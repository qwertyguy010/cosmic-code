package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{	
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var modVersion:String = '1.0';//ModVersion + Discord RPC
	public static var curSelected:Int = 0;

	var BACKSPACE = 8;

	var cmMenu:BGSprite;
	var funnyBoxArt:BGSprite;
	var ytpMenu:BGSprite;
	var menuYM:BGSprite;
	var bfMenu:BGSprite;
	var oldCmMenu:BGSprite;
	var malkeMenu:BGSprite;

	var bordthingy:FlxTypedGroup<FlxSprite>;
	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		#if !switch 'old', #end
		'options'
	];

	var blu:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		blu = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		blu.scrollFactor.set(0, yScroll);
		blu.setGraphicSize(Std.int(blu.width * 1.175));
		blu.updateHitbox();
		blu.screenCenter();
		blu.visible = false;
		blu.antialiasing = ClientPrefs.globalAntialiasing;
		blu.color = 0xff0400ff;
		add(blu);
		
		// blu.scrollFactor.set();

		bordthingy = new FlxTypedGroup<FlxSprite>();
		add(bordthingy);
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		cmMenu = new BGSprite('menuCM', 3, 62, 0.0, 0.0, ['menu CM idle'], true); // scroll factor cuz yes.
		cmMenu.cameras = [camGame];
		cmMenu.setGraphicSize(Std.int(cmMenu.width * 0.9));
		cmMenu.antialiasing = ClientPrefs.globalAntialiasing;
		add(cmMenu);
		cmMenu.visible = true;
		funnyBoxArt = new BGSprite('boxartassets', 55, 60, 0.0, 0.0, ['box art dancing'], true); // scroll factor cuz why not.
		// LOOK IS THE FUCKING OLD LOGO ON THE SPRITE :RAGE:
		funnyBoxArt.cameras = [camGame];
		funnyBoxArt.antialiasing = ClientPrefs.globalAntialiasing;
		add(funnyBoxArt);
		funnyBoxArt.visible = false;
		ytpMenu = new BGSprite('menuYTPSMAL', 13, 69, 0.0, 0.0, ['menu Ytp idle'], true);
		ytpMenu.cameras = [camGame];
		ytpMenu.flipX = true;
		ytpMenu.antialiasing = ClientPrefs.globalAntialiasing;
		add(ytpMenu);
		ytpMenu.visible = false;
		menuYM = new BGSprite('menuYM', -3, 88, 0.0, 0.0, ['menu YM idle'], true);
		menuYM.flipX = true;
		menuYM.cameras = [camGame];
		menuYM.setGraphicSize(Std.int(cmMenu.width * 0.9));
		menuYM.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuYM);
		menuYM.visible = false;
		bfMenu = new BGSprite('menuBF', -3, 88, 0.0, 0.0, ['menu BF idle dance'], true);
		bfMenu.cameras = [camGame];
		bfMenu.setGraphicSize(Std.int(cmMenu.width * 0.9));
		bfMenu.flipX = true;
		bfMenu.antialiasing = ClientPrefs.globalAntialiasing;
		add(bfMenu);
		bfMenu.visible = false;
		oldCmMenu = new BGSprite('menuOLDCm', 55, 70, 0.0, 0.0, ['menu OLDCM idle'], true);
		oldCmMenu.cameras = [camGame];
		oldCmMenu.setGraphicSize(Std.int(oldCmMenu.width * 1.1));
		oldCmMenu.antialiasing = ClientPrefs.globalAntialiasing;
		add(oldCmMenu);
		oldCmMenu.visible = false;
		malkeMenu = new BGSprite('menuMALKE', 18, 69, 0.0, 0.0, ['menu MALKE idle'], true);
		malkeMenu.cameras = [camGame];
		malkeMenu.setGraphicSize(Std.int(malkeMenu.width * 2.2));
		malkeMenu.antialiasing = ClientPrefs.globalAntialiasing;
		add(malkeMenu);
		malkeMenu.visible = false;

		for (i in 0...optionShit.length)
		{
			var bord:BGSprite = new BGSprite('menuBorder', -161, -606, 0.0, 0.135);
			bord.cameras = [camGame];
			bord.antialiasing = ClientPrefs.globalAntialiasing;
			bord.alpha = 0.50;
			bordthingy.add(bord);
			// This group menu border is fucking uhhhhh...cool i guess because is cool
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 150)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			// No.
			//menuItem.screenCenter(X);
			menuItem.x += 565;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "VS. Cosmic Mario v" + modVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (optionShit[curSelected] == 'story_mode') {
			changeItem(-1);
			changeItem(1);

			cmMenu.dance();
			cmMenu.updateHitbox();
			cmMenu.visible = true;
		}
		else {
			cmMenu.visible = false;
		}
		if (optionShit[curSelected] == 'freeplay') {
			changeItem(-1);
			changeItem(1);

			// Oopsey Old Mod Logo
			
			funnyBoxArt.dance();
			funnyBoxArt.updateHitbox();
			funnyBoxArt.visible = true;
		}
		else {
			funnyBoxArt.visible = false;
		}
		if (optionShit[curSelected] == 'awards'){
			changeItem(-1);
			changeItem(1);

			ytpMenu.dance();
			ytpMenu.updateHitbox();
			ytpMenu.visible = true;
		}
		else{
			ytpMenu.visible = false;
		}
		if (optionShit[curSelected] == 'credits'){
			changeItem(-1);
			changeItem(1);

			menuYM.dance();
			menuYM.updateHitbox();
			menuYM.visible = true;
		}
		else {
			menuYM.visible = false;
		}
		if (optionShit[curSelected] == 'donate') {
			changeItem(-1);
			changeItem(1);

			bfMenu.dance();
			bfMenu.updateHitbox();
			bfMenu.visible = true;
		}
		else {
			bfMenu.visible = false;
		}
		if (optionShit[curSelected] == 'old'){
			changeItem(-1);
			changeItem(1);

			oldCmMenu.dance();
			oldCmMenu.updateHitbox();
			oldCmMenu.visible = true;
		}
		else {
			oldCmMenu.visible = false;
		}
		if (optionShit[curSelected] == 'options'){
			changeItem(-1);
			changeItem(1);

			malkeMenu.dance();
			malkeMenu.updateHitbox();
			malkeMenu.visible = true;
		}
		else{
			malkeMenu.visible = false;
		}

		//LOOK THE SELECT MENU BUTTONS ARE STATIC :SOB:


		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				if (optionShit[curSelected] == 'old')
				{
					CoolUtil.browserLoad('https://gamebanana.com/mods/download/337769#FileInfo_697418');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(blu, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									/**
									case 'donate':
									**/
									/**
									case 'old':
									**/
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}

			if (FlxG.keys.justPressed.FIVE)
			{
				FlxG.switchState(new ErrorState());
				return;
			}

			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//no spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
