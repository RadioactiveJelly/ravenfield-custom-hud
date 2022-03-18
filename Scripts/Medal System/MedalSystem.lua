-- Register the behaviour
behaviour("MedalSystem")

function MedalSystem:Awake()
	self.gameObject.name = "Medal System"
	self.medalQueue = {}
end

function MedalSystem:Start()
	-- Run when behaviour is created
	GameEvents.onActorDied.AddListener(self,"onActorDied")

	--Kill Medals
	self.killStreak = 0
	self.lastKillStreak = ""

	self.actors = ActorManager.actors
	for i = 1, #self.actors, 1 do
		if not self.actors[i].isPlayer then
			self.actors[i].onTakeDamage.AddListener(self,"onTakeDamage")
		end
	end

	self.timeForRapidKills = 5
	self.rapidKillsTimer = 0
	self.rapidKills = 0

	local scoreSystemObj = self.gameObject.Find("ScoreSystem")
	if scoreSystemObj then
		self.scoreSystem = scoreSystemObj.GetComponent(ScriptedBehaviour)
	end
end

function MedalSystem:Update()
	
	--[[if(Input.GetKeyDown(KeyCode.O)) then
		self.killStreak = self.killStreak + 1
		self:CheckStreak()
	end]]--

	if(self.rapidKillsTimer > 0) then
		self.rapidKillsTimer = self.rapidKillsTimer - Time.deltaTime
		if(self.rapidKillsTimer <= 0) then
			self:EvaluateRapidKills()
			self.rapidKills = 0
		end
	end
end

function MedalSystem:onActorDied(actor, source, isSilent)
	if actor.isPlayer then
		self.killStreak = 0
		self.lastKillStreak = ""
	end

	if source then
		if source.isPlayer and actor.team ~= source.team then
			self.killStreak = self.killStreak + 1
			self:CheckStreak()
			self.rapidKillsTimer = self.timeForRapidKills
			self.rapidKills = self.rapidKills + 1
		end
	end
end

function MedalSystem:CheckStreak()
	local streak = self.killStreak
	if streak >= 31 then
		self:GenerateMedal("Unstoppable", "KillStreak", 100, 0)
	elseif streak == 30 then
		self:GenerateMedal("Nuclear", "KillStreak", 0, 0.2)
	elseif streak == 25 then
		self:GenerateMedal("Brutal", "KillStreak", 0, 0.2)
	elseif streak == 20 then
		self:GenerateMedal("Relentless", "KillStreak", 0, 0.2)
	elseif streak == 15 then
		self:GenerateMedal("Ruthless", "KillStreak", 0, 0.2)
	elseif streak == 10 then
		self:GenerateMedal("Merciless", "KillStreak", 0, 0.2)
	elseif streak == 5 then
		self:GenerateMedal("Bloodthirsty", "KillStreak", 500, 0)
	end
end

function MedalSystem:EvaluateRapidKills()
	local rapidKills = self.rapidKills
	local medalType = "RapidKills"

	local bonusPoints = 0

	if rapidKills >= 9 then
		self:GenerateMedal("KillChain", medalType, 1000, 0)
	elseif rapidKills >= 8 then
		self:GenerateMedal("OctaChain", medalType, 800, 0)
	elseif rapidKills >= 7 then
		self:GenerateMedal("HeptaChain", medalType, 700, 0)
	elseif rapidKills >= 6 then
		self:GenerateMedal("HexaChain", medalType, 600, 0)
	elseif rapidKills >= 5 then
		self:GenerateMedal("PentaChain", medalType, 500, 0)
	elseif rapidKills >= 4 then
		self:GenerateMedal("QuadChain", medalType, 400, 0)
	elseif rapidKills >= 3 then
		self:GenerateMedal("TripleChain", medalType, 300, 0)
	elseif rapidKills >= 2 then
		self:GenerateMedal("DoubleChain", medalType, 200, 0)
	end
end

function MedalSystem:RemoveTopMedal()
	table.remove(self.medalQueue,1)
end

function MedalSystem:onTakeDamage(actor, source, info)
	if actor.isDead then
		return
	end

	if source and source.isPlayer and source.team ~= actor.team then
		if info.isCriticalHit and not info.isSplashDamage then
			if info.healthDamage >= actor.health then
				self:GenerateMedal("Headshot", "Kill", 100, 0)
			end
		end
		if info.healthDamage >= actor.health then
			if ActorManager.ActorDistanceToPlayer(actor) >= 50 and not info.isSplashDamage then
				self:GenerateMedal("Longshot", "Kill", 50, 0)
			end
		end
		
	end
end

function MedalSystem:GenerateMedal(medalName, medalType, bonusPoints, multiplierBonus)

	local medalData = {}
	medalData.medalType = medalType
	medalData.medalName = medalName
	medalData.bonusPoints = bonusPoints
	medalData.multiplierBonus = multiplierBonus

	if self.scoreSystem then
		if bonusPoints > 0 then
			self.scoreSystem.self:AddScore(bonusPoints, true, false)
		end
		
		if multiplierBonus > 0 then
			self.scoreSystem.self:AddMultiplier(multiplierBonus)
		end
	end

	table.insert(self.medalQueue, medalData)

end