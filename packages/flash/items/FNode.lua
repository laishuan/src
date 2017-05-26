-- FNode.lua
local FlashConfig = import("..config")
local FlashUtil = import("..util")

local FNode = class("FNode", cc.Sprite)

local totalRetain = 0
local totalRelease = 0
local nodeRetainCache = {}
function FNode:ctor(data, doc, subTpData)
	self.doc = doc;
	self.name = data.name
	self.frameRate = doc.fileInfo.frameRate
	self.retainHash = {}
end

-- function FNode:onEnter()

-- end

-- function FNode:onExit()

-- end

-- function FNode:onEnterTransitionFinish()

-- end

-- function FNode:onExitTransitionStart()

-- end

-- function FNode:onCleanup()
	
-- end

function FNode:retainNode(node, name)
	node:retain()
	totalRetain = totalRetain + 1
	if not nodeRetainCache[name] then
		nodeRetainCache[name] = 0
	end
	nodeRetainCache[name] = nodeRetainCache[name] + 1

	local data = self.retainHash[node]
	if not data then
		data = {}
		data.cnt = 0
		data.name = name
		self.retainHash[node] = data
	end
	data.cnt = data.cnt + 1
end

function FNode:releaseNode(node, name)
	node:release()
	totalRelease = totalRelease + 1
	if nodeRetainCache[name] then
		nodeRetainCache[name] = nodeRetainCache[name] - 1
	end
	local data = self.retainHash[node]
	if data then
		data.cnt = data.cnt - 1
		if data.cnt <= 0 then
			self.retainHash[node] = nil
		end
	end
end

function FNode:removeSelfAndClean()
	-- printInfo("%s:removeSelfAndClean", self.name)
	for node,data in pairs(self.retainHash) do
		for i=1,data.cnt do
			self:releaseNode(node, data.name)
		end
	end
	-- dump(self.retainHash)
	self.retainHash = {}
	self:removeSelf()
end

function FNode:showGlobalRetainCache()
	dump(nodeRetainCache)
	printInfo("end retainCnt,releaseCnt:%s,%s", totalRetain, totalRelease)
end

return FNode;