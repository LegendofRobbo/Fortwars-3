

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:Initialize()
    self.Entity:SetModel( "models/weapons/w_eq_fraggrenade_thrown.mdl" )
    self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType(  MOVETYPE_VPHYSICS )   
    self.Entity:SetSolid( SOLID_VPHYSICS )	
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	--timer.Simple(2,self.Explode,self)
	timer.Simple(3,function() if self:IsValid() then self:Explode() end end)
	util.SpriteTrail(self, 0, team.GetColor(self.LastHolder:Team()), false, 4, 4, 0.5, 1, "trails/plasma.vmt")
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:PhysicsCollide()
self:Explode()
end

function ENT:Explode()

	if !self then return end
	local kills = 0
	local amount = 200
	local attacker = self.LastHolder
	if !IsValid(attacker) then
		attacker = self
	end

		local pos = self:GetPos()
		local getents = ents.FindInSphere( pos, 300 )
		for i,v in pairs(getents) do
			local target = false
			if v:GetTeam() != self:GetTeam() || v == self.LastHolder then
				if v.tbl then
					local min = v:OBBMins()
					local max = v:OBBMaxs()
					local vPos = v:GetPos()
					target = {
							vPos,
							vPos+min,
							vPos+max,
							vPos+Vector(min.x,min.y,max.z),
							vPos+Vector(min.x,max.y,max.z),
							vPos+Vector(max.x,min.y,max.z),
							vPos+Vector(max.x,max.y,min.z),
							vPos+Vector(min.x,max.y,min.z),
							vPos+Vector(max.x,min.y,min.z)
						}
				elseif v:IsPlayer() then
					if v:Crouching() then
						target = {v:GetPos() + Vector( 0, 0, 30 )}
					else
						target = {v:GetPos() + Vector( 0, 0, 48 )}
					end
				end
			end
			if target then
				for _, tg in pairs( target ) do
					local trace = {}
					trace.start = pos
					trace.endpos = tg
					trace.filter = self
					local ent = util.TraceLine(trace).Entity
					if IsValid(ent) and ent == v then
						if ent:IsPlayer() then
							
							local d = DamageInfo()
							d:SetDamage( (1-ent:GetPos():Distance(pos)/300)*85 )
							d:SetDamageType( DMG_BLAST )
							if self.LastHolder == ent then d:SetAttacker( self ) else d:SetAttacker( attacker ) end
							d:SetInflictor( self )
							ent:TakeDamageInfo( d )

						else
							local d = DamageInfo()
							d:SetDamage( (1-ent:GetPos():Distance(pos)/300)*100 )
							d:SetDamageType( DMG_BLAST )
							if self.LastHolder == ent then d:SetAttacker( self ) else d:SetAttacker( attacker ) end
							d:SetInflictor( self )
							ent:TakeDamageInfo( d )
						end
					end
				end
			end
		end

		
		
		
	local effectdata = EffectData()
	effectdata:SetStart( pos )
	effectdata:SetOrigin( pos )
	effectdata:SetScale( 8 )
	util.Effect( "Explosion", effectdata )
	self:Remove()

end

function ENT:UpdateTransmitState() 
	return TRANSMIT_ALWAYS 
end

function ENT:OnTakeDamage(dmginfo)



end