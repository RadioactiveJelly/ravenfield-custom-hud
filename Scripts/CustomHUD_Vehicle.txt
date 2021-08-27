-- Register the behaviour
behaviour("CustomHUD_Vehicle")

function CustomHUD_Vehicle:Start()
	self.script.AddValueMonitor("monitorVehicle","updateVehicleHUD")
	self.script.AddValueMonitor("monitorVehicleHealth", "updateVehicleHealth")

	print("<color=lightblue>[Custom HUD]Initialized Vehicle Display Module v1.1.0 </color>")
	self:SetActive(false)
end

function CustomHUD_Vehicle:monitorVehicle()
	return Player.actor.activeVehicle
end

function CustomHUD_Vehicle:SetActive(active)
	self.targets.vehicleName.gameObject.SetActive(active)
	self.targets.vehicleText.gameObject.SetActive(active)
	if self.targets.background then
		self.targets.background.gameObject.SetActive(active)
	end
end

function CustomHUD_Vehicle:updateVehicleHUD()
	if Player.actor.activeVehicle then
		self:SetActive(true)
		self.targets.vehicleName.text = Player.actor.activeVehicle.name
		self:updateVehicleHealth()
	else
		self:SetActive(false)
	end
end

function CustomHUD_Vehicle:monitorVehicleHealth()
	if Player.actor.activeVehicle == nil then
		return
	end
	return Player.actor.activeVehicle.health
end

function CustomHUD_Vehicle:updateVehicleHealth()
	if Player.actor.activeVehicle == nil then
		return
	end
	local vehicleHealth = Mathf.Round(Player.actor.activeVehicle.health)
	local healthText = vehicleHealth .. "/" .. Player.actor.activeVehicle.maxHealth
	self.targets.vehicleText.text = healthText
end