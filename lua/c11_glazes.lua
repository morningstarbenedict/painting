clear_palette()
-- after the gown has set: glazes over the sleeves, the bodice and the hair;
-- the slope of the far shoulder, the neck's turned side
print(wait(6 * 24 * 60))

-- the far shoulder's slope: skin from the neck down to the gown
SLOPE = poly({{474, 600}, {466, 650}, {450, 684}, {426, 704}, {404, 716}, {440, 718}, {480, 718}, {480, 600}}, true):soften(1) - NECK:shrink(3) - BAND
SLOPE = SLOPE * (everywhere() - HAIR)
local function slopeLV(x, y) return 0.55 + 0.25 * smoothstep(404, 470, x) - 0.15 * smoothstep(600, 700, y) end
work(SLOPE, {hand="body", piles=tents_g(FL, slopeLV, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=0.9, clip=SLOPE,
  tool="filbert 4", length={6, 14}})
SKIN = SKIN + SLOPE
BG = BG - SLOPE

-- the gown: verdigris over the sleeves, deepest in their turns; rose madder over the bodice
local vg = pile{{"copper green", 1}, {"bone black", 0.25}, {"raw umber", 0.2}, medium=0.8, name="verdigris glaze"}
local vgd = pile{{"copper green", 0.6}, {"bone black", 0.6}, {"raw umber", 0.4}, medium=0.75, name="sleeve shadow glaze"}
work(SLEEVES, {hand="glaze", pile=vg, coverage=1, angle=F:field("fall"), clip=SLEEVES})
work(SLEEVES * mask(function(x, y) return 1 - smoothstep(0.25, 0.6, LV(x, y)) end), {hand="glaze", pile=vgd, coverage=1, angle=F:field("fall"), clip=SLEEVES})
local rg = pile{{"rose madder", 1}, {"red earth", 0.15}, medium=0.8, name="madder glaze"}
local rgd = pile{{"rose madder", 1}, {"bone black", 0.35}, {"raw umber", 0.2}, medium=0.75, name="bodice shadow glaze"}
work(BODICE, {hand="glaze", pile=rg, coverage=1, angle=F:field("fall"), clip=BODICE})
-- the bodice turns at its sides; soft folds gather toward the waist
local folds = noise{seed=5, period=45, octaves=2, stretch={1.5, 5}}
work(BODICE * mask(function(x, y)
    local side = smoothstep(500, 430, x) + smoothstep(600, 700, x)
    return clamp(0.8 * side + 0.6 * math.max(0, folds(x, y)) * smoothstep(850, 1100, y), 0, 1)
  end), {hand="glaze", pile=rgd, coverage=1, angle=F:field("fall"), clip=BODICE})

-- the hair deepened to auburn, the strands showing through
local hg = pile{{"raw umber", 1}, {"red earth", 0.35}, {"bone black", 0.06}, medium=0.75, name="hair glaze"}
work(HAIR, {hand="glaze", pile=hg, coverage=1, angle=FH:field("fall"), clip=HAIR})
work(HAIR * mask(function(x, y) return 1 - smoothstep(0.3, 0.65, HLV(x, y)) end), {hand="glaze", pile=hg, coverage=1, angle=FH:field("fall"), clip=HAIR})

-- the neck's turned side and the shadow of the hair on it
local ng = pile{{"raw umber", 1}, {"red earth", 0.4}, {"green earth", 0.3}, {"lead white", 0.25}, medium=0.7, name="neck shadow glaze"}
local nm = NECK * mask(function(x, y) return smoothstep(560, 625, x) * (1 - smoothstep(700, 760, y) * 0.5) end)
work(nm, {hand="glaze", pile=ng, coverage=1, angle=1.57, clip=NECK})
