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
	local sprite = cc.Sprite:createWithSpriteFrameName(itemData.name);
	sprite:setAnchorPoint(cc.p(0, 1));
	return sprite;
end

function _M.createAnim(itemData, doc, subTpData)
	if not subTpData then
		local Mc = import(".items.Mc", PATH)
		return Mc:create(itemData, doc);
	else
		local Cls = import(".items." .. subTpData.subTp, PATH);
		return Cls:create(itemData, doc, subTpData)
	end
end

function _M.createNode(itemData, doc)
	local node = cc.Sprite:create()
	return node;
end

function _M.createText(itemData, doc)
	local node = cc.Node:create()
	return node;
end

function _M.createLink(itemData, doc)
	local flash = doc.flash;
	return flash:createMC(itemData.flashName, itemData.itemName);
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

function _M.interpolatioAttr(attr1, attr2, percentage)
	local ret = {};

	_M.interpolatioByKey("x", attr1, attr2, 0, percentage, ret)
	_M.interpolatioByKey("y", attr1, attr2, 0, percentage, ret)
	_M.interpolatioByKeySkew("skewX", attr1, attr2, 0, percentage, ret)
	_M.interpolatioByKeySkew("skewY", attr1, attr2, 0, percentage, ret)
	_M.interpolatioByKey("scaleX", attr1, attr2, 1, percentage, ret)
	_M.interpolatioByKey("scaleY", attr1, attr2, 1, percentage, ret)

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
	else
		node:setBlendFunc(cc.blendFunc(gl.ONE, gl.ONE))
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

return _M;