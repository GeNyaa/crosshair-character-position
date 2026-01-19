-- Crosshair Addon
local Crosshair = CreateFrame("Frame", "CrosshairFrame", UIParent)
Crosshair:SetFrameStrata("TOOLTIP")
Crosshair:SetAllPoints(UIParent)
Crosshair:EnableMouse(false)

-- Lokalisierung
local L = {}
local locale = GetLocale()

-- Deutsche Texte (Standard)
L["TITLE"] = "Crosshair Einstellungen"
L["SIZE"] = "Größe"
L["THICKNESS"] = "Thickness"
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

-- Englische Texte
if locale == "enUS" or locale == "enGB" then
    L["TITLE"] = "Crosshair Settings"
    L["SIZE"] = "Size"
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
end

-- Spanische Texte
if locale == "esES" or locale == "esMX" then
    L["TITLE"] = "Configuración de Mira"
    L["SIZE"] = "Tamaño"
    L["THICKNESS"] = "Thickness"
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
end

-- Französische Texte
if locale == "frFR" then
    L["TITLE"] = "Paramètres du Reticule"
    L["SIZE"] = "Taille"
    L["THICKNESS"] = "Thickness"
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
end

-- Standard settings
local defaults = {
    size = 20,
    color = {r = 0, g = 1, b = 0, a = 1}, -- Green
    enabled = true,
    offsetX = 0,
    offsetY = 0,
    thickness = 1
}

-- Initialize database
CrosshairDB = CrosshairDB or {}
for k, v in pairs(defaults) do
    if CrosshairDB[k] == nil then
        CrosshairDB[k] = v
    end
end

-- Container frame for the crosshair (for moving)
local crosshairContainer = CreateFrame("Frame", "CrosshairContainer", UIParent)
crosshairContainer:SetFrameStrata("TOOLTIP")
crosshairContainer:SetSize(1, 1)
crosshairContainer:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
crosshairContainer:EnableMouse(false)
crosshairContainer:SetMovable(true)

-- Horizontal line
local horizontalLine = crosshairContainer:CreateTexture(nil, "OVERLAY")
horizontalLine:SetTexture("Interface\\Buttons\\WHITE8X8")
horizontalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)

-- Vertical line
local verticalLine = crosshairContainer:CreateTexture(nil, "OVERLAY")
verticalLine:SetTexture("Interface\\Buttons\\WHITE8X8")
verticalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)

-- Function to update the crosshair
local function UpdateCrosshair()
    if not CrosshairDB.enabled then
        horizontalLine:Hide()
        verticalLine:Hide()
        crosshairContainer:EnableMouse(false)
        return
    end
    
    horizontalLine:Show()
    verticalLine:Show()
    
    local size = CrosshairDB.size
    local thickness = CrosshairDB.thickness or 1
    
    -- Container Position aktualisieren
    crosshairContainer:ClearAllPoints()
    crosshairContainer:SetPoint("CENTER", UIParent, "CENTER", CrosshairDB.offsetX or 0, CrosshairDB.offsetY or 0)
    
    -- Horizontal line
    horizontalLine:SetSize(size * 2, thickness * 2)
    horizontalLine:SetPoint("CENTER", crosshairContainer, "CENTER", 0, 0)
    
    -- Vertical line
    verticalLine:SetSize(thickness * 2, size * 2)
    verticalLine:SetPoint("CENTER", crosshairContainer, "CENTER", 0, 0)
    
    -- Update color
    horizontalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)
    verticalLine:SetVertexColor(CrosshairDB.color.r, CrosshairDB.color.g, CrosshairDB.color.b, CrosshairDB.color.a)
end

-- Initialization
Crosshair:RegisterEvent("PLAYER_LOGIN")
Crosshair:RegisterEvent("ADDON_LOADED")
Crosshair:RegisterEvent("DISPLAY_SIZE_CHANGED")

-- Konfigurations-Fenster erstellen
local configFrame = nil

local function CreateConfigFrame()
    if configFrame then
        return configFrame
    end
    
    local frame = CreateFrame("Frame", "CrosshairConfigFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(600, 500)
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
    
    -- Size Label
    local sizeLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sizeLabel:SetPoint("TOPLEFT", 20, -60)
    sizeLabel:SetText(L["SIZE"] .. ":")
    
    -- Size Slider
    local sizeSlider = CreateFrame("Slider", "CrosshairFrameSizeSlider", panel, "OptionsSliderTemplate")
    sizeSlider:SetPoint("TOPLEFT", sizeLabel, "BOTTOMLEFT", 0, -10)
    sizeSlider:SetMinMaxValues(5, 100)
    sizeSlider:SetValue(CrosshairDB.size)
    sizeSlider:SetValueStep(1)
    sizeSlider:SetObeyStepOnDrag(true)
    getglobal(sizeSlider:GetName() .. "Low"):SetText("5")
    getglobal(sizeSlider:GetName() .. "High"):SetText("100")
    getglobal(sizeSlider:GetName() .. "Text"):SetText(L["SIZE"] .. ": " .. CrosshairDB.size)
    
    sizeSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        CrosshairDB.size = value
        getglobal(self:GetName() .. "Text"):SetText(L["SIZE"] .. ": " .. value)
        UpdateCrosshair()
    end)

    -- Thickness Label
    local thicknessLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    thicknessLabel:SetPoint("TOPLEFT", 20, 0)
    thicknessLabel:SetText(L["THICKNESS"] .. ":")

    -- Thickness Slider
    local thicknessSlider = CreateFrame("Slider", "CrosshairFrameThicknessSlider", panel, "OptionsSliderTemplate")
    thicknessSlider:SetPoint("TOPLEFT", thicknessLabel, "BOTTOMLEFT", 0, -15)
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
        getglobal(self:GetName() .. "Text"):SetText(L["SIZE"] .. ": " .. value)
        UpdateCrosshair()
    end)
    
    -- Farbe Label
    local colorLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    colorLabel:SetPoint("TOPLEFT", 20, -130)
    colorLabel:SetText(L["COLOR"] .. ":")
    
    -- Red Slider
    local redSlider = CreateFrame("Slider", "CrosshairFrameRedSlider", panel, "OptionsSliderTemplate")
    redSlider:SetPoint("TOPLEFT", colorLabel, "BOTTOMLEFT", 0, -10)
    redSlider:SetMinMaxValues(0, 1)
    redSlider:SetValue(CrosshairDB.color.r)
    redSlider:SetValueStep(0.01)
    getglobal(redSlider:GetName() .. "Low"):SetText("0")
    getglobal(redSlider:GetName() .. "High"):SetText("1")
    getglobal(redSlider:GetName() .. "Text"):SetText(L["RED"] .. ": " .. math.floor(CrosshairDB.color.r * 100) .. "%")
    
    redSlider:SetScript("OnValueChanged", function(self, value)
        CrosshairDB.color.r = value
        getglobal(self:GetName() .. "Text"):SetText(L["RED"] .. ": " .. math.floor(value * 100) .. "%")
        UpdateCrosshair()
    end)
    
    -- Green Slider
    local greenSlider = CreateFrame("Slider", "CrosshairFrameGreenSlider", panel, "OptionsSliderTemplate")
    greenSlider:SetPoint("TOPLEFT", redSlider, "BOTTOMLEFT", 0, -20)
    greenSlider:SetMinMaxValues(0, 1)
    greenSlider:SetValue(CrosshairDB.color.g)
    greenSlider:SetValueStep(0.01)
    getglobal(greenSlider:GetName() .. "Low"):SetText("0")
    getglobal(greenSlider:GetName() .. "High"):SetText("1")
    getglobal(greenSlider:GetName() .. "Text"):SetText(L["GREEN"] .. ": " .. math.floor(CrosshairDB.color.g * 100) .. "%")
    
    greenSlider:SetScript("OnValueChanged", function(self, value)
        CrosshairDB.color.g = value
        getglobal(self:GetName() .. "Text"):SetText(L["GREEN"] .. ": " .. math.floor(value * 100) .. "%")
        UpdateCrosshair()
    end)
    
    -- Blue Slider
    local blueSlider = CreateFrame("Slider", "CrosshairFrameBlueSlider", panel, "OptionsSliderTemplate")
    blueSlider:SetPoint("TOPLEFT", greenSlider, "BOTTOMLEFT", 0, -20)
    blueSlider:SetMinMaxValues(0, 1)
    blueSlider:SetValue(CrosshairDB.color.b)
    blueSlider:SetValueStep(0.01)
    getglobal(blueSlider:GetName() .. "Low"):SetText("0")
    getglobal(blueSlider:GetName() .. "High"):SetText("1")
    getglobal(blueSlider:GetName() .. "Text"):SetText(L["BLUE"] .. ": " .. math.floor(CrosshairDB.color.b * 100) .. "%")
    
    blueSlider:SetScript("OnValueChanged", function(self, value)
        CrosshairDB.color.b = value
        getglobal(self:GetName() .. "Text"):SetText(L["BLUE"] .. ": " .. math.floor(value * 100) .. "%")
        UpdateCrosshair()
    end)
    
    -- On/Off checkbox
    local checkbox = CreateFrame("CheckButton", "CrosshairFrameEnabledCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", 20, -280)
    checkbox:SetChecked(CrosshairDB.enabled)
    getglobal(checkbox:GetName() .. "Text"):SetText(L["ENABLE"])
    
    checkbox:SetScript("OnClick", function(self)
        CrosshairDB.enabled = self:GetChecked()
        UpdateCrosshair()
    end)
    
    -- Position Label (rechte Seite)
    local positionLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    positionLabel:SetPoint("TOPRIGHT", -20, -60)
    positionLabel:SetText(L["POSITION"] .. ":")
    
    -- X-Versatz Label
    local xOffsetLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    xOffsetLabel:SetPoint("TOPRIGHT", positionLabel, "BOTTOMRIGHT", 0, -10)
    xOffsetLabel:SetText(L["X_OFFSET"] .. ":")
    
    -- X-Versatz Slider (zuerst erstellen)
    local xOffsetSlider = CreateFrame("Slider", "CrosshairFrameXOffsetSlider", panel, "OptionsSliderTemplate")
    xOffsetSlider:SetPoint("TOPRIGHT", xOffsetLabel, "BOTTOMRIGHT", 0, -10)
    xOffsetSlider:SetMinMaxValues(-500, 500)
    xOffsetSlider:SetValue(CrosshairDB.offsetX or 0)
    xOffsetSlider:SetValueStep(1)
    xOffsetSlider:SetObeyStepOnDrag(true)
    getglobal(xOffsetSlider:GetName() .. "Low"):SetText("-500")
    getglobal(xOffsetSlider:GetName() .. "High"):SetText("500")
    getglobal(xOffsetSlider:GetName() .. "Text"):SetText(L["X_OFFSET"])
    
    -- X-Versatz Eingabefeld
    local xOffsetEditBox = CreateFrame("EditBox", "CrosshairXOffsetEditBox", panel, "InputBoxTemplate")
    xOffsetEditBox:SetSize(60, 20)
    xOffsetEditBox:SetPoint("TOPRIGHT", xOffsetSlider, "BOTTOMRIGHT", -10, -5)
    xOffsetEditBox:SetAutoFocus(false)
    xOffsetEditBox:SetNumeric(true)
    xOffsetEditBox:SetText(tostring(CrosshairDB.offsetX or 0))
    
    xOffsetEditBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText()) or 0
        value = math.max(-500, math.min(500, math.floor(value)))
        self:SetText(tostring(value))
        CrosshairDB.offsetX = value
        xOffsetSlider:SetValue(value)
        UpdateCrosshair()
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
    
    -- Y-Versatz Label
    local yOffsetLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    yOffsetLabel:SetPoint("TOPRIGHT", xOffsetEditBox, "BOTTOMRIGHT", 0, -20)
    yOffsetLabel:SetText(L["Y_OFFSET"] .. ":")
    
    -- Y-Versatz Slider (zuerst erstellen)
    local yOffsetSlider = CreateFrame("Slider", "CrosshairFrameYOffsetSlider", panel, "OptionsSliderTemplate")
    yOffsetSlider:SetPoint("TOPRIGHT", yOffsetLabel, "BOTTOMRIGHT", 0, -10)
    yOffsetSlider:SetMinMaxValues(-500, 500)
    yOffsetSlider:SetValue(CrosshairDB.offsetY or 0)
    yOffsetSlider:SetValueStep(1)
    yOffsetSlider:SetObeyStepOnDrag(true)
    getglobal(yOffsetSlider:GetName() .. "Low"):SetText("-500")
    getglobal(yOffsetSlider:GetName() .. "High"):SetText("500")
    getglobal(yOffsetSlider:GetName() .. "Text"):SetText(L["Y_OFFSET"])
    
    -- Y-Versatz Eingabefeld
    local yOffsetEditBox = CreateFrame("EditBox", "CrosshairYOffsetEditBox", panel, "InputBoxTemplate")
    yOffsetEditBox:SetSize(60, 20)
    yOffsetEditBox:SetPoint("TOPRIGHT", yOffsetSlider, "BOTTOMRIGHT", -10, -5)
    yOffsetEditBox:SetAutoFocus(false)
    yOffsetEditBox:SetNumeric(true)
    yOffsetEditBox:SetText(tostring(CrosshairDB.offsetY or 0))
    
    yOffsetEditBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText()) or 0
        value = math.max(-500, math.min(500, math.floor(value)))
        self:SetText(tostring(value))
        CrosshairDB.offsetY = value
        yOffsetSlider:SetValue(value)
        UpdateCrosshair()
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
    
    -- Position zurücksetzen Button
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
        print("|cFF00FF00===================================|r")
        print("|cFF00FF00Crosshair|r |cFF88AAFFv1.0.0|r")
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

