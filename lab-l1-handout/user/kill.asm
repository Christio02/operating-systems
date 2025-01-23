
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
   8:	87aa                	mv	a5,a0
   a:	fcb43823          	sd	a1,-48(s0)
   e:	fcf42e23          	sw	a5,-36(s0)
  int i;

  if(argc < 2){
  12:	fdc42783          	lw	a5,-36(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	02e7c063          	blt	a5,a4,3c <main+0x3c>
    fprintf(2, "usage: kill pid...\n");
  20:	00001597          	auipc	a1,0x1
  24:	d8058593          	addi	a1,a1,-640 # da0 <malloc+0x13c>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	9f0080e7          	jalr	-1552(ra) # a1a <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	506080e7          	jalr	1286(ra) # 53a <exit>
  }
  for(i=1; i<argc; i++)
  3c:	4785                	li	a5,1
  3e:	fef42623          	sw	a5,-20(s0)
  42:	a805                	j	72 <main+0x72>
    kill(atoi(argv[i]));
  44:	fec42783          	lw	a5,-20(s0)
  48:	078e                	slli	a5,a5,0x3
  4a:	fd043703          	ld	a4,-48(s0)
  4e:	97ba                	add	a5,a5,a4
  50:	639c                	ld	a5,0(a5)
  52:	853e                	mv	a0,a5
  54:	00000097          	auipc	ra,0x0
  58:	2ec080e7          	jalr	748(ra) # 340 <atoi>
  5c:	87aa                	mv	a5,a0
  5e:	853e                	mv	a0,a5
  60:	00000097          	auipc	ra,0x0
  64:	50a080e7          	jalr	1290(ra) # 56a <kill>
  for(i=1; i<argc; i++)
  68:	fec42783          	lw	a5,-20(s0)
  6c:	2785                	addiw	a5,a5,1
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	873e                	mv	a4,a5
  78:	fdc42783          	lw	a5,-36(s0)
  7c:	2701                	sext.w	a4,a4
  7e:	2781                	sext.w	a5,a5
  80:	fcf742e3          	blt	a4,a5,44 <main+0x44>
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	4b4080e7          	jalr	1204(ra) # 53a <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	49a080e7          	jalr	1178(ra) # 53a <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	7179                	addi	sp,sp,-48
  aa:	f422                	sd	s0,40(sp)
  ac:	1800                	addi	s0,sp,48
  ae:	fca43c23          	sd	a0,-40(s0)
  b2:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  b6:	fd843783          	ld	a5,-40(s0)
  ba:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  be:	0001                	nop
  c0:	fd043703          	ld	a4,-48(s0)
  c4:	00170793          	addi	a5,a4,1
  c8:	fcf43823          	sd	a5,-48(s0)
  cc:	fd843783          	ld	a5,-40(s0)
  d0:	00178693          	addi	a3,a5,1
  d4:	fcd43c23          	sd	a3,-40(s0)
  d8:	00074703          	lbu	a4,0(a4)
  dc:	00e78023          	sb	a4,0(a5)
  e0:	0007c783          	lbu	a5,0(a5)
  e4:	fff1                	bnez	a5,c0 <strcpy+0x18>
    ;
  return os;
  e6:	fe843783          	ld	a5,-24(s0)
}
  ea:	853e                	mv	a0,a5
  ec:	7422                	ld	s0,40(sp)
  ee:	6145                	addi	sp,sp,48
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1101                	addi	sp,sp,-32
  f4:	ec22                	sd	s0,24(sp)
  f6:	1000                	addi	s0,sp,32
  f8:	fea43423          	sd	a0,-24(s0)
  fc:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 100:	a819                	j	116 <strcmp+0x24>
    p++, q++;
 102:	fe843783          	ld	a5,-24(s0)
 106:	0785                	addi	a5,a5,1
 108:	fef43423          	sd	a5,-24(s0)
 10c:	fe043783          	ld	a5,-32(s0)
 110:	0785                	addi	a5,a5,1
 112:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 116:	fe843783          	ld	a5,-24(s0)
 11a:	0007c783          	lbu	a5,0(a5)
 11e:	cb99                	beqz	a5,134 <strcmp+0x42>
 120:	fe843783          	ld	a5,-24(s0)
 124:	0007c703          	lbu	a4,0(a5)
 128:	fe043783          	ld	a5,-32(s0)
 12c:	0007c783          	lbu	a5,0(a5)
 130:	fcf709e3          	beq	a4,a5,102 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 134:	fe843783          	ld	a5,-24(s0)
 138:	0007c783          	lbu	a5,0(a5)
 13c:	0007871b          	sext.w	a4,a5
 140:	fe043783          	ld	a5,-32(s0)
 144:	0007c783          	lbu	a5,0(a5)
 148:	2781                	sext.w	a5,a5
 14a:	40f707bb          	subw	a5,a4,a5
 14e:	2781                	sext.w	a5,a5
}
 150:	853e                	mv	a0,a5
 152:	6462                	ld	s0,24(sp)
 154:	6105                	addi	sp,sp,32
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	7179                	addi	sp,sp,-48
 15a:	f422                	sd	s0,40(sp)
 15c:	1800                	addi	s0,sp,48
 15e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 162:	fe042623          	sw	zero,-20(s0)
 166:	a031                	j	172 <strlen+0x1a>
 168:	fec42783          	lw	a5,-20(s0)
 16c:	2785                	addiw	a5,a5,1
 16e:	fef42623          	sw	a5,-20(s0)
 172:	fec42783          	lw	a5,-20(s0)
 176:	fd843703          	ld	a4,-40(s0)
 17a:	97ba                	add	a5,a5,a4
 17c:	0007c783          	lbu	a5,0(a5)
 180:	f7e5                	bnez	a5,168 <strlen+0x10>
    ;
  return n;
 182:	fec42783          	lw	a5,-20(s0)
}
 186:	853e                	mv	a0,a5
 188:	7422                	ld	s0,40(sp)
 18a:	6145                	addi	sp,sp,48
 18c:	8082                	ret

000000000000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	7179                	addi	sp,sp,-48
 190:	f422                	sd	s0,40(sp)
 192:	1800                	addi	s0,sp,48
 194:	fca43c23          	sd	a0,-40(s0)
 198:	87ae                	mv	a5,a1
 19a:	8732                	mv	a4,a2
 19c:	fcf42a23          	sw	a5,-44(s0)
 1a0:	87ba                	mv	a5,a4
 1a2:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1a6:	fd843783          	ld	a5,-40(s0)
 1aa:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1ae:	fe042623          	sw	zero,-20(s0)
 1b2:	a00d                	j	1d4 <memset+0x46>
    cdst[i] = c;
 1b4:	fec42783          	lw	a5,-20(s0)
 1b8:	fe043703          	ld	a4,-32(s0)
 1bc:	97ba                	add	a5,a5,a4
 1be:	fd442703          	lw	a4,-44(s0)
 1c2:	0ff77713          	zext.b	a4,a4
 1c6:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1ca:	fec42783          	lw	a5,-20(s0)
 1ce:	2785                	addiw	a5,a5,1
 1d0:	fef42623          	sw	a5,-20(s0)
 1d4:	fec42703          	lw	a4,-20(s0)
 1d8:	fd042783          	lw	a5,-48(s0)
 1dc:	2781                	sext.w	a5,a5
 1de:	fcf76be3          	bltu	a4,a5,1b4 <memset+0x26>
  }
  return dst;
 1e2:	fd843783          	ld	a5,-40(s0)
}
 1e6:	853e                	mv	a0,a5
 1e8:	7422                	ld	s0,40(sp)
 1ea:	6145                	addi	sp,sp,48
 1ec:	8082                	ret

00000000000001ee <strchr>:

char*
strchr(const char *s, char c)
{
 1ee:	1101                	addi	sp,sp,-32
 1f0:	ec22                	sd	s0,24(sp)
 1f2:	1000                	addi	s0,sp,32
 1f4:	fea43423          	sd	a0,-24(s0)
 1f8:	87ae                	mv	a5,a1
 1fa:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1fe:	a01d                	j	224 <strchr+0x36>
    if(*s == c)
 200:	fe843783          	ld	a5,-24(s0)
 204:	0007c703          	lbu	a4,0(a5)
 208:	fe744783          	lbu	a5,-25(s0)
 20c:	0ff7f793          	zext.b	a5,a5
 210:	00e79563          	bne	a5,a4,21a <strchr+0x2c>
      return (char*)s;
 214:	fe843783          	ld	a5,-24(s0)
 218:	a821                	j	230 <strchr+0x42>
  for(; *s; s++)
 21a:	fe843783          	ld	a5,-24(s0)
 21e:	0785                	addi	a5,a5,1
 220:	fef43423          	sd	a5,-24(s0)
 224:	fe843783          	ld	a5,-24(s0)
 228:	0007c783          	lbu	a5,0(a5)
 22c:	fbf1                	bnez	a5,200 <strchr+0x12>
  return 0;
 22e:	4781                	li	a5,0
}
 230:	853e                	mv	a0,a5
 232:	6462                	ld	s0,24(sp)
 234:	6105                	addi	sp,sp,32
 236:	8082                	ret

0000000000000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	7179                	addi	sp,sp,-48
 23a:	f406                	sd	ra,40(sp)
 23c:	f022                	sd	s0,32(sp)
 23e:	1800                	addi	s0,sp,48
 240:	fca43c23          	sd	a0,-40(s0)
 244:	87ae                	mv	a5,a1
 246:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24a:	fe042623          	sw	zero,-20(s0)
 24e:	a8a1                	j	2a6 <gets+0x6e>
    cc = read(0, &c, 1);
 250:	fe740793          	addi	a5,s0,-25
 254:	4605                	li	a2,1
 256:	85be                	mv	a1,a5
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	2f8080e7          	jalr	760(ra) # 552 <read>
 262:	87aa                	mv	a5,a0
 264:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 268:	fe842783          	lw	a5,-24(s0)
 26c:	2781                	sext.w	a5,a5
 26e:	04f05763          	blez	a5,2bc <gets+0x84>
      break;
    buf[i++] = c;
 272:	fec42783          	lw	a5,-20(s0)
 276:	0017871b          	addiw	a4,a5,1
 27a:	fee42623          	sw	a4,-20(s0)
 27e:	873e                	mv	a4,a5
 280:	fd843783          	ld	a5,-40(s0)
 284:	97ba                	add	a5,a5,a4
 286:	fe744703          	lbu	a4,-25(s0)
 28a:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 28e:	fe744783          	lbu	a5,-25(s0)
 292:	873e                	mv	a4,a5
 294:	47a9                	li	a5,10
 296:	02f70463          	beq	a4,a5,2be <gets+0x86>
 29a:	fe744783          	lbu	a5,-25(s0)
 29e:	873e                	mv	a4,a5
 2a0:	47b5                	li	a5,13
 2a2:	00f70e63          	beq	a4,a5,2be <gets+0x86>
  for(i=0; i+1 < max; ){
 2a6:	fec42783          	lw	a5,-20(s0)
 2aa:	2785                	addiw	a5,a5,1
 2ac:	0007871b          	sext.w	a4,a5
 2b0:	fd442783          	lw	a5,-44(s0)
 2b4:	2781                	sext.w	a5,a5
 2b6:	f8f74de3          	blt	a4,a5,250 <gets+0x18>
 2ba:	a011                	j	2be <gets+0x86>
      break;
 2bc:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2be:	fec42783          	lw	a5,-20(s0)
 2c2:	fd843703          	ld	a4,-40(s0)
 2c6:	97ba                	add	a5,a5,a4
 2c8:	00078023          	sb	zero,0(a5)
  return buf;
 2cc:	fd843783          	ld	a5,-40(s0)
}
 2d0:	853e                	mv	a0,a5
 2d2:	70a2                	ld	ra,40(sp)
 2d4:	7402                	ld	s0,32(sp)
 2d6:	6145                	addi	sp,sp,48
 2d8:	8082                	ret

00000000000002da <stat>:

int
stat(const char *n, struct stat *st)
{
 2da:	7179                	addi	sp,sp,-48
 2dc:	f406                	sd	ra,40(sp)
 2de:	f022                	sd	s0,32(sp)
 2e0:	1800                	addi	s0,sp,48
 2e2:	fca43c23          	sd	a0,-40(s0)
 2e6:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ea:	4581                	li	a1,0
 2ec:	fd843503          	ld	a0,-40(s0)
 2f0:	00000097          	auipc	ra,0x0
 2f4:	28a080e7          	jalr	650(ra) # 57a <open>
 2f8:	87aa                	mv	a5,a0
 2fa:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2fe:	fec42783          	lw	a5,-20(s0)
 302:	2781                	sext.w	a5,a5
 304:	0007d463          	bgez	a5,30c <stat+0x32>
    return -1;
 308:	57fd                	li	a5,-1
 30a:	a035                	j	336 <stat+0x5c>
  r = fstat(fd, st);
 30c:	fec42783          	lw	a5,-20(s0)
 310:	fd043583          	ld	a1,-48(s0)
 314:	853e                	mv	a0,a5
 316:	00000097          	auipc	ra,0x0
 31a:	27c080e7          	jalr	636(ra) # 592 <fstat>
 31e:	87aa                	mv	a5,a0
 320:	fef42423          	sw	a5,-24(s0)
  close(fd);
 324:	fec42783          	lw	a5,-20(s0)
 328:	853e                	mv	a0,a5
 32a:	00000097          	auipc	ra,0x0
 32e:	238080e7          	jalr	568(ra) # 562 <close>
  return r;
 332:	fe842783          	lw	a5,-24(s0)
}
 336:	853e                	mv	a0,a5
 338:	70a2                	ld	ra,40(sp)
 33a:	7402                	ld	s0,32(sp)
 33c:	6145                	addi	sp,sp,48
 33e:	8082                	ret

0000000000000340 <atoi>:

int
atoi(const char *s)
{
 340:	7179                	addi	sp,sp,-48
 342:	f422                	sd	s0,40(sp)
 344:	1800                	addi	s0,sp,48
 346:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 34a:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 34e:	a81d                	j	384 <atoi+0x44>
    n = n*10 + *s++ - '0';
 350:	fec42783          	lw	a5,-20(s0)
 354:	873e                	mv	a4,a5
 356:	87ba                	mv	a5,a4
 358:	0027979b          	slliw	a5,a5,0x2
 35c:	9fb9                	addw	a5,a5,a4
 35e:	0017979b          	slliw	a5,a5,0x1
 362:	0007871b          	sext.w	a4,a5
 366:	fd843783          	ld	a5,-40(s0)
 36a:	00178693          	addi	a3,a5,1
 36e:	fcd43c23          	sd	a3,-40(s0)
 372:	0007c783          	lbu	a5,0(a5)
 376:	2781                	sext.w	a5,a5
 378:	9fb9                	addw	a5,a5,a4
 37a:	2781                	sext.w	a5,a5
 37c:	fd07879b          	addiw	a5,a5,-48
 380:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 384:	fd843783          	ld	a5,-40(s0)
 388:	0007c783          	lbu	a5,0(a5)
 38c:	873e                	mv	a4,a5
 38e:	02f00793          	li	a5,47
 392:	00e7fb63          	bgeu	a5,a4,3a8 <atoi+0x68>
 396:	fd843783          	ld	a5,-40(s0)
 39a:	0007c783          	lbu	a5,0(a5)
 39e:	873e                	mv	a4,a5
 3a0:	03900793          	li	a5,57
 3a4:	fae7f6e3          	bgeu	a5,a4,350 <atoi+0x10>
  return n;
 3a8:	fec42783          	lw	a5,-20(s0)
}
 3ac:	853e                	mv	a0,a5
 3ae:	7422                	ld	s0,40(sp)
 3b0:	6145                	addi	sp,sp,48
 3b2:	8082                	ret

00000000000003b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b4:	7139                	addi	sp,sp,-64
 3b6:	fc22                	sd	s0,56(sp)
 3b8:	0080                	addi	s0,sp,64
 3ba:	fca43c23          	sd	a0,-40(s0)
 3be:	fcb43823          	sd	a1,-48(s0)
 3c2:	87b2                	mv	a5,a2
 3c4:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3c8:	fd843783          	ld	a5,-40(s0)
 3cc:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3d0:	fd043783          	ld	a5,-48(s0)
 3d4:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3d8:	fe043703          	ld	a4,-32(s0)
 3dc:	fe843783          	ld	a5,-24(s0)
 3e0:	02e7fc63          	bgeu	a5,a4,418 <memmove+0x64>
    while(n-- > 0)
 3e4:	a00d                	j	406 <memmove+0x52>
      *dst++ = *src++;
 3e6:	fe043703          	ld	a4,-32(s0)
 3ea:	00170793          	addi	a5,a4,1
 3ee:	fef43023          	sd	a5,-32(s0)
 3f2:	fe843783          	ld	a5,-24(s0)
 3f6:	00178693          	addi	a3,a5,1
 3fa:	fed43423          	sd	a3,-24(s0)
 3fe:	00074703          	lbu	a4,0(a4)
 402:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 406:	fcc42783          	lw	a5,-52(s0)
 40a:	fff7871b          	addiw	a4,a5,-1
 40e:	fce42623          	sw	a4,-52(s0)
 412:	fcf04ae3          	bgtz	a5,3e6 <memmove+0x32>
 416:	a891                	j	46a <memmove+0xb6>
  } else {
    dst += n;
 418:	fcc42783          	lw	a5,-52(s0)
 41c:	fe843703          	ld	a4,-24(s0)
 420:	97ba                	add	a5,a5,a4
 422:	fef43423          	sd	a5,-24(s0)
    src += n;
 426:	fcc42783          	lw	a5,-52(s0)
 42a:	fe043703          	ld	a4,-32(s0)
 42e:	97ba                	add	a5,a5,a4
 430:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 434:	a01d                	j	45a <memmove+0xa6>
      *--dst = *--src;
 436:	fe043783          	ld	a5,-32(s0)
 43a:	17fd                	addi	a5,a5,-1
 43c:	fef43023          	sd	a5,-32(s0)
 440:	fe843783          	ld	a5,-24(s0)
 444:	17fd                	addi	a5,a5,-1
 446:	fef43423          	sd	a5,-24(s0)
 44a:	fe043783          	ld	a5,-32(s0)
 44e:	0007c703          	lbu	a4,0(a5)
 452:	fe843783          	ld	a5,-24(s0)
 456:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 45a:	fcc42783          	lw	a5,-52(s0)
 45e:	fff7871b          	addiw	a4,a5,-1
 462:	fce42623          	sw	a4,-52(s0)
 466:	fcf048e3          	bgtz	a5,436 <memmove+0x82>
  }
  return vdst;
 46a:	fd843783          	ld	a5,-40(s0)
}
 46e:	853e                	mv	a0,a5
 470:	7462                	ld	s0,56(sp)
 472:	6121                	addi	sp,sp,64
 474:	8082                	ret

0000000000000476 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 476:	7139                	addi	sp,sp,-64
 478:	fc22                	sd	s0,56(sp)
 47a:	0080                	addi	s0,sp,64
 47c:	fca43c23          	sd	a0,-40(s0)
 480:	fcb43823          	sd	a1,-48(s0)
 484:	87b2                	mv	a5,a2
 486:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 48a:	fd843783          	ld	a5,-40(s0)
 48e:	fef43423          	sd	a5,-24(s0)
 492:	fd043783          	ld	a5,-48(s0)
 496:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 49a:	a0a1                	j	4e2 <memcmp+0x6c>
    if (*p1 != *p2) {
 49c:	fe843783          	ld	a5,-24(s0)
 4a0:	0007c703          	lbu	a4,0(a5)
 4a4:	fe043783          	ld	a5,-32(s0)
 4a8:	0007c783          	lbu	a5,0(a5)
 4ac:	02f70163          	beq	a4,a5,4ce <memcmp+0x58>
      return *p1 - *p2;
 4b0:	fe843783          	ld	a5,-24(s0)
 4b4:	0007c783          	lbu	a5,0(a5)
 4b8:	0007871b          	sext.w	a4,a5
 4bc:	fe043783          	ld	a5,-32(s0)
 4c0:	0007c783          	lbu	a5,0(a5)
 4c4:	2781                	sext.w	a5,a5
 4c6:	40f707bb          	subw	a5,a4,a5
 4ca:	2781                	sext.w	a5,a5
 4cc:	a01d                	j	4f2 <memcmp+0x7c>
    }
    p1++;
 4ce:	fe843783          	ld	a5,-24(s0)
 4d2:	0785                	addi	a5,a5,1
 4d4:	fef43423          	sd	a5,-24(s0)
    p2++;
 4d8:	fe043783          	ld	a5,-32(s0)
 4dc:	0785                	addi	a5,a5,1
 4de:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4e2:	fcc42783          	lw	a5,-52(s0)
 4e6:	fff7871b          	addiw	a4,a5,-1
 4ea:	fce42623          	sw	a4,-52(s0)
 4ee:	f7dd                	bnez	a5,49c <memcmp+0x26>
  }
  return 0;
 4f0:	4781                	li	a5,0
}
 4f2:	853e                	mv	a0,a5
 4f4:	7462                	ld	s0,56(sp)
 4f6:	6121                	addi	sp,sp,64
 4f8:	8082                	ret

00000000000004fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4fa:	7179                	addi	sp,sp,-48
 4fc:	f406                	sd	ra,40(sp)
 4fe:	f022                	sd	s0,32(sp)
 500:	1800                	addi	s0,sp,48
 502:	fea43423          	sd	a0,-24(s0)
 506:	feb43023          	sd	a1,-32(s0)
 50a:	87b2                	mv	a5,a2
 50c:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 510:	fdc42783          	lw	a5,-36(s0)
 514:	863e                	mv	a2,a5
 516:	fe043583          	ld	a1,-32(s0)
 51a:	fe843503          	ld	a0,-24(s0)
 51e:	00000097          	auipc	ra,0x0
 522:	e96080e7          	jalr	-362(ra) # 3b4 <memmove>
 526:	87aa                	mv	a5,a0
}
 528:	853e                	mv	a0,a5
 52a:	70a2                	ld	ra,40(sp)
 52c:	7402                	ld	s0,32(sp)
 52e:	6145                	addi	sp,sp,48
 530:	8082                	ret

0000000000000532 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 532:	4885                	li	a7,1
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exit>:
.global exit
exit:
 li a7, SYS_exit
 53a:	4889                	li	a7,2
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <wait>:
.global wait
wait:
 li a7, SYS_wait
 542:	488d                	li	a7,3
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 54a:	4891                	li	a7,4
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <read>:
.global read
read:
 li a7, SYS_read
 552:	4895                	li	a7,5
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <write>:
.global write
write:
 li a7, SYS_write
 55a:	48c1                	li	a7,16
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <close>:
.global close
close:
 li a7, SYS_close
 562:	48d5                	li	a7,21
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <kill>:
.global kill
kill:
 li a7, SYS_kill
 56a:	4899                	li	a7,6
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <exec>:
.global exec
exec:
 li a7, SYS_exec
 572:	489d                	li	a7,7
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <open>:
.global open
open:
 li a7, SYS_open
 57a:	48bd                	li	a7,15
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 582:	48c5                	li	a7,17
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58a:	48c9                	li	a7,18
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 592:	48a1                	li	a7,8
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <link>:
.global link
link:
 li a7, SYS_link
 59a:	48cd                	li	a7,19
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a2:	48d1                	li	a7,20
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5aa:	48a5                	li	a7,9
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b2:	48a9                	li	a7,10
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ba:	48ad                	li	a7,11
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c2:	48b1                	li	a7,12
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ca:	48b5                	li	a7,13
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d2:	48b9                	li	a7,14
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <hello>:
.global hello
hello:
 li a7, SYS_hello
 5da:	48d9                	li	a7,22
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 5e2:	48dd                	li	a7,23
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ea:	1101                	addi	sp,sp,-32
 5ec:	ec06                	sd	ra,24(sp)
 5ee:	e822                	sd	s0,16(sp)
 5f0:	1000                	addi	s0,sp,32
 5f2:	87aa                	mv	a5,a0
 5f4:	872e                	mv	a4,a1
 5f6:	fef42623          	sw	a5,-20(s0)
 5fa:	87ba                	mv	a5,a4
 5fc:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 600:	feb40713          	addi	a4,s0,-21
 604:	fec42783          	lw	a5,-20(s0)
 608:	4605                	li	a2,1
 60a:	85ba                	mv	a1,a4
 60c:	853e                	mv	a0,a5
 60e:	00000097          	auipc	ra,0x0
 612:	f4c080e7          	jalr	-180(ra) # 55a <write>
}
 616:	0001                	nop
 618:	60e2                	ld	ra,24(sp)
 61a:	6442                	ld	s0,16(sp)
 61c:	6105                	addi	sp,sp,32
 61e:	8082                	ret

0000000000000620 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	7139                	addi	sp,sp,-64
 622:	fc06                	sd	ra,56(sp)
 624:	f822                	sd	s0,48(sp)
 626:	0080                	addi	s0,sp,64
 628:	87aa                	mv	a5,a0
 62a:	8736                	mv	a4,a3
 62c:	fcf42623          	sw	a5,-52(s0)
 630:	87ae                	mv	a5,a1
 632:	fcf42423          	sw	a5,-56(s0)
 636:	87b2                	mv	a5,a2
 638:	fcf42223          	sw	a5,-60(s0)
 63c:	87ba                	mv	a5,a4
 63e:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 642:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 646:	fc042783          	lw	a5,-64(s0)
 64a:	2781                	sext.w	a5,a5
 64c:	c38d                	beqz	a5,66e <printint+0x4e>
 64e:	fc842783          	lw	a5,-56(s0)
 652:	2781                	sext.w	a5,a5
 654:	0007dd63          	bgez	a5,66e <printint+0x4e>
    neg = 1;
 658:	4785                	li	a5,1
 65a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 65e:	fc842783          	lw	a5,-56(s0)
 662:	40f007bb          	negw	a5,a5
 666:	2781                	sext.w	a5,a5
 668:	fef42223          	sw	a5,-28(s0)
 66c:	a029                	j	676 <printint+0x56>
  } else {
    x = xx;
 66e:	fc842783          	lw	a5,-56(s0)
 672:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 676:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 67a:	fc442783          	lw	a5,-60(s0)
 67e:	fe442703          	lw	a4,-28(s0)
 682:	02f777bb          	remuw	a5,a4,a5
 686:	0007861b          	sext.w	a2,a5
 68a:	fec42783          	lw	a5,-20(s0)
 68e:	0017871b          	addiw	a4,a5,1
 692:	fee42623          	sw	a4,-20(s0)
 696:	00001697          	auipc	a3,0x1
 69a:	cda68693          	addi	a3,a3,-806 # 1370 <digits>
 69e:	02061713          	slli	a4,a2,0x20
 6a2:	9301                	srli	a4,a4,0x20
 6a4:	9736                	add	a4,a4,a3
 6a6:	00074703          	lbu	a4,0(a4)
 6aa:	17c1                	addi	a5,a5,-16
 6ac:	97a2                	add	a5,a5,s0
 6ae:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6b2:	fc442783          	lw	a5,-60(s0)
 6b6:	fe442703          	lw	a4,-28(s0)
 6ba:	02f757bb          	divuw	a5,a4,a5
 6be:	fef42223          	sw	a5,-28(s0)
 6c2:	fe442783          	lw	a5,-28(s0)
 6c6:	2781                	sext.w	a5,a5
 6c8:	fbcd                	bnez	a5,67a <printint+0x5a>
  if(neg)
 6ca:	fe842783          	lw	a5,-24(s0)
 6ce:	2781                	sext.w	a5,a5
 6d0:	cf85                	beqz	a5,708 <printint+0xe8>
    buf[i++] = '-';
 6d2:	fec42783          	lw	a5,-20(s0)
 6d6:	0017871b          	addiw	a4,a5,1
 6da:	fee42623          	sw	a4,-20(s0)
 6de:	17c1                	addi	a5,a5,-16
 6e0:	97a2                	add	a5,a5,s0
 6e2:	02d00713          	li	a4,45
 6e6:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6ea:	a839                	j	708 <printint+0xe8>
    putc(fd, buf[i]);
 6ec:	fec42783          	lw	a5,-20(s0)
 6f0:	17c1                	addi	a5,a5,-16
 6f2:	97a2                	add	a5,a5,s0
 6f4:	fe07c703          	lbu	a4,-32(a5)
 6f8:	fcc42783          	lw	a5,-52(s0)
 6fc:	85ba                	mv	a1,a4
 6fe:	853e                	mv	a0,a5
 700:	00000097          	auipc	ra,0x0
 704:	eea080e7          	jalr	-278(ra) # 5ea <putc>
  while(--i >= 0)
 708:	fec42783          	lw	a5,-20(s0)
 70c:	37fd                	addiw	a5,a5,-1
 70e:	fef42623          	sw	a5,-20(s0)
 712:	fec42783          	lw	a5,-20(s0)
 716:	2781                	sext.w	a5,a5
 718:	fc07dae3          	bgez	a5,6ec <printint+0xcc>
}
 71c:	0001                	nop
 71e:	0001                	nop
 720:	70e2                	ld	ra,56(sp)
 722:	7442                	ld	s0,48(sp)
 724:	6121                	addi	sp,sp,64
 726:	8082                	ret

0000000000000728 <printptr>:

static void
printptr(int fd, uint64 x) {
 728:	7179                	addi	sp,sp,-48
 72a:	f406                	sd	ra,40(sp)
 72c:	f022                	sd	s0,32(sp)
 72e:	1800                	addi	s0,sp,48
 730:	87aa                	mv	a5,a0
 732:	fcb43823          	sd	a1,-48(s0)
 736:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 73a:	fdc42783          	lw	a5,-36(s0)
 73e:	03000593          	li	a1,48
 742:	853e                	mv	a0,a5
 744:	00000097          	auipc	ra,0x0
 748:	ea6080e7          	jalr	-346(ra) # 5ea <putc>
  putc(fd, 'x');
 74c:	fdc42783          	lw	a5,-36(s0)
 750:	07800593          	li	a1,120
 754:	853e                	mv	a0,a5
 756:	00000097          	auipc	ra,0x0
 75a:	e94080e7          	jalr	-364(ra) # 5ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75e:	fe042623          	sw	zero,-20(s0)
 762:	a82d                	j	79c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 764:	fd043783          	ld	a5,-48(s0)
 768:	93f1                	srli	a5,a5,0x3c
 76a:	00001717          	auipc	a4,0x1
 76e:	c0670713          	addi	a4,a4,-1018 # 1370 <digits>
 772:	97ba                	add	a5,a5,a4
 774:	0007c703          	lbu	a4,0(a5)
 778:	fdc42783          	lw	a5,-36(s0)
 77c:	85ba                	mv	a1,a4
 77e:	853e                	mv	a0,a5
 780:	00000097          	auipc	ra,0x0
 784:	e6a080e7          	jalr	-406(ra) # 5ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 788:	fec42783          	lw	a5,-20(s0)
 78c:	2785                	addiw	a5,a5,1
 78e:	fef42623          	sw	a5,-20(s0)
 792:	fd043783          	ld	a5,-48(s0)
 796:	0792                	slli	a5,a5,0x4
 798:	fcf43823          	sd	a5,-48(s0)
 79c:	fec42783          	lw	a5,-20(s0)
 7a0:	873e                	mv	a4,a5
 7a2:	47bd                	li	a5,15
 7a4:	fce7f0e3          	bgeu	a5,a4,764 <printptr+0x3c>
}
 7a8:	0001                	nop
 7aa:	0001                	nop
 7ac:	70a2                	ld	ra,40(sp)
 7ae:	7402                	ld	s0,32(sp)
 7b0:	6145                	addi	sp,sp,48
 7b2:	8082                	ret

00000000000007b4 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b4:	715d                	addi	sp,sp,-80
 7b6:	e486                	sd	ra,72(sp)
 7b8:	e0a2                	sd	s0,64(sp)
 7ba:	0880                	addi	s0,sp,80
 7bc:	87aa                	mv	a5,a0
 7be:	fcb43023          	sd	a1,-64(s0)
 7c2:	fac43c23          	sd	a2,-72(s0)
 7c6:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7ca:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7ce:	fe042223          	sw	zero,-28(s0)
 7d2:	a42d                	j	9fc <vprintf+0x248>
    c = fmt[i] & 0xff;
 7d4:	fe442783          	lw	a5,-28(s0)
 7d8:	fc043703          	ld	a4,-64(s0)
 7dc:	97ba                	add	a5,a5,a4
 7de:	0007c783          	lbu	a5,0(a5)
 7e2:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7e6:	fe042783          	lw	a5,-32(s0)
 7ea:	2781                	sext.w	a5,a5
 7ec:	eb9d                	bnez	a5,822 <vprintf+0x6e>
      if(c == '%'){
 7ee:	fdc42783          	lw	a5,-36(s0)
 7f2:	0007871b          	sext.w	a4,a5
 7f6:	02500793          	li	a5,37
 7fa:	00f71763          	bne	a4,a5,808 <vprintf+0x54>
        state = '%';
 7fe:	02500793          	li	a5,37
 802:	fef42023          	sw	a5,-32(s0)
 806:	a2f5                	j	9f2 <vprintf+0x23e>
      } else {
        putc(fd, c);
 808:	fdc42783          	lw	a5,-36(s0)
 80c:	0ff7f713          	zext.b	a4,a5
 810:	fcc42783          	lw	a5,-52(s0)
 814:	85ba                	mv	a1,a4
 816:	853e                	mv	a0,a5
 818:	00000097          	auipc	ra,0x0
 81c:	dd2080e7          	jalr	-558(ra) # 5ea <putc>
 820:	aac9                	j	9f2 <vprintf+0x23e>
      }
    } else if(state == '%'){
 822:	fe042783          	lw	a5,-32(s0)
 826:	0007871b          	sext.w	a4,a5
 82a:	02500793          	li	a5,37
 82e:	1cf71263          	bne	a4,a5,9f2 <vprintf+0x23e>
      if(c == 'd'){
 832:	fdc42783          	lw	a5,-36(s0)
 836:	0007871b          	sext.w	a4,a5
 83a:	06400793          	li	a5,100
 83e:	02f71463          	bne	a4,a5,866 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 842:	fb843783          	ld	a5,-72(s0)
 846:	00878713          	addi	a4,a5,8
 84a:	fae43c23          	sd	a4,-72(s0)
 84e:	4398                	lw	a4,0(a5)
 850:	fcc42783          	lw	a5,-52(s0)
 854:	4685                	li	a3,1
 856:	4629                	li	a2,10
 858:	85ba                	mv	a1,a4
 85a:	853e                	mv	a0,a5
 85c:	00000097          	auipc	ra,0x0
 860:	dc4080e7          	jalr	-572(ra) # 620 <printint>
 864:	a269                	j	9ee <vprintf+0x23a>
      } else if(c == 'l') {
 866:	fdc42783          	lw	a5,-36(s0)
 86a:	0007871b          	sext.w	a4,a5
 86e:	06c00793          	li	a5,108
 872:	02f71663          	bne	a4,a5,89e <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 876:	fb843783          	ld	a5,-72(s0)
 87a:	00878713          	addi	a4,a5,8
 87e:	fae43c23          	sd	a4,-72(s0)
 882:	639c                	ld	a5,0(a5)
 884:	0007871b          	sext.w	a4,a5
 888:	fcc42783          	lw	a5,-52(s0)
 88c:	4681                	li	a3,0
 88e:	4629                	li	a2,10
 890:	85ba                	mv	a1,a4
 892:	853e                	mv	a0,a5
 894:	00000097          	auipc	ra,0x0
 898:	d8c080e7          	jalr	-628(ra) # 620 <printint>
 89c:	aa89                	j	9ee <vprintf+0x23a>
      } else if(c == 'x') {
 89e:	fdc42783          	lw	a5,-36(s0)
 8a2:	0007871b          	sext.w	a4,a5
 8a6:	07800793          	li	a5,120
 8aa:	02f71463          	bne	a4,a5,8d2 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8ae:	fb843783          	ld	a5,-72(s0)
 8b2:	00878713          	addi	a4,a5,8
 8b6:	fae43c23          	sd	a4,-72(s0)
 8ba:	4398                	lw	a4,0(a5)
 8bc:	fcc42783          	lw	a5,-52(s0)
 8c0:	4681                	li	a3,0
 8c2:	4641                	li	a2,16
 8c4:	85ba                	mv	a1,a4
 8c6:	853e                	mv	a0,a5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	d58080e7          	jalr	-680(ra) # 620 <printint>
 8d0:	aa39                	j	9ee <vprintf+0x23a>
      } else if(c == 'p') {
 8d2:	fdc42783          	lw	a5,-36(s0)
 8d6:	0007871b          	sext.w	a4,a5
 8da:	07000793          	li	a5,112
 8de:	02f71263          	bne	a4,a5,902 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8e2:	fb843783          	ld	a5,-72(s0)
 8e6:	00878713          	addi	a4,a5,8
 8ea:	fae43c23          	sd	a4,-72(s0)
 8ee:	6398                	ld	a4,0(a5)
 8f0:	fcc42783          	lw	a5,-52(s0)
 8f4:	85ba                	mv	a1,a4
 8f6:	853e                	mv	a0,a5
 8f8:	00000097          	auipc	ra,0x0
 8fc:	e30080e7          	jalr	-464(ra) # 728 <printptr>
 900:	a0fd                	j	9ee <vprintf+0x23a>
      } else if(c == 's'){
 902:	fdc42783          	lw	a5,-36(s0)
 906:	0007871b          	sext.w	a4,a5
 90a:	07300793          	li	a5,115
 90e:	04f71c63          	bne	a4,a5,966 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 912:	fb843783          	ld	a5,-72(s0)
 916:	00878713          	addi	a4,a5,8
 91a:	fae43c23          	sd	a4,-72(s0)
 91e:	639c                	ld	a5,0(a5)
 920:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 924:	fe843783          	ld	a5,-24(s0)
 928:	eb8d                	bnez	a5,95a <vprintf+0x1a6>
          s = "(null)";
 92a:	00000797          	auipc	a5,0x0
 92e:	48e78793          	addi	a5,a5,1166 # db8 <malloc+0x154>
 932:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 936:	a015                	j	95a <vprintf+0x1a6>
          putc(fd, *s);
 938:	fe843783          	ld	a5,-24(s0)
 93c:	0007c703          	lbu	a4,0(a5)
 940:	fcc42783          	lw	a5,-52(s0)
 944:	85ba                	mv	a1,a4
 946:	853e                	mv	a0,a5
 948:	00000097          	auipc	ra,0x0
 94c:	ca2080e7          	jalr	-862(ra) # 5ea <putc>
          s++;
 950:	fe843783          	ld	a5,-24(s0)
 954:	0785                	addi	a5,a5,1
 956:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 95a:	fe843783          	ld	a5,-24(s0)
 95e:	0007c783          	lbu	a5,0(a5)
 962:	fbf9                	bnez	a5,938 <vprintf+0x184>
 964:	a069                	j	9ee <vprintf+0x23a>
        }
      } else if(c == 'c'){
 966:	fdc42783          	lw	a5,-36(s0)
 96a:	0007871b          	sext.w	a4,a5
 96e:	06300793          	li	a5,99
 972:	02f71463          	bne	a4,a5,99a <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 976:	fb843783          	ld	a5,-72(s0)
 97a:	00878713          	addi	a4,a5,8
 97e:	fae43c23          	sd	a4,-72(s0)
 982:	439c                	lw	a5,0(a5)
 984:	0ff7f713          	zext.b	a4,a5
 988:	fcc42783          	lw	a5,-52(s0)
 98c:	85ba                	mv	a1,a4
 98e:	853e                	mv	a0,a5
 990:	00000097          	auipc	ra,0x0
 994:	c5a080e7          	jalr	-934(ra) # 5ea <putc>
 998:	a899                	j	9ee <vprintf+0x23a>
      } else if(c == '%'){
 99a:	fdc42783          	lw	a5,-36(s0)
 99e:	0007871b          	sext.w	a4,a5
 9a2:	02500793          	li	a5,37
 9a6:	00f71f63          	bne	a4,a5,9c4 <vprintf+0x210>
        putc(fd, c);
 9aa:	fdc42783          	lw	a5,-36(s0)
 9ae:	0ff7f713          	zext.b	a4,a5
 9b2:	fcc42783          	lw	a5,-52(s0)
 9b6:	85ba                	mv	a1,a4
 9b8:	853e                	mv	a0,a5
 9ba:	00000097          	auipc	ra,0x0
 9be:	c30080e7          	jalr	-976(ra) # 5ea <putc>
 9c2:	a035                	j	9ee <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9c4:	fcc42783          	lw	a5,-52(s0)
 9c8:	02500593          	li	a1,37
 9cc:	853e                	mv	a0,a5
 9ce:	00000097          	auipc	ra,0x0
 9d2:	c1c080e7          	jalr	-996(ra) # 5ea <putc>
        putc(fd, c);
 9d6:	fdc42783          	lw	a5,-36(s0)
 9da:	0ff7f713          	zext.b	a4,a5
 9de:	fcc42783          	lw	a5,-52(s0)
 9e2:	85ba                	mv	a1,a4
 9e4:	853e                	mv	a0,a5
 9e6:	00000097          	auipc	ra,0x0
 9ea:	c04080e7          	jalr	-1020(ra) # 5ea <putc>
      }
      state = 0;
 9ee:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9f2:	fe442783          	lw	a5,-28(s0)
 9f6:	2785                	addiw	a5,a5,1
 9f8:	fef42223          	sw	a5,-28(s0)
 9fc:	fe442783          	lw	a5,-28(s0)
 a00:	fc043703          	ld	a4,-64(s0)
 a04:	97ba                	add	a5,a5,a4
 a06:	0007c783          	lbu	a5,0(a5)
 a0a:	dc0795e3          	bnez	a5,7d4 <vprintf+0x20>
    }
  }
}
 a0e:	0001                	nop
 a10:	0001                	nop
 a12:	60a6                	ld	ra,72(sp)
 a14:	6406                	ld	s0,64(sp)
 a16:	6161                	addi	sp,sp,80
 a18:	8082                	ret

0000000000000a1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a1a:	7159                	addi	sp,sp,-112
 a1c:	fc06                	sd	ra,56(sp)
 a1e:	f822                	sd	s0,48(sp)
 a20:	0080                	addi	s0,sp,64
 a22:	fcb43823          	sd	a1,-48(s0)
 a26:	e010                	sd	a2,0(s0)
 a28:	e414                	sd	a3,8(s0)
 a2a:	e818                	sd	a4,16(s0)
 a2c:	ec1c                	sd	a5,24(s0)
 a2e:	03043023          	sd	a6,32(s0)
 a32:	03143423          	sd	a7,40(s0)
 a36:	87aa                	mv	a5,a0
 a38:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a3c:	03040793          	addi	a5,s0,48
 a40:	fcf43423          	sd	a5,-56(s0)
 a44:	fc843783          	ld	a5,-56(s0)
 a48:	fd078793          	addi	a5,a5,-48
 a4c:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a50:	fe843703          	ld	a4,-24(s0)
 a54:	fdc42783          	lw	a5,-36(s0)
 a58:	863a                	mv	a2,a4
 a5a:	fd043583          	ld	a1,-48(s0)
 a5e:	853e                	mv	a0,a5
 a60:	00000097          	auipc	ra,0x0
 a64:	d54080e7          	jalr	-684(ra) # 7b4 <vprintf>
}
 a68:	0001                	nop
 a6a:	70e2                	ld	ra,56(sp)
 a6c:	7442                	ld	s0,48(sp)
 a6e:	6165                	addi	sp,sp,112
 a70:	8082                	ret

0000000000000a72 <printf>:

void
printf(const char *fmt, ...)
{
 a72:	7159                	addi	sp,sp,-112
 a74:	f406                	sd	ra,40(sp)
 a76:	f022                	sd	s0,32(sp)
 a78:	1800                	addi	s0,sp,48
 a7a:	fca43c23          	sd	a0,-40(s0)
 a7e:	e40c                	sd	a1,8(s0)
 a80:	e810                	sd	a2,16(s0)
 a82:	ec14                	sd	a3,24(s0)
 a84:	f018                	sd	a4,32(s0)
 a86:	f41c                	sd	a5,40(s0)
 a88:	03043823          	sd	a6,48(s0)
 a8c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a90:	04040793          	addi	a5,s0,64
 a94:	fcf43823          	sd	a5,-48(s0)
 a98:	fd043783          	ld	a5,-48(s0)
 a9c:	fc878793          	addi	a5,a5,-56
 aa0:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 aa4:	fe843783          	ld	a5,-24(s0)
 aa8:	863e                	mv	a2,a5
 aaa:	fd843583          	ld	a1,-40(s0)
 aae:	4505                	li	a0,1
 ab0:	00000097          	auipc	ra,0x0
 ab4:	d04080e7          	jalr	-764(ra) # 7b4 <vprintf>
}
 ab8:	0001                	nop
 aba:	70a2                	ld	ra,40(sp)
 abc:	7402                	ld	s0,32(sp)
 abe:	6165                	addi	sp,sp,112
 ac0:	8082                	ret

0000000000000ac2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ac2:	7179                	addi	sp,sp,-48
 ac4:	f422                	sd	s0,40(sp)
 ac6:	1800                	addi	s0,sp,48
 ac8:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 acc:	fd843783          	ld	a5,-40(s0)
 ad0:	17c1                	addi	a5,a5,-16
 ad2:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad6:	00001797          	auipc	a5,0x1
 ada:	8ca78793          	addi	a5,a5,-1846 # 13a0 <freep>
 ade:	639c                	ld	a5,0(a5)
 ae0:	fef43423          	sd	a5,-24(s0)
 ae4:	a815                	j	b18 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae6:	fe843783          	ld	a5,-24(s0)
 aea:	639c                	ld	a5,0(a5)
 aec:	fe843703          	ld	a4,-24(s0)
 af0:	00f76f63          	bltu	a4,a5,b0e <free+0x4c>
 af4:	fe043703          	ld	a4,-32(s0)
 af8:	fe843783          	ld	a5,-24(s0)
 afc:	02e7eb63          	bltu	a5,a4,b32 <free+0x70>
 b00:	fe843783          	ld	a5,-24(s0)
 b04:	639c                	ld	a5,0(a5)
 b06:	fe043703          	ld	a4,-32(s0)
 b0a:	02f76463          	bltu	a4,a5,b32 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b0e:	fe843783          	ld	a5,-24(s0)
 b12:	639c                	ld	a5,0(a5)
 b14:	fef43423          	sd	a5,-24(s0)
 b18:	fe043703          	ld	a4,-32(s0)
 b1c:	fe843783          	ld	a5,-24(s0)
 b20:	fce7f3e3          	bgeu	a5,a4,ae6 <free+0x24>
 b24:	fe843783          	ld	a5,-24(s0)
 b28:	639c                	ld	a5,0(a5)
 b2a:	fe043703          	ld	a4,-32(s0)
 b2e:	faf77ce3          	bgeu	a4,a5,ae6 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b32:	fe043783          	ld	a5,-32(s0)
 b36:	479c                	lw	a5,8(a5)
 b38:	1782                	slli	a5,a5,0x20
 b3a:	9381                	srli	a5,a5,0x20
 b3c:	0792                	slli	a5,a5,0x4
 b3e:	fe043703          	ld	a4,-32(s0)
 b42:	973e                	add	a4,a4,a5
 b44:	fe843783          	ld	a5,-24(s0)
 b48:	639c                	ld	a5,0(a5)
 b4a:	02f71763          	bne	a4,a5,b78 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b4e:	fe043783          	ld	a5,-32(s0)
 b52:	4798                	lw	a4,8(a5)
 b54:	fe843783          	ld	a5,-24(s0)
 b58:	639c                	ld	a5,0(a5)
 b5a:	479c                	lw	a5,8(a5)
 b5c:	9fb9                	addw	a5,a5,a4
 b5e:	0007871b          	sext.w	a4,a5
 b62:	fe043783          	ld	a5,-32(s0)
 b66:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b68:	fe843783          	ld	a5,-24(s0)
 b6c:	639c                	ld	a5,0(a5)
 b6e:	6398                	ld	a4,0(a5)
 b70:	fe043783          	ld	a5,-32(s0)
 b74:	e398                	sd	a4,0(a5)
 b76:	a039                	j	b84 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b78:	fe843783          	ld	a5,-24(s0)
 b7c:	6398                	ld	a4,0(a5)
 b7e:	fe043783          	ld	a5,-32(s0)
 b82:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	479c                	lw	a5,8(a5)
 b8a:	1782                	slli	a5,a5,0x20
 b8c:	9381                	srli	a5,a5,0x20
 b8e:	0792                	slli	a5,a5,0x4
 b90:	fe843703          	ld	a4,-24(s0)
 b94:	97ba                	add	a5,a5,a4
 b96:	fe043703          	ld	a4,-32(s0)
 b9a:	02f71563          	bne	a4,a5,bc4 <free+0x102>
    p->s.size += bp->s.size;
 b9e:	fe843783          	ld	a5,-24(s0)
 ba2:	4798                	lw	a4,8(a5)
 ba4:	fe043783          	ld	a5,-32(s0)
 ba8:	479c                	lw	a5,8(a5)
 baa:	9fb9                	addw	a5,a5,a4
 bac:	0007871b          	sext.w	a4,a5
 bb0:	fe843783          	ld	a5,-24(s0)
 bb4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bb6:	fe043783          	ld	a5,-32(s0)
 bba:	6398                	ld	a4,0(a5)
 bbc:	fe843783          	ld	a5,-24(s0)
 bc0:	e398                	sd	a4,0(a5)
 bc2:	a031                	j	bce <free+0x10c>
  } else
    p->s.ptr = bp;
 bc4:	fe843783          	ld	a5,-24(s0)
 bc8:	fe043703          	ld	a4,-32(s0)
 bcc:	e398                	sd	a4,0(a5)
  freep = p;
 bce:	00000797          	auipc	a5,0x0
 bd2:	7d278793          	addi	a5,a5,2002 # 13a0 <freep>
 bd6:	fe843703          	ld	a4,-24(s0)
 bda:	e398                	sd	a4,0(a5)
}
 bdc:	0001                	nop
 bde:	7422                	ld	s0,40(sp)
 be0:	6145                	addi	sp,sp,48
 be2:	8082                	ret

0000000000000be4 <morecore>:

static Header*
morecore(uint nu)
{
 be4:	7179                	addi	sp,sp,-48
 be6:	f406                	sd	ra,40(sp)
 be8:	f022                	sd	s0,32(sp)
 bea:	1800                	addi	s0,sp,48
 bec:	87aa                	mv	a5,a0
 bee:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bf2:	fdc42783          	lw	a5,-36(s0)
 bf6:	0007871b          	sext.w	a4,a5
 bfa:	6785                	lui	a5,0x1
 bfc:	00f77563          	bgeu	a4,a5,c06 <morecore+0x22>
    nu = 4096;
 c00:	6785                	lui	a5,0x1
 c02:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c06:	fdc42783          	lw	a5,-36(s0)
 c0a:	0047979b          	slliw	a5,a5,0x4
 c0e:	2781                	sext.w	a5,a5
 c10:	2781                	sext.w	a5,a5
 c12:	853e                	mv	a0,a5
 c14:	00000097          	auipc	ra,0x0
 c18:	9ae080e7          	jalr	-1618(ra) # 5c2 <sbrk>
 c1c:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c20:	fe843703          	ld	a4,-24(s0)
 c24:	57fd                	li	a5,-1
 c26:	00f71463          	bne	a4,a5,c2e <morecore+0x4a>
    return 0;
 c2a:	4781                	li	a5,0
 c2c:	a03d                	j	c5a <morecore+0x76>
  hp = (Header*)p;
 c2e:	fe843783          	ld	a5,-24(s0)
 c32:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c36:	fe043783          	ld	a5,-32(s0)
 c3a:	fdc42703          	lw	a4,-36(s0)
 c3e:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c40:	fe043783          	ld	a5,-32(s0)
 c44:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3ac>
 c46:	853e                	mv	a0,a5
 c48:	00000097          	auipc	ra,0x0
 c4c:	e7a080e7          	jalr	-390(ra) # ac2 <free>
  return freep;
 c50:	00000797          	auipc	a5,0x0
 c54:	75078793          	addi	a5,a5,1872 # 13a0 <freep>
 c58:	639c                	ld	a5,0(a5)
}
 c5a:	853e                	mv	a0,a5
 c5c:	70a2                	ld	ra,40(sp)
 c5e:	7402                	ld	s0,32(sp)
 c60:	6145                	addi	sp,sp,48
 c62:	8082                	ret

0000000000000c64 <malloc>:

void*
malloc(uint nbytes)
{
 c64:	7139                	addi	sp,sp,-64
 c66:	fc06                	sd	ra,56(sp)
 c68:	f822                	sd	s0,48(sp)
 c6a:	0080                	addi	s0,sp,64
 c6c:	87aa                	mv	a5,a0
 c6e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c72:	fcc46783          	lwu	a5,-52(s0)
 c76:	07bd                	addi	a5,a5,15
 c78:	8391                	srli	a5,a5,0x4
 c7a:	2781                	sext.w	a5,a5
 c7c:	2785                	addiw	a5,a5,1
 c7e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c82:	00000797          	auipc	a5,0x0
 c86:	71e78793          	addi	a5,a5,1822 # 13a0 <freep>
 c8a:	639c                	ld	a5,0(a5)
 c8c:	fef43023          	sd	a5,-32(s0)
 c90:	fe043783          	ld	a5,-32(s0)
 c94:	ef95                	bnez	a5,cd0 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c96:	00000797          	auipc	a5,0x0
 c9a:	6fa78793          	addi	a5,a5,1786 # 1390 <base>
 c9e:	fef43023          	sd	a5,-32(s0)
 ca2:	00000797          	auipc	a5,0x0
 ca6:	6fe78793          	addi	a5,a5,1790 # 13a0 <freep>
 caa:	fe043703          	ld	a4,-32(s0)
 cae:	e398                	sd	a4,0(a5)
 cb0:	00000797          	auipc	a5,0x0
 cb4:	6f078793          	addi	a5,a5,1776 # 13a0 <freep>
 cb8:	6398                	ld	a4,0(a5)
 cba:	00000797          	auipc	a5,0x0
 cbe:	6d678793          	addi	a5,a5,1750 # 1390 <base>
 cc2:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cc4:	00000797          	auipc	a5,0x0
 cc8:	6cc78793          	addi	a5,a5,1740 # 1390 <base>
 ccc:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd0:	fe043783          	ld	a5,-32(s0)
 cd4:	639c                	ld	a5,0(a5)
 cd6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cda:	fe843783          	ld	a5,-24(s0)
 cde:	4798                	lw	a4,8(a5)
 ce0:	fdc42783          	lw	a5,-36(s0)
 ce4:	2781                	sext.w	a5,a5
 ce6:	06f76763          	bltu	a4,a5,d54 <malloc+0xf0>
      if(p->s.size == nunits)
 cea:	fe843783          	ld	a5,-24(s0)
 cee:	4798                	lw	a4,8(a5)
 cf0:	fdc42783          	lw	a5,-36(s0)
 cf4:	2781                	sext.w	a5,a5
 cf6:	00e79963          	bne	a5,a4,d08 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cfa:	fe843783          	ld	a5,-24(s0)
 cfe:	6398                	ld	a4,0(a5)
 d00:	fe043783          	ld	a5,-32(s0)
 d04:	e398                	sd	a4,0(a5)
 d06:	a825                	j	d3e <malloc+0xda>
      else {
        p->s.size -= nunits;
 d08:	fe843783          	ld	a5,-24(s0)
 d0c:	479c                	lw	a5,8(a5)
 d0e:	fdc42703          	lw	a4,-36(s0)
 d12:	9f99                	subw	a5,a5,a4
 d14:	0007871b          	sext.w	a4,a5
 d18:	fe843783          	ld	a5,-24(s0)
 d1c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d1e:	fe843783          	ld	a5,-24(s0)
 d22:	479c                	lw	a5,8(a5)
 d24:	1782                	slli	a5,a5,0x20
 d26:	9381                	srli	a5,a5,0x20
 d28:	0792                	slli	a5,a5,0x4
 d2a:	fe843703          	ld	a4,-24(s0)
 d2e:	97ba                	add	a5,a5,a4
 d30:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d34:	fe843783          	ld	a5,-24(s0)
 d38:	fdc42703          	lw	a4,-36(s0)
 d3c:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d3e:	00000797          	auipc	a5,0x0
 d42:	66278793          	addi	a5,a5,1634 # 13a0 <freep>
 d46:	fe043703          	ld	a4,-32(s0)
 d4a:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d4c:	fe843783          	ld	a5,-24(s0)
 d50:	07c1                	addi	a5,a5,16
 d52:	a091                	j	d96 <malloc+0x132>
    }
    if(p == freep)
 d54:	00000797          	auipc	a5,0x0
 d58:	64c78793          	addi	a5,a5,1612 # 13a0 <freep>
 d5c:	639c                	ld	a5,0(a5)
 d5e:	fe843703          	ld	a4,-24(s0)
 d62:	02f71063          	bne	a4,a5,d82 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d66:	fdc42783          	lw	a5,-36(s0)
 d6a:	853e                	mv	a0,a5
 d6c:	00000097          	auipc	ra,0x0
 d70:	e78080e7          	jalr	-392(ra) # be4 <morecore>
 d74:	fea43423          	sd	a0,-24(s0)
 d78:	fe843783          	ld	a5,-24(s0)
 d7c:	e399                	bnez	a5,d82 <malloc+0x11e>
        return 0;
 d7e:	4781                	li	a5,0
 d80:	a819                	j	d96 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d82:	fe843783          	ld	a5,-24(s0)
 d86:	fef43023          	sd	a5,-32(s0)
 d8a:	fe843783          	ld	a5,-24(s0)
 d8e:	639c                	ld	a5,0(a5)
 d90:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d94:	b799                	j	cda <malloc+0x76>
  }
}
 d96:	853e                	mv	a0,a5
 d98:	70e2                	ld	ra,56(sp)
 d9a:	7442                	ld	s0,48(sp)
 d9c:	6121                	addi	sp,sp,64
 d9e:	8082                	ret
