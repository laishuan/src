-- Mc.lua
local Timeline = import(".Timeline");

local Mc = class("Mc", cc.Sprite)

function Mc:ctor(data, doc)
	self.doc = doc;
	self.name = data.name;
	self.frameRate = doc.fileInfo.frameRate
	self.perFrameTime = 1/self.frameRate;
	self.timeline = Timeline:create(data.timeline, self);

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
	    local function update(dt)
	    	self:update(dt)
	    end
		self:scheduleUpdate(update);
	end
end

function Mc:setSpeed(setSpeed)
	
end

function Mc:onExit()
	-- printInfo("onExit:")
	self.isEnter = false;
	if self.isPlaying then
		self:unscheduleUpdate();
	end
end

function Mc:play()
	self:setUpdateStatus(true);
end

function Mc:stop()
	self:setUpdateStatus(false);
end

function Mc:gotoAndPlay()
	-- body
end

function Mc:gotoAndStop()
	-- body
end

function Mc:setUpdateStatus(isPlaying)
	if not self.isEnter then
		self.isPlaying = isPlaying;
	else
		if self.isPlaying ~= isPlaying then
			if isPlaying then
			    local function update(dt)
			    	self:update(dt)
			    end
				self:scheduleUpdate(update);
			else
				self:unscheduleUpdate()
			end
		end
		self.isPlaying = isPlaying;
	end
end

function Mc:update(dt)
	self.total = self.total + dt;
	local curFrame = math.floor(self.total/self.perFrameTime);
	if curFrame >= self.timeline.frameCount then
		curFrame = 0;
		self.total = self.total % self.perFrameTime;
	end
	self.timeline:updateFrame(curFrame)
end

return Mc;