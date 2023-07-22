-- Register the behaviour
behaviour("CustomHUD_ScoreBoardEditor")

function CustomHUD_ScoreBoardEditor:Start()
	local bString = self.script.mutator.GetConfigurationString("blueTeamName")
	local rString = self.script.mutator.GetConfigurationString("redTeamName")

	local blueTeamName = "<color=white>The</color> Eagles"
	if bString ~= "" then
		blueTeamName = bString	
	end

	local redTeamName = "<color=white>The</color> Ravens"
	if rString ~= "" then
		redTeamName = rString
	end 

	self:ReplaceScoreBoardName("Scoreboard Canvas/Panel/Team Panel/Header Panel/Text Team", blueTeamName)
	self:ReplaceScoreBoardName("Scoreboard Canvas/Panel/Team Panel (1)/Header Panel/Text Team", redTeamName)
end

function CustomHUD_ScoreBoardEditor:ReplaceScoreBoardName(path, name)
	local nameObj = GameObject.Find(path)
	if nameObj then 
		local teamName = nameObj.GetComponent(Text)
		teamName.text = name
	end
end
