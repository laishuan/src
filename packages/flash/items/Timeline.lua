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
	local layersData = data.layers;
	for i=1,self.layerCount do
		local layerData = layersData[i]
		local layer = Layer:create(layerData, i, self)
		self.layers[#self.layers+1] = layer;
	end
end

function Timeline:addInsNameData(insName, cacheData, childAttr)
	local doc = self.mc.doc
	local itemName = childAttr.itemName
	local tpData;

	if childAttr.loop and childAttr.firstFrame then
		tpData = {};
		tpData.subTp = FlashConfig.AnmSubTp.Gra
		tpData.loop = childAttr.loop;
		tpData.firstFrame = childAttr.firstFrame;
	end

	local ins, child
	self.insNameCache[insName] = cacheData;
	if childAttr.x == 0 and childAttr.y == 0 then
		ins = doc:createInstance(itemName, tpData)
		ins:retain()
	else
		ins = FlashUtil.createNode();
		ins:retain();
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

end

function Timeline:cleanup()
	for i=1,self.layerCount do
		local layer = self.layers[i];
		layer:cleanup()
	end
end

return Timeline;