if SERVER then AddCSLuaFile("shared.lua") end
SWEP.Author			= "Darkspider"
SWEP.Contact		= ""
SWEP.Purpose		= "Create custom spawn"
SWEP.Instructions	= "Shoot and spawn where you are standing"
SWEP.PrintName = "Spawn Gun"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_irifle.mdl"
SWEP.WorldModel		= "models/weapons/w_irifle.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1				// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"
SWEP.nextFire = 0
function SWEP:PrimaryAttack()
	if self.nextFire > CurTime() then return end
	if SERVER then
		if !IsValid(self.Owner.SpawnPoint) then
			self.Owner.SpawnPoint = ents.Create("darkland_spawn")
			self.Owner.SpawnPoint:Spawn()
		end
		self.Owner.SpawnPoint:SetPos(self.Owner:GetPos())
		self.Owner.SpawnAng = self.Owner:EyeAngles()
		self.Owner:EmitSound("ambient/machines/catapult_throw.wav")
	end
	self.nextFire = CurTime()+1
	local ef = EffectData()
	ef:SetOrigin(self.Owner:GetPos())
	util.Effect("spawngun",ef)
end
function SWEP:SecondaryAttack()
	if CLIENT then return end
	if IsValid(self.Owner.SpawnPoint) then
		self.Owner.SpawnPoint:Remove()
		self.Owner.SpawnPoint = nil
		self.Owner.SpawnAng = nil
	end
end