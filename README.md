# Simple Blur
Cheap blur snippet for vgui elements

# Usage example
```lua
function PANEL:Paint( w, h )
  local x, y = self:LocalToScreen(0, 0)
  draw.Blur(-x, -y)
end
```
