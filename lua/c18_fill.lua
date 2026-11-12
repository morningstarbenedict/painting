clear_palette()
-- the hole between the far shoulder's slope and the breast, filled with flesh;
-- the speckled patch on the near side of the breast laid again
local FILL = poly({{410, 712}, {436, 694}, {470, 684}, {488, 700}, {488, 748}, {414, 748}}, true) - BAND2 - CHEM2:grow(0.5) - HAIR
local PATCH = (NECK * rect(600, 725, 150, 100)) - BAND2 - CHEM2:grow(0.5) - HAIR
local area = FILL + PATCH
work(area, {hand="body", piles=tents_g(FL, CV, 0.12, 0.95, 1.4), coverage=3, fill=true, angle=0.15, clip=area,
  tool="filbert 3", length={5, 12}, load=0.9})
SKIN = SKIN + FILL
