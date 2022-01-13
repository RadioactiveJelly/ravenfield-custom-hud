-- Register the behaviour
behaviour("CustomHUD_ReloadNotif")

function CustomHUD_ReloadNotif:Start()
	-- Run when behaviour is created
	print("Hello World")
end

function CustomHUD_ReloadNotif:Update()
	-- Run every frame
	if not Player.actor.isDead and Player.actor.activeWeapon then
		
	end
end
