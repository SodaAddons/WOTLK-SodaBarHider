local frame = _G["VerticalMultiBarsContainer"]
local frame2 = _G["MultiBarLeft"]

local hideframe = CreateFrame("Frame", "DaveHideFrame", UIParent)
hideframe:SetFrameStrata("BACKGROUND")
hideframe:SetWidth(140)
hideframe:SetHeight(640)
hideframe:SetPoint("RIGHT",0,0)
hideframe:Show()
local showframe = CreateFrame("Frame", "DaveShowFrame", DaveHideFrame)
showframe:SetFrameStrata("BACKGROUND")
showframe:SetWidth(100)
showframe:SetHeight(600)
showframe:SetPoint("RIGHT",0,0)
showframe:Show()

showframe:HookScript("OnEnter", function(self)
  if InCombatLockdown() == false then
    ShowBars()
  end
end)

hideframe:HookScript("OnEnter", function(self)
  if InCombatLockdown() == false then
    HideBars()
  end
end)

hideframe:RegisterEvent("PLAYER_ENTERING_WORLD");
hideframe:RegisterEvent("PLAYER_REGEN_DISABLED");
hideframe:RegisterEvent("PLAYER_REGEN_ENABLED");
local function eventHandler(self, event, ...)
  if event == "PLAYER_REGEN_DISABLED"  then
    ShowBars()
  else
    HideBars()
  end
end
hideframe:SetScript("OnEvent", eventHandler);

function HideBars()
  frame:Hide()
  frame2:Hide()
end
  
function ShowBars()
  frame:Show()
  frame2:Show()
end