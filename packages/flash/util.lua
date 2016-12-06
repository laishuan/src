-- util.lua
local PATH = ...

local FlashConfig = import(".config");
local _M = {};

function _M.getJsonPath (fileName)
	return FlashConfig.path .. "/" .. fileName .. "/" .. fileName .. ".json";
end

function _M.getLuaPath (fileName)
	return FlashConfig.path .. "." .. fileName .. "." .. fileName;
end

function _M.getPlistPath (fileName)
	return FlashConfig.path .. "/" .. fileName .. "/" .. fileName .."image.plist";
end

function _M.createImage(itemData, doc)
	local sprite = cc.Sprite:createWithSpriteFrameName(itemData.path);
	sprite:setAnchorPoint(cc.p(0, 1));
	return sprite;
end

function _M.createAnim(itemData, doc, subTpData)
	local ret
	if subTpData.loop and subTpData.firstFrame then
		local Cls = import(".items.Graphic", PATH);
		ret = Cls:create(itemData, doc, subTpData)
	else
		local Mc = import(".items.Mc", PATH)
		ret = Mc:create(itemData, doc, subTpData);
	end
	return ret
end

function _M.createNode(itemData, doc, subTpData)
	local Fnode = import(".items.FNode", PATH)
	local node = Fnode:create()
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
	return label
end

function _M.createLink(itemData, doc, subTpData)
	local flash = doc.flash;
	return flash:createMC(itemData.flashName, itemData.itemName, subTpData);
end

function _M.createFSprite(itemData, doc, subTpData)
	local FSprite = import(".items.FSprite", PATH)
	local ret = FSprite:create(itemData, doc, subTpData);
	return ret
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

	if attr.blendMode == "add" then
		node:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
	end

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
    ttfConfig.fontSize = subTpData.size
	local ttfPath = "fonts/" .. subTpData.face .. ".ttf";
	local fullPath = cc.FileUtils:getInstance():fullPathForFilename(ttfPath);
	if io.exists(fullPath) then
	    ttfConfig.fontFilePath = ttfPath
	else
		ttfConfig.fontFilePath = "fonts/" .. FlashConfig.defaultFnt;
	end
    ttfConfig.glyphs=cc.GLYPHCOLLECTION_DYNAMIC
    ttfConfig.customGlyphs = nil
	ttfConfig.distanceFieldEnabled = true
	label:setTTFConfig(ttfConfig)
	label:setString(subTpData.txt)
	-- label:setString("你好")

	-- label =  cc.Label:createWithSystemFont(subTpData.txt, subTpData.face, fontSize)

	label:setAlignment(alignment, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label:setDimensions(subTpData.width, subTpData.height)
    label:setAnchorPoint(cc.p(0,1.0))
    label:setTextColor(cc.c4b(tonumber(subTpData.r, 10), 
    	tonumber(subTpData.g, 10), 
    	tonumber(subTpData.b, 10), 
    	255))
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

return _M;