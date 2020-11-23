
if CLIENT then
	SWEP.PrintName = "Ninja Gun"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.2
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


SWEP.nextFire = 0
SWEP.lastFire = 0
function SWEP:PrimaryAttack()
	if self.nextFire > CurTime() then return end
	self.nextFire = CurTime() + self.Primary.Delay
	self.lastFire = CurTime()
	
	local ninjamods = self.Weapon:GetNWBool("mods", false)
	if ( ninjamods ) then
		self.Weapon:EmitSound("Weapon_TMP.Single")
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_SILENCED ) 
	else
		self.Weapon:EmitSound(Sound("Weapon_USP.Single"))
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	end

	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	
	self:TakePrimaryAmmo( 1 )
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	if self.Weapon:Clip1() < 1 then
		self:Reload()
	end

end


function SWEP:SecondaryAttack()
local ninjamods = self.Weapon:GetNWBool("mods", false)
	if ( ninjamods ) then
		self.Weapon:SendWeaponAnim( ACT_VM_DETACH_SILENCER )
		self.Weapon:SetNetworkedBool( "mods", false )
	else
		self.Weapon:SendWeaponAnim( ACT_VM_ATTACH_SILENCER ) 
		self.Weapon:SetNetworkedBool( "mods", true )
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 3 )
end

function SWEP:Reload()
local ninjamods = self.Weapon:GetNWBool("mods", false)
    if ( ninjamods ) then
	self.Weapon:DefaultReload( ACT_VM_RELOAD_SILENCED );
	else
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	end
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
local ninjamods = self.Weapon:GetNWBool("mods", false)
if ( ninjamods ) then
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW_SILENCED );
	else
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	end
return true
end

function SWEP:OnRemove()
self.Weapon:SetNetworkedBool( "mods", false )
end