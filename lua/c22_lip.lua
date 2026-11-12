clear_palette()
-- the upper lip: the nose's shadow kept narrow under its tip, the flanks of the lip lit
print(wait(2 * 24 * 60))
local function blob(p, rx, ry) return function(x, y) local dx, dy = (x - p[1]) / rx, (y - p[2]) / ry; return math.exp(-(dx * dx + dy * dy)) end end
local tip = blob(onface(0, 85, 82), 7, 3.5)
local feats = LIPS:grow(1)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3) end
local ul = poly({onface(-26, 84, 68), onface(-10, 82, 80), onface(10, 82, 80), onface(26, 84, 68), onface(26, 104, 64), onface(0, 99, 74), onface(-26, 104, 64)}, true):soften(3) - feats
local function v(x, y) return clamp(LVF(x, y) + 0.08 - 0.3 * tip(x, y), 0, 1) end
work(ul, {hand="body", piles=tents_g(FL, v, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=0, clip=FACE - feats,
  tool="filbert 2.5", length={3, 8}, load=0.8})
