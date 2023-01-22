class CfgPatches
{
	class par_dynamickillcam
	{
		projectName="par_dynamickillcam";
		author="parrygod";
		units[] = {};
		weapons[] = {};
		version="0.1";
		requiredVersion = 2.0;
		requiredAddons[] = {
			"cba_xeh"
		};
	};
};

class CfgMods
{
	class par_dynamickillcam
	{
		type = "mod";
	};
};

class Extended_PreInit_EventHandlers
{
	class par_dynamickillcam
	{
		init = "call compile preProcessFileLineNumbers '\par_dynamickillcam\XEH_preInit.sqf'";
	};
};

class CfgFunctions {
    class par_dynamickillcam {
		class main {
			class killcam {
				file = "par_dynamickillcam\functions\fn_killcam.sqf";
				postInit = 1;
			};
		};
    };
};

class CfgSounds
{
	sounds[] = {};
	
	class par_dynamickillcam_slow1 {
		name = "par_dynamickillcam_slow1";
		sound[] = {"\par_dynamickillcam\sound\slow1.ogg", 2,1};
		titles[] = {};
	};
	class par_dynamickillcam_slow2 {
		name = "par_dynamickillcam_slow2";
		sound[] = {"\par_dynamickillcam\sound\slow2.ogg", 1.5,1};
		titles[] = {};
	};
	class par_dynamickillcam_slow3 {
		name = "par_dynamickillcam_slow3";
		sound[] = {"\par_dynamickillcam\sound\slow3.ogg", 2,1};
		titles[] = {};
	};
};