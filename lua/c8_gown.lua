clear_palette()
-- the gown, 2: the sleeves repainted in green velvet, the bodice's folds,
-- the band of the neckline, the chemise's edge

-- the sleeves: everything of the gown outside the seams
local function seamF(y) return lerp(436, 418, clamp((y - 740) / 430, 0, 1)) end
local function seamN(y) return lerp(706, 738, clamp((y - 750) / 420, 0, 1)) end
SLEEVES = GOWN * mask(function(x, y) return ((x < seamF(y)) or (x > seamN(y))) and 1 or 0 end):soften(1.5)
BODICE = GOWN - SLEEVES
local slD = pile{{"green earth", 1.4}, {"bone black", 0.5}, {"raw umber", 0.5}, {"copper green", 0.3}, turps=0.1, name="sleeve dark"}
local slM = pile{{"green earth", 1.6}, {"copper green", 0.5}, {"yellow ochre", 0.4}, {"lead white", 0.35}, {"bone black", 0.1}, turps=0.1, name="sleeve mid"}
local slL = pile{{"green earth", 1}, {"copper green", 0.4}, {"Naples yellow", 0.5}, {"lead white", 1}, turps=0.1, name="sleeve light"}
-- velvet: folds as the light catches the pile; a fold noise along the arm
local folds = noise{seed=31, period=70, octaves=3, stretch={1.45, 4}}
local function SV(x, y) return clamp(LV(x, y) * 0.8 + 0.25 * folds(x, y), 0, 1) end
work(SLEEVES, {hand="body", piles=tents({slD, slM, slL}, SV, 0.15, 0.8), coverage=2.6, fill=true,
  angle=F:field("fall"), clip=SLEEVES, tool="filbert 10"})
blend(SLEEVES:shrink(3), {angle=F:field("fall")})

-- the bodice's folds and lights: vermilion lights in the lit planes, deep red-black in the turns
local bodN = noise{seed=17, period=55, octaves=3, stretch={1.5, 3}}
local function BV(x, y) return clamp(LV(x, y) * 0.85 + 0.18 * bodN(x, y), 0, 1) end
local bdD = pile{{"red earth", 1.2}, {"bone black", 0.6}, {"rose madder", 0.4}, name="bodice dark"}
local bdM = pile{{"vermilion", 1}, {"red earth", 0.8}, {"rose madder", 0.3}, name="bodice mid"}
local bdL = pile{{"vermilion", 1.3}, {"lead white", 0.35}, {"red earth", 0.2}, name="bodice light"}
work(BODICE, {hand="body", piles=tents({bdD, bdM, bdL}, BV, 0.2, 0.8), coverage=2.4, fill=true,
  angle=F:field("fall"), clip=BODICE, tool="filbert 8"})
blend(BODICE:shrink(3), {angle=F:field("fall")})

-- the neckline's band: black velvet, laid along the edge of the breast
BANDPATH = {{432, 708}, {400, 744}, {401, 793}, {414, 829}, {520, 831}, {620, 831}, {735, 826}, {742, 790}, {744, 738}, {710, 706}}
BAND = ribbon(BANDPATH, 14) * (GOWN + SLEEVES):grow(1) - NECK
local bandP = pile{{"bone black", 1}, {"raw umber", 0.5}, {"smalt", 0.2}, name="band"}
work(BAND, {hand="detail", pile=bandP, coverage=3, fill=true, clip=BAND, tool={kind="round", width=2.2, point=0.5}})

-- the chemise: a fine white edge of linen just inside the neckline, gathered in tiny pleats
CHEM = (CHESTPOLY - CHESTPOLY:shrink(3.2)) * rect(390, 736, 370, 100) * BODYF
local chemS = pile{{"lead white", 2}, {"raw umber", 0.15}, {"bone black", 0.05}, name="chemise shade"}
local chemL = pile{{"lead white", 3}, {"Naples yellow", 0.15}, name="chemise light"}
work(CHEM, {hand="detail", piles={{chemS, function(x, y) return 1 - LV(x, y) end}, {chemL, LV}}, coverage=3, fill=true, clip=CHEM,
  tool={kind="round", width=1.2, point=0.6}})
print(SLEEVES:area(), BODICE:area(), BAND:area(), CHEM:area())
