-- the underdrawing: the features and contours laid in lightly, as a cartoon
-- pounced and gone over with a fine point
local c = pencil("2B")
local function ln(pts, p) c:line(pts, {pressure=p}) end

-- the silhouette of the face, found from the solid row by row
local far, near, chin = {}, {}, {}
for y = 340, 590, 10 do
  for x = 380, 560 do if HEAD:at(x, y) > 0.5 then far[#far + 1] = {x, y}; break end end
end
for y = 470, 585, 10 do
  for x = 680, 480, -1 do if HEAD:at(x, y) > 0.5 then near[#near + 1] = {x, y}; break end end
end
for x = 440, 590, 10 do
  for y = 640, 480, -1 do if HEAD:at(x, y) > 0.5 and BODYF:at(x, y + 3) < 0.5 then chin[#chin + 1] = {x, y}; break end end
end
FACE_FAR, FACE_NEAR, FACE_CHIN = far, near, chin
ln(far, 0.32); ln(near, 0.3); ln(chin, 0.3)

for _, s in ipairs({-1, 1}) do
  local e = EYES[s]
  ln(e.up, 0.45); ln(e.low, 0.25); ln(e.crease, 0.2); ln(e.brow, 0.25)
  -- the iris, a circle on the eyeball
  local ir = {}
  for i = 0, 16 do
    local a = 2 * math.pi * i / 16
    ir[#ir + 1] = onface(e.irisc[1] + e.iris_r * math.cos(a), e.irisc[2] + e.iris_r * math.sin(a), 72)
  end
  ln(ir, 0.25)
end
ln(NOSE.side, 0.22); ln(NOSE.wingR, 0.3); ln(NOSE.wingL, 0.3); ln(NOSE.base, 0.25)
ln(MOUTH.line, 0.4); ln(MOUTH.upper, 0.22); ln(MOUTH.lower, 0.2)

-- the hairline and the neckline, lightly
ln({{416, 336}, {448, 302}, {478, 288}, {505, 283}, {540, 287}, {572, 300}, {596, 326}, {608, 366}, {614, 410}, {614, 460}, {607, 510}}, 0.2)
ln({{406, 745}, {408, 790}, {420, 820}, {520, 822}, {620, 822}, {728, 818}, {734, 790}, {736, 740}}, 0.2)
print(#far, #near, #chin)
