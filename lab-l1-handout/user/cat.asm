
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
   8:	87aa                	mv	a5,a0
   a:	fcf42e23          	sw	a5,-36(s0)
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   e:	a091                	j	52 <cat+0x52>
    if (write(1, buf, n) != n) {
  10:	fec42783          	lw	a5,-20(s0)
  14:	863e                	mv	a2,a5
  16:	00001597          	auipc	a1,0x1
  1a:	39a58593          	addi	a1,a1,922 # 13b0 <buf>
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	62c080e7          	jalr	1580(ra) # 64c <write>
  28:	87aa                	mv	a5,a0
  2a:	873e                	mv	a4,a5
  2c:	fec42783          	lw	a5,-20(s0)
  30:	2781                	sext.w	a5,a5
  32:	02e78063          	beq	a5,a4,52 <cat+0x52>
      fprintf(2, "cat: write error\n");
  36:	00001597          	auipc	a1,0x1
  3a:	e6a58593          	addi	a1,a1,-406 # ea0 <malloc+0x14a>
  3e:	4509                	li	a0,2
  40:	00001097          	auipc	ra,0x1
  44:	acc080e7          	jalr	-1332(ra) # b0c <fprintf>
      exit(1);
  48:	4505                	li	a0,1
  4a:	00000097          	auipc	ra,0x0
  4e:	5e2080e7          	jalr	1506(ra) # 62c <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  52:	fdc42783          	lw	a5,-36(s0)
  56:	20000613          	li	a2,512
  5a:	00001597          	auipc	a1,0x1
  5e:	35658593          	addi	a1,a1,854 # 13b0 <buf>
  62:	853e                	mv	a0,a5
  64:	00000097          	auipc	ra,0x0
  68:	5e0080e7          	jalr	1504(ra) # 644 <read>
  6c:	87aa                	mv	a5,a0
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	2781                	sext.w	a5,a5
  78:	f8f04ce3          	bgtz	a5,10 <cat+0x10>
    }
  }
  if(n < 0){
  7c:	fec42783          	lw	a5,-20(s0)
  80:	2781                	sext.w	a5,a5
  82:	0207d063          	bgez	a5,a2 <cat+0xa2>
    fprintf(2, "cat: read error\n");
  86:	00001597          	auipc	a1,0x1
  8a:	e3258593          	addi	a1,a1,-462 # eb8 <malloc+0x162>
  8e:	4509                	li	a0,2
  90:	00001097          	auipc	ra,0x1
  94:	a7c080e7          	jalr	-1412(ra) # b0c <fprintf>
    exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	592080e7          	jalr	1426(ra) # 62c <exit>
  }
}
  a2:	0001                	nop
  a4:	70a2                	ld	ra,40(sp)
  a6:	7402                	ld	s0,32(sp)
  a8:	6145                	addi	sp,sp,48
  aa:	8082                	ret

00000000000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	7179                	addi	sp,sp,-48
  ae:	f406                	sd	ra,40(sp)
  b0:	f022                	sd	s0,32(sp)
  b2:	1800                	addi	s0,sp,48
  b4:	87aa                	mv	a5,a0
  b6:	fcb43823          	sd	a1,-48(s0)
  ba:	fcf42e23          	sw	a5,-36(s0)
  int fd, i;

  if(argc <= 1){
  be:	fdc42783          	lw	a5,-36(s0)
  c2:	0007871b          	sext.w	a4,a5
  c6:	4785                	li	a5,1
  c8:	00e7cc63          	blt	a5,a4,e0 <main+0x34>
    cat(0);
  cc:	4501                	li	a0,0
  ce:	00000097          	auipc	ra,0x0
  d2:	f32080e7          	jalr	-206(ra) # 0 <cat>
    exit(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	554080e7          	jalr	1364(ra) # 62c <exit>
  }

  for(i = 1; i < argc; i++){
  e0:	4785                	li	a5,1
  e2:	fef42623          	sw	a5,-20(s0)
  e6:	a8bd                	j	164 <main+0xb8>
    if((fd = open(argv[i], 0)) < 0){
  e8:	fec42783          	lw	a5,-20(s0)
  ec:	078e                	slli	a5,a5,0x3
  ee:	fd043703          	ld	a4,-48(s0)
  f2:	97ba                	add	a5,a5,a4
  f4:	639c                	ld	a5,0(a5)
  f6:	4581                	li	a1,0
  f8:	853e                	mv	a0,a5
  fa:	00000097          	auipc	ra,0x0
  fe:	572080e7          	jalr	1394(ra) # 66c <open>
 102:	87aa                	mv	a5,a0
 104:	fef42423          	sw	a5,-24(s0)
 108:	fe842783          	lw	a5,-24(s0)
 10c:	2781                	sext.w	a5,a5
 10e:	0207d863          	bgez	a5,13e <main+0x92>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 112:	fec42783          	lw	a5,-20(s0)
 116:	078e                	slli	a5,a5,0x3
 118:	fd043703          	ld	a4,-48(s0)
 11c:	97ba                	add	a5,a5,a4
 11e:	639c                	ld	a5,0(a5)
 120:	863e                	mv	a2,a5
 122:	00001597          	auipc	a1,0x1
 126:	dae58593          	addi	a1,a1,-594 # ed0 <malloc+0x17a>
 12a:	4509                	li	a0,2
 12c:	00001097          	auipc	ra,0x1
 130:	9e0080e7          	jalr	-1568(ra) # b0c <fprintf>
      exit(1);
 134:	4505                	li	a0,1
 136:	00000097          	auipc	ra,0x0
 13a:	4f6080e7          	jalr	1270(ra) # 62c <exit>
    }
    cat(fd);
 13e:	fe842783          	lw	a5,-24(s0)
 142:	853e                	mv	a0,a5
 144:	00000097          	auipc	ra,0x0
 148:	ebc080e7          	jalr	-324(ra) # 0 <cat>
    close(fd);
 14c:	fe842783          	lw	a5,-24(s0)
 150:	853e                	mv	a0,a5
 152:	00000097          	auipc	ra,0x0
 156:	502080e7          	jalr	1282(ra) # 654 <close>
  for(i = 1; i < argc; i++){
 15a:	fec42783          	lw	a5,-20(s0)
 15e:	2785                	addiw	a5,a5,1
 160:	fef42623          	sw	a5,-20(s0)
 164:	fec42783          	lw	a5,-20(s0)
 168:	873e                	mv	a4,a5
 16a:	fdc42783          	lw	a5,-36(s0)
 16e:	2701                	sext.w	a4,a4
 170:	2781                	sext.w	a5,a5
 172:	f6f74be3          	blt	a4,a5,e8 <main+0x3c>
  }
  exit(0);
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	4b4080e7          	jalr	1204(ra) # 62c <exit>

0000000000000180 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 180:	1141                	addi	sp,sp,-16
 182:	e406                	sd	ra,8(sp)
 184:	e022                	sd	s0,0(sp)
 186:	0800                	addi	s0,sp,16
  extern int main();
  main();
 188:	00000097          	auipc	ra,0x0
 18c:	f24080e7          	jalr	-220(ra) # ac <main>
  exit(0);
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	49a080e7          	jalr	1178(ra) # 62c <exit>

000000000000019a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19a:	7179                	addi	sp,sp,-48
 19c:	f422                	sd	s0,40(sp)
 19e:	1800                	addi	s0,sp,48
 1a0:	fca43c23          	sd	a0,-40(s0)
 1a4:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 1a8:	fd843783          	ld	a5,-40(s0)
 1ac:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 1b0:	0001                	nop
 1b2:	fd043703          	ld	a4,-48(s0)
 1b6:	00170793          	addi	a5,a4,1
 1ba:	fcf43823          	sd	a5,-48(s0)
 1be:	fd843783          	ld	a5,-40(s0)
 1c2:	00178693          	addi	a3,a5,1
 1c6:	fcd43c23          	sd	a3,-40(s0)
 1ca:	00074703          	lbu	a4,0(a4)
 1ce:	00e78023          	sb	a4,0(a5)
 1d2:	0007c783          	lbu	a5,0(a5)
 1d6:	fff1                	bnez	a5,1b2 <strcpy+0x18>
    ;
  return os;
 1d8:	fe843783          	ld	a5,-24(s0)
}
 1dc:	853e                	mv	a0,a5
 1de:	7422                	ld	s0,40(sp)
 1e0:	6145                	addi	sp,sp,48
 1e2:	8082                	ret

00000000000001e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e4:	1101                	addi	sp,sp,-32
 1e6:	ec22                	sd	s0,24(sp)
 1e8:	1000                	addi	s0,sp,32
 1ea:	fea43423          	sd	a0,-24(s0)
 1ee:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 1f2:	a819                	j	208 <strcmp+0x24>
    p++, q++;
 1f4:	fe843783          	ld	a5,-24(s0)
 1f8:	0785                	addi	a5,a5,1
 1fa:	fef43423          	sd	a5,-24(s0)
 1fe:	fe043783          	ld	a5,-32(s0)
 202:	0785                	addi	a5,a5,1
 204:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 208:	fe843783          	ld	a5,-24(s0)
 20c:	0007c783          	lbu	a5,0(a5)
 210:	cb99                	beqz	a5,226 <strcmp+0x42>
 212:	fe843783          	ld	a5,-24(s0)
 216:	0007c703          	lbu	a4,0(a5)
 21a:	fe043783          	ld	a5,-32(s0)
 21e:	0007c783          	lbu	a5,0(a5)
 222:	fcf709e3          	beq	a4,a5,1f4 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 226:	fe843783          	ld	a5,-24(s0)
 22a:	0007c783          	lbu	a5,0(a5)
 22e:	0007871b          	sext.w	a4,a5
 232:	fe043783          	ld	a5,-32(s0)
 236:	0007c783          	lbu	a5,0(a5)
 23a:	2781                	sext.w	a5,a5
 23c:	40f707bb          	subw	a5,a4,a5
 240:	2781                	sext.w	a5,a5
}
 242:	853e                	mv	a0,a5
 244:	6462                	ld	s0,24(sp)
 246:	6105                	addi	sp,sp,32
 248:	8082                	ret

000000000000024a <strlen>:

uint
strlen(const char *s)
{
 24a:	7179                	addi	sp,sp,-48
 24c:	f422                	sd	s0,40(sp)
 24e:	1800                	addi	s0,sp,48
 250:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 254:	fe042623          	sw	zero,-20(s0)
 258:	a031                	j	264 <strlen+0x1a>
 25a:	fec42783          	lw	a5,-20(s0)
 25e:	2785                	addiw	a5,a5,1
 260:	fef42623          	sw	a5,-20(s0)
 264:	fec42783          	lw	a5,-20(s0)
 268:	fd843703          	ld	a4,-40(s0)
 26c:	97ba                	add	a5,a5,a4
 26e:	0007c783          	lbu	a5,0(a5)
 272:	f7e5                	bnez	a5,25a <strlen+0x10>
    ;
  return n;
 274:	fec42783          	lw	a5,-20(s0)
}
 278:	853e                	mv	a0,a5
 27a:	7422                	ld	s0,40(sp)
 27c:	6145                	addi	sp,sp,48
 27e:	8082                	ret

0000000000000280 <memset>:

void*
memset(void *dst, int c, uint n)
{
 280:	7179                	addi	sp,sp,-48
 282:	f422                	sd	s0,40(sp)
 284:	1800                	addi	s0,sp,48
 286:	fca43c23          	sd	a0,-40(s0)
 28a:	87ae                	mv	a5,a1
 28c:	8732                	mv	a4,a2
 28e:	fcf42a23          	sw	a5,-44(s0)
 292:	87ba                	mv	a5,a4
 294:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 298:	fd843783          	ld	a5,-40(s0)
 29c:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 2a0:	fe042623          	sw	zero,-20(s0)
 2a4:	a00d                	j	2c6 <memset+0x46>
    cdst[i] = c;
 2a6:	fec42783          	lw	a5,-20(s0)
 2aa:	fe043703          	ld	a4,-32(s0)
 2ae:	97ba                	add	a5,a5,a4
 2b0:	fd442703          	lw	a4,-44(s0)
 2b4:	0ff77713          	zext.b	a4,a4
 2b8:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 2bc:	fec42783          	lw	a5,-20(s0)
 2c0:	2785                	addiw	a5,a5,1
 2c2:	fef42623          	sw	a5,-20(s0)
 2c6:	fec42703          	lw	a4,-20(s0)
 2ca:	fd042783          	lw	a5,-48(s0)
 2ce:	2781                	sext.w	a5,a5
 2d0:	fcf76be3          	bltu	a4,a5,2a6 <memset+0x26>
  }
  return dst;
 2d4:	fd843783          	ld	a5,-40(s0)
}
 2d8:	853e                	mv	a0,a5
 2da:	7422                	ld	s0,40(sp)
 2dc:	6145                	addi	sp,sp,48
 2de:	8082                	ret

00000000000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	1101                	addi	sp,sp,-32
 2e2:	ec22                	sd	s0,24(sp)
 2e4:	1000                	addi	s0,sp,32
 2e6:	fea43423          	sd	a0,-24(s0)
 2ea:	87ae                	mv	a5,a1
 2ec:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 2f0:	a01d                	j	316 <strchr+0x36>
    if(*s == c)
 2f2:	fe843783          	ld	a5,-24(s0)
 2f6:	0007c703          	lbu	a4,0(a5)
 2fa:	fe744783          	lbu	a5,-25(s0)
 2fe:	0ff7f793          	zext.b	a5,a5
 302:	00e79563          	bne	a5,a4,30c <strchr+0x2c>
      return (char*)s;
 306:	fe843783          	ld	a5,-24(s0)
 30a:	a821                	j	322 <strchr+0x42>
  for(; *s; s++)
 30c:	fe843783          	ld	a5,-24(s0)
 310:	0785                	addi	a5,a5,1
 312:	fef43423          	sd	a5,-24(s0)
 316:	fe843783          	ld	a5,-24(s0)
 31a:	0007c783          	lbu	a5,0(a5)
 31e:	fbf1                	bnez	a5,2f2 <strchr+0x12>
  return 0;
 320:	4781                	li	a5,0
}
 322:	853e                	mv	a0,a5
 324:	6462                	ld	s0,24(sp)
 326:	6105                	addi	sp,sp,32
 328:	8082                	ret

000000000000032a <gets>:

char*
gets(char *buf, int max)
{
 32a:	7179                	addi	sp,sp,-48
 32c:	f406                	sd	ra,40(sp)
 32e:	f022                	sd	s0,32(sp)
 330:	1800                	addi	s0,sp,48
 332:	fca43c23          	sd	a0,-40(s0)
 336:	87ae                	mv	a5,a1
 338:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33c:	fe042623          	sw	zero,-20(s0)
 340:	a8a1                	j	398 <gets+0x6e>
    cc = read(0, &c, 1);
 342:	fe740793          	addi	a5,s0,-25
 346:	4605                	li	a2,1
 348:	85be                	mv	a1,a5
 34a:	4501                	li	a0,0
 34c:	00000097          	auipc	ra,0x0
 350:	2f8080e7          	jalr	760(ra) # 644 <read>
 354:	87aa                	mv	a5,a0
 356:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 35a:	fe842783          	lw	a5,-24(s0)
 35e:	2781                	sext.w	a5,a5
 360:	04f05763          	blez	a5,3ae <gets+0x84>
      break;
    buf[i++] = c;
 364:	fec42783          	lw	a5,-20(s0)
 368:	0017871b          	addiw	a4,a5,1
 36c:	fee42623          	sw	a4,-20(s0)
 370:	873e                	mv	a4,a5
 372:	fd843783          	ld	a5,-40(s0)
 376:	97ba                	add	a5,a5,a4
 378:	fe744703          	lbu	a4,-25(s0)
 37c:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 380:	fe744783          	lbu	a5,-25(s0)
 384:	873e                	mv	a4,a5
 386:	47a9                	li	a5,10
 388:	02f70463          	beq	a4,a5,3b0 <gets+0x86>
 38c:	fe744783          	lbu	a5,-25(s0)
 390:	873e                	mv	a4,a5
 392:	47b5                	li	a5,13
 394:	00f70e63          	beq	a4,a5,3b0 <gets+0x86>
  for(i=0; i+1 < max; ){
 398:	fec42783          	lw	a5,-20(s0)
 39c:	2785                	addiw	a5,a5,1
 39e:	0007871b          	sext.w	a4,a5
 3a2:	fd442783          	lw	a5,-44(s0)
 3a6:	2781                	sext.w	a5,a5
 3a8:	f8f74de3          	blt	a4,a5,342 <gets+0x18>
 3ac:	a011                	j	3b0 <gets+0x86>
      break;
 3ae:	0001                	nop
      break;
  }
  buf[i] = '\0';
 3b0:	fec42783          	lw	a5,-20(s0)
 3b4:	fd843703          	ld	a4,-40(s0)
 3b8:	97ba                	add	a5,a5,a4
 3ba:	00078023          	sb	zero,0(a5)
  return buf;
 3be:	fd843783          	ld	a5,-40(s0)
}
 3c2:	853e                	mv	a0,a5
 3c4:	70a2                	ld	ra,40(sp)
 3c6:	7402                	ld	s0,32(sp)
 3c8:	6145                	addi	sp,sp,48
 3ca:	8082                	ret

00000000000003cc <stat>:

int
stat(const char *n, struct stat *st)
{
 3cc:	7179                	addi	sp,sp,-48
 3ce:	f406                	sd	ra,40(sp)
 3d0:	f022                	sd	s0,32(sp)
 3d2:	1800                	addi	s0,sp,48
 3d4:	fca43c23          	sd	a0,-40(s0)
 3d8:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3dc:	4581                	li	a1,0
 3de:	fd843503          	ld	a0,-40(s0)
 3e2:	00000097          	auipc	ra,0x0
 3e6:	28a080e7          	jalr	650(ra) # 66c <open>
 3ea:	87aa                	mv	a5,a0
 3ec:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 3f0:	fec42783          	lw	a5,-20(s0)
 3f4:	2781                	sext.w	a5,a5
 3f6:	0007d463          	bgez	a5,3fe <stat+0x32>
    return -1;
 3fa:	57fd                	li	a5,-1
 3fc:	a035                	j	428 <stat+0x5c>
  r = fstat(fd, st);
 3fe:	fec42783          	lw	a5,-20(s0)
 402:	fd043583          	ld	a1,-48(s0)
 406:	853e                	mv	a0,a5
 408:	00000097          	auipc	ra,0x0
 40c:	27c080e7          	jalr	636(ra) # 684 <fstat>
 410:	87aa                	mv	a5,a0
 412:	fef42423          	sw	a5,-24(s0)
  close(fd);
 416:	fec42783          	lw	a5,-20(s0)
 41a:	853e                	mv	a0,a5
 41c:	00000097          	auipc	ra,0x0
 420:	238080e7          	jalr	568(ra) # 654 <close>
  return r;
 424:	fe842783          	lw	a5,-24(s0)
}
 428:	853e                	mv	a0,a5
 42a:	70a2                	ld	ra,40(sp)
 42c:	7402                	ld	s0,32(sp)
 42e:	6145                	addi	sp,sp,48
 430:	8082                	ret

0000000000000432 <atoi>:

int
atoi(const char *s)
{
 432:	7179                	addi	sp,sp,-48
 434:	f422                	sd	s0,40(sp)
 436:	1800                	addi	s0,sp,48
 438:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 43c:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 440:	a81d                	j	476 <atoi+0x44>
    n = n*10 + *s++ - '0';
 442:	fec42783          	lw	a5,-20(s0)
 446:	873e                	mv	a4,a5
 448:	87ba                	mv	a5,a4
 44a:	0027979b          	slliw	a5,a5,0x2
 44e:	9fb9                	addw	a5,a5,a4
 450:	0017979b          	slliw	a5,a5,0x1
 454:	0007871b          	sext.w	a4,a5
 458:	fd843783          	ld	a5,-40(s0)
 45c:	00178693          	addi	a3,a5,1
 460:	fcd43c23          	sd	a3,-40(s0)
 464:	0007c783          	lbu	a5,0(a5)
 468:	2781                	sext.w	a5,a5
 46a:	9fb9                	addw	a5,a5,a4
 46c:	2781                	sext.w	a5,a5
 46e:	fd07879b          	addiw	a5,a5,-48
 472:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 476:	fd843783          	ld	a5,-40(s0)
 47a:	0007c783          	lbu	a5,0(a5)
 47e:	873e                	mv	a4,a5
 480:	02f00793          	li	a5,47
 484:	00e7fb63          	bgeu	a5,a4,49a <atoi+0x68>
 488:	fd843783          	ld	a5,-40(s0)
 48c:	0007c783          	lbu	a5,0(a5)
 490:	873e                	mv	a4,a5
 492:	03900793          	li	a5,57
 496:	fae7f6e3          	bgeu	a5,a4,442 <atoi+0x10>
  return n;
 49a:	fec42783          	lw	a5,-20(s0)
}
 49e:	853e                	mv	a0,a5
 4a0:	7422                	ld	s0,40(sp)
 4a2:	6145                	addi	sp,sp,48
 4a4:	8082                	ret

00000000000004a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a6:	7139                	addi	sp,sp,-64
 4a8:	fc22                	sd	s0,56(sp)
 4aa:	0080                	addi	s0,sp,64
 4ac:	fca43c23          	sd	a0,-40(s0)
 4b0:	fcb43823          	sd	a1,-48(s0)
 4b4:	87b2                	mv	a5,a2
 4b6:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 4ba:	fd843783          	ld	a5,-40(s0)
 4be:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 4c2:	fd043783          	ld	a5,-48(s0)
 4c6:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 4ca:	fe043703          	ld	a4,-32(s0)
 4ce:	fe843783          	ld	a5,-24(s0)
 4d2:	02e7fc63          	bgeu	a5,a4,50a <memmove+0x64>
    while(n-- > 0)
 4d6:	a00d                	j	4f8 <memmove+0x52>
      *dst++ = *src++;
 4d8:	fe043703          	ld	a4,-32(s0)
 4dc:	00170793          	addi	a5,a4,1
 4e0:	fef43023          	sd	a5,-32(s0)
 4e4:	fe843783          	ld	a5,-24(s0)
 4e8:	00178693          	addi	a3,a5,1
 4ec:	fed43423          	sd	a3,-24(s0)
 4f0:	00074703          	lbu	a4,0(a4)
 4f4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 4f8:	fcc42783          	lw	a5,-52(s0)
 4fc:	fff7871b          	addiw	a4,a5,-1
 500:	fce42623          	sw	a4,-52(s0)
 504:	fcf04ae3          	bgtz	a5,4d8 <memmove+0x32>
 508:	a891                	j	55c <memmove+0xb6>
  } else {
    dst += n;
 50a:	fcc42783          	lw	a5,-52(s0)
 50e:	fe843703          	ld	a4,-24(s0)
 512:	97ba                	add	a5,a5,a4
 514:	fef43423          	sd	a5,-24(s0)
    src += n;
 518:	fcc42783          	lw	a5,-52(s0)
 51c:	fe043703          	ld	a4,-32(s0)
 520:	97ba                	add	a5,a5,a4
 522:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 526:	a01d                	j	54c <memmove+0xa6>
      *--dst = *--src;
 528:	fe043783          	ld	a5,-32(s0)
 52c:	17fd                	addi	a5,a5,-1
 52e:	fef43023          	sd	a5,-32(s0)
 532:	fe843783          	ld	a5,-24(s0)
 536:	17fd                	addi	a5,a5,-1
 538:	fef43423          	sd	a5,-24(s0)
 53c:	fe043783          	ld	a5,-32(s0)
 540:	0007c703          	lbu	a4,0(a5)
 544:	fe843783          	ld	a5,-24(s0)
 548:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 54c:	fcc42783          	lw	a5,-52(s0)
 550:	fff7871b          	addiw	a4,a5,-1
 554:	fce42623          	sw	a4,-52(s0)
 558:	fcf048e3          	bgtz	a5,528 <memmove+0x82>
  }
  return vdst;
 55c:	fd843783          	ld	a5,-40(s0)
}
 560:	853e                	mv	a0,a5
 562:	7462                	ld	s0,56(sp)
 564:	6121                	addi	sp,sp,64
 566:	8082                	ret

0000000000000568 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 568:	7139                	addi	sp,sp,-64
 56a:	fc22                	sd	s0,56(sp)
 56c:	0080                	addi	s0,sp,64
 56e:	fca43c23          	sd	a0,-40(s0)
 572:	fcb43823          	sd	a1,-48(s0)
 576:	87b2                	mv	a5,a2
 578:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 57c:	fd843783          	ld	a5,-40(s0)
 580:	fef43423          	sd	a5,-24(s0)
 584:	fd043783          	ld	a5,-48(s0)
 588:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 58c:	a0a1                	j	5d4 <memcmp+0x6c>
    if (*p1 != *p2) {
 58e:	fe843783          	ld	a5,-24(s0)
 592:	0007c703          	lbu	a4,0(a5)
 596:	fe043783          	ld	a5,-32(s0)
 59a:	0007c783          	lbu	a5,0(a5)
 59e:	02f70163          	beq	a4,a5,5c0 <memcmp+0x58>
      return *p1 - *p2;
 5a2:	fe843783          	ld	a5,-24(s0)
 5a6:	0007c783          	lbu	a5,0(a5)
 5aa:	0007871b          	sext.w	a4,a5
 5ae:	fe043783          	ld	a5,-32(s0)
 5b2:	0007c783          	lbu	a5,0(a5)
 5b6:	2781                	sext.w	a5,a5
 5b8:	40f707bb          	subw	a5,a4,a5
 5bc:	2781                	sext.w	a5,a5
 5be:	a01d                	j	5e4 <memcmp+0x7c>
    }
    p1++;
 5c0:	fe843783          	ld	a5,-24(s0)
 5c4:	0785                	addi	a5,a5,1
 5c6:	fef43423          	sd	a5,-24(s0)
    p2++;
 5ca:	fe043783          	ld	a5,-32(s0)
 5ce:	0785                	addi	a5,a5,1
 5d0:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5d4:	fcc42783          	lw	a5,-52(s0)
 5d8:	fff7871b          	addiw	a4,a5,-1
 5dc:	fce42623          	sw	a4,-52(s0)
 5e0:	f7dd                	bnez	a5,58e <memcmp+0x26>
  }
  return 0;
 5e2:	4781                	li	a5,0
}
 5e4:	853e                	mv	a0,a5
 5e6:	7462                	ld	s0,56(sp)
 5e8:	6121                	addi	sp,sp,64
 5ea:	8082                	ret

00000000000005ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5ec:	7179                	addi	sp,sp,-48
 5ee:	f406                	sd	ra,40(sp)
 5f0:	f022                	sd	s0,32(sp)
 5f2:	1800                	addi	s0,sp,48
 5f4:	fea43423          	sd	a0,-24(s0)
 5f8:	feb43023          	sd	a1,-32(s0)
 5fc:	87b2                	mv	a5,a2
 5fe:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 602:	fdc42783          	lw	a5,-36(s0)
 606:	863e                	mv	a2,a5
 608:	fe043583          	ld	a1,-32(s0)
 60c:	fe843503          	ld	a0,-24(s0)
 610:	00000097          	auipc	ra,0x0
 614:	e96080e7          	jalr	-362(ra) # 4a6 <memmove>
 618:	87aa                	mv	a5,a0
}
 61a:	853e                	mv	a0,a5
 61c:	70a2                	ld	ra,40(sp)
 61e:	7402                	ld	s0,32(sp)
 620:	6145                	addi	sp,sp,48
 622:	8082                	ret

0000000000000624 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 624:	4885                	li	a7,1
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <exit>:
.global exit
exit:
 li a7, SYS_exit
 62c:	4889                	li	a7,2
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <wait>:
.global wait
wait:
 li a7, SYS_wait
 634:	488d                	li	a7,3
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 63c:	4891                	li	a7,4
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <read>:
.global read
read:
 li a7, SYS_read
 644:	4895                	li	a7,5
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <write>:
.global write
write:
 li a7, SYS_write
 64c:	48c1                	li	a7,16
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <close>:
.global close
close:
 li a7, SYS_close
 654:	48d5                	li	a7,21
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <kill>:
.global kill
kill:
 li a7, SYS_kill
 65c:	4899                	li	a7,6
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <exec>:
.global exec
exec:
 li a7, SYS_exec
 664:	489d                	li	a7,7
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <open>:
.global open
open:
 li a7, SYS_open
 66c:	48bd                	li	a7,15
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 674:	48c5                	li	a7,17
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 67c:	48c9                	li	a7,18
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 684:	48a1                	li	a7,8
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <link>:
.global link
link:
 li a7, SYS_link
 68c:	48cd                	li	a7,19
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 694:	48d1                	li	a7,20
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 69c:	48a5                	li	a7,9
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6a4:	48a9                	li	a7,10
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ac:	48ad                	li	a7,11
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6b4:	48b1                	li	a7,12
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6bc:	48b5                	li	a7,13
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6c4:	48b9                	li	a7,14
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <hello>:
.global hello
hello:
 li a7, SYS_hello
 6cc:	48d9                	li	a7,22
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 6d4:	48dd                	li	a7,23
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6dc:	1101                	addi	sp,sp,-32
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	87aa                	mv	a5,a0
 6e6:	872e                	mv	a4,a1
 6e8:	fef42623          	sw	a5,-20(s0)
 6ec:	87ba                	mv	a5,a4
 6ee:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 6f2:	feb40713          	addi	a4,s0,-21
 6f6:	fec42783          	lw	a5,-20(s0)
 6fa:	4605                	li	a2,1
 6fc:	85ba                	mv	a1,a4
 6fe:	853e                	mv	a0,a5
 700:	00000097          	auipc	ra,0x0
 704:	f4c080e7          	jalr	-180(ra) # 64c <write>
}
 708:	0001                	nop
 70a:	60e2                	ld	ra,24(sp)
 70c:	6442                	ld	s0,16(sp)
 70e:	6105                	addi	sp,sp,32
 710:	8082                	ret

0000000000000712 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 712:	7139                	addi	sp,sp,-64
 714:	fc06                	sd	ra,56(sp)
 716:	f822                	sd	s0,48(sp)
 718:	0080                	addi	s0,sp,64
 71a:	87aa                	mv	a5,a0
 71c:	8736                	mv	a4,a3
 71e:	fcf42623          	sw	a5,-52(s0)
 722:	87ae                	mv	a5,a1
 724:	fcf42423          	sw	a5,-56(s0)
 728:	87b2                	mv	a5,a2
 72a:	fcf42223          	sw	a5,-60(s0)
 72e:	87ba                	mv	a5,a4
 730:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 734:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 738:	fc042783          	lw	a5,-64(s0)
 73c:	2781                	sext.w	a5,a5
 73e:	c38d                	beqz	a5,760 <printint+0x4e>
 740:	fc842783          	lw	a5,-56(s0)
 744:	2781                	sext.w	a5,a5
 746:	0007dd63          	bgez	a5,760 <printint+0x4e>
    neg = 1;
 74a:	4785                	li	a5,1
 74c:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 750:	fc842783          	lw	a5,-56(s0)
 754:	40f007bb          	negw	a5,a5
 758:	2781                	sext.w	a5,a5
 75a:	fef42223          	sw	a5,-28(s0)
 75e:	a029                	j	768 <printint+0x56>
  } else {
    x = xx;
 760:	fc842783          	lw	a5,-56(s0)
 764:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 768:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 76c:	fc442783          	lw	a5,-60(s0)
 770:	fe442703          	lw	a4,-28(s0)
 774:	02f777bb          	remuw	a5,a4,a5
 778:	0007861b          	sext.w	a2,a5
 77c:	fec42783          	lw	a5,-20(s0)
 780:	0017871b          	addiw	a4,a5,1
 784:	fee42623          	sw	a4,-20(s0)
 788:	00001697          	auipc	a3,0x1
 78c:	c0868693          	addi	a3,a3,-1016 # 1390 <digits>
 790:	02061713          	slli	a4,a2,0x20
 794:	9301                	srli	a4,a4,0x20
 796:	9736                	add	a4,a4,a3
 798:	00074703          	lbu	a4,0(a4)
 79c:	17c1                	addi	a5,a5,-16
 79e:	97a2                	add	a5,a5,s0
 7a0:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 7a4:	fc442783          	lw	a5,-60(s0)
 7a8:	fe442703          	lw	a4,-28(s0)
 7ac:	02f757bb          	divuw	a5,a4,a5
 7b0:	fef42223          	sw	a5,-28(s0)
 7b4:	fe442783          	lw	a5,-28(s0)
 7b8:	2781                	sext.w	a5,a5
 7ba:	fbcd                	bnez	a5,76c <printint+0x5a>
  if(neg)
 7bc:	fe842783          	lw	a5,-24(s0)
 7c0:	2781                	sext.w	a5,a5
 7c2:	cf85                	beqz	a5,7fa <printint+0xe8>
    buf[i++] = '-';
 7c4:	fec42783          	lw	a5,-20(s0)
 7c8:	0017871b          	addiw	a4,a5,1
 7cc:	fee42623          	sw	a4,-20(s0)
 7d0:	17c1                	addi	a5,a5,-16
 7d2:	97a2                	add	a5,a5,s0
 7d4:	02d00713          	li	a4,45
 7d8:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7dc:	a839                	j	7fa <printint+0xe8>
    putc(fd, buf[i]);
 7de:	fec42783          	lw	a5,-20(s0)
 7e2:	17c1                	addi	a5,a5,-16
 7e4:	97a2                	add	a5,a5,s0
 7e6:	fe07c703          	lbu	a4,-32(a5)
 7ea:	fcc42783          	lw	a5,-52(s0)
 7ee:	85ba                	mv	a1,a4
 7f0:	853e                	mv	a0,a5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	eea080e7          	jalr	-278(ra) # 6dc <putc>
  while(--i >= 0)
 7fa:	fec42783          	lw	a5,-20(s0)
 7fe:	37fd                	addiw	a5,a5,-1
 800:	fef42623          	sw	a5,-20(s0)
 804:	fec42783          	lw	a5,-20(s0)
 808:	2781                	sext.w	a5,a5
 80a:	fc07dae3          	bgez	a5,7de <printint+0xcc>
}
 80e:	0001                	nop
 810:	0001                	nop
 812:	70e2                	ld	ra,56(sp)
 814:	7442                	ld	s0,48(sp)
 816:	6121                	addi	sp,sp,64
 818:	8082                	ret

000000000000081a <printptr>:

static void
printptr(int fd, uint64 x) {
 81a:	7179                	addi	sp,sp,-48
 81c:	f406                	sd	ra,40(sp)
 81e:	f022                	sd	s0,32(sp)
 820:	1800                	addi	s0,sp,48
 822:	87aa                	mv	a5,a0
 824:	fcb43823          	sd	a1,-48(s0)
 828:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 82c:	fdc42783          	lw	a5,-36(s0)
 830:	03000593          	li	a1,48
 834:	853e                	mv	a0,a5
 836:	00000097          	auipc	ra,0x0
 83a:	ea6080e7          	jalr	-346(ra) # 6dc <putc>
  putc(fd, 'x');
 83e:	fdc42783          	lw	a5,-36(s0)
 842:	07800593          	li	a1,120
 846:	853e                	mv	a0,a5
 848:	00000097          	auipc	ra,0x0
 84c:	e94080e7          	jalr	-364(ra) # 6dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 850:	fe042623          	sw	zero,-20(s0)
 854:	a82d                	j	88e <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 856:	fd043783          	ld	a5,-48(s0)
 85a:	93f1                	srli	a5,a5,0x3c
 85c:	00001717          	auipc	a4,0x1
 860:	b3470713          	addi	a4,a4,-1228 # 1390 <digits>
 864:	97ba                	add	a5,a5,a4
 866:	0007c703          	lbu	a4,0(a5)
 86a:	fdc42783          	lw	a5,-36(s0)
 86e:	85ba                	mv	a1,a4
 870:	853e                	mv	a0,a5
 872:	00000097          	auipc	ra,0x0
 876:	e6a080e7          	jalr	-406(ra) # 6dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 87a:	fec42783          	lw	a5,-20(s0)
 87e:	2785                	addiw	a5,a5,1
 880:	fef42623          	sw	a5,-20(s0)
 884:	fd043783          	ld	a5,-48(s0)
 888:	0792                	slli	a5,a5,0x4
 88a:	fcf43823          	sd	a5,-48(s0)
 88e:	fec42783          	lw	a5,-20(s0)
 892:	873e                	mv	a4,a5
 894:	47bd                	li	a5,15
 896:	fce7f0e3          	bgeu	a5,a4,856 <printptr+0x3c>
}
 89a:	0001                	nop
 89c:	0001                	nop
 89e:	70a2                	ld	ra,40(sp)
 8a0:	7402                	ld	s0,32(sp)
 8a2:	6145                	addi	sp,sp,48
 8a4:	8082                	ret

00000000000008a6 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8a6:	715d                	addi	sp,sp,-80
 8a8:	e486                	sd	ra,72(sp)
 8aa:	e0a2                	sd	s0,64(sp)
 8ac:	0880                	addi	s0,sp,80
 8ae:	87aa                	mv	a5,a0
 8b0:	fcb43023          	sd	a1,-64(s0)
 8b4:	fac43c23          	sd	a2,-72(s0)
 8b8:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8bc:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8c0:	fe042223          	sw	zero,-28(s0)
 8c4:	a42d                	j	aee <vprintf+0x248>
    c = fmt[i] & 0xff;
 8c6:	fe442783          	lw	a5,-28(s0)
 8ca:	fc043703          	ld	a4,-64(s0)
 8ce:	97ba                	add	a5,a5,a4
 8d0:	0007c783          	lbu	a5,0(a5)
 8d4:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8d8:	fe042783          	lw	a5,-32(s0)
 8dc:	2781                	sext.w	a5,a5
 8de:	eb9d                	bnez	a5,914 <vprintf+0x6e>
      if(c == '%'){
 8e0:	fdc42783          	lw	a5,-36(s0)
 8e4:	0007871b          	sext.w	a4,a5
 8e8:	02500793          	li	a5,37
 8ec:	00f71763          	bne	a4,a5,8fa <vprintf+0x54>
        state = '%';
 8f0:	02500793          	li	a5,37
 8f4:	fef42023          	sw	a5,-32(s0)
 8f8:	a2f5                	j	ae4 <vprintf+0x23e>
      } else {
        putc(fd, c);
 8fa:	fdc42783          	lw	a5,-36(s0)
 8fe:	0ff7f713          	zext.b	a4,a5
 902:	fcc42783          	lw	a5,-52(s0)
 906:	85ba                	mv	a1,a4
 908:	853e                	mv	a0,a5
 90a:	00000097          	auipc	ra,0x0
 90e:	dd2080e7          	jalr	-558(ra) # 6dc <putc>
 912:	aac9                	j	ae4 <vprintf+0x23e>
      }
    } else if(state == '%'){
 914:	fe042783          	lw	a5,-32(s0)
 918:	0007871b          	sext.w	a4,a5
 91c:	02500793          	li	a5,37
 920:	1cf71263          	bne	a4,a5,ae4 <vprintf+0x23e>
      if(c == 'd'){
 924:	fdc42783          	lw	a5,-36(s0)
 928:	0007871b          	sext.w	a4,a5
 92c:	06400793          	li	a5,100
 930:	02f71463          	bne	a4,a5,958 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 934:	fb843783          	ld	a5,-72(s0)
 938:	00878713          	addi	a4,a5,8
 93c:	fae43c23          	sd	a4,-72(s0)
 940:	4398                	lw	a4,0(a5)
 942:	fcc42783          	lw	a5,-52(s0)
 946:	4685                	li	a3,1
 948:	4629                	li	a2,10
 94a:	85ba                	mv	a1,a4
 94c:	853e                	mv	a0,a5
 94e:	00000097          	auipc	ra,0x0
 952:	dc4080e7          	jalr	-572(ra) # 712 <printint>
 956:	a269                	j	ae0 <vprintf+0x23a>
      } else if(c == 'l') {
 958:	fdc42783          	lw	a5,-36(s0)
 95c:	0007871b          	sext.w	a4,a5
 960:	06c00793          	li	a5,108
 964:	02f71663          	bne	a4,a5,990 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 968:	fb843783          	ld	a5,-72(s0)
 96c:	00878713          	addi	a4,a5,8
 970:	fae43c23          	sd	a4,-72(s0)
 974:	639c                	ld	a5,0(a5)
 976:	0007871b          	sext.w	a4,a5
 97a:	fcc42783          	lw	a5,-52(s0)
 97e:	4681                	li	a3,0
 980:	4629                	li	a2,10
 982:	85ba                	mv	a1,a4
 984:	853e                	mv	a0,a5
 986:	00000097          	auipc	ra,0x0
 98a:	d8c080e7          	jalr	-628(ra) # 712 <printint>
 98e:	aa89                	j	ae0 <vprintf+0x23a>
      } else if(c == 'x') {
 990:	fdc42783          	lw	a5,-36(s0)
 994:	0007871b          	sext.w	a4,a5
 998:	07800793          	li	a5,120
 99c:	02f71463          	bne	a4,a5,9c4 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 9a0:	fb843783          	ld	a5,-72(s0)
 9a4:	00878713          	addi	a4,a5,8
 9a8:	fae43c23          	sd	a4,-72(s0)
 9ac:	4398                	lw	a4,0(a5)
 9ae:	fcc42783          	lw	a5,-52(s0)
 9b2:	4681                	li	a3,0
 9b4:	4641                	li	a2,16
 9b6:	85ba                	mv	a1,a4
 9b8:	853e                	mv	a0,a5
 9ba:	00000097          	auipc	ra,0x0
 9be:	d58080e7          	jalr	-680(ra) # 712 <printint>
 9c2:	aa39                	j	ae0 <vprintf+0x23a>
      } else if(c == 'p') {
 9c4:	fdc42783          	lw	a5,-36(s0)
 9c8:	0007871b          	sext.w	a4,a5
 9cc:	07000793          	li	a5,112
 9d0:	02f71263          	bne	a4,a5,9f4 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9d4:	fb843783          	ld	a5,-72(s0)
 9d8:	00878713          	addi	a4,a5,8
 9dc:	fae43c23          	sd	a4,-72(s0)
 9e0:	6398                	ld	a4,0(a5)
 9e2:	fcc42783          	lw	a5,-52(s0)
 9e6:	85ba                	mv	a1,a4
 9e8:	853e                	mv	a0,a5
 9ea:	00000097          	auipc	ra,0x0
 9ee:	e30080e7          	jalr	-464(ra) # 81a <printptr>
 9f2:	a0fd                	j	ae0 <vprintf+0x23a>
      } else if(c == 's'){
 9f4:	fdc42783          	lw	a5,-36(s0)
 9f8:	0007871b          	sext.w	a4,a5
 9fc:	07300793          	li	a5,115
 a00:	04f71c63          	bne	a4,a5,a58 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a04:	fb843783          	ld	a5,-72(s0)
 a08:	00878713          	addi	a4,a5,8
 a0c:	fae43c23          	sd	a4,-72(s0)
 a10:	639c                	ld	a5,0(a5)
 a12:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a16:	fe843783          	ld	a5,-24(s0)
 a1a:	eb8d                	bnez	a5,a4c <vprintf+0x1a6>
          s = "(null)";
 a1c:	00000797          	auipc	a5,0x0
 a20:	4cc78793          	addi	a5,a5,1228 # ee8 <malloc+0x192>
 a24:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a28:	a015                	j	a4c <vprintf+0x1a6>
          putc(fd, *s);
 a2a:	fe843783          	ld	a5,-24(s0)
 a2e:	0007c703          	lbu	a4,0(a5)
 a32:	fcc42783          	lw	a5,-52(s0)
 a36:	85ba                	mv	a1,a4
 a38:	853e                	mv	a0,a5
 a3a:	00000097          	auipc	ra,0x0
 a3e:	ca2080e7          	jalr	-862(ra) # 6dc <putc>
          s++;
 a42:	fe843783          	ld	a5,-24(s0)
 a46:	0785                	addi	a5,a5,1
 a48:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a4c:	fe843783          	ld	a5,-24(s0)
 a50:	0007c783          	lbu	a5,0(a5)
 a54:	fbf9                	bnez	a5,a2a <vprintf+0x184>
 a56:	a069                	j	ae0 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a58:	fdc42783          	lw	a5,-36(s0)
 a5c:	0007871b          	sext.w	a4,a5
 a60:	06300793          	li	a5,99
 a64:	02f71463          	bne	a4,a5,a8c <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a68:	fb843783          	ld	a5,-72(s0)
 a6c:	00878713          	addi	a4,a5,8
 a70:	fae43c23          	sd	a4,-72(s0)
 a74:	439c                	lw	a5,0(a5)
 a76:	0ff7f713          	zext.b	a4,a5
 a7a:	fcc42783          	lw	a5,-52(s0)
 a7e:	85ba                	mv	a1,a4
 a80:	853e                	mv	a0,a5
 a82:	00000097          	auipc	ra,0x0
 a86:	c5a080e7          	jalr	-934(ra) # 6dc <putc>
 a8a:	a899                	j	ae0 <vprintf+0x23a>
      } else if(c == '%'){
 a8c:	fdc42783          	lw	a5,-36(s0)
 a90:	0007871b          	sext.w	a4,a5
 a94:	02500793          	li	a5,37
 a98:	00f71f63          	bne	a4,a5,ab6 <vprintf+0x210>
        putc(fd, c);
 a9c:	fdc42783          	lw	a5,-36(s0)
 aa0:	0ff7f713          	zext.b	a4,a5
 aa4:	fcc42783          	lw	a5,-52(s0)
 aa8:	85ba                	mv	a1,a4
 aaa:	853e                	mv	a0,a5
 aac:	00000097          	auipc	ra,0x0
 ab0:	c30080e7          	jalr	-976(ra) # 6dc <putc>
 ab4:	a035                	j	ae0 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ab6:	fcc42783          	lw	a5,-52(s0)
 aba:	02500593          	li	a1,37
 abe:	853e                	mv	a0,a5
 ac0:	00000097          	auipc	ra,0x0
 ac4:	c1c080e7          	jalr	-996(ra) # 6dc <putc>
        putc(fd, c);
 ac8:	fdc42783          	lw	a5,-36(s0)
 acc:	0ff7f713          	zext.b	a4,a5
 ad0:	fcc42783          	lw	a5,-52(s0)
 ad4:	85ba                	mv	a1,a4
 ad6:	853e                	mv	a0,a5
 ad8:	00000097          	auipc	ra,0x0
 adc:	c04080e7          	jalr	-1020(ra) # 6dc <putc>
      }
      state = 0;
 ae0:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 ae4:	fe442783          	lw	a5,-28(s0)
 ae8:	2785                	addiw	a5,a5,1
 aea:	fef42223          	sw	a5,-28(s0)
 aee:	fe442783          	lw	a5,-28(s0)
 af2:	fc043703          	ld	a4,-64(s0)
 af6:	97ba                	add	a5,a5,a4
 af8:	0007c783          	lbu	a5,0(a5)
 afc:	dc0795e3          	bnez	a5,8c6 <vprintf+0x20>
    }
  }
}
 b00:	0001                	nop
 b02:	0001                	nop
 b04:	60a6                	ld	ra,72(sp)
 b06:	6406                	ld	s0,64(sp)
 b08:	6161                	addi	sp,sp,80
 b0a:	8082                	ret

0000000000000b0c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b0c:	7159                	addi	sp,sp,-112
 b0e:	fc06                	sd	ra,56(sp)
 b10:	f822                	sd	s0,48(sp)
 b12:	0080                	addi	s0,sp,64
 b14:	fcb43823          	sd	a1,-48(s0)
 b18:	e010                	sd	a2,0(s0)
 b1a:	e414                	sd	a3,8(s0)
 b1c:	e818                	sd	a4,16(s0)
 b1e:	ec1c                	sd	a5,24(s0)
 b20:	03043023          	sd	a6,32(s0)
 b24:	03143423          	sd	a7,40(s0)
 b28:	87aa                	mv	a5,a0
 b2a:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b2e:	03040793          	addi	a5,s0,48
 b32:	fcf43423          	sd	a5,-56(s0)
 b36:	fc843783          	ld	a5,-56(s0)
 b3a:	fd078793          	addi	a5,a5,-48
 b3e:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b42:	fe843703          	ld	a4,-24(s0)
 b46:	fdc42783          	lw	a5,-36(s0)
 b4a:	863a                	mv	a2,a4
 b4c:	fd043583          	ld	a1,-48(s0)
 b50:	853e                	mv	a0,a5
 b52:	00000097          	auipc	ra,0x0
 b56:	d54080e7          	jalr	-684(ra) # 8a6 <vprintf>
}
 b5a:	0001                	nop
 b5c:	70e2                	ld	ra,56(sp)
 b5e:	7442                	ld	s0,48(sp)
 b60:	6165                	addi	sp,sp,112
 b62:	8082                	ret

0000000000000b64 <printf>:

void
printf(const char *fmt, ...)
{
 b64:	7159                	addi	sp,sp,-112
 b66:	f406                	sd	ra,40(sp)
 b68:	f022                	sd	s0,32(sp)
 b6a:	1800                	addi	s0,sp,48
 b6c:	fca43c23          	sd	a0,-40(s0)
 b70:	e40c                	sd	a1,8(s0)
 b72:	e810                	sd	a2,16(s0)
 b74:	ec14                	sd	a3,24(s0)
 b76:	f018                	sd	a4,32(s0)
 b78:	f41c                	sd	a5,40(s0)
 b7a:	03043823          	sd	a6,48(s0)
 b7e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b82:	04040793          	addi	a5,s0,64
 b86:	fcf43823          	sd	a5,-48(s0)
 b8a:	fd043783          	ld	a5,-48(s0)
 b8e:	fc878793          	addi	a5,a5,-56
 b92:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 b96:	fe843783          	ld	a5,-24(s0)
 b9a:	863e                	mv	a2,a5
 b9c:	fd843583          	ld	a1,-40(s0)
 ba0:	4505                	li	a0,1
 ba2:	00000097          	auipc	ra,0x0
 ba6:	d04080e7          	jalr	-764(ra) # 8a6 <vprintf>
}
 baa:	0001                	nop
 bac:	70a2                	ld	ra,40(sp)
 bae:	7402                	ld	s0,32(sp)
 bb0:	6165                	addi	sp,sp,112
 bb2:	8082                	ret

0000000000000bb4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bb4:	7179                	addi	sp,sp,-48
 bb6:	f422                	sd	s0,40(sp)
 bb8:	1800                	addi	s0,sp,48
 bba:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bbe:	fd843783          	ld	a5,-40(s0)
 bc2:	17c1                	addi	a5,a5,-16
 bc4:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc8:	00001797          	auipc	a5,0x1
 bcc:	9f878793          	addi	a5,a5,-1544 # 15c0 <freep>
 bd0:	639c                	ld	a5,0(a5)
 bd2:	fef43423          	sd	a5,-24(s0)
 bd6:	a815                	j	c0a <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bd8:	fe843783          	ld	a5,-24(s0)
 bdc:	639c                	ld	a5,0(a5)
 bde:	fe843703          	ld	a4,-24(s0)
 be2:	00f76f63          	bltu	a4,a5,c00 <free+0x4c>
 be6:	fe043703          	ld	a4,-32(s0)
 bea:	fe843783          	ld	a5,-24(s0)
 bee:	02e7eb63          	bltu	a5,a4,c24 <free+0x70>
 bf2:	fe843783          	ld	a5,-24(s0)
 bf6:	639c                	ld	a5,0(a5)
 bf8:	fe043703          	ld	a4,-32(s0)
 bfc:	02f76463          	bltu	a4,a5,c24 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c00:	fe843783          	ld	a5,-24(s0)
 c04:	639c                	ld	a5,0(a5)
 c06:	fef43423          	sd	a5,-24(s0)
 c0a:	fe043703          	ld	a4,-32(s0)
 c0e:	fe843783          	ld	a5,-24(s0)
 c12:	fce7f3e3          	bgeu	a5,a4,bd8 <free+0x24>
 c16:	fe843783          	ld	a5,-24(s0)
 c1a:	639c                	ld	a5,0(a5)
 c1c:	fe043703          	ld	a4,-32(s0)
 c20:	faf77ce3          	bgeu	a4,a5,bd8 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c24:	fe043783          	ld	a5,-32(s0)
 c28:	479c                	lw	a5,8(a5)
 c2a:	1782                	slli	a5,a5,0x20
 c2c:	9381                	srli	a5,a5,0x20
 c2e:	0792                	slli	a5,a5,0x4
 c30:	fe043703          	ld	a4,-32(s0)
 c34:	973e                	add	a4,a4,a5
 c36:	fe843783          	ld	a5,-24(s0)
 c3a:	639c                	ld	a5,0(a5)
 c3c:	02f71763          	bne	a4,a5,c6a <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 c40:	fe043783          	ld	a5,-32(s0)
 c44:	4798                	lw	a4,8(a5)
 c46:	fe843783          	ld	a5,-24(s0)
 c4a:	639c                	ld	a5,0(a5)
 c4c:	479c                	lw	a5,8(a5)
 c4e:	9fb9                	addw	a5,a5,a4
 c50:	0007871b          	sext.w	a4,a5
 c54:	fe043783          	ld	a5,-32(s0)
 c58:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c5a:	fe843783          	ld	a5,-24(s0)
 c5e:	639c                	ld	a5,0(a5)
 c60:	6398                	ld	a4,0(a5)
 c62:	fe043783          	ld	a5,-32(s0)
 c66:	e398                	sd	a4,0(a5)
 c68:	a039                	j	c76 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 c6a:	fe843783          	ld	a5,-24(s0)
 c6e:	6398                	ld	a4,0(a5)
 c70:	fe043783          	ld	a5,-32(s0)
 c74:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c76:	fe843783          	ld	a5,-24(s0)
 c7a:	479c                	lw	a5,8(a5)
 c7c:	1782                	slli	a5,a5,0x20
 c7e:	9381                	srli	a5,a5,0x20
 c80:	0792                	slli	a5,a5,0x4
 c82:	fe843703          	ld	a4,-24(s0)
 c86:	97ba                	add	a5,a5,a4
 c88:	fe043703          	ld	a4,-32(s0)
 c8c:	02f71563          	bne	a4,a5,cb6 <free+0x102>
    p->s.size += bp->s.size;
 c90:	fe843783          	ld	a5,-24(s0)
 c94:	4798                	lw	a4,8(a5)
 c96:	fe043783          	ld	a5,-32(s0)
 c9a:	479c                	lw	a5,8(a5)
 c9c:	9fb9                	addw	a5,a5,a4
 c9e:	0007871b          	sext.w	a4,a5
 ca2:	fe843783          	ld	a5,-24(s0)
 ca6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ca8:	fe043783          	ld	a5,-32(s0)
 cac:	6398                	ld	a4,0(a5)
 cae:	fe843783          	ld	a5,-24(s0)
 cb2:	e398                	sd	a4,0(a5)
 cb4:	a031                	j	cc0 <free+0x10c>
  } else
    p->s.ptr = bp;
 cb6:	fe843783          	ld	a5,-24(s0)
 cba:	fe043703          	ld	a4,-32(s0)
 cbe:	e398                	sd	a4,0(a5)
  freep = p;
 cc0:	00001797          	auipc	a5,0x1
 cc4:	90078793          	addi	a5,a5,-1792 # 15c0 <freep>
 cc8:	fe843703          	ld	a4,-24(s0)
 ccc:	e398                	sd	a4,0(a5)
}
 cce:	0001                	nop
 cd0:	7422                	ld	s0,40(sp)
 cd2:	6145                	addi	sp,sp,48
 cd4:	8082                	ret

0000000000000cd6 <morecore>:

static Header*
morecore(uint nu)
{
 cd6:	7179                	addi	sp,sp,-48
 cd8:	f406                	sd	ra,40(sp)
 cda:	f022                	sd	s0,32(sp)
 cdc:	1800                	addi	s0,sp,48
 cde:	87aa                	mv	a5,a0
 ce0:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 ce4:	fdc42783          	lw	a5,-36(s0)
 ce8:	0007871b          	sext.w	a4,a5
 cec:	6785                	lui	a5,0x1
 cee:	00f77563          	bgeu	a4,a5,cf8 <morecore+0x22>
    nu = 4096;
 cf2:	6785                	lui	a5,0x1
 cf4:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 cf8:	fdc42783          	lw	a5,-36(s0)
 cfc:	0047979b          	slliw	a5,a5,0x4
 d00:	2781                	sext.w	a5,a5
 d02:	2781                	sext.w	a5,a5
 d04:	853e                	mv	a0,a5
 d06:	00000097          	auipc	ra,0x0
 d0a:	9ae080e7          	jalr	-1618(ra) # 6b4 <sbrk>
 d0e:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d12:	fe843703          	ld	a4,-24(s0)
 d16:	57fd                	li	a5,-1
 d18:	00f71463          	bne	a4,a5,d20 <morecore+0x4a>
    return 0;
 d1c:	4781                	li	a5,0
 d1e:	a03d                	j	d4c <morecore+0x76>
  hp = (Header*)p;
 d20:	fe843783          	ld	a5,-24(s0)
 d24:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d28:	fe043783          	ld	a5,-32(s0)
 d2c:	fdc42703          	lw	a4,-36(s0)
 d30:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d32:	fe043783          	ld	a5,-32(s0)
 d36:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x2ba>
 d38:	853e                	mv	a0,a5
 d3a:	00000097          	auipc	ra,0x0
 d3e:	e7a080e7          	jalr	-390(ra) # bb4 <free>
  return freep;
 d42:	00001797          	auipc	a5,0x1
 d46:	87e78793          	addi	a5,a5,-1922 # 15c0 <freep>
 d4a:	639c                	ld	a5,0(a5)
}
 d4c:	853e                	mv	a0,a5
 d4e:	70a2                	ld	ra,40(sp)
 d50:	7402                	ld	s0,32(sp)
 d52:	6145                	addi	sp,sp,48
 d54:	8082                	ret

0000000000000d56 <malloc>:

void*
malloc(uint nbytes)
{
 d56:	7139                	addi	sp,sp,-64
 d58:	fc06                	sd	ra,56(sp)
 d5a:	f822                	sd	s0,48(sp)
 d5c:	0080                	addi	s0,sp,64
 d5e:	87aa                	mv	a5,a0
 d60:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d64:	fcc46783          	lwu	a5,-52(s0)
 d68:	07bd                	addi	a5,a5,15
 d6a:	8391                	srli	a5,a5,0x4
 d6c:	2781                	sext.w	a5,a5
 d6e:	2785                	addiw	a5,a5,1
 d70:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d74:	00001797          	auipc	a5,0x1
 d78:	84c78793          	addi	a5,a5,-1972 # 15c0 <freep>
 d7c:	639c                	ld	a5,0(a5)
 d7e:	fef43023          	sd	a5,-32(s0)
 d82:	fe043783          	ld	a5,-32(s0)
 d86:	ef95                	bnez	a5,dc2 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d88:	00001797          	auipc	a5,0x1
 d8c:	82878793          	addi	a5,a5,-2008 # 15b0 <base>
 d90:	fef43023          	sd	a5,-32(s0)
 d94:	00001797          	auipc	a5,0x1
 d98:	82c78793          	addi	a5,a5,-2004 # 15c0 <freep>
 d9c:	fe043703          	ld	a4,-32(s0)
 da0:	e398                	sd	a4,0(a5)
 da2:	00001797          	auipc	a5,0x1
 da6:	81e78793          	addi	a5,a5,-2018 # 15c0 <freep>
 daa:	6398                	ld	a4,0(a5)
 dac:	00001797          	auipc	a5,0x1
 db0:	80478793          	addi	a5,a5,-2044 # 15b0 <base>
 db4:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 db6:	00000797          	auipc	a5,0x0
 dba:	7fa78793          	addi	a5,a5,2042 # 15b0 <base>
 dbe:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dc2:	fe043783          	ld	a5,-32(s0)
 dc6:	639c                	ld	a5,0(a5)
 dc8:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dcc:	fe843783          	ld	a5,-24(s0)
 dd0:	4798                	lw	a4,8(a5)
 dd2:	fdc42783          	lw	a5,-36(s0)
 dd6:	2781                	sext.w	a5,a5
 dd8:	06f76763          	bltu	a4,a5,e46 <malloc+0xf0>
      if(p->s.size == nunits)
 ddc:	fe843783          	ld	a5,-24(s0)
 de0:	4798                	lw	a4,8(a5)
 de2:	fdc42783          	lw	a5,-36(s0)
 de6:	2781                	sext.w	a5,a5
 de8:	00e79963          	bne	a5,a4,dfa <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 dec:	fe843783          	ld	a5,-24(s0)
 df0:	6398                	ld	a4,0(a5)
 df2:	fe043783          	ld	a5,-32(s0)
 df6:	e398                	sd	a4,0(a5)
 df8:	a825                	j	e30 <malloc+0xda>
      else {
        p->s.size -= nunits;
 dfa:	fe843783          	ld	a5,-24(s0)
 dfe:	479c                	lw	a5,8(a5)
 e00:	fdc42703          	lw	a4,-36(s0)
 e04:	9f99                	subw	a5,a5,a4
 e06:	0007871b          	sext.w	a4,a5
 e0a:	fe843783          	ld	a5,-24(s0)
 e0e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e10:	fe843783          	ld	a5,-24(s0)
 e14:	479c                	lw	a5,8(a5)
 e16:	1782                	slli	a5,a5,0x20
 e18:	9381                	srli	a5,a5,0x20
 e1a:	0792                	slli	a5,a5,0x4
 e1c:	fe843703          	ld	a4,-24(s0)
 e20:	97ba                	add	a5,a5,a4
 e22:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e26:	fe843783          	ld	a5,-24(s0)
 e2a:	fdc42703          	lw	a4,-36(s0)
 e2e:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e30:	00000797          	auipc	a5,0x0
 e34:	79078793          	addi	a5,a5,1936 # 15c0 <freep>
 e38:	fe043703          	ld	a4,-32(s0)
 e3c:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e3e:	fe843783          	ld	a5,-24(s0)
 e42:	07c1                	addi	a5,a5,16
 e44:	a091                	j	e88 <malloc+0x132>
    }
    if(p == freep)
 e46:	00000797          	auipc	a5,0x0
 e4a:	77a78793          	addi	a5,a5,1914 # 15c0 <freep>
 e4e:	639c                	ld	a5,0(a5)
 e50:	fe843703          	ld	a4,-24(s0)
 e54:	02f71063          	bne	a4,a5,e74 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e58:	fdc42783          	lw	a5,-36(s0)
 e5c:	853e                	mv	a0,a5
 e5e:	00000097          	auipc	ra,0x0
 e62:	e78080e7          	jalr	-392(ra) # cd6 <morecore>
 e66:	fea43423          	sd	a0,-24(s0)
 e6a:	fe843783          	ld	a5,-24(s0)
 e6e:	e399                	bnez	a5,e74 <malloc+0x11e>
        return 0;
 e70:	4781                	li	a5,0
 e72:	a819                	j	e88 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e74:	fe843783          	ld	a5,-24(s0)
 e78:	fef43023          	sd	a5,-32(s0)
 e7c:	fe843783          	ld	a5,-24(s0)
 e80:	639c                	ld	a5,0(a5)
 e82:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e86:	b799                	j	dcc <malloc+0x76>
  }
}
 e88:	853e                	mv	a0,a5
 e8a:	70e2                	ld	ra,56(sp)
 e8c:	7442                	ld	s0,48(sp)
 e8e:	6121                	addi	sp,sp,64
 e90:	8082                	ret
