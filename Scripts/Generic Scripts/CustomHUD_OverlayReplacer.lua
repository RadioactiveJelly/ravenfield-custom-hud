-- Register the behaviour
behaviour("CustomHUD_OverlayReplacer")

function CustomHUD_OverlayReplacer:Start()
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")
	GameEvents.onCapturePointNeutralized.AddListener(self,"onCapturePointNeutralized")
	
	if GameManager.buildNumber <= 26 then
		local overlayGO = GameObject.Find("Overlay Text").gameObject
		self.vanillaOverlayText = overlayGO.GetComponentInChildren(Text)
		self.vanillaOverlayText.color = Color(0,0,0,0)
		self.vanillaOverlayText.supportRichText = false
		self.script.AddValueMonitor("monitorOverlayText", "deprecatedOnOverlayTextChange")
	else
		PlayerHud.HideUIElement(UIElement.OverlayText)
		GameEvents.onOverlayText.AddListener(self,"OnOverlayTextChange")
	end
	
	self.overlayText = self.targets.overlayText

	self.hasSpawned = false

	self.lifeTime = 1

	local bString = self.script.mutator.GetConfigurationString("blueTeamName")
	local rString = self.script.mutator.GetConfigurationString("redTeamName")

	if bString == "" then
		self.blueTeamName = "<color=white>The</color> Eagles"
	else
		self.blueTeamName = bString
	end
	
	if rString == "" then
		self.redTeamName = "<color=white>The</color> Ravens"
	else
		self.redTeamName = rString
	end 

	self.blueTeamHexCode = self.targets.colorData.GetString("blueTeamHex")
	self.redTeamHexCode = self.targets.colorData.GetString("redTeamHex")
	
	self.blueTeamColor = self.targets.colorData.GetColor("blueTeamColor")
	self.redTeamColor = self.targets.colorData.GetColor("redTeamColor")

	self.blueTeamText = "<color=" .. self.blueTeamHexCode .. ">" .. self.blueTeamName .. "</color>"
	self.redTeamText = "<color=" .. self.redTeamHexCode .. ">" .. self.redTeamName .. "</color>"

	self.targets.newOverlay.text = ""

	self.isValid = true
end

function CustomHUD_OverlayReplacer:Update()
	-- Run every frame
	if Input.GetKeyDown(KeyCode.O) then
		Overlay.ShowMessage("This is a test!", 5)
	end

	if Input.GetKeyDown(KeyCode.I) then
		Overlay.ShowMessage("This is a test!2", 5)
	end

	if self.lifeTime > 0 then
		self.lifeTime = self.lifeTime - Time.deltaTime
	else
		if self.lifeTime <= 0 then
			self.targets.canvasGroup.alpha = self.targets.canvasGroup.alpha -  (1.5 * Time.deltaTime)
		end
	end
end

function CustomHUD_OverlayReplacer:monitorOverlayText()
	return self.vanillaOverlayText.text
end

function CustomHUD_OverlayReplacer:deprecatedOnOverlayTextChange()
	self:UpdateText(self.vanillaOverlayText.text, 3)
end

function CustomHUD_OverlayReplacer:UpdateText(text, duration)
	if text == "" then
		return
	end
	self.lifeTime = duration
	print(duration)

	local formattedText = text

	if string.find(text, "<color=#0000FF>EAGLE</color>") then
		formattedText = string.gsub(text, "<color=#0000FF>EAGLE</color>", self.blueTeamText)
	elseif string.find(text, "<color=#FF0000>RAVEN</color>") then
		formattedText = string.gsub(text, "<color=#FF0000>RAVEN</color>", self.redTeamText)
	end

	formattedText = string.upper(formattedText)

	self.alpha = 1
	self.targets.canvasGroup.alpha = 1
	self.targets.newOverlay.text = formattedText
	print(formattedText)
end

function CustomHUD_OverlayReplacer:OnOverlayTextChange(text, duration)
	self:UpdateText(text, duration)
end

function CustomHUD_OverlayReplacer:onActorSpawn(actor)
	if(actor == Player.actor) then
		self.hasSpawnedOnce = true
	end
end

function CustomHUD_OverlayReplacer:onCapturePointNeutralized(capturePoint, previousOwner)
	if self.isValid and self.hasSpawnedOnce or Player.actor.team == Team.Neutral then
		local capturePointText = capturePoint.name
		if previousOwner == Team.Red then
			Overlay.ShowMessage("<color=#0000FF>EAGLE</color> NEUTRALIZED " .. capturePointText)
		else
			Overlay.ShowMessage("<color=#FF0000>RAVEN</color> NEUTRALIZED " .. capturePointText)
		end
	end
end