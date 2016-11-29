-- Layer.lua
local FlashConfig = import("..config")
local FlashUtil = import("..util")

local Frame = import(".Frame");

local Layer = class("Layer");

function Layer:ctor(data, index, timeline)
	self.timeline = timeline;
	self.mc = timeline.mc;

	self.order = (timeline.layerCount-index+1)*100
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
	local frameIndex = frame.index;

	for index,elementData in ipairs(elementDatas) do
		self:cacheOneElement(elementData, index, frameIndex)
	end
end

function Layer:cacheOneElement(elementData, eIndex, fIndex)
	local childAttr = elementData.childAttr
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
	self.elementsCache[cacheKey] = cacheData
	local insName = childAttr.insName
	if insName then
		printInfo("insName:" .. insName)
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
		if v.ins then
			v.ins:removeSelf()
			v.ins:release()
			v.ins = nil;
		end
	end
end

return Layer;