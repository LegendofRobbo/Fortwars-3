
	AddCSLuaFile("shared.lua")
	include("shared.lua")



SWEP.ManaCost = NEO_MANA_COST


function SWEP:SecondaryAttack()
	if self.Owner:GetMana() > self.ManaCost then
		self.Owner:SetVelocity(self.Owner:GetForward() * 1000)
		self.Owner:TakeMana(self.ManaCost)

	end

	
end

