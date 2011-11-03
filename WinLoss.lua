wl = CreateFrame("Frame")

wl:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
wl:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
wl:RegisterEvent('ADDON_LOADED')
wl:RegisterEvent('WORLD_MAP_UPDATE')

local currentBGsaved = 0
local uname,urealm = UnitName("player")

function wl:WORLD_MAP_UPDATE()
  -- we can reasonably assume that the player has left the game or entered and new one and left
  -- the zone-in area (doesn't fire until you leave WSG hold, for example).
  currentBGsaved = 0
end

function wl:ADDON_LOADED()
  -- in case someone deletes (as they should) the database
  if WinLossDB == nil then WinLossDB = {} end
end

fnction wl:UPDATE_BATTLEFIELD_STATUS(...)
  -- DEFAULT_CHAT_FRAME:AddMessage("Update BG");
  local winner = GetBattlefieldWinner();
  if winner then
    if currentBGsaved then return end
    local d = date("%s");
    local u = UnitLevel("player");
    local s = GetNumBattlefieldScores();
    local zoneName = GetZoneText();
    if currentBGsaved == 0 then
      -- Apparently sometimes zone changes aren't triggered
      -- so we'll also discount any new win within 5 minutes after the last
      -- *sigh*
      if d <= savetime - 300 then return end 
      WinLossDB[d..":"..uname] = winner..":"..u..":"..s..":"..zoneName;
      savetime = d
      currentBGsaved = 1
    end
    DEFAULT_CHAT_FRAME:AddMessage(winner..":"..u..":"..s..":"..zoneName);
    if winner == 1 then 
      DEFAULT_CHAT_FRAME:AddMessage("Alliance has won")
    else
      DEFAULT_CHAT_FRAME:AddMessage("Horde has won")
    end
  end
end
