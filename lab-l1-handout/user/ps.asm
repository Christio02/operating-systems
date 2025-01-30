
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

   struct process_info info[64]; // store up to 64 processes (NPROC)
   int count = get_process(info, 64); // get active processes from syscall and add to info array
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
      printf("%s (%d): %d\n", info[i].name, info[i].pid, info[i].state); // go through process info and print out
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
  7c:	d5850513          	addi	a0,a0,-680 # dd0 <malloc+0x144>
  80:	00001097          	auipc	ra,0x1
  84:	a1a080e7          	jalr	-1510(ra) # a9a <printf>
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

000000000000060a <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 60a:	48e1                	li	a7,24
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 612:	1101                	addi	sp,sp,-32
 614:	ec06                	sd	ra,24(sp)
 616:	e822                	sd	s0,16(sp)
 618:	1000                	addi	s0,sp,32
 61a:	87aa                	mv	a5,a0
 61c:	872e                	mv	a4,a1
 61e:	fef42623          	sw	a5,-20(s0)
 622:	87ba                	mv	a5,a4
 624:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 628:	feb40713          	addi	a4,s0,-21
 62c:	fec42783          	lw	a5,-20(s0)
 630:	4605                	li	a2,1
 632:	85ba                	mv	a1,a4
 634:	853e                	mv	a0,a5
 636:	00000097          	auipc	ra,0x0
 63a:	f44080e7          	jalr	-188(ra) # 57a <write>
}
 63e:	0001                	nop
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6105                	addi	sp,sp,32
 646:	8082                	ret

0000000000000648 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 648:	7139                	addi	sp,sp,-64
 64a:	fc06                	sd	ra,56(sp)
 64c:	f822                	sd	s0,48(sp)
 64e:	0080                	addi	s0,sp,64
 650:	87aa                	mv	a5,a0
 652:	8736                	mv	a4,a3
 654:	fcf42623          	sw	a5,-52(s0)
 658:	87ae                	mv	a5,a1
 65a:	fcf42423          	sw	a5,-56(s0)
 65e:	87b2                	mv	a5,a2
 660:	fcf42223          	sw	a5,-60(s0)
 664:	87ba                	mv	a5,a4
 666:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66a:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 66e:	fc042783          	lw	a5,-64(s0)
 672:	2781                	sext.w	a5,a5
 674:	c38d                	beqz	a5,696 <printint+0x4e>
 676:	fc842783          	lw	a5,-56(s0)
 67a:	2781                	sext.w	a5,a5
 67c:	0007dd63          	bgez	a5,696 <printint+0x4e>
    neg = 1;
 680:	4785                	li	a5,1
 682:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 686:	fc842783          	lw	a5,-56(s0)
 68a:	40f007bb          	negw	a5,a5
 68e:	2781                	sext.w	a5,a5
 690:	fef42223          	sw	a5,-28(s0)
 694:	a029                	j	69e <printint+0x56>
  } else {
    x = xx;
 696:	fc842783          	lw	a5,-56(s0)
 69a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 69e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 6a2:	fc442783          	lw	a5,-60(s0)
 6a6:	fe442703          	lw	a4,-28(s0)
 6aa:	02f777bb          	remuw	a5,a4,a5
 6ae:	0007861b          	sext.w	a2,a5
 6b2:	fec42783          	lw	a5,-20(s0)
 6b6:	0017871b          	addiw	a4,a5,1
 6ba:	fee42623          	sw	a4,-20(s0)
 6be:	00001697          	auipc	a3,0x1
 6c2:	cb268693          	addi	a3,a3,-846 # 1370 <digits>
 6c6:	02061713          	slli	a4,a2,0x20
 6ca:	9301                	srli	a4,a4,0x20
 6cc:	9736                	add	a4,a4,a3
 6ce:	00074703          	lbu	a4,0(a4)
 6d2:	17c1                	addi	a5,a5,-16
 6d4:	97a2                	add	a5,a5,s0
 6d6:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6da:	fc442783          	lw	a5,-60(s0)
 6de:	fe442703          	lw	a4,-28(s0)
 6e2:	02f757bb          	divuw	a5,a4,a5
 6e6:	fef42223          	sw	a5,-28(s0)
 6ea:	fe442783          	lw	a5,-28(s0)
 6ee:	2781                	sext.w	a5,a5
 6f0:	fbcd                	bnez	a5,6a2 <printint+0x5a>
  if(neg)
 6f2:	fe842783          	lw	a5,-24(s0)
 6f6:	2781                	sext.w	a5,a5
 6f8:	cf85                	beqz	a5,730 <printint+0xe8>
    buf[i++] = '-';
 6fa:	fec42783          	lw	a5,-20(s0)
 6fe:	0017871b          	addiw	a4,a5,1
 702:	fee42623          	sw	a4,-20(s0)
 706:	17c1                	addi	a5,a5,-16
 708:	97a2                	add	a5,a5,s0
 70a:	02d00713          	li	a4,45
 70e:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 712:	a839                	j	730 <printint+0xe8>
    putc(fd, buf[i]);
 714:	fec42783          	lw	a5,-20(s0)
 718:	17c1                	addi	a5,a5,-16
 71a:	97a2                	add	a5,a5,s0
 71c:	fe07c703          	lbu	a4,-32(a5)
 720:	fcc42783          	lw	a5,-52(s0)
 724:	85ba                	mv	a1,a4
 726:	853e                	mv	a0,a5
 728:	00000097          	auipc	ra,0x0
 72c:	eea080e7          	jalr	-278(ra) # 612 <putc>
  while(--i >= 0)
 730:	fec42783          	lw	a5,-20(s0)
 734:	37fd                	addiw	a5,a5,-1
 736:	fef42623          	sw	a5,-20(s0)
 73a:	fec42783          	lw	a5,-20(s0)
 73e:	2781                	sext.w	a5,a5
 740:	fc07dae3          	bgez	a5,714 <printint+0xcc>
}
 744:	0001                	nop
 746:	0001                	nop
 748:	70e2                	ld	ra,56(sp)
 74a:	7442                	ld	s0,48(sp)
 74c:	6121                	addi	sp,sp,64
 74e:	8082                	ret

0000000000000750 <printptr>:

static void
printptr(int fd, uint64 x) {
 750:	7179                	addi	sp,sp,-48
 752:	f406                	sd	ra,40(sp)
 754:	f022                	sd	s0,32(sp)
 756:	1800                	addi	s0,sp,48
 758:	87aa                	mv	a5,a0
 75a:	fcb43823          	sd	a1,-48(s0)
 75e:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 762:	fdc42783          	lw	a5,-36(s0)
 766:	03000593          	li	a1,48
 76a:	853e                	mv	a0,a5
 76c:	00000097          	auipc	ra,0x0
 770:	ea6080e7          	jalr	-346(ra) # 612 <putc>
  putc(fd, 'x');
 774:	fdc42783          	lw	a5,-36(s0)
 778:	07800593          	li	a1,120
 77c:	853e                	mv	a0,a5
 77e:	00000097          	auipc	ra,0x0
 782:	e94080e7          	jalr	-364(ra) # 612 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 786:	fe042623          	sw	zero,-20(s0)
 78a:	a82d                	j	7c4 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78c:	fd043783          	ld	a5,-48(s0)
 790:	93f1                	srli	a5,a5,0x3c
 792:	00001717          	auipc	a4,0x1
 796:	bde70713          	addi	a4,a4,-1058 # 1370 <digits>
 79a:	97ba                	add	a5,a5,a4
 79c:	0007c703          	lbu	a4,0(a5)
 7a0:	fdc42783          	lw	a5,-36(s0)
 7a4:	85ba                	mv	a1,a4
 7a6:	853e                	mv	a0,a5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e6a080e7          	jalr	-406(ra) # 612 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b0:	fec42783          	lw	a5,-20(s0)
 7b4:	2785                	addiw	a5,a5,1
 7b6:	fef42623          	sw	a5,-20(s0)
 7ba:	fd043783          	ld	a5,-48(s0)
 7be:	0792                	slli	a5,a5,0x4
 7c0:	fcf43823          	sd	a5,-48(s0)
 7c4:	fec42783          	lw	a5,-20(s0)
 7c8:	873e                	mv	a4,a5
 7ca:	47bd                	li	a5,15
 7cc:	fce7f0e3          	bgeu	a5,a4,78c <printptr+0x3c>
}
 7d0:	0001                	nop
 7d2:	0001                	nop
 7d4:	70a2                	ld	ra,40(sp)
 7d6:	7402                	ld	s0,32(sp)
 7d8:	6145                	addi	sp,sp,48
 7da:	8082                	ret

00000000000007dc <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7dc:	715d                	addi	sp,sp,-80
 7de:	e486                	sd	ra,72(sp)
 7e0:	e0a2                	sd	s0,64(sp)
 7e2:	0880                	addi	s0,sp,80
 7e4:	87aa                	mv	a5,a0
 7e6:	fcb43023          	sd	a1,-64(s0)
 7ea:	fac43c23          	sd	a2,-72(s0)
 7ee:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7f2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7f6:	fe042223          	sw	zero,-28(s0)
 7fa:	a42d                	j	a24 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7fc:	fe442783          	lw	a5,-28(s0)
 800:	fc043703          	ld	a4,-64(s0)
 804:	97ba                	add	a5,a5,a4
 806:	0007c783          	lbu	a5,0(a5)
 80a:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 80e:	fe042783          	lw	a5,-32(s0)
 812:	2781                	sext.w	a5,a5
 814:	eb9d                	bnez	a5,84a <vprintf+0x6e>
      if(c == '%'){
 816:	fdc42783          	lw	a5,-36(s0)
 81a:	0007871b          	sext.w	a4,a5
 81e:	02500793          	li	a5,37
 822:	00f71763          	bne	a4,a5,830 <vprintf+0x54>
        state = '%';
 826:	02500793          	li	a5,37
 82a:	fef42023          	sw	a5,-32(s0)
 82e:	a2f5                	j	a1a <vprintf+0x23e>
      } else {
        putc(fd, c);
 830:	fdc42783          	lw	a5,-36(s0)
 834:	0ff7f713          	zext.b	a4,a5
 838:	fcc42783          	lw	a5,-52(s0)
 83c:	85ba                	mv	a1,a4
 83e:	853e                	mv	a0,a5
 840:	00000097          	auipc	ra,0x0
 844:	dd2080e7          	jalr	-558(ra) # 612 <putc>
 848:	aac9                	j	a1a <vprintf+0x23e>
      }
    } else if(state == '%'){
 84a:	fe042783          	lw	a5,-32(s0)
 84e:	0007871b          	sext.w	a4,a5
 852:	02500793          	li	a5,37
 856:	1cf71263          	bne	a4,a5,a1a <vprintf+0x23e>
      if(c == 'd'){
 85a:	fdc42783          	lw	a5,-36(s0)
 85e:	0007871b          	sext.w	a4,a5
 862:	06400793          	li	a5,100
 866:	02f71463          	bne	a4,a5,88e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 86a:	fb843783          	ld	a5,-72(s0)
 86e:	00878713          	addi	a4,a5,8
 872:	fae43c23          	sd	a4,-72(s0)
 876:	4398                	lw	a4,0(a5)
 878:	fcc42783          	lw	a5,-52(s0)
 87c:	4685                	li	a3,1
 87e:	4629                	li	a2,10
 880:	85ba                	mv	a1,a4
 882:	853e                	mv	a0,a5
 884:	00000097          	auipc	ra,0x0
 888:	dc4080e7          	jalr	-572(ra) # 648 <printint>
 88c:	a269                	j	a16 <vprintf+0x23a>
      } else if(c == 'l') {
 88e:	fdc42783          	lw	a5,-36(s0)
 892:	0007871b          	sext.w	a4,a5
 896:	06c00793          	li	a5,108
 89a:	02f71663          	bne	a4,a5,8c6 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89e:	fb843783          	ld	a5,-72(s0)
 8a2:	00878713          	addi	a4,a5,8
 8a6:	fae43c23          	sd	a4,-72(s0)
 8aa:	639c                	ld	a5,0(a5)
 8ac:	0007871b          	sext.w	a4,a5
 8b0:	fcc42783          	lw	a5,-52(s0)
 8b4:	4681                	li	a3,0
 8b6:	4629                	li	a2,10
 8b8:	85ba                	mv	a1,a4
 8ba:	853e                	mv	a0,a5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	d8c080e7          	jalr	-628(ra) # 648 <printint>
 8c4:	aa89                	j	a16 <vprintf+0x23a>
      } else if(c == 'x') {
 8c6:	fdc42783          	lw	a5,-36(s0)
 8ca:	0007871b          	sext.w	a4,a5
 8ce:	07800793          	li	a5,120
 8d2:	02f71463          	bne	a4,a5,8fa <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8d6:	fb843783          	ld	a5,-72(s0)
 8da:	00878713          	addi	a4,a5,8
 8de:	fae43c23          	sd	a4,-72(s0)
 8e2:	4398                	lw	a4,0(a5)
 8e4:	fcc42783          	lw	a5,-52(s0)
 8e8:	4681                	li	a3,0
 8ea:	4641                	li	a2,16
 8ec:	85ba                	mv	a1,a4
 8ee:	853e                	mv	a0,a5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	d58080e7          	jalr	-680(ra) # 648 <printint>
 8f8:	aa39                	j	a16 <vprintf+0x23a>
      } else if(c == 'p') {
 8fa:	fdc42783          	lw	a5,-36(s0)
 8fe:	0007871b          	sext.w	a4,a5
 902:	07000793          	li	a5,112
 906:	02f71263          	bne	a4,a5,92a <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 90a:	fb843783          	ld	a5,-72(s0)
 90e:	00878713          	addi	a4,a5,8
 912:	fae43c23          	sd	a4,-72(s0)
 916:	6398                	ld	a4,0(a5)
 918:	fcc42783          	lw	a5,-52(s0)
 91c:	85ba                	mv	a1,a4
 91e:	853e                	mv	a0,a5
 920:	00000097          	auipc	ra,0x0
 924:	e30080e7          	jalr	-464(ra) # 750 <printptr>
 928:	a0fd                	j	a16 <vprintf+0x23a>
      } else if(c == 's'){
 92a:	fdc42783          	lw	a5,-36(s0)
 92e:	0007871b          	sext.w	a4,a5
 932:	07300793          	li	a5,115
 936:	04f71c63          	bne	a4,a5,98e <vprintf+0x1b2>
        s = va_arg(ap, char*);
 93a:	fb843783          	ld	a5,-72(s0)
 93e:	00878713          	addi	a4,a5,8
 942:	fae43c23          	sd	a4,-72(s0)
 946:	639c                	ld	a5,0(a5)
 948:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 94c:	fe843783          	ld	a5,-24(s0)
 950:	eb8d                	bnez	a5,982 <vprintf+0x1a6>
          s = "(null)";
 952:	00000797          	auipc	a5,0x0
 956:	48e78793          	addi	a5,a5,1166 # de0 <malloc+0x154>
 95a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 95e:	a015                	j	982 <vprintf+0x1a6>
          putc(fd, *s);
 960:	fe843783          	ld	a5,-24(s0)
 964:	0007c703          	lbu	a4,0(a5)
 968:	fcc42783          	lw	a5,-52(s0)
 96c:	85ba                	mv	a1,a4
 96e:	853e                	mv	a0,a5
 970:	00000097          	auipc	ra,0x0
 974:	ca2080e7          	jalr	-862(ra) # 612 <putc>
          s++;
 978:	fe843783          	ld	a5,-24(s0)
 97c:	0785                	addi	a5,a5,1
 97e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 982:	fe843783          	ld	a5,-24(s0)
 986:	0007c783          	lbu	a5,0(a5)
 98a:	fbf9                	bnez	a5,960 <vprintf+0x184>
 98c:	a069                	j	a16 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 98e:	fdc42783          	lw	a5,-36(s0)
 992:	0007871b          	sext.w	a4,a5
 996:	06300793          	li	a5,99
 99a:	02f71463          	bne	a4,a5,9c2 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 99e:	fb843783          	ld	a5,-72(s0)
 9a2:	00878713          	addi	a4,a5,8
 9a6:	fae43c23          	sd	a4,-72(s0)
 9aa:	439c                	lw	a5,0(a5)
 9ac:	0ff7f713          	zext.b	a4,a5
 9b0:	fcc42783          	lw	a5,-52(s0)
 9b4:	85ba                	mv	a1,a4
 9b6:	853e                	mv	a0,a5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	c5a080e7          	jalr	-934(ra) # 612 <putc>
 9c0:	a899                	j	a16 <vprintf+0x23a>
      } else if(c == '%'){
 9c2:	fdc42783          	lw	a5,-36(s0)
 9c6:	0007871b          	sext.w	a4,a5
 9ca:	02500793          	li	a5,37
 9ce:	00f71f63          	bne	a4,a5,9ec <vprintf+0x210>
        putc(fd, c);
 9d2:	fdc42783          	lw	a5,-36(s0)
 9d6:	0ff7f713          	zext.b	a4,a5
 9da:	fcc42783          	lw	a5,-52(s0)
 9de:	85ba                	mv	a1,a4
 9e0:	853e                	mv	a0,a5
 9e2:	00000097          	auipc	ra,0x0
 9e6:	c30080e7          	jalr	-976(ra) # 612 <putc>
 9ea:	a035                	j	a16 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9ec:	fcc42783          	lw	a5,-52(s0)
 9f0:	02500593          	li	a1,37
 9f4:	853e                	mv	a0,a5
 9f6:	00000097          	auipc	ra,0x0
 9fa:	c1c080e7          	jalr	-996(ra) # 612 <putc>
        putc(fd, c);
 9fe:	fdc42783          	lw	a5,-36(s0)
 a02:	0ff7f713          	zext.b	a4,a5
 a06:	fcc42783          	lw	a5,-52(s0)
 a0a:	85ba                	mv	a1,a4
 a0c:	853e                	mv	a0,a5
 a0e:	00000097          	auipc	ra,0x0
 a12:	c04080e7          	jalr	-1020(ra) # 612 <putc>
      }
      state = 0;
 a16:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a1a:	fe442783          	lw	a5,-28(s0)
 a1e:	2785                	addiw	a5,a5,1
 a20:	fef42223          	sw	a5,-28(s0)
 a24:	fe442783          	lw	a5,-28(s0)
 a28:	fc043703          	ld	a4,-64(s0)
 a2c:	97ba                	add	a5,a5,a4
 a2e:	0007c783          	lbu	a5,0(a5)
 a32:	dc0795e3          	bnez	a5,7fc <vprintf+0x20>
    }
  }
}
 a36:	0001                	nop
 a38:	0001                	nop
 a3a:	60a6                	ld	ra,72(sp)
 a3c:	6406                	ld	s0,64(sp)
 a3e:	6161                	addi	sp,sp,80
 a40:	8082                	ret

0000000000000a42 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a42:	7159                	addi	sp,sp,-112
 a44:	fc06                	sd	ra,56(sp)
 a46:	f822                	sd	s0,48(sp)
 a48:	0080                	addi	s0,sp,64
 a4a:	fcb43823          	sd	a1,-48(s0)
 a4e:	e010                	sd	a2,0(s0)
 a50:	e414                	sd	a3,8(s0)
 a52:	e818                	sd	a4,16(s0)
 a54:	ec1c                	sd	a5,24(s0)
 a56:	03043023          	sd	a6,32(s0)
 a5a:	03143423          	sd	a7,40(s0)
 a5e:	87aa                	mv	a5,a0
 a60:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a64:	03040793          	addi	a5,s0,48
 a68:	fcf43423          	sd	a5,-56(s0)
 a6c:	fc843783          	ld	a5,-56(s0)
 a70:	fd078793          	addi	a5,a5,-48
 a74:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a78:	fe843703          	ld	a4,-24(s0)
 a7c:	fdc42783          	lw	a5,-36(s0)
 a80:	863a                	mv	a2,a4
 a82:	fd043583          	ld	a1,-48(s0)
 a86:	853e                	mv	a0,a5
 a88:	00000097          	auipc	ra,0x0
 a8c:	d54080e7          	jalr	-684(ra) # 7dc <vprintf>
}
 a90:	0001                	nop
 a92:	70e2                	ld	ra,56(sp)
 a94:	7442                	ld	s0,48(sp)
 a96:	6165                	addi	sp,sp,112
 a98:	8082                	ret

0000000000000a9a <printf>:

void
printf(const char *fmt, ...)
{
 a9a:	7159                	addi	sp,sp,-112
 a9c:	f406                	sd	ra,40(sp)
 a9e:	f022                	sd	s0,32(sp)
 aa0:	1800                	addi	s0,sp,48
 aa2:	fca43c23          	sd	a0,-40(s0)
 aa6:	e40c                	sd	a1,8(s0)
 aa8:	e810                	sd	a2,16(s0)
 aaa:	ec14                	sd	a3,24(s0)
 aac:	f018                	sd	a4,32(s0)
 aae:	f41c                	sd	a5,40(s0)
 ab0:	03043823          	sd	a6,48(s0)
 ab4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ab8:	04040793          	addi	a5,s0,64
 abc:	fcf43823          	sd	a5,-48(s0)
 ac0:	fd043783          	ld	a5,-48(s0)
 ac4:	fc878793          	addi	a5,a5,-56
 ac8:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 acc:	fe843783          	ld	a5,-24(s0)
 ad0:	863e                	mv	a2,a5
 ad2:	fd843583          	ld	a1,-40(s0)
 ad6:	4505                	li	a0,1
 ad8:	00000097          	auipc	ra,0x0
 adc:	d04080e7          	jalr	-764(ra) # 7dc <vprintf>
}
 ae0:	0001                	nop
 ae2:	70a2                	ld	ra,40(sp)
 ae4:	7402                	ld	s0,32(sp)
 ae6:	6165                	addi	sp,sp,112
 ae8:	8082                	ret

0000000000000aea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aea:	7179                	addi	sp,sp,-48
 aec:	f422                	sd	s0,40(sp)
 aee:	1800                	addi	s0,sp,48
 af0:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 af4:	fd843783          	ld	a5,-40(s0)
 af8:	17c1                	addi	a5,a5,-16
 afa:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afe:	00001797          	auipc	a5,0x1
 b02:	8a278793          	addi	a5,a5,-1886 # 13a0 <freep>
 b06:	639c                	ld	a5,0(a5)
 b08:	fef43423          	sd	a5,-24(s0)
 b0c:	a815                	j	b40 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b0e:	fe843783          	ld	a5,-24(s0)
 b12:	639c                	ld	a5,0(a5)
 b14:	fe843703          	ld	a4,-24(s0)
 b18:	00f76f63          	bltu	a4,a5,b36 <free+0x4c>
 b1c:	fe043703          	ld	a4,-32(s0)
 b20:	fe843783          	ld	a5,-24(s0)
 b24:	02e7eb63          	bltu	a5,a4,b5a <free+0x70>
 b28:	fe843783          	ld	a5,-24(s0)
 b2c:	639c                	ld	a5,0(a5)
 b2e:	fe043703          	ld	a4,-32(s0)
 b32:	02f76463          	bltu	a4,a5,b5a <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b36:	fe843783          	ld	a5,-24(s0)
 b3a:	639c                	ld	a5,0(a5)
 b3c:	fef43423          	sd	a5,-24(s0)
 b40:	fe043703          	ld	a4,-32(s0)
 b44:	fe843783          	ld	a5,-24(s0)
 b48:	fce7f3e3          	bgeu	a5,a4,b0e <free+0x24>
 b4c:	fe843783          	ld	a5,-24(s0)
 b50:	639c                	ld	a5,0(a5)
 b52:	fe043703          	ld	a4,-32(s0)
 b56:	faf77ce3          	bgeu	a4,a5,b0e <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b5a:	fe043783          	ld	a5,-32(s0)
 b5e:	479c                	lw	a5,8(a5)
 b60:	1782                	slli	a5,a5,0x20
 b62:	9381                	srli	a5,a5,0x20
 b64:	0792                	slli	a5,a5,0x4
 b66:	fe043703          	ld	a4,-32(s0)
 b6a:	973e                	add	a4,a4,a5
 b6c:	fe843783          	ld	a5,-24(s0)
 b70:	639c                	ld	a5,0(a5)
 b72:	02f71763          	bne	a4,a5,ba0 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b76:	fe043783          	ld	a5,-32(s0)
 b7a:	4798                	lw	a4,8(a5)
 b7c:	fe843783          	ld	a5,-24(s0)
 b80:	639c                	ld	a5,0(a5)
 b82:	479c                	lw	a5,8(a5)
 b84:	9fb9                	addw	a5,a5,a4
 b86:	0007871b          	sext.w	a4,a5
 b8a:	fe043783          	ld	a5,-32(s0)
 b8e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b90:	fe843783          	ld	a5,-24(s0)
 b94:	639c                	ld	a5,0(a5)
 b96:	6398                	ld	a4,0(a5)
 b98:	fe043783          	ld	a5,-32(s0)
 b9c:	e398                	sd	a4,0(a5)
 b9e:	a039                	j	bac <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 ba0:	fe843783          	ld	a5,-24(s0)
 ba4:	6398                	ld	a4,0(a5)
 ba6:	fe043783          	ld	a5,-32(s0)
 baa:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 bac:	fe843783          	ld	a5,-24(s0)
 bb0:	479c                	lw	a5,8(a5)
 bb2:	1782                	slli	a5,a5,0x20
 bb4:	9381                	srli	a5,a5,0x20
 bb6:	0792                	slli	a5,a5,0x4
 bb8:	fe843703          	ld	a4,-24(s0)
 bbc:	97ba                	add	a5,a5,a4
 bbe:	fe043703          	ld	a4,-32(s0)
 bc2:	02f71563          	bne	a4,a5,bec <free+0x102>
    p->s.size += bp->s.size;
 bc6:	fe843783          	ld	a5,-24(s0)
 bca:	4798                	lw	a4,8(a5)
 bcc:	fe043783          	ld	a5,-32(s0)
 bd0:	479c                	lw	a5,8(a5)
 bd2:	9fb9                	addw	a5,a5,a4
 bd4:	0007871b          	sext.w	a4,a5
 bd8:	fe843783          	ld	a5,-24(s0)
 bdc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bde:	fe043783          	ld	a5,-32(s0)
 be2:	6398                	ld	a4,0(a5)
 be4:	fe843783          	ld	a5,-24(s0)
 be8:	e398                	sd	a4,0(a5)
 bea:	a031                	j	bf6 <free+0x10c>
  } else
    p->s.ptr = bp;
 bec:	fe843783          	ld	a5,-24(s0)
 bf0:	fe043703          	ld	a4,-32(s0)
 bf4:	e398                	sd	a4,0(a5)
  freep = p;
 bf6:	00000797          	auipc	a5,0x0
 bfa:	7aa78793          	addi	a5,a5,1962 # 13a0 <freep>
 bfe:	fe843703          	ld	a4,-24(s0)
 c02:	e398                	sd	a4,0(a5)
}
 c04:	0001                	nop
 c06:	7422                	ld	s0,40(sp)
 c08:	6145                	addi	sp,sp,48
 c0a:	8082                	ret

0000000000000c0c <morecore>:

static Header*
morecore(uint nu)
{
 c0c:	7179                	addi	sp,sp,-48
 c0e:	f406                	sd	ra,40(sp)
 c10:	f022                	sd	s0,32(sp)
 c12:	1800                	addi	s0,sp,48
 c14:	87aa                	mv	a5,a0
 c16:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c1a:	fdc42783          	lw	a5,-36(s0)
 c1e:	0007871b          	sext.w	a4,a5
 c22:	6785                	lui	a5,0x1
 c24:	00f77563          	bgeu	a4,a5,c2e <morecore+0x22>
    nu = 4096;
 c28:	6785                	lui	a5,0x1
 c2a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c2e:	fdc42783          	lw	a5,-36(s0)
 c32:	0047979b          	slliw	a5,a5,0x4
 c36:	2781                	sext.w	a5,a5
 c38:	2781                	sext.w	a5,a5
 c3a:	853e                	mv	a0,a5
 c3c:	00000097          	auipc	ra,0x0
 c40:	9a6080e7          	jalr	-1626(ra) # 5e2 <sbrk>
 c44:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c48:	fe843703          	ld	a4,-24(s0)
 c4c:	57fd                	li	a5,-1
 c4e:	00f71463          	bne	a4,a5,c56 <morecore+0x4a>
    return 0;
 c52:	4781                	li	a5,0
 c54:	a03d                	j	c82 <morecore+0x76>
  hp = (Header*)p;
 c56:	fe843783          	ld	a5,-24(s0)
 c5a:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c5e:	fe043783          	ld	a5,-32(s0)
 c62:	fdc42703          	lw	a4,-36(s0)
 c66:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c68:	fe043783          	ld	a5,-32(s0)
 c6c:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x384>
 c6e:	853e                	mv	a0,a5
 c70:	00000097          	auipc	ra,0x0
 c74:	e7a080e7          	jalr	-390(ra) # aea <free>
  return freep;
 c78:	00000797          	auipc	a5,0x0
 c7c:	72878793          	addi	a5,a5,1832 # 13a0 <freep>
 c80:	639c                	ld	a5,0(a5)
}
 c82:	853e                	mv	a0,a5
 c84:	70a2                	ld	ra,40(sp)
 c86:	7402                	ld	s0,32(sp)
 c88:	6145                	addi	sp,sp,48
 c8a:	8082                	ret

0000000000000c8c <malloc>:

void*
malloc(uint nbytes)
{
 c8c:	7139                	addi	sp,sp,-64
 c8e:	fc06                	sd	ra,56(sp)
 c90:	f822                	sd	s0,48(sp)
 c92:	0080                	addi	s0,sp,64
 c94:	87aa                	mv	a5,a0
 c96:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c9a:	fcc46783          	lwu	a5,-52(s0)
 c9e:	07bd                	addi	a5,a5,15
 ca0:	8391                	srli	a5,a5,0x4
 ca2:	2781                	sext.w	a5,a5
 ca4:	2785                	addiw	a5,a5,1
 ca6:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 caa:	00000797          	auipc	a5,0x0
 cae:	6f678793          	addi	a5,a5,1782 # 13a0 <freep>
 cb2:	639c                	ld	a5,0(a5)
 cb4:	fef43023          	sd	a5,-32(s0)
 cb8:	fe043783          	ld	a5,-32(s0)
 cbc:	ef95                	bnez	a5,cf8 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cbe:	00000797          	auipc	a5,0x0
 cc2:	6d278793          	addi	a5,a5,1746 # 1390 <base>
 cc6:	fef43023          	sd	a5,-32(s0)
 cca:	00000797          	auipc	a5,0x0
 cce:	6d678793          	addi	a5,a5,1750 # 13a0 <freep>
 cd2:	fe043703          	ld	a4,-32(s0)
 cd6:	e398                	sd	a4,0(a5)
 cd8:	00000797          	auipc	a5,0x0
 cdc:	6c878793          	addi	a5,a5,1736 # 13a0 <freep>
 ce0:	6398                	ld	a4,0(a5)
 ce2:	00000797          	auipc	a5,0x0
 ce6:	6ae78793          	addi	a5,a5,1710 # 1390 <base>
 cea:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cec:	00000797          	auipc	a5,0x0
 cf0:	6a478793          	addi	a5,a5,1700 # 1390 <base>
 cf4:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cf8:	fe043783          	ld	a5,-32(s0)
 cfc:	639c                	ld	a5,0(a5)
 cfe:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d02:	fe843783          	ld	a5,-24(s0)
 d06:	4798                	lw	a4,8(a5)
 d08:	fdc42783          	lw	a5,-36(s0)
 d0c:	2781                	sext.w	a5,a5
 d0e:	06f76763          	bltu	a4,a5,d7c <malloc+0xf0>
      if(p->s.size == nunits)
 d12:	fe843783          	ld	a5,-24(s0)
 d16:	4798                	lw	a4,8(a5)
 d18:	fdc42783          	lw	a5,-36(s0)
 d1c:	2781                	sext.w	a5,a5
 d1e:	00e79963          	bne	a5,a4,d30 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d22:	fe843783          	ld	a5,-24(s0)
 d26:	6398                	ld	a4,0(a5)
 d28:	fe043783          	ld	a5,-32(s0)
 d2c:	e398                	sd	a4,0(a5)
 d2e:	a825                	j	d66 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d30:	fe843783          	ld	a5,-24(s0)
 d34:	479c                	lw	a5,8(a5)
 d36:	fdc42703          	lw	a4,-36(s0)
 d3a:	9f99                	subw	a5,a5,a4
 d3c:	0007871b          	sext.w	a4,a5
 d40:	fe843783          	ld	a5,-24(s0)
 d44:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d46:	fe843783          	ld	a5,-24(s0)
 d4a:	479c                	lw	a5,8(a5)
 d4c:	1782                	slli	a5,a5,0x20
 d4e:	9381                	srli	a5,a5,0x20
 d50:	0792                	slli	a5,a5,0x4
 d52:	fe843703          	ld	a4,-24(s0)
 d56:	97ba                	add	a5,a5,a4
 d58:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d5c:	fe843783          	ld	a5,-24(s0)
 d60:	fdc42703          	lw	a4,-36(s0)
 d64:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d66:	00000797          	auipc	a5,0x0
 d6a:	63a78793          	addi	a5,a5,1594 # 13a0 <freep>
 d6e:	fe043703          	ld	a4,-32(s0)
 d72:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d74:	fe843783          	ld	a5,-24(s0)
 d78:	07c1                	addi	a5,a5,16
 d7a:	a091                	j	dbe <malloc+0x132>
    }
    if(p == freep)
 d7c:	00000797          	auipc	a5,0x0
 d80:	62478793          	addi	a5,a5,1572 # 13a0 <freep>
 d84:	639c                	ld	a5,0(a5)
 d86:	fe843703          	ld	a4,-24(s0)
 d8a:	02f71063          	bne	a4,a5,daa <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d8e:	fdc42783          	lw	a5,-36(s0)
 d92:	853e                	mv	a0,a5
 d94:	00000097          	auipc	ra,0x0
 d98:	e78080e7          	jalr	-392(ra) # c0c <morecore>
 d9c:	fea43423          	sd	a0,-24(s0)
 da0:	fe843783          	ld	a5,-24(s0)
 da4:	e399                	bnez	a5,daa <malloc+0x11e>
        return 0;
 da6:	4781                	li	a5,0
 da8:	a819                	j	dbe <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 daa:	fe843783          	ld	a5,-24(s0)
 dae:	fef43023          	sd	a5,-32(s0)
 db2:	fe843783          	ld	a5,-24(s0)
 db6:	639c                	ld	a5,0(a5)
 db8:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dbc:	b799                	j	d02 <malloc+0x76>
  }
}
 dbe:	853e                	mv	a0,a5
 dc0:	70e2                	ld	ra,56(sp)
 dc2:	7442                	ld	s0,48(sp)
 dc4:	6121                	addi	sp,sp,64
 dc6:	8082                	ret
