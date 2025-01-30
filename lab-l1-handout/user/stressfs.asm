
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	0480                	addi	s0,sp,576
   e:	87aa                	mv	a5,a0
  10:	dcb43023          	sd	a1,-576(s0)
  14:	dcf42623          	sw	a5,-564(s0)
  int fd, i;
  char path[] = "stressfs0";
  18:	00001797          	auipc	a5,0x1
  1c:	ec878793          	addi	a5,a5,-312 # ee0 <malloc+0x178>
  20:	6398                	ld	a4,0(a5)
  22:	fce43c23          	sd	a4,-40(s0)
  26:	0087d783          	lhu	a5,8(a5)
  2a:	fef41023          	sh	a5,-32(s0)
  char data[512];

  printf("stressfs starting\n");
  2e:	00001517          	auipc	a0,0x1
  32:	e8250513          	addi	a0,a0,-382 # eb0 <malloc+0x148>
  36:	00001097          	auipc	ra,0x1
  3a:	b40080e7          	jalr	-1216(ra) # b76 <printf>
  memset(data, 'a', sizeof(data));
  3e:	dd840793          	addi	a5,s0,-552
  42:	20000613          	li	a2,512
  46:	06100593          	li	a1,97
  4a:	853e                	mv	a0,a5
  4c:	00000097          	auipc	ra,0x0
  50:	23e080e7          	jalr	574(ra) # 28a <memset>

  for(i = 0; i < 4; i++)
  54:	fe042623          	sw	zero,-20(s0)
  58:	a829                	j	72 <main+0x72>
    if(fork() > 0)
  5a:	00000097          	auipc	ra,0x0
  5e:	5d4080e7          	jalr	1492(ra) # 62e <fork>
  62:	87aa                	mv	a5,a0
  64:	00f04f63          	bgtz	a5,82 <main+0x82>
  for(i = 0; i < 4; i++)
  68:	fec42783          	lw	a5,-20(s0)
  6c:	2785                	addiw	a5,a5,1
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	0007871b          	sext.w	a4,a5
  7a:	478d                	li	a5,3
  7c:	fce7dfe3          	bge	a5,a4,5a <main+0x5a>
  80:	a011                	j	84 <main+0x84>
      break;
  82:	0001                	nop

  printf("write %d\n", i);
  84:	fec42783          	lw	a5,-20(s0)
  88:	85be                	mv	a1,a5
  8a:	00001517          	auipc	a0,0x1
  8e:	e3e50513          	addi	a0,a0,-450 # ec8 <malloc+0x160>
  92:	00001097          	auipc	ra,0x1
  96:	ae4080e7          	jalr	-1308(ra) # b76 <printf>

  path[8] += i;
  9a:	fe044703          	lbu	a4,-32(s0)
  9e:	fec42783          	lw	a5,-20(s0)
  a2:	0ff7f793          	zext.b	a5,a5
  a6:	9fb9                	addw	a5,a5,a4
  a8:	0ff7f793          	zext.b	a5,a5
  ac:	fef40023          	sb	a5,-32(s0)
  fd = open(path, O_CREATE | O_RDWR);
  b0:	fd840793          	addi	a5,s0,-40
  b4:	20200593          	li	a1,514
  b8:	853e                	mv	a0,a5
  ba:	00000097          	auipc	ra,0x0
  be:	5bc080e7          	jalr	1468(ra) # 676 <open>
  c2:	87aa                	mv	a5,a0
  c4:	fef42423          	sw	a5,-24(s0)
  for(i = 0; i < 20; i++)
  c8:	fe042623          	sw	zero,-20(s0)
  cc:	a015                	j	f0 <main+0xf0>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ce:	dd840713          	addi	a4,s0,-552
  d2:	fe842783          	lw	a5,-24(s0)
  d6:	20000613          	li	a2,512
  da:	85ba                	mv	a1,a4
  dc:	853e                	mv	a0,a5
  de:	00000097          	auipc	ra,0x0
  e2:	578080e7          	jalr	1400(ra) # 656 <write>
  for(i = 0; i < 20; i++)
  e6:	fec42783          	lw	a5,-20(s0)
  ea:	2785                	addiw	a5,a5,1
  ec:	fef42623          	sw	a5,-20(s0)
  f0:	fec42783          	lw	a5,-20(s0)
  f4:	0007871b          	sext.w	a4,a5
  f8:	47cd                	li	a5,19
  fa:	fce7dae3          	bge	a5,a4,ce <main+0xce>
  close(fd);
  fe:	fe842783          	lw	a5,-24(s0)
 102:	853e                	mv	a0,a5
 104:	00000097          	auipc	ra,0x0
 108:	55a080e7          	jalr	1370(ra) # 65e <close>

  printf("read\n");
 10c:	00001517          	auipc	a0,0x1
 110:	dcc50513          	addi	a0,a0,-564 # ed8 <malloc+0x170>
 114:	00001097          	auipc	ra,0x1
 118:	a62080e7          	jalr	-1438(ra) # b76 <printf>

  fd = open(path, O_RDONLY);
 11c:	fd840793          	addi	a5,s0,-40
 120:	4581                	li	a1,0
 122:	853e                	mv	a0,a5
 124:	00000097          	auipc	ra,0x0
 128:	552080e7          	jalr	1362(ra) # 676 <open>
 12c:	87aa                	mv	a5,a0
 12e:	fef42423          	sw	a5,-24(s0)
  for (i = 0; i < 20; i++)
 132:	fe042623          	sw	zero,-20(s0)
 136:	a015                	j	15a <main+0x15a>
    read(fd, data, sizeof(data));
 138:	dd840713          	addi	a4,s0,-552
 13c:	fe842783          	lw	a5,-24(s0)
 140:	20000613          	li	a2,512
 144:	85ba                	mv	a1,a4
 146:	853e                	mv	a0,a5
 148:	00000097          	auipc	ra,0x0
 14c:	506080e7          	jalr	1286(ra) # 64e <read>
  for (i = 0; i < 20; i++)
 150:	fec42783          	lw	a5,-20(s0)
 154:	2785                	addiw	a5,a5,1
 156:	fef42623          	sw	a5,-20(s0)
 15a:	fec42783          	lw	a5,-20(s0)
 15e:	0007871b          	sext.w	a4,a5
 162:	47cd                	li	a5,19
 164:	fce7dae3          	bge	a5,a4,138 <main+0x138>
  close(fd);
 168:	fe842783          	lw	a5,-24(s0)
 16c:	853e                	mv	a0,a5
 16e:	00000097          	auipc	ra,0x0
 172:	4f0080e7          	jalr	1264(ra) # 65e <close>

  wait(0);
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	4c6080e7          	jalr	1222(ra) # 63e <wait>

  exit(0);
 180:	4501                	li	a0,0
 182:	00000097          	auipc	ra,0x0
 186:	4b4080e7          	jalr	1204(ra) # 636 <exit>

000000000000018a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  extern int main();
  main();
 192:	00000097          	auipc	ra,0x0
 196:	e6e080e7          	jalr	-402(ra) # 0 <main>
  exit(0);
 19a:	4501                	li	a0,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	49a080e7          	jalr	1178(ra) # 636 <exit>

00000000000001a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a4:	7179                	addi	sp,sp,-48
 1a6:	f422                	sd	s0,40(sp)
 1a8:	1800                	addi	s0,sp,48
 1aa:	fca43c23          	sd	a0,-40(s0)
 1ae:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 1b2:	fd843783          	ld	a5,-40(s0)
 1b6:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 1ba:	0001                	nop
 1bc:	fd043703          	ld	a4,-48(s0)
 1c0:	00170793          	addi	a5,a4,1
 1c4:	fcf43823          	sd	a5,-48(s0)
 1c8:	fd843783          	ld	a5,-40(s0)
 1cc:	00178693          	addi	a3,a5,1
 1d0:	fcd43c23          	sd	a3,-40(s0)
 1d4:	00074703          	lbu	a4,0(a4)
 1d8:	00e78023          	sb	a4,0(a5)
 1dc:	0007c783          	lbu	a5,0(a5)
 1e0:	fff1                	bnez	a5,1bc <strcpy+0x18>
    ;
  return os;
 1e2:	fe843783          	ld	a5,-24(s0)
}
 1e6:	853e                	mv	a0,a5
 1e8:	7422                	ld	s0,40(sp)
 1ea:	6145                	addi	sp,sp,48
 1ec:	8082                	ret

00000000000001ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ee:	1101                	addi	sp,sp,-32
 1f0:	ec22                	sd	s0,24(sp)
 1f2:	1000                	addi	s0,sp,32
 1f4:	fea43423          	sd	a0,-24(s0)
 1f8:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 1fc:	a819                	j	212 <strcmp+0x24>
    p++, q++;
 1fe:	fe843783          	ld	a5,-24(s0)
 202:	0785                	addi	a5,a5,1
 204:	fef43423          	sd	a5,-24(s0)
 208:	fe043783          	ld	a5,-32(s0)
 20c:	0785                	addi	a5,a5,1
 20e:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 212:	fe843783          	ld	a5,-24(s0)
 216:	0007c783          	lbu	a5,0(a5)
 21a:	cb99                	beqz	a5,230 <strcmp+0x42>
 21c:	fe843783          	ld	a5,-24(s0)
 220:	0007c703          	lbu	a4,0(a5)
 224:	fe043783          	ld	a5,-32(s0)
 228:	0007c783          	lbu	a5,0(a5)
 22c:	fcf709e3          	beq	a4,a5,1fe <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 230:	fe843783          	ld	a5,-24(s0)
 234:	0007c783          	lbu	a5,0(a5)
 238:	0007871b          	sext.w	a4,a5
 23c:	fe043783          	ld	a5,-32(s0)
 240:	0007c783          	lbu	a5,0(a5)
 244:	2781                	sext.w	a5,a5
 246:	40f707bb          	subw	a5,a4,a5
 24a:	2781                	sext.w	a5,a5
}
 24c:	853e                	mv	a0,a5
 24e:	6462                	ld	s0,24(sp)
 250:	6105                	addi	sp,sp,32
 252:	8082                	ret

0000000000000254 <strlen>:

uint
strlen(const char *s)
{
 254:	7179                	addi	sp,sp,-48
 256:	f422                	sd	s0,40(sp)
 258:	1800                	addi	s0,sp,48
 25a:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 25e:	fe042623          	sw	zero,-20(s0)
 262:	a031                	j	26e <strlen+0x1a>
 264:	fec42783          	lw	a5,-20(s0)
 268:	2785                	addiw	a5,a5,1
 26a:	fef42623          	sw	a5,-20(s0)
 26e:	fec42783          	lw	a5,-20(s0)
 272:	fd843703          	ld	a4,-40(s0)
 276:	97ba                	add	a5,a5,a4
 278:	0007c783          	lbu	a5,0(a5)
 27c:	f7e5                	bnez	a5,264 <strlen+0x10>
    ;
  return n;
 27e:	fec42783          	lw	a5,-20(s0)
}
 282:	853e                	mv	a0,a5
 284:	7422                	ld	s0,40(sp)
 286:	6145                	addi	sp,sp,48
 288:	8082                	ret

000000000000028a <memset>:

void*
memset(void *dst, int c, uint n)
{
 28a:	7179                	addi	sp,sp,-48
 28c:	f422                	sd	s0,40(sp)
 28e:	1800                	addi	s0,sp,48
 290:	fca43c23          	sd	a0,-40(s0)
 294:	87ae                	mv	a5,a1
 296:	8732                	mv	a4,a2
 298:	fcf42a23          	sw	a5,-44(s0)
 29c:	87ba                	mv	a5,a4
 29e:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 2a2:	fd843783          	ld	a5,-40(s0)
 2a6:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 2aa:	fe042623          	sw	zero,-20(s0)
 2ae:	a00d                	j	2d0 <memset+0x46>
    cdst[i] = c;
 2b0:	fec42783          	lw	a5,-20(s0)
 2b4:	fe043703          	ld	a4,-32(s0)
 2b8:	97ba                	add	a5,a5,a4
 2ba:	fd442703          	lw	a4,-44(s0)
 2be:	0ff77713          	zext.b	a4,a4
 2c2:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 2c6:	fec42783          	lw	a5,-20(s0)
 2ca:	2785                	addiw	a5,a5,1
 2cc:	fef42623          	sw	a5,-20(s0)
 2d0:	fec42703          	lw	a4,-20(s0)
 2d4:	fd042783          	lw	a5,-48(s0)
 2d8:	2781                	sext.w	a5,a5
 2da:	fcf76be3          	bltu	a4,a5,2b0 <memset+0x26>
  }
  return dst;
 2de:	fd843783          	ld	a5,-40(s0)
}
 2e2:	853e                	mv	a0,a5
 2e4:	7422                	ld	s0,40(sp)
 2e6:	6145                	addi	sp,sp,48
 2e8:	8082                	ret

00000000000002ea <strchr>:

char*
strchr(const char *s, char c)
{
 2ea:	1101                	addi	sp,sp,-32
 2ec:	ec22                	sd	s0,24(sp)
 2ee:	1000                	addi	s0,sp,32
 2f0:	fea43423          	sd	a0,-24(s0)
 2f4:	87ae                	mv	a5,a1
 2f6:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 2fa:	a01d                	j	320 <strchr+0x36>
    if(*s == c)
 2fc:	fe843783          	ld	a5,-24(s0)
 300:	0007c703          	lbu	a4,0(a5)
 304:	fe744783          	lbu	a5,-25(s0)
 308:	0ff7f793          	zext.b	a5,a5
 30c:	00e79563          	bne	a5,a4,316 <strchr+0x2c>
      return (char*)s;
 310:	fe843783          	ld	a5,-24(s0)
 314:	a821                	j	32c <strchr+0x42>
  for(; *s; s++)
 316:	fe843783          	ld	a5,-24(s0)
 31a:	0785                	addi	a5,a5,1
 31c:	fef43423          	sd	a5,-24(s0)
 320:	fe843783          	ld	a5,-24(s0)
 324:	0007c783          	lbu	a5,0(a5)
 328:	fbf1                	bnez	a5,2fc <strchr+0x12>
  return 0;
 32a:	4781                	li	a5,0
}
 32c:	853e                	mv	a0,a5
 32e:	6462                	ld	s0,24(sp)
 330:	6105                	addi	sp,sp,32
 332:	8082                	ret

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	7179                	addi	sp,sp,-48
 336:	f406                	sd	ra,40(sp)
 338:	f022                	sd	s0,32(sp)
 33a:	1800                	addi	s0,sp,48
 33c:	fca43c23          	sd	a0,-40(s0)
 340:	87ae                	mv	a5,a1
 342:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	fe042623          	sw	zero,-20(s0)
 34a:	a8a1                	j	3a2 <gets+0x6e>
    cc = read(0, &c, 1);
 34c:	fe740793          	addi	a5,s0,-25
 350:	4605                	li	a2,1
 352:	85be                	mv	a1,a5
 354:	4501                	li	a0,0
 356:	00000097          	auipc	ra,0x0
 35a:	2f8080e7          	jalr	760(ra) # 64e <read>
 35e:	87aa                	mv	a5,a0
 360:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 364:	fe842783          	lw	a5,-24(s0)
 368:	2781                	sext.w	a5,a5
 36a:	04f05763          	blez	a5,3b8 <gets+0x84>
      break;
    buf[i++] = c;
 36e:	fec42783          	lw	a5,-20(s0)
 372:	0017871b          	addiw	a4,a5,1
 376:	fee42623          	sw	a4,-20(s0)
 37a:	873e                	mv	a4,a5
 37c:	fd843783          	ld	a5,-40(s0)
 380:	97ba                	add	a5,a5,a4
 382:	fe744703          	lbu	a4,-25(s0)
 386:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 38a:	fe744783          	lbu	a5,-25(s0)
 38e:	873e                	mv	a4,a5
 390:	47a9                	li	a5,10
 392:	02f70463          	beq	a4,a5,3ba <gets+0x86>
 396:	fe744783          	lbu	a5,-25(s0)
 39a:	873e                	mv	a4,a5
 39c:	47b5                	li	a5,13
 39e:	00f70e63          	beq	a4,a5,3ba <gets+0x86>
  for(i=0; i+1 < max; ){
 3a2:	fec42783          	lw	a5,-20(s0)
 3a6:	2785                	addiw	a5,a5,1
 3a8:	0007871b          	sext.w	a4,a5
 3ac:	fd442783          	lw	a5,-44(s0)
 3b0:	2781                	sext.w	a5,a5
 3b2:	f8f74de3          	blt	a4,a5,34c <gets+0x18>
 3b6:	a011                	j	3ba <gets+0x86>
      break;
 3b8:	0001                	nop
      break;
  }
  buf[i] = '\0';
 3ba:	fec42783          	lw	a5,-20(s0)
 3be:	fd843703          	ld	a4,-40(s0)
 3c2:	97ba                	add	a5,a5,a4
 3c4:	00078023          	sb	zero,0(a5)
  return buf;
 3c8:	fd843783          	ld	a5,-40(s0)
}
 3cc:	853e                	mv	a0,a5
 3ce:	70a2                	ld	ra,40(sp)
 3d0:	7402                	ld	s0,32(sp)
 3d2:	6145                	addi	sp,sp,48
 3d4:	8082                	ret

00000000000003d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d6:	7179                	addi	sp,sp,-48
 3d8:	f406                	sd	ra,40(sp)
 3da:	f022                	sd	s0,32(sp)
 3dc:	1800                	addi	s0,sp,48
 3de:	fca43c23          	sd	a0,-40(s0)
 3e2:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e6:	4581                	li	a1,0
 3e8:	fd843503          	ld	a0,-40(s0)
 3ec:	00000097          	auipc	ra,0x0
 3f0:	28a080e7          	jalr	650(ra) # 676 <open>
 3f4:	87aa                	mv	a5,a0
 3f6:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 3fa:	fec42783          	lw	a5,-20(s0)
 3fe:	2781                	sext.w	a5,a5
 400:	0007d463          	bgez	a5,408 <stat+0x32>
    return -1;
 404:	57fd                	li	a5,-1
 406:	a035                	j	432 <stat+0x5c>
  r = fstat(fd, st);
 408:	fec42783          	lw	a5,-20(s0)
 40c:	fd043583          	ld	a1,-48(s0)
 410:	853e                	mv	a0,a5
 412:	00000097          	auipc	ra,0x0
 416:	27c080e7          	jalr	636(ra) # 68e <fstat>
 41a:	87aa                	mv	a5,a0
 41c:	fef42423          	sw	a5,-24(s0)
  close(fd);
 420:	fec42783          	lw	a5,-20(s0)
 424:	853e                	mv	a0,a5
 426:	00000097          	auipc	ra,0x0
 42a:	238080e7          	jalr	568(ra) # 65e <close>
  return r;
 42e:	fe842783          	lw	a5,-24(s0)
}
 432:	853e                	mv	a0,a5
 434:	70a2                	ld	ra,40(sp)
 436:	7402                	ld	s0,32(sp)
 438:	6145                	addi	sp,sp,48
 43a:	8082                	ret

000000000000043c <atoi>:

int
atoi(const char *s)
{
 43c:	7179                	addi	sp,sp,-48
 43e:	f422                	sd	s0,40(sp)
 440:	1800                	addi	s0,sp,48
 442:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 446:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 44a:	a81d                	j	480 <atoi+0x44>
    n = n*10 + *s++ - '0';
 44c:	fec42783          	lw	a5,-20(s0)
 450:	873e                	mv	a4,a5
 452:	87ba                	mv	a5,a4
 454:	0027979b          	slliw	a5,a5,0x2
 458:	9fb9                	addw	a5,a5,a4
 45a:	0017979b          	slliw	a5,a5,0x1
 45e:	0007871b          	sext.w	a4,a5
 462:	fd843783          	ld	a5,-40(s0)
 466:	00178693          	addi	a3,a5,1
 46a:	fcd43c23          	sd	a3,-40(s0)
 46e:	0007c783          	lbu	a5,0(a5)
 472:	2781                	sext.w	a5,a5
 474:	9fb9                	addw	a5,a5,a4
 476:	2781                	sext.w	a5,a5
 478:	fd07879b          	addiw	a5,a5,-48
 47c:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 480:	fd843783          	ld	a5,-40(s0)
 484:	0007c783          	lbu	a5,0(a5)
 488:	873e                	mv	a4,a5
 48a:	02f00793          	li	a5,47
 48e:	00e7fb63          	bgeu	a5,a4,4a4 <atoi+0x68>
 492:	fd843783          	ld	a5,-40(s0)
 496:	0007c783          	lbu	a5,0(a5)
 49a:	873e                	mv	a4,a5
 49c:	03900793          	li	a5,57
 4a0:	fae7f6e3          	bgeu	a5,a4,44c <atoi+0x10>
  return n;
 4a4:	fec42783          	lw	a5,-20(s0)
}
 4a8:	853e                	mv	a0,a5
 4aa:	7422                	ld	s0,40(sp)
 4ac:	6145                	addi	sp,sp,48
 4ae:	8082                	ret

00000000000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	7139                	addi	sp,sp,-64
 4b2:	fc22                	sd	s0,56(sp)
 4b4:	0080                	addi	s0,sp,64
 4b6:	fca43c23          	sd	a0,-40(s0)
 4ba:	fcb43823          	sd	a1,-48(s0)
 4be:	87b2                	mv	a5,a2
 4c0:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 4c4:	fd843783          	ld	a5,-40(s0)
 4c8:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 4cc:	fd043783          	ld	a5,-48(s0)
 4d0:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 4d4:	fe043703          	ld	a4,-32(s0)
 4d8:	fe843783          	ld	a5,-24(s0)
 4dc:	02e7fc63          	bgeu	a5,a4,514 <memmove+0x64>
    while(n-- > 0)
 4e0:	a00d                	j	502 <memmove+0x52>
      *dst++ = *src++;
 4e2:	fe043703          	ld	a4,-32(s0)
 4e6:	00170793          	addi	a5,a4,1
 4ea:	fef43023          	sd	a5,-32(s0)
 4ee:	fe843783          	ld	a5,-24(s0)
 4f2:	00178693          	addi	a3,a5,1
 4f6:	fed43423          	sd	a3,-24(s0)
 4fa:	00074703          	lbu	a4,0(a4)
 4fe:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 502:	fcc42783          	lw	a5,-52(s0)
 506:	fff7871b          	addiw	a4,a5,-1
 50a:	fce42623          	sw	a4,-52(s0)
 50e:	fcf04ae3          	bgtz	a5,4e2 <memmove+0x32>
 512:	a891                	j	566 <memmove+0xb6>
  } else {
    dst += n;
 514:	fcc42783          	lw	a5,-52(s0)
 518:	fe843703          	ld	a4,-24(s0)
 51c:	97ba                	add	a5,a5,a4
 51e:	fef43423          	sd	a5,-24(s0)
    src += n;
 522:	fcc42783          	lw	a5,-52(s0)
 526:	fe043703          	ld	a4,-32(s0)
 52a:	97ba                	add	a5,a5,a4
 52c:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 530:	a01d                	j	556 <memmove+0xa6>
      *--dst = *--src;
 532:	fe043783          	ld	a5,-32(s0)
 536:	17fd                	addi	a5,a5,-1
 538:	fef43023          	sd	a5,-32(s0)
 53c:	fe843783          	ld	a5,-24(s0)
 540:	17fd                	addi	a5,a5,-1
 542:	fef43423          	sd	a5,-24(s0)
 546:	fe043783          	ld	a5,-32(s0)
 54a:	0007c703          	lbu	a4,0(a5)
 54e:	fe843783          	ld	a5,-24(s0)
 552:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 556:	fcc42783          	lw	a5,-52(s0)
 55a:	fff7871b          	addiw	a4,a5,-1
 55e:	fce42623          	sw	a4,-52(s0)
 562:	fcf048e3          	bgtz	a5,532 <memmove+0x82>
  }
  return vdst;
 566:	fd843783          	ld	a5,-40(s0)
}
 56a:	853e                	mv	a0,a5
 56c:	7462                	ld	s0,56(sp)
 56e:	6121                	addi	sp,sp,64
 570:	8082                	ret

0000000000000572 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 572:	7139                	addi	sp,sp,-64
 574:	fc22                	sd	s0,56(sp)
 576:	0080                	addi	s0,sp,64
 578:	fca43c23          	sd	a0,-40(s0)
 57c:	fcb43823          	sd	a1,-48(s0)
 580:	87b2                	mv	a5,a2
 582:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 586:	fd843783          	ld	a5,-40(s0)
 58a:	fef43423          	sd	a5,-24(s0)
 58e:	fd043783          	ld	a5,-48(s0)
 592:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 596:	a0a1                	j	5de <memcmp+0x6c>
    if (*p1 != *p2) {
 598:	fe843783          	ld	a5,-24(s0)
 59c:	0007c703          	lbu	a4,0(a5)
 5a0:	fe043783          	ld	a5,-32(s0)
 5a4:	0007c783          	lbu	a5,0(a5)
 5a8:	02f70163          	beq	a4,a5,5ca <memcmp+0x58>
      return *p1 - *p2;
 5ac:	fe843783          	ld	a5,-24(s0)
 5b0:	0007c783          	lbu	a5,0(a5)
 5b4:	0007871b          	sext.w	a4,a5
 5b8:	fe043783          	ld	a5,-32(s0)
 5bc:	0007c783          	lbu	a5,0(a5)
 5c0:	2781                	sext.w	a5,a5
 5c2:	40f707bb          	subw	a5,a4,a5
 5c6:	2781                	sext.w	a5,a5
 5c8:	a01d                	j	5ee <memcmp+0x7c>
    }
    p1++;
 5ca:	fe843783          	ld	a5,-24(s0)
 5ce:	0785                	addi	a5,a5,1
 5d0:	fef43423          	sd	a5,-24(s0)
    p2++;
 5d4:	fe043783          	ld	a5,-32(s0)
 5d8:	0785                	addi	a5,a5,1
 5da:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5de:	fcc42783          	lw	a5,-52(s0)
 5e2:	fff7871b          	addiw	a4,a5,-1
 5e6:	fce42623          	sw	a4,-52(s0)
 5ea:	f7dd                	bnez	a5,598 <memcmp+0x26>
  }
  return 0;
 5ec:	4781                	li	a5,0
}
 5ee:	853e                	mv	a0,a5
 5f0:	7462                	ld	s0,56(sp)
 5f2:	6121                	addi	sp,sp,64
 5f4:	8082                	ret

00000000000005f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5f6:	7179                	addi	sp,sp,-48
 5f8:	f406                	sd	ra,40(sp)
 5fa:	f022                	sd	s0,32(sp)
 5fc:	1800                	addi	s0,sp,48
 5fe:	fea43423          	sd	a0,-24(s0)
 602:	feb43023          	sd	a1,-32(s0)
 606:	87b2                	mv	a5,a2
 608:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 60c:	fdc42783          	lw	a5,-36(s0)
 610:	863e                	mv	a2,a5
 612:	fe043583          	ld	a1,-32(s0)
 616:	fe843503          	ld	a0,-24(s0)
 61a:	00000097          	auipc	ra,0x0
 61e:	e96080e7          	jalr	-362(ra) # 4b0 <memmove>
 622:	87aa                	mv	a5,a0
}
 624:	853e                	mv	a0,a5
 626:	70a2                	ld	ra,40(sp)
 628:	7402                	ld	s0,32(sp)
 62a:	6145                	addi	sp,sp,48
 62c:	8082                	ret

000000000000062e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 62e:	4885                	li	a7,1
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <exit>:
.global exit
exit:
 li a7, SYS_exit
 636:	4889                	li	a7,2
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <wait>:
.global wait
wait:
 li a7, SYS_wait
 63e:	488d                	li	a7,3
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 646:	4891                	li	a7,4
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <read>:
.global read
read:
 li a7, SYS_read
 64e:	4895                	li	a7,5
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <write>:
.global write
write:
 li a7, SYS_write
 656:	48c1                	li	a7,16
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <close>:
.global close
close:
 li a7, SYS_close
 65e:	48d5                	li	a7,21
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <kill>:
.global kill
kill:
 li a7, SYS_kill
 666:	4899                	li	a7,6
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <exec>:
.global exec
exec:
 li a7, SYS_exec
 66e:	489d                	li	a7,7
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <open>:
.global open
open:
 li a7, SYS_open
 676:	48bd                	li	a7,15
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 67e:	48c5                	li	a7,17
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 686:	48c9                	li	a7,18
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 68e:	48a1                	li	a7,8
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <link>:
.global link
link:
 li a7, SYS_link
 696:	48cd                	li	a7,19
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 69e:	48d1                	li	a7,20
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6a6:	48a5                	li	a7,9
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 6ae:	48a9                	li	a7,10
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6b6:	48ad                	li	a7,11
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6be:	48b1                	li	a7,12
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6c6:	48b5                	li	a7,13
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ce:	48b9                	li	a7,14
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <hello>:
.global hello
hello:
 li a7, SYS_hello
 6d6:	48d9                	li	a7,22
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 6de:	48dd                	li	a7,23
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 6e6:	48e1                	li	a7,24
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6ee:	1101                	addi	sp,sp,-32
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	e822                	sd	s0,16(sp)
 6f4:	1000                	addi	s0,sp,32
 6f6:	87aa                	mv	a5,a0
 6f8:	872e                	mv	a4,a1
 6fa:	fef42623          	sw	a5,-20(s0)
 6fe:	87ba                	mv	a5,a4
 700:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 704:	feb40713          	addi	a4,s0,-21
 708:	fec42783          	lw	a5,-20(s0)
 70c:	4605                	li	a2,1
 70e:	85ba                	mv	a1,a4
 710:	853e                	mv	a0,a5
 712:	00000097          	auipc	ra,0x0
 716:	f44080e7          	jalr	-188(ra) # 656 <write>
}
 71a:	0001                	nop
 71c:	60e2                	ld	ra,24(sp)
 71e:	6442                	ld	s0,16(sp)
 720:	6105                	addi	sp,sp,32
 722:	8082                	ret

0000000000000724 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 724:	7139                	addi	sp,sp,-64
 726:	fc06                	sd	ra,56(sp)
 728:	f822                	sd	s0,48(sp)
 72a:	0080                	addi	s0,sp,64
 72c:	87aa                	mv	a5,a0
 72e:	8736                	mv	a4,a3
 730:	fcf42623          	sw	a5,-52(s0)
 734:	87ae                	mv	a5,a1
 736:	fcf42423          	sw	a5,-56(s0)
 73a:	87b2                	mv	a5,a2
 73c:	fcf42223          	sw	a5,-60(s0)
 740:	87ba                	mv	a5,a4
 742:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 746:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 74a:	fc042783          	lw	a5,-64(s0)
 74e:	2781                	sext.w	a5,a5
 750:	c38d                	beqz	a5,772 <printint+0x4e>
 752:	fc842783          	lw	a5,-56(s0)
 756:	2781                	sext.w	a5,a5
 758:	0007dd63          	bgez	a5,772 <printint+0x4e>
    neg = 1;
 75c:	4785                	li	a5,1
 75e:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 762:	fc842783          	lw	a5,-56(s0)
 766:	40f007bb          	negw	a5,a5
 76a:	2781                	sext.w	a5,a5
 76c:	fef42223          	sw	a5,-28(s0)
 770:	a029                	j	77a <printint+0x56>
  } else {
    x = xx;
 772:	fc842783          	lw	a5,-56(s0)
 776:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 77a:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 77e:	fc442783          	lw	a5,-60(s0)
 782:	fe442703          	lw	a4,-28(s0)
 786:	02f777bb          	remuw	a5,a4,a5
 78a:	0007861b          	sext.w	a2,a5
 78e:	fec42783          	lw	a5,-20(s0)
 792:	0017871b          	addiw	a4,a5,1
 796:	fee42623          	sw	a4,-20(s0)
 79a:	00001697          	auipc	a3,0x1
 79e:	bd668693          	addi	a3,a3,-1066 # 1370 <digits>
 7a2:	02061713          	slli	a4,a2,0x20
 7a6:	9301                	srli	a4,a4,0x20
 7a8:	9736                	add	a4,a4,a3
 7aa:	00074703          	lbu	a4,0(a4)
 7ae:	17c1                	addi	a5,a5,-16
 7b0:	97a2                	add	a5,a5,s0
 7b2:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 7b6:	fc442783          	lw	a5,-60(s0)
 7ba:	fe442703          	lw	a4,-28(s0)
 7be:	02f757bb          	divuw	a5,a4,a5
 7c2:	fef42223          	sw	a5,-28(s0)
 7c6:	fe442783          	lw	a5,-28(s0)
 7ca:	2781                	sext.w	a5,a5
 7cc:	fbcd                	bnez	a5,77e <printint+0x5a>
  if(neg)
 7ce:	fe842783          	lw	a5,-24(s0)
 7d2:	2781                	sext.w	a5,a5
 7d4:	cf85                	beqz	a5,80c <printint+0xe8>
    buf[i++] = '-';
 7d6:	fec42783          	lw	a5,-20(s0)
 7da:	0017871b          	addiw	a4,a5,1
 7de:	fee42623          	sw	a4,-20(s0)
 7e2:	17c1                	addi	a5,a5,-16
 7e4:	97a2                	add	a5,a5,s0
 7e6:	02d00713          	li	a4,45
 7ea:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7ee:	a839                	j	80c <printint+0xe8>
    putc(fd, buf[i]);
 7f0:	fec42783          	lw	a5,-20(s0)
 7f4:	17c1                	addi	a5,a5,-16
 7f6:	97a2                	add	a5,a5,s0
 7f8:	fe07c703          	lbu	a4,-32(a5)
 7fc:	fcc42783          	lw	a5,-52(s0)
 800:	85ba                	mv	a1,a4
 802:	853e                	mv	a0,a5
 804:	00000097          	auipc	ra,0x0
 808:	eea080e7          	jalr	-278(ra) # 6ee <putc>
  while(--i >= 0)
 80c:	fec42783          	lw	a5,-20(s0)
 810:	37fd                	addiw	a5,a5,-1
 812:	fef42623          	sw	a5,-20(s0)
 816:	fec42783          	lw	a5,-20(s0)
 81a:	2781                	sext.w	a5,a5
 81c:	fc07dae3          	bgez	a5,7f0 <printint+0xcc>
}
 820:	0001                	nop
 822:	0001                	nop
 824:	70e2                	ld	ra,56(sp)
 826:	7442                	ld	s0,48(sp)
 828:	6121                	addi	sp,sp,64
 82a:	8082                	ret

000000000000082c <printptr>:

static void
printptr(int fd, uint64 x) {
 82c:	7179                	addi	sp,sp,-48
 82e:	f406                	sd	ra,40(sp)
 830:	f022                	sd	s0,32(sp)
 832:	1800                	addi	s0,sp,48
 834:	87aa                	mv	a5,a0
 836:	fcb43823          	sd	a1,-48(s0)
 83a:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 83e:	fdc42783          	lw	a5,-36(s0)
 842:	03000593          	li	a1,48
 846:	853e                	mv	a0,a5
 848:	00000097          	auipc	ra,0x0
 84c:	ea6080e7          	jalr	-346(ra) # 6ee <putc>
  putc(fd, 'x');
 850:	fdc42783          	lw	a5,-36(s0)
 854:	07800593          	li	a1,120
 858:	853e                	mv	a0,a5
 85a:	00000097          	auipc	ra,0x0
 85e:	e94080e7          	jalr	-364(ra) # 6ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 862:	fe042623          	sw	zero,-20(s0)
 866:	a82d                	j	8a0 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 868:	fd043783          	ld	a5,-48(s0)
 86c:	93f1                	srli	a5,a5,0x3c
 86e:	00001717          	auipc	a4,0x1
 872:	b0270713          	addi	a4,a4,-1278 # 1370 <digits>
 876:	97ba                	add	a5,a5,a4
 878:	0007c703          	lbu	a4,0(a5)
 87c:	fdc42783          	lw	a5,-36(s0)
 880:	85ba                	mv	a1,a4
 882:	853e                	mv	a0,a5
 884:	00000097          	auipc	ra,0x0
 888:	e6a080e7          	jalr	-406(ra) # 6ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 88c:	fec42783          	lw	a5,-20(s0)
 890:	2785                	addiw	a5,a5,1
 892:	fef42623          	sw	a5,-20(s0)
 896:	fd043783          	ld	a5,-48(s0)
 89a:	0792                	slli	a5,a5,0x4
 89c:	fcf43823          	sd	a5,-48(s0)
 8a0:	fec42783          	lw	a5,-20(s0)
 8a4:	873e                	mv	a4,a5
 8a6:	47bd                	li	a5,15
 8a8:	fce7f0e3          	bgeu	a5,a4,868 <printptr+0x3c>
}
 8ac:	0001                	nop
 8ae:	0001                	nop
 8b0:	70a2                	ld	ra,40(sp)
 8b2:	7402                	ld	s0,32(sp)
 8b4:	6145                	addi	sp,sp,48
 8b6:	8082                	ret

00000000000008b8 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8b8:	715d                	addi	sp,sp,-80
 8ba:	e486                	sd	ra,72(sp)
 8bc:	e0a2                	sd	s0,64(sp)
 8be:	0880                	addi	s0,sp,80
 8c0:	87aa                	mv	a5,a0
 8c2:	fcb43023          	sd	a1,-64(s0)
 8c6:	fac43c23          	sd	a2,-72(s0)
 8ca:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8ce:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8d2:	fe042223          	sw	zero,-28(s0)
 8d6:	a42d                	j	b00 <vprintf+0x248>
    c = fmt[i] & 0xff;
 8d8:	fe442783          	lw	a5,-28(s0)
 8dc:	fc043703          	ld	a4,-64(s0)
 8e0:	97ba                	add	a5,a5,a4
 8e2:	0007c783          	lbu	a5,0(a5)
 8e6:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8ea:	fe042783          	lw	a5,-32(s0)
 8ee:	2781                	sext.w	a5,a5
 8f0:	eb9d                	bnez	a5,926 <vprintf+0x6e>
      if(c == '%'){
 8f2:	fdc42783          	lw	a5,-36(s0)
 8f6:	0007871b          	sext.w	a4,a5
 8fa:	02500793          	li	a5,37
 8fe:	00f71763          	bne	a4,a5,90c <vprintf+0x54>
        state = '%';
 902:	02500793          	li	a5,37
 906:	fef42023          	sw	a5,-32(s0)
 90a:	a2f5                	j	af6 <vprintf+0x23e>
      } else {
        putc(fd, c);
 90c:	fdc42783          	lw	a5,-36(s0)
 910:	0ff7f713          	zext.b	a4,a5
 914:	fcc42783          	lw	a5,-52(s0)
 918:	85ba                	mv	a1,a4
 91a:	853e                	mv	a0,a5
 91c:	00000097          	auipc	ra,0x0
 920:	dd2080e7          	jalr	-558(ra) # 6ee <putc>
 924:	aac9                	j	af6 <vprintf+0x23e>
      }
    } else if(state == '%'){
 926:	fe042783          	lw	a5,-32(s0)
 92a:	0007871b          	sext.w	a4,a5
 92e:	02500793          	li	a5,37
 932:	1cf71263          	bne	a4,a5,af6 <vprintf+0x23e>
      if(c == 'd'){
 936:	fdc42783          	lw	a5,-36(s0)
 93a:	0007871b          	sext.w	a4,a5
 93e:	06400793          	li	a5,100
 942:	02f71463          	bne	a4,a5,96a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 946:	fb843783          	ld	a5,-72(s0)
 94a:	00878713          	addi	a4,a5,8
 94e:	fae43c23          	sd	a4,-72(s0)
 952:	4398                	lw	a4,0(a5)
 954:	fcc42783          	lw	a5,-52(s0)
 958:	4685                	li	a3,1
 95a:	4629                	li	a2,10
 95c:	85ba                	mv	a1,a4
 95e:	853e                	mv	a0,a5
 960:	00000097          	auipc	ra,0x0
 964:	dc4080e7          	jalr	-572(ra) # 724 <printint>
 968:	a269                	j	af2 <vprintf+0x23a>
      } else if(c == 'l') {
 96a:	fdc42783          	lw	a5,-36(s0)
 96e:	0007871b          	sext.w	a4,a5
 972:	06c00793          	li	a5,108
 976:	02f71663          	bne	a4,a5,9a2 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 97a:	fb843783          	ld	a5,-72(s0)
 97e:	00878713          	addi	a4,a5,8
 982:	fae43c23          	sd	a4,-72(s0)
 986:	639c                	ld	a5,0(a5)
 988:	0007871b          	sext.w	a4,a5
 98c:	fcc42783          	lw	a5,-52(s0)
 990:	4681                	li	a3,0
 992:	4629                	li	a2,10
 994:	85ba                	mv	a1,a4
 996:	853e                	mv	a0,a5
 998:	00000097          	auipc	ra,0x0
 99c:	d8c080e7          	jalr	-628(ra) # 724 <printint>
 9a0:	aa89                	j	af2 <vprintf+0x23a>
      } else if(c == 'x') {
 9a2:	fdc42783          	lw	a5,-36(s0)
 9a6:	0007871b          	sext.w	a4,a5
 9aa:	07800793          	li	a5,120
 9ae:	02f71463          	bne	a4,a5,9d6 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 9b2:	fb843783          	ld	a5,-72(s0)
 9b6:	00878713          	addi	a4,a5,8
 9ba:	fae43c23          	sd	a4,-72(s0)
 9be:	4398                	lw	a4,0(a5)
 9c0:	fcc42783          	lw	a5,-52(s0)
 9c4:	4681                	li	a3,0
 9c6:	4641                	li	a2,16
 9c8:	85ba                	mv	a1,a4
 9ca:	853e                	mv	a0,a5
 9cc:	00000097          	auipc	ra,0x0
 9d0:	d58080e7          	jalr	-680(ra) # 724 <printint>
 9d4:	aa39                	j	af2 <vprintf+0x23a>
      } else if(c == 'p') {
 9d6:	fdc42783          	lw	a5,-36(s0)
 9da:	0007871b          	sext.w	a4,a5
 9de:	07000793          	li	a5,112
 9e2:	02f71263          	bne	a4,a5,a06 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9e6:	fb843783          	ld	a5,-72(s0)
 9ea:	00878713          	addi	a4,a5,8
 9ee:	fae43c23          	sd	a4,-72(s0)
 9f2:	6398                	ld	a4,0(a5)
 9f4:	fcc42783          	lw	a5,-52(s0)
 9f8:	85ba                	mv	a1,a4
 9fa:	853e                	mv	a0,a5
 9fc:	00000097          	auipc	ra,0x0
 a00:	e30080e7          	jalr	-464(ra) # 82c <printptr>
 a04:	a0fd                	j	af2 <vprintf+0x23a>
      } else if(c == 's'){
 a06:	fdc42783          	lw	a5,-36(s0)
 a0a:	0007871b          	sext.w	a4,a5
 a0e:	07300793          	li	a5,115
 a12:	04f71c63          	bne	a4,a5,a6a <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a16:	fb843783          	ld	a5,-72(s0)
 a1a:	00878713          	addi	a4,a5,8
 a1e:	fae43c23          	sd	a4,-72(s0)
 a22:	639c                	ld	a5,0(a5)
 a24:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a28:	fe843783          	ld	a5,-24(s0)
 a2c:	eb8d                	bnez	a5,a5e <vprintf+0x1a6>
          s = "(null)";
 a2e:	00000797          	auipc	a5,0x0
 a32:	4c278793          	addi	a5,a5,1218 # ef0 <malloc+0x188>
 a36:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a3a:	a015                	j	a5e <vprintf+0x1a6>
          putc(fd, *s);
 a3c:	fe843783          	ld	a5,-24(s0)
 a40:	0007c703          	lbu	a4,0(a5)
 a44:	fcc42783          	lw	a5,-52(s0)
 a48:	85ba                	mv	a1,a4
 a4a:	853e                	mv	a0,a5
 a4c:	00000097          	auipc	ra,0x0
 a50:	ca2080e7          	jalr	-862(ra) # 6ee <putc>
          s++;
 a54:	fe843783          	ld	a5,-24(s0)
 a58:	0785                	addi	a5,a5,1
 a5a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a5e:	fe843783          	ld	a5,-24(s0)
 a62:	0007c783          	lbu	a5,0(a5)
 a66:	fbf9                	bnez	a5,a3c <vprintf+0x184>
 a68:	a069                	j	af2 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a6a:	fdc42783          	lw	a5,-36(s0)
 a6e:	0007871b          	sext.w	a4,a5
 a72:	06300793          	li	a5,99
 a76:	02f71463          	bne	a4,a5,a9e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a7a:	fb843783          	ld	a5,-72(s0)
 a7e:	00878713          	addi	a4,a5,8
 a82:	fae43c23          	sd	a4,-72(s0)
 a86:	439c                	lw	a5,0(a5)
 a88:	0ff7f713          	zext.b	a4,a5
 a8c:	fcc42783          	lw	a5,-52(s0)
 a90:	85ba                	mv	a1,a4
 a92:	853e                	mv	a0,a5
 a94:	00000097          	auipc	ra,0x0
 a98:	c5a080e7          	jalr	-934(ra) # 6ee <putc>
 a9c:	a899                	j	af2 <vprintf+0x23a>
      } else if(c == '%'){
 a9e:	fdc42783          	lw	a5,-36(s0)
 aa2:	0007871b          	sext.w	a4,a5
 aa6:	02500793          	li	a5,37
 aaa:	00f71f63          	bne	a4,a5,ac8 <vprintf+0x210>
        putc(fd, c);
 aae:	fdc42783          	lw	a5,-36(s0)
 ab2:	0ff7f713          	zext.b	a4,a5
 ab6:	fcc42783          	lw	a5,-52(s0)
 aba:	85ba                	mv	a1,a4
 abc:	853e                	mv	a0,a5
 abe:	00000097          	auipc	ra,0x0
 ac2:	c30080e7          	jalr	-976(ra) # 6ee <putc>
 ac6:	a035                	j	af2 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ac8:	fcc42783          	lw	a5,-52(s0)
 acc:	02500593          	li	a1,37
 ad0:	853e                	mv	a0,a5
 ad2:	00000097          	auipc	ra,0x0
 ad6:	c1c080e7          	jalr	-996(ra) # 6ee <putc>
        putc(fd, c);
 ada:	fdc42783          	lw	a5,-36(s0)
 ade:	0ff7f713          	zext.b	a4,a5
 ae2:	fcc42783          	lw	a5,-52(s0)
 ae6:	85ba                	mv	a1,a4
 ae8:	853e                	mv	a0,a5
 aea:	00000097          	auipc	ra,0x0
 aee:	c04080e7          	jalr	-1020(ra) # 6ee <putc>
      }
      state = 0;
 af2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 af6:	fe442783          	lw	a5,-28(s0)
 afa:	2785                	addiw	a5,a5,1
 afc:	fef42223          	sw	a5,-28(s0)
 b00:	fe442783          	lw	a5,-28(s0)
 b04:	fc043703          	ld	a4,-64(s0)
 b08:	97ba                	add	a5,a5,a4
 b0a:	0007c783          	lbu	a5,0(a5)
 b0e:	dc0795e3          	bnez	a5,8d8 <vprintf+0x20>
    }
  }
}
 b12:	0001                	nop
 b14:	0001                	nop
 b16:	60a6                	ld	ra,72(sp)
 b18:	6406                	ld	s0,64(sp)
 b1a:	6161                	addi	sp,sp,80
 b1c:	8082                	ret

0000000000000b1e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b1e:	7159                	addi	sp,sp,-112
 b20:	fc06                	sd	ra,56(sp)
 b22:	f822                	sd	s0,48(sp)
 b24:	0080                	addi	s0,sp,64
 b26:	fcb43823          	sd	a1,-48(s0)
 b2a:	e010                	sd	a2,0(s0)
 b2c:	e414                	sd	a3,8(s0)
 b2e:	e818                	sd	a4,16(s0)
 b30:	ec1c                	sd	a5,24(s0)
 b32:	03043023          	sd	a6,32(s0)
 b36:	03143423          	sd	a7,40(s0)
 b3a:	87aa                	mv	a5,a0
 b3c:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b40:	03040793          	addi	a5,s0,48
 b44:	fcf43423          	sd	a5,-56(s0)
 b48:	fc843783          	ld	a5,-56(s0)
 b4c:	fd078793          	addi	a5,a5,-48
 b50:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b54:	fe843703          	ld	a4,-24(s0)
 b58:	fdc42783          	lw	a5,-36(s0)
 b5c:	863a                	mv	a2,a4
 b5e:	fd043583          	ld	a1,-48(s0)
 b62:	853e                	mv	a0,a5
 b64:	00000097          	auipc	ra,0x0
 b68:	d54080e7          	jalr	-684(ra) # 8b8 <vprintf>
}
 b6c:	0001                	nop
 b6e:	70e2                	ld	ra,56(sp)
 b70:	7442                	ld	s0,48(sp)
 b72:	6165                	addi	sp,sp,112
 b74:	8082                	ret

0000000000000b76 <printf>:

void
printf(const char *fmt, ...)
{
 b76:	7159                	addi	sp,sp,-112
 b78:	f406                	sd	ra,40(sp)
 b7a:	f022                	sd	s0,32(sp)
 b7c:	1800                	addi	s0,sp,48
 b7e:	fca43c23          	sd	a0,-40(s0)
 b82:	e40c                	sd	a1,8(s0)
 b84:	e810                	sd	a2,16(s0)
 b86:	ec14                	sd	a3,24(s0)
 b88:	f018                	sd	a4,32(s0)
 b8a:	f41c                	sd	a5,40(s0)
 b8c:	03043823          	sd	a6,48(s0)
 b90:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b94:	04040793          	addi	a5,s0,64
 b98:	fcf43823          	sd	a5,-48(s0)
 b9c:	fd043783          	ld	a5,-48(s0)
 ba0:	fc878793          	addi	a5,a5,-56
 ba4:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ba8:	fe843783          	ld	a5,-24(s0)
 bac:	863e                	mv	a2,a5
 bae:	fd843583          	ld	a1,-40(s0)
 bb2:	4505                	li	a0,1
 bb4:	00000097          	auipc	ra,0x0
 bb8:	d04080e7          	jalr	-764(ra) # 8b8 <vprintf>
}
 bbc:	0001                	nop
 bbe:	70a2                	ld	ra,40(sp)
 bc0:	7402                	ld	s0,32(sp)
 bc2:	6165                	addi	sp,sp,112
 bc4:	8082                	ret

0000000000000bc6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bc6:	7179                	addi	sp,sp,-48
 bc8:	f422                	sd	s0,40(sp)
 bca:	1800                	addi	s0,sp,48
 bcc:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bd0:	fd843783          	ld	a5,-40(s0)
 bd4:	17c1                	addi	a5,a5,-16
 bd6:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bda:	00000797          	auipc	a5,0x0
 bde:	7c678793          	addi	a5,a5,1990 # 13a0 <freep>
 be2:	639c                	ld	a5,0(a5)
 be4:	fef43423          	sd	a5,-24(s0)
 be8:	a815                	j	c1c <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bea:	fe843783          	ld	a5,-24(s0)
 bee:	639c                	ld	a5,0(a5)
 bf0:	fe843703          	ld	a4,-24(s0)
 bf4:	00f76f63          	bltu	a4,a5,c12 <free+0x4c>
 bf8:	fe043703          	ld	a4,-32(s0)
 bfc:	fe843783          	ld	a5,-24(s0)
 c00:	02e7eb63          	bltu	a5,a4,c36 <free+0x70>
 c04:	fe843783          	ld	a5,-24(s0)
 c08:	639c                	ld	a5,0(a5)
 c0a:	fe043703          	ld	a4,-32(s0)
 c0e:	02f76463          	bltu	a4,a5,c36 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c12:	fe843783          	ld	a5,-24(s0)
 c16:	639c                	ld	a5,0(a5)
 c18:	fef43423          	sd	a5,-24(s0)
 c1c:	fe043703          	ld	a4,-32(s0)
 c20:	fe843783          	ld	a5,-24(s0)
 c24:	fce7f3e3          	bgeu	a5,a4,bea <free+0x24>
 c28:	fe843783          	ld	a5,-24(s0)
 c2c:	639c                	ld	a5,0(a5)
 c2e:	fe043703          	ld	a4,-32(s0)
 c32:	faf77ce3          	bgeu	a4,a5,bea <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c36:	fe043783          	ld	a5,-32(s0)
 c3a:	479c                	lw	a5,8(a5)
 c3c:	1782                	slli	a5,a5,0x20
 c3e:	9381                	srli	a5,a5,0x20
 c40:	0792                	slli	a5,a5,0x4
 c42:	fe043703          	ld	a4,-32(s0)
 c46:	973e                	add	a4,a4,a5
 c48:	fe843783          	ld	a5,-24(s0)
 c4c:	639c                	ld	a5,0(a5)
 c4e:	02f71763          	bne	a4,a5,c7c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 c52:	fe043783          	ld	a5,-32(s0)
 c56:	4798                	lw	a4,8(a5)
 c58:	fe843783          	ld	a5,-24(s0)
 c5c:	639c                	ld	a5,0(a5)
 c5e:	479c                	lw	a5,8(a5)
 c60:	9fb9                	addw	a5,a5,a4
 c62:	0007871b          	sext.w	a4,a5
 c66:	fe043783          	ld	a5,-32(s0)
 c6a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c6c:	fe843783          	ld	a5,-24(s0)
 c70:	639c                	ld	a5,0(a5)
 c72:	6398                	ld	a4,0(a5)
 c74:	fe043783          	ld	a5,-32(s0)
 c78:	e398                	sd	a4,0(a5)
 c7a:	a039                	j	c88 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 c7c:	fe843783          	ld	a5,-24(s0)
 c80:	6398                	ld	a4,0(a5)
 c82:	fe043783          	ld	a5,-32(s0)
 c86:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c88:	fe843783          	ld	a5,-24(s0)
 c8c:	479c                	lw	a5,8(a5)
 c8e:	1782                	slli	a5,a5,0x20
 c90:	9381                	srli	a5,a5,0x20
 c92:	0792                	slli	a5,a5,0x4
 c94:	fe843703          	ld	a4,-24(s0)
 c98:	97ba                	add	a5,a5,a4
 c9a:	fe043703          	ld	a4,-32(s0)
 c9e:	02f71563          	bne	a4,a5,cc8 <free+0x102>
    p->s.size += bp->s.size;
 ca2:	fe843783          	ld	a5,-24(s0)
 ca6:	4798                	lw	a4,8(a5)
 ca8:	fe043783          	ld	a5,-32(s0)
 cac:	479c                	lw	a5,8(a5)
 cae:	9fb9                	addw	a5,a5,a4
 cb0:	0007871b          	sext.w	a4,a5
 cb4:	fe843783          	ld	a5,-24(s0)
 cb8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cba:	fe043783          	ld	a5,-32(s0)
 cbe:	6398                	ld	a4,0(a5)
 cc0:	fe843783          	ld	a5,-24(s0)
 cc4:	e398                	sd	a4,0(a5)
 cc6:	a031                	j	cd2 <free+0x10c>
  } else
    p->s.ptr = bp;
 cc8:	fe843783          	ld	a5,-24(s0)
 ccc:	fe043703          	ld	a4,-32(s0)
 cd0:	e398                	sd	a4,0(a5)
  freep = p;
 cd2:	00000797          	auipc	a5,0x0
 cd6:	6ce78793          	addi	a5,a5,1742 # 13a0 <freep>
 cda:	fe843703          	ld	a4,-24(s0)
 cde:	e398                	sd	a4,0(a5)
}
 ce0:	0001                	nop
 ce2:	7422                	ld	s0,40(sp)
 ce4:	6145                	addi	sp,sp,48
 ce6:	8082                	ret

0000000000000ce8 <morecore>:

static Header*
morecore(uint nu)
{
 ce8:	7179                	addi	sp,sp,-48
 cea:	f406                	sd	ra,40(sp)
 cec:	f022                	sd	s0,32(sp)
 cee:	1800                	addi	s0,sp,48
 cf0:	87aa                	mv	a5,a0
 cf2:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 cf6:	fdc42783          	lw	a5,-36(s0)
 cfa:	0007871b          	sext.w	a4,a5
 cfe:	6785                	lui	a5,0x1
 d00:	00f77563          	bgeu	a4,a5,d0a <morecore+0x22>
    nu = 4096;
 d04:	6785                	lui	a5,0x1
 d06:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d0a:	fdc42783          	lw	a5,-36(s0)
 d0e:	0047979b          	slliw	a5,a5,0x4
 d12:	2781                	sext.w	a5,a5
 d14:	2781                	sext.w	a5,a5
 d16:	853e                	mv	a0,a5
 d18:	00000097          	auipc	ra,0x0
 d1c:	9a6080e7          	jalr	-1626(ra) # 6be <sbrk>
 d20:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d24:	fe843703          	ld	a4,-24(s0)
 d28:	57fd                	li	a5,-1
 d2a:	00f71463          	bne	a4,a5,d32 <morecore+0x4a>
    return 0;
 d2e:	4781                	li	a5,0
 d30:	a03d                	j	d5e <morecore+0x76>
  hp = (Header*)p;
 d32:	fe843783          	ld	a5,-24(s0)
 d36:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d3a:	fe043783          	ld	a5,-32(s0)
 d3e:	fdc42703          	lw	a4,-36(s0)
 d42:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d44:	fe043783          	ld	a5,-32(s0)
 d48:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x2a8>
 d4a:	853e                	mv	a0,a5
 d4c:	00000097          	auipc	ra,0x0
 d50:	e7a080e7          	jalr	-390(ra) # bc6 <free>
  return freep;
 d54:	00000797          	auipc	a5,0x0
 d58:	64c78793          	addi	a5,a5,1612 # 13a0 <freep>
 d5c:	639c                	ld	a5,0(a5)
}
 d5e:	853e                	mv	a0,a5
 d60:	70a2                	ld	ra,40(sp)
 d62:	7402                	ld	s0,32(sp)
 d64:	6145                	addi	sp,sp,48
 d66:	8082                	ret

0000000000000d68 <malloc>:

void*
malloc(uint nbytes)
{
 d68:	7139                	addi	sp,sp,-64
 d6a:	fc06                	sd	ra,56(sp)
 d6c:	f822                	sd	s0,48(sp)
 d6e:	0080                	addi	s0,sp,64
 d70:	87aa                	mv	a5,a0
 d72:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d76:	fcc46783          	lwu	a5,-52(s0)
 d7a:	07bd                	addi	a5,a5,15
 d7c:	8391                	srli	a5,a5,0x4
 d7e:	2781                	sext.w	a5,a5
 d80:	2785                	addiw	a5,a5,1
 d82:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d86:	00000797          	auipc	a5,0x0
 d8a:	61a78793          	addi	a5,a5,1562 # 13a0 <freep>
 d8e:	639c                	ld	a5,0(a5)
 d90:	fef43023          	sd	a5,-32(s0)
 d94:	fe043783          	ld	a5,-32(s0)
 d98:	ef95                	bnez	a5,dd4 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d9a:	00000797          	auipc	a5,0x0
 d9e:	5f678793          	addi	a5,a5,1526 # 1390 <base>
 da2:	fef43023          	sd	a5,-32(s0)
 da6:	00000797          	auipc	a5,0x0
 daa:	5fa78793          	addi	a5,a5,1530 # 13a0 <freep>
 dae:	fe043703          	ld	a4,-32(s0)
 db2:	e398                	sd	a4,0(a5)
 db4:	00000797          	auipc	a5,0x0
 db8:	5ec78793          	addi	a5,a5,1516 # 13a0 <freep>
 dbc:	6398                	ld	a4,0(a5)
 dbe:	00000797          	auipc	a5,0x0
 dc2:	5d278793          	addi	a5,a5,1490 # 1390 <base>
 dc6:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 dc8:	00000797          	auipc	a5,0x0
 dcc:	5c878793          	addi	a5,a5,1480 # 1390 <base>
 dd0:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dd4:	fe043783          	ld	a5,-32(s0)
 dd8:	639c                	ld	a5,0(a5)
 dda:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dde:	fe843783          	ld	a5,-24(s0)
 de2:	4798                	lw	a4,8(a5)
 de4:	fdc42783          	lw	a5,-36(s0)
 de8:	2781                	sext.w	a5,a5
 dea:	06f76763          	bltu	a4,a5,e58 <malloc+0xf0>
      if(p->s.size == nunits)
 dee:	fe843783          	ld	a5,-24(s0)
 df2:	4798                	lw	a4,8(a5)
 df4:	fdc42783          	lw	a5,-36(s0)
 df8:	2781                	sext.w	a5,a5
 dfa:	00e79963          	bne	a5,a4,e0c <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 dfe:	fe843783          	ld	a5,-24(s0)
 e02:	6398                	ld	a4,0(a5)
 e04:	fe043783          	ld	a5,-32(s0)
 e08:	e398                	sd	a4,0(a5)
 e0a:	a825                	j	e42 <malloc+0xda>
      else {
        p->s.size -= nunits;
 e0c:	fe843783          	ld	a5,-24(s0)
 e10:	479c                	lw	a5,8(a5)
 e12:	fdc42703          	lw	a4,-36(s0)
 e16:	9f99                	subw	a5,a5,a4
 e18:	0007871b          	sext.w	a4,a5
 e1c:	fe843783          	ld	a5,-24(s0)
 e20:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e22:	fe843783          	ld	a5,-24(s0)
 e26:	479c                	lw	a5,8(a5)
 e28:	1782                	slli	a5,a5,0x20
 e2a:	9381                	srli	a5,a5,0x20
 e2c:	0792                	slli	a5,a5,0x4
 e2e:	fe843703          	ld	a4,-24(s0)
 e32:	97ba                	add	a5,a5,a4
 e34:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e38:	fe843783          	ld	a5,-24(s0)
 e3c:	fdc42703          	lw	a4,-36(s0)
 e40:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e42:	00000797          	auipc	a5,0x0
 e46:	55e78793          	addi	a5,a5,1374 # 13a0 <freep>
 e4a:	fe043703          	ld	a4,-32(s0)
 e4e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e50:	fe843783          	ld	a5,-24(s0)
 e54:	07c1                	addi	a5,a5,16
 e56:	a091                	j	e9a <malloc+0x132>
    }
    if(p == freep)
 e58:	00000797          	auipc	a5,0x0
 e5c:	54878793          	addi	a5,a5,1352 # 13a0 <freep>
 e60:	639c                	ld	a5,0(a5)
 e62:	fe843703          	ld	a4,-24(s0)
 e66:	02f71063          	bne	a4,a5,e86 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e6a:	fdc42783          	lw	a5,-36(s0)
 e6e:	853e                	mv	a0,a5
 e70:	00000097          	auipc	ra,0x0
 e74:	e78080e7          	jalr	-392(ra) # ce8 <morecore>
 e78:	fea43423          	sd	a0,-24(s0)
 e7c:	fe843783          	ld	a5,-24(s0)
 e80:	e399                	bnez	a5,e86 <malloc+0x11e>
        return 0;
 e82:	4781                	li	a5,0
 e84:	a819                	j	e9a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e86:	fe843783          	ld	a5,-24(s0)
 e8a:	fef43023          	sd	a5,-32(s0)
 e8e:	fe843783          	ld	a5,-24(s0)
 e92:	639c                	ld	a5,0(a5)
 e94:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e98:	b799                	j	dde <malloc+0x76>
  }
}
 e9a:	853e                	mv	a0,a5
 e9c:	70e2                	ld	ra,56(sp)
 e9e:	7442                	ld	s0,48(sp)
 ea0:	6121                	addi	sp,sp,64
 ea2:	8082                	ret
