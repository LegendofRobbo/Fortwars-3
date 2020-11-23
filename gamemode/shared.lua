GM.DarklandID = 1
GM.Name = "Fortwars"
GM.Author = "Darkspider/Balrog/LegendofRobbo"
GM.NameSeperator = " - "

local playa = FindMetaTable("Player")

function playa:GetStatus()
	return self:GetNWInt("DonatorRank")
end
function playa:IsPremium()
	return (self:GetStatus() == 1)
end
function playa:IsPlatinum()
	return (self:GetStatus() == 2)
end

function playa:IsModerator()
	return self:GetNWInt("AdminRank") >= 1
end

local oldisadmin = oldisadmin or playa.IsAdmin
function playa:IsAdmin(...)
	if oldisadmin( self, ...) then return true end
	return self:GetNWInt("AdminRank") >= 2
end

local oldissadmin = oldissadmin or playa.IsSuperAdmin
function playa:IsSuperAdmin(...)
	if oldissadmin( self, ...) then return true end
	return self:GetNWInt("AdminRank") == 3
end

DEBUG_MODE = false

DEFAULT_CASH = 12000 --Start with this much cash as a new player
DEFAULT_BALL_TIME = 300 --Start with this much time in reloaded

KILL_MONEY = 50
WIN_MONEY = 1500

BUILD_TIME = 6*60
FIGHT_TIME = 12*60

HOLD_REWARD 	= 5;
END_GAME_TIME = 30

MAX_PROPS = 100

BASE_ENERGY_REGEN = 5 --amt per second

VOTE_THRESH = 0.7
VOTE_DELAY = 2*60
VOTE_WARNING = 10
TEAM_BLUE = 1
TEAM_RED = 2
TEAM_YELLOW = 3
TEAM_GREEN = 4


PRED_MANA_INVIS = 70
NADE_MANA_COST = 40
NEO_MANA_COST = 60
SORC_MANA_ZAP = 30
SORC_MANA_HEAL = 100
-- ADV_MANA_COST = 40

team.SetUp(TEAM_BLUE,"Blue Team",Color(20,20,255,255))
team.SetUp(TEAM_RED,"Red Team",Color(255,20,20,255))
team.SetUp(TEAM_YELLOW,"Yellow Team",Color(200,200,0,255))
team.SetUp(TEAM_GREEN,"Green Team",Color(0,200,0,255))

IS_CHRISTMAS =  false --play christmas song at the end

CHRISTMAS_SONG = "darkland/fortwars/jbells.mp3"
WIN_SONG = "darkland/fortwars/wintest.mp3"


PropList = {}
PropList[1] = {
MODEL = "models/props_junk/wood_crate001a.mdl",
NAME = "Wooden Crate",
PRICE = 5,
HEALTH = 600
}
PropList[2] = {
MODEL = "models/props_junk/wood_crate002a.mdl",
NAME = "Big Wooden Crate",
PRICE = 10,
HEALTH = 600
}
PropList[3] = {
MODEL = "models/props_junk/wood_pallet001a.mdl",
NAME = "Wooden Pallet",
PRICE = 15,
HEALTH = 800
}
PropList[4] = {
MODEL = "models/props_wasteland/wood_fence01a.mdl",
NAME = "Wooden Fence",
PRICE = 30,
HEALTH = 800
}
PropList[5] = {
MODEL = "models/props_pipes/concrete_pipe001a.mdl",
NAME = "Concrete Pipe",
PRICE = 70,
HEALTH = 900
}
PropList[6] = {
MODEL = "models/props_wasteland/wood_fence02a.mdl",
NAME = "Small Wooden Fence",
PRICE = 15,
HEALTH = 900
}



UPropList = {}
UPropList[1] = {
MODEL = "models/hunter/triangles/2x1x1.mdl",
NAME = "Alloy Ramp",
PRICE = 90,
HEALTH = 1400,
BUYCOST = 35000,
}


for i,v in pairs(PropList) do
	Model(v.MODEL)
end

function GM:Move( ply, mv )
	
	if ply:GetDTBool(0) then
		
		local dirVec = Vector(0,0,0)
		
		if ply:KeyDown(IN_FORWARD) then
			dirVec = ply:GetAimVector() * 10
		end
		if ply:KeyDown(IN_BACK) then
			dirVec = ply:GetAimVector() * -10
		end
		if ply:KeyDown(IN_MOVERIGHT) then
			dirVec = dirVec + ply:GetRight() * 10
		end
		if ply:KeyDown(IN_MOVELEFT) then
			dirVec = dirVec + ply:GetRight() * -10
		end
		mv:SetOrigin(mv:GetOrigin()+dirVec)
		return true
	elseif ply.LeftNoClip then
	
		local dirVec = Vector(0,0,0)
		
		if ply:KeyDown(IN_FORWARD) then
			dirVec = ply:GetAimVector() * 10
		end
		if ply:KeyDown(IN_BACK) then
			dirVec = ply:GetAimVector() * -10
		end
		if ply:KeyDown(IN_MOVERIGHT) then
			dirVec = dirVec + ply:GetRight() * 10
		end
		if ply:KeyDown(IN_MOVELEFT) then
			dirVec = dirVec + ply:GetRight() * -10
		end
		
		timer.Simple(0.001,function() ply:SetLocalVelocity(dirVec*50) end)
		ply.LeftNoClip = false
	end
	
end
function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 
     return ply:GetDTBool(0) -- Don't allow default footsteps in  plat fly
end



Classes = {}

Classes[1] = {
	NAME = "Human",
	COST = 0,
	WEAPON = "human_gun",
	DESCRIPTION = "The standard noob class. Pretty terrible on its own but it can be decent with the right upgrades installed. You have a standard glock, fires one bullet per shot. Right click to call Hax on someone.",
	HEALTH = 100,
	SPEED = 250,
	MODEL = "scientist",
	LEVELS = 2,
	ABILITY = "Noob army: Respawn 50% faster",
}

Classes[2] = {
	NAME = "Gunner",
	COST = 6000,
	WEAPON = "gunner_gun",
	DESCRIPTION = "If you can aim well then this is the class for you, its desert eagle pistol will drop even the toughest targets with a couple of headshots.",
	HEALTH = 100,
	SPEED = 170,
	MODEL = "barney",
	LEVELS = 1,
	ABILITY = "",
}

Classes[3] = {
	NAME = "Raider",
	COST = 10000,
	WEAPON = "raider_gun",
	DESCRIPTION = "An agile unit equipped with a rapid firing SMG, great for fast assaults and attacking from unexpected places.  A good choice as a first purchase for a new player",
	HEALTH = 80,
	SPEED = 250,
	MODEL = "models/player/Group03/male_03.mdl",
	LEVELS = 2,
	ABILITY = "Blitzkrieg Rush (80 mana): A short burst of speed",
}

Classes[4] = {
	NAME = "Ninja",
	COST = 15000,
	WEAPON = "ninja_gun",
	DESCRIPTION = "A light assault class that is geared towards ball hunting or getting into difficult bases.  Right click allows you to use a silencer but it's purely cosmetic.",
	HEALTH = 80,
	SPEED = 300,
	MODEL = "mossman",
	SPAWNFUNC = function(pl) pl:SetJumpPower(400) end,
	CHANGEFUNC = function(pl) pl:SetJumpPower(200) end,
	LEVELS = 2,
	ABILITY = "Double Jump: Change direction midair",
}


Classes[5] = {
	NAME = "Hitman",
	COST = 30000,
	WEAPON = "hitman_gun",
	DESCRIPTION = "You are the team sniper, stay back out of the fight and use your scout rifle to make sure its your boys who get their hands on the ball.",
	HEALTH = 100,
	SPEED = 250,
	MODEL = "breen",
	LEVELS = 2,
	ABILITY = "Tag Shot: mark enemies out on hud when you shoot them",
}

Classes[6] = {
	NAME = "Golem",
	COST = 25000,
	WEAPON = "golem_gun",
	DESCRIPTION = "You are basically a moving turret, using your m249 machine gun to lay down sheets of suppressing fire that will stop the enemy charge dead in its tracks.",
	HEALTH = 150,
	SPEED = 150,
	MODEL = "monk",
	LEVELS = 2,
	ABILITY = "Golem Lockdown (90 mana): Become a turret",
}

Classes[7] = {
	NAME = "Predator",
	COST = 45000,
	WEAPON = "pred_gun",
	DESCRIPTION = "Like assassinating people from behind? This class allows you to cloak with right mouse button and has a knife. If you crouch you become even harder to see. This class is preferably used for offense or ambushing.",
	HEALTH = 120,
	SPEED = 275,
	MODEL = "gman",
	LEVELS = 1,
	ABILITY = "",
}

Classes[8] = {
	NAME = "Juggernaught",
	COST = 60000,
	WEAPON = "jugg_gun",
	DESCRIPTION = "I'm the juggernaut bitch! outlast your enemies with your massive health pool then gun them down with your superior close range firepower.  Remember to avoid snipers!",
	HEALTH = 200,
	SPEED = 150,
	MODEL = "odessa",
	LEVELS = 2,
	ABILITY = "Rubber Bullets: Bullets slow enemies briefly",
}

Classes[9] = {
	NAME = "Bomber",
	COST = 70000,
	WEAPON = "bomber_gun",
	DESCRIPTION = "ALLAHU AKBAR",
	HEALTH = 180,
	SPEED = 210,
	MODEL = "eli",
	LEVELS = 2,
	ABILITY = "Short Fuse: Shorter wind-up time for your bomb",
}

Classes[10] = {
	NAME = "Swat",
	COST = 50000,
	WEAPON = "swat_gun",
	DESCRIPTION = "Armed with the M4A1 Carbine, Swat's are accurate and powerful if you have good aim. A well balanced class that can be used effectively in both the assault and defense roles.",
	HEALTH = 100,
	SPEED = 230,
	--MODEL = "super"
	MODEL = "models/player/Combine_Super_Soldier.mdl",
	LEVELS = 2,
	ABILITY = "Frag Grenade (80 mana): Toss a frag grenade",
}
Classes[11] = {
	NAME = "Terrorist",
	COST = 55000,
	WEAPON = "terrorist_gun",
	DESCRIPTION = "Terrorize your enemies with your powerful AK-47 rifle.  You may not have as much raw offensive power as the swat but you are tougher and can outlast them in pitched battles.",
	HEALTH = 120,
	SPEED = 220,
	--MODEL = "prison"
	MODEL = "models/player/Combine_Soldier_PrisonGuard.mdl",
	LEVELS = 2,
	ABILITY = "Extended Wrath (10 mana): Keep firing even when empty",
}

Classes[12] = {
	NAME = "Sorcerer",
	COST = 60000,
	WEAPON = "sorcerer_gun",
	DESCRIPTION = "Armed with a lightning wand that can fling a single powerful bolt or (with upgrades) chain lightning that can roast their entire squad.  Use your mana wisely as it's easy to run out and be left defenseless!",
	HEALTH = 80,
	SPEED = 230,
	MODEL = "stripped",
	LEVELS = 2,
	ABILITY = "Bounce Bolt (45 mana): Fire a bolt that bounces to 1 target",
}
Classes[13] = {
	NAME = "Neo",
	COST = 70000,
	WEAPON = "neo_gun",
	DESCRIPTION = "The ultimate ball hunter, your leap ability can run rings about the slow plebs on the ground.  Be careful though, you are fragile and your matrix powers won't save you from gravity if you mess up a jump.",
	HEALTH = 90,
	SPEED = 230,
	--MODEL = "burnt"
	MODEL = "models/player/police.mdl",
	LEVELS = 1,
	ABILITY = "",
}
Classes[14] = {
	NAME = "Assassin",
	COST = 60000,
	WEAPON = "assassin_gun",
	DESCRIPTION = "Like Hitman, except you could afford a gun with an actual magazine.  Your sig 550 rifle is difficult to master but incredibly deadly when you do so.",
	HEALTH = 100,
	SPEED = 170,
	MODEL = "gman",
	LEVELS = 1,
	ABILITY = "",
}
Classes[15] = {
	NAME = "Advancer",
	COST = 45000,
	WEAPON = "advancer_gun",
	DESCRIPTION = "A slow moving heavy assault class that mows enemies down with its relentless P90 smg.  Can inflict massive casualties but you'll need backup from your team because you don't last long under fire.",
	HEALTH = 120,
	SPEED = 120,
	MODEL = "charple",
	LEVELS = 2,
	ABILITY = "Splinter Shot: Fire 10 bullets at once!",
}
Classes[16] = {
	NAME = "RocketMan",
	COST = 60000,
	WEAPON = "arena_rocket",
	DESCRIPTION = "Ever seen a large group of enemies camping in a tunnel and thought to yourself \"damn i wish i could just blow them all up at once\".  Well now you can!  Just try not to vaporize yourself along with them",
	HEALTH = 160,
	SPEED = 100,
	MODEL = "odessa",
	LEVELS = 1,
	ABILITY = "",
}
Classes[17] = {
	NAME = "Grenadier",
	COST = 60000,
	WEAPON = "grenade_gun",
	DESCRIPTION = "This class throws powerful grenades that can blast enemies into gory chunks. Use wisely and try not to blow yourself up! (Grenades require mana to throw but have unlimited ammunition)",
	HEALTH = 80,
	SPEED = 100,
	MODEL = "odessa",
	LEVELS = 1,
	ABILITY = "",
}

/*
Classes[18] = {
	NAME = "Huntsman",
	COST = 40000,
	WEAPON = "hunter_gun",
	DESCRIPTION = "A hunter equipped with a high powered crossbow",
	HEALTH = 100,
	SPEED = 200,
	MODEL = "models/player/guerilla.mdl",
	LEVELS = 1,
	ABILITY = "",
}

Classes[19] = {
	NAME = "Undead",
	COST = 20000,
	WEAPON = "zombie_gun",
	DESCRIPTION = "You are the walking dead! use your powerful melee attacks to batter your enemies into a quivering heap",
	HEALTH = 150,
	SPEED = 250,
	MODEL = "models/player/zombie_classic.mdl",
	LEVELS = 2,
	ABILITY = "Regeneration (passive): Constantly regenerate health",
}
Classes[20] = {
	NAME = "Support",
	COST = 35000,
	WEAPON = "support_gun",
	DESCRIPTION = "You are the supporter, fire healing beams at your wounded teammates to heal them\nBe careful not to accidentally heal an enemy!",
	HEALTH = 60,
	SPEED = 180,
	MODEL = "models/player/p2_chell.mdl",
	LEVELS = 2,
	ABILITY = "EMP Bullets (passive): Your pistol disrupts enemies mana bars, making it harder for them to use their abilities effectively",
}
*/


EndGameStats = {}
EndGameStats[1] = {
	Text = function(pl,data) return pl:Name().." is the Sadist, with "..data.." Kills!" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w:Frags()})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[2] = {
	Text = function(pl,data) return pl:Name().." is the MoneyMaker, earning a total of $"..data end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w.MoneyEarned or 0})
		end
		table.sort(t,function(a,b)  return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[3] = {
	Text = function(pl,data) return pl:Name().." is the BaseBuilder, wasting $"..data.." in props" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w.ProppedMoney or 0})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[4] = {
	Text = function(pl,data) return pl:Name().." doesn't afraid of anything, with "..data.." deaths" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w:Deaths()})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[5] = {
	Text = function(pl,data) return pl:Name().." is the Homewrecker, doing a total of "..data.." building damage" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w.BuildingDamage or 0})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[6] = {
	Text = function(pl,data) return pl:Name().." is a bit shy, with only  "..data.." kills" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w:Frags()})
		end
		table.sort(t,function(a,b) return a[2] < b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[7] = {
	Text = function(pl,data) return pl:Name().." is emo with "..data.." suicides" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w.Suicides or 0})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[8] = {
	Text = function(pl,data) return pl:Name().." is the Headhunter with "..data.." headshots" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w.Headshots or 0})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[9] = {
	Text = function(pl,data) return pl:Name().." is taking the game seriously, earning "..data.." achievements" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w.NumEarned or 0})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[10] = {
	Text = function(pl,data) return pl:Name().." is a Ball Whore, holding the ball for "..data.." seconds" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w.BallSecs or 0})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}
EndGameStats[11] = {
	Text = function(pl,data) if !IsValid(pl) then return "Nobody is impatient, because nobody voteskipped!" end return pl:Name().." is impatient, being the first voteskipper this round" end,
	Grabber = function(pl)
		for q,w in pairs(player.GetAll()) do
			if w.firstSkipper then
				return w
			end
		end
	end
}
EndGameStats[12] = {
	Text = function(pl,data) return pl:Name().." likes to spam chat, with a total of "..data.." messages" end,
	Grabber = function(pl)
		local t = {}
		for q,w in pairs(player.GetAll()) do
			table.insert(t,{w,w.Messages or 0})
		end
		table.sort(t,function(a,b) return a[2] > b[2] end)
		
		return t[1][1],t[1][2]
	end
}

for i,v in pairs(Classes) do
	if !string.find(v.MODEL,"/") then
		v.MODEL = player_manager.TranslatePlayerModel(v.MODEL)
	end
	Model(v.MODEL)
end


---------------
--skills
---------------
Skills = {}

Skills[1] = {
	NAME = "Speed",
	COST = 5000,
	DESCRIPTION = "Buying more speed will make your character move faster than normal. You will travel faster for each upgrade up to a maximum of 5 upgrades",
}

Skills[2] = {
	NAME = "Health",
	COST = 6000,
	DESCRIPTION = "This upgrade will give you 10 Health Points for each upgrade to a maximum of 50 health.",
}

Skills[3] = {
	NAME = "Max Energy",
	COST = 6000,
	DESCRIPTION = "This upgrade will increase your maximum energy by five energy Points up to a maximum of 25 points.",
}
Skills[4] = {
	NAME = "Energy Regen",
	COST = 6500,
	DESCRIPTION = "This upgrade will increase your energy regeneration by one energy Point per level to a maximum of +5",
}

Skills[5] = {
	NAME = "Better Props",
	COST = 0,
	DESCRIPTION = "Buy some better props to build your base out of",
}


------------
--Maplist
------------
mapList = {
{"fw_concrete"},
{"fw_earthlanding_b3"},
{"fw_quad"},
{"fw_parkwar"},
{"fw_thebridge"},
{"fw_teleport"},
{"fw_adultswim_v2"},
{"fw_spiral_v2"},
{"fw_airgrid"},
{"fw_mayan"},
{"fw_3towers2"},
{"fw_4_platforms"},
{"fw_arches"},
{"fw_boxed"},
{"fw_bunkers"},
{"fw_circlewarz"},
{"fw_city_v2"},
{"fw_demoneye_b2"},
{"fw_destruction"},
{"fw_dock_b1"},
{"fw_greengrass_re_v31"},
{"fw_junglealtar"},
{"fw_ledges"},
{"fw_municipal"},
{"fw_sunny_4"},
{"fw_temple_v2"},
{"fw_towerpower_v2"},
{"fw_weedlab"},


--{"fw_excellence"},
--{"fw_pipeline_v2"},
--{"fw_pool_v2"},
--{"fw_river"}
-- {"fw_waterway"},
-- {"fw_portal"},
-- {"fw_oct_4"},
-- {"fw_battleships3"},
-- {"fw_trenches3"},
-- {"fw_hydro"},
-- {"fw_tactical"},
-- {"fw_chambers_final"},
-- {"fw_teleport"},
-- {"fw_rogueball"},
-- {"fw_2forttfc_v2"},
-- {"fw_war"},
-- {"fw_developers2"},
-- {"fw_arched2"},
-- {"fw_harbor"},
-- {"fw_choices"},
-- {"fw_ambush"},
-- {"fw_parkwar"},
-- {"fw_adultswim_v2"},
-- {"fw_symmetry"},
-- {"fw_spiral_v2"},
-- {"fw_bunkers"},
-- {"fw_demoneye_b2"},
-- {"fw_thebridge"},
-- {"fw_airgrid"},
-- {"fw_diarena"},
-- {"fw_cuba"},
-- {"fw_outpost_v2"},
-- {"fw_3rooms"},
-- {"fw_fourrooms"},
-- {"fw_sharting_dragons_v1"},
-- {"fw_tworooms"},
-- {"fw_endoftime"},
-- {"fw_ledges"},
-- {"fw_2sides"},
-- {"fw_2fort_night"},
-- {"fw_ball_room_blitz"},
-- {"fw_circlewarz"},
-- {"Fw_city"},
-- {"fw_delay"},
-- {"fw_devreversed_v2"},
-- {"fw_ditch_v3"},
-- {"fw_funtime"},
-- {"fw_italy"},
-- {"fw_junglealtar"},
-- {"fw_lake_v2"},
-- {"fw_ledges"},
-- {"fw_no_where"},
-- {"fw_octagon_v2"},
-- {"fw_platforms"},
-- {"fw_PMG_FTW_V1"},
-- {"fw_ramp"},
-- {"fw_volcano_v2"},
-- {"fw_stairs"},
-- {"fw_temple_v2"},
-- {"fw_towerpower_v2"},
-- {"fw_TrimfortsV2"},
-- {"fw_iceworld"},
-- {"fw_3some7"},
-- {"fw_hellhound_v6"},
-- {"fw_arena_V2"},
-- {"fw_municipal"},
-- {"fw_excellence"},
-- {"fw_miniV1"},
-- {"fw_climb2"},
-- {"fw_football"},
-- {"fw_twbunk"},
-- {"fw_containment"},
-- {"fw_goldengate_v3"},
-- {"fw_refinery21"},
-- {"fw_pit"}
}




--Achievements for FortWars
/*
achievement.Add(
"100 Kills",
function(pl) return pl:GetDarklandVar("kills",0) > 99 end,
--"http://www.darklandservers.com/garrysmod/da_awards/100_kills.png",
"http://img2.wikia.nocookie.net/__cb20130807183653/dishonoredvideogame/images/8/8f/Message_from_the_Empress.png",
1,
"Get at least 100 overall kills in FortWars",
function(pl) return pl:GetDarklandVar("kills",0) / 100 end,
function(pl) return math.min(100,pl:GetDarklandVar("kills",0)) end,
"100 Kills")
*/
--[[
achievement.Add(
"500 Kills",
function(pl) return pl:GetDarklandVar("kills",0) > 499 end,
"http://www.darklandservers.com/garrysmod/da_awards/500_kills.png",
1,
"Get at least 500 overall kills in FortWars",
function(pl) return pl:GetDarklandVar("kills",0) / 500 end,
function(pl) return math.min(500,pl:GetDarklandVar("kills",0)) end,
"500 Kills")

achievement.Add(
"1000 Kills",
function(pl) return pl:GetDarklandVar("kills",0) > 999 end,
"http://www.darklandservers.com/garrysmod/da_awards/1000_kills.png",
1,
"Get at least 1000 overall kills in FortWars",
function(pl) return pl:GetDarklandVar("kills",0) / 1000 end,
function(pl) return math.min(1000,pl:GetDarklandVar("kills",0)) end,
"1000 Kills")

achievement.Add(
"3000 Kills",
function(pl) return pl:GetDarklandVar("kills",0) > 2999 end,
"http://www.darklandservers.com/garrysmod/da_awards/3000_kills.png",
1,
"Get at least 3000 overall kills in FortWars",
function(pl) return pl:GetDarklandVar("kills",0) / 3000 end,
function(pl) return math.min(3000,pl:GetDarklandVar("kills",0)) end,
"3000 Kills")


achievement.Add(
"10000 Kills",
function(pl) return pl:GetDarklandVar("kills",0) > 9999 end,
"http://www.darklandservers.com/garrysmod/da_awards/10000_kills.png",
1,
"Get at least 10000 overall kills in FortWars",
function(pl) return pl:GetDarklandVar("kills",0) / 10000 end,
function(pl) return math.min(10000,pl:GetDarklandVar("kills",0)) end,
"10000 Kills")


achievement.Add(
"20000 Kills",
function(pl) return pl:GetDarklandVar("kills",0) > 19999 end,
"http://www.darklandservers.com/garrysmod/da_awards/20000_kills.png",
1,
"Get at least 20000 overall kills in FortWars",
function(pl) return pl:GetDarklandVar("kills",0) / 20000 end,
function(pl) return math.min(20000,pl:GetDarklandVar("kills",0)) end,
"20000 Kills")

achievement.Add(
"Hole In A Pocket",
function(pl) return pl:GetMoney() > 9999 end,
"http://www.darklandservers.com/garrysmod/da_awards/hole_in_pocket.jpg",
1,
"Get at least $10,000 in FortWars",
function(pl) return pl:GetMoney() / 10000 end,
function(pl) return math.min(10000,pl:GetMoney()) end,
"10000 Dollars")

achievement.Add(
"Spoiled",
function(pl) return pl:GetMoney() > 99999 end,
"http://www.darklandservers.com/garrysmod/da_awards/spoiled.jpg",
1,
"Get at least $100,000 in FortWars",
function(pl) return pl:GetMoney() / 100000 end,
function(pl) return math.min(100000,pl:GetMoney()) end,
"100000 Dollars")

achievement.Add(
"Buddy System",
function(pl) return pl:GetDarklandVar("assists",0) >= 100 end,
"http://www.darklandservers.com/garrysmod/da_awards/buddyachievement.png",
1,
"Get 100 assists on FortWars",
function(pl) return pl:GetDarklandVar("assists",0) / 100 end,
function(pl) return math.min(100,pl:GetDarklandVar("assists",0)) end,
"100 Assists")

achievement.Add(
"Working Together",
function(pl) return pl:GetDarklandVar("assists",0) >= 250 end,
"http://www.darklandservers.com/garrysmod/da_awards/workingtogether.png",
1,
"Get 250 assists on FortWars",
function(pl) return pl:GetDarklandVar("assists",0) / 250 end,
function(pl) return math.min(250,pl:GetDarklandVar("assists",0)) end,
"250 Assists")

achievement.Add(
"Good Teammate",
function(pl) return pl:GetDarklandVar("assists",0) >= 500 end,
"http://www.darklandservers.com/garrysmod/da_awards/goodteammate.png",
1,
"Get 500 assists on FortWars",
function(pl) return pl:GetDarklandVar("assists",0) / 500 end,
function(pl) return math.min(500,pl:GetDarklandVar("assists",0)) end,
"500 Assists")

achievement.Add(
"Got Your Six",
function(pl) return pl:GetDarklandVar("assists",0) >= 1000 end,
"http://www.darklandservers.com/garrysmod/da_awards/gotyoursix.png",
1,
"Get 1000 assists on FortWars",
function(pl) return pl:GetDarklandVar("assists",0) / 1000 end,
function(pl) return math.min(1000,pl:GetDarklandVar("assists",0)) end,
"1000 Assists")

achievement.Add(
"Team Player",
function(pl) return pl:GetDarklandVar("assists",0) >= 2000 end,
"http://www.darklandservers.com/garrysmod/da_awards/teamplayer.png",
1,
"Get 2000 assists on FortWars",
function(pl) return pl:GetDarklandVar("assists",0) / 2000 end,
function(pl) return math.min(2000,pl:GetDarklandVar("assists",0)) end,
"2000 Assists")

achievement.Add(
"Trustworthy",
function(pl) return pl:GetDarklandVar("assists",0) >= 5000 end,
"http://www.darklandservers.com/garrysmod/da_awards/trustworthy.png",
1,
"Get 5000 assists on FortWars",
function(pl) return pl:GetDarklandVar("assists",0) / 5000 end,
function(pl) return math.min(5000,pl:GetDarklandVar("assists",0)) end,
"5000 Assists")



achievement.Add(
"Do You feel lucky?",
function(pl) return pl:GetDarklandVar("lifeKills_Gunner") >= 10 end,
"http://www.darklandservers.com/garrysmod/da_awards/doyoufeellucky.png",
1,
"Get 10 kills in one life as a Gunner",
function(pl) return pl:GetDarklandVar("lifeKills_Gunner") / 10 end,
function(pl) return math.min(10,pl:GetDarklandVar("lifeKills_Gunner")) end,
"10")

achievement.Add(
"Eye For An Eye",
function(pl) return false end,
"http://www.darklandservers.com/garrysmod/da_awards/EyeforanEye.png",
1,
"Kill someone who has killed you within the past 10 seconds",
false,
false,
false)

achievement.Add(
"Mercenary",
function(pl) return pl:GetDarklandVar("lifeKills_Predator") >= 10 end,
"http://www.darklandservers.com/garrysmod/da_awards/Mercenary.png",
1,
"Get 10 kills in one life as a Predator",
function(pl) return pl:GetDarklandVar("lifeKills_Predator") / 10 end,
function(pl) return math.min(10,pl:GetDarklandVar("lifeKills_Predator")) end,
"10")

achievement.Add(
"Rick James",
function(pl) return pl:GetDarklandVar("gameKills_Bomber") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/rickjames.png",
1,
"Blow up 50 people in one game",
function(pl) return pl:GetDarklandVar("gameKills_Bomber") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Bomber")) end,
"50")

achievement.Add(
"Marksman",
function(pl) return pl:GetDarklandVar("gameKills_Assassin") + pl:GetDarklandVar("gameKills_Hitman") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/marksman.png",
1,
"Get 50 kills with a sniper rifle in one game on FortWars",
function(pl) return (pl:GetDarklandVar("gameKills_Assassin") + pl:GetDarklandVar("gameKills_Hitman")) / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Assassin") + pl:GetDarklandVar("gameKills_Hitman")) end,
"50")

achievement.Add(
"Shoop da Woop",
function(pl) return pl:GetDarklandVar("gameKills_Sorcerer") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/ShoopdaWoop.png",
1,
"Zap 50 people to death as a Sorcerer in one game",
function(pl) return pl:GetDarklandVar("gameKills_Sorcerer") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Sorcerer")) end,
"50")

achievement.Add(
"Last Man Standing",
function(pl) return pl:GetDarklandVar("gameKills_Human") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/LastManStanding.png",
1,
"Show em' who's best, kill 50 people as a human in one game",
function(pl) return pl:GetDarklandVar("gameKills_Human") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Human")) end,
"50")

achievement.Add(
"Medal of Honor",
function(pl) return pl:GetDarklandVar("gameKills_Swat") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/MedalofHonor.png",
1,
"You made the team, 50 kills as Swat in one game",
function(pl) return pl:GetDarklandVar("gameKills_Swat") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Swat")) end,
"50")

achievement.Add(
"Iron Cross",
function(pl) return pl:GetDarklandVar("gameKills_Terrorist") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/NationalThreat.png",
1,
"Instill fear by getting 50 kills as Terrorist in one game",
function(pl) return pl:GetDarklandVar("gameKills_Terrorist") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Terrorist")) end,
"50")

achievement.Add(
"Crackshot",
function(pl) return pl:GetDarklandVar("gameKills_Gunner") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/Crackshot.png",
1,
"Run the streets, get 50 kills as Gunner in one game",
function(pl) return pl:GetDarklandVar("gameKills_Gunner") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Gunner")) end,
"50")

achievement.Add(
"Shotty Master",
function(pl) return pl:GetDarklandVar("gameKills_Juggernaught") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/ShottyMaster.png",
1,
"Using your trusty shotgun, get 50 kills as Juggernaught in one game",
function(pl) return pl:GetDarklandVar("gameKills_Juggernaught") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Juggernaught")) end,
"50")

achievement.Add(
"Human Tank",
function(pl) return pl:GetDarklandVar("gameKills_Golem") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/HumanTank.png",
1,
"Take aim, get 50 kills as Golem in one game",
function(pl) return pl:GetDarklandVar("gameKills_Golem") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Golem")) end,
"50")

achievement.Add(
"Soldier",
function(pl) return pl:GetDarklandVar("gameKills_Advancer") >= 50 end,
"http://www.darklandservers.com/garrysmod/da_awards/Soldier.png",
1,
"Take aim, get 50 kills as Advancer in one game",
function(pl) return pl:GetDarklandVar("gameKills_Advancer") / 50 end,
function(pl) return math.min(50,pl:GetDarklandVar("gameKills_Advancer")) end,
"50")


local function ServerVet(ply)
	for i,v in pairs(ply.Classes) do
		if v != 1 then return false end
	end
	if ply:GetMoney() < 100000 then return false end
	if ply:GetDarklandVar("kills") < 10000 then return false end
	return true
end
local function ClientVet(pl)
	for i,v in pairs(myClasses) do
		if v != true then return false end
	end
	if myMoney < 100000 then return false end
	if pl:GetDarklandVar("kills") < 10000 then return false end
	return true
end

achievement.Add(
"Veteran",
function(pl) if SERVER then return ServerVet(pl) else return ClientVet(pl) end end,
"http://www.darklandservers.com/garrysmod/da_awards/Veteran.png",
1,
"Get all classes, have $100k, and have 10k kills",
false,
false,
false)


achievement.Add(
"Anti-Camper",
function(pl) return pl:GetNWInt("NeoSniperShots") >= 20 end,
"http://www.darklandservers.com/garrysmod/da_awards/anti-camper.png",
1,
"Kill 20 snipers in one game as a Neo",
function(pl) return pl:GetNWInt("NeoSniperShots") / 20 end,
function(pl) return math.min(20,pl:GetNWInt("NeoSniperShots")) end,
"20")

achievement.Add(
"C4 Bomber",
function(pl) return pl:GetDarklandVar("1bombmax") >= 2 end,
"http://www.darklandservers.com/garrysmod/da_awards/C4Bomber.png",
1,
"Kill 2 people with one bomb as Bomber",
function(pl) return pl:GetDarklandVar("1bombmax") / 2 end,
function(pl) return math.min(2,pl:GetDarklandVar("1bombmax")) end,
"2")

achievement.Add(
"Atomic Detonator",
function(pl) return pl:GetDarklandVar("1bombmax") >= 3 end,
"http://www.darklandservers.com/garrysmod/da_awards/AtomicDetonator.png",
1,
"Kill 3 people with one bomb as Bomber",
function(pl) return pl:GetDarklandVar("1bombmax") / 3 end,
function(pl) return math.min(3,pl:GetDarklandVar("1bombmax")) end,
"3")

local function get50Awards(pl)
	local t = {}
	table.insert(t,pl:HasAchievement("Rick James"))
	table.insert(t,pl:HasAchievement("Marksman"))
	table.insert(t,pl:HasAchievement("Shoop da Woop"))
	table.insert(t,pl:HasAchievement("Last Man Standing"))
	table.insert(t,pl:HasAchievement("Medal of Honor"))
	table.insert(t,pl:HasAchievement("Iron Cross"))
	table.insert(t,pl:HasAchievement("Crackshot"))
	table.insert(t,pl:HasAchievement("Shotty Master"))
	table.insert(t,pl:HasAchievement("Human Tank"))
	table.insert(t,pl:HasAchievement("Soldier"))
	local num = 0;
	local allTrue = true
	for i,v in pairs(t) do
		if v then
			num = num + 1
		else
			allTrue = false
		end
	end
	return allTrue,num


end


achievement.Add(
"Pwn3r",
function(pl) return get50Awards(pl) end,
"http://www.darklandservers.com/garrysmod/da_awards/Pwn3r.png",
1,
"Obtain all \"50 Kills\" awards.",
function(pl) local t,n = get50Awards(pl) return n / 10 end,
function(pl) local t,n = get50Awards(pl) return n end,
"10")




achievement.Add(
"Ball Grabber",
function(pl) return pl:GetDarklandVar("balltime",0) > 299 end,
"http://www.darklandservers.com/garrysmod/da_awards/5minutes.png",
1,
"Hold the ball in FW Reloaded for 5 minutes",
function(pl) return pl:GetDarklandVar("balltime",0) / 300 end,
function(pl) return math.min(5,math.floor(pl:GetDarklandVar("balltime",0)/60)) end,
"5 Minutes")

achievement.Add(
"Ball Holder",
function(pl) return pl:GetDarklandVar("balltime",0) >= 1800 end,
"http://www.darklandservers.com/garrysmod/da_awards/30minutes.png",
1,
"Hold the ball in FW Reloaded for 30 minutes",
function(pl) return pl:GetDarklandVar("balltime",0) / 1800 end,
function(pl) return math.min(30,math.floor(pl:GetDarklandVar("balltime",0)/60)) end,
"30 Minutes")

achievement.Add(
"Ball Protector",
function(pl) return pl:GetDarklandVar("balltime",0) >= 3600 end,
"http://www.darklandservers.com/garrysmod/da_awards/1hour.png",
1,
"Hold the ball in FW Reloaded for 1 hour",
function(pl) return pl:GetDarklandVar("balltime",0) / 3600 end,
function(pl) return math.min(36,math.floor(pl:GetDarklandVar("balltime",0)/60)) end,
"60 Minutes")

achievement.Add(
"Ball Guardian",
function(pl) return pl:GetDarklandVar("balltime",0) >= 86400 end,
"http://www.darklandservers.com/garrysmod/da_awards/1hour.png",
1,
"Hold the ball in FW Reloaded for 1 day",
function(pl) return pl:GetDarklandVar("balltime",0) / 86400 end,
function(pl) return math.min(24,math.floor(pl:GetDarklandVar("balltime",0)/3600)) end,
"24 Hours")
--]]