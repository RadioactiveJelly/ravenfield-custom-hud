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

	if hitInfo.actor then
		if hitInfo.actor.isPlayer then return end

		local willKill = (hitInfo.actor.health - damageInfo.healthDamage) <= 0
		local color = Color.white
		if damageInfo.isSplashDamage then
			color = Color.yellow
		end
		if willKill then
			if damageInfo.isSplashDamage then
				color = Color(1,0.5,0,1)
			else
				color = Color.red
			end
		end

		self:DisplayHitMarker(color)
		self:PlayActorDamageSound()
	end
end

function CWHUD_Hitmarker:Update()
	if self.targets.CanvasGroup.alpha > 0 then
		self.hitMarkerAlpha = self.hitMarkerAlpha - Time.deltaTime
		
		self.targets.CanvasGroup.alpha = self.hitMarkerAlpha
	end

	if self.scaleTime > 0 then
		self.scaleTime = self.scaleTime - (Time.deltaTime * 2)
		local scale = self.animationCurve.Evaluate(1 - self.scaleTime)
		self.targets.HitmarkerSprite.transform.localScale = Vector3(scale,scale,1)
	end
end

function CWHUD_Hitmarker:PlayActorDamageSound()
	local rand = Random.Range(0.9, 1.1)
	self.targets.AudioSource.pitch = rand
	self.targets.AudioSource.Play()
end

function CWHUD_Hitmarker:DisplayHitMarker(color)
	self.targets.HitmarkerSprite.color = color
	self.hitMarkerAlpha = 1.5
	self.targets.CanvasGroup.alpha = self.hitMarkerAlpha
	self.scaleTime = 1
end
