
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	87aa                	mv	a5,a0
   c:	fcb43023          	sd	a1,-64(s0)
  10:	fcf42623          	sw	a5,-52(s0)
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	fcf42e23          	sw	a5,-36(s0)
  1a:	a051                	j	9e <main+0x9e>
    write(1, argv[i], strlen(argv[i]));
  1c:	fdc42783          	lw	a5,-36(s0)
  20:	078e                	slli	a5,a5,0x3
  22:	fc043703          	ld	a4,-64(s0)
  26:	97ba                	add	a5,a5,a4
  28:	6384                	ld	s1,0(a5)
  2a:	fdc42783          	lw	a5,-36(s0)
  2e:	078e                	slli	a5,a5,0x3
  30:	fc043703          	ld	a4,-64(s0)
  34:	97ba                	add	a5,a5,a4
  36:	639c                	ld	a5,0(a5)
  38:	853e                	mv	a0,a5
  3a:	00000097          	auipc	ra,0x0
  3e:	14a080e7          	jalr	330(ra) # 184 <strlen>
  42:	87aa                	mv	a5,a0
  44:	2781                	sext.w	a5,a5
  46:	2781                	sext.w	a5,a5
  48:	863e                	mv	a2,a5
  4a:	85a6                	mv	a1,s1
  4c:	4505                	li	a0,1
  4e:	00000097          	auipc	ra,0x0
  52:	538080e7          	jalr	1336(ra) # 586 <write>
    if(i + 1 < argc){
  56:	fdc42783          	lw	a5,-36(s0)
  5a:	2785                	addiw	a5,a5,1
  5c:	0007871b          	sext.w	a4,a5
  60:	fcc42783          	lw	a5,-52(s0)
  64:	2781                	sext.w	a5,a5
  66:	00f75d63          	bge	a4,a5,80 <main+0x80>
      write(1, " ", 1);
  6a:	4605                	li	a2,1
  6c:	00001597          	auipc	a1,0x1
  70:	d7458593          	addi	a1,a1,-652 # de0 <malloc+0x148>
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	510080e7          	jalr	1296(ra) # 586 <write>
  7e:	a819                	j	94 <main+0x94>
    } else {
      write(1, "\n", 1);
  80:	4605                	li	a2,1
  82:	00001597          	auipc	a1,0x1
  86:	d6658593          	addi	a1,a1,-666 # de8 <malloc+0x150>
  8a:	4505                	li	a0,1
  8c:	00000097          	auipc	ra,0x0
  90:	4fa080e7          	jalr	1274(ra) # 586 <write>
  for(i = 1; i < argc; i++){
  94:	fdc42783          	lw	a5,-36(s0)
  98:	2785                	addiw	a5,a5,1
  9a:	fcf42e23          	sw	a5,-36(s0)
  9e:	fdc42783          	lw	a5,-36(s0)
  a2:	873e                	mv	a4,a5
  a4:	fcc42783          	lw	a5,-52(s0)
  a8:	2701                	sext.w	a4,a4
  aa:	2781                	sext.w	a5,a5
  ac:	f6f748e3          	blt	a4,a5,1c <main+0x1c>
    }
  }
  exit(0);
  b0:	4501                	li	a0,0
  b2:	00000097          	auipc	ra,0x0
  b6:	4b4080e7          	jalr	1204(ra) # 566 <exit>

00000000000000ba <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e406                	sd	ra,8(sp)
  be:	e022                	sd	s0,0(sp)
  c0:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c2:	00000097          	auipc	ra,0x0
  c6:	f3e080e7          	jalr	-194(ra) # 0 <main>
  exit(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	49a080e7          	jalr	1178(ra) # 566 <exit>

00000000000000d4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d4:	7179                	addi	sp,sp,-48
  d6:	f422                	sd	s0,40(sp)
  d8:	1800                	addi	s0,sp,48
  da:	fca43c23          	sd	a0,-40(s0)
  de:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  e2:	fd843783          	ld	a5,-40(s0)
  e6:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  ea:	0001                	nop
  ec:	fd043703          	ld	a4,-48(s0)
  f0:	00170793          	addi	a5,a4,1
  f4:	fcf43823          	sd	a5,-48(s0)
  f8:	fd843783          	ld	a5,-40(s0)
  fc:	00178693          	addi	a3,a5,1
 100:	fcd43c23          	sd	a3,-40(s0)
 104:	00074703          	lbu	a4,0(a4)
 108:	00e78023          	sb	a4,0(a5)
 10c:	0007c783          	lbu	a5,0(a5)
 110:	fff1                	bnez	a5,ec <strcpy+0x18>
    ;
  return os;
 112:	fe843783          	ld	a5,-24(s0)
}
 116:	853e                	mv	a0,a5
 118:	7422                	ld	s0,40(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret

000000000000011e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11e:	1101                	addi	sp,sp,-32
 120:	ec22                	sd	s0,24(sp)
 122:	1000                	addi	s0,sp,32
 124:	fea43423          	sd	a0,-24(s0)
 128:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 12c:	a819                	j	142 <strcmp+0x24>
    p++, q++;
 12e:	fe843783          	ld	a5,-24(s0)
 132:	0785                	addi	a5,a5,1
 134:	fef43423          	sd	a5,-24(s0)
 138:	fe043783          	ld	a5,-32(s0)
 13c:	0785                	addi	a5,a5,1
 13e:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 142:	fe843783          	ld	a5,-24(s0)
 146:	0007c783          	lbu	a5,0(a5)
 14a:	cb99                	beqz	a5,160 <strcmp+0x42>
 14c:	fe843783          	ld	a5,-24(s0)
 150:	0007c703          	lbu	a4,0(a5)
 154:	fe043783          	ld	a5,-32(s0)
 158:	0007c783          	lbu	a5,0(a5)
 15c:	fcf709e3          	beq	a4,a5,12e <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 160:	fe843783          	ld	a5,-24(s0)
 164:	0007c783          	lbu	a5,0(a5)
 168:	0007871b          	sext.w	a4,a5
 16c:	fe043783          	ld	a5,-32(s0)
 170:	0007c783          	lbu	a5,0(a5)
 174:	2781                	sext.w	a5,a5
 176:	40f707bb          	subw	a5,a4,a5
 17a:	2781                	sext.w	a5,a5
}
 17c:	853e                	mv	a0,a5
 17e:	6462                	ld	s0,24(sp)
 180:	6105                	addi	sp,sp,32
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	7179                	addi	sp,sp,-48
 186:	f422                	sd	s0,40(sp)
 188:	1800                	addi	s0,sp,48
 18a:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 18e:	fe042623          	sw	zero,-20(s0)
 192:	a031                	j	19e <strlen+0x1a>
 194:	fec42783          	lw	a5,-20(s0)
 198:	2785                	addiw	a5,a5,1
 19a:	fef42623          	sw	a5,-20(s0)
 19e:	fec42783          	lw	a5,-20(s0)
 1a2:	fd843703          	ld	a4,-40(s0)
 1a6:	97ba                	add	a5,a5,a4
 1a8:	0007c783          	lbu	a5,0(a5)
 1ac:	f7e5                	bnez	a5,194 <strlen+0x10>
    ;
  return n;
 1ae:	fec42783          	lw	a5,-20(s0)
}
 1b2:	853e                	mv	a0,a5
 1b4:	7422                	ld	s0,40(sp)
 1b6:	6145                	addi	sp,sp,48
 1b8:	8082                	ret

00000000000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ba:	7179                	addi	sp,sp,-48
 1bc:	f422                	sd	s0,40(sp)
 1be:	1800                	addi	s0,sp,48
 1c0:	fca43c23          	sd	a0,-40(s0)
 1c4:	87ae                	mv	a5,a1
 1c6:	8732                	mv	a4,a2
 1c8:	fcf42a23          	sw	a5,-44(s0)
 1cc:	87ba                	mv	a5,a4
 1ce:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1d2:	fd843783          	ld	a5,-40(s0)
 1d6:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1da:	fe042623          	sw	zero,-20(s0)
 1de:	a00d                	j	200 <memset+0x46>
    cdst[i] = c;
 1e0:	fec42783          	lw	a5,-20(s0)
 1e4:	fe043703          	ld	a4,-32(s0)
 1e8:	97ba                	add	a5,a5,a4
 1ea:	fd442703          	lw	a4,-44(s0)
 1ee:	0ff77713          	zext.b	a4,a4
 1f2:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1f6:	fec42783          	lw	a5,-20(s0)
 1fa:	2785                	addiw	a5,a5,1
 1fc:	fef42623          	sw	a5,-20(s0)
 200:	fec42703          	lw	a4,-20(s0)
 204:	fd042783          	lw	a5,-48(s0)
 208:	2781                	sext.w	a5,a5
 20a:	fcf76be3          	bltu	a4,a5,1e0 <memset+0x26>
  }
  return dst;
 20e:	fd843783          	ld	a5,-40(s0)
}
 212:	853e                	mv	a0,a5
 214:	7422                	ld	s0,40(sp)
 216:	6145                	addi	sp,sp,48
 218:	8082                	ret

000000000000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec22                	sd	s0,24(sp)
 21e:	1000                	addi	s0,sp,32
 220:	fea43423          	sd	a0,-24(s0)
 224:	87ae                	mv	a5,a1
 226:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 22a:	a01d                	j	250 <strchr+0x36>
    if(*s == c)
 22c:	fe843783          	ld	a5,-24(s0)
 230:	0007c703          	lbu	a4,0(a5)
 234:	fe744783          	lbu	a5,-25(s0)
 238:	0ff7f793          	zext.b	a5,a5
 23c:	00e79563          	bne	a5,a4,246 <strchr+0x2c>
      return (char*)s;
 240:	fe843783          	ld	a5,-24(s0)
 244:	a821                	j	25c <strchr+0x42>
  for(; *s; s++)
 246:	fe843783          	ld	a5,-24(s0)
 24a:	0785                	addi	a5,a5,1
 24c:	fef43423          	sd	a5,-24(s0)
 250:	fe843783          	ld	a5,-24(s0)
 254:	0007c783          	lbu	a5,0(a5)
 258:	fbf1                	bnez	a5,22c <strchr+0x12>
  return 0;
 25a:	4781                	li	a5,0
}
 25c:	853e                	mv	a0,a5
 25e:	6462                	ld	s0,24(sp)
 260:	6105                	addi	sp,sp,32
 262:	8082                	ret

0000000000000264 <gets>:

char*
gets(char *buf, int max)
{
 264:	7179                	addi	sp,sp,-48
 266:	f406                	sd	ra,40(sp)
 268:	f022                	sd	s0,32(sp)
 26a:	1800                	addi	s0,sp,48
 26c:	fca43c23          	sd	a0,-40(s0)
 270:	87ae                	mv	a5,a1
 272:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	fe042623          	sw	zero,-20(s0)
 27a:	a8a1                	j	2d2 <gets+0x6e>
    cc = read(0, &c, 1);
 27c:	fe740793          	addi	a5,s0,-25
 280:	4605                	li	a2,1
 282:	85be                	mv	a1,a5
 284:	4501                	li	a0,0
 286:	00000097          	auipc	ra,0x0
 28a:	2f8080e7          	jalr	760(ra) # 57e <read>
 28e:	87aa                	mv	a5,a0
 290:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 294:	fe842783          	lw	a5,-24(s0)
 298:	2781                	sext.w	a5,a5
 29a:	04f05763          	blez	a5,2e8 <gets+0x84>
      break;
    buf[i++] = c;
 29e:	fec42783          	lw	a5,-20(s0)
 2a2:	0017871b          	addiw	a4,a5,1
 2a6:	fee42623          	sw	a4,-20(s0)
 2aa:	873e                	mv	a4,a5
 2ac:	fd843783          	ld	a5,-40(s0)
 2b0:	97ba                	add	a5,a5,a4
 2b2:	fe744703          	lbu	a4,-25(s0)
 2b6:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2ba:	fe744783          	lbu	a5,-25(s0)
 2be:	873e                	mv	a4,a5
 2c0:	47a9                	li	a5,10
 2c2:	02f70463          	beq	a4,a5,2ea <gets+0x86>
 2c6:	fe744783          	lbu	a5,-25(s0)
 2ca:	873e                	mv	a4,a5
 2cc:	47b5                	li	a5,13
 2ce:	00f70e63          	beq	a4,a5,2ea <gets+0x86>
  for(i=0; i+1 < max; ){
 2d2:	fec42783          	lw	a5,-20(s0)
 2d6:	2785                	addiw	a5,a5,1
 2d8:	0007871b          	sext.w	a4,a5
 2dc:	fd442783          	lw	a5,-44(s0)
 2e0:	2781                	sext.w	a5,a5
 2e2:	f8f74de3          	blt	a4,a5,27c <gets+0x18>
 2e6:	a011                	j	2ea <gets+0x86>
      break;
 2e8:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2ea:	fec42783          	lw	a5,-20(s0)
 2ee:	fd843703          	ld	a4,-40(s0)
 2f2:	97ba                	add	a5,a5,a4
 2f4:	00078023          	sb	zero,0(a5)
  return buf;
 2f8:	fd843783          	ld	a5,-40(s0)
}
 2fc:	853e                	mv	a0,a5
 2fe:	70a2                	ld	ra,40(sp)
 300:	7402                	ld	s0,32(sp)
 302:	6145                	addi	sp,sp,48
 304:	8082                	ret

0000000000000306 <stat>:

int
stat(const char *n, struct stat *st)
{
 306:	7179                	addi	sp,sp,-48
 308:	f406                	sd	ra,40(sp)
 30a:	f022                	sd	s0,32(sp)
 30c:	1800                	addi	s0,sp,48
 30e:	fca43c23          	sd	a0,-40(s0)
 312:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 316:	4581                	li	a1,0
 318:	fd843503          	ld	a0,-40(s0)
 31c:	00000097          	auipc	ra,0x0
 320:	28a080e7          	jalr	650(ra) # 5a6 <open>
 324:	87aa                	mv	a5,a0
 326:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 32a:	fec42783          	lw	a5,-20(s0)
 32e:	2781                	sext.w	a5,a5
 330:	0007d463          	bgez	a5,338 <stat+0x32>
    return -1;
 334:	57fd                	li	a5,-1
 336:	a035                	j	362 <stat+0x5c>
  r = fstat(fd, st);
 338:	fec42783          	lw	a5,-20(s0)
 33c:	fd043583          	ld	a1,-48(s0)
 340:	853e                	mv	a0,a5
 342:	00000097          	auipc	ra,0x0
 346:	27c080e7          	jalr	636(ra) # 5be <fstat>
 34a:	87aa                	mv	a5,a0
 34c:	fef42423          	sw	a5,-24(s0)
  close(fd);
 350:	fec42783          	lw	a5,-20(s0)
 354:	853e                	mv	a0,a5
 356:	00000097          	auipc	ra,0x0
 35a:	238080e7          	jalr	568(ra) # 58e <close>
  return r;
 35e:	fe842783          	lw	a5,-24(s0)
}
 362:	853e                	mv	a0,a5
 364:	70a2                	ld	ra,40(sp)
 366:	7402                	ld	s0,32(sp)
 368:	6145                	addi	sp,sp,48
 36a:	8082                	ret

000000000000036c <atoi>:

int
atoi(const char *s)
{
 36c:	7179                	addi	sp,sp,-48
 36e:	f422                	sd	s0,40(sp)
 370:	1800                	addi	s0,sp,48
 372:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 376:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 37a:	a81d                	j	3b0 <atoi+0x44>
    n = n*10 + *s++ - '0';
 37c:	fec42783          	lw	a5,-20(s0)
 380:	873e                	mv	a4,a5
 382:	87ba                	mv	a5,a4
 384:	0027979b          	slliw	a5,a5,0x2
 388:	9fb9                	addw	a5,a5,a4
 38a:	0017979b          	slliw	a5,a5,0x1
 38e:	0007871b          	sext.w	a4,a5
 392:	fd843783          	ld	a5,-40(s0)
 396:	00178693          	addi	a3,a5,1
 39a:	fcd43c23          	sd	a3,-40(s0)
 39e:	0007c783          	lbu	a5,0(a5)
 3a2:	2781                	sext.w	a5,a5
 3a4:	9fb9                	addw	a5,a5,a4
 3a6:	2781                	sext.w	a5,a5
 3a8:	fd07879b          	addiw	a5,a5,-48
 3ac:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 3b0:	fd843783          	ld	a5,-40(s0)
 3b4:	0007c783          	lbu	a5,0(a5)
 3b8:	873e                	mv	a4,a5
 3ba:	02f00793          	li	a5,47
 3be:	00e7fb63          	bgeu	a5,a4,3d4 <atoi+0x68>
 3c2:	fd843783          	ld	a5,-40(s0)
 3c6:	0007c783          	lbu	a5,0(a5)
 3ca:	873e                	mv	a4,a5
 3cc:	03900793          	li	a5,57
 3d0:	fae7f6e3          	bgeu	a5,a4,37c <atoi+0x10>
  return n;
 3d4:	fec42783          	lw	a5,-20(s0)
}
 3d8:	853e                	mv	a0,a5
 3da:	7422                	ld	s0,40(sp)
 3dc:	6145                	addi	sp,sp,48
 3de:	8082                	ret

00000000000003e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e0:	7139                	addi	sp,sp,-64
 3e2:	fc22                	sd	s0,56(sp)
 3e4:	0080                	addi	s0,sp,64
 3e6:	fca43c23          	sd	a0,-40(s0)
 3ea:	fcb43823          	sd	a1,-48(s0)
 3ee:	87b2                	mv	a5,a2
 3f0:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3f4:	fd843783          	ld	a5,-40(s0)
 3f8:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3fc:	fd043783          	ld	a5,-48(s0)
 400:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 404:	fe043703          	ld	a4,-32(s0)
 408:	fe843783          	ld	a5,-24(s0)
 40c:	02e7fc63          	bgeu	a5,a4,444 <memmove+0x64>
    while(n-- > 0)
 410:	a00d                	j	432 <memmove+0x52>
      *dst++ = *src++;
 412:	fe043703          	ld	a4,-32(s0)
 416:	00170793          	addi	a5,a4,1
 41a:	fef43023          	sd	a5,-32(s0)
 41e:	fe843783          	ld	a5,-24(s0)
 422:	00178693          	addi	a3,a5,1
 426:	fed43423          	sd	a3,-24(s0)
 42a:	00074703          	lbu	a4,0(a4)
 42e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 432:	fcc42783          	lw	a5,-52(s0)
 436:	fff7871b          	addiw	a4,a5,-1
 43a:	fce42623          	sw	a4,-52(s0)
 43e:	fcf04ae3          	bgtz	a5,412 <memmove+0x32>
 442:	a891                	j	496 <memmove+0xb6>
  } else {
    dst += n;
 444:	fcc42783          	lw	a5,-52(s0)
 448:	fe843703          	ld	a4,-24(s0)
 44c:	97ba                	add	a5,a5,a4
 44e:	fef43423          	sd	a5,-24(s0)
    src += n;
 452:	fcc42783          	lw	a5,-52(s0)
 456:	fe043703          	ld	a4,-32(s0)
 45a:	97ba                	add	a5,a5,a4
 45c:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 460:	a01d                	j	486 <memmove+0xa6>
      *--dst = *--src;
 462:	fe043783          	ld	a5,-32(s0)
 466:	17fd                	addi	a5,a5,-1
 468:	fef43023          	sd	a5,-32(s0)
 46c:	fe843783          	ld	a5,-24(s0)
 470:	17fd                	addi	a5,a5,-1
 472:	fef43423          	sd	a5,-24(s0)
 476:	fe043783          	ld	a5,-32(s0)
 47a:	0007c703          	lbu	a4,0(a5)
 47e:	fe843783          	ld	a5,-24(s0)
 482:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 486:	fcc42783          	lw	a5,-52(s0)
 48a:	fff7871b          	addiw	a4,a5,-1
 48e:	fce42623          	sw	a4,-52(s0)
 492:	fcf048e3          	bgtz	a5,462 <memmove+0x82>
  }
  return vdst;
 496:	fd843783          	ld	a5,-40(s0)
}
 49a:	853e                	mv	a0,a5
 49c:	7462                	ld	s0,56(sp)
 49e:	6121                	addi	sp,sp,64
 4a0:	8082                	ret

00000000000004a2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a2:	7139                	addi	sp,sp,-64
 4a4:	fc22                	sd	s0,56(sp)
 4a6:	0080                	addi	s0,sp,64
 4a8:	fca43c23          	sd	a0,-40(s0)
 4ac:	fcb43823          	sd	a1,-48(s0)
 4b0:	87b2                	mv	a5,a2
 4b2:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4b6:	fd843783          	ld	a5,-40(s0)
 4ba:	fef43423          	sd	a5,-24(s0)
 4be:	fd043783          	ld	a5,-48(s0)
 4c2:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4c6:	a0a1                	j	50e <memcmp+0x6c>
    if (*p1 != *p2) {
 4c8:	fe843783          	ld	a5,-24(s0)
 4cc:	0007c703          	lbu	a4,0(a5)
 4d0:	fe043783          	ld	a5,-32(s0)
 4d4:	0007c783          	lbu	a5,0(a5)
 4d8:	02f70163          	beq	a4,a5,4fa <memcmp+0x58>
      return *p1 - *p2;
 4dc:	fe843783          	ld	a5,-24(s0)
 4e0:	0007c783          	lbu	a5,0(a5)
 4e4:	0007871b          	sext.w	a4,a5
 4e8:	fe043783          	ld	a5,-32(s0)
 4ec:	0007c783          	lbu	a5,0(a5)
 4f0:	2781                	sext.w	a5,a5
 4f2:	40f707bb          	subw	a5,a4,a5
 4f6:	2781                	sext.w	a5,a5
 4f8:	a01d                	j	51e <memcmp+0x7c>
    }
    p1++;
 4fa:	fe843783          	ld	a5,-24(s0)
 4fe:	0785                	addi	a5,a5,1
 500:	fef43423          	sd	a5,-24(s0)
    p2++;
 504:	fe043783          	ld	a5,-32(s0)
 508:	0785                	addi	a5,a5,1
 50a:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 50e:	fcc42783          	lw	a5,-52(s0)
 512:	fff7871b          	addiw	a4,a5,-1
 516:	fce42623          	sw	a4,-52(s0)
 51a:	f7dd                	bnez	a5,4c8 <memcmp+0x26>
  }
  return 0;
 51c:	4781                	li	a5,0
}
 51e:	853e                	mv	a0,a5
 520:	7462                	ld	s0,56(sp)
 522:	6121                	addi	sp,sp,64
 524:	8082                	ret

0000000000000526 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 526:	7179                	addi	sp,sp,-48
 528:	f406                	sd	ra,40(sp)
 52a:	f022                	sd	s0,32(sp)
 52c:	1800                	addi	s0,sp,48
 52e:	fea43423          	sd	a0,-24(s0)
 532:	feb43023          	sd	a1,-32(s0)
 536:	87b2                	mv	a5,a2
 538:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 53c:	fdc42783          	lw	a5,-36(s0)
 540:	863e                	mv	a2,a5
 542:	fe043583          	ld	a1,-32(s0)
 546:	fe843503          	ld	a0,-24(s0)
 54a:	00000097          	auipc	ra,0x0
 54e:	e96080e7          	jalr	-362(ra) # 3e0 <memmove>
 552:	87aa                	mv	a5,a0
}
 554:	853e                	mv	a0,a5
 556:	70a2                	ld	ra,40(sp)
 558:	7402                	ld	s0,32(sp)
 55a:	6145                	addi	sp,sp,48
 55c:	8082                	ret

000000000000055e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 55e:	4885                	li	a7,1
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <exit>:
.global exit
exit:
 li a7, SYS_exit
 566:	4889                	li	a7,2
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <wait>:
.global wait
wait:
 li a7, SYS_wait
 56e:	488d                	li	a7,3
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 576:	4891                	li	a7,4
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <read>:
.global read
read:
 li a7, SYS_read
 57e:	4895                	li	a7,5
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <write>:
.global write
write:
 li a7, SYS_write
 586:	48c1                	li	a7,16
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <close>:
.global close
close:
 li a7, SYS_close
 58e:	48d5                	li	a7,21
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <kill>:
.global kill
kill:
 li a7, SYS_kill
 596:	4899                	li	a7,6
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <exec>:
.global exec
exec:
 li a7, SYS_exec
 59e:	489d                	li	a7,7
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <open>:
.global open
open:
 li a7, SYS_open
 5a6:	48bd                	li	a7,15
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ae:	48c5                	li	a7,17
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5b6:	48c9                	li	a7,18
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5be:	48a1                	li	a7,8
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <link>:
.global link
link:
 li a7, SYS_link
 5c6:	48cd                	li	a7,19
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ce:	48d1                	li	a7,20
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d6:	48a5                	li	a7,9
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <dup>:
.global dup
dup:
 li a7, SYS_dup
 5de:	48a9                	li	a7,10
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e6:	48ad                	li	a7,11
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ee:	48b1                	li	a7,12
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f6:	48b5                	li	a7,13
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5fe:	48b9                	li	a7,14
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <hello>:
.global hello
hello:
 li a7, SYS_hello
 606:	48d9                	li	a7,22
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 60e:	48dd                	li	a7,23
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 616:	48e1                	li	a7,24
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 61e:	1101                	addi	sp,sp,-32
 620:	ec06                	sd	ra,24(sp)
 622:	e822                	sd	s0,16(sp)
 624:	1000                	addi	s0,sp,32
 626:	87aa                	mv	a5,a0
 628:	872e                	mv	a4,a1
 62a:	fef42623          	sw	a5,-20(s0)
 62e:	87ba                	mv	a5,a4
 630:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 634:	feb40713          	addi	a4,s0,-21
 638:	fec42783          	lw	a5,-20(s0)
 63c:	4605                	li	a2,1
 63e:	85ba                	mv	a1,a4
 640:	853e                	mv	a0,a5
 642:	00000097          	auipc	ra,0x0
 646:	f44080e7          	jalr	-188(ra) # 586 <write>
}
 64a:	0001                	nop
 64c:	60e2                	ld	ra,24(sp)
 64e:	6442                	ld	s0,16(sp)
 650:	6105                	addi	sp,sp,32
 652:	8082                	ret

0000000000000654 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 654:	7139                	addi	sp,sp,-64
 656:	fc06                	sd	ra,56(sp)
 658:	f822                	sd	s0,48(sp)
 65a:	0080                	addi	s0,sp,64
 65c:	87aa                	mv	a5,a0
 65e:	8736                	mv	a4,a3
 660:	fcf42623          	sw	a5,-52(s0)
 664:	87ae                	mv	a5,a1
 666:	fcf42423          	sw	a5,-56(s0)
 66a:	87b2                	mv	a5,a2
 66c:	fcf42223          	sw	a5,-60(s0)
 670:	87ba                	mv	a5,a4
 672:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 676:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 67a:	fc042783          	lw	a5,-64(s0)
 67e:	2781                	sext.w	a5,a5
 680:	c38d                	beqz	a5,6a2 <printint+0x4e>
 682:	fc842783          	lw	a5,-56(s0)
 686:	2781                	sext.w	a5,a5
 688:	0007dd63          	bgez	a5,6a2 <printint+0x4e>
    neg = 1;
 68c:	4785                	li	a5,1
 68e:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 692:	fc842783          	lw	a5,-56(s0)
 696:	40f007bb          	negw	a5,a5
 69a:	2781                	sext.w	a5,a5
 69c:	fef42223          	sw	a5,-28(s0)
 6a0:	a029                	j	6aa <printint+0x56>
  } else {
    x = xx;
 6a2:	fc842783          	lw	a5,-56(s0)
 6a6:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 6aa:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 6ae:	fc442783          	lw	a5,-60(s0)
 6b2:	fe442703          	lw	a4,-28(s0)
 6b6:	02f777bb          	remuw	a5,a4,a5
 6ba:	0007861b          	sext.w	a2,a5
 6be:	fec42783          	lw	a5,-20(s0)
 6c2:	0017871b          	addiw	a4,a5,1
 6c6:	fee42623          	sw	a4,-20(s0)
 6ca:	00001697          	auipc	a3,0x1
 6ce:	ca668693          	addi	a3,a3,-858 # 1370 <digits>
 6d2:	02061713          	slli	a4,a2,0x20
 6d6:	9301                	srli	a4,a4,0x20
 6d8:	9736                	add	a4,a4,a3
 6da:	00074703          	lbu	a4,0(a4)
 6de:	17c1                	addi	a5,a5,-16
 6e0:	97a2                	add	a5,a5,s0
 6e2:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6e6:	fc442783          	lw	a5,-60(s0)
 6ea:	fe442703          	lw	a4,-28(s0)
 6ee:	02f757bb          	divuw	a5,a4,a5
 6f2:	fef42223          	sw	a5,-28(s0)
 6f6:	fe442783          	lw	a5,-28(s0)
 6fa:	2781                	sext.w	a5,a5
 6fc:	fbcd                	bnez	a5,6ae <printint+0x5a>
  if(neg)
 6fe:	fe842783          	lw	a5,-24(s0)
 702:	2781                	sext.w	a5,a5
 704:	cf85                	beqz	a5,73c <printint+0xe8>
    buf[i++] = '-';
 706:	fec42783          	lw	a5,-20(s0)
 70a:	0017871b          	addiw	a4,a5,1
 70e:	fee42623          	sw	a4,-20(s0)
 712:	17c1                	addi	a5,a5,-16
 714:	97a2                	add	a5,a5,s0
 716:	02d00713          	li	a4,45
 71a:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 71e:	a839                	j	73c <printint+0xe8>
    putc(fd, buf[i]);
 720:	fec42783          	lw	a5,-20(s0)
 724:	17c1                	addi	a5,a5,-16
 726:	97a2                	add	a5,a5,s0
 728:	fe07c703          	lbu	a4,-32(a5)
 72c:	fcc42783          	lw	a5,-52(s0)
 730:	85ba                	mv	a1,a4
 732:	853e                	mv	a0,a5
 734:	00000097          	auipc	ra,0x0
 738:	eea080e7          	jalr	-278(ra) # 61e <putc>
  while(--i >= 0)
 73c:	fec42783          	lw	a5,-20(s0)
 740:	37fd                	addiw	a5,a5,-1
 742:	fef42623          	sw	a5,-20(s0)
 746:	fec42783          	lw	a5,-20(s0)
 74a:	2781                	sext.w	a5,a5
 74c:	fc07dae3          	bgez	a5,720 <printint+0xcc>
}
 750:	0001                	nop
 752:	0001                	nop
 754:	70e2                	ld	ra,56(sp)
 756:	7442                	ld	s0,48(sp)
 758:	6121                	addi	sp,sp,64
 75a:	8082                	ret

000000000000075c <printptr>:

static void
printptr(int fd, uint64 x) {
 75c:	7179                	addi	sp,sp,-48
 75e:	f406                	sd	ra,40(sp)
 760:	f022                	sd	s0,32(sp)
 762:	1800                	addi	s0,sp,48
 764:	87aa                	mv	a5,a0
 766:	fcb43823          	sd	a1,-48(s0)
 76a:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 76e:	fdc42783          	lw	a5,-36(s0)
 772:	03000593          	li	a1,48
 776:	853e                	mv	a0,a5
 778:	00000097          	auipc	ra,0x0
 77c:	ea6080e7          	jalr	-346(ra) # 61e <putc>
  putc(fd, 'x');
 780:	fdc42783          	lw	a5,-36(s0)
 784:	07800593          	li	a1,120
 788:	853e                	mv	a0,a5
 78a:	00000097          	auipc	ra,0x0
 78e:	e94080e7          	jalr	-364(ra) # 61e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 792:	fe042623          	sw	zero,-20(s0)
 796:	a82d                	j	7d0 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 798:	fd043783          	ld	a5,-48(s0)
 79c:	93f1                	srli	a5,a5,0x3c
 79e:	00001717          	auipc	a4,0x1
 7a2:	bd270713          	addi	a4,a4,-1070 # 1370 <digits>
 7a6:	97ba                	add	a5,a5,a4
 7a8:	0007c703          	lbu	a4,0(a5)
 7ac:	fdc42783          	lw	a5,-36(s0)
 7b0:	85ba                	mv	a1,a4
 7b2:	853e                	mv	a0,a5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e6a080e7          	jalr	-406(ra) # 61e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7bc:	fec42783          	lw	a5,-20(s0)
 7c0:	2785                	addiw	a5,a5,1
 7c2:	fef42623          	sw	a5,-20(s0)
 7c6:	fd043783          	ld	a5,-48(s0)
 7ca:	0792                	slli	a5,a5,0x4
 7cc:	fcf43823          	sd	a5,-48(s0)
 7d0:	fec42783          	lw	a5,-20(s0)
 7d4:	873e                	mv	a4,a5
 7d6:	47bd                	li	a5,15
 7d8:	fce7f0e3          	bgeu	a5,a4,798 <printptr+0x3c>
}
 7dc:	0001                	nop
 7de:	0001                	nop
 7e0:	70a2                	ld	ra,40(sp)
 7e2:	7402                	ld	s0,32(sp)
 7e4:	6145                	addi	sp,sp,48
 7e6:	8082                	ret

00000000000007e8 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7e8:	715d                	addi	sp,sp,-80
 7ea:	e486                	sd	ra,72(sp)
 7ec:	e0a2                	sd	s0,64(sp)
 7ee:	0880                	addi	s0,sp,80
 7f0:	87aa                	mv	a5,a0
 7f2:	fcb43023          	sd	a1,-64(s0)
 7f6:	fac43c23          	sd	a2,-72(s0)
 7fa:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7fe:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 802:	fe042223          	sw	zero,-28(s0)
 806:	a42d                	j	a30 <vprintf+0x248>
    c = fmt[i] & 0xff;
 808:	fe442783          	lw	a5,-28(s0)
 80c:	fc043703          	ld	a4,-64(s0)
 810:	97ba                	add	a5,a5,a4
 812:	0007c783          	lbu	a5,0(a5)
 816:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 81a:	fe042783          	lw	a5,-32(s0)
 81e:	2781                	sext.w	a5,a5
 820:	eb9d                	bnez	a5,856 <vprintf+0x6e>
      if(c == '%'){
 822:	fdc42783          	lw	a5,-36(s0)
 826:	0007871b          	sext.w	a4,a5
 82a:	02500793          	li	a5,37
 82e:	00f71763          	bne	a4,a5,83c <vprintf+0x54>
        state = '%';
 832:	02500793          	li	a5,37
 836:	fef42023          	sw	a5,-32(s0)
 83a:	a2f5                	j	a26 <vprintf+0x23e>
      } else {
        putc(fd, c);
 83c:	fdc42783          	lw	a5,-36(s0)
 840:	0ff7f713          	zext.b	a4,a5
 844:	fcc42783          	lw	a5,-52(s0)
 848:	85ba                	mv	a1,a4
 84a:	853e                	mv	a0,a5
 84c:	00000097          	auipc	ra,0x0
 850:	dd2080e7          	jalr	-558(ra) # 61e <putc>
 854:	aac9                	j	a26 <vprintf+0x23e>
      }
    } else if(state == '%'){
 856:	fe042783          	lw	a5,-32(s0)
 85a:	0007871b          	sext.w	a4,a5
 85e:	02500793          	li	a5,37
 862:	1cf71263          	bne	a4,a5,a26 <vprintf+0x23e>
      if(c == 'd'){
 866:	fdc42783          	lw	a5,-36(s0)
 86a:	0007871b          	sext.w	a4,a5
 86e:	06400793          	li	a5,100
 872:	02f71463          	bne	a4,a5,89a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 876:	fb843783          	ld	a5,-72(s0)
 87a:	00878713          	addi	a4,a5,8
 87e:	fae43c23          	sd	a4,-72(s0)
 882:	4398                	lw	a4,0(a5)
 884:	fcc42783          	lw	a5,-52(s0)
 888:	4685                	li	a3,1
 88a:	4629                	li	a2,10
 88c:	85ba                	mv	a1,a4
 88e:	853e                	mv	a0,a5
 890:	00000097          	auipc	ra,0x0
 894:	dc4080e7          	jalr	-572(ra) # 654 <printint>
 898:	a269                	j	a22 <vprintf+0x23a>
      } else if(c == 'l') {
 89a:	fdc42783          	lw	a5,-36(s0)
 89e:	0007871b          	sext.w	a4,a5
 8a2:	06c00793          	li	a5,108
 8a6:	02f71663          	bne	a4,a5,8d2 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8aa:	fb843783          	ld	a5,-72(s0)
 8ae:	00878713          	addi	a4,a5,8
 8b2:	fae43c23          	sd	a4,-72(s0)
 8b6:	639c                	ld	a5,0(a5)
 8b8:	0007871b          	sext.w	a4,a5
 8bc:	fcc42783          	lw	a5,-52(s0)
 8c0:	4681                	li	a3,0
 8c2:	4629                	li	a2,10
 8c4:	85ba                	mv	a1,a4
 8c6:	853e                	mv	a0,a5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	d8c080e7          	jalr	-628(ra) # 654 <printint>
 8d0:	aa89                	j	a22 <vprintf+0x23a>
      } else if(c == 'x') {
 8d2:	fdc42783          	lw	a5,-36(s0)
 8d6:	0007871b          	sext.w	a4,a5
 8da:	07800793          	li	a5,120
 8de:	02f71463          	bne	a4,a5,906 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8e2:	fb843783          	ld	a5,-72(s0)
 8e6:	00878713          	addi	a4,a5,8
 8ea:	fae43c23          	sd	a4,-72(s0)
 8ee:	4398                	lw	a4,0(a5)
 8f0:	fcc42783          	lw	a5,-52(s0)
 8f4:	4681                	li	a3,0
 8f6:	4641                	li	a2,16
 8f8:	85ba                	mv	a1,a4
 8fa:	853e                	mv	a0,a5
 8fc:	00000097          	auipc	ra,0x0
 900:	d58080e7          	jalr	-680(ra) # 654 <printint>
 904:	aa39                	j	a22 <vprintf+0x23a>
      } else if(c == 'p') {
 906:	fdc42783          	lw	a5,-36(s0)
 90a:	0007871b          	sext.w	a4,a5
 90e:	07000793          	li	a5,112
 912:	02f71263          	bne	a4,a5,936 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 916:	fb843783          	ld	a5,-72(s0)
 91a:	00878713          	addi	a4,a5,8
 91e:	fae43c23          	sd	a4,-72(s0)
 922:	6398                	ld	a4,0(a5)
 924:	fcc42783          	lw	a5,-52(s0)
 928:	85ba                	mv	a1,a4
 92a:	853e                	mv	a0,a5
 92c:	00000097          	auipc	ra,0x0
 930:	e30080e7          	jalr	-464(ra) # 75c <printptr>
 934:	a0fd                	j	a22 <vprintf+0x23a>
      } else if(c == 's'){
 936:	fdc42783          	lw	a5,-36(s0)
 93a:	0007871b          	sext.w	a4,a5
 93e:	07300793          	li	a5,115
 942:	04f71c63          	bne	a4,a5,99a <vprintf+0x1b2>
        s = va_arg(ap, char*);
 946:	fb843783          	ld	a5,-72(s0)
 94a:	00878713          	addi	a4,a5,8
 94e:	fae43c23          	sd	a4,-72(s0)
 952:	639c                	ld	a5,0(a5)
 954:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 958:	fe843783          	ld	a5,-24(s0)
 95c:	eb8d                	bnez	a5,98e <vprintf+0x1a6>
          s = "(null)";
 95e:	00000797          	auipc	a5,0x0
 962:	49278793          	addi	a5,a5,1170 # df0 <malloc+0x158>
 966:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 96a:	a015                	j	98e <vprintf+0x1a6>
          putc(fd, *s);
 96c:	fe843783          	ld	a5,-24(s0)
 970:	0007c703          	lbu	a4,0(a5)
 974:	fcc42783          	lw	a5,-52(s0)
 978:	85ba                	mv	a1,a4
 97a:	853e                	mv	a0,a5
 97c:	00000097          	auipc	ra,0x0
 980:	ca2080e7          	jalr	-862(ra) # 61e <putc>
          s++;
 984:	fe843783          	ld	a5,-24(s0)
 988:	0785                	addi	a5,a5,1
 98a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 98e:	fe843783          	ld	a5,-24(s0)
 992:	0007c783          	lbu	a5,0(a5)
 996:	fbf9                	bnez	a5,96c <vprintf+0x184>
 998:	a069                	j	a22 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 99a:	fdc42783          	lw	a5,-36(s0)
 99e:	0007871b          	sext.w	a4,a5
 9a2:	06300793          	li	a5,99
 9a6:	02f71463          	bne	a4,a5,9ce <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 9aa:	fb843783          	ld	a5,-72(s0)
 9ae:	00878713          	addi	a4,a5,8
 9b2:	fae43c23          	sd	a4,-72(s0)
 9b6:	439c                	lw	a5,0(a5)
 9b8:	0ff7f713          	zext.b	a4,a5
 9bc:	fcc42783          	lw	a5,-52(s0)
 9c0:	85ba                	mv	a1,a4
 9c2:	853e                	mv	a0,a5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	c5a080e7          	jalr	-934(ra) # 61e <putc>
 9cc:	a899                	j	a22 <vprintf+0x23a>
      } else if(c == '%'){
 9ce:	fdc42783          	lw	a5,-36(s0)
 9d2:	0007871b          	sext.w	a4,a5
 9d6:	02500793          	li	a5,37
 9da:	00f71f63          	bne	a4,a5,9f8 <vprintf+0x210>
        putc(fd, c);
 9de:	fdc42783          	lw	a5,-36(s0)
 9e2:	0ff7f713          	zext.b	a4,a5
 9e6:	fcc42783          	lw	a5,-52(s0)
 9ea:	85ba                	mv	a1,a4
 9ec:	853e                	mv	a0,a5
 9ee:	00000097          	auipc	ra,0x0
 9f2:	c30080e7          	jalr	-976(ra) # 61e <putc>
 9f6:	a035                	j	a22 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9f8:	fcc42783          	lw	a5,-52(s0)
 9fc:	02500593          	li	a1,37
 a00:	853e                	mv	a0,a5
 a02:	00000097          	auipc	ra,0x0
 a06:	c1c080e7          	jalr	-996(ra) # 61e <putc>
        putc(fd, c);
 a0a:	fdc42783          	lw	a5,-36(s0)
 a0e:	0ff7f713          	zext.b	a4,a5
 a12:	fcc42783          	lw	a5,-52(s0)
 a16:	85ba                	mv	a1,a4
 a18:	853e                	mv	a0,a5
 a1a:	00000097          	auipc	ra,0x0
 a1e:	c04080e7          	jalr	-1020(ra) # 61e <putc>
      }
      state = 0;
 a22:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a26:	fe442783          	lw	a5,-28(s0)
 a2a:	2785                	addiw	a5,a5,1
 a2c:	fef42223          	sw	a5,-28(s0)
 a30:	fe442783          	lw	a5,-28(s0)
 a34:	fc043703          	ld	a4,-64(s0)
 a38:	97ba                	add	a5,a5,a4
 a3a:	0007c783          	lbu	a5,0(a5)
 a3e:	dc0795e3          	bnez	a5,808 <vprintf+0x20>
    }
  }
}
 a42:	0001                	nop
 a44:	0001                	nop
 a46:	60a6                	ld	ra,72(sp)
 a48:	6406                	ld	s0,64(sp)
 a4a:	6161                	addi	sp,sp,80
 a4c:	8082                	ret

0000000000000a4e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a4e:	7159                	addi	sp,sp,-112
 a50:	fc06                	sd	ra,56(sp)
 a52:	f822                	sd	s0,48(sp)
 a54:	0080                	addi	s0,sp,64
 a56:	fcb43823          	sd	a1,-48(s0)
 a5a:	e010                	sd	a2,0(s0)
 a5c:	e414                	sd	a3,8(s0)
 a5e:	e818                	sd	a4,16(s0)
 a60:	ec1c                	sd	a5,24(s0)
 a62:	03043023          	sd	a6,32(s0)
 a66:	03143423          	sd	a7,40(s0)
 a6a:	87aa                	mv	a5,a0
 a6c:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a70:	03040793          	addi	a5,s0,48
 a74:	fcf43423          	sd	a5,-56(s0)
 a78:	fc843783          	ld	a5,-56(s0)
 a7c:	fd078793          	addi	a5,a5,-48
 a80:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a84:	fe843703          	ld	a4,-24(s0)
 a88:	fdc42783          	lw	a5,-36(s0)
 a8c:	863a                	mv	a2,a4
 a8e:	fd043583          	ld	a1,-48(s0)
 a92:	853e                	mv	a0,a5
 a94:	00000097          	auipc	ra,0x0
 a98:	d54080e7          	jalr	-684(ra) # 7e8 <vprintf>
}
 a9c:	0001                	nop
 a9e:	70e2                	ld	ra,56(sp)
 aa0:	7442                	ld	s0,48(sp)
 aa2:	6165                	addi	sp,sp,112
 aa4:	8082                	ret

0000000000000aa6 <printf>:

void
printf(const char *fmt, ...)
{
 aa6:	7159                	addi	sp,sp,-112
 aa8:	f406                	sd	ra,40(sp)
 aaa:	f022                	sd	s0,32(sp)
 aac:	1800                	addi	s0,sp,48
 aae:	fca43c23          	sd	a0,-40(s0)
 ab2:	e40c                	sd	a1,8(s0)
 ab4:	e810                	sd	a2,16(s0)
 ab6:	ec14                	sd	a3,24(s0)
 ab8:	f018                	sd	a4,32(s0)
 aba:	f41c                	sd	a5,40(s0)
 abc:	03043823          	sd	a6,48(s0)
 ac0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ac4:	04040793          	addi	a5,s0,64
 ac8:	fcf43823          	sd	a5,-48(s0)
 acc:	fd043783          	ld	a5,-48(s0)
 ad0:	fc878793          	addi	a5,a5,-56
 ad4:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ad8:	fe843783          	ld	a5,-24(s0)
 adc:	863e                	mv	a2,a5
 ade:	fd843583          	ld	a1,-40(s0)
 ae2:	4505                	li	a0,1
 ae4:	00000097          	auipc	ra,0x0
 ae8:	d04080e7          	jalr	-764(ra) # 7e8 <vprintf>
}
 aec:	0001                	nop
 aee:	70a2                	ld	ra,40(sp)
 af0:	7402                	ld	s0,32(sp)
 af2:	6165                	addi	sp,sp,112
 af4:	8082                	ret

0000000000000af6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 af6:	7179                	addi	sp,sp,-48
 af8:	f422                	sd	s0,40(sp)
 afa:	1800                	addi	s0,sp,48
 afc:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b00:	fd843783          	ld	a5,-40(s0)
 b04:	17c1                	addi	a5,a5,-16
 b06:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b0a:	00001797          	auipc	a5,0x1
 b0e:	89678793          	addi	a5,a5,-1898 # 13a0 <freep>
 b12:	639c                	ld	a5,0(a5)
 b14:	fef43423          	sd	a5,-24(s0)
 b18:	a815                	j	b4c <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b1a:	fe843783          	ld	a5,-24(s0)
 b1e:	639c                	ld	a5,0(a5)
 b20:	fe843703          	ld	a4,-24(s0)
 b24:	00f76f63          	bltu	a4,a5,b42 <free+0x4c>
 b28:	fe043703          	ld	a4,-32(s0)
 b2c:	fe843783          	ld	a5,-24(s0)
 b30:	02e7eb63          	bltu	a5,a4,b66 <free+0x70>
 b34:	fe843783          	ld	a5,-24(s0)
 b38:	639c                	ld	a5,0(a5)
 b3a:	fe043703          	ld	a4,-32(s0)
 b3e:	02f76463          	bltu	a4,a5,b66 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b42:	fe843783          	ld	a5,-24(s0)
 b46:	639c                	ld	a5,0(a5)
 b48:	fef43423          	sd	a5,-24(s0)
 b4c:	fe043703          	ld	a4,-32(s0)
 b50:	fe843783          	ld	a5,-24(s0)
 b54:	fce7f3e3          	bgeu	a5,a4,b1a <free+0x24>
 b58:	fe843783          	ld	a5,-24(s0)
 b5c:	639c                	ld	a5,0(a5)
 b5e:	fe043703          	ld	a4,-32(s0)
 b62:	faf77ce3          	bgeu	a4,a5,b1a <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b66:	fe043783          	ld	a5,-32(s0)
 b6a:	479c                	lw	a5,8(a5)
 b6c:	1782                	slli	a5,a5,0x20
 b6e:	9381                	srli	a5,a5,0x20
 b70:	0792                	slli	a5,a5,0x4
 b72:	fe043703          	ld	a4,-32(s0)
 b76:	973e                	add	a4,a4,a5
 b78:	fe843783          	ld	a5,-24(s0)
 b7c:	639c                	ld	a5,0(a5)
 b7e:	02f71763          	bne	a4,a5,bac <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b82:	fe043783          	ld	a5,-32(s0)
 b86:	4798                	lw	a4,8(a5)
 b88:	fe843783          	ld	a5,-24(s0)
 b8c:	639c                	ld	a5,0(a5)
 b8e:	479c                	lw	a5,8(a5)
 b90:	9fb9                	addw	a5,a5,a4
 b92:	0007871b          	sext.w	a4,a5
 b96:	fe043783          	ld	a5,-32(s0)
 b9a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b9c:	fe843783          	ld	a5,-24(s0)
 ba0:	639c                	ld	a5,0(a5)
 ba2:	6398                	ld	a4,0(a5)
 ba4:	fe043783          	ld	a5,-32(s0)
 ba8:	e398                	sd	a4,0(a5)
 baa:	a039                	j	bb8 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 bac:	fe843783          	ld	a5,-24(s0)
 bb0:	6398                	ld	a4,0(a5)
 bb2:	fe043783          	ld	a5,-32(s0)
 bb6:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 bb8:	fe843783          	ld	a5,-24(s0)
 bbc:	479c                	lw	a5,8(a5)
 bbe:	1782                	slli	a5,a5,0x20
 bc0:	9381                	srli	a5,a5,0x20
 bc2:	0792                	slli	a5,a5,0x4
 bc4:	fe843703          	ld	a4,-24(s0)
 bc8:	97ba                	add	a5,a5,a4
 bca:	fe043703          	ld	a4,-32(s0)
 bce:	02f71563          	bne	a4,a5,bf8 <free+0x102>
    p->s.size += bp->s.size;
 bd2:	fe843783          	ld	a5,-24(s0)
 bd6:	4798                	lw	a4,8(a5)
 bd8:	fe043783          	ld	a5,-32(s0)
 bdc:	479c                	lw	a5,8(a5)
 bde:	9fb9                	addw	a5,a5,a4
 be0:	0007871b          	sext.w	a4,a5
 be4:	fe843783          	ld	a5,-24(s0)
 be8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bea:	fe043783          	ld	a5,-32(s0)
 bee:	6398                	ld	a4,0(a5)
 bf0:	fe843783          	ld	a5,-24(s0)
 bf4:	e398                	sd	a4,0(a5)
 bf6:	a031                	j	c02 <free+0x10c>
  } else
    p->s.ptr = bp;
 bf8:	fe843783          	ld	a5,-24(s0)
 bfc:	fe043703          	ld	a4,-32(s0)
 c00:	e398                	sd	a4,0(a5)
  freep = p;
 c02:	00000797          	auipc	a5,0x0
 c06:	79e78793          	addi	a5,a5,1950 # 13a0 <freep>
 c0a:	fe843703          	ld	a4,-24(s0)
 c0e:	e398                	sd	a4,0(a5)
}
 c10:	0001                	nop
 c12:	7422                	ld	s0,40(sp)
 c14:	6145                	addi	sp,sp,48
 c16:	8082                	ret

0000000000000c18 <morecore>:

static Header*
morecore(uint nu)
{
 c18:	7179                	addi	sp,sp,-48
 c1a:	f406                	sd	ra,40(sp)
 c1c:	f022                	sd	s0,32(sp)
 c1e:	1800                	addi	s0,sp,48
 c20:	87aa                	mv	a5,a0
 c22:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c26:	fdc42783          	lw	a5,-36(s0)
 c2a:	0007871b          	sext.w	a4,a5
 c2e:	6785                	lui	a5,0x1
 c30:	00f77563          	bgeu	a4,a5,c3a <morecore+0x22>
    nu = 4096;
 c34:	6785                	lui	a5,0x1
 c36:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c3a:	fdc42783          	lw	a5,-36(s0)
 c3e:	0047979b          	slliw	a5,a5,0x4
 c42:	2781                	sext.w	a5,a5
 c44:	2781                	sext.w	a5,a5
 c46:	853e                	mv	a0,a5
 c48:	00000097          	auipc	ra,0x0
 c4c:	9a6080e7          	jalr	-1626(ra) # 5ee <sbrk>
 c50:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c54:	fe843703          	ld	a4,-24(s0)
 c58:	57fd                	li	a5,-1
 c5a:	00f71463          	bne	a4,a5,c62 <morecore+0x4a>
    return 0;
 c5e:	4781                	li	a5,0
 c60:	a03d                	j	c8e <morecore+0x76>
  hp = (Header*)p;
 c62:	fe843783          	ld	a5,-24(s0)
 c66:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c6a:	fe043783          	ld	a5,-32(s0)
 c6e:	fdc42703          	lw	a4,-36(s0)
 c72:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c74:	fe043783          	ld	a5,-32(s0)
 c78:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x378>
 c7a:	853e                	mv	a0,a5
 c7c:	00000097          	auipc	ra,0x0
 c80:	e7a080e7          	jalr	-390(ra) # af6 <free>
  return freep;
 c84:	00000797          	auipc	a5,0x0
 c88:	71c78793          	addi	a5,a5,1820 # 13a0 <freep>
 c8c:	639c                	ld	a5,0(a5)
}
 c8e:	853e                	mv	a0,a5
 c90:	70a2                	ld	ra,40(sp)
 c92:	7402                	ld	s0,32(sp)
 c94:	6145                	addi	sp,sp,48
 c96:	8082                	ret

0000000000000c98 <malloc>:

void*
malloc(uint nbytes)
{
 c98:	7139                	addi	sp,sp,-64
 c9a:	fc06                	sd	ra,56(sp)
 c9c:	f822                	sd	s0,48(sp)
 c9e:	0080                	addi	s0,sp,64
 ca0:	87aa                	mv	a5,a0
 ca2:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ca6:	fcc46783          	lwu	a5,-52(s0)
 caa:	07bd                	addi	a5,a5,15
 cac:	8391                	srli	a5,a5,0x4
 cae:	2781                	sext.w	a5,a5
 cb0:	2785                	addiw	a5,a5,1
 cb2:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 cb6:	00000797          	auipc	a5,0x0
 cba:	6ea78793          	addi	a5,a5,1770 # 13a0 <freep>
 cbe:	639c                	ld	a5,0(a5)
 cc0:	fef43023          	sd	a5,-32(s0)
 cc4:	fe043783          	ld	a5,-32(s0)
 cc8:	ef95                	bnez	a5,d04 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cca:	00000797          	auipc	a5,0x0
 cce:	6c678793          	addi	a5,a5,1734 # 1390 <base>
 cd2:	fef43023          	sd	a5,-32(s0)
 cd6:	00000797          	auipc	a5,0x0
 cda:	6ca78793          	addi	a5,a5,1738 # 13a0 <freep>
 cde:	fe043703          	ld	a4,-32(s0)
 ce2:	e398                	sd	a4,0(a5)
 ce4:	00000797          	auipc	a5,0x0
 ce8:	6bc78793          	addi	a5,a5,1724 # 13a0 <freep>
 cec:	6398                	ld	a4,0(a5)
 cee:	00000797          	auipc	a5,0x0
 cf2:	6a278793          	addi	a5,a5,1698 # 1390 <base>
 cf6:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cf8:	00000797          	auipc	a5,0x0
 cfc:	69878793          	addi	a5,a5,1688 # 1390 <base>
 d00:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d04:	fe043783          	ld	a5,-32(s0)
 d08:	639c                	ld	a5,0(a5)
 d0a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d0e:	fe843783          	ld	a5,-24(s0)
 d12:	4798                	lw	a4,8(a5)
 d14:	fdc42783          	lw	a5,-36(s0)
 d18:	2781                	sext.w	a5,a5
 d1a:	06f76763          	bltu	a4,a5,d88 <malloc+0xf0>
      if(p->s.size == nunits)
 d1e:	fe843783          	ld	a5,-24(s0)
 d22:	4798                	lw	a4,8(a5)
 d24:	fdc42783          	lw	a5,-36(s0)
 d28:	2781                	sext.w	a5,a5
 d2a:	00e79963          	bne	a5,a4,d3c <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d2e:	fe843783          	ld	a5,-24(s0)
 d32:	6398                	ld	a4,0(a5)
 d34:	fe043783          	ld	a5,-32(s0)
 d38:	e398                	sd	a4,0(a5)
 d3a:	a825                	j	d72 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d3c:	fe843783          	ld	a5,-24(s0)
 d40:	479c                	lw	a5,8(a5)
 d42:	fdc42703          	lw	a4,-36(s0)
 d46:	9f99                	subw	a5,a5,a4
 d48:	0007871b          	sext.w	a4,a5
 d4c:	fe843783          	ld	a5,-24(s0)
 d50:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d52:	fe843783          	ld	a5,-24(s0)
 d56:	479c                	lw	a5,8(a5)
 d58:	1782                	slli	a5,a5,0x20
 d5a:	9381                	srli	a5,a5,0x20
 d5c:	0792                	slli	a5,a5,0x4
 d5e:	fe843703          	ld	a4,-24(s0)
 d62:	97ba                	add	a5,a5,a4
 d64:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d68:	fe843783          	ld	a5,-24(s0)
 d6c:	fdc42703          	lw	a4,-36(s0)
 d70:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d72:	00000797          	auipc	a5,0x0
 d76:	62e78793          	addi	a5,a5,1582 # 13a0 <freep>
 d7a:	fe043703          	ld	a4,-32(s0)
 d7e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d80:	fe843783          	ld	a5,-24(s0)
 d84:	07c1                	addi	a5,a5,16
 d86:	a091                	j	dca <malloc+0x132>
    }
    if(p == freep)
 d88:	00000797          	auipc	a5,0x0
 d8c:	61878793          	addi	a5,a5,1560 # 13a0 <freep>
 d90:	639c                	ld	a5,0(a5)
 d92:	fe843703          	ld	a4,-24(s0)
 d96:	02f71063          	bne	a4,a5,db6 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d9a:	fdc42783          	lw	a5,-36(s0)
 d9e:	853e                	mv	a0,a5
 da0:	00000097          	auipc	ra,0x0
 da4:	e78080e7          	jalr	-392(ra) # c18 <morecore>
 da8:	fea43423          	sd	a0,-24(s0)
 dac:	fe843783          	ld	a5,-24(s0)
 db0:	e399                	bnez	a5,db6 <malloc+0x11e>
        return 0;
 db2:	4781                	li	a5,0
 db4:	a819                	j	dca <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db6:	fe843783          	ld	a5,-24(s0)
 dba:	fef43023          	sd	a5,-32(s0)
 dbe:	fe843783          	ld	a5,-24(s0)
 dc2:	639c                	ld	a5,0(a5)
 dc4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dc8:	b799                	j	d0e <malloc+0x76>
  }
}
 dca:	853e                	mv	a0,a5
 dcc:	70e2                	ld	ra,56(sp)
 dce:	7442                	ld	s0,48(sp)
 dd0:	6121                	addi	sp,sp,64
 dd2:	8082                	ret
