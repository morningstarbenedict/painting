clear_palette()
-- the hair falling into the braid without a seam; strands plaited across the lobes;
-- the lips shaped
local top = HAIR * rect(600, 400, 110, 140) * mask(function(x, y) return 1 - smoothstep(470, 530, y) end)
local hp = {
  pile{{"raw umber", 1.3}, {"bone black", 0.4}, {"red earth", 0.35}, name="hair d0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.55}, {"bone black", 0.15}, {"yellow ochre", 0.15}, name="hair d1"},
  pile{{"raw umber", 1}, {"red earth", 0.6}, {"yellow ochre", 0.5}, name="hair d2"},
}
local function hv(x, y) return HLV(x, y) * (1 - 0.6 * smoothstep(440, 520, y)) end
work(top, {hand="body", piles=tents_g(hp, hv, 0.15, 0.9, 1.4), coverage=2.6, fill=true, angle=1.45, clip=HAIR,
  tool="filbert 4", length={15, 40}})
-- strands over the braid's lobes, along each lobe's slant
local sd = pile{{"raw umber", 1.3}, {"bone black", 0.35}, {"red earth", 0.3}, name="strand dark"}
local sl = pile{{"yellow ochre", 0.9}, {"raw umber", 0.5}, {"red earth", 0.35}, {"lead white", 0.3}, name="strand light"}
local rb = brush{kind="rigger", width=1.3, point=0.9}
local function cl(t) return lerp(650, 666, t), lerp(455, 775, t) end
local n = 15
for i = 0, n - 1 do
  local t = (i + 0.5) / n
  local x, y = cl(t)
  local side = (i % 2 == 0) and -1 or 1
  local w = lerp(22, 14, t)
  local a = side * 0.55
  local cx, cy = x + side * w * 0.2, y
  for k = -2, 2 do
    local off = k * 3.2
    local ox, oy = -math.sin(a) * off, math.cos(a) * off
    local L = w * 0.55 * math.sqrt(1 - (k / 3) ^ 2)
    local p0 = {cx + ox - math.cos(a) * L, cy + oy - math.sin(a) * L}
    local p1 = {cx + ox + math.cos(a) * L, cy + oy + math.sin(a) * L}
    rb:reload((k <= -1) and sl or sd, 0.4)
    rb:gesture({{p0[1], p0[2], 0.05}, {(p0[1] + p1[1]) / 2, (p0[2] + p1[2]) / 2 - 1.2, 0.35}, {p1[1], p1[2], 0.05}}, {clip=HAIR})
  end
end
-- the lips: the upper turned down from the light, the lower rounding into shadow at its foot
local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
local upper = poly(cat(MOUTH.upper, rev(MOUTH.line)), true)
local lower = poly(cat(MOUTH.line, rev(MOUTH.lower)), true)
local lu = pile{{"lead white", 0.8}, {"rose madder", 0.3}, {"red earth", 0.4}, {"raw umber", 0.2}, name="upper lip dark"}
work(upper, {hand="detail", pile=lu, coverage=2.5, fill=true, clip=upper, tool={kind="round", width=1.6, point=0.4}, edge="soft"})
local my = MOUTH.center[2]
local ld = pile{{"lead white", 1}, {"rose madder", 0.2}, {"red earth", 0.35}, {"raw umber", 0.15}, name="lower lip shade"}
work(lower * mask(function(x, y) return smoothstep(my + 4, my + 9, y) end), {hand="detail", pile=ld, coverage=2, clip=lower:grow(0.8),
  tool={kind="round", width=1.6, point=0.4}})
local mline = pile{{"red earth", 1}, {"raw umber", 1}, {"rose madder", 0.3}, {"lead white", 0.1}, name="mouth line"}
local ml = {}
for i, p in ipairs(MOUTH.line) do
  local t = (i - 1) / (#MOUTH.line - 1)
  ml[#ml + 1] = {p[1], p[2] + 0.2, 0.25 + 0.25 * (math.abs(t - 0.5) * 2) ^ 2}
end
local bm = brush{kind="round", width=1.7, point=0.9}
bm:load(mline, 0.5)
bm:gesture(ml, {wobble=0.2})
local hb = brush{kind="filbert", width=3, stiffness=0.4, lay=1.5}
hb:load(pile{{"lead white", 3}, {"vermilion", 0.08}, {"rose madder", 0.03}, name="lip light"}, 0.35)
local ll = onface(-6, 114, 74)
hb:touch(ll[1], ll[2], {pressure=0.2, drag={4, 0}})
