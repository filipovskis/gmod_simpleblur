# Simple Blur
Cheap blur for user interfaces

# Usage example
```lua
function PANEL:Paint( w, h )
  local x, y = self:LocalToScreen(0, 0)
  draw.Blur(-x, -y)
end
```
