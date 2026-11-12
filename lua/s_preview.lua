head = build_head(); neck = build_neck()
F = form{{head}, {neck, dist=0.05}, light={from={-1, -0.75}, front=0.65, ambient=0.18, bounce=0.12, penumbra=0.06}}
local lv = {}
local N = 6
for i = 0, N - 1 do
  local t = i / (N - 1)
  lv[#lv + 1] = pile{{"bone black", (1 - t) ^ 2 * 3 + 0.02}, {"lead white", t * 3 + 0.05}}
end
local ps = {}
for i = 1, N do
  local c = (i - 1) / (N - 1)
  ps[#ps + 1] = {lv[i], function(x, y)
    local v = F:value(x, y)
    return math.max(0, 1 - math.abs(v - c) * (N - 1))
  end}
end
work(F:parts_mask{1, 2}, {hand="body", piles=ps, coverage=2.5, angle=F:field("across"), clip=true})
for _, p in ipairs({{EX - 60, EY}, {EX, EY}, {EX + 40, EY + 70}}) do print(p[1], p[2], F:value(p[1], p[2])) end
