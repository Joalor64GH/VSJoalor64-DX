package;

import lime.app.Application;

class ScaryState extends FlxState
{
    	var daText:FlxText;
		var triedToLeave:Bool = false;

	override function create()
    	{
        	var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        	add(bg);

        	daText = new FlxText(4, FlxG.height - 24, 0, 'An exception occurred. Please close the software and report this error.', 12);
		daText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        	daText.screenCenter(XY);
		add(daText);

        	super.create();
    	}

    	override function update(elapsed:Float)
    	{
        	if (FlxG.keys.justPressed.ESCAPE)
        	{
				triedToLeave = true;
            		FlxG.sound.play(Paths.sound('JUMPSCARE'));

            		new FlxTimer().start(3.9, (tmr:FlxTimer) -> 
		    	{
					#if sys
			    Sys.exit(0);
				#else
				openfl.system.System.exit(0);
				#end
		    	});
        	}

			if (triedToLeave) 
			{
				Application.current.window.title = randomString();
            	daText.text = randomString();
			}

        	super.update(elapsed);
    	}

    	static inline var upperCase:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	static inline var lowerCase:String = "abcdefghijklmnopqrstuvwxyz";
	static inline var numbers:String = "0123456789";
	static inline var symbols:String = "!@#$%&()*+-,./:;<=>?^[]{}";

	inline public static function randomString() 
	{
		var str = "";
			for (e in [upperCase, lowerCase, numbers, symbols])
				str += e.charAt(FlxG.random.int(0, e.length - 1));

		return str;
	}
}