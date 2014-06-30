local MrPlow = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("MrPlow")

local FAMILY = MrPlow.Lookups.Family.Base 
local FAMILYDUPES = MrPlow.Lookups.Family.Dupes
local FAMILYORDER = MrPlow.Lookups.Family.Order 
local CATEGORY = MrPlow.Lookups.Category.Base 
local CATEGORYDUPES = MrPlow.Lookups.Category.Dupes
local CATEGORYORDER = MrPlow.Lookups.Category.Order 
local SLOT = MrPlow.Lookups.Slot.Base
local SLOTORDER = MrPlow.Lookups.Slot.Order

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


function MrPlow:PowerLevelSort(itemLeft, itemRight)
	local aLvl = itemLeft:GetPowerLevel()
	local bLvl = itemRight:GetPowerLevel()
	
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

function MrPlow:IdSort(itemLeft, itemRight)
	local strLeftId = itemLeft:GetInventoryId()
	local strRightId = itemRight:GetInventoryId()
	if strLeftId > strRightId then
		return 1
	end
	if strLeftId < strRightId then
		return -1
	end
	
	return 0
end