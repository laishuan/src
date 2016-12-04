-- FSprite.lua

local Timeline = import(".Timeline");
local FNode = import('.FNode')

local FSprite = class("FSprite", FNode)

function FSprite:ctor(data, doc, subTpData)
	self.doc = doc;
	self.name = data.name;
	self.loop = subTpData.loop;
	self.firstFrame = subTpData.firstFrame
	self.group = subTpData.group
	self.timeline = Timeline:create(data.timeline, self);
	self.frameCount = self.timeline.frameCount;
	self.timeline:updateFrame(0, 0)
end

function FSprite:removeSelfAndClean( ... )
	self:removeSelf()
	self.timeline:cleanup()
end

function FSprite:getChildByName(insName)
	return self.timeline:getChildByName(insName)
end

return FSprite;