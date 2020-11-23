local ranknames = {
	[0] = "user",
	[1] = "moderator",
	[2] = "admin",
	[3] = "superadmin",
}

local donatornames = {
	[0] = "non-donator",
	[1] = "donator",
	[2] = "platinum donator",
}


local function RconSetDonator( args )
	if !args[1] or !args[2] then print( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local rank = math.Clamp(tonumber(args[2]), 0, 2)
	local people = {}
	for k, v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then print( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then print( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	people[1]:SetNWInt( "DonatorRank", rank )
	print( "Set "..people[1]:Nick().."'s donator rank to "..donatornames[rank] )
	if rank >= 1 then people[1]:ChatPrint( "Thank you for donating to our server! You are now a "..donatornames[rank] ) else people[1]:ChatPrint( "Your donator priveleges have been stripped!" ) end
	people[1]:SaveProfile()
end

concommand.Add( "fw_admin_set_donator", function( ply, cmd, args )
	if !ply:IsValid() then RconSetDonator( args ) return end
	if !ply:IsSuperAdmin() then ply:ChatPrint( "Only superadmins can use this command!" ) return end
	if !args[1] or !args[2] then ply:ChatPrint( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local rank = math.Clamp(tonumber(args[2]), 0, 2)
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then ply:ChatPrint( "Multiple targets found! Please be more specific with the target's name!" ) return end

	people[1]:SetNWInt( "DonatorRank", math.Clamp(rank, 0, 2) )
	ply:ChatPrint( "Set "..people[1]:Nick().."'s donator rank to "..donatornames[rank] )
	if rank >= 1 then people[1]:ChatPrint( "Thank you for donating to our server! You are now a "..donatornames[rank] ) else people[1]:ChatPrint( "Your donator priveleges have been stripped!" ) end
	people[1]:SaveProfile()
end )

local function RconSetDonatorID( args )
	if !args[1] or !args[2] then print( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local rank = math.Clamp(tonumber(args[2]), 0, 2)
	local online = false
	for k,v in pairs( player.GetAll() ) do
		if v:SteamID() == target then 
			v:SetNWInt( "DonatorRank", math.Clamp(rank, 0, 2) ) 
			online = true 
			v:SaveProfile()
			print( "Set "..v:Nick().."'s donator rank to "..donatornames[rank] )
			if rank >= 1 then v:ChatPrint( "Thank you for donating to our server!" ) else v:ChatPrint( "Your donator priveleges have been stripped!" ) end
		end
	end
	if online then return end
	local data = util.GetPData( target, "fw2_stats", "" )
	if data == "" then print( "Invalid SteamID! either this player has never played here before or you typed something wrong" ) return end
	local stats = string.Explode("|", data )

	local newdata = table.concat({ stats[1], stats[2], rank, stats[4] }, "|")
	util.SetPData( target, "fw2_stats", newdata )
	print( "Set "..target.."'s donator rank to "..donatornames[rank] )
end

concommand.Add( "fw_admin_set_donator_id", function( ply, cmd, args )
	if !ply:IsValid() then RconSetDonatorID( args ) return end
	if !ply:IsSuperAdmin() then ply:ChatPrint( "Only superadmins can use this command!" ) return end
	if !args[1] or !args[2] then ply:ChatPrint( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local rank = math.Clamp(tonumber(args[2]), 0, 2)
	local online = false
	for k,v in pairs( player.GetAll() ) do
		if v:SteamID() == target then 
			v:SetNWInt( "DonatorRank", math.Clamp(rank, 0, 2) ) 
			online = true 
			v:SaveProfile() 
			if rank >= 1 then v:ChatPrint( "Thank you for donating to our server!" ) else v:ChatPrint( "Your donator priveleges have been stripped!" ) end
		end
	end
	if online then return end
	local data = util.GetPData( target, "fw2_stats", "" )
	if data == "" then ply:ChatPrint( "Invalid SteamID! either this player has never played here before or you typed something wrong" ) return end
	local stats = string.Explode("|", data )

	local newdata = table.concat({ stats[1], stats[2], math.Clamp(rank, 0, 2), stats[4] }, "|")
	util.SetPData( target, "fw2_stats", newdata )
	ply:ChatPrint( "Set "..target.."'s donator rank to "..donatornames[rank] )

end )

local function RconSetAdmin( args )
	if !args[1] or !args[2] then print( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local rank = math.Clamp(tonumber(args[2]), 0, 3)
	local people = {}
	for k, v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then print( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then print( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	people[1]:SetNWInt( "AdminRank", rank )
	print( "Set "..people[1]:Nick().."'s staff rank to "..ranknames[rank] )
	if rank >= 1 then people[1]:ChatPrint( "You have been given the "..ranknames[rank].." rank!" ) else people[1]:ChatPrint( "Your admin prank has been stripped!" ) end
	people[1]:SaveProfile()
end

concommand.Add( "fw_admin_set_admin", function( ply, cmd, args )
	if !ply:IsValid() then RconSetAdmin( args ) return end
	if !ply:IsSuperAdmin() then ply:ChatPrint( "Only superadmins can use this command!" ) return end
	if !args[1] or !args[2] then ply:ChatPrint( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local rank = math.Clamp(tonumber(args[2]), 0, 3)
	local people = {}
	for k, v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then ply:ChatPrint( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then ply:ChatPrint( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	people[1]:SetNWInt( "AdminRank", rank )
	ply:ChatPrint( "Set "..people[1]:Nick().."'s staff rank to "..ranknames[rank] )
	if rank >= 1 then people[1]:ChatPrint( "You have been given the "..ranknames[rank].." rank!" ) else people[1]:ChatPrint( "Your admin prank has been stripped!" ) end
	people[1]:SaveProfile()
end )

local function RconKick( args )
	if !args[1] then print( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local reason = tostring(args[2]) or "No reason given, you know what you did anyway faggot"
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then print( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then print( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	for k, v in pairs(player.GetAll()) do v:ChatPrint( people[1]:Nick().." was kicked from the server for: "..reason ) end
	print( "You kicked "..people[1]:Nick().." from the server for: "..reason )
	people[1]:ClearProps()
	people[1]:Kick( reason )
end

concommand.Add( "fw_admin_kick", function( ply, cmd, args )
	if !ply:IsValid() then RconKick( args ) return end
	if !ply:IsModerator() then ply:ChatPrint( "Only moderators and above can use this command!" ) return end
	if !args[1] then ply:ChatPrint( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local reason = tostring(args[2]) or "No reason given, you know what you did anyway faggot"
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then ply:ChatPrint( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then ply:ChatPrint( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	if ply:GetNWInt("AdminRank") <= people[1]:GetNWInt("AdminRank") then ply:ChatPrint( "You can only kick lower ranks! talk to the owner if you have a problem to report with this person!" ) return end

	for k, v in pairs(player.GetAll()) do v:ChatPrint( people[1]:Nick().." was kicked from the server for: "..reason ) end
	people[1]:ClearProps()
	people[1]:Kick( reason )
end )

local function RconBan( args )
	if !args[1] then print( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local time = tonumber(args[2]) or 60
	local reason = "Banned for "..time.."Minutes: "..(tostring(args[3]) or "No reason given, you know what you did anyway faggot")
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then print( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then print( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	for k, v in pairs(player.GetAll()) do v:ChatPrint( people[1]:Nick().." was banned from the server for: "..time.." minutes for: "..reason ) end
	print( "You banned "..people[1]:Nick().." from the server for: "..time.." minutes for: "..reason )
	people[1]:ClearProps()
	people[1]:Ban( time )
	people[1]:Kick( reason )
end

concommand.Add( "fw_admin_ban", function( ply, cmd, args )
	if !ply:IsValid() then RconBan( args ) return end
	if !ply:Moderator() then ply:ChatPrint( "Only moderators and above can use this command!" ) return end
	if !args[1] then ply:ChatPrint( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local time = tonumber(args[2]) or 60
	if ply:IsModerator() and !ply:IsAdmin() and time < 10080 then time = 10080 ply:ChatPrint( "Clamped ban time to 1 week, speak to an admin if you want to ban somebody for longer" ) end
	local reason = "Banned for "..time.."Minutes: "..(tostring(args[3]) or "No reason given, you know what you did anyway faggot")
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then ply:ChatPrint( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then ply:ChatPrint( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	if ply:GetNWInt("AdminRank") <= people[1]:GetNWInt("AdminRank") then ply:ChatPrint( "You can only ban lower ranks! talk to the owner if you have a problem to report with this person!" ) return end

	for k, v in pairs(player.GetAll()) do v:ChatPrint( people[1]:Nick().." was banned from the server for: "..time.." minutes for: "..reason ) end
	people[1]:ClearProps()
	people[1]:Ban( time )
	people[1]:Kick( reason )
end )

local function RconCleanup( args )
	if !args[1] then print( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then print( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then print( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	for k, v in pairs(player.GetAll()) do v:ChatPrint( people[1]:Nick().."'s props have been deleted by an admin!" ) end
	print("You deleted "..people[1]:Nick().."'s props")
	people[1]:ClearProps()
end

concommand.Add( "fw_admin_cleanup", function( ply, cmd, args )
	if !ply:IsValid() then RconCleanup( args ) return end
	if !ply:Moderator() then ply:ChatPrint( "Only moderators and above can use this command!" ) return end
	if !args[1] then ply:ChatPrint( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then ply:ChatPrint( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then ply:ChatPrint( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	if ply:GetNWInt("AdminRank") <= people[1]:GetNWInt("AdminRank") then ply:ChatPrint( "You can only cleanup lower ranks! talk to the owner if you have a problem to report with this person!" ) return end

	for k, v in pairs(player.GetAll()) do v:ChatPrint( people[1]:Nick().."'s props have been deleted by an admin!" ) end
	people[1]:ClearProps()

end )


local function RconGiveMoney( args )
	if !args[1] or !args[2] then print( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local cash = tonumber(args[2])
	local people = {}
	for k, v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then print( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then print( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	people[1]:AddMoney( cash )
	print( "Gave "..people[1]:Nick().." "..cash.." dollars!" )
	people[1]:SaveProfile()
end

concommand.Add( "fw_admin_give_money", function( ply, cmd, args )
	if !ply:IsValid() then RconGiveMoney( args ) return end
	if !ply:IsSuperAdmin() then ply:ChatPrint( "Only superadmins can use this command!" ) return end
	if !args[1] or !args[2] then ply:ChatPrint( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local cash = tonumber(args[2])
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then ply:ChatPrint( "Multiple targets found! Please be more specific with the target's name!" ) return end

	people[1]:AddMoney( cash )
	ply:ChatPrint( "Gave "..people[1]:Nick().." "..cash.." dollars!" )
	people[1]:SaveProfile()
end)


local function RconSetMoney( args )
	if !args[1] or !args[2] then print( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local cash = tonumber(args[2])
	local people = {}
	for k, v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then print( "Multiple targets found! Please be more specific with the target's name!" ) return end
	if #people == 0 then print( "Nobody found by that name! Please be more specific with the target's name!" ) return end

	people[1]:SetMoney( cash )
	print( "Set "..people[1]:Nick().."'s money to "..cash.." dollars!" )
	people[1]:SaveProfile()
end

concommand.Add( "fw_admin_set_money", function( ply, cmd, args )
	if !ply:IsValid() then RconSetMoney( args ) return end
	if !ply:IsSuperAdmin() then ply:ChatPrint( "Only superadmins can use this command!" ) return end
	if !args[1] or !args[2] then ply:ChatPrint( "Invalid syntax! use the fw_admin_help command if you need help" ) return end
	local target = tostring(args[1])
	local cash = tonumber(args[2])
	local people = {}
	for k,v in pairs( player.GetAll() ) do
		if string.find(string.lower(v:Nick()), string.lower(target), 1, true ) != nil then table.insert( people, v ) end
	end
	if #people > 1 then ply:ChatPrint( "Multiple targets found! Please be more specific with the target's name!" ) return end

	people[1]:SetMoney( cash )
	ply:ChatPrint( "Set "..people[1]:Nick().."'s money to "..cash.." dollars!" )
	people[1]:SaveProfile()
end )