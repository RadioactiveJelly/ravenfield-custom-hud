-- Register the behaviour
behaviour("CustomHUD_TickerCompass")

function CustomHUD_TickerCompass:Start()
	self.rawImage = self.targets.RawImage
	self.angleText = self.targets.Angle
	self.lastAngle = -1
	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	if self.dataContainer then
		self.northColor = self.dataContainer.GetColor("_north")
	end

	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")
	GameEvents.onActorDiedInfo.AddListener(self,"onActorDiedInfo")

	self.targets.CanvasGroup.alpha = 0

	self.script.AddValueMonitor("monitorHUDVisibility", "onHUDVisibilityChange")
end

function CustomHUD_TickerCompass:Update()
	if Player.actor and not Player.actor.isDead then
		local anglePlayer = PlayerCamera.fpCamera.transform.eulerAngles.y
		
		local x = anglePlayer/360 + 0.52
		local uvRect = self.rawImage.uvRect
		self.rawImage.uvRect = Rect(x, uvRect.y, uvRect.width, uvRect.height)
		self.rawImage.material.SetFloat("_Offset", x)

		if self.angleText then
			if self.lastAngle ~= anglePlayer then
				if anglePlayer > 75 and anglePlayer < 105 then
					self.angleText.text = "E"
					if self.dataContainer then
						self.angleText.color = self.northColor
					end
				elseif anglePlayer > 165 and anglePlayer < 195 then
					self.angleText.text = "S"
					if self.dataContainer then
						self.angleText.color = self.northColor
					end
				elseif anglePlayer > 255 and anglePlayer < 285 then
					self.angleText.text = "W"
					if self.dataContainer then
						self.angleText.color = self.northColor
					end
				elseif anglePlayer > 345 or anglePlayer < 15 then
					self.angleText.text = "N"
					if self.dataContainer then
						self.angleText.color = self.northColor
					end
				else
					self.angleText.text = Mathf.Floor(anglePlayer)
					self.angleText.color = Color.white
				end
				self.lastAngle = anglePlayer
			end
		end
	end
end

function CustomHUD_TickerCompass:monitorHUDVisibility()
	return PlayerHud.hudPlayerEnabled
end

function CustomHUD_TickerCompass:onHUDVisibilityChange()
	local visible = not Player.actor.isDead and GameManager.hudPlayerEnabled and self.healthNumberVisibility
	local alpha = 1
	if not visible then
		alpha = 0
	end
	self.targets.CanvasGroup.alpha = alpha
end

function CustomHUD_TickerCompass:onActorDiedInfo(actor, info, isSilent)
	if actor.isPlayer then
		self.targets.CanvasGroup.alpha = 0
	end
end

function CustomHUD_TickerCompass:onActorSpawn(actor)
	if actor.isPlayer then
		self.targets.CanvasGroup.alpha = 1
	end
end