
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
    int pid;
    int state;
};


int main(int argc, char *argv[]) {
   0:	9d010113          	addi	sp,sp,-1584
   4:	62113423          	sd	ra,1576(sp)
   8:	62813023          	sd	s0,1568(sp)
   c:	63010413          	addi	s0,sp,1584
  10:	87aa                	mv	a5,a0
  12:	9cb43823          	sd	a1,-1584(s0)
  16:	9cf42e23          	sw	a5,-1572(s0)

   struct process_info processes[64]; // Store retrieved processes

   int count = get_process((uint64)processes); // receive current processes from kernel
  1a:	9e840793          	addi	a5,s0,-1560
  1e:	853e                	mv	a0,a5
  20:	00000097          	auipc	ra,0x0
  24:	600080e7          	jalr	1536(ra) # 620 <get_process>
  28:	87aa                	mv	a5,a0
  2a:	fef42423          	sw	a5,-24(s0)

   if (count < 0) { // check if failed
  2e:	fe842783          	lw	a5,-24(s0)
  32:	2781                	sext.w	a5,a5
  34:	0007df63          	bgez	a5,52 <main+0x52>
      printf("Error getting processes");
  38:	00001517          	auipc	a0,0x1
  3c:	db850513          	addi	a0,a0,-584 # df0 <malloc+0x146>
  40:	00001097          	auipc	ra,0x1
  44:	a78080e7          	jalr	-1416(ra) # ab8 <printf>
      exit(1);
  48:	4505                	li	a0,1
  4a:	00000097          	auipc	ra,0x0
  4e:	52e080e7          	jalr	1326(ra) # 578 <exit>
   }

   // print out information
   for (int i = 0; i < count; i++) {
  52:	fe042623          	sw	zero,-20(s0)
  56:	a8a9                	j	b0 <main+0xb0>
      printf("%s (%d): %d\n", processes[i].name, processes[i].pid, processes[i].state); 
  58:	9e840693          	addi	a3,s0,-1560
  5c:	fec42703          	lw	a4,-20(s0)
  60:	87ba                	mv	a5,a4
  62:	0786                	slli	a5,a5,0x1
  64:	97ba                	add	a5,a5,a4
  66:	078e                	slli	a5,a5,0x3
  68:	00f685b3          	add	a1,a3,a5
  6c:	fec42703          	lw	a4,-20(s0)
  70:	87ba                	mv	a5,a4
  72:	0786                	slli	a5,a5,0x1
  74:	97ba                	add	a5,a5,a4
  76:	078e                	slli	a5,a5,0x3
  78:	17c1                	addi	a5,a5,-16
  7a:	97a2                	add	a5,a5,s0
  7c:	a087a603          	lw	a2,-1528(a5)
  80:	fec42703          	lw	a4,-20(s0)
  84:	87ba                	mv	a5,a4
  86:	0786                	slli	a5,a5,0x1
  88:	97ba                	add	a5,a5,a4
  8a:	078e                	slli	a5,a5,0x3
  8c:	17c1                	addi	a5,a5,-16
  8e:	97a2                	add	a5,a5,s0
  90:	a0c7a783          	lw	a5,-1524(a5)
  94:	86be                	mv	a3,a5
  96:	00001517          	auipc	a0,0x1
  9a:	d7250513          	addi	a0,a0,-654 # e08 <malloc+0x15e>
  9e:	00001097          	auipc	ra,0x1
  a2:	a1a080e7          	jalr	-1510(ra) # ab8 <printf>
   for (int i = 0; i < count; i++) {
  a6:	fec42783          	lw	a5,-20(s0)
  aa:	2785                	addiw	a5,a5,1
  ac:	fef42623          	sw	a5,-20(s0)
  b0:	fec42783          	lw	a5,-20(s0)
  b4:	873e                	mv	a4,a5
  b6:	fe842783          	lw	a5,-24(s0)
  ba:	2701                	sext.w	a4,a4
  bc:	2781                	sext.w	a5,a5
  be:	f8f74de3          	blt	a4,a5,58 <main+0x58>
   }

  
   exit(0);
  c2:	4501                	li	a0,0
  c4:	00000097          	auipc	ra,0x0
  c8:	4b4080e7          	jalr	1204(ra) # 578 <exit>

00000000000000cc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  d4:	00000097          	auipc	ra,0x0
  d8:	f2c080e7          	jalr	-212(ra) # 0 <main>
  exit(0);
  dc:	4501                	li	a0,0
  de:	00000097          	auipc	ra,0x0
  e2:	49a080e7          	jalr	1178(ra) # 578 <exit>

00000000000000e6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  e6:	7179                	addi	sp,sp,-48
  e8:	f422                	sd	s0,40(sp)
  ea:	1800                	addi	s0,sp,48
  ec:	fca43c23          	sd	a0,-40(s0)
  f0:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  f4:	fd843783          	ld	a5,-40(s0)
  f8:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  fc:	0001                	nop
  fe:	fd043703          	ld	a4,-48(s0)
 102:	00170793          	addi	a5,a4,1
 106:	fcf43823          	sd	a5,-48(s0)
 10a:	fd843783          	ld	a5,-40(s0)
 10e:	00178693          	addi	a3,a5,1
 112:	fcd43c23          	sd	a3,-40(s0)
 116:	00074703          	lbu	a4,0(a4)
 11a:	00e78023          	sb	a4,0(a5)
 11e:	0007c783          	lbu	a5,0(a5)
 122:	fff1                	bnez	a5,fe <strcpy+0x18>
    ;
  return os;
 124:	fe843783          	ld	a5,-24(s0)
}
 128:	853e                	mv	a0,a5
 12a:	7422                	ld	s0,40(sp)
 12c:	6145                	addi	sp,sp,48
 12e:	8082                	ret

0000000000000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	1101                	addi	sp,sp,-32
 132:	ec22                	sd	s0,24(sp)
 134:	1000                	addi	s0,sp,32
 136:	fea43423          	sd	a0,-24(s0)
 13a:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 13e:	a819                	j	154 <strcmp+0x24>
    p++, q++;
 140:	fe843783          	ld	a5,-24(s0)
 144:	0785                	addi	a5,a5,1
 146:	fef43423          	sd	a5,-24(s0)
 14a:	fe043783          	ld	a5,-32(s0)
 14e:	0785                	addi	a5,a5,1
 150:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 154:	fe843783          	ld	a5,-24(s0)
 158:	0007c783          	lbu	a5,0(a5)
 15c:	cb99                	beqz	a5,172 <strcmp+0x42>
 15e:	fe843783          	ld	a5,-24(s0)
 162:	0007c703          	lbu	a4,0(a5)
 166:	fe043783          	ld	a5,-32(s0)
 16a:	0007c783          	lbu	a5,0(a5)
 16e:	fcf709e3          	beq	a4,a5,140 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 172:	fe843783          	ld	a5,-24(s0)
 176:	0007c783          	lbu	a5,0(a5)
 17a:	0007871b          	sext.w	a4,a5
 17e:	fe043783          	ld	a5,-32(s0)
 182:	0007c783          	lbu	a5,0(a5)
 186:	2781                	sext.w	a5,a5
 188:	40f707bb          	subw	a5,a4,a5
 18c:	2781                	sext.w	a5,a5
}
 18e:	853e                	mv	a0,a5
 190:	6462                	ld	s0,24(sp)
 192:	6105                	addi	sp,sp,32
 194:	8082                	ret

0000000000000196 <strlen>:

uint
strlen(const char *s)
{
 196:	7179                	addi	sp,sp,-48
 198:	f422                	sd	s0,40(sp)
 19a:	1800                	addi	s0,sp,48
 19c:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 1a0:	fe042623          	sw	zero,-20(s0)
 1a4:	a031                	j	1b0 <strlen+0x1a>
 1a6:	fec42783          	lw	a5,-20(s0)
 1aa:	2785                	addiw	a5,a5,1
 1ac:	fef42623          	sw	a5,-20(s0)
 1b0:	fec42783          	lw	a5,-20(s0)
 1b4:	fd843703          	ld	a4,-40(s0)
 1b8:	97ba                	add	a5,a5,a4
 1ba:	0007c783          	lbu	a5,0(a5)
 1be:	f7e5                	bnez	a5,1a6 <strlen+0x10>
    ;
  return n;
 1c0:	fec42783          	lw	a5,-20(s0)
}
 1c4:	853e                	mv	a0,a5
 1c6:	7422                	ld	s0,40(sp)
 1c8:	6145                	addi	sp,sp,48
 1ca:	8082                	ret

00000000000001cc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cc:	7179                	addi	sp,sp,-48
 1ce:	f422                	sd	s0,40(sp)
 1d0:	1800                	addi	s0,sp,48
 1d2:	fca43c23          	sd	a0,-40(s0)
 1d6:	87ae                	mv	a5,a1
 1d8:	8732                	mv	a4,a2
 1da:	fcf42a23          	sw	a5,-44(s0)
 1de:	87ba                	mv	a5,a4
 1e0:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1e4:	fd843783          	ld	a5,-40(s0)
 1e8:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1ec:	fe042623          	sw	zero,-20(s0)
 1f0:	a00d                	j	212 <memset+0x46>
    cdst[i] = c;
 1f2:	fec42783          	lw	a5,-20(s0)
 1f6:	fe043703          	ld	a4,-32(s0)
 1fa:	97ba                	add	a5,a5,a4
 1fc:	fd442703          	lw	a4,-44(s0)
 200:	0ff77713          	zext.b	a4,a4
 204:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 208:	fec42783          	lw	a5,-20(s0)
 20c:	2785                	addiw	a5,a5,1
 20e:	fef42623          	sw	a5,-20(s0)
 212:	fec42703          	lw	a4,-20(s0)
 216:	fd042783          	lw	a5,-48(s0)
 21a:	2781                	sext.w	a5,a5
 21c:	fcf76be3          	bltu	a4,a5,1f2 <memset+0x26>
  }
  return dst;
 220:	fd843783          	ld	a5,-40(s0)
}
 224:	853e                	mv	a0,a5
 226:	7422                	ld	s0,40(sp)
 228:	6145                	addi	sp,sp,48
 22a:	8082                	ret

000000000000022c <strchr>:

char*
strchr(const char *s, char c)
{
 22c:	1101                	addi	sp,sp,-32
 22e:	ec22                	sd	s0,24(sp)
 230:	1000                	addi	s0,sp,32
 232:	fea43423          	sd	a0,-24(s0)
 236:	87ae                	mv	a5,a1
 238:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 23c:	a01d                	j	262 <strchr+0x36>
    if(*s == c)
 23e:	fe843783          	ld	a5,-24(s0)
 242:	0007c703          	lbu	a4,0(a5)
 246:	fe744783          	lbu	a5,-25(s0)
 24a:	0ff7f793          	zext.b	a5,a5
 24e:	00e79563          	bne	a5,a4,258 <strchr+0x2c>
      return (char*)s;
 252:	fe843783          	ld	a5,-24(s0)
 256:	a821                	j	26e <strchr+0x42>
  for(; *s; s++)
 258:	fe843783          	ld	a5,-24(s0)
 25c:	0785                	addi	a5,a5,1
 25e:	fef43423          	sd	a5,-24(s0)
 262:	fe843783          	ld	a5,-24(s0)
 266:	0007c783          	lbu	a5,0(a5)
 26a:	fbf1                	bnez	a5,23e <strchr+0x12>
  return 0;
 26c:	4781                	li	a5,0
}
 26e:	853e                	mv	a0,a5
 270:	6462                	ld	s0,24(sp)
 272:	6105                	addi	sp,sp,32
 274:	8082                	ret

0000000000000276 <gets>:

char*
gets(char *buf, int max)
{
 276:	7179                	addi	sp,sp,-48
 278:	f406                	sd	ra,40(sp)
 27a:	f022                	sd	s0,32(sp)
 27c:	1800                	addi	s0,sp,48
 27e:	fca43c23          	sd	a0,-40(s0)
 282:	87ae                	mv	a5,a1
 284:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 288:	fe042623          	sw	zero,-20(s0)
 28c:	a8a1                	j	2e4 <gets+0x6e>
    cc = read(0, &c, 1);
 28e:	fe740793          	addi	a5,s0,-25
 292:	4605                	li	a2,1
 294:	85be                	mv	a1,a5
 296:	4501                	li	a0,0
 298:	00000097          	auipc	ra,0x0
 29c:	2f8080e7          	jalr	760(ra) # 590 <read>
 2a0:	87aa                	mv	a5,a0
 2a2:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 2a6:	fe842783          	lw	a5,-24(s0)
 2aa:	2781                	sext.w	a5,a5
 2ac:	04f05763          	blez	a5,2fa <gets+0x84>
      break;
    buf[i++] = c;
 2b0:	fec42783          	lw	a5,-20(s0)
 2b4:	0017871b          	addiw	a4,a5,1
 2b8:	fee42623          	sw	a4,-20(s0)
 2bc:	873e                	mv	a4,a5
 2be:	fd843783          	ld	a5,-40(s0)
 2c2:	97ba                	add	a5,a5,a4
 2c4:	fe744703          	lbu	a4,-25(s0)
 2c8:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2cc:	fe744783          	lbu	a5,-25(s0)
 2d0:	873e                	mv	a4,a5
 2d2:	47a9                	li	a5,10
 2d4:	02f70463          	beq	a4,a5,2fc <gets+0x86>
 2d8:	fe744783          	lbu	a5,-25(s0)
 2dc:	873e                	mv	a4,a5
 2de:	47b5                	li	a5,13
 2e0:	00f70e63          	beq	a4,a5,2fc <gets+0x86>
  for(i=0; i+1 < max; ){
 2e4:	fec42783          	lw	a5,-20(s0)
 2e8:	2785                	addiw	a5,a5,1
 2ea:	0007871b          	sext.w	a4,a5
 2ee:	fd442783          	lw	a5,-44(s0)
 2f2:	2781                	sext.w	a5,a5
 2f4:	f8f74de3          	blt	a4,a5,28e <gets+0x18>
 2f8:	a011                	j	2fc <gets+0x86>
      break;
 2fa:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2fc:	fec42783          	lw	a5,-20(s0)
 300:	fd843703          	ld	a4,-40(s0)
 304:	97ba                	add	a5,a5,a4
 306:	00078023          	sb	zero,0(a5)
  return buf;
 30a:	fd843783          	ld	a5,-40(s0)
}
 30e:	853e                	mv	a0,a5
 310:	70a2                	ld	ra,40(sp)
 312:	7402                	ld	s0,32(sp)
 314:	6145                	addi	sp,sp,48
 316:	8082                	ret

0000000000000318 <stat>:

int
stat(const char *n, struct stat *st)
{
 318:	7179                	addi	sp,sp,-48
 31a:	f406                	sd	ra,40(sp)
 31c:	f022                	sd	s0,32(sp)
 31e:	1800                	addi	s0,sp,48
 320:	fca43c23          	sd	a0,-40(s0)
 324:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 328:	4581                	li	a1,0
 32a:	fd843503          	ld	a0,-40(s0)
 32e:	00000097          	auipc	ra,0x0
 332:	28a080e7          	jalr	650(ra) # 5b8 <open>
 336:	87aa                	mv	a5,a0
 338:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 33c:	fec42783          	lw	a5,-20(s0)
 340:	2781                	sext.w	a5,a5
 342:	0007d463          	bgez	a5,34a <stat+0x32>
    return -1;
 346:	57fd                	li	a5,-1
 348:	a035                	j	374 <stat+0x5c>
  r = fstat(fd, st);
 34a:	fec42783          	lw	a5,-20(s0)
 34e:	fd043583          	ld	a1,-48(s0)
 352:	853e                	mv	a0,a5
 354:	00000097          	auipc	ra,0x0
 358:	27c080e7          	jalr	636(ra) # 5d0 <fstat>
 35c:	87aa                	mv	a5,a0
 35e:	fef42423          	sw	a5,-24(s0)
  close(fd);
 362:	fec42783          	lw	a5,-20(s0)
 366:	853e                	mv	a0,a5
 368:	00000097          	auipc	ra,0x0
 36c:	238080e7          	jalr	568(ra) # 5a0 <close>
  return r;
 370:	fe842783          	lw	a5,-24(s0)
}
 374:	853e                	mv	a0,a5
 376:	70a2                	ld	ra,40(sp)
 378:	7402                	ld	s0,32(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret

000000000000037e <atoi>:

int
atoi(const char *s)
{
 37e:	7179                	addi	sp,sp,-48
 380:	f422                	sd	s0,40(sp)
 382:	1800                	addi	s0,sp,48
 384:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 388:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 38c:	a81d                	j	3c2 <atoi+0x44>
    n = n*10 + *s++ - '0';
 38e:	fec42783          	lw	a5,-20(s0)
 392:	873e                	mv	a4,a5
 394:	87ba                	mv	a5,a4
 396:	0027979b          	slliw	a5,a5,0x2
 39a:	9fb9                	addw	a5,a5,a4
 39c:	0017979b          	slliw	a5,a5,0x1
 3a0:	0007871b          	sext.w	a4,a5
 3a4:	fd843783          	ld	a5,-40(s0)
 3a8:	00178693          	addi	a3,a5,1
 3ac:	fcd43c23          	sd	a3,-40(s0)
 3b0:	0007c783          	lbu	a5,0(a5)
 3b4:	2781                	sext.w	a5,a5
 3b6:	9fb9                	addw	a5,a5,a4
 3b8:	2781                	sext.w	a5,a5
 3ba:	fd07879b          	addiw	a5,a5,-48
 3be:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 3c2:	fd843783          	ld	a5,-40(s0)
 3c6:	0007c783          	lbu	a5,0(a5)
 3ca:	873e                	mv	a4,a5
 3cc:	02f00793          	li	a5,47
 3d0:	00e7fb63          	bgeu	a5,a4,3e6 <atoi+0x68>
 3d4:	fd843783          	ld	a5,-40(s0)
 3d8:	0007c783          	lbu	a5,0(a5)
 3dc:	873e                	mv	a4,a5
 3de:	03900793          	li	a5,57
 3e2:	fae7f6e3          	bgeu	a5,a4,38e <atoi+0x10>
  return n;
 3e6:	fec42783          	lw	a5,-20(s0)
}
 3ea:	853e                	mv	a0,a5
 3ec:	7422                	ld	s0,40(sp)
 3ee:	6145                	addi	sp,sp,48
 3f0:	8082                	ret

00000000000003f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f2:	7139                	addi	sp,sp,-64
 3f4:	fc22                	sd	s0,56(sp)
 3f6:	0080                	addi	s0,sp,64
 3f8:	fca43c23          	sd	a0,-40(s0)
 3fc:	fcb43823          	sd	a1,-48(s0)
 400:	87b2                	mv	a5,a2
 402:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 406:	fd843783          	ld	a5,-40(s0)
 40a:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 40e:	fd043783          	ld	a5,-48(s0)
 412:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 416:	fe043703          	ld	a4,-32(s0)
 41a:	fe843783          	ld	a5,-24(s0)
 41e:	02e7fc63          	bgeu	a5,a4,456 <memmove+0x64>
    while(n-- > 0)
 422:	a00d                	j	444 <memmove+0x52>
      *dst++ = *src++;
 424:	fe043703          	ld	a4,-32(s0)
 428:	00170793          	addi	a5,a4,1
 42c:	fef43023          	sd	a5,-32(s0)
 430:	fe843783          	ld	a5,-24(s0)
 434:	00178693          	addi	a3,a5,1
 438:	fed43423          	sd	a3,-24(s0)
 43c:	00074703          	lbu	a4,0(a4)
 440:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 444:	fcc42783          	lw	a5,-52(s0)
 448:	fff7871b          	addiw	a4,a5,-1
 44c:	fce42623          	sw	a4,-52(s0)
 450:	fcf04ae3          	bgtz	a5,424 <memmove+0x32>
 454:	a891                	j	4a8 <memmove+0xb6>
  } else {
    dst += n;
 456:	fcc42783          	lw	a5,-52(s0)
 45a:	fe843703          	ld	a4,-24(s0)
 45e:	97ba                	add	a5,a5,a4
 460:	fef43423          	sd	a5,-24(s0)
    src += n;
 464:	fcc42783          	lw	a5,-52(s0)
 468:	fe043703          	ld	a4,-32(s0)
 46c:	97ba                	add	a5,a5,a4
 46e:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 472:	a01d                	j	498 <memmove+0xa6>
      *--dst = *--src;
 474:	fe043783          	ld	a5,-32(s0)
 478:	17fd                	addi	a5,a5,-1
 47a:	fef43023          	sd	a5,-32(s0)
 47e:	fe843783          	ld	a5,-24(s0)
 482:	17fd                	addi	a5,a5,-1
 484:	fef43423          	sd	a5,-24(s0)
 488:	fe043783          	ld	a5,-32(s0)
 48c:	0007c703          	lbu	a4,0(a5)
 490:	fe843783          	ld	a5,-24(s0)
 494:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 498:	fcc42783          	lw	a5,-52(s0)
 49c:	fff7871b          	addiw	a4,a5,-1
 4a0:	fce42623          	sw	a4,-52(s0)
 4a4:	fcf048e3          	bgtz	a5,474 <memmove+0x82>
  }
  return vdst;
 4a8:	fd843783          	ld	a5,-40(s0)
}
 4ac:	853e                	mv	a0,a5
 4ae:	7462                	ld	s0,56(sp)
 4b0:	6121                	addi	sp,sp,64
 4b2:	8082                	ret

00000000000004b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b4:	7139                	addi	sp,sp,-64
 4b6:	fc22                	sd	s0,56(sp)
 4b8:	0080                	addi	s0,sp,64
 4ba:	fca43c23          	sd	a0,-40(s0)
 4be:	fcb43823          	sd	a1,-48(s0)
 4c2:	87b2                	mv	a5,a2
 4c4:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4c8:	fd843783          	ld	a5,-40(s0)
 4cc:	fef43423          	sd	a5,-24(s0)
 4d0:	fd043783          	ld	a5,-48(s0)
 4d4:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4d8:	a0a1                	j	520 <memcmp+0x6c>
    if (*p1 != *p2) {
 4da:	fe843783          	ld	a5,-24(s0)
 4de:	0007c703          	lbu	a4,0(a5)
 4e2:	fe043783          	ld	a5,-32(s0)
 4e6:	0007c783          	lbu	a5,0(a5)
 4ea:	02f70163          	beq	a4,a5,50c <memcmp+0x58>
      return *p1 - *p2;
 4ee:	fe843783          	ld	a5,-24(s0)
 4f2:	0007c783          	lbu	a5,0(a5)
 4f6:	0007871b          	sext.w	a4,a5
 4fa:	fe043783          	ld	a5,-32(s0)
 4fe:	0007c783          	lbu	a5,0(a5)
 502:	2781                	sext.w	a5,a5
 504:	40f707bb          	subw	a5,a4,a5
 508:	2781                	sext.w	a5,a5
 50a:	a01d                	j	530 <memcmp+0x7c>
    }
    p1++;
 50c:	fe843783          	ld	a5,-24(s0)
 510:	0785                	addi	a5,a5,1
 512:	fef43423          	sd	a5,-24(s0)
    p2++;
 516:	fe043783          	ld	a5,-32(s0)
 51a:	0785                	addi	a5,a5,1
 51c:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 520:	fcc42783          	lw	a5,-52(s0)
 524:	fff7871b          	addiw	a4,a5,-1
 528:	fce42623          	sw	a4,-52(s0)
 52c:	f7dd                	bnez	a5,4da <memcmp+0x26>
  }
  return 0;
 52e:	4781                	li	a5,0
}
 530:	853e                	mv	a0,a5
 532:	7462                	ld	s0,56(sp)
 534:	6121                	addi	sp,sp,64
 536:	8082                	ret

0000000000000538 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 538:	7179                	addi	sp,sp,-48
 53a:	f406                	sd	ra,40(sp)
 53c:	f022                	sd	s0,32(sp)
 53e:	1800                	addi	s0,sp,48
 540:	fea43423          	sd	a0,-24(s0)
 544:	feb43023          	sd	a1,-32(s0)
 548:	87b2                	mv	a5,a2
 54a:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 54e:	fdc42783          	lw	a5,-36(s0)
 552:	863e                	mv	a2,a5
 554:	fe043583          	ld	a1,-32(s0)
 558:	fe843503          	ld	a0,-24(s0)
 55c:	00000097          	auipc	ra,0x0
 560:	e96080e7          	jalr	-362(ra) # 3f2 <memmove>
 564:	87aa                	mv	a5,a0
}
 566:	853e                	mv	a0,a5
 568:	70a2                	ld	ra,40(sp)
 56a:	7402                	ld	s0,32(sp)
 56c:	6145                	addi	sp,sp,48
 56e:	8082                	ret

0000000000000570 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 570:	4885                	li	a7,1
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <exit>:
.global exit
exit:
 li a7, SYS_exit
 578:	4889                	li	a7,2
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <wait>:
.global wait
wait:
 li a7, SYS_wait
 580:	488d                	li	a7,3
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 588:	4891                	li	a7,4
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <read>:
.global read
read:
 li a7, SYS_read
 590:	4895                	li	a7,5
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <write>:
.global write
write:
 li a7, SYS_write
 598:	48c1                	li	a7,16
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <close>:
.global close
close:
 li a7, SYS_close
 5a0:	48d5                	li	a7,21
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a8:	4899                	li	a7,6
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b0:	489d                	li	a7,7
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <open>:
.global open
open:
 li a7, SYS_open
 5b8:	48bd                	li	a7,15
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c0:	48c5                	li	a7,17
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c8:	48c9                	li	a7,18
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d0:	48a1                	li	a7,8
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <link>:
.global link
link:
 li a7, SYS_link
 5d8:	48cd                	li	a7,19
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e0:	48d1                	li	a7,20
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e8:	48a5                	li	a7,9
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f0:	48a9                	li	a7,10
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f8:	48ad                	li	a7,11
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 600:	48b1                	li	a7,12
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 608:	48b5                	li	a7,13
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 610:	48b9                	li	a7,14
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <hello>:
.global hello
hello:
 li a7, SYS_hello
 618:	48d9                	li	a7,22
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
 620:	48dd                	li	a7,23
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <get_arr>:
.global get_arr
get_arr:
 li a7, SYS_get_arr
 628:	48e1                	li	a7,24
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 630:	1101                	addi	sp,sp,-32
 632:	ec06                	sd	ra,24(sp)
 634:	e822                	sd	s0,16(sp)
 636:	1000                	addi	s0,sp,32
 638:	87aa                	mv	a5,a0
 63a:	872e                	mv	a4,a1
 63c:	fef42623          	sw	a5,-20(s0)
 640:	87ba                	mv	a5,a4
 642:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 646:	feb40713          	addi	a4,s0,-21
 64a:	fec42783          	lw	a5,-20(s0)
 64e:	4605                	li	a2,1
 650:	85ba                	mv	a1,a4
 652:	853e                	mv	a0,a5
 654:	00000097          	auipc	ra,0x0
 658:	f44080e7          	jalr	-188(ra) # 598 <write>
}
 65c:	0001                	nop
 65e:	60e2                	ld	ra,24(sp)
 660:	6442                	ld	s0,16(sp)
 662:	6105                	addi	sp,sp,32
 664:	8082                	ret

0000000000000666 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 666:	7139                	addi	sp,sp,-64
 668:	fc06                	sd	ra,56(sp)
 66a:	f822                	sd	s0,48(sp)
 66c:	0080                	addi	s0,sp,64
 66e:	87aa                	mv	a5,a0
 670:	8736                	mv	a4,a3
 672:	fcf42623          	sw	a5,-52(s0)
 676:	87ae                	mv	a5,a1
 678:	fcf42423          	sw	a5,-56(s0)
 67c:	87b2                	mv	a5,a2
 67e:	fcf42223          	sw	a5,-60(s0)
 682:	87ba                	mv	a5,a4
 684:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 688:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 68c:	fc042783          	lw	a5,-64(s0)
 690:	2781                	sext.w	a5,a5
 692:	c38d                	beqz	a5,6b4 <printint+0x4e>
 694:	fc842783          	lw	a5,-56(s0)
 698:	2781                	sext.w	a5,a5
 69a:	0007dd63          	bgez	a5,6b4 <printint+0x4e>
    neg = 1;
 69e:	4785                	li	a5,1
 6a0:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 6a4:	fc842783          	lw	a5,-56(s0)
 6a8:	40f007bb          	negw	a5,a5
 6ac:	2781                	sext.w	a5,a5
 6ae:	fef42223          	sw	a5,-28(s0)
 6b2:	a029                	j	6bc <printint+0x56>
  } else {
    x = xx;
 6b4:	fc842783          	lw	a5,-56(s0)
 6b8:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 6bc:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 6c0:	fc442783          	lw	a5,-60(s0)
 6c4:	fe442703          	lw	a4,-28(s0)
 6c8:	02f777bb          	remuw	a5,a4,a5
 6cc:	0007861b          	sext.w	a2,a5
 6d0:	fec42783          	lw	a5,-20(s0)
 6d4:	0017871b          	addiw	a4,a5,1
 6d8:	fee42623          	sw	a4,-20(s0)
 6dc:	00001697          	auipc	a3,0x1
 6e0:	c9468693          	addi	a3,a3,-876 # 1370 <digits>
 6e4:	02061713          	slli	a4,a2,0x20
 6e8:	9301                	srli	a4,a4,0x20
 6ea:	9736                	add	a4,a4,a3
 6ec:	00074703          	lbu	a4,0(a4)
 6f0:	17c1                	addi	a5,a5,-16
 6f2:	97a2                	add	a5,a5,s0
 6f4:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6f8:	fc442783          	lw	a5,-60(s0)
 6fc:	fe442703          	lw	a4,-28(s0)
 700:	02f757bb          	divuw	a5,a4,a5
 704:	fef42223          	sw	a5,-28(s0)
 708:	fe442783          	lw	a5,-28(s0)
 70c:	2781                	sext.w	a5,a5
 70e:	fbcd                	bnez	a5,6c0 <printint+0x5a>
  if(neg)
 710:	fe842783          	lw	a5,-24(s0)
 714:	2781                	sext.w	a5,a5
 716:	cf85                	beqz	a5,74e <printint+0xe8>
    buf[i++] = '-';
 718:	fec42783          	lw	a5,-20(s0)
 71c:	0017871b          	addiw	a4,a5,1
 720:	fee42623          	sw	a4,-20(s0)
 724:	17c1                	addi	a5,a5,-16
 726:	97a2                	add	a5,a5,s0
 728:	02d00713          	li	a4,45
 72c:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 730:	a839                	j	74e <printint+0xe8>
    putc(fd, buf[i]);
 732:	fec42783          	lw	a5,-20(s0)
 736:	17c1                	addi	a5,a5,-16
 738:	97a2                	add	a5,a5,s0
 73a:	fe07c703          	lbu	a4,-32(a5)
 73e:	fcc42783          	lw	a5,-52(s0)
 742:	85ba                	mv	a1,a4
 744:	853e                	mv	a0,a5
 746:	00000097          	auipc	ra,0x0
 74a:	eea080e7          	jalr	-278(ra) # 630 <putc>
  while(--i >= 0)
 74e:	fec42783          	lw	a5,-20(s0)
 752:	37fd                	addiw	a5,a5,-1
 754:	fef42623          	sw	a5,-20(s0)
 758:	fec42783          	lw	a5,-20(s0)
 75c:	2781                	sext.w	a5,a5
 75e:	fc07dae3          	bgez	a5,732 <printint+0xcc>
}
 762:	0001                	nop
 764:	0001                	nop
 766:	70e2                	ld	ra,56(sp)
 768:	7442                	ld	s0,48(sp)
 76a:	6121                	addi	sp,sp,64
 76c:	8082                	ret

000000000000076e <printptr>:

static void
printptr(int fd, uint64 x) {
 76e:	7179                	addi	sp,sp,-48
 770:	f406                	sd	ra,40(sp)
 772:	f022                	sd	s0,32(sp)
 774:	1800                	addi	s0,sp,48
 776:	87aa                	mv	a5,a0
 778:	fcb43823          	sd	a1,-48(s0)
 77c:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 780:	fdc42783          	lw	a5,-36(s0)
 784:	03000593          	li	a1,48
 788:	853e                	mv	a0,a5
 78a:	00000097          	auipc	ra,0x0
 78e:	ea6080e7          	jalr	-346(ra) # 630 <putc>
  putc(fd, 'x');
 792:	fdc42783          	lw	a5,-36(s0)
 796:	07800593          	li	a1,120
 79a:	853e                	mv	a0,a5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e94080e7          	jalr	-364(ra) # 630 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a4:	fe042623          	sw	zero,-20(s0)
 7a8:	a82d                	j	7e2 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7aa:	fd043783          	ld	a5,-48(s0)
 7ae:	93f1                	srli	a5,a5,0x3c
 7b0:	00001717          	auipc	a4,0x1
 7b4:	bc070713          	addi	a4,a4,-1088 # 1370 <digits>
 7b8:	97ba                	add	a5,a5,a4
 7ba:	0007c703          	lbu	a4,0(a5)
 7be:	fdc42783          	lw	a5,-36(s0)
 7c2:	85ba                	mv	a1,a4
 7c4:	853e                	mv	a0,a5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	e6a080e7          	jalr	-406(ra) # 630 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ce:	fec42783          	lw	a5,-20(s0)
 7d2:	2785                	addiw	a5,a5,1
 7d4:	fef42623          	sw	a5,-20(s0)
 7d8:	fd043783          	ld	a5,-48(s0)
 7dc:	0792                	slli	a5,a5,0x4
 7de:	fcf43823          	sd	a5,-48(s0)
 7e2:	fec42783          	lw	a5,-20(s0)
 7e6:	873e                	mv	a4,a5
 7e8:	47bd                	li	a5,15
 7ea:	fce7f0e3          	bgeu	a5,a4,7aa <printptr+0x3c>
}
 7ee:	0001                	nop
 7f0:	0001                	nop
 7f2:	70a2                	ld	ra,40(sp)
 7f4:	7402                	ld	s0,32(sp)
 7f6:	6145                	addi	sp,sp,48
 7f8:	8082                	ret

00000000000007fa <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7fa:	715d                	addi	sp,sp,-80
 7fc:	e486                	sd	ra,72(sp)
 7fe:	e0a2                	sd	s0,64(sp)
 800:	0880                	addi	s0,sp,80
 802:	87aa                	mv	a5,a0
 804:	fcb43023          	sd	a1,-64(s0)
 808:	fac43c23          	sd	a2,-72(s0)
 80c:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 810:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 814:	fe042223          	sw	zero,-28(s0)
 818:	a42d                	j	a42 <vprintf+0x248>
    c = fmt[i] & 0xff;
 81a:	fe442783          	lw	a5,-28(s0)
 81e:	fc043703          	ld	a4,-64(s0)
 822:	97ba                	add	a5,a5,a4
 824:	0007c783          	lbu	a5,0(a5)
 828:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 82c:	fe042783          	lw	a5,-32(s0)
 830:	2781                	sext.w	a5,a5
 832:	eb9d                	bnez	a5,868 <vprintf+0x6e>
      if(c == '%'){
 834:	fdc42783          	lw	a5,-36(s0)
 838:	0007871b          	sext.w	a4,a5
 83c:	02500793          	li	a5,37
 840:	00f71763          	bne	a4,a5,84e <vprintf+0x54>
        state = '%';
 844:	02500793          	li	a5,37
 848:	fef42023          	sw	a5,-32(s0)
 84c:	a2f5                	j	a38 <vprintf+0x23e>
      } else {
        putc(fd, c);
 84e:	fdc42783          	lw	a5,-36(s0)
 852:	0ff7f713          	zext.b	a4,a5
 856:	fcc42783          	lw	a5,-52(s0)
 85a:	85ba                	mv	a1,a4
 85c:	853e                	mv	a0,a5
 85e:	00000097          	auipc	ra,0x0
 862:	dd2080e7          	jalr	-558(ra) # 630 <putc>
 866:	aac9                	j	a38 <vprintf+0x23e>
      }
    } else if(state == '%'){
 868:	fe042783          	lw	a5,-32(s0)
 86c:	0007871b          	sext.w	a4,a5
 870:	02500793          	li	a5,37
 874:	1cf71263          	bne	a4,a5,a38 <vprintf+0x23e>
      if(c == 'd'){
 878:	fdc42783          	lw	a5,-36(s0)
 87c:	0007871b          	sext.w	a4,a5
 880:	06400793          	li	a5,100
 884:	02f71463          	bne	a4,a5,8ac <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 888:	fb843783          	ld	a5,-72(s0)
 88c:	00878713          	addi	a4,a5,8
 890:	fae43c23          	sd	a4,-72(s0)
 894:	4398                	lw	a4,0(a5)
 896:	fcc42783          	lw	a5,-52(s0)
 89a:	4685                	li	a3,1
 89c:	4629                	li	a2,10
 89e:	85ba                	mv	a1,a4
 8a0:	853e                	mv	a0,a5
 8a2:	00000097          	auipc	ra,0x0
 8a6:	dc4080e7          	jalr	-572(ra) # 666 <printint>
 8aa:	a269                	j	a34 <vprintf+0x23a>
      } else if(c == 'l') {
 8ac:	fdc42783          	lw	a5,-36(s0)
 8b0:	0007871b          	sext.w	a4,a5
 8b4:	06c00793          	li	a5,108
 8b8:	02f71663          	bne	a4,a5,8e4 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8bc:	fb843783          	ld	a5,-72(s0)
 8c0:	00878713          	addi	a4,a5,8
 8c4:	fae43c23          	sd	a4,-72(s0)
 8c8:	639c                	ld	a5,0(a5)
 8ca:	0007871b          	sext.w	a4,a5
 8ce:	fcc42783          	lw	a5,-52(s0)
 8d2:	4681                	li	a3,0
 8d4:	4629                	li	a2,10
 8d6:	85ba                	mv	a1,a4
 8d8:	853e                	mv	a0,a5
 8da:	00000097          	auipc	ra,0x0
 8de:	d8c080e7          	jalr	-628(ra) # 666 <printint>
 8e2:	aa89                	j	a34 <vprintf+0x23a>
      } else if(c == 'x') {
 8e4:	fdc42783          	lw	a5,-36(s0)
 8e8:	0007871b          	sext.w	a4,a5
 8ec:	07800793          	li	a5,120
 8f0:	02f71463          	bne	a4,a5,918 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8f4:	fb843783          	ld	a5,-72(s0)
 8f8:	00878713          	addi	a4,a5,8
 8fc:	fae43c23          	sd	a4,-72(s0)
 900:	4398                	lw	a4,0(a5)
 902:	fcc42783          	lw	a5,-52(s0)
 906:	4681                	li	a3,0
 908:	4641                	li	a2,16
 90a:	85ba                	mv	a1,a4
 90c:	853e                	mv	a0,a5
 90e:	00000097          	auipc	ra,0x0
 912:	d58080e7          	jalr	-680(ra) # 666 <printint>
 916:	aa39                	j	a34 <vprintf+0x23a>
      } else if(c == 'p') {
 918:	fdc42783          	lw	a5,-36(s0)
 91c:	0007871b          	sext.w	a4,a5
 920:	07000793          	li	a5,112
 924:	02f71263          	bne	a4,a5,948 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 928:	fb843783          	ld	a5,-72(s0)
 92c:	00878713          	addi	a4,a5,8
 930:	fae43c23          	sd	a4,-72(s0)
 934:	6398                	ld	a4,0(a5)
 936:	fcc42783          	lw	a5,-52(s0)
 93a:	85ba                	mv	a1,a4
 93c:	853e                	mv	a0,a5
 93e:	00000097          	auipc	ra,0x0
 942:	e30080e7          	jalr	-464(ra) # 76e <printptr>
 946:	a0fd                	j	a34 <vprintf+0x23a>
      } else if(c == 's'){
 948:	fdc42783          	lw	a5,-36(s0)
 94c:	0007871b          	sext.w	a4,a5
 950:	07300793          	li	a5,115
 954:	04f71c63          	bne	a4,a5,9ac <vprintf+0x1b2>
        s = va_arg(ap, char*);
 958:	fb843783          	ld	a5,-72(s0)
 95c:	00878713          	addi	a4,a5,8
 960:	fae43c23          	sd	a4,-72(s0)
 964:	639c                	ld	a5,0(a5)
 966:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 96a:	fe843783          	ld	a5,-24(s0)
 96e:	eb8d                	bnez	a5,9a0 <vprintf+0x1a6>
          s = "(null)";
 970:	00000797          	auipc	a5,0x0
 974:	4a878793          	addi	a5,a5,1192 # e18 <malloc+0x16e>
 978:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 97c:	a015                	j	9a0 <vprintf+0x1a6>
          putc(fd, *s);
 97e:	fe843783          	ld	a5,-24(s0)
 982:	0007c703          	lbu	a4,0(a5)
 986:	fcc42783          	lw	a5,-52(s0)
 98a:	85ba                	mv	a1,a4
 98c:	853e                	mv	a0,a5
 98e:	00000097          	auipc	ra,0x0
 992:	ca2080e7          	jalr	-862(ra) # 630 <putc>
          s++;
 996:	fe843783          	ld	a5,-24(s0)
 99a:	0785                	addi	a5,a5,1
 99c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9a0:	fe843783          	ld	a5,-24(s0)
 9a4:	0007c783          	lbu	a5,0(a5)
 9a8:	fbf9                	bnez	a5,97e <vprintf+0x184>
 9aa:	a069                	j	a34 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 9ac:	fdc42783          	lw	a5,-36(s0)
 9b0:	0007871b          	sext.w	a4,a5
 9b4:	06300793          	li	a5,99
 9b8:	02f71463          	bne	a4,a5,9e0 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 9bc:	fb843783          	ld	a5,-72(s0)
 9c0:	00878713          	addi	a4,a5,8
 9c4:	fae43c23          	sd	a4,-72(s0)
 9c8:	439c                	lw	a5,0(a5)
 9ca:	0ff7f713          	zext.b	a4,a5
 9ce:	fcc42783          	lw	a5,-52(s0)
 9d2:	85ba                	mv	a1,a4
 9d4:	853e                	mv	a0,a5
 9d6:	00000097          	auipc	ra,0x0
 9da:	c5a080e7          	jalr	-934(ra) # 630 <putc>
 9de:	a899                	j	a34 <vprintf+0x23a>
      } else if(c == '%'){
 9e0:	fdc42783          	lw	a5,-36(s0)
 9e4:	0007871b          	sext.w	a4,a5
 9e8:	02500793          	li	a5,37
 9ec:	00f71f63          	bne	a4,a5,a0a <vprintf+0x210>
        putc(fd, c);
 9f0:	fdc42783          	lw	a5,-36(s0)
 9f4:	0ff7f713          	zext.b	a4,a5
 9f8:	fcc42783          	lw	a5,-52(s0)
 9fc:	85ba                	mv	a1,a4
 9fe:	853e                	mv	a0,a5
 a00:	00000097          	auipc	ra,0x0
 a04:	c30080e7          	jalr	-976(ra) # 630 <putc>
 a08:	a035                	j	a34 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a0a:	fcc42783          	lw	a5,-52(s0)
 a0e:	02500593          	li	a1,37
 a12:	853e                	mv	a0,a5
 a14:	00000097          	auipc	ra,0x0
 a18:	c1c080e7          	jalr	-996(ra) # 630 <putc>
        putc(fd, c);
 a1c:	fdc42783          	lw	a5,-36(s0)
 a20:	0ff7f713          	zext.b	a4,a5
 a24:	fcc42783          	lw	a5,-52(s0)
 a28:	85ba                	mv	a1,a4
 a2a:	853e                	mv	a0,a5
 a2c:	00000097          	auipc	ra,0x0
 a30:	c04080e7          	jalr	-1020(ra) # 630 <putc>
      }
      state = 0;
 a34:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a38:	fe442783          	lw	a5,-28(s0)
 a3c:	2785                	addiw	a5,a5,1
 a3e:	fef42223          	sw	a5,-28(s0)
 a42:	fe442783          	lw	a5,-28(s0)
 a46:	fc043703          	ld	a4,-64(s0)
 a4a:	97ba                	add	a5,a5,a4
 a4c:	0007c783          	lbu	a5,0(a5)
 a50:	dc0795e3          	bnez	a5,81a <vprintf+0x20>
    }
  }
}
 a54:	0001                	nop
 a56:	0001                	nop
 a58:	60a6                	ld	ra,72(sp)
 a5a:	6406                	ld	s0,64(sp)
 a5c:	6161                	addi	sp,sp,80
 a5e:	8082                	ret

0000000000000a60 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a60:	7159                	addi	sp,sp,-112
 a62:	fc06                	sd	ra,56(sp)
 a64:	f822                	sd	s0,48(sp)
 a66:	0080                	addi	s0,sp,64
 a68:	fcb43823          	sd	a1,-48(s0)
 a6c:	e010                	sd	a2,0(s0)
 a6e:	e414                	sd	a3,8(s0)
 a70:	e818                	sd	a4,16(s0)
 a72:	ec1c                	sd	a5,24(s0)
 a74:	03043023          	sd	a6,32(s0)
 a78:	03143423          	sd	a7,40(s0)
 a7c:	87aa                	mv	a5,a0
 a7e:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a82:	03040793          	addi	a5,s0,48
 a86:	fcf43423          	sd	a5,-56(s0)
 a8a:	fc843783          	ld	a5,-56(s0)
 a8e:	fd078793          	addi	a5,a5,-48
 a92:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a96:	fe843703          	ld	a4,-24(s0)
 a9a:	fdc42783          	lw	a5,-36(s0)
 a9e:	863a                	mv	a2,a4
 aa0:	fd043583          	ld	a1,-48(s0)
 aa4:	853e                	mv	a0,a5
 aa6:	00000097          	auipc	ra,0x0
 aaa:	d54080e7          	jalr	-684(ra) # 7fa <vprintf>
}
 aae:	0001                	nop
 ab0:	70e2                	ld	ra,56(sp)
 ab2:	7442                	ld	s0,48(sp)
 ab4:	6165                	addi	sp,sp,112
 ab6:	8082                	ret

0000000000000ab8 <printf>:

void
printf(const char *fmt, ...)
{
 ab8:	7159                	addi	sp,sp,-112
 aba:	f406                	sd	ra,40(sp)
 abc:	f022                	sd	s0,32(sp)
 abe:	1800                	addi	s0,sp,48
 ac0:	fca43c23          	sd	a0,-40(s0)
 ac4:	e40c                	sd	a1,8(s0)
 ac6:	e810                	sd	a2,16(s0)
 ac8:	ec14                	sd	a3,24(s0)
 aca:	f018                	sd	a4,32(s0)
 acc:	f41c                	sd	a5,40(s0)
 ace:	03043823          	sd	a6,48(s0)
 ad2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ad6:	04040793          	addi	a5,s0,64
 ada:	fcf43823          	sd	a5,-48(s0)
 ade:	fd043783          	ld	a5,-48(s0)
 ae2:	fc878793          	addi	a5,a5,-56
 ae6:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 aea:	fe843783          	ld	a5,-24(s0)
 aee:	863e                	mv	a2,a5
 af0:	fd843583          	ld	a1,-40(s0)
 af4:	4505                	li	a0,1
 af6:	00000097          	auipc	ra,0x0
 afa:	d04080e7          	jalr	-764(ra) # 7fa <vprintf>
}
 afe:	0001                	nop
 b00:	70a2                	ld	ra,40(sp)
 b02:	7402                	ld	s0,32(sp)
 b04:	6165                	addi	sp,sp,112
 b06:	8082                	ret

0000000000000b08 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b08:	7179                	addi	sp,sp,-48
 b0a:	f422                	sd	s0,40(sp)
 b0c:	1800                	addi	s0,sp,48
 b0e:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b12:	fd843783          	ld	a5,-40(s0)
 b16:	17c1                	addi	a5,a5,-16
 b18:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1c:	00001797          	auipc	a5,0x1
 b20:	88478793          	addi	a5,a5,-1916 # 13a0 <freep>
 b24:	639c                	ld	a5,0(a5)
 b26:	fef43423          	sd	a5,-24(s0)
 b2a:	a815                	j	b5e <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b2c:	fe843783          	ld	a5,-24(s0)
 b30:	639c                	ld	a5,0(a5)
 b32:	fe843703          	ld	a4,-24(s0)
 b36:	00f76f63          	bltu	a4,a5,b54 <free+0x4c>
 b3a:	fe043703          	ld	a4,-32(s0)
 b3e:	fe843783          	ld	a5,-24(s0)
 b42:	02e7eb63          	bltu	a5,a4,b78 <free+0x70>
 b46:	fe843783          	ld	a5,-24(s0)
 b4a:	639c                	ld	a5,0(a5)
 b4c:	fe043703          	ld	a4,-32(s0)
 b50:	02f76463          	bltu	a4,a5,b78 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b54:	fe843783          	ld	a5,-24(s0)
 b58:	639c                	ld	a5,0(a5)
 b5a:	fef43423          	sd	a5,-24(s0)
 b5e:	fe043703          	ld	a4,-32(s0)
 b62:	fe843783          	ld	a5,-24(s0)
 b66:	fce7f3e3          	bgeu	a5,a4,b2c <free+0x24>
 b6a:	fe843783          	ld	a5,-24(s0)
 b6e:	639c                	ld	a5,0(a5)
 b70:	fe043703          	ld	a4,-32(s0)
 b74:	faf77ce3          	bgeu	a4,a5,b2c <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b78:	fe043783          	ld	a5,-32(s0)
 b7c:	479c                	lw	a5,8(a5)
 b7e:	1782                	slli	a5,a5,0x20
 b80:	9381                	srli	a5,a5,0x20
 b82:	0792                	slli	a5,a5,0x4
 b84:	fe043703          	ld	a4,-32(s0)
 b88:	973e                	add	a4,a4,a5
 b8a:	fe843783          	ld	a5,-24(s0)
 b8e:	639c                	ld	a5,0(a5)
 b90:	02f71763          	bne	a4,a5,bbe <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b94:	fe043783          	ld	a5,-32(s0)
 b98:	4798                	lw	a4,8(a5)
 b9a:	fe843783          	ld	a5,-24(s0)
 b9e:	639c                	ld	a5,0(a5)
 ba0:	479c                	lw	a5,8(a5)
 ba2:	9fb9                	addw	a5,a5,a4
 ba4:	0007871b          	sext.w	a4,a5
 ba8:	fe043783          	ld	a5,-32(s0)
 bac:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 bae:	fe843783          	ld	a5,-24(s0)
 bb2:	639c                	ld	a5,0(a5)
 bb4:	6398                	ld	a4,0(a5)
 bb6:	fe043783          	ld	a5,-32(s0)
 bba:	e398                	sd	a4,0(a5)
 bbc:	a039                	j	bca <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 bbe:	fe843783          	ld	a5,-24(s0)
 bc2:	6398                	ld	a4,0(a5)
 bc4:	fe043783          	ld	a5,-32(s0)
 bc8:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 bca:	fe843783          	ld	a5,-24(s0)
 bce:	479c                	lw	a5,8(a5)
 bd0:	1782                	slli	a5,a5,0x20
 bd2:	9381                	srli	a5,a5,0x20
 bd4:	0792                	slli	a5,a5,0x4
 bd6:	fe843703          	ld	a4,-24(s0)
 bda:	97ba                	add	a5,a5,a4
 bdc:	fe043703          	ld	a4,-32(s0)
 be0:	02f71563          	bne	a4,a5,c0a <free+0x102>
    p->s.size += bp->s.size;
 be4:	fe843783          	ld	a5,-24(s0)
 be8:	4798                	lw	a4,8(a5)
 bea:	fe043783          	ld	a5,-32(s0)
 bee:	479c                	lw	a5,8(a5)
 bf0:	9fb9                	addw	a5,a5,a4
 bf2:	0007871b          	sext.w	a4,a5
 bf6:	fe843783          	ld	a5,-24(s0)
 bfa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bfc:	fe043783          	ld	a5,-32(s0)
 c00:	6398                	ld	a4,0(a5)
 c02:	fe843783          	ld	a5,-24(s0)
 c06:	e398                	sd	a4,0(a5)
 c08:	a031                	j	c14 <free+0x10c>
  } else
    p->s.ptr = bp;
 c0a:	fe843783          	ld	a5,-24(s0)
 c0e:	fe043703          	ld	a4,-32(s0)
 c12:	e398                	sd	a4,0(a5)
  freep = p;
 c14:	00000797          	auipc	a5,0x0
 c18:	78c78793          	addi	a5,a5,1932 # 13a0 <freep>
 c1c:	fe843703          	ld	a4,-24(s0)
 c20:	e398                	sd	a4,0(a5)
}
 c22:	0001                	nop
 c24:	7422                	ld	s0,40(sp)
 c26:	6145                	addi	sp,sp,48
 c28:	8082                	ret

0000000000000c2a <morecore>:

static Header*
morecore(uint nu)
{
 c2a:	7179                	addi	sp,sp,-48
 c2c:	f406                	sd	ra,40(sp)
 c2e:	f022                	sd	s0,32(sp)
 c30:	1800                	addi	s0,sp,48
 c32:	87aa                	mv	a5,a0
 c34:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c38:	fdc42783          	lw	a5,-36(s0)
 c3c:	0007871b          	sext.w	a4,a5
 c40:	6785                	lui	a5,0x1
 c42:	00f77563          	bgeu	a4,a5,c4c <morecore+0x22>
    nu = 4096;
 c46:	6785                	lui	a5,0x1
 c48:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c4c:	fdc42783          	lw	a5,-36(s0)
 c50:	0047979b          	slliw	a5,a5,0x4
 c54:	2781                	sext.w	a5,a5
 c56:	2781                	sext.w	a5,a5
 c58:	853e                	mv	a0,a5
 c5a:	00000097          	auipc	ra,0x0
 c5e:	9a6080e7          	jalr	-1626(ra) # 600 <sbrk>
 c62:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c66:	fe843703          	ld	a4,-24(s0)
 c6a:	57fd                	li	a5,-1
 c6c:	00f71463          	bne	a4,a5,c74 <morecore+0x4a>
    return 0;
 c70:	4781                	li	a5,0
 c72:	a03d                	j	ca0 <morecore+0x76>
  hp = (Header*)p;
 c74:	fe843783          	ld	a5,-24(s0)
 c78:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c7c:	fe043783          	ld	a5,-32(s0)
 c80:	fdc42703          	lw	a4,-36(s0)
 c84:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c86:	fe043783          	ld	a5,-32(s0)
 c8a:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x366>
 c8c:	853e                	mv	a0,a5
 c8e:	00000097          	auipc	ra,0x0
 c92:	e7a080e7          	jalr	-390(ra) # b08 <free>
  return freep;
 c96:	00000797          	auipc	a5,0x0
 c9a:	70a78793          	addi	a5,a5,1802 # 13a0 <freep>
 c9e:	639c                	ld	a5,0(a5)
}
 ca0:	853e                	mv	a0,a5
 ca2:	70a2                	ld	ra,40(sp)
 ca4:	7402                	ld	s0,32(sp)
 ca6:	6145                	addi	sp,sp,48
 ca8:	8082                	ret

0000000000000caa <malloc>:

void*
malloc(uint nbytes)
{
 caa:	7139                	addi	sp,sp,-64
 cac:	fc06                	sd	ra,56(sp)
 cae:	f822                	sd	s0,48(sp)
 cb0:	0080                	addi	s0,sp,64
 cb2:	87aa                	mv	a5,a0
 cb4:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cb8:	fcc46783          	lwu	a5,-52(s0)
 cbc:	07bd                	addi	a5,a5,15
 cbe:	8391                	srli	a5,a5,0x4
 cc0:	2781                	sext.w	a5,a5
 cc2:	2785                	addiw	a5,a5,1
 cc4:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 cc8:	00000797          	auipc	a5,0x0
 ccc:	6d878793          	addi	a5,a5,1752 # 13a0 <freep>
 cd0:	639c                	ld	a5,0(a5)
 cd2:	fef43023          	sd	a5,-32(s0)
 cd6:	fe043783          	ld	a5,-32(s0)
 cda:	ef95                	bnez	a5,d16 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cdc:	00000797          	auipc	a5,0x0
 ce0:	6b478793          	addi	a5,a5,1716 # 1390 <base>
 ce4:	fef43023          	sd	a5,-32(s0)
 ce8:	00000797          	auipc	a5,0x0
 cec:	6b878793          	addi	a5,a5,1720 # 13a0 <freep>
 cf0:	fe043703          	ld	a4,-32(s0)
 cf4:	e398                	sd	a4,0(a5)
 cf6:	00000797          	auipc	a5,0x0
 cfa:	6aa78793          	addi	a5,a5,1706 # 13a0 <freep>
 cfe:	6398                	ld	a4,0(a5)
 d00:	00000797          	auipc	a5,0x0
 d04:	69078793          	addi	a5,a5,1680 # 1390 <base>
 d08:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 d0a:	00000797          	auipc	a5,0x0
 d0e:	68678793          	addi	a5,a5,1670 # 1390 <base>
 d12:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d16:	fe043783          	ld	a5,-32(s0)
 d1a:	639c                	ld	a5,0(a5)
 d1c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d20:	fe843783          	ld	a5,-24(s0)
 d24:	4798                	lw	a4,8(a5)
 d26:	fdc42783          	lw	a5,-36(s0)
 d2a:	2781                	sext.w	a5,a5
 d2c:	06f76763          	bltu	a4,a5,d9a <malloc+0xf0>
      if(p->s.size == nunits)
 d30:	fe843783          	ld	a5,-24(s0)
 d34:	4798                	lw	a4,8(a5)
 d36:	fdc42783          	lw	a5,-36(s0)
 d3a:	2781                	sext.w	a5,a5
 d3c:	00e79963          	bne	a5,a4,d4e <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d40:	fe843783          	ld	a5,-24(s0)
 d44:	6398                	ld	a4,0(a5)
 d46:	fe043783          	ld	a5,-32(s0)
 d4a:	e398                	sd	a4,0(a5)
 d4c:	a825                	j	d84 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d4e:	fe843783          	ld	a5,-24(s0)
 d52:	479c                	lw	a5,8(a5)
 d54:	fdc42703          	lw	a4,-36(s0)
 d58:	9f99                	subw	a5,a5,a4
 d5a:	0007871b          	sext.w	a4,a5
 d5e:	fe843783          	ld	a5,-24(s0)
 d62:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d64:	fe843783          	ld	a5,-24(s0)
 d68:	479c                	lw	a5,8(a5)
 d6a:	1782                	slli	a5,a5,0x20
 d6c:	9381                	srli	a5,a5,0x20
 d6e:	0792                	slli	a5,a5,0x4
 d70:	fe843703          	ld	a4,-24(s0)
 d74:	97ba                	add	a5,a5,a4
 d76:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d7a:	fe843783          	ld	a5,-24(s0)
 d7e:	fdc42703          	lw	a4,-36(s0)
 d82:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d84:	00000797          	auipc	a5,0x0
 d88:	61c78793          	addi	a5,a5,1564 # 13a0 <freep>
 d8c:	fe043703          	ld	a4,-32(s0)
 d90:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d92:	fe843783          	ld	a5,-24(s0)
 d96:	07c1                	addi	a5,a5,16
 d98:	a091                	j	ddc <malloc+0x132>
    }
    if(p == freep)
 d9a:	00000797          	auipc	a5,0x0
 d9e:	60678793          	addi	a5,a5,1542 # 13a0 <freep>
 da2:	639c                	ld	a5,0(a5)
 da4:	fe843703          	ld	a4,-24(s0)
 da8:	02f71063          	bne	a4,a5,dc8 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 dac:	fdc42783          	lw	a5,-36(s0)
 db0:	853e                	mv	a0,a5
 db2:	00000097          	auipc	ra,0x0
 db6:	e78080e7          	jalr	-392(ra) # c2a <morecore>
 dba:	fea43423          	sd	a0,-24(s0)
 dbe:	fe843783          	ld	a5,-24(s0)
 dc2:	e399                	bnez	a5,dc8 <malloc+0x11e>
        return 0;
 dc4:	4781                	li	a5,0
 dc6:	a819                	j	ddc <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dc8:	fe843783          	ld	a5,-24(s0)
 dcc:	fef43023          	sd	a5,-32(s0)
 dd0:	fe843783          	ld	a5,-24(s0)
 dd4:	639c                	ld	a5,0(a5)
 dd6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dda:	b799                	j	d20 <malloc+0x76>
  }
}
 ddc:	853e                	mv	a0,a5
 dde:	70e2                	ld	ra,56(sp)
 de0:	7442                	ld	s0,48(sp)
 de2:	6121                	addi	sp,sp,64
 de4:	8082                	ret
