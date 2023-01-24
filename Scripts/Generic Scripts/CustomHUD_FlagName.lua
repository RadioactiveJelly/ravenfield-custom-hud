-- Register the behaviour
behaviour("CustomHUD_FlagName")

function CustomHUD_FlagName:Start()
	self.targets.capPointName.text = ""
	self.lastCapPoint = nil
end

function CustomHUD_FlagName:Update()
	-- Run every frame
	if Player.actor.currentCapturePoint and Player.actor.currentCapturePoint ~= self.lastCapPoint then
		local capPoint = Player.actor.currentCapturePoint
		self.targets.capPointName.text = capPoint.name
		self.lastCapPoint = capPoint
	elseif Player.actor.currentCapturePoint == nil then
		self.targets.capPointName.text = ""
		self.lastCapPoint = nil
	end
end
