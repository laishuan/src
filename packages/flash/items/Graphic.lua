-- Graphic.lua

-- Graphic.lua
local Timeline = import(".Timeline");
local FNode = import('.FNode')

local Graphic = class("Graphic", FNode)

function Graphic:ctor(data, doc, subTpData)
	self.doc = doc;
	self.name = data.name;
	self.loop = subTpData.loop;
	self.firstFrame = subTpData.firstFrame
	self.group = subTpData.group
	self.timeline = Timeline:create(data.timeline, self);
	self.frameCount = self.timeline.frameCount;
end

function Graphic:updateFrame(frame, det)
	local realFrame;
	if self.loop == "loop" then
		realFrame = self.firstFrame + frame;
		if realFrame >= self.frameCount then
			realFrame = self.firstFrame;
		end
	end

	if self.loop == "play once" then
		realFrame = self.firstFrame + frame;
		if realFrame >= self.frameCount then
			realFrame = self.frameCount - 1;
		end
	end

	if self.loop == "single frame" then
		realFrame = self.firstFrame;
	end 
	self.timeline:updateFrame(realFrame, det)
end

function Graphic:removeSelfAndClean( ... )
	self:removeSelf()
	self.timeline:cleanup()
end

return Graphic;