local CarbineInventoryModule = MrPlow:NewModule("CarbineInventoryModule")
local Parent

function CarbineInventoryModule:OnEnable()
	Parent = self.Parent
	if Apollo.GetAddonInfo("Inventory").bRunning ~= 0 then Parent.inventory = Apollo.GetAddon("Inventory") end
end

function CarbineInventoryModule:WindowManagementAdd(name, args)
	if args.strName = Apollo.GetString("InterfaceMenu_Inventory") then return end
	local prompt = Parent.inventory.wndMain:FindChild("ItemSortPrompt")

		prompt:SetAnchorOffsets(-26, 9, 26, 205)
		
		-- Make the existing bottom button a middle button
		Parent.inventory.wndMain:FindChild("IconBtnSortQuality"):ChangeArt("BK3:btnHolo_ListView_Mid")

		-- Create our additional button and hook it in
		Parent.wndMain = Parent:CreateSortOption("IconSortBtns", prompt)		
		
		if Parent.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end

		local config = Parent.wndMain:FindChild("ConfigButton")

		if Parent.inventory.nSortItemType == 4 and Parent.inventory.bShouldSortItems then
			Parent.wndMain:SetCheck(Parent.inventory.bShouldSortItems)
			Parent.inventory.wndMainBagWindow:SetSort(Parent.inventory.bShouldSortItems)			
			Parent.inventory.wndMainBagWindow:SetItemSortComparer(Parent:GetSortFunction())
		end	
end