-- Register the behaviour
behaviour("CustomHUD_DamageIndicatorManager")

function CustomHUD_DamageIndicatorManager:Start()
	-- Run when behaviour is created
	Player.actor.onTakeDamage.AddListener(self,"onTakeDamage")

	self.liveIndicators = {}
	--self.pooledIndicators = {}

	self.indicatorPrefab = self.targets.DataContainer.GetGameObject("Indicator")

	self.affectedTeamActors = ActorManager.GetActorsOnTeam(Player.actor.team)

	GameObject.Find("Damage Indicator Mask").gameObject.SetActive(false)
end

function CustomHUD_DamageIndicatorManager:Update()
	-- Run every frame

	--[[if Input.GetKeyDown(KeyCode.T) then
		for i = 1, #self.affectedTeamActors, 1 do
			if not self.affectedTeamActors[i].isPlayer and not self.affectedTeamActors[i].isDead then
				print(self.affectedTeamActors[i].name)
				Player.actor.Damage(self.affectedTeamActors[i], 25, 0, false, false)
			end
		end
	end]]--


	for botName, indicator in pairs(self.liveIndicators) do
		indicator.self:Tick(Player.actor.isDead)
		if indicator.self.isDead then
			self.liveIndicators[botName] = nil
			GameObject.Destroy(indicator.gameObject)
		end
	end
end

function CustomHUD_DamageIndicatorManager:onTakeDamage(actor, source, info)
	if source and source ~= Player.actor and not Player.actor.isDead then
		self:CreateIndicator(source ,source.position)
	end
end

function CustomHUD_DamageIndicatorManager:CreateIndicator(source ,targetPos)
	local indicator = nil
	if self.liveIndicators[source.name] then
		indicator = self.liveIndicators[source.name]
	else
		--[[if #self.pooledIndicators > 0 then
			indicator = table.remove(self.pooledIndicators, #self.pooledIndicators)
		else
			indicator = GameObject.Instantiate(self.indicatorPrefab).GetComponent(ScriptedBehaviour)
			indicator.gameObject.transform.SetParent(self.gameObject.transform, false)
		end]]--
		indicator = GameObject.Instantiate(self.indicatorPrefab).GetComponent(ScriptedBehaviour)
		indicator.gameObject.transform.SetParent(self.gameObject.transform, false)
		self.liveIndicators[source.name] = indicator
	end
	indicator.self:Init(targetPos)
end