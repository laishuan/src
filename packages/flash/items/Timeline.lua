-- Timeline.lua
local Layer = import(".Layer");

local Timeline = class("Timeline");

function Timeline:ctor(data, mc)
	self.mc = mc;
	self.frameCount = data.frameCount;
	self.layerCount = data.layerCount;
	self.layers = {};
	local layersData = data.layers;
	for i=1,self.layerCount do
		local layerData = layersData[i]
		local layer = Layer:create(layerData, i, self)
		self.layers[#self.layers+1] = layer;
	end
end

function Timeline:updateFrame(frame)
	local newFrame = frame + 1;
	if self.curFrame ~= newFrame then
		self.curFrame = newFrame;
		-- printInfo("curFrame:" .. curFrame)
		for i=1,self.layerCount do
			local layer = self.layers[i];
			layer:updateFrame(newFrame)
		end
	end
end

return Timeline;