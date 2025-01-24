
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/process.h"
#include "user.h"


int main(int argc, char *argv[]) {
   0:	9d010113          	addi	sp,sp,-1584
   4:	62113423          	sd	ra,1576(sp)
   8:	62813023          	sd	s0,1568(sp)
   c:	63010413          	addi	s0,sp,1584
  10:	87aa                	mv	a5,a0
  12:	9cb43823          	sd	a1,-1584(s0)
  16:	9cf42e23          	sw	a5,-1572(s0)

   struct process_info info[64];
   int count = get_process(info, 64);
  1a:	9e840793          	addi	a5,s0,-1560
  1e:	04000593          	li	a1,64
  22:	853e                	mv	a0,a5
  24:	00000097          	auipc	ra,0x0
  28:	5de080e7          	jalr	1502(ra) # 602 <get_process>
  2c:	87aa                	mv	a5,a0
  2e:	fef42423          	sw	a5,-24(s0)

   for (int i = 0; i < count; i++) {
  32:	fe042623          	sw	zero,-20(s0)
  36:	a8b1                	j	92 <main+0x92>
      printf("%s (%d): %d\n", info[i].name, info[i].pid, info[i].state);
  38:	9e840693          	addi	a3,s0,-1560
  3c:	fec42703          	lw	a4,-20(s0)
  40:	87ba                	mv	a5,a4
  42:	0786                	slli	a5,a5,0x1
  44:	97ba                	add	a5,a5,a4
  46:	078e                	slli	a5,a5,0x3
  48:	97b6                	add	a5,a5,a3
  4a:	00878593          	addi	a1,a5,8
  4e:	fec42703          	lw	a4,-20(s0)
  52:	87ba                	mv	a5,a4
  54:	0786                	slli	a5,a5,0x1
  56:	97ba                	add	a5,a5,a4
  58:	078e                	slli	a5,a5,0x3
  5a:	17c1                	addi	a5,a5,-16
  5c:	97a2                	add	a5,a5,s0
  5e:	9f87a603          	lw	a2,-1544(a5)
  62:	fec42703          	lw	a4,-20(s0)
  66:	87ba                	mv	a5,a4
  68:	0786                	slli	a5,a5,0x1
  6a:	97ba                	add	a5,a5,a4
  6c:	078e                	slli	a5,a5,0x3
  6e:	17c1                	addi	a5,a5,-16
  70:	97a2                	add	a5,a5,s0
  72:	9fc7a783          	lw	a5,-1540(a5)
  76:	86be                	mv	a3,a5
  78:	00001517          	auipc	a0,0x1
  7c:	d4850513          	addi	a0,a0,-696 # dc0 <malloc+0x13c>
  80:	00001097          	auipc	ra,0x1
  84:	a12080e7          	jalr	-1518(ra) # a92 <printf>
   for (int i = 0; i < count; i++) {
  88:	fec42783          	lw	a5,-20(s0)
  8c:	2785                	addiw	a5,a5,1
  8e:	fef42623          	sw	a5,-20(s0)
  92:	fec42783          	lw	a5,-20(s0)
  96:	873e                	mv	a4,a5
  98:	fe842783          	lw	a5,-24(s0)
  9c:	2701                	sext.w	a4,a4
  9e:	2781                	sext.w	a5,a5
  a0:	f8f74ce3          	blt	a4,a5,38 <main+0x38>
   }

   exit(0);
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	4b4080e7          	jalr	1204(ra) # 55a <exit>

00000000000000ae <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  extern int main();
  main();
  b6:	00000097          	auipc	ra,0x0
  ba:	f4a080e7          	jalr	-182(ra) # 0 <main>
  exit(0);
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	49a080e7          	jalr	1178(ra) # 55a <exit>

00000000000000c8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  c8:	7179                	addi	sp,sp,-48
  ca:	f422                	sd	s0,40(sp)
  cc:	1800                	addi	s0,sp,48
  ce:	fca43c23          	sd	a0,-40(s0)
  d2:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  d6:	fd843783          	ld	a5,-40(s0)
  da:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  de:	0001                	nop
  e0:	fd043703          	ld	a4,-48(s0)
  e4:	00170793          	addi	a5,a4,1
  e8:	fcf43823          	sd	a5,-48(s0)
  ec:	fd843783          	ld	a5,-40(s0)
  f0:	00178693          	addi	a3,a5,1
  f4:	fcd43c23          	sd	a3,-40(s0)
  f8:	00074703          	lbu	a4,0(a4)
  fc:	00e78023          	sb	a4,0(a5)
 100:	0007c783          	lbu	a5,0(a5)
 104:	fff1                	bnez	a5,e0 <strcpy+0x18>
    ;
  return os;
 106:	fe843783          	ld	a5,-24(s0)
}
 10a:	853e                	mv	a0,a5
 10c:	7422                	ld	s0,40(sp)
 10e:	6145                	addi	sp,sp,48
 110:	8082                	ret

0000000000000112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 112:	1101                	addi	sp,sp,-32
 114:	ec22                	sd	s0,24(sp)
 116:	1000                	addi	s0,sp,32
 118:	fea43423          	sd	a0,-24(s0)
 11c:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 120:	a819                	j	136 <strcmp+0x24>
    p++, q++;
 122:	fe843783          	ld	a5,-24(s0)
 126:	0785                	addi	a5,a5,1
 128:	fef43423          	sd	a5,-24(s0)
 12c:	fe043783          	ld	a5,-32(s0)
 130:	0785                	addi	a5,a5,1
 132:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 136:	fe843783          	ld	a5,-24(s0)
 13a:	0007c783          	lbu	a5,0(a5)
 13e:	cb99                	beqz	a5,154 <strcmp+0x42>
 140:	fe843783          	ld	a5,-24(s0)
 144:	0007c703          	lbu	a4,0(a5)
 148:	fe043783          	ld	a5,-32(s0)
 14c:	0007c783          	lbu	a5,0(a5)
 150:	fcf709e3          	beq	a4,a5,122 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 154:	fe843783          	ld	a5,-24(s0)
 158:	0007c783          	lbu	a5,0(a5)
 15c:	0007871b          	sext.w	a4,a5
 160:	fe043783          	ld	a5,-32(s0)
 164:	0007c783          	lbu	a5,0(a5)
 168:	2781                	sext.w	a5,a5
 16a:	40f707bb          	subw	a5,a4,a5
 16e:	2781                	sext.w	a5,a5
}
 170:	853e                	mv	a0,a5
 172:	6462                	ld	s0,24(sp)
 174:	6105                	addi	sp,sp,32
 176:	8082                	ret

0000000000000178 <strlen>:

uint
strlen(const char *s)
{
 178:	7179                	addi	sp,sp,-48
 17a:	f422                	sd	s0,40(sp)
 17c:	1800                	addi	s0,sp,48
 17e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 182:	fe042623          	sw	zero,-20(s0)
 186:	a031                	j	192 <strlen+0x1a>
 188:	fec42783          	lw	a5,-20(s0)
 18c:	2785                	addiw	a5,a5,1
 18e:	fef42623          	sw	a5,-20(s0)
 192:	fec42783          	lw	a5,-20(s0)
 196:	fd843703          	ld	a4,-40(s0)
 19a:	97ba                	add	a5,a5,a4
 19c:	0007c783          	lbu	a5,0(a5)
 1a0:	f7e5                	bnez	a5,188 <strlen+0x10>
    ;
  return n;
 1a2:	fec42783          	lw	a5,-20(s0)
}
 1a6:	853e                	mv	a0,a5
 1a8:	7422                	ld	s0,40(sp)
 1aa:	6145                	addi	sp,sp,48
 1ac:	8082                	ret

00000000000001ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ae:	7179                	addi	sp,sp,-48
 1b0:	f422                	sd	s0,40(sp)
 1b2:	1800                	addi	s0,sp,48
 1b4:	fca43c23          	sd	a0,-40(s0)
 1b8:	87ae                	mv	a5,a1
 1ba:	8732                	mv	a4,a2
 1bc:	fcf42a23          	sw	a5,-44(s0)
 1c0:	87ba                	mv	a5,a4
 1c2:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1c6:	fd843783          	ld	a5,-40(s0)
 1ca:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1ce:	fe042623          	sw	zero,-20(s0)
 1d2:	a00d                	j	1f4 <memset+0x46>
    cdst[i] = c;
 1d4:	fec42783          	lw	a5,-20(s0)
 1d8:	fe043703          	ld	a4,-32(s0)
 1dc:	97ba                	add	a5,a5,a4
 1de:	fd442703          	lw	a4,-44(s0)
 1e2:	0ff77713          	zext.b	a4,a4
 1e6:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1ea:	fec42783          	lw	a5,-20(s0)
 1ee:	2785                	addiw	a5,a5,1
 1f0:	fef42623          	sw	a5,-20(s0)
 1f4:	fec42703          	lw	a4,-20(s0)
 1f8:	fd042783          	lw	a5,-48(s0)
 1fc:	2781                	sext.w	a5,a5
 1fe:	fcf76be3          	bltu	a4,a5,1d4 <memset+0x26>
  }
  return dst;
 202:	fd843783          	ld	a5,-40(s0)
}
 206:	853e                	mv	a0,a5
 208:	7422                	ld	s0,40(sp)
 20a:	6145                	addi	sp,sp,48
 20c:	8082                	ret

000000000000020e <strchr>:

char*
strchr(const char *s, char c)
{
 20e:	1101                	addi	sp,sp,-32
 210:	ec22                	sd	s0,24(sp)
 212:	1000                	addi	s0,sp,32
 214:	fea43423          	sd	a0,-24(s0)
 218:	87ae                	mv	a5,a1
 21a:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 21e:	a01d                	j	244 <strchr+0x36>
    if(*s == c)
 220:	fe843783          	ld	a5,-24(s0)
 224:	0007c703          	lbu	a4,0(a5)
 228:	fe744783          	lbu	a5,-25(s0)
 22c:	0ff7f793          	zext.b	a5,a5
 230:	00e79563          	bne	a5,a4,23a <strchr+0x2c>
      return (char*)s;
 234:	fe843783          	ld	a5,-24(s0)
 238:	a821                	j	250 <strchr+0x42>
  for(; *s; s++)
 23a:	fe843783          	ld	a5,-24(s0)
 23e:	0785                	addi	a5,a5,1
 240:	fef43423          	sd	a5,-24(s0)
 244:	fe843783          	ld	a5,-24(s0)
 248:	0007c783          	lbu	a5,0(a5)
 24c:	fbf1                	bnez	a5,220 <strchr+0x12>
  return 0;
 24e:	4781                	li	a5,0
}
 250:	853e                	mv	a0,a5
 252:	6462                	ld	s0,24(sp)
 254:	6105                	addi	sp,sp,32
 256:	8082                	ret

0000000000000258 <gets>:

char*
gets(char *buf, int max)
{
 258:	7179                	addi	sp,sp,-48
 25a:	f406                	sd	ra,40(sp)
 25c:	f022                	sd	s0,32(sp)
 25e:	1800                	addi	s0,sp,48
 260:	fca43c23          	sd	a0,-40(s0)
 264:	87ae                	mv	a5,a1
 266:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26a:	fe042623          	sw	zero,-20(s0)
 26e:	a8a1                	j	2c6 <gets+0x6e>
    cc = read(0, &c, 1);
 270:	fe740793          	addi	a5,s0,-25
 274:	4605                	li	a2,1
 276:	85be                	mv	a1,a5
 278:	4501                	li	a0,0
 27a:	00000097          	auipc	ra,0x0
 27e:	2f8080e7          	jalr	760(ra) # 572 <read>
 282:	87aa                	mv	a5,a0
 284:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 288:	fe842783          	lw	a5,-24(s0)
 28c:	2781                	sext.w	a5,a5
 28e:	04f05763          	blez	a5,2dc <gets+0x84>
      break;
    buf[i++] = c;
 292:	fec42783          	lw	a5,-20(s0)
 296:	0017871b          	addiw	a4,a5,1
 29a:	fee42623          	sw	a4,-20(s0)
 29e:	873e                	mv	a4,a5
 2a0:	fd843783          	ld	a5,-40(s0)
 2a4:	97ba                	add	a5,a5,a4
 2a6:	fe744703          	lbu	a4,-25(s0)
 2aa:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2ae:	fe744783          	lbu	a5,-25(s0)
 2b2:	873e                	mv	a4,a5
 2b4:	47a9                	li	a5,10
 2b6:	02f70463          	beq	a4,a5,2de <gets+0x86>
 2ba:	fe744783          	lbu	a5,-25(s0)
 2be:	873e                	mv	a4,a5
 2c0:	47b5                	li	a5,13
 2c2:	00f70e63          	beq	a4,a5,2de <gets+0x86>
  for(i=0; i+1 < max; ){
 2c6:	fec42783          	lw	a5,-20(s0)
 2ca:	2785                	addiw	a5,a5,1
 2cc:	0007871b          	sext.w	a4,a5
 2d0:	fd442783          	lw	a5,-44(s0)
 2d4:	2781                	sext.w	a5,a5
 2d6:	f8f74de3          	blt	a4,a5,270 <gets+0x18>
 2da:	a011                	j	2de <gets+0x86>
      break;
 2dc:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2de:	fec42783          	lw	a5,-20(s0)
 2e2:	fd843703          	ld	a4,-40(s0)
 2e6:	97ba                	add	a5,a5,a4
 2e8:	00078023          	sb	zero,0(a5)
  return buf;
 2ec:	fd843783          	ld	a5,-40(s0)
}
 2f0:	853e                	mv	a0,a5
 2f2:	70a2                	ld	ra,40(sp)
 2f4:	7402                	ld	s0,32(sp)
 2f6:	6145                	addi	sp,sp,48
 2f8:	8082                	ret

00000000000002fa <stat>:

int
stat(const char *n, struct stat *st)
{
 2fa:	7179                	addi	sp,sp,-48
 2fc:	f406                	sd	ra,40(sp)
 2fe:	f022                	sd	s0,32(sp)
 300:	1800                	addi	s0,sp,48
 302:	fca43c23          	sd	a0,-40(s0)
 306:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 30a:	4581                	li	a1,0
 30c:	fd843503          	ld	a0,-40(s0)
 310:	00000097          	auipc	ra,0x0
 314:	28a080e7          	jalr	650(ra) # 59a <open>
 318:	87aa                	mv	a5,a0
 31a:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 31e:	fec42783          	lw	a5,-20(s0)
 322:	2781                	sext.w	a5,a5
 324:	0007d463          	bgez	a5,32c <stat+0x32>
    return -1;
 328:	57fd                	li	a5,-1
 32a:	a035                	j	356 <stat+0x5c>
  r = fstat(fd, st);
 32c:	fec42783          	lw	a5,-20(s0)
 330:	fd043583          	ld	a1,-48(s0)
 334:	853e                	mv	a0,a5
 336:	00000097          	auipc	ra,0x0
 33a:	27c080e7          	jalr	636(ra) # 5b2 <fstat>
 33e:	87aa                	mv	a5,a0
 340:	fef42423          	sw	a5,-24(s0)
  close(fd);
 344:	fec42783          	lw	a5,-20(s0)
 348:	853e                	mv	a0,a5
 34a:	00000097          	auipc	ra,0x0
 34e:	238080e7          	jalr	568(ra) # 582 <close>
  return r;
 352:	fe842783          	lw	a5,-24(s0)
}
 356:	853e                	mv	a0,a5
 358:	70a2                	ld	ra,40(sp)
 35a:	7402                	ld	s0,32(sp)
 35c:	6145                	addi	sp,sp,48
 35e:	8082                	ret

0000000000000360 <atoi>:

int
atoi(const char *s)
{
 360:	7179                	addi	sp,sp,-48
 362:	f422                	sd	s0,40(sp)
 364:	1800                	addi	s0,sp,48
 366:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 36a:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 36e:	a81d                	j	3a4 <atoi+0x44>
    n = n*10 + *s++ - '0';
 370:	fec42783          	lw	a5,-20(s0)
 374:	873e                	mv	a4,a5
 376:	87ba                	mv	a5,a4
 378:	0027979b          	slliw	a5,a5,0x2
 37c:	9fb9                	addw	a5,a5,a4
 37e:	0017979b          	slliw	a5,a5,0x1
 382:	0007871b          	sext.w	a4,a5
 386:	fd843783          	ld	a5,-40(s0)
 38a:	00178693          	addi	a3,a5,1
 38e:	fcd43c23          	sd	a3,-40(s0)
 392:	0007c783          	lbu	a5,0(a5)
 396:	2781                	sext.w	a5,a5
 398:	9fb9                	addw	a5,a5,a4
 39a:	2781                	sext.w	a5,a5
 39c:	fd07879b          	addiw	a5,a5,-48
 3a0:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 3a4:	fd843783          	ld	a5,-40(s0)
 3a8:	0007c783          	lbu	a5,0(a5)
 3ac:	873e                	mv	a4,a5
 3ae:	02f00793          	li	a5,47
 3b2:	00e7fb63          	bgeu	a5,a4,3c8 <atoi+0x68>
 3b6:	fd843783          	ld	a5,-40(s0)
 3ba:	0007c783          	lbu	a5,0(a5)
 3be:	873e                	mv	a4,a5
 3c0:	03900793          	li	a5,57
 3c4:	fae7f6e3          	bgeu	a5,a4,370 <atoi+0x10>
  return n;
 3c8:	fec42783          	lw	a5,-20(s0)
}
 3cc:	853e                	mv	a0,a5
 3ce:	7422                	ld	s0,40(sp)
 3d0:	6145                	addi	sp,sp,48
 3d2:	8082                	ret

00000000000003d4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d4:	7139                	addi	sp,sp,-64
 3d6:	fc22                	sd	s0,56(sp)
 3d8:	0080                	addi	s0,sp,64
 3da:	fca43c23          	sd	a0,-40(s0)
 3de:	fcb43823          	sd	a1,-48(s0)
 3e2:	87b2                	mv	a5,a2
 3e4:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3e8:	fd843783          	ld	a5,-40(s0)
 3ec:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3f0:	fd043783          	ld	a5,-48(s0)
 3f4:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3f8:	fe043703          	ld	a4,-32(s0)
 3fc:	fe843783          	ld	a5,-24(s0)
 400:	02e7fc63          	bgeu	a5,a4,438 <memmove+0x64>
    while(n-- > 0)
 404:	a00d                	j	426 <memmove+0x52>
      *dst++ = *src++;
 406:	fe043703          	ld	a4,-32(s0)
 40a:	00170793          	addi	a5,a4,1
 40e:	fef43023          	sd	a5,-32(s0)
 412:	fe843783          	ld	a5,-24(s0)
 416:	00178693          	addi	a3,a5,1
 41a:	fed43423          	sd	a3,-24(s0)
 41e:	00074703          	lbu	a4,0(a4)
 422:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 426:	fcc42783          	lw	a5,-52(s0)
 42a:	fff7871b          	addiw	a4,a5,-1
 42e:	fce42623          	sw	a4,-52(s0)
 432:	fcf04ae3          	bgtz	a5,406 <memmove+0x32>
 436:	a891                	j	48a <memmove+0xb6>
  } else {
    dst += n;
 438:	fcc42783          	lw	a5,-52(s0)
 43c:	fe843703          	ld	a4,-24(s0)
 440:	97ba                	add	a5,a5,a4
 442:	fef43423          	sd	a5,-24(s0)
    src += n;
 446:	fcc42783          	lw	a5,-52(s0)
 44a:	fe043703          	ld	a4,-32(s0)
 44e:	97ba                	add	a5,a5,a4
 450:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 454:	a01d                	j	47a <memmove+0xa6>
      *--dst = *--src;
 456:	fe043783          	ld	a5,-32(s0)
 45a:	17fd                	addi	a5,a5,-1
 45c:	fef43023          	sd	a5,-32(s0)
 460:	fe843783          	ld	a5,-24(s0)
 464:	17fd                	addi	a5,a5,-1
 466:	fef43423          	sd	a5,-24(s0)
 46a:	fe043783          	ld	a5,-32(s0)
 46e:	0007c703          	lbu	a4,0(a5)
 472:	fe843783          	ld	a5,-24(s0)
 476:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 47a:	fcc42783          	lw	a5,-52(s0)
 47e:	fff7871b          	addiw	a4,a5,-1
 482:	fce42623          	sw	a4,-52(s0)
 486:	fcf048e3          	bgtz	a5,456 <memmove+0x82>
  }
  return vdst;
 48a:	fd843783          	ld	a5,-40(s0)
}
 48e:	853e                	mv	a0,a5
 490:	7462                	ld	s0,56(sp)
 492:	6121                	addi	sp,sp,64
 494:	8082                	ret

0000000000000496 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 496:	7139                	addi	sp,sp,-64
 498:	fc22                	sd	s0,56(sp)
 49a:	0080                	addi	s0,sp,64
 49c:	fca43c23          	sd	a0,-40(s0)
 4a0:	fcb43823          	sd	a1,-48(s0)
 4a4:	87b2                	mv	a5,a2
 4a6:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4aa:	fd843783          	ld	a5,-40(s0)
 4ae:	fef43423          	sd	a5,-24(s0)
 4b2:	fd043783          	ld	a5,-48(s0)
 4b6:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4ba:	a0a1                	j	502 <memcmp+0x6c>
    if (*p1 != *p2) {
 4bc:	fe843783          	ld	a5,-24(s0)
 4c0:	0007c703          	lbu	a4,0(a5)
 4c4:	fe043783          	ld	a5,-32(s0)
 4c8:	0007c783          	lbu	a5,0(a5)
 4cc:	02f70163          	beq	a4,a5,4ee <memcmp+0x58>
      return *p1 - *p2;
 4d0:	fe843783          	ld	a5,-24(s0)
 4d4:	0007c783          	lbu	a5,0(a5)
 4d8:	0007871b          	sext.w	a4,a5
 4dc:	fe043783          	ld	a5,-32(s0)
 4e0:	0007c783          	lbu	a5,0(a5)
 4e4:	2781                	sext.w	a5,a5
 4e6:	40f707bb          	subw	a5,a4,a5
 4ea:	2781                	sext.w	a5,a5
 4ec:	a01d                	j	512 <memcmp+0x7c>
    }
    p1++;
 4ee:	fe843783          	ld	a5,-24(s0)
 4f2:	0785                	addi	a5,a5,1
 4f4:	fef43423          	sd	a5,-24(s0)
    p2++;
 4f8:	fe043783          	ld	a5,-32(s0)
 4fc:	0785                	addi	a5,a5,1
 4fe:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 502:	fcc42783          	lw	a5,-52(s0)
 506:	fff7871b          	addiw	a4,a5,-1
 50a:	fce42623          	sw	a4,-52(s0)
 50e:	f7dd                	bnez	a5,4bc <memcmp+0x26>
  }
  return 0;
 510:	4781                	li	a5,0
}
 512:	853e                	mv	a0,a5
 514:	7462                	ld	s0,56(sp)
 516:	6121                	addi	sp,sp,64
 518:	8082                	ret

000000000000051a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 51a:	7179                	addi	sp,sp,-48
 51c:	f406                	sd	ra,40(sp)
 51e:	f022                	sd	s0,32(sp)
 520:	1800                	addi	s0,sp,48
 522:	fea43423          	sd	a0,-24(s0)
 526:	feb43023          	sd	a1,-32(s0)
 52a:	87b2                	mv	a5,a2
 52c:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 530:	fdc42783          	lw	a5,-36(s0)
 534:	863e                	mv	a2,a5
 536:	fe043583          	ld	a1,-32(s0)
 53a:	fe843503          	ld	a0,-24(s0)
 53e:	00000097          	auipc	ra,0x0
 542:	e96080e7          	jalr	-362(ra) # 3d4 <memmove>
 546:	87aa                	mv	a5,a0
}
 548:	853e                	mv	a0,a5
 54a:	70a2                	ld	ra,40(sp)
 54c:	7402                	ld	s0,32(sp)
 54e:	6145                	addi	sp,sp,48
 550:	8082                	ret

0000000000000552 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 552:	4885                	li	a7,1
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <exit>:
.global exit
exit:
 li a7, SYS_exit
 55a:	4889                	li	a7,2
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <wait>:
.global wait
wait:
 li a7, SYS_wait
 562:	488d                	li	a7,3
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 56a:	4891                	li	a7,4
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <read>:
.global read
read:
 li a7, SYS_read
 572:	4895                	li	a7,5
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <write>:
.global write
write:
 li a7, SYS_write
 57a:	48c1                	li	a7,16
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <close>:
.global close
close:
 li a7, SYS_close
 582:	48d5                	li	a7,21
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <kill>:
.global kill
kill:
 li a7, SYS_kill
 58a:	4899                	li	a7,6
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <exec>:
.global exec
exec:
 li a7, SYS_exec
 592:	489d                	li	a7,7
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <open>:
.global open
open:
 li a7, SYS_open
 59a:	48bd                	li	a7,15
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a2:	48c5                	li	a7,17
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5aa:	48c9                	li	a7,18
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b2:	48a1                	li	a7,8
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <link>:
.global link
link:
 li a7, SYS_link
 5ba:	48cd                	li	a7,19
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c2:	48d1                	li	a7,20
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ca:	48a5                	li	a7,9
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d2:	48a9                	li	a7,10
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5da:	48ad                	li	a7,11
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e2:	48b1                	li	a7,12
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ea:	48b5                	li	a7,13
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f2:	48b9                	li	a7,14
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <hello>:
.global hello
hello:
 li a7, SYS_hello
 5fa:	48d9                	li	a7,22
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 602:	48dd                	li	a7,23
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60a:	1101                	addi	sp,sp,-32
 60c:	ec06                	sd	ra,24(sp)
 60e:	e822                	sd	s0,16(sp)
 610:	1000                	addi	s0,sp,32
 612:	87aa                	mv	a5,a0
 614:	872e                	mv	a4,a1
 616:	fef42623          	sw	a5,-20(s0)
 61a:	87ba                	mv	a5,a4
 61c:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 620:	feb40713          	addi	a4,s0,-21
 624:	fec42783          	lw	a5,-20(s0)
 628:	4605                	li	a2,1
 62a:	85ba                	mv	a1,a4
 62c:	853e                	mv	a0,a5
 62e:	00000097          	auipc	ra,0x0
 632:	f4c080e7          	jalr	-180(ra) # 57a <write>
}
 636:	0001                	nop
 638:	60e2                	ld	ra,24(sp)
 63a:	6442                	ld	s0,16(sp)
 63c:	6105                	addi	sp,sp,32
 63e:	8082                	ret

0000000000000640 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 640:	7139                	addi	sp,sp,-64
 642:	fc06                	sd	ra,56(sp)
 644:	f822                	sd	s0,48(sp)
 646:	0080                	addi	s0,sp,64
 648:	87aa                	mv	a5,a0
 64a:	8736                	mv	a4,a3
 64c:	fcf42623          	sw	a5,-52(s0)
 650:	87ae                	mv	a5,a1
 652:	fcf42423          	sw	a5,-56(s0)
 656:	87b2                	mv	a5,a2
 658:	fcf42223          	sw	a5,-60(s0)
 65c:	87ba                	mv	a5,a4
 65e:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 662:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 666:	fc042783          	lw	a5,-64(s0)
 66a:	2781                	sext.w	a5,a5
 66c:	c38d                	beqz	a5,68e <printint+0x4e>
 66e:	fc842783          	lw	a5,-56(s0)
 672:	2781                	sext.w	a5,a5
 674:	0007dd63          	bgez	a5,68e <printint+0x4e>
    neg = 1;
 678:	4785                	li	a5,1
 67a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 67e:	fc842783          	lw	a5,-56(s0)
 682:	40f007bb          	negw	a5,a5
 686:	2781                	sext.w	a5,a5
 688:	fef42223          	sw	a5,-28(s0)
 68c:	a029                	j	696 <printint+0x56>
  } else {
    x = xx;
 68e:	fc842783          	lw	a5,-56(s0)
 692:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 696:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 69a:	fc442783          	lw	a5,-60(s0)
 69e:	fe442703          	lw	a4,-28(s0)
 6a2:	02f777bb          	remuw	a5,a4,a5
 6a6:	0007861b          	sext.w	a2,a5
 6aa:	fec42783          	lw	a5,-20(s0)
 6ae:	0017871b          	addiw	a4,a5,1
 6b2:	fee42623          	sw	a4,-20(s0)
 6b6:	00001697          	auipc	a3,0x1
 6ba:	cba68693          	addi	a3,a3,-838 # 1370 <digits>
 6be:	02061713          	slli	a4,a2,0x20
 6c2:	9301                	srli	a4,a4,0x20
 6c4:	9736                	add	a4,a4,a3
 6c6:	00074703          	lbu	a4,0(a4)
 6ca:	17c1                	addi	a5,a5,-16
 6cc:	97a2                	add	a5,a5,s0
 6ce:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6d2:	fc442783          	lw	a5,-60(s0)
 6d6:	fe442703          	lw	a4,-28(s0)
 6da:	02f757bb          	divuw	a5,a4,a5
 6de:	fef42223          	sw	a5,-28(s0)
 6e2:	fe442783          	lw	a5,-28(s0)
 6e6:	2781                	sext.w	a5,a5
 6e8:	fbcd                	bnez	a5,69a <printint+0x5a>
  if(neg)
 6ea:	fe842783          	lw	a5,-24(s0)
 6ee:	2781                	sext.w	a5,a5
 6f0:	cf85                	beqz	a5,728 <printint+0xe8>
    buf[i++] = '-';
 6f2:	fec42783          	lw	a5,-20(s0)
 6f6:	0017871b          	addiw	a4,a5,1
 6fa:	fee42623          	sw	a4,-20(s0)
 6fe:	17c1                	addi	a5,a5,-16
 700:	97a2                	add	a5,a5,s0
 702:	02d00713          	li	a4,45
 706:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 70a:	a839                	j	728 <printint+0xe8>
    putc(fd, buf[i]);
 70c:	fec42783          	lw	a5,-20(s0)
 710:	17c1                	addi	a5,a5,-16
 712:	97a2                	add	a5,a5,s0
 714:	fe07c703          	lbu	a4,-32(a5)
 718:	fcc42783          	lw	a5,-52(s0)
 71c:	85ba                	mv	a1,a4
 71e:	853e                	mv	a0,a5
 720:	00000097          	auipc	ra,0x0
 724:	eea080e7          	jalr	-278(ra) # 60a <putc>
  while(--i >= 0)
 728:	fec42783          	lw	a5,-20(s0)
 72c:	37fd                	addiw	a5,a5,-1
 72e:	fef42623          	sw	a5,-20(s0)
 732:	fec42783          	lw	a5,-20(s0)
 736:	2781                	sext.w	a5,a5
 738:	fc07dae3          	bgez	a5,70c <printint+0xcc>
}
 73c:	0001                	nop
 73e:	0001                	nop
 740:	70e2                	ld	ra,56(sp)
 742:	7442                	ld	s0,48(sp)
 744:	6121                	addi	sp,sp,64
 746:	8082                	ret

0000000000000748 <printptr>:

static void
printptr(int fd, uint64 x) {
 748:	7179                	addi	sp,sp,-48
 74a:	f406                	sd	ra,40(sp)
 74c:	f022                	sd	s0,32(sp)
 74e:	1800                	addi	s0,sp,48
 750:	87aa                	mv	a5,a0
 752:	fcb43823          	sd	a1,-48(s0)
 756:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 75a:	fdc42783          	lw	a5,-36(s0)
 75e:	03000593          	li	a1,48
 762:	853e                	mv	a0,a5
 764:	00000097          	auipc	ra,0x0
 768:	ea6080e7          	jalr	-346(ra) # 60a <putc>
  putc(fd, 'x');
 76c:	fdc42783          	lw	a5,-36(s0)
 770:	07800593          	li	a1,120
 774:	853e                	mv	a0,a5
 776:	00000097          	auipc	ra,0x0
 77a:	e94080e7          	jalr	-364(ra) # 60a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77e:	fe042623          	sw	zero,-20(s0)
 782:	a82d                	j	7bc <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 784:	fd043783          	ld	a5,-48(s0)
 788:	93f1                	srli	a5,a5,0x3c
 78a:	00001717          	auipc	a4,0x1
 78e:	be670713          	addi	a4,a4,-1050 # 1370 <digits>
 792:	97ba                	add	a5,a5,a4
 794:	0007c703          	lbu	a4,0(a5)
 798:	fdc42783          	lw	a5,-36(s0)
 79c:	85ba                	mv	a1,a4
 79e:	853e                	mv	a0,a5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	e6a080e7          	jalr	-406(ra) # 60a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a8:	fec42783          	lw	a5,-20(s0)
 7ac:	2785                	addiw	a5,a5,1
 7ae:	fef42623          	sw	a5,-20(s0)
 7b2:	fd043783          	ld	a5,-48(s0)
 7b6:	0792                	slli	a5,a5,0x4
 7b8:	fcf43823          	sd	a5,-48(s0)
 7bc:	fec42783          	lw	a5,-20(s0)
 7c0:	873e                	mv	a4,a5
 7c2:	47bd                	li	a5,15
 7c4:	fce7f0e3          	bgeu	a5,a4,784 <printptr+0x3c>
}
 7c8:	0001                	nop
 7ca:	0001                	nop
 7cc:	70a2                	ld	ra,40(sp)
 7ce:	7402                	ld	s0,32(sp)
 7d0:	6145                	addi	sp,sp,48
 7d2:	8082                	ret

00000000000007d4 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7d4:	715d                	addi	sp,sp,-80
 7d6:	e486                	sd	ra,72(sp)
 7d8:	e0a2                	sd	s0,64(sp)
 7da:	0880                	addi	s0,sp,80
 7dc:	87aa                	mv	a5,a0
 7de:	fcb43023          	sd	a1,-64(s0)
 7e2:	fac43c23          	sd	a2,-72(s0)
 7e6:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7ea:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7ee:	fe042223          	sw	zero,-28(s0)
 7f2:	a42d                	j	a1c <vprintf+0x248>
    c = fmt[i] & 0xff;
 7f4:	fe442783          	lw	a5,-28(s0)
 7f8:	fc043703          	ld	a4,-64(s0)
 7fc:	97ba                	add	a5,a5,a4
 7fe:	0007c783          	lbu	a5,0(a5)
 802:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 806:	fe042783          	lw	a5,-32(s0)
 80a:	2781                	sext.w	a5,a5
 80c:	eb9d                	bnez	a5,842 <vprintf+0x6e>
      if(c == '%'){
 80e:	fdc42783          	lw	a5,-36(s0)
 812:	0007871b          	sext.w	a4,a5
 816:	02500793          	li	a5,37
 81a:	00f71763          	bne	a4,a5,828 <vprintf+0x54>
        state = '%';
 81e:	02500793          	li	a5,37
 822:	fef42023          	sw	a5,-32(s0)
 826:	a2f5                	j	a12 <vprintf+0x23e>
      } else {
        putc(fd, c);
 828:	fdc42783          	lw	a5,-36(s0)
 82c:	0ff7f713          	zext.b	a4,a5
 830:	fcc42783          	lw	a5,-52(s0)
 834:	85ba                	mv	a1,a4
 836:	853e                	mv	a0,a5
 838:	00000097          	auipc	ra,0x0
 83c:	dd2080e7          	jalr	-558(ra) # 60a <putc>
 840:	aac9                	j	a12 <vprintf+0x23e>
      }
    } else if(state == '%'){
 842:	fe042783          	lw	a5,-32(s0)
 846:	0007871b          	sext.w	a4,a5
 84a:	02500793          	li	a5,37
 84e:	1cf71263          	bne	a4,a5,a12 <vprintf+0x23e>
      if(c == 'd'){
 852:	fdc42783          	lw	a5,-36(s0)
 856:	0007871b          	sext.w	a4,a5
 85a:	06400793          	li	a5,100
 85e:	02f71463          	bne	a4,a5,886 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 862:	fb843783          	ld	a5,-72(s0)
 866:	00878713          	addi	a4,a5,8
 86a:	fae43c23          	sd	a4,-72(s0)
 86e:	4398                	lw	a4,0(a5)
 870:	fcc42783          	lw	a5,-52(s0)
 874:	4685                	li	a3,1
 876:	4629                	li	a2,10
 878:	85ba                	mv	a1,a4
 87a:	853e                	mv	a0,a5
 87c:	00000097          	auipc	ra,0x0
 880:	dc4080e7          	jalr	-572(ra) # 640 <printint>
 884:	a269                	j	a0e <vprintf+0x23a>
      } else if(c == 'l') {
 886:	fdc42783          	lw	a5,-36(s0)
 88a:	0007871b          	sext.w	a4,a5
 88e:	06c00793          	li	a5,108
 892:	02f71663          	bne	a4,a5,8be <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 896:	fb843783          	ld	a5,-72(s0)
 89a:	00878713          	addi	a4,a5,8
 89e:	fae43c23          	sd	a4,-72(s0)
 8a2:	639c                	ld	a5,0(a5)
 8a4:	0007871b          	sext.w	a4,a5
 8a8:	fcc42783          	lw	a5,-52(s0)
 8ac:	4681                	li	a3,0
 8ae:	4629                	li	a2,10
 8b0:	85ba                	mv	a1,a4
 8b2:	853e                	mv	a0,a5
 8b4:	00000097          	auipc	ra,0x0
 8b8:	d8c080e7          	jalr	-628(ra) # 640 <printint>
 8bc:	aa89                	j	a0e <vprintf+0x23a>
      } else if(c == 'x') {
 8be:	fdc42783          	lw	a5,-36(s0)
 8c2:	0007871b          	sext.w	a4,a5
 8c6:	07800793          	li	a5,120
 8ca:	02f71463          	bne	a4,a5,8f2 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8ce:	fb843783          	ld	a5,-72(s0)
 8d2:	00878713          	addi	a4,a5,8
 8d6:	fae43c23          	sd	a4,-72(s0)
 8da:	4398                	lw	a4,0(a5)
 8dc:	fcc42783          	lw	a5,-52(s0)
 8e0:	4681                	li	a3,0
 8e2:	4641                	li	a2,16
 8e4:	85ba                	mv	a1,a4
 8e6:	853e                	mv	a0,a5
 8e8:	00000097          	auipc	ra,0x0
 8ec:	d58080e7          	jalr	-680(ra) # 640 <printint>
 8f0:	aa39                	j	a0e <vprintf+0x23a>
      } else if(c == 'p') {
 8f2:	fdc42783          	lw	a5,-36(s0)
 8f6:	0007871b          	sext.w	a4,a5
 8fa:	07000793          	li	a5,112
 8fe:	02f71263          	bne	a4,a5,922 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 902:	fb843783          	ld	a5,-72(s0)
 906:	00878713          	addi	a4,a5,8
 90a:	fae43c23          	sd	a4,-72(s0)
 90e:	6398                	ld	a4,0(a5)
 910:	fcc42783          	lw	a5,-52(s0)
 914:	85ba                	mv	a1,a4
 916:	853e                	mv	a0,a5
 918:	00000097          	auipc	ra,0x0
 91c:	e30080e7          	jalr	-464(ra) # 748 <printptr>
 920:	a0fd                	j	a0e <vprintf+0x23a>
      } else if(c == 's'){
 922:	fdc42783          	lw	a5,-36(s0)
 926:	0007871b          	sext.w	a4,a5
 92a:	07300793          	li	a5,115
 92e:	04f71c63          	bne	a4,a5,986 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 932:	fb843783          	ld	a5,-72(s0)
 936:	00878713          	addi	a4,a5,8
 93a:	fae43c23          	sd	a4,-72(s0)
 93e:	639c                	ld	a5,0(a5)
 940:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 944:	fe843783          	ld	a5,-24(s0)
 948:	eb8d                	bnez	a5,97a <vprintf+0x1a6>
          s = "(null)";
 94a:	00000797          	auipc	a5,0x0
 94e:	48678793          	addi	a5,a5,1158 # dd0 <malloc+0x14c>
 952:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 956:	a015                	j	97a <vprintf+0x1a6>
          putc(fd, *s);
 958:	fe843783          	ld	a5,-24(s0)
 95c:	0007c703          	lbu	a4,0(a5)
 960:	fcc42783          	lw	a5,-52(s0)
 964:	85ba                	mv	a1,a4
 966:	853e                	mv	a0,a5
 968:	00000097          	auipc	ra,0x0
 96c:	ca2080e7          	jalr	-862(ra) # 60a <putc>
          s++;
 970:	fe843783          	ld	a5,-24(s0)
 974:	0785                	addi	a5,a5,1
 976:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 97a:	fe843783          	ld	a5,-24(s0)
 97e:	0007c783          	lbu	a5,0(a5)
 982:	fbf9                	bnez	a5,958 <vprintf+0x184>
 984:	a069                	j	a0e <vprintf+0x23a>
        }
      } else if(c == 'c'){
 986:	fdc42783          	lw	a5,-36(s0)
 98a:	0007871b          	sext.w	a4,a5
 98e:	06300793          	li	a5,99
 992:	02f71463          	bne	a4,a5,9ba <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 996:	fb843783          	ld	a5,-72(s0)
 99a:	00878713          	addi	a4,a5,8
 99e:	fae43c23          	sd	a4,-72(s0)
 9a2:	439c                	lw	a5,0(a5)
 9a4:	0ff7f713          	zext.b	a4,a5
 9a8:	fcc42783          	lw	a5,-52(s0)
 9ac:	85ba                	mv	a1,a4
 9ae:	853e                	mv	a0,a5
 9b0:	00000097          	auipc	ra,0x0
 9b4:	c5a080e7          	jalr	-934(ra) # 60a <putc>
 9b8:	a899                	j	a0e <vprintf+0x23a>
      } else if(c == '%'){
 9ba:	fdc42783          	lw	a5,-36(s0)
 9be:	0007871b          	sext.w	a4,a5
 9c2:	02500793          	li	a5,37
 9c6:	00f71f63          	bne	a4,a5,9e4 <vprintf+0x210>
        putc(fd, c);
 9ca:	fdc42783          	lw	a5,-36(s0)
 9ce:	0ff7f713          	zext.b	a4,a5
 9d2:	fcc42783          	lw	a5,-52(s0)
 9d6:	85ba                	mv	a1,a4
 9d8:	853e                	mv	a0,a5
 9da:	00000097          	auipc	ra,0x0
 9de:	c30080e7          	jalr	-976(ra) # 60a <putc>
 9e2:	a035                	j	a0e <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9e4:	fcc42783          	lw	a5,-52(s0)
 9e8:	02500593          	li	a1,37
 9ec:	853e                	mv	a0,a5
 9ee:	00000097          	auipc	ra,0x0
 9f2:	c1c080e7          	jalr	-996(ra) # 60a <putc>
        putc(fd, c);
 9f6:	fdc42783          	lw	a5,-36(s0)
 9fa:	0ff7f713          	zext.b	a4,a5
 9fe:	fcc42783          	lw	a5,-52(s0)
 a02:	85ba                	mv	a1,a4
 a04:	853e                	mv	a0,a5
 a06:	00000097          	auipc	ra,0x0
 a0a:	c04080e7          	jalr	-1020(ra) # 60a <putc>
      }
      state = 0;
 a0e:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a12:	fe442783          	lw	a5,-28(s0)
 a16:	2785                	addiw	a5,a5,1
 a18:	fef42223          	sw	a5,-28(s0)
 a1c:	fe442783          	lw	a5,-28(s0)
 a20:	fc043703          	ld	a4,-64(s0)
 a24:	97ba                	add	a5,a5,a4
 a26:	0007c783          	lbu	a5,0(a5)
 a2a:	dc0795e3          	bnez	a5,7f4 <vprintf+0x20>
    }
  }
}
 a2e:	0001                	nop
 a30:	0001                	nop
 a32:	60a6                	ld	ra,72(sp)
 a34:	6406                	ld	s0,64(sp)
 a36:	6161                	addi	sp,sp,80
 a38:	8082                	ret

0000000000000a3a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a3a:	7159                	addi	sp,sp,-112
 a3c:	fc06                	sd	ra,56(sp)
 a3e:	f822                	sd	s0,48(sp)
 a40:	0080                	addi	s0,sp,64
 a42:	fcb43823          	sd	a1,-48(s0)
 a46:	e010                	sd	a2,0(s0)
 a48:	e414                	sd	a3,8(s0)
 a4a:	e818                	sd	a4,16(s0)
 a4c:	ec1c                	sd	a5,24(s0)
 a4e:	03043023          	sd	a6,32(s0)
 a52:	03143423          	sd	a7,40(s0)
 a56:	87aa                	mv	a5,a0
 a58:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a5c:	03040793          	addi	a5,s0,48
 a60:	fcf43423          	sd	a5,-56(s0)
 a64:	fc843783          	ld	a5,-56(s0)
 a68:	fd078793          	addi	a5,a5,-48
 a6c:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a70:	fe843703          	ld	a4,-24(s0)
 a74:	fdc42783          	lw	a5,-36(s0)
 a78:	863a                	mv	a2,a4
 a7a:	fd043583          	ld	a1,-48(s0)
 a7e:	853e                	mv	a0,a5
 a80:	00000097          	auipc	ra,0x0
 a84:	d54080e7          	jalr	-684(ra) # 7d4 <vprintf>
}
 a88:	0001                	nop
 a8a:	70e2                	ld	ra,56(sp)
 a8c:	7442                	ld	s0,48(sp)
 a8e:	6165                	addi	sp,sp,112
 a90:	8082                	ret

0000000000000a92 <printf>:

void
printf(const char *fmt, ...)
{
 a92:	7159                	addi	sp,sp,-112
 a94:	f406                	sd	ra,40(sp)
 a96:	f022                	sd	s0,32(sp)
 a98:	1800                	addi	s0,sp,48
 a9a:	fca43c23          	sd	a0,-40(s0)
 a9e:	e40c                	sd	a1,8(s0)
 aa0:	e810                	sd	a2,16(s0)
 aa2:	ec14                	sd	a3,24(s0)
 aa4:	f018                	sd	a4,32(s0)
 aa6:	f41c                	sd	a5,40(s0)
 aa8:	03043823          	sd	a6,48(s0)
 aac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ab0:	04040793          	addi	a5,s0,64
 ab4:	fcf43823          	sd	a5,-48(s0)
 ab8:	fd043783          	ld	a5,-48(s0)
 abc:	fc878793          	addi	a5,a5,-56
 ac0:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ac4:	fe843783          	ld	a5,-24(s0)
 ac8:	863e                	mv	a2,a5
 aca:	fd843583          	ld	a1,-40(s0)
 ace:	4505                	li	a0,1
 ad0:	00000097          	auipc	ra,0x0
 ad4:	d04080e7          	jalr	-764(ra) # 7d4 <vprintf>
}
 ad8:	0001                	nop
 ada:	70a2                	ld	ra,40(sp)
 adc:	7402                	ld	s0,32(sp)
 ade:	6165                	addi	sp,sp,112
 ae0:	8082                	ret

0000000000000ae2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae2:	7179                	addi	sp,sp,-48
 ae4:	f422                	sd	s0,40(sp)
 ae6:	1800                	addi	s0,sp,48
 ae8:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aec:	fd843783          	ld	a5,-40(s0)
 af0:	17c1                	addi	a5,a5,-16
 af2:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af6:	00001797          	auipc	a5,0x1
 afa:	8aa78793          	addi	a5,a5,-1878 # 13a0 <freep>
 afe:	639c                	ld	a5,0(a5)
 b00:	fef43423          	sd	a5,-24(s0)
 b04:	a815                	j	b38 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b06:	fe843783          	ld	a5,-24(s0)
 b0a:	639c                	ld	a5,0(a5)
 b0c:	fe843703          	ld	a4,-24(s0)
 b10:	00f76f63          	bltu	a4,a5,b2e <free+0x4c>
 b14:	fe043703          	ld	a4,-32(s0)
 b18:	fe843783          	ld	a5,-24(s0)
 b1c:	02e7eb63          	bltu	a5,a4,b52 <free+0x70>
 b20:	fe843783          	ld	a5,-24(s0)
 b24:	639c                	ld	a5,0(a5)
 b26:	fe043703          	ld	a4,-32(s0)
 b2a:	02f76463          	bltu	a4,a5,b52 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b2e:	fe843783          	ld	a5,-24(s0)
 b32:	639c                	ld	a5,0(a5)
 b34:	fef43423          	sd	a5,-24(s0)
 b38:	fe043703          	ld	a4,-32(s0)
 b3c:	fe843783          	ld	a5,-24(s0)
 b40:	fce7f3e3          	bgeu	a5,a4,b06 <free+0x24>
 b44:	fe843783          	ld	a5,-24(s0)
 b48:	639c                	ld	a5,0(a5)
 b4a:	fe043703          	ld	a4,-32(s0)
 b4e:	faf77ce3          	bgeu	a4,a5,b06 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b52:	fe043783          	ld	a5,-32(s0)
 b56:	479c                	lw	a5,8(a5)
 b58:	1782                	slli	a5,a5,0x20
 b5a:	9381                	srli	a5,a5,0x20
 b5c:	0792                	slli	a5,a5,0x4
 b5e:	fe043703          	ld	a4,-32(s0)
 b62:	973e                	add	a4,a4,a5
 b64:	fe843783          	ld	a5,-24(s0)
 b68:	639c                	ld	a5,0(a5)
 b6a:	02f71763          	bne	a4,a5,b98 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b6e:	fe043783          	ld	a5,-32(s0)
 b72:	4798                	lw	a4,8(a5)
 b74:	fe843783          	ld	a5,-24(s0)
 b78:	639c                	ld	a5,0(a5)
 b7a:	479c                	lw	a5,8(a5)
 b7c:	9fb9                	addw	a5,a5,a4
 b7e:	0007871b          	sext.w	a4,a5
 b82:	fe043783          	ld	a5,-32(s0)
 b86:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b88:	fe843783          	ld	a5,-24(s0)
 b8c:	639c                	ld	a5,0(a5)
 b8e:	6398                	ld	a4,0(a5)
 b90:	fe043783          	ld	a5,-32(s0)
 b94:	e398                	sd	a4,0(a5)
 b96:	a039                	j	ba4 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b98:	fe843783          	ld	a5,-24(s0)
 b9c:	6398                	ld	a4,0(a5)
 b9e:	fe043783          	ld	a5,-32(s0)
 ba2:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 ba4:	fe843783          	ld	a5,-24(s0)
 ba8:	479c                	lw	a5,8(a5)
 baa:	1782                	slli	a5,a5,0x20
 bac:	9381                	srli	a5,a5,0x20
 bae:	0792                	slli	a5,a5,0x4
 bb0:	fe843703          	ld	a4,-24(s0)
 bb4:	97ba                	add	a5,a5,a4
 bb6:	fe043703          	ld	a4,-32(s0)
 bba:	02f71563          	bne	a4,a5,be4 <free+0x102>
    p->s.size += bp->s.size;
 bbe:	fe843783          	ld	a5,-24(s0)
 bc2:	4798                	lw	a4,8(a5)
 bc4:	fe043783          	ld	a5,-32(s0)
 bc8:	479c                	lw	a5,8(a5)
 bca:	9fb9                	addw	a5,a5,a4
 bcc:	0007871b          	sext.w	a4,a5
 bd0:	fe843783          	ld	a5,-24(s0)
 bd4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bd6:	fe043783          	ld	a5,-32(s0)
 bda:	6398                	ld	a4,0(a5)
 bdc:	fe843783          	ld	a5,-24(s0)
 be0:	e398                	sd	a4,0(a5)
 be2:	a031                	j	bee <free+0x10c>
  } else
    p->s.ptr = bp;
 be4:	fe843783          	ld	a5,-24(s0)
 be8:	fe043703          	ld	a4,-32(s0)
 bec:	e398                	sd	a4,0(a5)
  freep = p;
 bee:	00000797          	auipc	a5,0x0
 bf2:	7b278793          	addi	a5,a5,1970 # 13a0 <freep>
 bf6:	fe843703          	ld	a4,-24(s0)
 bfa:	e398                	sd	a4,0(a5)
}
 bfc:	0001                	nop
 bfe:	7422                	ld	s0,40(sp)
 c00:	6145                	addi	sp,sp,48
 c02:	8082                	ret

0000000000000c04 <morecore>:

static Header*
morecore(uint nu)
{
 c04:	7179                	addi	sp,sp,-48
 c06:	f406                	sd	ra,40(sp)
 c08:	f022                	sd	s0,32(sp)
 c0a:	1800                	addi	s0,sp,48
 c0c:	87aa                	mv	a5,a0
 c0e:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c12:	fdc42783          	lw	a5,-36(s0)
 c16:	0007871b          	sext.w	a4,a5
 c1a:	6785                	lui	a5,0x1
 c1c:	00f77563          	bgeu	a4,a5,c26 <morecore+0x22>
    nu = 4096;
 c20:	6785                	lui	a5,0x1
 c22:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c26:	fdc42783          	lw	a5,-36(s0)
 c2a:	0047979b          	slliw	a5,a5,0x4
 c2e:	2781                	sext.w	a5,a5
 c30:	2781                	sext.w	a5,a5
 c32:	853e                	mv	a0,a5
 c34:	00000097          	auipc	ra,0x0
 c38:	9ae080e7          	jalr	-1618(ra) # 5e2 <sbrk>
 c3c:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c40:	fe843703          	ld	a4,-24(s0)
 c44:	57fd                	li	a5,-1
 c46:	00f71463          	bne	a4,a5,c4e <morecore+0x4a>
    return 0;
 c4a:	4781                	li	a5,0
 c4c:	a03d                	j	c7a <morecore+0x76>
  hp = (Header*)p;
 c4e:	fe843783          	ld	a5,-24(s0)
 c52:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c56:	fe043783          	ld	a5,-32(s0)
 c5a:	fdc42703          	lw	a4,-36(s0)
 c5e:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c60:	fe043783          	ld	a5,-32(s0)
 c64:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x38c>
 c66:	853e                	mv	a0,a5
 c68:	00000097          	auipc	ra,0x0
 c6c:	e7a080e7          	jalr	-390(ra) # ae2 <free>
  return freep;
 c70:	00000797          	auipc	a5,0x0
 c74:	73078793          	addi	a5,a5,1840 # 13a0 <freep>
 c78:	639c                	ld	a5,0(a5)
}
 c7a:	853e                	mv	a0,a5
 c7c:	70a2                	ld	ra,40(sp)
 c7e:	7402                	ld	s0,32(sp)
 c80:	6145                	addi	sp,sp,48
 c82:	8082                	ret

0000000000000c84 <malloc>:

void*
malloc(uint nbytes)
{
 c84:	7139                	addi	sp,sp,-64
 c86:	fc06                	sd	ra,56(sp)
 c88:	f822                	sd	s0,48(sp)
 c8a:	0080                	addi	s0,sp,64
 c8c:	87aa                	mv	a5,a0
 c8e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c92:	fcc46783          	lwu	a5,-52(s0)
 c96:	07bd                	addi	a5,a5,15
 c98:	8391                	srli	a5,a5,0x4
 c9a:	2781                	sext.w	a5,a5
 c9c:	2785                	addiw	a5,a5,1
 c9e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 ca2:	00000797          	auipc	a5,0x0
 ca6:	6fe78793          	addi	a5,a5,1790 # 13a0 <freep>
 caa:	639c                	ld	a5,0(a5)
 cac:	fef43023          	sd	a5,-32(s0)
 cb0:	fe043783          	ld	a5,-32(s0)
 cb4:	ef95                	bnez	a5,cf0 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cb6:	00000797          	auipc	a5,0x0
 cba:	6da78793          	addi	a5,a5,1754 # 1390 <base>
 cbe:	fef43023          	sd	a5,-32(s0)
 cc2:	00000797          	auipc	a5,0x0
 cc6:	6de78793          	addi	a5,a5,1758 # 13a0 <freep>
 cca:	fe043703          	ld	a4,-32(s0)
 cce:	e398                	sd	a4,0(a5)
 cd0:	00000797          	auipc	a5,0x0
 cd4:	6d078793          	addi	a5,a5,1744 # 13a0 <freep>
 cd8:	6398                	ld	a4,0(a5)
 cda:	00000797          	auipc	a5,0x0
 cde:	6b678793          	addi	a5,a5,1718 # 1390 <base>
 ce2:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 ce4:	00000797          	auipc	a5,0x0
 ce8:	6ac78793          	addi	a5,a5,1708 # 1390 <base>
 cec:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cf0:	fe043783          	ld	a5,-32(s0)
 cf4:	639c                	ld	a5,0(a5)
 cf6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cfa:	fe843783          	ld	a5,-24(s0)
 cfe:	4798                	lw	a4,8(a5)
 d00:	fdc42783          	lw	a5,-36(s0)
 d04:	2781                	sext.w	a5,a5
 d06:	06f76763          	bltu	a4,a5,d74 <malloc+0xf0>
      if(p->s.size == nunits)
 d0a:	fe843783          	ld	a5,-24(s0)
 d0e:	4798                	lw	a4,8(a5)
 d10:	fdc42783          	lw	a5,-36(s0)
 d14:	2781                	sext.w	a5,a5
 d16:	00e79963          	bne	a5,a4,d28 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d1a:	fe843783          	ld	a5,-24(s0)
 d1e:	6398                	ld	a4,0(a5)
 d20:	fe043783          	ld	a5,-32(s0)
 d24:	e398                	sd	a4,0(a5)
 d26:	a825                	j	d5e <malloc+0xda>
      else {
        p->s.size -= nunits;
 d28:	fe843783          	ld	a5,-24(s0)
 d2c:	479c                	lw	a5,8(a5)
 d2e:	fdc42703          	lw	a4,-36(s0)
 d32:	9f99                	subw	a5,a5,a4
 d34:	0007871b          	sext.w	a4,a5
 d38:	fe843783          	ld	a5,-24(s0)
 d3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d3e:	fe843783          	ld	a5,-24(s0)
 d42:	479c                	lw	a5,8(a5)
 d44:	1782                	slli	a5,a5,0x20
 d46:	9381                	srli	a5,a5,0x20
 d48:	0792                	slli	a5,a5,0x4
 d4a:	fe843703          	ld	a4,-24(s0)
 d4e:	97ba                	add	a5,a5,a4
 d50:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d54:	fe843783          	ld	a5,-24(s0)
 d58:	fdc42703          	lw	a4,-36(s0)
 d5c:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d5e:	00000797          	auipc	a5,0x0
 d62:	64278793          	addi	a5,a5,1602 # 13a0 <freep>
 d66:	fe043703          	ld	a4,-32(s0)
 d6a:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d6c:	fe843783          	ld	a5,-24(s0)
 d70:	07c1                	addi	a5,a5,16
 d72:	a091                	j	db6 <malloc+0x132>
    }
    if(p == freep)
 d74:	00000797          	auipc	a5,0x0
 d78:	62c78793          	addi	a5,a5,1580 # 13a0 <freep>
 d7c:	639c                	ld	a5,0(a5)
 d7e:	fe843703          	ld	a4,-24(s0)
 d82:	02f71063          	bne	a4,a5,da2 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d86:	fdc42783          	lw	a5,-36(s0)
 d8a:	853e                	mv	a0,a5
 d8c:	00000097          	auipc	ra,0x0
 d90:	e78080e7          	jalr	-392(ra) # c04 <morecore>
 d94:	fea43423          	sd	a0,-24(s0)
 d98:	fe843783          	ld	a5,-24(s0)
 d9c:	e399                	bnez	a5,da2 <malloc+0x11e>
        return 0;
 d9e:	4781                	li	a5,0
 da0:	a819                	j	db6 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 da2:	fe843783          	ld	a5,-24(s0)
 da6:	fef43023          	sd	a5,-32(s0)
 daa:	fe843783          	ld	a5,-24(s0)
 dae:	639c                	ld	a5,0(a5)
 db0:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 db4:	b799                	j	cfa <malloc+0x76>
  }
}
 db6:	853e                	mv	a0,a5
 db8:	70e2                	ld	ra,56(sp)
 dba:	7442                	ld	s0,48(sp)
 dbc:	6121                	addi	sp,sp,64
 dbe:	8082                	ret
