wl = CreateFrame("Frame")

wl:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
wl:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
wl:RegisterEvent('ADDON_LOADED')
wl:RegisterEvent('WORLD_MAP_UPDATE')

wl.currentBGsaved = 0 -- to avoid multiple saves while UPDATE_BATTLEFIELD_STATUS fires as we stare at score
local uname,_ = UnitName("player")

function wl:WORLD_MAP_UPDATE()
  -- we can reasonably assume that the player has left the game or entered and new one and left
  -- the zone-in area (doesn't fire until you leave WSG hold, for example).
  self.currentBGsaved = 0
end

function wl:ADDON_LOADED()
  -- in case someone deletes (as they should) the database
  if WinLossDB == nil then WinLossDB = {} end
  if WinLossDB["debug"] == nil then WinLossDB["debug"] = false end
end

function wl:UPDATE_BATTLEFIELD_STATUS()
  local winner = GetBattlefieldWinner();
  if winner then
    if currentBGsaved then return end
    local d = date("%s");
    local u = UnitLevel("player");
    local s = GetNumBattlefieldScores();
    local zoneName = GetZoneText();
    wl:Debug("BG Saved is now: "..self.currentBGsaved);
    if self.currentBGsaved == 0 then
      WinLossDB[d] = winner..":"..u..":"..s..":"..zoneName..":"..uname;
      self.currentBGsaved = 1
      wl:Debug("Now BGSaved is One");
    end
    wl:Debug(winner..":"..u..":"..s..":"..zoneName);
    if winner == 1 then 
      DEFAULT_CHAT_FRAME:AddMessage("Alliance has won")
    else
      DEFAULT_CHAT_FRAME:AddMessage("Horde has won")
    end
  end
end

function wl:Debug(message)
  if not WinLossDB["debug"] then return end
  DEFAULT_CHAT_FRAME:AddMessage("*** WLD: "..message);
end

SLASH_WINLOSS1 = "/winloss";
SlashCmdList["WINLOSS"] = function(msg)
  local command, rest = msg:match("^(%S*)%s*(.-)$")
  if command == "help" then
    DEFAULT_CHAT_FRAME:AddMessage("---] Collects wins and losses");
    DEFAULT_CHAT_FRAME:AddMessage("---] Type /winloss clear to clean database. All collected data will be cleared.");
  elseif command == "clear" then
    WinLossDB = {}
  elseif command == "data" then
    DEFAULT_CHAT_FRAME:AddMessage("Fancy data visualizations coming soon");
  elseif command == "debug" then
    WinLossDB["debug"] = not WinLossDB["debug"];
    DEFAULT_CHAT_FRAME:AddMessage("Debug is now "..tostring(WinLossDB["debug"]));
  end
end
