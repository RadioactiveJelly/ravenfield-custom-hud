-- Register the behaviour
behaviour("CustomHUD_DamageSound")

function CustomHUD_DamageSound:Awake()
	-- Run when behaviour is created
	Player.actor.onTakeDamage.AddListener(self,"onTakeDamage")

	self.targets.AudioSource.SetOutputAudioMixer(AudioMixer.Important)
end

function CustomHUD_DamageSound:Update()
	--[[if Input.GetKeyDown(KeyCode.T) then
		self:PlaySound()
	end]]--
end

function CustomHUD_DamageSound:onTakeDamage(actor, source, info)
	if info.isSplashDamage then return end
	if source == nil then return end

	self:PlaySound()
end

function CustomHUD_DamageSound:PlaySound()
	local rand = Random.Range(0.9, 1.1)
	self.targets.AudioSource.pitch = rand
	self.targets.AudioSource.Play()
end
