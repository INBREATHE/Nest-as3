package
{
import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.ui.Keyboard;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import app.controller.commands.ReadyCommand;
import app.controller.commands.StartupCommand;

import consts.Colors;
import consts.Defaults;
import consts.Fonts;

import nest.entities.application.Application;
import nest.entities.application.ApplicationFacade;

import starling.core.Starling;

[SWF(frameRate="60")]
public class Main extends Sprite
{
    static public var root:Sprite;
    static private var console:TextField;

    private const ROOT_CREATED:String = "rootCreated";
    private var _splash:Splash;

    //==================================================================================================
    public static function log(message:String):void { if(console) console.text = "\n> " + message + console.text; }
    public function Main() { if(this.stage) Init(null); else this.addEventListener(Event.ADDED_TO_STAGE, Init); }
    //==================================================================================================

    //==================================================================================================
    private function SetupConsole():void {
    //==================================================================================================
        console = new TextField();
        console.textColor = 0xff0000;
        console.width = 1280;
        console.height = 720;
        stage.addChild(console);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, function (e:KeyboardEvent):void
        {
            switch (e.keyCode)
            {
                case Keyboard.C:
                    console.text = "";
                    break;
            }
        });
        log("Console Initialized");
    }

    //==================================================================================================
    private function Init(e:Event):void {
    //==================================================================================================
        if(this.hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, Init);

        Main.root = this;

        SetupStage();
//        SetupSplash();
//        SetupConsole();
        SetupStarling();
    }

    //==================================================================================================
    private function SetupStage():void {
    //==================================================================================================
        Multitouch.inputMode 	= MultitouchInputMode.TOUCH_POINT;
        stage.align 			= StageAlign.TOP_LEFT;
        stage.scaleMode 		= StageScaleMode.NO_SCALE;
        stage.autoOrients 		= true;
        stage.color				= 0xfcfcfc;
        stage.displayState		= StageDisplayState.FULL_SCREEN;
        stage.quality			= StageQuality.HIGH;
        stage.addEventListener(Event.DEACTIVATE, HandlerDeactivate);

        NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
        NativeApplication.nativeApplication.autoExit = true;
    }

    //==================================================================================================
    private function SetupSplash():void {
    //==================================================================================================
        _splash = new Splash(Colors.BLACK_23);
        _splash.x = 0;
        _splash.y = 0;
    }

    /**
     * this function is called from PrepareCompleteCommand
     */
    //==================================================================================================
    public function hideSplash():void {
     //==================================================================================================
        if(_splash) _splash.hide();
    }

   //==================================================================================================
    public function showSplash():void {
    //==================================================================================================
        trace("showSplash");
        _splash && this.addChild(_splash);
    }

    //==================================================================================================
    private function SetupStarling():void {
    //==================================================================================================
        Starling.multitouchEnabled = true;
        const viewport:Rectangle = new Rectangle(0,0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
        const starling:Starling = new Starling(Application, stage, viewport);

		Application.SCREEN_WIDTH = Defaults.DEFAULT_WIDTH;
		Application.SCREEN_HEIGHT = Defaults.DEFAULT_HEIGHT;
		
        starling.enableErrorChecking = false;
        starling.antiAliasing = 8;
        starling.skipUnchangedFrames = false;
        starling.simulateMultitouch = false;

        starling.stage.stageWidth = viewport.width;
        starling.stage.stageHeight = viewport.height;
        Starling.current.addEventListener(ROOT_CREATED, StartApplication);
        starling.start();

        //showSplash();
    }

    //==================================================================================================
    private function StartApplication():void {
    //==================================================================================================
        trace("StartApplication");
        const strlng:Starling = Starling.current;
		strlng.removeEventListener(ROOT_CREATED, StartApplication);
//		strlng.showStats = true;
		
        Fonts.init();

        const applicationFacade:ApplicationFacade = ApplicationFacade.getInstance();
        applicationFacade.registerCountCommand( ApplicationFacade.STARTUP, StartupCommand, 1 );
        applicationFacade.registerCountCommand( ApplicationFacade.READY, ReadyCommand, 1 );
        applicationFacade.startup(this);
    }

    //==================================================================================================
    private function HandlerDeactivate(e:Event):void {
    //==================================================================================================

    }
}
}