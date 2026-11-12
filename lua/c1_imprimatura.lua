-- a warm, lean imprimatura over the white ground, as on a gessoed panel
palette{set_out={"lead white", "vermilion", "red earth", "yellow ochre", "raw umber", "bone black",
  "green earth", "rose madder", "copper green", "smalt", "Naples yellow"}}
IMP = pile{{"raw umber", 1}, {"yellow ochre", 1.2}, {"red earth", 0.2}, turps=0.75, name="imprimatura"}
work(everywhere(), {hand="broad", pile=IMP, coverage=1.6, load=0.5, angle=0.3, pressure={0.5, 0.8}, fill=true})
blend(everywhere(), {angle=-0.4})
print(wait(24 * 60))
