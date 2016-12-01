-- config.lua
local _M = {};

_M.path = "flashRes";

_M.useContentTP = "lua";

_M.itemTypes = {
	Img = "Image",
	Anm = "Anim",
	Nod = "Node",
	Txt = "Text",
	LK = "Link",
	Spt = "FSprite"

}
_M.AnmSubTp = {
	Gra = "Graphic",
}
return _M;