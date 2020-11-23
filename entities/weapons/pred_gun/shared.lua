

if CLIENT then
	SWEP.PrintName = "Killer Blade"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = false
end



util.PrecacheSound("weapons/knife/knife_hit1.wav")

util.PrecacheSound("weapons/knife/knife_hitwall1.wav")
util.PrecacheSound("weapons/knife/knife_slash1.wav")
util.PrecacheSound("weapons/physcannon/energy_sing_flyby2.wav")
--meh
SWEP.Author			= "Darkspider"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"
SWEP.HoldType = "knife"

SWEP.Primary.Damage			= 40
SWEP.Primary.BackStab		= 2000
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Delay		= 12
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.vis = 2
SWEP.nextinvis = 0
SWEP.invis = false
SWEP.setstate = false


function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

-- Make sure the player becomes visible when spawns/dies/switches weapons
function SWEP:Deploy()
	self:SetVis(2)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)	
	return true
end
function SWEP:Holster()
	self:SetVis(2)
	return true
end
function SWEP:OnRemove()
	self:SetVis(2)
end

-- Invisble types
function SWEP:Think()
if self:GetVis() == 0 and !self.Owner:Crouching() then self:SetVis(1) return end
if self:GetVis() == 1 and self.Owner:Crouching() then self:SetVis(0) return end
end

function SWEP:GetVis()
return self.vis
end

function SWEP:SetVis(int)
	int2 = int + 1
	local alpha = {15, 30, 255}

	if CLIENT then
		local colc = team.GetColor(LocalPlayer():Team())
		if IsValid(LocalPlayer():GetViewModel()) then
			local vm = LocalPlayer():GetViewModel()
			if vm:GetRenderMode() != RENDERMODE_TRANSALPHA then vm:SetRenderMode(RENDERMODE_TRANSALPHA) end
			vm:SetColor(Color(255,255,255,alpha[int2]))
		end
	end

	if self.Weapon:GetRenderMode() != RENDERMODE_TRANSALPHA then self.Weapon:SetRenderMode(RENDERMODE_TRANSALPHA) end
	self.Weapon:SetColor(Color(255,255,255,alpha[int2]))

	if SERVER then
		local col = team.GetColor(self.Owner:Team())
		if self.Owner:GetRenderMode() != RENDERMODE_TRANSALPHA then self.Owner:SetRenderMode(RENDERMODE_TRANSALPHA) end
		self.Owner:SetColor(Color(col.r,col.g,col.b,alpha[int2]))
--		if int2 < 3 then self.Owner:SetMaterial("models/effects/vol_lightmask01") else self.Owner:SetMaterial("") end
		
	end
	self.vis = int
end

function SWEP:SecondaryAttack()
	if self.Owner:GetMana() < PRED_MANA_INVIS then return end
	-- if VIP and self.Owner.VIP then return end

	if self:GetVis() == 2 then
		self:SetVis(1)
		self.Weapon:EmitSound(Sound( "weapons/physcannon/energy_sing_flyby2.wav"), 100,120)
		if SERVER then
			self.Owner:TakeMana(PRED_MANA_INVIS)
		end
	end
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + .4)

	local pos = self.Owner:GetShootPos()
	local dir = self.Owner:GetAimVector()

/* --------------- old trace  ---------------
	local trace = {}
	trace.start = pos
	trace.endpos = pos + (dir * 75)
	trace.filter = self.Owner
	local tr = util.TraceLine(trace)
*/

	--------------- new trace  ---------------
	local tr = util.TraceLine( {
		start = pos,
		endpos = pos + (dir * 75),
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = pos,
			endpos = pos + (dir * 75),
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 )
		} )
	end


	if tr.Hit then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		local worldpos1 = tr.HitPos + tr.HitNormal
		local worldpos2 = tr.HitPos - tr.HitNormal
		util.Decal("ManhackCut",worldpos1,worldpos2)
		self.Weapon:EmitSound(Sound("weapons/knife/knife_hit"..math.random(1,4)..".wav"))
		if !tr.HitWorld and !tr.Entity:IsPlayer() then
				if !CLIENT then
					tr.Entity:TakeDamage(10,self.Owner)
				end
		elseif !tr.HitWorld and tr.Entity:IsPlayer() then
				if !CLIENT then
					-- if self:GetVis() != 2 then
						local y1, y2 = tr.Entity:GetAngles().y, self.Owner:GetAngles().y
						local AngDiff = y1 - y2
						
						if AngDiff <= 60 and AngDiff >= -60 then -- if behind the player :D finally got this to work how it is ment to :DDdD
							tr.Entity:TakeDamage(self.Primary.BackStab,self.Owner)
						else
							tr.Entity:TakeDamage(self.Primary.Damage + 10,self.Owner)
						end
					-- else
						-- tr.Entity:TakeDamage(self.Primary.Damage,self.Owner)
					-- end
				end
		end
	else
		self.Weapon:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if self:GetVis() != 2 then
		self:SetVis(2)
	end
end

function SWEP:Reload()
end

function SWEP:DrawWorldModel()
	print(self:GetVis())
	if self:GetVis() == 2 then self:DrawModel() end
end