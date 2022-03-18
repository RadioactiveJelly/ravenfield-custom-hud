-- Register the behaviour
behaviour("CustomHUD_HealthBar")

function CustomHUD_HealthBar:Start()
	GameEvents.onActorDied.AddListener(self,"onActorDied")
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")

	self.targets.Canvas.enabled = false

	local enhancedHealthObj = self.gameObject.Find("EnhancedHealth")
	if enhancedHealthObj then
		self.enhancedHealth = enhancedHealthObj.GetComponent(ScriptedBehaviour)
	end

	if self.enhancedHealth then
		self.script.AddValueMonitor("monitorCurrentHealth","updateHealthUIEnhanced")	
	else
		self.script.AddValueMonitor("monitorCurrentHealth","updateHealthUI")
		self.script.AddValueMonitor("monitorCurrentMaxHealth", "updateHealthUI")
	end
	
	self.healthBarVisibility = self.script.mutator.GetConfigurationBool("healthBarVisibility")

	self.script.AddValueMonitor("monitorHUDVisibility", "onHUDVisibilityChange")

	print("<color=lightblue>[Custom HUD]Initialized Health Bar Module v1.2.0 </color>")
end

function CustomHUD_HealthBar:monitorHUDVisibility()
	return PlayerHud.hudPlayerEnabled
end

function CustomHUD_HealthBar:onHUDVisibilityChange()
	self.targets.Canvas.enabled = not Player.actor.isDead and GameManager.hudPlayerEnabled and self.healthBarVisibility
end

function CustomHUD_HealthBar:monitorCurrentHealth()
	return Player.actor.health
end

function CustomHUD_HealthBar:monitorCurrentMaxHealth()
	return Player.actor.maxHealth
end

function CustomHUD_HealthBar:monitorEHSMaxHealth()
	return self.enhancedHealth.self.maxHP
end

function CustomHUD_HealthBar:monitorEHSOverHeal()
	return self.enhancedHealth.self.overHealMax
end

function CustomHUD_HealthBar:updateHealthUI()
	if Player.actor then
		if self.targets.healthBar then
			local hpScale = Player.actor.health/Player.actor.maxHealth
			self.targets.healthBar.fillAmount = hpScale
			if self.targets.animator then
				if hpScale <= 0.5 then
					self.targets.animator.SetBool("lowHealth", true)
				else
					self.targets.animator.SetBool("lowHealth", false)
					self.targets.redFlash.color = Color(1,0,0,0)
				end
			end
		end
	end
end

function CustomHUD_HealthBar:updateHealthUIEnhanced()
	if Player.actor then
		if self.targets.healthBar then
			local hpScale = Player.actor.health/self.enhancedHealth.self.maxHP
			hpScale = Mathf.Clamp(hpScale,0,1)
			self.targets.healthBar.fillAmount = hpScale
			if self.targets.animator then
				if hpScale <= 0.5 then
					self.targets.animator.SetBool("lowHealth", true)
				else
					self.targets.animator.SetBool("lowHealth", false)
					self.targets.redFlash.color = Color(1,0,0,0)
				end
			end
			self:updateOverHealBar()
		end
	end
end

function CustomHUD_HealthBar:updateOverHealBar()
	if Player.actor then
		if self.targets.overHealBar then
			local overheal = Player.actor.health - self.enhancedHealth.self.maxHP
			local overhealScale = overheal/(self.enhancedHealth.self.overHealCap - self.enhancedHealth.self.maxHP)
			overheal = Mathf.Clamp(overheal,0,1)
			self.targets.overHealBar.fillAmount = overhealScale
		end
	end
end

function CustomHUD_HealthBar:onActorSpawn(actor)
	if actor.isPlayer then
		self.targets.redFlash.color = Color(1,0,0,0)
		self.targets.Canvas.enabled = GameManager.hudPlayerEnabled and self.healthBarVisibility
	end
end

function CustomHUD_HealthBar:onActorDied(actor,source,isSilent)
	if actor.isPlayer then
		self.targets.Canvas.enabled = false
	end
end