--require ("mysqloo")

--local db = mysqloo.connect( "123.456.789.0", "drake", "abc123", "database_name", 3306 )
/*
function GM:PlayerAuthed(pl,steamid)

	Query("SELECT Money,Class,Classes,Skills FROM fw_playerdata WHERE SteamID=\'"..steamid.."\'",
	function(res,stat,err)
		--if err != 0 or !IsValid(pl) then return end
		if !IsValid(pl) then print("Invalid Player Authed") end
		if err != 0 then print("Error authing player: ",err) end
		LoadFWProfile(pl,res)
	end)
	
end
*/

local playa = FindMetaTable("Player")

function playa:ClearProps()
for k, v in pairs(ents.FindByClass("prop")) do
	if v.Spawner == self then v:Remove() end
end
end

function playa:HasProfileData()
local exists = false
if ( self:GetPData( "fw2_stats", "" ) != "" ) or ( self:GetPData( "fw2_skills", "" ) != "" ) or ( self:GetPData( "fw2_classes", "" ) != "" ) or ( self:GetPData( "fw2_props", "" ) != "" ) then exists = true end
return exists
end

function playa:DeleteProfile()
	self:RemovePData( "fw2_stats" )
	self:RemovePData( "fw2_classes" )
	self:RemovePData( "fw2_skills" )
	self:RemovePData( "fw2_props" )

	self.Money = DEFAULT_CASH
	self.StartMoney = self.Money
	self.Class = 1
	self:SetNWInt( "DonatorRank", 0 )
	self.MoneyEarned = 0
	self.ProppedMoney = 0
	self.BuildingDamage = 0
	self.Suicides = 0
	self.Headshots = 0
	self.Messages = 0
	self.NumEarned = 0
	self.BallSecs = 0
	self.Classes = {}
	self.Classes[1] = 1
	for i=2,#Classes do self.Classes[i] = 0 end
	self.Skills = {}
	for i=1,#Skills do self.Skills[i] = 0 end

	self:ChatPrint( "Your fortwars profile has been deleted!" )

end

function playa:SaveProfile()
	if !self.fwLoaded then return end
	local sstats = {
--		[1] = self.Money - self.StartMoney,
		[1] = self.Money,
		[2] = self.Class,
		[3] = self:GetNWInt( "DonatorRank", 0 ),
		[4] = self:GetNWInt( "AdminRank", 0 ),
	}
	self:SetPData( "fw2_stats", table.concat(sstats,"|") )
	self:SetPData( "fw2_classes", table.concat(self.Classes,"|") )
	self:SetPData( "fw2_skills", table.concat(self.Skills,"|") )
	self:SetPData( "fw2_props", table.concat(self.OwnedProps,"|") )

	self.StartMoney = self.Money
end

function playa:LoadProfile()
	if self:HasProfileData() then
		-- load existing profile
		local stats = string.Explode("|", self:GetPData( "fw2_stats", "" ) )
		local sqlskills = string.Explode("|", self:GetPData( "fw2_skills", "" ) )
		local sqlclasses = string.Explode("|", self:GetPData( "fw2_classes", "" ) )
		local sqlprops = string.Explode("|", self:GetPData( "fw2_props", "" ) )
		self.Money = tonumber(stats[1])
		self.Class = tonumber(stats[2])
		self:SetNWInt( "DonatorRank", tonumber(stats[3]) )
		self:SetNWInt( "AdminRank", tonumber(stats[4]) )
		self.MoneyEarned = 0
		self.ProppedMoney = 0
		self.BuildingDamage = 0
		self.Suicides = 0
		self.Headshots = 0
		self.Messages = 0
		self.NumEarned = 0
		self.BallSecs = 0
		self.StartMoney = self.Money
		self.Classes = {}
		self.OwnedProps = {}
--		self.Classes[1] = 1
		for i=1,#Classes do
			self.Classes[i] = tonumber(sqlclasses[i]) or 0
		end
		if self.Classes[1] < 1 then self.Classes[1] = 1 end
		self.Skills = {}
		for i=1,#Skills do
			self.Skills[i] = tonumber(sqlskills[i]) or 0
		end
		for i=1,#UPropList do
			self.OwnedProps[i] = tonumber(sqlprops[i]) or 0
		end

	else
		-- player is a newfag or their profile got deleted
		self.Money = DEFAULT_CASH
		self.StartMoney = self.Money
		self.Class = 1
		self:SetNWInt( "DonatorRank", 0 )
		self:SetNWInt( "AdminRank", 0 )
		self.MoneyEarned = 0
		self.ProppedMoney = 0
		self.BuildingDamage = 0
		self.Suicides = 0
		self.Headshots = 0
		self.Messages = 0
		self.NumEarned = 0
		self.BallSecs = 0
		self.Classes = {}
		self.OwnedProps = {}
		self.Classes[1] = 1
		for i=2,#Classes do self.Classes[i] = 0 end
		self.Skills = {}
		for i=1,#Skills do self.Skills[i] = 0 end
		for i=1,#UPropList do self.OwnedProps[i] = 0 end

	end

	-- this shit needs to get called no matter what
		hook.Call("ProfileLoaded", GAMEMODE, self)
		local steamid = self:SteamID()
		timer.Create("saveTimer_"..steamid,10,0,function() if !self:IsValid() then timer.Destroy("saveTimer_"..steamid) return end self:SaveProfile() end)
end

function GM:PlayerAuthed( ply, steamid )
	if !ply:IsValid() then print("Invalid player authed!") return end
	ply:LoadProfile()
end

local function RconHelp()
print( "fw_admin_set_donator <name> <rank number> - set their donator rank ( 0 = user, 1 = premium, 2 = platinum )" )
print( "fw_admin_set_donator_id <steamid> <rank number> - same as above but works on steamids and can be used on offline players" )
print( "fw_admin_set_admin <name> <rank> - set their admin rank ( 0 = user, 1 = mod, 2 = admin, 3 = superadmin )" )
print( "fw_admin_give_money <name> <cash> - give them the specified amount of money, use a negative number to subtract cash" )
print( "fw_admin_ban <name> <length> <reason> - ban this fool, moderators can only ban for up to 1 week" )
print( "fw_admin_kick <name> <reason> - boot this asshole out of the server" )
print( "fw_admin_cleanup <name> - delete all props placed by this person" )
end

concommand.Add( "fw_admin_help", function( ply, cmd, args )
if !ply:IsValid() then RconHelp() return end
ply:ChatPrint( "SUPERADMIN COMMANDS:" )
ply:ChatPrint( "fw_admin_set_donator <name> <rank number> - set their donator rank ( 0 = user, 1 = premium, 2 = platinum )" )
ply:ChatPrint( "fw_admin_set_donator_id <steamid> <rank number> - same as above but works on steamids and can be used on offline players" )
ply:ChatPrint( "fw_admin_set_admin <name> <rank> - set their admin rank ( 0 = user, 1 = mod, 2 = admin, 3 = superadmin )" )
ply:ChatPrint( "fw_admin_give_money <name> <cash> - give them the specified amount of money, use a negative number to subtract cash" )
ply:ChatPrint( "MODERATOR/ADMIN COMMANDS:" )
ply:ChatPrint( "fw_admin_ban <name> <length> <reason> - ban this fool, moderators can only ban for up to 1 week" )
ply:ChatPrint( "fw_admin_kick <name> <reason> - boot this asshole out of the server" )
ply:ChatPrint( "fw_admin_cleanup <name> - delete all props placed by this person" )
end)


-- double jumpan, shamelessly stolen from willox's double jump addon
local function GetMoveVector(mv)
	local ang = mv:GetAngles()

	local max_speed = mv:GetMaxSpeed()

	local forward = math.Clamp(mv:GetForwardSpeed(), -max_speed, max_speed)
	local side = math.Clamp(mv:GetSideSpeed(), -max_speed, max_speed)

	local abs_xy_move = math.abs(forward) + math.abs(side)

	if abs_xy_move == 0 then
		return Vector(0, 0, 0)
	end

	local mul = max_speed / abs_xy_move

	local vec = Vector()

	vec:Add(ang:Forward() * forward)
	vec:Add(ang:Right() * side)

	vec:Mul(mul)

	return vec
end

hook.Add("SetupMove", "Multi Jump", function(ply, mv)
	if not ( ply.Class == 3 and ply.Classes[3] > 1 ) then return end -- if they aren't ninja and dont have the upgrade for it then this hook wont run
	-- Let the engine handle movement from the ground
	if ply:OnGround() then
		ply:SetNWInt("jumplevel", 0)

		return
	end	

	-- Don't do anything if not jumping
	if not mv:KeyPressed(IN_JUMP) then
		return
	end

--	ply:SetJumpLevel(ply:GetJumpLevel() + 1)
	ply:SetNWInt("jumplevel", ply:GetNWInt("jumplevel") + 1 )

	if ply:GetNWInt("jumplevel") > 1 then
		return
	end

	local vel = GetMoveVector(mv)

	vel.z = ply:GetJumpPower() * 0.7

	mv:SetVelocity(vel)

	ply:DoCustomAnimEvent(PLAYERANIMEVENT_JUMP , -1)
end)





/*
function LoadFWProfile(pl,tbl)

	print("FW PROFILE LOADING!")
	tbl = tbl[1]
	if tbl == nil then NewPlayer(pl) return end
	--pl.Money = tonumber(tbl[1]) or DEFAULT_CASH
	pl.Money = tonumber(tbl["Money"]) or DEFAULT_CASH
	pl.MoneyEarned = 0
	pl.ProppedMoney = 0
	pl.BuildingDamage = 0
	pl.Suicides = 0
	pl.Headshots = 0
	pl.Messages = 0
	pl.NumEarned = 0
	pl.BallSecs = 0
	pl.StartMoney = pl.Money
	--pl.Class = tonumber(tbl[2]) or 1
	pl.Class = tonumber(tbl["Class"]) or 1
	--print("Profile loading!")
	--local classload = tbl[3] or ""
	local classload = tbl["Classes"] or ""
	classload = string.Explode("|",classload)
	pl.Classes = {}
	pl.Classes[1] = 1 --They get human no matter what
	for i=2,#Classes do
		pl.Classes[i] = tonumber(classload[i]) or 0
	end
	
	--local skillload = tbl[4] or ""
	local skillload = tbl["Skills"] or ""
	skillload = string.Explode("|",skillload)
	pl.Skills = {}
	for i=1,#Skills do
		pl.Skills[i] = tonumber(skillload[i]) or 0
	end
	
	pl.ClassKills = {}
	pl.LifeClassKills = {}
	pl.LastPlayerKillTime = {}
	pl:SetNWInt("NeoSniperShots",0)
	
	hook.Call("ProfileLoaded",GAMEMODE,pl)
	local steamid = pl:SteamID()
	timer.Create("saveTimer_"..steamid,10,0,function() if !IsValid(pl) then timer.Destroy("saveTimer_"..steamid) return end SaveData(pl) end)
end

function NewPlayer(pl)
	pl.Money = DEFAULT_CASH
	pl.StartMoney = pl.Money
	pl.Class = 1
	pl.MoneyEarned = 0
	pl.ProppedMoney = 0
	pl.BuildingDamage = 0
	pl.Suicides = 0
	pl.Headshots = 0
	pl.Messages = 0
	pl.NumEarned = 0
	pl.BallSecs = 0
	pl.Classes = {}
	pl.Classes[1] = 1
	for i=2,#Classes do pl.Classes[i] = 0 end
	pl.Skills = {}
	for i=1,#Skills do pl.Skills[i] = 0 end
	Query("INSERT INTO fw_playerdata (SteamID,Money,Classes,Skills) VALUES (\'"..pl:SteamID().."\',"..DEFAULT_CASH..",\'"..table.concat(pl.Classes,"|").."\',\'"..table.concat(pl.Skills,"|").."\')",function(df,sdf,err) print("New Player") end)
	hook.Call("ProfileLoaded",GAMEMODE,pl)
	local steamid = pl:SteamID()
	timer.Create("saveTimer_"..steamid,10,0,function() if !IsValid(pl) then timer.Destroy("saveTimer_"..steamid) return end SaveData(pl) end)
end


function SaveData(pl)
	if !pl.fwLoaded then return end --prevent any overwriting of profiles and angry emails
	local money = pl.Money-pl.StartMoney;
	local class = pl.Class
	local classes = table.concat(pl.Classes,"|")
	local skills = table.concat(pl.Skills,"|")
	Query("UPDATE fw_playerdata SET Money=Money+"..money..", Class="..class..", Classes=\""..classes.."\", Skills=\""..skills.."\" WHERE SteamID=\""..pl:SteamID().."\"")
	pl.StartMoney = pl.Money
end
*/

local meta = FindMetaTable("Player")
function meta:AddMoney(int)
	self.MoneyEarned = self.MoneyEarned + int
	self.Money = self.Money + int
	SendMoney(self)
end

function meta:SetMoney(int)
	self.Money = int
	SendMoney(self)
end

function meta:GetMoney()
	return self.Money or 0
end
function meta:TakeMoney(int)
	self.MoneyEarned = self.MoneyEarned - int
	self.Money = self.Money - int
	SendMoney(self)
end
function meta:Gib( norm )

	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetNormal( norm )
	util.Effect( "gib_player", effectdata )

end
function meta:GetAssists()
	return ply:GetNWInt("Assists")
end

--energy stuff

function meta:SetEnergy(int)
	self:SetNWInt( "fw_mana", int )
	/*
	self.Energy = int
	umsg.Start("setEnergy",self)
		umsg.Char(self.Energy)
	umsg.End()
	*/
end

function meta:GetMana()
	return self:GetNWInt( "fw_mana" )
end

function meta:TakeMana(int)
	self:SetNWInt( "fw_mana", math.Clamp(self:GetMana() - int, 0, 10000) )
	/*
	self.Energy = self.Energy - int
	umsg.Start("setEnergy",self)
		umsg.Char(self.Energy)
	umsg.End()
	*/
end

timer.Create("energyTimer",1,0,function() 
	for i,v in pairs(player.GetAll()) do 
		v:SetEnergy( math.Clamp(v:GetMana() + (v.RegenRate or BASE_ENERGY_REGEN),0,v.MaxEnergy) )
	end 
end)