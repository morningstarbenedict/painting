clear_palette()
-- the hair deepened to auburn, the strands showing through
local hg = pile{{"raw umber", 1}, {"red earth", 0.35}, {"bone black", 0.06}, medium=0.75, name="hair glaze"}
work(HAIR, {hand="glaze", pile=hg, coverage=1, angle=FH:field("fall"), clip=HAIR})
work(HAIR * mask(function(x, y) return 1 - smoothstep(0.3, 0.65, HLV(x, y)) end), {hand="glaze", pile=hg, coverage=1, angle=FH:field("fall"), clip=HAIR})

-- the neck's turned side and the shadow of the hair on it
local ng = pile{{"raw umber", 1}, {"red earth", 0.4}, {"green earth", 0.3}, {"lead white", 0.25}, medium=0.7, name="neck shadow glaze"}
local nm = NECK * mask(function(x, y) return smoothstep(560, 625, x) * (1 - smoothstep(700, 760, y) * 0.5) end)
work(nm, {hand="glaze", pile=ng, coverage=1, angle=1.57, clip=NECK})
