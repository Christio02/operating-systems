
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	87aa                	mv	a5,a0
   a:	feb43023          	sd	a1,-32(s0)
   e:	fef42623          	sw	a5,-20(s0)
  if(argc != 3){
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	478d                	li	a5,3
  1c:	02f70063          	beq	a4,a5,3c <main+0x3c>
    fprintf(2, "Usage: ln old new\n");
  20:	00001597          	auipc	a1,0x1
  24:	d9058593          	addi	a1,a1,-624 # db0 <malloc+0x144>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	9f8080e7          	jalr	-1544(ra) # a22 <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	506080e7          	jalr	1286(ra) # 53a <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  3c:	fe043783          	ld	a5,-32(s0)
  40:	07a1                	addi	a5,a5,8
  42:	6398                	ld	a4,0(a5)
  44:	fe043783          	ld	a5,-32(s0)
  48:	07c1                	addi	a5,a5,16
  4a:	639c                	ld	a5,0(a5)
  4c:	85be                	mv	a1,a5
  4e:	853a                	mv	a0,a4
  50:	00000097          	auipc	ra,0x0
  54:	54a080e7          	jalr	1354(ra) # 59a <link>
  58:	87aa                	mv	a5,a0
  5a:	0207d563          	bgez	a5,84 <main+0x84>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  5e:	fe043783          	ld	a5,-32(s0)
  62:	07a1                	addi	a5,a5,8
  64:	6398                	ld	a4,0(a5)
  66:	fe043783          	ld	a5,-32(s0)
  6a:	07c1                	addi	a5,a5,16
  6c:	639c                	ld	a5,0(a5)
  6e:	86be                	mv	a3,a5
  70:	863a                	mv	a2,a4
  72:	00001597          	auipc	a1,0x1
  76:	d5658593          	addi	a1,a1,-682 # dc8 <malloc+0x15c>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9a6080e7          	jalr	-1626(ra) # a22 <fprintf>
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	4b4080e7          	jalr	1204(ra) # 53a <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	49a080e7          	jalr	1178(ra) # 53a <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	7179                	addi	sp,sp,-48
  aa:	f422                	sd	s0,40(sp)
  ac:	1800                	addi	s0,sp,48
  ae:	fca43c23          	sd	a0,-40(s0)
  b2:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  b6:	fd843783          	ld	a5,-40(s0)
  ba:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  be:	0001                	nop
  c0:	fd043703          	ld	a4,-48(s0)
  c4:	00170793          	addi	a5,a4,1
  c8:	fcf43823          	sd	a5,-48(s0)
  cc:	fd843783          	ld	a5,-40(s0)
  d0:	00178693          	addi	a3,a5,1
  d4:	fcd43c23          	sd	a3,-40(s0)
  d8:	00074703          	lbu	a4,0(a4)
  dc:	00e78023          	sb	a4,0(a5)
  e0:	0007c783          	lbu	a5,0(a5)
  e4:	fff1                	bnez	a5,c0 <strcpy+0x18>
    ;
  return os;
  e6:	fe843783          	ld	a5,-24(s0)
}
  ea:	853e                	mv	a0,a5
  ec:	7422                	ld	s0,40(sp)
  ee:	6145                	addi	sp,sp,48
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1101                	addi	sp,sp,-32
  f4:	ec22                	sd	s0,24(sp)
  f6:	1000                	addi	s0,sp,32
  f8:	fea43423          	sd	a0,-24(s0)
  fc:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 100:	a819                	j	116 <strcmp+0x24>
    p++, q++;
 102:	fe843783          	ld	a5,-24(s0)
 106:	0785                	addi	a5,a5,1
 108:	fef43423          	sd	a5,-24(s0)
 10c:	fe043783          	ld	a5,-32(s0)
 110:	0785                	addi	a5,a5,1
 112:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 116:	fe843783          	ld	a5,-24(s0)
 11a:	0007c783          	lbu	a5,0(a5)
 11e:	cb99                	beqz	a5,134 <strcmp+0x42>
 120:	fe843783          	ld	a5,-24(s0)
 124:	0007c703          	lbu	a4,0(a5)
 128:	fe043783          	ld	a5,-32(s0)
 12c:	0007c783          	lbu	a5,0(a5)
 130:	fcf709e3          	beq	a4,a5,102 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 134:	fe843783          	ld	a5,-24(s0)
 138:	0007c783          	lbu	a5,0(a5)
 13c:	0007871b          	sext.w	a4,a5
 140:	fe043783          	ld	a5,-32(s0)
 144:	0007c783          	lbu	a5,0(a5)
 148:	2781                	sext.w	a5,a5
 14a:	40f707bb          	subw	a5,a4,a5
 14e:	2781                	sext.w	a5,a5
}
 150:	853e                	mv	a0,a5
 152:	6462                	ld	s0,24(sp)
 154:	6105                	addi	sp,sp,32
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	7179                	addi	sp,sp,-48
 15a:	f422                	sd	s0,40(sp)
 15c:	1800                	addi	s0,sp,48
 15e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 162:	fe042623          	sw	zero,-20(s0)
 166:	a031                	j	172 <strlen+0x1a>
 168:	fec42783          	lw	a5,-20(s0)
 16c:	2785                	addiw	a5,a5,1
 16e:	fef42623          	sw	a5,-20(s0)
 172:	fec42783          	lw	a5,-20(s0)
 176:	fd843703          	ld	a4,-40(s0)
 17a:	97ba                	add	a5,a5,a4
 17c:	0007c783          	lbu	a5,0(a5)
 180:	f7e5                	bnez	a5,168 <strlen+0x10>
    ;
  return n;
 182:	fec42783          	lw	a5,-20(s0)
}
 186:	853e                	mv	a0,a5
 188:	7422                	ld	s0,40(sp)
 18a:	6145                	addi	sp,sp,48
 18c:	8082                	ret

000000000000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	7179                	addi	sp,sp,-48
 190:	f422                	sd	s0,40(sp)
 192:	1800                	addi	s0,sp,48
 194:	fca43c23          	sd	a0,-40(s0)
 198:	87ae                	mv	a5,a1
 19a:	8732                	mv	a4,a2
 19c:	fcf42a23          	sw	a5,-44(s0)
 1a0:	87ba                	mv	a5,a4
 1a2:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1a6:	fd843783          	ld	a5,-40(s0)
 1aa:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1ae:	fe042623          	sw	zero,-20(s0)
 1b2:	a00d                	j	1d4 <memset+0x46>
    cdst[i] = c;
 1b4:	fec42783          	lw	a5,-20(s0)
 1b8:	fe043703          	ld	a4,-32(s0)
 1bc:	97ba                	add	a5,a5,a4
 1be:	fd442703          	lw	a4,-44(s0)
 1c2:	0ff77713          	zext.b	a4,a4
 1c6:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1ca:	fec42783          	lw	a5,-20(s0)
 1ce:	2785                	addiw	a5,a5,1
 1d0:	fef42623          	sw	a5,-20(s0)
 1d4:	fec42703          	lw	a4,-20(s0)
 1d8:	fd042783          	lw	a5,-48(s0)
 1dc:	2781                	sext.w	a5,a5
 1de:	fcf76be3          	bltu	a4,a5,1b4 <memset+0x26>
  }
  return dst;
 1e2:	fd843783          	ld	a5,-40(s0)
}
 1e6:	853e                	mv	a0,a5
 1e8:	7422                	ld	s0,40(sp)
 1ea:	6145                	addi	sp,sp,48
 1ec:	8082                	ret

00000000000001ee <strchr>:

char*
strchr(const char *s, char c)
{
 1ee:	1101                	addi	sp,sp,-32
 1f0:	ec22                	sd	s0,24(sp)
 1f2:	1000                	addi	s0,sp,32
 1f4:	fea43423          	sd	a0,-24(s0)
 1f8:	87ae                	mv	a5,a1
 1fa:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1fe:	a01d                	j	224 <strchr+0x36>
    if(*s == c)
 200:	fe843783          	ld	a5,-24(s0)
 204:	0007c703          	lbu	a4,0(a5)
 208:	fe744783          	lbu	a5,-25(s0)
 20c:	0ff7f793          	zext.b	a5,a5
 210:	00e79563          	bne	a5,a4,21a <strchr+0x2c>
      return (char*)s;
 214:	fe843783          	ld	a5,-24(s0)
 218:	a821                	j	230 <strchr+0x42>
  for(; *s; s++)
 21a:	fe843783          	ld	a5,-24(s0)
 21e:	0785                	addi	a5,a5,1
 220:	fef43423          	sd	a5,-24(s0)
 224:	fe843783          	ld	a5,-24(s0)
 228:	0007c783          	lbu	a5,0(a5)
 22c:	fbf1                	bnez	a5,200 <strchr+0x12>
  return 0;
 22e:	4781                	li	a5,0
}
 230:	853e                	mv	a0,a5
 232:	6462                	ld	s0,24(sp)
 234:	6105                	addi	sp,sp,32
 236:	8082                	ret

0000000000000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	7179                	addi	sp,sp,-48
 23a:	f406                	sd	ra,40(sp)
 23c:	f022                	sd	s0,32(sp)
 23e:	1800                	addi	s0,sp,48
 240:	fca43c23          	sd	a0,-40(s0)
 244:	87ae                	mv	a5,a1
 246:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24a:	fe042623          	sw	zero,-20(s0)
 24e:	a8a1                	j	2a6 <gets+0x6e>
    cc = read(0, &c, 1);
 250:	fe740793          	addi	a5,s0,-25
 254:	4605                	li	a2,1
 256:	85be                	mv	a1,a5
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	2f8080e7          	jalr	760(ra) # 552 <read>
 262:	87aa                	mv	a5,a0
 264:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 268:	fe842783          	lw	a5,-24(s0)
 26c:	2781                	sext.w	a5,a5
 26e:	04f05763          	blez	a5,2bc <gets+0x84>
      break;
    buf[i++] = c;
 272:	fec42783          	lw	a5,-20(s0)
 276:	0017871b          	addiw	a4,a5,1
 27a:	fee42623          	sw	a4,-20(s0)
 27e:	873e                	mv	a4,a5
 280:	fd843783          	ld	a5,-40(s0)
 284:	97ba                	add	a5,a5,a4
 286:	fe744703          	lbu	a4,-25(s0)
 28a:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 28e:	fe744783          	lbu	a5,-25(s0)
 292:	873e                	mv	a4,a5
 294:	47a9                	li	a5,10
 296:	02f70463          	beq	a4,a5,2be <gets+0x86>
 29a:	fe744783          	lbu	a5,-25(s0)
 29e:	873e                	mv	a4,a5
 2a0:	47b5                	li	a5,13
 2a2:	00f70e63          	beq	a4,a5,2be <gets+0x86>
  for(i=0; i+1 < max; ){
 2a6:	fec42783          	lw	a5,-20(s0)
 2aa:	2785                	addiw	a5,a5,1
 2ac:	0007871b          	sext.w	a4,a5
 2b0:	fd442783          	lw	a5,-44(s0)
 2b4:	2781                	sext.w	a5,a5
 2b6:	f8f74de3          	blt	a4,a5,250 <gets+0x18>
 2ba:	a011                	j	2be <gets+0x86>
      break;
 2bc:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2be:	fec42783          	lw	a5,-20(s0)
 2c2:	fd843703          	ld	a4,-40(s0)
 2c6:	97ba                	add	a5,a5,a4
 2c8:	00078023          	sb	zero,0(a5)
  return buf;
 2cc:	fd843783          	ld	a5,-40(s0)
}
 2d0:	853e                	mv	a0,a5
 2d2:	70a2                	ld	ra,40(sp)
 2d4:	7402                	ld	s0,32(sp)
 2d6:	6145                	addi	sp,sp,48
 2d8:	8082                	ret

00000000000002da <stat>:

int
stat(const char *n, struct stat *st)
{
 2da:	7179                	addi	sp,sp,-48
 2dc:	f406                	sd	ra,40(sp)
 2de:	f022                	sd	s0,32(sp)
 2e0:	1800                	addi	s0,sp,48
 2e2:	fca43c23          	sd	a0,-40(s0)
 2e6:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ea:	4581                	li	a1,0
 2ec:	fd843503          	ld	a0,-40(s0)
 2f0:	00000097          	auipc	ra,0x0
 2f4:	28a080e7          	jalr	650(ra) # 57a <open>
 2f8:	87aa                	mv	a5,a0
 2fa:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2fe:	fec42783          	lw	a5,-20(s0)
 302:	2781                	sext.w	a5,a5
 304:	0007d463          	bgez	a5,30c <stat+0x32>
    return -1;
 308:	57fd                	li	a5,-1
 30a:	a035                	j	336 <stat+0x5c>
  r = fstat(fd, st);
 30c:	fec42783          	lw	a5,-20(s0)
 310:	fd043583          	ld	a1,-48(s0)
 314:	853e                	mv	a0,a5
 316:	00000097          	auipc	ra,0x0
 31a:	27c080e7          	jalr	636(ra) # 592 <fstat>
 31e:	87aa                	mv	a5,a0
 320:	fef42423          	sw	a5,-24(s0)
  close(fd);
 324:	fec42783          	lw	a5,-20(s0)
 328:	853e                	mv	a0,a5
 32a:	00000097          	auipc	ra,0x0
 32e:	238080e7          	jalr	568(ra) # 562 <close>
  return r;
 332:	fe842783          	lw	a5,-24(s0)
}
 336:	853e                	mv	a0,a5
 338:	70a2                	ld	ra,40(sp)
 33a:	7402                	ld	s0,32(sp)
 33c:	6145                	addi	sp,sp,48
 33e:	8082                	ret

0000000000000340 <atoi>:

int
atoi(const char *s)
{
 340:	7179                	addi	sp,sp,-48
 342:	f422                	sd	s0,40(sp)
 344:	1800                	addi	s0,sp,48
 346:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 34a:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 34e:	a81d                	j	384 <atoi+0x44>
    n = n*10 + *s++ - '0';
 350:	fec42783          	lw	a5,-20(s0)
 354:	873e                	mv	a4,a5
 356:	87ba                	mv	a5,a4
 358:	0027979b          	slliw	a5,a5,0x2
 35c:	9fb9                	addw	a5,a5,a4
 35e:	0017979b          	slliw	a5,a5,0x1
 362:	0007871b          	sext.w	a4,a5
 366:	fd843783          	ld	a5,-40(s0)
 36a:	00178693          	addi	a3,a5,1
 36e:	fcd43c23          	sd	a3,-40(s0)
 372:	0007c783          	lbu	a5,0(a5)
 376:	2781                	sext.w	a5,a5
 378:	9fb9                	addw	a5,a5,a4
 37a:	2781                	sext.w	a5,a5
 37c:	fd07879b          	addiw	a5,a5,-48
 380:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 384:	fd843783          	ld	a5,-40(s0)
 388:	0007c783          	lbu	a5,0(a5)
 38c:	873e                	mv	a4,a5
 38e:	02f00793          	li	a5,47
 392:	00e7fb63          	bgeu	a5,a4,3a8 <atoi+0x68>
 396:	fd843783          	ld	a5,-40(s0)
 39a:	0007c783          	lbu	a5,0(a5)
 39e:	873e                	mv	a4,a5
 3a0:	03900793          	li	a5,57
 3a4:	fae7f6e3          	bgeu	a5,a4,350 <atoi+0x10>
  return n;
 3a8:	fec42783          	lw	a5,-20(s0)
}
 3ac:	853e                	mv	a0,a5
 3ae:	7422                	ld	s0,40(sp)
 3b0:	6145                	addi	sp,sp,48
 3b2:	8082                	ret

00000000000003b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b4:	7139                	addi	sp,sp,-64
 3b6:	fc22                	sd	s0,56(sp)
 3b8:	0080                	addi	s0,sp,64
 3ba:	fca43c23          	sd	a0,-40(s0)
 3be:	fcb43823          	sd	a1,-48(s0)
 3c2:	87b2                	mv	a5,a2
 3c4:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3c8:	fd843783          	ld	a5,-40(s0)
 3cc:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3d0:	fd043783          	ld	a5,-48(s0)
 3d4:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3d8:	fe043703          	ld	a4,-32(s0)
 3dc:	fe843783          	ld	a5,-24(s0)
 3e0:	02e7fc63          	bgeu	a5,a4,418 <memmove+0x64>
    while(n-- > 0)
 3e4:	a00d                	j	406 <memmove+0x52>
      *dst++ = *src++;
 3e6:	fe043703          	ld	a4,-32(s0)
 3ea:	00170793          	addi	a5,a4,1
 3ee:	fef43023          	sd	a5,-32(s0)
 3f2:	fe843783          	ld	a5,-24(s0)
 3f6:	00178693          	addi	a3,a5,1
 3fa:	fed43423          	sd	a3,-24(s0)
 3fe:	00074703          	lbu	a4,0(a4)
 402:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 406:	fcc42783          	lw	a5,-52(s0)
 40a:	fff7871b          	addiw	a4,a5,-1
 40e:	fce42623          	sw	a4,-52(s0)
 412:	fcf04ae3          	bgtz	a5,3e6 <memmove+0x32>
 416:	a891                	j	46a <memmove+0xb6>
  } else {
    dst += n;
 418:	fcc42783          	lw	a5,-52(s0)
 41c:	fe843703          	ld	a4,-24(s0)
 420:	97ba                	add	a5,a5,a4
 422:	fef43423          	sd	a5,-24(s0)
    src += n;
 426:	fcc42783          	lw	a5,-52(s0)
 42a:	fe043703          	ld	a4,-32(s0)
 42e:	97ba                	add	a5,a5,a4
 430:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 434:	a01d                	j	45a <memmove+0xa6>
      *--dst = *--src;
 436:	fe043783          	ld	a5,-32(s0)
 43a:	17fd                	addi	a5,a5,-1
 43c:	fef43023          	sd	a5,-32(s0)
 440:	fe843783          	ld	a5,-24(s0)
 444:	17fd                	addi	a5,a5,-1
 446:	fef43423          	sd	a5,-24(s0)
 44a:	fe043783          	ld	a5,-32(s0)
 44e:	0007c703          	lbu	a4,0(a5)
 452:	fe843783          	ld	a5,-24(s0)
 456:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 45a:	fcc42783          	lw	a5,-52(s0)
 45e:	fff7871b          	addiw	a4,a5,-1
 462:	fce42623          	sw	a4,-52(s0)
 466:	fcf048e3          	bgtz	a5,436 <memmove+0x82>
  }
  return vdst;
 46a:	fd843783          	ld	a5,-40(s0)
}
 46e:	853e                	mv	a0,a5
 470:	7462                	ld	s0,56(sp)
 472:	6121                	addi	sp,sp,64
 474:	8082                	ret

0000000000000476 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 476:	7139                	addi	sp,sp,-64
 478:	fc22                	sd	s0,56(sp)
 47a:	0080                	addi	s0,sp,64
 47c:	fca43c23          	sd	a0,-40(s0)
 480:	fcb43823          	sd	a1,-48(s0)
 484:	87b2                	mv	a5,a2
 486:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 48a:	fd843783          	ld	a5,-40(s0)
 48e:	fef43423          	sd	a5,-24(s0)
 492:	fd043783          	ld	a5,-48(s0)
 496:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 49a:	a0a1                	j	4e2 <memcmp+0x6c>
    if (*p1 != *p2) {
 49c:	fe843783          	ld	a5,-24(s0)
 4a0:	0007c703          	lbu	a4,0(a5)
 4a4:	fe043783          	ld	a5,-32(s0)
 4a8:	0007c783          	lbu	a5,0(a5)
 4ac:	02f70163          	beq	a4,a5,4ce <memcmp+0x58>
      return *p1 - *p2;
 4b0:	fe843783          	ld	a5,-24(s0)
 4b4:	0007c783          	lbu	a5,0(a5)
 4b8:	0007871b          	sext.w	a4,a5
 4bc:	fe043783          	ld	a5,-32(s0)
 4c0:	0007c783          	lbu	a5,0(a5)
 4c4:	2781                	sext.w	a5,a5
 4c6:	40f707bb          	subw	a5,a4,a5
 4ca:	2781                	sext.w	a5,a5
 4cc:	a01d                	j	4f2 <memcmp+0x7c>
    }
    p1++;
 4ce:	fe843783          	ld	a5,-24(s0)
 4d2:	0785                	addi	a5,a5,1
 4d4:	fef43423          	sd	a5,-24(s0)
    p2++;
 4d8:	fe043783          	ld	a5,-32(s0)
 4dc:	0785                	addi	a5,a5,1
 4de:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4e2:	fcc42783          	lw	a5,-52(s0)
 4e6:	fff7871b          	addiw	a4,a5,-1
 4ea:	fce42623          	sw	a4,-52(s0)
 4ee:	f7dd                	bnez	a5,49c <memcmp+0x26>
  }
  return 0;
 4f0:	4781                	li	a5,0
}
 4f2:	853e                	mv	a0,a5
 4f4:	7462                	ld	s0,56(sp)
 4f6:	6121                	addi	sp,sp,64
 4f8:	8082                	ret

00000000000004fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4fa:	7179                	addi	sp,sp,-48
 4fc:	f406                	sd	ra,40(sp)
 4fe:	f022                	sd	s0,32(sp)
 500:	1800                	addi	s0,sp,48
 502:	fea43423          	sd	a0,-24(s0)
 506:	feb43023          	sd	a1,-32(s0)
 50a:	87b2                	mv	a5,a2
 50c:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 510:	fdc42783          	lw	a5,-36(s0)
 514:	863e                	mv	a2,a5
 516:	fe043583          	ld	a1,-32(s0)
 51a:	fe843503          	ld	a0,-24(s0)
 51e:	00000097          	auipc	ra,0x0
 522:	e96080e7          	jalr	-362(ra) # 3b4 <memmove>
 526:	87aa                	mv	a5,a0
}
 528:	853e                	mv	a0,a5
 52a:	70a2                	ld	ra,40(sp)
 52c:	7402                	ld	s0,32(sp)
 52e:	6145                	addi	sp,sp,48
 530:	8082                	ret

0000000000000532 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 532:	4885                	li	a7,1
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exit>:
.global exit
exit:
 li a7, SYS_exit
 53a:	4889                	li	a7,2
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <wait>:
.global wait
wait:
 li a7, SYS_wait
 542:	488d                	li	a7,3
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 54a:	4891                	li	a7,4
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <read>:
.global read
read:
 li a7, SYS_read
 552:	4895                	li	a7,5
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <write>:
.global write
write:
 li a7, SYS_write
 55a:	48c1                	li	a7,16
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <close>:
.global close
close:
 li a7, SYS_close
 562:	48d5                	li	a7,21
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <kill>:
.global kill
kill:
 li a7, SYS_kill
 56a:	4899                	li	a7,6
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <exec>:
.global exec
exec:
 li a7, SYS_exec
 572:	489d                	li	a7,7
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <open>:
.global open
open:
 li a7, SYS_open
 57a:	48bd                	li	a7,15
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 582:	48c5                	li	a7,17
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58a:	48c9                	li	a7,18
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 592:	48a1                	li	a7,8
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <link>:
.global link
link:
 li a7, SYS_link
 59a:	48cd                	li	a7,19
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a2:	48d1                	li	a7,20
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5aa:	48a5                	li	a7,9
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b2:	48a9                	li	a7,10
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ba:	48ad                	li	a7,11
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c2:	48b1                	li	a7,12
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ca:	48b5                	li	a7,13
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d2:	48b9                	li	a7,14
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <hello>:
.global hello
hello:
 li a7, SYS_hello
 5da:	48d9                	li	a7,22
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 5e2:	48dd                	li	a7,23
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 5ea:	48e1                	li	a7,24
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5f2:	1101                	addi	sp,sp,-32
 5f4:	ec06                	sd	ra,24(sp)
 5f6:	e822                	sd	s0,16(sp)
 5f8:	1000                	addi	s0,sp,32
 5fa:	87aa                	mv	a5,a0
 5fc:	872e                	mv	a4,a1
 5fe:	fef42623          	sw	a5,-20(s0)
 602:	87ba                	mv	a5,a4
 604:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 608:	feb40713          	addi	a4,s0,-21
 60c:	fec42783          	lw	a5,-20(s0)
 610:	4605                	li	a2,1
 612:	85ba                	mv	a1,a4
 614:	853e                	mv	a0,a5
 616:	00000097          	auipc	ra,0x0
 61a:	f44080e7          	jalr	-188(ra) # 55a <write>
}
 61e:	0001                	nop
 620:	60e2                	ld	ra,24(sp)
 622:	6442                	ld	s0,16(sp)
 624:	6105                	addi	sp,sp,32
 626:	8082                	ret

0000000000000628 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 628:	7139                	addi	sp,sp,-64
 62a:	fc06                	sd	ra,56(sp)
 62c:	f822                	sd	s0,48(sp)
 62e:	0080                	addi	s0,sp,64
 630:	87aa                	mv	a5,a0
 632:	8736                	mv	a4,a3
 634:	fcf42623          	sw	a5,-52(s0)
 638:	87ae                	mv	a5,a1
 63a:	fcf42423          	sw	a5,-56(s0)
 63e:	87b2                	mv	a5,a2
 640:	fcf42223          	sw	a5,-60(s0)
 644:	87ba                	mv	a5,a4
 646:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 64a:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 64e:	fc042783          	lw	a5,-64(s0)
 652:	2781                	sext.w	a5,a5
 654:	c38d                	beqz	a5,676 <printint+0x4e>
 656:	fc842783          	lw	a5,-56(s0)
 65a:	2781                	sext.w	a5,a5
 65c:	0007dd63          	bgez	a5,676 <printint+0x4e>
    neg = 1;
 660:	4785                	li	a5,1
 662:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 666:	fc842783          	lw	a5,-56(s0)
 66a:	40f007bb          	negw	a5,a5
 66e:	2781                	sext.w	a5,a5
 670:	fef42223          	sw	a5,-28(s0)
 674:	a029                	j	67e <printint+0x56>
  } else {
    x = xx;
 676:	fc842783          	lw	a5,-56(s0)
 67a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 67e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 682:	fc442783          	lw	a5,-60(s0)
 686:	fe442703          	lw	a4,-28(s0)
 68a:	02f777bb          	remuw	a5,a4,a5
 68e:	0007861b          	sext.w	a2,a5
 692:	fec42783          	lw	a5,-20(s0)
 696:	0017871b          	addiw	a4,a5,1
 69a:	fee42623          	sw	a4,-20(s0)
 69e:	00001697          	auipc	a3,0x1
 6a2:	cd268693          	addi	a3,a3,-814 # 1370 <digits>
 6a6:	02061713          	slli	a4,a2,0x20
 6aa:	9301                	srli	a4,a4,0x20
 6ac:	9736                	add	a4,a4,a3
 6ae:	00074703          	lbu	a4,0(a4)
 6b2:	17c1                	addi	a5,a5,-16
 6b4:	97a2                	add	a5,a5,s0
 6b6:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6ba:	fc442783          	lw	a5,-60(s0)
 6be:	fe442703          	lw	a4,-28(s0)
 6c2:	02f757bb          	divuw	a5,a4,a5
 6c6:	fef42223          	sw	a5,-28(s0)
 6ca:	fe442783          	lw	a5,-28(s0)
 6ce:	2781                	sext.w	a5,a5
 6d0:	fbcd                	bnez	a5,682 <printint+0x5a>
  if(neg)
 6d2:	fe842783          	lw	a5,-24(s0)
 6d6:	2781                	sext.w	a5,a5
 6d8:	cf85                	beqz	a5,710 <printint+0xe8>
    buf[i++] = '-';
 6da:	fec42783          	lw	a5,-20(s0)
 6de:	0017871b          	addiw	a4,a5,1
 6e2:	fee42623          	sw	a4,-20(s0)
 6e6:	17c1                	addi	a5,a5,-16
 6e8:	97a2                	add	a5,a5,s0
 6ea:	02d00713          	li	a4,45
 6ee:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6f2:	a839                	j	710 <printint+0xe8>
    putc(fd, buf[i]);
 6f4:	fec42783          	lw	a5,-20(s0)
 6f8:	17c1                	addi	a5,a5,-16
 6fa:	97a2                	add	a5,a5,s0
 6fc:	fe07c703          	lbu	a4,-32(a5)
 700:	fcc42783          	lw	a5,-52(s0)
 704:	85ba                	mv	a1,a4
 706:	853e                	mv	a0,a5
 708:	00000097          	auipc	ra,0x0
 70c:	eea080e7          	jalr	-278(ra) # 5f2 <putc>
  while(--i >= 0)
 710:	fec42783          	lw	a5,-20(s0)
 714:	37fd                	addiw	a5,a5,-1
 716:	fef42623          	sw	a5,-20(s0)
 71a:	fec42783          	lw	a5,-20(s0)
 71e:	2781                	sext.w	a5,a5
 720:	fc07dae3          	bgez	a5,6f4 <printint+0xcc>
}
 724:	0001                	nop
 726:	0001                	nop
 728:	70e2                	ld	ra,56(sp)
 72a:	7442                	ld	s0,48(sp)
 72c:	6121                	addi	sp,sp,64
 72e:	8082                	ret

0000000000000730 <printptr>:

static void
printptr(int fd, uint64 x) {
 730:	7179                	addi	sp,sp,-48
 732:	f406                	sd	ra,40(sp)
 734:	f022                	sd	s0,32(sp)
 736:	1800                	addi	s0,sp,48
 738:	87aa                	mv	a5,a0
 73a:	fcb43823          	sd	a1,-48(s0)
 73e:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 742:	fdc42783          	lw	a5,-36(s0)
 746:	03000593          	li	a1,48
 74a:	853e                	mv	a0,a5
 74c:	00000097          	auipc	ra,0x0
 750:	ea6080e7          	jalr	-346(ra) # 5f2 <putc>
  putc(fd, 'x');
 754:	fdc42783          	lw	a5,-36(s0)
 758:	07800593          	li	a1,120
 75c:	853e                	mv	a0,a5
 75e:	00000097          	auipc	ra,0x0
 762:	e94080e7          	jalr	-364(ra) # 5f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 766:	fe042623          	sw	zero,-20(s0)
 76a:	a82d                	j	7a4 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76c:	fd043783          	ld	a5,-48(s0)
 770:	93f1                	srli	a5,a5,0x3c
 772:	00001717          	auipc	a4,0x1
 776:	bfe70713          	addi	a4,a4,-1026 # 1370 <digits>
 77a:	97ba                	add	a5,a5,a4
 77c:	0007c703          	lbu	a4,0(a5)
 780:	fdc42783          	lw	a5,-36(s0)
 784:	85ba                	mv	a1,a4
 786:	853e                	mv	a0,a5
 788:	00000097          	auipc	ra,0x0
 78c:	e6a080e7          	jalr	-406(ra) # 5f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 790:	fec42783          	lw	a5,-20(s0)
 794:	2785                	addiw	a5,a5,1
 796:	fef42623          	sw	a5,-20(s0)
 79a:	fd043783          	ld	a5,-48(s0)
 79e:	0792                	slli	a5,a5,0x4
 7a0:	fcf43823          	sd	a5,-48(s0)
 7a4:	fec42783          	lw	a5,-20(s0)
 7a8:	873e                	mv	a4,a5
 7aa:	47bd                	li	a5,15
 7ac:	fce7f0e3          	bgeu	a5,a4,76c <printptr+0x3c>
}
 7b0:	0001                	nop
 7b2:	0001                	nop
 7b4:	70a2                	ld	ra,40(sp)
 7b6:	7402                	ld	s0,32(sp)
 7b8:	6145                	addi	sp,sp,48
 7ba:	8082                	ret

00000000000007bc <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7bc:	715d                	addi	sp,sp,-80
 7be:	e486                	sd	ra,72(sp)
 7c0:	e0a2                	sd	s0,64(sp)
 7c2:	0880                	addi	s0,sp,80
 7c4:	87aa                	mv	a5,a0
 7c6:	fcb43023          	sd	a1,-64(s0)
 7ca:	fac43c23          	sd	a2,-72(s0)
 7ce:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7d2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7d6:	fe042223          	sw	zero,-28(s0)
 7da:	a42d                	j	a04 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7dc:	fe442783          	lw	a5,-28(s0)
 7e0:	fc043703          	ld	a4,-64(s0)
 7e4:	97ba                	add	a5,a5,a4
 7e6:	0007c783          	lbu	a5,0(a5)
 7ea:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7ee:	fe042783          	lw	a5,-32(s0)
 7f2:	2781                	sext.w	a5,a5
 7f4:	eb9d                	bnez	a5,82a <vprintf+0x6e>
      if(c == '%'){
 7f6:	fdc42783          	lw	a5,-36(s0)
 7fa:	0007871b          	sext.w	a4,a5
 7fe:	02500793          	li	a5,37
 802:	00f71763          	bne	a4,a5,810 <vprintf+0x54>
        state = '%';
 806:	02500793          	li	a5,37
 80a:	fef42023          	sw	a5,-32(s0)
 80e:	a2f5                	j	9fa <vprintf+0x23e>
      } else {
        putc(fd, c);
 810:	fdc42783          	lw	a5,-36(s0)
 814:	0ff7f713          	zext.b	a4,a5
 818:	fcc42783          	lw	a5,-52(s0)
 81c:	85ba                	mv	a1,a4
 81e:	853e                	mv	a0,a5
 820:	00000097          	auipc	ra,0x0
 824:	dd2080e7          	jalr	-558(ra) # 5f2 <putc>
 828:	aac9                	j	9fa <vprintf+0x23e>
      }
    } else if(state == '%'){
 82a:	fe042783          	lw	a5,-32(s0)
 82e:	0007871b          	sext.w	a4,a5
 832:	02500793          	li	a5,37
 836:	1cf71263          	bne	a4,a5,9fa <vprintf+0x23e>
      if(c == 'd'){
 83a:	fdc42783          	lw	a5,-36(s0)
 83e:	0007871b          	sext.w	a4,a5
 842:	06400793          	li	a5,100
 846:	02f71463          	bne	a4,a5,86e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 84a:	fb843783          	ld	a5,-72(s0)
 84e:	00878713          	addi	a4,a5,8
 852:	fae43c23          	sd	a4,-72(s0)
 856:	4398                	lw	a4,0(a5)
 858:	fcc42783          	lw	a5,-52(s0)
 85c:	4685                	li	a3,1
 85e:	4629                	li	a2,10
 860:	85ba                	mv	a1,a4
 862:	853e                	mv	a0,a5
 864:	00000097          	auipc	ra,0x0
 868:	dc4080e7          	jalr	-572(ra) # 628 <printint>
 86c:	a269                	j	9f6 <vprintf+0x23a>
      } else if(c == 'l') {
 86e:	fdc42783          	lw	a5,-36(s0)
 872:	0007871b          	sext.w	a4,a5
 876:	06c00793          	li	a5,108
 87a:	02f71663          	bne	a4,a5,8a6 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 87e:	fb843783          	ld	a5,-72(s0)
 882:	00878713          	addi	a4,a5,8
 886:	fae43c23          	sd	a4,-72(s0)
 88a:	639c                	ld	a5,0(a5)
 88c:	0007871b          	sext.w	a4,a5
 890:	fcc42783          	lw	a5,-52(s0)
 894:	4681                	li	a3,0
 896:	4629                	li	a2,10
 898:	85ba                	mv	a1,a4
 89a:	853e                	mv	a0,a5
 89c:	00000097          	auipc	ra,0x0
 8a0:	d8c080e7          	jalr	-628(ra) # 628 <printint>
 8a4:	aa89                	j	9f6 <vprintf+0x23a>
      } else if(c == 'x') {
 8a6:	fdc42783          	lw	a5,-36(s0)
 8aa:	0007871b          	sext.w	a4,a5
 8ae:	07800793          	li	a5,120
 8b2:	02f71463          	bne	a4,a5,8da <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8b6:	fb843783          	ld	a5,-72(s0)
 8ba:	00878713          	addi	a4,a5,8
 8be:	fae43c23          	sd	a4,-72(s0)
 8c2:	4398                	lw	a4,0(a5)
 8c4:	fcc42783          	lw	a5,-52(s0)
 8c8:	4681                	li	a3,0
 8ca:	4641                	li	a2,16
 8cc:	85ba                	mv	a1,a4
 8ce:	853e                	mv	a0,a5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	d58080e7          	jalr	-680(ra) # 628 <printint>
 8d8:	aa39                	j	9f6 <vprintf+0x23a>
      } else if(c == 'p') {
 8da:	fdc42783          	lw	a5,-36(s0)
 8de:	0007871b          	sext.w	a4,a5
 8e2:	07000793          	li	a5,112
 8e6:	02f71263          	bne	a4,a5,90a <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8ea:	fb843783          	ld	a5,-72(s0)
 8ee:	00878713          	addi	a4,a5,8
 8f2:	fae43c23          	sd	a4,-72(s0)
 8f6:	6398                	ld	a4,0(a5)
 8f8:	fcc42783          	lw	a5,-52(s0)
 8fc:	85ba                	mv	a1,a4
 8fe:	853e                	mv	a0,a5
 900:	00000097          	auipc	ra,0x0
 904:	e30080e7          	jalr	-464(ra) # 730 <printptr>
 908:	a0fd                	j	9f6 <vprintf+0x23a>
      } else if(c == 's'){
 90a:	fdc42783          	lw	a5,-36(s0)
 90e:	0007871b          	sext.w	a4,a5
 912:	07300793          	li	a5,115
 916:	04f71c63          	bne	a4,a5,96e <vprintf+0x1b2>
        s = va_arg(ap, char*);
 91a:	fb843783          	ld	a5,-72(s0)
 91e:	00878713          	addi	a4,a5,8
 922:	fae43c23          	sd	a4,-72(s0)
 926:	639c                	ld	a5,0(a5)
 928:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 92c:	fe843783          	ld	a5,-24(s0)
 930:	eb8d                	bnez	a5,962 <vprintf+0x1a6>
          s = "(null)";
 932:	00000797          	auipc	a5,0x0
 936:	4ae78793          	addi	a5,a5,1198 # de0 <malloc+0x174>
 93a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 93e:	a015                	j	962 <vprintf+0x1a6>
          putc(fd, *s);
 940:	fe843783          	ld	a5,-24(s0)
 944:	0007c703          	lbu	a4,0(a5)
 948:	fcc42783          	lw	a5,-52(s0)
 94c:	85ba                	mv	a1,a4
 94e:	853e                	mv	a0,a5
 950:	00000097          	auipc	ra,0x0
 954:	ca2080e7          	jalr	-862(ra) # 5f2 <putc>
          s++;
 958:	fe843783          	ld	a5,-24(s0)
 95c:	0785                	addi	a5,a5,1
 95e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 962:	fe843783          	ld	a5,-24(s0)
 966:	0007c783          	lbu	a5,0(a5)
 96a:	fbf9                	bnez	a5,940 <vprintf+0x184>
 96c:	a069                	j	9f6 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 96e:	fdc42783          	lw	a5,-36(s0)
 972:	0007871b          	sext.w	a4,a5
 976:	06300793          	li	a5,99
 97a:	02f71463          	bne	a4,a5,9a2 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 97e:	fb843783          	ld	a5,-72(s0)
 982:	00878713          	addi	a4,a5,8
 986:	fae43c23          	sd	a4,-72(s0)
 98a:	439c                	lw	a5,0(a5)
 98c:	0ff7f713          	zext.b	a4,a5
 990:	fcc42783          	lw	a5,-52(s0)
 994:	85ba                	mv	a1,a4
 996:	853e                	mv	a0,a5
 998:	00000097          	auipc	ra,0x0
 99c:	c5a080e7          	jalr	-934(ra) # 5f2 <putc>
 9a0:	a899                	j	9f6 <vprintf+0x23a>
      } else if(c == '%'){
 9a2:	fdc42783          	lw	a5,-36(s0)
 9a6:	0007871b          	sext.w	a4,a5
 9aa:	02500793          	li	a5,37
 9ae:	00f71f63          	bne	a4,a5,9cc <vprintf+0x210>
        putc(fd, c);
 9b2:	fdc42783          	lw	a5,-36(s0)
 9b6:	0ff7f713          	zext.b	a4,a5
 9ba:	fcc42783          	lw	a5,-52(s0)
 9be:	85ba                	mv	a1,a4
 9c0:	853e                	mv	a0,a5
 9c2:	00000097          	auipc	ra,0x0
 9c6:	c30080e7          	jalr	-976(ra) # 5f2 <putc>
 9ca:	a035                	j	9f6 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9cc:	fcc42783          	lw	a5,-52(s0)
 9d0:	02500593          	li	a1,37
 9d4:	853e                	mv	a0,a5
 9d6:	00000097          	auipc	ra,0x0
 9da:	c1c080e7          	jalr	-996(ra) # 5f2 <putc>
        putc(fd, c);
 9de:	fdc42783          	lw	a5,-36(s0)
 9e2:	0ff7f713          	zext.b	a4,a5
 9e6:	fcc42783          	lw	a5,-52(s0)
 9ea:	85ba                	mv	a1,a4
 9ec:	853e                	mv	a0,a5
 9ee:	00000097          	auipc	ra,0x0
 9f2:	c04080e7          	jalr	-1020(ra) # 5f2 <putc>
      }
      state = 0;
 9f6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9fa:	fe442783          	lw	a5,-28(s0)
 9fe:	2785                	addiw	a5,a5,1
 a00:	fef42223          	sw	a5,-28(s0)
 a04:	fe442783          	lw	a5,-28(s0)
 a08:	fc043703          	ld	a4,-64(s0)
 a0c:	97ba                	add	a5,a5,a4
 a0e:	0007c783          	lbu	a5,0(a5)
 a12:	dc0795e3          	bnez	a5,7dc <vprintf+0x20>
    }
  }
}
 a16:	0001                	nop
 a18:	0001                	nop
 a1a:	60a6                	ld	ra,72(sp)
 a1c:	6406                	ld	s0,64(sp)
 a1e:	6161                	addi	sp,sp,80
 a20:	8082                	ret

0000000000000a22 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a22:	7159                	addi	sp,sp,-112
 a24:	fc06                	sd	ra,56(sp)
 a26:	f822                	sd	s0,48(sp)
 a28:	0080                	addi	s0,sp,64
 a2a:	fcb43823          	sd	a1,-48(s0)
 a2e:	e010                	sd	a2,0(s0)
 a30:	e414                	sd	a3,8(s0)
 a32:	e818                	sd	a4,16(s0)
 a34:	ec1c                	sd	a5,24(s0)
 a36:	03043023          	sd	a6,32(s0)
 a3a:	03143423          	sd	a7,40(s0)
 a3e:	87aa                	mv	a5,a0
 a40:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a44:	03040793          	addi	a5,s0,48
 a48:	fcf43423          	sd	a5,-56(s0)
 a4c:	fc843783          	ld	a5,-56(s0)
 a50:	fd078793          	addi	a5,a5,-48
 a54:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a58:	fe843703          	ld	a4,-24(s0)
 a5c:	fdc42783          	lw	a5,-36(s0)
 a60:	863a                	mv	a2,a4
 a62:	fd043583          	ld	a1,-48(s0)
 a66:	853e                	mv	a0,a5
 a68:	00000097          	auipc	ra,0x0
 a6c:	d54080e7          	jalr	-684(ra) # 7bc <vprintf>
}
 a70:	0001                	nop
 a72:	70e2                	ld	ra,56(sp)
 a74:	7442                	ld	s0,48(sp)
 a76:	6165                	addi	sp,sp,112
 a78:	8082                	ret

0000000000000a7a <printf>:

void
printf(const char *fmt, ...)
{
 a7a:	7159                	addi	sp,sp,-112
 a7c:	f406                	sd	ra,40(sp)
 a7e:	f022                	sd	s0,32(sp)
 a80:	1800                	addi	s0,sp,48
 a82:	fca43c23          	sd	a0,-40(s0)
 a86:	e40c                	sd	a1,8(s0)
 a88:	e810                	sd	a2,16(s0)
 a8a:	ec14                	sd	a3,24(s0)
 a8c:	f018                	sd	a4,32(s0)
 a8e:	f41c                	sd	a5,40(s0)
 a90:	03043823          	sd	a6,48(s0)
 a94:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a98:	04040793          	addi	a5,s0,64
 a9c:	fcf43823          	sd	a5,-48(s0)
 aa0:	fd043783          	ld	a5,-48(s0)
 aa4:	fc878793          	addi	a5,a5,-56
 aa8:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 aac:	fe843783          	ld	a5,-24(s0)
 ab0:	863e                	mv	a2,a5
 ab2:	fd843583          	ld	a1,-40(s0)
 ab6:	4505                	li	a0,1
 ab8:	00000097          	auipc	ra,0x0
 abc:	d04080e7          	jalr	-764(ra) # 7bc <vprintf>
}
 ac0:	0001                	nop
 ac2:	70a2                	ld	ra,40(sp)
 ac4:	7402                	ld	s0,32(sp)
 ac6:	6165                	addi	sp,sp,112
 ac8:	8082                	ret

0000000000000aca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aca:	7179                	addi	sp,sp,-48
 acc:	f422                	sd	s0,40(sp)
 ace:	1800                	addi	s0,sp,48
 ad0:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ad4:	fd843783          	ld	a5,-40(s0)
 ad8:	17c1                	addi	a5,a5,-16
 ada:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ade:	00001797          	auipc	a5,0x1
 ae2:	8c278793          	addi	a5,a5,-1854 # 13a0 <freep>
 ae6:	639c                	ld	a5,0(a5)
 ae8:	fef43423          	sd	a5,-24(s0)
 aec:	a815                	j	b20 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aee:	fe843783          	ld	a5,-24(s0)
 af2:	639c                	ld	a5,0(a5)
 af4:	fe843703          	ld	a4,-24(s0)
 af8:	00f76f63          	bltu	a4,a5,b16 <free+0x4c>
 afc:	fe043703          	ld	a4,-32(s0)
 b00:	fe843783          	ld	a5,-24(s0)
 b04:	02e7eb63          	bltu	a5,a4,b3a <free+0x70>
 b08:	fe843783          	ld	a5,-24(s0)
 b0c:	639c                	ld	a5,0(a5)
 b0e:	fe043703          	ld	a4,-32(s0)
 b12:	02f76463          	bltu	a4,a5,b3a <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b16:	fe843783          	ld	a5,-24(s0)
 b1a:	639c                	ld	a5,0(a5)
 b1c:	fef43423          	sd	a5,-24(s0)
 b20:	fe043703          	ld	a4,-32(s0)
 b24:	fe843783          	ld	a5,-24(s0)
 b28:	fce7f3e3          	bgeu	a5,a4,aee <free+0x24>
 b2c:	fe843783          	ld	a5,-24(s0)
 b30:	639c                	ld	a5,0(a5)
 b32:	fe043703          	ld	a4,-32(s0)
 b36:	faf77ce3          	bgeu	a4,a5,aee <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b3a:	fe043783          	ld	a5,-32(s0)
 b3e:	479c                	lw	a5,8(a5)
 b40:	1782                	slli	a5,a5,0x20
 b42:	9381                	srli	a5,a5,0x20
 b44:	0792                	slli	a5,a5,0x4
 b46:	fe043703          	ld	a4,-32(s0)
 b4a:	973e                	add	a4,a4,a5
 b4c:	fe843783          	ld	a5,-24(s0)
 b50:	639c                	ld	a5,0(a5)
 b52:	02f71763          	bne	a4,a5,b80 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b56:	fe043783          	ld	a5,-32(s0)
 b5a:	4798                	lw	a4,8(a5)
 b5c:	fe843783          	ld	a5,-24(s0)
 b60:	639c                	ld	a5,0(a5)
 b62:	479c                	lw	a5,8(a5)
 b64:	9fb9                	addw	a5,a5,a4
 b66:	0007871b          	sext.w	a4,a5
 b6a:	fe043783          	ld	a5,-32(s0)
 b6e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b70:	fe843783          	ld	a5,-24(s0)
 b74:	639c                	ld	a5,0(a5)
 b76:	6398                	ld	a4,0(a5)
 b78:	fe043783          	ld	a5,-32(s0)
 b7c:	e398                	sd	a4,0(a5)
 b7e:	a039                	j	b8c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b80:	fe843783          	ld	a5,-24(s0)
 b84:	6398                	ld	a4,0(a5)
 b86:	fe043783          	ld	a5,-32(s0)
 b8a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b8c:	fe843783          	ld	a5,-24(s0)
 b90:	479c                	lw	a5,8(a5)
 b92:	1782                	slli	a5,a5,0x20
 b94:	9381                	srli	a5,a5,0x20
 b96:	0792                	slli	a5,a5,0x4
 b98:	fe843703          	ld	a4,-24(s0)
 b9c:	97ba                	add	a5,a5,a4
 b9e:	fe043703          	ld	a4,-32(s0)
 ba2:	02f71563          	bne	a4,a5,bcc <free+0x102>
    p->s.size += bp->s.size;
 ba6:	fe843783          	ld	a5,-24(s0)
 baa:	4798                	lw	a4,8(a5)
 bac:	fe043783          	ld	a5,-32(s0)
 bb0:	479c                	lw	a5,8(a5)
 bb2:	9fb9                	addw	a5,a5,a4
 bb4:	0007871b          	sext.w	a4,a5
 bb8:	fe843783          	ld	a5,-24(s0)
 bbc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bbe:	fe043783          	ld	a5,-32(s0)
 bc2:	6398                	ld	a4,0(a5)
 bc4:	fe843783          	ld	a5,-24(s0)
 bc8:	e398                	sd	a4,0(a5)
 bca:	a031                	j	bd6 <free+0x10c>
  } else
    p->s.ptr = bp;
 bcc:	fe843783          	ld	a5,-24(s0)
 bd0:	fe043703          	ld	a4,-32(s0)
 bd4:	e398                	sd	a4,0(a5)
  freep = p;
 bd6:	00000797          	auipc	a5,0x0
 bda:	7ca78793          	addi	a5,a5,1994 # 13a0 <freep>
 bde:	fe843703          	ld	a4,-24(s0)
 be2:	e398                	sd	a4,0(a5)
}
 be4:	0001                	nop
 be6:	7422                	ld	s0,40(sp)
 be8:	6145                	addi	sp,sp,48
 bea:	8082                	ret

0000000000000bec <morecore>:

static Header*
morecore(uint nu)
{
 bec:	7179                	addi	sp,sp,-48
 bee:	f406                	sd	ra,40(sp)
 bf0:	f022                	sd	s0,32(sp)
 bf2:	1800                	addi	s0,sp,48
 bf4:	87aa                	mv	a5,a0
 bf6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bfa:	fdc42783          	lw	a5,-36(s0)
 bfe:	0007871b          	sext.w	a4,a5
 c02:	6785                	lui	a5,0x1
 c04:	00f77563          	bgeu	a4,a5,c0e <morecore+0x22>
    nu = 4096;
 c08:	6785                	lui	a5,0x1
 c0a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c0e:	fdc42783          	lw	a5,-36(s0)
 c12:	0047979b          	slliw	a5,a5,0x4
 c16:	2781                	sext.w	a5,a5
 c18:	2781                	sext.w	a5,a5
 c1a:	853e                	mv	a0,a5
 c1c:	00000097          	auipc	ra,0x0
 c20:	9a6080e7          	jalr	-1626(ra) # 5c2 <sbrk>
 c24:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c28:	fe843703          	ld	a4,-24(s0)
 c2c:	57fd                	li	a5,-1
 c2e:	00f71463          	bne	a4,a5,c36 <morecore+0x4a>
    return 0;
 c32:	4781                	li	a5,0
 c34:	a03d                	j	c62 <morecore+0x76>
  hp = (Header*)p;
 c36:	fe843783          	ld	a5,-24(s0)
 c3a:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c3e:	fe043783          	ld	a5,-32(s0)
 c42:	fdc42703          	lw	a4,-36(s0)
 c46:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c48:	fe043783          	ld	a5,-32(s0)
 c4c:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3a4>
 c4e:	853e                	mv	a0,a5
 c50:	00000097          	auipc	ra,0x0
 c54:	e7a080e7          	jalr	-390(ra) # aca <free>
  return freep;
 c58:	00000797          	auipc	a5,0x0
 c5c:	74878793          	addi	a5,a5,1864 # 13a0 <freep>
 c60:	639c                	ld	a5,0(a5)
}
 c62:	853e                	mv	a0,a5
 c64:	70a2                	ld	ra,40(sp)
 c66:	7402                	ld	s0,32(sp)
 c68:	6145                	addi	sp,sp,48
 c6a:	8082                	ret

0000000000000c6c <malloc>:

void*
malloc(uint nbytes)
{
 c6c:	7139                	addi	sp,sp,-64
 c6e:	fc06                	sd	ra,56(sp)
 c70:	f822                	sd	s0,48(sp)
 c72:	0080                	addi	s0,sp,64
 c74:	87aa                	mv	a5,a0
 c76:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c7a:	fcc46783          	lwu	a5,-52(s0)
 c7e:	07bd                	addi	a5,a5,15
 c80:	8391                	srli	a5,a5,0x4
 c82:	2781                	sext.w	a5,a5
 c84:	2785                	addiw	a5,a5,1
 c86:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c8a:	00000797          	auipc	a5,0x0
 c8e:	71678793          	addi	a5,a5,1814 # 13a0 <freep>
 c92:	639c                	ld	a5,0(a5)
 c94:	fef43023          	sd	a5,-32(s0)
 c98:	fe043783          	ld	a5,-32(s0)
 c9c:	ef95                	bnez	a5,cd8 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c9e:	00000797          	auipc	a5,0x0
 ca2:	6f278793          	addi	a5,a5,1778 # 1390 <base>
 ca6:	fef43023          	sd	a5,-32(s0)
 caa:	00000797          	auipc	a5,0x0
 cae:	6f678793          	addi	a5,a5,1782 # 13a0 <freep>
 cb2:	fe043703          	ld	a4,-32(s0)
 cb6:	e398                	sd	a4,0(a5)
 cb8:	00000797          	auipc	a5,0x0
 cbc:	6e878793          	addi	a5,a5,1768 # 13a0 <freep>
 cc0:	6398                	ld	a4,0(a5)
 cc2:	00000797          	auipc	a5,0x0
 cc6:	6ce78793          	addi	a5,a5,1742 # 1390 <base>
 cca:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 ccc:	00000797          	auipc	a5,0x0
 cd0:	6c478793          	addi	a5,a5,1732 # 1390 <base>
 cd4:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd8:	fe043783          	ld	a5,-32(s0)
 cdc:	639c                	ld	a5,0(a5)
 cde:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 ce2:	fe843783          	ld	a5,-24(s0)
 ce6:	4798                	lw	a4,8(a5)
 ce8:	fdc42783          	lw	a5,-36(s0)
 cec:	2781                	sext.w	a5,a5
 cee:	06f76763          	bltu	a4,a5,d5c <malloc+0xf0>
      if(p->s.size == nunits)
 cf2:	fe843783          	ld	a5,-24(s0)
 cf6:	4798                	lw	a4,8(a5)
 cf8:	fdc42783          	lw	a5,-36(s0)
 cfc:	2781                	sext.w	a5,a5
 cfe:	00e79963          	bne	a5,a4,d10 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d02:	fe843783          	ld	a5,-24(s0)
 d06:	6398                	ld	a4,0(a5)
 d08:	fe043783          	ld	a5,-32(s0)
 d0c:	e398                	sd	a4,0(a5)
 d0e:	a825                	j	d46 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d10:	fe843783          	ld	a5,-24(s0)
 d14:	479c                	lw	a5,8(a5)
 d16:	fdc42703          	lw	a4,-36(s0)
 d1a:	9f99                	subw	a5,a5,a4
 d1c:	0007871b          	sext.w	a4,a5
 d20:	fe843783          	ld	a5,-24(s0)
 d24:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d26:	fe843783          	ld	a5,-24(s0)
 d2a:	479c                	lw	a5,8(a5)
 d2c:	1782                	slli	a5,a5,0x20
 d2e:	9381                	srli	a5,a5,0x20
 d30:	0792                	slli	a5,a5,0x4
 d32:	fe843703          	ld	a4,-24(s0)
 d36:	97ba                	add	a5,a5,a4
 d38:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d3c:	fe843783          	ld	a5,-24(s0)
 d40:	fdc42703          	lw	a4,-36(s0)
 d44:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d46:	00000797          	auipc	a5,0x0
 d4a:	65a78793          	addi	a5,a5,1626 # 13a0 <freep>
 d4e:	fe043703          	ld	a4,-32(s0)
 d52:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d54:	fe843783          	ld	a5,-24(s0)
 d58:	07c1                	addi	a5,a5,16
 d5a:	a091                	j	d9e <malloc+0x132>
    }
    if(p == freep)
 d5c:	00000797          	auipc	a5,0x0
 d60:	64478793          	addi	a5,a5,1604 # 13a0 <freep>
 d64:	639c                	ld	a5,0(a5)
 d66:	fe843703          	ld	a4,-24(s0)
 d6a:	02f71063          	bne	a4,a5,d8a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d6e:	fdc42783          	lw	a5,-36(s0)
 d72:	853e                	mv	a0,a5
 d74:	00000097          	auipc	ra,0x0
 d78:	e78080e7          	jalr	-392(ra) # bec <morecore>
 d7c:	fea43423          	sd	a0,-24(s0)
 d80:	fe843783          	ld	a5,-24(s0)
 d84:	e399                	bnez	a5,d8a <malloc+0x11e>
        return 0;
 d86:	4781                	li	a5,0
 d88:	a819                	j	d9e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d8a:	fe843783          	ld	a5,-24(s0)
 d8e:	fef43023          	sd	a5,-32(s0)
 d92:	fe843783          	ld	a5,-24(s0)
 d96:	639c                	ld	a5,0(a5)
 d98:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d9c:	b799                	j	ce2 <malloc+0x76>
  }
}
 d9e:	853e                	mv	a0,a5
 da0:	70e2                	ld	ra,56(sp)
 da2:	7442                	ld	s0,48(sp)
 da4:	6121                	addi	sp,sp,64
 da6:	8082                	ret
