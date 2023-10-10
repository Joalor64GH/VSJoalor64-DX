package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.text.FlxText;

class SaveFileState extends MusicBeatState
{
	public static var coolColors:Array<FlxColor> = [
		0xFFFFFFFF, // White
		0xFF808080, // Gray
		0xFF008000, // Green
		0xFF00FF00, // Lime
		0xFFFFFF00, // Yellow
		0xFFFFA500, // Orange
		0xFFFF0000, // Red
		0xFF800080, // Purple
		0xFF0000FF, // Blue
		0xFF8B4513, // Brown
		0xFFFFC0CB, // Pink
		0xFFFF00FF, // Magenta
		0xFF00FFFF // Cyan
	];

    	public static var saveFile:FlxSave;

    	private var grpControls:FlxTypedGroup<Alphabet>;

    	var controlsStrings:Array<String> = [];

	var curSelected:Int = 0;
    	var savesCanDelete:Array<Int> = [];

	var deleteMode:Bool = false;
	var selectedSomething:Bool = false;
    	var emptySave:Array<Bool> = [true, true, true];

    	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	var menuBG:FlxSprite;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        	menuBG.color = randomizeColor();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		for (i in 0...3)
		{
			var save:FlxSave = new FlxSave();
			save.bind("CoolSaveFile" + Std.string(i), "saves");
			trace("Save File " + Std.string(i + 1));
			emptySave[i] = (!save.data.init || save.data.init == null);
			save.flush();
			controlsStrings.push("Save File " + Std.string(i + 1) + (!emptySave[i] ? "" : " Empty"));
		}

		controlsStrings.push("Erase Save");

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, 0, controlsStrings[i], true, false);
			controlLabel.screenCenter();
			controlLabel.y += (100 * (i - (controlsStrings.length / 2))) + 50;
			grpControls.add(controlLabel);
		}

		var versionTxt:FlxText = new FlxText(4, FlxG.height - 24, 0, 'Press R to reset all save files', 12);
		versionTxt.scrollFactor.set();
		versionTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionTxt);

        	selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

		FlxG.mouse.visible = true;

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selectedSomething)
		{
			if (controls.UI_UP_P || controls.UI_DOWN_P)
				changeSelection(controls.UI_UP_P ? -1 : 1);

			if (controls.ACCEPT)
			{
				FlxG.mouse.visible = false;
				if (curSelected != (grpControls.length - 1))
				{
					if (!deleteMode)
					{
						selectedSomething = true;

						FlxG.sound.play(Paths.sound('confirmMenu'));

						for (i in 0...grpControls.length)
						{
							var fuk:Alphabet = grpControls.members[i];
							if (curSelected != i)
							{
								fuk.alpha = 0;
							}
							else
							{
								if (ClientPrefs.flashing)
								{
									FlxFlicker.flicker(fuk, 1, 0.06, false, false, function(flick:FlxFlicker)
									{
										saveFile = new FlxSave();
										saveFile.bind("CoolSaveFile" + Std.string(curSelected), "saves");
										saveFile.data.init = true;
										saveFile.flush();
										Highscore.load();
										MusicBeatState.switchState(new MainMenuState());
									});
								}
								else
								{
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										saveFile = new FlxSave();
										saveFile.bind("CoolSaveFile" + Std.string(curSelected), "saves");
										saveFile.data.init = true;
										saveFile.flush();
										Highscore.load();
										MusicBeatState.switchState(new MainMenuState());
									});
								}
							}
						}
					}
					else
					{
						eraseSave(savesCanDelete[curSelected]);
					}
				}
				else
				{
					deleteMode = !deleteMode;
					if (deleteMode)
					{
						idkLol();
					}
					else
					{
						grpControls.clear();

						for (i in 0...controlsStrings.length)
						{
							var controlLabel:Alphabet = new Alphabet(0, 0, controlsStrings[i], true, false);
							controlLabel.screenCenter();
							controlLabel.y += (100 * (i - (controlsStrings.length / 2))) + 50;
							grpControls.add(controlLabel);
						}

						curSelected = 0;
						changeSelection(curSelected);
					}
				}
			}

			if (controls.RESET && !deleteMode) 
			{
				openSubState(new Prompt('This action will reset ALL of your save files.\nProceed anyways?', 0, function() {
					for (i in 0...3) {
						eraseSave(i);
					}
					FlxG.sound.play(Paths.sound('confirmMenu'));
				}, function() {
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}, false));
			}
		}
	}

	function eraseSave(id:Int)
	{
		// erase save file
		var save:FlxSave = new FlxSave();
		save.bind("CoolSaveFile" + Std.string(id), "saves");
		save.erase();

		// rebind to avoid issues
		trace("Erased Save File " + (id + 1));
		save.bind("CoolSaveFile" + Std.string(id), "saves");
		save.flush();

		save.data.songScores = 0;
        save.data.songRating = 0;
        save.data.weekScores = 0;

		save.data.passwordCorrect = false;
		save.data.bonusUnlock = false;
		save.data.stars = [false, false, false];

		emptySave[id] = true;
		controlsStrings[id] = "Save File " + Std.string(id + 1) + " Empty";
		idkLol();
	}

	function idkLol()
	{
		savesCanDelete = [];

		for (i in 0...grpControls.length)
		{
			if (i != 3)
			{
				if (!emptySave[i])
				{
					savesCanDelete.push(i);
				}
			}
		}

		grpControls.clear();

		var savesAvailable:Array<String> = [];

		for (i in 0...savesCanDelete.length)
		{
			savesAvailable.push("Save File " + Std.string(i + 1));
		}

		savesAvailable.push("Cancel");

		for (i in 0...savesAvailable.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, 0, savesAvailable[i], true, false);
			controlLabel.screenCenter();
			controlLabel.y += (100 * (i - (savesAvailable.length / 2))) + 50;
			grpControls.add(controlLabel);
		}

		changeSelection();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
                		selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
	}

	public static function randomizeColor()
    	{
		var chance:Int = FlxG.random.int(0, coolColors.length - 1);
		var color:FlxColor = coolColors[chance];
		return color;
    	}
}