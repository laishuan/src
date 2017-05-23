local FlashUtil = import(".util")
local FlashConfig = import(".config");
local Doc = import(".Doc");
local McGroup = import(".McGroup")

local Flash = {}

Flash.docs = {};
Flash.defaultGroup = McGroup:create("___defaule___")

function Flash:createMC(fileName, itemName, subTpData)
	assert(fileName and type(fileName) == "string", "Flash:createMC - invalid param fileName");
	assert((not itemName) or type(itemName) == "string", "Flash:createMC - invalid param itemName");
	itemName = itemName or "scene";

	local doc = self.docs[fileName];
	if not doc then
		doc = Doc:create(fileName, self);
		self.docs[fileName] = doc;
	end
	if not subTpData then
		subTpData = {}
		subTpData.group = McGroup:create()
		subTpData.subTp = FlashConfig.AnmSubTp.Mov
	end
	return doc:createInstance(itemName, subTpData);
end

function Flash:createGroup(groupName)
	-- body
end

function Flash:preloadSync(...)
	
end

function Flash:preloadAsync( ... )
	-- body
end

return Flash
