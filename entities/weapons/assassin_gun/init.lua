SWEP.HoldType = "ar2"
AddCSLuaFile("shared.lua")
include("shared.lua")

	
	
function SWEP:Holster()
self.Weapon:SetNetworkedBool( "zoomed", false )
return true
end
function SWEP:Deploy()
self.Weapon:SetNetworkedBool( "zoomed", false )
return true
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	local zoomed = self.Weapon:GetNWBool("zoomed", false)
	
	if(zoomed) then
		self.Owner:SetFOV(0, 0.1)
	else
		self.Owner:SetFOV(30, 0.1)
	end
	self.Weapon:SetNWBool("zoomed", !zoomed)
end

function SWEP:Reload()
	self.Weapon:SetNWBool( "zoomed", false )
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	local zoomed = self.Weapon:GetNWBool("zoomed", false)
	if !(zoomed) then
		self.Owner:SetFOV(0, 0.1)
		
	end
end
