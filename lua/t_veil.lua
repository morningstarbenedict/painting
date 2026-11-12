clear_palette()
local s = SPH[2]
local v1 = pile{{"lead white", 2.2}, {"yellow ochre", 0.35}, {"red earth", 0.18}, {"green earth", 0.15}, {"raw umber", 0.08}, thinner=0.6, name="veil"}
local m = s.m * mask(function(x, y) return smoothstep(0.2, 0.7, s.v(x, y)) end)
work(m, {hand="scumble", pile=v1, coverage=0.9, clip=s.m, angle=0.6})
work(m, {hand="scumble", pile=v1, coverage=0.9, clip=s.m, angle=2.1})
local s3 = SPH[3]
local m3 = s3.m * mask(function(x, y) return smoothstep(0.2, 0.7, s3.v(x, y)) end)
work(m3, {hand="glaze", pile=pile{{"lead white", 2.2}, {"yellow ochre", 0.35}, {"red earth", 0.18}, {"green earth", 0.15}, medium=0.5, name="veil2"}, coverage=1, clip=s3.m})
