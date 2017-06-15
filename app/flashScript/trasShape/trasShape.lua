-- templet.lua

local trasShape = class("trasShape",cc.load("flash").BaseFSController)


function trasShape:ctor(fsprit, subData)
	trasShape.super.ctor(self, fsprit, subData)
end

function trasShape:onCreate()
	-- self.fsprit:setEndCallBack(function ( ... )
	-- 	self.fsprit:stop()
	-- end)
end

function trasShape:bindAllIns()
	-- All Ins Bind 

end

function trasShape:onSetData(data)
end

function trasShape:onEnter(from)
end

function trasShape:onExit()
end

function trasShape:onCleanup()
end

return trasShape