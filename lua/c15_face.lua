clear_palette()
-- the face: darker eyes, the sockets' shadow at the nose, the upper lip and the
-- nose's shadow smoothed, the far contour lost into the dark
print(wait(3 * 24 * 60))
local function rev(t) local o = {} for i = #t, 1, -1 do o[#o + 1] = t[i] end return o end
local feats = (EYEM[-1].opening + EYEM[1].opening):grow(1.5) + LIPS:grow(1)
for _, k in ipairs({"nostR", "nostL"}) do feats = feats + ribbon(NOSE[k], 3.5) end

-- the sockets: a soft shadow between each eye and the bridge of the nose, under the brow
local function blob(p, rx, ry) return function(x, y) local dx, dy = (x - p[1]) / rx, (y - p[2]) / ry; return math.exp(-(dx * dx + dy * dy)) end end
local sR = blob(onface(-22, -4, 70), 9, 12)
local sL = blob(onface(22, -4, 70), 11, 13)
local function lvS(x, y) return LVF(x, y) * (1 - 0.45 * (sR(x, y) + sL(x, y))) end
local socket = (FACE - feats) * mask(function(x, y) return clamp(1.6 * (sR(x, y) + sL(x, y)), 0, 1) end)
work(socket, {hand="body", piles=tents_g(FL, lvS, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=F:field("across"),
  clip=FACE - feats, tool="filbert 3", length={4, 9}, load=0.8})
-- the upper lip, lighter; the nose's shadowed flank, smoothed
local ul = poly({onface(-24, 86, 70), onface(-8, 83, 80), onface(8, 83, 80), onface(24, 86, 70), onface(24, 104, 66), onface(0, 99, 74), onface(-24, 104, 66)}, true):soften(3) - feats
work(ul, {hand="body", piles=tents_g(FL, function(x, y) return LVF(x, y) + 0.12 end, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=0,
  clip=FACE - feats, tool="filbert 3", length={4, 9}, load=0.8})
local ns = ribbon(NOSE.side, 7):soften(3) - feats
work(ns, {hand="body", piles=tents_g(FL, LVF, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=1.5,
  clip=FACE - feats, tool="filbert 3", length={4, 10}, load=0.8})
-- the line between chin and neck: the jaw's turn, not a line
local jaw = ribbon(FACE_CHIN, 5):soften(2) * (FACE + NECK)
work(jaw, {hand="body", piles=tents_g(FL, LVF, 0.12, 0.95, 1.5), coverage=3, fill=true, angle=0.2,
  clip=SKIN, tool="filbert 3", length={4, 9}, load=0.8})
clear_palette()
-- the irises again, in body colour: dark warm brown, a darker rim, lighter below
local irisD = pile{{"raw umber", 1}, {"bone black", 0.35}, {"red earth", 0.15}, name="iris dark"}
local irisM = pile{{"raw umber", 1}, {"red earth", 0.3}, {"yellow ochre", 0.2}, {"bone black", 0.08}, name="iris mid"}
local irisL = pile{{"raw umber", 0.8}, {"yellow ochre", 0.5}, {"red earth", 0.3}, name="iris light"}
local pupil = pile{{"bone black", 1}, {"raw umber", 0.3}, name="pupil"}
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local ir = EYEM[s].iris
  local cx, cy = e.center[1], e.center[2]
  local rr = e.iris_r * HS
  work(ir, {hand="detail", piles={
      {irisD, function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2) / rr; return 1.4 * smoothstep(0.6, 1.0, d) + 0.8 * clamp((cy - y) / rr + 0.3, 0, 1) end},
      {irisM, function(x, y) return 0.7 end},
      {irisL, function(x, y) return 0.9 * clamp((y - cy) / rr, 0, 1) end}},
    coverage=3, fill=true, clip=ir, tool={kind="round", width=1.2, point=0.6}})
  work(EYEM[s].pupil, {hand="detail", pile=pupil, coverage=3, fill=true, clip=EYEM[s].pupil, tool={kind="round", width=1.0, point=0.7}})
  -- the whites lowered: a grey-warm body tint near the corners and under the lid
  local wsh = pile{{"lead white", 1.2}, {"raw umber", 0.3}, {"red earth", 0.06}, {"yellow ochre", 0.06}, name="white shade"}
  local wm = (EYEM[s].opening - ir:grow(0.4)) * mask(function(x, y)
    return clamp(math.abs(x - cx) / 16 - 0.35 + clamp((cy - y + 2) / 6, 0, 1), 0, 1) end)
  work(wm, {hand="detail", pile=wsh, coverage=2, clip=EYEM[s].opening, tool={kind="round", width=1.4, point=0.5}})
end
for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  local g = brush{kind="round", width=1.6, point=0.5, lay=3}
  g:load(pile{{"lead white", 1}, blot=0.15, name="glint"}, 0.8)
  local r = e.iris_r * HS
  g:touch(e.center[1] - 0.3 * r, e.center[2] - 0.32 * r, {pressure=(s == 1) and 0.42 or 0.32})
end
