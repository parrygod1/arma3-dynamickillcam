class CfgPatches
{
	class ner_antiwallglitch
	{
		projectName="ner_antiwallglitch";
		author="Nerexis";
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
	class ner_antiwallglitch
	{
		type = "mod";
	};
};

class CfgFunctions {
    class ner_antiwallglitch {
        class main {
            file = "ner_antiwallglitch\bootstrap";
            class preInit {
                preInit = 1;
            };
        };
    };
};

class Extended_PreInit_EventHandlers {
    class ner_antiwallglitch_preInit_event {
        init = "call compile preprocessFileLineNumbers 'ner_antiwallglitch\XEH_preInit.sqf';";
    };
};

class Extended_Init_EventHandlers {
    class Man {
        class ner_antiwallglitch_init_unit_event {
            init = "diag_log 'ner_antiwallglitch_init_unit_event called'; _this call NER_antiWallGlitch_initUnitEH;";
        };
    };
};