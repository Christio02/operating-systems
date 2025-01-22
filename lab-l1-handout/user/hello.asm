
user/_hello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"



int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	87aa                	mv	a5,a0
   a:	feb43023          	sd	a1,-32(s0)
   e:	fef42623          	sw	a5,-20(s0)
    if (argc == 1) {
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	00f71b63          	bne	a4,a5,32 <main+0x32>
        printf("Hello world!\n");
  20:	00001517          	auipc	a0,0x1
  24:	d4050513          	addi	a0,a0,-704 # d60 <malloc+0x144>
  28:	00001097          	auipc	ra,0x1
  2c:	a02080e7          	jalr	-1534(ra) # a2a <printf>
  30:	a831                	j	4c <main+0x4c>

    } else {
        printf("Hello %s , nice to meet you!\n ", argv[1]);
  32:	fe043783          	ld	a5,-32(s0)
  36:	07a1                	addi	a5,a5,8
  38:	639c                	ld	a5,0(a5)
  3a:	85be                	mv	a1,a5
  3c:	00001517          	auipc	a0,0x1
  40:	d3450513          	addi	a0,a0,-716 # d70 <malloc+0x154>
  44:	00001097          	auipc	ra,0x1
  48:	9e6080e7          	jalr	-1562(ra) # a2a <printf>
    }
    exit(0);
  4c:	4501                	li	a0,0
  4e:	00000097          	auipc	ra,0x0
  52:	4b4080e7          	jalr	1204(ra) # 502 <exit>

0000000000000056 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  56:	1141                	addi	sp,sp,-16
  58:	e406                	sd	ra,8(sp)
  5a:	e022                	sd	s0,0(sp)
  5c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5e:	00000097          	auipc	ra,0x0
  62:	fa2080e7          	jalr	-94(ra) # 0 <main>
  exit(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	49a080e7          	jalr	1178(ra) # 502 <exit>

0000000000000070 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  70:	7179                	addi	sp,sp,-48
  72:	f422                	sd	s0,40(sp)
  74:	1800                	addi	s0,sp,48
  76:	fca43c23          	sd	a0,-40(s0)
  7a:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  7e:	fd843783          	ld	a5,-40(s0)
  82:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  86:	0001                	nop
  88:	fd043703          	ld	a4,-48(s0)
  8c:	00170793          	addi	a5,a4,1
  90:	fcf43823          	sd	a5,-48(s0)
  94:	fd843783          	ld	a5,-40(s0)
  98:	00178693          	addi	a3,a5,1
  9c:	fcd43c23          	sd	a3,-40(s0)
  a0:	00074703          	lbu	a4,0(a4)
  a4:	00e78023          	sb	a4,0(a5)
  a8:	0007c783          	lbu	a5,0(a5)
  ac:	fff1                	bnez	a5,88 <strcpy+0x18>
    ;
  return os;
  ae:	fe843783          	ld	a5,-24(s0)
}
  b2:	853e                	mv	a0,a5
  b4:	7422                	ld	s0,40(sp)
  b6:	6145                	addi	sp,sp,48
  b8:	8082                	ret

00000000000000ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ba:	1101                	addi	sp,sp,-32
  bc:	ec22                	sd	s0,24(sp)
  be:	1000                	addi	s0,sp,32
  c0:	fea43423          	sd	a0,-24(s0)
  c4:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  c8:	a819                	j	de <strcmp+0x24>
    p++, q++;
  ca:	fe843783          	ld	a5,-24(s0)
  ce:	0785                	addi	a5,a5,1
  d0:	fef43423          	sd	a5,-24(s0)
  d4:	fe043783          	ld	a5,-32(s0)
  d8:	0785                	addi	a5,a5,1
  da:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  de:	fe843783          	ld	a5,-24(s0)
  e2:	0007c783          	lbu	a5,0(a5)
  e6:	cb99                	beqz	a5,fc <strcmp+0x42>
  e8:	fe843783          	ld	a5,-24(s0)
  ec:	0007c703          	lbu	a4,0(a5)
  f0:	fe043783          	ld	a5,-32(s0)
  f4:	0007c783          	lbu	a5,0(a5)
  f8:	fcf709e3          	beq	a4,a5,ca <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  fc:	fe843783          	ld	a5,-24(s0)
 100:	0007c783          	lbu	a5,0(a5)
 104:	0007871b          	sext.w	a4,a5
 108:	fe043783          	ld	a5,-32(s0)
 10c:	0007c783          	lbu	a5,0(a5)
 110:	2781                	sext.w	a5,a5
 112:	40f707bb          	subw	a5,a4,a5
 116:	2781                	sext.w	a5,a5
}
 118:	853e                	mv	a0,a5
 11a:	6462                	ld	s0,24(sp)
 11c:	6105                	addi	sp,sp,32
 11e:	8082                	ret

0000000000000120 <strlen>:

uint
strlen(const char *s)
{
 120:	7179                	addi	sp,sp,-48
 122:	f422                	sd	s0,40(sp)
 124:	1800                	addi	s0,sp,48
 126:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 12a:	fe042623          	sw	zero,-20(s0)
 12e:	a031                	j	13a <strlen+0x1a>
 130:	fec42783          	lw	a5,-20(s0)
 134:	2785                	addiw	a5,a5,1
 136:	fef42623          	sw	a5,-20(s0)
 13a:	fec42783          	lw	a5,-20(s0)
 13e:	fd843703          	ld	a4,-40(s0)
 142:	97ba                	add	a5,a5,a4
 144:	0007c783          	lbu	a5,0(a5)
 148:	f7e5                	bnez	a5,130 <strlen+0x10>
    ;
  return n;
 14a:	fec42783          	lw	a5,-20(s0)
}
 14e:	853e                	mv	a0,a5
 150:	7422                	ld	s0,40(sp)
 152:	6145                	addi	sp,sp,48
 154:	8082                	ret

0000000000000156 <memset>:

void*
memset(void *dst, int c, uint n)
{
 156:	7179                	addi	sp,sp,-48
 158:	f422                	sd	s0,40(sp)
 15a:	1800                	addi	s0,sp,48
 15c:	fca43c23          	sd	a0,-40(s0)
 160:	87ae                	mv	a5,a1
 162:	8732                	mv	a4,a2
 164:	fcf42a23          	sw	a5,-44(s0)
 168:	87ba                	mv	a5,a4
 16a:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 16e:	fd843783          	ld	a5,-40(s0)
 172:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 176:	fe042623          	sw	zero,-20(s0)
 17a:	a00d                	j	19c <memset+0x46>
    cdst[i] = c;
 17c:	fec42783          	lw	a5,-20(s0)
 180:	fe043703          	ld	a4,-32(s0)
 184:	97ba                	add	a5,a5,a4
 186:	fd442703          	lw	a4,-44(s0)
 18a:	0ff77713          	zext.b	a4,a4
 18e:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 192:	fec42783          	lw	a5,-20(s0)
 196:	2785                	addiw	a5,a5,1
 198:	fef42623          	sw	a5,-20(s0)
 19c:	fec42703          	lw	a4,-20(s0)
 1a0:	fd042783          	lw	a5,-48(s0)
 1a4:	2781                	sext.w	a5,a5
 1a6:	fcf76be3          	bltu	a4,a5,17c <memset+0x26>
  }
  return dst;
 1aa:	fd843783          	ld	a5,-40(s0)
}
 1ae:	853e                	mv	a0,a5
 1b0:	7422                	ld	s0,40(sp)
 1b2:	6145                	addi	sp,sp,48
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1101                	addi	sp,sp,-32
 1b8:	ec22                	sd	s0,24(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	fea43423          	sd	a0,-24(s0)
 1c0:	87ae                	mv	a5,a1
 1c2:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1c6:	a01d                	j	1ec <strchr+0x36>
    if(*s == c)
 1c8:	fe843783          	ld	a5,-24(s0)
 1cc:	0007c703          	lbu	a4,0(a5)
 1d0:	fe744783          	lbu	a5,-25(s0)
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	00e79563          	bne	a5,a4,1e2 <strchr+0x2c>
      return (char*)s;
 1dc:	fe843783          	ld	a5,-24(s0)
 1e0:	a821                	j	1f8 <strchr+0x42>
  for(; *s; s++)
 1e2:	fe843783          	ld	a5,-24(s0)
 1e6:	0785                	addi	a5,a5,1
 1e8:	fef43423          	sd	a5,-24(s0)
 1ec:	fe843783          	ld	a5,-24(s0)
 1f0:	0007c783          	lbu	a5,0(a5)
 1f4:	fbf1                	bnez	a5,1c8 <strchr+0x12>
  return 0;
 1f6:	4781                	li	a5,0
}
 1f8:	853e                	mv	a0,a5
 1fa:	6462                	ld	s0,24(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret

0000000000000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	7179                	addi	sp,sp,-48
 202:	f406                	sd	ra,40(sp)
 204:	f022                	sd	s0,32(sp)
 206:	1800                	addi	s0,sp,48
 208:	fca43c23          	sd	a0,-40(s0)
 20c:	87ae                	mv	a5,a1
 20e:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 212:	fe042623          	sw	zero,-20(s0)
 216:	a8a1                	j	26e <gets+0x6e>
    cc = read(0, &c, 1);
 218:	fe740793          	addi	a5,s0,-25
 21c:	4605                	li	a2,1
 21e:	85be                	mv	a1,a5
 220:	4501                	li	a0,0
 222:	00000097          	auipc	ra,0x0
 226:	2f8080e7          	jalr	760(ra) # 51a <read>
 22a:	87aa                	mv	a5,a0
 22c:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 230:	fe842783          	lw	a5,-24(s0)
 234:	2781                	sext.w	a5,a5
 236:	04f05763          	blez	a5,284 <gets+0x84>
      break;
    buf[i++] = c;
 23a:	fec42783          	lw	a5,-20(s0)
 23e:	0017871b          	addiw	a4,a5,1
 242:	fee42623          	sw	a4,-20(s0)
 246:	873e                	mv	a4,a5
 248:	fd843783          	ld	a5,-40(s0)
 24c:	97ba                	add	a5,a5,a4
 24e:	fe744703          	lbu	a4,-25(s0)
 252:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 256:	fe744783          	lbu	a5,-25(s0)
 25a:	873e                	mv	a4,a5
 25c:	47a9                	li	a5,10
 25e:	02f70463          	beq	a4,a5,286 <gets+0x86>
 262:	fe744783          	lbu	a5,-25(s0)
 266:	873e                	mv	a4,a5
 268:	47b5                	li	a5,13
 26a:	00f70e63          	beq	a4,a5,286 <gets+0x86>
  for(i=0; i+1 < max; ){
 26e:	fec42783          	lw	a5,-20(s0)
 272:	2785                	addiw	a5,a5,1
 274:	0007871b          	sext.w	a4,a5
 278:	fd442783          	lw	a5,-44(s0)
 27c:	2781                	sext.w	a5,a5
 27e:	f8f74de3          	blt	a4,a5,218 <gets+0x18>
 282:	a011                	j	286 <gets+0x86>
      break;
 284:	0001                	nop
      break;
  }
  buf[i] = '\0';
 286:	fec42783          	lw	a5,-20(s0)
 28a:	fd843703          	ld	a4,-40(s0)
 28e:	97ba                	add	a5,a5,a4
 290:	00078023          	sb	zero,0(a5)
  return buf;
 294:	fd843783          	ld	a5,-40(s0)
}
 298:	853e                	mv	a0,a5
 29a:	70a2                	ld	ra,40(sp)
 29c:	7402                	ld	s0,32(sp)
 29e:	6145                	addi	sp,sp,48
 2a0:	8082                	ret

00000000000002a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a2:	7179                	addi	sp,sp,-48
 2a4:	f406                	sd	ra,40(sp)
 2a6:	f022                	sd	s0,32(sp)
 2a8:	1800                	addi	s0,sp,48
 2aa:	fca43c23          	sd	a0,-40(s0)
 2ae:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b2:	4581                	li	a1,0
 2b4:	fd843503          	ld	a0,-40(s0)
 2b8:	00000097          	auipc	ra,0x0
 2bc:	28a080e7          	jalr	650(ra) # 542 <open>
 2c0:	87aa                	mv	a5,a0
 2c2:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2c6:	fec42783          	lw	a5,-20(s0)
 2ca:	2781                	sext.w	a5,a5
 2cc:	0007d463          	bgez	a5,2d4 <stat+0x32>
    return -1;
 2d0:	57fd                	li	a5,-1
 2d2:	a035                	j	2fe <stat+0x5c>
  r = fstat(fd, st);
 2d4:	fec42783          	lw	a5,-20(s0)
 2d8:	fd043583          	ld	a1,-48(s0)
 2dc:	853e                	mv	a0,a5
 2de:	00000097          	auipc	ra,0x0
 2e2:	27c080e7          	jalr	636(ra) # 55a <fstat>
 2e6:	87aa                	mv	a5,a0
 2e8:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2ec:	fec42783          	lw	a5,-20(s0)
 2f0:	853e                	mv	a0,a5
 2f2:	00000097          	auipc	ra,0x0
 2f6:	238080e7          	jalr	568(ra) # 52a <close>
  return r;
 2fa:	fe842783          	lw	a5,-24(s0)
}
 2fe:	853e                	mv	a0,a5
 300:	70a2                	ld	ra,40(sp)
 302:	7402                	ld	s0,32(sp)
 304:	6145                	addi	sp,sp,48
 306:	8082                	ret

0000000000000308 <atoi>:

int
atoi(const char *s)
{
 308:	7179                	addi	sp,sp,-48
 30a:	f422                	sd	s0,40(sp)
 30c:	1800                	addi	s0,sp,48
 30e:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 312:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 316:	a81d                	j	34c <atoi+0x44>
    n = n*10 + *s++ - '0';
 318:	fec42783          	lw	a5,-20(s0)
 31c:	873e                	mv	a4,a5
 31e:	87ba                	mv	a5,a4
 320:	0027979b          	slliw	a5,a5,0x2
 324:	9fb9                	addw	a5,a5,a4
 326:	0017979b          	slliw	a5,a5,0x1
 32a:	0007871b          	sext.w	a4,a5
 32e:	fd843783          	ld	a5,-40(s0)
 332:	00178693          	addi	a3,a5,1
 336:	fcd43c23          	sd	a3,-40(s0)
 33a:	0007c783          	lbu	a5,0(a5)
 33e:	2781                	sext.w	a5,a5
 340:	9fb9                	addw	a5,a5,a4
 342:	2781                	sext.w	a5,a5
 344:	fd07879b          	addiw	a5,a5,-48
 348:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 34c:	fd843783          	ld	a5,-40(s0)
 350:	0007c783          	lbu	a5,0(a5)
 354:	873e                	mv	a4,a5
 356:	02f00793          	li	a5,47
 35a:	00e7fb63          	bgeu	a5,a4,370 <atoi+0x68>
 35e:	fd843783          	ld	a5,-40(s0)
 362:	0007c783          	lbu	a5,0(a5)
 366:	873e                	mv	a4,a5
 368:	03900793          	li	a5,57
 36c:	fae7f6e3          	bgeu	a5,a4,318 <atoi+0x10>
  return n;
 370:	fec42783          	lw	a5,-20(s0)
}
 374:	853e                	mv	a0,a5
 376:	7422                	ld	s0,40(sp)
 378:	6145                	addi	sp,sp,48
 37a:	8082                	ret

000000000000037c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37c:	7139                	addi	sp,sp,-64
 37e:	fc22                	sd	s0,56(sp)
 380:	0080                	addi	s0,sp,64
 382:	fca43c23          	sd	a0,-40(s0)
 386:	fcb43823          	sd	a1,-48(s0)
 38a:	87b2                	mv	a5,a2
 38c:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 390:	fd843783          	ld	a5,-40(s0)
 394:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 398:	fd043783          	ld	a5,-48(s0)
 39c:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3a0:	fe043703          	ld	a4,-32(s0)
 3a4:	fe843783          	ld	a5,-24(s0)
 3a8:	02e7fc63          	bgeu	a5,a4,3e0 <memmove+0x64>
    while(n-- > 0)
 3ac:	a00d                	j	3ce <memmove+0x52>
      *dst++ = *src++;
 3ae:	fe043703          	ld	a4,-32(s0)
 3b2:	00170793          	addi	a5,a4,1
 3b6:	fef43023          	sd	a5,-32(s0)
 3ba:	fe843783          	ld	a5,-24(s0)
 3be:	00178693          	addi	a3,a5,1
 3c2:	fed43423          	sd	a3,-24(s0)
 3c6:	00074703          	lbu	a4,0(a4)
 3ca:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3ce:	fcc42783          	lw	a5,-52(s0)
 3d2:	fff7871b          	addiw	a4,a5,-1
 3d6:	fce42623          	sw	a4,-52(s0)
 3da:	fcf04ae3          	bgtz	a5,3ae <memmove+0x32>
 3de:	a891                	j	432 <memmove+0xb6>
  } else {
    dst += n;
 3e0:	fcc42783          	lw	a5,-52(s0)
 3e4:	fe843703          	ld	a4,-24(s0)
 3e8:	97ba                	add	a5,a5,a4
 3ea:	fef43423          	sd	a5,-24(s0)
    src += n;
 3ee:	fcc42783          	lw	a5,-52(s0)
 3f2:	fe043703          	ld	a4,-32(s0)
 3f6:	97ba                	add	a5,a5,a4
 3f8:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 3fc:	a01d                	j	422 <memmove+0xa6>
      *--dst = *--src;
 3fe:	fe043783          	ld	a5,-32(s0)
 402:	17fd                	addi	a5,a5,-1
 404:	fef43023          	sd	a5,-32(s0)
 408:	fe843783          	ld	a5,-24(s0)
 40c:	17fd                	addi	a5,a5,-1
 40e:	fef43423          	sd	a5,-24(s0)
 412:	fe043783          	ld	a5,-32(s0)
 416:	0007c703          	lbu	a4,0(a5)
 41a:	fe843783          	ld	a5,-24(s0)
 41e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 422:	fcc42783          	lw	a5,-52(s0)
 426:	fff7871b          	addiw	a4,a5,-1
 42a:	fce42623          	sw	a4,-52(s0)
 42e:	fcf048e3          	bgtz	a5,3fe <memmove+0x82>
  }
  return vdst;
 432:	fd843783          	ld	a5,-40(s0)
}
 436:	853e                	mv	a0,a5
 438:	7462                	ld	s0,56(sp)
 43a:	6121                	addi	sp,sp,64
 43c:	8082                	ret

000000000000043e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 43e:	7139                	addi	sp,sp,-64
 440:	fc22                	sd	s0,56(sp)
 442:	0080                	addi	s0,sp,64
 444:	fca43c23          	sd	a0,-40(s0)
 448:	fcb43823          	sd	a1,-48(s0)
 44c:	87b2                	mv	a5,a2
 44e:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 452:	fd843783          	ld	a5,-40(s0)
 456:	fef43423          	sd	a5,-24(s0)
 45a:	fd043783          	ld	a5,-48(s0)
 45e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 462:	a0a1                	j	4aa <memcmp+0x6c>
    if (*p1 != *p2) {
 464:	fe843783          	ld	a5,-24(s0)
 468:	0007c703          	lbu	a4,0(a5)
 46c:	fe043783          	ld	a5,-32(s0)
 470:	0007c783          	lbu	a5,0(a5)
 474:	02f70163          	beq	a4,a5,496 <memcmp+0x58>
      return *p1 - *p2;
 478:	fe843783          	ld	a5,-24(s0)
 47c:	0007c783          	lbu	a5,0(a5)
 480:	0007871b          	sext.w	a4,a5
 484:	fe043783          	ld	a5,-32(s0)
 488:	0007c783          	lbu	a5,0(a5)
 48c:	2781                	sext.w	a5,a5
 48e:	40f707bb          	subw	a5,a4,a5
 492:	2781                	sext.w	a5,a5
 494:	a01d                	j	4ba <memcmp+0x7c>
    }
    p1++;
 496:	fe843783          	ld	a5,-24(s0)
 49a:	0785                	addi	a5,a5,1
 49c:	fef43423          	sd	a5,-24(s0)
    p2++;
 4a0:	fe043783          	ld	a5,-32(s0)
 4a4:	0785                	addi	a5,a5,1
 4a6:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4aa:	fcc42783          	lw	a5,-52(s0)
 4ae:	fff7871b          	addiw	a4,a5,-1
 4b2:	fce42623          	sw	a4,-52(s0)
 4b6:	f7dd                	bnez	a5,464 <memcmp+0x26>
  }
  return 0;
 4b8:	4781                	li	a5,0
}
 4ba:	853e                	mv	a0,a5
 4bc:	7462                	ld	s0,56(sp)
 4be:	6121                	addi	sp,sp,64
 4c0:	8082                	ret

00000000000004c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c2:	7179                	addi	sp,sp,-48
 4c4:	f406                	sd	ra,40(sp)
 4c6:	f022                	sd	s0,32(sp)
 4c8:	1800                	addi	s0,sp,48
 4ca:	fea43423          	sd	a0,-24(s0)
 4ce:	feb43023          	sd	a1,-32(s0)
 4d2:	87b2                	mv	a5,a2
 4d4:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4d8:	fdc42783          	lw	a5,-36(s0)
 4dc:	863e                	mv	a2,a5
 4de:	fe043583          	ld	a1,-32(s0)
 4e2:	fe843503          	ld	a0,-24(s0)
 4e6:	00000097          	auipc	ra,0x0
 4ea:	e96080e7          	jalr	-362(ra) # 37c <memmove>
 4ee:	87aa                	mv	a5,a0
}
 4f0:	853e                	mv	a0,a5
 4f2:	70a2                	ld	ra,40(sp)
 4f4:	7402                	ld	s0,32(sp)
 4f6:	6145                	addi	sp,sp,48
 4f8:	8082                	ret

00000000000004fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4fa:	4885                	li	a7,1
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <exit>:
.global exit
exit:
 li a7, SYS_exit
 502:	4889                	li	a7,2
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <wait>:
.global wait
wait:
 li a7, SYS_wait
 50a:	488d                	li	a7,3
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 512:	4891                	li	a7,4
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <read>:
.global read
read:
 li a7, SYS_read
 51a:	4895                	li	a7,5
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <write>:
.global write
write:
 li a7, SYS_write
 522:	48c1                	li	a7,16
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <close>:
.global close
close:
 li a7, SYS_close
 52a:	48d5                	li	a7,21
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <kill>:
.global kill
kill:
 li a7, SYS_kill
 532:	4899                	li	a7,6
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exec>:
.global exec
exec:
 li a7, SYS_exec
 53a:	489d                	li	a7,7
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <open>:
.global open
open:
 li a7, SYS_open
 542:	48bd                	li	a7,15
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 54a:	48c5                	li	a7,17
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 552:	48c9                	li	a7,18
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55a:	48a1                	li	a7,8
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <link>:
.global link
link:
 li a7, SYS_link
 562:	48cd                	li	a7,19
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 56a:	48d1                	li	a7,20
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 572:	48a5                	li	a7,9
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <dup>:
.global dup
dup:
 li a7, SYS_dup
 57a:	48a9                	li	a7,10
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 582:	48ad                	li	a7,11
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 58a:	48b1                	li	a7,12
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 592:	48b5                	li	a7,13
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59a:	48b9                	li	a7,14
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a2:	1101                	addi	sp,sp,-32
 5a4:	ec06                	sd	ra,24(sp)
 5a6:	e822                	sd	s0,16(sp)
 5a8:	1000                	addi	s0,sp,32
 5aa:	87aa                	mv	a5,a0
 5ac:	872e                	mv	a4,a1
 5ae:	fef42623          	sw	a5,-20(s0)
 5b2:	87ba                	mv	a5,a4
 5b4:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5b8:	feb40713          	addi	a4,s0,-21
 5bc:	fec42783          	lw	a5,-20(s0)
 5c0:	4605                	li	a2,1
 5c2:	85ba                	mv	a1,a4
 5c4:	853e                	mv	a0,a5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	f5c080e7          	jalr	-164(ra) # 522 <write>
}
 5ce:	0001                	nop
 5d0:	60e2                	ld	ra,24(sp)
 5d2:	6442                	ld	s0,16(sp)
 5d4:	6105                	addi	sp,sp,32
 5d6:	8082                	ret

00000000000005d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d8:	7139                	addi	sp,sp,-64
 5da:	fc06                	sd	ra,56(sp)
 5dc:	f822                	sd	s0,48(sp)
 5de:	0080                	addi	s0,sp,64
 5e0:	87aa                	mv	a5,a0
 5e2:	8736                	mv	a4,a3
 5e4:	fcf42623          	sw	a5,-52(s0)
 5e8:	87ae                	mv	a5,a1
 5ea:	fcf42423          	sw	a5,-56(s0)
 5ee:	87b2                	mv	a5,a2
 5f0:	fcf42223          	sw	a5,-60(s0)
 5f4:	87ba                	mv	a5,a4
 5f6:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5fa:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 5fe:	fc042783          	lw	a5,-64(s0)
 602:	2781                	sext.w	a5,a5
 604:	c38d                	beqz	a5,626 <printint+0x4e>
 606:	fc842783          	lw	a5,-56(s0)
 60a:	2781                	sext.w	a5,a5
 60c:	0007dd63          	bgez	a5,626 <printint+0x4e>
    neg = 1;
 610:	4785                	li	a5,1
 612:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 616:	fc842783          	lw	a5,-56(s0)
 61a:	40f007bb          	negw	a5,a5
 61e:	2781                	sext.w	a5,a5
 620:	fef42223          	sw	a5,-28(s0)
 624:	a029                	j	62e <printint+0x56>
  } else {
    x = xx;
 626:	fc842783          	lw	a5,-56(s0)
 62a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 62e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 632:	fc442783          	lw	a5,-60(s0)
 636:	fe442703          	lw	a4,-28(s0)
 63a:	02f777bb          	remuw	a5,a4,a5
 63e:	0007861b          	sext.w	a2,a5
 642:	fec42783          	lw	a5,-20(s0)
 646:	0017871b          	addiw	a4,a5,1
 64a:	fee42623          	sw	a4,-20(s0)
 64e:	00001697          	auipc	a3,0x1
 652:	d2268693          	addi	a3,a3,-734 # 1370 <digits>
 656:	02061713          	slli	a4,a2,0x20
 65a:	9301                	srli	a4,a4,0x20
 65c:	9736                	add	a4,a4,a3
 65e:	00074703          	lbu	a4,0(a4)
 662:	17c1                	addi	a5,a5,-16
 664:	97a2                	add	a5,a5,s0
 666:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 66a:	fc442783          	lw	a5,-60(s0)
 66e:	fe442703          	lw	a4,-28(s0)
 672:	02f757bb          	divuw	a5,a4,a5
 676:	fef42223          	sw	a5,-28(s0)
 67a:	fe442783          	lw	a5,-28(s0)
 67e:	2781                	sext.w	a5,a5
 680:	fbcd                	bnez	a5,632 <printint+0x5a>
  if(neg)
 682:	fe842783          	lw	a5,-24(s0)
 686:	2781                	sext.w	a5,a5
 688:	cf85                	beqz	a5,6c0 <printint+0xe8>
    buf[i++] = '-';
 68a:	fec42783          	lw	a5,-20(s0)
 68e:	0017871b          	addiw	a4,a5,1
 692:	fee42623          	sw	a4,-20(s0)
 696:	17c1                	addi	a5,a5,-16
 698:	97a2                	add	a5,a5,s0
 69a:	02d00713          	li	a4,45
 69e:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6a2:	a839                	j	6c0 <printint+0xe8>
    putc(fd, buf[i]);
 6a4:	fec42783          	lw	a5,-20(s0)
 6a8:	17c1                	addi	a5,a5,-16
 6aa:	97a2                	add	a5,a5,s0
 6ac:	fe07c703          	lbu	a4,-32(a5)
 6b0:	fcc42783          	lw	a5,-52(s0)
 6b4:	85ba                	mv	a1,a4
 6b6:	853e                	mv	a0,a5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	eea080e7          	jalr	-278(ra) # 5a2 <putc>
  while(--i >= 0)
 6c0:	fec42783          	lw	a5,-20(s0)
 6c4:	37fd                	addiw	a5,a5,-1
 6c6:	fef42623          	sw	a5,-20(s0)
 6ca:	fec42783          	lw	a5,-20(s0)
 6ce:	2781                	sext.w	a5,a5
 6d0:	fc07dae3          	bgez	a5,6a4 <printint+0xcc>
}
 6d4:	0001                	nop
 6d6:	0001                	nop
 6d8:	70e2                	ld	ra,56(sp)
 6da:	7442                	ld	s0,48(sp)
 6dc:	6121                	addi	sp,sp,64
 6de:	8082                	ret

00000000000006e0 <printptr>:

static void
printptr(int fd, uint64 x) {
 6e0:	7179                	addi	sp,sp,-48
 6e2:	f406                	sd	ra,40(sp)
 6e4:	f022                	sd	s0,32(sp)
 6e6:	1800                	addi	s0,sp,48
 6e8:	87aa                	mv	a5,a0
 6ea:	fcb43823          	sd	a1,-48(s0)
 6ee:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6f2:	fdc42783          	lw	a5,-36(s0)
 6f6:	03000593          	li	a1,48
 6fa:	853e                	mv	a0,a5
 6fc:	00000097          	auipc	ra,0x0
 700:	ea6080e7          	jalr	-346(ra) # 5a2 <putc>
  putc(fd, 'x');
 704:	fdc42783          	lw	a5,-36(s0)
 708:	07800593          	li	a1,120
 70c:	853e                	mv	a0,a5
 70e:	00000097          	auipc	ra,0x0
 712:	e94080e7          	jalr	-364(ra) # 5a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 716:	fe042623          	sw	zero,-20(s0)
 71a:	a82d                	j	754 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71c:	fd043783          	ld	a5,-48(s0)
 720:	93f1                	srli	a5,a5,0x3c
 722:	00001717          	auipc	a4,0x1
 726:	c4e70713          	addi	a4,a4,-946 # 1370 <digits>
 72a:	97ba                	add	a5,a5,a4
 72c:	0007c703          	lbu	a4,0(a5)
 730:	fdc42783          	lw	a5,-36(s0)
 734:	85ba                	mv	a1,a4
 736:	853e                	mv	a0,a5
 738:	00000097          	auipc	ra,0x0
 73c:	e6a080e7          	jalr	-406(ra) # 5a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 740:	fec42783          	lw	a5,-20(s0)
 744:	2785                	addiw	a5,a5,1
 746:	fef42623          	sw	a5,-20(s0)
 74a:	fd043783          	ld	a5,-48(s0)
 74e:	0792                	slli	a5,a5,0x4
 750:	fcf43823          	sd	a5,-48(s0)
 754:	fec42783          	lw	a5,-20(s0)
 758:	873e                	mv	a4,a5
 75a:	47bd                	li	a5,15
 75c:	fce7f0e3          	bgeu	a5,a4,71c <printptr+0x3c>
}
 760:	0001                	nop
 762:	0001                	nop
 764:	70a2                	ld	ra,40(sp)
 766:	7402                	ld	s0,32(sp)
 768:	6145                	addi	sp,sp,48
 76a:	8082                	ret

000000000000076c <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 76c:	715d                	addi	sp,sp,-80
 76e:	e486                	sd	ra,72(sp)
 770:	e0a2                	sd	s0,64(sp)
 772:	0880                	addi	s0,sp,80
 774:	87aa                	mv	a5,a0
 776:	fcb43023          	sd	a1,-64(s0)
 77a:	fac43c23          	sd	a2,-72(s0)
 77e:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 782:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 786:	fe042223          	sw	zero,-28(s0)
 78a:	a42d                	j	9b4 <vprintf+0x248>
    c = fmt[i] & 0xff;
 78c:	fe442783          	lw	a5,-28(s0)
 790:	fc043703          	ld	a4,-64(s0)
 794:	97ba                	add	a5,a5,a4
 796:	0007c783          	lbu	a5,0(a5)
 79a:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 79e:	fe042783          	lw	a5,-32(s0)
 7a2:	2781                	sext.w	a5,a5
 7a4:	eb9d                	bnez	a5,7da <vprintf+0x6e>
      if(c == '%'){
 7a6:	fdc42783          	lw	a5,-36(s0)
 7aa:	0007871b          	sext.w	a4,a5
 7ae:	02500793          	li	a5,37
 7b2:	00f71763          	bne	a4,a5,7c0 <vprintf+0x54>
        state = '%';
 7b6:	02500793          	li	a5,37
 7ba:	fef42023          	sw	a5,-32(s0)
 7be:	a2f5                	j	9aa <vprintf+0x23e>
      } else {
        putc(fd, c);
 7c0:	fdc42783          	lw	a5,-36(s0)
 7c4:	0ff7f713          	zext.b	a4,a5
 7c8:	fcc42783          	lw	a5,-52(s0)
 7cc:	85ba                	mv	a1,a4
 7ce:	853e                	mv	a0,a5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	dd2080e7          	jalr	-558(ra) # 5a2 <putc>
 7d8:	aac9                	j	9aa <vprintf+0x23e>
      }
    } else if(state == '%'){
 7da:	fe042783          	lw	a5,-32(s0)
 7de:	0007871b          	sext.w	a4,a5
 7e2:	02500793          	li	a5,37
 7e6:	1cf71263          	bne	a4,a5,9aa <vprintf+0x23e>
      if(c == 'd'){
 7ea:	fdc42783          	lw	a5,-36(s0)
 7ee:	0007871b          	sext.w	a4,a5
 7f2:	06400793          	li	a5,100
 7f6:	02f71463          	bne	a4,a5,81e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 7fa:	fb843783          	ld	a5,-72(s0)
 7fe:	00878713          	addi	a4,a5,8
 802:	fae43c23          	sd	a4,-72(s0)
 806:	4398                	lw	a4,0(a5)
 808:	fcc42783          	lw	a5,-52(s0)
 80c:	4685                	li	a3,1
 80e:	4629                	li	a2,10
 810:	85ba                	mv	a1,a4
 812:	853e                	mv	a0,a5
 814:	00000097          	auipc	ra,0x0
 818:	dc4080e7          	jalr	-572(ra) # 5d8 <printint>
 81c:	a269                	j	9a6 <vprintf+0x23a>
      } else if(c == 'l') {
 81e:	fdc42783          	lw	a5,-36(s0)
 822:	0007871b          	sext.w	a4,a5
 826:	06c00793          	li	a5,108
 82a:	02f71663          	bne	a4,a5,856 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 82e:	fb843783          	ld	a5,-72(s0)
 832:	00878713          	addi	a4,a5,8
 836:	fae43c23          	sd	a4,-72(s0)
 83a:	639c                	ld	a5,0(a5)
 83c:	0007871b          	sext.w	a4,a5
 840:	fcc42783          	lw	a5,-52(s0)
 844:	4681                	li	a3,0
 846:	4629                	li	a2,10
 848:	85ba                	mv	a1,a4
 84a:	853e                	mv	a0,a5
 84c:	00000097          	auipc	ra,0x0
 850:	d8c080e7          	jalr	-628(ra) # 5d8 <printint>
 854:	aa89                	j	9a6 <vprintf+0x23a>
      } else if(c == 'x') {
 856:	fdc42783          	lw	a5,-36(s0)
 85a:	0007871b          	sext.w	a4,a5
 85e:	07800793          	li	a5,120
 862:	02f71463          	bne	a4,a5,88a <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 866:	fb843783          	ld	a5,-72(s0)
 86a:	00878713          	addi	a4,a5,8
 86e:	fae43c23          	sd	a4,-72(s0)
 872:	4398                	lw	a4,0(a5)
 874:	fcc42783          	lw	a5,-52(s0)
 878:	4681                	li	a3,0
 87a:	4641                	li	a2,16
 87c:	85ba                	mv	a1,a4
 87e:	853e                	mv	a0,a5
 880:	00000097          	auipc	ra,0x0
 884:	d58080e7          	jalr	-680(ra) # 5d8 <printint>
 888:	aa39                	j	9a6 <vprintf+0x23a>
      } else if(c == 'p') {
 88a:	fdc42783          	lw	a5,-36(s0)
 88e:	0007871b          	sext.w	a4,a5
 892:	07000793          	li	a5,112
 896:	02f71263          	bne	a4,a5,8ba <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 89a:	fb843783          	ld	a5,-72(s0)
 89e:	00878713          	addi	a4,a5,8
 8a2:	fae43c23          	sd	a4,-72(s0)
 8a6:	6398                	ld	a4,0(a5)
 8a8:	fcc42783          	lw	a5,-52(s0)
 8ac:	85ba                	mv	a1,a4
 8ae:	853e                	mv	a0,a5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	e30080e7          	jalr	-464(ra) # 6e0 <printptr>
 8b8:	a0fd                	j	9a6 <vprintf+0x23a>
      } else if(c == 's'){
 8ba:	fdc42783          	lw	a5,-36(s0)
 8be:	0007871b          	sext.w	a4,a5
 8c2:	07300793          	li	a5,115
 8c6:	04f71c63          	bne	a4,a5,91e <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8ca:	fb843783          	ld	a5,-72(s0)
 8ce:	00878713          	addi	a4,a5,8
 8d2:	fae43c23          	sd	a4,-72(s0)
 8d6:	639c                	ld	a5,0(a5)
 8d8:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8dc:	fe843783          	ld	a5,-24(s0)
 8e0:	eb8d                	bnez	a5,912 <vprintf+0x1a6>
          s = "(null)";
 8e2:	00000797          	auipc	a5,0x0
 8e6:	4ae78793          	addi	a5,a5,1198 # d90 <malloc+0x174>
 8ea:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8ee:	a015                	j	912 <vprintf+0x1a6>
          putc(fd, *s);
 8f0:	fe843783          	ld	a5,-24(s0)
 8f4:	0007c703          	lbu	a4,0(a5)
 8f8:	fcc42783          	lw	a5,-52(s0)
 8fc:	85ba                	mv	a1,a4
 8fe:	853e                	mv	a0,a5
 900:	00000097          	auipc	ra,0x0
 904:	ca2080e7          	jalr	-862(ra) # 5a2 <putc>
          s++;
 908:	fe843783          	ld	a5,-24(s0)
 90c:	0785                	addi	a5,a5,1
 90e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 912:	fe843783          	ld	a5,-24(s0)
 916:	0007c783          	lbu	a5,0(a5)
 91a:	fbf9                	bnez	a5,8f0 <vprintf+0x184>
 91c:	a069                	j	9a6 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 91e:	fdc42783          	lw	a5,-36(s0)
 922:	0007871b          	sext.w	a4,a5
 926:	06300793          	li	a5,99
 92a:	02f71463          	bne	a4,a5,952 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 92e:	fb843783          	ld	a5,-72(s0)
 932:	00878713          	addi	a4,a5,8
 936:	fae43c23          	sd	a4,-72(s0)
 93a:	439c                	lw	a5,0(a5)
 93c:	0ff7f713          	zext.b	a4,a5
 940:	fcc42783          	lw	a5,-52(s0)
 944:	85ba                	mv	a1,a4
 946:	853e                	mv	a0,a5
 948:	00000097          	auipc	ra,0x0
 94c:	c5a080e7          	jalr	-934(ra) # 5a2 <putc>
 950:	a899                	j	9a6 <vprintf+0x23a>
      } else if(c == '%'){
 952:	fdc42783          	lw	a5,-36(s0)
 956:	0007871b          	sext.w	a4,a5
 95a:	02500793          	li	a5,37
 95e:	00f71f63          	bne	a4,a5,97c <vprintf+0x210>
        putc(fd, c);
 962:	fdc42783          	lw	a5,-36(s0)
 966:	0ff7f713          	zext.b	a4,a5
 96a:	fcc42783          	lw	a5,-52(s0)
 96e:	85ba                	mv	a1,a4
 970:	853e                	mv	a0,a5
 972:	00000097          	auipc	ra,0x0
 976:	c30080e7          	jalr	-976(ra) # 5a2 <putc>
 97a:	a035                	j	9a6 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 97c:	fcc42783          	lw	a5,-52(s0)
 980:	02500593          	li	a1,37
 984:	853e                	mv	a0,a5
 986:	00000097          	auipc	ra,0x0
 98a:	c1c080e7          	jalr	-996(ra) # 5a2 <putc>
        putc(fd, c);
 98e:	fdc42783          	lw	a5,-36(s0)
 992:	0ff7f713          	zext.b	a4,a5
 996:	fcc42783          	lw	a5,-52(s0)
 99a:	85ba                	mv	a1,a4
 99c:	853e                	mv	a0,a5
 99e:	00000097          	auipc	ra,0x0
 9a2:	c04080e7          	jalr	-1020(ra) # 5a2 <putc>
      }
      state = 0;
 9a6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9aa:	fe442783          	lw	a5,-28(s0)
 9ae:	2785                	addiw	a5,a5,1
 9b0:	fef42223          	sw	a5,-28(s0)
 9b4:	fe442783          	lw	a5,-28(s0)
 9b8:	fc043703          	ld	a4,-64(s0)
 9bc:	97ba                	add	a5,a5,a4
 9be:	0007c783          	lbu	a5,0(a5)
 9c2:	dc0795e3          	bnez	a5,78c <vprintf+0x20>
    }
  }
}
 9c6:	0001                	nop
 9c8:	0001                	nop
 9ca:	60a6                	ld	ra,72(sp)
 9cc:	6406                	ld	s0,64(sp)
 9ce:	6161                	addi	sp,sp,80
 9d0:	8082                	ret

00000000000009d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9d2:	7159                	addi	sp,sp,-112
 9d4:	fc06                	sd	ra,56(sp)
 9d6:	f822                	sd	s0,48(sp)
 9d8:	0080                	addi	s0,sp,64
 9da:	fcb43823          	sd	a1,-48(s0)
 9de:	e010                	sd	a2,0(s0)
 9e0:	e414                	sd	a3,8(s0)
 9e2:	e818                	sd	a4,16(s0)
 9e4:	ec1c                	sd	a5,24(s0)
 9e6:	03043023          	sd	a6,32(s0)
 9ea:	03143423          	sd	a7,40(s0)
 9ee:	87aa                	mv	a5,a0
 9f0:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9f4:	03040793          	addi	a5,s0,48
 9f8:	fcf43423          	sd	a5,-56(s0)
 9fc:	fc843783          	ld	a5,-56(s0)
 a00:	fd078793          	addi	a5,a5,-48
 a04:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a08:	fe843703          	ld	a4,-24(s0)
 a0c:	fdc42783          	lw	a5,-36(s0)
 a10:	863a                	mv	a2,a4
 a12:	fd043583          	ld	a1,-48(s0)
 a16:	853e                	mv	a0,a5
 a18:	00000097          	auipc	ra,0x0
 a1c:	d54080e7          	jalr	-684(ra) # 76c <vprintf>
}
 a20:	0001                	nop
 a22:	70e2                	ld	ra,56(sp)
 a24:	7442                	ld	s0,48(sp)
 a26:	6165                	addi	sp,sp,112
 a28:	8082                	ret

0000000000000a2a <printf>:

void
printf(const char *fmt, ...)
{
 a2a:	7159                	addi	sp,sp,-112
 a2c:	f406                	sd	ra,40(sp)
 a2e:	f022                	sd	s0,32(sp)
 a30:	1800                	addi	s0,sp,48
 a32:	fca43c23          	sd	a0,-40(s0)
 a36:	e40c                	sd	a1,8(s0)
 a38:	e810                	sd	a2,16(s0)
 a3a:	ec14                	sd	a3,24(s0)
 a3c:	f018                	sd	a4,32(s0)
 a3e:	f41c                	sd	a5,40(s0)
 a40:	03043823          	sd	a6,48(s0)
 a44:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a48:	04040793          	addi	a5,s0,64
 a4c:	fcf43823          	sd	a5,-48(s0)
 a50:	fd043783          	ld	a5,-48(s0)
 a54:	fc878793          	addi	a5,a5,-56
 a58:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a5c:	fe843783          	ld	a5,-24(s0)
 a60:	863e                	mv	a2,a5
 a62:	fd843583          	ld	a1,-40(s0)
 a66:	4505                	li	a0,1
 a68:	00000097          	auipc	ra,0x0
 a6c:	d04080e7          	jalr	-764(ra) # 76c <vprintf>
}
 a70:	0001                	nop
 a72:	70a2                	ld	ra,40(sp)
 a74:	7402                	ld	s0,32(sp)
 a76:	6165                	addi	sp,sp,112
 a78:	8082                	ret

0000000000000a7a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a7a:	7179                	addi	sp,sp,-48
 a7c:	f422                	sd	s0,40(sp)
 a7e:	1800                	addi	s0,sp,48
 a80:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a84:	fd843783          	ld	a5,-40(s0)
 a88:	17c1                	addi	a5,a5,-16
 a8a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8e:	00001797          	auipc	a5,0x1
 a92:	91278793          	addi	a5,a5,-1774 # 13a0 <freep>
 a96:	639c                	ld	a5,0(a5)
 a98:	fef43423          	sd	a5,-24(s0)
 a9c:	a815                	j	ad0 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a9e:	fe843783          	ld	a5,-24(s0)
 aa2:	639c                	ld	a5,0(a5)
 aa4:	fe843703          	ld	a4,-24(s0)
 aa8:	00f76f63          	bltu	a4,a5,ac6 <free+0x4c>
 aac:	fe043703          	ld	a4,-32(s0)
 ab0:	fe843783          	ld	a5,-24(s0)
 ab4:	02e7eb63          	bltu	a5,a4,aea <free+0x70>
 ab8:	fe843783          	ld	a5,-24(s0)
 abc:	639c                	ld	a5,0(a5)
 abe:	fe043703          	ld	a4,-32(s0)
 ac2:	02f76463          	bltu	a4,a5,aea <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac6:	fe843783          	ld	a5,-24(s0)
 aca:	639c                	ld	a5,0(a5)
 acc:	fef43423          	sd	a5,-24(s0)
 ad0:	fe043703          	ld	a4,-32(s0)
 ad4:	fe843783          	ld	a5,-24(s0)
 ad8:	fce7f3e3          	bgeu	a5,a4,a9e <free+0x24>
 adc:	fe843783          	ld	a5,-24(s0)
 ae0:	639c                	ld	a5,0(a5)
 ae2:	fe043703          	ld	a4,-32(s0)
 ae6:	faf77ce3          	bgeu	a4,a5,a9e <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 aea:	fe043783          	ld	a5,-32(s0)
 aee:	479c                	lw	a5,8(a5)
 af0:	1782                	slli	a5,a5,0x20
 af2:	9381                	srli	a5,a5,0x20
 af4:	0792                	slli	a5,a5,0x4
 af6:	fe043703          	ld	a4,-32(s0)
 afa:	973e                	add	a4,a4,a5
 afc:	fe843783          	ld	a5,-24(s0)
 b00:	639c                	ld	a5,0(a5)
 b02:	02f71763          	bne	a4,a5,b30 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b06:	fe043783          	ld	a5,-32(s0)
 b0a:	4798                	lw	a4,8(a5)
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	639c                	ld	a5,0(a5)
 b12:	479c                	lw	a5,8(a5)
 b14:	9fb9                	addw	a5,a5,a4
 b16:	0007871b          	sext.w	a4,a5
 b1a:	fe043783          	ld	a5,-32(s0)
 b1e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b20:	fe843783          	ld	a5,-24(s0)
 b24:	639c                	ld	a5,0(a5)
 b26:	6398                	ld	a4,0(a5)
 b28:	fe043783          	ld	a5,-32(s0)
 b2c:	e398                	sd	a4,0(a5)
 b2e:	a039                	j	b3c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b30:	fe843783          	ld	a5,-24(s0)
 b34:	6398                	ld	a4,0(a5)
 b36:	fe043783          	ld	a5,-32(s0)
 b3a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b3c:	fe843783          	ld	a5,-24(s0)
 b40:	479c                	lw	a5,8(a5)
 b42:	1782                	slli	a5,a5,0x20
 b44:	9381                	srli	a5,a5,0x20
 b46:	0792                	slli	a5,a5,0x4
 b48:	fe843703          	ld	a4,-24(s0)
 b4c:	97ba                	add	a5,a5,a4
 b4e:	fe043703          	ld	a4,-32(s0)
 b52:	02f71563          	bne	a4,a5,b7c <free+0x102>
    p->s.size += bp->s.size;
 b56:	fe843783          	ld	a5,-24(s0)
 b5a:	4798                	lw	a4,8(a5)
 b5c:	fe043783          	ld	a5,-32(s0)
 b60:	479c                	lw	a5,8(a5)
 b62:	9fb9                	addw	a5,a5,a4
 b64:	0007871b          	sext.w	a4,a5
 b68:	fe843783          	ld	a5,-24(s0)
 b6c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b6e:	fe043783          	ld	a5,-32(s0)
 b72:	6398                	ld	a4,0(a5)
 b74:	fe843783          	ld	a5,-24(s0)
 b78:	e398                	sd	a4,0(a5)
 b7a:	a031                	j	b86 <free+0x10c>
  } else
    p->s.ptr = bp;
 b7c:	fe843783          	ld	a5,-24(s0)
 b80:	fe043703          	ld	a4,-32(s0)
 b84:	e398                	sd	a4,0(a5)
  freep = p;
 b86:	00001797          	auipc	a5,0x1
 b8a:	81a78793          	addi	a5,a5,-2022 # 13a0 <freep>
 b8e:	fe843703          	ld	a4,-24(s0)
 b92:	e398                	sd	a4,0(a5)
}
 b94:	0001                	nop
 b96:	7422                	ld	s0,40(sp)
 b98:	6145                	addi	sp,sp,48
 b9a:	8082                	ret

0000000000000b9c <morecore>:

static Header*
morecore(uint nu)
{
 b9c:	7179                	addi	sp,sp,-48
 b9e:	f406                	sd	ra,40(sp)
 ba0:	f022                	sd	s0,32(sp)
 ba2:	1800                	addi	s0,sp,48
 ba4:	87aa                	mv	a5,a0
 ba6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 baa:	fdc42783          	lw	a5,-36(s0)
 bae:	0007871b          	sext.w	a4,a5
 bb2:	6785                	lui	a5,0x1
 bb4:	00f77563          	bgeu	a4,a5,bbe <morecore+0x22>
    nu = 4096;
 bb8:	6785                	lui	a5,0x1
 bba:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bbe:	fdc42783          	lw	a5,-36(s0)
 bc2:	0047979b          	slliw	a5,a5,0x4
 bc6:	2781                	sext.w	a5,a5
 bc8:	2781                	sext.w	a5,a5
 bca:	853e                	mv	a0,a5
 bcc:	00000097          	auipc	ra,0x0
 bd0:	9be080e7          	jalr	-1602(ra) # 58a <sbrk>
 bd4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bd8:	fe843703          	ld	a4,-24(s0)
 bdc:	57fd                	li	a5,-1
 bde:	00f71463          	bne	a4,a5,be6 <morecore+0x4a>
    return 0;
 be2:	4781                	li	a5,0
 be4:	a03d                	j	c12 <morecore+0x76>
  hp = (Header*)p;
 be6:	fe843783          	ld	a5,-24(s0)
 bea:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bee:	fe043783          	ld	a5,-32(s0)
 bf2:	fdc42703          	lw	a4,-36(s0)
 bf6:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 bf8:	fe043783          	ld	a5,-32(s0)
 bfc:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3f4>
 bfe:	853e                	mv	a0,a5
 c00:	00000097          	auipc	ra,0x0
 c04:	e7a080e7          	jalr	-390(ra) # a7a <free>
  return freep;
 c08:	00000797          	auipc	a5,0x0
 c0c:	79878793          	addi	a5,a5,1944 # 13a0 <freep>
 c10:	639c                	ld	a5,0(a5)
}
 c12:	853e                	mv	a0,a5
 c14:	70a2                	ld	ra,40(sp)
 c16:	7402                	ld	s0,32(sp)
 c18:	6145                	addi	sp,sp,48
 c1a:	8082                	ret

0000000000000c1c <malloc>:

void*
malloc(uint nbytes)
{
 c1c:	7139                	addi	sp,sp,-64
 c1e:	fc06                	sd	ra,56(sp)
 c20:	f822                	sd	s0,48(sp)
 c22:	0080                	addi	s0,sp,64
 c24:	87aa                	mv	a5,a0
 c26:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c2a:	fcc46783          	lwu	a5,-52(s0)
 c2e:	07bd                	addi	a5,a5,15
 c30:	8391                	srli	a5,a5,0x4
 c32:	2781                	sext.w	a5,a5
 c34:	2785                	addiw	a5,a5,1
 c36:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c3a:	00000797          	auipc	a5,0x0
 c3e:	76678793          	addi	a5,a5,1894 # 13a0 <freep>
 c42:	639c                	ld	a5,0(a5)
 c44:	fef43023          	sd	a5,-32(s0)
 c48:	fe043783          	ld	a5,-32(s0)
 c4c:	ef95                	bnez	a5,c88 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c4e:	00000797          	auipc	a5,0x0
 c52:	74278793          	addi	a5,a5,1858 # 1390 <base>
 c56:	fef43023          	sd	a5,-32(s0)
 c5a:	00000797          	auipc	a5,0x0
 c5e:	74678793          	addi	a5,a5,1862 # 13a0 <freep>
 c62:	fe043703          	ld	a4,-32(s0)
 c66:	e398                	sd	a4,0(a5)
 c68:	00000797          	auipc	a5,0x0
 c6c:	73878793          	addi	a5,a5,1848 # 13a0 <freep>
 c70:	6398                	ld	a4,0(a5)
 c72:	00000797          	auipc	a5,0x0
 c76:	71e78793          	addi	a5,a5,1822 # 1390 <base>
 c7a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c7c:	00000797          	auipc	a5,0x0
 c80:	71478793          	addi	a5,a5,1812 # 1390 <base>
 c84:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c88:	fe043783          	ld	a5,-32(s0)
 c8c:	639c                	ld	a5,0(a5)
 c8e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c92:	fe843783          	ld	a5,-24(s0)
 c96:	4798                	lw	a4,8(a5)
 c98:	fdc42783          	lw	a5,-36(s0)
 c9c:	2781                	sext.w	a5,a5
 c9e:	06f76763          	bltu	a4,a5,d0c <malloc+0xf0>
      if(p->s.size == nunits)
 ca2:	fe843783          	ld	a5,-24(s0)
 ca6:	4798                	lw	a4,8(a5)
 ca8:	fdc42783          	lw	a5,-36(s0)
 cac:	2781                	sext.w	a5,a5
 cae:	00e79963          	bne	a5,a4,cc0 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cb2:	fe843783          	ld	a5,-24(s0)
 cb6:	6398                	ld	a4,0(a5)
 cb8:	fe043783          	ld	a5,-32(s0)
 cbc:	e398                	sd	a4,0(a5)
 cbe:	a825                	j	cf6 <malloc+0xda>
      else {
        p->s.size -= nunits;
 cc0:	fe843783          	ld	a5,-24(s0)
 cc4:	479c                	lw	a5,8(a5)
 cc6:	fdc42703          	lw	a4,-36(s0)
 cca:	9f99                	subw	a5,a5,a4
 ccc:	0007871b          	sext.w	a4,a5
 cd0:	fe843783          	ld	a5,-24(s0)
 cd4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cd6:	fe843783          	ld	a5,-24(s0)
 cda:	479c                	lw	a5,8(a5)
 cdc:	1782                	slli	a5,a5,0x20
 cde:	9381                	srli	a5,a5,0x20
 ce0:	0792                	slli	a5,a5,0x4
 ce2:	fe843703          	ld	a4,-24(s0)
 ce6:	97ba                	add	a5,a5,a4
 ce8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cec:	fe843783          	ld	a5,-24(s0)
 cf0:	fdc42703          	lw	a4,-36(s0)
 cf4:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 cf6:	00000797          	auipc	a5,0x0
 cfa:	6aa78793          	addi	a5,a5,1706 # 13a0 <freep>
 cfe:	fe043703          	ld	a4,-32(s0)
 d02:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d04:	fe843783          	ld	a5,-24(s0)
 d08:	07c1                	addi	a5,a5,16
 d0a:	a091                	j	d4e <malloc+0x132>
    }
    if(p == freep)
 d0c:	00000797          	auipc	a5,0x0
 d10:	69478793          	addi	a5,a5,1684 # 13a0 <freep>
 d14:	639c                	ld	a5,0(a5)
 d16:	fe843703          	ld	a4,-24(s0)
 d1a:	02f71063          	bne	a4,a5,d3a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d1e:	fdc42783          	lw	a5,-36(s0)
 d22:	853e                	mv	a0,a5
 d24:	00000097          	auipc	ra,0x0
 d28:	e78080e7          	jalr	-392(ra) # b9c <morecore>
 d2c:	fea43423          	sd	a0,-24(s0)
 d30:	fe843783          	ld	a5,-24(s0)
 d34:	e399                	bnez	a5,d3a <malloc+0x11e>
        return 0;
 d36:	4781                	li	a5,0
 d38:	a819                	j	d4e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d3a:	fe843783          	ld	a5,-24(s0)
 d3e:	fef43023          	sd	a5,-32(s0)
 d42:	fe843783          	ld	a5,-24(s0)
 d46:	639c                	ld	a5,0(a5)
 d48:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d4c:	b799                	j	c92 <malloc+0x76>
  }
}
 d4e:	853e                	mv	a0,a5
 d50:	70e2                	ld	ra,56(sp)
 d52:	7442                	ld	s0,48(sp)
 d54:	6121                	addi	sp,sp,64
 d56:	8082                	ret
