-- Frame.lua

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
	if #self.elements == 0 then
		for index,elementData in ipairs(self.elementsData) do
			local elementNode = self:createOneElementByData(elementData, index);
			local attr = self:getAttrByFrame(elementData, frame);
			self:setNodeAttrByData(elementNode, attr);
			self.elements[#self.elements+1] = elementNode;
		end
	else
		for i=1,#self.elements do
			local elementData = self.elementsData[i]
			local elementNode = self.elements[i]
			local attr = self:getAttrByFrame(elementData, frame);
			self:setNodeAttrByData(elementNode, attr);
		end
	end
end

function Frame:getAttrByFrame(elementData, frame)
	local detFrame = frame - (self.startFrame + 1);

	if detFrame == 0 then
		return elementData.attr;
	end

	if not self.nextAttr then
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

	local ret;
	if childAttr.x == 0 and childAttr.y == 0 then
		local instance = doc:createInstance(childAttr.itemName)
		instance:addTo(self.mc, elementOrder, childAttr.name)
		ret = instance;
	else
		local node = cc.Sprite:create();
		node:addTo(self.mc, elementOrder)
		local instance = doc:createInstance(childAttr.itemName)
		instance:addTo(node, 1, childAttr.name):move(childAttr.x, childAttr.y)
		ret = node;
	end

	if childAttr.loop and childAttr.firstFrame then
		-- ret:
	end

	return ret;
end

function Frame:setNodeAttrByData(node, attr)
	node:move(attr.x, attr.y);

	local skewX = attr.skewX or 0;
	node:setRotationSkewX(skewX);

	local skewY = attr.skewY or 0;
	node:setRotationSkewY(skewY);

	local scaleX = attr.scaleX or 1;
	node:setScaleX(scaleX);

	local scaleY = attr.scaleY or 1;
	node:setScaleY(scaleY);

	if attr.blendMode == "add" then
		node:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
	else
		node:setBlendFunc(cc.blendFunc(gl.ONE, gl.ONE))
	end
end

local interpolatioByKey = function (key, attr1, attr2, default, percentage, ret)
	local value1 = attr1[key] or default;
	local value2 = attr2[key] or default;
	local newV
	if value1 == value2 then
		newV = value1;
	else
		newV = value1 + (value2-value1)*percentage;
	end 
	ret[key] = newV;
end

local interpolatioByKey2 = function (key, attr1, attr2, default, percentage, ret)
	local value1 = attr1[key] or default;
	local value2 = attr2[key] or default;
	local newV

	if value1 == value2 then
		newV = value1;
	else
		local sub = value2-value1;
		if sub < - 180 then
			sub = sub + 360
		end

		if sub > 180 then
			sub = sub - 360;
		end
		newV = value1 + sub*percentage;
	end 
	ret[key] = newV;
end

function Frame:interpolatioAttr(attr1, attr2, percentage)
	local ret = {};

	interpolatioByKey("x", attr1, attr2, 0, percentage, ret)
	interpolatioByKey("y", attr1, attr2, 0, percentage, ret)
	interpolatioByKey2("skewX", attr1, attr2, 0, percentage, ret)
	interpolatioByKey2("skewY", attr1, attr2, 0, percentage, ret)
	interpolatioByKey("scaleX", attr1, attr2, 1, percentage, ret)
	interpolatioByKey("scaleY", attr1, attr2, 1, percentage, ret)

	return ret;
end

return Frame;