-- templet.lua

local shanzeichui = class("shanzeichui", FBaseController)

function shanzeichui:ctor(FView)
	shanzeichui.super.ctor(self, FView)
	--__Content_Ctor
end

function shanzeichui:removeSelfAndClean( ... )
	shanzeichui.super.removeSelfAndClean(...)
	--__Content_removeSelfAndClean
end

return shanzeichui