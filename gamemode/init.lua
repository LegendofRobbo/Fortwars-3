AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("spawnicon.lua")
AddCSLuaFile("killfeed.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile( "cl_deathnotice.lua" )
AddCSLuaFile( "cl_targetid.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )

AddCSLuaFile("scoreboard/scoreboard.lua" )

include("shared.lua")
include("player.lua")
include("commands.lua")
include("admincommands.lua")
include("sv_achhooks.lua")
include("killfeed.lua")


AddCSLuaFile("cl_endgame.lua")

util.AddNetworkString( "SendClasses" )
util.AddNetworkString( "SendProps" )

resource.AddFile("materials/darkland/fortwars/f1bg.vtf")
resource.AddFile("materials/darkland/fortwars/f1bg.vmt")


--resource.AddFile("materials/darkland/pumpkin2.vtf")
--resource.AddFile("materials/darkland/pumpkin2.vmt")

resource.AddFile("materials/darkland/scope/scope.vtf")
resource.AddFile("materials/darkland/scope/scope.vmt")
resource.AddFile("sound/darkland/fortwars/bomberlol.mp3")
resource.AddFile("sound/darkland/freeze_cam.wav")
resource.AddFile("sound/darkland/rocket_launcher.mp3")

resource.AddWorkshop("624906772")


if IS_CHRISTMAS then
	resource.AddFile("sound/"..CHRISTMAS_SONG)
else
	resource.AddFile("sound/"..WIN_SONG)
end


DEATHMATCH = false --Start in build
roundEnd = BUILD_TIME
roundStart = 0;

g_Ball = NULL
holdingTeam = 0
ballHolder = NULL;

ENDGAME = false;

TeamInfo = {}
TeamInfo[1] = {
Spawn = "info_player_blue",
Present = false,
BoxCount = 0,
HoldTime = DEFAULT_BALL_TIME
}
TeamInfo[2] = {
Spawn = "info_player_red",
Present = false,
BoxCount = 0,
HoldTime = DEFAULT_BALL_TIME
}
TeamInfo[3] = {
Spawn = "info_player_yellow",
Present = false,
BoxCount = 0,
HoldTime = DEFAULT_BALL_TIME
}
TeamInfo[4] = {
Spawn = "info_player_green",
Present = false,
BoxCount = 0,
HoldTime = DEFAULT_BALL_TIME
}


-- shit fix for getdarklandvar system
local playa = FindMetaTable("Player")

function playa:GetDarklandVar( var, val )
	return 1
end

function playa:SetDarklandVar( var, val )
	return
end

--DONE GAMEMODE LOAD
function SecondTimer()
	if CurTime() >= roundEnd then
		
		if ENDGAME then
			ChangeMap()
			return
		end
		ChangeRound()
	end
	
	if IsValid(ballHolder) && !ENDGAME then
		TeamInfo[ballHolder:Team()].HoldTime = TeamInfo[ballHolder:Team()].HoldTime - 1;
		ballHolder.BallSecs = ballHolder.BallSecs + 1
		ballHolder:AddMoney(HOLD_REWARD)
--		ballHolder:SetDarklandVar("balltime",ballHolder:GetDarklandVar("balltime",0)+1)
		
		hook.Call("FW_BallTimeIncrease",GAMEMODE,ballHolder)
		
		if TeamInfo[ballHolder:Team()].HoldTime <= 0 then 
			GAMEMODE:GameOver(ballHolder:Team())
		end
	end
end
timer.Create("herpdederpitydoo", 1, 0, SecondTimer)


LastRoundMaps = {}
LastRoundMaps[1] = "fw_concrete"
LastRoundMaps[2] = "fw_earthlanding_b3"
LastRoundMaps[3] = "fw_excellence"
LastRoundMaps[4] = "fw_pipeline_v2"
LastRoundMaps[5] = "fw_pool_v2"
function CheckMapCompatibility() --change level if incompatible
	local exists = ents.FindByClass("balldrop")[1] != nil
	if !exists then
		game.ConsoleCommand("changelevel "..mapList[math.random(1,#mapList)][1].."\n")
	end
end

function GM:InitPostEntity()
	CheckMapCompatibility()
	--Now count the number of valid teams
	local num = 0
	for i,v in pairs(TeamInfo) do
		local tbl = ents.FindByClass(v.Spawn)
		if tbl[1] then 
			num=num+1 
			TeamInfo[i].Present = true 
			--create markers
			for ii,v in pairs(tbl) do
				timer.Simple(ii*0.01,function()
					local tr = util.TraceLine({start = v:GetPos()+Vector(0,0,46), endpos = v:GetPos()+Vector(0,0,-1000), filter = v})
					if tr.Hit then v:SetPos(tr.HitPos+Vector(0,0,10)) end
					local ent = ents.Create("spawn_marker")
					local ang = v:GetAngles()
					ent:SetPos( v:GetPos() )
					ent:SetAngles( Angle( 0, ang.y, 0 ) )
					ent.color = team.GetColor( i )
					ent:Spawn()
					ent:Activate()
					v.blocker = ent
				end)
			end
		end
		TeamInfo[i].Spawns = TeamInfo[i].Spawns or tbl --Hold a table of all the spawns so we don't have to find them everytime we spawn
	end
	if num < 2 then game.ConsoleCommand("changelevel "..mapList[math.random(1,#mapList)][1].."\n") end -- Only one or less teams have spawns, the map maker failed so change it
	--print(sepcount, "INDEX1")
	--local t = string.Explode("|",file.Read("lastfwmaps.txt") or "")
	local t = string.Explode("|", "fw_concrete|fw_earthlanding_b3|fw_excellence|fw_pipeline_v2|fw_pool_v2" or "")
	--for i,v in pairs(t) do
	--	LastRoundMaps[tonumber(v)] = true
	--end
	
	
	
	--[[local t = file.Find("../maps/fw_*.bsp")
	local goodMaps = {}
	local notDone = {}
	for i,v in pairs(t) do
		for q,w in pairs(mapList) do
			if string.find(v,w[1]) then
				
				table.insert(goodMaps,w)
			end
		end
	end
	
	mapList = goodMaps	
	]]
	
	for i,v in pairs(mapList) do
		mapList[i].votes = 0
	end
	hook.Call("MapEntitiesMade",GAMEMODE)
end

function FixSpawnTable()
local num = 0
	for i,v in pairs(TeamInfo) do
		local tbl = ents.FindByClass(v.Spawn)
		if tbl[1] then 
			num=num+1 
			TeamInfo[i].Present = true 
			--create markers
			for ii,v in pairs(tbl) do
				timer.Simple(ii*0.01,function()
					local tr = util.TraceLine({start = v:GetPos()+Vector(0,0,46), endpos = v:GetPos()+Vector(0,0,-1000), filter = v})
					if tr.Hit then v:SetPos(tr.HitPos+Vector(0,0,10)) end
					local ent = ents.Create("spawn_marker")
					local ang = v:GetAngles()
					ent:SetPos( v:GetPos() )
					ent:SetAngles( Angle( 0, ang.y, 0 ) )
					ent.color = team.GetColor( i )
					ent:Spawn()
					ent:Activate()
					v.blocker = ent
				end)
			end
		end
		TeamInfo[i].Spawns = TeamInfo[i].Spawns or tbl
	end
end


function GM:ShowHelp( pl )
	pl:ConCommand("fw_help")
end

function GM:ProfileLoaded( pl )
	local t = {}
	for i,v in pairs(TeamInfo) do 
		if v.Present then 
			table.insert(t,i) 
		end 
	end
	
	
	table.sort(t,function(a,b) return team.NumPlayers(a) < team.NumPlayers(b) end)
	if t[1] then pl:SetTeam(t[1]) else pl:SetTeam(1) end
	local c = team.GetColor(t[1]) or Color(255,255,255)
	pl:SetColor(c)
	
	
	pl.fwLoaded = true
	pl:UnSpectate()
	pl:Spawn()
	SendClasses(pl)
	SendSkills(pl)
	SendClass(pl)
	SendMoney(pl)
	GAMEMODE:UpdateAttributes(pl)
	
end



function GM:PlayerInitialSpawn( pl )
	pl:LoadProfile()
	pl:SetCanZoom( false )
	pl.LastPlayerKillTime = {}
	pl.Suicides = 0
end

concommand.Add("DoneLoadingFW",function(pl)
	SendInitialize( pl )
	SendRound(pl)
end)

function GM:PlayerSelectSpawn( pl )
	if pl.SpawnPoint then return pl.SpawnPoint end
		local tbl = TeamInfo[pl:Team()]
		if !tbl then return nil end --They have not loaded, spawn them in noclip underground
		for i=1,10 do
			local v = tbl.Spawns[math.random(1,#tbl.Spawns)]
			local origin = v:GetPos()
			local ents_found = ents.FindInBox(origin-Vector(20,20,5),origin+Vector(20,20,80))
			if !ents_found[5] then if v.blocker then v.blocker:SetNotSolid(true) end return v end
		end
	
	return tbl.Spawns[1]
end

function GM:PlayerSpawn( pl )

	if !pl.fwLoaded then pl:Spectate( 4 ) return end
	pl:UnSpectate()
	
	pl:SetModel(Classes[pl.Class].MODEL)
	pl:SetNWBool( "tagshotted", false )
--	pl:SetModel("nigger")
	if DEATHMATCH then
		pl:Give("weapon_physcannon")
		pl:Give(Classes[pl.Class].WEAPON)
	else
		pl:Give("fw_spawngun")
		pl:Give("prop_creator")
		pl:Give("prop_remover")
		pl:Give("weapon_physgun")
	end
	if pl.SpawnAng then pl:SetEyeAngles(pl.SpawnAng) end
	
	timer.Simple( 0.5, function() GAMEMODE:ResetSpeed( pl ) end)
	self:UpdateAttributes(pl)
end

function GM:ResetSpeed( ply )
	ply:SetWalkSpeed(Classes[ply.Class].SPEED+(ply.Skills[1]*20))
	ply:SetRunSpeed(Classes[ply.Class].SPEED+(ply.Skills[1]*20))
end

function GM:UpdateAttributes(ply)
	self:ResetSpeed( ply )
	ply:SetHealth(Classes[ply.Class].HEALTH+(ply.Skills[2]*10))
	ply:SetEnergy(100+(ply.Skills[2]*5))
	ply.MaxEnergy = 100+(ply.Skills[3]*5)
	ply.RegenRate = BASE_ENERGY_REGEN+ply.Skills[4]
	if Classes[ply.Class].SPAWNFUNC then Classes[ply.Class].SPAWNFUNC(ply) end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	--More damage if we're shot in the head
	 if ( hitgroup == HITGROUP_HEAD ) then
	 
		dmginfo:ScaleDamage( 2 )
		if dmginfo:GetDamage() > ply:Health() then
			dmginfo:GetAttacker().Headshots = dmginfo:GetAttacker().Headshots + 1
		end
	 end
	 
	-- Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM || 
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_GEAR ) then
	 
		dmginfo:ScaleDamage( 0.25 )
	 
	 end

end

function GM:PlayerShouldTakeDamage(ply,attacker)
	if attacker:IsPlayer() then return ply:Team() != attacker:Team() end
	
	
	local phyAttacker = attacker.LastHolder or NULL
	
	
	if phyAttacker:IsPlayer() then return phyAttacker:Team() != ply:Team() || phyAttacker == ply end
	
	
	return DEATHMATCH
end

function GM:PlayerHurt(ply,attacker)
	if ply:Team() != attacker:GetTeam() && ply:Health() > 0 then
		if attacker:IsPlayer() then
			ply.lastAttacker = attacker;
			ply.lastAttack = CurTime() + 5
		elseif IsValid(attacker.LastHolder) && attacker.LastHolder:IsPlayer() then
			ply.lastAttacker = attacker.LastHolder
			ply.lastAttack = CurTime() + 5
		end
	end
end

function GM:GetFallDamage(ply,speed)
	speed = speed - 580
	return speed * (100/444)
end
function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CreateRagdoll()
	
	ply:AddDeaths( 1 )
	
end
local killRewards = {}
killRewards[0] = KILL_MONEY
killRewards[1] = KILL_MONEY * 2
killRewards[2] = KILL_MONEY * 3
function GM:PlayerDeath(victim,weapon,killer)
	if ( victim.Class == 1 and victim.Classes[1] > 1 ) then
		victim.NextSpawnTime = CurTime() + 1.5
	else
		victim.NextSpawnTime = CurTime() + 3
	end
	victim:SetDTBool(0,false)
	if (killer == victim) then
		victim.Suicides = victim.Suicides + 1
		umsg.Start( "PlayerKilledSelf" )
			umsg.Entity( victim )
		umsg.End()
		return 
	end


	
	if killer == g_Ball then killer = g_Ball.Punter end

	
	local assister = NULL
	if victim.lastAttacker != killer then
		if IsValid(victim.lastAttacker) && victim.lastAttacker:IsPlayer() && victim.lastAttack > CurTime() then
			assister = killer
			killer = victim.lastAttacker
		end
	end
	if IsValid(assister) and assister:IsPlayer() then
		killer:AddFrags(1)
		assister:SetNWInt("Assists",assister:GetNWInt("Assists")+1)
		
		
		killer:AddMoney(killRewards[killer:GetStatus()]/3)
		assister:AddMoney(killRewards[assister:GetStatus()]/3)
		
		
		timer.Simple(1.5,function()self:FreezeCam(victim,killer)end)
		
		--victim has 10 seconds to kill killer to get the achievement
		killer.LastPlayerKillTime[victim] = CurTime() + 10
		
		--check if victim killed killer within the last 10 seconds
		local val = victim.LastPlayerKillTime[killer] or 0
		
		if val - CurTime() > 0 then
--			GiveAchievement(killer,"Eye For An Eye")
		end
		
		local class = Classes[killer.Class].NAME
		
		table.Empty(victim.LifeClassKills) --clear this when you die
		killer.LifeClassKills[class] = killer.LifeClassKills[class] or 0
		killer.LifeClassKills[class] = killer.LifeClassKills[class] + 1
		
		killer.ClassKills[class] = killer.ClassKills[class] or 0
		killer.ClassKills[class] = killer.ClassKills[class] + 1
		
		
		hook.Call("OnAssist",GAMEMODE,assister,victim)
		hook.Call("OnKillPlayer",GAMEMODE,killer,victim)
		umsg.Start( "PlayerKilledByPlayers" )
			umsg.Entity( victim )
			local str = killer:GetActiveWeapon()
			if str:IsValid() then str = str:GetClass() else str = "" end
			umsg.String( str  )
			umsg.Entity( killer )
			umsg.Entity( assister )
		umsg.End()
	return end


	if ( killer:IsPlayer() ) then
	
		--victim has 10 seconds to kill victim.lastAttacker to get the achievement
		killer.LastPlayerKillTime[victim] = CurTime() + 10
		
		--check if victim killed victim.lastAttacker within the last 10 seconds
		local val = victim.LastPlayerKillTime[killer] or 0
		
		if val - CurTime() > 0 then
--			GiveAchievement(killer,"Eye For An Eye")
		end
		
		local class = Classes[killer.Class].NAME
		
		
		victim.LifeClassKills = {} --clear this when you die
		
		
		killer.LifeClassKills = killer.LifeClassKills or {}
		killer.LifeClassKills[class] = killer.LifeClassKills[class] or 0
		killer.LifeClassKills[class] = killer.LifeClassKills[class] + 1
		
		
		killer.ClassKills = killer.ClassKills or {}
		killer.ClassKills[class] = killer.ClassKills[class] or 0
		killer.ClassKills[class] = killer.ClassKills[class] + 1
		
		killer:AddMoney(killRewards[killer:GetStatus()])
		killer:AddFrags(1)
		timer.Simple(1.5,function()self:FreezeCam(victim,killer)end)
		hook.Call("OnKillPlayer",GAMEMODE,killer,victim)
		umsg.Start( "PlayerKilledByPlayer" )
		
			umsg.Entity( victim )
			local str = killer:GetActiveWeapon()
			if str:IsValid() then str = str:GetClass() else str = "" end
			umsg.String( str )
			umsg.Entity( killer )
		
		umsg.End()
		
		
	return end
	
	umsg.Start( "PlayerKilled" )
	
		umsg.Entity( victim )
		umsg.String( weapon:GetClass() )
		umsg.String( killer:GetClass() )

	umsg.End()
	
	
end

function GM:FreezeCam( pl, attacker )

	if( IsValid( pl ) and IsValid( attacker ) and !pl:Alive() ) then
		pl:Spectate( OBS_MODE_FREEZECAM );
		pl:SpectateEntity( attacker );
		umsg.Start("freezeCamSound",pl)
		umsg.End()
	end
	
end

function GM:OnPhysgunFreeze(wep,phys,ent,pl)
	return false
end
function GM:OnPhysgunReload(wep,pl)
	return false
end
function GM:PhysgunDrop(pl,ent)
	if ent:IsPlayer() then return end
	ent:GetPhysicsObject():EnableMotion(false)
	local col = team.GetColor(ent.Team)
	ent:SetColor(Color(col.r,col.g,col.b,255))
end

function GM:PhysgunPickup(pl,ent)
	if ent:IsPlayer() then return pl:IsAdmin() end
	if ent:GetClass() != "prop" then return end
	if ent.Spawner == pl then ent:SetColor(Color(255,255,255)) return true end
	if pl:IsAdmin() and IsValid(ent.Spawner) then pl:PrintMessage(4,"This prop belongs to "..ent.Spawner:Name()) ent:SetColor(Color(255,255,255)) return true end
	if !IsValid(ent.Spawner) then 
		pl:PrintMessage(4,"The owner of this prop is gone, it is now yours") 
		ent.Spawner = pl
		ent.Team = pl:Team()
		ent:SetColor(Color(255,255,255))
		return true 
	end
	pl:PrintMessage(4,"This prop belongs to "..ent.Spawner:Name())
	return false
end

function GM:PlayerNoClip(pl)
	if !DEATHMATCH then
		if pl:IsAdmin() then return true end
		if pl:IsPlatinum() then 
			--[[if !pl:GetDTBool(0) then
				pl:SetDTBool(0,true)
				return
			else
				pl.LeftNoClip = true
				pl:SetDTBool(0,false)
				return
			end			]]
				
			if !pl.FlyN then
					pl:SetMoveType(4)
					pl.FlyN = true
			else
					pl:SetMoveType(2)
					pl.FlyN = false
			end
		end
	end
	return false
end


function GM:RoundChanged()
	VoteSkippers = {}
end
function GM:GameOver(winner)
	ENDGAME = winner;
	roundEnd = CurTime() + END_GAME_TIME
	
	
	umsg.Start("gameOver")
		umsg.Char(winner);
	umsg.End()
	
	SendTime()
	--SendMaps()
	if IsValid(g_Ball) then
		DropEntityIfHeld(g_Ball)
	end
	for i,v in pairs(team.GetPlayers(winner)) do v:AddMoney(WIN_MONEY) end
	for i,v in pairs(player.GetAll()) do v:Lock() v:SaveProfile() end
	
	SendEndGameVars()
	return true
end

function GM:PlayerCanPickupWeapon(ply,wep)
	
	if (
	wep:GetClass() == "weapon_physgun" ||
	wep:GetClass() == "fw_spawngun" ||
	wep:GetClass() == "prop_creator" ||
	wep:GetClass() == "prop_remover"
	) && DEATHMATCH then 
	
		wep:Remove() 
		return false
	end
	if wep:GetClass() == "weapon_physcannon" then return true end
	if DEATHMATCH && (wep:GetClass() != Classes[ply.Class].WEAPON) then wep:Remove() return false end
	return true
end
	
	

function GM:GravGunCanPickUp(pl, ent) 
	return ent == g_Ball
end

function GM:GravGunOnPickedUp(ply, ent)
	if ent == g_Ball then 
		ply.GGFEnt = ent
		holdingTeam = ply:Team() 
		ballHolder = ply
		SendNewHolder()
		ent.LastHolder = ply
		return true 
	end
	return false
end

function GM:GravGunOnDropped(ply, ent)
	if (IsValid(ply.GGFEnt)) then
		ply.GGFEnt = nil
	end
	if ent == g_Ball then 
		ballHolder = nil
		holdingTeam = 0 
		SendNewHolder() 
	end
end
function GM:GravGunPunt(ply,ent)
	if ent != g_Ball && ent:GetClass() != "sent_rpgrocket" && ent:GetClass() != "nade" then return false end
	ent.Punter = ply
	timer.Simple(1,function() if IsValid(ent) then ent.Punter = nil end end)
	return true
end
	
function ChangeMap()

	local newmap = ""
		if table.HasValue( mapList, game.GetMap() ) then
			for i, map in ipairs( mapList ) do
				if map == game.GetMap() then
					newmap = maps[ math.fmod( i + 1, #mapList ) ]
				end
			end
		else
			newmap = mapList[ math.random( 1, #mapList ) ]
		end

--	table.sort(mapList,function(a,b) return a.votes > b.votes end) -- voting is fucked at the moment
	game.ConsoleCommand("changelevel "..tostring(newmap[1]).."\n")
end

function BoxRemoved(ent,ply)
	
	TeamInfo[ent.Team].BoxCount=TeamInfo[ent.Team].BoxCount-1
	local rf = RecipientFilter()
	for i,v in pairs(team.GetPlayers(ent.Team)) do rf:AddPlayer(v) end
	umsg.Start("boxCount",rf)
		umsg.Char(TeamInfo[ent.Team].BoxCount)
	umsg.End()
	if IsValid(ply) && !ENDGAME then
		ply:AddMoney(ent.TBL.PRICE)
	end
end

function RaiseBoxCount(tm)
	TeamInfo[tm].BoxCount=TeamInfo[tm].BoxCount+1
	local rf = RecipientFilter()
	for i,v in pairs(team.GetPlayers(tm)) do rf:AddPlayer(v) end
	umsg.Start("boxCount",rf)
		umsg.Char(TeamInfo[tm].BoxCount)
	umsg.End()

end

function GetBoxCount(tm)
	return TeamInfo[tm].BoxCount
end

function SendNewHolder(pl)
	umsg.Start("newHolder",pl)
		umsg.Char(holdingTeam)
	umsg.End()
end
local voteSkipping = false
function ChangeRound()
	DEATHMATCH = !DEATHMATCH
	voteSkipping = false
	roundStart = CurTime()
	for i,v in pairs(ents.FindByClass("func_wall_toggle")) do v:Fire("toggle","",0) end
	local tbl = ents.FindByClass("spawn_marker")
	if DEATHMATCH then 
		roundEnd = CurTime() + FIGHT_TIME
		for i,v in pairs(tbl) do v:Disable() end
		
		g_Ball = ents.Create("ball")
		local spawns = ents.FindByClass("balldrop")
		g_Ball:SetPos(spawns[math.random(1,#spawns)]:GetPos())
		g_Ball:Spawn()
	else 
		roundEnd = CurTime()+BUILD_TIME
		for i,v in pairs(tbl) do v:Enable() end
		if IsValid(g_Ball) then
			g_Ball:Remove()
		end
		ballHolder = nil
		holdingTeam = 0 
		SendNewHolder() 
	end
	for i,v in ipairs(SpawnBoxes) do
		if IsValid(v) then
			v:Remove()
		end
	end

	VoteSkippers = {}
	SendTime()
	SendRound()
	hook.Call("RoundChanged",GAMEMODE)
	for i,v in pairs(player.GetAll()) do 
		v:StripWeapons()
		v:Spawn()
		v:SetDTBool(0,false)
		local c = team.GetColor(v:Team())
		v:SetColor(c)
		v:SetPlayerColor( Vector(c.r / 255, c.g / 255, c.b /255) )
		if IsValid(v:GetViewModel()) then
			v:GetViewModel():SetColor(Color(255,255,255))
		end
		timer.Simple( 0.5, function() GAMEMODE:ResetSpeed( v ) end)
		
	end
	
end
function SendRound(pl)
	umsg.Start("getRound",pl)
		umsg.Bool(DEATHMATCH)
	umsg.End()
end
function SendInitialize( pl )
	local t = {}
	for i,v in pairs(TeamInfo) do
		if v.Present then
			table.insert(t,i)
		end
	end
		
	umsg.Start("initFW",pl)
		umsg.Long(roundEnd)
		for i,v in pairs(t) do
			umsg.Char(v)
		end
	umsg.End()
	
	umsg.Start("newHolder",pl)
		umsg.Char(holdingTeam)
	umsg.End()

	for i,v in pairs(TeamInfo) do
		if v.Present then
			umsg.Start("getHoldTimes",pl)
				umsg.String(i.."|"..v.HoldTime)
			umsg.End()
		end
	end
	
	hook.Call("TeamsSent",GAMEMODE,pl)
end
function SendTime( pl )
	umsg.Start("setRoundTime",pl)
		umsg.Long(roundEnd)
	umsg.End()
end

function SendEndGameVars()


	for i,v in pairs(EndGameStats) do
		local pl,amt = v.Grabber()
		umsg.Start("getEndVar")
		umsg.Char(i)
		if IsValid(pl) then
			umsg.Char(pl:EntIndex())
		else
			umsg.Char(0)
		end
		umsg.String(amt or "")
		umsg.End()
		
	end


end

function SendProps( pl )
	/*
	local trues = {}
	for i,v in pairs(pl.Classes) do
		if v > 0 then
			trues[i] = v
--			table.insert(trues,i)
		end
	end
	umsg.Start("getClasses",pl)
		umsg.String(table.concat(trues,"|"))
	umsg.End()
	*/
	net.Start("SendProps")
	net.WriteTable( pl.OwnedProps )
	net.Send( pl )
end


function SendClasses( pl )

	SendProps( pl ) -- just gonna shoehorn it in here cos im a lazy cunt

	net.Start("SendClasses")
	net.WriteTable( pl.Classes )
	net.Send( pl )
end

function SendClass(pl)
	umsg.Start("currentClass",pl)
		umsg.Char(pl.Class)
	umsg.End()
end
function SendSkill( pl, skill )
	umsg.Start("getSkill",pl)
		umsg.Char(skill)
		umsg.Char(pl.Skills[skill])
	umsg.End()
end
function SendSkills( pl )
	local str = ""
	for i,v in pairs( pl.Skills ) do
		str = str..v
	end
	umsg.Start("getSkills",pl)
		umsg.String(str)
	umsg.End()
end
function SendMoney( pl )
	umsg.Start("getMoney",pl)
		umsg.Long(pl.Money)
	umsg.End()
end
local maps = {}
function SendMaps()

	while (#maps<math.min(5,table.getn(mapList))) do
		local map = math.random(1,#mapList)
		if !LastRoundMaps[map] && !table.HasValue(maps,map) then
			table.insert(maps,map)
		end
	end
	file.Write("lastfwmaps.txt",table.concat(maps,"|"))
	umsg.Start("getMaps")
	for i=1,5 do
		umsg.Char(maps[i])
	end
	umsg.End()

end

local ChatCommands = {}
function AddChatCommand(cmd,callback)
	ChatCommands[cmd] = callback
end

function ChatCommandFunction(ply,text,public)
	if string.find(text,"/") == 1 then
		--print(sepcount, "INDEX2")
		local tbl = string.Explode(" ",text)
		tbl[1] = string.sub(tbl[1],2)
		--set and remove the crap before calling and passing
		local i = tbl[1]
		table.remove(tbl,1)
		if !ChatCommands[i] then ply:ChatPrint("Invalid Command") return "" end

		return ChatCommands[i](ply,tbl) or "";
	end
	if ply.Messages then
		ply.Messages = ply.Messages + 1
	end
end
hook.Add("PlayerSay","ChatCommands",ChatCommandFunction)

VoteSkippers = {}
local VoteSkips = 0
local firstSkipper = false
function VoteSkip(ply,tbl)
	if !firstSkipper then ply.firstSkipper = true firstSkipper = true end
	

	if DEATHMATCH then 
		ply:ChatPrint("You can only voteskip in build mode!") 
		return 
	end
	if voteSkipping then return end
	if (roundStart + VOTE_DELAY > CurTime()) and !DEBUG_MODE then 
		ply:ChatPrint("You must wait "..string.ToMinutesSeconds(roundStart + VOTE_DELAY - CurTime()).." to voteskip") 
		return 
	end
	if VoteSkippers[ply:SteamID()] then 
		ply:ChatPrint("You have already voteskipped this round!") 
		return 
	end
	VoteSkippers[ply:SteamID()] = true
	
	if ply:IsPlatinum() then
		VoteSkips = VoteSkips + 4
	elseif ply:IsPremium() then
		VoteSkips = VoteSkips + 2
	else
		VoteSkips = VoteSkips + 1
	end
	
	local needed = math.ceil(#player.GetAll()*VOTE_THRESH)
	
	if VoteSkips >= needed then
		roundEnd = CurTime() + VOTE_WARNING
		--ChangeRound() 
		umsg.Start("voteskipPassed")
		umsg.End()
		voteSkipping = true
		return 
	end
	
	for i,v in pairs(player.GetAll()) do 
		v:ChatPrint("There are now "..VoteSkips.." voteskips. ("..needed.." needed)") 
	end
end
	

AddChatCommand("voteskip",VoteSkip)

function ResetSpawn(ply)
	ply.SpawnPoint = nil
	ply.SpawnAng = nil
	ply:ChatPrint("You have reset your spawn")
end
AddChatCommand("resetspawn",ResetSpawn)

function KillSelf(ply)
	ply:Kill()
	ply:ChatPrint("You have respawned")
end
AddChatCommand("respawn",KillSelf)

function GiveMoney(pl,tbl)
	if !tbl then 
		pl:ChatPrint("Usage: /givemoney Amount Name") 
		return 
	end
	local amt = tonumber(tbl[1])
	if !amt or amt < 25 then pl:ChatPrint("Enter a number value of at least 25!") return end
	if amt > pl.Money then pl:ChatPrint("You don't have that much money!") return end
	table.remove(tbl,1)
	local name = string.lower(table.concat(tbl," "))
	local recvr
	local num = 0
	for i,v in pairs(player.GetAll()) do 
		if string.find(string.lower(v:Name()),name,1,true) then
			recvr = v
			num = num + 1
		end
	end
	if num > 1 then pl:ChatPrint("Too many names contain "..name) return end
	if !recvr then pl:ChatPrint("Player not found") return end
	if recvr == pl then pl:ChatPrint("You can't give yourself money") return end
	
	pl:TakeMoney(amt)
	recvr:AddMoney(amt)
	ply:SaveProfile()
	recvr:SaveProfile()
	recvr:ChatPrint(pl:Name().." has given you $"..amt)
	pl:ChatPrint("You have given "..recvr:Name().." $"..amt)
	
end
AddChatCommand("givemoney",GiveMoney)

local meta = FindMetaTable("Entity")
function meta:GetTeam()
	if self.tbl then return self.Team end
	if self:IsPlayer() then return self:Team() end
end
function meta:TakeDmg(amt,atk,inf)
	self:TakeDamage(amt,atk,inf)
	
	return self:IsPlayer() && !self:Alive()
end


local function GGFix_Death(ply)
	local ent = ply.GGFEnt
	if (IsValid(ent)) then
		DropEntityIfHeld(ent)
		ent:SetOwner(nil)
		ply.GGFEnt = nil
	end
	if ballHolder == ply || !IsValid(ballHolder) then 
		holdingTeam = 0 
		SendNewHolder() 
	end
end
hook.Add("PlayerDeath", "GravGunFix_PlayerDeath", GGFix_Death)

local function achievementEarned(pl,t)
	--pl.NumEarned = pl.NumEarned + 1

end
hook.Add("PlayerEarnedAchievement","addthemup",achievementEarned)