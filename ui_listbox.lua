--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics
local min = math.min

-- simple list box with index and clickable string list
-- usually linked to collection in its behavior

ListBox = {}
ListBox.__index = ListBox
ListBox.ident = "ui_listbox"
ListBox.name = "ListBox"
ListBox.caption = "ListBox"
ListBox.itemSpacing = 1 -- this will define a gap between items
ListBox.itemCaptionAlign = "left" 
ListBox.itemCaptionPadding = 4 -- this will make text appear shifted
ListBox.displayMax = 16
ListBox.shift = 0
ListBox.showBorder = false
ListBox.showScroll = false
ListBox.scrollWidth = 16

function ListBox:new(name)
	local self = {}
	setmetatable(self,ListBox)
	self.items = {}
	self.index = 0
	self.itemHeight = 16
	if name ~= nil then self.name = name end
	return self
end
setmetatable(ListBox,{__index = UIElement})

function ListBox:mousepressed(x,y,b)
	if self:isMouseOver(x,y) then
		if b == 1 or b == 2 then
			local c = #self.items
			if c>0 then
				local sx,sy,sw,ih = self.x,self.y,self.w,self.itemHeight
				for i=(self.shift+1),(self.shift+math.min(self.displayMax,c)) do
					local factor = i-1-self.shift
					local ix,iy = sx,factor*ih+factor*self.itemSpacing
					if x>=sx and x<=sx+sw and y>=sy+iy and y<=sy+iy+ih then
						self.index = i
						break
					end
				end
			end
		self:click(b)
		end
	end
end

function ListBox:wheelmoved(x,y)
	if self:isMouseOver() == true then
		if y > 0 then
			self.shift = self.shift - 1
			if self.shift<0 then self.shift = 0 end
		elseif y < 0 then	
			if self.shift<(#self.items-self.displayMax) then
				self.shift = self.shift+1
			end
		end
	end
end

-- this will return highlighted element
function ListBox:getSelected()
	return self.items[self.index]
end

function ListBox:addItem(item,name)
	--table.insert(self.items,item)
	self.items[#self.items+1] = item
	if #self.items == 1 then self.index = 1 end
end


function ListBox:clear()
	for k,v in pairs(self.items) do self.items[k] = nil end
	self.index = 0
end

function ListBox:last()
	self.index = #self.items
end

function ListBox:first()
	if #self.items>0 then self.index = 1 else self.index = 0 end
end

function ListBox:setSize(w,h) 
	self.w = w or self.w self.h = h or self.h 
	self.displayMax = math.floor(self.h/(self.itemHeight+self.itemSpacing))
	print(self.name.."|"..self.displayMax)
end

-- if you specify a number, it will return you an item as if you index an array, otherwise it will try to look for it by comparing strings
function ListBox:getItem(item)
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

function ListBox:setItemValue(item,value)
	self.items[item] = value
end

function ListBox:draw()
	local cr,cg,cb,ca = l_gfx.getColor()
	if self.showBorder == true then
		l_gfx.setColor(self.colorLine)
		l_gfx.rectangle("line",self.x,self.y,self.w,self.h)
	end
	local c = #self.items
	local fh = l_gfx.getFont():getHeight()/2
	if c>0 then	
		local sx,sy,sw,ih = self.x,self.y,self.w,self.itemHeight
		for i=(self.shift+1),(self.shift+math.min(self.displayMax,c)) do
			if self.index == i then
				l_gfx.setColor(self.colorHighlight)
			else
				l_gfx.setColor(self.colorFill)
			end
			local factor = i-1-self.shift
			local space = factor*self.itemSpacing
			local ix,iy,iw = self.x, self.y+factor*self.itemHeight+space,self.w
			if self.showScroll == true then iw = iw - self.scrollWidth end
			local fpad = self.itemHeight/2-fh
			
			l_gfx.rectangle("fill",ix,iy,iw,self.itemHeight)
			l_gfx.setColor(self.colorFont)
			if type(self.items[i]) == "table" then
				l_gfx.printf(self.items[i][1],ix+self.itemCaptionPadding,iy+fpad,iw-self.itemCaptionPadding,self.itemCaptionAlign)
			elseif type(self.items[i]) == "string" then
				l_gfx.printf(self.items[i],ix+self.itemCaptionPadding,iy+fpad,iw-self.itemCaptionPadding,self.itemCaptionAlign)
			end
		end
		if self.showScroll == true then
			l_gfx.setColor(self.colorFill)
			l_gfx.rectangle("line",self.w+self.x-self.scrollWidth,self.y,self.scrollWidth,self.h)
			local h = self.h/(math.max(#self.items/self.displayMax,1))
			l_gfx.rectangle("fill",self.w+self.x-self.scrollWidth,self.y+self.shift*self.displayMax,self.scrollWidth,h)
		end
	end
	l_gfx.setColor(cr,cg,cb,ca)
end


GaugeList = {}
GaugeList.__index = GaugeList
GaugeList.ident = "ui_gaugelist"
GaugeList.name = "GaugeList"
GaugeList.colorProgress = {0,160,160,128}
function GaugeList:new(name)
	local self = {}
	setmetatable(self,GaugeList)
	self.items = {}
	self.index = 0
	self.itemHeight = 16
	if name ~= nil then self.name = name end
	return self
end
setmetatable(GaugeList,{__index = ListBox})

function GaugeList:addItem(item,val)
	table.insert(self.items,{item,val or 0})
	if #self.items == 1 then self.index = 1 end
end

function GaugeList:clear()
	--for k,v in pairs(self.items) do self.items[k][2] = nil self.items[k][1] = nil self.items[k] = nil end
	if #self.items>0 then
		for i=#self.items,1,-1 do
			self.items[i][2] = nil
			self.items[i][1] = nil
			table.remove(self.items,i)
		end
	end
	self.index = 0
end

function GaugeList:setItemValue(item,value,value2)
	self.items[item][1] = value or self.items[item][1]
	self.items[item][2] = value2 or 0
end

function GaugeList:draw()
	if self.showBorder == true then
		l_gfx.setColor(self.colorLine)
		l_gfx.rectangle("line",self.x,self.y,self.w,self.h)
	end
	local c = #self.items
	local fh = l_gfx.getFont():getHeight()/2
	if c>0 then	
		local sx,sy,sw,ih = self.x,self.y,self.w,self.itemHeight
		for i=(self.shift+1),(self.shift+math.min(self.displayMax,c)) do
			if self.index == i then
				l_gfx.setColor(self.colorHighlight)
			else
				l_gfx.setColor(self.colorFill)
			end
			local factor = i-1-self.shift
			local space = factor*self.itemSpacing
			local ix,iy,iw = self.x, self.y+factor*self.itemHeight+space,self.w
			if self.showScroll == true then iw = iw - self.scrollWidth end
			local fpad = self.itemHeight/2-fh
			
			l_gfx.rectangle("fill",ix,iy,iw,self.itemHeight)
			l_gfx.setColor(self.colorProgress)
			local prg = min(self.items[i][2]/100,1)
	
			l_gfx.rectangle("fill",ix,iy,prg*iw,self.itemHeight)
			l_gfx.setColor(self.colorFont)
			if type(self.items[i][1]) == "table" then
				l_gfx.printf(self.items[i][1][1],ix+self.itemCaptionPadding,iy+fpad,iw-self.itemCaptionPadding,self.itemCaptionAlign)
			elseif type(self.items[i][1]) == "string" then
				l_gfx.printf(self.items[i][1],ix+self.itemCaptionPadding,iy+fpad,iw-self.itemCaptionPadding,self.itemCaptionAlign)
			end
		end
		if self.showScroll == true then
			l_gfx.setColor(self.colorFill)
			l_gfx.rectangle("line",self.w+self.x-self.scrollWidth,self.y,self.scrollWidth,self.h)
			local h = self.h/(math.max(#self.items/self.displayMax,1))
			l_gfx.rectangle("fill",self.w+self.x-self.scrollWidth,self.y+self.shift*self.displayMax,self.scrollWidth,h)
		end
	end
end

function GaugeList:clear()
	for k,v in pairs(self.items) do 
		self.items[k][1],self.items[k][2] = nil,nil
		self.items[k] = nil
	end
	self.index = 0
end


