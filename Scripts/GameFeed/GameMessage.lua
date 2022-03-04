-- Register the behaviour
behaviour("GameMessage")

--This class is responsible for displaying game messages. It will fade out and destroy itself after a certain amount of time has passed.

function GameMessage:InitVariables(scale)
	-- Run when behaviour is created
	self.killerText = self.targets.KillerText
	self.killerRect = self.targets.KillerRect
	self.weaponSprite = self.targets.WeaponSprite
	self.weaponRect = self.targets.WeaponRect
	self.killedText = self.targets.KilledText

	self.flagImage = self.targets.FlagImage
	self.captureText = self.targets.CaptureText
	self.canvasGroup = self.targets.CanvasGroup

	self.initDone = false
	self.lifeTime = 1
	self.isDead = false
	self.alpha = 0
	self.canvasGroup.alpha = self.alpha
	self.fadeScale = 0.5

	self.targetPos = Vector3(322,0,0)
	self.weaponSpriteScale = scale
	self.canShow = false

	self.killerText.gameObject.SetActive(false)
	self.weaponSprite.gameObject.SetActive(false)
	self.killedText.gameObject.SetActive(false)

	self.flagImage.gameObject.SetActive(false)
	self.captureText.gameObject.SetActive(false)
end

function GameMessage:Update()

	if self.initDone and self.canShow then
		if self.gameObject.transform.localPosition.y > 0 then
			self.lifeTime = self.lifeTime - Time.deltaTime
			if self.lifeTime <= 0 then
				self.canvasGroup.alpha = self.alpha
				self.alpha = self.alpha - (Time.deltaTime * self.fadeScale)
				if self.alpha <= 0 then
					self.isDead = true
				end
			else
				self.canvasGroup.alpha = self.alpha
				self.alpha = self.alpha + Time.deltaTime * 2
			end
		end
		self.gameObject.transform.localPosition = Vector3.MoveTowards(self.gameObject.transform.localPosition, self.targetPos, Time.deltaTime * 200)
	end

end

function GameMessage:InitAsKillMessageNoSource(killed)
	self.killerText.gameObject.SetActive(true)
	self.killerText.text = killed .. " died."
	self.canShow = true
end

function GameMessage:WriteMessage(message)
	self.killerText.gameObject.SetActive(true)

	self.killerText.text = message --killer .. " killed " .. killed
	self.canShow = true
end

function GameMessage:WriteKillMessage(killer, killed, uiSprite)
	local useDefaultSprite = false
	if uiSprite == nil then
		useDefaultSprite = true
	end
	
	if useDefaultSprite == false then
		self.weaponRect.sizeDelta = Vector2(uiSprite.rect.width/self.weaponSpriteScale,uiSprite.rect.height/self.weaponSpriteScale)
	else
		self.weaponRect.sizeDelta = Vector2(50,50)
	end
	

	self.killerText.gameObject.SetActive(true)
	self.weaponSprite.gameObject.SetActive(true)
	self.killedText.gameObject.SetActive(true)

	self.killerText.text = killer
	self.killedText.text = killed
	if not useDefaultSprite then
		self.weaponSprite.sprite = uiSprite
	end
	self.script.StartCoroutine(self:ScaleToTextRect(0.1, useDefaultSprite));
end

function GameMessage:ScaleToTextRect(delay)
	return function()
		coroutine.yield(WaitForSeconds(delay))

		local spritePos = Vector3(self.killerRect.gameObject.transform.localPosition.x + self.killerRect.rect.size.x, self.weaponSprite.gameObject.transform.localPosition.y, 0)
		local killedTextPos = Vector3(spritePos.x + self.weaponRect.rect.size.x, self.killedText.gameObject.transform.localPosition.y, 0)

		self.weaponSprite.gameObject.transform.localPosition = spritePos
		self.killedText.gameObject.transform.localPosition = killedTextPos
		self.canShow = true
	end
end

function GameMessage:WriteCaptureMessage(message, color)
	self.flagImage.gameObject.SetActive(true)
	self.captureText.gameObject.SetActive(true)

	self.flagImage.color = color
	self.captureText.text = message
	self.canShow = true
end

function GameMessage:Kill()
	self.lifeTime = 0
	self.fadeScale = 16
end

function GameMessage:Show(startPos)
	self.initDone = true
	self.gameObject.transform.localPosition = Vector3(322,startPos,0)
end

function GameMessage:SetPosition(yPos)
	self.targetPos = Vector3(322,yPos,0)
end