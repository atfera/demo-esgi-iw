﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Pandemonius"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Pandemonius",

	shell = "Dark Shell Alert",
	shell_desc = "Warn when Dark Shell is cast",
	shell_trigger1 = "gains Dark Shell",
	shell_trigger2 = "Dark Shell fades",
	shell_alert1 = "Dark Shell!",
	shell_alert2 = "Dark Shell Down!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.zonename = AceLibrary("Babble-Zone-2.2")["Mana-Tombs"]
mod.enabletrigger = boss 
mod.toggleoptions = {"shell", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if self.db.profile.shell and msg == L["shell_trigger1"] then
		self:Message(L["shell_alert1"], "Attention")
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if self.db.profile.shell and msg:find(L["shell_trigger2"]) then
		self:Message(L["shell_alert2"], "Attention")
	end
end
