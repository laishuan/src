-- Frame.lua
local FlashUtil = import("..util")
local FlashConfig = import("..config")

local Frame = class("Frame");

function Frame:ctor(data, layer)
	self.layer = layer;
	self.mc = layer.mc;

	self.startFrame = data.startFrame;
	self.duration = data.duration
	self.tweenType = data.tweenType;
	self.isEmpty = data.isEmpty;
	self.elementsData = data.elements;
	self.elements = {};
end

function Frame:isMotion()
	return self.tweenType == "motion"
end

function Frame:setNextAttrByFrameData(frameData)
	self.nextAttr = frameData.elements[1].attr;
end

function Frame:enter(frame)
	if self.isEmpty then
		return;
	end
	local detFrame = frame - (self.startFrame + 1)
	if #self.elements == 0 then
		for index,elementData in ipairs(self.elementsData) do
			local elementNode = self:createOneElementByData(elementData, index);
			local attr = self:getAttrByFrame(elementData, detFrame);
			FlashUtil.setNodeAttrByData(elementNode, attr);
			if iskindof(elementNode, FlashConfig.AnmSubTp.Gra) then
				elementNode:updateFrame(detFrame)
			end
			self.elements[#self.elements+1] = elementNode;
		end
	else
		for i=1,#self.elements do
			local elementData = self.elementsData[i]
			local elementNode = self.elements[i]
			local attr = self:getAttrByFrame(elementData, detFrame);
			FlashUtil.setNodeAttrByData(elementNode, attr);
			if iskindof(elementNode, FlashConfig.AnmSubTp.Gra) then
				elementNode:updateFrame(detFrame)
			end
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

	return self:interpolatioAttr(elementData.attr, self.nextAttr, detFrame/self.duration)
end

function Frame:exit()
	for _,node in ipairs(self.elements) do
		node:removeSelf()
	end
	self.elements = {}
end

function Frame:createOneElementByData(elementData, index)
	local attr = elementData.attr;
	local childAttr = elementData.childAttr;
	local layerOrder = self.layer.order;
	local elementOrder = layerOrder + index;
	local doc = self.mc.doc

	local tpData;
	if childAttr.loop and childAttr.firstFrame then
		tpData = {};
		tpData.subTp = FlashConfig.AnmSubTp.Gra;
		tpData.loop = loop;
		tpData.firstFrame = firstFrame;
	end

	local ret;
	if childAttr.x == 0 and childAttr.y == 0 then
		local instance = doc:createInstance(childAttr.itemName, tpData)
		instance:addTo(self.mc, elementOrder, childAttr.name)
		ret = instance;
	else
		local node = FlashUtil.createNode();
		node:addTo(self.mc, elementOrder)
		local instance = doc:createInstance(childAttr.itemName, tpData)
		instance:addTo(node, 1, childAttr.name):move(childAttr.x, childAttr.y)
		ret = node;
	end



	return ret;
end

function Frame:interpolatioAttr(attr1, attr2, percentage)
	local ret = {};

	FlashUtil.interpolatioByKey("x", attr1, attr2, 0, percentage, ret)
	FlashUtil.interpolatioByKey("y", attr1, attr2, 0, percentage, ret)
	FlashUtil.interpolatioByKeySkew("skewX", attr1, attr2, 0, percentage, ret)
	FlashUtil.interpolatioByKeySkew("skewY", attr1, attr2, 0, percentage, ret)
	FlashUtil.interpolatioByKey("scaleX", attr1, attr2, 1, percentage, ret)
	FlashUtil.interpolatioByKey("scaleY", attr1, attr2, 1, percentage, ret)

	return ret;
end

return Frame;