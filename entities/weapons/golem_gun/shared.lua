if SERVER then
	AddCSLuaFile("shared.lua")

end

if CLIENT then
	SWEP.PrintName = "HammerDown"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"
SWEP.HoldType = "ar2"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip 		= false
SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 75
SWEP.Primary.Delay			= 0.09
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 1

SWEP.LockedDown = false

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "LockedDown" )
end

function SWEP:SecondaryAttack()

	if SERVER and IsFirstTimePredicted() and self.Owner:IsOnGround() and self.Owner:Alive() then 
		if !self:GetLockedDown() then
			if self.Owner.Classes[6] < 2 or self.Owner:GetMana() < 90 then return end

			self:SetLockedDown( true )
			self.Owner:EmitSound( "npc/roller/blade_cut.wav" )
			GAMEMODE:SetPlayerSpeed( self.Owner, 1, 1 ) 
			self.Owner:SetJumpPower( 1 )
			self.Owner:TakeMana(90)
		else
			self:SetLockedDown( false )
			GAMEMODE:ResetSpeed( self.Owner ) 
			self.Owner:SetJumpPower( 200 ) 
			self.Owner:EmitSound( "npc/roller/blade_in.wav" )
		end

	end
	self:SetNextSecondaryFire( CurTime() + 1 )
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	if self.Owner:Crouching() then cone = cone * 0.6 end
	if self:GetLockedDown() then 
		cone = cone * 0.7
		recoil = recoil * 0.6
	end
	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0 )			// Aim Cone
	bullet.Tracer	= 4								// Show a tracer on every x bullets 
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	self.Owner:FireBullets( bullet )

	// CUSTOM RECOIL !
	if CLIENT then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end

end

function SWEP:DrawHUD()

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0
	local cone = self.Primary.Cone
	if self:GetLockedDown() then cone = cone * 0.7 end
	if self.Owner:Crouching() then cone = cone * 0.6 end
	local scale = 10 * cone
	
	
	// Scale the size of the crosshair according to how long ago we fired our weapon
	local LastShootTime = self.lastFire
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
	
	surface.SetDrawColor( 0, 255, 0, 255 )
	
	// Draw an awesome crosshair
	local gap = 40 * scale
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )

end