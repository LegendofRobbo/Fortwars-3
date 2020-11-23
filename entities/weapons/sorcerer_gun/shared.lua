if ( CLIENT ) then

	SWEP.PrintName		= "Divine Power"			
	SWEP.Author		= "Darkspider"
	SWEP.Slot		= 1
	SWEP.SlotPos		= 1
	SWEP.Description	= ""
	SWEP.Purpose		= ""
	SWEP.Instructions	= ""
	
end

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel			= "models/weapons/w_stunbaton.mdl"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "melee"

SWEP.Primary.Recoil		= 0.001
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone		= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay		= 0.3
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.Delay		= 1
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"


function SWEP:PrimaryAttack()
	if self.Owner:GetMana() < 30 then return end
	if SERVER then
		local vStart = self.Owner:GetShootPos()
		local vForward = self.Owner:GetAimVector()
		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + (vForward * 4096) 
		trace.filter = self.Owner
		local tr = util.TraceLine(trace)
		local norm = tr.Normal
		local pos = tr.HitPos
		self.Owner:EmitSound(Sound("npc/vort/attack_shoot.wav"))

		util.Decal("FadingScorch", pos + norm, pos - norm )

	end
			bullet = {}
			bullet.Num=1
			bullet.Src=self.Owner:GetShootPos()
			bullet.Dir=self.Owner:GetAimVector()
			bullet.Spread=Vector(0,0,0)
			bullet.Tracer=1
			bullet.TracerName = "fw_sorcerer_lightning"
			bullet.Force=2
			bullet.Damage = 60
			bullet.Callback	= function(attacker, tr, dmginfo)
			if IsFirstTimePredicted() then
			local effectdata = EffectData()
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetScale(1)
				effectdata:SetMagnitude(3)
				effectdata:SetRadius(5)
			util.Effect("Sparks", effectdata)
			end
			if SERVER then
				if tr.Entity:IsValid() and tr.Entity:IsPlayer() then
					dmginfo:SetDamage( 0 )
					tr.Entity:TakeDamage( 60, self.Owner, self )
				end
			end

			end

			self:SendWeaponAnim( ACT_VM_HITCENTER )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			 
			self.Owner:FireBullets(bullet)
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
			if SERVER then self.Owner:TakeMana(30) end

end


function SWEP:SecondaryAttack()
	if self.Owner:GetMana() < 45 then return end
	if SERVER and self.Owner.Classes[12] < 2 then return end
	if CLIENT and myClasses[12] < 2 then return end
	if SERVER then
		local vStart = self.Owner:GetShootPos()
		local vForward = self.Owner:GetAimVector()
		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + (vForward * 4096) 
		trace.filter = self.Owner
		local tr = util.TraceLine(trace)
		local norm = tr.Normal
		local pos = tr.HitPos
		self.Owner:EmitSound(Sound("npc/vort/attack_shoot.wav"))

		util.Decal("FadingScorch", pos + norm, pos - norm )

	end
			bullet = {}
			bullet.Num=1
			bullet.Src=self.Owner:GetShootPos()
			bullet.Dir=self.Owner:GetAimVector()
			bullet.Spread=Vector(0,0,0)
			bullet.Tracer=1
			bullet.TracerName = "fw_sorcerer_lightning"
			bullet.Force=2
			bullet.Damage = 50
			bullet.Callback	= function(attacker, tr, dmginfo)
			if IsFirstTimePredicted() then
			local effectdata = EffectData()
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetScale(1)
				effectdata:SetMagnitude(3)
				effectdata:SetRadius(5)
			util.Effect("Sparks", effectdata)
			end


				for k, v in pairs(ents.FindInSphere(tr.HitPos,400)) do
					if !v:IsPlayer() then continue end
					if v:Team() == self.Owner:Team() then continue end
					if tr.Entity:IsValid() and tr.Entity:IsPlayer() and v == tr.Entity then continue end
					
					local ntrace = {}
					ntrace.start = tr.HitPos
					ntrace.endpos = v:GetPos() + Vector( 0, 0, 35 )
					if tr.Entity:IsValid() and tr.Entity:IsPlayer() then ntrace.filter = tr.Entity end
					ntrace.mask = MASK_SHOT
					local ntr = util.TraceLine(ntrace)

					if ntr.Entity:IsValid() and ntr.Entity == v then
						nbullet = {}
						nbullet.Num = 1
						nbullet.Src = tr.HitPos
						nbullet.Dir = (v:GetPos() + Vector( 0,0,40) - tr.HitPos )
						nbullet.Spread = Vector(0,0,0)
						nbullet.Tracer = 1
						nbullet.TracerName = ""
						nbullet.Force = 2
						nbullet.Damage = 40
						nbullet.Callback = function(attacker, nbtr, dmginfo)
						if IsFirstTimePredicted() then
							local effectdata = EffectData()
							effectdata:SetOrigin(tr.HitPos)
							effectdata:SetStart(nbtr.HitPos)
							util.Effect("fw_sorcerer_lightning2", effectdata)
						end

						if SERVER then
							if nbtr.Entity:IsValid() and nbtr.Entity:IsPlayer() then
							dmginfo:SetDamage( 0 )
							nbtr.Entity:TakeDamage( 40, self.Owner, self )
						end
					end

						end
						self.Owner:FireBullets(nbullet)
						break
					end

				end
			if SERVER then
				if tr.Entity:IsValid() and tr.Entity:IsPlayer() then
					dmginfo:SetDamage( 0 )
					tr.Entity:TakeDamage( 50, self.Owner, self )
				end
			end

			end

			self:SendWeaponAnim( ACT_VM_HITCENTER )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			 
			self.Owner:FireBullets(bullet)
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
			if SERVER then self.Owner:TakeMana(45) end

end