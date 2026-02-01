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
    borderColor = {r = 0, g = 0, b = 0, a = 1}, -- Black
    strata = "TOOLTIP"
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
