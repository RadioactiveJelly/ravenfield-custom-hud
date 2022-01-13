-- Register the behaviour
behaviour("CustomHUD_OverlayReplacer")

function CustomHUD_OverlayReplacer:Start()
	-- Run when behaviour is created
	local overlayGO = GameObject.Find("Overlay Text").gameObject
	self.overlayText = overlayGO.GetComponent(Text)
	overlayGO.SetActive(false)

	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")

	self.replacementOverlayText = self.targets.Text

	self.lifeTime = 1
	self.replacementOverlayText.text = ""
end

function CustomHUD_OverlayReplacer:Update()
	-- Run every frame

	if self.lifeTime > 0 then
		self.lifeTime = self.lifeTime - Time.deltaTime
	else
		self.replacementOverlayText.text = ""
	end

	if Input.GetKeyDown(KeyCode.O) then
		Overlay.ShowMessage("This is a test!")
	end

end

function CustomHUD_OverlayReplacer:monitorOverlayText()
	return self.overlayText.text
end

function CustomHUD_OverlayReplacer:onOverlayTextChange()
	self:UpdateText(text)
end

function CustomHUD_OverlayReplacer:UpdateText(text)
	self.replacementOverlayText.text = text
	self.lifeTime = 1
end

function CustomHUD_OverlayReplacer:onActorSpawn(actor)
	if(actor == Player.actor) then
		if self.hasSpawned == false then
			self.hasSpawnedOnce = true
			self.script.AddValueMonitor("monitorOverlayText", "onOverlayTextChange")
		end
	end
end