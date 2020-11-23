local PANEL = {}

local memberships = {}
memberships[1] = {
1,
1,
"PermaBan",
"No",
KILL_MONEY .."$",
"No",
"No",
"N/A"
} 
memberships[2] = {
2,
2,
"7 Days",
"Yes",
KILL_MONEY*2 .."$", 
"No",
"No",
"$5 USD"
}
memberships[3] = {
4,
4,
"4 Days",
"Yes",
KILL_MONEY*5 .."$",
"Yes",
"Yes",
"$15 USD"
}
local m_name = {"Regular","Premium","Platinum"}
local m_desc = {"Voteskips","Votemaps","Max Ban","AFK Immunity","Money per kill","Fly in build","Reserved Slots","Donation Needed"}
local dollas = "You can also donate $1 and receive $20,000 Darkland Cash for each $1 USD you donate."


function PANEL:Init()
	if !Me or !Me:IsValid() then Me = LocalPlayer() end

	self:SetSize(750,425)
	
	self.tabNames = {"Help","Classes","Upgrades","Donations"}
	self.selectedClass = 1
	self.selectedSkill = 1
	--Hold all the items in a 1D table and loop to set visibility to false/true...
	self.dispItems = {}
	
	
	self.currentTab = 1
	
	
	local oldButt
	for i,v in pairs(self.tabNames) do
		local button = vgui.Create("Button",self)
		local xPos = 10
		if oldButt then xPos = oldButt:GetPos()+oldButt:GetWide()+80 end
		button:SetPos(xPos,75)
		button.col = Color(255,255,255,255)
		button:SetText("")
		button.Paint = function() 
		local col = color_white
		if self.currentTab == i then col = Color(100,100,100,255) end
		
		draw.SimpleText(v,"ScoreboardSubtitle2",button:GetWide()*0.5,button:GetTall()*0.5,col,1,1) 
		end
		surface.SetFont("ScoreboardSubtitle2")
		local x,h = surface.GetTextSize(v)
		button:SetSize(x,h)
		button.OnMousePressed = function() self.currentTab = i self:RefreshTabs() end
		button:SetCursor("hand")
		oldButt = button
	end
	local close = vgui.Create("Button",self)
	close:SetPos(575,75)
	close:SetSize(154,30)
	close:SetText("")
	close.Paint = function()
		local vData = {}
		vData[1] = {}
		vData[1].x = 19
		vData[1].y = 0
		
		vData[2] = {}
		vData[2].x = 154
		vData[2].y = 0
		
		vData[3] = {}
		vData[3].x = 154
		vData[3].y = 30
		
		vData[4] = {}
		vData[4].x = 0
		vData[4].y = 30
		local col = team.GetColor(Me:Team())
		local amt = 90
		if close.Hovered then amt = 110 end
		surface.SetDrawColor(math.Clamp(amt+col.r,0,255),math.Clamp(amt+col.g,0,255),math.Clamp(amt+col.b,0,255),100)
		surface.DrawPoly(vData)
		draw.SimpleText("Close","ScoreboardSubtitle2",close:GetWide()*0.5,close:GetTall()*0.5,Color(255,255,255,255),1,1)
	end
	close.DoClick = function() self:SetVisible(false) RememberCursorPosition() gui.EnableScreenClicker(false) end
	
	--HELP TAB
	local helpPanel = vgui.Create("DPanel",self)
	helpPanel.tab = 1
	helpPanel:StretchToParent(20,125,20,20)
	helpPanel.Paint = function()
		local col = team.GetColor(Me:Team())
		draw.RoundedBox(2,0,0,helpPanel:GetWide(),helpPanel:GetTall(),Color(math.Clamp(90+col.r,0,255),math.Clamp(90+col.g,0,255),math.Clamp(90+col.b,0,255),100))
		
		draw.SimpleText("How do I play?","ScoreboardSubtitle2",10,10,Color(255,255,255,255),0,3)
		draw.DrawText([[To win, you must grab the ball that spawns when fight mode starts.
	Other teams will be fighting for it as well. A good strategy is to build a strong defensive base and get the ball into it as
	soon as you can. All you have to do is hold the ball until the needed time runs out. You can view the time needed on
	the handy dandy HUD up in the top left.]],"Default",10,50,Color(255,255,255,255),0)
		
		
	end
	table.insert(self.dispItems,helpPanel)
	
	
	local classesList = vgui.Create("DPanelList",self)
	classesList:StretchToParent(20,125,nil,20)
	classesList.tab = 2
	classesList:SetSpacing(2)
	classesList:SetWide(250)
	classesList:EnableVerticalScrollbar()
	for i,v in pairs(Classes) do
		local p = vgui.Create("Panel")
		p.OnCursorEntered = function() p.Hovered = true end
		p.OnCursorExited = function() p.Hovered = false end
		p.OnMousePressed = function() if self.selectedClass == i then if myClasses[self.selectedClass] > 0 then RunConsoleCommand("chooseclass",self.selectedClass) end else self.selectedClass = i end end
		p:SetTall(30)
		p.Paint = function()
			local amt = 90
			if p.Hovered then amt = amt + 30 end
			if i == self.selectedClass then amt = 60 end
			if myClasses[i] < 1 then amt = 180 end
			local col = team.GetColor(Me:Team())
			draw.RoundedBox(4,0,0,p:GetWide(),p:GetTall(),Color(math.Clamp(amt+col.r,0,255),math.Clamp(amt+col.g,0,255),math.Clamp(amt+col.b,0,255),255))
			local nametext = v.NAME
			if v.LEVELS > 1 then nametext = nametext.." ( ".. myClasses[i].." / "..tonumber(v.LEVELS).." )" end
			draw.SimpleTextOutlined(nametext,"ScoreboardSubtitle2",p:GetWide()*0.5,p:GetTall()*0.5,Color(255,255,255,255),1,1,1,Color(0,0,0,255))
		end
		classesList:AddItem(p)
	end
	table.insert(self.dispItems,classesList)
	
	local classPanel = vgui.Create("DPanel",self)
	classPanel:StretchToParent(280,125,20,60)
	classPanel.tab = 2
	classPanel.Paint = function()
		local tbl = Classes[self.selectedClass]
		draw.RoundedBox(0,0,0,classPanel:GetWide(),classPanel:GetTall(),Color(50,50,50,200))
		draw.SimpleText(tbl.NAME,"ScoreboardHeader2",classPanel:GetWide()*0.5,20,Color(0,0,0,255),1,1)
		--draw.DrawText(util.WordWrap("About this class: "..tbl.DESCRIPTION,"Default",1200),"Default",10,60,Color(255,255,255,255),0,1)
		draw.DrawText(util.WordWrap("About this class: "..tbl.DESCRIPTION,"Default",650),"Default",10,60,Color(255,255,255,255),0,1)
		draw.SimpleText("Speed:\t\t"..tbl.SPEED,"ScoreboardSubtitle2",5,170,Color(255,255,255,255),0,1)
		draw.SimpleText("Health:\t\t"..tbl.HEALTH,"ScoreboardSubtitle2",5,190,Color(255,255,255,255),0,1)
		local col = Color(255,0,0,255)
		if myMoney >= tbl.COST then col = Color(0,255,0,255) end
		local cost = "Price:\t\t\t"..tbl.COST
		if Classes[self.selectedClass].LEVELS > 1 and myClasses[self.selectedClass] < Classes[self.selectedClass].LEVELS and myClasses[self.selectedClass] > 0 then cost = "Upgrade Cost:\t"..(tbl.COST / 2) end
		if self.selectedClass == 1 then cost = "Upgrade Cost:\t10000" end
		if myClasses[self.selectedClass] == Classes[self.selectedClass].LEVELS then cost = "Already Owned" col = Color(155,155,155,255) end
		draw.SimpleText(cost,"ScoreboardSubtitle2",5,210,col,0,1)
		if tbl.ABILITY != "" then draw.SimpleText("Upgrade: ","ScoreboardSubtitle2",5,230,Color(255,255,255),0,1) draw.SimpleText(tbl.ABILITY,"ScoreboardSubtitle2",65,230,Color(255,155,0),0,1)  end
	end
	local model = vgui.Create("DModelPanel",classPanel)
	model:StretchToParent(classPanel:GetWide()-classPanel:GetTall(),0,0,0)
	model.currModel = self.selectedClass
	model:SetCamPos(Vector(75,-20,35))
	model:SetLookAt(Vector(0,-20,35))
	
	model:SetModel(Classes[1].MODEL)
	model.Think = function() 
		if model.currModel != self.selectedClass then 
			model:SetModel(Classes[self.selectedClass].MODEL)
			model.currModel = self.selectedClass 
		end
	end
	table.insert(self.dispItems,classPanel)
	
	
	local chooseclass = vgui.Create("Button",self)
	chooseclass:StretchToParent(280,self:GetTall()-50,250,20)
	chooseclass:SetText("")
	chooseclass.Paint = function()
		local col = team.GetColor(Me:Team())
		local amt = 90
		if chooseclass.Hovered then amt = 110 end
		
		draw.RoundedBox(2,0,0,chooseclass:GetWide(),chooseclass:GetTall(),Color(math.Clamp(amt+col.r,0,255),math.Clamp(amt+col.g,0,255),math.Clamp(amt+col.b,0,255),100))
		local txt = "Not Owned"
		if myClasses[self.selectedClass] > 0 then txt = "Select" end
		draw.SimpleText(txt,"ScoreboardSubtitle2",chooseclass:GetWide()*0.5,chooseclass:GetTall()*0.5,Color(255,255,255,255),1,1)
	end
	chooseclass.DoClick = function() RunConsoleCommand("chooseclass",self.selectedClass)  end
	chooseclass.tab = 2
	table.insert(self.dispItems,chooseclass)

	local buyclass = vgui.Create("Button",self)
	buyclass:StretchToParent(510,self:GetTall()-50,20,20)
	buyclass:SetText("")
	buyclass.Paint = function()
		local col = team.GetColor(Me:Team())
		local amt = 90
		if buyclass.Hovered then amt = 110 end
		
		draw.RoundedBox(2,0,0,buyclass:GetWide(),buyclass:GetTall(),Color(math.Clamp(amt+col.r,0,255),math.Clamp(amt+col.g,0,255),math.Clamp(amt+col.b,0,255),100))
		local txt = "Buy"
		if Classes[self.selectedClass].LEVELS > 1 and myClasses[self.selectedClass] < Classes[self.selectedClass].LEVELS and myClasses[self.selectedClass] > 0 then txt = "Upgrade" end
		if myClasses[self.selectedClass] == Classes[self.selectedClass].LEVELS then txt = "Already Owned" end
		draw.SimpleText(txt,"ScoreboardSubtitle2",buyclass:GetWide()*0.5,buyclass:GetTall()*0.5,Color(255,255,255,255),1,1)
	end
	buyclass.DoClick = function() RunConsoleCommand("buyclass",self.selectedClass)  end
	buyclass.tab = 2
	table.insert(self.dispItems,buyclass)
	
	
	local skillList = vgui.Create("DPanelList",self)
	skillList:StretchToParent(20,125,nil,20)
	skillList.tab = 3
	skillList:SetSpacing(2)
	skillList:SetWide(250)
	skillList:EnableVerticalScrollbar()
	for i,v in pairs(Skills) do
		local p = vgui.Create("Panel")
		p.OnCursorEntered = function() p.Hovered = true end
		p.OnCursorExited = function() p.Hovered = false end
		p.OnMousePressed = function() if i == 5 then RunConsoleCommand("fw_buyprops" ) else self.selectedSkill = i end end
		p:SetTall(30)
		p.Paint = function()
			local amt = 90
			if p.Hovered then amt = 110 end
			if i == self.selectedSkill then amt = 60 end
			local col = team.GetColor(Me:Team())
			draw.RoundedBox(4,0,0,p:GetWide(),p:GetTall(),Color(math.Clamp(amt+col.r,0,255),math.Clamp(amt+col.g,0,255),math.Clamp(amt+col.b,0,255),255))
			draw.SimpleTextOutlined(v.NAME,"ScoreboardSubtitle2",p:GetWide()*0.5,p:GetTall()*0.5,Color(255,255,255,255),1,1,1,Color(0,0,0,255))

		end
		skillList:AddItem(p)
	end

	table.insert(self.dispItems,skillList)
	
	local skillPanel = vgui.Create("DPanel",self)
	skillPanel:StretchToParent(280,125,20,60)
	skillPanel.tab = 3
	skillPanel.Paint = function()
		local tbl = Skills[self.selectedSkill]
		draw.RoundedBox(0,0,0,skillPanel:GetWide(),skillPanel:GetTall(),Color(50,50,50,200))
		draw.SimpleText(tbl.NAME,"ScoreboardHeader2",skillPanel:GetWide()*0.5,20,Color(0,0,0,255),1,1)
			local tbl = Skills[self.selectedSkill]
			draw.DrawText(util.WordWrap("About this skill: "..tbl.DESCRIPTION,"Default",1200),"Default",10,60,Color(255,255,255,255),0,1)
			local col = Color(255,0,0,255)
			if myMoney >= tbl.COST*(mySkills[self.selectedSkill]+1) then col = Color(0,255,0,255) end
			draw.SimpleText("Price:\t\t\t"..tbl.COST*(mySkills[self.selectedSkill]+1),"ScoreboardSubtitle2",10,190,col,0,1)
	end
	table.insert(self.dispItems,skillPanel)
	
	local chooseskill = vgui.Create("Button",self)
	chooseskill:StretchToParent(280,self:GetTall()-50,20,20)
	chooseskill:SetText("")
	chooseskill.Paint = function()
		local txt = "Upgrade"
		if mySkills[self.selectedSkill] > 4 then return end
		
		local col = team.GetColor(Me:Team())
		local amt = 90
		if chooseskill.Hovered then amt = 110 end

		draw.RoundedBox(2,0,0,chooseskill:GetWide(),chooseskill:GetTall(),Color(math.Clamp(amt+col.r,0,255),math.Clamp(amt+col.g,0,255),math.Clamp(amt+col.b,0,255),100))

		draw.SimpleText(txt,"ScoreboardSubtitle2",chooseskill:GetWide()*0.5,chooseskill:GetTall()*0.5,Color(255,255,255,255),1,1)
	end
	chooseskill.DoClick = function() RunConsoleCommand("buyskill",self.selectedSkill)  end
	chooseskill.tab = 3
	table.insert(self.dispItems,chooseskill)	

	--DONATIONS TAB
	

	local donPanel = vgui.Create("DPanel",self)
	donPanel.tab = 4
	donPanel:StretchToParent(20,125,20,20)
	donPanel.Paint = function()
		local col = team.GetColor(Me:Team())
		draw.RoundedBox(2,0,0,donPanel:GetWide(),donPanel:GetTall(),Color(math.Clamp(90+col.r,0,255),math.Clamp(90+col.g,0,255),math.Clamp(90+col.b,0,255),100))
		local xOff = 15
		local yOff = 15
		--local txt = util.WordWrap("Deadlock is expensive to run and costs me about $150 a month to run. Donations are needed to cover the cost of things such as the server and bandwidth. By donating you are supporting the Deadlock Community. We offer these incentives as well.","VGUID5",1000
		local txt = "Donations are needed to cover the cost of things such as the server and bandwidth. By donating you are supporting the Community. We offer these incentives as well."
		draw.DrawText(txt, "VGUID5", xOff, yOff, Color(255,255,255,255),0)
		for i,v in pairs(memberships) do
				
			for e,w in pairs(v) do

				draw.SimpleText(w, "VGUID5", xOff+((i) * 140), yOff+(e * 18)+50, Color(math.Clamp(255-(i-1)*85,0,255),math.Clamp((i-1)*85,0,255),0,255),0,1)
			end
		end
		for i,v in pairs(m_desc) do
			draw.SimpleTextOutlined(v, "VGUID1", xOff+1, yOff+(i * 18)+50, Color(255,255,255,255),0,1,1,Color(0,0,0,255))
			--draw.SimpleTextOutlined(v, "VGUID1", xOff, yOff+(i * 18)+70, Color(20,150,20,255),0,1)
		end
		for i,v in pairs(m_name) do
			draw.SimpleTextOutlined(v, "VGUID1", xOff+((i) * 140)+1, yOff+50, Color(255,255,255,255),1,1,1,Color(0,0,0,255))
			--draw.SimpleText(v, "VGUID1", xOff+((i+1) * 140),yOff+72, Color(20,150,20,255),1,1)
		end
		local usd = util.WordWrap(dollas,"VGUID5",donPanel:GetWide()-100)
		draw.DrawText(usd, "VGUID5", xOff, 337, Color(255,255,255,255),0)
		--draw.SimpleText("Please see www.DarklandServers.com/donations.php for more info.", "VGUID1",donPanel:GetWide()*0.5+2,donPanel:GetTall()-20, Color(0,0,0,255),1,1)
		--draw.SimpleText("Please see www.DarklandServers.com/donations.php for more info.", "VGUID1",donPanel:GetWide()*0.5+1,donPanel:GetTall()-21, Color(20,50,20,255),1,1)
		--draw.SimpleText("Please see www.DarklandServers.com/donations.php for more info.", "VGUID1",donPanel:GetWide()*0.5,donPanel:GetTall()-22, Color(20,150,20,255),1,1)
		draw.SimpleText("Donations currently available, please see www.DeadlockGaming.com for more info", "VGUID1",donPanel:GetWide()*0.5+2,donPanel:GetTall()-20, Color(0,0,0,255),1,1)
		draw.SimpleText("Donations currently available, please see www.DeadlockGaming.com for more info", "VGUID1",donPanel:GetWide()*0.5+1,donPanel:GetTall()-21, Color(20,50,20,255),1,1)
		draw.SimpleText("Donations currently available, please see www.DeadlockGaming.com for more info", "VGUID1",donPanel:GetWide()*0.5,donPanel:GetTall()-22, Color(20,150,20,255),1,1)
	end
	table.insert(self.dispItems,donPanel)
	
	self:RefreshTabs()
	
end
--much better :D
function PANEL:RefreshTabs()
	for i,v in pairs(self.dispItems) do
		v:SetVisible(v.tab == self.currentTab)
	end
end

function PANEL:Paint()
	surface.SetTexture(surface.GetTextureID("darkland/fortwars/f1bg"))
	local col = team.GetColor(Me:Team())
	surface.SetDrawColor(math.Clamp(90+col.r,0,255),math.Clamp(90+col.g,0,255),math.Clamp(90+col.b,0,255),255)
	surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
end
vgui.Register("fw_menu",PANEL,"DPanel")

function CreateMenu()


	if ValidPanel(g_fwMenu) then g_fwMenu:Remove() end
	g_fwMenu = vgui.Create("fw_menu")
	g_fwMenu:Center()
	g_fwMenu:SetVisible(false) --Little hacky so the next thing works good :D
	
	g_fwMenu:SetVisible(!g_fwMenu:IsVisible())
	if !g_fwMenu:IsVisible() then RememberCursorPosition() end
	gui.EnableScreenClicker(g_fwMenu:IsVisible())
	if g_fwMenu:IsVisible() then RestoreCursorPosition() end
end
hook.Add("FullyLoaded","CreateMenu",CreateMenu)
concommand.Add("fw_help",CreateMenu)

--concommand.Add("debugremovemenu", function() g_fwMenu:Remove() end)


function PropMenu()

if Menu then return false end

local Menu = vgui.Create("DFrame")
Menu:SetSize(750,425)
Menu:SetTitle("")
Menu:Center()
Menu:MakePopup()

Menu.Paint = function( self, w, h )
surface.SetTexture(surface.GetTextureID("darkland/fortwars/f1bg"))
local col = team.GetColor(Me:Team())
surface.SetDrawColor(math.Clamp(90+col.r,0,255),math.Clamp(90+col.g,0,255),math.Clamp(90+col.b,0,255),255)
surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
end

local ppanel = vgui.Create( "DPanelList", Menu )
ppanel:SetSize(750,390)
ppanel:SetPos( 15, 115 )
ppanel:EnableVerticalScrollbar( true )
ppanel:EnableHorizontal( true )
ppanel:SetSpacing( 5 )

for k, v in SortedPairsByMemberValue( UPropList, "COST" ) do

    local ItemBackground = vgui.Create( "DPanel" )
    ItemBackground:SetPos( 5, 5 )
    ItemBackground:SetSize( 100, 140 )
    ItemBackground.Paint = function( self, w, h ) -- Paint function
        draw.RoundedBoxEx(8,1,1, w - 2,h-2,Color(0, 0, 0, 50), false, false, false, false)
        local col = team.GetColor(Me:Team())
	surface.SetDrawColor(50, 50, 50 ,255)
	surface.DrawOutlinedRect(0, 0, w, h)
	draw.SimpleText(v.NAME,"ScoreboardSubtitle2",w*0.5,h*0.5 + 10,Color(255,255,255,255),1,1)
		local pricecol = Color(255,0,0,255)
		if myMoney >= v.BUYCOST then pricecol = Color(0,255,0,255) end
	draw.SimpleText("Cost: "..v.BUYCOST,"ScoreboardSubtitle2",w*0.5,h*0.5 + 30,pricecol,1,1)
    end

    local ItemDisplay = vgui.Create( "SpawnIcon", ItemBackground )
    ItemDisplay:SetPos( 18, 5 )
    ItemDisplay:SetModel( v.MODEL )
    ItemDisplay:SetToolTip(false)
    ItemDisplay:SetSize(75,75)
    ItemDisplay.PaintOver = function()
        return
    end
    ItemDisplay.OnMousePressed = function()
        return false
    end

		local p = vgui.Create("Panel", ItemBackground)
		p.OnCursorEntered = function() p.Hovered = true end
		p.OnCursorExited = function() p.Hovered = false end
		p.OnMousePressed = function() RunConsoleCommand("buyprop", k ) end
		p:SetPos(10, 110)
		p:SetSize(80, 20)

		p.Paint = function()
			local amt = 90
			local btxt = "Buy"
			if p.Hovered then amt = amt + 30 end
			if myProps[k] > 0 then amt = amt + 60 btxt = "Owned" end
			local col = team.GetColor(Me:Team())
			draw.RoundedBox(4,0,0,p:GetWide(),p:GetTall(),Color(math.Clamp(amt+col.r,0,255),math.Clamp(amt+col.g,0,255),math.Clamp(amt+col.b,0,255),255))
			draw.SimpleTextOutlined(btxt,"ScoreboardSubtitle2",p:GetWide()*0.5,p:GetTall()*0.5,Color(255,255,255,255),1,1,1,Color(0,0,0,255))
		end

ppanel:AddItem( ItemBackground )
end

end
concommand.Add("fw_buyprops",PropMenu)