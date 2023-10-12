package;

#if sys
import sys.FileSystem;
#end

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import Conductor;

using StringTools;

typedef Song = {
    var name:String;
    var song:String;
    var disc:String;
    var bpm:Float;
    var col:FlxColor;
}

class MusicPlayerState extends MusicBeatState
{
    public var bg:FlxSprite;
    
    public var disc:FlxSprite;
    public var musplayer:FlxSprite;
    public var playerneedle:FlxSprite;

    public var songTxt:FlxText;
    public var lengthTxt:FlxText;

    // var loop:Bool = true;
    // var loaded:Bool = false;

    var curSelected:Int = 0;
    
    var songs:Array<Song> = [
        {name:"Test", song:"test", disc:"test", bpm:150, 0xFF00FFFE}
    ];

    override public function create()
    {
        openfl.system.System.gc();

        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        add(bg);
        
        musplayer = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/musplayer'));
        musplayer.screenCenter();
        musplayer.antialiasing = true;
        add(musplayer);
        disc = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/disc')); // default
        disc.setPosition(musplayer.x + 268, musplayer.y + 13);
        disc.antialiasing = true;
        disc.angularVelocity = 30;
        add(disc);
        playerneedle = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/playerneedle'));
        playerneedle.screenCenter();
        playerneedle.antialiasing = true;
        add(playerneedle);

        songTxt = new FlxText(0, 0, 0, 'Test', 72);
        songTxt.screenCenter(X);
        songTxt.scrollFactor.set();
		songTxt.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(songTxt);

        lengthTxt = new FlxText(0, musplayer.y - 30, 0, 'placeholder', 12);
        lengthTxt.scrollFactor.set();
        lengthTxt.screenCenter();
		lengthTxt.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(lengthTxt);

        // changeSong();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        /*if (controls.UI_LEFT_P || controls.UI_RIGHT_P) 
        {
            FlxG.sound.play(Paths.sound('switchbtn'));
	    changeSong(controls.UI_LEFT_P ? -1 : 1);
        }*/

        if (controls.BACK) 
        {
            MusicBeatState.switchState(new MainMenuState());
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
        }

        /*if(FlxG.sound.music != null)
        {
            Conductor.songPosition = FlxG.sound.music.time;
            if (controls.ACCEPT && loaded)
            {
                FlxG.sound.play(Paths.sound('playbtn'));
                if(!FlxG.sound.music.playing)
                {
                    FlxG.sound.music.play();
                }
                else
                {
                    FlxG.sound.music.pause();
                }  
            }   
        }*/

        if (FlxG.keys.justPressed.R) 
        {
            MusicBeatState.resetState();
        }

        /*if (FlxG.keys.justPressed.L) 
        {
            loop = (!loop) ? false : true;
        }*/

        if (FlxG.keys.justPressed.Y)
        {
            // placeholder link until the actual ost comes out
			CoolUtil.browserLoad('https://www.youtube.com/playlist?list=PLxj2uzHFxP2Z4LZymCMwCDqEe3OsX1poD');
        }
    }

    /*static var loadedSongs:Array<String> = [];
    function changeSong(change:Int = 0)
    {
        loaded = false;
        
        if(FlxG.sound.music != null) 
            FlxG.sound.music.stop();

        lengthTxt.text = "Loading song...";

        curSelected += change;
        if(curSelected >= songs.length)
            curSelected = 0;
        else if(curSelected < 0)
            curSelected = songs.length - 1;

        if(FileSystem.exists(Paths.image('radio/discs/${songs[curSelected].disc}'))) 
        {
            disc.loadGraphic(Paths.image('radio/discs/${songs[curSelected].disc}'));
        }
        else 
        {
	    trace('ohno its dont exist');
        }

        songTxt.text = '< ${songs[curSelected].name} >';

        Conductor.changeBPM(songs[curSelected].bpm);
       
        var songName:String = songs[curSelected].song == null ? songs[curSelected].name.toLowerCase() : songs[curSelected].song;

        if(!loadedSongs.contains(songName))
        {
            loadedSongs.push(songName);
            FlxG.sound.playMusic(Paths.music(songName), 1, loop);
            FlxG.sound.music.pause();
        }
        else
        {
            FlxG.sound.playMusic(Paths.music(songName), 1, loop);
            FlxG.sound.music.pause();
        }

        loaded = true;

        var seconds:String = '' + Std.int(FlxG.sound.music.length / 1000) % 60;
        if(seconds.length == 1) 
            seconds = '0' + seconds;

        lengthTxt.text = 'Song Length: ${Std.int(FlxG.sound.music.length / 1000 / 60)}:$seconds';
    }*/
}