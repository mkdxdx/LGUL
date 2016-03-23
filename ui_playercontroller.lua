--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

GWEntityController = {}
GWEntityController.__index = GWEntityController
GWEntityController.name = "GWEntityController"
GWEntityController.ident = "ui_gwentitycontroller"
GWEntityController.updateable = true
function GWEntityController:new(name)
	local self = setmetatable({},GWEntityController)
	self.name = name or self.name
	return self
end
setmetatable(GWEntityController,{__index = Element})

function GWEntityController:init()
	
end

function GWEntityController:keypressed(key,isrepeat)
	if self.entity ~= nil then
		self.entity:keypressed(key,isrepeat)
	end
end

function GWEntityController:keyreleased(key)
	if self.entity~=nil then
		self.entity:keyreleased(key)
	end
end

function GWEntityController:setEntity(entity)
	self.entity = entity
end

function GWEntityController:unsetEntity()
	self.entity = nil
end

function GWEntityController:getEntity() return self.entity end

function GWEntityController:update(dt) end



PlayerController = {}
PlayerController.__index = PlayerController
PlayerController.name = "PlayerController"
PlayerController.ident = "ui_playercontroller"
PlayerController.updateable = true
function PlayerController:new(name)
	local self = setmetatable({},PlayerController)
	self.name = name or self.name
	return self
end
setmetatable(PlayerController,{__index = GWEntityController})


