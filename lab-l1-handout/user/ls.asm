
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	0080                	addi	s0,sp,64
       a:	fca43423          	sd	a0,-56(s0)
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
       e:	fc843503          	ld	a0,-56(s0)
      12:	00000097          	auipc	ra,0x0
      16:	45a080e7          	jalr	1114(ra) # 46c <strlen>
      1a:	87aa                	mv	a5,a0
      1c:	2781                	sext.w	a5,a5
      1e:	1782                	slli	a5,a5,0x20
      20:	9381                	srli	a5,a5,0x20
      22:	fc843703          	ld	a4,-56(s0)
      26:	97ba                	add	a5,a5,a4
      28:	fcf43c23          	sd	a5,-40(s0)
      2c:	a031                	j	38 <fmtname+0x38>
      2e:	fd843783          	ld	a5,-40(s0)
      32:	17fd                	addi	a5,a5,-1
      34:	fcf43c23          	sd	a5,-40(s0)
      38:	fd843703          	ld	a4,-40(s0)
      3c:	fc843783          	ld	a5,-56(s0)
      40:	00f76b63          	bltu	a4,a5,56 <fmtname+0x56>
      44:	fd843783          	ld	a5,-40(s0)
      48:	0007c783          	lbu	a5,0(a5)
      4c:	873e                	mv	a4,a5
      4e:	02f00793          	li	a5,47
      52:	fcf71ee3          	bne	a4,a5,2e <fmtname+0x2e>
    ;
  p++;
      56:	fd843783          	ld	a5,-40(s0)
      5a:	0785                	addi	a5,a5,1
      5c:	fcf43c23          	sd	a5,-40(s0)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
      60:	fd843503          	ld	a0,-40(s0)
      64:	00000097          	auipc	ra,0x0
      68:	408080e7          	jalr	1032(ra) # 46c <strlen>
      6c:	87aa                	mv	a5,a0
      6e:	2781                	sext.w	a5,a5
      70:	873e                	mv	a4,a5
      72:	47b5                	li	a5,13
      74:	00e7f563          	bgeu	a5,a4,7e <fmtname+0x7e>
    return p;
      78:	fd843783          	ld	a5,-40(s0)
      7c:	a8b5                	j	f8 <fmtname+0xf8>
  memmove(buf, p, strlen(p));
      7e:	fd843503          	ld	a0,-40(s0)
      82:	00000097          	auipc	ra,0x0
      86:	3ea080e7          	jalr	1002(ra) # 46c <strlen>
      8a:	87aa                	mv	a5,a0
      8c:	2781                	sext.w	a5,a5
      8e:	2781                	sext.w	a5,a5
      90:	863e                	mv	a2,a5
      92:	fd843583          	ld	a1,-40(s0)
      96:	00002517          	auipc	a0,0x2
      9a:	34a50513          	addi	a0,a0,842 # 23e0 <buf.0>
      9e:	00000097          	auipc	ra,0x0
      a2:	62a080e7          	jalr	1578(ra) # 6c8 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
      a6:	fd843503          	ld	a0,-40(s0)
      aa:	00000097          	auipc	ra,0x0
      ae:	3c2080e7          	jalr	962(ra) # 46c <strlen>
      b2:	87aa                	mv	a5,a0
      b4:	2781                	sext.w	a5,a5
      b6:	02079713          	slli	a4,a5,0x20
      ba:	9301                	srli	a4,a4,0x20
      bc:	00002797          	auipc	a5,0x2
      c0:	32478793          	addi	a5,a5,804 # 23e0 <buf.0>
      c4:	00f704b3          	add	s1,a4,a5
      c8:	fd843503          	ld	a0,-40(s0)
      cc:	00000097          	auipc	ra,0x0
      d0:	3a0080e7          	jalr	928(ra) # 46c <strlen>
      d4:	87aa                	mv	a5,a0
      d6:	2781                	sext.w	a5,a5
      d8:	4739                	li	a4,14
      da:	40f707bb          	subw	a5,a4,a5
      de:	2781                	sext.w	a5,a5
      e0:	863e                	mv	a2,a5
      e2:	02000593          	li	a1,32
      e6:	8526                	mv	a0,s1
      e8:	00000097          	auipc	ra,0x0
      ec:	3ba080e7          	jalr	954(ra) # 4a2 <memset>
  return buf;
      f0:	00002797          	auipc	a5,0x2
      f4:	2f078793          	addi	a5,a5,752 # 23e0 <buf.0>
}
      f8:	853e                	mv	a0,a5
      fa:	70e2                	ld	ra,56(sp)
      fc:	7442                	ld	s0,48(sp)
      fe:	74a2                	ld	s1,40(sp)
     100:	6121                	addi	sp,sp,64
     102:	8082                	ret

0000000000000104 <ls>:

void
ls(char *path)
{
     104:	da010113          	addi	sp,sp,-608
     108:	24113c23          	sd	ra,600(sp)
     10c:	24813823          	sd	s0,592(sp)
     110:	1480                	addi	s0,sp,608
     112:	daa43423          	sd	a0,-600(s0)
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
     116:	4581                	li	a1,0
     118:	da843503          	ld	a0,-600(s0)
     11c:	00000097          	auipc	ra,0x0
     120:	772080e7          	jalr	1906(ra) # 88e <open>
     124:	87aa                	mv	a5,a0
     126:	fef42623          	sw	a5,-20(s0)
     12a:	fec42783          	lw	a5,-20(s0)
     12e:	2781                	sext.w	a5,a5
     130:	0007de63          	bgez	a5,14c <ls+0x48>
    fprintf(2, "ls: cannot open %s\n", path);
     134:	da843603          	ld	a2,-600(s0)
     138:	00001597          	auipc	a1,0x1
     13c:	f8858593          	addi	a1,a1,-120 # 10c0 <malloc+0x148>
     140:	4509                	li	a0,2
     142:	00001097          	auipc	ra,0x1
     146:	bec080e7          	jalr	-1044(ra) # d2e <fprintf>
    return;
     14a:	a2e9                	j	314 <ls+0x210>
  }

  if(fstat(fd, &st) < 0){
     14c:	db840713          	addi	a4,s0,-584
     150:	fec42783          	lw	a5,-20(s0)
     154:	85ba                	mv	a1,a4
     156:	853e                	mv	a0,a5
     158:	00000097          	auipc	ra,0x0
     15c:	74e080e7          	jalr	1870(ra) # 8a6 <fstat>
     160:	87aa                	mv	a5,a0
     162:	0207d563          	bgez	a5,18c <ls+0x88>
    fprintf(2, "ls: cannot stat %s\n", path);
     166:	da843603          	ld	a2,-600(s0)
     16a:	00001597          	auipc	a1,0x1
     16e:	f6e58593          	addi	a1,a1,-146 # 10d8 <malloc+0x160>
     172:	4509                	li	a0,2
     174:	00001097          	auipc	ra,0x1
     178:	bba080e7          	jalr	-1094(ra) # d2e <fprintf>
    close(fd);
     17c:	fec42783          	lw	a5,-20(s0)
     180:	853e                	mv	a0,a5
     182:	00000097          	auipc	ra,0x0
     186:	6f4080e7          	jalr	1780(ra) # 876 <close>
    return;
     18a:	a269                	j	314 <ls+0x210>
  }

  switch(st.type){
     18c:	dc041783          	lh	a5,-576(s0)
     190:	873e                	mv	a4,a5
     192:	86ba                	mv	a3,a4
     194:	4785                	li	a5,1
     196:	04f68563          	beq	a3,a5,1e0 <ls+0xdc>
     19a:	87ba                	mv	a5,a4
     19c:	16f05563          	blez	a5,306 <ls+0x202>
     1a0:	0007079b          	sext.w	a5,a4
     1a4:	37f9                	addiw	a5,a5,-2
     1a6:	2781                	sext.w	a5,a5
     1a8:	873e                	mv	a4,a5
     1aa:	4785                	li	a5,1
     1ac:	14e7ed63          	bltu	a5,a4,306 <ls+0x202>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
     1b0:	da843503          	ld	a0,-600(s0)
     1b4:	00000097          	auipc	ra,0x0
     1b8:	e4c080e7          	jalr	-436(ra) # 0 <fmtname>
     1bc:	85aa                	mv	a1,a0
     1be:	dc041783          	lh	a5,-576(s0)
     1c2:	863e                	mv	a2,a5
     1c4:	dbc42783          	lw	a5,-580(s0)
     1c8:	dc843703          	ld	a4,-568(s0)
     1cc:	86be                	mv	a3,a5
     1ce:	00001517          	auipc	a0,0x1
     1d2:	f2250513          	addi	a0,a0,-222 # 10f0 <malloc+0x178>
     1d6:	00001097          	auipc	ra,0x1
     1da:	bb0080e7          	jalr	-1104(ra) # d86 <printf>
    break;
     1de:	a225                	j	306 <ls+0x202>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
     1e0:	da843503          	ld	a0,-600(s0)
     1e4:	00000097          	auipc	ra,0x0
     1e8:	288080e7          	jalr	648(ra) # 46c <strlen>
     1ec:	87aa                	mv	a5,a0
     1ee:	2781                	sext.w	a5,a5
     1f0:	27c1                	addiw	a5,a5,16
     1f2:	2781                	sext.w	a5,a5
     1f4:	873e                	mv	a4,a5
     1f6:	20000793          	li	a5,512
     1fa:	00e7fb63          	bgeu	a5,a4,210 <ls+0x10c>
      printf("ls: path too long\n");
     1fe:	00001517          	auipc	a0,0x1
     202:	f0250513          	addi	a0,a0,-254 # 1100 <malloc+0x188>
     206:	00001097          	auipc	ra,0x1
     20a:	b80080e7          	jalr	-1152(ra) # d86 <printf>
      break;
     20e:	a8e5                	j	306 <ls+0x202>
    }
    strcpy(buf, path);
     210:	de040793          	addi	a5,s0,-544
     214:	da843583          	ld	a1,-600(s0)
     218:	853e                	mv	a0,a5
     21a:	00000097          	auipc	ra,0x0
     21e:	1a2080e7          	jalr	418(ra) # 3bc <strcpy>
    p = buf+strlen(buf);
     222:	de040793          	addi	a5,s0,-544
     226:	853e                	mv	a0,a5
     228:	00000097          	auipc	ra,0x0
     22c:	244080e7          	jalr	580(ra) # 46c <strlen>
     230:	87aa                	mv	a5,a0
     232:	2781                	sext.w	a5,a5
     234:	1782                	slli	a5,a5,0x20
     236:	9381                	srli	a5,a5,0x20
     238:	de040713          	addi	a4,s0,-544
     23c:	97ba                	add	a5,a5,a4
     23e:	fef43023          	sd	a5,-32(s0)
    *p++ = '/';
     242:	fe043783          	ld	a5,-32(s0)
     246:	00178713          	addi	a4,a5,1
     24a:	fee43023          	sd	a4,-32(s0)
     24e:	02f00713          	li	a4,47
     252:	00e78023          	sb	a4,0(a5)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     256:	a079                	j	2e4 <ls+0x1e0>
      if(de.inum == 0)
     258:	dd045783          	lhu	a5,-560(s0)
     25c:	c3d9                	beqz	a5,2e2 <ls+0x1de>
        continue;
      memmove(p, de.name, DIRSIZ);
     25e:	dd040793          	addi	a5,s0,-560
     262:	0789                	addi	a5,a5,2
     264:	4639                	li	a2,14
     266:	85be                	mv	a1,a5
     268:	fe043503          	ld	a0,-32(s0)
     26c:	00000097          	auipc	ra,0x0
     270:	45c080e7          	jalr	1116(ra) # 6c8 <memmove>
      p[DIRSIZ] = 0;
     274:	fe043783          	ld	a5,-32(s0)
     278:	07b9                	addi	a5,a5,14
     27a:	00078023          	sb	zero,0(a5)
      if(stat(buf, &st) < 0){
     27e:	db840713          	addi	a4,s0,-584
     282:	de040793          	addi	a5,s0,-544
     286:	85ba                	mv	a1,a4
     288:	853e                	mv	a0,a5
     28a:	00000097          	auipc	ra,0x0
     28e:	364080e7          	jalr	868(ra) # 5ee <stat>
     292:	87aa                	mv	a5,a0
     294:	0007de63          	bgez	a5,2b0 <ls+0x1ac>
        printf("ls: cannot stat %s\n", buf);
     298:	de040793          	addi	a5,s0,-544
     29c:	85be                	mv	a1,a5
     29e:	00001517          	auipc	a0,0x1
     2a2:	e3a50513          	addi	a0,a0,-454 # 10d8 <malloc+0x160>
     2a6:	00001097          	auipc	ra,0x1
     2aa:	ae0080e7          	jalr	-1312(ra) # d86 <printf>
        continue;
     2ae:	a81d                	j	2e4 <ls+0x1e0>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
     2b0:	de040793          	addi	a5,s0,-544
     2b4:	853e                	mv	a0,a5
     2b6:	00000097          	auipc	ra,0x0
     2ba:	d4a080e7          	jalr	-694(ra) # 0 <fmtname>
     2be:	85aa                	mv	a1,a0
     2c0:	dc041783          	lh	a5,-576(s0)
     2c4:	863e                	mv	a2,a5
     2c6:	dbc42783          	lw	a5,-580(s0)
     2ca:	dc843703          	ld	a4,-568(s0)
     2ce:	86be                	mv	a3,a5
     2d0:	00001517          	auipc	a0,0x1
     2d4:	e4850513          	addi	a0,a0,-440 # 1118 <malloc+0x1a0>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	aae080e7          	jalr	-1362(ra) # d86 <printf>
     2e0:	a011                	j	2e4 <ls+0x1e0>
        continue;
     2e2:	0001                	nop
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     2e4:	dd040713          	addi	a4,s0,-560
     2e8:	fec42783          	lw	a5,-20(s0)
     2ec:	4641                	li	a2,16
     2ee:	85ba                	mv	a1,a4
     2f0:	853e                	mv	a0,a5
     2f2:	00000097          	auipc	ra,0x0
     2f6:	574080e7          	jalr	1396(ra) # 866 <read>
     2fa:	87aa                	mv	a5,a0
     2fc:	873e                	mv	a4,a5
     2fe:	47c1                	li	a5,16
     300:	f4f70ce3          	beq	a4,a5,258 <ls+0x154>
    }
    break;
     304:	0001                	nop
  }
  close(fd);
     306:	fec42783          	lw	a5,-20(s0)
     30a:	853e                	mv	a0,a5
     30c:	00000097          	auipc	ra,0x0
     310:	56a080e7          	jalr	1386(ra) # 876 <close>
}
     314:	25813083          	ld	ra,600(sp)
     318:	25013403          	ld	s0,592(sp)
     31c:	26010113          	addi	sp,sp,608
     320:	8082                	ret

0000000000000322 <main>:

int
main(int argc, char *argv[])
{
     322:	7179                	addi	sp,sp,-48
     324:	f406                	sd	ra,40(sp)
     326:	f022                	sd	s0,32(sp)
     328:	1800                	addi	s0,sp,48
     32a:	87aa                	mv	a5,a0
     32c:	fcb43823          	sd	a1,-48(s0)
     330:	fcf42e23          	sw	a5,-36(s0)
  int i;

  if(argc < 2){
     334:	fdc42783          	lw	a5,-36(s0)
     338:	0007871b          	sext.w	a4,a5
     33c:	4785                	li	a5,1
     33e:	00e7cf63          	blt	a5,a4,35c <main+0x3a>
    ls(".");
     342:	00001517          	auipc	a0,0x1
     346:	de650513          	addi	a0,a0,-538 # 1128 <malloc+0x1b0>
     34a:	00000097          	auipc	ra,0x0
     34e:	dba080e7          	jalr	-582(ra) # 104 <ls>
    exit(0);
     352:	4501                	li	a0,0
     354:	00000097          	auipc	ra,0x0
     358:	4fa080e7          	jalr	1274(ra) # 84e <exit>
  }
  for(i=1; i<argc; i++)
     35c:	4785                	li	a5,1
     35e:	fef42623          	sw	a5,-20(s0)
     362:	a015                	j	386 <main+0x64>
    ls(argv[i]);
     364:	fec42783          	lw	a5,-20(s0)
     368:	078e                	slli	a5,a5,0x3
     36a:	fd043703          	ld	a4,-48(s0)
     36e:	97ba                	add	a5,a5,a4
     370:	639c                	ld	a5,0(a5)
     372:	853e                	mv	a0,a5
     374:	00000097          	auipc	ra,0x0
     378:	d90080e7          	jalr	-624(ra) # 104 <ls>
  for(i=1; i<argc; i++)
     37c:	fec42783          	lw	a5,-20(s0)
     380:	2785                	addiw	a5,a5,1
     382:	fef42623          	sw	a5,-20(s0)
     386:	fec42783          	lw	a5,-20(s0)
     38a:	873e                	mv	a4,a5
     38c:	fdc42783          	lw	a5,-36(s0)
     390:	2701                	sext.w	a4,a4
     392:	2781                	sext.w	a5,a5
     394:	fcf748e3          	blt	a4,a5,364 <main+0x42>
  exit(0);
     398:	4501                	li	a0,0
     39a:	00000097          	auipc	ra,0x0
     39e:	4b4080e7          	jalr	1204(ra) # 84e <exit>

00000000000003a2 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     3a2:	1141                	addi	sp,sp,-16
     3a4:	e406                	sd	ra,8(sp)
     3a6:	e022                	sd	s0,0(sp)
     3a8:	0800                	addi	s0,sp,16
  extern int main();
  main();
     3aa:	00000097          	auipc	ra,0x0
     3ae:	f78080e7          	jalr	-136(ra) # 322 <main>
  exit(0);
     3b2:	4501                	li	a0,0
     3b4:	00000097          	auipc	ra,0x0
     3b8:	49a080e7          	jalr	1178(ra) # 84e <exit>

00000000000003bc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     3bc:	7179                	addi	sp,sp,-48
     3be:	f422                	sd	s0,40(sp)
     3c0:	1800                	addi	s0,sp,48
     3c2:	fca43c23          	sd	a0,-40(s0)
     3c6:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     3ca:	fd843783          	ld	a5,-40(s0)
     3ce:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     3d2:	0001                	nop
     3d4:	fd043703          	ld	a4,-48(s0)
     3d8:	00170793          	addi	a5,a4,1
     3dc:	fcf43823          	sd	a5,-48(s0)
     3e0:	fd843783          	ld	a5,-40(s0)
     3e4:	00178693          	addi	a3,a5,1
     3e8:	fcd43c23          	sd	a3,-40(s0)
     3ec:	00074703          	lbu	a4,0(a4)
     3f0:	00e78023          	sb	a4,0(a5)
     3f4:	0007c783          	lbu	a5,0(a5)
     3f8:	fff1                	bnez	a5,3d4 <strcpy+0x18>
    ;
  return os;
     3fa:	fe843783          	ld	a5,-24(s0)
}
     3fe:	853e                	mv	a0,a5
     400:	7422                	ld	s0,40(sp)
     402:	6145                	addi	sp,sp,48
     404:	8082                	ret

0000000000000406 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     406:	1101                	addi	sp,sp,-32
     408:	ec22                	sd	s0,24(sp)
     40a:	1000                	addi	s0,sp,32
     40c:	fea43423          	sd	a0,-24(s0)
     410:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     414:	a819                	j	42a <strcmp+0x24>
    p++, q++;
     416:	fe843783          	ld	a5,-24(s0)
     41a:	0785                	addi	a5,a5,1
     41c:	fef43423          	sd	a5,-24(s0)
     420:	fe043783          	ld	a5,-32(s0)
     424:	0785                	addi	a5,a5,1
     426:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
     42a:	fe843783          	ld	a5,-24(s0)
     42e:	0007c783          	lbu	a5,0(a5)
     432:	cb99                	beqz	a5,448 <strcmp+0x42>
     434:	fe843783          	ld	a5,-24(s0)
     438:	0007c703          	lbu	a4,0(a5)
     43c:	fe043783          	ld	a5,-32(s0)
     440:	0007c783          	lbu	a5,0(a5)
     444:	fcf709e3          	beq	a4,a5,416 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
     448:	fe843783          	ld	a5,-24(s0)
     44c:	0007c783          	lbu	a5,0(a5)
     450:	0007871b          	sext.w	a4,a5
     454:	fe043783          	ld	a5,-32(s0)
     458:	0007c783          	lbu	a5,0(a5)
     45c:	2781                	sext.w	a5,a5
     45e:	40f707bb          	subw	a5,a4,a5
     462:	2781                	sext.w	a5,a5
}
     464:	853e                	mv	a0,a5
     466:	6462                	ld	s0,24(sp)
     468:	6105                	addi	sp,sp,32
     46a:	8082                	ret

000000000000046c <strlen>:

uint
strlen(const char *s)
{
     46c:	7179                	addi	sp,sp,-48
     46e:	f422                	sd	s0,40(sp)
     470:	1800                	addi	s0,sp,48
     472:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
     476:	fe042623          	sw	zero,-20(s0)
     47a:	a031                	j	486 <strlen+0x1a>
     47c:	fec42783          	lw	a5,-20(s0)
     480:	2785                	addiw	a5,a5,1
     482:	fef42623          	sw	a5,-20(s0)
     486:	fec42783          	lw	a5,-20(s0)
     48a:	fd843703          	ld	a4,-40(s0)
     48e:	97ba                	add	a5,a5,a4
     490:	0007c783          	lbu	a5,0(a5)
     494:	f7e5                	bnez	a5,47c <strlen+0x10>
    ;
  return n;
     496:	fec42783          	lw	a5,-20(s0)
}
     49a:	853e                	mv	a0,a5
     49c:	7422                	ld	s0,40(sp)
     49e:	6145                	addi	sp,sp,48
     4a0:	8082                	ret

00000000000004a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     4a2:	7179                	addi	sp,sp,-48
     4a4:	f422                	sd	s0,40(sp)
     4a6:	1800                	addi	s0,sp,48
     4a8:	fca43c23          	sd	a0,-40(s0)
     4ac:	87ae                	mv	a5,a1
     4ae:	8732                	mv	a4,a2
     4b0:	fcf42a23          	sw	a5,-44(s0)
     4b4:	87ba                	mv	a5,a4
     4b6:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
     4ba:	fd843783          	ld	a5,-40(s0)
     4be:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
     4c2:	fe042623          	sw	zero,-20(s0)
     4c6:	a00d                	j	4e8 <memset+0x46>
    cdst[i] = c;
     4c8:	fec42783          	lw	a5,-20(s0)
     4cc:	fe043703          	ld	a4,-32(s0)
     4d0:	97ba                	add	a5,a5,a4
     4d2:	fd442703          	lw	a4,-44(s0)
     4d6:	0ff77713          	zext.b	a4,a4
     4da:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
     4de:	fec42783          	lw	a5,-20(s0)
     4e2:	2785                	addiw	a5,a5,1
     4e4:	fef42623          	sw	a5,-20(s0)
     4e8:	fec42703          	lw	a4,-20(s0)
     4ec:	fd042783          	lw	a5,-48(s0)
     4f0:	2781                	sext.w	a5,a5
     4f2:	fcf76be3          	bltu	a4,a5,4c8 <memset+0x26>
  }
  return dst;
     4f6:	fd843783          	ld	a5,-40(s0)
}
     4fa:	853e                	mv	a0,a5
     4fc:	7422                	ld	s0,40(sp)
     4fe:	6145                	addi	sp,sp,48
     500:	8082                	ret

0000000000000502 <strchr>:

char*
strchr(const char *s, char c)
{
     502:	1101                	addi	sp,sp,-32
     504:	ec22                	sd	s0,24(sp)
     506:	1000                	addi	s0,sp,32
     508:	fea43423          	sd	a0,-24(s0)
     50c:	87ae                	mv	a5,a1
     50e:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
     512:	a01d                	j	538 <strchr+0x36>
    if(*s == c)
     514:	fe843783          	ld	a5,-24(s0)
     518:	0007c703          	lbu	a4,0(a5)
     51c:	fe744783          	lbu	a5,-25(s0)
     520:	0ff7f793          	zext.b	a5,a5
     524:	00e79563          	bne	a5,a4,52e <strchr+0x2c>
      return (char*)s;
     528:	fe843783          	ld	a5,-24(s0)
     52c:	a821                	j	544 <strchr+0x42>
  for(; *s; s++)
     52e:	fe843783          	ld	a5,-24(s0)
     532:	0785                	addi	a5,a5,1
     534:	fef43423          	sd	a5,-24(s0)
     538:	fe843783          	ld	a5,-24(s0)
     53c:	0007c783          	lbu	a5,0(a5)
     540:	fbf1                	bnez	a5,514 <strchr+0x12>
  return 0;
     542:	4781                	li	a5,0
}
     544:	853e                	mv	a0,a5
     546:	6462                	ld	s0,24(sp)
     548:	6105                	addi	sp,sp,32
     54a:	8082                	ret

000000000000054c <gets>:

char*
gets(char *buf, int max)
{
     54c:	7179                	addi	sp,sp,-48
     54e:	f406                	sd	ra,40(sp)
     550:	f022                	sd	s0,32(sp)
     552:	1800                	addi	s0,sp,48
     554:	fca43c23          	sd	a0,-40(s0)
     558:	87ae                	mv	a5,a1
     55a:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     55e:	fe042623          	sw	zero,-20(s0)
     562:	a8a1                	j	5ba <gets+0x6e>
    cc = read(0, &c, 1);
     564:	fe740793          	addi	a5,s0,-25
     568:	4605                	li	a2,1
     56a:	85be                	mv	a1,a5
     56c:	4501                	li	a0,0
     56e:	00000097          	auipc	ra,0x0
     572:	2f8080e7          	jalr	760(ra) # 866 <read>
     576:	87aa                	mv	a5,a0
     578:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
     57c:	fe842783          	lw	a5,-24(s0)
     580:	2781                	sext.w	a5,a5
     582:	04f05763          	blez	a5,5d0 <gets+0x84>
      break;
    buf[i++] = c;
     586:	fec42783          	lw	a5,-20(s0)
     58a:	0017871b          	addiw	a4,a5,1
     58e:	fee42623          	sw	a4,-20(s0)
     592:	873e                	mv	a4,a5
     594:	fd843783          	ld	a5,-40(s0)
     598:	97ba                	add	a5,a5,a4
     59a:	fe744703          	lbu	a4,-25(s0)
     59e:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
     5a2:	fe744783          	lbu	a5,-25(s0)
     5a6:	873e                	mv	a4,a5
     5a8:	47a9                	li	a5,10
     5aa:	02f70463          	beq	a4,a5,5d2 <gets+0x86>
     5ae:	fe744783          	lbu	a5,-25(s0)
     5b2:	873e                	mv	a4,a5
     5b4:	47b5                	li	a5,13
     5b6:	00f70e63          	beq	a4,a5,5d2 <gets+0x86>
  for(i=0; i+1 < max; ){
     5ba:	fec42783          	lw	a5,-20(s0)
     5be:	2785                	addiw	a5,a5,1
     5c0:	0007871b          	sext.w	a4,a5
     5c4:	fd442783          	lw	a5,-44(s0)
     5c8:	2781                	sext.w	a5,a5
     5ca:	f8f74de3          	blt	a4,a5,564 <gets+0x18>
     5ce:	a011                	j	5d2 <gets+0x86>
      break;
     5d0:	0001                	nop
      break;
  }
  buf[i] = '\0';
     5d2:	fec42783          	lw	a5,-20(s0)
     5d6:	fd843703          	ld	a4,-40(s0)
     5da:	97ba                	add	a5,a5,a4
     5dc:	00078023          	sb	zero,0(a5)
  return buf;
     5e0:	fd843783          	ld	a5,-40(s0)
}
     5e4:	853e                	mv	a0,a5
     5e6:	70a2                	ld	ra,40(sp)
     5e8:	7402                	ld	s0,32(sp)
     5ea:	6145                	addi	sp,sp,48
     5ec:	8082                	ret

00000000000005ee <stat>:

int
stat(const char *n, struct stat *st)
{
     5ee:	7179                	addi	sp,sp,-48
     5f0:	f406                	sd	ra,40(sp)
     5f2:	f022                	sd	s0,32(sp)
     5f4:	1800                	addi	s0,sp,48
     5f6:	fca43c23          	sd	a0,-40(s0)
     5fa:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     5fe:	4581                	li	a1,0
     600:	fd843503          	ld	a0,-40(s0)
     604:	00000097          	auipc	ra,0x0
     608:	28a080e7          	jalr	650(ra) # 88e <open>
     60c:	87aa                	mv	a5,a0
     60e:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
     612:	fec42783          	lw	a5,-20(s0)
     616:	2781                	sext.w	a5,a5
     618:	0007d463          	bgez	a5,620 <stat+0x32>
    return -1;
     61c:	57fd                	li	a5,-1
     61e:	a035                	j	64a <stat+0x5c>
  r = fstat(fd, st);
     620:	fec42783          	lw	a5,-20(s0)
     624:	fd043583          	ld	a1,-48(s0)
     628:	853e                	mv	a0,a5
     62a:	00000097          	auipc	ra,0x0
     62e:	27c080e7          	jalr	636(ra) # 8a6 <fstat>
     632:	87aa                	mv	a5,a0
     634:	fef42423          	sw	a5,-24(s0)
  close(fd);
     638:	fec42783          	lw	a5,-20(s0)
     63c:	853e                	mv	a0,a5
     63e:	00000097          	auipc	ra,0x0
     642:	238080e7          	jalr	568(ra) # 876 <close>
  return r;
     646:	fe842783          	lw	a5,-24(s0)
}
     64a:	853e                	mv	a0,a5
     64c:	70a2                	ld	ra,40(sp)
     64e:	7402                	ld	s0,32(sp)
     650:	6145                	addi	sp,sp,48
     652:	8082                	ret

0000000000000654 <atoi>:

int
atoi(const char *s)
{
     654:	7179                	addi	sp,sp,-48
     656:	f422                	sd	s0,40(sp)
     658:	1800                	addi	s0,sp,48
     65a:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
     65e:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
     662:	a81d                	j	698 <atoi+0x44>
    n = n*10 + *s++ - '0';
     664:	fec42783          	lw	a5,-20(s0)
     668:	873e                	mv	a4,a5
     66a:	87ba                	mv	a5,a4
     66c:	0027979b          	slliw	a5,a5,0x2
     670:	9fb9                	addw	a5,a5,a4
     672:	0017979b          	slliw	a5,a5,0x1
     676:	0007871b          	sext.w	a4,a5
     67a:	fd843783          	ld	a5,-40(s0)
     67e:	00178693          	addi	a3,a5,1
     682:	fcd43c23          	sd	a3,-40(s0)
     686:	0007c783          	lbu	a5,0(a5)
     68a:	2781                	sext.w	a5,a5
     68c:	9fb9                	addw	a5,a5,a4
     68e:	2781                	sext.w	a5,a5
     690:	fd07879b          	addiw	a5,a5,-48
     694:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
     698:	fd843783          	ld	a5,-40(s0)
     69c:	0007c783          	lbu	a5,0(a5)
     6a0:	873e                	mv	a4,a5
     6a2:	02f00793          	li	a5,47
     6a6:	00e7fb63          	bgeu	a5,a4,6bc <atoi+0x68>
     6aa:	fd843783          	ld	a5,-40(s0)
     6ae:	0007c783          	lbu	a5,0(a5)
     6b2:	873e                	mv	a4,a5
     6b4:	03900793          	li	a5,57
     6b8:	fae7f6e3          	bgeu	a5,a4,664 <atoi+0x10>
  return n;
     6bc:	fec42783          	lw	a5,-20(s0)
}
     6c0:	853e                	mv	a0,a5
     6c2:	7422                	ld	s0,40(sp)
     6c4:	6145                	addi	sp,sp,48
     6c6:	8082                	ret

00000000000006c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     6c8:	7139                	addi	sp,sp,-64
     6ca:	fc22                	sd	s0,56(sp)
     6cc:	0080                	addi	s0,sp,64
     6ce:	fca43c23          	sd	a0,-40(s0)
     6d2:	fcb43823          	sd	a1,-48(s0)
     6d6:	87b2                	mv	a5,a2
     6d8:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
     6dc:	fd843783          	ld	a5,-40(s0)
     6e0:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
     6e4:	fd043783          	ld	a5,-48(s0)
     6e8:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
     6ec:	fe043703          	ld	a4,-32(s0)
     6f0:	fe843783          	ld	a5,-24(s0)
     6f4:	02e7fc63          	bgeu	a5,a4,72c <memmove+0x64>
    while(n-- > 0)
     6f8:	a00d                	j	71a <memmove+0x52>
      *dst++ = *src++;
     6fa:	fe043703          	ld	a4,-32(s0)
     6fe:	00170793          	addi	a5,a4,1
     702:	fef43023          	sd	a5,-32(s0)
     706:	fe843783          	ld	a5,-24(s0)
     70a:	00178693          	addi	a3,a5,1
     70e:	fed43423          	sd	a3,-24(s0)
     712:	00074703          	lbu	a4,0(a4)
     716:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     71a:	fcc42783          	lw	a5,-52(s0)
     71e:	fff7871b          	addiw	a4,a5,-1
     722:	fce42623          	sw	a4,-52(s0)
     726:	fcf04ae3          	bgtz	a5,6fa <memmove+0x32>
     72a:	a891                	j	77e <memmove+0xb6>
  } else {
    dst += n;
     72c:	fcc42783          	lw	a5,-52(s0)
     730:	fe843703          	ld	a4,-24(s0)
     734:	97ba                	add	a5,a5,a4
     736:	fef43423          	sd	a5,-24(s0)
    src += n;
     73a:	fcc42783          	lw	a5,-52(s0)
     73e:	fe043703          	ld	a4,-32(s0)
     742:	97ba                	add	a5,a5,a4
     744:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
     748:	a01d                	j	76e <memmove+0xa6>
      *--dst = *--src;
     74a:	fe043783          	ld	a5,-32(s0)
     74e:	17fd                	addi	a5,a5,-1
     750:	fef43023          	sd	a5,-32(s0)
     754:	fe843783          	ld	a5,-24(s0)
     758:	17fd                	addi	a5,a5,-1
     75a:	fef43423          	sd	a5,-24(s0)
     75e:	fe043783          	ld	a5,-32(s0)
     762:	0007c703          	lbu	a4,0(a5)
     766:	fe843783          	ld	a5,-24(s0)
     76a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     76e:	fcc42783          	lw	a5,-52(s0)
     772:	fff7871b          	addiw	a4,a5,-1
     776:	fce42623          	sw	a4,-52(s0)
     77a:	fcf048e3          	bgtz	a5,74a <memmove+0x82>
  }
  return vdst;
     77e:	fd843783          	ld	a5,-40(s0)
}
     782:	853e                	mv	a0,a5
     784:	7462                	ld	s0,56(sp)
     786:	6121                	addi	sp,sp,64
     788:	8082                	ret

000000000000078a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     78a:	7139                	addi	sp,sp,-64
     78c:	fc22                	sd	s0,56(sp)
     78e:	0080                	addi	s0,sp,64
     790:	fca43c23          	sd	a0,-40(s0)
     794:	fcb43823          	sd	a1,-48(s0)
     798:	87b2                	mv	a5,a2
     79a:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
     79e:	fd843783          	ld	a5,-40(s0)
     7a2:	fef43423          	sd	a5,-24(s0)
     7a6:	fd043783          	ld	a5,-48(s0)
     7aa:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     7ae:	a0a1                	j	7f6 <memcmp+0x6c>
    if (*p1 != *p2) {
     7b0:	fe843783          	ld	a5,-24(s0)
     7b4:	0007c703          	lbu	a4,0(a5)
     7b8:	fe043783          	ld	a5,-32(s0)
     7bc:	0007c783          	lbu	a5,0(a5)
     7c0:	02f70163          	beq	a4,a5,7e2 <memcmp+0x58>
      return *p1 - *p2;
     7c4:	fe843783          	ld	a5,-24(s0)
     7c8:	0007c783          	lbu	a5,0(a5)
     7cc:	0007871b          	sext.w	a4,a5
     7d0:	fe043783          	ld	a5,-32(s0)
     7d4:	0007c783          	lbu	a5,0(a5)
     7d8:	2781                	sext.w	a5,a5
     7da:	40f707bb          	subw	a5,a4,a5
     7de:	2781                	sext.w	a5,a5
     7e0:	a01d                	j	806 <memcmp+0x7c>
    }
    p1++;
     7e2:	fe843783          	ld	a5,-24(s0)
     7e6:	0785                	addi	a5,a5,1
     7e8:	fef43423          	sd	a5,-24(s0)
    p2++;
     7ec:	fe043783          	ld	a5,-32(s0)
     7f0:	0785                	addi	a5,a5,1
     7f2:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     7f6:	fcc42783          	lw	a5,-52(s0)
     7fa:	fff7871b          	addiw	a4,a5,-1
     7fe:	fce42623          	sw	a4,-52(s0)
     802:	f7dd                	bnez	a5,7b0 <memcmp+0x26>
  }
  return 0;
     804:	4781                	li	a5,0
}
     806:	853e                	mv	a0,a5
     808:	7462                	ld	s0,56(sp)
     80a:	6121                	addi	sp,sp,64
     80c:	8082                	ret

000000000000080e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     80e:	7179                	addi	sp,sp,-48
     810:	f406                	sd	ra,40(sp)
     812:	f022                	sd	s0,32(sp)
     814:	1800                	addi	s0,sp,48
     816:	fea43423          	sd	a0,-24(s0)
     81a:	feb43023          	sd	a1,-32(s0)
     81e:	87b2                	mv	a5,a2
     820:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
     824:	fdc42783          	lw	a5,-36(s0)
     828:	863e                	mv	a2,a5
     82a:	fe043583          	ld	a1,-32(s0)
     82e:	fe843503          	ld	a0,-24(s0)
     832:	00000097          	auipc	ra,0x0
     836:	e96080e7          	jalr	-362(ra) # 6c8 <memmove>
     83a:	87aa                	mv	a5,a0
}
     83c:	853e                	mv	a0,a5
     83e:	70a2                	ld	ra,40(sp)
     840:	7402                	ld	s0,32(sp)
     842:	6145                	addi	sp,sp,48
     844:	8082                	ret

0000000000000846 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     846:	4885                	li	a7,1
 ecall
     848:	00000073          	ecall
 ret
     84c:	8082                	ret

000000000000084e <exit>:
.global exit
exit:
 li a7, SYS_exit
     84e:	4889                	li	a7,2
 ecall
     850:	00000073          	ecall
 ret
     854:	8082                	ret

0000000000000856 <wait>:
.global wait
wait:
 li a7, SYS_wait
     856:	488d                	li	a7,3
 ecall
     858:	00000073          	ecall
 ret
     85c:	8082                	ret

000000000000085e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     85e:	4891                	li	a7,4
 ecall
     860:	00000073          	ecall
 ret
     864:	8082                	ret

0000000000000866 <read>:
.global read
read:
 li a7, SYS_read
     866:	4895                	li	a7,5
 ecall
     868:	00000073          	ecall
 ret
     86c:	8082                	ret

000000000000086e <write>:
.global write
write:
 li a7, SYS_write
     86e:	48c1                	li	a7,16
 ecall
     870:	00000073          	ecall
 ret
     874:	8082                	ret

0000000000000876 <close>:
.global close
close:
 li a7, SYS_close
     876:	48d5                	li	a7,21
 ecall
     878:	00000073          	ecall
 ret
     87c:	8082                	ret

000000000000087e <kill>:
.global kill
kill:
 li a7, SYS_kill
     87e:	4899                	li	a7,6
 ecall
     880:	00000073          	ecall
 ret
     884:	8082                	ret

0000000000000886 <exec>:
.global exec
exec:
 li a7, SYS_exec
     886:	489d                	li	a7,7
 ecall
     888:	00000073          	ecall
 ret
     88c:	8082                	ret

000000000000088e <open>:
.global open
open:
 li a7, SYS_open
     88e:	48bd                	li	a7,15
 ecall
     890:	00000073          	ecall
 ret
     894:	8082                	ret

0000000000000896 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     896:	48c5                	li	a7,17
 ecall
     898:	00000073          	ecall
 ret
     89c:	8082                	ret

000000000000089e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     89e:	48c9                	li	a7,18
 ecall
     8a0:	00000073          	ecall
 ret
     8a4:	8082                	ret

00000000000008a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     8a6:	48a1                	li	a7,8
 ecall
     8a8:	00000073          	ecall
 ret
     8ac:	8082                	ret

00000000000008ae <link>:
.global link
link:
 li a7, SYS_link
     8ae:	48cd                	li	a7,19
 ecall
     8b0:	00000073          	ecall
 ret
     8b4:	8082                	ret

00000000000008b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     8b6:	48d1                	li	a7,20
 ecall
     8b8:	00000073          	ecall
 ret
     8bc:	8082                	ret

00000000000008be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     8be:	48a5                	li	a7,9
 ecall
     8c0:	00000073          	ecall
 ret
     8c4:	8082                	ret

00000000000008c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     8c6:	48a9                	li	a7,10
 ecall
     8c8:	00000073          	ecall
 ret
     8cc:	8082                	ret

00000000000008ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     8ce:	48ad                	li	a7,11
 ecall
     8d0:	00000073          	ecall
 ret
     8d4:	8082                	ret

00000000000008d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     8d6:	48b1                	li	a7,12
 ecall
     8d8:	00000073          	ecall
 ret
     8dc:	8082                	ret

00000000000008de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     8de:	48b5                	li	a7,13
 ecall
     8e0:	00000073          	ecall
 ret
     8e4:	8082                	ret

00000000000008e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     8e6:	48b9                	li	a7,14
 ecall
     8e8:	00000073          	ecall
 ret
     8ec:	8082                	ret

00000000000008ee <hello>:
.global hello
hello:
 li a7, SYS_hello
     8ee:	48d9                	li	a7,22
 ecall
     8f0:	00000073          	ecall
 ret
     8f4:	8082                	ret

00000000000008f6 <get_process>:
.global get_process
get_process:
 li a7, SYS_get_process
     8f6:	48dd                	li	a7,23
 ecall
     8f8:	00000073          	ecall
 ret
     8fc:	8082                	ret

00000000000008fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     8fe:	1101                	addi	sp,sp,-32
     900:	ec06                	sd	ra,24(sp)
     902:	e822                	sd	s0,16(sp)
     904:	1000                	addi	s0,sp,32
     906:	87aa                	mv	a5,a0
     908:	872e                	mv	a4,a1
     90a:	fef42623          	sw	a5,-20(s0)
     90e:	87ba                	mv	a5,a4
     910:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     914:	feb40713          	addi	a4,s0,-21
     918:	fec42783          	lw	a5,-20(s0)
     91c:	4605                	li	a2,1
     91e:	85ba                	mv	a1,a4
     920:	853e                	mv	a0,a5
     922:	00000097          	auipc	ra,0x0
     926:	f4c080e7          	jalr	-180(ra) # 86e <write>
}
     92a:	0001                	nop
     92c:	60e2                	ld	ra,24(sp)
     92e:	6442                	ld	s0,16(sp)
     930:	6105                	addi	sp,sp,32
     932:	8082                	ret

0000000000000934 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     934:	7139                	addi	sp,sp,-64
     936:	fc06                	sd	ra,56(sp)
     938:	f822                	sd	s0,48(sp)
     93a:	0080                	addi	s0,sp,64
     93c:	87aa                	mv	a5,a0
     93e:	8736                	mv	a4,a3
     940:	fcf42623          	sw	a5,-52(s0)
     944:	87ae                	mv	a5,a1
     946:	fcf42423          	sw	a5,-56(s0)
     94a:	87b2                	mv	a5,a2
     94c:	fcf42223          	sw	a5,-60(s0)
     950:	87ba                	mv	a5,a4
     952:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     956:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     95a:	fc042783          	lw	a5,-64(s0)
     95e:	2781                	sext.w	a5,a5
     960:	c38d                	beqz	a5,982 <printint+0x4e>
     962:	fc842783          	lw	a5,-56(s0)
     966:	2781                	sext.w	a5,a5
     968:	0007dd63          	bgez	a5,982 <printint+0x4e>
    neg = 1;
     96c:	4785                	li	a5,1
     96e:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     972:	fc842783          	lw	a5,-56(s0)
     976:	40f007bb          	negw	a5,a5
     97a:	2781                	sext.w	a5,a5
     97c:	fef42223          	sw	a5,-28(s0)
     980:	a029                	j	98a <printint+0x56>
  } else {
    x = xx;
     982:	fc842783          	lw	a5,-56(s0)
     986:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     98a:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     98e:	fc442783          	lw	a5,-60(s0)
     992:	fe442703          	lw	a4,-28(s0)
     996:	02f777bb          	remuw	a5,a4,a5
     99a:	0007861b          	sext.w	a2,a5
     99e:	fec42783          	lw	a5,-20(s0)
     9a2:	0017871b          	addiw	a4,a5,1
     9a6:	fee42623          	sw	a4,-20(s0)
     9aa:	00002697          	auipc	a3,0x2
     9ae:	a1668693          	addi	a3,a3,-1514 # 23c0 <digits>
     9b2:	02061713          	slli	a4,a2,0x20
     9b6:	9301                	srli	a4,a4,0x20
     9b8:	9736                	add	a4,a4,a3
     9ba:	00074703          	lbu	a4,0(a4)
     9be:	17c1                	addi	a5,a5,-16
     9c0:	97a2                	add	a5,a5,s0
     9c2:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     9c6:	fc442783          	lw	a5,-60(s0)
     9ca:	fe442703          	lw	a4,-28(s0)
     9ce:	02f757bb          	divuw	a5,a4,a5
     9d2:	fef42223          	sw	a5,-28(s0)
     9d6:	fe442783          	lw	a5,-28(s0)
     9da:	2781                	sext.w	a5,a5
     9dc:	fbcd                	bnez	a5,98e <printint+0x5a>
  if(neg)
     9de:	fe842783          	lw	a5,-24(s0)
     9e2:	2781                	sext.w	a5,a5
     9e4:	cf85                	beqz	a5,a1c <printint+0xe8>
    buf[i++] = '-';
     9e6:	fec42783          	lw	a5,-20(s0)
     9ea:	0017871b          	addiw	a4,a5,1
     9ee:	fee42623          	sw	a4,-20(s0)
     9f2:	17c1                	addi	a5,a5,-16
     9f4:	97a2                	add	a5,a5,s0
     9f6:	02d00713          	li	a4,45
     9fa:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     9fe:	a839                	j	a1c <printint+0xe8>
    putc(fd, buf[i]);
     a00:	fec42783          	lw	a5,-20(s0)
     a04:	17c1                	addi	a5,a5,-16
     a06:	97a2                	add	a5,a5,s0
     a08:	fe07c703          	lbu	a4,-32(a5)
     a0c:	fcc42783          	lw	a5,-52(s0)
     a10:	85ba                	mv	a1,a4
     a12:	853e                	mv	a0,a5
     a14:	00000097          	auipc	ra,0x0
     a18:	eea080e7          	jalr	-278(ra) # 8fe <putc>
  while(--i >= 0)
     a1c:	fec42783          	lw	a5,-20(s0)
     a20:	37fd                	addiw	a5,a5,-1
     a22:	fef42623          	sw	a5,-20(s0)
     a26:	fec42783          	lw	a5,-20(s0)
     a2a:	2781                	sext.w	a5,a5
     a2c:	fc07dae3          	bgez	a5,a00 <printint+0xcc>
}
     a30:	0001                	nop
     a32:	0001                	nop
     a34:	70e2                	ld	ra,56(sp)
     a36:	7442                	ld	s0,48(sp)
     a38:	6121                	addi	sp,sp,64
     a3a:	8082                	ret

0000000000000a3c <printptr>:

static void
printptr(int fd, uint64 x) {
     a3c:	7179                	addi	sp,sp,-48
     a3e:	f406                	sd	ra,40(sp)
     a40:	f022                	sd	s0,32(sp)
     a42:	1800                	addi	s0,sp,48
     a44:	87aa                	mv	a5,a0
     a46:	fcb43823          	sd	a1,-48(s0)
     a4a:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     a4e:	fdc42783          	lw	a5,-36(s0)
     a52:	03000593          	li	a1,48
     a56:	853e                	mv	a0,a5
     a58:	00000097          	auipc	ra,0x0
     a5c:	ea6080e7          	jalr	-346(ra) # 8fe <putc>
  putc(fd, 'x');
     a60:	fdc42783          	lw	a5,-36(s0)
     a64:	07800593          	li	a1,120
     a68:	853e                	mv	a0,a5
     a6a:	00000097          	auipc	ra,0x0
     a6e:	e94080e7          	jalr	-364(ra) # 8fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a72:	fe042623          	sw	zero,-20(s0)
     a76:	a82d                	j	ab0 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     a78:	fd043783          	ld	a5,-48(s0)
     a7c:	93f1                	srli	a5,a5,0x3c
     a7e:	00002717          	auipc	a4,0x2
     a82:	94270713          	addi	a4,a4,-1726 # 23c0 <digits>
     a86:	97ba                	add	a5,a5,a4
     a88:	0007c703          	lbu	a4,0(a5)
     a8c:	fdc42783          	lw	a5,-36(s0)
     a90:	85ba                	mv	a1,a4
     a92:	853e                	mv	a0,a5
     a94:	00000097          	auipc	ra,0x0
     a98:	e6a080e7          	jalr	-406(ra) # 8fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a9c:	fec42783          	lw	a5,-20(s0)
     aa0:	2785                	addiw	a5,a5,1
     aa2:	fef42623          	sw	a5,-20(s0)
     aa6:	fd043783          	ld	a5,-48(s0)
     aaa:	0792                	slli	a5,a5,0x4
     aac:	fcf43823          	sd	a5,-48(s0)
     ab0:	fec42783          	lw	a5,-20(s0)
     ab4:	873e                	mv	a4,a5
     ab6:	47bd                	li	a5,15
     ab8:	fce7f0e3          	bgeu	a5,a4,a78 <printptr+0x3c>
}
     abc:	0001                	nop
     abe:	0001                	nop
     ac0:	70a2                	ld	ra,40(sp)
     ac2:	7402                	ld	s0,32(sp)
     ac4:	6145                	addi	sp,sp,48
     ac6:	8082                	ret

0000000000000ac8 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ac8:	715d                	addi	sp,sp,-80
     aca:	e486                	sd	ra,72(sp)
     acc:	e0a2                	sd	s0,64(sp)
     ace:	0880                	addi	s0,sp,80
     ad0:	87aa                	mv	a5,a0
     ad2:	fcb43023          	sd	a1,-64(s0)
     ad6:	fac43c23          	sd	a2,-72(s0)
     ada:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     ade:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     ae2:	fe042223          	sw	zero,-28(s0)
     ae6:	a42d                	j	d10 <vprintf+0x248>
    c = fmt[i] & 0xff;
     ae8:	fe442783          	lw	a5,-28(s0)
     aec:	fc043703          	ld	a4,-64(s0)
     af0:	97ba                	add	a5,a5,a4
     af2:	0007c783          	lbu	a5,0(a5)
     af6:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     afa:	fe042783          	lw	a5,-32(s0)
     afe:	2781                	sext.w	a5,a5
     b00:	eb9d                	bnez	a5,b36 <vprintf+0x6e>
      if(c == '%'){
     b02:	fdc42783          	lw	a5,-36(s0)
     b06:	0007871b          	sext.w	a4,a5
     b0a:	02500793          	li	a5,37
     b0e:	00f71763          	bne	a4,a5,b1c <vprintf+0x54>
        state = '%';
     b12:	02500793          	li	a5,37
     b16:	fef42023          	sw	a5,-32(s0)
     b1a:	a2f5                	j	d06 <vprintf+0x23e>
      } else {
        putc(fd, c);
     b1c:	fdc42783          	lw	a5,-36(s0)
     b20:	0ff7f713          	zext.b	a4,a5
     b24:	fcc42783          	lw	a5,-52(s0)
     b28:	85ba                	mv	a1,a4
     b2a:	853e                	mv	a0,a5
     b2c:	00000097          	auipc	ra,0x0
     b30:	dd2080e7          	jalr	-558(ra) # 8fe <putc>
     b34:	aac9                	j	d06 <vprintf+0x23e>
      }
    } else if(state == '%'){
     b36:	fe042783          	lw	a5,-32(s0)
     b3a:	0007871b          	sext.w	a4,a5
     b3e:	02500793          	li	a5,37
     b42:	1cf71263          	bne	a4,a5,d06 <vprintf+0x23e>
      if(c == 'd'){
     b46:	fdc42783          	lw	a5,-36(s0)
     b4a:	0007871b          	sext.w	a4,a5
     b4e:	06400793          	li	a5,100
     b52:	02f71463          	bne	a4,a5,b7a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     b56:	fb843783          	ld	a5,-72(s0)
     b5a:	00878713          	addi	a4,a5,8
     b5e:	fae43c23          	sd	a4,-72(s0)
     b62:	4398                	lw	a4,0(a5)
     b64:	fcc42783          	lw	a5,-52(s0)
     b68:	4685                	li	a3,1
     b6a:	4629                	li	a2,10
     b6c:	85ba                	mv	a1,a4
     b6e:	853e                	mv	a0,a5
     b70:	00000097          	auipc	ra,0x0
     b74:	dc4080e7          	jalr	-572(ra) # 934 <printint>
     b78:	a269                	j	d02 <vprintf+0x23a>
      } else if(c == 'l') {
     b7a:	fdc42783          	lw	a5,-36(s0)
     b7e:	0007871b          	sext.w	a4,a5
     b82:	06c00793          	li	a5,108
     b86:	02f71663          	bne	a4,a5,bb2 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     b8a:	fb843783          	ld	a5,-72(s0)
     b8e:	00878713          	addi	a4,a5,8
     b92:	fae43c23          	sd	a4,-72(s0)
     b96:	639c                	ld	a5,0(a5)
     b98:	0007871b          	sext.w	a4,a5
     b9c:	fcc42783          	lw	a5,-52(s0)
     ba0:	4681                	li	a3,0
     ba2:	4629                	li	a2,10
     ba4:	85ba                	mv	a1,a4
     ba6:	853e                	mv	a0,a5
     ba8:	00000097          	auipc	ra,0x0
     bac:	d8c080e7          	jalr	-628(ra) # 934 <printint>
     bb0:	aa89                	j	d02 <vprintf+0x23a>
      } else if(c == 'x') {
     bb2:	fdc42783          	lw	a5,-36(s0)
     bb6:	0007871b          	sext.w	a4,a5
     bba:	07800793          	li	a5,120
     bbe:	02f71463          	bne	a4,a5,be6 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     bc2:	fb843783          	ld	a5,-72(s0)
     bc6:	00878713          	addi	a4,a5,8
     bca:	fae43c23          	sd	a4,-72(s0)
     bce:	4398                	lw	a4,0(a5)
     bd0:	fcc42783          	lw	a5,-52(s0)
     bd4:	4681                	li	a3,0
     bd6:	4641                	li	a2,16
     bd8:	85ba                	mv	a1,a4
     bda:	853e                	mv	a0,a5
     bdc:	00000097          	auipc	ra,0x0
     be0:	d58080e7          	jalr	-680(ra) # 934 <printint>
     be4:	aa39                	j	d02 <vprintf+0x23a>
      } else if(c == 'p') {
     be6:	fdc42783          	lw	a5,-36(s0)
     bea:	0007871b          	sext.w	a4,a5
     bee:	07000793          	li	a5,112
     bf2:	02f71263          	bne	a4,a5,c16 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     bf6:	fb843783          	ld	a5,-72(s0)
     bfa:	00878713          	addi	a4,a5,8
     bfe:	fae43c23          	sd	a4,-72(s0)
     c02:	6398                	ld	a4,0(a5)
     c04:	fcc42783          	lw	a5,-52(s0)
     c08:	85ba                	mv	a1,a4
     c0a:	853e                	mv	a0,a5
     c0c:	00000097          	auipc	ra,0x0
     c10:	e30080e7          	jalr	-464(ra) # a3c <printptr>
     c14:	a0fd                	j	d02 <vprintf+0x23a>
      } else if(c == 's'){
     c16:	fdc42783          	lw	a5,-36(s0)
     c1a:	0007871b          	sext.w	a4,a5
     c1e:	07300793          	li	a5,115
     c22:	04f71c63          	bne	a4,a5,c7a <vprintf+0x1b2>
        s = va_arg(ap, char*);
     c26:	fb843783          	ld	a5,-72(s0)
     c2a:	00878713          	addi	a4,a5,8
     c2e:	fae43c23          	sd	a4,-72(s0)
     c32:	639c                	ld	a5,0(a5)
     c34:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     c38:	fe843783          	ld	a5,-24(s0)
     c3c:	eb8d                	bnez	a5,c6e <vprintf+0x1a6>
          s = "(null)";
     c3e:	00000797          	auipc	a5,0x0
     c42:	4f278793          	addi	a5,a5,1266 # 1130 <malloc+0x1b8>
     c46:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c4a:	a015                	j	c6e <vprintf+0x1a6>
          putc(fd, *s);
     c4c:	fe843783          	ld	a5,-24(s0)
     c50:	0007c703          	lbu	a4,0(a5)
     c54:	fcc42783          	lw	a5,-52(s0)
     c58:	85ba                	mv	a1,a4
     c5a:	853e                	mv	a0,a5
     c5c:	00000097          	auipc	ra,0x0
     c60:	ca2080e7          	jalr	-862(ra) # 8fe <putc>
          s++;
     c64:	fe843783          	ld	a5,-24(s0)
     c68:	0785                	addi	a5,a5,1
     c6a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c6e:	fe843783          	ld	a5,-24(s0)
     c72:	0007c783          	lbu	a5,0(a5)
     c76:	fbf9                	bnez	a5,c4c <vprintf+0x184>
     c78:	a069                	j	d02 <vprintf+0x23a>
        }
      } else if(c == 'c'){
     c7a:	fdc42783          	lw	a5,-36(s0)
     c7e:	0007871b          	sext.w	a4,a5
     c82:	06300793          	li	a5,99
     c86:	02f71463          	bne	a4,a5,cae <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     c8a:	fb843783          	ld	a5,-72(s0)
     c8e:	00878713          	addi	a4,a5,8
     c92:	fae43c23          	sd	a4,-72(s0)
     c96:	439c                	lw	a5,0(a5)
     c98:	0ff7f713          	zext.b	a4,a5
     c9c:	fcc42783          	lw	a5,-52(s0)
     ca0:	85ba                	mv	a1,a4
     ca2:	853e                	mv	a0,a5
     ca4:	00000097          	auipc	ra,0x0
     ca8:	c5a080e7          	jalr	-934(ra) # 8fe <putc>
     cac:	a899                	j	d02 <vprintf+0x23a>
      } else if(c == '%'){
     cae:	fdc42783          	lw	a5,-36(s0)
     cb2:	0007871b          	sext.w	a4,a5
     cb6:	02500793          	li	a5,37
     cba:	00f71f63          	bne	a4,a5,cd8 <vprintf+0x210>
        putc(fd, c);
     cbe:	fdc42783          	lw	a5,-36(s0)
     cc2:	0ff7f713          	zext.b	a4,a5
     cc6:	fcc42783          	lw	a5,-52(s0)
     cca:	85ba                	mv	a1,a4
     ccc:	853e                	mv	a0,a5
     cce:	00000097          	auipc	ra,0x0
     cd2:	c30080e7          	jalr	-976(ra) # 8fe <putc>
     cd6:	a035                	j	d02 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     cd8:	fcc42783          	lw	a5,-52(s0)
     cdc:	02500593          	li	a1,37
     ce0:	853e                	mv	a0,a5
     ce2:	00000097          	auipc	ra,0x0
     ce6:	c1c080e7          	jalr	-996(ra) # 8fe <putc>
        putc(fd, c);
     cea:	fdc42783          	lw	a5,-36(s0)
     cee:	0ff7f713          	zext.b	a4,a5
     cf2:	fcc42783          	lw	a5,-52(s0)
     cf6:	85ba                	mv	a1,a4
     cf8:	853e                	mv	a0,a5
     cfa:	00000097          	auipc	ra,0x0
     cfe:	c04080e7          	jalr	-1020(ra) # 8fe <putc>
      }
      state = 0;
     d02:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     d06:	fe442783          	lw	a5,-28(s0)
     d0a:	2785                	addiw	a5,a5,1
     d0c:	fef42223          	sw	a5,-28(s0)
     d10:	fe442783          	lw	a5,-28(s0)
     d14:	fc043703          	ld	a4,-64(s0)
     d18:	97ba                	add	a5,a5,a4
     d1a:	0007c783          	lbu	a5,0(a5)
     d1e:	dc0795e3          	bnez	a5,ae8 <vprintf+0x20>
    }
  }
}
     d22:	0001                	nop
     d24:	0001                	nop
     d26:	60a6                	ld	ra,72(sp)
     d28:	6406                	ld	s0,64(sp)
     d2a:	6161                	addi	sp,sp,80
     d2c:	8082                	ret

0000000000000d2e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d2e:	7159                	addi	sp,sp,-112
     d30:	fc06                	sd	ra,56(sp)
     d32:	f822                	sd	s0,48(sp)
     d34:	0080                	addi	s0,sp,64
     d36:	fcb43823          	sd	a1,-48(s0)
     d3a:	e010                	sd	a2,0(s0)
     d3c:	e414                	sd	a3,8(s0)
     d3e:	e818                	sd	a4,16(s0)
     d40:	ec1c                	sd	a5,24(s0)
     d42:	03043023          	sd	a6,32(s0)
     d46:	03143423          	sd	a7,40(s0)
     d4a:	87aa                	mv	a5,a0
     d4c:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     d50:	03040793          	addi	a5,s0,48
     d54:	fcf43423          	sd	a5,-56(s0)
     d58:	fc843783          	ld	a5,-56(s0)
     d5c:	fd078793          	addi	a5,a5,-48
     d60:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     d64:	fe843703          	ld	a4,-24(s0)
     d68:	fdc42783          	lw	a5,-36(s0)
     d6c:	863a                	mv	a2,a4
     d6e:	fd043583          	ld	a1,-48(s0)
     d72:	853e                	mv	a0,a5
     d74:	00000097          	auipc	ra,0x0
     d78:	d54080e7          	jalr	-684(ra) # ac8 <vprintf>
}
     d7c:	0001                	nop
     d7e:	70e2                	ld	ra,56(sp)
     d80:	7442                	ld	s0,48(sp)
     d82:	6165                	addi	sp,sp,112
     d84:	8082                	ret

0000000000000d86 <printf>:

void
printf(const char *fmt, ...)
{
     d86:	7159                	addi	sp,sp,-112
     d88:	f406                	sd	ra,40(sp)
     d8a:	f022                	sd	s0,32(sp)
     d8c:	1800                	addi	s0,sp,48
     d8e:	fca43c23          	sd	a0,-40(s0)
     d92:	e40c                	sd	a1,8(s0)
     d94:	e810                	sd	a2,16(s0)
     d96:	ec14                	sd	a3,24(s0)
     d98:	f018                	sd	a4,32(s0)
     d9a:	f41c                	sd	a5,40(s0)
     d9c:	03043823          	sd	a6,48(s0)
     da0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     da4:	04040793          	addi	a5,s0,64
     da8:	fcf43823          	sd	a5,-48(s0)
     dac:	fd043783          	ld	a5,-48(s0)
     db0:	fc878793          	addi	a5,a5,-56
     db4:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     db8:	fe843783          	ld	a5,-24(s0)
     dbc:	863e                	mv	a2,a5
     dbe:	fd843583          	ld	a1,-40(s0)
     dc2:	4505                	li	a0,1
     dc4:	00000097          	auipc	ra,0x0
     dc8:	d04080e7          	jalr	-764(ra) # ac8 <vprintf>
}
     dcc:	0001                	nop
     dce:	70a2                	ld	ra,40(sp)
     dd0:	7402                	ld	s0,32(sp)
     dd2:	6165                	addi	sp,sp,112
     dd4:	8082                	ret

0000000000000dd6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     dd6:	7179                	addi	sp,sp,-48
     dd8:	f422                	sd	s0,40(sp)
     dda:	1800                	addi	s0,sp,48
     ddc:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     de0:	fd843783          	ld	a5,-40(s0)
     de4:	17c1                	addi	a5,a5,-16
     de6:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     dea:	00001797          	auipc	a5,0x1
     dee:	61678793          	addi	a5,a5,1558 # 2400 <freep>
     df2:	639c                	ld	a5,0(a5)
     df4:	fef43423          	sd	a5,-24(s0)
     df8:	a815                	j	e2c <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     dfa:	fe843783          	ld	a5,-24(s0)
     dfe:	639c                	ld	a5,0(a5)
     e00:	fe843703          	ld	a4,-24(s0)
     e04:	00f76f63          	bltu	a4,a5,e22 <free+0x4c>
     e08:	fe043703          	ld	a4,-32(s0)
     e0c:	fe843783          	ld	a5,-24(s0)
     e10:	02e7eb63          	bltu	a5,a4,e46 <free+0x70>
     e14:	fe843783          	ld	a5,-24(s0)
     e18:	639c                	ld	a5,0(a5)
     e1a:	fe043703          	ld	a4,-32(s0)
     e1e:	02f76463          	bltu	a4,a5,e46 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e22:	fe843783          	ld	a5,-24(s0)
     e26:	639c                	ld	a5,0(a5)
     e28:	fef43423          	sd	a5,-24(s0)
     e2c:	fe043703          	ld	a4,-32(s0)
     e30:	fe843783          	ld	a5,-24(s0)
     e34:	fce7f3e3          	bgeu	a5,a4,dfa <free+0x24>
     e38:	fe843783          	ld	a5,-24(s0)
     e3c:	639c                	ld	a5,0(a5)
     e3e:	fe043703          	ld	a4,-32(s0)
     e42:	faf77ce3          	bgeu	a4,a5,dfa <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
     e46:	fe043783          	ld	a5,-32(s0)
     e4a:	479c                	lw	a5,8(a5)
     e4c:	1782                	slli	a5,a5,0x20
     e4e:	9381                	srli	a5,a5,0x20
     e50:	0792                	slli	a5,a5,0x4
     e52:	fe043703          	ld	a4,-32(s0)
     e56:	973e                	add	a4,a4,a5
     e58:	fe843783          	ld	a5,-24(s0)
     e5c:	639c                	ld	a5,0(a5)
     e5e:	02f71763          	bne	a4,a5,e8c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
     e62:	fe043783          	ld	a5,-32(s0)
     e66:	4798                	lw	a4,8(a5)
     e68:	fe843783          	ld	a5,-24(s0)
     e6c:	639c                	ld	a5,0(a5)
     e6e:	479c                	lw	a5,8(a5)
     e70:	9fb9                	addw	a5,a5,a4
     e72:	0007871b          	sext.w	a4,a5
     e76:	fe043783          	ld	a5,-32(s0)
     e7a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     e7c:	fe843783          	ld	a5,-24(s0)
     e80:	639c                	ld	a5,0(a5)
     e82:	6398                	ld	a4,0(a5)
     e84:	fe043783          	ld	a5,-32(s0)
     e88:	e398                	sd	a4,0(a5)
     e8a:	a039                	j	e98 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
     e8c:	fe843783          	ld	a5,-24(s0)
     e90:	6398                	ld	a4,0(a5)
     e92:	fe043783          	ld	a5,-32(s0)
     e96:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     e98:	fe843783          	ld	a5,-24(s0)
     e9c:	479c                	lw	a5,8(a5)
     e9e:	1782                	slli	a5,a5,0x20
     ea0:	9381                	srli	a5,a5,0x20
     ea2:	0792                	slli	a5,a5,0x4
     ea4:	fe843703          	ld	a4,-24(s0)
     ea8:	97ba                	add	a5,a5,a4
     eaa:	fe043703          	ld	a4,-32(s0)
     eae:	02f71563          	bne	a4,a5,ed8 <free+0x102>
    p->s.size += bp->s.size;
     eb2:	fe843783          	ld	a5,-24(s0)
     eb6:	4798                	lw	a4,8(a5)
     eb8:	fe043783          	ld	a5,-32(s0)
     ebc:	479c                	lw	a5,8(a5)
     ebe:	9fb9                	addw	a5,a5,a4
     ec0:	0007871b          	sext.w	a4,a5
     ec4:	fe843783          	ld	a5,-24(s0)
     ec8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     eca:	fe043783          	ld	a5,-32(s0)
     ece:	6398                	ld	a4,0(a5)
     ed0:	fe843783          	ld	a5,-24(s0)
     ed4:	e398                	sd	a4,0(a5)
     ed6:	a031                	j	ee2 <free+0x10c>
  } else
    p->s.ptr = bp;
     ed8:	fe843783          	ld	a5,-24(s0)
     edc:	fe043703          	ld	a4,-32(s0)
     ee0:	e398                	sd	a4,0(a5)
  freep = p;
     ee2:	00001797          	auipc	a5,0x1
     ee6:	51e78793          	addi	a5,a5,1310 # 2400 <freep>
     eea:	fe843703          	ld	a4,-24(s0)
     eee:	e398                	sd	a4,0(a5)
}
     ef0:	0001                	nop
     ef2:	7422                	ld	s0,40(sp)
     ef4:	6145                	addi	sp,sp,48
     ef6:	8082                	ret

0000000000000ef8 <morecore>:

static Header*
morecore(uint nu)
{
     ef8:	7179                	addi	sp,sp,-48
     efa:	f406                	sd	ra,40(sp)
     efc:	f022                	sd	s0,32(sp)
     efe:	1800                	addi	s0,sp,48
     f00:	87aa                	mv	a5,a0
     f02:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     f06:	fdc42783          	lw	a5,-36(s0)
     f0a:	0007871b          	sext.w	a4,a5
     f0e:	6785                	lui	a5,0x1
     f10:	00f77563          	bgeu	a4,a5,f1a <morecore+0x22>
    nu = 4096;
     f14:	6785                	lui	a5,0x1
     f16:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     f1a:	fdc42783          	lw	a5,-36(s0)
     f1e:	0047979b          	slliw	a5,a5,0x4
     f22:	2781                	sext.w	a5,a5
     f24:	2781                	sext.w	a5,a5
     f26:	853e                	mv	a0,a5
     f28:	00000097          	auipc	ra,0x0
     f2c:	9ae080e7          	jalr	-1618(ra) # 8d6 <sbrk>
     f30:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     f34:	fe843703          	ld	a4,-24(s0)
     f38:	57fd                	li	a5,-1
     f3a:	00f71463          	bne	a4,a5,f42 <morecore+0x4a>
    return 0;
     f3e:	4781                	li	a5,0
     f40:	a03d                	j	f6e <morecore+0x76>
  hp = (Header*)p;
     f42:	fe843783          	ld	a5,-24(s0)
     f46:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     f4a:	fe043783          	ld	a5,-32(s0)
     f4e:	fdc42703          	lw	a4,-36(s0)
     f52:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     f54:	fe043783          	ld	a5,-32(s0)
     f58:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x98>
     f5a:	853e                	mv	a0,a5
     f5c:	00000097          	auipc	ra,0x0
     f60:	e7a080e7          	jalr	-390(ra) # dd6 <free>
  return freep;
     f64:	00001797          	auipc	a5,0x1
     f68:	49c78793          	addi	a5,a5,1180 # 2400 <freep>
     f6c:	639c                	ld	a5,0(a5)
}
     f6e:	853e                	mv	a0,a5
     f70:	70a2                	ld	ra,40(sp)
     f72:	7402                	ld	s0,32(sp)
     f74:	6145                	addi	sp,sp,48
     f76:	8082                	ret

0000000000000f78 <malloc>:

void*
malloc(uint nbytes)
{
     f78:	7139                	addi	sp,sp,-64
     f7a:	fc06                	sd	ra,56(sp)
     f7c:	f822                	sd	s0,48(sp)
     f7e:	0080                	addi	s0,sp,64
     f80:	87aa                	mv	a5,a0
     f82:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f86:	fcc46783          	lwu	a5,-52(s0)
     f8a:	07bd                	addi	a5,a5,15
     f8c:	8391                	srli	a5,a5,0x4
     f8e:	2781                	sext.w	a5,a5
     f90:	2785                	addiw	a5,a5,1
     f92:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
     f96:	00001797          	auipc	a5,0x1
     f9a:	46a78793          	addi	a5,a5,1130 # 2400 <freep>
     f9e:	639c                	ld	a5,0(a5)
     fa0:	fef43023          	sd	a5,-32(s0)
     fa4:	fe043783          	ld	a5,-32(s0)
     fa8:	ef95                	bnez	a5,fe4 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
     faa:	00001797          	auipc	a5,0x1
     fae:	44678793          	addi	a5,a5,1094 # 23f0 <base>
     fb2:	fef43023          	sd	a5,-32(s0)
     fb6:	00001797          	auipc	a5,0x1
     fba:	44a78793          	addi	a5,a5,1098 # 2400 <freep>
     fbe:	fe043703          	ld	a4,-32(s0)
     fc2:	e398                	sd	a4,0(a5)
     fc4:	00001797          	auipc	a5,0x1
     fc8:	43c78793          	addi	a5,a5,1084 # 2400 <freep>
     fcc:	6398                	ld	a4,0(a5)
     fce:	00001797          	auipc	a5,0x1
     fd2:	42278793          	addi	a5,a5,1058 # 23f0 <base>
     fd6:	e398                	sd	a4,0(a5)
    base.s.size = 0;
     fd8:	00001797          	auipc	a5,0x1
     fdc:	41878793          	addi	a5,a5,1048 # 23f0 <base>
     fe0:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fe4:	fe043783          	ld	a5,-32(s0)
     fe8:	639c                	ld	a5,0(a5)
     fea:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     fee:	fe843783          	ld	a5,-24(s0)
     ff2:	4798                	lw	a4,8(a5)
     ff4:	fdc42783          	lw	a5,-36(s0)
     ff8:	2781                	sext.w	a5,a5
     ffa:	06f76763          	bltu	a4,a5,1068 <malloc+0xf0>
      if(p->s.size == nunits)
     ffe:	fe843783          	ld	a5,-24(s0)
    1002:	4798                	lw	a4,8(a5)
    1004:	fdc42783          	lw	a5,-36(s0)
    1008:	2781                	sext.w	a5,a5
    100a:	00e79963          	bne	a5,a4,101c <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    100e:	fe843783          	ld	a5,-24(s0)
    1012:	6398                	ld	a4,0(a5)
    1014:	fe043783          	ld	a5,-32(s0)
    1018:	e398                	sd	a4,0(a5)
    101a:	a825                	j	1052 <malloc+0xda>
      else {
        p->s.size -= nunits;
    101c:	fe843783          	ld	a5,-24(s0)
    1020:	479c                	lw	a5,8(a5)
    1022:	fdc42703          	lw	a4,-36(s0)
    1026:	9f99                	subw	a5,a5,a4
    1028:	0007871b          	sext.w	a4,a5
    102c:	fe843783          	ld	a5,-24(s0)
    1030:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1032:	fe843783          	ld	a5,-24(s0)
    1036:	479c                	lw	a5,8(a5)
    1038:	1782                	slli	a5,a5,0x20
    103a:	9381                	srli	a5,a5,0x20
    103c:	0792                	slli	a5,a5,0x4
    103e:	fe843703          	ld	a4,-24(s0)
    1042:	97ba                	add	a5,a5,a4
    1044:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    1048:	fe843783          	ld	a5,-24(s0)
    104c:	fdc42703          	lw	a4,-36(s0)
    1050:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    1052:	00001797          	auipc	a5,0x1
    1056:	3ae78793          	addi	a5,a5,942 # 2400 <freep>
    105a:	fe043703          	ld	a4,-32(s0)
    105e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    1060:	fe843783          	ld	a5,-24(s0)
    1064:	07c1                	addi	a5,a5,16
    1066:	a091                	j	10aa <malloc+0x132>
    }
    if(p == freep)
    1068:	00001797          	auipc	a5,0x1
    106c:	39878793          	addi	a5,a5,920 # 2400 <freep>
    1070:	639c                	ld	a5,0(a5)
    1072:	fe843703          	ld	a4,-24(s0)
    1076:	02f71063          	bne	a4,a5,1096 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    107a:	fdc42783          	lw	a5,-36(s0)
    107e:	853e                	mv	a0,a5
    1080:	00000097          	auipc	ra,0x0
    1084:	e78080e7          	jalr	-392(ra) # ef8 <morecore>
    1088:	fea43423          	sd	a0,-24(s0)
    108c:	fe843783          	ld	a5,-24(s0)
    1090:	e399                	bnez	a5,1096 <malloc+0x11e>
        return 0;
    1092:	4781                	li	a5,0
    1094:	a819                	j	10aa <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1096:	fe843783          	ld	a5,-24(s0)
    109a:	fef43023          	sd	a5,-32(s0)
    109e:	fe843783          	ld	a5,-24(s0)
    10a2:	639c                	ld	a5,0(a5)
    10a4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    10a8:	b799                	j	fee <malloc+0x76>
  }
}
    10aa:	853e                	mv	a0,a5
    10ac:	70e2                	ld	ra,56(sp)
    10ae:	7442                	ld	s0,48(sp)
    10b0:	6121                	addi	sp,sp,64
    10b2:	8082                	ret
