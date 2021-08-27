-- Register the behaviour
behaviour("CustomHUD_PlayerName")

function CustomHUD_PlayerName:Start()
	-- Run when behaviour is created
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
	if self.dataContainer then
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

	print("<color=lightblue>[Custom HUD]Initialized Player Name Module v1.2.0 </color>")
end

