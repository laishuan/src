-- templet.lua

local mainScene = class("mainScene",cc.load("flash").BaseFSController)


function mainScene:ctor(fsprit, subData)
	mainScene.super.ctor(self, fsprit, subData)
	-- All Ins Bind 
	self.startBtn = self.fsprit:getChildByName("startBtn") -- Button
	self.startAnim = self.fsprit:getChildByName("startAnim") -- Movieclip

	self.data = subData.data

	self.startAnim:stop()
	self.startBtn:setClickFunc(function ( ... )
		self.startAnim:gotoAndPlay(1)
	end)
end

function mainScene:onEnter(from)
end

function mainScene:onExit()
end

function mainScene:onCleanup()
end

return mainScene