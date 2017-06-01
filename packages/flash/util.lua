-- util.lua
local PATH = ...

local FlashConfig = import(".config");
local _M = {};

function _M.getJsonPath (fileName)
	return FlashConfig.jsonPath .. "/" .. fileName .. "/" .. "FlashInfo.json";
end

function _M.getLuaPath (fileName)
	return FlashConfig.luaPath .. "." .. fileName .. "." .. "FlashInfo.lua";
end

function _M.getSpliteLuaPath(fileName, itemName)
	return FlashConfig.luaPath .. "." .. fileName .. "." .. itemName;
end

function _M.getPlistPath (fileName)
	return FlashConfig.jsonPath .. "/" .. fileName .. "/" .. fileName .."image.plist";
end

function _M.getMusicPath(musicName)
	return FlashConfig.jsonPath .. "/" .. musicName;
end

function _M.createImage(itemData, doc, subTpData)
	local sprite = cc.Sprite:createWithSpriteFrameName(itemData.path);
	sprite:setAnchorPoint(cc.p(0, 1));
	if subTpData.blendMode == "add" or subTpData.pblendMode == "add" then
		sprite:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
	end
	return sprite;
end


function _M.createAnim(itemData, doc, subTpData)
	local ret
	if subTpData.subTp == FlashConfig.AnmSubTp.Gra then
		local Cls = import(".items.Graphic", PATH);
		ret = Cls:create(itemData, doc, subTpData)
	elseif subTpData.subTp == FlashConfig.AnmSubTp.Btn then
		local FBtn = import(".items.FBtn", PATH)
		ret = FBtn:create(itemData, doc, subTpData)
	elseif subTpData.subTp == FlashConfig.AnmSubTp.Spt then
		local FSprite = import(".items.FSprite", PATH)
		ret = FSprite:create(itemData, doc, subTpData);
	elseif subTpData.subTp == FlashConfig.AnmSubTp.Mov then 
		local Mc = import(".items.Mc", PATH)
		ret = Mc:create(itemData, doc, subTpData);
	end
	return ret
end

local currentMusicPath
function _M.createMusic(itemData, doc, subTpData)
	local musicPath = _M.getMusicPath(itemData.path);
	local isLoop = (subTpData.soundLoopMode == "loop")
	if subTpData.soundSync == "start" then
		if AudioEngine.isMusicPlaying() and currentMusicPath ~= musicPath then
			AudioEngine.stopMusic(true)
			AudioEngine.playMusic(musicPath, isLoop)
			currentMusicPath = musicPath
		end
	end

	if subTpData.soundSync == "stop" then
		if currentMusicPath == musicPath then
			if AudioEngine.isMusicPlaying() then
				AudioEngine.stopMusic(true)
				currentMusicPath = nil
			end
		end
		doc:stopAllEffectByName(musicPath);
	end

	if subTpData.soundSync == "event" then
		local soundID = AudioEngine.playEffect(musicPath, isLoop);
		doc:addSoundIDByName(musicPath, soundID);
	end
end

function _M.createNode(itemData, doc, subTpData)
	local Fnode = import(".items.FNode", PATH)
	local node = Fnode:create(itemData, doc, subTpData)
	local bound = subTpData.bound
	if subTpData.canTouch then
		local width = math.abs(bound.left - bound.right)
		local height = math.abs(bound.bottom - bound.top)
		local anchorX, anchorY
		node.bound = cc.rect(bound.left, -bound.bottom, width, height)
		anchorX = -bound.left/width
		anchorY = bound.bottom/height
		-- printInfo("anchorX:" .. anchorX .. " anchorY:" .. anchorY)
		node:setAnchorPoint(cc.p(anchorX, anchorY))
		-- node:setContentSize(cc.size(width, height))
	    if FlashConfig.showBtnFrame then
			local fangkuai = node:getChildByTag(FlashConfig.TextFrameTag)
			if not fangkuai then
			    fangkuai = cc.Sprite:create("fangkuai.png")
			    fangkuai:setAnchorPoint(cc.p(anchorX,anchorY))
			    fangkuai:addTo(node, 1, FlashConfig.TextFrameTag):move(0, 0)
		 	end
		    fangkuai:setScaleX(width/10)
		    fangkuai:setScaleY(height/10)
		    fangkuai:setOpacity(60)
		end
	end
	return node;
end

function _M.createText(itemData, doc, subTpData)
	-- local label;

 --    local alignment;
 --    if subTpData.alignment == "left"
 --    	or subTpData.alignment == "justify" then
 --    	alignment = cc.TEXT_ALIGNMENT_LEFT;
	-- elseif subTpData.alignment == "center" then
	-- 	alignment = cc.TEXT_ALIGNMENT_CENTER
	-- elseif subTpData.alignment == "right" then
	-- 	alignment = cc.TEXT_ALIGNMENT_RIGHT
 --    end
 --    local fontSize = subTpData.size
 --    local fontType = subTpData.face;

	-- local ttfConfig = {};
 --    ttfConfig.fontSize = subTpData.size
	-- local ttfPath = "fonts/" .. subTpData.face .. ".ttf";
	-- local fullPath = cc.FileUtils:getInstance():fullPathForFilename(ttfPath);
	-- if io.exists(fullPath) then
	--     ttfConfig.fontFilePath = ttfPath
	-- else
	-- 	ttfConfig.fontFilePath = "fonts/" .. FlashConfig.defaultFnt;
	-- end
 --    ttfConfig.glyphs=cc.GLYPHCOLLECTION_DYNAMIC
 --    ttfConfig.customGlyphs = nil
	-- ttfConfig.distanceFieldEnabled = true
	-- label = cc.Label:create()
	-- label:setTTFConfig(ttfConfig)
	-- label:setString(subTpData.txt)
	-- -- label:setString("你好")

	-- -- label =  cc.Label:createWithSystemFont(subTpData.txt, subTpData.face, fontSize)

	-- label:setAlignment(alignment, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	-- label:setDimensions(subTpData.width, subTpData.height)
 --    label:setAnchorPoint(cc.p(0,1.0))
 --    label:setTextColor(cc.c4b(tonumber(subTpData.r, 10), 
 --    	tonumber(subTpData.g, 10), 
 --    	tonumber(subTpData.b, 10), 
 --    	255))
	-- return label;

	local label = cc.Label:create()
	label:setAnchorPoint(cc.p(0,1))
	return label
end

function _M.createLink(itemData, doc, subTpData)
	local flash = doc.flash;
	return flash:createMC(itemData.flashName, itemData.itemName, subTpData);
end

function _M.interpolatioByKey (key, attr1, attr2, default, percentage, ret)
	local value1 = attr1[key] or default;
	local value2 = attr2[key] or default;
	local newV
	if value1 == value2 then
		newV = value1;
	else
		newV = value1 + (value2-value1)*percentage;
	end 
	ret[key] = newV;
end

function _M.interpolatioByKeySkew (key, attr1, attr2, default, percentage, ret)
	local value1 = attr1[key] or default;
	local value2 = attr2[key] or default;
	local newV

	if value1 == value2 then
		newV = value1;
	else
		local sub = value2-value1;
		if sub < - 180 then
			sub = sub + 360
		end

		if sub > 180 then
			sub = sub - 360;
		end
		newV = value1 + sub*percentage;
	end 
	ret[key] = newV;
end

function _M.interpolatioByKeySkewCW (key, attr1, attr2, default, percentage, ret, totalAngle)
	local value1 = attr1[key] or default;
	local value2 = attr2[key] or default;
	local newV

	if value1 == value2 then
		newV = value1;
	else
		local sub = value2-value1;
		if sub < 0 then
			sub = sub + 360
		end
		newV = value1 + sub*percentage + totalAngle*percentage;
		if newV > 360 then
			newV = newV % 360
		end

	end 
	ret[key] = newV;
end

function _M.interpolatioByKeySkewCCW (key, attr1, attr2, default, percentage, ret, totalAngle)
	local value1 = attr1[key] or default;
	local value2 = attr2[key] or default;
	local newV

	if value1 == value2 then
		newV = value1;
	else
		local sub = value2-value1;
		if sub > 0 then
			sub = sub - 360
		end
		newV = value1 + sub*percentage + totalAngle*percentage;
		if newV < -360 then
			newV = newV % 360
		end

	end 
	ret[key] = newV;
end

function _M.interpolatioAttr(attr1, attr2, percentage, totalAngle)
	local ret = {};

	_M.interpolatioByKey("x", attr1, attr2, 0, percentage, ret)
	_M.interpolatioByKey("y", attr1, attr2, 0, percentage, ret)
	if not totalAngle then
		_M.interpolatioByKeySkew("skewX", attr1, attr2, 0, percentage, ret)
		_M.interpolatioByKeySkew("skewY", attr1, attr2, 0, percentage, ret)
	elseif totalAngle > 0 then
		_M.interpolatioByKeySkewCW("skewX", attr1, attr2, 0, percentage, ret, totalAngle)
		_M.interpolatioByKeySkewCW("skewY", attr1, attr2, 0, percentage, ret, totalAngle)
	elseif totalAngle < 0 then
		_M.interpolatioByKeySkewCCW("skewX", attr1, attr2, 0, percentage, ret, totalAngle)
		_M.interpolatioByKeySkewCCW("skewY", attr1, attr2, 0, percentage, ret, totalAngle)
	end
	_M.interpolatioByKey("scaleX", attr1, attr2, 1, percentage, ret)
	_M.interpolatioByKey("scaleY", attr1, attr2, 1, percentage, ret)
	_M.interpolatioByKey("alpha", attr1, attr2, 255, percentage, ret)
	_M.interpolatioByKey("rp", attr1, attr2, 100, percentage, ret)
	_M.interpolatioByKey("gp", attr1, attr2, 100, percentage, ret)
	_M.interpolatioByKey("bp", attr1, attr2, 100, percentage, ret)

	return ret;
end

function _M.setNodeAttrByData(node, attr)
	node:move(attr.x, attr.y);

	local skewX = attr.skewX or 0;
	node:setRotationSkewX(skewX);

	local skewY = attr.skewY or 0;
	node:setRotationSkewY(skewY);

	local scaleX = attr.scaleX or 1;
	node:setScaleX(scaleX);

	local scaleY = attr.scaleY or 1;
	node:setScaleY(scaleY);

	local alpha = attr.alpha or 255
	node:setOpacity(math.floor(alpha))

	local rp = attr.rp or 100
	local gp = attr.gp or 100
	local bp = attr.bp or 100
	if rp+gp+bp < 300 then
		rp = math.floor(rp*2.55)
		gp = math.floor(gp*2.55)
		bp = math.floor(bp*2.55)
		-- printInfo("rp:" .. rp .. " gp:" .. gp .. " bp:" .. bp)
		node:setColor(cc.c3b(rp,gp,bp))
	end
end

function _M.setTextAttr(label, subTpData)
    local alignment;
    if subTpData.alignment == "left"
    	or subTpData.alignment == "justify" then
    	alignment = cc.TEXT_ALIGNMENT_LEFT;
	elseif subTpData.alignment == "center" then
		alignment = cc.TEXT_ALIGNMENT_CENTER
	elseif subTpData.alignment == "right" then
		alignment = cc.TEXT_ALIGNMENT_RIGHT
    end
    local fontSize = subTpData.size
    local fontType = subTpData.face;

	local ttfConfig = {};
    ttfConfig.fontSize = fontSize
	local ttfPath = "fonts/" .. subTpData.face .. ".ttf";
	local fullPath = cc.FileUtils:getInstance():fullPathForFilename(ttfPath);
	if io.exists(fullPath) then
	    ttfConfig.fontFilePath = ttfPath
	else
		ttfConfig.fontFilePath = "fonts/" .. FlashConfig.defaultFnt;
	end
    ttfConfig.glyphs=cc.GLYPHCOLLECTION_DYNAMIC
    ttfConfig.customGlyphs = nil
	ttfConfig.distanceFieldEnabled = false
	label:setTTFConfig(ttfConfig)
	-- label:setString("你好")

	-- label =  cc.Label:createWithSystemFont(subTpData.txt, subTpData.face, fontSize)

	label:setAlignment(alignment, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	-- label:setDimensions(subTpData.width, subTpData.height)
    -- label:setAnchorPoint(cc.p(0,0.5))
    label:setTextColor(cc.c4b(tonumber(subTpData.r, 10), 
    	tonumber(subTpData.g, 10), 
    	tonumber(subTpData.b, 10), 
    	255))
	label:setString(subTpData.txt)
    if FlashConfig.showTextFrame then
		local fangkuai = label:getChildByTag(FlashConfig.TextFrameTag)
		if not fangkuai then
		    fangkuai = cc.Sprite:create("fangkuai.png")
		    fangkuai:setAnchorPoint(cc.p(0,1.0))
		    fangkuai:addTo(label, 1, FlashConfig.TextFrameTag):move(0, subTpData.height)
	 	end
	    fangkuai:setScaleX(subTpData.width/10)
	    fangkuai:setScaleY(subTpData.height/10)
	    fangkuai:setOpacity(60)
	end
end

function _M.getElementCacheKey(name, tp, eIndex, fIndex)
	return  name .. "_" .. tp .. "_" .. eIndex .. "_" .. fIndex;
end

function _M.kindOfClass(obj, className)
	local class = obj.class
	if class and class.__cname == className then
		return true
	end
	return false
end

function _M.createClippingNode()
	local clip = cc.ClippingNode:create()  
	clip:setAlphaThreshold(0)  
	local node = cc.Sprite:create()
	clip:setStencil(node)
	return clip, node;
end

function _M.getLayerOrder(layerCount, layerIndex)
	return (layerCount-layerIndex+1)*100
end

local director = cc.Director:getInstance()
local view = director:getOpenGLView()
local framesize = director:getWinSize()
local w, h = framesize.width, framesize.height
local offsetH = h - CC_DESIGN_RESOLUTION.height;

function _M.getOffsetByAlign(align)
	return offsetH*align
end

return _M;