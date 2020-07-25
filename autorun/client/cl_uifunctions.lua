--[[
MIT License

Copyright (c) 2020 @scuroin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local render, shouldupdate = render
local rt = GetRenderTarget('blurscreen_cache', 256, 256)
local mat = CreateMaterial('blurscreen_cache', 'UnlitGeneric', {
	['$translucent'] = 1,
	['$alpha'] = 1,
	['$basetexture'] = rt:GetName(),
	['$vertexalpha'] = 1,
})

do
	local ScrW, ScrH = ScrW, ScrH
	
	function draw.Blur(x, y)
		local w, h = ScrW(), ScrH()
		render.SetMaterial(mat)
		render.DrawScreenQuadEx(x, y, w, h)
		shouldupdate = true
	end
end

do
	local cvRate = CreateConVar('r_blurframes', '31', FCVAR_ARCHIVE, '', 1, 61)
	local nextupd, blurvalue = 0, ScrW() / 256 + 3
	local screen = render.GetRefractTexture()

	local function DoBlur(rt)
		render.PushRenderTarget(rt)
		render.DrawTextureToScreen(screen)
		render.BlurRenderTarget(rt, blurvalue, blurvalue, 3)
		render.PopRenderTarget()
	end

	hook.Add('PostDrawEffects', 'UpdateBlur', function()
		if shouldupdate ~= true then return end
		local now, w, h = RealTime(), ScrW(), ScrH()

		shouldupdate = false
		if now > nextupd then
			nextupd = now + (1 / cvRate:GetInt())

			render.UpdateRefractTexture()
			render.CopyTexture(screen, rt)
			DoBlur(rt)
		end
	end)
end
