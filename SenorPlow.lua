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

local MrPlow = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon(MrPlow, "MrPlow", bHasConfigureFunction, tDependencies, "Gemini:Hook-1.0")


local prototype = {
	Connect = function(parent) self.Parent = parent return self end
	OnInitialize = function() self:RegisterEvent("WindowManagementAdd") end
}
-----------------------------------------------------------------------------------------------
-- MrPlow OnInitialize
-----------------------------------------------------------------------------------------------
function MrPlow:OnInitialize()	
    -- Set up our modules
	LibSort = Apollo.GetPackage("Wob:LibSort-1.0").tPackage
	self.GeminiGUI = Apollo.GetPackage("Gemini:GUI-1.0").tPackage

	self:SetDefaultModuleLibraries("Gemini:Hook-1.0", "Gemini:Event-1.0")
	self:SetDefaultModulePrototype(prototype)

	self.LibSort = LibSort

	local CarbineInventoryModule = self:GetModule("CarbineInventoryModule"):Connect(self)
	local CarbineBankModule = self:GetModule("CarbineBankModule"):Connect(self)

	-- Check if Inventory is loaded
	
	
		
	Apollo.RegisterEventHandler("WindowManagementAdd", "WindowManagementAdd", self)
	
	-- Space Stash integration
	if Apollo.GetAddonInfo("SpaceStashCore") and Apollo.GetAddonInfo("SpaceStashCore").bRunning ~= 0 then self.spaceStashCore = Apollo.GetAddon("SpaceStashCore") end
	if Apollo.GetAddonInfo("SpaceStashInventory") and Apollo.GetAddonInfo("SpaceStashInventory").bRunning ~= 0 then self.spaceStashInventory = Apollo.GetAddon("SpaceStashInventory") end
	if Apollo.GetAddonInfo("SpaceStashBank") and Apollo.GetAddonInfo("SpaceStashBank").bRunning ~= 0 then self.spaceStashBank = Apollo.GetAddon("SpaceStashBank") end
	Apollo.RegisterEventHandler("SpaceStashCore_OpenOptions", "SpaceStashCore_OpenOptions", self)
	
	
	-- Extend our dropdown		
	LibSort:Register("MrPlow", "Family", "Sort by Item Family", "family", function(...) return MrPlow:FamilySort(...) end)
	LibSort:Register("MrPlow", "Slot", "Sort by Item Slot", "slot", function(...) return MrPlow:SlotSort(...) end)
	LibSort:Register("MrPlow", "Category", "Sort by Item Category", "category", function(...) return MrPlow:CategorySort(...) end)
	LibSort:Register("MrPlow", "Level", "Sort by Required Level", "level", function(...) return MrPlow:LevelSort(...) end)
	LibSort:Register("MrPlow", "PowerLevel", "Sort by Power Level", "powerlevel", function(...) return MrPlow:PowerLevelSort(...) end)
	LibSort:Register("MrPlow", "Name", "Sort by Name", "level", function(...) return MrPlow:NameSort(...) end)
	LibSort:Register("MrPlow", "Id", "Sort by Inventory Id", "id", function(...) return MrPlow:IdSort(...) end)

	LibSort:RegisterDefaultOrder("MrPlow", {"Family", "Slot", "Category"}, {"PowerLevel", "Level", "Name", "Id"})

	
	local GeminiLogging = Apollo.GetPackage("Gemini:Logging-1.2").tPackage
  	self.glog = GeminiLogging:GetLogger({
        level = GeminiLogging.DEBUG,
        pattern = "%d %n %c %l - %m",
        appender = "GeminiConsole"
  	})
  	self.glog:debug("loaded mrplow")
  	-- Default sort order
	self.config = {
		Lookups = { Family = MrPlow.Lookups.Family.Order,
					Category = MrPlow.Lookups.Category.Order,
					Slot = MrPlow.Lookups.Slot.Order
		}
	}
  	
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


--- API ---

function MrPlow:GetSortFunction()
	return function(...) LibSort:Comparer(...) end
end



function MrPlow:WindowManagementAdd(args)
	local inventory = self.inventory				
	local bank = self.bank 
	local gbank = self.gbank 

---- Space Stash ----------------
	if args.strName == "SpaceStashInventory" then 
		-- We'll assume the options panel is created too
		local prompt = self.spaceStashCore.SSISortChooserButton:FindChild("ChoiceContainer")
		local a,b,c,d = prompt:GetAnchorOffsets()
		prompt:SetAnchorOffsets(a,b,c, d + 27)
		local bottom = self.spaceStashCore.SSISortChooserButton:FindChild("Choice4")
		self.spaceStashCore.bottom = bottom
		self.spaceStashCore.prompt = prompt
		self.wndMain = self:CreateSortOption("SSCGR1OPT3", prompt)
		a,b,c,d = self.wndMain:GetAnchorOffsets()
		self.wndMain:SetAnchorOffsets(a + 2, b +11, c - 2, d + 11)
		bottom:ChangeArt("BK3:btnHolo_ListView_Mid")

		if self.spaceStashCore.db.profile.config.auto.inventory.sort == 4 then
			self.spaceStashInventory:SetSortMehtod(function(...) return LibSort:Comparer(...) end)
			self.spaceStashCore.SSISortChooserButton:SetText("All")
			self.wndMain:SetCheck(true)
		end
		return
	end

	if args.strName == "SpaceStashBank" then
		-- Now we're loaded, set the 4th option to be our sort
		if self.spaceStashCore.db.profile.config.auto.inventory.sort == 4 then
			self.spaceStashBank.wndBankFrame:FindChild("BankWindow"):SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
			self.spaceStashBank.wndBankFrame:FindChild("BankWindow"):SetSort(true)					
		end
		-- And hook the clear option
		self:PostHook(self.spaceStashCore, "OnInventorySortSelected", 
			function(...)
				local wndHandler = ...
				if wndHandler:GetName() == "Choice1" then 
					self.spaceStashBank.wndBank:FindChild("BankWindow"):SetItemSortComparer(nil)
					self.spaceStashBank.wndBank:FindChild("BankWindow"):SetSort(false)
				end
			end)				
		return
	end		

------ Carbine Inventory -------------
	if args.strName == Apollo.GetString("InterfaceMenu_Inventory") then 
			
		local prompt = self.inventory.wndMain:FindChild("ItemSortPrompt")

		prompt:SetAnchorOffsets(-26, 9, 26, 205)
		
		-- Make the existing bottom button a middle button
		inventory.wndMain:FindChild("IconBtnSortQuality"):ChangeArt("BK3:btnHolo_ListView_Mid")

		-- Create our additional button and hook it in
		self.wndMain = MrPlow:CreateSortOption("IconSortBtns", prompt)
		self.wndForm = Apollo.LoadForm(self.xmlDoc2, "MrPlowForm", nil , self)
		
		if self.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end

		local config = self.wndMain:FindChild("ConfigButton")

		if inventory.nSortItemType == 4 and inventory.bShouldSortItems then
			self.wndMain:SetCheck(inventory.bShouldSortItems)
			inventory.wndMainBagWindow:SetSort(inventory.bShouldSortItems)			
			inventory.wndMainBagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
		end	
	end

------ Carbine Bank -------------
	if args.strName == Apollo.GetString("Bank_Header") then 				
		bank.bagWindow = bank.wndMain:FindChild("MainBagWindow")

		-- Hook into the sort function to reflect it into the bank
		self:PostHook(inventory, "OnOptionsSortItemsOff", function() bank.bagWindow:SetSort(false) end)
				
		if inventory.nSortItemType == 4 and inventory.bShouldSortItems then
			bank.bagWindow:SetSort(inventory.bShouldSortItems)
			self:SortBank()	
		end
	end	
end


function MrPlow:SortBank()
	if self.bank and self.bank.bagWindow then
		self.bank.bagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
	end
	if self.spaceStashBank then
		self.spaceStashBank.wndBankFrame:FindChild("BankWindow"):SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
	end
end


function MrPlow:SortInventory()
	if self.inventory then
		self.inventory.wndMainBagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
	end
	if self.spaceStashInventory then
		self.spaceStashInventory:SetSortMehtod(function(...) return LibSort:Comparer(...) end)
	end
end


--- Sorting Functions -----

---------------------------------------------------------------------------------------------------
-- IconBtnSortAll Functions
---------------------------------------------------------------------------------------------------
function MrPlow:OnOptionsSortItemsByAll( wndHandler, wndControl, eMouseButton )
	
	if self.inventory then
		self.inventory.bShouldSortItems = true
		self.inventory.nSortItemType = 4
		self.inventory.wndMainBagWindow:SetSort(true)
		self.inventory.wndMainBagWindow:SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
		self.inventory.wndIconBtnSortDropDown:SetCheck(false)
	end

	if self.spaceStashCore then
		self.spaceStashCore.db.profile.config.auto.inventory.sort = 4
		self.spaceStashCore.SSISortChooserButton:SetText(wndHandler:GetText())		
    	self.spaceStashCore.SSISortChooserButton:FindChild("ChoiceContainer"):Show(false,true)
	end

	if self.spaceStashInventory then		
		self.spaceStashInventory:SetSortMehtod(function(...) return LibSort:Comparer(...) end)
	end

	if self.spaceStashBank then
		self.spaceStashBank.wndBankFrame:FindChild("BankWindow"):SetItemSortComparer(function(...) return LibSort:Comparer(...) end)
		self.spaceStashBank.wndBankFrame:FindChild("BankWindow"):SetSort(true)
	end
end