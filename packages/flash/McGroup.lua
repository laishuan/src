-- McGroup.lua

local FlashUtil = import(".util")
local FlashConfig = import(".config");

local McGroup = class("McGroup")

function McGroup:ctor(name)
	self.name = name;
	self.scheduler =  cc.Director:getInstance():getScheduler()
	self.mcHash = {}
	self.mcCount = 0
	self.entry = nil
	self.speed = 1
end

function McGroup:setSpeed(speed)
	if speed then
		self.speed = speed
	end 
end

function McGroup:pause()
	self:stop()
end

function McGroup:resume()
	self:start()
end

function McGroup:addMc(mc)
	self.mcHash[mc] = true
	self.mcCount = self.mcCount + 1
	if self.mcCount > 0 then
		self:start()
	end
end

function McGroup:removeMc(mc)
	if self.mcHash[mc] then
		self.mcHash[mc] = nil
		self.mcCount = self.mcCount - 1
		if self.mcCount <= 0 then
			self:stop()
		end
	end
end

function McGroup:update(dt)
	for mc,_ in pairs(self.mcHash) do
		mc:update(dt*1000*self.speed)
	end
end

function McGroup:start()
	if not self.entry then
		local update = function (dt)
			self:update(dt)
		end
		self.entry = self.scheduler:scheduleScriptFunc(update, CUR_ANIM_INTERVAL, false)
	end
end

function McGroup:stop()
	if self.entry then
		self.scheduler:unscheduleScriptEntry(self.entry)
		self.entry = nil
	end
end

return McGroup