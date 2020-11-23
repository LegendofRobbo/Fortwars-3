if ( SERVER ) then
 
    AddCSLuaFile( "shared.lua" )
   
    SWEP.HoldType         = "rpg"
   
end
 
if ( CLIENT ) then
 
    SWEP.PrintName     		= "Rocket Launcher"   
    SWEP.Author    			= "Protocol7"
 
    SWEP.Slot           	= 2
    SWEP.SlotPos        	= 1
    SWEP.ViewModelFOV   	= 55
    SWEP.IconLetter   	 	= ""
	SWEP.DrawAmmo			= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.DrawCrosshair 		= false
	killicon.AddFont( "weapon_antitank", "CSKillIcons", SWEP.IconLetter, Color( 0, 255, 0, 255 ) )
 
end
------------General Swep Info---------------
SWEP.Author   = "Protocol7"
SWEP.Contact        = ""
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
-----------------------------------------------
 
------------Models---------------------------
SWEP.ViewModelFlip	    = false
SWEP.ViewModel      = "models/weapons/v_rpg.mdl"
SWEP.WorldModel   = "models/weapons/w_rocket_launcher.mdl"
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



function SWEP:Rocket()
	if CLIENT then return end
	local spos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector()
	local pos = spos + (aim * 50)
	pos = pos + (self.Owner:GetRight() * 10)
	local rocket = ents.Create( "sent_rpgrocket" )	
	rocket:SetOwner( self.Owner )
	rocket.LastHolder = self.Owner
	rocket:SetPos( pos )
	
	rocket:SetAngles( self:GetAngles() )
	rocket:Spawn()
	rocket:Activate()
	
	self.Owner:ViewPunch( Angle( math.Rand( -5, -10 ), math.Rand( 0, 0 ), math.Rand( 0, 0 ) ) )	
end

function SWEP:myReload()
	if !IsFirstTimePredicted() then return end
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
		self.NextFire = CurTime() + 3

		timer.Simple( 1.3, function() if self:IsValid() then self:myReload() end end )
		
end
