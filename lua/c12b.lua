clear_palette()
-- the bodice repainted: crimson, turning dark at its sides, soft folds toward the waist
local folds = noise{seed=5, period=45, octaves=2, stretch={1.5, 5}}
local function BV(x, y)
  local side = smoothstep(500, 425, x) + smoothstep(600, 710, x)
  return clamp(LV(x, y) * 0.9 - 0.35 * side + 0.25 * folds(x, y) * smoothstep(840, 1050, y) + 0.05, 0, 1)
end
local bd = {
  pile{{"rose madder", 1}, {"bone black", 0.5}, {"red earth", 0.5}, name="crimson 0"},
  pile{{"rose madder", 1}, {"red earth", 0.6}, {"vermilion", 0.3}, {"bone black", 0.12}, name="crimson 1"},
  pile{{"vermilion", 0.7}, {"rose madder", 0.8}, {"red earth", 0.3}, name="crimson 2"},
  pile{{"vermilion", 1}, {"rose madder", 0.3}, {"lead white", 0.2}, name="crimson 3"},
}
work(BODICE, {hand="body", piles=tents_g(bd, BV, 0.05, 0.85, 1.1), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=BODICE, tool="filbert 7", length={12, 36}})
