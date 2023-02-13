-- Register the behaviour
behaviour("CWHUD_TeamIndicator")

function CWHUD_TeamIndicator:Start()
	-- Run when behaviour is created
	self.dataContainer = self.gameObject.GetComponent(DataContainer)

	local color = nil
	if(Player.actor.team == Team.Blue) then
		color = self.targets.colorData.GetColor("blueTeamColor")
	else
		color = self.targets.colorData.GetColor("redTeamColor")
	end
	
	if color then self.targets.indicator.color = color end
end

