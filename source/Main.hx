package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

import core.ToastCore;

//crash handler stuff
#if CRASH_HANDLER
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import Discord.DiscordClient;
import sys.FileSystem;
import sys.io.File;
#end

#if desktop
import ALSoftConfig;
#end

#if linux
import lime.graphics.Image;
#end

using StringTools;

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite
{
	public static var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).

	public static var fpsVar:FPS; // fps and memory thing
	public static var toast:ToastCore; // credits go to MAJigsaw77

	public static function main():Void
		Lib.current.addChild(new Main());

	public function new()
	{
		super();

		#if windows
		NativeUtil.enableDarkMode();
		#end

		FlxG.signals.preStateSwitch.add(() ->{
			#if cpp
			cpp.NativeGc.run(true);
			cpp.NativeGc.enable(true);
			#end
			FlxG.bitmap.dumpCache();
			FlxG.bitmap.clearUnused();

			openfl.system.System.gc();
		});

		FlxG.signals.postStateSwitch.add(() ->{
			#if cpp
			cpp.NativeGc.run(false);
			cpp.NativeGc.enable(false);
			#end
			openfl.system.System.gc();
		});
	
		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(gameWidth, gameHeight, TitleState, 60, 60, true, false));

		fpsVar = new FPS(10, 10, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null)
			fpsVar.visible = ClientPrefs.showFPS;

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if html5
		FlxG.autoPause = FlxG.mouse.visible = false;
		#end

		// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
		// very cool person for real they don't get enough credit for their work
		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (e) -> {
			var errMsg:String = "";
			var path:String;
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var dateNow:String = Date.now().toString();
	
			dateNow = dateNow.replace(" ", "_");
			dateNow = dateNow.replace(":", "'");
	
			path = "./crash/" + "VSJoalor64DX_" + dateNow + ".txt";
	
			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case FilePos(s, file, line, column):
						errMsg += file + " (line " + line + ")\n";
					default:
						Sys.println(stackItem);
				}
			}
	
			errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/Joalor64GH/VSJoalor64-DX/issues\n\n> Crash Handler written by: sqirra-rng";
	
			if (!FileSystem.exists("./crash/"))
				FileSystem.createDirectory("./crash/");
	
			File.saveContent(path, errMsg + "\n");
	
			Sys.println(errMsg);
			Sys.println("Crash dump saved in " + Path.normalize(path));
	
			Application.current.window.alert(errMsg, "Error!");
			DiscordClient.shutdown();
			Sys.exit(1);
		});
		#end

		toast = new ToastCore();
		addChild(toast);
	}
}