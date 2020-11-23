if SERVER then AddCSLuaFile("shared.lua") end
SWEP.Author			= "Darkspider"
SWEP.Contact		= ""
SWEP.Purpose		= "Create Props"
SWEP.Instructions	= "Left click to create props. Right click to select props."
SWEP.PrintName = "Prop Creator"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
 
SWEP.Primary.ClipSize		= -1				// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"
local SelectedProp = 1
local SpecialProp = false

GhostProp = CreateClientConVar( "fw_ghost_prop", "1", true, false )

local lastSend = 0
function SWEP:PrimaryAttack()
	if SERVER then return end
	if lastSend > CurTime() then return end
	lastSend = CurTime()+0.1
	RunConsoleCommand( "createprop",SelectedProp, tostring(SpecialProp))
end
if SERVER then 
function SWEP:SecondaryAttack() end 
return end
local MousePos = {ScrW()*0.5,ScrH()*0.5}

function SWEP:SecondaryAttack()
	if !BuildPanel then 
		BuildPanel = vgui.Create("PropMenu") 
		gui.EnableScreenClicker(true)
		gui.SetMousePos(unpack(MousePos))
	else
		BuildPanel:SetVisible(true)
		gui.EnableScreenClicker(true)
		gui.SetMousePos(unpack(MousePos))
	end
end


function SWEP:MakeGhostProp( )
	
	util.PrecacheModel( PropList[SelectedProp].MODEL )
	
	self:ReleaseGhostProp()
	
	--self.GhostProp = ents.Create( "prop_physics" )
	
	--self.GhostProp:SetModel( PropList[SelectedProp].MODEL )
	--self.GhostProp:Spawn()
	
	--self.GhostProp:SetSolid( SOLID_VPHYSICS );
	--self.GhostProp:SetMoveType( MOVETYPE_NONE )
	--self.GhostProp:SetNotSolid( true );
	--self.GhostProp:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	local c = team.GetColor(Me:Team())
	--self.GhostProp:SetColor( c.r,c.g,c.b, 150 )
	
end

function SWEP:ReleaseGhostProp()
	
	if ( IsValid(self.GhostProp) ) then
		--self.GhostProp:Remove()
		--self.GhostProp = nil
	end
	
end

function SWEP:UpdateGhostProp()
	if tonumber(GhostProp:GetInt()) == 0 then self:ReleaseGhostProp() return end
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start + (self.Owner:GetAimVector() * 300)
	tr.filter = self.Owner

	local trace = util.TraceLine( tr )
	if (trace.Hit) then
		if ( !self.GhostProp ) then 
			self:MakeGhostProp( )
		end
			if trace.Entity:IsValid() && trace.Entity:GetClass() == "prop" then
				self.GhostProp:SetAngles( trace.Entity:GetAngles())
			end

			local norm = trace.HitNormal
			local obb = self.GhostProp:OBBMaxs()
			local pos = trace.HitPos + Vector(norm.x*obb.x,norm.y*obb.y,norm.z*obb.z)							
			
			--self.GhostProp:SetPos( pos )
			--self.GhostProp:SetModel( PropList[SelectedProp].MODEL )
	else
		self:ReleaseGhostProp()
	end

end

function SWEP:Think()
	if CLIENT then
		local pmodel = ""
		if SpecialProp then pmodel = UPropList[SelectedProp].MODEL else pmodel = PropList[SelectedProp].MODEL end
--		if !pmodel or pmodel == "" then print("asddas") local pmodel = UPropList[SelectedProp].MODEL end
		if pmodel == "" then return end

		if !self.Ghost or !self.Ghost:IsValid() then
			self.Ghost = ents.CreateClientProp(pmodel)
			self.Ghost:SetOwner(LocalPlayer())
			self.Ghost:SetRenderMode(RENDERMODE_TRANSALPHA)
		elseif self.Ghost:GetModel() != pmodel then
			self.Ghost:SetModel(pmodel)
		end

		if !self.Ghost:IsValid() then return end

		local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = tr.start + (self.Owner:GetAimVector() * 300)
		tr.filter = self.Owner
		local trace = util.TraceLine(tr)

		if trace.Hit then

		local ang = Angle(0,0,0)
		ang.yaw = 0
		ang.roll = 0
		ang.pitch = 0
		local vec = trace.HitPos
		local maxs = self.Ghost:OBBMaxs()
		local mins = self.Ghost:OBBMins()
		local height = maxs.Z - mins.Z
		vec.Z = vec.Z

		ang.yaw = ang.yaw + (self.PYaw or 0)
		ang.pitch = ang.pitch + (self.PPitch or 0)
		ang.roll = ang.roll + (self.PRoll or 0)
		vec.Z = vec.Z + (self.PHeight or 0)

		local norm = trace.HitNormal
		local obb = self.Ghost:OBBMaxs()
		local opos = trace.HitPos + Vector(norm.x*obb.x,norm.y*obb.y,norm.z*obb.z)

		self.Ghost:SetPos(opos)


		self.Ghost:SetAngles(ang)
		if trace.Entity:IsValid() && trace.Entity:GetClass() == "prop" then
			self.Ghost:SetAngles( trace.Entity:GetAngles())
		else
			self.Ghost:SetAngles(ang)
		end
		self.Ghost:SetColor(Color(255, 255, 255, 100))
		else
			if self.Ghost:IsValid() then self.Ghost:SetColor(Color(255, 255, 255, 0)) end
		end

	end
	
end

function SWEP:OnRemove()
	if !CLIENT then return end
	if IsValid(self.Ghost) then
		self.Ghost:Remove()
	end
end

function SWEP:Holster()
	if !CLIENT then return end
	if IsValid(self.Ghost) then
		self.Ghost:Remove()
	end
end

local PANEL = {}

function PANEL:RefreshProps()
	for i,v in pairs(PropList) do
		local p = vgui.Create("SpawnIcon")
		p:SetModel(v.MODEL)
		p:SetToolTip(v.NAME.." - $"..v.PRICE)
		p.OnCursorMoved = function() SelectedProp = i SpecialProp = false end
		self.List:AddItem(p)
	end
	local pen0r = 0
	for i,v in pairs(UPropList) do
		if !myProps[i] then continue end
		local p = vgui.Create("SpawnIcon")
		p:SetModel(v.MODEL)
		p:SetToolTip(v.NAME.." - $"..v.PRICE)
		p.OnCursorMoved = function() SelectedProp = i SpecialProp = true end
		self.List:AddItem(p)
		pen0r = pen0r + 64
	end
	self:SetTall((#PropList*64 + pen0r) + 30)
end

function PANEL:Init()
	self.List = vgui.Create("DPanelList",self)
	self.List:SetAutoSize(true)

	self:RefreshProps()
	--self.ghostProp = vgui.Create("DCheckBox",self)
	--self.ghostProp:SetPos(1,self:GetTall()-29)
	
	--self.ghostProp:SetConVar("fw_ghost_prop")
	local lbl = Label("Ghost Prop?",self)
	lbl:SetPos(1,self:GetTall()-20)
	self:Center()
	
end

function PANEL:Think()
	if !Me:KeyDown(IN_ATTACK2) then 
		self:SetVisible(false)
--		if ValidPanel(PropMenu) then PropMenu:Remove() end
		
		MousePos = {gui.MouseX(),gui.MouseY()}
		gui.EnableScreenClicker(false)
	end
end
vgui.Register("PropMenu",PANEL,"DPanel")