local FlashUtil = import(".util")
local FlashConfig = import(".config");
local Doc = import(".Doc");
local McGroup = import(".McGroup")

local Flash = {}

Flash.docs = {};
local defaultGroup = McGroup:create("___defaule___")

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

function Flash:createMcByType(tp, fileName, itemName, group)
	local mcGroup = group and McGroup:create(group) or defaultGroup
	local doc = self:getDocByName(fileName)
	local subTpData = {}
	subTpData.group = mcGroup
	subTpData.subTp = tp
	itemName = itemName or "scene";
	return doc:createInstance(itemName, subTpData);
end

function Flash:createMovie(fileName, itemName, group)
	return self:createMcByType(FlashConfig.AnmSubTp.Mov, fileName, itemName, group)
end

function Flash:createBtn(fileName, itemName, group)
	return self:createMcByType(FlashConfig.AnmSubTp.Btn, fileName, itemName, group)
end

function Flash:createGra(fileName, itemName, group)
	return self:createMcByType(FlashConfig.AnmSubTp.Gra, fileName, itemName, group)
end

return Flash
