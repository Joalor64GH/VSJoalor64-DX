package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;

import Password;
import PlayState;

using StringTools;

/*
 * Mostly copied from MinigamesState.hx
 * @author Joalor64GH
 * @see https://github.com/Joalor64GH/Joalor64-Engine-Rewrite/blob/main/source/meta/state/MinigamesState.hx
 */
class FreeplayState extends MusicBeatState 
{
    	private var grpControls:FlxTypedGroup<Alphabet>;
		
        private var iconArray:Array<HealthIcon> = [];

	public var controlStrings:Array<CoolSong> = [ // these songs will be remastered!!
		new CoolSong('Tutorial', 'How to play the game.', 'gf', '911444'),
		new CoolSong('Code and Stuff', 'Hello.', 'memphis', '00f2ff'),
		new CoolSong('Imagination', 'This song could be better.', 'memphis', '00f2ff'),
		new CoolSong('The Finale', 'bang bang', 'memphis', '00f2ff'),
		new CoolSong('Klassicheskiy Ritm', 'Bounds round', 'circle', '0004ff'), // and i'll add some for him :)
		/*
		new CoolSong('Circle Song 2', 'description', 'circle', '0004ff'),
		new CoolSong('Circle Song 3', 'description', 'circle', '0004ff'),
		*/
		new CoolSong('Test', 'quick test song idk', 'bf-pixel', '59d0ff')
	];
	
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	var scoreText:FlxText;
	var descTxt:FlxText;

	var menuBG:FlxSprite;

	var checker:FlxBackdrop;

	var intendedColor:FlxColor;
	var colorTween:FlxTween;

    	var curSelected:Int = 0;

    	override function create()
	{
		// this is for testing!!
		/*
		if (SaveFileState.saveFile.data.bonusUnlock)
		{
			controlStrings.push(new CoolSong('Bonus 1', 'Hello World', 'face', 'adadad'));
			controlStrings.push(new CoolSong('Bonus 2', 'Hello World', 'face', 'adadad'));
			controlStrings.push(new CoolSong('Bonus 3', 'Hello World', 'face', 'adadad'));
			if (SaveFileState.saveFile.data.passwordCorrect)
			{
				controlStrings.push(new CoolSong('Bonus 4', 'Hello World', 'face', 'adadad'));
			}
			else
			{
				controlStrings.push(new CoolSong('???', 'This song requires a password!', 'face', 'adadad'));
			}
		}
		*/
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        	menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		#if (flixel_addons < "3.0.0")
		checker = new FlxBackdrop(Paths.image('grid'), 0.2, 0.2, true, true);
		#else
		checker = new FlxBackdrop(Paths.image('grid'));
		#end
        	checker.scrollFactor.set(0.07, 0);
        	add(checker);

        	var slash:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/slash'));
		slash.antialiasing = ClientPrefs.globalAntialiasing;
		slash.screenCenter();
		add(slash);

        	grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlStrings[i].name, true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i - curSelected;
			grpControls.add(controlLabel);

			if (controlLabel.width > 980)
				controlLabel.scale.x = 980 / controlLabel.width;

            		var icon:HealthIcon = new HealthIcon(controlStrings[i].icon);
			icon.sprTracker = controlLabel;
			icon.updateHitbox();
			iconArray.push(icon);
			add(icon);
		}
        
        	var bottomPanel:FlxSprite = new FlxSprite(0, FlxG.height - 100).makeGraphic(FlxG.width, 100, 0xFF000000);
		bottomPanel.alpha = 0.5;
		add(bottomPanel);

        	scoreText = new FlxText(20, FlxG.height - 80, 1000, "", 22);
		scoreText.setFormat("VCR OSD Mono", 30, 0xFFffffff, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreText.scrollFactor.set();
        	scoreText.screenCenter(X);
        	add(scoreText);

        	descTxt = new FlxText(scoreText.x, scoreText.y + 36, 1000, "", 22);
        	descTxt.screenCenter(X);
		descTxt.scrollFactor.set();
		descTxt.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(descTxt);

		var topPanel:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 26, FlxColor.BLACK);
		topPanel.scrollFactor.set();
		topPanel.alpha = 0.6;
		add(topPanel);

		var controlsTxt:FlxText = new FlxText(topPanel.x, topPanel.y + 4, FlxG.width, "R - RESET SCORE // CTRL - GAMEPLAY CHANGERS", 32);
		controlsTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		controlsTxt.screenCenter(X);
		controlsTxt.scrollFactor.set();
		add(controlsTxt);

		#if sys
		if (ClientPrefs.saveReplay)
			controlsTxt.text += " // ALT - REPLAYS";
		#end

		menuBG.color = CoolUtil.colorFromString(controlStrings[curSelected].color);
		intendedColor = menuBG.color;

		if(curSelected >= controlStrings.length) 
			curSelected = 0;
			
        	changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		checker.x -= 0.45;
		checker.y -= 0.16;

        	lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		
		if(ratingSplit.length < 2)
			ratingSplit.push('');
		while(ratingSplit[1].length < 2)
			ratingSplit[1] += '0';

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';

        	if (controls.UI_UP_P || controls.UI_DOWN_P)
			changeSelection(controls.UI_UP_P ? -1 : 1);

		if (controls.BACK) 
        	{
			if(colorTween != null) 
			{
				colorTween.cancel();
			}
                	FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
        	}
            
		if (controls.ACCEPT)
		{
			/*
			if (contolStrings[curSelected] == '???')
			{
				openSubState(new Password());
			}
			else
			{
			*/
			FlxG.sound.music.volume = 0;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			var lowercasePlz:String = Paths.formatToSongPath(controlStrings[curSelected].name);
			var formatIdfk:String = Highscore.formatSong(lowercasePlz);
			LoadingState.loadAndSwitchState(new PlayState());
			PlayState.SONG = Song.loadFromJson(formatIdfk, lowercasePlz);
			PlayState.isStoryMode = false;
			// }
		}

        	if (FlxG.keys.justPressed.CONTROL)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if (controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(controlStrings[curSelected].name, controlStrings[curSelected].icon));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		#if sys
		else if (FlxG.keys.justPressed.ALT && ClientPrefs.saveReplay)
		{
			MusicBeatState.switchState(new ReplaySelectState(Paths.formatToSongPath(controlStrings[curSelected].name)));
		}
		#end
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		descTxt.text = controlStrings[curSelected].description;

		var newColor:FlxColor = CoolUtil.colorFromString(controlStrings[curSelected].color);
		trace('The BG color is: $newColor');
		if(newColor != intendedColor) 
		{
			if(colorTween != null) 
			{
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(menuBG, 1, menuBG.color, intendedColor, 
			{
				onComplete: function(twn:FlxTween) 
				{
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

        	intendedScore = Highscore.getScore(controlStrings[curSelected].name);
		intendedRating = Highscore.getRating(controlStrings[curSelected].name);

		for (i in 0...iconArray.length)
			iconArray[i].alpha = 0.6;

		iconArray[curSelected].alpha = 1;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

class CoolSong
{
	public var name:String;
	public var description:String;
	public var icon:String;
	public var color:String;

	public function new(Name:String, dsc:String, img:String, col:String)
	{
		name = Name;
        	description = dsc;
        	icon = img;
		color = col;
	}
}