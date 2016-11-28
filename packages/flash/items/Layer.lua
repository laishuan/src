-- Layer.lua

local Frame = import(".Frame");

local Layer = class("Layer");

function Layer:ctor(data, index, timeline)
	self.timeline = timeline;
	self.mc = timeline.mc;

	self.order = (timeline.layerCount-index+1)*100
	self.layerType = data.layerType;
	self.visible = data.visible
	self.frameCount = data.frameCount;
	local framesData = data.frames

	self.keyFrames = {};
	local endFrameArr = {};
	for i=1,#framesData do
		local frameData = framesData[i]
		local keyFrame = Frame:create(frameData, self)
		if keyFrame:isMotion() then
			local nextFrameData = framesData[i+1];
			if nextFrameData then
				keyFrame:setNextAttrByFrameData(nextFrameData)
			end
		end
		self.keyFrames[#self.keyFrames+1] = keyFrame;
		endFrameArr[#endFrameArr+1] = frameData.startFrame + frameData.duration
	end

	local keyFrameIndex = 1;
	self.frames = {};
	for i=1,self.frameCount do
		local frameObj;
		if i <= endFrameArr[keyFrameIndex] then
			frameObj = self.keyFrames[keyFrameIndex];
		else
			keyFrameIndex = keyFrameIndex + 1;
			frameObj = self.keyFrames[keyFrameIndex];
		end
		assert(frameObj, string.format("Layer:ctor - bad layer data of %s, %s", timeline.mc.name, timeline.mc.doc.fileName))
		self.frames[#self.frames+1] = frameObj;
	end
end

function Layer:updateFrame(frame)
	if frame > self.frameCount then
		if self.curFrameObj then
			self.curFrameObj:exit();
			self.curFrameObj = nil;
		end
		self.curFrame = frame;
		return;
	end

	if self.curFrame ~= frame then
		local newFrameObj = self.frames[frame];
		if self.curFrameObj ~= newFrameObj then
			if self.curFrameObj then
				self.curFrameObj:exit();
			end
			self.curFrameObj = newFrameObj;
			newFrameObj:enter(frame);
		else
			self.curFrameObj:enter(frame);
		end
		self.curFrame = frame;
	end
end

return Layer;