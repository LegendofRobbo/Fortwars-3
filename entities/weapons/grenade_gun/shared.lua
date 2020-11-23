
if CLIENT then
	SWEP.PrintName = "Grenades"
	SWEP.Author	= "Darkspider"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.ViewModelFOV   	= 70
end

SWEP.Base				= "darkland_base"
SWEP.HoldType = "grenade"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFlip 		= false
SWEP.Primary.Sound = nil
SWEP.ViewModel			= "models/weapons/v_grenade.mdl"
SWEP.WorldModel			= "models/weapons/w_grenade.mdl"

local clientFix = 0 --dumbass function calls like 6 times for some reason, this hacky fucker should fix it
function SWEP:PrimaryAttack()

	if self.Owner:GetMana() < NADE_MANA_COST then return end
	if CLIENT && clientFix > RealTime() then return end
	
	if SERVER then
	
		local nade = ents.Create("nade")
		nade:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*20)
		nade.Team = self.Owner:Team()
		nade.LastHolder = self.Owner
		nade:Spawn()
		
		local phys = nade:GetPhysicsObject()
		if phys:IsValid() then
			phys:AddVelocity(self.Owner:GetAimVector()*1500)
		end

		
		self.Owner:TakeMana(NADE_MANA_COST)
	else
		clientFix = RealTime()+0.5
	end
	 self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
	 timer.Simple(0.1,function()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	end)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	self:SetNextPrimaryFire( CurTime() + 0.5 )
end