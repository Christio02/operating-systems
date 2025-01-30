
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   8:	4589                	li	a1,2
   a:	00001517          	auipc	a0,0x1
   e:	e3e50513          	addi	a0,a0,-450 # e48 <malloc+0x14a>
  12:	00000097          	auipc	ra,0x0
  16:	5fa080e7          	jalr	1530(ra) # 60c <open>
  1a:	87aa                	mv	a5,a0
  1c:	0207d563          	bgez	a5,46 <main+0x46>
    mknod("console", CONSOLE, 0);
  20:	4601                	li	a2,0
  22:	4585                	li	a1,1
  24:	00001517          	auipc	a0,0x1
  28:	e2450513          	addi	a0,a0,-476 # e48 <malloc+0x14a>
  2c:	00000097          	auipc	ra,0x0
  30:	5e8080e7          	jalr	1512(ra) # 614 <mknod>
    open("console", O_RDWR);
  34:	4589                	li	a1,2
  36:	00001517          	auipc	a0,0x1
  3a:	e1250513          	addi	a0,a0,-494 # e48 <malloc+0x14a>
  3e:	00000097          	auipc	ra,0x0
  42:	5ce080e7          	jalr	1486(ra) # 60c <open>
  }
  dup(0);  // stdout
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	5fc080e7          	jalr	1532(ra) # 644 <dup>
  dup(0);  // stderr
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	5f2080e7          	jalr	1522(ra) # 644 <dup>

  for(;;){
    printf("init: starting sh\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	df650513          	addi	a0,a0,-522 # e50 <malloc+0x152>
  62:	00001097          	auipc	ra,0x1
  66:	aaa080e7          	jalr	-1366(ra) # b0c <printf>
    pid = fork();
  6a:	00000097          	auipc	ra,0x0
  6e:	55a080e7          	jalr	1370(ra) # 5c4 <fork>
  72:	87aa                	mv	a5,a0
  74:	fef42623          	sw	a5,-20(s0)
    if(pid < 0){
  78:	fec42783          	lw	a5,-20(s0)
  7c:	2781                	sext.w	a5,a5
  7e:	0007df63          	bgez	a5,9c <main+0x9c>
      printf("init: fork failed\n");
  82:	00001517          	auipc	a0,0x1
  86:	de650513          	addi	a0,a0,-538 # e68 <malloc+0x16a>
  8a:	00001097          	auipc	ra,0x1
  8e:	a82080e7          	jalr	-1406(ra) # b0c <printf>
      exit(1);
  92:	4505                	li	a0,1
  94:	00000097          	auipc	ra,0x0
  98:	538080e7          	jalr	1336(ra) # 5cc <exit>
    }
    if(pid == 0){
  9c:	fec42783          	lw	a5,-20(s0)
  a0:	2781                	sext.w	a5,a5
  a2:	eb95                	bnez	a5,d6 <main+0xd6>
      exec("sh", argv);
  a4:	00001597          	auipc	a1,0x1
  a8:	2cc58593          	addi	a1,a1,716 # 1370 <argv>
  ac:	00001517          	auipc	a0,0x1
  b0:	d9450513          	addi	a0,a0,-620 # e40 <malloc+0x142>
  b4:	00000097          	auipc	ra,0x0
  b8:	550080e7          	jalr	1360(ra) # 604 <exec>
      printf("init: exec sh failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	dc450513          	addi	a0,a0,-572 # e80 <malloc+0x182>
  c4:	00001097          	auipc	ra,0x1
  c8:	a48080e7          	jalr	-1464(ra) # b0c <printf>
      exit(1);
  cc:	4505                	li	a0,1
  ce:	00000097          	auipc	ra,0x0
  d2:	4fe080e7          	jalr	1278(ra) # 5cc <exit>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	4fc080e7          	jalr	1276(ra) # 5d4 <wait>
  e0:	87aa                	mv	a5,a0
  e2:	fef42423          	sw	a5,-24(s0)
      if(wpid == pid){
  e6:	fe842783          	lw	a5,-24(s0)
  ea:	873e                	mv	a4,a5
  ec:	fec42783          	lw	a5,-20(s0)
  f0:	2701                	sext.w	a4,a4
  f2:	2781                	sext.w	a5,a5
  f4:	02f70463          	beq	a4,a5,11c <main+0x11c>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  f8:	fe842783          	lw	a5,-24(s0)
  fc:	2781                	sext.w	a5,a5
  fe:	fc07dce3          	bgez	a5,d6 <main+0xd6>
        printf("init: wait returned an error\n");
 102:	00001517          	auipc	a0,0x1
 106:	d9650513          	addi	a0,a0,-618 # e98 <malloc+0x19a>
 10a:	00001097          	auipc	ra,0x1
 10e:	a02080e7          	jalr	-1534(ra) # b0c <printf>
        exit(1);
 112:	4505                	li	a0,1
 114:	00000097          	auipc	ra,0x0
 118:	4b8080e7          	jalr	1208(ra) # 5cc <exit>
        break;
 11c:	0001                	nop
    printf("init: starting sh\n");
 11e:	bf35                	j	5a <main+0x5a>

0000000000000120 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 120:	1141                	addi	sp,sp,-16
 122:	e406                	sd	ra,8(sp)
 124:	e022                	sd	s0,0(sp)
 126:	0800                	addi	s0,sp,16
  extern int main();
  main();
 128:	00000097          	auipc	ra,0x0
 12c:	ed8080e7          	jalr	-296(ra) # 0 <main>
  exit(0);
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	49a080e7          	jalr	1178(ra) # 5cc <exit>

000000000000013a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13a:	7179                	addi	sp,sp,-48
 13c:	f422                	sd	s0,40(sp)
 13e:	1800                	addi	s0,sp,48
 140:	fca43c23          	sd	a0,-40(s0)
 144:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 148:	fd843783          	ld	a5,-40(s0)
 14c:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 150:	0001                	nop
 152:	fd043703          	ld	a4,-48(s0)
 156:	00170793          	addi	a5,a4,1
 15a:	fcf43823          	sd	a5,-48(s0)
 15e:	fd843783          	ld	a5,-40(s0)
 162:	00178693          	addi	a3,a5,1
 166:	fcd43c23          	sd	a3,-40(s0)
 16a:	00074703          	lbu	a4,0(a4)
 16e:	00e78023          	sb	a4,0(a5)
 172:	0007c783          	lbu	a5,0(a5)
 176:	fff1                	bnez	a5,152 <strcpy+0x18>
    ;
  return os;
 178:	fe843783          	ld	a5,-24(s0)
}
 17c:	853e                	mv	a0,a5
 17e:	7422                	ld	s0,40(sp)
 180:	6145                	addi	sp,sp,48
 182:	8082                	ret

0000000000000184 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 184:	1101                	addi	sp,sp,-32
 186:	ec22                	sd	s0,24(sp)
 188:	1000                	addi	s0,sp,32
 18a:	fea43423          	sd	a0,-24(s0)
 18e:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 192:	a819                	j	1a8 <strcmp+0x24>
    p++, q++;
 194:	fe843783          	ld	a5,-24(s0)
 198:	0785                	addi	a5,a5,1
 19a:	fef43423          	sd	a5,-24(s0)
 19e:	fe043783          	ld	a5,-32(s0)
 1a2:	0785                	addi	a5,a5,1
 1a4:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 1a8:	fe843783          	ld	a5,-24(s0)
 1ac:	0007c783          	lbu	a5,0(a5)
 1b0:	cb99                	beqz	a5,1c6 <strcmp+0x42>
 1b2:	fe843783          	ld	a5,-24(s0)
 1b6:	0007c703          	lbu	a4,0(a5)
 1ba:	fe043783          	ld	a5,-32(s0)
 1be:	0007c783          	lbu	a5,0(a5)
 1c2:	fcf709e3          	beq	a4,a5,194 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 1c6:	fe843783          	ld	a5,-24(s0)
 1ca:	0007c783          	lbu	a5,0(a5)
 1ce:	0007871b          	sext.w	a4,a5
 1d2:	fe043783          	ld	a5,-32(s0)
 1d6:	0007c783          	lbu	a5,0(a5)
 1da:	2781                	sext.w	a5,a5
 1dc:	40f707bb          	subw	a5,a4,a5
 1e0:	2781                	sext.w	a5,a5
}
 1e2:	853e                	mv	a0,a5
 1e4:	6462                	ld	s0,24(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret

00000000000001ea <strlen>:

uint
strlen(const char *s)
{
 1ea:	7179                	addi	sp,sp,-48
 1ec:	f422                	sd	s0,40(sp)
 1ee:	1800                	addi	s0,sp,48
 1f0:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 1f4:	fe042623          	sw	zero,-20(s0)
 1f8:	a031                	j	204 <strlen+0x1a>
 1fa:	fec42783          	lw	a5,-20(s0)
 1fe:	2785                	addiw	a5,a5,1
 200:	fef42623          	sw	a5,-20(s0)
 204:	fec42783          	lw	a5,-20(s0)
 208:	fd843703          	ld	a4,-40(s0)
 20c:	97ba                	add	a5,a5,a4
 20e:	0007c783          	lbu	a5,0(a5)
 212:	f7e5                	bnez	a5,1fa <strlen+0x10>
    ;
  return n;
 214:	fec42783          	lw	a5,-20(s0)
}
 218:	853e                	mv	a0,a5
 21a:	7422                	ld	s0,40(sp)
 21c:	6145                	addi	sp,sp,48
 21e:	8082                	ret

0000000000000220 <memset>:

void*
memset(void *dst, int c, uint n)
{
 220:	7179                	addi	sp,sp,-48
 222:	f422                	sd	s0,40(sp)
 224:	1800                	addi	s0,sp,48
 226:	fca43c23          	sd	a0,-40(s0)
 22a:	87ae                	mv	a5,a1
 22c:	8732                	mv	a4,a2
 22e:	fcf42a23          	sw	a5,-44(s0)
 232:	87ba                	mv	a5,a4
 234:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 238:	fd843783          	ld	a5,-40(s0)
 23c:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 240:	fe042623          	sw	zero,-20(s0)
 244:	a00d                	j	266 <memset+0x46>
    cdst[i] = c;
 246:	fec42783          	lw	a5,-20(s0)
 24a:	fe043703          	ld	a4,-32(s0)
 24e:	97ba                	add	a5,a5,a4
 250:	fd442703          	lw	a4,-44(s0)
 254:	0ff77713          	zext.b	a4,a4
 258:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 25c:	fec42783          	lw	a5,-20(s0)
 260:	2785                	addiw	a5,a5,1
 262:	fef42623          	sw	a5,-20(s0)
 266:	fec42703          	lw	a4,-20(s0)
 26a:	fd042783          	lw	a5,-48(s0)
 26e:	2781                	sext.w	a5,a5
 270:	fcf76be3          	bltu	a4,a5,246 <memset+0x26>
  }
  return dst;
 274:	fd843783          	ld	a5,-40(s0)
}
 278:	853e                	mv	a0,a5
 27a:	7422                	ld	s0,40(sp)
 27c:	6145                	addi	sp,sp,48
 27e:	8082                	ret

0000000000000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	1101                	addi	sp,sp,-32
 282:	ec22                	sd	s0,24(sp)
 284:	1000                	addi	s0,sp,32
 286:	fea43423          	sd	a0,-24(s0)
 28a:	87ae                	mv	a5,a1
 28c:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 290:	a01d                	j	2b6 <strchr+0x36>
    if(*s == c)
 292:	fe843783          	ld	a5,-24(s0)
 296:	0007c703          	lbu	a4,0(a5)
 29a:	fe744783          	lbu	a5,-25(s0)
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	00e79563          	bne	a5,a4,2ac <strchr+0x2c>
      return (char*)s;
 2a6:	fe843783          	ld	a5,-24(s0)
 2aa:	a821                	j	2c2 <strchr+0x42>
  for(; *s; s++)
 2ac:	fe843783          	ld	a5,-24(s0)
 2b0:	0785                	addi	a5,a5,1
 2b2:	fef43423          	sd	a5,-24(s0)
 2b6:	fe843783          	ld	a5,-24(s0)
 2ba:	0007c783          	lbu	a5,0(a5)
 2be:	fbf1                	bnez	a5,292 <strchr+0x12>
  return 0;
 2c0:	4781                	li	a5,0
}
 2c2:	853e                	mv	a0,a5
 2c4:	6462                	ld	s0,24(sp)
 2c6:	6105                	addi	sp,sp,32
 2c8:	8082                	ret

00000000000002ca <gets>:

char*
gets(char *buf, int max)
{
 2ca:	7179                	addi	sp,sp,-48
 2cc:	f406                	sd	ra,40(sp)
 2ce:	f022                	sd	s0,32(sp)
 2d0:	1800                	addi	s0,sp,48
 2d2:	fca43c23          	sd	a0,-40(s0)
 2d6:	87ae                	mv	a5,a1
 2d8:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2dc:	fe042623          	sw	zero,-20(s0)
 2e0:	a8a1                	j	338 <gets+0x6e>
    cc = read(0, &c, 1);
 2e2:	fe740793          	addi	a5,s0,-25
 2e6:	4605                	li	a2,1
 2e8:	85be                	mv	a1,a5
 2ea:	4501                	li	a0,0
 2ec:	00000097          	auipc	ra,0x0
 2f0:	2f8080e7          	jalr	760(ra) # 5e4 <read>
 2f4:	87aa                	mv	a5,a0
 2f6:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 2fa:	fe842783          	lw	a5,-24(s0)
 2fe:	2781                	sext.w	a5,a5
 300:	04f05763          	blez	a5,34e <gets+0x84>
      break;
    buf[i++] = c;
 304:	fec42783          	lw	a5,-20(s0)
 308:	0017871b          	addiw	a4,a5,1
 30c:	fee42623          	sw	a4,-20(s0)
 310:	873e                	mv	a4,a5
 312:	fd843783          	ld	a5,-40(s0)
 316:	97ba                	add	a5,a5,a4
 318:	fe744703          	lbu	a4,-25(s0)
 31c:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 320:	fe744783          	lbu	a5,-25(s0)
 324:	873e                	mv	a4,a5
 326:	47a9                	li	a5,10
 328:	02f70463          	beq	a4,a5,350 <gets+0x86>
 32c:	fe744783          	lbu	a5,-25(s0)
 330:	873e                	mv	a4,a5
 332:	47b5                	li	a5,13
 334:	00f70e63          	beq	a4,a5,350 <gets+0x86>
  for(i=0; i+1 < max; ){
 338:	fec42783          	lw	a5,-20(s0)
 33c:	2785                	addiw	a5,a5,1
 33e:	0007871b          	sext.w	a4,a5
 342:	fd442783          	lw	a5,-44(s0)
 346:	2781                	sext.w	a5,a5
 348:	f8f74de3          	blt	a4,a5,2e2 <gets+0x18>
 34c:	a011                	j	350 <gets+0x86>
      break;
 34e:	0001                	nop
      break;
  }
  buf[i] = '\0';
 350:	fec42783          	lw	a5,-20(s0)
 354:	fd843703          	ld	a4,-40(s0)
 358:	97ba                	add	a5,a5,a4
 35a:	00078023          	sb	zero,0(a5)
  return buf;
 35e:	fd843783          	ld	a5,-40(s0)
}
 362:	853e                	mv	a0,a5
 364:	70a2                	ld	ra,40(sp)
 366:	7402                	ld	s0,32(sp)
 368:	6145                	addi	sp,sp,48
 36a:	8082                	ret

000000000000036c <stat>:

int
stat(const char *n, struct stat *st)
{
 36c:	7179                	addi	sp,sp,-48
 36e:	f406                	sd	ra,40(sp)
 370:	f022                	sd	s0,32(sp)
 372:	1800                	addi	s0,sp,48
 374:	fca43c23          	sd	a0,-40(s0)
 378:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37c:	4581                	li	a1,0
 37e:	fd843503          	ld	a0,-40(s0)
 382:	00000097          	auipc	ra,0x0
 386:	28a080e7          	jalr	650(ra) # 60c <open>
 38a:	87aa                	mv	a5,a0
 38c:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 390:	fec42783          	lw	a5,-20(s0)
 394:	2781                	sext.w	a5,a5
 396:	0007d463          	bgez	a5,39e <stat+0x32>
    return -1;
 39a:	57fd                	li	a5,-1
 39c:	a035                	j	3c8 <stat+0x5c>
  r = fstat(fd, st);
 39e:	fec42783          	lw	a5,-20(s0)
 3a2:	fd043583          	ld	a1,-48(s0)
 3a6:	853e                	mv	a0,a5
 3a8:	00000097          	auipc	ra,0x0
 3ac:	27c080e7          	jalr	636(ra) # 624 <fstat>
 3b0:	87aa                	mv	a5,a0
 3b2:	fef42423          	sw	a5,-24(s0)
  close(fd);
 3b6:	fec42783          	lw	a5,-20(s0)
 3ba:	853e                	mv	a0,a5
 3bc:	00000097          	auipc	ra,0x0
 3c0:	238080e7          	jalr	568(ra) # 5f4 <close>
  return r;
 3c4:	fe842783          	lw	a5,-24(s0)
}
 3c8:	853e                	mv	a0,a5
 3ca:	70a2                	ld	ra,40(sp)
 3cc:	7402                	ld	s0,32(sp)
 3ce:	6145                	addi	sp,sp,48
 3d0:	8082                	ret

00000000000003d2 <atoi>:

int
atoi(const char *s)
{
 3d2:	7179                	addi	sp,sp,-48
 3d4:	f422                	sd	s0,40(sp)
 3d6:	1800                	addi	s0,sp,48
 3d8:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 3dc:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 3e0:	a81d                	j	416 <atoi+0x44>
    n = n*10 + *s++ - '0';
 3e2:	fec42783          	lw	a5,-20(s0)
 3e6:	873e                	mv	a4,a5
 3e8:	87ba                	mv	a5,a4
 3ea:	0027979b          	slliw	a5,a5,0x2
 3ee:	9fb9                	addw	a5,a5,a4
 3f0:	0017979b          	slliw	a5,a5,0x1
 3f4:	0007871b          	sext.w	a4,a5
 3f8:	fd843783          	ld	a5,-40(s0)
 3fc:	00178693          	addi	a3,a5,1
 400:	fcd43c23          	sd	a3,-40(s0)
 404:	0007c783          	lbu	a5,0(a5)
 408:	2781                	sext.w	a5,a5
 40a:	9fb9                	addw	a5,a5,a4
 40c:	2781                	sext.w	a5,a5
 40e:	fd07879b          	addiw	a5,a5,-48
 412:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 416:	fd843783          	ld	a5,-40(s0)
 41a:	0007c783          	lbu	a5,0(a5)
 41e:	873e                	mv	a4,a5
 420:	02f00793          	li	a5,47
 424:	00e7fb63          	bgeu	a5,a4,43a <atoi+0x68>
 428:	fd843783          	ld	a5,-40(s0)
 42c:	0007c783          	lbu	a5,0(a5)
 430:	873e                	mv	a4,a5
 432:	03900793          	li	a5,57
 436:	fae7f6e3          	bgeu	a5,a4,3e2 <atoi+0x10>
  return n;
 43a:	fec42783          	lw	a5,-20(s0)
}
 43e:	853e                	mv	a0,a5
 440:	7422                	ld	s0,40(sp)
 442:	6145                	addi	sp,sp,48
 444:	8082                	ret

0000000000000446 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 446:	7139                	addi	sp,sp,-64
 448:	fc22                	sd	s0,56(sp)
 44a:	0080                	addi	s0,sp,64
 44c:	fca43c23          	sd	a0,-40(s0)
 450:	fcb43823          	sd	a1,-48(s0)
 454:	87b2                	mv	a5,a2
 456:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 45a:	fd843783          	ld	a5,-40(s0)
 45e:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 462:	fd043783          	ld	a5,-48(s0)
 466:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 46a:	fe043703          	ld	a4,-32(s0)
 46e:	fe843783          	ld	a5,-24(s0)
 472:	02e7fc63          	bgeu	a5,a4,4aa <memmove+0x64>
    while(n-- > 0)
 476:	a00d                	j	498 <memmove+0x52>
      *dst++ = *src++;
 478:	fe043703          	ld	a4,-32(s0)
 47c:	00170793          	addi	a5,a4,1
 480:	fef43023          	sd	a5,-32(s0)
 484:	fe843783          	ld	a5,-24(s0)
 488:	00178693          	addi	a3,a5,1
 48c:	fed43423          	sd	a3,-24(s0)
 490:	00074703          	lbu	a4,0(a4)
 494:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 498:	fcc42783          	lw	a5,-52(s0)
 49c:	fff7871b          	addiw	a4,a5,-1
 4a0:	fce42623          	sw	a4,-52(s0)
 4a4:	fcf04ae3          	bgtz	a5,478 <memmove+0x32>
 4a8:	a891                	j	4fc <memmove+0xb6>
  } else {
    dst += n;
 4aa:	fcc42783          	lw	a5,-52(s0)
 4ae:	fe843703          	ld	a4,-24(s0)
 4b2:	97ba                	add	a5,a5,a4
 4b4:	fef43423          	sd	a5,-24(s0)
    src += n;
 4b8:	fcc42783          	lw	a5,-52(s0)
 4bc:	fe043703          	ld	a4,-32(s0)
 4c0:	97ba                	add	a5,a5,a4
 4c2:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 4c6:	a01d                	j	4ec <memmove+0xa6>
      *--dst = *--src;
 4c8:	fe043783          	ld	a5,-32(s0)
 4cc:	17fd                	addi	a5,a5,-1
 4ce:	fef43023          	sd	a5,-32(s0)
 4d2:	fe843783          	ld	a5,-24(s0)
 4d6:	17fd                	addi	a5,a5,-1
 4d8:	fef43423          	sd	a5,-24(s0)
 4dc:	fe043783          	ld	a5,-32(s0)
 4e0:	0007c703          	lbu	a4,0(a5)
 4e4:	fe843783          	ld	a5,-24(s0)
 4e8:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 4ec:	fcc42783          	lw	a5,-52(s0)
 4f0:	fff7871b          	addiw	a4,a5,-1
 4f4:	fce42623          	sw	a4,-52(s0)
 4f8:	fcf048e3          	bgtz	a5,4c8 <memmove+0x82>
  }
  return vdst;
 4fc:	fd843783          	ld	a5,-40(s0)
}
 500:	853e                	mv	a0,a5
 502:	7462                	ld	s0,56(sp)
 504:	6121                	addi	sp,sp,64
 506:	8082                	ret

0000000000000508 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 508:	7139                	addi	sp,sp,-64
 50a:	fc22                	sd	s0,56(sp)
 50c:	0080                	addi	s0,sp,64
 50e:	fca43c23          	sd	a0,-40(s0)
 512:	fcb43823          	sd	a1,-48(s0)
 516:	87b2                	mv	a5,a2
 518:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 51c:	fd843783          	ld	a5,-40(s0)
 520:	fef43423          	sd	a5,-24(s0)
 524:	fd043783          	ld	a5,-48(s0)
 528:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 52c:	a0a1                	j	574 <memcmp+0x6c>
    if (*p1 != *p2) {
 52e:	fe843783          	ld	a5,-24(s0)
 532:	0007c703          	lbu	a4,0(a5)
 536:	fe043783          	ld	a5,-32(s0)
 53a:	0007c783          	lbu	a5,0(a5)
 53e:	02f70163          	beq	a4,a5,560 <memcmp+0x58>
      return *p1 - *p2;
 542:	fe843783          	ld	a5,-24(s0)
 546:	0007c783          	lbu	a5,0(a5)
 54a:	0007871b          	sext.w	a4,a5
 54e:	fe043783          	ld	a5,-32(s0)
 552:	0007c783          	lbu	a5,0(a5)
 556:	2781                	sext.w	a5,a5
 558:	40f707bb          	subw	a5,a4,a5
 55c:	2781                	sext.w	a5,a5
 55e:	a01d                	j	584 <memcmp+0x7c>
    }
    p1++;
 560:	fe843783          	ld	a5,-24(s0)
 564:	0785                	addi	a5,a5,1
 566:	fef43423          	sd	a5,-24(s0)
    p2++;
 56a:	fe043783          	ld	a5,-32(s0)
 56e:	0785                	addi	a5,a5,1
 570:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 574:	fcc42783          	lw	a5,-52(s0)
 578:	fff7871b          	addiw	a4,a5,-1
 57c:	fce42623          	sw	a4,-52(s0)
 580:	f7dd                	bnez	a5,52e <memcmp+0x26>
  }
  return 0;
 582:	4781                	li	a5,0
}
 584:	853e                	mv	a0,a5
 586:	7462                	ld	s0,56(sp)
 588:	6121                	addi	sp,sp,64
 58a:	8082                	ret

000000000000058c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 58c:	7179                	addi	sp,sp,-48
 58e:	f406                	sd	ra,40(sp)
 590:	f022                	sd	s0,32(sp)
 592:	1800                	addi	s0,sp,48
 594:	fea43423          	sd	a0,-24(s0)
 598:	feb43023          	sd	a1,-32(s0)
 59c:	87b2                	mv	a5,a2
 59e:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 5a2:	fdc42783          	lw	a5,-36(s0)
 5a6:	863e                	mv	a2,a5
 5a8:	fe043583          	ld	a1,-32(s0)
 5ac:	fe843503          	ld	a0,-24(s0)
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e96080e7          	jalr	-362(ra) # 446 <memmove>
 5b8:	87aa                	mv	a5,a0
}
 5ba:	853e                	mv	a0,a5
 5bc:	70a2                	ld	ra,40(sp)
 5be:	7402                	ld	s0,32(sp)
 5c0:	6145                	addi	sp,sp,48
 5c2:	8082                	ret

00000000000005c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5c4:	4885                	li	a7,1
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 5cc:	4889                	li	a7,2
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5d4:	488d                	li	a7,3
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5dc:	4891                	li	a7,4
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <read>:
.global read
read:
 li a7, SYS_read
 5e4:	4895                	li	a7,5
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <write>:
.global write
write:
 li a7, SYS_write
 5ec:	48c1                	li	a7,16
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <close>:
.global close
close:
 li a7, SYS_close
 5f4:	48d5                	li	a7,21
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5fc:	4899                	li	a7,6
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <exec>:
.global exec
exec:
 li a7, SYS_exec
 604:	489d                	li	a7,7
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <open>:
.global open
open:
 li a7, SYS_open
 60c:	48bd                	li	a7,15
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 614:	48c5                	li	a7,17
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 61c:	48c9                	li	a7,18
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 624:	48a1                	li	a7,8
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <link>:
.global link
link:
 li a7, SYS_link
 62c:	48cd                	li	a7,19
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 634:	48d1                	li	a7,20
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 63c:	48a5                	li	a7,9
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <dup>:
.global dup
dup:
 li a7, SYS_dup
 644:	48a9                	li	a7,10
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 64c:	48ad                	li	a7,11
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 654:	48b1                	li	a7,12
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 65c:	48b5                	li	a7,13
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 664:	48b9                	li	a7,14
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <hello>:
.global hello
hello:
 li a7, SYS_hello
 66c:	48d9                	li	a7,22
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 674:	48dd                	li	a7,23
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 67c:	48e1                	li	a7,24
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 684:	1101                	addi	sp,sp,-32
 686:	ec06                	sd	ra,24(sp)
 688:	e822                	sd	s0,16(sp)
 68a:	1000                	addi	s0,sp,32
 68c:	87aa                	mv	a5,a0
 68e:	872e                	mv	a4,a1
 690:	fef42623          	sw	a5,-20(s0)
 694:	87ba                	mv	a5,a4
 696:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 69a:	feb40713          	addi	a4,s0,-21
 69e:	fec42783          	lw	a5,-20(s0)
 6a2:	4605                	li	a2,1
 6a4:	85ba                	mv	a1,a4
 6a6:	853e                	mv	a0,a5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	f44080e7          	jalr	-188(ra) # 5ec <write>
}
 6b0:	0001                	nop
 6b2:	60e2                	ld	ra,24(sp)
 6b4:	6442                	ld	s0,16(sp)
 6b6:	6105                	addi	sp,sp,32
 6b8:	8082                	ret

00000000000006ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6ba:	7139                	addi	sp,sp,-64
 6bc:	fc06                	sd	ra,56(sp)
 6be:	f822                	sd	s0,48(sp)
 6c0:	0080                	addi	s0,sp,64
 6c2:	87aa                	mv	a5,a0
 6c4:	8736                	mv	a4,a3
 6c6:	fcf42623          	sw	a5,-52(s0)
 6ca:	87ae                	mv	a5,a1
 6cc:	fcf42423          	sw	a5,-56(s0)
 6d0:	87b2                	mv	a5,a2
 6d2:	fcf42223          	sw	a5,-60(s0)
 6d6:	87ba                	mv	a5,a4
 6d8:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6dc:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 6e0:	fc042783          	lw	a5,-64(s0)
 6e4:	2781                	sext.w	a5,a5
 6e6:	c38d                	beqz	a5,708 <printint+0x4e>
 6e8:	fc842783          	lw	a5,-56(s0)
 6ec:	2781                	sext.w	a5,a5
 6ee:	0007dd63          	bgez	a5,708 <printint+0x4e>
    neg = 1;
 6f2:	4785                	li	a5,1
 6f4:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 6f8:	fc842783          	lw	a5,-56(s0)
 6fc:	40f007bb          	negw	a5,a5
 700:	2781                	sext.w	a5,a5
 702:	fef42223          	sw	a5,-28(s0)
 706:	a029                	j	710 <printint+0x56>
  } else {
    x = xx;
 708:	fc842783          	lw	a5,-56(s0)
 70c:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 710:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 714:	fc442783          	lw	a5,-60(s0)
 718:	fe442703          	lw	a4,-28(s0)
 71c:	02f777bb          	remuw	a5,a4,a5
 720:	0007861b          	sext.w	a2,a5
 724:	fec42783          	lw	a5,-20(s0)
 728:	0017871b          	addiw	a4,a5,1
 72c:	fee42623          	sw	a4,-20(s0)
 730:	00001697          	auipc	a3,0x1
 734:	c5068693          	addi	a3,a3,-944 # 1380 <digits>
 738:	02061713          	slli	a4,a2,0x20
 73c:	9301                	srli	a4,a4,0x20
 73e:	9736                	add	a4,a4,a3
 740:	00074703          	lbu	a4,0(a4)
 744:	17c1                	addi	a5,a5,-16
 746:	97a2                	add	a5,a5,s0
 748:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 74c:	fc442783          	lw	a5,-60(s0)
 750:	fe442703          	lw	a4,-28(s0)
 754:	02f757bb          	divuw	a5,a4,a5
 758:	fef42223          	sw	a5,-28(s0)
 75c:	fe442783          	lw	a5,-28(s0)
 760:	2781                	sext.w	a5,a5
 762:	fbcd                	bnez	a5,714 <printint+0x5a>
  if(neg)
 764:	fe842783          	lw	a5,-24(s0)
 768:	2781                	sext.w	a5,a5
 76a:	cf85                	beqz	a5,7a2 <printint+0xe8>
    buf[i++] = '-';
 76c:	fec42783          	lw	a5,-20(s0)
 770:	0017871b          	addiw	a4,a5,1
 774:	fee42623          	sw	a4,-20(s0)
 778:	17c1                	addi	a5,a5,-16
 77a:	97a2                	add	a5,a5,s0
 77c:	02d00713          	li	a4,45
 780:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 784:	a839                	j	7a2 <printint+0xe8>
    putc(fd, buf[i]);
 786:	fec42783          	lw	a5,-20(s0)
 78a:	17c1                	addi	a5,a5,-16
 78c:	97a2                	add	a5,a5,s0
 78e:	fe07c703          	lbu	a4,-32(a5)
 792:	fcc42783          	lw	a5,-52(s0)
 796:	85ba                	mv	a1,a4
 798:	853e                	mv	a0,a5
 79a:	00000097          	auipc	ra,0x0
 79e:	eea080e7          	jalr	-278(ra) # 684 <putc>
  while(--i >= 0)
 7a2:	fec42783          	lw	a5,-20(s0)
 7a6:	37fd                	addiw	a5,a5,-1
 7a8:	fef42623          	sw	a5,-20(s0)
 7ac:	fec42783          	lw	a5,-20(s0)
 7b0:	2781                	sext.w	a5,a5
 7b2:	fc07dae3          	bgez	a5,786 <printint+0xcc>
}
 7b6:	0001                	nop
 7b8:	0001                	nop
 7ba:	70e2                	ld	ra,56(sp)
 7bc:	7442                	ld	s0,48(sp)
 7be:	6121                	addi	sp,sp,64
 7c0:	8082                	ret

00000000000007c2 <printptr>:

static void
printptr(int fd, uint64 x) {
 7c2:	7179                	addi	sp,sp,-48
 7c4:	f406                	sd	ra,40(sp)
 7c6:	f022                	sd	s0,32(sp)
 7c8:	1800                	addi	s0,sp,48
 7ca:	87aa                	mv	a5,a0
 7cc:	fcb43823          	sd	a1,-48(s0)
 7d0:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 7d4:	fdc42783          	lw	a5,-36(s0)
 7d8:	03000593          	li	a1,48
 7dc:	853e                	mv	a0,a5
 7de:	00000097          	auipc	ra,0x0
 7e2:	ea6080e7          	jalr	-346(ra) # 684 <putc>
  putc(fd, 'x');
 7e6:	fdc42783          	lw	a5,-36(s0)
 7ea:	07800593          	li	a1,120
 7ee:	853e                	mv	a0,a5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	e94080e7          	jalr	-364(ra) # 684 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f8:	fe042623          	sw	zero,-20(s0)
 7fc:	a82d                	j	836 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fe:	fd043783          	ld	a5,-48(s0)
 802:	93f1                	srli	a5,a5,0x3c
 804:	00001717          	auipc	a4,0x1
 808:	b7c70713          	addi	a4,a4,-1156 # 1380 <digits>
 80c:	97ba                	add	a5,a5,a4
 80e:	0007c703          	lbu	a4,0(a5)
 812:	fdc42783          	lw	a5,-36(s0)
 816:	85ba                	mv	a1,a4
 818:	853e                	mv	a0,a5
 81a:	00000097          	auipc	ra,0x0
 81e:	e6a080e7          	jalr	-406(ra) # 684 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 822:	fec42783          	lw	a5,-20(s0)
 826:	2785                	addiw	a5,a5,1
 828:	fef42623          	sw	a5,-20(s0)
 82c:	fd043783          	ld	a5,-48(s0)
 830:	0792                	slli	a5,a5,0x4
 832:	fcf43823          	sd	a5,-48(s0)
 836:	fec42783          	lw	a5,-20(s0)
 83a:	873e                	mv	a4,a5
 83c:	47bd                	li	a5,15
 83e:	fce7f0e3          	bgeu	a5,a4,7fe <printptr+0x3c>
}
 842:	0001                	nop
 844:	0001                	nop
 846:	70a2                	ld	ra,40(sp)
 848:	7402                	ld	s0,32(sp)
 84a:	6145                	addi	sp,sp,48
 84c:	8082                	ret

000000000000084e <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 84e:	715d                	addi	sp,sp,-80
 850:	e486                	sd	ra,72(sp)
 852:	e0a2                	sd	s0,64(sp)
 854:	0880                	addi	s0,sp,80
 856:	87aa                	mv	a5,a0
 858:	fcb43023          	sd	a1,-64(s0)
 85c:	fac43c23          	sd	a2,-72(s0)
 860:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 864:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 868:	fe042223          	sw	zero,-28(s0)
 86c:	a42d                	j	a96 <vprintf+0x248>
    c = fmt[i] & 0xff;
 86e:	fe442783          	lw	a5,-28(s0)
 872:	fc043703          	ld	a4,-64(s0)
 876:	97ba                	add	a5,a5,a4
 878:	0007c783          	lbu	a5,0(a5)
 87c:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 880:	fe042783          	lw	a5,-32(s0)
 884:	2781                	sext.w	a5,a5
 886:	eb9d                	bnez	a5,8bc <vprintf+0x6e>
      if(c == '%'){
 888:	fdc42783          	lw	a5,-36(s0)
 88c:	0007871b          	sext.w	a4,a5
 890:	02500793          	li	a5,37
 894:	00f71763          	bne	a4,a5,8a2 <vprintf+0x54>
        state = '%';
 898:	02500793          	li	a5,37
 89c:	fef42023          	sw	a5,-32(s0)
 8a0:	a2f5                	j	a8c <vprintf+0x23e>
      } else {
        putc(fd, c);
 8a2:	fdc42783          	lw	a5,-36(s0)
 8a6:	0ff7f713          	zext.b	a4,a5
 8aa:	fcc42783          	lw	a5,-52(s0)
 8ae:	85ba                	mv	a1,a4
 8b0:	853e                	mv	a0,a5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	dd2080e7          	jalr	-558(ra) # 684 <putc>
 8ba:	aac9                	j	a8c <vprintf+0x23e>
      }
    } else if(state == '%'){
 8bc:	fe042783          	lw	a5,-32(s0)
 8c0:	0007871b          	sext.w	a4,a5
 8c4:	02500793          	li	a5,37
 8c8:	1cf71263          	bne	a4,a5,a8c <vprintf+0x23e>
      if(c == 'd'){
 8cc:	fdc42783          	lw	a5,-36(s0)
 8d0:	0007871b          	sext.w	a4,a5
 8d4:	06400793          	li	a5,100
 8d8:	02f71463          	bne	a4,a5,900 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 8dc:	fb843783          	ld	a5,-72(s0)
 8e0:	00878713          	addi	a4,a5,8
 8e4:	fae43c23          	sd	a4,-72(s0)
 8e8:	4398                	lw	a4,0(a5)
 8ea:	fcc42783          	lw	a5,-52(s0)
 8ee:	4685                	li	a3,1
 8f0:	4629                	li	a2,10
 8f2:	85ba                	mv	a1,a4
 8f4:	853e                	mv	a0,a5
 8f6:	00000097          	auipc	ra,0x0
 8fa:	dc4080e7          	jalr	-572(ra) # 6ba <printint>
 8fe:	a269                	j	a88 <vprintf+0x23a>
      } else if(c == 'l') {
 900:	fdc42783          	lw	a5,-36(s0)
 904:	0007871b          	sext.w	a4,a5
 908:	06c00793          	li	a5,108
 90c:	02f71663          	bne	a4,a5,938 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 910:	fb843783          	ld	a5,-72(s0)
 914:	00878713          	addi	a4,a5,8
 918:	fae43c23          	sd	a4,-72(s0)
 91c:	639c                	ld	a5,0(a5)
 91e:	0007871b          	sext.w	a4,a5
 922:	fcc42783          	lw	a5,-52(s0)
 926:	4681                	li	a3,0
 928:	4629                	li	a2,10
 92a:	85ba                	mv	a1,a4
 92c:	853e                	mv	a0,a5
 92e:	00000097          	auipc	ra,0x0
 932:	d8c080e7          	jalr	-628(ra) # 6ba <printint>
 936:	aa89                	j	a88 <vprintf+0x23a>
      } else if(c == 'x') {
 938:	fdc42783          	lw	a5,-36(s0)
 93c:	0007871b          	sext.w	a4,a5
 940:	07800793          	li	a5,120
 944:	02f71463          	bne	a4,a5,96c <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 948:	fb843783          	ld	a5,-72(s0)
 94c:	00878713          	addi	a4,a5,8
 950:	fae43c23          	sd	a4,-72(s0)
 954:	4398                	lw	a4,0(a5)
 956:	fcc42783          	lw	a5,-52(s0)
 95a:	4681                	li	a3,0
 95c:	4641                	li	a2,16
 95e:	85ba                	mv	a1,a4
 960:	853e                	mv	a0,a5
 962:	00000097          	auipc	ra,0x0
 966:	d58080e7          	jalr	-680(ra) # 6ba <printint>
 96a:	aa39                	j	a88 <vprintf+0x23a>
      } else if(c == 'p') {
 96c:	fdc42783          	lw	a5,-36(s0)
 970:	0007871b          	sext.w	a4,a5
 974:	07000793          	li	a5,112
 978:	02f71263          	bne	a4,a5,99c <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 97c:	fb843783          	ld	a5,-72(s0)
 980:	00878713          	addi	a4,a5,8
 984:	fae43c23          	sd	a4,-72(s0)
 988:	6398                	ld	a4,0(a5)
 98a:	fcc42783          	lw	a5,-52(s0)
 98e:	85ba                	mv	a1,a4
 990:	853e                	mv	a0,a5
 992:	00000097          	auipc	ra,0x0
 996:	e30080e7          	jalr	-464(ra) # 7c2 <printptr>
 99a:	a0fd                	j	a88 <vprintf+0x23a>
      } else if(c == 's'){
 99c:	fdc42783          	lw	a5,-36(s0)
 9a0:	0007871b          	sext.w	a4,a5
 9a4:	07300793          	li	a5,115
 9a8:	04f71c63          	bne	a4,a5,a00 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 9ac:	fb843783          	ld	a5,-72(s0)
 9b0:	00878713          	addi	a4,a5,8
 9b4:	fae43c23          	sd	a4,-72(s0)
 9b8:	639c                	ld	a5,0(a5)
 9ba:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 9be:	fe843783          	ld	a5,-24(s0)
 9c2:	eb8d                	bnez	a5,9f4 <vprintf+0x1a6>
          s = "(null)";
 9c4:	00000797          	auipc	a5,0x0
 9c8:	4f478793          	addi	a5,a5,1268 # eb8 <malloc+0x1ba>
 9cc:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9d0:	a015                	j	9f4 <vprintf+0x1a6>
          putc(fd, *s);
 9d2:	fe843783          	ld	a5,-24(s0)
 9d6:	0007c703          	lbu	a4,0(a5)
 9da:	fcc42783          	lw	a5,-52(s0)
 9de:	85ba                	mv	a1,a4
 9e0:	853e                	mv	a0,a5
 9e2:	00000097          	auipc	ra,0x0
 9e6:	ca2080e7          	jalr	-862(ra) # 684 <putc>
          s++;
 9ea:	fe843783          	ld	a5,-24(s0)
 9ee:	0785                	addi	a5,a5,1
 9f0:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9f4:	fe843783          	ld	a5,-24(s0)
 9f8:	0007c783          	lbu	a5,0(a5)
 9fc:	fbf9                	bnez	a5,9d2 <vprintf+0x184>
 9fe:	a069                	j	a88 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a00:	fdc42783          	lw	a5,-36(s0)
 a04:	0007871b          	sext.w	a4,a5
 a08:	06300793          	li	a5,99
 a0c:	02f71463          	bne	a4,a5,a34 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a10:	fb843783          	ld	a5,-72(s0)
 a14:	00878713          	addi	a4,a5,8
 a18:	fae43c23          	sd	a4,-72(s0)
 a1c:	439c                	lw	a5,0(a5)
 a1e:	0ff7f713          	zext.b	a4,a5
 a22:	fcc42783          	lw	a5,-52(s0)
 a26:	85ba                	mv	a1,a4
 a28:	853e                	mv	a0,a5
 a2a:	00000097          	auipc	ra,0x0
 a2e:	c5a080e7          	jalr	-934(ra) # 684 <putc>
 a32:	a899                	j	a88 <vprintf+0x23a>
      } else if(c == '%'){
 a34:	fdc42783          	lw	a5,-36(s0)
 a38:	0007871b          	sext.w	a4,a5
 a3c:	02500793          	li	a5,37
 a40:	00f71f63          	bne	a4,a5,a5e <vprintf+0x210>
        putc(fd, c);
 a44:	fdc42783          	lw	a5,-36(s0)
 a48:	0ff7f713          	zext.b	a4,a5
 a4c:	fcc42783          	lw	a5,-52(s0)
 a50:	85ba                	mv	a1,a4
 a52:	853e                	mv	a0,a5
 a54:	00000097          	auipc	ra,0x0
 a58:	c30080e7          	jalr	-976(ra) # 684 <putc>
 a5c:	a035                	j	a88 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a5e:	fcc42783          	lw	a5,-52(s0)
 a62:	02500593          	li	a1,37
 a66:	853e                	mv	a0,a5
 a68:	00000097          	auipc	ra,0x0
 a6c:	c1c080e7          	jalr	-996(ra) # 684 <putc>
        putc(fd, c);
 a70:	fdc42783          	lw	a5,-36(s0)
 a74:	0ff7f713          	zext.b	a4,a5
 a78:	fcc42783          	lw	a5,-52(s0)
 a7c:	85ba                	mv	a1,a4
 a7e:	853e                	mv	a0,a5
 a80:	00000097          	auipc	ra,0x0
 a84:	c04080e7          	jalr	-1020(ra) # 684 <putc>
      }
      state = 0;
 a88:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a8c:	fe442783          	lw	a5,-28(s0)
 a90:	2785                	addiw	a5,a5,1
 a92:	fef42223          	sw	a5,-28(s0)
 a96:	fe442783          	lw	a5,-28(s0)
 a9a:	fc043703          	ld	a4,-64(s0)
 a9e:	97ba                	add	a5,a5,a4
 aa0:	0007c783          	lbu	a5,0(a5)
 aa4:	dc0795e3          	bnez	a5,86e <vprintf+0x20>
    }
  }
}
 aa8:	0001                	nop
 aaa:	0001                	nop
 aac:	60a6                	ld	ra,72(sp)
 aae:	6406                	ld	s0,64(sp)
 ab0:	6161                	addi	sp,sp,80
 ab2:	8082                	ret

0000000000000ab4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ab4:	7159                	addi	sp,sp,-112
 ab6:	fc06                	sd	ra,56(sp)
 ab8:	f822                	sd	s0,48(sp)
 aba:	0080                	addi	s0,sp,64
 abc:	fcb43823          	sd	a1,-48(s0)
 ac0:	e010                	sd	a2,0(s0)
 ac2:	e414                	sd	a3,8(s0)
 ac4:	e818                	sd	a4,16(s0)
 ac6:	ec1c                	sd	a5,24(s0)
 ac8:	03043023          	sd	a6,32(s0)
 acc:	03143423          	sd	a7,40(s0)
 ad0:	87aa                	mv	a5,a0
 ad2:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 ad6:	03040793          	addi	a5,s0,48
 ada:	fcf43423          	sd	a5,-56(s0)
 ade:	fc843783          	ld	a5,-56(s0)
 ae2:	fd078793          	addi	a5,a5,-48
 ae6:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 aea:	fe843703          	ld	a4,-24(s0)
 aee:	fdc42783          	lw	a5,-36(s0)
 af2:	863a                	mv	a2,a4
 af4:	fd043583          	ld	a1,-48(s0)
 af8:	853e                	mv	a0,a5
 afa:	00000097          	auipc	ra,0x0
 afe:	d54080e7          	jalr	-684(ra) # 84e <vprintf>
}
 b02:	0001                	nop
 b04:	70e2                	ld	ra,56(sp)
 b06:	7442                	ld	s0,48(sp)
 b08:	6165                	addi	sp,sp,112
 b0a:	8082                	ret

0000000000000b0c <printf>:

void
printf(const char *fmt, ...)
{
 b0c:	7159                	addi	sp,sp,-112
 b0e:	f406                	sd	ra,40(sp)
 b10:	f022                	sd	s0,32(sp)
 b12:	1800                	addi	s0,sp,48
 b14:	fca43c23          	sd	a0,-40(s0)
 b18:	e40c                	sd	a1,8(s0)
 b1a:	e810                	sd	a2,16(s0)
 b1c:	ec14                	sd	a3,24(s0)
 b1e:	f018                	sd	a4,32(s0)
 b20:	f41c                	sd	a5,40(s0)
 b22:	03043823          	sd	a6,48(s0)
 b26:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b2a:	04040793          	addi	a5,s0,64
 b2e:	fcf43823          	sd	a5,-48(s0)
 b32:	fd043783          	ld	a5,-48(s0)
 b36:	fc878793          	addi	a5,a5,-56
 b3a:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 b3e:	fe843783          	ld	a5,-24(s0)
 b42:	863e                	mv	a2,a5
 b44:	fd843583          	ld	a1,-40(s0)
 b48:	4505                	li	a0,1
 b4a:	00000097          	auipc	ra,0x0
 b4e:	d04080e7          	jalr	-764(ra) # 84e <vprintf>
}
 b52:	0001                	nop
 b54:	70a2                	ld	ra,40(sp)
 b56:	7402                	ld	s0,32(sp)
 b58:	6165                	addi	sp,sp,112
 b5a:	8082                	ret

0000000000000b5c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b5c:	7179                	addi	sp,sp,-48
 b5e:	f422                	sd	s0,40(sp)
 b60:	1800                	addi	s0,sp,48
 b62:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b66:	fd843783          	ld	a5,-40(s0)
 b6a:	17c1                	addi	a5,a5,-16
 b6c:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b70:	00001797          	auipc	a5,0x1
 b74:	84078793          	addi	a5,a5,-1984 # 13b0 <freep>
 b78:	639c                	ld	a5,0(a5)
 b7a:	fef43423          	sd	a5,-24(s0)
 b7e:	a815                	j	bb2 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b80:	fe843783          	ld	a5,-24(s0)
 b84:	639c                	ld	a5,0(a5)
 b86:	fe843703          	ld	a4,-24(s0)
 b8a:	00f76f63          	bltu	a4,a5,ba8 <free+0x4c>
 b8e:	fe043703          	ld	a4,-32(s0)
 b92:	fe843783          	ld	a5,-24(s0)
 b96:	02e7eb63          	bltu	a5,a4,bcc <free+0x70>
 b9a:	fe843783          	ld	a5,-24(s0)
 b9e:	639c                	ld	a5,0(a5)
 ba0:	fe043703          	ld	a4,-32(s0)
 ba4:	02f76463          	bltu	a4,a5,bcc <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba8:	fe843783          	ld	a5,-24(s0)
 bac:	639c                	ld	a5,0(a5)
 bae:	fef43423          	sd	a5,-24(s0)
 bb2:	fe043703          	ld	a4,-32(s0)
 bb6:	fe843783          	ld	a5,-24(s0)
 bba:	fce7f3e3          	bgeu	a5,a4,b80 <free+0x24>
 bbe:	fe843783          	ld	a5,-24(s0)
 bc2:	639c                	ld	a5,0(a5)
 bc4:	fe043703          	ld	a4,-32(s0)
 bc8:	faf77ce3          	bgeu	a4,a5,b80 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 bcc:	fe043783          	ld	a5,-32(s0)
 bd0:	479c                	lw	a5,8(a5)
 bd2:	1782                	slli	a5,a5,0x20
 bd4:	9381                	srli	a5,a5,0x20
 bd6:	0792                	slli	a5,a5,0x4
 bd8:	fe043703          	ld	a4,-32(s0)
 bdc:	973e                	add	a4,a4,a5
 bde:	fe843783          	ld	a5,-24(s0)
 be2:	639c                	ld	a5,0(a5)
 be4:	02f71763          	bne	a4,a5,c12 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 be8:	fe043783          	ld	a5,-32(s0)
 bec:	4798                	lw	a4,8(a5)
 bee:	fe843783          	ld	a5,-24(s0)
 bf2:	639c                	ld	a5,0(a5)
 bf4:	479c                	lw	a5,8(a5)
 bf6:	9fb9                	addw	a5,a5,a4
 bf8:	0007871b          	sext.w	a4,a5
 bfc:	fe043783          	ld	a5,-32(s0)
 c00:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c02:	fe843783          	ld	a5,-24(s0)
 c06:	639c                	ld	a5,0(a5)
 c08:	6398                	ld	a4,0(a5)
 c0a:	fe043783          	ld	a5,-32(s0)
 c0e:	e398                	sd	a4,0(a5)
 c10:	a039                	j	c1e <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 c12:	fe843783          	ld	a5,-24(s0)
 c16:	6398                	ld	a4,0(a5)
 c18:	fe043783          	ld	a5,-32(s0)
 c1c:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c1e:	fe843783          	ld	a5,-24(s0)
 c22:	479c                	lw	a5,8(a5)
 c24:	1782                	slli	a5,a5,0x20
 c26:	9381                	srli	a5,a5,0x20
 c28:	0792                	slli	a5,a5,0x4
 c2a:	fe843703          	ld	a4,-24(s0)
 c2e:	97ba                	add	a5,a5,a4
 c30:	fe043703          	ld	a4,-32(s0)
 c34:	02f71563          	bne	a4,a5,c5e <free+0x102>
    p->s.size += bp->s.size;
 c38:	fe843783          	ld	a5,-24(s0)
 c3c:	4798                	lw	a4,8(a5)
 c3e:	fe043783          	ld	a5,-32(s0)
 c42:	479c                	lw	a5,8(a5)
 c44:	9fb9                	addw	a5,a5,a4
 c46:	0007871b          	sext.w	a4,a5
 c4a:	fe843783          	ld	a5,-24(s0)
 c4e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c50:	fe043783          	ld	a5,-32(s0)
 c54:	6398                	ld	a4,0(a5)
 c56:	fe843783          	ld	a5,-24(s0)
 c5a:	e398                	sd	a4,0(a5)
 c5c:	a031                	j	c68 <free+0x10c>
  } else
    p->s.ptr = bp;
 c5e:	fe843783          	ld	a5,-24(s0)
 c62:	fe043703          	ld	a4,-32(s0)
 c66:	e398                	sd	a4,0(a5)
  freep = p;
 c68:	00000797          	auipc	a5,0x0
 c6c:	74878793          	addi	a5,a5,1864 # 13b0 <freep>
 c70:	fe843703          	ld	a4,-24(s0)
 c74:	e398                	sd	a4,0(a5)
}
 c76:	0001                	nop
 c78:	7422                	ld	s0,40(sp)
 c7a:	6145                	addi	sp,sp,48
 c7c:	8082                	ret

0000000000000c7e <morecore>:

static Header*
morecore(uint nu)
{
 c7e:	7179                	addi	sp,sp,-48
 c80:	f406                	sd	ra,40(sp)
 c82:	f022                	sd	s0,32(sp)
 c84:	1800                	addi	s0,sp,48
 c86:	87aa                	mv	a5,a0
 c88:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c8c:	fdc42783          	lw	a5,-36(s0)
 c90:	0007871b          	sext.w	a4,a5
 c94:	6785                	lui	a5,0x1
 c96:	00f77563          	bgeu	a4,a5,ca0 <morecore+0x22>
    nu = 4096;
 c9a:	6785                	lui	a5,0x1
 c9c:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 ca0:	fdc42783          	lw	a5,-36(s0)
 ca4:	0047979b          	slliw	a5,a5,0x4
 ca8:	2781                	sext.w	a5,a5
 caa:	2781                	sext.w	a5,a5
 cac:	853e                	mv	a0,a5
 cae:	00000097          	auipc	ra,0x0
 cb2:	9a6080e7          	jalr	-1626(ra) # 654 <sbrk>
 cb6:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 cba:	fe843703          	ld	a4,-24(s0)
 cbe:	57fd                	li	a5,-1
 cc0:	00f71463          	bne	a4,a5,cc8 <morecore+0x4a>
    return 0;
 cc4:	4781                	li	a5,0
 cc6:	a03d                	j	cf4 <morecore+0x76>
  hp = (Header*)p;
 cc8:	fe843783          	ld	a5,-24(s0)
 ccc:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 cd0:	fe043783          	ld	a5,-32(s0)
 cd4:	fdc42703          	lw	a4,-36(s0)
 cd8:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 cda:	fe043783          	ld	a5,-32(s0)
 cde:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x312>
 ce0:	853e                	mv	a0,a5
 ce2:	00000097          	auipc	ra,0x0
 ce6:	e7a080e7          	jalr	-390(ra) # b5c <free>
  return freep;
 cea:	00000797          	auipc	a5,0x0
 cee:	6c678793          	addi	a5,a5,1734 # 13b0 <freep>
 cf2:	639c                	ld	a5,0(a5)
}
 cf4:	853e                	mv	a0,a5
 cf6:	70a2                	ld	ra,40(sp)
 cf8:	7402                	ld	s0,32(sp)
 cfa:	6145                	addi	sp,sp,48
 cfc:	8082                	ret

0000000000000cfe <malloc>:

void*
malloc(uint nbytes)
{
 cfe:	7139                	addi	sp,sp,-64
 d00:	fc06                	sd	ra,56(sp)
 d02:	f822                	sd	s0,48(sp)
 d04:	0080                	addi	s0,sp,64
 d06:	87aa                	mv	a5,a0
 d08:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d0c:	fcc46783          	lwu	a5,-52(s0)
 d10:	07bd                	addi	a5,a5,15
 d12:	8391                	srli	a5,a5,0x4
 d14:	2781                	sext.w	a5,a5
 d16:	2785                	addiw	a5,a5,1
 d18:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d1c:	00000797          	auipc	a5,0x0
 d20:	69478793          	addi	a5,a5,1684 # 13b0 <freep>
 d24:	639c                	ld	a5,0(a5)
 d26:	fef43023          	sd	a5,-32(s0)
 d2a:	fe043783          	ld	a5,-32(s0)
 d2e:	ef95                	bnez	a5,d6a <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d30:	00000797          	auipc	a5,0x0
 d34:	67078793          	addi	a5,a5,1648 # 13a0 <base>
 d38:	fef43023          	sd	a5,-32(s0)
 d3c:	00000797          	auipc	a5,0x0
 d40:	67478793          	addi	a5,a5,1652 # 13b0 <freep>
 d44:	fe043703          	ld	a4,-32(s0)
 d48:	e398                	sd	a4,0(a5)
 d4a:	00000797          	auipc	a5,0x0
 d4e:	66678793          	addi	a5,a5,1638 # 13b0 <freep>
 d52:	6398                	ld	a4,0(a5)
 d54:	00000797          	auipc	a5,0x0
 d58:	64c78793          	addi	a5,a5,1612 # 13a0 <base>
 d5c:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 d5e:	00000797          	auipc	a5,0x0
 d62:	64278793          	addi	a5,a5,1602 # 13a0 <base>
 d66:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d6a:	fe043783          	ld	a5,-32(s0)
 d6e:	639c                	ld	a5,0(a5)
 d70:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d74:	fe843783          	ld	a5,-24(s0)
 d78:	4798                	lw	a4,8(a5)
 d7a:	fdc42783          	lw	a5,-36(s0)
 d7e:	2781                	sext.w	a5,a5
 d80:	06f76763          	bltu	a4,a5,dee <malloc+0xf0>
      if(p->s.size == nunits)
 d84:	fe843783          	ld	a5,-24(s0)
 d88:	4798                	lw	a4,8(a5)
 d8a:	fdc42783          	lw	a5,-36(s0)
 d8e:	2781                	sext.w	a5,a5
 d90:	00e79963          	bne	a5,a4,da2 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d94:	fe843783          	ld	a5,-24(s0)
 d98:	6398                	ld	a4,0(a5)
 d9a:	fe043783          	ld	a5,-32(s0)
 d9e:	e398                	sd	a4,0(a5)
 da0:	a825                	j	dd8 <malloc+0xda>
      else {
        p->s.size -= nunits;
 da2:	fe843783          	ld	a5,-24(s0)
 da6:	479c                	lw	a5,8(a5)
 da8:	fdc42703          	lw	a4,-36(s0)
 dac:	9f99                	subw	a5,a5,a4
 dae:	0007871b          	sext.w	a4,a5
 db2:	fe843783          	ld	a5,-24(s0)
 db6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 db8:	fe843783          	ld	a5,-24(s0)
 dbc:	479c                	lw	a5,8(a5)
 dbe:	1782                	slli	a5,a5,0x20
 dc0:	9381                	srli	a5,a5,0x20
 dc2:	0792                	slli	a5,a5,0x4
 dc4:	fe843703          	ld	a4,-24(s0)
 dc8:	97ba                	add	a5,a5,a4
 dca:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 dce:	fe843783          	ld	a5,-24(s0)
 dd2:	fdc42703          	lw	a4,-36(s0)
 dd6:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 dd8:	00000797          	auipc	a5,0x0
 ddc:	5d878793          	addi	a5,a5,1496 # 13b0 <freep>
 de0:	fe043703          	ld	a4,-32(s0)
 de4:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 de6:	fe843783          	ld	a5,-24(s0)
 dea:	07c1                	addi	a5,a5,16
 dec:	a091                	j	e30 <malloc+0x132>
    }
    if(p == freep)
 dee:	00000797          	auipc	a5,0x0
 df2:	5c278793          	addi	a5,a5,1474 # 13b0 <freep>
 df6:	639c                	ld	a5,0(a5)
 df8:	fe843703          	ld	a4,-24(s0)
 dfc:	02f71063          	bne	a4,a5,e1c <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e00:	fdc42783          	lw	a5,-36(s0)
 e04:	853e                	mv	a0,a5
 e06:	00000097          	auipc	ra,0x0
 e0a:	e78080e7          	jalr	-392(ra) # c7e <morecore>
 e0e:	fea43423          	sd	a0,-24(s0)
 e12:	fe843783          	ld	a5,-24(s0)
 e16:	e399                	bnez	a5,e1c <malloc+0x11e>
        return 0;
 e18:	4781                	li	a5,0
 e1a:	a819                	j	e30 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e1c:	fe843783          	ld	a5,-24(s0)
 e20:	fef43023          	sd	a5,-32(s0)
 e24:	fe843783          	ld	a5,-24(s0)
 e28:	639c                	ld	a5,0(a5)
 e2a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e2e:	b799                	j	d74 <malloc+0x76>
  }
}
 e30:	853e                	mv	a0,a5
 e32:	70e2                	ld	ra,56(sp)
 e34:	7442                	ld	s0,48(sp)
 e36:	6121                	addi	sp,sp,64
 e38:	8082                	ret
