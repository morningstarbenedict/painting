clear_palette()
-- the braid again, darker: slanting lobes plaited left and right, the ribbon over them
local bl = {
  pile{{"raw umber", 1.3}, {"bone black", 0.5}, {"red earth", 0.3}, name="braid 0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.5}, {"bone black", 0.15}, name="braid 1"},
  pile{{"raw umber", 1}, {"red earth", 0.55}, {"yellow ochre", 0.45}, name="braid 2"},
  pile{{"raw umber", 0.7}, {"yellow ochre", 0.9}, {"red earth", 0.35}, {"lead white", 0.2}, name="braid 3"},
}
local function cl(t) return lerp(650, 666, t), lerp(455, 775, t) end
local BR = HAIRBACK * mask(function(x, y) return smoothstep(440, 470, y) end) - NECK:shrink(1)
-- the whole braid first in its shadow
work(BR, {hand="body", pile=bl[1], coverage=2.5, fill=true, angle=1.5, clip=BR, tool="filbert 4", length={8, 20}})
local n = 15
for i = 0, n - 1 do
  local t = (i + 0.5) / n
  local x, y = cl(t)
  local side = (i % 2 == 0) and -1 or 1
  local w = lerp(22, 14, t)
  local a = side * 0.55
  local pts = {}
  for k = 0, 19 do
    local u = 2 * math.pi * k / 20
    local ex, ey = w * 0.6 * math.cos(u), 13 * math.sin(u)
    pts[#pts + 1] = {x + side * w * 0.2 + ex * math.cos(a) - ey * math.sin(a), y + ex * math.sin(a) + ey * math.cos(a)}
  end
  local lobe = poly(pts, true) * BR
  local cx, cy = x + side * w * 0.2, y
  local vf = function(px, py)
    local u = ((px - cx) * math.cos(a) + (py - cy) * math.sin(a)) / (w * 0.6)
    local v = (-(px - cx) * math.sin(a) + (py - cy) * math.cos(a)) / 13
    return clamp(0.62 - 0.35 * u - 0.45 * v - 0.3 * t, 0, 1)
  end
  work(lobe, {hand="body", piles=tents(bl, vf, 0, 1), coverage=3, fill=true, angle=1.57 + a, clip=lobe,
    tool="filbert 2.5", length={5, 12}})
end
local rb = brush{kind="round", width=2.2, point=0.5}
local rp = pile{{"bone black", 1}, {"raw umber", 0.4}, {"rose madder", 0.3}, name="ribbon"}
for i = 0, n - 1, 2 do
  local t = (i + 1) / n
  local x, y = cl(t)
  rb:reload(rp, 0.55)
  rb:gesture({{x - 14, y - 6, 0.25}, {x, y + 1, 0.45}, {x + 13, y + 7, 0.25}}, {clip=BR})
end
