-- Register the behaviour
behaviour("CWHUD_MedalDisplay")

function CWHUD_MedalDisplay:Start()
	self.script.StartCoroutine(self:DelayedStart())

	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	self.medalPrefab = self.dataContainer.GetGameObject("MedalPrefab")
	
	self.medalPos = self.targets.medalPos.transform.localPosition

	self.medalPool = {}
	self.activeMedals = {}
	self.medalQueue = {}

	self.instanceCount = 0
	
	self.cooldownTimer = 0
	self.cooldownValue = 0.4
end

function CWHUD_MedalDisplay:DelayedStart()
	return function()
		coroutine.yield(WaitForSeconds(0.1))
		local scoreSystemObj = self.gameObject.Find("Score System")
		if scoreSystemObj then
			local medalSystemObj = scoreSystemObj.transform.Find("Medal System")
			if medalSystemObj then
				self.medalSystem = medalSystemObj.gameObject.GetComponent(ScriptedBehaviour)
				self.medalSystem.self:DisableDefaultHUD()
			end
		end
	end
end

function CWHUD_MedalDisplay:Update()
	-- Run every frame
	if self.medalSystem == nil then return end

	
	if #self.medalSystem.self.medalQueue > 0  then
		if self.cooldownTimer > 0 then
			self.cooldownTimer = self.cooldownTimer - Time.deltaTime
		end
		if self.cooldownTimer <= 0 then
			local topRequest = self.medalSystem.self.medalQueue[1]

			if topRequest then
				local medal = self:RequestMedalPrefab()
				medal.self:Show()
				self:ProcessRequestData(medal,topRequest)
				self.targets.audioSource.Play()
				table.insert(self.activeMedals, 1, medal)
				self.cooldownTimer = self.cooldownValue

				self:UpdateActiveMedals()

				self.medalSystem.self:RemoveTopMedal()
			end
		end
	end
	
	for i = 1, #self.activeMedals, 1 do
		local medal = self.activeMedals[i]
		medal.self:Tick()
	end
end

function CWHUD_MedalDisplay:UpdateActiveMedals()
	if #self.activeMedals > 0  then
		for i = 1, #self.activeMedals, 1 do
			if i > 1 then
				local medal = self.activeMedals[i]
				if i > 3 then
					medal.self:Kill()
				else
					medal.self:StartShrink(self.cooldownValue-0.10)
				end
				local to = Vector3(self.medalPos.x + (165*(i-1)), self.medalPos.y+5, 0)
				local from = Vector3(self.medalPos.x + (165*(i-2)), self.medalPos.y, 0)
				medal.self:StartMoveTo(self.cooldownValue/2, from, to)
			end
		end

		local oldestMedal = self.activeMedals[#self.activeMedals]
		if oldestMedal.self.isDead then
			self.activeMedals[#self.activeMedals] = nil
			table.insert(self.medalPool, 1, oldestMedal)
		end
	end
end

function CWHUD_MedalDisplay:RequestMedalPrefab()
	if #self.medalPool > 0 then 
		local pooledMedal = table.remove(self.medalPool,1)
		pooledMedal.self:Init()
		pooledMedal.transform.localPosition = self.medalPos
		return pooledMedal
	end

	local newMedal = GameObject.Instantiate(self.medalPrefab).GetComponent(ScriptedBehaviour)
	self.instanceCount = self.instanceCount + 1
	newMedal.gameObject.transform.SetParent(self.gameObject.transform, false)
	newMedal.transform.localPosition = self.medalPos
	newMedal.self:Init()
	newMedal.self:SetText("Medal Instance #" .. self.instanceCount)
	return newMedal
end

function CWHUD_MedalDisplay:ProcessRequestData(medalDisplay, medalData)

	local medalName = ""
	if(medalData.medalType == "KillStreak") then
		medalDisplay.self:SetSprite(self.targets.killStreakMedals.GetSprite(medalData.medalName))
		medalName = medalData.medalName
	elseif(medalData.medalType == "Kill") then
		medalDisplay.self:SetSprite(self.targets.killMedals.GetSprite(medalData.medalName))
		medalName = medalData.medalName
	elseif(medalData.medalType == "Other") then
		medalDisplay.self:SetSprite(self.targets.otherMedals.GetSprite(medalData.medalName))
		medalName = medalData.medalName
	elseif(medalData.medalType == "RapidKills") then
		medalDisplay.self:SetSprite(self.targets.rapidKillMedals.GetSprite(medalData.medalName))
		medalName = self:GetRapidKillMedalName(medalData.medalName)
	end

	local bonusText = ""
	if medalData.bonusPoints > 0 and medalData.multiplierBonus == 0 then
		bonusText = "+" .. medalData.bonusPoints .. " points"
	elseif medalData.bonusPoints == 0 and medalData.multiplierBonus > 0 then
		bonusText = "Multiplier +" .. medalData.multiplierBonus
	end

	medalDisplay.self:SetText(medalName)
	medalDisplay.self:SetPointsText(bonusText)
end

function CWHUD_MedalDisplay:GetRapidKillMedalName(medalName)

	local toReturn = ""

	if medalName == "DoubleChain" then
		toReturn = "Double Kill"
	elseif medalName == "TripleChain" then
		toReturn = "Triple Kill"
	elseif medalName == "QuadChain" then
		toReturn = "Fury Kill"
	elseif medalName == "PentaChain" then
		toReturn = "Frenzy Kill"
	elseif medalName == "HexaChain" then
		toReturn = "Super Kill"
	elseif medalName == "HeptaChain" then
		toReturn = "Mega Kill"
	elseif medalName == "OctaChain" then
		toReturn = "Ultra Kill"
	elseif medalName == "KillChain" then
		toReturn = "Kill Chain"
	end	

	return toReturn
end