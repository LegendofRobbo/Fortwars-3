if SERVER then
	AddCSLuaFile("shared.lua")

end

if CLIENT then
	SWEP.PrintName = "Super Shotty"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"
SWEP.HoldType = "ar2"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 13
SWEP.Primary.NumShots		= 4
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 1.0
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "BuckShot"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 1
if CLIENT then NextShotty = 0 end

--RIPPED OUT OF THE CSS GUN, I DID NOT MAKE THIS
function SWEP:Reload()
	
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	

	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		
	end

end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Owner.NextShotty = self.Owner.NextShotty or 0
	if SERVER and self.Owner.NextShotty > CurTime() then return end
	if CLIENT and NextShotty > CurTime() then return end
	
	// Play shoot sound
	self.Weapon:EmitSound( self.Primary.Sound )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	// Shoot the bullet
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	NextShotty = CurTime() + 0.8
	self.Owner.NextShotty = CurTime() + 0.8
	self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	
	if self.Weapon:Clip1() < 1 then
		self:Reload()
	end
end

function SWEP:Think()


	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
	
		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			
			// Finsished reload -
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNetworkedBool( "reloading", false )
				return
			end
			
			// Next cycle
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			// Finish filling, final pump
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			else
			
			end
			
		end
	
	end

end


function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	if self.Owner:Crouching() then cone = cone * 0.6 end
	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0 )			// Aim Cone
	bullet.Tracer	= 1								// Show a tracer on every x bullets 
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	bullet.Callback = function( ply, tr, dmg )
	if CLIENT then return end
	if ply.Classes[8] < 2 then return end
	if tr.Entity:IsValid() and tr.Entity:IsPlayer() then 
		local p = tr.Entity
		local sped = Classes[p.Class].SPEED + (p.Skills[1]*20)
		GAMEMODE:SetPlayerSpeed( p, sped * 0.6, sped * 0.6 ) 
		timer.Create("slowtimer_"..p:UniqueID(), 1.5, 1, function() if p:IsValid() then GAMEMODE:ResetSpeed( p ) end end)
		end
	end
	self.Owner:FireBullets( bullet )

	// CUSTOM RECOIL !
	if CLIENT then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end

end