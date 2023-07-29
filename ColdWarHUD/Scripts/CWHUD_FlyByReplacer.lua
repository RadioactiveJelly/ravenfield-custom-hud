-- Register the behaviour
behaviour("CWHUD_FlyByReplacer")

function CWHUD_FlyByReplacer:Start()
	-- Run when behaviour is created

	local clips = self.targets.DataContainer.GetAudioClipArray("FlyBy")

	local flyByObject = GameObject.Find("Player Fps Actor(Clone)/Bullet Flyby Sound")
	if flyByObject then
		print("Flyby object")
		local flybySoundBank = flyByObject.GetComponent(SoundBank)
		if flybySoundBank then
			flybySoundBank.clips = clips
		end
	end
end
