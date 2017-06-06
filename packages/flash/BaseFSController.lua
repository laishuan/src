-- BaseFSController.lua

local FlashUtil = import(".util")
local FlashConfig = import(".config");

local BaseFSController = class("BaseFSController")

function BaseFSController:ctor(fsprit, subData)
	-- printInfo("BaseFSController ctor %s", fsprit.name)
	self.fsprit = fsprit
	self.subTp = subData.subTp
	self:bindAllIns()
	self:onCreate()
	self:onSetData(subData.data)
end

function BaseFSController:enter(from)
	-- printInfo("BaseFSController enter %s", self.fsprit.name)
	-- dump(from)
	self:onEnter(from)
end

function BaseFSController:exit()
	-- printInfo("BaseFSController exit %s", self.fsprit.name)
	self:onExit()
end

function BaseFSController:cleanup()
	-- printInfo("BaseFSController cleanup")
	self:onCleanup()
end

function BaseFSController:onCreate()
end

function BaseFSController:onSetData(data)
end

function BaseFSController:onEnter(from)
end

function BaseFSController:onExit(from)
end

function BaseFSController:bindAllIns()
end

function BaseFSController:onCleanup()
end


return BaseFSController;