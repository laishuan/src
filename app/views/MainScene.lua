
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("你好", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)


    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("flashRes/test/testimage.plist")
    local Flash = cc.load("flash")
    local x = math.random(200, 300)
    local y = math.random(200, 300)
    -- local waitAnim = Flash:createMC("mojiaoxiaobinggou", "Skill1"):addTo(self):move(x, y)
    -- local dao = waitAnim:getChildByName("dao")
    -- local xuecao = Flash:createMC("mojiaoxiaobinggou", "xuecao")
    -- dao:add(xuecao, 2000)
    -- waitAnim:setSpeed(1)
    x = math.random(500, 600)
    y = math.random(200, 300)
    local waitAnim = Flash:createMC("mojiaoxiaobinggou", "Skill2")
    -- local bujian1 = waitAnim:getChildByName("bujian1")
    local txt1 = waitAnim:getChildByName("asdf")
    local txt2 = waitAnim:getChildByName("woqu")
    -- txt1:setString("不去了啊！")
    -- txt2:setString("哈哈哈")
    waitAnim:addTo(self):move(0, 0)
    -- waitAnim:gotoAndPlay(30)
    -- waitAnim:setEndCallBack(function ( ... )
    --     waitAnim:gotoAndPlay(45)
    --     printInfo("anim end")
    -- end)

    -- waitAnim:setFrameCallBack(3, function ( ... )
    --     printInfo("anim call back frame 3")
    -- end)

    --     waitAnim:setFrameCallBack(4, function ( ... )
    --     printInfo("anim call back frame 4")
    -- end)
    -- waitAnim:stop()
    -- waitAnim:gotoAndStop(1)
    -- waitAnim:gotoAndStop(5)
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
