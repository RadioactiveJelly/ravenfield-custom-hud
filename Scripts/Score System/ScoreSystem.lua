-- Register the behaviour
behaviour("ScoreSystem")

function ScoreSystem:Awake()
	self.gameObject.name = "ScoreSystem"
end

function ScoreSystem:Start()
	GameEvents.onActorDied.AddListener(self,"onActorDied")

	self.pointsPerKill = 100
	self.totalPoints = 0
	self.scoreMultiplier = 1
	self.pointsHistory = {}
end

function ScoreSystem:Update()
	--[[if Input.GetKeyDown(KeyCode.O) then
		self:AddScore(100,false,true)
	end
	if Input.GetKeyDown(KeyCode.I) then
		self:AddMultiplier(1)
	end]]--
end

function ScoreSystem:onActorDied(actor, source, isSilent)
	if source.isPlayer and actor.team ~= Player.actor.team then
		self:AddScore(self.pointsPerKill, false, true)
	end

	if(actor.isPlayer) then
		self.scoreMultiplier = 1
	end
end

function ScoreSystem:AddMultiplier(val)
	self.scoreMultiplier = self.scoreMultiplier + val
end

function ScoreSystem:AddScore(score, flat, history)
	local earnedScore = 0
	if(flat) then
		earnedScore = score
	else
		earnedScore = score * self.scoreMultiplier
	end

	self.totalPoints = self.totalPoints + earnedScore

	if(history) then
		table.insert(self.pointsHistory, earnedScore)
	end
end
