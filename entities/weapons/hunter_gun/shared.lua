if ( SERVER ) then
 
    AddCSLuaFile( "shared.lua" )
   
    SWEP.HoldType         = "crossbow"
   
end
 
if ( CLIENT ) then
 
    SWEP.PrintName     		= "Crossbow"   
    SWEP.Author    			= "LegendofRobbo"
 
    SWEP.Slot           	= 2
    SWEP.SlotPos        	= 1
    SWEP.ViewModelFOV   	= 55
	SWEP.DrawAmmo			= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.DrawCrosshair 		= false
 
end
------------General Swep Info---------------
SWEP.Author   = "LegendofRobbo"
SWEP.Contact        = ""
SWEP.Spawnable      = true
SWEP.AdminOnly = false
-----------------------------------------------
 
------------Models---------------------------
SWEP.ViewModelFlip	    = false
SWEP.ViewModel      = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel   = "models/weapons/w_crossbow.mdl"
SWEP.Base = "darkland_base"
----------------------------------------------
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.NextFire = CurTime()
end

function SWEP:Deploy()
	self.NextFire = CurTime()
end
 
 
function SWEP:Think() -- Called every frame

end


function SWEP:Reload()
end


local fs = Sound("Weapon_Crossbow.Single")
function SWEP:Rocket()
	if CLIENT then return end
	local spos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector()
	local pos = spos + (aim * 50)
	pos = pos + (self.Owner:GetRight() * 10)
	local rocket = ents.Create( "crossbow_bolt" )	
	rocket:SetOwner( self.Owner )
	rocket.LastHolder = self.Owner
	rocket:SetPos( pos )
	local ang = self:GetAngles()
	ang:RotateAroundAxis( self:GetAngles():Up(), 90)
	rocket:SetAngles( ang )
	rocket:Spawn()
	rocket:Activate()
	
	self.Owner:ViewPunch( Angle( math.Rand( -5, -10 ), math.Rand( 0, 0 ), math.Rand( 0, 0 ) ) )	
end

function SWEP:myReload()
	if !IsFirstTimePredicted() then return end
		self.Weapon:EmitSound("Weapon_Crossbow.Reload")
		self:SendWeaponAnim( ACT_VM_RELOAD )
end

function SWEP:PrimaryAttack()
	if self.NextFire > CurTime() then return false end
		local spos = self.Owner:GetShootPos()
		local aim = self.Owner:GetAimVector()
		local pos = spos + (aim * 50)
		local tr = {}
		tr.start = spos
		tr.endpos = pos
		tr.filter = self.Owner
		tr = util.TraceLine(tr)
		if tr.Hit then self.Weapon:EmitSound( "Weapon_RPG.Empty" ) return end
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:Rocket( self.Owner:GetAimVector() )
		self.NextFire = CurTime() + 1.2
			self:EmitSound(fs)

		self:myReload()
		
end
