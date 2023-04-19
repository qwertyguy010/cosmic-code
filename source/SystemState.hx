package;

import flixel.*;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxMath;
import flash.system.System;
import lime.utils.Assets;
import meta.state.PlayState;
#if sys
import sys.FileSystem;
#end

using StringTools;

class SystemState extends FlxState
{
	override public function create()
	{
		System.exit(0);
		#if linux
		System.command('/usr/bin/xdg-open', [site]);
		#end
	}
}
