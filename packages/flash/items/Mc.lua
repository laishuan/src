-- Mc.lua
local Timeline = import(".Timeline");

local Mc = class("Mc", cc.Sprite)

function Mc:ctor(data, doc, group)
	self.doc = doc;
	self.name = data.name;
	assert(group, "Mc-ctor: group must not be null, name:" .. self.name)
	self.group = group
	self.frameRate = doc.fileInfo.frameRate
	self.perFrameTime = 1000/self.frameRate;
	self.timeline = Timeline:create(data.timeline, self);
	self.oneLoopTime = (self.timeline.frameCount/self.frameRate)*1000

	self:onNodeEvent("enter", self.onEnter);
	self:onNodeEvent("exit", self.onExit);
	self:onNodeEvent("enterTransitionFinish", self.onEnterTransitionFinish);
	self:onNodeEvent("exitTransitionStart", self.onExitTransitionStart);
	self:onNodeEvent("cleanup", self.onCleanup);

	self.isPlaying = true;
	self.total = 0;
end



function Mc:onEnter()
	-- printInfo("onEnter:");
	self.isEnter = true;
	if self.isPlaying then
		self.group:addMc(self)
	end
end

function Mc:onCleanup()
	
end

function Mc:setSpeed(speed)
	self.group:setSpeed(speed)
end

function Mc:onExit()
	-- printInfo("onExit:")
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
	self:resetTotal();
	self:updateFrame(frame, 0);
	self:play()
end

function Mc:gotoAndStop(frame)
	self:resetTotal();
	self:updateFrame(frame, 0);
	self:stop();
end

function Mc:getChildByName(insName)
	return self.timeline:getChildByName(insName)
end

function Mc:resetTotal()
	self.total = 0
end

function Mc:removeSelfAndClean( ... )
	self:removeSelf()
	self.timeline:cleanup()
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