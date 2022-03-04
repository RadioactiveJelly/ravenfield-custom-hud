-- Register the behaviour
behaviour("CustomHUD_Vehicle")

function CustomHUD_Vehicle:Start()
	self.script.AddValueMonitor("monitorVehicle","updateVehicleHUD")
	self.script.AddValueMonitor("monitorVehicleHealth", "updateVehicleHealth")

	self.vehicleHUDVisibility = self.script.mutator.GetConfigurationBool("vehicleHUDVisibility")

	self.script.AddValueMonitor("monitorHUDVisibility", "onHUDVisibilityChange")

	self.targets.Canvas.enabled = false
	print("<color=lightblue>[Custom HUD]Initialized Vehicle Display Module v1.2.0 </color>")
end

function CustomHUD_Vehicle:monitorHUDVisibility()
	return GameManager.hudPlayerEnabled
end

function CustomHUD_Vehicle:onHUDVisibilityChange()
	self.targets.Canvas.enabled = not Player.actor.isDead and GameManager.hudPlayerEnabled and self.vehicleHUDVisibility and not Player.actor.activeVehicle == nil
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
		self.targets.Canvas.enabled = true
		self.targets.vehicleName.text = Player.actor.activeVehicle.name
		self:updateVehicleHealth()
	else
		self.targets.Canvas.enabled = false
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
