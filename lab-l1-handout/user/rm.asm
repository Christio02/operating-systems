
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
  24:	da058593          	addi	a1,a1,-608 # dc0 <malloc+0x13e>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	a0e080e7          	jalr	-1522(ra) # a38 <fprintf>
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
  76:	d6658593          	addi	a1,a1,-666 # dd8 <malloc+0x156>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9bc080e7          	jalr	-1604(ra) # a38 <fprintf>
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

0000000000000608 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 608:	1101                	addi	sp,sp,-32
 60a:	ec06                	sd	ra,24(sp)
 60c:	e822                	sd	s0,16(sp)
 60e:	1000                	addi	s0,sp,32
 610:	87aa                	mv	a5,a0
 612:	872e                	mv	a4,a1
 614:	fef42623          	sw	a5,-20(s0)
 618:	87ba                	mv	a5,a4
 61a:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 61e:	feb40713          	addi	a4,s0,-21
 622:	fec42783          	lw	a5,-20(s0)
 626:	4605                	li	a2,1
 628:	85ba                	mv	a1,a4
 62a:	853e                	mv	a0,a5
 62c:	00000097          	auipc	ra,0x0
 630:	f4c080e7          	jalr	-180(ra) # 578 <write>
}
 634:	0001                	nop
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	6105                	addi	sp,sp,32
 63c:	8082                	ret

000000000000063e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63e:	7139                	addi	sp,sp,-64
 640:	fc06                	sd	ra,56(sp)
 642:	f822                	sd	s0,48(sp)
 644:	0080                	addi	s0,sp,64
 646:	87aa                	mv	a5,a0
 648:	8736                	mv	a4,a3
 64a:	fcf42623          	sw	a5,-52(s0)
 64e:	87ae                	mv	a5,a1
 650:	fcf42423          	sw	a5,-56(s0)
 654:	87b2                	mv	a5,a2
 656:	fcf42223          	sw	a5,-60(s0)
 65a:	87ba                	mv	a5,a4
 65c:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 660:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 664:	fc042783          	lw	a5,-64(s0)
 668:	2781                	sext.w	a5,a5
 66a:	c38d                	beqz	a5,68c <printint+0x4e>
 66c:	fc842783          	lw	a5,-56(s0)
 670:	2781                	sext.w	a5,a5
 672:	0007dd63          	bgez	a5,68c <printint+0x4e>
    neg = 1;
 676:	4785                	li	a5,1
 678:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 67c:	fc842783          	lw	a5,-56(s0)
 680:	40f007bb          	negw	a5,a5
 684:	2781                	sext.w	a5,a5
 686:	fef42223          	sw	a5,-28(s0)
 68a:	a029                	j	694 <printint+0x56>
  } else {
    x = xx;
 68c:	fc842783          	lw	a5,-56(s0)
 690:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 694:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 698:	fc442783          	lw	a5,-60(s0)
 69c:	fe442703          	lw	a4,-28(s0)
 6a0:	02f777bb          	remuw	a5,a4,a5
 6a4:	0007861b          	sext.w	a2,a5
 6a8:	fec42783          	lw	a5,-20(s0)
 6ac:	0017871b          	addiw	a4,a5,1
 6b0:	fee42623          	sw	a4,-20(s0)
 6b4:	00001697          	auipc	a3,0x1
 6b8:	cbc68693          	addi	a3,a3,-836 # 1370 <digits>
 6bc:	02061713          	slli	a4,a2,0x20
 6c0:	9301                	srli	a4,a4,0x20
 6c2:	9736                	add	a4,a4,a3
 6c4:	00074703          	lbu	a4,0(a4)
 6c8:	17c1                	addi	a5,a5,-16
 6ca:	97a2                	add	a5,a5,s0
 6cc:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6d0:	fc442783          	lw	a5,-60(s0)
 6d4:	fe442703          	lw	a4,-28(s0)
 6d8:	02f757bb          	divuw	a5,a4,a5
 6dc:	fef42223          	sw	a5,-28(s0)
 6e0:	fe442783          	lw	a5,-28(s0)
 6e4:	2781                	sext.w	a5,a5
 6e6:	fbcd                	bnez	a5,698 <printint+0x5a>
  if(neg)
 6e8:	fe842783          	lw	a5,-24(s0)
 6ec:	2781                	sext.w	a5,a5
 6ee:	cf85                	beqz	a5,726 <printint+0xe8>
    buf[i++] = '-';
 6f0:	fec42783          	lw	a5,-20(s0)
 6f4:	0017871b          	addiw	a4,a5,1
 6f8:	fee42623          	sw	a4,-20(s0)
 6fc:	17c1                	addi	a5,a5,-16
 6fe:	97a2                	add	a5,a5,s0
 700:	02d00713          	li	a4,45
 704:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 708:	a839                	j	726 <printint+0xe8>
    putc(fd, buf[i]);
 70a:	fec42783          	lw	a5,-20(s0)
 70e:	17c1                	addi	a5,a5,-16
 710:	97a2                	add	a5,a5,s0
 712:	fe07c703          	lbu	a4,-32(a5)
 716:	fcc42783          	lw	a5,-52(s0)
 71a:	85ba                	mv	a1,a4
 71c:	853e                	mv	a0,a5
 71e:	00000097          	auipc	ra,0x0
 722:	eea080e7          	jalr	-278(ra) # 608 <putc>
  while(--i >= 0)
 726:	fec42783          	lw	a5,-20(s0)
 72a:	37fd                	addiw	a5,a5,-1
 72c:	fef42623          	sw	a5,-20(s0)
 730:	fec42783          	lw	a5,-20(s0)
 734:	2781                	sext.w	a5,a5
 736:	fc07dae3          	bgez	a5,70a <printint+0xcc>
}
 73a:	0001                	nop
 73c:	0001                	nop
 73e:	70e2                	ld	ra,56(sp)
 740:	7442                	ld	s0,48(sp)
 742:	6121                	addi	sp,sp,64
 744:	8082                	ret

0000000000000746 <printptr>:

static void
printptr(int fd, uint64 x) {
 746:	7179                	addi	sp,sp,-48
 748:	f406                	sd	ra,40(sp)
 74a:	f022                	sd	s0,32(sp)
 74c:	1800                	addi	s0,sp,48
 74e:	87aa                	mv	a5,a0
 750:	fcb43823          	sd	a1,-48(s0)
 754:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 758:	fdc42783          	lw	a5,-36(s0)
 75c:	03000593          	li	a1,48
 760:	853e                	mv	a0,a5
 762:	00000097          	auipc	ra,0x0
 766:	ea6080e7          	jalr	-346(ra) # 608 <putc>
  putc(fd, 'x');
 76a:	fdc42783          	lw	a5,-36(s0)
 76e:	07800593          	li	a1,120
 772:	853e                	mv	a0,a5
 774:	00000097          	auipc	ra,0x0
 778:	e94080e7          	jalr	-364(ra) # 608 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77c:	fe042623          	sw	zero,-20(s0)
 780:	a82d                	j	7ba <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 782:	fd043783          	ld	a5,-48(s0)
 786:	93f1                	srli	a5,a5,0x3c
 788:	00001717          	auipc	a4,0x1
 78c:	be870713          	addi	a4,a4,-1048 # 1370 <digits>
 790:	97ba                	add	a5,a5,a4
 792:	0007c703          	lbu	a4,0(a5)
 796:	fdc42783          	lw	a5,-36(s0)
 79a:	85ba                	mv	a1,a4
 79c:	853e                	mv	a0,a5
 79e:	00000097          	auipc	ra,0x0
 7a2:	e6a080e7          	jalr	-406(ra) # 608 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a6:	fec42783          	lw	a5,-20(s0)
 7aa:	2785                	addiw	a5,a5,1
 7ac:	fef42623          	sw	a5,-20(s0)
 7b0:	fd043783          	ld	a5,-48(s0)
 7b4:	0792                	slli	a5,a5,0x4
 7b6:	fcf43823          	sd	a5,-48(s0)
 7ba:	fec42783          	lw	a5,-20(s0)
 7be:	873e                	mv	a4,a5
 7c0:	47bd                	li	a5,15
 7c2:	fce7f0e3          	bgeu	a5,a4,782 <printptr+0x3c>
}
 7c6:	0001                	nop
 7c8:	0001                	nop
 7ca:	70a2                	ld	ra,40(sp)
 7cc:	7402                	ld	s0,32(sp)
 7ce:	6145                	addi	sp,sp,48
 7d0:	8082                	ret

00000000000007d2 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7d2:	715d                	addi	sp,sp,-80
 7d4:	e486                	sd	ra,72(sp)
 7d6:	e0a2                	sd	s0,64(sp)
 7d8:	0880                	addi	s0,sp,80
 7da:	87aa                	mv	a5,a0
 7dc:	fcb43023          	sd	a1,-64(s0)
 7e0:	fac43c23          	sd	a2,-72(s0)
 7e4:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7e8:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7ec:	fe042223          	sw	zero,-28(s0)
 7f0:	a42d                	j	a1a <vprintf+0x248>
    c = fmt[i] & 0xff;
 7f2:	fe442783          	lw	a5,-28(s0)
 7f6:	fc043703          	ld	a4,-64(s0)
 7fa:	97ba                	add	a5,a5,a4
 7fc:	0007c783          	lbu	a5,0(a5)
 800:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 804:	fe042783          	lw	a5,-32(s0)
 808:	2781                	sext.w	a5,a5
 80a:	eb9d                	bnez	a5,840 <vprintf+0x6e>
      if(c == '%'){
 80c:	fdc42783          	lw	a5,-36(s0)
 810:	0007871b          	sext.w	a4,a5
 814:	02500793          	li	a5,37
 818:	00f71763          	bne	a4,a5,826 <vprintf+0x54>
        state = '%';
 81c:	02500793          	li	a5,37
 820:	fef42023          	sw	a5,-32(s0)
 824:	a2f5                	j	a10 <vprintf+0x23e>
      } else {
        putc(fd, c);
 826:	fdc42783          	lw	a5,-36(s0)
 82a:	0ff7f713          	zext.b	a4,a5
 82e:	fcc42783          	lw	a5,-52(s0)
 832:	85ba                	mv	a1,a4
 834:	853e                	mv	a0,a5
 836:	00000097          	auipc	ra,0x0
 83a:	dd2080e7          	jalr	-558(ra) # 608 <putc>
 83e:	aac9                	j	a10 <vprintf+0x23e>
      }
    } else if(state == '%'){
 840:	fe042783          	lw	a5,-32(s0)
 844:	0007871b          	sext.w	a4,a5
 848:	02500793          	li	a5,37
 84c:	1cf71263          	bne	a4,a5,a10 <vprintf+0x23e>
      if(c == 'd'){
 850:	fdc42783          	lw	a5,-36(s0)
 854:	0007871b          	sext.w	a4,a5
 858:	06400793          	li	a5,100
 85c:	02f71463          	bne	a4,a5,884 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 860:	fb843783          	ld	a5,-72(s0)
 864:	00878713          	addi	a4,a5,8
 868:	fae43c23          	sd	a4,-72(s0)
 86c:	4398                	lw	a4,0(a5)
 86e:	fcc42783          	lw	a5,-52(s0)
 872:	4685                	li	a3,1
 874:	4629                	li	a2,10
 876:	85ba                	mv	a1,a4
 878:	853e                	mv	a0,a5
 87a:	00000097          	auipc	ra,0x0
 87e:	dc4080e7          	jalr	-572(ra) # 63e <printint>
 882:	a269                	j	a0c <vprintf+0x23a>
      } else if(c == 'l') {
 884:	fdc42783          	lw	a5,-36(s0)
 888:	0007871b          	sext.w	a4,a5
 88c:	06c00793          	li	a5,108
 890:	02f71663          	bne	a4,a5,8bc <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 894:	fb843783          	ld	a5,-72(s0)
 898:	00878713          	addi	a4,a5,8
 89c:	fae43c23          	sd	a4,-72(s0)
 8a0:	639c                	ld	a5,0(a5)
 8a2:	0007871b          	sext.w	a4,a5
 8a6:	fcc42783          	lw	a5,-52(s0)
 8aa:	4681                	li	a3,0
 8ac:	4629                	li	a2,10
 8ae:	85ba                	mv	a1,a4
 8b0:	853e                	mv	a0,a5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	d8c080e7          	jalr	-628(ra) # 63e <printint>
 8ba:	aa89                	j	a0c <vprintf+0x23a>
      } else if(c == 'x') {
 8bc:	fdc42783          	lw	a5,-36(s0)
 8c0:	0007871b          	sext.w	a4,a5
 8c4:	07800793          	li	a5,120
 8c8:	02f71463          	bne	a4,a5,8f0 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8cc:	fb843783          	ld	a5,-72(s0)
 8d0:	00878713          	addi	a4,a5,8
 8d4:	fae43c23          	sd	a4,-72(s0)
 8d8:	4398                	lw	a4,0(a5)
 8da:	fcc42783          	lw	a5,-52(s0)
 8de:	4681                	li	a3,0
 8e0:	4641                	li	a2,16
 8e2:	85ba                	mv	a1,a4
 8e4:	853e                	mv	a0,a5
 8e6:	00000097          	auipc	ra,0x0
 8ea:	d58080e7          	jalr	-680(ra) # 63e <printint>
 8ee:	aa39                	j	a0c <vprintf+0x23a>
      } else if(c == 'p') {
 8f0:	fdc42783          	lw	a5,-36(s0)
 8f4:	0007871b          	sext.w	a4,a5
 8f8:	07000793          	li	a5,112
 8fc:	02f71263          	bne	a4,a5,920 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 900:	fb843783          	ld	a5,-72(s0)
 904:	00878713          	addi	a4,a5,8
 908:	fae43c23          	sd	a4,-72(s0)
 90c:	6398                	ld	a4,0(a5)
 90e:	fcc42783          	lw	a5,-52(s0)
 912:	85ba                	mv	a1,a4
 914:	853e                	mv	a0,a5
 916:	00000097          	auipc	ra,0x0
 91a:	e30080e7          	jalr	-464(ra) # 746 <printptr>
 91e:	a0fd                	j	a0c <vprintf+0x23a>
      } else if(c == 's'){
 920:	fdc42783          	lw	a5,-36(s0)
 924:	0007871b          	sext.w	a4,a5
 928:	07300793          	li	a5,115
 92c:	04f71c63          	bne	a4,a5,984 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 930:	fb843783          	ld	a5,-72(s0)
 934:	00878713          	addi	a4,a5,8
 938:	fae43c23          	sd	a4,-72(s0)
 93c:	639c                	ld	a5,0(a5)
 93e:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 942:	fe843783          	ld	a5,-24(s0)
 946:	eb8d                	bnez	a5,978 <vprintf+0x1a6>
          s = "(null)";
 948:	00000797          	auipc	a5,0x0
 94c:	4b078793          	addi	a5,a5,1200 # df8 <malloc+0x176>
 950:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 954:	a015                	j	978 <vprintf+0x1a6>
          putc(fd, *s);
 956:	fe843783          	ld	a5,-24(s0)
 95a:	0007c703          	lbu	a4,0(a5)
 95e:	fcc42783          	lw	a5,-52(s0)
 962:	85ba                	mv	a1,a4
 964:	853e                	mv	a0,a5
 966:	00000097          	auipc	ra,0x0
 96a:	ca2080e7          	jalr	-862(ra) # 608 <putc>
          s++;
 96e:	fe843783          	ld	a5,-24(s0)
 972:	0785                	addi	a5,a5,1
 974:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 978:	fe843783          	ld	a5,-24(s0)
 97c:	0007c783          	lbu	a5,0(a5)
 980:	fbf9                	bnez	a5,956 <vprintf+0x184>
 982:	a069                	j	a0c <vprintf+0x23a>
        }
      } else if(c == 'c'){
 984:	fdc42783          	lw	a5,-36(s0)
 988:	0007871b          	sext.w	a4,a5
 98c:	06300793          	li	a5,99
 990:	02f71463          	bne	a4,a5,9b8 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 994:	fb843783          	ld	a5,-72(s0)
 998:	00878713          	addi	a4,a5,8
 99c:	fae43c23          	sd	a4,-72(s0)
 9a0:	439c                	lw	a5,0(a5)
 9a2:	0ff7f713          	zext.b	a4,a5
 9a6:	fcc42783          	lw	a5,-52(s0)
 9aa:	85ba                	mv	a1,a4
 9ac:	853e                	mv	a0,a5
 9ae:	00000097          	auipc	ra,0x0
 9b2:	c5a080e7          	jalr	-934(ra) # 608 <putc>
 9b6:	a899                	j	a0c <vprintf+0x23a>
      } else if(c == '%'){
 9b8:	fdc42783          	lw	a5,-36(s0)
 9bc:	0007871b          	sext.w	a4,a5
 9c0:	02500793          	li	a5,37
 9c4:	00f71f63          	bne	a4,a5,9e2 <vprintf+0x210>
        putc(fd, c);
 9c8:	fdc42783          	lw	a5,-36(s0)
 9cc:	0ff7f713          	zext.b	a4,a5
 9d0:	fcc42783          	lw	a5,-52(s0)
 9d4:	85ba                	mv	a1,a4
 9d6:	853e                	mv	a0,a5
 9d8:	00000097          	auipc	ra,0x0
 9dc:	c30080e7          	jalr	-976(ra) # 608 <putc>
 9e0:	a035                	j	a0c <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9e2:	fcc42783          	lw	a5,-52(s0)
 9e6:	02500593          	li	a1,37
 9ea:	853e                	mv	a0,a5
 9ec:	00000097          	auipc	ra,0x0
 9f0:	c1c080e7          	jalr	-996(ra) # 608 <putc>
        putc(fd, c);
 9f4:	fdc42783          	lw	a5,-36(s0)
 9f8:	0ff7f713          	zext.b	a4,a5
 9fc:	fcc42783          	lw	a5,-52(s0)
 a00:	85ba                	mv	a1,a4
 a02:	853e                	mv	a0,a5
 a04:	00000097          	auipc	ra,0x0
 a08:	c04080e7          	jalr	-1020(ra) # 608 <putc>
      }
      state = 0;
 a0c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a10:	fe442783          	lw	a5,-28(s0)
 a14:	2785                	addiw	a5,a5,1
 a16:	fef42223          	sw	a5,-28(s0)
 a1a:	fe442783          	lw	a5,-28(s0)
 a1e:	fc043703          	ld	a4,-64(s0)
 a22:	97ba                	add	a5,a5,a4
 a24:	0007c783          	lbu	a5,0(a5)
 a28:	dc0795e3          	bnez	a5,7f2 <vprintf+0x20>
    }
  }
}
 a2c:	0001                	nop
 a2e:	0001                	nop
 a30:	60a6                	ld	ra,72(sp)
 a32:	6406                	ld	s0,64(sp)
 a34:	6161                	addi	sp,sp,80
 a36:	8082                	ret

0000000000000a38 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a38:	7159                	addi	sp,sp,-112
 a3a:	fc06                	sd	ra,56(sp)
 a3c:	f822                	sd	s0,48(sp)
 a3e:	0080                	addi	s0,sp,64
 a40:	fcb43823          	sd	a1,-48(s0)
 a44:	e010                	sd	a2,0(s0)
 a46:	e414                	sd	a3,8(s0)
 a48:	e818                	sd	a4,16(s0)
 a4a:	ec1c                	sd	a5,24(s0)
 a4c:	03043023          	sd	a6,32(s0)
 a50:	03143423          	sd	a7,40(s0)
 a54:	87aa                	mv	a5,a0
 a56:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a5a:	03040793          	addi	a5,s0,48
 a5e:	fcf43423          	sd	a5,-56(s0)
 a62:	fc843783          	ld	a5,-56(s0)
 a66:	fd078793          	addi	a5,a5,-48
 a6a:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a6e:	fe843703          	ld	a4,-24(s0)
 a72:	fdc42783          	lw	a5,-36(s0)
 a76:	863a                	mv	a2,a4
 a78:	fd043583          	ld	a1,-48(s0)
 a7c:	853e                	mv	a0,a5
 a7e:	00000097          	auipc	ra,0x0
 a82:	d54080e7          	jalr	-684(ra) # 7d2 <vprintf>
}
 a86:	0001                	nop
 a88:	70e2                	ld	ra,56(sp)
 a8a:	7442                	ld	s0,48(sp)
 a8c:	6165                	addi	sp,sp,112
 a8e:	8082                	ret

0000000000000a90 <printf>:

void
printf(const char *fmt, ...)
{
 a90:	7159                	addi	sp,sp,-112
 a92:	f406                	sd	ra,40(sp)
 a94:	f022                	sd	s0,32(sp)
 a96:	1800                	addi	s0,sp,48
 a98:	fca43c23          	sd	a0,-40(s0)
 a9c:	e40c                	sd	a1,8(s0)
 a9e:	e810                	sd	a2,16(s0)
 aa0:	ec14                	sd	a3,24(s0)
 aa2:	f018                	sd	a4,32(s0)
 aa4:	f41c                	sd	a5,40(s0)
 aa6:	03043823          	sd	a6,48(s0)
 aaa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aae:	04040793          	addi	a5,s0,64
 ab2:	fcf43823          	sd	a5,-48(s0)
 ab6:	fd043783          	ld	a5,-48(s0)
 aba:	fc878793          	addi	a5,a5,-56
 abe:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ac2:	fe843783          	ld	a5,-24(s0)
 ac6:	863e                	mv	a2,a5
 ac8:	fd843583          	ld	a1,-40(s0)
 acc:	4505                	li	a0,1
 ace:	00000097          	auipc	ra,0x0
 ad2:	d04080e7          	jalr	-764(ra) # 7d2 <vprintf>
}
 ad6:	0001                	nop
 ad8:	70a2                	ld	ra,40(sp)
 ada:	7402                	ld	s0,32(sp)
 adc:	6165                	addi	sp,sp,112
 ade:	8082                	ret

0000000000000ae0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae0:	7179                	addi	sp,sp,-48
 ae2:	f422                	sd	s0,40(sp)
 ae4:	1800                	addi	s0,sp,48
 ae6:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aea:	fd843783          	ld	a5,-40(s0)
 aee:	17c1                	addi	a5,a5,-16
 af0:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af4:	00001797          	auipc	a5,0x1
 af8:	8ac78793          	addi	a5,a5,-1876 # 13a0 <freep>
 afc:	639c                	ld	a5,0(a5)
 afe:	fef43423          	sd	a5,-24(s0)
 b02:	a815                	j	b36 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b04:	fe843783          	ld	a5,-24(s0)
 b08:	639c                	ld	a5,0(a5)
 b0a:	fe843703          	ld	a4,-24(s0)
 b0e:	00f76f63          	bltu	a4,a5,b2c <free+0x4c>
 b12:	fe043703          	ld	a4,-32(s0)
 b16:	fe843783          	ld	a5,-24(s0)
 b1a:	02e7eb63          	bltu	a5,a4,b50 <free+0x70>
 b1e:	fe843783          	ld	a5,-24(s0)
 b22:	639c                	ld	a5,0(a5)
 b24:	fe043703          	ld	a4,-32(s0)
 b28:	02f76463          	bltu	a4,a5,b50 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b2c:	fe843783          	ld	a5,-24(s0)
 b30:	639c                	ld	a5,0(a5)
 b32:	fef43423          	sd	a5,-24(s0)
 b36:	fe043703          	ld	a4,-32(s0)
 b3a:	fe843783          	ld	a5,-24(s0)
 b3e:	fce7f3e3          	bgeu	a5,a4,b04 <free+0x24>
 b42:	fe843783          	ld	a5,-24(s0)
 b46:	639c                	ld	a5,0(a5)
 b48:	fe043703          	ld	a4,-32(s0)
 b4c:	faf77ce3          	bgeu	a4,a5,b04 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b50:	fe043783          	ld	a5,-32(s0)
 b54:	479c                	lw	a5,8(a5)
 b56:	1782                	slli	a5,a5,0x20
 b58:	9381                	srli	a5,a5,0x20
 b5a:	0792                	slli	a5,a5,0x4
 b5c:	fe043703          	ld	a4,-32(s0)
 b60:	973e                	add	a4,a4,a5
 b62:	fe843783          	ld	a5,-24(s0)
 b66:	639c                	ld	a5,0(a5)
 b68:	02f71763          	bne	a4,a5,b96 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b6c:	fe043783          	ld	a5,-32(s0)
 b70:	4798                	lw	a4,8(a5)
 b72:	fe843783          	ld	a5,-24(s0)
 b76:	639c                	ld	a5,0(a5)
 b78:	479c                	lw	a5,8(a5)
 b7a:	9fb9                	addw	a5,a5,a4
 b7c:	0007871b          	sext.w	a4,a5
 b80:	fe043783          	ld	a5,-32(s0)
 b84:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b86:	fe843783          	ld	a5,-24(s0)
 b8a:	639c                	ld	a5,0(a5)
 b8c:	6398                	ld	a4,0(a5)
 b8e:	fe043783          	ld	a5,-32(s0)
 b92:	e398                	sd	a4,0(a5)
 b94:	a039                	j	ba2 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b96:	fe843783          	ld	a5,-24(s0)
 b9a:	6398                	ld	a4,0(a5)
 b9c:	fe043783          	ld	a5,-32(s0)
 ba0:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 ba2:	fe843783          	ld	a5,-24(s0)
 ba6:	479c                	lw	a5,8(a5)
 ba8:	1782                	slli	a5,a5,0x20
 baa:	9381                	srli	a5,a5,0x20
 bac:	0792                	slli	a5,a5,0x4
 bae:	fe843703          	ld	a4,-24(s0)
 bb2:	97ba                	add	a5,a5,a4
 bb4:	fe043703          	ld	a4,-32(s0)
 bb8:	02f71563          	bne	a4,a5,be2 <free+0x102>
    p->s.size += bp->s.size;
 bbc:	fe843783          	ld	a5,-24(s0)
 bc0:	4798                	lw	a4,8(a5)
 bc2:	fe043783          	ld	a5,-32(s0)
 bc6:	479c                	lw	a5,8(a5)
 bc8:	9fb9                	addw	a5,a5,a4
 bca:	0007871b          	sext.w	a4,a5
 bce:	fe843783          	ld	a5,-24(s0)
 bd2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bd4:	fe043783          	ld	a5,-32(s0)
 bd8:	6398                	ld	a4,0(a5)
 bda:	fe843783          	ld	a5,-24(s0)
 bde:	e398                	sd	a4,0(a5)
 be0:	a031                	j	bec <free+0x10c>
  } else
    p->s.ptr = bp;
 be2:	fe843783          	ld	a5,-24(s0)
 be6:	fe043703          	ld	a4,-32(s0)
 bea:	e398                	sd	a4,0(a5)
  freep = p;
 bec:	00000797          	auipc	a5,0x0
 bf0:	7b478793          	addi	a5,a5,1972 # 13a0 <freep>
 bf4:	fe843703          	ld	a4,-24(s0)
 bf8:	e398                	sd	a4,0(a5)
}
 bfa:	0001                	nop
 bfc:	7422                	ld	s0,40(sp)
 bfe:	6145                	addi	sp,sp,48
 c00:	8082                	ret

0000000000000c02 <morecore>:

static Header*
morecore(uint nu)
{
 c02:	7179                	addi	sp,sp,-48
 c04:	f406                	sd	ra,40(sp)
 c06:	f022                	sd	s0,32(sp)
 c08:	1800                	addi	s0,sp,48
 c0a:	87aa                	mv	a5,a0
 c0c:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c10:	fdc42783          	lw	a5,-36(s0)
 c14:	0007871b          	sext.w	a4,a5
 c18:	6785                	lui	a5,0x1
 c1a:	00f77563          	bgeu	a4,a5,c24 <morecore+0x22>
    nu = 4096;
 c1e:	6785                	lui	a5,0x1
 c20:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c24:	fdc42783          	lw	a5,-36(s0)
 c28:	0047979b          	slliw	a5,a5,0x4
 c2c:	2781                	sext.w	a5,a5
 c2e:	2781                	sext.w	a5,a5
 c30:	853e                	mv	a0,a5
 c32:	00000097          	auipc	ra,0x0
 c36:	9ae080e7          	jalr	-1618(ra) # 5e0 <sbrk>
 c3a:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c3e:	fe843703          	ld	a4,-24(s0)
 c42:	57fd                	li	a5,-1
 c44:	00f71463          	bne	a4,a5,c4c <morecore+0x4a>
    return 0;
 c48:	4781                	li	a5,0
 c4a:	a03d                	j	c78 <morecore+0x76>
  hp = (Header*)p;
 c4c:	fe843783          	ld	a5,-24(s0)
 c50:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c54:	fe043783          	ld	a5,-32(s0)
 c58:	fdc42703          	lw	a4,-36(s0)
 c5c:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c5e:	fe043783          	ld	a5,-32(s0)
 c62:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x38e>
 c64:	853e                	mv	a0,a5
 c66:	00000097          	auipc	ra,0x0
 c6a:	e7a080e7          	jalr	-390(ra) # ae0 <free>
  return freep;
 c6e:	00000797          	auipc	a5,0x0
 c72:	73278793          	addi	a5,a5,1842 # 13a0 <freep>
 c76:	639c                	ld	a5,0(a5)
}
 c78:	853e                	mv	a0,a5
 c7a:	70a2                	ld	ra,40(sp)
 c7c:	7402                	ld	s0,32(sp)
 c7e:	6145                	addi	sp,sp,48
 c80:	8082                	ret

0000000000000c82 <malloc>:

void*
malloc(uint nbytes)
{
 c82:	7139                	addi	sp,sp,-64
 c84:	fc06                	sd	ra,56(sp)
 c86:	f822                	sd	s0,48(sp)
 c88:	0080                	addi	s0,sp,64
 c8a:	87aa                	mv	a5,a0
 c8c:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c90:	fcc46783          	lwu	a5,-52(s0)
 c94:	07bd                	addi	a5,a5,15
 c96:	8391                	srli	a5,a5,0x4
 c98:	2781                	sext.w	a5,a5
 c9a:	2785                	addiw	a5,a5,1
 c9c:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 ca0:	00000797          	auipc	a5,0x0
 ca4:	70078793          	addi	a5,a5,1792 # 13a0 <freep>
 ca8:	639c                	ld	a5,0(a5)
 caa:	fef43023          	sd	a5,-32(s0)
 cae:	fe043783          	ld	a5,-32(s0)
 cb2:	ef95                	bnez	a5,cee <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cb4:	00000797          	auipc	a5,0x0
 cb8:	6dc78793          	addi	a5,a5,1756 # 1390 <base>
 cbc:	fef43023          	sd	a5,-32(s0)
 cc0:	00000797          	auipc	a5,0x0
 cc4:	6e078793          	addi	a5,a5,1760 # 13a0 <freep>
 cc8:	fe043703          	ld	a4,-32(s0)
 ccc:	e398                	sd	a4,0(a5)
 cce:	00000797          	auipc	a5,0x0
 cd2:	6d278793          	addi	a5,a5,1746 # 13a0 <freep>
 cd6:	6398                	ld	a4,0(a5)
 cd8:	00000797          	auipc	a5,0x0
 cdc:	6b878793          	addi	a5,a5,1720 # 1390 <base>
 ce0:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 ce2:	00000797          	auipc	a5,0x0
 ce6:	6ae78793          	addi	a5,a5,1710 # 1390 <base>
 cea:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cee:	fe043783          	ld	a5,-32(s0)
 cf2:	639c                	ld	a5,0(a5)
 cf4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cf8:	fe843783          	ld	a5,-24(s0)
 cfc:	4798                	lw	a4,8(a5)
 cfe:	fdc42783          	lw	a5,-36(s0)
 d02:	2781                	sext.w	a5,a5
 d04:	06f76763          	bltu	a4,a5,d72 <malloc+0xf0>
      if(p->s.size == nunits)
 d08:	fe843783          	ld	a5,-24(s0)
 d0c:	4798                	lw	a4,8(a5)
 d0e:	fdc42783          	lw	a5,-36(s0)
 d12:	2781                	sext.w	a5,a5
 d14:	00e79963          	bne	a5,a4,d26 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d18:	fe843783          	ld	a5,-24(s0)
 d1c:	6398                	ld	a4,0(a5)
 d1e:	fe043783          	ld	a5,-32(s0)
 d22:	e398                	sd	a4,0(a5)
 d24:	a825                	j	d5c <malloc+0xda>
      else {
        p->s.size -= nunits;
 d26:	fe843783          	ld	a5,-24(s0)
 d2a:	479c                	lw	a5,8(a5)
 d2c:	fdc42703          	lw	a4,-36(s0)
 d30:	9f99                	subw	a5,a5,a4
 d32:	0007871b          	sext.w	a4,a5
 d36:	fe843783          	ld	a5,-24(s0)
 d3a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d3c:	fe843783          	ld	a5,-24(s0)
 d40:	479c                	lw	a5,8(a5)
 d42:	1782                	slli	a5,a5,0x20
 d44:	9381                	srli	a5,a5,0x20
 d46:	0792                	slli	a5,a5,0x4
 d48:	fe843703          	ld	a4,-24(s0)
 d4c:	97ba                	add	a5,a5,a4
 d4e:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d52:	fe843783          	ld	a5,-24(s0)
 d56:	fdc42703          	lw	a4,-36(s0)
 d5a:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d5c:	00000797          	auipc	a5,0x0
 d60:	64478793          	addi	a5,a5,1604 # 13a0 <freep>
 d64:	fe043703          	ld	a4,-32(s0)
 d68:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d6a:	fe843783          	ld	a5,-24(s0)
 d6e:	07c1                	addi	a5,a5,16
 d70:	a091                	j	db4 <malloc+0x132>
    }
    if(p == freep)
 d72:	00000797          	auipc	a5,0x0
 d76:	62e78793          	addi	a5,a5,1582 # 13a0 <freep>
 d7a:	639c                	ld	a5,0(a5)
 d7c:	fe843703          	ld	a4,-24(s0)
 d80:	02f71063          	bne	a4,a5,da0 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d84:	fdc42783          	lw	a5,-36(s0)
 d88:	853e                	mv	a0,a5
 d8a:	00000097          	auipc	ra,0x0
 d8e:	e78080e7          	jalr	-392(ra) # c02 <morecore>
 d92:	fea43423          	sd	a0,-24(s0)
 d96:	fe843783          	ld	a5,-24(s0)
 d9a:	e399                	bnez	a5,da0 <malloc+0x11e>
        return 0;
 d9c:	4781                	li	a5,0
 d9e:	a819                	j	db4 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 da0:	fe843783          	ld	a5,-24(s0)
 da4:	fef43023          	sd	a5,-32(s0)
 da8:	fe843783          	ld	a5,-24(s0)
 dac:	639c                	ld	a5,0(a5)
 dae:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 db2:	b799                	j	cf8 <malloc+0x76>
  }
}
 db4:	853e                	mv	a0,a5
 db6:	70e2                	ld	ra,56(sp)
 db8:	7442                	ld	s0,48(sp)
 dba:	6121                	addi	sp,sp,64
 dbc:	8082                	ret
