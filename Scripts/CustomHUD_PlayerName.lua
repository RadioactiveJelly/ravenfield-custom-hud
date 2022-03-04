-- Register the behaviour
behaviour("CustomHUD_PlayerName")

function CustomHUD_PlayerName:Start()
	GameEvents.onActorDied.AddListener(self,"onActorDied")
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")

	self.playerNameVisibility = self.script.mutator.GetConfigurationBool("playerNameVisibility")
	--self.targets.playerNameText.gameObject.SetActive(self.playerNameVisibility or not GameManager.isLegitimate or Player.actor.name == "Unknown Player")

	self:SetText()

	self.script.AddValueMonitor("monitorHUDVisibility", "onHUDVisibilityChange")
	self.targets.playerNameText.gameObject.SetActive(false)

	print("<color=lightblue>[Custom HUD]Initialized Player Name Module v1.3.0 </color>")
end

function CustomHUD_PlayerName:SetText()
	local configString = self.script.mutator.GetConfigurationString("displayName")
	local isPirate = (Player.actor.name == "Unknown Player" or not GameManager.isLegitimate)

	if not isPirate then
		if configString == "" then
			self.playerName = Player.actor.name
		else
			self.playerName = configString
		end
	elseif isPirate then
		print("<color=red>PIRATE</color>")
		if configString == "" then
			self.playerName = "Pirate"
		else
			self.playerName = "Nice Try"
		end
	end
	
	self.targets.playerNameText.text = self.playerName

	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	if self.dataContainer and Player.actor.team ~= Team.Neutral then
		if self.dataContainer.GetBool("useTeamColor") then
			local colorVector = nil
			if Player.actor.team == Team.Blue then
				colorVector = self.dataContainer.GetVector("blueTeamColor")
			elseif Player.actor.team == Team.Red then
				colorVector = self.dataContainer.GetVector("redTeamColor")
			end
			self.targets.playerNameText.color = Color(colorVector.x/255, colorVector.y/255, colorVector.z/255, 1)
		end
	end
end

function CustomHUD_PlayerName:monitorHUDVisibility()
	return GameManager.hudPlayerEnabled
end

function CustomHUD_PlayerName:onHUDVisibilityChange()
	self.targets.playerNameText.gameObject.SetActive(not Player.actor.isDead and GameManager.hudPlayerEnabled and self.playerNameVisibility)
end

function CustomHUD_PlayerName:onActorSpawn(actor)
	if actor.isPlayer then
		self.targets.playerNameText.gameObject.SetActive(GameManager.hudPlayerEnabled and self.playerNameVisibility)
	end
end

function CustomHUD_PlayerName:onActorDied(actor,source,isSilent)
	if actor.isPlayer then
		self.targets.playerNameText.gameObject.SetActive(false)
	end
end