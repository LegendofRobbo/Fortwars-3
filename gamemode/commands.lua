function BuildProp(ply,cmd,args)
	if GetBoxCount(ply:Team()) >= MAX_PROPS then return end
	ply.LastSpawnProp = ply.LastSpawnProp or 0
	if ply.LastSpawnProp > CurTime() then return end
	local uprop = false
	local agg = args[2]
	if agg == "true" then uprop = true end
	local index = tonumber(args[1])
	local tbl = {}
	if uprop then if ply.OwnedProps[index] < 1 then ply:ChatPrint("You don't own the blueprint for that prop!") return end tbl = UPropList[index] else tbl = PropList[index] end
	if tbl == {} then return end
	
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = tr.start + ply:GetAimVector()*300
	tr.filter = ply
	local trace = util.TraceLine(tr)
	if trace.Fraction == 0 then ply:EmitSound(Sound("buttons/button19.wav")) ply.LastSpawnProp = CurTime()+1 return end
	
	
	if trace.Hit  then
		local ent = ents.Create("prop")
		ent:SetModel(tbl.MODEL)
		ent:SetPropTable(tbl)
		ent.Team = ply:Team()
		ent:SetNWInt("Team",ply:Team())
		local c = team.GetColor(ent.Team)
		ent:SetColor(Color(c.r, c.g, c.b))
		local obb = ent:OBBMaxs()
		local norm = trace.HitNormal
		local pos = trace.HitPos + Vector(norm.x*obb.x,norm.y*obb.y,norm.z*obb.z)
		
		ent:SetPos(pos)	
		--ent:SetAngles( Vector( 0 + args[2], 0 + args[3], 0 + args[4] ) )
		if trace.Entity:IsValid() && trace.Entity:GetClass() == "prop" then
			ent:SetAngles(trace.Entity:GetAngles())
		end
		ent.Spawner = ply
		ent:Spawn()
		ent:EmitSound(Sound("plats/crane/vertical_stop.wav"))
		RaiseBoxCount(ent.Team)
		ply:TakeMoney(tbl.PRICE)
		ply.ProppedMoney = ply.ProppedMoney + tbl.PRICE
		ply.LastSpawnProp = CurTime()+1
	end
	
end
concommand.Add("createprop",BuildProp)


function ChooseClass(ply,cmd,args)
	local index = tonumber(args[1])
	if !Classes[index] then return end
	if ply.Classes[index] > 0 then -- They do have the class
		if Classes[ply.Class].CHANGEFUNC then Classes[ply.Class].CHANGEFUNC(ply) end
		ply.Class = index
		if ply:Alive() && DEATHMATCH then
			ply:Kill()
		end
		SendClass(ply)
		SendClasses(ply)
		GAMEMODE:UpdateAttributes(ply)
	else
		ply:ChatPrint("You don't own that class!")
	end	
end
concommand.Add("chooseclass",ChooseClass)


function BuyClass(ply,cmd,args)
	local index = tonumber(args[1])
	if !Classes[index] then return end
	local buycost = Classes[index].COST
	local upgradecost = Classes[index].COST / 2
	if index == 1 then upgradecost = 10000 end

	if ply.Money >= buycost and ply.Classes[index] < 1 then
		if Classes[ply.Class].CHANGEFUNC then Classes[ply.Class].CHANGEFUNC(ply) end
		ply.Class = index
		ply.Classes[index] = 1
		ply:TakeMoney(buycost)
		SendClass(ply) -- ??? i dont think this does anything
		SendClasses(ply)
		ply:SaveProfile()
		GAMEMODE:UpdateAttributes(ply)
		ply:ChatPrint("You purchased the "..Classes[index].NAME.." class!")

	elseif ply.Money >= upgradecost and ply.Classes[index] < Classes[index].LEVELS then
		if Classes[ply.Class].CHANGEFUNC then Classes[ply.Class].CHANGEFUNC(ply) end
		ply.Class = index
		ply.Classes[index] = ply.Classes[index] + 1
		ply:TakeMoney(upgradecost)
		SendClass(ply) -- ??? i dont think this does anything
		SendClasses(ply)
		ply:SaveProfile()
		GAMEMODE:UpdateAttributes(ply)
		ply:ChatPrint("You upgraded the "..Classes[index].NAME.." class!")

	elseif ply.Classes[index] == Classes[index].LEVELS then
		ply:ChatPrint("You already own that class!")
	else
		ply:ChatPrint("You can not afford that class")
	end	
end
concommand.Add("buyclass",BuyClass)

/*
function ChooseClass(ply,cmd,args)
	local index = tonumber(args[1])
	if !Classes[index] then return end
	if ply.Classes[index] == 1 then -- They do have the class
		if Classes[ply.Class].CHANGEFUNC then Classes[ply.Class].CHANGEFUNC(ply) end
		ply.Class = index
		if ply:Alive() && DEATHMATCH then
			ply:Kill()
		end
		SendClass(ply)
		SendClasses(ply)
		GAMEMODE:UpdateAttributes(ply)
	elseif ply.Money >= Classes[index].COST then
		if Classes[ply.Class].CHANGEFUNC then Classes[ply.Class].CHANGEFUNC(ply) end
		ply.Class = index
		ply.Classes[index] = 1
		ply:TakeMoney(Classes[index].COST)
		SendClass(ply) -- ??? i dont think this does anything
		SendClasses(ply)
		ply:SaveProfile()
		GAMEMODE:UpdateAttributes(ply)
	else
		ply:ChatPrint("You can not afford that class")
	end	
end
concommand.Add("chooseclass",ChooseClass)

*/

function BuySkill(ply,cmd,args)
	local index = tonumber(args[1])
	if index == 5 then return end
	if !Skills[index] then return end
	if ply.Skills[index] > 4 then return end --You have maxed this skill
	if ply.Money < (Skills[index].COST * (ply.Skills[index]+1)) then ply:ChatPrint("You can not afford this upgrade") return end --You can't afford it
	ply:TakeMoney(Skills[index].COST * (ply.Skills[index]+1))
	ply.Skills[index] = ply.Skills[index] + 1
	ply:SaveProfile()
	SendSkill(ply,index)
	
	GAMEMODE:UpdateAttributes(ply)
	ply:ChatPrint("Upgrades take effect instantly")
end
concommand.Add("buyskill",BuySkill)

function BuyProp(ply,cmd,args)
	local index = tonumber(args[1])
	if !UPropList[index] then return end
	if ply.OwnedProps[index] > 0 then return end
	if ply.Money < UPropList[index].BUYCOST then ply:ChatPrint("You can not afford this blueprint") return end
	ply:TakeMoney(UPropList[index].BUYCOST)
	ply.OwnedProps[index] = 1
	ply:SaveProfile()
	SendProps(ply)
	
	ply:ChatPrint("You purchased the "..UPropList[index].NAME.." blueprint")
end
concommand.Add("buyprop",BuyProp)

local mapVoted = {}
function MapVote(ply,cmd,args)
	local map = tonumber(args[1])
	if !mapList[map] or mapVoted[ply:SteamID()] then return end
	local voteamt = 1
	if ply:IsPlatinum() then
		voteamt = 4
	elseif ply:IsPremium() then
		voteamt = 2
	end
	mapList[map].votes = mapList[map].votes + voteamt;
	umsg.Start("getMapVote")
		umsg.Char(map)
		umsg.Char(voteamt)
	umsg.End()
	mapVoted[ply:SteamID()] = true
end
concommand.Add("mapVote",MapVote)