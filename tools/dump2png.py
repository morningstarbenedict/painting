import sys, numpy as np
from PIL import Image, ImageDraw
x0,y0,st=int(sys.argv[4]) if len(sys.argv)>4 else 330,int(sys.argv[5]) if len(sys.argv)>5 else 170,int(sys.argv[6]) if len(sys.argv)>6 else 2
rows=[l.split() for l in open(sys.argv[1]) if l.strip() and ':' in l.split()[0]]
a=np.zeros((len(rows),len(rows[0]),3),np.uint8)
for i,r in enumerate(rows):
  for j,c in enumerate(r):
    f=c.split(':'); v=int(f[0]); p=int(f[1]); ms=[float(t) for t in f[2:]]
    if p==0: col=np.array((60,90,60),float)
    else: col=np.array((v,v,v) if p==1 else (v,int(v*0.9),int(v*0.8)),float)
    tints=[(160,90,40),(200,40,40),(40,60,200),(200,200,40),(40,200,200),(200,40,200)]
    for k,mv in enumerate(ms):
      col=col*(1-0.55*mv)+np.array(tints[k%6])*0.55*mv
    a[i,j]=col.astype(np.uint8)
im=Image.fromarray(a).resize((a.shape[1]*st,a.shape[0]*st),Image.NEAREST)
d=ImageDraw.Draw(im)
if len(sys.argv)>3:
  for x in range(0,1001,50): d.line([((x-x0),0),((x-x0),im.size[1])],fill=(255,0,0)); d.text((x-x0+2,2),str(x),fill=(255,255,0))
  for y in range(0,1334,50): d.line([(0,y-y0),(im.size[0],y-y0)],fill=(255,0,0)); d.text((2,y-y0+2),str(y),fill=(255,255,0))
im.save(sys.argv[2])
