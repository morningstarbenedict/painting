clear_palette()
-- sfumato at the contours: the far cheek lost into the dark, the hairline softened
local dark = pile{{"bone black", 0.8}, {"raw umber", 1.6}, {"green earth", 1}, {"lead white", 0.15}, name="lose dark"}
local farside = FACE * mask(function(x, y) return smoothstep(470, 430, x) end)
lose(FACE, {pile=dark, where=function(x, y) return smoothstep(470, 440, x) * (1 - smoothstep(560, 600, y)) * 0.8 end,
  tool="filbert 3", reach={4, 5}, load=0.15})
local hairc = pile{{"raw umber", 1.2}, {"red earth", 0.5}, {"yellow ochre", 0.2}, name="lose hair"}
lose(FACE, {pile=hairc, where=function(x, y) return (smoothstep(420, 440, x) * (1 - smoothstep(330, 360, y))) * 0.6 + smoothstep(590, 610, x) * 0.5 end,
  tool="filbert 3", reach={4, 4}, load=0.15})
