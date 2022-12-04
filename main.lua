local addonFrames = {
  right = {
    active = true,
    hideFrame = CreateFrame("Frame", "SodaRightHideFrame", UIParent),
    showFrame = CreateFrame("Frame", "SodaRightShowFrame", SodaRightHideFrame),
    anchor = "RIGHT",
    width = _G["MultiBarLeft"]:GetWidth() * 2,
    height = _G["MultiBarLeft"]:GetHeight(),
    targets = { _G["MultiBarRight"], _G["MultiBarLeft"] }
  },
  bottom = {
    active = true,
    hideFrame = CreateFrame("Frame", "SodaBottomHideFrame", UIParent),
    showFrame = CreateFrame("Frame", "SodaBottomShowFrame", SodaBottomHideFrame),
    width = _G["MainMenuBar"]:GetWidth(),
    height = _G["MainMenuBar"]:GetHeight() + _G["MultiBarBottomLeft"]:GetHeight() + _G["StanceBarFrame"]:GetHeight(),
    anchor = "BOTTOM",
    targets = { _G["MainMenuBar"] },
  },
}

local rightToggled, leftToggled = false, false

local eventframe = CreateFrame("Frame", "SodaEventFrame", UIParent)
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:RegisterEvent("PLAYER_REGEN_ENABLED")
eventframe:RegisterEvent("ADDON_LOADED")
local function eventHandler(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "SodaBarHider" then
    if SBHRightToggled == nil then
      SBHRightToggled = true
      SBHBottomToggled = true
      addonFrames.bottom.active = true
      addonFrames.right.active = true
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    print("SBH: type /sbh enable/disable bottom/right/all to activate bar hiding")
    for key, category in pairs(addonFrames) do
      category.showFrame:SetWidth(category.width)
      category.showFrame:SetHeight(category.height)

      category.hideFrame:SetWidth(category.width + 20)
      category.hideFrame:SetHeight(category.height + 20)

      category.hideFrame:SetPoint(category.anchor, 0, 0)
      category.showFrame:SetPoint(category.anchor, 0, 0)

      category.hideFrame:Show()
      category.showFrame:Show()

      for index, val in ipairs(category.targets) do
        RegisterAttributeDriver(val, "state-visibility", "[combat] show;")
      end

      category.showFrame:HookScript("OnEnter", function(self)
        if not category.active then
          return
        end
        if InCombatLockdown() == false then
          ShowBars(category.targets)
        end
      end)

      category.hideFrame:HookScript("OnEnter", function(self)
        if not category.active then
          return
        end
        if InCombatLockdown() == false then
          HideBars(category.targets)
        end
      end)

    end
  else
    HideAllBars()
  end
end

eventframe:SetScript("OnEvent", eventHandler);

function HideBars(targets)
  for index, frame in ipairs(targets) do
    frame:Hide()
  end
end

function ShowBars(targets)
  for index, frame in ipairs(targets) do
    frame:Show()
  end
end

function HideAllBars()
  HideBars(addonFrames.right.targets)
  HideBars(addonFrames.bottom.targets)
end

function ShowAllBars()
  ShowBars(addonFrames.right.targets)
  ShowBars(addonFrames.bottom.targets)
end

SLASH_SBH1 = "/SBH"
local function MyCommands(msg, editbox)
  local action, target = strsplit(" ", msg, 2)

  if action ~= "disable" and action ~= "enable" then
    return
  end

  local value = false
  if action == "enable" then
    value = true
  end

  if target == "right" then
    SBHRightToggled = value
    addonFrames.right.active = value
    if value == false then
      ShowBars(addonFrames.right.targets)
    end
  elseif target == "bottom" then
    SBHBottomToggled = value
    addonFrames.bottom.active = value
    if value == false then
      ShowBars(addonFrames.bottom.targets)
    end
  elseif target == "all" then
    SBHRightToggled = value
    SBHBottomToggled = value
    addonFrames.right.active = value
    addonFrames.bottom.active = value
    if value == false then
      ShowAllBars()
    end
  end
end

SlashCmdList["SBH"] = MyCommands
