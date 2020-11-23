ENT.Spawnable			= false
ENT.AdminSpawnable		= false

include( "shared.lua" )

 local matBall2 = Material( "darkland/pumpkin2" )

function ENT:Initialize()

end

function ENT:Draw()


	if os.time() < 1257033600 then
		local pos = self.Entity:GetPos()

		render.SetMaterial( matBall2 )
		render.DrawSprite( pos, 32, 32, Color( 255, 255, 255, 255 ) )
	else
		self.Entity:DrawModel()
	end

end