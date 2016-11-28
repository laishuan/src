-- util.lua
local FlashConfig = import(".config");
local Mc = import(".items.Mc")
local cc = _G.cc;
local _M = {};
setfenv(1, _M)

function getJsonPath (fileName)
	return FlashConfig.path .. "/" .. fileName .. "/" .. fileName .. ".json";
end

function getLuaPath (fileName)
	return FlashConfig.path .. "." .. fileName .. "." .. fileName;
end

function getPlistPath (fileName)
	return FlashConfig.path .. "/" .. fileName .. "/" .. fileName .."image.plist";
end

function createImage(itemData, doc)
	local sprite = cc.Sprite:createWithSpriteFrameName(itemData.name);
	sprite:setAnchorPoint(cc.p(0, 1));
	return sprite;
end

function createAnim(itemData, doc)
	return Mc:create(itemData, doc);
end

function createNode(itemData, doc)
	local node = cc.Sprite:create()
	return node;
end

function createText(itemData, doc)
	local node = cc.Node:create()
	return node;
end

function createLink(itemData, doc)
	local flash = doc.flash;
	return flash:createMC(itemData.flashName, itemData.itemName);
end



return _M;