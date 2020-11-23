AddCSLuaFile("shared.lua")


	include("shared.lua")
	SWEP.HoldType = "grenade"
	
	
function SWEP:Initialize()
		self:SetHoldType( "grenade" ) --its a knife
end

