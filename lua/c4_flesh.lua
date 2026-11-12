-- the flesh: one smooth pass of short strokes from a six-step ladder, umber
-- shadow to Naples-yellow light, cool greenish halftones between, the rose of
-- the cheeks, the nose and the chin worked into it wet
clear_palette()
FL = {
  pile{{"raw umber", 1}, {"red earth", 0.4}, {"bone black", 0.1}, {"green earth", 0.3}, {"lead white", 0.1}, name="flesh 0"},
  pile{{"raw umber", 1}, {"red earth", 0.4}, {"green earth", 0.4}, {"yellow ochre", 0.2}, {"lead white", 0.45}, name="flesh 1"},
  pile{{"lead white", 1.2}, {"raw umber", 0.45}, {"red earth", 0.25}, {"yellow ochre", 0.35}, {"green earth", 0.35}, name="flesh 2"},
  pile{{"lead white", 2.2}, {"yellow ochre", 0.35}, {"red earth", 0.18}, {"green earth", 0.15}, {"raw umber", 0.08}, name="flesh 3"},
  pile{{"lead white", 3}, {"yellow ochre", 0.25}, {"vermilion", 0.05}, {"red earth", 0.04}, name="flesh 4"},
  pile{{"lead white", 4}, {"Naples yellow", 0.4}, {"vermilion", 0.02}, name="flesh 5"},
}
ROSE = pile{{"lead white", 2.4}, {"vermilion", 0.22}, {"rose madder", 0.06}, {"yellow ochre", 0.15}, name="rose"}

local function blob(p, rx, ry)
  return function(x, y)
    local dx, dy = (x - p[1]) / rx, (y - p[2]) / ry
    return math.exp(-(dx * dx + dy * dy))
  end
end
local cheekN = blob(onface(48, 52, 60), 34, 30)
local cheekF = blob(onface(-46, 50, 60), 22, 26)
local noseT = blob(onface(0, 64, 95), 12, 12)
local chinB = blob(onface(0, 150, 60), 22, 14)
function ROSY(x, y)
  return clamp(0.8 * cheekN(x, y) + 0.55 * cheekF(x, y) + 0.45 * noseT(x, y) + 0.4 * chinB(x, y), 0, 1)
end

-- the light on the skin, with the jaw's shadow falling down and right onto the neck
function LVF(x, y)
  local v = LV(x, y)
  if HEAD:at(x, y) < 0.5 then
    local sh = 0
    for _, d in ipairs({{-8, -22}, {-12, -34}, {-16, -46}, {-5, -14}}) do
      if HEAD:at(x + d[1], y + d[2]) > 0.5 then sh = sh + 0.25 end
    end
    v = v * (1 - 0.6 * sh)
  end
  return v
end

local ps = tents(FL, LVF, 0.12, 0.95)
ps[#ps + 1] = {ROSE, function(x, y) return 1.3 * ROSY(x, y) * smoothstep(0.3, 0.6, LV(x, y)) end}
work(SKIN, {hand="body", piles=ps, coverage=3, fill=true, angle=F:field("across"), clip=SKIN,
  tool="filbert 4", length={6, 14}})
print(wait(4 * 24 * 60))
