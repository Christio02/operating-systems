
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	0080                	addi	s0,sp,64
       8:	fca43423          	sd	a0,-56(s0)
       c:	87ae                	mv	a5,a1
       e:	fcf42223          	sw	a5,-60(s0)
  int n, m;
  char *p, *q;

  m = 0;
      12:	fe042623          	sw	zero,-20(s0)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
      16:	a0c5                	j	f6 <grep+0xf6>
    m += n;
      18:	fec42783          	lw	a5,-20(s0)
      1c:	873e                	mv	a4,a5
      1e:	fdc42783          	lw	a5,-36(s0)
      22:	9fb9                	addw	a5,a5,a4
      24:	fef42623          	sw	a5,-20(s0)
    buf[m] = '\0';
      28:	00002717          	auipc	a4,0x2
      2c:	40870713          	addi	a4,a4,1032 # 2430 <buf>
      30:	fec42783          	lw	a5,-20(s0)
      34:	97ba                	add	a5,a5,a4
      36:	00078023          	sb	zero,0(a5)
    p = buf;
      3a:	00002797          	auipc	a5,0x2
      3e:	3f678793          	addi	a5,a5,1014 # 2430 <buf>
      42:	fef43023          	sd	a5,-32(s0)
    while((q = strchr(p, '\n')) != 0){
      46:	a891                	j	9a <grep+0x9a>
      *q = 0;
      48:	fd043783          	ld	a5,-48(s0)
      4c:	00078023          	sb	zero,0(a5)
      if(match(pattern, p)){
      50:	fe043583          	ld	a1,-32(s0)
      54:	fc843503          	ld	a0,-56(s0)
      58:	00000097          	auipc	ra,0x0
      5c:	1fc080e7          	jalr	508(ra) # 254 <match>
      60:	87aa                	mv	a5,a0
      62:	c79d                	beqz	a5,90 <grep+0x90>
        *q = '\n';
      64:	fd043783          	ld	a5,-48(s0)
      68:	4729                	li	a4,10
      6a:	00e78023          	sb	a4,0(a5)
        write(1, p, q+1 - p);
      6e:	fd043783          	ld	a5,-48(s0)
      72:	00178713          	addi	a4,a5,1
      76:	fe043783          	ld	a5,-32(s0)
      7a:	40f707b3          	sub	a5,a4,a5
      7e:	2781                	sext.w	a5,a5
      80:	863e                	mv	a2,a5
      82:	fe043583          	ld	a1,-32(s0)
      86:	4505                	li	a0,1
      88:	00001097          	auipc	ra,0x1
      8c:	860080e7          	jalr	-1952(ra) # 8e8 <write>
      }
      p = q+1;
      90:	fd043783          	ld	a5,-48(s0)
      94:	0785                	addi	a5,a5,1
      96:	fef43023          	sd	a5,-32(s0)
    while((q = strchr(p, '\n')) != 0){
      9a:	45a9                	li	a1,10
      9c:	fe043503          	ld	a0,-32(s0)
      a0:	00000097          	auipc	ra,0x0
      a4:	4dc080e7          	jalr	1244(ra) # 57c <strchr>
      a8:	fca43823          	sd	a0,-48(s0)
      ac:	fd043783          	ld	a5,-48(s0)
      b0:	ffc1                	bnez	a5,48 <grep+0x48>
    }
    if(m > 0){
      b2:	fec42783          	lw	a5,-20(s0)
      b6:	2781                	sext.w	a5,a5
      b8:	02f05f63          	blez	a5,f6 <grep+0xf6>
      m -= p - buf;
      bc:	fec42703          	lw	a4,-20(s0)
      c0:	fe043683          	ld	a3,-32(s0)
      c4:	00002797          	auipc	a5,0x2
      c8:	36c78793          	addi	a5,a5,876 # 2430 <buf>
      cc:	40f687b3          	sub	a5,a3,a5
      d0:	2781                	sext.w	a5,a5
      d2:	40f707bb          	subw	a5,a4,a5
      d6:	2781                	sext.w	a5,a5
      d8:	fef42623          	sw	a5,-20(s0)
      memmove(buf, p, m);
      dc:	fec42783          	lw	a5,-20(s0)
      e0:	863e                	mv	a2,a5
      e2:	fe043583          	ld	a1,-32(s0)
      e6:	00002517          	auipc	a0,0x2
      ea:	34a50513          	addi	a0,a0,842 # 2430 <buf>
      ee:	00000097          	auipc	ra,0x0
      f2:	654080e7          	jalr	1620(ra) # 742 <memmove>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
      f6:	fec42703          	lw	a4,-20(s0)
      fa:	00002797          	auipc	a5,0x2
      fe:	33678793          	addi	a5,a5,822 # 2430 <buf>
     102:	00f706b3          	add	a3,a4,a5
     106:	fec42783          	lw	a5,-20(s0)
     10a:	3ff00713          	li	a4,1023
     10e:	40f707bb          	subw	a5,a4,a5
     112:	2781                	sext.w	a5,a5
     114:	0007871b          	sext.w	a4,a5
     118:	fc442783          	lw	a5,-60(s0)
     11c:	863a                	mv	a2,a4
     11e:	85b6                	mv	a1,a3
     120:	853e                	mv	a0,a5
     122:	00000097          	auipc	ra,0x0
     126:	7be080e7          	jalr	1982(ra) # 8e0 <read>
     12a:	87aa                	mv	a5,a0
     12c:	fcf42e23          	sw	a5,-36(s0)
     130:	fdc42783          	lw	a5,-36(s0)
     134:	2781                	sext.w	a5,a5
     136:	eef041e3          	bgtz	a5,18 <grep+0x18>
    }
  }
}
     13a:	0001                	nop
     13c:	0001                	nop
     13e:	70e2                	ld	ra,56(sp)
     140:	7442                	ld	s0,48(sp)
     142:	6121                	addi	sp,sp,64
     144:	8082                	ret

0000000000000146 <main>:

int
main(int argc, char *argv[])
{
     146:	7139                	addi	sp,sp,-64
     148:	fc06                	sd	ra,56(sp)
     14a:	f822                	sd	s0,48(sp)
     14c:	0080                	addi	s0,sp,64
     14e:	87aa                	mv	a5,a0
     150:	fcb43023          	sd	a1,-64(s0)
     154:	fcf42623          	sw	a5,-52(s0)
  int fd, i;
  char *pattern;

  if(argc <= 1){
     158:	fcc42783          	lw	a5,-52(s0)
     15c:	0007871b          	sext.w	a4,a5
     160:	4785                	li	a5,1
     162:	02e7c063          	blt	a5,a4,182 <main+0x3c>
    fprintf(2, "usage: grep pattern [file ...]\n");
     166:	00001597          	auipc	a1,0x1
     16a:	fca58593          	addi	a1,a1,-54 # 1130 <malloc+0x13e>
     16e:	4509                	li	a0,2
     170:	00001097          	auipc	ra,0x1
     174:	c38080e7          	jalr	-968(ra) # da8 <fprintf>
    exit(1);
     178:	4505                	li	a0,1
     17a:	00000097          	auipc	ra,0x0
     17e:	74e080e7          	jalr	1870(ra) # 8c8 <exit>
  }
  pattern = argv[1];
     182:	fc043783          	ld	a5,-64(s0)
     186:	679c                	ld	a5,8(a5)
     188:	fef43023          	sd	a5,-32(s0)

  if(argc <= 2){
     18c:	fcc42783          	lw	a5,-52(s0)
     190:	0007871b          	sext.w	a4,a5
     194:	4789                	li	a5,2
     196:	00e7ce63          	blt	a5,a4,1b2 <main+0x6c>
    grep(pattern, 0);
     19a:	4581                	li	a1,0
     19c:	fe043503          	ld	a0,-32(s0)
     1a0:	00000097          	auipc	ra,0x0
     1a4:	e60080e7          	jalr	-416(ra) # 0 <grep>
    exit(0);
     1a8:	4501                	li	a0,0
     1aa:	00000097          	auipc	ra,0x0
     1ae:	71e080e7          	jalr	1822(ra) # 8c8 <exit>
  }

  for(i = 2; i < argc; i++){
     1b2:	4789                	li	a5,2
     1b4:	fef42623          	sw	a5,-20(s0)
     1b8:	a041                	j	238 <main+0xf2>
    if((fd = open(argv[i], 0)) < 0){
     1ba:	fec42783          	lw	a5,-20(s0)
     1be:	078e                	slli	a5,a5,0x3
     1c0:	fc043703          	ld	a4,-64(s0)
     1c4:	97ba                	add	a5,a5,a4
     1c6:	639c                	ld	a5,0(a5)
     1c8:	4581                	li	a1,0
     1ca:	853e                	mv	a0,a5
     1cc:	00000097          	auipc	ra,0x0
     1d0:	73c080e7          	jalr	1852(ra) # 908 <open>
     1d4:	87aa                	mv	a5,a0
     1d6:	fcf42e23          	sw	a5,-36(s0)
     1da:	fdc42783          	lw	a5,-36(s0)
     1de:	2781                	sext.w	a5,a5
     1e0:	0207d763          	bgez	a5,20e <main+0xc8>
      printf("grep: cannot open %s\n", argv[i]);
     1e4:	fec42783          	lw	a5,-20(s0)
     1e8:	078e                	slli	a5,a5,0x3
     1ea:	fc043703          	ld	a4,-64(s0)
     1ee:	97ba                	add	a5,a5,a4
     1f0:	639c                	ld	a5,0(a5)
     1f2:	85be                	mv	a1,a5
     1f4:	00001517          	auipc	a0,0x1
     1f8:	f5c50513          	addi	a0,a0,-164 # 1150 <malloc+0x15e>
     1fc:	00001097          	auipc	ra,0x1
     200:	c04080e7          	jalr	-1020(ra) # e00 <printf>
      exit(1);
     204:	4505                	li	a0,1
     206:	00000097          	auipc	ra,0x0
     20a:	6c2080e7          	jalr	1730(ra) # 8c8 <exit>
    }
    grep(pattern, fd);
     20e:	fdc42783          	lw	a5,-36(s0)
     212:	85be                	mv	a1,a5
     214:	fe043503          	ld	a0,-32(s0)
     218:	00000097          	auipc	ra,0x0
     21c:	de8080e7          	jalr	-536(ra) # 0 <grep>
    close(fd);
     220:	fdc42783          	lw	a5,-36(s0)
     224:	853e                	mv	a0,a5
     226:	00000097          	auipc	ra,0x0
     22a:	6ca080e7          	jalr	1738(ra) # 8f0 <close>
  for(i = 2; i < argc; i++){
     22e:	fec42783          	lw	a5,-20(s0)
     232:	2785                	addiw	a5,a5,1
     234:	fef42623          	sw	a5,-20(s0)
     238:	fec42783          	lw	a5,-20(s0)
     23c:	873e                	mv	a4,a5
     23e:	fcc42783          	lw	a5,-52(s0)
     242:	2701                	sext.w	a4,a4
     244:	2781                	sext.w	a5,a5
     246:	f6f74ae3          	blt	a4,a5,1ba <main+0x74>
  }
  exit(0);
     24a:	4501                	li	a0,0
     24c:	00000097          	auipc	ra,0x0
     250:	67c080e7          	jalr	1660(ra) # 8c8 <exit>

0000000000000254 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
     254:	1101                	addi	sp,sp,-32
     256:	ec06                	sd	ra,24(sp)
     258:	e822                	sd	s0,16(sp)
     25a:	1000                	addi	s0,sp,32
     25c:	fea43423          	sd	a0,-24(s0)
     260:	feb43023          	sd	a1,-32(s0)
  if(re[0] == '^')
     264:	fe843783          	ld	a5,-24(s0)
     268:	0007c783          	lbu	a5,0(a5)
     26c:	873e                	mv	a4,a5
     26e:	05e00793          	li	a5,94
     272:	00f71e63          	bne	a4,a5,28e <match+0x3a>
    return matchhere(re+1, text);
     276:	fe843783          	ld	a5,-24(s0)
     27a:	0785                	addi	a5,a5,1
     27c:	fe043583          	ld	a1,-32(s0)
     280:	853e                	mv	a0,a5
     282:	00000097          	auipc	ra,0x0
     286:	042080e7          	jalr	66(ra) # 2c4 <matchhere>
     28a:	87aa                	mv	a5,a0
     28c:	a03d                	j	2ba <match+0x66>
  do{  // must look at empty string
    if(matchhere(re, text))
     28e:	fe043583          	ld	a1,-32(s0)
     292:	fe843503          	ld	a0,-24(s0)
     296:	00000097          	auipc	ra,0x0
     29a:	02e080e7          	jalr	46(ra) # 2c4 <matchhere>
     29e:	87aa                	mv	a5,a0
     2a0:	c399                	beqz	a5,2a6 <match+0x52>
      return 1;
     2a2:	4785                	li	a5,1
     2a4:	a819                	j	2ba <match+0x66>
  }while(*text++ != '\0');
     2a6:	fe043783          	ld	a5,-32(s0)
     2aa:	00178713          	addi	a4,a5,1
     2ae:	fee43023          	sd	a4,-32(s0)
     2b2:	0007c783          	lbu	a5,0(a5)
     2b6:	ffe1                	bnez	a5,28e <match+0x3a>
  return 0;
     2b8:	4781                	li	a5,0
}
     2ba:	853e                	mv	a0,a5
     2bc:	60e2                	ld	ra,24(sp)
     2be:	6442                	ld	s0,16(sp)
     2c0:	6105                	addi	sp,sp,32
     2c2:	8082                	ret

00000000000002c4 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
     2c4:	1101                	addi	sp,sp,-32
     2c6:	ec06                	sd	ra,24(sp)
     2c8:	e822                	sd	s0,16(sp)
     2ca:	1000                	addi	s0,sp,32
     2cc:	fea43423          	sd	a0,-24(s0)
     2d0:	feb43023          	sd	a1,-32(s0)
  if(re[0] == '\0')
     2d4:	fe843783          	ld	a5,-24(s0)
     2d8:	0007c783          	lbu	a5,0(a5)
     2dc:	e399                	bnez	a5,2e2 <matchhere+0x1e>
    return 1;
     2de:	4785                	li	a5,1
     2e0:	a0c1                	j	3a0 <matchhere+0xdc>
  if(re[1] == '*')
     2e2:	fe843783          	ld	a5,-24(s0)
     2e6:	0785                	addi	a5,a5,1
     2e8:	0007c783          	lbu	a5,0(a5)
     2ec:	873e                	mv	a4,a5
     2ee:	02a00793          	li	a5,42
     2f2:	02f71563          	bne	a4,a5,31c <matchhere+0x58>
    return matchstar(re[0], re+2, text);
     2f6:	fe843783          	ld	a5,-24(s0)
     2fa:	0007c783          	lbu	a5,0(a5)
     2fe:	0007871b          	sext.w	a4,a5
     302:	fe843783          	ld	a5,-24(s0)
     306:	0789                	addi	a5,a5,2
     308:	fe043603          	ld	a2,-32(s0)
     30c:	85be                	mv	a1,a5
     30e:	853a                	mv	a0,a4
     310:	00000097          	auipc	ra,0x0
     314:	09a080e7          	jalr	154(ra) # 3aa <matchstar>
     318:	87aa                	mv	a5,a0
     31a:	a059                	j	3a0 <matchhere+0xdc>
  if(re[0] == '$' && re[1] == '\0')
     31c:	fe843783          	ld	a5,-24(s0)
     320:	0007c783          	lbu	a5,0(a5)
     324:	873e                	mv	a4,a5
     326:	02400793          	li	a5,36
     32a:	02f71363          	bne	a4,a5,350 <matchhere+0x8c>
     32e:	fe843783          	ld	a5,-24(s0)
     332:	0785                	addi	a5,a5,1
     334:	0007c783          	lbu	a5,0(a5)
     338:	ef81                	bnez	a5,350 <matchhere+0x8c>
    return *text == '\0';
     33a:	fe043783          	ld	a5,-32(s0)
     33e:	0007c783          	lbu	a5,0(a5)
     342:	2781                	sext.w	a5,a5
     344:	0017b793          	seqz	a5,a5
     348:	0ff7f793          	zext.b	a5,a5
     34c:	2781                	sext.w	a5,a5
     34e:	a889                	j	3a0 <matchhere+0xdc>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
     350:	fe043783          	ld	a5,-32(s0)
     354:	0007c783          	lbu	a5,0(a5)
     358:	c3b9                	beqz	a5,39e <matchhere+0xda>
     35a:	fe843783          	ld	a5,-24(s0)
     35e:	0007c783          	lbu	a5,0(a5)
     362:	873e                	mv	a4,a5
     364:	02e00793          	li	a5,46
     368:	00f70c63          	beq	a4,a5,380 <matchhere+0xbc>
     36c:	fe843783          	ld	a5,-24(s0)
     370:	0007c703          	lbu	a4,0(a5)
     374:	fe043783          	ld	a5,-32(s0)
     378:	0007c783          	lbu	a5,0(a5)
     37c:	02f71163          	bne	a4,a5,39e <matchhere+0xda>
    return matchhere(re+1, text+1);
     380:	fe843783          	ld	a5,-24(s0)
     384:	00178713          	addi	a4,a5,1
     388:	fe043783          	ld	a5,-32(s0)
     38c:	0785                	addi	a5,a5,1
     38e:	85be                	mv	a1,a5
     390:	853a                	mv	a0,a4
     392:	00000097          	auipc	ra,0x0
     396:	f32080e7          	jalr	-206(ra) # 2c4 <matchhere>
     39a:	87aa                	mv	a5,a0
     39c:	a011                	j	3a0 <matchhere+0xdc>
  return 0;
     39e:	4781                	li	a5,0
}
     3a0:	853e                	mv	a0,a5
     3a2:	60e2                	ld	ra,24(sp)
     3a4:	6442                	ld	s0,16(sp)
     3a6:	6105                	addi	sp,sp,32
     3a8:	8082                	ret

00000000000003aa <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
     3aa:	7179                	addi	sp,sp,-48
     3ac:	f406                	sd	ra,40(sp)
     3ae:	f022                	sd	s0,32(sp)
     3b0:	1800                	addi	s0,sp,48
     3b2:	87aa                	mv	a5,a0
     3b4:	feb43023          	sd	a1,-32(s0)
     3b8:	fcc43c23          	sd	a2,-40(s0)
     3bc:	fef42623          	sw	a5,-20(s0)
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
     3c0:	fd843583          	ld	a1,-40(s0)
     3c4:	fe043503          	ld	a0,-32(s0)
     3c8:	00000097          	auipc	ra,0x0
     3cc:	efc080e7          	jalr	-260(ra) # 2c4 <matchhere>
     3d0:	87aa                	mv	a5,a0
     3d2:	c399                	beqz	a5,3d8 <matchstar+0x2e>
      return 1;
     3d4:	4785                	li	a5,1
     3d6:	a835                	j	412 <matchstar+0x68>
  }while(*text!='\0' && (*text++==c || c=='.'));
     3d8:	fd843783          	ld	a5,-40(s0)
     3dc:	0007c783          	lbu	a5,0(a5)
     3e0:	cb85                	beqz	a5,410 <matchstar+0x66>
     3e2:	fd843783          	ld	a5,-40(s0)
     3e6:	00178713          	addi	a4,a5,1
     3ea:	fce43c23          	sd	a4,-40(s0)
     3ee:	0007c783          	lbu	a5,0(a5)
     3f2:	0007871b          	sext.w	a4,a5
     3f6:	fec42783          	lw	a5,-20(s0)
     3fa:	2781                	sext.w	a5,a5
     3fc:	fce782e3          	beq	a5,a4,3c0 <matchstar+0x16>
     400:	fec42783          	lw	a5,-20(s0)
     404:	0007871b          	sext.w	a4,a5
     408:	02e00793          	li	a5,46
     40c:	faf70ae3          	beq	a4,a5,3c0 <matchstar+0x16>
  return 0;
     410:	4781                	li	a5,0
}
     412:	853e                	mv	a0,a5
     414:	70a2                	ld	ra,40(sp)
     416:	7402                	ld	s0,32(sp)
     418:	6145                	addi	sp,sp,48
     41a:	8082                	ret

000000000000041c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     41c:	1141                	addi	sp,sp,-16
     41e:	e406                	sd	ra,8(sp)
     420:	e022                	sd	s0,0(sp)
     422:	0800                	addi	s0,sp,16
  extern int main();
  main();
     424:	00000097          	auipc	ra,0x0
     428:	d22080e7          	jalr	-734(ra) # 146 <main>
  exit(0);
     42c:	4501                	li	a0,0
     42e:	00000097          	auipc	ra,0x0
     432:	49a080e7          	jalr	1178(ra) # 8c8 <exit>

0000000000000436 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     436:	7179                	addi	sp,sp,-48
     438:	f422                	sd	s0,40(sp)
     43a:	1800                	addi	s0,sp,48
     43c:	fca43c23          	sd	a0,-40(s0)
     440:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     444:	fd843783          	ld	a5,-40(s0)
     448:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     44c:	0001                	nop
     44e:	fd043703          	ld	a4,-48(s0)
     452:	00170793          	addi	a5,a4,1
     456:	fcf43823          	sd	a5,-48(s0)
     45a:	fd843783          	ld	a5,-40(s0)
     45e:	00178693          	addi	a3,a5,1
     462:	fcd43c23          	sd	a3,-40(s0)
     466:	00074703          	lbu	a4,0(a4)
     46a:	00e78023          	sb	a4,0(a5)
     46e:	0007c783          	lbu	a5,0(a5)
     472:	fff1                	bnez	a5,44e <strcpy+0x18>
    ;
  return os;
     474:	fe843783          	ld	a5,-24(s0)
}
     478:	853e                	mv	a0,a5
     47a:	7422                	ld	s0,40(sp)
     47c:	6145                	addi	sp,sp,48
     47e:	8082                	ret

0000000000000480 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     480:	1101                	addi	sp,sp,-32
     482:	ec22                	sd	s0,24(sp)
     484:	1000                	addi	s0,sp,32
     486:	fea43423          	sd	a0,-24(s0)
     48a:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     48e:	a819                	j	4a4 <strcmp+0x24>
    p++, q++;
     490:	fe843783          	ld	a5,-24(s0)
     494:	0785                	addi	a5,a5,1
     496:	fef43423          	sd	a5,-24(s0)
     49a:	fe043783          	ld	a5,-32(s0)
     49e:	0785                	addi	a5,a5,1
     4a0:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
     4a4:	fe843783          	ld	a5,-24(s0)
     4a8:	0007c783          	lbu	a5,0(a5)
     4ac:	cb99                	beqz	a5,4c2 <strcmp+0x42>
     4ae:	fe843783          	ld	a5,-24(s0)
     4b2:	0007c703          	lbu	a4,0(a5)
     4b6:	fe043783          	ld	a5,-32(s0)
     4ba:	0007c783          	lbu	a5,0(a5)
     4be:	fcf709e3          	beq	a4,a5,490 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
     4c2:	fe843783          	ld	a5,-24(s0)
     4c6:	0007c783          	lbu	a5,0(a5)
     4ca:	0007871b          	sext.w	a4,a5
     4ce:	fe043783          	ld	a5,-32(s0)
     4d2:	0007c783          	lbu	a5,0(a5)
     4d6:	2781                	sext.w	a5,a5
     4d8:	40f707bb          	subw	a5,a4,a5
     4dc:	2781                	sext.w	a5,a5
}
     4de:	853e                	mv	a0,a5
     4e0:	6462                	ld	s0,24(sp)
     4e2:	6105                	addi	sp,sp,32
     4e4:	8082                	ret

00000000000004e6 <strlen>:

uint
strlen(const char *s)
{
     4e6:	7179                	addi	sp,sp,-48
     4e8:	f422                	sd	s0,40(sp)
     4ea:	1800                	addi	s0,sp,48
     4ec:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
     4f0:	fe042623          	sw	zero,-20(s0)
     4f4:	a031                	j	500 <strlen+0x1a>
     4f6:	fec42783          	lw	a5,-20(s0)
     4fa:	2785                	addiw	a5,a5,1
     4fc:	fef42623          	sw	a5,-20(s0)
     500:	fec42783          	lw	a5,-20(s0)
     504:	fd843703          	ld	a4,-40(s0)
     508:	97ba                	add	a5,a5,a4
     50a:	0007c783          	lbu	a5,0(a5)
     50e:	f7e5                	bnez	a5,4f6 <strlen+0x10>
    ;
  return n;
     510:	fec42783          	lw	a5,-20(s0)
}
     514:	853e                	mv	a0,a5
     516:	7422                	ld	s0,40(sp)
     518:	6145                	addi	sp,sp,48
     51a:	8082                	ret

000000000000051c <memset>:

void*
memset(void *dst, int c, uint n)
{
     51c:	7179                	addi	sp,sp,-48
     51e:	f422                	sd	s0,40(sp)
     520:	1800                	addi	s0,sp,48
     522:	fca43c23          	sd	a0,-40(s0)
     526:	87ae                	mv	a5,a1
     528:	8732                	mv	a4,a2
     52a:	fcf42a23          	sw	a5,-44(s0)
     52e:	87ba                	mv	a5,a4
     530:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
     534:	fd843783          	ld	a5,-40(s0)
     538:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
     53c:	fe042623          	sw	zero,-20(s0)
     540:	a00d                	j	562 <memset+0x46>
    cdst[i] = c;
     542:	fec42783          	lw	a5,-20(s0)
     546:	fe043703          	ld	a4,-32(s0)
     54a:	97ba                	add	a5,a5,a4
     54c:	fd442703          	lw	a4,-44(s0)
     550:	0ff77713          	zext.b	a4,a4
     554:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
     558:	fec42783          	lw	a5,-20(s0)
     55c:	2785                	addiw	a5,a5,1
     55e:	fef42623          	sw	a5,-20(s0)
     562:	fec42703          	lw	a4,-20(s0)
     566:	fd042783          	lw	a5,-48(s0)
     56a:	2781                	sext.w	a5,a5
     56c:	fcf76be3          	bltu	a4,a5,542 <memset+0x26>
  }
  return dst;
     570:	fd843783          	ld	a5,-40(s0)
}
     574:	853e                	mv	a0,a5
     576:	7422                	ld	s0,40(sp)
     578:	6145                	addi	sp,sp,48
     57a:	8082                	ret

000000000000057c <strchr>:

char*
strchr(const char *s, char c)
{
     57c:	1101                	addi	sp,sp,-32
     57e:	ec22                	sd	s0,24(sp)
     580:	1000                	addi	s0,sp,32
     582:	fea43423          	sd	a0,-24(s0)
     586:	87ae                	mv	a5,a1
     588:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
     58c:	a01d                	j	5b2 <strchr+0x36>
    if(*s == c)
     58e:	fe843783          	ld	a5,-24(s0)
     592:	0007c703          	lbu	a4,0(a5)
     596:	fe744783          	lbu	a5,-25(s0)
     59a:	0ff7f793          	zext.b	a5,a5
     59e:	00e79563          	bne	a5,a4,5a8 <strchr+0x2c>
      return (char*)s;
     5a2:	fe843783          	ld	a5,-24(s0)
     5a6:	a821                	j	5be <strchr+0x42>
  for(; *s; s++)
     5a8:	fe843783          	ld	a5,-24(s0)
     5ac:	0785                	addi	a5,a5,1
     5ae:	fef43423          	sd	a5,-24(s0)
     5b2:	fe843783          	ld	a5,-24(s0)
     5b6:	0007c783          	lbu	a5,0(a5)
     5ba:	fbf1                	bnez	a5,58e <strchr+0x12>
  return 0;
     5bc:	4781                	li	a5,0
}
     5be:	853e                	mv	a0,a5
     5c0:	6462                	ld	s0,24(sp)
     5c2:	6105                	addi	sp,sp,32
     5c4:	8082                	ret

00000000000005c6 <gets>:

char*
gets(char *buf, int max)
{
     5c6:	7179                	addi	sp,sp,-48
     5c8:	f406                	sd	ra,40(sp)
     5ca:	f022                	sd	s0,32(sp)
     5cc:	1800                	addi	s0,sp,48
     5ce:	fca43c23          	sd	a0,-40(s0)
     5d2:	87ae                	mv	a5,a1
     5d4:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     5d8:	fe042623          	sw	zero,-20(s0)
     5dc:	a8a1                	j	634 <gets+0x6e>
    cc = read(0, &c, 1);
     5de:	fe740793          	addi	a5,s0,-25
     5e2:	4605                	li	a2,1
     5e4:	85be                	mv	a1,a5
     5e6:	4501                	li	a0,0
     5e8:	00000097          	auipc	ra,0x0
     5ec:	2f8080e7          	jalr	760(ra) # 8e0 <read>
     5f0:	87aa                	mv	a5,a0
     5f2:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
     5f6:	fe842783          	lw	a5,-24(s0)
     5fa:	2781                	sext.w	a5,a5
     5fc:	04f05763          	blez	a5,64a <gets+0x84>
      break;
    buf[i++] = c;
     600:	fec42783          	lw	a5,-20(s0)
     604:	0017871b          	addiw	a4,a5,1
     608:	fee42623          	sw	a4,-20(s0)
     60c:	873e                	mv	a4,a5
     60e:	fd843783          	ld	a5,-40(s0)
     612:	97ba                	add	a5,a5,a4
     614:	fe744703          	lbu	a4,-25(s0)
     618:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
     61c:	fe744783          	lbu	a5,-25(s0)
     620:	873e                	mv	a4,a5
     622:	47a9                	li	a5,10
     624:	02f70463          	beq	a4,a5,64c <gets+0x86>
     628:	fe744783          	lbu	a5,-25(s0)
     62c:	873e                	mv	a4,a5
     62e:	47b5                	li	a5,13
     630:	00f70e63          	beq	a4,a5,64c <gets+0x86>
  for(i=0; i+1 < max; ){
     634:	fec42783          	lw	a5,-20(s0)
     638:	2785                	addiw	a5,a5,1
     63a:	0007871b          	sext.w	a4,a5
     63e:	fd442783          	lw	a5,-44(s0)
     642:	2781                	sext.w	a5,a5
     644:	f8f74de3          	blt	a4,a5,5de <gets+0x18>
     648:	a011                	j	64c <gets+0x86>
      break;
     64a:	0001                	nop
      break;
  }
  buf[i] = '\0';
     64c:	fec42783          	lw	a5,-20(s0)
     650:	fd843703          	ld	a4,-40(s0)
     654:	97ba                	add	a5,a5,a4
     656:	00078023          	sb	zero,0(a5)
  return buf;
     65a:	fd843783          	ld	a5,-40(s0)
}
     65e:	853e                	mv	a0,a5
     660:	70a2                	ld	ra,40(sp)
     662:	7402                	ld	s0,32(sp)
     664:	6145                	addi	sp,sp,48
     666:	8082                	ret

0000000000000668 <stat>:

int
stat(const char *n, struct stat *st)
{
     668:	7179                	addi	sp,sp,-48
     66a:	f406                	sd	ra,40(sp)
     66c:	f022                	sd	s0,32(sp)
     66e:	1800                	addi	s0,sp,48
     670:	fca43c23          	sd	a0,-40(s0)
     674:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     678:	4581                	li	a1,0
     67a:	fd843503          	ld	a0,-40(s0)
     67e:	00000097          	auipc	ra,0x0
     682:	28a080e7          	jalr	650(ra) # 908 <open>
     686:	87aa                	mv	a5,a0
     688:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
     68c:	fec42783          	lw	a5,-20(s0)
     690:	2781                	sext.w	a5,a5
     692:	0007d463          	bgez	a5,69a <stat+0x32>
    return -1;
     696:	57fd                	li	a5,-1
     698:	a035                	j	6c4 <stat+0x5c>
  r = fstat(fd, st);
     69a:	fec42783          	lw	a5,-20(s0)
     69e:	fd043583          	ld	a1,-48(s0)
     6a2:	853e                	mv	a0,a5
     6a4:	00000097          	auipc	ra,0x0
     6a8:	27c080e7          	jalr	636(ra) # 920 <fstat>
     6ac:	87aa                	mv	a5,a0
     6ae:	fef42423          	sw	a5,-24(s0)
  close(fd);
     6b2:	fec42783          	lw	a5,-20(s0)
     6b6:	853e                	mv	a0,a5
     6b8:	00000097          	auipc	ra,0x0
     6bc:	238080e7          	jalr	568(ra) # 8f0 <close>
  return r;
     6c0:	fe842783          	lw	a5,-24(s0)
}
     6c4:	853e                	mv	a0,a5
     6c6:	70a2                	ld	ra,40(sp)
     6c8:	7402                	ld	s0,32(sp)
     6ca:	6145                	addi	sp,sp,48
     6cc:	8082                	ret

00000000000006ce <atoi>:

int
atoi(const char *s)
{
     6ce:	7179                	addi	sp,sp,-48
     6d0:	f422                	sd	s0,40(sp)
     6d2:	1800                	addi	s0,sp,48
     6d4:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
     6d8:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
     6dc:	a81d                	j	712 <atoi+0x44>
    n = n*10 + *s++ - '0';
     6de:	fec42783          	lw	a5,-20(s0)
     6e2:	873e                	mv	a4,a5
     6e4:	87ba                	mv	a5,a4
     6e6:	0027979b          	slliw	a5,a5,0x2
     6ea:	9fb9                	addw	a5,a5,a4
     6ec:	0017979b          	slliw	a5,a5,0x1
     6f0:	0007871b          	sext.w	a4,a5
     6f4:	fd843783          	ld	a5,-40(s0)
     6f8:	00178693          	addi	a3,a5,1
     6fc:	fcd43c23          	sd	a3,-40(s0)
     700:	0007c783          	lbu	a5,0(a5)
     704:	2781                	sext.w	a5,a5
     706:	9fb9                	addw	a5,a5,a4
     708:	2781                	sext.w	a5,a5
     70a:	fd07879b          	addiw	a5,a5,-48
     70e:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
     712:	fd843783          	ld	a5,-40(s0)
     716:	0007c783          	lbu	a5,0(a5)
     71a:	873e                	mv	a4,a5
     71c:	02f00793          	li	a5,47
     720:	00e7fb63          	bgeu	a5,a4,736 <atoi+0x68>
     724:	fd843783          	ld	a5,-40(s0)
     728:	0007c783          	lbu	a5,0(a5)
     72c:	873e                	mv	a4,a5
     72e:	03900793          	li	a5,57
     732:	fae7f6e3          	bgeu	a5,a4,6de <atoi+0x10>
  return n;
     736:	fec42783          	lw	a5,-20(s0)
}
     73a:	853e                	mv	a0,a5
     73c:	7422                	ld	s0,40(sp)
     73e:	6145                	addi	sp,sp,48
     740:	8082                	ret

0000000000000742 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     742:	7139                	addi	sp,sp,-64
     744:	fc22                	sd	s0,56(sp)
     746:	0080                	addi	s0,sp,64
     748:	fca43c23          	sd	a0,-40(s0)
     74c:	fcb43823          	sd	a1,-48(s0)
     750:	87b2                	mv	a5,a2
     752:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
     756:	fd843783          	ld	a5,-40(s0)
     75a:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
     75e:	fd043783          	ld	a5,-48(s0)
     762:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
     766:	fe043703          	ld	a4,-32(s0)
     76a:	fe843783          	ld	a5,-24(s0)
     76e:	02e7fc63          	bgeu	a5,a4,7a6 <memmove+0x64>
    while(n-- > 0)
     772:	a00d                	j	794 <memmove+0x52>
      *dst++ = *src++;
     774:	fe043703          	ld	a4,-32(s0)
     778:	00170793          	addi	a5,a4,1
     77c:	fef43023          	sd	a5,-32(s0)
     780:	fe843783          	ld	a5,-24(s0)
     784:	00178693          	addi	a3,a5,1
     788:	fed43423          	sd	a3,-24(s0)
     78c:	00074703          	lbu	a4,0(a4)
     790:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     794:	fcc42783          	lw	a5,-52(s0)
     798:	fff7871b          	addiw	a4,a5,-1
     79c:	fce42623          	sw	a4,-52(s0)
     7a0:	fcf04ae3          	bgtz	a5,774 <memmove+0x32>
     7a4:	a891                	j	7f8 <memmove+0xb6>
  } else {
    dst += n;
     7a6:	fcc42783          	lw	a5,-52(s0)
     7aa:	fe843703          	ld	a4,-24(s0)
     7ae:	97ba                	add	a5,a5,a4
     7b0:	fef43423          	sd	a5,-24(s0)
    src += n;
     7b4:	fcc42783          	lw	a5,-52(s0)
     7b8:	fe043703          	ld	a4,-32(s0)
     7bc:	97ba                	add	a5,a5,a4
     7be:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
     7c2:	a01d                	j	7e8 <memmove+0xa6>
      *--dst = *--src;
     7c4:	fe043783          	ld	a5,-32(s0)
     7c8:	17fd                	addi	a5,a5,-1
     7ca:	fef43023          	sd	a5,-32(s0)
     7ce:	fe843783          	ld	a5,-24(s0)
     7d2:	17fd                	addi	a5,a5,-1
     7d4:	fef43423          	sd	a5,-24(s0)
     7d8:	fe043783          	ld	a5,-32(s0)
     7dc:	0007c703          	lbu	a4,0(a5)
     7e0:	fe843783          	ld	a5,-24(s0)
     7e4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     7e8:	fcc42783          	lw	a5,-52(s0)
     7ec:	fff7871b          	addiw	a4,a5,-1
     7f0:	fce42623          	sw	a4,-52(s0)
     7f4:	fcf048e3          	bgtz	a5,7c4 <memmove+0x82>
  }
  return vdst;
     7f8:	fd843783          	ld	a5,-40(s0)
}
     7fc:	853e                	mv	a0,a5
     7fe:	7462                	ld	s0,56(sp)
     800:	6121                	addi	sp,sp,64
     802:	8082                	ret

0000000000000804 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     804:	7139                	addi	sp,sp,-64
     806:	fc22                	sd	s0,56(sp)
     808:	0080                	addi	s0,sp,64
     80a:	fca43c23          	sd	a0,-40(s0)
     80e:	fcb43823          	sd	a1,-48(s0)
     812:	87b2                	mv	a5,a2
     814:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
     818:	fd843783          	ld	a5,-40(s0)
     81c:	fef43423          	sd	a5,-24(s0)
     820:	fd043783          	ld	a5,-48(s0)
     824:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     828:	a0a1                	j	870 <memcmp+0x6c>
    if (*p1 != *p2) {
     82a:	fe843783          	ld	a5,-24(s0)
     82e:	0007c703          	lbu	a4,0(a5)
     832:	fe043783          	ld	a5,-32(s0)
     836:	0007c783          	lbu	a5,0(a5)
     83a:	02f70163          	beq	a4,a5,85c <memcmp+0x58>
      return *p1 - *p2;
     83e:	fe843783          	ld	a5,-24(s0)
     842:	0007c783          	lbu	a5,0(a5)
     846:	0007871b          	sext.w	a4,a5
     84a:	fe043783          	ld	a5,-32(s0)
     84e:	0007c783          	lbu	a5,0(a5)
     852:	2781                	sext.w	a5,a5
     854:	40f707bb          	subw	a5,a4,a5
     858:	2781                	sext.w	a5,a5
     85a:	a01d                	j	880 <memcmp+0x7c>
    }
    p1++;
     85c:	fe843783          	ld	a5,-24(s0)
     860:	0785                	addi	a5,a5,1
     862:	fef43423          	sd	a5,-24(s0)
    p2++;
     866:	fe043783          	ld	a5,-32(s0)
     86a:	0785                	addi	a5,a5,1
     86c:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     870:	fcc42783          	lw	a5,-52(s0)
     874:	fff7871b          	addiw	a4,a5,-1
     878:	fce42623          	sw	a4,-52(s0)
     87c:	f7dd                	bnez	a5,82a <memcmp+0x26>
  }
  return 0;
     87e:	4781                	li	a5,0
}
     880:	853e                	mv	a0,a5
     882:	7462                	ld	s0,56(sp)
     884:	6121                	addi	sp,sp,64
     886:	8082                	ret

0000000000000888 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     888:	7179                	addi	sp,sp,-48
     88a:	f406                	sd	ra,40(sp)
     88c:	f022                	sd	s0,32(sp)
     88e:	1800                	addi	s0,sp,48
     890:	fea43423          	sd	a0,-24(s0)
     894:	feb43023          	sd	a1,-32(s0)
     898:	87b2                	mv	a5,a2
     89a:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
     89e:	fdc42783          	lw	a5,-36(s0)
     8a2:	863e                	mv	a2,a5
     8a4:	fe043583          	ld	a1,-32(s0)
     8a8:	fe843503          	ld	a0,-24(s0)
     8ac:	00000097          	auipc	ra,0x0
     8b0:	e96080e7          	jalr	-362(ra) # 742 <memmove>
     8b4:	87aa                	mv	a5,a0
}
     8b6:	853e                	mv	a0,a5
     8b8:	70a2                	ld	ra,40(sp)
     8ba:	7402                	ld	s0,32(sp)
     8bc:	6145                	addi	sp,sp,48
     8be:	8082                	ret

00000000000008c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     8c0:	4885                	li	a7,1
 ecall
     8c2:	00000073          	ecall
 ret
     8c6:	8082                	ret

00000000000008c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     8c8:	4889                	li	a7,2
 ecall
     8ca:	00000073          	ecall
 ret
     8ce:	8082                	ret

00000000000008d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     8d0:	488d                	li	a7,3
 ecall
     8d2:	00000073          	ecall
 ret
     8d6:	8082                	ret

00000000000008d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     8d8:	4891                	li	a7,4
 ecall
     8da:	00000073          	ecall
 ret
     8de:	8082                	ret

00000000000008e0 <read>:
.global read
read:
 li a7, SYS_read
     8e0:	4895                	li	a7,5
 ecall
     8e2:	00000073          	ecall
 ret
     8e6:	8082                	ret

00000000000008e8 <write>:
.global write
write:
 li a7, SYS_write
     8e8:	48c1                	li	a7,16
 ecall
     8ea:	00000073          	ecall
 ret
     8ee:	8082                	ret

00000000000008f0 <close>:
.global close
close:
 li a7, SYS_close
     8f0:	48d5                	li	a7,21
 ecall
     8f2:	00000073          	ecall
 ret
     8f6:	8082                	ret

00000000000008f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
     8f8:	4899                	li	a7,6
 ecall
     8fa:	00000073          	ecall
 ret
     8fe:	8082                	ret

0000000000000900 <exec>:
.global exec
exec:
 li a7, SYS_exec
     900:	489d                	li	a7,7
 ecall
     902:	00000073          	ecall
 ret
     906:	8082                	ret

0000000000000908 <open>:
.global open
open:
 li a7, SYS_open
     908:	48bd                	li	a7,15
 ecall
     90a:	00000073          	ecall
 ret
     90e:	8082                	ret

0000000000000910 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     910:	48c5                	li	a7,17
 ecall
     912:	00000073          	ecall
 ret
     916:	8082                	ret

0000000000000918 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     918:	48c9                	li	a7,18
 ecall
     91a:	00000073          	ecall
 ret
     91e:	8082                	ret

0000000000000920 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     920:	48a1                	li	a7,8
 ecall
     922:	00000073          	ecall
 ret
     926:	8082                	ret

0000000000000928 <link>:
.global link
link:
 li a7, SYS_link
     928:	48cd                	li	a7,19
 ecall
     92a:	00000073          	ecall
 ret
     92e:	8082                	ret

0000000000000930 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     930:	48d1                	li	a7,20
 ecall
     932:	00000073          	ecall
 ret
     936:	8082                	ret

0000000000000938 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     938:	48a5                	li	a7,9
 ecall
     93a:	00000073          	ecall
 ret
     93e:	8082                	ret

0000000000000940 <dup>:
.global dup
dup:
 li a7, SYS_dup
     940:	48a9                	li	a7,10
 ecall
     942:	00000073          	ecall
 ret
     946:	8082                	ret

0000000000000948 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     948:	48ad                	li	a7,11
 ecall
     94a:	00000073          	ecall
 ret
     94e:	8082                	ret

0000000000000950 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     950:	48b1                	li	a7,12
 ecall
     952:	00000073          	ecall
 ret
     956:	8082                	ret

0000000000000958 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     958:	48b5                	li	a7,13
 ecall
     95a:	00000073          	ecall
 ret
     95e:	8082                	ret

0000000000000960 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     960:	48b9                	li	a7,14
 ecall
     962:	00000073          	ecall
 ret
     966:	8082                	ret

0000000000000968 <hello>:
.global hello
hello:
 li a7, SYS_hello
     968:	48d9                	li	a7,22
 ecall
     96a:	00000073          	ecall
 ret
     96e:	8082                	ret

0000000000000970 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
     970:	48dd                	li	a7,23
 ecall
     972:	00000073          	ecall
 ret
     976:	8082                	ret

0000000000000978 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     978:	1101                	addi	sp,sp,-32
     97a:	ec06                	sd	ra,24(sp)
     97c:	e822                	sd	s0,16(sp)
     97e:	1000                	addi	s0,sp,32
     980:	87aa                	mv	a5,a0
     982:	872e                	mv	a4,a1
     984:	fef42623          	sw	a5,-20(s0)
     988:	87ba                	mv	a5,a4
     98a:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     98e:	feb40713          	addi	a4,s0,-21
     992:	fec42783          	lw	a5,-20(s0)
     996:	4605                	li	a2,1
     998:	85ba                	mv	a1,a4
     99a:	853e                	mv	a0,a5
     99c:	00000097          	auipc	ra,0x0
     9a0:	f4c080e7          	jalr	-180(ra) # 8e8 <write>
}
     9a4:	0001                	nop
     9a6:	60e2                	ld	ra,24(sp)
     9a8:	6442                	ld	s0,16(sp)
     9aa:	6105                	addi	sp,sp,32
     9ac:	8082                	ret

00000000000009ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     9ae:	7139                	addi	sp,sp,-64
     9b0:	fc06                	sd	ra,56(sp)
     9b2:	f822                	sd	s0,48(sp)
     9b4:	0080                	addi	s0,sp,64
     9b6:	87aa                	mv	a5,a0
     9b8:	8736                	mv	a4,a3
     9ba:	fcf42623          	sw	a5,-52(s0)
     9be:	87ae                	mv	a5,a1
     9c0:	fcf42423          	sw	a5,-56(s0)
     9c4:	87b2                	mv	a5,a2
     9c6:	fcf42223          	sw	a5,-60(s0)
     9ca:	87ba                	mv	a5,a4
     9cc:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     9d0:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     9d4:	fc042783          	lw	a5,-64(s0)
     9d8:	2781                	sext.w	a5,a5
     9da:	c38d                	beqz	a5,9fc <printint+0x4e>
     9dc:	fc842783          	lw	a5,-56(s0)
     9e0:	2781                	sext.w	a5,a5
     9e2:	0007dd63          	bgez	a5,9fc <printint+0x4e>
    neg = 1;
     9e6:	4785                	li	a5,1
     9e8:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     9ec:	fc842783          	lw	a5,-56(s0)
     9f0:	40f007bb          	negw	a5,a5
     9f4:	2781                	sext.w	a5,a5
     9f6:	fef42223          	sw	a5,-28(s0)
     9fa:	a029                	j	a04 <printint+0x56>
  } else {
    x = xx;
     9fc:	fc842783          	lw	a5,-56(s0)
     a00:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     a04:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     a08:	fc442783          	lw	a5,-60(s0)
     a0c:	fe442703          	lw	a4,-28(s0)
     a10:	02f777bb          	remuw	a5,a4,a5
     a14:	0007861b          	sext.w	a2,a5
     a18:	fec42783          	lw	a5,-20(s0)
     a1c:	0017871b          	addiw	a4,a5,1
     a20:	fee42623          	sw	a4,-20(s0)
     a24:	00002697          	auipc	a3,0x2
     a28:	9ec68693          	addi	a3,a3,-1556 # 2410 <digits>
     a2c:	02061713          	slli	a4,a2,0x20
     a30:	9301                	srli	a4,a4,0x20
     a32:	9736                	add	a4,a4,a3
     a34:	00074703          	lbu	a4,0(a4)
     a38:	17c1                	addi	a5,a5,-16
     a3a:	97a2                	add	a5,a5,s0
     a3c:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     a40:	fc442783          	lw	a5,-60(s0)
     a44:	fe442703          	lw	a4,-28(s0)
     a48:	02f757bb          	divuw	a5,a4,a5
     a4c:	fef42223          	sw	a5,-28(s0)
     a50:	fe442783          	lw	a5,-28(s0)
     a54:	2781                	sext.w	a5,a5
     a56:	fbcd                	bnez	a5,a08 <printint+0x5a>
  if(neg)
     a58:	fe842783          	lw	a5,-24(s0)
     a5c:	2781                	sext.w	a5,a5
     a5e:	cf85                	beqz	a5,a96 <printint+0xe8>
    buf[i++] = '-';
     a60:	fec42783          	lw	a5,-20(s0)
     a64:	0017871b          	addiw	a4,a5,1
     a68:	fee42623          	sw	a4,-20(s0)
     a6c:	17c1                	addi	a5,a5,-16
     a6e:	97a2                	add	a5,a5,s0
     a70:	02d00713          	li	a4,45
     a74:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     a78:	a839                	j	a96 <printint+0xe8>
    putc(fd, buf[i]);
     a7a:	fec42783          	lw	a5,-20(s0)
     a7e:	17c1                	addi	a5,a5,-16
     a80:	97a2                	add	a5,a5,s0
     a82:	fe07c703          	lbu	a4,-32(a5)
     a86:	fcc42783          	lw	a5,-52(s0)
     a8a:	85ba                	mv	a1,a4
     a8c:	853e                	mv	a0,a5
     a8e:	00000097          	auipc	ra,0x0
     a92:	eea080e7          	jalr	-278(ra) # 978 <putc>
  while(--i >= 0)
     a96:	fec42783          	lw	a5,-20(s0)
     a9a:	37fd                	addiw	a5,a5,-1
     a9c:	fef42623          	sw	a5,-20(s0)
     aa0:	fec42783          	lw	a5,-20(s0)
     aa4:	2781                	sext.w	a5,a5
     aa6:	fc07dae3          	bgez	a5,a7a <printint+0xcc>
}
     aaa:	0001                	nop
     aac:	0001                	nop
     aae:	70e2                	ld	ra,56(sp)
     ab0:	7442                	ld	s0,48(sp)
     ab2:	6121                	addi	sp,sp,64
     ab4:	8082                	ret

0000000000000ab6 <printptr>:

static void
printptr(int fd, uint64 x) {
     ab6:	7179                	addi	sp,sp,-48
     ab8:	f406                	sd	ra,40(sp)
     aba:	f022                	sd	s0,32(sp)
     abc:	1800                	addi	s0,sp,48
     abe:	87aa                	mv	a5,a0
     ac0:	fcb43823          	sd	a1,-48(s0)
     ac4:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     ac8:	fdc42783          	lw	a5,-36(s0)
     acc:	03000593          	li	a1,48
     ad0:	853e                	mv	a0,a5
     ad2:	00000097          	auipc	ra,0x0
     ad6:	ea6080e7          	jalr	-346(ra) # 978 <putc>
  putc(fd, 'x');
     ada:	fdc42783          	lw	a5,-36(s0)
     ade:	07800593          	li	a1,120
     ae2:	853e                	mv	a0,a5
     ae4:	00000097          	auipc	ra,0x0
     ae8:	e94080e7          	jalr	-364(ra) # 978 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     aec:	fe042623          	sw	zero,-20(s0)
     af0:	a82d                	j	b2a <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     af2:	fd043783          	ld	a5,-48(s0)
     af6:	93f1                	srli	a5,a5,0x3c
     af8:	00002717          	auipc	a4,0x2
     afc:	91870713          	addi	a4,a4,-1768 # 2410 <digits>
     b00:	97ba                	add	a5,a5,a4
     b02:	0007c703          	lbu	a4,0(a5)
     b06:	fdc42783          	lw	a5,-36(s0)
     b0a:	85ba                	mv	a1,a4
     b0c:	853e                	mv	a0,a5
     b0e:	00000097          	auipc	ra,0x0
     b12:	e6a080e7          	jalr	-406(ra) # 978 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     b16:	fec42783          	lw	a5,-20(s0)
     b1a:	2785                	addiw	a5,a5,1
     b1c:	fef42623          	sw	a5,-20(s0)
     b20:	fd043783          	ld	a5,-48(s0)
     b24:	0792                	slli	a5,a5,0x4
     b26:	fcf43823          	sd	a5,-48(s0)
     b2a:	fec42783          	lw	a5,-20(s0)
     b2e:	873e                	mv	a4,a5
     b30:	47bd                	li	a5,15
     b32:	fce7f0e3          	bgeu	a5,a4,af2 <printptr+0x3c>
}
     b36:	0001                	nop
     b38:	0001                	nop
     b3a:	70a2                	ld	ra,40(sp)
     b3c:	7402                	ld	s0,32(sp)
     b3e:	6145                	addi	sp,sp,48
     b40:	8082                	ret

0000000000000b42 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     b42:	715d                	addi	sp,sp,-80
     b44:	e486                	sd	ra,72(sp)
     b46:	e0a2                	sd	s0,64(sp)
     b48:	0880                	addi	s0,sp,80
     b4a:	87aa                	mv	a5,a0
     b4c:	fcb43023          	sd	a1,-64(s0)
     b50:	fac43c23          	sd	a2,-72(s0)
     b54:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     b58:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     b5c:	fe042223          	sw	zero,-28(s0)
     b60:	a42d                	j	d8a <vprintf+0x248>
    c = fmt[i] & 0xff;
     b62:	fe442783          	lw	a5,-28(s0)
     b66:	fc043703          	ld	a4,-64(s0)
     b6a:	97ba                	add	a5,a5,a4
     b6c:	0007c783          	lbu	a5,0(a5)
     b70:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     b74:	fe042783          	lw	a5,-32(s0)
     b78:	2781                	sext.w	a5,a5
     b7a:	eb9d                	bnez	a5,bb0 <vprintf+0x6e>
      if(c == '%'){
     b7c:	fdc42783          	lw	a5,-36(s0)
     b80:	0007871b          	sext.w	a4,a5
     b84:	02500793          	li	a5,37
     b88:	00f71763          	bne	a4,a5,b96 <vprintf+0x54>
        state = '%';
     b8c:	02500793          	li	a5,37
     b90:	fef42023          	sw	a5,-32(s0)
     b94:	a2f5                	j	d80 <vprintf+0x23e>
      } else {
        putc(fd, c);
     b96:	fdc42783          	lw	a5,-36(s0)
     b9a:	0ff7f713          	zext.b	a4,a5
     b9e:	fcc42783          	lw	a5,-52(s0)
     ba2:	85ba                	mv	a1,a4
     ba4:	853e                	mv	a0,a5
     ba6:	00000097          	auipc	ra,0x0
     baa:	dd2080e7          	jalr	-558(ra) # 978 <putc>
     bae:	aac9                	j	d80 <vprintf+0x23e>
      }
    } else if(state == '%'){
     bb0:	fe042783          	lw	a5,-32(s0)
     bb4:	0007871b          	sext.w	a4,a5
     bb8:	02500793          	li	a5,37
     bbc:	1cf71263          	bne	a4,a5,d80 <vprintf+0x23e>
      if(c == 'd'){
     bc0:	fdc42783          	lw	a5,-36(s0)
     bc4:	0007871b          	sext.w	a4,a5
     bc8:	06400793          	li	a5,100
     bcc:	02f71463          	bne	a4,a5,bf4 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     bd0:	fb843783          	ld	a5,-72(s0)
     bd4:	00878713          	addi	a4,a5,8
     bd8:	fae43c23          	sd	a4,-72(s0)
     bdc:	4398                	lw	a4,0(a5)
     bde:	fcc42783          	lw	a5,-52(s0)
     be2:	4685                	li	a3,1
     be4:	4629                	li	a2,10
     be6:	85ba                	mv	a1,a4
     be8:	853e                	mv	a0,a5
     bea:	00000097          	auipc	ra,0x0
     bee:	dc4080e7          	jalr	-572(ra) # 9ae <printint>
     bf2:	a269                	j	d7c <vprintf+0x23a>
      } else if(c == 'l') {
     bf4:	fdc42783          	lw	a5,-36(s0)
     bf8:	0007871b          	sext.w	a4,a5
     bfc:	06c00793          	li	a5,108
     c00:	02f71663          	bne	a4,a5,c2c <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c04:	fb843783          	ld	a5,-72(s0)
     c08:	00878713          	addi	a4,a5,8
     c0c:	fae43c23          	sd	a4,-72(s0)
     c10:	639c                	ld	a5,0(a5)
     c12:	0007871b          	sext.w	a4,a5
     c16:	fcc42783          	lw	a5,-52(s0)
     c1a:	4681                	li	a3,0
     c1c:	4629                	li	a2,10
     c1e:	85ba                	mv	a1,a4
     c20:	853e                	mv	a0,a5
     c22:	00000097          	auipc	ra,0x0
     c26:	d8c080e7          	jalr	-628(ra) # 9ae <printint>
     c2a:	aa89                	j	d7c <vprintf+0x23a>
      } else if(c == 'x') {
     c2c:	fdc42783          	lw	a5,-36(s0)
     c30:	0007871b          	sext.w	a4,a5
     c34:	07800793          	li	a5,120
     c38:	02f71463          	bne	a4,a5,c60 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     c3c:	fb843783          	ld	a5,-72(s0)
     c40:	00878713          	addi	a4,a5,8
     c44:	fae43c23          	sd	a4,-72(s0)
     c48:	4398                	lw	a4,0(a5)
     c4a:	fcc42783          	lw	a5,-52(s0)
     c4e:	4681                	li	a3,0
     c50:	4641                	li	a2,16
     c52:	85ba                	mv	a1,a4
     c54:	853e                	mv	a0,a5
     c56:	00000097          	auipc	ra,0x0
     c5a:	d58080e7          	jalr	-680(ra) # 9ae <printint>
     c5e:	aa39                	j	d7c <vprintf+0x23a>
      } else if(c == 'p') {
     c60:	fdc42783          	lw	a5,-36(s0)
     c64:	0007871b          	sext.w	a4,a5
     c68:	07000793          	li	a5,112
     c6c:	02f71263          	bne	a4,a5,c90 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     c70:	fb843783          	ld	a5,-72(s0)
     c74:	00878713          	addi	a4,a5,8
     c78:	fae43c23          	sd	a4,-72(s0)
     c7c:	6398                	ld	a4,0(a5)
     c7e:	fcc42783          	lw	a5,-52(s0)
     c82:	85ba                	mv	a1,a4
     c84:	853e                	mv	a0,a5
     c86:	00000097          	auipc	ra,0x0
     c8a:	e30080e7          	jalr	-464(ra) # ab6 <printptr>
     c8e:	a0fd                	j	d7c <vprintf+0x23a>
      } else if(c == 's'){
     c90:	fdc42783          	lw	a5,-36(s0)
     c94:	0007871b          	sext.w	a4,a5
     c98:	07300793          	li	a5,115
     c9c:	04f71c63          	bne	a4,a5,cf4 <vprintf+0x1b2>
        s = va_arg(ap, char*);
     ca0:	fb843783          	ld	a5,-72(s0)
     ca4:	00878713          	addi	a4,a5,8
     ca8:	fae43c23          	sd	a4,-72(s0)
     cac:	639c                	ld	a5,0(a5)
     cae:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     cb2:	fe843783          	ld	a5,-24(s0)
     cb6:	eb8d                	bnez	a5,ce8 <vprintf+0x1a6>
          s = "(null)";
     cb8:	00000797          	auipc	a5,0x0
     cbc:	4b078793          	addi	a5,a5,1200 # 1168 <malloc+0x176>
     cc0:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     cc4:	a015                	j	ce8 <vprintf+0x1a6>
          putc(fd, *s);
     cc6:	fe843783          	ld	a5,-24(s0)
     cca:	0007c703          	lbu	a4,0(a5)
     cce:	fcc42783          	lw	a5,-52(s0)
     cd2:	85ba                	mv	a1,a4
     cd4:	853e                	mv	a0,a5
     cd6:	00000097          	auipc	ra,0x0
     cda:	ca2080e7          	jalr	-862(ra) # 978 <putc>
          s++;
     cde:	fe843783          	ld	a5,-24(s0)
     ce2:	0785                	addi	a5,a5,1
     ce4:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     ce8:	fe843783          	ld	a5,-24(s0)
     cec:	0007c783          	lbu	a5,0(a5)
     cf0:	fbf9                	bnez	a5,cc6 <vprintf+0x184>
     cf2:	a069                	j	d7c <vprintf+0x23a>
        }
      } else if(c == 'c'){
     cf4:	fdc42783          	lw	a5,-36(s0)
     cf8:	0007871b          	sext.w	a4,a5
     cfc:	06300793          	li	a5,99
     d00:	02f71463          	bne	a4,a5,d28 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     d04:	fb843783          	ld	a5,-72(s0)
     d08:	00878713          	addi	a4,a5,8
     d0c:	fae43c23          	sd	a4,-72(s0)
     d10:	439c                	lw	a5,0(a5)
     d12:	0ff7f713          	zext.b	a4,a5
     d16:	fcc42783          	lw	a5,-52(s0)
     d1a:	85ba                	mv	a1,a4
     d1c:	853e                	mv	a0,a5
     d1e:	00000097          	auipc	ra,0x0
     d22:	c5a080e7          	jalr	-934(ra) # 978 <putc>
     d26:	a899                	j	d7c <vprintf+0x23a>
      } else if(c == '%'){
     d28:	fdc42783          	lw	a5,-36(s0)
     d2c:	0007871b          	sext.w	a4,a5
     d30:	02500793          	li	a5,37
     d34:	00f71f63          	bne	a4,a5,d52 <vprintf+0x210>
        putc(fd, c);
     d38:	fdc42783          	lw	a5,-36(s0)
     d3c:	0ff7f713          	zext.b	a4,a5
     d40:	fcc42783          	lw	a5,-52(s0)
     d44:	85ba                	mv	a1,a4
     d46:	853e                	mv	a0,a5
     d48:	00000097          	auipc	ra,0x0
     d4c:	c30080e7          	jalr	-976(ra) # 978 <putc>
     d50:	a035                	j	d7c <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     d52:	fcc42783          	lw	a5,-52(s0)
     d56:	02500593          	li	a1,37
     d5a:	853e                	mv	a0,a5
     d5c:	00000097          	auipc	ra,0x0
     d60:	c1c080e7          	jalr	-996(ra) # 978 <putc>
        putc(fd, c);
     d64:	fdc42783          	lw	a5,-36(s0)
     d68:	0ff7f713          	zext.b	a4,a5
     d6c:	fcc42783          	lw	a5,-52(s0)
     d70:	85ba                	mv	a1,a4
     d72:	853e                	mv	a0,a5
     d74:	00000097          	auipc	ra,0x0
     d78:	c04080e7          	jalr	-1020(ra) # 978 <putc>
      }
      state = 0;
     d7c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     d80:	fe442783          	lw	a5,-28(s0)
     d84:	2785                	addiw	a5,a5,1
     d86:	fef42223          	sw	a5,-28(s0)
     d8a:	fe442783          	lw	a5,-28(s0)
     d8e:	fc043703          	ld	a4,-64(s0)
     d92:	97ba                	add	a5,a5,a4
     d94:	0007c783          	lbu	a5,0(a5)
     d98:	dc0795e3          	bnez	a5,b62 <vprintf+0x20>
    }
  }
}
     d9c:	0001                	nop
     d9e:	0001                	nop
     da0:	60a6                	ld	ra,72(sp)
     da2:	6406                	ld	s0,64(sp)
     da4:	6161                	addi	sp,sp,80
     da6:	8082                	ret

0000000000000da8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     da8:	7159                	addi	sp,sp,-112
     daa:	fc06                	sd	ra,56(sp)
     dac:	f822                	sd	s0,48(sp)
     dae:	0080                	addi	s0,sp,64
     db0:	fcb43823          	sd	a1,-48(s0)
     db4:	e010                	sd	a2,0(s0)
     db6:	e414                	sd	a3,8(s0)
     db8:	e818                	sd	a4,16(s0)
     dba:	ec1c                	sd	a5,24(s0)
     dbc:	03043023          	sd	a6,32(s0)
     dc0:	03143423          	sd	a7,40(s0)
     dc4:	87aa                	mv	a5,a0
     dc6:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     dca:	03040793          	addi	a5,s0,48
     dce:	fcf43423          	sd	a5,-56(s0)
     dd2:	fc843783          	ld	a5,-56(s0)
     dd6:	fd078793          	addi	a5,a5,-48
     dda:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     dde:	fe843703          	ld	a4,-24(s0)
     de2:	fdc42783          	lw	a5,-36(s0)
     de6:	863a                	mv	a2,a4
     de8:	fd043583          	ld	a1,-48(s0)
     dec:	853e                	mv	a0,a5
     dee:	00000097          	auipc	ra,0x0
     df2:	d54080e7          	jalr	-684(ra) # b42 <vprintf>
}
     df6:	0001                	nop
     df8:	70e2                	ld	ra,56(sp)
     dfa:	7442                	ld	s0,48(sp)
     dfc:	6165                	addi	sp,sp,112
     dfe:	8082                	ret

0000000000000e00 <printf>:

void
printf(const char *fmt, ...)
{
     e00:	7159                	addi	sp,sp,-112
     e02:	f406                	sd	ra,40(sp)
     e04:	f022                	sd	s0,32(sp)
     e06:	1800                	addi	s0,sp,48
     e08:	fca43c23          	sd	a0,-40(s0)
     e0c:	e40c                	sd	a1,8(s0)
     e0e:	e810                	sd	a2,16(s0)
     e10:	ec14                	sd	a3,24(s0)
     e12:	f018                	sd	a4,32(s0)
     e14:	f41c                	sd	a5,40(s0)
     e16:	03043823          	sd	a6,48(s0)
     e1a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e1e:	04040793          	addi	a5,s0,64
     e22:	fcf43823          	sd	a5,-48(s0)
     e26:	fd043783          	ld	a5,-48(s0)
     e2a:	fc878793          	addi	a5,a5,-56
     e2e:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     e32:	fe843783          	ld	a5,-24(s0)
     e36:	863e                	mv	a2,a5
     e38:	fd843583          	ld	a1,-40(s0)
     e3c:	4505                	li	a0,1
     e3e:	00000097          	auipc	ra,0x0
     e42:	d04080e7          	jalr	-764(ra) # b42 <vprintf>
}
     e46:	0001                	nop
     e48:	70a2                	ld	ra,40(sp)
     e4a:	7402                	ld	s0,32(sp)
     e4c:	6165                	addi	sp,sp,112
     e4e:	8082                	ret

0000000000000e50 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     e50:	7179                	addi	sp,sp,-48
     e52:	f422                	sd	s0,40(sp)
     e54:	1800                	addi	s0,sp,48
     e56:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     e5a:	fd843783          	ld	a5,-40(s0)
     e5e:	17c1                	addi	a5,a5,-16
     e60:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e64:	00002797          	auipc	a5,0x2
     e68:	9dc78793          	addi	a5,a5,-1572 # 2840 <freep>
     e6c:	639c                	ld	a5,0(a5)
     e6e:	fef43423          	sd	a5,-24(s0)
     e72:	a815                	j	ea6 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e74:	fe843783          	ld	a5,-24(s0)
     e78:	639c                	ld	a5,0(a5)
     e7a:	fe843703          	ld	a4,-24(s0)
     e7e:	00f76f63          	bltu	a4,a5,e9c <free+0x4c>
     e82:	fe043703          	ld	a4,-32(s0)
     e86:	fe843783          	ld	a5,-24(s0)
     e8a:	02e7eb63          	bltu	a5,a4,ec0 <free+0x70>
     e8e:	fe843783          	ld	a5,-24(s0)
     e92:	639c                	ld	a5,0(a5)
     e94:	fe043703          	ld	a4,-32(s0)
     e98:	02f76463          	bltu	a4,a5,ec0 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e9c:	fe843783          	ld	a5,-24(s0)
     ea0:	639c                	ld	a5,0(a5)
     ea2:	fef43423          	sd	a5,-24(s0)
     ea6:	fe043703          	ld	a4,-32(s0)
     eaa:	fe843783          	ld	a5,-24(s0)
     eae:	fce7f3e3          	bgeu	a5,a4,e74 <free+0x24>
     eb2:	fe843783          	ld	a5,-24(s0)
     eb6:	639c                	ld	a5,0(a5)
     eb8:	fe043703          	ld	a4,-32(s0)
     ebc:	faf77ce3          	bgeu	a4,a5,e74 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
     ec0:	fe043783          	ld	a5,-32(s0)
     ec4:	479c                	lw	a5,8(a5)
     ec6:	1782                	slli	a5,a5,0x20
     ec8:	9381                	srli	a5,a5,0x20
     eca:	0792                	slli	a5,a5,0x4
     ecc:	fe043703          	ld	a4,-32(s0)
     ed0:	973e                	add	a4,a4,a5
     ed2:	fe843783          	ld	a5,-24(s0)
     ed6:	639c                	ld	a5,0(a5)
     ed8:	02f71763          	bne	a4,a5,f06 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
     edc:	fe043783          	ld	a5,-32(s0)
     ee0:	4798                	lw	a4,8(a5)
     ee2:	fe843783          	ld	a5,-24(s0)
     ee6:	639c                	ld	a5,0(a5)
     ee8:	479c                	lw	a5,8(a5)
     eea:	9fb9                	addw	a5,a5,a4
     eec:	0007871b          	sext.w	a4,a5
     ef0:	fe043783          	ld	a5,-32(s0)
     ef4:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     ef6:	fe843783          	ld	a5,-24(s0)
     efa:	639c                	ld	a5,0(a5)
     efc:	6398                	ld	a4,0(a5)
     efe:	fe043783          	ld	a5,-32(s0)
     f02:	e398                	sd	a4,0(a5)
     f04:	a039                	j	f12 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
     f06:	fe843783          	ld	a5,-24(s0)
     f0a:	6398                	ld	a4,0(a5)
     f0c:	fe043783          	ld	a5,-32(s0)
     f10:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     f12:	fe843783          	ld	a5,-24(s0)
     f16:	479c                	lw	a5,8(a5)
     f18:	1782                	slli	a5,a5,0x20
     f1a:	9381                	srli	a5,a5,0x20
     f1c:	0792                	slli	a5,a5,0x4
     f1e:	fe843703          	ld	a4,-24(s0)
     f22:	97ba                	add	a5,a5,a4
     f24:	fe043703          	ld	a4,-32(s0)
     f28:	02f71563          	bne	a4,a5,f52 <free+0x102>
    p->s.size += bp->s.size;
     f2c:	fe843783          	ld	a5,-24(s0)
     f30:	4798                	lw	a4,8(a5)
     f32:	fe043783          	ld	a5,-32(s0)
     f36:	479c                	lw	a5,8(a5)
     f38:	9fb9                	addw	a5,a5,a4
     f3a:	0007871b          	sext.w	a4,a5
     f3e:	fe843783          	ld	a5,-24(s0)
     f42:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f44:	fe043783          	ld	a5,-32(s0)
     f48:	6398                	ld	a4,0(a5)
     f4a:	fe843783          	ld	a5,-24(s0)
     f4e:	e398                	sd	a4,0(a5)
     f50:	a031                	j	f5c <free+0x10c>
  } else
    p->s.ptr = bp;
     f52:	fe843783          	ld	a5,-24(s0)
     f56:	fe043703          	ld	a4,-32(s0)
     f5a:	e398                	sd	a4,0(a5)
  freep = p;
     f5c:	00002797          	auipc	a5,0x2
     f60:	8e478793          	addi	a5,a5,-1820 # 2840 <freep>
     f64:	fe843703          	ld	a4,-24(s0)
     f68:	e398                	sd	a4,0(a5)
}
     f6a:	0001                	nop
     f6c:	7422                	ld	s0,40(sp)
     f6e:	6145                	addi	sp,sp,48
     f70:	8082                	ret

0000000000000f72 <morecore>:

static Header*
morecore(uint nu)
{
     f72:	7179                	addi	sp,sp,-48
     f74:	f406                	sd	ra,40(sp)
     f76:	f022                	sd	s0,32(sp)
     f78:	1800                	addi	s0,sp,48
     f7a:	87aa                	mv	a5,a0
     f7c:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     f80:	fdc42783          	lw	a5,-36(s0)
     f84:	0007871b          	sext.w	a4,a5
     f88:	6785                	lui	a5,0x1
     f8a:	00f77563          	bgeu	a4,a5,f94 <morecore+0x22>
    nu = 4096;
     f8e:	6785                	lui	a5,0x1
     f90:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     f94:	fdc42783          	lw	a5,-36(s0)
     f98:	0047979b          	slliw	a5,a5,0x4
     f9c:	2781                	sext.w	a5,a5
     f9e:	2781                	sext.w	a5,a5
     fa0:	853e                	mv	a0,a5
     fa2:	00000097          	auipc	ra,0x0
     fa6:	9ae080e7          	jalr	-1618(ra) # 950 <sbrk>
     faa:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     fae:	fe843703          	ld	a4,-24(s0)
     fb2:	57fd                	li	a5,-1
     fb4:	00f71463          	bne	a4,a5,fbc <morecore+0x4a>
    return 0;
     fb8:	4781                	li	a5,0
     fba:	a03d                	j	fe8 <morecore+0x76>
  hp = (Header*)p;
     fbc:	fe843783          	ld	a5,-24(s0)
     fc0:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     fc4:	fe043783          	ld	a5,-32(s0)
     fc8:	fdc42703          	lw	a4,-36(s0)
     fcc:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     fce:	fe043783          	ld	a5,-32(s0)
     fd2:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x1e>
     fd4:	853e                	mv	a0,a5
     fd6:	00000097          	auipc	ra,0x0
     fda:	e7a080e7          	jalr	-390(ra) # e50 <free>
  return freep;
     fde:	00002797          	auipc	a5,0x2
     fe2:	86278793          	addi	a5,a5,-1950 # 2840 <freep>
     fe6:	639c                	ld	a5,0(a5)
}
     fe8:	853e                	mv	a0,a5
     fea:	70a2                	ld	ra,40(sp)
     fec:	7402                	ld	s0,32(sp)
     fee:	6145                	addi	sp,sp,48
     ff0:	8082                	ret

0000000000000ff2 <malloc>:

void*
malloc(uint nbytes)
{
     ff2:	7139                	addi	sp,sp,-64
     ff4:	fc06                	sd	ra,56(sp)
     ff6:	f822                	sd	s0,48(sp)
     ff8:	0080                	addi	s0,sp,64
     ffa:	87aa                	mv	a5,a0
     ffc:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1000:	fcc46783          	lwu	a5,-52(s0)
    1004:	07bd                	addi	a5,a5,15
    1006:	8391                	srli	a5,a5,0x4
    1008:	2781                	sext.w	a5,a5
    100a:	2785                	addiw	a5,a5,1
    100c:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    1010:	00002797          	auipc	a5,0x2
    1014:	83078793          	addi	a5,a5,-2000 # 2840 <freep>
    1018:	639c                	ld	a5,0(a5)
    101a:	fef43023          	sd	a5,-32(s0)
    101e:	fe043783          	ld	a5,-32(s0)
    1022:	ef95                	bnez	a5,105e <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    1024:	00002797          	auipc	a5,0x2
    1028:	80c78793          	addi	a5,a5,-2036 # 2830 <base>
    102c:	fef43023          	sd	a5,-32(s0)
    1030:	00002797          	auipc	a5,0x2
    1034:	81078793          	addi	a5,a5,-2032 # 2840 <freep>
    1038:	fe043703          	ld	a4,-32(s0)
    103c:	e398                	sd	a4,0(a5)
    103e:	00002797          	auipc	a5,0x2
    1042:	80278793          	addi	a5,a5,-2046 # 2840 <freep>
    1046:	6398                	ld	a4,0(a5)
    1048:	00001797          	auipc	a5,0x1
    104c:	7e878793          	addi	a5,a5,2024 # 2830 <base>
    1050:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    1052:	00001797          	auipc	a5,0x1
    1056:	7de78793          	addi	a5,a5,2014 # 2830 <base>
    105a:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    105e:	fe043783          	ld	a5,-32(s0)
    1062:	639c                	ld	a5,0(a5)
    1064:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1068:	fe843783          	ld	a5,-24(s0)
    106c:	4798                	lw	a4,8(a5)
    106e:	fdc42783          	lw	a5,-36(s0)
    1072:	2781                	sext.w	a5,a5
    1074:	06f76763          	bltu	a4,a5,10e2 <malloc+0xf0>
      if(p->s.size == nunits)
    1078:	fe843783          	ld	a5,-24(s0)
    107c:	4798                	lw	a4,8(a5)
    107e:	fdc42783          	lw	a5,-36(s0)
    1082:	2781                	sext.w	a5,a5
    1084:	00e79963          	bne	a5,a4,1096 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    1088:	fe843783          	ld	a5,-24(s0)
    108c:	6398                	ld	a4,0(a5)
    108e:	fe043783          	ld	a5,-32(s0)
    1092:	e398                	sd	a4,0(a5)
    1094:	a825                	j	10cc <malloc+0xda>
      else {
        p->s.size -= nunits;
    1096:	fe843783          	ld	a5,-24(s0)
    109a:	479c                	lw	a5,8(a5)
    109c:	fdc42703          	lw	a4,-36(s0)
    10a0:	9f99                	subw	a5,a5,a4
    10a2:	0007871b          	sext.w	a4,a5
    10a6:	fe843783          	ld	a5,-24(s0)
    10aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
    10ac:	fe843783          	ld	a5,-24(s0)
    10b0:	479c                	lw	a5,8(a5)
    10b2:	1782                	slli	a5,a5,0x20
    10b4:	9381                	srli	a5,a5,0x20
    10b6:	0792                	slli	a5,a5,0x4
    10b8:	fe843703          	ld	a4,-24(s0)
    10bc:	97ba                	add	a5,a5,a4
    10be:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    10c2:	fe843783          	ld	a5,-24(s0)
    10c6:	fdc42703          	lw	a4,-36(s0)
    10ca:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    10cc:	00001797          	auipc	a5,0x1
    10d0:	77478793          	addi	a5,a5,1908 # 2840 <freep>
    10d4:	fe043703          	ld	a4,-32(s0)
    10d8:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    10da:	fe843783          	ld	a5,-24(s0)
    10de:	07c1                	addi	a5,a5,16
    10e0:	a091                	j	1124 <malloc+0x132>
    }
    if(p == freep)
    10e2:	00001797          	auipc	a5,0x1
    10e6:	75e78793          	addi	a5,a5,1886 # 2840 <freep>
    10ea:	639c                	ld	a5,0(a5)
    10ec:	fe843703          	ld	a4,-24(s0)
    10f0:	02f71063          	bne	a4,a5,1110 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    10f4:	fdc42783          	lw	a5,-36(s0)
    10f8:	853e                	mv	a0,a5
    10fa:	00000097          	auipc	ra,0x0
    10fe:	e78080e7          	jalr	-392(ra) # f72 <morecore>
    1102:	fea43423          	sd	a0,-24(s0)
    1106:	fe843783          	ld	a5,-24(s0)
    110a:	e399                	bnez	a5,1110 <malloc+0x11e>
        return 0;
    110c:	4781                	li	a5,0
    110e:	a819                	j	1124 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1110:	fe843783          	ld	a5,-24(s0)
    1114:	fef43023          	sd	a5,-32(s0)
    1118:	fe843783          	ld	a5,-24(s0)
    111c:	639c                	ld	a5,0(a5)
    111e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1122:	b799                	j	1068 <malloc+0x76>
  }
}
    1124:	853e                	mv	a0,a5
    1126:	70e2                	ld	ra,56(sp)
    1128:	7442                	ld	s0,48(sp)
    112a:	6121                	addi	sp,sp,64
    112c:	8082                	ret
