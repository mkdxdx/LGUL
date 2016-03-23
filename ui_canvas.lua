local l_gfx = love.graphics

UICanvas = {}
UICanvas.__index = UICanvas
UICanvas.ident = "ui_canvas"
UICanvas.mode = "add"
function UICanvas:new(name)
	local self = setmetatable({},UICanvas)
	self.name = name or self.name
	return self
end
setmetatable(UICanvas,{__index = Image})

function UICanvas:create(x,y)
	self.canvas = l_gfx.newCanvas(x,y)
	self:setSize(x,y)
end

function UICanvas:draw()
	if self.canvas ~= nil then
		--[[
		local c = l_gfx.getCanvas()
		l_gfx.setCanvas(self.canvas)
		l_gfx.clear()
		local bm = l_gfx.getBlendMode()
		local cr,cg,cb,ca = l_gfx.getColor()
		l_gfx.setColor(self.colorTint)
		l_gfx.setBlendMode(self.mode)
		l_gfx.draw(self.canvas,self.x,self.y)
		l_gfx.setBlendMode(bm)
		l_gfx.setColor(cr,cg,cb,ca)
		l_gfx.setCanvas(c)
		]]--
		
		local bm = l_gfx.getBlendMode()
		local cr,cg,cb,ca = l_gfx.getColor()
		local px,py = self:getPosition()
		l_gfx.draw(self.canvas,px,py)
		if self.showBorder == true then
			l_gfx.setColor(self.colorLine)
			local w,h = self.w,self.h
			l_gfx.rectangle("line",self.x-1,self.y-1,w+2,h+2)
		end
		l_gfx.setColor(cr,cg,cb,ca)
		l_gfx.setBlendMode(bm)
	end
end

function UICanvas:get()
	return self.canvas
end