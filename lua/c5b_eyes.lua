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
