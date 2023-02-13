-- Register the behaviour
behaviour("CustomHUD_DamageIndicator")


function CustomHUD_DamageIndicator:Init(targetPos)
	self.lifetime = 2.5
	self.timer = self.lifetime
	self.isDead = false

	self.targetPos = targetPos
	self.targets.canvasGroup.alpha = 1
	self.gameObject.transform.localPosition = Vector3(0,0,0)
end

function CustomHUD_DamageIndicator:Tick(isDead)
	if self.lifetime < 0 then
		self.isDead = true
	else
		if not isDead then
			local dir = self.targetPos - Player.actor.position

			local rotation = Quaternion.LookRotation(dir)
			rotation.z = -rotation.y
			rotation.x = 0
			rotation.y = 0
	
			local north = Vector3(0, 0, PlayerCamera.fpCamera.transform.eulerAngles.y)
			local finalRot = rotation * Quaternion.Euler(north)
			self.gameObject.transform.localRotation = finalRot
		end
		self.timer = self.timer - Time.deltaTime
		self.targets.canvasGroup.alpha = self.timer/(self.lifetime/2)
	end
end
