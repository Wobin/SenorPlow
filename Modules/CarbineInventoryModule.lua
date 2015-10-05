local MrPlow = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("MrPlow")
local CarbineInventoryModule = MrPlow:NewModule("CarbineInventoryModule")
local Parent, Inventory, Bank, Preload = true
local HookedFunctions = {"OnOptionsSortItemsName", "OnOptionsSortItemsByCategory", "OnOptionsSortItemsByQuality", "OnOptionsSortItemsOff"}


function CarbineInventoryModule:OnEnable()
	Parent = self.Parent
	Parent.glog:debug("on enable")
	if Apollo.GetAddonInfo("Inventory") and Apollo.GetAddonInfo("Inventory").bRunning ~= 0 then self.inventory = Apollo.GetAddon("Inventory") end
	if Apollo.GetAddonInfo("BankViewer") and Apollo.GetAddonInfo("BankViewer").bRunning ~= 0 then self.bank = Apollo.GetAddon("BankViewer")  end	
	if not self.inventory then Parent.glog:debug("on disable") return self:Disable() end
	Inventory = self.inventory 	
	Bank = self.bank	
	-- proceeding with the load if the Carbine Inventory has already been loaded
	if not Preload then self:WindowManagementAdd("WindowManagementAddAfterLoad", {strName = Apollo.GetString("InterfaceMenu_Inventory")}) end
end

function CarbineInventoryModule:OnDisable()
	 self:UnregisterEvent("WindowManagementAdd")
end

function CarbineInventoryModule:WindowManagementAdd(name, args)	

	if not Inventory then Preload = false return end -- if the Carbine inventory loads before this module enable and recall it
	if Inventory and args.strName == Apollo.GetString("InterfaceMenu_Inventory") then 	
	Parent.glog:debug(args.wnd and args.wnd:GetName())
		local prompt = Inventory.wndMain:FindChild("ItemSortPrompt")
		prompt:SetAnchorOffsets(-26, 9, 26, 205)
			
		-- Make the existing bottom button a middle button
		Inventory.wndMain:FindChild("IconBtnSortQuality"):ChangeArt("BK3:btnHolo_ListView_Mid")
	
		-- Create our additional button and hook it in
		self.optionChoice = Parent:CreateSortOption("IconSortBtns", prompt, self, Inventory.wndMain:FindChild("OptionsContainer"))		
	
		if Inventory.nSortItemType == 4 and Inventory.bShouldSortItems then
			self.optionChoice:SetCheck(Inventory.bShouldSortItems)
			Parent:SetSortOnBag(Inventory.wndMainBagWindow)
		end	
		for i, name in ipairs(HookedFunctions) do
			if not self:IsHooked(Inventory, name) then 
				self:PostHook(Inventory, name, function() Parent:CreateOptionPanel():Show(false) end)
			end
		end
		return
	end

	if Bank and args.strName == Apollo.GetString("Bank_Header") then 
		
		Bank.bagWindow = Bank.wndMain:FindChild("MainBagWindow")	
		-- Hook into the sort function to reflect it into the bank
		if not self:IsHooked(Inventory, "OnOptionsSortItemsOff") then
			self:PostHook(Inventory, "OnOptionsSortItemsOff", function() Parent:UnsetSortOnBag(Bank.bagWindow) end)
		end
		
		if self:ShouldSort() then		
			Parent:SetSortOnBag(Bank.bagWindow)
		end
	end
end

function CarbineInventoryModule:ShouldSort()
	return Inventory.nSortItemType == 4 and Inventory.bShouldSortItems 
end

function CarbineInventoryModule:OnOptionsSortItemsByAll(wndHandler, wndControl, eMouseButton )
	if Inventory then
		Inventory.bShouldSortItems = true
		Inventory.nSortItemType = 4
		Parent:SetSortOnBag(Inventory.wndMainBagWindow)		
		Inventory.wndIconBtnSortDropDown:SetCheck(false)
	end

	if Bank and Bank.bagWindow then
		Parent:SetSortOnBag(Bank.bagWindow)
	end
end