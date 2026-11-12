clear_palette()
local function tent(list, vf)
  local o = {}
  for i, p in ipairs(list) do
    local c = (i - 1) / (#list - 1)
    o[#o + 1] = {p, function(x, y) return math.max(0, 1 - math.abs(vf(x, y) - c) * (#list - 1)) + 0.001 end}
  end
  return o
end
FL3 = {
  pile{{"raw umber", 1}, {"red earth", 0.4}, {"bone black", 0.1}, {"green earth", 0.3}, {"lead white", 0.1}},
  pile{{"raw umber", 1}, {"red earth", 0.4}, {"green earth", 0.4}, {"yellow ochre", 0.2}, {"lead white", 0.45}},
  pile{{"lead white", 1.2}, {"raw umber", 0.45}, {"red earth", 0.25}, {"yellow ochre", 0.35}, {"green earth", 0.35}},
  pile{{"lead white", 2.2}, {"yellow ochre", 0.35}, {"red earth", 0.18}, {"green earth", 0.15}, {"raw umber", 0.08}},
  pile{{"lead white", 3}, {"yellow ochre", 0.25}, {"vermilion", 0.05}, {"red earth", 0.04}},
  pile{{"lead white", 4}, {"Naples yellow", 0.4}, {"vermilion", 0.02}},
}
for k, cx in ipairs({250, 650}) do
  local cy = 1050
  local f = function(x, y)
    local dx, dy = (x - cx) / 90, (y - cy) / 90
    local d2 = dx * dx + dy * dy
    if d2 > 1 then return 0.3 end
    local nz = math.sqrt(1 - d2)
    local d = -0.62 * dx - 0.58 * dy + 0.53 * nz
    return clamp(((d + 0.55) / 1.55) ^ 1.35, 0, 1)
  end
  local m = ellipse(cx, cy, 90, 90)
  local ang = function(x,y) return math.atan(y-cy, x-cx) + 1.57 end
  work(m, {hand="body", piles=tent(FL3, f), coverage=3, fill=true, clip=m, tool="filbert 4", length={6, 14}, angle=ang})
  if k == 2 then
    local sh = m * mask(function(x, y) return smoothstep(0.55, 0.25, f(x, y)) end)
    work(sh, {hand="body", piles=tent({FL3[1], FL3[2], FL3[3]}, function(x, y) return f(x, y) / 0.5 end), coverage=2, clip=m, tool="filbert 3", length={5, 10}, angle=ang, load=0.6})
    local hi = m * mask(function(x, y) return smoothstep(0.7, 0.9, f(x, y)) end)
    work(hi, {hand="body", pile=FL3[6], coverage=1.5, clip=m, tool="filbert 3", length={5, 10}, angle=ang, load=0.6})
  end
end
