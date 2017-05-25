-- Mc.lua
local FSprite = import('.FSprite')

local Mc = class("Mc", FSprite)

function Mc:ctor(data, doc, subTpData)
	self:onNodeEvent("enter", self.onEnter);
	self:onNodeEvent("exit", self.onExit);
	-- self:onNodeEvent("enterTransitionFinish", self.onEnterTransitionFinish);
	-- self:onNodeEvent("exitTransitionStart", self.onExitTransitionStart);
	-- self:onNodeEvent("cleanup", self.onCleanup);
	
	Mc.super.ctor(self, data, doc, subTpData)
	assert(self.group, "Mc-ctor: group must not be null, name:" .. self.name)
	

	self.perFrameTime = 1000/self.frameRate;
	self.oneLoopTime = (self.timeline.frameCount/self.frameRate)*1000

	self.isPlaying = true;
	self.total = 0;
end



function Mc:onEnter()
	-- Mc.super.onEnter(self)
	self.isEnter = true;
	if self.isPlaying then
		self.group:addMc(self)
	end
end


function Mc:setSpeed(speed)
	self.group:setSpeed(speed)
end

function Mc:onExit()
	-- Mc.super.onExit(self)
	self.isEnter = false;
	if self.isPlaying then
		self.group:removeMc(self)
	end
end

function Mc:play()
	self:setUpdateStatus(true);
end

function Mc:stop()
	self:setUpdateStatus(false);
end

function Mc:gotoAndPlay(frame)
	self.timeline.lastFrame = frame-1;
	self:resetTotal();
	self:updateFrame(frame-1, 0);
	self:play()
end

function Mc:gotoAndStop(frame)

	self.timeline.lastFrame = frame-1;
	self:resetTotal();
	self:updateFrame(frame-1, 0);
	self:stop();
end

function Mc:setFrameCallBack(frame, func)
	self.timeline:setFrameCallBack(frame, func)
end

function Mc:setEndCallBack(func)
	self.timeline:setEndCallBack(func)
end

function Mc:setEachFrameCallBack(func)
	self.timeline:setEachFrameCallBack(func)
end

function Mc:getChildByName(insName)
	return self.timeline:getChildByName(insName)
end

function Mc:resetTotal()
	self.total = 0
end

function Mc:setUpdateStatus(isPlaying)
	if not self.isEnter then
		self.isPlaying = isPlaying;
	else
		if self.isPlaying ~= isPlaying then
			if isPlaying then
				self.group:addMc(self)
			else
				self.group:removeMc(self)
			end
		end
		self.isPlaying = isPlaying;
	end
end

function Mc:update(dt)
	self.total = self.total + dt;

	local curFrame = math.floor(self.total/self.perFrameTime);
	local det = (self.total%self.perFrameTime)/self.perFrameTime
	local frameCount = self.timeline.frameCount;
	if curFrame >= frameCount then
		self.total = self.total - self.oneLoopTime
		curFrame =  math.floor(self.total/self.perFrameTime);
		self.timeline.lastFrame = 0;
	end

	if det < 0.01 then
		det = 0
	end
	self.timeline:updateFrame(curFrame, det)
end

function Mc:updateFrame(detFrame, det)
	det = det or 0
	self.total = self.total + (detFrame+det)*self.perFrameTime;
	self.timeline:updateFrame(detFrame, 0)
end

return Mc;