wl = CreateFrame("Frame")

wl:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
wl:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
wl:RegisterEvent('ADDON_LOADED')

function wl:ADDON_LOADED()
  if WinLossDB == nil then WinLossDB = {} end
end

function wl:UPDATE_BATTLEFIELD_STATUS(...)
  DEFAULT_CHAT_FRAME:AddMessage("Update BG");
  local winner = GetBattlefieldWinner();
  if winner then
    local d = date("%s");
    local u = UnitLevel("player");
    local s = GetNumBattlefieldScores();
    local zoneName = GetZoneText();
    WinLossDB[d] = winner..":"..u..":"..s..":"..zoneName;
    DEFAULT_CHAT_FRAME:AddMessage(winner..":"..u..":"..s..":"..zoneName);
    if winner == 1 then 
      DEFAULT_CHAT_FRAME:AddMessage("Alliance has won")
    else
      DEFAULT_CHAT_FRAME:AddMessage("Horde has won")
    end
  end
end
