
user/_get_process:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#include "user.h"
#include "../kernel/types.h"  // Add this first
#include "../kernel/stat.h"

int main(int argc, char **argv) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
   8:	87aa                	mv	a5,a0
   a:	fcb43823          	sd	a1,-48(s0)
   e:	fcf42e23          	sw	a5,-36(s0)

  uint64 info = get_process();
  12:	00000097          	auipc	ra,0x0
  16:	59a080e7          	jalr	1434(ra) # 5ac <get_process>
  1a:	87aa                	mv	a5,a0
  1c:	fef43423          	sd	a5,-24(s0)
  int pid = info & 0xFFFFFFFF;
  20:	fe843783          	ld	a5,-24(s0)
  24:	fef42223          	sw	a5,-28(s0)
  int state = (info >> 32) & 0xFFFFFFFF;
  28:	fe843783          	ld	a5,-24(s0)
  2c:	9381                	srli	a5,a5,0x20
  2e:	fef42023          	sw	a5,-32(s0)

  printf("pid = %d, state = %d\n", pid, state);
  32:	fe042703          	lw	a4,-32(s0)
  36:	fe442783          	lw	a5,-28(s0)
  3a:	863a                	mv	a2,a4
  3c:	85be                	mv	a1,a5
  3e:	00001517          	auipc	a0,0x1
  42:	d3250513          	addi	a0,a0,-718 # d70 <malloc+0x142>
  46:	00001097          	auipc	ra,0x1
  4a:	9f6080e7          	jalr	-1546(ra) # a3c <printf>

  exit(0);
  4e:	4501                	li	a0,0
  50:	00000097          	auipc	ra,0x0
  54:	4b4080e7          	jalr	1204(ra) # 504 <exit>

0000000000000058 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  58:	1141                	addi	sp,sp,-16
  5a:	e406                	sd	ra,8(sp)
  5c:	e022                	sd	s0,0(sp)
  5e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  60:	00000097          	auipc	ra,0x0
  64:	fa0080e7          	jalr	-96(ra) # 0 <main>
  exit(0);
  68:	4501                	li	a0,0
  6a:	00000097          	auipc	ra,0x0
  6e:	49a080e7          	jalr	1178(ra) # 504 <exit>

0000000000000072 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  72:	7179                	addi	sp,sp,-48
  74:	f422                	sd	s0,40(sp)
  76:	1800                	addi	s0,sp,48
  78:	fca43c23          	sd	a0,-40(s0)
  7c:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  80:	fd843783          	ld	a5,-40(s0)
  84:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  88:	0001                	nop
  8a:	fd043703          	ld	a4,-48(s0)
  8e:	00170793          	addi	a5,a4,1
  92:	fcf43823          	sd	a5,-48(s0)
  96:	fd843783          	ld	a5,-40(s0)
  9a:	00178693          	addi	a3,a5,1
  9e:	fcd43c23          	sd	a3,-40(s0)
  a2:	00074703          	lbu	a4,0(a4)
  a6:	00e78023          	sb	a4,0(a5)
  aa:	0007c783          	lbu	a5,0(a5)
  ae:	fff1                	bnez	a5,8a <strcpy+0x18>
    ;
  return os;
  b0:	fe843783          	ld	a5,-24(s0)
}
  b4:	853e                	mv	a0,a5
  b6:	7422                	ld	s0,40(sp)
  b8:	6145                	addi	sp,sp,48
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1101                	addi	sp,sp,-32
  be:	ec22                	sd	s0,24(sp)
  c0:	1000                	addi	s0,sp,32
  c2:	fea43423          	sd	a0,-24(s0)
  c6:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  ca:	a819                	j	e0 <strcmp+0x24>
    p++, q++;
  cc:	fe843783          	ld	a5,-24(s0)
  d0:	0785                	addi	a5,a5,1
  d2:	fef43423          	sd	a5,-24(s0)
  d6:	fe043783          	ld	a5,-32(s0)
  da:	0785                	addi	a5,a5,1
  dc:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  e0:	fe843783          	ld	a5,-24(s0)
  e4:	0007c783          	lbu	a5,0(a5)
  e8:	cb99                	beqz	a5,fe <strcmp+0x42>
  ea:	fe843783          	ld	a5,-24(s0)
  ee:	0007c703          	lbu	a4,0(a5)
  f2:	fe043783          	ld	a5,-32(s0)
  f6:	0007c783          	lbu	a5,0(a5)
  fa:	fcf709e3          	beq	a4,a5,cc <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  fe:	fe843783          	ld	a5,-24(s0)
 102:	0007c783          	lbu	a5,0(a5)
 106:	0007871b          	sext.w	a4,a5
 10a:	fe043783          	ld	a5,-32(s0)
 10e:	0007c783          	lbu	a5,0(a5)
 112:	2781                	sext.w	a5,a5
 114:	40f707bb          	subw	a5,a4,a5
 118:	2781                	sext.w	a5,a5
}
 11a:	853e                	mv	a0,a5
 11c:	6462                	ld	s0,24(sp)
 11e:	6105                	addi	sp,sp,32
 120:	8082                	ret

0000000000000122 <strlen>:

uint
strlen(const char *s)
{
 122:	7179                	addi	sp,sp,-48
 124:	f422                	sd	s0,40(sp)
 126:	1800                	addi	s0,sp,48
 128:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 12c:	fe042623          	sw	zero,-20(s0)
 130:	a031                	j	13c <strlen+0x1a>
 132:	fec42783          	lw	a5,-20(s0)
 136:	2785                	addiw	a5,a5,1
 138:	fef42623          	sw	a5,-20(s0)
 13c:	fec42783          	lw	a5,-20(s0)
 140:	fd843703          	ld	a4,-40(s0)
 144:	97ba                	add	a5,a5,a4
 146:	0007c783          	lbu	a5,0(a5)
 14a:	f7e5                	bnez	a5,132 <strlen+0x10>
    ;
  return n;
 14c:	fec42783          	lw	a5,-20(s0)
}
 150:	853e                	mv	a0,a5
 152:	7422                	ld	s0,40(sp)
 154:	6145                	addi	sp,sp,48
 156:	8082                	ret

0000000000000158 <memset>:

void*
memset(void *dst, int c, uint n)
{
 158:	7179                	addi	sp,sp,-48
 15a:	f422                	sd	s0,40(sp)
 15c:	1800                	addi	s0,sp,48
 15e:	fca43c23          	sd	a0,-40(s0)
 162:	87ae                	mv	a5,a1
 164:	8732                	mv	a4,a2
 166:	fcf42a23          	sw	a5,-44(s0)
 16a:	87ba                	mv	a5,a4
 16c:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 170:	fd843783          	ld	a5,-40(s0)
 174:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 178:	fe042623          	sw	zero,-20(s0)
 17c:	a00d                	j	19e <memset+0x46>
    cdst[i] = c;
 17e:	fec42783          	lw	a5,-20(s0)
 182:	fe043703          	ld	a4,-32(s0)
 186:	97ba                	add	a5,a5,a4
 188:	fd442703          	lw	a4,-44(s0)
 18c:	0ff77713          	zext.b	a4,a4
 190:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 194:	fec42783          	lw	a5,-20(s0)
 198:	2785                	addiw	a5,a5,1
 19a:	fef42623          	sw	a5,-20(s0)
 19e:	fec42703          	lw	a4,-20(s0)
 1a2:	fd042783          	lw	a5,-48(s0)
 1a6:	2781                	sext.w	a5,a5
 1a8:	fcf76be3          	bltu	a4,a5,17e <memset+0x26>
  }
  return dst;
 1ac:	fd843783          	ld	a5,-40(s0)
}
 1b0:	853e                	mv	a0,a5
 1b2:	7422                	ld	s0,40(sp)
 1b4:	6145                	addi	sp,sp,48
 1b6:	8082                	ret

00000000000001b8 <strchr>:

char*
strchr(const char *s, char c)
{
 1b8:	1101                	addi	sp,sp,-32
 1ba:	ec22                	sd	s0,24(sp)
 1bc:	1000                	addi	s0,sp,32
 1be:	fea43423          	sd	a0,-24(s0)
 1c2:	87ae                	mv	a5,a1
 1c4:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1c8:	a01d                	j	1ee <strchr+0x36>
    if(*s == c)
 1ca:	fe843783          	ld	a5,-24(s0)
 1ce:	0007c703          	lbu	a4,0(a5)
 1d2:	fe744783          	lbu	a5,-25(s0)
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	00e79563          	bne	a5,a4,1e4 <strchr+0x2c>
      return (char*)s;
 1de:	fe843783          	ld	a5,-24(s0)
 1e2:	a821                	j	1fa <strchr+0x42>
  for(; *s; s++)
 1e4:	fe843783          	ld	a5,-24(s0)
 1e8:	0785                	addi	a5,a5,1
 1ea:	fef43423          	sd	a5,-24(s0)
 1ee:	fe843783          	ld	a5,-24(s0)
 1f2:	0007c783          	lbu	a5,0(a5)
 1f6:	fbf1                	bnez	a5,1ca <strchr+0x12>
  return 0;
 1f8:	4781                	li	a5,0
}
 1fa:	853e                	mv	a0,a5
 1fc:	6462                	ld	s0,24(sp)
 1fe:	6105                	addi	sp,sp,32
 200:	8082                	ret

0000000000000202 <gets>:

char*
gets(char *buf, int max)
{
 202:	7179                	addi	sp,sp,-48
 204:	f406                	sd	ra,40(sp)
 206:	f022                	sd	s0,32(sp)
 208:	1800                	addi	s0,sp,48
 20a:	fca43c23          	sd	a0,-40(s0)
 20e:	87ae                	mv	a5,a1
 210:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 214:	fe042623          	sw	zero,-20(s0)
 218:	a8a1                	j	270 <gets+0x6e>
    cc = read(0, &c, 1);
 21a:	fe740793          	addi	a5,s0,-25
 21e:	4605                	li	a2,1
 220:	85be                	mv	a1,a5
 222:	4501                	li	a0,0
 224:	00000097          	auipc	ra,0x0
 228:	2f8080e7          	jalr	760(ra) # 51c <read>
 22c:	87aa                	mv	a5,a0
 22e:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 232:	fe842783          	lw	a5,-24(s0)
 236:	2781                	sext.w	a5,a5
 238:	04f05763          	blez	a5,286 <gets+0x84>
      break;
    buf[i++] = c;
 23c:	fec42783          	lw	a5,-20(s0)
 240:	0017871b          	addiw	a4,a5,1
 244:	fee42623          	sw	a4,-20(s0)
 248:	873e                	mv	a4,a5
 24a:	fd843783          	ld	a5,-40(s0)
 24e:	97ba                	add	a5,a5,a4
 250:	fe744703          	lbu	a4,-25(s0)
 254:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 258:	fe744783          	lbu	a5,-25(s0)
 25c:	873e                	mv	a4,a5
 25e:	47a9                	li	a5,10
 260:	02f70463          	beq	a4,a5,288 <gets+0x86>
 264:	fe744783          	lbu	a5,-25(s0)
 268:	873e                	mv	a4,a5
 26a:	47b5                	li	a5,13
 26c:	00f70e63          	beq	a4,a5,288 <gets+0x86>
  for(i=0; i+1 < max; ){
 270:	fec42783          	lw	a5,-20(s0)
 274:	2785                	addiw	a5,a5,1
 276:	0007871b          	sext.w	a4,a5
 27a:	fd442783          	lw	a5,-44(s0)
 27e:	2781                	sext.w	a5,a5
 280:	f8f74de3          	blt	a4,a5,21a <gets+0x18>
 284:	a011                	j	288 <gets+0x86>
      break;
 286:	0001                	nop
      break;
  }
  buf[i] = '\0';
 288:	fec42783          	lw	a5,-20(s0)
 28c:	fd843703          	ld	a4,-40(s0)
 290:	97ba                	add	a5,a5,a4
 292:	00078023          	sb	zero,0(a5)
  return buf;
 296:	fd843783          	ld	a5,-40(s0)
}
 29a:	853e                	mv	a0,a5
 29c:	70a2                	ld	ra,40(sp)
 29e:	7402                	ld	s0,32(sp)
 2a0:	6145                	addi	sp,sp,48
 2a2:	8082                	ret

00000000000002a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a4:	7179                	addi	sp,sp,-48
 2a6:	f406                	sd	ra,40(sp)
 2a8:	f022                	sd	s0,32(sp)
 2aa:	1800                	addi	s0,sp,48
 2ac:	fca43c23          	sd	a0,-40(s0)
 2b0:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b4:	4581                	li	a1,0
 2b6:	fd843503          	ld	a0,-40(s0)
 2ba:	00000097          	auipc	ra,0x0
 2be:	28a080e7          	jalr	650(ra) # 544 <open>
 2c2:	87aa                	mv	a5,a0
 2c4:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2c8:	fec42783          	lw	a5,-20(s0)
 2cc:	2781                	sext.w	a5,a5
 2ce:	0007d463          	bgez	a5,2d6 <stat+0x32>
    return -1;
 2d2:	57fd                	li	a5,-1
 2d4:	a035                	j	300 <stat+0x5c>
  r = fstat(fd, st);
 2d6:	fec42783          	lw	a5,-20(s0)
 2da:	fd043583          	ld	a1,-48(s0)
 2de:	853e                	mv	a0,a5
 2e0:	00000097          	auipc	ra,0x0
 2e4:	27c080e7          	jalr	636(ra) # 55c <fstat>
 2e8:	87aa                	mv	a5,a0
 2ea:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2ee:	fec42783          	lw	a5,-20(s0)
 2f2:	853e                	mv	a0,a5
 2f4:	00000097          	auipc	ra,0x0
 2f8:	238080e7          	jalr	568(ra) # 52c <close>
  return r;
 2fc:	fe842783          	lw	a5,-24(s0)
}
 300:	853e                	mv	a0,a5
 302:	70a2                	ld	ra,40(sp)
 304:	7402                	ld	s0,32(sp)
 306:	6145                	addi	sp,sp,48
 308:	8082                	ret

000000000000030a <atoi>:

int
atoi(const char *s)
{
 30a:	7179                	addi	sp,sp,-48
 30c:	f422                	sd	s0,40(sp)
 30e:	1800                	addi	s0,sp,48
 310:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 314:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 318:	a81d                	j	34e <atoi+0x44>
    n = n*10 + *s++ - '0';
 31a:	fec42783          	lw	a5,-20(s0)
 31e:	873e                	mv	a4,a5
 320:	87ba                	mv	a5,a4
 322:	0027979b          	slliw	a5,a5,0x2
 326:	9fb9                	addw	a5,a5,a4
 328:	0017979b          	slliw	a5,a5,0x1
 32c:	0007871b          	sext.w	a4,a5
 330:	fd843783          	ld	a5,-40(s0)
 334:	00178693          	addi	a3,a5,1
 338:	fcd43c23          	sd	a3,-40(s0)
 33c:	0007c783          	lbu	a5,0(a5)
 340:	2781                	sext.w	a5,a5
 342:	9fb9                	addw	a5,a5,a4
 344:	2781                	sext.w	a5,a5
 346:	fd07879b          	addiw	a5,a5,-48
 34a:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 34e:	fd843783          	ld	a5,-40(s0)
 352:	0007c783          	lbu	a5,0(a5)
 356:	873e                	mv	a4,a5
 358:	02f00793          	li	a5,47
 35c:	00e7fb63          	bgeu	a5,a4,372 <atoi+0x68>
 360:	fd843783          	ld	a5,-40(s0)
 364:	0007c783          	lbu	a5,0(a5)
 368:	873e                	mv	a4,a5
 36a:	03900793          	li	a5,57
 36e:	fae7f6e3          	bgeu	a5,a4,31a <atoi+0x10>
  return n;
 372:	fec42783          	lw	a5,-20(s0)
}
 376:	853e                	mv	a0,a5
 378:	7422                	ld	s0,40(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret

000000000000037e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37e:	7139                	addi	sp,sp,-64
 380:	fc22                	sd	s0,56(sp)
 382:	0080                	addi	s0,sp,64
 384:	fca43c23          	sd	a0,-40(s0)
 388:	fcb43823          	sd	a1,-48(s0)
 38c:	87b2                	mv	a5,a2
 38e:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 392:	fd843783          	ld	a5,-40(s0)
 396:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 39a:	fd043783          	ld	a5,-48(s0)
 39e:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3a2:	fe043703          	ld	a4,-32(s0)
 3a6:	fe843783          	ld	a5,-24(s0)
 3aa:	02e7fc63          	bgeu	a5,a4,3e2 <memmove+0x64>
    while(n-- > 0)
 3ae:	a00d                	j	3d0 <memmove+0x52>
      *dst++ = *src++;
 3b0:	fe043703          	ld	a4,-32(s0)
 3b4:	00170793          	addi	a5,a4,1
 3b8:	fef43023          	sd	a5,-32(s0)
 3bc:	fe843783          	ld	a5,-24(s0)
 3c0:	00178693          	addi	a3,a5,1
 3c4:	fed43423          	sd	a3,-24(s0)
 3c8:	00074703          	lbu	a4,0(a4)
 3cc:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3d0:	fcc42783          	lw	a5,-52(s0)
 3d4:	fff7871b          	addiw	a4,a5,-1
 3d8:	fce42623          	sw	a4,-52(s0)
 3dc:	fcf04ae3          	bgtz	a5,3b0 <memmove+0x32>
 3e0:	a891                	j	434 <memmove+0xb6>
  } else {
    dst += n;
 3e2:	fcc42783          	lw	a5,-52(s0)
 3e6:	fe843703          	ld	a4,-24(s0)
 3ea:	97ba                	add	a5,a5,a4
 3ec:	fef43423          	sd	a5,-24(s0)
    src += n;
 3f0:	fcc42783          	lw	a5,-52(s0)
 3f4:	fe043703          	ld	a4,-32(s0)
 3f8:	97ba                	add	a5,a5,a4
 3fa:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 3fe:	a01d                	j	424 <memmove+0xa6>
      *--dst = *--src;
 400:	fe043783          	ld	a5,-32(s0)
 404:	17fd                	addi	a5,a5,-1
 406:	fef43023          	sd	a5,-32(s0)
 40a:	fe843783          	ld	a5,-24(s0)
 40e:	17fd                	addi	a5,a5,-1
 410:	fef43423          	sd	a5,-24(s0)
 414:	fe043783          	ld	a5,-32(s0)
 418:	0007c703          	lbu	a4,0(a5)
 41c:	fe843783          	ld	a5,-24(s0)
 420:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 424:	fcc42783          	lw	a5,-52(s0)
 428:	fff7871b          	addiw	a4,a5,-1
 42c:	fce42623          	sw	a4,-52(s0)
 430:	fcf048e3          	bgtz	a5,400 <memmove+0x82>
  }
  return vdst;
 434:	fd843783          	ld	a5,-40(s0)
}
 438:	853e                	mv	a0,a5
 43a:	7462                	ld	s0,56(sp)
 43c:	6121                	addi	sp,sp,64
 43e:	8082                	ret

0000000000000440 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 440:	7139                	addi	sp,sp,-64
 442:	fc22                	sd	s0,56(sp)
 444:	0080                	addi	s0,sp,64
 446:	fca43c23          	sd	a0,-40(s0)
 44a:	fcb43823          	sd	a1,-48(s0)
 44e:	87b2                	mv	a5,a2
 450:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 454:	fd843783          	ld	a5,-40(s0)
 458:	fef43423          	sd	a5,-24(s0)
 45c:	fd043783          	ld	a5,-48(s0)
 460:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 464:	a0a1                	j	4ac <memcmp+0x6c>
    if (*p1 != *p2) {
 466:	fe843783          	ld	a5,-24(s0)
 46a:	0007c703          	lbu	a4,0(a5)
 46e:	fe043783          	ld	a5,-32(s0)
 472:	0007c783          	lbu	a5,0(a5)
 476:	02f70163          	beq	a4,a5,498 <memcmp+0x58>
      return *p1 - *p2;
 47a:	fe843783          	ld	a5,-24(s0)
 47e:	0007c783          	lbu	a5,0(a5)
 482:	0007871b          	sext.w	a4,a5
 486:	fe043783          	ld	a5,-32(s0)
 48a:	0007c783          	lbu	a5,0(a5)
 48e:	2781                	sext.w	a5,a5
 490:	40f707bb          	subw	a5,a4,a5
 494:	2781                	sext.w	a5,a5
 496:	a01d                	j	4bc <memcmp+0x7c>
    }
    p1++;
 498:	fe843783          	ld	a5,-24(s0)
 49c:	0785                	addi	a5,a5,1
 49e:	fef43423          	sd	a5,-24(s0)
    p2++;
 4a2:	fe043783          	ld	a5,-32(s0)
 4a6:	0785                	addi	a5,a5,1
 4a8:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4ac:	fcc42783          	lw	a5,-52(s0)
 4b0:	fff7871b          	addiw	a4,a5,-1
 4b4:	fce42623          	sw	a4,-52(s0)
 4b8:	f7dd                	bnez	a5,466 <memcmp+0x26>
  }
  return 0;
 4ba:	4781                	li	a5,0
}
 4bc:	853e                	mv	a0,a5
 4be:	7462                	ld	s0,56(sp)
 4c0:	6121                	addi	sp,sp,64
 4c2:	8082                	ret

00000000000004c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c4:	7179                	addi	sp,sp,-48
 4c6:	f406                	sd	ra,40(sp)
 4c8:	f022                	sd	s0,32(sp)
 4ca:	1800                	addi	s0,sp,48
 4cc:	fea43423          	sd	a0,-24(s0)
 4d0:	feb43023          	sd	a1,-32(s0)
 4d4:	87b2                	mv	a5,a2
 4d6:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4da:	fdc42783          	lw	a5,-36(s0)
 4de:	863e                	mv	a2,a5
 4e0:	fe043583          	ld	a1,-32(s0)
 4e4:	fe843503          	ld	a0,-24(s0)
 4e8:	00000097          	auipc	ra,0x0
 4ec:	e96080e7          	jalr	-362(ra) # 37e <memmove>
 4f0:	87aa                	mv	a5,a0
}
 4f2:	853e                	mv	a0,a5
 4f4:	70a2                	ld	ra,40(sp)
 4f6:	7402                	ld	s0,32(sp)
 4f8:	6145                	addi	sp,sp,48
 4fa:	8082                	ret

00000000000004fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4fc:	4885                	li	a7,1
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <exit>:
.global exit
exit:
 li a7, SYS_exit
 504:	4889                	li	a7,2
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <wait>:
.global wait
wait:
 li a7, SYS_wait
 50c:	488d                	li	a7,3
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 514:	4891                	li	a7,4
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <read>:
.global read
read:
 li a7, SYS_read
 51c:	4895                	li	a7,5
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <write>:
.global write
write:
 li a7, SYS_write
 524:	48c1                	li	a7,16
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <close>:
.global close
close:
 li a7, SYS_close
 52c:	48d5                	li	a7,21
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <kill>:
.global kill
kill:
 li a7, SYS_kill
 534:	4899                	li	a7,6
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <exec>:
.global exec
exec:
 li a7, SYS_exec
 53c:	489d                	li	a7,7
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <open>:
.global open
open:
 li a7, SYS_open
 544:	48bd                	li	a7,15
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 54c:	48c5                	li	a7,17
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 554:	48c9                	li	a7,18
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55c:	48a1                	li	a7,8
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <link>:
.global link
link:
 li a7, SYS_link
 564:	48cd                	li	a7,19
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 56c:	48d1                	li	a7,20
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 574:	48a5                	li	a7,9
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <dup>:
.global dup
dup:
 li a7, SYS_dup
 57c:	48a9                	li	a7,10
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 584:	48ad                	li	a7,11
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 58c:	48b1                	li	a7,12
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 594:	48b5                	li	a7,13
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59c:	48b9                	li	a7,14
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <hello>:
.global hello
hello:
 li a7, SYS_hello
 5a4:	48d9                	li	a7,22
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 5ac:	48dd                	li	a7,23
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b4:	1101                	addi	sp,sp,-32
 5b6:	ec06                	sd	ra,24(sp)
 5b8:	e822                	sd	s0,16(sp)
 5ba:	1000                	addi	s0,sp,32
 5bc:	87aa                	mv	a5,a0
 5be:	872e                	mv	a4,a1
 5c0:	fef42623          	sw	a5,-20(s0)
 5c4:	87ba                	mv	a5,a4
 5c6:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5ca:	feb40713          	addi	a4,s0,-21
 5ce:	fec42783          	lw	a5,-20(s0)
 5d2:	4605                	li	a2,1
 5d4:	85ba                	mv	a1,a4
 5d6:	853e                	mv	a0,a5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	f4c080e7          	jalr	-180(ra) # 524 <write>
}
 5e0:	0001                	nop
 5e2:	60e2                	ld	ra,24(sp)
 5e4:	6442                	ld	s0,16(sp)
 5e6:	6105                	addi	sp,sp,32
 5e8:	8082                	ret

00000000000005ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ea:	7139                	addi	sp,sp,-64
 5ec:	fc06                	sd	ra,56(sp)
 5ee:	f822                	sd	s0,48(sp)
 5f0:	0080                	addi	s0,sp,64
 5f2:	87aa                	mv	a5,a0
 5f4:	8736                	mv	a4,a3
 5f6:	fcf42623          	sw	a5,-52(s0)
 5fa:	87ae                	mv	a5,a1
 5fc:	fcf42423          	sw	a5,-56(s0)
 600:	87b2                	mv	a5,a2
 602:	fcf42223          	sw	a5,-60(s0)
 606:	87ba                	mv	a5,a4
 608:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 60c:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 610:	fc042783          	lw	a5,-64(s0)
 614:	2781                	sext.w	a5,a5
 616:	c38d                	beqz	a5,638 <printint+0x4e>
 618:	fc842783          	lw	a5,-56(s0)
 61c:	2781                	sext.w	a5,a5
 61e:	0007dd63          	bgez	a5,638 <printint+0x4e>
    neg = 1;
 622:	4785                	li	a5,1
 624:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 628:	fc842783          	lw	a5,-56(s0)
 62c:	40f007bb          	negw	a5,a5
 630:	2781                	sext.w	a5,a5
 632:	fef42223          	sw	a5,-28(s0)
 636:	a029                	j	640 <printint+0x56>
  } else {
    x = xx;
 638:	fc842783          	lw	a5,-56(s0)
 63c:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 640:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 644:	fc442783          	lw	a5,-60(s0)
 648:	fe442703          	lw	a4,-28(s0)
 64c:	02f777bb          	remuw	a5,a4,a5
 650:	0007861b          	sext.w	a2,a5
 654:	fec42783          	lw	a5,-20(s0)
 658:	0017871b          	addiw	a4,a5,1
 65c:	fee42623          	sw	a4,-20(s0)
 660:	00001697          	auipc	a3,0x1
 664:	d1068693          	addi	a3,a3,-752 # 1370 <digits>
 668:	02061713          	slli	a4,a2,0x20
 66c:	9301                	srli	a4,a4,0x20
 66e:	9736                	add	a4,a4,a3
 670:	00074703          	lbu	a4,0(a4)
 674:	17c1                	addi	a5,a5,-16
 676:	97a2                	add	a5,a5,s0
 678:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 67c:	fc442783          	lw	a5,-60(s0)
 680:	fe442703          	lw	a4,-28(s0)
 684:	02f757bb          	divuw	a5,a4,a5
 688:	fef42223          	sw	a5,-28(s0)
 68c:	fe442783          	lw	a5,-28(s0)
 690:	2781                	sext.w	a5,a5
 692:	fbcd                	bnez	a5,644 <printint+0x5a>
  if(neg)
 694:	fe842783          	lw	a5,-24(s0)
 698:	2781                	sext.w	a5,a5
 69a:	cf85                	beqz	a5,6d2 <printint+0xe8>
    buf[i++] = '-';
 69c:	fec42783          	lw	a5,-20(s0)
 6a0:	0017871b          	addiw	a4,a5,1
 6a4:	fee42623          	sw	a4,-20(s0)
 6a8:	17c1                	addi	a5,a5,-16
 6aa:	97a2                	add	a5,a5,s0
 6ac:	02d00713          	li	a4,45
 6b0:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6b4:	a839                	j	6d2 <printint+0xe8>
    putc(fd, buf[i]);
 6b6:	fec42783          	lw	a5,-20(s0)
 6ba:	17c1                	addi	a5,a5,-16
 6bc:	97a2                	add	a5,a5,s0
 6be:	fe07c703          	lbu	a4,-32(a5)
 6c2:	fcc42783          	lw	a5,-52(s0)
 6c6:	85ba                	mv	a1,a4
 6c8:	853e                	mv	a0,a5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	eea080e7          	jalr	-278(ra) # 5b4 <putc>
  while(--i >= 0)
 6d2:	fec42783          	lw	a5,-20(s0)
 6d6:	37fd                	addiw	a5,a5,-1
 6d8:	fef42623          	sw	a5,-20(s0)
 6dc:	fec42783          	lw	a5,-20(s0)
 6e0:	2781                	sext.w	a5,a5
 6e2:	fc07dae3          	bgez	a5,6b6 <printint+0xcc>
}
 6e6:	0001                	nop
 6e8:	0001                	nop
 6ea:	70e2                	ld	ra,56(sp)
 6ec:	7442                	ld	s0,48(sp)
 6ee:	6121                	addi	sp,sp,64
 6f0:	8082                	ret

00000000000006f2 <printptr>:

static void
printptr(int fd, uint64 x) {
 6f2:	7179                	addi	sp,sp,-48
 6f4:	f406                	sd	ra,40(sp)
 6f6:	f022                	sd	s0,32(sp)
 6f8:	1800                	addi	s0,sp,48
 6fa:	87aa                	mv	a5,a0
 6fc:	fcb43823          	sd	a1,-48(s0)
 700:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 704:	fdc42783          	lw	a5,-36(s0)
 708:	03000593          	li	a1,48
 70c:	853e                	mv	a0,a5
 70e:	00000097          	auipc	ra,0x0
 712:	ea6080e7          	jalr	-346(ra) # 5b4 <putc>
  putc(fd, 'x');
 716:	fdc42783          	lw	a5,-36(s0)
 71a:	07800593          	li	a1,120
 71e:	853e                	mv	a0,a5
 720:	00000097          	auipc	ra,0x0
 724:	e94080e7          	jalr	-364(ra) # 5b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 728:	fe042623          	sw	zero,-20(s0)
 72c:	a82d                	j	766 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72e:	fd043783          	ld	a5,-48(s0)
 732:	93f1                	srli	a5,a5,0x3c
 734:	00001717          	auipc	a4,0x1
 738:	c3c70713          	addi	a4,a4,-964 # 1370 <digits>
 73c:	97ba                	add	a5,a5,a4
 73e:	0007c703          	lbu	a4,0(a5)
 742:	fdc42783          	lw	a5,-36(s0)
 746:	85ba                	mv	a1,a4
 748:	853e                	mv	a0,a5
 74a:	00000097          	auipc	ra,0x0
 74e:	e6a080e7          	jalr	-406(ra) # 5b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 752:	fec42783          	lw	a5,-20(s0)
 756:	2785                	addiw	a5,a5,1
 758:	fef42623          	sw	a5,-20(s0)
 75c:	fd043783          	ld	a5,-48(s0)
 760:	0792                	slli	a5,a5,0x4
 762:	fcf43823          	sd	a5,-48(s0)
 766:	fec42783          	lw	a5,-20(s0)
 76a:	873e                	mv	a4,a5
 76c:	47bd                	li	a5,15
 76e:	fce7f0e3          	bgeu	a5,a4,72e <printptr+0x3c>
}
 772:	0001                	nop
 774:	0001                	nop
 776:	70a2                	ld	ra,40(sp)
 778:	7402                	ld	s0,32(sp)
 77a:	6145                	addi	sp,sp,48
 77c:	8082                	ret

000000000000077e <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 77e:	715d                	addi	sp,sp,-80
 780:	e486                	sd	ra,72(sp)
 782:	e0a2                	sd	s0,64(sp)
 784:	0880                	addi	s0,sp,80
 786:	87aa                	mv	a5,a0
 788:	fcb43023          	sd	a1,-64(s0)
 78c:	fac43c23          	sd	a2,-72(s0)
 790:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 794:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 798:	fe042223          	sw	zero,-28(s0)
 79c:	a42d                	j	9c6 <vprintf+0x248>
    c = fmt[i] & 0xff;
 79e:	fe442783          	lw	a5,-28(s0)
 7a2:	fc043703          	ld	a4,-64(s0)
 7a6:	97ba                	add	a5,a5,a4
 7a8:	0007c783          	lbu	a5,0(a5)
 7ac:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7b0:	fe042783          	lw	a5,-32(s0)
 7b4:	2781                	sext.w	a5,a5
 7b6:	eb9d                	bnez	a5,7ec <vprintf+0x6e>
      if(c == '%'){
 7b8:	fdc42783          	lw	a5,-36(s0)
 7bc:	0007871b          	sext.w	a4,a5
 7c0:	02500793          	li	a5,37
 7c4:	00f71763          	bne	a4,a5,7d2 <vprintf+0x54>
        state = '%';
 7c8:	02500793          	li	a5,37
 7cc:	fef42023          	sw	a5,-32(s0)
 7d0:	a2f5                	j	9bc <vprintf+0x23e>
      } else {
        putc(fd, c);
 7d2:	fdc42783          	lw	a5,-36(s0)
 7d6:	0ff7f713          	zext.b	a4,a5
 7da:	fcc42783          	lw	a5,-52(s0)
 7de:	85ba                	mv	a1,a4
 7e0:	853e                	mv	a0,a5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	dd2080e7          	jalr	-558(ra) # 5b4 <putc>
 7ea:	aac9                	j	9bc <vprintf+0x23e>
      }
    } else if(state == '%'){
 7ec:	fe042783          	lw	a5,-32(s0)
 7f0:	0007871b          	sext.w	a4,a5
 7f4:	02500793          	li	a5,37
 7f8:	1cf71263          	bne	a4,a5,9bc <vprintf+0x23e>
      if(c == 'd'){
 7fc:	fdc42783          	lw	a5,-36(s0)
 800:	0007871b          	sext.w	a4,a5
 804:	06400793          	li	a5,100
 808:	02f71463          	bne	a4,a5,830 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 80c:	fb843783          	ld	a5,-72(s0)
 810:	00878713          	addi	a4,a5,8
 814:	fae43c23          	sd	a4,-72(s0)
 818:	4398                	lw	a4,0(a5)
 81a:	fcc42783          	lw	a5,-52(s0)
 81e:	4685                	li	a3,1
 820:	4629                	li	a2,10
 822:	85ba                	mv	a1,a4
 824:	853e                	mv	a0,a5
 826:	00000097          	auipc	ra,0x0
 82a:	dc4080e7          	jalr	-572(ra) # 5ea <printint>
 82e:	a269                	j	9b8 <vprintf+0x23a>
      } else if(c == 'l') {
 830:	fdc42783          	lw	a5,-36(s0)
 834:	0007871b          	sext.w	a4,a5
 838:	06c00793          	li	a5,108
 83c:	02f71663          	bne	a4,a5,868 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 840:	fb843783          	ld	a5,-72(s0)
 844:	00878713          	addi	a4,a5,8
 848:	fae43c23          	sd	a4,-72(s0)
 84c:	639c                	ld	a5,0(a5)
 84e:	0007871b          	sext.w	a4,a5
 852:	fcc42783          	lw	a5,-52(s0)
 856:	4681                	li	a3,0
 858:	4629                	li	a2,10
 85a:	85ba                	mv	a1,a4
 85c:	853e                	mv	a0,a5
 85e:	00000097          	auipc	ra,0x0
 862:	d8c080e7          	jalr	-628(ra) # 5ea <printint>
 866:	aa89                	j	9b8 <vprintf+0x23a>
      } else if(c == 'x') {
 868:	fdc42783          	lw	a5,-36(s0)
 86c:	0007871b          	sext.w	a4,a5
 870:	07800793          	li	a5,120
 874:	02f71463          	bne	a4,a5,89c <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 878:	fb843783          	ld	a5,-72(s0)
 87c:	00878713          	addi	a4,a5,8
 880:	fae43c23          	sd	a4,-72(s0)
 884:	4398                	lw	a4,0(a5)
 886:	fcc42783          	lw	a5,-52(s0)
 88a:	4681                	li	a3,0
 88c:	4641                	li	a2,16
 88e:	85ba                	mv	a1,a4
 890:	853e                	mv	a0,a5
 892:	00000097          	auipc	ra,0x0
 896:	d58080e7          	jalr	-680(ra) # 5ea <printint>
 89a:	aa39                	j	9b8 <vprintf+0x23a>
      } else if(c == 'p') {
 89c:	fdc42783          	lw	a5,-36(s0)
 8a0:	0007871b          	sext.w	a4,a5
 8a4:	07000793          	li	a5,112
 8a8:	02f71263          	bne	a4,a5,8cc <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8ac:	fb843783          	ld	a5,-72(s0)
 8b0:	00878713          	addi	a4,a5,8
 8b4:	fae43c23          	sd	a4,-72(s0)
 8b8:	6398                	ld	a4,0(a5)
 8ba:	fcc42783          	lw	a5,-52(s0)
 8be:	85ba                	mv	a1,a4
 8c0:	853e                	mv	a0,a5
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e30080e7          	jalr	-464(ra) # 6f2 <printptr>
 8ca:	a0fd                	j	9b8 <vprintf+0x23a>
      } else if(c == 's'){
 8cc:	fdc42783          	lw	a5,-36(s0)
 8d0:	0007871b          	sext.w	a4,a5
 8d4:	07300793          	li	a5,115
 8d8:	04f71c63          	bne	a4,a5,930 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8dc:	fb843783          	ld	a5,-72(s0)
 8e0:	00878713          	addi	a4,a5,8
 8e4:	fae43c23          	sd	a4,-72(s0)
 8e8:	639c                	ld	a5,0(a5)
 8ea:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8ee:	fe843783          	ld	a5,-24(s0)
 8f2:	eb8d                	bnez	a5,924 <vprintf+0x1a6>
          s = "(null)";
 8f4:	00000797          	auipc	a5,0x0
 8f8:	49478793          	addi	a5,a5,1172 # d88 <malloc+0x15a>
 8fc:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 900:	a015                	j	924 <vprintf+0x1a6>
          putc(fd, *s);
 902:	fe843783          	ld	a5,-24(s0)
 906:	0007c703          	lbu	a4,0(a5)
 90a:	fcc42783          	lw	a5,-52(s0)
 90e:	85ba                	mv	a1,a4
 910:	853e                	mv	a0,a5
 912:	00000097          	auipc	ra,0x0
 916:	ca2080e7          	jalr	-862(ra) # 5b4 <putc>
          s++;
 91a:	fe843783          	ld	a5,-24(s0)
 91e:	0785                	addi	a5,a5,1
 920:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 924:	fe843783          	ld	a5,-24(s0)
 928:	0007c783          	lbu	a5,0(a5)
 92c:	fbf9                	bnez	a5,902 <vprintf+0x184>
 92e:	a069                	j	9b8 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 930:	fdc42783          	lw	a5,-36(s0)
 934:	0007871b          	sext.w	a4,a5
 938:	06300793          	li	a5,99
 93c:	02f71463          	bne	a4,a5,964 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 940:	fb843783          	ld	a5,-72(s0)
 944:	00878713          	addi	a4,a5,8
 948:	fae43c23          	sd	a4,-72(s0)
 94c:	439c                	lw	a5,0(a5)
 94e:	0ff7f713          	zext.b	a4,a5
 952:	fcc42783          	lw	a5,-52(s0)
 956:	85ba                	mv	a1,a4
 958:	853e                	mv	a0,a5
 95a:	00000097          	auipc	ra,0x0
 95e:	c5a080e7          	jalr	-934(ra) # 5b4 <putc>
 962:	a899                	j	9b8 <vprintf+0x23a>
      } else if(c == '%'){
 964:	fdc42783          	lw	a5,-36(s0)
 968:	0007871b          	sext.w	a4,a5
 96c:	02500793          	li	a5,37
 970:	00f71f63          	bne	a4,a5,98e <vprintf+0x210>
        putc(fd, c);
 974:	fdc42783          	lw	a5,-36(s0)
 978:	0ff7f713          	zext.b	a4,a5
 97c:	fcc42783          	lw	a5,-52(s0)
 980:	85ba                	mv	a1,a4
 982:	853e                	mv	a0,a5
 984:	00000097          	auipc	ra,0x0
 988:	c30080e7          	jalr	-976(ra) # 5b4 <putc>
 98c:	a035                	j	9b8 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 98e:	fcc42783          	lw	a5,-52(s0)
 992:	02500593          	li	a1,37
 996:	853e                	mv	a0,a5
 998:	00000097          	auipc	ra,0x0
 99c:	c1c080e7          	jalr	-996(ra) # 5b4 <putc>
        putc(fd, c);
 9a0:	fdc42783          	lw	a5,-36(s0)
 9a4:	0ff7f713          	zext.b	a4,a5
 9a8:	fcc42783          	lw	a5,-52(s0)
 9ac:	85ba                	mv	a1,a4
 9ae:	853e                	mv	a0,a5
 9b0:	00000097          	auipc	ra,0x0
 9b4:	c04080e7          	jalr	-1020(ra) # 5b4 <putc>
      }
      state = 0;
 9b8:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9bc:	fe442783          	lw	a5,-28(s0)
 9c0:	2785                	addiw	a5,a5,1
 9c2:	fef42223          	sw	a5,-28(s0)
 9c6:	fe442783          	lw	a5,-28(s0)
 9ca:	fc043703          	ld	a4,-64(s0)
 9ce:	97ba                	add	a5,a5,a4
 9d0:	0007c783          	lbu	a5,0(a5)
 9d4:	dc0795e3          	bnez	a5,79e <vprintf+0x20>
    }
  }
}
 9d8:	0001                	nop
 9da:	0001                	nop
 9dc:	60a6                	ld	ra,72(sp)
 9de:	6406                	ld	s0,64(sp)
 9e0:	6161                	addi	sp,sp,80
 9e2:	8082                	ret

00000000000009e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9e4:	7159                	addi	sp,sp,-112
 9e6:	fc06                	sd	ra,56(sp)
 9e8:	f822                	sd	s0,48(sp)
 9ea:	0080                	addi	s0,sp,64
 9ec:	fcb43823          	sd	a1,-48(s0)
 9f0:	e010                	sd	a2,0(s0)
 9f2:	e414                	sd	a3,8(s0)
 9f4:	e818                	sd	a4,16(s0)
 9f6:	ec1c                	sd	a5,24(s0)
 9f8:	03043023          	sd	a6,32(s0)
 9fc:	03143423          	sd	a7,40(s0)
 a00:	87aa                	mv	a5,a0
 a02:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a06:	03040793          	addi	a5,s0,48
 a0a:	fcf43423          	sd	a5,-56(s0)
 a0e:	fc843783          	ld	a5,-56(s0)
 a12:	fd078793          	addi	a5,a5,-48
 a16:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a1a:	fe843703          	ld	a4,-24(s0)
 a1e:	fdc42783          	lw	a5,-36(s0)
 a22:	863a                	mv	a2,a4
 a24:	fd043583          	ld	a1,-48(s0)
 a28:	853e                	mv	a0,a5
 a2a:	00000097          	auipc	ra,0x0
 a2e:	d54080e7          	jalr	-684(ra) # 77e <vprintf>
}
 a32:	0001                	nop
 a34:	70e2                	ld	ra,56(sp)
 a36:	7442                	ld	s0,48(sp)
 a38:	6165                	addi	sp,sp,112
 a3a:	8082                	ret

0000000000000a3c <printf>:

void
printf(const char *fmt, ...)
{
 a3c:	7159                	addi	sp,sp,-112
 a3e:	f406                	sd	ra,40(sp)
 a40:	f022                	sd	s0,32(sp)
 a42:	1800                	addi	s0,sp,48
 a44:	fca43c23          	sd	a0,-40(s0)
 a48:	e40c                	sd	a1,8(s0)
 a4a:	e810                	sd	a2,16(s0)
 a4c:	ec14                	sd	a3,24(s0)
 a4e:	f018                	sd	a4,32(s0)
 a50:	f41c                	sd	a5,40(s0)
 a52:	03043823          	sd	a6,48(s0)
 a56:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a5a:	04040793          	addi	a5,s0,64
 a5e:	fcf43823          	sd	a5,-48(s0)
 a62:	fd043783          	ld	a5,-48(s0)
 a66:	fc878793          	addi	a5,a5,-56
 a6a:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a6e:	fe843783          	ld	a5,-24(s0)
 a72:	863e                	mv	a2,a5
 a74:	fd843583          	ld	a1,-40(s0)
 a78:	4505                	li	a0,1
 a7a:	00000097          	auipc	ra,0x0
 a7e:	d04080e7          	jalr	-764(ra) # 77e <vprintf>
}
 a82:	0001                	nop
 a84:	70a2                	ld	ra,40(sp)
 a86:	7402                	ld	s0,32(sp)
 a88:	6165                	addi	sp,sp,112
 a8a:	8082                	ret

0000000000000a8c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a8c:	7179                	addi	sp,sp,-48
 a8e:	f422                	sd	s0,40(sp)
 a90:	1800                	addi	s0,sp,48
 a92:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a96:	fd843783          	ld	a5,-40(s0)
 a9a:	17c1                	addi	a5,a5,-16
 a9c:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa0:	00001797          	auipc	a5,0x1
 aa4:	90078793          	addi	a5,a5,-1792 # 13a0 <freep>
 aa8:	639c                	ld	a5,0(a5)
 aaa:	fef43423          	sd	a5,-24(s0)
 aae:	a815                	j	ae2 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab0:	fe843783          	ld	a5,-24(s0)
 ab4:	639c                	ld	a5,0(a5)
 ab6:	fe843703          	ld	a4,-24(s0)
 aba:	00f76f63          	bltu	a4,a5,ad8 <free+0x4c>
 abe:	fe043703          	ld	a4,-32(s0)
 ac2:	fe843783          	ld	a5,-24(s0)
 ac6:	02e7eb63          	bltu	a5,a4,afc <free+0x70>
 aca:	fe843783          	ld	a5,-24(s0)
 ace:	639c                	ld	a5,0(a5)
 ad0:	fe043703          	ld	a4,-32(s0)
 ad4:	02f76463          	bltu	a4,a5,afc <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad8:	fe843783          	ld	a5,-24(s0)
 adc:	639c                	ld	a5,0(a5)
 ade:	fef43423          	sd	a5,-24(s0)
 ae2:	fe043703          	ld	a4,-32(s0)
 ae6:	fe843783          	ld	a5,-24(s0)
 aea:	fce7f3e3          	bgeu	a5,a4,ab0 <free+0x24>
 aee:	fe843783          	ld	a5,-24(s0)
 af2:	639c                	ld	a5,0(a5)
 af4:	fe043703          	ld	a4,-32(s0)
 af8:	faf77ce3          	bgeu	a4,a5,ab0 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 afc:	fe043783          	ld	a5,-32(s0)
 b00:	479c                	lw	a5,8(a5)
 b02:	1782                	slli	a5,a5,0x20
 b04:	9381                	srli	a5,a5,0x20
 b06:	0792                	slli	a5,a5,0x4
 b08:	fe043703          	ld	a4,-32(s0)
 b0c:	973e                	add	a4,a4,a5
 b0e:	fe843783          	ld	a5,-24(s0)
 b12:	639c                	ld	a5,0(a5)
 b14:	02f71763          	bne	a4,a5,b42 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b18:	fe043783          	ld	a5,-32(s0)
 b1c:	4798                	lw	a4,8(a5)
 b1e:	fe843783          	ld	a5,-24(s0)
 b22:	639c                	ld	a5,0(a5)
 b24:	479c                	lw	a5,8(a5)
 b26:	9fb9                	addw	a5,a5,a4
 b28:	0007871b          	sext.w	a4,a5
 b2c:	fe043783          	ld	a5,-32(s0)
 b30:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b32:	fe843783          	ld	a5,-24(s0)
 b36:	639c                	ld	a5,0(a5)
 b38:	6398                	ld	a4,0(a5)
 b3a:	fe043783          	ld	a5,-32(s0)
 b3e:	e398                	sd	a4,0(a5)
 b40:	a039                	j	b4e <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b42:	fe843783          	ld	a5,-24(s0)
 b46:	6398                	ld	a4,0(a5)
 b48:	fe043783          	ld	a5,-32(s0)
 b4c:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b4e:	fe843783          	ld	a5,-24(s0)
 b52:	479c                	lw	a5,8(a5)
 b54:	1782                	slli	a5,a5,0x20
 b56:	9381                	srli	a5,a5,0x20
 b58:	0792                	slli	a5,a5,0x4
 b5a:	fe843703          	ld	a4,-24(s0)
 b5e:	97ba                	add	a5,a5,a4
 b60:	fe043703          	ld	a4,-32(s0)
 b64:	02f71563          	bne	a4,a5,b8e <free+0x102>
    p->s.size += bp->s.size;
 b68:	fe843783          	ld	a5,-24(s0)
 b6c:	4798                	lw	a4,8(a5)
 b6e:	fe043783          	ld	a5,-32(s0)
 b72:	479c                	lw	a5,8(a5)
 b74:	9fb9                	addw	a5,a5,a4
 b76:	0007871b          	sext.w	a4,a5
 b7a:	fe843783          	ld	a5,-24(s0)
 b7e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b80:	fe043783          	ld	a5,-32(s0)
 b84:	6398                	ld	a4,0(a5)
 b86:	fe843783          	ld	a5,-24(s0)
 b8a:	e398                	sd	a4,0(a5)
 b8c:	a031                	j	b98 <free+0x10c>
  } else
    p->s.ptr = bp;
 b8e:	fe843783          	ld	a5,-24(s0)
 b92:	fe043703          	ld	a4,-32(s0)
 b96:	e398                	sd	a4,0(a5)
  freep = p;
 b98:	00001797          	auipc	a5,0x1
 b9c:	80878793          	addi	a5,a5,-2040 # 13a0 <freep>
 ba0:	fe843703          	ld	a4,-24(s0)
 ba4:	e398                	sd	a4,0(a5)
}
 ba6:	0001                	nop
 ba8:	7422                	ld	s0,40(sp)
 baa:	6145                	addi	sp,sp,48
 bac:	8082                	ret

0000000000000bae <morecore>:

static Header*
morecore(uint nu)
{
 bae:	7179                	addi	sp,sp,-48
 bb0:	f406                	sd	ra,40(sp)
 bb2:	f022                	sd	s0,32(sp)
 bb4:	1800                	addi	s0,sp,48
 bb6:	87aa                	mv	a5,a0
 bb8:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bbc:	fdc42783          	lw	a5,-36(s0)
 bc0:	0007871b          	sext.w	a4,a5
 bc4:	6785                	lui	a5,0x1
 bc6:	00f77563          	bgeu	a4,a5,bd0 <morecore+0x22>
    nu = 4096;
 bca:	6785                	lui	a5,0x1
 bcc:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bd0:	fdc42783          	lw	a5,-36(s0)
 bd4:	0047979b          	slliw	a5,a5,0x4
 bd8:	2781                	sext.w	a5,a5
 bda:	2781                	sext.w	a5,a5
 bdc:	853e                	mv	a0,a5
 bde:	00000097          	auipc	ra,0x0
 be2:	9ae080e7          	jalr	-1618(ra) # 58c <sbrk>
 be6:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bea:	fe843703          	ld	a4,-24(s0)
 bee:	57fd                	li	a5,-1
 bf0:	00f71463          	bne	a4,a5,bf8 <morecore+0x4a>
    return 0;
 bf4:	4781                	li	a5,0
 bf6:	a03d                	j	c24 <morecore+0x76>
  hp = (Header*)p;
 bf8:	fe843783          	ld	a5,-24(s0)
 bfc:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c00:	fe043783          	ld	a5,-32(s0)
 c04:	fdc42703          	lw	a4,-36(s0)
 c08:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c0a:	fe043783          	ld	a5,-32(s0)
 c0e:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3e2>
 c10:	853e                	mv	a0,a5
 c12:	00000097          	auipc	ra,0x0
 c16:	e7a080e7          	jalr	-390(ra) # a8c <free>
  return freep;
 c1a:	00000797          	auipc	a5,0x0
 c1e:	78678793          	addi	a5,a5,1926 # 13a0 <freep>
 c22:	639c                	ld	a5,0(a5)
}
 c24:	853e                	mv	a0,a5
 c26:	70a2                	ld	ra,40(sp)
 c28:	7402                	ld	s0,32(sp)
 c2a:	6145                	addi	sp,sp,48
 c2c:	8082                	ret

0000000000000c2e <malloc>:

void*
malloc(uint nbytes)
{
 c2e:	7139                	addi	sp,sp,-64
 c30:	fc06                	sd	ra,56(sp)
 c32:	f822                	sd	s0,48(sp)
 c34:	0080                	addi	s0,sp,64
 c36:	87aa                	mv	a5,a0
 c38:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c3c:	fcc46783          	lwu	a5,-52(s0)
 c40:	07bd                	addi	a5,a5,15
 c42:	8391                	srli	a5,a5,0x4
 c44:	2781                	sext.w	a5,a5
 c46:	2785                	addiw	a5,a5,1
 c48:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c4c:	00000797          	auipc	a5,0x0
 c50:	75478793          	addi	a5,a5,1876 # 13a0 <freep>
 c54:	639c                	ld	a5,0(a5)
 c56:	fef43023          	sd	a5,-32(s0)
 c5a:	fe043783          	ld	a5,-32(s0)
 c5e:	ef95                	bnez	a5,c9a <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c60:	00000797          	auipc	a5,0x0
 c64:	73078793          	addi	a5,a5,1840 # 1390 <base>
 c68:	fef43023          	sd	a5,-32(s0)
 c6c:	00000797          	auipc	a5,0x0
 c70:	73478793          	addi	a5,a5,1844 # 13a0 <freep>
 c74:	fe043703          	ld	a4,-32(s0)
 c78:	e398                	sd	a4,0(a5)
 c7a:	00000797          	auipc	a5,0x0
 c7e:	72678793          	addi	a5,a5,1830 # 13a0 <freep>
 c82:	6398                	ld	a4,0(a5)
 c84:	00000797          	auipc	a5,0x0
 c88:	70c78793          	addi	a5,a5,1804 # 1390 <base>
 c8c:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c8e:	00000797          	auipc	a5,0x0
 c92:	70278793          	addi	a5,a5,1794 # 1390 <base>
 c96:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c9a:	fe043783          	ld	a5,-32(s0)
 c9e:	639c                	ld	a5,0(a5)
 ca0:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 ca4:	fe843783          	ld	a5,-24(s0)
 ca8:	4798                	lw	a4,8(a5)
 caa:	fdc42783          	lw	a5,-36(s0)
 cae:	2781                	sext.w	a5,a5
 cb0:	06f76763          	bltu	a4,a5,d1e <malloc+0xf0>
      if(p->s.size == nunits)
 cb4:	fe843783          	ld	a5,-24(s0)
 cb8:	4798                	lw	a4,8(a5)
 cba:	fdc42783          	lw	a5,-36(s0)
 cbe:	2781                	sext.w	a5,a5
 cc0:	00e79963          	bne	a5,a4,cd2 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cc4:	fe843783          	ld	a5,-24(s0)
 cc8:	6398                	ld	a4,0(a5)
 cca:	fe043783          	ld	a5,-32(s0)
 cce:	e398                	sd	a4,0(a5)
 cd0:	a825                	j	d08 <malloc+0xda>
      else {
        p->s.size -= nunits;
 cd2:	fe843783          	ld	a5,-24(s0)
 cd6:	479c                	lw	a5,8(a5)
 cd8:	fdc42703          	lw	a4,-36(s0)
 cdc:	9f99                	subw	a5,a5,a4
 cde:	0007871b          	sext.w	a4,a5
 ce2:	fe843783          	ld	a5,-24(s0)
 ce6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ce8:	fe843783          	ld	a5,-24(s0)
 cec:	479c                	lw	a5,8(a5)
 cee:	1782                	slli	a5,a5,0x20
 cf0:	9381                	srli	a5,a5,0x20
 cf2:	0792                	slli	a5,a5,0x4
 cf4:	fe843703          	ld	a4,-24(s0)
 cf8:	97ba                	add	a5,a5,a4
 cfa:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cfe:	fe843783          	ld	a5,-24(s0)
 d02:	fdc42703          	lw	a4,-36(s0)
 d06:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d08:	00000797          	auipc	a5,0x0
 d0c:	69878793          	addi	a5,a5,1688 # 13a0 <freep>
 d10:	fe043703          	ld	a4,-32(s0)
 d14:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d16:	fe843783          	ld	a5,-24(s0)
 d1a:	07c1                	addi	a5,a5,16
 d1c:	a091                	j	d60 <malloc+0x132>
    }
    if(p == freep)
 d1e:	00000797          	auipc	a5,0x0
 d22:	68278793          	addi	a5,a5,1666 # 13a0 <freep>
 d26:	639c                	ld	a5,0(a5)
 d28:	fe843703          	ld	a4,-24(s0)
 d2c:	02f71063          	bne	a4,a5,d4c <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d30:	fdc42783          	lw	a5,-36(s0)
 d34:	853e                	mv	a0,a5
 d36:	00000097          	auipc	ra,0x0
 d3a:	e78080e7          	jalr	-392(ra) # bae <morecore>
 d3e:	fea43423          	sd	a0,-24(s0)
 d42:	fe843783          	ld	a5,-24(s0)
 d46:	e399                	bnez	a5,d4c <malloc+0x11e>
        return 0;
 d48:	4781                	li	a5,0
 d4a:	a819                	j	d60 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d4c:	fe843783          	ld	a5,-24(s0)
 d50:	fef43023          	sd	a5,-32(s0)
 d54:	fe843783          	ld	a5,-24(s0)
 d58:	639c                	ld	a5,0(a5)
 d5a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d5e:	b799                	j	ca4 <malloc+0x76>
  }
}
 d60:	853e                	mv	a0,a5
 d62:	70e2                	ld	ra,56(sp)
 d64:	7442                	ld	s0,48(sp)
 d66:	6121                	addi	sp,sp,64
 d68:	8082                	ret
