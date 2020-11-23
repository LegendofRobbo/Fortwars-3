
if CLIENT then
	SWEP.PrintName = "SSR"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Scout.Single")
SWEP.Primary.Recoil			= 0.41
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Delay			= 0.01
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 255
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "SniperRound"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 0.5

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	if self.Owner:Crouching() then cone = cone * 0.6 end
	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0 )			// Aim Cone
	bullet.Tracer	= 4								// Show a tracer on every x bullets 
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	bullet.Callback = function( ply, tr, dmg )
		if !SERVER or ply.Classes[5] < 2 then return end
		if tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() then tr.Entity:SetNWBool( "tagshotted", true ) end
	end
	self.Owner:FireBullets( bullet )

	// CUSTOM RECOIL !
	if CLIENT then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end

end