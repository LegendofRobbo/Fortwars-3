local wew = "wew"
/*
hook.Add("OnKillPlayer","AchievementKills",function(killer,victim)

	killer:SetDarklandVar("kills",killer:GetDarklandVar("kills",0)+1)
	
	
	
	local class = Classes[killer.Class].NAME
	
	
	killer:SetDarklandVar("totalKills_"..class,killer:GetDarklandVar("totalKills_"..class) + 1)
	
	
	local amt = killer:GetDarklandVar("gameKills_"..class)
	
	if amt < killer.ClassKills[class] then
		killer:SetDarklandVar("gameKills_"..class,killer.ClassKills[class])
	end

	local amt = killer:GetDarklandVar("lifeKills_"..class)
	if amt < killer.LifeClassKills[class] then
		killer:SetDarklandVar("lifeKills_"..class,killer.ClassKills[class])
	end
	
	if class == "Neo" then
		local oClass = Classes[victim.Class].NAME
		
		if oClass == "Assassin" || oClass == "Hitman" then
			
			killer:SetNWInt("NeoSniperShots",killer:GetNWInt("NeoSniperShots")+1)
			
		end
	end

end)
hook.Add("OnAssist","AchievementAssists",function(killer,victim)
	if !IsValid(killer) then return end
	killer:SetDarklandVar("assists",killer:GetDarklandVar("assists",0)+1)

end)

hook.Add("OnExplodeBomb","BoomBoomPow",function(killer,kills)

	local amt = killer:GetDarklandVar("1bombmax")
	if amt < kills then
		killer:SetDarklandVar("1bombmax",kills)
	end
end)
*/