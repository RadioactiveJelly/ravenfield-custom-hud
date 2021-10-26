-- Register the behaviour
behaviour("CustomHUD_SimpleCompass")

function CustomHUD_SimpleCompass:Start()
	-- Run when behaviour is created
	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	if self.dataContainer then
		if self.dataContainer.GetBool("useTeamColor") then
			local colorVector = nil
			if Player.actor.team == Team.Blue then
				colorVector = self.dataContainer.GetVector("blueTeamColor")
			elseif Player.actor.team == Team.Red then
				colorVector = self.dataContainer.GetVector("redTeamColor")
			end
			self.targets.NorthText.color = Color(colorVector.x/255, colorVector.y/255, colorVector.z/255, 1)
		end
	end

	print("<color=lightblue>[Custom HUD]Initialized Simple Compass Module v1.0.0 </color>")
end

function CustomHUD_SimpleCompass:Update()
	-- Run every frame
	local anglePlayer = PlayerCamera.fpCamera.transform.eulerAngles.y
	local rotation = Quaternion.Euler(0,0,anglePlayer)
	self.targets.Compass.transform.localRotation = rotation
end
