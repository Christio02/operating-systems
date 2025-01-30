
user/_hello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#include "user.h"



int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	87aa                	mv	a5,a0
   a:	feb43023          	sd	a1,-32(s0)
   e:	fef42623          	sw	a5,-20(s0)
    if (argc == 1) { // if we only one argument
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	00f71b63          	bne	a4,a5,32 <main+0x32>
        printf("Hello World\n"); // just print hello world
  20:	00001517          	auipc	a0,0x1
  24:	d5050513          	addi	a0,a0,-688 # d70 <malloc+0x13c>
  28:	00001097          	auipc	ra,0x1
  2c:	a1a080e7          	jalr	-1510(ra) # a42 <printf>
  30:	a831                	j	4c <main+0x4c>

    } else {
        printf("Hello %s, nice to meet you!\n ", argv[1]); // otherwiser print the argument also
  32:	fe043783          	ld	a5,-32(s0)
  36:	07a1                	addi	a5,a5,8
  38:	639c                	ld	a5,0(a5)
  3a:	85be                	mv	a1,a5
  3c:	00001517          	auipc	a0,0x1
  40:	d4450513          	addi	a0,a0,-700 # d80 <malloc+0x14c>
  44:	00001097          	auipc	ra,0x1
  48:	9fe080e7          	jalr	-1538(ra) # a42 <printf>
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

00000000000005a2 <hello>:
.global hello
hello:
 li a7, SYS_hello
 5a2:	48d9                	li	a7,22
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 5aa:	48dd                	li	a7,23
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 5b2:	48e1                	li	a7,24
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ba:	1101                	addi	sp,sp,-32
 5bc:	ec06                	sd	ra,24(sp)
 5be:	e822                	sd	s0,16(sp)
 5c0:	1000                	addi	s0,sp,32
 5c2:	87aa                	mv	a5,a0
 5c4:	872e                	mv	a4,a1
 5c6:	fef42623          	sw	a5,-20(s0)
 5ca:	87ba                	mv	a5,a4
 5cc:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5d0:	feb40713          	addi	a4,s0,-21
 5d4:	fec42783          	lw	a5,-20(s0)
 5d8:	4605                	li	a2,1
 5da:	85ba                	mv	a1,a4
 5dc:	853e                	mv	a0,a5
 5de:	00000097          	auipc	ra,0x0
 5e2:	f44080e7          	jalr	-188(ra) # 522 <write>
}
 5e6:	0001                	nop
 5e8:	60e2                	ld	ra,24(sp)
 5ea:	6442                	ld	s0,16(sp)
 5ec:	6105                	addi	sp,sp,32
 5ee:	8082                	ret

00000000000005f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f0:	7139                	addi	sp,sp,-64
 5f2:	fc06                	sd	ra,56(sp)
 5f4:	f822                	sd	s0,48(sp)
 5f6:	0080                	addi	s0,sp,64
 5f8:	87aa                	mv	a5,a0
 5fa:	8736                	mv	a4,a3
 5fc:	fcf42623          	sw	a5,-52(s0)
 600:	87ae                	mv	a5,a1
 602:	fcf42423          	sw	a5,-56(s0)
 606:	87b2                	mv	a5,a2
 608:	fcf42223          	sw	a5,-60(s0)
 60c:	87ba                	mv	a5,a4
 60e:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 612:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 616:	fc042783          	lw	a5,-64(s0)
 61a:	2781                	sext.w	a5,a5
 61c:	c38d                	beqz	a5,63e <printint+0x4e>
 61e:	fc842783          	lw	a5,-56(s0)
 622:	2781                	sext.w	a5,a5
 624:	0007dd63          	bgez	a5,63e <printint+0x4e>
    neg = 1;
 628:	4785                	li	a5,1
 62a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 62e:	fc842783          	lw	a5,-56(s0)
 632:	40f007bb          	negw	a5,a5
 636:	2781                	sext.w	a5,a5
 638:	fef42223          	sw	a5,-28(s0)
 63c:	a029                	j	646 <printint+0x56>
  } else {
    x = xx;
 63e:	fc842783          	lw	a5,-56(s0)
 642:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 646:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 64a:	fc442783          	lw	a5,-60(s0)
 64e:	fe442703          	lw	a4,-28(s0)
 652:	02f777bb          	remuw	a5,a4,a5
 656:	0007861b          	sext.w	a2,a5
 65a:	fec42783          	lw	a5,-20(s0)
 65e:	0017871b          	addiw	a4,a5,1
 662:	fee42623          	sw	a4,-20(s0)
 666:	00001697          	auipc	a3,0x1
 66a:	d0a68693          	addi	a3,a3,-758 # 1370 <digits>
 66e:	02061713          	slli	a4,a2,0x20
 672:	9301                	srli	a4,a4,0x20
 674:	9736                	add	a4,a4,a3
 676:	00074703          	lbu	a4,0(a4)
 67a:	17c1                	addi	a5,a5,-16
 67c:	97a2                	add	a5,a5,s0
 67e:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 682:	fc442783          	lw	a5,-60(s0)
 686:	fe442703          	lw	a4,-28(s0)
 68a:	02f757bb          	divuw	a5,a4,a5
 68e:	fef42223          	sw	a5,-28(s0)
 692:	fe442783          	lw	a5,-28(s0)
 696:	2781                	sext.w	a5,a5
 698:	fbcd                	bnez	a5,64a <printint+0x5a>
  if(neg)
 69a:	fe842783          	lw	a5,-24(s0)
 69e:	2781                	sext.w	a5,a5
 6a0:	cf85                	beqz	a5,6d8 <printint+0xe8>
    buf[i++] = '-';
 6a2:	fec42783          	lw	a5,-20(s0)
 6a6:	0017871b          	addiw	a4,a5,1
 6aa:	fee42623          	sw	a4,-20(s0)
 6ae:	17c1                	addi	a5,a5,-16
 6b0:	97a2                	add	a5,a5,s0
 6b2:	02d00713          	li	a4,45
 6b6:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6ba:	a839                	j	6d8 <printint+0xe8>
    putc(fd, buf[i]);
 6bc:	fec42783          	lw	a5,-20(s0)
 6c0:	17c1                	addi	a5,a5,-16
 6c2:	97a2                	add	a5,a5,s0
 6c4:	fe07c703          	lbu	a4,-32(a5)
 6c8:	fcc42783          	lw	a5,-52(s0)
 6cc:	85ba                	mv	a1,a4
 6ce:	853e                	mv	a0,a5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	eea080e7          	jalr	-278(ra) # 5ba <putc>
  while(--i >= 0)
 6d8:	fec42783          	lw	a5,-20(s0)
 6dc:	37fd                	addiw	a5,a5,-1
 6de:	fef42623          	sw	a5,-20(s0)
 6e2:	fec42783          	lw	a5,-20(s0)
 6e6:	2781                	sext.w	a5,a5
 6e8:	fc07dae3          	bgez	a5,6bc <printint+0xcc>
}
 6ec:	0001                	nop
 6ee:	0001                	nop
 6f0:	70e2                	ld	ra,56(sp)
 6f2:	7442                	ld	s0,48(sp)
 6f4:	6121                	addi	sp,sp,64
 6f6:	8082                	ret

00000000000006f8 <printptr>:

static void
printptr(int fd, uint64 x) {
 6f8:	7179                	addi	sp,sp,-48
 6fa:	f406                	sd	ra,40(sp)
 6fc:	f022                	sd	s0,32(sp)
 6fe:	1800                	addi	s0,sp,48
 700:	87aa                	mv	a5,a0
 702:	fcb43823          	sd	a1,-48(s0)
 706:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 70a:	fdc42783          	lw	a5,-36(s0)
 70e:	03000593          	li	a1,48
 712:	853e                	mv	a0,a5
 714:	00000097          	auipc	ra,0x0
 718:	ea6080e7          	jalr	-346(ra) # 5ba <putc>
  putc(fd, 'x');
 71c:	fdc42783          	lw	a5,-36(s0)
 720:	07800593          	li	a1,120
 724:	853e                	mv	a0,a5
 726:	00000097          	auipc	ra,0x0
 72a:	e94080e7          	jalr	-364(ra) # 5ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72e:	fe042623          	sw	zero,-20(s0)
 732:	a82d                	j	76c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 734:	fd043783          	ld	a5,-48(s0)
 738:	93f1                	srli	a5,a5,0x3c
 73a:	00001717          	auipc	a4,0x1
 73e:	c3670713          	addi	a4,a4,-970 # 1370 <digits>
 742:	97ba                	add	a5,a5,a4
 744:	0007c703          	lbu	a4,0(a5)
 748:	fdc42783          	lw	a5,-36(s0)
 74c:	85ba                	mv	a1,a4
 74e:	853e                	mv	a0,a5
 750:	00000097          	auipc	ra,0x0
 754:	e6a080e7          	jalr	-406(ra) # 5ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 758:	fec42783          	lw	a5,-20(s0)
 75c:	2785                	addiw	a5,a5,1
 75e:	fef42623          	sw	a5,-20(s0)
 762:	fd043783          	ld	a5,-48(s0)
 766:	0792                	slli	a5,a5,0x4
 768:	fcf43823          	sd	a5,-48(s0)
 76c:	fec42783          	lw	a5,-20(s0)
 770:	873e                	mv	a4,a5
 772:	47bd                	li	a5,15
 774:	fce7f0e3          	bgeu	a5,a4,734 <printptr+0x3c>
}
 778:	0001                	nop
 77a:	0001                	nop
 77c:	70a2                	ld	ra,40(sp)
 77e:	7402                	ld	s0,32(sp)
 780:	6145                	addi	sp,sp,48
 782:	8082                	ret

0000000000000784 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 784:	715d                	addi	sp,sp,-80
 786:	e486                	sd	ra,72(sp)
 788:	e0a2                	sd	s0,64(sp)
 78a:	0880                	addi	s0,sp,80
 78c:	87aa                	mv	a5,a0
 78e:	fcb43023          	sd	a1,-64(s0)
 792:	fac43c23          	sd	a2,-72(s0)
 796:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 79a:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 79e:	fe042223          	sw	zero,-28(s0)
 7a2:	a42d                	j	9cc <vprintf+0x248>
    c = fmt[i] & 0xff;
 7a4:	fe442783          	lw	a5,-28(s0)
 7a8:	fc043703          	ld	a4,-64(s0)
 7ac:	97ba                	add	a5,a5,a4
 7ae:	0007c783          	lbu	a5,0(a5)
 7b2:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7b6:	fe042783          	lw	a5,-32(s0)
 7ba:	2781                	sext.w	a5,a5
 7bc:	eb9d                	bnez	a5,7f2 <vprintf+0x6e>
      if(c == '%'){
 7be:	fdc42783          	lw	a5,-36(s0)
 7c2:	0007871b          	sext.w	a4,a5
 7c6:	02500793          	li	a5,37
 7ca:	00f71763          	bne	a4,a5,7d8 <vprintf+0x54>
        state = '%';
 7ce:	02500793          	li	a5,37
 7d2:	fef42023          	sw	a5,-32(s0)
 7d6:	a2f5                	j	9c2 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7d8:	fdc42783          	lw	a5,-36(s0)
 7dc:	0ff7f713          	zext.b	a4,a5
 7e0:	fcc42783          	lw	a5,-52(s0)
 7e4:	85ba                	mv	a1,a4
 7e6:	853e                	mv	a0,a5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	dd2080e7          	jalr	-558(ra) # 5ba <putc>
 7f0:	aac9                	j	9c2 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7f2:	fe042783          	lw	a5,-32(s0)
 7f6:	0007871b          	sext.w	a4,a5
 7fa:	02500793          	li	a5,37
 7fe:	1cf71263          	bne	a4,a5,9c2 <vprintf+0x23e>
      if(c == 'd'){
 802:	fdc42783          	lw	a5,-36(s0)
 806:	0007871b          	sext.w	a4,a5
 80a:	06400793          	li	a5,100
 80e:	02f71463          	bne	a4,a5,836 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 812:	fb843783          	ld	a5,-72(s0)
 816:	00878713          	addi	a4,a5,8
 81a:	fae43c23          	sd	a4,-72(s0)
 81e:	4398                	lw	a4,0(a5)
 820:	fcc42783          	lw	a5,-52(s0)
 824:	4685                	li	a3,1
 826:	4629                	li	a2,10
 828:	85ba                	mv	a1,a4
 82a:	853e                	mv	a0,a5
 82c:	00000097          	auipc	ra,0x0
 830:	dc4080e7          	jalr	-572(ra) # 5f0 <printint>
 834:	a269                	j	9be <vprintf+0x23a>
      } else if(c == 'l') {
 836:	fdc42783          	lw	a5,-36(s0)
 83a:	0007871b          	sext.w	a4,a5
 83e:	06c00793          	li	a5,108
 842:	02f71663          	bne	a4,a5,86e <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 846:	fb843783          	ld	a5,-72(s0)
 84a:	00878713          	addi	a4,a5,8
 84e:	fae43c23          	sd	a4,-72(s0)
 852:	639c                	ld	a5,0(a5)
 854:	0007871b          	sext.w	a4,a5
 858:	fcc42783          	lw	a5,-52(s0)
 85c:	4681                	li	a3,0
 85e:	4629                	li	a2,10
 860:	85ba                	mv	a1,a4
 862:	853e                	mv	a0,a5
 864:	00000097          	auipc	ra,0x0
 868:	d8c080e7          	jalr	-628(ra) # 5f0 <printint>
 86c:	aa89                	j	9be <vprintf+0x23a>
      } else if(c == 'x') {
 86e:	fdc42783          	lw	a5,-36(s0)
 872:	0007871b          	sext.w	a4,a5
 876:	07800793          	li	a5,120
 87a:	02f71463          	bne	a4,a5,8a2 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 87e:	fb843783          	ld	a5,-72(s0)
 882:	00878713          	addi	a4,a5,8
 886:	fae43c23          	sd	a4,-72(s0)
 88a:	4398                	lw	a4,0(a5)
 88c:	fcc42783          	lw	a5,-52(s0)
 890:	4681                	li	a3,0
 892:	4641                	li	a2,16
 894:	85ba                	mv	a1,a4
 896:	853e                	mv	a0,a5
 898:	00000097          	auipc	ra,0x0
 89c:	d58080e7          	jalr	-680(ra) # 5f0 <printint>
 8a0:	aa39                	j	9be <vprintf+0x23a>
      } else if(c == 'p') {
 8a2:	fdc42783          	lw	a5,-36(s0)
 8a6:	0007871b          	sext.w	a4,a5
 8aa:	07000793          	li	a5,112
 8ae:	02f71263          	bne	a4,a5,8d2 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8b2:	fb843783          	ld	a5,-72(s0)
 8b6:	00878713          	addi	a4,a5,8
 8ba:	fae43c23          	sd	a4,-72(s0)
 8be:	6398                	ld	a4,0(a5)
 8c0:	fcc42783          	lw	a5,-52(s0)
 8c4:	85ba                	mv	a1,a4
 8c6:	853e                	mv	a0,a5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e30080e7          	jalr	-464(ra) # 6f8 <printptr>
 8d0:	a0fd                	j	9be <vprintf+0x23a>
      } else if(c == 's'){
 8d2:	fdc42783          	lw	a5,-36(s0)
 8d6:	0007871b          	sext.w	a4,a5
 8da:	07300793          	li	a5,115
 8de:	04f71c63          	bne	a4,a5,936 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8e2:	fb843783          	ld	a5,-72(s0)
 8e6:	00878713          	addi	a4,a5,8
 8ea:	fae43c23          	sd	a4,-72(s0)
 8ee:	639c                	ld	a5,0(a5)
 8f0:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8f4:	fe843783          	ld	a5,-24(s0)
 8f8:	eb8d                	bnez	a5,92a <vprintf+0x1a6>
          s = "(null)";
 8fa:	00000797          	auipc	a5,0x0
 8fe:	4a678793          	addi	a5,a5,1190 # da0 <malloc+0x16c>
 902:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 906:	a015                	j	92a <vprintf+0x1a6>
          putc(fd, *s);
 908:	fe843783          	ld	a5,-24(s0)
 90c:	0007c703          	lbu	a4,0(a5)
 910:	fcc42783          	lw	a5,-52(s0)
 914:	85ba                	mv	a1,a4
 916:	853e                	mv	a0,a5
 918:	00000097          	auipc	ra,0x0
 91c:	ca2080e7          	jalr	-862(ra) # 5ba <putc>
          s++;
 920:	fe843783          	ld	a5,-24(s0)
 924:	0785                	addi	a5,a5,1
 926:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 92a:	fe843783          	ld	a5,-24(s0)
 92e:	0007c783          	lbu	a5,0(a5)
 932:	fbf9                	bnez	a5,908 <vprintf+0x184>
 934:	a069                	j	9be <vprintf+0x23a>
        }
      } else if(c == 'c'){
 936:	fdc42783          	lw	a5,-36(s0)
 93a:	0007871b          	sext.w	a4,a5
 93e:	06300793          	li	a5,99
 942:	02f71463          	bne	a4,a5,96a <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 946:	fb843783          	ld	a5,-72(s0)
 94a:	00878713          	addi	a4,a5,8
 94e:	fae43c23          	sd	a4,-72(s0)
 952:	439c                	lw	a5,0(a5)
 954:	0ff7f713          	zext.b	a4,a5
 958:	fcc42783          	lw	a5,-52(s0)
 95c:	85ba                	mv	a1,a4
 95e:	853e                	mv	a0,a5
 960:	00000097          	auipc	ra,0x0
 964:	c5a080e7          	jalr	-934(ra) # 5ba <putc>
 968:	a899                	j	9be <vprintf+0x23a>
      } else if(c == '%'){
 96a:	fdc42783          	lw	a5,-36(s0)
 96e:	0007871b          	sext.w	a4,a5
 972:	02500793          	li	a5,37
 976:	00f71f63          	bne	a4,a5,994 <vprintf+0x210>
        putc(fd, c);
 97a:	fdc42783          	lw	a5,-36(s0)
 97e:	0ff7f713          	zext.b	a4,a5
 982:	fcc42783          	lw	a5,-52(s0)
 986:	85ba                	mv	a1,a4
 988:	853e                	mv	a0,a5
 98a:	00000097          	auipc	ra,0x0
 98e:	c30080e7          	jalr	-976(ra) # 5ba <putc>
 992:	a035                	j	9be <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 994:	fcc42783          	lw	a5,-52(s0)
 998:	02500593          	li	a1,37
 99c:	853e                	mv	a0,a5
 99e:	00000097          	auipc	ra,0x0
 9a2:	c1c080e7          	jalr	-996(ra) # 5ba <putc>
        putc(fd, c);
 9a6:	fdc42783          	lw	a5,-36(s0)
 9aa:	0ff7f713          	zext.b	a4,a5
 9ae:	fcc42783          	lw	a5,-52(s0)
 9b2:	85ba                	mv	a1,a4
 9b4:	853e                	mv	a0,a5
 9b6:	00000097          	auipc	ra,0x0
 9ba:	c04080e7          	jalr	-1020(ra) # 5ba <putc>
      }
      state = 0;
 9be:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9c2:	fe442783          	lw	a5,-28(s0)
 9c6:	2785                	addiw	a5,a5,1
 9c8:	fef42223          	sw	a5,-28(s0)
 9cc:	fe442783          	lw	a5,-28(s0)
 9d0:	fc043703          	ld	a4,-64(s0)
 9d4:	97ba                	add	a5,a5,a4
 9d6:	0007c783          	lbu	a5,0(a5)
 9da:	dc0795e3          	bnez	a5,7a4 <vprintf+0x20>
    }
  }
}
 9de:	0001                	nop
 9e0:	0001                	nop
 9e2:	60a6                	ld	ra,72(sp)
 9e4:	6406                	ld	s0,64(sp)
 9e6:	6161                	addi	sp,sp,80
 9e8:	8082                	ret

00000000000009ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9ea:	7159                	addi	sp,sp,-112
 9ec:	fc06                	sd	ra,56(sp)
 9ee:	f822                	sd	s0,48(sp)
 9f0:	0080                	addi	s0,sp,64
 9f2:	fcb43823          	sd	a1,-48(s0)
 9f6:	e010                	sd	a2,0(s0)
 9f8:	e414                	sd	a3,8(s0)
 9fa:	e818                	sd	a4,16(s0)
 9fc:	ec1c                	sd	a5,24(s0)
 9fe:	03043023          	sd	a6,32(s0)
 a02:	03143423          	sd	a7,40(s0)
 a06:	87aa                	mv	a5,a0
 a08:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a0c:	03040793          	addi	a5,s0,48
 a10:	fcf43423          	sd	a5,-56(s0)
 a14:	fc843783          	ld	a5,-56(s0)
 a18:	fd078793          	addi	a5,a5,-48
 a1c:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a20:	fe843703          	ld	a4,-24(s0)
 a24:	fdc42783          	lw	a5,-36(s0)
 a28:	863a                	mv	a2,a4
 a2a:	fd043583          	ld	a1,-48(s0)
 a2e:	853e                	mv	a0,a5
 a30:	00000097          	auipc	ra,0x0
 a34:	d54080e7          	jalr	-684(ra) # 784 <vprintf>
}
 a38:	0001                	nop
 a3a:	70e2                	ld	ra,56(sp)
 a3c:	7442                	ld	s0,48(sp)
 a3e:	6165                	addi	sp,sp,112
 a40:	8082                	ret

0000000000000a42 <printf>:

void
printf(const char *fmt, ...)
{
 a42:	7159                	addi	sp,sp,-112
 a44:	f406                	sd	ra,40(sp)
 a46:	f022                	sd	s0,32(sp)
 a48:	1800                	addi	s0,sp,48
 a4a:	fca43c23          	sd	a0,-40(s0)
 a4e:	e40c                	sd	a1,8(s0)
 a50:	e810                	sd	a2,16(s0)
 a52:	ec14                	sd	a3,24(s0)
 a54:	f018                	sd	a4,32(s0)
 a56:	f41c                	sd	a5,40(s0)
 a58:	03043823          	sd	a6,48(s0)
 a5c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a60:	04040793          	addi	a5,s0,64
 a64:	fcf43823          	sd	a5,-48(s0)
 a68:	fd043783          	ld	a5,-48(s0)
 a6c:	fc878793          	addi	a5,a5,-56
 a70:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a74:	fe843783          	ld	a5,-24(s0)
 a78:	863e                	mv	a2,a5
 a7a:	fd843583          	ld	a1,-40(s0)
 a7e:	4505                	li	a0,1
 a80:	00000097          	auipc	ra,0x0
 a84:	d04080e7          	jalr	-764(ra) # 784 <vprintf>
}
 a88:	0001                	nop
 a8a:	70a2                	ld	ra,40(sp)
 a8c:	7402                	ld	s0,32(sp)
 a8e:	6165                	addi	sp,sp,112
 a90:	8082                	ret

0000000000000a92 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a92:	7179                	addi	sp,sp,-48
 a94:	f422                	sd	s0,40(sp)
 a96:	1800                	addi	s0,sp,48
 a98:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a9c:	fd843783          	ld	a5,-40(s0)
 aa0:	17c1                	addi	a5,a5,-16
 aa2:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa6:	00001797          	auipc	a5,0x1
 aaa:	8fa78793          	addi	a5,a5,-1798 # 13a0 <freep>
 aae:	639c                	ld	a5,0(a5)
 ab0:	fef43423          	sd	a5,-24(s0)
 ab4:	a815                	j	ae8 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab6:	fe843783          	ld	a5,-24(s0)
 aba:	639c                	ld	a5,0(a5)
 abc:	fe843703          	ld	a4,-24(s0)
 ac0:	00f76f63          	bltu	a4,a5,ade <free+0x4c>
 ac4:	fe043703          	ld	a4,-32(s0)
 ac8:	fe843783          	ld	a5,-24(s0)
 acc:	02e7eb63          	bltu	a5,a4,b02 <free+0x70>
 ad0:	fe843783          	ld	a5,-24(s0)
 ad4:	639c                	ld	a5,0(a5)
 ad6:	fe043703          	ld	a4,-32(s0)
 ada:	02f76463          	bltu	a4,a5,b02 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ade:	fe843783          	ld	a5,-24(s0)
 ae2:	639c                	ld	a5,0(a5)
 ae4:	fef43423          	sd	a5,-24(s0)
 ae8:	fe043703          	ld	a4,-32(s0)
 aec:	fe843783          	ld	a5,-24(s0)
 af0:	fce7f3e3          	bgeu	a5,a4,ab6 <free+0x24>
 af4:	fe843783          	ld	a5,-24(s0)
 af8:	639c                	ld	a5,0(a5)
 afa:	fe043703          	ld	a4,-32(s0)
 afe:	faf77ce3          	bgeu	a4,a5,ab6 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b02:	fe043783          	ld	a5,-32(s0)
 b06:	479c                	lw	a5,8(a5)
 b08:	1782                	slli	a5,a5,0x20
 b0a:	9381                	srli	a5,a5,0x20
 b0c:	0792                	slli	a5,a5,0x4
 b0e:	fe043703          	ld	a4,-32(s0)
 b12:	973e                	add	a4,a4,a5
 b14:	fe843783          	ld	a5,-24(s0)
 b18:	639c                	ld	a5,0(a5)
 b1a:	02f71763          	bne	a4,a5,b48 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b1e:	fe043783          	ld	a5,-32(s0)
 b22:	4798                	lw	a4,8(a5)
 b24:	fe843783          	ld	a5,-24(s0)
 b28:	639c                	ld	a5,0(a5)
 b2a:	479c                	lw	a5,8(a5)
 b2c:	9fb9                	addw	a5,a5,a4
 b2e:	0007871b          	sext.w	a4,a5
 b32:	fe043783          	ld	a5,-32(s0)
 b36:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b38:	fe843783          	ld	a5,-24(s0)
 b3c:	639c                	ld	a5,0(a5)
 b3e:	6398                	ld	a4,0(a5)
 b40:	fe043783          	ld	a5,-32(s0)
 b44:	e398                	sd	a4,0(a5)
 b46:	a039                	j	b54 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b48:	fe843783          	ld	a5,-24(s0)
 b4c:	6398                	ld	a4,0(a5)
 b4e:	fe043783          	ld	a5,-32(s0)
 b52:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b54:	fe843783          	ld	a5,-24(s0)
 b58:	479c                	lw	a5,8(a5)
 b5a:	1782                	slli	a5,a5,0x20
 b5c:	9381                	srli	a5,a5,0x20
 b5e:	0792                	slli	a5,a5,0x4
 b60:	fe843703          	ld	a4,-24(s0)
 b64:	97ba                	add	a5,a5,a4
 b66:	fe043703          	ld	a4,-32(s0)
 b6a:	02f71563          	bne	a4,a5,b94 <free+0x102>
    p->s.size += bp->s.size;
 b6e:	fe843783          	ld	a5,-24(s0)
 b72:	4798                	lw	a4,8(a5)
 b74:	fe043783          	ld	a5,-32(s0)
 b78:	479c                	lw	a5,8(a5)
 b7a:	9fb9                	addw	a5,a5,a4
 b7c:	0007871b          	sext.w	a4,a5
 b80:	fe843783          	ld	a5,-24(s0)
 b84:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b86:	fe043783          	ld	a5,-32(s0)
 b8a:	6398                	ld	a4,0(a5)
 b8c:	fe843783          	ld	a5,-24(s0)
 b90:	e398                	sd	a4,0(a5)
 b92:	a031                	j	b9e <free+0x10c>
  } else
    p->s.ptr = bp;
 b94:	fe843783          	ld	a5,-24(s0)
 b98:	fe043703          	ld	a4,-32(s0)
 b9c:	e398                	sd	a4,0(a5)
  freep = p;
 b9e:	00001797          	auipc	a5,0x1
 ba2:	80278793          	addi	a5,a5,-2046 # 13a0 <freep>
 ba6:	fe843703          	ld	a4,-24(s0)
 baa:	e398                	sd	a4,0(a5)
}
 bac:	0001                	nop
 bae:	7422                	ld	s0,40(sp)
 bb0:	6145                	addi	sp,sp,48
 bb2:	8082                	ret

0000000000000bb4 <morecore>:

static Header*
morecore(uint nu)
{
 bb4:	7179                	addi	sp,sp,-48
 bb6:	f406                	sd	ra,40(sp)
 bb8:	f022                	sd	s0,32(sp)
 bba:	1800                	addi	s0,sp,48
 bbc:	87aa                	mv	a5,a0
 bbe:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bc2:	fdc42783          	lw	a5,-36(s0)
 bc6:	0007871b          	sext.w	a4,a5
 bca:	6785                	lui	a5,0x1
 bcc:	00f77563          	bgeu	a4,a5,bd6 <morecore+0x22>
    nu = 4096;
 bd0:	6785                	lui	a5,0x1
 bd2:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bd6:	fdc42783          	lw	a5,-36(s0)
 bda:	0047979b          	slliw	a5,a5,0x4
 bde:	2781                	sext.w	a5,a5
 be0:	2781                	sext.w	a5,a5
 be2:	853e                	mv	a0,a5
 be4:	00000097          	auipc	ra,0x0
 be8:	9a6080e7          	jalr	-1626(ra) # 58a <sbrk>
 bec:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bf0:	fe843703          	ld	a4,-24(s0)
 bf4:	57fd                	li	a5,-1
 bf6:	00f71463          	bne	a4,a5,bfe <morecore+0x4a>
    return 0;
 bfa:	4781                	li	a5,0
 bfc:	a03d                	j	c2a <morecore+0x76>
  hp = (Header*)p;
 bfe:	fe843783          	ld	a5,-24(s0)
 c02:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c06:	fe043783          	ld	a5,-32(s0)
 c0a:	fdc42703          	lw	a4,-36(s0)
 c0e:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c10:	fe043783          	ld	a5,-32(s0)
 c14:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3dc>
 c16:	853e                	mv	a0,a5
 c18:	00000097          	auipc	ra,0x0
 c1c:	e7a080e7          	jalr	-390(ra) # a92 <free>
  return freep;
 c20:	00000797          	auipc	a5,0x0
 c24:	78078793          	addi	a5,a5,1920 # 13a0 <freep>
 c28:	639c                	ld	a5,0(a5)
}
 c2a:	853e                	mv	a0,a5
 c2c:	70a2                	ld	ra,40(sp)
 c2e:	7402                	ld	s0,32(sp)
 c30:	6145                	addi	sp,sp,48
 c32:	8082                	ret

0000000000000c34 <malloc>:

void*
malloc(uint nbytes)
{
 c34:	7139                	addi	sp,sp,-64
 c36:	fc06                	sd	ra,56(sp)
 c38:	f822                	sd	s0,48(sp)
 c3a:	0080                	addi	s0,sp,64
 c3c:	87aa                	mv	a5,a0
 c3e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c42:	fcc46783          	lwu	a5,-52(s0)
 c46:	07bd                	addi	a5,a5,15
 c48:	8391                	srli	a5,a5,0x4
 c4a:	2781                	sext.w	a5,a5
 c4c:	2785                	addiw	a5,a5,1
 c4e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c52:	00000797          	auipc	a5,0x0
 c56:	74e78793          	addi	a5,a5,1870 # 13a0 <freep>
 c5a:	639c                	ld	a5,0(a5)
 c5c:	fef43023          	sd	a5,-32(s0)
 c60:	fe043783          	ld	a5,-32(s0)
 c64:	ef95                	bnez	a5,ca0 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c66:	00000797          	auipc	a5,0x0
 c6a:	72a78793          	addi	a5,a5,1834 # 1390 <base>
 c6e:	fef43023          	sd	a5,-32(s0)
 c72:	00000797          	auipc	a5,0x0
 c76:	72e78793          	addi	a5,a5,1838 # 13a0 <freep>
 c7a:	fe043703          	ld	a4,-32(s0)
 c7e:	e398                	sd	a4,0(a5)
 c80:	00000797          	auipc	a5,0x0
 c84:	72078793          	addi	a5,a5,1824 # 13a0 <freep>
 c88:	6398                	ld	a4,0(a5)
 c8a:	00000797          	auipc	a5,0x0
 c8e:	70678793          	addi	a5,a5,1798 # 1390 <base>
 c92:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c94:	00000797          	auipc	a5,0x0
 c98:	6fc78793          	addi	a5,a5,1788 # 1390 <base>
 c9c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ca0:	fe043783          	ld	a5,-32(s0)
 ca4:	639c                	ld	a5,0(a5)
 ca6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 caa:	fe843783          	ld	a5,-24(s0)
 cae:	4798                	lw	a4,8(a5)
 cb0:	fdc42783          	lw	a5,-36(s0)
 cb4:	2781                	sext.w	a5,a5
 cb6:	06f76763          	bltu	a4,a5,d24 <malloc+0xf0>
      if(p->s.size == nunits)
 cba:	fe843783          	ld	a5,-24(s0)
 cbe:	4798                	lw	a4,8(a5)
 cc0:	fdc42783          	lw	a5,-36(s0)
 cc4:	2781                	sext.w	a5,a5
 cc6:	00e79963          	bne	a5,a4,cd8 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cca:	fe843783          	ld	a5,-24(s0)
 cce:	6398                	ld	a4,0(a5)
 cd0:	fe043783          	ld	a5,-32(s0)
 cd4:	e398                	sd	a4,0(a5)
 cd6:	a825                	j	d0e <malloc+0xda>
      else {
        p->s.size -= nunits;
 cd8:	fe843783          	ld	a5,-24(s0)
 cdc:	479c                	lw	a5,8(a5)
 cde:	fdc42703          	lw	a4,-36(s0)
 ce2:	9f99                	subw	a5,a5,a4
 ce4:	0007871b          	sext.w	a4,a5
 ce8:	fe843783          	ld	a5,-24(s0)
 cec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cee:	fe843783          	ld	a5,-24(s0)
 cf2:	479c                	lw	a5,8(a5)
 cf4:	1782                	slli	a5,a5,0x20
 cf6:	9381                	srli	a5,a5,0x20
 cf8:	0792                	slli	a5,a5,0x4
 cfa:	fe843703          	ld	a4,-24(s0)
 cfe:	97ba                	add	a5,a5,a4
 d00:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d04:	fe843783          	ld	a5,-24(s0)
 d08:	fdc42703          	lw	a4,-36(s0)
 d0c:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d0e:	00000797          	auipc	a5,0x0
 d12:	69278793          	addi	a5,a5,1682 # 13a0 <freep>
 d16:	fe043703          	ld	a4,-32(s0)
 d1a:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d1c:	fe843783          	ld	a5,-24(s0)
 d20:	07c1                	addi	a5,a5,16
 d22:	a091                	j	d66 <malloc+0x132>
    }
    if(p == freep)
 d24:	00000797          	auipc	a5,0x0
 d28:	67c78793          	addi	a5,a5,1660 # 13a0 <freep>
 d2c:	639c                	ld	a5,0(a5)
 d2e:	fe843703          	ld	a4,-24(s0)
 d32:	02f71063          	bne	a4,a5,d52 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d36:	fdc42783          	lw	a5,-36(s0)
 d3a:	853e                	mv	a0,a5
 d3c:	00000097          	auipc	ra,0x0
 d40:	e78080e7          	jalr	-392(ra) # bb4 <morecore>
 d44:	fea43423          	sd	a0,-24(s0)
 d48:	fe843783          	ld	a5,-24(s0)
 d4c:	e399                	bnez	a5,d52 <malloc+0x11e>
        return 0;
 d4e:	4781                	li	a5,0
 d50:	a819                	j	d66 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d52:	fe843783          	ld	a5,-24(s0)
 d56:	fef43023          	sd	a5,-32(s0)
 d5a:	fe843783          	ld	a5,-24(s0)
 d5e:	639c                	ld	a5,0(a5)
 d60:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d64:	b799                	j	caa <malloc+0x76>
  }
}
 d66:	853e                	mv	a0,a5
 d68:	70e2                	ld	ra,56(sp)
 d6a:	7442                	ld	s0,48(sp)
 d6c:	6121                	addi	sp,sp,64
 d6e:	8082                	ret
