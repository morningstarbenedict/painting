clear_palette()
-- the parapet's face laid again smooth: grey stone, a little warmer in its light
local st = noise{seed=77, period=90, octaves=3}
local s1 = pile{{"lead white", 1.4}, {"raw umber", 0.75}, {"bone black", 0.3}, {"yellow ochre", 0.1}, name="stone 1"}
local s2 = pile{{"lead white", 1.8}, {"raw umber", 0.7}, {"bone black", 0.25}, {"yellow ochre", 0.25}, name="stone 2"}
local s3 = pile{{"lead white", 1.2}, {"raw umber", 0.8}, {"bone black", 0.4}, {"green earth", 0.2}, name="stone 3"}
work(PARFRONT, {hand="body", piles={{s1, 1}, {s2, function(x, y) return 0.8 * clamp(st(x, y) + 0.3, 0, 1) * (1 - x / 1400) end},
  {s3, function(x, y) return 0.8 * clamp(-st(x, y) + 0.2, 0, 1) + 0.3 * smoothstep(1250, 1333, y) end}},
  coverage=2.6, fill=true, angle=0.02, clip=PARFRONT, tool="filbert 10", length={40, 120}})
local arris = pile{{"lead white", 3}, {"yellow ochre", 0.15}, {"raw umber", 0.2}, name="arris"}
local b = brush{kind="flat", width=3, stiffness=0.6}
for x = 0, 1000, 70 do
  b:reload(arris, 0.55)
  b:stroke({{x - 4, 1170.5}, {x + 76, 1170}}, {pressure={0.45, 0.4}})
end
local edge = pile{{"raw umber", 1}, {"bone black", 0.45}, {"lead white", 0.5}, name="stone edge"}
for x = 0, 1000, 70 do
  b:reload(edge, 0.5)
  b:stroke({{x - 4, 1201.5}, {x + 76, 1201}}, {pressure={0.4, 0.35}})
end
