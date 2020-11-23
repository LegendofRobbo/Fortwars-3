if SERVER then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType = "ar2"

if CLIENT then
	SWEP.PrintName = "Swat Gun"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_M4A1.Single")
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 1
SWEP.Manacost = 80
SWEP.Nadecooldown = CurTime()

function SWEP:SecondaryAttack()

	if self.Owner:GetMana() < self.Manacost or self.Nadecooldown > CurTime() then return end
	
	if SERVER then

		if self.Owner.Classes[10] < 2 then return end
		self.Owner:TakeMana(self.Manacost)
		self.Owner:EmitSound( "weapons/grenade/cook.wav" )
		
		timer.Simple( 0.25, function() -- yeah i know its bad to use timers in predicted functions, bat me
		local nade = ents.Create("nade_swat")
		nade:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector()*20)
		nade.Team = self.Owner:Team()
		nade.LastHolder = self.Owner
		nade:Spawn()
		
		local phys = nade:GetPhysicsObject()
		if phys:IsValid() then
			phys:AddVelocity(self.Owner:GetAimVector()*1000)
		end
		self:SendWeaponAnim(ACT_VM_DRAW)

		end)
	end

	if CLIENT and myClasses[10] < 2 then return end
	self.Nadecooldown = CurTime() + 10
	 if IsFirstTimePredicted() then self:SendWeaponAnim(ACT_VM_IDLE) end
	 self:SetNextPrimaryFire( CurTime() + 1.2 )
	 self:SetNextSecondaryFire( CurTime() + 1.2 )
end