package consts
{
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class Fonts
	{
		public static const
			LATO_REGULAR		: String 		= "Lato"
		,	LATO_BOLD			: String 		= "LatoBold"
		,	LATO_THIN			: String 		= "LatoThin"
		,	LATO_HEAVY			: String 		= "LatoHeavy"
		
		,	ROBOTO_CONDENSED	: String 		= "RobotoCondensedRegular"
		,	ROBOTO_REGULAR		: String 		= "RobotoRegular"
		,	ROBOTO_LIGHT		: String 		= "RobotoLight"
		,	ROBOTO_BOLD			: String 		= "RobotoBold"
		
		,	BF_LATO_REGULAR		: String 		= "LatoRegularBF"
		,	BF_LATO_HEAVY		: String 		= "LatoHeavyCharactersBF"
		,	BF_LATO_INDEXIES	: String 		= "LatoRegularIndexiesBF"
		;

		[Embed(source="../../assets/fonts/Lato/Lato-Light.ttf", 	embedAsCFF="false", fontFamily="LatoThin", fontStyle="normal", fontWeight = "normal", unicodeRange = "U+0020-U+0022, U+0026-U+0029, U+002c, U+002e-U+005a, U+0061-U+007a, U+0401, U+0410-U+044f, U+0451")]
		private static const LatoThin:Class;
		[Embed(source="../../assets/fonts/Lato/Lato-Regular.ttf", 	embedAsCFF="false", fontFamily="Lato", fontStyle="normal", fontWeight = "normal", unicodeRange = "U+0020-U+0022, U+0026-U+0029, U+002c, U+002e-U+005a, U+0061-U+007a, U+0401, U+0410-U+044f, U+0451")]
		private static const LatoRegular:Class;
		[Embed(source="../../assets/fonts/Lato/Lato-Bold.ttf", 	embedAsCFF="false", fontFamily="LatoBold", fontStyle="normal", fontWeight = "normal", unicodeRange = "U+0020-U+0022, U+0026-U+0029, U+002c, U+002e-U+005a, U+0061-U+007a, U+0401, U+0410-U+044f, U+0451")]
		private static const LatoBold:Class;
		[Embed(source="../../assets/fonts/Lato/Lato-Heavy.ttf", 	embedAsCFF="false", fontFamily="LatoHeavy", fontStyle="normal", fontWeight = "normal", unicodeRange = "U+0020-U+0022, U+0026-U+0029, U+002c, U+002e-U+005a, U+0061-U+007a, U+0401, U+0410-U+044f, U+0451")]
		private static const LatoBlack:Class;

		//[Embed(source="../../assets/fonts/Roboto/RobotoCondensed-Regular.ttf", 	embedAsCFF="false", fontFamily="RobotoCondensedRegular", fontStyle="normal", fontWeight = "normal")]//, unicodeRange = "U+0020-U+0022, U+0026-U+0029, U+002c, U+002e-U+005a, U+0061-U+007a, U+0401, U+0410-U+044f, U+0451")]
		//private static const RobotoCondensedRegular:Class;
		//[Embed(source="../../assets/fonts/Roboto/Roboto-Regular.ttf", 	embedAsCFF="false", fontFamily="RobotoRegular", fontStyle="normal", fontWeight = "normal")]//, unicodeRange = "U+0020-U+0022, U+0026-U+0029, U+002c, U+002e-U+005a, U+0061-U+007a, U+0401, U+0410-U+044f, U+0451")]
		//private static const RobotoRegular:Class;
		//[Embed(source="../../assets/fonts/Roboto/Roboto-Light.ttf", 	embedAsCFF="false", fontFamily="RobotoLight", fontStyle="normal", fontWeight = "normal")]//, unicodeRange = "U+0020-U+0022, U+0026-U+0029, U+002c, U+002e-U+005a, U+0061-U+007a, U+0401, U+0410-U+044f, U+0451")]
		//private static const RobotoLight:Class;
		//[Embed(source="../../assets/fonts/Roboto/Roboto-Bold.ttf", 	embedAsCFF="false", fontFamily="RobotoBold", fontStyle="normal", fontWeight = "normal")]//, unicodeRange = "U+0020-U+0022, U+0026-U+0029, U+002c, U+002e-U+005a, U+0061-U+007a, U+0401, U+0410-U+044f, U+0451")]
		//private static const RobotoBold:Class;

		[Embed(source = "../../assets/fonts/BitmapFonts/LatoRegularIndexiesBF.xml", mimeType = "application/octet-stream")]
		public static const LatoRegularIndexiesXML:Class;
		[Embed(source="../../assets/fonts/BitmapFonts/LatoRegularIndexiesBF.png")]
		public static const LatoRegularIndexiesAtlass:Class;

		[Embed(source = "../../assets/fonts/BitmapFonts/LatoRegularBF.fnt", mimeType = "application/octet-stream")]
		public static const LatoRegularXML:Class;
		[Embed(source="../../assets/fonts/BitmapFonts/LatoRegularBF.png")]
		public static const LatoRegularAtlass:Class;

		[Embed(source = "../../assets/fonts/BitmapFonts/LatoHeavyCharactersBF.fnt", mimeType = "application/octet-stream")]
		public static const LatoHeavyCharactersXML:Class;
		[Embed(source="../../assets/fonts/BitmapFonts/LatoHeavyCharactersBF.png")]
		public static const LatoHeavyCharactersAtlass:Class;

		public static function init():void {
			//var BFTexture:Texture = Texture.fromBitmap(new LatoRegularIndexiesAtlass());
			//var BFDescriptor:XML = XML(new LatoRegularIndexiesXML());
			//var bitmapFont:BitmapFont = new BitmapFont(BFTexture, BFDescriptor);
			//TextField.registerBitmapFont(bitmapFont);
//
			//BFTexture = Texture.fromBitmap(new LatoRegularAtlass());
			//BFDescriptor = XML(new LatoRegularXML());
			//bitmapFont = new BitmapFont(BFTexture, BFDescriptor);
			//TextField.registerBitmapFont(bitmapFont);
//
			//BFTexture = Texture.fromBitmap(new LatoHeavyCharactersAtlass());
			//BFDescriptor = XML(new LatoHeavyCharactersXML());
			//bitmapFont = new BitmapFont(BFTexture, BFDescriptor);
			//TextField.registerBitmapFont(bitmapFont);

			TextField.updateEmbeddedFonts();
		}
	}
}
