

EFFECT.Mat = Material( "sprites/tp_beam001" )

--[[---------------------------------------------------------
   Init( data table )
-----------------------------------------------------------]]
function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	-- Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	self.Alpha = 255
	self.Life = 0.0;

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
	self.Offset = 0
	self.R = 0
end

--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )

	self.Life = self.Life + FrameTime() * 3
	self.Alpha = 255 * ( 2 - self.Life )
	self.R = 255-(self.Life * 4)
	
	return (self.Life < 1)

end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render( )
	if ( self.Alpha < 1 ) then return end
		
	render.SetMaterial( self.Mat )
	local texcoord = self.Life * -1 /2
	local norm = (self.StartPos - self.EndPos) * self.Life

	self.Length = norm:Length() /2
	
	

	render.DrawBeam( self.StartPos,
						self.EndPos,
						math.random( 15, 55),
						texcoord,
						texcoord + self.Length / 1024,
						Color( 155,155, 255, 155 * ( 1 - self.Life ) )	)

end