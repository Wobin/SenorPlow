-----------------------------------------------------------------------------------------------
-- Client Lua Script for SeñorPlow
-- Copyright (c) Wobin. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
-----------------------------------------------------------------------------------------------
-- SeñorPlow Module Definition
-----------------------------------------------------------------------------------------------
local MrPlow = {} 
local LibSort
local inventory
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
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
	[FAMILY.ARMOR] = 				1,
	[FAMILY.WEAPON] = 				2,
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

MrPlow.Lookups = {}
MrPlow.Lookups.FAMILY = FAMILY
MrPlow.Lookups.FAMILYORDER = FAMILYORDER
MrPlow.Lookups.CATEGORY = CATEGORY
MrPlow.Lookups.CATEGORYORDER = CATEGORYORDER
MrPlow.Lookups.SLOT = SLOT

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function MrPlow:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    -- initialize variables here

    return o
end

function MrPlow:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		"Wob:LibSort-1.0", "Inventory"
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)

end
 
-----------------------------------------------------------------------------------------------
-- MrPlow OnLoad
-----------------------------------------------------------------------------------------------
function MrPlow:OnLoad()
    -- Set up our modules
	LibSort = Apollo.GetPackage("Wob:LibSort-1.0").tPackage

	-- Check if Inventory is loaded
	inventory = Apollo.GetAddon("Inventory")
	
	self.xmlDoc = XmlDoc.CreateFromFile("SenorPlow.xml")
	self.xmlDoc2 = XmlDoc.CreateFromFile("NewForm.xml")
		
		if not inventory.wndMain then -- Look out for the event that it has
		Apollo.RegisterEventHandler("WindowManagementAdd", "HookExtraButton", self)
	else -- we're good to go
		self:HookExtraButton()
	end

		-- Extend our dropdown		
		LibSort:Register("MrPlow", "Family", "Sort by Item Family", "family", function(...) return MrPlow:FamilySort(...) end)
		LibSort:Register("MrPlow", "Slot", "Sort by Item Slot", "slot", function(...) return MrPlow:SlotSort(...) end)
		LibSort:Register("MrPlow", "Category", "Sort by Item Category", "category", function(...) return MrPlow:CategorySort(...) end)
		LibSort:Register("MrPlow", "Level", "Sort by Required Level", "level", function(...) return MrPlow:LevelSort(...) end)
		LibSort:Register("MrPlow", "Name", "Sort by Name", "level", function(...) return MrPlow:NameSort(...) end)

		self.LibSort = LibSort	
end


-----------------------------------------------------------------------------------------------
-- MrPlow OnDocLoaded
-----------------------------------------------------------------------------------------------


function MrPlow:HookExtraButton(args)
	if args and args.strName ~= Apollo.GetString("InterfaceMenu_Inventory") then return end
	
	inventoryMain = inventory.wndMain or args.wnd
	
	self.inventory = inventory
	local prompt = inventory.wndMain:FindChild("ItemSortPrompt")
	prompt:SetAnchorOffsets(-26, 9, 26, 205)
	
	-- Make the existing bottom button a middle button
	inventory.wndMain:FindChild("IconBtnSortQuality"):ChangeArt("BK3:btnHolo_ListView_Mid")

	-- Create our additional button and hook it in
	self.wndMain = Apollo.LoadForm(self.xmlDoc, "IconBtnSortAll", prompt , self)
	self.wndForm = Apollo.LoadForm(self.xmlDoc2, "MrPlowForm", nil , self)
	
	if self.wndMain == nil then
		Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
		return
	end
	if inventory.nSortItemType == 4 and inventory.bShouldSortItems then
		self.wndMain:SetCheck(inventory.bShouldSortItems)
		inventory.wndMainBagWindow:SetSort(true)
		inventory.wndMainBagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
	end	
end


function MrPlow:FamilySort(itemLeft, itemRight)	
	local aFam = itemLeft:GetItemFamily()
	local bFam = itemRight:GetItemFamily()
	
	if FAMILYDUPES[aFam] then aFam = FAMILYDUPES[aFam] end
	if FAMILYDUPES[bFam] then bFam = FAMILYDUPES[bFam] end

	if aFam == bFam then return 0 end
	if (FAMILYORDER[aFam] or 0) < (FAMILYORDER[bFam] or 0) then return -1 end
	if (FAMILYORDER[aFam] or 0) > (FAMILYORDER[bFam] or 0) then return 1 end
end

function MrPlow:SlotSort(itemLeft, itemRight)	
	local aSlot = itemLeft:GetSlot()
	local bSlot = itemRight:GetSlot()

	if aSlot == bSlot then return 0 end
	if (SLOTORDER[aSlot] or 0) < (SLOTORDER[bSlot] or 0) then return -1 end
	if (SLOTORDER[aSlot] or 0) > (SLOTORDER[bSlot] or 0) then return 1 end
end

function MrPlow:CategorySort(itemLeft, itemRight)	
	local aCat = itemLeft:GetItemCategory()
	local bCat = itemRight:GetItemCategory()

	if CATEGORYDUPES[aCat] then aCat = CATEGORYDUPES[aCat] end
	if CATEGORYDUPES[bCat] then bCat = CATEGORYDUPES[bCat] end

	if aCat == bCat then return 0 end
	if (CATEGORYORDER[aCat] or 0) > (CATEGORYORDER[bCat] or 0) then return -1 end
	if (CATEGORYORDER[aCat] or 0) < (CATEGORYORDER[bCat] or 0) then return 1 end
end

function MrPlow:LevelSort(itemLeft, itemRight)
	local aLvl = itemLeft:GetRequiredLevel()
	local bLvl = itemRight:GetRequiredLevel()

	if aLvl == bLvl then return 0 end
	if aLvl > bLvl then return -1 end
	if aLvl < bLvl then return 1 end
end

function MrPlow:NameSort(itemLeft, itemRight)
	local strLeftName = itemLeft:GetName()
	local strRightName = itemRight:GetName()
	if strLeftName > strRightName then
		return 1
	end
	if strLeftName < strRightName then
		return -1
	end
	
	return 0
end

---------------------------------------------------------------------------------------------------
-- IconBtnSortAll Functions
---------------------------------------------------------------------------------------------------
function MrPlow:OnOptionsSortItemsByAll( wndHandler, wndControl, eMouseButton )
	inventory.bShouldSortItems = true
	inventory.nSortItemType = 4
	inventory.wndMainBagWindow:SetSort(true)
	inventory.wndMainBagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
	inventory.wndIconBtnSortDropDown:SetCheck(false)
end

-----------------------------------------------------------------------------------------------
-- MrPlow Instance
-----------------------------------------------------------------------------------------------
local SenorPlow = MrPlow:new()
SenorPlow:Init()
