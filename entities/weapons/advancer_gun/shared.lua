if SERVER then
	AddCSLuaFile("shared.lua")

end

if CLIENT then
	SWEP.PrintName = "P90"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"
SWEP.HoldType = "ar2"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_p90.Single")
SWEP.Primary.Recoil			= 0.3
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.023
SWEP.Primary.ClipSize		= 35
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 1
/*
function SWEP:SecondaryAttack()
	if CLIENT then return end
	if !IsFirstTimePredicted() or (self.Owner.NextSpeed and self.Owner.NextSpeed > CurTime()) then return end
	if self.Owner.Classes[15] < 2 then return end
	if self.Owner:GetMana() > 30 then
		local sped = Classes[self.Owner.Class].SPEED + (self.Owner.Skills[1]*20)
--		GAMEMODE:SetPlayerSpeed( self.Owner, sped * 8, sped * 8 )
		local vec = self.Owner:GetVelocity()
		self.Owner:SetVelocity(Vector( 0, 0, 250))
		timer.Simple( 0.05, function() self.Owner:SetVelocity( (vec * 3) ) end)
		self.Owner:EmitSound( "physics/flesh/flesh_impact_hard6.wav" )
		self.Owner:TakeMana(30)
		self.Owner.NextSpeed = CurTime() + 1.5
		local fag = self.Owner
	end
end
*/


SWEP.nextFire = 0
SWEP.lastFire = 0
function SWEP:SecondaryAttack()
	if self.Weapon:Clip1() < 10 then return end
	
	if self.nextFire > CurTime() then return end
		self.nextFire = CurTime() + (self.Primary.Delay * 5)
		self.lastFire = CurTime()
	// Play shoot sound
	self.Weapon:EmitSound( "weapons/shotgun/shotgun_fire6.wav" )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	// Shoot the bullet
	self:CSShootBullet( 12, self.Primary.Recoil, 10, self.Primary.Cone * 6 )
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 10 )
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.4,-0.2) * self.Primary.Recoil * 5, math.Rand(-0.5,0.5) * self.Primary.Recoil, 0 ) )
	
	
	if self.Weapon:Clip1() < 1 then
		self:Reload()
	end
end