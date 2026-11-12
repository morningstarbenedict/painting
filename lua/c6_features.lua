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
