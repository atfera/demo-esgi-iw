
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Witherbark", 1008, 1214)
if not mod then return end
mod:RegisterEnableMob(81522)

--------------------------------------------------------------------------------
-- Locals
--

local energy = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.energyStatus = "A Globule reached Witherbark: %d%% energy"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		164294, -- Unchecked Growth
		164275, -- Brittle Bark
		{164357, "TANK"}, -- Parched Gasp
		"bosskill",
	}
end

function mod:OnBossEnable()
	-- XXX Target scan agitated water?
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "UncheckedGrowth", 164294)
	self:Log("SPELL_AURA_APPLIED", "BrittleBark", 164275)
	self:Log("SPELL_AURA_REMOVED", "BrittleBarkOver", 164275)
	self:Log("SPELL_CAST_SUCCESS", "Energize", 164438)
	self:Log("SPELL_CAST_START", "ParchedGasp", 164357)

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "UncheckedGrowthSpawned"

	self:Death("Win", 81522)
end

function mod:OnEngage()
	energy = 0
	self:CDBar(164357, 7) -- Parched Gasp
	self:Bar(164275, 30) -- Brittle Bark
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UncheckedGrowth(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
	end
end

function mod:BrittleBark(args)
	energy = 0
	self:Message(args.spellId, "Attention", "Info", ("%s - %s"):format(args.spellName, CL.incoming:format(self:SpellName(-10100)))) -- 10100 = Aqueous Globules
	self:StopBar(164357) -- Parched Gasp
end

function mod:BrittleBarkOver(args)
	self:Message(args.spellId, "Attention", "Info", CL.over:format(args.spellName))
	self:Bar(args.spellId, 30)
	self:CDBar(164357, 4) -- Parched Gasp
end

function mod:Energize(args)
	energy = energy + 25
	if energy < 101 then
		self:Message(164275, "Neutral", nil, L.energyStatus:format(energy), "spell_lightning_lightningbolt01")
	end
end

function mod:ParchedGasp(args)
	self:Message(args.spellId, "Important")
	self:CDBar(args.spellId, 11) -- 10-13s
end

function mod:UncheckedGrowthSpawned(_, msg)
	if self:Tank() and msg:find(self:SpellName(164294), nil, true) then -- Unchecked Growth
		self:Message(164294, "Urgent", nil, CL.add_spawned)
	end
end
