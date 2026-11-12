clear_palette()
local rg = pile{{"rose madder", 1}, {"red earth", 0.15}, medium=0.8, name="madder glaze"}
local rgd = pile{{"rose madder", 1}, {"bone black", 0.35}, {"raw umber", 0.2}, medium=0.75, name="bodice shadow glaze"}
work(BODICE, {hand="glaze", pile=rg, coverage=1, angle=F:field("fall"), clip=BODICE})
-- the bodice turns at its sides; soft folds gather toward the waist
local folds = noise{seed=5, period=45, octaves=2, stretch={1.5, 5}}
work(BODICE * mask(function(x, y)
    local side = smoothstep(500, 430, x) + smoothstep(600, 700, x)
    return clamp(0.8 * side + 0.6 * math.max(0, folds(x, y)) * smoothstep(850, 1100, y), 0, 1)
  end), {hand="glaze", pile=rgd, coverage=1, angle=F:field("fall"), clip=BODICE})

