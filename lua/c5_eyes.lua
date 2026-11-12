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
