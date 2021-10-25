-- Register the behaviour
behaviour("CustomHUD_Weapon")

function CustomHUD_Weapon:Awake()
	self.sightText = GameObject.Find("Sight Text").GetComponent(Text)
end

function CustomHUD_Weapon:Start()
	self.script.AddValueMonitor("monitorCurrentWeapon", "onChangeWeapon")
	self.script.AddValueMonitor("monitorHeat", "onHeatChange")
	self.script.AddValueMonitor("monitorFireMode", "onFireModeChange")

	self.script.AddValueMonitor("monitorSightModeText", "onSightModeChange")

	print("<color=lightblue>[Custom HUD]Initialized Weapon Display Module v1.2.1 </color>")
end

function CustomHUD_Weapon:monitorCurrentWeapon()
	return Player.actor.activeWeapon
end

function CustomHUD_Weapon:onChangeWeapon()
	if Player.actor.activeWeapon == nil then
		return
	end
	local name = ""
	if Player.actor.activeWeapon.weaponEntry then
		name = Player.actor.activeWeapon.weaponEntry.name
		if string.find(Player.actor.activeWeapon.weaponEntry.name, "EXTAS") then
			name = string.gsub(name, "EXTAS%s+-%s", "")
		end
	else
		name = Player.actor.activeWeapon.gameObject.name
		print(name)
		if string.find(Player.actor.activeWeapon.gameObject.name, "(Clone)") then
			name = string.gsub(name, '%(Clone%)', "")
		end
	end
	
	if Player.actor.activeWeapon.applyHeat then
		self.targets.heatText.gameObject.SetActive(true)
		self:onHeatChange()
	else
		self.targets.heatText.gameObject.SetActive(false)
	end

	self.targets.AmmoDisplay.self:onAmmoChange(Player.actor.activeWeapon.activeSubWeapon.ammo)
	self.targets.AmmoDisplay.self:onSpareAmmoChange(Player.actor.activeWeapon.activeSubWeapon.spareAmmo)

	self.targets.weaponName.text = name
end

function CustomHUD_Weapon:monitorHeat()
	if Player.actor.activeWeapon == nil then
		return
	end
	return Player.actor.activeWeapon.heat
end

function CustomHUD_Weapon:onHeatChange()
	if Player.actor.activeWeapon == nil then
		return
	end
	if Player.actor.activeWeapon.applyHeat then
		local heatPercentage = Player.actor.activeWeapon.heat * 100
		local color = 1 - Player.actor.activeWeapon.heat
		heatPercentage = Mathf.Round(heatPercentage)
		self.targets.heatText.text = "Heat: " .. heatPercentage .. "%"
		self.targets.heatText.color = Color(1, color, color, 1)
	end
end

function CustomHUD_Weapon:monitorFireMode()
	if Player.actor.activeWeapon == nil then
		return nil
	end
	return Player.actor.activeWeapon.activeSubWeapon.isAuto
end

function CustomHUD_Weapon:onFireModeChange(isAuto)
	if isAuto == nil then
		return
	end

	if isAuto then
		self.targets.fireMode.text = "Full Auto"
	else
		self.targets.fireMode.text = "Single Fire"
	end
end

function CustomHUD_Weapon:monitorSightModeText()
	return self.sightText.text
end

function CustomHUD_Weapon:onSightModeChange()
	self.targets.SightMode.text = self.sightText.text
end