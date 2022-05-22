Config = {

BlipSprite = 237,
BlipColor = 26,
BlipText = 'Crafting',

UseLimitSystem = true, -- Enable if your esx uses limit system

CraftingStopWithDistance = false, -- Crafting will stop when not near workbench

ExperiancePerCraft = 5, -- The amount of experiance added per craft (100 Experiance is 1 level)

HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job

Categories = {

['items'] = {
	Label = 'Items',
	Image = 'items',
	Jobs = {}
},
['weapons'] = {
	Label = 'WEAPONS',
	Image = 'weapons',
	Jobs = {}
}


},

PermanentItems = { -- Items that dont get removed when crafting
	['wrench'] = true
},

NamesNeed = {
	['lsd'] = 'LSD',
	['adrenalin'] = 'Adrenalin',
	['sianoor'] = 'Sianoor',
	['WEAPON_PISTOL50'] = 'Pistol50',
	['WEAPON_PISTOL_MK2'] = 'Pistol MK2',
	['WEAPON_HEAVYPISTOL'] = 'HeavyPistol',
	['WEAPON_ASSAULTSMG'] = 'Assault Smg',
	['WEAPON_ADVANCEDRIFLE'] = 'Advanced Rifle',
	['WEAPON_GUSENBERG'] = 'Gusenberg',
	['WEAPON_COMBATPISTOL'] = 'Combat Pistol',
	['WEAPON_MICROSMG'] = 'MicroSmg',
	['WEAPON_CARBINERIFLE'] = 'Carbine Rifle',
	['WEAPON_CARBINERIFLE_MK2'] = 'Carbine Rifle MK2',
	['WEAPON_ASSAULTRIFLE'] = 'Assault Rifle',
	['WEAPON_ASSAULTRIFLE_MK2'] = 'Assault Rifle MK2',
	['WEAPON_SMG'] = 'SMG',
	['WEAPON_SMG_MK2'] = 'SMG MK2',
	['WEAPON_PISTOL'] = 'Pistol',
	['WEAPON_BULLPUP_MK2'] = 'BULLPUP MK2',
	['WEAPON_BULLPUP'] = 'BULLPUP',
	['wood'] = 'Choob',
	['copper'] = 'Copper',
	['iron'] = 'Iron',
	['plastic'] = 'Plastic',
	['kheshabacp'] = '45 ACP',
	['kheshabmm'] = '9 MM',
	['kheshabrifle'] = '7.62',
	['tyre'] = 'Charkh Mashin',
	['door'] = 'Dar mashin',
	['fixtool'] = 'Repair Kit',
	['packagedmeth'] = 'Shishe',
	['packagedcoca'] = 'Coce',
	['packagedweed'] = 'Weed',
	['scope'] = 'Scope',
	['flashlight'] = 'Flashlight',
	['silencer'] = 'Silencer',
	['grip'] = 'Grip',
	['water'] = 'Ab',
	['vodka'] = 'Vodka',
	['beer'] = 'Abjo',
	['whiskey'] = 'whiskey',
	['lockpick'] = 'LockPick',
	['drill'] = 'Drill',
	['blowtorch'] = 'BlowTorch',
	['rasperry'] = 'Abzar Hack',
	['opium'] = 'Tanbako',
	['zoghal'] = 'Zoghal'
},

Recipes = { -- Enter Item name and then the speed value! The higher the value the more torque


['WEAPON_PISTOL'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 0, -- The amount that will be crafted
	SuccessRate = 70, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 40, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 45,
		['wood'] = 40,
		['plastic'] = 15,
		['copper'] = 15
	},
	GangsNeed = {
		['Yakuza'] = true,
		['Camorra'] = true,
		['Sicilian'] = true,
	},
},

['WEAPON_COMBATPISTOL'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 0, -- The amount that will be crafted
	SuccessRate = 70, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 40, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 45,
		['wood'] = 40,
		['plastic'] = 15,
		['copper'] = 15
	},
	GangsNeed = {
		['Yakuza'] = true,
		['Camorra'] = true,
		['Sicilian'] = true,
	},
},


['WEAPON_HEAVYPISTOL'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 45, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 45,
		['wood'] = 40,
		['plastic'] = 15,
		['copper'] = 15
	},
	GangsNeed = {
		['Yakuza'] = true,
		['Camorra'] = true,
		['Sicilian'] = true,
	},
},

['WEAPON_PISTOL50'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 70, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 45, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 45,
		['wood'] = 40,
		['plastic'] = 15,
		['copper'] = 15
	},
	GangsNeed = {
		['Yakuza'] = true,
		['Camorra'] = true,
		['Sicilian'] = true,
	},
},

['WEAPON_ASSAULTSMG'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 110,
		['wood'] = 50,
		['plastic'] = 20,
		['copper'] = 30
	},
	GangsNeed = {
		['Sicilian'] = true,
	},
},

['WEAPON_GUSENBERG'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 130,
		['wood'] = 60,
		['plastic'] = 25,
		['copper'] = 40
	},
	GangsNeed = {
		['Yakuza'] = true,
		['Camorra'] = true,
		['Sicilian'] = true,
	},
},

['WEAPON_MICROSMG'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 110,
		['wood'] = 50,
		['plastic'] = 20,
		['copper'] = 30
	},
	GangsNeed = {
		['Yakuza'] = true
	},
},

['WEAPON_ASSAULTRIFLE'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 160,
		['wood'] = 70,
		['plastic'] = 30,
		['copper'] = 50
	},
	GangsNeed = {
		['Yakuza'] = true
	},
},

['WEAPON_CARBINERIFLE'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 160,
		['wood'] = 70,
		['plastic'] = 30,
		['copper'] = 50
	},
	GangsNeed = {
		['Sicilian'] = true
	},
},

['WEAPON_ADVANCEDRIFLE'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 160,
		['wood'] = 70,
		['plastic'] = 30,
		['copper'] = 50
	},
	GangsNeed = {
		['Camorra'] = true
	},
},

['WEAPON_SMG'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 110,
		['wood'] = 50,
		['plastic'] = 20,
		['copper'] = 30
	},
	GangsNeed = {
		['Camorra'] = true
	},
},

['WEAPON_CARBINERIFLE_MK2'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['WEAPON_CARBINERIFLE'] = 1,
		['iron'] = 20,
		['copper'] = 5
	},
	GangsNeed = {
		['ROSE'] = true
	},
},

['WEAPON_ASSAULTRIFLE_MK2'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['WEAPON_ASSAULTRIFLE'] = 1,
		['iron'] = 18,
		['copper'] = 5
	},
	GangsNeed = {
		['ROSE'] = true
	},
},

['WEAPON_PISTOL_MK2'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['WEAPON_PISTOL'] = 1,
		['iron'] = 10,
		['copper'] = 2
	},
	GangsNeed = {
		['ROSE'] = true
	},
},

['WEAPON_SMG_MK2'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['WEAPON_SMG'] = 1,
		['iron'] = 14,
		['copper'] = 6
	},
	GangsNeed = {
		['ROSE'] = true
	},
},

['WEAPON_BULLPUP_MK2'] = {
	Category = 'weapons', -- The category item will be put in
	isGun = true, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['WEAPON_BULLPUP'] = 1,
		['iron'] = 24,
		['copper'] = 8
	},
	GangsNeed = {
		['ROSE'] = true
	},
},

['yusuf'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['copper'] = 15,
		['iron'] = 10,
	},
	GangsNeed = {
		['L2K'] = true,
	},
},

['scope'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 15,
	},
	GangsNeed = {
		['L2K'] = true,
	},
},

['flashlight'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 12,
		['copper'] = 3
	},
	GangsNeed = {
		['L2K'] = true,
	},
},

['silencer'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 15,
		['copper'] = 15
	},
	GangsNeed = {
		['L2K'] = true,
	},
},

['grip'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 18,
		['copper'] = 10
	},
	GangsNeed = {
		['L2K'] = true,
	},
},

['kheshabmm'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 5,
	},
	GangsNeed = {
		['L2K'] = true,
	},
},

['vodka'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['wood'] = 5,
		['water'] = 2,
		['packagedmeth'] = 1
	},
	GangsNeed = {
		['bahamas'] = true,
	},
},

['beer'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['wood'] = 3,
		['water'] = 1,
		['packagedcoca'] = 2,
	},
	GangsNeed = {
		['bahamas'] = true,
	},
},

['whiskey'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['wood'] = 5,
		['water'] = 3,
		['packagedcoca'] = 2,
	},
	GangsNeed = {
		['bahamas'] = true,
	},
},

['zoghal'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['wood'] = 10,
	},
	GangsNeed = {
		['cafe'] = true,
	},
},

['opium'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 10, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packagedcoca'] = 2,
	},
	GangsNeed = {
		['cafe'] = true,
	},
},

['kheshabacp'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 15, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 8,
	},
	GangsNeed = {
		['L2K'] = true,
	},
},

['kheshabrifle'] = {
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, --  100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 15, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 10,
	},
	GangsNeed = {
		['L2K'] = true,
	},
},


['lsd'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 40, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packagedcoca'] = 3,
		['packagedweed'] = 3
	},
	GangsNeed = {
		['GHOST'] = true
	},
},

['adrenalin'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 40, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packagedcoca'] = 4,
		['packagedweed'] = 4
	},
	GangsNeed = {
		['GHOST'] = true
	},
},

['sianoor'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 40, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['packagedmeth'] = 3,
		['packagedcoca'] = 2
	},
	GangsNeed = {
		['GHOST'] = true
	},
},

['tyre'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 30, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['plastic'] = 10,
		['copper'] = 5
	},
	GangsNeed = {
		['mechanic'] = true,
		['motormechanic'] = true,
	},
},

['door'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 30, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 20,
		['plastic'] = 10
	},
	GangsNeed = {
		['mechanic'] = true,
		['motormechanic'] = true,
	},
},

['fixtool'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 30, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 12,
		['plastic'] = 6
	},
	GangsNeed = {
		['mechanic'] = true,
		['motormechanic'] = true,
	},
},

['lockpick'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 10,
		['plastic'] = 5
	},
	GangsNeed = {
		['semsary'] = true,
	},
},

['drill'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 30, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 20,
		['plastic'] = 10
	},
	GangsNeed = {
		['semsary'] = true,
	},
},

['blowtorch'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 25, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 15,
		['plastic'] = 8
	},
	GangsNeed = {
		['semsary'] = true,
	},
},

['rasperry'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'items', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 90, -- 90% That the craft will succeed! If it does not you will lose your ingredients
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 25, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['iron'] = 15,
		['plastic'] = 10
	},
	GangsNeed = {
		['semsary'] = true,
	},
},

},

Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access
	{coords = vector3(2331.15,3037.46,-49.15), jobs = {}, blip = false, recipes = {}, radius = 3.0 },
},


Text = {

    ['not_enough_ingredients'] = '~r~Shoma Item Haye Mored Niaz Ra Nadarid',
    ['you_cant_hold_item'] = '~r~Nemitavanid In Item Ra Craft Konid !',
    ['item_crafted'] = '~g~Item Craft Shod !',
    ['wrong_job'] = 'You cant open this workbench',
    ['workbench_hologram'] = 'Dokmeye [~b~E~w~] Bznid Baraye Baz Shodan Menu Craft',
    ['wrong_usage'] = 'Wrong usage of command',
    ['inv_limit_exceed'] = '~r~Jaye Khali Baraye Craft Item Dar Inventory Khod Nadarid !',
    ['crafting_failed'] = '~r~Shans Nadashti Itemet Shekast !'
}

}



function SendTextMessage(msg)
    ESX.ShowNotification(msg)
end
