local CarbineBankModule = MrPlow:NewModule("CarbineBankModule")
local Parent

function CarbineBankModule:OnEnable()
	Parent = self.Parent
	if Apollo.GetAddonInfo("BankViewer").bRunning ~= 0 then Parent.bank = Apollo.GetAddon("BankViewer")  end	
end

function CarbineBankModule:WindowManagementAdd(name, args)
	if args.strName = Apollo.GetString("Bank_Header") then return end
	Parent.bank.bagWindow = bank.wndMain:FindChild("MainBagWindow")

	-- Hook into the sort function to reflect it into the bank
	self:PostHook(inventory, "OnOptionsSortItemsOff", function() Parent.bank.bagWindow:SetSort(false) end)
				
	if Parent.inventory.nSortItemType == 4 and Parent.inventory.bShouldSortItems then
		Parent.bank.bagWindow:SetSort(inventory.bShouldSortItems)
		Parent.bank.bagWindow:SetItemSortComparer(Parent:GetSortFunction())
	end
end