-- BaseFSController.lua

local FlashUtil = import(".util")
local FlashConfig = import(".config");

local BaseFSController = class("BaseFSController")

function BaseFSController:ctor(fsprit, subTp)
	self.fsprit = fsprit
	self.subTp = subTp
	printInfo("create controller : %s", fsprit.name)
end

return BaseFSController;