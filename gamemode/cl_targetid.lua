function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end
	
	local text = "ERROR"
	local font = "TargetID"
	
	--if trace.Entity:GetNetworkedString("selectedclass") == "class_predator" and trace.Entity:GetActiveWeapon():GetTable().invis == true then return end
	if (trace.Entity:IsPlayer()) then
		text = trace.Entity:GetName()
	else
		return
		//text = trace.Entity:GetClass()
	end
	local tc = trace.Entity:GetColor()
	if tc.a < 40 and trace.Entity:Team() != LocalPlayer():Team() then return end -- they are a cloaked enemy predator
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local x, y = ScrW()/2,ScrH()/2
	
	x = x - w / 2
	y = y + 30
	
	// The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, team.GetColor( trace.Entity:Team() ) )
	if trace.Entity:Team() == LocalPlayer():Team() then
	y = y + h + 5
	
	local text = trace.Entity:Health() .. "%"
	local font = "TargetIDSmall"
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x =  ScrW()/2 - (w/2)
	
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, team.GetColor( trace.Entity:Team() ) )
	end
end

