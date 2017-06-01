-- templet.lua

local actionHurtSkill1 = class("actionHurtSkill1", FBaseController)

function actionHurtSkill1:ctor(FView)
	actionHurtSkill1.super.ctor(self, FView)
	--__Content_Ctor
end

function actionHurtSkill1:removeSelfAndClean( ... )
	actionHurtSkill1.super.removeSelfAndClean(...)
	--__Content_removeSelfAndClean
end

return actionHurtSkill1