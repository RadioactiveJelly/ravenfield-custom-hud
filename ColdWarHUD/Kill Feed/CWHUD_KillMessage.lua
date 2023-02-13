-- Register the behaviour
behaviour("CWHUD_KillMessage")

function CWHUD_KillMessage:Tick()
	if not self.isDead and self.isShown then
		self.timer = self.timer - Time.deltaTime
		if self.timer < 0 then
			self:Kill()
		end
	end
end

function CWHUD_KillMessage:Init()
	if self.animator == nil then self.animator = self.gameObject.GetComponent(Animator) end

	self.timer = 2.5
	self.isDead = false
	self.isShown = false

	self.animator.ResetTrigger("Hide")
	self.animator.ResetTrigger("Show")
	
	self.withPoints = false
end

function CWHUD_KillMessage:SetText(text)
	self.targets.message.text = text
end

function CWHUD_KillMessage:SetID(id)
	self.ID = id
end

function CWHUD_KillMessage:SetPoints(text)
	self.targets.points.text = text
	self.animator.SetBool("WithPoints",true)
end

function CWHUD_KillMessage:Kill()
	self.timer = -1
	self.isDead = true
end

function CWHUD_KillMessage:Hide()
	self.animator.SetTrigger("Hide")
	self.animator.ResetTrigger("Show")
end

function CWHUD_KillMessage:Show()
	self.animator.SetTrigger("Show")
	print("Show " .. self.ID)
	self.isShown = true
end