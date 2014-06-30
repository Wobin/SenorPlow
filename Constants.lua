local MrPlow = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("MrPlow")

-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------

local FAMILY = {
		ARMOR = 1, --
		BAG = 5, --
		BROKEN_ITEM = 13, --
		CHARGED_ITEM = 17,--
		CONSUMABLE = 16,--
		COSTUME = 26, --
		CRAFTING = 27,
		GEAR = 15,--
		HOUSING = 20,
		HOUSING_EXTERIOR = 21,--
		FABKIT = 22, --
		MISCELLANEOUS = 25, --
		PATH = 29,--
		QUEST_ITEM = 24, --
		REAGENT = 18,--
		RUNES = 33,--
		SCHEMATIC = 19,--
		TOOL = 28,--
		UNUSUAL_COMPONENT = 31,--
		WARPLOT = 30,--
		WEAPON = 2 --
}

local FAMILYDUPES = {	[FAMILY.FABKIT] = FAMILY.HOUSING,
						[FAMILY.HOUSING_EXTERIOR] = FAMILY.HOUSING}


local FAMILYORDER = {
	[FAMILY.WEAPON] = 				1,
	[FAMILY.ARMOR] = 				2,	
	[FAMILY.COSTUME] = 				3,
	[FAMILY.GEAR] = 				4,
	[FAMILY.PATH] = 				5,
	[FAMILY.CRAFTING] = 			6,
	[FAMILY.REAGENT] = 				7,
	[FAMILY.RUNES] = 				8,
	[FAMILY.SCHEMATIC] = 			9,
	[FAMILY.CONSUMABLE] = 			10,
	[FAMILY.QUEST_ITEM] = 			11,
	[FAMILY.TOOL] = 				12,
	[FAMILY.WARPLOT] = 				13,
	[FAMILY.HOUSING] = 				14,
	[FAMILY.BAG] =  				15,
	[FAMILY.UNUSUAL_COMPONENT] = 	16,
	[FAMILY.CHARGED_ITEM] = 		17,
	[FAMILY.BROKEN_ITEM] = 			18,
	[FAMILY.MISCELLANEOUS] = 		19
}
local FAMILYNAMES = {
	[FAMILY.ARMOR] = 				"Armour",
	[FAMILY.WEAPON] = 				"Weapon",
	[FAMILY.COSTUME] = 				"Costume",
	[FAMILY.GEAR] = 				"Gear",
	[FAMILY.PATH] = 				"Path",
	[FAMILY.CRAFTING] = 			"Crafting",
	[FAMILY.REAGENT] = 				"Reagent",
	[FAMILY.RUNES] = 				"Runes",
	[FAMILY.SCHEMATIC] = 			"Schematic",
	[FAMILY.CONSUMABLE] = 			"Consumable",
	[FAMILY.QUEST_ITEM] = 			"Quest Item",
	[FAMILY.TOOL] = 				"Tool",
	[FAMILY.WARPLOT] = 				"WarPlot",
	[FAMILY.HOUSING] = 				"Housing",
	[FAMILY.BAG] =  				"Bag",
	[FAMILY.UNUSUAL_COMPONENT] = 	"Unusual Component",
	[FAMILY.CHARGED_ITEM] = 		"Charged Item",
	[FAMILY.BROKEN_ITEM] = 			"Broken Item",
	[FAMILY.MISCELLANEOUS] = 		"Misc"	
}

local CATEGORY = {
		ACCENT = 75,			--
		AIR_RUNE= 134,
		ARCHITECT = 118,
		BAG = 88,
		BANDAGE = 50,
		BROKEN_ITEM = 59,
		BROKEN_ITEM2 = 58,
		BOOK = 96, 
		CHARGED_ITEM = 57,
		CHARGED_ITEM2 = 55,
		CONSUMABLE = 53,			
		CLOTH = 113,
		CRAFTING_SUPPLIES= 109,
		COSTUME = 99,
		DISCOVERY_RELIC= 101,
		DYES = 54,
		EARTH_RUNE= 133,
		ELEMENTS = 120,
		ELIXIR = 49,
		FARMING = 104,
		FIRE_RUNE= 131,
		FISHING_TOOL= 115,
		FLOOR = 71,
		FUSION_RUNE= 137,
		GENERAL_MEALS= 127,
		HEAVY_ARMOR= 3,
		HOBBY = 102,
		HOUSING = 67,
		WARPLOT_IMPROVEMENT = 121,
		ELDAN_QUEST = 122,
		FABKIT = 76,
		JUNK = 94,
		LIFE_RUNE= 135,
		LIGHT_ARMOR= 1,
		LOGIC_RUNE= 136,
		LOOT_BAG= 138,
		MASTERCRAFT = 126,
		MEDISHOTSBOOSTS = 48,
		MEDIUM_ARMOR= 2,
		MINING = 103,
		MINING_TOOL= 106,
		MOUNT = 97,
		NOVELTY = 95,
		PET = 98,
		PERMANENT_ENCHANT = 52,		
		PROPRIETARY_MATERIAL= 128,
		QUEST_ITEM = 84,
		QUEST_ITEM2 = 83,
		QUEST_ACTIVATED = 85,
		QUEST_ACTIVATED2= 86,
		QUEST_CONSUMABLE= 87,
		REAGENT = 65,
		REAGENT2 = 62,
		REAGENT_CRAFTING = 63,
		RELIC_HUNTERTOOL = 117,
		RELICS = 107,
		SALVAGEABLE_ITEM= 105,
		SCHEMATIC = 66,		
		SETTLER = 111,
		SKILL_AMP= 130,
		SPECIAL_MEALS= 47,
		STARTS_A_QUEST = 82,
		SURVIVALIST = 110,
		SURVIVALIST_TOOL= 116,
		TECHNOLOGIST = 5,
		WATER_RUNE= 132,
		WARPLOT_DEPLOYABLE_WEAPON = 123,
		WARPLOT_DEPLOYABLE_TRAP = 124,
		WEAPON_ATTACHMENT = 7,
		WEAPON_CLAWS= 24,
		WEAPON_GREATSWORD= 8,
		WEAPON_HEAVY_GUN= 108,
		WEAPON_PADDLES= 12,
		WEAPON_PISTOLS= 16,
		WEAPON_PSYBLADE= 22,
		WEAPON_RIFLE= 10,
		WEAPON_STAFF= 20,
}

CATEGORYDUPES = {	[CATEGORY.QUEST_ACTIVATED] = CATEGORY.QUEST_ITEM,
					[CATEGORY.QUEST_ACTIVATED2] = CATEGORY.QUEST_ITEM, 
					[CATEGORY.QUEST_ITEM2] = CATEGORY.QUEST_ITEM,
					[CATEGORY.QUEST_CONSUMABLE] = CATEGORY.QUEST_ITEM,
					[CATEGORY.REAGENT2] = CATEGORY.REAGENT,
					[CATEGORY.BROKEN_ITEM2] = CATEGORY.BROKEN_ITEM,
					[CATEGORY.CHARGED_ITEM2] = CATEGORY.CHARGED_ITEM,
					[CATEGORY.ACCENT] = CATEGORY.ARCHITECT,
					[CATEGORY.FLOOR] = CATEGORY.ARCHITECT,
					[CATEGORY.HOUSING] = CATEGORY.ARCHITECT

				}

-- Specific overall order is irrelevant, just order within the families
local CATEGORYORDER = {
		[CATEGORY.AIR_RUNE] = 					1,
		[CATEGORY.EARTH_RUNE] = 				2,
		[CATEGORY.FIRE_RUNE] =  				3,
		[CATEGORY.FUSION_RUNE] =  				4,
		[CATEGORY.LIFE_RUNE] =  				5,
		[CATEGORY.LOGIC_RUNE] =  				6,
		[CATEGORY.WATER_RUNE] =  				7,
		[CATEGORY.HEAVY_ARMOR] =  				8,
		[CATEGORY.MEDIUM_ARMOR] =  				9,
		[CATEGORY.LIGHT_ARMOR] =   				10,
		[CATEGORY.COSTUME] =   					11,
		[CATEGORY.WEAPON_CLAWS] =   			12,
		[CATEGORY.WEAPON_GREATSWORD] = 			13,
		[CATEGORY.WEAPON_HEAVY_GUN] = 			14,
		[CATEGORY.WEAPON_PADDLES] = 			15,
		[CATEGORY.WEAPON_PISTOLS] =   			16,
		[CATEGORY.WEAPON_PSYBLADE] =   			17,
		[CATEGORY.WEAPON_RIFLE] =   			18,
		[CATEGORY.WEAPON_STAFF] =   			19,
		[CATEGORY.WEAPON_ATTACHMENT] =   		20,
		[CATEGORY.RELICS] =   					21,
		[CATEGORY.MINING] =   					22,
		[CATEGORY.SETTLER] =   					23,
		[CATEGORY.SURVIVALIST] =   				24,
		[CATEGORY.TECHNOLOGIST] =   			25,
		[CATEGORY.FARMING] =   					26,
		[CATEGORY.CLOTH] =   					27,
		[CATEGORY.CRAFTING_SUPPLIES] =   		28,
		[CATEGORY.ELEMENTS] =   				29,
		[CATEGORY.MASTERCRAFT] =   				30,
		[CATEGORY.RELIC_HUNTERTOOL] =   		31,
		[CATEGORY.MINING_TOOL] =   				32,
		[CATEGORY.SURVIVALIST_TOOL] =   		33,
		[CATEGORY.ARCHITECT] =   				34,
		[CATEGORY.WARPLOT_IMPROVEMENT] = 		35,
		[CATEGORY.WARPLOT_DEPLOYABLE_WEAPON] = 	36,
		[CATEGORY.WARPLOT_DEPLOYABLE_TRAP] = 	37,
		[CATEGORY.SALVAGEABLE_ITEM] = 			38,
		[CATEGORY.SCHEMATIC] =   				39,
		[CATEGORY.SKILL_AMP] =   				40,
		[CATEGORY.LOOT_BAG] =   				41,
		[CATEGORY.BAG] =   						42,
		[CATEGORY.DYES] =   					43,
		[CATEGORY.SPECIAL_MEALS] =   			44,
		[CATEGORY.GENERAL_MEALS] = 	  			45,
		[CATEGORY.CONSUMABLE] =   				46,
		[CATEGORY.ELIXIR] =   					47,
		[CATEGORY.MEDISHOTSBOOSTS] =   			48,
		[CATEGORY.BANDAGE] =   					49,
		[CATEGORY.QUEST_ITEM] =   				50,
		[CATEGORY.MOUNT] =   					51,
		[CATEGORY.PET] =   				  		52,
		[CATEGORY.ELDAN_QUEST] =   				53,
		[CATEGORY.PERMANENT_ENCHANT] =   		54,
		[CATEGORY.PROPRIETARY_MATERIAL] =  		55,
		[CATEGORY.HOBBY] =   					56,
		[CATEGORY.CHARGED_ITEM] =   			57,
		[CATEGORY.NOVELTY] =   					58,
		[CATEGORY.BROKEN_ITEM] =   				59,
		[CATEGORY.FISHING_TOOL] =  				60,
		[CATEGORY.DISCOVERY_RELIC] =   			61,
		[CATEGORY.REAGENT] =   					62,
		[CATEGORY.REAGENT_CRAFTING] =   		63,		
		[CATEGORY.BOOK] =    					64,
		[CATEGORY.JUNK] =   					65,
		[CATEGORY.STARTS_A_QUEST] =   			66,	
}

local CATEGORYNAMES =  {
		[CATEGORY.AIR_RUNE] = 					"Air Rune",
		[CATEGORY.EARTH_RUNE] = 				"Earth Rune",
		[CATEGORY.FIRE_RUNE] =  				"Fire Rune",
		[CATEGORY.FUSION_RUNE] =  				"Fusion Rune",
		[CATEGORY.LIFE_RUNE] =  				"Life Rune",
		[CATEGORY.LOGIC_RUNE] =  				"Logic Rune",
		[CATEGORY.WATER_RUNE] =  				"Water Rune",
		[CATEGORY.HEAVY_ARMOR] =  				"Heavy Armor",
		[CATEGORY.MEDIUM_ARMOR] =  				"Medium Armor",
		[CATEGORY.LIGHT_ARMOR] =   				"Light Armor",
		[CATEGORY.COSTUME] =   					"Costume",
		[CATEGORY.WEAPON_CLAWS] =   			"Weapon Claws",
		[CATEGORY.WEAPON_GREATSWORD] = 			"Weapon Greatsword",
		[CATEGORY.WEAPON_HEAVY_GUN] = 			"Weapon Heavy Gun",
		[CATEGORY.WEAPON_PADDLES] = 			"Weapon Paddles",
		[CATEGORY.WEAPON_PISTOLS] =   			"Weapon Pistols",
		[CATEGORY.WEAPON_PSYBLADE] =   			"Weapon Psyblade",
		[CATEGORY.WEAPON_RIFLE] =   			"Weapon Rifle",
		[CATEGORY.WEAPON_STAFF] =   			"Weapon Staff",
		[CATEGORY.WEAPON_ATTACHMENT] =   		"Weapon Attachment",
		[CATEGORY.RELICS] =   					"Relics",
		[CATEGORY.MINING] =   					"Mining",
		[CATEGORY.SETTLER] =   					"Settler",
		[CATEGORY.SURVIVALIST] =   				"Survivalist",
		[CATEGORY.TECHNOLOGIST] =   			"Technologist",
		[CATEGORY.FARMING] =   					"Farming",
		[CATEGORY.CLOTH] =   					"Cloth",
		[CATEGORY.CRAFTING_SUPPLIES] =   		"Crafting Supplies",
		[CATEGORY.ELEMENTS] =   				"Elements",
		[CATEGORY.MASTERCRAFT] =   				"Mastercraft",
		[CATEGORY.RELIC_HUNTERTOOL] =   		"Relic Huntertool",
		[CATEGORY.MINING_TOOL] =   				"Mining Tool",
		[CATEGORY.SURVIVALIST_TOOL] =   		"Survivalist Tool",
		[CATEGORY.ARCHITECT] =   				"Architect",
		[CATEGORY.WARPLOT_IMPROVEMENT] = 		"Warplot Improvement",
		[CATEGORY.WARPLOT_DEPLOYABLE_WEAPON] = 	"Warplot Deployable Weapon",
		[CATEGORY.WARPLOT_DEPLOYABLE_TRAP] = 	"Warplot Deployable Trap",
		[CATEGORY.SALVAGEABLE_ITEM] = 			"Salvageable Item",
		[CATEGORY.SCHEMATIC] =   				"Schematic",
		[CATEGORY.SKILL_AMP] =   				"Skill Amp",
		[CATEGORY.LOOT_BAG] =   				"Loot Bag",
		[CATEGORY.BAG] =   						"Bag",
		[CATEGORY.DYES] =   					"Dyes",
		[CATEGORY.SPECIAL_MEALS] =   			"Special Meals",
		[CATEGORY.GENERAL_MEALS] = 	  			"General Meals",
		[CATEGORY.CONSUMABLE] =   				"Consumable",
		[CATEGORY.ELIXIR] =   					"Elixir",
		[CATEGORY.MEDISHOTSBOOSTS] =   			"Medishotsboosts",
		[CATEGORY.BANDAGE] =   					"Bandage",
		[CATEGORY.QUEST_ITEM] =   				"Quest Item",
		[CATEGORY.MOUNT] =   					"Mount",
		[CATEGORY.PET] =   				  		"Pet",
		[CATEGORY.ELDAN_QUEST] =   				"Eldan Quest",
		[CATEGORY.PERMANENT_ENCHANT] =   		"Permanent Enchant",
		[CATEGORY.PROPRIETARY_MATERIAL] =  		"Proprietary Material",
		[CATEGORY.HOBBY] =   					"Hobby",
		[CATEGORY.CHARGED_ITEM] =   			"Charged Item",
		[CATEGORY.NOVELTY] =   					"Novelty",
		[CATEGORY.BROKEN_ITEM] =   				"Broken Item",
		[CATEGORY.FISHING_TOOL] =  				"Fishing Tool",
		[CATEGORY.DISCOVERY_RELIC] =   			"Discovery Relic",
		[CATEGORY.REAGENT] =   					"Reagent",
		[CATEGORY.REAGENT_CRAFTING] =   		"Reagent Crafting",		
		[CATEGORY.BOOK] =    					"Book",
		[CATEGORY.JUNK] =   					"Junk",
		[CATEGORY.STARTS_A_QUEST] =   			"Starts A Quest",	
	}

local SLOT = {
		AUGMENT = 10,
		CHEST = 0,
		FEET = 4,
		GADGET = 11,
		HANDS = 5,
		HEAD = 2,
		BAG = 17,
		WEAPON_ATTACHMENT = 7,
		SUPPORT_SYSTEM = 8,
		KEY = 9,
		LEGS = 1,
		PRIMARY_WEAPON = 16,
		SHIELDS = 15,
		SHOULDER = 3,
		TOOL = 6,
}

local SLOTORDER = {
		[SLOT.PRIMARY_WEAPON] 		=1,
		[SLOT.SHIELDS] 				=2,
		[SLOT.HEAD] 				=3,
		[SLOT.SHOULDER] 			=4,
		[SLOT.CHEST] 				=5,
		[SLOT.HANDS] 				=6,
		[SLOT.LEGS] 				=7,
		[SLOT.FEET] 				=8,
		[SLOT.TOOL] 				=9,
		[SLOT.WEAPON_ATTACHMENT] 	=10,
		[SLOT.SUPPORT_SYSTEM] 		=11,
		[SLOT.GADGET] 				=12,
		[SLOT.KEY] 					=13,
		[SLOT.AUGMENT] 				=14,
		[SLOT.BAG] 					=15,
}

local SLOTNAMES = {
		[SLOT.PRIMARY_WEAPON] 		="Primary Weapon",
		[SLOT.SHIELDS] 				="Shields",
		[SLOT.HEAD] 				="Head",
		[SLOT.SHOULDER] 			="Shoulder",
		[SLOT.CHEST] 				="Chest",
		[SLOT.HANDS] 				="Hands",
		[SLOT.LEGS] 				="Legs",
		[SLOT.FEET] 				="Feet",
		[SLOT.TOOL] 				="Tool",
		[SLOT.WEAPON_ATTACHMENT] 	="Weapon Attachment",
		[SLOT.SUPPORT_SYSTEM] 		="Support System",
		[SLOT.GADGET] 				="Gadget",
		[SLOT.KEY] 					="Key",
		[SLOT.AUGMENT] 				="Augment",
		[SLOT.BAG] 					="Bag",
}
MrPlow.Lookups = {}
MrPlow.Lookups.Family = {Title = "Family", Base = FAMILY, Dupes = FAMILYDUPES, Order = FAMILYORDER, Names = FAMILYNAMES}
MrPlow.Lookups.Category = {Title = "Category", Base = CATEGORY, Dupes = CATEGORYDUPES, Order = CATEGORYORDER, Names = CATEGORYNAMES}
MrPlow.Lookups.Slot = {Title = "Slots", Base = SLOT, Dupes = {}, Order = SLOTORDER, Names = SLOTNAMES}

