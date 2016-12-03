-- Frame.lua
local FlashUtil = import("..util")
local FlashConfig = import("..config")

local Frame = class("Frame");

function Frame:ctor(data, index, layer)
	self.layer = layer;
	self.mc = layer.mc;
	self.index = index;
	self.name = data.name

	self.startFrame = data.startFrame;
	self.duration = data.duration
	self.tweenType = data.tweenType;
	self.isMotionFrame = (self.tweenType == "motion")
	self.isEmpty = data.isEmpty;
	self.elementsData = data.elements;
	self.elements = {};
end

function Frame:isMotion()
	return self.isMotionFrame
end

function Frame:setNextAttrByFrameData(frameData)
	local elementData = frameData.elements[1]
	if elementData then
		self.nextAttr = frameData.elements[1].attr;
	end 
end

function Frame:enter(frame, det)
	if self.isEmpty then
		return;
	end
	local detFrame = frame - (self.startFrame + 1)
	if #self.elements == 0 then
		for index,elementData in ipairs(self.elementsData) do
			local ins, child, isEnter = self:createOneElementByData(elementData, index);
			local data = {}
			data.ins = ins;
			data.child = child;
			self.elements[#self.elements+1] = data;
			local realElement = data.child or ins
			if isEnter and FlashUtil.kindOfClass(realElement, FlashConfig.itemTypes.Anm) then
				realElement:updateFrame(detFrame, det)
			end
		end
	end
	for i=1,#self.elements do
		local elementData = self.elementsData[i]
		local data = self.elements[i]
		local ins = data.ins
		local attr = self:getAttrByFrame(elementData, detFrame+det);
		local realElement = data.child or ins
		if FlashUtil.kindOfClass(realElement, FlashConfig.AnmSubTp.Gra) then
			realElement:updateFrame(detFrame, det)
		end
		FlashUtil.setNodeAttrByData(ins, attr);
	end
end

function Frame:getAttrByFrame(elementData, detFrame)
	if not self.nextAttr then
		return elementData.attr;
	end

	if detFrame == 0 then
		return elementData.attr;
	end

	return FlashUtil.interpolatioAttr(elementData.attr, self.nextAttr, detFrame/self.duration)
end

function Frame:exit(newFrame)
	local newIndex = (newFrame and newFrame.index)
	for index,elementData in ipairs(self.elementsData) do
		local childAttr = elementData.childAttr;
		local insData = self.elements[index]
		local ins, child = insData.ins, insData.child
		local itemName = childAttr.itemName
		local tp
		if childAttr.loop and childAttr.firstFrame then
			tp = FlashConfig.AnmSubTp.Gra
		else
			tp = childAttr.tp
		end
		local cackeKey = FlashUtil.getElementCacheKey(itemName, tp, index, self.index)
		local cacheData = self.layer:getElementCacheData(cackeKey)
		-- dump(cacheData)
		local isRemove = true;
		if newIndex and newIndex > self.index then
			local isAllHad = true
			for i=self.index+1,newIndex do	
				local nextFrameKey = FlashUtil.getElementCacheKey(itemName, tp, index, i)
				local nextCacheData = self.layer:getElementCacheData(nextFrameKey)
				if not nextCacheData then
					isAllHad = false;
					break
				end
			end
			isRemove = not isAllHad
		end
		if isRemove then
			ins:removeSelf();
			local realIns = child or ins;
			if FlashUtil.kindOfClass(realIns, "Mc") then
				realIns:resetTotal()
			end
			cacheData.enter = false;
		end

	end
	self.elements = {}
end

function Frame:createOneElementByData(elementData, index)
	local attr = elementData.attr;
	local childAttr = elementData.childAttr;
	local layerOrder = self.layer.order;
	local elementOrder = layerOrder + index;
	local doc = self.mc.doc
	local itemName = childAttr.itemName
	local tp = childAttr.tp;

	local tpData = childAttr
	tpData.group = self.mc.group
	assert(tpData.group, "Frame:createOneElementByData - must had group, name:" .. self.mc.name)
	if childAttr.loop and childAttr.firstFrame then
		tp = FlashConfig.AnmSubTp.Gra
	end
	local cackeKey = FlashUtil.getElementCacheKey(itemName, tp, index, self.index)
	local cacheData = self.layer:getElementCacheData(cackeKey)
	local ins = cacheData.ins;
	local child = cacheData.child;
	local isEnter = false
	if ins then
		if not cacheData.enter then
			ins:addTo(self.mc, elementOrder, childAttr.name)
			cacheData.enter = true;
			isEnter = true
		end
		if child then
			child:move(childAttr.x, childAttr.y)
		end
	else
		isEnter = true
		if childAttr.x == 0 and childAttr.y == 0 then
			ins = doc:createInstance(childAttr.itemName, tpData)
			ins:retain()
			ins:addTo(self.mc, elementOrder, childAttr.name)
		else
			ins = FlashUtil.createNode();
			ins:retain();
			ins:addTo(self.mc, elementOrder)
			child = doc:createInstance(childAttr.itemName, tpData)
			child:addTo(ins, 1, childAttr.name):move(childAttr.x, childAttr.y)
			cacheData.child = child
		end
		cacheData.ins = ins;
		cacheData.enter = true
	end
	return ins, child, isEnter;
end

return Frame;