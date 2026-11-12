SG = pile{{"raw umber", 1}, {"red earth", 0.45}, {"bone black", 0.08}, medium=0.8, name="shadow glaze"}
for _, th in ipairs({0.55, 0.4, 0.25}) do
  local m = SPM * mask(function(x, y) return smoothstep(th + 0.12, th - 0.12, SPV(x, y)) end)
  work(m, {hand="glaze", pile=SG, coverage=1, clip=SPM})
end
