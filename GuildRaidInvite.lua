function GuildRaidInvite(phrase)
  if graidinv_frame == nil then
    graidinv_frame = CreateFrame("Frame")
  end

  if graidinv_frame.state == nil then
    graidinv_frame.state = false
  end

  local function GuildRaidToggle(msg)
    if graidinv_frame == nil or graidinv_frame.state == nil or graidinv_frame.phrase == nil then return end
    graidinv_frame.state = not graidinv_frame.state
    if graidinv_frame.state then
      graidinv_frame:RegisterEvent("CHAT_MSG_GUILD")
      graidinv_frame:RegisterEvent("CHAT_MSG_WHISPER")
      graidinv_frame.old_phrase = phrase
      SendChatMessage("Raid auto-invites starting now. Type in guild chat or whisper: " .. graidinv_frame.phrase, "GUILD")
    elseif graidinv_frame.state == false and (graidinv_frame.old_phrase ~= nil and graidinv_frame.old_phrase ~= graidinv_frame.phrase) then
      graidinv_frame.old_phrase = phrase
      graidinv_frame.state = true
      graidinv_frame:RegisterEvent("CHAT_MSG_GUILD")
      graidinv_frame:RegisterEvent("CHAT_MSG_WHISPER")
      SendChatMessage("Raid auto-invites starting now. Type in guild chat or whisper: " .. graidinv_frame.phrase, "GUILD")
    else
      if msg ~= nil then
        SendChatMessage(msg, "GUILD")
      else
        SendChatMessage("Raid auto-invites finished.", "GUILD")
      end
      graidinv_frame:UnregisterAllEvents()
      graidinv_frame.phrase = nil
    end
  end

  local function GuildRaidCheckMember(player_name)
    local name, rank, rankIndex, level, class, zone, note, officernote, online, status
    for i=1, GetNumGuildMembers() do
      name, rank, rankIndex, level, class, zone, note, officernote, online, status = GetGuildRosterInfo(i)
      if player_name == name then
        return true
      end
    end
    return false
  end

  if phrase == nil or phrase == "" then
    if graidinv_frame.state then
      GuildRaidToggle()
      return
    else
      DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000You have to define phrase for auto-invites.|r" )
      return
    end
  end

  graidinv_frame.phrase = phrase
  GuildRaidToggle()
  graidinv_frame:SetScript("OnEvent", function()
    if this.phrase == nill then return end
    if arg1 == this.phrase then
      -- convert to raid
      if GetNumPartyMembers() > 0 and GetNumRaidMembers() == 0 then
        ConvertToRaid()
      end
      -- invite if raid is not full
      if GetNumRaidMembers() < 40 then
        -- check if player in your guild
        if GuildRaidCheckMember(arg2) then
          InviteByName(arg2)
        end
      else
        -- stop invites if raid is full
        GuildRaidToggle("Raid auto-invites finished (raid is full).")
      end
    end
  end
  )

end
SlashCmdList.GUILDRAIDINVITE = GuildRaidInvite
SLASH_GUILDRAIDINVITE1 = "/graidinv"