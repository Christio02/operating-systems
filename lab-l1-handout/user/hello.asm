
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
    if (argc == 1) {
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	00f71b63          	bne	a4,a5,32 <main+0x32>
        printf("Hello World\n");
  20:	00001517          	auipc	a0,0x1
  24:	d5050513          	addi	a0,a0,-688 # d70 <malloc+0x144>
  28:	00001097          	auipc	ra,0x1
  2c:	a12080e7          	jalr	-1518(ra) # a3a <printf>
  30:	a831                	j	4c <main+0x4c>

    } else {
        printf("Hello %s, nice to meet you!\n ", argv[1]);
  32:	fe043783          	ld	a5,-32(s0)
  36:	07a1                	addi	a5,a5,8
  38:	639c                	ld	a5,0(a5)
  3a:	85be                	mv	a1,a5
  3c:	00001517          	auipc	a0,0x1
  40:	d4450513          	addi	a0,a0,-700 # d80 <malloc+0x154>
  44:	00001097          	auipc	ra,0x1
  48:	9f6080e7          	jalr	-1546(ra) # a3a <printf>
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

00000000000005b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b2:	1101                	addi	sp,sp,-32
 5b4:	ec06                	sd	ra,24(sp)
 5b6:	e822                	sd	s0,16(sp)
 5b8:	1000                	addi	s0,sp,32
 5ba:	87aa                	mv	a5,a0
 5bc:	872e                	mv	a4,a1
 5be:	fef42623          	sw	a5,-20(s0)
 5c2:	87ba                	mv	a5,a4
 5c4:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5c8:	feb40713          	addi	a4,s0,-21
 5cc:	fec42783          	lw	a5,-20(s0)
 5d0:	4605                	li	a2,1
 5d2:	85ba                	mv	a1,a4
 5d4:	853e                	mv	a0,a5
 5d6:	00000097          	auipc	ra,0x0
 5da:	f4c080e7          	jalr	-180(ra) # 522 <write>
}
 5de:	0001                	nop
 5e0:	60e2                	ld	ra,24(sp)
 5e2:	6442                	ld	s0,16(sp)
 5e4:	6105                	addi	sp,sp,32
 5e6:	8082                	ret

00000000000005e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e8:	7139                	addi	sp,sp,-64
 5ea:	fc06                	sd	ra,56(sp)
 5ec:	f822                	sd	s0,48(sp)
 5ee:	0080                	addi	s0,sp,64
 5f0:	87aa                	mv	a5,a0
 5f2:	8736                	mv	a4,a3
 5f4:	fcf42623          	sw	a5,-52(s0)
 5f8:	87ae                	mv	a5,a1
 5fa:	fcf42423          	sw	a5,-56(s0)
 5fe:	87b2                	mv	a5,a2
 600:	fcf42223          	sw	a5,-60(s0)
 604:	87ba                	mv	a5,a4
 606:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 60a:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 60e:	fc042783          	lw	a5,-64(s0)
 612:	2781                	sext.w	a5,a5
 614:	c38d                	beqz	a5,636 <printint+0x4e>
 616:	fc842783          	lw	a5,-56(s0)
 61a:	2781                	sext.w	a5,a5
 61c:	0007dd63          	bgez	a5,636 <printint+0x4e>
    neg = 1;
 620:	4785                	li	a5,1
 622:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 626:	fc842783          	lw	a5,-56(s0)
 62a:	40f007bb          	negw	a5,a5
 62e:	2781                	sext.w	a5,a5
 630:	fef42223          	sw	a5,-28(s0)
 634:	a029                	j	63e <printint+0x56>
  } else {
    x = xx;
 636:	fc842783          	lw	a5,-56(s0)
 63a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 63e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 642:	fc442783          	lw	a5,-60(s0)
 646:	fe442703          	lw	a4,-28(s0)
 64a:	02f777bb          	remuw	a5,a4,a5
 64e:	0007861b          	sext.w	a2,a5
 652:	fec42783          	lw	a5,-20(s0)
 656:	0017871b          	addiw	a4,a5,1
 65a:	fee42623          	sw	a4,-20(s0)
 65e:	00001697          	auipc	a3,0x1
 662:	d1268693          	addi	a3,a3,-750 # 1370 <digits>
 666:	02061713          	slli	a4,a2,0x20
 66a:	9301                	srli	a4,a4,0x20
 66c:	9736                	add	a4,a4,a3
 66e:	00074703          	lbu	a4,0(a4)
 672:	17c1                	addi	a5,a5,-16
 674:	97a2                	add	a5,a5,s0
 676:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 67a:	fc442783          	lw	a5,-60(s0)
 67e:	fe442703          	lw	a4,-28(s0)
 682:	02f757bb          	divuw	a5,a4,a5
 686:	fef42223          	sw	a5,-28(s0)
 68a:	fe442783          	lw	a5,-28(s0)
 68e:	2781                	sext.w	a5,a5
 690:	fbcd                	bnez	a5,642 <printint+0x5a>
  if(neg)
 692:	fe842783          	lw	a5,-24(s0)
 696:	2781                	sext.w	a5,a5
 698:	cf85                	beqz	a5,6d0 <printint+0xe8>
    buf[i++] = '-';
 69a:	fec42783          	lw	a5,-20(s0)
 69e:	0017871b          	addiw	a4,a5,1
 6a2:	fee42623          	sw	a4,-20(s0)
 6a6:	17c1                	addi	a5,a5,-16
 6a8:	97a2                	add	a5,a5,s0
 6aa:	02d00713          	li	a4,45
 6ae:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6b2:	a839                	j	6d0 <printint+0xe8>
    putc(fd, buf[i]);
 6b4:	fec42783          	lw	a5,-20(s0)
 6b8:	17c1                	addi	a5,a5,-16
 6ba:	97a2                	add	a5,a5,s0
 6bc:	fe07c703          	lbu	a4,-32(a5)
 6c0:	fcc42783          	lw	a5,-52(s0)
 6c4:	85ba                	mv	a1,a4
 6c6:	853e                	mv	a0,a5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	eea080e7          	jalr	-278(ra) # 5b2 <putc>
  while(--i >= 0)
 6d0:	fec42783          	lw	a5,-20(s0)
 6d4:	37fd                	addiw	a5,a5,-1
 6d6:	fef42623          	sw	a5,-20(s0)
 6da:	fec42783          	lw	a5,-20(s0)
 6de:	2781                	sext.w	a5,a5
 6e0:	fc07dae3          	bgez	a5,6b4 <printint+0xcc>
}
 6e4:	0001                	nop
 6e6:	0001                	nop
 6e8:	70e2                	ld	ra,56(sp)
 6ea:	7442                	ld	s0,48(sp)
 6ec:	6121                	addi	sp,sp,64
 6ee:	8082                	ret

00000000000006f0 <printptr>:

static void
printptr(int fd, uint64 x) {
 6f0:	7179                	addi	sp,sp,-48
 6f2:	f406                	sd	ra,40(sp)
 6f4:	f022                	sd	s0,32(sp)
 6f6:	1800                	addi	s0,sp,48
 6f8:	87aa                	mv	a5,a0
 6fa:	fcb43823          	sd	a1,-48(s0)
 6fe:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 702:	fdc42783          	lw	a5,-36(s0)
 706:	03000593          	li	a1,48
 70a:	853e                	mv	a0,a5
 70c:	00000097          	auipc	ra,0x0
 710:	ea6080e7          	jalr	-346(ra) # 5b2 <putc>
  putc(fd, 'x');
 714:	fdc42783          	lw	a5,-36(s0)
 718:	07800593          	li	a1,120
 71c:	853e                	mv	a0,a5
 71e:	00000097          	auipc	ra,0x0
 722:	e94080e7          	jalr	-364(ra) # 5b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 726:	fe042623          	sw	zero,-20(s0)
 72a:	a82d                	j	764 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72c:	fd043783          	ld	a5,-48(s0)
 730:	93f1                	srli	a5,a5,0x3c
 732:	00001717          	auipc	a4,0x1
 736:	c3e70713          	addi	a4,a4,-962 # 1370 <digits>
 73a:	97ba                	add	a5,a5,a4
 73c:	0007c703          	lbu	a4,0(a5)
 740:	fdc42783          	lw	a5,-36(s0)
 744:	85ba                	mv	a1,a4
 746:	853e                	mv	a0,a5
 748:	00000097          	auipc	ra,0x0
 74c:	e6a080e7          	jalr	-406(ra) # 5b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 750:	fec42783          	lw	a5,-20(s0)
 754:	2785                	addiw	a5,a5,1
 756:	fef42623          	sw	a5,-20(s0)
 75a:	fd043783          	ld	a5,-48(s0)
 75e:	0792                	slli	a5,a5,0x4
 760:	fcf43823          	sd	a5,-48(s0)
 764:	fec42783          	lw	a5,-20(s0)
 768:	873e                	mv	a4,a5
 76a:	47bd                	li	a5,15
 76c:	fce7f0e3          	bgeu	a5,a4,72c <printptr+0x3c>
}
 770:	0001                	nop
 772:	0001                	nop
 774:	70a2                	ld	ra,40(sp)
 776:	7402                	ld	s0,32(sp)
 778:	6145                	addi	sp,sp,48
 77a:	8082                	ret

000000000000077c <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 77c:	715d                	addi	sp,sp,-80
 77e:	e486                	sd	ra,72(sp)
 780:	e0a2                	sd	s0,64(sp)
 782:	0880                	addi	s0,sp,80
 784:	87aa                	mv	a5,a0
 786:	fcb43023          	sd	a1,-64(s0)
 78a:	fac43c23          	sd	a2,-72(s0)
 78e:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 792:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 796:	fe042223          	sw	zero,-28(s0)
 79a:	a42d                	j	9c4 <vprintf+0x248>
    c = fmt[i] & 0xff;
 79c:	fe442783          	lw	a5,-28(s0)
 7a0:	fc043703          	ld	a4,-64(s0)
 7a4:	97ba                	add	a5,a5,a4
 7a6:	0007c783          	lbu	a5,0(a5)
 7aa:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7ae:	fe042783          	lw	a5,-32(s0)
 7b2:	2781                	sext.w	a5,a5
 7b4:	eb9d                	bnez	a5,7ea <vprintf+0x6e>
      if(c == '%'){
 7b6:	fdc42783          	lw	a5,-36(s0)
 7ba:	0007871b          	sext.w	a4,a5
 7be:	02500793          	li	a5,37
 7c2:	00f71763          	bne	a4,a5,7d0 <vprintf+0x54>
        state = '%';
 7c6:	02500793          	li	a5,37
 7ca:	fef42023          	sw	a5,-32(s0)
 7ce:	a2f5                	j	9ba <vprintf+0x23e>
      } else {
        putc(fd, c);
 7d0:	fdc42783          	lw	a5,-36(s0)
 7d4:	0ff7f713          	zext.b	a4,a5
 7d8:	fcc42783          	lw	a5,-52(s0)
 7dc:	85ba                	mv	a1,a4
 7de:	853e                	mv	a0,a5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	dd2080e7          	jalr	-558(ra) # 5b2 <putc>
 7e8:	aac9                	j	9ba <vprintf+0x23e>
      }
    } else if(state == '%'){
 7ea:	fe042783          	lw	a5,-32(s0)
 7ee:	0007871b          	sext.w	a4,a5
 7f2:	02500793          	li	a5,37
 7f6:	1cf71263          	bne	a4,a5,9ba <vprintf+0x23e>
      if(c == 'd'){
 7fa:	fdc42783          	lw	a5,-36(s0)
 7fe:	0007871b          	sext.w	a4,a5
 802:	06400793          	li	a5,100
 806:	02f71463          	bne	a4,a5,82e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 80a:	fb843783          	ld	a5,-72(s0)
 80e:	00878713          	addi	a4,a5,8
 812:	fae43c23          	sd	a4,-72(s0)
 816:	4398                	lw	a4,0(a5)
 818:	fcc42783          	lw	a5,-52(s0)
 81c:	4685                	li	a3,1
 81e:	4629                	li	a2,10
 820:	85ba                	mv	a1,a4
 822:	853e                	mv	a0,a5
 824:	00000097          	auipc	ra,0x0
 828:	dc4080e7          	jalr	-572(ra) # 5e8 <printint>
 82c:	a269                	j	9b6 <vprintf+0x23a>
      } else if(c == 'l') {
 82e:	fdc42783          	lw	a5,-36(s0)
 832:	0007871b          	sext.w	a4,a5
 836:	06c00793          	li	a5,108
 83a:	02f71663          	bne	a4,a5,866 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 83e:	fb843783          	ld	a5,-72(s0)
 842:	00878713          	addi	a4,a5,8
 846:	fae43c23          	sd	a4,-72(s0)
 84a:	639c                	ld	a5,0(a5)
 84c:	0007871b          	sext.w	a4,a5
 850:	fcc42783          	lw	a5,-52(s0)
 854:	4681                	li	a3,0
 856:	4629                	li	a2,10
 858:	85ba                	mv	a1,a4
 85a:	853e                	mv	a0,a5
 85c:	00000097          	auipc	ra,0x0
 860:	d8c080e7          	jalr	-628(ra) # 5e8 <printint>
 864:	aa89                	j	9b6 <vprintf+0x23a>
      } else if(c == 'x') {
 866:	fdc42783          	lw	a5,-36(s0)
 86a:	0007871b          	sext.w	a4,a5
 86e:	07800793          	li	a5,120
 872:	02f71463          	bne	a4,a5,89a <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 876:	fb843783          	ld	a5,-72(s0)
 87a:	00878713          	addi	a4,a5,8
 87e:	fae43c23          	sd	a4,-72(s0)
 882:	4398                	lw	a4,0(a5)
 884:	fcc42783          	lw	a5,-52(s0)
 888:	4681                	li	a3,0
 88a:	4641                	li	a2,16
 88c:	85ba                	mv	a1,a4
 88e:	853e                	mv	a0,a5
 890:	00000097          	auipc	ra,0x0
 894:	d58080e7          	jalr	-680(ra) # 5e8 <printint>
 898:	aa39                	j	9b6 <vprintf+0x23a>
      } else if(c == 'p') {
 89a:	fdc42783          	lw	a5,-36(s0)
 89e:	0007871b          	sext.w	a4,a5
 8a2:	07000793          	li	a5,112
 8a6:	02f71263          	bne	a4,a5,8ca <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8aa:	fb843783          	ld	a5,-72(s0)
 8ae:	00878713          	addi	a4,a5,8
 8b2:	fae43c23          	sd	a4,-72(s0)
 8b6:	6398                	ld	a4,0(a5)
 8b8:	fcc42783          	lw	a5,-52(s0)
 8bc:	85ba                	mv	a1,a4
 8be:	853e                	mv	a0,a5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	e30080e7          	jalr	-464(ra) # 6f0 <printptr>
 8c8:	a0fd                	j	9b6 <vprintf+0x23a>
      } else if(c == 's'){
 8ca:	fdc42783          	lw	a5,-36(s0)
 8ce:	0007871b          	sext.w	a4,a5
 8d2:	07300793          	li	a5,115
 8d6:	04f71c63          	bne	a4,a5,92e <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8da:	fb843783          	ld	a5,-72(s0)
 8de:	00878713          	addi	a4,a5,8
 8e2:	fae43c23          	sd	a4,-72(s0)
 8e6:	639c                	ld	a5,0(a5)
 8e8:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8ec:	fe843783          	ld	a5,-24(s0)
 8f0:	eb8d                	bnez	a5,922 <vprintf+0x1a6>
          s = "(null)";
 8f2:	00000797          	auipc	a5,0x0
 8f6:	4ae78793          	addi	a5,a5,1198 # da0 <malloc+0x174>
 8fa:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8fe:	a015                	j	922 <vprintf+0x1a6>
          putc(fd, *s);
 900:	fe843783          	ld	a5,-24(s0)
 904:	0007c703          	lbu	a4,0(a5)
 908:	fcc42783          	lw	a5,-52(s0)
 90c:	85ba                	mv	a1,a4
 90e:	853e                	mv	a0,a5
 910:	00000097          	auipc	ra,0x0
 914:	ca2080e7          	jalr	-862(ra) # 5b2 <putc>
          s++;
 918:	fe843783          	ld	a5,-24(s0)
 91c:	0785                	addi	a5,a5,1
 91e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 922:	fe843783          	ld	a5,-24(s0)
 926:	0007c783          	lbu	a5,0(a5)
 92a:	fbf9                	bnez	a5,900 <vprintf+0x184>
 92c:	a069                	j	9b6 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 92e:	fdc42783          	lw	a5,-36(s0)
 932:	0007871b          	sext.w	a4,a5
 936:	06300793          	li	a5,99
 93a:	02f71463          	bne	a4,a5,962 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 93e:	fb843783          	ld	a5,-72(s0)
 942:	00878713          	addi	a4,a5,8
 946:	fae43c23          	sd	a4,-72(s0)
 94a:	439c                	lw	a5,0(a5)
 94c:	0ff7f713          	zext.b	a4,a5
 950:	fcc42783          	lw	a5,-52(s0)
 954:	85ba                	mv	a1,a4
 956:	853e                	mv	a0,a5
 958:	00000097          	auipc	ra,0x0
 95c:	c5a080e7          	jalr	-934(ra) # 5b2 <putc>
 960:	a899                	j	9b6 <vprintf+0x23a>
      } else if(c == '%'){
 962:	fdc42783          	lw	a5,-36(s0)
 966:	0007871b          	sext.w	a4,a5
 96a:	02500793          	li	a5,37
 96e:	00f71f63          	bne	a4,a5,98c <vprintf+0x210>
        putc(fd, c);
 972:	fdc42783          	lw	a5,-36(s0)
 976:	0ff7f713          	zext.b	a4,a5
 97a:	fcc42783          	lw	a5,-52(s0)
 97e:	85ba                	mv	a1,a4
 980:	853e                	mv	a0,a5
 982:	00000097          	auipc	ra,0x0
 986:	c30080e7          	jalr	-976(ra) # 5b2 <putc>
 98a:	a035                	j	9b6 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 98c:	fcc42783          	lw	a5,-52(s0)
 990:	02500593          	li	a1,37
 994:	853e                	mv	a0,a5
 996:	00000097          	auipc	ra,0x0
 99a:	c1c080e7          	jalr	-996(ra) # 5b2 <putc>
        putc(fd, c);
 99e:	fdc42783          	lw	a5,-36(s0)
 9a2:	0ff7f713          	zext.b	a4,a5
 9a6:	fcc42783          	lw	a5,-52(s0)
 9aa:	85ba                	mv	a1,a4
 9ac:	853e                	mv	a0,a5
 9ae:	00000097          	auipc	ra,0x0
 9b2:	c04080e7          	jalr	-1020(ra) # 5b2 <putc>
      }
      state = 0;
 9b6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9ba:	fe442783          	lw	a5,-28(s0)
 9be:	2785                	addiw	a5,a5,1
 9c0:	fef42223          	sw	a5,-28(s0)
 9c4:	fe442783          	lw	a5,-28(s0)
 9c8:	fc043703          	ld	a4,-64(s0)
 9cc:	97ba                	add	a5,a5,a4
 9ce:	0007c783          	lbu	a5,0(a5)
 9d2:	dc0795e3          	bnez	a5,79c <vprintf+0x20>
    }
  }
}
 9d6:	0001                	nop
 9d8:	0001                	nop
 9da:	60a6                	ld	ra,72(sp)
 9dc:	6406                	ld	s0,64(sp)
 9de:	6161                	addi	sp,sp,80
 9e0:	8082                	ret

00000000000009e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9e2:	7159                	addi	sp,sp,-112
 9e4:	fc06                	sd	ra,56(sp)
 9e6:	f822                	sd	s0,48(sp)
 9e8:	0080                	addi	s0,sp,64
 9ea:	fcb43823          	sd	a1,-48(s0)
 9ee:	e010                	sd	a2,0(s0)
 9f0:	e414                	sd	a3,8(s0)
 9f2:	e818                	sd	a4,16(s0)
 9f4:	ec1c                	sd	a5,24(s0)
 9f6:	03043023          	sd	a6,32(s0)
 9fa:	03143423          	sd	a7,40(s0)
 9fe:	87aa                	mv	a5,a0
 a00:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a04:	03040793          	addi	a5,s0,48
 a08:	fcf43423          	sd	a5,-56(s0)
 a0c:	fc843783          	ld	a5,-56(s0)
 a10:	fd078793          	addi	a5,a5,-48
 a14:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a18:	fe843703          	ld	a4,-24(s0)
 a1c:	fdc42783          	lw	a5,-36(s0)
 a20:	863a                	mv	a2,a4
 a22:	fd043583          	ld	a1,-48(s0)
 a26:	853e                	mv	a0,a5
 a28:	00000097          	auipc	ra,0x0
 a2c:	d54080e7          	jalr	-684(ra) # 77c <vprintf>
}
 a30:	0001                	nop
 a32:	70e2                	ld	ra,56(sp)
 a34:	7442                	ld	s0,48(sp)
 a36:	6165                	addi	sp,sp,112
 a38:	8082                	ret

0000000000000a3a <printf>:

void
printf(const char *fmt, ...)
{
 a3a:	7159                	addi	sp,sp,-112
 a3c:	f406                	sd	ra,40(sp)
 a3e:	f022                	sd	s0,32(sp)
 a40:	1800                	addi	s0,sp,48
 a42:	fca43c23          	sd	a0,-40(s0)
 a46:	e40c                	sd	a1,8(s0)
 a48:	e810                	sd	a2,16(s0)
 a4a:	ec14                	sd	a3,24(s0)
 a4c:	f018                	sd	a4,32(s0)
 a4e:	f41c                	sd	a5,40(s0)
 a50:	03043823          	sd	a6,48(s0)
 a54:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a58:	04040793          	addi	a5,s0,64
 a5c:	fcf43823          	sd	a5,-48(s0)
 a60:	fd043783          	ld	a5,-48(s0)
 a64:	fc878793          	addi	a5,a5,-56
 a68:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a6c:	fe843783          	ld	a5,-24(s0)
 a70:	863e                	mv	a2,a5
 a72:	fd843583          	ld	a1,-40(s0)
 a76:	4505                	li	a0,1
 a78:	00000097          	auipc	ra,0x0
 a7c:	d04080e7          	jalr	-764(ra) # 77c <vprintf>
}
 a80:	0001                	nop
 a82:	70a2                	ld	ra,40(sp)
 a84:	7402                	ld	s0,32(sp)
 a86:	6165                	addi	sp,sp,112
 a88:	8082                	ret

0000000000000a8a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a8a:	7179                	addi	sp,sp,-48
 a8c:	f422                	sd	s0,40(sp)
 a8e:	1800                	addi	s0,sp,48
 a90:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a94:	fd843783          	ld	a5,-40(s0)
 a98:	17c1                	addi	a5,a5,-16
 a9a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9e:	00001797          	auipc	a5,0x1
 aa2:	90278793          	addi	a5,a5,-1790 # 13a0 <freep>
 aa6:	639c                	ld	a5,0(a5)
 aa8:	fef43423          	sd	a5,-24(s0)
 aac:	a815                	j	ae0 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aae:	fe843783          	ld	a5,-24(s0)
 ab2:	639c                	ld	a5,0(a5)
 ab4:	fe843703          	ld	a4,-24(s0)
 ab8:	00f76f63          	bltu	a4,a5,ad6 <free+0x4c>
 abc:	fe043703          	ld	a4,-32(s0)
 ac0:	fe843783          	ld	a5,-24(s0)
 ac4:	02e7eb63          	bltu	a5,a4,afa <free+0x70>
 ac8:	fe843783          	ld	a5,-24(s0)
 acc:	639c                	ld	a5,0(a5)
 ace:	fe043703          	ld	a4,-32(s0)
 ad2:	02f76463          	bltu	a4,a5,afa <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad6:	fe843783          	ld	a5,-24(s0)
 ada:	639c                	ld	a5,0(a5)
 adc:	fef43423          	sd	a5,-24(s0)
 ae0:	fe043703          	ld	a4,-32(s0)
 ae4:	fe843783          	ld	a5,-24(s0)
 ae8:	fce7f3e3          	bgeu	a5,a4,aae <free+0x24>
 aec:	fe843783          	ld	a5,-24(s0)
 af0:	639c                	ld	a5,0(a5)
 af2:	fe043703          	ld	a4,-32(s0)
 af6:	faf77ce3          	bgeu	a4,a5,aae <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 afa:	fe043783          	ld	a5,-32(s0)
 afe:	479c                	lw	a5,8(a5)
 b00:	1782                	slli	a5,a5,0x20
 b02:	9381                	srli	a5,a5,0x20
 b04:	0792                	slli	a5,a5,0x4
 b06:	fe043703          	ld	a4,-32(s0)
 b0a:	973e                	add	a4,a4,a5
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	639c                	ld	a5,0(a5)
 b12:	02f71763          	bne	a4,a5,b40 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b16:	fe043783          	ld	a5,-32(s0)
 b1a:	4798                	lw	a4,8(a5)
 b1c:	fe843783          	ld	a5,-24(s0)
 b20:	639c                	ld	a5,0(a5)
 b22:	479c                	lw	a5,8(a5)
 b24:	9fb9                	addw	a5,a5,a4
 b26:	0007871b          	sext.w	a4,a5
 b2a:	fe043783          	ld	a5,-32(s0)
 b2e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b30:	fe843783          	ld	a5,-24(s0)
 b34:	639c                	ld	a5,0(a5)
 b36:	6398                	ld	a4,0(a5)
 b38:	fe043783          	ld	a5,-32(s0)
 b3c:	e398                	sd	a4,0(a5)
 b3e:	a039                	j	b4c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b40:	fe843783          	ld	a5,-24(s0)
 b44:	6398                	ld	a4,0(a5)
 b46:	fe043783          	ld	a5,-32(s0)
 b4a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b4c:	fe843783          	ld	a5,-24(s0)
 b50:	479c                	lw	a5,8(a5)
 b52:	1782                	slli	a5,a5,0x20
 b54:	9381                	srli	a5,a5,0x20
 b56:	0792                	slli	a5,a5,0x4
 b58:	fe843703          	ld	a4,-24(s0)
 b5c:	97ba                	add	a5,a5,a4
 b5e:	fe043703          	ld	a4,-32(s0)
 b62:	02f71563          	bne	a4,a5,b8c <free+0x102>
    p->s.size += bp->s.size;
 b66:	fe843783          	ld	a5,-24(s0)
 b6a:	4798                	lw	a4,8(a5)
 b6c:	fe043783          	ld	a5,-32(s0)
 b70:	479c                	lw	a5,8(a5)
 b72:	9fb9                	addw	a5,a5,a4
 b74:	0007871b          	sext.w	a4,a5
 b78:	fe843783          	ld	a5,-24(s0)
 b7c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b7e:	fe043783          	ld	a5,-32(s0)
 b82:	6398                	ld	a4,0(a5)
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	e398                	sd	a4,0(a5)
 b8a:	a031                	j	b96 <free+0x10c>
  } else
    p->s.ptr = bp;
 b8c:	fe843783          	ld	a5,-24(s0)
 b90:	fe043703          	ld	a4,-32(s0)
 b94:	e398                	sd	a4,0(a5)
  freep = p;
 b96:	00001797          	auipc	a5,0x1
 b9a:	80a78793          	addi	a5,a5,-2038 # 13a0 <freep>
 b9e:	fe843703          	ld	a4,-24(s0)
 ba2:	e398                	sd	a4,0(a5)
}
 ba4:	0001                	nop
 ba6:	7422                	ld	s0,40(sp)
 ba8:	6145                	addi	sp,sp,48
 baa:	8082                	ret

0000000000000bac <morecore>:

static Header*
morecore(uint nu)
{
 bac:	7179                	addi	sp,sp,-48
 bae:	f406                	sd	ra,40(sp)
 bb0:	f022                	sd	s0,32(sp)
 bb2:	1800                	addi	s0,sp,48
 bb4:	87aa                	mv	a5,a0
 bb6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bba:	fdc42783          	lw	a5,-36(s0)
 bbe:	0007871b          	sext.w	a4,a5
 bc2:	6785                	lui	a5,0x1
 bc4:	00f77563          	bgeu	a4,a5,bce <morecore+0x22>
    nu = 4096;
 bc8:	6785                	lui	a5,0x1
 bca:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bce:	fdc42783          	lw	a5,-36(s0)
 bd2:	0047979b          	slliw	a5,a5,0x4
 bd6:	2781                	sext.w	a5,a5
 bd8:	2781                	sext.w	a5,a5
 bda:	853e                	mv	a0,a5
 bdc:	00000097          	auipc	ra,0x0
 be0:	9ae080e7          	jalr	-1618(ra) # 58a <sbrk>
 be4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 be8:	fe843703          	ld	a4,-24(s0)
 bec:	57fd                	li	a5,-1
 bee:	00f71463          	bne	a4,a5,bf6 <morecore+0x4a>
    return 0;
 bf2:	4781                	li	a5,0
 bf4:	a03d                	j	c22 <morecore+0x76>
  hp = (Header*)p;
 bf6:	fe843783          	ld	a5,-24(s0)
 bfa:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bfe:	fe043783          	ld	a5,-32(s0)
 c02:	fdc42703          	lw	a4,-36(s0)
 c06:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c08:	fe043783          	ld	a5,-32(s0)
 c0c:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3e4>
 c0e:	853e                	mv	a0,a5
 c10:	00000097          	auipc	ra,0x0
 c14:	e7a080e7          	jalr	-390(ra) # a8a <free>
  return freep;
 c18:	00000797          	auipc	a5,0x0
 c1c:	78878793          	addi	a5,a5,1928 # 13a0 <freep>
 c20:	639c                	ld	a5,0(a5)
}
 c22:	853e                	mv	a0,a5
 c24:	70a2                	ld	ra,40(sp)
 c26:	7402                	ld	s0,32(sp)
 c28:	6145                	addi	sp,sp,48
 c2a:	8082                	ret

0000000000000c2c <malloc>:

void*
malloc(uint nbytes)
{
 c2c:	7139                	addi	sp,sp,-64
 c2e:	fc06                	sd	ra,56(sp)
 c30:	f822                	sd	s0,48(sp)
 c32:	0080                	addi	s0,sp,64
 c34:	87aa                	mv	a5,a0
 c36:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c3a:	fcc46783          	lwu	a5,-52(s0)
 c3e:	07bd                	addi	a5,a5,15
 c40:	8391                	srli	a5,a5,0x4
 c42:	2781                	sext.w	a5,a5
 c44:	2785                	addiw	a5,a5,1
 c46:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c4a:	00000797          	auipc	a5,0x0
 c4e:	75678793          	addi	a5,a5,1878 # 13a0 <freep>
 c52:	639c                	ld	a5,0(a5)
 c54:	fef43023          	sd	a5,-32(s0)
 c58:	fe043783          	ld	a5,-32(s0)
 c5c:	ef95                	bnez	a5,c98 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c5e:	00000797          	auipc	a5,0x0
 c62:	73278793          	addi	a5,a5,1842 # 1390 <base>
 c66:	fef43023          	sd	a5,-32(s0)
 c6a:	00000797          	auipc	a5,0x0
 c6e:	73678793          	addi	a5,a5,1846 # 13a0 <freep>
 c72:	fe043703          	ld	a4,-32(s0)
 c76:	e398                	sd	a4,0(a5)
 c78:	00000797          	auipc	a5,0x0
 c7c:	72878793          	addi	a5,a5,1832 # 13a0 <freep>
 c80:	6398                	ld	a4,0(a5)
 c82:	00000797          	auipc	a5,0x0
 c86:	70e78793          	addi	a5,a5,1806 # 1390 <base>
 c8a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c8c:	00000797          	auipc	a5,0x0
 c90:	70478793          	addi	a5,a5,1796 # 1390 <base>
 c94:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c98:	fe043783          	ld	a5,-32(s0)
 c9c:	639c                	ld	a5,0(a5)
 c9e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 ca2:	fe843783          	ld	a5,-24(s0)
 ca6:	4798                	lw	a4,8(a5)
 ca8:	fdc42783          	lw	a5,-36(s0)
 cac:	2781                	sext.w	a5,a5
 cae:	06f76763          	bltu	a4,a5,d1c <malloc+0xf0>
      if(p->s.size == nunits)
 cb2:	fe843783          	ld	a5,-24(s0)
 cb6:	4798                	lw	a4,8(a5)
 cb8:	fdc42783          	lw	a5,-36(s0)
 cbc:	2781                	sext.w	a5,a5
 cbe:	00e79963          	bne	a5,a4,cd0 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cc2:	fe843783          	ld	a5,-24(s0)
 cc6:	6398                	ld	a4,0(a5)
 cc8:	fe043783          	ld	a5,-32(s0)
 ccc:	e398                	sd	a4,0(a5)
 cce:	a825                	j	d06 <malloc+0xda>
      else {
        p->s.size -= nunits;
 cd0:	fe843783          	ld	a5,-24(s0)
 cd4:	479c                	lw	a5,8(a5)
 cd6:	fdc42703          	lw	a4,-36(s0)
 cda:	9f99                	subw	a5,a5,a4
 cdc:	0007871b          	sext.w	a4,a5
 ce0:	fe843783          	ld	a5,-24(s0)
 ce4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ce6:	fe843783          	ld	a5,-24(s0)
 cea:	479c                	lw	a5,8(a5)
 cec:	1782                	slli	a5,a5,0x20
 cee:	9381                	srli	a5,a5,0x20
 cf0:	0792                	slli	a5,a5,0x4
 cf2:	fe843703          	ld	a4,-24(s0)
 cf6:	97ba                	add	a5,a5,a4
 cf8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cfc:	fe843783          	ld	a5,-24(s0)
 d00:	fdc42703          	lw	a4,-36(s0)
 d04:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d06:	00000797          	auipc	a5,0x0
 d0a:	69a78793          	addi	a5,a5,1690 # 13a0 <freep>
 d0e:	fe043703          	ld	a4,-32(s0)
 d12:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d14:	fe843783          	ld	a5,-24(s0)
 d18:	07c1                	addi	a5,a5,16
 d1a:	a091                	j	d5e <malloc+0x132>
    }
    if(p == freep)
 d1c:	00000797          	auipc	a5,0x0
 d20:	68478793          	addi	a5,a5,1668 # 13a0 <freep>
 d24:	639c                	ld	a5,0(a5)
 d26:	fe843703          	ld	a4,-24(s0)
 d2a:	02f71063          	bne	a4,a5,d4a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d2e:	fdc42783          	lw	a5,-36(s0)
 d32:	853e                	mv	a0,a5
 d34:	00000097          	auipc	ra,0x0
 d38:	e78080e7          	jalr	-392(ra) # bac <morecore>
 d3c:	fea43423          	sd	a0,-24(s0)
 d40:	fe843783          	ld	a5,-24(s0)
 d44:	e399                	bnez	a5,d4a <malloc+0x11e>
        return 0;
 d46:	4781                	li	a5,0
 d48:	a819                	j	d5e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d4a:	fe843783          	ld	a5,-24(s0)
 d4e:	fef43023          	sd	a5,-32(s0)
 d52:	fe843783          	ld	a5,-24(s0)
 d56:	639c                	ld	a5,0(a5)
 d58:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d5c:	b799                	j	ca2 <malloc+0x76>
  }
}
 d5e:	853e                	mv	a0,a5
 d60:	70e2                	ld	ra,56(sp)
 d62:	7442                	ld	s0,48(sp)
 d64:	6121                	addi	sp,sp,64
 d66:	8082                	ret
