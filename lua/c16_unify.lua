clear_palette()
-- one unifying pass over the face in the flesh ladder, its light including the
-- sockets' shadow; the features kept out
print(wait(2 * 24 * 60))
local feats = (EYEM[-1].opening + EYEM[1].opening):grow(1.2) + LIPS:grow(0.8)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3) end
local function blob(p, rx, ry) return function(x, y) local dx, dy = (x - p[1]) / rx, (y - p[2]) / ry; return math.exp(-(dx * dx + dy * dy)) end end
local sR = blob(onface(-22, -4, 70), 9, 12)
local sL = blob(onface(22, -4, 70), 11, 13)
local lidR = blob(onface(-40, -6, 70), 16, 6)
local lidL = blob(onface(40, -6, 70), 18, 6)
local und = blob(onface(0, 86, 80), 16, 5)
FV = function(x, y)
  return LVF(x, y) * (1 - 0.4 * (sR(x, y) + sL(x, y)) - 0.15 * (lidR(x, y) + lidL(x, y)) - 0.2 * und(x, y))
end
local ps = tents_g(FL, FV, 0.12, 0.95, 1.5)
ps[#ps + 1] = {ROSE, function(x, y) return 1.0 * ROSY(x, y) * smoothstep(0.35, 0.65, LV(x, y)) end}
local area = FACE:shrink(0.5) - feats
work(area, {hand="body", piles=ps, coverage=3, fill=true, angle=F:field("across"), clip=area,
  tool="filbert 3", length={4, 10}, load=0.85})
