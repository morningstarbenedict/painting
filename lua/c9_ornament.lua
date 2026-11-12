clear_palette()
-- ornament: gold embroidery along the band, the ferronnière across the brow,
-- a string of jet beads at the throat, gold ties at the sleeves' seams

local gold = {
  pile{{"yellow ochre", 1}, {"red earth", 0.25}, {"raw umber", 0.25}, name="gold dark"},
  pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 0.2}, name="gold mid"},
  pile{{"Naples yellow", 1}, {"lead white", 1}, blot=0.2, name="gold light"},
}
local function along(path, step)
  -- points every `step` units along a polyline, with the direction there
  local out = {}
  local acc, i = 0, 1
  local total = 0
  for k = 1, #path - 1 do
    local a, b = path[k], path[k + 1]
    local l = math.sqrt((b[1] - a[1]) ^ 2 + (b[2] - a[2]) ^ 2)
    local d = (step - acc) % step
    while d <= l do
      local t = d / l
      out[#out + 1] = {a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, (b[1] - a[1]) / l, (b[2] - a[2]) / l}
      d = d + step
    end
    acc = (acc + l) % step
  end
  return out
end

-- the embroidery: a running knot of two interlaced strands, gold on black
local gb = brush{kind="round", width=1.3, point=0.8}
local pts = along(BANDPATH, 9)
for j, p in ipairs(pts) do
  local x, y, tx, ty = p[1], p[2], p[3], p[4]
  local nx, ny = -ty, tx
  local v = LV(x, y)
  local gp = gold[(v > 0.55) and 3 or ((v > 0.3) and 2 or 1)]
  for _, sgn in ipairs({-1, 1}) do
    gb:reload(gp, 0.5)
    local a = {x - tx * 4.5 + nx * 3.5 * sgn, y - ty * 4.5 + ny * 3.5 * sgn, 0.15}
    local m = {x, y, 0.35}
    local b = {x + tx * 4.5 - nx * 3.5 * sgn, y + ty * 4.5 - ny * 3.5 * sgn, 0.15}
    gb:gesture({a, m, b}, {clip=BAND:grow(0.5)})
  end
  -- a seed pearl at every second crossing
  if j % 2 == 0 then
    gb:reload(gold[3], 0.6)
    gb:touch(x, y, {pressure=0.4})
  end
end

-- the ferronnière: a fine dark cord across the forehead, a jewel at its middle
FERR = {}
for i = 0, 16 do
  local x = -78 + 156 * i / 16
  FERR[#FERR + 1] = onface(x, -86 + 0.0035 * x * x, 70, 0.8)
end
local fm = ribbon(FERR, 1.8) * (FACE + HAIR)
local cord = pile{{"bone black", 1}, {"raw umber", 0.6}, name="cord"}
work(fm, {hand="detail", pile=cord, coverage=3, fill=true, clip=fm, tool={kind="round", width=1.0, point=0.8}})
-- its shadow on the brow, a breath below it
local fs = {}
for _, p in ipairs(FERR) do fs[#fs + 1] = {p[1] + 0.8, p[2] + 2.2} end
local fsm = ribbon(fs, 2.2):soften(1.5) * FACE
work(fsm, {hand="glaze", pile=pile{{"raw umber", 0.6}, {"red earth", 0.4}, {"lead white", 0.4}, medium=0.75, name="cord shadow"}, coverage=0.9, clip=fsm:grow(1)})
-- the jewel: a cabochon of deep red in a gold setting, a pearl hanging under it
JEWEL = onface(0, -84, 75, 1)
local jx, jy = JEWEL[1], JEWEL[2]
local setting = ellipse(jx, jy, 5.2, 6.2)
work(setting, {hand="detail", piles={{gold[1], 0.5}, {gold[2], 0.5}}, coverage=3, fill=true, clip=setting, tool={kind="round", width=1.0, point=0.6}})
local stone = ellipse(jx, jy, 3.4, 4.2)
work(stone, {hand="detail", piles={{pile{{"rose madder", 1}, {"bone black", 0.3}, {"red earth", 0.3}, name="ruby dark"}, 0.6},
  {pile{{"vermilion", 0.6}, {"rose madder", 1}, name="ruby"}, 0.4}}, coverage=3, fill=true, clip=stone, tool={kind="round", width=0.9, point=0.6}})
local gl = brush{kind="round", width=1.1, point=0.6, lay=3}
SPARK = SPARK or pile{{"lead white", 1}, blot=0.2, name="spark"}
gl:load(SPARK, 0.8)
gl:touch(jx - 1.2, jy - 1.6, {pressure=0.4})
gl:touch(jx + 1.4, jy + 2.6, {pressure=0.15})
local pearl = ellipse(jx + 0.3, jy + 10.5, 2.6, 3.0)
work(pearl, {hand="detail", piles={{pile{{"lead white", 2}, {"raw umber", 0.15}, {"bone black", 0.05}, name="pearl shade"}, 0.5},
  {pile{{"lead white", 3}, {"Naples yellow", 0.1}, name="pearl"}, 0.5}}, coverage=3, fill=true, clip=pearl, tool={kind="round", width=0.9, point=0.6}})
gl:reload(SPARK, 0.8)
gl:touch(jx - 0.6, jy + 9.6, {pressure=0.35})

clear_palette()
-- jet beads at the throat, a string lying over the breast
local bead = pile{{"bone black", 1}, {"raw umber", 0.3}, name="jet"}
local beadL = pile{{"lead white", 2}, {"smalt", 0.2}, name="jet light"}
local bb = brush{kind="round", width=3.2, point=0.2, lay=2}
local hb = brush{kind="round", width=1.0, point=0.7}
for _, strand in ipairs({{452, 640, 690, 74, 0.42}, {446, 648, 700, 112, 0.44}}) do
  local x0, x1, y0, sag, low = strand[1], strand[2], strand[3], strand[4], strand[5]
  local n = math.floor((x1 - x0) / 5.4)
  for i = 0, n do
    local t = i / n
    local u = (t <= low) and (t / low) or ((1 - t) / (1 - low))
    local x = lerp(x0, x1, t)
    local y = y0 + sag * math.sin(u * math.pi / 2) ^ 1.3
    if NECK:at(x, y) > 0.6 then
      bb:reload(bead, 0.7)
      bb:touch(x, y, {pressure=0.55})
      hb:reload(beadL, 0.5)
      hb:touch(x - 0.9, y - 1.0, {pressure=0.3})
    end
  end
end

-- gold ties where the sleeves meet the bodice, with white puffs of the chemise
local tie = brush{kind="round", width=2.0, point=0.7}
local puff = pile{{"lead white", 3}, {"raw umber", 0.1}, name="puff"}
local puffS = pile{{"lead white", 1.4}, {"raw umber", 0.3}, {"bone black", 0.08}, name="puff shade"}
for _, s in ipairs({{424, 870}, {420, 980}, {722, 880}, {728, 990}}) do
  local m = ellipse(s[1], s[2], 7, 11):roughen(1.5, 6, 3)
  work(m, {hand="detail", piles={{puff, function(x, y) return LV(x, y) + 0.3 end}, {puffS, function(x, y) return 1 - LV(x, y) end}},
    coverage=3, fill=true, clip=m, tool={kind="round", width=1.6, point=0.5}})
  for k = -1, 1, 2 do
    tie:reload(gold[2], 0.5)
    tie:gesture({{s[1] - 6, s[2] + k * 2, 0.35}, {s[1], s[2] + k * 0.5, 0.45}, {s[1] + 6, s[2] - k * 2, 0.3}}, {})
  end
  tie:reload(gold[3], 0.5)
  tie:gesture({{s[1], s[2], 0.3}, {s[1] + 3, s[2] + 9, 0.2}, {s[1] + 2, s[2] + 16, 0.0}}, {})
end
