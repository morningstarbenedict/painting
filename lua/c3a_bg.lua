-- dead colouring, 1: the background, dark olive umber, a breath lighter behind the shadowed side
palette{set_out={"lead white", "vermilion", "red earth", "yellow ochre", "raw umber", "bone black",
  "green earth", "rose madder", "copper green", "smalt", "Naples yellow"}}
BGD = pile{{"bone black", 1}, {"raw umber", 1.6}, {"green earth", 1.2}, {"lead white", 0.12}, turps=0.15, name="bg dark"}
BGL = pile{{"bone black", 0.55}, {"raw umber", 1.6}, {"green earth", 1.5}, {"yellow ochre", 0.35}, {"lead white", 0.45}, turps=0.15, name="bg light"}
function bg_w_dark(x, y) return 1 - smoothstep(380, 950, x) * 0.85 end
function bg_w_light(x, y) return smoothstep(380, 950, x) * (1 - smoothstep(700, 1150, y) * 0.5) end
work(BG, {hand="broad", piles={{BGD, bg_w_dark}, {BGL, bg_w_light}}, coverage=3, load=0.9, fill=true,
  angle=function(x, y) return 1.35 + 0.25 * math.sin(x / 260 + y / 310) end, clip=BG:grow(3), edge="soft"})
