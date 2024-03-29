﻿-- Register the behaviour
behaviour("CustomHUD_Weapon")

function CustomHUD_Weapon:Awake()
	if GameManager.buildNumber <= 26 then
		self.sightText = GameObject.Find("Sight Text").GetComponent(Text)
	else
		self.sightText = GameObject.Find("Scope Text").GetComponent(Text)
	end
end

function CustomHUD_Weapon:Start()
	GameEvents.onActorDied.AddListener(self,"onActorDied")
	GameEvents.onActorSpawn.AddListener(self,"onActorSpawn")

	self.targets.Canvas.enabled = false

	self.script.AddValueMonitor("monitorCurrentWeapon", "onChangeWeapon")
	self.script.AddValueMonitor("monitorHeat", "onHeatChange")
	self.script.AddValueMonitor("monitorFireMode", "onFireModeChange")

	self.script.AddValueMonitor("monitorSightModeText", "onSightModeChange")

	self.weaponHUDVisibility = self.script.mutator.GetConfigurationBool("weaponHUDVisibility")
	
	self.script.AddValueMonitor("monitorHUDVisibility", "onHUDVisibilityChange")

	print("<color=lightblue>[Custom HUD]Initialized Weapon Display Module v1.3.0 </color>")
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
		name = self:CleanString(name,"EXTAS", "EXTAS%s+-%s")
		name = self:CleanString(name,"RWP2_", "RWP2_")
	else
		name = Player.actor.activeWeapon.gameObject.name
		name = self:CleanString(name,"(Clone)", "%(Clone%)")
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

function CustomHUD_Weapon:monitorHUDVisibility()
	return GameManager.hudPlayerEnabled
end

function CustomHUD_Weapon:onHUDVisibilityChange()
	self.targets.Canvas.enabled = not Player.actor.isDead and GameManager.hudPlayerEnabled and self.weaponHUDVisibility
end

function CustomHUD_Weapon:CleanString(str, target, format)
	if string.find(str, target) then
		str = string.gsub(str, format, "")
	end
	return str
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

function CustomHUD_Weapon:onActorSpawn(actor)
	if actor.isPlayer then
		self.targets.Canvas.enabled = GameManager.hudPlayerEnabled and self.weaponHUDVisibility
	end
end

function CustomHUD_Weapon:onActorDied(actor,source,isSilent)
	if actor.isPlayer then
		self.targets.Canvas.enabled = false
	end
end