-- dead colouring, 2: parapet, gown, hair, and the flesh in verdaccio

function LV(x, y)
  local s = F:sample(x, y)
  if s then return lightval(s) end
  return 0.35
end
-- weights for a ladder of piles over a value function: a tent around each step
function tents(list, vf, lo, hi)
  local out = {}
  local n = #list
  for i, p in ipairs(list) do
    local c = (i - 1) / (n - 1)
    out[#out + 1] = {p, function(x, y)
      local t = clamp((vf(x, y) - lo) / (hi - lo), 0, 1)
      return math.max(0, 1 - math.abs(t - c) * (n - 1)) + 0.001
    end}
  end
  return out
end

-- the hair's own solid, for its light: a cap over the skull and the braid behind
do
  local function P(x, y, z) return {EX + HS * x, EY + HS * y, HS * z} end
  local cap = body.ellipsoid(P(0, -52, -38), {HS * 110, HS * 133, HS * 136})
  cap = cap:union(body.ellipsoid(P(-80, 10, -10), {HS * 34, HS * 70, HS * 60}), 30)
  cap = cap:union(body.ellipsoid(P(86, 10, -10), {HS * 34, HS * 70, HS * 60}), 30)
  cap = cap:turn(P(0, 0, 0), YAW, PITCH, ROLL)
  local braid = body.ellipsoid({662, 560, -40}, {36, 230, 30}):turn({662, 560, -40}, 0, 0, -0.05)
  FH = form{{cap}, {braid}, light={from={-1, -0.75}, front=0.5, ambient=0.22}}
end
function HLV(x, y)
  local s = FH:sample(x, y)
  if s then return lightval(s) end
  return 0.3
end

-- the parapet: grey stone, its top lit
local stL = pile{{"lead white", 3}, {"raw umber", 0.55}, {"bone black", 0.2}, {"yellow ochre", 0.25}, turps=0.15, name="stone light"}
local stD = pile{{"lead white", 1.3}, {"raw umber", 0.8}, {"bone black", 0.4}, turps=0.15, name="stone dark"}
PARTOP = rect(0, 1168, 1000, 32)
PARFRONT = PARAPET - PARTOP
work(PARTOP, {hand="body", pile=stL, coverage=2.6, fill=true, angle=0, clip=PARTOP})
work(PARFRONT, {hand="body", pile=stD, coverage=2.6, fill=true, angle=0.03, clip=PARFRONT})

-- the gown: red earth and vermilion, darker in its turned planes (to be glazed)
local drL = pile{{"red earth", 1.6}, {"vermilion", 1.2}, {"lead white", 0.25}, turps=0.1, name="gown light"}
local drM = pile{{"red earth", 2}, {"vermilion", 0.4}, {"raw umber", 0.3}, turps=0.1, name="gown mid"}
local drD = pile{{"red earth", 1.6}, {"bone black", 0.7}, {"raw umber", 0.6}, turps=0.1, name="gown dark"}
GOWN = DRESS - PARAPET
work(GOWN, {hand="body", piles=tents({drD, drM, drL}, LV, 0.15, 0.85), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=GOWN, tool="filbert 12"})

-- the hair: chestnut, darker where it turns from the light
local hr = {
  pile{{"raw umber", 1.4}, {"red earth", 0.5}, {"bone black", 0.35}, turps=0.1, name="hair 1"},
  pile{{"raw umber", 1.2}, {"red earth", 0.7}, {"yellow ochre", 0.5}, {"lead white", 0.1}, turps=0.1, name="hair 2"},
  pile{{"raw umber", 0.8}, {"red earth", 0.6}, {"yellow ochre", 1}, {"lead white", 0.35}, turps=0.1, name="hair 3"},
}
work(HAIR, {hand="body", piles=tents(hr, HLV, 0.2, 0.85), coverage=2.6, fill=true, angle=FH:field("fall"), clip=HAIR, tool="filbert 7"})

-- the flesh in verdaccio: black and ochre's green-grey, green earth, lead white
VERD = {
  pile{{"bone black", 0.5}, {"raw umber", 1}, {"green earth", 1}, {"yellow ochre", 0.3}, name="verd 0"},
  pile{{"bone black", 0.3}, {"yellow ochre", 0.6}, {"green earth", 1.5}, {"raw umber", 0.5}, {"lead white", 0.3}, name="verd 1"},
  pile{{"bone black", 0.15}, {"yellow ochre", 0.5}, {"green earth", 1.5}, {"raw umber", 0.3}, {"lead white", 0.9}, name="verd 2"},
  pile{{"bone black", 0.06}, {"yellow ochre", 0.3}, {"green earth", 1.2}, {"lead white", 1.6}, name="verd 3"},
  pile{{"green earth", 0.6}, {"yellow ochre", 0.12}, {"lead white", 2.6}, name="verd 4"},
  pile{{"lead white", 4}, {"green earth", 0.2}, {"yellow ochre", 0.1}, name="verd 5"},
}
work(SKIN, {hand="body", piles=tents(VERD, LV, 0.14, 0.95), coverage=3, fill=true,
  angle=F:field("across"), clip=SKIN, tool="filbert 6"})
blend(SKIN:shrink(2), {angle=F:field("across")})
print(wait(3 * 24 * 60))
