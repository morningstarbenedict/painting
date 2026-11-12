clear_palette()
-- the background's second coat: a deep, quiet umber-green, darkest behind the
-- lit profile, warming and opening a little behind the shadowed side; and the
-- parapet's edges

BGD2 = pile{{"bone black", 1}, {"raw umber", 1.8}, {"green earth", 1.0}, {"lead white", 0.08}, name="bg2 dark"}
BGL2 = pile{{"bone black", 0.45}, {"raw umber", 1.6}, {"green earth", 1.4}, {"yellow ochre", 0.45}, {"lead white", 0.5}, name="bg2 light"}
work(BG, {hand="broad", piles={{BGD2, bg_w_dark}, {BGL2, bg_w_light}}, coverage=2.2, load=0.85, fill=true,
  angle=function(x, y) return 1.45 + 0.2 * math.sin(x / 300 + y / 270) end, clip=BG:grow(2),
  edge={found=0.3, soft=0.5, lost=0.2, period=50}})
blend(BG:shrink(6), {angle=1.5})
