-- Register the behaviour
behaviour("CustomHUD_Hitmarker")

function CustomHUD_Hitmarker:Start()
	-- Run when behaviour is created
	GameEvents.onPlayerDealtDamage.AddListener(self,"OnPlayerDealtDamage")

	self.targets.AudioSource.SetOutputAudioMixer(AudioMixer.Master)
	self.hitMarkerAlpha = 0

	PlayerHud.HideUIElement(UIElement.Hitmarker)
end

function CustomHUD_Hitmarker:OnPlayerDealtDamage(damageInfo, hitInfo)
	if damageInfo.isSplashDamage then return end

	if hitInfo.actor then
		local willKill = (hitInfo.actor.health - damageInfo.healthDamage) <= 0
		self:DisplayHitMarker(willKill)
		self:PlayActorDamageSound()
	end
end

function CustomHUD_Hitmarker:Update()
	if self.targets.CanvasGroup.alpha > 0 then
		self.hitMarkerAlpha = self.hitMarkerAlpha - Time.deltaTime
		self.targets.CanvasGroup.alpha = self.hitMarkerAlpha
	end
end

function CustomHUD_Hitmarker:PlayActorDamageSound()
	local rand = Random.Range(0.9, 1.1)
	self.targets.AudioSource.pitch = rand
	self.targets.AudioSource.Play()
end

function CustomHUD_Hitmarker:DisplayHitMarker(willKill)
	if willKill then
		self.targets.HitmarkerSprite.color = Color.red
	else
		self.targets.HitmarkerSprite.color = Color.white
	end
	self.hitMarkerAlpha = 1.5
	self.targets.CanvasGroup.alpha = self.hitMarkerAlpha
end