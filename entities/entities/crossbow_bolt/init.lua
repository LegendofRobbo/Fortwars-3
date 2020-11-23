

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:Initialize()
    self.Entity:SetModel( "models/props_c17/TrapPropeller_Lever.mdl" )
    self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType(  MOVETYPE_VPHYSICS )   
    self.Entity:SetSolid( SOLID_VPHYSICS )	
	/*
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	*/
	--timer.Simple(2,self.Explode,self)
	timer.Simple(3,function() if self:IsValid() then self:Explode() end end)
	util.SpriteTrail(self, 0, team.GetColor(self.LastHolder:Team()), false, 4, 4, 0.5, 1, "trails/plasma.vmt")
--	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:EnableGravity(false)
		phys:EnableDrag(false) 
		phys:SetMass(2)
        	phys:Wake()
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_PENETRATING)
	end
	self.ded = false

end

function ENT:Think()

	if self:WaterLevel() > 0 then self:Remove() end
	local phys 		= self.Entity:GetPhysicsObject()
	local ang 		= self.Entity:GetRight() * 100000
	local up		= self.Entity:GetUp() * -800

	local force		= ang + up

	phys:ApplyForceCenter(force)

	if (self.Entity.HitWeld) then  
		self.HitWeld = false  
		constraint.Weld(self.Entity.HitEnt, self.Entity, 0, 0, 0, true)  
	end 

end


function ENT:PhysicsCollide()
if self.ded then return end
self.ded = true
self:SetMoveType( MOVETYPE_NONE )
self:SetRenderMode( RENDERMODE_NONE )
self.Entity:EmitSound("Weapon_Crossbow.BoltHitWorld")
timer.Simple( 1, function() if self:IsValid() then self:Remove() end end)
end

function ENT:Explode()
	self:Remove()

end

function ENT:UpdateTransmitState() 
	return TRANSMIT_ALWAYS 
end

function ENT:OnTakeDamage(dmginfo)



end