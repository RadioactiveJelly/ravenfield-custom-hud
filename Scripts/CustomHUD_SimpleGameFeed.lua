-- Register the behaviour
behaviour("CustomHUD_SimpleGameFeed")

function CustomHUD_SimpleGameFeed:Start()
	-- Run when behaviour is created
	
	
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")

	self.maxLines = 5

	self.feed = self.targets.KillFeedText;
	self.lines = {}
	for i = 1, self.maxLines, 1 do
		self.lines[i] = ""
	end

	self.blueTeamHexCode = "#6fa8dc"
	self.redTeamHexCode = "#e06666"
	self.weaponHex = "#9FB5B7"

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

	self.timeToFade = 5
	self.timer = 0

	self.alpha = 1

	self.canClearFeed = true

	self:UpdateFeed()
	self.feed.text = ""
	self.playerName = ""
	local configString = self.script.mutator.GetConfigurationString("displayName")
	if configString == "" then
		self.playerName = Player.actor.name
	else
		self.playerName = configString
	end

	print("<color=lightblue>[Custom HUD]Initialized Game Feed Module v1.0.0</color>")
end

function CustomHUD_SimpleGameFeed:Update()
	if self.feedEnabled then
		if self.timer < self.timeToFade then
			self.timer = self.timer + Time.deltaTime
		else
			self.targets.CanvasGroup.alpha = self.alpha
			self.alpha = self.alpha - Time.deltaTime/4
			if (self.alpha <= 0) and self.canClearFeed then
				self:Clear()
				self.canClearFeed = false
			end
		end
	end
end

function CustomHUD_SimpleGameFeed:Clear()
	for i = 1, self.maxLines, 1 do
		self.lines[i] = ""
	end
	self.feed.text = ""
end

function CustomHUD_SimpleGameFeed:UpdateFeed()
	local text = ""

	for i=1,self.maxLines do
		if self.lines[i] ~= "" then
			text = text .. self.lines[i] .. "\n"
		end
	end

	self.feed.text = text
	self.timer = 0
	self.alpha = 1
	self.targets.CanvasGroup.alpha = self.alpha
	self.canClearFeed = true
end

function CustomHUD_SimpleGameFeed:PushText(text)
	for i=1,self.maxLines-1 do
		self.lines[i] = self.lines[i+1]
	end
	self.lines[self.maxLines] = text

	self:UpdateFeed()
end

function CustomHUD_SimpleGameFeed:onActorDied(actor, source, isSilent)
	local actorName = actor.name
	if actor.isPlayer then
		actorName = self.playerName
	end
	local sourceName = ""
	local sourceWeapon = ""

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
			local weaponName = ""
			if source.activeWeapon.weaponEntry then
				weaponName = source.activeWeapon.weaponEntry.name
				weaponName = self:CleanString(weaponName,"EXTAS", "EXTAS%s+-%s")
				weaponName = self:CleanString(weaponName,"RWP2_", "RWP2_")
			else
				weaponName = source.activeWeapon.gameObject.name
				weaponName = self:CleanString(weaponName,"(Clone)", "%(Clone%)")
			end
			sourceWeapon = "<color=" .. self.weaponHex .. ">" .. weaponName .. "</color>"
			self:PushText(sourceName .." ---[" .. sourceWeapon .. "]---> " .. actorName)
		else
			self:PushText(sourceName .." killed " .. actorName)
		end
	else
		self:PushText(actorName .. " died.")
	end
end

function CustomHUD_SimpleGameFeed:CleanString(str, target, format)
	if string.find(str, target) then
		str = string.gsub(str, format, "")
	end
	return str
end

function CustomHUD_SimpleGameFeed:onCapturePointCaptured(capturePoint, newOwner)
	if self.hasSpawnedOnce then
		local capturePointText = capturePoint.name
		if newOwner == Team.Blue then
			self:PushText(self.blueTeamText ..  " captured " .. capturePointText .. "!")
		else
			self:PushText(self.redTeamText ..  " captured " .. capturePointText .. "!")
		end
	end
end

function CustomHUD_SimpleGameFeed:onCapturePointNeutralized(capturePoint, previousOwner)
	if self.hasSpawnedOnce then
		local capturePointText = capturePoint.name
		if previousOwner == Team.Blue then
			self:PushText(self.redTeamText ..  " neutralized " .. capturePointText .. "!")
		else
			self:PushText(self.blueTeamText ..  " neutralized " .. capturePointText .. "!")
		end
	end
end

function CustomHUD_SimpleGameFeed:onActorSpawn(actor)
	if(actor == Player.actor) then
		self.hasSpawnedOnce = true
	end
end