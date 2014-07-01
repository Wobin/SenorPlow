local MrPlow = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("MrPlow")
local VikingInventoryModule = MrPlow:NewModule("VikingInventoryModule")
local Parent, Inventory, Bank

local tPixie = 	{ loc = { nOffsets = { 0, -144, 0, 0 }, fPoints = { 0, 1, 1, 1 }}, strSprite = "BK3:UI_BK3_Holo_InsetFlyout", cr = "white", crText = "black", }
									



function VikingInventoryModule:IsActive()
	return Inventory ~= nil
end

function VikingInventoryModule:OnEnable()
	Parent = self.Parent
	if Apollo.GetAddonInfo("VikingInventory").bRunning ~= 0 then self.inventory = Apollo.GetAddon("VikingInventory") end	
	Inventory = self.inventory 	

	if self:IsActive() then self:RestyleConfig() end
end

function VikingInventoryModule:RestyleConfig()

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
            Font = "CRB_Options", 
            Text = "Señor Plow Order Settings", 
            BGColor = "UI_WindowBGDefault", 
            TextColor = "UI_WindowTitleYellow", 
            Name = "Title", 
            DT_VCENTER = true, 
            DT_CENTER = true, 
        },
          {
            AnchorPoints= {1, 0, 1, 0},
            AnchorOffsets = { -25, -5, 5, 25 },
            Class = "Button", 
            Base = "BK3:btnHolo_Close", 
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
            Name = "CloseButton", 
            Events = {
                ButtonSignal = function(...) MrPlow.OptionsPanel:Show(false) end,
            },
        },
        {
            AnchorPoints = { 0, 0, 1, 0},
            AnchorOffsets = { 20, 30, -20, 60 },
            Class = "Button", 
            Base = "BK3:btnHolo_ListView_Simple", 
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
             Base = "BK3:btnHolo_ListView_Simple", 
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
            Base = "BK3:btnHolo_ListView_Simple", 
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
    TextColor = "UI_WindowTextDefault", 
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
            TextColor = "UI_WindowTitleYellow", 
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
    Base = "BK3:btnHolo_ListView_Simple", 
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

Parent.overButton = "CRB_PlayerPathSprites:btnPP_HologramBase"
Parent.outButton = "BK3:btnHolo_ListView_Simple"

SendVarToRover("tst", Parent)
end

function VikingInventoryModule:WindowManagementAdd(name, args)
	if Inventory and args.strName == Apollo.GetString("InterfaceMenu_Inventory") then 	
	
		local prompt = Inventory.wndMain:FindChild("ItemSortPrompt")	
		local a, b, c, d = prompt:GetAnchorOffsets()
		prompt:SetAnchorOffsets(a, b, c, d + 30)
		prompt:UpdatePixie(1, tPixie)

		for i,choice in ipairs(prompt:GetChildren()) do
			local a, b, c, d = choice:GetAnchorOffsets()
			choice:SetAnchorOffsets(a, b - 30, c, d - 30)
		end

		-- Make the existing bottom button a middle button
		Inventory.wndMain:FindChild("IconBtnSortQuality"):ChangeArt("BK3:btnHolo_ListView_Mid")
	
		-- Create our additional button and hook it in
		self.optionChoice = Parent:CreateSortOption("IconSortBtns", prompt, self, Inventory.wndMain:FindChild("OptionsContainer"))		
	
		self.optionChoice:SetAnchorOffsets(0, -32, 0, 0)	
		self.optionChoice:SetAnchorPoints(0, 1, 1, 1)
		
		

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

function VikingInventoryModule:ShouldSort()
	return Inventory.nSortItemType == 4 and Inventory.bShouldSortItems 
end

function VikingInventoryModule:OnOptionsSortItemsByAll(wndHandler, wndControl, eMouseButton )
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