-- Register the behaviour
behaviour("CustomHUD_QuickThrow")

function CustomHUD_QuickThrow:Start()
	-- Run when behaviour is created

	self.slots = {}
	self.txtCounts = {}
	self.sprites = {}
	self.keyBindTxts = {}

	self.slots[0] = self.targets.Slot1GO
	self.slots[1] = self.targets.Slot2GO
	self.slots[2] = self.targets.Slot3GO

	self.slots[0].SetActive(false)
	self.slots[1].SetActive(false)
	self.slots[2].SetActive(false)

	self.txtCounts[0] = self.targets.Slot1Count
	self.txtCounts[1] = self.targets.Slot2Count
	self.txtCounts[2] = self.targets.Slot3Count

	self.sprites[0] = self.targets.Slot1Sprite
	self.sprites[1] = self.targets.Slot2Sprite
	self.sprites[2] = self.targets.Slot3Sprite

	self.keyBindTxts[0] = self.targets.Slot1KeyBind
	self.keyBindTxts[1] = self.targets.Slot2KeyBind
	self.keyBindTxts[2] = self.targets.Slot3KeyBind

	self.targets.ThrowModeText.gameObject.SetActive(false)

	self.throwModeText = self.targets.ThrowModeText

	self.script.StartCoroutine(self:ReplaceQuickThrowHUD())

	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	self:TeamColor()
	print("<color=lightblue>[Custom HUD]Initialized Quick Throw Override Module v1.0.0 </color>")
end

function CustomHUD_QuickThrow:ReplaceQuickThrowHUD()
	return function()
		coroutine.yield(WaitForSeconds(0.25))
		local quickThrowObj = self.gameObject.find("QuickThrow")
		if quickThrowObj then
			self.quickThrow = quickThrowObj.GetComponent(ScriptedBehaviour)
			if self.quickThrow then
				self.quickThrow.self:ReplaceHUD(self)
			end
		end
	end
end

function CustomHUD_QuickThrow:TeamColor()
	if self.dataContainer and Player.actor.team ~= Team.Neutral then
		if self.dataContainer.GetBool("useTeamColors") then
			local colorVector = nil
			if Player.actor.team == Team.Blue then
				colorVector = self.dataContainer.GetVector("blueTeamColor")
			elseif Player.actor.team == Team.Red then
				colorVector = self.dataContainer.GetVector("redTeamColor")
			end
			self.sprites[0].color = Color(colorVector.x/255, colorVector.y/255, colorVector.z/255, 1)
			self.sprites[1].color = Color(colorVector.x/255, colorVector.y/255, colorVector.z/255, 1)
			self.sprites[2].color = Color(colorVector.x/255, colorVector.y/255, colorVector.z/255, 1)
		end
	end
end