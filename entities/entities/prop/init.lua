

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:Initialize()
	
    self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType(  MOVETYPE_VPHYSICS )   
    self.Entity:SetSolid( SOLID_VPHYSICS )	
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
	self:SetNWInt("Health",self.TBL.HEALTH)
	self:SetNWInt("MaxHP",self:GetHealth())
	self.MaxHP = self:GetHealth()
	self:DrawShadow(false)
end

function ENT:SetPropTable(t)
	self.TBL = t
end

function ENT:OnRemove() 
	BoxRemoved(self,self.Spawner) 
end


function ENT:UpdateTransmitState() 
	return TRANSMIT_PVS
end

function ENT:OnTakeDamage(dmginfo)
	if !DEATHMATCH then return end
	
	local amt = dmginfo:GetDamage()
	
	
	self:SetNWInt("Health",self:GetHealth()-amt)
	
	local hp = self:GetHealth()
	if self:GetHealth() < 1 then self:Remove() end
	
	
		
	local entteam = self.Team
	
	if entteam != dmginfo:GetAttacker():GetTeam() then
		dmginfo:GetAttacker().BuildingDamage = dmginfo:GetAttacker().BuildingDamage + amt
	end
	
	
	local calc = hp*255/self.MaxHP

	if entteam == 1 then
		self:SetColor(Color(0,0,calc,255))
	elseif entteam == 2 then
		self:SetColor(Color(calc,0,0,255))
	elseif entteam == 3 then
		self:SetColor(Color(calc,calc,0,255))
	elseif entteam == 4 then
		self:SetColor(Color(0,calc,0,255))
	end
end