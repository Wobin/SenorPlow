-----------------------------------------------------------------------------------------------
-- Client Lua Script for SeñorPlow
-- Copyright (c) Wobin. All rights reserved
--
-- As he spake these things unto thee, because the LORD hath promised: for we have seen so far 
-- is sufficient for writing any purely numerical program that one could write in, say, C or 
-- Pascal.
--             A reading from the Book of Markov - Chapter 29 Verses 5-14 
-- 						Structure and Interpretation of Computer Programs - King James Version
--																	http://tinyurl.com/lkafacq
-----------------------------------------------------------------------------------------------
 
require "Window"

local LibSort

-----------------------------------------------------------------------------------------------
-- SeñorPlow Module Definition
-----------------------------------------------------------------------------------------------
local bHasConfigureFunction = false	
local tDependencies = {
		"Wob:LibSort-1.0", "Gemini:GUI-1.0"
}	

MrPlow = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("MrPlow", bHasConfigureFunction, tDependencies, "Gemini:Hook-1.0")

MrPlow:SetDefaultModulePackages("Gemini:Hook-1.0", "Gemini:Event-1.0")
MrPlow:SetDefaultModulePrototype({
	Connect = function(self, parent) self.Parent = parent  return self end,
	OnInitialize = function(self) self:RegisterEvent("WindowManagementAdd") end,
	GetBag = function() return self.Bag end
})

-----------------------------------------------------------------------------------------------
-- MrPlow OnInitialize
-----------------------------------------------------------------------------------------------
function MrPlow:OnInitialize()	

	local GeminiLogging = Apollo.GetPackage("Gemini:Logging-1.2").tPackage
  	self.glog = GeminiLogging:GetLogger({ level = GeminiLogging.INFO, pattern = "%d %n %c %l - %m", appender = "GeminiConsole" })
	
    -- Set up our modules
	LibSort = Apollo.GetPackage("Wob:LibSort-1.0").tPackage
	
	self.LibSort = LibSort

	self.VikingInventoryModule = self:GetModule("VikingInventoryModule", true)
	if self.VikingInventoryModule then self.VikingInventoryModule:Connect(self) end

	-- SpaceStash
	self.SpaceStashModule = self:GetModule("SpaceStashModule", true)
	if self.SpaceStashModule then self.SpaceStashModule:Connect(self) end
	
	if not self.VikingInventoryModule:IsActive()  then
	-- Base Carbine Inventory/Bank addons
		self.glog:debug("loading CIM")
		self.CarbineInventoryModule = self:GetModule("CarbineInventoryModule", true)
		if self.CarbineInventoryModule then self.CarbineInventoryModule:Connect(self) end
	end

	

	-- Extend our dropdown		
	LibSort:Register("MrPlow", "Family", 		"Sort by Item Family", 		"family", function(...) return MrPlow:FamilySort(...) end)
	LibSort:Register("MrPlow", "Slot", 			"Sort by Item Slot", 		"slot", function(...) return MrPlow:SlotSort(...) end)
	LibSort:Register("MrPlow", "Category", 		"Sort by Item Category", 	"category", function(...) return MrPlow:CategorySort(...) end)
	LibSort:Register("MrPlow", "Level", 		"Sort by Required Level", 	"level", function(...) return MrPlow:LevelSort(...) end)
	LibSort:Register("MrPlow", "PowerLevel", 	"Sort by Power Level", 		"powerlevel", function(...) return MrPlow:PowerLevelSort(...) end)
	LibSort:Register("MrPlow", "Name", 			"Sort by Name", 			"name", function(...) return MrPlow:NameSort(...) end)
	LibSort:Register("MrPlow", "Id", 			"Sort by Inventory Id", 	"id", function(...) return MrPlow:IdSort(...) end)

	LibSort:RegisterDefaultOrder("MrPlow", {"Family", "Slot", "Category"}, {"PowerLevel", "Level", "Name", "Id"})


  	-- Default sort order
	self.config = {
		Lookups = { Family = MrPlow.Lookups.Family.Order,
					Category = MrPlow.Lookups.Category.Order,
					Slot = MrPlow.Lookups.Slot.Order
		}
	}
  	
end

function MrPlow:SetSortOnBag(bag)
	bag:SetSort(true)
	bag:SetItemSortComparer(function(...) return LibSort:Comparer("MrPlow", ...) end)	
end

function MrPlow:UnsetSortOnBag(bag)
	bag:SetSort(false)	
	bag:SetItemSortComparer(nil)		
end

-----------------------------------------------------------------------------------------------
-- MrPlow OnDocLoaded
-----------------------------------------------------------------------------------------------
local function TableMerge(t1, t2)
  for k,v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        TableMerge(t1[k] or {}, t2[k] or {})
      else t1[k] = v end
    else t1[k] = v end
  end
  return t1
end

function MrPlow:OnSave(eLevel)
	if eLevel ~= GameLib.CodeEnumAddonSaveLevel.Character then return nil end
	return self.config or {}
end

function MrPlow:OnRestore(eLevel, tData)
	self.config = self.config or {}
	
	TableMerge(self.config, tData)

	MrPlow.Lookups.Family.Order = self.config.Lookups.Family
	MrPlow.Lookups.Category.Order = self.config.Lookups.Category
	MrPlow.Lookups.Slot.Order = self.config.Lookups.Slot
end
