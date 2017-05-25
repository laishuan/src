-- Timeline.lua
local Layer = import(".Layer");
local FlashUtil = import("..util")
local FlashConfig = import("..config")

local Timeline = class("Timeline");

function Timeline:ctor(data, mc)
	self.mc = mc;
	self.frameCount = data.frameCount;
	self.layerCount = data.layerCount;
	self.layers = {};
	self.insNameCache = {}
	self.allFrameCallBack = {}
	self.lastFrame = 0
	local layersData = data.layers;

	for i=1,self.layerCount do
		local layerData = layersData[i]
		local layer;
		local order = FlashUtil.getLayerOrder(self.layerCount, i);
		if layerData.layerType == "mask" then
			local clipNode, stencil = FlashUtil.createClippingNode()
			clipNode:addTo(self.mc, order);
			self.curClipNode = clipNode;
			layer = Layer:create(layerData, i, self, stencil)
		elseif layerData.layerType == "masked" then
			layer = Layer:create(layerData, i, self, self.curClipNode)
		elseif layerData.layerType == "normal" then
			local layerNode
			local align = layerData.align
			if align then
				layerNode = mc.doc:createInstance(FlashConfig.defaultNodeName, {name="layer"})
				local offsetY = FlashUtil.getOffsetByAlign(align)
				layerNode:addTo(self.mc, order):move(0, offsetY);
			end
			self.curClipNode = nil;
			layer = Layer:create(layerData, i, self, layerNode)
		end
		self.layers[#self.layers+1] = layer;
	end
end

function Timeline:setFrameCallBack(frame, func)
	self.allFrameCallBack[frame] = func
end

function Timeline:setEndCallBack(func)
	self.allFrameCallBack[self.frameCount] = func
end

function Timeline:setEachFrameCallBack(func)
	self.eachFrameCallBack = func
end

function Timeline:addInsNameData(insName, cacheData, childAttr)
	local doc = self.mc.doc
	local itemName = childAttr.itemName
	local tpData = childAttr;

	tpData.group = self.mc.group
	local ins, child
	self.insNameCache[insName] = cacheData;
	if childAttr.x == 0 and childAttr.y == 0 then
		ins = doc:createInstance(itemName, tpData)
		self.mc:retainNode(ins, itemName)
	else
		ins = doc:createInstance(FlashConfig.defaultNodeName, {});
		self.mc:retainNode(ins, FlashConfig.defaultNodeName)
		child = doc:createInstance(itemName, tpData)
		child:addTo(ins, 1, childAttr.name):move(childAttr.x, childAttr.y)
		cacheData.child = child
	end
	cacheData.ins = ins;
end


function Timeline:getChildByName(insName)
	local cacheData = self.insNameCache[insName]
	if cacheData then
		return cacheData.child or cacheData.ins
	end
end


function Timeline:updateFrame(frame, det)
	local newFrame = frame + 1;
	if newFrame > self.frameCount then
		newFrame = self.frameCount
	end
	if newFrame <= 0 then
		newFrame = 1
	end
	det = det or 0
	for i=1,self.layerCount do
		local layer = self.layers[i];
		layer:updateFrame(newFrame, det)
	end
	if self.eachFrameCallBack then
		self.eachFrameCallBack(newFrame)
	end
	for i=self.lastFrame+1,newFrame do
		local curFrameCallBack = self.allFrameCallBack[i]
		if curFrameCallBack then
			curFrameCallBack(newFrame)
		end
	end

	self.lastFrame = newFrame
end

function Timeline:updateBlendMode()
	for _,layer in ipairs(self.layers) do
		layer:updateBlendMode()
	end
end

function Timeline:cleanup()
	for i=1,self.layerCount do
		local layer = self.layers[i];
		layer:cleanup()
	end
end

return Timeline;