

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:Initialize()
    self.Entity:SetModel( "models/Weapons/w_missile_closed.mdl" )
    self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType(  MOVETYPE_VPHYSICS )   
    self.Entity:SetSolid( SOLID_VPHYSICS )
	self.SpawnTime = CurTime()
	self:EmitSound("darkland/rocket_launcher.mp3")
	self.PhysObj = self.Entity:GetPhysicsObject()
    if (self.PhysObj:IsValid()) then
		self.PhysObj:EnableGravity( false )
		self.PhysObj:EnableDrag( false ) 
		self.PhysObj:SetMass(30)
        self.PhysObj:Wake()
    end
		
	util.PrecacheSound( "explode_4" )
	
end


  
 
 
function ENT:Think() 
local phys = self.Entity:GetPhysicsObject()
local ang = self.Entity:GetForward() * 9000
local upang = self.Entity:GetUp() * math.Rand(700,1000) * (math.sin(CurTime()*30))
local rightang = self.Entity:GetRight() * math.Rand(700,1000) * (math.cos(CurTime()*30))
local force
if self.SpawnTime + 0.5 < CurTime() then
force = ang + upang + rightang
else
force = ang
end
phys:ApplyForceCenter(force)
end


function ENT:Explosion(vel)
	local height, entpos, dis;
	local pos = self.Entity:GetPos()
	local others = ents.FindInSphere( self.Entity:GetPos(), 300  )
		for _, ent in pairs( others ) do
			height = 0
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:Crouching() then
					height = 30
				else
					height = 50
				end
			end
			entpos = ent:GetPos()+Vector(0,0,height)
			dis = entpos:Distance(pos)
			
			local trace = { start = pos, endpos = entpos, filter = self.Entity }
			local tr = util.TraceLine( trace )
			
				if tr.Entity == ent and tr.Entity:IsPlayer() and (tr.Entity:Team() != self:GetOwner():Team() or tr.Entity == self.LastHolder) then
					if self.Entity:GetOwner() != ent then
							local d = DamageInfo()
							d:SetDamage( ((300 - dis)/300)*150 )
							d:SetDamageType( DMG_BLAST )
							d:SetAttacker( self.Entity:GetOwner() )
							d:SetInflictor( self )
							ent:TakeDamageInfo( d )
--						ent:TakeDamage( ((300 - dis)/300)*150 , self.Entity:GetOwner() )
					else
							local d = DamageInfo()
							d:SetDamage( ((300 - dis)/300)*150 )
							d:SetDamageType( DMG_BLAST )
							d:SetAttacker( self )
							d:SetInflictor( self )
							ent:TakeDamageInfo( d )

--						ent:TakeDamage( ((300 - dis)/300)*150 , game.GetWorld() )
					end
				elseif tr.Entity == ent and tr.Entity.tbl and tr.Entity.Team != self:GetOwner():Team() then
					local d = DamageInfo()
					d:SetDamage( ((300 - dis)/300)*60 )
					d:SetDamageType( DMG_BLAST )
					d:SetAttacker( self.Entity:GetOwner() )
					d:SetInflictor( self )
					ent:TakeDamageInfo( d )
--					ent:TakeDamage( ((300 - dis)/300)*60 , self.Entity:GetOwner() )
				end
			end
		end
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetNormal(vel)
	util.Effect( "rocketman", effectdata )			 -- Explosion effect
end

function ENT:PhysicsUpdate( phys )
	phys:AddVelocity( self.Entity:GetForward() * 1.1 );
end 
   
function ENT:PhysicsCollide( data, physobj ) 
	util.Decal("Scorch", data.HitPos + data.HitNormal , data.HitPos - data.HitNormal)
	local p = data.HitEntity
	local v = physobj:GetVelocity()
	if p:IsPlayer() and p:Team() != self:GetOwner():Team() then p:Gib(v) end
	self:Explosion(v)
	self.Entity:Remove()
end

function ENT:OnRemove()
	self.Entity:StopSound( "explode_4" )
end
function ENT:KeyValue( ent, key )
end

function ENT:UpdateTransmitState( ent )
	return TRANSMIT_ALWAYS
end

function ENT:OnTakeDamage(dmginfo)
	local physobj = self:GetPhysicsObject()
	local v = physobj:GetVelocity()
	self:Explosion(v)
	self.Entity:Remove()
end