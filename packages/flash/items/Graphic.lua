-- Graphic.lua

-- Graphic.lua
local Timeline = import(".Timeline");

local Graphic = class("Graphic", cc.Sprite)

function Graphic:ctor(data, doc, subTpData)
	self.doc = doc;
	self.name = data.name;
	self.timeline = Timeline:create(data.timeline, self);
	self.frameCount = self.timeline.frameCount;
	self.loop = subTpData.loop;
	self.firstFrame = subTpData.firstFrame
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

return Graphic;