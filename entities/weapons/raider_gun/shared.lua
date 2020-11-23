if SERVER then
	AddCSLuaFile("shared.lua")

end

if CLIENT then
	SWEP.PrintName = "MAC10"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base				= "darkland_base"
SWEP.HoldType = "ar2"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_mac10.Single")
SWEP.Primary.Recoil			= 0.3
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.023
SWEP.Primary.ClipSize		= 35
SWEP.Primary.Delay			= 0.09
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 255
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 1

SWEP.Sounds = {
	"vo/ravenholm/monk_quicklybro.wav",
	"vo/ravenholm/exit_goquickly.wav",
	"vo/ravenholm/monk_coverme01.wav",
}

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if !IsFirstTimePredicted() or (self.Owner.NextSpeed and self.Owner.NextSpeed > CurTime()) then return end
	if self.Owner.Classes[3] < 2 then return end
	if self.Owner:GetMana() > 70 then
		local sped = Classes[self.Owner.Class].SPEED + (self.Owner.Skills[1]*20)
		GAMEMODE:SetPlayerSpeed( self.Owner, sped * 1.6, sped * 1.6 )
		self.Owner:EmitSound( tostring(table.Random( self.Sounds )) )
		self.Owner:TakeMana(70)
		self.Owner.NextSpeed = CurTime() + 5
		local fag = self.Owner
		
		timer.Simple(3, function()
			if IsValid(fag) then 
				GAMEMODE:ResetSpeed( fag )
			end 
		end)
	end
end
