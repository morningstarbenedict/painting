clear_palette()
-- corrections: the shadowed cheek restated, heavier lids, the lips rebuilt
print(wait(2 * 24 * 60))
local feats = (EYEM[-1].opening + EYEM[1].opening):grow(1.5) + LIPS:grow(1)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3.5) end
local shade = (SKIN:shrink(1.5) - feats) * mask(function(x, y) return 1 - smoothstep(0.42, 0.62, LVF(x, y)) end)
work(shade, {hand="body", piles=tents_g(FL, LVF, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=F:field("across"),
  clip=SKIN - feats, tool="filbert 3", length={4, 10}, load=0.9})

-- the lids lowered over the irises: a band of lid flesh, then the line again
local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
local lidF = pile{{"lead white", 1.6}, {"raw umber", 0.4}, {"red earth", 0.3}, {"yellow ochre", 0.3}, {"green earth", 0.2}, name="lid flesh"}
local lidFL = pile{{"lead white", 2.4}, {"yellow ochre", 0.3}, {"red earth", 0.2}, {"green earth", 0.1}, name="lid flesh light"}
local lid = pile{{"raw umber", 1}, {"bone black", 0.35}, {"red earth", 0.35}, {"lead white", 0.12}, name="lid line"}
local wdark = pile{{"raw umber", 1}, {"red earth", 0.2}, {"lead white", 0.6}, medium=0.7, name="white dark glaze"}
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local up2 = {}
  for i, p in ipairs(e.up) do
    local t = (i - 1) / (#e.up - 1)
    up2[i] = {p[1], p[2] + 2.6 * math.sin(math.pi * t) ^ 0.8}
  end
  local band = poly(cat(e.up, rev(up2)), true):grow(0.6)
  work(band, {hand="detail", piles={{lidF, function(x, y) return 1 - LV(x, y) end}, {lidFL, LV}}, coverage=3, fill=true, clip=band,
    tool={kind="round", width=1.4, point=0.5}})
  -- the whites, lowered in value
  local wm = EYEM[s].opening - EYEM[s].iris:grow(0.3) - band
  work(wm, {hand="glaze", pile=wdark, coverage=1, clip=EYEM[s].opening, tool={kind="round", width=3, point=0.4}})
  local b = brush{kind="round", width=2.8, point=0.6, stiffness=0.35}
  local pts = {}
  for i, p in ipairs(up2) do
    local t = (i - 1) / (#up2 - 1)
    pts[#pts + 1] = {p[1], p[2] - 0.1, 0.2 + 0.4 * smoothstep(0.05, 0.85, t) - 0.25 * smoothstep(0.92, 1, t)}
  end
  b:load(lid, 0.55)
  b:gesture(pts, {wobble=0.2})
  EYES[s].up2 = up2
end

-- the lips rebuilt in body paint, soft at their edges, the line between them again
local upper = poly(cat(MOUTH.upper, rev(MOUTH.line)), true)
local lower = poly(cat(MOUTH.line, rev(MOUTH.lower)), true)
local lipU = pile{{"lead white", 1.2}, {"rose madder", 0.18}, {"red earth", 0.35}, {"raw umber", 0.12}, {"vermilion", 0.05}, name="upper lip"}
local lipL = pile{{"lead white", 1.8}, {"vermilion", 0.16}, {"rose madder", 0.1}, {"red earth", 0.12}, {"yellow ochre", 0.06}, name="lower lip"}
work(upper, {hand="detail", pile=lipU, coverage=3, fill=true, clip=upper:grow(1), tool={kind="round", width=1.8, point=0.4}, edge="soft"})
work(lower, {hand="detail", pile=lipL, coverage=3, fill=true, clip=lower:grow(1.2), tool={kind="round", width=2.0, point=0.4}, edge="soft"})
local mline = pile{{"red earth", 1}, {"raw umber", 0.9}, {"rose madder", 0.3}, {"lead white", 0.15}, name="mouth line"}
local ml = {}
for i, p in ipairs(MOUTH.line) do
  local t = (i - 1) / (#MOUTH.line - 1)
  ml[#ml + 1] = {p[1], p[2] + 0.2, 0.22 + 0.3 * (math.abs(t - 0.5) * 2) ^ 2}
end
local bm = brush{kind="round", width=1.8, point=0.9}
bm:load(mline, 0.5)
bm:gesture(ml, {wobble=0.2})
