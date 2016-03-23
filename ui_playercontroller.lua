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


