-- Register the behaviour
behaviour("CWHUD_KillFeed")

function CWHUD_KillFeed:Start()
	self.active = self.script.mutator.GetConfigurationBool("killFeedEnabled")
	if not self.active then return end


	GameEvents.onActorDiedInfo.AddListener(self, "onActorDied")
	GameEvents.onVehicleDisabled.AddListener(self, "onVehicleDisabled")
	GameEvents.onVehicleDestroyed.AddListener(self, "onVehicleDestroyed")

	self.script.StartCoroutine(self:DelayedStart())

	self.messagePool = {}
	self.activeMessages = {}
	self.queuedMessages = {}
	self.instanceCount = 0

	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	self.messagePrefab = self.dataContainer.GetGameObject("KillMessage")
	self.killSFX = self.dataContainer.GetAudioClip("KillSound")

	self.blueTeamColor = self.targets.ColorData.GetColor("blueTeamColor")
	self.redTeamColor = self.targets.ColorData.GetColor("redTeamColor")

	self.blueTeamHexCode = self.targets.ColorData.GetString("blueTeamHex")
	self.redTeamHexCode = self.targets.ColorData.GetString("redTeamHex")

	if GameManager.buildNumber <= 26 then
		GameObject.Find("Kill Indicator (1)").gameObject.SetActive(false)
		GameObject.Find("Kill Indicator (2)").gameObject.SetActive(false)
		GameObject.Find("Kill Indicator").gameObject.SetActive(false)
		GameObject.Find("Kill Indicator Parent Panel").gameObject.SetActive(false)
	else
		PlayerHud.HideUIElement(UIElement.KillFeed)
	end
	
end

function CWHUD_KillFeed:DelayedStart()
	return function()
		coroutine.yield(WaitForSeconds(0.1))
		local scoreSystemObj = self.gameObject.Find("Score System")
		if scoreSystemObj then
			self.scoreSystem = scoreSystemObj.GetComponent(ScriptedBehaviour)
			self.scoreSystem.self:DisableDefaultHUD()
			self.enabled = true
		end
	end
end

function CWHUD_KillFeed:Update()
	if not self.active then return end
	
	for i = 1, #self.activeMessages, 1 do
		local message = self.activeMessages[i]
		message.self:Tick()
	end

	--Clean "dead" messages
	if #self.activeMessages > 0 and self.activeMessages[#self.activeMessages].self.isDead then
		local oldestMessage = table.remove(self.activeMessages, #self.activeMessages)
		oldestMessage.gameObject.transform.SetParent(self.targets.pool.transform, false)
		oldestMessage.self:Hide()
		print("Oldest message is: " .. oldestMessage.self.ID)
		table.insert(self.messagePool ,1 , oldestMessage)

		if #self.activeMessages == 0 then
			if self.scoreSystem then
				self.targets.multiplier.text = ""
			end
		end
	end
end

function CWHUD_KillFeed:RequestMessage()
	local messageToReturn = nil
	if #self.messagePool > 0 then 
		messageToReturn = table.remove(self.messagePool,1)
	else
		messageToReturn = GameObject.Instantiate(self.messagePrefab).GetComponent(ScriptedBehaviour)
		self.instanceCount = self.instanceCount + 1
		messageToReturn.self:SetID("Message Instance #" .. self.instanceCount)
	end

	messageToReturn.self:Init()
	return messageToReturn
end

function CWHUD_KillFeed:Push(message)
	message.gameObject.transform.SetParent(self.targets.feed.transform, false)
	table.insert(self.activeMessages,1,message)
	self:UpdatePositions()

	if #self.activeMessages > 5 then
		self.activeMessages[#self.activeMessages].self:Kill()
	end

	if self.scoreSystem and self.scoreSystem.self.scoreMultiplier > 1 then
		self.targets.multiplier.text = "Multiplier x" .. self.scoreSystem.self.scoreMultiplier
	end

	message.self:Show()
end

function CWHUD_KillFeed:UpdatePositions()
	for i = 1, #self.activeMessages, 1 do
		local message = self.activeMessages[i]
		message.transform.localPosition = Vector3(0, 60 - ((i-1)*30))
	end
end

function CWHUD_KillFeed:onActorDied(actor, info, silentKill)
	if actor.isPlayer then return end
	if info.sourceActor == nil then return end
	if not info.sourceActor.isPlayer then return end

	local actorName = actor.name
	local messageText = ""
	if actor.team == Team.Blue then
		actorName = "<color=" .. self.blueTeamHexCode .. ">" .. actorName .. "</color>"
	else
		actorName = "<color=" .. self.redTeamHexCode .. ">" .. actorName .. "</color>"
	end
	
	messageText = "Killed " .. actorName

	if self.scoreSystem then
		if actor.team ~= Player.actor.team then
			messageText = "+"..(self.scoreSystem.self.pointsPerKill * self.scoreSystem.self.scoreMultiplier) .. " " .. messageText
		end
	end

	local message = self:RequestMessage()
	message.self:SetText(messageText)

	self.targets.audioSource.PlayOneShot(self.killSFX)
	
	self:Push(message)
end

function CWHUD_KillFeed:onVehicleDisabled(vehicle, damageInfo)
	if damageInfo.sourceActor == nil then return end
	if not damageInfo.sourceActor.isPlayer then return end

	local vehicleName = vehicle.name

	if vehicle.team == 0 then
		vehicleName = "<color=" .. self.blueTeamHexCode .. ">" .. vehicleName .. "</color>"
	elseif vehicle.team == 1 then
		vehicleName = "<color=" .. self.redTeamHexCode .. ">" .. vehicleName .. "</color>"
	end

	local messageText = "Disabled " .. vehicleName

	local message = self:RequestMessage()
	message.self:SetText(messageText)

	self.targets.audioSource.PlayOneShot(self.killSFX)
	self:Push(message)
end

function CWHUD_KillFeed:onVehicleDestroyed(vehicle, damageInfo)
	if damageInfo.sourceActor == nil then return end
	if not damageInfo.sourceActor.isPlayer then return end

	local vehicleName = vehicle.name

	if vehicle.team == 0 then
		vehicleName = "<color=" .. self.blueTeamHexCode .. ">" .. vehicleName .. "</color>"
	elseif vehicle.team == 1 then
		vehicleName = "<color=" .. self.redTeamHexCode .. ">" .. vehicleName .. "</color>"
	end

	local messageText = "Destroyed " .. vehicleName

	local message = self:RequestMessage()
	message.self:SetText(messageText)

	self.targets.audioSource.PlayOneShot(self.killSFX)
	self:Push(message)
end