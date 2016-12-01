local FlashUtil = import(".util")
local FlashConfig = import(".config");
local Doc = import(".Doc");
local McGroup = import(".McGroup")

local Flash = {}

Flash.docs = {};
Flash.defaultGroup = McGroup:create("___defaule___")

function Flash:createMC(fileName, itemName, group)
	assert(fileName and type(fileName) == "string", "Flash:createMC - invalid param fileName");
	assert((not itemName) or type(itemName) == "string", "Flash:createMC - invalid param itemName");
	itemName = itemName or "scene";

	local doc = self.docs[fileName];
	if not doc then
		doc = Doc:create(fileName, self);
		self.docs[fileName] = doc;
	end
	local data = {}
	data.group = group or McGroup:create()
	return doc:createInstance(itemName, data);
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
