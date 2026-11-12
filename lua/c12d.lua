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
