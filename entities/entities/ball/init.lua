

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:Initialize()
    self.Entity:SetModel( "models/roller.mdl" )
    self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType(  MOVETYPE_VPHYSICS )   
    self.Entity:SetSolid( SOLID_VPHYSICS )	
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end


function ENT:UpdateTransmitState() 
	return TRANSMIT_ALWAYS 
end

function ENT:OnTakeDamage(dmginfo)



end