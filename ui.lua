--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

require(ui_scrdir.."ui_element")
require(ui_scrdir.."ui_uielement")
require(ui_scrdir.."ui_button")
require(ui_scrdir.."ui_label")
require(ui_scrdir.."ui_groupbox")
require(ui_scrdir.."ui_spin")
require(ui_scrdir.."ui_shape")
require(ui_scrdir.."ui_checkbox")
require(ui_scrdir.."ui_pageswitch")
require(ui_scrdir.."ui_radiobutton")
require(ui_scrdir.."ui_progressbar")
require(ui_scrdir.."ui_particleemitter")
require(ui_scrdir.."ui_imagecollection")
require(ui_scrdir.."ui_listbox")
require(ui_scrdir.."ui_image")
require(ui_scrdir.."ui_collection")
require(ui_scrdir.."ui_timer")
require(ui_scrdir.."ui_canvas")
require(ui_scrdir.."ui_pointplotter")
require(ui_scrdir.."ui_playercontroller")
require(ui_scrdir.."ui_textfield")

local l_gfx = love.graphics


-- define UIManager "class": the one that handles all the buttons and labels,draws them, updates them and handles inputs
UIManager = {}
UIManager.__index = UIManager

function UIManager:new()
	local self = {}
	setmetatable(self,UIManager)
	self.items = {}
	self.drawList = {}
	self.updateList = {}
	self.inputList = {}
	return self
end

function UIManager:addItem(item)
	table.insert(self.items,item)
	if item.updateable == true then
		table.insert(self.updateList,item)
	end
	if item.drawable == true then
		table.insert(self.drawList,item)
	end
	if item.input == true then
		table.insert(self.inputList,item)
	end
	item:oncreate()
	return item
end

function UIManager:getItem(name,deep)
	local c = #self.items
	if c>0 then
		for i=1,c do
			if self.items[i]:getName() == name then
				return self.items[i]
			elseif self.items[i].items ~= nil and deep == true then
				self.items[i]:getItem(name,deep)
			end
		end		
	end
	return nil
end

-- element deep search

function UIManager:draw()
	local dl = self.drawList
	local c = table.getn(dl)
	if c>0 then
		for i=1,c do
			if dl[i].visible == true then dl[i]:draw() end
		end
	end
end

function UIManager:update(dt)
	local ul = self.updateList
	local c = table.getn(ul)
	if c>0 then
		for i=1,c do
			if ul[i].active == true then ul[i]:update(dt) end
		end
	end
end

function UIManager:mousemoved(x,y,dx,dy)
	local ill = self.inputList
	for i,v in ipairs(ill) do
		if v.active == true then v:mousemoved(x,y,dx,dy) end
	end
end

function UIManager:mousepressed(x,y,b)
	for i,v in ipairs(self.inputList) do
		if v.active == true then v:mousepressed(x,y,b) end
	end
end

function UIManager:mousereleased(x,y,b)
	for i,v in ipairs(self.inputList) do
		if v.active == true then v:mousereleased(x,y,b) end
	end
end

function UIManager:wheelmoved(x,y)
	for i,v in ipairs(self.inputList) do
		if v.active == true then v:wheelmoved(x,y) end
	end
end

function UIManager:keypressed(key,isrepeat)
	for i,v in ipairs(self.inputList) do
		if v.active == true then v:keypressed(key,isrepeat) end
	end
end

function UIManager:keyreleased(key)
	for i,v in ipairs(self.inputList) do
		if v.active == true then v:keyreleased(key) end
	end
end

function UIManager:textinput(t)
	for i,v in ipairs(self.inputList) do
		if v.active == true then v:textinput(t) end
	end
end

function UIManager:onchangewindow(w,h) 
	for i,v in ipairs(self.items) do
		v:onchangewindow(w,h)
	end
end

function UIManager:init()
	uistartup(self)
end
