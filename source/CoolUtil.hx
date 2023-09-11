package;

import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
#if sys
import sys.FileSystem;
#end

using StringTools;

class CoolUtil
{
	inline public static function boundTo(value:Float, min:Float, max:Float):Float
		return Math.max(min, Math.min(max, value));

	inline public static function txtSplit(path:String)
	{
		return [for (i in LimeAssets.getText(path).trim().split('\n')) i.trim()];
	}

	inline public static function coolTextFile(path:String):Array<String> {
		return (Assets.exists(path)) ? [for (i in Assets.getText(path).trim().split('\n')) i.trim()] : [];
	}

	// this is actual source code from VS Null https://gamebanana.com/mods/447674
	// now outdated 😅
	public static inline function coolerTextFile(path:String, daString:String = ''):String
		return FileAssets.exists(path) ? daString = Assets.getText(path).trim() : '';

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substr(4);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}
	
	inline public static function listFromString(string:String):Array<String> {
		return string.trim().split('\n').map(str -> str.trim());
	}

	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	//uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void {
		precacheSoundFile(Paths.sound(sound, library));
	}

	public static function precacheMusic(sound:String, ?library:String = null):Void {
		precacheSoundFile(Paths.music(sound, library));
	}

	private static function precacheSoundFile(file:Dynamic):Void {
		if (Assets.exists(file, SOUND) || Assets.exists(file, MUSIC))
			Assets.getSound(file, true);
	}

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}

// there's a big difference between the two
typedef FileAssets = #if sys FileSystem; #else openfl.utils.Assets; #end