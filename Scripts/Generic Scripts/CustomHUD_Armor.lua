-- Register the behaviour
behaviour("CustomHUD_Armor")

function CustomHUD_Armor:Start()
	self.armorText = self.targets.armorText
	self.armorPlateText = self.targets.armorPlateText
	self.script.StartCoroutine(self:DelayedStart())
end

function CustomHUD_Armor:DelayedStart()
	return function()
		coroutine.yield(WaitForSeconds(0.1))
		local armorObj = self.gameObject.Find("PlayerArmor")
		if armorObj then
			self.playerArmor = armorObj.GetComponent(ScriptedBehaviour)
			self.playerArmor.self:DisableHUD()
			self.script.AddValueMonitor("monitorCurrentArmorHealth","onArmorHealthChanged")
			self.script.AddValueMonitor("monitorCurrentArmorPlates","onArmorPlateCountChanged")
			GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")
			self.displayValue = self.playerArmor.self.armorHealth
		else
			self.armorText.text =  "---"
			self.armorPlateText.text = "-"
		end
	end
end

function CustomHUD_Armor:Update()
	if self.playerArmor then
		if self.playerArmor.self.armorHealth > self.displayValue then
			self.displayValue = self.displayValue + (Time.deltaTime * 100)
			if self.displayValue > self.playerArmor.self.armorHealth then
				self.displayValue = self.playerArmor.self.armorHealth
			end
			self.armorText.text = Mathf.Ceil(self.displayValue)
		end
	end
end

function CustomHUD_Armor:monitorCurrentArmorHealth()
	return self.playerArmor.self.armorHealth
end

function CustomHUD_Armor:onArmorHealthChanged()
	local health = Mathf.Ceil(self.playerArmor.self.armorHealth)
	health = Mathf.Clamp(health,0,999)
	if health < self.displayValue then
		self.displayValue = health
		self.armorText.text = self.displayValue
	end
end

function CustomHUD_Armor:monitorCurrentArmorPlates()
	return self.playerArmor.self.currentArmorPlateCount
end

function CustomHUD_Armor:onArmorPlateCountChanged()
	self.armorPlateText.text = self.playerArmor.self.currentArmorPlateCount
end

function CustomHUD_Armor:onActorSpawn(actor)
	if(actor.isPlayer) then
		local health = Mathf.Ceil(self.playerArmor.self.armorHealth)
		health = Mathf.Clamp(health,0,999)
		self.armorText.text = health
		self.displayValue = health

		self.armorPlateText.text = self.playerArmor.self.currentArmorPlateCount
	end
end