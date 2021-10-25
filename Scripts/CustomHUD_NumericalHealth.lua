-- Register the behaviour
behaviour("CustomHUD_NumericalHealth")

function CustomHUD_NumericalHealth:Start()
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")
	self.script.AddValueMonitor("monitorCurrentHealth","onHealthChanged")
	self.maxHealth = 100

	local enhancedHealthObj = self.gameObject.Find("EnhancedHealth")
	if enhancedHealthObj then
		self.enhancedHealth = enhancedHealthObj.GetComponent(ScriptedBehaviour)
	end

	self.doColorChange = true

	print("<color=lightblue>[Custom HUD]Initialized Numerical Health Module v1.0.0 </color>")
end

function CustomHUD_NumericalHealth:monitorCurrentHealth()
	return Player.actor.health
end

function CustomHUD_NumericalHealth:onHealthChanged()
	local health = Mathf.Ceil(Player.actor.health)
	health = Mathf.Clamp(health,0,999)
	self.targets.HealthText.text = health

	--[[if health <= self.lowHealthThreshold then
		local c = health/self.lowHealthThreshold
		local color = Color(1,c,c,1)
		self.targets.HealthText.color = color
	else
		self.targets.HealthText.color = Color.white
	end]]--
	if self.doColorChange then
		local c = health/self.maxHealth
		local color = Color(1,c,c,1)
		self.targets.HealthText.color = color
	end
end

function CustomHUD_NumericalHealth:onActorSpawn()
	if self.enhancedHealth then
		self.maxHealth = self.enhancedHealth.self.maxHP
	end
end