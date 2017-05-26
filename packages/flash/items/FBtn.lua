-- FBtn.lua
local FlashConfig = import("..config")
local FlashUtil = import("..util")

local FSprite = import('.FSprite')

local FBtn = class("FBtn", FSprite)

function FBtn:ctor(data, doc, subTpData)
	data = self:transData(data)
	FBtn.super.ctor(self, data, doc, subTpData)
	-- dump(data, "test_after_trans:" .. self.name, 15)
	self:initTouch()
end

function FBtn:transData(data)
	local newLayerData = {}
	newLayerData.layerType = "normal"
	newLayerData.visible = true
	newLayerData.frameCount = 4
	local elements = {}
	newLayerData.frames = {
		{
			startFrame = 0,
			duration = 4,
			isEmpty = false,
			elements = elements,
		}
	}

	local ret = clone(data)
	local layers = ret.timeline.layers

	for index,layer in ipairs(layers) do

		local frame = self:findLayerFrameByIndex(layer, 4)
		if frame then
			local frameElements = frame.elements
			for i,v in ipairs(frameElements) do
				elements[#elements+1] = v
				local data = v.childAttr
				v.childAttr = {}

				v.childAttr.tp = FlashConfig.itemTypes.Nod
				v.childAttr.itemName = FlashConfig.defaultNodeName
				v.childAttr.insName = "touchBound" .. #elements
				v.childAttr.canTouch = true
				v.childAttr.bound = data.bound
				v.childAttr.x = data.x
				v.childAttr.y = data.y
			end
		end
	end
	table.insert(layers, 1, newLayerData)
	ret.timeline.layerCount = ret.timeline.layerCount + 1
	if ret.timeline.frameCount < 4 then
		ret.timeline.frameCount = 4
	end
	return ret
end

function FBtn:initTouch()
   	local function onMyTouchBegan( touch,event )
   		local target = event:getCurrentTarget()
   		local touchPos = target:convertToNodeSpace(touch:getLocation())
   		local bound = target.bound
   		-- printInfo("x:%s y:%s", touchPos.x, touchPos.y)
   		-- printInfo("x:%s y:%s w:%s h:%s", bound.x, bound.y, bound.width, bound.height)
   		if cc.rectContainsPoint(bound, touchPos) then
	   		self.timeline:updateFrame(2, 0)
	   		-- printInfo("touchBegin")
	   		target.isTouchBegin = true
	   		return true
	   	end
	   	target.isTouchBegin = false
	   	return false
    end
    local function onMyTouchEnded(touch,event)
   		local target = event:getCurrentTarget()
   		local touchPos = target:convertToNodeSpace(touch:getLocation())
   		local bound = target.bound
   		local ret = false
   		if cc.rectContainsPoint(bound, touchPos) and target.isTouchBegin then
	    	if self.touchFunc then
	    		self.touchFunc()
	    	end
	    	-- printInfo("touchEnd")
	    	ret = true
	   	end
    	self.timeline:updateFrame(0, 0)
	   	return ret

    end

    local function onMyTouchMove(touch,event)
    	-- printInfo("touchMove")
    end

    local function onMyTouchCancelled(touch,event)
    	-- printInfo("touchCancelled")
    	local target = event:getCurrentTarget()
    	self.timeline:updateFrame(0, 0)
    	target.isTouchBegin = false
    	return true
    end
    

	local index = 1
	local touchBound = self.timeline:getChildByName("touchBound" .. index)
	while touchBound do
		-- printInfo("find touchBound of index:" .. index)
		local touchListen = cc.EventListenerTouchOneByOne:create()
	    touchListen:registerScriptHandler(onMyTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
	    touchListen:registerScriptHandler(onMyTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
	    touchListen:registerScriptHandler(onMyTouchMove,cc.Handler.EVENT_TOUCH_MOVED)
	    touchListen:registerScriptHandler(onMyTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED)

	    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	    eventDispatcher:addEventListenerWithSceneGraphPriority(touchListen,touchBound)
		index = index +1
		touchBound = self.timeline:getChildByName("touchBound" .. index)
	end
end

function FBtn:findLayerFrameByIndex(layer, index)
	local frames = layer.frames
	for i,frame in ipairs(frames) do
		local endIndex = frame.startFrame + frame.duration
		if endIndex >= index then
			local ret = clone(frame)
			frame.elements = {}
			frame.isEmpty = true
			return ret
		end
	end
end

function FBtn:setClickFunc(func)
	self.touchFunc = func
end


return FBtn