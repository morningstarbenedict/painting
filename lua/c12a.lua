clear_palette()
-- the sleeves repainted: deep green velvet, its pile catching the light in folds
local folds = noise{seed=31, period=70, octaves=3, stretch={1.45, 4}}
local function SV(x, y) return clamp(LV(x, y) * 0.9 + 0.3 * folds(x, y) - 0.1, 0, 1) end
local sl = {
  pile{{"bone black", 1}, {"copper green", 0.5}, {"green earth", 0.6}, {"raw umber", 0.3}, name="velvet 0"},
  pile{{"bone black", 0.5}, {"copper green", 0.7}, {"green earth", 1}, {"raw umber", 0.2}, name="velvet 1"},
  pile{{"copper green", 0.8}, {"green earth", 1}, {"bone black", 0.2}, {"yellow ochre", 0.2}, {"lead white", 0.15}, name="velvet 2"},
  pile{{"green earth", 1}, {"copper green", 0.5}, {"Naples yellow", 0.35}, {"lead white", 0.35}, name="velvet 3"},
}
work(SLEEVES, {hand="body", piles=tents_g(sl, SV, 0.1, 0.85, 1.3), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=SLEEVES, tool="filbert 8", length={15, 45}})
