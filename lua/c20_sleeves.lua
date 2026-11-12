clear_palette()
-- the sleeves once more, deeper and quieter: a dark green velvet, its lights restrained
local folds = noise{seed=31, period=70, octaves=3, stretch={1.45, 4}}
local function SV(x, y) return clamp(LV(x, y) * 0.85 + 0.28 * folds(x, y) - 0.2, 0, 1) end
local sl = {
  pile{{"bone black", 1}, {"copper green", 0.45}, {"green earth", 0.6}, {"raw umber", 0.35}, name="velvet 0"},
  pile{{"bone black", 0.6}, {"copper green", 0.6}, {"green earth", 1}, {"raw umber", 0.25}, name="velvet 1"},
  pile{{"copper green", 0.7}, {"green earth", 1}, {"bone black", 0.3}, {"raw umber", 0.15}, name="velvet 2"},
  pile{{"green earth", 1}, {"copper green", 0.5}, {"yellow ochre", 0.15}, {"lead white", 0.25}, {"bone black", 0.08}, name="velvet 3"},
}
work(SLEEVES - BAND2, {hand="body", piles=tents_g(sl, SV, 0.05, 0.8, 1.2), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=SLEEVES - BAND2, tool="filbert 6", length={12, 36}})
-- gold ties and chemise puffs at the seams, again over the new velvet
local gold2 = pile{{"Naples yellow", 1}, {"yellow ochre", 0.6}, {"lead white", 0.2}, name="gold mid"}
local gold3 = pile{{"Naples yellow", 1}, {"lead white", 1}, blot=0.2, name="gold light"}
local puff = pile{{"lead white", 3}, {"raw umber", 0.12}, name="puff"}
local puffS = pile{{"lead white", 1.3}, {"raw umber", 0.35}, {"bone black", 0.08}, name="puff shade"}
local tie = brush{kind="round", width=2.2, point=0.7}
for _, s in ipairs({{425, 880}, {421, 990}, {420, 1100}, {720, 890}, {726, 1000}, {732, 1110}}) do
  local m = ellipse(s[1], s[2], 8, 13):roughen(1.5, 6, 3)
  work(m, {hand="detail", piles={{puff, function(x, y) return LV(x, y) + 0.2 end}, {puffS, function(x, y) return 1 - LV(x, y) end}},
    coverage=3, fill=true, clip=m, tool={kind="round", width=1.8, point=0.5}})
  for k = -1, 1, 2 do
    tie:reload(gold2, 0.5)
    tie:gesture({{s[1] - 7, s[2] + k * 2.5, 0.35}, {s[1], s[2] + k * 0.5, 0.5}, {s[1] + 7, s[2] - k * 2.5, 0.35}}, {})
  end
  tie:reload(gold3, 0.5)
  tie:gesture({{s[1], s[2], 0.35}, {s[1] + 3, s[2] + 10, 0.25}, {s[1] + 2, s[2] + 18, 0.0}}, {})
end
