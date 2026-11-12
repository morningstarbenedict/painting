SG = pile{{"raw umber", 1}, {"red earth", 0.3}, {"bone black", 0.12}, medium=0.85, name="shadow glaze"}
for k, s in ipairs(SPH) do
  if k > 1 then
    for _, th in ipairs({0.55, 0.38, 0.22}) do
      local m = s.m * mask(function(x, y) return smoothstep(th + 0.15, th - 0.15, s.v(x, y)) end)
      if k == 2 then
        work(m, {hand="glaze", pile=SG, coverage=1, clip=s.m})
        blend(m, {tool={kind="badger", width=14}, length={10, 20}, clip=s.m, angle=function(x,y) return math.atan(y-s.cy, x-s.cx) + 1.57 end})
      elseif k == 3 then
        work(m, {hand="glaze", pile=SG, coverage=1, clip=s.m, tool={kind="badger", width=18}, length={15, 35}, pressure={0.3, 0.5},
          angle=function(x,y) return math.atan(y-s.cy, x-s.cx) + 1.57 end})
      else
        work(m, {hand="glaze", pile=SG, coverage=1, clip=s.m})
        local r = rag{width=20}
        r:wipe(m, {pressure=0.25})
      end
    end
  end
end
