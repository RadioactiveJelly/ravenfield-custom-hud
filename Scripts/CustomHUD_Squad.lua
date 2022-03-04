-- Register the behaviour
behaviour("CustomHUD_Squad")

function CustomHUD_Squad:Awake()
	self.squadText = self.gameObject.Find("Squad Text").GetComponent(Text)
end

function CustomHUD_Squad:Start()
	
	self.squadTextVisibility = self.script.mutator.GetConfigurationBool("squadTextVisibility")
	
	if self.squadTextVisibility then
		self.script.AddValueMonitor("monitorSquadText", "updateSquadText")
		self:updateSquadText()
	else
		self.squadText.gameObject.SetActive(false)
	end
	

	print("<color=lightblue>[Custom HUD]Initialized Squad Display Module v1.1.0 </color>")
end

function CustomHUD_Squad:monitorSquadText()
	return self.squadText.text
end

function CustomHUD_Squad:updateSquadText()
	self.targets.squadText.text = self.squadText.text
end