-- Register the behaviour
behaviour("CWHUD_Medal")

function CWHUD_Medal:Tick()
	if not self.isDead and self.isShown then
		self.timer = self.timer - Time.deltaTime
		if self.timer < 0 then
			self:Kill()
		end
	end
end

function CWHUD_Medal:Init()
	if self.animator == nil then self.animator = self.gameObject.GetComponent(Animator) end

	self.timer = 5.0
	self.isDead = false
	self.isShown = false
	self.animator.SetBool("Dead",false)

	self.gameObject.transform.localScale = Vector3(1,1,1)

	self.targets.canvasGroup.alpha = 0

	self.shrinking = false
end

function CWHUD_Medal:Kill()
	self.timer = -1
	self.isDead = true
	self.animator.SetBool("Dead",true)
end

function CWHUD_Medal:SetText(text)
	self.targets.medalName.text = text
end

function CWHUD_Medal:SetPointsText(text)
	self.targets.bonusText.text = text
end

function CWHUD_Medal:SetSprite(sprite)
	self.targets.medalImage.sprite = sprite
end

function CWHUD_Medal:Show()
	self.targets.canvasGroup.alpha = 1
	self.animator.SetTrigger("Show")
	self.isShown = true
end

function CWHUD_Medal:Shrink()
	local startingScale = 1
	local targetScale = 0.5

	local duration = 2
	local t = self.shrinkTimeElapsed /duration
	local scale = Mathf.Lerp(startingScale, targetScale, t)

	self.gameObject.transform.localScale = Vector3(scale,scale,1)

	if t >= 1 then self.shrink = false end
end

function CWHUD_Medal:StartShrink(duration)
	if not self.shrinking then
		self.shrinking = true
		self.script.StartCoroutine(self:ShrinkCoroutine(duration))
	end
end

function CWHUD_Medal:ShrinkCoroutine(duration)
	return function()
		local startingScale = 1
		local targetScale = 0.6

		local elapsedTime = 0.0
		while(elapsedTime < duration) do
			elapsedTime = elapsedTime + Time.deltaTime

			local t = elapsedTime/duration
			local scale = Mathf.Lerp(startingScale, targetScale, t)

			self.gameObject.transform.localScale = Vector3(scale,scale,1)

			if t >= 1 or self.isDead then break
			else coroutine.yield() end
		end
	end
end

function CWHUD_Medal:StartMoveTo(duration, from, to)
	self.script.StartCoroutine(self:MoveToCoroutine(duration, from, to))
end

function CWHUD_Medal:MoveToCoroutine(duration, from, to)
	return function()
		local elapsedTime = 0.0
		while(elapsedTime < duration) do
			elapsedTime = elapsedTime + Time.deltaTime

			local t = elapsedTime/duration
			local pos = Vector3.Lerp(from, to, t)

			self.gameObject.transform.localPosition = pos

			if t >= 1 or self.isDead then break
			else coroutine.yield() end
		end
	end
end