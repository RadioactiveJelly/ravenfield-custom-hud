-- Register the behaviour
behaviour("CustomHUD_OverlayReplacer")

function CustomHUD_OverlayReplacer:Start()
	-- Run when behaviour is created
	local overlayGO = GameObject.Find("Overlay Text").gameObject
	self.overlayText = overlayGO.GetComponentInChildren(Text)
	self.overlayText.color = Color(0,0,0,0)
	self.overlayText.supportRichText = false

	self.hasSpawned = false

	self.lifeTime = 1

	self.script.AddValueMonitor("monitorOverlayText", "onOverlayTextChange")
end

function CustomHUD_OverlayReplacer:Update()
	-- Run every frame


	if Input.GetKeyDown(KeyCode.O) then
		Overlay.ShowMessage("This is a test!", 5)
	end

	if Input.GetKeyDown(KeyCode.I) then
		Overlay.ShowMessage("This is a test!2", 5)
	end
end

function CustomHUD_OverlayReplacer:monitorOverlayText()
	return self.overlayText.text
end

function CustomHUD_OverlayReplacer:onOverlayTextChange()
	self:UpdateText(self.overlayText.text)
end

function CustomHUD_OverlayReplacer:UpdateText(text)
	self.lifeTime = 1
	print(text)
end
