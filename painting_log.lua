-- easel session "portrait": a painting replayed chunk by chunk.
-- Each "--@ chunk" line starts one chunk as it was run at the easel.
--@ box friedrich
--@ engine 9
--@ knife-skim
--@ palette-carried-paint
--@ limbs-join-nearest
--@ reload-finite
--@ blend-feather
--@ brush-skim
--@ blend-at-masks
--@ glaze-film
--@ liquid-film-levels
--@ sealed-drawing-guide
--@ drawing-optics
--@ rag-lift
--@ full-palette-refuses
--@ pastel-current-heap
--@ calls-agree
--@ drain
--@ paper

--@ chunk 1
-- a fine linen, sized and knifed smooth with lead white as a panel's gesso,
-- the top coat toned a light warm buff: the imprimatura
canvas{size=500, aspect=0.75, linen={34, 30}, seed=11,
  ground={{pile={{"lead white", 8}, {"yellow ochre", 0.12}}, um=160, apply="knife", texture=0.06},
          {pile={{"lead white", 8}, {"yellow ochre", 0.12}}, um=80, apply="knife", texture=0.04},
          {pile={{"lead white", 8}, {"yellow ochre", 0.55}, {"raw umber", 0.22}, {"red earth", 0.06}}, um=30, apply="knife", texture=0.03}}}
print(W, H)

--@ chunk 2
-- The sitter's head as a solid: built facing the viewer about the eye line's
-- center E, then turned three-quarters toward the light (viewer's left).
-- Units: canvas units; x right, y down, z toward the viewer.
EX, EY = 530, 400            -- eye line center on the canvas
HS = 1.15                    -- the head's scale
YAW, PITCH, ROLL = 0.40, 0.10, 0.06

local function P(x, y, z) return {EX + HS * x, EY + HS * y, HS * z} end
local function E(c, r) return body.ellipsoid(c, r) end
local function R(r) return {HS * r[1], HS * r[2], HS * r[3]} end

function build_head()
  local h = E(P(0, -52, -38), R{102, 124, 128})                     -- cranium, its front the forehead
  h = h:union(E(P(0, 42, 4), R{84, 96, 80}), 42)                    -- face mass
  h = h:union(E(P(-42, 50, 40), R{32, 30, 30}), 34)                 -- cheek R
  h = h:union(E(P(42, 50, 40), R{32, 30, 30}), 34)                  -- cheek L
  h = h:union(E(P(0, 102, -10), R{66, 60, 66}), 36)                  -- jaw
  h = h:union(E(P(0, 149, 34), R{24, 20, 22}), 24)                  -- chin
  h = h:union(E(P(0, -16, 56), R{78, 20, 24}), 26)                  -- brow
  -- the nose: bridge, tip, wings
  h = h:union(E(P(0, 24, 78), R{10, 42, 13}), 12)
  h = h:union(E(P(0, 66, 89), R{12, 12, 11}), 10)
  h = h:union(E(P(-13, 72, 78), R{10, 8, 10}), 8)
  h = h:union(E(P(13, 72, 78), R{10, 8, 10}), 8)
  -- the mouth: muzzle, upper lip, lower lip
  h = h:union(E(P(0, 104, 54), R{36, 26, 21}), 18)
  h = h:union(E(P(0, 101, 70), R{23, 7, 9}), 8)
  h = h:union(E(P(0, 116, 68), R{19, 8, 10}), 8)
  -- eye sockets carved under the brow, the eyeballs in them
  h = h:subtract(E(P(-40, 2, 84), R{30, 18, 18}), 14)
  h = h:subtract(E(P(40, 2, 84), R{30, 18, 18}), 14)
  h = h:union(E(P(-40, 3, 52), R{20, 20, 20}), 4)
  h = h:union(E(P(40, 3, 52), R{20, 20, 20}), 4)
  return h:turn(P(0, 0, 0), YAW, PITCH, ROLL)
end

function build_neck()
  return E({EX + 12, EY + 260, -50}, {66, 130, 60}):turn({EX + 12, EY + 260, -50}, 0, -0.12, 0.05)
end

function build_torso()
  local t = E({555, 1010, -90}, {205, 300, 120})
  t = t:union(E({368, 790, -70}, {78, 80, 68}), 55)      -- far shoulder
  t = t:union(E({752, 800, -50}, {88, 88, 78}), 55)      -- near shoulder
  t = t:union(E({335, 1010, -80}, {70, 230, 64}), 34)    -- far arm
  t = t:union(E({795, 1030, -40}, {84, 240, 74}), 34)    -- near arm
  return t:turn({555, 1010, -90}, 0.22, 0.0, 0.0)
end

function build_form()
  return form{{build_head()}, {build_neck():union(build_torso(), 45), dist=0.05},
    light={from={-1, -0.75}, front=0.5, ambient=0.22, bounce=0.12, penumbra=0.06}}
end

-- head-local (frontal, about E) -> canvas x, y and z, as :turn does
function proj(x, y, z)
  x, y, z = HS * x, HS * y, HS * z
  local sy, cy = math.sin(YAW), math.cos(YAW)
  local sp, cp = math.sin(PITCH), math.cos(PITCH)
  local sr, cr = math.sin(ROLL), math.cos(ROLL)
  -- yaw
  local x1, y1, z1 = cy * x - sy * z, y, sy * x + cy * z
  -- pitch
  local x2, y2, z2 = x1, cp * y1 + sp * z1, -sp * y1 + cp * z1
  -- roll
  local x3, y3 = cr * x2 - sr * y2, sr * x2 + cr * y2
  return EX + x3, EY + y3, z2
end
function pp(x, y, z) local a, b = proj(x, y, z); return {a, b} end

-- a soft light of my own from the solid's normals: wrapped diffuse (sfumato),
-- the cast shadows of the solid, a little reflected light from below right
LX, LY, LZ = -0.62, -0.58, 0.53
do local n = math.sqrt(LX*LX + LY*LY + LZ*LZ); LX, LY, LZ = LX/n, LY/n, LZ/n end
WRAP = 0.55
function lightval(s)
  local n = s.n
  local d = n[1]*LX + n[2]*LY + n[3]*LZ
  local v = clamp((d + WRAP) / (1 + WRAP), 0, 1)
  v = v ^ 1.35
  local cast = s.shade.cast or 0
  v = v * (1 - 0.0 * cast)
  local b = clamp(n[1]*0.6 + n[2]*0.5 + n[3]*0.2, 0, 1)   -- bounce from lower right
  return clamp(0.10 + 0.86 * v + 0.10 * b, 0, 1)
end

--@ chunk 3
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

--@ chunk 4
-- The features, drawn in the head's own frontal coordinates and laid onto its
-- turned surface: each point found where the solid is under it.

-- canvas offset and depth -> head-local (the inverse of proj)
function unproj(xc, yc, zc)
  local x3, y3, z2 = xc - EX, yc - EY, zc
  local sy, cy = math.sin(YAW), math.cos(YAW)
  local sp, cp = math.sin(PITCH), math.cos(PITCH)
  local sr, cr = math.sin(ROLL), math.cos(ROLL)
  local x2, y2 = cr * x3 + sr * y3, -sr * x3 + cr * y3
  local y1, z1 = cp * y2 - sp * z2, sp * y2 + cp * z2
  local x, z = cy * x2 + sy * z1, -sy * x2 + cy * z1
  return x / HS, y1 / HS, z / HS
end

-- the canvas point of the head's front surface at head-local (x, y)
function onface(x, y, z0, lift)
  local z = z0 or 60
  local cx, cy
  for _ = 1, 6 do
    cx, cy = proj(x, y, z)
    local s = F:sample(cx, cy)
    if not s or s.part ~= 1 then break end
    local hx, hy, hz = unproj(cx, cy, s.z)
    -- move along the head's z until its (x, y) match
    z = hz + (lift or 0)
    local ex, ey = x - hx, y - hy
    if math.abs(ex) + math.abs(ey) < 0.05 then break end
  end
  cx, cy = proj(x, y, z)
  return {cx, cy}
end

local function path(pts, z0, lift)
  local out = {}
  for _, p in ipairs(pts) do out[#out + 1] = onface(p[1], p[2], z0, lift) end
  return out
end
local function arc(cx, cy, w, h, n, a0, a1)
  local out = {}
  for i = 0, n do
    local a = a0 + (a1 - a0) * i / n
    out[#out + 1] = {cx + w * math.cos(a), cy + h * math.sin(a)}
  end
  return out
end

-- the eyes: lids as arcs over the eyeballs; s = -1 the sitter's right
-- (viewer's left, far), 1 her left (near)
EYES = {}
for _, s in ipairs({-1, 1}) do
  local cx, cy = 40 * s, 3
  local e = {}
  -- inner corner toward the nose, outer corner a little higher
  local inner, outer = {cx - 15 * s, cy + 1.5}, {cx + 17 * s, cy - 1}
  local up, low = {}, {}
  for i = 0, 12 do
    local t = i / 12
    local x = inner[1] + (outer[1] - inner[1]) * t
    local yb = inner[2] + (outer[2] - inner[2]) * t
    up[#up + 1] = {x, yb - 8.5 * math.sin(math.pi * t ^ 0.85)}
    low[#low + 1] = {x, yb + 4.5 * math.sin(math.pi * t ^ 1.1)}
  end
  e.up = path(up, 70, 1.5)
  e.low = path(low, 70, 1.0)
  -- the crease of the upper lid, above it
  local cr = {}
  for i = 0, 10 do
    local t = i / 10
    local x = inner[1] + 2 * s + (outer[1] - inner[1] - 1 * s) * t
    cr[#cr + 1] = {x, cy - 7 - 7 * math.sin(math.pi * t ^ 0.8)}
  end
  e.crease = path(cr, 70, 0.5)
  -- the iris looks a little toward the viewer: shifted toward +x in the head
  e.irisc = {cx + 3.5, cy - 0.8}
  e.iris_r = 7.6
  e.inner, e.outer = onface(inner[1], inner[2], 70), onface(outer[1], outer[2], 70)
  e.center = onface(e.irisc[1], e.irisc[2], 72)
  -- the brow
  local br = {}
  for i = 0, 10 do
    local t = i / 10
    local x = cx - 19 * s + 42 * s * t
    br[#br + 1] = {x, cy - 23 - 6 * math.sin(math.pi * (t ^ 0.7)) + 2 * t}
  end
  e.brow = path(br, 74, 1)
  EYES[s] = e
end

-- the nose: the bridge's shadow side, the wings, the nostrils
NOSE = {
  side = path({{7, -2}, {9, 20}, {10, 42}, {12, 58}, {15, 66}}, 80, 0.5),
  wingR = path({{-8, 64}, {-18, 66}, {-21, 73}, {-17, 79}, {-9, 80}}, 80, 0.5),
  wingL = path({{8, 64}, {18, 66}, {21, 73}, {17, 79}, {9, 80}}, 80, 0.5),
  base = path({{-14, 79}, {-6, 81.5}, {0, 82.5}, {6, 81.5}, {14, 79}}, 85, 0.5),
  nostR = path({{-11, 77.5}, {-6, 79}, {-3, 80}}, 85, 0),
  nostL = path({{11, 77.5}, {6, 79}, {3, 80}}, 85, 0),
  tip = onface(0, 66, 100),
}

-- the mouth: the line between the lips, the upper lip's edge, the lower's
MOUTH = {
  line = path({{-24, 107}, {-15, 108.5}, {-6, 108.2}, {0, 109.2}, {6, 108.2}, {15, 108.5}, {24, 107}}, 74, 0),
  upper = path({{-23, 106.5}, {-14, 101}, {-5, 98.5}, {0, 100.3}, {5, 98.5}, {14, 101}, {23, 106.5}}, 74, 0.5),
  lower = path({{-20, 109}, {-12, 116.5}, {0, 119}, {12, 116.5}, {20, 109}}, 74, 0.5),
  center = onface(0, 109, 74),
  cornerR = onface(-24, 107, 70), cornerL = onface(24, 107, 70),
}
CHIN = onface(0, 150, 60)
print("eye R", EYES[-1].center[1], EYES[-1].center[2], " eye L", EYES[1].center[1], EYES[1].center[2])
print("nose tip", NOSE.tip[1], NOSE.tip[2], " mouth", MOUTH.center[1], MOUTH.center[2], " chin", CHIN[1], CHIN[2])

--@ chunk 5
-- the underdrawing: the features and contours laid in lightly, as a cartoon
-- pounced and gone over with a fine point
local c = pencil("2B")
local function ln(pts, p) c:line(pts, {pressure=p}) end

-- the silhouette of the face, found from the solid row by row
local far, near, chin = {}, {}, {}
for y = 340, 590, 10 do
  for x = 380, 560 do if HEAD:at(x, y) > 0.5 then far[#far + 1] = {x, y}; break end end
end
for y = 470, 585, 10 do
  for x = 680, 480, -1 do if HEAD:at(x, y) > 0.5 then near[#near + 1] = {x, y}; break end end
end
for x = 440, 590, 10 do
  for y = 640, 480, -1 do if HEAD:at(x, y) > 0.5 and BODYF:at(x, y + 3) < 0.5 then chin[#chin + 1] = {x, y}; break end end
end
FACE_FAR, FACE_NEAR, FACE_CHIN = far, near, chin
ln(far, 0.32); ln(near, 0.3); ln(chin, 0.3)

for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  ln(e.up, 0.45); ln(e.low, 0.25); ln(e.crease, 0.2); ln(e.brow, 0.25)
  -- the iris, a circle on the eyeball
  local ir = {}
  for i = 0, 16 do
    local a = 2 * math.pi * i / 16
    ir[#ir + 1] = onface(e.irisc[1] + e.iris_r * math.cos(a), e.irisc[2] + e.iris_r * math.sin(a), 72)
  end
  ln(ir, 0.25)
end
ln(NOSE.side, 0.22); ln(NOSE.wingR, 0.3); ln(NOSE.wingL, 0.3); ln(NOSE.base, 0.25)
ln(MOUTH.line, 0.4); ln(MOUTH.upper, 0.22); ln(MOUTH.lower, 0.2)

-- the hairline and the neckline, lightly
ln({{416, 336}, {448, 302}, {478, 288}, {505, 283}, {540, 287}, {572, 300}, {596, 326}, {608, 366}, {614, 410}, {614, 460}, {607, 510}}, 0.2)
ln({{406, 745}, {408, 790}, {420, 820}, {520, 822}, {620, 822}, {728, 818}, {734, 790}, {736, 740}}, 0.2)
print(#far, #near, #chin)

--@ chunk 6
-- dead colouring, 1: the background, dark olive umber, a breath lighter behind the shadowed side
palette{set_out={"lead white", "vermilion", "red earth", "yellow ochre", "raw umber", "bone black",
  "green earth", "rose madder", "copper green", "smalt", "Naples yellow"}}
BGD = pile{{"bone black", 1}, {"raw umber", 1.6}, {"green earth", 1.2}, {"lead white", 0.12}, turps=0.15, name="bg dark"}
BGL = pile{{"bone black", 0.55}, {"raw umber", 1.6}, {"green earth", 1.5}, {"yellow ochre", 0.35}, {"lead white", 0.45}, turps=0.15, name="bg light"}
function bg_w_dark(x, y) return 1 - smoothstep(380, 950, x) * 0.85 end
function bg_w_light(x, y) return smoothstep(380, 950, x) * (1 - smoothstep(700, 1150, y) * 0.5) end
work(BG, {hand="broad", piles={{BGD, bg_w_dark}, {BGL, bg_w_light}}, coverage=3, load=0.9, fill=true,
  angle=function(x, y) return 1.35 + 0.25 * math.sin(x / 260 + y / 310) end, clip=BG:grow(3), edge="soft"})

--@ chunk 7
-- dead colouring, 2: parapet, gown, hair, and the flesh in verdaccio

function LV(x, y)
  local s = F:sample(x, y)
  if s then return lightval(s) end
  return 0.35
end
-- weights for a ladder of piles over a value function: a tent around each step
function tents(list, vf, lo, hi)
  local out = {}
  local n = #list
  for i, p in ipairs(list) do
    local c = (i - 1) / (n - 1)
    out[#out + 1] = {p, function(x, y)
      local t = clamp((vf(x, y) - lo) / (hi - lo), 0, 1)
      return math.max(0, 1 - math.abs(t - c) * (n - 1)) + 0.001
    end}
  end
  return out
end

-- the hair's own solid, for its light: a cap over the skull and the braid behind
do
  local function P(x, y, z) return {EX + HS * x, EY + HS * y, HS * z} end
  local cap = body.ellipsoid(P(0, -52, -38), {HS * 110, HS * 133, HS * 136})
  cap = cap:union(body.ellipsoid(P(-80, 10, -10), {HS * 34, HS * 70, HS * 60}), 30)
  cap = cap:union(body.ellipsoid(P(86, 10, -10), {HS * 34, HS * 70, HS * 60}), 30)
  cap = cap:turn(P(0, 0, 0), YAW, PITCH, ROLL)
  local braid = body.ellipsoid({662, 560, -40}, {36, 230, 30}):turn({662, 560, -40}, 0, 0, -0.05)
  FH = form{{cap}, {braid}, light={from={-1, -0.75}, front=0.5, ambient=0.22}}
end
function HLV(x, y)
  local s = FH:sample(x, y)
  if s then return lightval(s) end
  return 0.3
end

-- the parapet: grey stone, its top lit
local stL = pile{{"lead white", 3}, {"raw umber", 0.55}, {"bone black", 0.2}, {"yellow ochre", 0.25}, turps=0.15, name="stone light"}
local stD = pile{{"lead white", 1.3}, {"raw umber", 0.8}, {"bone black", 0.4}, turps=0.15, name="stone dark"}
PARTOP = rect(0, 1168, 1000, 32)
PARFRONT = PARAPET - PARTOP
work(PARTOP, {hand="body", pile=stL, coverage=2.6, fill=true, angle=0, clip=PARTOP})
work(PARFRONT, {hand="body", pile=stD, coverage=2.6, fill=true, angle=0.03, clip=PARFRONT})

-- the gown: red earth and vermilion, darker in its turned planes (to be glazed)
local drL = pile{{"red earth", 1.6}, {"vermilion", 1.2}, {"lead white", 0.25}, turps=0.1, name="gown light"}
local drM = pile{{"red earth", 2}, {"vermilion", 0.4}, {"raw umber", 0.3}, turps=0.1, name="gown mid"}
local drD = pile{{"red earth", 1.6}, {"bone black", 0.7}, {"raw umber", 0.6}, turps=0.1, name="gown dark"}
GOWN = DRESS - PARAPET
work(GOWN, {hand="body", piles=tents({drD, drM, drL}, LV, 0.15, 0.85), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=GOWN, tool="filbert 12"})

-- the hair: chestnut, darker where it turns from the light
local hr = {
  pile{{"raw umber", 1.4}, {"red earth", 0.5}, {"bone black", 0.35}, turps=0.1, name="hair 1"},
  pile{{"raw umber", 1.2}, {"red earth", 0.7}, {"yellow ochre", 0.5}, {"lead white", 0.1}, turps=0.1, name="hair 2"},
  pile{{"raw umber", 0.8}, {"red earth", 0.6}, {"yellow ochre", 1}, {"lead white", 0.35}, turps=0.1, name="hair 3"},
}
work(HAIR, {hand="body", piles=tents(hr, HLV, 0.2, 0.85), coverage=2.6, fill=true, angle=FH:field("fall"), clip=HAIR, tool="filbert 7"})

-- the flesh in verdaccio: black and ochre's green-grey, green earth, lead white
VERD = {
  pile{{"bone black", 0.5}, {"raw umber", 1}, {"green earth", 1}, {"yellow ochre", 0.3}, name="verd 0"},
  pile{{"bone black", 0.3}, {"yellow ochre", 0.6}, {"green earth", 1.5}, {"raw umber", 0.5}, {"lead white", 0.3}, name="verd 1"},
  pile{{"bone black", 0.15}, {"yellow ochre", 0.5}, {"green earth", 1.5}, {"raw umber", 0.3}, {"lead white", 0.9}, name="verd 2"},
  pile{{"bone black", 0.06}, {"yellow ochre", 0.3}, {"green earth", 1.2}, {"lead white", 1.6}, name="verd 3"},
  pile{{"green earth", 0.6}, {"yellow ochre", 0.12}, {"lead white", 2.6}, name="verd 4"},
  pile{{"lead white", 4}, {"green earth", 0.2}, {"yellow ochre", 0.1}, name="verd 5"},
}
work(SKIN, {hand="body", piles=tents(VERD, LV, 0.14, 0.95), coverage=3, fill=true,
  angle=F:field("across"), clip=SKIN, tool="filbert 6"})
blend(SKIN:shrink(2), {angle=F:field("across")})
print(wait(3 * 24 * 60))

--@ chunk 8
for _, p in ipairs({{450,380},{500,330},{590,450},{600,520},{520,610},{470,470}}) do print(p[1],p[2], string.format("LV %.2f", LV(p[1],p[2])), drying(p[1],p[2])) end

--@ chunk 9
-- scrape every heap off the board
function clear_palette()
  local names = {}
  for line in string.gmatch(palette(), "[^\n]+") do
    local n = string.match(line, "^%s*%d+%. (.-): ")
    if n then names[#names + 1] = n end
  end
  if #names > 0 then palette{scrape=names} end
  return #names
end

--@ chunk 10
-- scrape every heap off the board
function clear_palette()
  local names = {}
  for line in string.gmatch(palette(), "[^\n]+") do
    local n = string.match(line, "^%s*%d+%. (.-): ")
    if n then n = string.gsub(n, " %(.-%)$", ""); names[#names + 1] = n end
  end
  if #names > 0 then palette{scrape=names} end
  return #names
end

--@ chunk 11
-- the flesh: one smooth pass of short strokes from a six-step ladder, umber
-- shadow to Naples-yellow light, cool greenish halftones between, the rose of
-- the cheeks, the nose and the chin worked into it wet
clear_palette()
FL = {
  pile{{"raw umber", 1}, {"red earth", 0.4}, {"bone black", 0.1}, {"green earth", 0.3}, {"lead white", 0.1}, name="flesh 0"},
  pile{{"raw umber", 1}, {"red earth", 0.4}, {"green earth", 0.4}, {"yellow ochre", 0.2}, {"lead white", 0.45}, name="flesh 1"},
  pile{{"lead white", 1.2}, {"raw umber", 0.45}, {"red earth", 0.25}, {"yellow ochre", 0.35}, {"green earth", 0.35}, name="flesh 2"},
  pile{{"lead white", 2.2}, {"yellow ochre", 0.35}, {"red earth", 0.18}, {"green earth", 0.15}, {"raw umber", 0.08}, name="flesh 3"},
  pile{{"lead white", 3}, {"yellow ochre", 0.25}, {"vermilion", 0.05}, {"red earth", 0.04}, name="flesh 4"},
  pile{{"lead white", 4}, {"Naples yellow", 0.4}, {"vermilion", 0.02}, name="flesh 5"},
}
ROSE = pile{{"lead white", 2.4}, {"vermilion", 0.22}, {"rose madder", 0.06}, {"yellow ochre", 0.15}, name="rose"}

local function blob(p, rx, ry)
  return function(x, y)
    local dx, dy = (x - p[1]) / rx, (y - p[2]) / ry
    return math.exp(-(dx * dx + dy * dy))
  end
end
local cheekN = blob(onface(48, 52, 60), 34, 30)
local cheekF = blob(onface(-46, 50, 60), 22, 26)
local noseT = blob(onface(0, 64, 95), 12, 12)
local chinB = blob(onface(0, 150, 60), 22, 14)
function ROSY(x, y)
  return clamp(0.8 * cheekN(x, y) + 0.55 * cheekF(x, y) + 0.45 * noseT(x, y) + 0.4 * chinB(x, y), 0, 1)
end

-- the light on the skin, with the jaw's shadow falling down and right onto the neck
function LVF(x, y)
  local v = LV(x, y)
  if HEAD:at(x, y) < 0.5 then
    local sh = 0
    for _, d in ipairs({{-8, -22}, {-12, -34}, {-16, -46}, {-5, -14}}) do
      if HEAD:at(x + d[1], y + d[2]) > 0.5 then sh = sh + 0.25 end
    end
    v = v * (1 - 0.6 * sh)
  end
  return v
end

local ps = tents(FL, LVF, 0.12, 0.95)
ps[#ps + 1] = {ROSE, function(x, y) return 1.3 * ROSY(x, y) * smoothstep(0.3, 0.6, LV(x, y)) end}
work(SKIN, {hand="body", piles=ps, coverage=3, fill=true, angle=F:field("across"), clip=SKIN,
  tool="filbert 4", length={6, 14}})
print(wait(4 * 24 * 60))

--@ chunk 12
for _, p in ipairs({{450,380},{590,450},{520,610},{500,330}}) do print(drying(p[1],p[2])) end

--@ chunk 13
-- the flesh, second coat: the same ladder pressed darker in the middle tones,
-- over the first now set
print(wait(3 * 24 * 60))
function tents_g(list, vf, lo, hi, g)
  local out = {}
  local n = #list
  for i, p in ipairs(list) do
    local c = (i - 1) / (n - 1)
    out[#out + 1] = {p, function(x, y)
      local t = clamp((vf(x, y) - lo) / (hi - lo), 0, 1) ^ g
      return math.max(0, 1 - math.abs(t - c) * (n - 1)) + 0.001
    end}
  end
  return out
end
local ps = tents_g(FL, LVF, 0.12, 0.95, 1.5)
ps[#ps + 1] = {ROSE, function(x, y) return 1.1 * ROSY(x, y) * smoothstep(0.35, 0.65, LV(x, y)) end}
work(SKIN, {hand="body", piles=ps, coverage=3, fill=true, angle=F:field("across"), clip=SKIN,
  tool="filbert 4", length={6, 14}, load=0.9})
print(wait(4 * 24 * 60))

--@ chunk 14
clear_palette()
-- the eyes: whites, irises, pupils, the lids and their lashes, the light in them

local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
local function circle_on_face(c, r, z, n)
  local o = {}
  for i = 0, (n or 24) - 1 do
    local a = 2 * math.pi * i / (n or 24)
    o[#o + 1] = onface(c[1] + r * math.cos(a), c[2] + r * math.sin(a), z)
  end
  return o
end

local white = pile{{"lead white", 2}, {"raw umber", 0.1}, {"bone black", 0.035}, {"yellow ochre", 0.06}, name="eye white"}
local whiteS = pile{{"lead white", 1.2}, {"raw umber", 0.25}, {"bone black", 0.06}, {"red earth", 0.05}, name="eye white shade"}
local irisD = pile{{"raw umber", 1}, {"bone black", 0.35}, {"red earth", 0.1}, name="iris dark"}
local irisM = pile{{"raw umber", 1}, {"red earth", 0.3}, {"yellow ochre", 0.45}, {"lead white", 0.15}, name="iris mid"}
local irisL = pile{{"raw umber", 0.6}, {"yellow ochre", 0.8}, {"red earth", 0.15}, {"lead white", 0.45}, name="iris light"}
local pupil = pile{{"bone black", 1}, {"raw umber", 0.2}, name="pupil"}
local lash = pile{{"bone black", 0.8}, {"raw umber", 1}, {"red earth", 0.25}, name="lash"}
local lidS = pile{{"raw umber", 1}, {"red earth", 0.5}, {"lead white", 0.6}, medium=0.55, name="lid shadow"}
local lowlid = pile{{"red earth", 0.6}, {"raw umber", 0.5}, {"lead white", 1.0}, name="low lid"}
local glint = pile{{"lead white", 1}, blot=0.15, name="glint"}
local caruncle = pile{{"lead white", 1}, {"vermilion", 0.25}, {"rose madder", 0.1}, name="caruncle"}

EYEM = {}
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local opening = poly(cat(e.up, rev(e.low)), true)
  local ir = poly(circle_on_face(e.irisc, e.iris_r, 72), true) * opening
  local pu = poly(circle_on_face({e.irisc[1] + 0.2, e.irisc[2] + 0.3}, 3.0, 73), true) * opening
  EYEM[s] = {opening = opening, iris = ir, pupil = pu}
  local cx, cy = e.center[1], e.center[2]
  local far = (s == -1) and 0.82 or 1
  -- the whites: greyer toward the corners and under the upper lid
  local wsh = function(x, y)
    local dx = math.abs(x - cx) / 18
    local top = clamp((cy - y + 4) / 8, 0, 1)
    return clamp(0.3 + dx * 0.6 + top * 0.6 + (1 - far) * 2, 0, 1)
  end
  work(opening - ir:grow(0.5), {hand="detail", piles={{white, function(x, y) return 1 - wsh(x, y) end}, {whiteS, wsh}},
    coverage=3, fill=true, clip=opening, tool={kind="round", width=1.4, point=0.6}})
  -- the iris: a dark rim, warm brown, lighter below where the light comes through
  local rr = e.iris_r * HS
  work(ir, {hand="detail", piles={
      {irisD, function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2) / rr; return smoothstep(0.6, 1.0, d) + 0.3 * clamp((cy - y) / rr, 0, 1) end},
      {irisM, function(x, y) return 0.6 end},
      {irisL, function(x, y) return 0.9 * clamp((y - cy) / rr + 0.2, 0, 1) * clamp((x - cx) / rr + 0.6, 0, 1) end}},
    coverage=3, fill=true, clip=ir, tool={kind="round", width=1.2, point=0.6}})
  work(pu, {hand="detail", pile=pupil, coverage=3, fill=true, clip=pu, tool={kind="round", width=1.0, point=0.7}})
  -- the upper lid's shadow over the top of the eye
  local band = opening * mask(function(x, y) return clamp((cy + 1 - y) / 6, 0, 1) end)
  work(band, {hand="glaze", pile=lidS, coverage=0.9, clip=opening})
  -- the lid line and its lashes, heavier toward the outer corner
  local b = brush{kind="round", width=2.0, point=0.9, stiffness=0.4}
  b:load(lash, 0.7)
  local pts = {}
  for i, p in ipairs(e.up) do
    local t = (i - 1) / (#e.up - 1)   -- 0 at the inner corner, 1 at the outer
    pts[#pts + 1] = {p[1], p[2] - 0.3, 0.25 + 0.6 * smoothstep(0.1, 0.9, t)}
  end
  b:gesture(pts, {wobble=0.3})
  b:reload(lash, 0.5)
  b:gesture(pts, {wobble=0.4})
  -- a few lashes at the outer corner, flicked out and down the face's turn
  for k = 1, 5 do
    local i = #e.up - k
    local p = e.up[i]
    b:reload(lash, 0.4)
    b:gesture({{p[1], p[2], 0.5}, {p[1] + 2.2 * s, p[2] - 2.5, 0.0}}, {})
  end
  -- the lower lid: a warm, broken line
  local b2 = brush{kind="round", width=1.4, point=0.9}
  b2:load(lowlid, 0.5)
  local lp = {}
  for i, p in ipairs(e.low) do lp[#lp + 1] = {p[1], p[2] + 0.6, 0.15 + 0.35 * math.sin(math.pi * (i - 1) / (#e.low - 1))} end
  b2:gesture(lp, {wobble=0.3})
  -- the crease of the lid
  local b3 = brush{kind="round", width=2.4, point=0.6}
  b3:load(lidS, 0.5)
  local cp = {}
  for i, p in ipairs(e.crease) do cp[#cp + 1] = {p[1], p[2], 0.15 + 0.3 * math.sin(math.pi * (i - 1) / (#e.crease - 1))} end
  b3:gesture(cp, {wobble=0.5})
  -- the caruncle at the inner corner
  local tb = brush{kind="round", width=1.6, point=0.5}
  tb:load(caruncle, 0.5)
  tb:touch(e.inner[1] - 1.4 * s, e.inner[2] - 0.2, {pressure=0.35})
end
-- the glints: the window's light in each eye, up and toward the light
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local g = brush{kind="round", width=1.5, point=0.6, lay=3}
  g:load(glint, 0.8)
  local r = e.iris_r * HS
  g:touch(e.center[1] - 0.35 * r, e.center[2] - 0.35 * r, {pressure=(s == 1) and 0.45 or 0.35})
end

--@ chunk 15
-- lift the first try at the eyes while it is wet
local m = nil
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local pts = {}
  for _, p in ipairs(e.up) do pts[#pts + 1] = p end
  for _, p in ipairs(e.crease) do pts[#pts + 1] = p end
  for i = #e.low, 1, -1 do pts[#pts + 1] = e.low[i] end
  local mm = EYEM[s].opening:grow(4) + ribbon(e.crease, 6) + ribbon(e.up, 9)
  m = m and (m + mm) or mm
end
EYELIFT = m:soften(2)
for k = 1, 3 do
  local r = rag{width=10}
  r:dip(0.9)
  r:wipe(EYELIFT, {pressure=0.7, angle=(k == 2) and 1.57 or 0, passes=2})
end
print(drying(EYES[1].center[1], EYES[1].center[2]))

--@ chunk 16
-- The features, drawn in the head's own frontal coordinates and laid onto its
-- turned surface: each point found where the solid is under it.

-- canvas offset and depth -> head-local (the inverse of proj)
function unproj(xc, yc, zc)
  local x3, y3, z2 = xc - EX, yc - EY, zc
  local sy, cy = math.sin(YAW), math.cos(YAW)
  local sp, cp = math.sin(PITCH), math.cos(PITCH)
  local sr, cr = math.sin(ROLL), math.cos(ROLL)
  local x2, y2 = cr * x3 + sr * y3, -sr * x3 + cr * y3
  local y1, z1 = cp * y2 - sp * z2, sp * y2 + cp * z2
  local x, z = cy * x2 + sy * z1, -sy * x2 + cy * z1
  return x / HS, y1 / HS, z / HS
end

-- the canvas point of the head's front surface at head-local (x, y)
function onface(x, y, z0, lift)
  local z = z0 or 60
  local cx, cy
  for _ = 1, 6 do
    cx, cy = proj(x, y, z)
    local s = F:sample(cx, cy)
    if not s or s.part ~= 1 then break end
    local hx, hy, hz = unproj(cx, cy, s.z)
    -- move along the head's z until its (x, y) match
    z = hz + (lift or 0)
    local ex, ey = x - hx, y - hy
    if math.abs(ex) + math.abs(ey) < 0.05 then break end
  end
  cx, cy = proj(x, y, z)
  return {cx, cy}
end

local function path(pts, z0, lift)
  local out = {}
  for _, p in ipairs(pts) do out[#out + 1] = onface(p[1], p[2], z0, lift) end
  return out
end
local function arc(cx, cy, w, h, n, a0, a1)
  local out = {}
  for i = 0, n do
    local a = a0 + (a1 - a0) * i / n
    out[#out + 1] = {cx + w * math.cos(a), cy + h * math.sin(a)}
  end
  return out
end

-- the eyes: lids as arcs over the eyeballs; s = -1 the sitter's right
-- (viewer's left, far), 1 her left (near)
EYES = {}
for _, s in ipairs({-1, 1}) do
  local cx, cy = 40 * s, 3
  local e = {}
  -- inner corner toward the nose, outer corner a little higher
  local inner, outer = {cx - 16 * s, cy + 1.5}, {cx + 18.5 * s, cy - 1.2}
  local up, low = {}, {}
  for i = 0, 12 do
    local t = i / 12
    local x = inner[1] + (outer[1] - inner[1]) * t
    local yb = inner[2] + (outer[2] - inner[2]) * t
    up[#up + 1] = {x, yb - 10 * math.sin(math.pi * t ^ 0.85)}
    low[#low + 1] = {x, yb + 5.5 * math.sin(math.pi * t ^ 1.1)}
  end
  e.up = path(up, 70, 1.5)
  e.low = path(low, 70, 1.0)
  -- the crease of the upper lid, above it
  local cr = {}
  for i = 0, 10 do
    local t = i / 10
    local x = inner[1] + 2 * s + (outer[1] - inner[1] - 1 * s) * t
    cr[#cr + 1] = {x, cy - 8.5 - 7.5 * math.sin(math.pi * t ^ 0.8)}
  end
  e.crease = path(cr, 70, 0.5)
  -- the iris looks a little toward the viewer: shifted toward +x in the head
  e.irisc = {cx + 3.5, cy - 0.2}
  e.iris_r = 8.4
  e.inner, e.outer = onface(inner[1], inner[2], 70), onface(outer[1], outer[2], 70)
  e.center = onface(e.irisc[1], e.irisc[2], 72)
  -- the brow
  local br = {}
  for i = 0, 10 do
    local t = i / 10
    local x = cx - 19 * s + 42 * s * t
    br[#br + 1] = {x, cy - 23 - 6 * math.sin(math.pi * (t ^ 0.7)) + 2 * t}
  end
  e.brow = path(br, 74, 1)
  EYES[s] = e
end

-- the nose: the bridge's shadow side, the wings, the nostrils
NOSE = {
  side = path({{7, -2}, {9, 20}, {10, 42}, {12, 58}, {15, 66}}, 80, 0.5),
  wingR = path({{-8, 64}, {-18, 66}, {-21, 73}, {-17, 79}, {-9, 80}}, 80, 0.5),
  wingL = path({{8, 64}, {18, 66}, {21, 73}, {17, 79}, {9, 80}}, 80, 0.5),
  base = path({{-14, 79}, {-6, 81.5}, {0, 82.5}, {6, 81.5}, {14, 79}}, 85, 0.5),
  nostR = path({{-11, 77.5}, {-6, 79}, {-3, 80}}, 85, 0),
  nostL = path({{11, 77.5}, {6, 79}, {3, 80}}, 85, 0),
  tip = onface(0, 66, 100),
}

-- the mouth: the line between the lips, the upper lip's edge, the lower's
MOUTH = {
  line = path({{-24, 107}, {-15, 108.5}, {-6, 108.2}, {0, 109.2}, {6, 108.2}, {15, 108.5}, {24, 107}}, 74, 0),
  upper = path({{-23, 106.5}, {-14, 101}, {-5, 98.5}, {0, 100.3}, {5, 98.5}, {14, 101}, {23, 106.5}}, 74, 0.5),
  lower = path({{-20, 109}, {-12, 116.5}, {0, 119}, {12, 116.5}, {20, 109}}, 74, 0.5),
  center = onface(0, 109, 74),
  cornerR = onface(-24, 107, 70), cornerL = onface(24, 107, 70),
}
CHIN = onface(0, 150, 60)
print("eye R", EYES[-1].center[1], EYES[-1].center[2], " eye L", EYES[1].center[1], EYES[1].center[2])
print("nose tip", NOSE.tip[1], NOSE.tip[2], " mouth", MOUTH.center[1], MOUTH.center[2], " chin", CHIN[1], CHIN[2])

--@ chunk 17
clear_palette()
-- the eyes, second try: the lids' flesh restated around them, then the whites,
-- warm brown irises under heavy lids, a soft lid line with no separate lashes

local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
local function circle_on_face(c, r, z, n)
  local o = {}
  for i = 0, (n or 24) - 1 do
    local a = 2 * math.pi * i / (n or 24)
    o[#o + 1] = onface(c[1] + r * math.cos(a), c[2] + r * math.sin(a), z)
  end
  return o
end
print(wait(2 * 24 * 60))

EYEM = {}
local open_all
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local opening = poly(cat(e.up, rev(e.low)), true)
  EYEM[s] = {opening = opening}
  open_all = open_all and (open_all + opening) or opening
end
-- the lids and the sockets' flesh, restated in the flesh ladder over the old try
local ring = (EYELIFT:grow(3) - open_all:shrink(0.5)) * FACE
work(ring, {hand="body", piles=tents_g(FL, LVF, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=F:field("across"),
  clip=ring:grow(1), tool="filbert 3", length={4, 9}, load=0.9})
clear_palette()

local white = pile{{"lead white", 2}, {"raw umber", 0.14}, {"bone black", 0.03}, {"yellow ochre", 0.08}, name="eye white"}
local whiteS = pile{{"lead white", 1}, {"raw umber", 0.35}, {"red earth", 0.08}, {"bone black", 0.04}, name="eye white shade"}
local irisD = pile{{"raw umber", 1}, {"bone black", 0.25}, {"red earth", 0.15}, name="iris dark"}
local irisM = pile{{"raw umber", 1}, {"red earth", 0.25}, {"yellow ochre", 0.35}, name="iris mid"}
local irisL = pile{{"raw umber", 0.7}, {"yellow ochre", 0.8}, {"red earth", 0.2}, {"lead white", 0.25}, name="iris light"}
local pupil = pile{{"bone black", 1}, {"raw umber", 0.3}, name="pupil"}
local lid = pile{{"raw umber", 1}, {"bone black", 0.35}, {"red earth", 0.35}, {"lead white", 0.12}, name="lid line"}
local lidS = pile{{"raw umber", 1}, {"red earth", 0.5}, {"lead white", 0.5}, medium=0.6, name="lid shadow"}
local lowlid = pile{{"red earth", 0.5}, {"raw umber", 0.6}, {"lead white", 1.2}, medium=0.3, name="low lid"}
local glint = pile{{"lead white", 1}, blot=0.15, name="glint"}
local caruncle = pile{{"lead white", 1.2}, {"vermilion", 0.2}, {"rose madder", 0.08}, {"raw umber", 0.05}, name="caruncle"}

for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local opening = EYEM[s].opening
  local ir = poly(circle_on_face(e.irisc, e.iris_r, 72), true) * opening
  local pu = poly(circle_on_face({e.irisc[1] + 0.2, e.irisc[2] + 0.4}, 3.1, 73), true) * opening
  EYEM[s].iris, EYEM[s].pupil = ir, pu
  local cx, cy = e.center[1], e.center[2]
  local far = (s == -1) and 0.8 or 1
  local wsh = function(x, y)
    local dx = math.abs(x - cx) / 20
    local top = clamp((cy - y + 3) / 9, 0, 1)
    return clamp(0.25 + dx * 0.55 + top * 0.7 + (1 - far) * 1.5, 0, 1)
  end
  work(opening - ir:grow(0.5), {hand="detail", piles={{white, function(x, y) return 1 - wsh(x, y) end}, {whiteS, wsh}},
    coverage=3, fill=true, clip=opening, tool={kind="round", width=1.6, point=0.5}})
  local rr = e.iris_r * HS
  work(ir, {hand="detail", piles={
      {irisD, function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2) / rr; return 1.3 * smoothstep(0.65, 1.0, d) + 0.6 * clamp((cy - y) / rr + 0.2, 0, 1) end},
      {irisM, function(x, y) return 0.6 end},
      {irisL, function(x, y) return 1.1 * clamp((y - cy) / rr + 0.1, 0, 1) * clamp((x - cx) / rr + 0.8, 0, 1) end}},
    coverage=3, fill=true, clip=ir, tool={kind="round", width=1.2, point=0.6}})
  work(pu, {hand="detail", pile=pupil, coverage=3, fill=true, clip=pu, tool={kind="round", width=1.0, point=0.7}})
  local band = opening * mask(function(x, y) return clamp((cy + 2 - y) / 7, 0, 1) end)
  work(band, {hand="glaze", pile=lidS, coverage=1, clip=opening})
  local b = brush{kind="round", width=2.8, point=0.6, stiffness=0.35}
  local pts = {}
  for i, p in ipairs(e.up) do
    local t = (i - 1) / (#e.up - 1)
    pts[#pts + 1] = {p[1], p[2] - 0.2, 0.18 + 0.42 * smoothstep(0.05, 0.85, t) - 0.25 * smoothstep(0.92, 1, t)}
  end
  b:load(lid, 0.55)
  b:gesture(pts, {wobble=0.2})
  local b2 = brush{kind="round", width=1.8, point=0.6}
  b2:load(lowlid, 0.4)
  local lp = {}
  for i, p in ipairs(e.low) do lp[#lp + 1] = {p[1], p[2] + 0.9, 0.08 + 0.22 * math.sin(math.pi * (i - 1) / (#e.low - 1))} end
  b2:gesture(lp, {wobble=0.3})
  local cm = ribbon(e.crease, 3.2):soften(2.2) * FACE
  work(cm, {hand="glaze", pile=lidS, coverage=0.9, clip=cm:grow(2)})
  local tb = brush{kind="round", width=2.0, point=0.4}
  tb:load(caruncle, 0.5)
  tb:touch(e.inner[1] - 1.5 * s, e.inner[2] - 0.3, {pressure=0.35})
end
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local g = brush{kind="round", width=1.7, point=0.5, lay=3}
  g:load(glint, 0.8)
  local r = e.iris_r * HS
  g:touch(e.center[1] - 0.3 * r, e.center[2] - 0.3 * r, {pressure=(s == 1) and 0.45 or 0.35})
end

--@ chunk 18
clear_palette()
-- the nose, the mouth, the brows: soft, found only where the form turns sharply

local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
local function press(pts, f) local o = {} for i, p in ipairs(pts) do o[#o + 1] = {p[1], p[2], f((i - 1) / (#pts - 1))} end return o end

local nostril = pile{{"raw umber", 1}, {"red earth", 0.7}, {"bone black", 0.2}, name="nostril"}
local crease = pile{{"raw umber", 0.8}, {"red earth", 0.7}, {"lead white", 0.7}, medium=0.4, name="crease"}
local hiN = pile{{"lead white", 4}, {"Naples yellow", 0.4}, {"vermilion", 0.02}, blot=0.1, name="highlight"}
local lipU = pile{{"lead white", 1}, {"rose madder", 0.35}, {"red earth", 0.45}, {"raw umber", 0.12}, name="upper lip"}
local lipL = pile{{"lead white", 1.6}, {"vermilion", 0.3}, {"rose madder", 0.2}, {"yellow ochre", 0.05}, name="lower lip"}
local mline = pile{{"red earth", 1}, {"raw umber", 0.9}, {"rose madder", 0.35}, {"bone black", 0.1}, name="mouth line"}
local browP = pile{{"raw umber", 1}, {"yellow ochre", 0.4}, {"lead white", 0.6}, {"red earth", 0.1}, medium=0.45, name="brow"}

-- nostrils and the wings' creases
local b = brush{kind="round", width=2.6, point=0.7}
for _, k in ipairs({"nostR", "nostL"}) do
  local m = ribbon(NOSE[k], (k == "nostR") and 2.6 or 2.0):soften(1.2)
  work(m, {hand="detail", pile=nostril, coverage=2, clip=m:grow(1), tool={kind="round", width=1.4, point=0.6}})
end
b:load(crease, 0.5)
b:gesture(press(NOSE.wingR, function(t) return 0.15 + 0.35 * math.sin(math.pi * t) end), {wobble=0.4})
b:reload(crease, 0.4)
b:gesture(press(NOSE.wingL, function(t) return 0.1 + 0.25 * math.sin(math.pi * t) end), {wobble=0.4})
-- the shadow under the nose's base, soft
local under = ribbon(NOSE.base, 4):soften(3)
work(under, {hand="glaze", pile=pile{{"raw umber", 0.7}, {"red earth", 0.5}, {"lead white", 0.3}, medium=0.75, name="under nose"}, coverage=0.9, clip=under:grow(3)})

-- the lips: the upper turned down from the light, darker; the lower full and lit
local upper = poly(cat(MOUTH.upper, rev(MOUTH.line)), true):soften(1.2)
local lower = poly(cat(MOUTH.line, rev(MOUTH.lower)), true):soften(1.6)
work(upper, {hand="detail", pile=lipU, coverage=3, fill=true, clip=upper, tool={kind="round", width=1.6, point=0.5}, edge="soft"})
work(lower, {hand="detail", pile=lipL, coverage=3, fill=true, clip=lower, tool={kind="round", width=1.8, point=0.5}, edge="soft"})
blend(upper + lower, {angle=0, tool={kind="badger", width=10}})
-- the line between them, darkest at the corners and the middle, lifting a little at the corners
local ml = {}
for i, p in ipairs(MOUTH.line) do
  local t = (i - 1) / (#MOUTH.line - 1)
  ml[#ml + 1] = {p[1], p[2] + 0.2, 0.3 + 0.35 * (math.abs(t - 0.5) * 2) ^ 2 + 0.15 * math.exp(-((t - 0.5) / 0.1) ^ 2)}
end
local bm = brush{kind="round", width=1.8, point=0.9}
bm:load(mline, 0.6)
bm:gesture(ml, {wobble=0.2})
-- the corners: a soft dimple of shadow
for _, c in ipairs({MOUTH.cornerR, MOUTH.cornerL}) do
  local m = ellipse(c[1], c[2] - 0.5, 3.2, 2.4):soften(2)
  work(m, {hand="glaze", pile=pile{{"raw umber", 0.8}, {"red earth", 0.6}, {"lead white", 0.4}, medium=0.7, name="corner"}, coverage=1, clip=m:grow(2)})
end
-- the shadow under the lower lip
local ul = {}
for _, p in ipairs(MOUTH.lower) do ul[#ul + 1] = {p[1], p[2] + 3.5} end
local um = ribbon(ul, 5):soften(3)
work(um, {hand="glaze", pile=pile{{"raw umber", 0.7}, {"red earth", 0.5}, {"lead white", 0.5}, medium=0.75, name="under lip"}, coverage=0.9, clip=um:grow(3)})

-- the brows: fine, plucked high, a few hairs' worth of soft strokes
for _, s in ipairs({-1, 1}) do
  local br = EYES[s].brow
  local bb = brush{kind="round", width=1.3, point=0.9}
  for k = 1, 16 do
    local t = (k - 0.5) / 16
    local i = math.max(1, math.min(#br - 1, math.floor(t * (#br - 1)) + 1))
    local p, q = br[i], br[i + 1]
    local x, y = lerp(p[1], q[1], 0.5) + rand(-1.5, 1.5), lerp(p[2], q[2], 0.5) + rand(-1.2, 1.2)
    local dx, dy = q[1] - p[1], q[2] - p[2]
    local l = math.sqrt(dx * dx + dy * dy)
    dx, dy = dx / l, dy / l
    bb:reload(browP, 0.35)
    local len = rand(4, 7) * (1 - 0.4 * t)
    bb:gesture({{x, y, 0.2}, {x + dx * len * 0.5, y + dy * len * 0.5 - 0.6, 0.35}, {x + dx * len, y + dy * len, 0.0}}, {})
  end
end

-- the lights: the bridge and tip of the nose, the lower lip, the chin's ball
local hb = brush{kind="round", width=2.2, point=0.5, lay=2}
hb:load(hiN, 0.6)
local t = NOSE.tip
hb:touch(t[1] - 2, t[2] - 3, {pressure=0.4})
local br = {}
for _, y in ipairs({10, 25, 40, 52}) do br[#br + 1] = onface(-3, y, 80) end
hb:reload(hiN, 0.4)
hb:gesture(press(br, function(t) return 0.08 + 0.2 * math.sin(math.pi * t) end), {wobble=0.3})
hb:reload(pile{{"lead white", 3}, {"vermilion", 0.1}, {"rose madder", 0.03}, name="lip light"}, 0.4)
local ll = onface(-4, 114, 74)
hb:touch(ll[1], ll[2], {pressure=0.3, drag={3, 0}})

--@ chunk 19
clear_palette()
-- velature: thin veils of light flesh in medium over the set flesh, smoothing
-- it into sfumato; the eyes warmed, the lips filled, the brows found
print(wait(4 * 24 * 60))
local feats = (EYEM[-1].opening + EYEM[1].opening):grow(1.5)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3.5) end
local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
LIPS = poly(cat(MOUTH.upper, rev(MOUTH.lower)), true)
feats = feats + LIPS:grow(1)
local skinV = SKIN:shrink(1.5) - feats
local vL = pile{{"lead white", 3}, {"yellow ochre", 0.25}, {"vermilion", 0.04}, {"red earth", 0.03}, medium=0.5, name="veil light"}
local vM = pile{{"lead white", 2.2}, {"yellow ochre", 0.35}, {"red earth", 0.16}, {"green earth", 0.16}, {"raw umber", 0.06}, medium=0.5, name="veil mid"}
local vD = pile{{"lead white", 1}, {"raw umber", 0.4}, {"red earth", 0.25}, {"yellow ochre", 0.3}, {"green earth", 0.3}, medium=0.55, name="veil dark"}
-- the lights, then the half-lights, each veiled once, the shadows once
work(skinV * mask(function(x, y) return smoothstep(0.42, 0.75, LVF(x, y)) end), {hand="glaze", pile=vL, coverage=1, clip=SKIN})
work(skinV * mask(function(x, y) local v = LVF(x, y); return smoothstep(0.22, 0.4, v) * (1 - smoothstep(0.55, 0.75, v)) end), {hand="glaze", pile=vM, coverage=1, clip=SKIN})
work(skinV * mask(function(x, y) return 1 - smoothstep(0.18, 0.35, LVF(x, y)) end), {hand="glaze", pile=vD, coverage=1, clip=SKIN})
-- the upper lip and the philtrum: lighter, so no shadow sits there like a moustache
local ul = poly({onface(-24, 86, 70), onface(-8, 83, 80), onface(8, 83, 80), onface(24, 86, 70), onface(24, 104, 66), onface(0, 99, 74), onface(-24, 104, 66)}, true):soften(4) - LIPS:grow(1)
work(ul, {hand="glaze", pile=vM, coverage=1, clip=SKIN})
print(wait(2 * 24 * 60))
-- the eyes: irises deepened with a warm brown glaze, whites warmed a breath
local ig = pile{{"raw umber", 1}, {"red earth", 0.35}, {"yellow ochre", 0.2}, medium=0.7, name="iris glaze"}
local wg = pile{{"lead white", 1}, {"yellow ochre", 0.12}, {"red earth", 0.03}, medium=0.6, name="white glaze"}
for _, s in ipairs({-1, 1}) do
  work(EYEM[s].iris, {hand="glaze", pile=ig, coverage=1, clip=EYEM[s].iris, tool={kind="round", width=3, point=0.4}})
  work(EYEM[s].opening - EYEM[s].iris:grow(0.5), {hand="glaze", pile=wg, coverage=1, clip=EYEM[s].opening, tool={kind="round", width=3, point=0.4}})
end
-- the lips: fuller colour, soft at their edges
local lg = pile{{"rose madder", 0.6}, {"vermilion", 0.5}, {"lead white", 0.6}, {"red earth", 0.15}, medium=0.55, name="lip glaze"}
work(LIPS:soften(1.5), {hand="glaze", pile=lg, coverage=1, clip=LIPS:grow(2), tool={kind="filbert", width=4}})
-- the brows: soft, faint, as plucked
local bgz = pile{{"raw umber", 1}, {"yellow ochre", 0.35}, {"red earth", 0.15}, {"lead white", 0.3}, medium=0.6, name="brow glaze"}
for _, s in ipairs({-1, 1}) do
  local br = EYES[s].brow
  local w = {}
  for i = 1, #br do local t = (i - 1) / (#br - 1); w[i] = 1.2 + 2.6 * math.sin(math.pi * t ^ 0.7) * (1 - 0.4 * t) end
  local m = ribbon(br, w):soften(1.5)
  work(m, {hand="glaze", pile=bgz, coverage=1, clip=m:grow(1.5), tool={kind="filbert", width=3}})
  work(m:shrink(0.6), {hand="glaze", pile=bgz, coverage=0.7, clip=m:grow(1), tool={kind="filbert", width=2}})
end

--@ chunk 20
local r = rag{width=8}; r:dip(0.9); r:wipe(LIPS:grow(3), {pressure=0.6, passes=2}); r:refold(); r:dip(0.9); r:wipe(LIPS:grow(3), {pressure=0.6, angle=1.57})

--@ chunk 21
clear_palette()
-- corrections: the shadowed cheek restated, heavier lids, the lips rebuilt
print(wait(2 * 24 * 60))
local feats = (EYEM[-1].opening + EYEM[1].opening):grow(1.5) + LIPS:grow(1)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3.5) end
local shade = (SKIN:shrink(1.5) - feats) * mask(function(x, y) return 1 - smoothstep(0.42, 0.62, LVF(x, y)) end)
work(shade, {hand="body", piles=tents_g(FL, LVF, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=F:field("across"),
  clip=SKIN - feats, tool="filbert 3", length={4, 10}, load=0.9})

-- the lids lowered over the irises: a band of lid flesh, then the line again
local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
local lidF = pile{{"lead white", 1.6}, {"raw umber", 0.4}, {"red earth", 0.3}, {"yellow ochre", 0.3}, {"green earth", 0.2}, name="lid flesh"}
local lidFL = pile{{"lead white", 2.4}, {"yellow ochre", 0.3}, {"red earth", 0.2}, {"green earth", 0.1}, name="lid flesh light"}
local lid = pile{{"raw umber", 1}, {"bone black", 0.35}, {"red earth", 0.35}, {"lead white", 0.12}, name="lid line"}
local wdark = pile{{"raw umber", 1}, {"red earth", 0.2}, {"lead white", 0.6}, medium=0.7, name="white dark glaze"}
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local up2 = {}
  for i, p in ipairs(e.up) do
    local t = (i - 1) / (#e.up - 1)
    up2[i] = {p[1], p[2] + 2.6 * math.sin(math.pi * t) ^ 0.8}
  end
  local band = poly(cat(e.up, rev(up2)), true):grow(0.6)
  work(band, {hand="detail", piles={{lidF, function(x, y) return 1 - LV(x, y) end}, {lidFL, LV}}, coverage=3, fill=true, clip=band,
    tool={kind="round", width=1.4, point=0.5}})
  -- the whites, lowered in value
  local wm = EYEM[s].opening - EYEM[s].iris:grow(0.3) - band
  work(wm, {hand="glaze", pile=wdark, coverage=1, clip=EYEM[s].opening, tool={kind="round", width=3, point=0.4}})
  local b = brush{kind="round", width=2.8, point=0.6, stiffness=0.35}
  local pts = {}
  for i, p in ipairs(up2) do
    local t = (i - 1) / (#up2 - 1)
    pts[#pts + 1] = {p[1], p[2] - 0.1, 0.2 + 0.4 * smoothstep(0.05, 0.85, t) - 0.25 * smoothstep(0.92, 1, t)}
  end
  b:load(lid, 0.55)
  b:gesture(pts, {wobble=0.2})
  EYES[s].up2 = up2
end

-- the lips rebuilt in body paint, soft at their edges, the line between them again
local upper = poly(cat(MOUTH.upper, rev(MOUTH.line)), true)
local lower = poly(cat(MOUTH.line, rev(MOUTH.lower)), true)
local lipU = pile{{"lead white", 1.2}, {"rose madder", 0.18}, {"red earth", 0.35}, {"raw umber", 0.12}, {"vermilion", 0.05}, name="upper lip"}
local lipL = pile{{"lead white", 1.8}, {"vermilion", 0.16}, {"rose madder", 0.1}, {"red earth", 0.12}, {"yellow ochre", 0.06}, name="lower lip"}
work(upper, {hand="detail", pile=lipU, coverage=3, fill=true, clip=upper:grow(1), tool={kind="round", width=1.8, point=0.4}, edge="soft"})
work(lower, {hand="detail", pile=lipL, coverage=3, fill=true, clip=lower:grow(1.2), tool={kind="round", width=2.0, point=0.4}, edge="soft"})
local mline = pile{{"red earth", 1}, {"raw umber", 0.9}, {"rose madder", 0.3}, {"lead white", 0.15}, name="mouth line"}
local ml = {}
for i, p in ipairs(MOUTH.line) do
  local t = (i - 1) / (#MOUTH.line - 1)
  ml[#ml + 1] = {p[1], p[2] + 0.2, 0.22 + 0.3 * (math.abs(t - 0.5) * 2) ^ 2}
end
local bm = brush{kind="round", width=1.8, point=0.9}
bm:load(mline, 0.5)
bm:gesture(ml, {wobble=0.2})

--@ chunk 22
clear_palette()
-- the hair: parted in the middle, drawn smooth over the head and down over
-- the ears, gathered behind; strands laid along its fall, lit and shadowed

local function bez(p0, p1, p2, p3, n)
  local o = {}
  for i = 0, n do
    local t = i / n
    local a, b, c, d = (1 - t) ^ 3, 3 * (1 - t) ^ 2 * t, 3 * (1 - t) * t * t, t ^ 3
    o[#o + 1] = {a * p0[1] + b * p1[1] + c * p2[1] + d * p3[1], a * p0[2] + b * p1[2] + c * p2[2] + d * p3[2]}
  end
  return o
end

-- the part, from the hairline back over the crown
PART = {{503, 286}, {512, 262}, {526, 236}, {542, 214}, {558, 200}}
local function on_part(t)
  local n = #PART - 1
  local i = math.min(n, math.floor(t * n) + 1)
  local u = t * n - (i - 1)
  return {lerp(PART[i][1], PART[i + 1][1], u), lerp(PART[i][2], PART[i + 1][2], u)}
end

HAIRPILES = {
  pile{{"raw umber", 1.3}, {"bone black", 0.45}, {"red earth", 0.35}, name="strand 0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.7}, {"yellow ochre", 0.35}, {"bone black", 0.1}, name="strand 1"},
  pile{{"raw umber", 0.8}, {"red earth", 0.6}, {"yellow ochre", 0.9}, {"lead white", 0.25}, name="strand 2"},
  pile{{"yellow ochre", 1}, {"raw umber", 0.4}, {"red earth", 0.3}, {"lead white", 0.6}, {"Naples yellow", 0.3}, name="strand 3"},
  pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 1}, {"red earth", 0.1}, name="strand 4"},
}
-- a deeper chestnut body first, over the dead colour
work(HAIR, {hand="body", piles=tents({HAIRPILES[1], HAIRPILES[2], HAIRPILES[3]}, HLV, 0.2, 0.9), coverage=2.5, fill=true,
  angle=FH:field("fall"), clip=HAIR, tool="filbert 6", length={10, 30}})
local function strand_pile(v)
  local i = clamp(math.floor(v * 5) + 1, 1, 5)
  return HAIRPILES[i]
end

-- the strands' paths: from the part out to each side and down
local paths = {}
for k = 1, 260 do
  local t = rand(0.0, 1.0) ^ 0.8
  local p0 = on_part(t)
  local side = (k % 2 == 0) and -1 or 1
  local p3, p1, p2
  if side == -1 then
    -- over the far temple and down beside the cheek
    local endy = lerp(330, 470, rand(0, 1) ^ 1.3)
    p3 = {lerp(426, 408, (endy - 330) / 140) + rand(-6, 6), endy}
    p1 = {p0[1] - 30 - rand(0, 20), p0[2] + rand(-6, 10)}
    p2 = {p3[1] - rand(4, 20), p3[2] - rand(40, 80)}
  else
    -- over the crown to the near side, down over the ear and back to the braid
    local endy = lerp(380, 560, rand(0, 1) ^ 1.1)
    p3 = {lerp(630, 668, (endy - 380) / 180) + rand(-8, 8), endy}
    p1 = {p0[1] + 40 + rand(0, 30), p0[2] + rand(-10, 20)}
    p2 = {p3[1] + rand(5, 25), p3[2] - rand(60, 120)}
  end
  paths[#paths + 1] = bez(p0, p1, p2, p3, 14)
end

-- lay them: dark strands first, then the lit ones over, each tinted by its light
local clipH = HAIR:shrink(1)
local order = {}
for i = 1, #paths do order[i] = i end
local bs = brush{kind="rigger", width=1.6, point=0.9}
for pass = 1, 2 do
  for _, i in ipairs(order) do
    local pts = paths[i]
    local mid = pts[math.floor(#pts / 2)]
    local v = HLV(mid[1], mid[2]) + randn(0, 0.08)
    if (pass == 1 and v < 0.5) or (pass == 2 and v >= 0.5) then
      local g = {}
      for j, p in ipairs(pts) do
        local tt = (j - 1) / (#pts - 1)
        g[#g + 1] = {p[1], p[2], 0.1 + 0.4 * math.sin(math.pi * tt) ^ 0.6}
      end
      bs:reload(strand_pile(clamp(v + (pass == 2 and 0.12 or -0.05), 0, 0.99)), 0.5)
      bs:gesture(g, {wobble=1.2, clip=clipH})
    end
  end
end
-- soften the strands into the mass, then a few crisp lights on the crown and the far side
blend(HAIR:shrink(3) - HAIRBACK, {angle=FH:field("fall")})
local hl = brush{kind="rigger", width=1.2, point=0.95}
for k = 1, 70 do
  local i = math.random(#paths)
  local pts = paths[i]
  local a = math.random(2, 7)
  local seg = {}
  for j = a, math.min(#pts, a + 5) do
    local p = pts[j]
    if HLV(p[1], p[2]) > 0.55 then seg[#seg + 1] = {p[1], p[2], 0.25} end
  end
  if #seg >= 3 then
    seg[1][3] = 0.0; seg[#seg][3] = 0.0
    hl:reload(HAIRPILES[5], 0.4)
    hl:gesture(seg, {wobble=0.6, clip=clipH})
  end
end
-- the part itself, a fine dark line
local bp = brush{kind="round", width=1.2, point=0.9}
bp:load(HAIRPILES[1], 0.5)
bp:gesture({{PART[1][1], PART[1][2], 0.3}, {PART[2][1], PART[2][2], 0.35}, {PART[3][1], PART[3][2], 0.3}, {PART[4][1], PART[4][2], 0.15}}, {clip=clipH})

--@ chunk 23
clear_palette()
-- the gown, 2: the sleeves repainted in green velvet, the bodice's folds,
-- the band of the neckline, the chemise's edge

-- the sleeves: everything of the gown outside the seams
local function seamF(y) return lerp(436, 418, clamp((y - 740) / 430, 0, 1)) end
local function seamN(y) return lerp(706, 738, clamp((y - 750) / 420, 0, 1)) end
SLEEVES = GOWN * mask(function(x, y) return ((x < seamF(y)) or (x > seamN(y))) and 1 or 0 end):soften(1.5)
BODICE = GOWN - SLEEVES
local slD = pile{{"green earth", 1.4}, {"bone black", 0.5}, {"raw umber", 0.5}, {"copper green", 0.3}, turps=0.1, name="sleeve dark"}
local slM = pile{{"green earth", 1.6}, {"copper green", 0.5}, {"yellow ochre", 0.4}, {"lead white", 0.35}, {"bone black", 0.1}, turps=0.1, name="sleeve mid"}
local slL = pile{{"green earth", 1}, {"copper green", 0.4}, {"Naples yellow", 0.5}, {"lead white", 1}, turps=0.1, name="sleeve light"}
-- velvet: folds as the light catches the pile; a fold noise along the arm
local folds = noise{seed=31, period=70, octaves=3, stretch={1.45, 4}}
local function SV(x, y) return clamp(LV(x, y) * 0.8 + 0.25 * folds(x, y), 0, 1) end
work(SLEEVES, {hand="body", piles=tents({slD, slM, slL}, SV, 0.15, 0.8), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=SLEEVES, tool="filbert 10"})
blend(SLEEVES:shrink(3), {angle=F:field("fall")})

-- the bodice's folds and lights: vermilion lights in the lit planes, deep red-black in the turns
local bodN = noise{seed=17, period=55, octaves=3, stretch={1.5, 3}}
local function BV(x, y) return clamp(LV(x, y) * 0.85 + 0.18 * bodN(x, y), 0, 1) end
local bdD = pile{{"red earth", 1.2}, {"bone black", 0.6}, {"rose madder", 0.4}, name="bodice dark"}
local bdM = pile{{"vermilion", 1}, {"red earth", 0.8}, {"rose madder", 0.3}, name="bodice mid"}
local bdL = pile{{"vermilion", 1.3}, {"lead white", 0.35}, {"red earth", 0.2}, name="bodice light"}
work(BODICE, {hand="body", piles=tents({bdD, bdM, bdL}, BV, 0.2, 0.8), coverage=2.4, fill=true,
  angle=F:field("fall"), clip=BODICE, tool="filbert 8"})
blend(BODICE:shrink(3), {angle=F:field("fall")})

-- the neckline's band: black velvet, laid along the edge of the breast
BANDPATH = {{432, 708}, {400, 744}, {401, 793}, {414, 829}, {520, 831}, {620, 831}, {735, 826}, {742, 790}, {744, 738}, {710, 706}}
BAND = ribbon(BANDPATH, 14) * (GOWN + SLEEVES):grow(1) - NECK
local bandP = pile{{"bone black", 1}, {"raw umber", 0.5}, {"smalt", 0.2}, name="band"}
work(BAND, {hand="detail", pile=bandP, coverage=3, fill=true, clip=BAND, tool={kind="round", width=2.2, point=0.5}})

-- the chemise: a fine white edge of linen just inside the neckline, gathered in tiny pleats
CHEM = (CHESTPOLY - CHESTPOLY:shrink(3.2)) * rect(390, 736, 370, 100) * BODYF
local chemS = pile{{"lead white", 2}, {"raw umber", 0.15}, {"bone black", 0.05}, name="chemise shade"}
local chemL = pile{{"lead white", 3}, {"Naples yellow", 0.15}, name="chemise light"}
work(CHEM, {hand="detail", piles={{chemS, function(x, y) return 1 - LV(x, y) end}, {chemL, LV}}, coverage=3, fill=true, clip=CHEM,
  tool={kind="round", width=1.2, point=0.6}})
print(SLEEVES:area(), BODICE:area(), BAND:area(), CHEM:area())

--@ chunk 24
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

--@ chunk 25
clear_palette()
local rg = pile{{"rose madder", 1}, {"red earth", 0.15}, medium=0.8, name="madder glaze"}
local rgd = pile{{"rose madder", 1}, {"bone black", 0.35}, {"raw umber", 0.2}, medium=0.75, name="bodice shadow glaze"}
work(BODICE, {hand="glaze", pile=rg, coverage=1, angle=F:field("fall"), clip=BODICE})
-- the bodice turns at its sides; soft folds gather toward the waist
local folds = noise{seed=5, period=45, octaves=2, stretch={1.5, 5}}
work(BODICE * mask(function(x, y)
    local side = smoothstep(500, 430, x) + smoothstep(600, 700, x)
    return clamp(0.8 * side + 0.6 * math.max(0, folds(x, y)) * smoothstep(850, 1100, y), 0, 1)
  end), {hand="glaze", pile=rgd, coverage=1, angle=F:field("fall"), clip=BODICE})

--@ chunk 26
clear_palette()
-- the hair deepened to auburn, the strands showing through
local hg = pile{{"raw umber", 1}, {"red earth", 0.35}, {"bone black", 0.06}, medium=0.75, name="hair glaze"}
work(HAIR, {hand="glaze", pile=hg, coverage=1, angle=FH:field("fall"), clip=HAIR})
work(HAIR * mask(function(x, y) return 1 - smoothstep(0.3, 0.65, HLV(x, y)) end), {hand="glaze", pile=hg, coverage=1, angle=FH:field("fall"), clip=HAIR})

-- the neck's turned side and the shadow of the hair on it
local ng = pile{{"raw umber", 1}, {"red earth", 0.4}, {"green earth", 0.3}, {"lead white", 0.25}, medium=0.7, name="neck shadow glaze"}
local nm = NECK * mask(function(x, y) return smoothstep(560, 625, x) * (1 - smoothstep(700, 760, y) * 0.5) end)
work(nm, {hand="glaze", pile=ng, coverage=1, angle=1.57, clip=NECK})

--@ chunk 27
clear_palette()
-- the sleeves repainted: deep green velvet, its pile catching the light in folds
local folds = noise{seed=31, period=70, octaves=3, stretch={1.45, 4}}
local function SV(x, y) return clamp(LV(x, y) * 0.9 + 0.3 * folds(x, y) - 0.1, 0, 1) end
local sl = {
  pile{{"bone black", 1}, {"copper green", 0.5}, {"green earth", 0.6}, {"raw umber", 0.3}, name="velvet 0"},
  pile{{"bone black", 0.5}, {"copper green", 0.7}, {"green earth", 1}, {"raw umber", 0.2}, name="velvet 1"},
  pile{{"copper green", 0.8}, {"green earth", 1}, {"bone black", 0.2}, {"yellow ochre", 0.2}, {"lead white", 0.15}, name="velvet 2"},
  pile{{"green earth", 1}, {"copper green", 0.5}, {"Naples yellow", 0.35}, {"lead white", 0.35}, name="velvet 3"},
}
work(SLEEVES, {hand="body", piles=tents_g(sl, SV, 0.1, 0.85, 1.3), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=SLEEVES, tool="filbert 8", length={15, 45}})

--@ chunk 28
clear_palette()
-- the bodice repainted: crimson, turning dark at its sides, soft folds toward the waist
local folds = noise{seed=5, period=45, octaves=2, stretch={1.5, 5}}
local function BV(x, y)
  local side = smoothstep(500, 425, x) + smoothstep(600, 710, x)
  return clamp(LV(x, y) * 0.9 - 0.35 * side + 0.25 * folds(x, y) * smoothstep(840, 1050, y) + 0.05, 0, 1)
end
local bd = {
  pile{{"rose madder", 1}, {"bone black", 0.5}, {"red earth", 0.5}, name="crimson 0"},
  pile{{"rose madder", 1}, {"red earth", 0.6}, {"vermilion", 0.3}, {"bone black", 0.12}, name="crimson 1"},
  pile{{"vermilion", 0.7}, {"rose madder", 0.8}, {"red earth", 0.3}, name="crimson 2"},
  pile{{"vermilion", 1}, {"rose madder", 0.3}, {"lead white", 0.2}, name="crimson 3"},
}
work(BODICE, {hand="body", piles=tents_g(bd, BV, 0.05, 0.85, 1.1), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=BODICE, tool="filbert 7", length={12, 36}})

--@ chunk 29
clear_palette()
-- the hair repainted deeper: auburn-brown, its lights to come back as strands
local hp = {
  pile{{"raw umber", 1.3}, {"bone black", 0.4}, {"red earth", 0.35}, name="hair d0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.55}, {"bone black", 0.15}, {"yellow ochre", 0.15}, name="hair d1"},
  pile{{"raw umber", 1}, {"red earth", 0.6}, {"yellow ochre", 0.5}, name="hair d2"},
  pile{{"raw umber", 0.7}, {"red earth", 0.5}, {"yellow ochre", 0.9}, {"lead white", 0.2}, name="hair d3"},
}
work(HAIR, {hand="body", piles=tents_g(hp, HLV, 0.2, 0.95, 1.6), coverage=2.6, fill=true,
  angle=FH:field("fall"), clip=HAIR, tool="filbert 5", length={12, 30}})

--@ chunk 30
clear_palette()
-- the background's second coat, left half: deep, quiet umber-green
BGD2 = pile{{"bone black", 1}, {"raw umber", 1.8}, {"green earth", 1.0}, {"lead white", 0.08}, name="bg2 dark"}
BGL2 = pile{{"bone black", 0.45}, {"raw umber", 1.6}, {"green earth", 1.4}, {"yellow ochre", 0.45}, {"lead white", 0.5}, name="bg2 light"}
BGHALF = {BG * rect(0, 0, 505, 1334), BG * rect(495, 0, 505, 1334)}
local m = BGHALF[1]
work(m, {hand="broad", piles={{BGD2, bg_w_dark}, {BGL2, bg_w_light}}, coverage=2.2, load=0.85, fill=true,
  angle=function(x, y) return 1.45 + 0.2 * math.sin(x / 300 + y / 270) end, clip=BG:grow(2),
  edge={found=0.3, soft=0.5, lost=0.2, period=50}})

--@ chunk 31
clear_palette()
-- the background's second coat, right half: deep, quiet umber-green
BGD2 = pile{{"bone black", 1}, {"raw umber", 1.8}, {"green earth", 1.0}, {"lead white", 0.08}, name="bg2 dark"}
BGL2 = pile{{"bone black", 0.45}, {"raw umber", 1.6}, {"green earth", 1.4}, {"yellow ochre", 0.45}, {"lead white", 0.5}, name="bg2 light"}
local m = BGHALF[2]
work(m, {hand="broad", piles={{BGD2, bg_w_dark}, {BGL2, bg_w_light}}, coverage=2.2, load=0.85, fill=true,
  angle=function(x, y) return 1.45 + 0.2 * math.sin(x / 300 + y / 270) end, clip=BG:grow(2),
  edge={found=0.3, soft=0.5, lost=0.2, period=50}})

--@ chunk 32
clear_palette()
-- the bodice again: deep crimson, folds running down from the neckline toward the
-- waist, each lit on its left flank and shadowed on its right
local foldsL = {}
for _, x0 in ipairs({452, 488, 530, 571, 612, 655, 690}) do
  local xc = 560
  foldsL[#foldsL + 1] = {x0, 835, xc + (x0 - xc) * 0.72, 1175}
end
local function foldv(x, y)
  local v = 0
  for _, f in ipairs(foldsL) do
    local t = clamp((y - f[2]) / (f[4] - f[2]), 0, 1)
    local fx = lerp(f[1], f[3], t)
    local d = x - fx
    local s = smoothstep(835, 920, y) * (0.6 + 0.4 * t)
    v = v + s * (0.32 * math.exp(-((d + 5) ^ 2) / 40) - 0.38 * math.exp(-((d - 6) ^ 2) / 50))
  end
  return v
end
function BV2(x, y)
  local side = smoothstep(500, 425, x) + smoothstep(610, 715, x)
  return clamp(LV(x, y) * 0.75 - 0.4 * side + foldv(x, y) - 0.08, 0, 1)
end
local bd = {
  pile{{"rose madder", 1}, {"bone black", 0.6}, {"red earth", 0.4}, name="crimson 0"},
  pile{{"rose madder", 1}, {"red earth", 0.5}, {"bone black", 0.25}, name="crimson 1"},
  pile{{"rose madder", 1}, {"vermilion", 0.4}, {"red earth", 0.4}, {"bone black", 0.05}, name="crimson 2"},
  pile{{"vermilion", 0.8}, {"rose madder", 0.6}, {"red earth", 0.2}, name="crimson 3"},
  pile{{"vermilion", 1}, {"rose madder", 0.3}, {"lead white", 0.3}, name="crimson 4"},
}
work(BODICE, {hand="body", piles=tents(bd, BV2, 0.0, 0.75), coverage=2.8, fill=true,
  angle=F:field("fall"), clip=BODICE, tool="filbert 5", length={10, 26}})

--@ chunk 33
clear_palette()
-- the hair's strands again, over the deeper body: parted in the middle, drawn smooth over the head and down over
-- the ears, gathered behind; strands laid along its fall, lit and shadowed

local function bez(p0, p1, p2, p3, n)
  local o = {}
  for i = 0, n do
    local t = i / n
    local a, b, c, d = (1 - t) ^ 3, 3 * (1 - t) ^ 2 * t, 3 * (1 - t) * t * t, t ^ 3
    o[#o + 1] = {a * p0[1] + b * p1[1] + c * p2[1] + d * p3[1], a * p0[2] + b * p1[2] + c * p2[2] + d * p3[2]}
  end
  return o
end

-- the part, from the hairline back over the crown
PART = {{503, 286}, {512, 262}, {526, 236}, {542, 214}, {558, 200}}
local function on_part(t)
  local n = #PART - 1
  local i = math.min(n, math.floor(t * n) + 1)
  local u = t * n - (i - 1)
  return {lerp(PART[i][1], PART[i + 1][1], u), lerp(PART[i][2], PART[i + 1][2], u)}
end

HAIRPILES = {
  pile{{"raw umber", 1.3}, {"bone black", 0.45}, {"red earth", 0.35}, name="strand 0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.7}, {"yellow ochre", 0.35}, {"bone black", 0.1}, name="strand 1"},
  pile{{"raw umber", 0.8}, {"red earth", 0.6}, {"yellow ochre", 0.9}, {"lead white", 0.25}, name="strand 2"},
  pile{{"yellow ochre", 1}, {"raw umber", 0.4}, {"red earth", 0.3}, {"lead white", 0.6}, {"Naples yellow", 0.3}, name="strand 3"},
  pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 1}, {"red earth", 0.1}, name="strand 4"},
}
local function strand_pile(v)
  local i = clamp(math.floor(v * 5) + 1, 1, 5)
  return HAIRPILES[i]
end

-- the strands' paths: from the part out to each side and down
local paths = {}
for k = 1, 300 do
  local t = rand(0.0, 1.0) ^ 0.8
  local p0 = on_part(t)
  local side = (k % 2 == 0) and -1 or 1
  local p3, p1, p2
  if side == -1 then
    -- over the far temple and down beside the cheek
    local endy = lerp(330, 470, rand(0, 1) ^ 1.3)
    p3 = {lerp(426, 408, (endy - 330) / 140) + rand(-6, 6), endy}
    p1 = {p0[1] - 30 - rand(0, 20), p0[2] + rand(-6, 10)}
    p2 = {p3[1] - rand(4, 20), p3[2] - rand(40, 80)}
  else
    -- over the crown to the near side, down over the ear and back to the braid
    local endy = lerp(380, 560, rand(0, 1) ^ 1.1)
    p3 = {lerp(630, 668, (endy - 380) / 180) + rand(-8, 8), endy}
    p1 = {p0[1] + 40 + rand(0, 30), p0[2] + rand(-10, 20)}
    p2 = {p3[1] + rand(5, 25), p3[2] - rand(60, 120)}
  end
  paths[#paths + 1] = bez(p0, p1, p2, p3, 14)
end

-- lay them: dark strands first, then the lit ones over, each tinted by its light
local clipH = HAIR:shrink(1)
local order = {}
for i = 1, #paths do order[i] = i end
local bs = brush{kind="rigger", width=1.6, point=0.9}
for pass = 1, 2 do
  for _, i in ipairs(order) do
    local pts = paths[i]
    local mid = pts[math.floor(#pts / 2)]
    local v = HLV(mid[1], mid[2]) ^ 1.5 + randn(0, 0.08)
    if (pass == 1 and v < 0.5) or (pass == 2 and v >= 0.5) then
      local g = {}
      for j, p in ipairs(pts) do
        local tt = (j - 1) / (#pts - 1)
        g[#g + 1] = {p[1], p[2], 0.1 + 0.4 * math.sin(math.pi * tt) ^ 0.6}
      end
      bs:reload(strand_pile(clamp(v + (pass == 2 and 0.05 or -0.1), 0, 0.99)), 0.45)
      bs:gesture(g, {wobble=1.2, clip=clipH})
    end
  end
end
-- soften the strands into the mass, then a few crisp lights on the crown and the far side
local hl = brush{kind="rigger", width=1.2, point=0.95}
for k = 1, 45 do
  local i = math.random(#paths)
  local pts = paths[i]
  local a = math.random(2, 7)
  local seg = {}
  for j = a, math.min(#pts, a + 5) do
    local p = pts[j]
    if HLV(p[1], p[2]) > 0.68 then seg[#seg + 1] = {p[1], p[2], 0.25} end
  end
  if #seg >= 3 then
    seg[1][3] = 0.0; seg[#seg][3] = 0.0
    hl:reload(HAIRPILES[4], 0.35)
    hl:gesture(seg, {wobble=0.6, clip=clipH})
  end
end
-- the part itself, a fine dark line
local bp = brush{kind="round", width=1.2, point=0.9}
bp:load(HAIRPILES[1], 0.5)
bp:gesture({{PART[1][1], PART[1][2], 0.3}, {PART[2][1], PART[2][2], 0.35}, {PART[3][1], PART[3][2], 0.3}, {PART[4][1], PART[4][2], 0.15}}, {clip=clipH})

--@ chunk 34
clear_palette()
-- the coazzone: the hair gathered behind into a braid, bound in a ribbon
local bl = {
  pile{{"raw umber", 1.3}, {"bone black", 0.45}, {"red earth", 0.3}, name="braid 0"},
  pile{{"raw umber", 1.1}, {"red earth", 0.6}, {"yellow ochre", 0.3}, name="braid 1"},
  pile{{"raw umber", 0.7}, {"red earth", 0.5}, {"yellow ochre", 0.9}, {"lead white", 0.25}, name="braid 2"},
  pile{{"yellow ochre", 1}, {"Naples yellow", 0.4}, {"raw umber", 0.3}, {"lead white", 0.5}, name="braid 3"},
}
local function cl(t) return lerp(652, 668, t), lerp(470, 760, t) end
local n = 13
for i = 0, n - 1 do
  local t = (i + 0.5) / n
  local x, y = cl(t)
  local side = (i % 2 == 0) and -1 or 1
  local w = lerp(24, 15, t)
  local cx, cy = x + side * w * 0.22, y
  local lobe = ellipse(cx, cy, w * 0.62, 15):roughen(1, 6, i) * HAIR
  local vf = function(px, py)
    local u = (px - cx) / (w * 0.62)
    local v = (py - cy) / 15
    return clamp(0.75 - 0.45 * u - 0.5 * v - 0.25 * t, 0, 1)
  end
  work(lobe, {hand="body", piles=tents(bl, vf, 0, 1), coverage=3, fill=true, angle=1.57 + side * 0.6, clip=lobe,
    tool="filbert 3", length={6, 14}})
end
-- the ribbon wound round it, dark with a glint
local rb = brush{kind="round", width=2.4, point=0.5}
local rp = pile{{"bone black", 1}, {"raw umber", 0.4}, {"rose madder", 0.3}, name="ribbon"}
for i = 0, n - 1, 2 do
  local t = (i + 1) / n
  local x, y = cl(t)
  rb:reload(rp, 0.6)
  rb:gesture({{x - 16, y - 6, 0.3}, {x, y + 1, 0.5}, {x + 15, y + 8, 0.3}}, {clip=HAIR})
end

--@ chunk 35
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

--@ chunk 36
clear_palette()
-- the face: darker eyes, the sockets' shadow at the nose, the upper lip and the
-- nose's shadow smoothed, the far contour lost into the dark
print(wait(3 * 24 * 60))
local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local feats = (EYEM[-1].opening + EYEM[1].opening):grow(1.5) + LIPS:grow(1)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3.5) end

-- the sockets: a soft shadow between each eye and the bridge of the nose, under the brow
local function blob(p, rx, ry) return function(x, y) local dx, dy = (x - p[1]) / rx, (y - p[2]) / ry; return math.exp(-(dx * dx + dy * dy)) end end
local sR = blob(onface(-22, -4, 70), 9, 12)
local sL = blob(onface(22, -4, 70), 11, 13)
local function lvS(x, y) return LVF(x, y) * (1 - 0.45 * (sR(x, y) + sL(x, y))) end
local socket = (FACE - feats) * mask(function(x, y) return clamp(1.6 * (sR(x, y) + sL(x, y)), 0, 1) end)
work(socket, {hand="body", piles=tents_g(FL, lvS, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=F:field("across"),
  clip=FACE - feats, tool="filbert 3", length={4, 9}, load=0.8})
-- the upper lip, lighter; the nose's shadowed flank, smoothed
local ul = poly({onface(-24, 86, 70), onface(-8, 83, 80), onface(8, 83, 80), onface(24, 86, 70), onface(24, 104, 66), onface(0, 99, 74), onface(-24, 104, 66)}, true):soften(3) - feats
work(ul, {hand="body", piles=tents_g(FL, function(x, y) return LVF(x, y) + 0.12 end, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=0,
  clip=FACE - feats, tool="filbert 3", length={4, 9}, load=0.8})
local ns = ribbon(NOSE.side, 7):soften(3) - feats
work(ns, {hand="body", piles=tents_g(FL, LVF, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=1.5,
  clip=FACE - feats, tool="filbert 3", length={4, 10}, load=0.8})
-- the line between chin and neck: the jaw's turn, not a line
local jaw = ribbon(FACE_CHIN, 5):soften(2) * (FACE + NECK)
work(jaw, {hand="body", piles=tents_g(FL, LVF, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=0.2,
  clip=SKIN, tool="filbert 3", length={4, 9}, load=0.8})
clear_palette()
-- the irises again, in body colour: dark warm brown, a darker rim, lighter below
local irisD = pile{{"raw umber", 1}, {"bone black", 0.35}, {"red earth", 0.15}, name="iris dark"}
local irisM = pile{{"raw umber", 1}, {"red earth", 0.3}, {"yellow ochre", 0.2}, {"bone black", 0.08}, name="iris mid"}
local irisL = pile{{"raw umber", 0.8}, {"yellow ochre", 0.5}, {"red earth", 0.3}, name="iris light"}
local pupil = pile{{"bone black", 1}, {"raw umber", 0.3}, name="pupil"}
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local ir = EYEM[s].iris
  local cx, cy = e.center[1], e.center[2]
  local rr = e.iris_r * HS
  work(ir, {hand="detail", piles={
      {irisD, function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2) / rr; return 1.4 * smoothstep(0.6, 1.0, d) + 0.8 * clamp((cy - y) / rr + 0.3, 0, 1) end},
      {irisM, function(x, y) return 0.7 end},
      {irisL, function(x, y) return 0.9 * clamp((y - cy) / rr, 0, 1) end}},
    coverage=3, fill=true, clip=ir, tool={kind="round", width=1.2, point=0.6}})
  work(EYEM[s].pupil, {hand="detail", pile=pupil, coverage=3, fill=true, clip=EYEM[s].pupil, tool={kind="round", width=1.0, point=0.7}})
  -- the whites lowered: a grey-warm body tint near the corners and under the lid
  local wsh = pile{{"lead white", 1.2}, {"raw umber", 0.3}, {"red earth", 0.06}, {"yellow ochre", 0.06}, name="white shade"}
  local wm = (EYEM[s].opening - ir:grow(0.4)) * mask(function(x, y)
    return clamp(math.abs(x - cx) / 16 - 0.35 + clamp((cy - y + 2) / 6, 0, 1), 0, 1) end)
  work(wm, {hand="detail", pile=wsh, coverage=2, clip=EYEM[s].opening, tool={kind="round", width=1.4, point=0.5}})
end
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local g = brush{kind="round", width=1.6, point=0.5, lay=3}
  g:load(pile{{"lead white", 1}, blot=0.15, name="glint"}, 0.8)
  local r = e.iris_r * HS
  g:touch(e.center[1] - 0.3 * r, e.center[2] - 0.32 * r, {pressure=(s == 1) and 0.42 or 0.32})
end

--@ chunk 37
clear_palette()
-- sfumato at the contours: the far cheek lost into the dark, the hairline softened
local dark = pile{{"bone black", 0.8}, {"raw umber", 1.6}, {"green earth", 1}, {"lead white", 0.15}, name="lose dark"}
local farside = FACE * mask(function(x, y) return smoothstep(470, 430, x) end)
lose(FACE, {pile=dark, where=function(x, y) return smoothstep(470, 440, x) * (1 - smoothstep(560, 600, y)) * 0.8 end,
  tool="filbert 3", reach={4, 5}, load=0.15})
local hairc = pile{{"raw umber", 1.2}, {"red earth", 0.5}, {"yellow ochre", 0.2}, name="lose hair"}
lose(FACE, {pile=hairc, where=function(x, y) return (smoothstep(420, 440, x) * (1 - smoothstep(330, 360, y))) * 0.6 + smoothstep(590, 610, x) * 0.5 end,
  tool="filbert 3", reach={4, 4}, load=0.15})

--@ chunk 38
clear_palette()
-- one unifying pass over the face in the flesh ladder, its light including the
-- sockets' shadow; the features kept out
print(wait(2 * 24 * 60))
local feats = (EYEM[-1].opening + EYEM[1].opening):grow(1.2) + LIPS:grow(0.8)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3) end
local function blob(p, rx, ry) return function(x, y) local dx, dy = (x - p[1]) / rx, (y - p[2]) / ry; return math.exp(-(dx * dx + dy * dy)) end end
local sR = blob(onface(-22, -4, 70), 9, 12)
local sL = blob(onface(22, -4, 70), 11, 13)
local lidR = blob(onface(-40, -6, 70), 16, 6)
local lidL = blob(onface(40, -6, 70), 18, 6)
local und = blob(onface(0, 86, 80), 16, 5)
FV = function(x, y)
  return LVF(x, y) * (1 - 0.4 * (sR(x, y) + sL(x, y)) - 0.15 * (lidR(x, y) + lidL(x, y)) - 0.2 * und(x, y))
end
local ps = tents_g(FL, FV, 0.12, 0.95, 1.5)
ps[#ps + 1] = {ROSE, function(x, y) return 1.0 * ROSY(x, y) * smoothstep(0.35, 0.65, LV(x, y)) end}
local area = FACE:shrink(0.5) - feats
work(area, {hand="body", piles=ps, coverage=3, fill=true, angle=F:field("across"), clip=area,
  tool="filbert 3", length={4, 10}, load=0.85})

--@ chunk 39
clear_palette()
-- ornament: gold embroidery along the band, the ferronnière across the brow,
-- a string of jet beads at the throat, gold ties at the sleeves' seams

local gold = {
  pile{{"yellow ochre", 1}, {"red earth", 0.25}, {"raw umber", 0.25}, name="gold dark"},
  pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 0.2}, name="gold mid"},
  pile{{"Naples yellow", 1}, {"lead white", 1}, blot=0.2, name="gold light"},
}
local function along(path, step)
  -- points every `step` units along a polyline, with the direction there
  local out = {}
  local acc, i = 0, 1
  local total = 0
  for k = 1, #path - 1 do
    local a, b = path[k], path[k + 1]
    local l = math.sqrt((b[1] - a[1]) ^ 2 + (b[2] - a[2]) ^ 2)
    local d = (step - acc) % step
    while d <= l do
      local t = d / l
      out[#out + 1] = {a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, (b[1] - a[1]) / l, (b[2] - a[2]) / l}
      d = d + step
    end
    acc = (acc + l) % step
  end
  return out
end

-- the embroidery: a running knot of two interlaced strands, gold on black
local gb = brush{kind="round", width=1.3, point=0.8}
local pts = along(BANDPATH, 9)
for j, p in ipairs(pts) do
  local x, y, tx, ty = p[1], p[2], p[3], p[4]
  local nx, ny = -ty, tx
  local v = LV(x, y)
  local gp = gold[(v > 0.55) and 3 or ((v > 0.3) and 2 or 1)]
  for _, sgn in ipairs({-1, 1}) do
    gb:reload(gp, 0.5)
    local a = {x - tx * 4.5 + nx * 3.5 * sgn, y - ty * 4.5 + ny * 3.5 * sgn, 0.15}
    local m = {x, y, 0.35}
    local b = {x + tx * 4.5 - nx * 3.5 * sgn, y + ty * 4.5 - ny * 3.5 * sgn, 0.15}
    gb:gesture({a, m, b}, {clip=BAND:grow(0.5)})
  end
  -- a seed pearl at every second crossing
  if j % 2 == 0 then
    gb:reload(gold[3], 0.6)
    gb:touch(x, y, {pressure=0.4})
  end
end

-- the ferronnière: a fine dark cord across the forehead, a jewel at its middle
FERR = {}
for i = 0, 16 do
  local x = -78 + 156 * i / 16
  FERR[#FERR + 1] = onface(x, -86 + 0.0035 * x * x, 70, 0.8)
end
local fm = ribbon(FERR, 1.8) * (FACE + HAIR)
local cord = pile{{"bone black", 1}, {"raw umber", 0.6}, name="cord"}
work(fm, {hand="detail", pile=cord, coverage=3, fill=true, clip=fm, tool={kind="round", width=1.0, point=0.8}})
-- its shadow on the brow, a breath below it
local fs = {}
for _, p in ipairs(FERR) do fs[#fs + 1] = {p[1] + 0.8, p[2] + 2.2} end
local fsm = ribbon(fs, 2.2):soften(1.5) * FACE
work(fsm, {hand="glaze", pile=pile{{"raw umber", 0.6}, {"red earth", 0.4}, {"lead white", 0.4}, medium=0.75, name="cord shadow"}, coverage=0.9, clip=fsm:grow(1)})
-- the jewel: a cabochon of deep red in a gold setting, a pearl hanging under it
JEWEL = onface(0, -84, 75, 1)
local jx, jy = JEWEL[1], JEWEL[2]
local setting = ellipse(jx, jy, 5.2, 6.2)
work(setting, {hand="detail", piles={{gold[1], 0.5}, {gold[2], 0.5}}, coverage=3, fill=true, clip=setting, tool={kind="round", width=1.0, point=0.6}})
local stone = ellipse(jx, jy, 3.4, 4.2)
work(stone, {hand="detail", piles={{pile{{"rose madder", 1}, {"bone black", 0.3}, {"red earth", 0.3}, name="ruby dark"}, 0.6},
  {pile{{"vermilion", 0.6}, {"rose madder", 1}, name="ruby"}, 0.4}}, coverage=3, fill=true, clip=stone, tool={kind="round", width=0.9, point=0.6}})
local gl = brush{kind="round", width=1.1, point=0.6, lay=3}
SPARK = SPARK or pile{{"lead white", 1}, blot=0.2, name="spark"}
gl:load(SPARK, 0.8)
gl:touch(jx - 1.2, jy - 1.6, {pressure=0.4})
gl:touch(jx + 1.4, jy + 2.6, {pressure=0.15})
local pearl = ellipse(jx + 0.3, jy + 10.5, 2.6, 3.0)
work(pearl, {hand="detail", piles={{pile{{"lead white", 2}, {"raw umber", 0.15}, {"bone black", 0.05}, name="pearl shade"}, 0.5},
  {pile{{"lead white", 3}, {"Naples yellow", 0.1}, name="pearl"}, 0.5}}, coverage=3, fill=true, clip=pearl, tool={kind="round", width=0.9, point=0.6}})
gl:reload(SPARK, 0.8)
gl:touch(jx - 0.6, jy + 9.6, {pressure=0.35})

clear_palette()
-- jet beads at the throat, a string lying over the breast
local bead = pile{{"bone black", 1}, {"raw umber", 0.3}, name="jet"}
local beadL = pile{{"lead white", 2}, {"smalt", 0.2}, name="jet light"}
local bb = brush{kind="round", width=3.2, point=0.2, lay=2}
local hb = brush{kind="round", width=1.0, point=0.7}
for _, strand in ipairs({{452, 640, 690, 74, 0.42}, {446, 648, 700, 112, 0.44}}) do
  local x0, x1, y0, sag, low = strand[1], strand[2], strand[3], strand[4], strand[5]
  local n = math.floor((x1 - x0) / 5.4)
  for i = 0, n do
    local t = i / n
    local u = (t <= low) and (t / low) or ((1 - t) / (1 - low))
    local x = lerp(x0, x1, t)
    local y = y0 + sag * math.sin(u * math.pi / 2) ^ 1.3
    if NECK:at(x, y) > 0.6 then
      bb:reload(bead, 0.7)
      bb:touch(x, y, {pressure=0.55})
      hb:reload(beadL, 0.5)
      hb:touch(x - 0.9, y - 1.0, {pressure=0.3})
    end
  end
end

-- gold ties where the sleeves meet the bodice, with white puffs of the chemise
local tie = brush{kind="round", width=2.0, point=0.7}
local puff = pile{{"lead white", 3}, {"raw umber", 0.1}, name="puff"}
local puffS = pile{{"lead white", 1.4}, {"raw umber", 0.3}, {"bone black", 0.08}, name="puff shade"}
for _, s in ipairs({{424, 870}, {420, 980}, {722, 880}, {728, 990}}) do
  local m = ellipse(s[1], s[2], 7, 11):roughen(1.5, 6, 3)
  work(m, {hand="detail", piles={{puff, function(x, y) return LV(x, y) + 0.3 end}, {puffS, function(x, y) return 1 - LV(x, y) end}},
    coverage=3, fill=true, clip=m, tool={kind="round", width=1.6, point=0.5}})
  for k = -1, 1, 2 do
    tie:reload(gold[2], 0.5)
    tie:gesture({{s[1] - 6, s[2] + k * 2, 0.35}, {s[1], s[2] + k * 0.5, 0.45}, {s[1] + 6, s[2] - k * 2, 0.3}}, {})
  end
  tie:reload(gold[3], 0.5)
  tie:gesture({{s[1], s[2], 0.3}, {s[1] + 3, s[2] + 9, 0.2}, {s[1] + 2, s[2] + 16, 0.0}}, {})
end

--@ chunk 40
clear_palette()
-- the neck and breast modelled again as one surface: lit from the upper left,
-- turning away to the right and under the braid; the collarbones and the
-- hollow of the throat found softly
print(wait(2 * 24 * 60))
local function seg_d(x, y, ax, ay, bx, by)
  local dx, dy = bx - ax, by - ay
  local t = clamp(((x - ax) * dx + (y - ay) * dy) / (dx * dx + dy * dy), 0, 1)
  local px, py = ax + t * dx, ay + t * dy
  return y - py, math.sqrt((x - px) ^ 2 + (y - py) ^ 2)
end
local function clav(x, y, ax, ay, mx, my, bx, by)
  local s1, d1 = seg_d(x, y, ax, ay, mx, my)
  local s2, d2 = seg_d(x, y, mx, my, bx, by)
  local s, d = s1, d1
  if d2 < d1 then s, d = s2, d2 end
  if d > 14 then return 0 end
  -- light on its top, a soft shadow just under it
  return 0.08 * math.exp(-((s + 3) ^ 2) / 12) - 0.16 * math.exp(-((s - 5) ^ 2) / 22)
end
function CV(x, y)
  local chest = 0.78 - 0.4 * smoothstep(540, 730, x) - 0.15 * smoothstep(420, 400, x) - 0.08 * smoothstep(740, 820, y)
  chest = chest + clav(x, y, 508, 714, 470, 706, 418, 712) + clav(x, y, 556, 716, 610, 708, 690, 722)
  local nx, ny = (x - 532) / 9, (y - 702) / 7
  chest = chest - 0.22 * math.exp(-(nx * nx + ny * ny))
  local w = smoothstep(660, 712, y)
  local v = lerp(LVF(x, y), chest, w)
  if x > 600 and y > 690 then v = v - 0.12 * smoothstep(600, 660, x) * (1 - smoothstep(780, 830, y)) end   -- the braid's shadow
  return clamp(v, 0, 1)
end
local area = (NECK + SLOPE) - HEAD
work(area, {hand="body", piles=tents_g(FL, CV, 0.12, 0.95, 1.4), coverage=3, fill=true,
  angle=function(x, y) return (y < 690) and 1.5 or 0.15 end, clip=area, tool="filbert 4", length={5, 12}, load=0.85})

--@ chunk 41
clear_palette()
-- the black velvet band over the neckline's edge again, the chemise's rim
-- inside it, its gold knotwork, and the jet beads larger
print(wait(2 * 24 * 60))
local INPATH = {}
for _, p in ipairs(BANDPATH) do INPATH[#INPATH + 1] = p end
BAND2 = ribbon(BANDPATH, 17) * ((GOWN + SLEEVES):grow(2) + NECK + SLOPE) - HAIR - HEAD
BAND2 = BAND2 * mask(function(x, y) return y > 700 and 1 or 0 end)
local bandP = pile{{"bone black", 1}, {"raw umber", 0.5}, {"smalt", 0.2}, name="band"}
local bandL = pile{{"bone black", 0.6}, {"raw umber", 0.6}, {"smalt", 0.3}, {"lead white", 0.25}, name="band light"}
work(BAND2, {hand="detail", piles={{bandP, function(x, y) return 1.2 - LV(x, y) end}, {bandL, function(x, y) return 0.4 * LV(x, y) end}},
  coverage=3, fill=true, clip=BAND2, tool={kind="round", width=2.4, point=0.5}})
-- the chemise: a fine white rim just inside the band
local inner = (NECK + SLOPE) - BAND2
CHEM2 = (inner - inner:shrink(2.6)) * BAND2:grow(3.5) * mask(function(x, y) return y > 712 and 1 or 0 end)
local chemS = pile{{"lead white", 2}, {"raw umber", 0.18}, {"bone black", 0.05}, name="chemise shade"}
local chemL = pile{{"lead white", 3}, {"Naples yellow", 0.12}, name="chemise light"}
work(CHEM2, {hand="detail", piles={{chemS, function(x, y) return 1 - CV(x, y) end}, {chemL, function(x, y) return CV(x, y) end}},
  coverage=3, fill=true, clip=CHEM2, tool={kind="round", width=1.0, point=0.6}})
-- the knotwork
local gold = {
  pile{{"yellow ochre", 1}, {"red earth", 0.25}, {"raw umber", 0.25}, name="gold dark"},
  pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 0.2}, name="gold mid"},
  pile{{"Naples yellow", 1}, {"lead white", 1}, blot=0.2, name="gold light"},
}
local function along(path, step)
  local out, acc = {}, 0
  for k = 1, #path - 1 do
    local a, b = path[k], path[k + 1]
    local l = math.sqrt((b[1] - a[1]) ^ 2 + (b[2] - a[2]) ^ 2)
    local d = (step - acc) % step
    while d <= l do
      local t = d / l
      out[#out + 1] = {a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, (b[1] - a[1]) / l, (b[2] - a[2]) / l}
      d = d + step
    end
    acc = (acc + l) % step
  end
  return out
end
local gb = brush{kind="round", width=1.4, point=0.8}
for j, p in ipairs(along(BANDPATH, 10)) do
  local x, y, tx, ty = p[1], p[2], p[3], p[4]
  if BAND2:at(x, y) > 0.5 then
    local nx, ny = -ty, tx
    local v = LV(x, y)
    local gp = gold[(v > 0.55) and 3 or ((v > 0.3) and 2 or 1)]
    for _, sgn in ipairs({-1, 1}) do
      gb:reload(gp, 0.5)
      gb:gesture({{x - tx * 5 + nx * 4 * sgn, y - ty * 5 + ny * 4 * sgn, 0.15}, {x, y, 0.4}, {x + tx * 5 - nx * 4 * sgn, y + ty * 5 - ny * 4 * sgn, 0.15}}, {clip=BAND2})
    end
    if j % 2 == 0 then gb:reload(gold[3], 0.6); gb:touch(x, y, {pressure=0.5}) end
  end
end
-- jet beads, larger: each a small sphere with its light
clear_palette()
local jet = {
  pile{{"bone black", 1}, {"raw umber", 0.3}, name="jet"},
  pile{{"bone black", 0.7}, {"raw umber", 0.3}, {"smalt", 0.3}, {"lead white", 0.35}, name="jet mid"},
}
local hb = brush{kind="round", width=1.3, point=0.6, lay=2}
local spark = pile{{"lead white", 1}, blot=0.2, name="spark"}
for _, strand in ipairs({{460, 628, 690, 62, 0.42, 3.4}, {448, 640, 700, 104, 0.44, 3.8}}) do
  local x0, x1, y0, sag, low, r = strand[1], strand[2], strand[3], strand[4], strand[5], strand[6]
  local n = math.floor((x1 - x0) / (r * 2.05))
  for i = 0, n do
    local t = i / n
    local u = (t <= low) and (t / low) or ((1 - t) / (1 - low))
    local x = lerp(x0, x1, t)
    local y = y0 + sag * math.sin(u * math.pi / 2) ^ 1.3
    if (NECK + SLOPE):at(x, y) > 0.6 and BAND2:at(x, y) < 0.3 then
      local m = ellipse(x, y, r, r)
      work(m, {hand="detail", piles={{jet[1], function(px, py) return 0.5 + ((px - x) + (py - y)) / r end}, {jet[2], function(px, py) return 0.5 - ((px - x) + (py - y)) / r end}},
        coverage=3, fill=true, clip=m, tool={kind="round", width=1.2, point=0.5}})
      hb:reload(spark, 0.5)
      hb:touch(x - r * 0.35, y - r * 0.4, {pressure=0.3})
    end
  end
end

--@ chunk 42
clear_palette()
-- the hole between the far shoulder's slope and the breast, filled with flesh;
-- the speckled patch on the near side of the breast laid again
local FILL = poly({{410, 712}, {436, 694}, {470, 684}, {488, 700}, {488, 748}, {414, 748}}, true) - BAND2 - CHEM2:grow(0.5) - HAIR
local PATCH = (NECK * rect(600, 725, 150, 100)) - BAND2 - CHEM2:grow(0.5) - HAIR
local area = FILL + PATCH
work(area, {hand="body", piles=tents_g(FL, CV, 0.12, 0.95, 1.4), coverage=3, fill=true, angle=0.15, clip=area,
  tool="filbert 3", length={5, 12}, load=0.9})
SKIN = SKIN + FILL

--@ chunk 43
clear_palette()
-- the braid again, darker: slanting lobes plaited left and right, the ribbon over them
local bl = {
  pile{{"raw umber", 1.3}, {"bone black", 0.5}, {"red earth", 0.3}, name="braid 0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.5}, {"bone black", 0.15}, name="braid 1"},
  pile{{"raw umber", 1}, {"red earth", 0.55}, {"yellow ochre", 0.45}, name="braid 2"},
  pile{{"raw umber", 0.7}, {"yellow ochre", 0.9}, {"red earth", 0.35}, {"lead white", 0.2}, name="braid 3"},
}
local function cl(t) return lerp(650, 666, t), lerp(455, 775, t) end
local BR = HAIRBACK * mask(function(x, y) return smoothstep(440, 470, y) end) - NECK:shrink(1)
-- the whole braid first in its shadow
work(BR, {hand="body", pile=bl[1], coverage=2.5, fill=true, angle=1.5, clip=BR, tool="filbert 4", length={8, 20}})
local n = 15
for i = 0, n - 1 do
  local t = (i + 0.5) / n
  local x, y = cl(t)
  local side = (i % 2 == 0) and -1 or 1
  local w = lerp(22, 14, t)
  local a = side * 0.55
  local pts = {}
  for k = 0, 19 do
    local u = 2 * math.pi * k / 20
    local ex, ey = w * 0.6 * math.cos(u), 13 * math.sin(u)
    pts[#pts + 1] = {x + side * w * 0.2 + ex * math.cos(a) - ey * math.sin(a), y + ex * math.sin(a) + ey * math.cos(a)}
  end
  local lobe = poly(pts, true) * BR
  local cx, cy = x + side * w * 0.2, y
  local vf = function(px, py)
    local u = ((px - cx) * math.cos(a) + (py - cy) * math.sin(a)) / (w * 0.6)
    local v = (-(px - cx) * math.sin(a) + (py - cy) * math.cos(a)) / 13
    return clamp(0.62 - 0.35 * u - 0.45 * v - 0.3 * t, 0, 1)
  end
  work(lobe, {hand="body", piles=tents(bl, vf, 0, 1), coverage=3, fill=true, angle=1.57 + a, clip=lobe,
    tool="filbert 2.5", length={5, 12}})
end
local rb = brush{kind="round", width=2.2, point=0.5}
local rp = pile{{"bone black", 1}, {"raw umber", 0.4}, {"rose madder", 0.3}, name="ribbon"}
for i = 0, n - 1, 2 do
  local t = (i + 1) / n
  local x, y = cl(t)
  rb:reload(rp, 0.55)
  rb:gesture({{x - 14, y - 6, 0.25}, {x, y + 1, 0.45}, {x + 13, y + 7, 0.25}}, {clip=BR})
end

--@ chunk 44
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

--@ chunk 45
clear_palette()
-- the sleeves once more, deeper and quieter: a dark green velvet, its lights restrained
local folds = noise{seed=31, period=70, octaves=3, stretch={1.45, 4}}
local function SV(x, y) return clamp(LV(x, y) * 0.85 + 0.28 * folds(x, y) - 0.2, 0, 1) end
local sl = {
  pile{{"bone black", 1}, {"copper green", 0.45}, {"green earth", 0.6}, {"raw umber", 0.35}, name="velvet 0"},
  pile{{"bone black", 0.6}, {"copper green", 0.6}, {"green earth", 1}, {"raw umber", 0.25}, name="velvet 1"},
  pile{{"copper green", 0.7}, {"green earth", 1}, {"bone black", 0.3}, {"raw umber", 0.15}, name="velvet 2"},
  pile{{"green earth", 1}, {"copper green", 0.5}, {"yellow ochre", 0.15}, {"lead white", 0.25}, {"bone black", 0.08}, name="velvet 3"},
}
work(SLEEVES - BAND2, {hand="body", piles=tents_g(sl, SV, 0.05, 0.8, 1.2), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=SLEEVES - BAND2, tool="filbert 6", length={12, 36}})
-- gold ties and chemise puffs at the seams, again over the new velvet
local gold2 = pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 0.2}, name="gold mid"}
local gold3 = pile{{"Naples yellow", 1}, {"lead white", 1}, blot=0.2, name="gold light"}
local puff = pile{{"lead white", 3}, {"raw umber", 0.12}, name="puff"}
local puffS = pile{{"lead white", 1.3}, {"raw umber", 0.35}, {"bone black", 0.08}, name="puff shade"}
local tie = brush{kind="round", width=2.2, point=0.7}
for _, s in ipairs({{425, 880}, {421, 990}, {420, 1100}, {720, 890}, {726, 1000}, {732, 1110}}) do
  local m = ellipse(s[1], s[2], 8, 13):roughen(1.5, 6, 3)
  work(m, {hand="detail", piles={{puff, function(x, y) return LV(x, y) + 0.2 end}, {puffS, function(x, y) return 1 - LV(x, y) end}},
    coverage=3, fill=true, clip=m, tool={kind="round", width=1.8, point=0.5}})
  for k = -1, 1, 2 do
    tie:reload(gold2, 0.5)
    tie:gesture({{s[1] - 7, s[2] + k * 2.5, 0.35}, {s[1], s[2] + k * 0.5, 0.5}, {s[1] + 7, s[2] - k * 2.5, 0.35}}, {})
  end
  tie:reload(gold3, 0.5)
  tie:gesture({{s[1], s[2], 0.35}, {s[1] + 3, s[2] + 10, 0.25}, {s[1] + 2, s[2] + 18, 0.0}}, {})
end

--@ chunk 46
clear_palette()
-- the last touches in the face: warmer whites, the lights on the nose, the lip
-- and the brow, the corners of the mouth lifted the breadth of a smile
local wsh = pile{{"lead white", 1.5}, {"raw umber", 0.22}, {"yellow ochre", 0.1}, {"red earth", 0.04}, name="white warm"}
local wlt = pile{{"lead white", 2.2}, {"yellow ochre", 0.12}, {"raw umber", 0.08}, name="white lit"}
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local cx, cy = e.center[1], e.center[2]
  local wm = EYEM[s].opening - EYEM[s].iris:grow(0.4)
  local far = (s == -1) and 0.25 or 0
  work(wm, {hand="detail", piles={{wsh, function(x, y) return 0.4 + math.abs(x - cx) / 18 + clamp((cy - y + 2) / 6, 0, 1) + far end},
    {wlt, function(x, y) return 0.8 - math.abs(x - cx) / 25 end}}, coverage=2.5, fill=true, clip=EYEM[s].opening:shrink(0.3),
    tool={kind="round", width=1.3, point=0.5}})
  local g = brush{kind="round", width=1.6, point=0.5, lay=3}
  g:load(pile{{"lead white", 1}, blot=0.15, name="glint"}, 0.8)
  local r = e.iris_r * HS
  g:touch(cx - 0.3 * r, cy - 0.32 * r, {pressure=(s == 1) and 0.42 or 0.32})
end
local hi = pile{{"lead white", 4}, {"Naples yellow", 0.35}, {"vermilion", 0.02}, blot=0.1, name="highlight"}
local hb = brush{kind="filbert", width=3.5, stiffness=0.4, lay=1.5}
hb:load(hi, 0.4)
local t = onface(-2, 62, 100)
hb:touch(t[1], t[2], {pressure=0.3, drag={0, 2}})
for _, y in ipairs({14, 28, 42}) do
  local p = onface(-4, y, 85)
  hb:reload(hi, 0.25)
  hb:touch(p[1], p[2], {pressure=0.18, drag={0, 4}})
end
for _, p in ipairs({{-20, -60}, {-5, -70}, {-48, 40}, {0, 152}}) do
  local q = onface(p[1], p[2], 70)
  hb:reload(hi, 0.2)
  hb:touch(q[1], q[2], {pressure=0.15, drag={2, 1}})
end
local ll = onface(-5, 114, 74)
hb:reload(pile{{"lead white", 3}, {"vermilion", 0.1}, {"rose madder", 0.04}, name="lip light"}, 0.35)
hb:touch(ll[1], ll[2], {pressure=0.22, drag={3, 0}})
-- the smile: the corners lifted, a soft shadow tucked into each
local cs = pile{{"raw umber", 0.9}, {"red earth", 0.6}, {"lead white", 0.5}, {"rose madder", 0.1}, name="corner"}
local cb = brush{kind="round", width=1.6, point=0.9}
for _, c in ipairs({{MOUTH.cornerR, -1}, {MOUTH.cornerL, 1}}) do
  local p, s = c[1], c[2]
  cb:reload(cs, 0.4)
  cb:gesture({{p[1] - 3 * s, p[2] + 0.3, 0.35}, {p[1], p[2] - 0.3, 0.3}, {p[1] + 2.5 * s, p[2] - 1.8, 0.0}}, {})
end

--@ chunk 47
clear_palette()
-- the upper lip: the nose's shadow kept narrow under its tip, the flanks of the lip lit
print(wait(2 * 24 * 60))
local function blob(p, rx, ry) return function(x, y) local dx, dy = (x - p[1]) / rx, (y - p[2]) / ry; return math.exp(-(dx * dx + dy * dy)) end end
local tip = blob(onface(0, 85, 82), 7, 3.5)
local feats = LIPS:grow(1)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3) end
local ul = poly({onface(-26, 84, 68), onface(-10, 82, 80), onface(10, 82, 80), onface(26, 84, 68), onface(26, 104, 64), onface(0, 99, 74), onface(-26, 104, 64)}, true):soften(3) - feats
local function v(x, y) return clamp(LVF(x, y) + 0.08 - 0.3 * tip(x, y), 0, 1) end
work(ul, {hand="body", piles=tents_g(FL, v, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=0, clip=FACE - feats,
  tool="filbert 2.5", length={3, 8}, load=0.8})

--@ chunk 48
clear_palette()
-- the hair falling into the braid without a seam; strands plaited across the lobes;
-- the lips shaped
local top = HAIR * rect(600, 400, 110, 140) * mask(function(x, y) return 1 - smoothstep(470, 530, y) end)
local hp = {
  pile{{"raw umber", 1.3}, {"bone black", 0.4}, {"red earth", 0.35}, name="hair d0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.55}, {"bone black", 0.15}, {"yellow ochre", 0.15}, name="hair d1"},
  pile{{"raw umber", 1}, {"red earth", 0.6}, {"yellow ochre", 0.5}, name="hair d2"},
}
local function hv(x, y) return HLV(x, y) * (1 - 0.6 * smoothstep(440, 520, y)) end
work(top, {hand="body", piles=tents_g(hp, hv, 0.15, 0.9, 1.4), coverage=2.6, fill=true, angle=1.45, clip=HAIR,
  tool="filbert 4", length={15, 40}})
-- strands over the braid's lobes, along each lobe's slant
local sd = pile{{"raw umber", 1.3}, {"bone black", 0.35}, {"red earth", 0.3}, name="strand dark"}
local sl = pile{{"yellow ochre", 0.9}, {"raw umber", 0.5}, {"red earth", 0.35}, {"lead white", 0.3}, name="strand light"}
local rb = brush{kind="rigger", width=1.3, point=0.9}
local function cl(t) return lerp(650, 666, t), lerp(455, 775, t) end
local n = 15
for i = 0, n - 1 do
  local t = (i + 0.5) / n
  local x, y = cl(t)
  local side = (i % 2 == 0) and -1 or 1
  local w = lerp(22, 14, t)
  local a = side * 0.55
  local cx, cy = x + side * w * 0.2, y
  for k = -2, 2 do
    local off = k * 3.2
    local ox, oy = -math.sin(a) * off, math.cos(a) * off
    local L = w * 0.55 * math.sqrt(1 - (k / 3) ^ 2)
    local p0 = {cx + ox - math.cos(a) * L, cy + oy - math.sin(a) * L}
    local p1 = {cx + ox + math.cos(a) * L, cy + oy + math.sin(a) * L}
    rb:reload((k <= -1) and sl or sd, 0.4)
    rb:gesture({{p0[1], p0[2], 0.05}, {(p0[1] + p1[1]) / 2, (p0[2] + p1[2]) / 2 - 1.2, 0.35}, {p1[1], p1[2], 0.05}}, {clip=HAIR})
  end
end
-- the lips: the upper turned down from the light, the lower rounding into shadow at its foot
local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local function cat(a, b) local o = {} for _, p in ipairs(a) do o[#o + 1] = p end for _, p in ipairs(b) do o[#o + 1] = p end return o end
local upper = poly(cat(MOUTH.upper, rev(MOUTH.line)), true)
local lower = poly(cat(MOUTH.line, rev(MOUTH.lower)), true)
local lu = pile{{"lead white", 0.8}, {"rose madder", 0.3}, {"red earth", 0.4}, {"raw umber", 0.2}, name="upper lip dark"}
work(upper, {hand="detail", pile=lu, coverage=2.5, fill=true, clip=upper, tool={kind="round", width=1.6, point=0.4}, edge="soft"})
local my = MOUTH.center[2]
local ld = pile{{"lead white", 1}, {"rose madder", 0.2}, {"red earth", 0.35}, {"raw umber", 0.15}, name="lower lip shade"}
work(lower * mask(function(x, y) return smoothstep(my + 4, my + 9, y) end), {hand="detail", pile=ld, coverage=2, clip=lower:grow(0.8),
  tool={kind="round", width=1.6, point=0.4}})
local mline = pile{{"red earth", 1}, {"raw umber", 1}, {"rose madder", 0.3}, {"lead white", 0.1}, name="mouth line"}
local ml = {}
for i, p in ipairs(MOUTH.line) do
  local t = (i - 1) / (#MOUTH.line - 1)
  ml[#ml + 1] = {p[1], p[2] + 0.2, 0.25 + 0.25 * (math.abs(t - 0.5) * 2) ^ 2}
end
local bm = brush{kind="round", width=1.7, point=0.9}
bm:load(mline, 0.5)
bm:gesture(ml, {wobble=0.2})
local hb = brush{kind="filbert", width=3, stiffness=0.4, lay=1.5}
hb:load(pile{{"lead white", 3}, {"vermilion", 0.08}, {"rose madder", 0.03}, name="lip light"}, 0.35)
local ll = onface(-6, 114, 74)
hb:touch(ll[1], ll[2], {pressure=0.2, drag={4, 0}})
