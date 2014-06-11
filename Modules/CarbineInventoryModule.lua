local CarbineInventoryModule = MrPlow:NewModule("CarbineInventoryModule")
local Parent, Inventory, Bank

function CarbineInventoryModule:OnEnable()
	Parent = self.Parent
	if Apollo.GetAddonInfo("Inventory").bRunning ~= 0 then self.inventory = Apollo.GetAddon("Inventory") end
	if Apollo.GetAddonInfo("BankViewer").bRunning ~= 0 then self.bank = Apollo.GetAddon("BankViewer")  end	
	Inventory = self.inventory 
	Bank = self.bank
end

function CarbineInventoryModule:WindowManagementAdd(name, args)
	if args.strName == Apollo.GetString("InterfaceMenu_Inventory") then 	
	
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
		return
	end

	if args.strName == Apollo.GetString("Bank_Header") then 
		
		Bank.bagWindow = Bank.wndMain:FindChild("MainBagWindow")	
		-- Hook into the sort function to reflect it into the bank
		if not self:IsHooked(Inventory, "OnOptionsSortItemsOff") then
			self:PostHook(Inventory, "OnOptionsSortItemsOff", function() Parent:UnsetSortOnBag(Bank.bagWindow) end)
		end
		
		if self:ShouldSort() then		
			Parent.glog:debug("in bank")	
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