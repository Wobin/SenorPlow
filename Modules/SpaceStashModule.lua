local MrPlow = Apollo.GetAddon("SeñorPlow")
local SpaceStashModule = MrPlow:NewModule("SpaceStashModule")
local Parent, Inventory, Bank 

function SpaceStashModule:OnInitialize()
	self:RegisterEvent("AddonFullyLoaded")
end

function SpaceStashModule:OnEnable()
	if Apollo.GetAddonInfo("SpaceStashCore") and Apollo.GetAddonInfo("SpaceStashCore").bRunning ~= 0 then self.spaceStashCore = Apollo.GetAddon("SpaceStashCore") end
	if Apollo.GetAddonInfo("SpaceStashInventory") and Apollo.GetAddonInfo("SpaceStashInventory").bRunning ~= 0 then self.spaceStashInventory = Apollo.GetAddon("SpaceStashInventory") end
	if Apollo.GetAddonInfo("SpaceStashBank") and Apollo.GetAddonInfo("SpaceStashBank").bRunning ~= 0 then self.spaceStashBank = Apollo.GetAddon("SpaceStashBank") end
	Parent = self.Parent	
	
	if not self.spaceStashCore then return self:Disable() end
end

function SpaceStashModule:OnDisable()
	 self:UnregisterEvent("WindowManagementAdd")
end

function SpaceStashModule:AddonFullyLoaded(name, args)
	
	if args.strName == "SpaceStashCore" then 
		-- moving the settings panel slightly to the right
		Parent.tConfigDef.AnchorOffsets = { 20, 5, 345, 255 }
		
		-- We'll assume the options panel is created too
		-- Find the dropdown
		local prompt = self.spaceStashCore.SSISortChooserButton:FindChild("ChoiceContainer")
		local a,b,c,d = prompt:GetAnchorOffsets()

		-- Extend it slightly to jam in our button
		prompt:SetAnchorOffsets(a,b,c, d + 22)
		local bottom = self.spaceStashCore.SSISortChooserButton:FindChild("Choice4")
		
		-- Change the current bottom image to a middle button visual		
		bottom:ChangeArt("BK3:btnHolo_ListView_Mid")
		

		-- Insert our button
		self.optionChoice = Parent:CreateSortOption("SSCGR1OPT3", prompt, self, self.spaceStashCore.wndMain, self.optionChoice)
		a,b,c,d = self.optionChoice:GetAnchorOffsets()
		self.optionChoice:SetAnchorOffsets(a + 2, b + 6, c - 2, d + 6)
		self.optionChoice:SetAnchorPoints(0, 0, 1, 0)

		-- Reattach the exbottom button to the previous one.
		a,b,c,d = self.optionChoice:GetAnchorOffsets()
		bottom:SetAnchorPoints(0, 0, 1, 0)
		bottom:SetAnchorOffsets(a, b - 28, c, d - 28)


		
		-- handle Bank options
		prompt = self.spaceStashCore.SSBSortChooserButton:FindChild("ChoiceContainer")
		a,b,c,d = prompt:GetAnchorOffsets()

		-- Extend it slightly to jam in our button
		prompt:SetAnchorOffsets(a,b,c, d + 22)
		bottom = self.spaceStashCore.SSBSortChooserButton:FindChild("Choice4")
		
		-- Change the current bottom image to a middle button visual		
		bottom:ChangeArt("BK3:btnHolo_ListView_Mid")
		

		-- Insert our button
		self.optionBChoice = Parent:CreateSortOption("SSCGR1OPT3", prompt, self, self.spaceStashCore.wndMain, self.optionBChoice)
		a,b,c,d = self.optionBChoice:GetAnchorOffsets()
		self.optionBChoice:SetAnchorOffsets(a + 2, b + 6, c - 2, d + 6)
		self.optionBChoice:SetAnchorPoints(0, 0, 1, 0)

		-- Reattach the exbottom button to the previous one.
		a,b,c,d = self.optionBChoice:GetAnchorOffsets()
		bottom:SetAnchorPoints(0, 0, 1, 0)
		bottom:SetAnchorOffsets(a, b - 28, c, d - 28)

		-- Now set the button to choose/highlight 'All' if it's been set previously
		if self.spaceStashCore.db.profile.config.auto.inventory.sort == 4 then
			self.spaceStashCore.SSISortChooserButton:SetText("All")
			self.optionChoice:SetCheck(true)
		end
		if self.spaceStashCore.db.profile.config.auto.bank.sort == 4 then			
			self.spaceStashCore.SSBSortChooserButton:SetText("All")
			self.optionBChoice:SetCheck(true)
		end
		return	
	end

	if args.strName == "SpaceStashInventory" then
		-- If we're set to sort all from a previous choice, then sort it
		if self.spaceStashCore.db.profile.config.auto.inventory.sort == 4 then
			self.spaceStashInventory:SetSortMehtod(function(...) return Parent.LibSort:Comparer("MrPlow", ...) end)		
		end
		return 
	end
	
	if args.strName == "SpaceStashBank" then
			-- If we're set to sort all from a previous choice, then sort it
		if self.spaceStashCore.db.profile.config.auto.bank.sort == 4 then			
			self.spaceStashBank:SetSortMehtod(function(...) return Parent.LibSort:Comparer("MrPlow", ...) end)
		end
		return
	end
end

function SpaceStashModule:OnOptionsSortItemsByAll(wndHandler, wndControl, eMouseButton )
	if self.spaceStashCore then		
		if self.spaceStashCore.SSISortChooserButton:IsVisible() and wndControl then
			self.spaceStashCore.db.profile.config.auto.inventory.sort = 4
			self.spaceStashCore.SSISortChooserButton:SetText("All")		
    		self.spaceStashCore.SSISortChooserButton:FindChild("ChoiceContainer"):Show(false,true)
    	end

    	if self.spaceStashCore.db.profile.config.auto.inventory.sort == 4 then
			self.spaceStashInventory:SetSortMehtod(function(...) return Parent.LibSort:Comparer("MrPlow",...) end)
    	end
    	
    	if self.spaceStashCore.SSBSortChooserButton:IsVisible() and wndControl then
			self.spaceStashCore.db.profile.config.auto.bank.sort = 4
			self.spaceStashCore.SSBSortChooserButton:SetText("All")		
    		self.spaceStashCore.SSBSortChooserButton:FindChild("ChoiceContainer"):Show(false,true)
    	end

    	if self.spaceStashCore.db.profile.config.auto.bank.sort == 4 then
			self.spaceStashBank:SetSortMehtod(function(...) return Parent.LibSort:Comparer("MrPlow",...) end)
    	end

		if wndControl then wndControl:SetCheck(true) end
	end
end