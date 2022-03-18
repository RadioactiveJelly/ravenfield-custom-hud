-- Register the behaviour
behaviour("CustomHUD_CameraShake")

function CustomHUD_CameraShake:Start()
	-- Run when behaviour is created
	
end

function CustomHUD_CameraShake:Update()
	local cam = PlayerCamera.fpCameraLocalRotation.eulerAngles
	self.transform.localRotation = Quaternion.Euler(Vector3(cam.x, cam.y, cam.z))
end
