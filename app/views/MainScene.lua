
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    local Flash = cc.load("flash")

    local addBtn = Flash:createBtn("shanzeichui", "add")
    addBtn:addTo(self, 10):move(420, 200)

    local removeBtn = Flash:createBtn("shanzeichui", "remove")
    removeBtn:addTo(self, 10):move(220, 200)

    addBtn:setClickFunc(function ( ... )
        if self.testMc then
            self.testMc:removeSelfAndClean()
        end
        self.testMc = Flash:createMovie("shanzeichui", "wait"):addTo(self, 1):move(0, 0)
        self.testMc:setEndCallBack(function ( ... )
            self.testMc:stop()
        end)
        -- addBtn:showGlobalRetainCache()
    end)

    removeBtn:setClickFunc(function ( ... )
        if self.testMc then
            self.testMc:removeSelfAndClean()
            self.testMc = nil
            addBtn:showGlobalRetainCache()
        end
    end)
end

-- function MainScene:createShape()
--     local shapeName = "shap" .. math.random(5)
--     local shapeMc = self.flash:createSpt("mainScene", shapeName)
--     local baseName = "base" .. math.random(9)
--     for i=1,6 do
--         local pos = "p" .. i
--         local posNode = shapeMc:getChildByName(pos)
--         if posNode then
--             local baseMc = self.flash:createSpt("mainScene", baseName)
--             posNode:addChild(baseMc)
--         end
--     end
--     return shapeMc
-- end

return MainScene
