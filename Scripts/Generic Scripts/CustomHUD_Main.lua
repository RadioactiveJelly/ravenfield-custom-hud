-- Register the behaviour
behaviour("CustomHUD_Main")

function CustomHUD_Main:Start()
	self.dataContainer = self.gameObject.GetComponent(DataContainer)
	
	self:DisableDefaultHUD()

	if GameManager.buildNumber < 25 then
		print("<color=red>[Custom HUD]You are using build number: " .. GameManager.buildNumber  .. " please update to the latest game version!</color>")
		print("<color=red>[Custom HUD]Using an older version below EA25 may cause issues</color>")
	end

	local hudVersion = self.dataContainer.GetString("hudVersion")
	print("<color=lightblue>[Custom HUD]Using HUD Style: </color>" .. self.dataContainer.GetString("hudName") .. "<color=lightblue> v" .. hudVersion .. "</color>")
	print("<color=lightblue>[Custom HUD]Initialized Main script v1.5.0</color>")
end

function CustomHUD_Main:monitorCurrentWeapon()
	return Player.actor.activeWeapon
end

function CustomHUD_Main:onChangeWeapon()
	if self.targets.WeaponHUD == nil then
		return
	end
	if Player.actor.activeWeapon == nil then
		self.targets.WeaponHUD.SetActive(false)
		return
	end
	self.targets.WeaponHUD.SetActive(self.weaponHUDVisibility)
end

function CustomHUD_Main:monitorHUDVisibility()
	return GameManager.hudPlayerEnabled
end

function CustomHUD_Main:onHUDVisibilityChange()
	self.targets.Canvas.enabled = not Player.actor.isDead and GameManager.hudPlayerEnabled
end

function CustomHUD_Main:onActorSpawn(actor)
	if actor.isPlayer then
		self.targets.Canvas.enabled = GameManager.hudPlayerEnabled
	end
end

function CustomHUD_Main:onActorDied(actor,source,isSilent)
	if actor.isPlayer then
		self.targets.Canvas.enabled = false
	end
end

function CustomHUD_Main:DisableDefaultHUD()
	GameObject.Find("Ingame UI Container(Clone)").Find("Ingame UI/Panel").gameObject.GetComponent(Image).color = Color(0,0,0,0)
	GameObject.Find("Current Ammo Text").gameObject.SetActive(false)
	GameObject.Find("Spare Ammo Text").gameObject.SetActive(false)
	GameObject.Find("Vehicle Health Background").gameObject.SetActive(false)
	GameObject.Find("Resupply Health").gameObject.SetActive(false)
	GameObject.Find("Resupply Ammo").gameObject.SetActive(false)
	GameObject.Find("Squad Text").gameObject.GetComponent(Text).color = Color(0,0,0,0)
	GameObject.Find("Sight Text").gameObject.SetActive(false)
	GameObject.Find("Weapon Image").gameObject.SetActive(false)
	GameObject.Find("Health Text").gameObject.transform.parent.gameObject.SetActive(false)
	
end