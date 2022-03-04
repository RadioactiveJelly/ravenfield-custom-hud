-- Register the behaviour
behaviour("CustomHUD_Stance")

function CustomHUD_Stance:Start()
	-- Run when behaviour is created
	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	self.script.AddValueMonitor("MonitorProne", "UpdateStance")
	self.script.AddValueMonitor("MonitorCrouch", "UpdateStance")

	if self.dataContainer and Player.actor.team ~= Team.Neutral then
		if self.dataContainer.GetBool("useTeamColors") then
			local colorVector = nil
			if Player.actor.team == Team.Blue then
				colorVector = self.dataContainer.GetVector("blueTeamColor")
			elseif Player.actor.team == Team.Red then
				colorVector = self.dataContainer.GetVector("redTeamColor")
			end
			self.targets.stanceImage.color = Color(colorVector.x/255, colorVector.y/255, colorVector.z/255, 1)
		end
	end
	print("<color=lightblue>[Custom HUD]Initialized Stance Module v1.0.0 </color>")
end

function CustomHUD_Stance:MonitorProne()
	return Player.actor.isProne
end

function CustomHUD_Stance:MonitorCrouch()
	return Player.actor.isCrouching
end

function CustomHUD_Stance:UpdateStance()
	if Player.actor.isProne then
		self.targets.stanceImage.sprite = self.dataContainer.GetSprite("proning")
	elseif Player.actor.isCrouching then
		self.targets.stanceImage.sprite = self.dataContainer.GetSprite("crouching")
	else
		self.targets.stanceImage.sprite = self.dataContainer.GetSprite("standing")
	end
end