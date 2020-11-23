

if CLIENT then
	SWEP.PrintName = "Lil' Ponies"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_elite.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_elite.Single")
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.012
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 255
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 0.5

	SWEP.HoldType = "duel"