	


--surface.CreateFont( "Impact", 32, 500, true, false, "ScoreboardHeader" )
surface.CreateFont( "ScoreboardHeader", {
								font = "Impact",
								size = 82,
								weight = 500,
								antialias = true,
								shadow = false} )

surface.CreateFont( "ScoreboardHeader2", {
								font = "Impact",
								size = 52,
								weight = 500,
								antialias = true,
								shadow = false} )

--surface.CreateFont( "coolvetica", 22, 500, true, false, "ScoreboardSubtitle" )
surface.CreateFont( "ScoreboardSubtitle", {
									font = "coolvetica",
									size = 20,
									weight = 500,
									antialias = true,
									shadow = false})

surface.CreateFont( "ScoreboardSubtitle2", {
									font = "coolvetica",
									size = 18,
									weight = 500,
									antialias = true,
									shadow = false})

local PANEL = {}

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
	self:SetWide(640)
	self:SetTall(ScrH()*0.95)
	self:Center()
end


function PANEL:Paint()
	
	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 10,10,10, 235 ) )
	--draw.RoundedBox( 0, 0, 0, self:GetWide(), 160, Color( 50,50,50, 205 ) )
	draw.BlackOut(1, 1, self:GetWide()-2, self:GetTall()-2) 
		

	draw.SimpleTextOutlined( GAMEMODE.Name ,"ScoreboardHeader",self:GetWide()*0.5, 50,Color(200,0,0,255),1,1, 2, Color( 55, 0, 0, 255) )
	draw.SimpleText( "Originally coded by Darkspider and Balrog" ,"ScoreboardSubtitle",self:GetWide()*0.5, 90,Color(150,150,150,255),1,1 )
	draw.SimpleText( "Duct-taped back together by LegendofRobbo" ,"ScoreboardSubtitle",self:GetWide()*0.5, 110,Color(150,150,150,255),1,1 )

	local w,h = surface.GTW("Ping","DefaultSmall")
	local tall = 160
	draw.SimpleText("Ping","Default", self:GetWide() - 50 - w*.5,tall )
	draw.SimpleText("Deaths","Default", self:GetWide() - 50*2 - w*.5, tall )
	draw.SimpleText("Assists","Default", self:GetWide() - 50*3 - w*.5, tall )
	draw.SimpleText("Kills","Default", self:GetWide() - 50*4 - w*.5, tall )
	
	for i,v in pairs(TeamInfo) do	
		local tbl = team.GetPlayers(i)
		table.sort(tbl,function(a,b)return a:Frags() > b:Frags() end)
		for _,ply in pairs(tbl) do
		tall = tall + 13
			draw.RoundedBox(1,2,tall,self:GetWide()-4,12,team.GetColor(i))
			draw.SimpleText(ply:Name(),"DefaultSmall", 4,tall )
			draw.SimpleText(ply:Deaths(),"DefaultSmall", self:GetWide() - 50*2 - w*.5, tall )
			draw.SimpleText(ply:GetNWInt("Assists"),"DefaultSmall", self:GetWide() - 50*3 - w*.5, tall )
			draw.SimpleText(ply:Frags(),"DefaultSmall", self:GetWide() - 50*4 - w*.5, tall )
			draw.SimpleText(ply:Ping(),"DefaultSmall", self:GetWide() - 50 - w*.5,tall )
			
		end
	end
	return true
end
vgui.Register( "ScoreBoard", PANEL, "DPanel" )