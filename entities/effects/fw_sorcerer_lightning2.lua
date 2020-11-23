

EFFECT.Mat = Material( "sprites/soul" )

--[[---------------------------------------------------------
   Init( data table )
-----------------------------------------------------------]]
function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	-- Keep the start and end pos - we're going to interpolate between them
	self.StartPos = data:GetStart()
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

	self.Life = self.Life + FrameTime() * 5
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
						math.random( 5, 25),
						texcoord,
						texcoord + self.Length / 1024,
						Color( 155,155, 255, 155 * ( 1 - self.Life ) )	)

end