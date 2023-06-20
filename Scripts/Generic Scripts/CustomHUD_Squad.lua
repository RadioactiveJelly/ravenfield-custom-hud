-- Register the behaviour
behaviour("CustomHUD_Squad")

function CustomHUD_Squad:Awake()
	if GameManager.buildNumber <= 26 then
		self.squadText = self.gameObject.Find("Squad Text").GetComponent(Text)
	else
		GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")
	end
end

function CustomHUD_Squad:Start()
	self.squadTextVisibility = self.script.mutator.GetConfigurationBool("squadTextVisibility")
	if GameManager.buildNumber <= 26 then
		self:DeprecatedInit()
	end
end

function CustomHUD_Squad:onActorSpawn(actor)
	if actor.isPlayer then
		if self.squadTextVisibility then
			self.script.AddValueMonitor("MonitorPlayerOrderState", "UpdateSquadText")
			self.script.AddValueMonitor("MonitorPlayerSquadCount", "UpdateSquadText")
			self:UpdateSquadText()
		else
			self.squadText.gameObject.SetActive(false)
		end
	end
end

--Deprecated
function CustomHUD_Squad:DeprecatedInit()
	if self.squadTextVisibility then
		self.script.AddValueMonitor("monitorSquadText", "updateSquadText")
		self:updateSquadText()
	else
		self.squadText.gameObject.SetActive(false)
	end
end

--Deprecated
function CustomHUD_Squad:monitorSquadText()
	return self.squadText.text
end
--Deprecated
function CustomHUD_Squad:updateSquadText()
	self.targets.squadText.text = self.squadText.text
end

function CustomHUD_Squad:MonitorPlayerOrderState()
	return PlayerHud.playerOrderState
end

function CustomHUD_Squad:MonitorPlayerSquadCount()
	return #Player.squad.members
end

function CustomHUD_Squad:UpdateSquadText(state)
	local squadCount = #Player.squad.members - 1
	local order = tostring(PlayerHud.playerOrderState)

	local squadText = ""
	if squadCount > 0 then
		squadText = "Squad: " .. squadCount .. " (" .. order .. ")"
	else
		squadText = "No Squad"
	end
	
	self.targets.squadText.text = squadText
end