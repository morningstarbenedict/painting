clear_palette()
-- the hair: parted in the middle, drawn smooth over the head and down over
-- the ears, gathered behind; strands laid along its fall, lit and shadowed

local function bez(p0, p1, p2, p3, n)
  local o = {}
  for i = 0, n do
    local t = i / n
    local a, b, c, d = (1 - t) ^ 3, 3 * (1 - t) ^ 2 * t, 3 * (1 - t) * t * t, t ^ 3
    o[#o + 1] = {a * p0[1] + b * p1[1] + c * p2[1] + d * p3[1], a * p0[2] + b * p1[2] + c * p2[2] + d * p3[2]}
  end
  return o
end

-- the part, from the hairline back over the crown
PART = {{503, 286}, {512, 262}, {526, 236}, {542, 214}, {558, 200}}
local function on_part(t)
  local n = #PART - 1
  local i = math.min(n, math.floor(t * n) + 1)
  local u = t * n - (i - 1)
  return {lerp(PART[i][1], PART[i + 1][1], u), lerp(PART[i][2], PART[i + 1][2], u)}
end

HAIRPILES = {
  pile{{"raw umber", 1.3}, {"bone black", 0.45}, {"red earth", 0.35}, name="strand 0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.7}, {"yellow ochre", 0.35}, {"bone black", 0.1}, name="strand 1"},
  pile{{"raw umber", 0.8}, {"red earth", 0.6}, {"yellow ochre", 0.9}, {"lead white", 0.25}, name="strand 2"},
  pile{{"yellow ochre", 1}, {"raw umber", 0.4}, {"red earth", 0.3}, {"lead white", 0.6}, {"Naples yellow", 0.3}, name="strand 3"},
  pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 1}, {"red earth", 0.1}, name="strand 4"},
}
-- a deeper chestnut body first, over the dead colour
work(HAIR, {hand="body", piles=tents({HAIRPILES[1], HAIRPILES[2], HAIRPILES[3]}, HLV, 0.2, 0.9), coverage=2.5, fill=true,
  angle=FH:field("fall"), clip=HAIR, tool="filbert 6", length={10, 30}})
local function strand_pile(v)
  local i = clamp(math.floor(v * 5) + 1, 1, 5)
  return HAIRPILES[i]
end

-- the strands' paths: from the part out to each side and down
local paths = {}
for k = 1, 260 do
  local t = rand(0.0, 1.0) ^ 0.8
  local p0 = on_part(t)
  local side = (k % 2 == 0) and -1 or 1
  local p3, p1, p2
  if side == -1 then
    -- over the far temple and down beside the cheek
    local endy = lerp(330, 470, rand(0, 1) ^ 1.3)
    p3 = {lerp(426, 408, (endy - 330) / 140) + rand(-6, 6), endy}
    p1 = {p0[1] - 30 - rand(0, 20), p0[2] + rand(-6, 10)}
    p2 = {p3[1] - rand(4, 20), p3[2] - rand(40, 80)}
  else
    -- over the crown to the near side, down over the ear and back to the braid
    local endy = lerp(380, 560, rand(0, 1) ^ 1.1)
    p3 = {lerp(630, 668, (endy - 380) / 180) + rand(-8, 8), endy}
    p1 = {p0[1] + 40 + rand(0, 30), p0[2] + rand(-10, 20)}
    p2 = {p3[1] + rand(5, 25), p3[2] - rand(60, 120)}
  end
  paths[#paths + 1] = bez(p0, p1, p2, p3, 14)
end

-- lay them: dark strands first, then the lit ones over, each tinted by its light
local clipH = HAIR:shrink(1)
local order = {}
for i = 1, #paths do order[i] = i end
local bs = brush{kind="rigger", width=1.6, point=0.9}
for pass = 1, 2 do
  for _, i in ipairs(order) do
    local pts = paths[i]
    local mid = pts[math.floor(#pts / 2)]
    local v = HLV(mid[1], mid[2]) + randn(0, 0.08)
    if (pass == 1 and v < 0.5) or (pass == 2 and v >= 0.5) then
      local g = {}
      for j, p in ipairs(pts) do
        local tt = (j - 1) / (#pts - 1)
        g[#g + 1] = {p[1], p[2], 0.1 + 0.4 * math.sin(math.pi * tt) ^ 0.6}
      end
      bs:reload(strand_pile(clamp(v + (pass == 2 and 0.12 or -0.05), 0, 0.99)), 0.5)
      bs:gesture(g, {wobble=1.2, clip=clipH})
    end
  end
end
-- soften the strands into the mass, then a few crisp lights on the crown and the far side
blend(HAIR:shrink(3) - HAIRBACK, {angle=FH:field("fall")})
local hl = brush{kind="rigger", width=1.2, point=0.95}
for k = 1, 70 do
  local i = math.random(#paths)
  local pts = paths[i]
  local a = math.random(2, 7)
  local seg = {}
  for j = a, math.min(#pts, a + 5) do
    local p = pts[j]
    if HLV(p[1], p[2]) > 0.55 then seg[#seg + 1] = {p[1], p[2], 0.25} end
  end
  if #seg >= 3 then
    seg[1][3] = 0.0; seg[#seg][3] = 0.0
    hl:reload(HAIRPILES[5], 0.4)
    hl:gesture(seg, {wobble=0.6, clip=clipH})
  end
end
-- the part itself, a fine dark line
local bp = brush{kind="round", width=1.2, point=0.9}
bp:load(HAIRPILES[1], 0.5)
bp:gesture({{PART[1][1], PART[1][2], 0.3}, {PART[2][1], PART[2][2], 0.35}, {PART[3][1], PART[3][2], 0.3}, {PART[4][1], PART[4][2], 0.15}}, {clip=clipH})
