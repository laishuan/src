-- FSprite.lua

local FlashUtil = import("..util")
local FNode = import('.FNode')

local FSprite = class("FSprite", FNode)

function FSprite:ctor(data, doc, subTpData)
	self.doc = doc;
	self.name = data.name;
	self.group = subTpData.group
	self.elementsData = data.element
	self.elements = {}
	self.insNameCache = {};
	for _,elementData in ipairs(self.elementsData) do
		local ins, child = self:createOneElement(elementData, doc, self.group)
		ins:addTo(self)
		self.elements[#self.elements+1] = ins
	end
end

function FSprite:createOneElement(elementData, doc, group)
	local attr = elementData.attr;
	local childAttr = elementData.childAttr;
	local itemName = childAttr.itemName
	local tpData = childAttr
	local ins, child
	tpData.group = group

	if childAttr.x == 0 and childAttr.y == 0 then
		ins = doc:createInstance(childAttr.itemName, tpData)
		ins:retain()
	else
		ins = FlashUtil.createNode();
		ins:retain();
		child = doc:createInstance(childAttr.itemName, tpData)
		child:addTo(ins, 1, childAttr.name):move(childAttr.x, childAttr.y)
	end
	FlashUtil.setNodeAttrByData(ins, attr)
	local insName = childAttr.insName;
	if childAttr.insName then
		self.insNameCache[childAttr.insName] = child or ins;
	end
	return ins, child
end

function FSprite:getChildByName(insName)
	return self.insNameCache[insName]
end

function FSprite:removeSelfAndClean()
	self:removeSelf()
	for index,ins in ipairs(self.elements) do
		ins:release()
	end
end

return FSprite;