-----------------------------------------------------------------------------------------------
-- Client Lua Script for SeñorPlow
-- Copyright (c) Wobin. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
-----------------------------------------------------------------------------------------------
-- SeñorPlow Module Definition
-----------------------------------------------------------------------------------------------
local MrPlow = MrPlow
local LibSort

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
		"Wob:LibSort-1.0", "Inventory", "BankViewer"
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)

end
 
-----------------------------------------------------------------------------------------------
-- MrPlow OnLoad
-----------------------------------------------------------------------------------------------
function MrPlow:OnLoad()
    -- Set up our modules
	LibSort = Apollo.GetPackage("Wob:LibSort-1.0").tPackage
	GeminiGUI = Apollo.GetPackage("Gemini:GUI-1.0").tPackage
	-- Check if Inventory is loaded
	self.inventory = Apollo.GetAddon("Inventory")
	self.bank = Apollo.GetAddon("BankViewer")

	self.xmlDoc = XmlDoc.CreateFromFile("SenorPlow.xml")
	self.xmlDoc2 = XmlDoc.CreateFromFile("NewForm.xml")
	Apollo.RegisterEventHandler("WindowManagementAdd", "WindowManagementAdd", self)

	-- Extend our dropdown		
	LibSort:Register("MrPlow", "Family", "Sort by Item Family", "family", function(...) return MrPlow:FamilySort(...) end)
	LibSort:Register("MrPlow", "Slot", "Sort by Item Slot", "slot", function(...) return MrPlow:SlotSort(...) end)
	LibSort:Register("MrPlow", "Category", "Sort by Item Category", "category", function(...) return MrPlow:CategorySort(...) end)
	LibSort:Register("MrPlow", "Level", "Sort by Required Level", "level", function(...) return MrPlow:LevelSort(...) end)
	LibSort:Register("MrPlow", "PowerLevel", "Sort by Power Level", "powerlevel", function(...) return MrPlow:PowerLevelSort(...) end)
	LibSort:Register("MrPlow", "Name", "Sort by Name", "level", function(...) return MrPlow:NameSort(...) end)
	LibSort:Register("MrPlow", "Id", "Sort by Inventory Id", "id", function(...) return MrPlow:IdSort(...) end)

	LibSort:RegisterDefaultOrder("MrPlow", {"Family", "Slot", "Category"}, {"PowerLevel","Level", "Name", "Id"})

	self.LibSort = LibSort

	local GeminiLogging = Apollo.GetPackage("Gemini:Logging-1.2").tPackage
  	self.glog = GeminiLogging:GetLogger({
        level = GeminiLogging.DEBUG,
        pattern = "%d %n %c %l - %m",
        appender = "GeminiConsole"
  	})


end


-----------------------------------------------------------------------------------------------
-- MrPlow OnDocLoaded
-----------------------------------------------------------------------------------------------


function MrPlow:WindowManagementAdd(args)
	local inventory = self.inventory				
	local bank = self.bank 
	local gbank = self.gbank 

	if args.strName == Apollo.GetString("InterfaceMenu_Inventory") then 
			
		local prompt = self.inventory.wndMain:FindChild("ItemSortPrompt")

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
			inventory.wndMainBagWindow:SetSort(inventory.bShouldSortItems)			
			inventory.wndMainBagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
		end	
	end
	self.inventoryHooks = {}
	
	if args.strName == Apollo.GetString("Bank_Header") then 		
		bank.bagWindow = bank.wndMain:FindChild("MainBagWindow")

		-- Hook into the sort function to reflect it into the bank
		
		self.inventoryHooks.OnOptionsSortItemsOff = inventory.OnOptionsSortItemsOff
		inventory.OnOptionsSortItemsOff = 
			function(...)
				self.inventoryHooks.OnOptionsSortItemsOff(inventory, ...)
				bank.bagWindow:SetSort(false)
			end
		
		
		if inventory.nSortItemType == 4 and inventory.bShouldSortItems then
			bank.bagWindow:SetSort(inventory.bShouldSortItems)
			self:SortBank()	
		end
	end	
end


function MrPlow:SortBank()
	self.bank.bagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
end



--- Sorting Functions -----

---------------------------------------------------------------------------------------------------
-- IconBtnSortAll Functions
---------------------------------------------------------------------------------------------------
function MrPlow:OnOptionsSortItemsByAll( wndHandler, wndControl, eMouseButton )
	self.inventory.bShouldSortItems = true
	self.inventory.nSortItemType = 4
	self.inventory.wndMainBagWindow:SetSort(true)
	self.inventory.wndMainBagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
	self.inventory.wndIconBtnSortDropDown:SetCheck(false)
end

-----------------------------------------------------------------------------------------------
-- MrPlow Instance
-----------------------------------------------------------------------------------------------
SenorPlow = MrPlow:new()
SenorPlow:Init()
