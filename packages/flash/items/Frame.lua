-- Frame.lua
local FlashUtil = import("..util")
local FlashConfig = import("..config")

local Frame = class("Frame");

function Frame:ctor(data, index, layer, parentNode)
	self.layer = layer;
	self.mc = layer.mc;
	self.index = index;
	self.name = data.name
	self.parentNode = layer.parentNode;
	self.rotateType = data.rotateType
	self.rotateTimes = data.rotateTimes
	self.startFrame = data.startFrame;
	self.duration = data.duration
	self.tweenType = data.tweenType;
	self.isMotionFrame = (self.tweenType == "motion")
	self.isEmpty = data.isEmpty;
	self.elementsData = data.elements;

	self.soundName = data.soundName;
	self.soundLoopMode = data.soundLoopMode
	self.soundSync = data.soundSync
	self.soundLoop =data.soundLoop

	self.elements = {};
end

function Frame:isMotion()
	return self.isMotionFrame
end

function Frame:dealSound()
	if self.soundName then
		local doc = self.mc.doc
		local tpData = {};
		tpData.soundLoopMode = self.soundLoopMode;
		tpData.soundSync = self.soundSync;
		tpData.soundLoop = self.soundLoop;
		tpData.group = self.mc.group
		
		doc:createInstance(self.soundName, tpData)
	end
end

function Frame:setNextAttrByFrameData(frameData)
	local elementData = frameData.elements[1]
	if elementData then
		self.nextAttr = frameData.elements[1].attr;
	end 
	local curElementDataNum = #self.elementsData
	local nextElementNum = #frameData.elements
	local min = math.min(curElementDataNum, nextElementNum)
	for i=1,min do
		local curChildAttr = self.elementsData[i].childAttr
		local nextChildAttr = frameData.elements[i].childAttr
		if curChildAttr.blendMode ~= nextChildAttr.blendMode then
			nextChildAttr.needBlen = true
		end

	end
	local rotateType = self.rotateType
	local rotateTimes = self.rotateTimes
	if rotateType then
		if rotateType == "clockwise" then
			self.totalAngle = 360*rotateTimes
		elseif rotateType == "counter-clockwise" then
			self.totalAngle = -360*rotateTimes
		end
	end
end

function Frame:enter(frame, det)
	if self.soundName and not self.hadDealSound then
		self:dealSound()
		self.hadDealSound = true
	end
	if self.isEmpty then
		return;
	end
	local detFrame = frame - (self.startFrame + 1)
	if #self.elements == 0 then
		for index,elementData in ipairs(self.elementsData) do
			local childAttr = elementData.childAttr
			local ins, child, isEnter = self:createOneElementByData(elementData, index);
			local data = {}
			data.ins = ins;
			data.child = child;
			self.elements[#self.elements+1] = data;
			local realElement = child or ins
			if isEnter and FlashUtil.kindOfClass(realElement, FlashConfig.itemTypes.Anm) then
				realElement:updateFrame(detFrame, det)
			end
			if childAttr.tp == FlashConfig.itemTypes.Txt then
				FlashUtil.setTextAttr(realElement, childAttr)
			end
		end
	end
	for i=1,#self.elements do
		local elementData = self.elementsData[i]
		local data = self.elements[i]
		local ins = data.ins
		local attr = self:getAttrByFrame(elementData, detFrame+det);
		local realElement = data.child or ins
		local blendMode = elementData.childAttr.blendMode
		if realElement.setBlendMode then
			realElement:setBlendMode(blendMode)
		end
		FlashUtil.setNodeAttrByData(ins, attr);
		if FlashUtil.kindOfClass(realElement, FlashConfig.AnmSubTp.Gra) then
			realElement:updateFrame(detFrame, det)
		end
	end
end

function Frame:getAttrByFrame(elementData, detFrame)
	if not self.nextAttr then
		return elementData.attr;
	end

	if detFrame == 0 then
		return elementData.attr;
	end

	return FlashUtil.interpolatioAttr(elementData.attr, self.nextAttr, detFrame/self.duration, self.totalAngle)
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
	self.hadDealSound = false
end

function Frame:createOneElementByData(elementData, index)
	local attr = elementData.attr;
	local childAttr = elementData.childAttr;
	local layerOrder = self.layer.order;
	local elementOrder
	if self.parentNode then
		elementOrder = index;
	else
		elementOrder = layerOrder + index;
	end
	local parentNode = self.parentNode or self.mc
	local doc = self.mc.doc
	local itemName = childAttr.itemName
	local tp = childAttr.tp;

	local tpData = childAttr
	tpData.group = self.mc.group
	tpData.pblendMode = self.mc.pblendMode or self.mc.blendMode
	-- print("blendMode:" .. tostring(tpData.blendMode) .. " name:" .. childAttr.itemName)
	assert(tpData.group, "Frame:createOneElementByData - must had group, name:" .. self.mc.name)
	if childAttr.loop and childAttr.firstFrame then
		tp = FlashConfig.AnmSubTp.Gra
	end
	local cackeKey = FlashUtil.getElementCacheKey(itemName, tp, index, self.index)
	local cacheData = self.layer:getElementCacheData(cackeKey)
	local ins = cacheData.ins;
	local child = cacheData.child;
	local realNode = child or ins
	local isEnter = false
	if ins then
		if not cacheData.enter then
			if realNode.setBlendMode and childAttr.needBlen then
				realNode:setBlendMode(tpData.blendMode)
			end
			ins:addTo(parentNode, elementOrder, childAttr.name)
			cacheData.enter = true;
			isEnter = true
		end
		if child then
			child:move(childAttr.x, childAttr.y)
			if FlashUtil.kindOfClass(child, FlashConfig.AnmSubTp.Gra) then
				child:refreshAttr(childAttr)
			end
		end
	else
		isEnter = true
		if childAttr.x == 0 and childAttr.y == 0 then
			ins = doc:createInstance(childAttr.itemName, tpData)
			self.mc:retainNode(ins, self.mc.name .. ":" .. childAttr.itemName)
			ins:addTo(parentNode, elementOrder, childAttr.name)
		else
			ins = doc:createInstance(FlashConfig.defaultNodeName, {});
			self.mc:retainNode(ins, self.mc.name .. ":" .. childAttr.itemName .. "--NodeParent")
			ins:addTo(parentNode, elementOrder)
			child = doc:createInstance(childAttr.itemName, tpData)
			child:addTo(ins, 1, childAttr.name):move(childAttr.x, childAttr.y)
			cacheData.child = child
		end
		cacheData.ins = ins;
		cacheData.tp = tp
		cacheData.enter = true
	end
	return ins, child, isEnter;
end

return Frame;