local FuseMenu, super = Class(Object)

function FuseMenu:init()
	super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.parallax_x = 0
	self.parallax_y = 0

	self.rectangle = Rectangle(0, 0, SCREEN_WIDTH, 121)
	self.rectangle:setColor(0, 0, 0, 1)
	self:addChild(self.rectangle)

	self.box = UIBox(54, 154, 533, 229, "light")
	self:addChild(self.box)
end

return FuseMenu