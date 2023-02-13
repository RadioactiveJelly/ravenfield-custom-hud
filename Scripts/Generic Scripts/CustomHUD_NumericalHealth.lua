-- Register the behaviour
behaviour("CustomHUD_NumericalHealth")

function CustomHUD_NumericalHealth:Start()
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")
	GameEvents.onActorDiedInfo.AddListener(self,"onActorDiedInfo")
	self.script.AddValueMonitor("monitorCurrentHealth","onHealthChanged")
	self.maxHealth = 100

	self.targets.Canvas.enabled = false

	local enhancedHealthObj = self.gameObject.Find("EnhancedHealth")
	if enhancedHealthObj then
		self.enhancedHealth = enhancedHealthObj.GetComponent(ScriptedBehaviour)
	end

	self.script.AddValueMonitor("monitorHUDVisibility", "onHUDVisibilityChange")

	self.dataContainer = self.gameObject.GetComponent(DataContainer)

	self.doColorChange = self.dataContainer.GetBool("colorChange")

	self.healthNumberVisibility = self.script.mutator.GetConfigurationBool("healthNumberVisibility")

	self.delayedUpdate = false
	self.displayValue = Player.actor.health

	print("<color=lightblue>[Custom HUD]Initialized Numerical Health Module v1.0.0 </color>")
end

function CustomHUD_NumericalHealth:monitorCurrentHealth()
	return Player.actor.health
end

function CustomHUD_NumericalHealth:monitorHUDVisibility()
	return PlayerHud.hudPlayerEnabled
end

function CustomHUD_NumericalHealth:onHUDVisibilityChange()
	self.targets.Canvas.enabled = not Player.actor.isDead and GameManager.hudPlayerEnabled and self.healthNumberVisibility
end

function CustomHUD_NumericalHealth:Update()
	if self.delayedUpdate then
		if self.displayValue > Player.actor.health then
			self.displayValue = self.displayValue - Time.deltaTime * 100
			if self.displayValue < 0 then
				self.displayValue = 0
			end
			self.targets.HealthText.text = Mathf.Ceil(self.displayValue)
		end
	end
end

function CustomHUD_NumericalHealth:onHealthChanged()
	local health = Mathf.Ceil(Player.actor.health)
	health = Mathf.Clamp(health,0,999)

	if self.delayedUpdate == false then
		self.targets.HealthText.text = health
	else
		if Player.actor.health > self.displayValue then
			self.targets.HealthText.text = health
			self.displayValue = health
		end
	end
	
	if self.doColorChange then
		local c = health/self.maxHealth
		local color = Color(1,c,c,1)
		self.targets.HealthText.color = color
	end
end

function CustomHUD_NumericalHealth:onActorSpawn(actor)
	if self.enhancedHealth then
		self.maxHealth = self.enhancedHealth.self.maxHP
	end
	if actor.isPlayer then
		if self.targets.Canvas then
			self.targets.Canvas.enabled = GameManager.hudPlayerEnabled and self.healthNumberVisibility
		end
		self.displayValue = Player.actor.health
		self.targets.HealthText.text = Player.actor.health
	end
end

function CustomHUD_NumericalHealth:onActorDiedInfo(actor, info, isSilent)
	if actor.isPlayer and self.targets.Canvas then
		self.targets.Canvas.enabled = false
	end
end