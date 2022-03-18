-- Register the behaviour
behaviour("CustomHUD_TeamIcon")

function CustomHUD_TeamIcon:Start()
	-- Run when behaviour is created
	self.dataContainer = self.gameObject.GetComponent(DataContainer)

	local sprite = nil
	if(Player.actor.team == Team.Blue) then
		sprite = self.dataContainer.GetSprite("EagleIcon")
	else
		sprite = self.dataContainer.GetSprite("RavenIcon")
	end
	
	self.targets.icon.sprite = sprite
end

