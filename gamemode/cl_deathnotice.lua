local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED )

language.Add("worldspawn", "Fell to his Clumsy Death")
language.Add("trigger_hurt", "Fell over Writhing in Pain")

// These are our kill icons
local Color_Icon = Color( 255, 80, 0, 255 )
local NPC_Color = Color( 250, 50, 50, 255 )

--surface.CreateFont( "HL2MPTypeDeath", ScreenScale( 30 ), 500, true, true, "HL2MPTypeDeath" )
surface.CreateFont( "HL2MPTypeDeath", {
										font = "HL2MPTypeDeath",
										size = ScreenScale( 30 ),
										weight = 500,
										antialias = true,
										shadow = true})
 
--killicon.AddFont( "prop_physics",		"HL2MPTypeDeath", 	"9", 	Color_Icon )
killicon.AddFont( "weapon_smg1",		"HL2MPTypeDeath", 	"/",	Color_Icon )
killicon.AddFont( "weapon_357",			"HL2MPTypeDeath", 	".", 	Color_Icon )
killicon.AddFont( "weapon_ar2",			"HL2MPTypeDeath", 	"2", 	Color_Icon )
killicon.AddFont( "crossbow_bolt",		"HL2MPTypeDeath", 	"1", 	Color_Icon )
killicon.AddFont( "weapon_shotgun",		"HL2MPTypeDeath", 	"0",	Color_Icon )
killicon.AddFont( "rpg_missile",		"HL2MPTypeDeath", 	"3", 	Color_Icon )
killicon.AddFont( "npc_grenade_frag",		"HL2MPTypeDeath", 	"4",	Color_Icon )
killicon.AddFont( "weapon_pistol",		"HL2MPTypeDeath", 	"-", 	Color_Icon )
killicon.AddFont( "prop_combine_ball",		"HL2MPTypeDeath", 	"8",	Color_Icon )
killicon.AddFont( "grenade_ar2",		"HL2MPTypeDeath", 	"7", 	Color_Icon )
killicon.AddFont( "weapon_stunstick",		"HL2MPTypeDeath", 	"!",	Color_Icon )
killicon.AddFont( "weapon_slam",		"HL2MPTypeDeath", 	"*", 	Color_Icon )
killicon.AddFont( "weapon_crowbar",		"HL2MPTypeDeath", 	"6",	Color_Icon )
killicon.AddFont( "pred_gun",			"CSKillIcons",		"j",	Color_Icon )
killicon.AddFont( "neo_gun",			"CSKillIcons",		"s",	Color_Icon )
killicon.AddFont( "hitman_gun",			"CSKillIcons",		"n",	Color_Icon )
killicon.AddFont( "bomber_gun",			"CSKillIcons",		"I",	Color_Icon )
killicon.AddFont( "swat_gun",			"CSKillIcons",		"w",	Color_Icon )
killicon.AddFont( "terrorist_gun",		"CSKillIcons",		"b",	Color_Icon )
killicon.AddFont( "golem_gun",			"CSKillIcons",		"z",	Color_Icon )
killicon.AddFont( "gunner_gun",			"CSKillIcons",		"f",	Color_Icon )
killicon.AddFont( "assassin_gun",		"CSKillIcons",		"i",	Color_Icon )

killicon.AddAlias( "sorcerer_gun",	"weapon_stunstick"	)
killicon.AddAlias( "prop_physics",	"prop_combine_ball"	)
killicon.AddAlias( "human_gun",		"weapon_pistol"		)
killicon.AddAlias( "ninja_gun",		"weapon_pistol"		)
killicon.AddAlias( "jugg_gun",		"weapon_shotgun"	)

local Deaths = {}

local function PlayerIDOrNameToString( var )

	if ( type( var ) == "string" ) then  
		if ( var == "" ) then return "" end
		return "#"..var
	end
	
	local ply = Entity( var )
	
	if (ply == NULL) then return "NULL!" end
	
	return ply:Name()
	
end 
  
  
local function RecvPlayerKilledByPlayer( message ) 
  
	local victim 	= message:ReadEntity(); 
	local inflictor	= message:ReadString(); 
	local attacker 	= message:ReadEntity(); 
	if (IsValid(attacker) and attacker:IsPlayer()) and (IsValid(victim) and victim:IsPlayer()) then
		GAMEMODE:AddDeathNotice( attacker:GetName(), attacker:Team(), nil, 0, inflictor, victim:GetName(), victim:Team() ) 
	end
end 
	 
usermessage.Hook( "PlayerKilledByPlayer", RecvPlayerKilledByPlayer ) 

local function RecvPlayerKilledByPlayers( message ) 
  
	local victim	= message:ReadEntity(); 
	local inflictor	= message:ReadString(); 
	local attacker	= message:ReadEntity(); 
	local assistant	= message:ReadEntity(); 
	if (IsValid(attacker) and attacker:IsPlayer()) and (IsValid(assistant) and assistant:IsPlayer()) and (IsValid(victim) and victim:IsPlayer()) then
		GAMEMODE:AddDeathNotice( attacker:GetName(), attacker:Team(), assistant:GetName(), assistant:Team(), inflictor, victim:GetName(), victim:Team() ) 
	end
end 
	 
usermessage.Hook( "PlayerKilledByPlayers", RecvPlayerKilledByPlayers ) 
  
  
local function RecvPlayerKilledSelf( message )

	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadString();
	if IsValid(victim) and victim:IsPlayer() then
		GAMEMODE:AddDeathNotice( victim:GetName(), victim:Team(), nil, 0, inflictor, "Bid Farewell to the Cruel World", -1 )
	end

end
 
usermessage.Hook( "PlayerKilledSelf", RecvPlayerKilledSelf ) 


local function RecvPlayerKilled( message ) 
	
	local victim 	= message:ReadEntity(); 
	local inflictor	= message:ReadString(); 
	local attacker 	= "#"..message:ReadString(); 
	
	GAMEMODE:AddDeathNotice( victim:GetName(), victim:Team(), nil, 0, inflictor, attacker, -1 ) 
	
end

usermessage.Hook( "PlayerKilled", RecvPlayerKilled )

local function RecvPlayerKilledNPC( message )

	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadString();
	local attacker 	= message:ReadEntity();
	
	GAMEMODE:AddDeathNotice( attacker:GetName(), attacker:Team(), nil, 0, inflictor, victim, -1 )
  
end
 
usermessage.Hook( "PlayerKilledNPC", RecvPlayerKilledNPC ) 


local function RecvNPCKilledNPC( message ) 
  
	local victim 	= "#" .. message:ReadString(); 
	local inflictor	= message:ReadString(); 
	local attacker 	= "#" .. message:ReadString(); 
			 
	GAMEMODE:AddDeathNotice( attacker, -1, nil, 0, inflictor, victim, -1 ) 
  
end

usermessage.Hook( "NPCKilledNPC", RecvNPCKilledNPC ) 

function GM:AddDeathNotice( Attacker, team1, Assistant, team2, Inflictor, Victim, team3 ) 
  
	local Death = {}
	Death.victim		= 	Victim
	Death.attacker		=	Attacker
	Death.assistant		=	Assistant
	Death.time		=	CurTime()
	
	Death.left		= 	Death.attacker
	Death.right		= 	Death.victim
	Death.icon		=	Inflictor
	if ( team1 == -1 ) then Death.color1 = table.Copy( NPC_Color )
	else Death.color1 = table.Copy( team.GetColor( team1 ) ) end
	
	if ( team2 == -1 ) then Death.color2 = table.Copy( NPC_Color )
	else Death.color2 = table.Copy( team.GetColor( team2 ) ) end

 	if ( team3 == -1 ) then Death.color3 = table.Copy( NPC_Color )
	else Death.color3 = table.Copy( team.GetColor( team3 ) ) end
	
	if (Death.left == Death.right) then
		Death.left = nil
		Death.icon = "suicide"
	end
	 
	table.insert( Deaths, Death )
  
end 

local function DrawDeath( x, y, death, hud_deathnotice_time )

	local w, h = killicon.GetSize( death.icon )
	w = w*0.5
	
	local fadeout = ( death.time + hud_deathnotice_time ) - CurTime()
	
	local alpha = math.Clamp( fadeout * 255, 0, 255 )
	death.color1.a = alpha
	death.color2.a = alpha
	death.color2.a = alpha
	

	surface.SetFont("ScoreboardSubtitle") --Changed from "ScoreboardText"
	local xx, ay = surface.GetTextSize( death.right )
	local ax, ay = surface.GetTextSize( death.attacker )
	x = x - xx - 32 - w

	if (death.attacker and death.assistant) then
		local bx, ay = surface.GetTextSize( death.assistant )
		local cx, ay = surface.GetTextSize( "+" )
		--draw.RoundedBox( (ay+4)*0.5, x - ax - bx - cx - w - 40, y-2, x + xx + ax + bx + cx + w + 32, ay+4, Color(255,255,255,alpha))
		--draw.RoundedBox( 4, x-w-2, y-h*0.25-2, w*2+4, h+4, Color(255,255,255,alpha))
		--draw.RoundedBox( ay*0.5, x - ax - bx - cx - w - 38, y, x + xx + ax + bx + cx + w + 32, ay, Color(000,000,000,alpha))
		draw.SimpleText( death.assistant, "ScoreboardSubtitle", x - w - 16, y, death.color2, TEXT_ALIGN_RIGHT )
		draw.SimpleText( "+", "ScoreboardSubtitle", x - bx - w - 24, y, Color(255,255,255,alpha), TEXT_ALIGN_RIGHT )
		draw.SimpleText( death.attacker, "ScoreboardSubtitle", x - bx - cx - w - 32, y, death.color1, TEXT_ALIGN_RIGHT )
	elseif (death.attacker) then
		--draw.RoundedBox( (ay+4)*0.5, x - ax - w - 26, y-2, x + ax + xx + w + 32, ay+4, Color(255,255,255,alpha))
		--draw.RoundedBox( 4, x-w-2, y-h*0.25-2, w*2+4, h+4, Color(255,255,255,alpha))
		--draw.RoundedBox( ay*0.5, x - ax - w - 24, y, x + ax + xx + w + 32, ay, Color(000,000,000,alpha))
		draw.SimpleText( death.attacker, "ScoreboardSubtitle", x - w - 16, y, death.color1, TEXT_ALIGN_RIGHT )
	end
	
	// Draw Icon
	--draw.RoundedBox( 2, x-w, y-h*0.25, w*2, h, Color(000,000,000,alpha))
	killicon.Draw( x, y, death.icon, alpha )

	// Draw VICTIM
	draw.SimpleText( death.right,		"ScoreboardSubtitle", x + w + 16, y,		death.color3,	TEXT_ALIGN_LEFT )
	
	return (y + h*0.70)

end

function GM:DrawDeathNotice( x, y )

	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()

	x = ScrW()--x*(ScrW()-200)+200
	y = y*ScrH()
	
	// Draw
	for k, Death in pairs( Deaths ) do
 
		if (Death.time + hud_deathnotice_time > CurTime()) then
	
			if (Death.lerp) then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
		
			y = DrawDeath( x, y, Death, hud_deathnotice_time )
		
		end
	
	end
	
	// We want to maintain the order of the table so instead of removing
	// expired entries one by one we will just clear the entire table
	// once everything is expired.
	for k, Death in pairs( Deaths ) do
		if (Death.time + hud_deathnotice_time > CurTime()) then
			return
		end
	end
	
	Deaths = {}
 
end