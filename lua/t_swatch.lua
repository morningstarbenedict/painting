SW = {
  v1 = pile{{"raw umber", 1.2}, {"bone black", 0.35}, {"green earth", 1.5}, {"lead white", 0.15}},
  v2 = pile{{"raw umber", 0.9}, {"bone black", 0.12}, {"green earth", 1.6}, {"lead white", 0.6}},
  v3 = pile{{"raw umber", 0.5}, {"green earth", 1.4}, {"lead white", 1.4}, {"yellow ochre", 0.1}},
  v4 = pile{{"raw umber", 0.15}, {"green earth", 0.8}, {"lead white", 2.6}, {"yellow ochre", 0.12}},
  v5 = pile{{"lead white", 4}, {"green earth", 0.25}, {"yellow ochre", 0.12}},
  f1 = pile{{"raw umber", 1}, {"red earth", 0.8}, {"bone black", 0.1}, {"lead white", 0.3}},
  f2 = pile{{"red earth", 0.7}, {"raw umber", 0.4}, {"yellow ochre", 0.5}, {"lead white", 1.2}},
  f3 = pile{{"lead white", 2.4}, {"red earth", 0.35}, {"yellow ochre", 0.35}, {"green earth", 0.15}},
  f4 = pile{{"lead white", 3.2}, {"vermilion", 0.12}, {"yellow ochre", 0.22}, {"red earth", 0.05}},
  f5 = pile{{"lead white", 4}, {"vermilion", 0.05}, {"Naples yellow", 0.3}},
  rose = pile{{"lead white", 2.5}, {"vermilion", 0.35}, {"rose madder", 0.1}},
}
SWN = {"v1","v2","v3","v4","v5","f1","f2","f3","f4","f5","rose"}
for i, n in ipairs(SWN) do
  local x = 40 + ((i - 1) % 6) * 160
  local y = 60 + math.floor((i - 1) / 6) * 160
  local r = rect(x, y, 120, 120)
  work(r, {hand="body", pile=SW[n], coverage=3, fill=true, clip=r})
end
