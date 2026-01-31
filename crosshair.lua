-- Crosshair Addon
local Crosshair = CreateFrame("Frame", "CrosshairFrame", UIParent)
Crosshair:SetFrameStrata("TOOLTIP")
Crosshair:SetAllPoints(UIParent)
Crosshair:EnableMouse(false)

-- Localization
local L = {}
local locale = GetLocale()

-- English Text (Standard)
L["TITLE"] = "Crosshair Settings"
L["SIZE_X"] = "Horizontal Size"
L["SIZE_Y"] = "Vertical Size"
L["THICKNESS"] = "Thickness"
L["COLOR"] = "Color"
L["ENABLE"] = "Enable Crosshair"
L["X_OFFSET"] = "X Offset"
L["Y_OFFSET"] = "Y Offset"
L["RESET_POSITION"] = "Reset Position"
L["POSITION"] = "Position"
L["NEW_ADDON_IDEAS"] = "New Addon Ideas?"
L["VISIT"] = "Visit"
L["COMBAT"] = "Show Only in Combat"
L["BORDER"] = "Enable Border"
L["BORDER_SIZE"] = "Border Size"
L["BORDER_COLOR"] = "Border Color"

-- German Text
if locale == "deDE" then
    L["TITLE"] = "Crosshair Einstellungen"
    L["SIZE_X"] = "Horizontale Größe"
    L["SIZE_Y"] = "Vertikale Größe"
    L["THICKNESS"] = "Dicke"
    L["COLOR"] = "Farbe"
    L["ENABLE"] = "Crosshair aktivieren"
    L["X_OFFSET"] = "X-Versatz"
    L["Y_OFFSET"] = "Y-Versatz"
    L["RESET_POSITION"] = "Position zurücksetzen"
    L["POSITION"] = "Position"
    L["NEW_ADDON_IDEAS"] = "Neue Addon-Ideen?"
    L["VISIT"] = "Besuche"
    L["COMBAT"] = "Nur im Kampf anzeigen"
    L["BORDER"] = "Rahmen aktivieren"
    L["BORDER_SIZE"] = "Rahmengröße"
    L["BORDER_COLOR"] = "Rahmenfarbe"
end

-- Spanish Text
if locale == "esES" or locale == "esMX" then
    L["TITLE"] = "Configuración de Mira"
    L["SIZE_X"] = "Tamaño Horizontal"
    L["SIZE_Y"] = "Tamaño Vertical"
    L["THICKNESS"] = "Espesor"
    L["COLOR"] = "Color"
    L["ENABLE"] = "Activar Mira"
    L["X_OFFSET"] = "Desplazamiento X"
    L["Y_OFFSET"] = "Desplazamiento Y"
    L["RESET_POSITION"] = "Restablecer Posición"
    L["POSITION"] = "Posición"
    L["NEW_ADDON_IDEAS"] = "¿Nuevas Ideas de Addon?"
    L["VISIT"] = "Visita"
    L["COMBAT"] = "Mostrar solo en combate"
    L["BORDER"] = "Activar Borde"
    L["BORDER_SIZE"] = "Tamaño del Borde"
    L["BORDER_COLOR"] = "Color del Borde"
end

-- French Text
if locale == "frFR" then
    L["TITLE"] = "Paramètres du Reticule"
    L["SIZE_X"] = "Taille Horizontale"
    L["SIZE_Y"] = "Taille Verticale"
    L["THICKNESS"] = "Épaisseur"
    L["COLOR"] = "Couleur"
    L["ENABLE"] = "Activer le Reticule"
    L["X_OFFSET"] = "Décalage X"
    L["Y_OFFSET"] = "Décalage Y"
    L["RESET_POSITION"] = "Réinitialiser la Position"
    L["POSITION"] = "Position"
    L["NEW_ADDON_IDEAS"] = "Nouvelles Idées d'Addon?"
    L["VISIT"] = "Visitez"
    L["COMBAT"] = "Afficher uniquement en combat"
    L["BORDER"] = "Activer la Bordure"
    L["BORDER_SIZE"] = "Taille de la Bordure"
    L["BORDER_COLOR"] = "Couleur de la Bordure"
end

-- Standard settings
local defaults = {
    sizeX = 20,
    sizeY = 20,
    color = {r = 0, g = 1, b = 0, a = 1}, -- Green
    enabled = true,
    offsetX = 0,
    offsetY = 0,
    thickness = 1,
    combat = false,
    borderEnabled = false,
    borderSize = 1,
    borderColor = {r = 0, g = 0, b = 0, a = 1} -- Black
}

-- Initialize database
CrosshairDB = CrosshairDB or {}
for k, v in pairs(defaults) do
    if CrosshairDB[k] == nil then
        CrosshairDB[k] = v
    elseif type(v) == "table" then
        -- Ensure nested table has all default keys
        for subKey, subValue in pairs(v) do
            if CrosshairDB[k][subKey] == nil then
                CrosshairDB[k][subKey] = subValue
            end
        end
    end
end

-- Container frame for the crosshair (for moving)
local crosshairContainer = CreateFrame("Frame", "CrosshairContainer", UIParent)
crosshairContainer:SetFrameStrata("TOOLTIP")
crosshairContainer:SetSize(1, 1)
crosshairContainer:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
crosshairContainer:EnableMouse(false)
crosshairContainer:SetMovable(true)

-- Border textures for horizontal line (created first so they appear behind)
local horizontalBorderTop = crosshairContainer:CreateTexture(nil, "BORDER", nil, 0)
horizontalBorderTop:SetTexture("Interface\\Buttons\\WHITE8X8")

local horizontalBorderBottom = crosshairContainer:CreateTexture(nil, "BORDER", nil, 0)
horizontalBorderBottom:SetTexture("Interface\\Buttons\\WHITE8X8")

local horizontalBorderLeft = crosshairContainer:CreateTexture(nil, "BORDER", nil, 0)
horizontalBorderLeft:SetTexture("Interface\\Buttons\\WHITE8X8")

local horizontalBorderRight = crosshairContainer:CreateTexture(nil, "BORDER", nil, 0)
horizontalBorderRight:SetTexture("Interface\\Buttons\\WHITE8X8")

-- Border textures for vertical line
local verticalBorderTop = crosshairContainer:CreateTexture(nil, "BORDER", nil, 0)
verticalBorderTop:SetTexture("Interface\\Buttons\\WHITE8X8")

local verticalBorderBottom = crosshairContainer:CreateTexture(nil, "BORDER", nil, 0)
verticalBorderBottom:SetTexture("Interface\\Buttons\\WHITE8X8")

local verticalBorderLeft = crosshairContainer:CreateTexture(nil, "BORDER", nil, 0)
verticalBorderLeft:SetTexture("Interface\\Buttons\\WHITE8X8")

local verticalBorderRight = crosshairContainer:CreateTexture(nil, "BORDER", nil, 0)
verticalBorderRight:SetTexture("Interface\\Buttons\\WHITE8X8")

-- Horizontal line (higher sublevel to appear on top of borders)
local horizontalLine = crosshairContainer:CreateTexture(nil, "OVERLAY", nil, 1)
horizontalLine:SetTexture("Interface\\Buttons\\WHITE8X8")
horizontalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)

-- Vertical line
local verticalLine = crosshairContainer:CreateTexture(nil, "OVERLAY", nil, 1)
verticalLine:SetTexture("Interface\\Buttons\\WHITE8X8")
verticalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)

-- Function to hide all border textures
local function HideBorders()
    horizontalBorderTop:Hide()
    horizontalBorderBottom:Hide()
    horizontalBorderLeft:Hide()
    horizontalBorderRight:Hide()
    verticalBorderTop:Hide()
    verticalBorderBottom:Hide()
    verticalBorderLeft:Hide()
    verticalBorderRight:Hide()
end

-- Function to show all border textures
local function ShowBorders()
    horizontalBorderTop:Show()
    horizontalBorderBottom:Show()
    horizontalBorderLeft:Show()
    horizontalBorderRight:Show()
    verticalBorderTop:Show()
    verticalBorderBottom:Show()
    verticalBorderLeft:Show()
    verticalBorderRight:Show()
end

-- Function to update the crosshair
local function UpdateCrosshair()
    if not CrosshairDB.enabled then
        horizontalLine:Hide()
        verticalLine:Hide()
        HideBorders()
        crosshairContainer:EnableMouse(false)
        return
    end

    horizontalLine:Show()
    verticalLine:Show()

    -- Support legacy 'size' setting by converting to sizeX/sizeY
    if CrosshairDB.size and not CrosshairDB.sizeX then
        CrosshairDB.sizeX = CrosshairDB.size
        CrosshairDB.sizeY = CrosshairDB.size
    end

    local sizeX = CrosshairDB.sizeX or 20
    local sizeY = CrosshairDB.sizeY or 20
    local thickness = CrosshairDB.thickness or 1
    local borderSize = CrosshairDB.borderSize or 1

    -- Container Position aktualisieren
    crosshairContainer:ClearAllPoints()
    crosshairContainer:SetPoint("CENTER", UIParent, "CENTER", CrosshairDB.offsetX or 0, CrosshairDB.offsetY or 0)

    -- Horizontal line
    local hWidth = sizeX * 2
    local hHeight = thickness * 2
    horizontalLine:SetSize(hWidth, hHeight)
    horizontalLine:ClearAllPoints()
    horizontalLine:SetPoint("CENTER", crosshairContainer, "CENTER", 0, 0)

    -- Vertical line
    local vWidth = thickness * 2
    local vHeight = sizeY * 2
    verticalLine:SetSize(vWidth, vHeight)
    verticalLine:ClearAllPoints()
    verticalLine:SetPoint("CENTER", crosshairContainer, "CENTER", 0, 0)

    -- Update main color
    horizontalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)
    verticalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)

    -- Update borders
    if CrosshairDB.borderEnabled then
        local bc = CrosshairDB.borderColor or {r = 0, g = 0, b = 0, a = 1}

        -- Horizontal line borders
        horizontalBorderTop:ClearAllPoints()
        horizontalBorderTop:SetSize(hWidth + borderSize * 2, borderSize)
        horizontalBorderTop:SetPoint("BOTTOMLEFT", horizontalLine, "TOPLEFT", -borderSize, 0)
        horizontalBorderTop:SetVertexColor(bc.r, bc.g, bc.b, bc.a)

        horizontalBorderBottom:ClearAllPoints()
        horizontalBorderBottom:SetSize(hWidth + borderSize * 2, borderSize)
        horizontalBorderBottom:SetPoint("TOPLEFT", horizontalLine, "BOTTOMLEFT", -borderSize, 0)
        horizontalBorderBottom:SetVertexColor(bc.r, bc.g, bc.b, bc.a)

        horizontalBorderLeft:ClearAllPoints()
        horizontalBorderLeft:SetSize(borderSize, hHeight)
        horizontalBorderLeft:SetPoint("TOPRIGHT", horizontalLine, "TOPLEFT", 0, 0)
        horizontalBorderLeft:SetVertexColor(bc.r, bc.g, bc.b, bc.a)

        horizontalBorderRight:ClearAllPoints()
        horizontalBorderRight:SetSize(borderSize, hHeight)
        horizontalBorderRight:SetPoint("TOPLEFT", horizontalLine, "TOPRIGHT", 0, 0)
        horizontalBorderRight:SetVertexColor(bc.r, bc.g, bc.b, bc.a)

        -- Vertical line borders
        verticalBorderTop:ClearAllPoints()
        verticalBorderTop:SetSize(vWidth + borderSize * 2, borderSize)
        verticalBorderTop:SetPoint("BOTTOMLEFT", verticalLine, "TOPLEFT", -borderSize, 0)
        verticalBorderTop:SetVertexColor(bc.r, bc.g, bc.b, bc.a)

        verticalBorderBottom:ClearAllPoints()
        verticalBorderBottom:SetSize(vWidth + borderSize * 2, borderSize)
        verticalBorderBottom:SetPoint("TOPLEFT", verticalLine, "BOTTOMLEFT", -borderSize, 0)
        verticalBorderBottom:SetVertexColor(bc.r, bc.g, bc.b, bc.a)

        verticalBorderLeft:ClearAllPoints()
        verticalBorderLeft:SetSize(borderSize, vHeight)
        verticalBorderLeft:SetPoint("TOPRIGHT", verticalLine, "TOPLEFT", 0, 0)
        verticalBorderLeft:SetVertexColor(bc.r, bc.g, bc.b, bc.a)

        verticalBorderRight:ClearAllPoints()
        verticalBorderRight:SetSize(borderSize, vHeight)
        verticalBorderRight:SetPoint("TOPLEFT", verticalLine, "TOPRIGHT", 0, 0)
        verticalBorderRight:SetVertexColor(bc.r, bc.g, bc.b, bc.a)

        ShowBorders()
    else
        HideBorders()
    end

    if CrosshairDB.combat then
        horizontalLine:Hide()
        verticalLine:Hide()
        HideBorders()
    end
end

local function CombatStart()
    if CrosshairDB.combat and CrosshairDB.enabled then
        horizontalLine:Show()
        verticalLine:Show()
        if CrosshairDB.borderEnabled then
            ShowBorders()
        end
    end
end

local function CombatEnd()
    if CrosshairDB.combat then
        horizontalLine:Hide()
        verticalLine:Hide()
        HideBorders()
    end
end

-- Initialization
Crosshair:RegisterEvent("PLAYER_LOGIN")
Crosshair:RegisterEvent("ADDON_LOADED")
Crosshair:RegisterEvent("DISPLAY_SIZE_CHANGED")
Crosshair:RegisterEvent("PLAYER_REGEN_DISABLED")
Crosshair:RegisterEvent("PLAYER_REGEN_ENABLED")

-- Create configuration window
local configFrame = nil

local function CreateConfigFrame()
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

-- Event Handler
Crosshair:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "crosshair" then
        UpdateCrosshair()
    elseif event == "PLAYER_LOGIN" then
        UpdateCrosshair()
        CreateConfigFrame() -- Frame erstellen
    elseif event == "DISPLAY_SIZE_CHANGED" then
        UpdateCrosshair()
    elseif event == "PLAYER_REGEN_DISABLED" then
        CombatStart()
    elseif event == "PLAYER_REGEN_ENABLED" then
        CombatEnd()
    end
end)

-- Slash Command
SLASH_CROSSHAIR1 = "/crosshair"
SLASH_CROSSHAIR2 = "/ch"
SlashCmdList["CROSSHAIR"] = function(msg)
    if not configFrame then
        CreateConfigFrame()
    end

    if configFrame:IsVisible() then
        configFrame:Hide()
    else
        configFrame:Show()
    end
end
