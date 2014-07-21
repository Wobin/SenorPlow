local MrPlow = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("MrPlow")
local GeminiGUI = Apollo.GetPackage("Gemini:GUI-1.0").tPackage

MrPlow.tListFrameDef = {
    AnchorPoints = {0, 1, 1, 0},
    AnchorOffsets = { -40, 0, 38, 285},
    RelativeToClient = true, 
    BGColor = "UI_WindowBGDefault", 
    TextColor = "UI_WindowTextDefault", 
    Template = "Holo_Large", 
    Name = "ListFrame", 
    Sprite = "BK3:UI_BK3_Holo_Framing_3_Blocker", 
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
            AnchorOffsets = { 5, 35, -10, -15 },
            RelativeToClient = true, 
            BGColor = "UI_WindowBGDefault", 
            TextColor = "UI_WindowTextDefault", 
            VScroll = true,
            NoClip = true,
            Template = "Holo_List",
            Name = "ListWindow",             
        }, 
        {
            AnchorOffsets = { 0, 2, 270, 30 },            
            RelativeToClient = true, 
            BGColor = "UI_WindowBGDefault", 
            TextColor = "UI_WindowTextDefault", 
            Font = "CRB_HeaderLarge",
            Name = "TitleText",                
            DT_VCENTER = true, 
            DT_CENTER = true, 
        },
    }
}

local tButtonExpand = {
    AnchorOffsets = { 10, 10, 26, 28},
    RelativeToClient = true
}
MrPlow.tListButtonDef =  {
    AnchorOffsets = { -2, 0, 210, 30 },
    WidgetType = "PushButton", 
    Base = "CRB_PlayerPathSprites:btnPP_BaseGrey", 
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

local tIconBtnSortAllDef = {
    AnchorOffsets = { 41, 158, -41, 188 },
    AnchorPoints = "HFILL",
    NoClip = true,
    Class = "Button", 
    Base = "BK3:btnHolo_ListView_Btm", 
    Font = "CRB_Button", 
    ButtonType = "Check", 
    RadioGroup = "IconSortBtns", 
    DT_VCENTER = true, 
    DT_CENTER = true, 
    BGColor = "white", 
    TextColor = "white", 
    NormalTextColor = "UI_BtnTextHoloNormal", 
    PressedTextColor = "UI_BtnTextHoloPressed", 
    FlybyTextColor = "UI_BtnTextHoloFlyby", 
    PressedFlybyTextColor = "UI_BtnTextHoloPressedFlyby", 
    DisabledTextColor = "UI_BtnTextHoloDisabled", 
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
  
MrPlow.tConfigDef = {
    AnchorPoints = {1, 0, 1,0},
    AnchorOffsets = { -15, -10, 310, 260 },
    RelativeToClient = true, 
    BGColor = "UI_WindowBGDefault", 
    TextColor = "UI_WindowTextDefault", 
    Template = "Holo_Large", 
    Name = "Config", 
    Border = true, 
    Picture = true, 
    SwallowMouseClicks = true, 
    Moveable = true, 
    Escapable = true, 
    Overlapped = false, 
    NoClip = true,
    Sprite = "BK3:UI_BK3_Holo_Framing_3_Blocker", 
    Children = {
        {            
            AnchorOffsets = { 1, 0, 210, 30 },
            RelativeToClient = true, 
            Font = "CRB_HeaderLarge", 
            Text = "Señor Plow Order Settings", 
            BGColor = "UI_WindowBGDefault", 
            TextColor = "UI_WindowTextDefault", 
            Name = "Title", 
            DT_VCENTER = true, 
            DT_CENTER = true, 
        },
          {
            AnchorPoints= {1, 0, 1, 0},
            AnchorOffsets = { -30, 0, 0, 30 },
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
            AnchorOffsets = { 20, 40, 235, 78 },
            Class = "Button", 
            Base = "CRB_Basekit:kitBtn_Holo", 
            Font = "CRB_Interface11_BBO", 
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
            AnchorOffsets = { 20, 80, 235, 118 },
            Class = "Button", 
            Base = "CRB_Basekit:kitBtn_Holo", 
            Font = "CRB_Interface11_BBO", 
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
            AnchorOffsets = { 20, 120, 235, 160 },
            Class = "Button", 
            Base = "CRB_Basekit:kitBtn_Holo", 
            Font = "CRB_Interface11_BBO", 
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



local FAMILY = MrPlow.Lookups.Family.Base 
local FAMILYNAMES = MrPlow.Lookups.Family.Names
local FAMILYDUPES = MrPlow.Lookups.Family.Dupes
local FAMILYORDER = MrPlow.Lookups.Family.Order 
local CATEGORY = MrPlow.Lookups.Category.Base 
local CATEGORYDUPES = MrPlow.Lookups.Category.Dupes
local CATEGORYORDER = MrPlow.Lookups.Category.Order 
local SLOT = MrPlow.Lookups.Slot.Base
local glog = MrPlow.glog 

function MrPlow:ShowConfig()    
    self:CreateOptionPanel():Show(not self.OptionsPanel:IsShown())
end

function MrPlow:CreateSortOption(radioGroup, parent, target, alongSide, buttonDefinition, buttonReference)
    local tButton = GeminiGUI:Create(tIconBtnSortAllDef)
    if not buttonReference then buttonReference = self.SortOptionButton end
    tButton:SetOption("RadioGroup", radioGroup)
    tButton:AddEvent("ButtonCheck", function(...) target:OnOptionsSortItemsByAll(...) end)
    buttonReference = tButton:GetInstance(self, parent)
    self.alongSide = alongSide
    return buttonReference
end

function MrPlow:CreateOptionPanel()
    if not self.OptionsPanel then         
        self.OptionsPanel = GeminiGUI:Create(MrPlow.tConfigDef):GetInstance(MrPlow, self.alongSide)      
        self.OptionsPanel:Show(false)
    end    
    return self.OptionsPanel
end

function MrPlow:CreateBaseFrame()
    local tWindow = GeminiGUI:Create(MrPlow.tListFrameDef)
    self.List = tWindow:GetInstance(MrPlow, self.OptionsPanel)
end

function MrPlow:CreateListOfButtons(group)
    if not self.List then self:CreateBaseFrame() end

    local tButton = GeminiGUI:Create(MrPlow.tListButtonDef)

    local listWindow = self.List:FindChild("ListWindow")
    
    self.List:FindChild("TitleText"):SetText(group.Title)

    listWindow:DestroyChildren()

    listWindow:SetData({group = group, self = listWindow})

    for name, rank in pairs(group.Order) do
        tButton:SetData({rank = rank, groupId = name, name = group.Names[name]})
        local but = tButton:GetInstance(MrPlow, listWindow)
        but:SetText(group.Names[name])            
    end

    local extraHeight = (13 * 32) - 60
    
    local offx1, offy1, offx2, offy2 = self.List:GetAnchorOffsets()
    self.List:SetAnchorOffsets(offx1, offy1, offx2, 285 + extraHeight)
    
    self:RerankList(listWindow)
    
    self.List:Show(true)
end

function MrPlow:ShowFamilyOrder()
    self:CreateListOfButtons(MrPlow.Lookups.Family)
end

function MrPlow:ShowCategoryOrder()
    self:CreateListOfButtons(MrPlow.Lookups.Category)
end

function MrPlow:ShowSlotOrder()
    self:CreateListOfButtons(MrPlow.Lookups.Slot)
end

function MrPlow:RerankList(list)
    list:ArrangeChildrenVert(0, function(a,b) return a:GetData().rank < b:GetData().rank end)
end

local lastUp
MrPlow.overButton = "CRB_PlayerPathSprites:btnPP_HologramBase"
MrPlow.outButton = "CRB_PlayerPathSprites:btnPP_BaseGrey"


------ Mouse functions ----

function MrPlow:BeginDragDrop(...)
    local wndHandler, wndControl, button = ...
    if wndHandler ~= wndControl then return end
    self.CurrentDDButton = wndHandler
    self.CurrentDDButton:SetBGOpacity(0.2)    
    Sound.Play(Sound.PlayUIMemoryStart)
    lastUp = nil
end
 

function MrPlow:EndDragDrop(...)
    local wndHandler, wndControl = ...
    if wndHandler ~= wndControl or wndControl == lastUp then return end    
    
    lastUp = wndControl
        
    self:ReorderTable(wndControl:GetParent():GetData(), wndControl:GetData(), self.LastButtonOver:GetData())

    self.CurrentDDButton:SetBGOpacity(1)    
    Sound.Play(Sound.PlayUIMemoryStart)
end

function MrPlow:MouseEnter(...)
    local wndControl = ...
    self.LastButtonOver = wndControl
    wndControl:ChangeArt(MrPlow.overButton)
end

function MrPlow:MouseLeave(...)
    local wndControl = ...
    wndControl:ChangeArt(MrPlow.outButton)
end

---- Reordering functions ----

function MrPlow:ReorderTable(list, itemA, itemB)
    list.group.OrderLookup = {}
    
    -- Generate the current order listing
    for name, rank in pairs(list.group.Order) do list.group.OrderLookup[rank] = name end

    -- Remove and insert the drag/dropped item into it's new position
    table.insert(list.group.OrderLookup, itemB.rank, table.remove(list.group.OrderLookup,itemA.rank))

    -- First re-set the order in the Order table
    for i,v in ipairs(list.group.OrderLookup) do
        list.group.Order[v] = i 
    end
    
    -- Now update the rank listing in the children
    for i,v in ipairs(list.self:GetChildren()) do
        local data = v:GetData()
        data.rank = list.group.Order[data.groupId]
    end

    -- And shake it all about
    self:RerankList(list.self)

    -- also resort the stuff in inventory/bank
    for name, mod in self:IterateModules() do
        if type(mod.OnOptionsSortItemsByAll) == "function" then
           mod:OnOptionsSortItemsByAll()
        end
    end
end