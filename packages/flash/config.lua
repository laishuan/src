-- config.lua
local _M = {};

_M.jsonPath = "flashRes";
_M.luaPath = "flashRes"
_M.scriptPath = "app.flashScript"
_M.useSheet = false
_M.useContentTP = "lua";

_M.itemTypes = {
	Img = "Image",
	Anm = "Anim",
	Nod = "Node",
	Txt = "Text",
	LK = "Link",
}
_M.AnmSubTp = {
	Gra = "Graphic",
	Btn = "Button",
	Spt = "FSprite",
	Mov = "Movieclip"
}

_M.defaultNodeName = "__DefaultNode";
_M.defaultTxtName = "__Text";
_M.defaultFnt = "STXIHEI.ttf"
-- _M.showTextFrame = true
-- _M.showBtnFrame = true
_M.TextFrameTag = 33567;
return _M;