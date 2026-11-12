clear_palette()
-- the hair repainted deeper: auburn-brown, its lights to come back as strands
local hp = {
  pile{{"raw umber", 1.3}, {"bone black", 0.4}, {"red earth", 0.35}, name="hair d0"},
  pile{{"raw umber", 1.2}, {"red earth", 0.55}, {"bone black", 0.15}, {"yellow ochre", 0.15}, name="hair d1"},
  pile{{"raw umber", 1}, {"red earth", 0.6}, {"yellow ochre", 0.5}, name="hair d2"},
  pile{{"raw umber", 0.7}, {"red earth", 0.5}, {"yellow ochre", 0.9}, {"lead white", 0.2}, name="hair d3"},
}
work(HAIR, {hand="body", piles=tents_g(hp, HLV, 0.2, 0.95, 1.6), coverage=2.6, fill=true,
  angle=FH:field("fall"), clip=HAIR, tool="filbert 5", length={12, 30}})
