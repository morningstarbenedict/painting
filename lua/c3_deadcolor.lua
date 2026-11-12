-- dead colouring: every mass laid in lean, the flesh in verdaccio modelled
-- from the light on the solid

-- the light anywhere on the figure (off the solid: a middle value)
function LV(x, y)
  local s = F:sample(x, y)
  if s then return lightval(s) end
  return 0.35
end
-- weights for graded piles: a tent around each pile's value
function tents(list, vf)
  local out = {}
  local n = #list
  for i, p in ipairs(list) do
    local c = (i - 1) / (n - 1)
    out[#out + 1] = {p, function(x, y) return math.max(0, 1 - math.abs(vf(x, y) - c) * (n - 1)) + 0.001 end}
  end
  return out
end

-- the background: dark olive umber, a breath lighter behind the shadowed side
local bgD = pile{{"bone black", 1}, {"raw umber", 1.6}, {"green earth", 1.2}, {"lead white", 0.15}, turps=0.35, name="bg dark"}
local bgL = pile{{"bone black", 0.6}, {"raw umber", 1.6}, {"green earth", 1.4}, {"yellow ochre", 0.3}, {"lead white", 0.5}, turps=0.35, name="bg light"}
work(BG, {hand="broad", piles={{bgD, function(x, y) return 1 - smoothstep(380, 900, x) * 0.8 end},
                               {bgL, function(x, y) return smoothstep(380, 900, x) * (1 - smoothstep(700, 1150, y) * 0.6) end}},
  coverage=2.2, angle=function(x, y) return 1.2 + 0.4 * math.sin(x / 170 + y / 230) end, clip=BG:grow(4), edge="soft"})

-- the parapet: grey stone, its top lit
local stL = pile{{"lead white", 3}, {"raw umber", 0.5}, {"bone black", 0.18}, {"yellow ochre", 0.2}, turps=0.3, name="stone light"}
local stD = pile{{"lead white", 1.4}, {"raw umber", 0.8}, {"bone black", 0.35}, turps=0.3, name="stone dark"}
local top = rect(0, 1168, 1000, 34)
work(top, {hand="body", pile=stL, coverage=2.2, angle=0, clip=top})
work(PARAPET - top, {hand="body", pile=stD, coverage=2.2, angle=0.05, clip=PARAPET - top})

-- the gown: red earth, darker in its turned planes
local drL = pile{{"red earth", 2}, {"vermilion", 1}, {"lead white", 0.3}, turps=0.25, name="gown light"}
local drD = pile{{"red earth", 2}, {"bone black", 0.7}, {"raw umber", 0.5}, turps=0.25, name="gown dark"}
work(DRESS - PARAPET, {hand="body", piles=tents({drD, drL}, LV), coverage=2.2, angle=F:field("fall"), clip=DRESS - PARAPET})

-- the hair: a middle brown
local hrL = pile{{"raw umber", 1}, {"red earth", 0.6}, {"yellow ochre", 0.8}, {"lead white", 0.3}, turps=0.3, name="hair light"}
local hrD = pile{{"raw umber", 1.4}, {"red earth", 0.5}, {"bone black", 0.3}, turps=0.3, name="hair dark"}
work(HAIR, {hand="body", piles=tents({hrD, hrL}, LV), coverage=2.2, angle=F:field("fall"), clip=HAIR})

-- the flesh in verdaccio: green earth and umber in the shadows, lead white in the lights
local v1 = pile{{"green earth", 2}, {"raw umber", 1.2}, {"bone black", 0.15}, {"lead white", 0.6}, name="verd 1"}
local v2 = pile{{"green earth", 2}, {"raw umber", 0.6}, {"lead white", 1.6}, name="verd 2"}
local v3 = pile{{"green earth", 1}, {"raw umber", 0.2}, {"lead white", 2.6}, {"yellow ochre", 0.1}, name="verd 3"}
local v4 = pile{{"lead white", 4}, {"green earth", 0.3}, {"yellow ochre", 0.12}, name="verd 4"}
work(SKIN, {hand="body", piles=tents({v1, v2, v3, v4}, LV), coverage=2.5, angle=F:field("across"), clip=SKIN, tool="filbert 6"})
blend(SKIN:shrink(2), {angle=F:field("across")})
print(wait(3 * 24 * 60))
