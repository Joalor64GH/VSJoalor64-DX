package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class BruhState extends MusicBeatState
{
	override function create()
    	{
        	var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        	add(bg);

        	var no:Alphabet = new Alphabet(0, 200, 'You can unlock this in-game.', true, false);
		no.screenCenter();
		add(no);

        	var versionTxt:FlxText = new FlxText(4, FlxG.height - 24, 0, 'Search through the files...', 12);
		versionTxt.scrollFactor.set();
		versionTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionTxt);

        	new FlxTimer().start(10, (tmr:FlxTimer) -> 
		{
			TitleState.initialized = false;
            		TitleState.closedState = false;
            		FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
		});

        	super.create();
    	}
}
