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
