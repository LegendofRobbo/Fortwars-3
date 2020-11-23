
include("shared.lua")
include("spawnicon.lua")
include("killfeed.lua")
include("cl_menu.lua")
include("cl_endgame.lua")
include( "cl_deathnotice.lua" )
include( "cl_targetid.lua" )
include( "cl_scoreboard.lua" )

surface.CreateFont( "CounterShit", { font = "csd", size = 30, weight = 500, antialias = true } )

DEATHMATCH = false --Default
local statusPanel;
local holdingTeam = 0
local voteSkipPassed = false
CurrentGame = TEAMDM --Default
roundEnd = BUILD_TIME

ENDGAME = false
myClass = 1
myMoney = DEFAULT_CASH
myClasses = {}
mySkills = {}
myProps = {}
myEnergy = 100

TeamsPresent = 0
TeamInfo = TeamInfo or {}

Me = game.GetWorld()
hook.Add("InitPostEntity", "mefix", function() Me = LocalPlayer() end)

for i,v in pairs(Skills) do mySkills[i] = 0 end
for i,v in pairs(Classes) do myClasses[i] = 0 end
myClasses[1] = 1
ChatOffset = {}
ChatOffset.y = ScrH()-230

--surface.CreateFont("STOMP_Blue Highway",18,700,true,false,"VGUID1")
surface.CreateFont("VGUID1", {
								font = "STOMP_Blue Highway",
								size = 18,
								weight = 700,
								antialias = true,
								shadow = false})
--surface.CreateFont("STOMP_Blue Highway",14,700,true,false,"VGUID2")
surface.CreateFont("VGUID2", {
								font = "STOMP_Blue Highway",
								size = 14,
								weight = 700,
								antialias = true,
								shadow = false})
--surface.CreateFont("STOMP_Blue Highway",13,900,true,false,"VGUID4")
surface.CreateFont("VGUID4",{
								font = "STOMP_Blue Highway",
								size = 13,
								weight = 900,
								antialias = true,
								shadow = false})
--surface.CreateFont("STOMP_Blue Highway",13,550,true,false,"VGUID5")
surface.CreateFont("VGUID5", {
								font = "STOMP_Blue Highway",
								size = 13,
								weight = 550,
								antialias = true,
								shadow = false})
--surface.CreateFont("STOMP_Blue Highway",16,450,true,false,"VGUIR2")
surface.CreateFont("VGUIR2", {
								font = "STOMP_Blue Highway",
								size = 16,
								weight = 450,
								antialias = true,
								shadow = false})
--surface.CreateFont("STOMP_Blue Highway",46,550,true,false,"VGUIH")
surface.CreateFont("VGUIH", {
								font = "STOMP_Blue Highway",
								size = 46,
								weight = 550,
								antialias = true,
								shadow = false})
--surface.CreateFont("STOMP_Blue Highway",24,600,true,false,"VGUIH3")
surface.CreateFont("VGUIH3", {
								font = "STOMP_Blue Highway",
								size = 24,
								weight = 600,
								antialias = true,
								shadow = false})
surface.CreateFont("VGUIBG2", {
								font = "STOMP_Blue Highway",
								size = 16,
								weight = 1200,
								antialias = true,
								shadow = false})


function draw.BlackOut(x,y,width,height)
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect(x,y,width ,height)
	surface.DrawOutlinedRect(x-1,y-1,width + 2,height + 2)
	surface.DrawOutlinedRect(x+1,y+1,width - 2,height - 2)
end

usermessage.Hook("freezeCamSound",function()

surface.PlaySound('misc/freeze_cam.wav')

end)

function surface.GTW(txt,fnt)
	surface.SetFont(fnt)
	local w,h = surface.GetTextSize(txt)
	
	return w,h
end


local statusTab = {}
statusTab[0] = "Regular"
statusTab[1] = "Premium"
statusTab[2] = "Platinum"
function GM:InitPostEntity()
	RunConsoleCommand("DoneLoadingFW")
	
end

function GM:PlayerBindPress( Player, Bind, Pressed )
	if( Pressed ) then
		// Remap the menu command to the last inventry command
		if( string.find( Bind, "menu" ) ) then
			RunConsoleCommand( "lastinv" ); 
			return true;
		end
	end
end



local lenTable = {}
lenTable[2] = 0.50
lenTable[3] = 1/3
lenTable[4] = 0.25

function TW(s,f)
	local w = surface.GetTextSize(s,f)
	return w
end

function util.WordWrap(txt,font,maxl)
	local tab = string.Explode(" ",txt)
	local w = ""
	for i,v in pairs(tab) do
		local t = w.." "..v
		if TW(t,font) < maxl then
			w = t
		else
			w = w.."\n"..v
		end
	end

	return w
end



/*
function GM:HUDPaint()
	if ENDGAME or !IsValid(Me) or !TeamInfo[Me:Team()] then return end
	
	
--sniper scopes

		if Me:GetActiveWeapon():IsValid() && Me:GetActiveWeapon():GetNetworkedBool( "zoomed" ) == true then

			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 100))

			local ScopeId = surface.GetTextureID("darkland/scope/scope")
			surface.SetTexture(ScopeId)
		
			QuadTable = {}
			
			QuadTable.texture 	= ScopeId
			QuadTable.color		= Color( 0, 0, 0, 255 )
			
			QuadTable.x = 0
			QuadTable.y = 0
			QuadTable.w = ScrW()
			QuadTable.h = ScrH()	
			draw.TexturedQuad( QuadTable )

			surface.SetDrawColor( 0, 0, 0, 200)
			surface.DrawRect(ScrW() / 2 - 1, 0, 2, ScrH() )
			surface.DrawRect(0, ScrH() / 2 - 1, ScrW(), 2 )
		end
	
	
	
	self:HUDDrawTargetID()
	self:DrawDeathNotice( 0.5, 0.07 )
	
	
	draw.RoundedBox(6,10,-6,267,71+(TeamsPresent*17),Color(200,200,200,100))
	draw.RoundedBox(6,11,-6,265,70+(TeamsPresent*17),Color(10,10,10,220))
	
	draw.RoundedBox(4,16,7,256,25,Color(200,200,200,100))
	draw.RoundedBox(4,17,8,254,23,Color(10,10,10,220))
	draw.SimpleText("FortWars: Reloaded","ScoreboardSubtitle",136,20,Color(255,255,255,255),1,1)
	

	
	draw.DrawText(util.WordWrap("Capture the ball and hold it until your team's timer runs out","Default",350),"Default",136,35,Color(255,255,255,255),1,1)
	local num = 0
	for i,v in pairs(TeamInfo) do
		if v.Present then
			draw.RoundedBox(0,29,65+num*16,242,13,Color(0,0,0,255))
			draw.RoundedBox(0,30,66+num*16,240,11,team.GetColor(i))
			
			draw.RoundedBox(6,22+(DEFAULT_BALL_TIME-v.HoldTime)/DEFAULT_BALL_TIME*242,63+num*16,16,16,Color(0,0,0,255))
			draw.RoundedBox(6,23+(DEFAULT_BALL_TIME-v.HoldTime)/DEFAULT_BALL_TIME*242,64+num*16,14,14,team.GetColor(i))
			
			local font = "Default"
			if holdingTeam == i then font = "DefaultSmall" end
			draw.SimpleText(string.ToMinutesSeconds(v.HoldTime),font,136,70+num*16,Color(255,255,255,255),0,1)
		end
		num=num+1;
	end

	local y = -5
	draw.RoundedBox(4,ScrW()*0.5-55,y,110,60,Color(200,200,200,200))
	draw.RoundedBox(4,ScrW()*0.5-54,y,108,59,Color(10,10,10,240))
	
	
	local disp = string.ToMinutesSeconds(roundEnd-CurTime())
	if roundEnd-CurTime() < 0 then disp = string.ToMinutesSeconds(0) end
	draw.SimpleTextOutlined(disp,"ScoreboardSubtitle",ScrW()*0.5,y+35,Color(255,255,255,255),1,1,1,Color(0,0,0,255))	
	draw.SimpleTextOutlined("Remaining","Default",ScrW()*0.5,y+50,Color(255,255,255,255),1,1,1,Color(0,0,0,255))	
	--boxcount	
	if !DEATHMATCH  then
		draw.RoundedBox(4,ScrW()*0.5-137,ScrH()-25,275,30,Color(200,200,200,200))
		draw.RoundedBox(4,ScrW()*0.5-136,ScrH()-24,273,29,Color(10,10,10,240))
		
		draw.SimpleText("Props: "..TeamInfo[Me:Team()].BoxCount.."/"..MAX_PROPS,"Default",ScrW()*0.5-132,ScrH()-10,Color(255,255,255,255),0,1)
		draw.RoundedBox(0,ScrW()*0.5-60,ScrH()-15,180,12,Color(200,200,200,100))
		draw.RoundedBox(0,ScrW()*0.5-60,ScrH()-15,TeamInfo[Me:Team()].BoxCount/MAX_PROPS*180,12,Color(255,255,255,255))
		draw.SimpleTextOutlined("Build Mode","Default",ScrW()*0.5,y+15,Color(255,255,255,255),1,1,1,Color(0,0,0,255))	
	else
		draw.SimpleTextOutlined("Fight Mode","Default",ScrW()*0.5,y+15,Color(255,255,255,255),1,1,1,Color(0,0,0,255))	
	end

	if voteSkipPassed then
		draw.SimpleTextOutlined("Vote Skip Passed! Round Ending in: "..disp,"ScoreboardSubtitle",ScrW()*0.5,80,Color(255,255,255,255),1,1,2,Color(FluctuateColor(),0,0,255))
	end
	
	--HP and Energy
	
	local healthSkill = mySkills[2] or 0
	draw.RoundedBox(0,22,ScrH()-120,255,22,Color(50,50,50,255))
	draw.RoundedBox(0,52,ScrH()-102,Me:Health()/(Classes[myClass].HEALTH + (healthSkill * 10))*225,17,Color(170,0,0,255))
	draw.SimpleText("Health: "..Me:Health(),"Default",55,ScrH()-112,Color(255,255,255,255),0,1)
	draw.RoundedBox(8,22,ScrH()-107,30,30,Color(217,52,50,255))
	
	
	draw.RoundedBox(0,22,ScrH()-60,255,22,Color(50,50,50,255))
	draw.RoundedBox(0,52,ScrH()-42,myEnergy/(100+(mySkills[3]*5))*225,17,Color(0,3,132,255))
	draw.SimpleText("Energy: "..math.Round(myEnergy),"Default",55,ScrH()-52,Color(255,255,255,255),0,1)
	draw.RoundedBox(8,22,ScrH()-47,30,30,Color(21,68,138,255))
	



	local tr = {}
	tr.start = Me:GetShootPos()
	tr.endpos = tr.start + Me:GetAimVector()*500
	tr.filter = Me
	tr = util.TraceLine(tr)
	local ent = tr.Entity
	if ent:IsValid() && ent:GetClass() == "prop" && ent:GetNWInt("Team") == Me:Team() then
		local t = (ent:GetPos()+ent:OBBCenter()):ToScreen()
		draw.RoundedBox(0,t.x-30,t.y-4,60,8,Color(200,200,200,200))
		draw.RoundedBox(0,t.x-29,t.y-3,58,6,Color(200,0,0,255))
		local frac = ent:GetHealth()/ent:GetNWInt("MaxHP")
		draw.RoundedBox(0,t.x-29,t.y-3,frac*58,6,Color(0,200,0,255))
	end	
	

	local wep = Me:GetActiveWeapon()
	if !wep:IsValid() then return end
	local clipSize = wep:Clip1()
	if clipSize < 0 then return end

	local prim = wep.Primary
	if prim then
		
	
		
		draw.RoundedBox(0,ScrW() - 222,ScrH()-52,204,20,Color(40,40,40,230))
		draw.RoundedBox(0,ScrW() - 215+4,ScrH()-47,clipSize/prim.ClipSize*188,10,Color(200,200,200,200))
		draw.SimpleText("Ammo:","Default",ScrW()-253,ScrH()-60,Color(255,255,255,255),1,1)
		draw.SimpleText(clipSize,"ScoreboardSubtitle",ScrW()-253,ScrH()-40,Color(255,255,255,255),1,1)
	end
	

	
end
*/

local function FormatCashValue( n )
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local hp = 0
local manalerp = 0
local cashlerp = 0
local ammolerp = 0
local mat1 = Material( "icon16/heart.png" )
local mat2 = Material( "icon16/lightning.png" )
local mat3 = Material( "icon16/money_dollar.png" )
local mat4 = Material( "icon16/user.png" )
local mat5 = Material( "icon16/user_gray.png" )
local dingus = Material( "overlays/scope_lens" )
local dingus2 = Material( "sprites/scope_arc" )
function GM:HUDPaint()
	local Me = LocalPlayer()
	myEnergy = Me:GetNWInt( "fw_mana" )
--	if ENDGAME or !IsValid(Me) or !TeamInfo[Me:Team()] then return end
	hp = Lerp( FrameTime()*10, hp, Me:Health() )
	manalerp = Lerp( FrameTime()*10, manalerp, myEnergy )
	cashlerp = Lerp( FrameTime()*10, cashlerp, myMoney )

	local fixcol = team.GetColor(Me:Team())
	local fixcol2 = Color( fixcol.r, fixcol.g, fixcol.b, 150)
	local fixcol3 = Color( fixcol.r / 2, fixcol.g / 2, fixcol.b / 2, 150)

	local sh = ScrH() - 80

	local healthSkill = mySkills[2] or 0

	-- health bar
	draw.RoundedBox( 10 , 40, sh, 300, 25 ,Color(0,0,0,200))
	if hp > 1 then
	draw.RoundedBox( 10 , 45, sh + 3 , hp / (Classes[myClass].HEALTH + ( healthSkill * 10 ) ) * 290, 20 ,Color(250,0,0,150))
	draw.RoundedBox( 6 , 48, sh + 8 , hp / (Classes[myClass].HEALTH + ( healthSkill * 10 ) ) * 290 - 7, 10 ,Color(150,0,0,200))
	end
	local hptxt
	if Me:Health() < 1 then hptxt = "WASTED!" else hptxt = "Health: "..Me:Health() end
	draw.SimpleText(hptxt,"Trebuchet18", 55, sh + 13 ,Color(255,255,255,255),0,1)
	surface.SetDrawColor( 255,255,255 )
	surface.SetMaterial( mat1 )
	surface.DrawTexturedRect( 12, sh + 5, 16, 16 )


	-- mana bar
	draw.RoundedBox( 10 , 40, sh + 30, 300, 25 ,Color(0,0,0,200))
	if myEnergy > 2 then
	draw.RoundedBox( 10 , 45, sh + 33 , manalerp / (100+(mySkills[3]*5)) * 290, 20 ,Color(0,150,250,150))
	draw.RoundedBox( 6 , 48, sh + 38 , manalerp / (100+(mySkills[3]*5)) * 290 - 7, 10 ,Color(50,50,150,200))
	end
	draw.SimpleText("Mana: "..math.Round(myEnergy),"Trebuchet18", 55, sh + 43 ,Color(255,255,255,255),0,1)
	surface.SetDrawColor( 255,255,255 )
	surface.SetMaterial( mat2 )
	surface.DrawTexturedRect( 12, sh + 35, 16, 16 )


	-- prop count
	if !DEATHMATCH  then
	local props = 0
	if TeamInfo and TeamInfo[Me:Team()] and TeamInfo[Me:Team()].BoxCount then props = TeamInfo[Me:Team()].BoxCount end
	draw.RoundedBox( 10 , (ScrW() / 2) - 150, sh + 30, 300, 55 ,Color(0,0,0,200))
	draw.RoundedBox( 5 , (ScrW() / 2) - 145, sh + 55, 290, 20 ,Color(0,0,0,200))
	if props > 0 then draw.RoundedBox( 5 , (ScrW() / 2) - 145, sh + 55, props / MAX_PROPS * 290, 20 ,fixcol3) end

	draw.SimpleText("Team prop count","Trebuchet18", ScrW() * 0.5 - 132,sh + 42, Color(255,255,255,255), 0, 1)
	draw.SimpleText(props.."/"..MAX_PROPS,"Trebuchet18",ScrW()*0.5-132,sh + 66,Color(255,255,255,255),0,1)

	end


	draw.RoundedBox(10,5,30, 285,(30 * #TeamInfo) + 2,Color(0,0,0,100))
	-- ball hold times
	local inum = 0
	for i,v in pairs(TeamInfo) do
		if v.Present then
			local tc = team.GetColor(i)
			local tc2 = Color( tc.r / 1.5 , tc.g / 1.5, tc.b / 1.5, 100)
			local tc3 = Color( tc.r , tc.g, tc.b, 150)
			local frac = (DEFAULT_BALL_TIME-v.HoldTime)/DEFAULT_BALL_TIME
			draw.RoundedBox(10,35,34 + inum * 30,250,24,Color(0,0,0,150))
			if frac > 0.045 then
			draw.RoundedBox(10,40,36 + inum * 30, frac * 240,20,tc3)
			draw.RoundedBox(4,45,41 + inum * 30,(frac * 240) - 10,10,tc2)
			end

			surface.SetDrawColor( team.GetColor(i) )
			surface.SetMaterial( mat5 )
			surface.DrawTexturedRect( 12, 36 + inum * 30, 16, 16 )
			
--			draw.RoundedBox( 10 , 45, 65+tonumber(inum)*16, 20 ,Color(0,150,250,150))
--			draw.RoundedBox( 6 , 48, 66 + tonumber(inum)*16, 10 ,Color(50,50,150,200))
			--draw.RoundedBox(6,22+(DEFAULT_BALL_TIME-v.HoldTime)/DEFAULT_BALL_TIME*242,63+num*16,16,16,Color(0,0,0,255))
			--draw.RoundedBox(6,23+(DEFAULT_BALL_TIME-v.HoldTime)/DEFAULT_BALL_TIME*242,64+num*16,14,14,team.GetColor(i))
			
			local font = "Default"
			if holdingTeam == i then font = "DefaultSmall" end
			local stupidvariablename = Color(255,255,255)
			if i == Me:Team() then stupidvariablename = Color(100,255,100) end
			draw.SimpleTextOutlined(string.ToMinutesSeconds(v.HoldTime),font,50,46 + inum * 30,stupidvariablename,0,1, 1, Color(50,50,50,200))
		end
		inum=inum+1;
	end

	self:HUDDrawTargetID()

	-- round info

	draw.RoundedBox( 10 , ScrW() / 2 - 125, -5, 250, 65 ,Color(0,0,0,200))
--	draw.RoundedBox(4,ScrW()*0.5-54,y,108,59,Color(10,10,10,240))
--	draw.RoundedBox(4,ScrW()*0.5-55,y,110,60,Color(200,200,200,200))
	
	
	local disp = string.ToMinutesSeconds(roundEnd-CurTime())
	if roundEnd-CurTime() < 0 then disp = string.ToMinutesSeconds(0) end
	draw.SimpleTextOutlined("Time remaining: "..disp,"Trebuchet18",ScrW()*0.5,40,Color(255,255,255,255),1,1,1,Color(0,0,0,255))	
	if !DEATHMATCH  then 
		draw.SimpleTextOutlined("Build Mode","Trebuchet24",ScrW()*0.5,16,Color(55,255,55,255),1,1,1,Color(0,50,0,255))
	else
		draw.SimpleTextOutlined("Fight Mode","Trebuchet24",ScrW()*0.5,16,Color(255,255,55,255),1,1,1,Color(50,50,0,255))
	end
--	draw.SimpleTextOutlined("Remaining","Trebuchet18",ScrW()*0.5,y+50,Color(255,255,255,255),1,1,1,Color(0,0,0,255))	

	if voteSkipPassed then
		local red = math.abs(math.sin(CurTime() * 5) * 255)
		local rcol = Color( 255, red, red )
		draw.SimpleTextOutlined("Vote Skip Passed! Round Ending in: "..disp,"ScoreboardSubtitle",ScrW()*0.5,80,rcol,1,1,2,Color(0,0,0,255))
	end


	-- user info
	draw.RoundedBox( 10 , 40, sh - 30, 300, 25 ,Color(0,0,0,200))
	draw.RoundedBox( 5 , 45, sh - 24, 290, 14 ,fixcol3)

	local txt = "Regular"
	if Me:IsPlatinum() then txt = "Platinum" elseif Me:IsPremium() then txt = "Premium" end

	draw.SimpleText("Class: "..Classes[myClass].NAME.." - Status: "..txt.." - $"..FormatCashValue( math.ceil(cashlerp) ),"Trebuchet18", 55, sh - 18 ,Color(255,255,255),0,1)
	surface.SetDrawColor( 255,255,255 )
	surface.SetMaterial( mat4 )
	surface.DrawTexturedRect( 12, sh - 25, 16, 16 )



	local tr = {}
	tr.start = Me:GetShootPos()
	tr.endpos = tr.start + Me:GetAimVector()*500
	tr.filter = Me
	tr = util.TraceLine(tr)
	local ent = tr.Entity
	if ent:IsValid() && ent:GetClass() == "prop" && ent:GetNWInt("Team") == Me:Team() then
		local t = (ent:GetPos()+ent:OBBCenter()):ToScreen()
		draw.RoundedBox(0,t.x-30,t.y-4,60,8,Color(200,200,200,200))
		draw.RoundedBox(0,t.x-29,t.y-3,58,6,Color(200,0,0,255))
		local frac = ent:GetHealth()/ent:GetNWInt("MaxHP")
		draw.RoundedBox(0,t.x-29,t.y-3,frac*58,6,Color(0,200,0,255))
	end	


	-- gun info
	local wep = Me:GetActiveWeapon()
	if !wep:IsValid() then return end
	local clipSize = wep:Clip1()
	if clipSize < 0 then return end

	local prim = wep.Primary
	if prim then
		
		ammolerp = Lerp( FrameTime()*12, ammolerp, clipSize )
		
		draw.RoundedBox( 10 , ScrW() - 360, sh + 30, 300, 25 ,Color(0,0,0,200))
		if clipSize > 0 then
		draw.RoundedBox( 10 , ScrW() - 355, sh + 32, ammolerp / prim.ClipSize * 290, 20 ,Color(150,100,0,200))
		draw.RoundedBox( 6 , ScrW() - 350, sh + 37, ammolerp / prim.ClipSize * 290 - 10, 10 ,Color(200,150,0,200))
		end
		draw.SimpleText("Ammo: "..clipSize,"Trebuchet18", ScrW() - 430, sh + 43 ,Color(255,255,255,255),0,1)
		if Classes[myClass].LEVELS > 1 and myClasses[myClass] > 1 and Classes[myClass].ABILITY != "" then draw.SimpleTextOutlined("Ability: "..Classes[myClass].ABILITY,"Trebuchet18", ScrW() - 430, sh + 15 ,Color(255,195,55,255),0,1, 2, Color(0,0,0)) 
		else
		draw.SimpleTextOutlined("Ability: Locked","Trebuchet18", ScrW() - 430, sh + 15 ,Color(55,55,55,255),0,1, 2, Color(0,0,0))
		end

--		draw.RoundedBox(0,ScrW() - 222,ScrH()-52,204,20,Color(40,40,40,230))
--		draw.RoundedBox(0,ScrW() - 215+4,ScrH()-47,clipSize/prim.ClipSize*188,10,Color(200,200,200,200))
--		draw.SimpleText("Ammo:","Default",ScrW()-253,ScrH()-60,Color(255,255,255,255),1,1)
--		draw.SimpleText(clipSize,"ScoreboardSubtitle",ScrW()-253,ScrH()-40,Color(255,255,255,255),1,1)
	end


	-- sniper scopes
		if Me:GetActiveWeapon():IsValid() && Me:GetActiveWeapon():GetNetworkedBool( "zoomed" ) == true then
		local hitpos = util.TraceLine ({
			start = LocalPlayer():GetShootPos(),
			endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 4096,
			filter = LocalPlayer(),
			mask = MASK_SHOT
		}).HitPos
			local screenpos = hitpos:ToScreen()
			local screenw = ScrW()
			local screenh = ScrH()
		local x = screenpos.x
	local y = screenpos.y
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawLine( x, 0, x, screenh )
		surface.DrawLine( 0, y, screenw, y )
		surface.SetMaterial( dingus )
		surface.DrawTexturedRect( 0, 0, screenw, screenh )
		surface.SetMaterial( dingus2 )
		surface.DrawTexturedRectRotated( x + 300, y + 300, 600, 600, 0 )
		surface.DrawTexturedRectRotated( x + 300, y - 300, 600, 600, 90 )
		surface.DrawTexturedRectRotated( x - 300, y - 300, 600, 600, 180 )
		surface.DrawTexturedRectRotated( x - 300, y + 300, 600, 600, 270 )
		surface.DrawRect( x + 595, 0, screenw - (x + 595), screenh)
		surface.DrawRect( 0, 0, x - 595, screenh)
		end

	for k, v in pairs(player.GetAll()) do
    	if !v:IsValid() or v == LocalPlayer() or !v:GetNWBool("tagshotted", false ) or !v:Alive() then continue end
    	local ppos = v:LocalToWorld( v:OBBCenter() ):ToScreen()
    	local tc = team.GetColor( v:Team() )
    	draw.SimpleTextOutlined( "C", "CounterShit", ppos.x - 3, ppos.y, tc, 1, 1, 1, Color(0,0,0,155) )
    	draw.SimpleTextOutlined( v:Nick(), "Trebuchet18", ppos.x, ppos.y - 25, tc, 1, 1, 1, Color(0,0,0,155) )
 --   	draw.SimpleText( v:Nick(), "Trebuchet18", ppos.x, ppos.y, tc, 1 )
    end


end
  
function GM:AdjustMouseSensitivity()
	if LocalPlayer():GetActiveWeapon():IsValid() && LocalPlayer():GetActiveWeapon():GetNetworkedBool( "zoomed" ) == true then return 0.4 else return 1 end
end


function ReloadedTimer()
	if TeamInfo[holdingTeam] then
		TeamInfo[holdingTeam].HoldTime = TeamInfo[holdingTeam].HoldTime - 1;
	end
end
timer.Create("ballTimer",1,0,ReloadedTimer)



function GM:PhysgunPickup(ply,ent)
	return ent:GetClass() == "prop_physics"
end

local goneParts = {"CHudHealth","CHudAmmo", "CHudDeathNotice"}
function GM:HUDShouldDraw(name)
	return !table.HasValue(goneParts,name)
end


local function GetRoundTime( um )
	roundEnd = um:ReadLong()
end
usermessage.Hook("setRoundTime",GetRoundTime)



local function GetBoxCount( um )
	TeamInfo[Me:Team()].BoxCount = um:ReadChar()
end
usermessage.Hook("boxCount",GetBoxCount)
/*
local function getClasses( um )
	local str = um:ReadString()
	--print(sepcount, "INDEX3")
	local t = string.Explode("|",str)
	for i,v in pairs(t) do
		myClasses[tonumber(v)] = true
	end
end
usermessage.Hook("getClasses",getClasses)
*/

net.Receive( "SendClasses", function( len ) 
local tab = net.ReadTable()
for i,v in pairs(tab) do
	myClasses[i] = v
end
end)

net.Receive( "SendProps", function( len ) 
local tab = net.ReadTable()
for i,v in pairs(tab) do
	myProps[i] = v
end
end)

local function getSkills( um )
	local t = string.Explode("",um:ReadString())
	for i,v in pairs(t) do
		mySkills[i] = tonumber(v)
	end
end
usermessage.Hook("getSkills",getSkills)
/*
local function getEnergy( um )
	myEnergy = um:ReadChar()
end
usermessage.Hook("setEnergy",getEnergy)

timer.Create("EnergyUpdate",0.05,0,
function()
		myEnergy = math.Clamp(myEnergy + (BASE_ENERGY_REGEN+mySkills[4])*0.05,0,100+(mySkills[3]*5))
end
)
*/

local function getSkill( um )
	mySkills[um:ReadChar()] = um:ReadChar()
end
usermessage.Hook("getSkill",getSkill)

usermessage.Hook("initFW",function( um )
	roundEnd = um:ReadLong()
	
	local index = um:ReadChar()
	while(index != 0) do
		TeamInfo[index] = {
			Present = true,
			BoxCount = 0
		}
		TeamsPresent = TeamsPresent + 1
		index = um:ReadChar()
	end
end)
	
function NewHolder( um )
	holdingTeam = um:ReadChar()
end
usermessage.Hook("newHolder",NewHolder)

function GetTimes( um )
	local tbl = string.Explode("|",um:ReadString())
	TeamInfo[tonumber(tbl[1])].HoldTime = tonumber(tbl[2]);
end
usermessage.Hook("getHoldTimes",GetTimes)	
	
function getClass( um )
	myClass = um:ReadChar()
--	statusPanel:UpdateClass()
end
usermessage.Hook("currentClass",getClass)
function getRound( um )
	local Me = LocalPlayer()
	Me:GetViewModel():SetColor(Color(255,255,255))
	voteSkipPassed = false
	if um:ReadBool() then DEATHMATCH = true return end
	DEATHMATCH = false
	
end
usermessage.Hook("getRound",getRound)
	
function getMoney( um )
	myMoney = um:ReadLong()
end
usermessage.Hook("getMoney",getMoney)
function voteSkipPassed()

	roundEnd = CurTime() + 10
	voteSkipPassed = true
	local obj = CreateSound(Me,"ambient/alarms/alarm_citizen_loop1.wav")
	obj:Play()
	--timer.Simple(6,obj.Stop,obj)
	timer.Simple(6,function() obj:Stop() end)
end
usermessage.Hook("voteskipPassed",voteSkipPassed)

local meta = FindMetaTable("Player")
function meta:GetMana()
	return LocalPlayer():GetNWInt( "fw_mana" )
end
function meta:GetMoney()
	return myMoney
end
/*

local PANEL = {}

function PANEL:Init()
	self.mPan = vgui.Create("DModelPanel",self)
	self.mPan:SetSize(60,60)
	self.mPan:SetLookAt(Vector(0,0,50))
	self.mPan:SetCamPos(Vector(0,40,45))
	self:UpdateClass()
end
function PANEL:UpdateClass()
	self.mPan:SetModel(Classes[myClass].MODEL)
end

function PANEL:Paint()
	--if !IsValid(Me) then return end
	if !IsValid(Me) then return end
	local c = team.GetColor(Me:Team())
	draw.RoundedBox(8,0,10,self:GetWide(),self:GetTall()-10,Color(c.r,c.g,c.b,200))
	draw.SimpleText("Class: "..Classes[myClass].NAME,"Default",self:GetWide()*0.5,20,Color(255,255,255,255),1,1)
	local txt = "Regular"
	if Me:IsPlatinum() then txt = "Platinum" elseif Me:IsPremium() then txt = "Premium" end
	draw.SimpleText("Status: "..txt,"Default",self:GetWide()*0.5,35,Color(255,255,255,255),1,1)
	draw.SimpleText("$"..myMoney,"Default",self:GetWide()*0.5,50,Color(255,255,255,255),1,1)
	
end
vgui.Register("Status",PANEL,"DPanel")
statusPanel = vgui.Create("Status")
statusPanel:SetSize(185,60)
statusPanel:SetPos(22,ScrH()-200)
*/