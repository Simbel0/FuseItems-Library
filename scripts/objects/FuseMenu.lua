local FuseMenu, super = Class(Object)

function FuseMenu:init()
	super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.parallax_x = 0
	self.parallax_y = 0

	local f_list = Kristal.callEvent("getItemsList")
	self.list = {}

	for k, recipe in ipairs(f_list) do
		table.insert(self.list, {})
		for k2,item in pairs(recipe) do
			print(k,k2,item)
			local true_item = Registry.createItem(item)
			self.list[k][k2] = true_item
		end
	end

	print(Utils.dump(self.list))

	self.selected = 1

	self.offset = 0

	self.left_arrow = Assets.getTexture("ui/flat_arrow_left")
	self.right_arrow = Assets.getTexture("ui/flat_arrow_right")

	self.heart = Assets.getTexture("player/heart")
	self.heart_y = 198
	self.heart_timer = nil
	self.heart_timer_on = false

	self.arrow_timer = 0
	self.arrows_x = {20, 605}

	self.arrow_dir = "l-r"

	--self.rectangle = Rectangle(0, 0, SCREEN_WIDTH, 121)
	--self.rectangle:setColor(0, 0, 0, 1)
	--self:addChild(self.rectangle)

	--self.box = UIBox(54, 154, 533, 229, "light")
	--self:addChild(self.box)
end

function FuseMenu:update()
	if Input.pressed("down", true) then
		self.selected = self.selected+1
		if self.selected > 2 then self.selected = 1 end
		self.heart_timer_on = false
		Game.world.timer:cancel(self.heart_timer)
	elseif Input.pressed("up", true) then
		self.selected = self.selected-1
		if self.selected < 1 then self.selected = 2 end
		self.heart_timer_on = false
		Game.world.timer:cancel(self.heart_timer)
	elseif Input.pressed("left", true) then
		self.offset = self.offset - 2
		if self.offset < 0 then self.offset = math.ceil(#self.list/2)-1 end
	elseif Input.pressed("right", true) then
		self.offset = self.offset + 2
		if self.offset > math.ceil(#self.list/2)-1 then self.offset = 0 end
	end
	print(self.offset)

	if self.selected == 1 then
		if not self.heart_timer_on then
			self.heart_timer_on = true
			self.heart_timer = Game.world.timer:tween(0.3, self, {heart_y=198}, "out-quint", function()
				self.heart_timer_on = false
			end)
		end
	else
		if not self.heart_timer_on then
			self.heart_timer_on = true
			self.heart_timer = Game.world.timer:tween(0.3, self, {heart_y=311}, "out-quint", function()
				self.heart_timer_on = false
			end)
		end
	end

	self.arrow_timer = self.arrow_timer + DTMULT

	if self.arrow_timer%5 == 0 then
		if self.arrow_dir == "l-r" then
			if self.arrows_x[1] < 24 then
				self.arrows_x[1] = self.arrows_x[1] + 2
				self.arrows_x[2] = self.arrows_x[2] - 2
			else
				self.arrow_dir = "to-r-l"
			end
		elseif self.arrow_dir == "r-l" then
			if self.arrows_x[1] > 20 then
				self.arrows_x[1] = self.arrows_x[1] - 2
				self.arrows_x[2] = self.arrows_x[2] + 2
			else
				self.arrow_dir = "to-l-r"
			end
		elseif Utils.startsWith(self.arrow_dir, "to-") then
			self.arrow_dir = self.arrow_dir:sub(4)
		end
	end
end

function FuseMenu:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, 121)

	love.graphics.rectangle("fill", 30+2, 130+2, 580-3, 276-3)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line", 30+2, 130+2, 580-3, 276-3)

	love.graphics.print("Result", 114, 140)
	love.graphics.print("Ingredients", 330, 140)

	love.graphics.setLineWidth(3)

	love.graphics.line(90, 181, 551, 181)

	local hasItems = {false, false}

	local item1 = self.list[1+self.offset]["item1"]
	local item2 = self.list[1+self.offset]["item2"]
	local result = self.list[1+self.offset]["result"]

	local temp_storages = {
		Utils.copy(Game.inventory.storages[item1.type == "key" and "key_items" or item1.type.."s"]),
		Utils.copy(Game.inventory.storages[item2.type == "key" and "key_items" or item2.type.."s"])
	}

	for i=1,2 do
		local item = i==1 and item1 or item2
		for _,v in ipairs(temp_storages[i]) do

			if v.id == item.id then
				hasItems[i] = true
				Utils.removeFromTable(temp_storages[i], v)
				if i==1 and item1.type == item2.type then
					Utils.removeFromTable(temp_storages[2], v)
				end
				break
			end
			if hasItems[i] then
				hasItems[i] = false
			end
		end
	end

	love.graphics.print(result.description, 20, 20)

	local can_fuse = hasItems[1] and hasItems[2]
	if can_fuse then
		if self.selected == 1 then
			love.graphics.setColor(1, 1, 0)
		else
			love.graphics.setColor(1, 1, 1)
		end
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end

	love.graphics.print(result.name, 110, 190)

	if hasItems[1] then
		love.graphics.setColor(1, 1, 1)
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	love.graphics.print(item1.name, 330, 190)

	if hasItems[2] then
		love.graphics.setColor(1, 1, 1)
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	love.graphics.print(item2.name, 330, 230)

	love.graphics.line(90, 280, 551, 280)

	hasItems = {false, false}

	item1 = self.list[2+self.offset]["item1"]
	item2 = self.list[2+self.offset]["item2"]
	result = self.list[2+self.offset]["result"]

	temp_storages = {
		Utils.copy(Game.inventory.storages[item1.type == "key" and "key_items" or item1.type.."s"]),
		Utils.copy(Game.inventory.storages[item2.type == "key" and "key_items" or item2.type.."s"])
	}

	for i=1,2 do
		local item = i==1 and item1 or item2
		for _,v in ipairs(temp_storages[i]) do
			print(i, v.id, item.id, v.id == item.id)

			if v.id == item.id then
				hasItems[i] = true
				Utils.removeFromTable(temp_storages[i], v)
				if i==1 and item1.type == item2.type then
					Utils.removeFromTable(temp_storages[2], v)
				end
				break
			end
			if hasItems[i] then
				hasItems[i] = false
			end
		end
	end

	local can_fuse = hasItems[1] and hasItems[2]
	if can_fuse then
		if self.selected == 2 then
			love.graphics.setColor(1, 1, 0)
		else
			love.graphics.setColor(1, 1, 1)
		end
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end

	love.graphics.print(result.name, 110, 303)

	if hasItems[1] then
		love.graphics.setColor(1, 1, 1)
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	love.graphics.print(item1.name, 330, 303)

	if hasItems[2] then
		love.graphics.setColor(1, 1, 1)
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	love.graphics.print(item2.name, 330, 343)

	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Page "..(self.offset+1).." / "..math.ceil(#self.list/2), 530, 343, 0, 0.5, 1)

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.left_arrow, self.arrows_x[1], 258, 0, 2, 2)
	love.graphics.draw(self.right_arrow, self.arrows_x[2], 258, 0, 2, 2)

	love.graphics.setColor(1, 0, 0)

	love.graphics.draw(self.heart, 80, self.heart_y)

	super.draw(self)
end

return FuseMenu