local FlashUtil = import(".util")
local FlashConfig = import(".config");
local Doc = import(".Doc");

local Flash = {}

Flash.docs = {};

function Flash:createMC(fileName, itemName)
	assert(fileName and type(fileName) == "string", "Flash:createMC - invalid param fileName");
	assert((not itemName) or type(itemName) == "string", "Flash:createMC - invalid param itemName");
	itemName = itemName or "scene";

	local doc = self.docs[fileName];
	if not doc then
		doc = Doc:create(fileName, self);
		self.docs[fileName] = doc;
	end
	return doc:createInstance(itemName);
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
