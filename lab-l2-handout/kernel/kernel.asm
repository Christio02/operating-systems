
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
    80000066:	2be78793          	addi	a5,a5,702 # 80006320 <timervec>
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
    8000012e:	81c080e7          	jalr	-2020(ra) # 80002946 <either_copyin>
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
    800001c0:	b48080e7          	jalr	-1208(ra) # 80001d04 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	5cc080e7          	jalr	1484(ra) # 80002790 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	316080e7          	jalr	790(ra) # 800024e8 <sleep>
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
    8000021e:	6d6080e7          	jalr	1750(ra) # 800028f0 <either_copyout>
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
    8000030c:	694080e7          	jalr	1684(ra) # 8000299c <procdump>
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
    8000046a:	0e6080e7          	jalr	230(ra) # 8000254c <wakeup>
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
    800008f6:	c5a080e7          	jalr	-934(ra) # 8000254c <wakeup>
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
    80000982:	b6a080e7          	jalr	-1174(ra) # 800024e8 <sleep>
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
    80000bd6:	116080e7          	jalr	278(ra) # 80001ce8 <mycpu>
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
    80000c08:	0e4080e7          	jalr	228(ra) # 80001ce8 <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	0d8080e7          	jalr	216(ra) # 80001ce8 <mycpu>
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
    80000c2c:	0c0080e7          	jalr	192(ra) # 80001ce8 <mycpu>
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
    80000c6c:	080080e7          	jalr	128(ra) # 80001ce8 <mycpu>
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
    80000c98:	054080e7          	jalr	84(ra) # 80001ce8 <mycpu>
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
    80000ede:	dfe080e7          	jalr	-514(ra) # 80001cd8 <cpuid>
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
    80000efa:	de2080e7          	jalr	-542(ra) # 80001cd8 <cpuid>
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
    80000f1c:	d0c080e7          	jalr	-756(ra) # 80002c24 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	444080e7          	jalr	1092(ra) # 80006364 <plicinithart>
  }

  scheduler();        
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	474080e7          	jalr	1140(ra) # 8000239c <scheduler>
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
    80000f8c:	c6a080e7          	jalr	-918(ra) # 80001bf2 <procinit>
    trapinit();      // trap vectors
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	c6c080e7          	jalr	-916(ra) # 80002bfc <trapinit>
    trapinithart();  // install kernel trap vector
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	c8c080e7          	jalr	-884(ra) # 80002c24 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	3aa080e7          	jalr	938(ra) # 8000634a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	3bc080e7          	jalr	956(ra) # 80006364 <plicinithart>
    binit();         // buffer cache
    80000fb0:	00002097          	auipc	ra,0x2
    80000fb4:	48a080e7          	jalr	1162(ra) # 8000343a <binit>
    iinit();         // inode table
    80000fb8:	00003097          	auipc	ra,0x3
    80000fbc:	b40080e7          	jalr	-1216(ra) # 80003af8 <iinit>
    fileinit();      // file table
    80000fc0:	00004097          	auipc	ra,0x4
    80000fc4:	af0080e7          	jalr	-1296(ra) # 80004ab0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	4a4080e7          	jalr	1188(ra) # 8000646c <virtio_disk_init>
    userinit();      // first user process
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	014080e7          	jalr	20(ra) # 80001fe4 <userinit>
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
    8000128c:	8c6080e7          	jalr	-1850(ra) # 80001b4e <proc_mapstacks>
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
    8000194a:	24c080e7          	jalr	588(ra) # 80002b92 <swtch>
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

    intr_on(); // enable time slicing


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
    80001a22:	07405e63          	blez	s4,80001a9e <mlfq_scheduler+0x136>
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
    80001a4e:	a829                	j	80001a68 <mlfq_scheduler+0x100>
            p->time_ticks++;
            int treshold = highTimeSlice;
            if (p->time_ticks >= treshold) {
                p->priority = 1;
            }
            p->time_ticks = 0;
    80001a50:	0404a223          	sw	zero,68(s1)
            c->proc = 0;
    80001a54:	000ab023          	sd	zero,0(s5)
            // update p->priority based on used time slice
           
        }

        release(&p->lock);
    80001a58:	8526                	mv	a0,s1
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	292080e7          	jalr	658(ra) # 80000cec <release>
    for (int i = 0; i < indexHigh; i++) {
    80001a62:	0921                	addi	s2,s2,8
    80001a64:	0b390e63          	beq	s2,s3,80001b20 <mlfq_scheduler+0x1b8>
        p = highPriority[i];
    80001a68:	00093483          	ld	s1,0(s2)
        acquire(&p->lock);
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	fffff097          	auipc	ra,0xfffff
    80001a72:	1ca080e7          	jalr	458(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE) {
    80001a76:	4c9c                	lw	a5,24(s1)
    80001a78:	ff4790e3          	bne	a5,s4,80001a58 <mlfq_scheduler+0xf0>
            p->state = RUNNING;
    80001a7c:	0184ac23          	sw	s8,24(s1)
            c->proc = p;
    80001a80:	009ab023          	sd	s1,0(s5)
            swtch(&c->context, &p->context);
    80001a84:	06848593          	addi	a1,s1,104
    80001a88:	855e                	mv	a0,s7
    80001a8a:	00001097          	auipc	ra,0x1
    80001a8e:	108080e7          	jalr	264(ra) # 80002b92 <swtch>
            if (p->time_ticks >= treshold) {
    80001a92:	40fc                	lw	a5,68(s1)
    80001a94:	fafa5ee3          	bge	s4,a5,80001a50 <mlfq_scheduler+0xe8>
                p->priority = 1;
    80001a98:	4785                	li	a5,1
    80001a9a:	c0bc                	sw	a5,64(s1)
    80001a9c:	bf55                	j	80001a50 <mlfq_scheduler+0xe8>

    }
    // if no process in high priority queue, then go through medium queue
    if (indexHigh == 0) {
    80001a9e:	080a1163          	bnez	s4,80001b20 <mlfq_scheduler+0x1b8>
        for (int i = 0; i < indexMed; i++) {
    80001aa2:	07505f63          	blez	s5,80001b20 <mlfq_scheduler+0x1b8>
            p = mediumPriority[i];
            acquire(&p->lock);
            if (p->state == RUNNABLE) {
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    80001aa6:	007b1b93          	slli	s7,s6,0x7
    80001aaa:	00012797          	auipc	a5,0x12
    80001aae:	cce78793          	addi	a5,a5,-818 # 80013778 <cpus+0x8>
    80001ab2:	9bbe                	add	s7,s7,a5
    80001ab4:	bb040993          	addi	s3,s0,-1104
    80001ab8:	003a9913          	slli	s2,s5,0x3
    80001abc:	994e                	add	s2,s2,s3
            if (p->state == RUNNABLE) {
    80001abe:	4a0d                	li	s4,3
                p->state = RUNNING;
    80001ac0:	4c11                	li	s8,4
                c->proc = p;
    80001ac2:	0b1e                	slli	s6,s6,0x7
    80001ac4:	00012a97          	auipc	s5,0x12
    80001ac8:	caca8a93          	addi	s5,s5,-852 # 80013770 <cpus>
    80001acc:	9ada                	add	s5,s5,s6
                p->time_ticks++;
                int treshold = medTimeSlice;
                if (p->time_ticks >= treshold) {
    80001ace:	4b21                	li	s6,8
    80001ad0:	a829                	j	80001aea <mlfq_scheduler+0x182>
                p->priority = 1;
            }
                p->time_ticks = 0;
    80001ad2:	0404a223          	sw	zero,68(s1)

                c->proc = 0;
    80001ad6:	000ab023          	sd	zero,0(s5)
                // update priority based on time slice

            }

            release(&p->lock);
    80001ada:	8526                	mv	a0,s1
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	210080e7          	jalr	528(ra) # 80000cec <release>
        for (int i = 0; i < indexMed; i++) {
    80001ae4:	09a1                	addi	s3,s3,8 # 1008 <_entry-0x7fffeff8>
    80001ae6:	03298d63          	beq	s3,s2,80001b20 <mlfq_scheduler+0x1b8>
            p = mediumPriority[i];
    80001aea:	0009b483          	ld	s1,0(s3)
            acquire(&p->lock);
    80001aee:	8526                	mv	a0,s1
    80001af0:	fffff097          	auipc	ra,0xfffff
    80001af4:	148080e7          	jalr	328(ra) # 80000c38 <acquire>
            if (p->state == RUNNABLE) {
    80001af8:	4c9c                	lw	a5,24(s1)
    80001afa:	ff4790e3          	bne	a5,s4,80001ada <mlfq_scheduler+0x172>
                p->state = RUNNING;
    80001afe:	0184ac23          	sw	s8,24(s1)
                c->proc = p;
    80001b02:	009ab023          	sd	s1,0(s5)
                swtch(&c->context, &p->context);
    80001b06:	06848593          	addi	a1,s1,104
    80001b0a:	855e                	mv	a0,s7
    80001b0c:	00001097          	auipc	ra,0x1
    80001b10:	086080e7          	jalr	134(ra) # 80002b92 <swtch>
                if (p->time_ticks >= treshold) {
    80001b14:	40fc                	lw	a5,68(s1)
    80001b16:	fafb5ee3          	bge	s6,a5,80001ad2 <mlfq_scheduler+0x16a>
                p->priority = 1;
    80001b1a:	4785                	li	a5,1
    80001b1c:	c0bc                	sw	a5,64(s1)
    80001b1e:	bf55                	j	80001ad2 <mlfq_scheduler+0x16a>

        }

    }

}
    80001b20:	44813083          	ld	ra,1096(sp)
    80001b24:	44013403          	ld	s0,1088(sp)
    80001b28:	43813483          	ld	s1,1080(sp)
    80001b2c:	43013903          	ld	s2,1072(sp)
    80001b30:	42813983          	ld	s3,1064(sp)
    80001b34:	42013a03          	ld	s4,1056(sp)
    80001b38:	41813a83          	ld	s5,1048(sp)
    80001b3c:	41013b03          	ld	s6,1040(sp)
    80001b40:	40813b83          	ld	s7,1032(sp)
    80001b44:	40013c03          	ld	s8,1024(sp)
    80001b48:	45010113          	addi	sp,sp,1104
    80001b4c:	8082                	ret

0000000080001b4e <proc_mapstacks>:
{
    80001b4e:	7139                	addi	sp,sp,-64
    80001b50:	fc06                	sd	ra,56(sp)
    80001b52:	f822                	sd	s0,48(sp)
    80001b54:	f426                	sd	s1,40(sp)
    80001b56:	f04a                	sd	s2,32(sp)
    80001b58:	ec4e                	sd	s3,24(sp)
    80001b5a:	e852                	sd	s4,16(sp)
    80001b5c:	e456                	sd	s5,8(sp)
    80001b5e:	e05a                	sd	s6,0(sp)
    80001b60:	0080                	addi	s0,sp,64
    80001b62:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001b64:	00012497          	auipc	s1,0x12
    80001b68:	03c48493          	addi	s1,s1,60 # 80013ba0 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001b6c:	8b26                	mv	s6,s1
    80001b6e:	ff4df937          	lui	s2,0xff4df
    80001b72:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e3d>
    80001b76:	0936                	slli	s2,s2,0xd
    80001b78:	6f590913          	addi	s2,s2,1781
    80001b7c:	0936                	slli	s2,s2,0xd
    80001b7e:	bd390913          	addi	s2,s2,-1069
    80001b82:	0932                	slli	s2,s2,0xc
    80001b84:	7a790913          	addi	s2,s2,1959
    80001b88:	040009b7          	lui	s3,0x4000
    80001b8c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b8e:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001b90:	00018a97          	auipc	s5,0x18
    80001b94:	c10a8a93          	addi	s5,s5,-1008 # 800197a0 <tickslock>
        char *pa = kalloc();
    80001b98:	fffff097          	auipc	ra,0xfffff
    80001b9c:	fb0080e7          	jalr	-80(ra) # 80000b48 <kalloc>
    80001ba0:	862a                	mv	a2,a0
        if (pa == 0)
    80001ba2:	c121                	beqz	a0,80001be2 <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80001ba4:	416485b3          	sub	a1,s1,s6
    80001ba8:	8591                	srai	a1,a1,0x4
    80001baa:	032585b3          	mul	a1,a1,s2
    80001bae:	2585                	addiw	a1,a1,1
    80001bb0:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bb4:	4719                	li	a4,6
    80001bb6:	6685                	lui	a3,0x1
    80001bb8:	40b985b3          	sub	a1,s3,a1
    80001bbc:	8552                	mv	a0,s4
    80001bbe:	fffff097          	auipc	ra,0xfffff
    80001bc2:	5da080e7          	jalr	1498(ra) # 80001198 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001bc6:	17048493          	addi	s1,s1,368
    80001bca:	fd5497e3          	bne	s1,s5,80001b98 <proc_mapstacks+0x4a>
}
    80001bce:	70e2                	ld	ra,56(sp)
    80001bd0:	7442                	ld	s0,48(sp)
    80001bd2:	74a2                	ld	s1,40(sp)
    80001bd4:	7902                	ld	s2,32(sp)
    80001bd6:	69e2                	ld	s3,24(sp)
    80001bd8:	6a42                	ld	s4,16(sp)
    80001bda:	6aa2                	ld	s5,8(sp)
    80001bdc:	6b02                	ld	s6,0(sp)
    80001bde:	6121                	addi	sp,sp,64
    80001be0:	8082                	ret
            panic("kalloc");
    80001be2:	00006517          	auipc	a0,0x6
    80001be6:	5d650513          	addi	a0,a0,1494 # 800081b8 <etext+0x1b8>
    80001bea:	fffff097          	auipc	ra,0xfffff
    80001bee:	976080e7          	jalr	-1674(ra) # 80000560 <panic>

0000000080001bf2 <procinit>:
{
    80001bf2:	7139                	addi	sp,sp,-64
    80001bf4:	fc06                	sd	ra,56(sp)
    80001bf6:	f822                	sd	s0,48(sp)
    80001bf8:	f426                	sd	s1,40(sp)
    80001bfa:	f04a                	sd	s2,32(sp)
    80001bfc:	ec4e                	sd	s3,24(sp)
    80001bfe:	e852                	sd	s4,16(sp)
    80001c00:	e456                	sd	s5,8(sp)
    80001c02:	e05a                	sd	s6,0(sp)
    80001c04:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001c06:	00006597          	auipc	a1,0x6
    80001c0a:	5ba58593          	addi	a1,a1,1466 # 800081c0 <etext+0x1c0>
    80001c0e:	00012517          	auipc	a0,0x12
    80001c12:	f6250513          	addi	a0,a0,-158 # 80013b70 <pid_lock>
    80001c16:	fffff097          	auipc	ra,0xfffff
    80001c1a:	f92080e7          	jalr	-110(ra) # 80000ba8 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001c1e:	00006597          	auipc	a1,0x6
    80001c22:	5aa58593          	addi	a1,a1,1450 # 800081c8 <etext+0x1c8>
    80001c26:	00012517          	auipc	a0,0x12
    80001c2a:	f6250513          	addi	a0,a0,-158 # 80013b88 <wait_lock>
    80001c2e:	fffff097          	auipc	ra,0xfffff
    80001c32:	f7a080e7          	jalr	-134(ra) # 80000ba8 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001c36:	00012497          	auipc	s1,0x12
    80001c3a:	f6a48493          	addi	s1,s1,-150 # 80013ba0 <proc>
        initlock(&p->lock, "proc");
    80001c3e:	00006b17          	auipc	s6,0x6
    80001c42:	59ab0b13          	addi	s6,s6,1434 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001c46:	8aa6                	mv	s5,s1
    80001c48:	ff4df937          	lui	s2,0xff4df
    80001c4c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e3d>
    80001c50:	0936                	slli	s2,s2,0xd
    80001c52:	6f590913          	addi	s2,s2,1781
    80001c56:	0936                	slli	s2,s2,0xd
    80001c58:	bd390913          	addi	s2,s2,-1069
    80001c5c:	0932                	slli	s2,s2,0xc
    80001c5e:	7a790913          	addi	s2,s2,1959
    80001c62:	040009b7          	lui	s3,0x4000
    80001c66:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001c68:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001c6a:	00018a17          	auipc	s4,0x18
    80001c6e:	b36a0a13          	addi	s4,s4,-1226 # 800197a0 <tickslock>
        initlock(&p->lock, "proc");
    80001c72:	85da                	mv	a1,s6
    80001c74:	8526                	mv	a0,s1
    80001c76:	fffff097          	auipc	ra,0xfffff
    80001c7a:	f32080e7          	jalr	-206(ra) # 80000ba8 <initlock>
        p->state = UNUSED;
    80001c7e:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001c82:	415487b3          	sub	a5,s1,s5
    80001c86:	8791                	srai	a5,a5,0x4
    80001c88:	032787b3          	mul	a5,a5,s2
    80001c8c:	2785                	addiw	a5,a5,1
    80001c8e:	00d7979b          	slliw	a5,a5,0xd
    80001c92:	40f987b3          	sub	a5,s3,a5
    80001c96:	e4bc                	sd	a5,72(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001c98:	17048493          	addi	s1,s1,368
    80001c9c:	fd449be3          	bne	s1,s4,80001c72 <procinit+0x80>
}
    80001ca0:	70e2                	ld	ra,56(sp)
    80001ca2:	7442                	ld	s0,48(sp)
    80001ca4:	74a2                	ld	s1,40(sp)
    80001ca6:	7902                	ld	s2,32(sp)
    80001ca8:	69e2                	ld	s3,24(sp)
    80001caa:	6a42                	ld	s4,16(sp)
    80001cac:	6aa2                	ld	s5,8(sp)
    80001cae:	6b02                	ld	s6,0(sp)
    80001cb0:	6121                	addi	sp,sp,64
    80001cb2:	8082                	ret

0000000080001cb4 <copy_array>:
{
    80001cb4:	1141                	addi	sp,sp,-16
    80001cb6:	e422                	sd	s0,8(sp)
    80001cb8:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001cba:	00c05c63          	blez	a2,80001cd2 <copy_array+0x1e>
    80001cbe:	87aa                	mv	a5,a0
    80001cc0:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001cc2:	0007c703          	lbu	a4,0(a5)
    80001cc6:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001cca:	0785                	addi	a5,a5,1
    80001ccc:	0585                	addi	a1,a1,1
    80001cce:	fea79ae3          	bne	a5,a0,80001cc2 <copy_array+0xe>
}
    80001cd2:	6422                	ld	s0,8(sp)
    80001cd4:	0141                	addi	sp,sp,16
    80001cd6:	8082                	ret

0000000080001cd8 <cpuid>:
{
    80001cd8:	1141                	addi	sp,sp,-16
    80001cda:	e422                	sd	s0,8(sp)
    80001cdc:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cde:	8512                	mv	a0,tp
}
    80001ce0:	2501                	sext.w	a0,a0
    80001ce2:	6422                	ld	s0,8(sp)
    80001ce4:	0141                	addi	sp,sp,16
    80001ce6:	8082                	ret

0000000080001ce8 <mycpu>:
{
    80001ce8:	1141                	addi	sp,sp,-16
    80001cea:	e422                	sd	s0,8(sp)
    80001cec:	0800                	addi	s0,sp,16
    80001cee:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001cf0:	2781                	sext.w	a5,a5
    80001cf2:	079e                	slli	a5,a5,0x7
}
    80001cf4:	00012517          	auipc	a0,0x12
    80001cf8:	a7c50513          	addi	a0,a0,-1412 # 80013770 <cpus>
    80001cfc:	953e                	add	a0,a0,a5
    80001cfe:	6422                	ld	s0,8(sp)
    80001d00:	0141                	addi	sp,sp,16
    80001d02:	8082                	ret

0000000080001d04 <myproc>:
{
    80001d04:	1101                	addi	sp,sp,-32
    80001d06:	ec06                	sd	ra,24(sp)
    80001d08:	e822                	sd	s0,16(sp)
    80001d0a:	e426                	sd	s1,8(sp)
    80001d0c:	1000                	addi	s0,sp,32
    push_off();
    80001d0e:	fffff097          	auipc	ra,0xfffff
    80001d12:	ede080e7          	jalr	-290(ra) # 80000bec <push_off>
    80001d16:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001d18:	2781                	sext.w	a5,a5
    80001d1a:	079e                	slli	a5,a5,0x7
    80001d1c:	00012717          	auipc	a4,0x12
    80001d20:	a5470713          	addi	a4,a4,-1452 # 80013770 <cpus>
    80001d24:	97ba                	add	a5,a5,a4
    80001d26:	6384                	ld	s1,0(a5)
    pop_off();
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	f64080e7          	jalr	-156(ra) # 80000c8c <pop_off>
}
    80001d30:	8526                	mv	a0,s1
    80001d32:	60e2                	ld	ra,24(sp)
    80001d34:	6442                	ld	s0,16(sp)
    80001d36:	64a2                	ld	s1,8(sp)
    80001d38:	6105                	addi	sp,sp,32
    80001d3a:	8082                	ret

0000000080001d3c <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001d3c:	1141                	addi	sp,sp,-16
    80001d3e:	e406                	sd	ra,8(sp)
    80001d40:	e022                	sd	s0,0(sp)
    80001d42:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	fc0080e7          	jalr	-64(ra) # 80001d04 <myproc>
    80001d4c:	fffff097          	auipc	ra,0xfffff
    80001d50:	fa0080e7          	jalr	-96(ra) # 80000cec <release>

    if (first)
    80001d54:	00009797          	auipc	a5,0x9
    80001d58:	6bc7a783          	lw	a5,1724(a5) # 8000b410 <first.1>
    80001d5c:	eb89                	bnez	a5,80001d6e <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001d5e:	00001097          	auipc	ra,0x1
    80001d62:	ede080e7          	jalr	-290(ra) # 80002c3c <usertrapret>
}
    80001d66:	60a2                	ld	ra,8(sp)
    80001d68:	6402                	ld	s0,0(sp)
    80001d6a:	0141                	addi	sp,sp,16
    80001d6c:	8082                	ret
        first = 0;
    80001d6e:	00009797          	auipc	a5,0x9
    80001d72:	6a07a123          	sw	zero,1698(a5) # 8000b410 <first.1>
        fsinit(ROOTDEV);
    80001d76:	4505                	li	a0,1
    80001d78:	00002097          	auipc	ra,0x2
    80001d7c:	d00080e7          	jalr	-768(ra) # 80003a78 <fsinit>
    80001d80:	bff9                	j	80001d5e <forkret+0x22>

0000000080001d82 <allocpid>:
{
    80001d82:	1101                	addi	sp,sp,-32
    80001d84:	ec06                	sd	ra,24(sp)
    80001d86:	e822                	sd	s0,16(sp)
    80001d88:	e426                	sd	s1,8(sp)
    80001d8a:	e04a                	sd	s2,0(sp)
    80001d8c:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001d8e:	00012917          	auipc	s2,0x12
    80001d92:	de290913          	addi	s2,s2,-542 # 80013b70 <pid_lock>
    80001d96:	854a                	mv	a0,s2
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	ea0080e7          	jalr	-352(ra) # 80000c38 <acquire>
    pid = nextpid;
    80001da0:	00009797          	auipc	a5,0x9
    80001da4:	68078793          	addi	a5,a5,1664 # 8000b420 <nextpid>
    80001da8:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001daa:	0014871b          	addiw	a4,s1,1
    80001dae:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001db0:	854a                	mv	a0,s2
    80001db2:	fffff097          	auipc	ra,0xfffff
    80001db6:	f3a080e7          	jalr	-198(ra) # 80000cec <release>
}
    80001dba:	8526                	mv	a0,s1
    80001dbc:	60e2                	ld	ra,24(sp)
    80001dbe:	6442                	ld	s0,16(sp)
    80001dc0:	64a2                	ld	s1,8(sp)
    80001dc2:	6902                	ld	s2,0(sp)
    80001dc4:	6105                	addi	sp,sp,32
    80001dc6:	8082                	ret

0000000080001dc8 <proc_pagetable>:
{
    80001dc8:	1101                	addi	sp,sp,-32
    80001dca:	ec06                	sd	ra,24(sp)
    80001dcc:	e822                	sd	s0,16(sp)
    80001dce:	e426                	sd	s1,8(sp)
    80001dd0:	e04a                	sd	s2,0(sp)
    80001dd2:	1000                	addi	s0,sp,32
    80001dd4:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001dd6:	fffff097          	auipc	ra,0xfffff
    80001dda:	5bc080e7          	jalr	1468(ra) # 80001392 <uvmcreate>
    80001dde:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001de0:	c121                	beqz	a0,80001e20 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001de2:	4729                	li	a4,10
    80001de4:	00005697          	auipc	a3,0x5
    80001de8:	21c68693          	addi	a3,a3,540 # 80007000 <_trampoline>
    80001dec:	6605                	lui	a2,0x1
    80001dee:	040005b7          	lui	a1,0x4000
    80001df2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001df4:	05b2                	slli	a1,a1,0xc
    80001df6:	fffff097          	auipc	ra,0xfffff
    80001dfa:	302080e7          	jalr	770(ra) # 800010f8 <mappages>
    80001dfe:	02054863          	bltz	a0,80001e2e <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001e02:	4719                	li	a4,6
    80001e04:	06093683          	ld	a3,96(s2)
    80001e08:	6605                	lui	a2,0x1
    80001e0a:	020005b7          	lui	a1,0x2000
    80001e0e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e10:	05b6                	slli	a1,a1,0xd
    80001e12:	8526                	mv	a0,s1
    80001e14:	fffff097          	auipc	ra,0xfffff
    80001e18:	2e4080e7          	jalr	740(ra) # 800010f8 <mappages>
    80001e1c:	02054163          	bltz	a0,80001e3e <proc_pagetable+0x76>
}
    80001e20:	8526                	mv	a0,s1
    80001e22:	60e2                	ld	ra,24(sp)
    80001e24:	6442                	ld	s0,16(sp)
    80001e26:	64a2                	ld	s1,8(sp)
    80001e28:	6902                	ld	s2,0(sp)
    80001e2a:	6105                	addi	sp,sp,32
    80001e2c:	8082                	ret
        uvmfree(pagetable, 0);
    80001e2e:	4581                	li	a1,0
    80001e30:	8526                	mv	a0,s1
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	772080e7          	jalr	1906(ra) # 800015a4 <uvmfree>
        return 0;
    80001e3a:	4481                	li	s1,0
    80001e3c:	b7d5                	j	80001e20 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e3e:	4681                	li	a3,0
    80001e40:	4605                	li	a2,1
    80001e42:	040005b7          	lui	a1,0x4000
    80001e46:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e48:	05b2                	slli	a1,a1,0xc
    80001e4a:	8526                	mv	a0,s1
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	472080e7          	jalr	1138(ra) # 800012be <uvmunmap>
        uvmfree(pagetable, 0);
    80001e54:	4581                	li	a1,0
    80001e56:	8526                	mv	a0,s1
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	74c080e7          	jalr	1868(ra) # 800015a4 <uvmfree>
        return 0;
    80001e60:	4481                	li	s1,0
    80001e62:	bf7d                	j	80001e20 <proc_pagetable+0x58>

0000000080001e64 <proc_freepagetable>:
{
    80001e64:	1101                	addi	sp,sp,-32
    80001e66:	ec06                	sd	ra,24(sp)
    80001e68:	e822                	sd	s0,16(sp)
    80001e6a:	e426                	sd	s1,8(sp)
    80001e6c:	e04a                	sd	s2,0(sp)
    80001e6e:	1000                	addi	s0,sp,32
    80001e70:	84aa                	mv	s1,a0
    80001e72:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e74:	4681                	li	a3,0
    80001e76:	4605                	li	a2,1
    80001e78:	040005b7          	lui	a1,0x4000
    80001e7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e7e:	05b2                	slli	a1,a1,0xc
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	43e080e7          	jalr	1086(ra) # 800012be <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e88:	4681                	li	a3,0
    80001e8a:	4605                	li	a2,1
    80001e8c:	020005b7          	lui	a1,0x2000
    80001e90:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e92:	05b6                	slli	a1,a1,0xd
    80001e94:	8526                	mv	a0,s1
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	428080e7          	jalr	1064(ra) # 800012be <uvmunmap>
    uvmfree(pagetable, sz);
    80001e9e:	85ca                	mv	a1,s2
    80001ea0:	8526                	mv	a0,s1
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	702080e7          	jalr	1794(ra) # 800015a4 <uvmfree>
}
    80001eaa:	60e2                	ld	ra,24(sp)
    80001eac:	6442                	ld	s0,16(sp)
    80001eae:	64a2                	ld	s1,8(sp)
    80001eb0:	6902                	ld	s2,0(sp)
    80001eb2:	6105                	addi	sp,sp,32
    80001eb4:	8082                	ret

0000000080001eb6 <freeproc>:
{
    80001eb6:	1101                	addi	sp,sp,-32
    80001eb8:	ec06                	sd	ra,24(sp)
    80001eba:	e822                	sd	s0,16(sp)
    80001ebc:	e426                	sd	s1,8(sp)
    80001ebe:	1000                	addi	s0,sp,32
    80001ec0:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001ec2:	7128                	ld	a0,96(a0)
    80001ec4:	c509                	beqz	a0,80001ece <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	b84080e7          	jalr	-1148(ra) # 80000a4a <kfree>
    p->trapframe = 0;
    80001ece:	0604b023          	sd	zero,96(s1)
    if (p->pagetable)
    80001ed2:	6ca8                	ld	a0,88(s1)
    80001ed4:	c511                	beqz	a0,80001ee0 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001ed6:	68ac                	ld	a1,80(s1)
    80001ed8:	00000097          	auipc	ra,0x0
    80001edc:	f8c080e7          	jalr	-116(ra) # 80001e64 <proc_freepagetable>
    p->pagetable = 0;
    80001ee0:	0404bc23          	sd	zero,88(s1)
    p->sz = 0;
    80001ee4:	0404b823          	sd	zero,80(s1)
    p->pid = 0;
    80001ee8:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001eec:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001ef0:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80001ef4:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001ef8:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001efc:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001f00:	0004ac23          	sw	zero,24(s1)
}
    80001f04:	60e2                	ld	ra,24(sp)
    80001f06:	6442                	ld	s0,16(sp)
    80001f08:	64a2                	ld	s1,8(sp)
    80001f0a:	6105                	addi	sp,sp,32
    80001f0c:	8082                	ret

0000000080001f0e <allocproc>:
{
    80001f0e:	1101                	addi	sp,sp,-32
    80001f10:	ec06                	sd	ra,24(sp)
    80001f12:	e822                	sd	s0,16(sp)
    80001f14:	e426                	sd	s1,8(sp)
    80001f16:	e04a                	sd	s2,0(sp)
    80001f18:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001f1a:	00012497          	auipc	s1,0x12
    80001f1e:	c8648493          	addi	s1,s1,-890 # 80013ba0 <proc>
    80001f22:	00018917          	auipc	s2,0x18
    80001f26:	87e90913          	addi	s2,s2,-1922 # 800197a0 <tickslock>
        acquire(&p->lock);
    80001f2a:	8526                	mv	a0,s1
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	d0c080e7          	jalr	-756(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80001f34:	4c9c                	lw	a5,24(s1)
    80001f36:	cf81                	beqz	a5,80001f4e <allocproc+0x40>
            release(&p->lock);
    80001f38:	8526                	mv	a0,s1
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	db2080e7          	jalr	-590(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001f42:	17048493          	addi	s1,s1,368
    80001f46:	ff2492e3          	bne	s1,s2,80001f2a <allocproc+0x1c>
    return 0;
    80001f4a:	4481                	li	s1,0
    80001f4c:	a8a9                	j	80001fa6 <allocproc+0x98>
    p->pid = allocpid();
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	e34080e7          	jalr	-460(ra) # 80001d82 <allocpid>
    80001f56:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001f58:	4785                	li	a5,1
    80001f5a:	cc9c                	sw	a5,24(s1)
    p->priority = 0;
    80001f5c:	0404a023          	sw	zero,64(s1)
    p->time_ticks = 0;
    80001f60:	0404a223          	sw	zero,68(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	be4080e7          	jalr	-1052(ra) # 80000b48 <kalloc>
    80001f6c:	892a                	mv	s2,a0
    80001f6e:	f0a8                	sd	a0,96(s1)
    80001f70:	c131                	beqz	a0,80001fb4 <allocproc+0xa6>
    p->pagetable = proc_pagetable(p);
    80001f72:	8526                	mv	a0,s1
    80001f74:	00000097          	auipc	ra,0x0
    80001f78:	e54080e7          	jalr	-428(ra) # 80001dc8 <proc_pagetable>
    80001f7c:	892a                	mv	s2,a0
    80001f7e:	eca8                	sd	a0,88(s1)
    if (p->pagetable == 0)
    80001f80:	c531                	beqz	a0,80001fcc <allocproc+0xbe>
    memset(&p->context, 0, sizeof(p->context));
    80001f82:	07000613          	li	a2,112
    80001f86:	4581                	li	a1,0
    80001f88:	06848513          	addi	a0,s1,104
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	da8080e7          	jalr	-600(ra) # 80000d34 <memset>
    p->context.ra = (uint64)forkret;
    80001f94:	00000797          	auipc	a5,0x0
    80001f98:	da878793          	addi	a5,a5,-600 # 80001d3c <forkret>
    80001f9c:	f4bc                	sd	a5,104(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001f9e:	64bc                	ld	a5,72(s1)
    80001fa0:	6705                	lui	a4,0x1
    80001fa2:	97ba                	add	a5,a5,a4
    80001fa4:	f8bc                	sd	a5,112(s1)
}
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	60e2                	ld	ra,24(sp)
    80001faa:	6442                	ld	s0,16(sp)
    80001fac:	64a2                	ld	s1,8(sp)
    80001fae:	6902                	ld	s2,0(sp)
    80001fb0:	6105                	addi	sp,sp,32
    80001fb2:	8082                	ret
        freeproc(p);
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	00000097          	auipc	ra,0x0
    80001fba:	f00080e7          	jalr	-256(ra) # 80001eb6 <freeproc>
        release(&p->lock);
    80001fbe:	8526                	mv	a0,s1
    80001fc0:	fffff097          	auipc	ra,0xfffff
    80001fc4:	d2c080e7          	jalr	-724(ra) # 80000cec <release>
        return 0;
    80001fc8:	84ca                	mv	s1,s2
    80001fca:	bff1                	j	80001fa6 <allocproc+0x98>
        freeproc(p);
    80001fcc:	8526                	mv	a0,s1
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	ee8080e7          	jalr	-280(ra) # 80001eb6 <freeproc>
        release(&p->lock);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	d14080e7          	jalr	-748(ra) # 80000cec <release>
        return 0;
    80001fe0:	84ca                	mv	s1,s2
    80001fe2:	b7d1                	j	80001fa6 <allocproc+0x98>

0000000080001fe4 <userinit>:
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	1000                	addi	s0,sp,32
    p = allocproc();
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	f20080e7          	jalr	-224(ra) # 80001f0e <allocproc>
    80001ff6:	84aa                	mv	s1,a0
    initproc = p;
    80001ff8:	00009797          	auipc	a5,0x9
    80001ffc:	50a7b023          	sd	a0,1280(a5) # 8000b4f8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002000:	03400613          	li	a2,52
    80002004:	00009597          	auipc	a1,0x9
    80002008:	42c58593          	addi	a1,a1,1068 # 8000b430 <initcode>
    8000200c:	6d28                	ld	a0,88(a0)
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	3b2080e7          	jalr	946(ra) # 800013c0 <uvmfirst>
    p->sz = PGSIZE;
    80002016:	6785                	lui	a5,0x1
    80002018:	e8bc                	sd	a5,80(s1)
    p->trapframe->epc = 0;     // user program counter
    8000201a:	70b8                	ld	a4,96(s1)
    8000201c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80002020:	70b8                	ld	a4,96(s1)
    80002022:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80002024:	4641                	li	a2,16
    80002026:	00006597          	auipc	a1,0x6
    8000202a:	1ba58593          	addi	a1,a1,442 # 800081e0 <etext+0x1e0>
    8000202e:	16048513          	addi	a0,s1,352
    80002032:	fffff097          	auipc	ra,0xfffff
    80002036:	e44080e7          	jalr	-444(ra) # 80000e76 <safestrcpy>
    p->cwd = namei("/");
    8000203a:	00006517          	auipc	a0,0x6
    8000203e:	1b650513          	addi	a0,a0,438 # 800081f0 <etext+0x1f0>
    80002042:	00002097          	auipc	ra,0x2
    80002046:	488080e7          	jalr	1160(ra) # 800044ca <namei>
    8000204a:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    8000204e:	478d                	li	a5,3
    80002050:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80002052:	8526                	mv	a0,s1
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	c98080e7          	jalr	-872(ra) # 80000cec <release>
}
    8000205c:	60e2                	ld	ra,24(sp)
    8000205e:	6442                	ld	s0,16(sp)
    80002060:	64a2                	ld	s1,8(sp)
    80002062:	6105                	addi	sp,sp,32
    80002064:	8082                	ret

0000000080002066 <growproc>:
{
    80002066:	1101                	addi	sp,sp,-32
    80002068:	ec06                	sd	ra,24(sp)
    8000206a:	e822                	sd	s0,16(sp)
    8000206c:	e426                	sd	s1,8(sp)
    8000206e:	e04a                	sd	s2,0(sp)
    80002070:	1000                	addi	s0,sp,32
    80002072:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80002074:	00000097          	auipc	ra,0x0
    80002078:	c90080e7          	jalr	-880(ra) # 80001d04 <myproc>
    8000207c:	84aa                	mv	s1,a0
    sz = p->sz;
    8000207e:	692c                	ld	a1,80(a0)
    if (n > 0)
    80002080:	01204c63          	bgtz	s2,80002098 <growproc+0x32>
    else if (n < 0)
    80002084:	02094663          	bltz	s2,800020b0 <growproc+0x4a>
    p->sz = sz;
    80002088:	e8ac                	sd	a1,80(s1)
    return 0;
    8000208a:	4501                	li	a0,0
}
    8000208c:	60e2                	ld	ra,24(sp)
    8000208e:	6442                	ld	s0,16(sp)
    80002090:	64a2                	ld	s1,8(sp)
    80002092:	6902                	ld	s2,0(sp)
    80002094:	6105                	addi	sp,sp,32
    80002096:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002098:	4691                	li	a3,4
    8000209a:	00b90633          	add	a2,s2,a1
    8000209e:	6d28                	ld	a0,88(a0)
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	3da080e7          	jalr	986(ra) # 8000147a <uvmalloc>
    800020a8:	85aa                	mv	a1,a0
    800020aa:	fd79                	bnez	a0,80002088 <growproc+0x22>
            return -1;
    800020ac:	557d                	li	a0,-1
    800020ae:	bff9                	j	8000208c <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800020b0:	00b90633          	add	a2,s2,a1
    800020b4:	6d28                	ld	a0,88(a0)
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	37c080e7          	jalr	892(ra) # 80001432 <uvmdealloc>
    800020be:	85aa                	mv	a1,a0
    800020c0:	b7e1                	j	80002088 <growproc+0x22>

00000000800020c2 <ps>:
{
    800020c2:	715d                	addi	sp,sp,-80
    800020c4:	e486                	sd	ra,72(sp)
    800020c6:	e0a2                	sd	s0,64(sp)
    800020c8:	fc26                	sd	s1,56(sp)
    800020ca:	f84a                	sd	s2,48(sp)
    800020cc:	f44e                	sd	s3,40(sp)
    800020ce:	f052                	sd	s4,32(sp)
    800020d0:	ec56                	sd	s5,24(sp)
    800020d2:	e85a                	sd	s6,16(sp)
    800020d4:	e45e                	sd	s7,8(sp)
    800020d6:	e062                	sd	s8,0(sp)
    800020d8:	0880                	addi	s0,sp,80
    800020da:	84aa                	mv	s1,a0
    800020dc:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	c26080e7          	jalr	-986(ra) # 80001d04 <myproc>
        return result;
    800020e6:	4901                	li	s2,0
    if (count == 0)
    800020e8:	0c0b8663          	beqz	s7,800021b4 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    800020ec:	05053b03          	ld	s6,80(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    800020f0:	003b951b          	slliw	a0,s7,0x3
    800020f4:	0175053b          	addw	a0,a0,s7
    800020f8:	0025151b          	slliw	a0,a0,0x2
    800020fc:	2501                	sext.w	a0,a0
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	f68080e7          	jalr	-152(ra) # 80002066 <growproc>
    80002106:	12054f63          	bltz	a0,80002244 <ps+0x182>
    struct user_proc loc_result[count];
    8000210a:	003b9a13          	slli	s4,s7,0x3
    8000210e:	9a5e                	add	s4,s4,s7
    80002110:	0a0a                	slli	s4,s4,0x2
    80002112:	00fa0793          	addi	a5,s4,15
    80002116:	8391                	srli	a5,a5,0x4
    80002118:	0792                	slli	a5,a5,0x4
    8000211a:	40f10133          	sub	sp,sp,a5
    8000211e:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    80002120:	17000793          	li	a5,368
    80002124:	02f484b3          	mul	s1,s1,a5
    80002128:	00012797          	auipc	a5,0x12
    8000212c:	a7878793          	addi	a5,a5,-1416 # 80013ba0 <proc>
    80002130:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80002132:	00017797          	auipc	a5,0x17
    80002136:	66e78793          	addi	a5,a5,1646 # 800197a0 <tickslock>
        return result;
    8000213a:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    8000213c:	06f4fc63          	bgeu	s1,a5,800021b4 <ps+0xf2>
    acquire(&wait_lock);
    80002140:	00012517          	auipc	a0,0x12
    80002144:	a4850513          	addi	a0,a0,-1464 # 80013b88 <wait_lock>
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	af0080e7          	jalr	-1296(ra) # 80000c38 <acquire>
        if (localCount == count)
    80002150:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    80002154:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    80002156:	00017c17          	auipc	s8,0x17
    8000215a:	64ac0c13          	addi	s8,s8,1610 # 800197a0 <tickslock>
    8000215e:	a851                	j	800021f2 <ps+0x130>
            loc_result[localCount].state = UNUSED;
    80002160:	00399793          	slli	a5,s3,0x3
    80002164:	97ce                	add	a5,a5,s3
    80002166:	078a                	slli	a5,a5,0x2
    80002168:	97d6                	add	a5,a5,s5
    8000216a:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    8000216e:	8526                	mv	a0,s1
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	b7c080e7          	jalr	-1156(ra) # 80000cec <release>
    release(&wait_lock);
    80002178:	00012517          	auipc	a0,0x12
    8000217c:	a1050513          	addi	a0,a0,-1520 # 80013b88 <wait_lock>
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	b6c080e7          	jalr	-1172(ra) # 80000cec <release>
    if (localCount < count)
    80002188:	0179f963          	bgeu	s3,s7,8000219a <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    8000218c:	00399793          	slli	a5,s3,0x3
    80002190:	97ce                	add	a5,a5,s3
    80002192:	078a                	slli	a5,a5,0x2
    80002194:	97d6                	add	a5,a5,s5
    80002196:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    8000219a:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    8000219c:	00000097          	auipc	ra,0x0
    800021a0:	b68080e7          	jalr	-1176(ra) # 80001d04 <myproc>
    800021a4:	86d2                	mv	a3,s4
    800021a6:	8656                	mv	a2,s5
    800021a8:	85da                	mv	a1,s6
    800021aa:	6d28                	ld	a0,88(a0)
    800021ac:	fffff097          	auipc	ra,0xfffff
    800021b0:	536080e7          	jalr	1334(ra) # 800016e2 <copyout>
}
    800021b4:	854a                	mv	a0,s2
    800021b6:	fb040113          	addi	sp,s0,-80
    800021ba:	60a6                	ld	ra,72(sp)
    800021bc:	6406                	ld	s0,64(sp)
    800021be:	74e2                	ld	s1,56(sp)
    800021c0:	7942                	ld	s2,48(sp)
    800021c2:	79a2                	ld	s3,40(sp)
    800021c4:	7a02                	ld	s4,32(sp)
    800021c6:	6ae2                	ld	s5,24(sp)
    800021c8:	6b42                	ld	s6,16(sp)
    800021ca:	6ba2                	ld	s7,8(sp)
    800021cc:	6c02                	ld	s8,0(sp)
    800021ce:	6161                	addi	sp,sp,80
    800021d0:	8082                	ret
        release(&p->lock);
    800021d2:	8526                	mv	a0,s1
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	b18080e7          	jalr	-1256(ra) # 80000cec <release>
        localCount++;
    800021dc:	2985                	addiw	s3,s3,1
    800021de:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    800021e2:	17048493          	addi	s1,s1,368
    800021e6:	f984f9e3          	bgeu	s1,s8,80002178 <ps+0xb6>
        if (localCount == count)
    800021ea:	02490913          	addi	s2,s2,36
    800021ee:	053b8d63          	beq	s7,s3,80002248 <ps+0x186>
        acquire(&p->lock);
    800021f2:	8526                	mv	a0,s1
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	a44080e7          	jalr	-1468(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    800021fc:	4c9c                	lw	a5,24(s1)
    800021fe:	d3ad                	beqz	a5,80002160 <ps+0x9e>
        loc_result[localCount].state = p->state;
    80002200:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002204:	549c                	lw	a5,40(s1)
    80002206:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    8000220a:	54dc                	lw	a5,44(s1)
    8000220c:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    80002210:	589c                	lw	a5,48(s1)
    80002212:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002216:	4641                	li	a2,16
    80002218:	85ca                	mv	a1,s2
    8000221a:	16048513          	addi	a0,s1,352
    8000221e:	00000097          	auipc	ra,0x0
    80002222:	a96080e7          	jalr	-1386(ra) # 80001cb4 <copy_array>
        if (p->parent != 0) // init
    80002226:	7c88                	ld	a0,56(s1)
    80002228:	d54d                	beqz	a0,800021d2 <ps+0x110>
            acquire(&p->parent->lock);
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	a0e080e7          	jalr	-1522(ra) # 80000c38 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    80002232:	7c88                	ld	a0,56(s1)
    80002234:	591c                	lw	a5,48(a0)
    80002236:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	ab2080e7          	jalr	-1358(ra) # 80000cec <release>
    80002242:	bf41                	j	800021d2 <ps+0x110>
        return result;
    80002244:	4901                	li	s2,0
    80002246:	b7bd                	j	800021b4 <ps+0xf2>
    release(&wait_lock);
    80002248:	00012517          	auipc	a0,0x12
    8000224c:	94050513          	addi	a0,a0,-1728 # 80013b88 <wait_lock>
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	a9c080e7          	jalr	-1380(ra) # 80000cec <release>
    if (localCount < count)
    80002258:	b789                	j	8000219a <ps+0xd8>

000000008000225a <fork>:
{
    8000225a:	7139                	addi	sp,sp,-64
    8000225c:	fc06                	sd	ra,56(sp)
    8000225e:	f822                	sd	s0,48(sp)
    80002260:	f04a                	sd	s2,32(sp)
    80002262:	e456                	sd	s5,8(sp)
    80002264:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002266:	00000097          	auipc	ra,0x0
    8000226a:	a9e080e7          	jalr	-1378(ra) # 80001d04 <myproc>
    8000226e:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    80002270:	00000097          	auipc	ra,0x0
    80002274:	c9e080e7          	jalr	-866(ra) # 80001f0e <allocproc>
    80002278:	12050063          	beqz	a0,80002398 <fork+0x13e>
    8000227c:	e852                	sd	s4,16(sp)
    8000227e:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002280:	050ab603          	ld	a2,80(s5)
    80002284:	6d2c                	ld	a1,88(a0)
    80002286:	058ab503          	ld	a0,88(s5)
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	354080e7          	jalr	852(ra) # 800015de <uvmcopy>
    80002292:	04054a63          	bltz	a0,800022e6 <fork+0x8c>
    80002296:	f426                	sd	s1,40(sp)
    80002298:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    8000229a:	050ab783          	ld	a5,80(s5)
    8000229e:	04fa3823          	sd	a5,80(s4)
    *(np->trapframe) = *(p->trapframe);
    800022a2:	060ab683          	ld	a3,96(s5)
    800022a6:	87b6                	mv	a5,a3
    800022a8:	060a3703          	ld	a4,96(s4)
    800022ac:	12068693          	addi	a3,a3,288
    800022b0:	0007b803          	ld	a6,0(a5)
    800022b4:	6788                	ld	a0,8(a5)
    800022b6:	6b8c                	ld	a1,16(a5)
    800022b8:	6f90                	ld	a2,24(a5)
    800022ba:	01073023          	sd	a6,0(a4)
    800022be:	e708                	sd	a0,8(a4)
    800022c0:	eb0c                	sd	a1,16(a4)
    800022c2:	ef10                	sd	a2,24(a4)
    800022c4:	02078793          	addi	a5,a5,32
    800022c8:	02070713          	addi	a4,a4,32
    800022cc:	fed792e3          	bne	a5,a3,800022b0 <fork+0x56>
    np->trapframe->a0 = 0;
    800022d0:	060a3783          	ld	a5,96(s4)
    800022d4:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800022d8:	0d8a8493          	addi	s1,s5,216
    800022dc:	0d8a0913          	addi	s2,s4,216
    800022e0:	158a8993          	addi	s3,s5,344
    800022e4:	a015                	j	80002308 <fork+0xae>
        freeproc(np);
    800022e6:	8552                	mv	a0,s4
    800022e8:	00000097          	auipc	ra,0x0
    800022ec:	bce080e7          	jalr	-1074(ra) # 80001eb6 <freeproc>
        release(&np->lock);
    800022f0:	8552                	mv	a0,s4
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	9fa080e7          	jalr	-1542(ra) # 80000cec <release>
        return -1;
    800022fa:	597d                	li	s2,-1
    800022fc:	6a42                	ld	s4,16(sp)
    800022fe:	a071                	j	8000238a <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002300:	04a1                	addi	s1,s1,8
    80002302:	0921                	addi	s2,s2,8
    80002304:	01348b63          	beq	s1,s3,8000231a <fork+0xc0>
        if (p->ofile[i])
    80002308:	6088                	ld	a0,0(s1)
    8000230a:	d97d                	beqz	a0,80002300 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    8000230c:	00003097          	auipc	ra,0x3
    80002310:	836080e7          	jalr	-1994(ra) # 80004b42 <filedup>
    80002314:	00a93023          	sd	a0,0(s2)
    80002318:	b7e5                	j	80002300 <fork+0xa6>
    np->cwd = idup(p->cwd);
    8000231a:	158ab503          	ld	a0,344(s5)
    8000231e:	00002097          	auipc	ra,0x2
    80002322:	9a0080e7          	jalr	-1632(ra) # 80003cbe <idup>
    80002326:	14aa3c23          	sd	a0,344(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    8000232a:	4641                	li	a2,16
    8000232c:	160a8593          	addi	a1,s5,352
    80002330:	160a0513          	addi	a0,s4,352
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	b42080e7          	jalr	-1214(ra) # 80000e76 <safestrcpy>
    pid = np->pid;
    8000233c:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80002340:	8552                	mv	a0,s4
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	9aa080e7          	jalr	-1622(ra) # 80000cec <release>
    acquire(&wait_lock);
    8000234a:	00012497          	auipc	s1,0x12
    8000234e:	83e48493          	addi	s1,s1,-1986 # 80013b88 <wait_lock>
    80002352:	8526                	mv	a0,s1
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	8e4080e7          	jalr	-1820(ra) # 80000c38 <acquire>
    np->parent = p;
    8000235c:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    80002360:	8526                	mv	a0,s1
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	98a080e7          	jalr	-1654(ra) # 80000cec <release>
    acquire(&np->lock);
    8000236a:	8552                	mv	a0,s4
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	8cc080e7          	jalr	-1844(ra) # 80000c38 <acquire>
    np->state = RUNNABLE;
    80002374:	478d                	li	a5,3
    80002376:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    8000237a:	8552                	mv	a0,s4
    8000237c:	fffff097          	auipc	ra,0xfffff
    80002380:	970080e7          	jalr	-1680(ra) # 80000cec <release>
    return pid;
    80002384:	74a2                	ld	s1,40(sp)
    80002386:	69e2                	ld	s3,24(sp)
    80002388:	6a42                	ld	s4,16(sp)
}
    8000238a:	854a                	mv	a0,s2
    8000238c:	70e2                	ld	ra,56(sp)
    8000238e:	7442                	ld	s0,48(sp)
    80002390:	7902                	ld	s2,32(sp)
    80002392:	6aa2                	ld	s5,8(sp)
    80002394:	6121                	addi	sp,sp,64
    80002396:	8082                	ret
        return -1;
    80002398:	597d                	li	s2,-1
    8000239a:	bfc5                	j	8000238a <fork+0x130>

000000008000239c <scheduler>:
{
    8000239c:	1101                	addi	sp,sp,-32
    8000239e:	ec06                	sd	ra,24(sp)
    800023a0:	e822                	sd	s0,16(sp)
    800023a2:	e426                	sd	s1,8(sp)
    800023a4:	e04a                	sd	s2,0(sp)
    800023a6:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    800023a8:	00009797          	auipc	a5,0x9
    800023ac:	0707b783          	ld	a5,112(a5) # 8000b418 <sched_pointer>
        if (old_scheduler != sched_pointer)
    800023b0:	00009497          	auipc	s1,0x9
    800023b4:	06848493          	addi	s1,s1,104 # 8000b418 <sched_pointer>
            printf("Scheduler switched\n");
    800023b8:	00006917          	auipc	s2,0x6
    800023bc:	e4090913          	addi	s2,s2,-448 # 800081f8 <etext+0x1f8>
    800023c0:	a809                	j	800023d2 <scheduler+0x36>
    800023c2:	854a                	mv	a0,s2
    800023c4:	ffffe097          	auipc	ra,0xffffe
    800023c8:	1e6080e7          	jalr	486(ra) # 800005aa <printf>
        (*sched_pointer)();
    800023cc:	609c                	ld	a5,0(s1)
    800023ce:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    800023d0:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    800023d2:	6098                	ld	a4,0(s1)
    800023d4:	fef717e3          	bne	a4,a5,800023c2 <scheduler+0x26>
    800023d8:	bfd5                	j	800023cc <scheduler+0x30>

00000000800023da <sched>:
{
    800023da:	7179                	addi	sp,sp,-48
    800023dc:	f406                	sd	ra,40(sp)
    800023de:	f022                	sd	s0,32(sp)
    800023e0:	ec26                	sd	s1,24(sp)
    800023e2:	e84a                	sd	s2,16(sp)
    800023e4:	e44e                	sd	s3,8(sp)
    800023e6:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800023e8:	00000097          	auipc	ra,0x0
    800023ec:	91c080e7          	jalr	-1764(ra) # 80001d04 <myproc>
    800023f0:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800023f2:	ffffe097          	auipc	ra,0xffffe
    800023f6:	7cc080e7          	jalr	1996(ra) # 80000bbe <holding>
    800023fa:	c53d                	beqz	a0,80002468 <sched+0x8e>
    800023fc:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800023fe:	2781                	sext.w	a5,a5
    80002400:	079e                	slli	a5,a5,0x7
    80002402:	00011717          	auipc	a4,0x11
    80002406:	36e70713          	addi	a4,a4,878 # 80013770 <cpus>
    8000240a:	97ba                	add	a5,a5,a4
    8000240c:	5fb8                	lw	a4,120(a5)
    8000240e:	4785                	li	a5,1
    80002410:	06f71463          	bne	a4,a5,80002478 <sched+0x9e>
    if (p->state == RUNNING)
    80002414:	4c98                	lw	a4,24(s1)
    80002416:	4791                	li	a5,4
    80002418:	06f70863          	beq	a4,a5,80002488 <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000241c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002420:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002422:	ebbd                	bnez	a5,80002498 <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002424:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002426:	00011917          	auipc	s2,0x11
    8000242a:	34a90913          	addi	s2,s2,842 # 80013770 <cpus>
    8000242e:	2781                	sext.w	a5,a5
    80002430:	079e                	slli	a5,a5,0x7
    80002432:	97ca                	add	a5,a5,s2
    80002434:	07c7a983          	lw	s3,124(a5)
    80002438:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000243a:	2581                	sext.w	a1,a1
    8000243c:	059e                	slli	a1,a1,0x7
    8000243e:	05a1                	addi	a1,a1,8
    80002440:	95ca                	add	a1,a1,s2
    80002442:	06848513          	addi	a0,s1,104
    80002446:	00000097          	auipc	ra,0x0
    8000244a:	74c080e7          	jalr	1868(ra) # 80002b92 <swtch>
    8000244e:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002450:	2781                	sext.w	a5,a5
    80002452:	079e                	slli	a5,a5,0x7
    80002454:	993e                	add	s2,s2,a5
    80002456:	07392e23          	sw	s3,124(s2)
}
    8000245a:	70a2                	ld	ra,40(sp)
    8000245c:	7402                	ld	s0,32(sp)
    8000245e:	64e2                	ld	s1,24(sp)
    80002460:	6942                	ld	s2,16(sp)
    80002462:	69a2                	ld	s3,8(sp)
    80002464:	6145                	addi	sp,sp,48
    80002466:	8082                	ret
        panic("sched p->lock");
    80002468:	00006517          	auipc	a0,0x6
    8000246c:	da850513          	addi	a0,a0,-600 # 80008210 <etext+0x210>
    80002470:	ffffe097          	auipc	ra,0xffffe
    80002474:	0f0080e7          	jalr	240(ra) # 80000560 <panic>
        panic("sched locks");
    80002478:	00006517          	auipc	a0,0x6
    8000247c:	da850513          	addi	a0,a0,-600 # 80008220 <etext+0x220>
    80002480:	ffffe097          	auipc	ra,0xffffe
    80002484:	0e0080e7          	jalr	224(ra) # 80000560 <panic>
        panic("sched running");
    80002488:	00006517          	auipc	a0,0x6
    8000248c:	da850513          	addi	a0,a0,-600 # 80008230 <etext+0x230>
    80002490:	ffffe097          	auipc	ra,0xffffe
    80002494:	0d0080e7          	jalr	208(ra) # 80000560 <panic>
        panic("sched interruptible");
    80002498:	00006517          	auipc	a0,0x6
    8000249c:	da850513          	addi	a0,a0,-600 # 80008240 <etext+0x240>
    800024a0:	ffffe097          	auipc	ra,0xffffe
    800024a4:	0c0080e7          	jalr	192(ra) # 80000560 <panic>

00000000800024a8 <yield>:
{
    800024a8:	1101                	addi	sp,sp,-32
    800024aa:	ec06                	sd	ra,24(sp)
    800024ac:	e822                	sd	s0,16(sp)
    800024ae:	e426                	sd	s1,8(sp)
    800024b0:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800024b2:	00000097          	auipc	ra,0x0
    800024b6:	852080e7          	jalr	-1966(ra) # 80001d04 <myproc>
    800024ba:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800024bc:	ffffe097          	auipc	ra,0xffffe
    800024c0:	77c080e7          	jalr	1916(ra) # 80000c38 <acquire>
    p->state = RUNNABLE;
    800024c4:	478d                	li	a5,3
    800024c6:	cc9c                	sw	a5,24(s1)
    p->time_ticks = 0;
    800024c8:	0404a223          	sw	zero,68(s1)
    sched();
    800024cc:	00000097          	auipc	ra,0x0
    800024d0:	f0e080e7          	jalr	-242(ra) # 800023da <sched>
    release(&p->lock);
    800024d4:	8526                	mv	a0,s1
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	816080e7          	jalr	-2026(ra) # 80000cec <release>
}
    800024de:	60e2                	ld	ra,24(sp)
    800024e0:	6442                	ld	s0,16(sp)
    800024e2:	64a2                	ld	s1,8(sp)
    800024e4:	6105                	addi	sp,sp,32
    800024e6:	8082                	ret

00000000800024e8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800024e8:	7179                	addi	sp,sp,-48
    800024ea:	f406                	sd	ra,40(sp)
    800024ec:	f022                	sd	s0,32(sp)
    800024ee:	ec26                	sd	s1,24(sp)
    800024f0:	e84a                	sd	s2,16(sp)
    800024f2:	e44e                	sd	s3,8(sp)
    800024f4:	1800                	addi	s0,sp,48
    800024f6:	89aa                	mv	s3,a0
    800024f8:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800024fa:	00000097          	auipc	ra,0x0
    800024fe:	80a080e7          	jalr	-2038(ra) # 80001d04 <myproc>
    80002502:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	734080e7          	jalr	1844(ra) # 80000c38 <acquire>
    release(lk);
    8000250c:	854a                	mv	a0,s2
    8000250e:	ffffe097          	auipc	ra,0xffffe
    80002512:	7de080e7          	jalr	2014(ra) # 80000cec <release>

    // Go to sleep.
    p->chan = chan;
    80002516:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000251a:	4789                	li	a5,2
    8000251c:	cc9c                	sw	a5,24(s1)

    sched();
    8000251e:	00000097          	auipc	ra,0x0
    80002522:	ebc080e7          	jalr	-324(ra) # 800023da <sched>

    // Tidy up.
    p->chan = 0;
    80002526:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000252a:	8526                	mv	a0,s1
    8000252c:	ffffe097          	auipc	ra,0xffffe
    80002530:	7c0080e7          	jalr	1984(ra) # 80000cec <release>
    acquire(lk);
    80002534:	854a                	mv	a0,s2
    80002536:	ffffe097          	auipc	ra,0xffffe
    8000253a:	702080e7          	jalr	1794(ra) # 80000c38 <acquire>
}
    8000253e:	70a2                	ld	ra,40(sp)
    80002540:	7402                	ld	s0,32(sp)
    80002542:	64e2                	ld	s1,24(sp)
    80002544:	6942                	ld	s2,16(sp)
    80002546:	69a2                	ld	s3,8(sp)
    80002548:	6145                	addi	sp,sp,48
    8000254a:	8082                	ret

000000008000254c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000254c:	7139                	addi	sp,sp,-64
    8000254e:	fc06                	sd	ra,56(sp)
    80002550:	f822                	sd	s0,48(sp)
    80002552:	f426                	sd	s1,40(sp)
    80002554:	f04a                	sd	s2,32(sp)
    80002556:	ec4e                	sd	s3,24(sp)
    80002558:	e852                	sd	s4,16(sp)
    8000255a:	e456                	sd	s5,8(sp)
    8000255c:	0080                	addi	s0,sp,64
    8000255e:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002560:	00011497          	auipc	s1,0x11
    80002564:	64048493          	addi	s1,s1,1600 # 80013ba0 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002568:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    8000256a:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000256c:	00017917          	auipc	s2,0x17
    80002570:	23490913          	addi	s2,s2,564 # 800197a0 <tickslock>
    80002574:	a811                	j	80002588 <wakeup+0x3c>
            }
            release(&p->lock);
    80002576:	8526                	mv	a0,s1
    80002578:	ffffe097          	auipc	ra,0xffffe
    8000257c:	774080e7          	jalr	1908(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002580:	17048493          	addi	s1,s1,368
    80002584:	03248663          	beq	s1,s2,800025b0 <wakeup+0x64>
        if (p != myproc())
    80002588:	fffff097          	auipc	ra,0xfffff
    8000258c:	77c080e7          	jalr	1916(ra) # 80001d04 <myproc>
    80002590:	fea488e3          	beq	s1,a0,80002580 <wakeup+0x34>
            acquire(&p->lock);
    80002594:	8526                	mv	a0,s1
    80002596:	ffffe097          	auipc	ra,0xffffe
    8000259a:	6a2080e7          	jalr	1698(ra) # 80000c38 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    8000259e:	4c9c                	lw	a5,24(s1)
    800025a0:	fd379be3          	bne	a5,s3,80002576 <wakeup+0x2a>
    800025a4:	709c                	ld	a5,32(s1)
    800025a6:	fd4798e3          	bne	a5,s4,80002576 <wakeup+0x2a>
                p->state = RUNNABLE;
    800025aa:	0154ac23          	sw	s5,24(s1)
    800025ae:	b7e1                	j	80002576 <wakeup+0x2a>
        }
    }
}
    800025b0:	70e2                	ld	ra,56(sp)
    800025b2:	7442                	ld	s0,48(sp)
    800025b4:	74a2                	ld	s1,40(sp)
    800025b6:	7902                	ld	s2,32(sp)
    800025b8:	69e2                	ld	s3,24(sp)
    800025ba:	6a42                	ld	s4,16(sp)
    800025bc:	6aa2                	ld	s5,8(sp)
    800025be:	6121                	addi	sp,sp,64
    800025c0:	8082                	ret

00000000800025c2 <reparent>:
{
    800025c2:	7179                	addi	sp,sp,-48
    800025c4:	f406                	sd	ra,40(sp)
    800025c6:	f022                	sd	s0,32(sp)
    800025c8:	ec26                	sd	s1,24(sp)
    800025ca:	e84a                	sd	s2,16(sp)
    800025cc:	e44e                	sd	s3,8(sp)
    800025ce:	e052                	sd	s4,0(sp)
    800025d0:	1800                	addi	s0,sp,48
    800025d2:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025d4:	00011497          	auipc	s1,0x11
    800025d8:	5cc48493          	addi	s1,s1,1484 # 80013ba0 <proc>
            pp->parent = initproc;
    800025dc:	00009a17          	auipc	s4,0x9
    800025e0:	f1ca0a13          	addi	s4,s4,-228 # 8000b4f8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025e4:	00017997          	auipc	s3,0x17
    800025e8:	1bc98993          	addi	s3,s3,444 # 800197a0 <tickslock>
    800025ec:	a029                	j	800025f6 <reparent+0x34>
    800025ee:	17048493          	addi	s1,s1,368
    800025f2:	01348d63          	beq	s1,s3,8000260c <reparent+0x4a>
        if (pp->parent == p)
    800025f6:	7c9c                	ld	a5,56(s1)
    800025f8:	ff279be3          	bne	a5,s2,800025ee <reparent+0x2c>
            pp->parent = initproc;
    800025fc:	000a3503          	ld	a0,0(s4)
    80002600:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80002602:	00000097          	auipc	ra,0x0
    80002606:	f4a080e7          	jalr	-182(ra) # 8000254c <wakeup>
    8000260a:	b7d5                	j	800025ee <reparent+0x2c>
}
    8000260c:	70a2                	ld	ra,40(sp)
    8000260e:	7402                	ld	s0,32(sp)
    80002610:	64e2                	ld	s1,24(sp)
    80002612:	6942                	ld	s2,16(sp)
    80002614:	69a2                	ld	s3,8(sp)
    80002616:	6a02                	ld	s4,0(sp)
    80002618:	6145                	addi	sp,sp,48
    8000261a:	8082                	ret

000000008000261c <exit>:
{
    8000261c:	7179                	addi	sp,sp,-48
    8000261e:	f406                	sd	ra,40(sp)
    80002620:	f022                	sd	s0,32(sp)
    80002622:	ec26                	sd	s1,24(sp)
    80002624:	e84a                	sd	s2,16(sp)
    80002626:	e44e                	sd	s3,8(sp)
    80002628:	e052                	sd	s4,0(sp)
    8000262a:	1800                	addi	s0,sp,48
    8000262c:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000262e:	fffff097          	auipc	ra,0xfffff
    80002632:	6d6080e7          	jalr	1750(ra) # 80001d04 <myproc>
    80002636:	89aa                	mv	s3,a0
    if (p == initproc)
    80002638:	00009797          	auipc	a5,0x9
    8000263c:	ec07b783          	ld	a5,-320(a5) # 8000b4f8 <initproc>
    80002640:	0d850493          	addi	s1,a0,216
    80002644:	15850913          	addi	s2,a0,344
    80002648:	02a79363          	bne	a5,a0,8000266e <exit+0x52>
        panic("init exiting");
    8000264c:	00006517          	auipc	a0,0x6
    80002650:	c0c50513          	addi	a0,a0,-1012 # 80008258 <etext+0x258>
    80002654:	ffffe097          	auipc	ra,0xffffe
    80002658:	f0c080e7          	jalr	-244(ra) # 80000560 <panic>
            fileclose(f);
    8000265c:	00002097          	auipc	ra,0x2
    80002660:	538080e7          	jalr	1336(ra) # 80004b94 <fileclose>
            p->ofile[fd] = 0;
    80002664:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80002668:	04a1                	addi	s1,s1,8
    8000266a:	01248563          	beq	s1,s2,80002674 <exit+0x58>
        if (p->ofile[fd])
    8000266e:	6088                	ld	a0,0(s1)
    80002670:	f575                	bnez	a0,8000265c <exit+0x40>
    80002672:	bfdd                	j	80002668 <exit+0x4c>
    begin_op();
    80002674:	00002097          	auipc	ra,0x2
    80002678:	056080e7          	jalr	86(ra) # 800046ca <begin_op>
    iput(p->cwd);
    8000267c:	1589b503          	ld	a0,344(s3)
    80002680:	00002097          	auipc	ra,0x2
    80002684:	83a080e7          	jalr	-1990(ra) # 80003eba <iput>
    end_op();
    80002688:	00002097          	auipc	ra,0x2
    8000268c:	0bc080e7          	jalr	188(ra) # 80004744 <end_op>
    p->cwd = 0;
    80002690:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    80002694:	00011497          	auipc	s1,0x11
    80002698:	4f448493          	addi	s1,s1,1268 # 80013b88 <wait_lock>
    8000269c:	8526                	mv	a0,s1
    8000269e:	ffffe097          	auipc	ra,0xffffe
    800026a2:	59a080e7          	jalr	1434(ra) # 80000c38 <acquire>
    reparent(p);
    800026a6:	854e                	mv	a0,s3
    800026a8:	00000097          	auipc	ra,0x0
    800026ac:	f1a080e7          	jalr	-230(ra) # 800025c2 <reparent>
    wakeup(p->parent);
    800026b0:	0389b503          	ld	a0,56(s3)
    800026b4:	00000097          	auipc	ra,0x0
    800026b8:	e98080e7          	jalr	-360(ra) # 8000254c <wakeup>
    acquire(&p->lock);
    800026bc:	854e                	mv	a0,s3
    800026be:	ffffe097          	auipc	ra,0xffffe
    800026c2:	57a080e7          	jalr	1402(ra) # 80000c38 <acquire>
    p->xstate = status;
    800026c6:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800026ca:	4795                	li	a5,5
    800026cc:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800026d0:	8526                	mv	a0,s1
    800026d2:	ffffe097          	auipc	ra,0xffffe
    800026d6:	61a080e7          	jalr	1562(ra) # 80000cec <release>
    sched();
    800026da:	00000097          	auipc	ra,0x0
    800026de:	d00080e7          	jalr	-768(ra) # 800023da <sched>
    panic("zombie exit");
    800026e2:	00006517          	auipc	a0,0x6
    800026e6:	b8650513          	addi	a0,a0,-1146 # 80008268 <etext+0x268>
    800026ea:	ffffe097          	auipc	ra,0xffffe
    800026ee:	e76080e7          	jalr	-394(ra) # 80000560 <panic>

00000000800026f2 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800026f2:	7179                	addi	sp,sp,-48
    800026f4:	f406                	sd	ra,40(sp)
    800026f6:	f022                	sd	s0,32(sp)
    800026f8:	ec26                	sd	s1,24(sp)
    800026fa:	e84a                	sd	s2,16(sp)
    800026fc:	e44e                	sd	s3,8(sp)
    800026fe:	1800                	addi	s0,sp,48
    80002700:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002702:	00011497          	auipc	s1,0x11
    80002706:	49e48493          	addi	s1,s1,1182 # 80013ba0 <proc>
    8000270a:	00017997          	auipc	s3,0x17
    8000270e:	09698993          	addi	s3,s3,150 # 800197a0 <tickslock>
    {
        acquire(&p->lock);
    80002712:	8526                	mv	a0,s1
    80002714:	ffffe097          	auipc	ra,0xffffe
    80002718:	524080e7          	jalr	1316(ra) # 80000c38 <acquire>
        if (p->pid == pid)
    8000271c:	589c                	lw	a5,48(s1)
    8000271e:	01278d63          	beq	a5,s2,80002738 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002722:	8526                	mv	a0,s1
    80002724:	ffffe097          	auipc	ra,0xffffe
    80002728:	5c8080e7          	jalr	1480(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000272c:	17048493          	addi	s1,s1,368
    80002730:	ff3491e3          	bne	s1,s3,80002712 <kill+0x20>
    }
    return -1;
    80002734:	557d                	li	a0,-1
    80002736:	a829                	j	80002750 <kill+0x5e>
            p->killed = 1;
    80002738:	4785                	li	a5,1
    8000273a:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000273c:	4c98                	lw	a4,24(s1)
    8000273e:	4789                	li	a5,2
    80002740:	00f70f63          	beq	a4,a5,8000275e <kill+0x6c>
            release(&p->lock);
    80002744:	8526                	mv	a0,s1
    80002746:	ffffe097          	auipc	ra,0xffffe
    8000274a:	5a6080e7          	jalr	1446(ra) # 80000cec <release>
            return 0;
    8000274e:	4501                	li	a0,0
}
    80002750:	70a2                	ld	ra,40(sp)
    80002752:	7402                	ld	s0,32(sp)
    80002754:	64e2                	ld	s1,24(sp)
    80002756:	6942                	ld	s2,16(sp)
    80002758:	69a2                	ld	s3,8(sp)
    8000275a:	6145                	addi	sp,sp,48
    8000275c:	8082                	ret
                p->state = RUNNABLE;
    8000275e:	478d                	li	a5,3
    80002760:	cc9c                	sw	a5,24(s1)
    80002762:	b7cd                	j	80002744 <kill+0x52>

0000000080002764 <setkilled>:

void setkilled(struct proc *p)
{
    80002764:	1101                	addi	sp,sp,-32
    80002766:	ec06                	sd	ra,24(sp)
    80002768:	e822                	sd	s0,16(sp)
    8000276a:	e426                	sd	s1,8(sp)
    8000276c:	1000                	addi	s0,sp,32
    8000276e:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002770:	ffffe097          	auipc	ra,0xffffe
    80002774:	4c8080e7          	jalr	1224(ra) # 80000c38 <acquire>
    p->killed = 1;
    80002778:	4785                	li	a5,1
    8000277a:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000277c:	8526                	mv	a0,s1
    8000277e:	ffffe097          	auipc	ra,0xffffe
    80002782:	56e080e7          	jalr	1390(ra) # 80000cec <release>
}
    80002786:	60e2                	ld	ra,24(sp)
    80002788:	6442                	ld	s0,16(sp)
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	6105                	addi	sp,sp,32
    8000278e:	8082                	ret

0000000080002790 <killed>:

int killed(struct proc *p)
{
    80002790:	1101                	addi	sp,sp,-32
    80002792:	ec06                	sd	ra,24(sp)
    80002794:	e822                	sd	s0,16(sp)
    80002796:	e426                	sd	s1,8(sp)
    80002798:	e04a                	sd	s2,0(sp)
    8000279a:	1000                	addi	s0,sp,32
    8000279c:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	49a080e7          	jalr	1178(ra) # 80000c38 <acquire>
    k = p->killed;
    800027a6:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800027aa:	8526                	mv	a0,s1
    800027ac:	ffffe097          	auipc	ra,0xffffe
    800027b0:	540080e7          	jalr	1344(ra) # 80000cec <release>
    return k;
}
    800027b4:	854a                	mv	a0,s2
    800027b6:	60e2                	ld	ra,24(sp)
    800027b8:	6442                	ld	s0,16(sp)
    800027ba:	64a2                	ld	s1,8(sp)
    800027bc:	6902                	ld	s2,0(sp)
    800027be:	6105                	addi	sp,sp,32
    800027c0:	8082                	ret

00000000800027c2 <wait>:
{
    800027c2:	715d                	addi	sp,sp,-80
    800027c4:	e486                	sd	ra,72(sp)
    800027c6:	e0a2                	sd	s0,64(sp)
    800027c8:	fc26                	sd	s1,56(sp)
    800027ca:	f84a                	sd	s2,48(sp)
    800027cc:	f44e                	sd	s3,40(sp)
    800027ce:	f052                	sd	s4,32(sp)
    800027d0:	ec56                	sd	s5,24(sp)
    800027d2:	e85a                	sd	s6,16(sp)
    800027d4:	e45e                	sd	s7,8(sp)
    800027d6:	e062                	sd	s8,0(sp)
    800027d8:	0880                	addi	s0,sp,80
    800027da:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800027dc:	fffff097          	auipc	ra,0xfffff
    800027e0:	528080e7          	jalr	1320(ra) # 80001d04 <myproc>
    800027e4:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800027e6:	00011517          	auipc	a0,0x11
    800027ea:	3a250513          	addi	a0,a0,930 # 80013b88 <wait_lock>
    800027ee:	ffffe097          	auipc	ra,0xffffe
    800027f2:	44a080e7          	jalr	1098(ra) # 80000c38 <acquire>
        havekids = 0;
    800027f6:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    800027f8:	4a15                	li	s4,5
                havekids = 1;
    800027fa:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027fc:	00017997          	auipc	s3,0x17
    80002800:	fa498993          	addi	s3,s3,-92 # 800197a0 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002804:	00011c17          	auipc	s8,0x11
    80002808:	384c0c13          	addi	s8,s8,900 # 80013b88 <wait_lock>
    8000280c:	a0d1                	j	800028d0 <wait+0x10e>
                    pid = pp->pid;
    8000280e:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002812:	000b0e63          	beqz	s6,8000282e <wait+0x6c>
    80002816:	4691                	li	a3,4
    80002818:	02c48613          	addi	a2,s1,44
    8000281c:	85da                	mv	a1,s6
    8000281e:	05893503          	ld	a0,88(s2)
    80002822:	fffff097          	auipc	ra,0xfffff
    80002826:	ec0080e7          	jalr	-320(ra) # 800016e2 <copyout>
    8000282a:	04054163          	bltz	a0,8000286c <wait+0xaa>
                    freeproc(pp);
    8000282e:	8526                	mv	a0,s1
    80002830:	fffff097          	auipc	ra,0xfffff
    80002834:	686080e7          	jalr	1670(ra) # 80001eb6 <freeproc>
                    release(&pp->lock);
    80002838:	8526                	mv	a0,s1
    8000283a:	ffffe097          	auipc	ra,0xffffe
    8000283e:	4b2080e7          	jalr	1202(ra) # 80000cec <release>
                    release(&wait_lock);
    80002842:	00011517          	auipc	a0,0x11
    80002846:	34650513          	addi	a0,a0,838 # 80013b88 <wait_lock>
    8000284a:	ffffe097          	auipc	ra,0xffffe
    8000284e:	4a2080e7          	jalr	1186(ra) # 80000cec <release>
}
    80002852:	854e                	mv	a0,s3
    80002854:	60a6                	ld	ra,72(sp)
    80002856:	6406                	ld	s0,64(sp)
    80002858:	74e2                	ld	s1,56(sp)
    8000285a:	7942                	ld	s2,48(sp)
    8000285c:	79a2                	ld	s3,40(sp)
    8000285e:	7a02                	ld	s4,32(sp)
    80002860:	6ae2                	ld	s5,24(sp)
    80002862:	6b42                	ld	s6,16(sp)
    80002864:	6ba2                	ld	s7,8(sp)
    80002866:	6c02                	ld	s8,0(sp)
    80002868:	6161                	addi	sp,sp,80
    8000286a:	8082                	ret
                        release(&pp->lock);
    8000286c:	8526                	mv	a0,s1
    8000286e:	ffffe097          	auipc	ra,0xffffe
    80002872:	47e080e7          	jalr	1150(ra) # 80000cec <release>
                        release(&wait_lock);
    80002876:	00011517          	auipc	a0,0x11
    8000287a:	31250513          	addi	a0,a0,786 # 80013b88 <wait_lock>
    8000287e:	ffffe097          	auipc	ra,0xffffe
    80002882:	46e080e7          	jalr	1134(ra) # 80000cec <release>
                        return -1;
    80002886:	59fd                	li	s3,-1
    80002888:	b7e9                	j	80002852 <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000288a:	17048493          	addi	s1,s1,368
    8000288e:	03348463          	beq	s1,s3,800028b6 <wait+0xf4>
            if (pp->parent == p)
    80002892:	7c9c                	ld	a5,56(s1)
    80002894:	ff279be3          	bne	a5,s2,8000288a <wait+0xc8>
                acquire(&pp->lock);
    80002898:	8526                	mv	a0,s1
    8000289a:	ffffe097          	auipc	ra,0xffffe
    8000289e:	39e080e7          	jalr	926(ra) # 80000c38 <acquire>
                if (pp->state == ZOMBIE)
    800028a2:	4c9c                	lw	a5,24(s1)
    800028a4:	f74785e3          	beq	a5,s4,8000280e <wait+0x4c>
                release(&pp->lock);
    800028a8:	8526                	mv	a0,s1
    800028aa:	ffffe097          	auipc	ra,0xffffe
    800028ae:	442080e7          	jalr	1090(ra) # 80000cec <release>
                havekids = 1;
    800028b2:	8756                	mv	a4,s5
    800028b4:	bfd9                	j	8000288a <wait+0xc8>
        if (!havekids || killed(p))
    800028b6:	c31d                	beqz	a4,800028dc <wait+0x11a>
    800028b8:	854a                	mv	a0,s2
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	ed6080e7          	jalr	-298(ra) # 80002790 <killed>
    800028c2:	ed09                	bnez	a0,800028dc <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800028c4:	85e2                	mv	a1,s8
    800028c6:	854a                	mv	a0,s2
    800028c8:	00000097          	auipc	ra,0x0
    800028cc:	c20080e7          	jalr	-992(ra) # 800024e8 <sleep>
        havekids = 0;
    800028d0:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800028d2:	00011497          	auipc	s1,0x11
    800028d6:	2ce48493          	addi	s1,s1,718 # 80013ba0 <proc>
    800028da:	bf65                	j	80002892 <wait+0xd0>
            release(&wait_lock);
    800028dc:	00011517          	auipc	a0,0x11
    800028e0:	2ac50513          	addi	a0,a0,684 # 80013b88 <wait_lock>
    800028e4:	ffffe097          	auipc	ra,0xffffe
    800028e8:	408080e7          	jalr	1032(ra) # 80000cec <release>
            return -1;
    800028ec:	59fd                	li	s3,-1
    800028ee:	b795                	j	80002852 <wait+0x90>

00000000800028f0 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800028f0:	7179                	addi	sp,sp,-48
    800028f2:	f406                	sd	ra,40(sp)
    800028f4:	f022                	sd	s0,32(sp)
    800028f6:	ec26                	sd	s1,24(sp)
    800028f8:	e84a                	sd	s2,16(sp)
    800028fa:	e44e                	sd	s3,8(sp)
    800028fc:	e052                	sd	s4,0(sp)
    800028fe:	1800                	addi	s0,sp,48
    80002900:	84aa                	mv	s1,a0
    80002902:	892e                	mv	s2,a1
    80002904:	89b2                	mv	s3,a2
    80002906:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002908:	fffff097          	auipc	ra,0xfffff
    8000290c:	3fc080e7          	jalr	1020(ra) # 80001d04 <myproc>
    if (user_dst)
    80002910:	c08d                	beqz	s1,80002932 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002912:	86d2                	mv	a3,s4
    80002914:	864e                	mv	a2,s3
    80002916:	85ca                	mv	a1,s2
    80002918:	6d28                	ld	a0,88(a0)
    8000291a:	fffff097          	auipc	ra,0xfffff
    8000291e:	dc8080e7          	jalr	-568(ra) # 800016e2 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002922:	70a2                	ld	ra,40(sp)
    80002924:	7402                	ld	s0,32(sp)
    80002926:	64e2                	ld	s1,24(sp)
    80002928:	6942                	ld	s2,16(sp)
    8000292a:	69a2                	ld	s3,8(sp)
    8000292c:	6a02                	ld	s4,0(sp)
    8000292e:	6145                	addi	sp,sp,48
    80002930:	8082                	ret
        memmove((char *)dst, src, len);
    80002932:	000a061b          	sext.w	a2,s4
    80002936:	85ce                	mv	a1,s3
    80002938:	854a                	mv	a0,s2
    8000293a:	ffffe097          	auipc	ra,0xffffe
    8000293e:	456080e7          	jalr	1110(ra) # 80000d90 <memmove>
        return 0;
    80002942:	8526                	mv	a0,s1
    80002944:	bff9                	j	80002922 <either_copyout+0x32>

0000000080002946 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002946:	7179                	addi	sp,sp,-48
    80002948:	f406                	sd	ra,40(sp)
    8000294a:	f022                	sd	s0,32(sp)
    8000294c:	ec26                	sd	s1,24(sp)
    8000294e:	e84a                	sd	s2,16(sp)
    80002950:	e44e                	sd	s3,8(sp)
    80002952:	e052                	sd	s4,0(sp)
    80002954:	1800                	addi	s0,sp,48
    80002956:	892a                	mv	s2,a0
    80002958:	84ae                	mv	s1,a1
    8000295a:	89b2                	mv	s3,a2
    8000295c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000295e:	fffff097          	auipc	ra,0xfffff
    80002962:	3a6080e7          	jalr	934(ra) # 80001d04 <myproc>
    if (user_src)
    80002966:	c08d                	beqz	s1,80002988 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002968:	86d2                	mv	a3,s4
    8000296a:	864e                	mv	a2,s3
    8000296c:	85ca                	mv	a1,s2
    8000296e:	6d28                	ld	a0,88(a0)
    80002970:	fffff097          	auipc	ra,0xfffff
    80002974:	dfe080e7          	jalr	-514(ra) # 8000176e <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002978:	70a2                	ld	ra,40(sp)
    8000297a:	7402                	ld	s0,32(sp)
    8000297c:	64e2                	ld	s1,24(sp)
    8000297e:	6942                	ld	s2,16(sp)
    80002980:	69a2                	ld	s3,8(sp)
    80002982:	6a02                	ld	s4,0(sp)
    80002984:	6145                	addi	sp,sp,48
    80002986:	8082                	ret
        memmove(dst, (char *)src, len);
    80002988:	000a061b          	sext.w	a2,s4
    8000298c:	85ce                	mv	a1,s3
    8000298e:	854a                	mv	a0,s2
    80002990:	ffffe097          	auipc	ra,0xffffe
    80002994:	400080e7          	jalr	1024(ra) # 80000d90 <memmove>
        return 0;
    80002998:	8526                	mv	a0,s1
    8000299a:	bff9                	j	80002978 <either_copyin+0x32>

000000008000299c <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    8000299c:	715d                	addi	sp,sp,-80
    8000299e:	e486                	sd	ra,72(sp)
    800029a0:	e0a2                	sd	s0,64(sp)
    800029a2:	fc26                	sd	s1,56(sp)
    800029a4:	f84a                	sd	s2,48(sp)
    800029a6:	f44e                	sd	s3,40(sp)
    800029a8:	f052                	sd	s4,32(sp)
    800029aa:	ec56                	sd	s5,24(sp)
    800029ac:	e85a                	sd	s6,16(sp)
    800029ae:	e45e                	sd	s7,8(sp)
    800029b0:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800029b2:	00005517          	auipc	a0,0x5
    800029b6:	65e50513          	addi	a0,a0,1630 # 80008010 <etext+0x10>
    800029ba:	ffffe097          	auipc	ra,0xffffe
    800029be:	bf0080e7          	jalr	-1040(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800029c2:	00011497          	auipc	s1,0x11
    800029c6:	33e48493          	addi	s1,s1,830 # 80013d00 <proc+0x160>
    800029ca:	00017917          	auipc	s2,0x17
    800029ce:	f3690913          	addi	s2,s2,-202 # 80019900 <bcache+0x148>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029d2:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800029d4:	00006997          	auipc	s3,0x6
    800029d8:	8a498993          	addi	s3,s3,-1884 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    800029dc:	00006a97          	auipc	s5,0x6
    800029e0:	8a4a8a93          	addi	s5,s5,-1884 # 80008280 <etext+0x280>
        printf("\n");
    800029e4:	00005a17          	auipc	s4,0x5
    800029e8:	62ca0a13          	addi	s4,s4,1580 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029ec:	00006b97          	auipc	s7,0x6
    800029f0:	e3cb8b93          	addi	s7,s7,-452 # 80008828 <states.0>
    800029f4:	a00d                	j	80002a16 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    800029f6:	ed06a583          	lw	a1,-304(a3)
    800029fa:	8556                	mv	a0,s5
    800029fc:	ffffe097          	auipc	ra,0xffffe
    80002a00:	bae080e7          	jalr	-1106(ra) # 800005aa <printf>
        printf("\n");
    80002a04:	8552                	mv	a0,s4
    80002a06:	ffffe097          	auipc	ra,0xffffe
    80002a0a:	ba4080e7          	jalr	-1116(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a0e:	17048493          	addi	s1,s1,368
    80002a12:	03248263          	beq	s1,s2,80002a36 <procdump+0x9a>
        if (p->state == UNUSED)
    80002a16:	86a6                	mv	a3,s1
    80002a18:	eb84a783          	lw	a5,-328(s1)
    80002a1c:	dbed                	beqz	a5,80002a0e <procdump+0x72>
            state = "???";
    80002a1e:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a20:	fcfb6be3          	bltu	s6,a5,800029f6 <procdump+0x5a>
    80002a24:	02079713          	slli	a4,a5,0x20
    80002a28:	01d75793          	srli	a5,a4,0x1d
    80002a2c:	97de                	add	a5,a5,s7
    80002a2e:	6390                	ld	a2,0(a5)
    80002a30:	f279                	bnez	a2,800029f6 <procdump+0x5a>
            state = "???";
    80002a32:	864e                	mv	a2,s3
    80002a34:	b7c9                	j	800029f6 <procdump+0x5a>
    }
}
    80002a36:	60a6                	ld	ra,72(sp)
    80002a38:	6406                	ld	s0,64(sp)
    80002a3a:	74e2                	ld	s1,56(sp)
    80002a3c:	7942                	ld	s2,48(sp)
    80002a3e:	79a2                	ld	s3,40(sp)
    80002a40:	7a02                	ld	s4,32(sp)
    80002a42:	6ae2                	ld	s5,24(sp)
    80002a44:	6b42                	ld	s6,16(sp)
    80002a46:	6ba2                	ld	s7,8(sp)
    80002a48:	6161                	addi	sp,sp,80
    80002a4a:	8082                	ret

0000000080002a4c <schedls>:

void schedls()
{
    80002a4c:	1101                	addi	sp,sp,-32
    80002a4e:	ec06                	sd	ra,24(sp)
    80002a50:	e822                	sd	s0,16(sp)
    80002a52:	e426                	sd	s1,8(sp)
    80002a54:	1000                	addi	s0,sp,32
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002a56:	00006517          	auipc	a0,0x6
    80002a5a:	83a50513          	addi	a0,a0,-1990 # 80008290 <etext+0x290>
    80002a5e:	ffffe097          	auipc	ra,0xffffe
    80002a62:	b4c080e7          	jalr	-1204(ra) # 800005aa <printf>
    printf("====================================\n");
    80002a66:	00006517          	auipc	a0,0x6
    80002a6a:	85250513          	addi	a0,a0,-1966 # 800082b8 <etext+0x2b8>
    80002a6e:	ffffe097          	auipc	ra,0xffffe
    80002a72:	b3c080e7          	jalr	-1220(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002a76:	00009717          	auipc	a4,0x9
    80002a7a:	a0273703          	ld	a4,-1534(a4) # 8000b478 <available_schedulers+0x10>
    80002a7e:	00009797          	auipc	a5,0x9
    80002a82:	99a7b783          	ld	a5,-1638(a5) # 8000b418 <sched_pointer>
    80002a86:	08f70763          	beq	a4,a5,80002b14 <schedls+0xc8>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002a8a:	00006517          	auipc	a0,0x6
    80002a8e:	85650513          	addi	a0,a0,-1962 # 800082e0 <etext+0x2e0>
    80002a92:	ffffe097          	auipc	ra,0xffffe
    80002a96:	b18080e7          	jalr	-1256(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002a9a:	00009497          	auipc	s1,0x9
    80002a9e:	99648493          	addi	s1,s1,-1642 # 8000b430 <initcode>
    80002aa2:	48b0                	lw	a2,80(s1)
    80002aa4:	00009597          	auipc	a1,0x9
    80002aa8:	9c458593          	addi	a1,a1,-1596 # 8000b468 <available_schedulers>
    80002aac:	00006517          	auipc	a0,0x6
    80002ab0:	84450513          	addi	a0,a0,-1980 # 800082f0 <etext+0x2f0>
    80002ab4:	ffffe097          	auipc	ra,0xffffe
    80002ab8:	af6080e7          	jalr	-1290(ra) # 800005aa <printf>
        if (available_schedulers[i].impl == sched_pointer)
    80002abc:	74b8                	ld	a4,104(s1)
    80002abe:	00009797          	auipc	a5,0x9
    80002ac2:	95a7b783          	ld	a5,-1702(a5) # 8000b418 <sched_pointer>
    80002ac6:	06f70063          	beq	a4,a5,80002b26 <schedls+0xda>
            printf("   \t");
    80002aca:	00006517          	auipc	a0,0x6
    80002ace:	81650513          	addi	a0,a0,-2026 # 800082e0 <etext+0x2e0>
    80002ad2:	ffffe097          	auipc	ra,0xffffe
    80002ad6:	ad8080e7          	jalr	-1320(ra) # 800005aa <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002ada:	00009617          	auipc	a2,0x9
    80002ade:	9c662603          	lw	a2,-1594(a2) # 8000b4a0 <available_schedulers+0x38>
    80002ae2:	00009597          	auipc	a1,0x9
    80002ae6:	9a658593          	addi	a1,a1,-1626 # 8000b488 <available_schedulers+0x20>
    80002aea:	00006517          	auipc	a0,0x6
    80002aee:	80650513          	addi	a0,a0,-2042 # 800082f0 <etext+0x2f0>
    80002af2:	ffffe097          	auipc	ra,0xffffe
    80002af6:	ab8080e7          	jalr	-1352(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002afa:	00005517          	auipc	a0,0x5
    80002afe:	7fe50513          	addi	a0,a0,2046 # 800082f8 <etext+0x2f8>
    80002b02:	ffffe097          	auipc	ra,0xffffe
    80002b06:	aa8080e7          	jalr	-1368(ra) # 800005aa <printf>
}
    80002b0a:	60e2                	ld	ra,24(sp)
    80002b0c:	6442                	ld	s0,16(sp)
    80002b0e:	64a2                	ld	s1,8(sp)
    80002b10:	6105                	addi	sp,sp,32
    80002b12:	8082                	ret
            printf("[*]\t");
    80002b14:	00005517          	auipc	a0,0x5
    80002b18:	7d450513          	addi	a0,a0,2004 # 800082e8 <etext+0x2e8>
    80002b1c:	ffffe097          	auipc	ra,0xffffe
    80002b20:	a8e080e7          	jalr	-1394(ra) # 800005aa <printf>
    80002b24:	bf9d                	j	80002a9a <schedls+0x4e>
    80002b26:	00005517          	auipc	a0,0x5
    80002b2a:	7c250513          	addi	a0,a0,1986 # 800082e8 <etext+0x2e8>
    80002b2e:	ffffe097          	auipc	ra,0xffffe
    80002b32:	a7c080e7          	jalr	-1412(ra) # 800005aa <printf>
    80002b36:	b755                	j	80002ada <schedls+0x8e>

0000000080002b38 <schedset>:

void schedset(int id)
{
    80002b38:	1141                	addi	sp,sp,-16
    80002b3a:	e406                	sd	ra,8(sp)
    80002b3c:	e022                	sd	s0,0(sp)
    80002b3e:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002b40:	4705                	li	a4,1
    80002b42:	02a76f63          	bltu	a4,a0,80002b80 <schedset+0x48>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002b46:	00551793          	slli	a5,a0,0x5
    80002b4a:	00009717          	auipc	a4,0x9
    80002b4e:	8e670713          	addi	a4,a4,-1818 # 8000b430 <initcode>
    80002b52:	973e                	add	a4,a4,a5
    80002b54:	6738                	ld	a4,72(a4)
    80002b56:	00009697          	auipc	a3,0x9
    80002b5a:	8ce6b123          	sd	a4,-1854(a3) # 8000b418 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002b5e:	00009597          	auipc	a1,0x9
    80002b62:	90a58593          	addi	a1,a1,-1782 # 8000b468 <available_schedulers>
    80002b66:	95be                	add	a1,a1,a5
    80002b68:	00005517          	auipc	a0,0x5
    80002b6c:	7d050513          	addi	a0,a0,2000 # 80008338 <etext+0x338>
    80002b70:	ffffe097          	auipc	ra,0xffffe
    80002b74:	a3a080e7          	jalr	-1478(ra) # 800005aa <printf>
    80002b78:	60a2                	ld	ra,8(sp)
    80002b7a:	6402                	ld	s0,0(sp)
    80002b7c:	0141                	addi	sp,sp,16
    80002b7e:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002b80:	00005517          	auipc	a0,0x5
    80002b84:	79050513          	addi	a0,a0,1936 # 80008310 <etext+0x310>
    80002b88:	ffffe097          	auipc	ra,0xffffe
    80002b8c:	a22080e7          	jalr	-1502(ra) # 800005aa <printf>
        return;
    80002b90:	b7e5                	j	80002b78 <schedset+0x40>

0000000080002b92 <swtch>:
    80002b92:	00153023          	sd	ra,0(a0)
    80002b96:	00253423          	sd	sp,8(a0)
    80002b9a:	e900                	sd	s0,16(a0)
    80002b9c:	ed04                	sd	s1,24(a0)
    80002b9e:	03253023          	sd	s2,32(a0)
    80002ba2:	03353423          	sd	s3,40(a0)
    80002ba6:	03453823          	sd	s4,48(a0)
    80002baa:	03553c23          	sd	s5,56(a0)
    80002bae:	05653023          	sd	s6,64(a0)
    80002bb2:	05753423          	sd	s7,72(a0)
    80002bb6:	05853823          	sd	s8,80(a0)
    80002bba:	05953c23          	sd	s9,88(a0)
    80002bbe:	07a53023          	sd	s10,96(a0)
    80002bc2:	07b53423          	sd	s11,104(a0)
    80002bc6:	0005b083          	ld	ra,0(a1)
    80002bca:	0085b103          	ld	sp,8(a1)
    80002bce:	6980                	ld	s0,16(a1)
    80002bd0:	6d84                	ld	s1,24(a1)
    80002bd2:	0205b903          	ld	s2,32(a1)
    80002bd6:	0285b983          	ld	s3,40(a1)
    80002bda:	0305ba03          	ld	s4,48(a1)
    80002bde:	0385ba83          	ld	s5,56(a1)
    80002be2:	0405bb03          	ld	s6,64(a1)
    80002be6:	0485bb83          	ld	s7,72(a1)
    80002bea:	0505bc03          	ld	s8,80(a1)
    80002bee:	0585bc83          	ld	s9,88(a1)
    80002bf2:	0605bd03          	ld	s10,96(a1)
    80002bf6:	0685bd83          	ld	s11,104(a1)
    80002bfa:	8082                	ret

0000000080002bfc <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002bfc:	1141                	addi	sp,sp,-16
    80002bfe:	e406                	sd	ra,8(sp)
    80002c00:	e022                	sd	s0,0(sp)
    80002c02:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002c04:	00005597          	auipc	a1,0x5
    80002c08:	78c58593          	addi	a1,a1,1932 # 80008390 <etext+0x390>
    80002c0c:	00017517          	auipc	a0,0x17
    80002c10:	b9450513          	addi	a0,a0,-1132 # 800197a0 <tickslock>
    80002c14:	ffffe097          	auipc	ra,0xffffe
    80002c18:	f94080e7          	jalr	-108(ra) # 80000ba8 <initlock>
}
    80002c1c:	60a2                	ld	ra,8(sp)
    80002c1e:	6402                	ld	s0,0(sp)
    80002c20:	0141                	addi	sp,sp,16
    80002c22:	8082                	ret

0000000080002c24 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002c24:	1141                	addi	sp,sp,-16
    80002c26:	e422                	sd	s0,8(sp)
    80002c28:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c2a:	00003797          	auipc	a5,0x3
    80002c2e:	66678793          	addi	a5,a5,1638 # 80006290 <kernelvec>
    80002c32:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002c36:	6422                	ld	s0,8(sp)
    80002c38:	0141                	addi	sp,sp,16
    80002c3a:	8082                	ret

0000000080002c3c <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002c3c:	1141                	addi	sp,sp,-16
    80002c3e:	e406                	sd	ra,8(sp)
    80002c40:	e022                	sd	s0,0(sp)
    80002c42:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002c44:	fffff097          	auipc	ra,0xfffff
    80002c48:	0c0080e7          	jalr	192(ra) # 80001d04 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c50:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c52:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002c56:	00004697          	auipc	a3,0x4
    80002c5a:	3aa68693          	addi	a3,a3,938 # 80007000 <_trampoline>
    80002c5e:	00004717          	auipc	a4,0x4
    80002c62:	3a270713          	addi	a4,a4,930 # 80007000 <_trampoline>
    80002c66:	8f15                	sub	a4,a4,a3
    80002c68:	040007b7          	lui	a5,0x4000
    80002c6c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002c6e:	07b2                	slli	a5,a5,0xc
    80002c70:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c72:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002c76:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002c78:	18002673          	csrr	a2,satp
    80002c7c:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c7e:	7130                	ld	a2,96(a0)
    80002c80:	6538                	ld	a4,72(a0)
    80002c82:	6585                	lui	a1,0x1
    80002c84:	972e                	add	a4,a4,a1
    80002c86:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002c88:	7138                	ld	a4,96(a0)
    80002c8a:	00000617          	auipc	a2,0x0
    80002c8e:	13860613          	addi	a2,a2,312 # 80002dc2 <usertrap>
    80002c92:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002c94:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c96:	8612                	mv	a2,tp
    80002c98:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c9a:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c9e:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002ca2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ca6:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002caa:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cac:	6f18                	ld	a4,24(a4)
    80002cae:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002cb2:	6d28                	ld	a0,88(a0)
    80002cb4:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002cb6:	00004717          	auipc	a4,0x4
    80002cba:	3e670713          	addi	a4,a4,998 # 8000709c <userret>
    80002cbe:	8f15                	sub	a4,a4,a3
    80002cc0:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002cc2:	577d                	li	a4,-1
    80002cc4:	177e                	slli	a4,a4,0x3f
    80002cc6:	8d59                	or	a0,a0,a4
    80002cc8:	9782                	jalr	a5
}
    80002cca:	60a2                	ld	ra,8(sp)
    80002ccc:	6402                	ld	s0,0(sp)
    80002cce:	0141                	addi	sp,sp,16
    80002cd0:	8082                	ret

0000000080002cd2 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002cd2:	1101                	addi	sp,sp,-32
    80002cd4:	ec06                	sd	ra,24(sp)
    80002cd6:	e822                	sd	s0,16(sp)
    80002cd8:	e426                	sd	s1,8(sp)
    80002cda:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002cdc:	00017497          	auipc	s1,0x17
    80002ce0:	ac448493          	addi	s1,s1,-1340 # 800197a0 <tickslock>
    80002ce4:	8526                	mv	a0,s1
    80002ce6:	ffffe097          	auipc	ra,0xffffe
    80002cea:	f52080e7          	jalr	-174(ra) # 80000c38 <acquire>
    ticks++;
    80002cee:	00009517          	auipc	a0,0x9
    80002cf2:	81250513          	addi	a0,a0,-2030 # 8000b500 <ticks>
    80002cf6:	411c                	lw	a5,0(a0)
    80002cf8:	2785                	addiw	a5,a5,1
    80002cfa:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002cfc:	00000097          	auipc	ra,0x0
    80002d00:	850080e7          	jalr	-1968(ra) # 8000254c <wakeup>
    release(&tickslock);
    80002d04:	8526                	mv	a0,s1
    80002d06:	ffffe097          	auipc	ra,0xffffe
    80002d0a:	fe6080e7          	jalr	-26(ra) # 80000cec <release>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	64a2                	ld	s1,8(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret

0000000080002d18 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d18:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002d1c:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002d1e:	0a07d163          	bgez	a5,80002dc0 <devintr+0xa8>
{
    80002d22:	1101                	addi	sp,sp,-32
    80002d24:	ec06                	sd	ra,24(sp)
    80002d26:	e822                	sd	s0,16(sp)
    80002d28:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002d2a:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002d2e:	46a5                	li	a3,9
    80002d30:	00d70c63          	beq	a4,a3,80002d48 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002d34:	577d                	li	a4,-1
    80002d36:	177e                	slli	a4,a4,0x3f
    80002d38:	0705                	addi	a4,a4,1
        return 0;
    80002d3a:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002d3c:	06e78163          	beq	a5,a4,80002d9e <devintr+0x86>
    }
}
    80002d40:	60e2                	ld	ra,24(sp)
    80002d42:	6442                	ld	s0,16(sp)
    80002d44:	6105                	addi	sp,sp,32
    80002d46:	8082                	ret
    80002d48:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002d4a:	00003097          	auipc	ra,0x3
    80002d4e:	652080e7          	jalr	1618(ra) # 8000639c <plic_claim>
    80002d52:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002d54:	47a9                	li	a5,10
    80002d56:	00f50963          	beq	a0,a5,80002d68 <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002d5a:	4785                	li	a5,1
    80002d5c:	00f50b63          	beq	a0,a5,80002d72 <devintr+0x5a>
        return 1;
    80002d60:	4505                	li	a0,1
        else if (irq)
    80002d62:	ec89                	bnez	s1,80002d7c <devintr+0x64>
    80002d64:	64a2                	ld	s1,8(sp)
    80002d66:	bfe9                	j	80002d40 <devintr+0x28>
            uartintr();
    80002d68:	ffffe097          	auipc	ra,0xffffe
    80002d6c:	c92080e7          	jalr	-878(ra) # 800009fa <uartintr>
        if (irq)
    80002d70:	a839                	j	80002d8e <devintr+0x76>
            virtio_disk_intr();
    80002d72:	00004097          	auipc	ra,0x4
    80002d76:	b54080e7          	jalr	-1196(ra) # 800068c6 <virtio_disk_intr>
        if (irq)
    80002d7a:	a811                	j	80002d8e <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002d7c:	85a6                	mv	a1,s1
    80002d7e:	00005517          	auipc	a0,0x5
    80002d82:	61a50513          	addi	a0,a0,1562 # 80008398 <etext+0x398>
    80002d86:	ffffe097          	auipc	ra,0xffffe
    80002d8a:	824080e7          	jalr	-2012(ra) # 800005aa <printf>
            plic_complete(irq);
    80002d8e:	8526                	mv	a0,s1
    80002d90:	00003097          	auipc	ra,0x3
    80002d94:	630080e7          	jalr	1584(ra) # 800063c0 <plic_complete>
        return 1;
    80002d98:	4505                	li	a0,1
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	b755                	j	80002d40 <devintr+0x28>
        if (cpuid() == 0)
    80002d9e:	fffff097          	auipc	ra,0xfffff
    80002da2:	f3a080e7          	jalr	-198(ra) # 80001cd8 <cpuid>
    80002da6:	c901                	beqz	a0,80002db6 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002da8:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002dac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002dae:	14479073          	csrw	sip,a5
        return 2;
    80002db2:	4509                	li	a0,2
    80002db4:	b771                	j	80002d40 <devintr+0x28>
            clockintr();
    80002db6:	00000097          	auipc	ra,0x0
    80002dba:	f1c080e7          	jalr	-228(ra) # 80002cd2 <clockintr>
    80002dbe:	b7ed                	j	80002da8 <devintr+0x90>
}
    80002dc0:	8082                	ret

0000000080002dc2 <usertrap>:
{
    80002dc2:	1101                	addi	sp,sp,-32
    80002dc4:	ec06                	sd	ra,24(sp)
    80002dc6:	e822                	sd	s0,16(sp)
    80002dc8:	e426                	sd	s1,8(sp)
    80002dca:	e04a                	sd	s2,0(sp)
    80002dcc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dce:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002dd2:	1007f793          	andi	a5,a5,256
    80002dd6:	e3b1                	bnez	a5,80002e1a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002dd8:	00003797          	auipc	a5,0x3
    80002ddc:	4b878793          	addi	a5,a5,1208 # 80006290 <kernelvec>
    80002de0:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	f20080e7          	jalr	-224(ra) # 80001d04 <myproc>
    80002dec:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002dee:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002df0:	14102773          	csrr	a4,sepc
    80002df4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002df6:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002dfa:	47a1                	li	a5,8
    80002dfc:	02f70763          	beq	a4,a5,80002e2a <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002e00:	00000097          	auipc	ra,0x0
    80002e04:	f18080e7          	jalr	-232(ra) # 80002d18 <devintr>
    80002e08:	892a                	mv	s2,a0
    80002e0a:	c151                	beqz	a0,80002e8e <usertrap+0xcc>
    if (killed(p))
    80002e0c:	8526                	mv	a0,s1
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	982080e7          	jalr	-1662(ra) # 80002790 <killed>
    80002e16:	c929                	beqz	a0,80002e68 <usertrap+0xa6>
    80002e18:	a099                	j	80002e5e <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002e1a:	00005517          	auipc	a0,0x5
    80002e1e:	59e50513          	addi	a0,a0,1438 # 800083b8 <etext+0x3b8>
    80002e22:	ffffd097          	auipc	ra,0xffffd
    80002e26:	73e080e7          	jalr	1854(ra) # 80000560 <panic>
        if (killed(p))
    80002e2a:	00000097          	auipc	ra,0x0
    80002e2e:	966080e7          	jalr	-1690(ra) # 80002790 <killed>
    80002e32:	e921                	bnez	a0,80002e82 <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002e34:	70b8                	ld	a4,96(s1)
    80002e36:	6f1c                	ld	a5,24(a4)
    80002e38:	0791                	addi	a5,a5,4
    80002e3a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e3c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e40:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e44:	10079073          	csrw	sstatus,a5
        syscall();
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	2dc080e7          	jalr	732(ra) # 80003124 <syscall>
    if (killed(p))
    80002e50:	8526                	mv	a0,s1
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	93e080e7          	jalr	-1730(ra) # 80002790 <killed>
    80002e5a:	c911                	beqz	a0,80002e6e <usertrap+0xac>
    80002e5c:	4901                	li	s2,0
        exit(-1);
    80002e5e:	557d                	li	a0,-1
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	7bc080e7          	jalr	1980(ra) # 8000261c <exit>
    if (which_dev == 2) {
    80002e68:	4789                	li	a5,2
    80002e6a:	04f90f63          	beq	s2,a5,80002ec8 <usertrap+0x106>
    usertrapret();
    80002e6e:	00000097          	auipc	ra,0x0
    80002e72:	dce080e7          	jalr	-562(ra) # 80002c3c <usertrapret>
}
    80002e76:	60e2                	ld	ra,24(sp)
    80002e78:	6442                	ld	s0,16(sp)
    80002e7a:	64a2                	ld	s1,8(sp)
    80002e7c:	6902                	ld	s2,0(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret
            exit(-1);
    80002e82:	557d                	li	a0,-1
    80002e84:	fffff097          	auipc	ra,0xfffff
    80002e88:	798080e7          	jalr	1944(ra) # 8000261c <exit>
    80002e8c:	b765                	j	80002e34 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e8e:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002e92:	5890                	lw	a2,48(s1)
    80002e94:	00005517          	auipc	a0,0x5
    80002e98:	54450513          	addi	a0,a0,1348 # 800083d8 <etext+0x3d8>
    80002e9c:	ffffd097          	auipc	ra,0xffffd
    80002ea0:	70e080e7          	jalr	1806(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ea4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ea8:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002eac:	00005517          	auipc	a0,0x5
    80002eb0:	55c50513          	addi	a0,a0,1372 # 80008408 <etext+0x408>
    80002eb4:	ffffd097          	auipc	ra,0xffffd
    80002eb8:	6f6080e7          	jalr	1782(ra) # 800005aa <printf>
        setkilled(p);
    80002ebc:	8526                	mv	a0,s1
    80002ebe:	00000097          	auipc	ra,0x0
    80002ec2:	8a6080e7          	jalr	-1882(ra) # 80002764 <setkilled>
    80002ec6:	b769                	j	80002e50 <usertrap+0x8e>
       p->priority = 1;
    80002ec8:	4785                	li	a5,1
    80002eca:	c0bc                	sw	a5,64(s1)
       yield(YIELD_TIMER); // yield
    80002ecc:	4505                	li	a0,1
    80002ece:	fffff097          	auipc	ra,0xfffff
    80002ed2:	5da080e7          	jalr	1498(ra) # 800024a8 <yield>
    80002ed6:	bf61                	j	80002e6e <usertrap+0xac>

0000000080002ed8 <kerneltrap>:
{
    80002ed8:	7179                	addi	sp,sp,-48
    80002eda:	f406                	sd	ra,40(sp)
    80002edc:	f022                	sd	s0,32(sp)
    80002ede:	ec26                	sd	s1,24(sp)
    80002ee0:	e84a                	sd	s2,16(sp)
    80002ee2:	e44e                	sd	s3,8(sp)
    80002ee4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ee6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002eea:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002eee:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002ef2:	1004f793          	andi	a5,s1,256
    80002ef6:	cb85                	beqz	a5,80002f26 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ef8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002efc:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002efe:	ef85                	bnez	a5,80002f36 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	e18080e7          	jalr	-488(ra) # 80002d18 <devintr>
    80002f08:	cd1d                	beqz	a0,80002f46 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f0a:	4789                	li	a5,2
    80002f0c:	06f50a63          	beq	a0,a5,80002f80 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f10:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f14:	10049073          	csrw	sstatus,s1
}
    80002f18:	70a2                	ld	ra,40(sp)
    80002f1a:	7402                	ld	s0,32(sp)
    80002f1c:	64e2                	ld	s1,24(sp)
    80002f1e:	6942                	ld	s2,16(sp)
    80002f20:	69a2                	ld	s3,8(sp)
    80002f22:	6145                	addi	sp,sp,48
    80002f24:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002f26:	00005517          	auipc	a0,0x5
    80002f2a:	50250513          	addi	a0,a0,1282 # 80008428 <etext+0x428>
    80002f2e:	ffffd097          	auipc	ra,0xffffd
    80002f32:	632080e7          	jalr	1586(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002f36:	00005517          	auipc	a0,0x5
    80002f3a:	51a50513          	addi	a0,a0,1306 # 80008450 <etext+0x450>
    80002f3e:	ffffd097          	auipc	ra,0xffffd
    80002f42:	622080e7          	jalr	1570(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002f46:	85ce                	mv	a1,s3
    80002f48:	00005517          	auipc	a0,0x5
    80002f4c:	52850513          	addi	a0,a0,1320 # 80008470 <etext+0x470>
    80002f50:	ffffd097          	auipc	ra,0xffffd
    80002f54:	65a080e7          	jalr	1626(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f58:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f5c:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f60:	00005517          	auipc	a0,0x5
    80002f64:	52050513          	addi	a0,a0,1312 # 80008480 <etext+0x480>
    80002f68:	ffffd097          	auipc	ra,0xffffd
    80002f6c:	642080e7          	jalr	1602(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002f70:	00005517          	auipc	a0,0x5
    80002f74:	52850513          	addi	a0,a0,1320 # 80008498 <etext+0x498>
    80002f78:	ffffd097          	auipc	ra,0xffffd
    80002f7c:	5e8080e7          	jalr	1512(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	d84080e7          	jalr	-636(ra) # 80001d04 <myproc>
    80002f88:	d541                	beqz	a0,80002f10 <kerneltrap+0x38>
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	d7a080e7          	jalr	-646(ra) # 80001d04 <myproc>
    80002f92:	4d18                	lw	a4,24(a0)
    80002f94:	4791                	li	a5,4
    80002f96:	f6f71de3          	bne	a4,a5,80002f10 <kerneltrap+0x38>
        yield(YIELD_OTHER);
    80002f9a:	4509                	li	a0,2
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	50c080e7          	jalr	1292(ra) # 800024a8 <yield>
    80002fa4:	b7b5                	j	80002f10 <kerneltrap+0x38>

0000000080002fa6 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002fa6:	1101                	addi	sp,sp,-32
    80002fa8:	ec06                	sd	ra,24(sp)
    80002faa:	e822                	sd	s0,16(sp)
    80002fac:	e426                	sd	s1,8(sp)
    80002fae:	1000                	addi	s0,sp,32
    80002fb0:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002fb2:	fffff097          	auipc	ra,0xfffff
    80002fb6:	d52080e7          	jalr	-686(ra) # 80001d04 <myproc>
    switch (n)
    80002fba:	4795                	li	a5,5
    80002fbc:	0497e163          	bltu	a5,s1,80002ffe <argraw+0x58>
    80002fc0:	048a                	slli	s1,s1,0x2
    80002fc2:	00006717          	auipc	a4,0x6
    80002fc6:	89670713          	addi	a4,a4,-1898 # 80008858 <states.0+0x30>
    80002fca:	94ba                	add	s1,s1,a4
    80002fcc:	409c                	lw	a5,0(s1)
    80002fce:	97ba                	add	a5,a5,a4
    80002fd0:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002fd2:	713c                	ld	a5,96(a0)
    80002fd4:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002fd6:	60e2                	ld	ra,24(sp)
    80002fd8:	6442                	ld	s0,16(sp)
    80002fda:	64a2                	ld	s1,8(sp)
    80002fdc:	6105                	addi	sp,sp,32
    80002fde:	8082                	ret
        return p->trapframe->a1;
    80002fe0:	713c                	ld	a5,96(a0)
    80002fe2:	7fa8                	ld	a0,120(a5)
    80002fe4:	bfcd                	j	80002fd6 <argraw+0x30>
        return p->trapframe->a2;
    80002fe6:	713c                	ld	a5,96(a0)
    80002fe8:	63c8                	ld	a0,128(a5)
    80002fea:	b7f5                	j	80002fd6 <argraw+0x30>
        return p->trapframe->a3;
    80002fec:	713c                	ld	a5,96(a0)
    80002fee:	67c8                	ld	a0,136(a5)
    80002ff0:	b7dd                	j	80002fd6 <argraw+0x30>
        return p->trapframe->a4;
    80002ff2:	713c                	ld	a5,96(a0)
    80002ff4:	6bc8                	ld	a0,144(a5)
    80002ff6:	b7c5                	j	80002fd6 <argraw+0x30>
        return p->trapframe->a5;
    80002ff8:	713c                	ld	a5,96(a0)
    80002ffa:	6fc8                	ld	a0,152(a5)
    80002ffc:	bfe9                	j	80002fd6 <argraw+0x30>
    panic("argraw");
    80002ffe:	00005517          	auipc	a0,0x5
    80003002:	4aa50513          	addi	a0,a0,1194 # 800084a8 <etext+0x4a8>
    80003006:	ffffd097          	auipc	ra,0xffffd
    8000300a:	55a080e7          	jalr	1370(ra) # 80000560 <panic>

000000008000300e <fetchaddr>:
{
    8000300e:	1101                	addi	sp,sp,-32
    80003010:	ec06                	sd	ra,24(sp)
    80003012:	e822                	sd	s0,16(sp)
    80003014:	e426                	sd	s1,8(sp)
    80003016:	e04a                	sd	s2,0(sp)
    80003018:	1000                	addi	s0,sp,32
    8000301a:	84aa                	mv	s1,a0
    8000301c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	ce6080e7          	jalr	-794(ra) # 80001d04 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003026:	693c                	ld	a5,80(a0)
    80003028:	02f4f863          	bgeu	s1,a5,80003058 <fetchaddr+0x4a>
    8000302c:	00848713          	addi	a4,s1,8
    80003030:	02e7e663          	bltu	a5,a4,8000305c <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003034:	46a1                	li	a3,8
    80003036:	8626                	mv	a2,s1
    80003038:	85ca                	mv	a1,s2
    8000303a:	6d28                	ld	a0,88(a0)
    8000303c:	ffffe097          	auipc	ra,0xffffe
    80003040:	732080e7          	jalr	1842(ra) # 8000176e <copyin>
    80003044:	00a03533          	snez	a0,a0
    80003048:	40a00533          	neg	a0,a0
}
    8000304c:	60e2                	ld	ra,24(sp)
    8000304e:	6442                	ld	s0,16(sp)
    80003050:	64a2                	ld	s1,8(sp)
    80003052:	6902                	ld	s2,0(sp)
    80003054:	6105                	addi	sp,sp,32
    80003056:	8082                	ret
        return -1;
    80003058:	557d                	li	a0,-1
    8000305a:	bfcd                	j	8000304c <fetchaddr+0x3e>
    8000305c:	557d                	li	a0,-1
    8000305e:	b7fd                	j	8000304c <fetchaddr+0x3e>

0000000080003060 <fetchstr>:
{
    80003060:	7179                	addi	sp,sp,-48
    80003062:	f406                	sd	ra,40(sp)
    80003064:	f022                	sd	s0,32(sp)
    80003066:	ec26                	sd	s1,24(sp)
    80003068:	e84a                	sd	s2,16(sp)
    8000306a:	e44e                	sd	s3,8(sp)
    8000306c:	1800                	addi	s0,sp,48
    8000306e:	892a                	mv	s2,a0
    80003070:	84ae                	mv	s1,a1
    80003072:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	c90080e7          	jalr	-880(ra) # 80001d04 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    8000307c:	86ce                	mv	a3,s3
    8000307e:	864a                	mv	a2,s2
    80003080:	85a6                	mv	a1,s1
    80003082:	6d28                	ld	a0,88(a0)
    80003084:	ffffe097          	auipc	ra,0xffffe
    80003088:	778080e7          	jalr	1912(ra) # 800017fc <copyinstr>
    8000308c:	00054e63          	bltz	a0,800030a8 <fetchstr+0x48>
    return strlen(buf);
    80003090:	8526                	mv	a0,s1
    80003092:	ffffe097          	auipc	ra,0xffffe
    80003096:	e16080e7          	jalr	-490(ra) # 80000ea8 <strlen>
}
    8000309a:	70a2                	ld	ra,40(sp)
    8000309c:	7402                	ld	s0,32(sp)
    8000309e:	64e2                	ld	s1,24(sp)
    800030a0:	6942                	ld	s2,16(sp)
    800030a2:	69a2                	ld	s3,8(sp)
    800030a4:	6145                	addi	sp,sp,48
    800030a6:	8082                	ret
        return -1;
    800030a8:	557d                	li	a0,-1
    800030aa:	bfc5                	j	8000309a <fetchstr+0x3a>

00000000800030ac <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    800030ac:	1101                	addi	sp,sp,-32
    800030ae:	ec06                	sd	ra,24(sp)
    800030b0:	e822                	sd	s0,16(sp)
    800030b2:	e426                	sd	s1,8(sp)
    800030b4:	1000                	addi	s0,sp,32
    800030b6:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800030b8:	00000097          	auipc	ra,0x0
    800030bc:	eee080e7          	jalr	-274(ra) # 80002fa6 <argraw>
    800030c0:	c088                	sw	a0,0(s1)
}
    800030c2:	60e2                	ld	ra,24(sp)
    800030c4:	6442                	ld	s0,16(sp)
    800030c6:	64a2                	ld	s1,8(sp)
    800030c8:	6105                	addi	sp,sp,32
    800030ca:	8082                	ret

00000000800030cc <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800030cc:	1101                	addi	sp,sp,-32
    800030ce:	ec06                	sd	ra,24(sp)
    800030d0:	e822                	sd	s0,16(sp)
    800030d2:	e426                	sd	s1,8(sp)
    800030d4:	1000                	addi	s0,sp,32
    800030d6:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800030d8:	00000097          	auipc	ra,0x0
    800030dc:	ece080e7          	jalr	-306(ra) # 80002fa6 <argraw>
    800030e0:	e088                	sd	a0,0(s1)
}
    800030e2:	60e2                	ld	ra,24(sp)
    800030e4:	6442                	ld	s0,16(sp)
    800030e6:	64a2                	ld	s1,8(sp)
    800030e8:	6105                	addi	sp,sp,32
    800030ea:	8082                	ret

00000000800030ec <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800030ec:	7179                	addi	sp,sp,-48
    800030ee:	f406                	sd	ra,40(sp)
    800030f0:	f022                	sd	s0,32(sp)
    800030f2:	ec26                	sd	s1,24(sp)
    800030f4:	e84a                	sd	s2,16(sp)
    800030f6:	1800                	addi	s0,sp,48
    800030f8:	84ae                	mv	s1,a1
    800030fa:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800030fc:	fd840593          	addi	a1,s0,-40
    80003100:	00000097          	auipc	ra,0x0
    80003104:	fcc080e7          	jalr	-52(ra) # 800030cc <argaddr>
    return fetchstr(addr, buf, max);
    80003108:	864a                	mv	a2,s2
    8000310a:	85a6                	mv	a1,s1
    8000310c:	fd843503          	ld	a0,-40(s0)
    80003110:	00000097          	auipc	ra,0x0
    80003114:	f50080e7          	jalr	-176(ra) # 80003060 <fetchstr>
}
    80003118:	70a2                	ld	ra,40(sp)
    8000311a:	7402                	ld	s0,32(sp)
    8000311c:	64e2                	ld	s1,24(sp)
    8000311e:	6942                	ld	s2,16(sp)
    80003120:	6145                	addi	sp,sp,48
    80003122:	8082                	ret

0000000080003124 <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    80003124:	1101                	addi	sp,sp,-32
    80003126:	ec06                	sd	ra,24(sp)
    80003128:	e822                	sd	s0,16(sp)
    8000312a:	e426                	sd	s1,8(sp)
    8000312c:	e04a                	sd	s2,0(sp)
    8000312e:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80003130:	fffff097          	auipc	ra,0xfffff
    80003134:	bd4080e7          	jalr	-1068(ra) # 80001d04 <myproc>
    80003138:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    8000313a:	06053903          	ld	s2,96(a0)
    8000313e:	0a893783          	ld	a5,168(s2)
    80003142:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80003146:	37fd                	addiw	a5,a5,-1
    80003148:	4761                	li	a4,24
    8000314a:	00f76f63          	bltu	a4,a5,80003168 <syscall+0x44>
    8000314e:	00369713          	slli	a4,a3,0x3
    80003152:	00005797          	auipc	a5,0x5
    80003156:	71e78793          	addi	a5,a5,1822 # 80008870 <syscalls>
    8000315a:	97ba                	add	a5,a5,a4
    8000315c:	639c                	ld	a5,0(a5)
    8000315e:	c789                	beqz	a5,80003168 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003160:	9782                	jalr	a5
    80003162:	06a93823          	sd	a0,112(s2)
    80003166:	a839                	j	80003184 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80003168:	16048613          	addi	a2,s1,352
    8000316c:	588c                	lw	a1,48(s1)
    8000316e:	00005517          	auipc	a0,0x5
    80003172:	34250513          	addi	a0,a0,834 # 800084b0 <etext+0x4b0>
    80003176:	ffffd097          	auipc	ra,0xffffd
    8000317a:	434080e7          	jalr	1076(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    8000317e:	70bc                	ld	a5,96(s1)
    80003180:	577d                	li	a4,-1
    80003182:	fbb8                	sd	a4,112(a5)
    }
}
    80003184:	60e2                	ld	ra,24(sp)
    80003186:	6442                	ld	s0,16(sp)
    80003188:	64a2                	ld	s1,8(sp)
    8000318a:	6902                	ld	s2,0(sp)
    8000318c:	6105                	addi	sp,sp,32
    8000318e:	8082                	ret

0000000080003190 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003190:	1101                	addi	sp,sp,-32
    80003192:	ec06                	sd	ra,24(sp)
    80003194:	e822                	sd	s0,16(sp)
    80003196:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80003198:	fec40593          	addi	a1,s0,-20
    8000319c:	4501                	li	a0,0
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	f0e080e7          	jalr	-242(ra) # 800030ac <argint>
    exit(n);
    800031a6:	fec42503          	lw	a0,-20(s0)
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	472080e7          	jalr	1138(ra) # 8000261c <exit>
    return 0; // not reached
}
    800031b2:	4501                	li	a0,0
    800031b4:	60e2                	ld	ra,24(sp)
    800031b6:	6442                	ld	s0,16(sp)
    800031b8:	6105                	addi	sp,sp,32
    800031ba:	8082                	ret

00000000800031bc <sys_getpid>:

uint64
sys_getpid(void)
{
    800031bc:	1141                	addi	sp,sp,-16
    800031be:	e406                	sd	ra,8(sp)
    800031c0:	e022                	sd	s0,0(sp)
    800031c2:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800031c4:	fffff097          	auipc	ra,0xfffff
    800031c8:	b40080e7          	jalr	-1216(ra) # 80001d04 <myproc>
}
    800031cc:	5908                	lw	a0,48(a0)
    800031ce:	60a2                	ld	ra,8(sp)
    800031d0:	6402                	ld	s0,0(sp)
    800031d2:	0141                	addi	sp,sp,16
    800031d4:	8082                	ret

00000000800031d6 <sys_fork>:

uint64
sys_fork(void)
{
    800031d6:	1141                	addi	sp,sp,-16
    800031d8:	e406                	sd	ra,8(sp)
    800031da:	e022                	sd	s0,0(sp)
    800031dc:	0800                	addi	s0,sp,16
    return fork();
    800031de:	fffff097          	auipc	ra,0xfffff
    800031e2:	07c080e7          	jalr	124(ra) # 8000225a <fork>
}
    800031e6:	60a2                	ld	ra,8(sp)
    800031e8:	6402                	ld	s0,0(sp)
    800031ea:	0141                	addi	sp,sp,16
    800031ec:	8082                	ret

00000000800031ee <sys_wait>:

uint64
sys_wait(void)
{
    800031ee:	1101                	addi	sp,sp,-32
    800031f0:	ec06                	sd	ra,24(sp)
    800031f2:	e822                	sd	s0,16(sp)
    800031f4:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    800031f6:	fe840593          	addi	a1,s0,-24
    800031fa:	4501                	li	a0,0
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	ed0080e7          	jalr	-304(ra) # 800030cc <argaddr>
    return wait(p);
    80003204:	fe843503          	ld	a0,-24(s0)
    80003208:	fffff097          	auipc	ra,0xfffff
    8000320c:	5ba080e7          	jalr	1466(ra) # 800027c2 <wait>
}
    80003210:	60e2                	ld	ra,24(sp)
    80003212:	6442                	ld	s0,16(sp)
    80003214:	6105                	addi	sp,sp,32
    80003216:	8082                	ret

0000000080003218 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003218:	7179                	addi	sp,sp,-48
    8000321a:	f406                	sd	ra,40(sp)
    8000321c:	f022                	sd	s0,32(sp)
    8000321e:	ec26                	sd	s1,24(sp)
    80003220:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80003222:	fdc40593          	addi	a1,s0,-36
    80003226:	4501                	li	a0,0
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	e84080e7          	jalr	-380(ra) # 800030ac <argint>
    addr = myproc()->sz;
    80003230:	fffff097          	auipc	ra,0xfffff
    80003234:	ad4080e7          	jalr	-1324(ra) # 80001d04 <myproc>
    80003238:	6924                	ld	s1,80(a0)
    if (growproc(n) < 0)
    8000323a:	fdc42503          	lw	a0,-36(s0)
    8000323e:	fffff097          	auipc	ra,0xfffff
    80003242:	e28080e7          	jalr	-472(ra) # 80002066 <growproc>
    80003246:	00054863          	bltz	a0,80003256 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    8000324a:	8526                	mv	a0,s1
    8000324c:	70a2                	ld	ra,40(sp)
    8000324e:	7402                	ld	s0,32(sp)
    80003250:	64e2                	ld	s1,24(sp)
    80003252:	6145                	addi	sp,sp,48
    80003254:	8082                	ret
        return -1;
    80003256:	54fd                	li	s1,-1
    80003258:	bfcd                	j	8000324a <sys_sbrk+0x32>

000000008000325a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000325a:	7139                	addi	sp,sp,-64
    8000325c:	fc06                	sd	ra,56(sp)
    8000325e:	f822                	sd	s0,48(sp)
    80003260:	f04a                	sd	s2,32(sp)
    80003262:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80003264:	fcc40593          	addi	a1,s0,-52
    80003268:	4501                	li	a0,0
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	e42080e7          	jalr	-446(ra) # 800030ac <argint>
    acquire(&tickslock);
    80003272:	00016517          	auipc	a0,0x16
    80003276:	52e50513          	addi	a0,a0,1326 # 800197a0 <tickslock>
    8000327a:	ffffe097          	auipc	ra,0xffffe
    8000327e:	9be080e7          	jalr	-1602(ra) # 80000c38 <acquire>
    ticks0 = ticks;
    80003282:	00008917          	auipc	s2,0x8
    80003286:	27e92903          	lw	s2,638(s2) # 8000b500 <ticks>
    while (ticks - ticks0 < n)
    8000328a:	fcc42783          	lw	a5,-52(s0)
    8000328e:	c3b9                	beqz	a5,800032d4 <sys_sleep+0x7a>
    80003290:	f426                	sd	s1,40(sp)
    80003292:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80003294:	00016997          	auipc	s3,0x16
    80003298:	50c98993          	addi	s3,s3,1292 # 800197a0 <tickslock>
    8000329c:	00008497          	auipc	s1,0x8
    800032a0:	26448493          	addi	s1,s1,612 # 8000b500 <ticks>
        if (killed(myproc()))
    800032a4:	fffff097          	auipc	ra,0xfffff
    800032a8:	a60080e7          	jalr	-1440(ra) # 80001d04 <myproc>
    800032ac:	fffff097          	auipc	ra,0xfffff
    800032b0:	4e4080e7          	jalr	1252(ra) # 80002790 <killed>
    800032b4:	ed15                	bnez	a0,800032f0 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    800032b6:	85ce                	mv	a1,s3
    800032b8:	8526                	mv	a0,s1
    800032ba:	fffff097          	auipc	ra,0xfffff
    800032be:	22e080e7          	jalr	558(ra) # 800024e8 <sleep>
    while (ticks - ticks0 < n)
    800032c2:	409c                	lw	a5,0(s1)
    800032c4:	412787bb          	subw	a5,a5,s2
    800032c8:	fcc42703          	lw	a4,-52(s0)
    800032cc:	fce7ece3          	bltu	a5,a4,800032a4 <sys_sleep+0x4a>
    800032d0:	74a2                	ld	s1,40(sp)
    800032d2:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    800032d4:	00016517          	auipc	a0,0x16
    800032d8:	4cc50513          	addi	a0,a0,1228 # 800197a0 <tickslock>
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	a10080e7          	jalr	-1520(ra) # 80000cec <release>
    return 0;
    800032e4:	4501                	li	a0,0
}
    800032e6:	70e2                	ld	ra,56(sp)
    800032e8:	7442                	ld	s0,48(sp)
    800032ea:	7902                	ld	s2,32(sp)
    800032ec:	6121                	addi	sp,sp,64
    800032ee:	8082                	ret
            release(&tickslock);
    800032f0:	00016517          	auipc	a0,0x16
    800032f4:	4b050513          	addi	a0,a0,1200 # 800197a0 <tickslock>
    800032f8:	ffffe097          	auipc	ra,0xffffe
    800032fc:	9f4080e7          	jalr	-1548(ra) # 80000cec <release>
            return -1;
    80003300:	557d                	li	a0,-1
    80003302:	74a2                	ld	s1,40(sp)
    80003304:	69e2                	ld	s3,24(sp)
    80003306:	b7c5                	j	800032e6 <sys_sleep+0x8c>

0000000080003308 <sys_kill>:

uint64
sys_kill(void)
{
    80003308:	1101                	addi	sp,sp,-32
    8000330a:	ec06                	sd	ra,24(sp)
    8000330c:	e822                	sd	s0,16(sp)
    8000330e:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    80003310:	fec40593          	addi	a1,s0,-20
    80003314:	4501                	li	a0,0
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	d96080e7          	jalr	-618(ra) # 800030ac <argint>
    return kill(pid);
    8000331e:	fec42503          	lw	a0,-20(s0)
    80003322:	fffff097          	auipc	ra,0xfffff
    80003326:	3d0080e7          	jalr	976(ra) # 800026f2 <kill>
}
    8000332a:	60e2                	ld	ra,24(sp)
    8000332c:	6442                	ld	s0,16(sp)
    8000332e:	6105                	addi	sp,sp,32
    80003330:	8082                	ret

0000000080003332 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003332:	1101                	addi	sp,sp,-32
    80003334:	ec06                	sd	ra,24(sp)
    80003336:	e822                	sd	s0,16(sp)
    80003338:	e426                	sd	s1,8(sp)
    8000333a:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    8000333c:	00016517          	auipc	a0,0x16
    80003340:	46450513          	addi	a0,a0,1124 # 800197a0 <tickslock>
    80003344:	ffffe097          	auipc	ra,0xffffe
    80003348:	8f4080e7          	jalr	-1804(ra) # 80000c38 <acquire>
    xticks = ticks;
    8000334c:	00008497          	auipc	s1,0x8
    80003350:	1b44a483          	lw	s1,436(s1) # 8000b500 <ticks>
    release(&tickslock);
    80003354:	00016517          	auipc	a0,0x16
    80003358:	44c50513          	addi	a0,a0,1100 # 800197a0 <tickslock>
    8000335c:	ffffe097          	auipc	ra,0xffffe
    80003360:	990080e7          	jalr	-1648(ra) # 80000cec <release>
    return xticks;
}
    80003364:	02049513          	slli	a0,s1,0x20
    80003368:	9101                	srli	a0,a0,0x20
    8000336a:	60e2                	ld	ra,24(sp)
    8000336c:	6442                	ld	s0,16(sp)
    8000336e:	64a2                	ld	s1,8(sp)
    80003370:	6105                	addi	sp,sp,32
    80003372:	8082                	ret

0000000080003374 <sys_ps>:

void *
sys_ps(void)
{
    80003374:	1101                	addi	sp,sp,-32
    80003376:	ec06                	sd	ra,24(sp)
    80003378:	e822                	sd	s0,16(sp)
    8000337a:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    8000337c:	fe042623          	sw	zero,-20(s0)
    80003380:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    80003384:	fec40593          	addi	a1,s0,-20
    80003388:	4501                	li	a0,0
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	d22080e7          	jalr	-734(ra) # 800030ac <argint>
    argint(1, &count);
    80003392:	fe840593          	addi	a1,s0,-24
    80003396:	4505                	li	a0,1
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	d14080e7          	jalr	-748(ra) # 800030ac <argint>
    return ps((uint8)start, (uint8)count);
    800033a0:	fe844583          	lbu	a1,-24(s0)
    800033a4:	fec44503          	lbu	a0,-20(s0)
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	d1a080e7          	jalr	-742(ra) # 800020c2 <ps>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret

00000000800033b8 <sys_schedls>:

uint64 sys_schedls(void)
{
    800033b8:	1141                	addi	sp,sp,-16
    800033ba:	e406                	sd	ra,8(sp)
    800033bc:	e022                	sd	s0,0(sp)
    800033be:	0800                	addi	s0,sp,16
    schedls();
    800033c0:	fffff097          	auipc	ra,0xfffff
    800033c4:	68c080e7          	jalr	1676(ra) # 80002a4c <schedls>
    return 0;
}
    800033c8:	4501                	li	a0,0
    800033ca:	60a2                	ld	ra,8(sp)
    800033cc:	6402                	ld	s0,0(sp)
    800033ce:	0141                	addi	sp,sp,16
    800033d0:	8082                	ret

00000000800033d2 <sys_schedset>:

uint64 sys_schedset(void)
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	1000                	addi	s0,sp,32
    int id = 0;
    800033da:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    800033de:	fec40593          	addi	a1,s0,-20
    800033e2:	4501                	li	a0,0
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	cc8080e7          	jalr	-824(ra) # 800030ac <argint>
    schedset(id - 1);
    800033ec:	fec42503          	lw	a0,-20(s0)
    800033f0:	357d                	addiw	a0,a0,-1
    800033f2:	fffff097          	auipc	ra,0xfffff
    800033f6:	746080e7          	jalr	1862(ra) # 80002b38 <schedset>
    return 0;
}
    800033fa:	4501                	li	a0,0
    800033fc:	60e2                	ld	ra,24(sp)
    800033fe:	6442                	ld	s0,16(sp)
    80003400:	6105                	addi	sp,sp,32
    80003402:	8082                	ret

0000000080003404 <sys_yield>:

uint64 sys_yield(void)
{
    80003404:	1141                	addi	sp,sp,-16
    80003406:	e406                	sd	ra,8(sp)
    80003408:	e022                	sd	s0,0(sp)
    8000340a:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    8000340c:	4509                	li	a0,2
    8000340e:	fffff097          	auipc	ra,0xfffff
    80003412:	09a080e7          	jalr	154(ra) # 800024a8 <yield>
    return 0;
}
    80003416:	4501                	li	a0,0
    80003418:	60a2                	ld	ra,8(sp)
    8000341a:	6402                	ld	s0,0(sp)
    8000341c:	0141                	addi	sp,sp,16
    8000341e:	8082                	ret

0000000080003420 <sys_getprio>:

uint64 sys_getprio(void) {
    80003420:	1141                	addi	sp,sp,-16
    80003422:	e406                	sd	ra,8(sp)
    80003424:	e022                	sd	s0,0(sp)
    80003426:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80003428:	fffff097          	auipc	ra,0xfffff
    8000342c:	8dc080e7          	jalr	-1828(ra) # 80001d04 <myproc>
    return p->priority;
    80003430:	4128                	lw	a0,64(a0)
    80003432:	60a2                	ld	ra,8(sp)
    80003434:	6402                	ld	s0,0(sp)
    80003436:	0141                	addi	sp,sp,16
    80003438:	8082                	ret

000000008000343a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000343a:	7179                	addi	sp,sp,-48
    8000343c:	f406                	sd	ra,40(sp)
    8000343e:	f022                	sd	s0,32(sp)
    80003440:	ec26                	sd	s1,24(sp)
    80003442:	e84a                	sd	s2,16(sp)
    80003444:	e44e                	sd	s3,8(sp)
    80003446:	e052                	sd	s4,0(sp)
    80003448:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000344a:	00005597          	auipc	a1,0x5
    8000344e:	08658593          	addi	a1,a1,134 # 800084d0 <etext+0x4d0>
    80003452:	00016517          	auipc	a0,0x16
    80003456:	36650513          	addi	a0,a0,870 # 800197b8 <bcache>
    8000345a:	ffffd097          	auipc	ra,0xffffd
    8000345e:	74e080e7          	jalr	1870(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003462:	0001e797          	auipc	a5,0x1e
    80003466:	35678793          	addi	a5,a5,854 # 800217b8 <bcache+0x8000>
    8000346a:	0001e717          	auipc	a4,0x1e
    8000346e:	5b670713          	addi	a4,a4,1462 # 80021a20 <bcache+0x8268>
    80003472:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003476:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000347a:	00016497          	auipc	s1,0x16
    8000347e:	35648493          	addi	s1,s1,854 # 800197d0 <bcache+0x18>
    b->next = bcache.head.next;
    80003482:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003484:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003486:	00005a17          	auipc	s4,0x5
    8000348a:	052a0a13          	addi	s4,s4,82 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    8000348e:	2b893783          	ld	a5,696(s2)
    80003492:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003494:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003498:	85d2                	mv	a1,s4
    8000349a:	01048513          	addi	a0,s1,16
    8000349e:	00001097          	auipc	ra,0x1
    800034a2:	4e8080e7          	jalr	1256(ra) # 80004986 <initsleeplock>
    bcache.head.next->prev = b;
    800034a6:	2b893783          	ld	a5,696(s2)
    800034aa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800034ac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800034b0:	45848493          	addi	s1,s1,1112
    800034b4:	fd349de3          	bne	s1,s3,8000348e <binit+0x54>
  }
}
    800034b8:	70a2                	ld	ra,40(sp)
    800034ba:	7402                	ld	s0,32(sp)
    800034bc:	64e2                	ld	s1,24(sp)
    800034be:	6942                	ld	s2,16(sp)
    800034c0:	69a2                	ld	s3,8(sp)
    800034c2:	6a02                	ld	s4,0(sp)
    800034c4:	6145                	addi	sp,sp,48
    800034c6:	8082                	ret

00000000800034c8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800034c8:	7179                	addi	sp,sp,-48
    800034ca:	f406                	sd	ra,40(sp)
    800034cc:	f022                	sd	s0,32(sp)
    800034ce:	ec26                	sd	s1,24(sp)
    800034d0:	e84a                	sd	s2,16(sp)
    800034d2:	e44e                	sd	s3,8(sp)
    800034d4:	1800                	addi	s0,sp,48
    800034d6:	892a                	mv	s2,a0
    800034d8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800034da:	00016517          	auipc	a0,0x16
    800034de:	2de50513          	addi	a0,a0,734 # 800197b8 <bcache>
    800034e2:	ffffd097          	auipc	ra,0xffffd
    800034e6:	756080e7          	jalr	1878(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800034ea:	0001e497          	auipc	s1,0x1e
    800034ee:	5864b483          	ld	s1,1414(s1) # 80021a70 <bcache+0x82b8>
    800034f2:	0001e797          	auipc	a5,0x1e
    800034f6:	52e78793          	addi	a5,a5,1326 # 80021a20 <bcache+0x8268>
    800034fa:	02f48f63          	beq	s1,a5,80003538 <bread+0x70>
    800034fe:	873e                	mv	a4,a5
    80003500:	a021                	j	80003508 <bread+0x40>
    80003502:	68a4                	ld	s1,80(s1)
    80003504:	02e48a63          	beq	s1,a4,80003538 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003508:	449c                	lw	a5,8(s1)
    8000350a:	ff279ce3          	bne	a5,s2,80003502 <bread+0x3a>
    8000350e:	44dc                	lw	a5,12(s1)
    80003510:	ff3799e3          	bne	a5,s3,80003502 <bread+0x3a>
      b->refcnt++;
    80003514:	40bc                	lw	a5,64(s1)
    80003516:	2785                	addiw	a5,a5,1
    80003518:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000351a:	00016517          	auipc	a0,0x16
    8000351e:	29e50513          	addi	a0,a0,670 # 800197b8 <bcache>
    80003522:	ffffd097          	auipc	ra,0xffffd
    80003526:	7ca080e7          	jalr	1994(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    8000352a:	01048513          	addi	a0,s1,16
    8000352e:	00001097          	auipc	ra,0x1
    80003532:	492080e7          	jalr	1170(ra) # 800049c0 <acquiresleep>
      return b;
    80003536:	a8b9                	j	80003594 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003538:	0001e497          	auipc	s1,0x1e
    8000353c:	5304b483          	ld	s1,1328(s1) # 80021a68 <bcache+0x82b0>
    80003540:	0001e797          	auipc	a5,0x1e
    80003544:	4e078793          	addi	a5,a5,1248 # 80021a20 <bcache+0x8268>
    80003548:	00f48863          	beq	s1,a5,80003558 <bread+0x90>
    8000354c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000354e:	40bc                	lw	a5,64(s1)
    80003550:	cf81                	beqz	a5,80003568 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003552:	64a4                	ld	s1,72(s1)
    80003554:	fee49de3          	bne	s1,a4,8000354e <bread+0x86>
  panic("bget: no buffers");
    80003558:	00005517          	auipc	a0,0x5
    8000355c:	f8850513          	addi	a0,a0,-120 # 800084e0 <etext+0x4e0>
    80003560:	ffffd097          	auipc	ra,0xffffd
    80003564:	000080e7          	jalr	ra # 80000560 <panic>
      b->dev = dev;
    80003568:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000356c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003570:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003574:	4785                	li	a5,1
    80003576:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003578:	00016517          	auipc	a0,0x16
    8000357c:	24050513          	addi	a0,a0,576 # 800197b8 <bcache>
    80003580:	ffffd097          	auipc	ra,0xffffd
    80003584:	76c080e7          	jalr	1900(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003588:	01048513          	addi	a0,s1,16
    8000358c:	00001097          	auipc	ra,0x1
    80003590:	434080e7          	jalr	1076(ra) # 800049c0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003594:	409c                	lw	a5,0(s1)
    80003596:	cb89                	beqz	a5,800035a8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003598:	8526                	mv	a0,s1
    8000359a:	70a2                	ld	ra,40(sp)
    8000359c:	7402                	ld	s0,32(sp)
    8000359e:	64e2                	ld	s1,24(sp)
    800035a0:	6942                	ld	s2,16(sp)
    800035a2:	69a2                	ld	s3,8(sp)
    800035a4:	6145                	addi	sp,sp,48
    800035a6:	8082                	ret
    virtio_disk_rw(b, 0);
    800035a8:	4581                	li	a1,0
    800035aa:	8526                	mv	a0,s1
    800035ac:	00003097          	auipc	ra,0x3
    800035b0:	0ec080e7          	jalr	236(ra) # 80006698 <virtio_disk_rw>
    b->valid = 1;
    800035b4:	4785                	li	a5,1
    800035b6:	c09c                	sw	a5,0(s1)
  return b;
    800035b8:	b7c5                	j	80003598 <bread+0xd0>

00000000800035ba <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800035ba:	1101                	addi	sp,sp,-32
    800035bc:	ec06                	sd	ra,24(sp)
    800035be:	e822                	sd	s0,16(sp)
    800035c0:	e426                	sd	s1,8(sp)
    800035c2:	1000                	addi	s0,sp,32
    800035c4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035c6:	0541                	addi	a0,a0,16
    800035c8:	00001097          	auipc	ra,0x1
    800035cc:	492080e7          	jalr	1170(ra) # 80004a5a <holdingsleep>
    800035d0:	cd01                	beqz	a0,800035e8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800035d2:	4585                	li	a1,1
    800035d4:	8526                	mv	a0,s1
    800035d6:	00003097          	auipc	ra,0x3
    800035da:	0c2080e7          	jalr	194(ra) # 80006698 <virtio_disk_rw>
}
    800035de:	60e2                	ld	ra,24(sp)
    800035e0:	6442                	ld	s0,16(sp)
    800035e2:	64a2                	ld	s1,8(sp)
    800035e4:	6105                	addi	sp,sp,32
    800035e6:	8082                	ret
    panic("bwrite");
    800035e8:	00005517          	auipc	a0,0x5
    800035ec:	f1050513          	addi	a0,a0,-240 # 800084f8 <etext+0x4f8>
    800035f0:	ffffd097          	auipc	ra,0xffffd
    800035f4:	f70080e7          	jalr	-144(ra) # 80000560 <panic>

00000000800035f8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035f8:	1101                	addi	sp,sp,-32
    800035fa:	ec06                	sd	ra,24(sp)
    800035fc:	e822                	sd	s0,16(sp)
    800035fe:	e426                	sd	s1,8(sp)
    80003600:	e04a                	sd	s2,0(sp)
    80003602:	1000                	addi	s0,sp,32
    80003604:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003606:	01050913          	addi	s2,a0,16
    8000360a:	854a                	mv	a0,s2
    8000360c:	00001097          	auipc	ra,0x1
    80003610:	44e080e7          	jalr	1102(ra) # 80004a5a <holdingsleep>
    80003614:	c925                	beqz	a0,80003684 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003616:	854a                	mv	a0,s2
    80003618:	00001097          	auipc	ra,0x1
    8000361c:	3fe080e7          	jalr	1022(ra) # 80004a16 <releasesleep>

  acquire(&bcache.lock);
    80003620:	00016517          	auipc	a0,0x16
    80003624:	19850513          	addi	a0,a0,408 # 800197b8 <bcache>
    80003628:	ffffd097          	auipc	ra,0xffffd
    8000362c:	610080e7          	jalr	1552(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003630:	40bc                	lw	a5,64(s1)
    80003632:	37fd                	addiw	a5,a5,-1
    80003634:	0007871b          	sext.w	a4,a5
    80003638:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000363a:	e71d                	bnez	a4,80003668 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000363c:	68b8                	ld	a4,80(s1)
    8000363e:	64bc                	ld	a5,72(s1)
    80003640:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003642:	68b8                	ld	a4,80(s1)
    80003644:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003646:	0001e797          	auipc	a5,0x1e
    8000364a:	17278793          	addi	a5,a5,370 # 800217b8 <bcache+0x8000>
    8000364e:	2b87b703          	ld	a4,696(a5)
    80003652:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003654:	0001e717          	auipc	a4,0x1e
    80003658:	3cc70713          	addi	a4,a4,972 # 80021a20 <bcache+0x8268>
    8000365c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000365e:	2b87b703          	ld	a4,696(a5)
    80003662:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003664:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003668:	00016517          	auipc	a0,0x16
    8000366c:	15050513          	addi	a0,a0,336 # 800197b8 <bcache>
    80003670:	ffffd097          	auipc	ra,0xffffd
    80003674:	67c080e7          	jalr	1660(ra) # 80000cec <release>
}
    80003678:	60e2                	ld	ra,24(sp)
    8000367a:	6442                	ld	s0,16(sp)
    8000367c:	64a2                	ld	s1,8(sp)
    8000367e:	6902                	ld	s2,0(sp)
    80003680:	6105                	addi	sp,sp,32
    80003682:	8082                	ret
    panic("brelse");
    80003684:	00005517          	auipc	a0,0x5
    80003688:	e7c50513          	addi	a0,a0,-388 # 80008500 <etext+0x500>
    8000368c:	ffffd097          	auipc	ra,0xffffd
    80003690:	ed4080e7          	jalr	-300(ra) # 80000560 <panic>

0000000080003694 <bpin>:

void
bpin(struct buf *b) {
    80003694:	1101                	addi	sp,sp,-32
    80003696:	ec06                	sd	ra,24(sp)
    80003698:	e822                	sd	s0,16(sp)
    8000369a:	e426                	sd	s1,8(sp)
    8000369c:	1000                	addi	s0,sp,32
    8000369e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800036a0:	00016517          	auipc	a0,0x16
    800036a4:	11850513          	addi	a0,a0,280 # 800197b8 <bcache>
    800036a8:	ffffd097          	auipc	ra,0xffffd
    800036ac:	590080e7          	jalr	1424(ra) # 80000c38 <acquire>
  b->refcnt++;
    800036b0:	40bc                	lw	a5,64(s1)
    800036b2:	2785                	addiw	a5,a5,1
    800036b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036b6:	00016517          	auipc	a0,0x16
    800036ba:	10250513          	addi	a0,a0,258 # 800197b8 <bcache>
    800036be:	ffffd097          	auipc	ra,0xffffd
    800036c2:	62e080e7          	jalr	1582(ra) # 80000cec <release>
}
    800036c6:	60e2                	ld	ra,24(sp)
    800036c8:	6442                	ld	s0,16(sp)
    800036ca:	64a2                	ld	s1,8(sp)
    800036cc:	6105                	addi	sp,sp,32
    800036ce:	8082                	ret

00000000800036d0 <bunpin>:

void
bunpin(struct buf *b) {
    800036d0:	1101                	addi	sp,sp,-32
    800036d2:	ec06                	sd	ra,24(sp)
    800036d4:	e822                	sd	s0,16(sp)
    800036d6:	e426                	sd	s1,8(sp)
    800036d8:	1000                	addi	s0,sp,32
    800036da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800036dc:	00016517          	auipc	a0,0x16
    800036e0:	0dc50513          	addi	a0,a0,220 # 800197b8 <bcache>
    800036e4:	ffffd097          	auipc	ra,0xffffd
    800036e8:	554080e7          	jalr	1364(ra) # 80000c38 <acquire>
  b->refcnt--;
    800036ec:	40bc                	lw	a5,64(s1)
    800036ee:	37fd                	addiw	a5,a5,-1
    800036f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036f2:	00016517          	auipc	a0,0x16
    800036f6:	0c650513          	addi	a0,a0,198 # 800197b8 <bcache>
    800036fa:	ffffd097          	auipc	ra,0xffffd
    800036fe:	5f2080e7          	jalr	1522(ra) # 80000cec <release>
}
    80003702:	60e2                	ld	ra,24(sp)
    80003704:	6442                	ld	s0,16(sp)
    80003706:	64a2                	ld	s1,8(sp)
    80003708:	6105                	addi	sp,sp,32
    8000370a:	8082                	ret

000000008000370c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000370c:	1101                	addi	sp,sp,-32
    8000370e:	ec06                	sd	ra,24(sp)
    80003710:	e822                	sd	s0,16(sp)
    80003712:	e426                	sd	s1,8(sp)
    80003714:	e04a                	sd	s2,0(sp)
    80003716:	1000                	addi	s0,sp,32
    80003718:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000371a:	00d5d59b          	srliw	a1,a1,0xd
    8000371e:	0001e797          	auipc	a5,0x1e
    80003722:	7767a783          	lw	a5,1910(a5) # 80021e94 <sb+0x1c>
    80003726:	9dbd                	addw	a1,a1,a5
    80003728:	00000097          	auipc	ra,0x0
    8000372c:	da0080e7          	jalr	-608(ra) # 800034c8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003730:	0074f713          	andi	a4,s1,7
    80003734:	4785                	li	a5,1
    80003736:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000373a:	14ce                	slli	s1,s1,0x33
    8000373c:	90d9                	srli	s1,s1,0x36
    8000373e:	00950733          	add	a4,a0,s1
    80003742:	05874703          	lbu	a4,88(a4)
    80003746:	00e7f6b3          	and	a3,a5,a4
    8000374a:	c69d                	beqz	a3,80003778 <bfree+0x6c>
    8000374c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000374e:	94aa                	add	s1,s1,a0
    80003750:	fff7c793          	not	a5,a5
    80003754:	8f7d                	and	a4,a4,a5
    80003756:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000375a:	00001097          	auipc	ra,0x1
    8000375e:	148080e7          	jalr	328(ra) # 800048a2 <log_write>
  brelse(bp);
    80003762:	854a                	mv	a0,s2
    80003764:	00000097          	auipc	ra,0x0
    80003768:	e94080e7          	jalr	-364(ra) # 800035f8 <brelse>
}
    8000376c:	60e2                	ld	ra,24(sp)
    8000376e:	6442                	ld	s0,16(sp)
    80003770:	64a2                	ld	s1,8(sp)
    80003772:	6902                	ld	s2,0(sp)
    80003774:	6105                	addi	sp,sp,32
    80003776:	8082                	ret
    panic("freeing free block");
    80003778:	00005517          	auipc	a0,0x5
    8000377c:	d9050513          	addi	a0,a0,-624 # 80008508 <etext+0x508>
    80003780:	ffffd097          	auipc	ra,0xffffd
    80003784:	de0080e7          	jalr	-544(ra) # 80000560 <panic>

0000000080003788 <balloc>:
{
    80003788:	711d                	addi	sp,sp,-96
    8000378a:	ec86                	sd	ra,88(sp)
    8000378c:	e8a2                	sd	s0,80(sp)
    8000378e:	e4a6                	sd	s1,72(sp)
    80003790:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003792:	0001e797          	auipc	a5,0x1e
    80003796:	6ea7a783          	lw	a5,1770(a5) # 80021e7c <sb+0x4>
    8000379a:	10078f63          	beqz	a5,800038b8 <balloc+0x130>
    8000379e:	e0ca                	sd	s2,64(sp)
    800037a0:	fc4e                	sd	s3,56(sp)
    800037a2:	f852                	sd	s4,48(sp)
    800037a4:	f456                	sd	s5,40(sp)
    800037a6:	f05a                	sd	s6,32(sp)
    800037a8:	ec5e                	sd	s7,24(sp)
    800037aa:	e862                	sd	s8,16(sp)
    800037ac:	e466                	sd	s9,8(sp)
    800037ae:	8baa                	mv	s7,a0
    800037b0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800037b2:	0001eb17          	auipc	s6,0x1e
    800037b6:	6c6b0b13          	addi	s6,s6,1734 # 80021e78 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037ba:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800037bc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037be:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800037c0:	6c89                	lui	s9,0x2
    800037c2:	a061                	j	8000384a <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800037c4:	97ca                	add	a5,a5,s2
    800037c6:	8e55                	or	a2,a2,a3
    800037c8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800037cc:	854a                	mv	a0,s2
    800037ce:	00001097          	auipc	ra,0x1
    800037d2:	0d4080e7          	jalr	212(ra) # 800048a2 <log_write>
        brelse(bp);
    800037d6:	854a                	mv	a0,s2
    800037d8:	00000097          	auipc	ra,0x0
    800037dc:	e20080e7          	jalr	-480(ra) # 800035f8 <brelse>
  bp = bread(dev, bno);
    800037e0:	85a6                	mv	a1,s1
    800037e2:	855e                	mv	a0,s7
    800037e4:	00000097          	auipc	ra,0x0
    800037e8:	ce4080e7          	jalr	-796(ra) # 800034c8 <bread>
    800037ec:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800037ee:	40000613          	li	a2,1024
    800037f2:	4581                	li	a1,0
    800037f4:	05850513          	addi	a0,a0,88
    800037f8:	ffffd097          	auipc	ra,0xffffd
    800037fc:	53c080e7          	jalr	1340(ra) # 80000d34 <memset>
  log_write(bp);
    80003800:	854a                	mv	a0,s2
    80003802:	00001097          	auipc	ra,0x1
    80003806:	0a0080e7          	jalr	160(ra) # 800048a2 <log_write>
  brelse(bp);
    8000380a:	854a                	mv	a0,s2
    8000380c:	00000097          	auipc	ra,0x0
    80003810:	dec080e7          	jalr	-532(ra) # 800035f8 <brelse>
}
    80003814:	6906                	ld	s2,64(sp)
    80003816:	79e2                	ld	s3,56(sp)
    80003818:	7a42                	ld	s4,48(sp)
    8000381a:	7aa2                	ld	s5,40(sp)
    8000381c:	7b02                	ld	s6,32(sp)
    8000381e:	6be2                	ld	s7,24(sp)
    80003820:	6c42                	ld	s8,16(sp)
    80003822:	6ca2                	ld	s9,8(sp)
}
    80003824:	8526                	mv	a0,s1
    80003826:	60e6                	ld	ra,88(sp)
    80003828:	6446                	ld	s0,80(sp)
    8000382a:	64a6                	ld	s1,72(sp)
    8000382c:	6125                	addi	sp,sp,96
    8000382e:	8082                	ret
    brelse(bp);
    80003830:	854a                	mv	a0,s2
    80003832:	00000097          	auipc	ra,0x0
    80003836:	dc6080e7          	jalr	-570(ra) # 800035f8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000383a:	015c87bb          	addw	a5,s9,s5
    8000383e:	00078a9b          	sext.w	s5,a5
    80003842:	004b2703          	lw	a4,4(s6)
    80003846:	06eaf163          	bgeu	s5,a4,800038a8 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    8000384a:	41fad79b          	sraiw	a5,s5,0x1f
    8000384e:	0137d79b          	srliw	a5,a5,0x13
    80003852:	015787bb          	addw	a5,a5,s5
    80003856:	40d7d79b          	sraiw	a5,a5,0xd
    8000385a:	01cb2583          	lw	a1,28(s6)
    8000385e:	9dbd                	addw	a1,a1,a5
    80003860:	855e                	mv	a0,s7
    80003862:	00000097          	auipc	ra,0x0
    80003866:	c66080e7          	jalr	-922(ra) # 800034c8 <bread>
    8000386a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000386c:	004b2503          	lw	a0,4(s6)
    80003870:	000a849b          	sext.w	s1,s5
    80003874:	8762                	mv	a4,s8
    80003876:	faa4fde3          	bgeu	s1,a0,80003830 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000387a:	00777693          	andi	a3,a4,7
    8000387e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003882:	41f7579b          	sraiw	a5,a4,0x1f
    80003886:	01d7d79b          	srliw	a5,a5,0x1d
    8000388a:	9fb9                	addw	a5,a5,a4
    8000388c:	4037d79b          	sraiw	a5,a5,0x3
    80003890:	00f90633          	add	a2,s2,a5
    80003894:	05864603          	lbu	a2,88(a2)
    80003898:	00c6f5b3          	and	a1,a3,a2
    8000389c:	d585                	beqz	a1,800037c4 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000389e:	2705                	addiw	a4,a4,1
    800038a0:	2485                	addiw	s1,s1,1
    800038a2:	fd471ae3          	bne	a4,s4,80003876 <balloc+0xee>
    800038a6:	b769                	j	80003830 <balloc+0xa8>
    800038a8:	6906                	ld	s2,64(sp)
    800038aa:	79e2                	ld	s3,56(sp)
    800038ac:	7a42                	ld	s4,48(sp)
    800038ae:	7aa2                	ld	s5,40(sp)
    800038b0:	7b02                	ld	s6,32(sp)
    800038b2:	6be2                	ld	s7,24(sp)
    800038b4:	6c42                	ld	s8,16(sp)
    800038b6:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800038b8:	00005517          	auipc	a0,0x5
    800038bc:	c6850513          	addi	a0,a0,-920 # 80008520 <etext+0x520>
    800038c0:	ffffd097          	auipc	ra,0xffffd
    800038c4:	cea080e7          	jalr	-790(ra) # 800005aa <printf>
  return 0;
    800038c8:	4481                	li	s1,0
    800038ca:	bfa9                	j	80003824 <balloc+0x9c>

00000000800038cc <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800038cc:	7179                	addi	sp,sp,-48
    800038ce:	f406                	sd	ra,40(sp)
    800038d0:	f022                	sd	s0,32(sp)
    800038d2:	ec26                	sd	s1,24(sp)
    800038d4:	e84a                	sd	s2,16(sp)
    800038d6:	e44e                	sd	s3,8(sp)
    800038d8:	1800                	addi	s0,sp,48
    800038da:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800038dc:	47ad                	li	a5,11
    800038de:	02b7e863          	bltu	a5,a1,8000390e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800038e2:	02059793          	slli	a5,a1,0x20
    800038e6:	01e7d593          	srli	a1,a5,0x1e
    800038ea:	00b504b3          	add	s1,a0,a1
    800038ee:	0504a903          	lw	s2,80(s1)
    800038f2:	08091263          	bnez	s2,80003976 <bmap+0xaa>
      addr = balloc(ip->dev);
    800038f6:	4108                	lw	a0,0(a0)
    800038f8:	00000097          	auipc	ra,0x0
    800038fc:	e90080e7          	jalr	-368(ra) # 80003788 <balloc>
    80003900:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003904:	06090963          	beqz	s2,80003976 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003908:	0524a823          	sw	s2,80(s1)
    8000390c:	a0ad                	j	80003976 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000390e:	ff45849b          	addiw	s1,a1,-12
    80003912:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003916:	0ff00793          	li	a5,255
    8000391a:	08e7e863          	bltu	a5,a4,800039aa <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000391e:	08052903          	lw	s2,128(a0)
    80003922:	00091f63          	bnez	s2,80003940 <bmap+0x74>
      addr = balloc(ip->dev);
    80003926:	4108                	lw	a0,0(a0)
    80003928:	00000097          	auipc	ra,0x0
    8000392c:	e60080e7          	jalr	-416(ra) # 80003788 <balloc>
    80003930:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003934:	04090163          	beqz	s2,80003976 <bmap+0xaa>
    80003938:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000393a:	0929a023          	sw	s2,128(s3)
    8000393e:	a011                	j	80003942 <bmap+0x76>
    80003940:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003942:	85ca                	mv	a1,s2
    80003944:	0009a503          	lw	a0,0(s3)
    80003948:	00000097          	auipc	ra,0x0
    8000394c:	b80080e7          	jalr	-1152(ra) # 800034c8 <bread>
    80003950:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003952:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003956:	02049713          	slli	a4,s1,0x20
    8000395a:	01e75593          	srli	a1,a4,0x1e
    8000395e:	00b784b3          	add	s1,a5,a1
    80003962:	0004a903          	lw	s2,0(s1)
    80003966:	02090063          	beqz	s2,80003986 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000396a:	8552                	mv	a0,s4
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	c8c080e7          	jalr	-884(ra) # 800035f8 <brelse>
    return addr;
    80003974:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003976:	854a                	mv	a0,s2
    80003978:	70a2                	ld	ra,40(sp)
    8000397a:	7402                	ld	s0,32(sp)
    8000397c:	64e2                	ld	s1,24(sp)
    8000397e:	6942                	ld	s2,16(sp)
    80003980:	69a2                	ld	s3,8(sp)
    80003982:	6145                	addi	sp,sp,48
    80003984:	8082                	ret
      addr = balloc(ip->dev);
    80003986:	0009a503          	lw	a0,0(s3)
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	dfe080e7          	jalr	-514(ra) # 80003788 <balloc>
    80003992:	0005091b          	sext.w	s2,a0
      if(addr){
    80003996:	fc090ae3          	beqz	s2,8000396a <bmap+0x9e>
        a[bn] = addr;
    8000399a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000399e:	8552                	mv	a0,s4
    800039a0:	00001097          	auipc	ra,0x1
    800039a4:	f02080e7          	jalr	-254(ra) # 800048a2 <log_write>
    800039a8:	b7c9                	j	8000396a <bmap+0x9e>
    800039aa:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800039ac:	00005517          	auipc	a0,0x5
    800039b0:	b8c50513          	addi	a0,a0,-1140 # 80008538 <etext+0x538>
    800039b4:	ffffd097          	auipc	ra,0xffffd
    800039b8:	bac080e7          	jalr	-1108(ra) # 80000560 <panic>

00000000800039bc <iget>:
{
    800039bc:	7179                	addi	sp,sp,-48
    800039be:	f406                	sd	ra,40(sp)
    800039c0:	f022                	sd	s0,32(sp)
    800039c2:	ec26                	sd	s1,24(sp)
    800039c4:	e84a                	sd	s2,16(sp)
    800039c6:	e44e                	sd	s3,8(sp)
    800039c8:	e052                	sd	s4,0(sp)
    800039ca:	1800                	addi	s0,sp,48
    800039cc:	89aa                	mv	s3,a0
    800039ce:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800039d0:	0001e517          	auipc	a0,0x1e
    800039d4:	4c850513          	addi	a0,a0,1224 # 80021e98 <itable>
    800039d8:	ffffd097          	auipc	ra,0xffffd
    800039dc:	260080e7          	jalr	608(ra) # 80000c38 <acquire>
  empty = 0;
    800039e0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039e2:	0001e497          	auipc	s1,0x1e
    800039e6:	4ce48493          	addi	s1,s1,1230 # 80021eb0 <itable+0x18>
    800039ea:	00020697          	auipc	a3,0x20
    800039ee:	f5668693          	addi	a3,a3,-170 # 80023940 <log>
    800039f2:	a039                	j	80003a00 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039f4:	02090b63          	beqz	s2,80003a2a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039f8:	08848493          	addi	s1,s1,136
    800039fc:	02d48a63          	beq	s1,a3,80003a30 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003a00:	449c                	lw	a5,8(s1)
    80003a02:	fef059e3          	blez	a5,800039f4 <iget+0x38>
    80003a06:	4098                	lw	a4,0(s1)
    80003a08:	ff3716e3          	bne	a4,s3,800039f4 <iget+0x38>
    80003a0c:	40d8                	lw	a4,4(s1)
    80003a0e:	ff4713e3          	bne	a4,s4,800039f4 <iget+0x38>
      ip->ref++;
    80003a12:	2785                	addiw	a5,a5,1
    80003a14:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003a16:	0001e517          	auipc	a0,0x1e
    80003a1a:	48250513          	addi	a0,a0,1154 # 80021e98 <itable>
    80003a1e:	ffffd097          	auipc	ra,0xffffd
    80003a22:	2ce080e7          	jalr	718(ra) # 80000cec <release>
      return ip;
    80003a26:	8926                	mv	s2,s1
    80003a28:	a03d                	j	80003a56 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a2a:	f7f9                	bnez	a5,800039f8 <iget+0x3c>
      empty = ip;
    80003a2c:	8926                	mv	s2,s1
    80003a2e:	b7e9                	j	800039f8 <iget+0x3c>
  if(empty == 0)
    80003a30:	02090c63          	beqz	s2,80003a68 <iget+0xac>
  ip->dev = dev;
    80003a34:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003a38:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003a3c:	4785                	li	a5,1
    80003a3e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003a42:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003a46:	0001e517          	auipc	a0,0x1e
    80003a4a:	45250513          	addi	a0,a0,1106 # 80021e98 <itable>
    80003a4e:	ffffd097          	auipc	ra,0xffffd
    80003a52:	29e080e7          	jalr	670(ra) # 80000cec <release>
}
    80003a56:	854a                	mv	a0,s2
    80003a58:	70a2                	ld	ra,40(sp)
    80003a5a:	7402                	ld	s0,32(sp)
    80003a5c:	64e2                	ld	s1,24(sp)
    80003a5e:	6942                	ld	s2,16(sp)
    80003a60:	69a2                	ld	s3,8(sp)
    80003a62:	6a02                	ld	s4,0(sp)
    80003a64:	6145                	addi	sp,sp,48
    80003a66:	8082                	ret
    panic("iget: no inodes");
    80003a68:	00005517          	auipc	a0,0x5
    80003a6c:	ae850513          	addi	a0,a0,-1304 # 80008550 <etext+0x550>
    80003a70:	ffffd097          	auipc	ra,0xffffd
    80003a74:	af0080e7          	jalr	-1296(ra) # 80000560 <panic>

0000000080003a78 <fsinit>:
fsinit(int dev) {
    80003a78:	7179                	addi	sp,sp,-48
    80003a7a:	f406                	sd	ra,40(sp)
    80003a7c:	f022                	sd	s0,32(sp)
    80003a7e:	ec26                	sd	s1,24(sp)
    80003a80:	e84a                	sd	s2,16(sp)
    80003a82:	e44e                	sd	s3,8(sp)
    80003a84:	1800                	addi	s0,sp,48
    80003a86:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a88:	4585                	li	a1,1
    80003a8a:	00000097          	auipc	ra,0x0
    80003a8e:	a3e080e7          	jalr	-1474(ra) # 800034c8 <bread>
    80003a92:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a94:	0001e997          	auipc	s3,0x1e
    80003a98:	3e498993          	addi	s3,s3,996 # 80021e78 <sb>
    80003a9c:	02000613          	li	a2,32
    80003aa0:	05850593          	addi	a1,a0,88
    80003aa4:	854e                	mv	a0,s3
    80003aa6:	ffffd097          	auipc	ra,0xffffd
    80003aaa:	2ea080e7          	jalr	746(ra) # 80000d90 <memmove>
  brelse(bp);
    80003aae:	8526                	mv	a0,s1
    80003ab0:	00000097          	auipc	ra,0x0
    80003ab4:	b48080e7          	jalr	-1208(ra) # 800035f8 <brelse>
  if(sb.magic != FSMAGIC)
    80003ab8:	0009a703          	lw	a4,0(s3)
    80003abc:	102037b7          	lui	a5,0x10203
    80003ac0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003ac4:	02f71263          	bne	a4,a5,80003ae8 <fsinit+0x70>
  initlog(dev, &sb);
    80003ac8:	0001e597          	auipc	a1,0x1e
    80003acc:	3b058593          	addi	a1,a1,944 # 80021e78 <sb>
    80003ad0:	854a                	mv	a0,s2
    80003ad2:	00001097          	auipc	ra,0x1
    80003ad6:	b60080e7          	jalr	-1184(ra) # 80004632 <initlog>
}
    80003ada:	70a2                	ld	ra,40(sp)
    80003adc:	7402                	ld	s0,32(sp)
    80003ade:	64e2                	ld	s1,24(sp)
    80003ae0:	6942                	ld	s2,16(sp)
    80003ae2:	69a2                	ld	s3,8(sp)
    80003ae4:	6145                	addi	sp,sp,48
    80003ae6:	8082                	ret
    panic("invalid file system");
    80003ae8:	00005517          	auipc	a0,0x5
    80003aec:	a7850513          	addi	a0,a0,-1416 # 80008560 <etext+0x560>
    80003af0:	ffffd097          	auipc	ra,0xffffd
    80003af4:	a70080e7          	jalr	-1424(ra) # 80000560 <panic>

0000000080003af8 <iinit>:
{
    80003af8:	7179                	addi	sp,sp,-48
    80003afa:	f406                	sd	ra,40(sp)
    80003afc:	f022                	sd	s0,32(sp)
    80003afe:	ec26                	sd	s1,24(sp)
    80003b00:	e84a                	sd	s2,16(sp)
    80003b02:	e44e                	sd	s3,8(sp)
    80003b04:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003b06:	00005597          	auipc	a1,0x5
    80003b0a:	a7258593          	addi	a1,a1,-1422 # 80008578 <etext+0x578>
    80003b0e:	0001e517          	auipc	a0,0x1e
    80003b12:	38a50513          	addi	a0,a0,906 # 80021e98 <itable>
    80003b16:	ffffd097          	auipc	ra,0xffffd
    80003b1a:	092080e7          	jalr	146(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003b1e:	0001e497          	auipc	s1,0x1e
    80003b22:	3a248493          	addi	s1,s1,930 # 80021ec0 <itable+0x28>
    80003b26:	00020997          	auipc	s3,0x20
    80003b2a:	e2a98993          	addi	s3,s3,-470 # 80023950 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003b2e:	00005917          	auipc	s2,0x5
    80003b32:	a5290913          	addi	s2,s2,-1454 # 80008580 <etext+0x580>
    80003b36:	85ca                	mv	a1,s2
    80003b38:	8526                	mv	a0,s1
    80003b3a:	00001097          	auipc	ra,0x1
    80003b3e:	e4c080e7          	jalr	-436(ra) # 80004986 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b42:	08848493          	addi	s1,s1,136
    80003b46:	ff3498e3          	bne	s1,s3,80003b36 <iinit+0x3e>
}
    80003b4a:	70a2                	ld	ra,40(sp)
    80003b4c:	7402                	ld	s0,32(sp)
    80003b4e:	64e2                	ld	s1,24(sp)
    80003b50:	6942                	ld	s2,16(sp)
    80003b52:	69a2                	ld	s3,8(sp)
    80003b54:	6145                	addi	sp,sp,48
    80003b56:	8082                	ret

0000000080003b58 <ialloc>:
{
    80003b58:	7139                	addi	sp,sp,-64
    80003b5a:	fc06                	sd	ra,56(sp)
    80003b5c:	f822                	sd	s0,48(sp)
    80003b5e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b60:	0001e717          	auipc	a4,0x1e
    80003b64:	32472703          	lw	a4,804(a4) # 80021e84 <sb+0xc>
    80003b68:	4785                	li	a5,1
    80003b6a:	06e7f463          	bgeu	a5,a4,80003bd2 <ialloc+0x7a>
    80003b6e:	f426                	sd	s1,40(sp)
    80003b70:	f04a                	sd	s2,32(sp)
    80003b72:	ec4e                	sd	s3,24(sp)
    80003b74:	e852                	sd	s4,16(sp)
    80003b76:	e456                	sd	s5,8(sp)
    80003b78:	e05a                	sd	s6,0(sp)
    80003b7a:	8aaa                	mv	s5,a0
    80003b7c:	8b2e                	mv	s6,a1
    80003b7e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003b80:	0001ea17          	auipc	s4,0x1e
    80003b84:	2f8a0a13          	addi	s4,s4,760 # 80021e78 <sb>
    80003b88:	00495593          	srli	a1,s2,0x4
    80003b8c:	018a2783          	lw	a5,24(s4)
    80003b90:	9dbd                	addw	a1,a1,a5
    80003b92:	8556                	mv	a0,s5
    80003b94:	00000097          	auipc	ra,0x0
    80003b98:	934080e7          	jalr	-1740(ra) # 800034c8 <bread>
    80003b9c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b9e:	05850993          	addi	s3,a0,88
    80003ba2:	00f97793          	andi	a5,s2,15
    80003ba6:	079a                	slli	a5,a5,0x6
    80003ba8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003baa:	00099783          	lh	a5,0(s3)
    80003bae:	cf9d                	beqz	a5,80003bec <ialloc+0x94>
    brelse(bp);
    80003bb0:	00000097          	auipc	ra,0x0
    80003bb4:	a48080e7          	jalr	-1464(ra) # 800035f8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003bb8:	0905                	addi	s2,s2,1
    80003bba:	00ca2703          	lw	a4,12(s4)
    80003bbe:	0009079b          	sext.w	a5,s2
    80003bc2:	fce7e3e3          	bltu	a5,a4,80003b88 <ialloc+0x30>
    80003bc6:	74a2                	ld	s1,40(sp)
    80003bc8:	7902                	ld	s2,32(sp)
    80003bca:	69e2                	ld	s3,24(sp)
    80003bcc:	6a42                	ld	s4,16(sp)
    80003bce:	6aa2                	ld	s5,8(sp)
    80003bd0:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003bd2:	00005517          	auipc	a0,0x5
    80003bd6:	9b650513          	addi	a0,a0,-1610 # 80008588 <etext+0x588>
    80003bda:	ffffd097          	auipc	ra,0xffffd
    80003bde:	9d0080e7          	jalr	-1584(ra) # 800005aa <printf>
  return 0;
    80003be2:	4501                	li	a0,0
}
    80003be4:	70e2                	ld	ra,56(sp)
    80003be6:	7442                	ld	s0,48(sp)
    80003be8:	6121                	addi	sp,sp,64
    80003bea:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003bec:	04000613          	li	a2,64
    80003bf0:	4581                	li	a1,0
    80003bf2:	854e                	mv	a0,s3
    80003bf4:	ffffd097          	auipc	ra,0xffffd
    80003bf8:	140080e7          	jalr	320(ra) # 80000d34 <memset>
      dip->type = type;
    80003bfc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c00:	8526                	mv	a0,s1
    80003c02:	00001097          	auipc	ra,0x1
    80003c06:	ca0080e7          	jalr	-864(ra) # 800048a2 <log_write>
      brelse(bp);
    80003c0a:	8526                	mv	a0,s1
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	9ec080e7          	jalr	-1556(ra) # 800035f8 <brelse>
      return iget(dev, inum);
    80003c14:	0009059b          	sext.w	a1,s2
    80003c18:	8556                	mv	a0,s5
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	da2080e7          	jalr	-606(ra) # 800039bc <iget>
    80003c22:	74a2                	ld	s1,40(sp)
    80003c24:	7902                	ld	s2,32(sp)
    80003c26:	69e2                	ld	s3,24(sp)
    80003c28:	6a42                	ld	s4,16(sp)
    80003c2a:	6aa2                	ld	s5,8(sp)
    80003c2c:	6b02                	ld	s6,0(sp)
    80003c2e:	bf5d                	j	80003be4 <ialloc+0x8c>

0000000080003c30 <iupdate>:
{
    80003c30:	1101                	addi	sp,sp,-32
    80003c32:	ec06                	sd	ra,24(sp)
    80003c34:	e822                	sd	s0,16(sp)
    80003c36:	e426                	sd	s1,8(sp)
    80003c38:	e04a                	sd	s2,0(sp)
    80003c3a:	1000                	addi	s0,sp,32
    80003c3c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c3e:	415c                	lw	a5,4(a0)
    80003c40:	0047d79b          	srliw	a5,a5,0x4
    80003c44:	0001e597          	auipc	a1,0x1e
    80003c48:	24c5a583          	lw	a1,588(a1) # 80021e90 <sb+0x18>
    80003c4c:	9dbd                	addw	a1,a1,a5
    80003c4e:	4108                	lw	a0,0(a0)
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	878080e7          	jalr	-1928(ra) # 800034c8 <bread>
    80003c58:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c5a:	05850793          	addi	a5,a0,88
    80003c5e:	40d8                	lw	a4,4(s1)
    80003c60:	8b3d                	andi	a4,a4,15
    80003c62:	071a                	slli	a4,a4,0x6
    80003c64:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003c66:	04449703          	lh	a4,68(s1)
    80003c6a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003c6e:	04649703          	lh	a4,70(s1)
    80003c72:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003c76:	04849703          	lh	a4,72(s1)
    80003c7a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003c7e:	04a49703          	lh	a4,74(s1)
    80003c82:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003c86:	44f8                	lw	a4,76(s1)
    80003c88:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c8a:	03400613          	li	a2,52
    80003c8e:	05048593          	addi	a1,s1,80
    80003c92:	00c78513          	addi	a0,a5,12
    80003c96:	ffffd097          	auipc	ra,0xffffd
    80003c9a:	0fa080e7          	jalr	250(ra) # 80000d90 <memmove>
  log_write(bp);
    80003c9e:	854a                	mv	a0,s2
    80003ca0:	00001097          	auipc	ra,0x1
    80003ca4:	c02080e7          	jalr	-1022(ra) # 800048a2 <log_write>
  brelse(bp);
    80003ca8:	854a                	mv	a0,s2
    80003caa:	00000097          	auipc	ra,0x0
    80003cae:	94e080e7          	jalr	-1714(ra) # 800035f8 <brelse>
}
    80003cb2:	60e2                	ld	ra,24(sp)
    80003cb4:	6442                	ld	s0,16(sp)
    80003cb6:	64a2                	ld	s1,8(sp)
    80003cb8:	6902                	ld	s2,0(sp)
    80003cba:	6105                	addi	sp,sp,32
    80003cbc:	8082                	ret

0000000080003cbe <idup>:
{
    80003cbe:	1101                	addi	sp,sp,-32
    80003cc0:	ec06                	sd	ra,24(sp)
    80003cc2:	e822                	sd	s0,16(sp)
    80003cc4:	e426                	sd	s1,8(sp)
    80003cc6:	1000                	addi	s0,sp,32
    80003cc8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003cca:	0001e517          	auipc	a0,0x1e
    80003cce:	1ce50513          	addi	a0,a0,462 # 80021e98 <itable>
    80003cd2:	ffffd097          	auipc	ra,0xffffd
    80003cd6:	f66080e7          	jalr	-154(ra) # 80000c38 <acquire>
  ip->ref++;
    80003cda:	449c                	lw	a5,8(s1)
    80003cdc:	2785                	addiw	a5,a5,1
    80003cde:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ce0:	0001e517          	auipc	a0,0x1e
    80003ce4:	1b850513          	addi	a0,a0,440 # 80021e98 <itable>
    80003ce8:	ffffd097          	auipc	ra,0xffffd
    80003cec:	004080e7          	jalr	4(ra) # 80000cec <release>
}
    80003cf0:	8526                	mv	a0,s1
    80003cf2:	60e2                	ld	ra,24(sp)
    80003cf4:	6442                	ld	s0,16(sp)
    80003cf6:	64a2                	ld	s1,8(sp)
    80003cf8:	6105                	addi	sp,sp,32
    80003cfa:	8082                	ret

0000000080003cfc <ilock>:
{
    80003cfc:	1101                	addi	sp,sp,-32
    80003cfe:	ec06                	sd	ra,24(sp)
    80003d00:	e822                	sd	s0,16(sp)
    80003d02:	e426                	sd	s1,8(sp)
    80003d04:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003d06:	c10d                	beqz	a0,80003d28 <ilock+0x2c>
    80003d08:	84aa                	mv	s1,a0
    80003d0a:	451c                	lw	a5,8(a0)
    80003d0c:	00f05e63          	blez	a5,80003d28 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003d10:	0541                	addi	a0,a0,16
    80003d12:	00001097          	auipc	ra,0x1
    80003d16:	cae080e7          	jalr	-850(ra) # 800049c0 <acquiresleep>
  if(ip->valid == 0){
    80003d1a:	40bc                	lw	a5,64(s1)
    80003d1c:	cf99                	beqz	a5,80003d3a <ilock+0x3e>
}
    80003d1e:	60e2                	ld	ra,24(sp)
    80003d20:	6442                	ld	s0,16(sp)
    80003d22:	64a2                	ld	s1,8(sp)
    80003d24:	6105                	addi	sp,sp,32
    80003d26:	8082                	ret
    80003d28:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003d2a:	00005517          	auipc	a0,0x5
    80003d2e:	87650513          	addi	a0,a0,-1930 # 800085a0 <etext+0x5a0>
    80003d32:	ffffd097          	auipc	ra,0xffffd
    80003d36:	82e080e7          	jalr	-2002(ra) # 80000560 <panic>
    80003d3a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d3c:	40dc                	lw	a5,4(s1)
    80003d3e:	0047d79b          	srliw	a5,a5,0x4
    80003d42:	0001e597          	auipc	a1,0x1e
    80003d46:	14e5a583          	lw	a1,334(a1) # 80021e90 <sb+0x18>
    80003d4a:	9dbd                	addw	a1,a1,a5
    80003d4c:	4088                	lw	a0,0(s1)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	77a080e7          	jalr	1914(ra) # 800034c8 <bread>
    80003d56:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d58:	05850593          	addi	a1,a0,88
    80003d5c:	40dc                	lw	a5,4(s1)
    80003d5e:	8bbd                	andi	a5,a5,15
    80003d60:	079a                	slli	a5,a5,0x6
    80003d62:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003d64:	00059783          	lh	a5,0(a1)
    80003d68:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003d6c:	00259783          	lh	a5,2(a1)
    80003d70:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d74:	00459783          	lh	a5,4(a1)
    80003d78:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d7c:	00659783          	lh	a5,6(a1)
    80003d80:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d84:	459c                	lw	a5,8(a1)
    80003d86:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d88:	03400613          	li	a2,52
    80003d8c:	05b1                	addi	a1,a1,12
    80003d8e:	05048513          	addi	a0,s1,80
    80003d92:	ffffd097          	auipc	ra,0xffffd
    80003d96:	ffe080e7          	jalr	-2(ra) # 80000d90 <memmove>
    brelse(bp);
    80003d9a:	854a                	mv	a0,s2
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	85c080e7          	jalr	-1956(ra) # 800035f8 <brelse>
    ip->valid = 1;
    80003da4:	4785                	li	a5,1
    80003da6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003da8:	04449783          	lh	a5,68(s1)
    80003dac:	c399                	beqz	a5,80003db2 <ilock+0xb6>
    80003dae:	6902                	ld	s2,0(sp)
    80003db0:	b7bd                	j	80003d1e <ilock+0x22>
      panic("ilock: no type");
    80003db2:	00004517          	auipc	a0,0x4
    80003db6:	7f650513          	addi	a0,a0,2038 # 800085a8 <etext+0x5a8>
    80003dba:	ffffc097          	auipc	ra,0xffffc
    80003dbe:	7a6080e7          	jalr	1958(ra) # 80000560 <panic>

0000000080003dc2 <iunlock>:
{
    80003dc2:	1101                	addi	sp,sp,-32
    80003dc4:	ec06                	sd	ra,24(sp)
    80003dc6:	e822                	sd	s0,16(sp)
    80003dc8:	e426                	sd	s1,8(sp)
    80003dca:	e04a                	sd	s2,0(sp)
    80003dcc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003dce:	c905                	beqz	a0,80003dfe <iunlock+0x3c>
    80003dd0:	84aa                	mv	s1,a0
    80003dd2:	01050913          	addi	s2,a0,16
    80003dd6:	854a                	mv	a0,s2
    80003dd8:	00001097          	auipc	ra,0x1
    80003ddc:	c82080e7          	jalr	-894(ra) # 80004a5a <holdingsleep>
    80003de0:	cd19                	beqz	a0,80003dfe <iunlock+0x3c>
    80003de2:	449c                	lw	a5,8(s1)
    80003de4:	00f05d63          	blez	a5,80003dfe <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003de8:	854a                	mv	a0,s2
    80003dea:	00001097          	auipc	ra,0x1
    80003dee:	c2c080e7          	jalr	-980(ra) # 80004a16 <releasesleep>
}
    80003df2:	60e2                	ld	ra,24(sp)
    80003df4:	6442                	ld	s0,16(sp)
    80003df6:	64a2                	ld	s1,8(sp)
    80003df8:	6902                	ld	s2,0(sp)
    80003dfa:	6105                	addi	sp,sp,32
    80003dfc:	8082                	ret
    panic("iunlock");
    80003dfe:	00004517          	auipc	a0,0x4
    80003e02:	7ba50513          	addi	a0,a0,1978 # 800085b8 <etext+0x5b8>
    80003e06:	ffffc097          	auipc	ra,0xffffc
    80003e0a:	75a080e7          	jalr	1882(ra) # 80000560 <panic>

0000000080003e0e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003e0e:	7179                	addi	sp,sp,-48
    80003e10:	f406                	sd	ra,40(sp)
    80003e12:	f022                	sd	s0,32(sp)
    80003e14:	ec26                	sd	s1,24(sp)
    80003e16:	e84a                	sd	s2,16(sp)
    80003e18:	e44e                	sd	s3,8(sp)
    80003e1a:	1800                	addi	s0,sp,48
    80003e1c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e1e:	05050493          	addi	s1,a0,80
    80003e22:	08050913          	addi	s2,a0,128
    80003e26:	a021                	j	80003e2e <itrunc+0x20>
    80003e28:	0491                	addi	s1,s1,4
    80003e2a:	01248d63          	beq	s1,s2,80003e44 <itrunc+0x36>
    if(ip->addrs[i]){
    80003e2e:	408c                	lw	a1,0(s1)
    80003e30:	dde5                	beqz	a1,80003e28 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003e32:	0009a503          	lw	a0,0(s3)
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	8d6080e7          	jalr	-1834(ra) # 8000370c <bfree>
      ip->addrs[i] = 0;
    80003e3e:	0004a023          	sw	zero,0(s1)
    80003e42:	b7dd                	j	80003e28 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e44:	0809a583          	lw	a1,128(s3)
    80003e48:	ed99                	bnez	a1,80003e66 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e4a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e4e:	854e                	mv	a0,s3
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	de0080e7          	jalr	-544(ra) # 80003c30 <iupdate>
}
    80003e58:	70a2                	ld	ra,40(sp)
    80003e5a:	7402                	ld	s0,32(sp)
    80003e5c:	64e2                	ld	s1,24(sp)
    80003e5e:	6942                	ld	s2,16(sp)
    80003e60:	69a2                	ld	s3,8(sp)
    80003e62:	6145                	addi	sp,sp,48
    80003e64:	8082                	ret
    80003e66:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e68:	0009a503          	lw	a0,0(s3)
    80003e6c:	fffff097          	auipc	ra,0xfffff
    80003e70:	65c080e7          	jalr	1628(ra) # 800034c8 <bread>
    80003e74:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e76:	05850493          	addi	s1,a0,88
    80003e7a:	45850913          	addi	s2,a0,1112
    80003e7e:	a021                	j	80003e86 <itrunc+0x78>
    80003e80:	0491                	addi	s1,s1,4
    80003e82:	01248b63          	beq	s1,s2,80003e98 <itrunc+0x8a>
      if(a[j])
    80003e86:	408c                	lw	a1,0(s1)
    80003e88:	dde5                	beqz	a1,80003e80 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003e8a:	0009a503          	lw	a0,0(s3)
    80003e8e:	00000097          	auipc	ra,0x0
    80003e92:	87e080e7          	jalr	-1922(ra) # 8000370c <bfree>
    80003e96:	b7ed                	j	80003e80 <itrunc+0x72>
    brelse(bp);
    80003e98:	8552                	mv	a0,s4
    80003e9a:	fffff097          	auipc	ra,0xfffff
    80003e9e:	75e080e7          	jalr	1886(ra) # 800035f8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003ea2:	0809a583          	lw	a1,128(s3)
    80003ea6:	0009a503          	lw	a0,0(s3)
    80003eaa:	00000097          	auipc	ra,0x0
    80003eae:	862080e7          	jalr	-1950(ra) # 8000370c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003eb2:	0809a023          	sw	zero,128(s3)
    80003eb6:	6a02                	ld	s4,0(sp)
    80003eb8:	bf49                	j	80003e4a <itrunc+0x3c>

0000000080003eba <iput>:
{
    80003eba:	1101                	addi	sp,sp,-32
    80003ebc:	ec06                	sd	ra,24(sp)
    80003ebe:	e822                	sd	s0,16(sp)
    80003ec0:	e426                	sd	s1,8(sp)
    80003ec2:	1000                	addi	s0,sp,32
    80003ec4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003ec6:	0001e517          	auipc	a0,0x1e
    80003eca:	fd250513          	addi	a0,a0,-46 # 80021e98 <itable>
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	d6a080e7          	jalr	-662(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ed6:	4498                	lw	a4,8(s1)
    80003ed8:	4785                	li	a5,1
    80003eda:	02f70263          	beq	a4,a5,80003efe <iput+0x44>
  ip->ref--;
    80003ede:	449c                	lw	a5,8(s1)
    80003ee0:	37fd                	addiw	a5,a5,-1
    80003ee2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ee4:	0001e517          	auipc	a0,0x1e
    80003ee8:	fb450513          	addi	a0,a0,-76 # 80021e98 <itable>
    80003eec:	ffffd097          	auipc	ra,0xffffd
    80003ef0:	e00080e7          	jalr	-512(ra) # 80000cec <release>
}
    80003ef4:	60e2                	ld	ra,24(sp)
    80003ef6:	6442                	ld	s0,16(sp)
    80003ef8:	64a2                	ld	s1,8(sp)
    80003efa:	6105                	addi	sp,sp,32
    80003efc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003efe:	40bc                	lw	a5,64(s1)
    80003f00:	dff9                	beqz	a5,80003ede <iput+0x24>
    80003f02:	04a49783          	lh	a5,74(s1)
    80003f06:	ffe1                	bnez	a5,80003ede <iput+0x24>
    80003f08:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003f0a:	01048913          	addi	s2,s1,16
    80003f0e:	854a                	mv	a0,s2
    80003f10:	00001097          	auipc	ra,0x1
    80003f14:	ab0080e7          	jalr	-1360(ra) # 800049c0 <acquiresleep>
    release(&itable.lock);
    80003f18:	0001e517          	auipc	a0,0x1e
    80003f1c:	f8050513          	addi	a0,a0,-128 # 80021e98 <itable>
    80003f20:	ffffd097          	auipc	ra,0xffffd
    80003f24:	dcc080e7          	jalr	-564(ra) # 80000cec <release>
    itrunc(ip);
    80003f28:	8526                	mv	a0,s1
    80003f2a:	00000097          	auipc	ra,0x0
    80003f2e:	ee4080e7          	jalr	-284(ra) # 80003e0e <itrunc>
    ip->type = 0;
    80003f32:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f36:	8526                	mv	a0,s1
    80003f38:	00000097          	auipc	ra,0x0
    80003f3c:	cf8080e7          	jalr	-776(ra) # 80003c30 <iupdate>
    ip->valid = 0;
    80003f40:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f44:	854a                	mv	a0,s2
    80003f46:	00001097          	auipc	ra,0x1
    80003f4a:	ad0080e7          	jalr	-1328(ra) # 80004a16 <releasesleep>
    acquire(&itable.lock);
    80003f4e:	0001e517          	auipc	a0,0x1e
    80003f52:	f4a50513          	addi	a0,a0,-182 # 80021e98 <itable>
    80003f56:	ffffd097          	auipc	ra,0xffffd
    80003f5a:	ce2080e7          	jalr	-798(ra) # 80000c38 <acquire>
    80003f5e:	6902                	ld	s2,0(sp)
    80003f60:	bfbd                	j	80003ede <iput+0x24>

0000000080003f62 <iunlockput>:
{
    80003f62:	1101                	addi	sp,sp,-32
    80003f64:	ec06                	sd	ra,24(sp)
    80003f66:	e822                	sd	s0,16(sp)
    80003f68:	e426                	sd	s1,8(sp)
    80003f6a:	1000                	addi	s0,sp,32
    80003f6c:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f6e:	00000097          	auipc	ra,0x0
    80003f72:	e54080e7          	jalr	-428(ra) # 80003dc2 <iunlock>
  iput(ip);
    80003f76:	8526                	mv	a0,s1
    80003f78:	00000097          	auipc	ra,0x0
    80003f7c:	f42080e7          	jalr	-190(ra) # 80003eba <iput>
}
    80003f80:	60e2                	ld	ra,24(sp)
    80003f82:	6442                	ld	s0,16(sp)
    80003f84:	64a2                	ld	s1,8(sp)
    80003f86:	6105                	addi	sp,sp,32
    80003f88:	8082                	ret

0000000080003f8a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f8a:	1141                	addi	sp,sp,-16
    80003f8c:	e422                	sd	s0,8(sp)
    80003f8e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f90:	411c                	lw	a5,0(a0)
    80003f92:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f94:	415c                	lw	a5,4(a0)
    80003f96:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f98:	04451783          	lh	a5,68(a0)
    80003f9c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003fa0:	04a51783          	lh	a5,74(a0)
    80003fa4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003fa8:	04c56783          	lwu	a5,76(a0)
    80003fac:	e99c                	sd	a5,16(a1)
}
    80003fae:	6422                	ld	s0,8(sp)
    80003fb0:	0141                	addi	sp,sp,16
    80003fb2:	8082                	ret

0000000080003fb4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fb4:	457c                	lw	a5,76(a0)
    80003fb6:	10d7e563          	bltu	a5,a3,800040c0 <readi+0x10c>
{
    80003fba:	7159                	addi	sp,sp,-112
    80003fbc:	f486                	sd	ra,104(sp)
    80003fbe:	f0a2                	sd	s0,96(sp)
    80003fc0:	eca6                	sd	s1,88(sp)
    80003fc2:	e0d2                	sd	s4,64(sp)
    80003fc4:	fc56                	sd	s5,56(sp)
    80003fc6:	f85a                	sd	s6,48(sp)
    80003fc8:	f45e                	sd	s7,40(sp)
    80003fca:	1880                	addi	s0,sp,112
    80003fcc:	8b2a                	mv	s6,a0
    80003fce:	8bae                	mv	s7,a1
    80003fd0:	8a32                	mv	s4,a2
    80003fd2:	84b6                	mv	s1,a3
    80003fd4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003fd6:	9f35                	addw	a4,a4,a3
    return 0;
    80003fd8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003fda:	0cd76a63          	bltu	a4,a3,800040ae <readi+0xfa>
    80003fde:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003fe0:	00e7f463          	bgeu	a5,a4,80003fe8 <readi+0x34>
    n = ip->size - off;
    80003fe4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fe8:	0a0a8963          	beqz	s5,8000409a <readi+0xe6>
    80003fec:	e8ca                	sd	s2,80(sp)
    80003fee:	f062                	sd	s8,32(sp)
    80003ff0:	ec66                	sd	s9,24(sp)
    80003ff2:	e86a                	sd	s10,16(sp)
    80003ff4:	e46e                	sd	s11,8(sp)
    80003ff6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ff8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ffc:	5c7d                	li	s8,-1
    80003ffe:	a82d                	j	80004038 <readi+0x84>
    80004000:	020d1d93          	slli	s11,s10,0x20
    80004004:	020ddd93          	srli	s11,s11,0x20
    80004008:	05890613          	addi	a2,s2,88
    8000400c:	86ee                	mv	a3,s11
    8000400e:	963a                	add	a2,a2,a4
    80004010:	85d2                	mv	a1,s4
    80004012:	855e                	mv	a0,s7
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	8dc080e7          	jalr	-1828(ra) # 800028f0 <either_copyout>
    8000401c:	05850d63          	beq	a0,s8,80004076 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004020:	854a                	mv	a0,s2
    80004022:	fffff097          	auipc	ra,0xfffff
    80004026:	5d6080e7          	jalr	1494(ra) # 800035f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000402a:	013d09bb          	addw	s3,s10,s3
    8000402e:	009d04bb          	addw	s1,s10,s1
    80004032:	9a6e                	add	s4,s4,s11
    80004034:	0559fd63          	bgeu	s3,s5,8000408e <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80004038:	00a4d59b          	srliw	a1,s1,0xa
    8000403c:	855a                	mv	a0,s6
    8000403e:	00000097          	auipc	ra,0x0
    80004042:	88e080e7          	jalr	-1906(ra) # 800038cc <bmap>
    80004046:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000404a:	c9b1                	beqz	a1,8000409e <readi+0xea>
    bp = bread(ip->dev, addr);
    8000404c:	000b2503          	lw	a0,0(s6)
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	478080e7          	jalr	1144(ra) # 800034c8 <bread>
    80004058:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000405a:	3ff4f713          	andi	a4,s1,1023
    8000405e:	40ec87bb          	subw	a5,s9,a4
    80004062:	413a86bb          	subw	a3,s5,s3
    80004066:	8d3e                	mv	s10,a5
    80004068:	2781                	sext.w	a5,a5
    8000406a:	0006861b          	sext.w	a2,a3
    8000406e:	f8f679e3          	bgeu	a2,a5,80004000 <readi+0x4c>
    80004072:	8d36                	mv	s10,a3
    80004074:	b771                	j	80004000 <readi+0x4c>
      brelse(bp);
    80004076:	854a                	mv	a0,s2
    80004078:	fffff097          	auipc	ra,0xfffff
    8000407c:	580080e7          	jalr	1408(ra) # 800035f8 <brelse>
      tot = -1;
    80004080:	59fd                	li	s3,-1
      break;
    80004082:	6946                	ld	s2,80(sp)
    80004084:	7c02                	ld	s8,32(sp)
    80004086:	6ce2                	ld	s9,24(sp)
    80004088:	6d42                	ld	s10,16(sp)
    8000408a:	6da2                	ld	s11,8(sp)
    8000408c:	a831                	j	800040a8 <readi+0xf4>
    8000408e:	6946                	ld	s2,80(sp)
    80004090:	7c02                	ld	s8,32(sp)
    80004092:	6ce2                	ld	s9,24(sp)
    80004094:	6d42                	ld	s10,16(sp)
    80004096:	6da2                	ld	s11,8(sp)
    80004098:	a801                	j	800040a8 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000409a:	89d6                	mv	s3,s5
    8000409c:	a031                	j	800040a8 <readi+0xf4>
    8000409e:	6946                	ld	s2,80(sp)
    800040a0:	7c02                	ld	s8,32(sp)
    800040a2:	6ce2                	ld	s9,24(sp)
    800040a4:	6d42                	ld	s10,16(sp)
    800040a6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800040a8:	0009851b          	sext.w	a0,s3
    800040ac:	69a6                	ld	s3,72(sp)
}
    800040ae:	70a6                	ld	ra,104(sp)
    800040b0:	7406                	ld	s0,96(sp)
    800040b2:	64e6                	ld	s1,88(sp)
    800040b4:	6a06                	ld	s4,64(sp)
    800040b6:	7ae2                	ld	s5,56(sp)
    800040b8:	7b42                	ld	s6,48(sp)
    800040ba:	7ba2                	ld	s7,40(sp)
    800040bc:	6165                	addi	sp,sp,112
    800040be:	8082                	ret
    return 0;
    800040c0:	4501                	li	a0,0
}
    800040c2:	8082                	ret

00000000800040c4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040c4:	457c                	lw	a5,76(a0)
    800040c6:	10d7ee63          	bltu	a5,a3,800041e2 <writei+0x11e>
{
    800040ca:	7159                	addi	sp,sp,-112
    800040cc:	f486                	sd	ra,104(sp)
    800040ce:	f0a2                	sd	s0,96(sp)
    800040d0:	e8ca                	sd	s2,80(sp)
    800040d2:	e0d2                	sd	s4,64(sp)
    800040d4:	fc56                	sd	s5,56(sp)
    800040d6:	f85a                	sd	s6,48(sp)
    800040d8:	f45e                	sd	s7,40(sp)
    800040da:	1880                	addi	s0,sp,112
    800040dc:	8aaa                	mv	s5,a0
    800040de:	8bae                	mv	s7,a1
    800040e0:	8a32                	mv	s4,a2
    800040e2:	8936                	mv	s2,a3
    800040e4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800040e6:	00e687bb          	addw	a5,a3,a4
    800040ea:	0ed7ee63          	bltu	a5,a3,800041e6 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800040ee:	00043737          	lui	a4,0x43
    800040f2:	0ef76c63          	bltu	a4,a5,800041ea <writei+0x126>
    800040f6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040f8:	0c0b0d63          	beqz	s6,800041d2 <writei+0x10e>
    800040fc:	eca6                	sd	s1,88(sp)
    800040fe:	f062                	sd	s8,32(sp)
    80004100:	ec66                	sd	s9,24(sp)
    80004102:	e86a                	sd	s10,16(sp)
    80004104:	e46e                	sd	s11,8(sp)
    80004106:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004108:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000410c:	5c7d                	li	s8,-1
    8000410e:	a091                	j	80004152 <writei+0x8e>
    80004110:	020d1d93          	slli	s11,s10,0x20
    80004114:	020ddd93          	srli	s11,s11,0x20
    80004118:	05848513          	addi	a0,s1,88
    8000411c:	86ee                	mv	a3,s11
    8000411e:	8652                	mv	a2,s4
    80004120:	85de                	mv	a1,s7
    80004122:	953a                	add	a0,a0,a4
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	822080e7          	jalr	-2014(ra) # 80002946 <either_copyin>
    8000412c:	07850263          	beq	a0,s8,80004190 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004130:	8526                	mv	a0,s1
    80004132:	00000097          	auipc	ra,0x0
    80004136:	770080e7          	jalr	1904(ra) # 800048a2 <log_write>
    brelse(bp);
    8000413a:	8526                	mv	a0,s1
    8000413c:	fffff097          	auipc	ra,0xfffff
    80004140:	4bc080e7          	jalr	1212(ra) # 800035f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004144:	013d09bb          	addw	s3,s10,s3
    80004148:	012d093b          	addw	s2,s10,s2
    8000414c:	9a6e                	add	s4,s4,s11
    8000414e:	0569f663          	bgeu	s3,s6,8000419a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004152:	00a9559b          	srliw	a1,s2,0xa
    80004156:	8556                	mv	a0,s5
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	774080e7          	jalr	1908(ra) # 800038cc <bmap>
    80004160:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004164:	c99d                	beqz	a1,8000419a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004166:	000aa503          	lw	a0,0(s5)
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	35e080e7          	jalr	862(ra) # 800034c8 <bread>
    80004172:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004174:	3ff97713          	andi	a4,s2,1023
    80004178:	40ec87bb          	subw	a5,s9,a4
    8000417c:	413b06bb          	subw	a3,s6,s3
    80004180:	8d3e                	mv	s10,a5
    80004182:	2781                	sext.w	a5,a5
    80004184:	0006861b          	sext.w	a2,a3
    80004188:	f8f674e3          	bgeu	a2,a5,80004110 <writei+0x4c>
    8000418c:	8d36                	mv	s10,a3
    8000418e:	b749                	j	80004110 <writei+0x4c>
      brelse(bp);
    80004190:	8526                	mv	a0,s1
    80004192:	fffff097          	auipc	ra,0xfffff
    80004196:	466080e7          	jalr	1126(ra) # 800035f8 <brelse>
  }

  if(off > ip->size)
    8000419a:	04caa783          	lw	a5,76(s5)
    8000419e:	0327fc63          	bgeu	a5,s2,800041d6 <writei+0x112>
    ip->size = off;
    800041a2:	052aa623          	sw	s2,76(s5)
    800041a6:	64e6                	ld	s1,88(sp)
    800041a8:	7c02                	ld	s8,32(sp)
    800041aa:	6ce2                	ld	s9,24(sp)
    800041ac:	6d42                	ld	s10,16(sp)
    800041ae:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800041b0:	8556                	mv	a0,s5
    800041b2:	00000097          	auipc	ra,0x0
    800041b6:	a7e080e7          	jalr	-1410(ra) # 80003c30 <iupdate>

  return tot;
    800041ba:	0009851b          	sext.w	a0,s3
    800041be:	69a6                	ld	s3,72(sp)
}
    800041c0:	70a6                	ld	ra,104(sp)
    800041c2:	7406                	ld	s0,96(sp)
    800041c4:	6946                	ld	s2,80(sp)
    800041c6:	6a06                	ld	s4,64(sp)
    800041c8:	7ae2                	ld	s5,56(sp)
    800041ca:	7b42                	ld	s6,48(sp)
    800041cc:	7ba2                	ld	s7,40(sp)
    800041ce:	6165                	addi	sp,sp,112
    800041d0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041d2:	89da                	mv	s3,s6
    800041d4:	bff1                	j	800041b0 <writei+0xec>
    800041d6:	64e6                	ld	s1,88(sp)
    800041d8:	7c02                	ld	s8,32(sp)
    800041da:	6ce2                	ld	s9,24(sp)
    800041dc:	6d42                	ld	s10,16(sp)
    800041de:	6da2                	ld	s11,8(sp)
    800041e0:	bfc1                	j	800041b0 <writei+0xec>
    return -1;
    800041e2:	557d                	li	a0,-1
}
    800041e4:	8082                	ret
    return -1;
    800041e6:	557d                	li	a0,-1
    800041e8:	bfe1                	j	800041c0 <writei+0xfc>
    return -1;
    800041ea:	557d                	li	a0,-1
    800041ec:	bfd1                	j	800041c0 <writei+0xfc>

00000000800041ee <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800041ee:	1141                	addi	sp,sp,-16
    800041f0:	e406                	sd	ra,8(sp)
    800041f2:	e022                	sd	s0,0(sp)
    800041f4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800041f6:	4639                	li	a2,14
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	c0c080e7          	jalr	-1012(ra) # 80000e04 <strncmp>
}
    80004200:	60a2                	ld	ra,8(sp)
    80004202:	6402                	ld	s0,0(sp)
    80004204:	0141                	addi	sp,sp,16
    80004206:	8082                	ret

0000000080004208 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004208:	7139                	addi	sp,sp,-64
    8000420a:	fc06                	sd	ra,56(sp)
    8000420c:	f822                	sd	s0,48(sp)
    8000420e:	f426                	sd	s1,40(sp)
    80004210:	f04a                	sd	s2,32(sp)
    80004212:	ec4e                	sd	s3,24(sp)
    80004214:	e852                	sd	s4,16(sp)
    80004216:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004218:	04451703          	lh	a4,68(a0)
    8000421c:	4785                	li	a5,1
    8000421e:	00f71a63          	bne	a4,a5,80004232 <dirlookup+0x2a>
    80004222:	892a                	mv	s2,a0
    80004224:	89ae                	mv	s3,a1
    80004226:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004228:	457c                	lw	a5,76(a0)
    8000422a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000422c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000422e:	e79d                	bnez	a5,8000425c <dirlookup+0x54>
    80004230:	a8a5                	j	800042a8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004232:	00004517          	auipc	a0,0x4
    80004236:	38e50513          	addi	a0,a0,910 # 800085c0 <etext+0x5c0>
    8000423a:	ffffc097          	auipc	ra,0xffffc
    8000423e:	326080e7          	jalr	806(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004242:	00004517          	auipc	a0,0x4
    80004246:	39650513          	addi	a0,a0,918 # 800085d8 <etext+0x5d8>
    8000424a:	ffffc097          	auipc	ra,0xffffc
    8000424e:	316080e7          	jalr	790(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004252:	24c1                	addiw	s1,s1,16
    80004254:	04c92783          	lw	a5,76(s2)
    80004258:	04f4f763          	bgeu	s1,a5,800042a6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000425c:	4741                	li	a4,16
    8000425e:	86a6                	mv	a3,s1
    80004260:	fc040613          	addi	a2,s0,-64
    80004264:	4581                	li	a1,0
    80004266:	854a                	mv	a0,s2
    80004268:	00000097          	auipc	ra,0x0
    8000426c:	d4c080e7          	jalr	-692(ra) # 80003fb4 <readi>
    80004270:	47c1                	li	a5,16
    80004272:	fcf518e3          	bne	a0,a5,80004242 <dirlookup+0x3a>
    if(de.inum == 0)
    80004276:	fc045783          	lhu	a5,-64(s0)
    8000427a:	dfe1                	beqz	a5,80004252 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000427c:	fc240593          	addi	a1,s0,-62
    80004280:	854e                	mv	a0,s3
    80004282:	00000097          	auipc	ra,0x0
    80004286:	f6c080e7          	jalr	-148(ra) # 800041ee <namecmp>
    8000428a:	f561                	bnez	a0,80004252 <dirlookup+0x4a>
      if(poff)
    8000428c:	000a0463          	beqz	s4,80004294 <dirlookup+0x8c>
        *poff = off;
    80004290:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004294:	fc045583          	lhu	a1,-64(s0)
    80004298:	00092503          	lw	a0,0(s2)
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	720080e7          	jalr	1824(ra) # 800039bc <iget>
    800042a4:	a011                	j	800042a8 <dirlookup+0xa0>
  return 0;
    800042a6:	4501                	li	a0,0
}
    800042a8:	70e2                	ld	ra,56(sp)
    800042aa:	7442                	ld	s0,48(sp)
    800042ac:	74a2                	ld	s1,40(sp)
    800042ae:	7902                	ld	s2,32(sp)
    800042b0:	69e2                	ld	s3,24(sp)
    800042b2:	6a42                	ld	s4,16(sp)
    800042b4:	6121                	addi	sp,sp,64
    800042b6:	8082                	ret

00000000800042b8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800042b8:	711d                	addi	sp,sp,-96
    800042ba:	ec86                	sd	ra,88(sp)
    800042bc:	e8a2                	sd	s0,80(sp)
    800042be:	e4a6                	sd	s1,72(sp)
    800042c0:	e0ca                	sd	s2,64(sp)
    800042c2:	fc4e                	sd	s3,56(sp)
    800042c4:	f852                	sd	s4,48(sp)
    800042c6:	f456                	sd	s5,40(sp)
    800042c8:	f05a                	sd	s6,32(sp)
    800042ca:	ec5e                	sd	s7,24(sp)
    800042cc:	e862                	sd	s8,16(sp)
    800042ce:	e466                	sd	s9,8(sp)
    800042d0:	1080                	addi	s0,sp,96
    800042d2:	84aa                	mv	s1,a0
    800042d4:	8b2e                	mv	s6,a1
    800042d6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800042d8:	00054703          	lbu	a4,0(a0)
    800042dc:	02f00793          	li	a5,47
    800042e0:	02f70263          	beq	a4,a5,80004304 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800042e4:	ffffe097          	auipc	ra,0xffffe
    800042e8:	a20080e7          	jalr	-1504(ra) # 80001d04 <myproc>
    800042ec:	15853503          	ld	a0,344(a0)
    800042f0:	00000097          	auipc	ra,0x0
    800042f4:	9ce080e7          	jalr	-1586(ra) # 80003cbe <idup>
    800042f8:	8a2a                	mv	s4,a0
  while(*path == '/')
    800042fa:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800042fe:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004300:	4b85                	li	s7,1
    80004302:	a875                	j	800043be <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80004304:	4585                	li	a1,1
    80004306:	4505                	li	a0,1
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	6b4080e7          	jalr	1716(ra) # 800039bc <iget>
    80004310:	8a2a                	mv	s4,a0
    80004312:	b7e5                	j	800042fa <namex+0x42>
      iunlockput(ip);
    80004314:	8552                	mv	a0,s4
    80004316:	00000097          	auipc	ra,0x0
    8000431a:	c4c080e7          	jalr	-948(ra) # 80003f62 <iunlockput>
      return 0;
    8000431e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004320:	8552                	mv	a0,s4
    80004322:	60e6                	ld	ra,88(sp)
    80004324:	6446                	ld	s0,80(sp)
    80004326:	64a6                	ld	s1,72(sp)
    80004328:	6906                	ld	s2,64(sp)
    8000432a:	79e2                	ld	s3,56(sp)
    8000432c:	7a42                	ld	s4,48(sp)
    8000432e:	7aa2                	ld	s5,40(sp)
    80004330:	7b02                	ld	s6,32(sp)
    80004332:	6be2                	ld	s7,24(sp)
    80004334:	6c42                	ld	s8,16(sp)
    80004336:	6ca2                	ld	s9,8(sp)
    80004338:	6125                	addi	sp,sp,96
    8000433a:	8082                	ret
      iunlock(ip);
    8000433c:	8552                	mv	a0,s4
    8000433e:	00000097          	auipc	ra,0x0
    80004342:	a84080e7          	jalr	-1404(ra) # 80003dc2 <iunlock>
      return ip;
    80004346:	bfe9                	j	80004320 <namex+0x68>
      iunlockput(ip);
    80004348:	8552                	mv	a0,s4
    8000434a:	00000097          	auipc	ra,0x0
    8000434e:	c18080e7          	jalr	-1000(ra) # 80003f62 <iunlockput>
      return 0;
    80004352:	8a4e                	mv	s4,s3
    80004354:	b7f1                	j	80004320 <namex+0x68>
  len = path - s;
    80004356:	40998633          	sub	a2,s3,s1
    8000435a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000435e:	099c5863          	bge	s8,s9,800043ee <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004362:	4639                	li	a2,14
    80004364:	85a6                	mv	a1,s1
    80004366:	8556                	mv	a0,s5
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	a28080e7          	jalr	-1496(ra) # 80000d90 <memmove>
    80004370:	84ce                	mv	s1,s3
  while(*path == '/')
    80004372:	0004c783          	lbu	a5,0(s1)
    80004376:	01279763          	bne	a5,s2,80004384 <namex+0xcc>
    path++;
    8000437a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000437c:	0004c783          	lbu	a5,0(s1)
    80004380:	ff278de3          	beq	a5,s2,8000437a <namex+0xc2>
    ilock(ip);
    80004384:	8552                	mv	a0,s4
    80004386:	00000097          	auipc	ra,0x0
    8000438a:	976080e7          	jalr	-1674(ra) # 80003cfc <ilock>
    if(ip->type != T_DIR){
    8000438e:	044a1783          	lh	a5,68(s4)
    80004392:	f97791e3          	bne	a5,s7,80004314 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80004396:	000b0563          	beqz	s6,800043a0 <namex+0xe8>
    8000439a:	0004c783          	lbu	a5,0(s1)
    8000439e:	dfd9                	beqz	a5,8000433c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800043a0:	4601                	li	a2,0
    800043a2:	85d6                	mv	a1,s5
    800043a4:	8552                	mv	a0,s4
    800043a6:	00000097          	auipc	ra,0x0
    800043aa:	e62080e7          	jalr	-414(ra) # 80004208 <dirlookup>
    800043ae:	89aa                	mv	s3,a0
    800043b0:	dd41                	beqz	a0,80004348 <namex+0x90>
    iunlockput(ip);
    800043b2:	8552                	mv	a0,s4
    800043b4:	00000097          	auipc	ra,0x0
    800043b8:	bae080e7          	jalr	-1106(ra) # 80003f62 <iunlockput>
    ip = next;
    800043bc:	8a4e                	mv	s4,s3
  while(*path == '/')
    800043be:	0004c783          	lbu	a5,0(s1)
    800043c2:	01279763          	bne	a5,s2,800043d0 <namex+0x118>
    path++;
    800043c6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043c8:	0004c783          	lbu	a5,0(s1)
    800043cc:	ff278de3          	beq	a5,s2,800043c6 <namex+0x10e>
  if(*path == 0)
    800043d0:	cb9d                	beqz	a5,80004406 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800043d2:	0004c783          	lbu	a5,0(s1)
    800043d6:	89a6                	mv	s3,s1
  len = path - s;
    800043d8:	4c81                	li	s9,0
    800043da:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800043dc:	01278963          	beq	a5,s2,800043ee <namex+0x136>
    800043e0:	dbbd                	beqz	a5,80004356 <namex+0x9e>
    path++;
    800043e2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800043e4:	0009c783          	lbu	a5,0(s3)
    800043e8:	ff279ce3          	bne	a5,s2,800043e0 <namex+0x128>
    800043ec:	b7ad                	j	80004356 <namex+0x9e>
    memmove(name, s, len);
    800043ee:	2601                	sext.w	a2,a2
    800043f0:	85a6                	mv	a1,s1
    800043f2:	8556                	mv	a0,s5
    800043f4:	ffffd097          	auipc	ra,0xffffd
    800043f8:	99c080e7          	jalr	-1636(ra) # 80000d90 <memmove>
    name[len] = 0;
    800043fc:	9cd6                	add	s9,s9,s5
    800043fe:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004402:	84ce                	mv	s1,s3
    80004404:	b7bd                	j	80004372 <namex+0xba>
  if(nameiparent){
    80004406:	f00b0de3          	beqz	s6,80004320 <namex+0x68>
    iput(ip);
    8000440a:	8552                	mv	a0,s4
    8000440c:	00000097          	auipc	ra,0x0
    80004410:	aae080e7          	jalr	-1362(ra) # 80003eba <iput>
    return 0;
    80004414:	4a01                	li	s4,0
    80004416:	b729                	j	80004320 <namex+0x68>

0000000080004418 <dirlink>:
{
    80004418:	7139                	addi	sp,sp,-64
    8000441a:	fc06                	sd	ra,56(sp)
    8000441c:	f822                	sd	s0,48(sp)
    8000441e:	f04a                	sd	s2,32(sp)
    80004420:	ec4e                	sd	s3,24(sp)
    80004422:	e852                	sd	s4,16(sp)
    80004424:	0080                	addi	s0,sp,64
    80004426:	892a                	mv	s2,a0
    80004428:	8a2e                	mv	s4,a1
    8000442a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000442c:	4601                	li	a2,0
    8000442e:	00000097          	auipc	ra,0x0
    80004432:	dda080e7          	jalr	-550(ra) # 80004208 <dirlookup>
    80004436:	ed25                	bnez	a0,800044ae <dirlink+0x96>
    80004438:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000443a:	04c92483          	lw	s1,76(s2)
    8000443e:	c49d                	beqz	s1,8000446c <dirlink+0x54>
    80004440:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004442:	4741                	li	a4,16
    80004444:	86a6                	mv	a3,s1
    80004446:	fc040613          	addi	a2,s0,-64
    8000444a:	4581                	li	a1,0
    8000444c:	854a                	mv	a0,s2
    8000444e:	00000097          	auipc	ra,0x0
    80004452:	b66080e7          	jalr	-1178(ra) # 80003fb4 <readi>
    80004456:	47c1                	li	a5,16
    80004458:	06f51163          	bne	a0,a5,800044ba <dirlink+0xa2>
    if(de.inum == 0)
    8000445c:	fc045783          	lhu	a5,-64(s0)
    80004460:	c791                	beqz	a5,8000446c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004462:	24c1                	addiw	s1,s1,16
    80004464:	04c92783          	lw	a5,76(s2)
    80004468:	fcf4ede3          	bltu	s1,a5,80004442 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000446c:	4639                	li	a2,14
    8000446e:	85d2                	mv	a1,s4
    80004470:	fc240513          	addi	a0,s0,-62
    80004474:	ffffd097          	auipc	ra,0xffffd
    80004478:	9c6080e7          	jalr	-1594(ra) # 80000e3a <strncpy>
  de.inum = inum;
    8000447c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004480:	4741                	li	a4,16
    80004482:	86a6                	mv	a3,s1
    80004484:	fc040613          	addi	a2,s0,-64
    80004488:	4581                	li	a1,0
    8000448a:	854a                	mv	a0,s2
    8000448c:	00000097          	auipc	ra,0x0
    80004490:	c38080e7          	jalr	-968(ra) # 800040c4 <writei>
    80004494:	1541                	addi	a0,a0,-16
    80004496:	00a03533          	snez	a0,a0
    8000449a:	40a00533          	neg	a0,a0
    8000449e:	74a2                	ld	s1,40(sp)
}
    800044a0:	70e2                	ld	ra,56(sp)
    800044a2:	7442                	ld	s0,48(sp)
    800044a4:	7902                	ld	s2,32(sp)
    800044a6:	69e2                	ld	s3,24(sp)
    800044a8:	6a42                	ld	s4,16(sp)
    800044aa:	6121                	addi	sp,sp,64
    800044ac:	8082                	ret
    iput(ip);
    800044ae:	00000097          	auipc	ra,0x0
    800044b2:	a0c080e7          	jalr	-1524(ra) # 80003eba <iput>
    return -1;
    800044b6:	557d                	li	a0,-1
    800044b8:	b7e5                	j	800044a0 <dirlink+0x88>
      panic("dirlink read");
    800044ba:	00004517          	auipc	a0,0x4
    800044be:	12e50513          	addi	a0,a0,302 # 800085e8 <etext+0x5e8>
    800044c2:	ffffc097          	auipc	ra,0xffffc
    800044c6:	09e080e7          	jalr	158(ra) # 80000560 <panic>

00000000800044ca <namei>:

struct inode*
namei(char *path)
{
    800044ca:	1101                	addi	sp,sp,-32
    800044cc:	ec06                	sd	ra,24(sp)
    800044ce:	e822                	sd	s0,16(sp)
    800044d0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800044d2:	fe040613          	addi	a2,s0,-32
    800044d6:	4581                	li	a1,0
    800044d8:	00000097          	auipc	ra,0x0
    800044dc:	de0080e7          	jalr	-544(ra) # 800042b8 <namex>
}
    800044e0:	60e2                	ld	ra,24(sp)
    800044e2:	6442                	ld	s0,16(sp)
    800044e4:	6105                	addi	sp,sp,32
    800044e6:	8082                	ret

00000000800044e8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800044e8:	1141                	addi	sp,sp,-16
    800044ea:	e406                	sd	ra,8(sp)
    800044ec:	e022                	sd	s0,0(sp)
    800044ee:	0800                	addi	s0,sp,16
    800044f0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800044f2:	4585                	li	a1,1
    800044f4:	00000097          	auipc	ra,0x0
    800044f8:	dc4080e7          	jalr	-572(ra) # 800042b8 <namex>
}
    800044fc:	60a2                	ld	ra,8(sp)
    800044fe:	6402                	ld	s0,0(sp)
    80004500:	0141                	addi	sp,sp,16
    80004502:	8082                	ret

0000000080004504 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004504:	1101                	addi	sp,sp,-32
    80004506:	ec06                	sd	ra,24(sp)
    80004508:	e822                	sd	s0,16(sp)
    8000450a:	e426                	sd	s1,8(sp)
    8000450c:	e04a                	sd	s2,0(sp)
    8000450e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004510:	0001f917          	auipc	s2,0x1f
    80004514:	43090913          	addi	s2,s2,1072 # 80023940 <log>
    80004518:	01892583          	lw	a1,24(s2)
    8000451c:	02892503          	lw	a0,40(s2)
    80004520:	fffff097          	auipc	ra,0xfffff
    80004524:	fa8080e7          	jalr	-88(ra) # 800034c8 <bread>
    80004528:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000452a:	02c92603          	lw	a2,44(s2)
    8000452e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004530:	00c05f63          	blez	a2,8000454e <write_head+0x4a>
    80004534:	0001f717          	auipc	a4,0x1f
    80004538:	43c70713          	addi	a4,a4,1084 # 80023970 <log+0x30>
    8000453c:	87aa                	mv	a5,a0
    8000453e:	060a                	slli	a2,a2,0x2
    80004540:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004542:	4314                	lw	a3,0(a4)
    80004544:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004546:	0711                	addi	a4,a4,4
    80004548:	0791                	addi	a5,a5,4
    8000454a:	fec79ce3          	bne	a5,a2,80004542 <write_head+0x3e>
  }
  bwrite(buf);
    8000454e:	8526                	mv	a0,s1
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	06a080e7          	jalr	106(ra) # 800035ba <bwrite>
  brelse(buf);
    80004558:	8526                	mv	a0,s1
    8000455a:	fffff097          	auipc	ra,0xfffff
    8000455e:	09e080e7          	jalr	158(ra) # 800035f8 <brelse>
}
    80004562:	60e2                	ld	ra,24(sp)
    80004564:	6442                	ld	s0,16(sp)
    80004566:	64a2                	ld	s1,8(sp)
    80004568:	6902                	ld	s2,0(sp)
    8000456a:	6105                	addi	sp,sp,32
    8000456c:	8082                	ret

000000008000456e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000456e:	0001f797          	auipc	a5,0x1f
    80004572:	3fe7a783          	lw	a5,1022(a5) # 8002396c <log+0x2c>
    80004576:	0af05d63          	blez	a5,80004630 <install_trans+0xc2>
{
    8000457a:	7139                	addi	sp,sp,-64
    8000457c:	fc06                	sd	ra,56(sp)
    8000457e:	f822                	sd	s0,48(sp)
    80004580:	f426                	sd	s1,40(sp)
    80004582:	f04a                	sd	s2,32(sp)
    80004584:	ec4e                	sd	s3,24(sp)
    80004586:	e852                	sd	s4,16(sp)
    80004588:	e456                	sd	s5,8(sp)
    8000458a:	e05a                	sd	s6,0(sp)
    8000458c:	0080                	addi	s0,sp,64
    8000458e:	8b2a                	mv	s6,a0
    80004590:	0001fa97          	auipc	s5,0x1f
    80004594:	3e0a8a93          	addi	s5,s5,992 # 80023970 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004598:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000459a:	0001f997          	auipc	s3,0x1f
    8000459e:	3a698993          	addi	s3,s3,934 # 80023940 <log>
    800045a2:	a00d                	j	800045c4 <install_trans+0x56>
    brelse(lbuf);
    800045a4:	854a                	mv	a0,s2
    800045a6:	fffff097          	auipc	ra,0xfffff
    800045aa:	052080e7          	jalr	82(ra) # 800035f8 <brelse>
    brelse(dbuf);
    800045ae:	8526                	mv	a0,s1
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	048080e7          	jalr	72(ra) # 800035f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045b8:	2a05                	addiw	s4,s4,1
    800045ba:	0a91                	addi	s5,s5,4
    800045bc:	02c9a783          	lw	a5,44(s3)
    800045c0:	04fa5e63          	bge	s4,a5,8000461c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045c4:	0189a583          	lw	a1,24(s3)
    800045c8:	014585bb          	addw	a1,a1,s4
    800045cc:	2585                	addiw	a1,a1,1
    800045ce:	0289a503          	lw	a0,40(s3)
    800045d2:	fffff097          	auipc	ra,0xfffff
    800045d6:	ef6080e7          	jalr	-266(ra) # 800034c8 <bread>
    800045da:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800045dc:	000aa583          	lw	a1,0(s5)
    800045e0:	0289a503          	lw	a0,40(s3)
    800045e4:	fffff097          	auipc	ra,0xfffff
    800045e8:	ee4080e7          	jalr	-284(ra) # 800034c8 <bread>
    800045ec:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800045ee:	40000613          	li	a2,1024
    800045f2:	05890593          	addi	a1,s2,88
    800045f6:	05850513          	addi	a0,a0,88
    800045fa:	ffffc097          	auipc	ra,0xffffc
    800045fe:	796080e7          	jalr	1942(ra) # 80000d90 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004602:	8526                	mv	a0,s1
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	fb6080e7          	jalr	-74(ra) # 800035ba <bwrite>
    if(recovering == 0)
    8000460c:	f80b1ce3          	bnez	s6,800045a4 <install_trans+0x36>
      bunpin(dbuf);
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	0be080e7          	jalr	190(ra) # 800036d0 <bunpin>
    8000461a:	b769                	j	800045a4 <install_trans+0x36>
}
    8000461c:	70e2                	ld	ra,56(sp)
    8000461e:	7442                	ld	s0,48(sp)
    80004620:	74a2                	ld	s1,40(sp)
    80004622:	7902                	ld	s2,32(sp)
    80004624:	69e2                	ld	s3,24(sp)
    80004626:	6a42                	ld	s4,16(sp)
    80004628:	6aa2                	ld	s5,8(sp)
    8000462a:	6b02                	ld	s6,0(sp)
    8000462c:	6121                	addi	sp,sp,64
    8000462e:	8082                	ret
    80004630:	8082                	ret

0000000080004632 <initlog>:
{
    80004632:	7179                	addi	sp,sp,-48
    80004634:	f406                	sd	ra,40(sp)
    80004636:	f022                	sd	s0,32(sp)
    80004638:	ec26                	sd	s1,24(sp)
    8000463a:	e84a                	sd	s2,16(sp)
    8000463c:	e44e                	sd	s3,8(sp)
    8000463e:	1800                	addi	s0,sp,48
    80004640:	892a                	mv	s2,a0
    80004642:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004644:	0001f497          	auipc	s1,0x1f
    80004648:	2fc48493          	addi	s1,s1,764 # 80023940 <log>
    8000464c:	00004597          	auipc	a1,0x4
    80004650:	fac58593          	addi	a1,a1,-84 # 800085f8 <etext+0x5f8>
    80004654:	8526                	mv	a0,s1
    80004656:	ffffc097          	auipc	ra,0xffffc
    8000465a:	552080e7          	jalr	1362(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    8000465e:	0149a583          	lw	a1,20(s3)
    80004662:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004664:	0109a783          	lw	a5,16(s3)
    80004668:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000466a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000466e:	854a                	mv	a0,s2
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	e58080e7          	jalr	-424(ra) # 800034c8 <bread>
  log.lh.n = lh->n;
    80004678:	4d30                	lw	a2,88(a0)
    8000467a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000467c:	00c05f63          	blez	a2,8000469a <initlog+0x68>
    80004680:	87aa                	mv	a5,a0
    80004682:	0001f717          	auipc	a4,0x1f
    80004686:	2ee70713          	addi	a4,a4,750 # 80023970 <log+0x30>
    8000468a:	060a                	slli	a2,a2,0x2
    8000468c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000468e:	4ff4                	lw	a3,92(a5)
    80004690:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004692:	0791                	addi	a5,a5,4
    80004694:	0711                	addi	a4,a4,4
    80004696:	fec79ce3          	bne	a5,a2,8000468e <initlog+0x5c>
  brelse(buf);
    8000469a:	fffff097          	auipc	ra,0xfffff
    8000469e:	f5e080e7          	jalr	-162(ra) # 800035f8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800046a2:	4505                	li	a0,1
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	eca080e7          	jalr	-310(ra) # 8000456e <install_trans>
  log.lh.n = 0;
    800046ac:	0001f797          	auipc	a5,0x1f
    800046b0:	2c07a023          	sw	zero,704(a5) # 8002396c <log+0x2c>
  write_head(); // clear the log
    800046b4:	00000097          	auipc	ra,0x0
    800046b8:	e50080e7          	jalr	-432(ra) # 80004504 <write_head>
}
    800046bc:	70a2                	ld	ra,40(sp)
    800046be:	7402                	ld	s0,32(sp)
    800046c0:	64e2                	ld	s1,24(sp)
    800046c2:	6942                	ld	s2,16(sp)
    800046c4:	69a2                	ld	s3,8(sp)
    800046c6:	6145                	addi	sp,sp,48
    800046c8:	8082                	ret

00000000800046ca <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800046ca:	1101                	addi	sp,sp,-32
    800046cc:	ec06                	sd	ra,24(sp)
    800046ce:	e822                	sd	s0,16(sp)
    800046d0:	e426                	sd	s1,8(sp)
    800046d2:	e04a                	sd	s2,0(sp)
    800046d4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800046d6:	0001f517          	auipc	a0,0x1f
    800046da:	26a50513          	addi	a0,a0,618 # 80023940 <log>
    800046de:	ffffc097          	auipc	ra,0xffffc
    800046e2:	55a080e7          	jalr	1370(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    800046e6:	0001f497          	auipc	s1,0x1f
    800046ea:	25a48493          	addi	s1,s1,602 # 80023940 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046ee:	4979                	li	s2,30
    800046f0:	a039                	j	800046fe <begin_op+0x34>
      sleep(&log, &log.lock);
    800046f2:	85a6                	mv	a1,s1
    800046f4:	8526                	mv	a0,s1
    800046f6:	ffffe097          	auipc	ra,0xffffe
    800046fa:	df2080e7          	jalr	-526(ra) # 800024e8 <sleep>
    if(log.committing){
    800046fe:	50dc                	lw	a5,36(s1)
    80004700:	fbed                	bnez	a5,800046f2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004702:	5098                	lw	a4,32(s1)
    80004704:	2705                	addiw	a4,a4,1
    80004706:	0027179b          	slliw	a5,a4,0x2
    8000470a:	9fb9                	addw	a5,a5,a4
    8000470c:	0017979b          	slliw	a5,a5,0x1
    80004710:	54d4                	lw	a3,44(s1)
    80004712:	9fb5                	addw	a5,a5,a3
    80004714:	00f95963          	bge	s2,a5,80004726 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004718:	85a6                	mv	a1,s1
    8000471a:	8526                	mv	a0,s1
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	dcc080e7          	jalr	-564(ra) # 800024e8 <sleep>
    80004724:	bfe9                	j	800046fe <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004726:	0001f517          	auipc	a0,0x1f
    8000472a:	21a50513          	addi	a0,a0,538 # 80023940 <log>
    8000472e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	5bc080e7          	jalr	1468(ra) # 80000cec <release>
      break;
    }
  }
}
    80004738:	60e2                	ld	ra,24(sp)
    8000473a:	6442                	ld	s0,16(sp)
    8000473c:	64a2                	ld	s1,8(sp)
    8000473e:	6902                	ld	s2,0(sp)
    80004740:	6105                	addi	sp,sp,32
    80004742:	8082                	ret

0000000080004744 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004744:	7139                	addi	sp,sp,-64
    80004746:	fc06                	sd	ra,56(sp)
    80004748:	f822                	sd	s0,48(sp)
    8000474a:	f426                	sd	s1,40(sp)
    8000474c:	f04a                	sd	s2,32(sp)
    8000474e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004750:	0001f497          	auipc	s1,0x1f
    80004754:	1f048493          	addi	s1,s1,496 # 80023940 <log>
    80004758:	8526                	mv	a0,s1
    8000475a:	ffffc097          	auipc	ra,0xffffc
    8000475e:	4de080e7          	jalr	1246(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    80004762:	509c                	lw	a5,32(s1)
    80004764:	37fd                	addiw	a5,a5,-1
    80004766:	0007891b          	sext.w	s2,a5
    8000476a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000476c:	50dc                	lw	a5,36(s1)
    8000476e:	e7b9                	bnez	a5,800047bc <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004770:	06091163          	bnez	s2,800047d2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004774:	0001f497          	auipc	s1,0x1f
    80004778:	1cc48493          	addi	s1,s1,460 # 80023940 <log>
    8000477c:	4785                	li	a5,1
    8000477e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004780:	8526                	mv	a0,s1
    80004782:	ffffc097          	auipc	ra,0xffffc
    80004786:	56a080e7          	jalr	1386(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000478a:	54dc                	lw	a5,44(s1)
    8000478c:	06f04763          	bgtz	a5,800047fa <end_op+0xb6>
    acquire(&log.lock);
    80004790:	0001f497          	auipc	s1,0x1f
    80004794:	1b048493          	addi	s1,s1,432 # 80023940 <log>
    80004798:	8526                	mv	a0,s1
    8000479a:	ffffc097          	auipc	ra,0xffffc
    8000479e:	49e080e7          	jalr	1182(ra) # 80000c38 <acquire>
    log.committing = 0;
    800047a2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800047a6:	8526                	mv	a0,s1
    800047a8:	ffffe097          	auipc	ra,0xffffe
    800047ac:	da4080e7          	jalr	-604(ra) # 8000254c <wakeup>
    release(&log.lock);
    800047b0:	8526                	mv	a0,s1
    800047b2:	ffffc097          	auipc	ra,0xffffc
    800047b6:	53a080e7          	jalr	1338(ra) # 80000cec <release>
}
    800047ba:	a815                	j	800047ee <end_op+0xaa>
    800047bc:	ec4e                	sd	s3,24(sp)
    800047be:	e852                	sd	s4,16(sp)
    800047c0:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800047c2:	00004517          	auipc	a0,0x4
    800047c6:	e3e50513          	addi	a0,a0,-450 # 80008600 <etext+0x600>
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	d96080e7          	jalr	-618(ra) # 80000560 <panic>
    wakeup(&log);
    800047d2:	0001f497          	auipc	s1,0x1f
    800047d6:	16e48493          	addi	s1,s1,366 # 80023940 <log>
    800047da:	8526                	mv	a0,s1
    800047dc:	ffffe097          	auipc	ra,0xffffe
    800047e0:	d70080e7          	jalr	-656(ra) # 8000254c <wakeup>
  release(&log.lock);
    800047e4:	8526                	mv	a0,s1
    800047e6:	ffffc097          	auipc	ra,0xffffc
    800047ea:	506080e7          	jalr	1286(ra) # 80000cec <release>
}
    800047ee:	70e2                	ld	ra,56(sp)
    800047f0:	7442                	ld	s0,48(sp)
    800047f2:	74a2                	ld	s1,40(sp)
    800047f4:	7902                	ld	s2,32(sp)
    800047f6:	6121                	addi	sp,sp,64
    800047f8:	8082                	ret
    800047fa:	ec4e                	sd	s3,24(sp)
    800047fc:	e852                	sd	s4,16(sp)
    800047fe:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004800:	0001fa97          	auipc	s5,0x1f
    80004804:	170a8a93          	addi	s5,s5,368 # 80023970 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004808:	0001fa17          	auipc	s4,0x1f
    8000480c:	138a0a13          	addi	s4,s4,312 # 80023940 <log>
    80004810:	018a2583          	lw	a1,24(s4)
    80004814:	012585bb          	addw	a1,a1,s2
    80004818:	2585                	addiw	a1,a1,1
    8000481a:	028a2503          	lw	a0,40(s4)
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	caa080e7          	jalr	-854(ra) # 800034c8 <bread>
    80004826:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004828:	000aa583          	lw	a1,0(s5)
    8000482c:	028a2503          	lw	a0,40(s4)
    80004830:	fffff097          	auipc	ra,0xfffff
    80004834:	c98080e7          	jalr	-872(ra) # 800034c8 <bread>
    80004838:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000483a:	40000613          	li	a2,1024
    8000483e:	05850593          	addi	a1,a0,88
    80004842:	05848513          	addi	a0,s1,88
    80004846:	ffffc097          	auipc	ra,0xffffc
    8000484a:	54a080e7          	jalr	1354(ra) # 80000d90 <memmove>
    bwrite(to);  // write the log
    8000484e:	8526                	mv	a0,s1
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	d6a080e7          	jalr	-662(ra) # 800035ba <bwrite>
    brelse(from);
    80004858:	854e                	mv	a0,s3
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	d9e080e7          	jalr	-610(ra) # 800035f8 <brelse>
    brelse(to);
    80004862:	8526                	mv	a0,s1
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	d94080e7          	jalr	-620(ra) # 800035f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000486c:	2905                	addiw	s2,s2,1
    8000486e:	0a91                	addi	s5,s5,4
    80004870:	02ca2783          	lw	a5,44(s4)
    80004874:	f8f94ee3          	blt	s2,a5,80004810 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004878:	00000097          	auipc	ra,0x0
    8000487c:	c8c080e7          	jalr	-884(ra) # 80004504 <write_head>
    install_trans(0); // Now install writes to home locations
    80004880:	4501                	li	a0,0
    80004882:	00000097          	auipc	ra,0x0
    80004886:	cec080e7          	jalr	-788(ra) # 8000456e <install_trans>
    log.lh.n = 0;
    8000488a:	0001f797          	auipc	a5,0x1f
    8000488e:	0e07a123          	sw	zero,226(a5) # 8002396c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004892:	00000097          	auipc	ra,0x0
    80004896:	c72080e7          	jalr	-910(ra) # 80004504 <write_head>
    8000489a:	69e2                	ld	s3,24(sp)
    8000489c:	6a42                	ld	s4,16(sp)
    8000489e:	6aa2                	ld	s5,8(sp)
    800048a0:	bdc5                	j	80004790 <end_op+0x4c>

00000000800048a2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800048a2:	1101                	addi	sp,sp,-32
    800048a4:	ec06                	sd	ra,24(sp)
    800048a6:	e822                	sd	s0,16(sp)
    800048a8:	e426                	sd	s1,8(sp)
    800048aa:	e04a                	sd	s2,0(sp)
    800048ac:	1000                	addi	s0,sp,32
    800048ae:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800048b0:	0001f917          	auipc	s2,0x1f
    800048b4:	09090913          	addi	s2,s2,144 # 80023940 <log>
    800048b8:	854a                	mv	a0,s2
    800048ba:	ffffc097          	auipc	ra,0xffffc
    800048be:	37e080e7          	jalr	894(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800048c2:	02c92603          	lw	a2,44(s2)
    800048c6:	47f5                	li	a5,29
    800048c8:	06c7c563          	blt	a5,a2,80004932 <log_write+0x90>
    800048cc:	0001f797          	auipc	a5,0x1f
    800048d0:	0907a783          	lw	a5,144(a5) # 8002395c <log+0x1c>
    800048d4:	37fd                	addiw	a5,a5,-1
    800048d6:	04f65e63          	bge	a2,a5,80004932 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800048da:	0001f797          	auipc	a5,0x1f
    800048de:	0867a783          	lw	a5,134(a5) # 80023960 <log+0x20>
    800048e2:	06f05063          	blez	a5,80004942 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800048e6:	4781                	li	a5,0
    800048e8:	06c05563          	blez	a2,80004952 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048ec:	44cc                	lw	a1,12(s1)
    800048ee:	0001f717          	auipc	a4,0x1f
    800048f2:	08270713          	addi	a4,a4,130 # 80023970 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800048f6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048f8:	4314                	lw	a3,0(a4)
    800048fa:	04b68c63          	beq	a3,a1,80004952 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800048fe:	2785                	addiw	a5,a5,1
    80004900:	0711                	addi	a4,a4,4
    80004902:	fef61be3          	bne	a2,a5,800048f8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004906:	0621                	addi	a2,a2,8
    80004908:	060a                	slli	a2,a2,0x2
    8000490a:	0001f797          	auipc	a5,0x1f
    8000490e:	03678793          	addi	a5,a5,54 # 80023940 <log>
    80004912:	97b2                	add	a5,a5,a2
    80004914:	44d8                	lw	a4,12(s1)
    80004916:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004918:	8526                	mv	a0,s1
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	d7a080e7          	jalr	-646(ra) # 80003694 <bpin>
    log.lh.n++;
    80004922:	0001f717          	auipc	a4,0x1f
    80004926:	01e70713          	addi	a4,a4,30 # 80023940 <log>
    8000492a:	575c                	lw	a5,44(a4)
    8000492c:	2785                	addiw	a5,a5,1
    8000492e:	d75c                	sw	a5,44(a4)
    80004930:	a82d                	j	8000496a <log_write+0xc8>
    panic("too big a transaction");
    80004932:	00004517          	auipc	a0,0x4
    80004936:	cde50513          	addi	a0,a0,-802 # 80008610 <etext+0x610>
    8000493a:	ffffc097          	auipc	ra,0xffffc
    8000493e:	c26080e7          	jalr	-986(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004942:	00004517          	auipc	a0,0x4
    80004946:	ce650513          	addi	a0,a0,-794 # 80008628 <etext+0x628>
    8000494a:	ffffc097          	auipc	ra,0xffffc
    8000494e:	c16080e7          	jalr	-1002(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004952:	00878693          	addi	a3,a5,8
    80004956:	068a                	slli	a3,a3,0x2
    80004958:	0001f717          	auipc	a4,0x1f
    8000495c:	fe870713          	addi	a4,a4,-24 # 80023940 <log>
    80004960:	9736                	add	a4,a4,a3
    80004962:	44d4                	lw	a3,12(s1)
    80004964:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004966:	faf609e3          	beq	a2,a5,80004918 <log_write+0x76>
  }
  release(&log.lock);
    8000496a:	0001f517          	auipc	a0,0x1f
    8000496e:	fd650513          	addi	a0,a0,-42 # 80023940 <log>
    80004972:	ffffc097          	auipc	ra,0xffffc
    80004976:	37a080e7          	jalr	890(ra) # 80000cec <release>
}
    8000497a:	60e2                	ld	ra,24(sp)
    8000497c:	6442                	ld	s0,16(sp)
    8000497e:	64a2                	ld	s1,8(sp)
    80004980:	6902                	ld	s2,0(sp)
    80004982:	6105                	addi	sp,sp,32
    80004984:	8082                	ret

0000000080004986 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004986:	1101                	addi	sp,sp,-32
    80004988:	ec06                	sd	ra,24(sp)
    8000498a:	e822                	sd	s0,16(sp)
    8000498c:	e426                	sd	s1,8(sp)
    8000498e:	e04a                	sd	s2,0(sp)
    80004990:	1000                	addi	s0,sp,32
    80004992:	84aa                	mv	s1,a0
    80004994:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004996:	00004597          	auipc	a1,0x4
    8000499a:	cb258593          	addi	a1,a1,-846 # 80008648 <etext+0x648>
    8000499e:	0521                	addi	a0,a0,8
    800049a0:	ffffc097          	auipc	ra,0xffffc
    800049a4:	208080e7          	jalr	520(ra) # 80000ba8 <initlock>
  lk->name = name;
    800049a8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800049ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049b0:	0204a423          	sw	zero,40(s1)
}
    800049b4:	60e2                	ld	ra,24(sp)
    800049b6:	6442                	ld	s0,16(sp)
    800049b8:	64a2                	ld	s1,8(sp)
    800049ba:	6902                	ld	s2,0(sp)
    800049bc:	6105                	addi	sp,sp,32
    800049be:	8082                	ret

00000000800049c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800049c0:	1101                	addi	sp,sp,-32
    800049c2:	ec06                	sd	ra,24(sp)
    800049c4:	e822                	sd	s0,16(sp)
    800049c6:	e426                	sd	s1,8(sp)
    800049c8:	e04a                	sd	s2,0(sp)
    800049ca:	1000                	addi	s0,sp,32
    800049cc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049ce:	00850913          	addi	s2,a0,8
    800049d2:	854a                	mv	a0,s2
    800049d4:	ffffc097          	auipc	ra,0xffffc
    800049d8:	264080e7          	jalr	612(ra) # 80000c38 <acquire>
  while (lk->locked) {
    800049dc:	409c                	lw	a5,0(s1)
    800049de:	cb89                	beqz	a5,800049f0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800049e0:	85ca                	mv	a1,s2
    800049e2:	8526                	mv	a0,s1
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	b04080e7          	jalr	-1276(ra) # 800024e8 <sleep>
  while (lk->locked) {
    800049ec:	409c                	lw	a5,0(s1)
    800049ee:	fbed                	bnez	a5,800049e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800049f0:	4785                	li	a5,1
    800049f2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049f4:	ffffd097          	auipc	ra,0xffffd
    800049f8:	310080e7          	jalr	784(ra) # 80001d04 <myproc>
    800049fc:	591c                	lw	a5,48(a0)
    800049fe:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004a00:	854a                	mv	a0,s2
    80004a02:	ffffc097          	auipc	ra,0xffffc
    80004a06:	2ea080e7          	jalr	746(ra) # 80000cec <release>
}
    80004a0a:	60e2                	ld	ra,24(sp)
    80004a0c:	6442                	ld	s0,16(sp)
    80004a0e:	64a2                	ld	s1,8(sp)
    80004a10:	6902                	ld	s2,0(sp)
    80004a12:	6105                	addi	sp,sp,32
    80004a14:	8082                	ret

0000000080004a16 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a16:	1101                	addi	sp,sp,-32
    80004a18:	ec06                	sd	ra,24(sp)
    80004a1a:	e822                	sd	s0,16(sp)
    80004a1c:	e426                	sd	s1,8(sp)
    80004a1e:	e04a                	sd	s2,0(sp)
    80004a20:	1000                	addi	s0,sp,32
    80004a22:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a24:	00850913          	addi	s2,a0,8
    80004a28:	854a                	mv	a0,s2
    80004a2a:	ffffc097          	auipc	ra,0xffffc
    80004a2e:	20e080e7          	jalr	526(ra) # 80000c38 <acquire>
  lk->locked = 0;
    80004a32:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a36:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	b10080e7          	jalr	-1264(ra) # 8000254c <wakeup>
  release(&lk->lk);
    80004a44:	854a                	mv	a0,s2
    80004a46:	ffffc097          	auipc	ra,0xffffc
    80004a4a:	2a6080e7          	jalr	678(ra) # 80000cec <release>
}
    80004a4e:	60e2                	ld	ra,24(sp)
    80004a50:	6442                	ld	s0,16(sp)
    80004a52:	64a2                	ld	s1,8(sp)
    80004a54:	6902                	ld	s2,0(sp)
    80004a56:	6105                	addi	sp,sp,32
    80004a58:	8082                	ret

0000000080004a5a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a5a:	7179                	addi	sp,sp,-48
    80004a5c:	f406                	sd	ra,40(sp)
    80004a5e:	f022                	sd	s0,32(sp)
    80004a60:	ec26                	sd	s1,24(sp)
    80004a62:	e84a                	sd	s2,16(sp)
    80004a64:	1800                	addi	s0,sp,48
    80004a66:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a68:	00850913          	addi	s2,a0,8
    80004a6c:	854a                	mv	a0,s2
    80004a6e:	ffffc097          	auipc	ra,0xffffc
    80004a72:	1ca080e7          	jalr	458(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a76:	409c                	lw	a5,0(s1)
    80004a78:	ef91                	bnez	a5,80004a94 <holdingsleep+0x3a>
    80004a7a:	4481                	li	s1,0
  release(&lk->lk);
    80004a7c:	854a                	mv	a0,s2
    80004a7e:	ffffc097          	auipc	ra,0xffffc
    80004a82:	26e080e7          	jalr	622(ra) # 80000cec <release>
  return r;
}
    80004a86:	8526                	mv	a0,s1
    80004a88:	70a2                	ld	ra,40(sp)
    80004a8a:	7402                	ld	s0,32(sp)
    80004a8c:	64e2                	ld	s1,24(sp)
    80004a8e:	6942                	ld	s2,16(sp)
    80004a90:	6145                	addi	sp,sp,48
    80004a92:	8082                	ret
    80004a94:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a96:	0284a983          	lw	s3,40(s1)
    80004a9a:	ffffd097          	auipc	ra,0xffffd
    80004a9e:	26a080e7          	jalr	618(ra) # 80001d04 <myproc>
    80004aa2:	5904                	lw	s1,48(a0)
    80004aa4:	413484b3          	sub	s1,s1,s3
    80004aa8:	0014b493          	seqz	s1,s1
    80004aac:	69a2                	ld	s3,8(sp)
    80004aae:	b7f9                	j	80004a7c <holdingsleep+0x22>

0000000080004ab0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004ab0:	1141                	addi	sp,sp,-16
    80004ab2:	e406                	sd	ra,8(sp)
    80004ab4:	e022                	sd	s0,0(sp)
    80004ab6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004ab8:	00004597          	auipc	a1,0x4
    80004abc:	ba058593          	addi	a1,a1,-1120 # 80008658 <etext+0x658>
    80004ac0:	0001f517          	auipc	a0,0x1f
    80004ac4:	fc850513          	addi	a0,a0,-56 # 80023a88 <ftable>
    80004ac8:	ffffc097          	auipc	ra,0xffffc
    80004acc:	0e0080e7          	jalr	224(ra) # 80000ba8 <initlock>
}
    80004ad0:	60a2                	ld	ra,8(sp)
    80004ad2:	6402                	ld	s0,0(sp)
    80004ad4:	0141                	addi	sp,sp,16
    80004ad6:	8082                	ret

0000000080004ad8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004ad8:	1101                	addi	sp,sp,-32
    80004ada:	ec06                	sd	ra,24(sp)
    80004adc:	e822                	sd	s0,16(sp)
    80004ade:	e426                	sd	s1,8(sp)
    80004ae0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004ae2:	0001f517          	auipc	a0,0x1f
    80004ae6:	fa650513          	addi	a0,a0,-90 # 80023a88 <ftable>
    80004aea:	ffffc097          	auipc	ra,0xffffc
    80004aee:	14e080e7          	jalr	334(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004af2:	0001f497          	auipc	s1,0x1f
    80004af6:	fae48493          	addi	s1,s1,-82 # 80023aa0 <ftable+0x18>
    80004afa:	00020717          	auipc	a4,0x20
    80004afe:	f4670713          	addi	a4,a4,-186 # 80024a40 <disk>
    if(f->ref == 0){
    80004b02:	40dc                	lw	a5,4(s1)
    80004b04:	cf99                	beqz	a5,80004b22 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b06:	02848493          	addi	s1,s1,40
    80004b0a:	fee49ce3          	bne	s1,a4,80004b02 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b0e:	0001f517          	auipc	a0,0x1f
    80004b12:	f7a50513          	addi	a0,a0,-134 # 80023a88 <ftable>
    80004b16:	ffffc097          	auipc	ra,0xffffc
    80004b1a:	1d6080e7          	jalr	470(ra) # 80000cec <release>
  return 0;
    80004b1e:	4481                	li	s1,0
    80004b20:	a819                	j	80004b36 <filealloc+0x5e>
      f->ref = 1;
    80004b22:	4785                	li	a5,1
    80004b24:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b26:	0001f517          	auipc	a0,0x1f
    80004b2a:	f6250513          	addi	a0,a0,-158 # 80023a88 <ftable>
    80004b2e:	ffffc097          	auipc	ra,0xffffc
    80004b32:	1be080e7          	jalr	446(ra) # 80000cec <release>
}
    80004b36:	8526                	mv	a0,s1
    80004b38:	60e2                	ld	ra,24(sp)
    80004b3a:	6442                	ld	s0,16(sp)
    80004b3c:	64a2                	ld	s1,8(sp)
    80004b3e:	6105                	addi	sp,sp,32
    80004b40:	8082                	ret

0000000080004b42 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b42:	1101                	addi	sp,sp,-32
    80004b44:	ec06                	sd	ra,24(sp)
    80004b46:	e822                	sd	s0,16(sp)
    80004b48:	e426                	sd	s1,8(sp)
    80004b4a:	1000                	addi	s0,sp,32
    80004b4c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b4e:	0001f517          	auipc	a0,0x1f
    80004b52:	f3a50513          	addi	a0,a0,-198 # 80023a88 <ftable>
    80004b56:	ffffc097          	auipc	ra,0xffffc
    80004b5a:	0e2080e7          	jalr	226(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004b5e:	40dc                	lw	a5,4(s1)
    80004b60:	02f05263          	blez	a5,80004b84 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b64:	2785                	addiw	a5,a5,1
    80004b66:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b68:	0001f517          	auipc	a0,0x1f
    80004b6c:	f2050513          	addi	a0,a0,-224 # 80023a88 <ftable>
    80004b70:	ffffc097          	auipc	ra,0xffffc
    80004b74:	17c080e7          	jalr	380(ra) # 80000cec <release>
  return f;
}
    80004b78:	8526                	mv	a0,s1
    80004b7a:	60e2                	ld	ra,24(sp)
    80004b7c:	6442                	ld	s0,16(sp)
    80004b7e:	64a2                	ld	s1,8(sp)
    80004b80:	6105                	addi	sp,sp,32
    80004b82:	8082                	ret
    panic("filedup");
    80004b84:	00004517          	auipc	a0,0x4
    80004b88:	adc50513          	addi	a0,a0,-1316 # 80008660 <etext+0x660>
    80004b8c:	ffffc097          	auipc	ra,0xffffc
    80004b90:	9d4080e7          	jalr	-1580(ra) # 80000560 <panic>

0000000080004b94 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b94:	7139                	addi	sp,sp,-64
    80004b96:	fc06                	sd	ra,56(sp)
    80004b98:	f822                	sd	s0,48(sp)
    80004b9a:	f426                	sd	s1,40(sp)
    80004b9c:	0080                	addi	s0,sp,64
    80004b9e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004ba0:	0001f517          	auipc	a0,0x1f
    80004ba4:	ee850513          	addi	a0,a0,-280 # 80023a88 <ftable>
    80004ba8:	ffffc097          	auipc	ra,0xffffc
    80004bac:	090080e7          	jalr	144(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004bb0:	40dc                	lw	a5,4(s1)
    80004bb2:	04f05c63          	blez	a5,80004c0a <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004bb6:	37fd                	addiw	a5,a5,-1
    80004bb8:	0007871b          	sext.w	a4,a5
    80004bbc:	c0dc                	sw	a5,4(s1)
    80004bbe:	06e04263          	bgtz	a4,80004c22 <fileclose+0x8e>
    80004bc2:	f04a                	sd	s2,32(sp)
    80004bc4:	ec4e                	sd	s3,24(sp)
    80004bc6:	e852                	sd	s4,16(sp)
    80004bc8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004bca:	0004a903          	lw	s2,0(s1)
    80004bce:	0094ca83          	lbu	s5,9(s1)
    80004bd2:	0104ba03          	ld	s4,16(s1)
    80004bd6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004bda:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004bde:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004be2:	0001f517          	auipc	a0,0x1f
    80004be6:	ea650513          	addi	a0,a0,-346 # 80023a88 <ftable>
    80004bea:	ffffc097          	auipc	ra,0xffffc
    80004bee:	102080e7          	jalr	258(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    80004bf2:	4785                	li	a5,1
    80004bf4:	04f90463          	beq	s2,a5,80004c3c <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004bf8:	3979                	addiw	s2,s2,-2
    80004bfa:	4785                	li	a5,1
    80004bfc:	0527fb63          	bgeu	a5,s2,80004c52 <fileclose+0xbe>
    80004c00:	7902                	ld	s2,32(sp)
    80004c02:	69e2                	ld	s3,24(sp)
    80004c04:	6a42                	ld	s4,16(sp)
    80004c06:	6aa2                	ld	s5,8(sp)
    80004c08:	a02d                	j	80004c32 <fileclose+0x9e>
    80004c0a:	f04a                	sd	s2,32(sp)
    80004c0c:	ec4e                	sd	s3,24(sp)
    80004c0e:	e852                	sd	s4,16(sp)
    80004c10:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004c12:	00004517          	auipc	a0,0x4
    80004c16:	a5650513          	addi	a0,a0,-1450 # 80008668 <etext+0x668>
    80004c1a:	ffffc097          	auipc	ra,0xffffc
    80004c1e:	946080e7          	jalr	-1722(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004c22:	0001f517          	auipc	a0,0x1f
    80004c26:	e6650513          	addi	a0,a0,-410 # 80023a88 <ftable>
    80004c2a:	ffffc097          	auipc	ra,0xffffc
    80004c2e:	0c2080e7          	jalr	194(ra) # 80000cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004c32:	70e2                	ld	ra,56(sp)
    80004c34:	7442                	ld	s0,48(sp)
    80004c36:	74a2                	ld	s1,40(sp)
    80004c38:	6121                	addi	sp,sp,64
    80004c3a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c3c:	85d6                	mv	a1,s5
    80004c3e:	8552                	mv	a0,s4
    80004c40:	00000097          	auipc	ra,0x0
    80004c44:	3a2080e7          	jalr	930(ra) # 80004fe2 <pipeclose>
    80004c48:	7902                	ld	s2,32(sp)
    80004c4a:	69e2                	ld	s3,24(sp)
    80004c4c:	6a42                	ld	s4,16(sp)
    80004c4e:	6aa2                	ld	s5,8(sp)
    80004c50:	b7cd                	j	80004c32 <fileclose+0x9e>
    begin_op();
    80004c52:	00000097          	auipc	ra,0x0
    80004c56:	a78080e7          	jalr	-1416(ra) # 800046ca <begin_op>
    iput(ff.ip);
    80004c5a:	854e                	mv	a0,s3
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	25e080e7          	jalr	606(ra) # 80003eba <iput>
    end_op();
    80004c64:	00000097          	auipc	ra,0x0
    80004c68:	ae0080e7          	jalr	-1312(ra) # 80004744 <end_op>
    80004c6c:	7902                	ld	s2,32(sp)
    80004c6e:	69e2                	ld	s3,24(sp)
    80004c70:	6a42                	ld	s4,16(sp)
    80004c72:	6aa2                	ld	s5,8(sp)
    80004c74:	bf7d                	j	80004c32 <fileclose+0x9e>

0000000080004c76 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c76:	715d                	addi	sp,sp,-80
    80004c78:	e486                	sd	ra,72(sp)
    80004c7a:	e0a2                	sd	s0,64(sp)
    80004c7c:	fc26                	sd	s1,56(sp)
    80004c7e:	f44e                	sd	s3,40(sp)
    80004c80:	0880                	addi	s0,sp,80
    80004c82:	84aa                	mv	s1,a0
    80004c84:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c86:	ffffd097          	auipc	ra,0xffffd
    80004c8a:	07e080e7          	jalr	126(ra) # 80001d04 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c8e:	409c                	lw	a5,0(s1)
    80004c90:	37f9                	addiw	a5,a5,-2
    80004c92:	4705                	li	a4,1
    80004c94:	04f76863          	bltu	a4,a5,80004ce4 <filestat+0x6e>
    80004c98:	f84a                	sd	s2,48(sp)
    80004c9a:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c9c:	6c88                	ld	a0,24(s1)
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	05e080e7          	jalr	94(ra) # 80003cfc <ilock>
    stati(f->ip, &st);
    80004ca6:	fb840593          	addi	a1,s0,-72
    80004caa:	6c88                	ld	a0,24(s1)
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	2de080e7          	jalr	734(ra) # 80003f8a <stati>
    iunlock(f->ip);
    80004cb4:	6c88                	ld	a0,24(s1)
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	10c080e7          	jalr	268(ra) # 80003dc2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004cbe:	46e1                	li	a3,24
    80004cc0:	fb840613          	addi	a2,s0,-72
    80004cc4:	85ce                	mv	a1,s3
    80004cc6:	05893503          	ld	a0,88(s2)
    80004cca:	ffffd097          	auipc	ra,0xffffd
    80004cce:	a18080e7          	jalr	-1512(ra) # 800016e2 <copyout>
    80004cd2:	41f5551b          	sraiw	a0,a0,0x1f
    80004cd6:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004cd8:	60a6                	ld	ra,72(sp)
    80004cda:	6406                	ld	s0,64(sp)
    80004cdc:	74e2                	ld	s1,56(sp)
    80004cde:	79a2                	ld	s3,40(sp)
    80004ce0:	6161                	addi	sp,sp,80
    80004ce2:	8082                	ret
  return -1;
    80004ce4:	557d                	li	a0,-1
    80004ce6:	bfcd                	j	80004cd8 <filestat+0x62>

0000000080004ce8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004ce8:	7179                	addi	sp,sp,-48
    80004cea:	f406                	sd	ra,40(sp)
    80004cec:	f022                	sd	s0,32(sp)
    80004cee:	e84a                	sd	s2,16(sp)
    80004cf0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004cf2:	00854783          	lbu	a5,8(a0)
    80004cf6:	cbc5                	beqz	a5,80004da6 <fileread+0xbe>
    80004cf8:	ec26                	sd	s1,24(sp)
    80004cfa:	e44e                	sd	s3,8(sp)
    80004cfc:	84aa                	mv	s1,a0
    80004cfe:	89ae                	mv	s3,a1
    80004d00:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d02:	411c                	lw	a5,0(a0)
    80004d04:	4705                	li	a4,1
    80004d06:	04e78963          	beq	a5,a4,80004d58 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d0a:	470d                	li	a4,3
    80004d0c:	04e78f63          	beq	a5,a4,80004d6a <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d10:	4709                	li	a4,2
    80004d12:	08e79263          	bne	a5,a4,80004d96 <fileread+0xae>
    ilock(f->ip);
    80004d16:	6d08                	ld	a0,24(a0)
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	fe4080e7          	jalr	-28(ra) # 80003cfc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d20:	874a                	mv	a4,s2
    80004d22:	5094                	lw	a3,32(s1)
    80004d24:	864e                	mv	a2,s3
    80004d26:	4585                	li	a1,1
    80004d28:	6c88                	ld	a0,24(s1)
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	28a080e7          	jalr	650(ra) # 80003fb4 <readi>
    80004d32:	892a                	mv	s2,a0
    80004d34:	00a05563          	blez	a0,80004d3e <fileread+0x56>
      f->off += r;
    80004d38:	509c                	lw	a5,32(s1)
    80004d3a:	9fa9                	addw	a5,a5,a0
    80004d3c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d3e:	6c88                	ld	a0,24(s1)
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	082080e7          	jalr	130(ra) # 80003dc2 <iunlock>
    80004d48:	64e2                	ld	s1,24(sp)
    80004d4a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004d4c:	854a                	mv	a0,s2
    80004d4e:	70a2                	ld	ra,40(sp)
    80004d50:	7402                	ld	s0,32(sp)
    80004d52:	6942                	ld	s2,16(sp)
    80004d54:	6145                	addi	sp,sp,48
    80004d56:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d58:	6908                	ld	a0,16(a0)
    80004d5a:	00000097          	auipc	ra,0x0
    80004d5e:	400080e7          	jalr	1024(ra) # 8000515a <piperead>
    80004d62:	892a                	mv	s2,a0
    80004d64:	64e2                	ld	s1,24(sp)
    80004d66:	69a2                	ld	s3,8(sp)
    80004d68:	b7d5                	j	80004d4c <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d6a:	02451783          	lh	a5,36(a0)
    80004d6e:	03079693          	slli	a3,a5,0x30
    80004d72:	92c1                	srli	a3,a3,0x30
    80004d74:	4725                	li	a4,9
    80004d76:	02d76a63          	bltu	a4,a3,80004daa <fileread+0xc2>
    80004d7a:	0792                	slli	a5,a5,0x4
    80004d7c:	0001f717          	auipc	a4,0x1f
    80004d80:	c6c70713          	addi	a4,a4,-916 # 800239e8 <devsw>
    80004d84:	97ba                	add	a5,a5,a4
    80004d86:	639c                	ld	a5,0(a5)
    80004d88:	c78d                	beqz	a5,80004db2 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004d8a:	4505                	li	a0,1
    80004d8c:	9782                	jalr	a5
    80004d8e:	892a                	mv	s2,a0
    80004d90:	64e2                	ld	s1,24(sp)
    80004d92:	69a2                	ld	s3,8(sp)
    80004d94:	bf65                	j	80004d4c <fileread+0x64>
    panic("fileread");
    80004d96:	00004517          	auipc	a0,0x4
    80004d9a:	8e250513          	addi	a0,a0,-1822 # 80008678 <etext+0x678>
    80004d9e:	ffffb097          	auipc	ra,0xffffb
    80004da2:	7c2080e7          	jalr	1986(ra) # 80000560 <panic>
    return -1;
    80004da6:	597d                	li	s2,-1
    80004da8:	b755                	j	80004d4c <fileread+0x64>
      return -1;
    80004daa:	597d                	li	s2,-1
    80004dac:	64e2                	ld	s1,24(sp)
    80004dae:	69a2                	ld	s3,8(sp)
    80004db0:	bf71                	j	80004d4c <fileread+0x64>
    80004db2:	597d                	li	s2,-1
    80004db4:	64e2                	ld	s1,24(sp)
    80004db6:	69a2                	ld	s3,8(sp)
    80004db8:	bf51                	j	80004d4c <fileread+0x64>

0000000080004dba <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004dba:	00954783          	lbu	a5,9(a0)
    80004dbe:	12078963          	beqz	a5,80004ef0 <filewrite+0x136>
{
    80004dc2:	715d                	addi	sp,sp,-80
    80004dc4:	e486                	sd	ra,72(sp)
    80004dc6:	e0a2                	sd	s0,64(sp)
    80004dc8:	f84a                	sd	s2,48(sp)
    80004dca:	f052                	sd	s4,32(sp)
    80004dcc:	e85a                	sd	s6,16(sp)
    80004dce:	0880                	addi	s0,sp,80
    80004dd0:	892a                	mv	s2,a0
    80004dd2:	8b2e                	mv	s6,a1
    80004dd4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004dd6:	411c                	lw	a5,0(a0)
    80004dd8:	4705                	li	a4,1
    80004dda:	02e78763          	beq	a5,a4,80004e08 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004dde:	470d                	li	a4,3
    80004de0:	02e78a63          	beq	a5,a4,80004e14 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004de4:	4709                	li	a4,2
    80004de6:	0ee79863          	bne	a5,a4,80004ed6 <filewrite+0x11c>
    80004dea:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004dec:	0cc05463          	blez	a2,80004eb4 <filewrite+0xfa>
    80004df0:	fc26                	sd	s1,56(sp)
    80004df2:	ec56                	sd	s5,24(sp)
    80004df4:	e45e                	sd	s7,8(sp)
    80004df6:	e062                	sd	s8,0(sp)
    int i = 0;
    80004df8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004dfa:	6b85                	lui	s7,0x1
    80004dfc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004e00:	6c05                	lui	s8,0x1
    80004e02:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004e06:	a851                	j	80004e9a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004e08:	6908                	ld	a0,16(a0)
    80004e0a:	00000097          	auipc	ra,0x0
    80004e0e:	248080e7          	jalr	584(ra) # 80005052 <pipewrite>
    80004e12:	a85d                	j	80004ec8 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e14:	02451783          	lh	a5,36(a0)
    80004e18:	03079693          	slli	a3,a5,0x30
    80004e1c:	92c1                	srli	a3,a3,0x30
    80004e1e:	4725                	li	a4,9
    80004e20:	0cd76a63          	bltu	a4,a3,80004ef4 <filewrite+0x13a>
    80004e24:	0792                	slli	a5,a5,0x4
    80004e26:	0001f717          	auipc	a4,0x1f
    80004e2a:	bc270713          	addi	a4,a4,-1086 # 800239e8 <devsw>
    80004e2e:	97ba                	add	a5,a5,a4
    80004e30:	679c                	ld	a5,8(a5)
    80004e32:	c3f9                	beqz	a5,80004ef8 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004e34:	4505                	li	a0,1
    80004e36:	9782                	jalr	a5
    80004e38:	a841                	j	80004ec8 <filewrite+0x10e>
      if(n1 > max)
    80004e3a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004e3e:	00000097          	auipc	ra,0x0
    80004e42:	88c080e7          	jalr	-1908(ra) # 800046ca <begin_op>
      ilock(f->ip);
    80004e46:	01893503          	ld	a0,24(s2)
    80004e4a:	fffff097          	auipc	ra,0xfffff
    80004e4e:	eb2080e7          	jalr	-334(ra) # 80003cfc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e52:	8756                	mv	a4,s5
    80004e54:	02092683          	lw	a3,32(s2)
    80004e58:	01698633          	add	a2,s3,s6
    80004e5c:	4585                	li	a1,1
    80004e5e:	01893503          	ld	a0,24(s2)
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	262080e7          	jalr	610(ra) # 800040c4 <writei>
    80004e6a:	84aa                	mv	s1,a0
    80004e6c:	00a05763          	blez	a0,80004e7a <filewrite+0xc0>
        f->off += r;
    80004e70:	02092783          	lw	a5,32(s2)
    80004e74:	9fa9                	addw	a5,a5,a0
    80004e76:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e7a:	01893503          	ld	a0,24(s2)
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	f44080e7          	jalr	-188(ra) # 80003dc2 <iunlock>
      end_op();
    80004e86:	00000097          	auipc	ra,0x0
    80004e8a:	8be080e7          	jalr	-1858(ra) # 80004744 <end_op>

      if(r != n1){
    80004e8e:	029a9563          	bne	s5,s1,80004eb8 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004e92:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004e96:	0149da63          	bge	s3,s4,80004eaa <filewrite+0xf0>
      int n1 = n - i;
    80004e9a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004e9e:	0004879b          	sext.w	a5,s1
    80004ea2:	f8fbdce3          	bge	s7,a5,80004e3a <filewrite+0x80>
    80004ea6:	84e2                	mv	s1,s8
    80004ea8:	bf49                	j	80004e3a <filewrite+0x80>
    80004eaa:	74e2                	ld	s1,56(sp)
    80004eac:	6ae2                	ld	s5,24(sp)
    80004eae:	6ba2                	ld	s7,8(sp)
    80004eb0:	6c02                	ld	s8,0(sp)
    80004eb2:	a039                	j	80004ec0 <filewrite+0x106>
    int i = 0;
    80004eb4:	4981                	li	s3,0
    80004eb6:	a029                	j	80004ec0 <filewrite+0x106>
    80004eb8:	74e2                	ld	s1,56(sp)
    80004eba:	6ae2                	ld	s5,24(sp)
    80004ebc:	6ba2                	ld	s7,8(sp)
    80004ebe:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004ec0:	033a1e63          	bne	s4,s3,80004efc <filewrite+0x142>
    80004ec4:	8552                	mv	a0,s4
    80004ec6:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004ec8:	60a6                	ld	ra,72(sp)
    80004eca:	6406                	ld	s0,64(sp)
    80004ecc:	7942                	ld	s2,48(sp)
    80004ece:	7a02                	ld	s4,32(sp)
    80004ed0:	6b42                	ld	s6,16(sp)
    80004ed2:	6161                	addi	sp,sp,80
    80004ed4:	8082                	ret
    80004ed6:	fc26                	sd	s1,56(sp)
    80004ed8:	f44e                	sd	s3,40(sp)
    80004eda:	ec56                	sd	s5,24(sp)
    80004edc:	e45e                	sd	s7,8(sp)
    80004ede:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004ee0:	00003517          	auipc	a0,0x3
    80004ee4:	7a850513          	addi	a0,a0,1960 # 80008688 <etext+0x688>
    80004ee8:	ffffb097          	auipc	ra,0xffffb
    80004eec:	678080e7          	jalr	1656(ra) # 80000560 <panic>
    return -1;
    80004ef0:	557d                	li	a0,-1
}
    80004ef2:	8082                	ret
      return -1;
    80004ef4:	557d                	li	a0,-1
    80004ef6:	bfc9                	j	80004ec8 <filewrite+0x10e>
    80004ef8:	557d                	li	a0,-1
    80004efa:	b7f9                	j	80004ec8 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004efc:	557d                	li	a0,-1
    80004efe:	79a2                	ld	s3,40(sp)
    80004f00:	b7e1                	j	80004ec8 <filewrite+0x10e>

0000000080004f02 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f02:	7179                	addi	sp,sp,-48
    80004f04:	f406                	sd	ra,40(sp)
    80004f06:	f022                	sd	s0,32(sp)
    80004f08:	ec26                	sd	s1,24(sp)
    80004f0a:	e052                	sd	s4,0(sp)
    80004f0c:	1800                	addi	s0,sp,48
    80004f0e:	84aa                	mv	s1,a0
    80004f10:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f12:	0005b023          	sd	zero,0(a1)
    80004f16:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f1a:	00000097          	auipc	ra,0x0
    80004f1e:	bbe080e7          	jalr	-1090(ra) # 80004ad8 <filealloc>
    80004f22:	e088                	sd	a0,0(s1)
    80004f24:	cd49                	beqz	a0,80004fbe <pipealloc+0xbc>
    80004f26:	00000097          	auipc	ra,0x0
    80004f2a:	bb2080e7          	jalr	-1102(ra) # 80004ad8 <filealloc>
    80004f2e:	00aa3023          	sd	a0,0(s4)
    80004f32:	c141                	beqz	a0,80004fb2 <pipealloc+0xb0>
    80004f34:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f36:	ffffc097          	auipc	ra,0xffffc
    80004f3a:	c12080e7          	jalr	-1006(ra) # 80000b48 <kalloc>
    80004f3e:	892a                	mv	s2,a0
    80004f40:	c13d                	beqz	a0,80004fa6 <pipealloc+0xa4>
    80004f42:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004f44:	4985                	li	s3,1
    80004f46:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f4a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f4e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f52:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f56:	00003597          	auipc	a1,0x3
    80004f5a:	74258593          	addi	a1,a1,1858 # 80008698 <etext+0x698>
    80004f5e:	ffffc097          	auipc	ra,0xffffc
    80004f62:	c4a080e7          	jalr	-950(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    80004f66:	609c                	ld	a5,0(s1)
    80004f68:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f6c:	609c                	ld	a5,0(s1)
    80004f6e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f72:	609c                	ld	a5,0(s1)
    80004f74:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f78:	609c                	ld	a5,0(s1)
    80004f7a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f7e:	000a3783          	ld	a5,0(s4)
    80004f82:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f86:	000a3783          	ld	a5,0(s4)
    80004f8a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f8e:	000a3783          	ld	a5,0(s4)
    80004f92:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f96:	000a3783          	ld	a5,0(s4)
    80004f9a:	0127b823          	sd	s2,16(a5)
  return 0;
    80004f9e:	4501                	li	a0,0
    80004fa0:	6942                	ld	s2,16(sp)
    80004fa2:	69a2                	ld	s3,8(sp)
    80004fa4:	a03d                	j	80004fd2 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004fa6:	6088                	ld	a0,0(s1)
    80004fa8:	c119                	beqz	a0,80004fae <pipealloc+0xac>
    80004faa:	6942                	ld	s2,16(sp)
    80004fac:	a029                	j	80004fb6 <pipealloc+0xb4>
    80004fae:	6942                	ld	s2,16(sp)
    80004fb0:	a039                	j	80004fbe <pipealloc+0xbc>
    80004fb2:	6088                	ld	a0,0(s1)
    80004fb4:	c50d                	beqz	a0,80004fde <pipealloc+0xdc>
    fileclose(*f0);
    80004fb6:	00000097          	auipc	ra,0x0
    80004fba:	bde080e7          	jalr	-1058(ra) # 80004b94 <fileclose>
  if(*f1)
    80004fbe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004fc2:	557d                	li	a0,-1
  if(*f1)
    80004fc4:	c799                	beqz	a5,80004fd2 <pipealloc+0xd0>
    fileclose(*f1);
    80004fc6:	853e                	mv	a0,a5
    80004fc8:	00000097          	auipc	ra,0x0
    80004fcc:	bcc080e7          	jalr	-1076(ra) # 80004b94 <fileclose>
  return -1;
    80004fd0:	557d                	li	a0,-1
}
    80004fd2:	70a2                	ld	ra,40(sp)
    80004fd4:	7402                	ld	s0,32(sp)
    80004fd6:	64e2                	ld	s1,24(sp)
    80004fd8:	6a02                	ld	s4,0(sp)
    80004fda:	6145                	addi	sp,sp,48
    80004fdc:	8082                	ret
  return -1;
    80004fde:	557d                	li	a0,-1
    80004fe0:	bfcd                	j	80004fd2 <pipealloc+0xd0>

0000000080004fe2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004fe2:	1101                	addi	sp,sp,-32
    80004fe4:	ec06                	sd	ra,24(sp)
    80004fe6:	e822                	sd	s0,16(sp)
    80004fe8:	e426                	sd	s1,8(sp)
    80004fea:	e04a                	sd	s2,0(sp)
    80004fec:	1000                	addi	s0,sp,32
    80004fee:	84aa                	mv	s1,a0
    80004ff0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004ff2:	ffffc097          	auipc	ra,0xffffc
    80004ff6:	c46080e7          	jalr	-954(ra) # 80000c38 <acquire>
  if(writable){
    80004ffa:	02090d63          	beqz	s2,80005034 <pipeclose+0x52>
    pi->writeopen = 0;
    80004ffe:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005002:	21848513          	addi	a0,s1,536
    80005006:	ffffd097          	auipc	ra,0xffffd
    8000500a:	546080e7          	jalr	1350(ra) # 8000254c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000500e:	2204b783          	ld	a5,544(s1)
    80005012:	eb95                	bnez	a5,80005046 <pipeclose+0x64>
    release(&pi->lock);
    80005014:	8526                	mv	a0,s1
    80005016:	ffffc097          	auipc	ra,0xffffc
    8000501a:	cd6080e7          	jalr	-810(ra) # 80000cec <release>
    kfree((char*)pi);
    8000501e:	8526                	mv	a0,s1
    80005020:	ffffc097          	auipc	ra,0xffffc
    80005024:	a2a080e7          	jalr	-1494(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    80005028:	60e2                	ld	ra,24(sp)
    8000502a:	6442                	ld	s0,16(sp)
    8000502c:	64a2                	ld	s1,8(sp)
    8000502e:	6902                	ld	s2,0(sp)
    80005030:	6105                	addi	sp,sp,32
    80005032:	8082                	ret
    pi->readopen = 0;
    80005034:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005038:	21c48513          	addi	a0,s1,540
    8000503c:	ffffd097          	auipc	ra,0xffffd
    80005040:	510080e7          	jalr	1296(ra) # 8000254c <wakeup>
    80005044:	b7e9                	j	8000500e <pipeclose+0x2c>
    release(&pi->lock);
    80005046:	8526                	mv	a0,s1
    80005048:	ffffc097          	auipc	ra,0xffffc
    8000504c:	ca4080e7          	jalr	-860(ra) # 80000cec <release>
}
    80005050:	bfe1                	j	80005028 <pipeclose+0x46>

0000000080005052 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005052:	711d                	addi	sp,sp,-96
    80005054:	ec86                	sd	ra,88(sp)
    80005056:	e8a2                	sd	s0,80(sp)
    80005058:	e4a6                	sd	s1,72(sp)
    8000505a:	e0ca                	sd	s2,64(sp)
    8000505c:	fc4e                	sd	s3,56(sp)
    8000505e:	f852                	sd	s4,48(sp)
    80005060:	f456                	sd	s5,40(sp)
    80005062:	1080                	addi	s0,sp,96
    80005064:	84aa                	mv	s1,a0
    80005066:	8aae                	mv	s5,a1
    80005068:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000506a:	ffffd097          	auipc	ra,0xffffd
    8000506e:	c9a080e7          	jalr	-870(ra) # 80001d04 <myproc>
    80005072:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005074:	8526                	mv	a0,s1
    80005076:	ffffc097          	auipc	ra,0xffffc
    8000507a:	bc2080e7          	jalr	-1086(ra) # 80000c38 <acquire>
  while(i < n){
    8000507e:	0d405863          	blez	s4,8000514e <pipewrite+0xfc>
    80005082:	f05a                	sd	s6,32(sp)
    80005084:	ec5e                	sd	s7,24(sp)
    80005086:	e862                	sd	s8,16(sp)
  int i = 0;
    80005088:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000508a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000508c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005090:	21c48b93          	addi	s7,s1,540
    80005094:	a089                	j	800050d6 <pipewrite+0x84>
      release(&pi->lock);
    80005096:	8526                	mv	a0,s1
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	c54080e7          	jalr	-940(ra) # 80000cec <release>
      return -1;
    800050a0:	597d                	li	s2,-1
    800050a2:	7b02                	ld	s6,32(sp)
    800050a4:	6be2                	ld	s7,24(sp)
    800050a6:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800050a8:	854a                	mv	a0,s2
    800050aa:	60e6                	ld	ra,88(sp)
    800050ac:	6446                	ld	s0,80(sp)
    800050ae:	64a6                	ld	s1,72(sp)
    800050b0:	6906                	ld	s2,64(sp)
    800050b2:	79e2                	ld	s3,56(sp)
    800050b4:	7a42                	ld	s4,48(sp)
    800050b6:	7aa2                	ld	s5,40(sp)
    800050b8:	6125                	addi	sp,sp,96
    800050ba:	8082                	ret
      wakeup(&pi->nread);
    800050bc:	8562                	mv	a0,s8
    800050be:	ffffd097          	auipc	ra,0xffffd
    800050c2:	48e080e7          	jalr	1166(ra) # 8000254c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050c6:	85a6                	mv	a1,s1
    800050c8:	855e                	mv	a0,s7
    800050ca:	ffffd097          	auipc	ra,0xffffd
    800050ce:	41e080e7          	jalr	1054(ra) # 800024e8 <sleep>
  while(i < n){
    800050d2:	05495f63          	bge	s2,s4,80005130 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    800050d6:	2204a783          	lw	a5,544(s1)
    800050da:	dfd5                	beqz	a5,80005096 <pipewrite+0x44>
    800050dc:	854e                	mv	a0,s3
    800050de:	ffffd097          	auipc	ra,0xffffd
    800050e2:	6b2080e7          	jalr	1714(ra) # 80002790 <killed>
    800050e6:	f945                	bnez	a0,80005096 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800050e8:	2184a783          	lw	a5,536(s1)
    800050ec:	21c4a703          	lw	a4,540(s1)
    800050f0:	2007879b          	addiw	a5,a5,512
    800050f4:	fcf704e3          	beq	a4,a5,800050bc <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050f8:	4685                	li	a3,1
    800050fa:	01590633          	add	a2,s2,s5
    800050fe:	faf40593          	addi	a1,s0,-81
    80005102:	0589b503          	ld	a0,88(s3)
    80005106:	ffffc097          	auipc	ra,0xffffc
    8000510a:	668080e7          	jalr	1640(ra) # 8000176e <copyin>
    8000510e:	05650263          	beq	a0,s6,80005152 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005112:	21c4a783          	lw	a5,540(s1)
    80005116:	0017871b          	addiw	a4,a5,1
    8000511a:	20e4ae23          	sw	a4,540(s1)
    8000511e:	1ff7f793          	andi	a5,a5,511
    80005122:	97a6                	add	a5,a5,s1
    80005124:	faf44703          	lbu	a4,-81(s0)
    80005128:	00e78c23          	sb	a4,24(a5)
      i++;
    8000512c:	2905                	addiw	s2,s2,1
    8000512e:	b755                	j	800050d2 <pipewrite+0x80>
    80005130:	7b02                	ld	s6,32(sp)
    80005132:	6be2                	ld	s7,24(sp)
    80005134:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80005136:	21848513          	addi	a0,s1,536
    8000513a:	ffffd097          	auipc	ra,0xffffd
    8000513e:	412080e7          	jalr	1042(ra) # 8000254c <wakeup>
  release(&pi->lock);
    80005142:	8526                	mv	a0,s1
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	ba8080e7          	jalr	-1112(ra) # 80000cec <release>
  return i;
    8000514c:	bfb1                	j	800050a8 <pipewrite+0x56>
  int i = 0;
    8000514e:	4901                	li	s2,0
    80005150:	b7dd                	j	80005136 <pipewrite+0xe4>
    80005152:	7b02                	ld	s6,32(sp)
    80005154:	6be2                	ld	s7,24(sp)
    80005156:	6c42                	ld	s8,16(sp)
    80005158:	bff9                	j	80005136 <pipewrite+0xe4>

000000008000515a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000515a:	715d                	addi	sp,sp,-80
    8000515c:	e486                	sd	ra,72(sp)
    8000515e:	e0a2                	sd	s0,64(sp)
    80005160:	fc26                	sd	s1,56(sp)
    80005162:	f84a                	sd	s2,48(sp)
    80005164:	f44e                	sd	s3,40(sp)
    80005166:	f052                	sd	s4,32(sp)
    80005168:	ec56                	sd	s5,24(sp)
    8000516a:	0880                	addi	s0,sp,80
    8000516c:	84aa                	mv	s1,a0
    8000516e:	892e                	mv	s2,a1
    80005170:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005172:	ffffd097          	auipc	ra,0xffffd
    80005176:	b92080e7          	jalr	-1134(ra) # 80001d04 <myproc>
    8000517a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000517c:	8526                	mv	a0,s1
    8000517e:	ffffc097          	auipc	ra,0xffffc
    80005182:	aba080e7          	jalr	-1350(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005186:	2184a703          	lw	a4,536(s1)
    8000518a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000518e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005192:	02f71963          	bne	a4,a5,800051c4 <piperead+0x6a>
    80005196:	2244a783          	lw	a5,548(s1)
    8000519a:	cf95                	beqz	a5,800051d6 <piperead+0x7c>
    if(killed(pr)){
    8000519c:	8552                	mv	a0,s4
    8000519e:	ffffd097          	auipc	ra,0xffffd
    800051a2:	5f2080e7          	jalr	1522(ra) # 80002790 <killed>
    800051a6:	e10d                	bnez	a0,800051c8 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051a8:	85a6                	mv	a1,s1
    800051aa:	854e                	mv	a0,s3
    800051ac:	ffffd097          	auipc	ra,0xffffd
    800051b0:	33c080e7          	jalr	828(ra) # 800024e8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051b4:	2184a703          	lw	a4,536(s1)
    800051b8:	21c4a783          	lw	a5,540(s1)
    800051bc:	fcf70de3          	beq	a4,a5,80005196 <piperead+0x3c>
    800051c0:	e85a                	sd	s6,16(sp)
    800051c2:	a819                	j	800051d8 <piperead+0x7e>
    800051c4:	e85a                	sd	s6,16(sp)
    800051c6:	a809                	j	800051d8 <piperead+0x7e>
      release(&pi->lock);
    800051c8:	8526                	mv	a0,s1
    800051ca:	ffffc097          	auipc	ra,0xffffc
    800051ce:	b22080e7          	jalr	-1246(ra) # 80000cec <release>
      return -1;
    800051d2:	59fd                	li	s3,-1
    800051d4:	a0a5                	j	8000523c <piperead+0xe2>
    800051d6:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051d8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051da:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051dc:	05505463          	blez	s5,80005224 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800051e0:	2184a783          	lw	a5,536(s1)
    800051e4:	21c4a703          	lw	a4,540(s1)
    800051e8:	02f70e63          	beq	a4,a5,80005224 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051ec:	0017871b          	addiw	a4,a5,1
    800051f0:	20e4ac23          	sw	a4,536(s1)
    800051f4:	1ff7f793          	andi	a5,a5,511
    800051f8:	97a6                	add	a5,a5,s1
    800051fa:	0187c783          	lbu	a5,24(a5)
    800051fe:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005202:	4685                	li	a3,1
    80005204:	fbf40613          	addi	a2,s0,-65
    80005208:	85ca                	mv	a1,s2
    8000520a:	058a3503          	ld	a0,88(s4)
    8000520e:	ffffc097          	auipc	ra,0xffffc
    80005212:	4d4080e7          	jalr	1236(ra) # 800016e2 <copyout>
    80005216:	01650763          	beq	a0,s6,80005224 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000521a:	2985                	addiw	s3,s3,1
    8000521c:	0905                	addi	s2,s2,1
    8000521e:	fd3a91e3          	bne	s5,s3,800051e0 <piperead+0x86>
    80005222:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005224:	21c48513          	addi	a0,s1,540
    80005228:	ffffd097          	auipc	ra,0xffffd
    8000522c:	324080e7          	jalr	804(ra) # 8000254c <wakeup>
  release(&pi->lock);
    80005230:	8526                	mv	a0,s1
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	aba080e7          	jalr	-1350(ra) # 80000cec <release>
    8000523a:	6b42                	ld	s6,16(sp)
  return i;
}
    8000523c:	854e                	mv	a0,s3
    8000523e:	60a6                	ld	ra,72(sp)
    80005240:	6406                	ld	s0,64(sp)
    80005242:	74e2                	ld	s1,56(sp)
    80005244:	7942                	ld	s2,48(sp)
    80005246:	79a2                	ld	s3,40(sp)
    80005248:	7a02                	ld	s4,32(sp)
    8000524a:	6ae2                	ld	s5,24(sp)
    8000524c:	6161                	addi	sp,sp,80
    8000524e:	8082                	ret

0000000080005250 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005250:	1141                	addi	sp,sp,-16
    80005252:	e422                	sd	s0,8(sp)
    80005254:	0800                	addi	s0,sp,16
    80005256:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005258:	8905                	andi	a0,a0,1
    8000525a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000525c:	8b89                	andi	a5,a5,2
    8000525e:	c399                	beqz	a5,80005264 <flags2perm+0x14>
      perm |= PTE_W;
    80005260:	00456513          	ori	a0,a0,4
    return perm;
}
    80005264:	6422                	ld	s0,8(sp)
    80005266:	0141                	addi	sp,sp,16
    80005268:	8082                	ret

000000008000526a <exec>:

int
exec(char *path, char **argv)
{
    8000526a:	df010113          	addi	sp,sp,-528
    8000526e:	20113423          	sd	ra,520(sp)
    80005272:	20813023          	sd	s0,512(sp)
    80005276:	ffa6                	sd	s1,504(sp)
    80005278:	fbca                	sd	s2,496(sp)
    8000527a:	0c00                	addi	s0,sp,528
    8000527c:	892a                	mv	s2,a0
    8000527e:	dea43c23          	sd	a0,-520(s0)
    80005282:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005286:	ffffd097          	auipc	ra,0xffffd
    8000528a:	a7e080e7          	jalr	-1410(ra) # 80001d04 <myproc>
    8000528e:	84aa                	mv	s1,a0

  begin_op();
    80005290:	fffff097          	auipc	ra,0xfffff
    80005294:	43a080e7          	jalr	1082(ra) # 800046ca <begin_op>

  if((ip = namei(path)) == 0){
    80005298:	854a                	mv	a0,s2
    8000529a:	fffff097          	auipc	ra,0xfffff
    8000529e:	230080e7          	jalr	560(ra) # 800044ca <namei>
    800052a2:	c135                	beqz	a0,80005306 <exec+0x9c>
    800052a4:	f3d2                	sd	s4,480(sp)
    800052a6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800052a8:	fffff097          	auipc	ra,0xfffff
    800052ac:	a54080e7          	jalr	-1452(ra) # 80003cfc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800052b0:	04000713          	li	a4,64
    800052b4:	4681                	li	a3,0
    800052b6:	e5040613          	addi	a2,s0,-432
    800052ba:	4581                	li	a1,0
    800052bc:	8552                	mv	a0,s4
    800052be:	fffff097          	auipc	ra,0xfffff
    800052c2:	cf6080e7          	jalr	-778(ra) # 80003fb4 <readi>
    800052c6:	04000793          	li	a5,64
    800052ca:	00f51a63          	bne	a0,a5,800052de <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800052ce:	e5042703          	lw	a4,-432(s0)
    800052d2:	464c47b7          	lui	a5,0x464c4
    800052d6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800052da:	02f70c63          	beq	a4,a5,80005312 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800052de:	8552                	mv	a0,s4
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	c82080e7          	jalr	-894(ra) # 80003f62 <iunlockput>
    end_op();
    800052e8:	fffff097          	auipc	ra,0xfffff
    800052ec:	45c080e7          	jalr	1116(ra) # 80004744 <end_op>
  }
  return -1;
    800052f0:	557d                	li	a0,-1
    800052f2:	7a1e                	ld	s4,480(sp)
}
    800052f4:	20813083          	ld	ra,520(sp)
    800052f8:	20013403          	ld	s0,512(sp)
    800052fc:	74fe                	ld	s1,504(sp)
    800052fe:	795e                	ld	s2,496(sp)
    80005300:	21010113          	addi	sp,sp,528
    80005304:	8082                	ret
    end_op();
    80005306:	fffff097          	auipc	ra,0xfffff
    8000530a:	43e080e7          	jalr	1086(ra) # 80004744 <end_op>
    return -1;
    8000530e:	557d                	li	a0,-1
    80005310:	b7d5                	j	800052f4 <exec+0x8a>
    80005312:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005314:	8526                	mv	a0,s1
    80005316:	ffffd097          	auipc	ra,0xffffd
    8000531a:	ab2080e7          	jalr	-1358(ra) # 80001dc8 <proc_pagetable>
    8000531e:	8b2a                	mv	s6,a0
    80005320:	30050f63          	beqz	a0,8000563e <exec+0x3d4>
    80005324:	f7ce                	sd	s3,488(sp)
    80005326:	efd6                	sd	s5,472(sp)
    80005328:	e7de                	sd	s7,456(sp)
    8000532a:	e3e2                	sd	s8,448(sp)
    8000532c:	ff66                	sd	s9,440(sp)
    8000532e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005330:	e7042d03          	lw	s10,-400(s0)
    80005334:	e8845783          	lhu	a5,-376(s0)
    80005338:	14078d63          	beqz	a5,80005492 <exec+0x228>
    8000533c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000533e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005340:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005342:	6c85                	lui	s9,0x1
    80005344:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005348:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000534c:	6a85                	lui	s5,0x1
    8000534e:	a0b5                	j	800053ba <exec+0x150>
      panic("loadseg: address should exist");
    80005350:	00003517          	auipc	a0,0x3
    80005354:	35050513          	addi	a0,a0,848 # 800086a0 <etext+0x6a0>
    80005358:	ffffb097          	auipc	ra,0xffffb
    8000535c:	208080e7          	jalr	520(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005360:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005362:	8726                	mv	a4,s1
    80005364:	012c06bb          	addw	a3,s8,s2
    80005368:	4581                	li	a1,0
    8000536a:	8552                	mv	a0,s4
    8000536c:	fffff097          	auipc	ra,0xfffff
    80005370:	c48080e7          	jalr	-952(ra) # 80003fb4 <readi>
    80005374:	2501                	sext.w	a0,a0
    80005376:	28a49863          	bne	s1,a0,80005606 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    8000537a:	012a893b          	addw	s2,s5,s2
    8000537e:	03397563          	bgeu	s2,s3,800053a8 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80005382:	02091593          	slli	a1,s2,0x20
    80005386:	9181                	srli	a1,a1,0x20
    80005388:	95de                	add	a1,a1,s7
    8000538a:	855a                	mv	a0,s6
    8000538c:	ffffc097          	auipc	ra,0xffffc
    80005390:	d2a080e7          	jalr	-726(ra) # 800010b6 <walkaddr>
    80005394:	862a                	mv	a2,a0
    if(pa == 0)
    80005396:	dd4d                	beqz	a0,80005350 <exec+0xe6>
    if(sz - i < PGSIZE)
    80005398:	412984bb          	subw	s1,s3,s2
    8000539c:	0004879b          	sext.w	a5,s1
    800053a0:	fcfcf0e3          	bgeu	s9,a5,80005360 <exec+0xf6>
    800053a4:	84d6                	mv	s1,s5
    800053a6:	bf6d                	j	80005360 <exec+0xf6>
    sz = sz1;
    800053a8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053ac:	2d85                	addiw	s11,s11,1
    800053ae:	038d0d1b          	addiw	s10,s10,56
    800053b2:	e8845783          	lhu	a5,-376(s0)
    800053b6:	08fdd663          	bge	s11,a5,80005442 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800053ba:	2d01                	sext.w	s10,s10
    800053bc:	03800713          	li	a4,56
    800053c0:	86ea                	mv	a3,s10
    800053c2:	e1840613          	addi	a2,s0,-488
    800053c6:	4581                	li	a1,0
    800053c8:	8552                	mv	a0,s4
    800053ca:	fffff097          	auipc	ra,0xfffff
    800053ce:	bea080e7          	jalr	-1046(ra) # 80003fb4 <readi>
    800053d2:	03800793          	li	a5,56
    800053d6:	20f51063          	bne	a0,a5,800055d6 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800053da:	e1842783          	lw	a5,-488(s0)
    800053de:	4705                	li	a4,1
    800053e0:	fce796e3          	bne	a5,a4,800053ac <exec+0x142>
    if(ph.memsz < ph.filesz)
    800053e4:	e4043483          	ld	s1,-448(s0)
    800053e8:	e3843783          	ld	a5,-456(s0)
    800053ec:	1ef4e963          	bltu	s1,a5,800055de <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800053f0:	e2843783          	ld	a5,-472(s0)
    800053f4:	94be                	add	s1,s1,a5
    800053f6:	1ef4e863          	bltu	s1,a5,800055e6 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    800053fa:	df043703          	ld	a4,-528(s0)
    800053fe:	8ff9                	and	a5,a5,a4
    80005400:	1e079763          	bnez	a5,800055ee <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005404:	e1c42503          	lw	a0,-484(s0)
    80005408:	00000097          	auipc	ra,0x0
    8000540c:	e48080e7          	jalr	-440(ra) # 80005250 <flags2perm>
    80005410:	86aa                	mv	a3,a0
    80005412:	8626                	mv	a2,s1
    80005414:	85ca                	mv	a1,s2
    80005416:	855a                	mv	a0,s6
    80005418:	ffffc097          	auipc	ra,0xffffc
    8000541c:	062080e7          	jalr	98(ra) # 8000147a <uvmalloc>
    80005420:	e0a43423          	sd	a0,-504(s0)
    80005424:	1c050963          	beqz	a0,800055f6 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005428:	e2843b83          	ld	s7,-472(s0)
    8000542c:	e2042c03          	lw	s8,-480(s0)
    80005430:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005434:	00098463          	beqz	s3,8000543c <exec+0x1d2>
    80005438:	4901                	li	s2,0
    8000543a:	b7a1                	j	80005382 <exec+0x118>
    sz = sz1;
    8000543c:	e0843903          	ld	s2,-504(s0)
    80005440:	b7b5                	j	800053ac <exec+0x142>
    80005442:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80005444:	8552                	mv	a0,s4
    80005446:	fffff097          	auipc	ra,0xfffff
    8000544a:	b1c080e7          	jalr	-1252(ra) # 80003f62 <iunlockput>
  end_op();
    8000544e:	fffff097          	auipc	ra,0xfffff
    80005452:	2f6080e7          	jalr	758(ra) # 80004744 <end_op>
  p = myproc();
    80005456:	ffffd097          	auipc	ra,0xffffd
    8000545a:	8ae080e7          	jalr	-1874(ra) # 80001d04 <myproc>
    8000545e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005460:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80005464:	6985                	lui	s3,0x1
    80005466:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005468:	99ca                	add	s3,s3,s2
    8000546a:	77fd                	lui	a5,0xfffff
    8000546c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005470:	4691                	li	a3,4
    80005472:	6609                	lui	a2,0x2
    80005474:	964e                	add	a2,a2,s3
    80005476:	85ce                	mv	a1,s3
    80005478:	855a                	mv	a0,s6
    8000547a:	ffffc097          	auipc	ra,0xffffc
    8000547e:	000080e7          	jalr	ra # 8000147a <uvmalloc>
    80005482:	892a                	mv	s2,a0
    80005484:	e0a43423          	sd	a0,-504(s0)
    80005488:	e519                	bnez	a0,80005496 <exec+0x22c>
  if(pagetable)
    8000548a:	e1343423          	sd	s3,-504(s0)
    8000548e:	4a01                	li	s4,0
    80005490:	aaa5                	j	80005608 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005492:	4901                	li	s2,0
    80005494:	bf45                	j	80005444 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005496:	75f9                	lui	a1,0xffffe
    80005498:	95aa                	add	a1,a1,a0
    8000549a:	855a                	mv	a0,s6
    8000549c:	ffffc097          	auipc	ra,0xffffc
    800054a0:	214080e7          	jalr	532(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    800054a4:	7bfd                	lui	s7,0xfffff
    800054a6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800054a8:	e0043783          	ld	a5,-512(s0)
    800054ac:	6388                	ld	a0,0(a5)
    800054ae:	c52d                	beqz	a0,80005518 <exec+0x2ae>
    800054b0:	e9040993          	addi	s3,s0,-368
    800054b4:	f9040c13          	addi	s8,s0,-112
    800054b8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800054ba:	ffffc097          	auipc	ra,0xffffc
    800054be:	9ee080e7          	jalr	-1554(ra) # 80000ea8 <strlen>
    800054c2:	0015079b          	addiw	a5,a0,1
    800054c6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800054ca:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800054ce:	13796863          	bltu	s2,s7,800055fe <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800054d2:	e0043d03          	ld	s10,-512(s0)
    800054d6:	000d3a03          	ld	s4,0(s10)
    800054da:	8552                	mv	a0,s4
    800054dc:	ffffc097          	auipc	ra,0xffffc
    800054e0:	9cc080e7          	jalr	-1588(ra) # 80000ea8 <strlen>
    800054e4:	0015069b          	addiw	a3,a0,1
    800054e8:	8652                	mv	a2,s4
    800054ea:	85ca                	mv	a1,s2
    800054ec:	855a                	mv	a0,s6
    800054ee:	ffffc097          	auipc	ra,0xffffc
    800054f2:	1f4080e7          	jalr	500(ra) # 800016e2 <copyout>
    800054f6:	10054663          	bltz	a0,80005602 <exec+0x398>
    ustack[argc] = sp;
    800054fa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800054fe:	0485                	addi	s1,s1,1
    80005500:	008d0793          	addi	a5,s10,8
    80005504:	e0f43023          	sd	a5,-512(s0)
    80005508:	008d3503          	ld	a0,8(s10)
    8000550c:	c909                	beqz	a0,8000551e <exec+0x2b4>
    if(argc >= MAXARG)
    8000550e:	09a1                	addi	s3,s3,8
    80005510:	fb8995e3          	bne	s3,s8,800054ba <exec+0x250>
  ip = 0;
    80005514:	4a01                	li	s4,0
    80005516:	a8cd                	j	80005608 <exec+0x39e>
  sp = sz;
    80005518:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000551c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000551e:	00349793          	slli	a5,s1,0x3
    80005522:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda410>
    80005526:	97a2                	add	a5,a5,s0
    80005528:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000552c:	00148693          	addi	a3,s1,1
    80005530:	068e                	slli	a3,a3,0x3
    80005532:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005536:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000553a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000553e:	f57966e3          	bltu	s2,s7,8000548a <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005542:	e9040613          	addi	a2,s0,-368
    80005546:	85ca                	mv	a1,s2
    80005548:	855a                	mv	a0,s6
    8000554a:	ffffc097          	auipc	ra,0xffffc
    8000554e:	198080e7          	jalr	408(ra) # 800016e2 <copyout>
    80005552:	0e054863          	bltz	a0,80005642 <exec+0x3d8>
  p->trapframe->a1 = sp;
    80005556:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    8000555a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000555e:	df843783          	ld	a5,-520(s0)
    80005562:	0007c703          	lbu	a4,0(a5)
    80005566:	cf11                	beqz	a4,80005582 <exec+0x318>
    80005568:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000556a:	02f00693          	li	a3,47
    8000556e:	a039                	j	8000557c <exec+0x312>
      last = s+1;
    80005570:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005574:	0785                	addi	a5,a5,1
    80005576:	fff7c703          	lbu	a4,-1(a5)
    8000557a:	c701                	beqz	a4,80005582 <exec+0x318>
    if(*s == '/')
    8000557c:	fed71ce3          	bne	a4,a3,80005574 <exec+0x30a>
    80005580:	bfc5                	j	80005570 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005582:	4641                	li	a2,16
    80005584:	df843583          	ld	a1,-520(s0)
    80005588:	160a8513          	addi	a0,s5,352
    8000558c:	ffffc097          	auipc	ra,0xffffc
    80005590:	8ea080e7          	jalr	-1814(ra) # 80000e76 <safestrcpy>
  oldpagetable = p->pagetable;
    80005594:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80005598:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    8000559c:	e0843783          	ld	a5,-504(s0)
    800055a0:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800055a4:	060ab783          	ld	a5,96(s5)
    800055a8:	e6843703          	ld	a4,-408(s0)
    800055ac:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800055ae:	060ab783          	ld	a5,96(s5)
    800055b2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800055b6:	85e6                	mv	a1,s9
    800055b8:	ffffd097          	auipc	ra,0xffffd
    800055bc:	8ac080e7          	jalr	-1876(ra) # 80001e64 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800055c0:	0004851b          	sext.w	a0,s1
    800055c4:	79be                	ld	s3,488(sp)
    800055c6:	7a1e                	ld	s4,480(sp)
    800055c8:	6afe                	ld	s5,472(sp)
    800055ca:	6b5e                	ld	s6,464(sp)
    800055cc:	6bbe                	ld	s7,456(sp)
    800055ce:	6c1e                	ld	s8,448(sp)
    800055d0:	7cfa                	ld	s9,440(sp)
    800055d2:	7d5a                	ld	s10,432(sp)
    800055d4:	b305                	j	800052f4 <exec+0x8a>
    800055d6:	e1243423          	sd	s2,-504(s0)
    800055da:	7dba                	ld	s11,424(sp)
    800055dc:	a035                	j	80005608 <exec+0x39e>
    800055de:	e1243423          	sd	s2,-504(s0)
    800055e2:	7dba                	ld	s11,424(sp)
    800055e4:	a015                	j	80005608 <exec+0x39e>
    800055e6:	e1243423          	sd	s2,-504(s0)
    800055ea:	7dba                	ld	s11,424(sp)
    800055ec:	a831                	j	80005608 <exec+0x39e>
    800055ee:	e1243423          	sd	s2,-504(s0)
    800055f2:	7dba                	ld	s11,424(sp)
    800055f4:	a811                	j	80005608 <exec+0x39e>
    800055f6:	e1243423          	sd	s2,-504(s0)
    800055fa:	7dba                	ld	s11,424(sp)
    800055fc:	a031                	j	80005608 <exec+0x39e>
  ip = 0;
    800055fe:	4a01                	li	s4,0
    80005600:	a021                	j	80005608 <exec+0x39e>
    80005602:	4a01                	li	s4,0
  if(pagetable)
    80005604:	a011                	j	80005608 <exec+0x39e>
    80005606:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005608:	e0843583          	ld	a1,-504(s0)
    8000560c:	855a                	mv	a0,s6
    8000560e:	ffffd097          	auipc	ra,0xffffd
    80005612:	856080e7          	jalr	-1962(ra) # 80001e64 <proc_freepagetable>
  return -1;
    80005616:	557d                	li	a0,-1
  if(ip){
    80005618:	000a1b63          	bnez	s4,8000562e <exec+0x3c4>
    8000561c:	79be                	ld	s3,488(sp)
    8000561e:	7a1e                	ld	s4,480(sp)
    80005620:	6afe                	ld	s5,472(sp)
    80005622:	6b5e                	ld	s6,464(sp)
    80005624:	6bbe                	ld	s7,456(sp)
    80005626:	6c1e                	ld	s8,448(sp)
    80005628:	7cfa                	ld	s9,440(sp)
    8000562a:	7d5a                	ld	s10,432(sp)
    8000562c:	b1e1                	j	800052f4 <exec+0x8a>
    8000562e:	79be                	ld	s3,488(sp)
    80005630:	6afe                	ld	s5,472(sp)
    80005632:	6b5e                	ld	s6,464(sp)
    80005634:	6bbe                	ld	s7,456(sp)
    80005636:	6c1e                	ld	s8,448(sp)
    80005638:	7cfa                	ld	s9,440(sp)
    8000563a:	7d5a                	ld	s10,432(sp)
    8000563c:	b14d                	j	800052de <exec+0x74>
    8000563e:	6b5e                	ld	s6,464(sp)
    80005640:	b979                	j	800052de <exec+0x74>
  sz = sz1;
    80005642:	e0843983          	ld	s3,-504(s0)
    80005646:	b591                	j	8000548a <exec+0x220>

0000000080005648 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005648:	7179                	addi	sp,sp,-48
    8000564a:	f406                	sd	ra,40(sp)
    8000564c:	f022                	sd	s0,32(sp)
    8000564e:	ec26                	sd	s1,24(sp)
    80005650:	e84a                	sd	s2,16(sp)
    80005652:	1800                	addi	s0,sp,48
    80005654:	892e                	mv	s2,a1
    80005656:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005658:	fdc40593          	addi	a1,s0,-36
    8000565c:	ffffe097          	auipc	ra,0xffffe
    80005660:	a50080e7          	jalr	-1456(ra) # 800030ac <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005664:	fdc42703          	lw	a4,-36(s0)
    80005668:	47bd                	li	a5,15
    8000566a:	02e7eb63          	bltu	a5,a4,800056a0 <argfd+0x58>
    8000566e:	ffffc097          	auipc	ra,0xffffc
    80005672:	696080e7          	jalr	1686(ra) # 80001d04 <myproc>
    80005676:	fdc42703          	lw	a4,-36(s0)
    8000567a:	01a70793          	addi	a5,a4,26
    8000567e:	078e                	slli	a5,a5,0x3
    80005680:	953e                	add	a0,a0,a5
    80005682:	651c                	ld	a5,8(a0)
    80005684:	c385                	beqz	a5,800056a4 <argfd+0x5c>
    return -1;
  if(pfd)
    80005686:	00090463          	beqz	s2,8000568e <argfd+0x46>
    *pfd = fd;
    8000568a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000568e:	4501                	li	a0,0
  if(pf)
    80005690:	c091                	beqz	s1,80005694 <argfd+0x4c>
    *pf = f;
    80005692:	e09c                	sd	a5,0(s1)
}
    80005694:	70a2                	ld	ra,40(sp)
    80005696:	7402                	ld	s0,32(sp)
    80005698:	64e2                	ld	s1,24(sp)
    8000569a:	6942                	ld	s2,16(sp)
    8000569c:	6145                	addi	sp,sp,48
    8000569e:	8082                	ret
    return -1;
    800056a0:	557d                	li	a0,-1
    800056a2:	bfcd                	j	80005694 <argfd+0x4c>
    800056a4:	557d                	li	a0,-1
    800056a6:	b7fd                	j	80005694 <argfd+0x4c>

00000000800056a8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800056a8:	1101                	addi	sp,sp,-32
    800056aa:	ec06                	sd	ra,24(sp)
    800056ac:	e822                	sd	s0,16(sp)
    800056ae:	e426                	sd	s1,8(sp)
    800056b0:	1000                	addi	s0,sp,32
    800056b2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800056b4:	ffffc097          	auipc	ra,0xffffc
    800056b8:	650080e7          	jalr	1616(ra) # 80001d04 <myproc>
    800056bc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800056be:	0d850793          	addi	a5,a0,216
    800056c2:	4501                	li	a0,0
    800056c4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800056c6:	6398                	ld	a4,0(a5)
    800056c8:	cb19                	beqz	a4,800056de <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800056ca:	2505                	addiw	a0,a0,1
    800056cc:	07a1                	addi	a5,a5,8
    800056ce:	fed51ce3          	bne	a0,a3,800056c6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800056d2:	557d                	li	a0,-1
}
    800056d4:	60e2                	ld	ra,24(sp)
    800056d6:	6442                	ld	s0,16(sp)
    800056d8:	64a2                	ld	s1,8(sp)
    800056da:	6105                	addi	sp,sp,32
    800056dc:	8082                	ret
      p->ofile[fd] = f;
    800056de:	01a50793          	addi	a5,a0,26
    800056e2:	078e                	slli	a5,a5,0x3
    800056e4:	963e                	add	a2,a2,a5
    800056e6:	e604                	sd	s1,8(a2)
      return fd;
    800056e8:	b7f5                	j	800056d4 <fdalloc+0x2c>

00000000800056ea <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800056ea:	715d                	addi	sp,sp,-80
    800056ec:	e486                	sd	ra,72(sp)
    800056ee:	e0a2                	sd	s0,64(sp)
    800056f0:	fc26                	sd	s1,56(sp)
    800056f2:	f84a                	sd	s2,48(sp)
    800056f4:	f44e                	sd	s3,40(sp)
    800056f6:	ec56                	sd	s5,24(sp)
    800056f8:	e85a                	sd	s6,16(sp)
    800056fa:	0880                	addi	s0,sp,80
    800056fc:	8b2e                	mv	s6,a1
    800056fe:	89b2                	mv	s3,a2
    80005700:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005702:	fb040593          	addi	a1,s0,-80
    80005706:	fffff097          	auipc	ra,0xfffff
    8000570a:	de2080e7          	jalr	-542(ra) # 800044e8 <nameiparent>
    8000570e:	84aa                	mv	s1,a0
    80005710:	14050e63          	beqz	a0,8000586c <create+0x182>
    return 0;

  ilock(dp);
    80005714:	ffffe097          	auipc	ra,0xffffe
    80005718:	5e8080e7          	jalr	1512(ra) # 80003cfc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000571c:	4601                	li	a2,0
    8000571e:	fb040593          	addi	a1,s0,-80
    80005722:	8526                	mv	a0,s1
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	ae4080e7          	jalr	-1308(ra) # 80004208 <dirlookup>
    8000572c:	8aaa                	mv	s5,a0
    8000572e:	c539                	beqz	a0,8000577c <create+0x92>
    iunlockput(dp);
    80005730:	8526                	mv	a0,s1
    80005732:	fffff097          	auipc	ra,0xfffff
    80005736:	830080e7          	jalr	-2000(ra) # 80003f62 <iunlockput>
    ilock(ip);
    8000573a:	8556                	mv	a0,s5
    8000573c:	ffffe097          	auipc	ra,0xffffe
    80005740:	5c0080e7          	jalr	1472(ra) # 80003cfc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005744:	4789                	li	a5,2
    80005746:	02fb1463          	bne	s6,a5,8000576e <create+0x84>
    8000574a:	044ad783          	lhu	a5,68(s5)
    8000574e:	37f9                	addiw	a5,a5,-2
    80005750:	17c2                	slli	a5,a5,0x30
    80005752:	93c1                	srli	a5,a5,0x30
    80005754:	4705                	li	a4,1
    80005756:	00f76c63          	bltu	a4,a5,8000576e <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000575a:	8556                	mv	a0,s5
    8000575c:	60a6                	ld	ra,72(sp)
    8000575e:	6406                	ld	s0,64(sp)
    80005760:	74e2                	ld	s1,56(sp)
    80005762:	7942                	ld	s2,48(sp)
    80005764:	79a2                	ld	s3,40(sp)
    80005766:	6ae2                	ld	s5,24(sp)
    80005768:	6b42                	ld	s6,16(sp)
    8000576a:	6161                	addi	sp,sp,80
    8000576c:	8082                	ret
    iunlockput(ip);
    8000576e:	8556                	mv	a0,s5
    80005770:	ffffe097          	auipc	ra,0xffffe
    80005774:	7f2080e7          	jalr	2034(ra) # 80003f62 <iunlockput>
    return 0;
    80005778:	4a81                	li	s5,0
    8000577a:	b7c5                	j	8000575a <create+0x70>
    8000577c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000577e:	85da                	mv	a1,s6
    80005780:	4088                	lw	a0,0(s1)
    80005782:	ffffe097          	auipc	ra,0xffffe
    80005786:	3d6080e7          	jalr	982(ra) # 80003b58 <ialloc>
    8000578a:	8a2a                	mv	s4,a0
    8000578c:	c531                	beqz	a0,800057d8 <create+0xee>
  ilock(ip);
    8000578e:	ffffe097          	auipc	ra,0xffffe
    80005792:	56e080e7          	jalr	1390(ra) # 80003cfc <ilock>
  ip->major = major;
    80005796:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000579a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000579e:	4905                	li	s2,1
    800057a0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800057a4:	8552                	mv	a0,s4
    800057a6:	ffffe097          	auipc	ra,0xffffe
    800057aa:	48a080e7          	jalr	1162(ra) # 80003c30 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800057ae:	032b0d63          	beq	s6,s2,800057e8 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800057b2:	004a2603          	lw	a2,4(s4)
    800057b6:	fb040593          	addi	a1,s0,-80
    800057ba:	8526                	mv	a0,s1
    800057bc:	fffff097          	auipc	ra,0xfffff
    800057c0:	c5c080e7          	jalr	-932(ra) # 80004418 <dirlink>
    800057c4:	08054163          	bltz	a0,80005846 <create+0x15c>
  iunlockput(dp);
    800057c8:	8526                	mv	a0,s1
    800057ca:	ffffe097          	auipc	ra,0xffffe
    800057ce:	798080e7          	jalr	1944(ra) # 80003f62 <iunlockput>
  return ip;
    800057d2:	8ad2                	mv	s5,s4
    800057d4:	7a02                	ld	s4,32(sp)
    800057d6:	b751                	j	8000575a <create+0x70>
    iunlockput(dp);
    800057d8:	8526                	mv	a0,s1
    800057da:	ffffe097          	auipc	ra,0xffffe
    800057de:	788080e7          	jalr	1928(ra) # 80003f62 <iunlockput>
    return 0;
    800057e2:	8ad2                	mv	s5,s4
    800057e4:	7a02                	ld	s4,32(sp)
    800057e6:	bf95                	j	8000575a <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800057e8:	004a2603          	lw	a2,4(s4)
    800057ec:	00003597          	auipc	a1,0x3
    800057f0:	ed458593          	addi	a1,a1,-300 # 800086c0 <etext+0x6c0>
    800057f4:	8552                	mv	a0,s4
    800057f6:	fffff097          	auipc	ra,0xfffff
    800057fa:	c22080e7          	jalr	-990(ra) # 80004418 <dirlink>
    800057fe:	04054463          	bltz	a0,80005846 <create+0x15c>
    80005802:	40d0                	lw	a2,4(s1)
    80005804:	00003597          	auipc	a1,0x3
    80005808:	ec458593          	addi	a1,a1,-316 # 800086c8 <etext+0x6c8>
    8000580c:	8552                	mv	a0,s4
    8000580e:	fffff097          	auipc	ra,0xfffff
    80005812:	c0a080e7          	jalr	-1014(ra) # 80004418 <dirlink>
    80005816:	02054863          	bltz	a0,80005846 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000581a:	004a2603          	lw	a2,4(s4)
    8000581e:	fb040593          	addi	a1,s0,-80
    80005822:	8526                	mv	a0,s1
    80005824:	fffff097          	auipc	ra,0xfffff
    80005828:	bf4080e7          	jalr	-1036(ra) # 80004418 <dirlink>
    8000582c:	00054d63          	bltz	a0,80005846 <create+0x15c>
    dp->nlink++;  // for ".."
    80005830:	04a4d783          	lhu	a5,74(s1)
    80005834:	2785                	addiw	a5,a5,1
    80005836:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000583a:	8526                	mv	a0,s1
    8000583c:	ffffe097          	auipc	ra,0xffffe
    80005840:	3f4080e7          	jalr	1012(ra) # 80003c30 <iupdate>
    80005844:	b751                	j	800057c8 <create+0xde>
  ip->nlink = 0;
    80005846:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000584a:	8552                	mv	a0,s4
    8000584c:	ffffe097          	auipc	ra,0xffffe
    80005850:	3e4080e7          	jalr	996(ra) # 80003c30 <iupdate>
  iunlockput(ip);
    80005854:	8552                	mv	a0,s4
    80005856:	ffffe097          	auipc	ra,0xffffe
    8000585a:	70c080e7          	jalr	1804(ra) # 80003f62 <iunlockput>
  iunlockput(dp);
    8000585e:	8526                	mv	a0,s1
    80005860:	ffffe097          	auipc	ra,0xffffe
    80005864:	702080e7          	jalr	1794(ra) # 80003f62 <iunlockput>
  return 0;
    80005868:	7a02                	ld	s4,32(sp)
    8000586a:	bdc5                	j	8000575a <create+0x70>
    return 0;
    8000586c:	8aaa                	mv	s5,a0
    8000586e:	b5f5                	j	8000575a <create+0x70>

0000000080005870 <sys_dup>:
{
    80005870:	7179                	addi	sp,sp,-48
    80005872:	f406                	sd	ra,40(sp)
    80005874:	f022                	sd	s0,32(sp)
    80005876:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005878:	fd840613          	addi	a2,s0,-40
    8000587c:	4581                	li	a1,0
    8000587e:	4501                	li	a0,0
    80005880:	00000097          	auipc	ra,0x0
    80005884:	dc8080e7          	jalr	-568(ra) # 80005648 <argfd>
    return -1;
    80005888:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000588a:	02054763          	bltz	a0,800058b8 <sys_dup+0x48>
    8000588e:	ec26                	sd	s1,24(sp)
    80005890:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005892:	fd843903          	ld	s2,-40(s0)
    80005896:	854a                	mv	a0,s2
    80005898:	00000097          	auipc	ra,0x0
    8000589c:	e10080e7          	jalr	-496(ra) # 800056a8 <fdalloc>
    800058a0:	84aa                	mv	s1,a0
    return -1;
    800058a2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800058a4:	00054f63          	bltz	a0,800058c2 <sys_dup+0x52>
  filedup(f);
    800058a8:	854a                	mv	a0,s2
    800058aa:	fffff097          	auipc	ra,0xfffff
    800058ae:	298080e7          	jalr	664(ra) # 80004b42 <filedup>
  return fd;
    800058b2:	87a6                	mv	a5,s1
    800058b4:	64e2                	ld	s1,24(sp)
    800058b6:	6942                	ld	s2,16(sp)
}
    800058b8:	853e                	mv	a0,a5
    800058ba:	70a2                	ld	ra,40(sp)
    800058bc:	7402                	ld	s0,32(sp)
    800058be:	6145                	addi	sp,sp,48
    800058c0:	8082                	ret
    800058c2:	64e2                	ld	s1,24(sp)
    800058c4:	6942                	ld	s2,16(sp)
    800058c6:	bfcd                	j	800058b8 <sys_dup+0x48>

00000000800058c8 <sys_read>:
{
    800058c8:	7179                	addi	sp,sp,-48
    800058ca:	f406                	sd	ra,40(sp)
    800058cc:	f022                	sd	s0,32(sp)
    800058ce:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800058d0:	fd840593          	addi	a1,s0,-40
    800058d4:	4505                	li	a0,1
    800058d6:	ffffd097          	auipc	ra,0xffffd
    800058da:	7f6080e7          	jalr	2038(ra) # 800030cc <argaddr>
  argint(2, &n);
    800058de:	fe440593          	addi	a1,s0,-28
    800058e2:	4509                	li	a0,2
    800058e4:	ffffd097          	auipc	ra,0xffffd
    800058e8:	7c8080e7          	jalr	1992(ra) # 800030ac <argint>
  if(argfd(0, 0, &f) < 0)
    800058ec:	fe840613          	addi	a2,s0,-24
    800058f0:	4581                	li	a1,0
    800058f2:	4501                	li	a0,0
    800058f4:	00000097          	auipc	ra,0x0
    800058f8:	d54080e7          	jalr	-684(ra) # 80005648 <argfd>
    800058fc:	87aa                	mv	a5,a0
    return -1;
    800058fe:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005900:	0007cc63          	bltz	a5,80005918 <sys_read+0x50>
  return fileread(f, p, n);
    80005904:	fe442603          	lw	a2,-28(s0)
    80005908:	fd843583          	ld	a1,-40(s0)
    8000590c:	fe843503          	ld	a0,-24(s0)
    80005910:	fffff097          	auipc	ra,0xfffff
    80005914:	3d8080e7          	jalr	984(ra) # 80004ce8 <fileread>
}
    80005918:	70a2                	ld	ra,40(sp)
    8000591a:	7402                	ld	s0,32(sp)
    8000591c:	6145                	addi	sp,sp,48
    8000591e:	8082                	ret

0000000080005920 <sys_write>:
{
    80005920:	7179                	addi	sp,sp,-48
    80005922:	f406                	sd	ra,40(sp)
    80005924:	f022                	sd	s0,32(sp)
    80005926:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005928:	fd840593          	addi	a1,s0,-40
    8000592c:	4505                	li	a0,1
    8000592e:	ffffd097          	auipc	ra,0xffffd
    80005932:	79e080e7          	jalr	1950(ra) # 800030cc <argaddr>
  argint(2, &n);
    80005936:	fe440593          	addi	a1,s0,-28
    8000593a:	4509                	li	a0,2
    8000593c:	ffffd097          	auipc	ra,0xffffd
    80005940:	770080e7          	jalr	1904(ra) # 800030ac <argint>
  if(argfd(0, 0, &f) < 0)
    80005944:	fe840613          	addi	a2,s0,-24
    80005948:	4581                	li	a1,0
    8000594a:	4501                	li	a0,0
    8000594c:	00000097          	auipc	ra,0x0
    80005950:	cfc080e7          	jalr	-772(ra) # 80005648 <argfd>
    80005954:	87aa                	mv	a5,a0
    return -1;
    80005956:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005958:	0007cc63          	bltz	a5,80005970 <sys_write+0x50>
  return filewrite(f, p, n);
    8000595c:	fe442603          	lw	a2,-28(s0)
    80005960:	fd843583          	ld	a1,-40(s0)
    80005964:	fe843503          	ld	a0,-24(s0)
    80005968:	fffff097          	auipc	ra,0xfffff
    8000596c:	452080e7          	jalr	1106(ra) # 80004dba <filewrite>
}
    80005970:	70a2                	ld	ra,40(sp)
    80005972:	7402                	ld	s0,32(sp)
    80005974:	6145                	addi	sp,sp,48
    80005976:	8082                	ret

0000000080005978 <sys_close>:
{
    80005978:	1101                	addi	sp,sp,-32
    8000597a:	ec06                	sd	ra,24(sp)
    8000597c:	e822                	sd	s0,16(sp)
    8000597e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005980:	fe040613          	addi	a2,s0,-32
    80005984:	fec40593          	addi	a1,s0,-20
    80005988:	4501                	li	a0,0
    8000598a:	00000097          	auipc	ra,0x0
    8000598e:	cbe080e7          	jalr	-834(ra) # 80005648 <argfd>
    return -1;
    80005992:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005994:	02054463          	bltz	a0,800059bc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005998:	ffffc097          	auipc	ra,0xffffc
    8000599c:	36c080e7          	jalr	876(ra) # 80001d04 <myproc>
    800059a0:	fec42783          	lw	a5,-20(s0)
    800059a4:	07e9                	addi	a5,a5,26
    800059a6:	078e                	slli	a5,a5,0x3
    800059a8:	953e                	add	a0,a0,a5
    800059aa:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800059ae:	fe043503          	ld	a0,-32(s0)
    800059b2:	fffff097          	auipc	ra,0xfffff
    800059b6:	1e2080e7          	jalr	482(ra) # 80004b94 <fileclose>
  return 0;
    800059ba:	4781                	li	a5,0
}
    800059bc:	853e                	mv	a0,a5
    800059be:	60e2                	ld	ra,24(sp)
    800059c0:	6442                	ld	s0,16(sp)
    800059c2:	6105                	addi	sp,sp,32
    800059c4:	8082                	ret

00000000800059c6 <sys_fstat>:
{
    800059c6:	1101                	addi	sp,sp,-32
    800059c8:	ec06                	sd	ra,24(sp)
    800059ca:	e822                	sd	s0,16(sp)
    800059cc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800059ce:	fe040593          	addi	a1,s0,-32
    800059d2:	4505                	li	a0,1
    800059d4:	ffffd097          	auipc	ra,0xffffd
    800059d8:	6f8080e7          	jalr	1784(ra) # 800030cc <argaddr>
  if(argfd(0, 0, &f) < 0)
    800059dc:	fe840613          	addi	a2,s0,-24
    800059e0:	4581                	li	a1,0
    800059e2:	4501                	li	a0,0
    800059e4:	00000097          	auipc	ra,0x0
    800059e8:	c64080e7          	jalr	-924(ra) # 80005648 <argfd>
    800059ec:	87aa                	mv	a5,a0
    return -1;
    800059ee:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800059f0:	0007ca63          	bltz	a5,80005a04 <sys_fstat+0x3e>
  return filestat(f, st);
    800059f4:	fe043583          	ld	a1,-32(s0)
    800059f8:	fe843503          	ld	a0,-24(s0)
    800059fc:	fffff097          	auipc	ra,0xfffff
    80005a00:	27a080e7          	jalr	634(ra) # 80004c76 <filestat>
}
    80005a04:	60e2                	ld	ra,24(sp)
    80005a06:	6442                	ld	s0,16(sp)
    80005a08:	6105                	addi	sp,sp,32
    80005a0a:	8082                	ret

0000000080005a0c <sys_link>:
{
    80005a0c:	7169                	addi	sp,sp,-304
    80005a0e:	f606                	sd	ra,296(sp)
    80005a10:	f222                	sd	s0,288(sp)
    80005a12:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a14:	08000613          	li	a2,128
    80005a18:	ed040593          	addi	a1,s0,-304
    80005a1c:	4501                	li	a0,0
    80005a1e:	ffffd097          	auipc	ra,0xffffd
    80005a22:	6ce080e7          	jalr	1742(ra) # 800030ec <argstr>
    return -1;
    80005a26:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a28:	12054663          	bltz	a0,80005b54 <sys_link+0x148>
    80005a2c:	08000613          	li	a2,128
    80005a30:	f5040593          	addi	a1,s0,-176
    80005a34:	4505                	li	a0,1
    80005a36:	ffffd097          	auipc	ra,0xffffd
    80005a3a:	6b6080e7          	jalr	1718(ra) # 800030ec <argstr>
    return -1;
    80005a3e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a40:	10054a63          	bltz	a0,80005b54 <sys_link+0x148>
    80005a44:	ee26                	sd	s1,280(sp)
  begin_op();
    80005a46:	fffff097          	auipc	ra,0xfffff
    80005a4a:	c84080e7          	jalr	-892(ra) # 800046ca <begin_op>
  if((ip = namei(old)) == 0){
    80005a4e:	ed040513          	addi	a0,s0,-304
    80005a52:	fffff097          	auipc	ra,0xfffff
    80005a56:	a78080e7          	jalr	-1416(ra) # 800044ca <namei>
    80005a5a:	84aa                	mv	s1,a0
    80005a5c:	c949                	beqz	a0,80005aee <sys_link+0xe2>
  ilock(ip);
    80005a5e:	ffffe097          	auipc	ra,0xffffe
    80005a62:	29e080e7          	jalr	670(ra) # 80003cfc <ilock>
  if(ip->type == T_DIR){
    80005a66:	04449703          	lh	a4,68(s1)
    80005a6a:	4785                	li	a5,1
    80005a6c:	08f70863          	beq	a4,a5,80005afc <sys_link+0xf0>
    80005a70:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005a72:	04a4d783          	lhu	a5,74(s1)
    80005a76:	2785                	addiw	a5,a5,1
    80005a78:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a7c:	8526                	mv	a0,s1
    80005a7e:	ffffe097          	auipc	ra,0xffffe
    80005a82:	1b2080e7          	jalr	434(ra) # 80003c30 <iupdate>
  iunlock(ip);
    80005a86:	8526                	mv	a0,s1
    80005a88:	ffffe097          	auipc	ra,0xffffe
    80005a8c:	33a080e7          	jalr	826(ra) # 80003dc2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005a90:	fd040593          	addi	a1,s0,-48
    80005a94:	f5040513          	addi	a0,s0,-176
    80005a98:	fffff097          	auipc	ra,0xfffff
    80005a9c:	a50080e7          	jalr	-1456(ra) # 800044e8 <nameiparent>
    80005aa0:	892a                	mv	s2,a0
    80005aa2:	cd35                	beqz	a0,80005b1e <sys_link+0x112>
  ilock(dp);
    80005aa4:	ffffe097          	auipc	ra,0xffffe
    80005aa8:	258080e7          	jalr	600(ra) # 80003cfc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005aac:	00092703          	lw	a4,0(s2)
    80005ab0:	409c                	lw	a5,0(s1)
    80005ab2:	06f71163          	bne	a4,a5,80005b14 <sys_link+0x108>
    80005ab6:	40d0                	lw	a2,4(s1)
    80005ab8:	fd040593          	addi	a1,s0,-48
    80005abc:	854a                	mv	a0,s2
    80005abe:	fffff097          	auipc	ra,0xfffff
    80005ac2:	95a080e7          	jalr	-1702(ra) # 80004418 <dirlink>
    80005ac6:	04054763          	bltz	a0,80005b14 <sys_link+0x108>
  iunlockput(dp);
    80005aca:	854a                	mv	a0,s2
    80005acc:	ffffe097          	auipc	ra,0xffffe
    80005ad0:	496080e7          	jalr	1174(ra) # 80003f62 <iunlockput>
  iput(ip);
    80005ad4:	8526                	mv	a0,s1
    80005ad6:	ffffe097          	auipc	ra,0xffffe
    80005ada:	3e4080e7          	jalr	996(ra) # 80003eba <iput>
  end_op();
    80005ade:	fffff097          	auipc	ra,0xfffff
    80005ae2:	c66080e7          	jalr	-922(ra) # 80004744 <end_op>
  return 0;
    80005ae6:	4781                	li	a5,0
    80005ae8:	64f2                	ld	s1,280(sp)
    80005aea:	6952                	ld	s2,272(sp)
    80005aec:	a0a5                	j	80005b54 <sys_link+0x148>
    end_op();
    80005aee:	fffff097          	auipc	ra,0xfffff
    80005af2:	c56080e7          	jalr	-938(ra) # 80004744 <end_op>
    return -1;
    80005af6:	57fd                	li	a5,-1
    80005af8:	64f2                	ld	s1,280(sp)
    80005afa:	a8a9                	j	80005b54 <sys_link+0x148>
    iunlockput(ip);
    80005afc:	8526                	mv	a0,s1
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	464080e7          	jalr	1124(ra) # 80003f62 <iunlockput>
    end_op();
    80005b06:	fffff097          	auipc	ra,0xfffff
    80005b0a:	c3e080e7          	jalr	-962(ra) # 80004744 <end_op>
    return -1;
    80005b0e:	57fd                	li	a5,-1
    80005b10:	64f2                	ld	s1,280(sp)
    80005b12:	a089                	j	80005b54 <sys_link+0x148>
    iunlockput(dp);
    80005b14:	854a                	mv	a0,s2
    80005b16:	ffffe097          	auipc	ra,0xffffe
    80005b1a:	44c080e7          	jalr	1100(ra) # 80003f62 <iunlockput>
  ilock(ip);
    80005b1e:	8526                	mv	a0,s1
    80005b20:	ffffe097          	auipc	ra,0xffffe
    80005b24:	1dc080e7          	jalr	476(ra) # 80003cfc <ilock>
  ip->nlink--;
    80005b28:	04a4d783          	lhu	a5,74(s1)
    80005b2c:	37fd                	addiw	a5,a5,-1
    80005b2e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b32:	8526                	mv	a0,s1
    80005b34:	ffffe097          	auipc	ra,0xffffe
    80005b38:	0fc080e7          	jalr	252(ra) # 80003c30 <iupdate>
  iunlockput(ip);
    80005b3c:	8526                	mv	a0,s1
    80005b3e:	ffffe097          	auipc	ra,0xffffe
    80005b42:	424080e7          	jalr	1060(ra) # 80003f62 <iunlockput>
  end_op();
    80005b46:	fffff097          	auipc	ra,0xfffff
    80005b4a:	bfe080e7          	jalr	-1026(ra) # 80004744 <end_op>
  return -1;
    80005b4e:	57fd                	li	a5,-1
    80005b50:	64f2                	ld	s1,280(sp)
    80005b52:	6952                	ld	s2,272(sp)
}
    80005b54:	853e                	mv	a0,a5
    80005b56:	70b2                	ld	ra,296(sp)
    80005b58:	7412                	ld	s0,288(sp)
    80005b5a:	6155                	addi	sp,sp,304
    80005b5c:	8082                	ret

0000000080005b5e <sys_unlink>:
{
    80005b5e:	7151                	addi	sp,sp,-240
    80005b60:	f586                	sd	ra,232(sp)
    80005b62:	f1a2                	sd	s0,224(sp)
    80005b64:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005b66:	08000613          	li	a2,128
    80005b6a:	f3040593          	addi	a1,s0,-208
    80005b6e:	4501                	li	a0,0
    80005b70:	ffffd097          	auipc	ra,0xffffd
    80005b74:	57c080e7          	jalr	1404(ra) # 800030ec <argstr>
    80005b78:	1a054a63          	bltz	a0,80005d2c <sys_unlink+0x1ce>
    80005b7c:	eda6                	sd	s1,216(sp)
  begin_op();
    80005b7e:	fffff097          	auipc	ra,0xfffff
    80005b82:	b4c080e7          	jalr	-1204(ra) # 800046ca <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b86:	fb040593          	addi	a1,s0,-80
    80005b8a:	f3040513          	addi	a0,s0,-208
    80005b8e:	fffff097          	auipc	ra,0xfffff
    80005b92:	95a080e7          	jalr	-1702(ra) # 800044e8 <nameiparent>
    80005b96:	84aa                	mv	s1,a0
    80005b98:	cd71                	beqz	a0,80005c74 <sys_unlink+0x116>
  ilock(dp);
    80005b9a:	ffffe097          	auipc	ra,0xffffe
    80005b9e:	162080e7          	jalr	354(ra) # 80003cfc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005ba2:	00003597          	auipc	a1,0x3
    80005ba6:	b1e58593          	addi	a1,a1,-1250 # 800086c0 <etext+0x6c0>
    80005baa:	fb040513          	addi	a0,s0,-80
    80005bae:	ffffe097          	auipc	ra,0xffffe
    80005bb2:	640080e7          	jalr	1600(ra) # 800041ee <namecmp>
    80005bb6:	14050c63          	beqz	a0,80005d0e <sys_unlink+0x1b0>
    80005bba:	00003597          	auipc	a1,0x3
    80005bbe:	b0e58593          	addi	a1,a1,-1266 # 800086c8 <etext+0x6c8>
    80005bc2:	fb040513          	addi	a0,s0,-80
    80005bc6:	ffffe097          	auipc	ra,0xffffe
    80005bca:	628080e7          	jalr	1576(ra) # 800041ee <namecmp>
    80005bce:	14050063          	beqz	a0,80005d0e <sys_unlink+0x1b0>
    80005bd2:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005bd4:	f2c40613          	addi	a2,s0,-212
    80005bd8:	fb040593          	addi	a1,s0,-80
    80005bdc:	8526                	mv	a0,s1
    80005bde:	ffffe097          	auipc	ra,0xffffe
    80005be2:	62a080e7          	jalr	1578(ra) # 80004208 <dirlookup>
    80005be6:	892a                	mv	s2,a0
    80005be8:	12050263          	beqz	a0,80005d0c <sys_unlink+0x1ae>
  ilock(ip);
    80005bec:	ffffe097          	auipc	ra,0xffffe
    80005bf0:	110080e7          	jalr	272(ra) # 80003cfc <ilock>
  if(ip->nlink < 1)
    80005bf4:	04a91783          	lh	a5,74(s2)
    80005bf8:	08f05563          	blez	a5,80005c82 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005bfc:	04491703          	lh	a4,68(s2)
    80005c00:	4785                	li	a5,1
    80005c02:	08f70963          	beq	a4,a5,80005c94 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005c06:	4641                	li	a2,16
    80005c08:	4581                	li	a1,0
    80005c0a:	fc040513          	addi	a0,s0,-64
    80005c0e:	ffffb097          	auipc	ra,0xffffb
    80005c12:	126080e7          	jalr	294(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c16:	4741                	li	a4,16
    80005c18:	f2c42683          	lw	a3,-212(s0)
    80005c1c:	fc040613          	addi	a2,s0,-64
    80005c20:	4581                	li	a1,0
    80005c22:	8526                	mv	a0,s1
    80005c24:	ffffe097          	auipc	ra,0xffffe
    80005c28:	4a0080e7          	jalr	1184(ra) # 800040c4 <writei>
    80005c2c:	47c1                	li	a5,16
    80005c2e:	0af51b63          	bne	a0,a5,80005ce4 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005c32:	04491703          	lh	a4,68(s2)
    80005c36:	4785                	li	a5,1
    80005c38:	0af70f63          	beq	a4,a5,80005cf6 <sys_unlink+0x198>
  iunlockput(dp);
    80005c3c:	8526                	mv	a0,s1
    80005c3e:	ffffe097          	auipc	ra,0xffffe
    80005c42:	324080e7          	jalr	804(ra) # 80003f62 <iunlockput>
  ip->nlink--;
    80005c46:	04a95783          	lhu	a5,74(s2)
    80005c4a:	37fd                	addiw	a5,a5,-1
    80005c4c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c50:	854a                	mv	a0,s2
    80005c52:	ffffe097          	auipc	ra,0xffffe
    80005c56:	fde080e7          	jalr	-34(ra) # 80003c30 <iupdate>
  iunlockput(ip);
    80005c5a:	854a                	mv	a0,s2
    80005c5c:	ffffe097          	auipc	ra,0xffffe
    80005c60:	306080e7          	jalr	774(ra) # 80003f62 <iunlockput>
  end_op();
    80005c64:	fffff097          	auipc	ra,0xfffff
    80005c68:	ae0080e7          	jalr	-1312(ra) # 80004744 <end_op>
  return 0;
    80005c6c:	4501                	li	a0,0
    80005c6e:	64ee                	ld	s1,216(sp)
    80005c70:	694e                	ld	s2,208(sp)
    80005c72:	a84d                	j	80005d24 <sys_unlink+0x1c6>
    end_op();
    80005c74:	fffff097          	auipc	ra,0xfffff
    80005c78:	ad0080e7          	jalr	-1328(ra) # 80004744 <end_op>
    return -1;
    80005c7c:	557d                	li	a0,-1
    80005c7e:	64ee                	ld	s1,216(sp)
    80005c80:	a055                	j	80005d24 <sys_unlink+0x1c6>
    80005c82:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005c84:	00003517          	auipc	a0,0x3
    80005c88:	a4c50513          	addi	a0,a0,-1460 # 800086d0 <etext+0x6d0>
    80005c8c:	ffffb097          	auipc	ra,0xffffb
    80005c90:	8d4080e7          	jalr	-1836(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c94:	04c92703          	lw	a4,76(s2)
    80005c98:	02000793          	li	a5,32
    80005c9c:	f6e7f5e3          	bgeu	a5,a4,80005c06 <sys_unlink+0xa8>
    80005ca0:	e5ce                	sd	s3,200(sp)
    80005ca2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ca6:	4741                	li	a4,16
    80005ca8:	86ce                	mv	a3,s3
    80005caa:	f1840613          	addi	a2,s0,-232
    80005cae:	4581                	li	a1,0
    80005cb0:	854a                	mv	a0,s2
    80005cb2:	ffffe097          	auipc	ra,0xffffe
    80005cb6:	302080e7          	jalr	770(ra) # 80003fb4 <readi>
    80005cba:	47c1                	li	a5,16
    80005cbc:	00f51c63          	bne	a0,a5,80005cd4 <sys_unlink+0x176>
    if(de.inum != 0)
    80005cc0:	f1845783          	lhu	a5,-232(s0)
    80005cc4:	e7b5                	bnez	a5,80005d30 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005cc6:	29c1                	addiw	s3,s3,16
    80005cc8:	04c92783          	lw	a5,76(s2)
    80005ccc:	fcf9ede3          	bltu	s3,a5,80005ca6 <sys_unlink+0x148>
    80005cd0:	69ae                	ld	s3,200(sp)
    80005cd2:	bf15                	j	80005c06 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005cd4:	00003517          	auipc	a0,0x3
    80005cd8:	a1450513          	addi	a0,a0,-1516 # 800086e8 <etext+0x6e8>
    80005cdc:	ffffb097          	auipc	ra,0xffffb
    80005ce0:	884080e7          	jalr	-1916(ra) # 80000560 <panic>
    80005ce4:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005ce6:	00003517          	auipc	a0,0x3
    80005cea:	a1a50513          	addi	a0,a0,-1510 # 80008700 <etext+0x700>
    80005cee:	ffffb097          	auipc	ra,0xffffb
    80005cf2:	872080e7          	jalr	-1934(ra) # 80000560 <panic>
    dp->nlink--;
    80005cf6:	04a4d783          	lhu	a5,74(s1)
    80005cfa:	37fd                	addiw	a5,a5,-1
    80005cfc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005d00:	8526                	mv	a0,s1
    80005d02:	ffffe097          	auipc	ra,0xffffe
    80005d06:	f2e080e7          	jalr	-210(ra) # 80003c30 <iupdate>
    80005d0a:	bf0d                	j	80005c3c <sys_unlink+0xde>
    80005d0c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005d0e:	8526                	mv	a0,s1
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	252080e7          	jalr	594(ra) # 80003f62 <iunlockput>
  end_op();
    80005d18:	fffff097          	auipc	ra,0xfffff
    80005d1c:	a2c080e7          	jalr	-1492(ra) # 80004744 <end_op>
  return -1;
    80005d20:	557d                	li	a0,-1
    80005d22:	64ee                	ld	s1,216(sp)
}
    80005d24:	70ae                	ld	ra,232(sp)
    80005d26:	740e                	ld	s0,224(sp)
    80005d28:	616d                	addi	sp,sp,240
    80005d2a:	8082                	ret
    return -1;
    80005d2c:	557d                	li	a0,-1
    80005d2e:	bfdd                	j	80005d24 <sys_unlink+0x1c6>
    iunlockput(ip);
    80005d30:	854a                	mv	a0,s2
    80005d32:	ffffe097          	auipc	ra,0xffffe
    80005d36:	230080e7          	jalr	560(ra) # 80003f62 <iunlockput>
    goto bad;
    80005d3a:	694e                	ld	s2,208(sp)
    80005d3c:	69ae                	ld	s3,200(sp)
    80005d3e:	bfc1                	j	80005d0e <sys_unlink+0x1b0>

0000000080005d40 <sys_open>:

uint64
sys_open(void)
{
    80005d40:	7131                	addi	sp,sp,-192
    80005d42:	fd06                	sd	ra,184(sp)
    80005d44:	f922                	sd	s0,176(sp)
    80005d46:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d48:	f4c40593          	addi	a1,s0,-180
    80005d4c:	4505                	li	a0,1
    80005d4e:	ffffd097          	auipc	ra,0xffffd
    80005d52:	35e080e7          	jalr	862(ra) # 800030ac <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d56:	08000613          	li	a2,128
    80005d5a:	f5040593          	addi	a1,s0,-176
    80005d5e:	4501                	li	a0,0
    80005d60:	ffffd097          	auipc	ra,0xffffd
    80005d64:	38c080e7          	jalr	908(ra) # 800030ec <argstr>
    80005d68:	87aa                	mv	a5,a0
    return -1;
    80005d6a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d6c:	0a07ce63          	bltz	a5,80005e28 <sys_open+0xe8>
    80005d70:	f526                	sd	s1,168(sp)

  begin_op();
    80005d72:	fffff097          	auipc	ra,0xfffff
    80005d76:	958080e7          	jalr	-1704(ra) # 800046ca <begin_op>

  if(omode & O_CREATE){
    80005d7a:	f4c42783          	lw	a5,-180(s0)
    80005d7e:	2007f793          	andi	a5,a5,512
    80005d82:	cfd5                	beqz	a5,80005e3e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005d84:	4681                	li	a3,0
    80005d86:	4601                	li	a2,0
    80005d88:	4589                	li	a1,2
    80005d8a:	f5040513          	addi	a0,s0,-176
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	95c080e7          	jalr	-1700(ra) # 800056ea <create>
    80005d96:	84aa                	mv	s1,a0
    if(ip == 0){
    80005d98:	cd41                	beqz	a0,80005e30 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d9a:	04449703          	lh	a4,68(s1)
    80005d9e:	478d                	li	a5,3
    80005da0:	00f71763          	bne	a4,a5,80005dae <sys_open+0x6e>
    80005da4:	0464d703          	lhu	a4,70(s1)
    80005da8:	47a5                	li	a5,9
    80005daa:	0ee7e163          	bltu	a5,a4,80005e8c <sys_open+0x14c>
    80005dae:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005db0:	fffff097          	auipc	ra,0xfffff
    80005db4:	d28080e7          	jalr	-728(ra) # 80004ad8 <filealloc>
    80005db8:	892a                	mv	s2,a0
    80005dba:	c97d                	beqz	a0,80005eb0 <sys_open+0x170>
    80005dbc:	ed4e                	sd	s3,152(sp)
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	8ea080e7          	jalr	-1814(ra) # 800056a8 <fdalloc>
    80005dc6:	89aa                	mv	s3,a0
    80005dc8:	0c054e63          	bltz	a0,80005ea4 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005dcc:	04449703          	lh	a4,68(s1)
    80005dd0:	478d                	li	a5,3
    80005dd2:	0ef70c63          	beq	a4,a5,80005eca <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005dd6:	4789                	li	a5,2
    80005dd8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005ddc:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005de0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005de4:	f4c42783          	lw	a5,-180(s0)
    80005de8:	0017c713          	xori	a4,a5,1
    80005dec:	8b05                	andi	a4,a4,1
    80005dee:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005df2:	0037f713          	andi	a4,a5,3
    80005df6:	00e03733          	snez	a4,a4
    80005dfa:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005dfe:	4007f793          	andi	a5,a5,1024
    80005e02:	c791                	beqz	a5,80005e0e <sys_open+0xce>
    80005e04:	04449703          	lh	a4,68(s1)
    80005e08:	4789                	li	a5,2
    80005e0a:	0cf70763          	beq	a4,a5,80005ed8 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005e0e:	8526                	mv	a0,s1
    80005e10:	ffffe097          	auipc	ra,0xffffe
    80005e14:	fb2080e7          	jalr	-78(ra) # 80003dc2 <iunlock>
  end_op();
    80005e18:	fffff097          	auipc	ra,0xfffff
    80005e1c:	92c080e7          	jalr	-1748(ra) # 80004744 <end_op>

  return fd;
    80005e20:	854e                	mv	a0,s3
    80005e22:	74aa                	ld	s1,168(sp)
    80005e24:	790a                	ld	s2,160(sp)
    80005e26:	69ea                	ld	s3,152(sp)
}
    80005e28:	70ea                	ld	ra,184(sp)
    80005e2a:	744a                	ld	s0,176(sp)
    80005e2c:	6129                	addi	sp,sp,192
    80005e2e:	8082                	ret
      end_op();
    80005e30:	fffff097          	auipc	ra,0xfffff
    80005e34:	914080e7          	jalr	-1772(ra) # 80004744 <end_op>
      return -1;
    80005e38:	557d                	li	a0,-1
    80005e3a:	74aa                	ld	s1,168(sp)
    80005e3c:	b7f5                	j	80005e28 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005e3e:	f5040513          	addi	a0,s0,-176
    80005e42:	ffffe097          	auipc	ra,0xffffe
    80005e46:	688080e7          	jalr	1672(ra) # 800044ca <namei>
    80005e4a:	84aa                	mv	s1,a0
    80005e4c:	c90d                	beqz	a0,80005e7e <sys_open+0x13e>
    ilock(ip);
    80005e4e:	ffffe097          	auipc	ra,0xffffe
    80005e52:	eae080e7          	jalr	-338(ra) # 80003cfc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e56:	04449703          	lh	a4,68(s1)
    80005e5a:	4785                	li	a5,1
    80005e5c:	f2f71fe3          	bne	a4,a5,80005d9a <sys_open+0x5a>
    80005e60:	f4c42783          	lw	a5,-180(s0)
    80005e64:	d7a9                	beqz	a5,80005dae <sys_open+0x6e>
      iunlockput(ip);
    80005e66:	8526                	mv	a0,s1
    80005e68:	ffffe097          	auipc	ra,0xffffe
    80005e6c:	0fa080e7          	jalr	250(ra) # 80003f62 <iunlockput>
      end_op();
    80005e70:	fffff097          	auipc	ra,0xfffff
    80005e74:	8d4080e7          	jalr	-1836(ra) # 80004744 <end_op>
      return -1;
    80005e78:	557d                	li	a0,-1
    80005e7a:	74aa                	ld	s1,168(sp)
    80005e7c:	b775                	j	80005e28 <sys_open+0xe8>
      end_op();
    80005e7e:	fffff097          	auipc	ra,0xfffff
    80005e82:	8c6080e7          	jalr	-1850(ra) # 80004744 <end_op>
      return -1;
    80005e86:	557d                	li	a0,-1
    80005e88:	74aa                	ld	s1,168(sp)
    80005e8a:	bf79                	j	80005e28 <sys_open+0xe8>
    iunlockput(ip);
    80005e8c:	8526                	mv	a0,s1
    80005e8e:	ffffe097          	auipc	ra,0xffffe
    80005e92:	0d4080e7          	jalr	212(ra) # 80003f62 <iunlockput>
    end_op();
    80005e96:	fffff097          	auipc	ra,0xfffff
    80005e9a:	8ae080e7          	jalr	-1874(ra) # 80004744 <end_op>
    return -1;
    80005e9e:	557d                	li	a0,-1
    80005ea0:	74aa                	ld	s1,168(sp)
    80005ea2:	b759                	j	80005e28 <sys_open+0xe8>
      fileclose(f);
    80005ea4:	854a                	mv	a0,s2
    80005ea6:	fffff097          	auipc	ra,0xfffff
    80005eaa:	cee080e7          	jalr	-786(ra) # 80004b94 <fileclose>
    80005eae:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005eb0:	8526                	mv	a0,s1
    80005eb2:	ffffe097          	auipc	ra,0xffffe
    80005eb6:	0b0080e7          	jalr	176(ra) # 80003f62 <iunlockput>
    end_op();
    80005eba:	fffff097          	auipc	ra,0xfffff
    80005ebe:	88a080e7          	jalr	-1910(ra) # 80004744 <end_op>
    return -1;
    80005ec2:	557d                	li	a0,-1
    80005ec4:	74aa                	ld	s1,168(sp)
    80005ec6:	790a                	ld	s2,160(sp)
    80005ec8:	b785                	j	80005e28 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005eca:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005ece:	04649783          	lh	a5,70(s1)
    80005ed2:	02f91223          	sh	a5,36(s2)
    80005ed6:	b729                	j	80005de0 <sys_open+0xa0>
    itrunc(ip);
    80005ed8:	8526                	mv	a0,s1
    80005eda:	ffffe097          	auipc	ra,0xffffe
    80005ede:	f34080e7          	jalr	-204(ra) # 80003e0e <itrunc>
    80005ee2:	b735                	j	80005e0e <sys_open+0xce>

0000000080005ee4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ee4:	7175                	addi	sp,sp,-144
    80005ee6:	e506                	sd	ra,136(sp)
    80005ee8:	e122                	sd	s0,128(sp)
    80005eea:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005eec:	ffffe097          	auipc	ra,0xffffe
    80005ef0:	7de080e7          	jalr	2014(ra) # 800046ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ef4:	08000613          	li	a2,128
    80005ef8:	f7040593          	addi	a1,s0,-144
    80005efc:	4501                	li	a0,0
    80005efe:	ffffd097          	auipc	ra,0xffffd
    80005f02:	1ee080e7          	jalr	494(ra) # 800030ec <argstr>
    80005f06:	02054963          	bltz	a0,80005f38 <sys_mkdir+0x54>
    80005f0a:	4681                	li	a3,0
    80005f0c:	4601                	li	a2,0
    80005f0e:	4585                	li	a1,1
    80005f10:	f7040513          	addi	a0,s0,-144
    80005f14:	fffff097          	auipc	ra,0xfffff
    80005f18:	7d6080e7          	jalr	2006(ra) # 800056ea <create>
    80005f1c:	cd11                	beqz	a0,80005f38 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f1e:	ffffe097          	auipc	ra,0xffffe
    80005f22:	044080e7          	jalr	68(ra) # 80003f62 <iunlockput>
  end_op();
    80005f26:	fffff097          	auipc	ra,0xfffff
    80005f2a:	81e080e7          	jalr	-2018(ra) # 80004744 <end_op>
  return 0;
    80005f2e:	4501                	li	a0,0
}
    80005f30:	60aa                	ld	ra,136(sp)
    80005f32:	640a                	ld	s0,128(sp)
    80005f34:	6149                	addi	sp,sp,144
    80005f36:	8082                	ret
    end_op();
    80005f38:	fffff097          	auipc	ra,0xfffff
    80005f3c:	80c080e7          	jalr	-2036(ra) # 80004744 <end_op>
    return -1;
    80005f40:	557d                	li	a0,-1
    80005f42:	b7fd                	j	80005f30 <sys_mkdir+0x4c>

0000000080005f44 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005f44:	7135                	addi	sp,sp,-160
    80005f46:	ed06                	sd	ra,152(sp)
    80005f48:	e922                	sd	s0,144(sp)
    80005f4a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005f4c:	ffffe097          	auipc	ra,0xffffe
    80005f50:	77e080e7          	jalr	1918(ra) # 800046ca <begin_op>
  argint(1, &major);
    80005f54:	f6c40593          	addi	a1,s0,-148
    80005f58:	4505                	li	a0,1
    80005f5a:	ffffd097          	auipc	ra,0xffffd
    80005f5e:	152080e7          	jalr	338(ra) # 800030ac <argint>
  argint(2, &minor);
    80005f62:	f6840593          	addi	a1,s0,-152
    80005f66:	4509                	li	a0,2
    80005f68:	ffffd097          	auipc	ra,0xffffd
    80005f6c:	144080e7          	jalr	324(ra) # 800030ac <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f70:	08000613          	li	a2,128
    80005f74:	f7040593          	addi	a1,s0,-144
    80005f78:	4501                	li	a0,0
    80005f7a:	ffffd097          	auipc	ra,0xffffd
    80005f7e:	172080e7          	jalr	370(ra) # 800030ec <argstr>
    80005f82:	02054b63          	bltz	a0,80005fb8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f86:	f6841683          	lh	a3,-152(s0)
    80005f8a:	f6c41603          	lh	a2,-148(s0)
    80005f8e:	458d                	li	a1,3
    80005f90:	f7040513          	addi	a0,s0,-144
    80005f94:	fffff097          	auipc	ra,0xfffff
    80005f98:	756080e7          	jalr	1878(ra) # 800056ea <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f9c:	cd11                	beqz	a0,80005fb8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f9e:	ffffe097          	auipc	ra,0xffffe
    80005fa2:	fc4080e7          	jalr	-60(ra) # 80003f62 <iunlockput>
  end_op();
    80005fa6:	ffffe097          	auipc	ra,0xffffe
    80005faa:	79e080e7          	jalr	1950(ra) # 80004744 <end_op>
  return 0;
    80005fae:	4501                	li	a0,0
}
    80005fb0:	60ea                	ld	ra,152(sp)
    80005fb2:	644a                	ld	s0,144(sp)
    80005fb4:	610d                	addi	sp,sp,160
    80005fb6:	8082                	ret
    end_op();
    80005fb8:	ffffe097          	auipc	ra,0xffffe
    80005fbc:	78c080e7          	jalr	1932(ra) # 80004744 <end_op>
    return -1;
    80005fc0:	557d                	li	a0,-1
    80005fc2:	b7fd                	j	80005fb0 <sys_mknod+0x6c>

0000000080005fc4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005fc4:	7135                	addi	sp,sp,-160
    80005fc6:	ed06                	sd	ra,152(sp)
    80005fc8:	e922                	sd	s0,144(sp)
    80005fca:	e14a                	sd	s2,128(sp)
    80005fcc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005fce:	ffffc097          	auipc	ra,0xffffc
    80005fd2:	d36080e7          	jalr	-714(ra) # 80001d04 <myproc>
    80005fd6:	892a                	mv	s2,a0
  
  begin_op();
    80005fd8:	ffffe097          	auipc	ra,0xffffe
    80005fdc:	6f2080e7          	jalr	1778(ra) # 800046ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005fe0:	08000613          	li	a2,128
    80005fe4:	f6040593          	addi	a1,s0,-160
    80005fe8:	4501                	li	a0,0
    80005fea:	ffffd097          	auipc	ra,0xffffd
    80005fee:	102080e7          	jalr	258(ra) # 800030ec <argstr>
    80005ff2:	04054d63          	bltz	a0,8000604c <sys_chdir+0x88>
    80005ff6:	e526                	sd	s1,136(sp)
    80005ff8:	f6040513          	addi	a0,s0,-160
    80005ffc:	ffffe097          	auipc	ra,0xffffe
    80006000:	4ce080e7          	jalr	1230(ra) # 800044ca <namei>
    80006004:	84aa                	mv	s1,a0
    80006006:	c131                	beqz	a0,8000604a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006008:	ffffe097          	auipc	ra,0xffffe
    8000600c:	cf4080e7          	jalr	-780(ra) # 80003cfc <ilock>
  if(ip->type != T_DIR){
    80006010:	04449703          	lh	a4,68(s1)
    80006014:	4785                	li	a5,1
    80006016:	04f71163          	bne	a4,a5,80006058 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000601a:	8526                	mv	a0,s1
    8000601c:	ffffe097          	auipc	ra,0xffffe
    80006020:	da6080e7          	jalr	-602(ra) # 80003dc2 <iunlock>
  iput(p->cwd);
    80006024:	15893503          	ld	a0,344(s2)
    80006028:	ffffe097          	auipc	ra,0xffffe
    8000602c:	e92080e7          	jalr	-366(ra) # 80003eba <iput>
  end_op();
    80006030:	ffffe097          	auipc	ra,0xffffe
    80006034:	714080e7          	jalr	1812(ra) # 80004744 <end_op>
  p->cwd = ip;
    80006038:	14993c23          	sd	s1,344(s2)
  return 0;
    8000603c:	4501                	li	a0,0
    8000603e:	64aa                	ld	s1,136(sp)
}
    80006040:	60ea                	ld	ra,152(sp)
    80006042:	644a                	ld	s0,144(sp)
    80006044:	690a                	ld	s2,128(sp)
    80006046:	610d                	addi	sp,sp,160
    80006048:	8082                	ret
    8000604a:	64aa                	ld	s1,136(sp)
    end_op();
    8000604c:	ffffe097          	auipc	ra,0xffffe
    80006050:	6f8080e7          	jalr	1784(ra) # 80004744 <end_op>
    return -1;
    80006054:	557d                	li	a0,-1
    80006056:	b7ed                	j	80006040 <sys_chdir+0x7c>
    iunlockput(ip);
    80006058:	8526                	mv	a0,s1
    8000605a:	ffffe097          	auipc	ra,0xffffe
    8000605e:	f08080e7          	jalr	-248(ra) # 80003f62 <iunlockput>
    end_op();
    80006062:	ffffe097          	auipc	ra,0xffffe
    80006066:	6e2080e7          	jalr	1762(ra) # 80004744 <end_op>
    return -1;
    8000606a:	557d                	li	a0,-1
    8000606c:	64aa                	ld	s1,136(sp)
    8000606e:	bfc9                	j	80006040 <sys_chdir+0x7c>

0000000080006070 <sys_exec>:

uint64
sys_exec(void)
{
    80006070:	7121                	addi	sp,sp,-448
    80006072:	ff06                	sd	ra,440(sp)
    80006074:	fb22                	sd	s0,432(sp)
    80006076:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006078:	e4840593          	addi	a1,s0,-440
    8000607c:	4505                	li	a0,1
    8000607e:	ffffd097          	auipc	ra,0xffffd
    80006082:	04e080e7          	jalr	78(ra) # 800030cc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006086:	08000613          	li	a2,128
    8000608a:	f5040593          	addi	a1,s0,-176
    8000608e:	4501                	li	a0,0
    80006090:	ffffd097          	auipc	ra,0xffffd
    80006094:	05c080e7          	jalr	92(ra) # 800030ec <argstr>
    80006098:	87aa                	mv	a5,a0
    return -1;
    8000609a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000609c:	0e07c263          	bltz	a5,80006180 <sys_exec+0x110>
    800060a0:	f726                	sd	s1,424(sp)
    800060a2:	f34a                	sd	s2,416(sp)
    800060a4:	ef4e                	sd	s3,408(sp)
    800060a6:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800060a8:	10000613          	li	a2,256
    800060ac:	4581                	li	a1,0
    800060ae:	e5040513          	addi	a0,s0,-432
    800060b2:	ffffb097          	auipc	ra,0xffffb
    800060b6:	c82080e7          	jalr	-894(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800060ba:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800060be:	89a6                	mv	s3,s1
    800060c0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800060c2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060c6:	00391513          	slli	a0,s2,0x3
    800060ca:	e4040593          	addi	a1,s0,-448
    800060ce:	e4843783          	ld	a5,-440(s0)
    800060d2:	953e                	add	a0,a0,a5
    800060d4:	ffffd097          	auipc	ra,0xffffd
    800060d8:	f3a080e7          	jalr	-198(ra) # 8000300e <fetchaddr>
    800060dc:	02054a63          	bltz	a0,80006110 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800060e0:	e4043783          	ld	a5,-448(s0)
    800060e4:	c7b9                	beqz	a5,80006132 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800060e6:	ffffb097          	auipc	ra,0xffffb
    800060ea:	a62080e7          	jalr	-1438(ra) # 80000b48 <kalloc>
    800060ee:	85aa                	mv	a1,a0
    800060f0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800060f4:	cd11                	beqz	a0,80006110 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060f6:	6605                	lui	a2,0x1
    800060f8:	e4043503          	ld	a0,-448(s0)
    800060fc:	ffffd097          	auipc	ra,0xffffd
    80006100:	f64080e7          	jalr	-156(ra) # 80003060 <fetchstr>
    80006104:	00054663          	bltz	a0,80006110 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80006108:	0905                	addi	s2,s2,1
    8000610a:	09a1                	addi	s3,s3,8
    8000610c:	fb491de3          	bne	s2,s4,800060c6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006110:	f5040913          	addi	s2,s0,-176
    80006114:	6088                	ld	a0,0(s1)
    80006116:	c125                	beqz	a0,80006176 <sys_exec+0x106>
    kfree(argv[i]);
    80006118:	ffffb097          	auipc	ra,0xffffb
    8000611c:	932080e7          	jalr	-1742(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006120:	04a1                	addi	s1,s1,8
    80006122:	ff2499e3          	bne	s1,s2,80006114 <sys_exec+0xa4>
  return -1;
    80006126:	557d                	li	a0,-1
    80006128:	74ba                	ld	s1,424(sp)
    8000612a:	791a                	ld	s2,416(sp)
    8000612c:	69fa                	ld	s3,408(sp)
    8000612e:	6a5a                	ld	s4,400(sp)
    80006130:	a881                	j	80006180 <sys_exec+0x110>
      argv[i] = 0;
    80006132:	0009079b          	sext.w	a5,s2
    80006136:	078e                	slli	a5,a5,0x3
    80006138:	fd078793          	addi	a5,a5,-48
    8000613c:	97a2                	add	a5,a5,s0
    8000613e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80006142:	e5040593          	addi	a1,s0,-432
    80006146:	f5040513          	addi	a0,s0,-176
    8000614a:	fffff097          	auipc	ra,0xfffff
    8000614e:	120080e7          	jalr	288(ra) # 8000526a <exec>
    80006152:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006154:	f5040993          	addi	s3,s0,-176
    80006158:	6088                	ld	a0,0(s1)
    8000615a:	c901                	beqz	a0,8000616a <sys_exec+0xfa>
    kfree(argv[i]);
    8000615c:	ffffb097          	auipc	ra,0xffffb
    80006160:	8ee080e7          	jalr	-1810(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006164:	04a1                	addi	s1,s1,8
    80006166:	ff3499e3          	bne	s1,s3,80006158 <sys_exec+0xe8>
  return ret;
    8000616a:	854a                	mv	a0,s2
    8000616c:	74ba                	ld	s1,424(sp)
    8000616e:	791a                	ld	s2,416(sp)
    80006170:	69fa                	ld	s3,408(sp)
    80006172:	6a5a                	ld	s4,400(sp)
    80006174:	a031                	j	80006180 <sys_exec+0x110>
  return -1;
    80006176:	557d                	li	a0,-1
    80006178:	74ba                	ld	s1,424(sp)
    8000617a:	791a                	ld	s2,416(sp)
    8000617c:	69fa                	ld	s3,408(sp)
    8000617e:	6a5a                	ld	s4,400(sp)
}
    80006180:	70fa                	ld	ra,440(sp)
    80006182:	745a                	ld	s0,432(sp)
    80006184:	6139                	addi	sp,sp,448
    80006186:	8082                	ret

0000000080006188 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006188:	7139                	addi	sp,sp,-64
    8000618a:	fc06                	sd	ra,56(sp)
    8000618c:	f822                	sd	s0,48(sp)
    8000618e:	f426                	sd	s1,40(sp)
    80006190:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006192:	ffffc097          	auipc	ra,0xffffc
    80006196:	b72080e7          	jalr	-1166(ra) # 80001d04 <myproc>
    8000619a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000619c:	fd840593          	addi	a1,s0,-40
    800061a0:	4501                	li	a0,0
    800061a2:	ffffd097          	auipc	ra,0xffffd
    800061a6:	f2a080e7          	jalr	-214(ra) # 800030cc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800061aa:	fc840593          	addi	a1,s0,-56
    800061ae:	fd040513          	addi	a0,s0,-48
    800061b2:	fffff097          	auipc	ra,0xfffff
    800061b6:	d50080e7          	jalr	-688(ra) # 80004f02 <pipealloc>
    return -1;
    800061ba:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800061bc:	0c054463          	bltz	a0,80006284 <sys_pipe+0xfc>
  fd0 = -1;
    800061c0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800061c4:	fd043503          	ld	a0,-48(s0)
    800061c8:	fffff097          	auipc	ra,0xfffff
    800061cc:	4e0080e7          	jalr	1248(ra) # 800056a8 <fdalloc>
    800061d0:	fca42223          	sw	a0,-60(s0)
    800061d4:	08054b63          	bltz	a0,8000626a <sys_pipe+0xe2>
    800061d8:	fc843503          	ld	a0,-56(s0)
    800061dc:	fffff097          	auipc	ra,0xfffff
    800061e0:	4cc080e7          	jalr	1228(ra) # 800056a8 <fdalloc>
    800061e4:	fca42023          	sw	a0,-64(s0)
    800061e8:	06054863          	bltz	a0,80006258 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800061ec:	4691                	li	a3,4
    800061ee:	fc440613          	addi	a2,s0,-60
    800061f2:	fd843583          	ld	a1,-40(s0)
    800061f6:	6ca8                	ld	a0,88(s1)
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	4ea080e7          	jalr	1258(ra) # 800016e2 <copyout>
    80006200:	02054063          	bltz	a0,80006220 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006204:	4691                	li	a3,4
    80006206:	fc040613          	addi	a2,s0,-64
    8000620a:	fd843583          	ld	a1,-40(s0)
    8000620e:	0591                	addi	a1,a1,4
    80006210:	6ca8                	ld	a0,88(s1)
    80006212:	ffffb097          	auipc	ra,0xffffb
    80006216:	4d0080e7          	jalr	1232(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000621a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000621c:	06055463          	bgez	a0,80006284 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006220:	fc442783          	lw	a5,-60(s0)
    80006224:	07e9                	addi	a5,a5,26
    80006226:	078e                	slli	a5,a5,0x3
    80006228:	97a6                	add	a5,a5,s1
    8000622a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000622e:	fc042783          	lw	a5,-64(s0)
    80006232:	07e9                	addi	a5,a5,26
    80006234:	078e                	slli	a5,a5,0x3
    80006236:	94be                	add	s1,s1,a5
    80006238:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    8000623c:	fd043503          	ld	a0,-48(s0)
    80006240:	fffff097          	auipc	ra,0xfffff
    80006244:	954080e7          	jalr	-1708(ra) # 80004b94 <fileclose>
    fileclose(wf);
    80006248:	fc843503          	ld	a0,-56(s0)
    8000624c:	fffff097          	auipc	ra,0xfffff
    80006250:	948080e7          	jalr	-1720(ra) # 80004b94 <fileclose>
    return -1;
    80006254:	57fd                	li	a5,-1
    80006256:	a03d                	j	80006284 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006258:	fc442783          	lw	a5,-60(s0)
    8000625c:	0007c763          	bltz	a5,8000626a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006260:	07e9                	addi	a5,a5,26
    80006262:	078e                	slli	a5,a5,0x3
    80006264:	97a6                	add	a5,a5,s1
    80006266:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000626a:	fd043503          	ld	a0,-48(s0)
    8000626e:	fffff097          	auipc	ra,0xfffff
    80006272:	926080e7          	jalr	-1754(ra) # 80004b94 <fileclose>
    fileclose(wf);
    80006276:	fc843503          	ld	a0,-56(s0)
    8000627a:	fffff097          	auipc	ra,0xfffff
    8000627e:	91a080e7          	jalr	-1766(ra) # 80004b94 <fileclose>
    return -1;
    80006282:	57fd                	li	a5,-1
}
    80006284:	853e                	mv	a0,a5
    80006286:	70e2                	ld	ra,56(sp)
    80006288:	7442                	ld	s0,48(sp)
    8000628a:	74a2                	ld	s1,40(sp)
    8000628c:	6121                	addi	sp,sp,64
    8000628e:	8082                	ret

0000000080006290 <kernelvec>:
    80006290:	7111                	addi	sp,sp,-256
    80006292:	e006                	sd	ra,0(sp)
    80006294:	e40a                	sd	sp,8(sp)
    80006296:	e80e                	sd	gp,16(sp)
    80006298:	ec12                	sd	tp,24(sp)
    8000629a:	f016                	sd	t0,32(sp)
    8000629c:	f41a                	sd	t1,40(sp)
    8000629e:	f81e                	sd	t2,48(sp)
    800062a0:	fc22                	sd	s0,56(sp)
    800062a2:	e0a6                	sd	s1,64(sp)
    800062a4:	e4aa                	sd	a0,72(sp)
    800062a6:	e8ae                	sd	a1,80(sp)
    800062a8:	ecb2                	sd	a2,88(sp)
    800062aa:	f0b6                	sd	a3,96(sp)
    800062ac:	f4ba                	sd	a4,104(sp)
    800062ae:	f8be                	sd	a5,112(sp)
    800062b0:	fcc2                	sd	a6,120(sp)
    800062b2:	e146                	sd	a7,128(sp)
    800062b4:	e54a                	sd	s2,136(sp)
    800062b6:	e94e                	sd	s3,144(sp)
    800062b8:	ed52                	sd	s4,152(sp)
    800062ba:	f156                	sd	s5,160(sp)
    800062bc:	f55a                	sd	s6,168(sp)
    800062be:	f95e                	sd	s7,176(sp)
    800062c0:	fd62                	sd	s8,184(sp)
    800062c2:	e1e6                	sd	s9,192(sp)
    800062c4:	e5ea                	sd	s10,200(sp)
    800062c6:	e9ee                	sd	s11,208(sp)
    800062c8:	edf2                	sd	t3,216(sp)
    800062ca:	f1f6                	sd	t4,224(sp)
    800062cc:	f5fa                	sd	t5,232(sp)
    800062ce:	f9fe                	sd	t6,240(sp)
    800062d0:	c09fc0ef          	jal	80002ed8 <kerneltrap>
    800062d4:	6082                	ld	ra,0(sp)
    800062d6:	6122                	ld	sp,8(sp)
    800062d8:	61c2                	ld	gp,16(sp)
    800062da:	7282                	ld	t0,32(sp)
    800062dc:	7322                	ld	t1,40(sp)
    800062de:	73c2                	ld	t2,48(sp)
    800062e0:	7462                	ld	s0,56(sp)
    800062e2:	6486                	ld	s1,64(sp)
    800062e4:	6526                	ld	a0,72(sp)
    800062e6:	65c6                	ld	a1,80(sp)
    800062e8:	6666                	ld	a2,88(sp)
    800062ea:	7686                	ld	a3,96(sp)
    800062ec:	7726                	ld	a4,104(sp)
    800062ee:	77c6                	ld	a5,112(sp)
    800062f0:	7866                	ld	a6,120(sp)
    800062f2:	688a                	ld	a7,128(sp)
    800062f4:	692a                	ld	s2,136(sp)
    800062f6:	69ca                	ld	s3,144(sp)
    800062f8:	6a6a                	ld	s4,152(sp)
    800062fa:	7a8a                	ld	s5,160(sp)
    800062fc:	7b2a                	ld	s6,168(sp)
    800062fe:	7bca                	ld	s7,176(sp)
    80006300:	7c6a                	ld	s8,184(sp)
    80006302:	6c8e                	ld	s9,192(sp)
    80006304:	6d2e                	ld	s10,200(sp)
    80006306:	6dce                	ld	s11,208(sp)
    80006308:	6e6e                	ld	t3,216(sp)
    8000630a:	7e8e                	ld	t4,224(sp)
    8000630c:	7f2e                	ld	t5,232(sp)
    8000630e:	7fce                	ld	t6,240(sp)
    80006310:	6111                	addi	sp,sp,256
    80006312:	10200073          	sret
    80006316:	00000013          	nop
    8000631a:	00000013          	nop
    8000631e:	0001                	nop

0000000080006320 <timervec>:
    80006320:	34051573          	csrrw	a0,mscratch,a0
    80006324:	e10c                	sd	a1,0(a0)
    80006326:	e510                	sd	a2,8(a0)
    80006328:	e914                	sd	a3,16(a0)
    8000632a:	6d0c                	ld	a1,24(a0)
    8000632c:	7110                	ld	a2,32(a0)
    8000632e:	6194                	ld	a3,0(a1)
    80006330:	96b2                	add	a3,a3,a2
    80006332:	e194                	sd	a3,0(a1)
    80006334:	4589                	li	a1,2
    80006336:	14459073          	csrw	sip,a1
    8000633a:	6914                	ld	a3,16(a0)
    8000633c:	6510                	ld	a2,8(a0)
    8000633e:	610c                	ld	a1,0(a0)
    80006340:	34051573          	csrrw	a0,mscratch,a0
    80006344:	30200073          	mret
	...

000000008000634a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000634a:	1141                	addi	sp,sp,-16
    8000634c:	e422                	sd	s0,8(sp)
    8000634e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006350:	0c0007b7          	lui	a5,0xc000
    80006354:	4705                	li	a4,1
    80006356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006358:	0c0007b7          	lui	a5,0xc000
    8000635c:	c3d8                	sw	a4,4(a5)
}
    8000635e:	6422                	ld	s0,8(sp)
    80006360:	0141                	addi	sp,sp,16
    80006362:	8082                	ret

0000000080006364 <plicinithart>:

void
plicinithart(void)
{
    80006364:	1141                	addi	sp,sp,-16
    80006366:	e406                	sd	ra,8(sp)
    80006368:	e022                	sd	s0,0(sp)
    8000636a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000636c:	ffffc097          	auipc	ra,0xffffc
    80006370:	96c080e7          	jalr	-1684(ra) # 80001cd8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006374:	0085171b          	slliw	a4,a0,0x8
    80006378:	0c0027b7          	lui	a5,0xc002
    8000637c:	97ba                	add	a5,a5,a4
    8000637e:	40200713          	li	a4,1026
    80006382:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006386:	00d5151b          	slliw	a0,a0,0xd
    8000638a:	0c2017b7          	lui	a5,0xc201
    8000638e:	97aa                	add	a5,a5,a0
    80006390:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006394:	60a2                	ld	ra,8(sp)
    80006396:	6402                	ld	s0,0(sp)
    80006398:	0141                	addi	sp,sp,16
    8000639a:	8082                	ret

000000008000639c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000639c:	1141                	addi	sp,sp,-16
    8000639e:	e406                	sd	ra,8(sp)
    800063a0:	e022                	sd	s0,0(sp)
    800063a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800063a4:	ffffc097          	auipc	ra,0xffffc
    800063a8:	934080e7          	jalr	-1740(ra) # 80001cd8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800063ac:	00d5151b          	slliw	a0,a0,0xd
    800063b0:	0c2017b7          	lui	a5,0xc201
    800063b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800063b6:	43c8                	lw	a0,4(a5)
    800063b8:	60a2                	ld	ra,8(sp)
    800063ba:	6402                	ld	s0,0(sp)
    800063bc:	0141                	addi	sp,sp,16
    800063be:	8082                	ret

00000000800063c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800063c0:	1101                	addi	sp,sp,-32
    800063c2:	ec06                	sd	ra,24(sp)
    800063c4:	e822                	sd	s0,16(sp)
    800063c6:	e426                	sd	s1,8(sp)
    800063c8:	1000                	addi	s0,sp,32
    800063ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800063cc:	ffffc097          	auipc	ra,0xffffc
    800063d0:	90c080e7          	jalr	-1780(ra) # 80001cd8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800063d4:	00d5151b          	slliw	a0,a0,0xd
    800063d8:	0c2017b7          	lui	a5,0xc201
    800063dc:	97aa                	add	a5,a5,a0
    800063de:	c3c4                	sw	s1,4(a5)
}
    800063e0:	60e2                	ld	ra,24(sp)
    800063e2:	6442                	ld	s0,16(sp)
    800063e4:	64a2                	ld	s1,8(sp)
    800063e6:	6105                	addi	sp,sp,32
    800063e8:	8082                	ret

00000000800063ea <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800063ea:	1141                	addi	sp,sp,-16
    800063ec:	e406                	sd	ra,8(sp)
    800063ee:	e022                	sd	s0,0(sp)
    800063f0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800063f2:	479d                	li	a5,7
    800063f4:	04a7cc63          	blt	a5,a0,8000644c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800063f8:	0001e797          	auipc	a5,0x1e
    800063fc:	64878793          	addi	a5,a5,1608 # 80024a40 <disk>
    80006400:	97aa                	add	a5,a5,a0
    80006402:	0187c783          	lbu	a5,24(a5)
    80006406:	ebb9                	bnez	a5,8000645c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006408:	00451693          	slli	a3,a0,0x4
    8000640c:	0001e797          	auipc	a5,0x1e
    80006410:	63478793          	addi	a5,a5,1588 # 80024a40 <disk>
    80006414:	6398                	ld	a4,0(a5)
    80006416:	9736                	add	a4,a4,a3
    80006418:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000641c:	6398                	ld	a4,0(a5)
    8000641e:	9736                	add	a4,a4,a3
    80006420:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006424:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006428:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000642c:	97aa                	add	a5,a5,a0
    8000642e:	4705                	li	a4,1
    80006430:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006434:	0001e517          	auipc	a0,0x1e
    80006438:	62450513          	addi	a0,a0,1572 # 80024a58 <disk+0x18>
    8000643c:	ffffc097          	auipc	ra,0xffffc
    80006440:	110080e7          	jalr	272(ra) # 8000254c <wakeup>
}
    80006444:	60a2                	ld	ra,8(sp)
    80006446:	6402                	ld	s0,0(sp)
    80006448:	0141                	addi	sp,sp,16
    8000644a:	8082                	ret
    panic("free_desc 1");
    8000644c:	00002517          	auipc	a0,0x2
    80006450:	2c450513          	addi	a0,a0,708 # 80008710 <etext+0x710>
    80006454:	ffffa097          	auipc	ra,0xffffa
    80006458:	10c080e7          	jalr	268(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000645c:	00002517          	auipc	a0,0x2
    80006460:	2c450513          	addi	a0,a0,708 # 80008720 <etext+0x720>
    80006464:	ffffa097          	auipc	ra,0xffffa
    80006468:	0fc080e7          	jalr	252(ra) # 80000560 <panic>

000000008000646c <virtio_disk_init>:
{
    8000646c:	1101                	addi	sp,sp,-32
    8000646e:	ec06                	sd	ra,24(sp)
    80006470:	e822                	sd	s0,16(sp)
    80006472:	e426                	sd	s1,8(sp)
    80006474:	e04a                	sd	s2,0(sp)
    80006476:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006478:	00002597          	auipc	a1,0x2
    8000647c:	2b858593          	addi	a1,a1,696 # 80008730 <etext+0x730>
    80006480:	0001e517          	auipc	a0,0x1e
    80006484:	6e850513          	addi	a0,a0,1768 # 80024b68 <disk+0x128>
    80006488:	ffffa097          	auipc	ra,0xffffa
    8000648c:	720080e7          	jalr	1824(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006490:	100017b7          	lui	a5,0x10001
    80006494:	4398                	lw	a4,0(a5)
    80006496:	2701                	sext.w	a4,a4
    80006498:	747277b7          	lui	a5,0x74727
    8000649c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800064a0:	18f71c63          	bne	a4,a5,80006638 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064a4:	100017b7          	lui	a5,0x10001
    800064a8:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800064aa:	439c                	lw	a5,0(a5)
    800064ac:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064ae:	4709                	li	a4,2
    800064b0:	18e79463          	bne	a5,a4,80006638 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064b4:	100017b7          	lui	a5,0x10001
    800064b8:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800064ba:	439c                	lw	a5,0(a5)
    800064bc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064be:	16e79d63          	bne	a5,a4,80006638 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800064c2:	100017b7          	lui	a5,0x10001
    800064c6:	47d8                	lw	a4,12(a5)
    800064c8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064ca:	554d47b7          	lui	a5,0x554d4
    800064ce:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800064d2:	16f71363          	bne	a4,a5,80006638 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064d6:	100017b7          	lui	a5,0x10001
    800064da:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064de:	4705                	li	a4,1
    800064e0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064e2:	470d                	li	a4,3
    800064e4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800064e6:	10001737          	lui	a4,0x10001
    800064ea:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800064ec:	c7ffe737          	lui	a4,0xc7ffe
    800064f0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9bdf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800064f4:	8ef9                	and	a3,a3,a4
    800064f6:	10001737          	lui	a4,0x10001
    800064fa:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064fc:	472d                	li	a4,11
    800064fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006500:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006504:	439c                	lw	a5,0(a5)
    80006506:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000650a:	8ba1                	andi	a5,a5,8
    8000650c:	12078e63          	beqz	a5,80006648 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006510:	100017b7          	lui	a5,0x10001
    80006514:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006518:	100017b7          	lui	a5,0x10001
    8000651c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006520:	439c                	lw	a5,0(a5)
    80006522:	2781                	sext.w	a5,a5
    80006524:	12079a63          	bnez	a5,80006658 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006528:	100017b7          	lui	a5,0x10001
    8000652c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006530:	439c                	lw	a5,0(a5)
    80006532:	2781                	sext.w	a5,a5
  if(max == 0)
    80006534:	12078a63          	beqz	a5,80006668 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006538:	471d                	li	a4,7
    8000653a:	12f77f63          	bgeu	a4,a5,80006678 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000653e:	ffffa097          	auipc	ra,0xffffa
    80006542:	60a080e7          	jalr	1546(ra) # 80000b48 <kalloc>
    80006546:	0001e497          	auipc	s1,0x1e
    8000654a:	4fa48493          	addi	s1,s1,1274 # 80024a40 <disk>
    8000654e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006550:	ffffa097          	auipc	ra,0xffffa
    80006554:	5f8080e7          	jalr	1528(ra) # 80000b48 <kalloc>
    80006558:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000655a:	ffffa097          	auipc	ra,0xffffa
    8000655e:	5ee080e7          	jalr	1518(ra) # 80000b48 <kalloc>
    80006562:	87aa                	mv	a5,a0
    80006564:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006566:	6088                	ld	a0,0(s1)
    80006568:	12050063          	beqz	a0,80006688 <virtio_disk_init+0x21c>
    8000656c:	0001e717          	auipc	a4,0x1e
    80006570:	4dc73703          	ld	a4,1244(a4) # 80024a48 <disk+0x8>
    80006574:	10070a63          	beqz	a4,80006688 <virtio_disk_init+0x21c>
    80006578:	10078863          	beqz	a5,80006688 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000657c:	6605                	lui	a2,0x1
    8000657e:	4581                	li	a1,0
    80006580:	ffffa097          	auipc	ra,0xffffa
    80006584:	7b4080e7          	jalr	1972(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006588:	0001e497          	auipc	s1,0x1e
    8000658c:	4b848493          	addi	s1,s1,1208 # 80024a40 <disk>
    80006590:	6605                	lui	a2,0x1
    80006592:	4581                	li	a1,0
    80006594:	6488                	ld	a0,8(s1)
    80006596:	ffffa097          	auipc	ra,0xffffa
    8000659a:	79e080e7          	jalr	1950(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    8000659e:	6605                	lui	a2,0x1
    800065a0:	4581                	li	a1,0
    800065a2:	6888                	ld	a0,16(s1)
    800065a4:	ffffa097          	auipc	ra,0xffffa
    800065a8:	790080e7          	jalr	1936(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800065ac:	100017b7          	lui	a5,0x10001
    800065b0:	4721                	li	a4,8
    800065b2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800065b4:	4098                	lw	a4,0(s1)
    800065b6:	100017b7          	lui	a5,0x10001
    800065ba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800065be:	40d8                	lw	a4,4(s1)
    800065c0:	100017b7          	lui	a5,0x10001
    800065c4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800065c8:	649c                	ld	a5,8(s1)
    800065ca:	0007869b          	sext.w	a3,a5
    800065ce:	10001737          	lui	a4,0x10001
    800065d2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800065d6:	9781                	srai	a5,a5,0x20
    800065d8:	10001737          	lui	a4,0x10001
    800065dc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800065e0:	689c                	ld	a5,16(s1)
    800065e2:	0007869b          	sext.w	a3,a5
    800065e6:	10001737          	lui	a4,0x10001
    800065ea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800065ee:	9781                	srai	a5,a5,0x20
    800065f0:	10001737          	lui	a4,0x10001
    800065f4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800065f8:	10001737          	lui	a4,0x10001
    800065fc:	4785                	li	a5,1
    800065fe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006600:	00f48c23          	sb	a5,24(s1)
    80006604:	00f48ca3          	sb	a5,25(s1)
    80006608:	00f48d23          	sb	a5,26(s1)
    8000660c:	00f48da3          	sb	a5,27(s1)
    80006610:	00f48e23          	sb	a5,28(s1)
    80006614:	00f48ea3          	sb	a5,29(s1)
    80006618:	00f48f23          	sb	a5,30(s1)
    8000661c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006620:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006624:	100017b7          	lui	a5,0x10001
    80006628:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000662c:	60e2                	ld	ra,24(sp)
    8000662e:	6442                	ld	s0,16(sp)
    80006630:	64a2                	ld	s1,8(sp)
    80006632:	6902                	ld	s2,0(sp)
    80006634:	6105                	addi	sp,sp,32
    80006636:	8082                	ret
    panic("could not find virtio disk");
    80006638:	00002517          	auipc	a0,0x2
    8000663c:	10850513          	addi	a0,a0,264 # 80008740 <etext+0x740>
    80006640:	ffffa097          	auipc	ra,0xffffa
    80006644:	f20080e7          	jalr	-224(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006648:	00002517          	auipc	a0,0x2
    8000664c:	11850513          	addi	a0,a0,280 # 80008760 <etext+0x760>
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	f10080e7          	jalr	-240(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006658:	00002517          	auipc	a0,0x2
    8000665c:	12850513          	addi	a0,a0,296 # 80008780 <etext+0x780>
    80006660:	ffffa097          	auipc	ra,0xffffa
    80006664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006668:	00002517          	auipc	a0,0x2
    8000666c:	13850513          	addi	a0,a0,312 # 800087a0 <etext+0x7a0>
    80006670:	ffffa097          	auipc	ra,0xffffa
    80006674:	ef0080e7          	jalr	-272(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006678:	00002517          	auipc	a0,0x2
    8000667c:	14850513          	addi	a0,a0,328 # 800087c0 <etext+0x7c0>
    80006680:	ffffa097          	auipc	ra,0xffffa
    80006684:	ee0080e7          	jalr	-288(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006688:	00002517          	auipc	a0,0x2
    8000668c:	15850513          	addi	a0,a0,344 # 800087e0 <etext+0x7e0>
    80006690:	ffffa097          	auipc	ra,0xffffa
    80006694:	ed0080e7          	jalr	-304(ra) # 80000560 <panic>

0000000080006698 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006698:	7159                	addi	sp,sp,-112
    8000669a:	f486                	sd	ra,104(sp)
    8000669c:	f0a2                	sd	s0,96(sp)
    8000669e:	eca6                	sd	s1,88(sp)
    800066a0:	e8ca                	sd	s2,80(sp)
    800066a2:	e4ce                	sd	s3,72(sp)
    800066a4:	e0d2                	sd	s4,64(sp)
    800066a6:	fc56                	sd	s5,56(sp)
    800066a8:	f85a                	sd	s6,48(sp)
    800066aa:	f45e                	sd	s7,40(sp)
    800066ac:	f062                	sd	s8,32(sp)
    800066ae:	ec66                	sd	s9,24(sp)
    800066b0:	1880                	addi	s0,sp,112
    800066b2:	8a2a                	mv	s4,a0
    800066b4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800066b6:	00c52c83          	lw	s9,12(a0)
    800066ba:	001c9c9b          	slliw	s9,s9,0x1
    800066be:	1c82                	slli	s9,s9,0x20
    800066c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800066c4:	0001e517          	auipc	a0,0x1e
    800066c8:	4a450513          	addi	a0,a0,1188 # 80024b68 <disk+0x128>
    800066cc:	ffffa097          	auipc	ra,0xffffa
    800066d0:	56c080e7          	jalr	1388(ra) # 80000c38 <acquire>
  for(int i = 0; i < 3; i++){
    800066d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800066d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800066d8:	0001eb17          	auipc	s6,0x1e
    800066dc:	368b0b13          	addi	s6,s6,872 # 80024a40 <disk>
  for(int i = 0; i < 3; i++){
    800066e0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800066e2:	0001ec17          	auipc	s8,0x1e
    800066e6:	486c0c13          	addi	s8,s8,1158 # 80024b68 <disk+0x128>
    800066ea:	a0ad                	j	80006754 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800066ec:	00fb0733          	add	a4,s6,a5
    800066f0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800066f4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800066f6:	0207c563          	bltz	a5,80006720 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800066fa:	2905                	addiw	s2,s2,1
    800066fc:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800066fe:	05590f63          	beq	s2,s5,8000675c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006702:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006704:	0001e717          	auipc	a4,0x1e
    80006708:	33c70713          	addi	a4,a4,828 # 80024a40 <disk>
    8000670c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000670e:	01874683          	lbu	a3,24(a4)
    80006712:	fee9                	bnez	a3,800066ec <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006714:	2785                	addiw	a5,a5,1
    80006716:	0705                	addi	a4,a4,1
    80006718:	fe979be3          	bne	a5,s1,8000670e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000671c:	57fd                	li	a5,-1
    8000671e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006720:	03205163          	blez	s2,80006742 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006724:	f9042503          	lw	a0,-112(s0)
    80006728:	00000097          	auipc	ra,0x0
    8000672c:	cc2080e7          	jalr	-830(ra) # 800063ea <free_desc>
      for(int j = 0; j < i; j++)
    80006730:	4785                	li	a5,1
    80006732:	0127d863          	bge	a5,s2,80006742 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006736:	f9442503          	lw	a0,-108(s0)
    8000673a:	00000097          	auipc	ra,0x0
    8000673e:	cb0080e7          	jalr	-848(ra) # 800063ea <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006742:	85e2                	mv	a1,s8
    80006744:	0001e517          	auipc	a0,0x1e
    80006748:	31450513          	addi	a0,a0,788 # 80024a58 <disk+0x18>
    8000674c:	ffffc097          	auipc	ra,0xffffc
    80006750:	d9c080e7          	jalr	-612(ra) # 800024e8 <sleep>
  for(int i = 0; i < 3; i++){
    80006754:	f9040613          	addi	a2,s0,-112
    80006758:	894e                	mv	s2,s3
    8000675a:	b765                	j	80006702 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000675c:	f9042503          	lw	a0,-112(s0)
    80006760:	00451693          	slli	a3,a0,0x4

  if(write)
    80006764:	0001e797          	auipc	a5,0x1e
    80006768:	2dc78793          	addi	a5,a5,732 # 80024a40 <disk>
    8000676c:	00a50713          	addi	a4,a0,10
    80006770:	0712                	slli	a4,a4,0x4
    80006772:	973e                	add	a4,a4,a5
    80006774:	01703633          	snez	a2,s7
    80006778:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000677a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000677e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006782:	6398                	ld	a4,0(a5)
    80006784:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006786:	0a868613          	addi	a2,a3,168
    8000678a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000678c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000678e:	6390                	ld	a2,0(a5)
    80006790:	00d605b3          	add	a1,a2,a3
    80006794:	4741                	li	a4,16
    80006796:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006798:	4805                	li	a6,1
    8000679a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000679e:	f9442703          	lw	a4,-108(s0)
    800067a2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800067a6:	0712                	slli	a4,a4,0x4
    800067a8:	963a                	add	a2,a2,a4
    800067aa:	058a0593          	addi	a1,s4,88
    800067ae:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800067b0:	0007b883          	ld	a7,0(a5)
    800067b4:	9746                	add	a4,a4,a7
    800067b6:	40000613          	li	a2,1024
    800067ba:	c710                	sw	a2,8(a4)
  if(write)
    800067bc:	001bb613          	seqz	a2,s7
    800067c0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800067c4:	00166613          	ori	a2,a2,1
    800067c8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800067cc:	f9842583          	lw	a1,-104(s0)
    800067d0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800067d4:	00250613          	addi	a2,a0,2
    800067d8:	0612                	slli	a2,a2,0x4
    800067da:	963e                	add	a2,a2,a5
    800067dc:	577d                	li	a4,-1
    800067de:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800067e2:	0592                	slli	a1,a1,0x4
    800067e4:	98ae                	add	a7,a7,a1
    800067e6:	03068713          	addi	a4,a3,48
    800067ea:	973e                	add	a4,a4,a5
    800067ec:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800067f0:	6398                	ld	a4,0(a5)
    800067f2:	972e                	add	a4,a4,a1
    800067f4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800067f8:	4689                	li	a3,2
    800067fa:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800067fe:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006802:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006806:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000680a:	6794                	ld	a3,8(a5)
    8000680c:	0026d703          	lhu	a4,2(a3)
    80006810:	8b1d                	andi	a4,a4,7
    80006812:	0706                	slli	a4,a4,0x1
    80006814:	96ba                	add	a3,a3,a4
    80006816:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000681a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000681e:	6798                	ld	a4,8(a5)
    80006820:	00275783          	lhu	a5,2(a4)
    80006824:	2785                	addiw	a5,a5,1
    80006826:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000682a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000682e:	100017b7          	lui	a5,0x10001
    80006832:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006836:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000683a:	0001e917          	auipc	s2,0x1e
    8000683e:	32e90913          	addi	s2,s2,814 # 80024b68 <disk+0x128>
  while(b->disk == 1) {
    80006842:	4485                	li	s1,1
    80006844:	01079c63          	bne	a5,a6,8000685c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006848:	85ca                	mv	a1,s2
    8000684a:	8552                	mv	a0,s4
    8000684c:	ffffc097          	auipc	ra,0xffffc
    80006850:	c9c080e7          	jalr	-868(ra) # 800024e8 <sleep>
  while(b->disk == 1) {
    80006854:	004a2783          	lw	a5,4(s4)
    80006858:	fe9788e3          	beq	a5,s1,80006848 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000685c:	f9042903          	lw	s2,-112(s0)
    80006860:	00290713          	addi	a4,s2,2
    80006864:	0712                	slli	a4,a4,0x4
    80006866:	0001e797          	auipc	a5,0x1e
    8000686a:	1da78793          	addi	a5,a5,474 # 80024a40 <disk>
    8000686e:	97ba                	add	a5,a5,a4
    80006870:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006874:	0001e997          	auipc	s3,0x1e
    80006878:	1cc98993          	addi	s3,s3,460 # 80024a40 <disk>
    8000687c:	00491713          	slli	a4,s2,0x4
    80006880:	0009b783          	ld	a5,0(s3)
    80006884:	97ba                	add	a5,a5,a4
    80006886:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000688a:	854a                	mv	a0,s2
    8000688c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006890:	00000097          	auipc	ra,0x0
    80006894:	b5a080e7          	jalr	-1190(ra) # 800063ea <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006898:	8885                	andi	s1,s1,1
    8000689a:	f0ed                	bnez	s1,8000687c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000689c:	0001e517          	auipc	a0,0x1e
    800068a0:	2cc50513          	addi	a0,a0,716 # 80024b68 <disk+0x128>
    800068a4:	ffffa097          	auipc	ra,0xffffa
    800068a8:	448080e7          	jalr	1096(ra) # 80000cec <release>
}
    800068ac:	70a6                	ld	ra,104(sp)
    800068ae:	7406                	ld	s0,96(sp)
    800068b0:	64e6                	ld	s1,88(sp)
    800068b2:	6946                	ld	s2,80(sp)
    800068b4:	69a6                	ld	s3,72(sp)
    800068b6:	6a06                	ld	s4,64(sp)
    800068b8:	7ae2                	ld	s5,56(sp)
    800068ba:	7b42                	ld	s6,48(sp)
    800068bc:	7ba2                	ld	s7,40(sp)
    800068be:	7c02                	ld	s8,32(sp)
    800068c0:	6ce2                	ld	s9,24(sp)
    800068c2:	6165                	addi	sp,sp,112
    800068c4:	8082                	ret

00000000800068c6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800068c6:	1101                	addi	sp,sp,-32
    800068c8:	ec06                	sd	ra,24(sp)
    800068ca:	e822                	sd	s0,16(sp)
    800068cc:	e426                	sd	s1,8(sp)
    800068ce:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800068d0:	0001e497          	auipc	s1,0x1e
    800068d4:	17048493          	addi	s1,s1,368 # 80024a40 <disk>
    800068d8:	0001e517          	auipc	a0,0x1e
    800068dc:	29050513          	addi	a0,a0,656 # 80024b68 <disk+0x128>
    800068e0:	ffffa097          	auipc	ra,0xffffa
    800068e4:	358080e7          	jalr	856(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800068e8:	100017b7          	lui	a5,0x10001
    800068ec:	53b8                	lw	a4,96(a5)
    800068ee:	8b0d                	andi	a4,a4,3
    800068f0:	100017b7          	lui	a5,0x10001
    800068f4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800068f6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800068fa:	689c                	ld	a5,16(s1)
    800068fc:	0204d703          	lhu	a4,32(s1)
    80006900:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006904:	04f70863          	beq	a4,a5,80006954 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006908:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000690c:	6898                	ld	a4,16(s1)
    8000690e:	0204d783          	lhu	a5,32(s1)
    80006912:	8b9d                	andi	a5,a5,7
    80006914:	078e                	slli	a5,a5,0x3
    80006916:	97ba                	add	a5,a5,a4
    80006918:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000691a:	00278713          	addi	a4,a5,2
    8000691e:	0712                	slli	a4,a4,0x4
    80006920:	9726                	add	a4,a4,s1
    80006922:	01074703          	lbu	a4,16(a4)
    80006926:	e721                	bnez	a4,8000696e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006928:	0789                	addi	a5,a5,2
    8000692a:	0792                	slli	a5,a5,0x4
    8000692c:	97a6                	add	a5,a5,s1
    8000692e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006930:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006934:	ffffc097          	auipc	ra,0xffffc
    80006938:	c18080e7          	jalr	-1000(ra) # 8000254c <wakeup>

    disk.used_idx += 1;
    8000693c:	0204d783          	lhu	a5,32(s1)
    80006940:	2785                	addiw	a5,a5,1
    80006942:	17c2                	slli	a5,a5,0x30
    80006944:	93c1                	srli	a5,a5,0x30
    80006946:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000694a:	6898                	ld	a4,16(s1)
    8000694c:	00275703          	lhu	a4,2(a4)
    80006950:	faf71ce3          	bne	a4,a5,80006908 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006954:	0001e517          	auipc	a0,0x1e
    80006958:	21450513          	addi	a0,a0,532 # 80024b68 <disk+0x128>
    8000695c:	ffffa097          	auipc	ra,0xffffa
    80006960:	390080e7          	jalr	912(ra) # 80000cec <release>
}
    80006964:	60e2                	ld	ra,24(sp)
    80006966:	6442                	ld	s0,16(sp)
    80006968:	64a2                	ld	s1,8(sp)
    8000696a:	6105                	addi	sp,sp,32
    8000696c:	8082                	ret
      panic("virtio_disk_intr status");
    8000696e:	00002517          	auipc	a0,0x2
    80006972:	e8a50513          	addi	a0,a0,-374 # 800087f8 <etext+0x7f8>
    80006976:	ffffa097          	auipc	ra,0xffffa
    8000697a:	bea080e7          	jalr	-1046(ra) # 80000560 <panic>
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
