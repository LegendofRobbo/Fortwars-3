
include( "scoreboard/scoreboard.lua" );

local pScoreBoard = nil

local ShowScoreboard = false
/*---------------------------------------------------------
   Name: CreateScoreboard( )
   Desc: Creates/Recreates the scoreboard
---------------------------------------------------------*/
function CreateScoreboard()

	if ( ScoreBoard ) then
	
		ScoreBoard:Remove()
		ScoreBoard = nil
	
	end
	--if ENDGAME then return end   Idk why you would want this? :S
	pScoreBoard = vgui.Create( "ScoreBoard" )

end

/*---------------------------------------------------------
   Name: GM:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
---------------------------------------------------------*/
function GM:ScoreboardShow()
	if finalmenu then return end
	ShowScoreboard = true
	gui.EnableScreenClicker( true )
	
	if ( !pScoreBoard ) then
		CreateScoreboard()
	end
	
	pScoreBoard:SetVisible( true )
	
end
/*---------------------------------------------------------
   Name: FW:ScoreboardHide( )
   Desc: Hides the scoreboard
---------------------------------------------------------*/
function GM:ScoreboardHide()

	ShowScoreboard = false
	if pScoreBoard then
		pScoreBoard:SetVisible( false )
	end
	--if ENDGAME then return end   Idk why you would want this? :S
	gui.EnableScreenClicker(false)
end

function GM:HUDDrawScoreBoard()
	return false
end

function GM:PostRenderVGUI()
	if !ShowScoreboard then return end

	pScoreBoard:SetPaintedManually(false)
		pScoreBoard:PaintManual()
    	pScoreBoard:SetPaintedManually(true)
end