
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	4c6080e7          	jalr	1222(ra) # 4ce <fork>
  10:	87aa                	mv	a5,a0
  12:	00f05763          	blez	a5,20 <main+0x20>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	00000097          	auipc	ra,0x0
  1c:	54e080e7          	jalr	1358(ra) # 566 <sleep>
  exit(0);
  20:	4501                	li	a0,0
  22:	00000097          	auipc	ra,0x0
  26:	4b4080e7          	jalr	1204(ra) # 4d6 <exit>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	49a080e7          	jalr	1178(ra) # 4d6 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	7179                	addi	sp,sp,-48
  46:	f422                	sd	s0,40(sp)
  48:	1800                	addi	s0,sp,48
  4a:	fca43c23          	sd	a0,-40(s0)
  4e:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  52:	fd843783          	ld	a5,-40(s0)
  56:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  5a:	0001                	nop
  5c:	fd043703          	ld	a4,-48(s0)
  60:	00170793          	addi	a5,a4,1
  64:	fcf43823          	sd	a5,-48(s0)
  68:	fd843783          	ld	a5,-40(s0)
  6c:	00178693          	addi	a3,a5,1
  70:	fcd43c23          	sd	a3,-40(s0)
  74:	00074703          	lbu	a4,0(a4)
  78:	00e78023          	sb	a4,0(a5)
  7c:	0007c783          	lbu	a5,0(a5)
  80:	fff1                	bnez	a5,5c <strcpy+0x18>
    ;
  return os;
  82:	fe843783          	ld	a5,-24(s0)
}
  86:	853e                	mv	a0,a5
  88:	7422                	ld	s0,40(sp)
  8a:	6145                	addi	sp,sp,48
  8c:	8082                	ret

000000000000008e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8e:	1101                	addi	sp,sp,-32
  90:	ec22                	sd	s0,24(sp)
  92:	1000                	addi	s0,sp,32
  94:	fea43423          	sd	a0,-24(s0)
  98:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  9c:	a819                	j	b2 <strcmp+0x24>
    p++, q++;
  9e:	fe843783          	ld	a5,-24(s0)
  a2:	0785                	addi	a5,a5,1
  a4:	fef43423          	sd	a5,-24(s0)
  a8:	fe043783          	ld	a5,-32(s0)
  ac:	0785                	addi	a5,a5,1
  ae:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  b2:	fe843783          	ld	a5,-24(s0)
  b6:	0007c783          	lbu	a5,0(a5)
  ba:	cb99                	beqz	a5,d0 <strcmp+0x42>
  bc:	fe843783          	ld	a5,-24(s0)
  c0:	0007c703          	lbu	a4,0(a5)
  c4:	fe043783          	ld	a5,-32(s0)
  c8:	0007c783          	lbu	a5,0(a5)
  cc:	fcf709e3          	beq	a4,a5,9e <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  d0:	fe843783          	ld	a5,-24(s0)
  d4:	0007c783          	lbu	a5,0(a5)
  d8:	0007871b          	sext.w	a4,a5
  dc:	fe043783          	ld	a5,-32(s0)
  e0:	0007c783          	lbu	a5,0(a5)
  e4:	2781                	sext.w	a5,a5
  e6:	40f707bb          	subw	a5,a4,a5
  ea:	2781                	sext.w	a5,a5
}
  ec:	853e                	mv	a0,a5
  ee:	6462                	ld	s0,24(sp)
  f0:	6105                	addi	sp,sp,32
  f2:	8082                	ret

00000000000000f4 <strlen>:

uint
strlen(const char *s)
{
  f4:	7179                	addi	sp,sp,-48
  f6:	f422                	sd	s0,40(sp)
  f8:	1800                	addi	s0,sp,48
  fa:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
  fe:	fe042623          	sw	zero,-20(s0)
 102:	a031                	j	10e <strlen+0x1a>
 104:	fec42783          	lw	a5,-20(s0)
 108:	2785                	addiw	a5,a5,1
 10a:	fef42623          	sw	a5,-20(s0)
 10e:	fec42783          	lw	a5,-20(s0)
 112:	fd843703          	ld	a4,-40(s0)
 116:	97ba                	add	a5,a5,a4
 118:	0007c783          	lbu	a5,0(a5)
 11c:	f7e5                	bnez	a5,104 <strlen+0x10>
    ;
  return n;
 11e:	fec42783          	lw	a5,-20(s0)
}
 122:	853e                	mv	a0,a5
 124:	7422                	ld	s0,40(sp)
 126:	6145                	addi	sp,sp,48
 128:	8082                	ret

000000000000012a <memset>:

void*
memset(void *dst, int c, uint n)
{
 12a:	7179                	addi	sp,sp,-48
 12c:	f422                	sd	s0,40(sp)
 12e:	1800                	addi	s0,sp,48
 130:	fca43c23          	sd	a0,-40(s0)
 134:	87ae                	mv	a5,a1
 136:	8732                	mv	a4,a2
 138:	fcf42a23          	sw	a5,-44(s0)
 13c:	87ba                	mv	a5,a4
 13e:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 142:	fd843783          	ld	a5,-40(s0)
 146:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 14a:	fe042623          	sw	zero,-20(s0)
 14e:	a00d                	j	170 <memset+0x46>
    cdst[i] = c;
 150:	fec42783          	lw	a5,-20(s0)
 154:	fe043703          	ld	a4,-32(s0)
 158:	97ba                	add	a5,a5,a4
 15a:	fd442703          	lw	a4,-44(s0)
 15e:	0ff77713          	zext.b	a4,a4
 162:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 166:	fec42783          	lw	a5,-20(s0)
 16a:	2785                	addiw	a5,a5,1
 16c:	fef42623          	sw	a5,-20(s0)
 170:	fec42703          	lw	a4,-20(s0)
 174:	fd042783          	lw	a5,-48(s0)
 178:	2781                	sext.w	a5,a5
 17a:	fcf76be3          	bltu	a4,a5,150 <memset+0x26>
  }
  return dst;
 17e:	fd843783          	ld	a5,-40(s0)
}
 182:	853e                	mv	a0,a5
 184:	7422                	ld	s0,40(sp)
 186:	6145                	addi	sp,sp,48
 188:	8082                	ret

000000000000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	1101                	addi	sp,sp,-32
 18c:	ec22                	sd	s0,24(sp)
 18e:	1000                	addi	s0,sp,32
 190:	fea43423          	sd	a0,-24(s0)
 194:	87ae                	mv	a5,a1
 196:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 19a:	a01d                	j	1c0 <strchr+0x36>
    if(*s == c)
 19c:	fe843783          	ld	a5,-24(s0)
 1a0:	0007c703          	lbu	a4,0(a5)
 1a4:	fe744783          	lbu	a5,-25(s0)
 1a8:	0ff7f793          	zext.b	a5,a5
 1ac:	00e79563          	bne	a5,a4,1b6 <strchr+0x2c>
      return (char*)s;
 1b0:	fe843783          	ld	a5,-24(s0)
 1b4:	a821                	j	1cc <strchr+0x42>
  for(; *s; s++)
 1b6:	fe843783          	ld	a5,-24(s0)
 1ba:	0785                	addi	a5,a5,1
 1bc:	fef43423          	sd	a5,-24(s0)
 1c0:	fe843783          	ld	a5,-24(s0)
 1c4:	0007c783          	lbu	a5,0(a5)
 1c8:	fbf1                	bnez	a5,19c <strchr+0x12>
  return 0;
 1ca:	4781                	li	a5,0
}
 1cc:	853e                	mv	a0,a5
 1ce:	6462                	ld	s0,24(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret

00000000000001d4 <gets>:

char*
gets(char *buf, int max)
{
 1d4:	7179                	addi	sp,sp,-48
 1d6:	f406                	sd	ra,40(sp)
 1d8:	f022                	sd	s0,32(sp)
 1da:	1800                	addi	s0,sp,48
 1dc:	fca43c23          	sd	a0,-40(s0)
 1e0:	87ae                	mv	a5,a1
 1e2:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	fe042623          	sw	zero,-20(s0)
 1ea:	a8a1                	j	242 <gets+0x6e>
    cc = read(0, &c, 1);
 1ec:	fe740793          	addi	a5,s0,-25
 1f0:	4605                	li	a2,1
 1f2:	85be                	mv	a1,a5
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	2f8080e7          	jalr	760(ra) # 4ee <read>
 1fe:	87aa                	mv	a5,a0
 200:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 204:	fe842783          	lw	a5,-24(s0)
 208:	2781                	sext.w	a5,a5
 20a:	04f05763          	blez	a5,258 <gets+0x84>
      break;
    buf[i++] = c;
 20e:	fec42783          	lw	a5,-20(s0)
 212:	0017871b          	addiw	a4,a5,1
 216:	fee42623          	sw	a4,-20(s0)
 21a:	873e                	mv	a4,a5
 21c:	fd843783          	ld	a5,-40(s0)
 220:	97ba                	add	a5,a5,a4
 222:	fe744703          	lbu	a4,-25(s0)
 226:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 22a:	fe744783          	lbu	a5,-25(s0)
 22e:	873e                	mv	a4,a5
 230:	47a9                	li	a5,10
 232:	02f70463          	beq	a4,a5,25a <gets+0x86>
 236:	fe744783          	lbu	a5,-25(s0)
 23a:	873e                	mv	a4,a5
 23c:	47b5                	li	a5,13
 23e:	00f70e63          	beq	a4,a5,25a <gets+0x86>
  for(i=0; i+1 < max; ){
 242:	fec42783          	lw	a5,-20(s0)
 246:	2785                	addiw	a5,a5,1
 248:	0007871b          	sext.w	a4,a5
 24c:	fd442783          	lw	a5,-44(s0)
 250:	2781                	sext.w	a5,a5
 252:	f8f74de3          	blt	a4,a5,1ec <gets+0x18>
 256:	a011                	j	25a <gets+0x86>
      break;
 258:	0001                	nop
      break;
  }
  buf[i] = '\0';
 25a:	fec42783          	lw	a5,-20(s0)
 25e:	fd843703          	ld	a4,-40(s0)
 262:	97ba                	add	a5,a5,a4
 264:	00078023          	sb	zero,0(a5)
  return buf;
 268:	fd843783          	ld	a5,-40(s0)
}
 26c:	853e                	mv	a0,a5
 26e:	70a2                	ld	ra,40(sp)
 270:	7402                	ld	s0,32(sp)
 272:	6145                	addi	sp,sp,48
 274:	8082                	ret

0000000000000276 <stat>:

int
stat(const char *n, struct stat *st)
{
 276:	7179                	addi	sp,sp,-48
 278:	f406                	sd	ra,40(sp)
 27a:	f022                	sd	s0,32(sp)
 27c:	1800                	addi	s0,sp,48
 27e:	fca43c23          	sd	a0,-40(s0)
 282:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	4581                	li	a1,0
 288:	fd843503          	ld	a0,-40(s0)
 28c:	00000097          	auipc	ra,0x0
 290:	28a080e7          	jalr	650(ra) # 516 <open>
 294:	87aa                	mv	a5,a0
 296:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 29a:	fec42783          	lw	a5,-20(s0)
 29e:	2781                	sext.w	a5,a5
 2a0:	0007d463          	bgez	a5,2a8 <stat+0x32>
    return -1;
 2a4:	57fd                	li	a5,-1
 2a6:	a035                	j	2d2 <stat+0x5c>
  r = fstat(fd, st);
 2a8:	fec42783          	lw	a5,-20(s0)
 2ac:	fd043583          	ld	a1,-48(s0)
 2b0:	853e                	mv	a0,a5
 2b2:	00000097          	auipc	ra,0x0
 2b6:	27c080e7          	jalr	636(ra) # 52e <fstat>
 2ba:	87aa                	mv	a5,a0
 2bc:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2c0:	fec42783          	lw	a5,-20(s0)
 2c4:	853e                	mv	a0,a5
 2c6:	00000097          	auipc	ra,0x0
 2ca:	238080e7          	jalr	568(ra) # 4fe <close>
  return r;
 2ce:	fe842783          	lw	a5,-24(s0)
}
 2d2:	853e                	mv	a0,a5
 2d4:	70a2                	ld	ra,40(sp)
 2d6:	7402                	ld	s0,32(sp)
 2d8:	6145                	addi	sp,sp,48
 2da:	8082                	ret

00000000000002dc <atoi>:

int
atoi(const char *s)
{
 2dc:	7179                	addi	sp,sp,-48
 2de:	f422                	sd	s0,40(sp)
 2e0:	1800                	addi	s0,sp,48
 2e2:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 2e6:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 2ea:	a81d                	j	320 <atoi+0x44>
    n = n*10 + *s++ - '0';
 2ec:	fec42783          	lw	a5,-20(s0)
 2f0:	873e                	mv	a4,a5
 2f2:	87ba                	mv	a5,a4
 2f4:	0027979b          	slliw	a5,a5,0x2
 2f8:	9fb9                	addw	a5,a5,a4
 2fa:	0017979b          	slliw	a5,a5,0x1
 2fe:	0007871b          	sext.w	a4,a5
 302:	fd843783          	ld	a5,-40(s0)
 306:	00178693          	addi	a3,a5,1
 30a:	fcd43c23          	sd	a3,-40(s0)
 30e:	0007c783          	lbu	a5,0(a5)
 312:	2781                	sext.w	a5,a5
 314:	9fb9                	addw	a5,a5,a4
 316:	2781                	sext.w	a5,a5
 318:	fd07879b          	addiw	a5,a5,-48
 31c:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 320:	fd843783          	ld	a5,-40(s0)
 324:	0007c783          	lbu	a5,0(a5)
 328:	873e                	mv	a4,a5
 32a:	02f00793          	li	a5,47
 32e:	00e7fb63          	bgeu	a5,a4,344 <atoi+0x68>
 332:	fd843783          	ld	a5,-40(s0)
 336:	0007c783          	lbu	a5,0(a5)
 33a:	873e                	mv	a4,a5
 33c:	03900793          	li	a5,57
 340:	fae7f6e3          	bgeu	a5,a4,2ec <atoi+0x10>
  return n;
 344:	fec42783          	lw	a5,-20(s0)
}
 348:	853e                	mv	a0,a5
 34a:	7422                	ld	s0,40(sp)
 34c:	6145                	addi	sp,sp,48
 34e:	8082                	ret

0000000000000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	7139                	addi	sp,sp,-64
 352:	fc22                	sd	s0,56(sp)
 354:	0080                	addi	s0,sp,64
 356:	fca43c23          	sd	a0,-40(s0)
 35a:	fcb43823          	sd	a1,-48(s0)
 35e:	87b2                	mv	a5,a2
 360:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 364:	fd843783          	ld	a5,-40(s0)
 368:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 36c:	fd043783          	ld	a5,-48(s0)
 370:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 374:	fe043703          	ld	a4,-32(s0)
 378:	fe843783          	ld	a5,-24(s0)
 37c:	02e7fc63          	bgeu	a5,a4,3b4 <memmove+0x64>
    while(n-- > 0)
 380:	a00d                	j	3a2 <memmove+0x52>
      *dst++ = *src++;
 382:	fe043703          	ld	a4,-32(s0)
 386:	00170793          	addi	a5,a4,1
 38a:	fef43023          	sd	a5,-32(s0)
 38e:	fe843783          	ld	a5,-24(s0)
 392:	00178693          	addi	a3,a5,1
 396:	fed43423          	sd	a3,-24(s0)
 39a:	00074703          	lbu	a4,0(a4)
 39e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3a2:	fcc42783          	lw	a5,-52(s0)
 3a6:	fff7871b          	addiw	a4,a5,-1
 3aa:	fce42623          	sw	a4,-52(s0)
 3ae:	fcf04ae3          	bgtz	a5,382 <memmove+0x32>
 3b2:	a891                	j	406 <memmove+0xb6>
  } else {
    dst += n;
 3b4:	fcc42783          	lw	a5,-52(s0)
 3b8:	fe843703          	ld	a4,-24(s0)
 3bc:	97ba                	add	a5,a5,a4
 3be:	fef43423          	sd	a5,-24(s0)
    src += n;
 3c2:	fcc42783          	lw	a5,-52(s0)
 3c6:	fe043703          	ld	a4,-32(s0)
 3ca:	97ba                	add	a5,a5,a4
 3cc:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 3d0:	a01d                	j	3f6 <memmove+0xa6>
      *--dst = *--src;
 3d2:	fe043783          	ld	a5,-32(s0)
 3d6:	17fd                	addi	a5,a5,-1
 3d8:	fef43023          	sd	a5,-32(s0)
 3dc:	fe843783          	ld	a5,-24(s0)
 3e0:	17fd                	addi	a5,a5,-1
 3e2:	fef43423          	sd	a5,-24(s0)
 3e6:	fe043783          	ld	a5,-32(s0)
 3ea:	0007c703          	lbu	a4,0(a5)
 3ee:	fe843783          	ld	a5,-24(s0)
 3f2:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3f6:	fcc42783          	lw	a5,-52(s0)
 3fa:	fff7871b          	addiw	a4,a5,-1
 3fe:	fce42623          	sw	a4,-52(s0)
 402:	fcf048e3          	bgtz	a5,3d2 <memmove+0x82>
  }
  return vdst;
 406:	fd843783          	ld	a5,-40(s0)
}
 40a:	853e                	mv	a0,a5
 40c:	7462                	ld	s0,56(sp)
 40e:	6121                	addi	sp,sp,64
 410:	8082                	ret

0000000000000412 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 412:	7139                	addi	sp,sp,-64
 414:	fc22                	sd	s0,56(sp)
 416:	0080                	addi	s0,sp,64
 418:	fca43c23          	sd	a0,-40(s0)
 41c:	fcb43823          	sd	a1,-48(s0)
 420:	87b2                	mv	a5,a2
 422:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 426:	fd843783          	ld	a5,-40(s0)
 42a:	fef43423          	sd	a5,-24(s0)
 42e:	fd043783          	ld	a5,-48(s0)
 432:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 436:	a0a1                	j	47e <memcmp+0x6c>
    if (*p1 != *p2) {
 438:	fe843783          	ld	a5,-24(s0)
 43c:	0007c703          	lbu	a4,0(a5)
 440:	fe043783          	ld	a5,-32(s0)
 444:	0007c783          	lbu	a5,0(a5)
 448:	02f70163          	beq	a4,a5,46a <memcmp+0x58>
      return *p1 - *p2;
 44c:	fe843783          	ld	a5,-24(s0)
 450:	0007c783          	lbu	a5,0(a5)
 454:	0007871b          	sext.w	a4,a5
 458:	fe043783          	ld	a5,-32(s0)
 45c:	0007c783          	lbu	a5,0(a5)
 460:	2781                	sext.w	a5,a5
 462:	40f707bb          	subw	a5,a4,a5
 466:	2781                	sext.w	a5,a5
 468:	a01d                	j	48e <memcmp+0x7c>
    }
    p1++;
 46a:	fe843783          	ld	a5,-24(s0)
 46e:	0785                	addi	a5,a5,1
 470:	fef43423          	sd	a5,-24(s0)
    p2++;
 474:	fe043783          	ld	a5,-32(s0)
 478:	0785                	addi	a5,a5,1
 47a:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 47e:	fcc42783          	lw	a5,-52(s0)
 482:	fff7871b          	addiw	a4,a5,-1
 486:	fce42623          	sw	a4,-52(s0)
 48a:	f7dd                	bnez	a5,438 <memcmp+0x26>
  }
  return 0;
 48c:	4781                	li	a5,0
}
 48e:	853e                	mv	a0,a5
 490:	7462                	ld	s0,56(sp)
 492:	6121                	addi	sp,sp,64
 494:	8082                	ret

0000000000000496 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 496:	7179                	addi	sp,sp,-48
 498:	f406                	sd	ra,40(sp)
 49a:	f022                	sd	s0,32(sp)
 49c:	1800                	addi	s0,sp,48
 49e:	fea43423          	sd	a0,-24(s0)
 4a2:	feb43023          	sd	a1,-32(s0)
 4a6:	87b2                	mv	a5,a2
 4a8:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4ac:	fdc42783          	lw	a5,-36(s0)
 4b0:	863e                	mv	a2,a5
 4b2:	fe043583          	ld	a1,-32(s0)
 4b6:	fe843503          	ld	a0,-24(s0)
 4ba:	00000097          	auipc	ra,0x0
 4be:	e96080e7          	jalr	-362(ra) # 350 <memmove>
 4c2:	87aa                	mv	a5,a0
}
 4c4:	853e                	mv	a0,a5
 4c6:	70a2                	ld	ra,40(sp)
 4c8:	7402                	ld	s0,32(sp)
 4ca:	6145                	addi	sp,sp,48
 4cc:	8082                	ret

00000000000004ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ce:	4885                	li	a7,1
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d6:	4889                	li	a7,2
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <wait>:
.global wait
wait:
 li a7, SYS_wait
 4de:	488d                	li	a7,3
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e6:	4891                	li	a7,4
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <read>:
.global read
read:
 li a7, SYS_read
 4ee:	4895                	li	a7,5
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <write>:
.global write
write:
 li a7, SYS_write
 4f6:	48c1                	li	a7,16
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <close>:
.global close
close:
 li a7, SYS_close
 4fe:	48d5                	li	a7,21
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <kill>:
.global kill
kill:
 li a7, SYS_kill
 506:	4899                	li	a7,6
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <exec>:
.global exec
exec:
 li a7, SYS_exec
 50e:	489d                	li	a7,7
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <open>:
.global open
open:
 li a7, SYS_open
 516:	48bd                	li	a7,15
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51e:	48c5                	li	a7,17
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 526:	48c9                	li	a7,18
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52e:	48a1                	li	a7,8
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <link>:
.global link
link:
 li a7, SYS_link
 536:	48cd                	li	a7,19
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53e:	48d1                	li	a7,20
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 546:	48a5                	li	a7,9
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <dup>:
.global dup
dup:
 li a7, SYS_dup
 54e:	48a9                	li	a7,10
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 556:	48ad                	li	a7,11
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55e:	48b1                	li	a7,12
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 566:	48b5                	li	a7,13
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56e:	48b9                	li	a7,14
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <hello>:
.global hello
hello:
 li a7, SYS_hello
 576:	48d9                	li	a7,22
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 57e:	48dd                	li	a7,23
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 586:	48e1                	li	a7,24
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 58e:	1101                	addi	sp,sp,-32
 590:	ec06                	sd	ra,24(sp)
 592:	e822                	sd	s0,16(sp)
 594:	1000                	addi	s0,sp,32
 596:	87aa                	mv	a5,a0
 598:	872e                	mv	a4,a1
 59a:	fef42623          	sw	a5,-20(s0)
 59e:	87ba                	mv	a5,a4
 5a0:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5a4:	feb40713          	addi	a4,s0,-21
 5a8:	fec42783          	lw	a5,-20(s0)
 5ac:	4605                	li	a2,1
 5ae:	85ba                	mv	a1,a4
 5b0:	853e                	mv	a0,a5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	f44080e7          	jalr	-188(ra) # 4f6 <write>
}
 5ba:	0001                	nop
 5bc:	60e2                	ld	ra,24(sp)
 5be:	6442                	ld	s0,16(sp)
 5c0:	6105                	addi	sp,sp,32
 5c2:	8082                	ret

00000000000005c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c4:	7139                	addi	sp,sp,-64
 5c6:	fc06                	sd	ra,56(sp)
 5c8:	f822                	sd	s0,48(sp)
 5ca:	0080                	addi	s0,sp,64
 5cc:	87aa                	mv	a5,a0
 5ce:	8736                	mv	a4,a3
 5d0:	fcf42623          	sw	a5,-52(s0)
 5d4:	87ae                	mv	a5,a1
 5d6:	fcf42423          	sw	a5,-56(s0)
 5da:	87b2                	mv	a5,a2
 5dc:	fcf42223          	sw	a5,-60(s0)
 5e0:	87ba                	mv	a5,a4
 5e2:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5e6:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 5ea:	fc042783          	lw	a5,-64(s0)
 5ee:	2781                	sext.w	a5,a5
 5f0:	c38d                	beqz	a5,612 <printint+0x4e>
 5f2:	fc842783          	lw	a5,-56(s0)
 5f6:	2781                	sext.w	a5,a5
 5f8:	0007dd63          	bgez	a5,612 <printint+0x4e>
    neg = 1;
 5fc:	4785                	li	a5,1
 5fe:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 602:	fc842783          	lw	a5,-56(s0)
 606:	40f007bb          	negw	a5,a5
 60a:	2781                	sext.w	a5,a5
 60c:	fef42223          	sw	a5,-28(s0)
 610:	a029                	j	61a <printint+0x56>
  } else {
    x = xx;
 612:	fc842783          	lw	a5,-56(s0)
 616:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 61a:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 61e:	fc442783          	lw	a5,-60(s0)
 622:	fe442703          	lw	a4,-28(s0)
 626:	02f777bb          	remuw	a5,a4,a5
 62a:	0007861b          	sext.w	a2,a5
 62e:	fec42783          	lw	a5,-20(s0)
 632:	0017871b          	addiw	a4,a5,1
 636:	fee42623          	sw	a4,-20(s0)
 63a:	00001697          	auipc	a3,0x1
 63e:	d3668693          	addi	a3,a3,-714 # 1370 <digits>
 642:	02061713          	slli	a4,a2,0x20
 646:	9301                	srli	a4,a4,0x20
 648:	9736                	add	a4,a4,a3
 64a:	00074703          	lbu	a4,0(a4)
 64e:	17c1                	addi	a5,a5,-16
 650:	97a2                	add	a5,a5,s0
 652:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 656:	fc442783          	lw	a5,-60(s0)
 65a:	fe442703          	lw	a4,-28(s0)
 65e:	02f757bb          	divuw	a5,a4,a5
 662:	fef42223          	sw	a5,-28(s0)
 666:	fe442783          	lw	a5,-28(s0)
 66a:	2781                	sext.w	a5,a5
 66c:	fbcd                	bnez	a5,61e <printint+0x5a>
  if(neg)
 66e:	fe842783          	lw	a5,-24(s0)
 672:	2781                	sext.w	a5,a5
 674:	cf85                	beqz	a5,6ac <printint+0xe8>
    buf[i++] = '-';
 676:	fec42783          	lw	a5,-20(s0)
 67a:	0017871b          	addiw	a4,a5,1
 67e:	fee42623          	sw	a4,-20(s0)
 682:	17c1                	addi	a5,a5,-16
 684:	97a2                	add	a5,a5,s0
 686:	02d00713          	li	a4,45
 68a:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 68e:	a839                	j	6ac <printint+0xe8>
    putc(fd, buf[i]);
 690:	fec42783          	lw	a5,-20(s0)
 694:	17c1                	addi	a5,a5,-16
 696:	97a2                	add	a5,a5,s0
 698:	fe07c703          	lbu	a4,-32(a5)
 69c:	fcc42783          	lw	a5,-52(s0)
 6a0:	85ba                	mv	a1,a4
 6a2:	853e                	mv	a0,a5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	eea080e7          	jalr	-278(ra) # 58e <putc>
  while(--i >= 0)
 6ac:	fec42783          	lw	a5,-20(s0)
 6b0:	37fd                	addiw	a5,a5,-1
 6b2:	fef42623          	sw	a5,-20(s0)
 6b6:	fec42783          	lw	a5,-20(s0)
 6ba:	2781                	sext.w	a5,a5
 6bc:	fc07dae3          	bgez	a5,690 <printint+0xcc>
}
 6c0:	0001                	nop
 6c2:	0001                	nop
 6c4:	70e2                	ld	ra,56(sp)
 6c6:	7442                	ld	s0,48(sp)
 6c8:	6121                	addi	sp,sp,64
 6ca:	8082                	ret

00000000000006cc <printptr>:

static void
printptr(int fd, uint64 x) {
 6cc:	7179                	addi	sp,sp,-48
 6ce:	f406                	sd	ra,40(sp)
 6d0:	f022                	sd	s0,32(sp)
 6d2:	1800                	addi	s0,sp,48
 6d4:	87aa                	mv	a5,a0
 6d6:	fcb43823          	sd	a1,-48(s0)
 6da:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6de:	fdc42783          	lw	a5,-36(s0)
 6e2:	03000593          	li	a1,48
 6e6:	853e                	mv	a0,a5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	ea6080e7          	jalr	-346(ra) # 58e <putc>
  putc(fd, 'x');
 6f0:	fdc42783          	lw	a5,-36(s0)
 6f4:	07800593          	li	a1,120
 6f8:	853e                	mv	a0,a5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	e94080e7          	jalr	-364(ra) # 58e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 702:	fe042623          	sw	zero,-20(s0)
 706:	a82d                	j	740 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 708:	fd043783          	ld	a5,-48(s0)
 70c:	93f1                	srli	a5,a5,0x3c
 70e:	00001717          	auipc	a4,0x1
 712:	c6270713          	addi	a4,a4,-926 # 1370 <digits>
 716:	97ba                	add	a5,a5,a4
 718:	0007c703          	lbu	a4,0(a5)
 71c:	fdc42783          	lw	a5,-36(s0)
 720:	85ba                	mv	a1,a4
 722:	853e                	mv	a0,a5
 724:	00000097          	auipc	ra,0x0
 728:	e6a080e7          	jalr	-406(ra) # 58e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72c:	fec42783          	lw	a5,-20(s0)
 730:	2785                	addiw	a5,a5,1
 732:	fef42623          	sw	a5,-20(s0)
 736:	fd043783          	ld	a5,-48(s0)
 73a:	0792                	slli	a5,a5,0x4
 73c:	fcf43823          	sd	a5,-48(s0)
 740:	fec42783          	lw	a5,-20(s0)
 744:	873e                	mv	a4,a5
 746:	47bd                	li	a5,15
 748:	fce7f0e3          	bgeu	a5,a4,708 <printptr+0x3c>
}
 74c:	0001                	nop
 74e:	0001                	nop
 750:	70a2                	ld	ra,40(sp)
 752:	7402                	ld	s0,32(sp)
 754:	6145                	addi	sp,sp,48
 756:	8082                	ret

0000000000000758 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 758:	715d                	addi	sp,sp,-80
 75a:	e486                	sd	ra,72(sp)
 75c:	e0a2                	sd	s0,64(sp)
 75e:	0880                	addi	s0,sp,80
 760:	87aa                	mv	a5,a0
 762:	fcb43023          	sd	a1,-64(s0)
 766:	fac43c23          	sd	a2,-72(s0)
 76a:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 76e:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 772:	fe042223          	sw	zero,-28(s0)
 776:	a42d                	j	9a0 <vprintf+0x248>
    c = fmt[i] & 0xff;
 778:	fe442783          	lw	a5,-28(s0)
 77c:	fc043703          	ld	a4,-64(s0)
 780:	97ba                	add	a5,a5,a4
 782:	0007c783          	lbu	a5,0(a5)
 786:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 78a:	fe042783          	lw	a5,-32(s0)
 78e:	2781                	sext.w	a5,a5
 790:	eb9d                	bnez	a5,7c6 <vprintf+0x6e>
      if(c == '%'){
 792:	fdc42783          	lw	a5,-36(s0)
 796:	0007871b          	sext.w	a4,a5
 79a:	02500793          	li	a5,37
 79e:	00f71763          	bne	a4,a5,7ac <vprintf+0x54>
        state = '%';
 7a2:	02500793          	li	a5,37
 7a6:	fef42023          	sw	a5,-32(s0)
 7aa:	a2f5                	j	996 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7ac:	fdc42783          	lw	a5,-36(s0)
 7b0:	0ff7f713          	zext.b	a4,a5
 7b4:	fcc42783          	lw	a5,-52(s0)
 7b8:	85ba                	mv	a1,a4
 7ba:	853e                	mv	a0,a5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	dd2080e7          	jalr	-558(ra) # 58e <putc>
 7c4:	aac9                	j	996 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7c6:	fe042783          	lw	a5,-32(s0)
 7ca:	0007871b          	sext.w	a4,a5
 7ce:	02500793          	li	a5,37
 7d2:	1cf71263          	bne	a4,a5,996 <vprintf+0x23e>
      if(c == 'd'){
 7d6:	fdc42783          	lw	a5,-36(s0)
 7da:	0007871b          	sext.w	a4,a5
 7de:	06400793          	li	a5,100
 7e2:	02f71463          	bne	a4,a5,80a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 7e6:	fb843783          	ld	a5,-72(s0)
 7ea:	00878713          	addi	a4,a5,8
 7ee:	fae43c23          	sd	a4,-72(s0)
 7f2:	4398                	lw	a4,0(a5)
 7f4:	fcc42783          	lw	a5,-52(s0)
 7f8:	4685                	li	a3,1
 7fa:	4629                	li	a2,10
 7fc:	85ba                	mv	a1,a4
 7fe:	853e                	mv	a0,a5
 800:	00000097          	auipc	ra,0x0
 804:	dc4080e7          	jalr	-572(ra) # 5c4 <printint>
 808:	a269                	j	992 <vprintf+0x23a>
      } else if(c == 'l') {
 80a:	fdc42783          	lw	a5,-36(s0)
 80e:	0007871b          	sext.w	a4,a5
 812:	06c00793          	li	a5,108
 816:	02f71663          	bne	a4,a5,842 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81a:	fb843783          	ld	a5,-72(s0)
 81e:	00878713          	addi	a4,a5,8
 822:	fae43c23          	sd	a4,-72(s0)
 826:	639c                	ld	a5,0(a5)
 828:	0007871b          	sext.w	a4,a5
 82c:	fcc42783          	lw	a5,-52(s0)
 830:	4681                	li	a3,0
 832:	4629                	li	a2,10
 834:	85ba                	mv	a1,a4
 836:	853e                	mv	a0,a5
 838:	00000097          	auipc	ra,0x0
 83c:	d8c080e7          	jalr	-628(ra) # 5c4 <printint>
 840:	aa89                	j	992 <vprintf+0x23a>
      } else if(c == 'x') {
 842:	fdc42783          	lw	a5,-36(s0)
 846:	0007871b          	sext.w	a4,a5
 84a:	07800793          	li	a5,120
 84e:	02f71463          	bne	a4,a5,876 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 852:	fb843783          	ld	a5,-72(s0)
 856:	00878713          	addi	a4,a5,8
 85a:	fae43c23          	sd	a4,-72(s0)
 85e:	4398                	lw	a4,0(a5)
 860:	fcc42783          	lw	a5,-52(s0)
 864:	4681                	li	a3,0
 866:	4641                	li	a2,16
 868:	85ba                	mv	a1,a4
 86a:	853e                	mv	a0,a5
 86c:	00000097          	auipc	ra,0x0
 870:	d58080e7          	jalr	-680(ra) # 5c4 <printint>
 874:	aa39                	j	992 <vprintf+0x23a>
      } else if(c == 'p') {
 876:	fdc42783          	lw	a5,-36(s0)
 87a:	0007871b          	sext.w	a4,a5
 87e:	07000793          	li	a5,112
 882:	02f71263          	bne	a4,a5,8a6 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 886:	fb843783          	ld	a5,-72(s0)
 88a:	00878713          	addi	a4,a5,8
 88e:	fae43c23          	sd	a4,-72(s0)
 892:	6398                	ld	a4,0(a5)
 894:	fcc42783          	lw	a5,-52(s0)
 898:	85ba                	mv	a1,a4
 89a:	853e                	mv	a0,a5
 89c:	00000097          	auipc	ra,0x0
 8a0:	e30080e7          	jalr	-464(ra) # 6cc <printptr>
 8a4:	a0fd                	j	992 <vprintf+0x23a>
      } else if(c == 's'){
 8a6:	fdc42783          	lw	a5,-36(s0)
 8aa:	0007871b          	sext.w	a4,a5
 8ae:	07300793          	li	a5,115
 8b2:	04f71c63          	bne	a4,a5,90a <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8b6:	fb843783          	ld	a5,-72(s0)
 8ba:	00878713          	addi	a4,a5,8
 8be:	fae43c23          	sd	a4,-72(s0)
 8c2:	639c                	ld	a5,0(a5)
 8c4:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8c8:	fe843783          	ld	a5,-24(s0)
 8cc:	eb8d                	bnez	a5,8fe <vprintf+0x1a6>
          s = "(null)";
 8ce:	00000797          	auipc	a5,0x0
 8d2:	48278793          	addi	a5,a5,1154 # d50 <malloc+0x148>
 8d6:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8da:	a015                	j	8fe <vprintf+0x1a6>
          putc(fd, *s);
 8dc:	fe843783          	ld	a5,-24(s0)
 8e0:	0007c703          	lbu	a4,0(a5)
 8e4:	fcc42783          	lw	a5,-52(s0)
 8e8:	85ba                	mv	a1,a4
 8ea:	853e                	mv	a0,a5
 8ec:	00000097          	auipc	ra,0x0
 8f0:	ca2080e7          	jalr	-862(ra) # 58e <putc>
          s++;
 8f4:	fe843783          	ld	a5,-24(s0)
 8f8:	0785                	addi	a5,a5,1
 8fa:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8fe:	fe843783          	ld	a5,-24(s0)
 902:	0007c783          	lbu	a5,0(a5)
 906:	fbf9                	bnez	a5,8dc <vprintf+0x184>
 908:	a069                	j	992 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 90a:	fdc42783          	lw	a5,-36(s0)
 90e:	0007871b          	sext.w	a4,a5
 912:	06300793          	li	a5,99
 916:	02f71463          	bne	a4,a5,93e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 91a:	fb843783          	ld	a5,-72(s0)
 91e:	00878713          	addi	a4,a5,8
 922:	fae43c23          	sd	a4,-72(s0)
 926:	439c                	lw	a5,0(a5)
 928:	0ff7f713          	zext.b	a4,a5
 92c:	fcc42783          	lw	a5,-52(s0)
 930:	85ba                	mv	a1,a4
 932:	853e                	mv	a0,a5
 934:	00000097          	auipc	ra,0x0
 938:	c5a080e7          	jalr	-934(ra) # 58e <putc>
 93c:	a899                	j	992 <vprintf+0x23a>
      } else if(c == '%'){
 93e:	fdc42783          	lw	a5,-36(s0)
 942:	0007871b          	sext.w	a4,a5
 946:	02500793          	li	a5,37
 94a:	00f71f63          	bne	a4,a5,968 <vprintf+0x210>
        putc(fd, c);
 94e:	fdc42783          	lw	a5,-36(s0)
 952:	0ff7f713          	zext.b	a4,a5
 956:	fcc42783          	lw	a5,-52(s0)
 95a:	85ba                	mv	a1,a4
 95c:	853e                	mv	a0,a5
 95e:	00000097          	auipc	ra,0x0
 962:	c30080e7          	jalr	-976(ra) # 58e <putc>
 966:	a035                	j	992 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 968:	fcc42783          	lw	a5,-52(s0)
 96c:	02500593          	li	a1,37
 970:	853e                	mv	a0,a5
 972:	00000097          	auipc	ra,0x0
 976:	c1c080e7          	jalr	-996(ra) # 58e <putc>
        putc(fd, c);
 97a:	fdc42783          	lw	a5,-36(s0)
 97e:	0ff7f713          	zext.b	a4,a5
 982:	fcc42783          	lw	a5,-52(s0)
 986:	85ba                	mv	a1,a4
 988:	853e                	mv	a0,a5
 98a:	00000097          	auipc	ra,0x0
 98e:	c04080e7          	jalr	-1020(ra) # 58e <putc>
      }
      state = 0;
 992:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 996:	fe442783          	lw	a5,-28(s0)
 99a:	2785                	addiw	a5,a5,1
 99c:	fef42223          	sw	a5,-28(s0)
 9a0:	fe442783          	lw	a5,-28(s0)
 9a4:	fc043703          	ld	a4,-64(s0)
 9a8:	97ba                	add	a5,a5,a4
 9aa:	0007c783          	lbu	a5,0(a5)
 9ae:	dc0795e3          	bnez	a5,778 <vprintf+0x20>
    }
  }
}
 9b2:	0001                	nop
 9b4:	0001                	nop
 9b6:	60a6                	ld	ra,72(sp)
 9b8:	6406                	ld	s0,64(sp)
 9ba:	6161                	addi	sp,sp,80
 9bc:	8082                	ret

00000000000009be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9be:	7159                	addi	sp,sp,-112
 9c0:	fc06                	sd	ra,56(sp)
 9c2:	f822                	sd	s0,48(sp)
 9c4:	0080                	addi	s0,sp,64
 9c6:	fcb43823          	sd	a1,-48(s0)
 9ca:	e010                	sd	a2,0(s0)
 9cc:	e414                	sd	a3,8(s0)
 9ce:	e818                	sd	a4,16(s0)
 9d0:	ec1c                	sd	a5,24(s0)
 9d2:	03043023          	sd	a6,32(s0)
 9d6:	03143423          	sd	a7,40(s0)
 9da:	87aa                	mv	a5,a0
 9dc:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9e0:	03040793          	addi	a5,s0,48
 9e4:	fcf43423          	sd	a5,-56(s0)
 9e8:	fc843783          	ld	a5,-56(s0)
 9ec:	fd078793          	addi	a5,a5,-48
 9f0:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 9f4:	fe843703          	ld	a4,-24(s0)
 9f8:	fdc42783          	lw	a5,-36(s0)
 9fc:	863a                	mv	a2,a4
 9fe:	fd043583          	ld	a1,-48(s0)
 a02:	853e                	mv	a0,a5
 a04:	00000097          	auipc	ra,0x0
 a08:	d54080e7          	jalr	-684(ra) # 758 <vprintf>
}
 a0c:	0001                	nop
 a0e:	70e2                	ld	ra,56(sp)
 a10:	7442                	ld	s0,48(sp)
 a12:	6165                	addi	sp,sp,112
 a14:	8082                	ret

0000000000000a16 <printf>:

void
printf(const char *fmt, ...)
{
 a16:	7159                	addi	sp,sp,-112
 a18:	f406                	sd	ra,40(sp)
 a1a:	f022                	sd	s0,32(sp)
 a1c:	1800                	addi	s0,sp,48
 a1e:	fca43c23          	sd	a0,-40(s0)
 a22:	e40c                	sd	a1,8(s0)
 a24:	e810                	sd	a2,16(s0)
 a26:	ec14                	sd	a3,24(s0)
 a28:	f018                	sd	a4,32(s0)
 a2a:	f41c                	sd	a5,40(s0)
 a2c:	03043823          	sd	a6,48(s0)
 a30:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a34:	04040793          	addi	a5,s0,64
 a38:	fcf43823          	sd	a5,-48(s0)
 a3c:	fd043783          	ld	a5,-48(s0)
 a40:	fc878793          	addi	a5,a5,-56
 a44:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a48:	fe843783          	ld	a5,-24(s0)
 a4c:	863e                	mv	a2,a5
 a4e:	fd843583          	ld	a1,-40(s0)
 a52:	4505                	li	a0,1
 a54:	00000097          	auipc	ra,0x0
 a58:	d04080e7          	jalr	-764(ra) # 758 <vprintf>
}
 a5c:	0001                	nop
 a5e:	70a2                	ld	ra,40(sp)
 a60:	7402                	ld	s0,32(sp)
 a62:	6165                	addi	sp,sp,112
 a64:	8082                	ret

0000000000000a66 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a66:	7179                	addi	sp,sp,-48
 a68:	f422                	sd	s0,40(sp)
 a6a:	1800                	addi	s0,sp,48
 a6c:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a70:	fd843783          	ld	a5,-40(s0)
 a74:	17c1                	addi	a5,a5,-16
 a76:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a7a:	00001797          	auipc	a5,0x1
 a7e:	92678793          	addi	a5,a5,-1754 # 13a0 <freep>
 a82:	639c                	ld	a5,0(a5)
 a84:	fef43423          	sd	a5,-24(s0)
 a88:	a815                	j	abc <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a8a:	fe843783          	ld	a5,-24(s0)
 a8e:	639c                	ld	a5,0(a5)
 a90:	fe843703          	ld	a4,-24(s0)
 a94:	00f76f63          	bltu	a4,a5,ab2 <free+0x4c>
 a98:	fe043703          	ld	a4,-32(s0)
 a9c:	fe843783          	ld	a5,-24(s0)
 aa0:	02e7eb63          	bltu	a5,a4,ad6 <free+0x70>
 aa4:	fe843783          	ld	a5,-24(s0)
 aa8:	639c                	ld	a5,0(a5)
 aaa:	fe043703          	ld	a4,-32(s0)
 aae:	02f76463          	bltu	a4,a5,ad6 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab2:	fe843783          	ld	a5,-24(s0)
 ab6:	639c                	ld	a5,0(a5)
 ab8:	fef43423          	sd	a5,-24(s0)
 abc:	fe043703          	ld	a4,-32(s0)
 ac0:	fe843783          	ld	a5,-24(s0)
 ac4:	fce7f3e3          	bgeu	a5,a4,a8a <free+0x24>
 ac8:	fe843783          	ld	a5,-24(s0)
 acc:	639c                	ld	a5,0(a5)
 ace:	fe043703          	ld	a4,-32(s0)
 ad2:	faf77ce3          	bgeu	a4,a5,a8a <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ad6:	fe043783          	ld	a5,-32(s0)
 ada:	479c                	lw	a5,8(a5)
 adc:	1782                	slli	a5,a5,0x20
 ade:	9381                	srli	a5,a5,0x20
 ae0:	0792                	slli	a5,a5,0x4
 ae2:	fe043703          	ld	a4,-32(s0)
 ae6:	973e                	add	a4,a4,a5
 ae8:	fe843783          	ld	a5,-24(s0)
 aec:	639c                	ld	a5,0(a5)
 aee:	02f71763          	bne	a4,a5,b1c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 af2:	fe043783          	ld	a5,-32(s0)
 af6:	4798                	lw	a4,8(a5)
 af8:	fe843783          	ld	a5,-24(s0)
 afc:	639c                	ld	a5,0(a5)
 afe:	479c                	lw	a5,8(a5)
 b00:	9fb9                	addw	a5,a5,a4
 b02:	0007871b          	sext.w	a4,a5
 b06:	fe043783          	ld	a5,-32(s0)
 b0a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	639c                	ld	a5,0(a5)
 b12:	6398                	ld	a4,0(a5)
 b14:	fe043783          	ld	a5,-32(s0)
 b18:	e398                	sd	a4,0(a5)
 b1a:	a039                	j	b28 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b1c:	fe843783          	ld	a5,-24(s0)
 b20:	6398                	ld	a4,0(a5)
 b22:	fe043783          	ld	a5,-32(s0)
 b26:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b28:	fe843783          	ld	a5,-24(s0)
 b2c:	479c                	lw	a5,8(a5)
 b2e:	1782                	slli	a5,a5,0x20
 b30:	9381                	srli	a5,a5,0x20
 b32:	0792                	slli	a5,a5,0x4
 b34:	fe843703          	ld	a4,-24(s0)
 b38:	97ba                	add	a5,a5,a4
 b3a:	fe043703          	ld	a4,-32(s0)
 b3e:	02f71563          	bne	a4,a5,b68 <free+0x102>
    p->s.size += bp->s.size;
 b42:	fe843783          	ld	a5,-24(s0)
 b46:	4798                	lw	a4,8(a5)
 b48:	fe043783          	ld	a5,-32(s0)
 b4c:	479c                	lw	a5,8(a5)
 b4e:	9fb9                	addw	a5,a5,a4
 b50:	0007871b          	sext.w	a4,a5
 b54:	fe843783          	ld	a5,-24(s0)
 b58:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b5a:	fe043783          	ld	a5,-32(s0)
 b5e:	6398                	ld	a4,0(a5)
 b60:	fe843783          	ld	a5,-24(s0)
 b64:	e398                	sd	a4,0(a5)
 b66:	a031                	j	b72 <free+0x10c>
  } else
    p->s.ptr = bp;
 b68:	fe843783          	ld	a5,-24(s0)
 b6c:	fe043703          	ld	a4,-32(s0)
 b70:	e398                	sd	a4,0(a5)
  freep = p;
 b72:	00001797          	auipc	a5,0x1
 b76:	82e78793          	addi	a5,a5,-2002 # 13a0 <freep>
 b7a:	fe843703          	ld	a4,-24(s0)
 b7e:	e398                	sd	a4,0(a5)
}
 b80:	0001                	nop
 b82:	7422                	ld	s0,40(sp)
 b84:	6145                	addi	sp,sp,48
 b86:	8082                	ret

0000000000000b88 <morecore>:

static Header*
morecore(uint nu)
{
 b88:	7179                	addi	sp,sp,-48
 b8a:	f406                	sd	ra,40(sp)
 b8c:	f022                	sd	s0,32(sp)
 b8e:	1800                	addi	s0,sp,48
 b90:	87aa                	mv	a5,a0
 b92:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 b96:	fdc42783          	lw	a5,-36(s0)
 b9a:	0007871b          	sext.w	a4,a5
 b9e:	6785                	lui	a5,0x1
 ba0:	00f77563          	bgeu	a4,a5,baa <morecore+0x22>
    nu = 4096;
 ba4:	6785                	lui	a5,0x1
 ba6:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 baa:	fdc42783          	lw	a5,-36(s0)
 bae:	0047979b          	slliw	a5,a5,0x4
 bb2:	2781                	sext.w	a5,a5
 bb4:	2781                	sext.w	a5,a5
 bb6:	853e                	mv	a0,a5
 bb8:	00000097          	auipc	ra,0x0
 bbc:	9a6080e7          	jalr	-1626(ra) # 55e <sbrk>
 bc0:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bc4:	fe843703          	ld	a4,-24(s0)
 bc8:	57fd                	li	a5,-1
 bca:	00f71463          	bne	a4,a5,bd2 <morecore+0x4a>
    return 0;
 bce:	4781                	li	a5,0
 bd0:	a03d                	j	bfe <morecore+0x76>
  hp = (Header*)p;
 bd2:	fe843783          	ld	a5,-24(s0)
 bd6:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bda:	fe043783          	ld	a5,-32(s0)
 bde:	fdc42703          	lw	a4,-36(s0)
 be2:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 be4:	fe043783          	ld	a5,-32(s0)
 be8:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x408>
 bea:	853e                	mv	a0,a5
 bec:	00000097          	auipc	ra,0x0
 bf0:	e7a080e7          	jalr	-390(ra) # a66 <free>
  return freep;
 bf4:	00000797          	auipc	a5,0x0
 bf8:	7ac78793          	addi	a5,a5,1964 # 13a0 <freep>
 bfc:	639c                	ld	a5,0(a5)
}
 bfe:	853e                	mv	a0,a5
 c00:	70a2                	ld	ra,40(sp)
 c02:	7402                	ld	s0,32(sp)
 c04:	6145                	addi	sp,sp,48
 c06:	8082                	ret

0000000000000c08 <malloc>:

void*
malloc(uint nbytes)
{
 c08:	7139                	addi	sp,sp,-64
 c0a:	fc06                	sd	ra,56(sp)
 c0c:	f822                	sd	s0,48(sp)
 c0e:	0080                	addi	s0,sp,64
 c10:	87aa                	mv	a5,a0
 c12:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c16:	fcc46783          	lwu	a5,-52(s0)
 c1a:	07bd                	addi	a5,a5,15
 c1c:	8391                	srli	a5,a5,0x4
 c1e:	2781                	sext.w	a5,a5
 c20:	2785                	addiw	a5,a5,1
 c22:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c26:	00000797          	auipc	a5,0x0
 c2a:	77a78793          	addi	a5,a5,1914 # 13a0 <freep>
 c2e:	639c                	ld	a5,0(a5)
 c30:	fef43023          	sd	a5,-32(s0)
 c34:	fe043783          	ld	a5,-32(s0)
 c38:	ef95                	bnez	a5,c74 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c3a:	00000797          	auipc	a5,0x0
 c3e:	75678793          	addi	a5,a5,1878 # 1390 <base>
 c42:	fef43023          	sd	a5,-32(s0)
 c46:	00000797          	auipc	a5,0x0
 c4a:	75a78793          	addi	a5,a5,1882 # 13a0 <freep>
 c4e:	fe043703          	ld	a4,-32(s0)
 c52:	e398                	sd	a4,0(a5)
 c54:	00000797          	auipc	a5,0x0
 c58:	74c78793          	addi	a5,a5,1868 # 13a0 <freep>
 c5c:	6398                	ld	a4,0(a5)
 c5e:	00000797          	auipc	a5,0x0
 c62:	73278793          	addi	a5,a5,1842 # 1390 <base>
 c66:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c68:	00000797          	auipc	a5,0x0
 c6c:	72878793          	addi	a5,a5,1832 # 1390 <base>
 c70:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c74:	fe043783          	ld	a5,-32(s0)
 c78:	639c                	ld	a5,0(a5)
 c7a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c7e:	fe843783          	ld	a5,-24(s0)
 c82:	4798                	lw	a4,8(a5)
 c84:	fdc42783          	lw	a5,-36(s0)
 c88:	2781                	sext.w	a5,a5
 c8a:	06f76763          	bltu	a4,a5,cf8 <malloc+0xf0>
      if(p->s.size == nunits)
 c8e:	fe843783          	ld	a5,-24(s0)
 c92:	4798                	lw	a4,8(a5)
 c94:	fdc42783          	lw	a5,-36(s0)
 c98:	2781                	sext.w	a5,a5
 c9a:	00e79963          	bne	a5,a4,cac <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 c9e:	fe843783          	ld	a5,-24(s0)
 ca2:	6398                	ld	a4,0(a5)
 ca4:	fe043783          	ld	a5,-32(s0)
 ca8:	e398                	sd	a4,0(a5)
 caa:	a825                	j	ce2 <malloc+0xda>
      else {
        p->s.size -= nunits;
 cac:	fe843783          	ld	a5,-24(s0)
 cb0:	479c                	lw	a5,8(a5)
 cb2:	fdc42703          	lw	a4,-36(s0)
 cb6:	9f99                	subw	a5,a5,a4
 cb8:	0007871b          	sext.w	a4,a5
 cbc:	fe843783          	ld	a5,-24(s0)
 cc0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cc2:	fe843783          	ld	a5,-24(s0)
 cc6:	479c                	lw	a5,8(a5)
 cc8:	1782                	slli	a5,a5,0x20
 cca:	9381                	srli	a5,a5,0x20
 ccc:	0792                	slli	a5,a5,0x4
 cce:	fe843703          	ld	a4,-24(s0)
 cd2:	97ba                	add	a5,a5,a4
 cd4:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cd8:	fe843783          	ld	a5,-24(s0)
 cdc:	fdc42703          	lw	a4,-36(s0)
 ce0:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 ce2:	00000797          	auipc	a5,0x0
 ce6:	6be78793          	addi	a5,a5,1726 # 13a0 <freep>
 cea:	fe043703          	ld	a4,-32(s0)
 cee:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 cf0:	fe843783          	ld	a5,-24(s0)
 cf4:	07c1                	addi	a5,a5,16
 cf6:	a091                	j	d3a <malloc+0x132>
    }
    if(p == freep)
 cf8:	00000797          	auipc	a5,0x0
 cfc:	6a878793          	addi	a5,a5,1704 # 13a0 <freep>
 d00:	639c                	ld	a5,0(a5)
 d02:	fe843703          	ld	a4,-24(s0)
 d06:	02f71063          	bne	a4,a5,d26 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d0a:	fdc42783          	lw	a5,-36(s0)
 d0e:	853e                	mv	a0,a5
 d10:	00000097          	auipc	ra,0x0
 d14:	e78080e7          	jalr	-392(ra) # b88 <morecore>
 d18:	fea43423          	sd	a0,-24(s0)
 d1c:	fe843783          	ld	a5,-24(s0)
 d20:	e399                	bnez	a5,d26 <malloc+0x11e>
        return 0;
 d22:	4781                	li	a5,0
 d24:	a819                	j	d3a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d26:	fe843783          	ld	a5,-24(s0)
 d2a:	fef43023          	sd	a5,-32(s0)
 d2e:	fe843783          	ld	a5,-24(s0)
 d32:	639c                	ld	a5,0(a5)
 d34:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d38:	b799                	j	c7e <malloc+0x76>
  }
}
 d3a:	853e                	mv	a0,a5
 d3c:	70e2                	ld	ra,56(sp)
 d3e:	7442                	ld	s0,48(sp)
 d40:	6121                	addi	sp,sp,64
 d42:	8082                	ret
