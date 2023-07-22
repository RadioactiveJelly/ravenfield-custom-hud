-- Register the behaviour
behaviour("WeaponHUD_Fader")

function WeaponHUD_Fader:Awake()
	--self.sightText = GameObject.Find("Sight Text").GetComponent(Text)
end

function WeaponHUD_Fader:Start()
	-- Run when behaviour is created
	self.alpha = 1
	self.beginFade = false
	self.timer = 5

	self.script.AddValueMonitor("monitorCurrentWeapon", "ResetFade")
	self.script.AddValueMonitor("monitorAmmo", "ResetFade")
	self.script.AddValueMonitor("monitorSpareAmmo", "ResetFade")
	self.script.AddValueMonitor("monitorHeat", "ResetFade")
	self.script.AddValueMonitor("monitorFireMode", "ResetFade")
	--self.script.AddValueMonitor("monitorSightModeText", "ResetFade")
	self.script.AddValueMonitor("monitorReloading", "ResetFade")

	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	self.timeBeforeFade = self.dataContainer.GetFloat("timeBeforeFade")
	self.fadeTimer = self.timeBeforeFade

	self.showKey = string.lower(self.script.mutator.GetConfigurationString("showWeaponText"))
end

function WeaponHUD_Fader:Update()
	-- Run every frame

	if Input.GetKeyDown(self.showKey) then
		self:ResetFade()
	end

	if self.fadeTimer > 0 then
		self.fadeTimer = self.fadeTimer - Time.deltaTime
	elseif self.fadeTimer <= 0 then
		self.beginFade = true
	end

	if self.beginFade then
		self.targets.canvasGroup.alpha = self.alpha
		self.alpha = self.alpha - Time.deltaTime/4
	end
end

function WeaponHUD_Fader:monitorCurrentWeapon()
	return Player.actor.activeWeapon
end

function WeaponHUD_Fader:monitorAmmo()
	if Player.actor.activeWeapon == nil then
		return nil
	end
	return Player.actor.activeWeapon.activeSubWeapon.ammo
end

function WeaponHUD_Fader:monitorSpareAmmo()
	if Player.actor.activeWeapon == nil then
		return nil
	end
	return Player.actor.activeWeapon.activeSubWeapon.spareAmmo
end

function WeaponHUD_Fader:monitorHeat()
	if Player.actor.activeWeapon == nil then
		return
	end
	return Player.actor.activeWeapon.heat
end

function WeaponHUD_Fader:monitorReloading()
	if Player.actor.activeWeapon == nil then
		return
	end
	return Player.actor.activeWeapon.isReloading
end

function WeaponHUD_Fader:monitorFireMode()
	if Player.actor.activeWeapon == nil then
		return nil
	end
	return Player.actor.activeWeapon.activeSubWeapon.isAuto
end

--[[function CustomHUD_Weapon:monitorSightModeText()
	return self.sightText.text
end]]--

function WeaponHUD_Fader:ResetFade()
	self.targets.canvasGroup.alpha = 1
	self.fadeTimer = self.timeBeforeFade
	self.alpha = 1
	self.beginFade = false
end