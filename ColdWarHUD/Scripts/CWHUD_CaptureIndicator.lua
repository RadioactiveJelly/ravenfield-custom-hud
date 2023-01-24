-- Register the behaviour
behaviour("CWHUD_CaptureIndicator")

function CWHUD_CaptureIndicator:Start()
	self.targets.capPointName.text = ""
	self.visibile = false

	self.targets.CanvasGroup.alpha = 0
	self.alpha = 0

	self.blueTeamColor = self.targets.ColorData.GetColor("blueTeamColor")
	self.redTeamColor = self.targets.ColorData.GetColor("redTeamColor")
	self.neutralColor = self.targets.ColorData.GetColor("neutral")
end

function CWHUD_CaptureIndicator:Update()
	if Player.actor.currentCapturePoint then
		local capPoint = Player.actor.currentCapturePoint
		self.targets.capPointName.text = capPoint.name

		self.visible = true

		self:UpdateBar(capPoint)
	else
		self.visible = false
	end

	if self.visible then
		if(self.alpha < 1) then
			self.alpha = self.alpha + (Time.deltaTime * 2)
		end
	else
		if(self.alpha > 0) then
			self.alpha = self.alpha - (Time.deltaTime * 2)
		end
	end

	
	self.targets.CanvasGroup.alpha = self.alpha
end

function CWHUD_CaptureIndicator:UpdateBar(capturePoint)
	if capturePoint.pendingOwner == Team.Blue then
		self.targets.fill.color = self.blueTeamColor
	else
		self.targets.fill.color = self.redTeamColor
	end
	self.targets.fill.fillAmount = capturePoint.captureProgress

	if capturePoint.owner == Team.Blue then
		self.targets.flag.color = self.blueTeamColor
	elseif capturePoint.owner == Team.Red then
		self.targets.flag.color = self.redTeamColor
	else
		self.targets.flag.color = self.neutralColor
	end
end

function CWHUD_CaptureIndicator:UpdateState(capturePoint)
	local state = ""
	if capturePoint.owner ~= Player.actor.team then
		state = capturePoint.isContested and "Contested!" or "Capturing!"
	else
		state = "Captured!"
	end
	self.targets.State.text = state
end