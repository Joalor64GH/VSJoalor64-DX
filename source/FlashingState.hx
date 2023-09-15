package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var bg:FlxSprite;

	override function create() 
	{
		super.create();

		bg = new FlxSprite().loadGraphic(Paths.image('warning'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
	}

	override function update(elapsed:Float) 
	{
		if (!leftState)	
		{
			if (FlxG.keys.justPressed.ESCAPE) 
			{
				ClientPrefs.flashing = false;
				ClientPrefs.saveSettings();
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(bg, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new TitleState());
					}
				});
				leftState = true;
			} 
			else if (FlxG.keys.justPressed.ENTER) 
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(bg, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new TitleState());
					}
				});
				leftState = true;
			}
		}
		super.update(elapsed);
	}
}