-- Register the behaviour
behaviour("CWHUD_Hitmarker")

function CWHUD_Hitmarker:Start()
	-- Run when behaviour is created
	GameEvents.onPlayerDealtDamage.AddListener(self,"OnPlayerDealtDamage")

	self.targets.AudioSource.SetOutputAudioMixer(AudioMixer.Master)
	self.hitMarkerAlpha = 0
	self.scaleTime = 0
	self.animationCurve = self.targets.DataContainer.GetAnimationCurve("AnimationCurve")

	self.targets.CanvasGroup.alpha = 0

	PlayerHud.HideUIElement(UIElement.Hitmarker)
end

function CWHUD_Hitmarker:OnPlayerDealtDamage(damageInfo, hitInfo)
	if damageInfo.isSplashDamage then return end

	if hitInfo.actor then
		local willKill = (hitInfo.actor.health - damageInfo.healthDamage) <= 0
		self:DisplayHitMarker(willKill)
		self:PlayActorDamageSound()
	end
end

function CWHUD_Hitmarker:Update()
	if self.targets.CanvasGroup.alpha > 0 then
		self.hitMarkerAlpha = self.hitMarkerAlpha - Time.deltaTime
		
		self.targets.CanvasGroup.alpha = self.hitMarkerAlpha
	end

	if self.scaleTime > 0 then
		self.scaleTime = self.scaleTime - Time.deltaTime
		local scale = self.animationCurve.Evaluate(1 - self.scaleTime)
		self.targets.HitmarkerSprite.transform.localScale = Vector3(scale,scale,1)
	end
end

function CWHUD_Hitmarker:PlayActorDamageSound()
	local rand = Random.Range(0.9, 1.1)
	self.targets.AudioSource.pitch = rand
	self.targets.AudioSource.Play()
end

function CWHUD_Hitmarker:DisplayHitMarker(willKill)
	if willKill then
		self.targets.HitmarkerSprite.color = Color.red
	else
		self.targets.HitmarkerSprite.color = Color.white
	end
	self.hitMarkerAlpha = 1.5
	self.targets.CanvasGroup.alpha = self.hitMarkerAlpha
	self.scaleTime = 1
end
