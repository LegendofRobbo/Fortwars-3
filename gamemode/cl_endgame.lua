local endMenu;
local maps = {}
function gameOver( um )
	ENDGAME = um:ReadChar()
	CreateEndGame()
	for i,v in pairs(hook.GetTable()["HUDPaint"]) do hook.Remove("HUDPaint",i) end
	--re-add the chat
	hook.Add("HUDPaint","DrawChat",ChatPaint)
end
usermessage.Hook("gameOver",gameOver)

function getMapVote( um )
	local int = um:ReadChar()
	local b = endMenu.buttons[maps[int]]
	b.numVotes = b.numVotes + um:ReadChar()
	b:SetText(mapList[int][1].." - "..b.numVotes)
end
usermessage.Hook("getMapVote",getMapVote)

function getEndVar(um)

	endMenu:AddEndVar(um:ReadChar(),player.GetByID(um:ReadChar()),um:ReadString())

end
usermessage.Hook("getEndVar",getEndVar)

local PANEL = {}

function PANEL:Init()
	self.winner = ENDGAME;
	self:SetSize(640,480)
	self:Center()
	self.list = vgui.Create("DPanelList",self)
	self.list:StretchToParent(5,100,5,100)
	self.list:EnableHorizontal(true)
	self.list.Paint = function() draw.RoundedBox(0,0,0,self.list:GetWide(),self.list:GetTall(),Color(0,0,0,255)) end
	gui.EnableScreenClicker(true)
end
function PANEL:Paint()
	draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,250))
	draw.RoundedBox(10,5,5,self:GetWide()-10,self:GetTall()-10,team.GetColor(self.winner))
	local disp = math.floor(roundEnd-CurTime())
	if disp < 1 then disp = "Changing Map..." end
	draw.SimpleTextOutlined(disp,"ScoreboardHeader",self:GetWide()*0.5,self:GetTall()-60,Color(255,255,255,255),1,1,2,Color(0,0,0,255))
	draw.SimpleTextOutlined(team.GetName(self.winner).." has won the game!","ScoreboardHeader2",self:GetWide()*0.5,30,Color(255,255,255,255),1,1,2,Color(0,0,0,255))
	
	draw.RoundedBox(0,0,70,self:GetWide(),100,Color(0,0,0,250))
	draw.SimpleText("This Round...","ScoreboardSubtitle",10,85,team.GetColor(self.winner),0,1)
	
	
end

function PANEL:AddEndVar(id,pl,data)

	local p = vgui.Create("DPanel")
	p:SetSize(self.list:GetWide()/3,self.list:GetTall()/4)
	p.lbl = Label(EndGameStats[id].Text(pl,data),p)
	p.lbl:SetPos(64,5)
	p.lbl:SetTextColor(Color(0,0,0,255))
	p.lbl:SetWrap(true)
	p.lbl:SetSize(p:GetWide()-80,p:GetTall()-10)
	self.list:AddItem(p)


end
vgui.Register("EndGameMenu",PANEL,"DPanel")



function CreateEndGame()
	if ValidPanel(statusPanel) then
		statusPanel:Remove()
	end
	endMenu = vgui.Create("EndGameMenu")
	if IS_CHRISTMAS then surface.PlaySound(CHRISTMAS_SONG) return end
	surface.PlaySound(WIN_SONG)
end


local function GetMaps( um )
	endMenu.buttons = {}
	local wide = (endMenu:GetWide()-10) / math.min(5,table.getn(mapList))
	for i=1,math.min(5,table.getn(mapList)) do
		local int = um:ReadChar()
		maps[int] = i
		local b = vgui.Create("DVoteButton",endMenu)
		b:SetSize(wide,30)
		b:SetPos(5+(i-1)*wide,endMenu:GetTall()-40)
		b:SetTextColor(Color(250,150,250))
		
		b.mapType = maps[i]
		b.numVotes = 0
		b.DoClick = function() RunConsoleCommand("mapVote",int) end
		b:SetText(mapList[int][1].." - "..b.numVotes)
		table.insert(endMenu.buttons,b)
	end
	
end
usermessage.Hook("getMaps",GetMaps)

local PANEL = {}
function PANEL:Paint()
	draw.RoundedBox(2,0,0,self:GetWide(),self:GetTall(),team.GetColor(self:GetParent().winner))
	draw.RoundedBox(2,1,1,self:GetWide()-2,self:GetTall()-2,Color(0,0,0,250))
end
vgui.Register("DVoteButton",PANEL,"DButton")