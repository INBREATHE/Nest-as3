/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.injector
{
import flash.utils.Dictionary;
import flash.utils.describeType;

public final class Injector
{
	static private const INJECT:String = "Inject";

	static private const _targets	:Dictionary 	= new Dictionary();
	static private const _source	:Dictionary 	= new Dictionary();

	//==================================================================================================
	static public function mapSource( name:String, instance:Object ):void {
	//==================================================================================================
		_source[ name ] = instance;
	}

	//==================================================================================================
	static public function mapTarget( classRef:Class ):void {
	//==================================================================================================
		const decription	: XML = describeType(classRef);
		const variablesList	: XMLList = decription..variable as XMLList;
		const variables		: Vector.<InjectVar> = new Vector.<InjectVar>();
		var variableXML		: XML;
		var variableMETA	: XMLList;
		var variableINJECT	: Boolean = false;
		var variableType	: String;
		var variableName	: String;
		if(variablesList.length() > 0) {
			for each (variableXML in variablesList) {
				variableType = variableXML.@type;
				variableName = variableXML.@name;
				variableMETA = variableXML.metadata.(@name == INJECT);
				variableINJECT = variableMETA.length() > 0;
				if(variableINJECT || (_source[variableType])) {
					variables.push(new InjectVar(variableName, variableType));
				}
			}
			if(variables.length) {
				_targets[classRef] = variables;
			}
		}
	}

	//==================================================================================================
	static public function mapTargets( classes:Vector.<Class> ):void {
	//==================================================================================================
		var description		: XML;
		var variablesList	: XMLList;
		var variableXML		: XML;
		var variableMETA	: XMLList;
		var variableINJECT	: Boolean = false;
		var variableType	: String;
		var variableName	: String;
		var variables		: Vector.<InjectVar>;
		classes.forEach(function( classDef:Class, index:uint, vec:Vector.<Class> ):void {
			description = describeType( classDef );
			variablesList = description..variable as XMLList;
			if(variablesList.length() > 0) {
				variables = new Vector.<InjectVar>();
				for each (variableXML in variablesList) {
					variableType = variableXML.@type;
					variableName = variableXML.@name;
					variableMETA = variableXML..metadata.(@name == INJECT);
					variableINJECT = variableMETA != null && variableMETA.length() > 0;
					if(variableINJECT || (_source[ variableType ])) {
						variables.push(new InjectVar( variableName, variableType ));
					}
				}
				if(variables.length > 0) {
					_targets[ classDef ] = variables;
				}
			}
		});
		// SAME BUT SHORTER and more expensive
		// classes.forEach(function(clss:Class, index:uint, vec:Vector.<Class>):void { mapTarget(clss) });
	}

	static public function hasTarget( classRef:Class ):Boolean {
		return !(_targets[ classRef ] == null);
	}

	static public function injectTo( classRef:Class, object:Object ):void {
        const variables	: Vector.<InjectVar> = _targets[ classRef ];
        var counter 	: uint = variables.length;
        var variable	: InjectVar;
        while(counter-- > 0) {
            variable = variables[ counter ];
            object[ variable.name ] = _source[ variable.type ];
        }
	}

	public static function unmapTarget( clss:Class ):void {
		if(_targets[clss])
			delete _targets[clss];
	}

	public static function unmapSource( name:String ):void {
		if(_source[name])
			delete _source[name];
	}
}
}

internal final class InjectVar {
	private var _name:String = "";
	public function get name():String { return _name; }

	private var _type:String = "";
	public function get type():String { return _type; }

	public function InjectVar(name:String, type:String)
	{
		this._type = type;
		this._name = name;
	}
}