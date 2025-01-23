
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
   8:	87aa                	mv	a5,a0
   a:	fcb43023          	sd	a1,-64(s0)
   e:	fcf42623          	sw	a5,-52(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  12:	fe042023          	sw	zero,-32(s0)
  16:	fe042783          	lw	a5,-32(s0)
  1a:	fef42223          	sw	a5,-28(s0)
  1e:	fe442783          	lw	a5,-28(s0)
  22:	fef42423          	sw	a5,-24(s0)
  inword = 0;
  26:	fc042e23          	sw	zero,-36(s0)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2a:	a861                	j	c2 <wc+0xc2>
    for(i=0; i<n; i++){
  2c:	fe042623          	sw	zero,-20(s0)
  30:	a041                	j	b0 <wc+0xb0>
      c++;
  32:	fe042783          	lw	a5,-32(s0)
  36:	2785                	addiw	a5,a5,1
  38:	fef42023          	sw	a5,-32(s0)
      if(buf[i] == '\n')
  3c:	00001717          	auipc	a4,0x1
  40:	37470713          	addi	a4,a4,884 # 13b0 <buf>
  44:	fec42783          	lw	a5,-20(s0)
  48:	97ba                	add	a5,a5,a4
  4a:	0007c783          	lbu	a5,0(a5)
  4e:	873e                	mv	a4,a5
  50:	47a9                	li	a5,10
  52:	00f71763          	bne	a4,a5,60 <wc+0x60>
        l++;
  56:	fe842783          	lw	a5,-24(s0)
  5a:	2785                	addiw	a5,a5,1
  5c:	fef42423          	sw	a5,-24(s0)
      if(strchr(" \r\t\n\v", buf[i]))
  60:	00001717          	auipc	a4,0x1
  64:	35070713          	addi	a4,a4,848 # 13b0 <buf>
  68:	fec42783          	lw	a5,-20(s0)
  6c:	97ba                	add	a5,a5,a4
  6e:	0007c783          	lbu	a5,0(a5)
  72:	85be                	mv	a1,a5
  74:	00001517          	auipc	a0,0x1
  78:	ecc50513          	addi	a0,a0,-308 # f40 <malloc+0x144>
  7c:	00000097          	auipc	ra,0x0
  80:	30a080e7          	jalr	778(ra) # 386 <strchr>
  84:	87aa                	mv	a5,a0
  86:	c781                	beqz	a5,8e <wc+0x8e>
        inword = 0;
  88:	fc042e23          	sw	zero,-36(s0)
  8c:	a829                	j	a6 <wc+0xa6>
      else if(!inword){
  8e:	fdc42783          	lw	a5,-36(s0)
  92:	2781                	sext.w	a5,a5
  94:	eb89                	bnez	a5,a6 <wc+0xa6>
        w++;
  96:	fe442783          	lw	a5,-28(s0)
  9a:	2785                	addiw	a5,a5,1
  9c:	fef42223          	sw	a5,-28(s0)
        inword = 1;
  a0:	4785                	li	a5,1
  a2:	fcf42e23          	sw	a5,-36(s0)
    for(i=0; i<n; i++){
  a6:	fec42783          	lw	a5,-20(s0)
  aa:	2785                	addiw	a5,a5,1
  ac:	fef42623          	sw	a5,-20(s0)
  b0:	fec42783          	lw	a5,-20(s0)
  b4:	873e                	mv	a4,a5
  b6:	fd842783          	lw	a5,-40(s0)
  ba:	2701                	sext.w	a4,a4
  bc:	2781                	sext.w	a5,a5
  be:	f6f74ae3          	blt	a4,a5,32 <wc+0x32>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  c2:	fcc42783          	lw	a5,-52(s0)
  c6:	20000613          	li	a2,512
  ca:	00001597          	auipc	a1,0x1
  ce:	2e658593          	addi	a1,a1,742 # 13b0 <buf>
  d2:	853e                	mv	a0,a5
  d4:	00000097          	auipc	ra,0x0
  d8:	616080e7          	jalr	1558(ra) # 6ea <read>
  dc:	87aa                	mv	a5,a0
  de:	fcf42c23          	sw	a5,-40(s0)
  e2:	fd842783          	lw	a5,-40(s0)
  e6:	2781                	sext.w	a5,a5
  e8:	f4f042e3          	bgtz	a5,2c <wc+0x2c>
      }
    }
  }
  if(n < 0){
  ec:	fd842783          	lw	a5,-40(s0)
  f0:	2781                	sext.w	a5,a5
  f2:	0007df63          	bgez	a5,110 <wc+0x110>
    printf("wc: read error\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	e5250513          	addi	a0,a0,-430 # f48 <malloc+0x14c>
  fe:	00001097          	auipc	ra,0x1
 102:	b0c080e7          	jalr	-1268(ra) # c0a <printf>
    exit(1);
 106:	4505                	li	a0,1
 108:	00000097          	auipc	ra,0x0
 10c:	5ca080e7          	jalr	1482(ra) # 6d2 <exit>
  }
  printf("%d %d %d %s\n", l, w, c, name);
 110:	fe042683          	lw	a3,-32(s0)
 114:	fe442603          	lw	a2,-28(s0)
 118:	fe842783          	lw	a5,-24(s0)
 11c:	fc043703          	ld	a4,-64(s0)
 120:	85be                	mv	a1,a5
 122:	00001517          	auipc	a0,0x1
 126:	e3650513          	addi	a0,a0,-458 # f58 <malloc+0x15c>
 12a:	00001097          	auipc	ra,0x1
 12e:	ae0080e7          	jalr	-1312(ra) # c0a <printf>
}
 132:	0001                	nop
 134:	70e2                	ld	ra,56(sp)
 136:	7442                	ld	s0,48(sp)
 138:	6121                	addi	sp,sp,64
 13a:	8082                	ret

000000000000013c <main>:

int
main(int argc, char *argv[])
{
 13c:	7179                	addi	sp,sp,-48
 13e:	f406                	sd	ra,40(sp)
 140:	f022                	sd	s0,32(sp)
 142:	1800                	addi	s0,sp,48
 144:	87aa                	mv	a5,a0
 146:	fcb43823          	sd	a1,-48(s0)
 14a:	fcf42e23          	sw	a5,-36(s0)
  int fd, i;

  if(argc <= 1){
 14e:	fdc42783          	lw	a5,-36(s0)
 152:	0007871b          	sext.w	a4,a5
 156:	4785                	li	a5,1
 158:	02e7c063          	blt	a5,a4,178 <main+0x3c>
    wc(0, "");
 15c:	00001597          	auipc	a1,0x1
 160:	e0c58593          	addi	a1,a1,-500 # f68 <malloc+0x16c>
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	e9a080e7          	jalr	-358(ra) # 0 <wc>
    exit(0);
 16e:	4501                	li	a0,0
 170:	00000097          	auipc	ra,0x0
 174:	562080e7          	jalr	1378(ra) # 6d2 <exit>
  }

  for(i = 1; i < argc; i++){
 178:	4785                	li	a5,1
 17a:	fef42623          	sw	a5,-20(s0)
 17e:	a071                	j	20a <main+0xce>
    if((fd = open(argv[i], 0)) < 0){
 180:	fec42783          	lw	a5,-20(s0)
 184:	078e                	slli	a5,a5,0x3
 186:	fd043703          	ld	a4,-48(s0)
 18a:	97ba                	add	a5,a5,a4
 18c:	639c                	ld	a5,0(a5)
 18e:	4581                	li	a1,0
 190:	853e                	mv	a0,a5
 192:	00000097          	auipc	ra,0x0
 196:	580080e7          	jalr	1408(ra) # 712 <open>
 19a:	87aa                	mv	a5,a0
 19c:	fef42423          	sw	a5,-24(s0)
 1a0:	fe842783          	lw	a5,-24(s0)
 1a4:	2781                	sext.w	a5,a5
 1a6:	0207d763          	bgez	a5,1d4 <main+0x98>
      printf("wc: cannot open %s\n", argv[i]);
 1aa:	fec42783          	lw	a5,-20(s0)
 1ae:	078e                	slli	a5,a5,0x3
 1b0:	fd043703          	ld	a4,-48(s0)
 1b4:	97ba                	add	a5,a5,a4
 1b6:	639c                	ld	a5,0(a5)
 1b8:	85be                	mv	a1,a5
 1ba:	00001517          	auipc	a0,0x1
 1be:	db650513          	addi	a0,a0,-586 # f70 <malloc+0x174>
 1c2:	00001097          	auipc	ra,0x1
 1c6:	a48080e7          	jalr	-1464(ra) # c0a <printf>
      exit(1);
 1ca:	4505                	li	a0,1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	506080e7          	jalr	1286(ra) # 6d2 <exit>
    }
    wc(fd, argv[i]);
 1d4:	fec42783          	lw	a5,-20(s0)
 1d8:	078e                	slli	a5,a5,0x3
 1da:	fd043703          	ld	a4,-48(s0)
 1de:	97ba                	add	a5,a5,a4
 1e0:	6398                	ld	a4,0(a5)
 1e2:	fe842783          	lw	a5,-24(s0)
 1e6:	85ba                	mv	a1,a4
 1e8:	853e                	mv	a0,a5
 1ea:	00000097          	auipc	ra,0x0
 1ee:	e16080e7          	jalr	-490(ra) # 0 <wc>
    close(fd);
 1f2:	fe842783          	lw	a5,-24(s0)
 1f6:	853e                	mv	a0,a5
 1f8:	00000097          	auipc	ra,0x0
 1fc:	502080e7          	jalr	1282(ra) # 6fa <close>
  for(i = 1; i < argc; i++){
 200:	fec42783          	lw	a5,-20(s0)
 204:	2785                	addiw	a5,a5,1
 206:	fef42623          	sw	a5,-20(s0)
 20a:	fec42783          	lw	a5,-20(s0)
 20e:	873e                	mv	a4,a5
 210:	fdc42783          	lw	a5,-36(s0)
 214:	2701                	sext.w	a4,a4
 216:	2781                	sext.w	a5,a5
 218:	f6f744e3          	blt	a4,a5,180 <main+0x44>
  }
  exit(0);
 21c:	4501                	li	a0,0
 21e:	00000097          	auipc	ra,0x0
 222:	4b4080e7          	jalr	1204(ra) # 6d2 <exit>

0000000000000226 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 22e:	00000097          	auipc	ra,0x0
 232:	f0e080e7          	jalr	-242(ra) # 13c <main>
  exit(0);
 236:	4501                	li	a0,0
 238:	00000097          	auipc	ra,0x0
 23c:	49a080e7          	jalr	1178(ra) # 6d2 <exit>

0000000000000240 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 240:	7179                	addi	sp,sp,-48
 242:	f422                	sd	s0,40(sp)
 244:	1800                	addi	s0,sp,48
 246:	fca43c23          	sd	a0,-40(s0)
 24a:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 24e:	fd843783          	ld	a5,-40(s0)
 252:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 256:	0001                	nop
 258:	fd043703          	ld	a4,-48(s0)
 25c:	00170793          	addi	a5,a4,1
 260:	fcf43823          	sd	a5,-48(s0)
 264:	fd843783          	ld	a5,-40(s0)
 268:	00178693          	addi	a3,a5,1
 26c:	fcd43c23          	sd	a3,-40(s0)
 270:	00074703          	lbu	a4,0(a4)
 274:	00e78023          	sb	a4,0(a5)
 278:	0007c783          	lbu	a5,0(a5)
 27c:	fff1                	bnez	a5,258 <strcpy+0x18>
    ;
  return os;
 27e:	fe843783          	ld	a5,-24(s0)
}
 282:	853e                	mv	a0,a5
 284:	7422                	ld	s0,40(sp)
 286:	6145                	addi	sp,sp,48
 288:	8082                	ret

000000000000028a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28a:	1101                	addi	sp,sp,-32
 28c:	ec22                	sd	s0,24(sp)
 28e:	1000                	addi	s0,sp,32
 290:	fea43423          	sd	a0,-24(s0)
 294:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 298:	a819                	j	2ae <strcmp+0x24>
    p++, q++;
 29a:	fe843783          	ld	a5,-24(s0)
 29e:	0785                	addi	a5,a5,1
 2a0:	fef43423          	sd	a5,-24(s0)
 2a4:	fe043783          	ld	a5,-32(s0)
 2a8:	0785                	addi	a5,a5,1
 2aa:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 2ae:	fe843783          	ld	a5,-24(s0)
 2b2:	0007c783          	lbu	a5,0(a5)
 2b6:	cb99                	beqz	a5,2cc <strcmp+0x42>
 2b8:	fe843783          	ld	a5,-24(s0)
 2bc:	0007c703          	lbu	a4,0(a5)
 2c0:	fe043783          	ld	a5,-32(s0)
 2c4:	0007c783          	lbu	a5,0(a5)
 2c8:	fcf709e3          	beq	a4,a5,29a <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 2cc:	fe843783          	ld	a5,-24(s0)
 2d0:	0007c783          	lbu	a5,0(a5)
 2d4:	0007871b          	sext.w	a4,a5
 2d8:	fe043783          	ld	a5,-32(s0)
 2dc:	0007c783          	lbu	a5,0(a5)
 2e0:	2781                	sext.w	a5,a5
 2e2:	40f707bb          	subw	a5,a4,a5
 2e6:	2781                	sext.w	a5,a5
}
 2e8:	853e                	mv	a0,a5
 2ea:	6462                	ld	s0,24(sp)
 2ec:	6105                	addi	sp,sp,32
 2ee:	8082                	ret

00000000000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	7179                	addi	sp,sp,-48
 2f2:	f422                	sd	s0,40(sp)
 2f4:	1800                	addi	s0,sp,48
 2f6:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 2fa:	fe042623          	sw	zero,-20(s0)
 2fe:	a031                	j	30a <strlen+0x1a>
 300:	fec42783          	lw	a5,-20(s0)
 304:	2785                	addiw	a5,a5,1
 306:	fef42623          	sw	a5,-20(s0)
 30a:	fec42783          	lw	a5,-20(s0)
 30e:	fd843703          	ld	a4,-40(s0)
 312:	97ba                	add	a5,a5,a4
 314:	0007c783          	lbu	a5,0(a5)
 318:	f7e5                	bnez	a5,300 <strlen+0x10>
    ;
  return n;
 31a:	fec42783          	lw	a5,-20(s0)
}
 31e:	853e                	mv	a0,a5
 320:	7422                	ld	s0,40(sp)
 322:	6145                	addi	sp,sp,48
 324:	8082                	ret

0000000000000326 <memset>:

void*
memset(void *dst, int c, uint n)
{
 326:	7179                	addi	sp,sp,-48
 328:	f422                	sd	s0,40(sp)
 32a:	1800                	addi	s0,sp,48
 32c:	fca43c23          	sd	a0,-40(s0)
 330:	87ae                	mv	a5,a1
 332:	8732                	mv	a4,a2
 334:	fcf42a23          	sw	a5,-44(s0)
 338:	87ba                	mv	a5,a4
 33a:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 33e:	fd843783          	ld	a5,-40(s0)
 342:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 346:	fe042623          	sw	zero,-20(s0)
 34a:	a00d                	j	36c <memset+0x46>
    cdst[i] = c;
 34c:	fec42783          	lw	a5,-20(s0)
 350:	fe043703          	ld	a4,-32(s0)
 354:	97ba                	add	a5,a5,a4
 356:	fd442703          	lw	a4,-44(s0)
 35a:	0ff77713          	zext.b	a4,a4
 35e:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 362:	fec42783          	lw	a5,-20(s0)
 366:	2785                	addiw	a5,a5,1
 368:	fef42623          	sw	a5,-20(s0)
 36c:	fec42703          	lw	a4,-20(s0)
 370:	fd042783          	lw	a5,-48(s0)
 374:	2781                	sext.w	a5,a5
 376:	fcf76be3          	bltu	a4,a5,34c <memset+0x26>
  }
  return dst;
 37a:	fd843783          	ld	a5,-40(s0)
}
 37e:	853e                	mv	a0,a5
 380:	7422                	ld	s0,40(sp)
 382:	6145                	addi	sp,sp,48
 384:	8082                	ret

0000000000000386 <strchr>:

char*
strchr(const char *s, char c)
{
 386:	1101                	addi	sp,sp,-32
 388:	ec22                	sd	s0,24(sp)
 38a:	1000                	addi	s0,sp,32
 38c:	fea43423          	sd	a0,-24(s0)
 390:	87ae                	mv	a5,a1
 392:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 396:	a01d                	j	3bc <strchr+0x36>
    if(*s == c)
 398:	fe843783          	ld	a5,-24(s0)
 39c:	0007c703          	lbu	a4,0(a5)
 3a0:	fe744783          	lbu	a5,-25(s0)
 3a4:	0ff7f793          	zext.b	a5,a5
 3a8:	00e79563          	bne	a5,a4,3b2 <strchr+0x2c>
      return (char*)s;
 3ac:	fe843783          	ld	a5,-24(s0)
 3b0:	a821                	j	3c8 <strchr+0x42>
  for(; *s; s++)
 3b2:	fe843783          	ld	a5,-24(s0)
 3b6:	0785                	addi	a5,a5,1
 3b8:	fef43423          	sd	a5,-24(s0)
 3bc:	fe843783          	ld	a5,-24(s0)
 3c0:	0007c783          	lbu	a5,0(a5)
 3c4:	fbf1                	bnez	a5,398 <strchr+0x12>
  return 0;
 3c6:	4781                	li	a5,0
}
 3c8:	853e                	mv	a0,a5
 3ca:	6462                	ld	s0,24(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <gets>:

char*
gets(char *buf, int max)
{
 3d0:	7179                	addi	sp,sp,-48
 3d2:	f406                	sd	ra,40(sp)
 3d4:	f022                	sd	s0,32(sp)
 3d6:	1800                	addi	s0,sp,48
 3d8:	fca43c23          	sd	a0,-40(s0)
 3dc:	87ae                	mv	a5,a1
 3de:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e2:	fe042623          	sw	zero,-20(s0)
 3e6:	a8a1                	j	43e <gets+0x6e>
    cc = read(0, &c, 1);
 3e8:	fe740793          	addi	a5,s0,-25
 3ec:	4605                	li	a2,1
 3ee:	85be                	mv	a1,a5
 3f0:	4501                	li	a0,0
 3f2:	00000097          	auipc	ra,0x0
 3f6:	2f8080e7          	jalr	760(ra) # 6ea <read>
 3fa:	87aa                	mv	a5,a0
 3fc:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 400:	fe842783          	lw	a5,-24(s0)
 404:	2781                	sext.w	a5,a5
 406:	04f05763          	blez	a5,454 <gets+0x84>
      break;
    buf[i++] = c;
 40a:	fec42783          	lw	a5,-20(s0)
 40e:	0017871b          	addiw	a4,a5,1
 412:	fee42623          	sw	a4,-20(s0)
 416:	873e                	mv	a4,a5
 418:	fd843783          	ld	a5,-40(s0)
 41c:	97ba                	add	a5,a5,a4
 41e:	fe744703          	lbu	a4,-25(s0)
 422:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 426:	fe744783          	lbu	a5,-25(s0)
 42a:	873e                	mv	a4,a5
 42c:	47a9                	li	a5,10
 42e:	02f70463          	beq	a4,a5,456 <gets+0x86>
 432:	fe744783          	lbu	a5,-25(s0)
 436:	873e                	mv	a4,a5
 438:	47b5                	li	a5,13
 43a:	00f70e63          	beq	a4,a5,456 <gets+0x86>
  for(i=0; i+1 < max; ){
 43e:	fec42783          	lw	a5,-20(s0)
 442:	2785                	addiw	a5,a5,1
 444:	0007871b          	sext.w	a4,a5
 448:	fd442783          	lw	a5,-44(s0)
 44c:	2781                	sext.w	a5,a5
 44e:	f8f74de3          	blt	a4,a5,3e8 <gets+0x18>
 452:	a011                	j	456 <gets+0x86>
      break;
 454:	0001                	nop
      break;
  }
  buf[i] = '\0';
 456:	fec42783          	lw	a5,-20(s0)
 45a:	fd843703          	ld	a4,-40(s0)
 45e:	97ba                	add	a5,a5,a4
 460:	00078023          	sb	zero,0(a5)
  return buf;
 464:	fd843783          	ld	a5,-40(s0)
}
 468:	853e                	mv	a0,a5
 46a:	70a2                	ld	ra,40(sp)
 46c:	7402                	ld	s0,32(sp)
 46e:	6145                	addi	sp,sp,48
 470:	8082                	ret

0000000000000472 <stat>:

int
stat(const char *n, struct stat *st)
{
 472:	7179                	addi	sp,sp,-48
 474:	f406                	sd	ra,40(sp)
 476:	f022                	sd	s0,32(sp)
 478:	1800                	addi	s0,sp,48
 47a:	fca43c23          	sd	a0,-40(s0)
 47e:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 482:	4581                	li	a1,0
 484:	fd843503          	ld	a0,-40(s0)
 488:	00000097          	auipc	ra,0x0
 48c:	28a080e7          	jalr	650(ra) # 712 <open>
 490:	87aa                	mv	a5,a0
 492:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 496:	fec42783          	lw	a5,-20(s0)
 49a:	2781                	sext.w	a5,a5
 49c:	0007d463          	bgez	a5,4a4 <stat+0x32>
    return -1;
 4a0:	57fd                	li	a5,-1
 4a2:	a035                	j	4ce <stat+0x5c>
  r = fstat(fd, st);
 4a4:	fec42783          	lw	a5,-20(s0)
 4a8:	fd043583          	ld	a1,-48(s0)
 4ac:	853e                	mv	a0,a5
 4ae:	00000097          	auipc	ra,0x0
 4b2:	27c080e7          	jalr	636(ra) # 72a <fstat>
 4b6:	87aa                	mv	a5,a0
 4b8:	fef42423          	sw	a5,-24(s0)
  close(fd);
 4bc:	fec42783          	lw	a5,-20(s0)
 4c0:	853e                	mv	a0,a5
 4c2:	00000097          	auipc	ra,0x0
 4c6:	238080e7          	jalr	568(ra) # 6fa <close>
  return r;
 4ca:	fe842783          	lw	a5,-24(s0)
}
 4ce:	853e                	mv	a0,a5
 4d0:	70a2                	ld	ra,40(sp)
 4d2:	7402                	ld	s0,32(sp)
 4d4:	6145                	addi	sp,sp,48
 4d6:	8082                	ret

00000000000004d8 <atoi>:

int
atoi(const char *s)
{
 4d8:	7179                	addi	sp,sp,-48
 4da:	f422                	sd	s0,40(sp)
 4dc:	1800                	addi	s0,sp,48
 4de:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 4e2:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 4e6:	a81d                	j	51c <atoi+0x44>
    n = n*10 + *s++ - '0';
 4e8:	fec42783          	lw	a5,-20(s0)
 4ec:	873e                	mv	a4,a5
 4ee:	87ba                	mv	a5,a4
 4f0:	0027979b          	slliw	a5,a5,0x2
 4f4:	9fb9                	addw	a5,a5,a4
 4f6:	0017979b          	slliw	a5,a5,0x1
 4fa:	0007871b          	sext.w	a4,a5
 4fe:	fd843783          	ld	a5,-40(s0)
 502:	00178693          	addi	a3,a5,1
 506:	fcd43c23          	sd	a3,-40(s0)
 50a:	0007c783          	lbu	a5,0(a5)
 50e:	2781                	sext.w	a5,a5
 510:	9fb9                	addw	a5,a5,a4
 512:	2781                	sext.w	a5,a5
 514:	fd07879b          	addiw	a5,a5,-48
 518:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 51c:	fd843783          	ld	a5,-40(s0)
 520:	0007c783          	lbu	a5,0(a5)
 524:	873e                	mv	a4,a5
 526:	02f00793          	li	a5,47
 52a:	00e7fb63          	bgeu	a5,a4,540 <atoi+0x68>
 52e:	fd843783          	ld	a5,-40(s0)
 532:	0007c783          	lbu	a5,0(a5)
 536:	873e                	mv	a4,a5
 538:	03900793          	li	a5,57
 53c:	fae7f6e3          	bgeu	a5,a4,4e8 <atoi+0x10>
  return n;
 540:	fec42783          	lw	a5,-20(s0)
}
 544:	853e                	mv	a0,a5
 546:	7422                	ld	s0,40(sp)
 548:	6145                	addi	sp,sp,48
 54a:	8082                	ret

000000000000054c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 54c:	7139                	addi	sp,sp,-64
 54e:	fc22                	sd	s0,56(sp)
 550:	0080                	addi	s0,sp,64
 552:	fca43c23          	sd	a0,-40(s0)
 556:	fcb43823          	sd	a1,-48(s0)
 55a:	87b2                	mv	a5,a2
 55c:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 560:	fd843783          	ld	a5,-40(s0)
 564:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 568:	fd043783          	ld	a5,-48(s0)
 56c:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 570:	fe043703          	ld	a4,-32(s0)
 574:	fe843783          	ld	a5,-24(s0)
 578:	02e7fc63          	bgeu	a5,a4,5b0 <memmove+0x64>
    while(n-- > 0)
 57c:	a00d                	j	59e <memmove+0x52>
      *dst++ = *src++;
 57e:	fe043703          	ld	a4,-32(s0)
 582:	00170793          	addi	a5,a4,1
 586:	fef43023          	sd	a5,-32(s0)
 58a:	fe843783          	ld	a5,-24(s0)
 58e:	00178693          	addi	a3,a5,1
 592:	fed43423          	sd	a3,-24(s0)
 596:	00074703          	lbu	a4,0(a4)
 59a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 59e:	fcc42783          	lw	a5,-52(s0)
 5a2:	fff7871b          	addiw	a4,a5,-1
 5a6:	fce42623          	sw	a4,-52(s0)
 5aa:	fcf04ae3          	bgtz	a5,57e <memmove+0x32>
 5ae:	a891                	j	602 <memmove+0xb6>
  } else {
    dst += n;
 5b0:	fcc42783          	lw	a5,-52(s0)
 5b4:	fe843703          	ld	a4,-24(s0)
 5b8:	97ba                	add	a5,a5,a4
 5ba:	fef43423          	sd	a5,-24(s0)
    src += n;
 5be:	fcc42783          	lw	a5,-52(s0)
 5c2:	fe043703          	ld	a4,-32(s0)
 5c6:	97ba                	add	a5,a5,a4
 5c8:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 5cc:	a01d                	j	5f2 <memmove+0xa6>
      *--dst = *--src;
 5ce:	fe043783          	ld	a5,-32(s0)
 5d2:	17fd                	addi	a5,a5,-1
 5d4:	fef43023          	sd	a5,-32(s0)
 5d8:	fe843783          	ld	a5,-24(s0)
 5dc:	17fd                	addi	a5,a5,-1
 5de:	fef43423          	sd	a5,-24(s0)
 5e2:	fe043783          	ld	a5,-32(s0)
 5e6:	0007c703          	lbu	a4,0(a5)
 5ea:	fe843783          	ld	a5,-24(s0)
 5ee:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 5f2:	fcc42783          	lw	a5,-52(s0)
 5f6:	fff7871b          	addiw	a4,a5,-1
 5fa:	fce42623          	sw	a4,-52(s0)
 5fe:	fcf048e3          	bgtz	a5,5ce <memmove+0x82>
  }
  return vdst;
 602:	fd843783          	ld	a5,-40(s0)
}
 606:	853e                	mv	a0,a5
 608:	7462                	ld	s0,56(sp)
 60a:	6121                	addi	sp,sp,64
 60c:	8082                	ret

000000000000060e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 60e:	7139                	addi	sp,sp,-64
 610:	fc22                	sd	s0,56(sp)
 612:	0080                	addi	s0,sp,64
 614:	fca43c23          	sd	a0,-40(s0)
 618:	fcb43823          	sd	a1,-48(s0)
 61c:	87b2                	mv	a5,a2
 61e:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 622:	fd843783          	ld	a5,-40(s0)
 626:	fef43423          	sd	a5,-24(s0)
 62a:	fd043783          	ld	a5,-48(s0)
 62e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 632:	a0a1                	j	67a <memcmp+0x6c>
    if (*p1 != *p2) {
 634:	fe843783          	ld	a5,-24(s0)
 638:	0007c703          	lbu	a4,0(a5)
 63c:	fe043783          	ld	a5,-32(s0)
 640:	0007c783          	lbu	a5,0(a5)
 644:	02f70163          	beq	a4,a5,666 <memcmp+0x58>
      return *p1 - *p2;
 648:	fe843783          	ld	a5,-24(s0)
 64c:	0007c783          	lbu	a5,0(a5)
 650:	0007871b          	sext.w	a4,a5
 654:	fe043783          	ld	a5,-32(s0)
 658:	0007c783          	lbu	a5,0(a5)
 65c:	2781                	sext.w	a5,a5
 65e:	40f707bb          	subw	a5,a4,a5
 662:	2781                	sext.w	a5,a5
 664:	a01d                	j	68a <memcmp+0x7c>
    }
    p1++;
 666:	fe843783          	ld	a5,-24(s0)
 66a:	0785                	addi	a5,a5,1
 66c:	fef43423          	sd	a5,-24(s0)
    p2++;
 670:	fe043783          	ld	a5,-32(s0)
 674:	0785                	addi	a5,a5,1
 676:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 67a:	fcc42783          	lw	a5,-52(s0)
 67e:	fff7871b          	addiw	a4,a5,-1
 682:	fce42623          	sw	a4,-52(s0)
 686:	f7dd                	bnez	a5,634 <memcmp+0x26>
  }
  return 0;
 688:	4781                	li	a5,0
}
 68a:	853e                	mv	a0,a5
 68c:	7462                	ld	s0,56(sp)
 68e:	6121                	addi	sp,sp,64
 690:	8082                	ret

0000000000000692 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 692:	7179                	addi	sp,sp,-48
 694:	f406                	sd	ra,40(sp)
 696:	f022                	sd	s0,32(sp)
 698:	1800                	addi	s0,sp,48
 69a:	fea43423          	sd	a0,-24(s0)
 69e:	feb43023          	sd	a1,-32(s0)
 6a2:	87b2                	mv	a5,a2
 6a4:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 6a8:	fdc42783          	lw	a5,-36(s0)
 6ac:	863e                	mv	a2,a5
 6ae:	fe043583          	ld	a1,-32(s0)
 6b2:	fe843503          	ld	a0,-24(s0)
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e96080e7          	jalr	-362(ra) # 54c <memmove>
 6be:	87aa                	mv	a5,a0
}
 6c0:	853e                	mv	a0,a5
 6c2:	70a2                	ld	ra,40(sp)
 6c4:	7402                	ld	s0,32(sp)
 6c6:	6145                	addi	sp,sp,48
 6c8:	8082                	ret

00000000000006ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ca:	4885                	li	a7,1
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6d2:	4889                	li	a7,2
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <wait>:
.global wait
wait:
 li a7, SYS_wait
 6da:	488d                	li	a7,3
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6e2:	4891                	li	a7,4
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <read>:
.global read
read:
 li a7, SYS_read
 6ea:	4895                	li	a7,5
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <write>:
.global write
write:
 li a7, SYS_write
 6f2:	48c1                	li	a7,16
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <close>:
.global close
close:
 li a7, SYS_close
 6fa:	48d5                	li	a7,21
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <kill>:
.global kill
kill:
 li a7, SYS_kill
 702:	4899                	li	a7,6
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <exec>:
.global exec
exec:
 li a7, SYS_exec
 70a:	489d                	li	a7,7
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <open>:
.global open
open:
 li a7, SYS_open
 712:	48bd                	li	a7,15
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 71a:	48c5                	li	a7,17
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 722:	48c9                	li	a7,18
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 72a:	48a1                	li	a7,8
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <link>:
.global link
link:
 li a7, SYS_link
 732:	48cd                	li	a7,19
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 73a:	48d1                	li	a7,20
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 742:	48a5                	li	a7,9
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <dup>:
.global dup
dup:
 li a7, SYS_dup
 74a:	48a9                	li	a7,10
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 752:	48ad                	li	a7,11
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 75a:	48b1                	li	a7,12
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 762:	48b5                	li	a7,13
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 76a:	48b9                	li	a7,14
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <hello>:
.global hello
hello:
 li a7, SYS_hello
 772:	48d9                	li	a7,22
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 77a:	48dd                	li	a7,23
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 782:	1101                	addi	sp,sp,-32
 784:	ec06                	sd	ra,24(sp)
 786:	e822                	sd	s0,16(sp)
 788:	1000                	addi	s0,sp,32
 78a:	87aa                	mv	a5,a0
 78c:	872e                	mv	a4,a1
 78e:	fef42623          	sw	a5,-20(s0)
 792:	87ba                	mv	a5,a4
 794:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 798:	feb40713          	addi	a4,s0,-21
 79c:	fec42783          	lw	a5,-20(s0)
 7a0:	4605                	li	a2,1
 7a2:	85ba                	mv	a1,a4
 7a4:	853e                	mv	a0,a5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	f4c080e7          	jalr	-180(ra) # 6f2 <write>
}
 7ae:	0001                	nop
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6105                	addi	sp,sp,32
 7b6:	8082                	ret

00000000000007b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b8:	7139                	addi	sp,sp,-64
 7ba:	fc06                	sd	ra,56(sp)
 7bc:	f822                	sd	s0,48(sp)
 7be:	0080                	addi	s0,sp,64
 7c0:	87aa                	mv	a5,a0
 7c2:	8736                	mv	a4,a3
 7c4:	fcf42623          	sw	a5,-52(s0)
 7c8:	87ae                	mv	a5,a1
 7ca:	fcf42423          	sw	a5,-56(s0)
 7ce:	87b2                	mv	a5,a2
 7d0:	fcf42223          	sw	a5,-60(s0)
 7d4:	87ba                	mv	a5,a4
 7d6:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7da:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 7de:	fc042783          	lw	a5,-64(s0)
 7e2:	2781                	sext.w	a5,a5
 7e4:	c38d                	beqz	a5,806 <printint+0x4e>
 7e6:	fc842783          	lw	a5,-56(s0)
 7ea:	2781                	sext.w	a5,a5
 7ec:	0007dd63          	bgez	a5,806 <printint+0x4e>
    neg = 1;
 7f0:	4785                	li	a5,1
 7f2:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 7f6:	fc842783          	lw	a5,-56(s0)
 7fa:	40f007bb          	negw	a5,a5
 7fe:	2781                	sext.w	a5,a5
 800:	fef42223          	sw	a5,-28(s0)
 804:	a029                	j	80e <printint+0x56>
  } else {
    x = xx;
 806:	fc842783          	lw	a5,-56(s0)
 80a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 80e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 812:	fc442783          	lw	a5,-60(s0)
 816:	fe442703          	lw	a4,-28(s0)
 81a:	02f777bb          	remuw	a5,a4,a5
 81e:	0007861b          	sext.w	a2,a5
 822:	fec42783          	lw	a5,-20(s0)
 826:	0017871b          	addiw	a4,a5,1
 82a:	fee42623          	sw	a4,-20(s0)
 82e:	00001697          	auipc	a3,0x1
 832:	b6268693          	addi	a3,a3,-1182 # 1390 <digits>
 836:	02061713          	slli	a4,a2,0x20
 83a:	9301                	srli	a4,a4,0x20
 83c:	9736                	add	a4,a4,a3
 83e:	00074703          	lbu	a4,0(a4)
 842:	17c1                	addi	a5,a5,-16
 844:	97a2                	add	a5,a5,s0
 846:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 84a:	fc442783          	lw	a5,-60(s0)
 84e:	fe442703          	lw	a4,-28(s0)
 852:	02f757bb          	divuw	a5,a4,a5
 856:	fef42223          	sw	a5,-28(s0)
 85a:	fe442783          	lw	a5,-28(s0)
 85e:	2781                	sext.w	a5,a5
 860:	fbcd                	bnez	a5,812 <printint+0x5a>
  if(neg)
 862:	fe842783          	lw	a5,-24(s0)
 866:	2781                	sext.w	a5,a5
 868:	cf85                	beqz	a5,8a0 <printint+0xe8>
    buf[i++] = '-';
 86a:	fec42783          	lw	a5,-20(s0)
 86e:	0017871b          	addiw	a4,a5,1
 872:	fee42623          	sw	a4,-20(s0)
 876:	17c1                	addi	a5,a5,-16
 878:	97a2                	add	a5,a5,s0
 87a:	02d00713          	li	a4,45
 87e:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 882:	a839                	j	8a0 <printint+0xe8>
    putc(fd, buf[i]);
 884:	fec42783          	lw	a5,-20(s0)
 888:	17c1                	addi	a5,a5,-16
 88a:	97a2                	add	a5,a5,s0
 88c:	fe07c703          	lbu	a4,-32(a5)
 890:	fcc42783          	lw	a5,-52(s0)
 894:	85ba                	mv	a1,a4
 896:	853e                	mv	a0,a5
 898:	00000097          	auipc	ra,0x0
 89c:	eea080e7          	jalr	-278(ra) # 782 <putc>
  while(--i >= 0)
 8a0:	fec42783          	lw	a5,-20(s0)
 8a4:	37fd                	addiw	a5,a5,-1
 8a6:	fef42623          	sw	a5,-20(s0)
 8aa:	fec42783          	lw	a5,-20(s0)
 8ae:	2781                	sext.w	a5,a5
 8b0:	fc07dae3          	bgez	a5,884 <printint+0xcc>
}
 8b4:	0001                	nop
 8b6:	0001                	nop
 8b8:	70e2                	ld	ra,56(sp)
 8ba:	7442                	ld	s0,48(sp)
 8bc:	6121                	addi	sp,sp,64
 8be:	8082                	ret

00000000000008c0 <printptr>:

static void
printptr(int fd, uint64 x) {
 8c0:	7179                	addi	sp,sp,-48
 8c2:	f406                	sd	ra,40(sp)
 8c4:	f022                	sd	s0,32(sp)
 8c6:	1800                	addi	s0,sp,48
 8c8:	87aa                	mv	a5,a0
 8ca:	fcb43823          	sd	a1,-48(s0)
 8ce:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 8d2:	fdc42783          	lw	a5,-36(s0)
 8d6:	03000593          	li	a1,48
 8da:	853e                	mv	a0,a5
 8dc:	00000097          	auipc	ra,0x0
 8e0:	ea6080e7          	jalr	-346(ra) # 782 <putc>
  putc(fd, 'x');
 8e4:	fdc42783          	lw	a5,-36(s0)
 8e8:	07800593          	li	a1,120
 8ec:	853e                	mv	a0,a5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e94080e7          	jalr	-364(ra) # 782 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8f6:	fe042623          	sw	zero,-20(s0)
 8fa:	a82d                	j	934 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8fc:	fd043783          	ld	a5,-48(s0)
 900:	93f1                	srli	a5,a5,0x3c
 902:	00001717          	auipc	a4,0x1
 906:	a8e70713          	addi	a4,a4,-1394 # 1390 <digits>
 90a:	97ba                	add	a5,a5,a4
 90c:	0007c703          	lbu	a4,0(a5)
 910:	fdc42783          	lw	a5,-36(s0)
 914:	85ba                	mv	a1,a4
 916:	853e                	mv	a0,a5
 918:	00000097          	auipc	ra,0x0
 91c:	e6a080e7          	jalr	-406(ra) # 782 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 920:	fec42783          	lw	a5,-20(s0)
 924:	2785                	addiw	a5,a5,1
 926:	fef42623          	sw	a5,-20(s0)
 92a:	fd043783          	ld	a5,-48(s0)
 92e:	0792                	slli	a5,a5,0x4
 930:	fcf43823          	sd	a5,-48(s0)
 934:	fec42783          	lw	a5,-20(s0)
 938:	873e                	mv	a4,a5
 93a:	47bd                	li	a5,15
 93c:	fce7f0e3          	bgeu	a5,a4,8fc <printptr+0x3c>
}
 940:	0001                	nop
 942:	0001                	nop
 944:	70a2                	ld	ra,40(sp)
 946:	7402                	ld	s0,32(sp)
 948:	6145                	addi	sp,sp,48
 94a:	8082                	ret

000000000000094c <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 94c:	715d                	addi	sp,sp,-80
 94e:	e486                	sd	ra,72(sp)
 950:	e0a2                	sd	s0,64(sp)
 952:	0880                	addi	s0,sp,80
 954:	87aa                	mv	a5,a0
 956:	fcb43023          	sd	a1,-64(s0)
 95a:	fac43c23          	sd	a2,-72(s0)
 95e:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 962:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 966:	fe042223          	sw	zero,-28(s0)
 96a:	a42d                	j	b94 <vprintf+0x248>
    c = fmt[i] & 0xff;
 96c:	fe442783          	lw	a5,-28(s0)
 970:	fc043703          	ld	a4,-64(s0)
 974:	97ba                	add	a5,a5,a4
 976:	0007c783          	lbu	a5,0(a5)
 97a:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 97e:	fe042783          	lw	a5,-32(s0)
 982:	2781                	sext.w	a5,a5
 984:	eb9d                	bnez	a5,9ba <vprintf+0x6e>
      if(c == '%'){
 986:	fdc42783          	lw	a5,-36(s0)
 98a:	0007871b          	sext.w	a4,a5
 98e:	02500793          	li	a5,37
 992:	00f71763          	bne	a4,a5,9a0 <vprintf+0x54>
        state = '%';
 996:	02500793          	li	a5,37
 99a:	fef42023          	sw	a5,-32(s0)
 99e:	a2f5                	j	b8a <vprintf+0x23e>
      } else {
        putc(fd, c);
 9a0:	fdc42783          	lw	a5,-36(s0)
 9a4:	0ff7f713          	zext.b	a4,a5
 9a8:	fcc42783          	lw	a5,-52(s0)
 9ac:	85ba                	mv	a1,a4
 9ae:	853e                	mv	a0,a5
 9b0:	00000097          	auipc	ra,0x0
 9b4:	dd2080e7          	jalr	-558(ra) # 782 <putc>
 9b8:	aac9                	j	b8a <vprintf+0x23e>
      }
    } else if(state == '%'){
 9ba:	fe042783          	lw	a5,-32(s0)
 9be:	0007871b          	sext.w	a4,a5
 9c2:	02500793          	li	a5,37
 9c6:	1cf71263          	bne	a4,a5,b8a <vprintf+0x23e>
      if(c == 'd'){
 9ca:	fdc42783          	lw	a5,-36(s0)
 9ce:	0007871b          	sext.w	a4,a5
 9d2:	06400793          	li	a5,100
 9d6:	02f71463          	bne	a4,a5,9fe <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 9da:	fb843783          	ld	a5,-72(s0)
 9de:	00878713          	addi	a4,a5,8
 9e2:	fae43c23          	sd	a4,-72(s0)
 9e6:	4398                	lw	a4,0(a5)
 9e8:	fcc42783          	lw	a5,-52(s0)
 9ec:	4685                	li	a3,1
 9ee:	4629                	li	a2,10
 9f0:	85ba                	mv	a1,a4
 9f2:	853e                	mv	a0,a5
 9f4:	00000097          	auipc	ra,0x0
 9f8:	dc4080e7          	jalr	-572(ra) # 7b8 <printint>
 9fc:	a269                	j	b86 <vprintf+0x23a>
      } else if(c == 'l') {
 9fe:	fdc42783          	lw	a5,-36(s0)
 a02:	0007871b          	sext.w	a4,a5
 a06:	06c00793          	li	a5,108
 a0a:	02f71663          	bne	a4,a5,a36 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a0e:	fb843783          	ld	a5,-72(s0)
 a12:	00878713          	addi	a4,a5,8
 a16:	fae43c23          	sd	a4,-72(s0)
 a1a:	639c                	ld	a5,0(a5)
 a1c:	0007871b          	sext.w	a4,a5
 a20:	fcc42783          	lw	a5,-52(s0)
 a24:	4681                	li	a3,0
 a26:	4629                	li	a2,10
 a28:	85ba                	mv	a1,a4
 a2a:	853e                	mv	a0,a5
 a2c:	00000097          	auipc	ra,0x0
 a30:	d8c080e7          	jalr	-628(ra) # 7b8 <printint>
 a34:	aa89                	j	b86 <vprintf+0x23a>
      } else if(c == 'x') {
 a36:	fdc42783          	lw	a5,-36(s0)
 a3a:	0007871b          	sext.w	a4,a5
 a3e:	07800793          	li	a5,120
 a42:	02f71463          	bne	a4,a5,a6a <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 a46:	fb843783          	ld	a5,-72(s0)
 a4a:	00878713          	addi	a4,a5,8
 a4e:	fae43c23          	sd	a4,-72(s0)
 a52:	4398                	lw	a4,0(a5)
 a54:	fcc42783          	lw	a5,-52(s0)
 a58:	4681                	li	a3,0
 a5a:	4641                	li	a2,16
 a5c:	85ba                	mv	a1,a4
 a5e:	853e                	mv	a0,a5
 a60:	00000097          	auipc	ra,0x0
 a64:	d58080e7          	jalr	-680(ra) # 7b8 <printint>
 a68:	aa39                	j	b86 <vprintf+0x23a>
      } else if(c == 'p') {
 a6a:	fdc42783          	lw	a5,-36(s0)
 a6e:	0007871b          	sext.w	a4,a5
 a72:	07000793          	li	a5,112
 a76:	02f71263          	bne	a4,a5,a9a <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 a7a:	fb843783          	ld	a5,-72(s0)
 a7e:	00878713          	addi	a4,a5,8
 a82:	fae43c23          	sd	a4,-72(s0)
 a86:	6398                	ld	a4,0(a5)
 a88:	fcc42783          	lw	a5,-52(s0)
 a8c:	85ba                	mv	a1,a4
 a8e:	853e                	mv	a0,a5
 a90:	00000097          	auipc	ra,0x0
 a94:	e30080e7          	jalr	-464(ra) # 8c0 <printptr>
 a98:	a0fd                	j	b86 <vprintf+0x23a>
      } else if(c == 's'){
 a9a:	fdc42783          	lw	a5,-36(s0)
 a9e:	0007871b          	sext.w	a4,a5
 aa2:	07300793          	li	a5,115
 aa6:	04f71c63          	bne	a4,a5,afe <vprintf+0x1b2>
        s = va_arg(ap, char*);
 aaa:	fb843783          	ld	a5,-72(s0)
 aae:	00878713          	addi	a4,a5,8
 ab2:	fae43c23          	sd	a4,-72(s0)
 ab6:	639c                	ld	a5,0(a5)
 ab8:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 abc:	fe843783          	ld	a5,-24(s0)
 ac0:	eb8d                	bnez	a5,af2 <vprintf+0x1a6>
          s = "(null)";
 ac2:	00000797          	auipc	a5,0x0
 ac6:	4c678793          	addi	a5,a5,1222 # f88 <malloc+0x18c>
 aca:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 ace:	a015                	j	af2 <vprintf+0x1a6>
          putc(fd, *s);
 ad0:	fe843783          	ld	a5,-24(s0)
 ad4:	0007c703          	lbu	a4,0(a5)
 ad8:	fcc42783          	lw	a5,-52(s0)
 adc:	85ba                	mv	a1,a4
 ade:	853e                	mv	a0,a5
 ae0:	00000097          	auipc	ra,0x0
 ae4:	ca2080e7          	jalr	-862(ra) # 782 <putc>
          s++;
 ae8:	fe843783          	ld	a5,-24(s0)
 aec:	0785                	addi	a5,a5,1
 aee:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 af2:	fe843783          	ld	a5,-24(s0)
 af6:	0007c783          	lbu	a5,0(a5)
 afa:	fbf9                	bnez	a5,ad0 <vprintf+0x184>
 afc:	a069                	j	b86 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 afe:	fdc42783          	lw	a5,-36(s0)
 b02:	0007871b          	sext.w	a4,a5
 b06:	06300793          	li	a5,99
 b0a:	02f71463          	bne	a4,a5,b32 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 b0e:	fb843783          	ld	a5,-72(s0)
 b12:	00878713          	addi	a4,a5,8
 b16:	fae43c23          	sd	a4,-72(s0)
 b1a:	439c                	lw	a5,0(a5)
 b1c:	0ff7f713          	zext.b	a4,a5
 b20:	fcc42783          	lw	a5,-52(s0)
 b24:	85ba                	mv	a1,a4
 b26:	853e                	mv	a0,a5
 b28:	00000097          	auipc	ra,0x0
 b2c:	c5a080e7          	jalr	-934(ra) # 782 <putc>
 b30:	a899                	j	b86 <vprintf+0x23a>
      } else if(c == '%'){
 b32:	fdc42783          	lw	a5,-36(s0)
 b36:	0007871b          	sext.w	a4,a5
 b3a:	02500793          	li	a5,37
 b3e:	00f71f63          	bne	a4,a5,b5c <vprintf+0x210>
        putc(fd, c);
 b42:	fdc42783          	lw	a5,-36(s0)
 b46:	0ff7f713          	zext.b	a4,a5
 b4a:	fcc42783          	lw	a5,-52(s0)
 b4e:	85ba                	mv	a1,a4
 b50:	853e                	mv	a0,a5
 b52:	00000097          	auipc	ra,0x0
 b56:	c30080e7          	jalr	-976(ra) # 782 <putc>
 b5a:	a035                	j	b86 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b5c:	fcc42783          	lw	a5,-52(s0)
 b60:	02500593          	li	a1,37
 b64:	853e                	mv	a0,a5
 b66:	00000097          	auipc	ra,0x0
 b6a:	c1c080e7          	jalr	-996(ra) # 782 <putc>
        putc(fd, c);
 b6e:	fdc42783          	lw	a5,-36(s0)
 b72:	0ff7f713          	zext.b	a4,a5
 b76:	fcc42783          	lw	a5,-52(s0)
 b7a:	85ba                	mv	a1,a4
 b7c:	853e                	mv	a0,a5
 b7e:	00000097          	auipc	ra,0x0
 b82:	c04080e7          	jalr	-1020(ra) # 782 <putc>
      }
      state = 0;
 b86:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 b8a:	fe442783          	lw	a5,-28(s0)
 b8e:	2785                	addiw	a5,a5,1
 b90:	fef42223          	sw	a5,-28(s0)
 b94:	fe442783          	lw	a5,-28(s0)
 b98:	fc043703          	ld	a4,-64(s0)
 b9c:	97ba                	add	a5,a5,a4
 b9e:	0007c783          	lbu	a5,0(a5)
 ba2:	dc0795e3          	bnez	a5,96c <vprintf+0x20>
    }
  }
}
 ba6:	0001                	nop
 ba8:	0001                	nop
 baa:	60a6                	ld	ra,72(sp)
 bac:	6406                	ld	s0,64(sp)
 bae:	6161                	addi	sp,sp,80
 bb0:	8082                	ret

0000000000000bb2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bb2:	7159                	addi	sp,sp,-112
 bb4:	fc06                	sd	ra,56(sp)
 bb6:	f822                	sd	s0,48(sp)
 bb8:	0080                	addi	s0,sp,64
 bba:	fcb43823          	sd	a1,-48(s0)
 bbe:	e010                	sd	a2,0(s0)
 bc0:	e414                	sd	a3,8(s0)
 bc2:	e818                	sd	a4,16(s0)
 bc4:	ec1c                	sd	a5,24(s0)
 bc6:	03043023          	sd	a6,32(s0)
 bca:	03143423          	sd	a7,40(s0)
 bce:	87aa                	mv	a5,a0
 bd0:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 bd4:	03040793          	addi	a5,s0,48
 bd8:	fcf43423          	sd	a5,-56(s0)
 bdc:	fc843783          	ld	a5,-56(s0)
 be0:	fd078793          	addi	a5,a5,-48
 be4:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 be8:	fe843703          	ld	a4,-24(s0)
 bec:	fdc42783          	lw	a5,-36(s0)
 bf0:	863a                	mv	a2,a4
 bf2:	fd043583          	ld	a1,-48(s0)
 bf6:	853e                	mv	a0,a5
 bf8:	00000097          	auipc	ra,0x0
 bfc:	d54080e7          	jalr	-684(ra) # 94c <vprintf>
}
 c00:	0001                	nop
 c02:	70e2                	ld	ra,56(sp)
 c04:	7442                	ld	s0,48(sp)
 c06:	6165                	addi	sp,sp,112
 c08:	8082                	ret

0000000000000c0a <printf>:

void
printf(const char *fmt, ...)
{
 c0a:	7159                	addi	sp,sp,-112
 c0c:	f406                	sd	ra,40(sp)
 c0e:	f022                	sd	s0,32(sp)
 c10:	1800                	addi	s0,sp,48
 c12:	fca43c23          	sd	a0,-40(s0)
 c16:	e40c                	sd	a1,8(s0)
 c18:	e810                	sd	a2,16(s0)
 c1a:	ec14                	sd	a3,24(s0)
 c1c:	f018                	sd	a4,32(s0)
 c1e:	f41c                	sd	a5,40(s0)
 c20:	03043823          	sd	a6,48(s0)
 c24:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c28:	04040793          	addi	a5,s0,64
 c2c:	fcf43823          	sd	a5,-48(s0)
 c30:	fd043783          	ld	a5,-48(s0)
 c34:	fc878793          	addi	a5,a5,-56
 c38:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 c3c:	fe843783          	ld	a5,-24(s0)
 c40:	863e                	mv	a2,a5
 c42:	fd843583          	ld	a1,-40(s0)
 c46:	4505                	li	a0,1
 c48:	00000097          	auipc	ra,0x0
 c4c:	d04080e7          	jalr	-764(ra) # 94c <vprintf>
}
 c50:	0001                	nop
 c52:	70a2                	ld	ra,40(sp)
 c54:	7402                	ld	s0,32(sp)
 c56:	6165                	addi	sp,sp,112
 c58:	8082                	ret

0000000000000c5a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c5a:	7179                	addi	sp,sp,-48
 c5c:	f422                	sd	s0,40(sp)
 c5e:	1800                	addi	s0,sp,48
 c60:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c64:	fd843783          	ld	a5,-40(s0)
 c68:	17c1                	addi	a5,a5,-16
 c6a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c6e:	00001797          	auipc	a5,0x1
 c72:	95278793          	addi	a5,a5,-1710 # 15c0 <freep>
 c76:	639c                	ld	a5,0(a5)
 c78:	fef43423          	sd	a5,-24(s0)
 c7c:	a815                	j	cb0 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c7e:	fe843783          	ld	a5,-24(s0)
 c82:	639c                	ld	a5,0(a5)
 c84:	fe843703          	ld	a4,-24(s0)
 c88:	00f76f63          	bltu	a4,a5,ca6 <free+0x4c>
 c8c:	fe043703          	ld	a4,-32(s0)
 c90:	fe843783          	ld	a5,-24(s0)
 c94:	02e7eb63          	bltu	a5,a4,cca <free+0x70>
 c98:	fe843783          	ld	a5,-24(s0)
 c9c:	639c                	ld	a5,0(a5)
 c9e:	fe043703          	ld	a4,-32(s0)
 ca2:	02f76463          	bltu	a4,a5,cca <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ca6:	fe843783          	ld	a5,-24(s0)
 caa:	639c                	ld	a5,0(a5)
 cac:	fef43423          	sd	a5,-24(s0)
 cb0:	fe043703          	ld	a4,-32(s0)
 cb4:	fe843783          	ld	a5,-24(s0)
 cb8:	fce7f3e3          	bgeu	a5,a4,c7e <free+0x24>
 cbc:	fe843783          	ld	a5,-24(s0)
 cc0:	639c                	ld	a5,0(a5)
 cc2:	fe043703          	ld	a4,-32(s0)
 cc6:	faf77ce3          	bgeu	a4,a5,c7e <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cca:	fe043783          	ld	a5,-32(s0)
 cce:	479c                	lw	a5,8(a5)
 cd0:	1782                	slli	a5,a5,0x20
 cd2:	9381                	srli	a5,a5,0x20
 cd4:	0792                	slli	a5,a5,0x4
 cd6:	fe043703          	ld	a4,-32(s0)
 cda:	973e                	add	a4,a4,a5
 cdc:	fe843783          	ld	a5,-24(s0)
 ce0:	639c                	ld	a5,0(a5)
 ce2:	02f71763          	bne	a4,a5,d10 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 ce6:	fe043783          	ld	a5,-32(s0)
 cea:	4798                	lw	a4,8(a5)
 cec:	fe843783          	ld	a5,-24(s0)
 cf0:	639c                	ld	a5,0(a5)
 cf2:	479c                	lw	a5,8(a5)
 cf4:	9fb9                	addw	a5,a5,a4
 cf6:	0007871b          	sext.w	a4,a5
 cfa:	fe043783          	ld	a5,-32(s0)
 cfe:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 d00:	fe843783          	ld	a5,-24(s0)
 d04:	639c                	ld	a5,0(a5)
 d06:	6398                	ld	a4,0(a5)
 d08:	fe043783          	ld	a5,-32(s0)
 d0c:	e398                	sd	a4,0(a5)
 d0e:	a039                	j	d1c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 d10:	fe843783          	ld	a5,-24(s0)
 d14:	6398                	ld	a4,0(a5)
 d16:	fe043783          	ld	a5,-32(s0)
 d1a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 d1c:	fe843783          	ld	a5,-24(s0)
 d20:	479c                	lw	a5,8(a5)
 d22:	1782                	slli	a5,a5,0x20
 d24:	9381                	srli	a5,a5,0x20
 d26:	0792                	slli	a5,a5,0x4
 d28:	fe843703          	ld	a4,-24(s0)
 d2c:	97ba                	add	a5,a5,a4
 d2e:	fe043703          	ld	a4,-32(s0)
 d32:	02f71563          	bne	a4,a5,d5c <free+0x102>
    p->s.size += bp->s.size;
 d36:	fe843783          	ld	a5,-24(s0)
 d3a:	4798                	lw	a4,8(a5)
 d3c:	fe043783          	ld	a5,-32(s0)
 d40:	479c                	lw	a5,8(a5)
 d42:	9fb9                	addw	a5,a5,a4
 d44:	0007871b          	sext.w	a4,a5
 d48:	fe843783          	ld	a5,-24(s0)
 d4c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d4e:	fe043783          	ld	a5,-32(s0)
 d52:	6398                	ld	a4,0(a5)
 d54:	fe843783          	ld	a5,-24(s0)
 d58:	e398                	sd	a4,0(a5)
 d5a:	a031                	j	d66 <free+0x10c>
  } else
    p->s.ptr = bp;
 d5c:	fe843783          	ld	a5,-24(s0)
 d60:	fe043703          	ld	a4,-32(s0)
 d64:	e398                	sd	a4,0(a5)
  freep = p;
 d66:	00001797          	auipc	a5,0x1
 d6a:	85a78793          	addi	a5,a5,-1958 # 15c0 <freep>
 d6e:	fe843703          	ld	a4,-24(s0)
 d72:	e398                	sd	a4,0(a5)
}
 d74:	0001                	nop
 d76:	7422                	ld	s0,40(sp)
 d78:	6145                	addi	sp,sp,48
 d7a:	8082                	ret

0000000000000d7c <morecore>:

static Header*
morecore(uint nu)
{
 d7c:	7179                	addi	sp,sp,-48
 d7e:	f406                	sd	ra,40(sp)
 d80:	f022                	sd	s0,32(sp)
 d82:	1800                	addi	s0,sp,48
 d84:	87aa                	mv	a5,a0
 d86:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 d8a:	fdc42783          	lw	a5,-36(s0)
 d8e:	0007871b          	sext.w	a4,a5
 d92:	6785                	lui	a5,0x1
 d94:	00f77563          	bgeu	a4,a5,d9e <morecore+0x22>
    nu = 4096;
 d98:	6785                	lui	a5,0x1
 d9a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d9e:	fdc42783          	lw	a5,-36(s0)
 da2:	0047979b          	slliw	a5,a5,0x4
 da6:	2781                	sext.w	a5,a5
 da8:	2781                	sext.w	a5,a5
 daa:	853e                	mv	a0,a5
 dac:	00000097          	auipc	ra,0x0
 db0:	9ae080e7          	jalr	-1618(ra) # 75a <sbrk>
 db4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 db8:	fe843703          	ld	a4,-24(s0)
 dbc:	57fd                	li	a5,-1
 dbe:	00f71463          	bne	a4,a5,dc6 <morecore+0x4a>
    return 0;
 dc2:	4781                	li	a5,0
 dc4:	a03d                	j	df2 <morecore+0x76>
  hp = (Header*)p;
 dc6:	fe843783          	ld	a5,-24(s0)
 dca:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 dce:	fe043783          	ld	a5,-32(s0)
 dd2:	fdc42703          	lw	a4,-36(s0)
 dd6:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 dd8:	fe043783          	ld	a5,-32(s0)
 ddc:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x214>
 dde:	853e                	mv	a0,a5
 de0:	00000097          	auipc	ra,0x0
 de4:	e7a080e7          	jalr	-390(ra) # c5a <free>
  return freep;
 de8:	00000797          	auipc	a5,0x0
 dec:	7d878793          	addi	a5,a5,2008 # 15c0 <freep>
 df0:	639c                	ld	a5,0(a5)
}
 df2:	853e                	mv	a0,a5
 df4:	70a2                	ld	ra,40(sp)
 df6:	7402                	ld	s0,32(sp)
 df8:	6145                	addi	sp,sp,48
 dfa:	8082                	ret

0000000000000dfc <malloc>:

void*
malloc(uint nbytes)
{
 dfc:	7139                	addi	sp,sp,-64
 dfe:	fc06                	sd	ra,56(sp)
 e00:	f822                	sd	s0,48(sp)
 e02:	0080                	addi	s0,sp,64
 e04:	87aa                	mv	a5,a0
 e06:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e0a:	fcc46783          	lwu	a5,-52(s0)
 e0e:	07bd                	addi	a5,a5,15
 e10:	8391                	srli	a5,a5,0x4
 e12:	2781                	sext.w	a5,a5
 e14:	2785                	addiw	a5,a5,1
 e16:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 e1a:	00000797          	auipc	a5,0x0
 e1e:	7a678793          	addi	a5,a5,1958 # 15c0 <freep>
 e22:	639c                	ld	a5,0(a5)
 e24:	fef43023          	sd	a5,-32(s0)
 e28:	fe043783          	ld	a5,-32(s0)
 e2c:	ef95                	bnez	a5,e68 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 e2e:	00000797          	auipc	a5,0x0
 e32:	78278793          	addi	a5,a5,1922 # 15b0 <base>
 e36:	fef43023          	sd	a5,-32(s0)
 e3a:	00000797          	auipc	a5,0x0
 e3e:	78678793          	addi	a5,a5,1926 # 15c0 <freep>
 e42:	fe043703          	ld	a4,-32(s0)
 e46:	e398                	sd	a4,0(a5)
 e48:	00000797          	auipc	a5,0x0
 e4c:	77878793          	addi	a5,a5,1912 # 15c0 <freep>
 e50:	6398                	ld	a4,0(a5)
 e52:	00000797          	auipc	a5,0x0
 e56:	75e78793          	addi	a5,a5,1886 # 15b0 <base>
 e5a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 e5c:	00000797          	auipc	a5,0x0
 e60:	75478793          	addi	a5,a5,1876 # 15b0 <base>
 e64:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e68:	fe043783          	ld	a5,-32(s0)
 e6c:	639c                	ld	a5,0(a5)
 e6e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e72:	fe843783          	ld	a5,-24(s0)
 e76:	4798                	lw	a4,8(a5)
 e78:	fdc42783          	lw	a5,-36(s0)
 e7c:	2781                	sext.w	a5,a5
 e7e:	06f76763          	bltu	a4,a5,eec <malloc+0xf0>
      if(p->s.size == nunits)
 e82:	fe843783          	ld	a5,-24(s0)
 e86:	4798                	lw	a4,8(a5)
 e88:	fdc42783          	lw	a5,-36(s0)
 e8c:	2781                	sext.w	a5,a5
 e8e:	00e79963          	bne	a5,a4,ea0 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 e92:	fe843783          	ld	a5,-24(s0)
 e96:	6398                	ld	a4,0(a5)
 e98:	fe043783          	ld	a5,-32(s0)
 e9c:	e398                	sd	a4,0(a5)
 e9e:	a825                	j	ed6 <malloc+0xda>
      else {
        p->s.size -= nunits;
 ea0:	fe843783          	ld	a5,-24(s0)
 ea4:	479c                	lw	a5,8(a5)
 ea6:	fdc42703          	lw	a4,-36(s0)
 eaa:	9f99                	subw	a5,a5,a4
 eac:	0007871b          	sext.w	a4,a5
 eb0:	fe843783          	ld	a5,-24(s0)
 eb4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 eb6:	fe843783          	ld	a5,-24(s0)
 eba:	479c                	lw	a5,8(a5)
 ebc:	1782                	slli	a5,a5,0x20
 ebe:	9381                	srli	a5,a5,0x20
 ec0:	0792                	slli	a5,a5,0x4
 ec2:	fe843703          	ld	a4,-24(s0)
 ec6:	97ba                	add	a5,a5,a4
 ec8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 ecc:	fe843783          	ld	a5,-24(s0)
 ed0:	fdc42703          	lw	a4,-36(s0)
 ed4:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 ed6:	00000797          	auipc	a5,0x0
 eda:	6ea78793          	addi	a5,a5,1770 # 15c0 <freep>
 ede:	fe043703          	ld	a4,-32(s0)
 ee2:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 ee4:	fe843783          	ld	a5,-24(s0)
 ee8:	07c1                	addi	a5,a5,16
 eea:	a091                	j	f2e <malloc+0x132>
    }
    if(p == freep)
 eec:	00000797          	auipc	a5,0x0
 ef0:	6d478793          	addi	a5,a5,1748 # 15c0 <freep>
 ef4:	639c                	ld	a5,0(a5)
 ef6:	fe843703          	ld	a4,-24(s0)
 efa:	02f71063          	bne	a4,a5,f1a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 efe:	fdc42783          	lw	a5,-36(s0)
 f02:	853e                	mv	a0,a5
 f04:	00000097          	auipc	ra,0x0
 f08:	e78080e7          	jalr	-392(ra) # d7c <morecore>
 f0c:	fea43423          	sd	a0,-24(s0)
 f10:	fe843783          	ld	a5,-24(s0)
 f14:	e399                	bnez	a5,f1a <malloc+0x11e>
        return 0;
 f16:	4781                	li	a5,0
 f18:	a819                	j	f2e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f1a:	fe843783          	ld	a5,-24(s0)
 f1e:	fef43023          	sd	a5,-32(s0)
 f22:	fe843783          	ld	a5,-24(s0)
 f26:	639c                	ld	a5,0(a5)
 f28:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 f2c:	b799                	j	e72 <malloc+0x76>
  }
}
 f2e:	853e                	mv	a0,a5
 f30:	70e2                	ld	ra,56(sp)
 f32:	7442                	ld	s0,48(sp)
 f34:	6121                	addi	sp,sp,64
 f36:	8082                	ret
