
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
  1c:	eb878793          	addi	a5,a5,-328 # ed0 <malloc+0x170>
  20:	6398                	ld	a4,0(a5)
  22:	fce43c23          	sd	a4,-40(s0)
  26:	0087d783          	lhu	a5,8(a5)
  2a:	fef41023          	sh	a5,-32(s0)
  char data[512];

  printf("stressfs starting\n");
  2e:	00001517          	auipc	a0,0x1
  32:	e7250513          	addi	a0,a0,-398 # ea0 <malloc+0x140>
  36:	00001097          	auipc	ra,0x1
  3a:	b38080e7          	jalr	-1224(ra) # b6e <printf>
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
  8e:	e2e50513          	addi	a0,a0,-466 # eb8 <malloc+0x158>
  92:	00001097          	auipc	ra,0x1
  96:	adc080e7          	jalr	-1316(ra) # b6e <printf>

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
 110:	dbc50513          	addi	a0,a0,-580 # ec8 <malloc+0x168>
 114:	00001097          	auipc	ra,0x1
 118:	a5a080e7          	jalr	-1446(ra) # b6e <printf>

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

00000000000006e6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6e6:	1101                	addi	sp,sp,-32
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	87aa                	mv	a5,a0
 6f0:	872e                	mv	a4,a1
 6f2:	fef42623          	sw	a5,-20(s0)
 6f6:	87ba                	mv	a5,a4
 6f8:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 6fc:	feb40713          	addi	a4,s0,-21
 700:	fec42783          	lw	a5,-20(s0)
 704:	4605                	li	a2,1
 706:	85ba                	mv	a1,a4
 708:	853e                	mv	a0,a5
 70a:	00000097          	auipc	ra,0x0
 70e:	f4c080e7          	jalr	-180(ra) # 656 <write>
}
 712:	0001                	nop
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6105                	addi	sp,sp,32
 71a:	8082                	ret

000000000000071c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 71c:	7139                	addi	sp,sp,-64
 71e:	fc06                	sd	ra,56(sp)
 720:	f822                	sd	s0,48(sp)
 722:	0080                	addi	s0,sp,64
 724:	87aa                	mv	a5,a0
 726:	8736                	mv	a4,a3
 728:	fcf42623          	sw	a5,-52(s0)
 72c:	87ae                	mv	a5,a1
 72e:	fcf42423          	sw	a5,-56(s0)
 732:	87b2                	mv	a5,a2
 734:	fcf42223          	sw	a5,-60(s0)
 738:	87ba                	mv	a5,a4
 73a:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 73e:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 742:	fc042783          	lw	a5,-64(s0)
 746:	2781                	sext.w	a5,a5
 748:	c38d                	beqz	a5,76a <printint+0x4e>
 74a:	fc842783          	lw	a5,-56(s0)
 74e:	2781                	sext.w	a5,a5
 750:	0007dd63          	bgez	a5,76a <printint+0x4e>
    neg = 1;
 754:	4785                	li	a5,1
 756:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 75a:	fc842783          	lw	a5,-56(s0)
 75e:	40f007bb          	negw	a5,a5
 762:	2781                	sext.w	a5,a5
 764:	fef42223          	sw	a5,-28(s0)
 768:	a029                	j	772 <printint+0x56>
  } else {
    x = xx;
 76a:	fc842783          	lw	a5,-56(s0)
 76e:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 772:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 776:	fc442783          	lw	a5,-60(s0)
 77a:	fe442703          	lw	a4,-28(s0)
 77e:	02f777bb          	remuw	a5,a4,a5
 782:	0007861b          	sext.w	a2,a5
 786:	fec42783          	lw	a5,-20(s0)
 78a:	0017871b          	addiw	a4,a5,1
 78e:	fee42623          	sw	a4,-20(s0)
 792:	00001697          	auipc	a3,0x1
 796:	bde68693          	addi	a3,a3,-1058 # 1370 <digits>
 79a:	02061713          	slli	a4,a2,0x20
 79e:	9301                	srli	a4,a4,0x20
 7a0:	9736                	add	a4,a4,a3
 7a2:	00074703          	lbu	a4,0(a4)
 7a6:	17c1                	addi	a5,a5,-16
 7a8:	97a2                	add	a5,a5,s0
 7aa:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 7ae:	fc442783          	lw	a5,-60(s0)
 7b2:	fe442703          	lw	a4,-28(s0)
 7b6:	02f757bb          	divuw	a5,a4,a5
 7ba:	fef42223          	sw	a5,-28(s0)
 7be:	fe442783          	lw	a5,-28(s0)
 7c2:	2781                	sext.w	a5,a5
 7c4:	fbcd                	bnez	a5,776 <printint+0x5a>
  if(neg)
 7c6:	fe842783          	lw	a5,-24(s0)
 7ca:	2781                	sext.w	a5,a5
 7cc:	cf85                	beqz	a5,804 <printint+0xe8>
    buf[i++] = '-';
 7ce:	fec42783          	lw	a5,-20(s0)
 7d2:	0017871b          	addiw	a4,a5,1
 7d6:	fee42623          	sw	a4,-20(s0)
 7da:	17c1                	addi	a5,a5,-16
 7dc:	97a2                	add	a5,a5,s0
 7de:	02d00713          	li	a4,45
 7e2:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7e6:	a839                	j	804 <printint+0xe8>
    putc(fd, buf[i]);
 7e8:	fec42783          	lw	a5,-20(s0)
 7ec:	17c1                	addi	a5,a5,-16
 7ee:	97a2                	add	a5,a5,s0
 7f0:	fe07c703          	lbu	a4,-32(a5)
 7f4:	fcc42783          	lw	a5,-52(s0)
 7f8:	85ba                	mv	a1,a4
 7fa:	853e                	mv	a0,a5
 7fc:	00000097          	auipc	ra,0x0
 800:	eea080e7          	jalr	-278(ra) # 6e6 <putc>
  while(--i >= 0)
 804:	fec42783          	lw	a5,-20(s0)
 808:	37fd                	addiw	a5,a5,-1
 80a:	fef42623          	sw	a5,-20(s0)
 80e:	fec42783          	lw	a5,-20(s0)
 812:	2781                	sext.w	a5,a5
 814:	fc07dae3          	bgez	a5,7e8 <printint+0xcc>
}
 818:	0001                	nop
 81a:	0001                	nop
 81c:	70e2                	ld	ra,56(sp)
 81e:	7442                	ld	s0,48(sp)
 820:	6121                	addi	sp,sp,64
 822:	8082                	ret

0000000000000824 <printptr>:

static void
printptr(int fd, uint64 x) {
 824:	7179                	addi	sp,sp,-48
 826:	f406                	sd	ra,40(sp)
 828:	f022                	sd	s0,32(sp)
 82a:	1800                	addi	s0,sp,48
 82c:	87aa                	mv	a5,a0
 82e:	fcb43823          	sd	a1,-48(s0)
 832:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 836:	fdc42783          	lw	a5,-36(s0)
 83a:	03000593          	li	a1,48
 83e:	853e                	mv	a0,a5
 840:	00000097          	auipc	ra,0x0
 844:	ea6080e7          	jalr	-346(ra) # 6e6 <putc>
  putc(fd, 'x');
 848:	fdc42783          	lw	a5,-36(s0)
 84c:	07800593          	li	a1,120
 850:	853e                	mv	a0,a5
 852:	00000097          	auipc	ra,0x0
 856:	e94080e7          	jalr	-364(ra) # 6e6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85a:	fe042623          	sw	zero,-20(s0)
 85e:	a82d                	j	898 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 860:	fd043783          	ld	a5,-48(s0)
 864:	93f1                	srli	a5,a5,0x3c
 866:	00001717          	auipc	a4,0x1
 86a:	b0a70713          	addi	a4,a4,-1270 # 1370 <digits>
 86e:	97ba                	add	a5,a5,a4
 870:	0007c703          	lbu	a4,0(a5)
 874:	fdc42783          	lw	a5,-36(s0)
 878:	85ba                	mv	a1,a4
 87a:	853e                	mv	a0,a5
 87c:	00000097          	auipc	ra,0x0
 880:	e6a080e7          	jalr	-406(ra) # 6e6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 884:	fec42783          	lw	a5,-20(s0)
 888:	2785                	addiw	a5,a5,1
 88a:	fef42623          	sw	a5,-20(s0)
 88e:	fd043783          	ld	a5,-48(s0)
 892:	0792                	slli	a5,a5,0x4
 894:	fcf43823          	sd	a5,-48(s0)
 898:	fec42783          	lw	a5,-20(s0)
 89c:	873e                	mv	a4,a5
 89e:	47bd                	li	a5,15
 8a0:	fce7f0e3          	bgeu	a5,a4,860 <printptr+0x3c>
}
 8a4:	0001                	nop
 8a6:	0001                	nop
 8a8:	70a2                	ld	ra,40(sp)
 8aa:	7402                	ld	s0,32(sp)
 8ac:	6145                	addi	sp,sp,48
 8ae:	8082                	ret

00000000000008b0 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8b0:	715d                	addi	sp,sp,-80
 8b2:	e486                	sd	ra,72(sp)
 8b4:	e0a2                	sd	s0,64(sp)
 8b6:	0880                	addi	s0,sp,80
 8b8:	87aa                	mv	a5,a0
 8ba:	fcb43023          	sd	a1,-64(s0)
 8be:	fac43c23          	sd	a2,-72(s0)
 8c2:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8c6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8ca:	fe042223          	sw	zero,-28(s0)
 8ce:	a42d                	j	af8 <vprintf+0x248>
    c = fmt[i] & 0xff;
 8d0:	fe442783          	lw	a5,-28(s0)
 8d4:	fc043703          	ld	a4,-64(s0)
 8d8:	97ba                	add	a5,a5,a4
 8da:	0007c783          	lbu	a5,0(a5)
 8de:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8e2:	fe042783          	lw	a5,-32(s0)
 8e6:	2781                	sext.w	a5,a5
 8e8:	eb9d                	bnez	a5,91e <vprintf+0x6e>
      if(c == '%'){
 8ea:	fdc42783          	lw	a5,-36(s0)
 8ee:	0007871b          	sext.w	a4,a5
 8f2:	02500793          	li	a5,37
 8f6:	00f71763          	bne	a4,a5,904 <vprintf+0x54>
        state = '%';
 8fa:	02500793          	li	a5,37
 8fe:	fef42023          	sw	a5,-32(s0)
 902:	a2f5                	j	aee <vprintf+0x23e>
      } else {
        putc(fd, c);
 904:	fdc42783          	lw	a5,-36(s0)
 908:	0ff7f713          	zext.b	a4,a5
 90c:	fcc42783          	lw	a5,-52(s0)
 910:	85ba                	mv	a1,a4
 912:	853e                	mv	a0,a5
 914:	00000097          	auipc	ra,0x0
 918:	dd2080e7          	jalr	-558(ra) # 6e6 <putc>
 91c:	aac9                	j	aee <vprintf+0x23e>
      }
    } else if(state == '%'){
 91e:	fe042783          	lw	a5,-32(s0)
 922:	0007871b          	sext.w	a4,a5
 926:	02500793          	li	a5,37
 92a:	1cf71263          	bne	a4,a5,aee <vprintf+0x23e>
      if(c == 'd'){
 92e:	fdc42783          	lw	a5,-36(s0)
 932:	0007871b          	sext.w	a4,a5
 936:	06400793          	li	a5,100
 93a:	02f71463          	bne	a4,a5,962 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 93e:	fb843783          	ld	a5,-72(s0)
 942:	00878713          	addi	a4,a5,8
 946:	fae43c23          	sd	a4,-72(s0)
 94a:	4398                	lw	a4,0(a5)
 94c:	fcc42783          	lw	a5,-52(s0)
 950:	4685                	li	a3,1
 952:	4629                	li	a2,10
 954:	85ba                	mv	a1,a4
 956:	853e                	mv	a0,a5
 958:	00000097          	auipc	ra,0x0
 95c:	dc4080e7          	jalr	-572(ra) # 71c <printint>
 960:	a269                	j	aea <vprintf+0x23a>
      } else if(c == 'l') {
 962:	fdc42783          	lw	a5,-36(s0)
 966:	0007871b          	sext.w	a4,a5
 96a:	06c00793          	li	a5,108
 96e:	02f71663          	bne	a4,a5,99a <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 972:	fb843783          	ld	a5,-72(s0)
 976:	00878713          	addi	a4,a5,8
 97a:	fae43c23          	sd	a4,-72(s0)
 97e:	639c                	ld	a5,0(a5)
 980:	0007871b          	sext.w	a4,a5
 984:	fcc42783          	lw	a5,-52(s0)
 988:	4681                	li	a3,0
 98a:	4629                	li	a2,10
 98c:	85ba                	mv	a1,a4
 98e:	853e                	mv	a0,a5
 990:	00000097          	auipc	ra,0x0
 994:	d8c080e7          	jalr	-628(ra) # 71c <printint>
 998:	aa89                	j	aea <vprintf+0x23a>
      } else if(c == 'x') {
 99a:	fdc42783          	lw	a5,-36(s0)
 99e:	0007871b          	sext.w	a4,a5
 9a2:	07800793          	li	a5,120
 9a6:	02f71463          	bne	a4,a5,9ce <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 9aa:	fb843783          	ld	a5,-72(s0)
 9ae:	00878713          	addi	a4,a5,8
 9b2:	fae43c23          	sd	a4,-72(s0)
 9b6:	4398                	lw	a4,0(a5)
 9b8:	fcc42783          	lw	a5,-52(s0)
 9bc:	4681                	li	a3,0
 9be:	4641                	li	a2,16
 9c0:	85ba                	mv	a1,a4
 9c2:	853e                	mv	a0,a5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	d58080e7          	jalr	-680(ra) # 71c <printint>
 9cc:	aa39                	j	aea <vprintf+0x23a>
      } else if(c == 'p') {
 9ce:	fdc42783          	lw	a5,-36(s0)
 9d2:	0007871b          	sext.w	a4,a5
 9d6:	07000793          	li	a5,112
 9da:	02f71263          	bne	a4,a5,9fe <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9de:	fb843783          	ld	a5,-72(s0)
 9e2:	00878713          	addi	a4,a5,8
 9e6:	fae43c23          	sd	a4,-72(s0)
 9ea:	6398                	ld	a4,0(a5)
 9ec:	fcc42783          	lw	a5,-52(s0)
 9f0:	85ba                	mv	a1,a4
 9f2:	853e                	mv	a0,a5
 9f4:	00000097          	auipc	ra,0x0
 9f8:	e30080e7          	jalr	-464(ra) # 824 <printptr>
 9fc:	a0fd                	j	aea <vprintf+0x23a>
      } else if(c == 's'){
 9fe:	fdc42783          	lw	a5,-36(s0)
 a02:	0007871b          	sext.w	a4,a5
 a06:	07300793          	li	a5,115
 a0a:	04f71c63          	bne	a4,a5,a62 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a0e:	fb843783          	ld	a5,-72(s0)
 a12:	00878713          	addi	a4,a5,8
 a16:	fae43c23          	sd	a4,-72(s0)
 a1a:	639c                	ld	a5,0(a5)
 a1c:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a20:	fe843783          	ld	a5,-24(s0)
 a24:	eb8d                	bnez	a5,a56 <vprintf+0x1a6>
          s = "(null)";
 a26:	00000797          	auipc	a5,0x0
 a2a:	4ba78793          	addi	a5,a5,1210 # ee0 <malloc+0x180>
 a2e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a32:	a015                	j	a56 <vprintf+0x1a6>
          putc(fd, *s);
 a34:	fe843783          	ld	a5,-24(s0)
 a38:	0007c703          	lbu	a4,0(a5)
 a3c:	fcc42783          	lw	a5,-52(s0)
 a40:	85ba                	mv	a1,a4
 a42:	853e                	mv	a0,a5
 a44:	00000097          	auipc	ra,0x0
 a48:	ca2080e7          	jalr	-862(ra) # 6e6 <putc>
          s++;
 a4c:	fe843783          	ld	a5,-24(s0)
 a50:	0785                	addi	a5,a5,1
 a52:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a56:	fe843783          	ld	a5,-24(s0)
 a5a:	0007c783          	lbu	a5,0(a5)
 a5e:	fbf9                	bnez	a5,a34 <vprintf+0x184>
 a60:	a069                	j	aea <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a62:	fdc42783          	lw	a5,-36(s0)
 a66:	0007871b          	sext.w	a4,a5
 a6a:	06300793          	li	a5,99
 a6e:	02f71463          	bne	a4,a5,a96 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a72:	fb843783          	ld	a5,-72(s0)
 a76:	00878713          	addi	a4,a5,8
 a7a:	fae43c23          	sd	a4,-72(s0)
 a7e:	439c                	lw	a5,0(a5)
 a80:	0ff7f713          	zext.b	a4,a5
 a84:	fcc42783          	lw	a5,-52(s0)
 a88:	85ba                	mv	a1,a4
 a8a:	853e                	mv	a0,a5
 a8c:	00000097          	auipc	ra,0x0
 a90:	c5a080e7          	jalr	-934(ra) # 6e6 <putc>
 a94:	a899                	j	aea <vprintf+0x23a>
      } else if(c == '%'){
 a96:	fdc42783          	lw	a5,-36(s0)
 a9a:	0007871b          	sext.w	a4,a5
 a9e:	02500793          	li	a5,37
 aa2:	00f71f63          	bne	a4,a5,ac0 <vprintf+0x210>
        putc(fd, c);
 aa6:	fdc42783          	lw	a5,-36(s0)
 aaa:	0ff7f713          	zext.b	a4,a5
 aae:	fcc42783          	lw	a5,-52(s0)
 ab2:	85ba                	mv	a1,a4
 ab4:	853e                	mv	a0,a5
 ab6:	00000097          	auipc	ra,0x0
 aba:	c30080e7          	jalr	-976(ra) # 6e6 <putc>
 abe:	a035                	j	aea <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ac0:	fcc42783          	lw	a5,-52(s0)
 ac4:	02500593          	li	a1,37
 ac8:	853e                	mv	a0,a5
 aca:	00000097          	auipc	ra,0x0
 ace:	c1c080e7          	jalr	-996(ra) # 6e6 <putc>
        putc(fd, c);
 ad2:	fdc42783          	lw	a5,-36(s0)
 ad6:	0ff7f713          	zext.b	a4,a5
 ada:	fcc42783          	lw	a5,-52(s0)
 ade:	85ba                	mv	a1,a4
 ae0:	853e                	mv	a0,a5
 ae2:	00000097          	auipc	ra,0x0
 ae6:	c04080e7          	jalr	-1020(ra) # 6e6 <putc>
      }
      state = 0;
 aea:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 aee:	fe442783          	lw	a5,-28(s0)
 af2:	2785                	addiw	a5,a5,1
 af4:	fef42223          	sw	a5,-28(s0)
 af8:	fe442783          	lw	a5,-28(s0)
 afc:	fc043703          	ld	a4,-64(s0)
 b00:	97ba                	add	a5,a5,a4
 b02:	0007c783          	lbu	a5,0(a5)
 b06:	dc0795e3          	bnez	a5,8d0 <vprintf+0x20>
    }
  }
}
 b0a:	0001                	nop
 b0c:	0001                	nop
 b0e:	60a6                	ld	ra,72(sp)
 b10:	6406                	ld	s0,64(sp)
 b12:	6161                	addi	sp,sp,80
 b14:	8082                	ret

0000000000000b16 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b16:	7159                	addi	sp,sp,-112
 b18:	fc06                	sd	ra,56(sp)
 b1a:	f822                	sd	s0,48(sp)
 b1c:	0080                	addi	s0,sp,64
 b1e:	fcb43823          	sd	a1,-48(s0)
 b22:	e010                	sd	a2,0(s0)
 b24:	e414                	sd	a3,8(s0)
 b26:	e818                	sd	a4,16(s0)
 b28:	ec1c                	sd	a5,24(s0)
 b2a:	03043023          	sd	a6,32(s0)
 b2e:	03143423          	sd	a7,40(s0)
 b32:	87aa                	mv	a5,a0
 b34:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b38:	03040793          	addi	a5,s0,48
 b3c:	fcf43423          	sd	a5,-56(s0)
 b40:	fc843783          	ld	a5,-56(s0)
 b44:	fd078793          	addi	a5,a5,-48
 b48:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b4c:	fe843703          	ld	a4,-24(s0)
 b50:	fdc42783          	lw	a5,-36(s0)
 b54:	863a                	mv	a2,a4
 b56:	fd043583          	ld	a1,-48(s0)
 b5a:	853e                	mv	a0,a5
 b5c:	00000097          	auipc	ra,0x0
 b60:	d54080e7          	jalr	-684(ra) # 8b0 <vprintf>
}
 b64:	0001                	nop
 b66:	70e2                	ld	ra,56(sp)
 b68:	7442                	ld	s0,48(sp)
 b6a:	6165                	addi	sp,sp,112
 b6c:	8082                	ret

0000000000000b6e <printf>:

void
printf(const char *fmt, ...)
{
 b6e:	7159                	addi	sp,sp,-112
 b70:	f406                	sd	ra,40(sp)
 b72:	f022                	sd	s0,32(sp)
 b74:	1800                	addi	s0,sp,48
 b76:	fca43c23          	sd	a0,-40(s0)
 b7a:	e40c                	sd	a1,8(s0)
 b7c:	e810                	sd	a2,16(s0)
 b7e:	ec14                	sd	a3,24(s0)
 b80:	f018                	sd	a4,32(s0)
 b82:	f41c                	sd	a5,40(s0)
 b84:	03043823          	sd	a6,48(s0)
 b88:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b8c:	04040793          	addi	a5,s0,64
 b90:	fcf43823          	sd	a5,-48(s0)
 b94:	fd043783          	ld	a5,-48(s0)
 b98:	fc878793          	addi	a5,a5,-56
 b9c:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ba0:	fe843783          	ld	a5,-24(s0)
 ba4:	863e                	mv	a2,a5
 ba6:	fd843583          	ld	a1,-40(s0)
 baa:	4505                	li	a0,1
 bac:	00000097          	auipc	ra,0x0
 bb0:	d04080e7          	jalr	-764(ra) # 8b0 <vprintf>
}
 bb4:	0001                	nop
 bb6:	70a2                	ld	ra,40(sp)
 bb8:	7402                	ld	s0,32(sp)
 bba:	6165                	addi	sp,sp,112
 bbc:	8082                	ret

0000000000000bbe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bbe:	7179                	addi	sp,sp,-48
 bc0:	f422                	sd	s0,40(sp)
 bc2:	1800                	addi	s0,sp,48
 bc4:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bc8:	fd843783          	ld	a5,-40(s0)
 bcc:	17c1                	addi	a5,a5,-16
 bce:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd2:	00000797          	auipc	a5,0x0
 bd6:	7ce78793          	addi	a5,a5,1998 # 13a0 <freep>
 bda:	639c                	ld	a5,0(a5)
 bdc:	fef43423          	sd	a5,-24(s0)
 be0:	a815                	j	c14 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 be2:	fe843783          	ld	a5,-24(s0)
 be6:	639c                	ld	a5,0(a5)
 be8:	fe843703          	ld	a4,-24(s0)
 bec:	00f76f63          	bltu	a4,a5,c0a <free+0x4c>
 bf0:	fe043703          	ld	a4,-32(s0)
 bf4:	fe843783          	ld	a5,-24(s0)
 bf8:	02e7eb63          	bltu	a5,a4,c2e <free+0x70>
 bfc:	fe843783          	ld	a5,-24(s0)
 c00:	639c                	ld	a5,0(a5)
 c02:	fe043703          	ld	a4,-32(s0)
 c06:	02f76463          	bltu	a4,a5,c2e <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c0a:	fe843783          	ld	a5,-24(s0)
 c0e:	639c                	ld	a5,0(a5)
 c10:	fef43423          	sd	a5,-24(s0)
 c14:	fe043703          	ld	a4,-32(s0)
 c18:	fe843783          	ld	a5,-24(s0)
 c1c:	fce7f3e3          	bgeu	a5,a4,be2 <free+0x24>
 c20:	fe843783          	ld	a5,-24(s0)
 c24:	639c                	ld	a5,0(a5)
 c26:	fe043703          	ld	a4,-32(s0)
 c2a:	faf77ce3          	bgeu	a4,a5,be2 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c2e:	fe043783          	ld	a5,-32(s0)
 c32:	479c                	lw	a5,8(a5)
 c34:	1782                	slli	a5,a5,0x20
 c36:	9381                	srli	a5,a5,0x20
 c38:	0792                	slli	a5,a5,0x4
 c3a:	fe043703          	ld	a4,-32(s0)
 c3e:	973e                	add	a4,a4,a5
 c40:	fe843783          	ld	a5,-24(s0)
 c44:	639c                	ld	a5,0(a5)
 c46:	02f71763          	bne	a4,a5,c74 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 c4a:	fe043783          	ld	a5,-32(s0)
 c4e:	4798                	lw	a4,8(a5)
 c50:	fe843783          	ld	a5,-24(s0)
 c54:	639c                	ld	a5,0(a5)
 c56:	479c                	lw	a5,8(a5)
 c58:	9fb9                	addw	a5,a5,a4
 c5a:	0007871b          	sext.w	a4,a5
 c5e:	fe043783          	ld	a5,-32(s0)
 c62:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c64:	fe843783          	ld	a5,-24(s0)
 c68:	639c                	ld	a5,0(a5)
 c6a:	6398                	ld	a4,0(a5)
 c6c:	fe043783          	ld	a5,-32(s0)
 c70:	e398                	sd	a4,0(a5)
 c72:	a039                	j	c80 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 c74:	fe843783          	ld	a5,-24(s0)
 c78:	6398                	ld	a4,0(a5)
 c7a:	fe043783          	ld	a5,-32(s0)
 c7e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c80:	fe843783          	ld	a5,-24(s0)
 c84:	479c                	lw	a5,8(a5)
 c86:	1782                	slli	a5,a5,0x20
 c88:	9381                	srli	a5,a5,0x20
 c8a:	0792                	slli	a5,a5,0x4
 c8c:	fe843703          	ld	a4,-24(s0)
 c90:	97ba                	add	a5,a5,a4
 c92:	fe043703          	ld	a4,-32(s0)
 c96:	02f71563          	bne	a4,a5,cc0 <free+0x102>
    p->s.size += bp->s.size;
 c9a:	fe843783          	ld	a5,-24(s0)
 c9e:	4798                	lw	a4,8(a5)
 ca0:	fe043783          	ld	a5,-32(s0)
 ca4:	479c                	lw	a5,8(a5)
 ca6:	9fb9                	addw	a5,a5,a4
 ca8:	0007871b          	sext.w	a4,a5
 cac:	fe843783          	ld	a5,-24(s0)
 cb0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cb2:	fe043783          	ld	a5,-32(s0)
 cb6:	6398                	ld	a4,0(a5)
 cb8:	fe843783          	ld	a5,-24(s0)
 cbc:	e398                	sd	a4,0(a5)
 cbe:	a031                	j	cca <free+0x10c>
  } else
    p->s.ptr = bp;
 cc0:	fe843783          	ld	a5,-24(s0)
 cc4:	fe043703          	ld	a4,-32(s0)
 cc8:	e398                	sd	a4,0(a5)
  freep = p;
 cca:	00000797          	auipc	a5,0x0
 cce:	6d678793          	addi	a5,a5,1750 # 13a0 <freep>
 cd2:	fe843703          	ld	a4,-24(s0)
 cd6:	e398                	sd	a4,0(a5)
}
 cd8:	0001                	nop
 cda:	7422                	ld	s0,40(sp)
 cdc:	6145                	addi	sp,sp,48
 cde:	8082                	ret

0000000000000ce0 <morecore>:

static Header*
morecore(uint nu)
{
 ce0:	7179                	addi	sp,sp,-48
 ce2:	f406                	sd	ra,40(sp)
 ce4:	f022                	sd	s0,32(sp)
 ce6:	1800                	addi	s0,sp,48
 ce8:	87aa                	mv	a5,a0
 cea:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 cee:	fdc42783          	lw	a5,-36(s0)
 cf2:	0007871b          	sext.w	a4,a5
 cf6:	6785                	lui	a5,0x1
 cf8:	00f77563          	bgeu	a4,a5,d02 <morecore+0x22>
    nu = 4096;
 cfc:	6785                	lui	a5,0x1
 cfe:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d02:	fdc42783          	lw	a5,-36(s0)
 d06:	0047979b          	slliw	a5,a5,0x4
 d0a:	2781                	sext.w	a5,a5
 d0c:	2781                	sext.w	a5,a5
 d0e:	853e                	mv	a0,a5
 d10:	00000097          	auipc	ra,0x0
 d14:	9ae080e7          	jalr	-1618(ra) # 6be <sbrk>
 d18:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d1c:	fe843703          	ld	a4,-24(s0)
 d20:	57fd                	li	a5,-1
 d22:	00f71463          	bne	a4,a5,d2a <morecore+0x4a>
    return 0;
 d26:	4781                	li	a5,0
 d28:	a03d                	j	d56 <morecore+0x76>
  hp = (Header*)p;
 d2a:	fe843783          	ld	a5,-24(s0)
 d2e:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d32:	fe043783          	ld	a5,-32(s0)
 d36:	fdc42703          	lw	a4,-36(s0)
 d3a:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d3c:	fe043783          	ld	a5,-32(s0)
 d40:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x2b0>
 d42:	853e                	mv	a0,a5
 d44:	00000097          	auipc	ra,0x0
 d48:	e7a080e7          	jalr	-390(ra) # bbe <free>
  return freep;
 d4c:	00000797          	auipc	a5,0x0
 d50:	65478793          	addi	a5,a5,1620 # 13a0 <freep>
 d54:	639c                	ld	a5,0(a5)
}
 d56:	853e                	mv	a0,a5
 d58:	70a2                	ld	ra,40(sp)
 d5a:	7402                	ld	s0,32(sp)
 d5c:	6145                	addi	sp,sp,48
 d5e:	8082                	ret

0000000000000d60 <malloc>:

void*
malloc(uint nbytes)
{
 d60:	7139                	addi	sp,sp,-64
 d62:	fc06                	sd	ra,56(sp)
 d64:	f822                	sd	s0,48(sp)
 d66:	0080                	addi	s0,sp,64
 d68:	87aa                	mv	a5,a0
 d6a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d6e:	fcc46783          	lwu	a5,-52(s0)
 d72:	07bd                	addi	a5,a5,15
 d74:	8391                	srli	a5,a5,0x4
 d76:	2781                	sext.w	a5,a5
 d78:	2785                	addiw	a5,a5,1
 d7a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d7e:	00000797          	auipc	a5,0x0
 d82:	62278793          	addi	a5,a5,1570 # 13a0 <freep>
 d86:	639c                	ld	a5,0(a5)
 d88:	fef43023          	sd	a5,-32(s0)
 d8c:	fe043783          	ld	a5,-32(s0)
 d90:	ef95                	bnez	a5,dcc <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d92:	00000797          	auipc	a5,0x0
 d96:	5fe78793          	addi	a5,a5,1534 # 1390 <base>
 d9a:	fef43023          	sd	a5,-32(s0)
 d9e:	00000797          	auipc	a5,0x0
 da2:	60278793          	addi	a5,a5,1538 # 13a0 <freep>
 da6:	fe043703          	ld	a4,-32(s0)
 daa:	e398                	sd	a4,0(a5)
 dac:	00000797          	auipc	a5,0x0
 db0:	5f478793          	addi	a5,a5,1524 # 13a0 <freep>
 db4:	6398                	ld	a4,0(a5)
 db6:	00000797          	auipc	a5,0x0
 dba:	5da78793          	addi	a5,a5,1498 # 1390 <base>
 dbe:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 dc0:	00000797          	auipc	a5,0x0
 dc4:	5d078793          	addi	a5,a5,1488 # 1390 <base>
 dc8:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dcc:	fe043783          	ld	a5,-32(s0)
 dd0:	639c                	ld	a5,0(a5)
 dd2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dd6:	fe843783          	ld	a5,-24(s0)
 dda:	4798                	lw	a4,8(a5)
 ddc:	fdc42783          	lw	a5,-36(s0)
 de0:	2781                	sext.w	a5,a5
 de2:	06f76763          	bltu	a4,a5,e50 <malloc+0xf0>
      if(p->s.size == nunits)
 de6:	fe843783          	ld	a5,-24(s0)
 dea:	4798                	lw	a4,8(a5)
 dec:	fdc42783          	lw	a5,-36(s0)
 df0:	2781                	sext.w	a5,a5
 df2:	00e79963          	bne	a5,a4,e04 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 df6:	fe843783          	ld	a5,-24(s0)
 dfa:	6398                	ld	a4,0(a5)
 dfc:	fe043783          	ld	a5,-32(s0)
 e00:	e398                	sd	a4,0(a5)
 e02:	a825                	j	e3a <malloc+0xda>
      else {
        p->s.size -= nunits;
 e04:	fe843783          	ld	a5,-24(s0)
 e08:	479c                	lw	a5,8(a5)
 e0a:	fdc42703          	lw	a4,-36(s0)
 e0e:	9f99                	subw	a5,a5,a4
 e10:	0007871b          	sext.w	a4,a5
 e14:	fe843783          	ld	a5,-24(s0)
 e18:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e1a:	fe843783          	ld	a5,-24(s0)
 e1e:	479c                	lw	a5,8(a5)
 e20:	1782                	slli	a5,a5,0x20
 e22:	9381                	srli	a5,a5,0x20
 e24:	0792                	slli	a5,a5,0x4
 e26:	fe843703          	ld	a4,-24(s0)
 e2a:	97ba                	add	a5,a5,a4
 e2c:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e30:	fe843783          	ld	a5,-24(s0)
 e34:	fdc42703          	lw	a4,-36(s0)
 e38:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e3a:	00000797          	auipc	a5,0x0
 e3e:	56678793          	addi	a5,a5,1382 # 13a0 <freep>
 e42:	fe043703          	ld	a4,-32(s0)
 e46:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e48:	fe843783          	ld	a5,-24(s0)
 e4c:	07c1                	addi	a5,a5,16
 e4e:	a091                	j	e92 <malloc+0x132>
    }
    if(p == freep)
 e50:	00000797          	auipc	a5,0x0
 e54:	55078793          	addi	a5,a5,1360 # 13a0 <freep>
 e58:	639c                	ld	a5,0(a5)
 e5a:	fe843703          	ld	a4,-24(s0)
 e5e:	02f71063          	bne	a4,a5,e7e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e62:	fdc42783          	lw	a5,-36(s0)
 e66:	853e                	mv	a0,a5
 e68:	00000097          	auipc	ra,0x0
 e6c:	e78080e7          	jalr	-392(ra) # ce0 <morecore>
 e70:	fea43423          	sd	a0,-24(s0)
 e74:	fe843783          	ld	a5,-24(s0)
 e78:	e399                	bnez	a5,e7e <malloc+0x11e>
        return 0;
 e7a:	4781                	li	a5,0
 e7c:	a819                	j	e92 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e7e:	fe843783          	ld	a5,-24(s0)
 e82:	fef43023          	sd	a5,-32(s0)
 e86:	fe843783          	ld	a5,-24(s0)
 e8a:	639c                	ld	a5,0(a5)
 e8c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e90:	b799                	j	dd6 <malloc+0x76>
  }
}
 e92:	853e                	mv	a0,a5
 e94:	70e2                	ld	ra,56(sp)
 e96:	7442                	ld	s0,48(sp)
 e98:	6121                	addi	sp,sp,64
 e9a:	8082                	ret
