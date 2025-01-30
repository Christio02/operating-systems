
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
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
    fprintf(2, "Usage: rm files...\n");
  20:	00001597          	auipc	a1,0x1
  24:	db058593          	addi	a1,a1,-592 # dd0 <malloc+0x146>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	a16080e7          	jalr	-1514(ra) # a40 <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	524080e7          	jalr	1316(ra) # 558 <exit>
  }

  for(i = 1; i < argc; i++){
  3c:	4785                	li	a5,1
  3e:	fef42623          	sw	a5,-20(s0)
  42:	a0b9                	j	90 <main+0x90>
    if(unlink(argv[i]) < 0){
  44:	fec42783          	lw	a5,-20(s0)
  48:	078e                	slli	a5,a5,0x3
  4a:	fd043703          	ld	a4,-48(s0)
  4e:	97ba                	add	a5,a5,a4
  50:	639c                	ld	a5,0(a5)
  52:	853e                	mv	a0,a5
  54:	00000097          	auipc	ra,0x0
  58:	554080e7          	jalr	1364(ra) # 5a8 <unlink>
  5c:	87aa                	mv	a5,a0
  5e:	0207d463          	bgez	a5,86 <main+0x86>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  62:	fec42783          	lw	a5,-20(s0)
  66:	078e                	slli	a5,a5,0x3
  68:	fd043703          	ld	a4,-48(s0)
  6c:	97ba                	add	a5,a5,a4
  6e:	639c                	ld	a5,0(a5)
  70:	863e                	mv	a2,a5
  72:	00001597          	auipc	a1,0x1
  76:	d7658593          	addi	a1,a1,-650 # de8 <malloc+0x15e>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9c4080e7          	jalr	-1596(ra) # a40 <fprintf>
      break;
  84:	a839                	j	a2 <main+0xa2>
  for(i = 1; i < argc; i++){
  86:	fec42783          	lw	a5,-20(s0)
  8a:	2785                	addiw	a5,a5,1
  8c:	fef42623          	sw	a5,-20(s0)
  90:	fec42783          	lw	a5,-20(s0)
  94:	873e                	mv	a4,a5
  96:	fdc42783          	lw	a5,-36(s0)
  9a:	2701                	sext.w	a4,a4
  9c:	2781                	sext.w	a5,a5
  9e:	faf743e3          	blt	a4,a5,44 <main+0x44>
    }
  }

  exit(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	4b4080e7          	jalr	1204(ra) # 558 <exit>

00000000000000ac <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  b4:	00000097          	auipc	ra,0x0
  b8:	f4c080e7          	jalr	-180(ra) # 0 <main>
  exit(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	49a080e7          	jalr	1178(ra) # 558 <exit>

00000000000000c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  c6:	7179                	addi	sp,sp,-48
  c8:	f422                	sd	s0,40(sp)
  ca:	1800                	addi	s0,sp,48
  cc:	fca43c23          	sd	a0,-40(s0)
  d0:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  d4:	fd843783          	ld	a5,-40(s0)
  d8:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  dc:	0001                	nop
  de:	fd043703          	ld	a4,-48(s0)
  e2:	00170793          	addi	a5,a4,1
  e6:	fcf43823          	sd	a5,-48(s0)
  ea:	fd843783          	ld	a5,-40(s0)
  ee:	00178693          	addi	a3,a5,1
  f2:	fcd43c23          	sd	a3,-40(s0)
  f6:	00074703          	lbu	a4,0(a4)
  fa:	00e78023          	sb	a4,0(a5)
  fe:	0007c783          	lbu	a5,0(a5)
 102:	fff1                	bnez	a5,de <strcpy+0x18>
    ;
  return os;
 104:	fe843783          	ld	a5,-24(s0)
}
 108:	853e                	mv	a0,a5
 10a:	7422                	ld	s0,40(sp)
 10c:	6145                	addi	sp,sp,48
 10e:	8082                	ret

0000000000000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	1101                	addi	sp,sp,-32
 112:	ec22                	sd	s0,24(sp)
 114:	1000                	addi	s0,sp,32
 116:	fea43423          	sd	a0,-24(s0)
 11a:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 11e:	a819                	j	134 <strcmp+0x24>
    p++, q++;
 120:	fe843783          	ld	a5,-24(s0)
 124:	0785                	addi	a5,a5,1
 126:	fef43423          	sd	a5,-24(s0)
 12a:	fe043783          	ld	a5,-32(s0)
 12e:	0785                	addi	a5,a5,1
 130:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 134:	fe843783          	ld	a5,-24(s0)
 138:	0007c783          	lbu	a5,0(a5)
 13c:	cb99                	beqz	a5,152 <strcmp+0x42>
 13e:	fe843783          	ld	a5,-24(s0)
 142:	0007c703          	lbu	a4,0(a5)
 146:	fe043783          	ld	a5,-32(s0)
 14a:	0007c783          	lbu	a5,0(a5)
 14e:	fcf709e3          	beq	a4,a5,120 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 152:	fe843783          	ld	a5,-24(s0)
 156:	0007c783          	lbu	a5,0(a5)
 15a:	0007871b          	sext.w	a4,a5
 15e:	fe043783          	ld	a5,-32(s0)
 162:	0007c783          	lbu	a5,0(a5)
 166:	2781                	sext.w	a5,a5
 168:	40f707bb          	subw	a5,a4,a5
 16c:	2781                	sext.w	a5,a5
}
 16e:	853e                	mv	a0,a5
 170:	6462                	ld	s0,24(sp)
 172:	6105                	addi	sp,sp,32
 174:	8082                	ret

0000000000000176 <strlen>:

uint
strlen(const char *s)
{
 176:	7179                	addi	sp,sp,-48
 178:	f422                	sd	s0,40(sp)
 17a:	1800                	addi	s0,sp,48
 17c:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 180:	fe042623          	sw	zero,-20(s0)
 184:	a031                	j	190 <strlen+0x1a>
 186:	fec42783          	lw	a5,-20(s0)
 18a:	2785                	addiw	a5,a5,1
 18c:	fef42623          	sw	a5,-20(s0)
 190:	fec42783          	lw	a5,-20(s0)
 194:	fd843703          	ld	a4,-40(s0)
 198:	97ba                	add	a5,a5,a4
 19a:	0007c783          	lbu	a5,0(a5)
 19e:	f7e5                	bnez	a5,186 <strlen+0x10>
    ;
  return n;
 1a0:	fec42783          	lw	a5,-20(s0)
}
 1a4:	853e                	mv	a0,a5
 1a6:	7422                	ld	s0,40(sp)
 1a8:	6145                	addi	sp,sp,48
 1aa:	8082                	ret

00000000000001ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ac:	7179                	addi	sp,sp,-48
 1ae:	f422                	sd	s0,40(sp)
 1b0:	1800                	addi	s0,sp,48
 1b2:	fca43c23          	sd	a0,-40(s0)
 1b6:	87ae                	mv	a5,a1
 1b8:	8732                	mv	a4,a2
 1ba:	fcf42a23          	sw	a5,-44(s0)
 1be:	87ba                	mv	a5,a4
 1c0:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1c4:	fd843783          	ld	a5,-40(s0)
 1c8:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1cc:	fe042623          	sw	zero,-20(s0)
 1d0:	a00d                	j	1f2 <memset+0x46>
    cdst[i] = c;
 1d2:	fec42783          	lw	a5,-20(s0)
 1d6:	fe043703          	ld	a4,-32(s0)
 1da:	97ba                	add	a5,a5,a4
 1dc:	fd442703          	lw	a4,-44(s0)
 1e0:	0ff77713          	zext.b	a4,a4
 1e4:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1e8:	fec42783          	lw	a5,-20(s0)
 1ec:	2785                	addiw	a5,a5,1
 1ee:	fef42623          	sw	a5,-20(s0)
 1f2:	fec42703          	lw	a4,-20(s0)
 1f6:	fd042783          	lw	a5,-48(s0)
 1fa:	2781                	sext.w	a5,a5
 1fc:	fcf76be3          	bltu	a4,a5,1d2 <memset+0x26>
  }
  return dst;
 200:	fd843783          	ld	a5,-40(s0)
}
 204:	853e                	mv	a0,a5
 206:	7422                	ld	s0,40(sp)
 208:	6145                	addi	sp,sp,48
 20a:	8082                	ret

000000000000020c <strchr>:

char*
strchr(const char *s, char c)
{
 20c:	1101                	addi	sp,sp,-32
 20e:	ec22                	sd	s0,24(sp)
 210:	1000                	addi	s0,sp,32
 212:	fea43423          	sd	a0,-24(s0)
 216:	87ae                	mv	a5,a1
 218:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 21c:	a01d                	j	242 <strchr+0x36>
    if(*s == c)
 21e:	fe843783          	ld	a5,-24(s0)
 222:	0007c703          	lbu	a4,0(a5)
 226:	fe744783          	lbu	a5,-25(s0)
 22a:	0ff7f793          	zext.b	a5,a5
 22e:	00e79563          	bne	a5,a4,238 <strchr+0x2c>
      return (char*)s;
 232:	fe843783          	ld	a5,-24(s0)
 236:	a821                	j	24e <strchr+0x42>
  for(; *s; s++)
 238:	fe843783          	ld	a5,-24(s0)
 23c:	0785                	addi	a5,a5,1
 23e:	fef43423          	sd	a5,-24(s0)
 242:	fe843783          	ld	a5,-24(s0)
 246:	0007c783          	lbu	a5,0(a5)
 24a:	fbf1                	bnez	a5,21e <strchr+0x12>
  return 0;
 24c:	4781                	li	a5,0
}
 24e:	853e                	mv	a0,a5
 250:	6462                	ld	s0,24(sp)
 252:	6105                	addi	sp,sp,32
 254:	8082                	ret

0000000000000256 <gets>:

char*
gets(char *buf, int max)
{
 256:	7179                	addi	sp,sp,-48
 258:	f406                	sd	ra,40(sp)
 25a:	f022                	sd	s0,32(sp)
 25c:	1800                	addi	s0,sp,48
 25e:	fca43c23          	sd	a0,-40(s0)
 262:	87ae                	mv	a5,a1
 264:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 268:	fe042623          	sw	zero,-20(s0)
 26c:	a8a1                	j	2c4 <gets+0x6e>
    cc = read(0, &c, 1);
 26e:	fe740793          	addi	a5,s0,-25
 272:	4605                	li	a2,1
 274:	85be                	mv	a1,a5
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	2f8080e7          	jalr	760(ra) # 570 <read>
 280:	87aa                	mv	a5,a0
 282:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 286:	fe842783          	lw	a5,-24(s0)
 28a:	2781                	sext.w	a5,a5
 28c:	04f05763          	blez	a5,2da <gets+0x84>
      break;
    buf[i++] = c;
 290:	fec42783          	lw	a5,-20(s0)
 294:	0017871b          	addiw	a4,a5,1
 298:	fee42623          	sw	a4,-20(s0)
 29c:	873e                	mv	a4,a5
 29e:	fd843783          	ld	a5,-40(s0)
 2a2:	97ba                	add	a5,a5,a4
 2a4:	fe744703          	lbu	a4,-25(s0)
 2a8:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2ac:	fe744783          	lbu	a5,-25(s0)
 2b0:	873e                	mv	a4,a5
 2b2:	47a9                	li	a5,10
 2b4:	02f70463          	beq	a4,a5,2dc <gets+0x86>
 2b8:	fe744783          	lbu	a5,-25(s0)
 2bc:	873e                	mv	a4,a5
 2be:	47b5                	li	a5,13
 2c0:	00f70e63          	beq	a4,a5,2dc <gets+0x86>
  for(i=0; i+1 < max; ){
 2c4:	fec42783          	lw	a5,-20(s0)
 2c8:	2785                	addiw	a5,a5,1
 2ca:	0007871b          	sext.w	a4,a5
 2ce:	fd442783          	lw	a5,-44(s0)
 2d2:	2781                	sext.w	a5,a5
 2d4:	f8f74de3          	blt	a4,a5,26e <gets+0x18>
 2d8:	a011                	j	2dc <gets+0x86>
      break;
 2da:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2dc:	fec42783          	lw	a5,-20(s0)
 2e0:	fd843703          	ld	a4,-40(s0)
 2e4:	97ba                	add	a5,a5,a4
 2e6:	00078023          	sb	zero,0(a5)
  return buf;
 2ea:	fd843783          	ld	a5,-40(s0)
}
 2ee:	853e                	mv	a0,a5
 2f0:	70a2                	ld	ra,40(sp)
 2f2:	7402                	ld	s0,32(sp)
 2f4:	6145                	addi	sp,sp,48
 2f6:	8082                	ret

00000000000002f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f8:	7179                	addi	sp,sp,-48
 2fa:	f406                	sd	ra,40(sp)
 2fc:	f022                	sd	s0,32(sp)
 2fe:	1800                	addi	s0,sp,48
 300:	fca43c23          	sd	a0,-40(s0)
 304:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 308:	4581                	li	a1,0
 30a:	fd843503          	ld	a0,-40(s0)
 30e:	00000097          	auipc	ra,0x0
 312:	28a080e7          	jalr	650(ra) # 598 <open>
 316:	87aa                	mv	a5,a0
 318:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 31c:	fec42783          	lw	a5,-20(s0)
 320:	2781                	sext.w	a5,a5
 322:	0007d463          	bgez	a5,32a <stat+0x32>
    return -1;
 326:	57fd                	li	a5,-1
 328:	a035                	j	354 <stat+0x5c>
  r = fstat(fd, st);
 32a:	fec42783          	lw	a5,-20(s0)
 32e:	fd043583          	ld	a1,-48(s0)
 332:	853e                	mv	a0,a5
 334:	00000097          	auipc	ra,0x0
 338:	27c080e7          	jalr	636(ra) # 5b0 <fstat>
 33c:	87aa                	mv	a5,a0
 33e:	fef42423          	sw	a5,-24(s0)
  close(fd);
 342:	fec42783          	lw	a5,-20(s0)
 346:	853e                	mv	a0,a5
 348:	00000097          	auipc	ra,0x0
 34c:	238080e7          	jalr	568(ra) # 580 <close>
  return r;
 350:	fe842783          	lw	a5,-24(s0)
}
 354:	853e                	mv	a0,a5
 356:	70a2                	ld	ra,40(sp)
 358:	7402                	ld	s0,32(sp)
 35a:	6145                	addi	sp,sp,48
 35c:	8082                	ret

000000000000035e <atoi>:

int
atoi(const char *s)
{
 35e:	7179                	addi	sp,sp,-48
 360:	f422                	sd	s0,40(sp)
 362:	1800                	addi	s0,sp,48
 364:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 368:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 36c:	a81d                	j	3a2 <atoi+0x44>
    n = n*10 + *s++ - '0';
 36e:	fec42783          	lw	a5,-20(s0)
 372:	873e                	mv	a4,a5
 374:	87ba                	mv	a5,a4
 376:	0027979b          	slliw	a5,a5,0x2
 37a:	9fb9                	addw	a5,a5,a4
 37c:	0017979b          	slliw	a5,a5,0x1
 380:	0007871b          	sext.w	a4,a5
 384:	fd843783          	ld	a5,-40(s0)
 388:	00178693          	addi	a3,a5,1
 38c:	fcd43c23          	sd	a3,-40(s0)
 390:	0007c783          	lbu	a5,0(a5)
 394:	2781                	sext.w	a5,a5
 396:	9fb9                	addw	a5,a5,a4
 398:	2781                	sext.w	a5,a5
 39a:	fd07879b          	addiw	a5,a5,-48
 39e:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 3a2:	fd843783          	ld	a5,-40(s0)
 3a6:	0007c783          	lbu	a5,0(a5)
 3aa:	873e                	mv	a4,a5
 3ac:	02f00793          	li	a5,47
 3b0:	00e7fb63          	bgeu	a5,a4,3c6 <atoi+0x68>
 3b4:	fd843783          	ld	a5,-40(s0)
 3b8:	0007c783          	lbu	a5,0(a5)
 3bc:	873e                	mv	a4,a5
 3be:	03900793          	li	a5,57
 3c2:	fae7f6e3          	bgeu	a5,a4,36e <atoi+0x10>
  return n;
 3c6:	fec42783          	lw	a5,-20(s0)
}
 3ca:	853e                	mv	a0,a5
 3cc:	7422                	ld	s0,40(sp)
 3ce:	6145                	addi	sp,sp,48
 3d0:	8082                	ret

00000000000003d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d2:	7139                	addi	sp,sp,-64
 3d4:	fc22                	sd	s0,56(sp)
 3d6:	0080                	addi	s0,sp,64
 3d8:	fca43c23          	sd	a0,-40(s0)
 3dc:	fcb43823          	sd	a1,-48(s0)
 3e0:	87b2                	mv	a5,a2
 3e2:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3e6:	fd843783          	ld	a5,-40(s0)
 3ea:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3ee:	fd043783          	ld	a5,-48(s0)
 3f2:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3f6:	fe043703          	ld	a4,-32(s0)
 3fa:	fe843783          	ld	a5,-24(s0)
 3fe:	02e7fc63          	bgeu	a5,a4,436 <memmove+0x64>
    while(n-- > 0)
 402:	a00d                	j	424 <memmove+0x52>
      *dst++ = *src++;
 404:	fe043703          	ld	a4,-32(s0)
 408:	00170793          	addi	a5,a4,1
 40c:	fef43023          	sd	a5,-32(s0)
 410:	fe843783          	ld	a5,-24(s0)
 414:	00178693          	addi	a3,a5,1
 418:	fed43423          	sd	a3,-24(s0)
 41c:	00074703          	lbu	a4,0(a4)
 420:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 424:	fcc42783          	lw	a5,-52(s0)
 428:	fff7871b          	addiw	a4,a5,-1
 42c:	fce42623          	sw	a4,-52(s0)
 430:	fcf04ae3          	bgtz	a5,404 <memmove+0x32>
 434:	a891                	j	488 <memmove+0xb6>
  } else {
    dst += n;
 436:	fcc42783          	lw	a5,-52(s0)
 43a:	fe843703          	ld	a4,-24(s0)
 43e:	97ba                	add	a5,a5,a4
 440:	fef43423          	sd	a5,-24(s0)
    src += n;
 444:	fcc42783          	lw	a5,-52(s0)
 448:	fe043703          	ld	a4,-32(s0)
 44c:	97ba                	add	a5,a5,a4
 44e:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 452:	a01d                	j	478 <memmove+0xa6>
      *--dst = *--src;
 454:	fe043783          	ld	a5,-32(s0)
 458:	17fd                	addi	a5,a5,-1
 45a:	fef43023          	sd	a5,-32(s0)
 45e:	fe843783          	ld	a5,-24(s0)
 462:	17fd                	addi	a5,a5,-1
 464:	fef43423          	sd	a5,-24(s0)
 468:	fe043783          	ld	a5,-32(s0)
 46c:	0007c703          	lbu	a4,0(a5)
 470:	fe843783          	ld	a5,-24(s0)
 474:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 478:	fcc42783          	lw	a5,-52(s0)
 47c:	fff7871b          	addiw	a4,a5,-1
 480:	fce42623          	sw	a4,-52(s0)
 484:	fcf048e3          	bgtz	a5,454 <memmove+0x82>
  }
  return vdst;
 488:	fd843783          	ld	a5,-40(s0)
}
 48c:	853e                	mv	a0,a5
 48e:	7462                	ld	s0,56(sp)
 490:	6121                	addi	sp,sp,64
 492:	8082                	ret

0000000000000494 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc22                	sd	s0,56(sp)
 498:	0080                	addi	s0,sp,64
 49a:	fca43c23          	sd	a0,-40(s0)
 49e:	fcb43823          	sd	a1,-48(s0)
 4a2:	87b2                	mv	a5,a2
 4a4:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4a8:	fd843783          	ld	a5,-40(s0)
 4ac:	fef43423          	sd	a5,-24(s0)
 4b0:	fd043783          	ld	a5,-48(s0)
 4b4:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4b8:	a0a1                	j	500 <memcmp+0x6c>
    if (*p1 != *p2) {
 4ba:	fe843783          	ld	a5,-24(s0)
 4be:	0007c703          	lbu	a4,0(a5)
 4c2:	fe043783          	ld	a5,-32(s0)
 4c6:	0007c783          	lbu	a5,0(a5)
 4ca:	02f70163          	beq	a4,a5,4ec <memcmp+0x58>
      return *p1 - *p2;
 4ce:	fe843783          	ld	a5,-24(s0)
 4d2:	0007c783          	lbu	a5,0(a5)
 4d6:	0007871b          	sext.w	a4,a5
 4da:	fe043783          	ld	a5,-32(s0)
 4de:	0007c783          	lbu	a5,0(a5)
 4e2:	2781                	sext.w	a5,a5
 4e4:	40f707bb          	subw	a5,a4,a5
 4e8:	2781                	sext.w	a5,a5
 4ea:	a01d                	j	510 <memcmp+0x7c>
    }
    p1++;
 4ec:	fe843783          	ld	a5,-24(s0)
 4f0:	0785                	addi	a5,a5,1
 4f2:	fef43423          	sd	a5,-24(s0)
    p2++;
 4f6:	fe043783          	ld	a5,-32(s0)
 4fa:	0785                	addi	a5,a5,1
 4fc:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 500:	fcc42783          	lw	a5,-52(s0)
 504:	fff7871b          	addiw	a4,a5,-1
 508:	fce42623          	sw	a4,-52(s0)
 50c:	f7dd                	bnez	a5,4ba <memcmp+0x26>
  }
  return 0;
 50e:	4781                	li	a5,0
}
 510:	853e                	mv	a0,a5
 512:	7462                	ld	s0,56(sp)
 514:	6121                	addi	sp,sp,64
 516:	8082                	ret

0000000000000518 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 518:	7179                	addi	sp,sp,-48
 51a:	f406                	sd	ra,40(sp)
 51c:	f022                	sd	s0,32(sp)
 51e:	1800                	addi	s0,sp,48
 520:	fea43423          	sd	a0,-24(s0)
 524:	feb43023          	sd	a1,-32(s0)
 528:	87b2                	mv	a5,a2
 52a:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 52e:	fdc42783          	lw	a5,-36(s0)
 532:	863e                	mv	a2,a5
 534:	fe043583          	ld	a1,-32(s0)
 538:	fe843503          	ld	a0,-24(s0)
 53c:	00000097          	auipc	ra,0x0
 540:	e96080e7          	jalr	-362(ra) # 3d2 <memmove>
 544:	87aa                	mv	a5,a0
}
 546:	853e                	mv	a0,a5
 548:	70a2                	ld	ra,40(sp)
 54a:	7402                	ld	s0,32(sp)
 54c:	6145                	addi	sp,sp,48
 54e:	8082                	ret

0000000000000550 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 550:	4885                	li	a7,1
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <exit>:
.global exit
exit:
 li a7, SYS_exit
 558:	4889                	li	a7,2
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <wait>:
.global wait
wait:
 li a7, SYS_wait
 560:	488d                	li	a7,3
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 568:	4891                	li	a7,4
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <read>:
.global read
read:
 li a7, SYS_read
 570:	4895                	li	a7,5
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <write>:
.global write
write:
 li a7, SYS_write
 578:	48c1                	li	a7,16
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <close>:
.global close
close:
 li a7, SYS_close
 580:	48d5                	li	a7,21
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <kill>:
.global kill
kill:
 li a7, SYS_kill
 588:	4899                	li	a7,6
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <exec>:
.global exec
exec:
 li a7, SYS_exec
 590:	489d                	li	a7,7
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <open>:
.global open
open:
 li a7, SYS_open
 598:	48bd                	li	a7,15
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a0:	48c5                	li	a7,17
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a8:	48c9                	li	a7,18
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b0:	48a1                	li	a7,8
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <link>:
.global link
link:
 li a7, SYS_link
 5b8:	48cd                	li	a7,19
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c0:	48d1                	li	a7,20
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c8:	48a5                	li	a7,9
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d0:	48a9                	li	a7,10
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d8:	48ad                	li	a7,11
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e0:	48b1                	li	a7,12
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e8:	48b5                	li	a7,13
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f0:	48b9                	li	a7,14
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <hello>:
.global hello
hello:
 li a7, SYS_hello
 5f8:	48d9                	li	a7,22
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 600:	48dd                	li	a7,23
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 608:	48e1                	li	a7,24
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 610:	1101                	addi	sp,sp,-32
 612:	ec06                	sd	ra,24(sp)
 614:	e822                	sd	s0,16(sp)
 616:	1000                	addi	s0,sp,32
 618:	87aa                	mv	a5,a0
 61a:	872e                	mv	a4,a1
 61c:	fef42623          	sw	a5,-20(s0)
 620:	87ba                	mv	a5,a4
 622:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 626:	feb40713          	addi	a4,s0,-21
 62a:	fec42783          	lw	a5,-20(s0)
 62e:	4605                	li	a2,1
 630:	85ba                	mv	a1,a4
 632:	853e                	mv	a0,a5
 634:	00000097          	auipc	ra,0x0
 638:	f44080e7          	jalr	-188(ra) # 578 <write>
}
 63c:	0001                	nop
 63e:	60e2                	ld	ra,24(sp)
 640:	6442                	ld	s0,16(sp)
 642:	6105                	addi	sp,sp,32
 644:	8082                	ret

0000000000000646 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 646:	7139                	addi	sp,sp,-64
 648:	fc06                	sd	ra,56(sp)
 64a:	f822                	sd	s0,48(sp)
 64c:	0080                	addi	s0,sp,64
 64e:	87aa                	mv	a5,a0
 650:	8736                	mv	a4,a3
 652:	fcf42623          	sw	a5,-52(s0)
 656:	87ae                	mv	a5,a1
 658:	fcf42423          	sw	a5,-56(s0)
 65c:	87b2                	mv	a5,a2
 65e:	fcf42223          	sw	a5,-60(s0)
 662:	87ba                	mv	a5,a4
 664:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 668:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 66c:	fc042783          	lw	a5,-64(s0)
 670:	2781                	sext.w	a5,a5
 672:	c38d                	beqz	a5,694 <printint+0x4e>
 674:	fc842783          	lw	a5,-56(s0)
 678:	2781                	sext.w	a5,a5
 67a:	0007dd63          	bgez	a5,694 <printint+0x4e>
    neg = 1;
 67e:	4785                	li	a5,1
 680:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 684:	fc842783          	lw	a5,-56(s0)
 688:	40f007bb          	negw	a5,a5
 68c:	2781                	sext.w	a5,a5
 68e:	fef42223          	sw	a5,-28(s0)
 692:	a029                	j	69c <printint+0x56>
  } else {
    x = xx;
 694:	fc842783          	lw	a5,-56(s0)
 698:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 69c:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 6a0:	fc442783          	lw	a5,-60(s0)
 6a4:	fe442703          	lw	a4,-28(s0)
 6a8:	02f777bb          	remuw	a5,a4,a5
 6ac:	0007861b          	sext.w	a2,a5
 6b0:	fec42783          	lw	a5,-20(s0)
 6b4:	0017871b          	addiw	a4,a5,1
 6b8:	fee42623          	sw	a4,-20(s0)
 6bc:	00001697          	auipc	a3,0x1
 6c0:	cb468693          	addi	a3,a3,-844 # 1370 <digits>
 6c4:	02061713          	slli	a4,a2,0x20
 6c8:	9301                	srli	a4,a4,0x20
 6ca:	9736                	add	a4,a4,a3
 6cc:	00074703          	lbu	a4,0(a4)
 6d0:	17c1                	addi	a5,a5,-16
 6d2:	97a2                	add	a5,a5,s0
 6d4:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6d8:	fc442783          	lw	a5,-60(s0)
 6dc:	fe442703          	lw	a4,-28(s0)
 6e0:	02f757bb          	divuw	a5,a4,a5
 6e4:	fef42223          	sw	a5,-28(s0)
 6e8:	fe442783          	lw	a5,-28(s0)
 6ec:	2781                	sext.w	a5,a5
 6ee:	fbcd                	bnez	a5,6a0 <printint+0x5a>
  if(neg)
 6f0:	fe842783          	lw	a5,-24(s0)
 6f4:	2781                	sext.w	a5,a5
 6f6:	cf85                	beqz	a5,72e <printint+0xe8>
    buf[i++] = '-';
 6f8:	fec42783          	lw	a5,-20(s0)
 6fc:	0017871b          	addiw	a4,a5,1
 700:	fee42623          	sw	a4,-20(s0)
 704:	17c1                	addi	a5,a5,-16
 706:	97a2                	add	a5,a5,s0
 708:	02d00713          	li	a4,45
 70c:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 710:	a839                	j	72e <printint+0xe8>
    putc(fd, buf[i]);
 712:	fec42783          	lw	a5,-20(s0)
 716:	17c1                	addi	a5,a5,-16
 718:	97a2                	add	a5,a5,s0
 71a:	fe07c703          	lbu	a4,-32(a5)
 71e:	fcc42783          	lw	a5,-52(s0)
 722:	85ba                	mv	a1,a4
 724:	853e                	mv	a0,a5
 726:	00000097          	auipc	ra,0x0
 72a:	eea080e7          	jalr	-278(ra) # 610 <putc>
  while(--i >= 0)
 72e:	fec42783          	lw	a5,-20(s0)
 732:	37fd                	addiw	a5,a5,-1
 734:	fef42623          	sw	a5,-20(s0)
 738:	fec42783          	lw	a5,-20(s0)
 73c:	2781                	sext.w	a5,a5
 73e:	fc07dae3          	bgez	a5,712 <printint+0xcc>
}
 742:	0001                	nop
 744:	0001                	nop
 746:	70e2                	ld	ra,56(sp)
 748:	7442                	ld	s0,48(sp)
 74a:	6121                	addi	sp,sp,64
 74c:	8082                	ret

000000000000074e <printptr>:

static void
printptr(int fd, uint64 x) {
 74e:	7179                	addi	sp,sp,-48
 750:	f406                	sd	ra,40(sp)
 752:	f022                	sd	s0,32(sp)
 754:	1800                	addi	s0,sp,48
 756:	87aa                	mv	a5,a0
 758:	fcb43823          	sd	a1,-48(s0)
 75c:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 760:	fdc42783          	lw	a5,-36(s0)
 764:	03000593          	li	a1,48
 768:	853e                	mv	a0,a5
 76a:	00000097          	auipc	ra,0x0
 76e:	ea6080e7          	jalr	-346(ra) # 610 <putc>
  putc(fd, 'x');
 772:	fdc42783          	lw	a5,-36(s0)
 776:	07800593          	li	a1,120
 77a:	853e                	mv	a0,a5
 77c:	00000097          	auipc	ra,0x0
 780:	e94080e7          	jalr	-364(ra) # 610 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 784:	fe042623          	sw	zero,-20(s0)
 788:	a82d                	j	7c2 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78a:	fd043783          	ld	a5,-48(s0)
 78e:	93f1                	srli	a5,a5,0x3c
 790:	00001717          	auipc	a4,0x1
 794:	be070713          	addi	a4,a4,-1056 # 1370 <digits>
 798:	97ba                	add	a5,a5,a4
 79a:	0007c703          	lbu	a4,0(a5)
 79e:	fdc42783          	lw	a5,-36(s0)
 7a2:	85ba                	mv	a1,a4
 7a4:	853e                	mv	a0,a5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e6a080e7          	jalr	-406(ra) # 610 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ae:	fec42783          	lw	a5,-20(s0)
 7b2:	2785                	addiw	a5,a5,1
 7b4:	fef42623          	sw	a5,-20(s0)
 7b8:	fd043783          	ld	a5,-48(s0)
 7bc:	0792                	slli	a5,a5,0x4
 7be:	fcf43823          	sd	a5,-48(s0)
 7c2:	fec42783          	lw	a5,-20(s0)
 7c6:	873e                	mv	a4,a5
 7c8:	47bd                	li	a5,15
 7ca:	fce7f0e3          	bgeu	a5,a4,78a <printptr+0x3c>
}
 7ce:	0001                	nop
 7d0:	0001                	nop
 7d2:	70a2                	ld	ra,40(sp)
 7d4:	7402                	ld	s0,32(sp)
 7d6:	6145                	addi	sp,sp,48
 7d8:	8082                	ret

00000000000007da <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7da:	715d                	addi	sp,sp,-80
 7dc:	e486                	sd	ra,72(sp)
 7de:	e0a2                	sd	s0,64(sp)
 7e0:	0880                	addi	s0,sp,80
 7e2:	87aa                	mv	a5,a0
 7e4:	fcb43023          	sd	a1,-64(s0)
 7e8:	fac43c23          	sd	a2,-72(s0)
 7ec:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7f0:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7f4:	fe042223          	sw	zero,-28(s0)
 7f8:	a42d                	j	a22 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7fa:	fe442783          	lw	a5,-28(s0)
 7fe:	fc043703          	ld	a4,-64(s0)
 802:	97ba                	add	a5,a5,a4
 804:	0007c783          	lbu	a5,0(a5)
 808:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 80c:	fe042783          	lw	a5,-32(s0)
 810:	2781                	sext.w	a5,a5
 812:	eb9d                	bnez	a5,848 <vprintf+0x6e>
      if(c == '%'){
 814:	fdc42783          	lw	a5,-36(s0)
 818:	0007871b          	sext.w	a4,a5
 81c:	02500793          	li	a5,37
 820:	00f71763          	bne	a4,a5,82e <vprintf+0x54>
        state = '%';
 824:	02500793          	li	a5,37
 828:	fef42023          	sw	a5,-32(s0)
 82c:	a2f5                	j	a18 <vprintf+0x23e>
      } else {
        putc(fd, c);
 82e:	fdc42783          	lw	a5,-36(s0)
 832:	0ff7f713          	zext.b	a4,a5
 836:	fcc42783          	lw	a5,-52(s0)
 83a:	85ba                	mv	a1,a4
 83c:	853e                	mv	a0,a5
 83e:	00000097          	auipc	ra,0x0
 842:	dd2080e7          	jalr	-558(ra) # 610 <putc>
 846:	aac9                	j	a18 <vprintf+0x23e>
      }
    } else if(state == '%'){
 848:	fe042783          	lw	a5,-32(s0)
 84c:	0007871b          	sext.w	a4,a5
 850:	02500793          	li	a5,37
 854:	1cf71263          	bne	a4,a5,a18 <vprintf+0x23e>
      if(c == 'd'){
 858:	fdc42783          	lw	a5,-36(s0)
 85c:	0007871b          	sext.w	a4,a5
 860:	06400793          	li	a5,100
 864:	02f71463          	bne	a4,a5,88c <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 868:	fb843783          	ld	a5,-72(s0)
 86c:	00878713          	addi	a4,a5,8
 870:	fae43c23          	sd	a4,-72(s0)
 874:	4398                	lw	a4,0(a5)
 876:	fcc42783          	lw	a5,-52(s0)
 87a:	4685                	li	a3,1
 87c:	4629                	li	a2,10
 87e:	85ba                	mv	a1,a4
 880:	853e                	mv	a0,a5
 882:	00000097          	auipc	ra,0x0
 886:	dc4080e7          	jalr	-572(ra) # 646 <printint>
 88a:	a269                	j	a14 <vprintf+0x23a>
      } else if(c == 'l') {
 88c:	fdc42783          	lw	a5,-36(s0)
 890:	0007871b          	sext.w	a4,a5
 894:	06c00793          	li	a5,108
 898:	02f71663          	bne	a4,a5,8c4 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89c:	fb843783          	ld	a5,-72(s0)
 8a0:	00878713          	addi	a4,a5,8
 8a4:	fae43c23          	sd	a4,-72(s0)
 8a8:	639c                	ld	a5,0(a5)
 8aa:	0007871b          	sext.w	a4,a5
 8ae:	fcc42783          	lw	a5,-52(s0)
 8b2:	4681                	li	a3,0
 8b4:	4629                	li	a2,10
 8b6:	85ba                	mv	a1,a4
 8b8:	853e                	mv	a0,a5
 8ba:	00000097          	auipc	ra,0x0
 8be:	d8c080e7          	jalr	-628(ra) # 646 <printint>
 8c2:	aa89                	j	a14 <vprintf+0x23a>
      } else if(c == 'x') {
 8c4:	fdc42783          	lw	a5,-36(s0)
 8c8:	0007871b          	sext.w	a4,a5
 8cc:	07800793          	li	a5,120
 8d0:	02f71463          	bne	a4,a5,8f8 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8d4:	fb843783          	ld	a5,-72(s0)
 8d8:	00878713          	addi	a4,a5,8
 8dc:	fae43c23          	sd	a4,-72(s0)
 8e0:	4398                	lw	a4,0(a5)
 8e2:	fcc42783          	lw	a5,-52(s0)
 8e6:	4681                	li	a3,0
 8e8:	4641                	li	a2,16
 8ea:	85ba                	mv	a1,a4
 8ec:	853e                	mv	a0,a5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	d58080e7          	jalr	-680(ra) # 646 <printint>
 8f6:	aa39                	j	a14 <vprintf+0x23a>
      } else if(c == 'p') {
 8f8:	fdc42783          	lw	a5,-36(s0)
 8fc:	0007871b          	sext.w	a4,a5
 900:	07000793          	li	a5,112
 904:	02f71263          	bne	a4,a5,928 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 908:	fb843783          	ld	a5,-72(s0)
 90c:	00878713          	addi	a4,a5,8
 910:	fae43c23          	sd	a4,-72(s0)
 914:	6398                	ld	a4,0(a5)
 916:	fcc42783          	lw	a5,-52(s0)
 91a:	85ba                	mv	a1,a4
 91c:	853e                	mv	a0,a5
 91e:	00000097          	auipc	ra,0x0
 922:	e30080e7          	jalr	-464(ra) # 74e <printptr>
 926:	a0fd                	j	a14 <vprintf+0x23a>
      } else if(c == 's'){
 928:	fdc42783          	lw	a5,-36(s0)
 92c:	0007871b          	sext.w	a4,a5
 930:	07300793          	li	a5,115
 934:	04f71c63          	bne	a4,a5,98c <vprintf+0x1b2>
        s = va_arg(ap, char*);
 938:	fb843783          	ld	a5,-72(s0)
 93c:	00878713          	addi	a4,a5,8
 940:	fae43c23          	sd	a4,-72(s0)
 944:	639c                	ld	a5,0(a5)
 946:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 94a:	fe843783          	ld	a5,-24(s0)
 94e:	eb8d                	bnez	a5,980 <vprintf+0x1a6>
          s = "(null)";
 950:	00000797          	auipc	a5,0x0
 954:	4b878793          	addi	a5,a5,1208 # e08 <malloc+0x17e>
 958:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 95c:	a015                	j	980 <vprintf+0x1a6>
          putc(fd, *s);
 95e:	fe843783          	ld	a5,-24(s0)
 962:	0007c703          	lbu	a4,0(a5)
 966:	fcc42783          	lw	a5,-52(s0)
 96a:	85ba                	mv	a1,a4
 96c:	853e                	mv	a0,a5
 96e:	00000097          	auipc	ra,0x0
 972:	ca2080e7          	jalr	-862(ra) # 610 <putc>
          s++;
 976:	fe843783          	ld	a5,-24(s0)
 97a:	0785                	addi	a5,a5,1
 97c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 980:	fe843783          	ld	a5,-24(s0)
 984:	0007c783          	lbu	a5,0(a5)
 988:	fbf9                	bnez	a5,95e <vprintf+0x184>
 98a:	a069                	j	a14 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 98c:	fdc42783          	lw	a5,-36(s0)
 990:	0007871b          	sext.w	a4,a5
 994:	06300793          	li	a5,99
 998:	02f71463          	bne	a4,a5,9c0 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 99c:	fb843783          	ld	a5,-72(s0)
 9a0:	00878713          	addi	a4,a5,8
 9a4:	fae43c23          	sd	a4,-72(s0)
 9a8:	439c                	lw	a5,0(a5)
 9aa:	0ff7f713          	zext.b	a4,a5
 9ae:	fcc42783          	lw	a5,-52(s0)
 9b2:	85ba                	mv	a1,a4
 9b4:	853e                	mv	a0,a5
 9b6:	00000097          	auipc	ra,0x0
 9ba:	c5a080e7          	jalr	-934(ra) # 610 <putc>
 9be:	a899                	j	a14 <vprintf+0x23a>
      } else if(c == '%'){
 9c0:	fdc42783          	lw	a5,-36(s0)
 9c4:	0007871b          	sext.w	a4,a5
 9c8:	02500793          	li	a5,37
 9cc:	00f71f63          	bne	a4,a5,9ea <vprintf+0x210>
        putc(fd, c);
 9d0:	fdc42783          	lw	a5,-36(s0)
 9d4:	0ff7f713          	zext.b	a4,a5
 9d8:	fcc42783          	lw	a5,-52(s0)
 9dc:	85ba                	mv	a1,a4
 9de:	853e                	mv	a0,a5
 9e0:	00000097          	auipc	ra,0x0
 9e4:	c30080e7          	jalr	-976(ra) # 610 <putc>
 9e8:	a035                	j	a14 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9ea:	fcc42783          	lw	a5,-52(s0)
 9ee:	02500593          	li	a1,37
 9f2:	853e                	mv	a0,a5
 9f4:	00000097          	auipc	ra,0x0
 9f8:	c1c080e7          	jalr	-996(ra) # 610 <putc>
        putc(fd, c);
 9fc:	fdc42783          	lw	a5,-36(s0)
 a00:	0ff7f713          	zext.b	a4,a5
 a04:	fcc42783          	lw	a5,-52(s0)
 a08:	85ba                	mv	a1,a4
 a0a:	853e                	mv	a0,a5
 a0c:	00000097          	auipc	ra,0x0
 a10:	c04080e7          	jalr	-1020(ra) # 610 <putc>
      }
      state = 0;
 a14:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a18:	fe442783          	lw	a5,-28(s0)
 a1c:	2785                	addiw	a5,a5,1
 a1e:	fef42223          	sw	a5,-28(s0)
 a22:	fe442783          	lw	a5,-28(s0)
 a26:	fc043703          	ld	a4,-64(s0)
 a2a:	97ba                	add	a5,a5,a4
 a2c:	0007c783          	lbu	a5,0(a5)
 a30:	dc0795e3          	bnez	a5,7fa <vprintf+0x20>
    }
  }
}
 a34:	0001                	nop
 a36:	0001                	nop
 a38:	60a6                	ld	ra,72(sp)
 a3a:	6406                	ld	s0,64(sp)
 a3c:	6161                	addi	sp,sp,80
 a3e:	8082                	ret

0000000000000a40 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a40:	7159                	addi	sp,sp,-112
 a42:	fc06                	sd	ra,56(sp)
 a44:	f822                	sd	s0,48(sp)
 a46:	0080                	addi	s0,sp,64
 a48:	fcb43823          	sd	a1,-48(s0)
 a4c:	e010                	sd	a2,0(s0)
 a4e:	e414                	sd	a3,8(s0)
 a50:	e818                	sd	a4,16(s0)
 a52:	ec1c                	sd	a5,24(s0)
 a54:	03043023          	sd	a6,32(s0)
 a58:	03143423          	sd	a7,40(s0)
 a5c:	87aa                	mv	a5,a0
 a5e:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a62:	03040793          	addi	a5,s0,48
 a66:	fcf43423          	sd	a5,-56(s0)
 a6a:	fc843783          	ld	a5,-56(s0)
 a6e:	fd078793          	addi	a5,a5,-48
 a72:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a76:	fe843703          	ld	a4,-24(s0)
 a7a:	fdc42783          	lw	a5,-36(s0)
 a7e:	863a                	mv	a2,a4
 a80:	fd043583          	ld	a1,-48(s0)
 a84:	853e                	mv	a0,a5
 a86:	00000097          	auipc	ra,0x0
 a8a:	d54080e7          	jalr	-684(ra) # 7da <vprintf>
}
 a8e:	0001                	nop
 a90:	70e2                	ld	ra,56(sp)
 a92:	7442                	ld	s0,48(sp)
 a94:	6165                	addi	sp,sp,112
 a96:	8082                	ret

0000000000000a98 <printf>:

void
printf(const char *fmt, ...)
{
 a98:	7159                	addi	sp,sp,-112
 a9a:	f406                	sd	ra,40(sp)
 a9c:	f022                	sd	s0,32(sp)
 a9e:	1800                	addi	s0,sp,48
 aa0:	fca43c23          	sd	a0,-40(s0)
 aa4:	e40c                	sd	a1,8(s0)
 aa6:	e810                	sd	a2,16(s0)
 aa8:	ec14                	sd	a3,24(s0)
 aaa:	f018                	sd	a4,32(s0)
 aac:	f41c                	sd	a5,40(s0)
 aae:	03043823          	sd	a6,48(s0)
 ab2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ab6:	04040793          	addi	a5,s0,64
 aba:	fcf43823          	sd	a5,-48(s0)
 abe:	fd043783          	ld	a5,-48(s0)
 ac2:	fc878793          	addi	a5,a5,-56
 ac6:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 aca:	fe843783          	ld	a5,-24(s0)
 ace:	863e                	mv	a2,a5
 ad0:	fd843583          	ld	a1,-40(s0)
 ad4:	4505                	li	a0,1
 ad6:	00000097          	auipc	ra,0x0
 ada:	d04080e7          	jalr	-764(ra) # 7da <vprintf>
}
 ade:	0001                	nop
 ae0:	70a2                	ld	ra,40(sp)
 ae2:	7402                	ld	s0,32(sp)
 ae4:	6165                	addi	sp,sp,112
 ae6:	8082                	ret

0000000000000ae8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae8:	7179                	addi	sp,sp,-48
 aea:	f422                	sd	s0,40(sp)
 aec:	1800                	addi	s0,sp,48
 aee:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 af2:	fd843783          	ld	a5,-40(s0)
 af6:	17c1                	addi	a5,a5,-16
 af8:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afc:	00001797          	auipc	a5,0x1
 b00:	8a478793          	addi	a5,a5,-1884 # 13a0 <freep>
 b04:	639c                	ld	a5,0(a5)
 b06:	fef43423          	sd	a5,-24(s0)
 b0a:	a815                	j	b3e <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	639c                	ld	a5,0(a5)
 b12:	fe843703          	ld	a4,-24(s0)
 b16:	00f76f63          	bltu	a4,a5,b34 <free+0x4c>
 b1a:	fe043703          	ld	a4,-32(s0)
 b1e:	fe843783          	ld	a5,-24(s0)
 b22:	02e7eb63          	bltu	a5,a4,b58 <free+0x70>
 b26:	fe843783          	ld	a5,-24(s0)
 b2a:	639c                	ld	a5,0(a5)
 b2c:	fe043703          	ld	a4,-32(s0)
 b30:	02f76463          	bltu	a4,a5,b58 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b34:	fe843783          	ld	a5,-24(s0)
 b38:	639c                	ld	a5,0(a5)
 b3a:	fef43423          	sd	a5,-24(s0)
 b3e:	fe043703          	ld	a4,-32(s0)
 b42:	fe843783          	ld	a5,-24(s0)
 b46:	fce7f3e3          	bgeu	a5,a4,b0c <free+0x24>
 b4a:	fe843783          	ld	a5,-24(s0)
 b4e:	639c                	ld	a5,0(a5)
 b50:	fe043703          	ld	a4,-32(s0)
 b54:	faf77ce3          	bgeu	a4,a5,b0c <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b58:	fe043783          	ld	a5,-32(s0)
 b5c:	479c                	lw	a5,8(a5)
 b5e:	1782                	slli	a5,a5,0x20
 b60:	9381                	srli	a5,a5,0x20
 b62:	0792                	slli	a5,a5,0x4
 b64:	fe043703          	ld	a4,-32(s0)
 b68:	973e                	add	a4,a4,a5
 b6a:	fe843783          	ld	a5,-24(s0)
 b6e:	639c                	ld	a5,0(a5)
 b70:	02f71763          	bne	a4,a5,b9e <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b74:	fe043783          	ld	a5,-32(s0)
 b78:	4798                	lw	a4,8(a5)
 b7a:	fe843783          	ld	a5,-24(s0)
 b7e:	639c                	ld	a5,0(a5)
 b80:	479c                	lw	a5,8(a5)
 b82:	9fb9                	addw	a5,a5,a4
 b84:	0007871b          	sext.w	a4,a5
 b88:	fe043783          	ld	a5,-32(s0)
 b8c:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b8e:	fe843783          	ld	a5,-24(s0)
 b92:	639c                	ld	a5,0(a5)
 b94:	6398                	ld	a4,0(a5)
 b96:	fe043783          	ld	a5,-32(s0)
 b9a:	e398                	sd	a4,0(a5)
 b9c:	a039                	j	baa <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b9e:	fe843783          	ld	a5,-24(s0)
 ba2:	6398                	ld	a4,0(a5)
 ba4:	fe043783          	ld	a5,-32(s0)
 ba8:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 baa:	fe843783          	ld	a5,-24(s0)
 bae:	479c                	lw	a5,8(a5)
 bb0:	1782                	slli	a5,a5,0x20
 bb2:	9381                	srli	a5,a5,0x20
 bb4:	0792                	slli	a5,a5,0x4
 bb6:	fe843703          	ld	a4,-24(s0)
 bba:	97ba                	add	a5,a5,a4
 bbc:	fe043703          	ld	a4,-32(s0)
 bc0:	02f71563          	bne	a4,a5,bea <free+0x102>
    p->s.size += bp->s.size;
 bc4:	fe843783          	ld	a5,-24(s0)
 bc8:	4798                	lw	a4,8(a5)
 bca:	fe043783          	ld	a5,-32(s0)
 bce:	479c                	lw	a5,8(a5)
 bd0:	9fb9                	addw	a5,a5,a4
 bd2:	0007871b          	sext.w	a4,a5
 bd6:	fe843783          	ld	a5,-24(s0)
 bda:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bdc:	fe043783          	ld	a5,-32(s0)
 be0:	6398                	ld	a4,0(a5)
 be2:	fe843783          	ld	a5,-24(s0)
 be6:	e398                	sd	a4,0(a5)
 be8:	a031                	j	bf4 <free+0x10c>
  } else
    p->s.ptr = bp;
 bea:	fe843783          	ld	a5,-24(s0)
 bee:	fe043703          	ld	a4,-32(s0)
 bf2:	e398                	sd	a4,0(a5)
  freep = p;
 bf4:	00000797          	auipc	a5,0x0
 bf8:	7ac78793          	addi	a5,a5,1964 # 13a0 <freep>
 bfc:	fe843703          	ld	a4,-24(s0)
 c00:	e398                	sd	a4,0(a5)
}
 c02:	0001                	nop
 c04:	7422                	ld	s0,40(sp)
 c06:	6145                	addi	sp,sp,48
 c08:	8082                	ret

0000000000000c0a <morecore>:

static Header*
morecore(uint nu)
{
 c0a:	7179                	addi	sp,sp,-48
 c0c:	f406                	sd	ra,40(sp)
 c0e:	f022                	sd	s0,32(sp)
 c10:	1800                	addi	s0,sp,48
 c12:	87aa                	mv	a5,a0
 c14:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c18:	fdc42783          	lw	a5,-36(s0)
 c1c:	0007871b          	sext.w	a4,a5
 c20:	6785                	lui	a5,0x1
 c22:	00f77563          	bgeu	a4,a5,c2c <morecore+0x22>
    nu = 4096;
 c26:	6785                	lui	a5,0x1
 c28:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c2c:	fdc42783          	lw	a5,-36(s0)
 c30:	0047979b          	slliw	a5,a5,0x4
 c34:	2781                	sext.w	a5,a5
 c36:	2781                	sext.w	a5,a5
 c38:	853e                	mv	a0,a5
 c3a:	00000097          	auipc	ra,0x0
 c3e:	9a6080e7          	jalr	-1626(ra) # 5e0 <sbrk>
 c42:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c46:	fe843703          	ld	a4,-24(s0)
 c4a:	57fd                	li	a5,-1
 c4c:	00f71463          	bne	a4,a5,c54 <morecore+0x4a>
    return 0;
 c50:	4781                	li	a5,0
 c52:	a03d                	j	c80 <morecore+0x76>
  hp = (Header*)p;
 c54:	fe843783          	ld	a5,-24(s0)
 c58:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c5c:	fe043783          	ld	a5,-32(s0)
 c60:	fdc42703          	lw	a4,-36(s0)
 c64:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c66:	fe043783          	ld	a5,-32(s0)
 c6a:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x386>
 c6c:	853e                	mv	a0,a5
 c6e:	00000097          	auipc	ra,0x0
 c72:	e7a080e7          	jalr	-390(ra) # ae8 <free>
  return freep;
 c76:	00000797          	auipc	a5,0x0
 c7a:	72a78793          	addi	a5,a5,1834 # 13a0 <freep>
 c7e:	639c                	ld	a5,0(a5)
}
 c80:	853e                	mv	a0,a5
 c82:	70a2                	ld	ra,40(sp)
 c84:	7402                	ld	s0,32(sp)
 c86:	6145                	addi	sp,sp,48
 c88:	8082                	ret

0000000000000c8a <malloc>:

void*
malloc(uint nbytes)
{
 c8a:	7139                	addi	sp,sp,-64
 c8c:	fc06                	sd	ra,56(sp)
 c8e:	f822                	sd	s0,48(sp)
 c90:	0080                	addi	s0,sp,64
 c92:	87aa                	mv	a5,a0
 c94:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c98:	fcc46783          	lwu	a5,-52(s0)
 c9c:	07bd                	addi	a5,a5,15
 c9e:	8391                	srli	a5,a5,0x4
 ca0:	2781                	sext.w	a5,a5
 ca2:	2785                	addiw	a5,a5,1
 ca4:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 ca8:	00000797          	auipc	a5,0x0
 cac:	6f878793          	addi	a5,a5,1784 # 13a0 <freep>
 cb0:	639c                	ld	a5,0(a5)
 cb2:	fef43023          	sd	a5,-32(s0)
 cb6:	fe043783          	ld	a5,-32(s0)
 cba:	ef95                	bnez	a5,cf6 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cbc:	00000797          	auipc	a5,0x0
 cc0:	6d478793          	addi	a5,a5,1748 # 1390 <base>
 cc4:	fef43023          	sd	a5,-32(s0)
 cc8:	00000797          	auipc	a5,0x0
 ccc:	6d878793          	addi	a5,a5,1752 # 13a0 <freep>
 cd0:	fe043703          	ld	a4,-32(s0)
 cd4:	e398                	sd	a4,0(a5)
 cd6:	00000797          	auipc	a5,0x0
 cda:	6ca78793          	addi	a5,a5,1738 # 13a0 <freep>
 cde:	6398                	ld	a4,0(a5)
 ce0:	00000797          	auipc	a5,0x0
 ce4:	6b078793          	addi	a5,a5,1712 # 1390 <base>
 ce8:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cea:	00000797          	auipc	a5,0x0
 cee:	6a678793          	addi	a5,a5,1702 # 1390 <base>
 cf2:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cf6:	fe043783          	ld	a5,-32(s0)
 cfa:	639c                	ld	a5,0(a5)
 cfc:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d00:	fe843783          	ld	a5,-24(s0)
 d04:	4798                	lw	a4,8(a5)
 d06:	fdc42783          	lw	a5,-36(s0)
 d0a:	2781                	sext.w	a5,a5
 d0c:	06f76763          	bltu	a4,a5,d7a <malloc+0xf0>
      if(p->s.size == nunits)
 d10:	fe843783          	ld	a5,-24(s0)
 d14:	4798                	lw	a4,8(a5)
 d16:	fdc42783          	lw	a5,-36(s0)
 d1a:	2781                	sext.w	a5,a5
 d1c:	00e79963          	bne	a5,a4,d2e <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d20:	fe843783          	ld	a5,-24(s0)
 d24:	6398                	ld	a4,0(a5)
 d26:	fe043783          	ld	a5,-32(s0)
 d2a:	e398                	sd	a4,0(a5)
 d2c:	a825                	j	d64 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d2e:	fe843783          	ld	a5,-24(s0)
 d32:	479c                	lw	a5,8(a5)
 d34:	fdc42703          	lw	a4,-36(s0)
 d38:	9f99                	subw	a5,a5,a4
 d3a:	0007871b          	sext.w	a4,a5
 d3e:	fe843783          	ld	a5,-24(s0)
 d42:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d44:	fe843783          	ld	a5,-24(s0)
 d48:	479c                	lw	a5,8(a5)
 d4a:	1782                	slli	a5,a5,0x20
 d4c:	9381                	srli	a5,a5,0x20
 d4e:	0792                	slli	a5,a5,0x4
 d50:	fe843703          	ld	a4,-24(s0)
 d54:	97ba                	add	a5,a5,a4
 d56:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d5a:	fe843783          	ld	a5,-24(s0)
 d5e:	fdc42703          	lw	a4,-36(s0)
 d62:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d64:	00000797          	auipc	a5,0x0
 d68:	63c78793          	addi	a5,a5,1596 # 13a0 <freep>
 d6c:	fe043703          	ld	a4,-32(s0)
 d70:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d72:	fe843783          	ld	a5,-24(s0)
 d76:	07c1                	addi	a5,a5,16
 d78:	a091                	j	dbc <malloc+0x132>
    }
    if(p == freep)
 d7a:	00000797          	auipc	a5,0x0
 d7e:	62678793          	addi	a5,a5,1574 # 13a0 <freep>
 d82:	639c                	ld	a5,0(a5)
 d84:	fe843703          	ld	a4,-24(s0)
 d88:	02f71063          	bne	a4,a5,da8 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d8c:	fdc42783          	lw	a5,-36(s0)
 d90:	853e                	mv	a0,a5
 d92:	00000097          	auipc	ra,0x0
 d96:	e78080e7          	jalr	-392(ra) # c0a <morecore>
 d9a:	fea43423          	sd	a0,-24(s0)
 d9e:	fe843783          	ld	a5,-24(s0)
 da2:	e399                	bnez	a5,da8 <malloc+0x11e>
        return 0;
 da4:	4781                	li	a5,0
 da6:	a819                	j	dbc <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 da8:	fe843783          	ld	a5,-24(s0)
 dac:	fef43023          	sd	a5,-32(s0)
 db0:	fe843783          	ld	a5,-24(s0)
 db4:	639c                	ld	a5,0(a5)
 db6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dba:	b799                	j	d00 <malloc+0x76>
  }
}
 dbc:	853e                	mv	a0,a5
 dbe:	70e2                	ld	ra,56(sp)
 dc0:	7442                	ld	s0,48(sp)
 dc2:	6121                	addi	sp,sp,64
 dc4:	8082                	ret
