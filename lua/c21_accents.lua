clear_palette()
-- the last touches in the face: warmer whites, the lights on the nose, the lip
-- and the brow, the corners of the mouth lifted the breadth of a smile
local wsh = pile{{"lead white", 1.5}, {"raw umber", 0.22}, {"yellow ochre", 0.1}, {"red earth", 0.04}, name="white warm"}
local wlt = pile{{"lead white", 2.2}, {"yellow ochre", 0.12}, {"raw umber", 0.08}, name="white lit"}
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local cx, cy = e.center[1], e.center[2]
  local wm = EYEM[s].opening - EYEM[s].iris:grow(0.4)
  local far = (s == -1) and 0.25 or 0
  work(wm, {hand="detail", piles={{wsh, function(x, y) return 0.4 + math.abs(x - cx) / 18 + clamp((cy - y + 2) / 6, 0, 1) + far end},
    {wlt, function(x, y) return 0.8 - math.abs(x - cx) / 25 end}}, coverage=2.5, fill=true, clip=EYEM[s].opening:shrink(0.3),
    tool={kind="round", width=1.3, point=0.5}})
  local g = brush{kind="round", width=1.6, point=0.5, lay=3}
  g:load(pile{{"lead white", 1}, blot=0.15, name="glint"}, 0.8)
  local r = e.iris_r * HS
  g:touch(cx - 0.3 * r, cy - 0.32 * r, {pressure=(s == 1) and 0.42 or 0.32})
end
local hi = pile{{"lead white", 4}, {"Naples yellow", 0.35}, {"vermilion", 0.02}, blot=0.1, name="highlight"}
local hb = brush{kind="filbert", width=3.5, stiffness=0.4, lay=1.5}
hb:load(hi, 0.4)
local t = onface(-2, 62, 100)
hb:touch(t[1], t[2], {pressure=0.3, drag={0, 2}})
for _, y in ipairs({14, 28, 42}) do
  local p = onface(-4, y, 85)
  hb:reload(hi, 0.25)
  hb:touch(p[1], p[2], {pressure=0.18, drag={0, 4}})
end
for _, p in ipairs({{-20, -60}, {-5, -70}, {-48, 40}, {0, 152}}) do
  local q = onface(p[1], p[2], 70)
  hb:reload(hi, 0.2)
  hb:touch(q[1], q[2], {pressure=0.15, drag={2, 1}})
end
local ll = onface(-5, 114, 74)
hb:reload(pile{{"lead white", 3}, {"vermilion", 0.1}, {"rose madder", 0.04}, name="lip light"}, 0.35)
hb:touch(ll[1], ll[2], {pressure=0.22, drag={3, 0}})
-- the smile: the corners lifted, a soft shadow tucked into each
local cs = pile{{"raw umber", 0.9}, {"red earth", 0.6}, {"lead white", 0.5}, {"rose madder", 0.1}, name="corner"}
local cb = brush{kind="round", width=1.6, point=0.9}
for _, c in ipairs({{MOUTH.cornerR, -1}, {MOUTH.cornerL, 1}}) do
  local p, s = c[1], c[2]
  cb:reload(cs, 0.4)
  cb:gesture({{p[1] - 3 * s, p[2] + 0.3, 0.35}, {p[1], p[2] - 0.3, 0.3}, {p[1] + 2.5 * s, p[2] - 1.8, 0.0}}, {})
end
