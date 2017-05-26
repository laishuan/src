-- Graphic.lua

-- Graphic.lua
local FSprite = import('.FSprite')

local Graphic = class("Graphic", FSprite)

function Graphic:ctor(data, doc, subTpData)
	Graphic.super.ctor(self, data, doc, subTpData)
	self.loop = subTpData.loop or "loop";
	self.firstFrame = subTpData.firstFrame or 1
end

function Graphic:refreshAttr(data)
	self.loop = data.loop;
	self.firstFrame = data.firstFrame
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