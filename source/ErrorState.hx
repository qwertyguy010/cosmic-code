package;

import flixel.*;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;

using StringTools;

class ErrorState extends MusicBeatState
{
    private var camError:FlxCamera;
    
    var bg:FlxSprite;
    var menuBG:FlxSprite;
    var errBrdr:FlxSprite;
    var lining:FlxSprite;
    var errBg:FlxSprite;
    var board:FlxSprite;

    override function create()
    {
        camError = new FlxCamera();

        FlxG.sound.playMusic(Paths.music('slientMusic'), 0.0);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

		menuBG = new FlxSprite().loadGraphic(Paths.image('menuBG'));
        menuBG.screenCenter();
		menuBG.antialiasing = true;

        errBrdr = new FlxSprite().loadGraphic(Paths.image('menuBorder'));
        errBrdr.antialiasing = true;
        errBrdr.alpha = 0.50;

        lining = new FlxSprite().loadGraphic(Paths.image('line'));
        lining.screenCenter();
        lining.antialiasing = true;

        errBg = new FlxSprite().loadGraphic(Paths.image('errBG'));
        errBg.screenCenter();
        errBg.antialiasing = true;

        var board:FlxSprite = new FlxSprite();

        board = new FlxSprite().loadGraphic(Paths.image('errorlol'));
        board.frames = Paths.getSparrowAtlas('errorlol');
        board.animation.addByPrefix('boob', 'error pop up');
        board.animation.add('boob', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 12, false);
        board.animation.play('boob');
        board.screenCenter();
        board.antialiasing = true;

        add(bg);

        add(errBrdr);

        add(menuBG);

        add(lining);

        add(errBg);

        add(board);
    }
}
