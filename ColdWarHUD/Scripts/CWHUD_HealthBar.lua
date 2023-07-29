-- Register the behaviour
behaviour("CWHUD_HealthBar")

function CWHUD_HealthBar:Start()
	GameEvents.onActorDied.AddListener(self,"onActorDied")
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")

	self.targets.Canvas.enabled = false

	local enhancedHealthObj = self.gameObject.Find("EnhancedHealth")
	if enhancedHealthObj then
		self.enhancedHealth = enhancedHealthObj.GetComponent(ScriptedBehaviour)
	end

	self.maxHP = Player.actor.maxHealth
	
	self.script.AddValueMonitor("monitorCurrentHealth","updateHealthUI")
	self.script.AddValueMonitor("monitorCurrentMaxHealth", "updateHealthUI")
	
	self.healthBarVisibility = self.script.mutator.GetConfigurationBool("healthBarVisibility")

	self.lastHPScale = 1.0
	self.healthLineScale = 1.0
	self.healthLineRectTransform = self.targets.healthLine.gameObject.GetComponent(RectTransform)

	self.delayedBarAlpha = 1.5

	self.flashTime = 0

	self.script.AddValueMonitor("monitorHUDVisibility", "onHUDVisibilityChange")
end

function CWHUD_HealthBar:monitorHUDVisibility()
	return PlayerHud.hudPlayerEnabled
end

function CWHUD_HealthBar:onHUDVisibilityChange()
	self.targets.Canvas.enabled = not Player.actor.isDead and GameManager.hudPlayerEnabled and self.healthBarVisibility
end

function CWHUD_HealthBar:monitorCurrentHealth()
	return Player.actor.health
end

function CWHUD_HealthBar:monitorCurrentMaxHealth()
	return Player.actor.maxHealth
end

function CWHUD_HealthBar:monitorEHSMaxHealth()
	return self.enhancedHealth.self.maxHP
end

function CWHUD_HealthBar:monitorEHSOverHeal()
	return self.enhancedHealth.self.overHealMax
end

function CWHUD_HealthBar:updateHealthUI()
	if Player.actor then
		if self.targets.healthFill then
			local hpScale = Player.actor.health/self.maxHP
			hpScale = Mathf.Clamp(hpScale,0,1)
			local isLower = hpScale < self.lastHPScale
			self.lastHPScale = hpScale
			
			self.targets.healthFill.transform.localScale = Vector3(hpScale,1,1)
			if isLower then
				local xPos = hpScale*self.targets.rect.rect.width
				self.healthLineRectTransform.anchoredPosition = Vector2(xPos, 0)
				self.healthLineScale = 1.0
				self.targets.healthLine.transform.localScale = Vector3(1,self.healthLineScale,1)

				self.delayedBarAlpha = 1.5
				self.targets.DelayedFill.color = Color(1,0,0,self.delayedBarAlpha)
			else
				self.targets.DelayedFill.transform.localScale = Vector3(hpScale,1,1)
			end
			self.targets.LowHealthFlash.color = Color(1,0,0,0)
			self.flashTime = 0

			if self.enhancedHealth then
				self:updateOverHealBar()
			end
		end
	end
end

function CWHUD_HealthBar:updateOverHealBar()
	if Player.actor then
		if self.targets.overHealBar then
			local overheal = Player.actor.health - self.enhancedHealth.self.maxHP
			local overhealScale = overheal/(self.enhancedHealth.self.overHealCap - self.enhancedHealth.self.maxHP)
			overheal = Mathf.Clamp(overheal,0,1)
			self.targets.overHealBar.fillAmount = overhealScale
		end
	end
end

function CWHUD_HealthBar:onActorSpawn(actor)
	if actor.isPlayer then
		self.targets.Canvas.enabled = GameManager.hudPlayerEnabled and self.healthBarVisibility
		self.targets.CanvasGroup.alpha = 1.0
		self.lastHPScale = 1.0
		if self.enhancedHealth then
			self.maxHP = self.enhancedHealth.self.maxHP
		end
	end
end

function CWHUD_HealthBar:onActorDied(actor,source,isSilent)
	if actor.isPlayer then
		self.healthLineScale = 0
		self.targets.healthLine.transform.localScale = Vector3(1,0,1)
	end
end

function CWHUD_HealthBar:Update()
	 if(Input.GetKeyDown(KeyCode.T)) then
		Player.actor.damage(Player.actor,10,0, false ,false)
	 end

	 local hpScale = Player.actor.health/self.maxHP

	 --Healthline
	 if self.healthLineScale > 0 then
		self.healthLineScale = self.healthLineScale - (Time.deltaTime*2)
		self.healthLineScale = Mathf.Clamp(self.healthLineScale,0,1)
		self.targets.healthLine.transform.localScale = Vector3(1,self.healthLineScale,1)
	 end

	 --DelayedBar
	 if self.delayedBarAlpha > 0 then
		self.delayedBarAlpha = self.delayedBarAlpha - Time.deltaTime
		self.targets.DelayedFill.color = Color(1,0,0,self.delayedBarAlpha)
		if self.delayedBarAlpha <= 0 then
			self.targets.DelayedFill.transform.localScale = Vector3(hpScale,1,1)
		end
	end

	if hpScale <= 0.5 and self.delayedBarAlpha <= 0 then
		self.flashTime = self.flashTime + Time.deltaTime
		local pingPong = Mathf.PingPong(self.flashTime,1)
		self.targets.LowHealthFlash.color = Color(1,0,0,pingPong)
	end

	if Player.actor.isDead then
		self.targets.CanvasGroup.alpha = self.targets.CanvasGroup.alpha - Time.deltaTime
	end
end
