clear_palette()
-- the flesh, second coat: the same ladder pressed darker in the middle tones,
-- over the first now set
print(wait(3 * 24 * 60))
function tents_g(list, vf, lo, hi, g)
  local out = {}
  local n = #list
  for i, p in ipairs(list) do
    local c = (i - 1) / (n - 1)
    out[#out + 1] = {p, function(x, y)
      local t = clamp((vf(x, y) - lo) / (hi - lo), 0, 1) ^ g
      return math.max(0, 1 - math.abs(t - c) * (n - 1)) + 0.001
    end}
  end
  return out
end
local ps = tents_g(FL, LVF, 0.12, 0.95, 1.5)
ps[#ps + 1] = {ROSE, function(x, y) return 1.1 * ROSY(x, y) * smoothstep(0.35, 0.65, LV(x, y)) end}
work(SKIN, {hand="body", piles=ps, coverage=3, fill=true, angle=F:field("across"), clip=SKIN,
  tool="filbert 4", length={6, 14}, load=0.9})
print(wait(4 * 24 * 60))
