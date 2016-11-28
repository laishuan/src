
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
    Flash:createMC("test", "Skill2"):addTo(self):move(300, 300)
    printLog("Flash", "All run")

    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("flashRes/effectGlobalFYN02/effectGlobalFYN02image.plist")
    -- local sprite = cc.Sprite:createWithSpriteFrameName("Image_1_test.png")
    -- sprite:addTo(self);
    -- sprite:setPosition(cc.p(100, 100))

    -- sprite = cc.Sprite:createWithSpriteFrameName("Image_1_effectGlobalFYN02.png")
    -- sprite:addTo(self);
    -- sprite:setPosition(cc.p(200, 200))
end

return MainScene
