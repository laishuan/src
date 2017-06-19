
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    local Flash = cc.load("flash")

    local gameMain = Flash:createFSprit("shanzeichui")
    gameMain:addTo(self):move(0, 0)
end



return MainScene
