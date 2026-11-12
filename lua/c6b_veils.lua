clear_palette()
-- velature: thin veils of light flesh in medium over the set flesh, smoothing
-- it into sfumato; the eyes warmed, the lips filled, the brows found
print(wait(4 * 24 * 60))
local feats = (EYEM[-1].opening + EYEM[1].opening):grow(1.5)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3.5) end
local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
LIPS = poly(cat(MOUTH.upper, rev(MOUTH.lower)), true)
feats = feats + LIPS:grow(1)
local skinV = SKIN:shrink(1.5) - feats
local vL = pile{{"lead white", 3}, {"yellow ochre", 0.25}, {"vermilion", 0.04}, {"red earth", 0.03}, medium=0.5, name="veil light"}
local vM = pile{{"lead white", 2.2}, {"yellow ochre", 0.35}, {"red earth", 0.16}, {"green earth", 0.16}, {"raw umber", 0.06}, medium=0.5, name="veil mid"}
local vD = pile{{"lead white", 1}, {"raw umber", 0.4}, {"red earth", 0.25}, {"yellow ochre", 0.3}, {"green earth", 0.3}, medium=0.55, name="veil dark"}
-- the lights, then the half-lights, each veiled once, the shadows once
work(skinV * mask(function(x, y) return smoothstep(0.42, 0.75, LVF(x, y)) end), {hand="glaze", pile=vL, coverage=1, clip=SKIN})
work(skinV * mask(function(x, y) local v = LVF(x, y); return smoothstep(0.22, 0.4, v) * (1 - smoothstep(0.55, 0.75, v)) end), {hand="glaze", pile=vM, coverage=1, clip=SKIN})
work(skinV * mask(function(x, y) return 1 - smoothstep(0.18, 0.35, LVF(x, y)) end), {hand="glaze", pile=vD, coverage=1, clip=SKIN})
-- the upper lip and the philtrum: lighter, so no shadow sits there like a moustache
local ul = poly({onface(-24, 86, 70), onface(-8, 83, 80), onface(8, 83, 80), onface(24, 86, 70), onface(24, 104, 66), onface(0, 99, 74), onface(-24, 104, 66)}, true):soften(4) - LIPS:grow(1)
work(ul, {hand="glaze", pile=vM, coverage=1, clip=SKIN})
print(wait(2 * 24 * 60))
-- the eyes: irises deepened with a warm brown glaze, whites warmed a breath
local ig = pile{{"raw umber", 1}, {"red earth", 0.35}, {"yellow ochre", 0.2}, medium=0.7, name="iris glaze"}
local wg = pile{{"lead white", 1}, {"yellow ochre", 0.12}, {"red earth", 0.03}, medium=0.6, name="white glaze"}
for _, s in ipairs({-1, 1}) do
  work(EYEM[s].iris, {hand="glaze", pile=ig, coverage=1, clip=EYEM[s].iris, tool={kind="round", width=3, point=0.4}})
  work(EYEM[s].opening - EYEM[s].iris:grow(0.5), {hand="glaze", pile=wg, coverage=1, clip=EYEM[s].opening, tool={kind="round", width=3, point=0.4}})
end
-- the lips: fuller colour, soft at their edges
local lg = pile{{"rose madder", 0.6}, {"vermilion", 0.5}, {"lead white", 0.6}, {"red earth", 0.15}, medium=0.55, name="lip glaze"}
work(LIPS:soften(1.5), {hand="glaze", pile=lg, coverage=1, clip=LIPS:grow(2), tool={kind="filbert", width=4}})
-- the brows: soft, faint, as plucked
local bgz = pile{{"raw umber", 1}, {"yellow ochre", 0.35}, {"red earth", 0.15}, {"lead white", 0.3}, medium=0.6, name="brow glaze"}
for _, s in ipairs({-1, 1}) do
  local br = EYES[s].brow
  local w = {}
  for i = 1, #br do local t = (i - 1) / (#br - 1); w[i] = 1.2 + 2.6 * math.sin(math.pi * t ^ 0.7) * (1 - 0.4 * t) end
  local m = ribbon(br, w):soften(1.5)
  work(m, {hand="glaze", pile=bgz, coverage=1, clip=m:grow(1.5), tool={kind="filbert", width=3}})
  work(m:shrink(0.6), {hand="glaze", pile=bgz, coverage=0.7, clip=m:grow(1), tool={kind="filbert", width=2}})
end
