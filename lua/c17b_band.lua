clear_palette()
-- the black velvet band over the neckline's edge again, the chemise's rim
-- inside it, its gold knotwork, and the jet beads larger
print(wait(2 * 24 * 60))
local INPATH = {}
for _, p in ipairs(BANDPATH) do INPATH[#INPATH + 1] = p end
BAND2 = ribbon(BANDPATH, 17) * ((GOWN + SLEEVES):grow(2) + NECK + SLOPE) - HAIR - HEAD
BAND2 = BAND2 * mask(function(x, y) return y > 700 and 1 or 0 end)
local bandP = pile{{"bone black", 1}, {"raw umber", 0.5}, {"smalt", 0.2}, name="band"}
local bandL = pile{{"bone black", 0.6}, {"raw umber", 0.6}, {"smalt", 0.3}, {"lead white", 0.25}, name="band light"}
work(BAND2, {hand="detail", piles={{bandP, function(x, y) return 1.2 - LV(x, y) end}, {bandL, function(x, y) return 0.4 * LV(x, y) end}},
  coverage=3, fill=true, clip=BAND2, tool={kind="round", width=2.4, point=0.5}})
-- the chemise: a fine white rim just inside the band
local inner = (NECK + SLOPE) - BAND2
CHEM2 = (inner - inner:shrink(2.6)) * BAND2:grow(3.5) * mask(function(x, y) return y > 712 and 1 or 0 end)
local chemS = pile{{"lead white", 2}, {"raw umber", 0.18}, {"bone black", 0.05}, name="chemise shade"}
local chemL = pile{{"lead white", 3}, {"Naples yellow", 0.12}, name="chemise light"}
work(CHEM2, {hand="detail", piles={{chemS, function(x, y) return 1 - CV(x, y) end}, {chemL, function(x, y) return CV(x, y) end}},
  coverage=3, fill=true, clip=CHEM2, tool={kind="round", width=1.0, point=0.6}})
-- the knotwork
local gold = {
  pile{{"yellow ochre", 1}, {"red earth", 0.25}, {"raw umber", 0.25}, name="gold dark"},
  pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 0.2}, name="gold mid"},
  pile{{"Naples yellow", 1}, {"lead white", 1}, blot=0.2, name="gold light"},
}
local function along(path, step)
  local out, acc = {}, 0
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
local gb = brush{kind="round", width=1.4, point=0.8}
for j, p in ipairs(along(BANDPATH, 10)) do
  local x, y, tx, ty = p[1], p[2], p[3], p[4]
  if BAND2:at(x, y) > 0.5 then
    local nx, ny = -ty, tx
    local v = LV(x, y)
    local gp = gold[(v > 0.55) and 3 or ((v > 0.3) and 2 or 1)]
    for _, sgn in ipairs({-1, 1}) do
      gb:reload(gp, 0.5)
      gb:gesture({{x - tx * 5 + nx * 4 * sgn, y - ty * 5 + ny * 4 * sgn, 0.15}, {x, y, 0.4}, {x + tx * 5 - nx * 4 * sgn, y + ty * 5 - ny * 4 * sgn, 0.15}}, {clip=BAND2})
    end
    if j % 2 == 0 then gb:reload(gold[3], 0.6); gb:touch(x, y, {pressure=0.5}) end
  end
end
-- jet beads, larger: each a small sphere with its light
clear_palette()
local jet = {
  pile{{"bone black", 1}, {"raw umber", 0.3}, name="jet"},
  pile{{"bone black", 0.7}, {"raw umber", 0.3}, {"smalt", 0.3}, {"lead white", 0.35}, name="jet mid"},
}
local hb = brush{kind="round", width=1.3, point=0.6, lay=2}
local spark = pile{{"lead white", 1}, blot=0.2, name="spark"}
for _, strand in ipairs({{460, 628, 690, 62, 0.42, 3.4}, {448, 640, 700, 104, 0.44, 3.8}}) do
  local x0, x1, y0, sag, low, r = strand[1], strand[2], strand[3], strand[4], strand[5], strand[6]
  local n = math.floor((x1 - x0) / (r * 2.05))
  for i = 0, n do
    local t = i / n
    local u = (t <= low) and (t / low) or ((1 - t) / (1 - low))
    local x = lerp(x0, x1, t)
    local y = y0 + sag * math.sin(u * math.pi / 2) ^ 1.3
    if (NECK + SLOPE):at(x, y) > 0.6 and BAND2:at(x, y) < 0.3 then
      local m = ellipse(x, y, r, r)
      work(m, {hand="detail", piles={{jet[1], function(px, py) return 0.5 + ((px - x) + (py - y)) / r end}, {jet[2], function(px, py) return 0.5 - ((px - x) + (py - y)) / r end}},
        coverage=3, fill=true, clip=m, tool={kind="round", width=1.2, point=0.5}})
      hb:reload(spark, 0.5)
      hb:touch(x - r * 0.35, y - r * 0.4, {pressure=0.3})
    end
  end
end
