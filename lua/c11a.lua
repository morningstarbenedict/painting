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
