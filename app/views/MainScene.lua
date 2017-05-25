
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    local Flash = cc.load("flash")
    self.flash = Flash
    local i = 1
    while i < 100 do 
        local view = Flash:createMC("shanzeichui", "wait")
        view:addTo(self):move(0, 0)
        view:removeSelfAndClean()
        i = i + 1
    end
    -- return
    -- local nextShap = view:getChildByName("ui"):getChildByName("nextShap")
    -- local score = view:getChildByName("ui"):getChildByName("txtScore")
    -- local shapNode = nextShap:getChildByName("shap")
    -- local shapeMc = self:createShape()
    -- shapNode:addChild(shapeMc)

    -- local frameCount = 0
    -- local shapeCnt = 0
    -- local shapeArr = {}
    -- view:setEachFrameCallBack(function ( ... )
    --     frameCount = frameCount + 1
    --     if frameCount == 50 then
    --         frameCount = 0
    --         shapeCnt = shapeCnt + 1
    --         score:setString(shapeCnt)
    --         local shapeMc = self:createShape()
    --         shapeMc:addTo(self):move(math.random(1, 600), 1000):setScale(0.4)
    --         shapeArr[shapeCnt] = shapeMc
    --     end

    --     local removeKeys = {}
    --     for k,v in pairs(shapeArr) do
    --         local y = v:getPositionY() - 100
    --         v:move(v:getPositionX(), y)
    --         if y <= -100 then
    --             removeKeys[k] = true
    --         end
    --     end

    --     for k,_ in pairs(removeKeys) do
    --         local shape = shapeArr[k]
    --         shape:removeSelfAndClean()
    --         shapeArr[k] = nil
    --     end
    -- end)
end

function MainScene:createShape()
    local shapeName = "shap" .. math.random(5)
    local shapeMc = self.flash:createSpt("mainScene", shapeName)
    local baseName = "base" .. math.random(9)
    for i=1,6 do
        local pos = "p" .. i
        local posNode = shapeMc:getChildByName(pos)
        if posNode then
            local baseMc = self.flash:createSpt("mainScene", baseName)
            posNode:addChild(baseMc)
        end
    end
    return shapeMc
end

return MainScene
