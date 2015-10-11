local MrPlow = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("MrPlow")
local ForgeUIModule = MrPlow:NewModule("ForgeUIModule")
local Parent, Inventory, Bank, Preload = true
local HookedFunctions = {"OnOptionsSortItemsName", "OnOptionsSortItemsByCategory", "OnOptionsSortItemsByQuality", "OnOptionsSortItemsOff"}


local tPixie = 	{ loc = { nOffsets = { 0, -144, 0, 0 }, fPoints = { 0, 1, 1, 1 }}, strSprite = "BK3:UI_BK3_Holo_InsetFlyout", cr = "white", crText = "black", }


function ForgeUIModule:IsActive()
	return Inventory ~= nil
end

function ForgeUIModule:OnEnable()
	Parent = self.Parent
	Parent.glog:debug("on enable")
	if Apollo.GetAddonInfo("ForgeUI_Inventory") and Apollo.GetAddonInfo("ForgeUI_Inventory").bRunning ~= 0 then self.inventory = Apollo.GetAddon("ForgeUI_Inventory") end
	if Apollo.GetAddonInfo("BankViewer") and Apollo.GetAddonInfo("BankViewer").bRunning ~= 0 then self.bank = Apollo.GetAddon("BankViewer")  end	
	if not self.inventory then Parent.glog:debug("on disable") return self:Disable() end
	Inventory = self.inventory 	
	Bank = self.bank	
	if self:IsActive() then self:RestyleConfig() end
	-- proceeding with the load if the Carbine Inventory has already been loaded
	if not Preload then self:WindowManagementAdd("WindowManagementAddAfterLoad", {strName = Apollo.GetString("InterfaceMenu_Inventory")}) end
	end

function ForgeUIModule:OnDisable()
	 self:UnregisterEvent("WindowManagementAdd")
end

function ForgeUIModule:RestyleConfig()

Parent.tConfigDef = {
    AnchorPoints = {1, 0, 1, 0},
    AnchorOffsets = { -5, -5, 204, 140 },
    RelativeToClient = true, 
    BGColor = "UI_WindowBGDefault", 
    TextColor = "UI_WindowTextDefault", 
    Template = "OldMetalControl", 
    Name = "Config", 
    Border = true, 
    Picture = true, 
    SwallowMouseClicks = true, 
    Moveable = true, 
    Escapable = true, 
    Overlapped = false, 
    NoClip = true,
    Sprite = "ChatLogSprites:sprChatBackground", 
    Children = {
        {            
            AnchorOffsets = { 5, 5, -5, 25 },
            AnchorPoints = { 0, 0, 1, 0 },
            RelativeToClient = true, 
            Font = "Nameplates", 
            Text = "Señor Plow Order Settings", 
            BGColor = "UI_WindowBGDefault", 
            TextColor = "xkcdFireEngineRed", 
            Name = "Title", 
            DT_VCENTER = true, 
            DT_CENTER = true, 
        },
          {
            AnchorPoints= {1, 0, 1, 0},
            AnchorOffsets = { -25, -5, 5, 25 },
            Class = "Button", 
            Base = "BK3:btnHolo_Close", 
            Font = "Thick", 
            ButtonType = "PushButton", 
            DT_VCENTER = true, 
            DT_CENTER = true, 
            BGColor = "UI_BtnBGDefault", 
            TextColor = "UI_BtnTextDefault", 
            NormalTextColor = "UI_BtnTextDefault", 
            PressedTextColor = "UI_BtnTextDefault", 
            FlybyTextColor = "UI_BtnTextDefault", 
            PressedFlybyTextColor = "UI_BtnTextDefault", 
            DisabledTextColor = "UI_BtnTextDefault", 
            Name = "CloseButton", 
            Events = {
                ButtonSignal = function(...) MrPlow.OptionsPanel:Show(false) end,
            },
        },
        {
            AnchorPoints = { 0, 0, 1, 0},
            AnchorOffsets = { 20, 30, -20, 60 },
            Class = "Button", 
            Base = "ForgeUI_Button", 
            Font = "CRB_InterfaceSmall_O", 
            ButtonType = "PushButton", 
            DT_VCENTER = true, 
            DT_CENTER = true, 
            BGColor = "UI_BtnBGDefault", 
            TextColor = "UI_BtnTextDefault", 
            NormalTextColor = "UI_BtnTextDefault", 
            PressedTextColor = "UI_BtnTextDefault", 
            FlybyTextColor = "UI_BtnTextDefault", 
            PressedFlybyTextColor = "UI_BtnTextDefault", 
            DisabledTextColor = "UI_BtnTextDefault", 
            Name = "FamilyButton", 
            Text = "Family", 
            Events = {
                ButtonSignal = function(...) MrPlow:ShowFamilyOrder() end,
            },
        },
        {
            AnchorPoints = { 0, 0, 1, 0},
            AnchorOffsets = { 20, 60, -20, 90 },
            Class = "Button", 
             Base = "ForgeUI_Button", 
            Font = "CRB_InterfaceSmall_O", 
            ButtonType = "PushButton", 
            DT_VCENTER = true, 
            DT_CENTER = true, 
            BGColor = "UI_BtnBGDefault", 
            TextColor = "UI_BtnTextDefault", 
            NormalTextColor = "UI_BtnTextDefault", 
            PressedTextColor = "UI_BtnTextDefault", 
            FlybyTextColor = "UI_BtnTextDefault", 
            PressedFlybyTextColor = "UI_BtnTextDefault", 
            DisabledTextColor = "UI_BtnTextDefault", 
            Name = "CategoryButton", 
            TextId = "Inventory_SortCategory", 
            Events = {
                ButtonSignal = function(...) MrPlow:ShowCategoryOrder() end,
            },
        },
        {
            AnchorPoints = { 0, 0, 1, 0},
            AnchorOffsets = { 20, 90, -20, 120 },
            Class = "Button", 
            Base = "ForgeUI_Button", 
            Font = "CRB_InterfaceSmall_O", 
            ButtonType = "PushButton", 
            DT_VCENTER = true, 
            DT_CENTER = true, 
            BGColor = "UI_BtnBGDefault", 
            TextColor = "UI_BtnTextDefault", 
            NormalTextColor = "UI_BtnTextDefault", 
            PressedTextColor = "UI_BtnTextDefault", 
            FlybyTextColor = "UI_BtnTextDefault", 
            PressedFlybyTextColor = "UI_BtnTextDefault", 
            DisabledTextColor = "UI_BtnTextDefault", 
            Name = "SlotButton", 
            Text = "Slot", 
            Events = {
                ButtonSignal = function(...) MrPlow:ShowSlotOrder() end,
            },
        },
    },
}

Parent.tListFrameDef = {
    AnchorPoints = {0, 1, 0, 0},
    AnchorOffsets = { -5, -5, 205, 200},
    RelativeToClient = true, 
    BGColor = "UI_WindowBGDefault", 
    TextColor = "xkcdFireEngineRed", 
    Template = "OldMetalControl", 
    Name = "ListFrame", 
    Sprite = "ChatLogSprites:sprChatBackground", 
    Border = true, 
    Picture = true, 
    SwallowMouseClicks = true,     
    Moveable = true, 
    Escapable = true, 
    Overlapped = false, 
    NoClip = true,
    Children = {       
    	{
            AnchorPoints = {0, 0, 1, 1},
            AnchorOffsets = { 15, 35, -15, -15 },
            RelativeToClient = true, 
            BGColor = "UI_WindowBGDefault", 
            TextColor = "UI_WindowTextDefault", 
            VScroll = true,
            NoClip = true,
            Template = "Holo_List",
            Name = "ListWindow",             
        }, 
        {
            AnchorPoints = {0, 0, 1, 0},
            AnchorOffsets = { 0, 2, 0, 30 },            
            RelativeToClient = true, 
            BGColor = "UI_WindowBGDefault", 
            TextColor = "xkcdFireEngineRed", 
            Font = "CRB_Options",
            Name = "TitleText",                
            DT_VCENTER = true, 
            DT_CENTER = true, 
        },
    }
}

Parent.tListButtonDef =  {
    AnchorPoints = {0, 0, 1, 0},
    AnchorOffsets = { -2, 0, -10, 30 },
    WidgetType = "PushButton", 
    Base = "ForgeUI_Button", 
    Font = "CRB_Options", 
    ButtonType = "PushButton", 
    DT_VCENTER = true, 
    DT_CENTER = true, 
    BGColor = "UI_BtnBGDefault", 
    TextColor = "UI_BtnTextDefault", 
    NormalTextColor = "UI_BtnTextDefault", 
    PressedTextColor = "UI_BtnTextDefault", 
    FlybyTextColor = "UI_BtnTextDefault", 
    PressedFlybyTextColor = "UI_BtnTextDefault", 
    DisabledTextColor = "UI_BtnTextDefault", 
    Name = "Button", 
    Template = "CRB_Normal", 
    TextId = "FontAlias_Thick", 
    Events =  {            
        ButtonDown = function(...) MrPlow.BeginDragDrop(...) end,
        ButtonUpCancel = function(...) MrPlow.EndDragDrop(...) end,
        ButtonUp = function(...) MrPlow.EndDragDrop(...) end,
        MouseEnter = function(...) MrPlow.MouseEnter(...) end,
        MouseExit = function(...) MrPlow.MouseLeave(...) end,
    }
}
Parent.tIconBtnSortAllDef = {
    AnchorOffsets = { 16, 158, -16, 188 },
    AnchorPoints = {0,0,1,0},
    NoClip = true,
    Class = "Button", 
    Base = "ForgeUI_Button", 
    Font = "CRB_Button", 
    ButtonType = "Check", 
    RadioGroup = "IconSortBtns", 
    DT_VCENTER = true, 
    DT_CENTER = true, 
    BGColor = "white", 
    TextColor = "white", 
    NormalTextColor = "White", 
    PressedTextColor = "White", 
    FlybyTextColor = "White", 
    PressedFlybyTextColor = "White", 
    DisabledTextColor = "White", 
    Name = "IconBtnSortAll", 
    Border = true, 
    Picture = true, 
    Moveable = true, 
    Escapable = true, 
    Overlapped = true, 
    TextId = "CRB_MasterLoot_Filter_All", 
    RadioDisallowNonSelection = true,         
    Children = {
        {
            AnchorOffsets = { -22, 9, 6, 41 },
            AnchorPoints = "TOPRIGHT",
            Class = "Button", 
            Base = "CRB_Basekit:kitBtn_ScrollHolo_RightSmall", 
            Font = "DefaultButton", 
            ButtonType = "PushButton", 
            DT_VCENTER = true, 
            DT_CENTER = true, 
            BGColor = "UI_BtnBGDefault", 
            TextColor = "UI_BtnTextDefault", 
            NormalTextColor = "UI_BtnTextDefault", 
            PressedTextColor = "UI_BtnTextDefault", 
            FlybyTextColor = "UI_BtnTextDefault", 
            PressedFlybyTextColor = "UI_BtnTextDefault", 
            DisabledTextColor = "UI_BtnTextDefault", 
            Name = "ConfigButton", 
            RelativeToClient = true, 
            Picture = true, 
            Events = {
                ButtonDown = function() MrPlow:ShowConfig() end,
            },
        },
    },
}
Parent.overButton = "ForgeUI_Button"
Parent.outButton = "ForgeUI_Button"
end

function ForgeUIModule:WindowManagementAdd(name, args)	

	if not Inventory then Preload = false return end -- if the Carbine inventory loads before this module enable and recall it
	if Inventory and args.strName == Apollo.GetString("InterfaceMenu_Inventory") then 	
	
		local prompt = Inventory.wndMain:FindChild("ItemSortPrompt")	
		local a, b, c, d = prompt:GetAnchorOffsets()
		prompt:SetAnchorOffsets(a, b, c, d + 36)
		prompt:UpdatePixie(1, tPixie)

		-- Create our additional button and hook it in
		self.optionChoice = Parent:CreateSortOption("IconSortBtns", prompt, self, Inventory.wndMain:FindChild("OptionsContainer"))		
	
		self.optionChoice:SetAnchorOffsets(6, -38, -6, -8)	
		self.optionChoice:SetAnchorPoints(0, 1, 1, 1)


		if Inventory.tSettings.nSortItemType == 4 and Inventory.tSettings.bShouldSortItems then
			self.optionChoice:SetCheck(Inventory.tSettings.bShouldSortItems)
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

function ForgeUIModule:ShouldSort()
	return Inventory.tSettings.nSortItemType == 4 and Inventory.tSettings.bShouldSortItems 
end

function ForgeUIModule:OnOptionsSortItemsByAll(wndHandler, wndControl, eMouseButton )
	if Inventory then
		Inventory.tSettings.bShouldSortItems = true
		Inventory.tSettings.nSortItemType = 4
		Parent:SetSortOnBag(Inventory.wndMainBagWindow)		
		Inventory.wndIconBtnSortDropDown:SetCheck(false)
	end

	if Bank and Bank.bagWindow then
		Parent:SetSortOnBag(Bank.bagWindow)
	end
end