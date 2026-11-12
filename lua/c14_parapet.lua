clear_palette()
-- the parapet: a lit arris along its top, grey stone with a little life in it,
-- the shadow of the sitter where she leans behind it
local arris = pile{{"lead white", 3}, {"yellow ochre", 0.15}, {"raw umber", 0.15}, name="arris"}
local b = brush{kind="flat", width=4, stiffness=0.6}
for x = 0, 1000, 60 do
  b:reload(arris, 0.6)
  b:stroke({{x - 4, 1170}, {x + 66, 1169.5}}, {pressure={0.5, 0.45}})
end
local edge = pile{{"raw umber", 1}, {"bone black", 0.4}, {"lead white", 0.6}, name="stone edge"}
b:reload(edge, 0.5)
for x = 0, 1000, 60 do
  b:reload(edge, 0.5)
  b:stroke({{x - 4, 1201}, {x + 66, 1200.5}}, {pressure={0.45, 0.4}})
end
-- stone: a veil of mottling
local st = noise{seed=77, period=60, octaves=4}
local stM = pile{{"lead white", 2}, {"raw umber", 0.6}, {"yellow ochre", 0.3}, {"bone black", 0.12}, name="stone mottle"}
work(PARFRONT * mask(function(x, y) return smoothstep(0.0, 0.5, st(x, y)) end), {hand="scumble", pile=stM, coverage=0.7, angle=0, clip=PARFRONT})
-- the figure's shadow on the top, falling right
local sh = poly({{560, 1171}, {760, 1171}, {840, 1199}, {600, 1199}}, true):soften(12) * PARTOP
work(sh, {hand="glaze", pile=pile{{"raw umber", 1}, {"bone black", 0.3}, {"lead white", 0.3}, medium=0.7, name="stone shadow"}, coverage=1, angle=0, clip=PARTOP})
