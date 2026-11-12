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
