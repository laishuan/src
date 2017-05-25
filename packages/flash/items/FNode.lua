-- FNode.lua
local FlashConfig = import("..config")
local FlashUtil = import("..util")

local FNode = class("FNode", cc.Sprite)

local totalRetain = 0
local totalRelease = 0
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
	local cnt = self.retainHash[node]
	if not cnt then
		cnt = 0
		self.retainHash[node] = cnt
	end
	self.retainHash[node] = self.retainHash[node] + 1
end

-- function FNode:releaseNode(node, name)
-- 	printInfo("releaseNode self name:%s release name:%s",self.name, name)
-- 	printInfo("befor")
-- 	self:showRetainHash()
-- 	node:release()
-- 	totalRelease = totalRelease + 1
-- 	if self.retainHash[name] then
-- 		local cnt = self.retainHash[name] - 1
-- 		if cnt <= 0 then
-- 			self.retainHash[name] = nil
-- 		else
-- 			self.retainHash[name] = cnt
-- 		end
-- 	end
-- 	printInfo("after")
-- 	self:showRetainHash()
-- 	printInfo("end retainCnt,releaseCnt:%s,%s", totalRetain, totalRelease)

-- end



function FNode:showRetainHash()
	dump(self.retainHash, self.name, 15)
end

function FNode:removeSelfAndClean()
	for node,cnt in pairs(self.retainHash) do
		for i=1,cnt do
			node:release()
			totalRelease = totalRelease + 1
		end
	end
	self.retainHash = {}
	self:removeSelf()
	printInfo("end retainCnt,releaseCnt:%s,%s", totalRetain, totalRelease)
end

return FNode;