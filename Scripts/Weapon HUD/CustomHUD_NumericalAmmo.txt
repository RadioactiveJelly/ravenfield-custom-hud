-- Register the behaviour
behaviour("CustomHUD_NumericalAmmo")

function CustomHUD_NumericalAmmo:Start()
	self.script.AddValueMonitor("monitorAmmo", "onAmmoChange")
	self.script.AddValueMonitor("monitorSpareAmmo", "onSpareAmmoChange")
end

function CustomHUD_NumericalAmmo:monitorAmmo()
	if Player.actor.activeWeapon == nil then
		return nil
	end
	return Player.actor.activeWeapon.activeSubWeapon.ammo
end

function CustomHUD_NumericalAmmo:onAmmoChange(ammo)
	if ammo == nil then
		return
	end
	
	if self.targets.ammoText then
		if ammo >= 0 then
			self.targets.ammoText.gameObject.SetActive(true)
			if ammo > 999 then
				ammo = 999
			end
			self.targets.ammoText.text = ammo
			if ammo/Player.actor.activeWeapon.activeSubWeapon.maxAmmo < 0.4 then
				self.targets.ammoText.color = Color.red
			else
				self.targets.ammoText.color = Color.white
			end
		else
			self.targets.ammoText.gameObject.SetActive(false)
		end	
	end
	
end

function CustomHUD_NumericalAmmo:monitorSpareAmmo()
	if Player.actor.activeWeapon == nil then
		return nil
	end
	return Player.actor.activeWeapon.activeSubWeapon.spareAmmo
end

function CustomHUD_NumericalAmmo:onSpareAmmoChange(spareAmmo)
	if spareAmmo == nil then
		return
	end

	if Player.actor.activeWeapon.activeSubWeapon.maxSpareAmmo >= 0 then
		self.targets.spareAmmoText.gameObject.SetActive(true)
		self.targets.spareAmmoText.text = spareAmmo
		if spareAmmo/Player.actor.activeWeapon.activeSubWeapon.maxSpareAmmo <= 0.3 or spareAmmo == 0 then
			self.targets.spareAmmoText.color = Color.red
		else
			self.targets.spareAmmoText.color = Color.white
		end
	elseif Player.actor.activeWeapon.activeSubWeapon.maxSpareAmmo == -1 then
		self.targets.spareAmmoText.gameObject.SetActive(false)
	elseif Player.actor.activeWeapon.activeSubWeapon.maxSpareAmmo == -2 then
		self.targets.spareAmmoText.gameObject.SetActive(true)
		self.targets.spareAmmoText.color = Color.white
		self.targets.spareAmmoText.text = "∞"
	end
end