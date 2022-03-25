-- Register the behaviour
behaviour("CustomHUD_HeadShotSound")

function CustomHUD_HeadShotSound:Start()
	GameEvents.onActorDiedInfo.AddListener(self,"onActorDiedInfo")
	self.soundBank = self.targets.soundBank
	self.targets.soundSource.SetOutputAudioMixer(AudioMixer.FirstPerson)
end

function CustomHUD_HeadShotSound:onActorDiedInfo(actor, info, isSilent)

	local source = info.sourceActor
	if source and source.isPlayer then
		if info.isCriticalHit and not info.isSplashDamage then
			self.soundBank.PlayRandom()
		end
	end

end