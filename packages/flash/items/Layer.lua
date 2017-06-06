-- Layer.lua
local FlashConfig = import("..config")
local FlashUtil = import("..util")

local Frame = import(".Frame");

local Layer = class("Layer");

function Layer:ctor(data, index, timeline, parentNode)
	self.timeline = timeline;
	self.mc = timeline.mc;
	self.layerIndex = index
	self.parentNode = parentNode
	self.order = FlashUtil.getLayerOrder(timeline.layerCount, index)
	self.layerType = data.layerType;
	self.visible = data.visible
	self.frameCount = data.frameCount;
	self.elementsCache = {};

	local framesData = data.frames
	self.keyFrames = {};

	for i=1,#framesData do
		local frameData = framesData[i]
		local keyFrame = self:createKeyFrameByData(i, framesData)
		self.keyFrames[#self.keyFrames+1] = keyFrame;
		self:cacheFrameElements(keyFrame)
	end

	self.frames = {};
	for index,keyFrame in ipairs(self.keyFrames) do
		for i=1,keyFrame.duration do
			self.frames[#self.frames+1] = keyFrame;
		end
	end
end

function Layer:cacheFrameElements(frame)
	local elementDatas = frame.elementsData;

	for index,elementData in ipairs(elementDatas) do
		self:cacheOneElement(elementData, index, frame)
	end
end

function Layer:cacheOneElement(elementData, eIndex, frame)
	local fIndex = frame.index;
	local frameName = frame.name
	local childAttr = elementData.childAttr
	-- dump(childAttr)
	local name = childAttr.itemName;
	local realtp;
	local tp = childAttr.tp
	if childAttr.loop 
		and tp == FlashConfig.itemTypes.Anm then
		realtp = FlashConfig.AnmSubTp.Gra;
	else
		realtp = tp
	end

	local cacheKey = FlashUtil.getElementCacheKey(name, realtp, eIndex, fIndex);
	local lastCacheKey =  FlashUtil.getElementCacheKey(name, realtp, eIndex, fIndex-1);
	local lastCacheData = self.elementsCache[lastCacheKey];
	local cacheData
	if lastCacheData then
		cacheData = lastCacheData;
	else
		cacheData = {};
	end
	cacheData.name = name
	self.elementsCache[cacheKey] = cacheData
	local insName = childAttr.insName
	if not insName then
		if frameName then
			insName = frameName .. "__" .. eIndex;
		end
	end
	if insName then
		-- printInfo("insName:" .. insName)
		self.timeline:addInsNameData(insName, cacheData, childAttr)
	end
end

function Layer:getElementCacheData(key)
	return self.elementsCache[key]
end

function Layer:createKeyFrameByData(index, framesData)
	local keyFrame;
	local lastFrameData = framesData[index-1];
	local curFrameData = framesData[index];
	local nextFrameData = framesData[index+1];

	keyFrame = Frame:create(curFrameData, index, self)
	if keyFrame:isMotion() then
		if nextFrameData then
			keyFrame:setNextAttrByFrameData(nextFrameData)
		end
	end

	return keyFrame;
end

function Layer:updateBlendMode(blendMode)
	for _,cacheData in pairs(self.elementsCache) do
		local realNode = cacheData.child or cacheData.ins
		local blendMode  = self.mc.pblendMode or self.mc.blendMode
		if realNode  then
			if realNode.setPBlendMode then
				realNode:setPBlendMode(blendMode)
			end

			if cacheData.tp == FlashConfig.itemTypes.Img then
				-- print("set " .. cacheData.name .. " blendMode to:" .. tostring(blendMode))
				if blendMode == "add" then
					realNode:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
				else
					realNode:setBlendFunc(cc.blendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA))
				end
			end
		end
	end
end

function Layer:updateFrame(frame, det)
	if frame > self.frameCount then
		if self.curFrameObj then
			self.curFrameObj:exit();
			self.curFrameObj = nil;
		end
		self.curFrame = frame;
		return;
	end

	local newFrameObj = self.frames[frame];
	if self.curFrameObj ~= newFrameObj then
		if self.curFrameObj then
			self.curFrameObj:exit(newFrameObj);
		end
		self.curFrameObj = newFrameObj;
		newFrameObj:enter(frame, det);
	else
		self.curFrameObj:enter(frame, det);
	end

end

function Layer:cleanup()
	for k,v in pairs(self.elementsCache) do
		local ins = v.ins
		if ins then
			if ins.removeSelfAndClean then
				ins:removeSelfAndClean()
			else
				ins:removeSelf()
			end
			v.ins = nil;
		end

		local child = v.child
		if child then
			if child.removeSelfAndClean then
				child:removeSelfAndClean()
			else
				child:removeSelf()
			end
			v.child = nil;
		end
	end
end

return Layer;