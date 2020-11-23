	SWEP.HoldType = "pistol"
	AddCSLuaFile("shared.lua")
	include("shared.lua")
	
function SWEP:PrimaryAttack()

	self.Owner:EmitSound(Sound("darkland/fortwars/bomberlol.mp3"),100,100)
	--timer.Simple(2,self.Boom,self)
	local btime = 2
	if self.Owner.Classes[9] == 2 then btime = 1.3 end
	timer.Simple(btime, function() self:Boom() end)
	self.Weapon:SetNextPrimaryFire(CurTime() + 4)
end

function SWEP:Boom()
	if !self or !self.Owner or !self.Owner:Alive() then return end
	local kills = 0
	local mypos = self.Owner:GetPos()
	local height = 48
	if self.Owner:Crouching() then
		height = 20
	end
		local pos = self.Owner:GetPos() + Vector( 0, 0, height )
		local getents = ents.FindInSphere( pos, 300 )
		for i,v in pairs(getents) do
			local target = false
			--print(v:GetTeam() != self.Owner:Team(),v.tbl,v)
			if v:GetTeam() != self.Owner:Team() then
			
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
					trace.filter = self.Owner
					local ent = util.TraceLine(trace).Entity
					if IsValid(ent) and ent == v then
						if ent:IsPlayer() then
--							local died = ent:TakeDmg((1-ent:GetPos():Distance(pos)/300)*300, self.Owner)
							local d = DamageInfo()
							d:SetDamage( (1-ent:GetPos():Distance(pos)/300)*300 )
							d:SetDamageType( DMG_BLAST )
							d:SetAttacker( self.Owner )
							d:SetInflictor( self )
							ent:TakeDamageInfo( d )
							if !ent:Alive() then 
--								self.Owner:AddFrags(1) 
								kills = kills + 1 
							end
						else
							local d = DamageInfo()
							d:SetDamage( (1-ent:GetPos():Distance(pos)/300)*75 )
							d:SetDamageType( DMG_BLAST )
							d:SetAttacker( self.Owner )
							d:SetInflictor( self )
							ent:TakeDamageInfo( d )
						end
					end
				end
			end
		end
		hook.Call("OnExplodeBomb",GAMEMODE,self.Owner,kills)
		
		
		
		
	local effectdata = EffectData()
	effectdata:SetStart( mypos )
	effectdata:SetOrigin( mypos )
	effectdata:SetScale( 8 )
	util.Effect( "Explosion", effectdata )

		self.Owner.lastAttacker = self.Owner
		self.Owner.lastAttack = CurTime()+5

							local d = DamageInfo()
							d:SetDamage( 6666 )
							d:SetDamageType( DMG_BLAST )
							d:SetAttacker( self )
							d:SetInflictor( self )
							self.Owner:TakeDamageInfo( d )


--		self.Owner:Kill()
		-- self.Owner:AddFrags(1)
end
