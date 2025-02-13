
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	4b013103          	ld	sp,1200(sp) # 8000b4b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	0000b717          	auipc	a4,0xb
    80000054:	4c070713          	addi	a4,a4,1216 # 8000b510 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	2ae78793          	addi	a5,a5,686 # 80006310 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9c7f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e2678793          	addi	a5,a5,-474 # 80000ed2 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	addi	s0,sp,80
    int i;

    for (i = 0; i < n; i++)
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    {
        char c;
        if (either_copyin(&c, user_src, src + i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00003097          	auipc	ra,0x3
    8000012e:	806080e7          	jalr	-2042(ra) # 80002930 <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
            break;
        uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7e4080e7          	jalr	2020(ra) # 8000091e <uartputc>
    for (i = 0; i < n; i++)
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
    }

    return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	addi	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
    uint target;
    int c;
    char cbuf;

    target = n;
    80000188:	00060b1b          	sext.w	s6,a2
    acquire(&cons.lock);
    8000018c:	00013517          	auipc	a0,0x13
    80000190:	4c450513          	addi	a0,a0,1220 # 80013650 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	aa4080e7          	jalr	-1372(ra) # 80000c38 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	4b448493          	addi	s1,s1,1204 # 80013650 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	54490913          	addi	s2,s2,1348 # 800136e8 <cons+0x98>
    while (n > 0)
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
        while (cons.r == cons.w)
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
            if (killed(myproc()))
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	b32080e7          	jalr	-1230(ra) # 80001cee <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	5b6080e7          	jalr	1462(ra) # 8000277a <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	300080e7          	jalr	768(ra) # 800024d2 <sleep>
        while (cons.r == cons.w)
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	46870713          	addi	a4,a4,1128 # 80013650 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

        if (c == C('D'))
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
            }
            break;
        }

        // copy the input byte to the user-space buffer.
        cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	6c0080e7          	jalr	1728(ra) # 800028da <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
            break;

        dst++;
    80000228:	0a05                	addi	s4,s4,1
        --n;
    8000022a:	39fd                	addiw	s3,s3,-1

        if (c == '\n')
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
                release(&cons.lock);
    80000236:	00013517          	auipc	a0,0x13
    8000023a:	41a50513          	addi	a0,a0,1050 # 80013650 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	aae080e7          	jalr	-1362(ra) # 80000cec <release>
                return -1;
    80000246:	557d                	li	a0,-1
        }
    }
    release(&cons.lock);

    return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	addi	sp,sp,96
    8000025a:	8082                	ret
            if (n < target)
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
                cons.r--;
    80000264:	00013717          	auipc	a4,0x13
    80000268:	48f72223          	sw	a5,1156(a4) # 800136e8 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	3d650513          	addi	a0,a0,982 # 80013650 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	a6a080e7          	jalr	-1430(ra) # 80000cec <release>
    return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	addi	s0,sp,16
    if (c == BACKSPACE)
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
        uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	59c080e7          	jalr	1436(ra) # 80000840 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
        uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	58a080e7          	jalr	1418(ra) # 80000840 <uartputc_sync>
        uartputc_sync(' ');
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
        uartputc_sync('\b');
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	574080e7          	jalr	1396(ra) # 80000840 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c)
{
    800002d6:	1101                	addi	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
    acquire(&cons.lock);
    800002e2:	00013517          	auipc	a0,0x13
    800002e6:	36e50513          	addi	a0,a0,878 # 80013650 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	94e080e7          	jalr	-1714(ra) # 80000c38 <acquire>

    switch (c)
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48563          	beq	s1,a5,8000039e <consoleintr+0xc8>
    800002f8:	0297c963          	blt	a5,s1,8000032a <consoleintr+0x54>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48c63          	beq	s1,a5,800003f6 <consoleintr+0x120>
    80000302:	47c1                	li	a5,16
    80000304:	10f49f63          	bne	s1,a5,80000422 <consoleintr+0x14c>
    {
    case C('P'): // Print process list.
        procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	67e080e7          	jalr	1662(ra) # 80002986 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	34050513          	addi	a0,a0,832 # 80013650 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	9d4080e7          	jalr	-1580(ra) # 80000cec <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
    switch (c)
    8000032a:	07f00793          	li	a5,127
    8000032e:	0cf48463          	beq	s1,a5,800003f6 <consoleintr+0x120>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000332:	00013717          	auipc	a4,0x13
    80000336:	31e70713          	addi	a4,a4,798 # 80013650 <cons>
    8000033a:	0a072783          	lw	a5,160(a4)
    8000033e:	09872703          	lw	a4,152(a4)
    80000342:	9f99                	subw	a5,a5,a4
    80000344:	07f00713          	li	a4,127
    80000348:	fcf764e3          	bltu	a4,a5,80000310 <consoleintr+0x3a>
            c = (c == '\r') ? '\n' : c;
    8000034c:	47b5                	li	a5,13
    8000034e:	0cf48d63          	beq	s1,a5,80000428 <consoleintr+0x152>
            consputc(c);
    80000352:	8526                	mv	a0,s1
    80000354:	00000097          	auipc	ra,0x0
    80000358:	f40080e7          	jalr	-192(ra) # 80000294 <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035c:	00013797          	auipc	a5,0x13
    80000360:	2f478793          	addi	a5,a5,756 # 80013650 <cons>
    80000364:	0a07a683          	lw	a3,160(a5)
    80000368:	0016871b          	addiw	a4,a3,1
    8000036c:	0007061b          	sext.w	a2,a4
    80000370:	0ae7a023          	sw	a4,160(a5)
    80000374:	07f6f693          	andi	a3,a3,127
    80000378:	97b6                	add	a5,a5,a3
    8000037a:	00978c23          	sb	s1,24(a5)
            if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE)
    8000037e:	47a9                	li	a5,10
    80000380:	0cf48b63          	beq	s1,a5,80000456 <consoleintr+0x180>
    80000384:	4791                	li	a5,4
    80000386:	0cf48863          	beq	s1,a5,80000456 <consoleintr+0x180>
    8000038a:	00013797          	auipc	a5,0x13
    8000038e:	35e7a783          	lw	a5,862(a5) # 800136e8 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	2b070713          	addi	a4,a4,688 # 80013650 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	2a048493          	addi	s1,s1,672 # 80013650 <cons>
        while (cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	02f70a63          	beq	a4,a5,800003ee <consoleintr+0x118>
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
        while (cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	03270463          	beq	a4,s2,800003f2 <consoleintr+0x11c>
            cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
            consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	ebe080e7          	jalr	-322(ra) # 80000294 <consputc>
        while (cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xe8>
    800003ea:	6902                	ld	s2,0(sp)
    800003ec:	b715                	j	80000310 <consoleintr+0x3a>
    800003ee:	6902                	ld	s2,0(sp)
    800003f0:	b705                	j	80000310 <consoleintr+0x3a>
    800003f2:	6902                	ld	s2,0(sp)
    800003f4:	bf31                	j	80000310 <consoleintr+0x3a>
        if (cons.e != cons.w)
    800003f6:	00013717          	auipc	a4,0x13
    800003fa:	25a70713          	addi	a4,a4,602 # 80013650 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
            cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	2ef72223          	sw	a5,740(a4) # 800136f0 <cons+0xa0>
            consputc(BACKSPACE);
    80000414:	10000513          	li	a0,256
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	e7c080e7          	jalr	-388(ra) # 80000294 <consputc>
    80000420:	bdc5                	j	80000310 <consoleintr+0x3a>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000422:	ee0487e3          	beqz	s1,80000310 <consoleintr+0x3a>
    80000426:	b731                	j	80000332 <consoleintr+0x5c>
            consputc(c);
    80000428:	4529                	li	a0,10
    8000042a:	00000097          	auipc	ra,0x0
    8000042e:	e6a080e7          	jalr	-406(ra) # 80000294 <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000432:	00013797          	auipc	a5,0x13
    80000436:	21e78793          	addi	a5,a5,542 # 80013650 <cons>
    8000043a:	0a07a703          	lw	a4,160(a5)
    8000043e:	0017069b          	addiw	a3,a4,1
    80000442:	0006861b          	sext.w	a2,a3
    80000446:	0ad7a023          	sw	a3,160(a5)
    8000044a:	07f77713          	andi	a4,a4,127
    8000044e:	97ba                	add	a5,a5,a4
    80000450:	4729                	li	a4,10
    80000452:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    80000456:	00013797          	auipc	a5,0x13
    8000045a:	28c7ab23          	sw	a2,662(a5) # 800136ec <cons+0x9c>
                wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	28a50513          	addi	a0,a0,650 # 800136e8 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	0d0080e7          	jalr	208(ra) # 80002536 <wakeup>
    8000046e:	b54d                	j	80000310 <consoleintr+0x3a>

0000000080000470 <consoleinit>:

void consoleinit(void)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
    initlock(&cons.lock, "cons");
    80000478:	00008597          	auipc	a1,0x8
    8000047c:	b8858593          	addi	a1,a1,-1144 # 80008000 <etext>
    80000480:	00013517          	auipc	a0,0x13
    80000484:	1d050513          	addi	a0,a0,464 # 80013650 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	720080e7          	jalr	1824(ra) # 80000ba8 <initlock>

    uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    80000498:	00023797          	auipc	a5,0x23
    8000049c:	55078793          	addi	a5,a5,1360 # 800239e8 <devsw>
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	cce70713          	addi	a4,a4,-818 # 8000016e <consoleread>
    800004a8:	eb98                	sd	a4,16(a5)
    devsw[CONSOLE].write = consolewrite;
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	c5670713          	addi	a4,a4,-938 # 80000100 <consolewrite>
    800004b2:	ef98                	sd	a4,24(a5)
}
    800004b4:	60a2                	ld	ra,8(sp)
    800004b6:	6402                	ld	s0,0(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004bc:	7179                	addi	sp,sp,-48
    800004be:	f406                	sd	ra,40(sp)
    800004c0:	f022                	sd	s0,32(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0xe>
    800004c6:	08054963          	bltz	a0,80000558 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	33a60613          	addi	a2,a2,826 # 80008810 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

  if(sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
    buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000051a:	02e05b63          	blez	a4,80000550 <printint+0x94>
    8000051e:	ec26                	sd	s1,24(sp)
    80000520:	e84a                	sd	s2,16(sp)
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00e784b3          	add	s1,a5,a4
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	377d                	addiw	a4,a4,-1
    80000532:	1702                	slli	a4,a4,0x20
    80000534:	9301                	srli	a4,a4,0x20
    80000536:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d56080e7          	jalr	-682(ra) # 80000294 <consputc>
  while(--i >= 0)
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x7e>
    8000054c:	64e2                	ld	s1,24(sp)
    8000054e:	6942                	ld	s2,16(sp)
}
    80000550:	70a2                	ld	ra,40(sp)
    80000552:	7402                	ld	s0,32(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
    x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00013797          	auipc	a5,0x13
    80000570:	1a07a223          	sw	zero,420(a5) # 80013710 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	0000b717          	auipc	a4,0xb
    800005a4:	f2f72823          	sw	a5,-208(a4) # 8000b4d0 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	f06a                	sd	s10,32(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00013d17          	auipc	s10,0x13
    800005ce:	146d2d03          	lw	s10,326(s10) # 80013710 <pr+0x18>
  if(locking)
    800005d2:	040d1463          	bnez	s10,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050b63          	beqz	a0,8000077c <printf+0x1d2>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000608:	00008a97          	auipc	s5,0x8
    8000060c:	208a8a93          	addi	s5,s5,520 # 80008810 <digits>
    switch(c){
    80000610:	07300c13          	li	s8,115
    80000614:	06400d93          	li	s11,100
    80000618:	a0b1                	j	80000664 <printf+0xba>
    acquire(&pr.lock);
    8000061a:	00013517          	auipc	a0,0x13
    8000061e:	0de50513          	addi	a0,a0,222 # 800136f8 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	616080e7          	jalr	1558(ra) # 80000c38 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c46080e7          	jalr	-954(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2985                	addiw	s3,s3,1
    80000658:	013a07b3          	add	a5,s4,s3
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c0>
    if(c != '%'){
    80000664:	ff6515e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000676:	10078b63          	beqz	a5,8000078c <printf+0x1e2>
    switch(c){
    8000067a:	05778a63          	beq	a5,s7,800006ce <printf+0x124>
    8000067e:	02fbf663          	bgeu	s7,a5,800006aa <printf+0x100>
    80000682:	09878863          	beq	a5,s8,80000712 <printf+0x168>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79563          	bne	a5,a4,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85e6                	mv	a1,s9
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e1c080e7          	jalr	-484(ra) # 800004bc <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	09678f63          	beq	a5,s6,80000748 <printf+0x19e>
    800006ae:	0bb79363          	bne	a5,s11,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	df8080e7          	jalr	-520(ra) # 800004bc <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	bb2080e7          	jalr	-1102(ra) # 80000294 <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	ba6080e7          	jalr	-1114(ra) # 80000294 <consputc>
    800006f6:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b92080e7          	jalr	-1134(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x14e>
    80000710:	b799                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x190>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d905                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b6c080e7          	jalr	-1172(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x17e>
    80000738:	bf39                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x17e>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b4a080e7          	jalr	-1206(ra) # 80000294 <consputc>
      break;
    80000752:	b711                	j	80000656 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b3e080e7          	jalr	-1218(ra) # 80000294 <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b34080e7          	jalr	-1228(ra) # 80000294 <consputc>
      break;
    80000768:	b5fd                	j	80000656 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	6de2                	ld	s11,24(sp)
  if(locking)
    8000077c:	020d1263          	bnez	s10,800007a0 <printf+0x1f6>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	7d02                	ld	s10,32(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	6de2                	ld	s11,24(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d2>
    release(&pr.lock);
    800007a0:	00013517          	auipc	a0,0x13
    800007a4:	f5850513          	addi	a0,a0,-168 # 800136f8 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	544080e7          	jalr	1348(ra) # 80000cec <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d6>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1101                	addi	sp,sp,-32
    800007b4:	ec06                	sd	ra,24(sp)
    800007b6:	e822                	sd	s0,16(sp)
    800007b8:	e426                	sd	s1,8(sp)
    800007ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007bc:	00013497          	auipc	s1,0x13
    800007c0:	f3c48493          	addi	s1,s1,-196 # 800136f8 <pr>
    800007c4:	00008597          	auipc	a1,0x8
    800007c8:	86c58593          	addi	a1,a1,-1940 # 80008030 <etext+0x30>
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	3da080e7          	jalr	986(ra) # 80000ba8 <initlock>
  pr.locking = 1;
    800007d6:	4785                	li	a5,1
    800007d8:	cc9c                	sw	a5,24(s1)
}
    800007da:	60e2                	ld	ra,24(sp)
    800007dc:	6442                	ld	s0,16(sp)
    800007de:	64a2                	ld	s1,8(sp)
    800007e0:	6105                	addi	sp,sp,32
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	10000737          	lui	a4,0x10000
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00008597          	auipc	a1,0x8
    80000824:	81858593          	addi	a1,a1,-2024 # 80008038 <etext+0x38>
    80000828:	00013517          	auipc	a0,0x13
    8000082c:	ef050513          	addi	a0,a0,-272 # 80013718 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	378080e7          	jalr	888(ra) # 80000ba8 <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	3a0080e7          	jalr	928(ra) # 80000bec <push_off>

  if(panicked){
    80000854:	0000b797          	auipc	a5,0xb
    80000858:	c7c7a783          	lw	a5,-900(a5) # 8000b4d0 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	412080e7          	jalr	1042(ra) # 80000c8c <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	0000b797          	auipc	a5,0xb
    80000892:	c4a7b783          	ld	a5,-950(a5) # 8000b4d8 <uart_tx_r>
    80000896:	0000b717          	auipc	a4,0xb
    8000089a:	c4a73703          	ld	a4,-950(a4) # 8000b4e0 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00013a97          	auipc	s5,0x13
    800008c0:	e5ca8a93          	addi	s5,s5,-420 # 80013718 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000b497          	auipc	s1,0xb
    800008c8:	c1448493          	addi	s1,s1,-1004 # 8000b4d8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000b997          	auipc	s3,0xb
    800008d4:	c1098993          	addi	s3,s3,-1008 # 8000b4e0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	c44080e7          	jalr	-956(ra) # 80002536 <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3)
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00013517          	auipc	a0,0x13
    80000934:	de850513          	addi	a0,a0,-536 # 80013718 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	300080e7          	jalr	768(ra) # 80000c38 <acquire>
  if(panicked){
    80000940:	0000b797          	auipc	a5,0xb
    80000944:	b907a783          	lw	a5,-1136(a5) # 8000b4d0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000b717          	auipc	a4,0xb
    8000094e:	b9673703          	ld	a4,-1130(a4) # 8000b4e0 <uart_tx_w>
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	b867b783          	ld	a5,-1146(a5) # 8000b4d8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00013997          	auipc	s3,0x13
    80000962:	dba98993          	addi	s3,s3,-582 # 80013718 <uart_tx_lock>
    80000966:	0000b497          	auipc	s1,0xb
    8000096a:	b7248493          	addi	s1,s1,-1166 # 8000b4d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000b917          	auipc	s2,0xb
    80000972:	b7290913          	addi	s2,s2,-1166 # 8000b4e0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	b54080e7          	jalr	-1196(ra) # 800024d2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00013497          	auipc	s1,0x13
    80000998:	d8448493          	addi	s1,s1,-636 # 80013718 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000b797          	auipc	a5,0xb
    800009ac:	b2e7bc23          	sd	a4,-1224(a5) # 8000b4e0 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	332080e7          	jalr	818(ra) # 80000cec <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e422                	sd	s0,8(sp)
    800009d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009e0:	0007c783          	lbu	a5,0(a5)
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb81                	beqz	a5,800009f6 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	6422                	ld	s0,8(sp)
    800009f2:	0141                	addi	sp,sp,16
    800009f4:	8082                	ret
    return -1;
    800009f6:	557d                	li	a0,-1
    800009f8:	bfe5                	j	800009f0 <uartgetc+0x1c>

00000000800009fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a04:	54fd                	li	s1,-1
    80000a06:	a029                	j	80000a10 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	8ce080e7          	jalr	-1842(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	fc4080e7          	jalr	-60(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a18:	fe9518e3          	bne	a0,s1,80000a08 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1c:	00013497          	auipc	s1,0x13
    80000a20:	cfc48493          	addi	s1,s1,-772 # 80013718 <uart_tx_lock>
    80000a24:	8526                	mv	a0,s1
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	212080e7          	jalr	530(ra) # 80000c38 <acquire>
  uartstart();
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	e60080e7          	jalr	-416(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	2b4080e7          	jalr	692(ra) # 80000cec <release>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret

0000000080000a4a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4a:	1101                	addi	sp,sp,-32
    80000a4c:	ec06                	sd	ra,24(sp)
    80000a4e:	e822                	sd	s0,16(sp)
    80000a50:	e426                	sd	s1,8(sp)
    80000a52:	e04a                	sd	s2,0(sp)
    80000a54:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a56:	03451793          	slli	a5,a0,0x34
    80000a5a:	ebb9                	bnez	a5,80000ab0 <kfree+0x66>
    80000a5c:	84aa                	mv	s1,a0
    80000a5e:	00024797          	auipc	a5,0x24
    80000a62:	12278793          	addi	a5,a5,290 # 80024b80 <end>
    80000a66:	04f56563          	bltu	a0,a5,80000ab0 <kfree+0x66>
    80000a6a:	47c5                	li	a5,17
    80000a6c:	07ee                	slli	a5,a5,0x1b
    80000a6e:	04f57163          	bgeu	a0,a5,80000ab0 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a72:	6605                	lui	a2,0x1
    80000a74:	4585                	li	a1,1
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	2be080e7          	jalr	702(ra) # 80000d34 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a7e:	00013917          	auipc	s2,0x13
    80000a82:	cd290913          	addi	s2,s2,-814 # 80013750 <kmem>
    80000a86:	854a                	mv	a0,s2
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	1b0080e7          	jalr	432(ra) # 80000c38 <acquire>
  r->next = kmem.freelist;
    80000a90:	01893783          	ld	a5,24(s2)
    80000a94:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a96:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	250080e7          	jalr	592(ra) # 80000cec <release>
}
    80000aa4:	60e2                	ld	ra,24(sp)
    80000aa6:	6442                	ld	s0,16(sp)
    80000aa8:	64a2                	ld	s1,8(sp)
    80000aaa:	6902                	ld	s2,0(sp)
    80000aac:	6105                	addi	sp,sp,32
    80000aae:	8082                	ret
    panic("kfree");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	59050513          	addi	a0,a0,1424 # 80008040 <etext+0x40>
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	aa8080e7          	jalr	-1368(ra) # 80000560 <panic>

0000000080000ac0 <freerange>:
{
    80000ac0:	7179                	addi	sp,sp,-48
    80000ac2:	f406                	sd	ra,40(sp)
    80000ac4:	f022                	sd	s0,32(sp)
    80000ac6:	ec26                	sd	s1,24(sp)
    80000ac8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aca:	6785                	lui	a5,0x1
    80000acc:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad0:	00e504b3          	add	s1,a0,a4
    80000ad4:	777d                	lui	a4,0xfffff
    80000ad6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad8:	94be                	add	s1,s1,a5
    80000ada:	0295e463          	bltu	a1,s1,80000b02 <freerange+0x42>
    80000ade:	e84a                	sd	s2,16(sp)
    80000ae0:	e44e                	sd	s3,8(sp)
    80000ae2:	e052                	sd	s4,0(sp)
    80000ae4:	892e                	mv	s2,a1
    kfree(p);
    80000ae6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	6985                	lui	s3,0x1
    kfree(p);
    80000aea:	01448533          	add	a0,s1,s4
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	f5c080e7          	jalr	-164(ra) # 80000a4a <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af6:	94ce                	add	s1,s1,s3
    80000af8:	fe9979e3          	bgeu	s2,s1,80000aea <freerange+0x2a>
    80000afc:	6942                	ld	s2,16(sp)
    80000afe:	69a2                	ld	s3,8(sp)
    80000b00:	6a02                	ld	s4,0(sp)
}
    80000b02:	70a2                	ld	ra,40(sp)
    80000b04:	7402                	ld	s0,32(sp)
    80000b06:	64e2                	ld	s1,24(sp)
    80000b08:	6145                	addi	sp,sp,48
    80000b0a:	8082                	ret

0000000080000b0c <kinit>:
{
    80000b0c:	1141                	addi	sp,sp,-16
    80000b0e:	e406                	sd	ra,8(sp)
    80000b10:	e022                	sd	s0,0(sp)
    80000b12:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b14:	00007597          	auipc	a1,0x7
    80000b18:	53458593          	addi	a1,a1,1332 # 80008048 <etext+0x48>
    80000b1c:	00013517          	auipc	a0,0x13
    80000b20:	c3450513          	addi	a0,a0,-972 # 80013750 <kmem>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	084080e7          	jalr	132(ra) # 80000ba8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00024517          	auipc	a0,0x24
    80000b34:	05050513          	addi	a0,a0,80 # 80024b80 <end>
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	f88080e7          	jalr	-120(ra) # 80000ac0 <freerange>
}
    80000b40:	60a2                	ld	ra,8(sp)
    80000b42:	6402                	ld	s0,0(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b48:	1101                	addi	sp,sp,-32
    80000b4a:	ec06                	sd	ra,24(sp)
    80000b4c:	e822                	sd	s0,16(sp)
    80000b4e:	e426                	sd	s1,8(sp)
    80000b50:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b52:	00013497          	auipc	s1,0x13
    80000b56:	bfe48493          	addi	s1,s1,-1026 # 80013750 <kmem>
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	0dc080e7          	jalr	220(ra) # 80000c38 <acquire>
  r = kmem.freelist;
    80000b64:	6c84                	ld	s1,24(s1)
  if(r)
    80000b66:	c885                	beqz	s1,80000b96 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b68:	609c                	ld	a5,0(s1)
    80000b6a:	00013517          	auipc	a0,0x13
    80000b6e:	be650513          	addi	a0,a0,-1050 # 80013750 <kmem>
    80000b72:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b74:	00000097          	auipc	ra,0x0
    80000b78:	178080e7          	jalr	376(ra) # 80000cec <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7c:	6605                	lui	a2,0x1
    80000b7e:	4595                	li	a1,5
    80000b80:	8526                	mv	a0,s1
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	1b2080e7          	jalr	434(ra) # 80000d34 <memset>
  return (void*)r;
}
    80000b8a:	8526                	mv	a0,s1
    80000b8c:	60e2                	ld	ra,24(sp)
    80000b8e:	6442                	ld	s0,16(sp)
    80000b90:	64a2                	ld	s1,8(sp)
    80000b92:	6105                	addi	sp,sp,32
    80000b94:	8082                	ret
  release(&kmem.lock);
    80000b96:	00013517          	auipc	a0,0x13
    80000b9a:	bba50513          	addi	a0,a0,-1094 # 80013750 <kmem>
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	14e080e7          	jalr	334(ra) # 80000cec <release>
  if(r)
    80000ba6:	b7d5                	j	80000b8a <kalloc+0x42>

0000000080000ba8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ba8:	1141                	addi	sp,sp,-16
    80000baa:	e422                	sd	s0,8(sp)
    80000bac:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bb0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb4:	00053823          	sd	zero,16(a0)
}
    80000bb8:	6422                	ld	s0,8(sp)
    80000bba:	0141                	addi	sp,sp,16
    80000bbc:	8082                	ret

0000000080000bbe <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bbe:	411c                	lw	a5,0(a0)
    80000bc0:	e399                	bnez	a5,80000bc6 <holding+0x8>
    80000bc2:	4501                	li	a0,0
  return r;
}
    80000bc4:	8082                	ret
{
    80000bc6:	1101                	addi	sp,sp,-32
    80000bc8:	ec06                	sd	ra,24(sp)
    80000bca:	e822                	sd	s0,16(sp)
    80000bcc:	e426                	sd	s1,8(sp)
    80000bce:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bd0:	6904                	ld	s1,16(a0)
    80000bd2:	00001097          	auipc	ra,0x1
    80000bd6:	100080e7          	jalr	256(ra) # 80001cd2 <mycpu>
    80000bda:	40a48533          	sub	a0,s1,a0
    80000bde:	00153513          	seqz	a0,a0
}
    80000be2:	60e2                	ld	ra,24(sp)
    80000be4:	6442                	ld	s0,16(sp)
    80000be6:	64a2                	ld	s1,8(sp)
    80000be8:	6105                	addi	sp,sp,32
    80000bea:	8082                	ret

0000000080000bec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bec:	1101                	addi	sp,sp,-32
    80000bee:	ec06                	sd	ra,24(sp)
    80000bf0:	e822                	sd	s0,16(sp)
    80000bf2:	e426                	sd	s1,8(sp)
    80000bf4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf6:	100024f3          	csrr	s1,sstatus
    80000bfa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bfe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c00:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c04:	00001097          	auipc	ra,0x1
    80000c08:	0ce080e7          	jalr	206(ra) # 80001cd2 <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	0c2080e7          	jalr	194(ra) # 80001cd2 <mycpu>
    80000c18:	5d3c                	lw	a5,120(a0)
    80000c1a:	2785                	addiw	a5,a5,1
    80000c1c:	dd3c                	sw	a5,120(a0)
}
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret
    mycpu()->intena = old;
    80000c28:	00001097          	auipc	ra,0x1
    80000c2c:	0aa080e7          	jalr	170(ra) # 80001cd2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c30:	8085                	srli	s1,s1,0x1
    80000c32:	8885                	andi	s1,s1,1
    80000c34:	dd64                	sw	s1,124(a0)
    80000c36:	bfe9                	j	80000c10 <push_off+0x24>

0000000080000c38 <acquire>:
{
    80000c38:	1101                	addi	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	addi	s0,sp,32
    80000c42:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	fa8080e7          	jalr	-88(ra) # 80000bec <push_off>
  if(holding(lk))
    80000c4c:	8526                	mv	a0,s1
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	f70080e7          	jalr	-144(ra) # 80000bbe <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c56:	4705                	li	a4,1
  if(holding(lk))
    80000c58:	e115                	bnez	a0,80000c7c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c5a:	87ba                	mv	a5,a4
    80000c5c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c60:	2781                	sext.w	a5,a5
    80000c62:	ffe5                	bnez	a5,80000c5a <acquire+0x22>
  __sync_synchronize();
    80000c64:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c68:	00001097          	auipc	ra,0x1
    80000c6c:	06a080e7          	jalr	106(ra) # 80001cd2 <mycpu>
    80000c70:	e888                	sd	a0,16(s1)
}
    80000c72:	60e2                	ld	ra,24(sp)
    80000c74:	6442                	ld	s0,16(sp)
    80000c76:	64a2                	ld	s1,8(sp)
    80000c78:	6105                	addi	sp,sp,32
    80000c7a:	8082                	ret
    panic("acquire");
    80000c7c:	00007517          	auipc	a0,0x7
    80000c80:	3d450513          	addi	a0,a0,980 # 80008050 <etext+0x50>
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	8dc080e7          	jalr	-1828(ra) # 80000560 <panic>

0000000080000c8c <pop_off>:

void
pop_off(void)
{
    80000c8c:	1141                	addi	sp,sp,-16
    80000c8e:	e406                	sd	ra,8(sp)
    80000c90:	e022                	sd	s0,0(sp)
    80000c92:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c94:	00001097          	auipc	ra,0x1
    80000c98:	03e080e7          	jalr	62(ra) # 80001cd2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c9c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ca0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ca2:	e78d                	bnez	a5,80000ccc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000ca4:	5d3c                	lw	a5,120(a0)
    80000ca6:	02f05b63          	blez	a5,80000cdc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000caa:	37fd                	addiw	a5,a5,-1
    80000cac:	0007871b          	sext.w	a4,a5
    80000cb0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cb2:	eb09                	bnez	a4,80000cc4 <pop_off+0x38>
    80000cb4:	5d7c                	lw	a5,124(a0)
    80000cb6:	c799                	beqz	a5,80000cc4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cbc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cc0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cc4:	60a2                	ld	ra,8(sp)
    80000cc6:	6402                	ld	s0,0(sp)
    80000cc8:	0141                	addi	sp,sp,16
    80000cca:	8082                	ret
    panic("pop_off - interruptible");
    80000ccc:	00007517          	auipc	a0,0x7
    80000cd0:	38c50513          	addi	a0,a0,908 # 80008058 <etext+0x58>
    80000cd4:	00000097          	auipc	ra,0x0
    80000cd8:	88c080e7          	jalr	-1908(ra) # 80000560 <panic>
    panic("pop_off");
    80000cdc:	00007517          	auipc	a0,0x7
    80000ce0:	39450513          	addi	a0,a0,916 # 80008070 <etext+0x70>
    80000ce4:	00000097          	auipc	ra,0x0
    80000ce8:	87c080e7          	jalr	-1924(ra) # 80000560 <panic>

0000000080000cec <release>:
{
    80000cec:	1101                	addi	sp,sp,-32
    80000cee:	ec06                	sd	ra,24(sp)
    80000cf0:	e822                	sd	s0,16(sp)
    80000cf2:	e426                	sd	s1,8(sp)
    80000cf4:	1000                	addi	s0,sp,32
    80000cf6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	ec6080e7          	jalr	-314(ra) # 80000bbe <holding>
    80000d00:	c115                	beqz	a0,80000d24 <release+0x38>
  lk->cpu = 0;
    80000d02:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d06:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d0a:	0310000f          	fence	rw,w
    80000d0e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d12:	00000097          	auipc	ra,0x0
    80000d16:	f7a080e7          	jalr	-134(ra) # 80000c8c <pop_off>
}
    80000d1a:	60e2                	ld	ra,24(sp)
    80000d1c:	6442                	ld	s0,16(sp)
    80000d1e:	64a2                	ld	s1,8(sp)
    80000d20:	6105                	addi	sp,sp,32
    80000d22:	8082                	ret
    panic("release");
    80000d24:	00007517          	auipc	a0,0x7
    80000d28:	35450513          	addi	a0,a0,852 # 80008078 <etext+0x78>
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	834080e7          	jalr	-1996(ra) # 80000560 <panic>

0000000080000d34 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d34:	1141                	addi	sp,sp,-16
    80000d36:	e422                	sd	s0,8(sp)
    80000d38:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d3a:	ca19                	beqz	a2,80000d50 <memset+0x1c>
    80000d3c:	87aa                	mv	a5,a0
    80000d3e:	1602                	slli	a2,a2,0x20
    80000d40:	9201                	srli	a2,a2,0x20
    80000d42:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d46:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d4a:	0785                	addi	a5,a5,1
    80000d4c:	fee79de3          	bne	a5,a4,80000d46 <memset+0x12>
  }
  return dst;
}
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret

0000000080000d56 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d56:	1141                	addi	sp,sp,-16
    80000d58:	e422                	sd	s0,8(sp)
    80000d5a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d5c:	ca05                	beqz	a2,80000d8c <memcmp+0x36>
    80000d5e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d62:	1682                	slli	a3,a3,0x20
    80000d64:	9281                	srli	a3,a3,0x20
    80000d66:	0685                	addi	a3,a3,1
    80000d68:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d6a:	00054783          	lbu	a5,0(a0)
    80000d6e:	0005c703          	lbu	a4,0(a1)
    80000d72:	00e79863          	bne	a5,a4,80000d82 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d76:	0505                	addi	a0,a0,1
    80000d78:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d7a:	fed518e3          	bne	a0,a3,80000d6a <memcmp+0x14>
  }

  return 0;
    80000d7e:	4501                	li	a0,0
    80000d80:	a019                	j	80000d86 <memcmp+0x30>
      return *s1 - *s2;
    80000d82:	40e7853b          	subw	a0,a5,a4
}
    80000d86:	6422                	ld	s0,8(sp)
    80000d88:	0141                	addi	sp,sp,16
    80000d8a:	8082                	ret
  return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	bfe5                	j	80000d86 <memcmp+0x30>

0000000080000d90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d90:	1141                	addi	sp,sp,-16
    80000d92:	e422                	sd	s0,8(sp)
    80000d94:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d96:	c205                	beqz	a2,80000db6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d98:	02a5e263          	bltu	a1,a0,80000dbc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d9c:	1602                	slli	a2,a2,0x20
    80000d9e:	9201                	srli	a2,a2,0x20
    80000da0:	00c587b3          	add	a5,a1,a2
{
    80000da4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000da6:	0585                	addi	a1,a1,1
    80000da8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda481>
    80000daa:	fff5c683          	lbu	a3,-1(a1)
    80000dae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000db2:	feb79ae3          	bne	a5,a1,80000da6 <memmove+0x16>

  return dst;
}
    80000db6:	6422                	ld	s0,8(sp)
    80000db8:	0141                	addi	sp,sp,16
    80000dba:	8082                	ret
  if(s < d && s + n > d){
    80000dbc:	02061693          	slli	a3,a2,0x20
    80000dc0:	9281                	srli	a3,a3,0x20
    80000dc2:	00d58733          	add	a4,a1,a3
    80000dc6:	fce57be3          	bgeu	a0,a4,80000d9c <memmove+0xc>
    d += n;
    80000dca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dcc:	fff6079b          	addiw	a5,a2,-1
    80000dd0:	1782                	slli	a5,a5,0x20
    80000dd2:	9381                	srli	a5,a5,0x20
    80000dd4:	fff7c793          	not	a5,a5
    80000dd8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dda:	177d                	addi	a4,a4,-1
    80000ddc:	16fd                	addi	a3,a3,-1
    80000dde:	00074603          	lbu	a2,0(a4)
    80000de2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000de6:	fef71ae3          	bne	a4,a5,80000dda <memmove+0x4a>
    80000dea:	b7f1                	j	80000db6 <memmove+0x26>

0000000080000dec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dec:	1141                	addi	sp,sp,-16
    80000dee:	e406                	sd	ra,8(sp)
    80000df0:	e022                	sd	s0,0(sp)
    80000df2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000df4:	00000097          	auipc	ra,0x0
    80000df8:	f9c080e7          	jalr	-100(ra) # 80000d90 <memmove>
}
    80000dfc:	60a2                	ld	ra,8(sp)
    80000dfe:	6402                	ld	s0,0(sp)
    80000e00:	0141                	addi	sp,sp,16
    80000e02:	8082                	ret

0000000080000e04 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e422                	sd	s0,8(sp)
    80000e08:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e0a:	ce11                	beqz	a2,80000e26 <strncmp+0x22>
    80000e0c:	00054783          	lbu	a5,0(a0)
    80000e10:	cf89                	beqz	a5,80000e2a <strncmp+0x26>
    80000e12:	0005c703          	lbu	a4,0(a1)
    80000e16:	00f71a63          	bne	a4,a5,80000e2a <strncmp+0x26>
    n--, p++, q++;
    80000e1a:	367d                	addiw	a2,a2,-1
    80000e1c:	0505                	addi	a0,a0,1
    80000e1e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e20:	f675                	bnez	a2,80000e0c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e22:	4501                	li	a0,0
    80000e24:	a801                	j	80000e34 <strncmp+0x30>
    80000e26:	4501                	li	a0,0
    80000e28:	a031                	j	80000e34 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000e2a:	00054503          	lbu	a0,0(a0)
    80000e2e:	0005c783          	lbu	a5,0(a1)
    80000e32:	9d1d                	subw	a0,a0,a5
}
    80000e34:	6422                	ld	s0,8(sp)
    80000e36:	0141                	addi	sp,sp,16
    80000e38:	8082                	ret

0000000080000e3a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e422                	sd	s0,8(sp)
    80000e3e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e40:	87aa                	mv	a5,a0
    80000e42:	86b2                	mv	a3,a2
    80000e44:	367d                	addiw	a2,a2,-1
    80000e46:	02d05563          	blez	a3,80000e70 <strncpy+0x36>
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	0005c703          	lbu	a4,0(a1)
    80000e50:	fee78fa3          	sb	a4,-1(a5)
    80000e54:	0585                	addi	a1,a1,1
    80000e56:	f775                	bnez	a4,80000e42 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e58:	873e                	mv	a4,a5
    80000e5a:	9fb5                	addw	a5,a5,a3
    80000e5c:	37fd                	addiw	a5,a5,-1
    80000e5e:	00c05963          	blez	a2,80000e70 <strncpy+0x36>
    *s++ = 0;
    80000e62:	0705                	addi	a4,a4,1
    80000e64:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e68:	40e786bb          	subw	a3,a5,a4
    80000e6c:	fed04be3          	bgtz	a3,80000e62 <strncpy+0x28>
  return os;
}
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e7c:	02c05363          	blez	a2,80000ea2 <safestrcpy+0x2c>
    80000e80:	fff6069b          	addiw	a3,a2,-1
    80000e84:	1682                	slli	a3,a3,0x20
    80000e86:	9281                	srli	a3,a3,0x20
    80000e88:	96ae                	add	a3,a3,a1
    80000e8a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e8c:	00d58963          	beq	a1,a3,80000e9e <safestrcpy+0x28>
    80000e90:	0585                	addi	a1,a1,1
    80000e92:	0785                	addi	a5,a5,1
    80000e94:	fff5c703          	lbu	a4,-1(a1)
    80000e98:	fee78fa3          	sb	a4,-1(a5)
    80000e9c:	fb65                	bnez	a4,80000e8c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e9e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ea2:	6422                	ld	s0,8(sp)
    80000ea4:	0141                	addi	sp,sp,16
    80000ea6:	8082                	ret

0000000080000ea8 <strlen>:

int
strlen(const char *s)
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e422                	sd	s0,8(sp)
    80000eac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eae:	00054783          	lbu	a5,0(a0)
    80000eb2:	cf91                	beqz	a5,80000ece <strlen+0x26>
    80000eb4:	0505                	addi	a0,a0,1
    80000eb6:	87aa                	mv	a5,a0
    80000eb8:	86be                	mv	a3,a5
    80000eba:	0785                	addi	a5,a5,1
    80000ebc:	fff7c703          	lbu	a4,-1(a5)
    80000ec0:	ff65                	bnez	a4,80000eb8 <strlen+0x10>
    80000ec2:	40a6853b          	subw	a0,a3,a0
    80000ec6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000ec8:	6422                	ld	s0,8(sp)
    80000eca:	0141                	addi	sp,sp,16
    80000ecc:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ece:	4501                	li	a0,0
    80000ed0:	bfe5                	j	80000ec8 <strlen+0x20>

0000000080000ed2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ed2:	1141                	addi	sp,sp,-16
    80000ed4:	e406                	sd	ra,8(sp)
    80000ed6:	e022                	sd	s0,0(sp)
    80000ed8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eda:	00001097          	auipc	ra,0x1
    80000ede:	de8080e7          	jalr	-536(ra) # 80001cc2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ee2:	0000a717          	auipc	a4,0xa
    80000ee6:	60670713          	addi	a4,a4,1542 # 8000b4e8 <started>
  if(cpuid() == 0){
    80000eea:	c139                	beqz	a0,80000f30 <main+0x5e>
    while(started == 0)
    80000eec:	431c                	lw	a5,0(a4)
    80000eee:	2781                	sext.w	a5,a5
    80000ef0:	dff5                	beqz	a5,80000eec <main+0x1a>
      ;
    __sync_synchronize();
    80000ef2:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	dcc080e7          	jalr	-564(ra) # 80001cc2 <cpuid>
    80000efe:	85aa                	mv	a1,a0
    80000f00:	00007517          	auipc	a0,0x7
    80000f04:	19850513          	addi	a0,a0,408 # 80008098 <etext+0x98>
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	6a2080e7          	jalr	1698(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	0d8080e7          	jalr	216(ra) # 80000fe8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f18:	00002097          	auipc	ra,0x2
    80000f1c:	cf6080e7          	jalr	-778(ra) # 80002c0e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	434080e7          	jalr	1076(ra) # 80006354 <plicinithart>
  }

  scheduler();        
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	45e080e7          	jalr	1118(ra) # 80002386 <scheduler>
    consoleinit();
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	540080e7          	jalr	1344(ra) # 80000470 <consoleinit>
    printfinit();
    80000f38:	00000097          	auipc	ra,0x0
    80000f3c:	87a080e7          	jalr	-1926(ra) # 800007b2 <printfinit>
    printf("\n");
    80000f40:	00007517          	auipc	a0,0x7
    80000f44:	0d050513          	addi	a0,a0,208 # 80008010 <etext+0x10>
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	662080e7          	jalr	1634(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80000f50:	00007517          	auipc	a0,0x7
    80000f54:	13050513          	addi	a0,a0,304 # 80008080 <etext+0x80>
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	652080e7          	jalr	1618(ra) # 800005aa <printf>
    printf("\n");
    80000f60:	00007517          	auipc	a0,0x7
    80000f64:	0b050513          	addi	a0,a0,176 # 80008010 <etext+0x10>
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	642080e7          	jalr	1602(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	b9c080e7          	jalr	-1124(ra) # 80000b0c <kinit>
    kvminit();       // create kernel page table
    80000f78:	00000097          	auipc	ra,0x0
    80000f7c:	326080e7          	jalr	806(ra) # 8000129e <kvminit>
    kvminithart();   // turn on paging
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	068080e7          	jalr	104(ra) # 80000fe8 <kvminithart>
    procinit();      // process table
    80000f88:	00001097          	auipc	ra,0x1
    80000f8c:	c54080e7          	jalr	-940(ra) # 80001bdc <procinit>
    trapinit();      // trap vectors
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	c56080e7          	jalr	-938(ra) # 80002be6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	c76080e7          	jalr	-906(ra) # 80002c0e <trapinithart>
    plicinit();      // set up interrupt controller
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	39a080e7          	jalr	922(ra) # 8000633a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	3ac080e7          	jalr	940(ra) # 80006354 <plicinithart>
    binit();         // buffer cache
    80000fb0:	00002097          	auipc	ra,0x2
    80000fb4:	470080e7          	jalr	1136(ra) # 80003420 <binit>
    iinit();         // inode table
    80000fb8:	00003097          	auipc	ra,0x3
    80000fbc:	b26080e7          	jalr	-1242(ra) # 80003ade <iinit>
    fileinit();      // file table
    80000fc0:	00004097          	auipc	ra,0x4
    80000fc4:	ad6080e7          	jalr	-1322(ra) # 80004a96 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	494080e7          	jalr	1172(ra) # 8000645c <virtio_disk_init>
    userinit();      // first user process
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	ffe080e7          	jalr	-2(ra) # 80001fce <userinit>
    __sync_synchronize();
    80000fd8:	0330000f          	fence	rw,rw
    started = 1;
    80000fdc:	4785                	li	a5,1
    80000fde:	0000a717          	auipc	a4,0xa
    80000fe2:	50f72523          	sw	a5,1290(a4) # 8000b4e8 <started>
    80000fe6:	b789                	j	80000f28 <main+0x56>

0000000080000fe8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fe8:	1141                	addi	sp,sp,-16
    80000fea:	e422                	sd	s0,8(sp)
    80000fec:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fee:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ff2:	0000a797          	auipc	a5,0xa
    80000ff6:	4fe7b783          	ld	a5,1278(a5) # 8000b4f0 <kernel_pagetable>
    80000ffa:	83b1                	srli	a5,a5,0xc
    80000ffc:	577d                	li	a4,-1
    80000ffe:	177e                	slli	a4,a4,0x3f
    80001000:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001002:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001006:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000100a:	6422                	ld	s0,8(sp)
    8000100c:	0141                	addi	sp,sp,16
    8000100e:	8082                	ret

0000000080001010 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001010:	7139                	addi	sp,sp,-64
    80001012:	fc06                	sd	ra,56(sp)
    80001014:	f822                	sd	s0,48(sp)
    80001016:	f426                	sd	s1,40(sp)
    80001018:	f04a                	sd	s2,32(sp)
    8000101a:	ec4e                	sd	s3,24(sp)
    8000101c:	e852                	sd	s4,16(sp)
    8000101e:	e456                	sd	s5,8(sp)
    80001020:	e05a                	sd	s6,0(sp)
    80001022:	0080                	addi	s0,sp,64
    80001024:	84aa                	mv	s1,a0
    80001026:	89ae                	mv	s3,a1
    80001028:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000102a:	57fd                	li	a5,-1
    8000102c:	83e9                	srli	a5,a5,0x1a
    8000102e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001030:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001032:	04b7f263          	bgeu	a5,a1,80001076 <walk+0x66>
    panic("walk");
    80001036:	00007517          	auipc	a0,0x7
    8000103a:	07a50513          	addi	a0,a0,122 # 800080b0 <etext+0xb0>
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	522080e7          	jalr	1314(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001046:	060a8663          	beqz	s5,800010b2 <walk+0xa2>
    8000104a:	00000097          	auipc	ra,0x0
    8000104e:	afe080e7          	jalr	-1282(ra) # 80000b48 <kalloc>
    80001052:	84aa                	mv	s1,a0
    80001054:	c529                	beqz	a0,8000109e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001056:	6605                	lui	a2,0x1
    80001058:	4581                	li	a1,0
    8000105a:	00000097          	auipc	ra,0x0
    8000105e:	cda080e7          	jalr	-806(ra) # 80000d34 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001062:	00c4d793          	srli	a5,s1,0xc
    80001066:	07aa                	slli	a5,a5,0xa
    80001068:	0017e793          	ori	a5,a5,1
    8000106c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001070:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda477>
    80001072:	036a0063          	beq	s4,s6,80001092 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001076:	0149d933          	srl	s2,s3,s4
    8000107a:	1ff97913          	andi	s2,s2,511
    8000107e:	090e                	slli	s2,s2,0x3
    80001080:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001082:	00093483          	ld	s1,0(s2)
    80001086:	0014f793          	andi	a5,s1,1
    8000108a:	dfd5                	beqz	a5,80001046 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000108c:	80a9                	srli	s1,s1,0xa
    8000108e:	04b2                	slli	s1,s1,0xc
    80001090:	b7c5                	j	80001070 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001092:	00c9d513          	srli	a0,s3,0xc
    80001096:	1ff57513          	andi	a0,a0,511
    8000109a:	050e                	slli	a0,a0,0x3
    8000109c:	9526                	add	a0,a0,s1
}
    8000109e:	70e2                	ld	ra,56(sp)
    800010a0:	7442                	ld	s0,48(sp)
    800010a2:	74a2                	ld	s1,40(sp)
    800010a4:	7902                	ld	s2,32(sp)
    800010a6:	69e2                	ld	s3,24(sp)
    800010a8:	6a42                	ld	s4,16(sp)
    800010aa:	6aa2                	ld	s5,8(sp)
    800010ac:	6b02                	ld	s6,0(sp)
    800010ae:	6121                	addi	sp,sp,64
    800010b0:	8082                	ret
        return 0;
    800010b2:	4501                	li	a0,0
    800010b4:	b7ed                	j	8000109e <walk+0x8e>

00000000800010b6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010b6:	57fd                	li	a5,-1
    800010b8:	83e9                	srli	a5,a5,0x1a
    800010ba:	00b7f463          	bgeu	a5,a1,800010c2 <walkaddr+0xc>
    return 0;
    800010be:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010c0:	8082                	ret
{
    800010c2:	1141                	addi	sp,sp,-16
    800010c4:	e406                	sd	ra,8(sp)
    800010c6:	e022                	sd	s0,0(sp)
    800010c8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010ca:	4601                	li	a2,0
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	f44080e7          	jalr	-188(ra) # 80001010 <walk>
  if(pte == 0)
    800010d4:	c105                	beqz	a0,800010f4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010d6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010d8:	0117f693          	andi	a3,a5,17
    800010dc:	4745                	li	a4,17
    return 0;
    800010de:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010e0:	00e68663          	beq	a3,a4,800010ec <walkaddr+0x36>
}
    800010e4:	60a2                	ld	ra,8(sp)
    800010e6:	6402                	ld	s0,0(sp)
    800010e8:	0141                	addi	sp,sp,16
    800010ea:	8082                	ret
  pa = PTE2PA(*pte);
    800010ec:	83a9                	srli	a5,a5,0xa
    800010ee:	00c79513          	slli	a0,a5,0xc
  return pa;
    800010f2:	bfcd                	j	800010e4 <walkaddr+0x2e>
    return 0;
    800010f4:	4501                	li	a0,0
    800010f6:	b7fd                	j	800010e4 <walkaddr+0x2e>

00000000800010f8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010f8:	715d                	addi	sp,sp,-80
    800010fa:	e486                	sd	ra,72(sp)
    800010fc:	e0a2                	sd	s0,64(sp)
    800010fe:	fc26                	sd	s1,56(sp)
    80001100:	f84a                	sd	s2,48(sp)
    80001102:	f44e                	sd	s3,40(sp)
    80001104:	f052                	sd	s4,32(sp)
    80001106:	ec56                	sd	s5,24(sp)
    80001108:	e85a                	sd	s6,16(sp)
    8000110a:	e45e                	sd	s7,8(sp)
    8000110c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000110e:	c639                	beqz	a2,8000115c <mappages+0x64>
    80001110:	8aaa                	mv	s5,a0
    80001112:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001114:	777d                	lui	a4,0xfffff
    80001116:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000111a:	fff58993          	addi	s3,a1,-1
    8000111e:	99b2                	add	s3,s3,a2
    80001120:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001124:	893e                	mv	s2,a5
    80001126:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000112a:	6b85                	lui	s7,0x1
    8000112c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001130:	4605                	li	a2,1
    80001132:	85ca                	mv	a1,s2
    80001134:	8556                	mv	a0,s5
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	eda080e7          	jalr	-294(ra) # 80001010 <walk>
    8000113e:	cd1d                	beqz	a0,8000117c <mappages+0x84>
    if(*pte & PTE_V)
    80001140:	611c                	ld	a5,0(a0)
    80001142:	8b85                	andi	a5,a5,1
    80001144:	e785                	bnez	a5,8000116c <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001146:	80b1                	srli	s1,s1,0xc
    80001148:	04aa                	slli	s1,s1,0xa
    8000114a:	0164e4b3          	or	s1,s1,s6
    8000114e:	0014e493          	ori	s1,s1,1
    80001152:	e104                	sd	s1,0(a0)
    if(a == last)
    80001154:	05390063          	beq	s2,s3,80001194 <mappages+0x9c>
    a += PGSIZE;
    80001158:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000115a:	bfc9                	j	8000112c <mappages+0x34>
    panic("mappages: size");
    8000115c:	00007517          	auipc	a0,0x7
    80001160:	f5c50513          	addi	a0,a0,-164 # 800080b8 <etext+0xb8>
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	3fc080e7          	jalr	1020(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000116c:	00007517          	auipc	a0,0x7
    80001170:	f5c50513          	addi	a0,a0,-164 # 800080c8 <etext+0xc8>
    80001174:	fffff097          	auipc	ra,0xfffff
    80001178:	3ec080e7          	jalr	1004(ra) # 80000560 <panic>
      return -1;
    8000117c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000117e:	60a6                	ld	ra,72(sp)
    80001180:	6406                	ld	s0,64(sp)
    80001182:	74e2                	ld	s1,56(sp)
    80001184:	7942                	ld	s2,48(sp)
    80001186:	79a2                	ld	s3,40(sp)
    80001188:	7a02                	ld	s4,32(sp)
    8000118a:	6ae2                	ld	s5,24(sp)
    8000118c:	6b42                	ld	s6,16(sp)
    8000118e:	6ba2                	ld	s7,8(sp)
    80001190:	6161                	addi	sp,sp,80
    80001192:	8082                	ret
  return 0;
    80001194:	4501                	li	a0,0
    80001196:	b7e5                	j	8000117e <mappages+0x86>

0000000080001198 <kvmmap>:
{
    80001198:	1141                	addi	sp,sp,-16
    8000119a:	e406                	sd	ra,8(sp)
    8000119c:	e022                	sd	s0,0(sp)
    8000119e:	0800                	addi	s0,sp,16
    800011a0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011a2:	86b2                	mv	a3,a2
    800011a4:	863e                	mv	a2,a5
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	f52080e7          	jalr	-174(ra) # 800010f8 <mappages>
    800011ae:	e509                	bnez	a0,800011b8 <kvmmap+0x20>
}
    800011b0:	60a2                	ld	ra,8(sp)
    800011b2:	6402                	ld	s0,0(sp)
    800011b4:	0141                	addi	sp,sp,16
    800011b6:	8082                	ret
    panic("kvmmap");
    800011b8:	00007517          	auipc	a0,0x7
    800011bc:	f2050513          	addi	a0,a0,-224 # 800080d8 <etext+0xd8>
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	3a0080e7          	jalr	928(ra) # 80000560 <panic>

00000000800011c8 <kvmmake>:
{
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	e04a                	sd	s2,0(sp)
    800011d2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	974080e7          	jalr	-1676(ra) # 80000b48 <kalloc>
    800011dc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011de:	6605                	lui	a2,0x1
    800011e0:	4581                	li	a1,0
    800011e2:	00000097          	auipc	ra,0x0
    800011e6:	b52080e7          	jalr	-1198(ra) # 80000d34 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011ea:	4719                	li	a4,6
    800011ec:	6685                	lui	a3,0x1
    800011ee:	10000637          	lui	a2,0x10000
    800011f2:	100005b7          	lui	a1,0x10000
    800011f6:	8526                	mv	a0,s1
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	fa0080e7          	jalr	-96(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001200:	4719                	li	a4,6
    80001202:	6685                	lui	a3,0x1
    80001204:	10001637          	lui	a2,0x10001
    80001208:	100015b7          	lui	a1,0x10001
    8000120c:	8526                	mv	a0,s1
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f8a080e7          	jalr	-118(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001216:	4719                	li	a4,6
    80001218:	004006b7          	lui	a3,0x400
    8000121c:	0c000637          	lui	a2,0xc000
    80001220:	0c0005b7          	lui	a1,0xc000
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	f72080e7          	jalr	-142(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000122e:	00007917          	auipc	s2,0x7
    80001232:	dd290913          	addi	s2,s2,-558 # 80008000 <etext>
    80001236:	4729                	li	a4,10
    80001238:	80007697          	auipc	a3,0x80007
    8000123c:	dc868693          	addi	a3,a3,-568 # 8000 <_entry-0x7fff8000>
    80001240:	4605                	li	a2,1
    80001242:	067e                	slli	a2,a2,0x1f
    80001244:	85b2                	mv	a1,a2
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f50080e7          	jalr	-176(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001250:	46c5                	li	a3,17
    80001252:	06ee                	slli	a3,a3,0x1b
    80001254:	4719                	li	a4,6
    80001256:	412686b3          	sub	a3,a3,s2
    8000125a:	864a                	mv	a2,s2
    8000125c:	85ca                	mv	a1,s2
    8000125e:	8526                	mv	a0,s1
    80001260:	00000097          	auipc	ra,0x0
    80001264:	f38080e7          	jalr	-200(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001268:	4729                	li	a4,10
    8000126a:	6685                	lui	a3,0x1
    8000126c:	00006617          	auipc	a2,0x6
    80001270:	d9460613          	addi	a2,a2,-620 # 80007000 <_trampoline>
    80001274:	040005b7          	lui	a1,0x4000
    80001278:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000127a:	05b2                	slli	a1,a1,0xc
    8000127c:	8526                	mv	a0,s1
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	f1a080e7          	jalr	-230(ra) # 80001198 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001286:	8526                	mv	a0,s1
    80001288:	00001097          	auipc	ra,0x1
    8000128c:	8b0080e7          	jalr	-1872(ra) # 80001b38 <proc_mapstacks>
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6902                	ld	s2,0(sp)
    8000129a:	6105                	addi	sp,sp,32
    8000129c:	8082                	ret

000000008000129e <kvminit>:
{
    8000129e:	1141                	addi	sp,sp,-16
    800012a0:	e406                	sd	ra,8(sp)
    800012a2:	e022                	sd	s0,0(sp)
    800012a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	f22080e7          	jalr	-222(ra) # 800011c8 <kvmmake>
    800012ae:	0000a797          	auipc	a5,0xa
    800012b2:	24a7b123          	sd	a0,578(a5) # 8000b4f0 <kernel_pagetable>
}
    800012b6:	60a2                	ld	ra,8(sp)
    800012b8:	6402                	ld	s0,0(sp)
    800012ba:	0141                	addi	sp,sp,16
    800012bc:	8082                	ret

00000000800012be <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012be:	715d                	addi	sp,sp,-80
    800012c0:	e486                	sd	ra,72(sp)
    800012c2:	e0a2                	sd	s0,64(sp)
    800012c4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012c6:	03459793          	slli	a5,a1,0x34
    800012ca:	e39d                	bnez	a5,800012f0 <uvmunmap+0x32>
    800012cc:	f84a                	sd	s2,48(sp)
    800012ce:	f44e                	sd	s3,40(sp)
    800012d0:	f052                	sd	s4,32(sp)
    800012d2:	ec56                	sd	s5,24(sp)
    800012d4:	e85a                	sd	s6,16(sp)
    800012d6:	e45e                	sd	s7,8(sp)
    800012d8:	8a2a                	mv	s4,a0
    800012da:	892e                	mv	s2,a1
    800012dc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012de:	0632                	slli	a2,a2,0xc
    800012e0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012e4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e6:	6b05                	lui	s6,0x1
    800012e8:	0935fb63          	bgeu	a1,s3,8000137e <uvmunmap+0xc0>
    800012ec:	fc26                	sd	s1,56(sp)
    800012ee:	a8a9                	j	80001348 <uvmunmap+0x8a>
    800012f0:	fc26                	sd	s1,56(sp)
    800012f2:	f84a                	sd	s2,48(sp)
    800012f4:	f44e                	sd	s3,40(sp)
    800012f6:	f052                	sd	s4,32(sp)
    800012f8:	ec56                	sd	s5,24(sp)
    800012fa:	e85a                	sd	s6,16(sp)
    800012fc:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800012fe:	00007517          	auipc	a0,0x7
    80001302:	de250513          	addi	a0,a0,-542 # 800080e0 <etext+0xe0>
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	25a080e7          	jalr	602(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    8000130e:	00007517          	auipc	a0,0x7
    80001312:	dea50513          	addi	a0,a0,-534 # 800080f8 <etext+0xf8>
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	24a080e7          	jalr	586(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    8000131e:	00007517          	auipc	a0,0x7
    80001322:	dea50513          	addi	a0,a0,-534 # 80008108 <etext+0x108>
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	23a080e7          	jalr	570(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    8000132e:	00007517          	auipc	a0,0x7
    80001332:	df250513          	addi	a0,a0,-526 # 80008120 <etext+0x120>
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	22a080e7          	jalr	554(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000133e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001342:	995a                	add	s2,s2,s6
    80001344:	03397c63          	bgeu	s2,s3,8000137c <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001348:	4601                	li	a2,0
    8000134a:	85ca                	mv	a1,s2
    8000134c:	8552                	mv	a0,s4
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	cc2080e7          	jalr	-830(ra) # 80001010 <walk>
    80001356:	84aa                	mv	s1,a0
    80001358:	d95d                	beqz	a0,8000130e <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000135a:	6108                	ld	a0,0(a0)
    8000135c:	00157793          	andi	a5,a0,1
    80001360:	dfdd                	beqz	a5,8000131e <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001362:	3ff57793          	andi	a5,a0,1023
    80001366:	fd7784e3          	beq	a5,s7,8000132e <uvmunmap+0x70>
    if(do_free){
    8000136a:	fc0a8ae3          	beqz	s5,8000133e <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000136e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001370:	0532                	slli	a0,a0,0xc
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	6d8080e7          	jalr	1752(ra) # 80000a4a <kfree>
    8000137a:	b7d1                	j	8000133e <uvmunmap+0x80>
    8000137c:	74e2                	ld	s1,56(sp)
    8000137e:	7942                	ld	s2,48(sp)
    80001380:	79a2                	ld	s3,40(sp)
    80001382:	7a02                	ld	s4,32(sp)
    80001384:	6ae2                	ld	s5,24(sp)
    80001386:	6b42                	ld	s6,16(sp)
    80001388:	6ba2                	ld	s7,8(sp)
  }
}
    8000138a:	60a6                	ld	ra,72(sp)
    8000138c:	6406                	ld	s0,64(sp)
    8000138e:	6161                	addi	sp,sp,80
    80001390:	8082                	ret

0000000080001392 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001392:	1101                	addi	sp,sp,-32
    80001394:	ec06                	sd	ra,24(sp)
    80001396:	e822                	sd	s0,16(sp)
    80001398:	e426                	sd	s1,8(sp)
    8000139a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	7ac080e7          	jalr	1964(ra) # 80000b48 <kalloc>
    800013a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013a6:	c519                	beqz	a0,800013b4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013a8:	6605                	lui	a2,0x1
    800013aa:	4581                	li	a1,0
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	988080e7          	jalr	-1656(ra) # 80000d34 <memset>
  return pagetable;
}
    800013b4:	8526                	mv	a0,s1
    800013b6:	60e2                	ld	ra,24(sp)
    800013b8:	6442                	ld	s0,16(sp)
    800013ba:	64a2                	ld	s1,8(sp)
    800013bc:	6105                	addi	sp,sp,32
    800013be:	8082                	ret

00000000800013c0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013c0:	7179                	addi	sp,sp,-48
    800013c2:	f406                	sd	ra,40(sp)
    800013c4:	f022                	sd	s0,32(sp)
    800013c6:	ec26                	sd	s1,24(sp)
    800013c8:	e84a                	sd	s2,16(sp)
    800013ca:	e44e                	sd	s3,8(sp)
    800013cc:	e052                	sd	s4,0(sp)
    800013ce:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013d0:	6785                	lui	a5,0x1
    800013d2:	04f67863          	bgeu	a2,a5,80001422 <uvmfirst+0x62>
    800013d6:	8a2a                	mv	s4,a0
    800013d8:	89ae                	mv	s3,a1
    800013da:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	76c080e7          	jalr	1900(ra) # 80000b48 <kalloc>
    800013e4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013e6:	6605                	lui	a2,0x1
    800013e8:	4581                	li	a1,0
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	94a080e7          	jalr	-1718(ra) # 80000d34 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013f2:	4779                	li	a4,30
    800013f4:	86ca                	mv	a3,s2
    800013f6:	6605                	lui	a2,0x1
    800013f8:	4581                	li	a1,0
    800013fa:	8552                	mv	a0,s4
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	cfc080e7          	jalr	-772(ra) # 800010f8 <mappages>
  memmove(mem, src, sz);
    80001404:	8626                	mv	a2,s1
    80001406:	85ce                	mv	a1,s3
    80001408:	854a                	mv	a0,s2
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	986080e7          	jalr	-1658(ra) # 80000d90 <memmove>
}
    80001412:	70a2                	ld	ra,40(sp)
    80001414:	7402                	ld	s0,32(sp)
    80001416:	64e2                	ld	s1,24(sp)
    80001418:	6942                	ld	s2,16(sp)
    8000141a:	69a2                	ld	s3,8(sp)
    8000141c:	6a02                	ld	s4,0(sp)
    8000141e:	6145                	addi	sp,sp,48
    80001420:	8082                	ret
    panic("uvmfirst: more than a page");
    80001422:	00007517          	auipc	a0,0x7
    80001426:	d1650513          	addi	a0,a0,-746 # 80008138 <etext+0x138>
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	136080e7          	jalr	310(ra) # 80000560 <panic>

0000000080001432 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001432:	1101                	addi	sp,sp,-32
    80001434:	ec06                	sd	ra,24(sp)
    80001436:	e822                	sd	s0,16(sp)
    80001438:	e426                	sd	s1,8(sp)
    8000143a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000143c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000143e:	00b67d63          	bgeu	a2,a1,80001458 <uvmdealloc+0x26>
    80001442:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001444:	6785                	lui	a5,0x1
    80001446:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001448:	00f60733          	add	a4,a2,a5
    8000144c:	76fd                	lui	a3,0xfffff
    8000144e:	8f75                	and	a4,a4,a3
    80001450:	97ae                	add	a5,a5,a1
    80001452:	8ff5                	and	a5,a5,a3
    80001454:	00f76863          	bltu	a4,a5,80001464 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001458:	8526                	mv	a0,s1
    8000145a:	60e2                	ld	ra,24(sp)
    8000145c:	6442                	ld	s0,16(sp)
    8000145e:	64a2                	ld	s1,8(sp)
    80001460:	6105                	addi	sp,sp,32
    80001462:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001464:	8f99                	sub	a5,a5,a4
    80001466:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001468:	4685                	li	a3,1
    8000146a:	0007861b          	sext.w	a2,a5
    8000146e:	85ba                	mv	a1,a4
    80001470:	00000097          	auipc	ra,0x0
    80001474:	e4e080e7          	jalr	-434(ra) # 800012be <uvmunmap>
    80001478:	b7c5                	j	80001458 <uvmdealloc+0x26>

000000008000147a <uvmalloc>:
  if(newsz < oldsz)
    8000147a:	0ab66b63          	bltu	a2,a1,80001530 <uvmalloc+0xb6>
{
    8000147e:	7139                	addi	sp,sp,-64
    80001480:	fc06                	sd	ra,56(sp)
    80001482:	f822                	sd	s0,48(sp)
    80001484:	ec4e                	sd	s3,24(sp)
    80001486:	e852                	sd	s4,16(sp)
    80001488:	e456                	sd	s5,8(sp)
    8000148a:	0080                	addi	s0,sp,64
    8000148c:	8aaa                	mv	s5,a0
    8000148e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001490:	6785                	lui	a5,0x1
    80001492:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001494:	95be                	add	a1,a1,a5
    80001496:	77fd                	lui	a5,0xfffff
    80001498:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000149c:	08c9fc63          	bgeu	s3,a2,80001534 <uvmalloc+0xba>
    800014a0:	f426                	sd	s1,40(sp)
    800014a2:	f04a                	sd	s2,32(sp)
    800014a4:	e05a                	sd	s6,0(sp)
    800014a6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014a8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800014ac:	fffff097          	auipc	ra,0xfffff
    800014b0:	69c080e7          	jalr	1692(ra) # 80000b48 <kalloc>
    800014b4:	84aa                	mv	s1,a0
    if(mem == 0){
    800014b6:	c915                	beqz	a0,800014ea <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800014b8:	6605                	lui	a2,0x1
    800014ba:	4581                	li	a1,0
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	878080e7          	jalr	-1928(ra) # 80000d34 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014c4:	875a                	mv	a4,s6
    800014c6:	86a6                	mv	a3,s1
    800014c8:	6605                	lui	a2,0x1
    800014ca:	85ca                	mv	a1,s2
    800014cc:	8556                	mv	a0,s5
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	c2a080e7          	jalr	-982(ra) # 800010f8 <mappages>
    800014d6:	ed05                	bnez	a0,8000150e <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014d8:	6785                	lui	a5,0x1
    800014da:	993e                	add	s2,s2,a5
    800014dc:	fd4968e3          	bltu	s2,s4,800014ac <uvmalloc+0x32>
  return newsz;
    800014e0:	8552                	mv	a0,s4
    800014e2:	74a2                	ld	s1,40(sp)
    800014e4:	7902                	ld	s2,32(sp)
    800014e6:	6b02                	ld	s6,0(sp)
    800014e8:	a821                	j	80001500 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    800014ea:	864e                	mv	a2,s3
    800014ec:	85ca                	mv	a1,s2
    800014ee:	8556                	mv	a0,s5
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	f42080e7          	jalr	-190(ra) # 80001432 <uvmdealloc>
      return 0;
    800014f8:	4501                	li	a0,0
    800014fa:	74a2                	ld	s1,40(sp)
    800014fc:	7902                	ld	s2,32(sp)
    800014fe:	6b02                	ld	s6,0(sp)
}
    80001500:	70e2                	ld	ra,56(sp)
    80001502:	7442                	ld	s0,48(sp)
    80001504:	69e2                	ld	s3,24(sp)
    80001506:	6a42                	ld	s4,16(sp)
    80001508:	6aa2                	ld	s5,8(sp)
    8000150a:	6121                	addi	sp,sp,64
    8000150c:	8082                	ret
      kfree(mem);
    8000150e:	8526                	mv	a0,s1
    80001510:	fffff097          	auipc	ra,0xfffff
    80001514:	53a080e7          	jalr	1338(ra) # 80000a4a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001518:	864e                	mv	a2,s3
    8000151a:	85ca                	mv	a1,s2
    8000151c:	8556                	mv	a0,s5
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f14080e7          	jalr	-236(ra) # 80001432 <uvmdealloc>
      return 0;
    80001526:	4501                	li	a0,0
    80001528:	74a2                	ld	s1,40(sp)
    8000152a:	7902                	ld	s2,32(sp)
    8000152c:	6b02                	ld	s6,0(sp)
    8000152e:	bfc9                	j	80001500 <uvmalloc+0x86>
    return oldsz;
    80001530:	852e                	mv	a0,a1
}
    80001532:	8082                	ret
  return newsz;
    80001534:	8532                	mv	a0,a2
    80001536:	b7e9                	j	80001500 <uvmalloc+0x86>

0000000080001538 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001538:	7179                	addi	sp,sp,-48
    8000153a:	f406                	sd	ra,40(sp)
    8000153c:	f022                	sd	s0,32(sp)
    8000153e:	ec26                	sd	s1,24(sp)
    80001540:	e84a                	sd	s2,16(sp)
    80001542:	e44e                	sd	s3,8(sp)
    80001544:	e052                	sd	s4,0(sp)
    80001546:	1800                	addi	s0,sp,48
    80001548:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000154a:	84aa                	mv	s1,a0
    8000154c:	6905                	lui	s2,0x1
    8000154e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001550:	4985                	li	s3,1
    80001552:	a829                	j	8000156c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001554:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001556:	00c79513          	slli	a0,a5,0xc
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	fde080e7          	jalr	-34(ra) # 80001538 <freewalk>
      pagetable[i] = 0;
    80001562:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001566:	04a1                	addi	s1,s1,8
    80001568:	03248163          	beq	s1,s2,8000158a <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000156c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000156e:	00f7f713          	andi	a4,a5,15
    80001572:	ff3701e3          	beq	a4,s3,80001554 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001576:	8b85                	andi	a5,a5,1
    80001578:	d7fd                	beqz	a5,80001566 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000157a:	00007517          	auipc	a0,0x7
    8000157e:	bde50513          	addi	a0,a0,-1058 # 80008158 <etext+0x158>
    80001582:	fffff097          	auipc	ra,0xfffff
    80001586:	fde080e7          	jalr	-34(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    8000158a:	8552                	mv	a0,s4
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	4be080e7          	jalr	1214(ra) # 80000a4a <kfree>
}
    80001594:	70a2                	ld	ra,40(sp)
    80001596:	7402                	ld	s0,32(sp)
    80001598:	64e2                	ld	s1,24(sp)
    8000159a:	6942                	ld	s2,16(sp)
    8000159c:	69a2                	ld	s3,8(sp)
    8000159e:	6a02                	ld	s4,0(sp)
    800015a0:	6145                	addi	sp,sp,48
    800015a2:	8082                	ret

00000000800015a4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015a4:	1101                	addi	sp,sp,-32
    800015a6:	ec06                	sd	ra,24(sp)
    800015a8:	e822                	sd	s0,16(sp)
    800015aa:	e426                	sd	s1,8(sp)
    800015ac:	1000                	addi	s0,sp,32
    800015ae:	84aa                	mv	s1,a0
  if(sz > 0)
    800015b0:	e999                	bnez	a1,800015c6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015b2:	8526                	mv	a0,s1
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	f84080e7          	jalr	-124(ra) # 80001538 <freewalk>
}
    800015bc:	60e2                	ld	ra,24(sp)
    800015be:	6442                	ld	s0,16(sp)
    800015c0:	64a2                	ld	s1,8(sp)
    800015c2:	6105                	addi	sp,sp,32
    800015c4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015c6:	6785                	lui	a5,0x1
    800015c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ca:	95be                	add	a1,a1,a5
    800015cc:	4685                	li	a3,1
    800015ce:	00c5d613          	srli	a2,a1,0xc
    800015d2:	4581                	li	a1,0
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	cea080e7          	jalr	-790(ra) # 800012be <uvmunmap>
    800015dc:	bfd9                	j	800015b2 <uvmfree+0xe>

00000000800015de <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015de:	c679                	beqz	a2,800016ac <uvmcopy+0xce>
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	0880                	addi	s0,sp,80
    800015f6:	8b2a                	mv	s6,a0
    800015f8:	8aae                	mv	s5,a1
    800015fa:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015fc:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015fe:	4601                	li	a2,0
    80001600:	85ce                	mv	a1,s3
    80001602:	855a                	mv	a0,s6
    80001604:	00000097          	auipc	ra,0x0
    80001608:	a0c080e7          	jalr	-1524(ra) # 80001010 <walk>
    8000160c:	c531                	beqz	a0,80001658 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000160e:	6118                	ld	a4,0(a0)
    80001610:	00177793          	andi	a5,a4,1
    80001614:	cbb1                	beqz	a5,80001668 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001616:	00a75593          	srli	a1,a4,0xa
    8000161a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000161e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	526080e7          	jalr	1318(ra) # 80000b48 <kalloc>
    8000162a:	892a                	mv	s2,a0
    8000162c:	c939                	beqz	a0,80001682 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000162e:	6605                	lui	a2,0x1
    80001630:	85de                	mv	a1,s7
    80001632:	fffff097          	auipc	ra,0xfffff
    80001636:	75e080e7          	jalr	1886(ra) # 80000d90 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000163a:	8726                	mv	a4,s1
    8000163c:	86ca                	mv	a3,s2
    8000163e:	6605                	lui	a2,0x1
    80001640:	85ce                	mv	a1,s3
    80001642:	8556                	mv	a0,s5
    80001644:	00000097          	auipc	ra,0x0
    80001648:	ab4080e7          	jalr	-1356(ra) # 800010f8 <mappages>
    8000164c:	e515                	bnez	a0,80001678 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000164e:	6785                	lui	a5,0x1
    80001650:	99be                	add	s3,s3,a5
    80001652:	fb49e6e3          	bltu	s3,s4,800015fe <uvmcopy+0x20>
    80001656:	a081                	j	80001696 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b1050513          	addi	a0,a0,-1264 # 80008168 <etext+0x168>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001668:	00007517          	auipc	a0,0x7
    8000166c:	b2050513          	addi	a0,a0,-1248 # 80008188 <etext+0x188>
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	ef0080e7          	jalr	-272(ra) # 80000560 <panic>
      kfree(mem);
    80001678:	854a                	mv	a0,s2
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	3d0080e7          	jalr	976(ra) # 80000a4a <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001682:	4685                	li	a3,1
    80001684:	00c9d613          	srli	a2,s3,0xc
    80001688:	4581                	li	a1,0
    8000168a:	8556                	mv	a0,s5
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	c32080e7          	jalr	-974(ra) # 800012be <uvmunmap>
  return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6161                	addi	sp,sp,80
    800016aa:	8082                	ret
  return 0;
    800016ac:	4501                	li	a0,0
}
    800016ae:	8082                	ret

00000000800016b0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016b0:	1141                	addi	sp,sp,-16
    800016b2:	e406                	sd	ra,8(sp)
    800016b4:	e022                	sd	s0,0(sp)
    800016b6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016b8:	4601                	li	a2,0
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	956080e7          	jalr	-1706(ra) # 80001010 <walk>
  if(pte == 0)
    800016c2:	c901                	beqz	a0,800016d2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016c4:	611c                	ld	a5,0(a0)
    800016c6:	9bbd                	andi	a5,a5,-17
    800016c8:	e11c                	sd	a5,0(a0)
}
    800016ca:	60a2                	ld	ra,8(sp)
    800016cc:	6402                	ld	s0,0(sp)
    800016ce:	0141                	addi	sp,sp,16
    800016d0:	8082                	ret
    panic("uvmclear");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	ad650513          	addi	a0,a0,-1322 # 800081a8 <etext+0x1a8>
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	e86080e7          	jalr	-378(ra) # 80000560 <panic>

00000000800016e2 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016e2:	c6bd                	beqz	a3,80001750 <copyout+0x6e>
{
    800016e4:	715d                	addi	sp,sp,-80
    800016e6:	e486                	sd	ra,72(sp)
    800016e8:	e0a2                	sd	s0,64(sp)
    800016ea:	fc26                	sd	s1,56(sp)
    800016ec:	f84a                	sd	s2,48(sp)
    800016ee:	f44e                	sd	s3,40(sp)
    800016f0:	f052                	sd	s4,32(sp)
    800016f2:	ec56                	sd	s5,24(sp)
    800016f4:	e85a                	sd	s6,16(sp)
    800016f6:	e45e                	sd	s7,8(sp)
    800016f8:	e062                	sd	s8,0(sp)
    800016fa:	0880                	addi	s0,sp,80
    800016fc:	8b2a                	mv	s6,a0
    800016fe:	8c2e                	mv	s8,a1
    80001700:	8a32                	mv	s4,a2
    80001702:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001704:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001706:	6a85                	lui	s5,0x1
    80001708:	a015                	j	8000172c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000170a:	9562                	add	a0,a0,s8
    8000170c:	0004861b          	sext.w	a2,s1
    80001710:	85d2                	mv	a1,s4
    80001712:	41250533          	sub	a0,a0,s2
    80001716:	fffff097          	auipc	ra,0xfffff
    8000171a:	67a080e7          	jalr	1658(ra) # 80000d90 <memmove>

    len -= n;
    8000171e:	409989b3          	sub	s3,s3,s1
    src += n;
    80001722:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001724:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001728:	02098263          	beqz	s3,8000174c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000172c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001730:	85ca                	mv	a1,s2
    80001732:	855a                	mv	a0,s6
    80001734:	00000097          	auipc	ra,0x0
    80001738:	982080e7          	jalr	-1662(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    8000173c:	cd01                	beqz	a0,80001754 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000173e:	418904b3          	sub	s1,s2,s8
    80001742:	94d6                	add	s1,s1,s5
    if(n > len)
    80001744:	fc99f3e3          	bgeu	s3,s1,8000170a <copyout+0x28>
    80001748:	84ce                	mv	s1,s3
    8000174a:	b7c1                	j	8000170a <copyout+0x28>
  }
  return 0;
    8000174c:	4501                	li	a0,0
    8000174e:	a021                	j	80001756 <copyout+0x74>
    80001750:	4501                	li	a0,0
}
    80001752:	8082                	ret
      return -1;
    80001754:	557d                	li	a0,-1
}
    80001756:	60a6                	ld	ra,72(sp)
    80001758:	6406                	ld	s0,64(sp)
    8000175a:	74e2                	ld	s1,56(sp)
    8000175c:	7942                	ld	s2,48(sp)
    8000175e:	79a2                	ld	s3,40(sp)
    80001760:	7a02                	ld	s4,32(sp)
    80001762:	6ae2                	ld	s5,24(sp)
    80001764:	6b42                	ld	s6,16(sp)
    80001766:	6ba2                	ld	s7,8(sp)
    80001768:	6c02                	ld	s8,0(sp)
    8000176a:	6161                	addi	sp,sp,80
    8000176c:	8082                	ret

000000008000176e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000176e:	caa5                	beqz	a3,800017de <copyin+0x70>
{
    80001770:	715d                	addi	sp,sp,-80
    80001772:	e486                	sd	ra,72(sp)
    80001774:	e0a2                	sd	s0,64(sp)
    80001776:	fc26                	sd	s1,56(sp)
    80001778:	f84a                	sd	s2,48(sp)
    8000177a:	f44e                	sd	s3,40(sp)
    8000177c:	f052                	sd	s4,32(sp)
    8000177e:	ec56                	sd	s5,24(sp)
    80001780:	e85a                	sd	s6,16(sp)
    80001782:	e45e                	sd	s7,8(sp)
    80001784:	e062                	sd	s8,0(sp)
    80001786:	0880                	addi	s0,sp,80
    80001788:	8b2a                	mv	s6,a0
    8000178a:	8a2e                	mv	s4,a1
    8000178c:	8c32                	mv	s8,a2
    8000178e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001790:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001792:	6a85                	lui	s5,0x1
    80001794:	a01d                	j	800017ba <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001796:	018505b3          	add	a1,a0,s8
    8000179a:	0004861b          	sext.w	a2,s1
    8000179e:	412585b3          	sub	a1,a1,s2
    800017a2:	8552                	mv	a0,s4
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	5ec080e7          	jalr	1516(ra) # 80000d90 <memmove>

    len -= n;
    800017ac:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017b0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017b2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017b6:	02098263          	beqz	s3,800017da <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017ba:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017be:	85ca                	mv	a1,s2
    800017c0:	855a                	mv	a0,s6
    800017c2:	00000097          	auipc	ra,0x0
    800017c6:	8f4080e7          	jalr	-1804(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    800017ca:	cd01                	beqz	a0,800017e2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017cc:	418904b3          	sub	s1,s2,s8
    800017d0:	94d6                	add	s1,s1,s5
    if(n > len)
    800017d2:	fc99f2e3          	bgeu	s3,s1,80001796 <copyin+0x28>
    800017d6:	84ce                	mv	s1,s3
    800017d8:	bf7d                	j	80001796 <copyin+0x28>
  }
  return 0;
    800017da:	4501                	li	a0,0
    800017dc:	a021                	j	800017e4 <copyin+0x76>
    800017de:	4501                	li	a0,0
}
    800017e0:	8082                	ret
      return -1;
    800017e2:	557d                	li	a0,-1
}
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6c02                	ld	s8,0(sp)
    800017f8:	6161                	addi	sp,sp,80
    800017fa:	8082                	ret

00000000800017fc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017fc:	cacd                	beqz	a3,800018ae <copyinstr+0xb2>
{
    800017fe:	715d                	addi	sp,sp,-80
    80001800:	e486                	sd	ra,72(sp)
    80001802:	e0a2                	sd	s0,64(sp)
    80001804:	fc26                	sd	s1,56(sp)
    80001806:	f84a                	sd	s2,48(sp)
    80001808:	f44e                	sd	s3,40(sp)
    8000180a:	f052                	sd	s4,32(sp)
    8000180c:	ec56                	sd	s5,24(sp)
    8000180e:	e85a                	sd	s6,16(sp)
    80001810:	e45e                	sd	s7,8(sp)
    80001812:	0880                	addi	s0,sp,80
    80001814:	8a2a                	mv	s4,a0
    80001816:	8b2e                	mv	s6,a1
    80001818:	8bb2                	mv	s7,a2
    8000181a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    8000181c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000181e:	6985                	lui	s3,0x1
    80001820:	a825                	j	80001858 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001822:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001826:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001828:	37fd                	addiw	a5,a5,-1
    8000182a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000182e:	60a6                	ld	ra,72(sp)
    80001830:	6406                	ld	s0,64(sp)
    80001832:	74e2                	ld	s1,56(sp)
    80001834:	7942                	ld	s2,48(sp)
    80001836:	79a2                	ld	s3,40(sp)
    80001838:	7a02                	ld	s4,32(sp)
    8000183a:	6ae2                	ld	s5,24(sp)
    8000183c:	6b42                	ld	s6,16(sp)
    8000183e:	6ba2                	ld	s7,8(sp)
    80001840:	6161                	addi	sp,sp,80
    80001842:	8082                	ret
    80001844:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001848:	9742                	add	a4,a4,a6
      --max;
    8000184a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    8000184e:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001852:	04e58663          	beq	a1,a4,8000189e <copyinstr+0xa2>
{
    80001856:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001858:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000185c:	85a6                	mv	a1,s1
    8000185e:	8552                	mv	a0,s4
    80001860:	00000097          	auipc	ra,0x0
    80001864:	856080e7          	jalr	-1962(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    80001868:	cd0d                	beqz	a0,800018a2 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    8000186a:	417486b3          	sub	a3,s1,s7
    8000186e:	96ce                	add	a3,a3,s3
    if(n > max)
    80001870:	00d97363          	bgeu	s2,a3,80001876 <copyinstr+0x7a>
    80001874:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001876:	955e                	add	a0,a0,s7
    80001878:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000187a:	c695                	beqz	a3,800018a6 <copyinstr+0xaa>
    8000187c:	87da                	mv	a5,s6
    8000187e:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001880:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001884:	96da                	add	a3,a3,s6
    80001886:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001888:	00f60733          	add	a4,a2,a5
    8000188c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffda480>
    80001890:	db49                	beqz	a4,80001822 <copyinstr+0x26>
        *dst = *p;
    80001892:	00e78023          	sb	a4,0(a5)
      dst++;
    80001896:	0785                	addi	a5,a5,1
    while(n > 0){
    80001898:	fed797e3          	bne	a5,a3,80001886 <copyinstr+0x8a>
    8000189c:	b765                	j	80001844 <copyinstr+0x48>
    8000189e:	4781                	li	a5,0
    800018a0:	b761                	j	80001828 <copyinstr+0x2c>
      return -1;
    800018a2:	557d                	li	a0,-1
    800018a4:	b769                	j	8000182e <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800018a6:	6b85                	lui	s7,0x1
    800018a8:	9ba6                	add	s7,s7,s1
    800018aa:	87da                	mv	a5,s6
    800018ac:	b76d                	j	80001856 <copyinstr+0x5a>
  int got_null = 0;
    800018ae:	4781                	li	a5,0
  if(got_null){
    800018b0:	37fd                	addiw	a5,a5,-1
    800018b2:	0007851b          	sext.w	a0,a5
}
    800018b6:	8082                	ret

00000000800018b8 <rr_scheduler>:
        old_scheduler = sched_pointer;
    }
}

void rr_scheduler(void)
{
    800018b8:	7139                	addi	sp,sp,-64
    800018ba:	fc06                	sd	ra,56(sp)
    800018bc:	f822                	sd	s0,48(sp)
    800018be:	f426                	sd	s1,40(sp)
    800018c0:	f04a                	sd	s2,32(sp)
    800018c2:	ec4e                	sd	s3,24(sp)
    800018c4:	e852                	sd	s4,16(sp)
    800018c6:	e456                	sd	s5,8(sp)
    800018c8:	e05a                	sd	s6,0(sp)
    800018ca:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    800018cc:	8792                	mv	a5,tp
    int id = r_tp();
    800018ce:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    800018d0:	00012a97          	auipc	s5,0x12
    800018d4:	ea0a8a93          	addi	s5,s5,-352 # 80013770 <cpus>
    800018d8:	00779713          	slli	a4,a5,0x7
    800018dc:	00ea86b3          	add	a3,s5,a4
    800018e0:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffda480>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018e4:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800018e8:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018ec:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    800018f0:	0721                	addi	a4,a4,8
    800018f2:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    800018f4:	00012497          	auipc	s1,0x12
    800018f8:	2ac48493          	addi	s1,s1,684 # 80013ba0 <proc>
        if (p->state == RUNNABLE)
    800018fc:	498d                	li	s3,3
            p->state = RUNNING;
    800018fe:	4b11                	li	s6,4
            c->proc = p;
    80001900:	079e                	slli	a5,a5,0x7
    80001902:	00012a17          	auipc	s4,0x12
    80001906:	e6ea0a13          	addi	s4,s4,-402 # 80013770 <cpus>
    8000190a:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    8000190c:	00018917          	auipc	s2,0x18
    80001910:	e9490913          	addi	s2,s2,-364 # 800197a0 <tickslock>
    80001914:	a811                	j	80001928 <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    80001916:	8526                	mv	a0,s1
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	3d4080e7          	jalr	980(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001920:	17048493          	addi	s1,s1,368
    80001924:	03248863          	beq	s1,s2,80001954 <rr_scheduler+0x9c>
        acquire(&p->lock);
    80001928:	8526                	mv	a0,s1
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	30e080e7          	jalr	782(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE)
    80001932:	4c9c                	lw	a5,24(s1)
    80001934:	ff3791e3          	bne	a5,s3,80001916 <rr_scheduler+0x5e>
            p->state = RUNNING;
    80001938:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    8000193c:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    80001940:	06848593          	addi	a1,s1,104
    80001944:	8556                	mv	a0,s5
    80001946:	00001097          	auipc	ra,0x1
    8000194a:	236080e7          	jalr	566(ra) # 80002b7c <swtch>
            c->proc = 0;
    8000194e:	000a3023          	sd	zero,0(s4)
    80001952:	b7d1                	j	80001916 <rr_scheduler+0x5e>
    }
    // In case a setsched happened, we will switch to the new scheduler after one
    // Round Robin round has completed.
}
    80001954:	70e2                	ld	ra,56(sp)
    80001956:	7442                	ld	s0,48(sp)
    80001958:	74a2                	ld	s1,40(sp)
    8000195a:	7902                	ld	s2,32(sp)
    8000195c:	69e2                	ld	s3,24(sp)
    8000195e:	6a42                	ld	s4,16(sp)
    80001960:	6aa2                	ld	s5,8(sp)
    80001962:	6b02                	ld	s6,0(sp)
    80001964:	6121                	addi	sp,sp,64
    80001966:	8082                	ret

0000000080001968 <mlfq_scheduler>:


void mlfq_scheduler(void) {
    80001968:	bb010113          	addi	sp,sp,-1104
    8000196c:	44113423          	sd	ra,1096(sp)
    80001970:	44813023          	sd	s0,1088(sp)
    80001974:	42913c23          	sd	s1,1080(sp)
    80001978:	43213823          	sd	s2,1072(sp)
    8000197c:	43313423          	sd	s3,1064(sp)
    80001980:	43413023          	sd	s4,1056(sp)
    80001984:	41513c23          	sd	s5,1048(sp)
    80001988:	41613823          	sd	s6,1040(sp)
    8000198c:	41713423          	sd	s7,1032(sp)
    80001990:	41813023          	sd	s8,1024(sp)
    80001994:	45010413          	addi	s0,sp,1104
  asm volatile("mv %0, tp" : "=r" (x) );
    80001998:	8b12                	mv	s6,tp
    int id = r_tp();
    8000199a:	2b01                	sext.w	s6,s6
    int indexMed = 0;

    struct proc *p; // get process struct
    struct cpu *c = mycpu(); // get cpu

    c->proc = 0; // set cpu process to none
    8000199c:	007b1713          	slli	a4,s6,0x7
    800019a0:	00012797          	auipc	a5,0x12
    800019a4:	dd078793          	addi	a5,a5,-560 # 80013770 <cpus>
    800019a8:	97ba                	add	a5,a5,a4
    800019aa:	0007b023          	sd	zero,0(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800019b2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019b6:	10079073          	csrw	sstatus,a5

    intr_on(); // enable interrupts


    // add processes to correct queue
    for (p = proc; p < &proc[NPROC]; p++) {
    800019ba:	00012497          	auipc	s1,0x12
    800019be:	1e648493          	addi	s1,s1,486 # 80013ba0 <proc>
    int indexMed = 0;
    800019c2:	4a81                	li	s5,0
    int indexHigh = 0;
    800019c4:	4a01                	li	s4,0
        acquire(&p->lock);
        if (p->state == RUNNABLE) {
    800019c6:	498d                	li	s3,3
            
            if (p->priority == 0) {
                highPriority[indexHigh] = p;
                indexHigh++;
            } else if (p->priority == 1) {
    800019c8:	4b85                	li	s7,1
    for (p = proc; p < &proc[NPROC]; p++) {
    800019ca:	00018917          	auipc	s2,0x18
    800019ce:	dd690913          	addi	s2,s2,-554 # 800197a0 <tickslock>
    800019d2:	a821                	j	800019ea <mlfq_scheduler+0x82>
            } else if (p->priority == 1) {
    800019d4:	03778e63          	beq	a5,s7,80001a10 <mlfq_scheduler+0xa8>
                mediumPriority[indexMed] = p;
                indexMed++;
            }
        }
        release(&p->lock);
    800019d8:	8526                	mv	a0,s1
    800019da:	fffff097          	auipc	ra,0xfffff
    800019de:	312080e7          	jalr	786(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800019e2:	17048493          	addi	s1,s1,368
    800019e6:	03248e63          	beq	s1,s2,80001a22 <mlfq_scheduler+0xba>
        acquire(&p->lock);
    800019ea:	8526                	mv	a0,s1
    800019ec:	fffff097          	auipc	ra,0xfffff
    800019f0:	24c080e7          	jalr	588(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE) {
    800019f4:	4c9c                	lw	a5,24(s1)
    800019f6:	ff3791e3          	bne	a5,s3,800019d8 <mlfq_scheduler+0x70>
            if (p->priority == 0) {
    800019fa:	40bc                	lw	a5,64(s1)
    800019fc:	ffe1                	bnez	a5,800019d4 <mlfq_scheduler+0x6c>
                highPriority[indexHigh] = p;
    800019fe:	003a1793          	slli	a5,s4,0x3
    80001a02:	fb078793          	addi	a5,a5,-80
    80001a06:	97a2                	add	a5,a5,s0
    80001a08:	e097b023          	sd	s1,-512(a5)
                indexHigh++;
    80001a0c:	2a05                	addiw	s4,s4,1
    80001a0e:	b7e9                	j	800019d8 <mlfq_scheduler+0x70>
                mediumPriority[indexMed] = p;
    80001a10:	003a9793          	slli	a5,s5,0x3
    80001a14:	fb078793          	addi	a5,a5,-80
    80001a18:	97a2                	add	a5,a5,s0
    80001a1a:	c097b023          	sd	s1,-1024(a5)
                indexMed++;
    80001a1e:	2a85                	addiw	s5,s5,1
    80001a20:	bf65                	j	800019d8 <mlfq_scheduler+0x70>

    }
    // run the high priority queue and demote to medium

    for (int i = 0; i < indexHigh; i++) {
    80001a22:	07405963          	blez	s4,80001a94 <mlfq_scheduler+0x12c>
        p = highPriority[i];
        acquire(&p->lock);
        if (p->state == RUNNABLE) {
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    80001a26:	007b1b93          	slli	s7,s6,0x7
    80001a2a:	00012797          	auipc	a5,0x12
    80001a2e:	d4e78793          	addi	a5,a5,-690 # 80013778 <cpus+0x8>
    80001a32:	9bbe                	add	s7,s7,a5
    80001a34:	db040913          	addi	s2,s0,-592
    80001a38:	003a1993          	slli	s3,s4,0x3
    80001a3c:	99ca                	add	s3,s3,s2
        if (p->state == RUNNABLE) {
    80001a3e:	4a0d                	li	s4,3
            p->state = RUNNING;
    80001a40:	4c11                	li	s8,4
            c->proc = p;
    80001a42:	0b1e                	slli	s6,s6,0x7
    80001a44:	00012a97          	auipc	s5,0x12
    80001a48:	d2ca8a93          	addi	s5,s5,-724 # 80013770 <cpus>
    80001a4c:	9ada                	add	s5,s5,s6
    80001a4e:	a809                	j	80001a60 <mlfq_scheduler+0xf8>

            p->time_ticks = 0; // reset time ticks
            c->proc = 0;           
        }

        release(&p->lock);
    80001a50:	8526                	mv	a0,s1
    80001a52:	fffff097          	auipc	ra,0xfffff
    80001a56:	29a080e7          	jalr	666(ra) # 80000cec <release>
    for (int i = 0; i < indexHigh; i++) {
    80001a5a:	0921                	addi	s2,s2,8
    80001a5c:	0b390763          	beq	s2,s3,80001b0a <mlfq_scheduler+0x1a2>
        p = highPriority[i];
    80001a60:	00093483          	ld	s1,0(s2)
        acquire(&p->lock);
    80001a64:	8526                	mv	a0,s1
    80001a66:	fffff097          	auipc	ra,0xfffff
    80001a6a:	1d2080e7          	jalr	466(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE) {
    80001a6e:	4c9c                	lw	a5,24(s1)
    80001a70:	ff4790e3          	bne	a5,s4,80001a50 <mlfq_scheduler+0xe8>
            p->state = RUNNING;
    80001a74:	0184ac23          	sw	s8,24(s1)
            c->proc = p;
    80001a78:	009ab023          	sd	s1,0(s5)
            swtch(&c->context, &p->context);
    80001a7c:	06848593          	addi	a1,s1,104
    80001a80:	855e                	mv	a0,s7
    80001a82:	00001097          	auipc	ra,0x1
    80001a86:	0fa080e7          	jalr	250(ra) # 80002b7c <swtch>
            p->time_ticks = 0; // reset time ticks
    80001a8a:	0404a223          	sw	zero,68(s1)
            c->proc = 0;           
    80001a8e:	000ab023          	sd	zero,0(s5)
    80001a92:	bf7d                	j	80001a50 <mlfq_scheduler+0xe8>

    }
    // if no process in high priority queue, then go through medium queue
    if (indexHigh == 0) {
    80001a94:	060a1b63          	bnez	s4,80001b0a <mlfq_scheduler+0x1a2>
        for (int i = 0; i < indexMed; i++) {
    80001a98:	07505963          	blez	s5,80001b0a <mlfq_scheduler+0x1a2>
            p = mediumPriority[i];
            acquire(&p->lock);
            if (p->state == RUNNABLE) {
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    80001a9c:	007b1b93          	slli	s7,s6,0x7
    80001aa0:	00012797          	auipc	a5,0x12
    80001aa4:	cd878793          	addi	a5,a5,-808 # 80013778 <cpus+0x8>
    80001aa8:	9bbe                	add	s7,s7,a5
    80001aaa:	bb040993          	addi	s3,s0,-1104
    80001aae:	003a9913          	slli	s2,s5,0x3
    80001ab2:	994e                	add	s2,s2,s3
            if (p->state == RUNNABLE) {
    80001ab4:	4a0d                	li	s4,3
                p->state = RUNNING;
    80001ab6:	4c11                	li	s8,4
                c->proc = p;
    80001ab8:	0b1e                	slli	s6,s6,0x7
    80001aba:	00012a97          	auipc	s5,0x12
    80001abe:	cb6a8a93          	addi	s5,s5,-842 # 80013770 <cpus>
    80001ac2:	9ada                	add	s5,s5,s6
    80001ac4:	a809                	j	80001ad6 <mlfq_scheduler+0x16e>
                c->proc = 0;
                // update priority based on time slice

            }

            release(&p->lock);
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	fffff097          	auipc	ra,0xfffff
    80001acc:	224080e7          	jalr	548(ra) # 80000cec <release>
        for (int i = 0; i < indexMed; i++) {
    80001ad0:	09a1                	addi	s3,s3,8 # 1008 <_entry-0x7fffeff8>
    80001ad2:	03298c63          	beq	s3,s2,80001b0a <mlfq_scheduler+0x1a2>
            p = mediumPriority[i];
    80001ad6:	0009b483          	ld	s1,0(s3)
            acquire(&p->lock);
    80001ada:	8526                	mv	a0,s1
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	15c080e7          	jalr	348(ra) # 80000c38 <acquire>
            if (p->state == RUNNABLE) {
    80001ae4:	4c9c                	lw	a5,24(s1)
    80001ae6:	ff4790e3          	bne	a5,s4,80001ac6 <mlfq_scheduler+0x15e>
                p->state = RUNNING;
    80001aea:	0184ac23          	sw	s8,24(s1)
                c->proc = p;
    80001aee:	009ab023          	sd	s1,0(s5)
                swtch(&c->context, &p->context);
    80001af2:	06848593          	addi	a1,s1,104
    80001af6:	855e                	mv	a0,s7
    80001af8:	00001097          	auipc	ra,0x1
    80001afc:	084080e7          	jalr	132(ra) # 80002b7c <swtch>
                p->time_ticks = 0;
    80001b00:	0404a223          	sw	zero,68(s1)
                c->proc = 0;
    80001b04:	000ab023          	sd	zero,0(s5)
    80001b08:	bf7d                	j	80001ac6 <mlfq_scheduler+0x15e>

        }

    }

}
    80001b0a:	44813083          	ld	ra,1096(sp)
    80001b0e:	44013403          	ld	s0,1088(sp)
    80001b12:	43813483          	ld	s1,1080(sp)
    80001b16:	43013903          	ld	s2,1072(sp)
    80001b1a:	42813983          	ld	s3,1064(sp)
    80001b1e:	42013a03          	ld	s4,1056(sp)
    80001b22:	41813a83          	ld	s5,1048(sp)
    80001b26:	41013b03          	ld	s6,1040(sp)
    80001b2a:	40813b83          	ld	s7,1032(sp)
    80001b2e:	40013c03          	ld	s8,1024(sp)
    80001b32:	45010113          	addi	sp,sp,1104
    80001b36:	8082                	ret

0000000080001b38 <proc_mapstacks>:
{
    80001b38:	7139                	addi	sp,sp,-64
    80001b3a:	fc06                	sd	ra,56(sp)
    80001b3c:	f822                	sd	s0,48(sp)
    80001b3e:	f426                	sd	s1,40(sp)
    80001b40:	f04a                	sd	s2,32(sp)
    80001b42:	ec4e                	sd	s3,24(sp)
    80001b44:	e852                	sd	s4,16(sp)
    80001b46:	e456                	sd	s5,8(sp)
    80001b48:	e05a                	sd	s6,0(sp)
    80001b4a:	0080                	addi	s0,sp,64
    80001b4c:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001b4e:	00012497          	auipc	s1,0x12
    80001b52:	05248493          	addi	s1,s1,82 # 80013ba0 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001b56:	8b26                	mv	s6,s1
    80001b58:	ff4df937          	lui	s2,0xff4df
    80001b5c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e3d>
    80001b60:	0936                	slli	s2,s2,0xd
    80001b62:	6f590913          	addi	s2,s2,1781
    80001b66:	0936                	slli	s2,s2,0xd
    80001b68:	bd390913          	addi	s2,s2,-1069
    80001b6c:	0932                	slli	s2,s2,0xc
    80001b6e:	7a790913          	addi	s2,s2,1959
    80001b72:	040009b7          	lui	s3,0x4000
    80001b76:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b78:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001b7a:	00018a97          	auipc	s5,0x18
    80001b7e:	c26a8a93          	addi	s5,s5,-986 # 800197a0 <tickslock>
        char *pa = kalloc();
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	fc6080e7          	jalr	-58(ra) # 80000b48 <kalloc>
    80001b8a:	862a                	mv	a2,a0
        if (pa == 0)
    80001b8c:	c121                	beqz	a0,80001bcc <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80001b8e:	416485b3          	sub	a1,s1,s6
    80001b92:	8591                	srai	a1,a1,0x4
    80001b94:	032585b3          	mul	a1,a1,s2
    80001b98:	2585                	addiw	a1,a1,1
    80001b9a:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b9e:	4719                	li	a4,6
    80001ba0:	6685                	lui	a3,0x1
    80001ba2:	40b985b3          	sub	a1,s3,a1
    80001ba6:	8552                	mv	a0,s4
    80001ba8:	fffff097          	auipc	ra,0xfffff
    80001bac:	5f0080e7          	jalr	1520(ra) # 80001198 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001bb0:	17048493          	addi	s1,s1,368
    80001bb4:	fd5497e3          	bne	s1,s5,80001b82 <proc_mapstacks+0x4a>
}
    80001bb8:	70e2                	ld	ra,56(sp)
    80001bba:	7442                	ld	s0,48(sp)
    80001bbc:	74a2                	ld	s1,40(sp)
    80001bbe:	7902                	ld	s2,32(sp)
    80001bc0:	69e2                	ld	s3,24(sp)
    80001bc2:	6a42                	ld	s4,16(sp)
    80001bc4:	6aa2                	ld	s5,8(sp)
    80001bc6:	6b02                	ld	s6,0(sp)
    80001bc8:	6121                	addi	sp,sp,64
    80001bca:	8082                	ret
            panic("kalloc");
    80001bcc:	00006517          	auipc	a0,0x6
    80001bd0:	5ec50513          	addi	a0,a0,1516 # 800081b8 <etext+0x1b8>
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	98c080e7          	jalr	-1652(ra) # 80000560 <panic>

0000000080001bdc <procinit>:
{
    80001bdc:	7139                	addi	sp,sp,-64
    80001bde:	fc06                	sd	ra,56(sp)
    80001be0:	f822                	sd	s0,48(sp)
    80001be2:	f426                	sd	s1,40(sp)
    80001be4:	f04a                	sd	s2,32(sp)
    80001be6:	ec4e                	sd	s3,24(sp)
    80001be8:	e852                	sd	s4,16(sp)
    80001bea:	e456                	sd	s5,8(sp)
    80001bec:	e05a                	sd	s6,0(sp)
    80001bee:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001bf0:	00006597          	auipc	a1,0x6
    80001bf4:	5d058593          	addi	a1,a1,1488 # 800081c0 <etext+0x1c0>
    80001bf8:	00012517          	auipc	a0,0x12
    80001bfc:	f7850513          	addi	a0,a0,-136 # 80013b70 <pid_lock>
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	fa8080e7          	jalr	-88(ra) # 80000ba8 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001c08:	00006597          	auipc	a1,0x6
    80001c0c:	5c058593          	addi	a1,a1,1472 # 800081c8 <etext+0x1c8>
    80001c10:	00012517          	auipc	a0,0x12
    80001c14:	f7850513          	addi	a0,a0,-136 # 80013b88 <wait_lock>
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	f90080e7          	jalr	-112(ra) # 80000ba8 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001c20:	00012497          	auipc	s1,0x12
    80001c24:	f8048493          	addi	s1,s1,-128 # 80013ba0 <proc>
        initlock(&p->lock, "proc");
    80001c28:	00006b17          	auipc	s6,0x6
    80001c2c:	5b0b0b13          	addi	s6,s6,1456 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001c30:	8aa6                	mv	s5,s1
    80001c32:	ff4df937          	lui	s2,0xff4df
    80001c36:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e3d>
    80001c3a:	0936                	slli	s2,s2,0xd
    80001c3c:	6f590913          	addi	s2,s2,1781
    80001c40:	0936                	slli	s2,s2,0xd
    80001c42:	bd390913          	addi	s2,s2,-1069
    80001c46:	0932                	slli	s2,s2,0xc
    80001c48:	7a790913          	addi	s2,s2,1959
    80001c4c:	040009b7          	lui	s3,0x4000
    80001c50:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001c52:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001c54:	00018a17          	auipc	s4,0x18
    80001c58:	b4ca0a13          	addi	s4,s4,-1204 # 800197a0 <tickslock>
        initlock(&p->lock, "proc");
    80001c5c:	85da                	mv	a1,s6
    80001c5e:	8526                	mv	a0,s1
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	f48080e7          	jalr	-184(ra) # 80000ba8 <initlock>
        p->state = UNUSED;
    80001c68:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001c6c:	415487b3          	sub	a5,s1,s5
    80001c70:	8791                	srai	a5,a5,0x4
    80001c72:	032787b3          	mul	a5,a5,s2
    80001c76:	2785                	addiw	a5,a5,1
    80001c78:	00d7979b          	slliw	a5,a5,0xd
    80001c7c:	40f987b3          	sub	a5,s3,a5
    80001c80:	e4bc                	sd	a5,72(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001c82:	17048493          	addi	s1,s1,368
    80001c86:	fd449be3          	bne	s1,s4,80001c5c <procinit+0x80>
}
    80001c8a:	70e2                	ld	ra,56(sp)
    80001c8c:	7442                	ld	s0,48(sp)
    80001c8e:	74a2                	ld	s1,40(sp)
    80001c90:	7902                	ld	s2,32(sp)
    80001c92:	69e2                	ld	s3,24(sp)
    80001c94:	6a42                	ld	s4,16(sp)
    80001c96:	6aa2                	ld	s5,8(sp)
    80001c98:	6b02                	ld	s6,0(sp)
    80001c9a:	6121                	addi	sp,sp,64
    80001c9c:	8082                	ret

0000000080001c9e <copy_array>:
{
    80001c9e:	1141                	addi	sp,sp,-16
    80001ca0:	e422                	sd	s0,8(sp)
    80001ca2:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001ca4:	00c05c63          	blez	a2,80001cbc <copy_array+0x1e>
    80001ca8:	87aa                	mv	a5,a0
    80001caa:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001cac:	0007c703          	lbu	a4,0(a5)
    80001cb0:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001cb4:	0785                	addi	a5,a5,1
    80001cb6:	0585                	addi	a1,a1,1
    80001cb8:	fea79ae3          	bne	a5,a0,80001cac <copy_array+0xe>
}
    80001cbc:	6422                	ld	s0,8(sp)
    80001cbe:	0141                	addi	sp,sp,16
    80001cc0:	8082                	ret

0000000080001cc2 <cpuid>:
{
    80001cc2:	1141                	addi	sp,sp,-16
    80001cc4:	e422                	sd	s0,8(sp)
    80001cc6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cc8:	8512                	mv	a0,tp
}
    80001cca:	2501                	sext.w	a0,a0
    80001ccc:	6422                	ld	s0,8(sp)
    80001cce:	0141                	addi	sp,sp,16
    80001cd0:	8082                	ret

0000000080001cd2 <mycpu>:
{
    80001cd2:	1141                	addi	sp,sp,-16
    80001cd4:	e422                	sd	s0,8(sp)
    80001cd6:	0800                	addi	s0,sp,16
    80001cd8:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001cda:	2781                	sext.w	a5,a5
    80001cdc:	079e                	slli	a5,a5,0x7
}
    80001cde:	00012517          	auipc	a0,0x12
    80001ce2:	a9250513          	addi	a0,a0,-1390 # 80013770 <cpus>
    80001ce6:	953e                	add	a0,a0,a5
    80001ce8:	6422                	ld	s0,8(sp)
    80001cea:	0141                	addi	sp,sp,16
    80001cec:	8082                	ret

0000000080001cee <myproc>:
{
    80001cee:	1101                	addi	sp,sp,-32
    80001cf0:	ec06                	sd	ra,24(sp)
    80001cf2:	e822                	sd	s0,16(sp)
    80001cf4:	e426                	sd	s1,8(sp)
    80001cf6:	1000                	addi	s0,sp,32
    push_off();
    80001cf8:	fffff097          	auipc	ra,0xfffff
    80001cfc:	ef4080e7          	jalr	-268(ra) # 80000bec <push_off>
    80001d00:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001d02:	2781                	sext.w	a5,a5
    80001d04:	079e                	slli	a5,a5,0x7
    80001d06:	00012717          	auipc	a4,0x12
    80001d0a:	a6a70713          	addi	a4,a4,-1430 # 80013770 <cpus>
    80001d0e:	97ba                	add	a5,a5,a4
    80001d10:	6384                	ld	s1,0(a5)
    pop_off();
    80001d12:	fffff097          	auipc	ra,0xfffff
    80001d16:	f7a080e7          	jalr	-134(ra) # 80000c8c <pop_off>
}
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	60e2                	ld	ra,24(sp)
    80001d1e:	6442                	ld	s0,16(sp)
    80001d20:	64a2                	ld	s1,8(sp)
    80001d22:	6105                	addi	sp,sp,32
    80001d24:	8082                	ret

0000000080001d26 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001d26:	1141                	addi	sp,sp,-16
    80001d28:	e406                	sd	ra,8(sp)
    80001d2a:	e022                	sd	s0,0(sp)
    80001d2c:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	fc0080e7          	jalr	-64(ra) # 80001cee <myproc>
    80001d36:	fffff097          	auipc	ra,0xfffff
    80001d3a:	fb6080e7          	jalr	-74(ra) # 80000cec <release>

    if (first)
    80001d3e:	00009797          	auipc	a5,0x9
    80001d42:	6d27a783          	lw	a5,1746(a5) # 8000b410 <first.1>
    80001d46:	eb89                	bnez	a5,80001d58 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001d48:	00001097          	auipc	ra,0x1
    80001d4c:	ede080e7          	jalr	-290(ra) # 80002c26 <usertrapret>
}
    80001d50:	60a2                	ld	ra,8(sp)
    80001d52:	6402                	ld	s0,0(sp)
    80001d54:	0141                	addi	sp,sp,16
    80001d56:	8082                	ret
        first = 0;
    80001d58:	00009797          	auipc	a5,0x9
    80001d5c:	6a07ac23          	sw	zero,1720(a5) # 8000b410 <first.1>
        fsinit(ROOTDEV);
    80001d60:	4505                	li	a0,1
    80001d62:	00002097          	auipc	ra,0x2
    80001d66:	cfc080e7          	jalr	-772(ra) # 80003a5e <fsinit>
    80001d6a:	bff9                	j	80001d48 <forkret+0x22>

0000000080001d6c <allocpid>:
{
    80001d6c:	1101                	addi	sp,sp,-32
    80001d6e:	ec06                	sd	ra,24(sp)
    80001d70:	e822                	sd	s0,16(sp)
    80001d72:	e426                	sd	s1,8(sp)
    80001d74:	e04a                	sd	s2,0(sp)
    80001d76:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001d78:	00012917          	auipc	s2,0x12
    80001d7c:	df890913          	addi	s2,s2,-520 # 80013b70 <pid_lock>
    80001d80:	854a                	mv	a0,s2
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	eb6080e7          	jalr	-330(ra) # 80000c38 <acquire>
    pid = nextpid;
    80001d8a:	00009797          	auipc	a5,0x9
    80001d8e:	69678793          	addi	a5,a5,1686 # 8000b420 <nextpid>
    80001d92:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001d94:	0014871b          	addiw	a4,s1,1
    80001d98:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001d9a:	854a                	mv	a0,s2
    80001d9c:	fffff097          	auipc	ra,0xfffff
    80001da0:	f50080e7          	jalr	-176(ra) # 80000cec <release>
}
    80001da4:	8526                	mv	a0,s1
    80001da6:	60e2                	ld	ra,24(sp)
    80001da8:	6442                	ld	s0,16(sp)
    80001daa:	64a2                	ld	s1,8(sp)
    80001dac:	6902                	ld	s2,0(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret

0000000080001db2 <proc_pagetable>:
{
    80001db2:	1101                	addi	sp,sp,-32
    80001db4:	ec06                	sd	ra,24(sp)
    80001db6:	e822                	sd	s0,16(sp)
    80001db8:	e426                	sd	s1,8(sp)
    80001dba:	e04a                	sd	s2,0(sp)
    80001dbc:	1000                	addi	s0,sp,32
    80001dbe:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001dc0:	fffff097          	auipc	ra,0xfffff
    80001dc4:	5d2080e7          	jalr	1490(ra) # 80001392 <uvmcreate>
    80001dc8:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001dca:	c121                	beqz	a0,80001e0a <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001dcc:	4729                	li	a4,10
    80001dce:	00005697          	auipc	a3,0x5
    80001dd2:	23268693          	addi	a3,a3,562 # 80007000 <_trampoline>
    80001dd6:	6605                	lui	a2,0x1
    80001dd8:	040005b7          	lui	a1,0x4000
    80001ddc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001dde:	05b2                	slli	a1,a1,0xc
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	318080e7          	jalr	792(ra) # 800010f8 <mappages>
    80001de8:	02054863          	bltz	a0,80001e18 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001dec:	4719                	li	a4,6
    80001dee:	06093683          	ld	a3,96(s2)
    80001df2:	6605                	lui	a2,0x1
    80001df4:	020005b7          	lui	a1,0x2000
    80001df8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001dfa:	05b6                	slli	a1,a1,0xd
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	2fa080e7          	jalr	762(ra) # 800010f8 <mappages>
    80001e06:	02054163          	bltz	a0,80001e28 <proc_pagetable+0x76>
}
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	60e2                	ld	ra,24(sp)
    80001e0e:	6442                	ld	s0,16(sp)
    80001e10:	64a2                	ld	s1,8(sp)
    80001e12:	6902                	ld	s2,0(sp)
    80001e14:	6105                	addi	sp,sp,32
    80001e16:	8082                	ret
        uvmfree(pagetable, 0);
    80001e18:	4581                	li	a1,0
    80001e1a:	8526                	mv	a0,s1
    80001e1c:	fffff097          	auipc	ra,0xfffff
    80001e20:	788080e7          	jalr	1928(ra) # 800015a4 <uvmfree>
        return 0;
    80001e24:	4481                	li	s1,0
    80001e26:	b7d5                	j	80001e0a <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e28:	4681                	li	a3,0
    80001e2a:	4605                	li	a2,1
    80001e2c:	040005b7          	lui	a1,0x4000
    80001e30:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e32:	05b2                	slli	a1,a1,0xc
    80001e34:	8526                	mv	a0,s1
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	488080e7          	jalr	1160(ra) # 800012be <uvmunmap>
        uvmfree(pagetable, 0);
    80001e3e:	4581                	li	a1,0
    80001e40:	8526                	mv	a0,s1
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	762080e7          	jalr	1890(ra) # 800015a4 <uvmfree>
        return 0;
    80001e4a:	4481                	li	s1,0
    80001e4c:	bf7d                	j	80001e0a <proc_pagetable+0x58>

0000000080001e4e <proc_freepagetable>:
{
    80001e4e:	1101                	addi	sp,sp,-32
    80001e50:	ec06                	sd	ra,24(sp)
    80001e52:	e822                	sd	s0,16(sp)
    80001e54:	e426                	sd	s1,8(sp)
    80001e56:	e04a                	sd	s2,0(sp)
    80001e58:	1000                	addi	s0,sp,32
    80001e5a:	84aa                	mv	s1,a0
    80001e5c:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e5e:	4681                	li	a3,0
    80001e60:	4605                	li	a2,1
    80001e62:	040005b7          	lui	a1,0x4000
    80001e66:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e68:	05b2                	slli	a1,a1,0xc
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	454080e7          	jalr	1108(ra) # 800012be <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e72:	4681                	li	a3,0
    80001e74:	4605                	li	a2,1
    80001e76:	020005b7          	lui	a1,0x2000
    80001e7a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e7c:	05b6                	slli	a1,a1,0xd
    80001e7e:	8526                	mv	a0,s1
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	43e080e7          	jalr	1086(ra) # 800012be <uvmunmap>
    uvmfree(pagetable, sz);
    80001e88:	85ca                	mv	a1,s2
    80001e8a:	8526                	mv	a0,s1
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	718080e7          	jalr	1816(ra) # 800015a4 <uvmfree>
}
    80001e94:	60e2                	ld	ra,24(sp)
    80001e96:	6442                	ld	s0,16(sp)
    80001e98:	64a2                	ld	s1,8(sp)
    80001e9a:	6902                	ld	s2,0(sp)
    80001e9c:	6105                	addi	sp,sp,32
    80001e9e:	8082                	ret

0000000080001ea0 <freeproc>:
{
    80001ea0:	1101                	addi	sp,sp,-32
    80001ea2:	ec06                	sd	ra,24(sp)
    80001ea4:	e822                	sd	s0,16(sp)
    80001ea6:	e426                	sd	s1,8(sp)
    80001ea8:	1000                	addi	s0,sp,32
    80001eaa:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001eac:	7128                	ld	a0,96(a0)
    80001eae:	c509                	beqz	a0,80001eb8 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	b9a080e7          	jalr	-1126(ra) # 80000a4a <kfree>
    p->trapframe = 0;
    80001eb8:	0604b023          	sd	zero,96(s1)
    if (p->pagetable)
    80001ebc:	6ca8                	ld	a0,88(s1)
    80001ebe:	c511                	beqz	a0,80001eca <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001ec0:	68ac                	ld	a1,80(s1)
    80001ec2:	00000097          	auipc	ra,0x0
    80001ec6:	f8c080e7          	jalr	-116(ra) # 80001e4e <proc_freepagetable>
    p->pagetable = 0;
    80001eca:	0404bc23          	sd	zero,88(s1)
    p->sz = 0;
    80001ece:	0404b823          	sd	zero,80(s1)
    p->pid = 0;
    80001ed2:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001ed6:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001eda:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80001ede:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001ee2:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001ee6:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001eea:	0004ac23          	sw	zero,24(s1)
}
    80001eee:	60e2                	ld	ra,24(sp)
    80001ef0:	6442                	ld	s0,16(sp)
    80001ef2:	64a2                	ld	s1,8(sp)
    80001ef4:	6105                	addi	sp,sp,32
    80001ef6:	8082                	ret

0000000080001ef8 <allocproc>:
{
    80001ef8:	1101                	addi	sp,sp,-32
    80001efa:	ec06                	sd	ra,24(sp)
    80001efc:	e822                	sd	s0,16(sp)
    80001efe:	e426                	sd	s1,8(sp)
    80001f00:	e04a                	sd	s2,0(sp)
    80001f02:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001f04:	00012497          	auipc	s1,0x12
    80001f08:	c9c48493          	addi	s1,s1,-868 # 80013ba0 <proc>
    80001f0c:	00018917          	auipc	s2,0x18
    80001f10:	89490913          	addi	s2,s2,-1900 # 800197a0 <tickslock>
        acquire(&p->lock);
    80001f14:	8526                	mv	a0,s1
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	d22080e7          	jalr	-734(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80001f1e:	4c9c                	lw	a5,24(s1)
    80001f20:	cf81                	beqz	a5,80001f38 <allocproc+0x40>
            release(&p->lock);
    80001f22:	8526                	mv	a0,s1
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	dc8080e7          	jalr	-568(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001f2c:	17048493          	addi	s1,s1,368
    80001f30:	ff2492e3          	bne	s1,s2,80001f14 <allocproc+0x1c>
    return 0;
    80001f34:	4481                	li	s1,0
    80001f36:	a8a9                	j	80001f90 <allocproc+0x98>
    p->pid = allocpid();
    80001f38:	00000097          	auipc	ra,0x0
    80001f3c:	e34080e7          	jalr	-460(ra) # 80001d6c <allocpid>
    80001f40:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001f42:	4785                	li	a5,1
    80001f44:	cc9c                	sw	a5,24(s1)
    p->priority = 0;
    80001f46:	0404a023          	sw	zero,64(s1)
    p->time_ticks = 0;
    80001f4a:	0404a223          	sw	zero,68(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	bfa080e7          	jalr	-1030(ra) # 80000b48 <kalloc>
    80001f56:	892a                	mv	s2,a0
    80001f58:	f0a8                	sd	a0,96(s1)
    80001f5a:	c131                	beqz	a0,80001f9e <allocproc+0xa6>
    p->pagetable = proc_pagetable(p);
    80001f5c:	8526                	mv	a0,s1
    80001f5e:	00000097          	auipc	ra,0x0
    80001f62:	e54080e7          	jalr	-428(ra) # 80001db2 <proc_pagetable>
    80001f66:	892a                	mv	s2,a0
    80001f68:	eca8                	sd	a0,88(s1)
    if (p->pagetable == 0)
    80001f6a:	c531                	beqz	a0,80001fb6 <allocproc+0xbe>
    memset(&p->context, 0, sizeof(p->context));
    80001f6c:	07000613          	li	a2,112
    80001f70:	4581                	li	a1,0
    80001f72:	06848513          	addi	a0,s1,104
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	dbe080e7          	jalr	-578(ra) # 80000d34 <memset>
    p->context.ra = (uint64)forkret;
    80001f7e:	00000797          	auipc	a5,0x0
    80001f82:	da878793          	addi	a5,a5,-600 # 80001d26 <forkret>
    80001f86:	f4bc                	sd	a5,104(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001f88:	64bc                	ld	a5,72(s1)
    80001f8a:	6705                	lui	a4,0x1
    80001f8c:	97ba                	add	a5,a5,a4
    80001f8e:	f8bc                	sd	a5,112(s1)
}
    80001f90:	8526                	mv	a0,s1
    80001f92:	60e2                	ld	ra,24(sp)
    80001f94:	6442                	ld	s0,16(sp)
    80001f96:	64a2                	ld	s1,8(sp)
    80001f98:	6902                	ld	s2,0(sp)
    80001f9a:	6105                	addi	sp,sp,32
    80001f9c:	8082                	ret
        freeproc(p);
    80001f9e:	8526                	mv	a0,s1
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	f00080e7          	jalr	-256(ra) # 80001ea0 <freeproc>
        release(&p->lock);
    80001fa8:	8526                	mv	a0,s1
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	d42080e7          	jalr	-702(ra) # 80000cec <release>
        return 0;
    80001fb2:	84ca                	mv	s1,s2
    80001fb4:	bff1                	j	80001f90 <allocproc+0x98>
        freeproc(p);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	ee8080e7          	jalr	-280(ra) # 80001ea0 <freeproc>
        release(&p->lock);
    80001fc0:	8526                	mv	a0,s1
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	d2a080e7          	jalr	-726(ra) # 80000cec <release>
        return 0;
    80001fca:	84ca                	mv	s1,s2
    80001fcc:	b7d1                	j	80001f90 <allocproc+0x98>

0000000080001fce <userinit>:
{
    80001fce:	1101                	addi	sp,sp,-32
    80001fd0:	ec06                	sd	ra,24(sp)
    80001fd2:	e822                	sd	s0,16(sp)
    80001fd4:	e426                	sd	s1,8(sp)
    80001fd6:	1000                	addi	s0,sp,32
    p = allocproc();
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	f20080e7          	jalr	-224(ra) # 80001ef8 <allocproc>
    80001fe0:	84aa                	mv	s1,a0
    initproc = p;
    80001fe2:	00009797          	auipc	a5,0x9
    80001fe6:	50a7bb23          	sd	a0,1302(a5) # 8000b4f8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001fea:	03400613          	li	a2,52
    80001fee:	00009597          	auipc	a1,0x9
    80001ff2:	44258593          	addi	a1,a1,1090 # 8000b430 <initcode>
    80001ff6:	6d28                	ld	a0,88(a0)
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	3c8080e7          	jalr	968(ra) # 800013c0 <uvmfirst>
    p->sz = PGSIZE;
    80002000:	6785                	lui	a5,0x1
    80002002:	e8bc                	sd	a5,80(s1)
    p->trapframe->epc = 0;     // user program counter
    80002004:	70b8                	ld	a4,96(s1)
    80002006:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    8000200a:	70b8                	ld	a4,96(s1)
    8000200c:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    8000200e:	4641                	li	a2,16
    80002010:	00006597          	auipc	a1,0x6
    80002014:	1d058593          	addi	a1,a1,464 # 800081e0 <etext+0x1e0>
    80002018:	16048513          	addi	a0,s1,352
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	e5a080e7          	jalr	-422(ra) # 80000e76 <safestrcpy>
    p->cwd = namei("/");
    80002024:	00006517          	auipc	a0,0x6
    80002028:	1cc50513          	addi	a0,a0,460 # 800081f0 <etext+0x1f0>
    8000202c:	00002097          	auipc	ra,0x2
    80002030:	484080e7          	jalr	1156(ra) # 800044b0 <namei>
    80002034:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    80002038:	478d                	li	a5,3
    8000203a:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    8000203c:	8526                	mv	a0,s1
    8000203e:	fffff097          	auipc	ra,0xfffff
    80002042:	cae080e7          	jalr	-850(ra) # 80000cec <release>
}
    80002046:	60e2                	ld	ra,24(sp)
    80002048:	6442                	ld	s0,16(sp)
    8000204a:	64a2                	ld	s1,8(sp)
    8000204c:	6105                	addi	sp,sp,32
    8000204e:	8082                	ret

0000000080002050 <growproc>:
{
    80002050:	1101                	addi	sp,sp,-32
    80002052:	ec06                	sd	ra,24(sp)
    80002054:	e822                	sd	s0,16(sp)
    80002056:	e426                	sd	s1,8(sp)
    80002058:	e04a                	sd	s2,0(sp)
    8000205a:	1000                	addi	s0,sp,32
    8000205c:	892a                	mv	s2,a0
    struct proc *p = myproc();
    8000205e:	00000097          	auipc	ra,0x0
    80002062:	c90080e7          	jalr	-880(ra) # 80001cee <myproc>
    80002066:	84aa                	mv	s1,a0
    sz = p->sz;
    80002068:	692c                	ld	a1,80(a0)
    if (n > 0)
    8000206a:	01204c63          	bgtz	s2,80002082 <growproc+0x32>
    else if (n < 0)
    8000206e:	02094663          	bltz	s2,8000209a <growproc+0x4a>
    p->sz = sz;
    80002072:	e8ac                	sd	a1,80(s1)
    return 0;
    80002074:	4501                	li	a0,0
}
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	64a2                	ld	s1,8(sp)
    8000207c:	6902                	ld	s2,0(sp)
    8000207e:	6105                	addi	sp,sp,32
    80002080:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002082:	4691                	li	a3,4
    80002084:	00b90633          	add	a2,s2,a1
    80002088:	6d28                	ld	a0,88(a0)
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	3f0080e7          	jalr	1008(ra) # 8000147a <uvmalloc>
    80002092:	85aa                	mv	a1,a0
    80002094:	fd79                	bnez	a0,80002072 <growproc+0x22>
            return -1;
    80002096:	557d                	li	a0,-1
    80002098:	bff9                	j	80002076 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000209a:	00b90633          	add	a2,s2,a1
    8000209e:	6d28                	ld	a0,88(a0)
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	392080e7          	jalr	914(ra) # 80001432 <uvmdealloc>
    800020a8:	85aa                	mv	a1,a0
    800020aa:	b7e1                	j	80002072 <growproc+0x22>

00000000800020ac <ps>:
{
    800020ac:	715d                	addi	sp,sp,-80
    800020ae:	e486                	sd	ra,72(sp)
    800020b0:	e0a2                	sd	s0,64(sp)
    800020b2:	fc26                	sd	s1,56(sp)
    800020b4:	f84a                	sd	s2,48(sp)
    800020b6:	f44e                	sd	s3,40(sp)
    800020b8:	f052                	sd	s4,32(sp)
    800020ba:	ec56                	sd	s5,24(sp)
    800020bc:	e85a                	sd	s6,16(sp)
    800020be:	e45e                	sd	s7,8(sp)
    800020c0:	e062                	sd	s8,0(sp)
    800020c2:	0880                	addi	s0,sp,80
    800020c4:	84aa                	mv	s1,a0
    800020c6:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    800020c8:	00000097          	auipc	ra,0x0
    800020cc:	c26080e7          	jalr	-986(ra) # 80001cee <myproc>
        return result;
    800020d0:	4901                	li	s2,0
    if (count == 0)
    800020d2:	0c0b8663          	beqz	s7,8000219e <ps+0xf2>
    void *result = (void *)myproc()->sz;
    800020d6:	05053b03          	ld	s6,80(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    800020da:	003b951b          	slliw	a0,s7,0x3
    800020de:	0175053b          	addw	a0,a0,s7
    800020e2:	0025151b          	slliw	a0,a0,0x2
    800020e6:	2501                	sext.w	a0,a0
    800020e8:	00000097          	auipc	ra,0x0
    800020ec:	f68080e7          	jalr	-152(ra) # 80002050 <growproc>
    800020f0:	12054f63          	bltz	a0,8000222e <ps+0x182>
    struct user_proc loc_result[count];
    800020f4:	003b9a13          	slli	s4,s7,0x3
    800020f8:	9a5e                	add	s4,s4,s7
    800020fa:	0a0a                	slli	s4,s4,0x2
    800020fc:	00fa0793          	addi	a5,s4,15
    80002100:	8391                	srli	a5,a5,0x4
    80002102:	0792                	slli	a5,a5,0x4
    80002104:	40f10133          	sub	sp,sp,a5
    80002108:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    8000210a:	17000793          	li	a5,368
    8000210e:	02f484b3          	mul	s1,s1,a5
    80002112:	00012797          	auipc	a5,0x12
    80002116:	a8e78793          	addi	a5,a5,-1394 # 80013ba0 <proc>
    8000211a:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    8000211c:	00017797          	auipc	a5,0x17
    80002120:	68478793          	addi	a5,a5,1668 # 800197a0 <tickslock>
        return result;
    80002124:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    80002126:	06f4fc63          	bgeu	s1,a5,8000219e <ps+0xf2>
    acquire(&wait_lock);
    8000212a:	00012517          	auipc	a0,0x12
    8000212e:	a5e50513          	addi	a0,a0,-1442 # 80013b88 <wait_lock>
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	b06080e7          	jalr	-1274(ra) # 80000c38 <acquire>
        if (localCount == count)
    8000213a:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    8000213e:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    80002140:	00017c17          	auipc	s8,0x17
    80002144:	660c0c13          	addi	s8,s8,1632 # 800197a0 <tickslock>
    80002148:	a851                	j	800021dc <ps+0x130>
            loc_result[localCount].state = UNUSED;
    8000214a:	00399793          	slli	a5,s3,0x3
    8000214e:	97ce                	add	a5,a5,s3
    80002150:	078a                	slli	a5,a5,0x2
    80002152:	97d6                	add	a5,a5,s5
    80002154:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80002158:	8526                	mv	a0,s1
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	b92080e7          	jalr	-1134(ra) # 80000cec <release>
    release(&wait_lock);
    80002162:	00012517          	auipc	a0,0x12
    80002166:	a2650513          	addi	a0,a0,-1498 # 80013b88 <wait_lock>
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	b82080e7          	jalr	-1150(ra) # 80000cec <release>
    if (localCount < count)
    80002172:	0179f963          	bgeu	s3,s7,80002184 <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80002176:	00399793          	slli	a5,s3,0x3
    8000217a:	97ce                	add	a5,a5,s3
    8000217c:	078a                	slli	a5,a5,0x2
    8000217e:	97d6                	add	a5,a5,s5
    80002180:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80002184:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	b68080e7          	jalr	-1176(ra) # 80001cee <myproc>
    8000218e:	86d2                	mv	a3,s4
    80002190:	8656                	mv	a2,s5
    80002192:	85da                	mv	a1,s6
    80002194:	6d28                	ld	a0,88(a0)
    80002196:	fffff097          	auipc	ra,0xfffff
    8000219a:	54c080e7          	jalr	1356(ra) # 800016e2 <copyout>
}
    8000219e:	854a                	mv	a0,s2
    800021a0:	fb040113          	addi	sp,s0,-80
    800021a4:	60a6                	ld	ra,72(sp)
    800021a6:	6406                	ld	s0,64(sp)
    800021a8:	74e2                	ld	s1,56(sp)
    800021aa:	7942                	ld	s2,48(sp)
    800021ac:	79a2                	ld	s3,40(sp)
    800021ae:	7a02                	ld	s4,32(sp)
    800021b0:	6ae2                	ld	s5,24(sp)
    800021b2:	6b42                	ld	s6,16(sp)
    800021b4:	6ba2                	ld	s7,8(sp)
    800021b6:	6c02                	ld	s8,0(sp)
    800021b8:	6161                	addi	sp,sp,80
    800021ba:	8082                	ret
        release(&p->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	b2e080e7          	jalr	-1234(ra) # 80000cec <release>
        localCount++;
    800021c6:	2985                	addiw	s3,s3,1
    800021c8:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    800021cc:	17048493          	addi	s1,s1,368
    800021d0:	f984f9e3          	bgeu	s1,s8,80002162 <ps+0xb6>
        if (localCount == count)
    800021d4:	02490913          	addi	s2,s2,36
    800021d8:	053b8d63          	beq	s7,s3,80002232 <ps+0x186>
        acquire(&p->lock);
    800021dc:	8526                	mv	a0,s1
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	a5a080e7          	jalr	-1446(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    800021e6:	4c9c                	lw	a5,24(s1)
    800021e8:	d3ad                	beqz	a5,8000214a <ps+0x9e>
        loc_result[localCount].state = p->state;
    800021ea:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    800021ee:	549c                	lw	a5,40(s1)
    800021f0:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    800021f4:	54dc                	lw	a5,44(s1)
    800021f6:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    800021fa:	589c                	lw	a5,48(s1)
    800021fc:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002200:	4641                	li	a2,16
    80002202:	85ca                	mv	a1,s2
    80002204:	16048513          	addi	a0,s1,352
    80002208:	00000097          	auipc	ra,0x0
    8000220c:	a96080e7          	jalr	-1386(ra) # 80001c9e <copy_array>
        if (p->parent != 0) // init
    80002210:	7c88                	ld	a0,56(s1)
    80002212:	d54d                	beqz	a0,800021bc <ps+0x110>
            acquire(&p->parent->lock);
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	a24080e7          	jalr	-1500(ra) # 80000c38 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    8000221c:	7c88                	ld	a0,56(s1)
    8000221e:	591c                	lw	a5,48(a0)
    80002220:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	ac8080e7          	jalr	-1336(ra) # 80000cec <release>
    8000222c:	bf41                	j	800021bc <ps+0x110>
        return result;
    8000222e:	4901                	li	s2,0
    80002230:	b7bd                	j	8000219e <ps+0xf2>
    release(&wait_lock);
    80002232:	00012517          	auipc	a0,0x12
    80002236:	95650513          	addi	a0,a0,-1706 # 80013b88 <wait_lock>
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	ab2080e7          	jalr	-1358(ra) # 80000cec <release>
    if (localCount < count)
    80002242:	b789                	j	80002184 <ps+0xd8>

0000000080002244 <fork>:
{
    80002244:	7139                	addi	sp,sp,-64
    80002246:	fc06                	sd	ra,56(sp)
    80002248:	f822                	sd	s0,48(sp)
    8000224a:	f04a                	sd	s2,32(sp)
    8000224c:	e456                	sd	s5,8(sp)
    8000224e:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002250:	00000097          	auipc	ra,0x0
    80002254:	a9e080e7          	jalr	-1378(ra) # 80001cee <myproc>
    80002258:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	c9e080e7          	jalr	-866(ra) # 80001ef8 <allocproc>
    80002262:	12050063          	beqz	a0,80002382 <fork+0x13e>
    80002266:	e852                	sd	s4,16(sp)
    80002268:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000226a:	050ab603          	ld	a2,80(s5)
    8000226e:	6d2c                	ld	a1,88(a0)
    80002270:	058ab503          	ld	a0,88(s5)
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	36a080e7          	jalr	874(ra) # 800015de <uvmcopy>
    8000227c:	04054a63          	bltz	a0,800022d0 <fork+0x8c>
    80002280:	f426                	sd	s1,40(sp)
    80002282:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    80002284:	050ab783          	ld	a5,80(s5)
    80002288:	04fa3823          	sd	a5,80(s4)
    *(np->trapframe) = *(p->trapframe);
    8000228c:	060ab683          	ld	a3,96(s5)
    80002290:	87b6                	mv	a5,a3
    80002292:	060a3703          	ld	a4,96(s4)
    80002296:	12068693          	addi	a3,a3,288
    8000229a:	0007b803          	ld	a6,0(a5)
    8000229e:	6788                	ld	a0,8(a5)
    800022a0:	6b8c                	ld	a1,16(a5)
    800022a2:	6f90                	ld	a2,24(a5)
    800022a4:	01073023          	sd	a6,0(a4)
    800022a8:	e708                	sd	a0,8(a4)
    800022aa:	eb0c                	sd	a1,16(a4)
    800022ac:	ef10                	sd	a2,24(a4)
    800022ae:	02078793          	addi	a5,a5,32
    800022b2:	02070713          	addi	a4,a4,32
    800022b6:	fed792e3          	bne	a5,a3,8000229a <fork+0x56>
    np->trapframe->a0 = 0;
    800022ba:	060a3783          	ld	a5,96(s4)
    800022be:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800022c2:	0d8a8493          	addi	s1,s5,216
    800022c6:	0d8a0913          	addi	s2,s4,216
    800022ca:	158a8993          	addi	s3,s5,344
    800022ce:	a015                	j	800022f2 <fork+0xae>
        freeproc(np);
    800022d0:	8552                	mv	a0,s4
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	bce080e7          	jalr	-1074(ra) # 80001ea0 <freeproc>
        release(&np->lock);
    800022da:	8552                	mv	a0,s4
    800022dc:	fffff097          	auipc	ra,0xfffff
    800022e0:	a10080e7          	jalr	-1520(ra) # 80000cec <release>
        return -1;
    800022e4:	597d                	li	s2,-1
    800022e6:	6a42                	ld	s4,16(sp)
    800022e8:	a071                	j	80002374 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    800022ea:	04a1                	addi	s1,s1,8
    800022ec:	0921                	addi	s2,s2,8
    800022ee:	01348b63          	beq	s1,s3,80002304 <fork+0xc0>
        if (p->ofile[i])
    800022f2:	6088                	ld	a0,0(s1)
    800022f4:	d97d                	beqz	a0,800022ea <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    800022f6:	00003097          	auipc	ra,0x3
    800022fa:	832080e7          	jalr	-1998(ra) # 80004b28 <filedup>
    800022fe:	00a93023          	sd	a0,0(s2)
    80002302:	b7e5                	j	800022ea <fork+0xa6>
    np->cwd = idup(p->cwd);
    80002304:	158ab503          	ld	a0,344(s5)
    80002308:	00002097          	auipc	ra,0x2
    8000230c:	99c080e7          	jalr	-1636(ra) # 80003ca4 <idup>
    80002310:	14aa3c23          	sd	a0,344(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002314:	4641                	li	a2,16
    80002316:	160a8593          	addi	a1,s5,352
    8000231a:	160a0513          	addi	a0,s4,352
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	b58080e7          	jalr	-1192(ra) # 80000e76 <safestrcpy>
    pid = np->pid;
    80002326:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    8000232a:	8552                	mv	a0,s4
    8000232c:	fffff097          	auipc	ra,0xfffff
    80002330:	9c0080e7          	jalr	-1600(ra) # 80000cec <release>
    acquire(&wait_lock);
    80002334:	00012497          	auipc	s1,0x12
    80002338:	85448493          	addi	s1,s1,-1964 # 80013b88 <wait_lock>
    8000233c:	8526                	mv	a0,s1
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	8fa080e7          	jalr	-1798(ra) # 80000c38 <acquire>
    np->parent = p;
    80002346:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    8000234a:	8526                	mv	a0,s1
    8000234c:	fffff097          	auipc	ra,0xfffff
    80002350:	9a0080e7          	jalr	-1632(ra) # 80000cec <release>
    acquire(&np->lock);
    80002354:	8552                	mv	a0,s4
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	8e2080e7          	jalr	-1822(ra) # 80000c38 <acquire>
    np->state = RUNNABLE;
    8000235e:	478d                	li	a5,3
    80002360:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80002364:	8552                	mv	a0,s4
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	986080e7          	jalr	-1658(ra) # 80000cec <release>
    return pid;
    8000236e:	74a2                	ld	s1,40(sp)
    80002370:	69e2                	ld	s3,24(sp)
    80002372:	6a42                	ld	s4,16(sp)
}
    80002374:	854a                	mv	a0,s2
    80002376:	70e2                	ld	ra,56(sp)
    80002378:	7442                	ld	s0,48(sp)
    8000237a:	7902                	ld	s2,32(sp)
    8000237c:	6aa2                	ld	s5,8(sp)
    8000237e:	6121                	addi	sp,sp,64
    80002380:	8082                	ret
        return -1;
    80002382:	597d                	li	s2,-1
    80002384:	bfc5                	j	80002374 <fork+0x130>

0000000080002386 <scheduler>:
{
    80002386:	1101                	addi	sp,sp,-32
    80002388:	ec06                	sd	ra,24(sp)
    8000238a:	e822                	sd	s0,16(sp)
    8000238c:	e426                	sd	s1,8(sp)
    8000238e:	e04a                	sd	s2,0(sp)
    80002390:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    80002392:	00009797          	auipc	a5,0x9
    80002396:	0867b783          	ld	a5,134(a5) # 8000b418 <sched_pointer>
        if (old_scheduler != sched_pointer)
    8000239a:	00009497          	auipc	s1,0x9
    8000239e:	07e48493          	addi	s1,s1,126 # 8000b418 <sched_pointer>
            printf("Scheduler switched\n");
    800023a2:	00006917          	auipc	s2,0x6
    800023a6:	e5690913          	addi	s2,s2,-426 # 800081f8 <etext+0x1f8>
    800023aa:	a809                	j	800023bc <scheduler+0x36>
    800023ac:	854a                	mv	a0,s2
    800023ae:	ffffe097          	auipc	ra,0xffffe
    800023b2:	1fc080e7          	jalr	508(ra) # 800005aa <printf>
        (*sched_pointer)();
    800023b6:	609c                	ld	a5,0(s1)
    800023b8:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    800023ba:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    800023bc:	6098                	ld	a4,0(s1)
    800023be:	fef717e3          	bne	a4,a5,800023ac <scheduler+0x26>
    800023c2:	bfd5                	j	800023b6 <scheduler+0x30>

00000000800023c4 <sched>:
{
    800023c4:	7179                	addi	sp,sp,-48
    800023c6:	f406                	sd	ra,40(sp)
    800023c8:	f022                	sd	s0,32(sp)
    800023ca:	ec26                	sd	s1,24(sp)
    800023cc:	e84a                	sd	s2,16(sp)
    800023ce:	e44e                	sd	s3,8(sp)
    800023d0:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800023d2:	00000097          	auipc	ra,0x0
    800023d6:	91c080e7          	jalr	-1764(ra) # 80001cee <myproc>
    800023da:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800023dc:	ffffe097          	auipc	ra,0xffffe
    800023e0:	7e2080e7          	jalr	2018(ra) # 80000bbe <holding>
    800023e4:	c53d                	beqz	a0,80002452 <sched+0x8e>
    800023e6:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800023e8:	2781                	sext.w	a5,a5
    800023ea:	079e                	slli	a5,a5,0x7
    800023ec:	00011717          	auipc	a4,0x11
    800023f0:	38470713          	addi	a4,a4,900 # 80013770 <cpus>
    800023f4:	97ba                	add	a5,a5,a4
    800023f6:	5fb8                	lw	a4,120(a5)
    800023f8:	4785                	li	a5,1
    800023fa:	06f71463          	bne	a4,a5,80002462 <sched+0x9e>
    if (p->state == RUNNING)
    800023fe:	4c98                	lw	a4,24(s1)
    80002400:	4791                	li	a5,4
    80002402:	06f70863          	beq	a4,a5,80002472 <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002406:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000240a:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000240c:	ebbd                	bnez	a5,80002482 <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000240e:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002410:	00011917          	auipc	s2,0x11
    80002414:	36090913          	addi	s2,s2,864 # 80013770 <cpus>
    80002418:	2781                	sext.w	a5,a5
    8000241a:	079e                	slli	a5,a5,0x7
    8000241c:	97ca                	add	a5,a5,s2
    8000241e:	07c7a983          	lw	s3,124(a5)
    80002422:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    80002424:	2581                	sext.w	a1,a1
    80002426:	059e                	slli	a1,a1,0x7
    80002428:	05a1                	addi	a1,a1,8
    8000242a:	95ca                	add	a1,a1,s2
    8000242c:	06848513          	addi	a0,s1,104
    80002430:	00000097          	auipc	ra,0x0
    80002434:	74c080e7          	jalr	1868(ra) # 80002b7c <swtch>
    80002438:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000243a:	2781                	sext.w	a5,a5
    8000243c:	079e                	slli	a5,a5,0x7
    8000243e:	993e                	add	s2,s2,a5
    80002440:	07392e23          	sw	s3,124(s2)
}
    80002444:	70a2                	ld	ra,40(sp)
    80002446:	7402                	ld	s0,32(sp)
    80002448:	64e2                	ld	s1,24(sp)
    8000244a:	6942                	ld	s2,16(sp)
    8000244c:	69a2                	ld	s3,8(sp)
    8000244e:	6145                	addi	sp,sp,48
    80002450:	8082                	ret
        panic("sched p->lock");
    80002452:	00006517          	auipc	a0,0x6
    80002456:	dbe50513          	addi	a0,a0,-578 # 80008210 <etext+0x210>
    8000245a:	ffffe097          	auipc	ra,0xffffe
    8000245e:	106080e7          	jalr	262(ra) # 80000560 <panic>
        panic("sched locks");
    80002462:	00006517          	auipc	a0,0x6
    80002466:	dbe50513          	addi	a0,a0,-578 # 80008220 <etext+0x220>
    8000246a:	ffffe097          	auipc	ra,0xffffe
    8000246e:	0f6080e7          	jalr	246(ra) # 80000560 <panic>
        panic("sched running");
    80002472:	00006517          	auipc	a0,0x6
    80002476:	dbe50513          	addi	a0,a0,-578 # 80008230 <etext+0x230>
    8000247a:	ffffe097          	auipc	ra,0xffffe
    8000247e:	0e6080e7          	jalr	230(ra) # 80000560 <panic>
        panic("sched interruptible");
    80002482:	00006517          	auipc	a0,0x6
    80002486:	dbe50513          	addi	a0,a0,-578 # 80008240 <etext+0x240>
    8000248a:	ffffe097          	auipc	ra,0xffffe
    8000248e:	0d6080e7          	jalr	214(ra) # 80000560 <panic>

0000000080002492 <yield>:
{
    80002492:	1101                	addi	sp,sp,-32
    80002494:	ec06                	sd	ra,24(sp)
    80002496:	e822                	sd	s0,16(sp)
    80002498:	e426                	sd	s1,8(sp)
    8000249a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8000249c:	00000097          	auipc	ra,0x0
    800024a0:	852080e7          	jalr	-1966(ra) # 80001cee <myproc>
    800024a4:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800024a6:	ffffe097          	auipc	ra,0xffffe
    800024aa:	792080e7          	jalr	1938(ra) # 80000c38 <acquire>
    p->state = RUNNABLE;
    800024ae:	478d                	li	a5,3
    800024b0:	cc9c                	sw	a5,24(s1)
    p->time_ticks = 0;
    800024b2:	0404a223          	sw	zero,68(s1)
    sched();
    800024b6:	00000097          	auipc	ra,0x0
    800024ba:	f0e080e7          	jalr	-242(ra) # 800023c4 <sched>
    release(&p->lock);
    800024be:	8526                	mv	a0,s1
    800024c0:	fffff097          	auipc	ra,0xfffff
    800024c4:	82c080e7          	jalr	-2004(ra) # 80000cec <release>
}
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	64a2                	ld	s1,8(sp)
    800024ce:	6105                	addi	sp,sp,32
    800024d0:	8082                	ret

00000000800024d2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800024d2:	7179                	addi	sp,sp,-48
    800024d4:	f406                	sd	ra,40(sp)
    800024d6:	f022                	sd	s0,32(sp)
    800024d8:	ec26                	sd	s1,24(sp)
    800024da:	e84a                	sd	s2,16(sp)
    800024dc:	e44e                	sd	s3,8(sp)
    800024de:	1800                	addi	s0,sp,48
    800024e0:	89aa                	mv	s3,a0
    800024e2:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800024e4:	00000097          	auipc	ra,0x0
    800024e8:	80a080e7          	jalr	-2038(ra) # 80001cee <myproc>
    800024ec:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800024ee:	ffffe097          	auipc	ra,0xffffe
    800024f2:	74a080e7          	jalr	1866(ra) # 80000c38 <acquire>
    release(lk);
    800024f6:	854a                	mv	a0,s2
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	7f4080e7          	jalr	2036(ra) # 80000cec <release>

    // Go to sleep.
    p->chan = chan;
    80002500:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80002504:	4789                	li	a5,2
    80002506:	cc9c                	sw	a5,24(s1)

    sched();
    80002508:	00000097          	auipc	ra,0x0
    8000250c:	ebc080e7          	jalr	-324(ra) # 800023c4 <sched>

    // Tidy up.
    p->chan = 0;
    80002510:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80002514:	8526                	mv	a0,s1
    80002516:	ffffe097          	auipc	ra,0xffffe
    8000251a:	7d6080e7          	jalr	2006(ra) # 80000cec <release>
    acquire(lk);
    8000251e:	854a                	mv	a0,s2
    80002520:	ffffe097          	auipc	ra,0xffffe
    80002524:	718080e7          	jalr	1816(ra) # 80000c38 <acquire>
}
    80002528:	70a2                	ld	ra,40(sp)
    8000252a:	7402                	ld	s0,32(sp)
    8000252c:	64e2                	ld	s1,24(sp)
    8000252e:	6942                	ld	s2,16(sp)
    80002530:	69a2                	ld	s3,8(sp)
    80002532:	6145                	addi	sp,sp,48
    80002534:	8082                	ret

0000000080002536 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002536:	7139                	addi	sp,sp,-64
    80002538:	fc06                	sd	ra,56(sp)
    8000253a:	f822                	sd	s0,48(sp)
    8000253c:	f426                	sd	s1,40(sp)
    8000253e:	f04a                	sd	s2,32(sp)
    80002540:	ec4e                	sd	s3,24(sp)
    80002542:	e852                	sd	s4,16(sp)
    80002544:	e456                	sd	s5,8(sp)
    80002546:	0080                	addi	s0,sp,64
    80002548:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000254a:	00011497          	auipc	s1,0x11
    8000254e:	65648493          	addi	s1,s1,1622 # 80013ba0 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002552:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80002554:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    80002556:	00017917          	auipc	s2,0x17
    8000255a:	24a90913          	addi	s2,s2,586 # 800197a0 <tickslock>
    8000255e:	a811                	j	80002572 <wakeup+0x3c>
            }
            release(&p->lock);
    80002560:	8526                	mv	a0,s1
    80002562:	ffffe097          	auipc	ra,0xffffe
    80002566:	78a080e7          	jalr	1930(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000256a:	17048493          	addi	s1,s1,368
    8000256e:	03248663          	beq	s1,s2,8000259a <wakeup+0x64>
        if (p != myproc())
    80002572:	fffff097          	auipc	ra,0xfffff
    80002576:	77c080e7          	jalr	1916(ra) # 80001cee <myproc>
    8000257a:	fea488e3          	beq	s1,a0,8000256a <wakeup+0x34>
            acquire(&p->lock);
    8000257e:	8526                	mv	a0,s1
    80002580:	ffffe097          	auipc	ra,0xffffe
    80002584:	6b8080e7          	jalr	1720(ra) # 80000c38 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80002588:	4c9c                	lw	a5,24(s1)
    8000258a:	fd379be3          	bne	a5,s3,80002560 <wakeup+0x2a>
    8000258e:	709c                	ld	a5,32(s1)
    80002590:	fd4798e3          	bne	a5,s4,80002560 <wakeup+0x2a>
                p->state = RUNNABLE;
    80002594:	0154ac23          	sw	s5,24(s1)
    80002598:	b7e1                	j	80002560 <wakeup+0x2a>
        }
    }
}
    8000259a:	70e2                	ld	ra,56(sp)
    8000259c:	7442                	ld	s0,48(sp)
    8000259e:	74a2                	ld	s1,40(sp)
    800025a0:	7902                	ld	s2,32(sp)
    800025a2:	69e2                	ld	s3,24(sp)
    800025a4:	6a42                	ld	s4,16(sp)
    800025a6:	6aa2                	ld	s5,8(sp)
    800025a8:	6121                	addi	sp,sp,64
    800025aa:	8082                	ret

00000000800025ac <reparent>:
{
    800025ac:	7179                	addi	sp,sp,-48
    800025ae:	f406                	sd	ra,40(sp)
    800025b0:	f022                	sd	s0,32(sp)
    800025b2:	ec26                	sd	s1,24(sp)
    800025b4:	e84a                	sd	s2,16(sp)
    800025b6:	e44e                	sd	s3,8(sp)
    800025b8:	e052                	sd	s4,0(sp)
    800025ba:	1800                	addi	s0,sp,48
    800025bc:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025be:	00011497          	auipc	s1,0x11
    800025c2:	5e248493          	addi	s1,s1,1506 # 80013ba0 <proc>
            pp->parent = initproc;
    800025c6:	00009a17          	auipc	s4,0x9
    800025ca:	f32a0a13          	addi	s4,s4,-206 # 8000b4f8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025ce:	00017997          	auipc	s3,0x17
    800025d2:	1d298993          	addi	s3,s3,466 # 800197a0 <tickslock>
    800025d6:	a029                	j	800025e0 <reparent+0x34>
    800025d8:	17048493          	addi	s1,s1,368
    800025dc:	01348d63          	beq	s1,s3,800025f6 <reparent+0x4a>
        if (pp->parent == p)
    800025e0:	7c9c                	ld	a5,56(s1)
    800025e2:	ff279be3          	bne	a5,s2,800025d8 <reparent+0x2c>
            pp->parent = initproc;
    800025e6:	000a3503          	ld	a0,0(s4)
    800025ea:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800025ec:	00000097          	auipc	ra,0x0
    800025f0:	f4a080e7          	jalr	-182(ra) # 80002536 <wakeup>
    800025f4:	b7d5                	j	800025d8 <reparent+0x2c>
}
    800025f6:	70a2                	ld	ra,40(sp)
    800025f8:	7402                	ld	s0,32(sp)
    800025fa:	64e2                	ld	s1,24(sp)
    800025fc:	6942                	ld	s2,16(sp)
    800025fe:	69a2                	ld	s3,8(sp)
    80002600:	6a02                	ld	s4,0(sp)
    80002602:	6145                	addi	sp,sp,48
    80002604:	8082                	ret

0000000080002606 <exit>:
{
    80002606:	7179                	addi	sp,sp,-48
    80002608:	f406                	sd	ra,40(sp)
    8000260a:	f022                	sd	s0,32(sp)
    8000260c:	ec26                	sd	s1,24(sp)
    8000260e:	e84a                	sd	s2,16(sp)
    80002610:	e44e                	sd	s3,8(sp)
    80002612:	e052                	sd	s4,0(sp)
    80002614:	1800                	addi	s0,sp,48
    80002616:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80002618:	fffff097          	auipc	ra,0xfffff
    8000261c:	6d6080e7          	jalr	1750(ra) # 80001cee <myproc>
    80002620:	89aa                	mv	s3,a0
    if (p == initproc)
    80002622:	00009797          	auipc	a5,0x9
    80002626:	ed67b783          	ld	a5,-298(a5) # 8000b4f8 <initproc>
    8000262a:	0d850493          	addi	s1,a0,216
    8000262e:	15850913          	addi	s2,a0,344
    80002632:	02a79363          	bne	a5,a0,80002658 <exit+0x52>
        panic("init exiting");
    80002636:	00006517          	auipc	a0,0x6
    8000263a:	c2250513          	addi	a0,a0,-990 # 80008258 <etext+0x258>
    8000263e:	ffffe097          	auipc	ra,0xffffe
    80002642:	f22080e7          	jalr	-222(ra) # 80000560 <panic>
            fileclose(f);
    80002646:	00002097          	auipc	ra,0x2
    8000264a:	534080e7          	jalr	1332(ra) # 80004b7a <fileclose>
            p->ofile[fd] = 0;
    8000264e:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80002652:	04a1                	addi	s1,s1,8
    80002654:	01248563          	beq	s1,s2,8000265e <exit+0x58>
        if (p->ofile[fd])
    80002658:	6088                	ld	a0,0(s1)
    8000265a:	f575                	bnez	a0,80002646 <exit+0x40>
    8000265c:	bfdd                	j	80002652 <exit+0x4c>
    begin_op();
    8000265e:	00002097          	auipc	ra,0x2
    80002662:	052080e7          	jalr	82(ra) # 800046b0 <begin_op>
    iput(p->cwd);
    80002666:	1589b503          	ld	a0,344(s3)
    8000266a:	00002097          	auipc	ra,0x2
    8000266e:	836080e7          	jalr	-1994(ra) # 80003ea0 <iput>
    end_op();
    80002672:	00002097          	auipc	ra,0x2
    80002676:	0b8080e7          	jalr	184(ra) # 8000472a <end_op>
    p->cwd = 0;
    8000267a:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    8000267e:	00011497          	auipc	s1,0x11
    80002682:	50a48493          	addi	s1,s1,1290 # 80013b88 <wait_lock>
    80002686:	8526                	mv	a0,s1
    80002688:	ffffe097          	auipc	ra,0xffffe
    8000268c:	5b0080e7          	jalr	1456(ra) # 80000c38 <acquire>
    reparent(p);
    80002690:	854e                	mv	a0,s3
    80002692:	00000097          	auipc	ra,0x0
    80002696:	f1a080e7          	jalr	-230(ra) # 800025ac <reparent>
    wakeup(p->parent);
    8000269a:	0389b503          	ld	a0,56(s3)
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	e98080e7          	jalr	-360(ra) # 80002536 <wakeup>
    acquire(&p->lock);
    800026a6:	854e                	mv	a0,s3
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	590080e7          	jalr	1424(ra) # 80000c38 <acquire>
    p->xstate = status;
    800026b0:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800026b4:	4795                	li	a5,5
    800026b6:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800026ba:	8526                	mv	a0,s1
    800026bc:	ffffe097          	auipc	ra,0xffffe
    800026c0:	630080e7          	jalr	1584(ra) # 80000cec <release>
    sched();
    800026c4:	00000097          	auipc	ra,0x0
    800026c8:	d00080e7          	jalr	-768(ra) # 800023c4 <sched>
    panic("zombie exit");
    800026cc:	00006517          	auipc	a0,0x6
    800026d0:	b9c50513          	addi	a0,a0,-1124 # 80008268 <etext+0x268>
    800026d4:	ffffe097          	auipc	ra,0xffffe
    800026d8:	e8c080e7          	jalr	-372(ra) # 80000560 <panic>

00000000800026dc <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800026dc:	7179                	addi	sp,sp,-48
    800026de:	f406                	sd	ra,40(sp)
    800026e0:	f022                	sd	s0,32(sp)
    800026e2:	ec26                	sd	s1,24(sp)
    800026e4:	e84a                	sd	s2,16(sp)
    800026e6:	e44e                	sd	s3,8(sp)
    800026e8:	1800                	addi	s0,sp,48
    800026ea:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800026ec:	00011497          	auipc	s1,0x11
    800026f0:	4b448493          	addi	s1,s1,1204 # 80013ba0 <proc>
    800026f4:	00017997          	auipc	s3,0x17
    800026f8:	0ac98993          	addi	s3,s3,172 # 800197a0 <tickslock>
    {
        acquire(&p->lock);
    800026fc:	8526                	mv	a0,s1
    800026fe:	ffffe097          	auipc	ra,0xffffe
    80002702:	53a080e7          	jalr	1338(ra) # 80000c38 <acquire>
        if (p->pid == pid)
    80002706:	589c                	lw	a5,48(s1)
    80002708:	01278d63          	beq	a5,s2,80002722 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    8000270c:	8526                	mv	a0,s1
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	5de080e7          	jalr	1502(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002716:	17048493          	addi	s1,s1,368
    8000271a:	ff3491e3          	bne	s1,s3,800026fc <kill+0x20>
    }
    return -1;
    8000271e:	557d                	li	a0,-1
    80002720:	a829                	j	8000273a <kill+0x5e>
            p->killed = 1;
    80002722:	4785                	li	a5,1
    80002724:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80002726:	4c98                	lw	a4,24(s1)
    80002728:	4789                	li	a5,2
    8000272a:	00f70f63          	beq	a4,a5,80002748 <kill+0x6c>
            release(&p->lock);
    8000272e:	8526                	mv	a0,s1
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	5bc080e7          	jalr	1468(ra) # 80000cec <release>
            return 0;
    80002738:	4501                	li	a0,0
}
    8000273a:	70a2                	ld	ra,40(sp)
    8000273c:	7402                	ld	s0,32(sp)
    8000273e:	64e2                	ld	s1,24(sp)
    80002740:	6942                	ld	s2,16(sp)
    80002742:	69a2                	ld	s3,8(sp)
    80002744:	6145                	addi	sp,sp,48
    80002746:	8082                	ret
                p->state = RUNNABLE;
    80002748:	478d                	li	a5,3
    8000274a:	cc9c                	sw	a5,24(s1)
    8000274c:	b7cd                	j	8000272e <kill+0x52>

000000008000274e <setkilled>:

void setkilled(struct proc *p)
{
    8000274e:	1101                	addi	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	1000                	addi	s0,sp,32
    80002758:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000275a:	ffffe097          	auipc	ra,0xffffe
    8000275e:	4de080e7          	jalr	1246(ra) # 80000c38 <acquire>
    p->killed = 1;
    80002762:	4785                	li	a5,1
    80002764:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80002766:	8526                	mv	a0,s1
    80002768:	ffffe097          	auipc	ra,0xffffe
    8000276c:	584080e7          	jalr	1412(ra) # 80000cec <release>
}
    80002770:	60e2                	ld	ra,24(sp)
    80002772:	6442                	ld	s0,16(sp)
    80002774:	64a2                	ld	s1,8(sp)
    80002776:	6105                	addi	sp,sp,32
    80002778:	8082                	ret

000000008000277a <killed>:

int killed(struct proc *p)
{
    8000277a:	1101                	addi	sp,sp,-32
    8000277c:	ec06                	sd	ra,24(sp)
    8000277e:	e822                	sd	s0,16(sp)
    80002780:	e426                	sd	s1,8(sp)
    80002782:	e04a                	sd	s2,0(sp)
    80002784:	1000                	addi	s0,sp,32
    80002786:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80002788:	ffffe097          	auipc	ra,0xffffe
    8000278c:	4b0080e7          	jalr	1200(ra) # 80000c38 <acquire>
    k = p->killed;
    80002790:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    80002794:	8526                	mv	a0,s1
    80002796:	ffffe097          	auipc	ra,0xffffe
    8000279a:	556080e7          	jalr	1366(ra) # 80000cec <release>
    return k;
}
    8000279e:	854a                	mv	a0,s2
    800027a0:	60e2                	ld	ra,24(sp)
    800027a2:	6442                	ld	s0,16(sp)
    800027a4:	64a2                	ld	s1,8(sp)
    800027a6:	6902                	ld	s2,0(sp)
    800027a8:	6105                	addi	sp,sp,32
    800027aa:	8082                	ret

00000000800027ac <wait>:
{
    800027ac:	715d                	addi	sp,sp,-80
    800027ae:	e486                	sd	ra,72(sp)
    800027b0:	e0a2                	sd	s0,64(sp)
    800027b2:	fc26                	sd	s1,56(sp)
    800027b4:	f84a                	sd	s2,48(sp)
    800027b6:	f44e                	sd	s3,40(sp)
    800027b8:	f052                	sd	s4,32(sp)
    800027ba:	ec56                	sd	s5,24(sp)
    800027bc:	e85a                	sd	s6,16(sp)
    800027be:	e45e                	sd	s7,8(sp)
    800027c0:	e062                	sd	s8,0(sp)
    800027c2:	0880                	addi	s0,sp,80
    800027c4:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800027c6:	fffff097          	auipc	ra,0xfffff
    800027ca:	528080e7          	jalr	1320(ra) # 80001cee <myproc>
    800027ce:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800027d0:	00011517          	auipc	a0,0x11
    800027d4:	3b850513          	addi	a0,a0,952 # 80013b88 <wait_lock>
    800027d8:	ffffe097          	auipc	ra,0xffffe
    800027dc:	460080e7          	jalr	1120(ra) # 80000c38 <acquire>
        havekids = 0;
    800027e0:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    800027e2:	4a15                	li	s4,5
                havekids = 1;
    800027e4:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027e6:	00017997          	auipc	s3,0x17
    800027ea:	fba98993          	addi	s3,s3,-70 # 800197a0 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800027ee:	00011c17          	auipc	s8,0x11
    800027f2:	39ac0c13          	addi	s8,s8,922 # 80013b88 <wait_lock>
    800027f6:	a0d1                	j	800028ba <wait+0x10e>
                    pid = pp->pid;
    800027f8:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800027fc:	000b0e63          	beqz	s6,80002818 <wait+0x6c>
    80002800:	4691                	li	a3,4
    80002802:	02c48613          	addi	a2,s1,44
    80002806:	85da                	mv	a1,s6
    80002808:	05893503          	ld	a0,88(s2)
    8000280c:	fffff097          	auipc	ra,0xfffff
    80002810:	ed6080e7          	jalr	-298(ra) # 800016e2 <copyout>
    80002814:	04054163          	bltz	a0,80002856 <wait+0xaa>
                    freeproc(pp);
    80002818:	8526                	mv	a0,s1
    8000281a:	fffff097          	auipc	ra,0xfffff
    8000281e:	686080e7          	jalr	1670(ra) # 80001ea0 <freeproc>
                    release(&pp->lock);
    80002822:	8526                	mv	a0,s1
    80002824:	ffffe097          	auipc	ra,0xffffe
    80002828:	4c8080e7          	jalr	1224(ra) # 80000cec <release>
                    release(&wait_lock);
    8000282c:	00011517          	auipc	a0,0x11
    80002830:	35c50513          	addi	a0,a0,860 # 80013b88 <wait_lock>
    80002834:	ffffe097          	auipc	ra,0xffffe
    80002838:	4b8080e7          	jalr	1208(ra) # 80000cec <release>
}
    8000283c:	854e                	mv	a0,s3
    8000283e:	60a6                	ld	ra,72(sp)
    80002840:	6406                	ld	s0,64(sp)
    80002842:	74e2                	ld	s1,56(sp)
    80002844:	7942                	ld	s2,48(sp)
    80002846:	79a2                	ld	s3,40(sp)
    80002848:	7a02                	ld	s4,32(sp)
    8000284a:	6ae2                	ld	s5,24(sp)
    8000284c:	6b42                	ld	s6,16(sp)
    8000284e:	6ba2                	ld	s7,8(sp)
    80002850:	6c02                	ld	s8,0(sp)
    80002852:	6161                	addi	sp,sp,80
    80002854:	8082                	ret
                        release(&pp->lock);
    80002856:	8526                	mv	a0,s1
    80002858:	ffffe097          	auipc	ra,0xffffe
    8000285c:	494080e7          	jalr	1172(ra) # 80000cec <release>
                        release(&wait_lock);
    80002860:	00011517          	auipc	a0,0x11
    80002864:	32850513          	addi	a0,a0,808 # 80013b88 <wait_lock>
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	484080e7          	jalr	1156(ra) # 80000cec <release>
                        return -1;
    80002870:	59fd                	li	s3,-1
    80002872:	b7e9                	j	8000283c <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002874:	17048493          	addi	s1,s1,368
    80002878:	03348463          	beq	s1,s3,800028a0 <wait+0xf4>
            if (pp->parent == p)
    8000287c:	7c9c                	ld	a5,56(s1)
    8000287e:	ff279be3          	bne	a5,s2,80002874 <wait+0xc8>
                acquire(&pp->lock);
    80002882:	8526                	mv	a0,s1
    80002884:	ffffe097          	auipc	ra,0xffffe
    80002888:	3b4080e7          	jalr	948(ra) # 80000c38 <acquire>
                if (pp->state == ZOMBIE)
    8000288c:	4c9c                	lw	a5,24(s1)
    8000288e:	f74785e3          	beq	a5,s4,800027f8 <wait+0x4c>
                release(&pp->lock);
    80002892:	8526                	mv	a0,s1
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	458080e7          	jalr	1112(ra) # 80000cec <release>
                havekids = 1;
    8000289c:	8756                	mv	a4,s5
    8000289e:	bfd9                	j	80002874 <wait+0xc8>
        if (!havekids || killed(p))
    800028a0:	c31d                	beqz	a4,800028c6 <wait+0x11a>
    800028a2:	854a                	mv	a0,s2
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	ed6080e7          	jalr	-298(ra) # 8000277a <killed>
    800028ac:	ed09                	bnez	a0,800028c6 <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800028ae:	85e2                	mv	a1,s8
    800028b0:	854a                	mv	a0,s2
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	c20080e7          	jalr	-992(ra) # 800024d2 <sleep>
        havekids = 0;
    800028ba:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800028bc:	00011497          	auipc	s1,0x11
    800028c0:	2e448493          	addi	s1,s1,740 # 80013ba0 <proc>
    800028c4:	bf65                	j	8000287c <wait+0xd0>
            release(&wait_lock);
    800028c6:	00011517          	auipc	a0,0x11
    800028ca:	2c250513          	addi	a0,a0,706 # 80013b88 <wait_lock>
    800028ce:	ffffe097          	auipc	ra,0xffffe
    800028d2:	41e080e7          	jalr	1054(ra) # 80000cec <release>
            return -1;
    800028d6:	59fd                	li	s3,-1
    800028d8:	b795                	j	8000283c <wait+0x90>

00000000800028da <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800028da:	7179                	addi	sp,sp,-48
    800028dc:	f406                	sd	ra,40(sp)
    800028de:	f022                	sd	s0,32(sp)
    800028e0:	ec26                	sd	s1,24(sp)
    800028e2:	e84a                	sd	s2,16(sp)
    800028e4:	e44e                	sd	s3,8(sp)
    800028e6:	e052                	sd	s4,0(sp)
    800028e8:	1800                	addi	s0,sp,48
    800028ea:	84aa                	mv	s1,a0
    800028ec:	892e                	mv	s2,a1
    800028ee:	89b2                	mv	s3,a2
    800028f0:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800028f2:	fffff097          	auipc	ra,0xfffff
    800028f6:	3fc080e7          	jalr	1020(ra) # 80001cee <myproc>
    if (user_dst)
    800028fa:	c08d                	beqz	s1,8000291c <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    800028fc:	86d2                	mv	a3,s4
    800028fe:	864e                	mv	a2,s3
    80002900:	85ca                	mv	a1,s2
    80002902:	6d28                	ld	a0,88(a0)
    80002904:	fffff097          	auipc	ra,0xfffff
    80002908:	dde080e7          	jalr	-546(ra) # 800016e2 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    8000290c:	70a2                	ld	ra,40(sp)
    8000290e:	7402                	ld	s0,32(sp)
    80002910:	64e2                	ld	s1,24(sp)
    80002912:	6942                	ld	s2,16(sp)
    80002914:	69a2                	ld	s3,8(sp)
    80002916:	6a02                	ld	s4,0(sp)
    80002918:	6145                	addi	sp,sp,48
    8000291a:	8082                	ret
        memmove((char *)dst, src, len);
    8000291c:	000a061b          	sext.w	a2,s4
    80002920:	85ce                	mv	a1,s3
    80002922:	854a                	mv	a0,s2
    80002924:	ffffe097          	auipc	ra,0xffffe
    80002928:	46c080e7          	jalr	1132(ra) # 80000d90 <memmove>
        return 0;
    8000292c:	8526                	mv	a0,s1
    8000292e:	bff9                	j	8000290c <either_copyout+0x32>

0000000080002930 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002930:	7179                	addi	sp,sp,-48
    80002932:	f406                	sd	ra,40(sp)
    80002934:	f022                	sd	s0,32(sp)
    80002936:	ec26                	sd	s1,24(sp)
    80002938:	e84a                	sd	s2,16(sp)
    8000293a:	e44e                	sd	s3,8(sp)
    8000293c:	e052                	sd	s4,0(sp)
    8000293e:	1800                	addi	s0,sp,48
    80002940:	892a                	mv	s2,a0
    80002942:	84ae                	mv	s1,a1
    80002944:	89b2                	mv	s3,a2
    80002946:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002948:	fffff097          	auipc	ra,0xfffff
    8000294c:	3a6080e7          	jalr	934(ra) # 80001cee <myproc>
    if (user_src)
    80002950:	c08d                	beqz	s1,80002972 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002952:	86d2                	mv	a3,s4
    80002954:	864e                	mv	a2,s3
    80002956:	85ca                	mv	a1,s2
    80002958:	6d28                	ld	a0,88(a0)
    8000295a:	fffff097          	auipc	ra,0xfffff
    8000295e:	e14080e7          	jalr	-492(ra) # 8000176e <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002962:	70a2                	ld	ra,40(sp)
    80002964:	7402                	ld	s0,32(sp)
    80002966:	64e2                	ld	s1,24(sp)
    80002968:	6942                	ld	s2,16(sp)
    8000296a:	69a2                	ld	s3,8(sp)
    8000296c:	6a02                	ld	s4,0(sp)
    8000296e:	6145                	addi	sp,sp,48
    80002970:	8082                	ret
        memmove(dst, (char *)src, len);
    80002972:	000a061b          	sext.w	a2,s4
    80002976:	85ce                	mv	a1,s3
    80002978:	854a                	mv	a0,s2
    8000297a:	ffffe097          	auipc	ra,0xffffe
    8000297e:	416080e7          	jalr	1046(ra) # 80000d90 <memmove>
        return 0;
    80002982:	8526                	mv	a0,s1
    80002984:	bff9                	j	80002962 <either_copyin+0x32>

0000000080002986 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002986:	715d                	addi	sp,sp,-80
    80002988:	e486                	sd	ra,72(sp)
    8000298a:	e0a2                	sd	s0,64(sp)
    8000298c:	fc26                	sd	s1,56(sp)
    8000298e:	f84a                	sd	s2,48(sp)
    80002990:	f44e                	sd	s3,40(sp)
    80002992:	f052                	sd	s4,32(sp)
    80002994:	ec56                	sd	s5,24(sp)
    80002996:	e85a                	sd	s6,16(sp)
    80002998:	e45e                	sd	s7,8(sp)
    8000299a:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    8000299c:	00005517          	auipc	a0,0x5
    800029a0:	67450513          	addi	a0,a0,1652 # 80008010 <etext+0x10>
    800029a4:	ffffe097          	auipc	ra,0xffffe
    800029a8:	c06080e7          	jalr	-1018(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800029ac:	00011497          	auipc	s1,0x11
    800029b0:	35448493          	addi	s1,s1,852 # 80013d00 <proc+0x160>
    800029b4:	00017917          	auipc	s2,0x17
    800029b8:	f4c90913          	addi	s2,s2,-180 # 80019900 <bcache+0x148>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029bc:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800029be:	00006997          	auipc	s3,0x6
    800029c2:	8ba98993          	addi	s3,s3,-1862 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    800029c6:	00006a97          	auipc	s5,0x6
    800029ca:	8baa8a93          	addi	s5,s5,-1862 # 80008280 <etext+0x280>
        printf("\n");
    800029ce:	00005a17          	auipc	s4,0x5
    800029d2:	642a0a13          	addi	s4,s4,1602 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029d6:	00006b97          	auipc	s7,0x6
    800029da:	e52b8b93          	addi	s7,s7,-430 # 80008828 <states.0>
    800029de:	a00d                	j	80002a00 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    800029e0:	ed06a583          	lw	a1,-304(a3)
    800029e4:	8556                	mv	a0,s5
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	bc4080e7          	jalr	-1084(ra) # 800005aa <printf>
        printf("\n");
    800029ee:	8552                	mv	a0,s4
    800029f0:	ffffe097          	auipc	ra,0xffffe
    800029f4:	bba080e7          	jalr	-1094(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800029f8:	17048493          	addi	s1,s1,368
    800029fc:	03248263          	beq	s1,s2,80002a20 <procdump+0x9a>
        if (p->state == UNUSED)
    80002a00:	86a6                	mv	a3,s1
    80002a02:	eb84a783          	lw	a5,-328(s1)
    80002a06:	dbed                	beqz	a5,800029f8 <procdump+0x72>
            state = "???";
    80002a08:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a0a:	fcfb6be3          	bltu	s6,a5,800029e0 <procdump+0x5a>
    80002a0e:	02079713          	slli	a4,a5,0x20
    80002a12:	01d75793          	srli	a5,a4,0x1d
    80002a16:	97de                	add	a5,a5,s7
    80002a18:	6390                	ld	a2,0(a5)
    80002a1a:	f279                	bnez	a2,800029e0 <procdump+0x5a>
            state = "???";
    80002a1c:	864e                	mv	a2,s3
    80002a1e:	b7c9                	j	800029e0 <procdump+0x5a>
    }
}
    80002a20:	60a6                	ld	ra,72(sp)
    80002a22:	6406                	ld	s0,64(sp)
    80002a24:	74e2                	ld	s1,56(sp)
    80002a26:	7942                	ld	s2,48(sp)
    80002a28:	79a2                	ld	s3,40(sp)
    80002a2a:	7a02                	ld	s4,32(sp)
    80002a2c:	6ae2                	ld	s5,24(sp)
    80002a2e:	6b42                	ld	s6,16(sp)
    80002a30:	6ba2                	ld	s7,8(sp)
    80002a32:	6161                	addi	sp,sp,80
    80002a34:	8082                	ret

0000000080002a36 <schedls>:

void schedls()
{
    80002a36:	1101                	addi	sp,sp,-32
    80002a38:	ec06                	sd	ra,24(sp)
    80002a3a:	e822                	sd	s0,16(sp)
    80002a3c:	e426                	sd	s1,8(sp)
    80002a3e:	1000                	addi	s0,sp,32
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002a40:	00006517          	auipc	a0,0x6
    80002a44:	85050513          	addi	a0,a0,-1968 # 80008290 <etext+0x290>
    80002a48:	ffffe097          	auipc	ra,0xffffe
    80002a4c:	b62080e7          	jalr	-1182(ra) # 800005aa <printf>
    printf("====================================\n");
    80002a50:	00006517          	auipc	a0,0x6
    80002a54:	86850513          	addi	a0,a0,-1944 # 800082b8 <etext+0x2b8>
    80002a58:	ffffe097          	auipc	ra,0xffffe
    80002a5c:	b52080e7          	jalr	-1198(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002a60:	00009717          	auipc	a4,0x9
    80002a64:	a1873703          	ld	a4,-1512(a4) # 8000b478 <available_schedulers+0x10>
    80002a68:	00009797          	auipc	a5,0x9
    80002a6c:	9b07b783          	ld	a5,-1616(a5) # 8000b418 <sched_pointer>
    80002a70:	08f70763          	beq	a4,a5,80002afe <schedls+0xc8>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002a74:	00006517          	auipc	a0,0x6
    80002a78:	86c50513          	addi	a0,a0,-1940 # 800082e0 <etext+0x2e0>
    80002a7c:	ffffe097          	auipc	ra,0xffffe
    80002a80:	b2e080e7          	jalr	-1234(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002a84:	00009497          	auipc	s1,0x9
    80002a88:	9ac48493          	addi	s1,s1,-1620 # 8000b430 <initcode>
    80002a8c:	48b0                	lw	a2,80(s1)
    80002a8e:	00009597          	auipc	a1,0x9
    80002a92:	9da58593          	addi	a1,a1,-1574 # 8000b468 <available_schedulers>
    80002a96:	00006517          	auipc	a0,0x6
    80002a9a:	85a50513          	addi	a0,a0,-1958 # 800082f0 <etext+0x2f0>
    80002a9e:	ffffe097          	auipc	ra,0xffffe
    80002aa2:	b0c080e7          	jalr	-1268(ra) # 800005aa <printf>
        if (available_schedulers[i].impl == sched_pointer)
    80002aa6:	74b8                	ld	a4,104(s1)
    80002aa8:	00009797          	auipc	a5,0x9
    80002aac:	9707b783          	ld	a5,-1680(a5) # 8000b418 <sched_pointer>
    80002ab0:	06f70063          	beq	a4,a5,80002b10 <schedls+0xda>
            printf("   \t");
    80002ab4:	00006517          	auipc	a0,0x6
    80002ab8:	82c50513          	addi	a0,a0,-2004 # 800082e0 <etext+0x2e0>
    80002abc:	ffffe097          	auipc	ra,0xffffe
    80002ac0:	aee080e7          	jalr	-1298(ra) # 800005aa <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002ac4:	00009617          	auipc	a2,0x9
    80002ac8:	9dc62603          	lw	a2,-1572(a2) # 8000b4a0 <available_schedulers+0x38>
    80002acc:	00009597          	auipc	a1,0x9
    80002ad0:	9bc58593          	addi	a1,a1,-1604 # 8000b488 <available_schedulers+0x20>
    80002ad4:	00006517          	auipc	a0,0x6
    80002ad8:	81c50513          	addi	a0,a0,-2020 # 800082f0 <etext+0x2f0>
    80002adc:	ffffe097          	auipc	ra,0xffffe
    80002ae0:	ace080e7          	jalr	-1330(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	81450513          	addi	a0,a0,-2028 # 800082f8 <etext+0x2f8>
    80002aec:	ffffe097          	auipc	ra,0xffffe
    80002af0:	abe080e7          	jalr	-1346(ra) # 800005aa <printf>
}
    80002af4:	60e2                	ld	ra,24(sp)
    80002af6:	6442                	ld	s0,16(sp)
    80002af8:	64a2                	ld	s1,8(sp)
    80002afa:	6105                	addi	sp,sp,32
    80002afc:	8082                	ret
            printf("[*]\t");
    80002afe:	00005517          	auipc	a0,0x5
    80002b02:	7ea50513          	addi	a0,a0,2026 # 800082e8 <etext+0x2e8>
    80002b06:	ffffe097          	auipc	ra,0xffffe
    80002b0a:	aa4080e7          	jalr	-1372(ra) # 800005aa <printf>
    80002b0e:	bf9d                	j	80002a84 <schedls+0x4e>
    80002b10:	00005517          	auipc	a0,0x5
    80002b14:	7d850513          	addi	a0,a0,2008 # 800082e8 <etext+0x2e8>
    80002b18:	ffffe097          	auipc	ra,0xffffe
    80002b1c:	a92080e7          	jalr	-1390(ra) # 800005aa <printf>
    80002b20:	b755                	j	80002ac4 <schedls+0x8e>

0000000080002b22 <schedset>:

void schedset(int id)
{
    80002b22:	1141                	addi	sp,sp,-16
    80002b24:	e406                	sd	ra,8(sp)
    80002b26:	e022                	sd	s0,0(sp)
    80002b28:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002b2a:	4705                	li	a4,1
    80002b2c:	02a76f63          	bltu	a4,a0,80002b6a <schedset+0x48>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002b30:	00551793          	slli	a5,a0,0x5
    80002b34:	00009717          	auipc	a4,0x9
    80002b38:	8fc70713          	addi	a4,a4,-1796 # 8000b430 <initcode>
    80002b3c:	973e                	add	a4,a4,a5
    80002b3e:	6738                	ld	a4,72(a4)
    80002b40:	00009697          	auipc	a3,0x9
    80002b44:	8ce6bc23          	sd	a4,-1832(a3) # 8000b418 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002b48:	00009597          	auipc	a1,0x9
    80002b4c:	92058593          	addi	a1,a1,-1760 # 8000b468 <available_schedulers>
    80002b50:	95be                	add	a1,a1,a5
    80002b52:	00005517          	auipc	a0,0x5
    80002b56:	7e650513          	addi	a0,a0,2022 # 80008338 <etext+0x338>
    80002b5a:	ffffe097          	auipc	ra,0xffffe
    80002b5e:	a50080e7          	jalr	-1456(ra) # 800005aa <printf>
    80002b62:	60a2                	ld	ra,8(sp)
    80002b64:	6402                	ld	s0,0(sp)
    80002b66:	0141                	addi	sp,sp,16
    80002b68:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002b6a:	00005517          	auipc	a0,0x5
    80002b6e:	7a650513          	addi	a0,a0,1958 # 80008310 <etext+0x310>
    80002b72:	ffffe097          	auipc	ra,0xffffe
    80002b76:	a38080e7          	jalr	-1480(ra) # 800005aa <printf>
        return;
    80002b7a:	b7e5                	j	80002b62 <schedset+0x40>

0000000080002b7c <swtch>:
    80002b7c:	00153023          	sd	ra,0(a0)
    80002b80:	00253423          	sd	sp,8(a0)
    80002b84:	e900                	sd	s0,16(a0)
    80002b86:	ed04                	sd	s1,24(a0)
    80002b88:	03253023          	sd	s2,32(a0)
    80002b8c:	03353423          	sd	s3,40(a0)
    80002b90:	03453823          	sd	s4,48(a0)
    80002b94:	03553c23          	sd	s5,56(a0)
    80002b98:	05653023          	sd	s6,64(a0)
    80002b9c:	05753423          	sd	s7,72(a0)
    80002ba0:	05853823          	sd	s8,80(a0)
    80002ba4:	05953c23          	sd	s9,88(a0)
    80002ba8:	07a53023          	sd	s10,96(a0)
    80002bac:	07b53423          	sd	s11,104(a0)
    80002bb0:	0005b083          	ld	ra,0(a1)
    80002bb4:	0085b103          	ld	sp,8(a1)
    80002bb8:	6980                	ld	s0,16(a1)
    80002bba:	6d84                	ld	s1,24(a1)
    80002bbc:	0205b903          	ld	s2,32(a1)
    80002bc0:	0285b983          	ld	s3,40(a1)
    80002bc4:	0305ba03          	ld	s4,48(a1)
    80002bc8:	0385ba83          	ld	s5,56(a1)
    80002bcc:	0405bb03          	ld	s6,64(a1)
    80002bd0:	0485bb83          	ld	s7,72(a1)
    80002bd4:	0505bc03          	ld	s8,80(a1)
    80002bd8:	0585bc83          	ld	s9,88(a1)
    80002bdc:	0605bd03          	ld	s10,96(a1)
    80002be0:	0685bd83          	ld	s11,104(a1)
    80002be4:	8082                	ret

0000000080002be6 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002be6:	1141                	addi	sp,sp,-16
    80002be8:	e406                	sd	ra,8(sp)
    80002bea:	e022                	sd	s0,0(sp)
    80002bec:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002bee:	00005597          	auipc	a1,0x5
    80002bf2:	7a258593          	addi	a1,a1,1954 # 80008390 <etext+0x390>
    80002bf6:	00017517          	auipc	a0,0x17
    80002bfa:	baa50513          	addi	a0,a0,-1110 # 800197a0 <tickslock>
    80002bfe:	ffffe097          	auipc	ra,0xffffe
    80002c02:	faa080e7          	jalr	-86(ra) # 80000ba8 <initlock>
}
    80002c06:	60a2                	ld	ra,8(sp)
    80002c08:	6402                	ld	s0,0(sp)
    80002c0a:	0141                	addi	sp,sp,16
    80002c0c:	8082                	ret

0000000080002c0e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002c0e:	1141                	addi	sp,sp,-16
    80002c10:	e422                	sd	s0,8(sp)
    80002c12:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c14:	00003797          	auipc	a5,0x3
    80002c18:	66c78793          	addi	a5,a5,1644 # 80006280 <kernelvec>
    80002c1c:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002c20:	6422                	ld	s0,8(sp)
    80002c22:	0141                	addi	sp,sp,16
    80002c24:	8082                	ret

0000000080002c26 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002c26:	1141                	addi	sp,sp,-16
    80002c28:	e406                	sd	ra,8(sp)
    80002c2a:	e022                	sd	s0,0(sp)
    80002c2c:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002c2e:	fffff097          	auipc	ra,0xfffff
    80002c32:	0c0080e7          	jalr	192(ra) # 80001cee <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c36:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c3a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c3c:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002c40:	00004697          	auipc	a3,0x4
    80002c44:	3c068693          	addi	a3,a3,960 # 80007000 <_trampoline>
    80002c48:	00004717          	auipc	a4,0x4
    80002c4c:	3b870713          	addi	a4,a4,952 # 80007000 <_trampoline>
    80002c50:	8f15                	sub	a4,a4,a3
    80002c52:	040007b7          	lui	a5,0x4000
    80002c56:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002c58:	07b2                	slli	a5,a5,0xc
    80002c5a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c5c:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002c60:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002c62:	18002673          	csrr	a2,satp
    80002c66:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c68:	7130                	ld	a2,96(a0)
    80002c6a:	6538                	ld	a4,72(a0)
    80002c6c:	6585                	lui	a1,0x1
    80002c6e:	972e                	add	a4,a4,a1
    80002c70:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002c72:	7138                	ld	a4,96(a0)
    80002c74:	00000617          	auipc	a2,0x0
    80002c78:	13860613          	addi	a2,a2,312 # 80002dac <usertrap>
    80002c7c:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002c7e:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c80:	8612                	mv	a2,tp
    80002c82:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c84:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c88:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002c8c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c90:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002c94:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002c96:	6f18                	ld	a4,24(a4)
    80002c98:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002c9c:	6d28                	ld	a0,88(a0)
    80002c9e:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002ca0:	00004717          	auipc	a4,0x4
    80002ca4:	3fc70713          	addi	a4,a4,1020 # 8000709c <userret>
    80002ca8:	8f15                	sub	a4,a4,a3
    80002caa:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002cac:	577d                	li	a4,-1
    80002cae:	177e                	slli	a4,a4,0x3f
    80002cb0:	8d59                	or	a0,a0,a4
    80002cb2:	9782                	jalr	a5
}
    80002cb4:	60a2                	ld	ra,8(sp)
    80002cb6:	6402                	ld	s0,0(sp)
    80002cb8:	0141                	addi	sp,sp,16
    80002cba:	8082                	ret

0000000080002cbc <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002cbc:	1101                	addi	sp,sp,-32
    80002cbe:	ec06                	sd	ra,24(sp)
    80002cc0:	e822                	sd	s0,16(sp)
    80002cc2:	e426                	sd	s1,8(sp)
    80002cc4:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002cc6:	00017497          	auipc	s1,0x17
    80002cca:	ada48493          	addi	s1,s1,-1318 # 800197a0 <tickslock>
    80002cce:	8526                	mv	a0,s1
    80002cd0:	ffffe097          	auipc	ra,0xffffe
    80002cd4:	f68080e7          	jalr	-152(ra) # 80000c38 <acquire>
    ticks++;
    80002cd8:	00009517          	auipc	a0,0x9
    80002cdc:	82850513          	addi	a0,a0,-2008 # 8000b500 <ticks>
    80002ce0:	411c                	lw	a5,0(a0)
    80002ce2:	2785                	addiw	a5,a5,1
    80002ce4:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002ce6:	00000097          	auipc	ra,0x0
    80002cea:	850080e7          	jalr	-1968(ra) # 80002536 <wakeup>
    release(&tickslock);
    80002cee:	8526                	mv	a0,s1
    80002cf0:	ffffe097          	auipc	ra,0xffffe
    80002cf4:	ffc080e7          	jalr	-4(ra) # 80000cec <release>
}
    80002cf8:	60e2                	ld	ra,24(sp)
    80002cfa:	6442                	ld	s0,16(sp)
    80002cfc:	64a2                	ld	s1,8(sp)
    80002cfe:	6105                	addi	sp,sp,32
    80002d00:	8082                	ret

0000000080002d02 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d02:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002d06:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002d08:	0a07d163          	bgez	a5,80002daa <devintr+0xa8>
{
    80002d0c:	1101                	addi	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002d14:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002d18:	46a5                	li	a3,9
    80002d1a:	00d70c63          	beq	a4,a3,80002d32 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002d1e:	577d                	li	a4,-1
    80002d20:	177e                	slli	a4,a4,0x3f
    80002d22:	0705                	addi	a4,a4,1
        return 0;
    80002d24:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002d26:	06e78163          	beq	a5,a4,80002d88 <devintr+0x86>
    }
}
    80002d2a:	60e2                	ld	ra,24(sp)
    80002d2c:	6442                	ld	s0,16(sp)
    80002d2e:	6105                	addi	sp,sp,32
    80002d30:	8082                	ret
    80002d32:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002d34:	00003097          	auipc	ra,0x3
    80002d38:	658080e7          	jalr	1624(ra) # 8000638c <plic_claim>
    80002d3c:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002d3e:	47a9                	li	a5,10
    80002d40:	00f50963          	beq	a0,a5,80002d52 <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002d44:	4785                	li	a5,1
    80002d46:	00f50b63          	beq	a0,a5,80002d5c <devintr+0x5a>
        return 1;
    80002d4a:	4505                	li	a0,1
        else if (irq)
    80002d4c:	ec89                	bnez	s1,80002d66 <devintr+0x64>
    80002d4e:	64a2                	ld	s1,8(sp)
    80002d50:	bfe9                	j	80002d2a <devintr+0x28>
            uartintr();
    80002d52:	ffffe097          	auipc	ra,0xffffe
    80002d56:	ca8080e7          	jalr	-856(ra) # 800009fa <uartintr>
        if (irq)
    80002d5a:	a839                	j	80002d78 <devintr+0x76>
            virtio_disk_intr();
    80002d5c:	00004097          	auipc	ra,0x4
    80002d60:	b5a080e7          	jalr	-1190(ra) # 800068b6 <virtio_disk_intr>
        if (irq)
    80002d64:	a811                	j	80002d78 <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002d66:	85a6                	mv	a1,s1
    80002d68:	00005517          	auipc	a0,0x5
    80002d6c:	63050513          	addi	a0,a0,1584 # 80008398 <etext+0x398>
    80002d70:	ffffe097          	auipc	ra,0xffffe
    80002d74:	83a080e7          	jalr	-1990(ra) # 800005aa <printf>
            plic_complete(irq);
    80002d78:	8526                	mv	a0,s1
    80002d7a:	00003097          	auipc	ra,0x3
    80002d7e:	636080e7          	jalr	1590(ra) # 800063b0 <plic_complete>
        return 1;
    80002d82:	4505                	li	a0,1
    80002d84:	64a2                	ld	s1,8(sp)
    80002d86:	b755                	j	80002d2a <devintr+0x28>
        if (cpuid() == 0)
    80002d88:	fffff097          	auipc	ra,0xfffff
    80002d8c:	f3a080e7          	jalr	-198(ra) # 80001cc2 <cpuid>
    80002d90:	c901                	beqz	a0,80002da0 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002d92:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002d96:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002d98:	14479073          	csrw	sip,a5
        return 2;
    80002d9c:	4509                	li	a0,2
    80002d9e:	b771                	j	80002d2a <devintr+0x28>
            clockintr();
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	f1c080e7          	jalr	-228(ra) # 80002cbc <clockintr>
    80002da8:	b7ed                	j	80002d92 <devintr+0x90>
}
    80002daa:	8082                	ret

0000000080002dac <usertrap>:
{
    80002dac:	1101                	addi	sp,sp,-32
    80002dae:	ec06                	sd	ra,24(sp)
    80002db0:	e822                	sd	s0,16(sp)
    80002db2:	e426                	sd	s1,8(sp)
    80002db4:	e04a                	sd	s2,0(sp)
    80002db6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002db8:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002dbc:	1007f793          	andi	a5,a5,256
    80002dc0:	e3b1                	bnez	a5,80002e04 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002dc2:	00003797          	auipc	a5,0x3
    80002dc6:	4be78793          	addi	a5,a5,1214 # 80006280 <kernelvec>
    80002dca:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002dce:	fffff097          	auipc	ra,0xfffff
    80002dd2:	f20080e7          	jalr	-224(ra) # 80001cee <myproc>
    80002dd6:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002dd8:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dda:	14102773          	csrr	a4,sepc
    80002dde:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002de0:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002de4:	47a1                	li	a5,8
    80002de6:	02f70763          	beq	a4,a5,80002e14 <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002dea:	00000097          	auipc	ra,0x0
    80002dee:	f18080e7          	jalr	-232(ra) # 80002d02 <devintr>
    80002df2:	892a                	mv	s2,a0
    80002df4:	c151                	beqz	a0,80002e78 <usertrap+0xcc>
    if (killed(p))
    80002df6:	8526                	mv	a0,s1
    80002df8:	00000097          	auipc	ra,0x0
    80002dfc:	982080e7          	jalr	-1662(ra) # 8000277a <killed>
    80002e00:	c929                	beqz	a0,80002e52 <usertrap+0xa6>
    80002e02:	a099                	j	80002e48 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002e04:	00005517          	auipc	a0,0x5
    80002e08:	5b450513          	addi	a0,a0,1460 # 800083b8 <etext+0x3b8>
    80002e0c:	ffffd097          	auipc	ra,0xffffd
    80002e10:	754080e7          	jalr	1876(ra) # 80000560 <panic>
        if (killed(p))
    80002e14:	00000097          	auipc	ra,0x0
    80002e18:	966080e7          	jalr	-1690(ra) # 8000277a <killed>
    80002e1c:	e921                	bnez	a0,80002e6c <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002e1e:	70b8                	ld	a4,96(s1)
    80002e20:	6f1c                	ld	a5,24(a4)
    80002e22:	0791                	addi	a5,a5,4
    80002e24:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e2a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e2e:	10079073          	csrw	sstatus,a5
        syscall();
    80002e32:	00000097          	auipc	ra,0x0
    80002e36:	2d8080e7          	jalr	728(ra) # 8000310a <syscall>
    if (killed(p))
    80002e3a:	8526                	mv	a0,s1
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	93e080e7          	jalr	-1730(ra) # 8000277a <killed>
    80002e44:	c911                	beqz	a0,80002e58 <usertrap+0xac>
    80002e46:	4901                	li	s2,0
        exit(-1);
    80002e48:	557d                	li	a0,-1
    80002e4a:	fffff097          	auipc	ra,0xfffff
    80002e4e:	7bc080e7          	jalr	1980(ra) # 80002606 <exit>
    if (which_dev == 2) {
    80002e52:	4789                	li	a5,2
    80002e54:	04f90f63          	beq	s2,a5,80002eb2 <usertrap+0x106>
    usertrapret();
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	dce080e7          	jalr	-562(ra) # 80002c26 <usertrapret>
}
    80002e60:	60e2                	ld	ra,24(sp)
    80002e62:	6442                	ld	s0,16(sp)
    80002e64:	64a2                	ld	s1,8(sp)
    80002e66:	6902                	ld	s2,0(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret
            exit(-1);
    80002e6c:	557d                	li	a0,-1
    80002e6e:	fffff097          	auipc	ra,0xfffff
    80002e72:	798080e7          	jalr	1944(ra) # 80002606 <exit>
    80002e76:	b765                	j	80002e1e <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e78:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002e7c:	5890                	lw	a2,48(s1)
    80002e7e:	00005517          	auipc	a0,0x5
    80002e82:	55a50513          	addi	a0,a0,1370 # 800083d8 <etext+0x3d8>
    80002e86:	ffffd097          	auipc	ra,0xffffd
    80002e8a:	724080e7          	jalr	1828(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e8e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e92:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e96:	00005517          	auipc	a0,0x5
    80002e9a:	57250513          	addi	a0,a0,1394 # 80008408 <etext+0x408>
    80002e9e:	ffffd097          	auipc	ra,0xffffd
    80002ea2:	70c080e7          	jalr	1804(ra) # 800005aa <printf>
        setkilled(p);
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	8a6080e7          	jalr	-1882(ra) # 8000274e <setkilled>
    80002eb0:	b769                	j	80002e3a <usertrap+0x8e>
       yield(YIELD_TIMER); // yield
    80002eb2:	4505                	li	a0,1
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	5de080e7          	jalr	1502(ra) # 80002492 <yield>
    80002ebc:	bf71                	j	80002e58 <usertrap+0xac>

0000000080002ebe <kerneltrap>:
{
    80002ebe:	7179                	addi	sp,sp,-48
    80002ec0:	f406                	sd	ra,40(sp)
    80002ec2:	f022                	sd	s0,32(sp)
    80002ec4:	ec26                	sd	s1,24(sp)
    80002ec6:	e84a                	sd	s2,16(sp)
    80002ec8:	e44e                	sd	s3,8(sp)
    80002eca:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ecc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ed0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ed4:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002ed8:	1004f793          	andi	a5,s1,256
    80002edc:	cb85                	beqz	a5,80002f0c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ede:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002ee2:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002ee4:	ef85                	bnez	a5,80002f1c <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	e1c080e7          	jalr	-484(ra) # 80002d02 <devintr>
    80002eee:	cd1d                	beqz	a0,80002f2c <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ef0:	4789                	li	a5,2
    80002ef2:	06f50a63          	beq	a0,a5,80002f66 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ef6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002efa:	10049073          	csrw	sstatus,s1
}
    80002efe:	70a2                	ld	ra,40(sp)
    80002f00:	7402                	ld	s0,32(sp)
    80002f02:	64e2                	ld	s1,24(sp)
    80002f04:	6942                	ld	s2,16(sp)
    80002f06:	69a2                	ld	s3,8(sp)
    80002f08:	6145                	addi	sp,sp,48
    80002f0a:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002f0c:	00005517          	auipc	a0,0x5
    80002f10:	51c50513          	addi	a0,a0,1308 # 80008428 <etext+0x428>
    80002f14:	ffffd097          	auipc	ra,0xffffd
    80002f18:	64c080e7          	jalr	1612(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002f1c:	00005517          	auipc	a0,0x5
    80002f20:	53450513          	addi	a0,a0,1332 # 80008450 <etext+0x450>
    80002f24:	ffffd097          	auipc	ra,0xffffd
    80002f28:	63c080e7          	jalr	1596(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002f2c:	85ce                	mv	a1,s3
    80002f2e:	00005517          	auipc	a0,0x5
    80002f32:	54250513          	addi	a0,a0,1346 # 80008470 <etext+0x470>
    80002f36:	ffffd097          	auipc	ra,0xffffd
    80002f3a:	674080e7          	jalr	1652(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f3e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f42:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f46:	00005517          	auipc	a0,0x5
    80002f4a:	53a50513          	addi	a0,a0,1338 # 80008480 <etext+0x480>
    80002f4e:	ffffd097          	auipc	ra,0xffffd
    80002f52:	65c080e7          	jalr	1628(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002f56:	00005517          	auipc	a0,0x5
    80002f5a:	54250513          	addi	a0,a0,1346 # 80008498 <etext+0x498>
    80002f5e:	ffffd097          	auipc	ra,0xffffd
    80002f62:	602080e7          	jalr	1538(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	d88080e7          	jalr	-632(ra) # 80001cee <myproc>
    80002f6e:	d541                	beqz	a0,80002ef6 <kerneltrap+0x38>
    80002f70:	fffff097          	auipc	ra,0xfffff
    80002f74:	d7e080e7          	jalr	-642(ra) # 80001cee <myproc>
    80002f78:	4d18                	lw	a4,24(a0)
    80002f7a:	4791                	li	a5,4
    80002f7c:	f6f71de3          	bne	a4,a5,80002ef6 <kerneltrap+0x38>
        yield(YIELD_OTHER);
    80002f80:	4509                	li	a0,2
    80002f82:	fffff097          	auipc	ra,0xfffff
    80002f86:	510080e7          	jalr	1296(ra) # 80002492 <yield>
    80002f8a:	b7b5                	j	80002ef6 <kerneltrap+0x38>

0000000080002f8c <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002f8c:	1101                	addi	sp,sp,-32
    80002f8e:	ec06                	sd	ra,24(sp)
    80002f90:	e822                	sd	s0,16(sp)
    80002f92:	e426                	sd	s1,8(sp)
    80002f94:	1000                	addi	s0,sp,32
    80002f96:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002f98:	fffff097          	auipc	ra,0xfffff
    80002f9c:	d56080e7          	jalr	-682(ra) # 80001cee <myproc>
    switch (n)
    80002fa0:	4795                	li	a5,5
    80002fa2:	0497e163          	bltu	a5,s1,80002fe4 <argraw+0x58>
    80002fa6:	048a                	slli	s1,s1,0x2
    80002fa8:	00006717          	auipc	a4,0x6
    80002fac:	8b070713          	addi	a4,a4,-1872 # 80008858 <states.0+0x30>
    80002fb0:	94ba                	add	s1,s1,a4
    80002fb2:	409c                	lw	a5,0(s1)
    80002fb4:	97ba                	add	a5,a5,a4
    80002fb6:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002fb8:	713c                	ld	a5,96(a0)
    80002fba:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002fbc:	60e2                	ld	ra,24(sp)
    80002fbe:	6442                	ld	s0,16(sp)
    80002fc0:	64a2                	ld	s1,8(sp)
    80002fc2:	6105                	addi	sp,sp,32
    80002fc4:	8082                	ret
        return p->trapframe->a1;
    80002fc6:	713c                	ld	a5,96(a0)
    80002fc8:	7fa8                	ld	a0,120(a5)
    80002fca:	bfcd                	j	80002fbc <argraw+0x30>
        return p->trapframe->a2;
    80002fcc:	713c                	ld	a5,96(a0)
    80002fce:	63c8                	ld	a0,128(a5)
    80002fd0:	b7f5                	j	80002fbc <argraw+0x30>
        return p->trapframe->a3;
    80002fd2:	713c                	ld	a5,96(a0)
    80002fd4:	67c8                	ld	a0,136(a5)
    80002fd6:	b7dd                	j	80002fbc <argraw+0x30>
        return p->trapframe->a4;
    80002fd8:	713c                	ld	a5,96(a0)
    80002fda:	6bc8                	ld	a0,144(a5)
    80002fdc:	b7c5                	j	80002fbc <argraw+0x30>
        return p->trapframe->a5;
    80002fde:	713c                	ld	a5,96(a0)
    80002fe0:	6fc8                	ld	a0,152(a5)
    80002fe2:	bfe9                	j	80002fbc <argraw+0x30>
    panic("argraw");
    80002fe4:	00005517          	auipc	a0,0x5
    80002fe8:	4c450513          	addi	a0,a0,1220 # 800084a8 <etext+0x4a8>
    80002fec:	ffffd097          	auipc	ra,0xffffd
    80002ff0:	574080e7          	jalr	1396(ra) # 80000560 <panic>

0000000080002ff4 <fetchaddr>:
{
    80002ff4:	1101                	addi	sp,sp,-32
    80002ff6:	ec06                	sd	ra,24(sp)
    80002ff8:	e822                	sd	s0,16(sp)
    80002ffa:	e426                	sd	s1,8(sp)
    80002ffc:	e04a                	sd	s2,0(sp)
    80002ffe:	1000                	addi	s0,sp,32
    80003000:	84aa                	mv	s1,a0
    80003002:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80003004:	fffff097          	auipc	ra,0xfffff
    80003008:	cea080e7          	jalr	-790(ra) # 80001cee <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000300c:	693c                	ld	a5,80(a0)
    8000300e:	02f4f863          	bgeu	s1,a5,8000303e <fetchaddr+0x4a>
    80003012:	00848713          	addi	a4,s1,8
    80003016:	02e7e663          	bltu	a5,a4,80003042 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000301a:	46a1                	li	a3,8
    8000301c:	8626                	mv	a2,s1
    8000301e:	85ca                	mv	a1,s2
    80003020:	6d28                	ld	a0,88(a0)
    80003022:	ffffe097          	auipc	ra,0xffffe
    80003026:	74c080e7          	jalr	1868(ra) # 8000176e <copyin>
    8000302a:	00a03533          	snez	a0,a0
    8000302e:	40a00533          	neg	a0,a0
}
    80003032:	60e2                	ld	ra,24(sp)
    80003034:	6442                	ld	s0,16(sp)
    80003036:	64a2                	ld	s1,8(sp)
    80003038:	6902                	ld	s2,0(sp)
    8000303a:	6105                	addi	sp,sp,32
    8000303c:	8082                	ret
        return -1;
    8000303e:	557d                	li	a0,-1
    80003040:	bfcd                	j	80003032 <fetchaddr+0x3e>
    80003042:	557d                	li	a0,-1
    80003044:	b7fd                	j	80003032 <fetchaddr+0x3e>

0000000080003046 <fetchstr>:
{
    80003046:	7179                	addi	sp,sp,-48
    80003048:	f406                	sd	ra,40(sp)
    8000304a:	f022                	sd	s0,32(sp)
    8000304c:	ec26                	sd	s1,24(sp)
    8000304e:	e84a                	sd	s2,16(sp)
    80003050:	e44e                	sd	s3,8(sp)
    80003052:	1800                	addi	s0,sp,48
    80003054:	892a                	mv	s2,a0
    80003056:	84ae                	mv	s1,a1
    80003058:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	c94080e7          	jalr	-876(ra) # 80001cee <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80003062:	86ce                	mv	a3,s3
    80003064:	864a                	mv	a2,s2
    80003066:	85a6                	mv	a1,s1
    80003068:	6d28                	ld	a0,88(a0)
    8000306a:	ffffe097          	auipc	ra,0xffffe
    8000306e:	792080e7          	jalr	1938(ra) # 800017fc <copyinstr>
    80003072:	00054e63          	bltz	a0,8000308e <fetchstr+0x48>
    return strlen(buf);
    80003076:	8526                	mv	a0,s1
    80003078:	ffffe097          	auipc	ra,0xffffe
    8000307c:	e30080e7          	jalr	-464(ra) # 80000ea8 <strlen>
}
    80003080:	70a2                	ld	ra,40(sp)
    80003082:	7402                	ld	s0,32(sp)
    80003084:	64e2                	ld	s1,24(sp)
    80003086:	6942                	ld	s2,16(sp)
    80003088:	69a2                	ld	s3,8(sp)
    8000308a:	6145                	addi	sp,sp,48
    8000308c:	8082                	ret
        return -1;
    8000308e:	557d                	li	a0,-1
    80003090:	bfc5                	j	80003080 <fetchstr+0x3a>

0000000080003092 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80003092:	1101                	addi	sp,sp,-32
    80003094:	ec06                	sd	ra,24(sp)
    80003096:	e822                	sd	s0,16(sp)
    80003098:	e426                	sd	s1,8(sp)
    8000309a:	1000                	addi	s0,sp,32
    8000309c:	84ae                	mv	s1,a1
    *ip = argraw(n);
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	eee080e7          	jalr	-274(ra) # 80002f8c <argraw>
    800030a6:	c088                	sw	a0,0(s1)
}
    800030a8:	60e2                	ld	ra,24(sp)
    800030aa:	6442                	ld	s0,16(sp)
    800030ac:	64a2                	ld	s1,8(sp)
    800030ae:	6105                	addi	sp,sp,32
    800030b0:	8082                	ret

00000000800030b2 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800030b2:	1101                	addi	sp,sp,-32
    800030b4:	ec06                	sd	ra,24(sp)
    800030b6:	e822                	sd	s0,16(sp)
    800030b8:	e426                	sd	s1,8(sp)
    800030ba:	1000                	addi	s0,sp,32
    800030bc:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800030be:	00000097          	auipc	ra,0x0
    800030c2:	ece080e7          	jalr	-306(ra) # 80002f8c <argraw>
    800030c6:	e088                	sd	a0,0(s1)
}
    800030c8:	60e2                	ld	ra,24(sp)
    800030ca:	6442                	ld	s0,16(sp)
    800030cc:	64a2                	ld	s1,8(sp)
    800030ce:	6105                	addi	sp,sp,32
    800030d0:	8082                	ret

00000000800030d2 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800030d2:	7179                	addi	sp,sp,-48
    800030d4:	f406                	sd	ra,40(sp)
    800030d6:	f022                	sd	s0,32(sp)
    800030d8:	ec26                	sd	s1,24(sp)
    800030da:	e84a                	sd	s2,16(sp)
    800030dc:	1800                	addi	s0,sp,48
    800030de:	84ae                	mv	s1,a1
    800030e0:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800030e2:	fd840593          	addi	a1,s0,-40
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	fcc080e7          	jalr	-52(ra) # 800030b2 <argaddr>
    return fetchstr(addr, buf, max);
    800030ee:	864a                	mv	a2,s2
    800030f0:	85a6                	mv	a1,s1
    800030f2:	fd843503          	ld	a0,-40(s0)
    800030f6:	00000097          	auipc	ra,0x0
    800030fa:	f50080e7          	jalr	-176(ra) # 80003046 <fetchstr>
}
    800030fe:	70a2                	ld	ra,40(sp)
    80003100:	7402                	ld	s0,32(sp)
    80003102:	64e2                	ld	s1,24(sp)
    80003104:	6942                	ld	s2,16(sp)
    80003106:	6145                	addi	sp,sp,48
    80003108:	8082                	ret

000000008000310a <syscall>:
    [SYS_yield] sys_yield,
    [SYS_getprio] sys_getprio,
};

void syscall(void)
{
    8000310a:	1101                	addi	sp,sp,-32
    8000310c:	ec06                	sd	ra,24(sp)
    8000310e:	e822                	sd	s0,16(sp)
    80003110:	e426                	sd	s1,8(sp)
    80003112:	e04a                	sd	s2,0(sp)
    80003114:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	bd8080e7          	jalr	-1064(ra) # 80001cee <myproc>
    8000311e:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80003120:	06053903          	ld	s2,96(a0)
    80003124:	0a893783          	ld	a5,168(s2)
    80003128:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000312c:	37fd                	addiw	a5,a5,-1
    8000312e:	4765                	li	a4,25
    80003130:	00f76f63          	bltu	a4,a5,8000314e <syscall+0x44>
    80003134:	00369713          	slli	a4,a3,0x3
    80003138:	00005797          	auipc	a5,0x5
    8000313c:	73878793          	addi	a5,a5,1848 # 80008870 <syscalls>
    80003140:	97ba                	add	a5,a5,a4
    80003142:	639c                	ld	a5,0(a5)
    80003144:	c789                	beqz	a5,8000314e <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003146:	9782                	jalr	a5
    80003148:	06a93823          	sd	a0,112(s2)
    8000314c:	a839                	j	8000316a <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    8000314e:	16048613          	addi	a2,s1,352
    80003152:	588c                	lw	a1,48(s1)
    80003154:	00005517          	auipc	a0,0x5
    80003158:	35c50513          	addi	a0,a0,860 # 800084b0 <etext+0x4b0>
    8000315c:	ffffd097          	auipc	ra,0xffffd
    80003160:	44e080e7          	jalr	1102(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80003164:	70bc                	ld	a5,96(s1)
    80003166:	577d                	li	a4,-1
    80003168:	fbb8                	sd	a4,112(a5)
    }
}
    8000316a:	60e2                	ld	ra,24(sp)
    8000316c:	6442                	ld	s0,16(sp)
    8000316e:	64a2                	ld	s1,8(sp)
    80003170:	6902                	ld	s2,0(sp)
    80003172:	6105                	addi	sp,sp,32
    80003174:	8082                	ret

0000000080003176 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003176:	1101                	addi	sp,sp,-32
    80003178:	ec06                	sd	ra,24(sp)
    8000317a:	e822                	sd	s0,16(sp)
    8000317c:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    8000317e:	fec40593          	addi	a1,s0,-20
    80003182:	4501                	li	a0,0
    80003184:	00000097          	auipc	ra,0x0
    80003188:	f0e080e7          	jalr	-242(ra) # 80003092 <argint>
    exit(n);
    8000318c:	fec42503          	lw	a0,-20(s0)
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	476080e7          	jalr	1142(ra) # 80002606 <exit>
    return 0; // not reached
}
    80003198:	4501                	li	a0,0
    8000319a:	60e2                	ld	ra,24(sp)
    8000319c:	6442                	ld	s0,16(sp)
    8000319e:	6105                	addi	sp,sp,32
    800031a0:	8082                	ret

00000000800031a2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800031a2:	1141                	addi	sp,sp,-16
    800031a4:	e406                	sd	ra,8(sp)
    800031a6:	e022                	sd	s0,0(sp)
    800031a8:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	b44080e7          	jalr	-1212(ra) # 80001cee <myproc>
}
    800031b2:	5908                	lw	a0,48(a0)
    800031b4:	60a2                	ld	ra,8(sp)
    800031b6:	6402                	ld	s0,0(sp)
    800031b8:	0141                	addi	sp,sp,16
    800031ba:	8082                	ret

00000000800031bc <sys_fork>:

uint64
sys_fork(void)
{
    800031bc:	1141                	addi	sp,sp,-16
    800031be:	e406                	sd	ra,8(sp)
    800031c0:	e022                	sd	s0,0(sp)
    800031c2:	0800                	addi	s0,sp,16
    return fork();
    800031c4:	fffff097          	auipc	ra,0xfffff
    800031c8:	080080e7          	jalr	128(ra) # 80002244 <fork>
}
    800031cc:	60a2                	ld	ra,8(sp)
    800031ce:	6402                	ld	s0,0(sp)
    800031d0:	0141                	addi	sp,sp,16
    800031d2:	8082                	ret

00000000800031d4 <sys_wait>:

uint64
sys_wait(void)
{
    800031d4:	1101                	addi	sp,sp,-32
    800031d6:	ec06                	sd	ra,24(sp)
    800031d8:	e822                	sd	s0,16(sp)
    800031da:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    800031dc:	fe840593          	addi	a1,s0,-24
    800031e0:	4501                	li	a0,0
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	ed0080e7          	jalr	-304(ra) # 800030b2 <argaddr>
    return wait(p);
    800031ea:	fe843503          	ld	a0,-24(s0)
    800031ee:	fffff097          	auipc	ra,0xfffff
    800031f2:	5be080e7          	jalr	1470(ra) # 800027ac <wait>
}
    800031f6:	60e2                	ld	ra,24(sp)
    800031f8:	6442                	ld	s0,16(sp)
    800031fa:	6105                	addi	sp,sp,32
    800031fc:	8082                	ret

00000000800031fe <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800031fe:	7179                	addi	sp,sp,-48
    80003200:	f406                	sd	ra,40(sp)
    80003202:	f022                	sd	s0,32(sp)
    80003204:	ec26                	sd	s1,24(sp)
    80003206:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80003208:	fdc40593          	addi	a1,s0,-36
    8000320c:	4501                	li	a0,0
    8000320e:	00000097          	auipc	ra,0x0
    80003212:	e84080e7          	jalr	-380(ra) # 80003092 <argint>
    addr = myproc()->sz;
    80003216:	fffff097          	auipc	ra,0xfffff
    8000321a:	ad8080e7          	jalr	-1320(ra) # 80001cee <myproc>
    8000321e:	6924                	ld	s1,80(a0)
    if (growproc(n) < 0)
    80003220:	fdc42503          	lw	a0,-36(s0)
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	e2c080e7          	jalr	-468(ra) # 80002050 <growproc>
    8000322c:	00054863          	bltz	a0,8000323c <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    80003230:	8526                	mv	a0,s1
    80003232:	70a2                	ld	ra,40(sp)
    80003234:	7402                	ld	s0,32(sp)
    80003236:	64e2                	ld	s1,24(sp)
    80003238:	6145                	addi	sp,sp,48
    8000323a:	8082                	ret
        return -1;
    8000323c:	54fd                	li	s1,-1
    8000323e:	bfcd                	j	80003230 <sys_sbrk+0x32>

0000000080003240 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003240:	7139                	addi	sp,sp,-64
    80003242:	fc06                	sd	ra,56(sp)
    80003244:	f822                	sd	s0,48(sp)
    80003246:	f04a                	sd	s2,32(sp)
    80003248:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    8000324a:	fcc40593          	addi	a1,s0,-52
    8000324e:	4501                	li	a0,0
    80003250:	00000097          	auipc	ra,0x0
    80003254:	e42080e7          	jalr	-446(ra) # 80003092 <argint>
    acquire(&tickslock);
    80003258:	00016517          	auipc	a0,0x16
    8000325c:	54850513          	addi	a0,a0,1352 # 800197a0 <tickslock>
    80003260:	ffffe097          	auipc	ra,0xffffe
    80003264:	9d8080e7          	jalr	-1576(ra) # 80000c38 <acquire>
    ticks0 = ticks;
    80003268:	00008917          	auipc	s2,0x8
    8000326c:	29892903          	lw	s2,664(s2) # 8000b500 <ticks>
    while (ticks - ticks0 < n)
    80003270:	fcc42783          	lw	a5,-52(s0)
    80003274:	c3b9                	beqz	a5,800032ba <sys_sleep+0x7a>
    80003276:	f426                	sd	s1,40(sp)
    80003278:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    8000327a:	00016997          	auipc	s3,0x16
    8000327e:	52698993          	addi	s3,s3,1318 # 800197a0 <tickslock>
    80003282:	00008497          	auipc	s1,0x8
    80003286:	27e48493          	addi	s1,s1,638 # 8000b500 <ticks>
        if (killed(myproc()))
    8000328a:	fffff097          	auipc	ra,0xfffff
    8000328e:	a64080e7          	jalr	-1436(ra) # 80001cee <myproc>
    80003292:	fffff097          	auipc	ra,0xfffff
    80003296:	4e8080e7          	jalr	1256(ra) # 8000277a <killed>
    8000329a:	ed15                	bnez	a0,800032d6 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    8000329c:	85ce                	mv	a1,s3
    8000329e:	8526                	mv	a0,s1
    800032a0:	fffff097          	auipc	ra,0xfffff
    800032a4:	232080e7          	jalr	562(ra) # 800024d2 <sleep>
    while (ticks - ticks0 < n)
    800032a8:	409c                	lw	a5,0(s1)
    800032aa:	412787bb          	subw	a5,a5,s2
    800032ae:	fcc42703          	lw	a4,-52(s0)
    800032b2:	fce7ece3          	bltu	a5,a4,8000328a <sys_sleep+0x4a>
    800032b6:	74a2                	ld	s1,40(sp)
    800032b8:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    800032ba:	00016517          	auipc	a0,0x16
    800032be:	4e650513          	addi	a0,a0,1254 # 800197a0 <tickslock>
    800032c2:	ffffe097          	auipc	ra,0xffffe
    800032c6:	a2a080e7          	jalr	-1494(ra) # 80000cec <release>
    return 0;
    800032ca:	4501                	li	a0,0
}
    800032cc:	70e2                	ld	ra,56(sp)
    800032ce:	7442                	ld	s0,48(sp)
    800032d0:	7902                	ld	s2,32(sp)
    800032d2:	6121                	addi	sp,sp,64
    800032d4:	8082                	ret
            release(&tickslock);
    800032d6:	00016517          	auipc	a0,0x16
    800032da:	4ca50513          	addi	a0,a0,1226 # 800197a0 <tickslock>
    800032de:	ffffe097          	auipc	ra,0xffffe
    800032e2:	a0e080e7          	jalr	-1522(ra) # 80000cec <release>
            return -1;
    800032e6:	557d                	li	a0,-1
    800032e8:	74a2                	ld	s1,40(sp)
    800032ea:	69e2                	ld	s3,24(sp)
    800032ec:	b7c5                	j	800032cc <sys_sleep+0x8c>

00000000800032ee <sys_kill>:

uint64
sys_kill(void)
{
    800032ee:	1101                	addi	sp,sp,-32
    800032f0:	ec06                	sd	ra,24(sp)
    800032f2:	e822                	sd	s0,16(sp)
    800032f4:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800032f6:	fec40593          	addi	a1,s0,-20
    800032fa:	4501                	li	a0,0
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	d96080e7          	jalr	-618(ra) # 80003092 <argint>
    return kill(pid);
    80003304:	fec42503          	lw	a0,-20(s0)
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	3d4080e7          	jalr	980(ra) # 800026dc <kill>
}
    80003310:	60e2                	ld	ra,24(sp)
    80003312:	6442                	ld	s0,16(sp)
    80003314:	6105                	addi	sp,sp,32
    80003316:	8082                	ret

0000000080003318 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003318:	1101                	addi	sp,sp,-32
    8000331a:	ec06                	sd	ra,24(sp)
    8000331c:	e822                	sd	s0,16(sp)
    8000331e:	e426                	sd	s1,8(sp)
    80003320:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    80003322:	00016517          	auipc	a0,0x16
    80003326:	47e50513          	addi	a0,a0,1150 # 800197a0 <tickslock>
    8000332a:	ffffe097          	auipc	ra,0xffffe
    8000332e:	90e080e7          	jalr	-1778(ra) # 80000c38 <acquire>
    xticks = ticks;
    80003332:	00008497          	auipc	s1,0x8
    80003336:	1ce4a483          	lw	s1,462(s1) # 8000b500 <ticks>
    release(&tickslock);
    8000333a:	00016517          	auipc	a0,0x16
    8000333e:	46650513          	addi	a0,a0,1126 # 800197a0 <tickslock>
    80003342:	ffffe097          	auipc	ra,0xffffe
    80003346:	9aa080e7          	jalr	-1622(ra) # 80000cec <release>
    return xticks;
}
    8000334a:	02049513          	slli	a0,s1,0x20
    8000334e:	9101                	srli	a0,a0,0x20
    80003350:	60e2                	ld	ra,24(sp)
    80003352:	6442                	ld	s0,16(sp)
    80003354:	64a2                	ld	s1,8(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret

000000008000335a <sys_ps>:

void *
sys_ps(void)
{
    8000335a:	1101                	addi	sp,sp,-32
    8000335c:	ec06                	sd	ra,24(sp)
    8000335e:	e822                	sd	s0,16(sp)
    80003360:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003362:	fe042623          	sw	zero,-20(s0)
    80003366:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    8000336a:	fec40593          	addi	a1,s0,-20
    8000336e:	4501                	li	a0,0
    80003370:	00000097          	auipc	ra,0x0
    80003374:	d22080e7          	jalr	-734(ra) # 80003092 <argint>
    argint(1, &count);
    80003378:	fe840593          	addi	a1,s0,-24
    8000337c:	4505                	li	a0,1
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	d14080e7          	jalr	-748(ra) # 80003092 <argint>
    return ps((uint8)start, (uint8)count);
    80003386:	fe844583          	lbu	a1,-24(s0)
    8000338a:	fec44503          	lbu	a0,-20(s0)
    8000338e:	fffff097          	auipc	ra,0xfffff
    80003392:	d1e080e7          	jalr	-738(ra) # 800020ac <ps>
}
    80003396:	60e2                	ld	ra,24(sp)
    80003398:	6442                	ld	s0,16(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <sys_schedls>:

uint64 sys_schedls(void)
{
    8000339e:	1141                	addi	sp,sp,-16
    800033a0:	e406                	sd	ra,8(sp)
    800033a2:	e022                	sd	s0,0(sp)
    800033a4:	0800                	addi	s0,sp,16
    schedls();
    800033a6:	fffff097          	auipc	ra,0xfffff
    800033aa:	690080e7          	jalr	1680(ra) # 80002a36 <schedls>
    return 0;
}
    800033ae:	4501                	li	a0,0
    800033b0:	60a2                	ld	ra,8(sp)
    800033b2:	6402                	ld	s0,0(sp)
    800033b4:	0141                	addi	sp,sp,16
    800033b6:	8082                	ret

00000000800033b8 <sys_schedset>:

uint64 sys_schedset(void)
{
    800033b8:	1101                	addi	sp,sp,-32
    800033ba:	ec06                	sd	ra,24(sp)
    800033bc:	e822                	sd	s0,16(sp)
    800033be:	1000                	addi	s0,sp,32
    int id = 0;
    800033c0:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    800033c4:	fec40593          	addi	a1,s0,-20
    800033c8:	4501                	li	a0,0
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	cc8080e7          	jalr	-824(ra) # 80003092 <argint>
    schedset(id - 1);
    800033d2:	fec42503          	lw	a0,-20(s0)
    800033d6:	357d                	addiw	a0,a0,-1
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	74a080e7          	jalr	1866(ra) # 80002b22 <schedset>
    return 0;
}
    800033e0:	4501                	li	a0,0
    800033e2:	60e2                	ld	ra,24(sp)
    800033e4:	6442                	ld	s0,16(sp)
    800033e6:	6105                	addi	sp,sp,32
    800033e8:	8082                	ret

00000000800033ea <sys_yield>:

uint64 sys_yield(void)
{
    800033ea:	1141                	addi	sp,sp,-16
    800033ec:	e406                	sd	ra,8(sp)
    800033ee:	e022                	sd	s0,0(sp)
    800033f0:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    800033f2:	4509                	li	a0,2
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	09e080e7          	jalr	158(ra) # 80002492 <yield>
    return 0;
}
    800033fc:	4501                	li	a0,0
    800033fe:	60a2                	ld	ra,8(sp)
    80003400:	6402                	ld	s0,0(sp)
    80003402:	0141                	addi	sp,sp,16
    80003404:	8082                	ret

0000000080003406 <sys_getprio>:

uint64 sys_getprio(void) {
    80003406:	1141                	addi	sp,sp,-16
    80003408:	e406                	sd	ra,8(sp)
    8000340a:	e022                	sd	s0,0(sp)
    8000340c:	0800                	addi	s0,sp,16
    
    return myproc()->priority;
    8000340e:	fffff097          	auipc	ra,0xfffff
    80003412:	8e0080e7          	jalr	-1824(ra) # 80001cee <myproc>
    80003416:	4128                	lw	a0,64(a0)
    80003418:	60a2                	ld	ra,8(sp)
    8000341a:	6402                	ld	s0,0(sp)
    8000341c:	0141                	addi	sp,sp,16
    8000341e:	8082                	ret

0000000080003420 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003420:	7179                	addi	sp,sp,-48
    80003422:	f406                	sd	ra,40(sp)
    80003424:	f022                	sd	s0,32(sp)
    80003426:	ec26                	sd	s1,24(sp)
    80003428:	e84a                	sd	s2,16(sp)
    8000342a:	e44e                	sd	s3,8(sp)
    8000342c:	e052                	sd	s4,0(sp)
    8000342e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003430:	00005597          	auipc	a1,0x5
    80003434:	0a058593          	addi	a1,a1,160 # 800084d0 <etext+0x4d0>
    80003438:	00016517          	auipc	a0,0x16
    8000343c:	38050513          	addi	a0,a0,896 # 800197b8 <bcache>
    80003440:	ffffd097          	auipc	ra,0xffffd
    80003444:	768080e7          	jalr	1896(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003448:	0001e797          	auipc	a5,0x1e
    8000344c:	37078793          	addi	a5,a5,880 # 800217b8 <bcache+0x8000>
    80003450:	0001e717          	auipc	a4,0x1e
    80003454:	5d070713          	addi	a4,a4,1488 # 80021a20 <bcache+0x8268>
    80003458:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000345c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003460:	00016497          	auipc	s1,0x16
    80003464:	37048493          	addi	s1,s1,880 # 800197d0 <bcache+0x18>
    b->next = bcache.head.next;
    80003468:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000346a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000346c:	00005a17          	auipc	s4,0x5
    80003470:	06ca0a13          	addi	s4,s4,108 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    80003474:	2b893783          	ld	a5,696(s2)
    80003478:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000347a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000347e:	85d2                	mv	a1,s4
    80003480:	01048513          	addi	a0,s1,16
    80003484:	00001097          	auipc	ra,0x1
    80003488:	4e8080e7          	jalr	1256(ra) # 8000496c <initsleeplock>
    bcache.head.next->prev = b;
    8000348c:	2b893783          	ld	a5,696(s2)
    80003490:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003492:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003496:	45848493          	addi	s1,s1,1112
    8000349a:	fd349de3          	bne	s1,s3,80003474 <binit+0x54>
  }
}
    8000349e:	70a2                	ld	ra,40(sp)
    800034a0:	7402                	ld	s0,32(sp)
    800034a2:	64e2                	ld	s1,24(sp)
    800034a4:	6942                	ld	s2,16(sp)
    800034a6:	69a2                	ld	s3,8(sp)
    800034a8:	6a02                	ld	s4,0(sp)
    800034aa:	6145                	addi	sp,sp,48
    800034ac:	8082                	ret

00000000800034ae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800034ae:	7179                	addi	sp,sp,-48
    800034b0:	f406                	sd	ra,40(sp)
    800034b2:	f022                	sd	s0,32(sp)
    800034b4:	ec26                	sd	s1,24(sp)
    800034b6:	e84a                	sd	s2,16(sp)
    800034b8:	e44e                	sd	s3,8(sp)
    800034ba:	1800                	addi	s0,sp,48
    800034bc:	892a                	mv	s2,a0
    800034be:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800034c0:	00016517          	auipc	a0,0x16
    800034c4:	2f850513          	addi	a0,a0,760 # 800197b8 <bcache>
    800034c8:	ffffd097          	auipc	ra,0xffffd
    800034cc:	770080e7          	jalr	1904(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800034d0:	0001e497          	auipc	s1,0x1e
    800034d4:	5a04b483          	ld	s1,1440(s1) # 80021a70 <bcache+0x82b8>
    800034d8:	0001e797          	auipc	a5,0x1e
    800034dc:	54878793          	addi	a5,a5,1352 # 80021a20 <bcache+0x8268>
    800034e0:	02f48f63          	beq	s1,a5,8000351e <bread+0x70>
    800034e4:	873e                	mv	a4,a5
    800034e6:	a021                	j	800034ee <bread+0x40>
    800034e8:	68a4                	ld	s1,80(s1)
    800034ea:	02e48a63          	beq	s1,a4,8000351e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800034ee:	449c                	lw	a5,8(s1)
    800034f0:	ff279ce3          	bne	a5,s2,800034e8 <bread+0x3a>
    800034f4:	44dc                	lw	a5,12(s1)
    800034f6:	ff3799e3          	bne	a5,s3,800034e8 <bread+0x3a>
      b->refcnt++;
    800034fa:	40bc                	lw	a5,64(s1)
    800034fc:	2785                	addiw	a5,a5,1
    800034fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003500:	00016517          	auipc	a0,0x16
    80003504:	2b850513          	addi	a0,a0,696 # 800197b8 <bcache>
    80003508:	ffffd097          	auipc	ra,0xffffd
    8000350c:	7e4080e7          	jalr	2020(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003510:	01048513          	addi	a0,s1,16
    80003514:	00001097          	auipc	ra,0x1
    80003518:	492080e7          	jalr	1170(ra) # 800049a6 <acquiresleep>
      return b;
    8000351c:	a8b9                	j	8000357a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000351e:	0001e497          	auipc	s1,0x1e
    80003522:	54a4b483          	ld	s1,1354(s1) # 80021a68 <bcache+0x82b0>
    80003526:	0001e797          	auipc	a5,0x1e
    8000352a:	4fa78793          	addi	a5,a5,1274 # 80021a20 <bcache+0x8268>
    8000352e:	00f48863          	beq	s1,a5,8000353e <bread+0x90>
    80003532:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003534:	40bc                	lw	a5,64(s1)
    80003536:	cf81                	beqz	a5,8000354e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003538:	64a4                	ld	s1,72(s1)
    8000353a:	fee49de3          	bne	s1,a4,80003534 <bread+0x86>
  panic("bget: no buffers");
    8000353e:	00005517          	auipc	a0,0x5
    80003542:	fa250513          	addi	a0,a0,-94 # 800084e0 <etext+0x4e0>
    80003546:	ffffd097          	auipc	ra,0xffffd
    8000354a:	01a080e7          	jalr	26(ra) # 80000560 <panic>
      b->dev = dev;
    8000354e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003552:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003556:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000355a:	4785                	li	a5,1
    8000355c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000355e:	00016517          	auipc	a0,0x16
    80003562:	25a50513          	addi	a0,a0,602 # 800197b8 <bcache>
    80003566:	ffffd097          	auipc	ra,0xffffd
    8000356a:	786080e7          	jalr	1926(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    8000356e:	01048513          	addi	a0,s1,16
    80003572:	00001097          	auipc	ra,0x1
    80003576:	434080e7          	jalr	1076(ra) # 800049a6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000357a:	409c                	lw	a5,0(s1)
    8000357c:	cb89                	beqz	a5,8000358e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000357e:	8526                	mv	a0,s1
    80003580:	70a2                	ld	ra,40(sp)
    80003582:	7402                	ld	s0,32(sp)
    80003584:	64e2                	ld	s1,24(sp)
    80003586:	6942                	ld	s2,16(sp)
    80003588:	69a2                	ld	s3,8(sp)
    8000358a:	6145                	addi	sp,sp,48
    8000358c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000358e:	4581                	li	a1,0
    80003590:	8526                	mv	a0,s1
    80003592:	00003097          	auipc	ra,0x3
    80003596:	0f6080e7          	jalr	246(ra) # 80006688 <virtio_disk_rw>
    b->valid = 1;
    8000359a:	4785                	li	a5,1
    8000359c:	c09c                	sw	a5,0(s1)
  return b;
    8000359e:	b7c5                	j	8000357e <bread+0xd0>

00000000800035a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800035a0:	1101                	addi	sp,sp,-32
    800035a2:	ec06                	sd	ra,24(sp)
    800035a4:	e822                	sd	s0,16(sp)
    800035a6:	e426                	sd	s1,8(sp)
    800035a8:	1000                	addi	s0,sp,32
    800035aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035ac:	0541                	addi	a0,a0,16
    800035ae:	00001097          	auipc	ra,0x1
    800035b2:	492080e7          	jalr	1170(ra) # 80004a40 <holdingsleep>
    800035b6:	cd01                	beqz	a0,800035ce <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800035b8:	4585                	li	a1,1
    800035ba:	8526                	mv	a0,s1
    800035bc:	00003097          	auipc	ra,0x3
    800035c0:	0cc080e7          	jalr	204(ra) # 80006688 <virtio_disk_rw>
}
    800035c4:	60e2                	ld	ra,24(sp)
    800035c6:	6442                	ld	s0,16(sp)
    800035c8:	64a2                	ld	s1,8(sp)
    800035ca:	6105                	addi	sp,sp,32
    800035cc:	8082                	ret
    panic("bwrite");
    800035ce:	00005517          	auipc	a0,0x5
    800035d2:	f2a50513          	addi	a0,a0,-214 # 800084f8 <etext+0x4f8>
    800035d6:	ffffd097          	auipc	ra,0xffffd
    800035da:	f8a080e7          	jalr	-118(ra) # 80000560 <panic>

00000000800035de <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035de:	1101                	addi	sp,sp,-32
    800035e0:	ec06                	sd	ra,24(sp)
    800035e2:	e822                	sd	s0,16(sp)
    800035e4:	e426                	sd	s1,8(sp)
    800035e6:	e04a                	sd	s2,0(sp)
    800035e8:	1000                	addi	s0,sp,32
    800035ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035ec:	01050913          	addi	s2,a0,16
    800035f0:	854a                	mv	a0,s2
    800035f2:	00001097          	auipc	ra,0x1
    800035f6:	44e080e7          	jalr	1102(ra) # 80004a40 <holdingsleep>
    800035fa:	c925                	beqz	a0,8000366a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800035fc:	854a                	mv	a0,s2
    800035fe:	00001097          	auipc	ra,0x1
    80003602:	3fe080e7          	jalr	1022(ra) # 800049fc <releasesleep>

  acquire(&bcache.lock);
    80003606:	00016517          	auipc	a0,0x16
    8000360a:	1b250513          	addi	a0,a0,434 # 800197b8 <bcache>
    8000360e:	ffffd097          	auipc	ra,0xffffd
    80003612:	62a080e7          	jalr	1578(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003616:	40bc                	lw	a5,64(s1)
    80003618:	37fd                	addiw	a5,a5,-1
    8000361a:	0007871b          	sext.w	a4,a5
    8000361e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003620:	e71d                	bnez	a4,8000364e <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003622:	68b8                	ld	a4,80(s1)
    80003624:	64bc                	ld	a5,72(s1)
    80003626:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003628:	68b8                	ld	a4,80(s1)
    8000362a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000362c:	0001e797          	auipc	a5,0x1e
    80003630:	18c78793          	addi	a5,a5,396 # 800217b8 <bcache+0x8000>
    80003634:	2b87b703          	ld	a4,696(a5)
    80003638:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000363a:	0001e717          	auipc	a4,0x1e
    8000363e:	3e670713          	addi	a4,a4,998 # 80021a20 <bcache+0x8268>
    80003642:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003644:	2b87b703          	ld	a4,696(a5)
    80003648:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000364a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000364e:	00016517          	auipc	a0,0x16
    80003652:	16a50513          	addi	a0,a0,362 # 800197b8 <bcache>
    80003656:	ffffd097          	auipc	ra,0xffffd
    8000365a:	696080e7          	jalr	1686(ra) # 80000cec <release>
}
    8000365e:	60e2                	ld	ra,24(sp)
    80003660:	6442                	ld	s0,16(sp)
    80003662:	64a2                	ld	s1,8(sp)
    80003664:	6902                	ld	s2,0(sp)
    80003666:	6105                	addi	sp,sp,32
    80003668:	8082                	ret
    panic("brelse");
    8000366a:	00005517          	auipc	a0,0x5
    8000366e:	e9650513          	addi	a0,a0,-362 # 80008500 <etext+0x500>
    80003672:	ffffd097          	auipc	ra,0xffffd
    80003676:	eee080e7          	jalr	-274(ra) # 80000560 <panic>

000000008000367a <bpin>:

void
bpin(struct buf *b) {
    8000367a:	1101                	addi	sp,sp,-32
    8000367c:	ec06                	sd	ra,24(sp)
    8000367e:	e822                	sd	s0,16(sp)
    80003680:	e426                	sd	s1,8(sp)
    80003682:	1000                	addi	s0,sp,32
    80003684:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003686:	00016517          	auipc	a0,0x16
    8000368a:	13250513          	addi	a0,a0,306 # 800197b8 <bcache>
    8000368e:	ffffd097          	auipc	ra,0xffffd
    80003692:	5aa080e7          	jalr	1450(ra) # 80000c38 <acquire>
  b->refcnt++;
    80003696:	40bc                	lw	a5,64(s1)
    80003698:	2785                	addiw	a5,a5,1
    8000369a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000369c:	00016517          	auipc	a0,0x16
    800036a0:	11c50513          	addi	a0,a0,284 # 800197b8 <bcache>
    800036a4:	ffffd097          	auipc	ra,0xffffd
    800036a8:	648080e7          	jalr	1608(ra) # 80000cec <release>
}
    800036ac:	60e2                	ld	ra,24(sp)
    800036ae:	6442                	ld	s0,16(sp)
    800036b0:	64a2                	ld	s1,8(sp)
    800036b2:	6105                	addi	sp,sp,32
    800036b4:	8082                	ret

00000000800036b6 <bunpin>:

void
bunpin(struct buf *b) {
    800036b6:	1101                	addi	sp,sp,-32
    800036b8:	ec06                	sd	ra,24(sp)
    800036ba:	e822                	sd	s0,16(sp)
    800036bc:	e426                	sd	s1,8(sp)
    800036be:	1000                	addi	s0,sp,32
    800036c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800036c2:	00016517          	auipc	a0,0x16
    800036c6:	0f650513          	addi	a0,a0,246 # 800197b8 <bcache>
    800036ca:	ffffd097          	auipc	ra,0xffffd
    800036ce:	56e080e7          	jalr	1390(ra) # 80000c38 <acquire>
  b->refcnt--;
    800036d2:	40bc                	lw	a5,64(s1)
    800036d4:	37fd                	addiw	a5,a5,-1
    800036d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036d8:	00016517          	auipc	a0,0x16
    800036dc:	0e050513          	addi	a0,a0,224 # 800197b8 <bcache>
    800036e0:	ffffd097          	auipc	ra,0xffffd
    800036e4:	60c080e7          	jalr	1548(ra) # 80000cec <release>
}
    800036e8:	60e2                	ld	ra,24(sp)
    800036ea:	6442                	ld	s0,16(sp)
    800036ec:	64a2                	ld	s1,8(sp)
    800036ee:	6105                	addi	sp,sp,32
    800036f0:	8082                	ret

00000000800036f2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800036f2:	1101                	addi	sp,sp,-32
    800036f4:	ec06                	sd	ra,24(sp)
    800036f6:	e822                	sd	s0,16(sp)
    800036f8:	e426                	sd	s1,8(sp)
    800036fa:	e04a                	sd	s2,0(sp)
    800036fc:	1000                	addi	s0,sp,32
    800036fe:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003700:	00d5d59b          	srliw	a1,a1,0xd
    80003704:	0001e797          	auipc	a5,0x1e
    80003708:	7907a783          	lw	a5,1936(a5) # 80021e94 <sb+0x1c>
    8000370c:	9dbd                	addw	a1,a1,a5
    8000370e:	00000097          	auipc	ra,0x0
    80003712:	da0080e7          	jalr	-608(ra) # 800034ae <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003716:	0074f713          	andi	a4,s1,7
    8000371a:	4785                	li	a5,1
    8000371c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003720:	14ce                	slli	s1,s1,0x33
    80003722:	90d9                	srli	s1,s1,0x36
    80003724:	00950733          	add	a4,a0,s1
    80003728:	05874703          	lbu	a4,88(a4)
    8000372c:	00e7f6b3          	and	a3,a5,a4
    80003730:	c69d                	beqz	a3,8000375e <bfree+0x6c>
    80003732:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003734:	94aa                	add	s1,s1,a0
    80003736:	fff7c793          	not	a5,a5
    8000373a:	8f7d                	and	a4,a4,a5
    8000373c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003740:	00001097          	auipc	ra,0x1
    80003744:	148080e7          	jalr	328(ra) # 80004888 <log_write>
  brelse(bp);
    80003748:	854a                	mv	a0,s2
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	e94080e7          	jalr	-364(ra) # 800035de <brelse>
}
    80003752:	60e2                	ld	ra,24(sp)
    80003754:	6442                	ld	s0,16(sp)
    80003756:	64a2                	ld	s1,8(sp)
    80003758:	6902                	ld	s2,0(sp)
    8000375a:	6105                	addi	sp,sp,32
    8000375c:	8082                	ret
    panic("freeing free block");
    8000375e:	00005517          	auipc	a0,0x5
    80003762:	daa50513          	addi	a0,a0,-598 # 80008508 <etext+0x508>
    80003766:	ffffd097          	auipc	ra,0xffffd
    8000376a:	dfa080e7          	jalr	-518(ra) # 80000560 <panic>

000000008000376e <balloc>:
{
    8000376e:	711d                	addi	sp,sp,-96
    80003770:	ec86                	sd	ra,88(sp)
    80003772:	e8a2                	sd	s0,80(sp)
    80003774:	e4a6                	sd	s1,72(sp)
    80003776:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003778:	0001e797          	auipc	a5,0x1e
    8000377c:	7047a783          	lw	a5,1796(a5) # 80021e7c <sb+0x4>
    80003780:	10078f63          	beqz	a5,8000389e <balloc+0x130>
    80003784:	e0ca                	sd	s2,64(sp)
    80003786:	fc4e                	sd	s3,56(sp)
    80003788:	f852                	sd	s4,48(sp)
    8000378a:	f456                	sd	s5,40(sp)
    8000378c:	f05a                	sd	s6,32(sp)
    8000378e:	ec5e                	sd	s7,24(sp)
    80003790:	e862                	sd	s8,16(sp)
    80003792:	e466                	sd	s9,8(sp)
    80003794:	8baa                	mv	s7,a0
    80003796:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003798:	0001eb17          	auipc	s6,0x1e
    8000379c:	6e0b0b13          	addi	s6,s6,1760 # 80021e78 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037a0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800037a2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037a4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800037a6:	6c89                	lui	s9,0x2
    800037a8:	a061                	j	80003830 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800037aa:	97ca                	add	a5,a5,s2
    800037ac:	8e55                	or	a2,a2,a3
    800037ae:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800037b2:	854a                	mv	a0,s2
    800037b4:	00001097          	auipc	ra,0x1
    800037b8:	0d4080e7          	jalr	212(ra) # 80004888 <log_write>
        brelse(bp);
    800037bc:	854a                	mv	a0,s2
    800037be:	00000097          	auipc	ra,0x0
    800037c2:	e20080e7          	jalr	-480(ra) # 800035de <brelse>
  bp = bread(dev, bno);
    800037c6:	85a6                	mv	a1,s1
    800037c8:	855e                	mv	a0,s7
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	ce4080e7          	jalr	-796(ra) # 800034ae <bread>
    800037d2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800037d4:	40000613          	li	a2,1024
    800037d8:	4581                	li	a1,0
    800037da:	05850513          	addi	a0,a0,88
    800037de:	ffffd097          	auipc	ra,0xffffd
    800037e2:	556080e7          	jalr	1366(ra) # 80000d34 <memset>
  log_write(bp);
    800037e6:	854a                	mv	a0,s2
    800037e8:	00001097          	auipc	ra,0x1
    800037ec:	0a0080e7          	jalr	160(ra) # 80004888 <log_write>
  brelse(bp);
    800037f0:	854a                	mv	a0,s2
    800037f2:	00000097          	auipc	ra,0x0
    800037f6:	dec080e7          	jalr	-532(ra) # 800035de <brelse>
}
    800037fa:	6906                	ld	s2,64(sp)
    800037fc:	79e2                	ld	s3,56(sp)
    800037fe:	7a42                	ld	s4,48(sp)
    80003800:	7aa2                	ld	s5,40(sp)
    80003802:	7b02                	ld	s6,32(sp)
    80003804:	6be2                	ld	s7,24(sp)
    80003806:	6c42                	ld	s8,16(sp)
    80003808:	6ca2                	ld	s9,8(sp)
}
    8000380a:	8526                	mv	a0,s1
    8000380c:	60e6                	ld	ra,88(sp)
    8000380e:	6446                	ld	s0,80(sp)
    80003810:	64a6                	ld	s1,72(sp)
    80003812:	6125                	addi	sp,sp,96
    80003814:	8082                	ret
    brelse(bp);
    80003816:	854a                	mv	a0,s2
    80003818:	00000097          	auipc	ra,0x0
    8000381c:	dc6080e7          	jalr	-570(ra) # 800035de <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003820:	015c87bb          	addw	a5,s9,s5
    80003824:	00078a9b          	sext.w	s5,a5
    80003828:	004b2703          	lw	a4,4(s6)
    8000382c:	06eaf163          	bgeu	s5,a4,8000388e <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80003830:	41fad79b          	sraiw	a5,s5,0x1f
    80003834:	0137d79b          	srliw	a5,a5,0x13
    80003838:	015787bb          	addw	a5,a5,s5
    8000383c:	40d7d79b          	sraiw	a5,a5,0xd
    80003840:	01cb2583          	lw	a1,28(s6)
    80003844:	9dbd                	addw	a1,a1,a5
    80003846:	855e                	mv	a0,s7
    80003848:	00000097          	auipc	ra,0x0
    8000384c:	c66080e7          	jalr	-922(ra) # 800034ae <bread>
    80003850:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003852:	004b2503          	lw	a0,4(s6)
    80003856:	000a849b          	sext.w	s1,s5
    8000385a:	8762                	mv	a4,s8
    8000385c:	faa4fde3          	bgeu	s1,a0,80003816 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003860:	00777693          	andi	a3,a4,7
    80003864:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003868:	41f7579b          	sraiw	a5,a4,0x1f
    8000386c:	01d7d79b          	srliw	a5,a5,0x1d
    80003870:	9fb9                	addw	a5,a5,a4
    80003872:	4037d79b          	sraiw	a5,a5,0x3
    80003876:	00f90633          	add	a2,s2,a5
    8000387a:	05864603          	lbu	a2,88(a2)
    8000387e:	00c6f5b3          	and	a1,a3,a2
    80003882:	d585                	beqz	a1,800037aa <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003884:	2705                	addiw	a4,a4,1
    80003886:	2485                	addiw	s1,s1,1
    80003888:	fd471ae3          	bne	a4,s4,8000385c <balloc+0xee>
    8000388c:	b769                	j	80003816 <balloc+0xa8>
    8000388e:	6906                	ld	s2,64(sp)
    80003890:	79e2                	ld	s3,56(sp)
    80003892:	7a42                	ld	s4,48(sp)
    80003894:	7aa2                	ld	s5,40(sp)
    80003896:	7b02                	ld	s6,32(sp)
    80003898:	6be2                	ld	s7,24(sp)
    8000389a:	6c42                	ld	s8,16(sp)
    8000389c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000389e:	00005517          	auipc	a0,0x5
    800038a2:	c8250513          	addi	a0,a0,-894 # 80008520 <etext+0x520>
    800038a6:	ffffd097          	auipc	ra,0xffffd
    800038aa:	d04080e7          	jalr	-764(ra) # 800005aa <printf>
  return 0;
    800038ae:	4481                	li	s1,0
    800038b0:	bfa9                	j	8000380a <balloc+0x9c>

00000000800038b2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800038b2:	7179                	addi	sp,sp,-48
    800038b4:	f406                	sd	ra,40(sp)
    800038b6:	f022                	sd	s0,32(sp)
    800038b8:	ec26                	sd	s1,24(sp)
    800038ba:	e84a                	sd	s2,16(sp)
    800038bc:	e44e                	sd	s3,8(sp)
    800038be:	1800                	addi	s0,sp,48
    800038c0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800038c2:	47ad                	li	a5,11
    800038c4:	02b7e863          	bltu	a5,a1,800038f4 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800038c8:	02059793          	slli	a5,a1,0x20
    800038cc:	01e7d593          	srli	a1,a5,0x1e
    800038d0:	00b504b3          	add	s1,a0,a1
    800038d4:	0504a903          	lw	s2,80(s1)
    800038d8:	08091263          	bnez	s2,8000395c <bmap+0xaa>
      addr = balloc(ip->dev);
    800038dc:	4108                	lw	a0,0(a0)
    800038de:	00000097          	auipc	ra,0x0
    800038e2:	e90080e7          	jalr	-368(ra) # 8000376e <balloc>
    800038e6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800038ea:	06090963          	beqz	s2,8000395c <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    800038ee:	0524a823          	sw	s2,80(s1)
    800038f2:	a0ad                	j	8000395c <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    800038f4:	ff45849b          	addiw	s1,a1,-12
    800038f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800038fc:	0ff00793          	li	a5,255
    80003900:	08e7e863          	bltu	a5,a4,80003990 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003904:	08052903          	lw	s2,128(a0)
    80003908:	00091f63          	bnez	s2,80003926 <bmap+0x74>
      addr = balloc(ip->dev);
    8000390c:	4108                	lw	a0,0(a0)
    8000390e:	00000097          	auipc	ra,0x0
    80003912:	e60080e7          	jalr	-416(ra) # 8000376e <balloc>
    80003916:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000391a:	04090163          	beqz	s2,8000395c <bmap+0xaa>
    8000391e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003920:	0929a023          	sw	s2,128(s3)
    80003924:	a011                	j	80003928 <bmap+0x76>
    80003926:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003928:	85ca                	mv	a1,s2
    8000392a:	0009a503          	lw	a0,0(s3)
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	b80080e7          	jalr	-1152(ra) # 800034ae <bread>
    80003936:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003938:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000393c:	02049713          	slli	a4,s1,0x20
    80003940:	01e75593          	srli	a1,a4,0x1e
    80003944:	00b784b3          	add	s1,a5,a1
    80003948:	0004a903          	lw	s2,0(s1)
    8000394c:	02090063          	beqz	s2,8000396c <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003950:	8552                	mv	a0,s4
    80003952:	00000097          	auipc	ra,0x0
    80003956:	c8c080e7          	jalr	-884(ra) # 800035de <brelse>
    return addr;
    8000395a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000395c:	854a                	mv	a0,s2
    8000395e:	70a2                	ld	ra,40(sp)
    80003960:	7402                	ld	s0,32(sp)
    80003962:	64e2                	ld	s1,24(sp)
    80003964:	6942                	ld	s2,16(sp)
    80003966:	69a2                	ld	s3,8(sp)
    80003968:	6145                	addi	sp,sp,48
    8000396a:	8082                	ret
      addr = balloc(ip->dev);
    8000396c:	0009a503          	lw	a0,0(s3)
    80003970:	00000097          	auipc	ra,0x0
    80003974:	dfe080e7          	jalr	-514(ra) # 8000376e <balloc>
    80003978:	0005091b          	sext.w	s2,a0
      if(addr){
    8000397c:	fc090ae3          	beqz	s2,80003950 <bmap+0x9e>
        a[bn] = addr;
    80003980:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003984:	8552                	mv	a0,s4
    80003986:	00001097          	auipc	ra,0x1
    8000398a:	f02080e7          	jalr	-254(ra) # 80004888 <log_write>
    8000398e:	b7c9                	j	80003950 <bmap+0x9e>
    80003990:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003992:	00005517          	auipc	a0,0x5
    80003996:	ba650513          	addi	a0,a0,-1114 # 80008538 <etext+0x538>
    8000399a:	ffffd097          	auipc	ra,0xffffd
    8000399e:	bc6080e7          	jalr	-1082(ra) # 80000560 <panic>

00000000800039a2 <iget>:
{
    800039a2:	7179                	addi	sp,sp,-48
    800039a4:	f406                	sd	ra,40(sp)
    800039a6:	f022                	sd	s0,32(sp)
    800039a8:	ec26                	sd	s1,24(sp)
    800039aa:	e84a                	sd	s2,16(sp)
    800039ac:	e44e                	sd	s3,8(sp)
    800039ae:	e052                	sd	s4,0(sp)
    800039b0:	1800                	addi	s0,sp,48
    800039b2:	89aa                	mv	s3,a0
    800039b4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800039b6:	0001e517          	auipc	a0,0x1e
    800039ba:	4e250513          	addi	a0,a0,1250 # 80021e98 <itable>
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	27a080e7          	jalr	634(ra) # 80000c38 <acquire>
  empty = 0;
    800039c6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039c8:	0001e497          	auipc	s1,0x1e
    800039cc:	4e848493          	addi	s1,s1,1256 # 80021eb0 <itable+0x18>
    800039d0:	00020697          	auipc	a3,0x20
    800039d4:	f7068693          	addi	a3,a3,-144 # 80023940 <log>
    800039d8:	a039                	j	800039e6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039da:	02090b63          	beqz	s2,80003a10 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039de:	08848493          	addi	s1,s1,136
    800039e2:	02d48a63          	beq	s1,a3,80003a16 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800039e6:	449c                	lw	a5,8(s1)
    800039e8:	fef059e3          	blez	a5,800039da <iget+0x38>
    800039ec:	4098                	lw	a4,0(s1)
    800039ee:	ff3716e3          	bne	a4,s3,800039da <iget+0x38>
    800039f2:	40d8                	lw	a4,4(s1)
    800039f4:	ff4713e3          	bne	a4,s4,800039da <iget+0x38>
      ip->ref++;
    800039f8:	2785                	addiw	a5,a5,1
    800039fa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800039fc:	0001e517          	auipc	a0,0x1e
    80003a00:	49c50513          	addi	a0,a0,1180 # 80021e98 <itable>
    80003a04:	ffffd097          	auipc	ra,0xffffd
    80003a08:	2e8080e7          	jalr	744(ra) # 80000cec <release>
      return ip;
    80003a0c:	8926                	mv	s2,s1
    80003a0e:	a03d                	j	80003a3c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a10:	f7f9                	bnez	a5,800039de <iget+0x3c>
      empty = ip;
    80003a12:	8926                	mv	s2,s1
    80003a14:	b7e9                	j	800039de <iget+0x3c>
  if(empty == 0)
    80003a16:	02090c63          	beqz	s2,80003a4e <iget+0xac>
  ip->dev = dev;
    80003a1a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003a1e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003a22:	4785                	li	a5,1
    80003a24:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003a28:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003a2c:	0001e517          	auipc	a0,0x1e
    80003a30:	46c50513          	addi	a0,a0,1132 # 80021e98 <itable>
    80003a34:	ffffd097          	auipc	ra,0xffffd
    80003a38:	2b8080e7          	jalr	696(ra) # 80000cec <release>
}
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	70a2                	ld	ra,40(sp)
    80003a40:	7402                	ld	s0,32(sp)
    80003a42:	64e2                	ld	s1,24(sp)
    80003a44:	6942                	ld	s2,16(sp)
    80003a46:	69a2                	ld	s3,8(sp)
    80003a48:	6a02                	ld	s4,0(sp)
    80003a4a:	6145                	addi	sp,sp,48
    80003a4c:	8082                	ret
    panic("iget: no inodes");
    80003a4e:	00005517          	auipc	a0,0x5
    80003a52:	b0250513          	addi	a0,a0,-1278 # 80008550 <etext+0x550>
    80003a56:	ffffd097          	auipc	ra,0xffffd
    80003a5a:	b0a080e7          	jalr	-1270(ra) # 80000560 <panic>

0000000080003a5e <fsinit>:
fsinit(int dev) {
    80003a5e:	7179                	addi	sp,sp,-48
    80003a60:	f406                	sd	ra,40(sp)
    80003a62:	f022                	sd	s0,32(sp)
    80003a64:	ec26                	sd	s1,24(sp)
    80003a66:	e84a                	sd	s2,16(sp)
    80003a68:	e44e                	sd	s3,8(sp)
    80003a6a:	1800                	addi	s0,sp,48
    80003a6c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a6e:	4585                	li	a1,1
    80003a70:	00000097          	auipc	ra,0x0
    80003a74:	a3e080e7          	jalr	-1474(ra) # 800034ae <bread>
    80003a78:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a7a:	0001e997          	auipc	s3,0x1e
    80003a7e:	3fe98993          	addi	s3,s3,1022 # 80021e78 <sb>
    80003a82:	02000613          	li	a2,32
    80003a86:	05850593          	addi	a1,a0,88
    80003a8a:	854e                	mv	a0,s3
    80003a8c:	ffffd097          	auipc	ra,0xffffd
    80003a90:	304080e7          	jalr	772(ra) # 80000d90 <memmove>
  brelse(bp);
    80003a94:	8526                	mv	a0,s1
    80003a96:	00000097          	auipc	ra,0x0
    80003a9a:	b48080e7          	jalr	-1208(ra) # 800035de <brelse>
  if(sb.magic != FSMAGIC)
    80003a9e:	0009a703          	lw	a4,0(s3)
    80003aa2:	102037b7          	lui	a5,0x10203
    80003aa6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003aaa:	02f71263          	bne	a4,a5,80003ace <fsinit+0x70>
  initlog(dev, &sb);
    80003aae:	0001e597          	auipc	a1,0x1e
    80003ab2:	3ca58593          	addi	a1,a1,970 # 80021e78 <sb>
    80003ab6:	854a                	mv	a0,s2
    80003ab8:	00001097          	auipc	ra,0x1
    80003abc:	b60080e7          	jalr	-1184(ra) # 80004618 <initlog>
}
    80003ac0:	70a2                	ld	ra,40(sp)
    80003ac2:	7402                	ld	s0,32(sp)
    80003ac4:	64e2                	ld	s1,24(sp)
    80003ac6:	6942                	ld	s2,16(sp)
    80003ac8:	69a2                	ld	s3,8(sp)
    80003aca:	6145                	addi	sp,sp,48
    80003acc:	8082                	ret
    panic("invalid file system");
    80003ace:	00005517          	auipc	a0,0x5
    80003ad2:	a9250513          	addi	a0,a0,-1390 # 80008560 <etext+0x560>
    80003ad6:	ffffd097          	auipc	ra,0xffffd
    80003ada:	a8a080e7          	jalr	-1398(ra) # 80000560 <panic>

0000000080003ade <iinit>:
{
    80003ade:	7179                	addi	sp,sp,-48
    80003ae0:	f406                	sd	ra,40(sp)
    80003ae2:	f022                	sd	s0,32(sp)
    80003ae4:	ec26                	sd	s1,24(sp)
    80003ae6:	e84a                	sd	s2,16(sp)
    80003ae8:	e44e                	sd	s3,8(sp)
    80003aea:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003aec:	00005597          	auipc	a1,0x5
    80003af0:	a8c58593          	addi	a1,a1,-1396 # 80008578 <etext+0x578>
    80003af4:	0001e517          	auipc	a0,0x1e
    80003af8:	3a450513          	addi	a0,a0,932 # 80021e98 <itable>
    80003afc:	ffffd097          	auipc	ra,0xffffd
    80003b00:	0ac080e7          	jalr	172(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003b04:	0001e497          	auipc	s1,0x1e
    80003b08:	3bc48493          	addi	s1,s1,956 # 80021ec0 <itable+0x28>
    80003b0c:	00020997          	auipc	s3,0x20
    80003b10:	e4498993          	addi	s3,s3,-444 # 80023950 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003b14:	00005917          	auipc	s2,0x5
    80003b18:	a6c90913          	addi	s2,s2,-1428 # 80008580 <etext+0x580>
    80003b1c:	85ca                	mv	a1,s2
    80003b1e:	8526                	mv	a0,s1
    80003b20:	00001097          	auipc	ra,0x1
    80003b24:	e4c080e7          	jalr	-436(ra) # 8000496c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b28:	08848493          	addi	s1,s1,136
    80003b2c:	ff3498e3          	bne	s1,s3,80003b1c <iinit+0x3e>
}
    80003b30:	70a2                	ld	ra,40(sp)
    80003b32:	7402                	ld	s0,32(sp)
    80003b34:	64e2                	ld	s1,24(sp)
    80003b36:	6942                	ld	s2,16(sp)
    80003b38:	69a2                	ld	s3,8(sp)
    80003b3a:	6145                	addi	sp,sp,48
    80003b3c:	8082                	ret

0000000080003b3e <ialloc>:
{
    80003b3e:	7139                	addi	sp,sp,-64
    80003b40:	fc06                	sd	ra,56(sp)
    80003b42:	f822                	sd	s0,48(sp)
    80003b44:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b46:	0001e717          	auipc	a4,0x1e
    80003b4a:	33e72703          	lw	a4,830(a4) # 80021e84 <sb+0xc>
    80003b4e:	4785                	li	a5,1
    80003b50:	06e7f463          	bgeu	a5,a4,80003bb8 <ialloc+0x7a>
    80003b54:	f426                	sd	s1,40(sp)
    80003b56:	f04a                	sd	s2,32(sp)
    80003b58:	ec4e                	sd	s3,24(sp)
    80003b5a:	e852                	sd	s4,16(sp)
    80003b5c:	e456                	sd	s5,8(sp)
    80003b5e:	e05a                	sd	s6,0(sp)
    80003b60:	8aaa                	mv	s5,a0
    80003b62:	8b2e                	mv	s6,a1
    80003b64:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003b66:	0001ea17          	auipc	s4,0x1e
    80003b6a:	312a0a13          	addi	s4,s4,786 # 80021e78 <sb>
    80003b6e:	00495593          	srli	a1,s2,0x4
    80003b72:	018a2783          	lw	a5,24(s4)
    80003b76:	9dbd                	addw	a1,a1,a5
    80003b78:	8556                	mv	a0,s5
    80003b7a:	00000097          	auipc	ra,0x0
    80003b7e:	934080e7          	jalr	-1740(ra) # 800034ae <bread>
    80003b82:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b84:	05850993          	addi	s3,a0,88
    80003b88:	00f97793          	andi	a5,s2,15
    80003b8c:	079a                	slli	a5,a5,0x6
    80003b8e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b90:	00099783          	lh	a5,0(s3)
    80003b94:	cf9d                	beqz	a5,80003bd2 <ialloc+0x94>
    brelse(bp);
    80003b96:	00000097          	auipc	ra,0x0
    80003b9a:	a48080e7          	jalr	-1464(ra) # 800035de <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b9e:	0905                	addi	s2,s2,1
    80003ba0:	00ca2703          	lw	a4,12(s4)
    80003ba4:	0009079b          	sext.w	a5,s2
    80003ba8:	fce7e3e3          	bltu	a5,a4,80003b6e <ialloc+0x30>
    80003bac:	74a2                	ld	s1,40(sp)
    80003bae:	7902                	ld	s2,32(sp)
    80003bb0:	69e2                	ld	s3,24(sp)
    80003bb2:	6a42                	ld	s4,16(sp)
    80003bb4:	6aa2                	ld	s5,8(sp)
    80003bb6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003bb8:	00005517          	auipc	a0,0x5
    80003bbc:	9d050513          	addi	a0,a0,-1584 # 80008588 <etext+0x588>
    80003bc0:	ffffd097          	auipc	ra,0xffffd
    80003bc4:	9ea080e7          	jalr	-1558(ra) # 800005aa <printf>
  return 0;
    80003bc8:	4501                	li	a0,0
}
    80003bca:	70e2                	ld	ra,56(sp)
    80003bcc:	7442                	ld	s0,48(sp)
    80003bce:	6121                	addi	sp,sp,64
    80003bd0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003bd2:	04000613          	li	a2,64
    80003bd6:	4581                	li	a1,0
    80003bd8:	854e                	mv	a0,s3
    80003bda:	ffffd097          	auipc	ra,0xffffd
    80003bde:	15a080e7          	jalr	346(ra) # 80000d34 <memset>
      dip->type = type;
    80003be2:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003be6:	8526                	mv	a0,s1
    80003be8:	00001097          	auipc	ra,0x1
    80003bec:	ca0080e7          	jalr	-864(ra) # 80004888 <log_write>
      brelse(bp);
    80003bf0:	8526                	mv	a0,s1
    80003bf2:	00000097          	auipc	ra,0x0
    80003bf6:	9ec080e7          	jalr	-1556(ra) # 800035de <brelse>
      return iget(dev, inum);
    80003bfa:	0009059b          	sext.w	a1,s2
    80003bfe:	8556                	mv	a0,s5
    80003c00:	00000097          	auipc	ra,0x0
    80003c04:	da2080e7          	jalr	-606(ra) # 800039a2 <iget>
    80003c08:	74a2                	ld	s1,40(sp)
    80003c0a:	7902                	ld	s2,32(sp)
    80003c0c:	69e2                	ld	s3,24(sp)
    80003c0e:	6a42                	ld	s4,16(sp)
    80003c10:	6aa2                	ld	s5,8(sp)
    80003c12:	6b02                	ld	s6,0(sp)
    80003c14:	bf5d                	j	80003bca <ialloc+0x8c>

0000000080003c16 <iupdate>:
{
    80003c16:	1101                	addi	sp,sp,-32
    80003c18:	ec06                	sd	ra,24(sp)
    80003c1a:	e822                	sd	s0,16(sp)
    80003c1c:	e426                	sd	s1,8(sp)
    80003c1e:	e04a                	sd	s2,0(sp)
    80003c20:	1000                	addi	s0,sp,32
    80003c22:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c24:	415c                	lw	a5,4(a0)
    80003c26:	0047d79b          	srliw	a5,a5,0x4
    80003c2a:	0001e597          	auipc	a1,0x1e
    80003c2e:	2665a583          	lw	a1,614(a1) # 80021e90 <sb+0x18>
    80003c32:	9dbd                	addw	a1,a1,a5
    80003c34:	4108                	lw	a0,0(a0)
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	878080e7          	jalr	-1928(ra) # 800034ae <bread>
    80003c3e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c40:	05850793          	addi	a5,a0,88
    80003c44:	40d8                	lw	a4,4(s1)
    80003c46:	8b3d                	andi	a4,a4,15
    80003c48:	071a                	slli	a4,a4,0x6
    80003c4a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003c4c:	04449703          	lh	a4,68(s1)
    80003c50:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003c54:	04649703          	lh	a4,70(s1)
    80003c58:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003c5c:	04849703          	lh	a4,72(s1)
    80003c60:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003c64:	04a49703          	lh	a4,74(s1)
    80003c68:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003c6c:	44f8                	lw	a4,76(s1)
    80003c6e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c70:	03400613          	li	a2,52
    80003c74:	05048593          	addi	a1,s1,80
    80003c78:	00c78513          	addi	a0,a5,12
    80003c7c:	ffffd097          	auipc	ra,0xffffd
    80003c80:	114080e7          	jalr	276(ra) # 80000d90 <memmove>
  log_write(bp);
    80003c84:	854a                	mv	a0,s2
    80003c86:	00001097          	auipc	ra,0x1
    80003c8a:	c02080e7          	jalr	-1022(ra) # 80004888 <log_write>
  brelse(bp);
    80003c8e:	854a                	mv	a0,s2
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	94e080e7          	jalr	-1714(ra) # 800035de <brelse>
}
    80003c98:	60e2                	ld	ra,24(sp)
    80003c9a:	6442                	ld	s0,16(sp)
    80003c9c:	64a2                	ld	s1,8(sp)
    80003c9e:	6902                	ld	s2,0(sp)
    80003ca0:	6105                	addi	sp,sp,32
    80003ca2:	8082                	ret

0000000080003ca4 <idup>:
{
    80003ca4:	1101                	addi	sp,sp,-32
    80003ca6:	ec06                	sd	ra,24(sp)
    80003ca8:	e822                	sd	s0,16(sp)
    80003caa:	e426                	sd	s1,8(sp)
    80003cac:	1000                	addi	s0,sp,32
    80003cae:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003cb0:	0001e517          	auipc	a0,0x1e
    80003cb4:	1e850513          	addi	a0,a0,488 # 80021e98 <itable>
    80003cb8:	ffffd097          	auipc	ra,0xffffd
    80003cbc:	f80080e7          	jalr	-128(ra) # 80000c38 <acquire>
  ip->ref++;
    80003cc0:	449c                	lw	a5,8(s1)
    80003cc2:	2785                	addiw	a5,a5,1
    80003cc4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003cc6:	0001e517          	auipc	a0,0x1e
    80003cca:	1d250513          	addi	a0,a0,466 # 80021e98 <itable>
    80003cce:	ffffd097          	auipc	ra,0xffffd
    80003cd2:	01e080e7          	jalr	30(ra) # 80000cec <release>
}
    80003cd6:	8526                	mv	a0,s1
    80003cd8:	60e2                	ld	ra,24(sp)
    80003cda:	6442                	ld	s0,16(sp)
    80003cdc:	64a2                	ld	s1,8(sp)
    80003cde:	6105                	addi	sp,sp,32
    80003ce0:	8082                	ret

0000000080003ce2 <ilock>:
{
    80003ce2:	1101                	addi	sp,sp,-32
    80003ce4:	ec06                	sd	ra,24(sp)
    80003ce6:	e822                	sd	s0,16(sp)
    80003ce8:	e426                	sd	s1,8(sp)
    80003cea:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003cec:	c10d                	beqz	a0,80003d0e <ilock+0x2c>
    80003cee:	84aa                	mv	s1,a0
    80003cf0:	451c                	lw	a5,8(a0)
    80003cf2:	00f05e63          	blez	a5,80003d0e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003cf6:	0541                	addi	a0,a0,16
    80003cf8:	00001097          	auipc	ra,0x1
    80003cfc:	cae080e7          	jalr	-850(ra) # 800049a6 <acquiresleep>
  if(ip->valid == 0){
    80003d00:	40bc                	lw	a5,64(s1)
    80003d02:	cf99                	beqz	a5,80003d20 <ilock+0x3e>
}
    80003d04:	60e2                	ld	ra,24(sp)
    80003d06:	6442                	ld	s0,16(sp)
    80003d08:	64a2                	ld	s1,8(sp)
    80003d0a:	6105                	addi	sp,sp,32
    80003d0c:	8082                	ret
    80003d0e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003d10:	00005517          	auipc	a0,0x5
    80003d14:	89050513          	addi	a0,a0,-1904 # 800085a0 <etext+0x5a0>
    80003d18:	ffffd097          	auipc	ra,0xffffd
    80003d1c:	848080e7          	jalr	-1976(ra) # 80000560 <panic>
    80003d20:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d22:	40dc                	lw	a5,4(s1)
    80003d24:	0047d79b          	srliw	a5,a5,0x4
    80003d28:	0001e597          	auipc	a1,0x1e
    80003d2c:	1685a583          	lw	a1,360(a1) # 80021e90 <sb+0x18>
    80003d30:	9dbd                	addw	a1,a1,a5
    80003d32:	4088                	lw	a0,0(s1)
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	77a080e7          	jalr	1914(ra) # 800034ae <bread>
    80003d3c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d3e:	05850593          	addi	a1,a0,88
    80003d42:	40dc                	lw	a5,4(s1)
    80003d44:	8bbd                	andi	a5,a5,15
    80003d46:	079a                	slli	a5,a5,0x6
    80003d48:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003d4a:	00059783          	lh	a5,0(a1)
    80003d4e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003d52:	00259783          	lh	a5,2(a1)
    80003d56:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d5a:	00459783          	lh	a5,4(a1)
    80003d5e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d62:	00659783          	lh	a5,6(a1)
    80003d66:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d6a:	459c                	lw	a5,8(a1)
    80003d6c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d6e:	03400613          	li	a2,52
    80003d72:	05b1                	addi	a1,a1,12
    80003d74:	05048513          	addi	a0,s1,80
    80003d78:	ffffd097          	auipc	ra,0xffffd
    80003d7c:	018080e7          	jalr	24(ra) # 80000d90 <memmove>
    brelse(bp);
    80003d80:	854a                	mv	a0,s2
    80003d82:	00000097          	auipc	ra,0x0
    80003d86:	85c080e7          	jalr	-1956(ra) # 800035de <brelse>
    ip->valid = 1;
    80003d8a:	4785                	li	a5,1
    80003d8c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d8e:	04449783          	lh	a5,68(s1)
    80003d92:	c399                	beqz	a5,80003d98 <ilock+0xb6>
    80003d94:	6902                	ld	s2,0(sp)
    80003d96:	b7bd                	j	80003d04 <ilock+0x22>
      panic("ilock: no type");
    80003d98:	00005517          	auipc	a0,0x5
    80003d9c:	81050513          	addi	a0,a0,-2032 # 800085a8 <etext+0x5a8>
    80003da0:	ffffc097          	auipc	ra,0xffffc
    80003da4:	7c0080e7          	jalr	1984(ra) # 80000560 <panic>

0000000080003da8 <iunlock>:
{
    80003da8:	1101                	addi	sp,sp,-32
    80003daa:	ec06                	sd	ra,24(sp)
    80003dac:	e822                	sd	s0,16(sp)
    80003dae:	e426                	sd	s1,8(sp)
    80003db0:	e04a                	sd	s2,0(sp)
    80003db2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003db4:	c905                	beqz	a0,80003de4 <iunlock+0x3c>
    80003db6:	84aa                	mv	s1,a0
    80003db8:	01050913          	addi	s2,a0,16
    80003dbc:	854a                	mv	a0,s2
    80003dbe:	00001097          	auipc	ra,0x1
    80003dc2:	c82080e7          	jalr	-894(ra) # 80004a40 <holdingsleep>
    80003dc6:	cd19                	beqz	a0,80003de4 <iunlock+0x3c>
    80003dc8:	449c                	lw	a5,8(s1)
    80003dca:	00f05d63          	blez	a5,80003de4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003dce:	854a                	mv	a0,s2
    80003dd0:	00001097          	auipc	ra,0x1
    80003dd4:	c2c080e7          	jalr	-980(ra) # 800049fc <releasesleep>
}
    80003dd8:	60e2                	ld	ra,24(sp)
    80003dda:	6442                	ld	s0,16(sp)
    80003ddc:	64a2                	ld	s1,8(sp)
    80003dde:	6902                	ld	s2,0(sp)
    80003de0:	6105                	addi	sp,sp,32
    80003de2:	8082                	ret
    panic("iunlock");
    80003de4:	00004517          	auipc	a0,0x4
    80003de8:	7d450513          	addi	a0,a0,2004 # 800085b8 <etext+0x5b8>
    80003dec:	ffffc097          	auipc	ra,0xffffc
    80003df0:	774080e7          	jalr	1908(ra) # 80000560 <panic>

0000000080003df4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003df4:	7179                	addi	sp,sp,-48
    80003df6:	f406                	sd	ra,40(sp)
    80003df8:	f022                	sd	s0,32(sp)
    80003dfa:	ec26                	sd	s1,24(sp)
    80003dfc:	e84a                	sd	s2,16(sp)
    80003dfe:	e44e                	sd	s3,8(sp)
    80003e00:	1800                	addi	s0,sp,48
    80003e02:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e04:	05050493          	addi	s1,a0,80
    80003e08:	08050913          	addi	s2,a0,128
    80003e0c:	a021                	j	80003e14 <itrunc+0x20>
    80003e0e:	0491                	addi	s1,s1,4
    80003e10:	01248d63          	beq	s1,s2,80003e2a <itrunc+0x36>
    if(ip->addrs[i]){
    80003e14:	408c                	lw	a1,0(s1)
    80003e16:	dde5                	beqz	a1,80003e0e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003e18:	0009a503          	lw	a0,0(s3)
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	8d6080e7          	jalr	-1834(ra) # 800036f2 <bfree>
      ip->addrs[i] = 0;
    80003e24:	0004a023          	sw	zero,0(s1)
    80003e28:	b7dd                	j	80003e0e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e2a:	0809a583          	lw	a1,128(s3)
    80003e2e:	ed99                	bnez	a1,80003e4c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e30:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e34:	854e                	mv	a0,s3
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	de0080e7          	jalr	-544(ra) # 80003c16 <iupdate>
}
    80003e3e:	70a2                	ld	ra,40(sp)
    80003e40:	7402                	ld	s0,32(sp)
    80003e42:	64e2                	ld	s1,24(sp)
    80003e44:	6942                	ld	s2,16(sp)
    80003e46:	69a2                	ld	s3,8(sp)
    80003e48:	6145                	addi	sp,sp,48
    80003e4a:	8082                	ret
    80003e4c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e4e:	0009a503          	lw	a0,0(s3)
    80003e52:	fffff097          	auipc	ra,0xfffff
    80003e56:	65c080e7          	jalr	1628(ra) # 800034ae <bread>
    80003e5a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e5c:	05850493          	addi	s1,a0,88
    80003e60:	45850913          	addi	s2,a0,1112
    80003e64:	a021                	j	80003e6c <itrunc+0x78>
    80003e66:	0491                	addi	s1,s1,4
    80003e68:	01248b63          	beq	s1,s2,80003e7e <itrunc+0x8a>
      if(a[j])
    80003e6c:	408c                	lw	a1,0(s1)
    80003e6e:	dde5                	beqz	a1,80003e66 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003e70:	0009a503          	lw	a0,0(s3)
    80003e74:	00000097          	auipc	ra,0x0
    80003e78:	87e080e7          	jalr	-1922(ra) # 800036f2 <bfree>
    80003e7c:	b7ed                	j	80003e66 <itrunc+0x72>
    brelse(bp);
    80003e7e:	8552                	mv	a0,s4
    80003e80:	fffff097          	auipc	ra,0xfffff
    80003e84:	75e080e7          	jalr	1886(ra) # 800035de <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e88:	0809a583          	lw	a1,128(s3)
    80003e8c:	0009a503          	lw	a0,0(s3)
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	862080e7          	jalr	-1950(ra) # 800036f2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e98:	0809a023          	sw	zero,128(s3)
    80003e9c:	6a02                	ld	s4,0(sp)
    80003e9e:	bf49                	j	80003e30 <itrunc+0x3c>

0000000080003ea0 <iput>:
{
    80003ea0:	1101                	addi	sp,sp,-32
    80003ea2:	ec06                	sd	ra,24(sp)
    80003ea4:	e822                	sd	s0,16(sp)
    80003ea6:	e426                	sd	s1,8(sp)
    80003ea8:	1000                	addi	s0,sp,32
    80003eaa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003eac:	0001e517          	auipc	a0,0x1e
    80003eb0:	fec50513          	addi	a0,a0,-20 # 80021e98 <itable>
    80003eb4:	ffffd097          	auipc	ra,0xffffd
    80003eb8:	d84080e7          	jalr	-636(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ebc:	4498                	lw	a4,8(s1)
    80003ebe:	4785                	li	a5,1
    80003ec0:	02f70263          	beq	a4,a5,80003ee4 <iput+0x44>
  ip->ref--;
    80003ec4:	449c                	lw	a5,8(s1)
    80003ec6:	37fd                	addiw	a5,a5,-1
    80003ec8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003eca:	0001e517          	auipc	a0,0x1e
    80003ece:	fce50513          	addi	a0,a0,-50 # 80021e98 <itable>
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	e1a080e7          	jalr	-486(ra) # 80000cec <release>
}
    80003eda:	60e2                	ld	ra,24(sp)
    80003edc:	6442                	ld	s0,16(sp)
    80003ede:	64a2                	ld	s1,8(sp)
    80003ee0:	6105                	addi	sp,sp,32
    80003ee2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ee4:	40bc                	lw	a5,64(s1)
    80003ee6:	dff9                	beqz	a5,80003ec4 <iput+0x24>
    80003ee8:	04a49783          	lh	a5,74(s1)
    80003eec:	ffe1                	bnez	a5,80003ec4 <iput+0x24>
    80003eee:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003ef0:	01048913          	addi	s2,s1,16
    80003ef4:	854a                	mv	a0,s2
    80003ef6:	00001097          	auipc	ra,0x1
    80003efa:	ab0080e7          	jalr	-1360(ra) # 800049a6 <acquiresleep>
    release(&itable.lock);
    80003efe:	0001e517          	auipc	a0,0x1e
    80003f02:	f9a50513          	addi	a0,a0,-102 # 80021e98 <itable>
    80003f06:	ffffd097          	auipc	ra,0xffffd
    80003f0a:	de6080e7          	jalr	-538(ra) # 80000cec <release>
    itrunc(ip);
    80003f0e:	8526                	mv	a0,s1
    80003f10:	00000097          	auipc	ra,0x0
    80003f14:	ee4080e7          	jalr	-284(ra) # 80003df4 <itrunc>
    ip->type = 0;
    80003f18:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	00000097          	auipc	ra,0x0
    80003f22:	cf8080e7          	jalr	-776(ra) # 80003c16 <iupdate>
    ip->valid = 0;
    80003f26:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f2a:	854a                	mv	a0,s2
    80003f2c:	00001097          	auipc	ra,0x1
    80003f30:	ad0080e7          	jalr	-1328(ra) # 800049fc <releasesleep>
    acquire(&itable.lock);
    80003f34:	0001e517          	auipc	a0,0x1e
    80003f38:	f6450513          	addi	a0,a0,-156 # 80021e98 <itable>
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	cfc080e7          	jalr	-772(ra) # 80000c38 <acquire>
    80003f44:	6902                	ld	s2,0(sp)
    80003f46:	bfbd                	j	80003ec4 <iput+0x24>

0000000080003f48 <iunlockput>:
{
    80003f48:	1101                	addi	sp,sp,-32
    80003f4a:	ec06                	sd	ra,24(sp)
    80003f4c:	e822                	sd	s0,16(sp)
    80003f4e:	e426                	sd	s1,8(sp)
    80003f50:	1000                	addi	s0,sp,32
    80003f52:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f54:	00000097          	auipc	ra,0x0
    80003f58:	e54080e7          	jalr	-428(ra) # 80003da8 <iunlock>
  iput(ip);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	00000097          	auipc	ra,0x0
    80003f62:	f42080e7          	jalr	-190(ra) # 80003ea0 <iput>
}
    80003f66:	60e2                	ld	ra,24(sp)
    80003f68:	6442                	ld	s0,16(sp)
    80003f6a:	64a2                	ld	s1,8(sp)
    80003f6c:	6105                	addi	sp,sp,32
    80003f6e:	8082                	ret

0000000080003f70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f70:	1141                	addi	sp,sp,-16
    80003f72:	e422                	sd	s0,8(sp)
    80003f74:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f76:	411c                	lw	a5,0(a0)
    80003f78:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f7a:	415c                	lw	a5,4(a0)
    80003f7c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f7e:	04451783          	lh	a5,68(a0)
    80003f82:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f86:	04a51783          	lh	a5,74(a0)
    80003f8a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f8e:	04c56783          	lwu	a5,76(a0)
    80003f92:	e99c                	sd	a5,16(a1)
}
    80003f94:	6422                	ld	s0,8(sp)
    80003f96:	0141                	addi	sp,sp,16
    80003f98:	8082                	ret

0000000080003f9a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f9a:	457c                	lw	a5,76(a0)
    80003f9c:	10d7e563          	bltu	a5,a3,800040a6 <readi+0x10c>
{
    80003fa0:	7159                	addi	sp,sp,-112
    80003fa2:	f486                	sd	ra,104(sp)
    80003fa4:	f0a2                	sd	s0,96(sp)
    80003fa6:	eca6                	sd	s1,88(sp)
    80003fa8:	e0d2                	sd	s4,64(sp)
    80003faa:	fc56                	sd	s5,56(sp)
    80003fac:	f85a                	sd	s6,48(sp)
    80003fae:	f45e                	sd	s7,40(sp)
    80003fb0:	1880                	addi	s0,sp,112
    80003fb2:	8b2a                	mv	s6,a0
    80003fb4:	8bae                	mv	s7,a1
    80003fb6:	8a32                	mv	s4,a2
    80003fb8:	84b6                	mv	s1,a3
    80003fba:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003fbc:	9f35                	addw	a4,a4,a3
    return 0;
    80003fbe:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003fc0:	0cd76a63          	bltu	a4,a3,80004094 <readi+0xfa>
    80003fc4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003fc6:	00e7f463          	bgeu	a5,a4,80003fce <readi+0x34>
    n = ip->size - off;
    80003fca:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fce:	0a0a8963          	beqz	s5,80004080 <readi+0xe6>
    80003fd2:	e8ca                	sd	s2,80(sp)
    80003fd4:	f062                	sd	s8,32(sp)
    80003fd6:	ec66                	sd	s9,24(sp)
    80003fd8:	e86a                	sd	s10,16(sp)
    80003fda:	e46e                	sd	s11,8(sp)
    80003fdc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fde:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003fe2:	5c7d                	li	s8,-1
    80003fe4:	a82d                	j	8000401e <readi+0x84>
    80003fe6:	020d1d93          	slli	s11,s10,0x20
    80003fea:	020ddd93          	srli	s11,s11,0x20
    80003fee:	05890613          	addi	a2,s2,88
    80003ff2:	86ee                	mv	a3,s11
    80003ff4:	963a                	add	a2,a2,a4
    80003ff6:	85d2                	mv	a1,s4
    80003ff8:	855e                	mv	a0,s7
    80003ffa:	fffff097          	auipc	ra,0xfffff
    80003ffe:	8e0080e7          	jalr	-1824(ra) # 800028da <either_copyout>
    80004002:	05850d63          	beq	a0,s8,8000405c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004006:	854a                	mv	a0,s2
    80004008:	fffff097          	auipc	ra,0xfffff
    8000400c:	5d6080e7          	jalr	1494(ra) # 800035de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004010:	013d09bb          	addw	s3,s10,s3
    80004014:	009d04bb          	addw	s1,s10,s1
    80004018:	9a6e                	add	s4,s4,s11
    8000401a:	0559fd63          	bgeu	s3,s5,80004074 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    8000401e:	00a4d59b          	srliw	a1,s1,0xa
    80004022:	855a                	mv	a0,s6
    80004024:	00000097          	auipc	ra,0x0
    80004028:	88e080e7          	jalr	-1906(ra) # 800038b2 <bmap>
    8000402c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004030:	c9b1                	beqz	a1,80004084 <readi+0xea>
    bp = bread(ip->dev, addr);
    80004032:	000b2503          	lw	a0,0(s6)
    80004036:	fffff097          	auipc	ra,0xfffff
    8000403a:	478080e7          	jalr	1144(ra) # 800034ae <bread>
    8000403e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004040:	3ff4f713          	andi	a4,s1,1023
    80004044:	40ec87bb          	subw	a5,s9,a4
    80004048:	413a86bb          	subw	a3,s5,s3
    8000404c:	8d3e                	mv	s10,a5
    8000404e:	2781                	sext.w	a5,a5
    80004050:	0006861b          	sext.w	a2,a3
    80004054:	f8f679e3          	bgeu	a2,a5,80003fe6 <readi+0x4c>
    80004058:	8d36                	mv	s10,a3
    8000405a:	b771                	j	80003fe6 <readi+0x4c>
      brelse(bp);
    8000405c:	854a                	mv	a0,s2
    8000405e:	fffff097          	auipc	ra,0xfffff
    80004062:	580080e7          	jalr	1408(ra) # 800035de <brelse>
      tot = -1;
    80004066:	59fd                	li	s3,-1
      break;
    80004068:	6946                	ld	s2,80(sp)
    8000406a:	7c02                	ld	s8,32(sp)
    8000406c:	6ce2                	ld	s9,24(sp)
    8000406e:	6d42                	ld	s10,16(sp)
    80004070:	6da2                	ld	s11,8(sp)
    80004072:	a831                	j	8000408e <readi+0xf4>
    80004074:	6946                	ld	s2,80(sp)
    80004076:	7c02                	ld	s8,32(sp)
    80004078:	6ce2                	ld	s9,24(sp)
    8000407a:	6d42                	ld	s10,16(sp)
    8000407c:	6da2                	ld	s11,8(sp)
    8000407e:	a801                	j	8000408e <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004080:	89d6                	mv	s3,s5
    80004082:	a031                	j	8000408e <readi+0xf4>
    80004084:	6946                	ld	s2,80(sp)
    80004086:	7c02                	ld	s8,32(sp)
    80004088:	6ce2                	ld	s9,24(sp)
    8000408a:	6d42                	ld	s10,16(sp)
    8000408c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000408e:	0009851b          	sext.w	a0,s3
    80004092:	69a6                	ld	s3,72(sp)
}
    80004094:	70a6                	ld	ra,104(sp)
    80004096:	7406                	ld	s0,96(sp)
    80004098:	64e6                	ld	s1,88(sp)
    8000409a:	6a06                	ld	s4,64(sp)
    8000409c:	7ae2                	ld	s5,56(sp)
    8000409e:	7b42                	ld	s6,48(sp)
    800040a0:	7ba2                	ld	s7,40(sp)
    800040a2:	6165                	addi	sp,sp,112
    800040a4:	8082                	ret
    return 0;
    800040a6:	4501                	li	a0,0
}
    800040a8:	8082                	ret

00000000800040aa <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040aa:	457c                	lw	a5,76(a0)
    800040ac:	10d7ee63          	bltu	a5,a3,800041c8 <writei+0x11e>
{
    800040b0:	7159                	addi	sp,sp,-112
    800040b2:	f486                	sd	ra,104(sp)
    800040b4:	f0a2                	sd	s0,96(sp)
    800040b6:	e8ca                	sd	s2,80(sp)
    800040b8:	e0d2                	sd	s4,64(sp)
    800040ba:	fc56                	sd	s5,56(sp)
    800040bc:	f85a                	sd	s6,48(sp)
    800040be:	f45e                	sd	s7,40(sp)
    800040c0:	1880                	addi	s0,sp,112
    800040c2:	8aaa                	mv	s5,a0
    800040c4:	8bae                	mv	s7,a1
    800040c6:	8a32                	mv	s4,a2
    800040c8:	8936                	mv	s2,a3
    800040ca:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800040cc:	00e687bb          	addw	a5,a3,a4
    800040d0:	0ed7ee63          	bltu	a5,a3,800041cc <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800040d4:	00043737          	lui	a4,0x43
    800040d8:	0ef76c63          	bltu	a4,a5,800041d0 <writei+0x126>
    800040dc:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040de:	0c0b0d63          	beqz	s6,800041b8 <writei+0x10e>
    800040e2:	eca6                	sd	s1,88(sp)
    800040e4:	f062                	sd	s8,32(sp)
    800040e6:	ec66                	sd	s9,24(sp)
    800040e8:	e86a                	sd	s10,16(sp)
    800040ea:	e46e                	sd	s11,8(sp)
    800040ec:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800040ee:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800040f2:	5c7d                	li	s8,-1
    800040f4:	a091                	j	80004138 <writei+0x8e>
    800040f6:	020d1d93          	slli	s11,s10,0x20
    800040fa:	020ddd93          	srli	s11,s11,0x20
    800040fe:	05848513          	addi	a0,s1,88
    80004102:	86ee                	mv	a3,s11
    80004104:	8652                	mv	a2,s4
    80004106:	85de                	mv	a1,s7
    80004108:	953a                	add	a0,a0,a4
    8000410a:	fffff097          	auipc	ra,0xfffff
    8000410e:	826080e7          	jalr	-2010(ra) # 80002930 <either_copyin>
    80004112:	07850263          	beq	a0,s8,80004176 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004116:	8526                	mv	a0,s1
    80004118:	00000097          	auipc	ra,0x0
    8000411c:	770080e7          	jalr	1904(ra) # 80004888 <log_write>
    brelse(bp);
    80004120:	8526                	mv	a0,s1
    80004122:	fffff097          	auipc	ra,0xfffff
    80004126:	4bc080e7          	jalr	1212(ra) # 800035de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000412a:	013d09bb          	addw	s3,s10,s3
    8000412e:	012d093b          	addw	s2,s10,s2
    80004132:	9a6e                	add	s4,s4,s11
    80004134:	0569f663          	bgeu	s3,s6,80004180 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004138:	00a9559b          	srliw	a1,s2,0xa
    8000413c:	8556                	mv	a0,s5
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	774080e7          	jalr	1908(ra) # 800038b2 <bmap>
    80004146:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000414a:	c99d                	beqz	a1,80004180 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000414c:	000aa503          	lw	a0,0(s5)
    80004150:	fffff097          	auipc	ra,0xfffff
    80004154:	35e080e7          	jalr	862(ra) # 800034ae <bread>
    80004158:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000415a:	3ff97713          	andi	a4,s2,1023
    8000415e:	40ec87bb          	subw	a5,s9,a4
    80004162:	413b06bb          	subw	a3,s6,s3
    80004166:	8d3e                	mv	s10,a5
    80004168:	2781                	sext.w	a5,a5
    8000416a:	0006861b          	sext.w	a2,a3
    8000416e:	f8f674e3          	bgeu	a2,a5,800040f6 <writei+0x4c>
    80004172:	8d36                	mv	s10,a3
    80004174:	b749                	j	800040f6 <writei+0x4c>
      brelse(bp);
    80004176:	8526                	mv	a0,s1
    80004178:	fffff097          	auipc	ra,0xfffff
    8000417c:	466080e7          	jalr	1126(ra) # 800035de <brelse>
  }

  if(off > ip->size)
    80004180:	04caa783          	lw	a5,76(s5)
    80004184:	0327fc63          	bgeu	a5,s2,800041bc <writei+0x112>
    ip->size = off;
    80004188:	052aa623          	sw	s2,76(s5)
    8000418c:	64e6                	ld	s1,88(sp)
    8000418e:	7c02                	ld	s8,32(sp)
    80004190:	6ce2                	ld	s9,24(sp)
    80004192:	6d42                	ld	s10,16(sp)
    80004194:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004196:	8556                	mv	a0,s5
    80004198:	00000097          	auipc	ra,0x0
    8000419c:	a7e080e7          	jalr	-1410(ra) # 80003c16 <iupdate>

  return tot;
    800041a0:	0009851b          	sext.w	a0,s3
    800041a4:	69a6                	ld	s3,72(sp)
}
    800041a6:	70a6                	ld	ra,104(sp)
    800041a8:	7406                	ld	s0,96(sp)
    800041aa:	6946                	ld	s2,80(sp)
    800041ac:	6a06                	ld	s4,64(sp)
    800041ae:	7ae2                	ld	s5,56(sp)
    800041b0:	7b42                	ld	s6,48(sp)
    800041b2:	7ba2                	ld	s7,40(sp)
    800041b4:	6165                	addi	sp,sp,112
    800041b6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041b8:	89da                	mv	s3,s6
    800041ba:	bff1                	j	80004196 <writei+0xec>
    800041bc:	64e6                	ld	s1,88(sp)
    800041be:	7c02                	ld	s8,32(sp)
    800041c0:	6ce2                	ld	s9,24(sp)
    800041c2:	6d42                	ld	s10,16(sp)
    800041c4:	6da2                	ld	s11,8(sp)
    800041c6:	bfc1                	j	80004196 <writei+0xec>
    return -1;
    800041c8:	557d                	li	a0,-1
}
    800041ca:	8082                	ret
    return -1;
    800041cc:	557d                	li	a0,-1
    800041ce:	bfe1                	j	800041a6 <writei+0xfc>
    return -1;
    800041d0:	557d                	li	a0,-1
    800041d2:	bfd1                	j	800041a6 <writei+0xfc>

00000000800041d4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800041d4:	1141                	addi	sp,sp,-16
    800041d6:	e406                	sd	ra,8(sp)
    800041d8:	e022                	sd	s0,0(sp)
    800041da:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800041dc:	4639                	li	a2,14
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	c26080e7          	jalr	-986(ra) # 80000e04 <strncmp>
}
    800041e6:	60a2                	ld	ra,8(sp)
    800041e8:	6402                	ld	s0,0(sp)
    800041ea:	0141                	addi	sp,sp,16
    800041ec:	8082                	ret

00000000800041ee <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800041ee:	7139                	addi	sp,sp,-64
    800041f0:	fc06                	sd	ra,56(sp)
    800041f2:	f822                	sd	s0,48(sp)
    800041f4:	f426                	sd	s1,40(sp)
    800041f6:	f04a                	sd	s2,32(sp)
    800041f8:	ec4e                	sd	s3,24(sp)
    800041fa:	e852                	sd	s4,16(sp)
    800041fc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800041fe:	04451703          	lh	a4,68(a0)
    80004202:	4785                	li	a5,1
    80004204:	00f71a63          	bne	a4,a5,80004218 <dirlookup+0x2a>
    80004208:	892a                	mv	s2,a0
    8000420a:	89ae                	mv	s3,a1
    8000420c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000420e:	457c                	lw	a5,76(a0)
    80004210:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004212:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004214:	e79d                	bnez	a5,80004242 <dirlookup+0x54>
    80004216:	a8a5                	j	8000428e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004218:	00004517          	auipc	a0,0x4
    8000421c:	3a850513          	addi	a0,a0,936 # 800085c0 <etext+0x5c0>
    80004220:	ffffc097          	auipc	ra,0xffffc
    80004224:	340080e7          	jalr	832(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004228:	00004517          	auipc	a0,0x4
    8000422c:	3b050513          	addi	a0,a0,944 # 800085d8 <etext+0x5d8>
    80004230:	ffffc097          	auipc	ra,0xffffc
    80004234:	330080e7          	jalr	816(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004238:	24c1                	addiw	s1,s1,16
    8000423a:	04c92783          	lw	a5,76(s2)
    8000423e:	04f4f763          	bgeu	s1,a5,8000428c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004242:	4741                	li	a4,16
    80004244:	86a6                	mv	a3,s1
    80004246:	fc040613          	addi	a2,s0,-64
    8000424a:	4581                	li	a1,0
    8000424c:	854a                	mv	a0,s2
    8000424e:	00000097          	auipc	ra,0x0
    80004252:	d4c080e7          	jalr	-692(ra) # 80003f9a <readi>
    80004256:	47c1                	li	a5,16
    80004258:	fcf518e3          	bne	a0,a5,80004228 <dirlookup+0x3a>
    if(de.inum == 0)
    8000425c:	fc045783          	lhu	a5,-64(s0)
    80004260:	dfe1                	beqz	a5,80004238 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004262:	fc240593          	addi	a1,s0,-62
    80004266:	854e                	mv	a0,s3
    80004268:	00000097          	auipc	ra,0x0
    8000426c:	f6c080e7          	jalr	-148(ra) # 800041d4 <namecmp>
    80004270:	f561                	bnez	a0,80004238 <dirlookup+0x4a>
      if(poff)
    80004272:	000a0463          	beqz	s4,8000427a <dirlookup+0x8c>
        *poff = off;
    80004276:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000427a:	fc045583          	lhu	a1,-64(s0)
    8000427e:	00092503          	lw	a0,0(s2)
    80004282:	fffff097          	auipc	ra,0xfffff
    80004286:	720080e7          	jalr	1824(ra) # 800039a2 <iget>
    8000428a:	a011                	j	8000428e <dirlookup+0xa0>
  return 0;
    8000428c:	4501                	li	a0,0
}
    8000428e:	70e2                	ld	ra,56(sp)
    80004290:	7442                	ld	s0,48(sp)
    80004292:	74a2                	ld	s1,40(sp)
    80004294:	7902                	ld	s2,32(sp)
    80004296:	69e2                	ld	s3,24(sp)
    80004298:	6a42                	ld	s4,16(sp)
    8000429a:	6121                	addi	sp,sp,64
    8000429c:	8082                	ret

000000008000429e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000429e:	711d                	addi	sp,sp,-96
    800042a0:	ec86                	sd	ra,88(sp)
    800042a2:	e8a2                	sd	s0,80(sp)
    800042a4:	e4a6                	sd	s1,72(sp)
    800042a6:	e0ca                	sd	s2,64(sp)
    800042a8:	fc4e                	sd	s3,56(sp)
    800042aa:	f852                	sd	s4,48(sp)
    800042ac:	f456                	sd	s5,40(sp)
    800042ae:	f05a                	sd	s6,32(sp)
    800042b0:	ec5e                	sd	s7,24(sp)
    800042b2:	e862                	sd	s8,16(sp)
    800042b4:	e466                	sd	s9,8(sp)
    800042b6:	1080                	addi	s0,sp,96
    800042b8:	84aa                	mv	s1,a0
    800042ba:	8b2e                	mv	s6,a1
    800042bc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800042be:	00054703          	lbu	a4,0(a0)
    800042c2:	02f00793          	li	a5,47
    800042c6:	02f70263          	beq	a4,a5,800042ea <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800042ca:	ffffe097          	auipc	ra,0xffffe
    800042ce:	a24080e7          	jalr	-1500(ra) # 80001cee <myproc>
    800042d2:	15853503          	ld	a0,344(a0)
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	9ce080e7          	jalr	-1586(ra) # 80003ca4 <idup>
    800042de:	8a2a                	mv	s4,a0
  while(*path == '/')
    800042e0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800042e4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800042e6:	4b85                	li	s7,1
    800042e8:	a875                	j	800043a4 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800042ea:	4585                	li	a1,1
    800042ec:	4505                	li	a0,1
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	6b4080e7          	jalr	1716(ra) # 800039a2 <iget>
    800042f6:	8a2a                	mv	s4,a0
    800042f8:	b7e5                	j	800042e0 <namex+0x42>
      iunlockput(ip);
    800042fa:	8552                	mv	a0,s4
    800042fc:	00000097          	auipc	ra,0x0
    80004300:	c4c080e7          	jalr	-948(ra) # 80003f48 <iunlockput>
      return 0;
    80004304:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004306:	8552                	mv	a0,s4
    80004308:	60e6                	ld	ra,88(sp)
    8000430a:	6446                	ld	s0,80(sp)
    8000430c:	64a6                	ld	s1,72(sp)
    8000430e:	6906                	ld	s2,64(sp)
    80004310:	79e2                	ld	s3,56(sp)
    80004312:	7a42                	ld	s4,48(sp)
    80004314:	7aa2                	ld	s5,40(sp)
    80004316:	7b02                	ld	s6,32(sp)
    80004318:	6be2                	ld	s7,24(sp)
    8000431a:	6c42                	ld	s8,16(sp)
    8000431c:	6ca2                	ld	s9,8(sp)
    8000431e:	6125                	addi	sp,sp,96
    80004320:	8082                	ret
      iunlock(ip);
    80004322:	8552                	mv	a0,s4
    80004324:	00000097          	auipc	ra,0x0
    80004328:	a84080e7          	jalr	-1404(ra) # 80003da8 <iunlock>
      return ip;
    8000432c:	bfe9                	j	80004306 <namex+0x68>
      iunlockput(ip);
    8000432e:	8552                	mv	a0,s4
    80004330:	00000097          	auipc	ra,0x0
    80004334:	c18080e7          	jalr	-1000(ra) # 80003f48 <iunlockput>
      return 0;
    80004338:	8a4e                	mv	s4,s3
    8000433a:	b7f1                	j	80004306 <namex+0x68>
  len = path - s;
    8000433c:	40998633          	sub	a2,s3,s1
    80004340:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004344:	099c5863          	bge	s8,s9,800043d4 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004348:	4639                	li	a2,14
    8000434a:	85a6                	mv	a1,s1
    8000434c:	8556                	mv	a0,s5
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	a42080e7          	jalr	-1470(ra) # 80000d90 <memmove>
    80004356:	84ce                	mv	s1,s3
  while(*path == '/')
    80004358:	0004c783          	lbu	a5,0(s1)
    8000435c:	01279763          	bne	a5,s2,8000436a <namex+0xcc>
    path++;
    80004360:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004362:	0004c783          	lbu	a5,0(s1)
    80004366:	ff278de3          	beq	a5,s2,80004360 <namex+0xc2>
    ilock(ip);
    8000436a:	8552                	mv	a0,s4
    8000436c:	00000097          	auipc	ra,0x0
    80004370:	976080e7          	jalr	-1674(ra) # 80003ce2 <ilock>
    if(ip->type != T_DIR){
    80004374:	044a1783          	lh	a5,68(s4)
    80004378:	f97791e3          	bne	a5,s7,800042fa <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000437c:	000b0563          	beqz	s6,80004386 <namex+0xe8>
    80004380:	0004c783          	lbu	a5,0(s1)
    80004384:	dfd9                	beqz	a5,80004322 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004386:	4601                	li	a2,0
    80004388:	85d6                	mv	a1,s5
    8000438a:	8552                	mv	a0,s4
    8000438c:	00000097          	auipc	ra,0x0
    80004390:	e62080e7          	jalr	-414(ra) # 800041ee <dirlookup>
    80004394:	89aa                	mv	s3,a0
    80004396:	dd41                	beqz	a0,8000432e <namex+0x90>
    iunlockput(ip);
    80004398:	8552                	mv	a0,s4
    8000439a:	00000097          	auipc	ra,0x0
    8000439e:	bae080e7          	jalr	-1106(ra) # 80003f48 <iunlockput>
    ip = next;
    800043a2:	8a4e                	mv	s4,s3
  while(*path == '/')
    800043a4:	0004c783          	lbu	a5,0(s1)
    800043a8:	01279763          	bne	a5,s2,800043b6 <namex+0x118>
    path++;
    800043ac:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043ae:	0004c783          	lbu	a5,0(s1)
    800043b2:	ff278de3          	beq	a5,s2,800043ac <namex+0x10e>
  if(*path == 0)
    800043b6:	cb9d                	beqz	a5,800043ec <namex+0x14e>
  while(*path != '/' && *path != 0)
    800043b8:	0004c783          	lbu	a5,0(s1)
    800043bc:	89a6                	mv	s3,s1
  len = path - s;
    800043be:	4c81                	li	s9,0
    800043c0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800043c2:	01278963          	beq	a5,s2,800043d4 <namex+0x136>
    800043c6:	dbbd                	beqz	a5,8000433c <namex+0x9e>
    path++;
    800043c8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800043ca:	0009c783          	lbu	a5,0(s3)
    800043ce:	ff279ce3          	bne	a5,s2,800043c6 <namex+0x128>
    800043d2:	b7ad                	j	8000433c <namex+0x9e>
    memmove(name, s, len);
    800043d4:	2601                	sext.w	a2,a2
    800043d6:	85a6                	mv	a1,s1
    800043d8:	8556                	mv	a0,s5
    800043da:	ffffd097          	auipc	ra,0xffffd
    800043de:	9b6080e7          	jalr	-1610(ra) # 80000d90 <memmove>
    name[len] = 0;
    800043e2:	9cd6                	add	s9,s9,s5
    800043e4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800043e8:	84ce                	mv	s1,s3
    800043ea:	b7bd                	j	80004358 <namex+0xba>
  if(nameiparent){
    800043ec:	f00b0de3          	beqz	s6,80004306 <namex+0x68>
    iput(ip);
    800043f0:	8552                	mv	a0,s4
    800043f2:	00000097          	auipc	ra,0x0
    800043f6:	aae080e7          	jalr	-1362(ra) # 80003ea0 <iput>
    return 0;
    800043fa:	4a01                	li	s4,0
    800043fc:	b729                	j	80004306 <namex+0x68>

00000000800043fe <dirlink>:
{
    800043fe:	7139                	addi	sp,sp,-64
    80004400:	fc06                	sd	ra,56(sp)
    80004402:	f822                	sd	s0,48(sp)
    80004404:	f04a                	sd	s2,32(sp)
    80004406:	ec4e                	sd	s3,24(sp)
    80004408:	e852                	sd	s4,16(sp)
    8000440a:	0080                	addi	s0,sp,64
    8000440c:	892a                	mv	s2,a0
    8000440e:	8a2e                	mv	s4,a1
    80004410:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004412:	4601                	li	a2,0
    80004414:	00000097          	auipc	ra,0x0
    80004418:	dda080e7          	jalr	-550(ra) # 800041ee <dirlookup>
    8000441c:	ed25                	bnez	a0,80004494 <dirlink+0x96>
    8000441e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004420:	04c92483          	lw	s1,76(s2)
    80004424:	c49d                	beqz	s1,80004452 <dirlink+0x54>
    80004426:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004428:	4741                	li	a4,16
    8000442a:	86a6                	mv	a3,s1
    8000442c:	fc040613          	addi	a2,s0,-64
    80004430:	4581                	li	a1,0
    80004432:	854a                	mv	a0,s2
    80004434:	00000097          	auipc	ra,0x0
    80004438:	b66080e7          	jalr	-1178(ra) # 80003f9a <readi>
    8000443c:	47c1                	li	a5,16
    8000443e:	06f51163          	bne	a0,a5,800044a0 <dirlink+0xa2>
    if(de.inum == 0)
    80004442:	fc045783          	lhu	a5,-64(s0)
    80004446:	c791                	beqz	a5,80004452 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004448:	24c1                	addiw	s1,s1,16
    8000444a:	04c92783          	lw	a5,76(s2)
    8000444e:	fcf4ede3          	bltu	s1,a5,80004428 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004452:	4639                	li	a2,14
    80004454:	85d2                	mv	a1,s4
    80004456:	fc240513          	addi	a0,s0,-62
    8000445a:	ffffd097          	auipc	ra,0xffffd
    8000445e:	9e0080e7          	jalr	-1568(ra) # 80000e3a <strncpy>
  de.inum = inum;
    80004462:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004466:	4741                	li	a4,16
    80004468:	86a6                	mv	a3,s1
    8000446a:	fc040613          	addi	a2,s0,-64
    8000446e:	4581                	li	a1,0
    80004470:	854a                	mv	a0,s2
    80004472:	00000097          	auipc	ra,0x0
    80004476:	c38080e7          	jalr	-968(ra) # 800040aa <writei>
    8000447a:	1541                	addi	a0,a0,-16
    8000447c:	00a03533          	snez	a0,a0
    80004480:	40a00533          	neg	a0,a0
    80004484:	74a2                	ld	s1,40(sp)
}
    80004486:	70e2                	ld	ra,56(sp)
    80004488:	7442                	ld	s0,48(sp)
    8000448a:	7902                	ld	s2,32(sp)
    8000448c:	69e2                	ld	s3,24(sp)
    8000448e:	6a42                	ld	s4,16(sp)
    80004490:	6121                	addi	sp,sp,64
    80004492:	8082                	ret
    iput(ip);
    80004494:	00000097          	auipc	ra,0x0
    80004498:	a0c080e7          	jalr	-1524(ra) # 80003ea0 <iput>
    return -1;
    8000449c:	557d                	li	a0,-1
    8000449e:	b7e5                	j	80004486 <dirlink+0x88>
      panic("dirlink read");
    800044a0:	00004517          	auipc	a0,0x4
    800044a4:	14850513          	addi	a0,a0,328 # 800085e8 <etext+0x5e8>
    800044a8:	ffffc097          	auipc	ra,0xffffc
    800044ac:	0b8080e7          	jalr	184(ra) # 80000560 <panic>

00000000800044b0 <namei>:

struct inode*
namei(char *path)
{
    800044b0:	1101                	addi	sp,sp,-32
    800044b2:	ec06                	sd	ra,24(sp)
    800044b4:	e822                	sd	s0,16(sp)
    800044b6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800044b8:	fe040613          	addi	a2,s0,-32
    800044bc:	4581                	li	a1,0
    800044be:	00000097          	auipc	ra,0x0
    800044c2:	de0080e7          	jalr	-544(ra) # 8000429e <namex>
}
    800044c6:	60e2                	ld	ra,24(sp)
    800044c8:	6442                	ld	s0,16(sp)
    800044ca:	6105                	addi	sp,sp,32
    800044cc:	8082                	ret

00000000800044ce <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800044ce:	1141                	addi	sp,sp,-16
    800044d0:	e406                	sd	ra,8(sp)
    800044d2:	e022                	sd	s0,0(sp)
    800044d4:	0800                	addi	s0,sp,16
    800044d6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800044d8:	4585                	li	a1,1
    800044da:	00000097          	auipc	ra,0x0
    800044de:	dc4080e7          	jalr	-572(ra) # 8000429e <namex>
}
    800044e2:	60a2                	ld	ra,8(sp)
    800044e4:	6402                	ld	s0,0(sp)
    800044e6:	0141                	addi	sp,sp,16
    800044e8:	8082                	ret

00000000800044ea <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800044ea:	1101                	addi	sp,sp,-32
    800044ec:	ec06                	sd	ra,24(sp)
    800044ee:	e822                	sd	s0,16(sp)
    800044f0:	e426                	sd	s1,8(sp)
    800044f2:	e04a                	sd	s2,0(sp)
    800044f4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800044f6:	0001f917          	auipc	s2,0x1f
    800044fa:	44a90913          	addi	s2,s2,1098 # 80023940 <log>
    800044fe:	01892583          	lw	a1,24(s2)
    80004502:	02892503          	lw	a0,40(s2)
    80004506:	fffff097          	auipc	ra,0xfffff
    8000450a:	fa8080e7          	jalr	-88(ra) # 800034ae <bread>
    8000450e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004510:	02c92603          	lw	a2,44(s2)
    80004514:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004516:	00c05f63          	blez	a2,80004534 <write_head+0x4a>
    8000451a:	0001f717          	auipc	a4,0x1f
    8000451e:	45670713          	addi	a4,a4,1110 # 80023970 <log+0x30>
    80004522:	87aa                	mv	a5,a0
    80004524:	060a                	slli	a2,a2,0x2
    80004526:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004528:	4314                	lw	a3,0(a4)
    8000452a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000452c:	0711                	addi	a4,a4,4
    8000452e:	0791                	addi	a5,a5,4
    80004530:	fec79ce3          	bne	a5,a2,80004528 <write_head+0x3e>
  }
  bwrite(buf);
    80004534:	8526                	mv	a0,s1
    80004536:	fffff097          	auipc	ra,0xfffff
    8000453a:	06a080e7          	jalr	106(ra) # 800035a0 <bwrite>
  brelse(buf);
    8000453e:	8526                	mv	a0,s1
    80004540:	fffff097          	auipc	ra,0xfffff
    80004544:	09e080e7          	jalr	158(ra) # 800035de <brelse>
}
    80004548:	60e2                	ld	ra,24(sp)
    8000454a:	6442                	ld	s0,16(sp)
    8000454c:	64a2                	ld	s1,8(sp)
    8000454e:	6902                	ld	s2,0(sp)
    80004550:	6105                	addi	sp,sp,32
    80004552:	8082                	ret

0000000080004554 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004554:	0001f797          	auipc	a5,0x1f
    80004558:	4187a783          	lw	a5,1048(a5) # 8002396c <log+0x2c>
    8000455c:	0af05d63          	blez	a5,80004616 <install_trans+0xc2>
{
    80004560:	7139                	addi	sp,sp,-64
    80004562:	fc06                	sd	ra,56(sp)
    80004564:	f822                	sd	s0,48(sp)
    80004566:	f426                	sd	s1,40(sp)
    80004568:	f04a                	sd	s2,32(sp)
    8000456a:	ec4e                	sd	s3,24(sp)
    8000456c:	e852                	sd	s4,16(sp)
    8000456e:	e456                	sd	s5,8(sp)
    80004570:	e05a                	sd	s6,0(sp)
    80004572:	0080                	addi	s0,sp,64
    80004574:	8b2a                	mv	s6,a0
    80004576:	0001fa97          	auipc	s5,0x1f
    8000457a:	3faa8a93          	addi	s5,s5,1018 # 80023970 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000457e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004580:	0001f997          	auipc	s3,0x1f
    80004584:	3c098993          	addi	s3,s3,960 # 80023940 <log>
    80004588:	a00d                	j	800045aa <install_trans+0x56>
    brelse(lbuf);
    8000458a:	854a                	mv	a0,s2
    8000458c:	fffff097          	auipc	ra,0xfffff
    80004590:	052080e7          	jalr	82(ra) # 800035de <brelse>
    brelse(dbuf);
    80004594:	8526                	mv	a0,s1
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	048080e7          	jalr	72(ra) # 800035de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000459e:	2a05                	addiw	s4,s4,1
    800045a0:	0a91                	addi	s5,s5,4
    800045a2:	02c9a783          	lw	a5,44(s3)
    800045a6:	04fa5e63          	bge	s4,a5,80004602 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045aa:	0189a583          	lw	a1,24(s3)
    800045ae:	014585bb          	addw	a1,a1,s4
    800045b2:	2585                	addiw	a1,a1,1
    800045b4:	0289a503          	lw	a0,40(s3)
    800045b8:	fffff097          	auipc	ra,0xfffff
    800045bc:	ef6080e7          	jalr	-266(ra) # 800034ae <bread>
    800045c0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800045c2:	000aa583          	lw	a1,0(s5)
    800045c6:	0289a503          	lw	a0,40(s3)
    800045ca:	fffff097          	auipc	ra,0xfffff
    800045ce:	ee4080e7          	jalr	-284(ra) # 800034ae <bread>
    800045d2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800045d4:	40000613          	li	a2,1024
    800045d8:	05890593          	addi	a1,s2,88
    800045dc:	05850513          	addi	a0,a0,88
    800045e0:	ffffc097          	auipc	ra,0xffffc
    800045e4:	7b0080e7          	jalr	1968(ra) # 80000d90 <memmove>
    bwrite(dbuf);  // write dst to disk
    800045e8:	8526                	mv	a0,s1
    800045ea:	fffff097          	auipc	ra,0xfffff
    800045ee:	fb6080e7          	jalr	-74(ra) # 800035a0 <bwrite>
    if(recovering == 0)
    800045f2:	f80b1ce3          	bnez	s6,8000458a <install_trans+0x36>
      bunpin(dbuf);
    800045f6:	8526                	mv	a0,s1
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	0be080e7          	jalr	190(ra) # 800036b6 <bunpin>
    80004600:	b769                	j	8000458a <install_trans+0x36>
}
    80004602:	70e2                	ld	ra,56(sp)
    80004604:	7442                	ld	s0,48(sp)
    80004606:	74a2                	ld	s1,40(sp)
    80004608:	7902                	ld	s2,32(sp)
    8000460a:	69e2                	ld	s3,24(sp)
    8000460c:	6a42                	ld	s4,16(sp)
    8000460e:	6aa2                	ld	s5,8(sp)
    80004610:	6b02                	ld	s6,0(sp)
    80004612:	6121                	addi	sp,sp,64
    80004614:	8082                	ret
    80004616:	8082                	ret

0000000080004618 <initlog>:
{
    80004618:	7179                	addi	sp,sp,-48
    8000461a:	f406                	sd	ra,40(sp)
    8000461c:	f022                	sd	s0,32(sp)
    8000461e:	ec26                	sd	s1,24(sp)
    80004620:	e84a                	sd	s2,16(sp)
    80004622:	e44e                	sd	s3,8(sp)
    80004624:	1800                	addi	s0,sp,48
    80004626:	892a                	mv	s2,a0
    80004628:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000462a:	0001f497          	auipc	s1,0x1f
    8000462e:	31648493          	addi	s1,s1,790 # 80023940 <log>
    80004632:	00004597          	auipc	a1,0x4
    80004636:	fc658593          	addi	a1,a1,-58 # 800085f8 <etext+0x5f8>
    8000463a:	8526                	mv	a0,s1
    8000463c:	ffffc097          	auipc	ra,0xffffc
    80004640:	56c080e7          	jalr	1388(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    80004644:	0149a583          	lw	a1,20(s3)
    80004648:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000464a:	0109a783          	lw	a5,16(s3)
    8000464e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004650:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004654:	854a                	mv	a0,s2
    80004656:	fffff097          	auipc	ra,0xfffff
    8000465a:	e58080e7          	jalr	-424(ra) # 800034ae <bread>
  log.lh.n = lh->n;
    8000465e:	4d30                	lw	a2,88(a0)
    80004660:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004662:	00c05f63          	blez	a2,80004680 <initlog+0x68>
    80004666:	87aa                	mv	a5,a0
    80004668:	0001f717          	auipc	a4,0x1f
    8000466c:	30870713          	addi	a4,a4,776 # 80023970 <log+0x30>
    80004670:	060a                	slli	a2,a2,0x2
    80004672:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004674:	4ff4                	lw	a3,92(a5)
    80004676:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004678:	0791                	addi	a5,a5,4
    8000467a:	0711                	addi	a4,a4,4
    8000467c:	fec79ce3          	bne	a5,a2,80004674 <initlog+0x5c>
  brelse(buf);
    80004680:	fffff097          	auipc	ra,0xfffff
    80004684:	f5e080e7          	jalr	-162(ra) # 800035de <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004688:	4505                	li	a0,1
    8000468a:	00000097          	auipc	ra,0x0
    8000468e:	eca080e7          	jalr	-310(ra) # 80004554 <install_trans>
  log.lh.n = 0;
    80004692:	0001f797          	auipc	a5,0x1f
    80004696:	2c07ad23          	sw	zero,730(a5) # 8002396c <log+0x2c>
  write_head(); // clear the log
    8000469a:	00000097          	auipc	ra,0x0
    8000469e:	e50080e7          	jalr	-432(ra) # 800044ea <write_head>
}
    800046a2:	70a2                	ld	ra,40(sp)
    800046a4:	7402                	ld	s0,32(sp)
    800046a6:	64e2                	ld	s1,24(sp)
    800046a8:	6942                	ld	s2,16(sp)
    800046aa:	69a2                	ld	s3,8(sp)
    800046ac:	6145                	addi	sp,sp,48
    800046ae:	8082                	ret

00000000800046b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800046b0:	1101                	addi	sp,sp,-32
    800046b2:	ec06                	sd	ra,24(sp)
    800046b4:	e822                	sd	s0,16(sp)
    800046b6:	e426                	sd	s1,8(sp)
    800046b8:	e04a                	sd	s2,0(sp)
    800046ba:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800046bc:	0001f517          	auipc	a0,0x1f
    800046c0:	28450513          	addi	a0,a0,644 # 80023940 <log>
    800046c4:	ffffc097          	auipc	ra,0xffffc
    800046c8:	574080e7          	jalr	1396(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    800046cc:	0001f497          	auipc	s1,0x1f
    800046d0:	27448493          	addi	s1,s1,628 # 80023940 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046d4:	4979                	li	s2,30
    800046d6:	a039                	j	800046e4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800046d8:	85a6                	mv	a1,s1
    800046da:	8526                	mv	a0,s1
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	df6080e7          	jalr	-522(ra) # 800024d2 <sleep>
    if(log.committing){
    800046e4:	50dc                	lw	a5,36(s1)
    800046e6:	fbed                	bnez	a5,800046d8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046e8:	5098                	lw	a4,32(s1)
    800046ea:	2705                	addiw	a4,a4,1
    800046ec:	0027179b          	slliw	a5,a4,0x2
    800046f0:	9fb9                	addw	a5,a5,a4
    800046f2:	0017979b          	slliw	a5,a5,0x1
    800046f6:	54d4                	lw	a3,44(s1)
    800046f8:	9fb5                	addw	a5,a5,a3
    800046fa:	00f95963          	bge	s2,a5,8000470c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800046fe:	85a6                	mv	a1,s1
    80004700:	8526                	mv	a0,s1
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	dd0080e7          	jalr	-560(ra) # 800024d2 <sleep>
    8000470a:	bfe9                	j	800046e4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000470c:	0001f517          	auipc	a0,0x1f
    80004710:	23450513          	addi	a0,a0,564 # 80023940 <log>
    80004714:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004716:	ffffc097          	auipc	ra,0xffffc
    8000471a:	5d6080e7          	jalr	1494(ra) # 80000cec <release>
      break;
    }
  }
}
    8000471e:	60e2                	ld	ra,24(sp)
    80004720:	6442                	ld	s0,16(sp)
    80004722:	64a2                	ld	s1,8(sp)
    80004724:	6902                	ld	s2,0(sp)
    80004726:	6105                	addi	sp,sp,32
    80004728:	8082                	ret

000000008000472a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000472a:	7139                	addi	sp,sp,-64
    8000472c:	fc06                	sd	ra,56(sp)
    8000472e:	f822                	sd	s0,48(sp)
    80004730:	f426                	sd	s1,40(sp)
    80004732:	f04a                	sd	s2,32(sp)
    80004734:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004736:	0001f497          	auipc	s1,0x1f
    8000473a:	20a48493          	addi	s1,s1,522 # 80023940 <log>
    8000473e:	8526                	mv	a0,s1
    80004740:	ffffc097          	auipc	ra,0xffffc
    80004744:	4f8080e7          	jalr	1272(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    80004748:	509c                	lw	a5,32(s1)
    8000474a:	37fd                	addiw	a5,a5,-1
    8000474c:	0007891b          	sext.w	s2,a5
    80004750:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004752:	50dc                	lw	a5,36(s1)
    80004754:	e7b9                	bnez	a5,800047a2 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004756:	06091163          	bnez	s2,800047b8 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000475a:	0001f497          	auipc	s1,0x1f
    8000475e:	1e648493          	addi	s1,s1,486 # 80023940 <log>
    80004762:	4785                	li	a5,1
    80004764:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004766:	8526                	mv	a0,s1
    80004768:	ffffc097          	auipc	ra,0xffffc
    8000476c:	584080e7          	jalr	1412(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004770:	54dc                	lw	a5,44(s1)
    80004772:	06f04763          	bgtz	a5,800047e0 <end_op+0xb6>
    acquire(&log.lock);
    80004776:	0001f497          	auipc	s1,0x1f
    8000477a:	1ca48493          	addi	s1,s1,458 # 80023940 <log>
    8000477e:	8526                	mv	a0,s1
    80004780:	ffffc097          	auipc	ra,0xffffc
    80004784:	4b8080e7          	jalr	1208(ra) # 80000c38 <acquire>
    log.committing = 0;
    80004788:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000478c:	8526                	mv	a0,s1
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	da8080e7          	jalr	-600(ra) # 80002536 <wakeup>
    release(&log.lock);
    80004796:	8526                	mv	a0,s1
    80004798:	ffffc097          	auipc	ra,0xffffc
    8000479c:	554080e7          	jalr	1364(ra) # 80000cec <release>
}
    800047a0:	a815                	j	800047d4 <end_op+0xaa>
    800047a2:	ec4e                	sd	s3,24(sp)
    800047a4:	e852                	sd	s4,16(sp)
    800047a6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800047a8:	00004517          	auipc	a0,0x4
    800047ac:	e5850513          	addi	a0,a0,-424 # 80008600 <etext+0x600>
    800047b0:	ffffc097          	auipc	ra,0xffffc
    800047b4:	db0080e7          	jalr	-592(ra) # 80000560 <panic>
    wakeup(&log);
    800047b8:	0001f497          	auipc	s1,0x1f
    800047bc:	18848493          	addi	s1,s1,392 # 80023940 <log>
    800047c0:	8526                	mv	a0,s1
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	d74080e7          	jalr	-652(ra) # 80002536 <wakeup>
  release(&log.lock);
    800047ca:	8526                	mv	a0,s1
    800047cc:	ffffc097          	auipc	ra,0xffffc
    800047d0:	520080e7          	jalr	1312(ra) # 80000cec <release>
}
    800047d4:	70e2                	ld	ra,56(sp)
    800047d6:	7442                	ld	s0,48(sp)
    800047d8:	74a2                	ld	s1,40(sp)
    800047da:	7902                	ld	s2,32(sp)
    800047dc:	6121                	addi	sp,sp,64
    800047de:	8082                	ret
    800047e0:	ec4e                	sd	s3,24(sp)
    800047e2:	e852                	sd	s4,16(sp)
    800047e4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800047e6:	0001fa97          	auipc	s5,0x1f
    800047ea:	18aa8a93          	addi	s5,s5,394 # 80023970 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800047ee:	0001fa17          	auipc	s4,0x1f
    800047f2:	152a0a13          	addi	s4,s4,338 # 80023940 <log>
    800047f6:	018a2583          	lw	a1,24(s4)
    800047fa:	012585bb          	addw	a1,a1,s2
    800047fe:	2585                	addiw	a1,a1,1
    80004800:	028a2503          	lw	a0,40(s4)
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	caa080e7          	jalr	-854(ra) # 800034ae <bread>
    8000480c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000480e:	000aa583          	lw	a1,0(s5)
    80004812:	028a2503          	lw	a0,40(s4)
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	c98080e7          	jalr	-872(ra) # 800034ae <bread>
    8000481e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004820:	40000613          	li	a2,1024
    80004824:	05850593          	addi	a1,a0,88
    80004828:	05848513          	addi	a0,s1,88
    8000482c:	ffffc097          	auipc	ra,0xffffc
    80004830:	564080e7          	jalr	1380(ra) # 80000d90 <memmove>
    bwrite(to);  // write the log
    80004834:	8526                	mv	a0,s1
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	d6a080e7          	jalr	-662(ra) # 800035a0 <bwrite>
    brelse(from);
    8000483e:	854e                	mv	a0,s3
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	d9e080e7          	jalr	-610(ra) # 800035de <brelse>
    brelse(to);
    80004848:	8526                	mv	a0,s1
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	d94080e7          	jalr	-620(ra) # 800035de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004852:	2905                	addiw	s2,s2,1
    80004854:	0a91                	addi	s5,s5,4
    80004856:	02ca2783          	lw	a5,44(s4)
    8000485a:	f8f94ee3          	blt	s2,a5,800047f6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000485e:	00000097          	auipc	ra,0x0
    80004862:	c8c080e7          	jalr	-884(ra) # 800044ea <write_head>
    install_trans(0); // Now install writes to home locations
    80004866:	4501                	li	a0,0
    80004868:	00000097          	auipc	ra,0x0
    8000486c:	cec080e7          	jalr	-788(ra) # 80004554 <install_trans>
    log.lh.n = 0;
    80004870:	0001f797          	auipc	a5,0x1f
    80004874:	0e07ae23          	sw	zero,252(a5) # 8002396c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004878:	00000097          	auipc	ra,0x0
    8000487c:	c72080e7          	jalr	-910(ra) # 800044ea <write_head>
    80004880:	69e2                	ld	s3,24(sp)
    80004882:	6a42                	ld	s4,16(sp)
    80004884:	6aa2                	ld	s5,8(sp)
    80004886:	bdc5                	j	80004776 <end_op+0x4c>

0000000080004888 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004888:	1101                	addi	sp,sp,-32
    8000488a:	ec06                	sd	ra,24(sp)
    8000488c:	e822                	sd	s0,16(sp)
    8000488e:	e426                	sd	s1,8(sp)
    80004890:	e04a                	sd	s2,0(sp)
    80004892:	1000                	addi	s0,sp,32
    80004894:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004896:	0001f917          	auipc	s2,0x1f
    8000489a:	0aa90913          	addi	s2,s2,170 # 80023940 <log>
    8000489e:	854a                	mv	a0,s2
    800048a0:	ffffc097          	auipc	ra,0xffffc
    800048a4:	398080e7          	jalr	920(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800048a8:	02c92603          	lw	a2,44(s2)
    800048ac:	47f5                	li	a5,29
    800048ae:	06c7c563          	blt	a5,a2,80004918 <log_write+0x90>
    800048b2:	0001f797          	auipc	a5,0x1f
    800048b6:	0aa7a783          	lw	a5,170(a5) # 8002395c <log+0x1c>
    800048ba:	37fd                	addiw	a5,a5,-1
    800048bc:	04f65e63          	bge	a2,a5,80004918 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800048c0:	0001f797          	auipc	a5,0x1f
    800048c4:	0a07a783          	lw	a5,160(a5) # 80023960 <log+0x20>
    800048c8:	06f05063          	blez	a5,80004928 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800048cc:	4781                	li	a5,0
    800048ce:	06c05563          	blez	a2,80004938 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048d2:	44cc                	lw	a1,12(s1)
    800048d4:	0001f717          	auipc	a4,0x1f
    800048d8:	09c70713          	addi	a4,a4,156 # 80023970 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800048dc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048de:	4314                	lw	a3,0(a4)
    800048e0:	04b68c63          	beq	a3,a1,80004938 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800048e4:	2785                	addiw	a5,a5,1
    800048e6:	0711                	addi	a4,a4,4
    800048e8:	fef61be3          	bne	a2,a5,800048de <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800048ec:	0621                	addi	a2,a2,8
    800048ee:	060a                	slli	a2,a2,0x2
    800048f0:	0001f797          	auipc	a5,0x1f
    800048f4:	05078793          	addi	a5,a5,80 # 80023940 <log>
    800048f8:	97b2                	add	a5,a5,a2
    800048fa:	44d8                	lw	a4,12(s1)
    800048fc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800048fe:	8526                	mv	a0,s1
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	d7a080e7          	jalr	-646(ra) # 8000367a <bpin>
    log.lh.n++;
    80004908:	0001f717          	auipc	a4,0x1f
    8000490c:	03870713          	addi	a4,a4,56 # 80023940 <log>
    80004910:	575c                	lw	a5,44(a4)
    80004912:	2785                	addiw	a5,a5,1
    80004914:	d75c                	sw	a5,44(a4)
    80004916:	a82d                	j	80004950 <log_write+0xc8>
    panic("too big a transaction");
    80004918:	00004517          	auipc	a0,0x4
    8000491c:	cf850513          	addi	a0,a0,-776 # 80008610 <etext+0x610>
    80004920:	ffffc097          	auipc	ra,0xffffc
    80004924:	c40080e7          	jalr	-960(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004928:	00004517          	auipc	a0,0x4
    8000492c:	d0050513          	addi	a0,a0,-768 # 80008628 <etext+0x628>
    80004930:	ffffc097          	auipc	ra,0xffffc
    80004934:	c30080e7          	jalr	-976(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004938:	00878693          	addi	a3,a5,8
    8000493c:	068a                	slli	a3,a3,0x2
    8000493e:	0001f717          	auipc	a4,0x1f
    80004942:	00270713          	addi	a4,a4,2 # 80023940 <log>
    80004946:	9736                	add	a4,a4,a3
    80004948:	44d4                	lw	a3,12(s1)
    8000494a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000494c:	faf609e3          	beq	a2,a5,800048fe <log_write+0x76>
  }
  release(&log.lock);
    80004950:	0001f517          	auipc	a0,0x1f
    80004954:	ff050513          	addi	a0,a0,-16 # 80023940 <log>
    80004958:	ffffc097          	auipc	ra,0xffffc
    8000495c:	394080e7          	jalr	916(ra) # 80000cec <release>
}
    80004960:	60e2                	ld	ra,24(sp)
    80004962:	6442                	ld	s0,16(sp)
    80004964:	64a2                	ld	s1,8(sp)
    80004966:	6902                	ld	s2,0(sp)
    80004968:	6105                	addi	sp,sp,32
    8000496a:	8082                	ret

000000008000496c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000496c:	1101                	addi	sp,sp,-32
    8000496e:	ec06                	sd	ra,24(sp)
    80004970:	e822                	sd	s0,16(sp)
    80004972:	e426                	sd	s1,8(sp)
    80004974:	e04a                	sd	s2,0(sp)
    80004976:	1000                	addi	s0,sp,32
    80004978:	84aa                	mv	s1,a0
    8000497a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000497c:	00004597          	auipc	a1,0x4
    80004980:	ccc58593          	addi	a1,a1,-820 # 80008648 <etext+0x648>
    80004984:	0521                	addi	a0,a0,8
    80004986:	ffffc097          	auipc	ra,0xffffc
    8000498a:	222080e7          	jalr	546(ra) # 80000ba8 <initlock>
  lk->name = name;
    8000498e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004992:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004996:	0204a423          	sw	zero,40(s1)
}
    8000499a:	60e2                	ld	ra,24(sp)
    8000499c:	6442                	ld	s0,16(sp)
    8000499e:	64a2                	ld	s1,8(sp)
    800049a0:	6902                	ld	s2,0(sp)
    800049a2:	6105                	addi	sp,sp,32
    800049a4:	8082                	ret

00000000800049a6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800049a6:	1101                	addi	sp,sp,-32
    800049a8:	ec06                	sd	ra,24(sp)
    800049aa:	e822                	sd	s0,16(sp)
    800049ac:	e426                	sd	s1,8(sp)
    800049ae:	e04a                	sd	s2,0(sp)
    800049b0:	1000                	addi	s0,sp,32
    800049b2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049b4:	00850913          	addi	s2,a0,8
    800049b8:	854a                	mv	a0,s2
    800049ba:	ffffc097          	auipc	ra,0xffffc
    800049be:	27e080e7          	jalr	638(ra) # 80000c38 <acquire>
  while (lk->locked) {
    800049c2:	409c                	lw	a5,0(s1)
    800049c4:	cb89                	beqz	a5,800049d6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800049c6:	85ca                	mv	a1,s2
    800049c8:	8526                	mv	a0,s1
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	b08080e7          	jalr	-1272(ra) # 800024d2 <sleep>
  while (lk->locked) {
    800049d2:	409c                	lw	a5,0(s1)
    800049d4:	fbed                	bnez	a5,800049c6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800049d6:	4785                	li	a5,1
    800049d8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049da:	ffffd097          	auipc	ra,0xffffd
    800049de:	314080e7          	jalr	788(ra) # 80001cee <myproc>
    800049e2:	591c                	lw	a5,48(a0)
    800049e4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800049e6:	854a                	mv	a0,s2
    800049e8:	ffffc097          	auipc	ra,0xffffc
    800049ec:	304080e7          	jalr	772(ra) # 80000cec <release>
}
    800049f0:	60e2                	ld	ra,24(sp)
    800049f2:	6442                	ld	s0,16(sp)
    800049f4:	64a2                	ld	s1,8(sp)
    800049f6:	6902                	ld	s2,0(sp)
    800049f8:	6105                	addi	sp,sp,32
    800049fa:	8082                	ret

00000000800049fc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800049fc:	1101                	addi	sp,sp,-32
    800049fe:	ec06                	sd	ra,24(sp)
    80004a00:	e822                	sd	s0,16(sp)
    80004a02:	e426                	sd	s1,8(sp)
    80004a04:	e04a                	sd	s2,0(sp)
    80004a06:	1000                	addi	s0,sp,32
    80004a08:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a0a:	00850913          	addi	s2,a0,8
    80004a0e:	854a                	mv	a0,s2
    80004a10:	ffffc097          	auipc	ra,0xffffc
    80004a14:	228080e7          	jalr	552(ra) # 80000c38 <acquire>
  lk->locked = 0;
    80004a18:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a1c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a20:	8526                	mv	a0,s1
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	b14080e7          	jalr	-1260(ra) # 80002536 <wakeup>
  release(&lk->lk);
    80004a2a:	854a                	mv	a0,s2
    80004a2c:	ffffc097          	auipc	ra,0xffffc
    80004a30:	2c0080e7          	jalr	704(ra) # 80000cec <release>
}
    80004a34:	60e2                	ld	ra,24(sp)
    80004a36:	6442                	ld	s0,16(sp)
    80004a38:	64a2                	ld	s1,8(sp)
    80004a3a:	6902                	ld	s2,0(sp)
    80004a3c:	6105                	addi	sp,sp,32
    80004a3e:	8082                	ret

0000000080004a40 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a40:	7179                	addi	sp,sp,-48
    80004a42:	f406                	sd	ra,40(sp)
    80004a44:	f022                	sd	s0,32(sp)
    80004a46:	ec26                	sd	s1,24(sp)
    80004a48:	e84a                	sd	s2,16(sp)
    80004a4a:	1800                	addi	s0,sp,48
    80004a4c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a4e:	00850913          	addi	s2,a0,8
    80004a52:	854a                	mv	a0,s2
    80004a54:	ffffc097          	auipc	ra,0xffffc
    80004a58:	1e4080e7          	jalr	484(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a5c:	409c                	lw	a5,0(s1)
    80004a5e:	ef91                	bnez	a5,80004a7a <holdingsleep+0x3a>
    80004a60:	4481                	li	s1,0
  release(&lk->lk);
    80004a62:	854a                	mv	a0,s2
    80004a64:	ffffc097          	auipc	ra,0xffffc
    80004a68:	288080e7          	jalr	648(ra) # 80000cec <release>
  return r;
}
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	70a2                	ld	ra,40(sp)
    80004a70:	7402                	ld	s0,32(sp)
    80004a72:	64e2                	ld	s1,24(sp)
    80004a74:	6942                	ld	s2,16(sp)
    80004a76:	6145                	addi	sp,sp,48
    80004a78:	8082                	ret
    80004a7a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a7c:	0284a983          	lw	s3,40(s1)
    80004a80:	ffffd097          	auipc	ra,0xffffd
    80004a84:	26e080e7          	jalr	622(ra) # 80001cee <myproc>
    80004a88:	5904                	lw	s1,48(a0)
    80004a8a:	413484b3          	sub	s1,s1,s3
    80004a8e:	0014b493          	seqz	s1,s1
    80004a92:	69a2                	ld	s3,8(sp)
    80004a94:	b7f9                	j	80004a62 <holdingsleep+0x22>

0000000080004a96 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004a96:	1141                	addi	sp,sp,-16
    80004a98:	e406                	sd	ra,8(sp)
    80004a9a:	e022                	sd	s0,0(sp)
    80004a9c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a9e:	00004597          	auipc	a1,0x4
    80004aa2:	bba58593          	addi	a1,a1,-1094 # 80008658 <etext+0x658>
    80004aa6:	0001f517          	auipc	a0,0x1f
    80004aaa:	fe250513          	addi	a0,a0,-30 # 80023a88 <ftable>
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	0fa080e7          	jalr	250(ra) # 80000ba8 <initlock>
}
    80004ab6:	60a2                	ld	ra,8(sp)
    80004ab8:	6402                	ld	s0,0(sp)
    80004aba:	0141                	addi	sp,sp,16
    80004abc:	8082                	ret

0000000080004abe <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004abe:	1101                	addi	sp,sp,-32
    80004ac0:	ec06                	sd	ra,24(sp)
    80004ac2:	e822                	sd	s0,16(sp)
    80004ac4:	e426                	sd	s1,8(sp)
    80004ac6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004ac8:	0001f517          	auipc	a0,0x1f
    80004acc:	fc050513          	addi	a0,a0,-64 # 80023a88 <ftable>
    80004ad0:	ffffc097          	auipc	ra,0xffffc
    80004ad4:	168080e7          	jalr	360(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ad8:	0001f497          	auipc	s1,0x1f
    80004adc:	fc848493          	addi	s1,s1,-56 # 80023aa0 <ftable+0x18>
    80004ae0:	00020717          	auipc	a4,0x20
    80004ae4:	f6070713          	addi	a4,a4,-160 # 80024a40 <disk>
    if(f->ref == 0){
    80004ae8:	40dc                	lw	a5,4(s1)
    80004aea:	cf99                	beqz	a5,80004b08 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004aec:	02848493          	addi	s1,s1,40
    80004af0:	fee49ce3          	bne	s1,a4,80004ae8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004af4:	0001f517          	auipc	a0,0x1f
    80004af8:	f9450513          	addi	a0,a0,-108 # 80023a88 <ftable>
    80004afc:	ffffc097          	auipc	ra,0xffffc
    80004b00:	1f0080e7          	jalr	496(ra) # 80000cec <release>
  return 0;
    80004b04:	4481                	li	s1,0
    80004b06:	a819                	j	80004b1c <filealloc+0x5e>
      f->ref = 1;
    80004b08:	4785                	li	a5,1
    80004b0a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b0c:	0001f517          	auipc	a0,0x1f
    80004b10:	f7c50513          	addi	a0,a0,-132 # 80023a88 <ftable>
    80004b14:	ffffc097          	auipc	ra,0xffffc
    80004b18:	1d8080e7          	jalr	472(ra) # 80000cec <release>
}
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	60e2                	ld	ra,24(sp)
    80004b20:	6442                	ld	s0,16(sp)
    80004b22:	64a2                	ld	s1,8(sp)
    80004b24:	6105                	addi	sp,sp,32
    80004b26:	8082                	ret

0000000080004b28 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b28:	1101                	addi	sp,sp,-32
    80004b2a:	ec06                	sd	ra,24(sp)
    80004b2c:	e822                	sd	s0,16(sp)
    80004b2e:	e426                	sd	s1,8(sp)
    80004b30:	1000                	addi	s0,sp,32
    80004b32:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b34:	0001f517          	auipc	a0,0x1f
    80004b38:	f5450513          	addi	a0,a0,-172 # 80023a88 <ftable>
    80004b3c:	ffffc097          	auipc	ra,0xffffc
    80004b40:	0fc080e7          	jalr	252(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004b44:	40dc                	lw	a5,4(s1)
    80004b46:	02f05263          	blez	a5,80004b6a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b4a:	2785                	addiw	a5,a5,1
    80004b4c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b4e:	0001f517          	auipc	a0,0x1f
    80004b52:	f3a50513          	addi	a0,a0,-198 # 80023a88 <ftable>
    80004b56:	ffffc097          	auipc	ra,0xffffc
    80004b5a:	196080e7          	jalr	406(ra) # 80000cec <release>
  return f;
}
    80004b5e:	8526                	mv	a0,s1
    80004b60:	60e2                	ld	ra,24(sp)
    80004b62:	6442                	ld	s0,16(sp)
    80004b64:	64a2                	ld	s1,8(sp)
    80004b66:	6105                	addi	sp,sp,32
    80004b68:	8082                	ret
    panic("filedup");
    80004b6a:	00004517          	auipc	a0,0x4
    80004b6e:	af650513          	addi	a0,a0,-1290 # 80008660 <etext+0x660>
    80004b72:	ffffc097          	auipc	ra,0xffffc
    80004b76:	9ee080e7          	jalr	-1554(ra) # 80000560 <panic>

0000000080004b7a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b7a:	7139                	addi	sp,sp,-64
    80004b7c:	fc06                	sd	ra,56(sp)
    80004b7e:	f822                	sd	s0,48(sp)
    80004b80:	f426                	sd	s1,40(sp)
    80004b82:	0080                	addi	s0,sp,64
    80004b84:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b86:	0001f517          	auipc	a0,0x1f
    80004b8a:	f0250513          	addi	a0,a0,-254 # 80023a88 <ftable>
    80004b8e:	ffffc097          	auipc	ra,0xffffc
    80004b92:	0aa080e7          	jalr	170(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004b96:	40dc                	lw	a5,4(s1)
    80004b98:	04f05c63          	blez	a5,80004bf0 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004b9c:	37fd                	addiw	a5,a5,-1
    80004b9e:	0007871b          	sext.w	a4,a5
    80004ba2:	c0dc                	sw	a5,4(s1)
    80004ba4:	06e04263          	bgtz	a4,80004c08 <fileclose+0x8e>
    80004ba8:	f04a                	sd	s2,32(sp)
    80004baa:	ec4e                	sd	s3,24(sp)
    80004bac:	e852                	sd	s4,16(sp)
    80004bae:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004bb0:	0004a903          	lw	s2,0(s1)
    80004bb4:	0094ca83          	lbu	s5,9(s1)
    80004bb8:	0104ba03          	ld	s4,16(s1)
    80004bbc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004bc0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004bc4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004bc8:	0001f517          	auipc	a0,0x1f
    80004bcc:	ec050513          	addi	a0,a0,-320 # 80023a88 <ftable>
    80004bd0:	ffffc097          	auipc	ra,0xffffc
    80004bd4:	11c080e7          	jalr	284(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    80004bd8:	4785                	li	a5,1
    80004bda:	04f90463          	beq	s2,a5,80004c22 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004bde:	3979                	addiw	s2,s2,-2
    80004be0:	4785                	li	a5,1
    80004be2:	0527fb63          	bgeu	a5,s2,80004c38 <fileclose+0xbe>
    80004be6:	7902                	ld	s2,32(sp)
    80004be8:	69e2                	ld	s3,24(sp)
    80004bea:	6a42                	ld	s4,16(sp)
    80004bec:	6aa2                	ld	s5,8(sp)
    80004bee:	a02d                	j	80004c18 <fileclose+0x9e>
    80004bf0:	f04a                	sd	s2,32(sp)
    80004bf2:	ec4e                	sd	s3,24(sp)
    80004bf4:	e852                	sd	s4,16(sp)
    80004bf6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004bf8:	00004517          	auipc	a0,0x4
    80004bfc:	a7050513          	addi	a0,a0,-1424 # 80008668 <etext+0x668>
    80004c00:	ffffc097          	auipc	ra,0xffffc
    80004c04:	960080e7          	jalr	-1696(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004c08:	0001f517          	auipc	a0,0x1f
    80004c0c:	e8050513          	addi	a0,a0,-384 # 80023a88 <ftable>
    80004c10:	ffffc097          	auipc	ra,0xffffc
    80004c14:	0dc080e7          	jalr	220(ra) # 80000cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004c18:	70e2                	ld	ra,56(sp)
    80004c1a:	7442                	ld	s0,48(sp)
    80004c1c:	74a2                	ld	s1,40(sp)
    80004c1e:	6121                	addi	sp,sp,64
    80004c20:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c22:	85d6                	mv	a1,s5
    80004c24:	8552                	mv	a0,s4
    80004c26:	00000097          	auipc	ra,0x0
    80004c2a:	3a2080e7          	jalr	930(ra) # 80004fc8 <pipeclose>
    80004c2e:	7902                	ld	s2,32(sp)
    80004c30:	69e2                	ld	s3,24(sp)
    80004c32:	6a42                	ld	s4,16(sp)
    80004c34:	6aa2                	ld	s5,8(sp)
    80004c36:	b7cd                	j	80004c18 <fileclose+0x9e>
    begin_op();
    80004c38:	00000097          	auipc	ra,0x0
    80004c3c:	a78080e7          	jalr	-1416(ra) # 800046b0 <begin_op>
    iput(ff.ip);
    80004c40:	854e                	mv	a0,s3
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	25e080e7          	jalr	606(ra) # 80003ea0 <iput>
    end_op();
    80004c4a:	00000097          	auipc	ra,0x0
    80004c4e:	ae0080e7          	jalr	-1312(ra) # 8000472a <end_op>
    80004c52:	7902                	ld	s2,32(sp)
    80004c54:	69e2                	ld	s3,24(sp)
    80004c56:	6a42                	ld	s4,16(sp)
    80004c58:	6aa2                	ld	s5,8(sp)
    80004c5a:	bf7d                	j	80004c18 <fileclose+0x9e>

0000000080004c5c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c5c:	715d                	addi	sp,sp,-80
    80004c5e:	e486                	sd	ra,72(sp)
    80004c60:	e0a2                	sd	s0,64(sp)
    80004c62:	fc26                	sd	s1,56(sp)
    80004c64:	f44e                	sd	s3,40(sp)
    80004c66:	0880                	addi	s0,sp,80
    80004c68:	84aa                	mv	s1,a0
    80004c6a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c6c:	ffffd097          	auipc	ra,0xffffd
    80004c70:	082080e7          	jalr	130(ra) # 80001cee <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c74:	409c                	lw	a5,0(s1)
    80004c76:	37f9                	addiw	a5,a5,-2
    80004c78:	4705                	li	a4,1
    80004c7a:	04f76863          	bltu	a4,a5,80004cca <filestat+0x6e>
    80004c7e:	f84a                	sd	s2,48(sp)
    80004c80:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c82:	6c88                	ld	a0,24(s1)
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	05e080e7          	jalr	94(ra) # 80003ce2 <ilock>
    stati(f->ip, &st);
    80004c8c:	fb840593          	addi	a1,s0,-72
    80004c90:	6c88                	ld	a0,24(s1)
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	2de080e7          	jalr	734(ra) # 80003f70 <stati>
    iunlock(f->ip);
    80004c9a:	6c88                	ld	a0,24(s1)
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	10c080e7          	jalr	268(ra) # 80003da8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004ca4:	46e1                	li	a3,24
    80004ca6:	fb840613          	addi	a2,s0,-72
    80004caa:	85ce                	mv	a1,s3
    80004cac:	05893503          	ld	a0,88(s2)
    80004cb0:	ffffd097          	auipc	ra,0xffffd
    80004cb4:	a32080e7          	jalr	-1486(ra) # 800016e2 <copyout>
    80004cb8:	41f5551b          	sraiw	a0,a0,0x1f
    80004cbc:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004cbe:	60a6                	ld	ra,72(sp)
    80004cc0:	6406                	ld	s0,64(sp)
    80004cc2:	74e2                	ld	s1,56(sp)
    80004cc4:	79a2                	ld	s3,40(sp)
    80004cc6:	6161                	addi	sp,sp,80
    80004cc8:	8082                	ret
  return -1;
    80004cca:	557d                	li	a0,-1
    80004ccc:	bfcd                	j	80004cbe <filestat+0x62>

0000000080004cce <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004cce:	7179                	addi	sp,sp,-48
    80004cd0:	f406                	sd	ra,40(sp)
    80004cd2:	f022                	sd	s0,32(sp)
    80004cd4:	e84a                	sd	s2,16(sp)
    80004cd6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004cd8:	00854783          	lbu	a5,8(a0)
    80004cdc:	cbc5                	beqz	a5,80004d8c <fileread+0xbe>
    80004cde:	ec26                	sd	s1,24(sp)
    80004ce0:	e44e                	sd	s3,8(sp)
    80004ce2:	84aa                	mv	s1,a0
    80004ce4:	89ae                	mv	s3,a1
    80004ce6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ce8:	411c                	lw	a5,0(a0)
    80004cea:	4705                	li	a4,1
    80004cec:	04e78963          	beq	a5,a4,80004d3e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cf0:	470d                	li	a4,3
    80004cf2:	04e78f63          	beq	a5,a4,80004d50 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004cf6:	4709                	li	a4,2
    80004cf8:	08e79263          	bne	a5,a4,80004d7c <fileread+0xae>
    ilock(f->ip);
    80004cfc:	6d08                	ld	a0,24(a0)
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	fe4080e7          	jalr	-28(ra) # 80003ce2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d06:	874a                	mv	a4,s2
    80004d08:	5094                	lw	a3,32(s1)
    80004d0a:	864e                	mv	a2,s3
    80004d0c:	4585                	li	a1,1
    80004d0e:	6c88                	ld	a0,24(s1)
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	28a080e7          	jalr	650(ra) # 80003f9a <readi>
    80004d18:	892a                	mv	s2,a0
    80004d1a:	00a05563          	blez	a0,80004d24 <fileread+0x56>
      f->off += r;
    80004d1e:	509c                	lw	a5,32(s1)
    80004d20:	9fa9                	addw	a5,a5,a0
    80004d22:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d24:	6c88                	ld	a0,24(s1)
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	082080e7          	jalr	130(ra) # 80003da8 <iunlock>
    80004d2e:	64e2                	ld	s1,24(sp)
    80004d30:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004d32:	854a                	mv	a0,s2
    80004d34:	70a2                	ld	ra,40(sp)
    80004d36:	7402                	ld	s0,32(sp)
    80004d38:	6942                	ld	s2,16(sp)
    80004d3a:	6145                	addi	sp,sp,48
    80004d3c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d3e:	6908                	ld	a0,16(a0)
    80004d40:	00000097          	auipc	ra,0x0
    80004d44:	400080e7          	jalr	1024(ra) # 80005140 <piperead>
    80004d48:	892a                	mv	s2,a0
    80004d4a:	64e2                	ld	s1,24(sp)
    80004d4c:	69a2                	ld	s3,8(sp)
    80004d4e:	b7d5                	j	80004d32 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d50:	02451783          	lh	a5,36(a0)
    80004d54:	03079693          	slli	a3,a5,0x30
    80004d58:	92c1                	srli	a3,a3,0x30
    80004d5a:	4725                	li	a4,9
    80004d5c:	02d76a63          	bltu	a4,a3,80004d90 <fileread+0xc2>
    80004d60:	0792                	slli	a5,a5,0x4
    80004d62:	0001f717          	auipc	a4,0x1f
    80004d66:	c8670713          	addi	a4,a4,-890 # 800239e8 <devsw>
    80004d6a:	97ba                	add	a5,a5,a4
    80004d6c:	639c                	ld	a5,0(a5)
    80004d6e:	c78d                	beqz	a5,80004d98 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004d70:	4505                	li	a0,1
    80004d72:	9782                	jalr	a5
    80004d74:	892a                	mv	s2,a0
    80004d76:	64e2                	ld	s1,24(sp)
    80004d78:	69a2                	ld	s3,8(sp)
    80004d7a:	bf65                	j	80004d32 <fileread+0x64>
    panic("fileread");
    80004d7c:	00004517          	auipc	a0,0x4
    80004d80:	8fc50513          	addi	a0,a0,-1796 # 80008678 <etext+0x678>
    80004d84:	ffffb097          	auipc	ra,0xffffb
    80004d88:	7dc080e7          	jalr	2012(ra) # 80000560 <panic>
    return -1;
    80004d8c:	597d                	li	s2,-1
    80004d8e:	b755                	j	80004d32 <fileread+0x64>
      return -1;
    80004d90:	597d                	li	s2,-1
    80004d92:	64e2                	ld	s1,24(sp)
    80004d94:	69a2                	ld	s3,8(sp)
    80004d96:	bf71                	j	80004d32 <fileread+0x64>
    80004d98:	597d                	li	s2,-1
    80004d9a:	64e2                	ld	s1,24(sp)
    80004d9c:	69a2                	ld	s3,8(sp)
    80004d9e:	bf51                	j	80004d32 <fileread+0x64>

0000000080004da0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004da0:	00954783          	lbu	a5,9(a0)
    80004da4:	12078963          	beqz	a5,80004ed6 <filewrite+0x136>
{
    80004da8:	715d                	addi	sp,sp,-80
    80004daa:	e486                	sd	ra,72(sp)
    80004dac:	e0a2                	sd	s0,64(sp)
    80004dae:	f84a                	sd	s2,48(sp)
    80004db0:	f052                	sd	s4,32(sp)
    80004db2:	e85a                	sd	s6,16(sp)
    80004db4:	0880                	addi	s0,sp,80
    80004db6:	892a                	mv	s2,a0
    80004db8:	8b2e                	mv	s6,a1
    80004dba:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004dbc:	411c                	lw	a5,0(a0)
    80004dbe:	4705                	li	a4,1
    80004dc0:	02e78763          	beq	a5,a4,80004dee <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004dc4:	470d                	li	a4,3
    80004dc6:	02e78a63          	beq	a5,a4,80004dfa <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004dca:	4709                	li	a4,2
    80004dcc:	0ee79863          	bne	a5,a4,80004ebc <filewrite+0x11c>
    80004dd0:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004dd2:	0cc05463          	blez	a2,80004e9a <filewrite+0xfa>
    80004dd6:	fc26                	sd	s1,56(sp)
    80004dd8:	ec56                	sd	s5,24(sp)
    80004dda:	e45e                	sd	s7,8(sp)
    80004ddc:	e062                	sd	s8,0(sp)
    int i = 0;
    80004dde:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004de0:	6b85                	lui	s7,0x1
    80004de2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004de6:	6c05                	lui	s8,0x1
    80004de8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004dec:	a851                	j	80004e80 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004dee:	6908                	ld	a0,16(a0)
    80004df0:	00000097          	auipc	ra,0x0
    80004df4:	248080e7          	jalr	584(ra) # 80005038 <pipewrite>
    80004df8:	a85d                	j	80004eae <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004dfa:	02451783          	lh	a5,36(a0)
    80004dfe:	03079693          	slli	a3,a5,0x30
    80004e02:	92c1                	srli	a3,a3,0x30
    80004e04:	4725                	li	a4,9
    80004e06:	0cd76a63          	bltu	a4,a3,80004eda <filewrite+0x13a>
    80004e0a:	0792                	slli	a5,a5,0x4
    80004e0c:	0001f717          	auipc	a4,0x1f
    80004e10:	bdc70713          	addi	a4,a4,-1060 # 800239e8 <devsw>
    80004e14:	97ba                	add	a5,a5,a4
    80004e16:	679c                	ld	a5,8(a5)
    80004e18:	c3f9                	beqz	a5,80004ede <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004e1a:	4505                	li	a0,1
    80004e1c:	9782                	jalr	a5
    80004e1e:	a841                	j	80004eae <filewrite+0x10e>
      if(n1 > max)
    80004e20:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004e24:	00000097          	auipc	ra,0x0
    80004e28:	88c080e7          	jalr	-1908(ra) # 800046b0 <begin_op>
      ilock(f->ip);
    80004e2c:	01893503          	ld	a0,24(s2)
    80004e30:	fffff097          	auipc	ra,0xfffff
    80004e34:	eb2080e7          	jalr	-334(ra) # 80003ce2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e38:	8756                	mv	a4,s5
    80004e3a:	02092683          	lw	a3,32(s2)
    80004e3e:	01698633          	add	a2,s3,s6
    80004e42:	4585                	li	a1,1
    80004e44:	01893503          	ld	a0,24(s2)
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	262080e7          	jalr	610(ra) # 800040aa <writei>
    80004e50:	84aa                	mv	s1,a0
    80004e52:	00a05763          	blez	a0,80004e60 <filewrite+0xc0>
        f->off += r;
    80004e56:	02092783          	lw	a5,32(s2)
    80004e5a:	9fa9                	addw	a5,a5,a0
    80004e5c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e60:	01893503          	ld	a0,24(s2)
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	f44080e7          	jalr	-188(ra) # 80003da8 <iunlock>
      end_op();
    80004e6c:	00000097          	auipc	ra,0x0
    80004e70:	8be080e7          	jalr	-1858(ra) # 8000472a <end_op>

      if(r != n1){
    80004e74:	029a9563          	bne	s5,s1,80004e9e <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004e78:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004e7c:	0149da63          	bge	s3,s4,80004e90 <filewrite+0xf0>
      int n1 = n - i;
    80004e80:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004e84:	0004879b          	sext.w	a5,s1
    80004e88:	f8fbdce3          	bge	s7,a5,80004e20 <filewrite+0x80>
    80004e8c:	84e2                	mv	s1,s8
    80004e8e:	bf49                	j	80004e20 <filewrite+0x80>
    80004e90:	74e2                	ld	s1,56(sp)
    80004e92:	6ae2                	ld	s5,24(sp)
    80004e94:	6ba2                	ld	s7,8(sp)
    80004e96:	6c02                	ld	s8,0(sp)
    80004e98:	a039                	j	80004ea6 <filewrite+0x106>
    int i = 0;
    80004e9a:	4981                	li	s3,0
    80004e9c:	a029                	j	80004ea6 <filewrite+0x106>
    80004e9e:	74e2                	ld	s1,56(sp)
    80004ea0:	6ae2                	ld	s5,24(sp)
    80004ea2:	6ba2                	ld	s7,8(sp)
    80004ea4:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004ea6:	033a1e63          	bne	s4,s3,80004ee2 <filewrite+0x142>
    80004eaa:	8552                	mv	a0,s4
    80004eac:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004eae:	60a6                	ld	ra,72(sp)
    80004eb0:	6406                	ld	s0,64(sp)
    80004eb2:	7942                	ld	s2,48(sp)
    80004eb4:	7a02                	ld	s4,32(sp)
    80004eb6:	6b42                	ld	s6,16(sp)
    80004eb8:	6161                	addi	sp,sp,80
    80004eba:	8082                	ret
    80004ebc:	fc26                	sd	s1,56(sp)
    80004ebe:	f44e                	sd	s3,40(sp)
    80004ec0:	ec56                	sd	s5,24(sp)
    80004ec2:	e45e                	sd	s7,8(sp)
    80004ec4:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004ec6:	00003517          	auipc	a0,0x3
    80004eca:	7c250513          	addi	a0,a0,1986 # 80008688 <etext+0x688>
    80004ece:	ffffb097          	auipc	ra,0xffffb
    80004ed2:	692080e7          	jalr	1682(ra) # 80000560 <panic>
    return -1;
    80004ed6:	557d                	li	a0,-1
}
    80004ed8:	8082                	ret
      return -1;
    80004eda:	557d                	li	a0,-1
    80004edc:	bfc9                	j	80004eae <filewrite+0x10e>
    80004ede:	557d                	li	a0,-1
    80004ee0:	b7f9                	j	80004eae <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004ee2:	557d                	li	a0,-1
    80004ee4:	79a2                	ld	s3,40(sp)
    80004ee6:	b7e1                	j	80004eae <filewrite+0x10e>

0000000080004ee8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004ee8:	7179                	addi	sp,sp,-48
    80004eea:	f406                	sd	ra,40(sp)
    80004eec:	f022                	sd	s0,32(sp)
    80004eee:	ec26                	sd	s1,24(sp)
    80004ef0:	e052                	sd	s4,0(sp)
    80004ef2:	1800                	addi	s0,sp,48
    80004ef4:	84aa                	mv	s1,a0
    80004ef6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004ef8:	0005b023          	sd	zero,0(a1)
    80004efc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f00:	00000097          	auipc	ra,0x0
    80004f04:	bbe080e7          	jalr	-1090(ra) # 80004abe <filealloc>
    80004f08:	e088                	sd	a0,0(s1)
    80004f0a:	cd49                	beqz	a0,80004fa4 <pipealloc+0xbc>
    80004f0c:	00000097          	auipc	ra,0x0
    80004f10:	bb2080e7          	jalr	-1102(ra) # 80004abe <filealloc>
    80004f14:	00aa3023          	sd	a0,0(s4)
    80004f18:	c141                	beqz	a0,80004f98 <pipealloc+0xb0>
    80004f1a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f1c:	ffffc097          	auipc	ra,0xffffc
    80004f20:	c2c080e7          	jalr	-980(ra) # 80000b48 <kalloc>
    80004f24:	892a                	mv	s2,a0
    80004f26:	c13d                	beqz	a0,80004f8c <pipealloc+0xa4>
    80004f28:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004f2a:	4985                	li	s3,1
    80004f2c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f30:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f34:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f38:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f3c:	00003597          	auipc	a1,0x3
    80004f40:	75c58593          	addi	a1,a1,1884 # 80008698 <etext+0x698>
    80004f44:	ffffc097          	auipc	ra,0xffffc
    80004f48:	c64080e7          	jalr	-924(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    80004f4c:	609c                	ld	a5,0(s1)
    80004f4e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f52:	609c                	ld	a5,0(s1)
    80004f54:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f58:	609c                	ld	a5,0(s1)
    80004f5a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f5e:	609c                	ld	a5,0(s1)
    80004f60:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f64:	000a3783          	ld	a5,0(s4)
    80004f68:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f6c:	000a3783          	ld	a5,0(s4)
    80004f70:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f74:	000a3783          	ld	a5,0(s4)
    80004f78:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f7c:	000a3783          	ld	a5,0(s4)
    80004f80:	0127b823          	sd	s2,16(a5)
  return 0;
    80004f84:	4501                	li	a0,0
    80004f86:	6942                	ld	s2,16(sp)
    80004f88:	69a2                	ld	s3,8(sp)
    80004f8a:	a03d                	j	80004fb8 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004f8c:	6088                	ld	a0,0(s1)
    80004f8e:	c119                	beqz	a0,80004f94 <pipealloc+0xac>
    80004f90:	6942                	ld	s2,16(sp)
    80004f92:	a029                	j	80004f9c <pipealloc+0xb4>
    80004f94:	6942                	ld	s2,16(sp)
    80004f96:	a039                	j	80004fa4 <pipealloc+0xbc>
    80004f98:	6088                	ld	a0,0(s1)
    80004f9a:	c50d                	beqz	a0,80004fc4 <pipealloc+0xdc>
    fileclose(*f0);
    80004f9c:	00000097          	auipc	ra,0x0
    80004fa0:	bde080e7          	jalr	-1058(ra) # 80004b7a <fileclose>
  if(*f1)
    80004fa4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004fa8:	557d                	li	a0,-1
  if(*f1)
    80004faa:	c799                	beqz	a5,80004fb8 <pipealloc+0xd0>
    fileclose(*f1);
    80004fac:	853e                	mv	a0,a5
    80004fae:	00000097          	auipc	ra,0x0
    80004fb2:	bcc080e7          	jalr	-1076(ra) # 80004b7a <fileclose>
  return -1;
    80004fb6:	557d                	li	a0,-1
}
    80004fb8:	70a2                	ld	ra,40(sp)
    80004fba:	7402                	ld	s0,32(sp)
    80004fbc:	64e2                	ld	s1,24(sp)
    80004fbe:	6a02                	ld	s4,0(sp)
    80004fc0:	6145                	addi	sp,sp,48
    80004fc2:	8082                	ret
  return -1;
    80004fc4:	557d                	li	a0,-1
    80004fc6:	bfcd                	j	80004fb8 <pipealloc+0xd0>

0000000080004fc8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004fc8:	1101                	addi	sp,sp,-32
    80004fca:	ec06                	sd	ra,24(sp)
    80004fcc:	e822                	sd	s0,16(sp)
    80004fce:	e426                	sd	s1,8(sp)
    80004fd0:	e04a                	sd	s2,0(sp)
    80004fd2:	1000                	addi	s0,sp,32
    80004fd4:	84aa                	mv	s1,a0
    80004fd6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004fd8:	ffffc097          	auipc	ra,0xffffc
    80004fdc:	c60080e7          	jalr	-928(ra) # 80000c38 <acquire>
  if(writable){
    80004fe0:	02090d63          	beqz	s2,8000501a <pipeclose+0x52>
    pi->writeopen = 0;
    80004fe4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004fe8:	21848513          	addi	a0,s1,536
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	54a080e7          	jalr	1354(ra) # 80002536 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004ff4:	2204b783          	ld	a5,544(s1)
    80004ff8:	eb95                	bnez	a5,8000502c <pipeclose+0x64>
    release(&pi->lock);
    80004ffa:	8526                	mv	a0,s1
    80004ffc:	ffffc097          	auipc	ra,0xffffc
    80005000:	cf0080e7          	jalr	-784(ra) # 80000cec <release>
    kfree((char*)pi);
    80005004:	8526                	mv	a0,s1
    80005006:	ffffc097          	auipc	ra,0xffffc
    8000500a:	a44080e7          	jalr	-1468(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    8000500e:	60e2                	ld	ra,24(sp)
    80005010:	6442                	ld	s0,16(sp)
    80005012:	64a2                	ld	s1,8(sp)
    80005014:	6902                	ld	s2,0(sp)
    80005016:	6105                	addi	sp,sp,32
    80005018:	8082                	ret
    pi->readopen = 0;
    8000501a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000501e:	21c48513          	addi	a0,s1,540
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	514080e7          	jalr	1300(ra) # 80002536 <wakeup>
    8000502a:	b7e9                	j	80004ff4 <pipeclose+0x2c>
    release(&pi->lock);
    8000502c:	8526                	mv	a0,s1
    8000502e:	ffffc097          	auipc	ra,0xffffc
    80005032:	cbe080e7          	jalr	-834(ra) # 80000cec <release>
}
    80005036:	bfe1                	j	8000500e <pipeclose+0x46>

0000000080005038 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005038:	711d                	addi	sp,sp,-96
    8000503a:	ec86                	sd	ra,88(sp)
    8000503c:	e8a2                	sd	s0,80(sp)
    8000503e:	e4a6                	sd	s1,72(sp)
    80005040:	e0ca                	sd	s2,64(sp)
    80005042:	fc4e                	sd	s3,56(sp)
    80005044:	f852                	sd	s4,48(sp)
    80005046:	f456                	sd	s5,40(sp)
    80005048:	1080                	addi	s0,sp,96
    8000504a:	84aa                	mv	s1,a0
    8000504c:	8aae                	mv	s5,a1
    8000504e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005050:	ffffd097          	auipc	ra,0xffffd
    80005054:	c9e080e7          	jalr	-866(ra) # 80001cee <myproc>
    80005058:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000505a:	8526                	mv	a0,s1
    8000505c:	ffffc097          	auipc	ra,0xffffc
    80005060:	bdc080e7          	jalr	-1060(ra) # 80000c38 <acquire>
  while(i < n){
    80005064:	0d405863          	blez	s4,80005134 <pipewrite+0xfc>
    80005068:	f05a                	sd	s6,32(sp)
    8000506a:	ec5e                	sd	s7,24(sp)
    8000506c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000506e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005070:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005072:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005076:	21c48b93          	addi	s7,s1,540
    8000507a:	a089                	j	800050bc <pipewrite+0x84>
      release(&pi->lock);
    8000507c:	8526                	mv	a0,s1
    8000507e:	ffffc097          	auipc	ra,0xffffc
    80005082:	c6e080e7          	jalr	-914(ra) # 80000cec <release>
      return -1;
    80005086:	597d                	li	s2,-1
    80005088:	7b02                	ld	s6,32(sp)
    8000508a:	6be2                	ld	s7,24(sp)
    8000508c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000508e:	854a                	mv	a0,s2
    80005090:	60e6                	ld	ra,88(sp)
    80005092:	6446                	ld	s0,80(sp)
    80005094:	64a6                	ld	s1,72(sp)
    80005096:	6906                	ld	s2,64(sp)
    80005098:	79e2                	ld	s3,56(sp)
    8000509a:	7a42                	ld	s4,48(sp)
    8000509c:	7aa2                	ld	s5,40(sp)
    8000509e:	6125                	addi	sp,sp,96
    800050a0:	8082                	ret
      wakeup(&pi->nread);
    800050a2:	8562                	mv	a0,s8
    800050a4:	ffffd097          	auipc	ra,0xffffd
    800050a8:	492080e7          	jalr	1170(ra) # 80002536 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050ac:	85a6                	mv	a1,s1
    800050ae:	855e                	mv	a0,s7
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	422080e7          	jalr	1058(ra) # 800024d2 <sleep>
  while(i < n){
    800050b8:	05495f63          	bge	s2,s4,80005116 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    800050bc:	2204a783          	lw	a5,544(s1)
    800050c0:	dfd5                	beqz	a5,8000507c <pipewrite+0x44>
    800050c2:	854e                	mv	a0,s3
    800050c4:	ffffd097          	auipc	ra,0xffffd
    800050c8:	6b6080e7          	jalr	1718(ra) # 8000277a <killed>
    800050cc:	f945                	bnez	a0,8000507c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800050ce:	2184a783          	lw	a5,536(s1)
    800050d2:	21c4a703          	lw	a4,540(s1)
    800050d6:	2007879b          	addiw	a5,a5,512
    800050da:	fcf704e3          	beq	a4,a5,800050a2 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050de:	4685                	li	a3,1
    800050e0:	01590633          	add	a2,s2,s5
    800050e4:	faf40593          	addi	a1,s0,-81
    800050e8:	0589b503          	ld	a0,88(s3)
    800050ec:	ffffc097          	auipc	ra,0xffffc
    800050f0:	682080e7          	jalr	1666(ra) # 8000176e <copyin>
    800050f4:	05650263          	beq	a0,s6,80005138 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800050f8:	21c4a783          	lw	a5,540(s1)
    800050fc:	0017871b          	addiw	a4,a5,1
    80005100:	20e4ae23          	sw	a4,540(s1)
    80005104:	1ff7f793          	andi	a5,a5,511
    80005108:	97a6                	add	a5,a5,s1
    8000510a:	faf44703          	lbu	a4,-81(s0)
    8000510e:	00e78c23          	sb	a4,24(a5)
      i++;
    80005112:	2905                	addiw	s2,s2,1
    80005114:	b755                	j	800050b8 <pipewrite+0x80>
    80005116:	7b02                	ld	s6,32(sp)
    80005118:	6be2                	ld	s7,24(sp)
    8000511a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000511c:	21848513          	addi	a0,s1,536
    80005120:	ffffd097          	auipc	ra,0xffffd
    80005124:	416080e7          	jalr	1046(ra) # 80002536 <wakeup>
  release(&pi->lock);
    80005128:	8526                	mv	a0,s1
    8000512a:	ffffc097          	auipc	ra,0xffffc
    8000512e:	bc2080e7          	jalr	-1086(ra) # 80000cec <release>
  return i;
    80005132:	bfb1                	j	8000508e <pipewrite+0x56>
  int i = 0;
    80005134:	4901                	li	s2,0
    80005136:	b7dd                	j	8000511c <pipewrite+0xe4>
    80005138:	7b02                	ld	s6,32(sp)
    8000513a:	6be2                	ld	s7,24(sp)
    8000513c:	6c42                	ld	s8,16(sp)
    8000513e:	bff9                	j	8000511c <pipewrite+0xe4>

0000000080005140 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005140:	715d                	addi	sp,sp,-80
    80005142:	e486                	sd	ra,72(sp)
    80005144:	e0a2                	sd	s0,64(sp)
    80005146:	fc26                	sd	s1,56(sp)
    80005148:	f84a                	sd	s2,48(sp)
    8000514a:	f44e                	sd	s3,40(sp)
    8000514c:	f052                	sd	s4,32(sp)
    8000514e:	ec56                	sd	s5,24(sp)
    80005150:	0880                	addi	s0,sp,80
    80005152:	84aa                	mv	s1,a0
    80005154:	892e                	mv	s2,a1
    80005156:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005158:	ffffd097          	auipc	ra,0xffffd
    8000515c:	b96080e7          	jalr	-1130(ra) # 80001cee <myproc>
    80005160:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005162:	8526                	mv	a0,s1
    80005164:	ffffc097          	auipc	ra,0xffffc
    80005168:	ad4080e7          	jalr	-1324(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000516c:	2184a703          	lw	a4,536(s1)
    80005170:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005174:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005178:	02f71963          	bne	a4,a5,800051aa <piperead+0x6a>
    8000517c:	2244a783          	lw	a5,548(s1)
    80005180:	cf95                	beqz	a5,800051bc <piperead+0x7c>
    if(killed(pr)){
    80005182:	8552                	mv	a0,s4
    80005184:	ffffd097          	auipc	ra,0xffffd
    80005188:	5f6080e7          	jalr	1526(ra) # 8000277a <killed>
    8000518c:	e10d                	bnez	a0,800051ae <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000518e:	85a6                	mv	a1,s1
    80005190:	854e                	mv	a0,s3
    80005192:	ffffd097          	auipc	ra,0xffffd
    80005196:	340080e7          	jalr	832(ra) # 800024d2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000519a:	2184a703          	lw	a4,536(s1)
    8000519e:	21c4a783          	lw	a5,540(s1)
    800051a2:	fcf70de3          	beq	a4,a5,8000517c <piperead+0x3c>
    800051a6:	e85a                	sd	s6,16(sp)
    800051a8:	a819                	j	800051be <piperead+0x7e>
    800051aa:	e85a                	sd	s6,16(sp)
    800051ac:	a809                	j	800051be <piperead+0x7e>
      release(&pi->lock);
    800051ae:	8526                	mv	a0,s1
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	b3c080e7          	jalr	-1220(ra) # 80000cec <release>
      return -1;
    800051b8:	59fd                	li	s3,-1
    800051ba:	a0a5                	j	80005222 <piperead+0xe2>
    800051bc:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051be:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051c0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051c2:	05505463          	blez	s5,8000520a <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800051c6:	2184a783          	lw	a5,536(s1)
    800051ca:	21c4a703          	lw	a4,540(s1)
    800051ce:	02f70e63          	beq	a4,a5,8000520a <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051d2:	0017871b          	addiw	a4,a5,1
    800051d6:	20e4ac23          	sw	a4,536(s1)
    800051da:	1ff7f793          	andi	a5,a5,511
    800051de:	97a6                	add	a5,a5,s1
    800051e0:	0187c783          	lbu	a5,24(a5)
    800051e4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051e8:	4685                	li	a3,1
    800051ea:	fbf40613          	addi	a2,s0,-65
    800051ee:	85ca                	mv	a1,s2
    800051f0:	058a3503          	ld	a0,88(s4)
    800051f4:	ffffc097          	auipc	ra,0xffffc
    800051f8:	4ee080e7          	jalr	1262(ra) # 800016e2 <copyout>
    800051fc:	01650763          	beq	a0,s6,8000520a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005200:	2985                	addiw	s3,s3,1
    80005202:	0905                	addi	s2,s2,1
    80005204:	fd3a91e3          	bne	s5,s3,800051c6 <piperead+0x86>
    80005208:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000520a:	21c48513          	addi	a0,s1,540
    8000520e:	ffffd097          	auipc	ra,0xffffd
    80005212:	328080e7          	jalr	808(ra) # 80002536 <wakeup>
  release(&pi->lock);
    80005216:	8526                	mv	a0,s1
    80005218:	ffffc097          	auipc	ra,0xffffc
    8000521c:	ad4080e7          	jalr	-1324(ra) # 80000cec <release>
    80005220:	6b42                	ld	s6,16(sp)
  return i;
}
    80005222:	854e                	mv	a0,s3
    80005224:	60a6                	ld	ra,72(sp)
    80005226:	6406                	ld	s0,64(sp)
    80005228:	74e2                	ld	s1,56(sp)
    8000522a:	7942                	ld	s2,48(sp)
    8000522c:	79a2                	ld	s3,40(sp)
    8000522e:	7a02                	ld	s4,32(sp)
    80005230:	6ae2                	ld	s5,24(sp)
    80005232:	6161                	addi	sp,sp,80
    80005234:	8082                	ret

0000000080005236 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005236:	1141                	addi	sp,sp,-16
    80005238:	e422                	sd	s0,8(sp)
    8000523a:	0800                	addi	s0,sp,16
    8000523c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000523e:	8905                	andi	a0,a0,1
    80005240:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005242:	8b89                	andi	a5,a5,2
    80005244:	c399                	beqz	a5,8000524a <flags2perm+0x14>
      perm |= PTE_W;
    80005246:	00456513          	ori	a0,a0,4
    return perm;
}
    8000524a:	6422                	ld	s0,8(sp)
    8000524c:	0141                	addi	sp,sp,16
    8000524e:	8082                	ret

0000000080005250 <exec>:

int
exec(char *path, char **argv)
{
    80005250:	df010113          	addi	sp,sp,-528
    80005254:	20113423          	sd	ra,520(sp)
    80005258:	20813023          	sd	s0,512(sp)
    8000525c:	ffa6                	sd	s1,504(sp)
    8000525e:	fbca                	sd	s2,496(sp)
    80005260:	0c00                	addi	s0,sp,528
    80005262:	892a                	mv	s2,a0
    80005264:	dea43c23          	sd	a0,-520(s0)
    80005268:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000526c:	ffffd097          	auipc	ra,0xffffd
    80005270:	a82080e7          	jalr	-1406(ra) # 80001cee <myproc>
    80005274:	84aa                	mv	s1,a0

  begin_op();
    80005276:	fffff097          	auipc	ra,0xfffff
    8000527a:	43a080e7          	jalr	1082(ra) # 800046b0 <begin_op>

  if((ip = namei(path)) == 0){
    8000527e:	854a                	mv	a0,s2
    80005280:	fffff097          	auipc	ra,0xfffff
    80005284:	230080e7          	jalr	560(ra) # 800044b0 <namei>
    80005288:	c135                	beqz	a0,800052ec <exec+0x9c>
    8000528a:	f3d2                	sd	s4,480(sp)
    8000528c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000528e:	fffff097          	auipc	ra,0xfffff
    80005292:	a54080e7          	jalr	-1452(ra) # 80003ce2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005296:	04000713          	li	a4,64
    8000529a:	4681                	li	a3,0
    8000529c:	e5040613          	addi	a2,s0,-432
    800052a0:	4581                	li	a1,0
    800052a2:	8552                	mv	a0,s4
    800052a4:	fffff097          	auipc	ra,0xfffff
    800052a8:	cf6080e7          	jalr	-778(ra) # 80003f9a <readi>
    800052ac:	04000793          	li	a5,64
    800052b0:	00f51a63          	bne	a0,a5,800052c4 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800052b4:	e5042703          	lw	a4,-432(s0)
    800052b8:	464c47b7          	lui	a5,0x464c4
    800052bc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800052c0:	02f70c63          	beq	a4,a5,800052f8 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800052c4:	8552                	mv	a0,s4
    800052c6:	fffff097          	auipc	ra,0xfffff
    800052ca:	c82080e7          	jalr	-894(ra) # 80003f48 <iunlockput>
    end_op();
    800052ce:	fffff097          	auipc	ra,0xfffff
    800052d2:	45c080e7          	jalr	1116(ra) # 8000472a <end_op>
  }
  return -1;
    800052d6:	557d                	li	a0,-1
    800052d8:	7a1e                	ld	s4,480(sp)
}
    800052da:	20813083          	ld	ra,520(sp)
    800052de:	20013403          	ld	s0,512(sp)
    800052e2:	74fe                	ld	s1,504(sp)
    800052e4:	795e                	ld	s2,496(sp)
    800052e6:	21010113          	addi	sp,sp,528
    800052ea:	8082                	ret
    end_op();
    800052ec:	fffff097          	auipc	ra,0xfffff
    800052f0:	43e080e7          	jalr	1086(ra) # 8000472a <end_op>
    return -1;
    800052f4:	557d                	li	a0,-1
    800052f6:	b7d5                	j	800052da <exec+0x8a>
    800052f8:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800052fa:	8526                	mv	a0,s1
    800052fc:	ffffd097          	auipc	ra,0xffffd
    80005300:	ab6080e7          	jalr	-1354(ra) # 80001db2 <proc_pagetable>
    80005304:	8b2a                	mv	s6,a0
    80005306:	30050f63          	beqz	a0,80005624 <exec+0x3d4>
    8000530a:	f7ce                	sd	s3,488(sp)
    8000530c:	efd6                	sd	s5,472(sp)
    8000530e:	e7de                	sd	s7,456(sp)
    80005310:	e3e2                	sd	s8,448(sp)
    80005312:	ff66                	sd	s9,440(sp)
    80005314:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005316:	e7042d03          	lw	s10,-400(s0)
    8000531a:	e8845783          	lhu	a5,-376(s0)
    8000531e:	14078d63          	beqz	a5,80005478 <exec+0x228>
    80005322:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005324:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005326:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005328:	6c85                	lui	s9,0x1
    8000532a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000532e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005332:	6a85                	lui	s5,0x1
    80005334:	a0b5                	j	800053a0 <exec+0x150>
      panic("loadseg: address should exist");
    80005336:	00003517          	auipc	a0,0x3
    8000533a:	36a50513          	addi	a0,a0,874 # 800086a0 <etext+0x6a0>
    8000533e:	ffffb097          	auipc	ra,0xffffb
    80005342:	222080e7          	jalr	546(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005346:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005348:	8726                	mv	a4,s1
    8000534a:	012c06bb          	addw	a3,s8,s2
    8000534e:	4581                	li	a1,0
    80005350:	8552                	mv	a0,s4
    80005352:	fffff097          	auipc	ra,0xfffff
    80005356:	c48080e7          	jalr	-952(ra) # 80003f9a <readi>
    8000535a:	2501                	sext.w	a0,a0
    8000535c:	28a49863          	bne	s1,a0,800055ec <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80005360:	012a893b          	addw	s2,s5,s2
    80005364:	03397563          	bgeu	s2,s3,8000538e <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80005368:	02091593          	slli	a1,s2,0x20
    8000536c:	9181                	srli	a1,a1,0x20
    8000536e:	95de                	add	a1,a1,s7
    80005370:	855a                	mv	a0,s6
    80005372:	ffffc097          	auipc	ra,0xffffc
    80005376:	d44080e7          	jalr	-700(ra) # 800010b6 <walkaddr>
    8000537a:	862a                	mv	a2,a0
    if(pa == 0)
    8000537c:	dd4d                	beqz	a0,80005336 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000537e:	412984bb          	subw	s1,s3,s2
    80005382:	0004879b          	sext.w	a5,s1
    80005386:	fcfcf0e3          	bgeu	s9,a5,80005346 <exec+0xf6>
    8000538a:	84d6                	mv	s1,s5
    8000538c:	bf6d                	j	80005346 <exec+0xf6>
    sz = sz1;
    8000538e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005392:	2d85                	addiw	s11,s11,1
    80005394:	038d0d1b          	addiw	s10,s10,56
    80005398:	e8845783          	lhu	a5,-376(s0)
    8000539c:	08fdd663          	bge	s11,a5,80005428 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800053a0:	2d01                	sext.w	s10,s10
    800053a2:	03800713          	li	a4,56
    800053a6:	86ea                	mv	a3,s10
    800053a8:	e1840613          	addi	a2,s0,-488
    800053ac:	4581                	li	a1,0
    800053ae:	8552                	mv	a0,s4
    800053b0:	fffff097          	auipc	ra,0xfffff
    800053b4:	bea080e7          	jalr	-1046(ra) # 80003f9a <readi>
    800053b8:	03800793          	li	a5,56
    800053bc:	20f51063          	bne	a0,a5,800055bc <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800053c0:	e1842783          	lw	a5,-488(s0)
    800053c4:	4705                	li	a4,1
    800053c6:	fce796e3          	bne	a5,a4,80005392 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800053ca:	e4043483          	ld	s1,-448(s0)
    800053ce:	e3843783          	ld	a5,-456(s0)
    800053d2:	1ef4e963          	bltu	s1,a5,800055c4 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800053d6:	e2843783          	ld	a5,-472(s0)
    800053da:	94be                	add	s1,s1,a5
    800053dc:	1ef4e863          	bltu	s1,a5,800055cc <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    800053e0:	df043703          	ld	a4,-528(s0)
    800053e4:	8ff9                	and	a5,a5,a4
    800053e6:	1e079763          	bnez	a5,800055d4 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800053ea:	e1c42503          	lw	a0,-484(s0)
    800053ee:	00000097          	auipc	ra,0x0
    800053f2:	e48080e7          	jalr	-440(ra) # 80005236 <flags2perm>
    800053f6:	86aa                	mv	a3,a0
    800053f8:	8626                	mv	a2,s1
    800053fa:	85ca                	mv	a1,s2
    800053fc:	855a                	mv	a0,s6
    800053fe:	ffffc097          	auipc	ra,0xffffc
    80005402:	07c080e7          	jalr	124(ra) # 8000147a <uvmalloc>
    80005406:	e0a43423          	sd	a0,-504(s0)
    8000540a:	1c050963          	beqz	a0,800055dc <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000540e:	e2843b83          	ld	s7,-472(s0)
    80005412:	e2042c03          	lw	s8,-480(s0)
    80005416:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000541a:	00098463          	beqz	s3,80005422 <exec+0x1d2>
    8000541e:	4901                	li	s2,0
    80005420:	b7a1                	j	80005368 <exec+0x118>
    sz = sz1;
    80005422:	e0843903          	ld	s2,-504(s0)
    80005426:	b7b5                	j	80005392 <exec+0x142>
    80005428:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000542a:	8552                	mv	a0,s4
    8000542c:	fffff097          	auipc	ra,0xfffff
    80005430:	b1c080e7          	jalr	-1252(ra) # 80003f48 <iunlockput>
  end_op();
    80005434:	fffff097          	auipc	ra,0xfffff
    80005438:	2f6080e7          	jalr	758(ra) # 8000472a <end_op>
  p = myproc();
    8000543c:	ffffd097          	auipc	ra,0xffffd
    80005440:	8b2080e7          	jalr	-1870(ra) # 80001cee <myproc>
    80005444:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005446:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    8000544a:	6985                	lui	s3,0x1
    8000544c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000544e:	99ca                	add	s3,s3,s2
    80005450:	77fd                	lui	a5,0xfffff
    80005452:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005456:	4691                	li	a3,4
    80005458:	6609                	lui	a2,0x2
    8000545a:	964e                	add	a2,a2,s3
    8000545c:	85ce                	mv	a1,s3
    8000545e:	855a                	mv	a0,s6
    80005460:	ffffc097          	auipc	ra,0xffffc
    80005464:	01a080e7          	jalr	26(ra) # 8000147a <uvmalloc>
    80005468:	892a                	mv	s2,a0
    8000546a:	e0a43423          	sd	a0,-504(s0)
    8000546e:	e519                	bnez	a0,8000547c <exec+0x22c>
  if(pagetable)
    80005470:	e1343423          	sd	s3,-504(s0)
    80005474:	4a01                	li	s4,0
    80005476:	aaa5                	j	800055ee <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005478:	4901                	li	s2,0
    8000547a:	bf45                	j	8000542a <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000547c:	75f9                	lui	a1,0xffffe
    8000547e:	95aa                	add	a1,a1,a0
    80005480:	855a                	mv	a0,s6
    80005482:	ffffc097          	auipc	ra,0xffffc
    80005486:	22e080e7          	jalr	558(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    8000548a:	7bfd                	lui	s7,0xfffff
    8000548c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000548e:	e0043783          	ld	a5,-512(s0)
    80005492:	6388                	ld	a0,0(a5)
    80005494:	c52d                	beqz	a0,800054fe <exec+0x2ae>
    80005496:	e9040993          	addi	s3,s0,-368
    8000549a:	f9040c13          	addi	s8,s0,-112
    8000549e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800054a0:	ffffc097          	auipc	ra,0xffffc
    800054a4:	a08080e7          	jalr	-1528(ra) # 80000ea8 <strlen>
    800054a8:	0015079b          	addiw	a5,a0,1
    800054ac:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800054b0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800054b4:	13796863          	bltu	s2,s7,800055e4 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800054b8:	e0043d03          	ld	s10,-512(s0)
    800054bc:	000d3a03          	ld	s4,0(s10)
    800054c0:	8552                	mv	a0,s4
    800054c2:	ffffc097          	auipc	ra,0xffffc
    800054c6:	9e6080e7          	jalr	-1562(ra) # 80000ea8 <strlen>
    800054ca:	0015069b          	addiw	a3,a0,1
    800054ce:	8652                	mv	a2,s4
    800054d0:	85ca                	mv	a1,s2
    800054d2:	855a                	mv	a0,s6
    800054d4:	ffffc097          	auipc	ra,0xffffc
    800054d8:	20e080e7          	jalr	526(ra) # 800016e2 <copyout>
    800054dc:	10054663          	bltz	a0,800055e8 <exec+0x398>
    ustack[argc] = sp;
    800054e0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800054e4:	0485                	addi	s1,s1,1
    800054e6:	008d0793          	addi	a5,s10,8
    800054ea:	e0f43023          	sd	a5,-512(s0)
    800054ee:	008d3503          	ld	a0,8(s10)
    800054f2:	c909                	beqz	a0,80005504 <exec+0x2b4>
    if(argc >= MAXARG)
    800054f4:	09a1                	addi	s3,s3,8
    800054f6:	fb8995e3          	bne	s3,s8,800054a0 <exec+0x250>
  ip = 0;
    800054fa:	4a01                	li	s4,0
    800054fc:	a8cd                	j	800055ee <exec+0x39e>
  sp = sz;
    800054fe:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005502:	4481                	li	s1,0
  ustack[argc] = 0;
    80005504:	00349793          	slli	a5,s1,0x3
    80005508:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda410>
    8000550c:	97a2                	add	a5,a5,s0
    8000550e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005512:	00148693          	addi	a3,s1,1
    80005516:	068e                	slli	a3,a3,0x3
    80005518:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000551c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005520:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005524:	f57966e3          	bltu	s2,s7,80005470 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005528:	e9040613          	addi	a2,s0,-368
    8000552c:	85ca                	mv	a1,s2
    8000552e:	855a                	mv	a0,s6
    80005530:	ffffc097          	auipc	ra,0xffffc
    80005534:	1b2080e7          	jalr	434(ra) # 800016e2 <copyout>
    80005538:	0e054863          	bltz	a0,80005628 <exec+0x3d8>
  p->trapframe->a1 = sp;
    8000553c:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80005540:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005544:	df843783          	ld	a5,-520(s0)
    80005548:	0007c703          	lbu	a4,0(a5)
    8000554c:	cf11                	beqz	a4,80005568 <exec+0x318>
    8000554e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005550:	02f00693          	li	a3,47
    80005554:	a039                	j	80005562 <exec+0x312>
      last = s+1;
    80005556:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000555a:	0785                	addi	a5,a5,1
    8000555c:	fff7c703          	lbu	a4,-1(a5)
    80005560:	c701                	beqz	a4,80005568 <exec+0x318>
    if(*s == '/')
    80005562:	fed71ce3          	bne	a4,a3,8000555a <exec+0x30a>
    80005566:	bfc5                	j	80005556 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005568:	4641                	li	a2,16
    8000556a:	df843583          	ld	a1,-520(s0)
    8000556e:	160a8513          	addi	a0,s5,352
    80005572:	ffffc097          	auipc	ra,0xffffc
    80005576:	904080e7          	jalr	-1788(ra) # 80000e76 <safestrcpy>
  oldpagetable = p->pagetable;
    8000557a:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    8000557e:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80005582:	e0843783          	ld	a5,-504(s0)
    80005586:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000558a:	060ab783          	ld	a5,96(s5)
    8000558e:	e6843703          	ld	a4,-408(s0)
    80005592:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005594:	060ab783          	ld	a5,96(s5)
    80005598:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000559c:	85e6                	mv	a1,s9
    8000559e:	ffffd097          	auipc	ra,0xffffd
    800055a2:	8b0080e7          	jalr	-1872(ra) # 80001e4e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800055a6:	0004851b          	sext.w	a0,s1
    800055aa:	79be                	ld	s3,488(sp)
    800055ac:	7a1e                	ld	s4,480(sp)
    800055ae:	6afe                	ld	s5,472(sp)
    800055b0:	6b5e                	ld	s6,464(sp)
    800055b2:	6bbe                	ld	s7,456(sp)
    800055b4:	6c1e                	ld	s8,448(sp)
    800055b6:	7cfa                	ld	s9,440(sp)
    800055b8:	7d5a                	ld	s10,432(sp)
    800055ba:	b305                	j	800052da <exec+0x8a>
    800055bc:	e1243423          	sd	s2,-504(s0)
    800055c0:	7dba                	ld	s11,424(sp)
    800055c2:	a035                	j	800055ee <exec+0x39e>
    800055c4:	e1243423          	sd	s2,-504(s0)
    800055c8:	7dba                	ld	s11,424(sp)
    800055ca:	a015                	j	800055ee <exec+0x39e>
    800055cc:	e1243423          	sd	s2,-504(s0)
    800055d0:	7dba                	ld	s11,424(sp)
    800055d2:	a831                	j	800055ee <exec+0x39e>
    800055d4:	e1243423          	sd	s2,-504(s0)
    800055d8:	7dba                	ld	s11,424(sp)
    800055da:	a811                	j	800055ee <exec+0x39e>
    800055dc:	e1243423          	sd	s2,-504(s0)
    800055e0:	7dba                	ld	s11,424(sp)
    800055e2:	a031                	j	800055ee <exec+0x39e>
  ip = 0;
    800055e4:	4a01                	li	s4,0
    800055e6:	a021                	j	800055ee <exec+0x39e>
    800055e8:	4a01                	li	s4,0
  if(pagetable)
    800055ea:	a011                	j	800055ee <exec+0x39e>
    800055ec:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800055ee:	e0843583          	ld	a1,-504(s0)
    800055f2:	855a                	mv	a0,s6
    800055f4:	ffffd097          	auipc	ra,0xffffd
    800055f8:	85a080e7          	jalr	-1958(ra) # 80001e4e <proc_freepagetable>
  return -1;
    800055fc:	557d                	li	a0,-1
  if(ip){
    800055fe:	000a1b63          	bnez	s4,80005614 <exec+0x3c4>
    80005602:	79be                	ld	s3,488(sp)
    80005604:	7a1e                	ld	s4,480(sp)
    80005606:	6afe                	ld	s5,472(sp)
    80005608:	6b5e                	ld	s6,464(sp)
    8000560a:	6bbe                	ld	s7,456(sp)
    8000560c:	6c1e                	ld	s8,448(sp)
    8000560e:	7cfa                	ld	s9,440(sp)
    80005610:	7d5a                	ld	s10,432(sp)
    80005612:	b1e1                	j	800052da <exec+0x8a>
    80005614:	79be                	ld	s3,488(sp)
    80005616:	6afe                	ld	s5,472(sp)
    80005618:	6b5e                	ld	s6,464(sp)
    8000561a:	6bbe                	ld	s7,456(sp)
    8000561c:	6c1e                	ld	s8,448(sp)
    8000561e:	7cfa                	ld	s9,440(sp)
    80005620:	7d5a                	ld	s10,432(sp)
    80005622:	b14d                	j	800052c4 <exec+0x74>
    80005624:	6b5e                	ld	s6,464(sp)
    80005626:	b979                	j	800052c4 <exec+0x74>
  sz = sz1;
    80005628:	e0843983          	ld	s3,-504(s0)
    8000562c:	b591                	j	80005470 <exec+0x220>

000000008000562e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000562e:	7179                	addi	sp,sp,-48
    80005630:	f406                	sd	ra,40(sp)
    80005632:	f022                	sd	s0,32(sp)
    80005634:	ec26                	sd	s1,24(sp)
    80005636:	e84a                	sd	s2,16(sp)
    80005638:	1800                	addi	s0,sp,48
    8000563a:	892e                	mv	s2,a1
    8000563c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000563e:	fdc40593          	addi	a1,s0,-36
    80005642:	ffffe097          	auipc	ra,0xffffe
    80005646:	a50080e7          	jalr	-1456(ra) # 80003092 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000564a:	fdc42703          	lw	a4,-36(s0)
    8000564e:	47bd                	li	a5,15
    80005650:	02e7eb63          	bltu	a5,a4,80005686 <argfd+0x58>
    80005654:	ffffc097          	auipc	ra,0xffffc
    80005658:	69a080e7          	jalr	1690(ra) # 80001cee <myproc>
    8000565c:	fdc42703          	lw	a4,-36(s0)
    80005660:	01a70793          	addi	a5,a4,26
    80005664:	078e                	slli	a5,a5,0x3
    80005666:	953e                	add	a0,a0,a5
    80005668:	651c                	ld	a5,8(a0)
    8000566a:	c385                	beqz	a5,8000568a <argfd+0x5c>
    return -1;
  if(pfd)
    8000566c:	00090463          	beqz	s2,80005674 <argfd+0x46>
    *pfd = fd;
    80005670:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005674:	4501                	li	a0,0
  if(pf)
    80005676:	c091                	beqz	s1,8000567a <argfd+0x4c>
    *pf = f;
    80005678:	e09c                	sd	a5,0(s1)
}
    8000567a:	70a2                	ld	ra,40(sp)
    8000567c:	7402                	ld	s0,32(sp)
    8000567e:	64e2                	ld	s1,24(sp)
    80005680:	6942                	ld	s2,16(sp)
    80005682:	6145                	addi	sp,sp,48
    80005684:	8082                	ret
    return -1;
    80005686:	557d                	li	a0,-1
    80005688:	bfcd                	j	8000567a <argfd+0x4c>
    8000568a:	557d                	li	a0,-1
    8000568c:	b7fd                	j	8000567a <argfd+0x4c>

000000008000568e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000568e:	1101                	addi	sp,sp,-32
    80005690:	ec06                	sd	ra,24(sp)
    80005692:	e822                	sd	s0,16(sp)
    80005694:	e426                	sd	s1,8(sp)
    80005696:	1000                	addi	s0,sp,32
    80005698:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000569a:	ffffc097          	auipc	ra,0xffffc
    8000569e:	654080e7          	jalr	1620(ra) # 80001cee <myproc>
    800056a2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800056a4:	0d850793          	addi	a5,a0,216
    800056a8:	4501                	li	a0,0
    800056aa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800056ac:	6398                	ld	a4,0(a5)
    800056ae:	cb19                	beqz	a4,800056c4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800056b0:	2505                	addiw	a0,a0,1
    800056b2:	07a1                	addi	a5,a5,8
    800056b4:	fed51ce3          	bne	a0,a3,800056ac <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800056b8:	557d                	li	a0,-1
}
    800056ba:	60e2                	ld	ra,24(sp)
    800056bc:	6442                	ld	s0,16(sp)
    800056be:	64a2                	ld	s1,8(sp)
    800056c0:	6105                	addi	sp,sp,32
    800056c2:	8082                	ret
      p->ofile[fd] = f;
    800056c4:	01a50793          	addi	a5,a0,26
    800056c8:	078e                	slli	a5,a5,0x3
    800056ca:	963e                	add	a2,a2,a5
    800056cc:	e604                	sd	s1,8(a2)
      return fd;
    800056ce:	b7f5                	j	800056ba <fdalloc+0x2c>

00000000800056d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800056d0:	715d                	addi	sp,sp,-80
    800056d2:	e486                	sd	ra,72(sp)
    800056d4:	e0a2                	sd	s0,64(sp)
    800056d6:	fc26                	sd	s1,56(sp)
    800056d8:	f84a                	sd	s2,48(sp)
    800056da:	f44e                	sd	s3,40(sp)
    800056dc:	ec56                	sd	s5,24(sp)
    800056de:	e85a                	sd	s6,16(sp)
    800056e0:	0880                	addi	s0,sp,80
    800056e2:	8b2e                	mv	s6,a1
    800056e4:	89b2                	mv	s3,a2
    800056e6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800056e8:	fb040593          	addi	a1,s0,-80
    800056ec:	fffff097          	auipc	ra,0xfffff
    800056f0:	de2080e7          	jalr	-542(ra) # 800044ce <nameiparent>
    800056f4:	84aa                	mv	s1,a0
    800056f6:	14050e63          	beqz	a0,80005852 <create+0x182>
    return 0;

  ilock(dp);
    800056fa:	ffffe097          	auipc	ra,0xffffe
    800056fe:	5e8080e7          	jalr	1512(ra) # 80003ce2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005702:	4601                	li	a2,0
    80005704:	fb040593          	addi	a1,s0,-80
    80005708:	8526                	mv	a0,s1
    8000570a:	fffff097          	auipc	ra,0xfffff
    8000570e:	ae4080e7          	jalr	-1308(ra) # 800041ee <dirlookup>
    80005712:	8aaa                	mv	s5,a0
    80005714:	c539                	beqz	a0,80005762 <create+0x92>
    iunlockput(dp);
    80005716:	8526                	mv	a0,s1
    80005718:	fffff097          	auipc	ra,0xfffff
    8000571c:	830080e7          	jalr	-2000(ra) # 80003f48 <iunlockput>
    ilock(ip);
    80005720:	8556                	mv	a0,s5
    80005722:	ffffe097          	auipc	ra,0xffffe
    80005726:	5c0080e7          	jalr	1472(ra) # 80003ce2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000572a:	4789                	li	a5,2
    8000572c:	02fb1463          	bne	s6,a5,80005754 <create+0x84>
    80005730:	044ad783          	lhu	a5,68(s5)
    80005734:	37f9                	addiw	a5,a5,-2
    80005736:	17c2                	slli	a5,a5,0x30
    80005738:	93c1                	srli	a5,a5,0x30
    8000573a:	4705                	li	a4,1
    8000573c:	00f76c63          	bltu	a4,a5,80005754 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005740:	8556                	mv	a0,s5
    80005742:	60a6                	ld	ra,72(sp)
    80005744:	6406                	ld	s0,64(sp)
    80005746:	74e2                	ld	s1,56(sp)
    80005748:	7942                	ld	s2,48(sp)
    8000574a:	79a2                	ld	s3,40(sp)
    8000574c:	6ae2                	ld	s5,24(sp)
    8000574e:	6b42                	ld	s6,16(sp)
    80005750:	6161                	addi	sp,sp,80
    80005752:	8082                	ret
    iunlockput(ip);
    80005754:	8556                	mv	a0,s5
    80005756:	ffffe097          	auipc	ra,0xffffe
    8000575a:	7f2080e7          	jalr	2034(ra) # 80003f48 <iunlockput>
    return 0;
    8000575e:	4a81                	li	s5,0
    80005760:	b7c5                	j	80005740 <create+0x70>
    80005762:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005764:	85da                	mv	a1,s6
    80005766:	4088                	lw	a0,0(s1)
    80005768:	ffffe097          	auipc	ra,0xffffe
    8000576c:	3d6080e7          	jalr	982(ra) # 80003b3e <ialloc>
    80005770:	8a2a                	mv	s4,a0
    80005772:	c531                	beqz	a0,800057be <create+0xee>
  ilock(ip);
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	56e080e7          	jalr	1390(ra) # 80003ce2 <ilock>
  ip->major = major;
    8000577c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005780:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005784:	4905                	li	s2,1
    80005786:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000578a:	8552                	mv	a0,s4
    8000578c:	ffffe097          	auipc	ra,0xffffe
    80005790:	48a080e7          	jalr	1162(ra) # 80003c16 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005794:	032b0d63          	beq	s6,s2,800057ce <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005798:	004a2603          	lw	a2,4(s4)
    8000579c:	fb040593          	addi	a1,s0,-80
    800057a0:	8526                	mv	a0,s1
    800057a2:	fffff097          	auipc	ra,0xfffff
    800057a6:	c5c080e7          	jalr	-932(ra) # 800043fe <dirlink>
    800057aa:	08054163          	bltz	a0,8000582c <create+0x15c>
  iunlockput(dp);
    800057ae:	8526                	mv	a0,s1
    800057b0:	ffffe097          	auipc	ra,0xffffe
    800057b4:	798080e7          	jalr	1944(ra) # 80003f48 <iunlockput>
  return ip;
    800057b8:	8ad2                	mv	s5,s4
    800057ba:	7a02                	ld	s4,32(sp)
    800057bc:	b751                	j	80005740 <create+0x70>
    iunlockput(dp);
    800057be:	8526                	mv	a0,s1
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	788080e7          	jalr	1928(ra) # 80003f48 <iunlockput>
    return 0;
    800057c8:	8ad2                	mv	s5,s4
    800057ca:	7a02                	ld	s4,32(sp)
    800057cc:	bf95                	j	80005740 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800057ce:	004a2603          	lw	a2,4(s4)
    800057d2:	00003597          	auipc	a1,0x3
    800057d6:	eee58593          	addi	a1,a1,-274 # 800086c0 <etext+0x6c0>
    800057da:	8552                	mv	a0,s4
    800057dc:	fffff097          	auipc	ra,0xfffff
    800057e0:	c22080e7          	jalr	-990(ra) # 800043fe <dirlink>
    800057e4:	04054463          	bltz	a0,8000582c <create+0x15c>
    800057e8:	40d0                	lw	a2,4(s1)
    800057ea:	00003597          	auipc	a1,0x3
    800057ee:	ede58593          	addi	a1,a1,-290 # 800086c8 <etext+0x6c8>
    800057f2:	8552                	mv	a0,s4
    800057f4:	fffff097          	auipc	ra,0xfffff
    800057f8:	c0a080e7          	jalr	-1014(ra) # 800043fe <dirlink>
    800057fc:	02054863          	bltz	a0,8000582c <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005800:	004a2603          	lw	a2,4(s4)
    80005804:	fb040593          	addi	a1,s0,-80
    80005808:	8526                	mv	a0,s1
    8000580a:	fffff097          	auipc	ra,0xfffff
    8000580e:	bf4080e7          	jalr	-1036(ra) # 800043fe <dirlink>
    80005812:	00054d63          	bltz	a0,8000582c <create+0x15c>
    dp->nlink++;  // for ".."
    80005816:	04a4d783          	lhu	a5,74(s1)
    8000581a:	2785                	addiw	a5,a5,1
    8000581c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005820:	8526                	mv	a0,s1
    80005822:	ffffe097          	auipc	ra,0xffffe
    80005826:	3f4080e7          	jalr	1012(ra) # 80003c16 <iupdate>
    8000582a:	b751                	j	800057ae <create+0xde>
  ip->nlink = 0;
    8000582c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005830:	8552                	mv	a0,s4
    80005832:	ffffe097          	auipc	ra,0xffffe
    80005836:	3e4080e7          	jalr	996(ra) # 80003c16 <iupdate>
  iunlockput(ip);
    8000583a:	8552                	mv	a0,s4
    8000583c:	ffffe097          	auipc	ra,0xffffe
    80005840:	70c080e7          	jalr	1804(ra) # 80003f48 <iunlockput>
  iunlockput(dp);
    80005844:	8526                	mv	a0,s1
    80005846:	ffffe097          	auipc	ra,0xffffe
    8000584a:	702080e7          	jalr	1794(ra) # 80003f48 <iunlockput>
  return 0;
    8000584e:	7a02                	ld	s4,32(sp)
    80005850:	bdc5                	j	80005740 <create+0x70>
    return 0;
    80005852:	8aaa                	mv	s5,a0
    80005854:	b5f5                	j	80005740 <create+0x70>

0000000080005856 <sys_dup>:
{
    80005856:	7179                	addi	sp,sp,-48
    80005858:	f406                	sd	ra,40(sp)
    8000585a:	f022                	sd	s0,32(sp)
    8000585c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000585e:	fd840613          	addi	a2,s0,-40
    80005862:	4581                	li	a1,0
    80005864:	4501                	li	a0,0
    80005866:	00000097          	auipc	ra,0x0
    8000586a:	dc8080e7          	jalr	-568(ra) # 8000562e <argfd>
    return -1;
    8000586e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005870:	02054763          	bltz	a0,8000589e <sys_dup+0x48>
    80005874:	ec26                	sd	s1,24(sp)
    80005876:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005878:	fd843903          	ld	s2,-40(s0)
    8000587c:	854a                	mv	a0,s2
    8000587e:	00000097          	auipc	ra,0x0
    80005882:	e10080e7          	jalr	-496(ra) # 8000568e <fdalloc>
    80005886:	84aa                	mv	s1,a0
    return -1;
    80005888:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000588a:	00054f63          	bltz	a0,800058a8 <sys_dup+0x52>
  filedup(f);
    8000588e:	854a                	mv	a0,s2
    80005890:	fffff097          	auipc	ra,0xfffff
    80005894:	298080e7          	jalr	664(ra) # 80004b28 <filedup>
  return fd;
    80005898:	87a6                	mv	a5,s1
    8000589a:	64e2                	ld	s1,24(sp)
    8000589c:	6942                	ld	s2,16(sp)
}
    8000589e:	853e                	mv	a0,a5
    800058a0:	70a2                	ld	ra,40(sp)
    800058a2:	7402                	ld	s0,32(sp)
    800058a4:	6145                	addi	sp,sp,48
    800058a6:	8082                	ret
    800058a8:	64e2                	ld	s1,24(sp)
    800058aa:	6942                	ld	s2,16(sp)
    800058ac:	bfcd                	j	8000589e <sys_dup+0x48>

00000000800058ae <sys_read>:
{
    800058ae:	7179                	addi	sp,sp,-48
    800058b0:	f406                	sd	ra,40(sp)
    800058b2:	f022                	sd	s0,32(sp)
    800058b4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800058b6:	fd840593          	addi	a1,s0,-40
    800058ba:	4505                	li	a0,1
    800058bc:	ffffd097          	auipc	ra,0xffffd
    800058c0:	7f6080e7          	jalr	2038(ra) # 800030b2 <argaddr>
  argint(2, &n);
    800058c4:	fe440593          	addi	a1,s0,-28
    800058c8:	4509                	li	a0,2
    800058ca:	ffffd097          	auipc	ra,0xffffd
    800058ce:	7c8080e7          	jalr	1992(ra) # 80003092 <argint>
  if(argfd(0, 0, &f) < 0)
    800058d2:	fe840613          	addi	a2,s0,-24
    800058d6:	4581                	li	a1,0
    800058d8:	4501                	li	a0,0
    800058da:	00000097          	auipc	ra,0x0
    800058de:	d54080e7          	jalr	-684(ra) # 8000562e <argfd>
    800058e2:	87aa                	mv	a5,a0
    return -1;
    800058e4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058e6:	0007cc63          	bltz	a5,800058fe <sys_read+0x50>
  return fileread(f, p, n);
    800058ea:	fe442603          	lw	a2,-28(s0)
    800058ee:	fd843583          	ld	a1,-40(s0)
    800058f2:	fe843503          	ld	a0,-24(s0)
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	3d8080e7          	jalr	984(ra) # 80004cce <fileread>
}
    800058fe:	70a2                	ld	ra,40(sp)
    80005900:	7402                	ld	s0,32(sp)
    80005902:	6145                	addi	sp,sp,48
    80005904:	8082                	ret

0000000080005906 <sys_write>:
{
    80005906:	7179                	addi	sp,sp,-48
    80005908:	f406                	sd	ra,40(sp)
    8000590a:	f022                	sd	s0,32(sp)
    8000590c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000590e:	fd840593          	addi	a1,s0,-40
    80005912:	4505                	li	a0,1
    80005914:	ffffd097          	auipc	ra,0xffffd
    80005918:	79e080e7          	jalr	1950(ra) # 800030b2 <argaddr>
  argint(2, &n);
    8000591c:	fe440593          	addi	a1,s0,-28
    80005920:	4509                	li	a0,2
    80005922:	ffffd097          	auipc	ra,0xffffd
    80005926:	770080e7          	jalr	1904(ra) # 80003092 <argint>
  if(argfd(0, 0, &f) < 0)
    8000592a:	fe840613          	addi	a2,s0,-24
    8000592e:	4581                	li	a1,0
    80005930:	4501                	li	a0,0
    80005932:	00000097          	auipc	ra,0x0
    80005936:	cfc080e7          	jalr	-772(ra) # 8000562e <argfd>
    8000593a:	87aa                	mv	a5,a0
    return -1;
    8000593c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000593e:	0007cc63          	bltz	a5,80005956 <sys_write+0x50>
  return filewrite(f, p, n);
    80005942:	fe442603          	lw	a2,-28(s0)
    80005946:	fd843583          	ld	a1,-40(s0)
    8000594a:	fe843503          	ld	a0,-24(s0)
    8000594e:	fffff097          	auipc	ra,0xfffff
    80005952:	452080e7          	jalr	1106(ra) # 80004da0 <filewrite>
}
    80005956:	70a2                	ld	ra,40(sp)
    80005958:	7402                	ld	s0,32(sp)
    8000595a:	6145                	addi	sp,sp,48
    8000595c:	8082                	ret

000000008000595e <sys_close>:
{
    8000595e:	1101                	addi	sp,sp,-32
    80005960:	ec06                	sd	ra,24(sp)
    80005962:	e822                	sd	s0,16(sp)
    80005964:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005966:	fe040613          	addi	a2,s0,-32
    8000596a:	fec40593          	addi	a1,s0,-20
    8000596e:	4501                	li	a0,0
    80005970:	00000097          	auipc	ra,0x0
    80005974:	cbe080e7          	jalr	-834(ra) # 8000562e <argfd>
    return -1;
    80005978:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000597a:	02054463          	bltz	a0,800059a2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000597e:	ffffc097          	auipc	ra,0xffffc
    80005982:	370080e7          	jalr	880(ra) # 80001cee <myproc>
    80005986:	fec42783          	lw	a5,-20(s0)
    8000598a:	07e9                	addi	a5,a5,26
    8000598c:	078e                	slli	a5,a5,0x3
    8000598e:	953e                	add	a0,a0,a5
    80005990:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005994:	fe043503          	ld	a0,-32(s0)
    80005998:	fffff097          	auipc	ra,0xfffff
    8000599c:	1e2080e7          	jalr	482(ra) # 80004b7a <fileclose>
  return 0;
    800059a0:	4781                	li	a5,0
}
    800059a2:	853e                	mv	a0,a5
    800059a4:	60e2                	ld	ra,24(sp)
    800059a6:	6442                	ld	s0,16(sp)
    800059a8:	6105                	addi	sp,sp,32
    800059aa:	8082                	ret

00000000800059ac <sys_fstat>:
{
    800059ac:	1101                	addi	sp,sp,-32
    800059ae:	ec06                	sd	ra,24(sp)
    800059b0:	e822                	sd	s0,16(sp)
    800059b2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800059b4:	fe040593          	addi	a1,s0,-32
    800059b8:	4505                	li	a0,1
    800059ba:	ffffd097          	auipc	ra,0xffffd
    800059be:	6f8080e7          	jalr	1784(ra) # 800030b2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800059c2:	fe840613          	addi	a2,s0,-24
    800059c6:	4581                	li	a1,0
    800059c8:	4501                	li	a0,0
    800059ca:	00000097          	auipc	ra,0x0
    800059ce:	c64080e7          	jalr	-924(ra) # 8000562e <argfd>
    800059d2:	87aa                	mv	a5,a0
    return -1;
    800059d4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800059d6:	0007ca63          	bltz	a5,800059ea <sys_fstat+0x3e>
  return filestat(f, st);
    800059da:	fe043583          	ld	a1,-32(s0)
    800059de:	fe843503          	ld	a0,-24(s0)
    800059e2:	fffff097          	auipc	ra,0xfffff
    800059e6:	27a080e7          	jalr	634(ra) # 80004c5c <filestat>
}
    800059ea:	60e2                	ld	ra,24(sp)
    800059ec:	6442                	ld	s0,16(sp)
    800059ee:	6105                	addi	sp,sp,32
    800059f0:	8082                	ret

00000000800059f2 <sys_link>:
{
    800059f2:	7169                	addi	sp,sp,-304
    800059f4:	f606                	sd	ra,296(sp)
    800059f6:	f222                	sd	s0,288(sp)
    800059f8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059fa:	08000613          	li	a2,128
    800059fe:	ed040593          	addi	a1,s0,-304
    80005a02:	4501                	li	a0,0
    80005a04:	ffffd097          	auipc	ra,0xffffd
    80005a08:	6ce080e7          	jalr	1742(ra) # 800030d2 <argstr>
    return -1;
    80005a0c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a0e:	12054663          	bltz	a0,80005b3a <sys_link+0x148>
    80005a12:	08000613          	li	a2,128
    80005a16:	f5040593          	addi	a1,s0,-176
    80005a1a:	4505                	li	a0,1
    80005a1c:	ffffd097          	auipc	ra,0xffffd
    80005a20:	6b6080e7          	jalr	1718(ra) # 800030d2 <argstr>
    return -1;
    80005a24:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a26:	10054a63          	bltz	a0,80005b3a <sys_link+0x148>
    80005a2a:	ee26                	sd	s1,280(sp)
  begin_op();
    80005a2c:	fffff097          	auipc	ra,0xfffff
    80005a30:	c84080e7          	jalr	-892(ra) # 800046b0 <begin_op>
  if((ip = namei(old)) == 0){
    80005a34:	ed040513          	addi	a0,s0,-304
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	a78080e7          	jalr	-1416(ra) # 800044b0 <namei>
    80005a40:	84aa                	mv	s1,a0
    80005a42:	c949                	beqz	a0,80005ad4 <sys_link+0xe2>
  ilock(ip);
    80005a44:	ffffe097          	auipc	ra,0xffffe
    80005a48:	29e080e7          	jalr	670(ra) # 80003ce2 <ilock>
  if(ip->type == T_DIR){
    80005a4c:	04449703          	lh	a4,68(s1)
    80005a50:	4785                	li	a5,1
    80005a52:	08f70863          	beq	a4,a5,80005ae2 <sys_link+0xf0>
    80005a56:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005a58:	04a4d783          	lhu	a5,74(s1)
    80005a5c:	2785                	addiw	a5,a5,1
    80005a5e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a62:	8526                	mv	a0,s1
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	1b2080e7          	jalr	434(ra) # 80003c16 <iupdate>
  iunlock(ip);
    80005a6c:	8526                	mv	a0,s1
    80005a6e:	ffffe097          	auipc	ra,0xffffe
    80005a72:	33a080e7          	jalr	826(ra) # 80003da8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005a76:	fd040593          	addi	a1,s0,-48
    80005a7a:	f5040513          	addi	a0,s0,-176
    80005a7e:	fffff097          	auipc	ra,0xfffff
    80005a82:	a50080e7          	jalr	-1456(ra) # 800044ce <nameiparent>
    80005a86:	892a                	mv	s2,a0
    80005a88:	cd35                	beqz	a0,80005b04 <sys_link+0x112>
  ilock(dp);
    80005a8a:	ffffe097          	auipc	ra,0xffffe
    80005a8e:	258080e7          	jalr	600(ra) # 80003ce2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005a92:	00092703          	lw	a4,0(s2)
    80005a96:	409c                	lw	a5,0(s1)
    80005a98:	06f71163          	bne	a4,a5,80005afa <sys_link+0x108>
    80005a9c:	40d0                	lw	a2,4(s1)
    80005a9e:	fd040593          	addi	a1,s0,-48
    80005aa2:	854a                	mv	a0,s2
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	95a080e7          	jalr	-1702(ra) # 800043fe <dirlink>
    80005aac:	04054763          	bltz	a0,80005afa <sys_link+0x108>
  iunlockput(dp);
    80005ab0:	854a                	mv	a0,s2
    80005ab2:	ffffe097          	auipc	ra,0xffffe
    80005ab6:	496080e7          	jalr	1174(ra) # 80003f48 <iunlockput>
  iput(ip);
    80005aba:	8526                	mv	a0,s1
    80005abc:	ffffe097          	auipc	ra,0xffffe
    80005ac0:	3e4080e7          	jalr	996(ra) # 80003ea0 <iput>
  end_op();
    80005ac4:	fffff097          	auipc	ra,0xfffff
    80005ac8:	c66080e7          	jalr	-922(ra) # 8000472a <end_op>
  return 0;
    80005acc:	4781                	li	a5,0
    80005ace:	64f2                	ld	s1,280(sp)
    80005ad0:	6952                	ld	s2,272(sp)
    80005ad2:	a0a5                	j	80005b3a <sys_link+0x148>
    end_op();
    80005ad4:	fffff097          	auipc	ra,0xfffff
    80005ad8:	c56080e7          	jalr	-938(ra) # 8000472a <end_op>
    return -1;
    80005adc:	57fd                	li	a5,-1
    80005ade:	64f2                	ld	s1,280(sp)
    80005ae0:	a8a9                	j	80005b3a <sys_link+0x148>
    iunlockput(ip);
    80005ae2:	8526                	mv	a0,s1
    80005ae4:	ffffe097          	auipc	ra,0xffffe
    80005ae8:	464080e7          	jalr	1124(ra) # 80003f48 <iunlockput>
    end_op();
    80005aec:	fffff097          	auipc	ra,0xfffff
    80005af0:	c3e080e7          	jalr	-962(ra) # 8000472a <end_op>
    return -1;
    80005af4:	57fd                	li	a5,-1
    80005af6:	64f2                	ld	s1,280(sp)
    80005af8:	a089                	j	80005b3a <sys_link+0x148>
    iunlockput(dp);
    80005afa:	854a                	mv	a0,s2
    80005afc:	ffffe097          	auipc	ra,0xffffe
    80005b00:	44c080e7          	jalr	1100(ra) # 80003f48 <iunlockput>
  ilock(ip);
    80005b04:	8526                	mv	a0,s1
    80005b06:	ffffe097          	auipc	ra,0xffffe
    80005b0a:	1dc080e7          	jalr	476(ra) # 80003ce2 <ilock>
  ip->nlink--;
    80005b0e:	04a4d783          	lhu	a5,74(s1)
    80005b12:	37fd                	addiw	a5,a5,-1
    80005b14:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b18:	8526                	mv	a0,s1
    80005b1a:	ffffe097          	auipc	ra,0xffffe
    80005b1e:	0fc080e7          	jalr	252(ra) # 80003c16 <iupdate>
  iunlockput(ip);
    80005b22:	8526                	mv	a0,s1
    80005b24:	ffffe097          	auipc	ra,0xffffe
    80005b28:	424080e7          	jalr	1060(ra) # 80003f48 <iunlockput>
  end_op();
    80005b2c:	fffff097          	auipc	ra,0xfffff
    80005b30:	bfe080e7          	jalr	-1026(ra) # 8000472a <end_op>
  return -1;
    80005b34:	57fd                	li	a5,-1
    80005b36:	64f2                	ld	s1,280(sp)
    80005b38:	6952                	ld	s2,272(sp)
}
    80005b3a:	853e                	mv	a0,a5
    80005b3c:	70b2                	ld	ra,296(sp)
    80005b3e:	7412                	ld	s0,288(sp)
    80005b40:	6155                	addi	sp,sp,304
    80005b42:	8082                	ret

0000000080005b44 <sys_unlink>:
{
    80005b44:	7151                	addi	sp,sp,-240
    80005b46:	f586                	sd	ra,232(sp)
    80005b48:	f1a2                	sd	s0,224(sp)
    80005b4a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005b4c:	08000613          	li	a2,128
    80005b50:	f3040593          	addi	a1,s0,-208
    80005b54:	4501                	li	a0,0
    80005b56:	ffffd097          	auipc	ra,0xffffd
    80005b5a:	57c080e7          	jalr	1404(ra) # 800030d2 <argstr>
    80005b5e:	1a054a63          	bltz	a0,80005d12 <sys_unlink+0x1ce>
    80005b62:	eda6                	sd	s1,216(sp)
  begin_op();
    80005b64:	fffff097          	auipc	ra,0xfffff
    80005b68:	b4c080e7          	jalr	-1204(ra) # 800046b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b6c:	fb040593          	addi	a1,s0,-80
    80005b70:	f3040513          	addi	a0,s0,-208
    80005b74:	fffff097          	auipc	ra,0xfffff
    80005b78:	95a080e7          	jalr	-1702(ra) # 800044ce <nameiparent>
    80005b7c:	84aa                	mv	s1,a0
    80005b7e:	cd71                	beqz	a0,80005c5a <sys_unlink+0x116>
  ilock(dp);
    80005b80:	ffffe097          	auipc	ra,0xffffe
    80005b84:	162080e7          	jalr	354(ra) # 80003ce2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005b88:	00003597          	auipc	a1,0x3
    80005b8c:	b3858593          	addi	a1,a1,-1224 # 800086c0 <etext+0x6c0>
    80005b90:	fb040513          	addi	a0,s0,-80
    80005b94:	ffffe097          	auipc	ra,0xffffe
    80005b98:	640080e7          	jalr	1600(ra) # 800041d4 <namecmp>
    80005b9c:	14050c63          	beqz	a0,80005cf4 <sys_unlink+0x1b0>
    80005ba0:	00003597          	auipc	a1,0x3
    80005ba4:	b2858593          	addi	a1,a1,-1240 # 800086c8 <etext+0x6c8>
    80005ba8:	fb040513          	addi	a0,s0,-80
    80005bac:	ffffe097          	auipc	ra,0xffffe
    80005bb0:	628080e7          	jalr	1576(ra) # 800041d4 <namecmp>
    80005bb4:	14050063          	beqz	a0,80005cf4 <sys_unlink+0x1b0>
    80005bb8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005bba:	f2c40613          	addi	a2,s0,-212
    80005bbe:	fb040593          	addi	a1,s0,-80
    80005bc2:	8526                	mv	a0,s1
    80005bc4:	ffffe097          	auipc	ra,0xffffe
    80005bc8:	62a080e7          	jalr	1578(ra) # 800041ee <dirlookup>
    80005bcc:	892a                	mv	s2,a0
    80005bce:	12050263          	beqz	a0,80005cf2 <sys_unlink+0x1ae>
  ilock(ip);
    80005bd2:	ffffe097          	auipc	ra,0xffffe
    80005bd6:	110080e7          	jalr	272(ra) # 80003ce2 <ilock>
  if(ip->nlink < 1)
    80005bda:	04a91783          	lh	a5,74(s2)
    80005bde:	08f05563          	blez	a5,80005c68 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005be2:	04491703          	lh	a4,68(s2)
    80005be6:	4785                	li	a5,1
    80005be8:	08f70963          	beq	a4,a5,80005c7a <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005bec:	4641                	li	a2,16
    80005bee:	4581                	li	a1,0
    80005bf0:	fc040513          	addi	a0,s0,-64
    80005bf4:	ffffb097          	auipc	ra,0xffffb
    80005bf8:	140080e7          	jalr	320(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bfc:	4741                	li	a4,16
    80005bfe:	f2c42683          	lw	a3,-212(s0)
    80005c02:	fc040613          	addi	a2,s0,-64
    80005c06:	4581                	li	a1,0
    80005c08:	8526                	mv	a0,s1
    80005c0a:	ffffe097          	auipc	ra,0xffffe
    80005c0e:	4a0080e7          	jalr	1184(ra) # 800040aa <writei>
    80005c12:	47c1                	li	a5,16
    80005c14:	0af51b63          	bne	a0,a5,80005cca <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005c18:	04491703          	lh	a4,68(s2)
    80005c1c:	4785                	li	a5,1
    80005c1e:	0af70f63          	beq	a4,a5,80005cdc <sys_unlink+0x198>
  iunlockput(dp);
    80005c22:	8526                	mv	a0,s1
    80005c24:	ffffe097          	auipc	ra,0xffffe
    80005c28:	324080e7          	jalr	804(ra) # 80003f48 <iunlockput>
  ip->nlink--;
    80005c2c:	04a95783          	lhu	a5,74(s2)
    80005c30:	37fd                	addiw	a5,a5,-1
    80005c32:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c36:	854a                	mv	a0,s2
    80005c38:	ffffe097          	auipc	ra,0xffffe
    80005c3c:	fde080e7          	jalr	-34(ra) # 80003c16 <iupdate>
  iunlockput(ip);
    80005c40:	854a                	mv	a0,s2
    80005c42:	ffffe097          	auipc	ra,0xffffe
    80005c46:	306080e7          	jalr	774(ra) # 80003f48 <iunlockput>
  end_op();
    80005c4a:	fffff097          	auipc	ra,0xfffff
    80005c4e:	ae0080e7          	jalr	-1312(ra) # 8000472a <end_op>
  return 0;
    80005c52:	4501                	li	a0,0
    80005c54:	64ee                	ld	s1,216(sp)
    80005c56:	694e                	ld	s2,208(sp)
    80005c58:	a84d                	j	80005d0a <sys_unlink+0x1c6>
    end_op();
    80005c5a:	fffff097          	auipc	ra,0xfffff
    80005c5e:	ad0080e7          	jalr	-1328(ra) # 8000472a <end_op>
    return -1;
    80005c62:	557d                	li	a0,-1
    80005c64:	64ee                	ld	s1,216(sp)
    80005c66:	a055                	j	80005d0a <sys_unlink+0x1c6>
    80005c68:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005c6a:	00003517          	auipc	a0,0x3
    80005c6e:	a6650513          	addi	a0,a0,-1434 # 800086d0 <etext+0x6d0>
    80005c72:	ffffb097          	auipc	ra,0xffffb
    80005c76:	8ee080e7          	jalr	-1810(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c7a:	04c92703          	lw	a4,76(s2)
    80005c7e:	02000793          	li	a5,32
    80005c82:	f6e7f5e3          	bgeu	a5,a4,80005bec <sys_unlink+0xa8>
    80005c86:	e5ce                	sd	s3,200(sp)
    80005c88:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c8c:	4741                	li	a4,16
    80005c8e:	86ce                	mv	a3,s3
    80005c90:	f1840613          	addi	a2,s0,-232
    80005c94:	4581                	li	a1,0
    80005c96:	854a                	mv	a0,s2
    80005c98:	ffffe097          	auipc	ra,0xffffe
    80005c9c:	302080e7          	jalr	770(ra) # 80003f9a <readi>
    80005ca0:	47c1                	li	a5,16
    80005ca2:	00f51c63          	bne	a0,a5,80005cba <sys_unlink+0x176>
    if(de.inum != 0)
    80005ca6:	f1845783          	lhu	a5,-232(s0)
    80005caa:	e7b5                	bnez	a5,80005d16 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005cac:	29c1                	addiw	s3,s3,16
    80005cae:	04c92783          	lw	a5,76(s2)
    80005cb2:	fcf9ede3          	bltu	s3,a5,80005c8c <sys_unlink+0x148>
    80005cb6:	69ae                	ld	s3,200(sp)
    80005cb8:	bf15                	j	80005bec <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005cba:	00003517          	auipc	a0,0x3
    80005cbe:	a2e50513          	addi	a0,a0,-1490 # 800086e8 <etext+0x6e8>
    80005cc2:	ffffb097          	auipc	ra,0xffffb
    80005cc6:	89e080e7          	jalr	-1890(ra) # 80000560 <panic>
    80005cca:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005ccc:	00003517          	auipc	a0,0x3
    80005cd0:	a3450513          	addi	a0,a0,-1484 # 80008700 <etext+0x700>
    80005cd4:	ffffb097          	auipc	ra,0xffffb
    80005cd8:	88c080e7          	jalr	-1908(ra) # 80000560 <panic>
    dp->nlink--;
    80005cdc:	04a4d783          	lhu	a5,74(s1)
    80005ce0:	37fd                	addiw	a5,a5,-1
    80005ce2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ce6:	8526                	mv	a0,s1
    80005ce8:	ffffe097          	auipc	ra,0xffffe
    80005cec:	f2e080e7          	jalr	-210(ra) # 80003c16 <iupdate>
    80005cf0:	bf0d                	j	80005c22 <sys_unlink+0xde>
    80005cf2:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005cf4:	8526                	mv	a0,s1
    80005cf6:	ffffe097          	auipc	ra,0xffffe
    80005cfa:	252080e7          	jalr	594(ra) # 80003f48 <iunlockput>
  end_op();
    80005cfe:	fffff097          	auipc	ra,0xfffff
    80005d02:	a2c080e7          	jalr	-1492(ra) # 8000472a <end_op>
  return -1;
    80005d06:	557d                	li	a0,-1
    80005d08:	64ee                	ld	s1,216(sp)
}
    80005d0a:	70ae                	ld	ra,232(sp)
    80005d0c:	740e                	ld	s0,224(sp)
    80005d0e:	616d                	addi	sp,sp,240
    80005d10:	8082                	ret
    return -1;
    80005d12:	557d                	li	a0,-1
    80005d14:	bfdd                	j	80005d0a <sys_unlink+0x1c6>
    iunlockput(ip);
    80005d16:	854a                	mv	a0,s2
    80005d18:	ffffe097          	auipc	ra,0xffffe
    80005d1c:	230080e7          	jalr	560(ra) # 80003f48 <iunlockput>
    goto bad;
    80005d20:	694e                	ld	s2,208(sp)
    80005d22:	69ae                	ld	s3,200(sp)
    80005d24:	bfc1                	j	80005cf4 <sys_unlink+0x1b0>

0000000080005d26 <sys_open>:

uint64
sys_open(void)
{
    80005d26:	7131                	addi	sp,sp,-192
    80005d28:	fd06                	sd	ra,184(sp)
    80005d2a:	f922                	sd	s0,176(sp)
    80005d2c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d2e:	f4c40593          	addi	a1,s0,-180
    80005d32:	4505                	li	a0,1
    80005d34:	ffffd097          	auipc	ra,0xffffd
    80005d38:	35e080e7          	jalr	862(ra) # 80003092 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d3c:	08000613          	li	a2,128
    80005d40:	f5040593          	addi	a1,s0,-176
    80005d44:	4501                	li	a0,0
    80005d46:	ffffd097          	auipc	ra,0xffffd
    80005d4a:	38c080e7          	jalr	908(ra) # 800030d2 <argstr>
    80005d4e:	87aa                	mv	a5,a0
    return -1;
    80005d50:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d52:	0a07ce63          	bltz	a5,80005e0e <sys_open+0xe8>
    80005d56:	f526                	sd	s1,168(sp)

  begin_op();
    80005d58:	fffff097          	auipc	ra,0xfffff
    80005d5c:	958080e7          	jalr	-1704(ra) # 800046b0 <begin_op>

  if(omode & O_CREATE){
    80005d60:	f4c42783          	lw	a5,-180(s0)
    80005d64:	2007f793          	andi	a5,a5,512
    80005d68:	cfd5                	beqz	a5,80005e24 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005d6a:	4681                	li	a3,0
    80005d6c:	4601                	li	a2,0
    80005d6e:	4589                	li	a1,2
    80005d70:	f5040513          	addi	a0,s0,-176
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	95c080e7          	jalr	-1700(ra) # 800056d0 <create>
    80005d7c:	84aa                	mv	s1,a0
    if(ip == 0){
    80005d7e:	cd41                	beqz	a0,80005e16 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d80:	04449703          	lh	a4,68(s1)
    80005d84:	478d                	li	a5,3
    80005d86:	00f71763          	bne	a4,a5,80005d94 <sys_open+0x6e>
    80005d8a:	0464d703          	lhu	a4,70(s1)
    80005d8e:	47a5                	li	a5,9
    80005d90:	0ee7e163          	bltu	a5,a4,80005e72 <sys_open+0x14c>
    80005d94:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005d96:	fffff097          	auipc	ra,0xfffff
    80005d9a:	d28080e7          	jalr	-728(ra) # 80004abe <filealloc>
    80005d9e:	892a                	mv	s2,a0
    80005da0:	c97d                	beqz	a0,80005e96 <sys_open+0x170>
    80005da2:	ed4e                	sd	s3,152(sp)
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	8ea080e7          	jalr	-1814(ra) # 8000568e <fdalloc>
    80005dac:	89aa                	mv	s3,a0
    80005dae:	0c054e63          	bltz	a0,80005e8a <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005db2:	04449703          	lh	a4,68(s1)
    80005db6:	478d                	li	a5,3
    80005db8:	0ef70c63          	beq	a4,a5,80005eb0 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005dbc:	4789                	li	a5,2
    80005dbe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005dc2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005dc6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005dca:	f4c42783          	lw	a5,-180(s0)
    80005dce:	0017c713          	xori	a4,a5,1
    80005dd2:	8b05                	andi	a4,a4,1
    80005dd4:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005dd8:	0037f713          	andi	a4,a5,3
    80005ddc:	00e03733          	snez	a4,a4
    80005de0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005de4:	4007f793          	andi	a5,a5,1024
    80005de8:	c791                	beqz	a5,80005df4 <sys_open+0xce>
    80005dea:	04449703          	lh	a4,68(s1)
    80005dee:	4789                	li	a5,2
    80005df0:	0cf70763          	beq	a4,a5,80005ebe <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005df4:	8526                	mv	a0,s1
    80005df6:	ffffe097          	auipc	ra,0xffffe
    80005dfa:	fb2080e7          	jalr	-78(ra) # 80003da8 <iunlock>
  end_op();
    80005dfe:	fffff097          	auipc	ra,0xfffff
    80005e02:	92c080e7          	jalr	-1748(ra) # 8000472a <end_op>

  return fd;
    80005e06:	854e                	mv	a0,s3
    80005e08:	74aa                	ld	s1,168(sp)
    80005e0a:	790a                	ld	s2,160(sp)
    80005e0c:	69ea                	ld	s3,152(sp)
}
    80005e0e:	70ea                	ld	ra,184(sp)
    80005e10:	744a                	ld	s0,176(sp)
    80005e12:	6129                	addi	sp,sp,192
    80005e14:	8082                	ret
      end_op();
    80005e16:	fffff097          	auipc	ra,0xfffff
    80005e1a:	914080e7          	jalr	-1772(ra) # 8000472a <end_op>
      return -1;
    80005e1e:	557d                	li	a0,-1
    80005e20:	74aa                	ld	s1,168(sp)
    80005e22:	b7f5                	j	80005e0e <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005e24:	f5040513          	addi	a0,s0,-176
    80005e28:	ffffe097          	auipc	ra,0xffffe
    80005e2c:	688080e7          	jalr	1672(ra) # 800044b0 <namei>
    80005e30:	84aa                	mv	s1,a0
    80005e32:	c90d                	beqz	a0,80005e64 <sys_open+0x13e>
    ilock(ip);
    80005e34:	ffffe097          	auipc	ra,0xffffe
    80005e38:	eae080e7          	jalr	-338(ra) # 80003ce2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e3c:	04449703          	lh	a4,68(s1)
    80005e40:	4785                	li	a5,1
    80005e42:	f2f71fe3          	bne	a4,a5,80005d80 <sys_open+0x5a>
    80005e46:	f4c42783          	lw	a5,-180(s0)
    80005e4a:	d7a9                	beqz	a5,80005d94 <sys_open+0x6e>
      iunlockput(ip);
    80005e4c:	8526                	mv	a0,s1
    80005e4e:	ffffe097          	auipc	ra,0xffffe
    80005e52:	0fa080e7          	jalr	250(ra) # 80003f48 <iunlockput>
      end_op();
    80005e56:	fffff097          	auipc	ra,0xfffff
    80005e5a:	8d4080e7          	jalr	-1836(ra) # 8000472a <end_op>
      return -1;
    80005e5e:	557d                	li	a0,-1
    80005e60:	74aa                	ld	s1,168(sp)
    80005e62:	b775                	j	80005e0e <sys_open+0xe8>
      end_op();
    80005e64:	fffff097          	auipc	ra,0xfffff
    80005e68:	8c6080e7          	jalr	-1850(ra) # 8000472a <end_op>
      return -1;
    80005e6c:	557d                	li	a0,-1
    80005e6e:	74aa                	ld	s1,168(sp)
    80005e70:	bf79                	j	80005e0e <sys_open+0xe8>
    iunlockput(ip);
    80005e72:	8526                	mv	a0,s1
    80005e74:	ffffe097          	auipc	ra,0xffffe
    80005e78:	0d4080e7          	jalr	212(ra) # 80003f48 <iunlockput>
    end_op();
    80005e7c:	fffff097          	auipc	ra,0xfffff
    80005e80:	8ae080e7          	jalr	-1874(ra) # 8000472a <end_op>
    return -1;
    80005e84:	557d                	li	a0,-1
    80005e86:	74aa                	ld	s1,168(sp)
    80005e88:	b759                	j	80005e0e <sys_open+0xe8>
      fileclose(f);
    80005e8a:	854a                	mv	a0,s2
    80005e8c:	fffff097          	auipc	ra,0xfffff
    80005e90:	cee080e7          	jalr	-786(ra) # 80004b7a <fileclose>
    80005e94:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005e96:	8526                	mv	a0,s1
    80005e98:	ffffe097          	auipc	ra,0xffffe
    80005e9c:	0b0080e7          	jalr	176(ra) # 80003f48 <iunlockput>
    end_op();
    80005ea0:	fffff097          	auipc	ra,0xfffff
    80005ea4:	88a080e7          	jalr	-1910(ra) # 8000472a <end_op>
    return -1;
    80005ea8:	557d                	li	a0,-1
    80005eaa:	74aa                	ld	s1,168(sp)
    80005eac:	790a                	ld	s2,160(sp)
    80005eae:	b785                	j	80005e0e <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005eb0:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005eb4:	04649783          	lh	a5,70(s1)
    80005eb8:	02f91223          	sh	a5,36(s2)
    80005ebc:	b729                	j	80005dc6 <sys_open+0xa0>
    itrunc(ip);
    80005ebe:	8526                	mv	a0,s1
    80005ec0:	ffffe097          	auipc	ra,0xffffe
    80005ec4:	f34080e7          	jalr	-204(ra) # 80003df4 <itrunc>
    80005ec8:	b735                	j	80005df4 <sys_open+0xce>

0000000080005eca <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005eca:	7175                	addi	sp,sp,-144
    80005ecc:	e506                	sd	ra,136(sp)
    80005ece:	e122                	sd	s0,128(sp)
    80005ed0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005ed2:	ffffe097          	auipc	ra,0xffffe
    80005ed6:	7de080e7          	jalr	2014(ra) # 800046b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005eda:	08000613          	li	a2,128
    80005ede:	f7040593          	addi	a1,s0,-144
    80005ee2:	4501                	li	a0,0
    80005ee4:	ffffd097          	auipc	ra,0xffffd
    80005ee8:	1ee080e7          	jalr	494(ra) # 800030d2 <argstr>
    80005eec:	02054963          	bltz	a0,80005f1e <sys_mkdir+0x54>
    80005ef0:	4681                	li	a3,0
    80005ef2:	4601                	li	a2,0
    80005ef4:	4585                	li	a1,1
    80005ef6:	f7040513          	addi	a0,s0,-144
    80005efa:	fffff097          	auipc	ra,0xfffff
    80005efe:	7d6080e7          	jalr	2006(ra) # 800056d0 <create>
    80005f02:	cd11                	beqz	a0,80005f1e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f04:	ffffe097          	auipc	ra,0xffffe
    80005f08:	044080e7          	jalr	68(ra) # 80003f48 <iunlockput>
  end_op();
    80005f0c:	fffff097          	auipc	ra,0xfffff
    80005f10:	81e080e7          	jalr	-2018(ra) # 8000472a <end_op>
  return 0;
    80005f14:	4501                	li	a0,0
}
    80005f16:	60aa                	ld	ra,136(sp)
    80005f18:	640a                	ld	s0,128(sp)
    80005f1a:	6149                	addi	sp,sp,144
    80005f1c:	8082                	ret
    end_op();
    80005f1e:	fffff097          	auipc	ra,0xfffff
    80005f22:	80c080e7          	jalr	-2036(ra) # 8000472a <end_op>
    return -1;
    80005f26:	557d                	li	a0,-1
    80005f28:	b7fd                	j	80005f16 <sys_mkdir+0x4c>

0000000080005f2a <sys_mknod>:

uint64
sys_mknod(void)
{
    80005f2a:	7135                	addi	sp,sp,-160
    80005f2c:	ed06                	sd	ra,152(sp)
    80005f2e:	e922                	sd	s0,144(sp)
    80005f30:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005f32:	ffffe097          	auipc	ra,0xffffe
    80005f36:	77e080e7          	jalr	1918(ra) # 800046b0 <begin_op>
  argint(1, &major);
    80005f3a:	f6c40593          	addi	a1,s0,-148
    80005f3e:	4505                	li	a0,1
    80005f40:	ffffd097          	auipc	ra,0xffffd
    80005f44:	152080e7          	jalr	338(ra) # 80003092 <argint>
  argint(2, &minor);
    80005f48:	f6840593          	addi	a1,s0,-152
    80005f4c:	4509                	li	a0,2
    80005f4e:	ffffd097          	auipc	ra,0xffffd
    80005f52:	144080e7          	jalr	324(ra) # 80003092 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f56:	08000613          	li	a2,128
    80005f5a:	f7040593          	addi	a1,s0,-144
    80005f5e:	4501                	li	a0,0
    80005f60:	ffffd097          	auipc	ra,0xffffd
    80005f64:	172080e7          	jalr	370(ra) # 800030d2 <argstr>
    80005f68:	02054b63          	bltz	a0,80005f9e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f6c:	f6841683          	lh	a3,-152(s0)
    80005f70:	f6c41603          	lh	a2,-148(s0)
    80005f74:	458d                	li	a1,3
    80005f76:	f7040513          	addi	a0,s0,-144
    80005f7a:	fffff097          	auipc	ra,0xfffff
    80005f7e:	756080e7          	jalr	1878(ra) # 800056d0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f82:	cd11                	beqz	a0,80005f9e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f84:	ffffe097          	auipc	ra,0xffffe
    80005f88:	fc4080e7          	jalr	-60(ra) # 80003f48 <iunlockput>
  end_op();
    80005f8c:	ffffe097          	auipc	ra,0xffffe
    80005f90:	79e080e7          	jalr	1950(ra) # 8000472a <end_op>
  return 0;
    80005f94:	4501                	li	a0,0
}
    80005f96:	60ea                	ld	ra,152(sp)
    80005f98:	644a                	ld	s0,144(sp)
    80005f9a:	610d                	addi	sp,sp,160
    80005f9c:	8082                	ret
    end_op();
    80005f9e:	ffffe097          	auipc	ra,0xffffe
    80005fa2:	78c080e7          	jalr	1932(ra) # 8000472a <end_op>
    return -1;
    80005fa6:	557d                	li	a0,-1
    80005fa8:	b7fd                	j	80005f96 <sys_mknod+0x6c>

0000000080005faa <sys_chdir>:

uint64
sys_chdir(void)
{
    80005faa:	7135                	addi	sp,sp,-160
    80005fac:	ed06                	sd	ra,152(sp)
    80005fae:	e922                	sd	s0,144(sp)
    80005fb0:	e14a                	sd	s2,128(sp)
    80005fb2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005fb4:	ffffc097          	auipc	ra,0xffffc
    80005fb8:	d3a080e7          	jalr	-710(ra) # 80001cee <myproc>
    80005fbc:	892a                	mv	s2,a0
  
  begin_op();
    80005fbe:	ffffe097          	auipc	ra,0xffffe
    80005fc2:	6f2080e7          	jalr	1778(ra) # 800046b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005fc6:	08000613          	li	a2,128
    80005fca:	f6040593          	addi	a1,s0,-160
    80005fce:	4501                	li	a0,0
    80005fd0:	ffffd097          	auipc	ra,0xffffd
    80005fd4:	102080e7          	jalr	258(ra) # 800030d2 <argstr>
    80005fd8:	04054d63          	bltz	a0,80006032 <sys_chdir+0x88>
    80005fdc:	e526                	sd	s1,136(sp)
    80005fde:	f6040513          	addi	a0,s0,-160
    80005fe2:	ffffe097          	auipc	ra,0xffffe
    80005fe6:	4ce080e7          	jalr	1230(ra) # 800044b0 <namei>
    80005fea:	84aa                	mv	s1,a0
    80005fec:	c131                	beqz	a0,80006030 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005fee:	ffffe097          	auipc	ra,0xffffe
    80005ff2:	cf4080e7          	jalr	-780(ra) # 80003ce2 <ilock>
  if(ip->type != T_DIR){
    80005ff6:	04449703          	lh	a4,68(s1)
    80005ffa:	4785                	li	a5,1
    80005ffc:	04f71163          	bne	a4,a5,8000603e <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006000:	8526                	mv	a0,s1
    80006002:	ffffe097          	auipc	ra,0xffffe
    80006006:	da6080e7          	jalr	-602(ra) # 80003da8 <iunlock>
  iput(p->cwd);
    8000600a:	15893503          	ld	a0,344(s2)
    8000600e:	ffffe097          	auipc	ra,0xffffe
    80006012:	e92080e7          	jalr	-366(ra) # 80003ea0 <iput>
  end_op();
    80006016:	ffffe097          	auipc	ra,0xffffe
    8000601a:	714080e7          	jalr	1812(ra) # 8000472a <end_op>
  p->cwd = ip;
    8000601e:	14993c23          	sd	s1,344(s2)
  return 0;
    80006022:	4501                	li	a0,0
    80006024:	64aa                	ld	s1,136(sp)
}
    80006026:	60ea                	ld	ra,152(sp)
    80006028:	644a                	ld	s0,144(sp)
    8000602a:	690a                	ld	s2,128(sp)
    8000602c:	610d                	addi	sp,sp,160
    8000602e:	8082                	ret
    80006030:	64aa                	ld	s1,136(sp)
    end_op();
    80006032:	ffffe097          	auipc	ra,0xffffe
    80006036:	6f8080e7          	jalr	1784(ra) # 8000472a <end_op>
    return -1;
    8000603a:	557d                	li	a0,-1
    8000603c:	b7ed                	j	80006026 <sys_chdir+0x7c>
    iunlockput(ip);
    8000603e:	8526                	mv	a0,s1
    80006040:	ffffe097          	auipc	ra,0xffffe
    80006044:	f08080e7          	jalr	-248(ra) # 80003f48 <iunlockput>
    end_op();
    80006048:	ffffe097          	auipc	ra,0xffffe
    8000604c:	6e2080e7          	jalr	1762(ra) # 8000472a <end_op>
    return -1;
    80006050:	557d                	li	a0,-1
    80006052:	64aa                	ld	s1,136(sp)
    80006054:	bfc9                	j	80006026 <sys_chdir+0x7c>

0000000080006056 <sys_exec>:

uint64
sys_exec(void)
{
    80006056:	7121                	addi	sp,sp,-448
    80006058:	ff06                	sd	ra,440(sp)
    8000605a:	fb22                	sd	s0,432(sp)
    8000605c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000605e:	e4840593          	addi	a1,s0,-440
    80006062:	4505                	li	a0,1
    80006064:	ffffd097          	auipc	ra,0xffffd
    80006068:	04e080e7          	jalr	78(ra) # 800030b2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000606c:	08000613          	li	a2,128
    80006070:	f5040593          	addi	a1,s0,-176
    80006074:	4501                	li	a0,0
    80006076:	ffffd097          	auipc	ra,0xffffd
    8000607a:	05c080e7          	jalr	92(ra) # 800030d2 <argstr>
    8000607e:	87aa                	mv	a5,a0
    return -1;
    80006080:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006082:	0e07c263          	bltz	a5,80006166 <sys_exec+0x110>
    80006086:	f726                	sd	s1,424(sp)
    80006088:	f34a                	sd	s2,416(sp)
    8000608a:	ef4e                	sd	s3,408(sp)
    8000608c:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000608e:	10000613          	li	a2,256
    80006092:	4581                	li	a1,0
    80006094:	e5040513          	addi	a0,s0,-432
    80006098:	ffffb097          	auipc	ra,0xffffb
    8000609c:	c9c080e7          	jalr	-868(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800060a0:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800060a4:	89a6                	mv	s3,s1
    800060a6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800060a8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060ac:	00391513          	slli	a0,s2,0x3
    800060b0:	e4040593          	addi	a1,s0,-448
    800060b4:	e4843783          	ld	a5,-440(s0)
    800060b8:	953e                	add	a0,a0,a5
    800060ba:	ffffd097          	auipc	ra,0xffffd
    800060be:	f3a080e7          	jalr	-198(ra) # 80002ff4 <fetchaddr>
    800060c2:	02054a63          	bltz	a0,800060f6 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800060c6:	e4043783          	ld	a5,-448(s0)
    800060ca:	c7b9                	beqz	a5,80006118 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800060cc:	ffffb097          	auipc	ra,0xffffb
    800060d0:	a7c080e7          	jalr	-1412(ra) # 80000b48 <kalloc>
    800060d4:	85aa                	mv	a1,a0
    800060d6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800060da:	cd11                	beqz	a0,800060f6 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060dc:	6605                	lui	a2,0x1
    800060de:	e4043503          	ld	a0,-448(s0)
    800060e2:	ffffd097          	auipc	ra,0xffffd
    800060e6:	f64080e7          	jalr	-156(ra) # 80003046 <fetchstr>
    800060ea:	00054663          	bltz	a0,800060f6 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    800060ee:	0905                	addi	s2,s2,1
    800060f0:	09a1                	addi	s3,s3,8
    800060f2:	fb491de3          	bne	s2,s4,800060ac <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060f6:	f5040913          	addi	s2,s0,-176
    800060fa:	6088                	ld	a0,0(s1)
    800060fc:	c125                	beqz	a0,8000615c <sys_exec+0x106>
    kfree(argv[i]);
    800060fe:	ffffb097          	auipc	ra,0xffffb
    80006102:	94c080e7          	jalr	-1716(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006106:	04a1                	addi	s1,s1,8
    80006108:	ff2499e3          	bne	s1,s2,800060fa <sys_exec+0xa4>
  return -1;
    8000610c:	557d                	li	a0,-1
    8000610e:	74ba                	ld	s1,424(sp)
    80006110:	791a                	ld	s2,416(sp)
    80006112:	69fa                	ld	s3,408(sp)
    80006114:	6a5a                	ld	s4,400(sp)
    80006116:	a881                	j	80006166 <sys_exec+0x110>
      argv[i] = 0;
    80006118:	0009079b          	sext.w	a5,s2
    8000611c:	078e                	slli	a5,a5,0x3
    8000611e:	fd078793          	addi	a5,a5,-48
    80006122:	97a2                	add	a5,a5,s0
    80006124:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80006128:	e5040593          	addi	a1,s0,-432
    8000612c:	f5040513          	addi	a0,s0,-176
    80006130:	fffff097          	auipc	ra,0xfffff
    80006134:	120080e7          	jalr	288(ra) # 80005250 <exec>
    80006138:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000613a:	f5040993          	addi	s3,s0,-176
    8000613e:	6088                	ld	a0,0(s1)
    80006140:	c901                	beqz	a0,80006150 <sys_exec+0xfa>
    kfree(argv[i]);
    80006142:	ffffb097          	auipc	ra,0xffffb
    80006146:	908080e7          	jalr	-1784(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000614a:	04a1                	addi	s1,s1,8
    8000614c:	ff3499e3          	bne	s1,s3,8000613e <sys_exec+0xe8>
  return ret;
    80006150:	854a                	mv	a0,s2
    80006152:	74ba                	ld	s1,424(sp)
    80006154:	791a                	ld	s2,416(sp)
    80006156:	69fa                	ld	s3,408(sp)
    80006158:	6a5a                	ld	s4,400(sp)
    8000615a:	a031                	j	80006166 <sys_exec+0x110>
  return -1;
    8000615c:	557d                	li	a0,-1
    8000615e:	74ba                	ld	s1,424(sp)
    80006160:	791a                	ld	s2,416(sp)
    80006162:	69fa                	ld	s3,408(sp)
    80006164:	6a5a                	ld	s4,400(sp)
}
    80006166:	70fa                	ld	ra,440(sp)
    80006168:	745a                	ld	s0,432(sp)
    8000616a:	6139                	addi	sp,sp,448
    8000616c:	8082                	ret

000000008000616e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000616e:	7139                	addi	sp,sp,-64
    80006170:	fc06                	sd	ra,56(sp)
    80006172:	f822                	sd	s0,48(sp)
    80006174:	f426                	sd	s1,40(sp)
    80006176:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006178:	ffffc097          	auipc	ra,0xffffc
    8000617c:	b76080e7          	jalr	-1162(ra) # 80001cee <myproc>
    80006180:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006182:	fd840593          	addi	a1,s0,-40
    80006186:	4501                	li	a0,0
    80006188:	ffffd097          	auipc	ra,0xffffd
    8000618c:	f2a080e7          	jalr	-214(ra) # 800030b2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006190:	fc840593          	addi	a1,s0,-56
    80006194:	fd040513          	addi	a0,s0,-48
    80006198:	fffff097          	auipc	ra,0xfffff
    8000619c:	d50080e7          	jalr	-688(ra) # 80004ee8 <pipealloc>
    return -1;
    800061a0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800061a2:	0c054463          	bltz	a0,8000626a <sys_pipe+0xfc>
  fd0 = -1;
    800061a6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800061aa:	fd043503          	ld	a0,-48(s0)
    800061ae:	fffff097          	auipc	ra,0xfffff
    800061b2:	4e0080e7          	jalr	1248(ra) # 8000568e <fdalloc>
    800061b6:	fca42223          	sw	a0,-60(s0)
    800061ba:	08054b63          	bltz	a0,80006250 <sys_pipe+0xe2>
    800061be:	fc843503          	ld	a0,-56(s0)
    800061c2:	fffff097          	auipc	ra,0xfffff
    800061c6:	4cc080e7          	jalr	1228(ra) # 8000568e <fdalloc>
    800061ca:	fca42023          	sw	a0,-64(s0)
    800061ce:	06054863          	bltz	a0,8000623e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800061d2:	4691                	li	a3,4
    800061d4:	fc440613          	addi	a2,s0,-60
    800061d8:	fd843583          	ld	a1,-40(s0)
    800061dc:	6ca8                	ld	a0,88(s1)
    800061de:	ffffb097          	auipc	ra,0xffffb
    800061e2:	504080e7          	jalr	1284(ra) # 800016e2 <copyout>
    800061e6:	02054063          	bltz	a0,80006206 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800061ea:	4691                	li	a3,4
    800061ec:	fc040613          	addi	a2,s0,-64
    800061f0:	fd843583          	ld	a1,-40(s0)
    800061f4:	0591                	addi	a1,a1,4
    800061f6:	6ca8                	ld	a0,88(s1)
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	4ea080e7          	jalr	1258(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006200:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006202:	06055463          	bgez	a0,8000626a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006206:	fc442783          	lw	a5,-60(s0)
    8000620a:	07e9                	addi	a5,a5,26
    8000620c:	078e                	slli	a5,a5,0x3
    8000620e:	97a6                	add	a5,a5,s1
    80006210:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80006214:	fc042783          	lw	a5,-64(s0)
    80006218:	07e9                	addi	a5,a5,26
    8000621a:	078e                	slli	a5,a5,0x3
    8000621c:	94be                	add	s1,s1,a5
    8000621e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80006222:	fd043503          	ld	a0,-48(s0)
    80006226:	fffff097          	auipc	ra,0xfffff
    8000622a:	954080e7          	jalr	-1708(ra) # 80004b7a <fileclose>
    fileclose(wf);
    8000622e:	fc843503          	ld	a0,-56(s0)
    80006232:	fffff097          	auipc	ra,0xfffff
    80006236:	948080e7          	jalr	-1720(ra) # 80004b7a <fileclose>
    return -1;
    8000623a:	57fd                	li	a5,-1
    8000623c:	a03d                	j	8000626a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000623e:	fc442783          	lw	a5,-60(s0)
    80006242:	0007c763          	bltz	a5,80006250 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006246:	07e9                	addi	a5,a5,26
    80006248:	078e                	slli	a5,a5,0x3
    8000624a:	97a6                	add	a5,a5,s1
    8000624c:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80006250:	fd043503          	ld	a0,-48(s0)
    80006254:	fffff097          	auipc	ra,0xfffff
    80006258:	926080e7          	jalr	-1754(ra) # 80004b7a <fileclose>
    fileclose(wf);
    8000625c:	fc843503          	ld	a0,-56(s0)
    80006260:	fffff097          	auipc	ra,0xfffff
    80006264:	91a080e7          	jalr	-1766(ra) # 80004b7a <fileclose>
    return -1;
    80006268:	57fd                	li	a5,-1
}
    8000626a:	853e                	mv	a0,a5
    8000626c:	70e2                	ld	ra,56(sp)
    8000626e:	7442                	ld	s0,48(sp)
    80006270:	74a2                	ld	s1,40(sp)
    80006272:	6121                	addi	sp,sp,64
    80006274:	8082                	ret
	...

0000000080006280 <kernelvec>:
    80006280:	7111                	addi	sp,sp,-256
    80006282:	e006                	sd	ra,0(sp)
    80006284:	e40a                	sd	sp,8(sp)
    80006286:	e80e                	sd	gp,16(sp)
    80006288:	ec12                	sd	tp,24(sp)
    8000628a:	f016                	sd	t0,32(sp)
    8000628c:	f41a                	sd	t1,40(sp)
    8000628e:	f81e                	sd	t2,48(sp)
    80006290:	fc22                	sd	s0,56(sp)
    80006292:	e0a6                	sd	s1,64(sp)
    80006294:	e4aa                	sd	a0,72(sp)
    80006296:	e8ae                	sd	a1,80(sp)
    80006298:	ecb2                	sd	a2,88(sp)
    8000629a:	f0b6                	sd	a3,96(sp)
    8000629c:	f4ba                	sd	a4,104(sp)
    8000629e:	f8be                	sd	a5,112(sp)
    800062a0:	fcc2                	sd	a6,120(sp)
    800062a2:	e146                	sd	a7,128(sp)
    800062a4:	e54a                	sd	s2,136(sp)
    800062a6:	e94e                	sd	s3,144(sp)
    800062a8:	ed52                	sd	s4,152(sp)
    800062aa:	f156                	sd	s5,160(sp)
    800062ac:	f55a                	sd	s6,168(sp)
    800062ae:	f95e                	sd	s7,176(sp)
    800062b0:	fd62                	sd	s8,184(sp)
    800062b2:	e1e6                	sd	s9,192(sp)
    800062b4:	e5ea                	sd	s10,200(sp)
    800062b6:	e9ee                	sd	s11,208(sp)
    800062b8:	edf2                	sd	t3,216(sp)
    800062ba:	f1f6                	sd	t4,224(sp)
    800062bc:	f5fa                	sd	t5,232(sp)
    800062be:	f9fe                	sd	t6,240(sp)
    800062c0:	bfffc0ef          	jal	80002ebe <kerneltrap>
    800062c4:	6082                	ld	ra,0(sp)
    800062c6:	6122                	ld	sp,8(sp)
    800062c8:	61c2                	ld	gp,16(sp)
    800062ca:	7282                	ld	t0,32(sp)
    800062cc:	7322                	ld	t1,40(sp)
    800062ce:	73c2                	ld	t2,48(sp)
    800062d0:	7462                	ld	s0,56(sp)
    800062d2:	6486                	ld	s1,64(sp)
    800062d4:	6526                	ld	a0,72(sp)
    800062d6:	65c6                	ld	a1,80(sp)
    800062d8:	6666                	ld	a2,88(sp)
    800062da:	7686                	ld	a3,96(sp)
    800062dc:	7726                	ld	a4,104(sp)
    800062de:	77c6                	ld	a5,112(sp)
    800062e0:	7866                	ld	a6,120(sp)
    800062e2:	688a                	ld	a7,128(sp)
    800062e4:	692a                	ld	s2,136(sp)
    800062e6:	69ca                	ld	s3,144(sp)
    800062e8:	6a6a                	ld	s4,152(sp)
    800062ea:	7a8a                	ld	s5,160(sp)
    800062ec:	7b2a                	ld	s6,168(sp)
    800062ee:	7bca                	ld	s7,176(sp)
    800062f0:	7c6a                	ld	s8,184(sp)
    800062f2:	6c8e                	ld	s9,192(sp)
    800062f4:	6d2e                	ld	s10,200(sp)
    800062f6:	6dce                	ld	s11,208(sp)
    800062f8:	6e6e                	ld	t3,216(sp)
    800062fa:	7e8e                	ld	t4,224(sp)
    800062fc:	7f2e                	ld	t5,232(sp)
    800062fe:	7fce                	ld	t6,240(sp)
    80006300:	6111                	addi	sp,sp,256
    80006302:	10200073          	sret
    80006306:	00000013          	nop
    8000630a:	00000013          	nop
    8000630e:	0001                	nop

0000000080006310 <timervec>:
    80006310:	34051573          	csrrw	a0,mscratch,a0
    80006314:	e10c                	sd	a1,0(a0)
    80006316:	e510                	sd	a2,8(a0)
    80006318:	e914                	sd	a3,16(a0)
    8000631a:	6d0c                	ld	a1,24(a0)
    8000631c:	7110                	ld	a2,32(a0)
    8000631e:	6194                	ld	a3,0(a1)
    80006320:	96b2                	add	a3,a3,a2
    80006322:	e194                	sd	a3,0(a1)
    80006324:	4589                	li	a1,2
    80006326:	14459073          	csrw	sip,a1
    8000632a:	6914                	ld	a3,16(a0)
    8000632c:	6510                	ld	a2,8(a0)
    8000632e:	610c                	ld	a1,0(a0)
    80006330:	34051573          	csrrw	a0,mscratch,a0
    80006334:	30200073          	mret
	...

000000008000633a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000633a:	1141                	addi	sp,sp,-16
    8000633c:	e422                	sd	s0,8(sp)
    8000633e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006340:	0c0007b7          	lui	a5,0xc000
    80006344:	4705                	li	a4,1
    80006346:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006348:	0c0007b7          	lui	a5,0xc000
    8000634c:	c3d8                	sw	a4,4(a5)
}
    8000634e:	6422                	ld	s0,8(sp)
    80006350:	0141                	addi	sp,sp,16
    80006352:	8082                	ret

0000000080006354 <plicinithart>:

void
plicinithart(void)
{
    80006354:	1141                	addi	sp,sp,-16
    80006356:	e406                	sd	ra,8(sp)
    80006358:	e022                	sd	s0,0(sp)
    8000635a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000635c:	ffffc097          	auipc	ra,0xffffc
    80006360:	966080e7          	jalr	-1690(ra) # 80001cc2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006364:	0085171b          	slliw	a4,a0,0x8
    80006368:	0c0027b7          	lui	a5,0xc002
    8000636c:	97ba                	add	a5,a5,a4
    8000636e:	40200713          	li	a4,1026
    80006372:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006376:	00d5151b          	slliw	a0,a0,0xd
    8000637a:	0c2017b7          	lui	a5,0xc201
    8000637e:	97aa                	add	a5,a5,a0
    80006380:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006384:	60a2                	ld	ra,8(sp)
    80006386:	6402                	ld	s0,0(sp)
    80006388:	0141                	addi	sp,sp,16
    8000638a:	8082                	ret

000000008000638c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000638c:	1141                	addi	sp,sp,-16
    8000638e:	e406                	sd	ra,8(sp)
    80006390:	e022                	sd	s0,0(sp)
    80006392:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006394:	ffffc097          	auipc	ra,0xffffc
    80006398:	92e080e7          	jalr	-1746(ra) # 80001cc2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000639c:	00d5151b          	slliw	a0,a0,0xd
    800063a0:	0c2017b7          	lui	a5,0xc201
    800063a4:	97aa                	add	a5,a5,a0
  return irq;
}
    800063a6:	43c8                	lw	a0,4(a5)
    800063a8:	60a2                	ld	ra,8(sp)
    800063aa:	6402                	ld	s0,0(sp)
    800063ac:	0141                	addi	sp,sp,16
    800063ae:	8082                	ret

00000000800063b0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800063b0:	1101                	addi	sp,sp,-32
    800063b2:	ec06                	sd	ra,24(sp)
    800063b4:	e822                	sd	s0,16(sp)
    800063b6:	e426                	sd	s1,8(sp)
    800063b8:	1000                	addi	s0,sp,32
    800063ba:	84aa                	mv	s1,a0
  int hart = cpuid();
    800063bc:	ffffc097          	auipc	ra,0xffffc
    800063c0:	906080e7          	jalr	-1786(ra) # 80001cc2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800063c4:	00d5151b          	slliw	a0,a0,0xd
    800063c8:	0c2017b7          	lui	a5,0xc201
    800063cc:	97aa                	add	a5,a5,a0
    800063ce:	c3c4                	sw	s1,4(a5)
}
    800063d0:	60e2                	ld	ra,24(sp)
    800063d2:	6442                	ld	s0,16(sp)
    800063d4:	64a2                	ld	s1,8(sp)
    800063d6:	6105                	addi	sp,sp,32
    800063d8:	8082                	ret

00000000800063da <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800063da:	1141                	addi	sp,sp,-16
    800063dc:	e406                	sd	ra,8(sp)
    800063de:	e022                	sd	s0,0(sp)
    800063e0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800063e2:	479d                	li	a5,7
    800063e4:	04a7cc63          	blt	a5,a0,8000643c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800063e8:	0001e797          	auipc	a5,0x1e
    800063ec:	65878793          	addi	a5,a5,1624 # 80024a40 <disk>
    800063f0:	97aa                	add	a5,a5,a0
    800063f2:	0187c783          	lbu	a5,24(a5)
    800063f6:	ebb9                	bnez	a5,8000644c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800063f8:	00451693          	slli	a3,a0,0x4
    800063fc:	0001e797          	auipc	a5,0x1e
    80006400:	64478793          	addi	a5,a5,1604 # 80024a40 <disk>
    80006404:	6398                	ld	a4,0(a5)
    80006406:	9736                	add	a4,a4,a3
    80006408:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000640c:	6398                	ld	a4,0(a5)
    8000640e:	9736                	add	a4,a4,a3
    80006410:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006414:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006418:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000641c:	97aa                	add	a5,a5,a0
    8000641e:	4705                	li	a4,1
    80006420:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006424:	0001e517          	auipc	a0,0x1e
    80006428:	63450513          	addi	a0,a0,1588 # 80024a58 <disk+0x18>
    8000642c:	ffffc097          	auipc	ra,0xffffc
    80006430:	10a080e7          	jalr	266(ra) # 80002536 <wakeup>
}
    80006434:	60a2                	ld	ra,8(sp)
    80006436:	6402                	ld	s0,0(sp)
    80006438:	0141                	addi	sp,sp,16
    8000643a:	8082                	ret
    panic("free_desc 1");
    8000643c:	00002517          	auipc	a0,0x2
    80006440:	2d450513          	addi	a0,a0,724 # 80008710 <etext+0x710>
    80006444:	ffffa097          	auipc	ra,0xffffa
    80006448:	11c080e7          	jalr	284(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000644c:	00002517          	auipc	a0,0x2
    80006450:	2d450513          	addi	a0,a0,724 # 80008720 <etext+0x720>
    80006454:	ffffa097          	auipc	ra,0xffffa
    80006458:	10c080e7          	jalr	268(ra) # 80000560 <panic>

000000008000645c <virtio_disk_init>:
{
    8000645c:	1101                	addi	sp,sp,-32
    8000645e:	ec06                	sd	ra,24(sp)
    80006460:	e822                	sd	s0,16(sp)
    80006462:	e426                	sd	s1,8(sp)
    80006464:	e04a                	sd	s2,0(sp)
    80006466:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006468:	00002597          	auipc	a1,0x2
    8000646c:	2c858593          	addi	a1,a1,712 # 80008730 <etext+0x730>
    80006470:	0001e517          	auipc	a0,0x1e
    80006474:	6f850513          	addi	a0,a0,1784 # 80024b68 <disk+0x128>
    80006478:	ffffa097          	auipc	ra,0xffffa
    8000647c:	730080e7          	jalr	1840(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006480:	100017b7          	lui	a5,0x10001
    80006484:	4398                	lw	a4,0(a5)
    80006486:	2701                	sext.w	a4,a4
    80006488:	747277b7          	lui	a5,0x74727
    8000648c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006490:	18f71c63          	bne	a4,a5,80006628 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006494:	100017b7          	lui	a5,0x10001
    80006498:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000649a:	439c                	lw	a5,0(a5)
    8000649c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000649e:	4709                	li	a4,2
    800064a0:	18e79463          	bne	a5,a4,80006628 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064a4:	100017b7          	lui	a5,0x10001
    800064a8:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800064aa:	439c                	lw	a5,0(a5)
    800064ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064ae:	16e79d63          	bne	a5,a4,80006628 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800064b2:	100017b7          	lui	a5,0x10001
    800064b6:	47d8                	lw	a4,12(a5)
    800064b8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064ba:	554d47b7          	lui	a5,0x554d4
    800064be:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800064c2:	16f71363          	bne	a4,a5,80006628 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064c6:	100017b7          	lui	a5,0x10001
    800064ca:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064ce:	4705                	li	a4,1
    800064d0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064d2:	470d                	li	a4,3
    800064d4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800064d6:	10001737          	lui	a4,0x10001
    800064da:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800064dc:	c7ffe737          	lui	a4,0xc7ffe
    800064e0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9bdf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800064e4:	8ef9                	and	a3,a3,a4
    800064e6:	10001737          	lui	a4,0x10001
    800064ea:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064ec:	472d                	li	a4,11
    800064ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064f0:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800064f4:	439c                	lw	a5,0(a5)
    800064f6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800064fa:	8ba1                	andi	a5,a5,8
    800064fc:	12078e63          	beqz	a5,80006638 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006500:	100017b7          	lui	a5,0x10001
    80006504:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006508:	100017b7          	lui	a5,0x10001
    8000650c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006510:	439c                	lw	a5,0(a5)
    80006512:	2781                	sext.w	a5,a5
    80006514:	12079a63          	bnez	a5,80006648 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006518:	100017b7          	lui	a5,0x10001
    8000651c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006520:	439c                	lw	a5,0(a5)
    80006522:	2781                	sext.w	a5,a5
  if(max == 0)
    80006524:	12078a63          	beqz	a5,80006658 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006528:	471d                	li	a4,7
    8000652a:	12f77f63          	bgeu	a4,a5,80006668 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000652e:	ffffa097          	auipc	ra,0xffffa
    80006532:	61a080e7          	jalr	1562(ra) # 80000b48 <kalloc>
    80006536:	0001e497          	auipc	s1,0x1e
    8000653a:	50a48493          	addi	s1,s1,1290 # 80024a40 <disk>
    8000653e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006540:	ffffa097          	auipc	ra,0xffffa
    80006544:	608080e7          	jalr	1544(ra) # 80000b48 <kalloc>
    80006548:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000654a:	ffffa097          	auipc	ra,0xffffa
    8000654e:	5fe080e7          	jalr	1534(ra) # 80000b48 <kalloc>
    80006552:	87aa                	mv	a5,a0
    80006554:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006556:	6088                	ld	a0,0(s1)
    80006558:	12050063          	beqz	a0,80006678 <virtio_disk_init+0x21c>
    8000655c:	0001e717          	auipc	a4,0x1e
    80006560:	4ec73703          	ld	a4,1260(a4) # 80024a48 <disk+0x8>
    80006564:	10070a63          	beqz	a4,80006678 <virtio_disk_init+0x21c>
    80006568:	10078863          	beqz	a5,80006678 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000656c:	6605                	lui	a2,0x1
    8000656e:	4581                	li	a1,0
    80006570:	ffffa097          	auipc	ra,0xffffa
    80006574:	7c4080e7          	jalr	1988(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006578:	0001e497          	auipc	s1,0x1e
    8000657c:	4c848493          	addi	s1,s1,1224 # 80024a40 <disk>
    80006580:	6605                	lui	a2,0x1
    80006582:	4581                	li	a1,0
    80006584:	6488                	ld	a0,8(s1)
    80006586:	ffffa097          	auipc	ra,0xffffa
    8000658a:	7ae080e7          	jalr	1966(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    8000658e:	6605                	lui	a2,0x1
    80006590:	4581                	li	a1,0
    80006592:	6888                	ld	a0,16(s1)
    80006594:	ffffa097          	auipc	ra,0xffffa
    80006598:	7a0080e7          	jalr	1952(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000659c:	100017b7          	lui	a5,0x10001
    800065a0:	4721                	li	a4,8
    800065a2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800065a4:	4098                	lw	a4,0(s1)
    800065a6:	100017b7          	lui	a5,0x10001
    800065aa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800065ae:	40d8                	lw	a4,4(s1)
    800065b0:	100017b7          	lui	a5,0x10001
    800065b4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800065b8:	649c                	ld	a5,8(s1)
    800065ba:	0007869b          	sext.w	a3,a5
    800065be:	10001737          	lui	a4,0x10001
    800065c2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800065c6:	9781                	srai	a5,a5,0x20
    800065c8:	10001737          	lui	a4,0x10001
    800065cc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800065d0:	689c                	ld	a5,16(s1)
    800065d2:	0007869b          	sext.w	a3,a5
    800065d6:	10001737          	lui	a4,0x10001
    800065da:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800065de:	9781                	srai	a5,a5,0x20
    800065e0:	10001737          	lui	a4,0x10001
    800065e4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800065e8:	10001737          	lui	a4,0x10001
    800065ec:	4785                	li	a5,1
    800065ee:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800065f0:	00f48c23          	sb	a5,24(s1)
    800065f4:	00f48ca3          	sb	a5,25(s1)
    800065f8:	00f48d23          	sb	a5,26(s1)
    800065fc:	00f48da3          	sb	a5,27(s1)
    80006600:	00f48e23          	sb	a5,28(s1)
    80006604:	00f48ea3          	sb	a5,29(s1)
    80006608:	00f48f23          	sb	a5,30(s1)
    8000660c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006610:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006614:	100017b7          	lui	a5,0x10001
    80006618:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000661c:	60e2                	ld	ra,24(sp)
    8000661e:	6442                	ld	s0,16(sp)
    80006620:	64a2                	ld	s1,8(sp)
    80006622:	6902                	ld	s2,0(sp)
    80006624:	6105                	addi	sp,sp,32
    80006626:	8082                	ret
    panic("could not find virtio disk");
    80006628:	00002517          	auipc	a0,0x2
    8000662c:	11850513          	addi	a0,a0,280 # 80008740 <etext+0x740>
    80006630:	ffffa097          	auipc	ra,0xffffa
    80006634:	f30080e7          	jalr	-208(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006638:	00002517          	auipc	a0,0x2
    8000663c:	12850513          	addi	a0,a0,296 # 80008760 <etext+0x760>
    80006640:	ffffa097          	auipc	ra,0xffffa
    80006644:	f20080e7          	jalr	-224(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006648:	00002517          	auipc	a0,0x2
    8000664c:	13850513          	addi	a0,a0,312 # 80008780 <etext+0x780>
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	f10080e7          	jalr	-240(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006658:	00002517          	auipc	a0,0x2
    8000665c:	14850513          	addi	a0,a0,328 # 800087a0 <etext+0x7a0>
    80006660:	ffffa097          	auipc	ra,0xffffa
    80006664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006668:	00002517          	auipc	a0,0x2
    8000666c:	15850513          	addi	a0,a0,344 # 800087c0 <etext+0x7c0>
    80006670:	ffffa097          	auipc	ra,0xffffa
    80006674:	ef0080e7          	jalr	-272(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006678:	00002517          	auipc	a0,0x2
    8000667c:	16850513          	addi	a0,a0,360 # 800087e0 <etext+0x7e0>
    80006680:	ffffa097          	auipc	ra,0xffffa
    80006684:	ee0080e7          	jalr	-288(ra) # 80000560 <panic>

0000000080006688 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006688:	7159                	addi	sp,sp,-112
    8000668a:	f486                	sd	ra,104(sp)
    8000668c:	f0a2                	sd	s0,96(sp)
    8000668e:	eca6                	sd	s1,88(sp)
    80006690:	e8ca                	sd	s2,80(sp)
    80006692:	e4ce                	sd	s3,72(sp)
    80006694:	e0d2                	sd	s4,64(sp)
    80006696:	fc56                	sd	s5,56(sp)
    80006698:	f85a                	sd	s6,48(sp)
    8000669a:	f45e                	sd	s7,40(sp)
    8000669c:	f062                	sd	s8,32(sp)
    8000669e:	ec66                	sd	s9,24(sp)
    800066a0:	1880                	addi	s0,sp,112
    800066a2:	8a2a                	mv	s4,a0
    800066a4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800066a6:	00c52c83          	lw	s9,12(a0)
    800066aa:	001c9c9b          	slliw	s9,s9,0x1
    800066ae:	1c82                	slli	s9,s9,0x20
    800066b0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800066b4:	0001e517          	auipc	a0,0x1e
    800066b8:	4b450513          	addi	a0,a0,1204 # 80024b68 <disk+0x128>
    800066bc:	ffffa097          	auipc	ra,0xffffa
    800066c0:	57c080e7          	jalr	1404(ra) # 80000c38 <acquire>
  for(int i = 0; i < 3; i++){
    800066c4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800066c6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800066c8:	0001eb17          	auipc	s6,0x1e
    800066cc:	378b0b13          	addi	s6,s6,888 # 80024a40 <disk>
  for(int i = 0; i < 3; i++){
    800066d0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800066d2:	0001ec17          	auipc	s8,0x1e
    800066d6:	496c0c13          	addi	s8,s8,1174 # 80024b68 <disk+0x128>
    800066da:	a0ad                	j	80006744 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800066dc:	00fb0733          	add	a4,s6,a5
    800066e0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800066e4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800066e6:	0207c563          	bltz	a5,80006710 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800066ea:	2905                	addiw	s2,s2,1
    800066ec:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800066ee:	05590f63          	beq	s2,s5,8000674c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800066f2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800066f4:	0001e717          	auipc	a4,0x1e
    800066f8:	34c70713          	addi	a4,a4,844 # 80024a40 <disk>
    800066fc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800066fe:	01874683          	lbu	a3,24(a4)
    80006702:	fee9                	bnez	a3,800066dc <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006704:	2785                	addiw	a5,a5,1
    80006706:	0705                	addi	a4,a4,1
    80006708:	fe979be3          	bne	a5,s1,800066fe <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000670c:	57fd                	li	a5,-1
    8000670e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006710:	03205163          	blez	s2,80006732 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006714:	f9042503          	lw	a0,-112(s0)
    80006718:	00000097          	auipc	ra,0x0
    8000671c:	cc2080e7          	jalr	-830(ra) # 800063da <free_desc>
      for(int j = 0; j < i; j++)
    80006720:	4785                	li	a5,1
    80006722:	0127d863          	bge	a5,s2,80006732 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006726:	f9442503          	lw	a0,-108(s0)
    8000672a:	00000097          	auipc	ra,0x0
    8000672e:	cb0080e7          	jalr	-848(ra) # 800063da <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006732:	85e2                	mv	a1,s8
    80006734:	0001e517          	auipc	a0,0x1e
    80006738:	32450513          	addi	a0,a0,804 # 80024a58 <disk+0x18>
    8000673c:	ffffc097          	auipc	ra,0xffffc
    80006740:	d96080e7          	jalr	-618(ra) # 800024d2 <sleep>
  for(int i = 0; i < 3; i++){
    80006744:	f9040613          	addi	a2,s0,-112
    80006748:	894e                	mv	s2,s3
    8000674a:	b765                	j	800066f2 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000674c:	f9042503          	lw	a0,-112(s0)
    80006750:	00451693          	slli	a3,a0,0x4

  if(write)
    80006754:	0001e797          	auipc	a5,0x1e
    80006758:	2ec78793          	addi	a5,a5,748 # 80024a40 <disk>
    8000675c:	00a50713          	addi	a4,a0,10
    80006760:	0712                	slli	a4,a4,0x4
    80006762:	973e                	add	a4,a4,a5
    80006764:	01703633          	snez	a2,s7
    80006768:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000676a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000676e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006772:	6398                	ld	a4,0(a5)
    80006774:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006776:	0a868613          	addi	a2,a3,168
    8000677a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000677c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000677e:	6390                	ld	a2,0(a5)
    80006780:	00d605b3          	add	a1,a2,a3
    80006784:	4741                	li	a4,16
    80006786:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006788:	4805                	li	a6,1
    8000678a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000678e:	f9442703          	lw	a4,-108(s0)
    80006792:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006796:	0712                	slli	a4,a4,0x4
    80006798:	963a                	add	a2,a2,a4
    8000679a:	058a0593          	addi	a1,s4,88
    8000679e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800067a0:	0007b883          	ld	a7,0(a5)
    800067a4:	9746                	add	a4,a4,a7
    800067a6:	40000613          	li	a2,1024
    800067aa:	c710                	sw	a2,8(a4)
  if(write)
    800067ac:	001bb613          	seqz	a2,s7
    800067b0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800067b4:	00166613          	ori	a2,a2,1
    800067b8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800067bc:	f9842583          	lw	a1,-104(s0)
    800067c0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800067c4:	00250613          	addi	a2,a0,2
    800067c8:	0612                	slli	a2,a2,0x4
    800067ca:	963e                	add	a2,a2,a5
    800067cc:	577d                	li	a4,-1
    800067ce:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800067d2:	0592                	slli	a1,a1,0x4
    800067d4:	98ae                	add	a7,a7,a1
    800067d6:	03068713          	addi	a4,a3,48
    800067da:	973e                	add	a4,a4,a5
    800067dc:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800067e0:	6398                	ld	a4,0(a5)
    800067e2:	972e                	add	a4,a4,a1
    800067e4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800067e8:	4689                	li	a3,2
    800067ea:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800067ee:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800067f2:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800067f6:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800067fa:	6794                	ld	a3,8(a5)
    800067fc:	0026d703          	lhu	a4,2(a3)
    80006800:	8b1d                	andi	a4,a4,7
    80006802:	0706                	slli	a4,a4,0x1
    80006804:	96ba                	add	a3,a3,a4
    80006806:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000680a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000680e:	6798                	ld	a4,8(a5)
    80006810:	00275783          	lhu	a5,2(a4)
    80006814:	2785                	addiw	a5,a5,1
    80006816:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000681a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000681e:	100017b7          	lui	a5,0x10001
    80006822:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006826:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000682a:	0001e917          	auipc	s2,0x1e
    8000682e:	33e90913          	addi	s2,s2,830 # 80024b68 <disk+0x128>
  while(b->disk == 1) {
    80006832:	4485                	li	s1,1
    80006834:	01079c63          	bne	a5,a6,8000684c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006838:	85ca                	mv	a1,s2
    8000683a:	8552                	mv	a0,s4
    8000683c:	ffffc097          	auipc	ra,0xffffc
    80006840:	c96080e7          	jalr	-874(ra) # 800024d2 <sleep>
  while(b->disk == 1) {
    80006844:	004a2783          	lw	a5,4(s4)
    80006848:	fe9788e3          	beq	a5,s1,80006838 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000684c:	f9042903          	lw	s2,-112(s0)
    80006850:	00290713          	addi	a4,s2,2
    80006854:	0712                	slli	a4,a4,0x4
    80006856:	0001e797          	auipc	a5,0x1e
    8000685a:	1ea78793          	addi	a5,a5,490 # 80024a40 <disk>
    8000685e:	97ba                	add	a5,a5,a4
    80006860:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006864:	0001e997          	auipc	s3,0x1e
    80006868:	1dc98993          	addi	s3,s3,476 # 80024a40 <disk>
    8000686c:	00491713          	slli	a4,s2,0x4
    80006870:	0009b783          	ld	a5,0(s3)
    80006874:	97ba                	add	a5,a5,a4
    80006876:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000687a:	854a                	mv	a0,s2
    8000687c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006880:	00000097          	auipc	ra,0x0
    80006884:	b5a080e7          	jalr	-1190(ra) # 800063da <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006888:	8885                	andi	s1,s1,1
    8000688a:	f0ed                	bnez	s1,8000686c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000688c:	0001e517          	auipc	a0,0x1e
    80006890:	2dc50513          	addi	a0,a0,732 # 80024b68 <disk+0x128>
    80006894:	ffffa097          	auipc	ra,0xffffa
    80006898:	458080e7          	jalr	1112(ra) # 80000cec <release>
}
    8000689c:	70a6                	ld	ra,104(sp)
    8000689e:	7406                	ld	s0,96(sp)
    800068a0:	64e6                	ld	s1,88(sp)
    800068a2:	6946                	ld	s2,80(sp)
    800068a4:	69a6                	ld	s3,72(sp)
    800068a6:	6a06                	ld	s4,64(sp)
    800068a8:	7ae2                	ld	s5,56(sp)
    800068aa:	7b42                	ld	s6,48(sp)
    800068ac:	7ba2                	ld	s7,40(sp)
    800068ae:	7c02                	ld	s8,32(sp)
    800068b0:	6ce2                	ld	s9,24(sp)
    800068b2:	6165                	addi	sp,sp,112
    800068b4:	8082                	ret

00000000800068b6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800068b6:	1101                	addi	sp,sp,-32
    800068b8:	ec06                	sd	ra,24(sp)
    800068ba:	e822                	sd	s0,16(sp)
    800068bc:	e426                	sd	s1,8(sp)
    800068be:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800068c0:	0001e497          	auipc	s1,0x1e
    800068c4:	18048493          	addi	s1,s1,384 # 80024a40 <disk>
    800068c8:	0001e517          	auipc	a0,0x1e
    800068cc:	2a050513          	addi	a0,a0,672 # 80024b68 <disk+0x128>
    800068d0:	ffffa097          	auipc	ra,0xffffa
    800068d4:	368080e7          	jalr	872(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800068d8:	100017b7          	lui	a5,0x10001
    800068dc:	53b8                	lw	a4,96(a5)
    800068de:	8b0d                	andi	a4,a4,3
    800068e0:	100017b7          	lui	a5,0x10001
    800068e4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800068e6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800068ea:	689c                	ld	a5,16(s1)
    800068ec:	0204d703          	lhu	a4,32(s1)
    800068f0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800068f4:	04f70863          	beq	a4,a5,80006944 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    800068f8:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800068fc:	6898                	ld	a4,16(s1)
    800068fe:	0204d783          	lhu	a5,32(s1)
    80006902:	8b9d                	andi	a5,a5,7
    80006904:	078e                	slli	a5,a5,0x3
    80006906:	97ba                	add	a5,a5,a4
    80006908:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000690a:	00278713          	addi	a4,a5,2
    8000690e:	0712                	slli	a4,a4,0x4
    80006910:	9726                	add	a4,a4,s1
    80006912:	01074703          	lbu	a4,16(a4)
    80006916:	e721                	bnez	a4,8000695e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006918:	0789                	addi	a5,a5,2
    8000691a:	0792                	slli	a5,a5,0x4
    8000691c:	97a6                	add	a5,a5,s1
    8000691e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006920:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006924:	ffffc097          	auipc	ra,0xffffc
    80006928:	c12080e7          	jalr	-1006(ra) # 80002536 <wakeup>

    disk.used_idx += 1;
    8000692c:	0204d783          	lhu	a5,32(s1)
    80006930:	2785                	addiw	a5,a5,1
    80006932:	17c2                	slli	a5,a5,0x30
    80006934:	93c1                	srli	a5,a5,0x30
    80006936:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000693a:	6898                	ld	a4,16(s1)
    8000693c:	00275703          	lhu	a4,2(a4)
    80006940:	faf71ce3          	bne	a4,a5,800068f8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006944:	0001e517          	auipc	a0,0x1e
    80006948:	22450513          	addi	a0,a0,548 # 80024b68 <disk+0x128>
    8000694c:	ffffa097          	auipc	ra,0xffffa
    80006950:	3a0080e7          	jalr	928(ra) # 80000cec <release>
}
    80006954:	60e2                	ld	ra,24(sp)
    80006956:	6442                	ld	s0,16(sp)
    80006958:	64a2                	ld	s1,8(sp)
    8000695a:	6105                	addi	sp,sp,32
    8000695c:	8082                	ret
      panic("virtio_disk_intr status");
    8000695e:	00002517          	auipc	a0,0x2
    80006962:	e9a50513          	addi	a0,a0,-358 # 800087f8 <etext+0x7f8>
    80006966:	ffffa097          	auipc	ra,0xffffa
    8000696a:	bfa080e7          	jalr	-1030(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
