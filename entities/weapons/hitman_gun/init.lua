AddCSLuaFile("shared.lua")
include("shared.lua")
SWEP.HoldType = "ar2"
	
	
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
	if self.Weapon:GetNetworkedBool( "zoomed" ) == false then
			self.Owner:SetFOV(20, 0.5)
		self.Weapon:SetNetworkedBool( "zoomed", true )
	else
			self.Owner:SetFOV(0, 0.5)
		self.Weapon:SetNetworkedBool( "zoomed", false )
	end
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	self.Weapon:SetNWBool( "zoomed", false )
	self.Owner:SetFOV(0, 0.1)
end
