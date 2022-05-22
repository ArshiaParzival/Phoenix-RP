Config = {}

-- Police Settings:
Config.PoliceJobs = {"police", "dadgostari"}	-- Jobs that can't do bankrobberies etc, but can secure the banks.

-- Alert Blip
Config.AlertBlipShow = true			-- enable or disable blip on map on police notify
Config.AlertBlipTime = 20			-- miliseconds that blip is active on map (this value is multiplied with 4 in the script)
Config.AlertBlipRadius = 50.0		-- set radius of the police notify blip
Config.AlertBlipAlpha = 250			-- set alpha of the blip
Config.AlertBlipColor = 1			-- set blip color

-- Minigames:
Config.mHacking = true				-- set to false to disable mhacking at the first keypad. // MUST ADD YOUR OWN THEN!!
Config.utkFingerPrint = true		-- set to false to disable utku fingerprint at the second keypad. // MUST ADD YOUR OWN THEN!!
Config.ChanceHackerDeviceBack = 75	-- set chance in % of getting hackerDevice back upon successful hacking.

-- Items:
Config.HackItem = "rasperry"
Config.LockPick = "lockpick"
Config.HammerWireCutter = "blowtorch"
Config.AccessCard = "accesscard"

-- Buttons:
Config.KeyHackTerminal = 38			-- Button for first keypad
Config.KeyHackVault = 311			-- Button for second keypad
Config.KeyOpenVaultDoor = 38		-- Button to open door
Config.KeyCloseVaultDoor = 38		-- Button to close door
Config.KeySecureVaultDoor = 47		-- Button to secure vault door

-- Other:
Config.HasItemLabel = true			-- set to false if your ESX vers. doesnt support item labels.

-- Banks:
Config.Banks = {
    [1] = {
        name = "Fleeca Bank [Legion Square]",
        blip = {enable = false, bName = "Fleeca Bank [Legion Square]", display = 4, sprite = 431, color = 5, scale = 0.7},
        inUse = false, minCops = 4,
        vault = { pos = {147.349,-1046.24,29.3681}, model = 2121050683, oHeadMin = 124.0, oHeadMax = 154.0, cHeadMin = 235.0, cHeadMax = 265.0 },
        door = { pos = {149.561, -1047.35, 29.34634}, model = -1591004109 },
        keypads = {
            [1] = { pos = {147.349,-1046.24,29.3681}, hacked = false },
            [2] = { pos = {148.52,-1046.574,29.59628}, hacked = false },
		},
		deskDoor = { pos = {145.562,-1041.337,29.36801}, model = -131754413, heading = 249.84619, lockpicked = false, oHeadMin = 160.0, oHeadMax = 180.0, cHeadMin = 235.0, cHeadMax = 265.0},
		deskCash = {
			[1] = {pos = {151.13,-1042.02,29.37}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = {149.7,-1041.48,29.37}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = {148.08,-1040.85,29.37}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},
		powerBox = {pos = {135.60,-1046.45,29.63}, disabled = false, animPos = {135.34,-1047.09,29.15}, animHeading = 340.66, freeTime = 60, hackSuccess = {enable = true, time = 30}}
    },
    [2] = {
        name = "Fleeca Bank [Alta]",
        blip = {enable = false, bName = "Fleeca Bank [Alta]", display = 4, sprite = 431, color = 5, scale = 0.7},
        inUse = false, minCops = 4,
        vault = { pos = {311.6992,-284.5561,54.1648}, model = 2121050683, oHeadMin = 124.0, oHeadMax = 154.0, cHeadMin = 235.0, cHeadMax = 265.0 },
        door = { pos = {313.8916,-285.7734,54.14302}, model = -1591004109 },
        keypads = {
            [1] = { pos = {311.6992,-284.5561,54.1648}, hacked = false },
            [2] = { pos = {312.8784,-284.991,54.39302}, hacked = false },
        },
		deskDoor = { pos = {310.0,-279.73,54.16}, model = -131754413, heading = 249.865966, lockpicked = false, oHeadMin = 160.0, oHeadMax = 180.0, cHeadMin = 235.0, cHeadMax = 265.0},
		deskCash = {
			[1] = {pos = {315.42,-280.26,54.16}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = {313.7,-279.59,54.16}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = {312.08,-279.07,54.16}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},
		powerBox = {pos = {258.66,-308.09,49.65}, disabled = false, animPos = {258.92,-307.33,49.65}, animHeading = 162.16, freeTime = 60, hackSuccess = {enable = true, time = 30}}
	},
	[3] = {
		name = "Fleeca Bank [Burton]",
		blip = { enable = false, bName = "Fleeca Bank [Burton]", display = 4, sprite = 431, color = 5, scale = 0.7 },
		inUse = false, minCops = 4,
		vault = { pos = {-353.32,-55.47687,49.03565}, model = 2121050683, oHeadMin = 124.0, oHeadMax = 154.0, cHeadMin = 235.0, cHeadMax = 265.0 },
		door = { pos = {-351.097, -56.46866, 49.01482}, model = -1591004109 },
		keypads = {
            [1] = { pos = {-353.32,-55.47687,49.03565}, hacked = false },
            [2] = { pos = {-352.2206, -55.77902, 49.2348}, hacked = false },
        },
		deskDoor = { pos = {-355.19,-50.56,49.04}, model = -131754413, heading = 250.85983, lockpicked = false, oHeadMin = 160.0, oHeadMax = 180.0, cHeadMin = 235.0, cHeadMax = 265.0},
		deskCash = {
			[1] = {pos = {-349.61,-51.04,49.04}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = {-351.3,-50.47,49.04}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = {-353.09,-49.86,49.04}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},
		powerBox = {pos = {-355.77,-50.22,54.42}, disabled = false, animPos = {-356.54,-49.91,54.42}, animHeading = 249.03, freeTime = 60, hackSuccess = {enable = true, time = 30}}
	},
	[4] = {
		name = "Fleeca Bank [Rockford Hills]",
		blip = { enable = false, bName = "Fleeca Bank [Rockford Hills]", display = 4, sprite = 431, color = 5, scale = 0.7 },
		inUse = false, minCops = 4,
		vault = { pos = {-1210.31,-336.334,37.781}, model = 2121050683, oHeadMin = 170.0, oHeadMax = 200.0, cHeadMin = 277.0, cHeadMax = 307.0 },
		door = { pos = {-1208.084, -335.4738, 37.75928}, model = -1591004109 },
		keypads = {
            [1] = { pos = {-1210.31,-336.334,37.781}, hacked = false },
            [2] = { pos = {-1209.306, -335.7388, 37.97926}, hacked = false },
        },
		deskDoor = { pos = {-1215.11,-334.23,37.78}, model = -131754413, heading = 296.8637, lockpicked = false, oHeadMin = 205.0, oHeadMax = 225.0, cHeadMin = 277.0, cHeadMax = 307.0},
		deskCash = {
			[1] = {pos = {-1210.58,-330.75,37.78}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = {-1211.99,-331.45,37.78}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = {-1213.63,-332.28,37.78}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},
		powerBox = {pos = {-1217.14,-332.99,42.12}, disabled = false, animPos = {-1216.5,-332.63,42.12}, animHeading = 119.32, freeTime = 60, hackSuccess = {enable = true, time = 30}}
	},
	[5] = {
		name = "Fleeca Bank [Grand Senora Desert]",
		blip = { enable = false, bName = "Fleeca Bank [Grand Senora Desert]", display = 4, sprite = 431, color = 5, scale = 0.7 },
		inUse = false, minCops = 4,
		vault = { pos = {1175.544,2712.855,38.088}, model = 2121050683, oHeadMin = 320.0, oHeadMax = 350.0, cHeadMin = 80.0, cHeadMax = 110.0 },
		door = { pos = {1173.07, 2713.166, 38.06626}, model = -1591004109 },
		keypads = {
            [1] = { pos = {1175.544,2712.855,38.088}, hacked = false },
            [2] = { pos = {1174.376,2712.854,38.26626}, hacked = false },
		},
		deskDoor = { pos = {1178.84,2708.87,38.09}, model = -131754413, heading = 90.0, lockpicked = false, oHeadMin = 0.0, oHeadMax = 25.0, cHeadMin = 80.0, cHeadMax = 110.0},
		deskCash = {
			[1] = {pos = {1173.16,2707.75,38.09}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = {1174.9,2707.76,38.09}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = {1176.59,2707.73,38.09}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},
		powerBox = {pos = {1158.18,2708.96,37.98}, disabled = false, animPos = {1157.47,2708.92,37.98}, animHeading = 269.46, freeTime = 60, hackSuccess = {enable = true, time = 30}}
	},
	[6] = {
		name = "Fleeca Bank [Great Ocean Highway]",
		blip = { enable = false, bName = "Fleeca Bank [Great Ocean Highway]", display = 4, sprite = 431, color = 5, scale = 0.7 },
		inUse = false, minCops = 4,
		vault = { pos = {-2956.473,482.2,15.99}, model = -63539571, oHeadMin = 230.0, oHeadMax = 260.0, cHeadMin = 340.0, cHeadMax = 370.0 },
		door = { pos = {-2956.226, 484.5746, 15.67534}, model = -1591004109, },
		keypads = {
            [1] = { pos = {-2956.473,482.2,15.99}, hacked = false },
            [2] = { pos = {-2956.44, 483.3556, 15.87528}, hacked = false },
		},
		deskDoor = { pos = {-2960.67,479.08,15.7}, model = -131754413, heading = 357.54295, lockpicked = false, oHeadMin = 260.0, oHeadMax = 280.0, cHeadMin = 340.0, cHeadMax = 370.0},
		deskCash = {
			[1] = {pos = {-2961.67,484.62,15.7}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = {-2961.76,482.99,15.7}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = {-2961.83,481.25,15.7}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},
		powerBox = {pos = {-2948.05,481.05,15.44}, disabled = false, animPos = {-2947.25,480.95,15.26}, animHeading = 90.32, freeTime = 60, hackSuccess = {enable = true, time = 30}}
	},
	[7] = {
		name = "Blaine County Savings Bank",
		blip = { enable = false, bName = "BCS Bank", display = 4, sprite = 431, color = 5, scale = 0.7 },
		inUse = false, minCops = 6,
		vault = { pos = {-105.9,6472.11,31.9}, model = -1185205679, oHeadMin = 140.0, oHeadMax = 170.0, cHeadMin = 30.0, cHeadMax = 60.0 },
		door = { pos = {-105.817, 6475.618, 31.62672}, model = 1309269072 },
		keypads = {
            [1] = { pos = {-105.9,6472.11,31.9}, hacked = false },
            [2] = { pos = {-105.5096, 6475.232, 32.00}, hacked = false },
		},
		deskDoor = { pos = {-109.36,6468.74,31.63}, model = -1184592117, heading = 45.00006, lockpicked = false, oHeadMin = 315.0, oHeadMax = 335.0, cHeadMin = 35.0, cHeadMax = 65.0},
		deskCash = {
			[1] = {pos = {-113.64,6471.79,31.63}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = {-112.32,6470.43,31.63}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = {-111.27,6469.37,31.63}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},
		powerBox = {pos = {-109.45,6483.29,31.47}, disabled = false, animPos = {-110.0,6483.8,31.47}, animHeading = 224.89, freeTime = 60, hackSuccess = {enable = true, time = 30}}
	},
	[8] = {
		name = "Pacific Standard Public Deposit Bank",
		blip = { enable = false, bName = "PSPD Bank", display = 4, sprite = 431, color = 5, scale = 0.7 },
		inUse = false, minCops = 9,
		vault = { pos = {252.8114,228.4967,102.0833}, model = 961976194, oHeadMin = 20.0, oHeadMax = 40.0, cHeadMin = 150.0, cHeadMax = 165.0 },
		door = { pos = {262.1650,221.76,106.2851}, model = 746855201 },
		keypads = {
			[1] = { pos = {262.3505,223.0325,106.7842}, hacked = false },
			[2] = { pos = {252.8114,228.4967,102.0833}, hacked = false },
		},
		deskDoor = { pos = {257.01,220.54,106.29}, model = -222270721, heading = 340.0, lockpicked = false, oHeadMin = 49.0, oHeadMax = 69.0, cHeadMin = 330.0, cHeadMax = 350.0},
		deskCash = {
			[1] = {pos = {242.64,226.22,106.29}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = {247.76,224.27,106.29}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = {252.88,222.43,106.29}, robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},
		powerBox = {pos = {255.50,227.14,151.63}, disabled = false, animPos = {255.22,226.35,151.63}, animHeading = 339.25, freeTime = 60, hackSuccess = {enable = true, time = 30}},
		safe = {cracked = false},
	},
}

-- DRILL SECTION:

Config.DrillItem = "drill"		-- item name from database
Config.DrillStopKey = 178		-- button to stop drill

Config.ChanceToKeepDrill = 25	-- set chance in % of keeping drill after successfull drill finish.

Config.SafeItemRewards = {
	[1] = { item = "jewels", chance = 30, min = 10, max = 50},
}

Config.SafeMoneyReward = {{
	dirtyCash = false,			-- set to false to receive normal cash
	minAmount = 250000,				-- this value is multiplied with 1000 in script, so 15 means 15.000$
	maxAmount = 500000,				-- this value is multiplied with 1000 in script, so 30 means 30.000$
}}

Config.Safes = {
	-- Fleeca Bank (Great Ocean Highway):
	[1] = { pos = {-2954.138,481.9888,15.6753}, AnimPos = {-2954.136,482.8257,15.67532}, AnimHeading = 174.28378295898, robbed = false, failed = false },
	[2] = { pos = {-2952.124,484.4436,15.67539}, AnimPos = {-2952.935,484.3697,15.67539}, AnimHeading = 263.67068481445, robbed = false, failed = false },
	[3] = { pos = {-2954.121,486.7845,15.67542}, AnimPos = {-2954.104,485.9754,15.6754}, AnimHeading = 355.06997680664, robbed = false, failed = false },
	[4] = { pos = {-2958.85,484.0662,15.6753}, AnimPos = {-2958.034,484.128,15.6753}, AnimHeading = 89.174713134766, robbed = false, failed = false },
	[5] = { pos = {-2957.4,486.2582,15.67534}, AnimPos = {-2957.432,485.405,15.67534}, AnimHeading = 354.07684326172, robbed = false, failed = false },
	
	-- Fleeca Bank (Grand Senora Desert):
	[6] = { pos = {1175.632,2715.207,38.06627}, AnimPos = {1174.726,2715.25,38.06627}, AnimHeading = 266.26025390625, robbed = false, failed = false },
	[7] = { pos = {1173.126,2717.204,38.0663}, AnimPos = {1173.09,2716.304,38.0663}, AnimHeading = 356.55850219727, robbed = false, failed = false },
	[8] = { pos = {1170.816,2715.171,38.06633}, AnimPos = {1171.683,2715.196,38.06633}, AnimHeading = 87.711120605469, robbed = false, failed = false },
	[9] = { pos = {1173.77,2710.368,38.06626}, AnimPos = {1173.77,2711.246,38.06626}, AnimHeading = 180.11283874512, robbed = false, failed = false },
	[10] = { pos = {1171.362,2711.888,38.06626}, AnimPos = {1172.23,2711.848,38.06626}, AnimHeading = 88.924171447754, robbed = false, failed = false },
	
	-- Blaine County Savings Bank:
	[11] = { pos = {-102.59,6475.231,31.62672}, AnimPos = {-103.1672,6475.829,31.65008}, AnimHeading = 220.24415588379, robbed = false, failed = false },
	[12] = { pos = {-103.0840,6478.672,31.62672}, AnimPos = {-103.6711,6478.08,31.62672}, AnimHeading = 318.58407592773, robbed = false, failed = false },
	[13] = { pos = {-106.8801,6478.354,31.62672}, AnimPos = {-106.2137,6477.688,31.62672}, AnimHeading = 43.0051612854, robbed = false, failed = false },
	[14] = { pos = {-107.3154,6473.156,31.6267}, AnimPos = {-106.8056,6473.856,31.6267}, AnimHeading = 137.65379333496, robbed = false, failed = false },
	[15] = { pos = {-107.9968,6475.834,31.6267}, AnimPos = {-107.3258,6475.314,31.6267}, AnimHeading = 48.860725402832, robbed = false, failed = false },
	
	-- Fleeca Bank (Legion Square):
	[16] = { pos = {146.485,-1048.443,29.34629}, AnimPos = {147.2295,-1048.667,29.3463}, AnimHeading = 68.842262268066, robbed = false, failed = false },
	[17] = { pos = {148.1023,-1051.246,29.34637}, AnimPos = {148.3918,-1050.358,29.34637}, AnimHeading = 155.65719604492, robbed = false, failed = false },
	[18] = { pos = {150.9744,-1050.026,29.34639}, AnimPos = {150.1801,-1049.772,29.34639}, AnimHeading = 249.98104858398, robbed = false, failed = false },
	[19] = { pos = {149.7868,-1044.556,29.34628}, AnimPos = {149.6842,-1045.262,29.34628}, AnimHeading = 342.73184204102, robbed = false, failed = false },
	[20] = { pos = {151.5238,-1046.762,29.34632}, AnimPos = {150.7966,-1046.51,29.34632}, AnimHeading = 247.81353759766, robbed = false, failed = false },
	
	-- Fleeca Bank (Alta):
	[21] = { pos = {310.7052,-286.8021,54.14304}, AnimPos = {311.6111,-287.0925,54.14304}, AnimHeading = 68.989158630371, robbed = false, failed = false },
	[22] = { pos = {312.5067,-289.5924,54.14307}, AnimPos = {312.7517,-288.7129,54.14307}, AnimHeading = 159.08302307129, robbed = false, failed = false },
	[23] = { pos = {315.2691,-288.2983,54.1431}, AnimPos = {314.4778,-288.1304,54.1431}, AnimHeading = 253.56311035156, robbed = false, failed = false },
	[24] = { pos = {314.250,-282.9718,54.143}, AnimPos = {313.9552,-283.6234,54.143}, AnimHeading = 342.52990722656, robbed = false, failed = false },
	[25] = { pos = {315.8612,-285.0188,54.143}, AnimPos = {315.1184,-284.787,54.143}, AnimHeading = 248.85200500488, robbed = false, failed = false },
	
	-- Fleeca Bank (Burton):
	[26] = { pos = {-354.3059,-57.70284,49.0148}, AnimPos = {-353.4183,-57.87337,49.01482}, AnimHeading = 68.584251403809, robbed = false, failed = false },
	[27] = { pos = {-352.5196,-60.42201,49.01486}, AnimPos = {-352.1959,-59.51867,49.01486}, AnimHeading = 159.24656677246, robbed = false, failed = false },
	[28] = { pos = {-349.625,-59.11305,49.01488}, AnimPos = {-350.4966,-58.94504,49.01488}, AnimHeading = 254.33476257324, robbed = false, failed = false },
	[29] = { pos = {-350.7996,-53.70058,49.01478}, AnimPos = {-351.0674,-54.45698,49.01478}, AnimHeading = 344.00854492188, robbed = false, failed = false },
	[30] = { pos = {-349.2906,-55.90288,49.0148}, AnimPos = {-349.9846,-55.67392,49.0148}, AnimHeading = 247.43865966796, robbed = false, failed = false },
	
	-- Fleeca Bank (Rockford Hills):
	[31] = { pos = {-1209.453,-338.4711,37.75927}, AnimPos = {-1208.604,-338.0278,37.75927}, AnimHeading = 115.5665512085, robbed = false, failed = false },
	[32] = { pos = {-1206.101,-339.1532,37.7593}, AnimPos = {-1206.626,-338.3526,37.7593}, AnimHeading = 206.15647888184, robbed = false, failed = false },
	[33] = { pos = {-1205.041,-336.1968,37.75933}, AnimPos = {-1205.828,-336.7115,37.75933}, AnimHeading = 299.26043701172, robbed = false, failed = false },
	[34] = { pos = {-1209.892,-333.4096,37.75926}, AnimPos = {-1209.52,-333.9354,37.75926}, AnimHeading = 26.248168945312, robbed = false, failed = false },
	[35] = { pos = {-1207.252,-333.5498,37.75926}, AnimPos = {-1207.788,-333.9974,37.75926}, AnimHeading = 298.41012573242, robbed = false, failed = false },
	
	-- Pacific Standard Public Deposit Bank:
	[36] = { pos = {258.645,218.8373,101.6834}, AnimPos = {258.4535,218.0434,101.6834}, AnimHeading = 340.15432739258, robbed = false, failed = false },
	[37] = { pos = {260.9536,217.9817,101.6834}, AnimPos = {260.6777,217.1929,101.6834}, AnimHeading = 335.23226928711, robbed = false, failed = false },
	[38] = { pos = {256.9889,214.1322,101.6834}, AnimPos = {257.2587,214.9102,101.6834}, AnimHeading = 158.06999206543, robbed = false, failed = false },
	[39] = { pos = {259.2212,213.3388,101.6834}, AnimPos = {259.4739,214.1086,101.6834}, AnimHeading = 159.97286987305, robbed = false, failed = false },
	[40] = { pos = {263.3824,216.9818,101.6834}, AnimPos = {263.1836,216.3488,101.6834}, AnimHeading = 342.95043945312, robbed = false, failed = false },
	[41] = { pos = {265.2072,216.3506,101.6834}, AnimPos = {265.049,215.6598,101.6834}, AnimHeading = 344.45587158204, robbed = false, failed = false },
	[42] = { pos = {266.8224,214.623,101.6834}, AnimPos = {266.2266,214.8334,101.6834}, AnimHeading = 247.95391845704, robbed = false, failed = false },
	[43] = { pos = {265.9872,212.3818,101.6834}, AnimPos = {265.467,212.5886,101.6834}, AnimHeading = 253.22686767578, robbed = false, failed = false },
	[44] = { pos = {263.7534,211.7626,101.6834}, AnimPos = {263.988,212.3554,101.6834}, AnimHeading = 158.84526062012, robbed = false, failed = false },
	[45] = { pos = {261.5878,212.6732,101.6834}, AnimPos = {261.7706,213.2954,101.6834}, AnimHeading = 158.96224975586, robbed = false, failed = false },
}

-- Camera Interaction Buttons:
Config.CamLeft = 174	-- Arrow Left
Config.CamRight = 175	-- Arrow Right
Config.CamUp = 172		-- Arrow Up
Config.CamDown = 173	-- Arrow Down
Config.CamExit = 178	-- DEL

Config.Camera = {
	[1] = {pos = {153.15,-1042.05,29.37}, heading = 44.32, name = 'Fleeca Bank [Legion Square] Cam #1'},
	[2] = {pos = {143.1,-1042.76,29.37}, heading = 235.08, name = 'Fleeca Bank [Legion Square] Cam #2'},
	[3] = {pos = {149.73,-1051.26,29.35}, heading = 16.87, name = 'Fleeca Bank [Legion Square] Cam #3'},
	--
	[4] = {pos = {317.63,-280.51,54.16}, heading = 46.96, name = 'Fleeca Bank [Alta] Cam #1'},
	[5] = {pos = {307.43,-281.14,54.16}, heading = 229.91, name = 'Fleeca Bank [Alta] Cam #2'},
	[6] = {pos = {314.07,-289.63,54.14}, heading = 24.06, name = 'Fleeca Bank [Alta] Cam #3'},
	--
	[7] = {pos = {-347.51,-51.26,49.04}, heading = 44.82, name = 'Fleeca Bank [Burton] Cam #1'},
	[8] = {pos = {-357.61,-51.92,49.04}, heading = 230.92, name = 'Fleeca Bank [Burton] Cam #2'},
	[9] = {pos = {-350.91,-60.51,49.01}, heading = 28.09, name = 'Fleeca Bank [Burton] Cam #3'},
	--
	[10] = {pos = {-1209.33,-329.2,37.78}, heading = 83.18, name = 'Fleeca Bank [Rockford Hills] Cam #1'},
	[11] = {pos = {-1215.84,-336.86,37.78}, heading = 270.99, name = 'Fleeca Bank [Rockford Hills] Cam #2'},
	[12] = {pos = {-1205.0,-338.07,37.76}, heading = 66.41, name = 'Fleeca Bank [Rockford Hills] Cam #3'},
	--
	[13] = {pos = {1171.39,2706.91,38.09}, heading = 243.26, name = 'Fleeca Bank [Grand Senora Desert] Cam #1'},
	[14] = {pos = {1180.68,2710.88,38.09}, heading = 63.94, name = 'Fleeca Bank [Grand Senora Desert] Cam #2'},
	[15] = {pos = {1171.55,2716.84,38.07}, heading = 226.04, name = 'Fleeca Bank [Grand Senora Desert] Cam #3'},
	--
	[16] = {pos = {-2962.26,486.62,15.7}, heading = 158.82, name = 'Fleeca Bank [Great Ocean Highway] Cam #1'},
	[17] = {pos = {-2958.7,477.21,15.7}, heading = 341.95, name = 'Fleeca Bank [Great Ocean Highway] Cam #2'},
	[18] = {pos = {-2952.44,485.95,15.68}, heading = 134.42, name = 'Fleeca Bank [Great Ocean Highway] Cam #3'},
	--
	[19] = {pos = {-108.86,6461.75,31.63}, heading = 357.17, name = 'Blaine County Savings Bank Cam #1'},
	[20] = {pos = {-103.91,6466.68,31.63}, heading = 89.7, name = 'Blaine County Savings Bank Cam #2'},
	[21] = {pos = {-102.28,6468.39,31.63}, heading = 29.87, name = 'Blaine County Savings Bank Cam #3'},
	[22] = {pos = {-104.54,6479.56,31.63}, heading = 176.15, name = 'Blaine County Savings Bank Cam #4'},
	--
	[23] = {pos = {233.11,221.94,106.29}, heading = 207.24, name = 'Pacific Standard Bank Cam #1'},
	[24] = {pos = {241.76,214.98,106.29}, heading = 283.2, name = 'Pacific Standard Bank Cam #2'},
	[25] = {pos = {258.99,204.19,110.29}, heading = 320.66, name = 'Pacific Standard Bank Cam #3'},
	[26] = {pos = {252.48,229.25,106.29}, heading = 157.75, name = 'Pacific Standard Bank Cam #4'},
	[27] = {pos = {252.0,225.43,101.68}, heading = 271.93, name = 'Pacific Standard Bank Cam #5'},
	--
}