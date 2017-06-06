-- FSprite.lua

local FlashConfig = import("..config")
local FlashUtil = import("..util")

local Timeline = import(".Timeline");
local FNode = import('.FNode')

local FSprite = class("FSprite", FNode)

function FSprite:ctor(data, doc, subTpData)
	FSprite.super.ctor(self, data, doc, subTpData)

	self.group = subTpData.group
	self.blendMode = subTpData.blendMode
	self.pblendMode = subTpData.pblendMode
	self.timeline = Timeline:create(data.timeline, self);
	self.frameCount = self.timeline.frameCount;
	self.controllerData = subTpData.data
	-- if subTpData.data then
	-- 	self:setData(subTpData.data)
	-- end
	self.timeline:updateFrame(0, 0)
	if data.script then
		local scriptPath = FlashUtil.getScriptPath(data.script, doc.fileName)
		local ScriptClass = require(scriptPath)
		self.controller = ScriptClass:create(self, subTpData)
	end
end

-- function FSprite:onEnter()
-- 	FSprite.super.onEnter(self)
-- end

-- function FSprite:onExit()
-- 	FSprite.super.onExit(self)
-- end

-- function FSprite:onEnterTransitionFinish()
-- 	FSprite.super.onEnterTransitionFinish(self)
-- end

-- function FSprite:onExitTransitionStart()
-- 	FSprite.super.onExitTransitionStart(self)
-- end

-- function FSprite:onCleanup()
-- 	-- printInfo("onCleanup")
-- 	FSprite.super.onCleanup(self)
-- end

function FSprite:removeSelfAndClean( ... )
	if self.controller then
		self.controller:cleanup()
	end
	self.timeline:cleanup()
	FSprite.super.removeSelfAndClean(self)
end

function FSprite:getChildByName(insName)
	return self.timeline:getChildByName(insName)
end

function FSprite:setBlendMode(blendMode)
	if blendMode ~= self.blendMode then
		self.blendMode = blendMode
		self.timeline:updateBlendMode()
	end
end

function FSprite:setPBlendMode(blendMode)
	if blendMode ~= self.pblendMode then
		self.pblendMode = blendMode
		self.timeline:updateBlendMode()
	end
end


return FSprite;