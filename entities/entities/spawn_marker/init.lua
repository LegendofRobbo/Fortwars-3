AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
SpawnBoxes = {}
function ENT:Initialize()
	self:PhysicsInitBox( Vector( -16, -16, -1 ), Vector( 16, 16, 73 ) )
	self:SetCollisionBounds( Vector( -16, -16, -1 ), Vector( 16, 16, 73 ) )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetMoveType( MOVETYPE_NONE )
	self:DrawShadow( false )
	self.enabled = true
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	local ent = ents.Create( "prop_dynamic" )
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:SetModel("models/PLAYER.mdl")
	ent:SetMaterial("models/debug/debugwhite")
	ent:SetNotSolid(true)
	ent:DrawShadow(false)
	ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	if self.color then ent:SetColor( Color(self.color.r*0.6, self.color.g*0.6, self.color.b*0.6, 120) ) end
	ent:Spawn()
	ent:Activate()
	self.effect = ent
	self.TouchingEnts = {}

end


function ENT:Enable()
	self:SetNotSolid(false)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.effect:SetNoDraw(false)
	self.enabled = true
end

function ENT:Disable()
	self:SetNotSolid(true)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self.effect:SetNoDraw(true)
	self.enabled = false
end

function ENT:StartTouch(ent)
	if ent:GetClass() == "prop" then
		ent.DeletionIndex = table.insert(SpawnBoxes,ent)
		local r,g,b,a = ent:GetColor()
		ent.oldcolor = Color(r,g,b,255)
		ent:SetColor( Color(r, g, b, 100) )
		ent.TouchingSpawns = ent.TouchingSpawns or {}
		self.TouchingEnts[ent] = table.insert(ent.TouchingSpawns,self)

	end
end


function ENT:Touch(ent)

end

function ENT:EndTouch(ent)
	if ent:GetClass() == "prop" then
		table.remove(SpawnBoxes,ent.DeletionIndex)
		
		table.remove(ent.TouchingSpawns,self.TouchingEnts[ent])
		self.TouchingEnts[ent] = nil
		
		if table.getn(ent.TouchingSpawns) < 1 then
			ent:SetColor( ent.oldcolor )
		end
	end
end

function ENT:OnTakeDamage(something) --spammed consolelooking for this
end

function ENT:PhysicsUpdate(something) --spammed consolelooking for this
end

function ENT:PhysicsCollide(something) --spammed consolelooking for this
end
function ENT:Use(something) --spammed consolelooking for this
end