-- Register the behaviour
behaviour("CustomHUD_TickerCompass")

function CustomHUD_TickerCompass:Start()
	self.rawImage = self.targets.RawImage
	self.angleText = self.targets.Angle
	self.lastAngle = -1
	local dataContainer = self.gameObject.GetComponent(DataContainer)
	self.northColor = dataContainer.GetColor("_north")
end

function CustomHUD_TickerCompass:Update()
	-- Run every frame
	if Player.actor and not Player.actor.isDead then
		local anglePlayer = PlayerCamera.fpCamera.transform.eulerAngles.y
		
		local x = anglePlayer/360 + 0.52
		local uvRect = self.rawImage.uvRect
		self.rawImage.uvRect = Rect(x, uvRect.y, uvRect.width, uvRect.height)
		self.rawImage.material.SetFloat("_Offset", x)

		if self.lastAngle ~= anglePlayer then
			if anglePlayer > 75 and anglePlayer < 105 then
				self.angleText.text = "E"
				self.angleText.color = self.northColor
			elseif anglePlayer > 165 and anglePlayer < 195 then
				self.angleText.text = "S"
				self.angleText.color = self.northColor
			elseif anglePlayer > 255 and anglePlayer < 285 then
				self.angleText.text = "W"
				self.angleText.color = self.northColor
			elseif anglePlayer > 345 or anglePlayer < 15 then
				self.angleText.text = "N"
				self.angleText.color = self.northColor
			else
				self.angleText.text = Mathf.Floor(anglePlayer)
				self.angleText.color = Color.white
			end
			self.lastAngle = anglePlayer
		end
		
	end
end
