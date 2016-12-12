-- Doc.lua

local FlashUtil = import(".util")
local FlashConfig = import(".config");

local Doc = class("Doc")

function Doc:ctor(fileName, flash)
	local docTable;
	if FlashConfig.useContentTP == 'json' then
		local fileUtils = cc.FileUtils:getInstance()
		local jsonPath = FlashUtil.getJsonPath(fileName)
		local fullPath = fileUtils:fullPathForFilename(jsonPath)
		local c = io.readfile(fullPath)
		assert(c, string.format("Doc:ctor - no content in file \"%s\"", fullPath))
		docTable = json.decode(c)
	elseif FlashConfig.useContentTP == 'lua' then 
		local luaPath = FlashUtil.getLuaPath(fileName)
		docTable = require(luaPath);
	end

	local plistPath = FlashUtil.getPlistPath(fileName);
	cc.SpriteFrameCache:getInstance():addSpriteFrames(plistPath)

	self.fileName = fileName;
	self.flash = flash;
	self.library = docTable.library
	self.fileInfo = docTable.fileInfo
	self.scene = docTable.scene;
	self.linkFiles = docTable.linkFiles;
end

function Doc:createInstance(itemName, data)
	local itemData;
	if itemName == "scene" then
		itemData = self.scene;
	else
		itemData = self.library[itemName];
	end
	assert(itemData, "Doc:createInsByData, itemData is nil name:" .. itemName)
	return self:createInsByData(itemData, data);
end

function Doc:createInsByData(itemData, data)

	assert(itemData, "Doc:createInsByData, itemData is nil")
	local ins = FlashUtil["create" .. itemData.tp](itemData, self, data);
	if ins then
		if ins.setCascadeOpacityEnabled and ins.setCascadeColorEnabled then
			ins:setCascadeOpacityEnabled(true)
			ins:setCascadeColorEnabled(true)
		end
		return ins;
	end
end

function Doc:stopAllEffectByName(musicPath)
	local musicPathData = self.allMusicEffect[musicPath];
	if not musicPathData then
		return false;
	else
		for soundId,_ in pairs(musicPathData) do
			AudioEngine.stopEffect(soundId)
		end
		self.allMusicEffect[musicPath] = nil
		return true
	end
end

function Doc:addSoundIDByName(musicPath, soundId)
	if not self.allMusicEffect then
		self.allMusicEffect = {};
	end
	local musicPathData = self.allMusicEffect[musicPath];
	if not musicPathData then
		musicPathData = {}
		self.allMusicEffect[musicPath] = musicPathData;
	end

	musicPathData[soundId] = true;
end

return Doc;