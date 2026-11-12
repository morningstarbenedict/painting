-- lift the first try at the eyes while it is wet
local m = nil
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local pts = {}
  for _, p in ipairs(e.up) do pts[#pts + 1] = p end
  for _, p in ipairs(e.crease) do pts[#pts + 1] = p end
  for i = #e.low, 1, -1 do pts[#pts + 1] = e.low[i] end
  local mm = EYEM[s].opening:grow(4) + ribbon(e.crease, 6) + ribbon(e.up, 9)
  m = m and (m + mm) or mm
end
EYELIFT = m:soften(2)
for k = 1, 3 do
  local r = rag{width=10}
  r:dip(0.9)
  r:wipe(EYELIFT, {pressure=0.7, angle=(k == 2) and 1.57 or 0, passes=2})
end
print(drying(EYES[1].center[1], EYES[1].center[2]))
