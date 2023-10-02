package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;

class BiosMenuState extends MusicBeatState 
{	
	var bg:FlxSprite;
    var imageSprite:FlxSprite;
	
    var imagePath:Array<String>;
    var charDesc:Array<String>;
    var charName:Array<String>;
	var bgColors:Array<String>;

	var curSelected:Int = -1;
    var currentIndex:Int = 0;

    var descriptionText:FlxText;
    var characterName:FlxText;

	var checker:FlxBackdrop;

	override function create() 
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Bios Menu", null);
		#end
		
		var background:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        background.setGraphicSize(Std.int(background.width * 1.2));
		background.color = 0xFF683FFD;
        background.screenCenter();
        add(background);

		#if (flixel_addons < "3.0.0")
		checker = new FlxBackdrop(Paths.image('grid'), 0.2, 0.2, true, true);
		#else
		checker = new FlxBackdrop(Paths.image('grid'));
		#end
        	checker.scrollFactor.set(0.07, 0);
        	add(checker);

		imagePath = ["biosMenu/characters/sample", "biosMenu/characters/sample", "biosMenu/characters/sample"];
        charDesc = ["This is a description text.", "This is a description text.", "This is a description text."];
        charName = ["Sample", "Name 2", "Name 3"];

		imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image("biosMenu/characters/sample"));
        add(imageSprite);

		characterName = new FlxText(630, 94, charName[currentIndex]);
        characterName.setFormat(Paths.font("vcr.ttf"), 96, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterName.antialiasing = true;
		characterName.borderSize = 4;
        add(characterName);

		descriptionText = new FlxText(630, 247, charDesc[currentIndex]);
        descriptionText.setFormat(Paths.font("vcr.ttf"), 34, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptionText.antialiasing = true;
		descriptionText.borderSize = 2.5;
        add(descriptionText);

		var arrows = new FlxSprite(218, 26).loadGraphic(Paths.image('biosMenu/arrows'));
		add(arrows);

		super.create();
	}

	override function update(elapsed:Float) 
	{	
		super.update(elapsed);

		checker.x -= 0.45;
		checker.y -= 0.16;

		if (controls.UI_UP_P) 
		{
			currentIndex--;
			if (currentIndex < 0)
			{
				currentIndex = imagePath.length - 1;
			}
			remove(imageSprite);
			imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image(imagePath[currentIndex]));
			add(imageSprite);
			descriptionText.text = charDesc[currentIndex];
			characterName.text = charName[currentIndex];
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else if (controls.UI_DOWN_P)
		{
			currentIndex++;
			if (currentIndex >= imagePath.length)
			{
				currentIndex = 0;
			}
			remove(imageSprite);
			imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image(imagePath[currentIndex]));
			add(imageSprite);
			descriptionText.text = charDesc[currentIndex];
			characterName.text = charName[currentIndex];  
			FlxG.sound.play(Paths.sound('scrollMenu'));    
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
	}
}