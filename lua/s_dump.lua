local x0, y0, x1, y1, st = DX0 or 330, DY0 or 170, DX1 or 760, DY1 or 760, DST or 2
local out = {}
local ms = DUMP_MASKS or {}
for y = y0, y1, st do
  local row = {}
  for x = x0, x1, st do
    local s = F:sample(x, y)
    local m = {}
    for i, mk in ipairs(ms) do m[i] = string.format("%.2f", mk:at(x, y)) end
    local ex = (#m > 0) and (":" .. table.concat(m, ":")) or ""
    if s then row[#row + 1] = string.format("%d", math.floor(lightval(s) * 255 + 0.5)) .. ":" .. s.part .. ex
    else row[#row + 1] = "-1:0" .. ex end
  end
  out[#out + 1] = table.concat(row, " ")
end
print(table.concat(out, "\n"))
