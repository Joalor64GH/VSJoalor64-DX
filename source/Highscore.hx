package;

import flixel.FlxG;

using StringTools;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	public static var songRating:Map<String, Float> = new Map();
	#else
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();
	#end

	public static function resetSong(song:String):Void
	{
		var daSong:String = formatSong(song);
		setScore(daSong, 0);
		setRating(daSong, 0);
	}

	public static function resetWeek(week:String):Void
	{
		var daWeek:String = formatSong(week);
		setWeekScore(daWeek, 0);
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
		{
			return Math.floor(value);
		}

		var tempMult:Float = 1;
		for (i in 0...decimals)
		{
			tempMult *= 10;
		}
		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	public static function saveScore(song:String, score:Int = 0, ?rating:Float = -1):Void
	{
		var daSong:String = formatSong(song);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score) {
				setScore(daSong, score);
				if(rating >= 0) setRating(daSong, rating);
			}
		}
		else {
			setScore(daSong, score);
			if(rating >= 0) setRating(daSong, rating);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0):Void
	{
		var daWeek:String = formatSong(week);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		SaveFileState.saveFile.data.songScores = songScores;
		SaveFileState.saveFile.flush();
	}
	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		SaveFileState.saveFile.data.weekScores = weekScores;
		SaveFileState.saveFile.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		SaveFileState.saveFile.data.songRating = songRating;
		SaveFileState.saveFile.flush();
	}

	public static function formatSong(song:String):String
	{
		return Paths.formatToSongPath(song);
	}

	public static function getScore(song:String):Int
	{
		var daSong:String = formatSong(song);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getRating(song:String):Float
	{
		var daSong:String = formatSong(song);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String):Int
	{
		var daWeek:String = formatSong(week);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	public static function load():Void
	{
		if (SaveFileState.saveFile.data.weekScores != null)
		{
			weekScores = SaveFileState.saveFile.data.weekScores;
		}
		if (SaveFileState.saveFile.data.songScores != null)
		{
			songScores = SaveFileState.saveFile.data.songScores;
		}
		if (SaveFileState.saveFile.data.songRating != null)
		{
			songRating = SaveFileState.saveFile.data.songRating;
		}
	}
}