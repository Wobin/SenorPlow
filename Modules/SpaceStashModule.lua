local SpaceStashModule = MrPlow:NewModule("SpaceStashModule")
local Parent, Inventory, Bank 

function SpaceStashModule:OnEnable()
	if Apollo.GetAddonInfo("SpaceStashCore") and Apollo.GetAddonInfo("SpaceStashCore").bRunning ~= 0 then self.spaceStashCore = Apollo.GetAddon("SpaceStashCore") end
	if Apollo.GetAddonInfo("SpaceStashInventory") and Apollo.GetAddonInfo("SpaceStashInventory").bRunning ~= 0 then self.spaceStashInventory = Apollo.GetAddon("SpaceStashInventory") end
	if Apollo.GetAddonInfo("SpaceStashBank") and Apollo.GetAddonInfo("SpaceStashBank").bRunning ~= 0 then self.spaceStashBank = Apollo.GetAddon("SpaceStashBank") end
	Parent = self.Parent
end

function SpaceStashModule:WindowManagementAdd(name, args)
	
	if args.strName == "SpaceStashInventory" then 
		-- We'll assume the options panel is created too
		-- Find the dropdown
		local prompt = self.spaceStashCore.SSISortChooserButton:FindChild("ChoiceContainer")
		local a,b,c,d = prompt:GetAnchorOffsets()

		-- Extend it slightly to jam in our button
		prompt:SetAnchorOffsets(a,b,c, d + 27)
		local bottom = self.spaceStashCore.SSISortChooserButton:FindChild("Choice4")
		self.spaceStashCore.bottom = bottom
		self.spaceStashCore.prompt = prompt

		-- Change the current bottom image to a middle button visual		
		bottom:ChangeArt("BK3:btnHolo_ListView_Mid")
		
		-- Insert our button
		self.optionChoice = Parent:CreateSortOption("SSCGR1OPT3", prompt, self, self.spaceStashCore.SSIOptionsFrame)
		a,b,c,d = self.optionChoice:GetAnchorOffsets()
		self.optionChoice:SetAnchorOffsets(a + 2, b +11, c - 2, d + 11)
		
		-- If we're set to sort all from a previous choice, then sort it
		if self.spaceStashCore.db.profile.config.auto.inventory.sort == 4 then
			self.spaceStashInventory:SetSortMehtod(function(...) return Parent.LibSort:Comparer(...) end)
			self.spaceStashCore.SSISortChooserButton:SetText("All")
			self.optionChoice:SetCheck(true)
		end
		return
	end

	if args.strName == "SpaceStashBank" then
		-- Now we're loaded, set the 4th option to be our sort
		if self.spaceStashCore.db.profile.config.auto.inventory.sort == 4 then
			Parent:SetSortOnBag(self.spaceStashBank.wndBankFrame:FindChild("BankWindow"))			
		end
		-- And hook the clear option
		self:PostHook(self.spaceStashCore, "OnInventorySortSelected", 
			function(...)
				local wndHandler, wndControl = ...
				if wndControl:GetName() == "Choice1" then 
					Parent:UnsetSortOnBag(self.spaceStashBank.wndBank:FindChild("BankWindow"))
				end
			end)				
		return
	end			
end

function SpaceStashModule:OnOptionsSortItemsByAll(wndHandler, wndControl, eMouseButton )
	if self.spaceStashCore then
		self.spaceStashCore.db.profile.config.auto.inventory.sort = 4
		self.spaceStashCore.SSISortChooserButton:SetText("All")		
		self.optionChoice:SetCheck(true)
    	self.spaceStashCore.SSISortChooserButton:FindChild("ChoiceContainer"):Show(false,true)
	end

	if self.spaceStashInventory then		
		self.spaceStashInventory:SetSortMehtod(function(...) return Parent.LibSort:Comparer(...) end)
	end

	if self.spaceStashBank then
		Parent:SetSortOnBag(self.spaceStashBank.wndBankFrame:FindChild("BankWindow"))
	end
end