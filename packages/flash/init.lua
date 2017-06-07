local FlashUtil = import(".util")
local FlashConfig = import(".config");
local Doc = import(".Doc");
local McGroup = import(".McGroup")
local defaultGroup = McGroup:create("___defaule___")
local BaseFSController = import(".BaseFSController")
local Flash = {}

Flash.docs = {};
Flash.BaseFSController = BaseFSController

function Flash:getDocByName(fileName)
	local doc = self.docs[fileName];
	if not doc then
		doc = Doc:create(fileName, self);
		self.docs[fileName] = doc;
	end
	return doc
end

function Flash:createMC(fileName, itemName, subTpData)
	assert(fileName and type(fileName) == "string", "Flash:createMC - invalid param fileName");
	assert((not itemName) or type(itemName) == "string", "Flash:createMC - invalid param itemName");
	itemName = itemName or "scene";
	local doc = self:getDocByName(fileName)
	if not subTpData then
		subTpData = {}
		subTpData.group = defaultGroup
		subTpData.subTp = FlashConfig.AnmSubTp.Mov
	end
	return doc:createInstance(itemName, subTpData);
end

function Flash:createMcByType(tp, fileName, itemName, subTpData)
	assert(not subTpData or type(subTpData) == "table", "Fhash:createMcByType - invalid param subTpData")
	local subTpData = subTpData or {}
	local mcGroup = subTpData.group and McGroup:create(subTpData.group) or defaultGroup
	subTpData.group = mcGroup
	subTpData.subTp = tp
	local doc = self:getDocByName(fileName)
	itemName = itemName or "scene";
	return doc:createInstance(itemName, subTpData);
end

function Flash:createMovie(fileName, itemName, subTpData)
	return self:createMcByType(FlashConfig.AnmSubTp.Mov, fileName, itemName, subTpData)
end

function Flash:createBtn(fileName, itemName, subTpData)
	return self:createMcByType(FlashConfig.AnmSubTp.Btn, fileName, itemName, subTpData)
end

function Flash:createGra(fileName, itemName, subTpData)
	return self:createMcByType(FlashConfig.AnmSubTp.Gra, fileName, itemName, subTpData)
end

function Flash:createFSprit(fileName, itemName, subTpData)
	return self:createMcByType(FlashConfig.AnmSubTp.Spt, fileName, itemName, subTpData)
end

return Flash
