
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)


    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("flashRes/test/testimage.plist")
    local Flash = cc.load("flash")
        local x = math.random(200, 300)
        local y = math.random(200, 300)
        local waitAnim = Flash:createMC("mojiaoxiaobinggou", "wait"):addTo(self):move(x, y)
        local dao = waitAnim:getChildByName("dao")
        local xuecao = Flash:createMC("mojiaoxiaobinggou", "xuecao")
        dao:add(xuecao, 2000)
    printLog("Flash", "All run")
    printInfo((nil == nil))

    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("flashRes/effectGlobalFYN02/effectGlobalFYN02image.plist")
    -- local sprite = cc.Sprite:createWithSpriteFrameName("Image_1_test.png")
    -- sprite:addTo(self);
    -- sprite:setPosition(cc.p(100, 100))

    -- sprite = cc.Sprite:createWithSpriteFrameName("Image_1_effectGlobalFYN02.png")
    -- sprite:addTo(self);
    -- sprite:setPosition(cc.p(200, 200))
end

return MainScene
