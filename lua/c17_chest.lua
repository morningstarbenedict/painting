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
