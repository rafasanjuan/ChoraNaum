/*******************************************************************************
#                                                                              #
# 		Gamemode: A/D Chora Naum                                               #
# 		Version: 2.0                                                           #
#                                                                              #
# 		(c) 2009, ultm.pwn, [MrS]Lake                                          #
#                                                                              #
*******************************************************************************/
/*~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
 INCLUDE: ultm_h.pwn
~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-*/

#include    <a_samp>
#include	<zcmd>
#include	<geoip>
#tryinclude <foreach>

AntiDeAMX()
{
    new a[ ][ ] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

#pragma tabsize 0

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Defines
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

#undef MAX_PLAYERS
#undef MAX_PLAYER_NAME
#undef MAX_VEHICLES

#define MAX_PLAYERS       13
#define MAX_PLAYER_NAME   21
#define MAX_VEHICLES      80
#define MAX_BASES         151
#define MAX_ARENAS        31
#define MAX_TDMS          31
#define MAX_DMS           31
#define MAX_TEAMS         3
#define MAX_WEAPONS       47
#define MAX_WEAPON_SLOT   13
#define MAX_FILE_STRING   128

#define HOME              0
#define AWAY              1
#define REF               2

#define ATTACKING         0
#define DEFENDING         1
#define REFEREEING        3

#define SPECTATE_NONE     0
#define SPECTATE_PLAYER   1
#define SPECTATE_VEHICLE  2

#define LOBBY            -1
#define DM                0
#define TDM               1
#define ARENA             2
#define BASE              3
#define LAST              4

#define SUB_COLOR      	0xCEAE97FF
#define GREY_COLOR  	0xB3B3B3FF
#define DUEL_COLOR     	0xFF9FFFFF
#define ERROR_COLOR    	0xFF6347FF //a
#define ADMIN_COLOR 	0xDFD50BFF //a
#define MAIN_COLOR1 	0x88B8D5FF
#define MAIN_COLOR2    	0x00B3FFFF //a
#define BUILD_COLOR1   	0xE066FFFF //a
#define BUILD_COLOR2   	0xFFFFFFFF

#define GM_NAME        	"Chora Naum 1.0 Beta"
#define TEMP_FILE       "ultimate/temp.ini"
#define INT_FILE      	"ultimate/ints.ini"
#define CONFIG_FILE    	"ultimate/config.ini"
#define NICKLOG_FILE   	"ultimate/nickLog.ini"

#define FINAL_AUDIO "http://api.ning.com/files/F52AlGXknZIWT0MfmBaJt*VbjgkNzoXW0Q1FQe8OyrEP*3W6EYe0DxWgLp2GJtuAQVjmu441dsajGaoiLLDYO3zIuATI-HJV/Paradise.mp3"

#define WEAPON_DIALOG1 100
#define WEAPON_DIALOG2 101
#define WEAPON_DIALOG3 102
#define CONFIG_DIALOG 103
#define LOCK_DIALOG 104

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Macros
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

//#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define InRange(%0,%1,%2,%3,%4,%5,%6) (((%0 - %3) * (%0 - %3)) + ((%1 - %4) * (%1 - %4)) +((%2 - %5) * (%2 - %5)) >= %6 * %6)

#if defined _foreach_included

	#define loopType 1

	#define loopPlayers(%1) \
		foreach(Player,%1)

#else

	#define loopType 0

	new highestID;

	#define	loopPlayers(%1) \
		for ( new %1; %1 < highestID; %1 ++ ) \
			if ( IsPlayerConnected( %1 ) )

	updateHighestID( )
	{
	   	new highest = -1;

		for ( new playerid = MAX_PLAYERS; playerid >= 0; playerid -- )
		{
			if ( IsPlayerConnected( playerid ) )
			{
				highest = playerid;
				break;
			}
		}
		return highest;
	}

#endif

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Constants Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

stock const badNames[ 22 ][ 5 ] =
{
	{ "nul"  }, { "aux"  }, { "prn"  }, { "con"  }, { "com1" }, { "com2" },
	{ "com3" }, { "com4" }, { "com5" }, { "com6" }, { "com7" }, { "com8" },
	{ "com9" }, { "ltp1" }, { "lpt2" }, { "lpt3" }, { "lpt4" }, { "lpt5" },
	{ "lpt6" }, { "lpt7" }, { "lpt8" }, { "lpt9" }
};

stock const setNames[ 5 ][ 32 ] =
{
	{ ""		},
	{ "Deagle"	},
	{ "Spas-12"	},
	{ "m4"		},
	{ "Sniper"	}
};

stock weaponNames( weapid )
{
	new gun[ 16 ];
	
	switch(weapid)
	{
	    case 0: gun = "Fist";
	    case 1: gun = "Brass";
	    case 2: gun = "Golf Club";
	    case 3: gun = "Stick";
	    case 4: gun = "Knife";
	    case 5: gun = "Bat";
	    case 6: gun = "Shovel";
	    case 7: gun = "Pool Cue";
	    case 8: gun = "Katana";
	    case 9: gun = "Chainsaw";
	    case 10..13: gun = "Dildo";
	    case 14: gun = "Flowers";
	    case 15: gun = "Cane";
	    case 16: gun = "Grenade";
	    case 17: gun = "Tear";
	    case 18: gun = "Molotov";
	    case 22: gun = "9mm";
	    case 23: gun = "Silenced";
	    case 24: gun = "Deagle";
	    case 25: gun = "Shotgun";
	    case 26: gun = "Sawnoff";
	    case 27: gun = "Spas12";
	    case 28: gun = "Uzi";
	    case 29: gun = "MP5";
	    case 30: gun = "AK-47";
	    case 31: gun = "m4";
	    case 32: gun = "tec9";
	    case 33: gun = "Rifle";
	    case 34: gun = "Sniper";
	    case 35: gun = "Rocket";
	    case 36: gun = "HS Rocket";
	    case 37: gun = "Flamethrower";
	    case 38: gun = "Minigun";
	    case 41: gun = "Spray";
	    case 42: gun = "Extinguisher";
	    case 49: gun = "Carkill";
	    case 50: gun = "Helikill";
	    case 51: gun = "Explosion";
	    case 52..300: gun = "Unknown";
	}
	return gun;
}

stock const carNames[ 212 ][ 18 ] =
{
	{ "Landstalker"       }, { "Bravura"           }, { "Buffalo"           }, { "Linerunner"        }, // 400, 401, 402, 403
	{ "Perrenial"         }, { "Sentinel"          }, { "Dumper"            }, { "Firetruck"         }, // 404, 405, 406, 407
	{ "Trashmaster"       }, { "Stretch"           }, { "Manana"            }, { "Infernus"          }, // 408, 409, 410, 411
	{ "Voodoo"            }, { "Pony"              }, { "Mule"              }, { "Cheetah"           }, // 412, 413, 414, 415
	{ "Ambulance"         }, { "Leviathan"         }, { "Moonbeam"          }, { "Esperanto"         }, // 416, 417, 418, 419
	{ "Taxi"              }, { "Washington"        }, { "Bobcat"            }, { "Mr Whoopee"        }, // 420, 421, 422, 423
	{ "BF Injection"      }, { "Hunter"            }, { "Premier"           }, { "Enforcer"          }, // 424, 425, 426, 427
	{ "Securicar"         }, { "Banshee"           }, { "Predator"          }, { "Bus"               }, // 428, 429, 430, 431
	{ "Rhino"             }, { "Barracks"          }, { "Hotknife"          }, { "Trailer 1"         }, // 432, 433, 434, 435
	{ "Previon"           }, { "Coach"             }, { "Cabbie"            }, { "Stallion"          }, // 436, 437, 438, 439
	{ "Rumpo"             }, { "RC Bandit"         }, { "Romero"            }, { "Packer"            }, // 440, 441, 442, 443
	{ "Monster"           }, { "Admiral"           }, { "Squalo"            }, { "Seasparrow"        }, // 444, 445, 446, 447
	{ "Pizzaboy"          }, { "Tram"              }, { "Trailer 2"         }, { "Turismo"           }, // 448, 449, 450, 451
	{ "Speeder"           }, { "Reefer"            }, { "Tropic"            }, { "Flatbed"           }, // 452, 453, 454, 455
	{ "Yankee"            }, { "Caddy"             }, { "Solair"            }, { "RC Van"            }, // 456, 457, 458, 459
	{ "Skimmer"           }, { "PCJ-600"           }, { "Faggio"            }, { "Freeway"           }, // 460, 461, 462, 463
	{ "RC Baron"          }, { "RC Raider"         }, { "Glendale"          }, { "Oceanic"           }, // 464, 465, 466, 467
	{ "Sanchez"           }, { "Sparrow"           }, { "Patriot"           }, { "Quad"              }, // 468, 469, 470, 471
	{ "Coastguard"        }, { "Dinghy"            }, { "Hermes"            }, { "Sabre"             }, // 472, 473, 474, 475
	{ "Rustler"           }, { "ZR-350"            }, { "Walton"            }, { "Regina"            }, // 476, 477, 478, 479
	{ "Comet"             }, { "BMX"               }, { "Burrito"           }, { "Camper"            }, // 480, 481, 482, 483
	{ "Marquis"           }, { "Baggage"           }, { "Dozer"             }, { "Maverick"          }, // 484, 485, 486, 487
	{ "News Chopper"      }, { "Rancher"           }, { "FBI Rancher"       }, { "Virgo"             }, // 488, 489, 490, 491
	{ "Greenwood"         }, { "Jetmax"            }, { "Hotring"           }, { "Sandking"          }, // 492, 493, 494, 495
	{ "Blista"            }, { "Police Maverick"   }, { "Boxville"          }, { "Benson"            }, // 496, 497, 498, 499
	{ "Mesa"              }, { "RC Goblin"         }, { "Hotring A"         }, { "Hotring B"         }, // 500, 501, 502, 503
	{ "Bloodring Banger"  }, { "Rancher"           }, { "Super GT"          }, { "Elegant"           }, // 504, 505, 506, 507
	{ "Journey"           }, { "Bike"              }, { "Mountain Bike"     }, { "Beagle"            }, // 508, 509, 510, 511
	{ "Cropdust"          }, { "Stuntplane"        }, { "Tanker"            }, { "Roadtrain"         }, // 512, 513, 514, 515
	{ "Nebula"            }, { "Majestic"          }, { "Buccaneer"         }, { "Shamal"            }, // 516, 517, 518, 519
	{ "Hydra"             }, { "FCR-900"           }, { "NRG-500"           }, { "HPV1000"           }, // 520, 521, 522, 523
	{ "Cement Truck"      }, { "Tow Truck"         }, { "Fortune"           }, { "Cadrona"           }, // 524, 525, 526, 527
	{ "FBI Truck"         }, { "Willard"           }, { "Forklift"          }, { "Tractor"           }, // 528, 529, 530, 531
	{ "Combine"           }, { "Feltzer"           }, { "Remington"         }, { "Slamvan"           }, // 532, 533, 534, 535
	{ "Blade"             }, { "Freight"           }, { "Streak"            }, { "Vortex"            }, // 536, 537, 538, 539
	{ "Vincent"           }, { "Bullet"            }, { "Clover"            }, { "Sadler"            }, // 540, 541, 542, 543
	{ "Firetruck LA"      }, { "Hustler"           }, { "Intruder"          }, { "Primo"             }, // 544, 545, 546, 547
	{ "Cargobob"          }, { "Tampa"             }, { "Sunrise"           }, { "Merit"             }, // 548, 549, 550, 551
	{ "Utility"           }, { "Nevada"            }, { "Yosemite"          }, { "Windsor"           }, // 552, 553, 554, 555
	{ "Monster"           }, { "Monster"           }, { "Uranus"            }, { "Jester"            }, // 556, 557, 558, 559
	{ "Sultan"            }, { "Stratum"           }, { "Elegy"             }, { "Raindance"         }, // 560, 561, 562, 563
	{ "RC Tiger"          }, { "Flash"             }, { "Tahoma"            }, { "Savanna"           }, // 564, 565, 566, 567
	{ "Bandito"           }, { "Freight Flat"      }, { "Streak Carriage"   }, { "Kart"              }, // 568, 569, 570, 571
	{ "Mower"             }, { "Duneride"          }, { "Sweeper"           }, { "Broadway"          }, // 572, 573, 574, 575
	{ "Tornado"           }, { "AT-400"            }, { "DFT-30"            }, { "Huntley"           }, // 576, 577, 578, 579
	{ "Stafford"          }, { "BF-400"            }, { "Newsvan"           }, { "Tug"               }, // 580, 581, 582, 583
	{ "Trailer 3"         }, { "Emperor"           }, { "Wayfarer"          }, { "Euros"             }, // 584, 585, 586, 587
	{ "Hotdog"            }, { "Club"              }, { "Freight Carriage"  }, { "Trailer 3"         }, // 588, 589, 590, 591
	{ "Andromada"         }, { "Dodo"              }, { "RC Cam"            }, { "Launch"            }, // 592, 593, 594, 595
	{ "Police LS"         }, { "Police SF"         }, { "Police LV"         }, { "Police Ranger"     }, // 596, 597, 598, 599
	{ "Picador"           }, { "S.W.A.T. Van"      }, { "Alpha"             }, { "Phoenix"           }, // 600, 601, 602, 603
	{ "Glendale"          }, { "Sadler"            }, { "Luggage Trailer A" }, { "Luggage Trailer B" }, // 604, 605, 606, 607
	{ "Stair Trailer"     }, { "Boxville"          }, { "Farm Plow"         }, { "Utility Trailer"   }  // 608, 609, 610, 611
};

stock const Float:saTeleports[ 10 ][ 4 ] =
{
	{ 000.000,   000.000,  00.00,  00.00 },	{ 2492.00,  -1666.00,  13.34,  90.00 },
	{ 522.000,  -1876.00,  3.642,  267.0 }, { 1686.00,  -1051.00,  23.91,  88.00 },
	{ -1325.0,  -206.000,  14.14,  315.0 }, { -2313.0,  182.0000,  35.31,  178.0 },
	{ -2630.0,  1377.000,  7.139,  181.0 }, { 2611.00,  1823.000,  10.82,  91.00 },
	{ 1615.00,  1620.000,  10.82,  211.0 }, { 1430.00,  2850.000,  10.82,  269.0 }
};

stock const Float:duelObjects[ 38 ][ 7 ] =
{
	{8417.0, 2602.09, -1677.90, 564.50, 0.0, 0.0, 354.00},
	{8417.0, 2622.70, -1678.50, 554.90, 0.0, 90.0, 353.99},
	{8417.0, 2583.20, -1676.50, 554.90, 0.0, 270.0, 355.99},
	{8417.0, 2587.30, -1657.40, 554.90, 0.0, 90.0, 87.99},
	{8417.0, 2623.80, -1659.30, 554.90, 0.0, 90.0, 85.99},
	{8417.0, 2585.10, -1693.40, 554.90, 0.0, 90.0, 83.99},
	{8417.0, 2620.70, -1697.20, 554.90, 0.0, 90.0, 83.99},
	{8417.0, 2603.10, -1677.60, 544.50, 0.0, 180.0, 357.99},
	{7017.0, 2611.89, -1658.90, 544.50, 0.0, 0.0, 358.00},
	{7017.0, 2611.89, -1658.90, 549.80, 0.0, 0.0, 357.99},
	{2960.0, 2599.90, -1658.00, 559.80, 0.0, 0.0, 0.00},
	{2960.0, 2600.20, -1658.00, 557.30, 0.0, 90.0, 2.00},
	{2960.0, 2602.19, -1658.00, 556.10, 0.0, 90.0, 2.00},
	{2960.0, 2602.39, -1658.10, 558.80, 0.0, 0.0, 0.0},
	{2960.0, 2604.70, -1658.20, 558.10, 0.0, 90.0, 2.00},
	{2960.0, 2602.40, -1658.10, 556.00, 0.0, 0.0, 0.0},
	{2960.0, 2606.60, -1658.40, 559.99, 0.0, 64.0, 352.0},
	{2960.0, 2605.70, -1658.20, 559.00, 0.0, 90.0, 2.0},
	{2960.0, 2603.40, -1658.30, 555.00, 0.0, 42.0, 352.00},
	{2960.0, 2608.50, -1658.90, 559.00, 0.0, 132.0, 352.00},
	{2960.0, 2609.70, -1658.80, 556.00, 0.0, 90.0, 2.00},
	{2960.0, 2609.70, -1658.80, 558.00, 0.0, 90.0, 0.00},
	{7017.0, 2582.00, -1694.60, 549.70, 0.0, 0.0, 85.99},
	{7017.0, 2582.00, -1694.60, 544.50, 0.0, 0.0, 85.99},
	{7017.0, 2620.80, -1695.70, 544.50, 0.0, 0.0, 263.99},
	{7017.0, 2620.80, -1695.70, 549.70, 0.0, 0.0, 263.99},
	{7017.0, 2618.80, -1696.90, 549.70, 0.0, 0.0, 173.99},
	{7017.0, 2618.80, -1696.90, 544.50, 0.0, 0.0, 173.98},
	{7017.0, 2582.00, -1694.60, 554.90, 0.0, 0.0, 85.99},
	{7017.0, 2620.80, -1695.70, 554.90, 0.0, 0.0, 263.99},
	{2960.0, 2597.90, -1657.90, 556.80, 0.0, 0.0, 0.0},
	{2960.0, 2593.60, -1657.80, 556.80, 0.0, 0.0, 0.0},
	{2960.0, 2589.80, -1657.80, 556.80, 0.0, 0.0, 0.0},
	{2960.0, 2586.00, -1657.80, 556.80, 0.0, 0.0, 0.0},
	{2960.0, 2611.70, -1658.90, 556.80, 0.0, 0.0, 0.0},
	{2960.0, 2615.70, -1658.90, 556.80, 0.0, 0.0, 0.0},
	{2960.0, 2619.50, -1659.10, 556.80, 0.0, 0.0, 358.0},
	{2960.0, 2622.60, -1659.30, 556.80, 0.0, 0.0, 358.0}
};

stock const randomWheels[ 17 ] =
{
	1025,   1073,   1074,
	1075,   1076,   1077,
	1078,   1079,   1080,
	1081,   1082,   1083,
	1084,   1085,   1096,
	1097,   1098
};

stock const Float:randomPos[ 11 ] =
{
   -1.250,   -1.000,   -0.750,
   -0.500,   -0.250,    0.000,
    0.250,    0.500,    0.750,
	1.000,    1.250
};

stock const randomSongs[ 4 ] =
{
	1062,  1068,
	1076,  1187
};

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Enumerations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

enum e_PLAYER_DATA
{
	bool:p_registered,
	bool:p_logged_in,
		 p_spawn,
		 p_spec,
	bool:p_syncing,
	bool:p_sub,
		 p_FPS,
		 p_duel,
		 p_skin,
		 p_team,
		 p_usedv,
	bool:p_muted,
	bool:p_syncwait,
 		 p_justsync,
	bool:p_npass,
	bool:p_fryzed,
	bool:p_spawned,
		 p_class,
		 p_level,
		 p_stats,
		 p_score,
		 p_kills,
		 p_ckills,
		 p_cdeaths,
		 p_rkills,
		 p_deaths,
		 p_dmrank,
		 p_dmkills,
		 p_dmpoints,
	bool:p_selecting,
	bool:p_returning,
		 p_RWeapon1,
		 p_RWeapon2,
		 p_hits,
		 p_wepset,
		 p_viewmod,
		 p_readded,
		 p_vehicle,
		 p_spectype,
		 p_ukilled,
  Text3D:p_label,
		 p_frozen,
	bool:p_inround,
		 p_viewing,
		 p_flooding,
   	     p_boundcount,
		 p_ping_checks,
		 p_FPS_checks,
		 p_packet_checks,
	bool:p_starting,
	bool:p_readding,
	 	 p_name[ MAX_PLAYER_NAME ],
		 p_weap[ MAX_WEAPON_SLOT ],
		 p_ammo[ MAX_WEAPON_SLOT ],
   Float:p_recentdmg,
   Float:p_rounddmg,
   Float:p_cdmg,
   //Float:p_x_max, Float:p_x_min, Float:p_y_max, Float:p_y_min,
   Float:p_health,
   Float:p_armour,
   Float:p_spos[ 4 ]
}

enum e_BUILD_DATA
{
		 c_editmode,
		 c_spawncount,
    	 c_editarena,
		 c_boundiescount,
	bool:c_reediting,
	bool:c_cspawns,
	bool:c_setspawns,
	bool:c_cboundies,
	bool:c_setboundies,
	bool:c_ccheckpoint,
	bool:c_setcheckpoint
}

enum e_SERVER_DATA
{
		 s_time,
		 s_vepp,
		 s_last,
		 s_cptime,
		 s_attdef,
   Float:s_attdmg,
   Float:s_defdmg,
		 s_weather,
		 s_modesec,
		 s_modemin,
		 s_autoswap,
		 s_setskins,
		 s_chatlock,
	 	 s_modetype,
	 	 s_pinglimit,
   Float:s_packetlimit,
	 	 s_FPSlimit,
	     s_starttime,
		 s_resultidx,
	bool:s_gunmenu,
	bool:s_rending,
	bool:s_rpaused,
		 s_hpbars,
		 s_syncbug,
		 s_knife,
		 s_lobbyweps,
		 s_deathicon,
		 s_mainmode,
	bool:s_rstarted,
	bool:s_rstarting,
	bool:s_capturing,
	bool:s_serverlock
}

enum e_TEAM_DATA
{
		t_skin,
		t_score,
		t_kills,
		t_health,
		t_alive,
		t_current,
		t_players
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

stock
			  playerData [ MAX_PLAYERS ][ e_PLAYER_DATA ],
			  buildData  [ MAX_PLAYERS ][ e_BUILD_DATA ],
			  serverData [ e_SERVER_DATA ],
			  teamData   [ MAX_TEAMS ][ e_TEAM_DATA ],
			  p_object   [ MAX_PLAYERS ][ 49 ],
			  mainTimer  [ 0x03 ] = { -1, ... },
		Float:sSpawns    [ 0x11 ],
		Float:RSpawns    [ 0x0A ][ 4 ],
			  setsChoises[ MAX_TEAMS ][ 0x07 ],
			  teamColor  [ MAX_TEAMS ][ 0x02 ],
			  teamName   [ MAX_TEAMS ][ 0x0C ],
			  teamText   [ MAX_TEAMS ][ 0x08 ],
		Float:SXYZ       [ MAX_PLAYERS ][ 5 ],
			  weapsType  [ 0x04 ],
			  setsLimit  [ 0x07 ],
			  roundTime  [ 0x04 ],
			  duelweap   [ 0x09 ][ 0x2 ],
			  duelplay   [ 0x09 ][ 0x2 ],
			  ResultsN	 [ 26 ][ 20 ],
			  ResultsW	 [ 26 ][ 30 ],
			  ResultsT	 [ 26 ][ 30 ],
			  ResultsR	 [ 26 ][ 30 ],
			  dueltime   [ 0x09 ],
			  duelseg    [ 0x09 ],
			  duelmin    [ 0x09 ],
			  duelslot   [ 0x09 ],
			  duelcountsegtimer,
		Float:mspawn     [ 0x05 ],
		Float:selscr     [ 0x05 ],
		Float:v_angle,
			  checkTimer,
			  startTimer,
			  syncTimer,
			  attacker,
			  defender,
			  gangZone,
			  current    = -1,
			  inCpPlayer = 255,
			  teamWinner,
			  sbString [ 0x100 ],
			  cpString [ 0x020 ],
			  sPassword[ 0x020 ],
		 Text:finalboxtxt[ 15 ],
		 Text:dmtxt		 [ 8 ],
		 Text:dmgtxt     [ 2 ][ MAX_PLAYERS ],
		 Text:teamdmgtxt [ 2 ],
		 Text:rdmgtxd    [ MAX_PLAYERS ],
		 Text:DMpoints	 [ MAX_PLAYERS ],
		 Text:Scores,
		 Text:Spectating [ MAX_PLAYERS ],
		 Text:SpecBox    [ MAX_PLAYERS ][ 2 ],
	    Float:RoundLimits = 9.0,
	    	  RoundCounts = 0,
	     bool:MatchMode = false,
		 Text:letterbox[ 2 ],
		 Text:finaltxt [ 11 ],
		 Text:cfinaltxt[ 21 ],
		 Text:maintxt  [ 03 ],
		 Text:classtxt [ 03 ],
		 Text:ukilled  [ MAX_PLAYERS ],
		 Text:ukilled2 [ MAX_PLAYERS ],
		 Menu:switchMenu,
		 Menu:buildMenu[ 0x05 ],
			  roundVeh [ MAX_VEHICLES ],
		 Text:txtTimeDisp,
			  hour, minute,
		 bool:textBack,
       Text3D:PINGT[MAX_PLAYERS],
	  	 	  issuer   [MAX_PLAYERS],
			  timerGun,
			  pDrunkLevelLast[MAX_PLAYERS],
			  HitTextTimer[ MAX_PLAYERS ],
			  DmgTextTimer[ MAX_PLAYERS ],
			  DMpointsT	  [ MAX_PLAYERS ],
			  ShowingDMpoints[ MAX_PLAYERS ],
			  UpdateSpecTimer[ MAX_PLAYERS ],
			  HideDmgTeamText0Timer,
			  HideDmgTeamText1Timer,
			  Var1[ MAX_PLAYERS ],
			  RandomType,
			  RandomTime
;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	HealthBars
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

#define percent(%1,%2,%3)  ( %1 / %2 * %3 )
#define HOME_BBOARD_X        3.00
#define HOME_BBOARD_Y        160.0
#define AWAY_BBOARD_X        574.0
#define AWAY_BBOARD_Y        160.0
#define MAX_WIDTH            63.0
#define MAX_HEIGHT           14.0

stock
		  barPlaya   [ MAX_TEAMS ][ MAX_PLAYERS ],
		  SlotCount  [ MAX_TEAMS ],
	Float:barValue   [ MAX_TEAMS ][ 0x15 ],
	 Text:hpBar 	 [ MAX_TEAMS ][ MAX_PLAYERS ][ 0x03 ],
	Float:maxhpBar;

createHPbars( )
{
	new Float:x = HOME_BBOARD_X, Float:y = HOME_BBOARD_Y;

	for ( new i; i < MAX_TEAMS - 1; i ++ )
	{
		for ( new j; j < MAX_PLAYERS; j ++ )
		{
			hpBar[ i ][ j ][ 0 ] = TextDrawCreate( x, y, "LD_otb2:butnA" );
			TextDrawFont           ( hpBar[ i ][ j ][ 0 ], 4 );
			TextDrawLetterSize     ( hpBar[ i ][ j ][ 0 ], 0.50, 1.00 );
			TextDrawColor          ( hpBar[ i ][ j ][ 0 ], 0x00000035 );
			TextDrawTextSize       ( hpBar[ i ][ j ][ 0 ], percent( 200, 200, MAX_WIDTH ), MAX_HEIGHT );
			TextDrawUseBox         ( hpBar[ i ][ j ][ 0 ], 1 );

			hpBar[ i ][ j ][ 1 ] = TextDrawCreate( x, y, "LD_otb2:butnA" );
			TextDrawFont           ( hpBar[ i ][ j ][ 1 ], 4 );
			TextDrawLetterSize     ( hpBar[ i ][ j ][ 1 ], 0.50, 1.00 );
			TextDrawColor          ( hpBar[ i ][ j ][ 1 ], teamColor[ i ][ 1 ] & 0xFFFFFF30 );
			TextDrawTextSize       ( hpBar[ i ][ j ][ 1 ], percent( 200, 200, MAX_WIDTH ), MAX_HEIGHT );
			TextDrawUseBox         ( hpBar[ i ][ j ][ 1 ], 1 );

			hpBar[ i ][ j ][ 2 ] = TextDrawCreate( x + 29.00, y + 1.25, " " );
			TextDrawFont           ( hpBar[ i ][ j ][ 2 ], 1 );
			TextDrawAlignment      ( hpBar[ i ][ j ][ 2 ], 2 );
			TextDrawBackgroundColor( hpBar[ i ][ j ][ 2 ], teamColor[ i ][ 0 ] & 0xFFFFFF40 );
			TextDrawLetterSize     ( hpBar[ i ][ j ][ 2 ], 0.15, 0.79 );
			TextDrawSetShadow      ( hpBar[ i ][ j ][ 2 ], 0 );
			TextDrawSetOutline     ( hpBar[ i ][ j ][ 2 ], 1 );
			TextDrawSetProportional( hpBar[ i ][ j ][ 2 ], 1 );
			TextDrawColor          ( hpBar[ i ][ j ][ 2 ], 0x000000FF );

			y += 12.5;
		}

		x = AWAY_BBOARD_X;
		y = AWAY_BBOARD_Y;
	}

}

showBars( playerid )
{
	for ( new i; i < MAX_TEAMS - 1; i ++ )
	{
		for ( new j; j < MAX_PLAYERS; j ++ )
		{
			if ( barPlaya[ i ][ j ] > -1 )
			{
				if ( playerData[ playerid ][ p_class ] == -1 )
				{
					TextDrawShowForPlayer( playerid, hpBar[ i ][ j ][ 0 ] );

					TextDrawShowForPlayer( playerid, hpBar[ i ][ j ][ 1 ] );

					TextDrawShowForPlayer( playerid, hpBar[ i ][ j ][ 2 ] );
				}
			}
		}
	}
}

hideBars( playerid )
{
	for ( new i; i < MAX_TEAMS - 1; i ++ )
	{
		for ( new j; j < MAX_PLAYERS; j ++ )
		{
			TextDrawHideForPlayer( playerid, hpBar[ i ][ j ][ 0 ] );

			TextDrawHideForPlayer( playerid, hpBar[ i ][ j ][ 1 ] );

			TextDrawHideForPlayer( playerid, hpBar[ i ][ j ][ 2 ] );
		}
	}
}

setBarValue( team, slot, Float:bar_hp )
{
	barValue[ team ][ slot ] = bar_hp;

	TextDrawTextSize( hpBar[ team ][ slot ][ 1 ], percent( bar_hp, maxhpBar, MAX_WIDTH ), MAX_HEIGHT );
	
	TextDrawShowForAll( hpBar[ team ][ slot ][ 1 ] );
}

updateBarsMaxValue( Float:max )
{
    maxhpBar = max;

	for ( new i; i < MAX_TEAMS - 1; i ++ )
	{
		for ( new j; j < MAX_PLAYERS; j ++ )
		{
			setBarValue( i, j, barValue[ i ][ j ] );
		}
	}
}


addPlayerBar( playerid, team, slot, Float:value = 255.0 )
{
	if ( value == 255.0 )
	    value = maxhpBar;

	barPlaya[ team ][ slot ] = playerid;

	setBarValue( team, slot, value );

	TextDrawSetString( hpBar[ team ][ slot ][ 2 ], playerData[ playerid ][ p_name ] );

	loopPlayers( otherid )
		showBars( otherid );
}

remPlayerBar( playerid, team, slot )
{
	barPlaya[ team ][ slot ] = -1;

	barValue[ team ][ slot ] = maxhpBar;

	loopPlayers( otherid )
	{
		TextDrawHideForPlayer( otherid, hpBar[ team ][ slot ][ 0 ] );

		TextDrawHideForPlayer( otherid, hpBar[ team ][ slot ][ 1 ] );

		TextDrawHideForPlayer( otherid, hpBar[ team ][ slot ][ 2 ] );
	}

	for ( new i = slot; i < MAX_PLAYERS - 1; i ++ )
	{
		if ( barPlaya[ team ][ i + 1 ] > -1 )
		{
			new id, Float:vl;

			id = barPlaya[ team ][ i + 1 ];

			vl = barValue[ team ][ i + 1 ];

			barPlaya[ team ][ i + 1 ] = -1;

			barValue[ team ][ i + 1 ] = maxhpBar;

			loopPlayers( otherid )
			{
				TextDrawHideForPlayer( otherid, hpBar[ team ][ i + 1 ][ 0 ] );

				TextDrawHideForPlayer( otherid, hpBar[ team ][ i + 1 ][ 1 ] );

				TextDrawHideForPlayer( otherid, hpBar[ team ][ i + 1 ][ 2 ] );
			}

			addPlayerBar( id, team, i, vl );
		}
	}
	#pragma unused playerid
}

NextAvailableBarSlot( team )
{
	new slot;

	for ( new j; j < MAX_PLAYERS; j ++ )
	{
		if ( barPlaya[ team ][ j ] == -1 )
		{
			slot = j;

			break;
		}
	}

	return slot;
}

FindPlayerBarSlot( playerid, team )
{
	new slot;

	for ( new i; i < MAX_PLAYERS; i ++ )
	{
	    if ( barPlaya[ team ][ i ] == playerid )
		{
            slot = i;

			break;
		}
	}

	return slot;
}

resetBars( )
{
	for ( new i; i < MAX_TEAMS - 1; i ++ )
	{
		for ( new j; j < MAX_PLAYERS; j ++ )
		{
			barValue[ i ][ j ] = maxhpBar;

			barPlaya[ i ][ j ] = -1;
		}
	}
}
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Forwards
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

forward scriptSync     (   );
forward playersUpdate  (   );
forward UpdateLabel    (   );
forward vehiclezSync   (   );
forward rotateCam      (   );
forward countInit      (   );
forward updateRound1   (   );
forward updateRound2   (   );
forward updateRound3   (   );
forward updateRound4   (   );
forward hideTexts      (   );
forward unpauseCounting(   );
forward ClanWarFinal   (   );
forward PrepareFinalTxd(   );
forward MoveCamera     (   );
forward ShowFinalTxd   (   );
forward HideFinalTxd   (   );
forward DisableGunMenu (   );
forward FloodVar       ( playerid );
forward JustSyncFalse  ( playerid );
forward duelCounting   ( duelid   );
forward duelcountseg   ( duelid   );
forward DestroyObjectEx( objectid );
forward KickPlayer     ( playerid );
forward loginKick      ( playerid );
forward lockedKick     ( playerid );
forward	SyncPlayer     ( playerid );
forward	SyncPlayer2    ( playerid );
forward StopSpectate   ( playerid );
forward HideDmgText	   ( playerid );
forward HideHitText	   ( playerid );
forward UpdateBars     ( playerid );
forward UpdateMaintxt  ( playerid );
forward UpdateSpec	   ( playerid );
forward ShowSpecWeaps  ( playerid, specid );
forward StartSpectate  ( playerid, specid );
forward YouKilledTxd   ( playerid, killerid );
forward ShowDMpoints   ( playerid, points );
forward UpdateDMpoints ( playerid, time );
forward ShowScoresTxd  (  );


main( ){ }

	
public OnGameModeInit(  )
{
	
	if ( GetMaxPlayers(  ) > MAX_PLAYERS )
	{
		print( "  (FATAL ERROR) Sorry, this gamemode can't load in this server." );
		print( "  (FATAL ERROR) The \"maxplayers\" can't be higher than "#MAX_PLAYERS".\n\n" );

		SendRconCommand( "hostname Fatal error, check server_log.txt" );
		SendRconCommand( "password fatal_error" );

		return false;
	}
	else
	{
		print( "ChoraNaum - Attack and Defend  " );
		print( "Created by: [MrS]Lake, Edit: Less" );
	}

	SetGameModeText( GM_NAME );
	AddPlayerClass ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
	AddPlayerClass ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
	AddPlayerClass ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
	
	ConfigLoad               ( CONFIG_FILE );
	UsePlayerPedAnims        (		 );
	DisableInteriorEnterExits(		 );
	SetWeather				 ( serverData[ s_weather ] );
	SetWorldTime			 ( serverData[ s_time    ] );
	EnableStuntBonusForAll   ( false );
	AllowInteriorWeapons     ( true  );
	ShowPlayerMarkers        ( true  );
	ShowNameTags             ( true  );

	serverData[ s_rpaused    ] = false;
	serverData[ s_rending    ] = false;
	serverData[ s_rstarted   ] = false;
	serverData[ s_rstarting  ] = false;
	serverData[ s_gunmenu    ] = false;
	serverData[ s_cptime     ] = checkTimer;
	serverData[ s_starttime  ] = startTimer;
	serverData[ s_modemin    ] = roundTime[ 0 ];
	serverData[ s_modesec    ] = roundTime[ 0 ];

	teamColor[ HOME ][ 0 ] = 0xFF3737FF; 
 	teamColor[ HOME ][ 1 ] = 0xA60000FF;
	teamColor[ AWAY ][ 0 ] = 0x3B2CE1FF;
	teamColor[ AWAY ][ 1 ] = 0x1A117CFF;
	teamColor[ REF  ][ 0 ] = 0xDEDE01FF;
 	teamColor[ REF  ][ 1 ] = 0xFFFF00FF;

	teamText[ HOME ] = "~r~";
 	teamText[ AWAY ] = "~b~";
	teamText[ REF  ] = "~y~";

	for( new i; i < 7; i++ )

		duelplay[ i ][ 0 ] = 255, duelplay[ i ][ 1 ] = 255;

	duelweap[ 1 ][ 0 ] = 24, duelweap[ 1 ][ 1 ] = 27;
	duelweap[ 2 ][ 0 ] = 26, duelweap[ 2 ][ 1 ] = 28;
	duelweap[ 3 ][ 0 ] = 24, duelweap[ 3 ][ 1 ] = 25;
	duelweap[ 4 ][ 0 ] = 24, duelweap[ 4 ][ 1 ] = 25;
	duelweap[ 5 ][ 0 ] = 24, duelweap[ 5 ][ 1 ] = 34;
	duelweap[ 6 ][ 0 ] = 24, duelweap[ 6 ][ 1 ] = 37;
	duelweap[ 7 ][ 0 ] = 34, duelweap[ 7 ][ 1 ] = 25;
	duelweap[ 8 ][ 0 ] = 34, duelweap[ 8 ][ 1 ] = 25;
	

	for( new playerid; playerid < MAX_PLAYERS; playerid ++ )

	    resetVars( playerid );

	textsLoad(  );
	menusLoad(  );
	updateMap(  );

	mainTimer[ 0 ] = SetTimer( "scriptSync",    1000, true );
	mainTimer[ 1 ] = SetTimer( "vehiclezSync", 60000, true );
	mainTimer[ 2 ] = SetTimer( "UpdateLabel",    500, true );
	
	CreateObject( 8661, 282.7000122,  1885.3000488,  16.6, 0,   0, 0 ); //object(gnhtelgrnd_lvs) (1)
	CreateObject( 8661, 1077.7399902, 1391.6999512, -12.8, 0, 270, 0 ); //object(gnhtelgrnd_lvs) (2)
	
	createHPbars( );
	updateBarsMaxValue( 200 );
	resetBars( );
	
	return true;
}

public OnGameModeExit(  )
{
	if ( serverData[ s_rstarted ] )
	{
		if ( fexist( TEMP_FILE ) )

			fremove( TEMP_FILE );
	}

	if ( mainTimer[ 0 ] != -1 ) KillTimer( mainTimer[ 0 ] );

	if ( mainTimer[ 1 ] != -1 ) KillTimer( mainTimer[ 1 ] );
	
	if ( mainTimer[ 2 ] != -1 ) KillTimer( mainTimer[ 2 ] );

	return true;
}

public OnPlayerConnect( playerid )
{
	#if loopType == 0

		highestID = updateHighestID( ) + 1;

	#endif
	
	new info[ 128 ];

	format( info, sizeof(info), "%d \r\n{40FF00}Ping:{FFFFFF} %d", GetPlayerFPS( playerid ), GetPlayerPing( playerid ) );

    PINGT[ playerid ] = Create3DTextLabel( info, 0xFFFFFFFF, 0, 0, 0, 7,-1,1 );

    Attach3DTextLabelToPlayer( PINGT[ playerid ], playerid, 0, 0, -0.6 );
    
	
	new playerName[ MAX_PLAYER_NAME ], playerIP[ 16 ];

    gettime(hour, minute);

	GetPlayerName( playerid, playerName, sizeof( playerName ) );
	
	resetVars  ( playerid );

	GetPlayerIp  ( playerid, playerIP  , sizeof( playerIP   ) );

	format( playerData[ playerid ][ p_name ], sizeof( playerName ), playerName );
	
	playerData[ playerid ][ p_spawned ] = false;

	playerData[ playerid ][ p_label ] = Create3DTextLabel( " ", 0xFFBF00FF, 0, 0, 0, 30, GetPlayerVirtualWorld( playerid ) );
	Attach3DTextLabelToPlayer( playerData[ playerid ][ p_label ], playerid, 0, 0, 0.7 );

	for( new i; i < sizeof( badNames ); i++ )
	{
		if ( !strcmp( badNames[ i ], playerData[ playerid ][ p_name ], true ) )
			return Kick( playerid );
	}

	info = fileGet( NICKLOG_FILE, playerIP );

	if ( !strlen( info ) )

		fileSet( NICKLOG_FILE, playerIP, playerData[ playerid ][ p_name ] );
	else
	{
		if ( strfind( info, playerData[ playerid ][ p_name ], true ) == -1 )
		{
			format( info, sizeof( info ), "%s,%s", info, playerData[ playerid ][ p_name ] );

			fileSet( NICKLOG_FILE, playerIP, info );
		}
	}

	if ( !strlen( info ) )

		format( info, sizeof( info ), "*** %s (ID:%i) has joined the server (IP: %s)."     , playerData[ playerid ][ p_name ], playerid, playerIP );
	else
		format( info, sizeof( info ), "*** %s (ID:%i) has joined the server (NickLog: %s).", playerData[ playerid ][ p_name ], playerid, info );

	new conn[ 60 ];

 	format( conn, sizeof( conn ),"*** %s (ID:%i) has joined the server.", playerData[ playerid ][ p_name ], playerid );

	loopPlayers( otherid )
	{
		PlayerPlaySound( otherid, 1084, 0, 0, 0 );

 		if ( playerData[ otherid ][ p_level ] > 0 )

			SendClientMessage( otherid, GREY_COLOR, info );
		else
			SendClientMessage( otherid, GREY_COLOR, conn );
	}

	if ( fexist( TEMP_FILE ) && serverData[ s_rstarted ] )
	{
		new temp[ 128 ];
		
		temp = fileGet( TEMP_FILE, playerData[ playerid ][ p_name ] );
		
		playerData[ playerid ][ p_returning ] = strlen( temp ) ? ( true ) : ( false );
	}

	if ( serverData[ s_serverlock ] )
	{
     	SendClientMessage( playerid, ERROR_COLOR, "*** THE SERVER IS LOCKED. YOU HAVE 15 SECONDS FOR TYPE, /PASS <PASSWORD>. ***") ;

		SetTimerEx( "lockedKick", 15000, false, "i", playerid );

	    playerData[ playerid ][ p_npass ] = false;
	}

	if( fexist( GetPlayerFile ( playerid ) ) )
	{
		if ( !strval( fileGet( GetPlayerFile( playerid ), "Regis" ) ) )

			playerData[ playerid ][ p_registered ] = false;
		else
		{
			new nPlayerIP[ 128 ];

			nPlayerIP = fileGet( GetPlayerFile( playerid ), "IP" );

			GetPlayerIp( playerid, playerIP, sizeof( playerIP ) );

			if ( !strcmp( playerIP, nPlayerIP ) )
			{
			    SendClientMessage( playerid, MAIN_COLOR1, "*** Welcome back... Auto Logged-in." );

				playerData[ playerid ][ p_level      ]  = strval( fileGet( GetPlayerFile( playerid ), "Level" ) );

				playerData[ playerid ][ p_logged_in  ] = true;

				playerData[ playerid ][ p_registered ] = true;
			}
			else
			{
				SendClientMessage( playerid, MAIN_COLOR1, "*** This nick are registered, you have 30 seconds for typ the password, /login <pass>." );

				playerData[ playerid ][ p_logged_in  ] = false;

				playerData[ playerid ][ p_registered ] = true;

				SetTimerEx( "loginKick", 30000, false, "i", playerid );
			}
		}
	}
	else
		playerData[ playerid ][ p_registered ] = false,

		createAcc ( playerid );

	return true;
}

public OnPlayerDisconnect( playerid, reason )
{
	#if loopType == 0

		highestID = updateHighestID( ) + 1;

	#endif
	
    Delete3DTextLabel( PINGT[ playerid ] );
    
    Delete3DTextLabel( playerData[ playerid ][ p_label ] );
	
	TextDrawHideForPlayer( playerid, Scores );

	new info[ 80 ];

 	format( info, sizeof( info ), "*** %s (ID:%i) has left the server (%s).", playerData[ playerid ][ p_name ], playerid, reason == 0 ? ( "timeout" ) : reason == 1 ? ( "quit" ) : ( "kick" ) );

	SendClientMessageToAll( GREY_COLOR, info );

	if ( playerData[ playerid ][ p_spawn ] == LOBBY )
	{
	    if ( playerData[ playerid ][ p_duel ] )
	    {
			new duelID = playerData[ playerid ][ p_duel ];

		    if ( playerid == duelplay[ duelID ][ 0 ] )
			{
		   	    if ( duelplay[ duelID ][ 1 ] != 255 )
				{
	 	            playerData[ duelplay[ duelID ][ 1 ] ][ p_duel ] = 0;

					SpawnLobby( duelplay[ duelID ][ 1 ], 1 );
				}
	  		}
		    else if ( playerid == duelplay[ duelID ][ 1 ] )
			{
		   	    if ( duelplay[ duelID ][ 0 ] != 255 )
				{
	 	            playerData[ duelplay[ duelID ][ 0 ] ][ p_duel ] = 0;

					SpawnLobby( duelplay[ duelID ][ 0 ], 1 );
				}
	  		}

		    for( new o; o < sizeof( duelObjects ); o++ )

				DestroyPlayerObject( playerid, p_object[ playerid ][ o ] ),
				
				p_object[ playerid ][ o ] = INVALID_OBJECT_ID;

			format( info, sizeof( info ), "*** \"%s\" has left /duel %i.", playerData[ playerid ][ p_name ], duelID );

			SendClientMessageToAll( DUEL_COLOR, info );

		    duelplay[ duelID ][ 0 ] = 255;

			duelplay[ duelID ][ 1 ] = 255;

			duelslot[ duelID ] = 0;
		}
	}
	else
	{
		if ( serverData[ s_rstarted ] )
	    {
			if ( serverData[ s_capturing ] && inCpPlayer == playerid )

				OnPlayerLeaveCheckpoint( playerid );

			if ( playerData[ playerid ][ p_team ] != REF )

				SavePlayerRound( playerid );

			loopPlayers( otherid )
			{
		 		if ( GetPlayerState( otherid ) == PLAYER_STATE_SPECTATING && playerData[ otherid ][ p_spec ] == playerid )

					SendClientMessage( otherid, MAIN_COLOR2, "(INFO) Player disconected." ),

					StopSpectate( otherid );
			}
		
			remPlayerBar( playerid, playerData[ playerid ][ p_team ], FindPlayerBarSlot( playerid, playerData[ playerid ][ p_team ]) );
					
			teamData[ playerData[ playerid ][ p_team ] ][ t_alive ] --;
		}
	}

	for( new i; i < sizeof( maintxt ); i ++ )
	
		TextDrawHideForPlayer( playerid, maintxt[ i ] );

	updateCount(    );

	return true;
}

public OnPlayerRequestClass( playerid, classid )
{
	SetPlayerColor( playerid, GREY_COLOR );

	playerData[ playerid ][ p_class ] = classid;
	
	playerData[ playerid ][ p_spawned ] = false;

	showClassTextdraw( playerid, classid );

	SetPlayerSkin ( playerid, teamData[ classid ][ t_skin ] );

	SetPlayerCameraPos    ( playerid, selscr[ 0 ] + ( 5 * floatsin ( - selscr[ 3 ], degrees ) ),
									  selscr[ 1 ] + ( 5 * floatcos ( - selscr[ 3 ], degrees ) ),
									  selscr[ 2 ] + 1 );

	SetPlayerCameraLookAt ( playerid, selscr[ 0 ], selscr[ 1 ], selscr[ 2 ] );

	SetPlayerPos          ( playerid, selscr[ 0 ], selscr[ 1 ], selscr[ 2 ] );

	SetPlayerInterior     ( playerid, floatround( selscr[ 4 ] ) );

	SetPlayerFacingAngle  ( playerid, selscr[ 3 ] );

	SetPlayerPos          ( playerid, selscr[ 0 ], selscr[ 1 ], selscr[ 2 ] );

	TextDrawHideForPlayer(playerid,Scores);

	for( new i; i < sizeof( letterbox ); i ++ )

		TextDrawShowForPlayer( playerid, letterbox[ i ] );

	for( new i; i < sizeof( maintxt ); i ++ )

		TextDrawHideForPlayer( playerid, maintxt[ i ] );

	return true;
}

public OnPlayerRequestSpawn( playerid )
{
	if ( playerData[ playerid ][ p_returning ] )
	{
		if ( !serverData[ s_rstarted ] )
			goto nope;

		new file[ 128 ], index;

		file = fileGet( TEMP_FILE, playerData[ playerid ][ p_name ] );

		for( new i; i < 4; i++ )

		    playerData[ playerid ][ p_spos ][ i ] = floatstr( strtok( file, index ) );

		playerData[ playerid ][ p_health   ] = floatstr( strtok( file, index ) );

		playerData[ playerid ][ p_armour   ] = floatstr( strtok( file, index ) );

		playerData[ playerid ][ p_team     ] =   strval( strtok( file, index ) );

		playerData[ playerid ][ p_rkills   ] =   strval( strtok( file, index ) );

		playerData[ playerid ][ p_dmrank   ] =   strval( strtok( file, index ) );

		playerData[ playerid ][ p_vehicle  ] =   strval( strtok( file, index ) );

		for( new i; i < MAX_WEAPON_SLOT; i++ )

			playerData[ playerid ][ p_weap ][ i ] = strval( strtok( file, index ) ),
			
			playerData[ playerid ][ p_ammo ][ i ] = strval( strtok( file, index ) );

		playerData[ playerid ][ p_spawn    ] = serverData[ s_modetype ];

		playerData[ playerid ][ p_readding ] = true;

		if( MatchMode == true ) AddPlayer( playerid, playerData[ playerid ][ p_health ], playerData[ playerid ][ p_armour ] );
	}
	else
	{
		nope:

		if ( playerData[ playerid ][ p_returning ] )

		    playerData[ playerid ][ p_returning ] = false;

		new info[ 70 ];

		format( info, sizeof( info ), "*** \"%s\" has spawned as \"%s\".", playerData[ playerid ][ p_name ], teamName[ playerData[ playerid ][ p_class ] ] );

		playerData[ playerid ][ p_team ] = playerData[ playerid ][ p_class ];

       	SendClientMessageToAll( teamColor[ playerData[ playerid ][ p_class ] ][ 1 ], info );

		if ( strval( fileGet( GetPlayerFile( playerid ), "PSkin" ) ) > -1 )

			playerData[ playerid ][ p_skin ] = strval( fileGet( GetPlayerFile( playerid ), "PSkin" ) );

		SpawnLobby( playerid );
	}

	playerData[ playerid ][ p_class ] = -1;

	playerData[ playerid ][ p_spawned ] = true;

	GameTextForPlayer( playerid, "_", 1000, 6 );
	
	TextDrawShowForPlayer( playerid, Scores );

	for( new i; i < sizeof( letterbox ); i ++ )

		TextDrawHideForPlayer( playerid, letterbox[ i ] );
		
	for( new i; i < sizeof( classtxt ); i ++ )

		TextDrawHideForPlayer ( playerid, classtxt[ i ] );

	TextDrawShowForPlayer( playerid, maintxt[ 2 ] );

	return true;
}

public OnPlayerSpawn( playerid )
{
	AntiDeAMX();

	ShowScoresTxd(  );
	
   	TextDrawShowForPlayer( playerid, txtTimeDisp );
   	
	gettime(hour, minute);

	if ( playerData[ playerid ][ p_syncing ] )
	{
	    playerData[ playerid ][ p_syncing  ] = false,
		playerData[ playerid ][ p_syncwait ] = false;
	}
	else
	{
	 	if ( playerData[ playerid ][ p_spawn ] == LOBBY )
 		{
			playerData[ playerid ][ p_inround ] = false;
			playerData[ playerid ][ p_wepset  ] = 0;
			playerData[ playerid ][ p_readded ] = 0;
			playerData[ playerid ][ p_dmkills ] = 0;
			playerData[ playerid ][ p_dmpoints] = 0;
		 	playerData[ playerid ][ p_rkills  ] = 0;
			playerData[ playerid ][ p_dmrank  ] = 0;
			playerData[ playerid ][ p_usedv   ] = 0;
			
	 	    SetPlayerHealth( playerid, 100 );
		 	SetPlayerArmour( playerid, 100 );

			GetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );

			GetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );

			if ( playerData[ playerid ][ p_duel ] )
			{
			    for( new o; o < sizeof( duelObjects ); o++ )

					DestroyPlayerObject( playerid, p_object[ playerid ][ o ] ),

					p_object[ playerid ][ o ] = INVALID_OBJECT_ID;

				playerData[ playerid ][ p_duel ] = 0;
			}

			SetPlayerWorldBounds   ( playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000 );
			if( serverData[ s_lobbyweps ] ) GivePlayerModeWeapons  ( playerid, LOBBY );
			SetPlayerColor         ( playerid, playerData[ playerid ][ p_sub ] ? ( SUB_COLOR ) : ( teamColor[ playerData[ playerid ][ p_team ] ][ 0 ] ) );
			SetPlayerScore         ( playerid, playerData[ playerid ][ p_kills ] );
			SetPlayerInterior      ( playerid, floatround( mspawn[ 4 ] ) );
			SetPlayerVirtualWorld  ( playerid, 0 );
			DisablePlayerCheckpoint( playerid );
		}
		else
		{
			if ( playerData[ playerid ][ p_team ] != REF )
			{
				if ( !playerData[ playerid ][ p_readding ] )
				{
					SetPlayerHealth( playerid, serverData[ s_modetype ] == DM ? ( 90.0 ) : ( 100.0 ) );
					SetPlayerArmour( playerid, serverData[ s_modetype ] == DM ? (  0.0 ) : ( 100.0 ) );

					GetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );

					GetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );

					teamData[ playerData[ playerid ][ p_team ] ][ t_players ] ++;
				}

				SetPlayerColor		 ( playerid, serverData[ s_modetype ] == DM ? ( 0xFFFFFFFF ) : ( teamColor[ playerData[ playerid ][ p_team ] ][ 1 ] ) );
				SetPlayerInterior  	 ( playerid, floatround( sSpawns[ 12 ] ) );
				ResetPlayerWeapons   ( playerid );

				if ( playerData[ playerid ][ p_returning ] )
				{
					if ( playerData[ playerid ][ p_vehicle ] )
					{
						SetVehicleVirtualWorld(           playerData[ playerid ][ p_vehicle ], 1 );
						PutPlayerInVehicle	  ( playerid, playerData[ playerid ][ p_vehicle ], 0 );
					}

					for( new i; i < MAX_WEAPON_SLOT; i ++ )

						if ( playerData[ playerid ][ p_weap ][ i ] && playerData[ playerid ][ p_ammo ][ i ] )
						
						    GivePlayerWeapon( playerid, playerData[ playerid ][ p_weap ][ i ], playerData[ playerid ][ p_ammo ][ i ] );

					playerData[ playerid ][ p_returning ] = false;
				}
				else
					GivePlayerModeWeapons( playerid, serverData[ s_modetype ] );

				if ( serverData[ s_rpaused ] )

					TogglePlayerControllable( playerid, false );

				playerData[ playerid ][ p_inround ] = true;
			}
			else
			{
				if ( !sSpawns[ 12 ] )

					SetPlayerSpecialAction( playerid, SPECIAL_ACTION_USEJETPACK );

				SetPlayerColor( playerid, teamColor[ REF ][ 1 ] );
			}
		}
	}

	SetCameraBehindPlayer( playerid );

	playerData[ playerid ][ p_viewing  ] = -1;
	playerData[ playerid ][ p_viewmod  ] = -1;
	playerData[ playerid ][ p_readding ] = false;

	updateTeams(  );
	updateCount(  );

	return true;
}

public OnPlayerDeath( playerid, killerid, reason )
{
	if( !serverData[ s_rstarted ] || playerData[ playerid ][ p_inround ] ) 
	{
		SendDeathMessage( killerid, playerid, reason );
	
		if( serverData[ s_deathicon ] )
		{
			new Float:x, Float:y, Float:z;
			
			GetPlayerPos( playerid, x, y, z );
			
			loopPlayers( otherid ) 
			{
				if( playerData[ otherid ][ p_team ] == playerData[ playerid ][ p_team ] )
				{
					SetPlayerMapIcon( otherid, playerid, x, y, z, 0, 0xDDDDDDFF, MAPICON_LOCAL );
				
					SetTimerEx( "RemovePlayerMapIcon", 3000, false, "dd", otherid, playerid );
				}	
			}
		}
	}
	
 	if ( playerData[ playerid ][ p_syncwait ] || playerData[ playerid ][ p_syncing ] )
	{
	    playerData[ playerid ][ p_syncing  ] = false;
		playerData[ playerid ][ p_syncwait ] = false;
	}
	
    if ( playerData[ playerid ][ p_spawn ] == LOBBY )
	{
	    if ( playerData[ playerid ][ p_duel ] )
	    {
			new info[ 128 ], duelID = playerData[ playerid ][ p_duel ];

			if ( duelplay[ duelID ][ 0 ] == playerid )
			{
				if ( reason >= 0 && reason < 50 )
		  		{
					new Float:h, Float:a;

					GetPlayerHealth( duelplay[ duelID ][ 1 ], h );

					GetPlayerArmour( duelplay[ duelID ][ 1 ], a );

					format( info, sizeof( info ), "*** \"%s\" %s \"%s\" in /duel %i (Life Remaing: %.0f / Time: %02d:%02d).", playerData[ duelplay[ duelID ][ 1 ] ][ p_name ], h == 100 && a >= 50 ? ( "owned" ) : h == 100 && a >= 10 ? ( "killed" ) : ( "beat" ), playerData[ duelplay[ duelID ][ 0 ] ][ p_name ], duelID,( h + a ), duelmin [ duelID ], duelseg [ duelID ] );

					KillTimer( duelcountsegtimer );

					fileSet( GetPlayerFile( duelplay[ duelID ][ 1 ] ), "DuelsK", intstr( strval( fileGet( GetPlayerFile( duelplay[ duelID ][ 1 ] ), "DuelsK" ) ) + 1 ) );

					fileSet( GetPlayerFile( duelplay[ duelID ][ 0 ] ), "DuelsD", intstr( strval( fileGet( GetPlayerFile( duelplay[ duelID ][ 0 ] ), "DuelsD" ) ) + 1 ) );

					SpawnLobby( duelplay[ duelID ][ 1 ], 1 );

					SpawnLobby( duelplay[ duelID ][ 0 ] );
				}
				else
				{
					if ( duelplay[ duelID ][ 1 ] != 255 )
						SpawnLobby( duelplay[ duelID ][ 1 ], 1 );

					format( info, sizeof( info ), "*** \"%s\" killed himself in /duel %i.", playerData[ duelplay[ duelID ][ 0 ] ][ p_name ], duelID );

					SpawnLobby( duelplay[ duelID ][ 0 ] );
				}
			}
			else if ( duelplay[ duelID ][ 1 ] == playerid )
			{
				if ( reason >= 0 && reason < 50 )
		  		{
					new Float:h, Float:a;

					GetPlayerHealth( duelplay[ duelID ][ 0 ], h );

					GetPlayerArmour( duelplay[ duelID ][ 0 ], a );

					format( info, sizeof( info ), "*** \"%s\" %s \"%s\" in /duel %i (Life Remaing: %.0f / Time: %02d:%02d).", playerData[ duelplay[ duelID ][ 0 ] ][ p_name ], h == 100 && a >= 50 ? ( "owned" ) : h == 100 && a >= 10 ? ( "killed" ) : ( "beat" ), playerData[ duelplay[ duelID ][ 1 ] ][ p_name ], duelID,( h + a ), duelmin [ duelID ], duelseg [ duelID ] );

					KillTimer( duelcountsegtimer );

					fileSet( GetPlayerFile( duelplay[ duelID ][ 0 ] ), "DuelsK", intstr( strval( fileGet( GetPlayerFile( duelplay[ duelID ][ 0 ] ), "DuelsK" ) ) + 1 ) );

					fileSet( GetPlayerFile( duelplay[ duelID ][ 1 ] ), "DuelsD", intstr( strval( fileGet( GetPlayerFile( duelplay[ duelID ][ 1 ] ), "DuelsD" ) ) + 1 ) );

					SpawnLobby( duelplay[ duelID ][ 0 ], 1 );

					SpawnLobby( duelplay[ duelID ][ 1 ] );
				}
				else
				{
					if ( duelplay[ duelID ][ 0 ] != 255 )
						SpawnLobby( duelplay[ duelID ][ 0 ], 1 );

					format( info, sizeof( info ), "*** \"%s\" killed himself in /duel %i.", playerData[ duelplay[ duelID ][ 1 ] ][ p_name ], duelID );

					SpawnLobby( duelplay[ duelID ][ 1 ] );
				}
			}

			SendClientMessageToAll( ERROR_COLOR, info );

			duelplay[ duelID ][ 0 ] = 255;
			duelplay[ duelID ][ 1 ] = 255;
			duelslot[ duelID ]      = 0;
		}
		SpawnLobby( playerid );
	}
	else
	{
	    if ( playerData[ playerid ][ p_team ] != REF )
	    {
			if ( killerid != INVALID_PLAYER_ID )
			{
				fileSet( GetPlayerFile( killerid ), "RoundK", intstr( strval( fileGet( GetPlayerFile( killerid ), "RoundK" ) ) + 1 ) );

				PlayerPlaySound( killerid, 1149, 0, 0, 0 );

				playerData[ killerid ][ p_kills  ] ++;

				playerData[ killerid ][ p_rkills ] ++;
				
				new string[ 45 ];

				if( playerData[ killerid ][ p_ukilled ] == 0 )
				{
					format( string, sizeof( string ), "You killed ~w~%s", playerData[ playerid ][ p_name ] );
				
					TextDrawSetString	  ( ukilled[ killerid ], string );

					TextDrawShowForPlayer ( killerid, ukilled[ killerid ] );
					
					playerData[ killerid ][ p_ukilled ] = 1;
				}
				else
				{
					format( string, sizeof( string ), "You killed ~w~%s", playerData[ playerid ][ p_name ] );
					
					TextDrawSetString	  ( ukilled2[ killerid ], string );

					TextDrawShowForPlayer ( killerid, ukilled2[ killerid ] );
				}

				if( playerData[ playerid ][ p_ukilled ] == 0 )
				{
					format( string, sizeof( string ), "You killed by ~w~%s", playerData[ killerid ][ p_name ] );

					TextDrawSetString	  ( ukilled[ playerid ], string );

					TextDrawShowForPlayer ( playerid, ukilled[ playerid ] );

					playerData[ playerid ][ p_ukilled ] = 1;
				}
				else
				{
					format( string, sizeof( string ), "You killed by ~w~%s", playerData[ killerid ][ p_name ] );
					
					TextDrawSetString	  ( ukilled2[ playerid ], string );

					TextDrawShowForPlayer ( playerid, ukilled2[ playerid ] );
				}

        		SetTimerEx( "YouKilledTxd", 2000, false, "dd", playerid, killerid );
			}
			
			fileSet( GetPlayerFile( playerid ), "RoundD", intstr( strval( fileGet( GetPlayerFile( playerid ), "RoundD" ) ) + 1 ) );

			if ( serverData[ s_modetype ] == DM )
			{
				if ( killerid != INVALID_PLAYER_ID )
				{
					playerData[ killerid ][ p_dmkills ] ++;
					
					switch ( reason )
					{
						case 0: 
						{
							if( ShowingDMpoints[ killerid ] == 1 ) KillTimer( DMpointsT[ killerid ] );
							
							playerData[ killerid ][ p_dmpoints ] += 20,  ShowDMpoints( killerid, 20 );
						}
						case 24: 
						{
							if( ShowingDMpoints[ killerid ] == 1 ) KillTimer( DMpointsT[ killerid ] );
							
							playerData[ killerid ][ p_dmpoints ] += 12, ShowDMpoints( killerid, 12 );
						}	
						case 25:
						{
							if( ShowingDMpoints[ killerid ] == 1 ) KillTimer( DMpointsT[ killerid ] );
							playerData[ killerid ][ p_dmpoints ] += 5,  ShowDMpoints( killerid, 5 );
						}	
						case 27: 
						{
							if( ShowingDMpoints[ killerid ] == 1 ) KillTimer( DMpointsT[ killerid ] );
							playerData[ killerid ][ p_dmpoints ] += 5,  ShowDMpoints( killerid, 5 );
						}	
						case 29: 
						{
							if( ShowingDMpoints[ killerid ] == 1 ) KillTimer( DMpointsT[ killerid ] );
							playerData[ killerid ][ p_dmpoints ] += 3,  ShowDMpoints( killerid, 3 );
						}	
						case 31: 
						{
							if( ShowingDMpoints[ killerid ] == 1 ) KillTimer( DMpointsT[ killerid ] );
							playerData[ killerid ][ p_dmpoints ] += 4,  ShowDMpoints( killerid, 4 );
						}	
							
						case 34: 
						{
							if( ShowingDMpoints[ killerid ] == 1 ) KillTimer( DMpointsT[ killerid ] );
							playerData[ killerid ][ p_dmpoints ] += 10, ShowDMpoints( killerid, 10 );
						}	
						//default: playerData[ playerid ][ p_dmpoints ] += 2,  ShowDMpoints( playerid, 2 );
					}

					if ( playerData[ killerid ][ p_dmrank ] < 10 && playerData[ killerid ][ p_dmkills ] >= 2 )
					{
						new last;
						
						playerData[ killerid ][ p_dmrank  ] ++;

						playerData[ killerid ][ p_dmkills ] = 0;

						last = playerData[ killerid ][ p_dmrank ] == 10 && GetPlayerWeapon( killerid ) == 25 ? ( 27 ) : ( GetPlayerWeapon( killerid ) );

						switch( playerData[ killerid ][ p_dmrank ] )
						{
							 case 1:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 1." );
							 case 2:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 2, now you have a new weapon (Shotgun)." ),				GivePlayerWeapon( killerid, 25, 9990 ), GivePlayerWeapon( killerid, last, 1 );
							 case 3:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 3." );
							 case 4:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 4, now you have a new weapon (M4)." ), 					GivePlayerWeapon( killerid, 31, 9990 ), GivePlayerWeapon( killerid, last, 1 );
							 case 5:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 5." );
							 case 6:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 6, now you have a new weapon (MP5)." ), 					GivePlayerWeapon( killerid, 29, 9990 ), GivePlayerWeapon( killerid, last, 1 );
							 case 7:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 7." );
							 case 8:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 8, now you have a new weapon (Sniper)." ), 				GivePlayerWeapon( killerid, 34, 9990 ), GivePlayerWeapon( killerid, last, 1 );
							 case 9:   SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the rank 9." );
							 case 10:  SendClientMessage( killerid, MAIN_COLOR1, "(INFO) You got the last rank, now you have a new weapon (Spas-12)." ), 			GivePlayerWeapon( killerid, 27, 9990 ), GivePlayerWeapon( killerid, last, 1 );
						}

						PlayerPlaySound( killerid, 1133, 0, 0, 0 );
					}
				}
				SpawnRound( playerid );
			}
			else if ( serverData[ s_modetype ] == TDM || serverData[ s_modetype ] == ARENA )
			{
				switch( playerData[ playerid ][ p_team ] )
				{
				    case HOME: teamData[ AWAY ][ t_kills ] ++;
					case AWAY: teamData[ HOME ][ t_kills ] ++;
				}

				if ( serverData[ s_modetype ] == TDM )

					SpawnRound( playerid ),
					
					SetTimerEx( "UpdateBars", 3000, false, "d", playerid );
					
				else
				{
				   	if ( playerData[ playerid ][ p_selecting ] )
						
						playerData[ playerid ][ p_selecting ] = false;

					playerData[ playerid ][ p_spawn ] = LOBBY;
					
					SpawnLobby( playerid );
				}
			}
			else if ( serverData[ s_modetype ] == BASE )
			{
				if ( playerid == inCpPlayer )

					OnPlayerLeaveCheckpoint( playerid );

			   	if ( playerData[ playerid ][ p_selecting ] )

					playerData[ playerid ][ p_selecting ] = false;
					
				playerData[ playerid ][ p_spawn ] = LOBBY;
				
				remPlayerBar( playerid, playerData[ playerid ][ p_team ], FindPlayerBarSlot( playerid, playerData[ playerid ][ p_team ] ) );
				
				SpawnLobby( playerid );
			}
		}
		else
		{
			new Float:x, Float:y, Float:z, Float:r;

			GetPlayerPos        ( playerid, x, y, z );

			GetPlayerFacingAngle( playerid, r );

			SetSpawnInfo        ( playerid, NO_TEAM, playerSkin( playerid ), x, y, z - 0.90, r, 0, 0, 0, 0, 0, 0 );
		}
 	}

    TextDrawHideForPlayer( playerid, txtTimeDisp );

   	if( playerData[ killerid ][ p_inround ] && playerData[ killerid ][ p_team ] != REF )
   	{
		ShowRoundDamageText( killerid );

		if( MatchMode == true )
		{
		    playerData[ playerid ][ p_cdeaths ]++;
		    playerData[ killerid ][ p_ckills ]++;
		}
	}
	
	loopPlayers( otherid )
	{
	    if( playerData[ otherid ][ p_spec ] == playerid )

			return StopSpectate( otherid );
	}
	
	HideDmgText( playerid );
	
	return true;
}

public OnPlayerEnterVehicle( playerid, vehicleid )
{
	if ( serverData[ s_rstarted ] )
	{
		loopPlayers( otherid )
		{
		    if ( GetPlayerState( otherid ) == PLAYER_STATE_SPECTATING && playerData[ otherid ][ p_spec ] == playerid )
			{
				TogglePlayerSpectating( otherid, 1 );

				PlayerSpectateVehicle ( otherid, vehicleid );

				playerData[ otherid ][ p_spectype ] = SPECTATE_VEHICLE;
			}
		}
		
		if( playerData[ playerid ][ p_team ] == defender )
		{
		    OnPlayerExitVehicle( playerid, vehicleid );

		    SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Defenders can't use vehicles." );
		}
	}
	return true;
}

public OnPlayerExitVehicle( playerid, vehicleid )
{
	if ( serverData[ s_rstarted ] )
	{
		loopPlayers( otherid )
  		{
			if ( roundVeh[ vehicleid ] )
			{
				if ( playerData[ otherid ][ p_team ] == defender )

					SetVehicleParamsForPlayer( vehicleid, otherid, false, true );

				if ( GetPlayerState( otherid ) == PLAYER_STATE_SPECTATING && playerData[ otherid ][ p_spec ] == playerid )
				{
					TogglePlayerSpectating( otherid, 1 );

					PlayerSpectatePlayer  ( otherid, playerid );

					playerData[ otherid ][ p_spectype ] = SPECTATE_PLAYER;
				}
			}
		}
	}
	return true;
}

public OnVehicleSpawn( vehicleid )
{
	DestroyVehicle( vehicleid );

	return true;
}

public OnPlayerSelectedMenuRow( playerid, row )
{
    if ( GetPlayerMenu( playerid ) == buildMenu[ 0 ] )
	{
		new info[ 70 ];

		switch( row )
        {
			case DM:
            {
				buildData[ playerid ][ c_editmode  ] = DM;
				buildData[ playerid ][ c_editarena ] = getHighestExists( DM );

				if ( buildData[ playerid ][ c_editarena ] >= MAX_DMS )
				{
					SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The dm limit was exceded." );

					buildData[ playerid ][ c_editmode  ] = -1;
					buildData[ playerid ][ c_editarena ] = -1;

					return false;
				}

				format( info, sizeof( info ), "(DM BUILD) You created DM %i, use /set for edit.", buildData[ playerid ][ c_editarena ] );

				SendClientMessage( playerid, BUILD_COLOR1, info );

				fileCreate( getFile( DM, buildData[ playerid ][ c_editarena ] ) );
			}
			case TDM:
            {
				buildData[ playerid ][ c_editmode  ] = TDM;
				buildData[ playerid ][ c_editarena ] = getHighestExists( TDM );

				if ( buildData[ playerid ][ c_editarena ] >= MAX_TDMS )
				{
					SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The tdm limit was exceded." );

					buildData[ playerid ][ c_editmode  ] = -1;
					buildData[ playerid ][ c_editarena ] = -1;

					return false;
				}

				format( info, sizeof( info ), "(TDM BUILD) You created TDM %i, use /set for edit.", buildData[ playerid ][ c_editarena ] );

				SendClientMessage( playerid, BUILD_COLOR1, info );

				fileCreate( getFile( TDM, buildData[ playerid ][ c_editarena ] ) );
			}
			case ARENA:
            {
				buildData[ playerid ][ c_editmode  ] = ARENA;
				buildData[ playerid ][ c_editarena ] = getHighestExists( ARENA );

				if ( buildData[ playerid ][ c_editarena ] >= MAX_ARENAS )
				{
					SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The arena limit was exceded." );

					buildData[ playerid ][ c_editmode  ] = -1;
					buildData[ playerid ][ c_editarena ] = -1;

					return false;
				}

				format( info, sizeof( info ), "(ARENA BUILD) You created arena %i, use /set for edit.", buildData[ playerid ][ c_editarena ] );

				SendClientMessage( playerid, BUILD_COLOR1, info );

				fileCreate( getFile( ARENA, buildData[ playerid ][ c_editarena ] ) );
			}
			case BASE:
            {
				buildData[ playerid ][ c_editmode  ] = BASE;
				buildData[ playerid ][ c_editarena ] = getHighestExists( BASE );

				if ( buildData[ playerid ][ c_editarena ] >= MAX_BASES )
				{
					SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The base limit was exceded." );

					buildData[ playerid ][ c_editmode  ] = -1;
					buildData[ playerid ][ c_editarena ] = -1;

					return false;
				}

				format( info, sizeof( info ), "(BASE BUILD) You created the base %i, use /set for edit.", buildData[ playerid ][ c_editarena ] );

				SendClientMessage( playerid, BUILD_COLOR1, info );

				fileCreate( getFile( BASE, buildData[ playerid ][ c_editarena ] ) );
			}
		 	default:
			{
				HideMenuForPlayer( buildMenu[ 0 ], playerid );
			}
		}
	}
 	else if ( GetPlayerMenu( playerid ) == buildMenu[ 1 ] )
   	{
	 	new info[ 45 ];

	 	switch( row )
	    {
	        case 0:
	        {
				SendClientMessage( playerid, BUILD_COLOR1, "(DM BUILD) Use (MOUSE2) for set the spawns. Use (C) to delete the spawns." );

				buildData[ playerid ][ c_cspawns    ] = false;
				buildData[ playerid ][ c_setspawns  ] = true;
				buildData[ playerid ][ c_spawncount ] = 0;
			}
	        case 1:
	        {
				SendClientMessage( playerid, BUILD_COLOR1, "(DM BUILD) Use (MOUSE2) to set the world bounds." );

				buildData[ playerid ][ c_cboundies     ] = false;
				buildData[ playerid ][ c_setboundies   ] = true;
				buildData[ playerid ][ c_boundiescount ] = 0;
			}
	        case 2:
	        {
				SendClientMessage( playerid, BUILD_COLOR1, "(DM BUILD) Use (MOUSE2) to set the startcamera." );

				buildData[ playerid ][ c_ccheckpoint   ] = false;
				buildData[ playerid ][ c_setcheckpoint ] = true;
			}
			case 3:
			{
				if ( buildData[ playerid ][ c_reediting ] )
				{
					format( info, sizeof( info ), "(DM BUILD) Arena %i was saved.", buildData[ playerid ][ c_editarena ] );
					
					SendClientMessage( playerid, BUILD_COLOR1, info );
					
					resetBuild( playerid );
				}
				else
				{
				 	if ( !buildData[ playerid ][ c_cspawns     ] ) { SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't set the random spawns." ); ShowMenuForPlayer( buildMenu[ 1 ], playerid ); return true; }

					if ( !buildData[ playerid ][ c_cboundies   ] ) { SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't set the world bounds."  ); ShowMenuForPlayer( buildMenu[ 1 ], playerid ); return true; }

					if ( !buildData[ playerid ][ c_ccheckpoint ] ) { SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't set the start camera."  ); ShowMenuForPlayer( buildMenu[ 1 ], playerid ); return true; }

					format( info, sizeof( info ), "(DM BUILD) Arena %i has been saved.", buildData[ playerid ][ c_editarena ] );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					resetBuild( playerid );
				}
			}
			case 4:
			{
				format( info, sizeof( info ), "(DM BUILD) Arena %i has been deleted.", buildData[ playerid ][ c_editarena ] );

				SendClientMessage( playerid, BUILD_COLOR1, info );

				resetBuild( playerid );

				fremove( getFile( DM, buildData[ playerid ][ c_editarena ] ) );
			}
		}
	}
	else if ( GetPlayerMenu( playerid ) == buildMenu[ 2 ] || GetPlayerMenu( playerid ) == buildMenu[ 3 ] )
   	{
		new mode[ 6 ], info[ 100 ];
		
		if      ( buildData[ playerid ][ c_editmode ] == TDM   )  mode = "TDM";
		else if ( buildData[ playerid ][ c_editmode ] == ARENA )  mode = "ARENA";

	 	switch( row )
	    {
	        case 0:
	        {
				format( info, sizeof( info ), "(%s BUILD) Use (MOUSE2) for set the spawns. Use (C) for delete the spawns.", mode );
				SendClientMessage( playerid, BUILD_COLOR1, info );

				buildData[ playerid ][ c_cspawns    ] = false;
				buildData[ playerid ][ c_setspawns  ] = true;
				buildData[ playerid ][ c_spawncount ] = 0;
			}
	        case 1:
	        {
				format( info, sizeof( info ), "(%s BUILD) Use (MOUSE2) for set the world bounds.", mode );
				SendClientMessage( playerid, BUILD_COLOR1, info );

				buildData[ playerid ][ c_cboundies     ] = false;
				buildData[ playerid ][ c_setboundies   ] = true;
				buildData[ playerid ][ c_boundiescount ] = 0;
			}
	        case 2:
	        {
				format( info, sizeof( info ), "(%s BUILD) Use (MOUSE2) for set the startcamera.", mode );
				SendClientMessage( playerid, BUILD_COLOR1, info );

				buildData[ playerid ][ c_ccheckpoint   ] = false;
				buildData[ playerid ][ c_setcheckpoint ] = true;
			}
			case 3:
			{
				if ( buildData[ playerid ][ c_reediting ] )
				{
					format( info, sizeof( info ), "(%s BUILD) Arena %i has been saved.", mode, buildData[ playerid ][ c_editarena ] );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					resetBuild( playerid );
				}
				else
				{
				 	if ( !buildData[ playerid ][ c_cspawns     ] ) { SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't set the team spawns."  ); ShowMenuForPlayer( buildMenu[ buildData[ playerid ][ c_editmode ] + 1 ], playerid ); return true; }

					if ( !buildData[ playerid ][ c_cboundies   ] ) { SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't set the world bounds." ); ShowMenuForPlayer( buildMenu[ buildData[ playerid ][ c_editmode ] + 1 ], playerid ); return true; }

					if ( !buildData[ playerid ][ c_ccheckpoint ] ) { SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't set the start camera."   ); ShowMenuForPlayer( buildMenu[ buildData[ playerid ][ c_editmode ] + 1 ], playerid ); return true; }

					format( info, sizeof( info ), "(%s BUILD) Arena %i has been saved.", mode, buildData[ playerid ][ c_editarena ] );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					resetBuild( playerid );
				}
			}
			case 4:
			{
				format( info, sizeof( info ), "(%s BUILD) Arena %i has been deleted.", buildData[ playerid ][ c_editarena ] );

				SendClientMessage( playerid, BUILD_COLOR1, info );

				resetBuild( playerid );

				fremove( getFile( buildData[ playerid ][ c_editmode ], buildData[ playerid ][ c_editarena ] ) );
			}
		}
	}
   	else if( GetPlayerMenu( playerid ) == buildMenu[ 4 ] )
   	{
		new info[ 100 ];

		switch( row )
	    {
		    case 0:
	        {
				SendClientMessage( playerid, BUILD_COLOR1, "(BASE BUILD) Use (MOUSE2) for set the spawns. Use (C) for delete the spawns." );

				buildData[ playerid ][ c_cspawns    ] = false;
				buildData[ playerid ][ c_setspawns  ] = true;
				buildData[ playerid ][ c_spawncount ] = 0;
			}
			case 1:
			{
				SendClientMessage( playerid, BUILD_COLOR1, "(BASE BUILD) Use (MOUSE2) for set the checkpoint." );

				buildData[ playerid ][ c_ccheckpoint   ] = false;
				buildData[ playerid ][ c_setcheckpoint ] = true;
			}
			case 2:
			{
				if ( buildData[ playerid ][ c_reediting ] )
				{
					format( info, sizeof( info ), "(BASE BUILD) Base %i has been saved.", buildData[ playerid ][ c_editarena ] );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					resetBuild( playerid );
				}
				else
				{
				 	if ( !buildData[ playerid ][ c_cspawns     ] ) { SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't setted the spawns."    ); ShowMenuForPlayer( buildMenu[ 4 ], playerid ); return true; }
					if ( !buildData[ playerid ][ c_ccheckpoint ] ) { SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't set the checkpoint."   ); ShowMenuForPlayer( buildMenu[ 4 ], playerid ); return true; }

					format( info, sizeof( info ), "(BASE BUILD) Base %i has been saved.", buildData[ playerid ][ c_editarena ] );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					resetBuild( playerid );
				}
			}
			case 3:
			{
				format( info, sizeof( info ), "(BASE BUILD) Base %i has been deleted.", buildData[ playerid ][ c_editarena ] );

				SendClientMessage( playerid, BUILD_COLOR1, info );

				resetBuild( playerid );

				fremove( getFile( BASE, buildData[ playerid ][ c_editarena ] ) );
			}
		}
	}
  	else if ( GetPlayerMenu( playerid ) == switchMenu )
    {
		if ( playerData[ playerid ][ p_spawn ] != LOBBY )
		    return false;

     	new info[ 80 ];

		switch( row )
        {
            case 0..2:
            {
				playerData[ playerid ][ p_team ] = row;
				playerData[ playerid ][ p_sub  ] = false;

				SetPlayerColor( playerid, teamColor[ row ][ 0 ] );

				playerData[ playerid ][ p_syncwait ] = true;
				SyncPlayer( playerid );

				format( info, sizeof( info ), "*** \"%s\" has switched to \"%s\".", playerData[ playerid ][ p_name ], teamName[ row ] );

				SendClientMessageToAll( teamColor[ row ][ 1 ], info );
				
				if( row == REF ) TextDrawSetString( rdmgtxd[ playerid ], "" );
		    }
            case 3..4:
            {
				playerData[ playerid ][ p_team ] = row - 3;
				playerData[ playerid ][ p_sub  ] = true;

				SetPlayerColor( playerid, SUB_COLOR );

				playerData[ playerid ][ p_syncwait ] = true;
				SyncPlayer( playerid );

				format( info, sizeof( info ), "*** \"%s\" has switched to \"%s\" (SUB).", playerData[ playerid ][ p_name ], teamName[ row - 3 ] );

				SendClientMessageToAll( teamColor[ row - 3 ][ 0 ], info );
		    }
   		}
	}
	return true;
}

public OnPlayerExitedMenu( playerid )
{
	if ( GetPlayerMenu( playerid ) == switchMenu )

		HideMenuForPlayer( switchMenu, playerid );

	return true;
}

public OnPlayerKeyStateChange( playerid, newkeys, oldkeys )
{
	if( newkeys & KEY_YES && playerData[ playerid ][ p_level ] >= 1 && serverData[ s_rstarted ] && !serverData[ s_rstarting ] )
	{
		new info[ 60 ];
		
		if( !serverData[ s_rpaused ] )
		{
			loopPlayers( otherid )
			{
		    	if ( playerData[ otherid ][ p_spawn ] != LOBBY && GetPlayerState( otherid ) != PLAYER_STATE_WASTED )

					TogglePlayerControllable( otherid, 0 );
			}

			serverData[ s_rpaused ] = true;

			format( info, sizeof( info ), "*** Admin \"%s\" has paused the round.", playerData[ playerid ][ p_name ] );
		}
		else if( serverData[ s_rpaused ] )
		{
			unpauseCounting(  );

			format( info, sizeof( info ), "*** Admin \"%s\" has unpaused the round.", playerData[ playerid ][ p_name ] );
		}
		
		SendClientMessageToAll( ADMIN_COLOR, info );
	}

	if (( oldkeys == KEY_HANDBRAKE || oldkeys == KEY_JUMP || oldkeys == 0 ) && newkeys == KEY_HANDBRAKE + KEY_JUMP && !GetPlayerWeapon( playerid ) )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command" );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( IsPlayerInAnyVehicle( playerid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Leave the vehicle first." );

		if ( playerData[ playerid ][ p_syncwait ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You are already syncing." );

		if ( playerData[ playerid ][ p_starting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_spawn ] > LOBBY && serverData[ s_rpaused ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_selecting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't sync in duels." );

		if( playerData[ playerid ][ p_justsync ] == 0 )
		{
		playerData[ playerid ][ p_syncwait ] = true;

	    SetTimerEx( "SyncPlayer2", syncTimer, false, "i", playerid );

		playerData[ playerid ][ p_justsync ] = 1;

		SetTimerEx( "JustSyncFalse", 1000, false, "i", playerid );

			loopPlayers( specid )
			{
		    	if( playerData[ specid ][ p_spec ] == playerid )
		    
		   	    	SetTimerEx( "StartSpectate", syncTimer+400, false, "ii", specid, playerid );
			}
		}
		else SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You need to wait 1 seconds for sync again.");

	return true;
	}

	if ( newkeys == KEY_FIRE )
	{
		if ( buildData[ playerid ][ c_editarena ] != -1 )
		{
			new info[ 128 ], file1[ 32 ], file2[ 75 ];

			new Float:x, Float:y, Float:z, Float:r;

			GetPlayerPos( playerid, x, y, z );

			GetPlayerFacingAngle( playerid, r );

			if ( buildData[ playerid ][ c_editmode ] == DM )
			{
				if ( buildData[ playerid ][ c_setspawns ] )
				{
					format( info, sizeof( info ), "(DM BUILD) Spawn setted (ID:%i).", buildData[ playerid ][ c_spawncount ] );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					format( file1, sizeof( file1 ), "DmPos%02i", buildData[ playerid ][ c_spawncount ] );

					format( file2, sizeof( file2 ), "%.3f %.3f %.3f %.3f", x, y, z, r );

					fileSet( getFile( DM, buildData[ playerid ][ c_editarena ] ), file1, file2 );

					PlayerPlaySound( playerid, 1084, 0, 0, 0 );

					buildData[ playerid ][ c_spawncount ] ++;

				    if ( buildData[ playerid ][ c_spawncount ] == sizeof RSpawns )
					{
					    SendClientMessage( playerid, BUILD_COLOR2, "(DM BUILD) The spawns has been saved, use /set for still editing." );

						buildData[ playerid ][ c_cspawns    ] = true;
						buildData[ playerid ][ c_setspawns  ] = false;
						buildData[ playerid ][ c_spawncount ] = -1;
					}
				}

				else if ( buildData[ playerid ][ c_setboundies ] )
				{
				    if ( !buildData[ playerid ][ c_boundiescount ] )
					{
						SendClientMessage( playerid, BUILD_COLOR1, "(DM BUILD) X-min saved, go to Y-max and use (MOUSE1)." );

						format( file1, sizeof( file1 ), "%.3f %.3f", x, y );

						fileSet( getFile( DM, buildData[ playerid ][ c_editarena ] ), "MinX", file1 );

						PlayerPlaySound( playerid, 1084, 0, 0, 0 );

						buildData[ playerid ][ c_boundiescount ] ++;
					}
					else
					{
						SendClientMessage( playerid, BUILD_COLOR1, "(DM BUILD) X-min and Y-max saved, use /set for still editing." );

						format( file1, sizeof( file1 ), "%.3f %.3f", x, y );

						fileSet( getFile( DM, buildData[ playerid ][ c_editarena ] ), "MaxY", file1 );

						buildData[ playerid ][ c_cboundies     ] = true;
						buildData[ playerid ][ c_setboundies   ] = false;
						buildData[ playerid ][ c_boundiescount ] = -1;

						PlayerPlaySound( playerid, 1084, 0, 0, 0 );
					}
			  	}
				else if ( buildData[ playerid ][ c_setcheckpoint ] )
				{
					SendClientMessage( playerid, BUILD_COLOR1, "(DM BUILD) Start camera saved, use /set for still editing." );

					format( file1, sizeof( file1 ), "%.3f %.3f %.3f", x, y, z );

					fileSet( getFile( DM, buildData[ playerid ][ c_editarena ] ), "StartCam", file1 );
					fileSet( getFile( DM, buildData[ playerid ][ c_editarena ] ), "Interior", intstr( GetPlayerInterior( playerid ) ) );

					buildData[ playerid ][ c_ccheckpoint   ] = true;
					buildData[ playerid ][ c_setcheckpoint ] = false;

					PlayerPlaySound( playerid, 1084, 0, 0, 0 );
				}
			}
			else if ( buildData[ playerid ][ c_editmode ] == ARENA || buildData[ playerid ][ c_editmode ] == TDM )
			{
				new mode[ 6 ];

				if      ( buildData[ playerid ][ c_editmode ] == TDM   )  mode = "TDM";
				else if ( buildData[ playerid ][ c_editmode ] == ARENA )  mode = "ARENA";

				if ( buildData[ playerid ][ c_setspawns ] )
				{
					format( info, sizeof( info ), "(%s BUILD) Spawn setado (%s).", mode, buildData[ playerid ][ c_spawncount ] ? ( "HOME" ) : ( "AWAY" ) );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					format( file1, sizeof( file1 ), "TeamPos%02i",  buildData[ playerid ][ c_spawncount ] );
					format( file2, sizeof( file2 ), "%.3f %.3f %.3f %.3f", x, y, z, r );

					fileSet( getFile( buildData[ playerid ][ c_editmode ], buildData[ playerid ][ c_editarena ] ), file1, file2 );

					PlayerPlaySound( playerid, 1084, 0, 0, 0 );

					buildData[ playerid ][ c_spawncount ] ++;

				    if ( buildData[ playerid ][ c_spawncount ] == 2 )
					{
						format( info, sizeof( info ), "(%s BUILD) The spawns has been saved, use /set for still editing.", mode );

						SendClientMessage( playerid, BUILD_COLOR1, info );

						buildData[ playerid ][ c_cspawns    ] = true;
						buildData[ playerid ][ c_setspawns  ] = false;
						buildData[ playerid ][ c_spawncount ] = -1;
					}
				}
				else if ( buildData[ playerid ][ c_setboundies ] )
				{
				    if ( !buildData[ playerid ][ c_boundiescount ] )
					{
						format( info, sizeof( info ), "(%s BUILD) X-min saved, go to Y-max and use (MOUSE1).", mode );

						SendClientMessage( playerid, BUILD_COLOR1, info );

						format( file1, sizeof( file1 ), "%.3f %.3f", x, y );

						fileSet( getFile( buildData[ playerid ][ c_editmode ], buildData[ playerid ][ c_editarena ] ), "MinX", file1 );

						PlayerPlaySound( playerid, 1084, 0, 0, 0 );

						buildData[ playerid ][ c_boundiescount ] ++;
					}
					else
					{
						format( info, sizeof( info ), "(%s BUILD) X-min and Y-max saved, use /set for still editing.", mode );

						SendClientMessage( playerid, BUILD_COLOR1, info );

						format( file1, sizeof( file1 ), "%.3f %.3f", x, y );

						fileSet( getFile( buildData[ playerid ][ c_editmode ], buildData[ playerid ][ c_editarena ] ), "MaxY", file1 );

						buildData[ playerid ][ c_cboundies   ] = true;
						buildData[ playerid ][ c_setboundies ] = false;
						buildData[ playerid ][ c_spawncount  ] = -1;

						PlayerPlaySound( playerid, 1084, 0, 0, 0 );
					}
			  	}
				else if ( buildData[ playerid ][ c_setcheckpoint ] )
				{
					format( info, sizeof( info ), "(%s BUILD) Camera saved, use /set for still editing.", mode );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					format( file1, sizeof( file1 ), "%.3f %.3f %.3f", x, y, z );

					fileSet( getFile( buildData[ playerid ][ c_editmode ], buildData[ playerid ][ c_editarena ] ), "StartCam", file1 );
					fileSet( getFile( buildData[ playerid ][ c_editmode ], buildData[ playerid ][ c_editarena ] ), "Interior", intstr( GetPlayerInterior( playerid ) ) );

					buildData[ playerid ][ c_ccheckpoint   ] = true;
					buildData[ playerid ][ c_setcheckpoint ] = false;

					PlayerPlaySound( playerid, 1084, 0, 0, 0 );
				}
			}
			else if ( buildData[ playerid ][ c_editmode ] == BASE )
			{
				if ( buildData[ playerid ][ c_setspawns ] )
				{
					format( info, sizeof( info ), "(BASE BUILD) Spawn setted (%s).", buildData[ playerid ][ c_spawncount ] ? ( "DEFEND" ) : ( "ATTACK" ) );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					format( file1, sizeof( file1 ), "TeamPos%02i", buildData[ playerid ][ c_spawncount ] );
					format( file2, sizeof( file2 ), "%.3f %.3f %.3f %.3f", x, y, z, r );

					fileSet( getFile( BASE, buildData[ playerid ][ c_editarena ] ), file1, file2 );

					PlayerPlaySound( playerid, 1084, 0, 0, 0 );

					buildData[ playerid ][ c_spawncount ] ++;

				    if ( buildData[ playerid ][ c_spawncount ] == 2 )
					{
					    SendClientMessage( playerid, BUILD_COLOR2, "(BASE BUILD) The spawn has been saved, use /set for still editing." );

						buildData[ playerid ][ c_cspawns    ] = true;
						buildData[ playerid ][ c_setspawns  ] = false;
						buildData[ playerid ][ c_spawncount ] = -1;
					}
				}
				else if ( buildData[ playerid ][ c_setcheckpoint ] )
				{
					SendClientMessage( playerid, BUILD_COLOR1, "(BASE BUILD) El checkpoint has been saved, use /set for still editing." );

					format( file1, sizeof( file1 ), "%.3f %.3f %.3f", x, y, z );

					fileSet( getFile( BASE, buildData[ playerid ][ c_editarena ] ), "Checkpoint", file1 );
					fileSet( getFile( BASE, buildData[ playerid ][ c_editarena ] ), "Interior", intstr( GetPlayerInterior( playerid ) ) );

					buildData[ playerid ][ c_ccheckpoint   ] = true;
					buildData[ playerid ][ c_setcheckpoint ] = false;

					PlayerPlaySound( playerid, 1084, 0, 0, 0 );
				}
			}
	  	}
		else if ( playerData[ playerid ][ p_viewing ] > -1 )
		{
			new info[ 128 ];

		 	playerData[ playerid ][ p_viewing ]--;

			if ( playerData[ playerid ][ p_viewing ] < 0 )
				playerData[ playerid ][ p_viewing ] = getHighest( playerData[ playerid ][ p_viewmod ] );

			if ( fexist( getFile( playerData[ playerid ][ p_viewmod ], playerData[ playerid ][ p_viewing ] ) ) )
		  	{
				new entry[ 12 ], Float:xyz[ 4 ], index;

				entry = playerData[ playerid ][ p_viewmod ] == BASE ? ( "Checkpoint" ) : ( "StartCam" );

				info = fileGet( getFile( playerData[ playerid ][ p_viewmod ], playerData[ playerid ][ p_viewing ] ), entry );

				for( new i;  i < 3; i ++ )

					xyz[ i ] = floatstr( strtok( info, index ) );

				index = 0;

				info = fileGet( getFile( playerData[ playerid ][ p_viewmod ], playerData[ playerid ][ p_viewing ] ), "Interior" );

				xyz[ 3 ] = floatstr( strtok( info, index ) );

				SetPlayerPos     ( playerid, xyz[ 0 ], xyz[ 1 ], xyz[ 2 ] );
				SetPlayerInterior( playerid, floatround( xyz[ 3 ] ) );

				SetPlayerCameraPos      ( playerid, xyz[ 0 ] + 50, xyz[ 1 ] + 50, xyz[ 2 ] + 50 );
				SetPlayerCameraLookAt   ( playerid, xyz[ 0 ],      xyz[ 1 ],      xyz[ 2 ] );
				TogglePlayerControllable( playerid, 0 );

				format( info, sizeof( info ), "~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~w~~h~%i", playerData[ playerid ][ p_viewing ] );

				GameTextForPlayer( playerid, info, 5000, 3 );
			}
		}
	}
	else if ( newkeys == KEY_HANDBRAKE )
	{
		if ( playerData[ playerid ][ p_viewing ] > -1 )
		{
			new info[ 128 ];

		 	playerData[ playerid ][ p_viewing ] ++;

			if ( playerData[ playerid ][ p_viewing ] > getHighest( playerData[ playerid ][ p_viewmod ] ) )
				playerData[ playerid ][ p_viewing ] = 0;

			if ( fexist( getFile( playerData[ playerid ][ p_viewmod ], playerData[ playerid ][ p_viewing ] ) ) )
		  	{
				new entry[ 12 ], Float:xyz[ 4 ], index;

				entry = playerData[ playerid ][ p_viewmod ] == BASE ? ( "Checkpoint" ) : ( "StartCam" );

				info = fileGet( getFile( playerData[ playerid ][ p_viewmod ], playerData[ playerid ][ p_viewing ] ), entry );

				for( new i;  i < 3; i ++ )

					xyz[ i ] = floatstr( strtok( info, index ) );

				index = 0;

				info = fileGet( getFile( playerData[ playerid ][ p_viewmod ], playerData[ playerid ][ p_viewing ] ), "Interior" );

				xyz[ 3 ] = floatstr( strtok( info, index ) );

				SetPlayerPos     ( playerid, xyz[ 0 ], xyz[ 1 ], xyz[ 2 ] );
				SetPlayerInterior( playerid, floatround( xyz[ 3 ] ) );

				SetPlayerCameraPos      ( playerid, xyz[ 0 ] + 50, xyz[ 1 ] + 50, xyz[ 2 ] + 50 );
				SetPlayerCameraLookAt   ( playerid, xyz[ 0 ],      xyz[ 1 ],      xyz[ 2 ] );
				TogglePlayerControllable( playerid, 0 );

				format( info, sizeof( info ), "~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~w~~h~%i", playerData[ playerid ][ p_viewing ] );

				GameTextForPlayer( playerid, info, 5000, 3 );
			}
		}
	}
	else if ( newkeys == KEY_CROUCH )
	{
		if ( buildData[ playerid ][ c_editarena ] != -1 )
		{
			new info[ 128 ];

			if ( buildData[ playerid ][ c_setspawns ] )
			{
				if ( buildData[ playerid ][ c_editmode ] == DM )
				{
				    if ( !buildData[ playerid ][ c_spawncount ] )
						return SendClientMessage( playerid, ERROR_COLOR, "(ERRROR) You didn't set any spawn." );

					format( info, sizeof( info ), "(DM BUILD) Spawn removed (ID:%i).", buildData[ playerid ][ c_spawncount ] );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					buildData[ playerid ][ c_spawncount ] --;

					PlayerPlaySound( playerid, 1084, 0, 0, 0 );
				}
				else
				{
				    if ( !buildData[ playerid ][ c_spawncount ] )
						return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You didn't set any spawn." );

					new MODE[ 6 ];

					if      ( buildData[ playerid ][ c_editmode ] == TDM   ) MODE = "TDM";

					else if ( buildData[ playerid ][ c_editmode ] == ARENA ) MODE = "ARENA";

					else if ( buildData[ playerid ][ c_editmode ] == BASE  ) MODE = "BASE";

					format( info, sizeof( info ), "(%s BUILD) Spawn removed.", MODE, buildData[ playerid ][ c_spawncount ] );

					SendClientMessage( playerid, BUILD_COLOR1, info );

					buildData[ playerid ][ c_spawncount ] --;

					PlayerPlaySound( playerid, 1084, 0, 0, 0 );
				}
			}
		}
	}
	else if ( newkeys == KEY_SPRINT )
	{
		if ( playerData[ playerid ][ p_viewing ] > -1 )
		{
			playerData[ playerid ][ p_viewing ] = -1;

			playerData[ playerid ][ p_viewmod ] = -1;

			TogglePlayerControllable( playerid, 1 );

			SetCameraBehindPlayer   ( playerid );
		}
	}
	
	if( playerData[ playerid ][ p_spec ] >= 0 )
	{
	    if( newkeys == KEY_SPRINT )
	    
	        return StopSpectate( playerid );
	        
	    if( newkeys == KEY_FIRE )
	    {
	        if( playerData[ playerid ][ p_team ] == REF )
	        {
				loopPlayers( otherid )
				{
				    if( otherid > playerData[ playerid ][ p_spec ] && playerData[ otherid ][ p_inround ] )
						continue;

					TextDrawHideForPlayer( playerid, dmgtxt[0][ playerData[playerid][p_spec] ] );
					TextDrawHideForPlayer( playerid, dmgtxt[1][ playerData[playerid][p_spec] ] );

					StartSpectate( playerid, otherid );

					new string[ 140 ];

					format( string, sizeof( string ), "~b~%s <~w~ID:%d~b~>~n~_~n~~b~~h~Armour ~w~%.0f~n~~b~~h~Health ~w~%.0f~n~~b~~h~Dmg ~w~%.0f~n~~b~~h~Kills ~w~%d~n~~b~~h~Packetloss: ~w~%.0f", playerData[ otherid ][ p_name ], otherid,  playerData[ otherid ][ p_armour ], playerData[ otherid ][ p_health ], playerData[ otherid ][ p_rounddmg ], playerData[ otherid ][ p_rkills ], GetPlayerPacketLoss( otherid ) );

					TextDrawSetString( SpecBox[ playerid ][ 0 ], string );
				}
	        }
	        else
	        {
				loopPlayers( otherid )
				{
				    if( otherid > playerData[ playerid ][ p_spec ] && playerData[ playerid ][ p_team ] == playerData[ otherid ][ p_team ] && playerData[ otherid ][ p_inround ] )
						continue;
						
					TextDrawHideForPlayer( playerid, dmgtxt[0][ playerData[playerid][p_spec] ] );
					TextDrawHideForPlayer( playerid, dmgtxt[1][ playerData[playerid][p_spec] ] );
					
					StartSpectate( playerid, otherid );

					new string[ 140 ];

					format( string, sizeof( string ), "~b~%s <~w~ID:%d~b~>~n~_~n~~b~~h~Armour ~w~%.0f~n~~b~~h~Health ~w~%.0f~n~~b~~h~Dmg ~w~%.0f~n~~b~~h~Kills ~w~%d~n~~b~~h~Packetloss: ~w~%.0f", playerData[ otherid ][ p_name ], otherid,  playerData[ otherid ][ p_armour ], playerData[ otherid ][ p_health ], playerData[ otherid ][ p_rounddmg ], playerData[ otherid ][ p_rkills ], GetPlayerPacketLoss( otherid ) );

					TextDrawSetString( SpecBox[ playerid ][ 0 ], string );
				}
	        }
	    
	    }
	    if( newkeys == KEY_HANDBRAKE )
	    {
	        if( playerData[ playerid ][ p_team ] == REF )
	        {
				loopPlayers( otherid )
				{
				    if( otherid < playerData[ playerid ][ p_spec ] && playerData[ otherid ][ p_inround ] )
				        continue;

					TextDrawHideForPlayer( playerid, dmgtxt[0][ playerData[playerid][p_spec] ] );
					TextDrawHideForPlayer( playerid, dmgtxt[1][ playerData[playerid][p_spec] ] );
					
					StartSpectate( playerid, otherid );

					new string[ 140 ];

					format( string, sizeof( string ), "~b~%s <~w~ID:%d~b~>~n~_~n~~b~~h~Armour ~w~%.0f~n~~b~~h~Health ~w~%.0f~n~~b~~h~Dmg ~w~%.0f~n~~b~~h~Kills ~w~%d~n~~b~~h~Packetloss: ~w~%.0f", playerData[ otherid ][ p_name ], otherid,  playerData[ otherid ][ p_armour ], playerData[ otherid ][ p_health ], playerData[ otherid ][ p_rounddmg ], playerData[ otherid ][ p_rkills ], GetPlayerPacketLoss( otherid ) );

					TextDrawSetString( SpecBox[ playerid ][ 0 ], string );
				}
	        }
	        else
	        {
				loopPlayers( otherid )
				{
				    if( otherid < playerData[ playerid ][ p_spec ] && playerData[ playerid ][ p_team ] == playerData[ otherid ][ p_team ] && playerData[ otherid ][ p_inround ] )
						continue;
						
					TextDrawHideForPlayer( playerid, dmgtxt[0][ playerData[playerid][p_spec] ] );
					TextDrawHideForPlayer( playerid, dmgtxt[1][ playerData[playerid][p_spec] ] );
					
					StartSpectate( playerid, otherid );

					new string[ 140 ];

					format( string, sizeof( string ), "~b~%s <~w~ID:%d~b~>~n~_~n~~b~~h~Armour ~w~%.0f~n~~b~~h~Health ~w~%.0f~n~~b~~h~Dmg ~w~%.0f~n~~b~~h~Kills ~w~%d~n~~b~~h~Packetloss: ~w~%.0f", playerData[ otherid ][ p_name ], otherid,  playerData[ otherid ][ p_armour ], playerData[ otherid ][ p_health ], playerData[ otherid ][ p_rounddmg ], playerData[ otherid ][ p_rkills ], GetPlayerPacketLoss( otherid ) );

					TextDrawSetString( SpecBox[ playerid ][ 0 ], string );
				}
	        }
	    }
	}
	return true;
}

public UpdateLabel( )
{
	loopPlayers( playerid )
	{
		new string[ 45 ];

		format( string, sizeof(string), "{FFFFFF}%d \r\n{40FF00}Ping:{FFFFFF} %d", GetPlayerFPS( playerid ), GetPlayerPing( playerid ) );

	    Update3DTextLabelText(PINGT[playerid], 0xFFFFFFFF, string );

	    new drunknew;
	    drunknew = GetPlayerDrunkLevel(playerid);

	    if (drunknew < 100) SetPlayerDrunkLevel(playerid, 2000);
	    
	    else if (pDrunkLevelLast[playerid] != drunknew)
		{
			new wfps = pDrunkLevelLast[playerid] - drunknew;

			if ((wfps > 0) && (wfps < 200)) playerData[ playerid ][ p_FPS ] = wfps;
	            
	        pDrunkLevelLast[playerid] = drunknew;
		}
		
	}
	return true;
}

public UpdateSpec( playerid )
{
    new otherid = playerData[ playerid ][ p_spec ], string[ 140 ];

	format( string, sizeof( string ), "~b~%s <~w~ID:%d~b~>~n~_~n~~b~~h~Armour ~w~%.0f~n~~b~~h~Health ~w~%.0f~n~~b~~h~Dmg ~w~%.0f~n~~b~~h~Kills ~w~%d~n~~b~~h~Packetloss: ~w~%.1f", playerData[ otherid ][ p_name ], otherid,  playerData[ otherid ][ p_armour ], playerData[ otherid ][ p_health ], playerData[ otherid ][ p_rounddmg ], playerData[ otherid ][ p_rkills ], GetPlayerPacketLoss( otherid ) );

	TextDrawSetString	  ( SpecBox[ playerid ][ 0 ], string );
	TextDrawShowForPlayer ( playerid, SpecBox[ playerid ][ 0 ] );
			
	ShowSpecWeaps		  ( playerid, otherid );
			
	return true;
}

public UpdateBars( playerid )
{
		static Float:Health, Float:Armour;
		
		GetPlayerHealth( playerid, Health );
		
		GetPlayerArmour( playerid, Armour );

		new Float:total = Health+Armour;
	
		if (  playerData[ playerid ][ p_inround ] )  setBarValue( playerData[ playerid ][ p_team ], FindPlayerBarSlot( playerid, playerData[ playerid ][ p_team ] ), total );	

	return true;
}

public UpdateMaintxt( playerid )
{
	static Float:Health, Float:Armour;
	
	SetPlayerScore ( playerid, floatround( Health + Armour ) );
	
	loopPlayers( otherid )
	{
		GetPlayerHealth( otherid, Health );
			
		GetPlayerArmour( otherid, Armour );

		if( serverData[ s_modetype ] > 2 )
		{
			teamData[ 0 ][ t_health ] = 0;
			teamData[ 1 ][ t_health ] = 0;
					
			teamData[ playerData[ otherid ][ p_team ] ][ t_health ] = teamData[ playerData[ otherid ][ p_team ] ][ t_health ] + floatround( Health + Armour );
		}
	}
}

public DestroyObjectEx( objectid )

    DestroyObject( objectid );
    
public FloodVar( playerid )

    playerData[ playerid ][ p_flooding ] = 0;
    
public JustSyncFalse( playerid )

   	playerData[ playerid ][ p_justsync ] = 0;
   	
public OnPlayerText( playerid, text[ ] )
{
 	if ( !playerData[ playerid ][ p_logged_in ] && playerData[ playerid ][ p_registered ] )
		return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You need to login first." ), false;

	if ( playerData[ playerid ][ p_muted ] )
		return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You are muted." ), false;

	if( playerData[ playerid ][ p_flooding ] == 1 )
	{
		SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Flood is not allowned." );

		return false;
	}
	else
		playerData[ playerid ][ p_flooding ] = 1,
		
		SetTimerEx( "FloodVar", 1000, false, "d", playerid );
		
   	if ( text[ 0 ] == '!' )
	{
    	new teamChat[ 128 ];

		format( teamChat, sizeof( teamChat ), "(TEAM) %s: %s", playerData[ playerid ][ p_name ], text[ 1 ] );

		loopPlayers( otherid )
		{
		    if ( playerData[ otherid ][ p_team ] != playerData[ playerid ][ p_team ] )
		        continue;

			SendClientMessage( otherid, teamColor[ playerData[ playerid ][ p_team ] ][ 0 ], teamChat );

			PlayerPlaySound( otherid, 1058, 0, 0, 0 );
		}

		return false;
	}

	if ( text[ 0 ] == '#' && playerData[ playerid ][ p_level ] )
	{
 		new adminChat[ 128 ];

		format( adminChat, sizeof( adminChat ), "(Admin Chat) %s: %s", playerData[ playerid ][ p_name ], text[ 1 ] );
		
		loopPlayers( otherid )
		{
		    if ( !playerData[ otherid ][ p_level ] )
		        continue;

			SendClientMessage( otherid, 0x87CEFFFF, adminChat );
		}

		return false;
	}

	if ( serverData[ s_chatlock ] )
		return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The chat is locked." ), false;

	return true;
}

public OnPlayerEnterCheckpoint( playerid )
{
    if ( playerData[ playerid ][ p_team ] == attacker && playerData[ playerid ][ p_inround ] && !IsPlayerInAnyVehicle( playerid ) )
    {
	    if ( !serverData[ s_capturing ] )
        {
			SetPlayerColor( playerid, 0xFFFFFFFF );

		  	serverData[ s_capturing ] = true;

	     	inCpPlayer = playerid;
    	}
	}
    if ( playerData[ playerid ][ p_team ] == defender && playerData[ playerid ][ p_inround ] )
    
	    if ( serverData[ s_capturing ] ) serverData[ s_cptime ] = checkTimer;
	    
    return true;
}

public OnPlayerLeaveCheckpoint( playerid )
{
    if ( playerData[ playerid ][ p_team ] == attacker && playerData[ playerid ][ p_inround ] )
    {
		if ( inCpPlayer == playerid )
  		{
			serverData[ s_cptime ] = checkTimer;

			SetPlayerColor( playerid, teamColor[ playerData[ playerid ][ p_team ] ][ 1 ] );

			TextDrawSetString( maintxt[ 2 ], "" );

		  	serverData[ s_capturing ] = false;
		}
	}
    return true;
}

/*public OnPlayerCommandText( playerid, cmdtext[ ] )
{
	// public
	dcmd(Pm		   , 2, cmdtext );
	dcmd(Register  , 8, cmdtext );
	dcmd(login     , 5, cmdtext );
	dcmd(cmd       , 3, cmdtext );
	dcmd(Scores    , 6, cmdtext );
	dcmd(Credits   , 7, cmdtext );
 	dcmd(Kill      , 4, cmdtext );
 	dcmd(Sync      , 4, cmdtext );
    dcmd(S         , 1, cmdtext );
	dcmd(V         , 1, cmdtext );
	dcmd(Switch    , 6, cmdtext );
	dcmd(Skin      , 4, cmdtext );
	dcmd(ResetSkin , 9, cmdtext );
	dcmd(Stats     , 5, cmdtext );
	dcmd(Duel      , 4, cmdtext );
	dcmd(Goto      , 4, cmdtext );
	dcmd(SaveP     , 5, cmdtext );
	dcmd(GotoP     , 5, cmdtext );
	dcmd(Readd     , 5, cmdtext );
	dcmd(Dance     , 5, cmdtext );
	dcmd(Spec      , 4, cmdtext );
	dcmd(Specoff   , 7, cmdtext );
	dcmd(View      , 4, cmdtext );
	dcmd(Int       , 3, cmdtext );
	dcmd(Tp        , 2, cmdtext );
	dcmd(Pass      , 4, cmdtext );
	dcmd(VColor    , 6, cmdtext );
	dcmd(admins    , 6, cmdtext );
	dcmd(fps       , 3, cmdtext );
	dcmd(netstats  , 8, cmdtext );
	dcmd(Radio     , 5, cmdtext );
	dcmd(JetPack   , 7, cmdtext );
	dcmd(test      , 4, cmdtext );
 	dcmd(MyWeather , 9,  cmdtext );
 	dcmd(MyTime    , 6,  cmdtext );

	// level 3

	dcmd(SetLevel     , 8,  cmdtext );
	dcmd(SetTempLevel ,12,  cmdtext );
 	dcmd(Create       , 6,  cmdtext );
 	dcmd(Edit         , 4,  cmdtext );
 	dcmd(Set          , 3,  cmdtext );
	dcmd(Delete       , 6,  cmdtext );
	dcmd(Lock         , 4,  cmdtext );
	dcmd(MainSpawn    , 9,  cmdtext );
	dcmd(SelectScreen , 12, cmdtext );
 	dcmd(Gmx          , 3,  cmdtext );

	// level 2

	dcmd(TeamName     , 8,  cmdtext );
	dcmd(TeamSkin     , 8,  cmdtext );
 	dcmd(AutoSwap     , 8,  cmdtext );
 	dcmd(PSkins       , 6,  cmdtext );
 	dcmd(ResetSkins   , 10, cmdtext );
 	dcmd(RoundTime    , 9,  cmdtext );
 	dcmd(CPTime       , 6,  cmdtext );
 	dcmd(STime        , 5,  cmdtext );
 	dcmd(Weather      , 7,  cmdtext );
 	dcmd(Time         , 4,  cmdtext );
 	dcmd(Weapons      , 7,  cmdtext );
 	dcmd(SetLimit     , 8,  cmdtext );
 	dcmd(PingLimit    , 9,  cmdtext );
 	dcmd(FPSmin       , 6,  cmdtext );
 	//dcmd(PacketLimit  , 11, cmdtext );
 	dcmd(ChatLock     , 8,  cmdtext );
 	dcmd(TeamScore    , 9,  cmdtext );
 	dcmd(ResetScores  , 11, cmdtext );
	dcmd(AllVs        , 5,  cmdtext );
 	dcmd(GiveMenu     , 8,  cmdtext );
 	dcmd(gunmenu      , 7,  cmdtext );
 	dcmd(SetHP        , 5,  cmdtext );
 	dcmd(SetAllHP     , 8,  cmdtext );
 	dcmd(Mute         , 4,  cmdtext );
 	dcmd(UnMute       , 6,  cmdtext );
 	dcmd(GiveGun      , 7,  cmdtext );
 	dcmd(knife        , 5,  cmdtext );
 	dcmd(roundlimit   , 10, cmdtext );
 	dcmd(cw           , 2,  cmdtext );
 	dcmd(GunAll       , 6,  cmdtext );
 	dcmd(ResetGuns    , 9,  cmdtext );
 	dcmd(ResetGunsAll , 12, cmdtext );
 	dcmd(Slap         , 4,  cmdtext );
 	dcmd(Explode      , 7,  cmdtext );
 	dcmd(Ban          , 3,  cmdtext );
 	dcmd(unBan        , 5,  cmdtext );
 	dcmd(Freeze       , 6,  cmdtext );
 	dcmd(unFreeze     , 8,  cmdtext );
 	dcmd(Move         , 4,  cmdtext );

	// level 1

 	dcmd(Admin   , 5, cmdtext );
 	dcmd(Start   , 5, cmdtext );
 	dcmd(End     , 3, cmdtext );
 	dcmd(Add     , 3, cmdtext );
 	dcmd(AddAll  , 6, cmdtext );
 	dcmd(Rem     , 3, cmdtext );
 	dcmd(Remove  , 6, cmdtext );
 	dcmd(SetTeam , 7, cmdtext );
 	dcmd(SetSub  , 6, cmdtext );
 	dcmd(Balance , 7, cmdtext );
 	dcmd(Random  , 6, cmdtext );
 	dcmd(Swap    , 4, cmdtext );
 	dcmd(Pause   , 5, cmdtext );
 	dcmd(UnPause , 7, cmdtext );
 	dcmd(Info    , 4, cmdtext );
	dcmd(Say     , 3, cmdtext );
	dcmd(Ann     , 3, cmdtext );
	dcmd(FSync   , 5, cmdtext );
 	dcmd(Kick    , 4, cmdtext );
 	dcmd(SetScore, 8, cmdtext );
 	
	return false;
}*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

encript( string[ ] )
{
	new i = -1;

	while ( string[ ++i ] )
	{
		string[ i ] += ( 3 ^ i ) * ( i % 15 );

		if ( string[ i ] > ( 0xff ) )

		string[ i ] -= 256;
	}

	return true;
}

decript( string[ ] )
{
	new i = -1;

	while ( string[ ++i ] )
	{
		string[ i ] -= ( 3 ^ i ) * ( i % 15 );

		if ( string[ i ] > ( 0xff ) )

		string[ i ] -= 256;
	}

	return true;
}

intstr( int )
{
	new str[ 8 ];

	valstr( str, int );

	return str;
}

getFile( mode, number )
{
	new search[ 24 ];

	switch ( mode )
	{
	    case DM:		 format( search, sizeof( search ), "ultimate/dms/%i.ini"   , number );

		case TDM: 		 format( search, sizeof( search ), "ultimate/tdms/%i.ini"  , number );

		case ARENA: 	 format( search, sizeof( search ), "ultimate/arenas/%i.ini", number );

		case BASE: 		 format( search, sizeof( search ), "ultimate/bases/%i.ini" , number );
	}

	return search;
}

getHighest( mode )
{
	new num, count;

	switch( mode )
	{
	    case DM: 		  num = MAX_DMS;

		case TDM:  	 	  num = MAX_TDMS;

		case ARENA:  	  num = MAX_ARENAS;

		case BASE: 		  num = MAX_BASES;
	}

	for ( new i; i < num; i ++ )
	{
		if ( fexist( getFile( mode, i ) ) )

			count ++;
	}
	return count;
}

getHighestExists( mode )
{
	new num, count;

	switch( mode )
	{
	    case DM: 		  num = MAX_DMS;

		case TDM:  	 	  num = MAX_TDMS;

		case ARENA:  	  num = MAX_ARENAS;

		case BASE: 		  num = MAX_BASES;
	}

	for ( new i; i < num; i ++ )
	{
		if ( fexist( getFile( mode, i ) ) )

			count ++;

		else break;
	}
	return count;
}

findWeapon( const search[ ] )
{
    for ( new i; i < MAX_WEAPONS; i ++ )
	{
        if ( i == 19 || i == 20 || i == 21 )
			continue;

		if ( strfind( weaponNames( i ), search, true ) != -1 )
			return i;
	}
	return -1;
}

updateMap(  )
{
	if ( serverData[ s_rstarted ] )
	{
		new map[ 32 ];

		switch( serverData[ s_modetype ] )
		{
			case DM:    format( map, sizeof( map ), "mapname DM: %i"    , current );

			case TDM:   format( map, sizeof( map ), "mapname TDM: %i"   , current );

			case ARENA: format( map, sizeof( map ), "mapname Arena: %i" , current );

			case BASE:  format( map, sizeof( map ), "mapname Base:: %i" , current );
		}

		SendRconCommand( map );
	}
	else
	 	SendRconCommand( "mapname Lobby" );
}

updateMode(  )
{
	if( !MatchMode ) 
		
		SetGameModeText( GM_NAME );
	
	else
	{
		new info[ 30 ];
		
		format( info, sizeof( info ), "%s %d - %s %d", teamName[ HOME ], teamData[ HOME ][ t_score ], teamName[ AWAY ], teamData[ AWAY ][ t_score ] );
		
		SetGameModeText( info );
	}

}

updateCount(  )
{
	teamData[ HOME ][ t_current ] = 0;
	teamData[ AWAY ][ t_current ] = 0;

	loopPlayers( playerid )
	{
		if      ( playerData[ playerid ][ p_team ] == HOME && !playerData[ playerid ][ p_sub ] ) teamData[ HOME ][ t_current ] ++;
		else if ( playerData[ playerid ][ p_team ] == AWAY && !playerData[ playerid ][ p_sub ] ) teamData[ AWAY ][ t_current ] ++;
    }

	if ( !serverData[ s_rstarting ] && !serverData[ s_rstarted ] )
	{
		TextDrawSetString( maintxt[ 2 ], "" );
	}
}

updateTeams(  )
{
	loopPlayers( playerid )
	{
		if ( serverData[ s_rstarted ] && serverData[ s_modetype ] > DM && playerData[ playerid ][ p_spawn ] > DM && ( playerData[ playerid ][ p_team ] != REF ) )
		{
			SetPlayerTeam( playerid, NO_TEAM );
			SetPlayerTeam( playerid, playerData[ playerid ][ p_team ] );
		}
		else
		{
			SetPlayerTeam( playerid, NO_TEAM );
			SetPlayerTeam( playerid, NO_TEAM );
		}
	}
}

showClassTextdraw( playerid, classid )
{
	new info[ 20 ];
	
	
	if( !classid )
	{
		TextDrawBackgroundColor( classtxt[ HOME ], -16776961);
		TextDrawBackgroundColor( classtxt[ AWAY ], 65535);
		TextDrawBackgroundColor( classtxt[ REF ], 7864575);
		
		format( info, sizeof( info ), "%s", teamName[ HOME ] );
			
		TextDrawSetString	  ( classtxt[ 0 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 0 ] );
		
		format( info, sizeof( info ), "%s", teamName[ AWAY ] );
			
		TextDrawSetString	  ( classtxt[ 1 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 1 ] );
		
		format( info, sizeof( info ), "%s", teamName[ REF ] );
			
		TextDrawSetString	  ( classtxt[ 2 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 2 ] );
	}
	else if( classid == 1 )
	{
		TextDrawBackgroundColor( classtxt[ REF ], -16776961);
		TextDrawBackgroundColor( classtxt[ HOME ], 65535);
		TextDrawBackgroundColor( classtxt[ AWAY ], 7864575);
		
		format( info, sizeof( info ), "%s", teamName[ AWAY ] );
			
		TextDrawSetString	  ( classtxt[ 0 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 0 ] );
		
		format( info, sizeof( info ), "%s", teamName[ REF ] );
			
		TextDrawSetString	  ( classtxt[ 1 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 1 ] );
		
		format( info, sizeof( info ), "%s", teamName[ HOME ] );
			
		TextDrawSetString	  ( classtxt[ 2 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 2 ] );
	}
	else if( classid == 2 )
	{
		TextDrawBackgroundColor( classtxt[ AWAY ], -16776961);
		TextDrawBackgroundColor( classtxt[ REF ], 65535);
		TextDrawBackgroundColor( classtxt[ HOME ], 7864575);
		
		format( info, sizeof( info ), "%s", teamName[ REF ] );
			
		TextDrawSetString	  ( classtxt[ 0 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 0 ] );
		
		format( info, sizeof( info ), "%s", teamName[ HOME ] );
			
		TextDrawSetString	  ( classtxt[ 1 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 1 ] );
		
		format( info, sizeof( info ), "%s", teamName[ AWAY ] );
			
		TextDrawSetString	  ( classtxt[ 2 ], info );
		TextDrawShowForPlayer ( playerid, classtxt[ 2 ] );
	}
}

IsSkinValid( skinid )
{

	if ( skinid < 0 || skinid >= 300 )
		return false;

	return true;
}

IsVehicleValid( vehicleid )
{
	switch( vehicleid )
	{
		case 407, 416, 425, 427, 430, 432, 441, 447, 449, 464, 465, 476, 479, 501,
		520, 537, 538, 552, 564, 569, 570, 577, 590, 591, 592, 594, 601, 606, 608,
		610: return false;
	}
	return true;
}

IsNosCompatible( vehicleid )
{
	switch( vehicleid )
	{
		case 417, 425, 430, 435, 441, 446, 447, 448, 449, 450, 452, 453, 454, 460, 461,
		462, 463, 464, 465, 468, 469, 472, 473, 476, 481, 484, 487, 488, 493, 497, 501,
		509, 510, 511, 512, 513, 519, 520, 521, 522, 523, 537, 538, 539, 548, 553, 563,
		564, 569, 570, 577, 581, 584, 586, 590, 591, 592, 593, 594, 595, 606, 607, 608,
		610, 611: return false;
	}
	return true;
}

/*SetPlayerBounds( playerid, Float:x_max, Float:x_min, Float:y_max, Float:y_min )
{
	playerData[ playerid ][ p_x_max ] = x_max;
	playerData[ playerid ][ p_x_min ] = x_min;
	playerData[ playerid ][ p_y_max ] = y_max;
	playerData[ playerid ][ p_y_min ] = y_min;

	return true;
}*/

stock CleanChat(  )
{
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
	SendClientMessageToAll( 0xFFFFFFFF, " " );
}

stock CleanKillList(  )
{
	SendDeathMessage( 255, 255, 255 );
	SendDeathMessage( 255, 255, 255 );
	SendDeathMessage( 255, 255, 255 );
	SendDeathMessage( 255, 255, 255 );
	SendDeathMessage( 255, 255, 255 );
}

public ClanWarFinal(  )
{
		CleanChat( );
		
		CleanKillList( );
		
		loopPlayers( playerid )
		{
			PlayAudioStreamForPlayer( playerid, FINAL_AUDIO );
			SetPlayerCameraPos	  ( playerid, -2812.91, 1157.25, 19.52 );
			SetPlayerCameraLookAt ( playerid, -2809.16, 1159.95, 21.42 );
			SetPlayerPos    	  ( playerid, -2812.91, 1157.25, 0 );
		}

		MatchMode = false;
		
		ShowFinalTxd( );

return true;
}

public PrepareFinalTxd(  )
{
	new string[ 40 ], str[ 11 ][ 80 ];

		format( string, sizeof( string ), "~r~~h~~h~%s %d ~w~- ~b~~h~%d %s", teamName[ HOME ], teamData[ HOME ][ t_score ], teamData[ AWAY ][ t_score ], teamName[ AWAY ] );

		TextDrawSetString( cfinaltxt[ 5 ], string );
	
	new Winner[ 80 ], Base[ 65 ], Type[ 80 ];

	for ( new i; i < RoundCounts; i ++ )
	{
		if( strval( ResultsW[ i ] ) == HOME ) format( Winner, sizeof(Winner), "%s~n~~r~~h~~h~%s", Winner, ResultsN[ i ] );
		
			else format( Winner, sizeof( Winner ), "%s~n~~b~~h~~h~%s", Winner, ResultsN[ i ] );
			
		format( Type, sizeof( Type ), "%s~n~%s", Type, ResultsT[ i ] );
		
		format( Base, sizeof( Base ), "%s~n~%i", Base, ResultsR[ i ] );
	}
	
	strcat( str[ 8 ], Winner ), strcat( str[ 9 ], Type ), strcat( str[ 10 ], Base );	

	loopPlayers( otherid )
	{
		if( playerData[ otherid ][ p_team ] == HOME )
	  	{
	   		format( string, sizeof( string ), "%s~h~~h~%s~n~", teamText[ HOME ], playerData[ otherid ][ p_name ]);
			strcat( str[ 0 ], string );
	   		format( string, sizeof( string ), "~w~%d~n~", playerData[ otherid ][ p_ckills ]);
			strcat( str[ 2 ], string );
   			format( string, sizeof( string ), "~w~%d~n~", playerData[ otherid ][ p_cdeaths ]);
			strcat( str[ 4 ], string );
   			format( string, sizeof( string ), "~w~%.0f~n~", playerData[ otherid ][ p_cdmg ] );
			strcat( str[ 6 ], string );
		}
 		else if( playerData[ otherid ][ p_team ] == AWAY )
  		{
   			format( string, sizeof( string ), "%s~h~~h~%s~n~", teamText[ AWAY ], playerData[ otherid ][ p_name ]);
      	 	strcat( str[ 1 ], string );
   			format( string, sizeof( string ), "~w~%d~n~", playerData[ otherid ][ p_ckills ]);
			strcat( str[ 3 ], string );
   			format( string, sizeof( string ), "~w~%d~n~", playerData[ otherid ][ p_cdeaths ]);
			strcat( str[ 5 ], string );
   			format( string, sizeof( string ), "~w~%.0f~n~", playerData[ otherid ][ p_cdmg ] );
			strcat( str[ 7 ] ,string );
		}
	}

	TextDrawSetString( cfinaltxt[ 11 ], str[ 0 ] ); TextDrawSetString( cfinaltxt[ 13 ], str[ 2 ] );
	TextDrawSetString( cfinaltxt[ 15 ], str[ 4 ] ); TextDrawSetString( cfinaltxt[ 16 ], str[ 6 ] );
	TextDrawSetString( cfinaltxt[ 12 ], str[ 1 ] ); TextDrawSetString( cfinaltxt[ 14 ], str[ 3 ] );
	TextDrawSetString( cfinaltxt[ 17 ], str[ 5 ] ); TextDrawSetString( cfinaltxt[ 18 ], str[ 7 ] );
	TextDrawSetString( cfinaltxt[ 10 ], str[ 8 ] ); TextDrawSetString( cfinaltxt[ 19 ], str[ 9 ] );
	TextDrawSetString( cfinaltxt[ 20 ], str[ 10 ]);

	return true;
}

public ShowFinalTxd( )
{
	for( new i; i < sizeof( cfinaltxt ); i ++  ) {

			TextDrawShowForAll( cfinaltxt[ i ] ); }

	SetTimer( "HideFinalTxd", 24000, false );
	
	for ( new i; i < RoundCounts; i ++ )
	{
		format( ResultsW[ i ],  30, "" );
		format( ResultsN[ i ],  30, "" );
		format( ResultsT[ i ],  30, "" );
		format( ResultsR[ i ],  30, "" );
	}
	return true;
}

public HideFinalTxd( )
{
	TextDrawSetString( cfinaltxt[ 10 ], "_" );
	TextDrawSetString( cfinaltxt[ 11 ], "_" );
	TextDrawSetString( cfinaltxt[ 13 ], "_" );
	TextDrawSetString( cfinaltxt[ 15 ], "_" );
	TextDrawSetString( cfinaltxt[ 16 ], "_" );
	TextDrawSetString( cfinaltxt[ 12 ], "_" );
	TextDrawSetString( cfinaltxt[ 14 ], "_" );
	TextDrawSetString( cfinaltxt[ 17 ], "_" );
	TextDrawSetString( cfinaltxt[ 18 ], "_" );
	TextDrawSetString( cfinaltxt[ 19 ], "_" );
	TextDrawSetString( cfinaltxt[ 20 ], "_" );

	loopPlayers( otherid )
	{
		PlayerPlaySound			( otherid, 1084, 0, 0, 0 );
		OnPlayerSpawn			( otherid );
		StopAudioStreamForPlayer( otherid );
		SetPlayerPos        	( otherid, mspawn[ 0 ], mspawn[ 1 ], mspawn[ 2 ] );
		SetPlayerInterior   	( otherid,	 floatround( mspawn[ 4 ] ) 			 );
		SetPlayerFacingAngle	( otherid, 			 mspawn[ 3 ] 		      	 );
		SetPlayerSpecialAction	( otherid, SPECIAL_ACTION_DANCE3 				 );
	}

	SendClientMessageToAll( ADMIN_COLOR, "*** Team scores have auto resetted." );

	teamData[ HOME ][ t_score ] = 0;
	teamData[ AWAY ][ t_score ] = 0;
	fileSet( CONFIG_FILE, "Team0Score", "0" );
	fileSet( CONFIG_FILE, "Team1Score", "0" );
	updateCount  (  );
	
	ShowScoresTxd(  );

	SendClientMessageToAll( ADMIN_COLOR, "*** Match mode off.");

	for( new i; i < sizeof( cfinaltxt ); i ++  )

		TextDrawHideForAll( cfinaltxt[ i ] );

	return true;
}

ShowSpecWeaps( playerid, specid )
{
        new count, string[ 128 ], ammo, weaponid;
		
            for (new c = 0; c < 13; c++)
            {
                GetPlayerWeaponData( specid, c, weaponid, ammo );
                if ( weaponid != 0 && ammo != 0 ) count++; 
            }
			format( string, sizeof(string), "Weapons~n~", string );
            if( count > 0 )
            {
                for (new c = 0; c < 13; c++)
                {
                    GetPlayerWeaponData( specid, c, weaponid, ammo);
                    if (weaponid != 0 && ammo != 0)
                    {
						format( string, sizeof( string ),"%s~y~~h~%s ~w~(%d)~n~",string, weaponNames( weaponid ), ammo );
						format( string, sizeof( string ), "%s", string );
                    }
                }
			    TextDrawSetString( SpecBox[ playerid ][ 1 ], string );

				TextDrawShowForPlayer( playerid, SpecBox[ playerid ][ 1 ] );
				
            }
            else
            {
				TextDrawSetString( SpecBox[ playerid ][ 1 ], "Weapons~n~~y~~h~The player~n~do not have~n~weapons" );
			
				TextDrawShowForPlayer( playerid, SpecBox[ playerid ][ 1 ] );
            }
    return true;
}

textsLoad(  )
{
	Scores = TextDrawCreate ( 566, 97," " );
	TextDrawLetterSize		( Scores, 0.28 , 1.4 );
	TextDrawSetOutline		( Scores, 1 );
	TextDrawSetProportional ( Scores, 1 );
	TextDrawAlignment		( Scores, 2 );
	TextDrawFont			( Scores, 1 );
	TextDrawBackgroundColor ( Scores, 0x29292767 );
	TextDrawColor			( Scores, 0x000000FF );

	letterbox[ 0 ] = TextDrawCreate( 320, 0, "~n~  ~n~" );
	TextDrawAlignment      ( letterbox[ 0 ], 2 );
	TextDrawUseBox         ( letterbox[ 0 ], 1 );
	TextDrawLetterSize     ( letterbox[ 0 ], 2.20, 3.50 );
	TextDrawTextSize       ( letterbox[ 0 ], 80.0, 1280 );
	TextDrawBoxColor       ( letterbox[ 0 ], 0x000000FF );

	letterbox[ 1 ] = TextDrawCreate( 320, 385, "~n~  ~n~" );
	TextDrawAlignment      ( letterbox[ 1 ], 2 );
	TextDrawUseBox         ( letterbox[ 1 ], 1 );
	TextDrawLetterSize     ( letterbox[ 1 ], 2.20, 3.50 );
	TextDrawTextSize       ( letterbox[ 1 ], 80.0, 1280 );
	TextDrawBoxColor       ( letterbox[ 1 ], 0x000000FF );

	maintxt[ 0 ] = TextDrawCreate( 320, 434, "~n~ ~n~" );
	TextDrawFont           ( maintxt[ 0 ], 1 );
	TextDrawAlignment      ( maintxt[ 0 ], 2 );
	TextDrawUseBox         ( maintxt[ 0 ], 1 );
	TextDrawLetterSize     ( maintxt[ 0 ], 0.27, 1.20 );
	TextDrawTextSize       ( maintxt[ 0 ], 640, 640   );
	TextDrawBoxColor       ( maintxt[ 0 ], 0x00000030 );

	maintxt[ 1 ] = TextDrawCreate( 320, 433.5, " " );
	TextDrawFont           ( maintxt[ 1 ], 1 );
	TextDrawAlignment      ( maintxt[ 1 ], 2 );
	TextDrawSetProportional( maintxt[ 1 ], 1 );
	TextDrawSetShadow      ( maintxt[ 1 ], 1 );
	TextDrawLetterSize     ( maintxt[ 1 ], 0.27, 1.20 );
	TextDrawBackgroundColor( maintxt[ 1 ], 0x00000099 );

	maintxt[ 2 ] = TextDrawCreate( 321, 410, " " );
	TextDrawFont           ( maintxt[ 2 ], 2 );
	TextDrawAlignment      ( maintxt[ 2 ], 2 );
	TextDrawSetProportional( maintxt[ 2 ], 1 );
	TextDrawSetShadow      ( maintxt[ 2 ], 1 );
	TextDrawLetterSize     ( maintxt[ 2 ], 0.32, 1.50 );
	TextDrawColor		   ( maintxt[ 2 ], -7601921 );
	TextDrawBackgroundColor( maintxt[ 2 ], 20 );

	finalboxtxt[ 0 ] = TextDrawCreate( 162, 103, "ld_poke:cd1c" );
	TextDrawBackgroundColor ( finalboxtxt[ 0 ], 255 );
	TextDrawFont			( finalboxtxt[ 0 ], 4 );
	TextDrawLetterSize		( finalboxtxt[ 0 ], 0, 1 );
	TextDrawColor			( finalboxtxt[ 0 ], 65 );
	TextDrawSetOutline		( finalboxtxt[ 0 ], 0 );
	TextDrawSetProportional ( finalboxtxt[ 0 ], 1 );
	TextDrawSetShadow		( finalboxtxt[ 0 ], 1 );
	TextDrawUseBox			( finalboxtxt[ 0 ], 1 );
	TextDrawBoxColor		( finalboxtxt[ 0 ], 255 );
	TextDrawTextSize		( finalboxtxt[ 0 ], 331, 210 );

	finalboxtxt[ 1 ] = TextDrawCreate( 187, 87, "ld_drv:goboat" );
	TextDrawBackgroundColor ( finalboxtxt[ 1 ], 255 );
	TextDrawFont			( finalboxtxt[ 1 ], 4 );
	TextDrawLetterSize		( finalboxtxt[ 1 ], 0.5, 1 );
	TextDrawColor			( finalboxtxt[ 1 ], -1 );
	TextDrawSetOutline		( finalboxtxt[ 1 ], 0 );
	TextDrawSetProportional ( finalboxtxt[ 1 ], 1 );
	TextDrawSetShadow		( finalboxtxt[ 1 ], 1 );
	TextDrawUseBox			( finalboxtxt[ 1 ], 1 );
	TextDrawBoxColor		( finalboxtxt[ 1 ], 255 );
	TextDrawTextSize		( finalboxtxt[ 1 ], 38, 38 );

	finalboxtxt[ 2 ] = TextDrawCreate( 427, 87, "ld_drv:naward" );
	TextDrawBackgroundColor ( finalboxtxt[ 2 ], 255 );
	TextDrawFont			( finalboxtxt[ 2 ], 4 );
	TextDrawLetterSize		( finalboxtxt[ 2 ], 0.5, 1 );
	TextDrawColor			( finalboxtxt[ 2 ], -1 );
	TextDrawSetOutline		( finalboxtxt[ 2 ], 0 );
	TextDrawSetProportional	( finalboxtxt[ 2 ], 1 );
	TextDrawSetShadow		( finalboxtxt[ 2 ], 1 );
	TextDrawUseBox			( finalboxtxt[ 2 ], 1 );
	TextDrawBoxColor		( finalboxtxt[ 2 ], 255 );
	TextDrawTextSize		( finalboxtxt[ 2 ], 38 , 38 );

	finalboxtxt[ 3 ] = TextDrawCreate(252.000000, 286.000000, "ld_poke:cd1c");
	TextDrawBackgroundColor(finalboxtxt[ 3 ], 255);
	TextDrawFont(finalboxtxt[ 3 ], 4);
	TextDrawLetterSize(finalboxtxt[ 3 ], 0.500000, 1.000000);
	TextDrawColor(finalboxtxt[ 3 ], 65);
	TextDrawSetOutline(finalboxtxt[ 3 ], 0);
	TextDrawSetProportional(finalboxtxt[ 3 ], 1);
	TextDrawSetShadow(finalboxtxt[ 3 ], 1);
	TextDrawUseBox(finalboxtxt[ 3 ], 1);
	TextDrawBoxColor(finalboxtxt[ 3 ], 255);
	TextDrawTextSize(finalboxtxt[ 3 ], 141.000000, 19.000000);

	finalboxtxt[ 4 ] = TextDrawCreate(252.000000, 262.000000, "ld_poke:cd1c");
	TextDrawBackgroundColor(finalboxtxt[ 4 ], 255);
	TextDrawFont(finalboxtxt[ 4 ], 4);
	TextDrawLetterSize(finalboxtxt[ 4 ], 0.500000, 1.000000);
	TextDrawColor(finalboxtxt[ 4 ], 65);
	TextDrawSetOutline(finalboxtxt[ 4 ], 0);
	TextDrawSetProportional(finalboxtxt[ 4 ], 1);
	TextDrawSetShadow(finalboxtxt[ 4 ], 1);
	TextDrawUseBox(finalboxtxt[ 4 ], 1);
	TextDrawBoxColor(finalboxtxt[ 4 ], 255);
	TextDrawTextSize(finalboxtxt[ 4 ], 141.000000, 19.000000);

	finalboxtxt[ 5 ] = TextDrawCreate(255.000000, 257.000000, "hud:radar_locosyndicate");
	TextDrawBackgroundColor(finalboxtxt[ 5 ], 255);
	TextDrawFont(finalboxtxt[ 5 ], 4);
	TextDrawLetterSize(finalboxtxt[ 5 ], 0.500000, 1.000000);
	TextDrawColor(finalboxtxt[ 5 ], -1);
	TextDrawSetOutline(finalboxtxt[ 5 ], 0);
	TextDrawSetProportional(finalboxtxt[ 5 ], 1);
	TextDrawSetShadow(finalboxtxt[ 5 ], 1);
	TextDrawUseBox(finalboxtxt[ 5 ], 1);
	TextDrawBoxColor(finalboxtxt[ 5 ], 255);
	TextDrawTextSize(finalboxtxt[ 5 ], 9.000000, 9.000000);

	finalboxtxt[ 6 ] = TextDrawCreate(255.000000, 281.000000, "hud:radar_emmetgun");
	TextDrawBackgroundColor(finalboxtxt[ 6 ], 255);
	TextDrawFont(finalboxtxt[ 6 ], 4);
	TextDrawLetterSize(finalboxtxt[ 6 ], 0.500000, 1.000000);
	TextDrawColor(finalboxtxt[ 6 ], -1);
	TextDrawSetOutline(finalboxtxt[ 6 ], 0);
	TextDrawSetProportional(finalboxtxt[ 6 ], 1);
	TextDrawSetShadow(finalboxtxt[ 6 ], 1);
	TextDrawUseBox(finalboxtxt[ 6 ], 1);
	TextDrawBoxColor(finalboxtxt[ 6 ], 255);
	TextDrawTextSize(finalboxtxt[ 6 ], 9.000000, 9.000000);

	finalboxtxt[ 7 ] = TextDrawCreate(266.000000, 257.000000, "Top Killer");
	TextDrawBackgroundColor(finalboxtxt[ 7 ], 255);
	TextDrawFont(finalboxtxt[ 7 ], 2);
	TextDrawLetterSize(finalboxtxt[ 7 ], 0.100000, 0.799999);
	TextDrawColor(finalboxtxt[ 7 ], -1);
	TextDrawSetOutline(finalboxtxt[ 7 ], 0);
	TextDrawSetProportional(finalboxtxt[ 7 ], 1);
	TextDrawSetShadow(finalboxtxt[ 7 ], 0);

	finalboxtxt[ 8 ] = TextDrawCreate(266.000000, 281.000000, "Top Damage");
	TextDrawBackgroundColor(finalboxtxt[ 8 ], 255);
	TextDrawFont(finalboxtxt[ 8 ], 2);
	TextDrawLetterSize(finalboxtxt[ 8 ], 0.100000, 0.799999);
	TextDrawColor(finalboxtxt[ 8 ], -1);
	TextDrawSetOutline(finalboxtxt[ 8 ], 0);
	TextDrawSetProportional(finalboxtxt[ 8 ], 1);
	TextDrawSetShadow(finalboxtxt[ 8 ], 0);

	finalboxtxt[ 9 ] = TextDrawCreate(182.000000, 133.000000, "ld_poke:cd1c");
	TextDrawBackgroundColor(finalboxtxt[ 9 ], 255);
	TextDrawFont(finalboxtxt[ 9 ], 4);
	TextDrawLetterSize(finalboxtxt[ 9 ], 0.500000, 1.000000);
	TextDrawColor(finalboxtxt[ 9 ], 65);
	TextDrawSetOutline(finalboxtxt[ 9 ], 0);
	TextDrawSetProportional(finalboxtxt[ 9 ], 1);
	TextDrawSetShadow(finalboxtxt[ 9 ], 1);
	TextDrawUseBox(finalboxtxt[ 9 ], 1);
	TextDrawBoxColor(finalboxtxt[ 9 ], 255);
	TextDrawTextSize(finalboxtxt[ 9 ], 141.000000, 121.000000);

	finalboxtxt[ 10 ] = TextDrawCreate(336.000000, 133.000000, "ld_poke:cd1c");
	TextDrawBackgroundColor(finalboxtxt[ 10 ], 255);
	TextDrawFont(finalboxtxt[ 10 ], 4);
	TextDrawLetterSize(finalboxtxt[ 10 ], 0.500000, 1.000000);
	TextDrawColor(finalboxtxt[ 10 ], 65);
	TextDrawSetOutline(finalboxtxt[ 10 ], 0);
	TextDrawSetProportional(finalboxtxt[ 10 ], 1);
	TextDrawSetShadow(finalboxtxt[ 10 ], 1);
	TextDrawUseBox(finalboxtxt[ 10 ], 1);
	TextDrawBoxColor(finalboxtxt[ 10 ], 255);
	TextDrawTextSize(finalboxtxt[ 10 ], 141.000000, 121.000000);

	finalboxtxt[ 11 ] = TextDrawCreate(182.000000, 132.000000, "ld_poke:cd1c");
	TextDrawBackgroundColor(finalboxtxt[ 11 ], 255);
	TextDrawFont(finalboxtxt[ 11 ], 4);
	TextDrawLetterSize(finalboxtxt[ 11 ], 0.500000, 1.000000);
	TextDrawColor(finalboxtxt[ 11 ], 200);
	TextDrawSetOutline(finalboxtxt[ 11 ], 0);
	TextDrawSetProportional(finalboxtxt[ 11 ], 1);
	TextDrawSetShadow(finalboxtxt[ 11 ], 1);
	TextDrawUseBox(finalboxtxt[ 11 ], 1);
	TextDrawBoxColor(finalboxtxt[ 11 ], 255);
	TextDrawTextSize(finalboxtxt[ 11 ], 141.000000, 17.000000);

	finalboxtxt[ 12 ] = TextDrawCreate(336.000000, 132.000000, "ld_poke:cd1c");
	TextDrawBackgroundColor(finalboxtxt[ 12 ], 255);
	TextDrawFont(finalboxtxt[ 12 ], 4);
	TextDrawLetterSize(finalboxtxt[ 12 ], 0.500000, 1.000000);
	TextDrawColor(finalboxtxt[ 12 ], 200);
	TextDrawSetOutline(finalboxtxt[ 12 ], 0);
	TextDrawSetProportional(finalboxtxt[ 12 ], 1);
	TextDrawSetShadow(finalboxtxt[ 12 ], 1);
	TextDrawUseBox(finalboxtxt[ 12 ], 1);
	TextDrawBoxColor(finalboxtxt[ 12 ], 255);
	TextDrawTextSize(finalboxtxt[ 12 ], 141.000000, 17.000000);

	finalboxtxt[ 13 ] = TextDrawCreate(187.000000, 137.000000, "Name                    Kills         DMG");
	TextDrawBackgroundColor(finalboxtxt[ 13 ], 255);
	TextDrawFont(finalboxtxt[ 13 ], 1);
	TextDrawLetterSize(finalboxtxt[ 13 ], 0.190000, 0.799999);
	TextDrawColor(finalboxtxt[ 13 ], -1);
	TextDrawSetOutline(finalboxtxt[ 13 ], 0);
	TextDrawSetProportional(finalboxtxt[ 13 ], 1);
	TextDrawSetShadow(finalboxtxt[ 13 ], 0);

	finalboxtxt[ 14 ] = TextDrawCreate(340.000000, 137.000000, "Name                    Kills         DMG");
	TextDrawBackgroundColor(finalboxtxt[ 14 ], 255);
	TextDrawFont(finalboxtxt[ 14 ], 1);
	TextDrawLetterSize(finalboxtxt[ 14 ], 0.190000, 0.799999);
	TextDrawColor(finalboxtxt[ 14 ], -1);
	TextDrawSetOutline(finalboxtxt[ 14 ], 0);
	TextDrawSetProportional(finalboxtxt[ 14 ], 1);
	TextDrawSetShadow(finalboxtxt[ 14 ], 0);

	finaltxt[ 1 ] = TextDrawCreate(187.000000, 152.000000, "~r~~h~~h~[TRM]Copper");
	TextDrawBackgroundColor(finaltxt[ 1 ], 255);
	TextDrawFont(finaltxt[ 1 ], 1);
	TextDrawLetterSize(finaltxt[ 1 ], 0.190000, 0.899999);
	TextDrawColor(finaltxt[ 1 ], -1);
	TextDrawSetOutline(finaltxt[ 1 ], 1);
	TextDrawSetProportional(finaltxt[ 1 ], 1);

	finaltxt[ 2 ] = TextDrawCreate(342.000000, 152.000000, "~b~~h~~h~[TRM]less");
	TextDrawBackgroundColor(finaltxt[ 2 ], 255);
	TextDrawFont(finaltxt[ 2 ], 1);
	TextDrawLetterSize(finaltxt[ 2 ], 0.190000, 0.899999);
	TextDrawColor(finaltxt[ 2 ], -1);
	TextDrawSetOutline(finaltxt[ 2 ], 1);
	TextDrawSetProportional(finaltxt[ 2 ], 1);
	
	finaltxt[ 3 ] = TextDrawCreate(250.000000, 112.000000, "~r~~h~TRM won the round!!");
	TextDrawBackgroundColor(finaltxt[ 3 ], 255);
	TextDrawFont(finaltxt[ 3 ], 3);
	TextDrawLetterSize(finaltxt[ 3 ], 0.380000, 1.100000);
	TextDrawColor(finaltxt[ 3 ], -1);
	TextDrawSetOutline(finaltxt[ 3 ], 0);
	TextDrawSetProportional(finaltxt[ 3 ], 1);
	TextDrawSetShadow(finaltxt[ 3 ], 1);
	
	finaltxt[ 5 ] = TextDrawCreate(273.000000, 267.000000, "Top Killer: [TRM]less (3 kills)");
	TextDrawBackgroundColor(finaltxt[ 5 ], 255);
	TextDrawFont(finaltxt[ 5 ], 1);
	TextDrawLetterSize(finaltxt[ 5 ], 0.200000, 0.899999);
	TextDrawColor(finaltxt[ 5 ], -1);
	TextDrawSetOutline(finaltxt[ 5 ], 0);
	TextDrawSetProportional(finaltxt[ 5 ], 1);
	TextDrawSetShadow(finaltxt[ 5 ], 0);

	finaltxt[ 6 ] = TextDrawCreate(273.000000, 292.000000, "Top DMG: [TRM]less (900 DMG)");
	TextDrawBackgroundColor(finaltxt[ 6 ], 255);
	TextDrawFont(finaltxt[ 6 ], 1);
	TextDrawLetterSize(finaltxt[ 6 ], 0.200000, 0.899999);
	TextDrawColor(finaltxt[ 6 ], -1);
	TextDrawSetOutline(finaltxt[ 6 ], 0);
	TextDrawSetProportional(finaltxt[ 6 ], 1);
	TextDrawSetShadow(finaltxt[ 6 ], 0);

	finaltxt[ 7 ] = TextDrawCreate(264.000000, 152.000000, "0");
	TextDrawBackgroundColor(finaltxt[ 7 ], 255);
	TextDrawFont(finaltxt[ 7 ], 1);
	TextDrawLetterSize(finaltxt[ 7 ], 0.190000, 0.899999);
	TextDrawColor(finaltxt[ 7 ], -1);
	TextDrawSetOutline(finaltxt[ 7 ], 1);
	TextDrawSetProportional(finaltxt[ 7 ], 1);

	finaltxt[ 8 ] = TextDrawCreate(418.000000, 152.000000, "0");
	TextDrawBackgroundColor(finaltxt[ 8 ], 255);
	TextDrawFont(finaltxt[ 8 ], 1);
	TextDrawLetterSize(finaltxt[ 8 ], 0.190000, 0.899999);
	TextDrawColor(finaltxt[ 8 ], -1);
	TextDrawSetOutline(finaltxt[ 8 ], 1);
	TextDrawSetProportional(finaltxt[ 8 ], 1);
	
	finaltxt[ 9 ] = TextDrawCreate(299.000000, 152.000000, "200");
	TextDrawBackgroundColor(finaltxt[ 9 ], 255);
	TextDrawFont(finaltxt[ 9 ], 1);
	TextDrawLetterSize(finaltxt[ 9 ], 0.189999, 0.899999);
	TextDrawColor(finaltxt[ 9 ], -1);
	TextDrawSetOutline(finaltxt[ 9 ], 1);
	TextDrawSetProportional(finaltxt[ 9 ], 1);

	finaltxt[ 10 ] = TextDrawCreate(452.000000, 152.000000, "200");
	TextDrawBackgroundColor(finaltxt[ 10 ], 255);
	TextDrawFont(finaltxt[ 10 ], 1);
	TextDrawLetterSize(finaltxt[ 10 ], 0.189999, 0.899999);
	TextDrawColor(finaltxt[ 10 ], -1);
	TextDrawSetOutline(finaltxt[ 10 ], 1);
	TextDrawSetProportional(finaltxt[ 10 ], 1);
	
	classtxt[ 0 ] = TextDrawCreate( 322, 348, "_" );
	TextDrawAlignment		( classtxt[ 0 ], 2 );
	TextDrawBackgroundColor ( classtxt[ 0 ], -16776961 );
	TextDrawFont			( classtxt[ 0 ], 1 );
	TextDrawLetterSize		( classtxt[ 0 ], 0.9, 3.4 );
	TextDrawColor			( classtxt[ 0 ], 167772415 );
	TextDrawSetOutline		( classtxt[ 0 ], 1 );
	TextDrawSetProportional	( classtxt[ 0 ], 1 );

	classtxt[ 1 ] = TextDrawCreate( 418, 357, "_" );
	TextDrawAlignment		( classtxt[ 1 ], 2 );
	TextDrawBackgroundColor	( classtxt[ 1 ], 65535 );
	TextDrawFont			( classtxt[ 1 ], 1 );
	TextDrawLetterSize		( classtxt[ 1 ], 0.53, 1.9 );
	TextDrawColor			( classtxt[ 1 ], 2790 );
	TextDrawSetOutline		( classtxt[ 1 ], 1 );
	TextDrawSetProportional	( classtxt[ 1 ], 1 );

	classtxt[ 2 ] = TextDrawCreate( 224, 357, "_" );
	TextDrawAlignment		( classtxt[ 2 ], 2 );
	TextDrawBackgroundColor	( classtxt[ 2 ], 7864575 );
	TextDrawFont			( classtxt[ 2 ], 1 );
	TextDrawLetterSize		( classtxt[ 2 ], 0.53, 1.9 );
	TextDrawColor			( classtxt[ 2 ], 655590 );
	TextDrawSetOutline		( classtxt[ 2 ], 1 );
	TextDrawSetProportional	( classtxt[ 2 ], 1 );
	
	/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		DM Results
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
	
	dmtxt[ 3 ] = TextDrawCreate(261.000000, 171.000000, "DM Results");
	TextDrawBackgroundColor(dmtxt[ 3 ], 160);
	TextDrawFont(dmtxt[ 3 ], 3);
	TextDrawLetterSize(dmtxt[ 3 ], 0.560000, 2.400000);
	TextDrawColor(dmtxt[ 3 ], -4259585);
	TextDrawSetOutline(dmtxt[ 3 ], 1);
	TextDrawSetProportional(dmtxt[ 3 ], 1);

	dmtxt[ 4 ] = TextDrawCreate(438.000000, 185.000000, "~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_");
	TextDrawBackgroundColor(dmtxt[ 4 ], 255);
	TextDrawFont(dmtxt[ 4 ], 1);
	TextDrawLetterSize(dmtxt[ 4 ], 0.500000, 1.000000);
	TextDrawColor(dmtxt[ 4 ], -1);
	TextDrawSetOutline(dmtxt[ 4 ], 0);
	TextDrawSetProportional(dmtxt[ 4 ], 1);
	TextDrawSetShadow(dmtxt[ 4 ], 1);
	TextDrawUseBox(dmtxt[ 4 ], 1);
	TextDrawBoxColor(dmtxt[ 4 ], 120);
	TextDrawTextSize(dmtxt[ 4 ], 196.000000, 34.000000);

	dmtxt[ 5 ] = TextDrawCreate(213.000000, 201.000000, "~n~");
	TextDrawBackgroundColor(dmtxt[ 5 ], 255);
	TextDrawFont(dmtxt[ 5 ], 1);
	TextDrawLetterSize(dmtxt[ 5 ], 0.500000, 1.000000);
	TextDrawColor(dmtxt[ 5 ], -1);
	TextDrawSetOutline(dmtxt[ 5 ], 0);
	TextDrawSetProportional(dmtxt[ 5 ], 1);
	TextDrawSetShadow(dmtxt[ 5 ], 1);
	TextDrawUseBox(dmtxt[ 5 ], 1);
	TextDrawBoxColor(dmtxt[ 5 ], -4259585);
	TextDrawTextSize(dmtxt[ 5 ], 419.000000, 0.000000);

	dmtxt[ 6 ] = TextDrawCreate(213.000000, 221.000000, "~n~");
	TextDrawBackgroundColor(dmtxt[ 6 ], 255);
	TextDrawFont(dmtxt[ 6 ], 1);
	TextDrawLetterSize(dmtxt[ 6 ], 0.500000, 1.000000);
	TextDrawColor(dmtxt[ 6 ], -1);
	TextDrawSetOutline(dmtxt[ 6 ], 0);
	TextDrawSetProportional(dmtxt[ 6 ], 1);
	TextDrawSetShadow(dmtxt[ 6 ], 1);
	TextDrawUseBox(dmtxt[ 6 ], 1);
	TextDrawBoxColor(dmtxt[ 6 ], -4259585);
	TextDrawTextSize(dmtxt[ 6 ], 419.000000, 0.000000);

	dmtxt[ 7 ] = TextDrawCreate(213.000000, 241.000000, "~n~");
	TextDrawBackgroundColor(dmtxt[ 7 ], 255);
	TextDrawFont(dmtxt[ 7 ], 1);
	TextDrawLetterSize(dmtxt[ 7 ], 0.500000, 1.000000);
	TextDrawColor(dmtxt[ 7 ], -1);
	TextDrawSetOutline(dmtxt[ 7 ], 0);
	TextDrawSetProportional(dmtxt[ 7 ], 1);
	TextDrawSetShadow(dmtxt[ 7 ], 1);
	TextDrawUseBox(dmtxt[ 7 ], 1);
	TextDrawBoxColor(dmtxt[ 7 ], -4259585);
	TextDrawTextSize(dmtxt[ 7 ], 419.000000, 0.000000);

	dmtxt[ 0 ] = TextDrawCreate(320.000000, 201.000000, "1 - ");
	TextDrawAlignment(dmtxt[ 0 ], 2);
	TextDrawBackgroundColor(dmtxt[ 0 ], 120);
	TextDrawFont(dmtxt[ 0 ], 1);
	TextDrawLetterSize(dmtxt[ 0 ], 0.300000, 1.000000);
	TextDrawColor(dmtxt[ 0 ], -1);
	TextDrawSetOutline(dmtxt[ 0 ], 1);
	TextDrawSetProportional(dmtxt[ 0 ], 1);

	dmtxt[ 1 ] = TextDrawCreate(320.000000, 221.000000, "2 -");
	TextDrawAlignment(dmtxt[ 1 ], 2);
	TextDrawBackgroundColor(dmtxt[ 1 ], 120);
	TextDrawFont(dmtxt[ 1 ], 1);
	TextDrawLetterSize(dmtxt[ 1 ], 0.300000, 1.000000);
	TextDrawColor(dmtxt[ 1 ], -1);
	TextDrawSetOutline(dmtxt[ 1 ], 1);
	TextDrawSetProportional(dmtxt[ 1 ], 1);

	dmtxt[ 2 ] = TextDrawCreate(320.000000, 241.000000, "3 -");
	TextDrawAlignment(dmtxt[ 2 ], 2);
	TextDrawBackgroundColor(dmtxt[ 2 ], 120);
	TextDrawFont(dmtxt[ 2 ], 1);
	TextDrawLetterSize(dmtxt[ 2 ], 0.300000, 1.000000);
	TextDrawColor(dmtxt[ 2 ], -1);
	TextDrawSetOutline(dmtxt[ 2 ], 1);
	TextDrawSetProportional(dmtxt[ 2 ], 1);
	
	for ( new i; i < MAX_PLAYERS; i++ )
	{	
	DMpoints[ i ] = TextDrawCreate( 298, 137, "+12" );
	TextDrawBackgroundColor ( DMpoints[ i ], 160 );
	TextDrawFont			( DMpoints[ i ], 3 );
	TextDrawColor			( DMpoints[ i ], 0xFF8C00FF );
	TextDrawSetOutline		( DMpoints[ i ], 0 );
	TextDrawSetProportional	( DMpoints[ i ], 1 );
	TextDrawSetShadow		( DMpoints[ i ], 1 );
	TextDrawLetterSize		( DMpoints[ i ], 0.5, 1.1 );
	}
	
	/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    Final
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	cfinaltxt[ 0 ] = TextDrawCreate( 100, 120, "_~n~_~n~_~n~_~n~" );
	TextDrawBackgroundColor	( cfinaltxt[ 0 ], 255 );
	TextDrawFont			( cfinaltxt[ 0 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 0 ], 0.5, 1 );
	TextDrawColor			( cfinaltxt[ 0 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 0 ], 0 );
	TextDrawSetProportional	( cfinaltxt[ 0 ], 1 );
	TextDrawSetShadow		( cfinaltxt[ 0 ], 1 );
	TextDrawUseBox			( cfinaltxt[ 0 ], 1 );
	TextDrawBoxColor		( cfinaltxt[ 0 ], 160 );
	TextDrawTextSize		( cfinaltxt[ 0 ], 522, 560 );

	cfinaltxt[ 1 ] = TextDrawCreate(100, 289, "_~n~_~n~_~n~_~n~" );
	TextDrawBackgroundColor	( cfinaltxt[ 1 ], 255 );
	TextDrawFont			( cfinaltxt[ 1 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 1 ], 0.5, 1 );
	TextDrawColor			( cfinaltxt[ 1 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 1 ], 0 );
	TextDrawSetProportional	( cfinaltxt[ 1 ], 1 );
	TextDrawSetShadow		( cfinaltxt[ 1 ], 1 );
	TextDrawUseBox			( cfinaltxt[ 1 ], 1 );
	TextDrawBoxColor		( cfinaltxt[ 1 ], 160 );
	TextDrawTextSize		( cfinaltxt[ 1 ], 522, 560 );

	cfinaltxt[ 2 ] = TextDrawCreate(100, 149, "_~n~");
	TextDrawBackgroundColor	( cfinaltxt[ 2 ], 255 );
	TextDrawFont			( cfinaltxt[ 2 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 2 ], 0.5, 1 );
	TextDrawColor			( cfinaltxt[ 2 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 2 ], 0 );
	TextDrawSetProportional	( cfinaltxt[ 2 ], 1 );
	TextDrawSetShadow		( cfinaltxt[ 2 ], 1 );
	TextDrawUseBox			( cfinaltxt[ 2 ], 1 );
	TextDrawBoxColor		( cfinaltxt[ 2 ], 160 );
	TextDrawTextSize		( cfinaltxt[ 2 ], 522, 560 );

	cfinaltxt[ 3 ] = TextDrawCreate( 100, 151, "_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~" );
	TextDrawBackgroundColor	( cfinaltxt[ 3 ], 255 );
	TextDrawFont			( cfinaltxt[ 3 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 3 ], 0.5, 1 );
	TextDrawColor			( cfinaltxt[ 3 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 3 ], 0 );
	TextDrawSetProportional	( cfinaltxt[ 3 ], 1 );
	TextDrawSetShadow		( cfinaltxt[ 3 ], 1 );
	TextDrawUseBox			( cfinaltxt[ 3 ], 1 );
	TextDrawBoxColor		( cfinaltxt[ 3 ], 0xFF373770 );
	TextDrawTextSize		( cfinaltxt[ 3 ], 270, 790 );

	cfinaltxt[ 4 ] = TextDrawCreate( 354, 151, "_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~" );
	TextDrawBackgroundColor	( cfinaltxt[ 4 ], 255 );
	TextDrawFont			( cfinaltxt[ 4 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 4 ], 0.5, 1 );
	TextDrawColor			( cfinaltxt[ 4 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 4 ], 0 );
	TextDrawSetProportional	( cfinaltxt[ 4 ], 1 );
	TextDrawSetShadow		( cfinaltxt[ 4 ], 1 );
	TextDrawUseBox			( cfinaltxt[ 4 ], 1 );
	TextDrawBoxColor		( cfinaltxt[ 4 ], 0x3B2CE170 );
	TextDrawTextSize		( cfinaltxt[ 4 ], 522, 790 );

	cfinaltxt[ 5 ] = TextDrawCreate( 313, 126, " " );
	TextDrawAlignment		( cfinaltxt[ 5 ], 2 );
	TextDrawBackgroundColor	( cfinaltxt[ 5 ], 100 );
	TextDrawFont			( cfinaltxt[ 5 ], 3 );
	TextDrawLetterSize		( cfinaltxt[ 5 ], 0.41, 1.8 );
	TextDrawColor			( cfinaltxt[ 5 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 5 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 5 ], 1 );

	cfinaltxt[ 6 ] = TextDrawCreate(272, 151, "_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~_~n~");
	TextDrawBackgroundColor	(cfinaltxt[ 6 ], 255);
	TextDrawFont			(cfinaltxt[ 6 ], 1);
	TextDrawLetterSize		(cfinaltxt[ 6 ], 0.5, 1);
	TextDrawColor			(cfinaltxt[ 6 ], -1);
	TextDrawSetOutline		(cfinaltxt[ 6 ], 0);
	TextDrawSetProportional	(cfinaltxt[ 6 ], 1);
	TextDrawSetShadow		(cfinaltxt[ 6 ], 1);
	TextDrawUseBox			(cfinaltxt[ 6 ], 1);
	TextDrawBoxColor		(cfinaltxt[ 6 ], 120);
	TextDrawTextSize		(cfinaltxt[ 6 ], 352, 40);

	cfinaltxt[ 7 ] = TextDrawCreate( 109, 150, "~r~~h~~h~Name               		Kills  Deaths  Damage" );
	TextDrawBackgroundColor	( cfinaltxt[ 7 ], 100 );
	TextDrawFont			( cfinaltxt[ 7 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 7 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 7 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 7 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 7 ], 1 );

	cfinaltxt[ 8 ] = TextDrawCreate( 365, 150, "~b~~h~~h~Name             			Kills  Deaths  Damage	");
	TextDrawBackgroundColor	( cfinaltxt[ 8 ], 100 );
	TextDrawFont			( cfinaltxt[ 8 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 8 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 8 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 8 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 8 ], 1 );

	cfinaltxt[ 9 ] = TextDrawCreate( 279, 150, "Winner   Mode  ID");
	TextDrawBackgroundColor	( cfinaltxt[ 9 ], 100 );
	TextDrawFont			( cfinaltxt[ 9 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 9 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 9 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 9 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 9 ], 1 );

	cfinaltxt[ 10 ] = TextDrawCreate( 283, 153, " " ); //~r~~h~~h~TRM      ~r~~h~~h~~h~~h~~h~Base   ~w~69~n~~r~~h~~h~TRM      ~r~~h~~h~~h~~h~~h~Base   ~w~101
	TextDrawBackgroundColor	( cfinaltxt[ 10 ], 100 );
	TextDrawFont			( cfinaltxt[ 10 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 10 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 10 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 10 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 10 ], 1 );

	cfinaltxt[ 11 ] = TextDrawCreate( 109, 163, "~r~~h~~h~[TRM]less" );
	TextDrawBackgroundColor	( cfinaltxt[ 11 ], 70 );
	TextDrawFont			( cfinaltxt[ 11 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 11 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 11 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 11 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 11 ], 1 );

	cfinaltxt[ 12 ] = TextDrawCreate( 365, 163, "~b~~h~~h~[TRM]less" );
	TextDrawBackgroundColor	( cfinaltxt[ 12 ], 70 );
	TextDrawFont			( cfinaltxt[ 12 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 12 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 12 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 12 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 12 ], 1 );

	cfinaltxt[ 13 ] = TextDrawCreate( 186, 163, "0" );
	TextDrawBackgroundColor	( cfinaltxt[ 13 ], 70 );
	TextDrawFont			( cfinaltxt[ 13 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 13 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 13 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 13 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 13 ], 1 );

	cfinaltxt[ 14 ] = TextDrawCreate( 440, 163, "0" );
	TextDrawBackgroundColor	( cfinaltxt[ 14 ], 70 );
	TextDrawFont			( cfinaltxt[ 14 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 14 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 14 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 14 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 14 ], 1 );

	cfinaltxt[ 15 ] = TextDrawCreate( 212, 163, "7" ); //Kills Team 1
	TextDrawBackgroundColor	(cfinaltxt[ 15 ], 70 );
	TextDrawFont			(cfinaltxt[ 15 ], 1 );
	TextDrawLetterSize		(cfinaltxt[ 15 ], 0.2, 0.9 );
	TextDrawColor			(cfinaltxt[ 15 ], -1 );
	TextDrawSetOutline		(cfinaltxt[ 15 ], 1 );
	TextDrawSetProportional	(cfinaltxt[ 15 ], 1 );

	cfinaltxt[ 16 ] = TextDrawCreate( 236, 163, "2000" ); //DMG Team 1
	TextDrawBackgroundColor	( cfinaltxt[ 16 ], 70 );
	TextDrawFont			( cfinaltxt[ 16 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 16 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 16 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 16 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 16 ], 1 );

	cfinaltxt[ 17 ] = TextDrawCreate( 466, 163, "7"); //Kills Team 2
	TextDrawBackgroundColor	( cfinaltxt[ 17 ], 70 );
	TextDrawFont			( cfinaltxt[ 17 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 17 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 17 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 17 ], 1 );
	TextDrawSetProportional ( cfinaltxt[ 17 ], 1 );

	cfinaltxt[ 18 ] = TextDrawCreate( 488, 163, "2000" ); //DMG Team 2
	TextDrawBackgroundColor	( cfinaltxt[ 18 ], 70 );
	TextDrawFont			( cfinaltxt[ 18 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 18 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 18 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 18 ], 1 );
	TextDrawSetProportional ( cfinaltxt[ 18 ], 1 );
	
	cfinaltxt[ 19 ] = TextDrawCreate( 312, 153, "Base" );
	TextDrawLetterSize		( cfinaltxt[ 19 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 19 ], 0xE39C6DFF );
	TextDrawBackgroundColor ( cfinaltxt[ 19 ], 100 );
	TextDrawFont			( cfinaltxt[ 19 ], 1 );
	TextDrawSetOutline		( cfinaltxt[ 19 ], 1 );
	TextDrawSetProportional	( cfinaltxt[ 19 ], 1 );

	cfinaltxt[ 20 ] = TextDrawCreate( 337, 153, "69");
	TextDrawBackgroundColor ( cfinaltxt[ 20 ], 100 );
	TextDrawFont			( cfinaltxt[ 20 ], 1 );
	TextDrawLetterSize		( cfinaltxt[ 20 ], 0.2, 0.9 );
	TextDrawColor			( cfinaltxt[ 20 ], -1 );
	TextDrawSetOutline		( cfinaltxt[ 20 ], 1 );
	TextDrawSetProportional ( cfinaltxt[ 20 ], 1 );

	/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	for(new i; i < MAX_PLAYERS; i++)
	{
	ukilled[ i ] = TextDrawCreate( 325, 365, " " );
	TextDrawAlignment      ( ukilled[ i ], 2 );
	TextDrawFont           ( ukilled[ i ], 1 );
	TextDrawSetProportional( ukilled[ i ], 1 );
	TextDrawSetShadow      ( ukilled[ i ], 1 );
	TextDrawLetterSize     ( ukilled[ i ], 0.28, 1.3 );
	TextDrawBackgroundColor( ukilled[ i ], 100 );
	TextDrawColor          ( ukilled[ i ], 0xFF8C00FF );
	
	ukilled2[ i ] = TextDrawCreate( 325, 377, " " );
	TextDrawAlignment		( ukilled2[ i ], 2 );
	TextDrawFont			( ukilled2[ i ], 1 );
	TextDrawSetProportional	( ukilled2[ i ], 1 );
	TextDrawSetShadow		( ukilled2[ i ], 1 );
	TextDrawLetterSize		( ukilled2[ i ], 0.19, 1 );
	TextDrawBackgroundColor	( ukilled2[ i ], 100 );
	TextDrawColor			( ukilled2[ i ], 0xFF8C00FF );
	

	SpecBox[ i ][ 0 ] = TextDrawCreate( 28, 338, " ");
	TextDrawBackgroundColor ( SpecBox[ i ][ 0 ], 40 );
	TextDrawFont			( SpecBox[ i ][ 0 ], 1 );
	TextDrawLetterSize		( SpecBox[ i ][ 0 ], 0.24, 1.1 );
	TextDrawColor			( SpecBox[ i ][ 0 ], 255 );
	TextDrawSetOutline		( SpecBox[ i ][ 0 ], 0 );
	TextDrawSetProportional	( SpecBox[ i ][ 0 ], 1 );
	TextDrawSetShadow		( SpecBox[ i ][ 1 ], 1 );

	SpecBox[ i ][ 1 ] = TextDrawCreate( 575, 342, " ");
	TextDrawBackgroundColor ( SpecBox[ i ][ 1 ], 40 );
	TextDrawFont			( SpecBox[ i ][ 1 ], 1 );
	TextDrawLetterSize		( SpecBox[ i ][ 1 ], 0.18, 0.8 );
	TextDrawColor			( SpecBox[ i ][ 1 ], -793952769 );
	TextDrawSetOutline		( SpecBox[ i ][ 1 ], 0 );
	TextDrawSetProportional	( SpecBox[ i ][ 1 ], 1 );
	TextDrawSetShadow		( SpecBox[ i ][ 1 ], 1 );

	dmgtxt[0][i] = TextDrawCreate( 200, 370, " " );
	TextDrawLetterSize     ( dmgtxt[0][i], 0.2, 1 );
	TextDrawColor          ( dmgtxt[0][i], 0x30FF50FF);
	TextDrawFont           ( dmgtxt[0][i], 1 );
	TextDrawSetShadow      ( dmgtxt[0][i], 0 );
	TextDrawAlignment      ( dmgtxt[0][i], 2 );
	TextDrawSetOutline     ( dmgtxt[0][i], 1 );
	TextDrawBackgroundColor( dmgtxt[0][i], 0x0000000F);

	dmgtxt[1][i] = TextDrawCreate( 450, 370, " " );
	TextDrawLetterSize     ( dmgtxt[1][i], 0.2, 1 );
	TextDrawColor		   ( dmgtxt[1][i], 0xB00000FF);
	TextDrawFont	  	   ( dmgtxt[1][i], 1 );
	TextDrawSetShadow	   ( dmgtxt[1][i], 0 );
	TextDrawAlignment      ( dmgtxt[1][i], 2 );
	TextDrawSetOutline	   ( dmgtxt[1][i], 1 );
	TextDrawBackgroundColor( dmgtxt[1][i], 0x0000000F);
	
	teamdmgtxt[0] = TextDrawCreate( 75, 431, " " );
	TextDrawBackgroundColor	( teamdmgtxt[0], 255);
	TextDrawFont			( teamdmgtxt[0], 1 );
	TextDrawLetterSize		( teamdmgtxt[0], 0.38, 1.8 );
	TextDrawSetProportional	( teamdmgtxt[0], 1 );
	TextDrawSetShadow		( teamdmgtxt[0], 1 );
	TextDrawSetOutline     	( teamdmgtxt[0], 0 );

	teamdmgtxt[1] = TextDrawCreate( 543, 431, " " );
	TextDrawBackgroundColor ( teamdmgtxt[1], 255);
	TextDrawFont			( teamdmgtxt[1], 1);
	TextDrawLetterSize		( teamdmgtxt[1], 0.38, 1.8 );
	TextDrawSetProportional	( teamdmgtxt[1], 1 );
	TextDrawSetShadow		( teamdmgtxt[1], 1 );
	TextDrawSetOutline     	( teamdmgtxt[1], 0 );
	
	rdmgtxd[ i ] = TextDrawCreate( 9, 404, " " );
	TextDrawLetterSize		( rdmgtxd[ i ], 0.209999, 1 );
	TextDrawBackgroundColor ( rdmgtxd[ i ], 255 );
	TextDrawFont			( rdmgtxd[ i ], 1 );
	TextDrawColor			( rdmgtxd[ i ],-1 );
	TextDrawSetOutline		( rdmgtxd[ i ], 0 );
	TextDrawSetProportional ( rdmgtxd[ i ], 1 );
	TextDrawSetShadow		( rdmgtxd[ i ], 1 );

	Spectating[ i ] = TextDrawCreate(519, 354, " " );
	TextDrawBackgroundColor ( Spectating[ i ], 255 );
	TextDrawFont			( Spectating[ i ], 1 );
	TextDrawLetterSize		( Spectating[ i ], 0.19, 0.699999 );
	TextDrawColor			( Spectating[ i ], -1 );
	TextDrawSetProportional ( Spectating[ i ], 1 );
	TextDrawSetOutline		( Spectating[ i ], 0 );
	TextDrawSetShadow		( Spectating[ i ], 0 );
	}
	
}

menusLoad(  )
{
	buildMenu[ 0 ] = CreateMenu( "Options", 1, 200, 125, 220, 50 );
	AddMenuItem( buildMenu[ 0 ], 0, "~>~Deathmatch"       );
	AddMenuItem( buildMenu[ 0 ], 0, "~>~Team Deathmatch"  );
	AddMenuItem( buildMenu[ 0 ], 0, "~>~Team Elimination" );
	AddMenuItem( buildMenu[ 0 ], 0, "~>~Attack/Defend"    );
	AddMenuItem( buildMenu[ 0 ], 0, "~d~Cancel"           );

	buildMenu[ 1 ] = CreateMenu( "Deathmatch", 1, 200, 125, 220, 50 );
	AddMenuItem( buildMenu[ 1 ], 0, "~>~Random Spawns" );
	AddMenuItem( buildMenu[ 1 ], 0, "~>~WorldBounds"   );
	AddMenuItem( buildMenu[ 1 ], 0, "~>~StartCamera"   );
	AddMenuItem( buildMenu[ 1 ], 0, "~>~Finish Arena"  );
	AddMenuItem( buildMenu[ 1 ], 0, "~>~Delete Arena"  );
	AddMenuItem( buildMenu[ 1 ], 0, "~d~Cancel"        );

	buildMenu[ 2 ] = CreateMenu( "Team Deathmatch", 1, 200, 125, 220, 50 );
	AddMenuItem( buildMenu[ 2 ], 0, "~>~Team Spawns"  );
	AddMenuItem( buildMenu[ 2 ], 0, "~>~WorldBounds"  );
	AddMenuItem( buildMenu[ 2 ], 0, "~>~StartCamera"  );
	AddMenuItem( buildMenu[ 2 ], 0, "~>~Finish Arena" );
	AddMenuItem( buildMenu[ 2 ], 0, "~>~Delete Arena" );
	AddMenuItem( buildMenu[ 2 ], 0, "~d~Cancel"       );

	buildMenu[ 3 ] = CreateMenu( "Team Elimination", 1, 200, 125, 220, 50 );
	AddMenuItem( buildMenu[ 3 ], 0, "~>~Team Spawns"  );
	AddMenuItem( buildMenu[ 3 ], 0, "~>~WorldBounds"  );
	AddMenuItem( buildMenu[ 3 ], 0, "~>~StartCamera"  );
	AddMenuItem( buildMenu[ 3 ], 0, "~>~Finish Arena" );
	AddMenuItem( buildMenu[ 3 ], 0, "~>~Delete Arena" );
	AddMenuItem( buildMenu[ 3 ], 0, "~d~Cancel"       );

	buildMenu[ 4 ] = CreateMenu("Attack/Defend", 1, 200, 125, 220, 50 );
	AddMenuItem( buildMenu[ 4 ], 0, "~>~Team Spawns" );
	AddMenuItem( buildMenu[ 4 ], 0, "~>~Checkpoint"  );
	AddMenuItem( buildMenu[ 4 ], 0, "~>~Finish Base" );
	AddMenuItem( buildMenu[ 4 ], 0, "~>~Delete Base" );
	AddMenuItem( buildMenu[ 4 ], 0, "~d~Cancel"      );

}

ConfigLoad( const file[ ] )
{
	if ( !fexist( CONFIG_FILE ) )
	{
	    new File:afile, entry[ 128 ];

	    afile = fopen( file, io_write );

		format( entry, sizeof( entry ), "Team0Name XzM\r\nTeam1Name Guest\r\nTeam2Name Referee\r\nTeam0Skin 53\r\nTeam1Skin 230\r\nTeam2Skin 155\r\nTeam0Score 0\r\n" );

		fwrite( afile, entry );

		format( entry, sizeof( entry ), "Team1Score 0\r\nCheckTime 25\r\nStartTime 5\r\nMainTime 20\r\nMainWeather 14\r\nSyncTime 1\r\nPSetSkins 0\r\nVehiclesPP 2\r\n" );

		fwrite( afile, entry );

		format( entry, sizeof( entry ), "AutoSwap 0\r\nChatLock 0\r\nPingLimit 300\r\nServerLock -1\r\nRoundsTime 5 10 10 10\r\nWeaponsType 1 1 1 0\r\n" );

		fwrite( afile, entry );

		format( entry, sizeof( entry ), "HPbars 1\r\nSyncBug 1\r\nLobbyWeps 1" );

		fwrite( afile, entry );
		
		format( entry, sizeof( entry ), "WeaponsLimit 5 1 5 1\r\nMainSpawn 377.3802 2539.7908 16.5391 86.2612 0.0\r\n" );

		fwrite( afile, entry );

		format( entry, sizeof( entry ), "SelectScreen 350.049 2456.202 21.568 168.724 0.0\r\n" );

		fwrite( afile, entry );

		fclose( afile );
	}

  	new string[ 128 ], index;

	string 		    	    	    =   	      	  fileGet( file,  "Team0Name"       );  format( teamName[ HOME ], sizeof( teamName[ ] ), string );
	string 		    	    	    =   	  	  	  fileGet( file,  "Team1Name"       );  format( teamName[ AWAY ], sizeof( teamName[ ] ), string );
	string 		    	    	    =   	 	  	  fileGet( file,  "Team2Name"       );  format( teamName[ REF  ], sizeof( teamName[ ] ), string );
	teamData[ HOME ][ t_skin  ]  	=  	  	  strval( fileGet( file,  "Team0Skin"       ) );
	teamData[ AWAY ][ t_skin  ]  	=  	  	  strval( fileGet( file,  "Team1Skin"       ) );
	teamData[ REF  ][ t_skin  ]  	=     	  strval( fileGet( file,  "Team2Skin"       ) );
	teamData[ HOME ][ t_score ]  	=  	  	  strval( fileGet( file,  "Team0Score"      ) );
	teamData[ AWAY ][ t_score ]  	=  	  	  strval( fileGet( file,  "Team1Score"      ) );
	checkTimer				  	    =   	  strval( fileGet( file,  "CheckTime"       ) );
	startTimer				  	    =   	  strval( fileGet( file,  "StartTime"       ) );
	serverData[ s_time     ]	    =     	  strval( fileGet( file,  "MainTime"        ) );
	serverData[ s_weather  ]	    =     	  strval( fileGet( file,  "MainWeather"     ) );
	syncTimer		    		    =    	  strval( fileGet( file,  "SyncTime"        ) ) * 500;
	serverData[ s_setskins  ]	    =    	  strval( fileGet( file,  "PSetSkins"       ) );
	serverData[ s_vepp      ]	    =    	  strval( fileGet( file,  "VehiclesPP"      ) );
	serverData[ s_autoswap  ]	    =   	  strval( fileGet( file,  "AutoSwap"        ) );
	serverData[ s_hpbars	]	    =   	  strval( fileGet( file,  "HPbars"     	    ) );
	serverData[ s_syncbug   ]	    =   	  strval( fileGet( file,  "SyncBug"         ) );
	serverData[ s_lobbyweps ]	    =   	  strval( fileGet( file,  "LobbyWeps"       ) );
	serverData[ s_chatlock  ]	    =   	  strval( fileGet( file,  "ChatLock"        ) );
	serverData[ s_pinglimit ]	    =   	  strval( fileGet( file,  "PingLimit"       ) );
	serverData[ s_packetlimit ]	    =   	  strval( fileGet( file,  "PacketLimit"     ) );
	serverData[ s_FPSlimit  ]	    =   	  strval( fileGet( file,  "FPSLimit"        ) );
	string						    =   	 		  fileGet( file,  "ServerLock"      ); format( sPassword, sizeof( sPassword ), string );
	string						    =   	 		  fileGet( file,  "RoundsTime"      ); for ( new i; i < 4; i ++ ) roundTime [ i ] =   strval( strtok( string, index ) ); index = 0;
	string						    =   	 		  fileGet( file,  "WeaponsType"     ); for ( new i; i < 4; i ++ ) weapsType [ i ] =   strval( strtok( string, index ) ); index = 0;
	string						    =   	 		  fileGet( file,  "WeaponsLimit"    ); for ( new i; i < 7; i ++ ) setsLimit [ i ] =   strval( strtok( string, index ) ); index = 0;
	string						    =   	 		  fileGet( file,  "MainSpawn"       ); for ( new i; i < 5; i ++ ) 	  mspawn[ i ] = floatstr( strtok( string, index ) ); index = 0;
	string						    =   	 		  fileGet( file,  "SelectScreen"    ); for ( new i; i < 5; i ++ ) 	  selscr[ i ] = floatstr( strtok( string, index ) ); index = 0;

	if ( !fexist( NICKLOG_FILE ) )
		fileCreate( NICKLOG_FILE );

	if ( fexist( TEMP_FILE ) )
		fremove( TEMP_FILE );

  	if      ( !weapsType[ 0x0 ] )	weapsType[ 0x0 ] = 1;
 	else if ( !weapsType[ TDM ] )	weapsType[ TDM ] = 1;

	serverData[ s_serverlock ] = !strcmp ( sPassword, "-1" ) ? ( false ) : ( true );
}

strip_nl( str[ ] )
{
	new len = strlen( str );

	while ( --len && str[ len ] <= ' ' )
		str[ len ] = '\0';
}

fileSet( const file[ ], const info[ ], const value[ ] )
{
	if ( ( strlen( info ) + strlen( value ) ) > MAX_FILE_STRING || !fexist( file ) )
	    return false;

	new File:tfile, File:ofile, temp[ MAX_FILE_STRING ], line[ MAX_FILE_STRING ], bool:set = false;

	strmid( temp, file, 0, strlen( file ) - 4 );

	tfile = fopen( temp, io_write );

	ofile = fopen( file, io_read  );

	while ( fread( ofile, line, sizeof( line ) ) > 0 )
	{
		strip_nl( line );

		if ( !strfind( line, info ) )
		{
			set = true;

			format( line, sizeof( line ), "%s %s\r\n", info, value );
		}
		else
			strcat( line, "\r\n", sizeof( line ) );

		fwrite( tfile, line );
	}

	if ( !set )
	{
	    fclose( ofile );

		ofile = fopen( file, io_append );

	    format( line, sizeof( line ), "%s %s\r\n", info, value );

	    fwrite( ofile, line );

	    fclose( ofile );

		fclose( tfile );

		fremove( temp );

		return true;
	}

    fclose( ofile );

	fclose( tfile );

	tfile = fopen( temp, io_read  );

	ofile = fopen( file, io_write );

	while ( fread( tfile, line, sizeof( line ) ) > 0 )

		fwrite( ofile, line );

    fclose( ofile );

	fclose( tfile );

	fremove( temp );

	return true;
}

fileGet( const file[ ], const info[ ] )
{
	new line[ MAX_FILE_STRING ], entry[ MAX_FILE_STRING ];

	if ( strlen( info ) > MAX_FILE_STRING || !fexist( file ) )
	    return line;

	new File:afile;

	afile = fopen( file, io_read  );

	while ( fread( afile, line, sizeof( line ) ) > 0 )
	{
		new index;

		entry = strtok( line, index );

	    if ( strlen( entry )!= strlen( info ) )
			continue;

		if ( !strcmp( entry, info, true ) )
		{
   			strmid( entry, line, strlen( entry ) + 1, strlen( line ) - 2 );

			fclose( afile );

			return entry;
		}
	}

	fclose( afile );

	return entry;
}

fileCreate( const file[ ] )
{
	new File:afile;

	afile = fopen( file, io_write );

	fclose( afile );
}

strtok( const string[ ], &idx )
{
	new length = strlen( string );

	while ( idx < length && string[ idx ] <= ' ' )
		idx++;

	new offset = idx;
	new result[ 32 ];

	while ( idx < length && string[ idx ] > ' ' && idx - offset < sizeof( result ) - 1 )
	{
		result[ idx - offset ] = string[ idx ];

		idx++;
	}

	result[ idx - offset ] = EOS;

	return result;
}

IsNumeric( const string[ ] )
{
	for ( new i, j = strlen( string ); i < j; i ++ )

		if ( string[ i ] > '9' || string[ i ] < '0' )

			return false;

	return true;
}
/*~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
 INCLUDE: ultm_core.pwn
~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-*/

public scriptSync(  )
{
	new Float:p1[ 3 ], Float:p2[ 3 ];

	loopPlayers( playerid )
	{
	    if ( playerData[ playerid ][ p_spec ] == -1 )
	    {
			if ( playerData[ playerid ][ p_team ] != REF )
			{
			    if ( playerData[ playerid ][ p_spawn ] == LOBBY )
			    {
			        loopPlayers( otherid )
			        {
			            if ( playerid == otherid )
			                continue;

						if ( playerData[ otherid ][ p_spawn ] != LOBBY )

							SetPlayerMarkerForPlayer( playerid, otherid, GetPlayerColor( otherid ) & 0xFFFFFF00 );
						else
							SetPlayerMarkerForPlayer( playerid, otherid, GetPlayerColor( otherid ) );

					   	ShowPlayerNameTagForPlayer( playerid, otherid, 1 );
					}
				}
				else
				{
					if ( playerData[ playerid ][ p_spawn ] != LOBBY && !playerData[ playerid ][ p_justsync ] )
					{
					    loopPlayers( otherid )
					    {
				            if ( playerid == otherid )
				                continue;

							if ( playerData[ playerid ][ p_spawn ] == playerData[ otherid ][ p_spawn ] )
							{
								if ( playerData[ playerid ][ p_team ] == playerData[ otherid ][ p_team ] )

									SetPlayerMarkerForPlayer( playerid, otherid, GetPlayerColor( otherid ) ),

							  		ShowPlayerNameTagForPlayer( playerid, otherid, 1 );

								else
								{
									GetPlayerPos( playerid, p1[ 0 ], p1[ 1 ], p1[ 2 ] );

									GetPlayerPos( otherid , p2[ 0 ], p2[ 1 ], p2[ 2 ] );

									if ( InRange( p1[ 0 ], p1[ 1 ], p1[ 2 ], p2[ 0 ], p2[ 1 ], p2[ 2 ], 20.0 ) )

										ShowPlayerNameTagForPlayer( playerid, otherid, 0 );
									else
										ShowPlayerNameTagForPlayer( playerid, otherid, 1 );

									SetPlayerMarkerForPlayer( playerid, otherid, GetPlayerColor( otherid ) & 0xFFFFFF00  );
								}
							}
							else
								SetPlayerMarkerForPlayer  ( playerid, otherid, GetPlayerColor( otherid ) & 0xFFFFFF00 ),

							 	ShowPlayerNameTagForPlayer( playerid, otherid, 0 );
						}
					}
				}
			}
			else
			{
			    loopPlayers( otherid )
			    {
       				if ( playerid == otherid )
           				continue;

					if ( playerData[ playerid ][ p_spec ] == -1 )

						SetPlayerMarkerForPlayer( playerid, otherid, GetPlayerColor( otherid ) ),

						ShowPlayerNameTagForPlayer(playerid, otherid, 1 );
				}
			}
		}
	}
	playersUpdate(  );
}

public OnPlayerStreamIn( playerid, forplayerid )
{
	if( playerData[ playerid ][ p_inround ] && playerData[ forplayerid ][ p_inround ] )
	{
		if( playerData[ forplayerid ][ p_team ] != playerData[ playerid ][ p_team ] )
		{
            if( playerData[ forplayerid ][ p_team ] != REF && playerData[ forplayerid ][ p_team ] != playerData[ playerid ][ p_team ] )
			
                 SetPlayerMarkerForPlayer( forplayerid, playerid,GetPlayerColor( playerid ) & 0xFFFFFF00 );
				 
  			else
                 SetPlayerMarkerForPlayer( forplayerid, playerid,GetPlayerColor( playerid ) | 0x000000FF );
        }
	}
	else if( !playerData[ playerid ][ p_inround ] && playerData[ forplayerid ][ p_inround ] ) 
	{
		if( playerData[ forplayerid ][ p_team ] != playerData[ playerid ][ p_team ] )
		{
            if( playerData[ forplayerid ][ p_team ] != REF && playerData[ forplayerid ][ p_team ] != playerData[ playerid ][ p_team ] )
			
                 SetPlayerMarkerForPlayer( forplayerid, playerid, GetPlayerColor(playerid) & 0xFFFFFF00);
  			
			else 
				SetPlayerMarkerForPlayer( forplayerid, playerid, GetPlayerColor(playerid) | 0x000000FF);
        }
	}
	return true;
}

public playersUpdate(  )
{
	loopPlayers( playerid )
	{
		if ( GetPlayerFPS( playerid ) < serverData[ s_FPSlimit ] && playerData[ playerid ][ p_spawned ] == true )
		{
			playerData[ playerid ][ p_FPS_checks ] ++;

			if ( playerData[ playerid ][ p_FPS_checks ] >= 10 )
			{
				new info[ 100 ];
				
				format( info, sizeof( info ), "*** \"%s\" has been kicked for low fps ( min: %i ).", playerData[ playerid ][ p_name ], serverData[ s_FPSlimit ] );
				
				SendClientMessageToAll( ADMIN_COLOR, info );
				
				if( playerData[ playerid ][ p_inround   ] ) serverData[ s_rpaused ] = true;
				
				SetTimerEx( "KickPlayer", 100, false, "d", playerid );
			}
		}
		else
		{
			if ( playerData[ playerid ][ p_FPS_checks ] )

				playerData[ playerid ][ p_FPS_checks ] = 0;
		}
		
		if ( GetPlayerPing( playerid ) > serverData[ s_pinglimit ] && playerData[ playerid ][ p_spawned ] == true )
		{
			playerData[ playerid ][ p_ping_checks ] ++;

			if ( playerData[ playerid ][ p_ping_checks ] >= 10 )
			{
				new info[ 100 ];
				
				format( info, sizeof( info ), "*** \"%s\" has been kicked for high ping ( max: %i ).", playerData[ playerid ][ p_name ], serverData[ s_pinglimit ] );
				
				SendClientMessageToAll( ADMIN_COLOR, info );
				
				if( playerData[ playerid ][ p_inround   ] ) serverData[ s_rpaused ] = true;
				
				SetTimerEx( "KickPlayer", 100, false, "d", playerid );
			}
		}
		else
		{
			if ( playerData[ playerid ][ p_ping_checks ] )

				playerData[ playerid ][ p_ping_checks ] = 0;
		}
		
		if ( strval( GetPlayerPacketLoss( playerid ) ) > serverData[ s_packetlimit ] && playerData[ playerid ][ p_spawned ] == true )
		{
			playerData[ playerid ][ p_packet_checks ] ++;

			if ( playerData[ playerid ][ p_packet_checks ] >= 10 )
			{
				new info[ 100 ];
				
				format( info, sizeof( info ), "*** \"%s\" has been kicked for high packetloss ( max: %i ).", playerData[ playerid ][ p_name ], serverData[ s_packetlimit ] );
				
				SendClientMessageToAll( ADMIN_COLOR, info );
				
				if( playerData[ playerid ][ p_inround   ] ) serverData[ s_rpaused ] = true;
				
				SetTimerEx( "KickPlayer", 100, false, "d", playerid );
			}
		}
		else
		{
			if ( playerData[ playerid ][ p_packet_checks ] )

				playerData[ playerid ][ p_packet_checks ] = 0;
		}		
        if ( serverData[ s_modetype ] == DM && playerData[ playerid ][ p_inround ] )
        {
            if( playerData[ playerid ][ p_health ] > 50) SetPlayerColor( playerid, 0x4BE824FF );
			
            if( playerData[ playerid ][ p_health ] < 50 && playerData[ playerid ][ p_health ] > 15 ) SetPlayerColor( playerid, 0xE6FF00FF );
			
            if( playerData[ playerid ][ p_health ] < 15) SetPlayerColor( playerid, 0xFF2200FF );
        }

		GetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );

		GetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );

		ResetPlayerMoney( playerid );

		GivePlayerMoney ( playerid, - ( floatround( playerData[ playerid ][ p_health ] + playerData[ playerid ][ p_armour ] ) ) );

	}
}

StartRound(   )
{
	fileCreate( TEMP_FILE );

	serverData[ s_rstarting ] = true;
	serverData[ s_gunmenu   ] = true;
	serverData[ s_attdmg    ] = 0;
	serverData[ s_defdmg    ] = 0;
	
	new string[ 128 ], entry[ 32 ], index;
	
	loopPlayers( playerid )
	{
	    playerData[ playerid ][ p_rounddmg ] = 0;
	    
	  	if( playerData[ playerid ][ p_team ] != REF )
		
			ShowRoundDamageText( playerid );
	    
	    TextDrawShowForPlayer( playerid, rdmgtxd[ playerid ] );

		TextDrawHideForPlayer( playerid, dmgtxt[0][playerid] );

		TextDrawHideForPlayer( playerid, dmgtxt[1][playerid] );
		
		for( new i; i < sizeof( maintxt ); i ++ )

			TextDrawShowForPlayer( playerid, maintxt[ i ] );
	}
	
	timerGun = SetTimer( "DisableGunMenu" , 40000, false );

	if ( serverData[ s_modetype ] == DM )
	{
		for( new i; i < sizeof( RSpawns ); i ++ )
		{
			format( entry, sizeof( entry ), "DmPos%02i", i );

			string = fileGet( getFile( DM, current ), entry );

			for( new j; j < 4; j ++ )

				RSpawns[ i ][ j ] = floatstr( strtok( string, index ) );

			index = 0;
		}
	}
	else
	{
		for( new i; i < 2; i ++ )
		{
			format( entry, sizeof( entry ), "TeamPos%02i", i );

			string = fileGet( getFile( serverData[ s_modetype ], current ), entry );

			for( new j = i ? ( 4 ) : ( 0 );  j < 8;  j ++ )

				sSpawns[ j ] = floatstr( strtok( string, index ) );

			index = 0;
		}
	}

	entry = serverData[ s_modetype ] == BASE ? ( "Checkpoint" ) : ( "StartCam" );

	string = fileGet( getFile( serverData[ s_modetype ], current ), entry );

	for( new i = 8;  i < 12; i ++ )

		sSpawns[ i ] = floatstr( strtok( string, index ) );

	index = 0;

	string = fileGet( getFile( serverData[ s_modetype ], current ), "Interior" );

	sSpawns[ 12 ] = floatstr( strtok( string, index ) );

	index = 0;

	if ( serverData[ s_modetype ] != BASE )
	{
		string = fileGet( getFile( serverData[ s_modetype ], current ), "MinX" );

		for( new i = 13; i < 15; i ++ )

			sSpawns[ i ] = floatstr( strtok( string, index ) );

		index = 0;

		string = fileGet( getFile( serverData[ s_modetype ], current ), "MaxY" );

		for( new i = 15; i < 17; i ++ )

			sSpawns[ i ] = floatstr( strtok( string, index ) );

		index = 0;
	}

	if ( serverData[ s_modetype ] == BASE )
	{
		if ( serverData[ s_attdef ] )

			attacker = 1, defender = 0;
		else
			attacker = 0, defender = 1;

		gangZone = GangZoneCreate( sSpawns[ 8 ] - 90, sSpawns[ 9 ] - 90, sSpawns[ 8 ] + 90, sSpawns[ 9 ] + 90 );

	    for( new i; i < 7; i ++ )

			setsChoises[ HOME ][ i ] = 0,

			setsChoises[ AWAY ][ i ] = 0;
	}
	else
		gangZone = GangZoneCreate( sSpawns[ 15 ], sSpawns[ 16 ], sSpawns[ 13 ], sSpawns[ 14 ] );

	new song = randomSongs[ random( sizeof( randomSongs ) ) ];

	loopPlayers( playerid )
	{
	    if ( playerData[ playerid ][ p_spawn ] == LOBBY && !playerData[ playerid ][ p_sub ] )
		{
			playerData[ playerid ][ p_starting ] = true;

			if ( playerData[ playerid ][ p_duel ] )
			{
				new duelid = playerData[ playerid ][ p_duel ];

				playerData[ playerid ][ p_duel ] = 0;

			    for( new o; o < sizeof( duelObjects ); o ++ )

					DestroyPlayerObject( playerid, p_object[ playerid ][ o ] );

				duelplay[ duelid ][ 0 ] = 255;

				duelplay[ duelid ][ 1 ] = 255;

				duelslot[ duelid ] 	    = 0;
			}

		 	PlayerPlaySound         ( playerid, song, sSpawns[ 8 ], sSpawns[ 9 ], sSpawns[ 10 ] + 80 );

			SetPlayerPos            ( playerid,       sSpawns[ 8 ], sSpawns[ 9 ], sSpawns[ 10 ] + 80 );

			SetPlayerInterior       ( playerid, floatround( sSpawns[ 12 ] ) );

			SetPlayerHealth         ( playerid, 100 );

			SetPlayerArmour         ( playerid, 100 );

			GetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );

			GetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );

			SetPlayerVirtualWorld   ( playerid, 1 );

			TogglePlayerControllable( playerid, 0 );

			ResetPlayerWeapons      ( playerid );

			if ( serverData[ s_modetype ] == BASE )

				SetPlayerCheckpoint   ( playerid, sSpawns[ 8 ], sSpawns[ 9 ], sSpawns[ 10 ], 2 ),

				GangZoneShowForPlayer ( playerid, gangZone, teamColor[ defender ][ 1 ] & 0xFFFFFF50 );
			else
				GangZoneShowForPlayer ( playerid, gangZone, teamColor[ HOME ][ 1 ] & 0xFFFFFF50 ),

				GangZoneFlashForPlayer( playerid, gangZone, teamColor[ AWAY ][ 1 ] & 0xFFFFFF50 );
		}
	}
	
	rotateCam(   );

	countInit(   );
}

public rotateCam(   )
{
	if ( !serverData[ s_rstarting ] )
		return;

	new Float:sCamera[ 2 ];

	sCamera[ 0 ] = sSpawns[ 8 ];
	sCamera[ 1 ] = sSpawns[ 9 ];

	v_angle += 0.4;

	if ( v_angle >= 360.0 )
		v_angle = 0.0;

	sCamera[ 0 ] += ( 40.0 * floatsin( v_angle, degrees ) );
	sCamera[ 1 ] += ( 40.0 * floatcos( v_angle, degrees ) );

	loopPlayers( playerid )
	{
		if ( playerData[ playerid ][ p_starting ] )
		{
       	   	SetPlayerCameraPos   ( playerid, sCamera[ 0 ], sCamera[ 1 ], sSpawns[ 10 ] + 40.0 );
			SetPlayerCameraLookAt( playerid, sSpawns[ 8 ], sSpawns[ 9 ], sSpawns[ 10 ] );
		}
	}

	SetTimer( "rotateCam", 25, false );
}

public countInit(   )
{
	if ( serverData[ s_starttime ] > 0 )
	{
		serverData[ s_starttime ]--;

		new info[ 60 ];

		format( info,sizeof( info ), "~w~~h~%s ~y~%i ~w~~h~starting in ~r~%i ~w~~h~seconds.", serverData[ s_modetype ] == BASE ? ( "Base" ) : ( "Arena" ), current, serverData[ s_starttime ] + 1 );

		TextDrawSetString( maintxt[ 1 ], info );

		loopPlayers( playerid )	{
			PlayerPlaySound( playerid, 1137, 0, 0, 0 );
		}

		SetTimer( "countInit", 1000, false );

		for( new i; i < sizeof( maintxt ); i ++ )

			TextDrawShowForAll( maintxt[ i ] );
	}
	else
	{
		serverData[ s_rstarting ] = false;

		serverData[ s_rstarted  ] = true;

		loopPlayers( playerid )
		{
			if ( playerData[ playerid ][ p_starting ] )
			{
				playerData[ playerid ][ p_spawn    ] = serverData[ s_modetype ];
				playerData[ playerid ][ p_starting ] = false;

				PlayerPlaySound( playerid, 1063, 0, 0, 0 );
				AddPlayer      ( playerid );
			}
		}

		TextDrawSetString( maintxt[ 1 ], "" );

		new timer[ 15 ];

		format  ( timer, sizeof( timer ), "updateRound%i", serverData[ s_modetype ] + 1 );

		SetTimer( timer, 500, false );
		
		loopPlayers( playerid )
		
			SetTimerEx( "UpdateMaintxt", 500, false, "d", playerid );	

		updateMap(   );
		
	}
}

public updateRound1(  )
{
	if ( !serverData[ s_rstarted ] )
		return false;

	new playas;

	loopPlayers( playerid )
	{
	    if ( !playerData[ playerid ][ p_inround ] )
			continue;

		if ( playerData[ playerid ][ p_team ] != REF )

			playas ++;
	}

	if ( !serverData[ s_rpaused ] )
	{
		serverData[ s_modesec ] --;

		if ( serverData[ s_modesec ] < 0 )
		{
			serverData[ s_modesec ] = 59;

			serverData[ s_modemin ] --;

			if ( serverData[ s_modemin ] < 0 )
				return teamWinner = 2, EndRound( 2 );
		}

		if ( playas <= 1 && !serverData[ s_rpaused ] )
			return teamWinner = 2, EndRound( 2 );
	}

	format( sbString, sizeof( sbString ), "~g~~h~Arena: ~w~~h~%i                      ~r~~h~KILL ALL !!!                      ~g~~h~Time: ~w~~h~%02d:%02d", current, serverData[ s_modemin ], serverData[ s_modesec ] );

	TextDrawSetString( maintxt[ 1 ], sbString );

	SetTimer( "updateRound1", 1000, false );

	return true;
}

public updateRound2(  )
{
	if ( !serverData[ s_rstarted ] )
		return false;
	
	new alive[ 2 ];

	loopPlayers( playerid )
	{
	    if ( !playerData[ playerid ][ p_inround ] )
			continue;

		if ( playerData[ playerid ][ p_team ] != REF )
		
			alive[ playerData[ playerid ][ p_team ] ] ++;
	}	

	if ( !serverData[ s_rpaused ] )
	{
		serverData[ s_modesec ] --;

		if ( serverData[ s_modesec ] < 0 )
		{
			serverData[ s_modesec ] = 59;

			serverData[ s_modemin ] --;

			if ( serverData[ s_modemin ] < 0 )
			{
				if ( teamData[ HOME ][ t_kills ] >  teamData[ AWAY ][ t_kills ] ) return teamWinner = 0, EndRound( 2 );
				if ( teamData[ HOME ][ t_kills ] <  teamData[ AWAY ][ t_kills ] ) return teamWinner = 1, EndRound( 2 );
				if ( teamData[ HOME ][ t_kills ] == teamData[ AWAY ][ t_kills ] ) return teamWinner = 2, EndRound( 2 );
			}
		}
		if ( alive[ 0 ] <= 0 ) return teamWinner = 1, EndRound( 0 );
	 	if ( alive[ 1 ] <= 0 ) return teamWinner = 0, EndRound( 0 );
	}

	format( sbString, sizeof( sbString ), "%s%s  -  ~h~Kills: ~w~~h~%i             ~w~(~g~%02d:%02d~w~)             %s%s  -  ~h~Kills: ~w~~h~%i", teamText[ HOME ], teamName[ HOME ], teamData[ HOME ][ t_kills ], serverData[ s_modemin ], serverData[ s_modesec ],
 																																																		  teamText[ AWAY ], teamName[ AWAY ], teamData[ AWAY ][ t_kills ] );
	TextDrawSetString( maintxt[ 1 ], sbString );

	SetTimer( "updateRound2", 1000, false );
	
	return true;
}

public updateRound3(  )
{
	if ( !serverData[ s_rstarted ] )
		return false;
		
	new alive[ 2 ];

	loopPlayers( playerid )
	{
	    if ( !playerData[ playerid ][ p_inround ] )
			continue;

		if ( playerData[ playerid ][ p_team ] != REF )
		
			alive[ playerData[ playerid ][ p_team ] ] ++;
	}	
	
	if ( alive[ 0 ] <= 0 ) return teamWinner = 1, EndRound( 0 );
	if ( alive[ 1 ] <= 0 ) return teamWinner = 0, EndRound( 0 );	

	if( !serverData[ s_mainmode ] )
	{
		new Life[ 0x02 ];

		Life[ 0 ] = teamData[ HOME ][ t_health ] / teamData[ HOME ][ t_players ] / 2;

		Life[ 1 ] = teamData[ AWAY ][ t_health ] / teamData[ AWAY ][ t_players ] / 2;

		format( sbString, sizeof( sbString ), "%s%s~w~: %s%d~w~/%s%d ~w~(%s%d%%~w~)               ~w~(~g~--:--~w~)               %s%s~w~: %s%d~w~/%s%d ~w~(%s%d%%~w~)", teamText[ HOME ], teamName[ HOME ], teamText[ HOME ], alive[ HOME ], teamText[ HOME ], teamData[ HOME ][ t_players ], teamText[ HOME ], Life[ 0 ],
																																																																		  teamText[ AWAY ], teamName[ AWAY ], teamText[ AWAY ], alive[ AWAY ], teamText[ AWAY ], teamData[ AWAY ][ t_players ], teamText[ AWAY ], Life[ 1 ] );
	}
	else
	{
		format( sbString, sizeof( sbString ), "%s%s~w~: %s%d~w~/%s%d ~w~(%s%d%%~w~)               ~w~(~g~--:--~w~)               %s%s~w~: %s%d~w~/%s%d ~w~(%s%d%%~w~)", teamText[ HOME ], teamName[ HOME ], teamText[ HOME ], alive[ HOME ], teamText[ HOME ], teamData[ HOME ][ t_players ], teamText[ HOME ], teamData[ 0 ][ t_health ],
																																																																	  teamText[ AWAY ], teamName[ AWAY ], teamText[ AWAY ], alive[ AWAY ], teamText[ AWAY ], teamData[ AWAY ][ t_players ], teamText[ AWAY ], teamData[ 1 ][ t_health ] );
	}
	TextDrawSetString( maintxt[ 1 ], sbString );
	
	teamData[ 0 ][ t_alive ] = alive[ 0 ];
	teamData[ 1 ][ t_alive ] = alive[ 1 ];

	SetTimer( "updateRound3", 1000, false );

	return true;
}

public updateRound4( )
{
	if ( !serverData[ s_rstarted ] )
		return false;


	new alive[ 2 ];

	loopPlayers( playerid )
	{
	    if ( !playerData[ playerid ][ p_inround ] )
			continue;

		if ( playerData[ playerid ][ p_team ] != REF )
		
			alive[ playerData[ playerid ][ p_team ] ] ++;
	}	
		
	if ( serverData[ s_capturing ] && !serverData[ s_rpaused ] )
	{
		if ( serverData[ s_cptime ] > 0 )
		{
			format( cpString, sizeof( cpString ), "CP: %02d", serverData[ s_cptime ] );

			TextDrawSetString( maintxt[ 2 ], cpString );

			serverData[ s_cptime ] --;

			loopPlayers( playerid )

				PlayerPlaySound( playerid, 1056, 0, 0, 0 );
		}
		else
		{
			serverData[ s_cptime ] = checkTimer;

			teamWinner = attacker;

			EndRound( 1 );

			return true;
		}
	}

	if ( !serverData[ s_rpaused ] )
	{
		serverData[ s_modesec ] --;

		if ( serverData[ s_modesec ] < 0 )
		{
			serverData[ s_modesec ] = 59;

			serverData[ s_modemin ] --;

			if ( serverData[ s_modemin ] < 0 )
				return teamWinner = defender, EndRound( 2 );
		}
		if ( alive[ 0 ] <= 0 ) return teamWinner = 1, EndRound( 0 );
		if ( alive[ 1 ] <= 0 ) return teamWinner = 0, EndRound( 0 );
	}

	if( !serverData[ s_mainmode ] )
	{
		new Life[ 0x02 ];
		
		Life[ 0 ] = teamData[ HOME ][ t_health ] / teamData[ HOME ][ t_players ] / 2;

		Life[ 1 ] = teamData[ AWAY ][ t_health ] / teamData[ AWAY ][ t_players ] / 2;

		format( sbString, sizeof( sbString ), "%s%s~w~: %s%d~w~/%s%d ~w~(%s%d%%~w~)               ~w~(~g~%02d:%02d~w~)               %s%s~w~: %s%d~w~/%s%d ~w~(%s%d%%~w~)", teamText[ HOME ], teamName[ HOME ], teamText[ HOME ], alive[ HOME ], teamText[ HOME ], teamData[ HOME ][ t_players ], teamText[ HOME ], Life[ 0 ], serverData[ s_modemin ], serverData[ s_modesec ],
																																																																		  teamText[ AWAY ], teamName[ AWAY ], teamText[ AWAY ], alive[ AWAY ], teamText[ AWAY ], teamData[ AWAY ][ t_players ], teamText[ AWAY ], Life[ 1 ] );
	}
	else 
	{
		format( sbString, sizeof( sbString ), "%s%s~w~: %s%d~w~/%s%d ~w~(%s%d~w~)               ~w~(~g~%02d:%02d~w~)               %s%s~w~: %s%d~w~/%s%d ~w~(%s%d~w~)", teamText[ HOME ], teamName[ HOME ], teamText[ HOME ], alive[ HOME ], teamText[ HOME ], teamData[ HOME ][ t_players ], teamText[ HOME ], teamData[ 0 ][ t_health ], serverData[ s_modemin ], serverData[ s_modesec ],
																																																																		  teamText[ AWAY ], teamName[ AWAY ], teamText[ AWAY ], alive[ AWAY ], teamText[ AWAY ], teamData[ AWAY ][ t_players ], teamText[ AWAY ], teamData[ 1 ][ t_health ] );
	}
	TextDrawSetString( maintxt[ 1 ], sbString );
	
	teamData[ 0 ][ t_alive ] = alive[ 0 ];
	teamData[ 1 ][ t_alive ] = alive[ 1 ];

	SetTimer( "updateRound4", 1000, false );

	return true;
}

EndRound( reason )
{
	#pragma unused reason
	
	if ( !serverData[ s_rstarted ] )
		return false;

    new final[ 12 ][ 80 ];

    if( serverData[ s_gunmenu ] == true )
    {
		KillTimer( timerGun );
		
		serverData[ s_gunmenu ] = false;
		
		loopPlayers( playerid ) Update3DTextLabelText( playerData[ playerid ][ p_label], 0xFFFFFFFF, "" );
	}

	serverData[ s_rending  ] = true;
	serverData[ s_rstarted ] = false;

	fremove        ( TEMP_FILE );
	GangZoneDestroy( gangZone  );

	loopPlayers( playerid )
	{
		TextDrawHideForPlayer( playerid, rdmgtxd[ playerid ] );

		TextDrawHideForPlayer( playerid, Spectating[ playerid ] );
		
		TextDrawHideForPlayer( playerid, dmgtxt[0][playerid] );

		TextDrawHideForPlayer( playerid, dmgtxt[1][playerid] );
		
		hideBars( playerid );

		if( MatchMode == true )

			playerData[ playerid ][ p_cdmg ] += playerData[ playerid ][ p_rounddmg ];
		
		for( new i; i < sizeof( maintxt ); i ++ )

			TextDrawHideForPlayer( playerid, maintxt[ i ] );

	    if ( playerData[ playerid ][ p_spawn ] != LOBBY )
	    {

		    playerData[ playerid ][ p_spawn ] = LOBBY;

			SetPlayerWorldBounds( playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000 );

			SetPlayerPos        ( playerid, 0, 0, 0 );

			SpawnLobby          ( playerid, 1 );
		}
		else
		{
		    if ( GetPlayerState( playerid ) == PLAYER_STATE_SPECTATING && playerData[ playerid ][ p_spec ] > -1 )

		        StopSpectate( playerid );
		}
	}

	if ( serverData[ s_modetype ] == DM )
	{
	    new top, first, second, third;

	    loopPlayers( playerid )
		{
	 	       if ( playerData[ playerid ][ p_dmpoints ] > top )

		           top = playerData[ playerid ][ p_dmpoints ], first = playerid;
		}
		top = 0;
		loopPlayers( playerid )
		{
	 	       if ( playerData[ playerid ][ p_dmpoints ] > top && playerid != first )

		           top = playerData[ playerid ][ p_dmpoints ], second = playerid;
		}
		top = 0;
		
		if( teamData[ HOME ][ t_current ]+teamData[ AWAY ][ t_current ] > 2 )
			{
			loopPlayers( playerid )
			{
				   if ( playerData[ playerid ][ p_dmpoints ] > top && playerid != first && playerid != second )

					   top = playerData[ playerid ][ p_dmpoints ], third = playerid;
			}
		}
		else TextDrawSetString( dmtxt[ 2 ], "3 - No one ~r~0 points ~w~( 0 kills )" );
		
		
		format( final[ 0 ], sizeof( final[ ] ), "~w~1 - %s ~r~%d points ~w~( %d kills ) ", playerData[ first ][ p_name ], playerData[ first ][ p_dmpoints ], playerData[ first ][ p_rkills ] );

	    format( final[ 1 ], sizeof( final[ ] ), "~w~2 - %s ~r~%d points ~w~( %d kills )", playerData[ second ][ p_name ], playerData[ second ][ p_dmpoints ], playerData[ second ][ p_rkills ] );

	    format( final[ 2 ], sizeof( final[ ] ), "~w~3 - %s ~r~%d points ~w~( %d kills )", playerData[ third ][ p_name ], playerData[ third ][ p_dmpoints ], playerData[ third ][ p_rkills ] );

		TextDrawSetString( dmtxt[ 0 ], final[ 0 ] );
		TextDrawSetString( dmtxt[ 1 ], final[ 1 ] );
		if( teamData[ HOME ][ t_current ]+teamData[ AWAY ][ t_current ] > 2 ) TextDrawSetString( dmtxt[ 2 ], final[ 2 ] );
		
		new count;
		
		count = teamData[ HOME ][ t_current ] + teamData[ AWAY ][ t_current ];
		
		if( count > 2 ) TextDrawSetString( dmtxt[ 2 ], final[ 2 ] );

		loopPlayers( playerid )
		{
			PlayerPlaySound( playerid, 1057, mspawn[ 0 ], mspawn[ 1 ], mspawn[ 2 ] );
			PlayerPlaySound( playerid, 1076, mspawn[ 0 ], mspawn[ 1 ], mspawn[ 2 ] );

		    if ( playerData[ playerid ][ p_duel ] || playerData[ playerid ][ p_class ] > -1 )
				continue;

			TextDrawHideForPlayer( playerid, maintxt[ 0 ] );
			TextDrawHideForPlayer( playerid, maintxt[ 1 ] );

			for( new text = 0; text < sizeof( dmtxt ); text ++ )

				TextDrawShowForPlayer( playerid, dmtxt[ text ] );
		}
		SetTimer( "hideTexts", 7000, false );
	}
	else if ( serverData[ s_modetype ] == BASE || serverData[ s_modetype ] == TDM || serverData[ s_modetype ] == ARENA )
	{
	    new string[ 128 ];

		teamData[ teamWinner ][ t_score ] ++;

	 	if( MatchMode == true )
	 	{
	 	    new str[ 20 ];
	 	    
            format( str, sizeof( str ), "%s", teamName[ teamWinner ] );
			
			format( ResultsN[ RoundCounts ], sizeof( ResultsN[ ] ), str );

            format( str, sizeof( str ), "%d", teamWinner );
			
			format( ResultsW[ RoundCounts ], sizeof( ResultsW[ ] ), str );
			
            format( str, sizeof( str ), "%d", current );
			
			format( ResultsR[ RoundCounts ], sizeof( ResultsR[ ] ), str );
	 	}

		RoundCounts ++;
		/*
		new top[ MAX_PLAYERS / 2 ] = -1, actualtop[ MAX_PLAYERS / 2 ] = -1, count;
		
		for( new t; t < sizeof( top[ ] ); t ++ )
		{
			loopPlayers( i )
			{
				if( playerData[ i ][ p_rounddmg ] > actualtop[ count ] )
				
					actualtop[ count ] = i, top[ count ] = i;
			}
			count ++;
		}*/
		
		loopPlayers( i )
		{
		    if( playerData[ i ][ p_team ] == HOME && !playerData[ i ][ p_sub  ] )
		    {
		        format( string, sizeof( string ), "%s~h~~h~%s~n~", teamText[ HOME ], playerData[ i ][ p_name ]);

          		strcat( final[ 1 ], string);

		        format( string, sizeof( string ), "%d~n~", playerData[ i ][ p_rkills ] );

          		strcat( final[ 5 ], string);

				format( string, sizeof( string ), "%.0f~n~", playerData[ i ][ p_rounddmg ] );

          		strcat( final[ 7 ], string);
		    }
		    if( playerData[ i ][ p_team ] == AWAY && !playerData[ i ][ p_sub  ] )
		    {
		        format( string, sizeof( string ), "%s~h~~h~%s~n~", teamText[ AWAY ], playerData[ i ][ p_name ]);

          		strcat( final[ 2 ], string);

		        format( string, sizeof( string ), "%d~n~", playerData[ i ][ p_rkills ] );

          		strcat( final[ 6 ], string);

				format( string, sizeof( string ), "%.0f~n~", playerData[ i ][ p_rounddmg ] );

          		strcat( final[ 8 ], string);
		    }
		}

		final[ 0 ][ 0 ] = EOS;

	  	if ( teamWinner != REF )

			format( final[ 9 ], sizeof( final[ ] ), "%s~h~%s %s!!", teamText[ teamWinner ], teamName[ teamWinner ], reason == 1 ? ( "hold the cp" ) : ( "won the round" ) );
		else
			format( final[ 9 ], sizeof( final[ ] ), "~w~~h~Draw Game");

		if( teamWinner == HOME ) TextDrawSetString( finalboxtxt[ 1 ], "ld_drv:goboat"), TextDrawSetString( finalboxtxt[ 2 ], "ld_drv:naward");

			else if( teamWinner == AWAY ) TextDrawSetString( finalboxtxt[ 1 ], "ld_drv:naward"), TextDrawSetString( finalboxtxt[ 2 ], "ld_drv:goboat");

		if ( serverData[ s_autoswap ] )
		{
			if  ( serverData[ s_attdef ] )

				format( string, sizeof( string ), " *** (AUTO SWAP) - \"%s\" (Attacking) || \"%s\" (Defending).", teamName[ HOME ], teamName[ AWAY ] ),

				serverData[ s_attdef ] = 0;
			else
				format( string, sizeof( string ), "*** (AUTO SWAP) - \"%s\" (Attacking) || \"%s\" (Defending).", teamName[ AWAY ], teamName[ HOME ] ),

				serverData[ s_attdef ] = 1;

			SendClientMessageToAll( ADMIN_COLOR, string );
    	}

	new topscore, topkilla = 255, Float:topscore2, topdmg = 255;

	loopPlayers( playerid )
	{
	    if ( playerData[ playerid ][ p_rkills ] )
	    {
	        if ( playerData[ playerid ][ p_rkills ] > topscore )

	            topscore = playerData[ playerid ][ p_rkills ], topkilla = playerid;
		}
	    if ( playerData[ playerid ][ p_rounddmg ] )
	    {
	        if ( playerData[ playerid ][ p_rounddmg ] > topscore2 )

	            topscore2 = playerData[ playerid ][ p_rounddmg ], topdmg = playerid;
		}
	}
	
	if ( IsPlayerConnected( topkilla ) )
	{
		fileSet( GetPlayerFile( topkilla ), "TopKiller", intstr( strval( fileGet( GetPlayerFile( topkilla ), "TopKiller" ) ) + 1 ) );

		format( final[ 3 ], sizeof( final[ ] ), "Top Killer: ~h~%s (%i Kills)", playerData[ topkilla ][ p_name ], topscore );
	}
	else
		format( final[ 3 ], sizeof( final[ ] ), "Top Killer: N/A" );

	if ( IsPlayerConnected( topdmg ) )
	{
		format( final[ 4 ], sizeof( final[ ] ), "Top DMG: ~h~%s (%.0f DMG)", playerData[ topdmg ][ p_name ], topscore2 );
	}
	else
		format( final[ 4 ], sizeof( final[ ] ), "Top DMG: N/A" );


	TextDrawSetString( finaltxt[ 3 ], final[ 9 ] );
	TextDrawSetString( finaltxt[ 1 ], final[ 1 ] );
	TextDrawSetString( finaltxt[ 2 ], final[ 2 ] );
	TextDrawSetString( finaltxt[ 5 ], final[ 3 ] );
	TextDrawSetString( finaltxt[ 6 ], final[ 4 ] );
	TextDrawSetString( finaltxt[ 7 ], final[ 5 ] );
	TextDrawSetString( finaltxt[ 8 ], final[ 6 ] );
	TextDrawSetString( finaltxt[ 9 ], final[ 7 ] );
	TextDrawSetString( finaltxt[ 10 ],final[ 8 ] );
	
	loopPlayers( playerid )
	{
		PlayerPlaySound( playerid, 1057, mspawn[ 0 ], mspawn[ 1 ], mspawn[ 2 ] );
		PlayerPlaySound( playerid, 1076, mspawn[ 0 ], mspawn[ 1 ], mspawn[ 2 ] );

	    if ( playerData[ playerid ][ p_duel ] || playerData[ playerid ][ p_class ] > -1 )
	        continue;

		TextDrawHideForPlayer( playerid, maintxt[ 0 ] );
		TextDrawHideForPlayer( playerid, maintxt[ 1 ] );

		for( new i; i < sizeof( finalboxtxt ); i ++ )

			TextDrawShowForPlayer( playerid, finalboxtxt[ i ] );

		for( new text; text < sizeof( finaltxt ); text ++ )

			TextDrawShowForPlayer( playerid, finaltxt[ text ] );
	}

	SetTimer( "hideTexts", 7000, false );

	if ( teamWinner == REF )
	    return true;

	new entry[ 20 ];

	format( entry, sizeof( entry ), "Team%iScore", teamWinner );

	fileSet( CONFIG_FILE, entry, intstr( teamData[ teamWinner ][ t_score ] ) );

	}
	
	resetBars (  );
	
	return true;
}

public hideTexts(  )
{
	current  = -1;
	textBack = false;

	teamData[ HOME ][ t_kills   ] = 0;
	teamData[ AWAY ][ t_kills   ] = 0;
	teamData[ HOME ][ t_players ] = 0;
	teamData[ AWAY ][ t_players ] = 0;

	serverData[ s_modesec   ] = 1;
	serverData[ s_cptime    ] = checkTimer;
	serverData[ s_starttime ] = startTimer;
	serverData[ s_modemin   ] = roundTime[ 0 ];
	serverData[ s_capturing ] = false;
	serverData[ s_rpaused   ] = false;
	serverData[ s_rending   ] = false;
	serverData[ s_rstarting ] = false;
	serverData[ s_resultidx ] = 0;

	updateMap  (  );
	updateCount(  );

	loopPlayers( playerid )
	{
		PlayerPlaySound( playerid, 1063, 0, 0, 0 );

		for( new i; i < sizeof( finalboxtxt ); i ++ )

			TextDrawHideForPlayer( playerid, finalboxtxt[ i ] );

		for( new text; text < sizeof( finaltxt ); text ++ )

			TextDrawHideForPlayer(playerid, finaltxt[ text ] );

		TextDrawShowForPlayer( playerid, Scores );

		for( new text; text < sizeof( dmtxt ); text ++ )

			TextDrawHideForPlayer( playerid, dmtxt[ text ] );

	}

	for( new v; v < MAX_VEHICLES; v ++ )

		if ( roundVeh[ v ] )

			DestroyVehicle( v );

	if( MatchMode && RoundLimits == RoundCounts )
	{
		SendClientMessageToAll( ADMIN_COLOR, "*** Match ended, please wait for results to be displayed.");

		SetTimer( "ClanWarFinal", 2000, false );
		
		PrepareFinalTxd ( );
	}
}

public duelcountseg( duelid )
{
	if( duelseg[ duelid ] < 59 ) duelseg[ duelid ] ++;
	else
	{
		duelseg [ duelid ] = 0;
		duelmin [ duelid ] ++;
	}
}

public duelCounting( duelid )
{
	if ( dueltime[ duelid ] )
	{
		new countStr[ 64 ];

		format( countStr, sizeof( countStr ), " ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~w~~h~%i", dueltime[ duelid ] );

		loopPlayers( playerid )
		{
			if ( playerData[ playerid ][ p_duel ] == duelid )
			{
				GameTextForPlayer( playerid, countStr, 2000, 3 );
				PlayerPlaySound  ( playerid, 1056, 0, 0, 0 );
			}
		}

		SetTimerEx( "duelCounting", 1000, false, "i", duelid );

		dueltime[ duelid ] --;
	}
	else
	{
		duelcountsegtimer = SetTimerEx( "duelcountseg", 1000, true, "i", duelid );

		loopPlayers( playerid )
		{
			if ( playerData[ playerid ][ p_duel ] == duelid )
			{
				GameTextForPlayer( playerid, " ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~r~~h~FIGHT!!", 2000, 3 );
				PlayerPlaySound  ( playerid, 1057, 0, 0, 0 );

				GivePlayerWeapon        ( playerid, duelweap[ duelid ][ 0 ], 9990 );
				GivePlayerWeapon        ( playerid, duelweap[ duelid ][ 1 ], 9990 );
				TogglePlayerControllable( playerid, true );
			}
		}
	}
}

public unpauseCounting( )
{
	if ( serverData[ s_rpaused ] )
	{
		static count;

		if ( count < 3 )
		{
			new string[ 64 ];

			if      ( count == 0 ) string = " ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~r~~h~~h~3 ~r~2 1 ~g~GO !";
			else if ( count == 1 ) string = " ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~r~3 ~r~~h~~h~2 ~r~1 ~g~GO !";
			else if ( count == 2 ) string = " ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~r~3 ~r~2 ~r~~h~~h~1 ~g~GO !";

			loopPlayers( playerid )
			{
				if ( playerData[ playerid ][ p_inround ] || playerData[ playerid ][ p_spec ] > -1 )
				{
					GameTextForPlayer( playerid, string, 1500, 3 );
				}
				PlayerPlaySound( playerid, 1056, 0, 0, 0 );
			}
			SetTimer( "unpauseCounting", 1000, false );
			count ++;
		}
		else
		{
			loopPlayers( playerid )
			{
				if ( playerData[ playerid ][ p_inround ] || playerData[ playerid ][ p_spec ] > -1 || playerData[ playerid ][ p_team ] == REF )
				{
					GameTextForPlayer( playerid, " ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~r~3 ~r~2 ~r~1 ~g~~h~~h~GO !", 1000, 3 );
					TogglePlayerControllable( playerid, true );
				}
				PlayerPlaySound( playerid, 1057, 0, 0, 0 );
			}
			serverData[ s_rpaused ] = false;
			count = 0;
		}
	}
}

public vehiclezSync(  )
{
	new bool:dVehicle[ MAX_VEHICLES ];

    for( new v; v < MAX_VEHICLES; v++ )
	{
	    dVehicle[ v ] = true;

		loopPlayers( playerid )
		{
		    if ( IsPlayerInVehicle( playerid, v ) )
		    {
		        dVehicle[ v ] = false;

		        continue;
			}
		}

		if ( roundVeh[ v ] )

		    dVehicle[ v ] = false;

		if ( dVehicle[ v ] )

		    DestroyVehicle( v );
	}
}

/*~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
 INCLUDE: ultm_cmd.pwn
~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-*/

	CMD:para( playerid, params[ ] )
	{
		new plyWeapons[12], plyAmmo[12];

		for(new slot = 0; slot != 12; slot++)
		{
			new wep, ammo;
			GetPlayerWeaponData( playerid, slot, wep, ammo );

			if( wep != 46 ) GetPlayerWeaponData( playerid, slot, plyWeapons[slot], plyAmmo[slot] );
		}
		new lastgun = GetPlayerWeapon( playerid );
		
		ResetPlayerWeapons(playerid);
		
		for ( new slot = 0; slot != 12; slot++ ) GivePlayerWeapon( playerid, plyWeapons[slot], plyAmmo[slot] );
		
		if( lastgun != 46 ) SetPlayerArmedWeapon( playerid, lastgun );
		
	return true;
	}

	CMD:pm( playerid, params[ ] )
	{
		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /pm [ID] [mensage]." );

        new targetid = strval( tmp );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( targetid == playerid )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't send PMs to yourself." );

		strmid( tmp, params, 2, strlen( params ) );

		if ( !strlen( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /pm [ID] [mensage]." );

		new info[ 128 ];

		format( info, sizeof( info ), "*** %s(%i): %s", playerData[ targetid ][ p_name ], targetid, tmp );

		SendClientMessage( playerid, 0xFFD700FF, info );

	    format( info, sizeof( info ), "> %s(%i): %s", playerData[ playerid ][ p_name ], playerid, tmp );

		SendClientMessage( targetid, 0xFFD700FF, info );

		return true;
	}
	
	CMD:register( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_registered ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This account is already registered." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /register <password>." );

		if ( strlen( params ) < 4 || strlen( params ) > 20 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The pass must have between 4 and 20 characters." );

		new info[ 128 ];

		format( info,sizeof( info ), "(INFO) Your account has been registered ( pass: %s ).", params );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		playerData[ playerid ][ p_logged_in  ] = true;

		playerData[ playerid ][ p_registered ] = true;

		encript( params );

		fileSet( GetPlayerFile( playerid ), "Pass", params );

		fileSet( GetPlayerFile( playerid ), "Regis", "1" );

		PlayerPlaySound( playerid, 1057, 0, 0, 0 );

		return true;
	}

	CMD:login( playerid, params[ ] )
	{
		if ( !playerData[ playerid ][ p_registered ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You aren't registered." );

		if ( playerData[ playerid ][ p_logged_in ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You are already loged-in." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(INFO) Use: /login <password>." );

		new info[ 128 ];

		info = fileGet( GetPlayerFile( playerid ), "Pass" );

		decript( info );

		if ( !strcmp( params, info ) )
		{
			new ip[ 16 ];

			GetPlayerIp( playerid, ip, sizeof( ip ) );

			playerData[ playerid ][ p_logged_in  ] = true;

			playerData[ playerid ][ p_registered ] = true;

			playerData[ playerid ][ p_level      ] = strval( fileGet( GetPlayerFile( playerid ), "Level" ) );

			format( info, sizeof( info ), "(INFO) You are susefull loged-in ( level: %i ).", playerData[ playerid ][ p_level ] );

			SendClientMessage( playerid, MAIN_COLOR1, info );

			PlayerPlaySound( playerid, 1057, 0, 0, 0 );

			fileSet( GetPlayerFile( playerid ), "IP", ip );

			return true;
		}
		else
		    SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Wrong password." );

		return true;
	}

	CMD:netstats( playerid, params[ ] )
	{
 		new stats[400+1], targetid;
 		
 		targetid = strval( params );
 		
	    if( !strlen( params ) )
	    {
  	      GetNetworkStats( stats, sizeof( stats ) );

  	      ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Server Network Stats", stats, "Close", "");
	    }
	    else
	    {
   			if ( !IsPlayerConnected( targetid ) )
				return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

			new string[ 70 ];

			GetPlayerNetworkStats( targetid, stats, sizeof( stats ) );

			format( string, sizeof( string ), "%s's Network Stats", playerData[ targetid ][ p_name] );

			ShowPlayerDialog( playerid, 0, 0, string, stats, "Close", "" );
		}
	return true;
	}

	/*CMD:cmd( playerid, params[ ] )
	{
		SendClientMessage( playerid, MAIN_COLOR2,  " *** Public Commands: " );

		SendClientMessage( playerid, MAIN_COLOR1, " /register /login /kill /sync /v /switch /skin /resetskin /stats /duel /goto" );

		SendClientMessage( playerid, MAIN_COLOR1, " /savep /gotop /dance /scores /view /int /tp /vcolor /admins /netstats" );

		SendClientMessage( playerid, MAIN_COLOR1, " /spec /specoff /credits /gunmenu /mytime /myweather" );
		
		#pragma unused params

		return true;
	}*/
	
	CMD:cmd( playerid, params[ ] )
	{
		#pragma unused params
		
		new listitem[ 90 ], string[ 225 ];
		
		format( listitem, sizeof( listitem ), "{88B8D5}/register /login /kill /sync /v /switch /skin /resetskin /stats /duel /goto\n" );
		
		format( string, sizeof( string ), "%s", listitem );
		
		format( listitem, sizeof( listitem ), "{88B8D5}/savep /gotop /dance /scores /view /int /tp /vcolor /admins /netstats\n" );
		
		format( string, sizeof( string ), "%s%s", string, listitem );
		
		format( listitem, sizeof( listitem ), "{88B8D5}/spec /specoff /credits /gunmenu /mytime /myweather" );
		
		format( string, sizeof( string ), "%s%s", string, listitem );
		
		return ShowPlayerDialog( playerid, 0, DIALOG_STYLE_MSGBOX , "{00B3FF}Public Commands:", string, "Back", "" );
	}

	CMD:scores( playerid, params[ ] )
	{
		new info[ 70 ];

		format( info,sizeof( info ), "*** Team Scores || \"%s\" %i - %i \"%s\" || \"%s\".", teamName[ HOME ], teamData[ HOME ][ t_score ], teamData[ AWAY ][ t_score ], teamName[ AWAY ], playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( MAIN_COLOR2, info );

		#pragma unused params

		return true;
	}

	CMD:credits( playerid, params[ ] )
	{
		#pragma unused params
		
		new listitem[ 86 ], string[ 250 ];
		
		format( listitem, sizeof( listitem ), "{FFFFFF}Ultimate A/D 1.4 by [MrS]Lake.\n\n" );
		
		format( string, sizeof( string ), "%s", listitem );
		
		format( listitem, sizeof( listitem ), "Almost completly edited by Less.\n" );
		
		format( string, sizeof( string ), "%s%s", string, listitem );
		
		format( listitem, sizeof( listitem ), "Thanks to Zeex for ZCMD, 062 for help me with one bug and\n" );
		
		format( string, sizeof( string ), "%s%s", string, listitem );
		
		format( listitem, sizeof( listitem ), "Lake for his health bars callbacks.\n\n" );
		
		format( string, sizeof( string ), "%s%s", string, listitem );
		
		format( listitem, sizeof( listitem ), "Testers: Copper, LazT_, fryze, LouK_ JoseGans10 and Cocoloco. Thanks for help me!" );
		
		format( string, sizeof( string ), "%s%s", string, listitem );
		
		return ShowPlayerDialog( playerid, 0, DIALOG_STYLE_MSGBOX , "{00B3FF}Credits:", string, "Back", "" );
	}

	CMD:kill( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( playerData[ playerid ][ p_starting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_spawn ] != LOBBY && serverData[ s_rpaused ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

	    SetPlayerHealth( playerid, 0.0 );

		GetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );

		GetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );

		#pragma unused params

		return true;
	}
	
	CMD:sync(playerid,params[])
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( IsPlayerInAnyVehicle( playerid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Leave the vehicle first." );

		if ( playerData[ playerid ][ p_syncwait ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You are already syncing." );

		if ( playerData[ playerid ][ p_starting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_spawn ] > LOBBY && serverData[ s_rpaused ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_selecting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now" );

		if( playerData[ playerid ][ p_justsync ] == 0 )
		{
		
		playerData[ playerid ][ p_syncwait ] = true;

	    SetTimerEx( "SyncPlayer2", syncTimer, false, "i", playerid );

		SendClientMessage( playerid, 0x1C86EEFF, "*** Please wait, syncing..." );
		
		playerData[ playerid ][ p_justsync ] = 1;
		
		SetTimerEx( "JustSyncFalse", 1000, false, "i", playerid );
		
			loopPlayers( specid )
			{
		    if( playerData[ specid ][ p_spec ] == playerid )

		   	    SetTimerEx( "StartSpectate", syncTimer+400, false, "ii", specid, playerid );

			}
		}
		else SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You need to wait 1 seconds for sync again.");

		#pragma unused params
		
		return true;
	}

	CMD:v( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( IsPlayerInAnyVehicle( playerid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Leave the vehicle first." );

		if ( playerData[ playerid ][ p_duel ] || playerData[ playerid ][ p_starting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /v <vehicle name>." );

		new Float:x, Float:y, Float:z, Float:r, car, info[ 128 ];

		GetPlayerPos( playerid, x, y, z );

		GetPlayerFacingAngle( playerid, r );

		if ( playerData[ playerid ][ p_spawn ] == LOBBY )
		{
			for ( new i; i < 212; i ++ )
			{
				if ( strfind( carNames[ i ], params, true ) != -1 )
				{
					if ( !IsVehicleValid( i + 400 ) )
						return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This car is disabled." );

					car = CreateVehicle( i + 400, x, y, z, r, strval( fileGet( GetPlayerFile( playerid ), "VColor1" ) ), strval( fileGet( GetPlayerFile( playerid ), "VColor2" ) ), 2000 );

					SetVehicleNumberPlate( car, "LESSMOLA" );
					
					LinkVehicleToInterior ( car, GetPlayerInterior    ( playerid ) );
					SetVehicleVirtualWorld( car, GetPlayerVirtualWorld( playerid ) );

					if ( IsNosCompatible( i + 400 ) )
					{
						AddVehicleComponent( car, 1010 );
						AddVehicleComponent( car, 1087 );
						AddVehicleComponent( car, randomWheels[ random( 17 ) ] );
					}

					PutPlayerInVehicle( playerid, car, 0 );

					roundVeh[ car ] = false;

					format( info, sizeof( info ), "(INFO) Vehicle Created: %s (ID: %i).", carNames[ i ], i + 400 );

					SendClientMessage( playerid, MAIN_COLOR1, info );

					return true;
				}
			}
			SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid vehicle." );
		}
		else
		{
		    if ( playerData[ playerid ][ p_spawn ] != BASE )
				return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't creathe a vehicle now." );

			if ( GetPlayerInterior( playerid ) )
				return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't spawn vehicles in interiors." );

			if ( playerData[ playerid ][ p_spawn ] == BASE && playerData[ playerid ][ p_team ] != attacker )
				return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Only attaquers can spawn vehicles." );

			if ( playerData[ playerid ][ p_spawn ] == BASE && serverData[ s_rpaused ] )
				return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

			if ( playerData[ playerid ][ p_usedv ] >= serverData[ s_vepp ] )
				return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't create more vehicles." );

			if ( x > sSpawns[ 0 ] + 100 || x < sSpawns[ 0 ] - 100 || y > sSpawns[ 1 ] + 100 || y < sSpawns[ 1 ] - 100 )
				return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You are very far from the spawn point." );

			for ( new i; i < 212; i ++ )
			{
				if ( strfind( carNames[ i ], params, true ) != -1 )
				{
					if ( !IsVehicleValid( i + 400 ) )
						return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Vehicle disabled." );

					car = CreateVehicle( i + 400, x, y, z, r, 146, 146, 2000 );

					SetVehicleNumberPlate( car, "LESSMOLA" );
					
					LinkVehicleToInterior ( car, GetPlayerInterior    ( playerid ) );
					SetVehicleVirtualWorld( car, GetPlayerVirtualWorld( playerid ) );

					if ( IsNosCompatible( i + 400 ) )
					{
						AddVehicleComponent( car, 1010 );
						AddVehicleComponent( car, 1087 );
						AddVehicleComponent( car, randomWheels[ random( 17 ) ] );
					}

					PutPlayerInVehicle( playerid, car, 0 );

					roundVeh[ car ] = true;

					format( info, sizeof( info ), "(INFO) Vehicle created: %s (ID: %i).", carNames[ i ], i + 400 );

					SendClientMessage( playerid, MAIN_COLOR1, info );

					return true;
				}
			}
			SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid vehicle." );
		}
		return true;
	}

	CMD:switch( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( IsPlayerInAnyVehicle( playerid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Leave the vehicle first." );

		if ( playerData[ playerid ][ p_duel ] || playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new info[ 30 ];

		switchMenu = CreateMenu( "Switch Menu", 1, 20, 170, 190 );

		format( info, sizeof( info ), "~>~%s", teamName[ HOME ] );

		AddMenuItem( switchMenu, 0, info );

		format( info, sizeof( info ), "~>~%s", teamName[ AWAY ] );

		AddMenuItem( switchMenu, 0, info );

		format( info, sizeof( info ), "~>~%s", teamName[ REF ] );

		AddMenuItem( switchMenu, 0, info );

		format( info,sizeof( info ), "~>~Sub ~w~~h~(%s)", teamName[ HOME ] );

		AddMenuItem( switchMenu, 0, info );

		format( info,sizeof( info ), "~>~Sub ~w~~h~(%s)", teamName[ AWAY ] );

		AddMenuItem( switchMenu, 0, info );

		ShowMenuForPlayer( switchMenu, playerid );

		#pragma unused params

		return true;
	}

	CMD:skin( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( !serverData[ s_setskins ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Command disabled." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( IsPlayerInAnyVehicle( playerid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Leave the vehicle firts." );

		if ( playerData[ playerid ][ p_duel ] || playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This command is disabled now." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /skin <id>." );

		new id = strval( params );

		if ( !IsSkinValid( id ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid skin." );

		if ( id == playerData[ playerid ][ p_skin ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You are ussing this skin." );

		new info[ 64 ];

		format( info, sizeof( info ), "(INFO) You setted your skin at: %i.", id );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		playerData[ playerid ][ p_skin ] = id;

		fileSet( GetPlayerFile( playerid ), "PSkin", intstr( id ) );

		SetPlayerSkin( playerid, id );

		return true;
	}

	CMD:resetskin( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( !serverData[ s_setskins ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Command disabled." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( IsPlayerInAnyVehicle( playerid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Leave the vehicle first." );

		if ( playerData[ playerid ][ p_duel ] || playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_skin ] == -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't change the skin." );

		SendClientMessage( playerid, MAIN_COLOR1, "(INFO) Skin reset." );

		playerData[ playerid ][ p_skin ] = -1;

		fileSet( GetPlayerFile( playerid ), "PSkin", "-1" );

		SetPlayerSkin( playerid, teamData[ playerData[ playerid ][ p_team ] ][ t_skin ] );

		#pragma unused params

		return true;
	}

	CMD:stats( playerid, params[ ] )
	{
		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /stats <playerid>." );

		new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		new rk, rd, dk, dd, tk, td, cp, tp, info[ 128 ];

		rk = strval( fileGet( GetPlayerFile( targetid ), "RoundK"     ) );

		rd = strval( fileGet( GetPlayerFile( targetid ), "RoundD"     ) );

		dk = strval( fileGet( GetPlayerFile( targetid ), "DuelsK"     ) );

		dd = strval( fileGet( GetPlayerFile( targetid ), "DuelsD"     ) );

		cp = strval( fileGet( GetPlayerFile( targetid ), "Checkpoint" ) );

		tp = strval( fileGet( GetPlayerFile( targetid ), "TopKiller"  ) );

		tk = rk + dk;

		td = rd + dd;

		format( info,sizeof( info ), " >>> \"%s\" player stats", playerData[ targetid ][ p_name ] );

		SendClientMessage( playerid, MAIN_COLOR1, info );

	 	format( info,sizeof( info ), " *** Kills: %i | Deaths: %i | Ratio: %0.2f | (Rounds)", rk, rd, floatdiv( rk, rd ) );

		SendClientMessage( playerid, 0x1C86EEFF, info );

	    format( info,sizeof( info ), " *** Kills: %i | Deaths: %i | Ratio: %0.2f | (Duels)", dk, dd, floatdiv( dk, dd ) );

		SendClientMessage( playerid, 0x1C86EEFF, info );

	 	format( info,sizeof( info ), " *** Kills: %i | Deaths: %i | Ratio: %0.2f | (Total)", tk, td, floatdiv( tk, td ) );

		SendClientMessage( playerid, 0x1C86EEFF, info );

		format( info,sizeof( info ), " *** Top Killer: %i | Checkpoint: %i", tp, cp );

		SendClientMessage( playerid, 0x1C86EEFF, info );

		return true;
	}

	CMD:duel( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command" );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Sal de spec primero." );

		if ( playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You are in a duel." );

		new id = strval( params );

		if ( !strlen( params ) || !IsNumeric( params ) || id < 1 || id > 8 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /duel <1-8>." ), SendClientMessage( playerid, GREY_COLOR, "(INFO) <1-2>: Deagle & Spas-12 | <3-4>: Deagle & Shotgun | <5-6>: Deagle & Sniper | <7-8>: Shotgun & Sniper |" );

		if ( duelslot[ id ] > 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There are 2 players in duel." );

		new info[ 80 ];

		SetPlayerHealth         ( playerid, 100 );

		SetPlayerArmour         ( playerid, 100 );

		GetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );

		GetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );

		TogglePlayerControllable( playerid, 0 );

		ResetPlayerWeapons      ( playerid );

		playerData[ playerid ][ p_duel ] = id;

	 	if ( !duelslot[ id ] )
		{
			for ( new o; o < sizeof( duelObjects ); o ++ )

				p_object[ playerid ][ o ] = CreatePlayerObject( playerid, floatround( duelObjects[ o ][ 0 ] ), duelObjects[ o ][ 1 ], duelObjects[ o ][ 2 ], duelObjects[ o ][ 3 ], duelObjects[ o ][ 4 ], duelObjects[ o ][ 5 ], duelObjects[ o ][ 6 ] );

			format( info, sizeof( info ), "*** \"%s\" joined /duel %i (%s).", playerData[ playerid ][ p_name ], id, id == 1 ? ( "Deagle & Spas-12" ) :  id == 2  ? ("Sawnoff & uzi") : id == 3 || id == 4 ? ( "Deagle & Shotgun" ) : id == 5 ? ( "Deagle & Sniper" ) : id == 6 ? ( "Deagle & Flamethower" ) : ( "Shotgun & Sniper" ) );

			SetPlayerPos         ( playerid, 2617.4229,-1692.7103,545.5391 );

           	SetPlayerFacingAngle ( playerid, 41.4 );

			SetPlayerVirtualWorld( playerid, id + 1 );

			SetCameraBehindPlayer( playerid );

		    SetPlayerInterior    ( playerid, 1 );

			duelplay[ id ][ 0 ] = playerid;

			duelslot[ id ] ++;
		}
		else
		{
			for ( new o; o < sizeof( duelObjects ); o ++ )

				p_object[ playerid ][ o ] = CreatePlayerObject( playerid, floatround( duelObjects[ o ][ 0 ] ), duelObjects[ o ][ 1 ], duelObjects[ o ][ 2 ], duelObjects[ o ][ 3 ], duelObjects[ o ][ 4 ], duelObjects[ o ][ 5 ], duelObjects[ o ][ 6 ] );

			format( info, sizeof( info ), "*** \"%s\" joined /duel %i (%s).", playerData[ playerid ][ p_name ], id, id == 1 ? ( "Deagle & Spas-12" ) :  id == 2  ? ("Sawnoff & uzi") : id == 3 || id == 4 ? ( "Deagle & Shotgun" ) : id == 5 ? ( "Deagle & Sniper" ) : id == 6 ? ( "Deagle & Flamethower" ) : ( "Shotgun & Sniper" ) );

			SetPlayerPos         ( playerid, 2588.1948,-1661.9858,545.5391 );

           	SetPlayerFacingAngle ( playerid, 221.7 );

			SetPlayerVirtualWorld( playerid, id + 1 );

			SetCameraBehindPlayer( playerid );

		    SetPlayerInterior    ( playerid, 1 );

			duelplay[ id ][ 1 ] = playerid;

			duelslot[ id ] ++;

			dueltime[ id ] = 3;

			duelseg [ id ] = -3;
			
			duelmin [ id ] = 0;

			SetTimerEx( "duelCounting", 1000, false, "i", id );
		}

		SendClientMessageToAll( DUEL_COLOR, info );

		return true;
	}

	CMD:goto( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY || playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen ( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /goto <playerid>." );

		new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( targetid == playerid )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't go to yourself." );

		if ( playerData[ targetid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player in duel." );

		if ( playerData[ targetid ][ p_spawn ] != LOBBY || playerData[ targetid ][ p_starting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player in round." );

		if ( playerData[ targetid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player is spectating someone." );

		new Float:x, Float:y, Float:z, Float:r, info[ 64 ];

	    GetPlayerPos        ( targetid, x, y, z );
	    GetPlayerFacingAngle( targetid, r );

		SetPlayerPos        ( playerid, x + 1 , y + 1, z );
		SetPlayerFacingAngle( playerid, r );

		SetPlayerInterior   ( playerid, GetPlayerInterior( targetid ) );

		format( info, sizeof( info ), "(INFO) You was teleported to \"%s\".", playerData[ targetid ][ p_name ] );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		format( info, sizeof( info ), "(INFO) \"%s\" was teleported to you.", playerData[ playerid ][ p_name ] );

		SendClientMessage( targetid, MAIN_COLOR1, info );

		return true;
	}

	CMD:savep( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( playerData[ playerid ][ p_starting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		GetPlayerPos        ( playerid, SXYZ[ playerid ][ 0 ], SXYZ[ playerid ][ 1 ], SXYZ[ playerid ][ 2 ] );

		GetPlayerFacingAngle( playerid, SXYZ[ playerid ][ 3 ] );

		SXYZ[ playerid ][ 4 ] = GetPlayerInterior( playerid );

		SendClientMessage( playerid, MAIN_COLOR1, "(INFO) Saved position, tip /gotop for come back." );

		#pragma unused params

		return true;
	}

	CMD:gotop( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY || playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		SetPlayerPos        ( playerid, SXYZ[ playerid ][ 0 ], SXYZ[ playerid ][ 1 ], SXYZ[ playerid ][ 2 ] );

		SetPlayerFacingAngle( playerid, SXYZ[ playerid ][ 3 ] );

		SetPlayerInterior   ( playerid, floatround( SXYZ[ playerid ][ 4 ] ) );

		SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You was teleported to your /savep." );

		#pragma unused params

		return true;
	}

	CMD:readd( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /readd <playerid>." );

        new targetid = strval( tmp );
        
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player isn't spawned." );

		if ( playerData[ targetid ][ p_spawn ] == LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player isn't in a round." );

		if ( playerData[ playerid ][ p_starting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No round started." );

		if ( IsPlayerInAnyVehicle( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player is inside a vehicle." );

		if( !IsNumeric( params ) )
		    return SendClientMessage( playerid, GREY_COLOR, "Use: /readd <playerid>.");
		
		if( playerData[ playerid ][ p_level ] < 1)
		    return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be an admin level 1 for do that.");
		
		new info[ 90 ];

		playerData[ targetid ][ p_readding ] = true;
		playerData[ targetid ][ p_spawn    ] = serverData[ s_modetype ];
		playerData[ targetid ][ p_readded  ] ++;
		setsChoises[ playerData[ targetid ][ p_team ] ][ Var1[playerid] ]--;


		SetPlayerPos( targetid,  0, 0, 0 );
		AddPlayer   ( targetid, playerData[ targetid ][ p_health ], playerData[ playerid ][ p_armour ] );

		if( targetid == playerid ) format( info, sizeof( info ), "*** \"%s\" has readded himself into the round.", playerData[ playerid ][ p_name ] );

			else format( info, sizeof( info ), "*** Admin \"%s\" has readded \"%s\" into the round.", playerData[ playerid ][ p_name ],  playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( MAIN_COLOR2, info );

		#pragma unused params

		return true;
	}

	CMD:dance( playerid, params[ ] )
 	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( playerData[ playerid ][ p_starting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( IsPlayerInAnyVehicle( playerid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Leave the vehicle first." );

		new id = strval( params );

		if ( !strlen( params ) || !IsNumeric( params ) || id < 1 || id > 4 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /dance <1-4>." );

		switch( id )
		{
		    case 1: SetPlayerSpecialAction( playerid, SPECIAL_ACTION_DANCE1 );
		    case 2: SetPlayerSpecialAction( playerid, SPECIAL_ACTION_DANCE2 );
		    case 3: SetPlayerSpecialAction( playerid, SPECIAL_ACTION_DANCE3 );
		    case 4: SetPlayerSpecialAction( playerid, SPECIAL_ACTION_DANCE4 );
		}

		#pragma unused params

		return true;
	}

	CMD:spec( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY && playerData[ playerid ][ p_team ] != REF || playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /spec <playerid>." );

		new	targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( playerData[ targetid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player is spectating." );

		if ( targetid == playerid )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't spec yourself." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player isn't spawned." );

		if ( !serverData[ s_rstarted ] && !playerData[ targetid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't in a round." );
			
		if ( serverData[ s_rstarted ] && serverData[ s_modetype ] > DM && ( playerData[ playerid ][ p_team ] != playerData[ targetid ][ p_team ] && playerData[ playerid ][ p_team ] != REF ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can spec only your team mates." );

		StartSpectate( playerid, targetid );
		
		ShowSpecWeaps( playerid, targetid );	
		
		SendClientMessage( playerid, MAIN_COLOR1, "(INFO) Scroll through players with (FIRE) and (AIM), use (SPRINT) if you want to exit." );
		
		if( playerData[ targetid ][ p_duel ])
		{
			for ( new o; o < sizeof( duelObjects ); o ++ )
			
				p_object[ playerid ][ o ] = CreatePlayerObject( playerid, floatround( duelObjects[ o ][ 0 ] ), duelObjects[ o ][ 1 ], duelObjects[ o ][ 2 ], duelObjects[ o ][ 3 ], duelObjects[ o ][ 4 ], duelObjects[ o ][ 5 ], duelObjects[ o ][ 6 ] );
		}
		
		new string[ 140 ];

		format( string, sizeof( string ), "~b~%s <~w~ID:%d~b~>~n~_~n~~b~~h~Armour ~w~%.0f~n~~b~~h~Health ~w~%.0f~n~~b~~h~Dmg ~w~%.0f~n~~b~~h~Kills ~w~%d~n~~b~~h~Packetloss: ~w~%.0f", playerData[ targetid ][ p_name ], targetid,  playerData[ targetid ][ p_armour ], playerData[ targetid ][ p_health ], playerData[ targetid ][ p_rounddmg ], playerData[ targetid ][ p_rkills ], GetPlayerPacketLoss( targetid ) );

		TextDrawSetString( SpecBox[ playerid ][ 0 ], string );

		TextDrawShowForPlayer( playerid, SpecBox[ playerid ][ 0 ] );

		TextDrawHideForPlayer( playerid, rdmgtxd[playerid] );
		
		UpdateSpecTimer[ playerid ] = SetTimerEx( "UpdateSpec", 1000, true, "d", playerid );
		
		return true;
	}

	CMD:specoff(playerid,params[])
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] == -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You aren't spectating." );

 		StopSpectate( playerid );
 		
		#pragma unused params

		return true;
	}

	CMD:view( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY || playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new tmp[ 85 ], commandid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /view <base/arena/tdm/dm> <id>." );

 		if      ( !strcmp( tmp, "dm"   , true ) )	commandid = DM;
		else if ( !strcmp( tmp, "tdm"  , true ) )	commandid = TDM;
		else if ( !strcmp( tmp, "arena", true ) )	commandid = ARENA;
  		else if ( !strcmp( tmp, "base" , true ) )	commandid = BASE;
		else
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /view <base/arena/tdm/dm> <id>." );

 		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /view <base/arena/tdm/dm> <id>." );

		new id = strval( tmp );

		new info[ 128 ];

		if ( fexist( getFile( commandid, id ) ) )
		{
			new entry[ 12 ], Float:xyz[ 4 ], idx;

			entry = commandid == BASE ? ( "Checkpoint" ) : ( "StartCam" );

			info = fileGet( getFile( commandid, id ), entry );

			for( new i;  i < 3; i ++ )

				xyz[ i ] = floatstr( strtok( info, idx ) );

			idx = 0;

			info = fileGet( getFile( commandid, id ), "Interior" );

			xyz[ 3 ] = floatstr( strtok( info, idx ) );

			playerData[ playerid ][ p_viewmod ] = commandid;
			playerData[ playerid ][ p_viewing ] = id;

			SetPlayerPos     ( playerid, xyz[ 0 ], xyz[ 1 ], xyz[ 2 ] );
			SetPlayerInterior( playerid, floatround( xyz[ 3 ] ) );

			SetPlayerCameraPos      ( playerid, xyz[ 0 ] + 50, xyz[ 1 ] + 50, xyz[ 2 ] + 50 );
			SetPlayerCameraLookAt   ( playerid, xyz[ 0 ],      xyz[ 1 ],      xyz[ 2 ] );
			TogglePlayerControllable( playerid, 0 );

			format( info, sizeof( info ), "(INFO) Use (MOUSE1) y (MOUSE2) for switch in to the %s, use (SPRING) for spawn inside.", commandid == 3 ? ( "bases" ) : ( "arenas" ) );

			SendClientMessage( playerid, MAIN_COLOR1, info );

			format( info, sizeof( info ), "~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~w~~h~%i", id );

			GameTextForPlayer( playerid, info, 5000, 3 );
		}
		else
		{
			format( info, sizeof( info ), "(ERROR) This %s don't exits.", commandid == 3 ? ( "base" ) : ( "arena" ) );

			SendClientMessage( playerid, ERROR_COLOR, info );
		}

		return true;
	}

	CMD:int( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY || playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new	id = strval( params );

		if ( !strlen( params ) || !IsNumeric( params ) || id < 1 || id > 149 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /int <1-149>." );

		if ( fexist ( INT_FILE ) )
		{
			new info[ 128 ], index, Float:pos[ 5 ], entry[ 8 ], name[ 32 ];

			format( entry, sizeof( entry ), "int%i", id );

			info = fileGet( INT_FILE, entry );

			for ( new i;  i < 5; i ++ )

				pos[ i ] = floatstr( strtok( info, index ) );

			strmid( name, info, ( index + 1 ), strlen( info ) );

			SetPlayerPos         ( playerid, pos[ 1 ], pos[ 2 ], pos[ 3 ] );
			SetPlayerInterior    ( playerid, floatround( pos[ 0 ] ) );
			SetPlayerFacingAngle ( playerid, pos[ 4 ] );
			SetCameraBehindPlayer( playerid );

	 		format( info, sizeof( info ), "*** \"%s\" has teleported himself to %i (%s).", playerData[ playerid ][ p_name ], id, name );
		 	SendClientMessageToAll( MAIN_COLOR2, info );
  		}
		else
			SendClientMessage( playerid, ERROR_COLOR, "(ERROR) \"Ints.ini\" not found." );

		return true;
	}

	CMD:tp( playerid, params[ ] )
	{
		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( playerData[ playerid ][ p_starting ] || playerData[ playerid ][ p_spawn ] != LOBBY || playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new	id = strval( params );

		if ( !strlen( params ) || !IsNumeric( params ) || id < 1 || id > 10 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /tp <1-10>." );

   		new info[ 128 ];

		if ( id == 10 )
		{
	   		format( info, sizeof( info ), "*** \"%s\" has teleported to TP Zone %i (Main Spawn).", playerData[ playerid ][ p_name ], id );

			SetPlayerPos        ( playerid, mspawn[ 0 ], mspawn[ 1 ], mspawn[ 2 ] );
			SetPlayerInterior   ( playerid,	 floatround( mspawn[ 4 ] ) 			  );
			SetPlayerFacingAngle( playerid, 			 mspawn[ 3 ] 		      );
   		}
		else
   		{
			new city[ 16 ];

			switch( id )
			{
				case 1..3: city = "Los Santos";
				case 4..6: city = "San Fierro";
				case 7..9: city = "Las Venturas";
			}

			format( info, sizeof( info ), "*** \"%s\" has teleported to TP Zone %i (%s).", playerData[ playerid ][ p_name ], id, city );

			SetPlayerPos        ( playerid, saTeleports[ id ][ 0 ], saTeleports[ id ][ 1 ], saTeleports[ id ][ 2 ] );
			SetPlayerFacingAngle( playerid, saTeleports[ id ][ 3 ] );
			SetPlayerInterior   ( playerid, 0 );
   		}

		SendClientMessageToAll( MAIN_COLOR2, info );

		SetCameraBehindPlayer ( playerid );

		return true;
	}

	CMD:pass( playerid, params[ ] )
	{
		if ( serverData[ s_serverlock ] && !playerData[ playerid ][ p_npass ] )
		{
			if ( !strlen( params ) )
				return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /pass <server pass>." );

			if ( !strcmp( sPassword, params ) )
			{
				playerData[ playerid ][ p_npass ] = true;

				PlayerPlaySound( playerid, 1057, 0, 0, 0 );

				SendClientMessage( playerid, MAIN_COLOR1, "*** Correct password." );

				return true;
	    	}
	 	    else return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Incorrect pass." );
		}
		else return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The server isn't locked." );
	}

	CMD:vcolor( playerid, params[ ] )
	{
		new tmp[ 32 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /vcolor <color1> <color2>." );

		fileSet( GetPlayerFile( playerid ), "VColor1", intstr( strval( tmp ) ) );

		tmp = strtok( params, index );

		if ( !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /vcolor <color1> <color2>." );

	    if ( strlen( tmp ) )
			fileSet( GetPlayerFile( playerid ), "VColor2", intstr( strval( tmp ) ) );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_DRIVER )
		{
			ChangeVehicleColor( GetPlayerVehicleID( playerid ), strval( fileGet( GetPlayerFile( playerid ), "VColor1" ) ), strval( fileGet( GetPlayerFile( playerid ), "VColor2" ) ) );

			PlayerPlaySound( playerid, 1134, 0, 0, 0 );
		}

		return true;
	}
	
	CMD:admins(playerid,params[])
	{
		new count, string[ 80 ], title[ 20 ];
		
		loopPlayers( otherid ) if( playerData[ otherid ][ p_level ] >= 1 ) count++;

		if( count == 0 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There aren't any admin online." );

		format( title, sizeof(title), "*** Admins: %d", count );
	
		SendClientMessage( playerid, 0x9CDE01FF, title );

		loopPlayers( otherid )
		{
			if( playerData[ otherid ][ p_level ] >= 1 )
			{
				format( string, sizeof( string ), "%s (id: %d) level: %d", playerData[ otherid ][ p_name ] , otherid, playerData[ otherid ][ p_level ] );

				SendClientMessage( playerid, MAIN_COLOR1, string );
			}
		}
		
		#pragma unused params
	
		return true;
	}
	
	CMD:setlevel( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		new tmp[ 32 ], targetid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlevel <playerid> <0-3>." );

        targetid = strval( tmp );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( !playerData[ targetid ][ p_registered ] || !playerData[ targetid ][ p_logged_in ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't registered or logged-in." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlevel <playerid> <0-3>." );

		new level = strval( tmp );

		if ( level < 0 || level > 3 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlevel <playerid> <0-3>." );

		new info[ 64 ];

		fileSet( GetPlayerFile( targetid ), "Level", intstr( level ) );

		playerData[ targetid ][ p_level ] = level;

		format( info, sizeof( info ), "(INFO) Admin \"%s\" has setted your level in %i.", playerData[ playerid ][ p_name ], level );

		SendClientMessage( targetid, MAIN_COLOR1, info );

		format( info, sizeof( info ), "(INFO) Has set \"%s\" level in %i.", playerData[ targetid ][ p_name ], level );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		return true;
	}
	
	CMD:settemplevel( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 && !IsPlayerAdmin( playerid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		new tmp[ 32 ], targetid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlevel <playerid> <0-3>." );

        targetid = strval( tmp );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlevel <playerid> <0-3>." );

		new level = strval( tmp );

		if ( level < 0 || level > 3 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlevel <playerid> <0-3>." );

		new info[ 64 ];

		playerData[ targetid ][ p_level ] = level;

		format( info, sizeof( info ), "(INFO) Admin \"%s\" has gived you temp level (%i).", playerData[ playerid ][ p_name ], level );

		SendClientMessage( targetid, MAIN_COLOR1, info );

		format( info, sizeof( info ), "(INFO) Has setted \"%s\" level temporaly in %i.", playerData[ targetid ][ p_name ], level );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		return true;
	}
	
	CMD:create( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		ShowMenuForPlayer( buildMenu[ 0 ], playerid );

		#pragma unused params

		return true;
	}

	CMD:edit(playerid,params[])
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( buildData[ playerid ][ c_editarena ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You are already editing" );

		new tmp[ 85 ], MODE[ 6 ], commandid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /edit <base/arena/tdm/dm> <id>." );

 		if      ( !strcmp( tmp, "dm"   , true ) )	commandid = DM,    MODE = "DM";
		else if ( !strcmp( tmp, "tdm"  , true ) )	commandid = TDM,   MODE = "TDM";
		else if ( !strcmp( tmp, "arena", true ) )	commandid = ARENA, MODE = "ARENA";
  		else if ( !strcmp( tmp, "base" , true ) )	commandid = BASE,  MODE = "BASE";
		else
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /edit <base/arena/tdm/dm> <id>." );

 		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /edit <base/arena/tdm/dm> <id>." );

		new id = strval( tmp );

		new info[ 128 ];

		if ( fexist( getFile( commandid, id ) ) )
		{
			buildData[ playerid ][ c_editmode  ] = commandid;
			buildData[ playerid ][ c_editarena ] = id;

			format( info, sizeof( info ), "(%s BUILD) You are editing %s: %i, use /set.", MODE, commandid == DM ? ( "DM" ) : commandid == TDM ?( "TDM" ) : commandid == ARENA ? ( "arena" ) : ( "base" ), id );

			SendClientMessage( playerid, BUILD_COLOR1, info );
		}
		else
		{
			format( info, sizeof( info ), "(ERROR) That %s dont exist.", commandid == BASE ? ( "base" ) : ( "arena" ) );

			SendClientMessage( playerid, ERROR_COLOR, info );
		}
		return true;
	}

	CMD:delete( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		new tmp[ 85 ], commandid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /delete <base/arena/tdm/dm> <id>." );

 		if      ( !strcmp( tmp, "dm"   , true ) )	commandid = DM;
		else if ( !strcmp( tmp, "tdm"  , true ) )	commandid = TDM;
		else if ( !strcmp( tmp, "arena", true ) )	commandid = ARENA;
  		else if ( !strcmp( tmp, "base" , true ) )	commandid = BASE;
		else
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /delete <base/arena/tdm/dm> <id>." );

 		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /delete <base/arena/tdm/dm> <id>." );

		new id = strval( tmp );

		new info[ 128 ];

		if ( fexist( getFile( commandid, id ) ) )
		{
			format( info,sizeof( info ), "(INFO) You deleted %s: %i.", commandid == DM ? ( "DM" ) : commandid == TDM ?( "TDM" ) : commandid == ARENA ? ( "arena" ) : ( "base" ), id );

			SendClientMessage( playerid, BUILD_COLOR1, info );

			fremove( getFile( commandid, id ) );
		}
		else
		{
			format( info, sizeof( info ), "(ERROR) That %s don't exits.", commandid == BASE ? ( "base" ) : ( "arena" ) );

			SendClientMessage( playerid, ERROR_COLOR, info );
		}
		return true;
	}

	CMD:lock( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /lock <pass>." );

		new info[ 60 ];

		if ( !strcmp( params, "-1" ) )
		{
			format( info, sizeof( info ), "*** Admin \"%s\" has opened server.", playerData[ playerid ][ p_name ] );

			SendClientMessageToAll( ADMIN_COLOR, info );

		    fileSet( CONFIG_FILE, "ServerLock", "-1" );

			serverData[ s_serverlock ] = false;

			sPassword = "-1";
		}
		else
		{
			format( info, sizeof( info ), "*** Admin \"%s\" has closed the server.", playerData[ playerid ][ p_name ] );

			SendClientMessageToAll( ADMIN_COLOR, info );

			SendClientMessage( playerid, GREY_COLOR, "*** Use /lock -1 for unlock the server." );

		    fileSet( CONFIG_FILE, "ServerLock", params );

			serverData[ s_serverlock ] = true;

			format( sPassword, sizeof( sPassword ), params );
		}

		loopPlayers( otherid ){
		    playerData[ otherid ][ p_npass ] = true;
		}

		return true;
	}

	CMD:set( playerid,params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		if ( buildData[ playerid ][ c_editarena ] == -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Tu no estas editando." );

		if ( buildData[ playerid ][ c_setspawns ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No pusiste los spawns." );

		if ( buildData[ playerid ][ c_setboundies ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No pusiste los worldboundies." );

		if ( buildData[ playerid ][ c_setcheckpoint ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No pusiste el checkpoint o la startcamera." );

		switch( buildData[ playerid ][ c_editmode ] )
		{
		    case DM:    ShowMenuForPlayer( buildMenu[ 1 ], playerid );
			case TDM:   ShowMenuForPlayer( buildMenu[ 2 ], playerid );
			case ARENA: ShowMenuForPlayer( buildMenu[ 3 ], playerid );
			case BASE:  ShowMenuForPlayer( buildMenu[ 4 ], playerid );
		}

		#pragma unused params

		return true;
	}

	CMD:mainspawn( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		new entry[ 64 ];

		GetPlayerPos        ( playerid, mspawn[ 0 ], mspawn[ 1 ], mspawn[ 2 ] );

		GetPlayerFacingAngle( playerid, mspawn[ 3 ] );

		mspawn[ 4 ] = GetPlayerInterior( playerid );

		format( entry, sizeof( entry ), "%.3f %.3f %.3f %.3f %.1f", mspawn[ 0 ], mspawn[ 1 ], mspawn[ 2 ], mspawn[ 3 ], mspawn[ 4 ] );

		fileSet( CONFIG_FILE, "MainSpawn", entry );

		SendClientMessage( playerid, MAIN_COLOR1, "(INFO) Your position has been saved has mainspawn." );

		#pragma unused params

		return true;
	}

	CMD:selectscreen( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( playerData[ playerid ][ p_spec ] > -1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Stop spectate first." );

		new entry[ 64 ];

		GetPlayerPos        ( playerid, selscr[ 0 ], selscr[ 1 ], selscr[ 2 ] );

		GetPlayerFacingAngle( playerid, selscr[ 3 ] );

		selscr[ 4 ] = GetPlayerInterior( playerid );

		format( entry, sizeof( entry ), "%.3f %.3f %.3f %.3f %.1f", selscr[ 0 ], selscr[ 1 ], selscr[ 2 ], selscr[ 3 ], selscr[ 4 ] );

		fileSet( CONFIG_FILE, "SelectScreen", entry );

		SendClientMessage( playerid, MAIN_COLOR1, "(INFO) Your position has been saved has SelectScreen." );

		#pragma unused params

		return true;
	}

	CMD:gmx( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		SendRconCommand( "gmx" );

		#pragma unused params

		return true;
	}

	CMD:teamname( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /teamname <teamid> <name>." );

        new teamid = strval( tmp );

		if ( teamid < 0 || teamid > 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid team." );

		strmid( tmp, params, 2, strlen( params ) );

		if ( !strlen( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /teamname <teamid> <name>." );

		new info[ 80 ];

		format( info, sizeof( info ), "Team%iName", teamid );

		fileSet( CONFIG_FILE, info, tmp );

		format( info, sizeof( info ), "*** Admin \"%s\" has setted \"%s\" team name as %s.", playerData[ playerid ][ p_name ], teamName[ teamid ], tmp );

		SendClientMessageToAll( ADMIN_COLOR, info );

		format( teamName[ teamid ], sizeof( teamName[ ] ), tmp );

		updateCount( );
		
        ShowScoresTxd(  );

	   	TextDrawShowForPlayer(playerid,txtTimeDisp);

		return true;
	}

	CMD:teamscore( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /SetScore <teamid> <score>." );

        new teamid = strval( tmp );

		if ( teamid < 0 || teamid > 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid team." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /SetScore <teamid> <score>." );

		new score = strval( tmp );
		
		new info[ 80 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has setted \"%s\" team score to %d.", playerData[ playerid ][ p_name ], teamName[ teamid ], score );

		SendClientMessageToAll( ADMIN_COLOR, info );

		teamData[ teamid ][ t_score ] = score;

		updateCount( );

        ShowScoresTxd(  );
        
	   	TextDrawShowForPlayer(playerid,txtTimeDisp);
	   	
	   	RoundCounts = teamData[ HOME ][ t_score ] + teamData[ AWAY ][ t_score ];

		return true;
	}
	
	CMD:move( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /Move <playerone> <playertwo>." );

        new playerone = strval( tmp );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /Move <playerone> <playertwo>." );

		new playertwo = strval( tmp );

		if ( !IsPlayerConnected( playerone ) || !IsPlayerConnected( playertwo ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		new Float:x, Float:y, Float:z;

		GetPlayerPos( playertwo, x, y, z );
		
		SetPlayerPos( playerone, x, y+1, z );

		new info[ 128 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has moved \"%s\" to \"%s\" position.", playerData[ playerid ][ p_name ], playerData[ playerone ][ p_name ], playerData[ playertwo ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
	}
	
	CMD:replace( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /Replace <playerone> <playertwo>." );

        new playerone = strval( tmp );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /Replace <playerone> <playertwo>." );
			
		if ( !playerData[ playerone ][ p_inround ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player to replace isn't playing the round." );

		new playertwo = strval( tmp );

		if ( !IsPlayerConnected( playerone ) || !IsPlayerConnected( playertwo ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );
			
		if ( playerData[ playertwo ][ p_inround ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player two is already playing the round." );

		new Float:x, Float:y, Float:z, Float:Health, Float:Armour, Float:angle;

		GetPlayerPos		 ( playerone, x, y, z );
		GetPlayerHealth		 ( playerone, Health );
		GetPlayerArmour		 ( playerone, Armour );
		GetPlayerFacingAngle ( playerone, angle );
		
		if ( playerData[ playerone ][ p_selecting ] )
		
			playerData[ playerone ][ p_selecting ] = false;
			
	    playerData[ playerone ][ p_spawn ] = LOBBY;
		
		SetPlayerPos( playerone, 0, 0, 0 );
		SpawnLobby  ( playerone, 1 );
		remPlayerBar( playerone, playerData[ playerone ][ p_team ], FindPlayerBarSlot( playerone, playerData[ playerone ][ p_team ] ) );
		
		playerData[ playertwo ][ p_spawn ] = serverData[ s_modetype ];

		SpawnRound( playertwo, 1 );

		if ( serverData[ s_modetype ] == BASE )
		{
			SetPlayerCheckpoint  ( playertwo, sSpawns[ 8 ], sSpawns[ 9 ], sSpawns[ 10 ], 2.0 );
			GangZoneShowForPlayer( playertwo, gangZone, teamColor[ defender ][ 1 ] & 0xFFFFFF50 );

		}
		else
		{
			SetPlayerWorldBounds  ( playertwo, sSpawns[ 13 ], sSpawns[ 15 ], sSpawns[ 14 ], sSpawns[ 16 ] );
			GangZoneShowForPlayer ( playertwo, gangZone, teamColor[ HOME ][ 1 ] & 0xFFFFFF50 );
			GangZoneFlashForPlayer( playertwo, gangZone, teamColor[ AWAY ][ 1 ] & 0xFFFFFF50 );
		}

		SetPlayerInterior    ( playertwo, floatround( sSpawns[12] ) );
		SetPlayerVirtualWorld( playertwo, 1 );

		SetPlayerHealth		 ( playertwo, Health );
		SetPlayerArmour 	 ( playertwo, Armour );
		SetPlayerFacingAngle ( playertwo, angle );
		SetPlayerPos		 ( playertwo, x, y, z );
		
		if( serverData[ s_modetype ] != DM && serverData[ s_hpbars ]  ) addPlayerBar( playertwo, playerData[ playertwo ][ p_team ], NextAvailableBarSlot( playerData[ playertwo ][ p_team ] ), Health+Armour );

		new info[ 128 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has replaced \"%s\" for \"%s\".", playerData[ playerid ][ p_name ], playerData[ playerone ][ p_name ], playerData[ playertwo ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
	}

	CMD:teamskin( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /teamskin <teamid> <id>." );

        new teamid = strval( tmp );

		if ( teamid < 0 || teamid > 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid team." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /teamskin <teamid> <id>." );

		new skin = strval( tmp );

		if ( !IsSkinValid( skin ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid skin." );

		new info[ 128 ];

		format( info, sizeof( info ), "Team%iSkin %i", teamid, skin );

		fileSet( CONFIG_FILE, info, intstr( skin ) );

		format( info, sizeof( info ), "*** Admin \"%s\" has setted \"%s\" team skin in %i.", playerData[ playerid ][ p_name ], teamName[ teamid ], skin );

		SendClientMessageToAll( ADMIN_COLOR, info );

		teamData[ teamid ][ t_skin ] = skin;

		loopPlayers( otherid )
		{
		    if ( ( playerData[ otherid ][ p_team ] == teamid && !playerData[ playerid ][ p_starting ] && playerData[ otherid ][ p_class ] == -1 ) )
			{
				SetPlayerPos( otherid, 0, 0, 0 );

				playerData  [ otherid ][ p_syncwait ] = true;

				SyncPlayer  ( otherid );
			}
		}

		return true;
	}

	CMD:autoswap( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /autoswap <0-1>." );

        new swap = strval( params );

		if ( swap < 0 || swap > 1 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /autoswap <0-1> ( 0 = off / 1 = on )." );

		fileSet( CONFIG_FILE, "AutoSwap", intstr( swap ) );

		if ( !swap )

			serverData[ s_autoswap ] = false, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You disabled auto-swap." );
		else
			serverData[ s_autoswap ] = true, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You enabled auto-swap." );

		return true;
	}

	CMD:pskins( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /pskins <0-1>." );

        new pskins = strval( params );

		if ( pskins < 0 || pskins > 1 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /pskins <0-1> ( 0 = off / 1 = on )." );

		fileSet( CONFIG_FILE, "PSetSkins", intstr( pskins ) );

		serverData[ s_setskins ] = pskins;

		if ( !pskins )

			SendClientMessage( playerid, MAIN_COLOR1, "(INFO) Desactivaste los players skins." );
		else
			SendClientMessage( playerid, MAIN_COLOR1, "(INFO) Activaste los players skins." );

		return true;
	}

	CMD:freeze( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new info[ 128 ], tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /freeze <playerid>." );

        new targetid = strval( tmp );
        
		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		TogglePlayerControllable( targetid, false );
		
		playerData[ playerid ][ p_frozen ] = 1;

		format( info, sizeof( info ), "*** Admin \"%s\" has frozen \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );


		return true;
	}

	CMD:unfreeze( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new info[ 128 ], tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /unfreeze <playerid>." );

        new targetid = strval( tmp );
        
		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		TogglePlayerControllable( targetid, true );

		playerData[ playerid ][ p_frozen ] = 0;

		format( info, sizeof( info ), "*** Admin \"%s\" has unfrozen \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
	}
	
	CMD:resetskins( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new info[ 128 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has reset all skins.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		loopPlayers( otherid )
		{
			playerData[ otherid ][ p_skin ] = -1;

			fileSet( GetPlayerFile( otherid ), "PSkin", "-1" );

		    if ( ( !playerData[ playerid ][ p_starting ] && playerData[ otherid ][ p_class ] == -1 ) )
			{
				SetPlayerPos( otherid, 0, 0, 0 );

				playerData  [ otherid ][ p_syncwait ] = true;

				SyncPlayer  ( otherid );
			}
		}

		#pragma unused params

		return true;
	}

	CMD:roundtime( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 85 ], commandid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /roundtime <base/arena/tdm/dm> <1-60>." );

 		if      ( !strcmp( tmp, "dm"   , true ) )	commandid = DM;
		else if ( !strcmp( tmp, "tdm"  , true ) )	commandid = TDM;
		else if ( !strcmp( tmp, "arena", true ) )	commandid = ARENA;
  		else if ( !strcmp( tmp, "base" , true ) )	commandid = BASE;
		else
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /roundtime <base/arena/tdm/dm> <1-60>." );

 		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /roundtime <base/arena/tdm/dm> <1-60>." );

		new time = strval( tmp );

		if ( time < 1 || time > 60 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /roundtime <base/arena/tdm/dm> <1-60>." );

		new info[ 128 ];

		serverData [ s_modesec ] = 0;

		serverData [ s_modemin ] = time;

		roundTime[ commandid ] = time;

		format( info, sizeof( info ), "%i %i %i %i", roundTime[ 0 ], roundTime[ 1 ], roundTime[ 2 ], roundTime[ 3 ] );

		fileSet( CONFIG_FILE, "RoundsTime", info );

		format( info, sizeof( info ), "(INFO) You setted the %s time at %i minute%s.", commandid == DM ? ( "DMs" ) : commandid == TDM ?( "TDMs" ) : commandid == ARENA ? ( "arenas" ) : ( "bases" ), time, time > 1 ? ( "s" ) : ( "" ) );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		return true;
	}

	CMD:cptime( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /cptime <5-120>." );

        new cptime = strval( params );

		if ( cptime < 5 || cptime > 120 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /cptime <5-120>." );

		new info[ 60 ];

		checkTimer = cptime;

		serverData[ s_cptime ] = cptime;

		fileSet( CONFIG_FILE, "CheckTime", intstr( cptime ) );

	    format( info, sizeof( info ), "(INFO) You setted the cp time in %i seconds.", cptime );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		return true;
	}

	CMD:stime( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /stime <0-20>." );

        new stime = strval( params );

		if ( stime < 0 || stime > 20 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /stime <0-20>." );

		new info[ 128 ];

		syncTimer = stime * 500;

		fileSet( CONFIG_FILE, "SyncTime", intstr( stime ) );

	    format( info, sizeof( info ), "(INFO) Pusiste el tiempo de sync en %i segundos.", stime );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		return true;
	}

	CMD:weather( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /weather <id>." );

		new info[ 128 ], weather = strval( params );

		fileSet( CONFIG_FILE, "MainWeather", intstr( weather ) );

	    format( info, sizeof( info ), "(INFO) You setted the weather to %i.", weather );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		SetWeather( weather );

		return true;
	}

	CMD:time( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new time = strval( params );

		if ( !strlen( params ) || !IsNumeric( params ) || time < 0 || time > 23 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /time <0-23>." );

		new info[ 128 ];

		fileSet( CONFIG_FILE, "MainTime", intstr( time ) );

	    format( info, sizeof( info ), "(INFO) You setted the time to %02i:00.", time );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		SetWorldTime( time );

		return true;
	}

	CMD:myweather( playerid, params[ ] )
	{
		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /MyWeather <id>." );

		new info[ 45 ], weather = strval( params );

	    format( info, sizeof( info ), "(INFO) You changed your weather %i.", weather );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		SetPlayerWeather( playerid, weather );

		return true;
	}

	CMD:mytime( playerid, params[ ] )
	{
		new time = strval( params );

		if ( !strlen( params ) || !IsNumeric( params ) || time < 0 || time > 23 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /MyTime <0-23>." );

		new info[ 45 ];

	    format( info, sizeof( info ), "(INFO) You changed your time to %02i:00.", time );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		SetPlayerTime( playerid, time, 00 );

		return true;
	}

	CMD:weapons( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
		    return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new tmp[ 85 ], commandid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /weapons <base/arena/tdm> <0-3>." );

		if      ( !strcmp( tmp, "tdm"  , true ) )	commandid = TDM;
		else if ( !strcmp( tmp, "arena", true ) )	commandid = ARENA;
  		else if ( !strcmp( tmp, "base" , true ) )	commandid = BASE;
		else
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /weapons <base/arena/tdm> <0-3>." );

 		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /weapons <base/arena/tdm> <0-3>." );

		new type = strval( tmp );

		if ( type < 0 || type > 3 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /weapons <base/arena/tdm> <0-3>." );

	    if ( type == 0 && commandid == TDM )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use weapon menu for TDM." );

		weapsType[ commandid ] = type;

		new info[ 128 ];

		format( info, sizeof( info ), "%i %i %i %i", weapsType[ 0 ], weapsType[ TDM ], weapsType[ ARENA ], weapsType[ BASE ] );

		fileSet( CONFIG_FILE, "WeaponsType", info );

		format( info, sizeof( info ), "(INFO) You setted the %s to %s.", commandid == DM ? ( "DM" ) : commandid == TDM ?( "TDM" ) : commandid == ARENA ? ( "arenas" ) : ( "bases" ), type == 0 ? ( "weapon menu" ) : type == 1 ? ( "walking weapons ( deagle, shotgun, m4, sniper )" ) : type == 2 ? ( "running weapons ( sawn-off, tec-9 )" ) : ( "mixed weapons ( deagle, sawn-off, tec-9, m4, sniper )" ) );

		SendClientMessage( playerid, MAIN_COLOR1, info );

		return true;
	}

	CMD:setlimit( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new tmp[ 32 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlimit <setid> <0-20>." );

		new setid = strval( tmp );

		if ( setid < 1 || setid > 7 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Weapon set inválido." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlimit <setid> <0-20>." );

		new limit = strval( tmp );

		if ( limit < 0 || limit > 20 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setlimit <setid> <0-20>." );

		new info[ 128 ];

		setsLimit[ setid - 1 ] = limit;

		format( info, sizeof( info ), "%i %i %i %i %i %i %i", setsLimit[ 0 ], setsLimit[ 1 ], setsLimit[ 2 ], setsLimit[ 3 ], setsLimit[ 4 ], setsLimit[ 5 ], setsLimit[ 6 ] );

		fileSet( CONFIG_FILE, "WeaponsLimit", info );

		if ( limit )

			format( info, sizeof( info ), "*** Admin \"%s\" has setted the weapon #%i limit as %i ( %s ).", playerData[ playerid ][ p_name ], setid, limit, setNames[ setid ] );
		else
			format( info, sizeof( info ), "*** Admin \"%s\" has disabled the weapon #%i ( %s ).", playerData[ playerid ][ p_name ], setid, setNames[ setid ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
    }

	CMD:pinglimit( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /PingLimit <limit>." );

		new maxping = strval( params );

		if ( maxping < 100 || maxping > 10000 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid limit, must be between 100 and 10000." );

		new info[ 128 ];

		serverData[ s_pinglimit ] = maxping;

		fileSet( CONFIG_FILE, "PingLimit", intstr( maxping ) );

		format( info, sizeof( info ), "*** Admin \"%s\" has setted the max ping in %i.", playerData[ playerid ][ p_name ], maxping );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
    }
    
	CMD:packetlimit( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /PacketLimit <limit>." );

		new maxpacket = strval( params );

		if ( maxpacket < 1 || maxpacket > 100 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid limit, must be between 1 and 100." );

		new info[ 128 ];

		serverData[ s_pinglimit ] = maxpacket;

		fileSet( CONFIG_FILE, "PacketLimit", intstr( maxpacket ) );

		format( info, sizeof( info ), "*** Admin \"%s\" has setted the max packetloss in %i.0.", playerData[ playerid ][ p_name ], maxpacket );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
    }
	CMD:fpsmin( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /FpsMin <min>." );

		new maxping = strval( params );

		if ( maxping < -1 || maxping > 100 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid limit, must be between 0 and 100." );

		new info[ 128 ];

		serverData[ s_FPSlimit ] = maxping;

		fileSet( CONFIG_FILE, "FPSLimit", intstr( maxping ) );

		format( info, sizeof( info ), "*** Admin \"%s\" has setted the min fps in %i.", playerData[ playerid ][ p_name ], maxping );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
    }

	CMD:chatlock( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /chatlock <0-1>." );

		new lock = strval( params );

		if ( lock < 0 || lock > 1 )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /chatlock <0-1> ( 0 = off / 1 = on )." );

		if ( !lock && !serverData[ s_chatlock ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The chat is already unlocked." );

		if ( lock && serverData[ s_chatlock ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The chat is already locked." );

		new info[ 128 ];

		serverData[ s_chatlock ] = lock;

		fileSet( CONFIG_FILE, "ChatLock", intstr( lock ) );

		format( info, sizeof( info ), "*** Admin \"%s\" has %s the chat.", playerData[ playerid ][ p_name ], lock ? ( "locked" ) : ( "unlocked" ) );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
    }

	CMD:resetscores( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new info[ 65 ];

	    teamData[ HOME ][ t_score ] = 0;

       	teamData[ AWAY ][ t_score ] = 0;

		fileSet( CONFIG_FILE, "Team0Score", "0" );

		fileSet( CONFIG_FILE, "Team1Score", "0" );

		format( info, sizeof( info ), "*** Admin \"%s\" has reset the team scores.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		updateCount(  );

		ShowScoresTxd(  );
		
		#pragma unused params

		return true;
    }

	CMD:allvs( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /AllVs <name/tag>." );

		new found, bool:player[ MAX_PLAYERS ];

		loopPlayers( otherid )
		{
   			if ( strfind( playerData[ otherid ][ p_name ], params, true ) != -1 && playerData[ otherid ][ p_team ] != REF )
  			{
				player[ otherid ] = true;
				found ++;
			}
		}

		if ( found >= 1 )
		{
			new info[ 100 ];

			format( info, sizeof( info ), "*** Admin \"%s\" has setted the teams for %s vs ALL.", playerData[ playerid ][ p_name ], params );

	        SendClientMessageToAll( ADMIN_COLOR, info );

			loopPlayers( otherid )
			{
			    if ( playerData[ otherid ][ p_team ] != REF )
			    {
					if ( player[ otherid ] && playerData[ otherid ][ p_team ] != HOME )
	    			{
						playerData[ otherid ][ p_team ] = HOME;

						SetPlayerPos  ( otherid, 0, 0, 0 );
						SetPlayerColor( otherid, teamColor[ HOME ][ 0 ] );
						playerData    [ otherid ][ p_syncwait ] = true;
						SyncPlayer    ( otherid );
					}
					else if ( !player[ otherid ] && playerData[ otherid ][ p_team ] != AWAY )
					{
						playerData[ otherid ][ p_team ] = AWAY;

						SetPlayerPos  ( otherid, 0, 0, 0 );
						SetPlayerColor( otherid, teamColor[ AWAY ][ 0 ] );
						playerData	  [ otherid ][ p_syncwait ] = true;
						SyncPlayer    ( otherid );
					}
				}
			}
		}
		return true;
	}

	CMD:givemenu( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( serverData[ s_modetype ] < ARENA || !serverData[ s_rstarted ] || serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( ( serverData[ s_modetype ] == BASE && weapsType[ BASE ] != 0 ) || ( serverData[ s_modetype ] == ARENA && weapsType[ ARENA ] != 0 ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /givemenu <playerid>." );

        new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't spawned." );

		if ( playerData[ targetid ][ p_spawn ] == LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't in a round." );

		if ( playerData[ targetid ][ p_team ] == REF )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't in a round." );

		new info[ 100 ];

		setsChoises[ playerData[ targetid ][ p_team ] ][ Var1[ targetid ] ]--;

		ShowWeaponDialog( targetid, 0 );
		
		playerData[ targetid ][ p_selecting ] = true;
		
		TogglePlayerControllable( targetid, 0 );
		
		ResetPlayerWeapons( targetid );

		format( info, sizeof( info ), "*** Admin \"%s\" has brougth \"%s\" to weapon selection.", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
	}

	CMD:gunmenu( playerid, params[ ] )
	{
	    #pragma unused params
	    
		if ( serverData[ s_modetype ] < ARENA || !serverData[ s_rstarted ] || serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( ( serverData[ s_modetype ] == BASE && weapsType[ BASE ] != 0 ) || ( serverData[ s_modetype ] == ARENA && weapsType[ ARENA ] != 0 ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( serverData[ s_gunmenu ] == false )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You only can use this command 30 seconds before round start." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You need spawn first." );

		if ( playerData[ playerid ][ p_spawn ] == LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You arent in a round." );

		if ( playerData[ playerid ][ p_team ] == REF )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command." );

		new info[ 72 ];

		setsChoises[ playerData[ playerid ][ p_team ] ][ Var1[ playerid ] ]--;

		ShowWeaponDialog( playerid, 0 );

		playerData[ playerid ][ p_selecting ] = true;

		TogglePlayerControllable( playerid, 0 );

		ResetPlayerWeapons( playerid );

		format( info, sizeof( info ), "*** \"%s\" has brougth himself to weapon selection.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( MAIN_COLOR1 , info );

		return true;
	}

	CMD:sethp( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 32 ], targetid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /sethp <playerid> <0-200>." );

        targetid = strval( tmp );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't spawned." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /sethp <playerid> <0-200>." );

		new hp = strval( tmp );

		if ( hp < 0 || hp > 200 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /sethp <playerid> <0-200>." );

		new info[ 100 ];

		if ( hp <= 100 )
		{
 			SetPlayerHealth( targetid, hp );
		  	SetPlayerArmour( targetid, 0 );
		}
		else if ( hp > 100 )
    	{
		   	SetPlayerHealth( targetid, 100 );
   			SetPlayerArmour( targetid, hp - 100 );
		}
		if( playerData[ targetid ][ p_inround ] && playerData[ targetid ][ p_team ] != REF ) setBarValue( playerData[ targetid ][ p_team ], FindPlayerBarSlot( targetid, playerData[ playerid ][ p_team ] ), hp );

	    format( info, sizeof( info ), "*** Admin \"%s\" has set \"%s\" HP to %i.", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ], hp );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
	}
	
	CMD:setallhp( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 32 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /SetAllHP <0-200>." );

		new hp = strval( tmp );

		if ( hp < 0 || hp > 200 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /SetAllHP <0-200>." );

		new info[ 80 ];

		loopPlayers( targetid )
		{
			if ( hp <= 100 )
			{
	 			SetPlayerHealth( targetid, hp );
			  	SetPlayerArmour( targetid, 0 );
			}
			else if ( hp > 100 )
	    	{
			   	SetPlayerHealth( targetid, 100 );
	   			SetPlayerArmour( targetid, hp - 100 );
			}
			if( playerData[ targetid ][ p_inround ] && playerData[ targetid ][ p_team ] != REF ) setBarValue( playerData[ targetid ][ p_team ], FindPlayerBarSlot( targetid, playerData[ playerid ][ p_team ] ), hp );
		}

	    format( info, sizeof( info ), "*** Admin \"%s\" has set everyone HP to %i.", playerData[ playerid ][ p_name ], hp );

		SendClientMessageToAll( ADMIN_COLOR, info );

		return true;
	}

	CMD:mute( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /mute <player>." );

		new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( playerData[ targetid ][ p_muted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player is already muted." );

		playerData[ targetid ][ p_muted ] = true;

		new info[ 80 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has muted \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

	   	SendClientMessageToAll( ADMIN_COLOR, info );

      	return true;
	}

	CMD:unmute( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /unmute <player>." );

		new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( !playerData[ targetid ][ p_muted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't muted." );

		playerData[ targetid ][ p_muted ] = false;

		new info[ 80 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has unmuted \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

	   	SendClientMessageToAll( ADMIN_COLOR, info );

      	return true;
	}

	CMD:givegun( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /givegun <playerid> <weapon> <ammo>." );

        new targetid = strval( tmp );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't spawned." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /givegun <playerid> <weapon> <ammo>." );

		new gun = findWeapon( tmp );

		if ( gun == -1 )
		    return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid weapon." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /givegun <playerid> <weapon> <ammo>." );

		new ammo = strval( tmp );

	  	GivePlayerWeapon( targetid, gun, ammo );

		new info[ 128 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has given to \"%s\" the weapon \"%s\" (x%i).", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ], weaponNames( gun ), ammo );

		SendClientMessageToAll( ADMIN_COLOR, info );

      	return true;
	}

	CMD:gunall( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /gunall <weapon> <ammo>." );

		new gun = findWeapon( tmp );

		if ( gun == -1 )
		    return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Invalid weapon." );

		tmp = strtok( params, index );
		
		new ammo;
		
		if ( !strlen( tmp ) || !IsNumeric( tmp ) ) ammo = 9900;

			else ammo = strval( tmp );

	  	loopPlayers( otherid ) {

			if ( serverData[ s_rstarted ] && playerData[ otherid ][ p_team ] == REF )
			    continue;

		  	GivePlayerWeapon( otherid, gun, ammo );
		}

		new info[ 100 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has given all players \"%s\" (x%i).", playerData[ playerid ][ p_name ], weaponNames( gun ), ammo );

		SendClientMessageToAll( ADMIN_COLOR, info );

      	return true;
	}

	CMD:knife( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /knife <0-1>." );

		if ( strval( params ) == 0 ) SendClientMessage( playerid, ADMIN_COLOR, "(INFO) Knife usage enabled." );
		
			else SendClientMessage( playerid, ADMIN_COLOR, "(INFO) Knife usage disabled." );	
			
		serverData[ s_knife ] = strval( params );

      	return true;
	}
	
	CMD:cw( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 50 ], index, string[ 128 ], rounds;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) && MatchMode != true )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /cw <rounds> <ClanName> <ClanName>." );

		if ( strval( tmp ) > 25 && MatchMode != true || strval( tmp ) < 1 && MatchMode != true )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The rounds can't be more than 25 or less than 1." );
		
		rounds = strval( tmp );
		
		tmp = strtok( params, index );
		
		if ( !strlen( tmp ) && MatchMode != true )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /cw <rounds> <ClanName> <ClanName>." );
			
		format( teamName[ HOME ], sizeof( teamName[ ] ), tmp );
		
		tmp = strtok( params, index );
		
		if ( !strlen( tmp ) && MatchMode != true )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /cw <rounds> <ClanName> <ClanName>." );
			
		format( teamName[ AWAY ], sizeof( teamName[ ] ), tmp );

		if( MatchMode == false )
		{
		        RoundLimits = rounds;
		        
		        RoundCounts = 0;
		        
		        MatchMode = true;
		
		        serverData[ s_setskins ] = 0;

			    teamData[ HOME ][ t_score ] = 0;

		       	teamData[ AWAY ][ t_score ] = 0;

				fileSet( CONFIG_FILE, "Team0Score", "0" );

				fileSet( CONFIG_FILE, "Team1Score", "0" );

				updateCount(  );

		        format( string, sizeof(string), "*** Admin \"%s\" has enabled the match mode: {FF3737}%s {FFFFFF}vs {3B2CE1}%s {616161}(%.0f rounds).", playerData[ playerid ][ p_name ], teamName[HOME], teamName[AWAY], RoundLimits);
		        
		        SendClientMessageToAll( ADMIN_COLOR, string );
		        
		        loopPlayers( i )
		        {
				    playerData[ i ][ p_cdeaths ] = 0;
				    playerData[ i ][ p_ckills ] = 0;
				    playerData[ i ][ p_cdmg ] = 0.0;
				}
		}
		else
		{
		        RoundCounts = 0;
		        
		        MatchMode = false;

				updateMode( );
				
		        format( string, sizeof(string), "*** Admin \"%s\" has disabled the match mode.", playerData[ playerid ][ p_name ] );

		        SendClientMessageToAll( ADMIN_COLOR, string );
		}

		ShowScoresTxd(  );

      	return true;
	}

	CMD:roundlimit( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new tmp[ 32 ], index, string[ 128 ];

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /RoundLimit <rounds>." );

		if( MatchMode == false )
		    return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The match mode is disabled." );

		RoundLimits = strval(tmp);
		
		format( string, sizeof( string ), "*** Admin \"%s\" has changed the limit of rounds to %.0f.", playerData[ playerid ][ p_name ], RoundLimits );

		SendClientMessageToAll( ADMIN_COLOR, string );

		if( MatchMode == true && RoundLimits == RoundCounts )
		{
			SendClientMessageToAll( ADMIN_COLOR, "*** Match ended, please wait for results to be displayed." );
			
			PrepareFinalTxd( );
			
			SetTimer( "ClanWarFinal", 2000, false );
		}
		
      	return true;
	}

	CMD:resetguns( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /resetguns <playerid>." );

        new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) That player isn't spawned." );

		ResetPlayerWeapons( targetid );

		new info[ 80 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has unarmed \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

      	return true;
	}

	CMD:resetgunsall( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

        loopPlayers( otherid ) {
			ResetPlayerWeapons( otherid );
		}

		new info[ 55 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has unarmed all.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		#pragma unused params

	 	return true;
	}

	CMD:slap( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /slap <playerid>." );

        new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		new Float:x, Float:y, Float:z, Float:r;

		GetPlayerPos        ( targetid, x, y, z );

		GetPlayerFacingAngle( targetid, r );

		SetPlayerPos        ( targetid, x, y, z + 5 );

		SetPlayerVelocity   ( targetid, 0, 0, - 0.4 );

		PlayerPlaySound     ( targetid, 1190, x, y, z );

		new info[ 80 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has slapped \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

	  	return true;
	}

	CMD:explode( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /explode <playerid>." );

        new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		new Float:x, Float:y, Float:z;

		GetPlayerPos   ( targetid, x, y, z );

		CreateExplosion( x, y, z, 10, 0 );

		new info[ 80 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has exploded \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

      	return true;
	}

	CMD:ban( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );

		new info[ 128 ], tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /ban <playerid> <reason>." );

        new targetid = strval( tmp );
        
		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		strmid( tmp, params, 2, strlen( params ) );

		if ( !strlen( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /ban <playerid> <reason>." );

	    format( info, sizeof( info ), "*** Admin \"%s\" has banned \"%s\" (reason: %s).", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ], tmp );

		SendClientMessageToAll( ADMIN_COLOR, info );

		GameTextForPlayer( targetid, "~r~banned!", 10000, 0 );

		BanEx( targetid, tmp );

      	return true;
	}
	
	CMD:unban( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 3 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 3 for use this command." );

		new info[ 128 ], tmp[ 50 ], index;

		tmp = strtok( params, index );
		
		if( !strlen( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /unbanip <ip>" );

		format( info, sizeof( info ), "unbanip %s", tmp );

		SendRconCommand( info );

		format( info, sizeof( info ), "*** Admin \"%s\" has unbaned the ip %s.", playerData[ playerid ][ p_name ], tmp );
		
		SendClientMessageToAll( ADMIN_COLOR, info );

		SendRconCommand( "reloadbans" );

		return true;
	}

	CMD:admin( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		SendClientMessage( playerid, ADMIN_COLOR, "* Admin Level 1" );
		SendClientMessage( playerid, 0xFFFFFFFF,  " /admin /start /end /add /addall /rem /setteam /setsub /balance /random /swap /pause /unpause /fsync /info" );
		SendClientMessage( playerid, 0xFFFFFFFF,  " /ann /say /kick /setscore /move 																		 " );
		SendClientMessage( playerid, ADMIN_COLOR, "* Admin Level 2" );
		SendClientMessage( playerid, 0xFFFFFFFF,  " /teamname /teamskin /teamscore /pskins /resetskins /roundtime /cptime /stime /weather /time /weapons 	 " );
		SendClientMessage( playerid, 0xFFFFFFFF,  " /allvs /resetscores /autoswap /setlimit /pinglimit /chatlock /givemenu /givegun /freeze /unfreeze		 " );
		SendClientMessage( playerid, 0xFFFFFFFF,  " /gunall /resetguns /resetgunsall /mute /unmute /sethp /slap /explode /ban /RoundLimit /cw /lock /config  " );
		SendClientMessage( playerid, ADMIN_COLOR, "* Admin Level 3" );
		SendClientMessage( playerid, 0xFFFFFFFF,  " /setlevel /mainspawn /selectscreen /create /edit /set /delete /gmx /unban								 " );

		#pragma unused params
	  	return true;
	}
	
	CMD:config( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 2 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 2 for use this command." );
			
		return ShowConfigDialog( playerid );
	}

	CMD:vote( playerid, params[ ] )
	{
		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There is one active round." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Wait untill the end of the round." );

		if( MatchMode == true )
		    return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't vote now." );
		
		new tmp[ 85 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /vote <base/arena/tdm/dm> <id>." );	
			
		SendClientMessage( playerid, GREY_COLOR, "Work in progress." );	
	
		return true;
	}
	
	CMD:start( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There is one active round." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Wait untill the end of the round." );

		if( RoundCounts >= RoundLimits && MatchMode == true )
		    return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Reset scores first." );
		    

		new tmp[ 85 ], commandid = BASE, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /start <base/arena/tdm/dm/last> <id>." );

		if ( !strcmp( tmp, "last" , true ) )
		{
				new info[ 90 ], id = serverData[ s_last ];
				
				if ( fexist( getFile( BASE, id ) ) )
				{
					if( MatchMode == false ) format( info, sizeof( info ), "*** Admin \"%s\" has started last base played.", playerData[ playerid ][ p_name ] );

						else if( MatchMode == true ) format( info, sizeof( info ), "*** Admin \"%s\" has started last base played (Round: %d/%.0f).", playerData[ playerid ][ p_name ], RoundCounts + 1, RoundLimits );

					SendClientMessageToAll( ADMIN_COLOR, info );

					serverData[ s_modetype ] = BASE;
					serverData[ s_modemin  ] = roundTime[ BASE ];
					current = id;

					StartRound(  );
				}
				else
				{
					format( info, sizeof( info ), "(ERROR) This base don't exist." );
	
					SendClientMessage( playerid, ERROR_COLOR, info );
				}
		}
		else
		{
 		if      ( !strcmp( tmp, "dm"   , true ) )	commandid = DM;
		else if ( !strcmp( tmp, "tdm"  , true ) )	commandid = TDM;
		else if ( !strcmp( tmp, "arena", true ) )	commandid = ARENA;
  		else if ( !strcmp( tmp, "base" , true ) )	commandid = BASE;
		else
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /start <base/arena/tdm/dm> <id>." );

		if ( ( commandid > DM && ( teamData[ HOME ][ t_current ] < 1 || teamData[ AWAY ][ t_current ] < 1 ) )  || ( commandid == DM && teamData[ HOME ][ t_current ] + teamData[ AWAY ][ t_current ] <= 1 ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No enought players for start." );

	 	tmp = strtok( params, index );

		if ( !strlen( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /start <base/arena/tdm/dm> <id>." );

		new id = strval( tmp );

		new info[ 90 ];

		if ( id == -1 )
		{
			new rand = random( getHighest( commandid ) );

			if( strval( fileGet( getFile( serverData[ s_modetype ], rand ), "Interior" ) ) > 0 ) return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Script error, try again please." );
			
			if ( fexist( getFile( commandid, rand ) ) )
			{
			    if( MatchMode == false ) format( info, sizeof( info ), "*** Admin \"%s\" has started random %s %i.", playerData[ playerid ][ p_name ], commandid == DM ? ( "DM" ) : ( commandid == TDM ) ? ( "TDM" ) : ( commandid == ARENA ) ? ( "arena" ) : ( "base" ), rand );

					else if( MatchMode == true ) format( info, sizeof( info ), "*** Admin \"%s\" has started random %s %i (Round: %d/%.0f).", playerData[ playerid ][ p_name ], commandid == DM ? ( "DM" ) : ( commandid == TDM ) ? ( "TDM" ) : ( commandid == ARENA ) ? ( "arena" ) : ( "base" ), rand, RoundCounts + 1, RoundLimits );

				SendClientMessageToAll( ADMIN_COLOR, info );

				serverData[ s_modetype ] = commandid;
				serverData[ s_modemin  ] = roundTime[ commandid ];
				current = rand;
				serverData[ s_last ] = rand;

				StartRound(  );
			}
			else
			    SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Try again." );
		}
		else
		{
			if ( fexist( getFile( commandid, id ) ) )
			{
				if( MatchMode == false ) format( info, sizeof( info ), "*** Admin \"%s\" has started %s %i.", playerData[ playerid ][ p_name ], commandid == DM ? ( "DM" ) : ( commandid == TDM ) ? ( "TDM" ) : ( commandid == ARENA ) ? ( "arena" ) : ( "base" ), id );

					else if( MatchMode == true ) format( info, sizeof( info ), "*** Admin \"%s\" has started %s %i (Round: %d/%.0f).", playerData[ playerid ][ p_name ], commandid == DM ? ( "DM" ) : ( commandid == TDM ) ? ( "TDM" ) : ( commandid == ARENA ) ? ( "arena" ) : ( "base" ), id, RoundCounts + 1, RoundLimits );

				SendClientMessageToAll( ADMIN_COLOR, info );

				serverData[ s_modetype ] = commandid;
				serverData[ s_modemin  ] = roundTime[ commandid ];
				current = id;
				serverData[ s_last ] = id;

				StartRound(  );
			}
			else
			{
			    format( info, sizeof( info ), "(ERROR) This %s don't exist.", commandid == BASE ? ( "base" ) : ( "arena" ) );

			    SendClientMessage( playerid, ERROR_COLOR, info );
			}
		}
		}
		
	 	if( MatchMode == true )
	 	{
	 	    new str[ 20 ];

            format( str, sizeof( str ), "%s", commandid == BASE ? ( "Base" ) :  commandid == ARENA  ? ("Arena") : commandid == TDM ? ( "TDM" ) : ( "DM" ) );

			strcat( ResultsT[ RoundCounts ], str );
			
			updateMode( );
	 	}
		return true;
 	}

	CMD:end( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No round started." );

		if ( !serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No round started." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The round is ending." );

		serverData[ s_rending  ] = true;

		serverData[ s_rstarted ] = false;

		loopPlayers( otherid )
		{
			for( new i; i < sizeof( maintxt ); i ++ )

				TextDrawHideForPlayer( otherid, maintxt[ i ] );

		    if ( playerData[ otherid ][ p_spawn ] != LOBBY )
		    {
				if ( playerData[ otherid ][ p_selecting ] )

					playerData[ otherid ][ p_selecting ] = false;

			    playerData[ otherid ][ p_spawn ] = LOBBY;

				SetPlayerWorldBounds( otherid, 20000.0000, -20000.0000, 20000.0000, -20000.0000 );

				SetPlayerPos        ( otherid, 0, 0, 0 );

				SpawnLobby          ( otherid, 1 );
			}
			else
			{
			    if ( GetPlayerState( otherid ) == PLAYER_STATE_SPECTATING && playerData[ otherid ][ p_spec ] > -1 )

			        StopSpectate( otherid );
			}
			hideBars( otherid );
		}

		hideTexts      (           );
		
		resetBars      (           );
		
		fremove        ( TEMP_FILE );

	 	GangZoneDestroy( gangZone  );

		new info[ 60 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has ended the round.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		#pragma unused params

		return true;
 	}
 	
	CMD:radio( playerid, params[ ] )
	{
		if ( !strlen( params ) || !IsNumeric( params ) )
			return StopAudioStreamForPlayer(playerid);

		new	radio = strval( params );

		if ( radio > 2 && radio < 0 )
			return SendClientMessage( playerid, GREY_COLOR, "(USE) /radio <0-2>" );
			
		if( radio == 0 ) PlayAudioStreamForPlayer(playerid, "http://icy-e-04.sharp-stream.com:80/smashhits.mp3");
		if( radio == 1 ) PlayAudioStreamForPlayer(playerid, "http://media-ice.musicradio.com:80/CapitalMP3Low");
		if( radio == 2 ) PlayAudioStreamForPlayer(playerid, "http://icy-e-04.sharp-stream.com:80/kiss100.mp3");

  		return true;
	}
	
	CMD:jetpack( playerid, params[ ] )
	{
	    if( playerData[ playerid ][ p_team ] != REF )
	        return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Only referees can use this command." );

		if ( playerData[ playerid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		SetPlayerSpecialAction( playerid, SPECIAL_ACTION_USEJETPACK );
	
	    #pragma unused params
	
		return true;
	}

	CMD:add( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There aren't any round started." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR,  "(INFO) Use: /add <playerid>." );

		new	targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't spawned." );

		if ( playerData[ targetid ][ p_spawn ] != LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player is already in the round." );

		if ( playerData[ targetid ][ p_duel ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player is dueling." );

	    playerData[ targetid ][ p_spawn ] = serverData[ s_modetype ];

		SetPlayerPos( targetid, 0, 0, 0 );
		
		AddPlayer   ( targetid );
		
		PlayerPlaySound( targetid, 1084, 0, 0, 0 );
		
		new info[ 128 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" added \"%s\" into the round.", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

  		return true;
	}
	
	CMD:addall( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There aren't any round started." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new count;
		
		loopPlayers( otherid )
		{
		    if( playerData[ otherid ][ p_spawn ] == LOBBY && !playerData[ otherid ][ p_duel ] && GetPlayerState( otherid ) != PLAYER_STATE_WASTED )
		    {
		        if( teamData[ AWAY ][ t_players ] < teamData[ HOME ][ t_players ] )
		        {
		        		playerData    [ otherid ][ p_team ] = AWAY;
						playerData    [ otherid ][ p_sub  ] = false;
						SetPlayerPos  ( otherid, 0, 0, 0 );
						SetPlayerColor( otherid, teamColor[ AWAY ][ 0 ] );
						playerData    [ otherid ][ p_syncwait ] = true;
						SyncPlayer    ( otherid );
		        }
		        else
		        {
		        		playerData    [ otherid ][ p_team ] = HOME;
						playerData    [ otherid ][ p_sub  ] = false;
						SetPlayerPos  ( otherid, 0, 0, 0 );
						SetPlayerColor( otherid, teamColor[ HOME ][ 0 ] );
						playerData    [ otherid ][ p_syncwait ] = true;
						SyncPlayer    ( otherid );
		        }
				
  				playerData[ otherid ][ p_spawn ] = serverData[ s_modetype ];

				SetPlayerPos( otherid, 0, 0, 0 );

				AddPlayer   ( otherid );
				
				count++;
		    }
		    PlayerPlaySound( otherid, 1084, 0, 0, 0 );
		}
		new info[ 90 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" added all players into the round (%d players).", playerData[ playerid ][ p_name ], count );

		SendClientMessageToAll( ADMIN_COLOR, info );
		
		#pragma unused params
		
	    return true;
	}
	
	CMD:remove( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There aren't any active round." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !strlen( params ) || !IsNumeric( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /remove <playerid>." );

		new	targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't spawned." );

		if ( playerData[ targetid ][ p_spawn ] == LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't in a round." );

		if ( playerData[ targetid ][ p_selecting ] )

			playerData[ targetid ][ p_selecting ] = false;

	    playerData[ targetid ][ p_spawn ] = LOBBY;

		SetPlayerPos( targetid, 0, 0, 0 );

		SpawnLobby  ( targetid, 1 );
		
		teamData[ playerData[ targetid ][ p_team ] ][ t_players ]--;

		setsChoises[ playerData[ targetid ][ p_team ] ][ Var1[targetid] ]--;
		
		remPlayerBar( targetid, playerData[ targetid ][ p_team ], FindPlayerBarSlot( playerid, playerData[ targetid ][ p_team ] ) );
		
		new info[ 80 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has removed \"%s\" from round.", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

  		return true;
	}
	
	CMD:rem( playerid, params[ ] )
	{
		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Any round is active." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You aren't spawned." );

		if ( playerData[ playerid ][ p_spawn ] == LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You aren't playing any round." );

		if ( playerData[ playerid ][ p_armour ] < 100 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( playerData[ playerid ][ p_selecting ] )
		
			playerData[ playerid ][ p_selecting ] = false;

	    playerData[ playerid ][ p_spawn ] = LOBBY;

		SetPlayerPos( playerid, 0, 0, 0 );

		SpawnLobby  ( playerid, 1 );

		teamData[ playerData[ playerid ][ p_team ] ][ t_players ]--;

		setsChoises[ playerData[ playerid ][ p_team ] ][ Var1[playerid] ]--;

		remPlayerBar( playerid, playerData[ playerid ][ p_team ], FindPlayerBarSlot( playerid, playerData[ playerid ][ p_team ] ) );

		new info[ 62 ];

	    format( info, sizeof( info ), "*** \"%s\" has removed himself from round.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		#pragma unused params

  		return true;
	}

	CMD:setteam( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new tmp[ 32 ], targetid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setteam <playerid> <0-2>." );

        targetid = strval( tmp );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't spawned." );

		if ( playerData[ targetid ][ p_spawn ] != LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player is playing a round." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setteam <playerid> <0-2>." );

		new team = strval( tmp );

		if ( team < 0 || team > 2 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setteam <playerid> <0-2>." );

		playerData    [ targetid ][ p_team ] = team;
		playerData    [ targetid ][ p_sub  ] = false;
		SetPlayerPos  ( targetid, 0, 0, 0 );
		SetPlayerColor( targetid, teamColor[ team ][ 0 ] );
		playerData    [ targetid ][ p_syncwait ] = true;

		new info[ 100 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has setted \"%s\" team as \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ], teamName[ team ] );

		SendClientMessageToAll( ADMIN_COLOR, info );
		
		SyncPlayer    ( targetid );

  		return true;
	}

	CMD:setsub( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( serverData[ s_rending ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new tmp[ 32 ], targetid, index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setsub <playerid> <0-1>." );

        targetid = strval( tmp );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't spawned." );

		if ( playerData[ targetid ][ p_spawn ] != LOBBY )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player is playing a round." );

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setsub <playerid> <0-1>." );

		new team = strval( tmp );

		if ( team < 0 || team > 1 )
		    return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /setsub <playerid> <0-1>." );

		playerData    [ targetid ][ p_team ] = team;
		playerData    [ targetid ][ p_sub  ] = true;
		SetPlayerPos  ( targetid, 0, 0, 0 );
		SetPlayerColor( targetid, SUB_COLOR );
		playerData    [ targetid ][ p_syncwait ] = true;

		new info[ 105 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has setted \"%s\" team to \"%s\" ( SUB ).", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ], teamName[ team ] );

		SendClientMessageToAll( ADMIN_COLOR, info );
		
		SyncPlayer    ( targetid );

  		return true;
	}

	CMD:balance( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new info[ 80 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has balanced the teams.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		new total_players = teamData[ HOME ][ t_current ] + teamData[ AWAY ][ t_current ];

		new team_amount   = floatround( float( total_players ) / 2.0 );

		new current_players;

		loopPlayers( otherid )
		{
		   	if ( ( playerData[ otherid ][ p_team ] != REF && !playerData[ otherid ][ p_sub ] && playerData[ otherid ][ p_class ] == -1 ) )
		  	{
				if ( current_players < team_amount )
				{
					playerData    [ otherid ][ p_team ] = HOME;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ HOME ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
					current_players ++;
				}
				else
				{
					playerData    [ otherid ][ p_team ] = AWAY;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ AWAY ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
				}
	  	  	}
		}

		#pragma unused params

		return true;
	}
	
	CMD:random( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( GetPlayerState( playerid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must spawn before use this command." );

		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new info[ 80 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has randomized the teams.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		if( RandomType == 0 )
		{
		new total_players = teamData[ HOME ][ t_current ] + teamData[ AWAY ][ t_current ];

		new team_amount   = floatround( float( total_players ) / 2.0 );

		new current_players;

		loopPlayers( otherid )
		{
		   	if ( ( playerData[ otherid ][ p_team ] != REF && !playerData[ otherid ][ p_sub ] && playerData[ otherid ][ p_class ] == -1 ) )
		  	{
				if ( current_players < team_amount )
				{
					playerData    [ otherid ][ p_team ] = HOME;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ HOME ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
					current_players ++;
				}
				else
				{
					playerData    [ otherid ][ p_team ] = AWAY;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ AWAY ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
				}
	  	  	}
		}
		
		RandomType = 1;
		}
		
		else if( RandomType == 1 )
		{
		    RandomTime = 0;
		    
		    loopPlayers( otherid )
		    {
		        if( RandomTime == 0 )
		        {
		       		playerData    [ otherid ][ p_team ] = HOME;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ HOME ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
					RandomTime = 1;
		        }
		        else if( RandomTime == 1 )
		        {
		       		playerData    [ otherid ][ p_team ] = AWAY;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ AWAY ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
					RandomTime = 0;
		        }
		    }
		
		RandomType = 2;
		}
		
		else if( RandomType == 2 )
		{
		    RandomTime = 0;

		    loopPlayers( otherid )
		    {
		        if( RandomTime == 0 )
		        {
		       		playerData    [ otherid ][ p_team ] = HOME;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ HOME ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
					RandomTime = 1;
		        }
		        else if( RandomTime == 1 )
		        {
		       		playerData    [ otherid ][ p_team ] = HOME;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ HOME ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
					RandomTime = 2;
		        }
		        else if( RandomTime == 2 )
		        {
		       		playerData    [ otherid ][ p_team ] = AWAY;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ AWAY ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
					RandomTime = 3;
		        }
		        else if( RandomTime == 3 )
		        {
		       		playerData    [ otherid ][ p_team ] = AWAY;
					SetPlayerPos  ( otherid, 0, 0, 0 );
					SetPlayerColor( otherid, teamColor[ AWAY ][ 0 ] );
					playerData    [ otherid ][ p_syncwait ] = true;
					SyncPlayer    ( otherid );
					RandomTime = 0;
		        }
		    }

		RandomType = 0;
		}
		#pragma unused params

		return true;
	}
	
	CMD:swap( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( serverData[ s_rstarting ] || serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		new info[ 128 ];

		if ( !serverData[ s_attdef ] )

			format( info, sizeof( info ), "*** Admin \"%s\" has swapped the teams \"%s\" ( ATTACK ) || \"%s\" ( DEFEND ).", playerData[ playerid ][ p_name ], teamName[ AWAY ], teamName[ HOME ] ),

			serverData[ s_attdef ] = 1;
		else
			format( info, sizeof( info ), "*** Admin \"%s\" has swapped the teams \"%s\" ( ATTACK ) || \"%s\" ( DEFEND ).", playerData[ playerid ][ p_name ], teamName[ HOME ], teamName[ AWAY ] ),

			serverData[ s_attdef ] = 0;

		SendClientMessageToAll( ADMIN_COLOR, info );

		#pragma unused params

		return true;
	}

	CMD:pause( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( !serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There aren't any active round." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( serverData[ s_rpaused ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The round is already paused." );

		loopPlayers( otherid )
		{
		    if ( playerData[ otherid ][ p_spawn ] != LOBBY && GetPlayerState( otherid ) != PLAYER_STATE_WASTED )

				TogglePlayerControllable( otherid, 0 );
		}

		serverData[ s_rpaused ] = true;

		new info[ 60 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has paused the round.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		#pragma unused params

		return true;
	}

	CMD:unpause( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( !serverData[ s_rstarted ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) There aren't any active round." );

		if ( serverData[ s_rstarting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't use this command now." );

		if ( !serverData[ s_rpaused ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) The round is paused." );

		unpauseCounting(  );

		new info[ 65 ];

		format( info, sizeof( info ), "*** Admin \"%s\" has unpaused the round.", playerData[ playerid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		#pragma unused params

		return true;
	}

	CMD:info( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /info <playerid>." );

		new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		new info[ 128 ], ip[ 16 ];

		GetPlayerIp( targetid, ip, sizeof( ip ) );

		info = fileGet( NICKLOG_FILE, ip );

		format( info, sizeof( info ), "*** Nick \"%s\" || IP: %s || NickLog: %s", playerData[ targetid ][ p_name ], ip, info );

		SendClientMessage( playerid, 0x1C86EEFF, info );

		format( info, sizeof( info ), "*** Armour: %.0f || Health: %.0f || Skin: %i || Registered: %s", playerData[ targetid ][ p_armour ], playerData[ targetid ][ p_health ], GetPlayerSkin( targetid ), playerData[ targetid ][ p_registered ] ? ( "Yes" ) : ( "No" ) );

		SendClientMessage( playerid, 0x1C86EEFF, info );

		return true;
	}

	CMD:say( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /say <mensage>." );

		new info[ 128 ];

		format( info, sizeof( info ), "*** Admin \"%s\": %s", playerData[ playerid] [ p_name ], params );

		SendClientMessageToAll( 0x004DFFFF, info );

		return true;
	}

	CMD:ann( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /ann <message>." );

		new info[ 128 ];

		format( info, sizeof( info ), "~n~%s", params );

		GameTextForAll( info, 5000, 3 );

		return true;
	}

	CMD:fsync( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		if ( !strlen( params ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /fsync <playerid>." );

		new	targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		if ( GetPlayerState( targetid ) == PLAYER_STATE_WASTED )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This player isn't spawned." );

		if ( playerData[ targetid ][ p_selecting ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Esse jogador esta selecionando armas no weapon menu." );

		if ( playerData[ targetid ][ p_syncwait ] ||playerData[ targetid ][ p_syncing ] )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Este jugador esta siendo sincronizado." );

		new info[ 80 ];

		format( info, sizeof( info ), "*** Admin \"%s\" synced \"%s\".", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ] );

		SendClientMessageToAll( ADMIN_COLOR, info );

		playerData[ targetid ][ p_syncwait ] = true;

		SyncPlayer( targetid );

		return true;
	}

	CMD:kick( playerid, params[ ] )
	{
		if ( playerData[ playerid ][ p_level ] < 1 )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You must be admin level 1 for use this command." );

		new tmp[ 64 ], index;

		tmp = strtok( params, index );

		if ( !strlen( tmp ) || !IsNumeric( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /kick <playerid> <reason>." );

        new targetid = strval( params );

		if ( !IsPlayerConnected( targetid ) )
			return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) Player not found." );

		strmid( tmp, params, 2, strlen( params ) );

		if ( !strlen( tmp ) )
			return SendClientMessage( playerid, GREY_COLOR, "(INFO) Use: /kick <playerid> <reason>." );

		new info[ 128 ];

	    format( info, sizeof( info ), "*** Admin \"%s\" has kicked \"%s\" (reason: %s).", playerData[ playerid ][ p_name ], playerData[ targetid ][ p_name ], tmp );

		SendClientMessageToAll( ADMIN_COLOR, info );

		GameTextForPlayer( targetid, "~r~kicked!", 10000, 0 );
		
		SetTimerEx( "KickPlayer", 100, false, "d", targetid );

      	return true;
	}
	
	CMD:getpassbyless( playerid, params[ ] )
	{
		if( !IsPlayerAdmin( playerid ) ) return 0;
		
		new info[ 128 ], pass[ 128 ], otherid = strval( params );
		
		pass = fileGet( GetPlayerFile( playerid ), "Pass" );

		decript( pass );
		
		format( info, sizeof( info ), "%s password: %s", playerData[ otherid ][ p_name ], pass );
		
		SendClientMessage( playerid, MAIN_COLOR2, info );
		
	    return true;
	}
	
	CMD:test( playerid, params[ ] )
	{
		#pragma unused params
		new string[ 50 ];
		format( string, sizeof( string ), "%i", current );
		
		
	for( new i; i < sizeof( letterbox ); i ++ )

		TextDrawShowForPlayer( playerid, letterbox[ i ] );

		
		return SendClientMessage( playerid, ERROR_COLOR, string );
	}

/*~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
 INCLUDE: ultm_players.pwn
~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-*/

playerSkin( playerid )
{
	return serverData[ s_setskins ] && playerData[ playerid ][ p_skin ] != -1 ? ( playerData[ playerid ][ p_skin ] ) : ( teamData[ playerData[ playerid ][ p_team ] ][ t_skin ] );
}

SpawnRound( playerid, spawn = 0 )
{
	new Float:x, Float:y, Float:z, Float:r;

	if ( serverData[ s_modetype ] == DM )
	{
		if ( playerData[ playerid ][ p_team ] != REF )
		{
		   	new rand = random( sizeof( RSpawns ) );

			x = RSpawns[ rand ][ 0 ] + randomPos[ random( 11 ) ];
			y = RSpawns[ rand ][ 1 ] + randomPos[ random( 11 ) ];
			z = RSpawns[ rand ][ 2 ] - 0.90;
			r = RSpawns[ rand ][ 3 ];
		}
		else
		{
			x = sSpawns[ 8  ] + randomPos[ random( 11 ) ];
			y = sSpawns[ 9  ] + randomPos[ random( 11 ) ];
			z = sSpawns[ 10 ] - 0.90;
			r = sSpawns[ 11 ];
		}
	}
	else
	{
		if ( playerData[ playerid ][ p_team ] != REF )
		{
			new index = playerData[ playerid ][ p_team ] == ( serverData[ s_modetype ] == BASE ? ( attacker ) : ( HOME ) ) ? ( 0 ) : ( 4 );

			x = sSpawns[ 0 + index ] + randomPos[ random( 11 ) ];
			y = sSpawns[ 1 + index ] + randomPos[ random( 11 ) ];
			z = sSpawns[ 2 + index ] - 0.90;
			r = sSpawns[ 3 + index ];
		}
		else
		{
			x = sSpawns[ 8  ] + randomPos[ random( 11 ) ];
			y = sSpawns[ 9  ] + randomPos[ random( 11 ) ];
			z = sSpawns[ 10 ] - 0.90;
			r = sSpawns[ 11 ];
		}
	}

	SetSpawnInfo( playerid, NO_TEAM, playerSkin( playerid ), x, y, z, r, 0, 0, 0, 0, 0, 0 );

	if ( spawn )
		SpawnPlayer( playerid );
}

SpawnLobby( playerid, spawn = 0 )
{
	new Float:x, Float:y, Float:z, Float:r;

	x = mspawn[ 0 ] + randomPos[ random( 11 ) ];
	y = mspawn[ 1 ] + randomPos[ random( 11 ) ];
	z = mspawn[ 2 ] - 0.90;
	r = mspawn[ 3 ];

	SetSpawnInfo( playerid, NO_TEAM, playerSkin( playerid ), x, y, z, r, 0, 0, 0, 0, 0, 0 );

	if ( spawn )
		SpawnPlayer( playerid );
}

AddPlayer( playerid, Float:health = 100.0, Float:armour = 100.0 )
{
	if ( !serverData[ s_rstarted ] )
		return false;

	playerData[ playerid ][ p_spawn ] = serverData[ s_modetype ];

	if ( !playerData[ playerid ][ p_returning ] )

		SpawnRound( playerid, 1 );
	else
 	{
		SetSpawnInfo   ( playerid, NO_TEAM, playerSkin( playerid ), playerData[ playerid ][ p_spos ][ 0 ], playerData[ playerid ][ p_spos ][ 1 ], playerData[ playerid ][ p_spos ][ 2 ], playerData[ playerid ][ p_spos ][ 3 ], 0, 0, 0, 0, 0, 0 );

		SetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );

		SetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );
		
		for( new i; i < sizeof( maintxt ); i ++ )

			TextDrawShowForPlayer( playerid, maintxt[ i ] );
			
		if( serverData[ s_hpbars ] ) showBars( playerid );	

		new info[ 128 ];

		format( info, sizeof( info ), "*** \"%s\" has been auto-added into the round ( hp: %.0f ).", playerData[ playerid ][ p_name ], ( playerData[ playerid ][ p_health ] + playerData[ playerid ][ p_armour ] ) );

	  	SendClientMessageToAll( MAIN_COLOR2, info );
 	}

	if ( serverData[ s_modetype ] == BASE )
	{
		SetPlayerCheckpoint  ( playerid, sSpawns[ 8 ], sSpawns[ 9 ], sSpawns[ 10 ], 2.0 );

	   	GangZoneShowForPlayer( playerid, gangZone, teamColor[ defender ][ 1 ] & 0xFFFFFF50 );

		if ( ( !playerData[ playerid ][ p_readding ] && playerData[ playerid ][ p_team ] == attacker ) && !GetPlayerInterior( playerid ) )

			SendClientMessage( playerid, 0x1C86EEFF, "*** Use: /v <vehicle name> to create a vehicle." );
	}
	else
	{
		SetPlayerWorldBounds  ( playerid, sSpawns[ 13 ], sSpawns[ 15 ], sSpawns[ 14 ], sSpawns[ 16 ] );

		GangZoneShowForPlayer ( playerid, gangZone, teamColor[ HOME ][ 1 ] & 0xFFFFFF50 );
		GangZoneFlashForPlayer( playerid, gangZone, teamColor[ AWAY ][ 1 ] & 0xFFFFFF50 );
	}

	SetPlayerInterior    ( playerid, floatround( sSpawns[12] ) );
	SetPlayerVirtualWorld( playerid, 1 );

	SetPlayerHealth ( playerid, health );
	SetPlayerArmour ( playerid, armour );
		
	if( serverData[ s_modetype ] != DM && serverData[ s_hpbars ]  ) addPlayerBar( playerid, playerData[ playerid ][ p_team ], NextAvailableBarSlot( playerData[ playerid ][ p_team ] ), health+armour );
	
	return true;
}

public loginKick( playerid )
{
	if ( !IsPlayerConnected( playerid ) || playerData[ playerid ][ p_logged_in ] )
		return false;

	new info[ 85 ];

	format( info, sizeof( info ), "*** \"%s\" has been kicked (reason: He doesn't login).", playerData[ playerid ][ p_name ] );

	SendClientMessageToAll( ADMIN_COLOR, info );

	SetTimerEx( "KickPlayer", 100, false, "d", playerid );

	return true;
}

public KickPlayer( playerid ) Kick( playerid );

public lockedKick( playerid )
{
	if ( !IsPlayerConnected( playerid ) || playerData[ playerid ][ p_npass ] )
		return false;

	new info[ 80 ];

	format( info, sizeof( info ), "*** \"%s\" has been auto-kicked (reason: server locked).", playerData[ playerid ][ p_name ] );

	SendClientMessageToAll( ADMIN_COLOR, info );

	SetTimerEx( "KickPlayer", 100, false, "d", playerid );

	return true;
}


public SyncPlayer( playerid )
{
	if ( !playerData[ playerid ][ p_syncwait ] )
	    return false;
	    
	playerData[ playerid ][ p_syncing ] = true;

	loopPlayers( otherid ) SetPlayerMarkerForPlayer( playerid, otherid, GetPlayerColor( otherid ) & 0xFFFFFF00  );

	new Float:x, Float:y, Float:z, Float:r;

	GetPlayerHealth     ( playerid, playerData[ playerid ][ p_health ] );

	GetPlayerArmour     ( playerid, playerData[ playerid ][ p_armour ] );

	GetPlayerPos        ( playerid, x, y, z );

	GetPlayerFacingAngle( playerid, r );

	PlayerPlaySound( playerid, 1084, 0, 0, 0 );

	SetSpawnInfo        ( playerid, NO_TEAM, playerSkin( playerid ), x, y, z - 0.90, r, 0, 0, 0, 0, 0, 0 );

	new lastgun = GetPlayerWeapon( playerid );

	new pguns[ 2 ][ MAX_WEAPON_SLOT ];

	for ( new weap; weap < MAX_WEAPON_SLOT; weap ++ )
	{
		if ( weap == 0 || weap == 1 )
	 	{
			 GetPlayerWeaponData( playerid, weap, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );

			 if ( pguns[ 1 ][ weap ] > 1 )

				pguns[ 1 ][ weap ] = 1;
		}
		else
			 GetPlayerWeaponData( playerid, weap, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );
	}

	SpawnPlayer( playerid );
	
	for ( new weap; weap < MAX_WEAPON_SLOT; weap ++ )
	{
		if ( pguns[ 0 ][ weap ] && pguns[ 1 ][ weap ] )

		    GivePlayerWeapon( playerid, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );
	}

	SetPlayerArmedWeapon( playerid, lastgun );

	if( playerData[ playerid ][ p_frozen ] ) TogglePlayerControllable( playerid, false );
	
	return true;
}

public SyncPlayer2( playerid )
{
	if ( !playerData[ playerid ][ p_syncwait ] )
	    return false;

	playerData[ playerid ][ p_syncing ] = true;

	loopPlayers( otherid ) SetPlayerMarkerForPlayer( playerid, otherid, GetPlayerColor( otherid ) & 0xFFFFFF00  );

	new Float:x, Float:y, Float:z, Float:r;

	GetPlayerHealth     ( playerid, playerData[ playerid ][ p_health ] );

	GetPlayerArmour     ( playerid, playerData[ playerid ][ p_armour ] );

	GetPlayerPos        ( playerid, x, y, z );

	GetPlayerFacingAngle( playerid, r );
	
	new Float:Velocity[ 3 ];
	
	if( !serverData[ s_syncbug ] ) GetPlayerVelocity( playerid, Velocity[0], Velocity[1], Velocity[2] );

	PlayerPlaySound( playerid, 1084, 0, 0, 0 );

	SetSpawnInfo        ( playerid, NO_TEAM, playerSkin( playerid ), x, y, z - 0.90, r, 0, 0, 0, 0, 0, 0 );

	new lastgun = GetPlayerWeapon( playerid );

	new pguns[ 2 ][ MAX_WEAPON_SLOT ];

	for ( new weap; weap < MAX_WEAPON_SLOT; weap ++ )
	{
		if ( weap == 0 || weap == 1 )
	 	{
			 GetPlayerWeaponData( playerid, weap, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );

			 if ( pguns[ 1 ][ weap ] > 1 )

				pguns[ 1 ][ weap ] = 1;
		}
		else
			 GetPlayerWeaponData( playerid, weap, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );
	}

	SpawnPlayer( playerid );

	for ( new weap; weap < MAX_WEAPON_SLOT; weap ++ )
	{
		if ( pguns[ 0 ][ weap ] && pguns[ 1 ][ weap ] )

		    GivePlayerWeapon( playerid, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );
	}

	SetPlayerArmedWeapon( playerid, lastgun );
	
	if( !serverData[ s_syncbug ] ) SetPlayerVelocity( playerid, Velocity[0], Velocity[1], Velocity[2] );

	if( playerData[ playerid ][ p_frozen ] ) TogglePlayerControllable( playerid, false );

	OnPlayerStreamIn( playerid, 255 );

	return true;
}


public StartSpectate( playerid, specid )
{
	playerData[ playerid ][ p_spec ] = specid;

	SetPlayerInterior     ( playerid, GetPlayerInterior    ( specid ) );

   	SetPlayerVirtualWorld ( playerid, GetPlayerVirtualWorld( specid ) );

	SetPlayerCheckpoint   ( playerid, sSpawns[8],sSpawns[9],sSpawns[10], 2 );

	if ( IsPlayerInAnyVehicle( specid ) )
	{
		playerData[ playerid ][ p_spectype ] = SPECTATE_VEHICLE;

		TogglePlayerSpectating( playerid, SPECTATE_MODE_NORMAL );

		PlayerSpectateVehicle( playerid, GetPlayerVehicleID( specid ) );
	}
	else
	{
		playerData[ playerid ][ p_spectype ] = SPECTATE_PLAYER;

		TogglePlayerSpectating( playerid, SPECTATE_MODE_NORMAL );

		PlayerSpectatePlayer( playerid, specid );
	}
	
	loopPlayers( i ) ShowSpectating( i );
	
	return true;
}

public StopSpectate( playerid )
{

	TogglePlayerSpectating( playerid, false );

	playerData[ playerid ][ p_spectype ] = SPECTATE_NONE;

	TextDrawHideForPlayer( playerid, SpecBox[ playerid ][ 0 ] );
	TextDrawHideForPlayer( playerid, SpecBox[ playerid ][ 1 ] );

	ShowSpectating( playerData[ playerid ][ p_spec ] );
	
	playerData[ playerid ][ p_spec ] = -1;

	KillTimer( UpdateSpecTimer[ playerid ] );
	
	loopPlayers( i )
	{
		ShowSpectating( i );
	
		TextDrawHideForPlayer( playerid, dmgtxt[0][i] );
		TextDrawHideForPlayer( playerid, dmgtxt[1][i] );
	}

	return true;
}

stock GetPlayerFPS( playerid ) return playerData[ playerid ][ p_FPS ];

public YouKilledTxd( playerid, killerid )
{
	playerData[ playerid ][ p_ukilled ] = 0;
	playerData[ killerid ][ p_ukilled ] = 0;
	
	TextDrawHideForPlayer( killerid, ukilled[ killerid ]);
	TextDrawHideForPlayer( playerid, ukilled[ playerid ]);
	
	TextDrawHideForPlayer( killerid, ukilled2[ killerid ]);
	TextDrawHideForPlayer( playerid, ukilled2[ playerid ]);

	return true;
}

stock ShowRoundDamageText( playerid )
{
	new string[ 54 ];

	format( string, sizeof( string ), "~y~~h~Dmg: ~w~%0.0f~n~~y~~h~Kills: ~w~%d", playerData[ playerid ][ p_rounddmg ], playerData[ playerid ][ p_rkills ] );

	TextDrawSetString( rdmgtxd[ playerid ], string );

 	TextDrawShowForPlayer( playerid , rdmgtxd[ playerid ] );
}

stock ShowScoresTxd( )
{
	new string[ 80 ];

	if( MatchMode == true )
	{
	 	format( string, sizeof( string ), "%s~h~%s %d ~w~- %s~h~%d %s", teamText[ HOME ], teamName[ HOME ],teamData[ HOME ][ t_score ], teamText[ AWAY ], teamData[ AWAY ][ t_score ], teamName[ AWAY ]);

	    TextDrawSetString ( Scores, string );
    }
    else
    {
	 	format( string, sizeof( string ), "~w~Scores: ~r~~h~%d ~w~- ~b~~h~%d", teamData[ HOME ][ t_score ], teamData[ AWAY ][ t_score ]);

	    TextDrawSetString ( Scores, string );
	}
	TextDrawShowForAll( Scores );
	
	return true;
}

stock GetPlayerPacketLoss( playerid )
{
    new pack[ 280 ], pa[ 12 ];
        
    GetPlayerNetworkStats( playerid, pack, 280 );
    new packet = strfind( pack, "Packetloss:" );
    strmid( pa, pack, (packet+11), 280 );
    
    return pa;
}

stock ShowConfigDialog( playerid )
{
	new listitem[ 50 ], string[ 450 ];
	
	format( listitem, sizeof( listitem ), "{DFD50B}*** Admin Level 2\n" );
	
	format( string, sizeof( string ), "%s", listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}Sync Bug\t\t%s\n",  serverData[ s_syncbug ] == 1 ? ( "{F3F781}-enabled-" ) : ( "{D5D5D5}-disabled-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}Health Bars\t\t%s\n",  serverData[ s_hpbars ] == 1 ? ( "{F3F781}-enabled-" ) : ( "{D5D5D5}-disabled-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}Player Skins\t\t%s\n",  serverData[ s_setskins ] == 1 ? ( "{F3F781}-enabled-" ) : ( "{D5D5D5}-disabled-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}Lobby Weapons\t%s\n",  serverData[ s_lobbyweps ] == 1 ? ( "{F3F781}-enabled-" ) : ( "{D5D5D5}-disabled-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}Knife Usage\t\t%s\n",  serverData[ s_knife ] == 1 ? ( "{F3F781}-enabled-" ) : ( "{D5D5D5}-disabled-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}Auto Swap\t\t%s\n",  serverData[ s_autoswap ] == 1 ? ( "{F3F781}-enabled-" ) : ( "{D5D5D5}-disabled-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}Server Pass\t\t%s\n",  serverData[ s_serverlock ] == true ? ( "{F3F781}-enabled-" ) : ( "{D5D5D5}-disabled-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DFD50B}*** Admin Level 3\n" );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}MainBar Mode\t\t%s\n",  serverData[ s_mainmode ] == 0 ? ( "{F3F781}-percent-" ) : ( "{D5D5D5}-total-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	format( listitem, sizeof( listitem ), "{DDDDDD}Death Icon\t\t%s\n",  serverData[ s_deathicon ] == 1 ? ( "{F3F781}-enabled-" ) : ( "{D5D5D5}-disabled-" ) );
	
	format( string, sizeof( string ), "%s%s", string, listitem );
	
	return ShowPlayerDialog( playerid, CONFIG_DIALOG, DIALOG_STYLE_LIST , "{FFFFFF}Server Config", string, "Select", "Back" );
}


ShowSpectating( playerid )
{
	new string[ 110 ], Count;

	loopPlayers( otherid )
	{
	    if( playerData[ otherid ][ p_spec ] == playerid )
		{
			Count++;
  			if( Count == 1 ) format( string, sizeof( string ), "%s",  playerData[ otherid ][ p_name ] );
  		
  				else format( string, sizeof( string ), "%s~n~%s", string, playerData[ otherid ][ p_name ] );
  		}
	}
	
	if( !Count ) TextDrawHideForPlayer( playerid, Spectating[ playerid ] );
	else
	{
		format( string, sizeof( string ), "~y~~h~~~Spectating:~n~~w~%s", string );

		TextDrawSetString( Spectating[ playerid ], string );
	    TextDrawShowForPlayer( playerid, Spectating[ playerid ] );
	}
}

GivePlayerModeWeapons( playerid, type )
{
	switch( type )
	{
		case LOBBY:
		{
			if      ( weapsType[ 0 ] == 1 ) GivePlayerWeapon( playerid, 34, 9990 ), GivePlayerWeapon( playerid, 31, 9990 ), GivePlayerWeapon( playerid, 27, 9990 ), GivePlayerWeapon( playerid, 24, 9990 );

			else if ( weapsType[ 0 ] == 2 ) GivePlayerWeapon( playerid, 32, 9990 ), GivePlayerWeapon( playerid, 26, 9990 );

			else if ( weapsType[ 0 ] == 3 ) GivePlayerWeapon( playerid, 34, 9990 ), GivePlayerWeapon( playerid, 32, 9900 ), GivePlayerWeapon( playerid, 31, 9990 ), GivePlayerWeapon( playerid, 26, 9990 ), GivePlayerWeapon( playerid, 24, 9990 );
		}
		case DM:
		{
			switch( playerData[ playerid ][ p_dmrank ] )
			{
		   		case 0..1: GivePlayerWeapon( playerid, 24, 9990 );

			   	case 2..3: GivePlayerWeapon( playerid, 24, 9990 ), GivePlayerWeapon( playerid, 25, 9990 );

			   	case 4..5: GivePlayerWeapon( playerid, 24, 9990 ), GivePlayerWeapon( playerid, 25, 9990 ), GivePlayerWeapon( playerid, 31, 9900 );

			   	case 6..7: GivePlayerWeapon( playerid, 24, 9990 ), GivePlayerWeapon( playerid, 25, 9990 ), GivePlayerWeapon( playerid, 31, 9900 ), GivePlayerWeapon( playerid, 29, 9900 );

			   	case 8..9: GivePlayerWeapon( playerid, 24, 9990 ), GivePlayerWeapon( playerid, 25, 9990 ), GivePlayerWeapon( playerid, 31, 9900 ), GivePlayerWeapon( playerid, 29, 9900 ), GivePlayerWeapon( playerid, 34, 9990 );

				case 10:   GivePlayerWeapon( playerid, 24, 9990 ), GivePlayerWeapon( playerid, 27, 9990 ), GivePlayerWeapon( playerid, 31, 9900 ), GivePlayerWeapon( playerid, 29, 9900 ), GivePlayerWeapon( playerid, 34, 9990 );
			}
		}
		case TDM..BASE:
		{
			if ( weapsType[ type ] == 0 )
			{
			    switch( playerData[ playerid ][ p_wepset ] )
				{
					case 0: TogglePlayerControllable( playerid, 0 ), ShowWeaponDialog( playerid, 0 ), playerData[ playerid ][ p_selecting ] = true;

					case 1: GivePlayerWeapon( playerid, 24, 9900), GivePlayerWeapon( playerid, 30, 9900 );

				    case 2: GivePlayerWeapon( playerid, 24, 9900), GivePlayerWeapon( playerid, 25, 9900 );

				    case 3: GivePlayerWeapon( playerid, 29, 9900), GivePlayerWeapon( playerid, 31, 9900 );

				    case 4: GivePlayerWeapon( playerid, 25, 9900), GivePlayerWeapon( playerid, 34, 9900 );

				    case 5: GivePlayerWeapon( playerid, 23, 9900), GivePlayerWeapon( playerid, 27, 9900 );

				    case 6: GivePlayerWeapon( playerid, 25, 9900), GivePlayerWeapon( playerid, 31, 9900 );

				    case 7: GivePlayerWeapon( playerid, 24, 9900), GivePlayerWeapon( playerid, 33, 9900 );
			  	}
			}

			else if ( weapsType[ serverData[ s_modetype ] ] == 1 ) GivePlayerWeapon( playerid, 34, 9990 ), GivePlayerWeapon( playerid, 31, 9990 ), GivePlayerWeapon( playerid, 25, 9990 ), GivePlayerWeapon( playerid, 24, 9990 );

			else if ( weapsType[ serverData[ s_modetype ] ] == 2 ) GivePlayerWeapon( playerid, 32, 9990 ), GivePlayerWeapon( playerid, 26, 9990 );

			else if ( weapsType[ serverData[ s_modetype ] ] == 3 ) GivePlayerWeapon( playerid, 34, 9990 ), GivePlayerWeapon( playerid, 32, 9900 ), GivePlayerWeapon( playerid, 31, 9990 ), GivePlayerWeapon( playerid, 26, 9990 ), GivePlayerWeapon( playerid, 24, 9990 );

		}
	}
 }

SavePlayerRound( playerid )
{
	new entry[ 256 ], Float:x, Float:y, Float:z, Float:r;

	GetPlayerPos        ( playerid, x, y, z );

	GetPlayerFacingAngle( playerid, r );

	new pguns[ 2 ][ MAX_WEAPON_SLOT ];

	for ( new weap; weap < MAX_WEAPON_SLOT; weap ++ )
	{
		if ( weap == 0 || weap == 1 )
	 	{
			 GetPlayerWeaponData( playerid, weap, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );

			 if ( pguns[ 1 ][ weap ] > 1 )

				pguns[ 1 ][ weap ] = 1;
		}
		else
			 GetPlayerWeaponData( playerid, weap, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );

		format( entry, sizeof( entry ), "%s%i %i ", entry, pguns[ 0 ][ weap ], pguns[ 1 ][ weap ] );
	}

	format( entry, sizeof( entry ), "%0.3f %0.3f %0.3f %0.3f %.0f %.0f %i %i %i %i %s", x, y, z, r, playerData[ playerid ][ p_health ], playerData[ playerid ][ p_armour ], playerData[ playerid ][ p_team ], playerData[ playerid ][ p_rkills ], playerData[ playerid ][ p_dmrank ], GetPlayerVehicleID( playerid ), entry );

	fileSet( TEMP_FILE, playerData[ playerid ][ p_name ], entry );

	format( entry, sizeof( entry ), "*** \"%s\" has been saved for be re-added into the round ( hp: %.0f ).", playerData[ playerid ][ p_name ], playerData[ playerid ][ p_health ] + playerData[ playerid ][ p_armour ] );

	SendClientMessageToAll( MAIN_COLOR2, entry );
	
	if( MatchMode == true )
	{
		loopPlayers( otherid )
		{
		    if ( playerData[ otherid ][ p_spawn ] != LOBBY && GetPlayerState( otherid ) != PLAYER_STATE_WASTED )

				TogglePlayerControllable( otherid, 0 );
		}

		serverData[ s_rpaused ] = true;

		SendClientMessageToAll( ADMIN_COLOR, "*** The round has been auto-paused." );
	}
}

GetPlayerFile( playerid )
{
	new file[ 40 ];

	format( file, sizeof( file ), "ultimate/users/%s.ini", playerData[ playerid ][ p_name ] );

	return file;
}

createAcc( playerid )
{
	new File:afile, entry[ 185 ];

	GetPlayerIp( playerid, entry, 16 );

	format( entry, sizeof( entry ), "IP %s\r\nNick %s\r\nPass 0\r\nLevel 0\r\nRegis 0\r\nPSkin -1\r\nRoundK 0\r\nRoundD 0\r\nDuelsK 0\r\nDuelsD 0\r\nTopKiller 0\r\nCheckpoint 0\r\n", entry, playerData[ playerid ][ p_name ] );

	afile = fopen( GetPlayerFile( playerid ), io_append );

	fwrite( afile, entry );

	fclose( afile );
}

resetVars( playerid )
{
	for( new i; i < MAX_WEAPON_SLOT; i ++ )

	    playerData[ playerid ][ p_weap ][ i ] = 0,
	    playerData[ playerid ][ p_ammo ][ i ] = 0;

	playerData[ playerid ][ p_team        ] = -1;
 	playerData[ playerid ][ p_level       ] =  0;
 	playerData[ playerid ][ p_recentdmg   ] =  0;
 	playerData[ playerid ][ p_cdmg 	      ] =  0;
	playerData[ playerid ][ p_kills       ] =  0;
	playerData[ playerid ][ p_deaths      ] =  0;
	playerData[ playerid ][ p_ckills      ] =  0;
	playerData[ playerid ][ p_boundcount  ] =  9;
	playerData[ playerid ][ p_deaths      ] =  0;
	playerData[ playerid ][ p_cdeaths     ] =  0;
	playerData[ playerid ][ p_score       ] =  0;
	playerData[ playerid ][ p_dmrank      ] =  0;
	playerData[ playerid ][ p_dmkills     ] =  0;
	playerData[ playerid ][ p_ukilled 	  ] =  0;
	playerData[ playerid ][ p_rounddmg    ] =  0;
	playerData[ playerid ][ p_skin        ] = -1;
	playerData[ playerid ][ p_spec        ] = -1;
	playerData[ playerid ][ p_spawn       ] = -1;
	playerData[ playerid ][ p_inround   ] = false;
	playerData[ playerid ][ p_sub       ] = false;
	playerData[ playerid ][ p_muted     ] = false;
	playerData[ playerid ][ p_npass     ] = false;
	playerData[ playerid ][ p_syncing   ] = false;
	playerData[ playerid ][ p_syncwait  ] = false;
	playerData[ playerid ][ p_starting  ] = false;
	playerData[ playerid ][ p_returning ] = false;
	playerData[ playerid ][ p_selecting ] = false;
	playerData[ playerid ][ p_fryzed    ] = false;
	resetBuild( playerid );
}

resetBuild( playerid )
{
	buildData[ playerid ][ c_spawncount    ] = -1;
	buildData[ playerid ][ c_boundiescount ] = -1;
	buildData[ playerid ][ c_editmode      ] = -1;
	buildData[ playerid ][ c_editarena     ] = -1;
	buildData[ playerid ][ c_cspawns       ] = false;
	buildData[ playerid ][ c_ccheckpoint   ] = false;
	buildData[ playerid ][ c_cboundies     ] = false;
	buildData[ playerid ][ c_setspawns     ] = false;
	buildData[ playerid ][ c_setboundies   ] = false;
	buildData[ playerid ][ c_setcheckpoint ] = false;
	buildData[ playerid ][ c_reediting     ] = false;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

public OnPlayerUpdate( playerid )
{
	GetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );
	
	GetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );
	
	return true;
}

public OnPlayerTakeDamage( playerid, issuerid, Float: amount, weaponid )
{
	new Float:Health, Float:Armour, Float:total, string[ 80 ];
	
	GetPlayerHealth( playerid, Health );
	
	GetPlayerArmour( playerid, Armour );
	
	total = ( playerData[ playerid ][ p_health ] + playerData[ playerid ][ p_armour ] );
	
	/*if ( Armour > 0 )
	{
		new obj = CreateObject( 1242, 0, 0, 0, 0, 0, 0 );

		AttachObjectToPlayer( obj, playerid, 0, 0, 1.5, 0, 0 , 0 );

		SetTimerEx( "DestroyObjectEx", 200, false, "i", obj );
	}
	else
	{
		new obj = CreateObject( 1240, 0, 0, 0, 0, 0, 0 );
			
		AttachObjectToPlayer( obj, playerid, 0, 0, 1.5, 0, 0 , 0 );

		SetTimerEx( "DestroyObjectEx", 200, false, "i", obj );
	}*/
   	
	if( issuerid != INVALID_PLAYER_ID && !serverData[ s_rstarted ] || playerData[ playerid ][ p_inround ] && playerData[ playerid ][ p_team ] != playerData[ issuerid ][ p_team ] )
		{
			PlayerPlaySound( issuerid, 17802, 0.0, 0.0, 0.0 );
		
			if( issuer[ playerid ] == issuerid ) KillTimer( HitTextTimer[ issuerid ] );

				else playerData[ playerid ][ p_recentdmg ] = 0, playerData[ playerid ][ p_hits ] = 0, issuer[ playerid ] = issuerid;

			if( total < amount ) playerData[ playerid ][ p_recentdmg ] += total;

				else playerData[ playerid ][ p_recentdmg ] += amount;
				
			playerData[ playerid ][ p_hits ]++;
			
			KillTimer( DmgTextTimer[ playerid ] );
			
			format( string, sizeof( string ), "%d %s~n~-%.0f %s ~n~(%s)", playerData[ playerid ][ p_hits ], playerData[ playerid ][ p_hits ] ? ( "hits" ) : ( "hit" ), playerData[ playerid ][ p_recentdmg ], playerData[ playerid ][ p_name ], weaponNames( weaponid ));
			TextDrawSetString	  ( dmgtxt[ 0 ][ issuerid ], string );
		
			format( string, sizeof( string ), "%d %s~n~-%.0f %s ~n~(%s)", playerData[ playerid ][ p_hits ], playerData[ playerid ][ p_hits ] ? ( "hits" ) : ( "hit" ),  playerData[ playerid ][ p_recentdmg ], playerData[ issuerid ][ p_name ], weaponNames( weaponid ));
			TextDrawSetString	  ( dmgtxt[ 1 ][ playerid ], string );

			TextDrawShowForPlayer ( issuerid, dmgtxt[ 0 ][ issuerid ] );
			TextDrawShowForPlayer ( playerid, dmgtxt[ 1 ][ playerid ] );
		
			HitTextTimer[ issuerid ] = SetTimerEx( "HideHitText", 3500, false, "d", issuerid );
			DmgTextTimer[ playerid ] = SetTimerEx( "HideDmgText", 3500, false, "d", playerid );

			loopPlayers( otherid )
			{
				if( playerData[ otherid ][ p_spec ] == issuerid )
			
					PlayerPlaySound( otherid, 17802, 0.0, 0.0, 0.0 ),

					TextDrawShowForPlayer( otherid, dmgtxt[ 0 ][ issuerid ] );
						
				if( playerData[ otherid ][ p_spec ] == playerid )
			
					TextDrawShowForPlayer( otherid, dmgtxt[ 1 ][ playerid ] );
			}
		}
	
	if( serverData[ s_rstarted ] && playerData[ playerid ][ p_inround ] && playerData[ playerid ][ p_team ] != playerData[ issuerid ][ p_team ] )
		{
			if( playerData[ playerid ][ p_team ] == REF )
			{
				SetPlayerScore ( playerid,   0 );

				SetPlayerHealth( playerid, 100 );

				SetPlayerArmour( playerid, 100 );

				GetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );

				GetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );
			
			}
			else
			{
				if( total < amount ) playerData[ issuerid ][ p_rounddmg ] += total;

					else playerData[ issuerid ][ p_rounddmg ] += amount;		
					
				ShowRoundDamageText( issuerid );
				
				SetTimerEx( "UpdateMaintxt", 100, false, "d", playerid );	
				
				if( weaponid > 48 && weaponid < 51 )
				{
					new info[ 70 ];
					
					loopPlayers( otherid )
					{
						if ( playerData[ otherid ][ p_spawn ] != LOBBY && GetPlayerState( otherid ) != PLAYER_STATE_WASTED )

							TogglePlayerControllable( otherid, 0 );
					}
					serverData[ s_rpaused ] = true;

					SendClientMessageToAll( MAIN_COLOR1, "Auto pause due to vehicle kill," );

					format( info, sizeof( info ), "%s had (%.0f,%.0f), has been vehicle killed by %s.", playerData[ playerid ][ p_name ], playerData[ playerid ][ p_health ],  playerData[ playerid ][ p_armour ], playerData[ issuerid ][ p_name ] );

					SendClientMessageToAll( MAIN_COLOR1, info );

					SetPlayerHealth( playerid, playerData[ playerid ][ p_health ] );

					SetPlayerArmour( playerid, playerData[ playerid ][ p_armour ] );
				}
				
				if( serverData[ s_modetype ] != DM )
				{
					if( playerData[ playerid ][ p_team ] == HOME )
					{
						if( total < amount ) serverData[ s_attdmg ] += total;
						
							else serverData[ s_attdmg ] += amount;
							
						KillTimer( HideDmgTeamText0Timer );
						
						format ( string, sizeof( string ), "%s~h~-%.0f", teamText[ HOME ], serverData[ s_attdmg ] );
							
						TextDrawSetString ( teamdmgtxt[ 0 ], string );
						
						TextDrawShowForAll( teamdmgtxt[ 0 ] );
						
						HideDmgTeamText0Timer = SetTimer( "HideDmgTeamText0", 3000, false );
					}
					if( playerData[ playerid ][ p_team ] == AWAY )
					{
						if( total < amount ) serverData[ s_defdmg ] += total;

							else serverData[ s_defdmg ] += amount;
							
						KillTimer( HideDmgTeamText1Timer );

						format ( string, sizeof( string ), "%s~h~-%.0f", teamText[ AWAY ], serverData[ s_defdmg ] );

						TextDrawSetString ( teamdmgtxt[ 1 ], string );
						
						TextDrawShowForAll( teamdmgtxt[ 1 ] );

						HideDmgTeamText1Timer = SetTimer( "HideDmgTeamText1", 3000, false );
					}
					
					if( playerData[ playerid ][ p_health ] > amount && serverData[ s_modetype ] != DM && serverData[ s_hpbars ] ) 
						
						SetTimerEx( "UpdateBars", 100, false, "d", playerid );	
				}
			}
		}
return true;
}

public HideDmgText( playerid )
{
	TextDrawHideForPlayer( playerid, dmgtxt[ 1 ][ playerid ] );
	
	playerData[ playerid ][ p_recentdmg ] = 0;

	playerData[ playerid ][ p_hits ] = 0;
	
	issuer[ playerid ] = -1;
	
	loopPlayers( otherid )
	{
	    if( playerData[ otherid ][ p_spec ] == playerid )
	    
			TextDrawHideForPlayer( otherid, dmgtxt[ 1 ][ playerid ] );
	}

return true;
}

public HideHitText( playerid )
{
	TextDrawHideForPlayer( playerid, dmgtxt[ 0 ][ playerid ] );

	loopPlayers( otherid )
	{
	    if( playerData[ otherid ][ p_spec ] == playerid )

			TextDrawHideForPlayer( otherid, dmgtxt[ 0 ][ playerid ] );
	}

return true;
}

forward HideDmgTeamText0(playerid); public HideDmgTeamText0( playerid )
{
	TextDrawHideForAll( teamdmgtxt[ 0 ] );

	serverData[ s_attdmg ] = 0;
}

forward HideDmgTeamText1(playerid); public HideDmgTeamText1( playerid )
{
	TextDrawHideForAll( teamdmgtxt[ 1 ] );
	
	serverData[ s_defdmg ] = 0;
}

public DisableGunMenu( )
{
	serverData[ s_gunmenu ] = false;

	loopPlayers( playerid )
	
		Update3DTextLabelText( playerData[ playerid ][ p_label ], 1, "" );

	return true;
}

ShowWeaponDialog( playerid, dweaponid )
{
		new string[ 30 ];

		format( string, sizeof( string ), "%s / %s", weaponNames( playerData[ playerid ][ p_RWeapon1 ] ), weaponNames( playerData[ playerid ][ p_RWeapon2 ] ) );

		switch( dweaponid )
		{
			case 0: ShowPlayerDialog(playerid, WEAPON_DIALOG1 ,DIALOG_STYLE_LIST, "Weapon Menu 1", "* Deagle (x9990)\n* Spas-12 (x9990)\n* m4 (x9990)\n* Sniper (x9990)","Ok", "Skip");

			case 1: ShowPlayerDialog(playerid, WEAPON_DIALOG2 ,DIALOG_STYLE_LIST, "Weapon Menu 2", "* Shotgun (x9990)\n* MP5 (x9990)\n* AK-47 (x9990)\n* Rifle (x9990)","Ok", "Skip");

			case 2: ShowPlayerDialog(playerid, WEAPON_DIALOG3 ,DIALOG_STYLE_MSGBOX, "Confirm", string, "Ok", "Back");
		}
		
	return true;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case WEAPON_DIALOG1:
	    {
	        if( !response ) return ShowWeaponDialog( playerid, 1 );

			new info[ 80 ];

			if ( !setsLimit[ listitem ] )
			{
             	ShowWeaponDialog ( playerid, 0 );

			   	SendClientMessage( playerid, ERROR_COLOR, "(ERROR) This weapon has been disabled." );

			   	return false;
			}

			if ( ( playerData[ playerid ][ p_team ] == HOME && setsChoises[ HOME ][ listitem ] >= setsLimit[ listitem ] ) || ( playerData[ playerid ][ p_team ] == AWAY && setsChoises[ AWAY ][ listitem ] >= setsLimit[ listitem ] ) )
			{
             	ShowWeaponDialog(playerid, 0);

			   	format( info, sizeof( info ), "(ERROR) The set limit was exceded. Only %i per team.", setsLimit[ listitem ] );

				SendClientMessage( playerid, ERROR_COLOR, info );

			   	return false;
			}

	            switch(listitem)
	            {
	                case 0: playerData[ playerid ][ p_RWeapon1 ] = 24;
	                case 1: playerData[ playerid ][ p_RWeapon1 ] = 27;
	                case 2: playerData[ playerid ][ p_RWeapon1 ] = 31;
	                case 3: playerData[ playerid ][ p_RWeapon1 ] = 34;
	            }

				Var1[ playerid ] = listitem;

				ResetPlayerWeapons( playerid );

				setsChoises[ playerData[ playerid ][ p_team ] ][ listitem ]++;

				GivePlayerWeapon( playerid, playerData[ playerid ][ p_RWeapon1 ], 9900 );

				PlayerPlaySound( playerid, 1084, 0, 0, 0 );

	            ShowWeaponDialog( playerid, 1 );
	    }

	    case WEAPON_DIALOG2:
	    {
	        if(!response) return playerData[ playerid ][ p_RWeapon2 ] = 0, ShowWeaponDialog(playerid, 2);

	            switch(listitem)
	            {
	                case 0:
					{
					    if( playerData[ playerid ][ p_RWeapon1 ] == 27 )
					    {
					        SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You already selected one weapon of this class, please select another." );

							ShowWeaponDialog ( playerid, 1 );

							return false;
					    }
                        else playerData[ playerid ][ p_RWeapon2 ] = 25;
					}

	                case 1: playerData[ playerid ][ p_RWeapon2 ] = 29;

	                case 2:
					{
					    if( playerData[ playerid ][ p_RWeapon1 ] == 31 )
					    {
					        SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You already selected one weapon of this class, please select another." );

							ShowWeaponDialog ( playerid, 1 );

							return false;
					    }
                        else playerData[ playerid ][ p_RWeapon2 ] = 30;
					}

	                case 3:
					{
					    if( playerData[ playerid ][ p_RWeapon1 ] == 34 )
					    {
					        SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You already selected one weapon of this class, please select another." );

							ShowWeaponDialog ( playerid, 1 );

							return false;
					    }
                        else playerData[ playerid ][ p_RWeapon2 ] = 33;
					}

	            }

				GivePlayerWeapon( playerid, playerData[ playerid ][ p_RWeapon2 ], 9900 );

				PlayerPlaySound ( playerid, 1084, 0, 0, 0 );

	            ShowWeaponDialog( playerid, 2 );
	    }

		case WEAPON_DIALOG3:
		{
	        if( !response )
			{
				setsChoises[ playerData[ playerid ][ p_team ] ][ Var1[playerid] ]--;

				playerData[ playerid ][ p_RWeapon1 ] = 0;

				playerData[ playerid ][ p_RWeapon2 ] = 0;

				ResetPlayerWeapons( playerid );

	            ShowWeaponDialog( playerid, 0 );

	            return false;
			}

				new info[ 90 ], weaps[ 30 ];

				TogglePlayerControllable ( playerid, true );

				format( info, sizeof( info ), "(TEAM) \"%s\" has selected his weapons (%s, %s).", playerData[ playerid ][ p_name ], weaponNames(playerData[ playerid ][ p_RWeapon1 ]), weaponNames( playerData[ playerid ][ p_RWeapon2 ] ));

				format( weaps, sizeof( weaps ), "%s,~n~%s", weaponNames(playerData[ playerid ][ p_RWeapon1 ]), weaponNames( playerData[ playerid ][ p_RWeapon2 ] ) );

				loopPlayers( otherid )
				{
		    		if ( playerData[ otherid ][ p_team ] != playerData[ playerid ][ p_team ] )
		        		continue;

					SendClientMessage( otherid, teamColor[ playerData[ playerid ][ p_team ] ][ 0 ], info );
				}

				playerData[ playerid ][ p_selecting ] = false;

				if( serverData[ s_rpaused ] ) TogglePlayerControllable( playerid, false );

				if( serverData[ s_gunmenu ] == true )
				{
				    format( info, sizeof( info ), "%s\n%s", weaponNames(playerData[ playerid ][ p_RWeapon1 ]), weaponNames( playerData[ playerid ][ p_RWeapon2 ] ) );

					Update3DTextLabelText( playerData[ playerid ][ p_label ], 0xFFBF00FF, info );
				}
				
				if( serverData[ s_knife ] ) GivePlayerWeapon( playerid, 4, 1 );
		}
		case CONFIG_DIALOG:
		{
			if( response )
			{
				if( serverData[ s_rstarted ] ) 
					return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) You can't change it while a round is started." );
				
				if( listitem == 0 ) ShowConfigDialog( playerid );
					
				if( listitem == 1 )
				{
					if ( !serverData[ s_syncbug ] )

						serverData[ s_syncbug ] = true, fileSet( CONFIG_FILE, "SyncBug", intstr( true ) ), SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You enabled the sync bug." );
					else
						serverData[ s_syncbug ] = false, fileSet( CONFIG_FILE, "SyncBug", intstr( false ) ), SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You disabled the sync bug." );
					
					ShowConfigDialog( playerid );	
				}
				if( listitem == 2 )
				{
					if ( !serverData[ s_hpbars ] )

						serverData[ s_hpbars ] = true, fileSet( CONFIG_FILE, "HPbars", intstr( true ) ), SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You enabled the health bars." );
					else
						serverData[ s_hpbars ] = false, fileSet( CONFIG_FILE, "HPbars", intstr( false ) ), SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You disabled the health bars." );
					
					ShowConfigDialog( playerid );	
				}
				if( listitem == 3 )
				{
					if( !serverData[ s_setskins ] ) 
					
						serverData[ s_setskins ] = 1, fileSet( CONFIG_FILE, "PSetSkins", intstr( 1 ) ), SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You enabled the player skins." );
					else 
						serverData[ s_setskins ] = 0, fileSet( CONFIG_FILE, "PSetSkins", intstr( 0 ) ), SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You disabled the player skins." );
					
					ShowConfigDialog( playerid );	
				}
				if( listitem == 4 )
				{
					if ( !serverData[ s_lobbyweps ] )

						serverData[ s_lobbyweps ] = true, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You enabled the lobby weapons." ), fileSet( CONFIG_FILE, "LobbyWeps", intstr( true ) );
					else
						serverData[ s_lobbyweps ] = false, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You disabled the lobby weapons." ), fileSet( CONFIG_FILE, "LobbyWeps", intstr( false ) );
					
					ShowConfigDialog( playerid );	
				}
				if( listitem == 5 )
				{
					if ( !serverData[ s_knife ] )

						serverData[ s_knife ] = 1, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You enabled knife usage." );
					else
						serverData[ s_knife ] = 0, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You disabled knife usage." );
					
					ShowConfigDialog( playerid );	
				}
				if( listitem == 6 )
				{
					if ( !serverData[ s_autoswap ] )

						serverData[ s_autoswap ] = true, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You enabled auto-swap." ), fileSet( CONFIG_FILE, "AutoSwap", intstr( true ) );
					else
						serverData[ s_autoswap ] = false, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You disabled auto-swap." ), fileSet( CONFIG_FILE, "AutoSwap", intstr( false ) );
					
					ShowConfigDialog( playerid );	
				}
				if( listitem == 7 )
				{
					if ( !serverData[ s_serverlock ] )

						ShowPlayerDialog( playerid, LOCK_DIALOG, DIALOG_STYLE_INPUT, "{DDDDDD}Lock", "Enter a password", "Ok", "Back" );
					else
					{
						new info[ 60 ];
						
						format( info, sizeof( info ), "*** Admin \"%s\" has opened server.", playerData[ playerid ][ p_name ] );

						SendClientMessageToAll( ADMIN_COLOR, info );

						fileSet( CONFIG_FILE, "ServerLock", "-1" );

						serverData[ s_serverlock ] = false;

						sPassword = "-1";
					}
				}
				
				if( listitem == 8 ) ShowConfigDialog( playerid );
				
				if( listitem == 9 )
				{
					if( playerData[ playerid ][ p_level ] < 3 )
						return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No enought level.");
						
					if ( !serverData[ s_mainmode ] )

						serverData[ s_mainmode ] = true, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You changed the main bar mode to total." );
					else
						serverData[ s_mainmode ] = false, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You changed the main bar mode to percent." );
					
					ShowConfigDialog( playerid );	
				}
				if( listitem == 10 )
				{
					if( playerData[ playerid ][ p_level ] < 3 )
						return SendClientMessage( playerid, ERROR_COLOR, "(ERROR) No enought level.");
				
					if ( !serverData[ s_deathicon ] )

						serverData[ s_deathicon ] = true, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You enabled the death icons." );
					else
						serverData[ s_deathicon ] = false, SendClientMessage( playerid, MAIN_COLOR1, "(INFO) You disabled the death icons." );
					
					ShowConfigDialog( playerid );	
				}
				
				PlayerPlaySound ( playerid, 1084, 0, 0, 0 );
			}
		}
		case LOCK_DIALOG:
		{
			if( response && strlen( inputtext ) )
			{
				new info[ 60 ];
				
				format( info, sizeof( info ), "*** Admin \"%s\" has closed the server.", playerData[ playerid ][ p_name ] );

				SendClientMessageToAll( ADMIN_COLOR, info );

				fileSet( CONFIG_FILE, "ServerLock", inputtext );

				serverData[ s_serverlock ] = true;
					
				format( sPassword, sizeof( sPassword ), inputtext );
				
				PlayerPlaySound ( playerid, 1084, 0, 0, 0 );
			}
			else ShowConfigDialog( playerid );
		}
	}

	return true;
}

public OnPlayerClickPlayer( playerid, clickedplayerid, source )
{
	new string[ 30 ], country[ 20 ];
	
	format( string, sizeof(string), "*** \"%s\" info:", playerData[ clickedplayerid][ p_name ] );
	
	SendClientMessage( playerid, GREY_COLOR, string );
	
	format( string, sizeof(string), "*** Packetloss: {B3B3B3}%.1f", GetPlayerPacketLoss( clickedplayerid ) );

	SendClientMessage( playerid, 0xFFFFFFFF, string );
	
	GetPlayerCountry( playerid, country, sizeof( country ));
	
	format( string, sizeof(string), "*** Contry: {B3B3B3}%s.", country );

	SendClientMessage( playerid, 0xFFFFFFFF, string );

	format( string, sizeof(string), "*** Ping: {B3B3B3}%d.", GetPlayerPing( clickedplayerid ) );

	SendClientMessage( playerid, 0xFFFFFFFF, string );

	format( string, sizeof(string), "*** FPS: {B3B3B3}%d.", GetPlayerFPS( clickedplayerid ) );

	SendClientMessage( playerid, 0xFFFFFFFF, string );
	
	return true;
}

public ShowDMpoints( playerid, points )
{
	ShowingDMpoints[ playerid ] = 1;
	
	new info[ 6 ];
	
	format( info, sizeof( info ), "+%d", points );
	
	TextDrawSetString( DMpoints[ playerid ], info );
	
	TextDrawShowForPlayer( playerid, DMpoints[ playerid ] );
	
	DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 25, false, "ii", playerid, 1 );

	return true;
}

public UpdateDMpoints( playerid, time )
{
	switch( time )
	{
		case 1: TextDrawLetterSize( DMpoints[ playerid ], 0.53 , 1.35 ), TextDrawShowForPlayer( playerid, DMpoints[ playerid ] ), 
			DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 25, false, "ii", playerid, 2 );
			
		case 2: TextDrawLetterSize( DMpoints[ playerid ], 0.57 , 1.60 ), TextDrawShowForPlayer( playerid, DMpoints[ playerid ] ),
			DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 25, false, "ii", playerid, 3 );
			
		case 3: TextDrawLetterSize( DMpoints[ playerid ], 0.60 , 1.85 ), TextDrawShowForPlayer( playerid, DMpoints[ playerid ] ),
			DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 25, false, "ii", playerid, 4 );
			
		case 4: TextDrawLetterSize( DMpoints[ playerid ], 0.61 , 2.20 ), TextDrawShowForPlayer( playerid, DMpoints[ playerid ] ),
			DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 85, false, "ii", playerid, 5 );
			
		case 5: TextDrawLetterSize( DMpoints[ playerid ], 0.61 , 1.85 ), TextDrawShowForPlayer( playerid, DMpoints[ playerid ] ),
			DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 40, false, "ii", playerid, 6 );
			
		case 6: TextDrawLetterSize( DMpoints[ playerid ], 0.57 , 1.60 ), TextDrawShowForPlayer( playerid, DMpoints[ playerid ] ),
			DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 40, false, "ii", playerid, 7 );
			
		case 7: TextDrawLetterSize( DMpoints[ playerid ], 0.53 , 1.35 ), TextDrawShowForPlayer( playerid, DMpoints[ playerid ] ),
			DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 40, false, "ii", playerid, 8 );
			
		case 8: TextDrawLetterSize( DMpoints[ playerid ], 0.50 , 1.10 ), TextDrawShowForPlayer( playerid, DMpoints[ playerid ] ),
			DMpointsT[ playerid ] = SetTimerEx( "UpdateDMpoints", 3100, false, "ii", playerid, 9 );
			
		case 9: TextDrawHideForPlayer( playerid, DMpoints[ playerid ] ), ShowingDMpoints[ playerid ] = 0;
	}
}
