-- Register the behaviour
behaviour("CustomHUD_GameFeed")

function CustomHUD_GameFeed:Start()
	-- Run when behaviour is created
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")

	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	self.gameMessagePrefab = self.dataContainer.GetGameObject("GameMessagePrefab")

	self.maxLines = self.script.mutator.GetConfigurationRange("feedLimit")

	self.blueTeamHexCode = self.dataContainer.GetString("blueTeamHex")
	self.redTeamHexCode = self.dataContainer.GetString("redTeamHex")
	
	self.blueTeamColor = self.dataContainer.GetColor("blueTeamColor")
	self.redTeamColor = self.dataContainer.GetColor("redTeamColor")

	self.feedEnabled = self.script.mutator.GetConfigurationBool("feedEnabled")

	local bString = self.script.mutator.GetConfigurationString("blueTeamName")
	local rString = self.script.mutator.GetConfigurationString("redTeamName")

	if bString == "" then
		self.blueTeamName = "<color=white>The</color> Eagles"
	else
		self.blueTeamName = bString
	end
	
	if rString == "" then
		self.redTeamName = "<color=white>The</color> Ravens"
	else
		self.redTeamName = rString
	end 
	
	local showKills = self.script.mutator.GetConfigurationBool("displayKills")
	if showKills and self.feedEnabled then
		GameEvents.onActorDied.AddListener(self,"onActorDied")
	end

	local showCapturePointUpdates = self.script.mutator.GetConfigurationBool("showCapturePointUpdates")
	if showCapturePointUpdates and self.feedEnabled then
		GameEvents.onCapturePointCaptured.AddListener(self,"onCapturePointCaptured")
		GameEvents.onCapturePointNeutralized.AddListener(self,"onCapturePointNeutralized")
	end

	self.blueTeamText = "<color=" .. self.blueTeamHexCode .. ">" .. self.blueTeamName .. "</color>"
	self.redTeamText = "<color=" .. self.redTeamHexCode .. ">" .. self.redTeamName .. "</color>"

	self.hasSpawnedOnce = false


	local configString = self.script.mutator.GetConfigurationString("displayName")
	if configString == "" then
		self.playerName = Player.actor.name
	else
		self.playerName = configString
	end

	self.messageQueue = {}

	self.locked = false

	self.weaponSpriteScale = self.script.mutator.GetConfigurationFloat("weaponSpriteScale")

	print("<color=lightblue>[Custom HUD]Initialized Game Feed Module v1.0.0</color>")
end

function CustomHUD_GameFeed:Update()

	--[[if (Input.GetKeyDown(KeyCode.O)) then
		local newMessage = self.gameObject.Instantiate(self.gameMessagePrefab).GetComponent(ScriptedBehaviour)
		newMessage.self:InitVariables()
		newMessage.gameObject.transform.parent = self.gameObject.transform
		newMessage.gameObject.transform.localPosition = Vector3(322,0,0)

		newMessage.self:InitAsCaptureMessage("We captured a point!", Color.grey)

		self:PushMessage(newMessage)
	end]]--

	if #self.messageQueue > 0 and not self.locked then
		local topMessage = self.messageQueue[#self.messageQueue]
		if topMessage.self.isDead then
			table.remove(self.messageQueue,#self.messageQueue)
			GameObject.Destroy(topMessage.gameObject)
		end
	end
end


function CustomHUD_GameFeed:PushMessage(message)
	self.locked = true

	local bottomPos = 0

	if #self.messageQueue > 0 then
		local bottomMessage = self.messageQueue[1]
		bottomPos = bottomMessage.gameObject.transform.localPosition.y - 32
	end

	table.insert(self.messageQueue, 1, message)
	message.self:Show(bottomPos)
	for i = 1, #self.messageQueue, 1 do
		self.messageQueue[i].self:SetPosition(16 + (32 * i-1))
		if i > self.maxLines then
			self.messageQueue[i].self:Kill()
		end
	end
	self.locked = false
end

function CustomHUD_GameFeed:onActorDied(actor, source, isSilent)
	local actorName = actor.name
	if actor.isPlayer then
		actorName = self.playerName
	end
	local sourceName = ""
	local sourceWeapon = ""

	local newMessage = self.gameObject.Instantiate(self.gameMessagePrefab).GetComponent(ScriptedBehaviour)
	newMessage.self:InitVariables(self.weaponSpriteScale)
	newMessage.gameObject.transform.parent = self.gameObject.transform
	newMessage.gameObject.transform.localPosition = Vector3(322,0,0)

	if actor.team == Team.Blue then
		actorName = "<color=" .. self.blueTeamHexCode .. ">" .. actorName .. "</color>"
	else
		actorName = "<color=" .. self.redTeamHexCode .. ">" .. actorName .. "</color>"
	end

	if source then
		if source.isPlayer then
			sourceName = self.playerName
		else
			sourceName = source.name
		end

		if source.team == Team.Blue then
			sourceName = "<color=" .. self.blueTeamHexCode .. ">" .. sourceName .. "</color>"
		else
			sourceName = "<color=" .. self.redTeamHexCode .. ">" .. sourceName .. "</color>"
		end

		if source.activeWeapon then
			local weaponSprite = nil
			if source.activeWeapon.weaponEntry then
				weaponSprite = source.activeWeapon.weaponEntry.uiSprite
				newMessage.self:WriteKillMessage(sourceName, actorName, weaponSprite)
			else
				local weaponName = ""
				weaponName = source.activeWeapon.gameObject.name
				weaponName = self:CleanString(weaponName,"(Clone)", "%(Clone%)")
				local message = sourceName .. " [" .. weaponName .. "] "  .. actorName
				newMessage.self:WriteMessage(message)
			end
		else
			
			local message = sourceName .. " killed " .. actorName
			newMessage.self:WriteMessage(message)
		end
	else
		local message = actorName .. " died"
		newMessage.self:WriteMessage(message)
	end
	self:PushMessage(newMessage)
end

function CustomHUD_GameFeed:CleanString(str, target, format)
	if string.find(str, target) then
		str = string.gsub(str, format, "")
	end
	return str
end

function CustomHUD_GameFeed:onCapturePointCaptured(capturePoint, newOwner)
	if self.hasSpawnedOnce and not Player.actor.isDead then
		local capturePointText = capturePoint.name

		local newMessage = self.gameObject.Instantiate(self.gameMessagePrefab).GetComponent(ScriptedBehaviour)
		newMessage.self:InitVariables(self.weaponSpriteScale)
		newMessage.gameObject.transform.parent = self.gameObject.transform
		newMessage.gameObject.transform.localPosition = Vector3(322,0,0)

		if newOwner == Team.Blue then
			local text = self.blueTeamText ..  " captured " .. capturePointText .. "!"
			newMessage.self:WriteCaptureMessage(text, self.blueTeamColor)
		else
			local text = self.redTeamText ..  " captured " .. capturePointText .. "!"
			newMessage.self:WriteCaptureMessage(text, self.redTeamColor)
		end

		self:PushMessage(newMessage)
	end
end

function CustomHUD_GameFeed:onCapturePointNeutralized(capturePoint, previousOwner)
	if self.hasSpawnedOnce and not Player.actor.isDead then
		local capturePointText = capturePoint.name

		local newMessage = self.gameObject.Instantiate(self.gameMessagePrefab).GetComponent(ScriptedBehaviour)
		newMessage.self:InitVariables(self.weaponSpriteScale)
		newMessage.gameObject.transform.parent = self.gameObject.transform
		newMessage.gameObject.transform.localPosition = Vector3(322,0,0)

		if previousOwner == Team.Blue then
			local text = self.redTeamText ..  " neutralized " .. capturePointText .. "!"
			newMessage.self:WriteCaptureMessage(text, Color.grey)
		else
			local text = self.blueTeamText ..  " neutralized " .. capturePointText .. "!"
			newMessage.self:WriteCaptureMessage(text, Color.grey)
		end
		self:PushMessage(newMessage)
	end
end

function CustomHUD_GameFeed:onActorSpawn(actor)
	if(actor == Player.actor) then
		self.hasSpawnedOnce = true
	end
end