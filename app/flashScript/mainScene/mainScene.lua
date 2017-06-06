-- templet.lua

local mainScene = class("mainScene",cc.load("flash").BaseFSController)


function mainScene:ctor(fsprit, subData)
	mainScene.super.ctor(self, fsprit, subData)
end

function mainScene:onCreate()
	printInfo("onCreate")
	self.startAnim:gotoAndStop(1)
	-- self.startAnim:setVisible(false)
	self.startAnim:setEndCallBack(function ( ... )
		self.startAnim:gotoAndStop(1)
	end)
	self.startBtn:setClickFunc(function ( ... )
		self.startAnim:gotoAndPlay(1)
	end)
end

function mainScene:bindAllIns()
	-- All Ins Bind 
	self.startBtn = self.fsprit:getChildByName("startBtn") -- Button
	self.startAnim = self.fsprit:getChildByName("startAnim") -- Movieclip

end

function mainScene:onSetData(data)
end

function mainScene:onEnter(from)
end

function mainScene:onExit()
end

function mainScene:onCleanup()
end

return mainScene