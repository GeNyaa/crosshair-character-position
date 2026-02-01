CrosshairDB = _G.CrosshairDB

-- Crosshair Addon
local Crosshair = CreateFrame("Frame", "CrosshairFrame", UIParent)
Crosshair:SetFrameStrata("TOOLTIP")
Crosshair:SetAllPoints(UIParent)
Crosshair:EnableMouse(false)


-- Container frame for the crosshair (for moving)
local crosshairContainer = CreateFrame("Frame", "CrosshairContainer", UIParent)
crosshairContainer:SetFrameStrata(CrosshairDB.strata or "TOOLTIP")
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
function UpdateCrosshair()
    if not CrosshairDB.enabled then
        horizontalLine:Hide()
        verticalLine:Hide()
        HideBorders()
        crosshairContainer:EnableMouse(false)
        return
    end

    horizontalLine:Show()
    verticalLine:Show()

    -- Set Strata level
    crosshairContainer:SetFrameStrata(CrosshairDB.strata or "TOOLTIP")

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

-- Event Handler
Crosshair:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "crosshair" then
        UpdateCrosshair()
    elseif event == "PLAYER_LOGIN" then
        UpdateCrosshair()
        CreateConfigFrame() -- Create Frame
    elseif event == "DISPLAY_SIZE_CHANGED" then
        UpdateCrosshair()
    elseif event == "PLAYER_REGEN_DISABLED" then
        CombatStart()
    elseif event == "PLAYER_REGEN_ENABLED" then
        CombatEnd()
    end
end)
