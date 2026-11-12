-- The design: the masks every later chunk paints through (globals).
F = build_form()
HEAD = F:parts_mask{1}
BODYF = F:parts_mask{2}

-- where the skin of the face shows: the head under the hairline, short of
-- the hair drawn down over the near ear
SKINPOLY = poly({{396, 660}, {396, 380}, {416, 336}, {448, 302}, {478, 288}, {505, 283}, {540, 287},
  {572, 300}, {596, 326}, {608, 366}, {614, 410}, {614, 460}, {607, 510}, {594, 560}, {582, 660}}, true)
FACE = HEAD * SKINPOLY

-- the neck, and the breast above the gown's square neckline
CHESTPOLY = poly({{440, 560}, {640, 560}, {650, 680}, {700, 712}, {736, 740}, {734, 790}, {728, 818},
  {620, 822}, {520, 822}, {420, 820}, {408, 790}, {406, 745}, {440, 712}}, true)
NECK = (BODYF * CHESTPOLY) - HEAD
SKIN = FACE + NECK

-- the hair: a cap over the skull, a sliver beyond the far temple, the mass
-- drawn down over the near ear and gathered behind into a braid down the back
HAIRBACK = poly({{600, 360}, {660, 300}, {692, 360}, {702, 450}, {700, 560}, {692, 660}, {682, 740},
  {652, 772}, {632, 700}, {628, 600}, {625, 520}, {612, 450}}, true)
HAIRFAR = poly({{442, 316}, {414, 340}, {402, 385}, {406, 430}, {418, 470}, {428, 470}, {424, 420},
  {426, 370}, {440, 335}}, true)
HAIR = (HEAD:grow(7):roughen(3, 40, 5) + HAIRFAR + HAIRBACK) - FACE - NECK:shrink(2)

-- the gown: everything of the body below and beside the neckline
DRESS = BODYF - NECK - HAIR - HEAD
FIGURE = HEAD + HAIR + NECK + DRESS

-- the parapet across the bottom, in front of everything
PARAPET = rect(0, 1168, 1000, 170)
BG = everywhere() - FIGURE - PARAPET
print(FACE:area(), HAIR:area(), NECK:area(), DRESS:area(), BG:area())
