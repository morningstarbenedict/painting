clear_palette()
-- the background's second coat, left half: deep, quiet umber-green
BGD2 = pile{{"bone black", 1}, {"raw umber", 1.8}, {"green earth", 1.0}, {"lead white", 0.08}, name="bg2 dark"}
BGL2 = pile{{"bone black", 0.45}, {"raw umber", 1.6}, {"green earth", 1.4}, {"yellow ochre", 0.45}, {"lead white", 0.5}, name="bg2 light"}
BGHALF = {BG * rect(0, 0, 505, 1334), BG * rect(495, 0, 505, 1334)}
local m = BGHALF[1]
work(m, {hand="broad", piles={{BGD2, bg_w_dark}, {BGL2, bg_w_light}}, coverage=2.2, load=0.85, fill=true,
  angle=function(x, y) return 1.45 + 0.2 * math.sin(x / 300 + y / 270) end, clip=BG:grow(2),
  edge={found=0.3, soft=0.5, lost=0.2, period=50}})
