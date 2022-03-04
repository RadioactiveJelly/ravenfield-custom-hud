-- Register the behaviour
behaviour("MWHUD_ScoreSystem")

function MWHUD_ScoreSystem:Start()
	-- Run when behaviour is created

	self.systemEnabled = self.script.mutator.GetConfigurationBool("scoreSystemEnabled")

	self.totalPoints = 0
	self.streakPoints = 0

	self.isInStreak = false
	self.streakLifetime = 2.5

	self.pointsText = self.targets.PointsText
	self.canvasGroup = self.targets.CanvasGroup
	self.bonusText = self.targets.BonusText
	self.scale = 2
	self.alpha = 1
	self.timeBeforeDecay = 1.5

	self.hasSpawnedOnce = false
	self.matchFinished = false
	self.canvasGroup.alpha = 0
	self.bonusText.text = ""
	self.pointsText.text = ""

	if self.systemEnabled then
		GameEvents.onActorDied.AddListener(self,"onActorDied")
		GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")
		GameEvents.onCapturePointCaptured.AddListener(self,"onCapturePointCaptured")
		GameEvents.onCapturePointNeutralized.AddListener(self,"onCapturePointNeutralized")
		GameEvents.onMatchEnd.AddListener(self,"onMatchEnd")
		print("<color=lime>[MW HUD]Initialized Score System v1.0.0</color>")
	end
	self.script.AddValueMonitor("monitorHUDVisibility", "onHUDVisibilityChange")
end

function MWHUD_ScoreSystem:Update()
	if self.enasystemEnabledbled == false then
		return
	end

	if self.isInStreak then
		if self.streakLifetime > 0 then
			self.streakLifetime = self.streakLifetime - Time.deltaTime
		else
			self.isInStreak = false
			self.totalPoints =  self.totalPoints + self.streakPoints
			if self.matchFinished == false then
				self.pointsText.text = "Total: " .. self.totalPoints
			else
				self.pointsText.text = "Final Score: " .. self.totalPoints
				local finalScoreText = self.targets.FinalText
				finalScoreText.text = "Final Score: " .. self.totalPoints
			end
			self.streakPoints = 0
			self.timeBeforeDecay = 1.5
			self.bonusText.text = ""
			self.scale = 2
		end
	else
		if self.timeBeforeDecay <= 0 then
			if self.alpha > 0 then
				self.canvasGroup.alpha = self.alpha
				self.alpha = self.alpha - Time.deltaTime * 1
			end
		else
			self.timeBeforeDecay = self.timeBeforeDecay - Time.deltaTime
		end
	end

	if self.scale > 1 then
		self.scale = self.scale - (Time.deltaTime * 5)
		if self.scale < 1 then
			self.scale = 1
		end
		self.pointsText.gameObject.transform.localScale = Vector3(self.scale, self.scale, 0)
	end
end

function MWHUD_ScoreSystem:onActorDied(actor, source, isSilent)
	if source == nil then
		return
	end

	if source.isPlayer and actor.team ~= Player.actor.team then
		local capPoint = Player.actor.currentCapturePoint
		local message = ""
		local bonus = 0


		if ActorManager.ActorDistanceToPlayer(actor) >= 50 then
			bonus = 25
			message = "Longshot"
		end

		if capPoint then
			if capPoint.owner == Player.actor.team then
				bonus = bonus + 10
				if message == "" then
					message = "Defensive Kill!"
				else
					message = message .. "\nDefensive Kill!"
				end
			else
				bonus = bonus + 25
				if message == "" then
					message = "Offensive Kill!"
				else
					message = message .. "\nOffense Kill!"
				end
			end
		else
			if message ~= "" then
				message = message .. "!"
			end
		end
		self:Score(50 + bonus, message)
	end
end

function MWHUD_ScoreSystem:onCapturePointCaptured(capturePoint, newOwner)
	if self.hasSpawnedOnce and not Player.actor.isDead then
		if Player.actor.currentCapturePoint == capturePoint and Player.actor.team == newOwner then
			self:Score(250, "Point Captured!")
		end
	end
end

function MWHUD_ScoreSystem:onCapturePointNeutralized(capturePoint, previousOwner)
	if self.hasSpawnedOnce and not Player.actor.isDead then
		if Player.actor.currentCapturePoint == capturePoint and Player.actor.team ~= previousOwner then
			self:Score(250, "Point Neutralized!")
		end
	end
end

function MWHUD_ScoreSystem:onActorSpawn(actor)
	if(actor == Player.actor) then
		self.hasSpawnedOnce = true
	end
end

function MWHUD_ScoreSystem:Score(score, message)
	if self.matchFinished then
		return
	end

	self.isInStreak = true
	
	self.bonusText.text = message
	self.streakPoints = self.streakPoints + score
	self.pointsText.text = "+" .. self.streakPoints
	self.streakLifetime = 2.5
	self.canvasGroup.alpha = 1
	self.scale = 2
	self.alpha = 1
end

function MWHUD_ScoreSystem:onMatchEnd(team)
	self:MatchEnd(team)
end

function MWHUD_ScoreSystem:MatchEnd(team)
	if Player.actor.team == team then
		self:Score(2500, "Victory!")
	end
	
	self.matchFinished = true
end

function MWHUD_ScoreSystem:monitorHUDVisibility()
	return GameManager.hudPlayerEnabled
end

function MWHUD_ScoreSystem:onHUDVisibilityChange()
	self.targets.Canvas.enabled = GameManager.hudPlayerEnabled
	self.targets.FinalText.gameObject.SetActive(GameManager.hudPlayerEnabled and self.matchFinished)
end