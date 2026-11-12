clear_palette()
local FLt = {
  pile{{"raw umber", 1}, {"red earth", 0.6}, {"bone black", 0.12}, {"lead white", 0.12}},
  pile{{"raw umber", 0.8}, {"red earth", 0.8}, {"yellow ochre", 0.3}, {"lead white", 0.45}},
  pile{{"lead white", 1.3}, {"red earth", 0.4}, {"yellow ochre", 0.45}, {"green earth", 0.45}, {"bone black", 0.03}},
  pile{{"lead white", 2.3}, {"red earth", 0.28}, {"yellow ochre", 0.35}, {"vermilion", 0.05}, {"green earth", 0.1}},
  pile{{"lead white", 3.2}, {"vermilion", 0.09}, {"yellow ochre", 0.25}},
  pile{{"lead white", 4}, {"Naples yellow", 0.35}, {"vermilion", 0.03}},
}
local function sph(cx, cy, r)
  return function(x, y)
    local dx, dy = (x - cx) / r, (y - cy) / r
    local d2 = dx * dx + dy * dy
    if d2 > 1 then return 0.3 end
    local nz = math.sqrt(1 - d2)
    local d = -0.62 * dx - 0.58 * dy + 0.53 * nz
    return clamp(((d + 0.55) / 1.55) ^ 1.35, 0, 1)
  end
end
local function tent(list, vf)
  local o = {}
  for i, p in ipairs(list) do
    local c = (i - 1) / (#list - 1)
    o[#o + 1] = {p, function(x, y) return math.max(0, 1 - math.abs(vf(x, y) - c) * (#list - 1)) + 0.001 end}
  end
  return o
end
local function test(cx, mode)
  local M = ellipse(cx, 750, 90, 90)
  local v = sph(cx, 750, 90)
  if mode == "C" then
    for _, pw in ipairs(tent(FLt, v)) do stipple(M, {pile=pw[1], width=3, coverage=function(x, y) return 5 * pw[2](x, y) end, clip=M}) end
  else
    work(M, {hand="body", piles=tent(FLt, v), coverage=3, fill=true, clip=M, tool="filbert 4", length={6, 14},
      angle=function(x,y) return math.atan(y-750, x-cx) + 1.57 end})
  end
  if mode == "B" or mode == "C" then
    blend(M:shrink(2), {tool={kind="badger", width=12}, length={8, 16}, angle=function(x,y) return math.atan(y-750, x-cx) + 1.57 end})
  end
end
test(150, "A"); test(400, "B"); test(650, "C")
