CrosshairDB = _G.CrosshairDB
L = CrosshairLocale

-- Create configuration window
local configFrame = nil

function CreateConfigFrame()
    if configFrame then
        return configFrame
    end

    local frame = CreateFrame("Frame", "CrosshairConfigFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(600, 600)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetFrameStrata("DIALOG")
    frame:Hide()

    -- Titel
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)
    frame.title:SetText(L["TITLE"])

    local panel = CreateFrame("Frame", nil, frame)
    panel:SetAllPoints(frame)
    panel:SetPoint("TOPLEFT", 10, -30)
    panel:SetPoint("BOTTOMRIGHT", -10, 10)

    -- Horizontal Size Label
    local sizeXLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sizeXLabel:SetPoint("TOPLEFT", 20, -60)
    sizeXLabel:SetText(L["SIZE_X"] .. ":")

    -- Horizontal Size Slider
    local sizeXSlider = CreateFrame("Slider", "CrosshairFrameSizeXSlider", panel, "OptionsSliderTemplate")
    sizeXSlider:SetPoint("TOPLEFT", sizeXLabel, "BOTTOMLEFT", 0, -10)
    sizeXSlider:SetMinMaxValues(5, 100)
    sizeXSlider:SetValue(CrosshairDB.sizeX or 20)
    sizeXSlider:SetValueStep(1)
    sizeXSlider:SetObeyStepOnDrag(true)
    getglobal(sizeXSlider:GetName() .. "Low"):SetText("5")
    getglobal(sizeXSlider:GetName() .. "High"):SetText("100")
    getglobal(sizeXSlider:GetName() .. "Text"):SetText(L["SIZE_X"] .. ": " .. (CrosshairDB.sizeX or 20))

    sizeXSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.sizeX = value
        getglobal(self:GetName() .. "Text"):SetText(L["SIZE_X"] .. ": " .. value)
        UpdateCrosshair()
    end)

    -- Vertical Size Label
    local sizeYLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sizeYLabel:SetPoint("TOPLEFT", sizeXSlider, "BOTTOMLEFT", 0, -25)
    sizeYLabel:SetText(L["SIZE_Y"] .. ":")

    -- Vertical Size Slider
    local sizeYSlider = CreateFrame("Slider", "CrosshairFrameSizeYSlider", panel, "OptionsSliderTemplate")
    sizeYSlider:SetPoint("TOPLEFT", sizeYLabel, "BOTTOMLEFT", 0, -10)
    sizeYSlider:SetMinMaxValues(5, 100)
    sizeYSlider:SetValue(CrosshairDB.sizeY or 20)
    sizeYSlider:SetValueStep(1)
    sizeYSlider:SetObeyStepOnDrag(true)
    getglobal(sizeYSlider:GetName() .. "Low"):SetText("5")
    getglobal(sizeYSlider:GetName() .. "High"):SetText("100")
    getglobal(sizeYSlider:GetName() .. "Text"):SetText(L["SIZE_Y"] .. ": " .. (CrosshairDB.sizeY or 20))

    sizeYSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.sizeY = value
        getglobal(self:GetName() .. "Text"):SetText(L["SIZE_Y"] .. ": " .. value)
        UpdateCrosshair()
    end)

    -- Thickness Label
    local thicknessLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    thicknessLabel:SetPoint("TOPLEFT", sizeYSlider, "BOTTOMLEFT", 0, -25)
    thicknessLabel:SetText(L["THICKNESS"] .. ":")

    -- Thickness Slider
    local thicknessSlider = CreateFrame("Slider", "CrosshairFrameThicknessSlider", panel, "OptionsSliderTemplate")
    thicknessSlider:SetPoint("TOPLEFT", thicknessLabel, "BOTTOMLEFT", 0, -10)
    thicknessSlider:SetMinMaxValues(1, 100)
    thicknessSlider:SetValue(CrosshairDB.thickness or 1)
    thicknessSlider:SetValueStep(1)
    thicknessSlider:SetObeyStepOnDrag(true)
    getglobal(thicknessSlider:GetName() .. "Low"):SetText("1")
    getglobal(thicknessSlider:GetName() .. "High"):SetText("100")
    getglobal(thicknessSlider:GetName() .. "Text"):SetText(L["THICKNESS"] .. ": " .. (CrosshairDB.thickness or 1))

    thicknessSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.thickness = value
        getglobal(self:GetName() .. "Text"):SetText(L["THICKNESS"] .. ": " .. value)
        UpdateCrosshair()
    end)

    -- Color Label
    local colorLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    colorLabel:SetPoint("TOPLEFT", thicknessSlider, "BOTTOMLEFT", 0, -25)
    colorLabel:SetText(L["COLOR"] .. ":")

    -- Color Picker Button
    local colorButton = CreateFrame("Button", "CrosshairColorButton", panel, "BackdropTemplate")
    colorButton:SetSize(32, 32)
    colorButton:SetPoint("TOPLEFT", colorLabel, "BOTTOMLEFT", 0, -5)
    colorButton:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 2,
    })
    colorButton:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    local colorSwatch = colorButton:CreateTexture(nil, "BACKGROUND")
    colorSwatch:SetPoint("TOPLEFT", 2, -2)
    colorSwatch:SetPoint("BOTTOMRIGHT", -2, 2)
    colorSwatch:SetColorTexture(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b)

    colorButton:SetScript("OnClick", function()
        local prevR, prevG, prevB = CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b

        local function ColorCallback()
            local newR, newG, newB = ColorPickerFrame:GetColorRGB()
            CrosshairDB.color.r = newR
            CrosshairDB.color.g = newG
            CrosshairDB.color.b = newB
            colorSwatch:SetColorTexture(newR, newG, newB)
            UpdateCrosshair()
        end

        local function CancelCallback()
            CrosshairDB.color.r = prevR
            CrosshairDB.color.g = prevG
            CrosshairDB.color.b = prevB
            colorSwatch:SetColorTexture(prevR, prevG, prevB)
            UpdateCrosshair()
        end

        ColorPickerFrame:SetupColorPickerAndShow({
            r = prevR,
            g = prevG,
            b = prevB,
            swatchFunc = ColorCallback,
            cancelFunc = CancelCallback,
        })
    end)

    -- Border Checkbox
    local borderCheckbox = CreateFrame("CheckButton", "CrosshairFrameBorderCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    borderCheckbox:SetPoint("TOPLEFT", colorButton, "BOTTOMLEFT", 0, -15)
    borderCheckbox:SetChecked(CrosshairDB.borderEnabled or false)
    getglobal(borderCheckbox:GetName() .. "Text"):SetText(L["BORDER"])

    borderCheckbox:SetScript("OnClick", function(self)
        CrosshairDB.borderEnabled = self:GetChecked()
        UpdateCrosshair()
    end)

    -- Border Size Label
    local borderSizeLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    borderSizeLabel:SetPoint("TOPLEFT", borderCheckbox, "BOTTOMLEFT", 0, -10)
    borderSizeLabel:SetText(L["BORDER_SIZE"] .. ":")

    -- Border Size Slider
    local borderSizeSlider = CreateFrame("Slider", "CrosshairFrameBorderSizeSlider", panel, "OptionsSliderTemplate")
    borderSizeSlider:SetPoint("TOPLEFT", borderSizeLabel, "BOTTOMLEFT", 0, -10)
    borderSizeSlider:SetMinMaxValues(1, 20)
    borderSizeSlider:SetValue(CrosshairDB.borderSize or 1)
    borderSizeSlider:SetValueStep(1)
    borderSizeSlider:SetObeyStepOnDrag(true)
    getglobal(borderSizeSlider:GetName() .. "Low"):SetText("1")
    getglobal(borderSizeSlider:GetName() .. "High"):SetText("20")
    getglobal(borderSizeSlider:GetName() .. "Text"):SetText(L["BORDER_SIZE"] .. ": " .. (CrosshairDB.borderSize or 1))

    borderSizeSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.borderSize = value
        getglobal(self:GetName() .. "Text"):SetText(L["BORDER_SIZE"] .. ": " .. value)
        UpdateCrosshair()
    end)

    -- Border Color Label
    local borderColorLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    borderColorLabel:SetPoint("TOPLEFT", borderSizeSlider, "BOTTOMLEFT", 0, -25)
    borderColorLabel:SetText(L["BORDER_COLOR"] .. ":")

    -- Border Color Picker Button
    local borderColorButton = CreateFrame("Button", "CrosshairBorderColorButton", panel, "BackdropTemplate")
    borderColorButton:SetSize(32, 32)
    borderColorButton:SetPoint("TOPLEFT", borderColorLabel, "BOTTOMLEFT", 0, -5)
    borderColorButton:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 2,
    })
    borderColorButton:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    local borderColorSwatch = borderColorButton:CreateTexture(nil, "BACKGROUND")
    borderColorSwatch:SetPoint("TOPLEFT", 2, -2)
    borderColorSwatch:SetPoint("BOTTOMRIGHT", -2, 2)
    local bc = CrosshairDB.borderColor or {r = 0, g = 0, b = 0}
    borderColorSwatch:SetColorTexture(bc.r, bc.g, bc.b)

    borderColorButton:SetScript("OnClick", function()
        local bCol = CrosshairDB.borderColor or {r = 0, g = 0, b = 0}
        local prevR, prevG, prevB = bCol.r, bCol.g, bCol.b

        local function BorderColorCallback()
            local newR, newG, newB = ColorPickerFrame:GetColorRGB()
            CrosshairDB.borderColor = CrosshairDB.borderColor or {}
            CrosshairDB.borderColor.r = newR
            CrosshairDB.borderColor.g = newG
            CrosshairDB.borderColor.b = newB
            CrosshairDB.borderColor.a = 1
            borderColorSwatch:SetColorTexture(newR, newG, newB)
            UpdateCrosshair()
        end

        local function BorderCancelCallback()
            CrosshairDB.borderColor = CrosshairDB.borderColor or {}
            CrosshairDB.borderColor.r = prevR
            CrosshairDB.borderColor.g = prevG
            CrosshairDB.borderColor.b = prevB
            CrosshairDB.borderColor.a = 1
            borderColorSwatch:SetColorTexture(prevR, prevG, prevB)
            UpdateCrosshair()
        end

        ColorPickerFrame:SetupColorPickerAndShow({
            r = prevR,
            g = prevG,
            b = prevB,
            swatchFunc = BorderColorCallback,
            cancelFunc = BorderCancelCallback,
        })
    end)

    -- On/Off checkbox
    local checkbox = CreateFrame("CheckButton", "CrosshairFrameEnabledCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", borderColorButton, "BOTTOMLEFT", 0, -15)
    checkbox:SetChecked(CrosshairDB.enabled)
    getglobal(checkbox:GetName() .. "Text"):SetText(L["ENABLE"])

    checkbox:SetScript("OnClick", function(self)
        CrosshairDB.enabled = self:GetChecked()
        UpdateCrosshair()
    end)

    -- On/Off checkbox in Combat Only
    local combatCheckbox = CreateFrame("CheckButton", "CrosshairFrameEnabledCombatCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    combatCheckbox:SetPoint("TOPLEFT", checkbox, "BOTTOMLEFT", 0, -5)
    combatCheckbox:SetChecked(CrosshairDB.combat or false)
    getglobal(combatCheckbox:GetName() .. "Text"):SetText(L["COMBAT"])

    combatCheckbox:SetScript("OnClick", function(self)
        CrosshairDB.combat = self:GetChecked()
        UpdateCrosshair()
    end)

    -- Position Label (right side)
    local positionLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    positionLabel:SetPoint("TOPRIGHT", -20, -60)
    positionLabel:SetText(L["POSITION"] .. ":")

    -- X-offset label
    local xOffsetLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    xOffsetLabel:SetPoint("TOPRIGHT", positionLabel, "BOTTOMRIGHT", 0, -10)
    xOffsetLabel:SetText(L["X_OFFSET"] .. ":")

    -- X-offset slider (create first)
    local xOffsetSlider = CreateFrame("Slider", "CrosshairFrameXOffsetSlider", panel, "OptionsSliderTemplate")
    xOffsetSlider:SetPoint("TOPRIGHT", xOffsetLabel, "BOTTOMRIGHT", 0, -10)
    xOffsetSlider:SetMinMaxValues(-500, 500)
    xOffsetSlider:SetValue(CrosshairDB.offsetX or 0)
    xOffsetSlider:SetValueStep(1)
    xOffsetSlider:SetObeyStepOnDrag(true)
    getglobal(xOffsetSlider:GetName() .. "Low"):SetText("-500")
    getglobal(xOffsetSlider:GetName() .. "High"):SetText("500")
    getglobal(xOffsetSlider:GetName() .. "Text"):SetText(L["X_OFFSET"])

    -- X-offset input field
    local xOffsetEditBox = CreateFrame("EditBox", "CrosshairXOffsetEditBox", panel, "InputBoxTemplate")
    xOffsetEditBox:SetSize(60, 20)
    xOffsetEditBox:SetPoint("TOPRIGHT", xOffsetSlider, "BOTTOMRIGHT", -10, -5)
    xOffsetEditBox:SetAutoFocus(false)
    xOffsetEditBox:SetText(tostring(CrosshairDB.offsetX or 0))

    xOffsetEditBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            value = math.max(-500, math.min(500, math.floor(value)))
            self:SetText(tostring(value))
            CrosshairDB.offsetX = value
            xOffsetSlider:SetValue(value)
            UpdateCrosshair()
        else
            self:SetText(tostring(CrosshairDB.offsetX or 0))
        end
        self:ClearFocus()
    end)

    xOffsetEditBox:SetScript("OnEscapePressed", function(self)
        self:SetText(tostring(CrosshairDB.offsetX or 0))
        self:ClearFocus()
    end)

    xOffsetSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.offsetX = value
        xOffsetEditBox:SetText(tostring(value))
        UpdateCrosshair()
    end)

    -- Y-offset label
    local yOffsetLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    yOffsetLabel:SetPoint("TOPRIGHT", xOffsetEditBox, "BOTTOMRIGHT", 0, -20)
    yOffsetLabel:SetText(L["Y_OFFSET"] .. ":")

    -- Y-offset slider (create first)
    local yOffsetSlider = CreateFrame("Slider", "CrosshairFrameYOffsetSlider", panel, "OptionsSliderTemplate")
    yOffsetSlider:SetPoint("TOPRIGHT", yOffsetLabel, "BOTTOMRIGHT", 0, -10)
    yOffsetSlider:SetMinMaxValues(-500, 500)
    yOffsetSlider:SetValue(CrosshairDB.offsetY or 0)
    yOffsetSlider:SetValueStep(1)
    yOffsetSlider:SetObeyStepOnDrag(true)
    getglobal(yOffsetSlider:GetName() .. "Low"):SetText("-500")
    getglobal(yOffsetSlider:GetName() .. "High"):SetText("500")
    getglobal(yOffsetSlider:GetName() .. "Text"):SetText(L["Y_OFFSET"])

    -- Y-offset input field
    local yOffsetEditBox = CreateFrame("EditBox", "CrosshairYOffsetEditBox", panel, "InputBoxTemplate")
    yOffsetEditBox:SetSize(60, 20)
    yOffsetEditBox:SetPoint("TOPRIGHT", yOffsetSlider, "BOTTOMRIGHT", -10, -5)
    yOffsetEditBox:SetAutoFocus(false)
    yOffsetEditBox:SetText(tostring(CrosshairDB.offsetY or 0))

    yOffsetEditBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            value = math.max(-500, math.min(500, math.floor(value)))
            self:SetText(tostring(value))
            CrosshairDB.offsetY = value
            yOffsetSlider:SetValue(value)
            UpdateCrosshair()
        else
            self:SetText(tostring(CrosshairDB.offsetY or 0))
        end
        self:ClearFocus()
    end)

    yOffsetEditBox:SetScript("OnEscapePressed", function(self)
        self:SetText(tostring(CrosshairDB.offsetY or 0))
        self:ClearFocus()
    end)

    yOffsetSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.offsetY = value
        yOffsetEditBox:SetText(tostring(value))
        UpdateCrosshair()
    end)

    -- Frame Strata Label
    local strataLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    strataLabel:SetPoint("TOPLEFT", 15, 0)
    strataLabel:SetText(L["STRATA"] .. ":")

    -- Dropdown for Frame Strata
    local strataDefs = {
        {"BACKGROUND", L["STRATA_BACKGROUND"]},
        {"LOW", L["STRATA_LOW"]},
        {"MEDIUM", L["STRATA_MEDIUM"]},
        {"HIGH", L["STRATA_HIGH"]},
        {"DIALOG", L["STRATA_DIALOG"]},
        {"FULLSCREEN", L["STRATA_FULLSCREEN"]},
        {"FULLSCREEN_DIALOG", L["STRATA_FULLSCREEN_DIALOG"]},
        {"TOOLTIP", L["STRATA_TOOLTIP"]},
    }

    local strataDropdown = CreateFrame("Frame", "CrosshairFrameStrataDropdown", panel, "UIDropDownMenuTemplate")
    strataDropdown:SetPoint("TOPLEFT", strataLabel, "BOTTOMLEFT", -15, -5)
    UIDropDownMenu_SetWidth(strataDropdown, 160)

    local function strataDropdown_OnClick(self)
        UIDropDownMenu_SetSelectedID(strataDropdown, self:GetID())
        CrosshairDB.strata = strataDefs[self:GetID()][1]
        UpdateCrosshair()
    end

    local function strataDropdown_Initialize(self, level)
        local selected
        for i, def in ipairs(strataDefs) do
            local api_strata, display_name = def[1], def[2]
            local info = UIDropDownMenu_CreateInfo()
            info.text = display_name
            info.value = api_strata
            info.func = strataDropdown_OnClick
            info.checked = (CrosshairDB.strata == api_strata)
            UIDropDownMenu_AddButton(info)
            if CrosshairDB.strata == api_strata then
                selected = i
            end
        end
        UIDropDownMenu_SetSelectedID(strataDropdown, selected or 7) -- Default to TOOLTIP if not set
        UIDropDownMenu_SetText(strataDropdown, strataDefs[selected or 8][2])
    end

    strataDropdown.initialize = strataDropdown_Initialize
    strataDropdown:SetScript("OnShow", function(self)
        UIDropDownMenu_Initialize(self, strataDropdown_Initialize)
    end)
    UIDropDownMenu_Initialize(strataDropdown, strataDropdown_Initialize)
    local selected = 8
    for i, def in ipairs(strataDefs) do
        if CrosshairDB.strata == def[1] then selected = i break end
    end
    UIDropDownMenu_SetSelectedID(strataDropdown, selected)
    UIDropDownMenu_SetText(strataDropdown, strataDefs[selected][2])

    -- Reset position button
    local resetButton = CreateFrame("Button", "CrosshairResetPositionButton", panel, "UIPanelButtonTemplate")
    resetButton:SetSize(150, 25)
    resetButton:SetPoint("TOPRIGHT", yOffsetSlider, "BOTTOMRIGHT", 0, -30)
    resetButton:SetText(L["RESET_POSITION"])

    resetButton:SetScript("OnClick", function()
        CrosshairDB.offsetX = 0
        CrosshairDB.offsetY = 0
        xOffsetSlider:SetValue(0)
        yOffsetSlider:SetValue(0)
        xOffsetEditBox:SetText("0")
        yOffsetEditBox:SetText("0")
        UpdateCrosshair()
    end)

    configFrame = frame
    return frame
end

-- Slash Command
SLASH_CROSSHAIR1 = "/crosshair"
SLASH_CROSSHAIR2 = "/ch"
SlashCmdList["CROSSHAIR"] = function(msg)
    if not configFrame then
        configFrame = CreateConfigFrame()
    end

    if configFrame:IsVisible() then
        configFrame:Hide()
    else
        configFrame:Show()
    end
end
