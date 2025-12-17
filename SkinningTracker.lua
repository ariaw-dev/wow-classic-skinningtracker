-- =====================================
-- SkinningTracker v1.0
-- =====================================

-- =====================================
-- Main Frame
-- =====================================
local ST = CreateFrame("Frame", "ST_Frame", UIParent, "BackdropTemplate")
ST:SetSize(300, 150)
ST:SetPoint("CENTER")
ST:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 12,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

ST:SetMovable(true)
ST:EnableMouse(true)
ST:RegisterForDrag("LeftButton")
ST:SetScript("OnDragStart", ST.StartMoving)
ST:SetScript("OnDragStop", ST.StopMovingOrSizing)

ST:Hide() -- start hidden

-- =====================================
-- Close Button & Title
-- =====================================
CreateFrame("Button", nil, ST, "UIPanelCloseButton"):SetPoint("TOPRIGHT", -5, -5)

ST.title = ST:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
ST.title:SetPoint("TOP", 0, -10)
ST.title:SetText("SkinningTracker")

-- =====================================
-- Session State
-- =====================================
local running = false
local elapsed = 0
local kills = 0
local skins = 0
local log = {}

-- =====================================
-- UI Text Helpers
-- =====================================
local function Line(y)
    local t = ST:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOPLEFT", 15, y)
    t:SetJustifyH("LEFT")
    return t
end

local timeText = Line(-40)
local killText = Line(-60)
local skinText = Line(-80)

local function UpdateText()
    timeText:SetText("Time: " .. SecondsToTime(math.floor(elapsed)))
    killText:SetText("Kills: " .. kills)
    skinText:SetText("Skins: " .. skins)
end

-- =====================================
-- Buttons
-- =====================================
local function Btn(text, x)
    local b = CreateFrame("Button", nil, ST, "UIPanelButtonTemplate")
    b:SetSize(60, 22)
    b:SetPoint("BOTTOMLEFT", x, 10)
    b:SetText(text)
    return b
end

local startBtn = Btn("Start", 10)
local stopBtn  = Btn("Stop", 80)
local resetBtn = Btn("Reset", 150)
local logBtn   = Btn("Log", 220)

-- =====================================
-- Log Frame
-- =====================================
local logF = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
logF:SetSize(460, 300)
logF:SetPoint("CENTER")
logF:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 12,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

logF:SetMovable(true)
logF:EnableMouse(true)
logF:RegisterForDrag("LeftButton")
logF:SetScript("OnDragStart", logF.StartMoving)
logF:SetScript("OnDragStop", logF.StopMovingOrSizing)
logF:Hide()

CreateFrame("Button", nil, logF, "UIPanelCloseButton"):SetPoint("TOPRIGHT", -5, -5)

logF.title = logF:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
logF.title:SetPoint("TOP", 0, -10)
logF.title:SetText("Session Log")

-- =====================================
-- Scroll Frame
-- =====================================
local sf = CreateFrame("ScrollFrame", nil, logF, "UIPanelScrollFrameTemplate")
sf:SetPoint("TOPLEFT", 10, -40)
sf:SetPoint("BOTTOMRIGHT", -30, 40)

local child = CreateFrame("Frame")
child:SetSize(420, 1)
sf:SetScrollChild(child)

local logText = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
logText:SetPoint("TOPLEFT", 0, 0)
logText:SetWidth(420)
logText:SetJustifyH("LEFT")

local function UpdateLog()
    local s = ""
    for _, l in ipairs(log) do
        s = s .. l .. "\n"
    end
    logText:SetText(s)
end

local function AddLog(msg)
    table.insert(log, date("[%H:%M:%S] ") .. msg)
    UpdateLog()
end

-- =====================================
-- Button Logic
-- =====================================
startBtn:SetScript("OnClick", function()
    running = true
end)

stopBtn:SetScript("OnClick", function()
    running = false
end)

resetBtn:SetScript("OnClick", function()
    running = false
    elapsed = 0
    kills = 0
    skins = 0
    wipe(log)
    UpdateText()
    UpdateLog()
end)

logBtn:SetScript("OnClick", function()
    logF:SetShown(not logF:IsShown())
    UpdateLog()
end)

-- =====================================
-- Events & Timer
-- =====================================
ST:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ST:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

ST:SetScript("OnUpdate", function(_, dt)
    if running then
        elapsed = elapsed + dt
        UpdateText()
    end
end)

ST:SetScript("OnEvent", function(_, event, ...)
    if not running then return end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, sub, _, srcGUID, _, _, _, destName =
            CombatLogGetCurrentEventInfo()

        if sub == "PARTY_KILL" and srcGUID == UnitGUID("player") then
            kills = kills + 1
            AddLog("Kill: " .. (destName or "Unknown"))
        end

    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, _, spellID = ...
        if unit == "player" and GetSpellInfo(spellID) == "Skinning" then
            skins = skins + 1
            AddLog("Skinned mob (" .. skins .. ")")
        end
    end

    UpdateText()
end)

-- =====================================
-- Hide Log when Main closes
-- =====================================
ST:SetScript("OnHide", function()
    logF:Hide()
end)

-- =====================================
-- Slash Command
-- =====================================
SLASH_ST1 = "/st"
SlashCmdList["ST"] = function()
    if ST:IsShown() then
        ST:Hide()
    else
        ST:Show()
        UpdateText()
    end
end

