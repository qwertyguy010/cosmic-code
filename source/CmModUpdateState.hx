package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class CmModUpdateState extends MusicBeatState {

	public static var leftState:Bool = false;

	var updatedTxT:FlxText;

	override function create() {

		super.create();
		
		FlxG.save.data.seen = true;

		/*var updatebg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('update/outdatedbg'));
		updatebg.antialiasing = true;
		updatebg.screenCenter();
		add(updatebg);

		var outdateground:FlxSprite = new FlxSprite().loadGraphic(Paths.image('update/mybigbird'));
		outdateground.antialiasing = true;
		outdateground.screenCenter();
		add(outdateground);

		var cm:FlxSprite = new FlxSprite().loadGraphic(Paths.image('update/cm_lol'));
		cm.antialiasing = true;
		cm.screenCenter();
		add(cm);

		var thisthing:FlxSprite = new FlxSprite().loadGraphic(Paths.image('update/bord'));
		thisthing.antialiasing = true;
		thisthing.screenCenter();
		add(thisthing);*/

		var modneedstoupdatelol:FlxSprite = new FlxSprite().loadGraphic(Paths.image('update/NeedsToUpdate'));
		modneedstoupdatelol.antialiasing = true;
		modneedstoupdatelol.screenCenter();
		add(modneedstoupdatelol);

		updatedTxT = new FlxText(0, 0, FlxG.width,
			"HEY!! Before you play this mod.   \n
			PLEASE UPDATE IT TO 1.5! (" + MainMenuState.modVersion + "),\n
			THERE IS NEW STUFF INCLUDED" + TitleState.updateModVersion + "!\n
			PRESS ESC TO GO IGNORE THIS YOU GRANDPA.\n
			\n
			THANKS FOR PLAYING THIS MOD ANYWAYS!!",
			32);
		updatedTxT.setFormat("Delfino", 32, FlxColor.WHITE, CENTER);
		updatedTxT.screenCenter(Y);
		add(updatedTxT);
	}

	override function update(elapsed:Float) {
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com");
				// i think the reason why i put the "//" because idk what to do with those 2 links on the bottom
				// Shit i don't know what to do here with the link.
			    //CoolUtil.browserLoad("https://gamebanana.com/mods/71223");
			    //CoolUtil.browserLoad("https://gamebanana.com/wips/71223");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(updatedTxT, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}

		super.update(elapsed);

	}
}
