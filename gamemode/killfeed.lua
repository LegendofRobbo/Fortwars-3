-- fortwars 3 killfeed system, created by legendofrobbo

local Gunkills = {
	"#V was ventilated by #K",
	"#V got shot up by #K",
	"#V was shot to pieces by #K",
	"#V got blasted by #K",
	"#V was capped by #K",
	"#V ate a load of #K's hot lead",
	"#V was perforated by #K",
	"#V was gunned down by #K",
	"#V couldn't beat #K to the draw",
	"#V bit #K's bullet",
}

local HSkills = {
	"#V's brains were liberated from his skull by #K",
	"#V copped #K's bullet right between the eyes",
	"#V's head was sent rolling by #K",
	"#V tried to catch #K's bullet between his teeth",
	"#V was headshotted by #K",
	"#K's bullet was the last thing that went through #V's head",
	"#V was topped off by #K",
}

local Knifekills = {
	"#V was sliced and diced by #K",
	"#V was stuck by #K",
	"#V was chopped up by #K",
	"#V's insides were turned into outsides by #K",
	"#V was given a too-short haircut by #K",
	"#V lost a game of knifey-spooney to #K",
	"#V was butchered by #K",
	"#V was stabbed in the face by #K",
	"#V was hunted down by #K",
}

local Bombkills = {
	"#V was vaporized by #K",
	"#V was blown to pieces by #K",
	"#V was roasted by #K",
	"#V was allahu ackbar'd by #K",
	"#V was splattered all over the walls by #K",
	"#V was ripped apart by #K's shrapnel",
	"#V was BBQ'd by #K",
	"#V was spontaneously combusted by #K",
	"#V was turned into a charred corpse by #K",
	"Bang! Zoom! #K sent #V straight to the moon!",
}

local Zapkills = {
	"#V was electrified by #K",
	"#V couldn't handle #K's voltage",
	"#V was energized by #K",
	"#V was shown divine power by #K",
	"#V was lit up by #K",
	"#V took #K's big black rod a bit too hard",
	"#V was levitated straight up to heaven by #K",
}

local Ballkills = {
	"#K crushed #V with the ball",
	"#K slam dunked #V with the ball",
	"#K bowled over #V with the ball",
	"#K squished #V with the ball",
	"#K punted #V with the ball",
	"#K scored a goal on #V's face with the ball",
}

local Fallkills = {
	"#V lost the fight to gravity",
	"#V left a stain on the pavement",
	"#V believed he could fly. he was wrong",
	"#V couldn't beat the laws of physics",
	"#V stood too close to the edge",
	"#V failed to reach escape velocity",
}

local Worldkills = {
	"#V was killed by unknown forces",
	"#V should have watched where he was going",
	"#V got sent back to great big special-ed class in the sky",
	"#V has returned to his people",
	"#V died mysteriously",
	"#V spontaneously vanished",
	"#V wasted his time on earth",
}

local Suicidekills = {
	"#V offed himself",
	"#V couldn't take it anymore",
	"#V an hero'd",
	"#V ate the muzzle of his own gun",
	"#V gave himself a shotgun mouthwash",
	"#V took the easy way out",
	"#V pussied out",
	"#V necked himself",
}

local BombSelfkills = {
	"#V vaporized himself",
	"#V blasted himself to pieces",
	"#V shouldn't have played with explosives",
	"#V stood too close to the bomb",
	"#V got his 72 virgins",
	"#V exploded himself",
	"#V anniholated himself",
}

if SERVER then 

util.AddNetworkString("Killfeed_Notify")

local playa = FindMetaTable("Player")
function playa:IsClass( cls )
	if !self:IsValid() or !self:IsPlayer() or !self.Class then return false end
	return Classes[self.Class].NAME == cls
end

hook.Add("GravGunPunt", "fixballkills", function(ply, ent) 
if ent:GetClass() == "ball" then ent.LastPunter = ply end
end)

hook.Add("GravGunOnPickedUp", "fixballkills2", function(ply, ent) 
if ent:GetClass() == "ball" then ent.LastPunter = ply end
end)

local function FormatKillString( str, ply, killer )
local vs = "Unkown"
local ks = "Unkown"
if ply:IsValid() then vs = ply:Nick() end
if killer:IsValid() and killer:IsPlayer() then ks = killer:Nick() end
local str1 = string.Replace( str, "#V", vs )
local str2 = string.Replace( str1, "#K", ks )

return str2

end


local function SelectKillMessage( tab, ply, killer )
local rtab, rnum = table.Random( tab )
net.Start("Killfeed_Notify")
net.WriteString( FormatKillString( rtab, ply, killer ) )
local tcol = Color(0,0,0)
if killer:IsValid() and killer:IsPlayer() and killer != ply then 
	tcol = team.GetColor(killer:Team())
end
net.WriteColor( tcol )
net.Broadcast()
end



local function Killfeed( ply, killer, dmg )
if !killer:IsValid() and dmg:IsFallDamage() then SelectKillMessage( Fallkills, ply, killer ) return elseif !killer:IsValid() then SelectKillMessage( Worldkills, ply, killer ) return end
if ply == killer then SelectKillMessage( Suicidekills, ply, killer ) return end

if dmg:GetInflictor():GetClass() == "ball" and dmg:GetInflictor().LastPunter:IsValid() then
	SelectKillMessage( Ballkills, ply, dmg:GetInflictor().LastPunter )
	return
end

if killer:IsClass( "Predator" ) and killer:GetActiveWeapon():GetClass() == "pred_gun" then 
	SelectKillMessage( Knifekills, ply, killer )
	return
end

if killer:IsClass( "Sorcerer" ) and killer:GetActiveWeapon():IsValid() and killer:GetActiveWeapon():GetClass() == "sorcerer_gun" then 
	SelectKillMessage( Zapkills, ply, killer )
	return
end

if dmg:IsBulletDamage() then 
	if ply:LastHitGroup() == 1 then SelectKillMessage( HSkills, ply, killer ) else SelectKillMessage( Gunkills, ply, killer ) end
	return
end

if dmg:IsExplosionDamage() then
	if !killer:IsPlayer() then SelectKillMessage( BombSelfkills, ply, killer ) return end
	SelectKillMessage( Bombkills, ply, killer )
	return
end

end
hook.Add("DoPlayerDeath", "killfeedhook", Killfeed )

end


if CLIENT then

surface.CreateFont( "Killfeed_Font", { font = "Trebuchet", size = 18, weight = 400, antialias = true } )

local killfeed = {}
	
net.Receive( "Killfeed_Notify", function( len )
local str, col = net.ReadString(), net.ReadColor()
table.insert( killfeed, { str, CurTime() + 8, col } )
MsgC( Color(255,255,255), "Kill: ", col, str, Color(255,255,255), "\n" )
end)

hook.Add("HUDPaint", "killfeed_drawkills", function() 
local i = 20
for k, v in pairs(killfeed) do
	surface.SetFont( "Killfeed_Font" )
	local xmin = surface.GetTextSize(v[1])
	draw.RoundedBox( 10, (ScrW() - xmin) - 30, i, xmin + 20, 25, Color(v[3].r / 2,v[3].g / 2,v[3].b / 2, (v[2] - CurTime()) * 22) )
	draw.SimpleText(v[1],"Killfeed_Font",ScrW() - 20, i + 2,Color(255,255,255, (v[2] - CurTime()) * 42.5),2,0)
	i = i + 30
	if v[2] < CurTime() then table.remove( killfeed, k ) end
end
end)



end