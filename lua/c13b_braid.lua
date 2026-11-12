clear_palette()
-- the coazzone: the hair gathered behind into a braid, bound in a ribbon
local bl = {
  pile{{"raw umber", 1.3}, {"bone black", 0.45}, {"red earth", 0.3}, name="braid 0"},
  pile{{"raw umber", 1.1}, {"red earth", 0.6}, {"yellow ochre", 0.3}, name="braid 1"},
  pile{{"raw umber", 0.7}, {"red earth", 0.5}, {"yellow ochre", 0.9}, {"lead white", 0.25}, name="braid 2"},
  pile{{"yellow ochre", 1}, {"Naples yellow", 0.4}, {"raw umber", 0.3}, {"lead white", 0.5}, name="braid 3"},
}
local function cl(t) return lerp(652, 668, t), lerp(470, 760, t) end
local n = 13
for i = 0, n - 1 do
  local t = (i + 0.5) / n
  local x, y = cl(t)
  local side = (i % 2 == 0) and -1 or 1
  local w = lerp(24, 15, t)
  local cx, cy = x + side * w * 0.22, y
  local lobe = ellipse(cx, cy, w * 0.62, 15):roughen(1, 6, i) * HAIR
  local vf = function(px, py)
    local u = (px - cx) / (w * 0.62)
    local v = (py - cy) / 15
    return clamp(0.75 - 0.45 * u - 0.5 * v - 0.25 * t, 0, 1)
  end
  work(lobe, {hand="body", piles=tents(bl, vf, 0, 1), coverage=3, fill=true, angle=1.57 + side * 0.6, clip=lobe,
    tool="filbert 3", length={6, 14}})
end
-- the ribbon wound round it, dark with a glint
local rb = brush{kind="round", width=2.4, point=0.5}
local rp = pile{{"bone black", 1}, {"raw umber", 0.4}, {"rose madder", 0.3}, name="ribbon"}
for i = 0, n - 1, 2 do
  local t = (i + 1) / n
  local x, y = cl(t)
  rb:reload(rp, 0.6)
  rb:gesture({{x - 16, y - 6, 0.3}, {x, y + 1, 0.5}, {x + 15, y + 8, 0.3}}, {clip=HAIR})
end
