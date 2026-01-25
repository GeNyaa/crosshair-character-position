-- Crosshair Addon
local Crosshair = CreateFrame("Frame", "CrosshairFrame", UIParent)
Crosshair:SetFrameStrata("TOOLTIP")
Crosshair:SetAllPoints(UIParent)
Crosshair:EnableMouse(false)

-- Lokalisierung
local L = {}
local locale = GetLocale()

-- English Text (Standard)
L["TITLE"] = "Crosshair Settings"
L["SIZE_X"] = "Horizontal Size"
L["SIZE_Y"] = "Vertical Size"
L["THICKNESS"] = "Thickness"
L["COLOR"] = "Color"
L["RED"] = "Red"
L["GREEN"] = "Green"
L["BLUE"] = "Blue"
L["ENABLE"] = "Enable Crosshair"
L["X_OFFSET"] = "X Offset"
L["Y_OFFSET"] = "Y Offset"
L["RESET_POSITION"] = "Reset Position"
L["POSITION"] = "Position"
L["NEW_ADDON_IDEAS"] = "New Addon Ideas?"
L["VISIT"] = "Visit"
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
    L["RED"] = "Rot"
    L["GREEN"] = "Grün"
    L["BLUE"] = "Blau"
    L["ENABLE"] = "Crosshair aktivieren"
    L["X_OFFSET"] = "X-Versatz"
    L["Y_OFFSET"] = "Y-Versatz"
    L["RESET_POSITION"] = "Position zurücksetzen"
    L["POSITION"] = "Position"
    L["NEW_ADDON_IDEAS"] = "Neue Addon-Ideen?"
    L["VISIT"] = "Besuche"
    L["BORDER"] = "Rahmen aktivieren"
    L["BORDER_SIZE"] = "Rahmengröße"
    L["BORDER_COLOR"] = "Rahmenfarbe"
end

-- Spanish Text
if locale == "esES" or locale == "esMX" then
    L["TITLE"] = "Configuración de Mira"
    L["SIZE_X"] = "Tamaño Horizontal"
    L["SIZE_Y"] = "Tamaño Vertical"
    L["THICKNESS"] = "Grosor"
    L["COLOR"] = "Color"
    L["RED"] = "Rojo"
    L["GREEN"] = "Verde"
    L["BLUE"] = "Azul"
    L["ENABLE"] = "Activar Mira"
    L["X_OFFSET"] = "Desplazamiento X"
    L["Y_OFFSET"] = "Desplazamiento Y"
    L["RESET_POSITION"] = "Restablecer Posición"
    L["POSITION"] = "Posición"
    L["NEW_ADDON_IDEAS"] = "¿Nuevas Ideas de Addon?"
    L["VISIT"] = "Visita"
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
    L["RED"] = "Rouge"
    L["GREEN"] = "Vert"
    L["BLUE"] = "Bleu"
    L["ENABLE"] = "Activer le Reticule"
    L["X_OFFSET"] = "Décalage X"
    L["Y_OFFSET"] = "Décalage Y"
    L["RESET_POSITION"] = "Réinitialiser la Position"
    L["POSITION"] = "Position"
    L["NEW_ADDON_IDEAS"] = "Nouvelles Idées d'Addon?"
    L["VISIT"] = "Visitez"
    L["BORDER"] = "Activer la Bordure"
    L["BORDER_SIZE"] = "Taille de la Bordure"
    L["BORDER_COLOR"] = "Couleur de la Bordure"
end

-- Standard settings
local defaults = {
    sizeX = 20,
    sizeY = 20,
    color = { r = 0, g = 1, b = 0, a = 1 }, -- Green
    enabled = true,
    offsetX = 0,
    offsetY = 0,
    thickness = 1,
    border = false,
    borderSize = 2,
    borderColor = { r = 0, g = 0, b = 0, a = 1 } -- Black
}

-- Initialize database
CrosshairDB = CrosshairDB or {}

-- Apply defaults for any missing values
for k, v in pairs(defaults) do
    if CrosshairDB[k] == nil then
        if type(v) == "table" then
            CrosshairDB[k] = {}
            for k2, v2 in pairs(v) do
                CrosshairDB[k][k2] = v2
            end
        else
            CrosshairDB[k] = v
        end
    end
end

-- Container frame for the crosshair (for moving)
local crosshairContainer = CreateFrame("Frame", "CrosshairContainer", UIParent)
crosshairContainer:SetFrameStrata("LOW")
crosshairContainer:SetSize(1, 1)
crosshairContainer:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
crosshairContainer:EnableMouse(false)
crosshairContainer:SetMovable(true)

-- Horizontal line
local horizontalLine = crosshairContainer:CreateTexture(nil, "ARTWORK")
horizontalLine:SetTexture("Interface\\Buttons\\WHITE8X8")
horizontalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)

-- Vertical line
local verticalLine = crosshairContainer:CreateTexture(nil, "ARTWORK")
verticalLine:SetTexture("Interface\\Buttons\\WHITE8X8")
verticalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)

-- Border textures - along the lines
local horizontalTopBorder = crosshairContainer:CreateTexture(nil, "BACKGROUND")
horizontalTopBorder:SetTexture("Interface\\Buttons\\WHITE8X8")

local horizontalBottomBorder = crosshairContainer:CreateTexture(nil, "BACKGROUND")
horizontalBottomBorder:SetTexture("Interface\\Buttons\\WHITE8X8")

local verticalLeftBorder = crosshairContainer:CreateTexture(nil, "BACKGROUND")
verticalLeftBorder:SetTexture("Interface\\Buttons\\WHITE8X8")

local verticalRightBorder = crosshairContainer:CreateTexture(nil, "BACKGROUND")
verticalRightBorder:SetTexture("Interface\\Buttons\\WHITE8X8")

-- Border textures - at the tips
local topTipBorder = crosshairContainer:CreateTexture(nil, "BACKGROUND")
topTipBorder:SetTexture("Interface\\Buttons\\WHITE8X8")

local bottomTipBorder = crosshairContainer:CreateTexture(nil, "BACKGROUND")
bottomTipBorder:SetTexture("Interface\\Buttons\\WHITE8X8")

local leftTipBorder = crosshairContainer:CreateTexture(nil, "BACKGROUND")
leftTipBorder:SetTexture("Interface\\Buttons\\WHITE8X8")

local rightTipBorder = crosshairContainer:CreateTexture(nil, "BACKGROUND")
rightTipBorder:SetTexture("Interface\\Buttons\\WHITE8X8")

-- Function to update the crosshair
local function UpdateCrosshair()
    -- Ensure database is initialized
    if not CrosshairDB then
        CrosshairDB = {}
    end

    -- Apply defaults if values are missing
    if not CrosshairDB.sizeX then CrosshairDB.sizeX = defaults.sizeX end
    if not CrosshairDB.sizeY then CrosshairDB.sizeY = defaults.sizeY end
    if not CrosshairDB.thickness then CrosshairDB.thickness = defaults.thickness end
    if not CrosshairDB.borderSize then CrosshairDB.borderSize = defaults.borderSize end
    if CrosshairDB.border == nil then CrosshairDB.border = defaults.border end
    if CrosshairDB.enabled == nil then CrosshairDB.enabled = defaults.enabled end
    if not CrosshairDB.color then CrosshairDB.color = { r = 0, g = 1, b = 0, a = 1 } end
    if not CrosshairDB.borderColor then CrosshairDB.borderColor = { r = 0, g = 0, b = 0, a = 1 } end
    if not CrosshairDB.offsetX then CrosshairDB.offsetX = defaults.offsetX end
    if not CrosshairDB.offsetY then CrosshairDB.offsetY = defaults.offsetY end

    if not CrosshairDB.enabled then
        horizontalLine:Hide()
        verticalLine:Hide()
        horizontalTopBorder:Hide()
        horizontalBottomBorder:Hide()
        verticalLeftBorder:Hide()
        verticalRightBorder:Hide()
        topTipBorder:Hide()
        bottomTipBorder:Hide()
        leftTipBorder:Hide()
        rightTipBorder:Hide()
        crosshairContainer:EnableMouse(false)
        return
    end

    horizontalLine:Show()
    verticalLine:Show()

    local sizeX = CrosshairDB.sizeX
    local sizeY = CrosshairDB.sizeY
    local thickness = CrosshairDB.thickness
    local borderEnabled = CrosshairDB.border
    local borderSize = CrosshairDB.borderSize

    -- Container Position aktualisieren
    crosshairContainer:ClearAllPoints()
    crosshairContainer:SetPoint("CENTER", UIParent, "CENTER", CrosshairDB.offsetX, CrosshairDB.offsetY)

    -- Horizontal line
    horizontalLine:SetSize(sizeX * 2, thickness * 2)
    horizontalLine:SetPoint("CENTER", crosshairContainer, "CENTER", 0, 0)

    -- Vertical line
    verticalLine:SetSize(thickness * 2, sizeY * 2)
    verticalLine:SetPoint("CENTER", crosshairContainer, "CENTER", 0, 0)

    -- Update color
    horizontalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)
    verticalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)

    -- Update borders
    if borderEnabled then
        -- Update border colors
        horizontalTopBorder:SetVertexColor(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g,
            CrosshairDB.borderColor.b, CrosshairDB.borderColor.a)
        horizontalBottomBorder:SetVertexColor(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g,
            CrosshairDB.borderColor.b, CrosshairDB.borderColor.a)
        verticalLeftBorder:SetVertexColor(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g, CrosshairDB.borderColor
            .b, CrosshairDB.borderColor.a)
        verticalRightBorder:SetVertexColor(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g,
            CrosshairDB.borderColor.b, CrosshairDB.borderColor.a)
        topTipBorder:SetVertexColor(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g, CrosshairDB.borderColor.b,
            CrosshairDB.borderColor.a)
        bottomTipBorder:SetVertexColor(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g, CrosshairDB.borderColor.b,
            CrosshairDB.borderColor.a)
        leftTipBorder:SetVertexColor(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g, CrosshairDB.borderColor.b,
            CrosshairDB.borderColor.a)
        rightTipBorder:SetVertexColor(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g, CrosshairDB.borderColor.b,
            CrosshairDB.borderColor.a)

        -- Borders along the horizontal line (top and bottom)
        horizontalTopBorder:ClearAllPoints()
        horizontalTopBorder:SetSize(sizeX * 2, borderSize)
        horizontalTopBorder:SetPoint("BOTTOM", horizontalLine, "TOP", 0, 0)
        horizontalTopBorder:Show()

        horizontalBottomBorder:ClearAllPoints()
        horizontalBottomBorder:SetSize(sizeX * 2, borderSize)
        horizontalBottomBorder:SetPoint("TOP", horizontalLine, "BOTTOM", 0, 0)
        horizontalBottomBorder:Show()

        -- Borders along the vertical line (left and right)
        verticalLeftBorder:ClearAllPoints()
        verticalLeftBorder:SetSize(borderSize, sizeY * 2)
        verticalLeftBorder:SetPoint("RIGHT", verticalLine, "LEFT", 0, 0)
        verticalLeftBorder:Show()

        verticalRightBorder:ClearAllPoints()
        verticalRightBorder:SetSize(borderSize, sizeY * 2)
        verticalRightBorder:SetPoint("LEFT", verticalLine, "RIGHT", 0, 0)
        verticalRightBorder:Show()

        -- Tip borders at the ends of the vertical line (top and bottom tips)
        topTipBorder:ClearAllPoints()
        topTipBorder:SetSize(thickness * 2 + borderSize * 2, borderSize)
        topTipBorder:SetPoint("BOTTOM", verticalLine, "TOP", 0, 0)
        topTipBorder:Show()

        bottomTipBorder:ClearAllPoints()
        bottomTipBorder:SetSize(thickness * 2 + borderSize * 2, borderSize)
        bottomTipBorder:SetPoint("TOP", verticalLine, "BOTTOM", 0, 0)
        bottomTipBorder:Show()

        -- Tip borders at the ends of the horizontal line (left and right tips)
        leftTipBorder:ClearAllPoints()
        leftTipBorder:SetSize(borderSize, thickness * 2 + borderSize * 2)
        leftTipBorder:SetPoint("RIGHT", horizontalLine, "LEFT", 0, 0)
        leftTipBorder:Show()

        rightTipBorder:ClearAllPoints()
        rightTipBorder:SetSize(borderSize, thickness * 2 + borderSize * 2)
        rightTipBorder:SetPoint("LEFT", horizontalLine, "RIGHT", 0, 0)
        rightTipBorder:Show()
    else
        horizontalTopBorder:Hide()
        horizontalBottomBorder:Hide()
        verticalLeftBorder:Hide()
        verticalRightBorder:Hide()
        topTipBorder:Hide()
        bottomTipBorder:Hide()
        leftTipBorder:Hide()
        rightTipBorder:Hide()
    end
end

-- Initialization
Crosshair:RegisterEvent("PLAYER_LOGIN")
Crosshair:RegisterEvent("ADDON_LOADED")
Crosshair:RegisterEvent("DISPLAY_SIZE_CHANGED")

-- Create configuration window
local configFrame = nil

local function CreateConfigFrame()
    if configFrame then
        return configFrame
    end

    local frame = CreateFrame("Frame", "CrosshairConfigFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(450, 450)
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
    sizeXLabel:SetPoint("TOPLEFT", 20, -10)

    -- Horizontal Size Slider
    local sizeXSlider = CreateFrame("Slider", "CrosshairFrameSizeXSlider", panel, "OptionsSliderTemplate")
    sizeXSlider:SetPoint("TOPLEFT", sizeXLabel, "BOTTOMLEFT", 0, -10)
    sizeXSlider:SetMinMaxValues(1, 100)
    sizeXSlider:SetValue(CrosshairDB.sizeX)
    sizeXSlider:SetValueStep(1)
    sizeXSlider:SetObeyStepOnDrag(true)
    getglobal(sizeXSlider:GetName() .. "Low"):SetText("1")
    getglobal(sizeXSlider:GetName() .. "High"):SetText("100")
    getglobal(sizeXSlider:GetName() .. "Text"):SetText(L["SIZE_X"] .. ": " .. CrosshairDB.sizeX)

    sizeXSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.sizeX = value
        getglobal(self:GetName() .. "Text"):SetText(L["SIZE_X"] .. ": " .. value)
        UpdateCrosshair()
    end)

    local xSizeEditBox = CreateFrame("EditBox", "CrosshairXSizeEditBox", panel, "InputBoxTemplate")
    xSizeEditBox:SetSize(60, 20)
    xSizeEditBox:SetPoint("TOPLEFT", sizeXSlider, "BOTTOMLEFT", 0, -15)
    xSizeEditBox:SetAutoFocus(false)
    xSizeEditBox:SetNumeric(true)
    xSizeEditBox:SetText(tostring(CrosshairDB.sizeX or 0))

    xSizeEditBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText()) or 0
        value = math.max(1, math.min(100, math.floor(value)))
        self:SetText(tostring(value))
        CrosshairDB.sizeX = value
        sizeXSlider:SetValue(value)
        UpdateCrosshair()
        self:ClearFocus()
    end)

    xSizeEditBox:SetScript("OnEscapePressed", function(self)
        self:SetText(tostring(CrosshairDB.sizeX or 0))
        self:ClearFocus()
    end)

    sizeXSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.sizeX = value
        xSizeEditBox:SetText(tostring(value))
        UpdateCrosshair()
    end)

    -- Vertical Size Label
    local sizeYLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sizeYLabel:SetPoint("TOPLEFT", xSizeEditBox, "BOTTOMLEFT", 0, -10)

    -- Vertical Size Slider
    local sizeYSlider = CreateFrame("Slider", "CrosshairFrameSizeYSlider", panel, "OptionsSliderTemplate")
    sizeYSlider:SetPoint("TOPLEFT", sizeYLabel, "BOTTOMLEFT", 0, -10)
    sizeYSlider:SetMinMaxValues(1, 100)
    sizeYSlider:SetValue(CrosshairDB.sizeY)
    sizeYSlider:SetValueStep(1)
    sizeYSlider:SetObeyStepOnDrag(true)
    getglobal(sizeYSlider:GetName() .. "Low"):SetText("1")
    getglobal(sizeYSlider:GetName() .. "High"):SetText("100")
    getglobal(sizeYSlider:GetName() .. "Text"):SetText(L["SIZE_Y"] .. ": " .. CrosshairDB.sizeY)

    sizeYSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.sizeY = value
        getglobal(self:GetName() .. "Text"):SetText(L["SIZE_Y"] .. ": " .. value)
        UpdateCrosshair()
    end)

    local ySizeEditBox = CreateFrame("EditBox", "CrosshairYSizeEditBox", panel, "InputBoxTemplate")
    ySizeEditBox:SetSize(60, 20)
    ySizeEditBox:SetPoint("TOPLEFT", sizeYSlider, "BOTTOMLEFT", 0, -15)
    ySizeEditBox:SetAutoFocus(false)
    ySizeEditBox:SetNumeric(true)
    ySizeEditBox:SetText(tostring(CrosshairDB.sizeY or 0))

    ySizeEditBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText()) or 0
        value = math.max(1, math.min(100, math.floor(value)))
        self:SetText(tostring(value))
        CrosshairDB.sizeY = value
        sizeYSlider:SetValue(value)
        UpdateCrosshair()
        self:ClearFocus()
    end)

    ySizeEditBox:SetScript("OnEscapePressed", function(self)
        self:SetText(tostring(CrosshairDB.sizeY or 0))
        self:ClearFocus()
    end)

    sizeYSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.sizeY = value
        ySizeEditBox:SetText(tostring(value))
        UpdateCrosshair()
    end)

    -- Thickness Label
    local thicknessLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    thicknessLabel:SetPoint("TOPLEFT", ySizeEditBox, "BOTTOMLEFT", 0, -10)

    -- Thickness Slider
    local thicknessSlider = CreateFrame("Slider", "CrosshairFrameThicknessSlider", panel, "OptionsSliderTemplate")
    thicknessSlider:SetPoint("TOPLEFT", thicknessLabel, "BOTTOMLEFT", 0, -10)
    thicknessSlider:SetMinMaxValues(1, 50)
    thicknessSlider:SetValue(CrosshairDB.thickness or 1)
    thicknessSlider:SetValueStep(1)
    thicknessSlider:SetObeyStepOnDrag(true)
    getglobal(thicknessSlider:GetName() .. "Low"):SetText("1")
    getglobal(thicknessSlider:GetName() .. "High"):SetText("50")
    getglobal(thicknessSlider:GetName() .. "Text"):SetText(L["THICKNESS"] .. ": " .. (CrosshairDB.thickness or 1))

    thicknessSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.thickness = value
        getglobal(self:GetName() .. "Text"):SetText(L["THICKNESS"] .. ": " .. value)
        UpdateCrosshair()
    end)

    -- Farbe Label
    local colorLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    colorLabel:SetPoint("TOPLEFT", thicknessSlider, "BOTTOMLEFT", 0, -20)
    colorLabel:SetText(L["COLOR"] .. ":")

    -- Crosshair Color Picker Button
    local colorButton = CreateFrame("Button", "CrosshairColorButton", panel)
    colorButton:SetPoint("TOPLEFT", colorLabel, "BOTTOMLEFT", 5, -10)
    colorButton:SetSize(40, 40)

    -- Border frame
    local colorBorderFrame = CreateFrame("Frame", nil, colorButton)
    colorBorderFrame:SetAllPoints()
    colorBorderFrame:SetFrameLevel(colorButton:GetFrameLevel() - 1)
    local colorBorderTex = colorBorderFrame:CreateTexture(nil, "BACKGROUND")
    colorBorderTex:SetAllPoints()
    colorBorderTex:SetColorTexture(0.3, 0.3, 0.3, 1)

    -- Color preview texture (inset)
    local colorTexture = colorButton:CreateTexture(nil, "ARTWORK")
    colorTexture:SetPoint("TOPLEFT", 2, -2)
    colorTexture:SetPoint("BOTTOMRIGHT", -2, 2)
    colorTexture:SetColorTexture(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, 1)

    colorButton:SetScript("OnClick", function(self)
        local previousR, previousG, previousB = CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b

        local info = {
            r = CrosshairDB.color.r,
            g = CrosshairDB.color.g,
            b = CrosshairDB.color.b,
            opacity = 1,
            hasOpacity = false,
            swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                CrosshairDB.color.r = r
                CrosshairDB.color.g = g
                CrosshairDB.color.b = b
                colorTexture:SetColorTexture(r, g, b, 1)
                UpdateCrosshair()
            end,
            cancelFunc = function()
                CrosshairDB.color.r = previousR
                CrosshairDB.color.g = previousG
                CrosshairDB.color.b = previousB
                colorTexture:SetColorTexture(previousR, previousG, previousB, 1)
                UpdateCrosshair()
            end,
        }
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end)

    -- On/Off checkbox
    local checkbox = CreateFrame("CheckButton", "CrosshairFrameEnabledCheckbox", panel,
        "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", colorButton, "BOTTOMLEFT", 0, -20)
    checkbox:SetChecked(CrosshairDB.enabled)
    getglobal(checkbox:GetName() .. "Text"):SetText(L["ENABLE"])

    checkbox:SetScript("OnClick", function(self)
        CrosshairDB.enabled = self:GetChecked()
        UpdateCrosshair()
    end)

    -- X-offset label
    local xOffsetLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    xOffsetLabel:SetPoint("TOPRIGHT", -20, -10)

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
    xOffsetEditBox:SetPoint("TOPRIGHT", xOffsetSlider, "BOTTOMRIGHT", 0, -15)
    xOffsetEditBox:SetAutoFocus(false)
    xOffsetEditBox:SetNumeric(false)
    xOffsetEditBox:SetText(tostring(CrosshairDB.offsetX or 0))

    xOffsetEditBox:SetScript("OnEnterPressed", function(self)
        local input = self:GetText()
        local value = tonumber(input)
        if value ~=nil then
            value = math.max(-500, math.min(500, math.floor(value)))
            self:SetText(tostring(value))
            CrosshairDB.offsetX = value
            xOffsetSlider:SetValue(value)
            UpdateCrosshair()
            self:ClearFocus()
        else
            self:SetText(tostring(CrosshairDB.offsetX or 0))
            self:ClearFocus()
        end
    end)

    xOffsetEditBox:SetScript("OnEscapePressed", function(self)
        self:SetText(tostring(CrosshairDB.offsetX or 0))
        self:ClearFocus()
    end)

    xOffsetSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.offsetX = value
        xOffsetEditBox:SetText(tonumber(value))
        UpdateCrosshair()
    end)

    -- Y-offset label
    local yOffsetLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    yOffsetLabel:SetPoint("TOPRIGHT", xOffsetEditBox, "BOTTOMRIGHT", 0, -10)

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
    yOffsetEditBox:SetPoint("TOPRIGHT", yOffsetSlider, "BOTTOMRIGHT", 0, -15)
    yOffsetEditBox:SetAutoFocus(false)
    yOffsetEditBox:SetNumeric(false)
    yOffsetEditBox:SetText(tostring(CrosshairDB.offsetY or 0))

    yOffsetEditBox:SetScript("OnEnterPressed", function(self)
    local input = self:GetText()
    local value = tonumber(input)
        if value ~=nil then
            value = math.max(-500, math.min(500, math.floor(value)))
            self:SetText(tostring(value))
            CrosshairDB.offsetY = value
            yOffsetSlider:SetValue(value)
            UpdateCrosshair()
            self:ClearFocus()
        else
            self:SetText(tostring(CrosshairDB.offsetY or 0))
            self:ClearFocus()
        end
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
    resetButton:SetPoint("TOPRIGHT", yOffsetEditBox, "BOTTOMRIGHT", 0, -10)
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

    -- Border checkbox
    local borderCheckbox = CreateFrame("CheckButton", "CrosshairFrameBorderCheckbox", panel,
        "InterfaceOptionsCheckButtonTemplate")
    borderCheckbox:SetPoint("TOPRIGHT", resetButton, "BOTTOMRIGHT", 0, -10)
    borderCheckbox:SetChecked(CrosshairDB.border)
    --getglobal(borderCheckbox:GetName() .. "Text"):SetText(L["BORDER"])

    local text = getglobal(borderCheckbox:GetName() .. "Text")
    text:SetText(L["BORDER"])
    text:ClearAllPoints()
    text:SetPoint("RIGHT", borderCheckbox, "LEFT", 0, 0)

    borderCheckbox:SetScript("OnClick", function(self)
        CrosshairDB.border = self:GetChecked()
        UpdateCrosshair()
    end)

    -- Border Size Label
    local borderSizeLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    borderSizeLabel:SetPoint("TOPRIGHT", borderCheckbox, "BOTTOMRIGHT", 0, -10)

    -- Border Size Slider
    local borderSizeSlider = CreateFrame("Slider", "CrosshairFrameBorderSizeSlider", panel, "OptionsSliderTemplate")
    borderSizeSlider:SetPoint("TOPRIGHT", borderSizeLabel, "BOTTOMRIGHT", 0, -10)
    borderSizeSlider:SetMinMaxValues(1, 10)
    borderSizeSlider:SetValue(CrosshairDB.borderSize or 2)
    borderSizeSlider:SetValueStep(1)
    borderSizeSlider:SetObeyStepOnDrag(true)
    getglobal(borderSizeSlider:GetName() .. "Low"):SetText("1")
    getglobal(borderSizeSlider:GetName() .. "High"):SetText("10")
    getglobal(borderSizeSlider:GetName() .. "Text"):SetText(L["BORDER_SIZE"] .. ": " .. (CrosshairDB.borderSize or 2))

    borderSizeSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.borderSize = value
        getglobal(self:GetName() .. "Text"):SetText(L["BORDER_SIZE"] .. ": " .. value)
        UpdateCrosshair()
    end)

    -- Border Color Label
    local borderColorLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    borderColorLabel:SetPoint("TOPRIGHT", borderSizeSlider, "BOTTOMRIGHT", 0, -20)
    borderColorLabel:SetText(L["BORDER_COLOR"] .. ":")

    -- Border Color Picker Button
    local borderColorButton = CreateFrame("Button", "CrosshairBorderColorButton", panel)
    borderColorButton:SetPoint("TOPRIGHT", borderColorLabel, "BOTTOMRIGHT", -5, -10)
    borderColorButton:SetSize(40, 40)

    -- Border frame
    local borderFrame = CreateFrame("Frame", nil, borderColorButton)
    borderFrame:SetAllPoints()
    borderFrame:SetFrameLevel(borderColorButton:GetFrameLevel() - 1)
    local borderTex = borderFrame:CreateTexture(nil, "BACKGROUND")
    borderTex:SetAllPoints()
    borderTex:SetColorTexture(0.3, 0.3, 0.3, 1)

    -- Color preview texture (inset)
    local borderColorTexture = borderColorButton:CreateTexture(nil, "ARTWORK")
    borderColorTexture:SetPoint("TOPLEFT", 2, -2)
    borderColorTexture:SetPoint("BOTTOMRIGHT", -2, 2)
    borderColorTexture:SetColorTexture(CrosshairDB.borderColor.r, CrosshairDB.borderColor.g, CrosshairDB.borderColor.b, 1)

    borderColorButton:SetScript("OnClick", function(self)
        local previousR, previousG, previousB = CrosshairDB.borderColor.r, CrosshairDB.borderColor.g,
            CrosshairDB.borderColor.b

        local info = {
            r = CrosshairDB.borderColor.r,
            g = CrosshairDB.borderColor.g,
            b = CrosshairDB.borderColor.b,
            opacity = 1,
            hasOpacity = false,
            swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                CrosshairDB.borderColor.r = r
                CrosshairDB.borderColor.g = g
                CrosshairDB.borderColor.b = b
                borderColorTexture:SetColorTexture(r, g, b, 1)
                UpdateCrosshair()
            end,
            cancelFunc = function()
                CrosshairDB.borderColor.r = previousR
                CrosshairDB.borderColor.g = previousG
                CrosshairDB.borderColor.b = previousB
                borderColorTexture:SetColorTexture(previousR, previousG, previousB, 1)
                UpdateCrosshair()
            end,
        }
        ColorPickerFrame:SetupColorPickerAndShow(info)
    end)

    configFrame = frame
    return frame
end

-- Event Handler
Crosshair:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "crosshair" then
        UpdateCrosshair()
        print("|cFF00FF00===================================|r")
        print("|cFF00FF00Crosshair|r |cFF88AAFFv1.2.0|r")
        print(" ")
        print("|cFF88AAFF" .. L["NEW_ADDON_IDEAS"] .. "|r")
        print("|cFFFFFFFF" .. L["VISIT"] .. "|r |cFF00FF00https://www.addon-forge.de/|r")
        print(" ")
    elseif event == "PLAYER_LOGIN" then
        UpdateCrosshair()
        CreateConfigFrame() -- Frame erstellen
    elseif event == "DISPLAY_SIZE_CHANGED" then
        UpdateCrosshair()
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
