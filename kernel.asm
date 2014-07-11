
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 4b 34 10 80       	mov    $0x8010344b,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 14 81 10 	movl   $0x80108114,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 c8 4a 00 00       	call   80104b16 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 75 4a 00 00       	call   80104b37 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 90 4a 00 00       	call   80104b99 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 36 47 00 00       	call   8010485a <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 18 4a 00 00       	call   80104b99 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 1b 81 10 80 	movl   $0x8010811b,(%esp)
8010019f:	e8 a2 03 00 00       	call   80100546 <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 14 26 00 00       	call   801027ec <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 2c 81 10 80 	movl   $0x8010812c,(%esp)
801001f6:	e8 4b 03 00 00       	call   80100546 <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 d7 25 00 00       	call   801027ec <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 33 81 10 80 	movl   $0x80108133,(%esp)
80100230:	e8 11 03 00 00       	call   80100546 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 f6 48 00 00       	call   80104b37 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 91 46 00 00       	call   80104933 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 eb 48 00 00       	call   80104b99 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801002c2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801002ca:	ec                   	in     (%dx),%al
801002cb:	89 c3                	mov    %eax,%ebx
801002cd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002d0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801002d4:	83 c4 14             	add    $0x14,%esp
801002d7:	5b                   	pop    %ebx
801002d8:	5d                   	pop    %ebp
801002d9:	c3                   	ret    

801002da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002da:	55                   	push   %ebp
801002db:	89 e5                	mov    %esp,%ebp
801002dd:	83 ec 08             	sub    $0x8,%esp
801002e0:	8b 55 08             	mov    0x8(%ebp),%edx
801002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801002e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002f5:	ee                   	out    %al,(%dx)
}
801002f6:	c9                   	leave  
801002f7:	c3                   	ret    

801002f8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f8:	55                   	push   %ebp
801002f9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002fb:	fa                   	cli    
}
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    

801002fe <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fe:	55                   	push   %ebp
801002ff:	89 e5                	mov    %esp,%ebp
80100301:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100308:	74 1c                	je     80100326 <printint+0x28>
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	c1 e8 1f             	shr    $0x1f,%eax
80100310:	0f b6 c0             	movzbl %al,%eax
80100313:	89 45 10             	mov    %eax,0x10(%ebp)
80100316:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031a:	74 0a                	je     80100326 <printint+0x28>
    x = -xx;
8010031c:	8b 45 08             	mov    0x8(%ebp),%eax
8010031f:	f7 d8                	neg    %eax
80100321:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100324:	eb 06                	jmp    8010032c <printint+0x2e>
  else
    x = xx;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010032c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100336:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100339:	ba 00 00 00 00       	mov    $0x0,%edx
8010033e:	f7 f1                	div    %ecx
80100340:	89 d0                	mov    %edx,%eax
80100342:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100349:	8d 4d e0             	lea    -0x20(%ebp),%ecx
8010034c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010034f:	01 ca                	add    %ecx,%edx
80100351:	88 02                	mov    %al,(%edx)
80100353:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
80100357:	8b 55 0c             	mov    0xc(%ebp),%edx
8010035a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010035d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100360:	ba 00 00 00 00       	mov    $0x0,%edx
80100365:	f7 75 d4             	divl   -0x2c(%ebp)
80100368:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010036f:	75 c2                	jne    80100333 <printint+0x35>

  if(sign)
80100371:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100375:	74 27                	je     8010039e <printint+0xa0>
    buf[i++] = '-';
80100377:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037d:	01 d0                	add    %edx,%eax
8010037f:	c6 00 2d             	movb   $0x2d,(%eax)
80100382:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
80100386:	eb 16                	jmp    8010039e <printint+0xa0>
    consputc(buf[i]);
80100388:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010038b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038e:	01 d0                	add    %edx,%eax
80100390:	0f b6 00             	movzbl (%eax),%eax
80100393:	0f be c0             	movsbl %al,%eax
80100396:	89 04 24             	mov    %eax,(%esp)
80100399:	e8 bb 03 00 00       	call   80100759 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010039e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003a6:	79 e0                	jns    80100388 <printint+0x8a>
    consputc(buf[i]);
}
801003a8:	c9                   	leave  
801003a9:	c3                   	ret    

801003aa <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003aa:	55                   	push   %ebp
801003ab:	89 e5                	mov    %esp,%ebp
801003ad:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003b0:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003bc:	74 0c                	je     801003ca <cprintf+0x20>
    acquire(&cons.lock);
801003be:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003c5:	e8 6d 47 00 00       	call   80104b37 <acquire>

  if (fmt == 0)
801003ca:	8b 45 08             	mov    0x8(%ebp),%eax
801003cd:	85 c0                	test   %eax,%eax
801003cf:	75 0c                	jne    801003dd <cprintf+0x33>
    panic("null fmt");
801003d1:	c7 04 24 3a 81 10 80 	movl   $0x8010813a,(%esp)
801003d8:	e8 69 01 00 00       	call   80100546 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003dd:	8d 45 0c             	lea    0xc(%ebp),%eax
801003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003ea:	e9 20 01 00 00       	jmp    8010050f <cprintf+0x165>
    if(c != '%'){
801003ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003f3:	74 10                	je     80100405 <cprintf+0x5b>
      consputc(c);
801003f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003f8:	89 04 24             	mov    %eax,(%esp)
801003fb:	e8 59 03 00 00       	call   80100759 <consputc>
      continue;
80100400:	e9 06 01 00 00       	jmp    8010050b <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100405:	8b 55 08             	mov    0x8(%ebp),%edx
80100408:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010040c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010040f:	01 d0                	add    %edx,%eax
80100411:	0f b6 00             	movzbl (%eax),%eax
80100414:	0f be c0             	movsbl %al,%eax
80100417:	25 ff 00 00 00       	and    $0xff,%eax
8010041c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010041f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100423:	0f 84 08 01 00 00    	je     80100531 <cprintf+0x187>
      break;
    switch(c){
80100429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010042c:	83 f8 70             	cmp    $0x70,%eax
8010042f:	74 4d                	je     8010047e <cprintf+0xd4>
80100431:	83 f8 70             	cmp    $0x70,%eax
80100434:	7f 13                	jg     80100449 <cprintf+0x9f>
80100436:	83 f8 25             	cmp    $0x25,%eax
80100439:	0f 84 a6 00 00 00    	je     801004e5 <cprintf+0x13b>
8010043f:	83 f8 64             	cmp    $0x64,%eax
80100442:	74 14                	je     80100458 <cprintf+0xae>
80100444:	e9 aa 00 00 00       	jmp    801004f3 <cprintf+0x149>
80100449:	83 f8 73             	cmp    $0x73,%eax
8010044c:	74 53                	je     801004a1 <cprintf+0xf7>
8010044e:	83 f8 78             	cmp    $0x78,%eax
80100451:	74 2b                	je     8010047e <cprintf+0xd4>
80100453:	e9 9b 00 00 00       	jmp    801004f3 <cprintf+0x149>
    case 'd':
      printint(*argp++, 10, 1);
80100458:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010045b:	8b 00                	mov    (%eax),%eax
8010045d:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100461:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100468:	00 
80100469:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100470:	00 
80100471:	89 04 24             	mov    %eax,(%esp)
80100474:	e8 85 fe ff ff       	call   801002fe <printint>
      break;
80100479:	e9 8d 00 00 00       	jmp    8010050b <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010047e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100481:	8b 00                	mov    (%eax),%eax
80100483:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100487:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010048e:	00 
8010048f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100496:	00 
80100497:	89 04 24             	mov    %eax,(%esp)
8010049a:	e8 5f fe ff ff       	call   801002fe <printint>
      break;
8010049f:	eb 6a                	jmp    8010050b <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a4:	8b 00                	mov    (%eax),%eax
801004a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ad:	0f 94 c0             	sete   %al
801004b0:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004b4:	84 c0                	test   %al,%al
801004b6:	74 20                	je     801004d8 <cprintf+0x12e>
        s = "(null)";
801004b8:	c7 45 ec 43 81 10 80 	movl   $0x80108143,-0x14(%ebp)
      for(; *s; s++)
801004bf:	eb 17                	jmp    801004d8 <cprintf+0x12e>
        consputc(*s);
801004c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004c4:	0f b6 00             	movzbl (%eax),%eax
801004c7:	0f be c0             	movsbl %al,%eax
801004ca:	89 04 24             	mov    %eax,(%esp)
801004cd:	e8 87 02 00 00       	call   80100759 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004d2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d6:	eb 01                	jmp    801004d9 <cprintf+0x12f>
801004d8:	90                   	nop
801004d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004dc:	0f b6 00             	movzbl (%eax),%eax
801004df:	84 c0                	test   %al,%al
801004e1:	75 de                	jne    801004c1 <cprintf+0x117>
        consputc(*s);
      break;
801004e3:	eb 26                	jmp    8010050b <cprintf+0x161>
    case '%':
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 68 02 00 00       	call   80100759 <consputc>
      break;
801004f1:	eb 18                	jmp    8010050b <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004f3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004fa:	e8 5a 02 00 00       	call   80100759 <consputc>
      consputc(c);
801004ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100502:	89 04 24             	mov    %eax,(%esp)
80100505:	e8 4f 02 00 00       	call   80100759 <consputc>
      break;
8010050a:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010050b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010050f:	8b 55 08             	mov    0x8(%ebp),%edx
80100512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100515:	01 d0                	add    %edx,%eax
80100517:	0f b6 00             	movzbl (%eax),%eax
8010051a:	0f be c0             	movsbl %al,%eax
8010051d:	25 ff 00 00 00       	and    $0xff,%eax
80100522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100529:	0f 85 c0 fe ff ff    	jne    801003ef <cprintf+0x45>
8010052f:	eb 01                	jmp    80100532 <cprintf+0x188>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100531:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100532:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100536:	74 0c                	je     80100544 <cprintf+0x19a>
    release(&cons.lock);
80100538:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010053f:	e8 55 46 00 00       	call   80104b99 <release>
}
80100544:	c9                   	leave  
80100545:	c3                   	ret    

80100546 <panic>:

void
panic(char *s)
{
80100546:	55                   	push   %ebp
80100547:	89 e5                	mov    %esp,%ebp
80100549:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
8010054c:	e8 a7 fd ff ff       	call   801002f8 <cli>
  cons.locking = 0;
80100551:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100558:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010055b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100561:	0f b6 00             	movzbl (%eax),%eax
80100564:	0f b6 c0             	movzbl %al,%eax
80100567:	89 44 24 04          	mov    %eax,0x4(%esp)
8010056b:	c7 04 24 4a 81 10 80 	movl   $0x8010814a,(%esp)
80100572:	e8 33 fe ff ff       	call   801003aa <cprintf>
  cprintf(s);
80100577:	8b 45 08             	mov    0x8(%ebp),%eax
8010057a:	89 04 24             	mov    %eax,(%esp)
8010057d:	e8 28 fe ff ff       	call   801003aa <cprintf>
  cprintf("\n");
80100582:	c7 04 24 59 81 10 80 	movl   $0x80108159,(%esp)
80100589:	e8 1c fe ff ff       	call   801003aa <cprintf>
  getcallerpcs(&s, pcs);
8010058e:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100591:	89 44 24 04          	mov    %eax,0x4(%esp)
80100595:	8d 45 08             	lea    0x8(%ebp),%eax
80100598:	89 04 24             	mov    %eax,(%esp)
8010059b:	e8 48 46 00 00       	call   80104be8 <getcallerpcs>
  for(i=0; i<10; i++)
801005a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005a7:	eb 1b                	jmp    801005c4 <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005ac:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801005b4:	c7 04 24 5b 81 10 80 	movl   $0x8010815b,(%esp)
801005bb:	e8 ea fd ff ff       	call   801003aa <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005c4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005c8:	7e df                	jle    801005a9 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005ca:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005d1:	00 00 00 
  for(;;)
    ;
801005d4:	eb fe                	jmp    801005d4 <panic+0x8e>

801005d6 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005d6:	55                   	push   %ebp
801005d7:	89 e5                	mov    %esp,%ebp
801005d9:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005dc:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005e3:	00 
801005e4:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005eb:	e8 ea fc ff ff       	call   801002da <outb>
  pos = inb(CRTPORT+1) << 8;
801005f0:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005f7:	e8 b4 fc ff ff       	call   801002b0 <inb>
801005fc:	0f b6 c0             	movzbl %al,%eax
801005ff:	c1 e0 08             	shl    $0x8,%eax
80100602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100605:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010060c:	00 
8010060d:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100614:	e8 c1 fc ff ff       	call   801002da <outb>
  pos |= inb(CRTPORT+1);
80100619:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100620:	e8 8b fc ff ff       	call   801002b0 <inb>
80100625:	0f b6 c0             	movzbl %al,%eax
80100628:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010062b:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010062f:	75 30                	jne    80100661 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100631:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100634:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100639:	89 c8                	mov    %ecx,%eax
8010063b:	f7 ea                	imul   %edx
8010063d:	c1 fa 05             	sar    $0x5,%edx
80100640:	89 c8                	mov    %ecx,%eax
80100642:	c1 f8 1f             	sar    $0x1f,%eax
80100645:	29 c2                	sub    %eax,%edx
80100647:	89 d0                	mov    %edx,%eax
80100649:	c1 e0 02             	shl    $0x2,%eax
8010064c:	01 d0                	add    %edx,%eax
8010064e:	c1 e0 04             	shl    $0x4,%eax
80100651:	89 ca                	mov    %ecx,%edx
80100653:	29 c2                	sub    %eax,%edx
80100655:	b8 50 00 00 00       	mov    $0x50,%eax
8010065a:	29 d0                	sub    %edx,%eax
8010065c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010065f:	eb 32                	jmp    80100693 <cgaputc+0xbd>
  else if(c == BACKSPACE){
80100661:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100668:	75 0c                	jne    80100676 <cgaputc+0xa0>
    if(pos > 0) --pos;
8010066a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010066e:	7e 23                	jle    80100693 <cgaputc+0xbd>
80100670:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100674:	eb 1d                	jmp    80100693 <cgaputc+0xbd>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100676:	a1 00 90 10 80       	mov    0x80109000,%eax
8010067b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010067e:	01 d2                	add    %edx,%edx
80100680:	01 c2                	add    %eax,%edx
80100682:	8b 45 08             	mov    0x8(%ebp),%eax
80100685:	66 25 ff 00          	and    $0xff,%ax
80100689:	80 cc 07             	or     $0x7,%ah
8010068c:	66 89 02             	mov    %ax,(%edx)
8010068f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
80100693:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010069a:	7e 53                	jle    801006ef <cgaputc+0x119>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010069c:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006a7:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ac:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006b3:	00 
801006b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801006b8:	89 04 24             	mov    %eax,(%esp)
801006bb:	e8 a5 47 00 00       	call   80104e65 <memmove>
    pos -= 80;
801006c0:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006c4:	b8 80 07 00 00       	mov    $0x780,%eax
801006c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006cc:	01 c0                	add    %eax,%eax
801006ce:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801006d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006d7:	01 c9                	add    %ecx,%ecx
801006d9:	01 ca                	add    %ecx,%edx
801006db:	89 44 24 08          	mov    %eax,0x8(%esp)
801006df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006e6:	00 
801006e7:	89 14 24             	mov    %edx,(%esp)
801006ea:	e8 a3 46 00 00       	call   80104d92 <memset>
  }
  
  outb(CRTPORT, 14);
801006ef:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006f6:	00 
801006f7:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006fe:	e8 d7 fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos>>8);
80100703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100706:	c1 f8 08             	sar    $0x8,%eax
80100709:	0f b6 c0             	movzbl %al,%eax
8010070c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100710:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100717:	e8 be fb ff ff       	call   801002da <outb>
  outb(CRTPORT, 15);
8010071c:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100723:	00 
80100724:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010072b:	e8 aa fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos);
80100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100733:	0f b6 c0             	movzbl %al,%eax
80100736:	89 44 24 04          	mov    %eax,0x4(%esp)
8010073a:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100741:	e8 94 fb ff ff       	call   801002da <outb>
  crt[pos] = ' ' | 0x0700;
80100746:	a1 00 90 10 80       	mov    0x80109000,%eax
8010074b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010074e:	01 d2                	add    %edx,%edx
80100750:	01 d0                	add    %edx,%eax
80100752:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100757:	c9                   	leave  
80100758:	c3                   	ret    

80100759 <consputc>:

void
consputc(int c)
{
80100759:	55                   	push   %ebp
8010075a:	89 e5                	mov    %esp,%ebp
8010075c:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010075f:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100764:	85 c0                	test   %eax,%eax
80100766:	74 07                	je     8010076f <consputc+0x16>
    cli();
80100768:	e8 8b fb ff ff       	call   801002f8 <cli>
    for(;;)
      ;
8010076d:	eb fe                	jmp    8010076d <consputc+0x14>
  }

  if(c == BACKSPACE){
8010076f:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100776:	75 26                	jne    8010079e <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100778:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010077f:	e8 c9 5f 00 00       	call   8010674d <uartputc>
80100784:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010078b:	e8 bd 5f 00 00       	call   8010674d <uartputc>
80100790:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100797:	e8 b1 5f 00 00       	call   8010674d <uartputc>
8010079c:	eb 0b                	jmp    801007a9 <consputc+0x50>
  } else
    uartputc(c);
8010079e:	8b 45 08             	mov    0x8(%ebp),%eax
801007a1:	89 04 24             	mov    %eax,(%esp)
801007a4:	e8 a4 5f 00 00       	call   8010674d <uartputc>
  cgaputc(c);
801007a9:	8b 45 08             	mov    0x8(%ebp),%eax
801007ac:	89 04 24             	mov    %eax,(%esp)
801007af:	e8 22 fe ff ff       	call   801005d6 <cgaputc>
}
801007b4:	c9                   	leave  
801007b5:	c3                   	ret    

801007b6 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b6:	55                   	push   %ebp
801007b7:	89 e5                	mov    %esp,%ebp
801007b9:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007bc:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801007c3:	e8 6f 43 00 00       	call   80104b37 <acquire>
  while((c = getc()) >= 0){
801007c8:	e9 41 01 00 00       	jmp    8010090e <consoleintr+0x158>
    switch(c){
801007cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007d0:	83 f8 10             	cmp    $0x10,%eax
801007d3:	74 1e                	je     801007f3 <consoleintr+0x3d>
801007d5:	83 f8 10             	cmp    $0x10,%eax
801007d8:	7f 0a                	jg     801007e4 <consoleintr+0x2e>
801007da:	83 f8 08             	cmp    $0x8,%eax
801007dd:	74 68                	je     80100847 <consoleintr+0x91>
801007df:	e9 94 00 00 00       	jmp    80100878 <consoleintr+0xc2>
801007e4:	83 f8 15             	cmp    $0x15,%eax
801007e7:	74 2f                	je     80100818 <consoleintr+0x62>
801007e9:	83 f8 7f             	cmp    $0x7f,%eax
801007ec:	74 59                	je     80100847 <consoleintr+0x91>
801007ee:	e9 85 00 00 00       	jmp    80100878 <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007f3:	e8 de 41 00 00       	call   801049d6 <procdump>
      break;
801007f8:	e9 11 01 00 00       	jmp    8010090e <consoleintr+0x158>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007fd:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100802:	83 e8 01             	sub    $0x1,%eax
80100805:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
8010080a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100811:	e8 43 ff ff ff       	call   80100759 <consputc>
80100816:	eb 01                	jmp    80100819 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100818:	90                   	nop
80100819:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010081f:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 db 00 00 00    	je     80100907 <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010082c:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100831:	83 e8 01             	sub    $0x1,%eax
80100834:	83 e0 7f             	and    $0x7f,%eax
80100837:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010083e:	3c 0a                	cmp    $0xa,%al
80100840:	75 bb                	jne    801007fd <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100842:	e9 c0 00 00 00       	jmp    80100907 <consoleintr+0x151>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100847:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010084d:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100852:	39 c2                	cmp    %eax,%edx
80100854:	0f 84 b0 00 00 00    	je     8010090a <consoleintr+0x154>
        input.e--;
8010085a:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010085f:	83 e8 01             	sub    $0x1,%eax
80100862:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100867:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010086e:	e8 e6 fe ff ff       	call   80100759 <consputc>
      }
      break;
80100873:	e9 92 00 00 00       	jmp    8010090a <consoleintr+0x154>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010087c:	0f 84 8b 00 00 00    	je     8010090d <consoleintr+0x157>
80100882:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100888:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010088d:	89 d1                	mov    %edx,%ecx
8010088f:	29 c1                	sub    %eax,%ecx
80100891:	89 c8                	mov    %ecx,%eax
80100893:	83 f8 7f             	cmp    $0x7f,%eax
80100896:	77 75                	ja     8010090d <consoleintr+0x157>
        c = (c == '\r') ? '\n' : c;
80100898:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010089c:	74 05                	je     801008a3 <consoleintr+0xed>
8010089e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008a1:	eb 05                	jmp    801008a8 <consoleintr+0xf2>
801008a3:	b8 0a 00 00 00       	mov    $0xa,%eax
801008a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008ab:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008b0:	89 c1                	mov    %eax,%ecx
801008b2:	83 e1 7f             	and    $0x7f,%ecx
801008b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008b8:	88 91 d4 dd 10 80    	mov    %dl,-0x7fef222c(%ecx)
801008be:	83 c0 01             	add    $0x1,%eax
801008c1:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(c);
801008c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008c9:	89 04 24             	mov    %eax,(%esp)
801008cc:	e8 88 fe ff ff       	call   80100759 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008d1:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008d5:	74 18                	je     801008ef <consoleintr+0x139>
801008d7:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008db:	74 12                	je     801008ef <consoleintr+0x139>
801008dd:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008e2:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008e8:	83 ea 80             	sub    $0xffffff80,%edx
801008eb:	39 d0                	cmp    %edx,%eax
801008ed:	75 1e                	jne    8010090d <consoleintr+0x157>
          input.w = input.e;
801008ef:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008f4:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008f9:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100900:	e8 2e 40 00 00       	call   80104933 <wakeup>
        }
      }
      break;
80100905:	eb 06                	jmp    8010090d <consoleintr+0x157>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100907:	90                   	nop
80100908:	eb 04                	jmp    8010090e <consoleintr+0x158>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010090a:	90                   	nop
8010090b:	eb 01                	jmp    8010090e <consoleintr+0x158>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
8010090d:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010090e:	8b 45 08             	mov    0x8(%ebp),%eax
80100911:	ff d0                	call   *%eax
80100913:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010091a:	0f 89 ad fe ff ff    	jns    801007cd <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100920:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100927:	e8 6d 42 00 00       	call   80104b99 <release>
}
8010092c:	c9                   	leave  
8010092d:	c3                   	ret    

8010092e <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010092e:	55                   	push   %ebp
8010092f:	89 e5                	mov    %esp,%ebp
80100931:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100934:	8b 45 08             	mov    0x8(%ebp),%eax
80100937:	89 04 24             	mov    %eax,(%esp)
8010093a:	e8 a2 10 00 00       	call   801019e1 <iunlock>
  target = n;
8010093f:	8b 45 10             	mov    0x10(%ebp),%eax
80100942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100945:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010094c:	e8 e6 41 00 00       	call   80104b37 <acquire>
  while(n > 0){
80100951:	e9 a8 00 00 00       	jmp    801009fe <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
80100956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010095c:	8b 40 24             	mov    0x24(%eax),%eax
8010095f:	85 c0                	test   %eax,%eax
80100961:	74 21                	je     80100984 <consoleread+0x56>
        release(&input.lock);
80100963:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010096a:	e8 2a 42 00 00       	call   80104b99 <release>
        ilock(ip);
8010096f:	8b 45 08             	mov    0x8(%ebp),%eax
80100972:	89 04 24             	mov    %eax,(%esp)
80100975:	e8 19 0f 00 00       	call   80101893 <ilock>
        return -1;
8010097a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010097f:	e9 a9 00 00 00       	jmp    80100a2d <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100984:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
8010098b:	80 
8010098c:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100993:	e8 c2 3e 00 00       	call   8010485a <sleep>
80100998:	eb 01                	jmp    8010099b <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010099a:	90                   	nop
8010099b:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801009a1:	a1 58 de 10 80       	mov    0x8010de58,%eax
801009a6:	39 c2                	cmp    %eax,%edx
801009a8:	74 ac                	je     80100956 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009aa:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009af:	89 c2                	mov    %eax,%edx
801009b1:	83 e2 7f             	and    $0x7f,%edx
801009b4:	0f b6 92 d4 dd 10 80 	movzbl -0x7fef222c(%edx),%edx
801009bb:	0f be d2             	movsbl %dl,%edx
801009be:	89 55 f0             	mov    %edx,-0x10(%ebp)
801009c1:	83 c0 01             	add    $0x1,%eax
801009c4:	a3 54 de 10 80       	mov    %eax,0x8010de54
    if(c == C('D')){  // EOF
801009c9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009cd:	75 17                	jne    801009e6 <consoleread+0xb8>
      if(n < target){
801009cf:	8b 45 10             	mov    0x10(%ebp),%eax
801009d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009d5:	73 2f                	jae    80100a06 <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009d7:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009dc:	83 e8 01             	sub    $0x1,%eax
801009df:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009e4:	eb 20                	jmp    80100a06 <consoleread+0xd8>
    }
    *dst++ = c;
801009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009e9:	89 c2                	mov    %eax,%edx
801009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801009ee:	88 10                	mov    %dl,(%eax)
801009f0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009f4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009f8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009fc:	74 0b                	je     80100a09 <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a02:	7f 96                	jg     8010099a <consoleread+0x6c>
80100a04:	eb 04                	jmp    80100a0a <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a06:	90                   	nop
80100a07:	eb 01                	jmp    80100a0a <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a09:	90                   	nop
  }
  release(&input.lock);
80100a0a:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100a11:	e8 83 41 00 00       	call   80104b99 <release>
  ilock(ip);
80100a16:	8b 45 08             	mov    0x8(%ebp),%eax
80100a19:	89 04 24             	mov    %eax,(%esp)
80100a1c:	e8 72 0e 00 00       	call   80101893 <ilock>

  return target - n;
80100a21:	8b 45 10             	mov    0x10(%ebp),%eax
80100a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a27:	89 d1                	mov    %edx,%ecx
80100a29:	29 c1                	sub    %eax,%ecx
80100a2b:	89 c8                	mov    %ecx,%eax
}
80100a2d:	c9                   	leave  
80100a2e:	c3                   	ret    

80100a2f <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a2f:	55                   	push   %ebp
80100a30:	89 e5                	mov    %esp,%ebp
80100a32:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a35:	8b 45 08             	mov    0x8(%ebp),%eax
80100a38:	89 04 24             	mov    %eax,(%esp)
80100a3b:	e8 a1 0f 00 00       	call   801019e1 <iunlock>
  acquire(&cons.lock);
80100a40:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a47:	e8 eb 40 00 00       	call   80104b37 <acquire>
  for(i = 0; i < n; i++)
80100a4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a53:	eb 1f                	jmp    80100a74 <consolewrite+0x45>
    consputc(buf[i] & 0xff);
80100a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a5b:	01 d0                	add    %edx,%eax
80100a5d:	0f b6 00             	movzbl (%eax),%eax
80100a60:	0f be c0             	movsbl %al,%eax
80100a63:	25 ff 00 00 00       	and    $0xff,%eax
80100a68:	89 04 24             	mov    %eax,(%esp)
80100a6b:	e8 e9 fc ff ff       	call   80100759 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a77:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a7a:	7c d9                	jl     80100a55 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a7c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a83:	e8 11 41 00 00       	call   80104b99 <release>
  ilock(ip);
80100a88:	8b 45 08             	mov    0x8(%ebp),%eax
80100a8b:	89 04 24             	mov    %eax,(%esp)
80100a8e:	e8 00 0e 00 00       	call   80101893 <ilock>

  return n;
80100a93:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a96:	c9                   	leave  
80100a97:	c3                   	ret    

80100a98 <consoleinit>:

void
consoleinit(void)
{
80100a98:	55                   	push   %ebp
80100a99:	89 e5                	mov    %esp,%ebp
80100a9b:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a9e:	c7 44 24 04 5f 81 10 	movl   $0x8010815f,0x4(%esp)
80100aa5:	80 
80100aa6:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100aad:	e8 64 40 00 00       	call   80104b16 <initlock>
  initlock(&input.lock, "input");
80100ab2:	c7 44 24 04 67 81 10 	movl   $0x80108167,0x4(%esp)
80100ab9:	80 
80100aba:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100ac1:	e8 50 40 00 00       	call   80104b16 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ac6:	c7 05 0c e8 10 80 2f 	movl   $0x80100a2f,0x8010e80c
80100acd:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ad0:	c7 05 08 e8 10 80 2e 	movl   $0x8010092e,0x8010e808
80100ad7:	09 10 80 
  cons.locking = 1;
80100ada:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100ae1:	00 00 00 

  picenable(IRQ_KBD);
80100ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aeb:	e8 09 30 00 00       	call   80103af9 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100af0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100af7:	00 
80100af8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aff:	e8 aa 1e 00 00       	call   801029ae <ioapicenable>
}
80100b04:	c9                   	leave  
80100b05:	c3                   	ret    
	...

80100b08 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b08:	55                   	push   %ebp
80100b09:	89 e5                	mov    %esp,%ebp
80100b0b:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b11:	8b 45 08             	mov    0x8(%ebp),%eax
80100b14:	89 04 24             	mov    %eax,(%esp)
80100b17:	e8 28 19 00 00       	call   80102444 <namei>
80100b1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b1f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b23:	75 0a                	jne    80100b2f <exec+0x27>
    return -1;
80100b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b2a:	e9 ef 03 00 00       	jmp    80100f1e <exec+0x416>
  ilock(ip);
80100b2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b32:	89 04 24             	mov    %eax,(%esp)
80100b35:	e8 59 0d 00 00       	call   80101893 <ilock>
  pgdir = 0;
80100b3a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b41:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b48:	00 
80100b49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b50:	00 
80100b51:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b5e:	89 04 24             	mov    %eax,(%esp)
80100b61:	e8 3a 12 00 00       	call   80101da0 <readi>
80100b66:	83 f8 33             	cmp    $0x33,%eax
80100b69:	0f 86 69 03 00 00    	jbe    80100ed8 <exec+0x3d0>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b6f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b75:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b7a:	0f 85 5b 03 00 00    	jne    80100edb <exec+0x3d3>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b80:	e8 1a 6d 00 00       	call   8010789f <setupkvm>
80100b85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b8c:	0f 84 4c 03 00 00    	je     80100ede <exec+0x3d6>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ba0:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ba9:	e9 c5 00 00 00       	jmp    80100c73 <exec+0x16b>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bb1:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bb8:	00 
80100bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bbd:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bc7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bca:	89 04 24             	mov    %eax,(%esp)
80100bcd:	e8 ce 11 00 00       	call   80101da0 <readi>
80100bd2:	83 f8 20             	cmp    $0x20,%eax
80100bd5:	0f 85 06 03 00 00    	jne    80100ee1 <exec+0x3d9>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bdb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100be1:	83 f8 01             	cmp    $0x1,%eax
80100be4:	75 7f                	jne    80100c65 <exec+0x15d>
      continue;
    if(ph.memsz < ph.filesz)
80100be6:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100bec:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bf2:	39 c2                	cmp    %eax,%edx
80100bf4:	0f 82 ea 02 00 00    	jb     80100ee4 <exec+0x3dc>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bfa:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c00:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c06:	01 d0                	add    %edx,%eax
80100c08:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 53 70 00 00       	call   80107c71 <allocuvm>
80100c1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c25:	0f 84 bc 02 00 00    	je     80100ee7 <exec+0x3df>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c2b:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c31:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c37:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c3d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c41:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c45:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c48:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c53:	89 04 24             	mov    %eax,(%esp)
80100c56:	e8 27 6f 00 00       	call   80107b82 <loaduvm>
80100c5b:	85 c0                	test   %eax,%eax
80100c5d:	0f 88 87 02 00 00    	js     80100eea <exec+0x3e2>
80100c63:	eb 01                	jmp    80100c66 <exec+0x15e>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c65:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c66:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c6d:	83 c0 20             	add    $0x20,%eax
80100c70:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c73:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c7a:	0f b7 c0             	movzwl %ax,%eax
80100c7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c80:	0f 8f 28 ff ff ff    	jg     80100bae <exec+0xa6>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c86:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c89:	89 04 24             	mov    %eax,(%esp)
80100c8c:	e8 86 0e 00 00       	call   80101b17 <iunlockput>
  ip = 0;
80100c91:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ca0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cab:	05 00 20 00 00       	add    $0x2000,%eax
80100cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbe:	89 04 24             	mov    %eax,(%esp)
80100cc1:	e8 ab 6f 00 00       	call   80107c71 <allocuvm>
80100cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccd:	0f 84 1a 02 00 00    	je     80100eed <exec+0x3e5>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce2:	89 04 24             	mov    %eax,(%esp)
80100ce5:	e8 b7 71 00 00       	call   80107ea1 <clearpteu>
  sp = sz;
80100cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ced:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf7:	e9 97 00 00 00       	jmp    80100d93 <exec+0x28b>
    if(argc >= MAXARG)
80100cfc:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d00:	0f 87 ea 01 00 00    	ja     80100ef0 <exec+0x3e8>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d10:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d13:	01 d0                	add    %edx,%eax
80100d15:	8b 00                	mov    (%eax),%eax
80100d17:	89 04 24             	mov    %eax,(%esp)
80100d1a:	e8 f1 42 00 00       	call   80105010 <strlen>
80100d1f:	f7 d0                	not    %eax
80100d21:	89 c2                	mov    %eax,%edx
80100d23:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d26:	01 d0                	add    %edx,%eax
80100d28:	83 e0 fc             	and    $0xfffffffc,%eax
80100d2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d38:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3b:	01 d0                	add    %edx,%eax
80100d3d:	8b 00                	mov    (%eax),%eax
80100d3f:	89 04 24             	mov    %eax,(%esp)
80100d42:	e8 c9 42 00 00       	call   80105010 <strlen>
80100d47:	83 c0 01             	add    $0x1,%eax
80100d4a:	89 c2                	mov    %eax,%edx
80100d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d4f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d59:	01 c8                	add    %ecx,%eax
80100d5b:	8b 00                	mov    (%eax),%eax
80100d5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d61:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d68:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d6f:	89 04 24             	mov    %eax,(%esp)
80100d72:	e8 ef 72 00 00       	call   80108066 <copyout>
80100d77:	85 c0                	test   %eax,%eax
80100d79:	0f 88 74 01 00 00    	js     80100ef3 <exec+0x3eb>
      goto bad;
    ustack[3+argc] = sp;
80100d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d82:	8d 50 03             	lea    0x3(%eax),%edx
80100d85:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d88:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d8f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da0:	01 d0                	add    %edx,%eax
80100da2:	8b 00                	mov    (%eax),%eax
80100da4:	85 c0                	test   %eax,%eax
80100da6:	0f 85 50 ff ff ff    	jne    80100cfc <exec+0x1f4>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100daf:	83 c0 03             	add    $0x3,%eax
80100db2:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100db9:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dbd:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc4:	ff ff ff 
  ustack[1] = argc;
80100dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dca:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd3:	83 c0 01             	add    $0x1,%eax
80100dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ddd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de0:	29 d0                	sub    %edx,%eax
80100de2:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100deb:	83 c0 04             	add    $0x4,%eax
80100dee:	c1 e0 02             	shl    $0x2,%eax
80100df1:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df7:	83 c0 04             	add    $0x4,%eax
80100dfa:	c1 e0 02             	shl    $0x2,%eax
80100dfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e01:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e07:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e15:	89 04 24             	mov    %eax,(%esp)
80100e18:	e8 49 72 00 00       	call   80108066 <copyout>
80100e1d:	85 c0                	test   %eax,%eax
80100e1f:	0f 88 d1 00 00 00    	js     80100ef6 <exec+0x3ee>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e25:	8b 45 08             	mov    0x8(%ebp),%eax
80100e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e31:	eb 17                	jmp    80100e4a <exec+0x342>
    if(*s == '/')
80100e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e36:	0f b6 00             	movzbl (%eax),%eax
80100e39:	3c 2f                	cmp    $0x2f,%al
80100e3b:	75 09                	jne    80100e46 <exec+0x33e>
      last = s+1;
80100e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e40:	83 c0 01             	add    $0x1,%eax
80100e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e4d:	0f b6 00             	movzbl (%eax),%eax
80100e50:	84 c0                	test   %al,%al
80100e52:	75 df                	jne    80100e33 <exec+0x32b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5a:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e5d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e64:	00 
80100e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e6c:	89 14 24             	mov    %edx,(%esp)
80100e6f:	e8 4e 41 00 00       	call   80104fc2 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7a:	8b 40 04             	mov    0x4(%eax),%eax
80100e7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e86:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e89:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e92:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e95:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9d:	8b 40 18             	mov    0x18(%eax),%eax
80100ea0:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ea6:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ea9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eaf:	8b 40 18             	mov    0x18(%eax),%eax
80100eb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eb5:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebe:	89 04 24             	mov    %eax,(%esp)
80100ec1:	e8 ca 6a 00 00       	call   80107990 <switchuvm>
  freevm(oldpgdir);
80100ec6:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ec9:	89 04 24             	mov    %eax,(%esp)
80100ecc:	e8 36 6f 00 00       	call   80107e07 <freevm>
  return 0;
80100ed1:	b8 00 00 00 00       	mov    $0x0,%eax
80100ed6:	eb 46                	jmp    80100f1e <exec+0x416>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100ed8:	90                   	nop
80100ed9:	eb 1c                	jmp    80100ef7 <exec+0x3ef>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100edb:	90                   	nop
80100edc:	eb 19                	jmp    80100ef7 <exec+0x3ef>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100ede:	90                   	nop
80100edf:	eb 16                	jmp    80100ef7 <exec+0x3ef>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ee1:	90                   	nop
80100ee2:	eb 13                	jmp    80100ef7 <exec+0x3ef>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ee4:	90                   	nop
80100ee5:	eb 10                	jmp    80100ef7 <exec+0x3ef>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ee7:	90                   	nop
80100ee8:	eb 0d                	jmp    80100ef7 <exec+0x3ef>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100eea:	90                   	nop
80100eeb:	eb 0a                	jmp    80100ef7 <exec+0x3ef>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100eed:	90                   	nop
80100eee:	eb 07                	jmp    80100ef7 <exec+0x3ef>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ef0:	90                   	nop
80100ef1:	eb 04                	jmp    80100ef7 <exec+0x3ef>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ef3:	90                   	nop
80100ef4:	eb 01                	jmp    80100ef7 <exec+0x3ef>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100ef6:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ef7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100efb:	74 0b                	je     80100f08 <exec+0x400>
    freevm(pgdir);
80100efd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f00:	89 04 24             	mov    %eax,(%esp)
80100f03:	e8 ff 6e 00 00       	call   80107e07 <freevm>
  if(ip)
80100f08:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f0c:	74 0b                	je     80100f19 <exec+0x411>
    iunlockput(ip);
80100f0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f11:	89 04 24             	mov    %eax,(%esp)
80100f14:	e8 fe 0b 00 00       	call   80101b17 <iunlockput>
  return -1;
80100f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f1e:	c9                   	leave  
80100f1f:	c3                   	ret    

80100f20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f26:	c7 44 24 04 6d 81 10 	movl   $0x8010816d,0x4(%esp)
80100f2d:	80 
80100f2e:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f35:	e8 dc 3b 00 00       	call   80104b16 <initlock>
}
80100f3a:	c9                   	leave  
80100f3b:	c3                   	ret    

80100f3c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f3c:	55                   	push   %ebp
80100f3d:	89 e5                	mov    %esp,%ebp
80100f3f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f42:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f49:	e8 e9 3b 00 00       	call   80104b37 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f4e:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f55:	eb 29                	jmp    80100f80 <filealloc+0x44>
    if(f->ref == 0){
80100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5a:	8b 40 04             	mov    0x4(%eax),%eax
80100f5d:	85 c0                	test   %eax,%eax
80100f5f:	75 1b                	jne    80100f7c <filealloc+0x40>
      f->ref = 1;
80100f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f64:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f6b:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f72:	e8 22 3c 00 00       	call   80104b99 <release>
      return f;
80100f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7a:	eb 1e                	jmp    80100f9a <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f7c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f80:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
80100f87:	72 ce                	jb     80100f57 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f89:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f90:	e8 04 3c 00 00       	call   80104b99 <release>
  return 0;
80100f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f9a:	c9                   	leave  
80100f9b:	c3                   	ret    

80100f9c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f9c:	55                   	push   %ebp
80100f9d:	89 e5                	mov    %esp,%ebp
80100f9f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fa2:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fa9:	e8 89 3b 00 00       	call   80104b37 <acquire>
  if(f->ref < 1)
80100fae:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb1:	8b 40 04             	mov    0x4(%eax),%eax
80100fb4:	85 c0                	test   %eax,%eax
80100fb6:	7f 0c                	jg     80100fc4 <filedup+0x28>
    panic("filedup");
80100fb8:	c7 04 24 74 81 10 80 	movl   $0x80108174,(%esp)
80100fbf:	e8 82 f5 ff ff       	call   80100546 <panic>
  f->ref++;
80100fc4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc7:	8b 40 04             	mov    0x4(%eax),%eax
80100fca:	8d 50 01             	lea    0x1(%eax),%edx
80100fcd:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd0:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fd3:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fda:	e8 ba 3b 00 00       	call   80104b99 <release>
  return f;
80100fdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fe2:	c9                   	leave  
80100fe3:	c3                   	ret    

80100fe4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fe4:	55                   	push   %ebp
80100fe5:	89 e5                	mov    %esp,%ebp
80100fe7:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fea:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100ff1:	e8 41 3b 00 00       	call   80104b37 <acquire>
  if(f->ref < 1)
80100ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff9:	8b 40 04             	mov    0x4(%eax),%eax
80100ffc:	85 c0                	test   %eax,%eax
80100ffe:	7f 0c                	jg     8010100c <fileclose+0x28>
    panic("fileclose");
80101000:	c7 04 24 7c 81 10 80 	movl   $0x8010817c,(%esp)
80101007:	e8 3a f5 ff ff       	call   80100546 <panic>
  if(--f->ref > 0){
8010100c:	8b 45 08             	mov    0x8(%ebp),%eax
8010100f:	8b 40 04             	mov    0x4(%eax),%eax
80101012:	8d 50 ff             	lea    -0x1(%eax),%edx
80101015:	8b 45 08             	mov    0x8(%ebp),%eax
80101018:	89 50 04             	mov    %edx,0x4(%eax)
8010101b:	8b 45 08             	mov    0x8(%ebp),%eax
8010101e:	8b 40 04             	mov    0x4(%eax),%eax
80101021:	85 c0                	test   %eax,%eax
80101023:	7e 11                	jle    80101036 <fileclose+0x52>
    release(&ftable.lock);
80101025:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
8010102c:	e8 68 3b 00 00       	call   80104b99 <release>
80101031:	e9 82 00 00 00       	jmp    801010b8 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101036:	8b 45 08             	mov    0x8(%ebp),%eax
80101039:	8b 10                	mov    (%eax),%edx
8010103b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010103e:	8b 50 04             	mov    0x4(%eax),%edx
80101041:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101044:	8b 50 08             	mov    0x8(%eax),%edx
80101047:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010104a:	8b 50 0c             	mov    0xc(%eax),%edx
8010104d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101050:	8b 50 10             	mov    0x10(%eax),%edx
80101053:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101056:	8b 40 14             	mov    0x14(%eax),%eax
80101059:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010105c:	8b 45 08             	mov    0x8(%ebp),%eax
8010105f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101066:	8b 45 08             	mov    0x8(%ebp),%eax
80101069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010106f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101076:	e8 1e 3b 00 00       	call   80104b99 <release>
  
  if(ff.type == FD_PIPE)
8010107b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107e:	83 f8 01             	cmp    $0x1,%eax
80101081:	75 18                	jne    8010109b <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101083:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101087:	0f be d0             	movsbl %al,%edx
8010108a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010108d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101091:	89 04 24             	mov    %eax,(%esp)
80101094:	e8 1a 2d 00 00       	call   80103db3 <pipeclose>
80101099:	eb 1d                	jmp    801010b8 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
8010109b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109e:	83 f8 02             	cmp    $0x2,%eax
801010a1:	75 15                	jne    801010b8 <fileclose+0xd4>
    begin_trans();
801010a3:	e8 b4 21 00 00       	call   8010325c <begin_trans>
    iput(ff.ip);
801010a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010ab:	89 04 24             	mov    %eax,(%esp)
801010ae:	e8 93 09 00 00       	call   80101a46 <iput>
    commit_trans();
801010b3:	e8 ed 21 00 00       	call   801032a5 <commit_trans>
  }
}
801010b8:	c9                   	leave  
801010b9:	c3                   	ret    

801010ba <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010ba:	55                   	push   %ebp
801010bb:	89 e5                	mov    %esp,%ebp
801010bd:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010c0:	8b 45 08             	mov    0x8(%ebp),%eax
801010c3:	8b 00                	mov    (%eax),%eax
801010c5:	83 f8 02             	cmp    $0x2,%eax
801010c8:	75 38                	jne    80101102 <filestat+0x48>
    ilock(f->ip);
801010ca:	8b 45 08             	mov    0x8(%ebp),%eax
801010cd:	8b 40 10             	mov    0x10(%eax),%eax
801010d0:	89 04 24             	mov    %eax,(%esp)
801010d3:	e8 bb 07 00 00       	call   80101893 <ilock>
    stati(f->ip, st);
801010d8:	8b 45 08             	mov    0x8(%ebp),%eax
801010db:	8b 40 10             	mov    0x10(%eax),%eax
801010de:	8b 55 0c             	mov    0xc(%ebp),%edx
801010e1:	89 54 24 04          	mov    %edx,0x4(%esp)
801010e5:	89 04 24             	mov    %eax,(%esp)
801010e8:	e8 6e 0c 00 00       	call   80101d5b <stati>
    iunlock(f->ip);
801010ed:	8b 45 08             	mov    0x8(%ebp),%eax
801010f0:	8b 40 10             	mov    0x10(%eax),%eax
801010f3:	89 04 24             	mov    %eax,(%esp)
801010f6:	e8 e6 08 00 00       	call   801019e1 <iunlock>
    return 0;
801010fb:	b8 00 00 00 00       	mov    $0x0,%eax
80101100:	eb 05                	jmp    80101107 <filestat+0x4d>
  }
  return -1;
80101102:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101107:	c9                   	leave  
80101108:	c3                   	ret    

80101109 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101109:	55                   	push   %ebp
8010110a:	89 e5                	mov    %esp,%ebp
8010110c:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010110f:	8b 45 08             	mov    0x8(%ebp),%eax
80101112:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101116:	84 c0                	test   %al,%al
80101118:	75 0a                	jne    80101124 <fileread+0x1b>
    return -1;
8010111a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010111f:	e9 9f 00 00 00       	jmp    801011c3 <fileread+0xba>
  if(f->type == FD_PIPE)
80101124:	8b 45 08             	mov    0x8(%ebp),%eax
80101127:	8b 00                	mov    (%eax),%eax
80101129:	83 f8 01             	cmp    $0x1,%eax
8010112c:	75 1e                	jne    8010114c <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010112e:	8b 45 08             	mov    0x8(%ebp),%eax
80101131:	8b 40 0c             	mov    0xc(%eax),%eax
80101134:	8b 55 10             	mov    0x10(%ebp),%edx
80101137:	89 54 24 08          	mov    %edx,0x8(%esp)
8010113b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010113e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101142:	89 04 24             	mov    %eax,(%esp)
80101145:	e8 ed 2d 00 00       	call   80103f37 <piperead>
8010114a:	eb 77                	jmp    801011c3 <fileread+0xba>
  if(f->type == FD_INODE){
8010114c:	8b 45 08             	mov    0x8(%ebp),%eax
8010114f:	8b 00                	mov    (%eax),%eax
80101151:	83 f8 02             	cmp    $0x2,%eax
80101154:	75 61                	jne    801011b7 <fileread+0xae>
    ilock(f->ip);
80101156:	8b 45 08             	mov    0x8(%ebp),%eax
80101159:	8b 40 10             	mov    0x10(%eax),%eax
8010115c:	89 04 24             	mov    %eax,(%esp)
8010115f:	e8 2f 07 00 00       	call   80101893 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101164:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101167:	8b 45 08             	mov    0x8(%ebp),%eax
8010116a:	8b 50 14             	mov    0x14(%eax),%edx
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	8b 40 10             	mov    0x10(%eax),%eax
80101173:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101177:	89 54 24 08          	mov    %edx,0x8(%esp)
8010117b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010117e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101182:	89 04 24             	mov    %eax,(%esp)
80101185:	e8 16 0c 00 00       	call   80101da0 <readi>
8010118a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010118d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101191:	7e 11                	jle    801011a4 <fileread+0x9b>
      f->off += r;
80101193:	8b 45 08             	mov    0x8(%ebp),%eax
80101196:	8b 50 14             	mov    0x14(%eax),%edx
80101199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010119c:	01 c2                	add    %eax,%edx
8010119e:	8b 45 08             	mov    0x8(%ebp),%eax
801011a1:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011a4:	8b 45 08             	mov    0x8(%ebp),%eax
801011a7:	8b 40 10             	mov    0x10(%eax),%eax
801011aa:	89 04 24             	mov    %eax,(%esp)
801011ad:	e8 2f 08 00 00       	call   801019e1 <iunlock>
    return r;
801011b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011b5:	eb 0c                	jmp    801011c3 <fileread+0xba>
  }
  panic("fileread");
801011b7:	c7 04 24 86 81 10 80 	movl   $0x80108186,(%esp)
801011be:	e8 83 f3 ff ff       	call   80100546 <panic>
}
801011c3:	c9                   	leave  
801011c4:	c3                   	ret    

801011c5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011c5:	55                   	push   %ebp
801011c6:	89 e5                	mov    %esp,%ebp
801011c8:	53                   	push   %ebx
801011c9:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011cc:	8b 45 08             	mov    0x8(%ebp),%eax
801011cf:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011d3:	84 c0                	test   %al,%al
801011d5:	75 0a                	jne    801011e1 <filewrite+0x1c>
    return -1;
801011d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011dc:	e9 23 01 00 00       	jmp    80101304 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011e1:	8b 45 08             	mov    0x8(%ebp),%eax
801011e4:	8b 00                	mov    (%eax),%eax
801011e6:	83 f8 01             	cmp    $0x1,%eax
801011e9:	75 21                	jne    8010120c <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011eb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ee:	8b 40 0c             	mov    0xc(%eax),%eax
801011f1:	8b 55 10             	mov    0x10(%ebp),%edx
801011f4:	89 54 24 08          	mov    %edx,0x8(%esp)
801011f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801011fb:	89 54 24 04          	mov    %edx,0x4(%esp)
801011ff:	89 04 24             	mov    %eax,(%esp)
80101202:	e8 3e 2c 00 00       	call   80103e45 <pipewrite>
80101207:	e9 f8 00 00 00       	jmp    80101304 <filewrite+0x13f>
  if(f->type == FD_INODE){
8010120c:	8b 45 08             	mov    0x8(%ebp),%eax
8010120f:	8b 00                	mov    (%eax),%eax
80101211:	83 f8 02             	cmp    $0x2,%eax
80101214:	0f 85 de 00 00 00    	jne    801012f8 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010121a:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101221:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101228:	e9 a8 00 00 00       	jmp    801012d5 <filewrite+0x110>
      int n1 = n - i;
8010122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101230:	8b 55 10             	mov    0x10(%ebp),%edx
80101233:	89 d1                	mov    %edx,%ecx
80101235:	29 c1                	sub    %eax,%ecx
80101237:	89 c8                	mov    %ecx,%eax
80101239:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010123c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010123f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101242:	7e 06                	jle    8010124a <filewrite+0x85>
        n1 = max;
80101244:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101247:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010124a:	e8 0d 20 00 00       	call   8010325c <begin_trans>
      ilock(f->ip);
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	8b 40 10             	mov    0x10(%eax),%eax
80101255:	89 04 24             	mov    %eax,(%esp)
80101258:	e8 36 06 00 00       	call   80101893 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010125d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101260:	8b 45 08             	mov    0x8(%ebp),%eax
80101263:	8b 50 14             	mov    0x14(%eax),%edx
80101266:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101269:	8b 45 0c             	mov    0xc(%ebp),%eax
8010126c:	01 c3                	add    %eax,%ebx
8010126e:	8b 45 08             	mov    0x8(%ebp),%eax
80101271:	8b 40 10             	mov    0x10(%eax),%eax
80101274:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101278:	89 54 24 08          	mov    %edx,0x8(%esp)
8010127c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101280:	89 04 24             	mov    %eax,(%esp)
80101283:	e8 7e 0c 00 00       	call   80101f06 <writei>
80101288:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010128b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010128f:	7e 11                	jle    801012a2 <filewrite+0xdd>
        f->off += r;
80101291:	8b 45 08             	mov    0x8(%ebp),%eax
80101294:	8b 50 14             	mov    0x14(%eax),%edx
80101297:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010129a:	01 c2                	add    %eax,%edx
8010129c:	8b 45 08             	mov    0x8(%ebp),%eax
8010129f:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012a2:	8b 45 08             	mov    0x8(%ebp),%eax
801012a5:	8b 40 10             	mov    0x10(%eax),%eax
801012a8:	89 04 24             	mov    %eax,(%esp)
801012ab:	e8 31 07 00 00       	call   801019e1 <iunlock>
      commit_trans();
801012b0:	e8 f0 1f 00 00       	call   801032a5 <commit_trans>

      if(r < 0)
801012b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012b9:	78 28                	js     801012e3 <filewrite+0x11e>
        break;
      if(r != n1)
801012bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012c1:	74 0c                	je     801012cf <filewrite+0x10a>
        panic("short filewrite");
801012c3:	c7 04 24 8f 81 10 80 	movl   $0x8010818f,(%esp)
801012ca:	e8 77 f2 ff ff       	call   80100546 <panic>
      i += r;
801012cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d2:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d8:	3b 45 10             	cmp    0x10(%ebp),%eax
801012db:	0f 8c 4c ff ff ff    	jl     8010122d <filewrite+0x68>
801012e1:	eb 01                	jmp    801012e4 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012e3:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ea:	75 05                	jne    801012f1 <filewrite+0x12c>
801012ec:	8b 45 10             	mov    0x10(%ebp),%eax
801012ef:	eb 05                	jmp    801012f6 <filewrite+0x131>
801012f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f6:	eb 0c                	jmp    80101304 <filewrite+0x13f>
  }
  panic("filewrite");
801012f8:	c7 04 24 9f 81 10 80 	movl   $0x8010819f,(%esp)
801012ff:	e8 42 f2 ff ff       	call   80100546 <panic>
}
80101304:	83 c4 24             	add    $0x24,%esp
80101307:	5b                   	pop    %ebx
80101308:	5d                   	pop    %ebp
80101309:	c3                   	ret    
	...

8010130c <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010130c:	55                   	push   %ebp
8010130d:	89 e5                	mov    %esp,%ebp
8010130f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101312:	8b 45 08             	mov    0x8(%ebp),%eax
80101315:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010131c:	00 
8010131d:	89 04 24             	mov    %eax,(%esp)
80101320:	e8 81 ee ff ff       	call   801001a6 <bread>
80101325:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132b:	83 c0 18             	add    $0x18,%eax
8010132e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101335:	00 
80101336:	89 44 24 04          	mov    %eax,0x4(%esp)
8010133a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010133d:	89 04 24             	mov    %eax,(%esp)
80101340:	e8 20 3b 00 00       	call   80104e65 <memmove>
  brelse(bp);
80101345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101348:	89 04 24             	mov    %eax,(%esp)
8010134b:	e8 c7 ee ff ff       	call   80100217 <brelse>
}
80101350:	c9                   	leave  
80101351:	c3                   	ret    

80101352 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101352:	55                   	push   %ebp
80101353:	89 e5                	mov    %esp,%ebp
80101355:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101358:	8b 55 0c             	mov    0xc(%ebp),%edx
8010135b:	8b 45 08             	mov    0x8(%ebp),%eax
8010135e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101362:	89 04 24             	mov    %eax,(%esp)
80101365:	e8 3c ee ff ff       	call   801001a6 <bread>
8010136a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010136d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101370:	83 c0 18             	add    $0x18,%eax
80101373:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010137a:	00 
8010137b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101382:	00 
80101383:	89 04 24             	mov    %eax,(%esp)
80101386:	e8 07 3a 00 00       	call   80104d92 <memset>
  log_write(bp);
8010138b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138e:	89 04 24             	mov    %eax,(%esp)
80101391:	e8 67 1f 00 00       	call   801032fd <log_write>
  brelse(bp);
80101396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101399:	89 04 24             	mov    %eax,(%esp)
8010139c:	e8 76 ee ff ff       	call   80100217 <brelse>
}
801013a1:	c9                   	leave  
801013a2:	c3                   	ret    

801013a3 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013a3:	55                   	push   %ebp
801013a4:	89 e5                	mov    %esp,%ebp
801013a6:	53                   	push   %ebx
801013a7:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013b1:	8b 45 08             	mov    0x8(%ebp),%eax
801013b4:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801013bb:	89 04 24             	mov    %eax,(%esp)
801013be:	e8 49 ff ff ff       	call   8010130c <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013ca:	e9 10 01 00 00       	jmp    801014df <balloc+0x13c>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d2:	89 c2                	mov    %eax,%edx
801013d4:	c1 fa 1f             	sar    $0x1f,%edx
801013d7:	c1 ea 14             	shr    $0x14,%edx
801013da:	01 d0                	add    %edx,%eax
801013dc:	c1 f8 0c             	sar    $0xc,%eax
801013df:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013e2:	c1 ea 03             	shr    $0x3,%edx
801013e5:	01 d0                	add    %edx,%eax
801013e7:	83 c0 03             	add    $0x3,%eax
801013ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ee:	8b 45 08             	mov    0x8(%ebp),%eax
801013f1:	89 04 24             	mov    %eax,(%esp)
801013f4:	e8 ad ed ff ff       	call   801001a6 <bread>
801013f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101403:	e9 a7 00 00 00       	jmp    801014af <balloc+0x10c>
      m = 1 << (bi % 8);
80101408:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010140b:	89 c2                	mov    %eax,%edx
8010140d:	c1 fa 1f             	sar    $0x1f,%edx
80101410:	c1 ea 1d             	shr    $0x1d,%edx
80101413:	01 d0                	add    %edx,%eax
80101415:	83 e0 07             	and    $0x7,%eax
80101418:	29 d0                	sub    %edx,%eax
8010141a:	ba 01 00 00 00       	mov    $0x1,%edx
8010141f:	89 d3                	mov    %edx,%ebx
80101421:	89 c1                	mov    %eax,%ecx
80101423:	d3 e3                	shl    %cl,%ebx
80101425:	89 d8                	mov    %ebx,%eax
80101427:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142d:	89 c2                	mov    %eax,%edx
8010142f:	c1 fa 1f             	sar    $0x1f,%edx
80101432:	c1 ea 1d             	shr    $0x1d,%edx
80101435:	01 d0                	add    %edx,%eax
80101437:	c1 f8 03             	sar    $0x3,%eax
8010143a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143d:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101442:	0f b6 c0             	movzbl %al,%eax
80101445:	23 45 e8             	and    -0x18(%ebp),%eax
80101448:	85 c0                	test   %eax,%eax
8010144a:	75 5f                	jne    801014ab <balloc+0x108>
        bp->data[bi/8] |= m;  // Mark block in use.
8010144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144f:	89 c2                	mov    %eax,%edx
80101451:	c1 fa 1f             	sar    $0x1f,%edx
80101454:	c1 ea 1d             	shr    $0x1d,%edx
80101457:	01 d0                	add    %edx,%eax
80101459:	c1 f8 03             	sar    $0x3,%eax
8010145c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145f:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101464:	89 d1                	mov    %edx,%ecx
80101466:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101469:	09 ca                	or     %ecx,%edx
8010146b:	89 d1                	mov    %edx,%ecx
8010146d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101470:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101474:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101477:	89 04 24             	mov    %eax,(%esp)
8010147a:	e8 7e 1e 00 00       	call   801032fd <log_write>
        brelse(bp);
8010147f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101482:	89 04 24             	mov    %eax,(%esp)
80101485:	e8 8d ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
8010148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101490:	01 c2                	add    %eax,%edx
80101492:	8b 45 08             	mov    0x8(%ebp),%eax
80101495:	89 54 24 04          	mov    %edx,0x4(%esp)
80101499:	89 04 24             	mov    %eax,(%esp)
8010149c:	e8 b1 fe ff ff       	call   80101352 <bzero>
        return b + bi;
801014a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a7:	01 d0                	add    %edx,%eax
801014a9:	eb 4e                	jmp    801014f9 <balloc+0x156>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014af:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014b6:	7f 15                	jg     801014cd <balloc+0x12a>
801014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014be:	01 d0                	add    %edx,%eax
801014c0:	89 c2                	mov    %eax,%edx
801014c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c5:	39 c2                	cmp    %eax,%edx
801014c7:	0f 82 3b ff ff ff    	jb     80101408 <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014d0:	89 04 24             	mov    %eax,(%esp)
801014d3:	e8 3f ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014d8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014e5:	39 c2                	cmp    %eax,%edx
801014e7:	0f 82 e2 fe ff ff    	jb     801013cf <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ed:	c7 04 24 a9 81 10 80 	movl   $0x801081a9,(%esp)
801014f4:	e8 4d f0 ff ff       	call   80100546 <panic>
}
801014f9:	83 c4 34             	add    $0x34,%esp
801014fc:	5b                   	pop    %ebx
801014fd:	5d                   	pop    %ebp
801014fe:	c3                   	ret    

801014ff <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014ff:	55                   	push   %ebp
80101500:	89 e5                	mov    %esp,%ebp
80101502:	53                   	push   %ebx
80101503:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101506:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101509:	89 44 24 04          	mov    %eax,0x4(%esp)
8010150d:	8b 45 08             	mov    0x8(%ebp),%eax
80101510:	89 04 24             	mov    %eax,(%esp)
80101513:	e8 f4 fd ff ff       	call   8010130c <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101518:	8b 45 0c             	mov    0xc(%ebp),%eax
8010151b:	89 c2                	mov    %eax,%edx
8010151d:	c1 ea 0c             	shr    $0xc,%edx
80101520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101523:	c1 e8 03             	shr    $0x3,%eax
80101526:	01 d0                	add    %edx,%eax
80101528:	8d 50 03             	lea    0x3(%eax),%edx
8010152b:	8b 45 08             	mov    0x8(%ebp),%eax
8010152e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101532:	89 04 24             	mov    %eax,(%esp)
80101535:	e8 6c ec ff ff       	call   801001a6 <bread>
8010153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010153d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101540:	25 ff 0f 00 00       	and    $0xfff,%eax
80101545:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101548:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154b:	89 c2                	mov    %eax,%edx
8010154d:	c1 fa 1f             	sar    $0x1f,%edx
80101550:	c1 ea 1d             	shr    $0x1d,%edx
80101553:	01 d0                	add    %edx,%eax
80101555:	83 e0 07             	and    $0x7,%eax
80101558:	29 d0                	sub    %edx,%eax
8010155a:	ba 01 00 00 00       	mov    $0x1,%edx
8010155f:	89 d3                	mov    %edx,%ebx
80101561:	89 c1                	mov    %eax,%ecx
80101563:	d3 e3                	shl    %cl,%ebx
80101565:	89 d8                	mov    %ebx,%eax
80101567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156d:	89 c2                	mov    %eax,%edx
8010156f:	c1 fa 1f             	sar    $0x1f,%edx
80101572:	c1 ea 1d             	shr    $0x1d,%edx
80101575:	01 d0                	add    %edx,%eax
80101577:	c1 f8 03             	sar    $0x3,%eax
8010157a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010157d:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101582:	0f b6 c0             	movzbl %al,%eax
80101585:	23 45 ec             	and    -0x14(%ebp),%eax
80101588:	85 c0                	test   %eax,%eax
8010158a:	75 0c                	jne    80101598 <bfree+0x99>
    panic("freeing free block");
8010158c:	c7 04 24 bf 81 10 80 	movl   $0x801081bf,(%esp)
80101593:	e8 ae ef ff ff       	call   80100546 <panic>
  bp->data[bi/8] &= ~m;
80101598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159b:	89 c2                	mov    %eax,%edx
8010159d:	c1 fa 1f             	sar    $0x1f,%edx
801015a0:	c1 ea 1d             	shr    $0x1d,%edx
801015a3:	01 d0                	add    %edx,%eax
801015a5:	c1 f8 03             	sar    $0x3,%eax
801015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ab:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015b0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015b3:	f7 d1                	not    %ecx
801015b5:	21 ca                	and    %ecx,%edx
801015b7:	89 d1                	mov    %edx,%ecx
801015b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015bc:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015c3:	89 04 24             	mov    %eax,(%esp)
801015c6:	e8 32 1d 00 00       	call   801032fd <log_write>
  brelse(bp);
801015cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ce:	89 04 24             	mov    %eax,(%esp)
801015d1:	e8 41 ec ff ff       	call   80100217 <brelse>
}
801015d6:	83 c4 34             	add    $0x34,%esp
801015d9:	5b                   	pop    %ebx
801015da:	5d                   	pop    %ebp
801015db:	c3                   	ret    

801015dc <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015dc:	55                   	push   %ebp
801015dd:	89 e5                	mov    %esp,%ebp
801015df:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015e2:	c7 44 24 04 d2 81 10 	movl   $0x801081d2,0x4(%esp)
801015e9:	80 
801015ea:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801015f1:	e8 20 35 00 00       	call   80104b16 <initlock>
}
801015f6:	c9                   	leave  
801015f7:	c3                   	ret    

801015f8 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015f8:	55                   	push   %ebp
801015f9:	89 e5                	mov    %esp,%ebp
801015fb:	83 ec 48             	sub    $0x48,%esp
801015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101601:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101605:	8b 45 08             	mov    0x8(%ebp),%eax
80101608:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010160b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010160f:	89 04 24             	mov    %eax,(%esp)
80101612:	e8 f5 fc ff ff       	call   8010130c <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101617:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010161e:	e9 98 00 00 00       	jmp    801016bb <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
80101623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101626:	c1 e8 03             	shr    $0x3,%eax
80101629:	83 c0 02             	add    $0x2,%eax
8010162c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101630:	8b 45 08             	mov    0x8(%ebp),%eax
80101633:	89 04 24             	mov    %eax,(%esp)
80101636:	e8 6b eb ff ff       	call   801001a6 <bread>
8010163b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101641:	8d 50 18             	lea    0x18(%eax),%edx
80101644:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101647:	83 e0 07             	and    $0x7,%eax
8010164a:	c1 e0 06             	shl    $0x6,%eax
8010164d:	01 d0                	add    %edx,%eax
8010164f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101652:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101655:	0f b7 00             	movzwl (%eax),%eax
80101658:	66 85 c0             	test   %ax,%ax
8010165b:	75 4f                	jne    801016ac <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
8010165d:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101664:	00 
80101665:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010166c:	00 
8010166d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101670:	89 04 24             	mov    %eax,(%esp)
80101673:	e8 1a 37 00 00       	call   80104d92 <memset>
      dip->type = type;
80101678:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010167b:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010167f:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101682:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101685:	89 04 24             	mov    %eax,(%esp)
80101688:	e8 70 1c 00 00       	call   801032fd <log_write>
      brelse(bp);
8010168d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101690:	89 04 24             	mov    %eax,(%esp)
80101693:	e8 7f eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010169b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010169f:	8b 45 08             	mov    0x8(%ebp),%eax
801016a2:	89 04 24             	mov    %eax,(%esp)
801016a5:	e8 e5 00 00 00       	call   8010178f <iget>
801016aa:	eb 29                	jmp    801016d5 <ialloc+0xdd>
    }
    brelse(bp);
801016ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016af:	89 04 24             	mov    %eax,(%esp)
801016b2:	e8 60 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016c1:	39 c2                	cmp    %eax,%edx
801016c3:	0f 82 5a ff ff ff    	jb     80101623 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016c9:	c7 04 24 d9 81 10 80 	movl   $0x801081d9,(%esp)
801016d0:	e8 71 ee ff ff       	call   80100546 <panic>
}
801016d5:	c9                   	leave  
801016d6:	c3                   	ret    

801016d7 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016d7:	55                   	push   %ebp
801016d8:	89 e5                	mov    %esp,%ebp
801016da:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016dd:	8b 45 08             	mov    0x8(%ebp),%eax
801016e0:	8b 40 04             	mov    0x4(%eax),%eax
801016e3:	c1 e8 03             	shr    $0x3,%eax
801016e6:	8d 50 02             	lea    0x2(%eax),%edx
801016e9:	8b 45 08             	mov    0x8(%ebp),%eax
801016ec:	8b 00                	mov    (%eax),%eax
801016ee:	89 54 24 04          	mov    %edx,0x4(%esp)
801016f2:	89 04 24             	mov    %eax,(%esp)
801016f5:	e8 ac ea ff ff       	call   801001a6 <bread>
801016fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101700:	8d 50 18             	lea    0x18(%eax),%edx
80101703:	8b 45 08             	mov    0x8(%ebp),%eax
80101706:	8b 40 04             	mov    0x4(%eax),%eax
80101709:	83 e0 07             	and    $0x7,%eax
8010170c:	c1 e0 06             	shl    $0x6,%eax
8010170f:	01 d0                	add    %edx,%eax
80101711:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101714:	8b 45 08             	mov    0x8(%ebp),%eax
80101717:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010171b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171e:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101721:	8b 45 08             	mov    0x8(%ebp),%eax
80101724:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101728:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172b:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010172f:	8b 45 08             	mov    0x8(%ebp),%eax
80101732:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101736:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101739:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010173d:	8b 45 08             	mov    0x8(%ebp),%eax
80101740:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101744:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101747:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010174b:	8b 45 08             	mov    0x8(%ebp),%eax
8010174e:	8b 50 18             	mov    0x18(%eax),%edx
80101751:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101754:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101757:	8b 45 08             	mov    0x8(%ebp),%eax
8010175a:	8d 50 1c             	lea    0x1c(%eax),%edx
8010175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101760:	83 c0 0c             	add    $0xc,%eax
80101763:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010176a:	00 
8010176b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010176f:	89 04 24             	mov    %eax,(%esp)
80101772:	e8 ee 36 00 00       	call   80104e65 <memmove>
  log_write(bp);
80101777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177a:	89 04 24             	mov    %eax,(%esp)
8010177d:	e8 7b 1b 00 00       	call   801032fd <log_write>
  brelse(bp);
80101782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101785:	89 04 24             	mov    %eax,(%esp)
80101788:	e8 8a ea ff ff       	call   80100217 <brelse>
}
8010178d:	c9                   	leave  
8010178e:	c3                   	ret    

8010178f <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010178f:	55                   	push   %ebp
80101790:	89 e5                	mov    %esp,%ebp
80101792:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101795:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010179c:	e8 96 33 00 00       	call   80104b37 <acquire>

  // Is the inode already cached?
  empty = 0;
801017a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017a8:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
801017af:	eb 59                	jmp    8010180a <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b4:	8b 40 08             	mov    0x8(%eax),%eax
801017b7:	85 c0                	test   %eax,%eax
801017b9:	7e 35                	jle    801017f0 <iget+0x61>
801017bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017be:	8b 00                	mov    (%eax),%eax
801017c0:	3b 45 08             	cmp    0x8(%ebp),%eax
801017c3:	75 2b                	jne    801017f0 <iget+0x61>
801017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c8:	8b 40 04             	mov    0x4(%eax),%eax
801017cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017ce:	75 20                	jne    801017f0 <iget+0x61>
      ip->ref++;
801017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d3:	8b 40 08             	mov    0x8(%eax),%eax
801017d6:	8d 50 01             	lea    0x1(%eax),%edx
801017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dc:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017df:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017e6:	e8 ae 33 00 00       	call   80104b99 <release>
      return ip;
801017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ee:	eb 6f                	jmp    8010185f <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017f4:	75 10                	jne    80101806 <iget+0x77>
801017f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f9:	8b 40 08             	mov    0x8(%eax),%eax
801017fc:	85 c0                	test   %eax,%eax
801017fe:	75 06                	jne    80101806 <iget+0x77>
      empty = ip;
80101800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101803:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101806:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010180a:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
80101811:	72 9e                	jb     801017b1 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101813:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101817:	75 0c                	jne    80101825 <iget+0x96>
    panic("iget: no inodes");
80101819:	c7 04 24 eb 81 10 80 	movl   $0x801081eb,(%esp)
80101820:	e8 21 ed ff ff       	call   80100546 <panic>

  ip = empty;
80101825:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182e:	8b 55 08             	mov    0x8(%ebp),%edx
80101831:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101836:	8b 55 0c             	mov    0xc(%ebp),%edx
80101839:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101849:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101850:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101857:	e8 3d 33 00 00       	call   80104b99 <release>

  return ip;
8010185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010185f:	c9                   	leave  
80101860:	c3                   	ret    

80101861 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101861:	55                   	push   %ebp
80101862:	89 e5                	mov    %esp,%ebp
80101864:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101867:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010186e:	e8 c4 32 00 00       	call   80104b37 <acquire>
  ip->ref++;
80101873:	8b 45 08             	mov    0x8(%ebp),%eax
80101876:	8b 40 08             	mov    0x8(%eax),%eax
80101879:	8d 50 01             	lea    0x1(%eax),%edx
8010187c:	8b 45 08             	mov    0x8(%ebp),%eax
8010187f:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101882:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101889:	e8 0b 33 00 00       	call   80104b99 <release>
  return ip;
8010188e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101891:	c9                   	leave  
80101892:	c3                   	ret    

80101893 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101893:	55                   	push   %ebp
80101894:	89 e5                	mov    %esp,%ebp
80101896:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101899:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010189d:	74 0a                	je     801018a9 <ilock+0x16>
8010189f:	8b 45 08             	mov    0x8(%ebp),%eax
801018a2:	8b 40 08             	mov    0x8(%eax),%eax
801018a5:	85 c0                	test   %eax,%eax
801018a7:	7f 0c                	jg     801018b5 <ilock+0x22>
    panic("ilock");
801018a9:	c7 04 24 fb 81 10 80 	movl   $0x801081fb,(%esp)
801018b0:	e8 91 ec ff ff       	call   80100546 <panic>

  acquire(&icache.lock);
801018b5:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018bc:	e8 76 32 00 00       	call   80104b37 <acquire>
  while(ip->flags & I_BUSY)
801018c1:	eb 13                	jmp    801018d6 <ilock+0x43>
    sleep(ip, &icache.lock);
801018c3:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
801018ca:	80 
801018cb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ce:	89 04 24             	mov    %eax,(%esp)
801018d1:	e8 84 2f 00 00       	call   8010485a <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018d6:	8b 45 08             	mov    0x8(%ebp),%eax
801018d9:	8b 40 0c             	mov    0xc(%eax),%eax
801018dc:	83 e0 01             	and    $0x1,%eax
801018df:	85 c0                	test   %eax,%eax
801018e1:	75 e0                	jne    801018c3 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018e3:	8b 45 08             	mov    0x8(%ebp),%eax
801018e6:	8b 40 0c             	mov    0xc(%eax),%eax
801018e9:	89 c2                	mov    %eax,%edx
801018eb:	83 ca 01             	or     $0x1,%edx
801018ee:	8b 45 08             	mov    0x8(%ebp),%eax
801018f1:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018f4:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018fb:	e8 99 32 00 00       	call   80104b99 <release>

  if(!(ip->flags & I_VALID)){
80101900:	8b 45 08             	mov    0x8(%ebp),%eax
80101903:	8b 40 0c             	mov    0xc(%eax),%eax
80101906:	83 e0 02             	and    $0x2,%eax
80101909:	85 c0                	test   %eax,%eax
8010190b:	0f 85 ce 00 00 00    	jne    801019df <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101911:	8b 45 08             	mov    0x8(%ebp),%eax
80101914:	8b 40 04             	mov    0x4(%eax),%eax
80101917:	c1 e8 03             	shr    $0x3,%eax
8010191a:	8d 50 02             	lea    0x2(%eax),%edx
8010191d:	8b 45 08             	mov    0x8(%ebp),%eax
80101920:	8b 00                	mov    (%eax),%eax
80101922:	89 54 24 04          	mov    %edx,0x4(%esp)
80101926:	89 04 24             	mov    %eax,(%esp)
80101929:	e8 78 e8 ff ff       	call   801001a6 <bread>
8010192e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101934:	8d 50 18             	lea    0x18(%eax),%edx
80101937:	8b 45 08             	mov    0x8(%ebp),%eax
8010193a:	8b 40 04             	mov    0x4(%eax),%eax
8010193d:	83 e0 07             	and    $0x7,%eax
80101940:	c1 e0 06             	shl    $0x6,%eax
80101943:	01 d0                	add    %edx,%eax
80101945:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101948:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194b:	0f b7 10             	movzwl (%eax),%edx
8010194e:	8b 45 08             	mov    0x8(%ebp),%eax
80101951:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101958:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010195c:	8b 45 08             	mov    0x8(%ebp),%eax
8010195f:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101963:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101966:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010196a:	8b 45 08             	mov    0x8(%ebp),%eax
8010196d:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101971:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101974:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101978:	8b 45 08             	mov    0x8(%ebp),%eax
8010197b:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
8010197f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101982:	8b 50 08             	mov    0x8(%eax),%edx
80101985:	8b 45 08             	mov    0x8(%ebp),%eax
80101988:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010198b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198e:	8d 50 0c             	lea    0xc(%eax),%edx
80101991:	8b 45 08             	mov    0x8(%ebp),%eax
80101994:	83 c0 1c             	add    $0x1c,%eax
80101997:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010199e:	00 
8010199f:	89 54 24 04          	mov    %edx,0x4(%esp)
801019a3:	89 04 24             	mov    %eax,(%esp)
801019a6:	e8 ba 34 00 00       	call   80104e65 <memmove>
    brelse(bp);
801019ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ae:	89 04 24             	mov    %eax,(%esp)
801019b1:	e8 61 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019b6:	8b 45 08             	mov    0x8(%ebp),%eax
801019b9:	8b 40 0c             	mov    0xc(%eax),%eax
801019bc:	89 c2                	mov    %eax,%edx
801019be:	83 ca 02             	or     $0x2,%edx
801019c1:	8b 45 08             	mov    0x8(%ebp),%eax
801019c4:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019c7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019ce:	66 85 c0             	test   %ax,%ax
801019d1:	75 0c                	jne    801019df <ilock+0x14c>
      panic("ilock: no type");
801019d3:	c7 04 24 01 82 10 80 	movl   $0x80108201,(%esp)
801019da:	e8 67 eb ff ff       	call   80100546 <panic>
  }
}
801019df:	c9                   	leave  
801019e0:	c3                   	ret    

801019e1 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019e1:	55                   	push   %ebp
801019e2:	89 e5                	mov    %esp,%ebp
801019e4:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019eb:	74 17                	je     80101a04 <iunlock+0x23>
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
801019f0:	8b 40 0c             	mov    0xc(%eax),%eax
801019f3:	83 e0 01             	and    $0x1,%eax
801019f6:	85 c0                	test   %eax,%eax
801019f8:	74 0a                	je     80101a04 <iunlock+0x23>
801019fa:	8b 45 08             	mov    0x8(%ebp),%eax
801019fd:	8b 40 08             	mov    0x8(%eax),%eax
80101a00:	85 c0                	test   %eax,%eax
80101a02:	7f 0c                	jg     80101a10 <iunlock+0x2f>
    panic("iunlock");
80101a04:	c7 04 24 10 82 10 80 	movl   $0x80108210,(%esp)
80101a0b:	e8 36 eb ff ff       	call   80100546 <panic>

  acquire(&icache.lock);
80101a10:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a17:	e8 1b 31 00 00       	call   80104b37 <acquire>
  ip->flags &= ~I_BUSY;
80101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a22:	89 c2                	mov    %eax,%edx
80101a24:	83 e2 fe             	and    $0xfffffffe,%edx
80101a27:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2a:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	89 04 24             	mov    %eax,(%esp)
80101a33:	e8 fb 2e 00 00       	call   80104933 <wakeup>
  release(&icache.lock);
80101a38:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a3f:	e8 55 31 00 00       	call   80104b99 <release>
}
80101a44:	c9                   	leave  
80101a45:	c3                   	ret    

80101a46 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a46:	55                   	push   %ebp
80101a47:	89 e5                	mov    %esp,%ebp
80101a49:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a4c:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a53:	e8 df 30 00 00       	call   80104b37 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5b:	8b 40 08             	mov    0x8(%eax),%eax
80101a5e:	83 f8 01             	cmp    $0x1,%eax
80101a61:	0f 85 93 00 00 00    	jne    80101afa <iput+0xb4>
80101a67:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6d:	83 e0 02             	and    $0x2,%eax
80101a70:	85 c0                	test   %eax,%eax
80101a72:	0f 84 82 00 00 00    	je     80101afa <iput+0xb4>
80101a78:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a7f:	66 85 c0             	test   %ax,%ax
80101a82:	75 76                	jne    80101afa <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a84:	8b 45 08             	mov    0x8(%ebp),%eax
80101a87:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8a:	83 e0 01             	and    $0x1,%eax
80101a8d:	85 c0                	test   %eax,%eax
80101a8f:	74 0c                	je     80101a9d <iput+0x57>
      panic("iput busy");
80101a91:	c7 04 24 18 82 10 80 	movl   $0x80108218,(%esp)
80101a98:	e8 a9 ea ff ff       	call   80100546 <panic>
    ip->flags |= I_BUSY;
80101a9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa0:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa3:	89 c2                	mov    %eax,%edx
80101aa5:	83 ca 01             	or     $0x1,%edx
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101aae:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101ab5:	e8 df 30 00 00       	call   80104b99 <release>
    itrunc(ip);
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	89 04 24             	mov    %eax,(%esp)
80101ac0:	e8 7d 01 00 00       	call   80101c42 <itrunc>
    ip->type = 0;
80101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac8:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	89 04 24             	mov    %eax,(%esp)
80101ad4:	e8 fe fb ff ff       	call   801016d7 <iupdate>
    acquire(&icache.lock);
80101ad9:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101ae0:	e8 52 30 00 00       	call   80104b37 <acquire>
    ip->flags = 0;
80101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101aef:	8b 45 08             	mov    0x8(%ebp),%eax
80101af2:	89 04 24             	mov    %eax,(%esp)
80101af5:	e8 39 2e 00 00       	call   80104933 <wakeup>
  }
  ip->ref--;
80101afa:	8b 45 08             	mov    0x8(%ebp),%eax
80101afd:	8b 40 08             	mov    0x8(%eax),%eax
80101b00:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b03:	8b 45 08             	mov    0x8(%ebp),%eax
80101b06:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b09:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101b10:	e8 84 30 00 00       	call   80104b99 <release>
}
80101b15:	c9                   	leave  
80101b16:	c3                   	ret    

80101b17 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b17:	55                   	push   %ebp
80101b18:	89 e5                	mov    %esp,%ebp
80101b1a:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b20:	89 04 24             	mov    %eax,(%esp)
80101b23:	e8 b9 fe ff ff       	call   801019e1 <iunlock>
  iput(ip);
80101b28:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2b:	89 04 24             	mov    %eax,(%esp)
80101b2e:	e8 13 ff ff ff       	call   80101a46 <iput>
}
80101b33:	c9                   	leave  
80101b34:	c3                   	ret    

80101b35 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b35:	55                   	push   %ebp
80101b36:	89 e5                	mov    %esp,%ebp
80101b38:	53                   	push   %ebx
80101b39:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b3c:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b40:	77 3e                	ja     80101b80 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b48:	83 c2 04             	add    $0x4,%edx
80101b4b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b56:	75 20                	jne    80101b78 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b58:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5b:	8b 00                	mov    (%eax),%eax
80101b5d:	89 04 24             	mov    %eax,(%esp)
80101b60:	e8 3e f8 ff ff       	call   801013a3 <balloc>
80101b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b6e:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b74:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b7b:	e9 bc 00 00 00       	jmp    80101c3c <bmap+0x107>
  }
  bn -= NDIRECT;
80101b80:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b84:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b88:	0f 87 a2 00 00 00    	ja     80101c30 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b91:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b9b:	75 19                	jne    80101bb6 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba0:	8b 00                	mov    (%eax),%eax
80101ba2:	89 04 24             	mov    %eax,(%esp)
80101ba5:	e8 f9 f7 ff ff       	call   801013a3 <balloc>
80101baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bb3:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb9:	8b 00                	mov    (%eax),%eax
80101bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bbe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bc2:	89 04 24             	mov    %eax,(%esp)
80101bc5:	e8 dc e5 ff ff       	call   801001a6 <bread>
80101bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd0:	83 c0 18             	add    $0x18,%eax
80101bd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101be3:	01 d0                	add    %edx,%eax
80101be5:	8b 00                	mov    (%eax),%eax
80101be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bee:	75 30                	jne    80101c20 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bf3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bfd:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c00:	8b 45 08             	mov    0x8(%ebp),%eax
80101c03:	8b 00                	mov    (%eax),%eax
80101c05:	89 04 24             	mov    %eax,(%esp)
80101c08:	e8 96 f7 ff ff       	call   801013a3 <balloc>
80101c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c13:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c18:	89 04 24             	mov    %eax,(%esp)
80101c1b:	e8 dd 16 00 00       	call   801032fd <log_write>
    }
    brelse(bp);
80101c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c23:	89 04 24             	mov    %eax,(%esp)
80101c26:	e8 ec e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c2e:	eb 0c                	jmp    80101c3c <bmap+0x107>
  }

  panic("bmap: out of range");
80101c30:	c7 04 24 22 82 10 80 	movl   $0x80108222,(%esp)
80101c37:	e8 0a e9 ff ff       	call   80100546 <panic>
}
80101c3c:	83 c4 24             	add    $0x24,%esp
80101c3f:	5b                   	pop    %ebx
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    

80101c42 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c42:	55                   	push   %ebp
80101c43:	89 e5                	mov    %esp,%ebp
80101c45:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c4f:	eb 44                	jmp    80101c95 <itrunc+0x53>
    if(ip->addrs[i]){
80101c51:	8b 45 08             	mov    0x8(%ebp),%eax
80101c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c57:	83 c2 04             	add    $0x4,%edx
80101c5a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c5e:	85 c0                	test   %eax,%eax
80101c60:	74 2f                	je     80101c91 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c68:	83 c2 04             	add    $0x4,%edx
80101c6b:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c72:	8b 00                	mov    (%eax),%eax
80101c74:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c78:	89 04 24             	mov    %eax,(%esp)
80101c7b:	e8 7f f8 ff ff       	call   801014ff <bfree>
      ip->addrs[i] = 0;
80101c80:	8b 45 08             	mov    0x8(%ebp),%eax
80101c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c86:	83 c2 04             	add    $0x4,%edx
80101c89:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c90:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c91:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c95:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c99:	7e b6                	jle    80101c51 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9e:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	0f 84 9b 00 00 00    	je     80101d44 <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 50 4c             	mov    0x4c(%eax),%edx
80101caf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb2:	8b 00                	mov    (%eax),%eax
80101cb4:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cb8:	89 04 24             	mov    %eax,(%esp)
80101cbb:	e8 e6 e4 ff ff       	call   801001a6 <bread>
80101cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cc6:	83 c0 18             	add    $0x18,%eax
80101cc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ccc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cd3:	eb 3b                	jmp    80101d10 <itrunc+0xce>
      if(a[j])
80101cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ce2:	01 d0                	add    %edx,%eax
80101ce4:	8b 00                	mov    (%eax),%eax
80101ce6:	85 c0                	test   %eax,%eax
80101ce8:	74 22                	je     80101d0c <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ced:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cf7:	01 d0                	add    %edx,%eax
80101cf9:	8b 10                	mov    (%eax),%edx
80101cfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfe:	8b 00                	mov    (%eax),%eax
80101d00:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d04:	89 04 24             	mov    %eax,(%esp)
80101d07:	e8 f3 f7 ff ff       	call   801014ff <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d0c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d13:	83 f8 7f             	cmp    $0x7f,%eax
80101d16:	76 bd                	jbe    80101cd5 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d1b:	89 04 24             	mov    %eax,(%esp)
80101d1e:	e8 f4 e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d23:	8b 45 08             	mov    0x8(%ebp),%eax
80101d26:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 00                	mov    (%eax),%eax
80101d2e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d32:	89 04 24             	mov    %eax,(%esp)
80101d35:	e8 c5 f7 ff ff       	call   801014ff <bfree>
    ip->addrs[NDIRECT] = 0;
80101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d44:	8b 45 08             	mov    0x8(%ebp),%eax
80101d47:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d51:	89 04 24             	mov    %eax,(%esp)
80101d54:	e8 7e f9 ff ff       	call   801016d7 <iupdate>
}
80101d59:	c9                   	leave  
80101d5a:	c3                   	ret    

80101d5b <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d5b:	55                   	push   %ebp
80101d5c:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d61:	8b 00                	mov    (%eax),%eax
80101d63:	89 c2                	mov    %eax,%edx
80101d65:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d68:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6e:	8b 50 04             	mov    0x4(%eax),%edx
80101d71:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d74:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d81:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d84:	8b 45 08             	mov    0x8(%ebp),%eax
80101d87:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d8e:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d92:	8b 45 08             	mov    0x8(%ebp),%eax
80101d95:	8b 50 18             	mov    0x18(%eax),%edx
80101d98:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d9b:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d9e:	5d                   	pop    %ebp
80101d9f:	c3                   	ret    

80101da0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101da6:	8b 45 08             	mov    0x8(%ebp),%eax
80101da9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101dad:	66 83 f8 03          	cmp    $0x3,%ax
80101db1:	75 60                	jne    80101e13 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101db3:	8b 45 08             	mov    0x8(%ebp),%eax
80101db6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dba:	66 85 c0             	test   %ax,%ax
80101dbd:	78 20                	js     80101ddf <readi+0x3f>
80101dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc6:	66 83 f8 09          	cmp    $0x9,%ax
80101dca:	7f 13                	jg     80101ddf <readi+0x3f>
80101dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dd3:	98                   	cwtl   
80101dd4:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101ddb:	85 c0                	test   %eax,%eax
80101ddd:	75 0a                	jne    80101de9 <readi+0x49>
      return -1;
80101ddf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de4:	e9 1b 01 00 00       	jmp    80101f04 <readi+0x164>
    return devsw[ip->major].read(ip, dst, n);
80101de9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dec:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101df0:	98                   	cwtl   
80101df1:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101df8:	8b 55 14             	mov    0x14(%ebp),%edx
80101dfb:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dff:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e02:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e06:	8b 55 08             	mov    0x8(%ebp),%edx
80101e09:	89 14 24             	mov    %edx,(%esp)
80101e0c:	ff d0                	call   *%eax
80101e0e:	e9 f1 00 00 00       	jmp    80101f04 <readi+0x164>
  }

  if(off > ip->size || off + n < off)
80101e13:	8b 45 08             	mov    0x8(%ebp),%eax
80101e16:	8b 40 18             	mov    0x18(%eax),%eax
80101e19:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e1c:	72 0d                	jb     80101e2b <readi+0x8b>
80101e1e:	8b 45 14             	mov    0x14(%ebp),%eax
80101e21:	8b 55 10             	mov    0x10(%ebp),%edx
80101e24:	01 d0                	add    %edx,%eax
80101e26:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e29:	73 0a                	jae    80101e35 <readi+0x95>
    return -1;
80101e2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e30:	e9 cf 00 00 00       	jmp    80101f04 <readi+0x164>
  if(off + n > ip->size)
80101e35:	8b 45 14             	mov    0x14(%ebp),%eax
80101e38:	8b 55 10             	mov    0x10(%ebp),%edx
80101e3b:	01 c2                	add    %eax,%edx
80101e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e40:	8b 40 18             	mov    0x18(%eax),%eax
80101e43:	39 c2                	cmp    %eax,%edx
80101e45:	76 0c                	jbe    80101e53 <readi+0xb3>
    n = ip->size - off;
80101e47:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4a:	8b 40 18             	mov    0x18(%eax),%eax
80101e4d:	2b 45 10             	sub    0x10(%ebp),%eax
80101e50:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e5a:	e9 96 00 00 00       	jmp    80101ef5 <readi+0x155>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e5f:	8b 45 10             	mov    0x10(%ebp),%eax
80101e62:	c1 e8 09             	shr    $0x9,%eax
80101e65:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e69:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6c:	89 04 24             	mov    %eax,(%esp)
80101e6f:	e8 c1 fc ff ff       	call   80101b35 <bmap>
80101e74:	8b 55 08             	mov    0x8(%ebp),%edx
80101e77:	8b 12                	mov    (%edx),%edx
80101e79:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7d:	89 14 24             	mov    %edx,(%esp)
80101e80:	e8 21 e3 ff ff       	call   801001a6 <bread>
80101e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e88:	8b 45 10             	mov    0x10(%ebp),%eax
80101e8b:	89 c2                	mov    %eax,%edx
80101e8d:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e93:	b8 00 02 00 00       	mov    $0x200,%eax
80101e98:	89 c1                	mov    %eax,%ecx
80101e9a:	29 d1                	sub    %edx,%ecx
80101e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e9f:	8b 55 14             	mov    0x14(%ebp),%edx
80101ea2:	29 c2                	sub    %eax,%edx
80101ea4:	89 c8                	mov    %ecx,%eax
80101ea6:	39 d0                	cmp    %edx,%eax
80101ea8:	76 02                	jbe    80101eac <readi+0x10c>
80101eaa:	89 d0                	mov    %edx,%eax
80101eac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101eaf:	8b 45 10             	mov    0x10(%ebp),%eax
80101eb2:	25 ff 01 00 00       	and    $0x1ff,%eax
80101eb7:	8d 50 10             	lea    0x10(%eax),%edx
80101eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ebd:	01 d0                	add    %edx,%eax
80101ebf:	8d 50 08             	lea    0x8(%eax),%edx
80101ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec5:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ec9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed0:	89 04 24             	mov    %eax,(%esp)
80101ed3:	e8 8d 2f 00 00       	call   80104e65 <memmove>
    brelse(bp);
80101ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101edb:	89 04 24             	mov    %eax,(%esp)
80101ede:	e8 34 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ee6:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eec:	01 45 10             	add    %eax,0x10(%ebp)
80101eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef2:	01 45 0c             	add    %eax,0xc(%ebp)
80101ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ef8:	3b 45 14             	cmp    0x14(%ebp),%eax
80101efb:	0f 82 5e ff ff ff    	jb     80101e5f <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f01:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f04:	c9                   	leave  
80101f05:	c3                   	ret    

80101f06 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f06:	55                   	push   %ebp
80101f07:	89 e5                	mov    %esp,%ebp
80101f09:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f13:	66 83 f8 03          	cmp    $0x3,%ax
80101f17:	75 60                	jne    80101f79 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f19:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f20:	66 85 c0             	test   %ax,%ax
80101f23:	78 20                	js     80101f45 <writei+0x3f>
80101f25:	8b 45 08             	mov    0x8(%ebp),%eax
80101f28:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2c:	66 83 f8 09          	cmp    $0x9,%ax
80101f30:	7f 13                	jg     80101f45 <writei+0x3f>
80101f32:	8b 45 08             	mov    0x8(%ebp),%eax
80101f35:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f39:	98                   	cwtl   
80101f3a:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f41:	85 c0                	test   %eax,%eax
80101f43:	75 0a                	jne    80101f4f <writei+0x49>
      return -1;
80101f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f4a:	e9 46 01 00 00       	jmp    80102095 <writei+0x18f>
    return devsw[ip->major].write(ip, src, n);
80101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f52:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f56:	98                   	cwtl   
80101f57:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f5e:	8b 55 14             	mov    0x14(%ebp),%edx
80101f61:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f65:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f68:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f6c:	8b 55 08             	mov    0x8(%ebp),%edx
80101f6f:	89 14 24             	mov    %edx,(%esp)
80101f72:	ff d0                	call   *%eax
80101f74:	e9 1c 01 00 00       	jmp    80102095 <writei+0x18f>
  }

  if(off > ip->size || off + n < off)
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	8b 40 18             	mov    0x18(%eax),%eax
80101f7f:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f82:	72 0d                	jb     80101f91 <writei+0x8b>
80101f84:	8b 45 14             	mov    0x14(%ebp),%eax
80101f87:	8b 55 10             	mov    0x10(%ebp),%edx
80101f8a:	01 d0                	add    %edx,%eax
80101f8c:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f8f:	73 0a                	jae    80101f9b <writei+0x95>
    return -1;
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	e9 fa 00 00 00       	jmp    80102095 <writei+0x18f>
  if(off + n > MAXFILE*BSIZE)
80101f9b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f9e:	8b 55 10             	mov    0x10(%ebp),%edx
80101fa1:	01 d0                	add    %edx,%eax
80101fa3:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fa8:	76 0a                	jbe    80101fb4 <writei+0xae>
    return -1;
80101faa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101faf:	e9 e1 00 00 00       	jmp    80102095 <writei+0x18f>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fbb:	e9 a1 00 00 00       	jmp    80102061 <writei+0x15b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc3:	c1 e8 09             	shr    $0x9,%eax
80101fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fca:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcd:	89 04 24             	mov    %eax,(%esp)
80101fd0:	e8 60 fb ff ff       	call   80101b35 <bmap>
80101fd5:	8b 55 08             	mov    0x8(%ebp),%edx
80101fd8:	8b 12                	mov    (%edx),%edx
80101fda:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fde:	89 14 24             	mov    %edx,(%esp)
80101fe1:	e8 c0 e1 ff ff       	call   801001a6 <bread>
80101fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe9:	8b 45 10             	mov    0x10(%ebp),%eax
80101fec:	89 c2                	mov    %eax,%edx
80101fee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101ff4:	b8 00 02 00 00       	mov    $0x200,%eax
80101ff9:	89 c1                	mov    %eax,%ecx
80101ffb:	29 d1                	sub    %edx,%ecx
80101ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102000:	8b 55 14             	mov    0x14(%ebp),%edx
80102003:	29 c2                	sub    %eax,%edx
80102005:	89 c8                	mov    %ecx,%eax
80102007:	39 d0                	cmp    %edx,%eax
80102009:	76 02                	jbe    8010200d <writei+0x107>
8010200b:	89 d0                	mov    %edx,%eax
8010200d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102010:	8b 45 10             	mov    0x10(%ebp),%eax
80102013:	25 ff 01 00 00       	and    $0x1ff,%eax
80102018:	8d 50 10             	lea    0x10(%eax),%edx
8010201b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010201e:	01 d0                	add    %edx,%eax
80102020:	8d 50 08             	lea    0x8(%eax),%edx
80102023:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102026:	89 44 24 08          	mov    %eax,0x8(%esp)
8010202a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010202d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102031:	89 14 24             	mov    %edx,(%esp)
80102034:	e8 2c 2e 00 00       	call   80104e65 <memmove>
    log_write(bp);
80102039:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010203c:	89 04 24             	mov    %eax,(%esp)
8010203f:	e8 b9 12 00 00       	call   801032fd <log_write>
    brelse(bp);
80102044:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102047:	89 04 24             	mov    %eax,(%esp)
8010204a:	e8 c8 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010204f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102052:	01 45 f4             	add    %eax,-0xc(%ebp)
80102055:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102058:	01 45 10             	add    %eax,0x10(%ebp)
8010205b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010205e:	01 45 0c             	add    %eax,0xc(%ebp)
80102061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102064:	3b 45 14             	cmp    0x14(%ebp),%eax
80102067:	0f 82 53 ff ff ff    	jb     80101fc0 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010206d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102071:	74 1f                	je     80102092 <writei+0x18c>
80102073:	8b 45 08             	mov    0x8(%ebp),%eax
80102076:	8b 40 18             	mov    0x18(%eax),%eax
80102079:	3b 45 10             	cmp    0x10(%ebp),%eax
8010207c:	73 14                	jae    80102092 <writei+0x18c>
    ip->size = off;
8010207e:	8b 45 08             	mov    0x8(%ebp),%eax
80102081:	8b 55 10             	mov    0x10(%ebp),%edx
80102084:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102087:	8b 45 08             	mov    0x8(%ebp),%eax
8010208a:	89 04 24             	mov    %eax,(%esp)
8010208d:	e8 45 f6 ff ff       	call   801016d7 <iupdate>
  }
  return n;
80102092:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102095:	c9                   	leave  
80102096:	c3                   	ret    

80102097 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102097:	55                   	push   %ebp
80102098:	89 e5                	mov    %esp,%ebp
8010209a:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010209d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020a4:	00 
801020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ac:	8b 45 08             	mov    0x8(%ebp),%eax
801020af:	89 04 24             	mov    %eax,(%esp)
801020b2:	e8 52 2e 00 00       	call   80104f09 <strncmp>
}
801020b7:	c9                   	leave  
801020b8:	c3                   	ret    

801020b9 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020b9:	55                   	push   %ebp
801020ba:	89 e5                	mov    %esp,%ebp
801020bc:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020bf:	8b 45 08             	mov    0x8(%ebp),%eax
801020c2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020c6:	66 83 f8 01          	cmp    $0x1,%ax
801020ca:	74 0c                	je     801020d8 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020cc:	c7 04 24 35 82 10 80 	movl   $0x80108235,(%esp)
801020d3:	e8 6e e4 ff ff       	call   80100546 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020df:	e9 87 00 00 00       	jmp    8010216b <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020e4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020eb:	00 
801020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ef:	89 44 24 08          	mov    %eax,0x8(%esp)
801020f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801020fa:	8b 45 08             	mov    0x8(%ebp),%eax
801020fd:	89 04 24             	mov    %eax,(%esp)
80102100:	e8 9b fc ff ff       	call   80101da0 <readi>
80102105:	83 f8 10             	cmp    $0x10,%eax
80102108:	74 0c                	je     80102116 <dirlookup+0x5d>
      panic("dirlink read");
8010210a:	c7 04 24 47 82 10 80 	movl   $0x80108247,(%esp)
80102111:	e8 30 e4 ff ff       	call   80100546 <panic>
    if(de.inum == 0)
80102116:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010211a:	66 85 c0             	test   %ax,%ax
8010211d:	74 47                	je     80102166 <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
8010211f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102122:	83 c0 02             	add    $0x2,%eax
80102125:	89 44 24 04          	mov    %eax,0x4(%esp)
80102129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010212c:	89 04 24             	mov    %eax,(%esp)
8010212f:	e8 63 ff ff ff       	call   80102097 <namecmp>
80102134:	85 c0                	test   %eax,%eax
80102136:	75 2f                	jne    80102167 <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102138:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010213c:	74 08                	je     80102146 <dirlookup+0x8d>
        *poff = off;
8010213e:	8b 45 10             	mov    0x10(%ebp),%eax
80102141:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102144:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102146:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010214a:	0f b7 c0             	movzwl %ax,%eax
8010214d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	8b 00                	mov    (%eax),%eax
80102155:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102158:	89 54 24 04          	mov    %edx,0x4(%esp)
8010215c:	89 04 24             	mov    %eax,(%esp)
8010215f:	e8 2b f6 ff ff       	call   8010178f <iget>
80102164:	eb 19                	jmp    8010217f <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102166:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102167:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010216b:	8b 45 08             	mov    0x8(%ebp),%eax
8010216e:	8b 40 18             	mov    0x18(%eax),%eax
80102171:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102174:	0f 87 6a ff ff ff    	ja     801020e4 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010217a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010217f:	c9                   	leave  
80102180:	c3                   	ret    

80102181 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102181:	55                   	push   %ebp
80102182:	89 e5                	mov    %esp,%ebp
80102184:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102187:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010218e:	00 
8010218f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102192:	89 44 24 04          	mov    %eax,0x4(%esp)
80102196:	8b 45 08             	mov    0x8(%ebp),%eax
80102199:	89 04 24             	mov    %eax,(%esp)
8010219c:	e8 18 ff ff ff       	call   801020b9 <dirlookup>
801021a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021a8:	74 15                	je     801021bf <dirlink+0x3e>
    iput(ip);
801021aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021ad:	89 04 24             	mov    %eax,(%esp)
801021b0:	e8 91 f8 ff ff       	call   80101a46 <iput>
    return -1;
801021b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021ba:	e9 b8 00 00 00       	jmp    80102277 <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021c6:	eb 44                	jmp    8010220c <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021cb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021d2:	00 
801021d3:	89 44 24 08          	mov    %eax,0x8(%esp)
801021d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021da:	89 44 24 04          	mov    %eax,0x4(%esp)
801021de:	8b 45 08             	mov    0x8(%ebp),%eax
801021e1:	89 04 24             	mov    %eax,(%esp)
801021e4:	e8 b7 fb ff ff       	call   80101da0 <readi>
801021e9:	83 f8 10             	cmp    $0x10,%eax
801021ec:	74 0c                	je     801021fa <dirlink+0x79>
      panic("dirlink read");
801021ee:	c7 04 24 47 82 10 80 	movl   $0x80108247,(%esp)
801021f5:	e8 4c e3 ff ff       	call   80100546 <panic>
    if(de.inum == 0)
801021fa:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021fe:	66 85 c0             	test   %ax,%ax
80102201:	74 18                	je     8010221b <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102206:	83 c0 10             	add    $0x10,%eax
80102209:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010220c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010220f:	8b 45 08             	mov    0x8(%ebp),%eax
80102212:	8b 40 18             	mov    0x18(%eax),%eax
80102215:	39 c2                	cmp    %eax,%edx
80102217:	72 af                	jb     801021c8 <dirlink+0x47>
80102219:	eb 01                	jmp    8010221c <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
8010221b:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010221c:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102223:	00 
80102224:	8b 45 0c             	mov    0xc(%ebp),%eax
80102227:	89 44 24 04          	mov    %eax,0x4(%esp)
8010222b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222e:	83 c0 02             	add    $0x2,%eax
80102231:	89 04 24             	mov    %eax,(%esp)
80102234:	e8 28 2d 00 00       	call   80104f61 <strncpy>
  de.inum = inum;
80102239:	8b 45 10             	mov    0x10(%ebp),%eax
8010223c:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102243:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010224a:	00 
8010224b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010224f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102252:	89 44 24 04          	mov    %eax,0x4(%esp)
80102256:	8b 45 08             	mov    0x8(%ebp),%eax
80102259:	89 04 24             	mov    %eax,(%esp)
8010225c:	e8 a5 fc ff ff       	call   80101f06 <writei>
80102261:	83 f8 10             	cmp    $0x10,%eax
80102264:	74 0c                	je     80102272 <dirlink+0xf1>
    panic("dirlink");
80102266:	c7 04 24 54 82 10 80 	movl   $0x80108254,(%esp)
8010226d:	e8 d4 e2 ff ff       	call   80100546 <panic>
  
  return 0;
80102272:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102277:	c9                   	leave  
80102278:	c3                   	ret    

80102279 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102279:	55                   	push   %ebp
8010227a:	89 e5                	mov    %esp,%ebp
8010227c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010227f:	eb 04                	jmp    80102285 <skipelem+0xc>
    path++;
80102281:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102285:	8b 45 08             	mov    0x8(%ebp),%eax
80102288:	0f b6 00             	movzbl (%eax),%eax
8010228b:	3c 2f                	cmp    $0x2f,%al
8010228d:	74 f2                	je     80102281 <skipelem+0x8>
    path++;
  if(*path == 0)
8010228f:	8b 45 08             	mov    0x8(%ebp),%eax
80102292:	0f b6 00             	movzbl (%eax),%eax
80102295:	84 c0                	test   %al,%al
80102297:	75 0a                	jne    801022a3 <skipelem+0x2a>
    return 0;
80102299:	b8 00 00 00 00       	mov    $0x0,%eax
8010229e:	e9 88 00 00 00       	jmp    8010232b <skipelem+0xb2>
  s = path;
801022a3:	8b 45 08             	mov    0x8(%ebp),%eax
801022a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022a9:	eb 04                	jmp    801022af <skipelem+0x36>
    path++;
801022ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022af:	8b 45 08             	mov    0x8(%ebp),%eax
801022b2:	0f b6 00             	movzbl (%eax),%eax
801022b5:	3c 2f                	cmp    $0x2f,%al
801022b7:	74 0a                	je     801022c3 <skipelem+0x4a>
801022b9:	8b 45 08             	mov    0x8(%ebp),%eax
801022bc:	0f b6 00             	movzbl (%eax),%eax
801022bf:	84 c0                	test   %al,%al
801022c1:	75 e8                	jne    801022ab <skipelem+0x32>
    path++;
  len = path - s;
801022c3:	8b 55 08             	mov    0x8(%ebp),%edx
801022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c9:	89 d1                	mov    %edx,%ecx
801022cb:	29 c1                	sub    %eax,%ecx
801022cd:	89 c8                	mov    %ecx,%eax
801022cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022d6:	7e 1c                	jle    801022f4 <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801022d8:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022df:	00 
801022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ea:	89 04 24             	mov    %eax,(%esp)
801022ed:	e8 73 2b 00 00       	call   80104e65 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022f2:	eb 2a                	jmp    8010231e <skipelem+0xa5>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102302:	8b 45 0c             	mov    0xc(%ebp),%eax
80102305:	89 04 24             	mov    %eax,(%esp)
80102308:	e8 58 2b 00 00       	call   80104e65 <memmove>
    name[len] = 0;
8010230d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102310:	8b 45 0c             	mov    0xc(%ebp),%eax
80102313:	01 d0                	add    %edx,%eax
80102315:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102318:	eb 04                	jmp    8010231e <skipelem+0xa5>
    path++;
8010231a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010231e:	8b 45 08             	mov    0x8(%ebp),%eax
80102321:	0f b6 00             	movzbl (%eax),%eax
80102324:	3c 2f                	cmp    $0x2f,%al
80102326:	74 f2                	je     8010231a <skipelem+0xa1>
    path++;
  return path;
80102328:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010232b:	c9                   	leave  
8010232c:	c3                   	ret    

8010232d <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010232d:	55                   	push   %ebp
8010232e:	89 e5                	mov    %esp,%ebp
80102330:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102333:	8b 45 08             	mov    0x8(%ebp),%eax
80102336:	0f b6 00             	movzbl (%eax),%eax
80102339:	3c 2f                	cmp    $0x2f,%al
8010233b:	75 1c                	jne    80102359 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
8010233d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102344:	00 
80102345:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010234c:	e8 3e f4 ff ff       	call   8010178f <iget>
80102351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102354:	e9 af 00 00 00       	jmp    80102408 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102359:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010235f:	8b 40 68             	mov    0x68(%eax),%eax
80102362:	89 04 24             	mov    %eax,(%esp)
80102365:	e8 f7 f4 ff ff       	call   80101861 <idup>
8010236a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010236d:	e9 96 00 00 00       	jmp    80102408 <namex+0xdb>
    ilock(ip);
80102372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102375:	89 04 24             	mov    %eax,(%esp)
80102378:	e8 16 f5 ff ff       	call   80101893 <ilock>
    if(ip->type != T_DIR){
8010237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102380:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102384:	66 83 f8 01          	cmp    $0x1,%ax
80102388:	74 15                	je     8010239f <namex+0x72>
      iunlockput(ip);
8010238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010238d:	89 04 24             	mov    %eax,(%esp)
80102390:	e8 82 f7 ff ff       	call   80101b17 <iunlockput>
      return 0;
80102395:	b8 00 00 00 00       	mov    $0x0,%eax
8010239a:	e9 a3 00 00 00       	jmp    80102442 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
8010239f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023a3:	74 1d                	je     801023c2 <namex+0x95>
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
801023a8:	0f b6 00             	movzbl (%eax),%eax
801023ab:	84 c0                	test   %al,%al
801023ad:	75 13                	jne    801023c2 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b2:	89 04 24             	mov    %eax,(%esp)
801023b5:	e8 27 f6 ff ff       	call   801019e1 <iunlock>
      return ip;
801023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023bd:	e9 80 00 00 00       	jmp    80102442 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023c9:	00 
801023ca:	8b 45 10             	mov    0x10(%ebp),%eax
801023cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d4:	89 04 24             	mov    %eax,(%esp)
801023d7:	e8 dd fc ff ff       	call   801020b9 <dirlookup>
801023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023e3:	75 12                	jne    801023f7 <namex+0xca>
      iunlockput(ip);
801023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e8:	89 04 24             	mov    %eax,(%esp)
801023eb:	e8 27 f7 ff ff       	call   80101b17 <iunlockput>
      return 0;
801023f0:	b8 00 00 00 00       	mov    $0x0,%eax
801023f5:	eb 4b                	jmp    80102442 <namex+0x115>
    }
    iunlockput(ip);
801023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023fa:	89 04 24             	mov    %eax,(%esp)
801023fd:	e8 15 f7 ff ff       	call   80101b17 <iunlockput>
    ip = next;
80102402:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102405:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102408:	8b 45 10             	mov    0x10(%ebp),%eax
8010240b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
80102412:	89 04 24             	mov    %eax,(%esp)
80102415:	e8 5f fe ff ff       	call   80102279 <skipelem>
8010241a:	89 45 08             	mov    %eax,0x8(%ebp)
8010241d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102421:	0f 85 4b ff ff ff    	jne    80102372 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010242b:	74 12                	je     8010243f <namex+0x112>
    iput(ip);
8010242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102430:	89 04 24             	mov    %eax,(%esp)
80102433:	e8 0e f6 ff ff       	call   80101a46 <iput>
    return 0;
80102438:	b8 00 00 00 00       	mov    $0x0,%eax
8010243d:	eb 03                	jmp    80102442 <namex+0x115>
  }
  return ip;
8010243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102442:	c9                   	leave  
80102443:	c3                   	ret    

80102444 <namei>:

struct inode*
namei(char *path)
{
80102444:	55                   	push   %ebp
80102445:	89 e5                	mov    %esp,%ebp
80102447:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010244a:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010244d:	89 44 24 08          	mov    %eax,0x8(%esp)
80102451:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102458:	00 
80102459:	8b 45 08             	mov    0x8(%ebp),%eax
8010245c:	89 04 24             	mov    %eax,(%esp)
8010245f:	e8 c9 fe ff ff       	call   8010232d <namex>
}
80102464:	c9                   	leave  
80102465:	c3                   	ret    

80102466 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102466:	55                   	push   %ebp
80102467:	89 e5                	mov    %esp,%ebp
80102469:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010246c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010246f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102473:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010247a:	00 
8010247b:	8b 45 08             	mov    0x8(%ebp),%eax
8010247e:	89 04 24             	mov    %eax,(%esp)
80102481:	e8 a7 fe ff ff       	call   8010232d <namex>
}
80102486:	c9                   	leave  
80102487:	c3                   	ret    

80102488 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102488:	55                   	push   %ebp
80102489:	89 e5                	mov    %esp,%ebp
8010248b:	53                   	push   %ebx
8010248c:	83 ec 14             	sub    $0x14,%esp
8010248f:	8b 45 08             	mov    0x8(%ebp),%eax
80102492:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102496:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
8010249a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010249e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801024a2:	ec                   	in     (%dx),%al
801024a3:	89 c3                	mov    %eax,%ebx
801024a5:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801024a8:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801024ac:	83 c4 14             	add    $0x14,%esp
801024af:	5b                   	pop    %ebx
801024b0:	5d                   	pop    %ebp
801024b1:	c3                   	ret    

801024b2 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024b2:	55                   	push   %ebp
801024b3:	89 e5                	mov    %esp,%ebp
801024b5:	57                   	push   %edi
801024b6:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024b7:	8b 55 08             	mov    0x8(%ebp),%edx
801024ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024bd:	8b 45 10             	mov    0x10(%ebp),%eax
801024c0:	89 cb                	mov    %ecx,%ebx
801024c2:	89 df                	mov    %ebx,%edi
801024c4:	89 c1                	mov    %eax,%ecx
801024c6:	fc                   	cld    
801024c7:	f3 6d                	rep insl (%dx),%es:(%edi)
801024c9:	89 c8                	mov    %ecx,%eax
801024cb:	89 fb                	mov    %edi,%ebx
801024cd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024d0:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024d3:	5b                   	pop    %ebx
801024d4:	5f                   	pop    %edi
801024d5:	5d                   	pop    %ebp
801024d6:	c3                   	ret    

801024d7 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024d7:	55                   	push   %ebp
801024d8:	89 e5                	mov    %esp,%ebp
801024da:	83 ec 08             	sub    $0x8,%esp
801024dd:	8b 55 08             	mov    0x8(%ebp),%edx
801024e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801024e3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024e7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024ea:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024ee:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024f2:	ee                   	out    %al,(%dx)
}
801024f3:	c9                   	leave  
801024f4:	c3                   	ret    

801024f5 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024f5:	55                   	push   %ebp
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	56                   	push   %esi
801024f9:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024fa:	8b 55 08             	mov    0x8(%ebp),%edx
801024fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102500:	8b 45 10             	mov    0x10(%ebp),%eax
80102503:	89 cb                	mov    %ecx,%ebx
80102505:	89 de                	mov    %ebx,%esi
80102507:	89 c1                	mov    %eax,%ecx
80102509:	fc                   	cld    
8010250a:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010250c:	89 c8                	mov    %ecx,%eax
8010250e:	89 f3                	mov    %esi,%ebx
80102510:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102513:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102516:	5b                   	pop    %ebx
80102517:	5e                   	pop    %esi
80102518:	5d                   	pop    %ebp
80102519:	c3                   	ret    

8010251a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010251a:	55                   	push   %ebp
8010251b:	89 e5                	mov    %esp,%ebp
8010251d:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102520:	90                   	nop
80102521:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102528:	e8 5b ff ff ff       	call   80102488 <inb>
8010252d:	0f b6 c0             	movzbl %al,%eax
80102530:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102533:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102536:	25 c0 00 00 00       	and    $0xc0,%eax
8010253b:	83 f8 40             	cmp    $0x40,%eax
8010253e:	75 e1                	jne    80102521 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102540:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102544:	74 11                	je     80102557 <idewait+0x3d>
80102546:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102549:	83 e0 21             	and    $0x21,%eax
8010254c:	85 c0                	test   %eax,%eax
8010254e:	74 07                	je     80102557 <idewait+0x3d>
    return -1;
80102550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102555:	eb 05                	jmp    8010255c <idewait+0x42>
  return 0;
80102557:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010255c:	c9                   	leave  
8010255d:	c3                   	ret    

8010255e <ideinit>:

void
ideinit(void)
{
8010255e:	55                   	push   %ebp
8010255f:	89 e5                	mov    %esp,%ebp
80102561:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102564:	c7 44 24 04 5c 82 10 	movl   $0x8010825c,0x4(%esp)
8010256b:	80 
8010256c:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102573:	e8 9e 25 00 00       	call   80104b16 <initlock>
  picenable(IRQ_IDE);
80102578:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010257f:	e8 75 15 00 00       	call   80103af9 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102584:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80102589:	83 e8 01             	sub    $0x1,%eax
8010258c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102590:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102597:	e8 12 04 00 00       	call   801029ae <ioapicenable>
  idewait(0);
8010259c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025a3:	e8 72 ff ff ff       	call   8010251a <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025a8:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025af:	00 
801025b0:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025b7:	e8 1b ff ff ff       	call   801024d7 <outb>
  for(i=0; i<1000; i++){
801025bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025c3:	eb 20                	jmp    801025e5 <ideinit+0x87>
    if(inb(0x1f7) != 0){
801025c5:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025cc:	e8 b7 fe ff ff       	call   80102488 <inb>
801025d1:	84 c0                	test   %al,%al
801025d3:	74 0c                	je     801025e1 <ideinit+0x83>
      havedisk1 = 1;
801025d5:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801025dc:	00 00 00 
      break;
801025df:	eb 0d                	jmp    801025ee <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025e5:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025ec:	7e d7                	jle    801025c5 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025ee:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025f5:	00 
801025f6:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025fd:	e8 d5 fe ff ff       	call   801024d7 <outb>
}
80102602:	c9                   	leave  
80102603:	c3                   	ret    

80102604 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102604:	55                   	push   %ebp
80102605:	89 e5                	mov    %esp,%ebp
80102607:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010260a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010260e:	75 0c                	jne    8010261c <idestart+0x18>
    panic("idestart");
80102610:	c7 04 24 60 82 10 80 	movl   $0x80108260,(%esp)
80102617:	e8 2a df ff ff       	call   80100546 <panic>

  idewait(0);
8010261c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102623:	e8 f2 fe ff ff       	call   8010251a <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102628:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010262f:	00 
80102630:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102637:	e8 9b fe ff ff       	call   801024d7 <outb>
  outb(0x1f2, 1);  // number of sectors
8010263c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102643:	00 
80102644:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010264b:	e8 87 fe ff ff       	call   801024d7 <outb>
  outb(0x1f3, b->sector & 0xff);
80102650:	8b 45 08             	mov    0x8(%ebp),%eax
80102653:	8b 40 08             	mov    0x8(%eax),%eax
80102656:	0f b6 c0             	movzbl %al,%eax
80102659:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265d:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102664:	e8 6e fe ff ff       	call   801024d7 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
8010266c:	8b 40 08             	mov    0x8(%eax),%eax
8010266f:	c1 e8 08             	shr    $0x8,%eax
80102672:	0f b6 c0             	movzbl %al,%eax
80102675:	89 44 24 04          	mov    %eax,0x4(%esp)
80102679:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102680:	e8 52 fe ff ff       	call   801024d7 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
80102688:	8b 40 08             	mov    0x8(%eax),%eax
8010268b:	c1 e8 10             	shr    $0x10,%eax
8010268e:	0f b6 c0             	movzbl %al,%eax
80102691:	89 44 24 04          	mov    %eax,0x4(%esp)
80102695:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010269c:	e8 36 fe ff ff       	call   801024d7 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801026a1:	8b 45 08             	mov    0x8(%ebp),%eax
801026a4:	8b 40 04             	mov    0x4(%eax),%eax
801026a7:	83 e0 01             	and    $0x1,%eax
801026aa:	89 c2                	mov    %eax,%edx
801026ac:	c1 e2 04             	shl    $0x4,%edx
801026af:	8b 45 08             	mov    0x8(%ebp),%eax
801026b2:	8b 40 08             	mov    0x8(%eax),%eax
801026b5:	c1 e8 18             	shr    $0x18,%eax
801026b8:	83 e0 0f             	and    $0xf,%eax
801026bb:	09 d0                	or     %edx,%eax
801026bd:	83 c8 e0             	or     $0xffffffe0,%eax
801026c0:	0f b6 c0             	movzbl %al,%eax
801026c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c7:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026ce:	e8 04 fe ff ff       	call   801024d7 <outb>
  if(b->flags & B_DIRTY){
801026d3:	8b 45 08             	mov    0x8(%ebp),%eax
801026d6:	8b 00                	mov    (%eax),%eax
801026d8:	83 e0 04             	and    $0x4,%eax
801026db:	85 c0                	test   %eax,%eax
801026dd:	74 34                	je     80102713 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026df:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026e6:	00 
801026e7:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026ee:	e8 e4 fd ff ff       	call   801024d7 <outb>
    outsl(0x1f0, b->data, 512/4);
801026f3:	8b 45 08             	mov    0x8(%ebp),%eax
801026f6:	83 c0 18             	add    $0x18,%eax
801026f9:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102700:	00 
80102701:	89 44 24 04          	mov    %eax,0x4(%esp)
80102705:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010270c:	e8 e4 fd ff ff       	call   801024f5 <outsl>
80102711:	eb 14                	jmp    80102727 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102713:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
8010271a:	00 
8010271b:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102722:	e8 b0 fd ff ff       	call   801024d7 <outb>
  }
}
80102727:	c9                   	leave  
80102728:	c3                   	ret    

80102729 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102729:	55                   	push   %ebp
8010272a:	89 e5                	mov    %esp,%ebp
8010272c:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010272f:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102736:	e8 fc 23 00 00       	call   80104b37 <acquire>
  if((b = idequeue) == 0){
8010273b:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102740:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102747:	75 11                	jne    8010275a <ideintr+0x31>
    release(&idelock);
80102749:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102750:	e8 44 24 00 00       	call   80104b99 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102755:	e9 90 00 00 00       	jmp    801027ea <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275d:	8b 40 14             	mov    0x14(%eax),%eax
80102760:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102768:	8b 00                	mov    (%eax),%eax
8010276a:	83 e0 04             	and    $0x4,%eax
8010276d:	85 c0                	test   %eax,%eax
8010276f:	75 2e                	jne    8010279f <ideintr+0x76>
80102771:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102778:	e8 9d fd ff ff       	call   8010251a <idewait>
8010277d:	85 c0                	test   %eax,%eax
8010277f:	78 1e                	js     8010279f <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102784:	83 c0 18             	add    $0x18,%eax
80102787:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010278e:	00 
8010278f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102793:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010279a:	e8 13 fd ff ff       	call   801024b2 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a2:	8b 00                	mov    (%eax),%eax
801027a4:	89 c2                	mov    %eax,%edx
801027a6:	83 ca 02             	or     $0x2,%edx
801027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ac:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b1:	8b 00                	mov    (%eax),%eax
801027b3:	89 c2                	mov    %eax,%edx
801027b5:	83 e2 fb             	and    $0xfffffffb,%edx
801027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027bb:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c0:	89 04 24             	mov    %eax,(%esp)
801027c3:	e8 6b 21 00 00       	call   80104933 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027c8:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027cd:	85 c0                	test   %eax,%eax
801027cf:	74 0d                	je     801027de <ideintr+0xb5>
    idestart(idequeue);
801027d1:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027d6:	89 04 24             	mov    %eax,(%esp)
801027d9:	e8 26 fe ff ff       	call   80102604 <idestart>

  release(&idelock);
801027de:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027e5:	e8 af 23 00 00       	call   80104b99 <release>
}
801027ea:	c9                   	leave  
801027eb:	c3                   	ret    

801027ec <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027ec:	55                   	push   %ebp
801027ed:	89 e5                	mov    %esp,%ebp
801027ef:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027f2:	8b 45 08             	mov    0x8(%ebp),%eax
801027f5:	8b 00                	mov    (%eax),%eax
801027f7:	83 e0 01             	and    $0x1,%eax
801027fa:	85 c0                	test   %eax,%eax
801027fc:	75 0c                	jne    8010280a <iderw+0x1e>
    panic("iderw: buf not busy");
801027fe:	c7 04 24 69 82 10 80 	movl   $0x80108269,(%esp)
80102805:	e8 3c dd ff ff       	call   80100546 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010280a:	8b 45 08             	mov    0x8(%ebp),%eax
8010280d:	8b 00                	mov    (%eax),%eax
8010280f:	83 e0 06             	and    $0x6,%eax
80102812:	83 f8 02             	cmp    $0x2,%eax
80102815:	75 0c                	jne    80102823 <iderw+0x37>
    panic("iderw: nothing to do");
80102817:	c7 04 24 7d 82 10 80 	movl   $0x8010827d,(%esp)
8010281e:	e8 23 dd ff ff       	call   80100546 <panic>
  if(b->dev != 0 && !havedisk1)
80102823:	8b 45 08             	mov    0x8(%ebp),%eax
80102826:	8b 40 04             	mov    0x4(%eax),%eax
80102829:	85 c0                	test   %eax,%eax
8010282b:	74 15                	je     80102842 <iderw+0x56>
8010282d:	a1 38 b6 10 80       	mov    0x8010b638,%eax
80102832:	85 c0                	test   %eax,%eax
80102834:	75 0c                	jne    80102842 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102836:	c7 04 24 92 82 10 80 	movl   $0x80108292,(%esp)
8010283d:	e8 04 dd ff ff       	call   80100546 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102842:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102849:	e8 e9 22 00 00       	call   80104b37 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
80102851:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102858:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
8010285f:	eb 0b                	jmp    8010286c <iderw+0x80>
80102861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102864:	8b 00                	mov    (%eax),%eax
80102866:	83 c0 14             	add    $0x14,%eax
80102869:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286f:	8b 00                	mov    (%eax),%eax
80102871:	85 c0                	test   %eax,%eax
80102873:	75 ec                	jne    80102861 <iderw+0x75>
    ;
  *pp = b;
80102875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102878:	8b 55 08             	mov    0x8(%ebp),%edx
8010287b:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010287d:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102882:	3b 45 08             	cmp    0x8(%ebp),%eax
80102885:	75 22                	jne    801028a9 <iderw+0xbd>
    idestart(b);
80102887:	8b 45 08             	mov    0x8(%ebp),%eax
8010288a:	89 04 24             	mov    %eax,(%esp)
8010288d:	e8 72 fd ff ff       	call   80102604 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102892:	eb 15                	jmp    801028a9 <iderw+0xbd>
    sleep(b, &idelock);
80102894:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
8010289b:	80 
8010289c:	8b 45 08             	mov    0x8(%ebp),%eax
8010289f:	89 04 24             	mov    %eax,(%esp)
801028a2:	e8 b3 1f 00 00       	call   8010485a <sleep>
801028a7:	eb 01                	jmp    801028aa <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028a9:	90                   	nop
801028aa:	8b 45 08             	mov    0x8(%ebp),%eax
801028ad:	8b 00                	mov    (%eax),%eax
801028af:	83 e0 06             	and    $0x6,%eax
801028b2:	83 f8 02             	cmp    $0x2,%eax
801028b5:	75 dd                	jne    80102894 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
801028b7:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801028be:	e8 d6 22 00 00       	call   80104b99 <release>
}
801028c3:	c9                   	leave  
801028c4:	c3                   	ret    
801028c5:	00 00                	add    %al,(%eax)
	...

801028c8 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801028c8:	55                   	push   %ebp
801028c9:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028cb:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028d0:	8b 55 08             	mov    0x8(%ebp),%edx
801028d3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028d5:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028da:	8b 40 10             	mov    0x10(%eax),%eax
}
801028dd:	5d                   	pop    %ebp
801028de:	c3                   	ret    

801028df <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028df:	55                   	push   %ebp
801028e0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028e2:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028e7:	8b 55 08             	mov    0x8(%ebp),%edx
801028ea:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028ec:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801028f4:	89 50 10             	mov    %edx,0x10(%eax)
}
801028f7:	5d                   	pop    %ebp
801028f8:	c3                   	ret    

801028f9 <ioapicinit>:

void
ioapicinit(void)
{
801028f9:	55                   	push   %ebp
801028fa:	89 e5                	mov    %esp,%ebp
801028fc:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028ff:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102904:	85 c0                	test   %eax,%eax
80102906:	0f 84 9f 00 00 00    	je     801029ab <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010290c:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
80102913:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102916:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010291d:	e8 a6 ff ff ff       	call   801028c8 <ioapicread>
80102922:	c1 e8 10             	shr    $0x10,%eax
80102925:	25 ff 00 00 00       	and    $0xff,%eax
8010292a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
8010292d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102934:	e8 8f ff ff ff       	call   801028c8 <ioapicread>
80102939:	c1 e8 18             	shr    $0x18,%eax
8010293c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
8010293f:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
80102946:	0f b6 c0             	movzbl %al,%eax
80102949:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010294c:	74 0c                	je     8010295a <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010294e:	c7 04 24 b0 82 10 80 	movl   $0x801082b0,(%esp)
80102955:	e8 50 da ff ff       	call   801003aa <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010295a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102961:	eb 3e                	jmp    801029a1 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102966:	83 c0 20             	add    $0x20,%eax
80102969:	0d 00 00 01 00       	or     $0x10000,%eax
8010296e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102971:	83 c2 08             	add    $0x8,%edx
80102974:	01 d2                	add    %edx,%edx
80102976:	89 44 24 04          	mov    %eax,0x4(%esp)
8010297a:	89 14 24             	mov    %edx,(%esp)
8010297d:	e8 5d ff ff ff       	call   801028df <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102985:	83 c0 08             	add    $0x8,%eax
80102988:	01 c0                	add    %eax,%eax
8010298a:	83 c0 01             	add    $0x1,%eax
8010298d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102994:	00 
80102995:	89 04 24             	mov    %eax,(%esp)
80102998:	e8 42 ff ff ff       	call   801028df <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010299d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029a7:	7e ba                	jle    80102963 <ioapicinit+0x6a>
801029a9:	eb 01                	jmp    801029ac <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
801029ab:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029ac:	c9                   	leave  
801029ad:	c3                   	ret    

801029ae <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029ae:	55                   	push   %ebp
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029b4:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801029b9:	85 c0                	test   %eax,%eax
801029bb:	74 39                	je     801029f6 <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029bd:	8b 45 08             	mov    0x8(%ebp),%eax
801029c0:	83 c0 20             	add    $0x20,%eax
801029c3:	8b 55 08             	mov    0x8(%ebp),%edx
801029c6:	83 c2 08             	add    $0x8,%edx
801029c9:	01 d2                	add    %edx,%edx
801029cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801029cf:	89 14 24             	mov    %edx,(%esp)
801029d2:	e8 08 ff ff ff       	call   801028df <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801029da:	c1 e0 18             	shl    $0x18,%eax
801029dd:	8b 55 08             	mov    0x8(%ebp),%edx
801029e0:	83 c2 08             	add    $0x8,%edx
801029e3:	01 d2                	add    %edx,%edx
801029e5:	83 c2 01             	add    $0x1,%edx
801029e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ec:	89 14 24             	mov    %edx,(%esp)
801029ef:	e8 eb fe ff ff       	call   801028df <ioapicwrite>
801029f4:	eb 01                	jmp    801029f7 <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
801029f6:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801029f7:	c9                   	leave  
801029f8:	c3                   	ret    
801029f9:	00 00                	add    %al,(%eax)
	...

801029fc <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029fc:	55                   	push   %ebp
801029fd:	89 e5                	mov    %esp,%ebp
801029ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102a02:	05 00 00 00 80       	add    $0x80000000,%eax
80102a07:	5d                   	pop    %ebp
80102a08:	c3                   	ret    

80102a09 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a09:	55                   	push   %ebp
80102a0a:	89 e5                	mov    %esp,%ebp
80102a0c:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a0f:	c7 44 24 04 e2 82 10 	movl   $0x801082e2,0x4(%esp)
80102a16:	80 
80102a17:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102a1e:	e8 f3 20 00 00       	call   80104b16 <initlock>
  kmem.use_lock = 0;
80102a23:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
80102a2a:	00 00 00 
  freerange(vstart, vend);
80102a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a30:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a34:	8b 45 08             	mov    0x8(%ebp),%eax
80102a37:	89 04 24             	mov    %eax,(%esp)
80102a3a:	e8 26 00 00 00       	call   80102a65 <freerange>
}
80102a3f:	c9                   	leave  
80102a40:	c3                   	ret    

80102a41 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a41:	55                   	push   %ebp
80102a42:	89 e5                	mov    %esp,%ebp
80102a44:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a47:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a51:	89 04 24             	mov    %eax,(%esp)
80102a54:	e8 0c 00 00 00       	call   80102a65 <freerange>
  kmem.use_lock = 1;
80102a59:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102a60:	00 00 00 
}
80102a63:	c9                   	leave  
80102a64:	c3                   	ret    

80102a65 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a65:	55                   	push   %ebp
80102a66:	89 e5                	mov    %esp,%ebp
80102a68:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6e:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a7b:	eb 12                	jmp    80102a8f <freerange+0x2a>
    kfree(p);
80102a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a80:	89 04 24             	mov    %eax,(%esp)
80102a83:	e8 16 00 00 00       	call   80102a9e <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a88:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a92:	05 00 10 00 00       	add    $0x1000,%eax
80102a97:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a9a:	76 e1                	jbe    80102a7d <freerange+0x18>
    kfree(p);
}
80102a9c:	c9                   	leave  
80102a9d:	c3                   	ret    

80102a9e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a9e:	55                   	push   %ebp
80102a9f:	89 e5                	mov    %esp,%ebp
80102aa1:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa7:	25 ff 0f 00 00       	and    $0xfff,%eax
80102aac:	85 c0                	test   %eax,%eax
80102aae:	75 1b                	jne    80102acb <kfree+0x2d>
80102ab0:	81 7d 08 fc 26 11 80 	cmpl   $0x801126fc,0x8(%ebp)
80102ab7:	72 12                	jb     80102acb <kfree+0x2d>
80102ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80102abc:	89 04 24             	mov    %eax,(%esp)
80102abf:	e8 38 ff ff ff       	call   801029fc <v2p>
80102ac4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ac9:	76 0c                	jbe    80102ad7 <kfree+0x39>
    panic("kfree");
80102acb:	c7 04 24 e7 82 10 80 	movl   $0x801082e7,(%esp)
80102ad2:	e8 6f da ff ff       	call   80100546 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ad7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102ade:	00 
80102adf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ae6:	00 
80102ae7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aea:	89 04 24             	mov    %eax,(%esp)
80102aed:	e8 a0 22 00 00       	call   80104d92 <memset>

  if(kmem.use_lock)
80102af2:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102af7:	85 c0                	test   %eax,%eax
80102af9:	74 0c                	je     80102b07 <kfree+0x69>
    acquire(&kmem.lock);
80102afb:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b02:	e8 30 20 00 00       	call   80104b37 <acquire>
  r = (struct run*)v;
80102b07:	8b 45 08             	mov    0x8(%ebp),%eax
80102b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b0d:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b16:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1b:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b20:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b25:	85 c0                	test   %eax,%eax
80102b27:	74 0c                	je     80102b35 <kfree+0x97>
    release(&kmem.lock);
80102b29:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b30:	e8 64 20 00 00       	call   80104b99 <release>
}
80102b35:	c9                   	leave  
80102b36:	c3                   	ret    

80102b37 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b37:	55                   	push   %ebp
80102b38:	89 e5                	mov    %esp,%ebp
80102b3a:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b3d:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b42:	85 c0                	test   %eax,%eax
80102b44:	74 0c                	je     80102b52 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b46:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b4d:	e8 e5 1f 00 00       	call   80104b37 <acquire>
  r = kmem.freelist;
80102b52:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b5e:	74 0a                	je     80102b6a <kalloc+0x33>
    kmem.freelist = r->next;
80102b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b63:	8b 00                	mov    (%eax),%eax
80102b65:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b6a:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b6f:	85 c0                	test   %eax,%eax
80102b71:	74 0c                	je     80102b7f <kalloc+0x48>
    release(&kmem.lock);
80102b73:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b7a:	e8 1a 20 00 00       	call   80104b99 <release>
  return (char*)r;
80102b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b82:	c9                   	leave  
80102b83:	c3                   	ret    

80102b84 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b84:	55                   	push   %ebp
80102b85:	89 e5                	mov    %esp,%ebp
80102b87:	53                   	push   %ebx
80102b88:	83 ec 14             	sub    $0x14,%esp
80102b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8e:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b92:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102b96:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102b9a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	89 c3                	mov    %eax,%ebx
80102ba1:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102ba4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102ba8:	83 c4 14             	add    $0x14,%esp
80102bab:	5b                   	pop    %ebx
80102bac:	5d                   	pop    %ebp
80102bad:	c3                   	ret    

80102bae <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102bb4:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102bbb:	e8 c4 ff ff ff       	call   80102b84 <inb>
80102bc0:	0f b6 c0             	movzbl %al,%eax
80102bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bc9:	83 e0 01             	and    $0x1,%eax
80102bcc:	85 c0                	test   %eax,%eax
80102bce:	75 0a                	jne    80102bda <kbdgetc+0x2c>
    return -1;
80102bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102bd5:	e9 25 01 00 00       	jmp    80102cff <kbdgetc+0x151>
  data = inb(KBDATAP);
80102bda:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102be1:	e8 9e ff ff ff       	call   80102b84 <inb>
80102be6:	0f b6 c0             	movzbl %al,%eax
80102be9:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102bec:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102bf3:	75 17                	jne    80102c0c <kbdgetc+0x5e>
    shift |= E0ESC;
80102bf5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bfa:	83 c8 40             	or     $0x40,%eax
80102bfd:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c02:	b8 00 00 00 00       	mov    $0x0,%eax
80102c07:	e9 f3 00 00 00       	jmp    80102cff <kbdgetc+0x151>
  } else if(data & 0x80){
80102c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c0f:	25 80 00 00 00       	and    $0x80,%eax
80102c14:	85 c0                	test   %eax,%eax
80102c16:	74 45                	je     80102c5d <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c18:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c1d:	83 e0 40             	and    $0x40,%eax
80102c20:	85 c0                	test   %eax,%eax
80102c22:	75 08                	jne    80102c2c <kbdgetc+0x7e>
80102c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c27:	83 e0 7f             	and    $0x7f,%eax
80102c2a:	eb 03                	jmp    80102c2f <kbdgetc+0x81>
80102c2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c35:	05 20 90 10 80       	add    $0x80109020,%eax
80102c3a:	0f b6 00             	movzbl (%eax),%eax
80102c3d:	83 c8 40             	or     $0x40,%eax
80102c40:	0f b6 c0             	movzbl %al,%eax
80102c43:	f7 d0                	not    %eax
80102c45:	89 c2                	mov    %eax,%edx
80102c47:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c4c:	21 d0                	and    %edx,%eax
80102c4e:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c53:	b8 00 00 00 00       	mov    $0x0,%eax
80102c58:	e9 a2 00 00 00       	jmp    80102cff <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c5d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c62:	83 e0 40             	and    $0x40,%eax
80102c65:	85 c0                	test   %eax,%eax
80102c67:	74 14                	je     80102c7d <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c69:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c70:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c75:	83 e0 bf             	and    $0xffffffbf,%eax
80102c78:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c80:	05 20 90 10 80       	add    $0x80109020,%eax
80102c85:	0f b6 00             	movzbl (%eax),%eax
80102c88:	0f b6 d0             	movzbl %al,%edx
80102c8b:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c90:	09 d0                	or     %edx,%eax
80102c92:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c9a:	05 20 91 10 80       	add    $0x80109120,%eax
80102c9f:	0f b6 00             	movzbl (%eax),%eax
80102ca2:	0f b6 d0             	movzbl %al,%edx
80102ca5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102caa:	31 d0                	xor    %edx,%eax
80102cac:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cb1:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cb6:	83 e0 03             	and    $0x3,%eax
80102cb9:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc3:	01 d0                	add    %edx,%eax
80102cc5:	0f b6 00             	movzbl (%eax),%eax
80102cc8:	0f b6 c0             	movzbl %al,%eax
80102ccb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102cce:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cd3:	83 e0 08             	and    $0x8,%eax
80102cd6:	85 c0                	test   %eax,%eax
80102cd8:	74 22                	je     80102cfc <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102cda:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102cde:	76 0c                	jbe    80102cec <kbdgetc+0x13e>
80102ce0:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102ce4:	77 06                	ja     80102cec <kbdgetc+0x13e>
      c += 'A' - 'a';
80102ce6:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102cea:	eb 10                	jmp    80102cfc <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102cec:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102cf0:	76 0a                	jbe    80102cfc <kbdgetc+0x14e>
80102cf2:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102cf6:	77 04                	ja     80102cfc <kbdgetc+0x14e>
      c += 'a' - 'A';
80102cf8:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102cfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102cff:	c9                   	leave  
80102d00:	c3                   	ret    

80102d01 <kbdintr>:

void
kbdintr(void)
{
80102d01:	55                   	push   %ebp
80102d02:	89 e5                	mov    %esp,%ebp
80102d04:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d07:	c7 04 24 ae 2b 10 80 	movl   $0x80102bae,(%esp)
80102d0e:	e8 a3 da ff ff       	call   801007b6 <consoleintr>
}
80102d13:	c9                   	leave  
80102d14:	c3                   	ret    
80102d15:	00 00                	add    %al,(%eax)
	...

80102d18 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d18:	55                   	push   %ebp
80102d19:	89 e5                	mov    %esp,%ebp
80102d1b:	83 ec 08             	sub    $0x8,%esp
80102d1e:	8b 55 08             	mov    0x8(%ebp),%edx
80102d21:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d24:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d28:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d2f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d33:	ee                   	out    %al,(%dx)
}
80102d34:	c9                   	leave  
80102d35:	c3                   	ret    

80102d36 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d36:	55                   	push   %ebp
80102d37:	89 e5                	mov    %esp,%ebp
80102d39:	53                   	push   %ebx
80102d3a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d3d:	9c                   	pushf  
80102d3e:	5b                   	pop    %ebx
80102d3f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102d42:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d45:	83 c4 10             	add    $0x10,%esp
80102d48:	5b                   	pop    %ebx
80102d49:	5d                   	pop    %ebp
80102d4a:	c3                   	ret    

80102d4b <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d4b:	55                   	push   %ebp
80102d4c:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d4e:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d53:	8b 55 08             	mov    0x8(%ebp),%edx
80102d56:	c1 e2 02             	shl    $0x2,%edx
80102d59:	01 c2                	add    %eax,%edx
80102d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d5e:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d60:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d65:	83 c0 20             	add    $0x20,%eax
80102d68:	8b 00                	mov    (%eax),%eax
}
80102d6a:	5d                   	pop    %ebp
80102d6b:	c3                   	ret    

80102d6c <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d6c:	55                   	push   %ebp
80102d6d:	89 e5                	mov    %esp,%ebp
80102d6f:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d72:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d77:	85 c0                	test   %eax,%eax
80102d79:	0f 84 47 01 00 00    	je     80102ec6 <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d7f:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d86:	00 
80102d87:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d8e:	e8 b8 ff ff ff       	call   80102d4b <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d93:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d9a:	00 
80102d9b:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102da2:	e8 a4 ff ff ff       	call   80102d4b <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102da7:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102dae:	00 
80102daf:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102db6:	e8 90 ff ff ff       	call   80102d4b <lapicw>
  lapicw(TICR, 10000000); 
80102dbb:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102dc2:	00 
80102dc3:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102dca:	e8 7c ff ff ff       	call   80102d4b <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102dcf:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd6:	00 
80102dd7:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102dde:	e8 68 ff ff ff       	call   80102d4b <lapicw>
  lapicw(LINT1, MASKED);
80102de3:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dea:	00 
80102deb:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102df2:	e8 54 ff ff ff       	call   80102d4b <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102df7:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102dfc:	83 c0 30             	add    $0x30,%eax
80102dff:	8b 00                	mov    (%eax),%eax
80102e01:	c1 e8 10             	shr    $0x10,%eax
80102e04:	25 ff 00 00 00       	and    $0xff,%eax
80102e09:	83 f8 03             	cmp    $0x3,%eax
80102e0c:	76 14                	jbe    80102e22 <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102e0e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e15:	00 
80102e16:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e1d:	e8 29 ff ff ff       	call   80102d4b <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e22:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e29:	00 
80102e2a:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e31:	e8 15 ff ff ff       	call   80102d4b <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3d:	00 
80102e3e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e45:	e8 01 ff ff ff       	call   80102d4b <lapicw>
  lapicw(ESR, 0);
80102e4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e51:	00 
80102e52:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e59:	e8 ed fe ff ff       	call   80102d4b <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e65:	00 
80102e66:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e6d:	e8 d9 fe ff ff       	call   80102d4b <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e79:	00 
80102e7a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e81:	e8 c5 fe ff ff       	call   80102d4b <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e86:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e8d:	00 
80102e8e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e95:	e8 b1 fe ff ff       	call   80102d4b <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e9a:	90                   	nop
80102e9b:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ea0:	05 00 03 00 00       	add    $0x300,%eax
80102ea5:	8b 00                	mov    (%eax),%eax
80102ea7:	25 00 10 00 00       	and    $0x1000,%eax
80102eac:	85 c0                	test   %eax,%eax
80102eae:	75 eb                	jne    80102e9b <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102eb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb7:	00 
80102eb8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102ebf:	e8 87 fe ff ff       	call   80102d4b <lapicw>
80102ec4:	eb 01                	jmp    80102ec7 <lapicinit+0x15b>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102ec6:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ec7:	c9                   	leave  
80102ec8:	c3                   	ret    

80102ec9 <cpunum>:

int
cpunum(void)
{
80102ec9:	55                   	push   %ebp
80102eca:	89 e5                	mov    %esp,%ebp
80102ecc:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102ecf:	e8 62 fe ff ff       	call   80102d36 <readeflags>
80102ed4:	25 00 02 00 00       	and    $0x200,%eax
80102ed9:	85 c0                	test   %eax,%eax
80102edb:	74 29                	je     80102f06 <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102edd:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102ee2:	85 c0                	test   %eax,%eax
80102ee4:	0f 94 c2             	sete   %dl
80102ee7:	83 c0 01             	add    $0x1,%eax
80102eea:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102eef:	84 d2                	test   %dl,%dl
80102ef1:	74 13                	je     80102f06 <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ef3:	8b 45 04             	mov    0x4(%ebp),%eax
80102ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
80102efa:	c7 04 24 f0 82 10 80 	movl   $0x801082f0,(%esp)
80102f01:	e8 a4 d4 ff ff       	call   801003aa <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102f06:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f0b:	85 c0                	test   %eax,%eax
80102f0d:	74 0f                	je     80102f1e <cpunum+0x55>
    return lapic[ID]>>24;
80102f0f:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f14:	83 c0 20             	add    $0x20,%eax
80102f17:	8b 00                	mov    (%eax),%eax
80102f19:	c1 e8 18             	shr    $0x18,%eax
80102f1c:	eb 05                	jmp    80102f23 <cpunum+0x5a>
  return 0;
80102f1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f23:	c9                   	leave  
80102f24:	c3                   	ret    

80102f25 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f25:	55                   	push   %ebp
80102f26:	89 e5                	mov    %esp,%ebp
80102f28:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f2b:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f30:	85 c0                	test   %eax,%eax
80102f32:	74 14                	je     80102f48 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f34:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f3b:	00 
80102f3c:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f43:	e8 03 fe ff ff       	call   80102d4b <lapicw>
}
80102f48:	c9                   	leave  
80102f49:	c3                   	ret    

80102f4a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f4a:	55                   	push   %ebp
80102f4b:	89 e5                	mov    %esp,%ebp
}
80102f4d:	5d                   	pop    %ebp
80102f4e:	c3                   	ret    

80102f4f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f4f:	55                   	push   %ebp
80102f50:	89 e5                	mov    %esp,%ebp
80102f52:	83 ec 1c             	sub    $0x1c,%esp
80102f55:	8b 45 08             	mov    0x8(%ebp),%eax
80102f58:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f5b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f62:	00 
80102f63:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f6a:	e8 a9 fd ff ff       	call   80102d18 <outb>
  outb(IO_RTC+1, 0x0A);
80102f6f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f76:	00 
80102f77:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f7e:	e8 95 fd ff ff       	call   80102d18 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f83:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f8d:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f95:	8d 50 02             	lea    0x2(%eax),%edx
80102f98:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f9b:	c1 e8 04             	shr    $0x4,%eax
80102f9e:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fa1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fa5:	c1 e0 18             	shl    $0x18,%eax
80102fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fac:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fb3:	e8 93 fd ff ff       	call   80102d4b <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fb8:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102fbf:	00 
80102fc0:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fc7:	e8 7f fd ff ff       	call   80102d4b <lapicw>
  microdelay(200);
80102fcc:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fd3:	e8 72 ff ff ff       	call   80102f4a <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102fd8:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102fdf:	00 
80102fe0:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fe7:	e8 5f fd ff ff       	call   80102d4b <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fec:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102ff3:	e8 52 ff ff ff       	call   80102f4a <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ff8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fff:	eb 40                	jmp    80103041 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80103001:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103005:	c1 e0 18             	shl    $0x18,%eax
80103008:	89 44 24 04          	mov    %eax,0x4(%esp)
8010300c:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103013:	e8 33 fd ff ff       	call   80102d4b <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103018:	8b 45 0c             	mov    0xc(%ebp),%eax
8010301b:	c1 e8 0c             	shr    $0xc,%eax
8010301e:	80 cc 06             	or     $0x6,%ah
80103021:	89 44 24 04          	mov    %eax,0x4(%esp)
80103025:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010302c:	e8 1a fd ff ff       	call   80102d4b <lapicw>
    microdelay(200);
80103031:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103038:	e8 0d ff ff ff       	call   80102f4a <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010303d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103041:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103045:	7e ba                	jle    80103001 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103047:	c9                   	leave  
80103048:	c3                   	ret    
80103049:	00 00                	add    %al,(%eax)
	...

8010304c <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
8010304c:	55                   	push   %ebp
8010304d:	89 e5                	mov    %esp,%ebp
8010304f:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103052:	c7 44 24 04 1c 83 10 	movl   $0x8010831c,0x4(%esp)
80103059:	80 
8010305a:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103061:	e8 b0 1a 00 00       	call   80104b16 <initlock>
  readsb(ROOTDEV, &sb);
80103066:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103069:	89 44 24 04          	mov    %eax,0x4(%esp)
8010306d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103074:	e8 93 e2 ff ff       	call   8010130c <readsb>
  log.start = sb.size - sb.nlog;
80103079:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010307f:	89 d1                	mov    %edx,%ecx
80103081:	29 c1                	sub    %eax,%ecx
80103083:	89 c8                	mov    %ecx,%eax
80103085:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
8010308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010308d:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
80103092:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
80103099:	00 00 00 
  recover_from_log();
8010309c:	e8 9a 01 00 00       	call   8010323b <recover_from_log>
}
801030a1:	c9                   	leave  
801030a2:	c3                   	ret    

801030a3 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801030a3:	55                   	push   %ebp
801030a4:	89 e5                	mov    %esp,%ebp
801030a6:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801030b0:	e9 8c 00 00 00       	jmp    80103141 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030b5:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
801030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030be:	01 d0                	add    %edx,%eax
801030c0:	83 c0 01             	add    $0x1,%eax
801030c3:	89 c2                	mov    %eax,%edx
801030c5:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801030ce:	89 04 24             	mov    %eax,(%esp)
801030d1:	e8 d0 d0 ff ff       	call   801001a6 <bread>
801030d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030dc:	83 c0 10             	add    $0x10,%eax
801030df:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801030e6:	89 c2                	mov    %eax,%edx
801030e8:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030ed:	89 54 24 04          	mov    %edx,0x4(%esp)
801030f1:	89 04 24             	mov    %eax,(%esp)
801030f4:	e8 ad d0 ff ff       	call   801001a6 <bread>
801030f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030ff:	8d 50 18             	lea    0x18(%eax),%edx
80103102:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103105:	83 c0 18             	add    $0x18,%eax
80103108:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010310f:	00 
80103110:	89 54 24 04          	mov    %edx,0x4(%esp)
80103114:	89 04 24             	mov    %eax,(%esp)
80103117:	e8 49 1d 00 00       	call   80104e65 <memmove>
    bwrite(dbuf);  // write dst to disk
8010311c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010311f:	89 04 24             	mov    %eax,(%esp)
80103122:	e8 b6 d0 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
80103127:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010312a:	89 04 24             	mov    %eax,(%esp)
8010312d:	e8 e5 d0 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103132:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103135:	89 04 24             	mov    %eax,(%esp)
80103138:	e8 da d0 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010313d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103141:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103146:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103149:	0f 8f 66 ff ff ff    	jg     801030b5 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010314f:	c9                   	leave  
80103150:	c3                   	ret    

80103151 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103151:	55                   	push   %ebp
80103152:	89 e5                	mov    %esp,%ebp
80103154:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103157:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010315c:	89 c2                	mov    %eax,%edx
8010315e:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103163:	89 54 24 04          	mov    %edx,0x4(%esp)
80103167:	89 04 24             	mov    %eax,(%esp)
8010316a:	e8 37 d0 ff ff       	call   801001a6 <bread>
8010316f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103175:	83 c0 18             	add    $0x18,%eax
80103178:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010317b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010317e:	8b 00                	mov    (%eax),%eax
80103180:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
80103185:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010318c:	eb 1b                	jmp    801031a9 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010318e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103191:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103194:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103198:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010319b:	83 c2 10             	add    $0x10,%edx
8010319e:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801031a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031a9:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801031ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031b1:	7f db                	jg     8010318e <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801031b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031b6:	89 04 24             	mov    %eax,(%esp)
801031b9:	e8 59 d0 ff ff       	call   80100217 <brelse>
}
801031be:	c9                   	leave  
801031bf:	c3                   	ret    

801031c0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801031c6:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801031cb:	89 c2                	mov    %eax,%edx
801031cd:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801031d2:	89 54 24 04          	mov    %edx,0x4(%esp)
801031d6:	89 04 24             	mov    %eax,(%esp)
801031d9:	e8 c8 cf ff ff       	call   801001a6 <bread>
801031de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031e4:	83 c0 18             	add    $0x18,%eax
801031e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801031ea:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
801031f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031f3:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801031f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031fc:	eb 1b                	jmp    80103219 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103201:	83 c0 10             	add    $0x10,%eax
80103204:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
8010320b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010320e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103211:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103215:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103219:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010321e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103221:	7f db                	jg     801031fe <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103223:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103226:	89 04 24             	mov    %eax,(%esp)
80103229:	e8 af cf ff ff       	call   801001dd <bwrite>
  brelse(buf);
8010322e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103231:	89 04 24             	mov    %eax,(%esp)
80103234:	e8 de cf ff ff       	call   80100217 <brelse>
}
80103239:	c9                   	leave  
8010323a:	c3                   	ret    

8010323b <recover_from_log>:

static void
recover_from_log(void)
{
8010323b:	55                   	push   %ebp
8010323c:	89 e5                	mov    %esp,%ebp
8010323e:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103241:	e8 0b ff ff ff       	call   80103151 <read_head>
  install_trans(); // if committed, copy from log to disk
80103246:	e8 58 fe ff ff       	call   801030a3 <install_trans>
  log.lh.n = 0;
8010324b:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103252:	00 00 00 
  write_head(); // clear the log
80103255:	e8 66 ff ff ff       	call   801031c0 <write_head>
}
8010325a:	c9                   	leave  
8010325b:	c3                   	ret    

8010325c <begin_trans>:

void
begin_trans(void)
{
8010325c:	55                   	push   %ebp
8010325d:	89 e5                	mov    %esp,%ebp
8010325f:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103262:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103269:	e8 c9 18 00 00       	call   80104b37 <acquire>
  while (log.busy) {
8010326e:	eb 14                	jmp    80103284 <begin_trans+0x28>
    sleep(&log, &log.lock);
80103270:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
80103277:	80 
80103278:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010327f:	e8 d6 15 00 00       	call   8010485a <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103284:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103289:	85 c0                	test   %eax,%eax
8010328b:	75 e3                	jne    80103270 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010328d:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
80103294:	00 00 00 
  release(&log.lock);
80103297:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010329e:	e8 f6 18 00 00       	call   80104b99 <release>
}
801032a3:	c9                   	leave  
801032a4:	c3                   	ret    

801032a5 <commit_trans>:

void
commit_trans(void)
{
801032a5:	55                   	push   %ebp
801032a6:	89 e5                	mov    %esp,%ebp
801032a8:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
801032ab:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032b0:	85 c0                	test   %eax,%eax
801032b2:	7e 19                	jle    801032cd <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
801032b4:	e8 07 ff ff ff       	call   801031c0 <write_head>
    install_trans(); // Now install writes to home locations
801032b9:	e8 e5 fd ff ff       	call   801030a3 <install_trans>
    log.lh.n = 0; 
801032be:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
801032c5:	00 00 00 
    write_head();    // Erase the transaction from the log
801032c8:	e8 f3 fe ff ff       	call   801031c0 <write_head>
  }
  
  acquire(&log.lock);
801032cd:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032d4:	e8 5e 18 00 00       	call   80104b37 <acquire>
  log.busy = 0;
801032d9:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
801032e0:	00 00 00 
  wakeup(&log);
801032e3:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032ea:	e8 44 16 00 00       	call   80104933 <wakeup>
  release(&log.lock);
801032ef:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032f6:	e8 9e 18 00 00       	call   80104b99 <release>
}
801032fb:	c9                   	leave  
801032fc:	c3                   	ret    

801032fd <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032fd:	55                   	push   %ebp
801032fe:	89 e5                	mov    %esp,%ebp
80103300:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103303:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103308:	83 f8 09             	cmp    $0x9,%eax
8010330b:	7f 12                	jg     8010331f <log_write+0x22>
8010330d:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103312:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
80103318:	83 ea 01             	sub    $0x1,%edx
8010331b:	39 d0                	cmp    %edx,%eax
8010331d:	7c 0c                	jl     8010332b <log_write+0x2e>
    panic("too big a transaction");
8010331f:	c7 04 24 20 83 10 80 	movl   $0x80108320,(%esp)
80103326:	e8 1b d2 ff ff       	call   80100546 <panic>
  if (!log.busy)
8010332b:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103330:	85 c0                	test   %eax,%eax
80103332:	75 0c                	jne    80103340 <log_write+0x43>
    panic("write outside of trans");
80103334:	c7 04 24 36 83 10 80 	movl   $0x80108336,(%esp)
8010333b:	e8 06 d2 ff ff       	call   80100546 <panic>

  for (i = 0; i < log.lh.n; i++) {
80103340:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103347:	eb 1d                	jmp    80103366 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
80103349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010334c:	83 c0 10             	add    $0x10,%eax
8010334f:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
80103356:	89 c2                	mov    %eax,%edx
80103358:	8b 45 08             	mov    0x8(%ebp),%eax
8010335b:	8b 40 08             	mov    0x8(%eax),%eax
8010335e:	39 c2                	cmp    %eax,%edx
80103360:	74 10                	je     80103372 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103362:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103366:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010336b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010336e:	7f d9                	jg     80103349 <log_write+0x4c>
80103370:	eb 01                	jmp    80103373 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
80103372:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103373:	8b 45 08             	mov    0x8(%ebp),%eax
80103376:	8b 40 08             	mov    0x8(%eax),%eax
80103379:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010337c:	83 c2 10             	add    $0x10,%edx
8010337f:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103386:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
8010338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010338f:	01 d0                	add    %edx,%eax
80103391:	83 c0 01             	add    $0x1,%eax
80103394:	89 c2                	mov    %eax,%edx
80103396:	8b 45 08             	mov    0x8(%ebp),%eax
80103399:	8b 40 04             	mov    0x4(%eax),%eax
8010339c:	89 54 24 04          	mov    %edx,0x4(%esp)
801033a0:	89 04 24             	mov    %eax,(%esp)
801033a3:	e8 fe cd ff ff       	call   801001a6 <bread>
801033a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
801033ab:	8b 45 08             	mov    0x8(%ebp),%eax
801033ae:	8d 50 18             	lea    0x18(%eax),%edx
801033b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033b4:	83 c0 18             	add    $0x18,%eax
801033b7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801033be:	00 
801033bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801033c3:	89 04 24             	mov    %eax,(%esp)
801033c6:	e8 9a 1a 00 00       	call   80104e65 <memmove>
  bwrite(lbuf);
801033cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ce:	89 04 24             	mov    %eax,(%esp)
801033d1:	e8 07 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
801033d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033d9:	89 04 24             	mov    %eax,(%esp)
801033dc:	e8 36 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
801033e1:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033e9:	75 0d                	jne    801033f8 <log_write+0xfb>
    log.lh.n++;
801033eb:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033f0:	83 c0 01             	add    $0x1,%eax
801033f3:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
801033f8:	8b 45 08             	mov    0x8(%ebp),%eax
801033fb:	8b 00                	mov    (%eax),%eax
801033fd:	89 c2                	mov    %eax,%edx
801033ff:	83 ca 04             	or     $0x4,%edx
80103402:	8b 45 08             	mov    0x8(%ebp),%eax
80103405:	89 10                	mov    %edx,(%eax)
}
80103407:	c9                   	leave  
80103408:	c3                   	ret    
80103409:	00 00                	add    %al,(%eax)
	...

8010340c <v2p>:
8010340c:	55                   	push   %ebp
8010340d:	89 e5                	mov    %esp,%ebp
8010340f:	8b 45 08             	mov    0x8(%ebp),%eax
80103412:	05 00 00 00 80       	add    $0x80000000,%eax
80103417:	5d                   	pop    %ebp
80103418:	c3                   	ret    

80103419 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103419:	55                   	push   %ebp
8010341a:	89 e5                	mov    %esp,%ebp
8010341c:	8b 45 08             	mov    0x8(%ebp),%eax
8010341f:	05 00 00 00 80       	add    $0x80000000,%eax
80103424:	5d                   	pop    %ebp
80103425:	c3                   	ret    

80103426 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103426:	55                   	push   %ebp
80103427:	89 e5                	mov    %esp,%ebp
80103429:	53                   	push   %ebx
8010342a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
8010342d:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103430:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80103433:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103436:	89 c3                	mov    %eax,%ebx
80103438:	89 d8                	mov    %ebx,%eax
8010343a:	f0 87 02             	lock xchg %eax,(%edx)
8010343d:	89 c3                	mov    %eax,%ebx
8010343f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103442:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103445:	83 c4 10             	add    $0x10,%esp
80103448:	5b                   	pop    %ebx
80103449:	5d                   	pop    %ebp
8010344a:	c3                   	ret    

8010344b <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010344b:	55                   	push   %ebp
8010344c:	89 e5                	mov    %esp,%ebp
8010344e:	83 e4 f0             	and    $0xfffffff0,%esp
80103451:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103454:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010345b:	80 
8010345c:	c7 04 24 fc 26 11 80 	movl   $0x801126fc,(%esp)
80103463:	e8 a1 f5 ff ff       	call   80102a09 <kinit1>
  kvmalloc();      // kernel page table
80103468:	e8 ef 44 00 00       	call   8010795c <kvmalloc>
  mpinit();        // collect info about this machine
8010346d:	e8 57 04 00 00       	call   801038c9 <mpinit>
  lapicinit();
80103472:	e8 f5 f8 ff ff       	call   80102d6c <lapicinit>
  seginit();       // set up segments
80103477:	e8 75 3e 00 00       	call   801072f1 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010347c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103482:	0f b6 00             	movzbl (%eax),%eax
80103485:	0f b6 c0             	movzbl %al,%eax
80103488:	89 44 24 04          	mov    %eax,0x4(%esp)
8010348c:	c7 04 24 4d 83 10 80 	movl   $0x8010834d,(%esp)
80103493:	e8 12 cf ff ff       	call   801003aa <cprintf>
  picinit();       // interrupt controller
80103498:	e8 91 06 00 00       	call   80103b2e <picinit>
  ioapicinit();    // another interrupt controller
8010349d:	e8 57 f4 ff ff       	call   801028f9 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801034a2:	e8 f1 d5 ff ff       	call   80100a98 <consoleinit>
  uartinit();      // serial port
801034a7:	e8 90 31 00 00       	call   8010663c <uartinit>
  pinit();         // process table
801034ac:	e8 96 0b 00 00       	call   80104047 <pinit>
  tvinit();        // trap vectors
801034b1:	e8 29 2d 00 00       	call   801061df <tvinit>
  binit();         // buffer cache
801034b6:	e8 79 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
801034bb:	e8 60 da ff ff       	call   80100f20 <fileinit>
  iinit();         // inode cache
801034c0:	e8 17 e1 ff ff       	call   801015dc <iinit>
  ideinit();       // disk
801034c5:	e8 94 f0 ff ff       	call   8010255e <ideinit>
  if(!ismp)
801034ca:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	75 05                	jne    801034d8 <main+0x8d>
    timerinit();   // uniprocessor timer
801034d3:	e8 4a 2c 00 00       	call   80106122 <timerinit>
  startothers();   // start other processors
801034d8:	e8 7f 00 00 00       	call   8010355c <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034dd:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801034e4:	8e 
801034e5:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801034ec:	e8 50 f5 ff ff       	call   80102a41 <kinit2>
  userinit();      // first user process
801034f1:	e8 6c 0c 00 00       	call   80104162 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801034f6:	e8 1a 00 00 00       	call   80103515 <mpmain>

801034fb <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801034fb:	55                   	push   %ebp
801034fc:	89 e5                	mov    %esp,%ebp
801034fe:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103501:	e8 6d 44 00 00       	call   80107973 <switchkvm>
  seginit();
80103506:	e8 e6 3d 00 00       	call   801072f1 <seginit>
  lapicinit();
8010350b:	e8 5c f8 ff ff       	call   80102d6c <lapicinit>
  mpmain();
80103510:	e8 00 00 00 00       	call   80103515 <mpmain>

80103515 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103515:	55                   	push   %ebp
80103516:	89 e5                	mov    %esp,%ebp
80103518:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010351b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103521:	0f b6 00             	movzbl (%eax),%eax
80103524:	0f b6 c0             	movzbl %al,%eax
80103527:	89 44 24 04          	mov    %eax,0x4(%esp)
8010352b:	c7 04 24 64 83 10 80 	movl   $0x80108364,(%esp)
80103532:	e8 73 ce ff ff       	call   801003aa <cprintf>
  idtinit();       // load idt register
80103537:	e8 17 2e 00 00       	call   80106353 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010353c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103542:	05 a8 00 00 00       	add    $0xa8,%eax
80103547:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010354e:	00 
8010354f:	89 04 24             	mov    %eax,(%esp)
80103552:	e8 cf fe ff ff       	call   80103426 <xchg>
  scheduler();     // start running processes
80103557:	e8 55 11 00 00       	call   801046b1 <scheduler>

8010355c <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010355c:	55                   	push   %ebp
8010355d:	89 e5                	mov    %esp,%ebp
8010355f:	53                   	push   %ebx
80103560:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103563:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
8010356a:	e8 aa fe ff ff       	call   80103419 <p2v>
8010356f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103572:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103577:	89 44 24 08          	mov    %eax,0x8(%esp)
8010357b:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
80103582:	80 
80103583:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103586:	89 04 24             	mov    %eax,(%esp)
80103589:	e8 d7 18 00 00       	call   80104e65 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010358e:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
80103595:	e9 86 00 00 00       	jmp    80103620 <startothers+0xc4>
    if(c == cpus+cpunum())  // We've started already.
8010359a:	e8 2a f9 ff ff       	call   80102ec9 <cpunum>
8010359f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035a5:	05 20 f9 10 80       	add    $0x8010f920,%eax
801035aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035ad:	74 69                	je     80103618 <startothers+0xbc>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035af:	e8 83 f5 ff ff       	call   80102b37 <kalloc>
801035b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801035b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035ba:	83 e8 04             	sub    $0x4,%eax
801035bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
801035c0:	81 c2 00 10 00 00    	add    $0x1000,%edx
801035c6:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801035c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035cb:	83 e8 08             	sub    $0x8,%eax
801035ce:	c7 00 fb 34 10 80    	movl   $0x801034fb,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801035d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035d7:	8d 58 f4             	lea    -0xc(%eax),%ebx
801035da:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801035e1:	e8 26 fe ff ff       	call   8010340c <v2p>
801035e6:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801035e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035eb:	89 04 24             	mov    %eax,(%esp)
801035ee:	e8 19 fe ff ff       	call   8010340c <v2p>
801035f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035f6:	0f b6 12             	movzbl (%edx),%edx
801035f9:	0f b6 d2             	movzbl %dl,%edx
801035fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80103600:	89 14 24             	mov    %edx,(%esp)
80103603:	e8 47 f9 ff ff       	call   80102f4f <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103608:	90                   	nop
80103609:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010360c:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103612:	85 c0                	test   %eax,%eax
80103614:	74 f3                	je     80103609 <startothers+0xad>
80103616:	eb 01                	jmp    80103619 <startothers+0xbd>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103618:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103619:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103620:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103625:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010362b:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103630:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103633:	0f 87 61 ff ff ff    	ja     8010359a <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103639:	83 c4 24             	add    $0x24,%esp
8010363c:	5b                   	pop    %ebx
8010363d:	5d                   	pop    %ebp
8010363e:	c3                   	ret    
	...

80103640 <p2v>:
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	8b 45 08             	mov    0x8(%ebp),%eax
80103646:	05 00 00 00 80       	add    $0x80000000,%eax
8010364b:	5d                   	pop    %ebp
8010364c:	c3                   	ret    

8010364d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010364d:	55                   	push   %ebp
8010364e:	89 e5                	mov    %esp,%ebp
80103650:	53                   	push   %ebx
80103651:	83 ec 14             	sub    $0x14,%esp
80103654:	8b 45 08             	mov    0x8(%ebp),%eax
80103657:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010365b:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
8010365f:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80103663:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80103667:	ec                   	in     (%dx),%al
80103668:	89 c3                	mov    %eax,%ebx
8010366a:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
8010366d:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80103671:	83 c4 14             	add    $0x14,%esp
80103674:	5b                   	pop    %ebx
80103675:	5d                   	pop    %ebp
80103676:	c3                   	ret    

80103677 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103677:	55                   	push   %ebp
80103678:	89 e5                	mov    %esp,%ebp
8010367a:	83 ec 08             	sub    $0x8,%esp
8010367d:	8b 55 08             	mov    0x8(%ebp),%edx
80103680:	8b 45 0c             	mov    0xc(%ebp),%eax
80103683:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103687:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010368a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010368e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103692:	ee                   	out    %al,(%dx)
}
80103693:	c9                   	leave  
80103694:	c3                   	ret    

80103695 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103695:	55                   	push   %ebp
80103696:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103698:	a1 44 b6 10 80       	mov    0x8010b644,%eax
8010369d:	89 c2                	mov    %eax,%edx
8010369f:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
801036a4:	89 d1                	mov    %edx,%ecx
801036a6:	29 c1                	sub    %eax,%ecx
801036a8:	89 c8                	mov    %ecx,%eax
801036aa:	c1 f8 02             	sar    $0x2,%eax
801036ad:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
801036b3:	5d                   	pop    %ebp
801036b4:	c3                   	ret    

801036b5 <sum>:

static uchar
sum(uchar *addr, int len)
{
801036b5:	55                   	push   %ebp
801036b6:	89 e5                	mov    %esp,%ebp
801036b8:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
801036bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801036c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801036c9:	eb 15                	jmp    801036e0 <sum+0x2b>
    sum += addr[i];
801036cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801036ce:	8b 45 08             	mov    0x8(%ebp),%eax
801036d1:	01 d0                	add    %edx,%eax
801036d3:	0f b6 00             	movzbl (%eax),%eax
801036d6:	0f b6 c0             	movzbl %al,%eax
801036d9:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801036dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801036e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801036e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036e6:	7c e3                	jl     801036cb <sum+0x16>
    sum += addr[i];
  return sum;
801036e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801036eb:	c9                   	leave  
801036ec:	c3                   	ret    

801036ed <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036ed:	55                   	push   %ebp
801036ee:	89 e5                	mov    %esp,%ebp
801036f0:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801036f3:	8b 45 08             	mov    0x8(%ebp),%eax
801036f6:	89 04 24             	mov    %eax,(%esp)
801036f9:	e8 42 ff ff ff       	call   80103640 <p2v>
801036fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103701:	8b 55 0c             	mov    0xc(%ebp),%edx
80103704:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103707:	01 d0                	add    %edx,%eax
80103709:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
8010370c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010370f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103712:	eb 3f                	jmp    80103753 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103714:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010371b:	00 
8010371c:	c7 44 24 04 78 83 10 	movl   $0x80108378,0x4(%esp)
80103723:	80 
80103724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103727:	89 04 24             	mov    %eax,(%esp)
8010372a:	e8 da 16 00 00       	call   80104e09 <memcmp>
8010372f:	85 c0                	test   %eax,%eax
80103731:	75 1c                	jne    8010374f <mpsearch1+0x62>
80103733:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010373a:	00 
8010373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373e:	89 04 24             	mov    %eax,(%esp)
80103741:	e8 6f ff ff ff       	call   801036b5 <sum>
80103746:	84 c0                	test   %al,%al
80103748:	75 05                	jne    8010374f <mpsearch1+0x62>
      return (struct mp*)p;
8010374a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010374d:	eb 11                	jmp    80103760 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010374f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103756:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103759:	72 b9                	jb     80103714 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
8010375b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103760:	c9                   	leave  
80103761:	c3                   	ret    

80103762 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103762:	55                   	push   %ebp
80103763:	89 e5                	mov    %esp,%ebp
80103765:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103768:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103772:	83 c0 0f             	add    $0xf,%eax
80103775:	0f b6 00             	movzbl (%eax),%eax
80103778:	0f b6 c0             	movzbl %al,%eax
8010377b:	89 c2                	mov    %eax,%edx
8010377d:	c1 e2 08             	shl    $0x8,%edx
80103780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103783:	83 c0 0e             	add    $0xe,%eax
80103786:	0f b6 00             	movzbl (%eax),%eax
80103789:	0f b6 c0             	movzbl %al,%eax
8010378c:	09 d0                	or     %edx,%eax
8010378e:	c1 e0 04             	shl    $0x4,%eax
80103791:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103798:	74 21                	je     801037bb <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
8010379a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037a1:	00 
801037a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a5:	89 04 24             	mov    %eax,(%esp)
801037a8:	e8 40 ff ff ff       	call   801036ed <mpsearch1>
801037ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037b4:	74 50                	je     80103806 <mpsearch+0xa4>
      return mp;
801037b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037b9:	eb 5f                	jmp    8010381a <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801037bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037be:	83 c0 14             	add    $0x14,%eax
801037c1:	0f b6 00             	movzbl (%eax),%eax
801037c4:	0f b6 c0             	movzbl %al,%eax
801037c7:	89 c2                	mov    %eax,%edx
801037c9:	c1 e2 08             	shl    $0x8,%edx
801037cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037cf:	83 c0 13             	add    $0x13,%eax
801037d2:	0f b6 00             	movzbl (%eax),%eax
801037d5:	0f b6 c0             	movzbl %al,%eax
801037d8:	09 d0                	or     %edx,%eax
801037da:	c1 e0 0a             	shl    $0xa,%eax
801037dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
801037e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037e3:	2d 00 04 00 00       	sub    $0x400,%eax
801037e8:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037ef:	00 
801037f0:	89 04 24             	mov    %eax,(%esp)
801037f3:	e8 f5 fe ff ff       	call   801036ed <mpsearch1>
801037f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037ff:	74 05                	je     80103806 <mpsearch+0xa4>
      return mp;
80103801:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103804:	eb 14                	jmp    8010381a <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103806:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
8010380d:	00 
8010380e:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103815:	e8 d3 fe ff ff       	call   801036ed <mpsearch1>
}
8010381a:	c9                   	leave  
8010381b:	c3                   	ret    

8010381c <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
8010381c:	55                   	push   %ebp
8010381d:	89 e5                	mov    %esp,%ebp
8010381f:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103822:	e8 3b ff ff ff       	call   80103762 <mpsearch>
80103827:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010382a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010382e:	74 0a                	je     8010383a <mpconfig+0x1e>
80103830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103833:	8b 40 04             	mov    0x4(%eax),%eax
80103836:	85 c0                	test   %eax,%eax
80103838:	75 0a                	jne    80103844 <mpconfig+0x28>
    return 0;
8010383a:	b8 00 00 00 00       	mov    $0x0,%eax
8010383f:	e9 83 00 00 00       	jmp    801038c7 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103847:	8b 40 04             	mov    0x4(%eax),%eax
8010384a:	89 04 24             	mov    %eax,(%esp)
8010384d:	e8 ee fd ff ff       	call   80103640 <p2v>
80103852:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103855:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010385c:	00 
8010385d:	c7 44 24 04 7d 83 10 	movl   $0x8010837d,0x4(%esp)
80103864:	80 
80103865:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103868:	89 04 24             	mov    %eax,(%esp)
8010386b:	e8 99 15 00 00       	call   80104e09 <memcmp>
80103870:	85 c0                	test   %eax,%eax
80103872:	74 07                	je     8010387b <mpconfig+0x5f>
    return 0;
80103874:	b8 00 00 00 00       	mov    $0x0,%eax
80103879:	eb 4c                	jmp    801038c7 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
8010387b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387e:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103882:	3c 01                	cmp    $0x1,%al
80103884:	74 12                	je     80103898 <mpconfig+0x7c>
80103886:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103889:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010388d:	3c 04                	cmp    $0x4,%al
8010388f:	74 07                	je     80103898 <mpconfig+0x7c>
    return 0;
80103891:	b8 00 00 00 00       	mov    $0x0,%eax
80103896:	eb 2f                	jmp    801038c7 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103898:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010389b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010389f:	0f b7 c0             	movzwl %ax,%eax
801038a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801038a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a9:	89 04 24             	mov    %eax,(%esp)
801038ac:	e8 04 fe ff ff       	call   801036b5 <sum>
801038b1:	84 c0                	test   %al,%al
801038b3:	74 07                	je     801038bc <mpconfig+0xa0>
    return 0;
801038b5:	b8 00 00 00 00       	mov    $0x0,%eax
801038ba:	eb 0b                	jmp    801038c7 <mpconfig+0xab>
  *pmp = mp;
801038bc:	8b 45 08             	mov    0x8(%ebp),%eax
801038bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038c2:	89 10                	mov    %edx,(%eax)
  return conf;
801038c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801038c7:	c9                   	leave  
801038c8:	c3                   	ret    

801038c9 <mpinit>:

void
mpinit(void)
{
801038c9:	55                   	push   %ebp
801038ca:	89 e5                	mov    %esp,%ebp
801038cc:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
801038cf:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
801038d6:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
801038d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801038dc:	89 04 24             	mov    %eax,(%esp)
801038df:	e8 38 ff ff ff       	call   8010381c <mpconfig>
801038e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801038e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801038eb:	0f 84 9c 01 00 00    	je     80103a8d <mpinit+0x1c4>
    return;
  ismp = 1;
801038f1:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
801038f8:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038fe:	8b 40 24             	mov    0x24(%eax),%eax
80103901:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103906:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103909:	83 c0 2c             	add    $0x2c,%eax
8010390c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010390f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103912:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103916:	0f b7 d0             	movzwl %ax,%edx
80103919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010391c:	01 d0                	add    %edx,%eax
8010391e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103921:	e9 f4 00 00 00       	jmp    80103a1a <mpinit+0x151>
    switch(*p){
80103926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103929:	0f b6 00             	movzbl (%eax),%eax
8010392c:	0f b6 c0             	movzbl %al,%eax
8010392f:	83 f8 04             	cmp    $0x4,%eax
80103932:	0f 87 bf 00 00 00    	ja     801039f7 <mpinit+0x12e>
80103938:	8b 04 85 c0 83 10 80 	mov    -0x7fef7c40(,%eax,4),%eax
8010393f:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103944:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103947:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010394a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010394e:	0f b6 d0             	movzbl %al,%edx
80103951:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103956:	39 c2                	cmp    %eax,%edx
80103958:	74 2d                	je     80103987 <mpinit+0xbe>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
8010395a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010395d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103961:	0f b6 d0             	movzbl %al,%edx
80103964:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103969:	89 54 24 08          	mov    %edx,0x8(%esp)
8010396d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103971:	c7 04 24 82 83 10 80 	movl   $0x80108382,(%esp)
80103978:	e8 2d ca ff ff       	call   801003aa <cprintf>
        ismp = 0;
8010397d:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103984:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103987:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010398a:	0f b6 40 03          	movzbl 0x3(%eax),%eax
8010398e:	0f b6 c0             	movzbl %al,%eax
80103991:	83 e0 02             	and    $0x2,%eax
80103994:	85 c0                	test   %eax,%eax
80103996:	74 15                	je     801039ad <mpinit+0xe4>
        bcpu = &cpus[ncpu];
80103998:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010399d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039a3:	05 20 f9 10 80       	add    $0x8010f920,%eax
801039a8:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
801039ad:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
801039b3:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039b8:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
801039be:	81 c2 20 f9 10 80    	add    $0x8010f920,%edx
801039c4:	88 02                	mov    %al,(%edx)
      ncpu++;
801039c6:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039cb:	83 c0 01             	add    $0x1,%eax
801039ce:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
801039d3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
801039d7:	eb 41                	jmp    80103a1a <mpinit+0x151>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
801039d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801039df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039e2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039e6:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
801039eb:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039ef:	eb 29                	jmp    80103a1a <mpinit+0x151>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039f1:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039f5:	eb 23                	jmp    80103a1a <mpinit+0x151>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801039f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039fa:	0f b6 00             	movzbl (%eax),%eax
801039fd:	0f b6 c0             	movzbl %al,%eax
80103a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a04:	c7 04 24 a0 83 10 80 	movl   $0x801083a0,(%esp)
80103a0b:	e8 9a c9 ff ff       	call   801003aa <cprintf>
      ismp = 0;
80103a10:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103a17:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a20:	0f 82 00 ff ff ff    	jb     80103926 <mpinit+0x5d>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103a26:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103a2b:	85 c0                	test   %eax,%eax
80103a2d:	75 1d                	jne    80103a4c <mpinit+0x183>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103a2f:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
80103a36:	00 00 00 
    lapic = 0;
80103a39:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
80103a40:	00 00 00 
    ioapicid = 0;
80103a43:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
80103a4a:	eb 41                	jmp    80103a8d <mpinit+0x1c4>
    return;
  }

  if(mp->imcrp){
80103a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a4f:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103a53:	84 c0                	test   %al,%al
80103a55:	74 36                	je     80103a8d <mpinit+0x1c4>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a57:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a5e:	00 
80103a5f:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a66:	e8 0c fc ff ff       	call   80103677 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a6b:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a72:	e8 d6 fb ff ff       	call   8010364d <inb>
80103a77:	83 c8 01             	or     $0x1,%eax
80103a7a:	0f b6 c0             	movzbl %al,%eax
80103a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a81:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a88:	e8 ea fb ff ff       	call   80103677 <outb>
  }
}
80103a8d:	c9                   	leave  
80103a8e:	c3                   	ret    
	...

80103a90 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 08             	sub    $0x8,%esp
80103a96:	8b 55 08             	mov    0x8(%ebp),%edx
80103a99:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a9c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103aa0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103aa3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103aa7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103aab:	ee                   	out    %al,(%dx)
}
80103aac:	c9                   	leave  
80103aad:	c3                   	ret    

80103aae <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103aae:	55                   	push   %ebp
80103aaf:	89 e5                	mov    %esp,%ebp
80103ab1:	83 ec 0c             	sub    $0xc,%esp
80103ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ab7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103abb:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103abf:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103ac5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ac9:	0f b6 c0             	movzbl %al,%eax
80103acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ad0:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ad7:	e8 b4 ff ff ff       	call   80103a90 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103adc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ae0:	66 c1 e8 08          	shr    $0x8,%ax
80103ae4:	0f b6 c0             	movzbl %al,%eax
80103ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aeb:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103af2:	e8 99 ff ff ff       	call   80103a90 <outb>
}
80103af7:	c9                   	leave  
80103af8:	c3                   	ret    

80103af9 <picenable>:

void
picenable(int irq)
{
80103af9:	55                   	push   %ebp
80103afa:	89 e5                	mov    %esp,%ebp
80103afc:	53                   	push   %ebx
80103afd:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103b00:	8b 45 08             	mov    0x8(%ebp),%eax
80103b03:	ba 01 00 00 00       	mov    $0x1,%edx
80103b08:	89 d3                	mov    %edx,%ebx
80103b0a:	89 c1                	mov    %eax,%ecx
80103b0c:	d3 e3                	shl    %cl,%ebx
80103b0e:	89 d8                	mov    %ebx,%eax
80103b10:	89 c2                	mov    %eax,%edx
80103b12:	f7 d2                	not    %edx
80103b14:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103b1b:	21 d0                	and    %edx,%eax
80103b1d:	0f b7 c0             	movzwl %ax,%eax
80103b20:	89 04 24             	mov    %eax,(%esp)
80103b23:	e8 86 ff ff ff       	call   80103aae <picsetmask>
}
80103b28:	83 c4 04             	add    $0x4,%esp
80103b2b:	5b                   	pop    %ebx
80103b2c:	5d                   	pop    %ebp
80103b2d:	c3                   	ret    

80103b2e <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103b2e:	55                   	push   %ebp
80103b2f:	89 e5                	mov    %esp,%ebp
80103b31:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103b34:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b3b:	00 
80103b3c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b43:	e8 48 ff ff ff       	call   80103a90 <outb>
  outb(IO_PIC2+1, 0xFF);
80103b48:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b4f:	00 
80103b50:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b57:	e8 34 ff ff ff       	call   80103a90 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b5c:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b63:	00 
80103b64:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b6b:	e8 20 ff ff ff       	call   80103a90 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b70:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b77:	00 
80103b78:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b7f:	e8 0c ff ff ff       	call   80103a90 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b84:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b8b:	00 
80103b8c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b93:	e8 f8 fe ff ff       	call   80103a90 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b98:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b9f:	00 
80103ba0:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ba7:	e8 e4 fe ff ff       	call   80103a90 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103bac:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103bb3:	00 
80103bb4:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bbb:	e8 d0 fe ff ff       	call   80103a90 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103bc0:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103bc7:	00 
80103bc8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bcf:	e8 bc fe ff ff       	call   80103a90 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103bd4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103bdb:	00 
80103bdc:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103be3:	e8 a8 fe ff ff       	call   80103a90 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103be8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bef:	00 
80103bf0:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bf7:	e8 94 fe ff ff       	call   80103a90 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bfc:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c03:	00 
80103c04:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c0b:	e8 80 fe ff ff       	call   80103a90 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103c10:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c17:	00 
80103c18:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c1f:	e8 6c fe ff ff       	call   80103a90 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103c24:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c2b:	00 
80103c2c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c33:	e8 58 fe ff ff       	call   80103a90 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103c38:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c3f:	00 
80103c40:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c47:	e8 44 fe ff ff       	call   80103a90 <outb>

  if(irqmask != 0xFFFF)
80103c4c:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c53:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c57:	74 12                	je     80103c6b <picinit+0x13d>
    picsetmask(irqmask);
80103c59:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c60:	0f b7 c0             	movzwl %ax,%eax
80103c63:	89 04 24             	mov    %eax,(%esp)
80103c66:	e8 43 fe ff ff       	call   80103aae <picsetmask>
}
80103c6b:	c9                   	leave  
80103c6c:	c3                   	ret    
80103c6d:	00 00                	add    %al,(%eax)
	...

80103c70 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c86:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c89:	8b 10                	mov    (%eax),%edx
80103c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c8e:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c90:	e8 a7 d2 ff ff       	call   80100f3c <filealloc>
80103c95:	8b 55 08             	mov    0x8(%ebp),%edx
80103c98:	89 02                	mov    %eax,(%edx)
80103c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c9d:	8b 00                	mov    (%eax),%eax
80103c9f:	85 c0                	test   %eax,%eax
80103ca1:	0f 84 c8 00 00 00    	je     80103d6f <pipealloc+0xff>
80103ca7:	e8 90 d2 ff ff       	call   80100f3c <filealloc>
80103cac:	8b 55 0c             	mov    0xc(%ebp),%edx
80103caf:	89 02                	mov    %eax,(%edx)
80103cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cb4:	8b 00                	mov    (%eax),%eax
80103cb6:	85 c0                	test   %eax,%eax
80103cb8:	0f 84 b1 00 00 00    	je     80103d6f <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103cbe:	e8 74 ee ff ff       	call   80102b37 <kalloc>
80103cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cca:	0f 84 9e 00 00 00    	je     80103d6e <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103cda:	00 00 00 
  p->writeopen = 1;
80103cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce0:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ce7:	00 00 00 
  p->nwrite = 0;
80103cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ced:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cf4:	00 00 00 
  p->nread = 0;
80103cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfa:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d01:	00 00 00 
  initlock(&p->lock, "pipe");
80103d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d07:	c7 44 24 04 d4 83 10 	movl   $0x801083d4,0x4(%esp)
80103d0e:	80 
80103d0f:	89 04 24             	mov    %eax,(%esp)
80103d12:	e8 ff 0d 00 00       	call   80104b16 <initlock>
  (*f0)->type = FD_PIPE;
80103d17:	8b 45 08             	mov    0x8(%ebp),%eax
80103d1a:	8b 00                	mov    (%eax),%eax
80103d1c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d22:	8b 45 08             	mov    0x8(%ebp),%eax
80103d25:	8b 00                	mov    (%eax),%eax
80103d27:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2e:	8b 00                	mov    (%eax),%eax
80103d30:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d34:	8b 45 08             	mov    0x8(%ebp),%eax
80103d37:	8b 00                	mov    (%eax),%eax
80103d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d3c:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d42:	8b 00                	mov    (%eax),%eax
80103d44:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d4d:	8b 00                	mov    (%eax),%eax
80103d4f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d53:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d56:	8b 00                	mov    (%eax),%eax
80103d58:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d5f:	8b 00                	mov    (%eax),%eax
80103d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d64:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d67:	b8 00 00 00 00       	mov    $0x0,%eax
80103d6c:	eb 43                	jmp    80103db1 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d6e:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d73:	74 0b                	je     80103d80 <pipealloc+0x110>
    kfree((char*)p);
80103d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d78:	89 04 24             	mov    %eax,(%esp)
80103d7b:	e8 1e ed ff ff       	call   80102a9e <kfree>
  if(*f0)
80103d80:	8b 45 08             	mov    0x8(%ebp),%eax
80103d83:	8b 00                	mov    (%eax),%eax
80103d85:	85 c0                	test   %eax,%eax
80103d87:	74 0d                	je     80103d96 <pipealloc+0x126>
    fileclose(*f0);
80103d89:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8c:	8b 00                	mov    (%eax),%eax
80103d8e:	89 04 24             	mov    %eax,(%esp)
80103d91:	e8 4e d2 ff ff       	call   80100fe4 <fileclose>
  if(*f1)
80103d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d99:	8b 00                	mov    (%eax),%eax
80103d9b:	85 c0                	test   %eax,%eax
80103d9d:	74 0d                	je     80103dac <pipealloc+0x13c>
    fileclose(*f1);
80103d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103da2:	8b 00                	mov    (%eax),%eax
80103da4:	89 04 24             	mov    %eax,(%esp)
80103da7:	e8 38 d2 ff ff       	call   80100fe4 <fileclose>
  return -1;
80103dac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103db1:	c9                   	leave  
80103db2:	c3                   	ret    

80103db3 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103db3:	55                   	push   %ebp
80103db4:	89 e5                	mov    %esp,%ebp
80103db6:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103db9:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbc:	89 04 24             	mov    %eax,(%esp)
80103dbf:	e8 73 0d 00 00       	call   80104b37 <acquire>
  if(writable){
80103dc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103dc8:	74 1f                	je     80103de9 <pipeclose+0x36>
    p->writeopen = 0;
80103dca:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcd:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103dd4:	00 00 00 
    wakeup(&p->nread);
80103dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dda:	05 34 02 00 00       	add    $0x234,%eax
80103ddf:	89 04 24             	mov    %eax,(%esp)
80103de2:	e8 4c 0b 00 00       	call   80104933 <wakeup>
80103de7:	eb 1d                	jmp    80103e06 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103de9:	8b 45 08             	mov    0x8(%ebp),%eax
80103dec:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103df3:	00 00 00 
    wakeup(&p->nwrite);
80103df6:	8b 45 08             	mov    0x8(%ebp),%eax
80103df9:	05 38 02 00 00       	add    $0x238,%eax
80103dfe:	89 04 24             	mov    %eax,(%esp)
80103e01:	e8 2d 0b 00 00       	call   80104933 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e06:	8b 45 08             	mov    0x8(%ebp),%eax
80103e09:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e0f:	85 c0                	test   %eax,%eax
80103e11:	75 25                	jne    80103e38 <pipeclose+0x85>
80103e13:	8b 45 08             	mov    0x8(%ebp),%eax
80103e16:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e1c:	85 c0                	test   %eax,%eax
80103e1e:	75 18                	jne    80103e38 <pipeclose+0x85>
    release(&p->lock);
80103e20:	8b 45 08             	mov    0x8(%ebp),%eax
80103e23:	89 04 24             	mov    %eax,(%esp)
80103e26:	e8 6e 0d 00 00       	call   80104b99 <release>
    kfree((char*)p);
80103e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2e:	89 04 24             	mov    %eax,(%esp)
80103e31:	e8 68 ec ff ff       	call   80102a9e <kfree>
80103e36:	eb 0b                	jmp    80103e43 <pipeclose+0x90>
  } else
    release(&p->lock);
80103e38:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3b:	89 04 24             	mov    %eax,(%esp)
80103e3e:	e8 56 0d 00 00       	call   80104b99 <release>
}
80103e43:	c9                   	leave  
80103e44:	c3                   	ret    

80103e45 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e45:	55                   	push   %ebp
80103e46:	89 e5                	mov    %esp,%ebp
80103e48:	53                   	push   %ebx
80103e49:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e4f:	89 04 24             	mov    %eax,(%esp)
80103e52:	e8 e0 0c 00 00       	call   80104b37 <acquire>
  for(i = 0; i < n; i++){
80103e57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e5e:	e9 a8 00 00 00       	jmp    80103f0b <pipewrite+0xc6>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e63:	8b 45 08             	mov    0x8(%ebp),%eax
80103e66:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e6c:	85 c0                	test   %eax,%eax
80103e6e:	74 0d                	je     80103e7d <pipewrite+0x38>
80103e70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e76:	8b 40 24             	mov    0x24(%eax),%eax
80103e79:	85 c0                	test   %eax,%eax
80103e7b:	74 15                	je     80103e92 <pipewrite+0x4d>
        release(&p->lock);
80103e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e80:	89 04 24             	mov    %eax,(%esp)
80103e83:	e8 11 0d 00 00       	call   80104b99 <release>
        return -1;
80103e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e8d:	e9 9f 00 00 00       	jmp    80103f31 <pipewrite+0xec>
      }
      wakeup(&p->nread);
80103e92:	8b 45 08             	mov    0x8(%ebp),%eax
80103e95:	05 34 02 00 00       	add    $0x234,%eax
80103e9a:	89 04 24             	mov    %eax,(%esp)
80103e9d:	e8 91 0a 00 00       	call   80104933 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea5:	8b 55 08             	mov    0x8(%ebp),%edx
80103ea8:	81 c2 38 02 00 00    	add    $0x238,%edx
80103eae:	89 44 24 04          	mov    %eax,0x4(%esp)
80103eb2:	89 14 24             	mov    %edx,(%esp)
80103eb5:	e8 a0 09 00 00       	call   8010485a <sleep>
80103eba:	eb 01                	jmp    80103ebd <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ebc:	90                   	nop
80103ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec0:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec9:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103ecf:	05 00 02 00 00       	add    $0x200,%eax
80103ed4:	39 c2                	cmp    %eax,%edx
80103ed6:	74 8b                	je     80103e63 <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80103edb:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ee1:	89 c3                	mov    %eax,%ebx
80103ee3:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103ee9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103eec:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eef:	01 ca                	add    %ecx,%edx
80103ef1:	0f b6 0a             	movzbl (%edx),%ecx
80103ef4:	8b 55 08             	mov    0x8(%ebp),%edx
80103ef7:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103efb:	8d 50 01             	lea    0x1(%eax),%edx
80103efe:	8b 45 08             	mov    0x8(%ebp),%eax
80103f01:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103f07:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f0e:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f11:	7c a9                	jl     80103ebc <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f13:	8b 45 08             	mov    0x8(%ebp),%eax
80103f16:	05 34 02 00 00       	add    $0x234,%eax
80103f1b:	89 04 24             	mov    %eax,(%esp)
80103f1e:	e8 10 0a 00 00       	call   80104933 <wakeup>
  release(&p->lock);
80103f23:	8b 45 08             	mov    0x8(%ebp),%eax
80103f26:	89 04 24             	mov    %eax,(%esp)
80103f29:	e8 6b 0c 00 00       	call   80104b99 <release>
  return n;
80103f2e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103f31:	83 c4 24             	add    $0x24,%esp
80103f34:	5b                   	pop    %ebx
80103f35:	5d                   	pop    %ebp
80103f36:	c3                   	ret    

80103f37 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f37:	55                   	push   %ebp
80103f38:	89 e5                	mov    %esp,%ebp
80103f3a:	53                   	push   %ebx
80103f3b:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103f3e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f41:	89 04 24             	mov    %eax,(%esp)
80103f44:	e8 ee 0b 00 00       	call   80104b37 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f49:	eb 3a                	jmp    80103f85 <piperead+0x4e>
    if(proc->killed){
80103f4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f51:	8b 40 24             	mov    0x24(%eax),%eax
80103f54:	85 c0                	test   %eax,%eax
80103f56:	74 15                	je     80103f6d <piperead+0x36>
      release(&p->lock);
80103f58:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5b:	89 04 24             	mov    %eax,(%esp)
80103f5e:	e8 36 0c 00 00       	call   80104b99 <release>
      return -1;
80103f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f68:	e9 b7 00 00 00       	jmp    80104024 <piperead+0xed>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f70:	8b 55 08             	mov    0x8(%ebp),%edx
80103f73:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f79:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f7d:	89 14 24             	mov    %edx,(%esp)
80103f80:	e8 d5 08 00 00       	call   8010485a <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f85:	8b 45 08             	mov    0x8(%ebp),%eax
80103f88:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f91:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f97:	39 c2                	cmp    %eax,%edx
80103f99:	75 0d                	jne    80103fa8 <piperead+0x71>
80103f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103fa4:	85 c0                	test   %eax,%eax
80103fa6:	75 a3                	jne    80103f4b <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103faf:	eb 4a                	jmp    80103ffb <piperead+0xc4>
    if(p->nread == p->nwrite)
80103fb1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103fba:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fc3:	39 c2                	cmp    %eax,%edx
80103fc5:	74 3e                	je     80104005 <piperead+0xce>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fca:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fcd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd3:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103fd9:	89 c3                	mov    %eax,%ebx
80103fdb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103fe1:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe4:	0f b6 54 1a 34       	movzbl 0x34(%edx,%ebx,1),%edx
80103fe9:	88 11                	mov    %dl,(%ecx)
80103feb:	8d 50 01             	lea    0x1(%eax),%edx
80103fee:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff1:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ff7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ffe:	3b 45 10             	cmp    0x10(%ebp),%eax
80104001:	7c ae                	jl     80103fb1 <piperead+0x7a>
80104003:	eb 01                	jmp    80104006 <piperead+0xcf>
    if(p->nread == p->nwrite)
      break;
80104005:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104006:	8b 45 08             	mov    0x8(%ebp),%eax
80104009:	05 38 02 00 00       	add    $0x238,%eax
8010400e:	89 04 24             	mov    %eax,(%esp)
80104011:	e8 1d 09 00 00       	call   80104933 <wakeup>
  release(&p->lock);
80104016:	8b 45 08             	mov    0x8(%ebp),%eax
80104019:	89 04 24             	mov    %eax,(%esp)
8010401c:	e8 78 0b 00 00       	call   80104b99 <release>
  return i;
80104021:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104024:	83 c4 24             	add    $0x24,%esp
80104027:	5b                   	pop    %ebx
80104028:	5d                   	pop    %ebp
80104029:	c3                   	ret    
	...

8010402c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010402c:	55                   	push   %ebp
8010402d:	89 e5                	mov    %esp,%ebp
8010402f:	53                   	push   %ebx
80104030:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104033:	9c                   	pushf  
80104034:	5b                   	pop    %ebx
80104035:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104038:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010403b:	83 c4 10             	add    $0x10,%esp
8010403e:	5b                   	pop    %ebx
8010403f:	5d                   	pop    %ebp
80104040:	c3                   	ret    

80104041 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104041:	55                   	push   %ebp
80104042:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104044:	fb                   	sti    
}
80104045:	5d                   	pop    %ebp
80104046:	c3                   	ret    

80104047 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104047:	55                   	push   %ebp
80104048:	89 e5                	mov    %esp,%ebp
8010404a:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010404d:	c7 44 24 04 d9 83 10 	movl   $0x801083d9,0x4(%esp)
80104054:	80 
80104055:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010405c:	e8 b5 0a 00 00       	call   80104b16 <initlock>
}
80104061:	c9                   	leave  
80104062:	c3                   	ret    

80104063 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104063:	55                   	push   %ebp
80104064:	89 e5                	mov    %esp,%ebp
80104066:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104069:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104070:	e8 c2 0a 00 00       	call   80104b37 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104075:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010407c:	eb 0e                	jmp    8010408c <allocproc+0x29>
    if(p->state == UNUSED)
8010407e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104081:	8b 40 0c             	mov    0xc(%eax),%eax
80104084:	85 c0                	test   %eax,%eax
80104086:	74 23                	je     801040ab <allocproc+0x48>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104088:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010408c:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104093:	72 e9                	jb     8010407e <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104095:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010409c:	e8 f8 0a 00 00       	call   80104b99 <release>
  return 0;
801040a1:	b8 00 00 00 00       	mov    $0x0,%eax
801040a6:	e9 b5 00 00 00       	jmp    80104160 <allocproc+0xfd>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
801040ab:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801040ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040af:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801040b6:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801040bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040be:	89 42 10             	mov    %eax,0x10(%edx)
801040c1:	83 c0 01             	add    $0x1,%eax
801040c4:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
801040c9:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801040d0:	e8 c4 0a 00 00       	call   80104b99 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801040d5:	e8 5d ea ff ff       	call   80102b37 <kalloc>
801040da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040dd:	89 42 08             	mov    %eax,0x8(%edx)
801040e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e3:	8b 40 08             	mov    0x8(%eax),%eax
801040e6:	85 c0                	test   %eax,%eax
801040e8:	75 11                	jne    801040fb <allocproc+0x98>
    p->state = UNUSED;
801040ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801040f4:	b8 00 00 00 00       	mov    $0x0,%eax
801040f9:	eb 65                	jmp    80104160 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
801040fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fe:	8b 40 08             	mov    0x8(%eax),%eax
80104101:	05 00 10 00 00       	add    $0x1000,%eax
80104106:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104109:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010410d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104110:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104113:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104116:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010411a:	ba 94 61 10 80       	mov    $0x80106194,%edx
8010411f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104122:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104124:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010412e:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104134:	8b 40 1c             	mov    0x1c(%eax),%eax
80104137:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010413e:	00 
8010413f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104146:	00 
80104147:	89 04 24             	mov    %eax,(%esp)
8010414a:	e8 43 0c 00 00       	call   80104d92 <memset>
  p->context->eip = (uint)forkret;
8010414f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104152:	8b 40 1c             	mov    0x1c(%eax),%eax
80104155:	ba 2e 48 10 80       	mov    $0x8010482e,%edx
8010415a:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010415d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104160:	c9                   	leave  
80104161:	c3                   	ret    

80104162 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104162:	55                   	push   %ebp
80104163:	89 e5                	mov    %esp,%ebp
80104165:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104168:	e8 f6 fe ff ff       	call   80104063 <allocproc>
8010416d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104173:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104178:	e8 22 37 00 00       	call   8010789f <setupkvm>
8010417d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104180:	89 42 04             	mov    %eax,0x4(%edx)
80104183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104186:	8b 40 04             	mov    0x4(%eax),%eax
80104189:	85 c0                	test   %eax,%eax
8010418b:	75 0c                	jne    80104199 <userinit+0x37>
    panic("userinit: out of memory?");
8010418d:	c7 04 24 e0 83 10 80 	movl   $0x801083e0,(%esp)
80104194:	e8 ad c3 ff ff       	call   80100546 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104199:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010419e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a1:	8b 40 04             	mov    0x4(%eax),%eax
801041a4:	89 54 24 08          	mov    %edx,0x8(%esp)
801041a8:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
801041af:	80 
801041b0:	89 04 24             	mov    %eax,(%esp)
801041b3:	e8 3f 39 00 00       	call   80107af7 <inituvm>
  p->sz = PGSIZE;
801041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bb:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801041c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c4:	8b 40 18             	mov    0x18(%eax),%eax
801041c7:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801041ce:	00 
801041cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041d6:	00 
801041d7:	89 04 24             	mov    %eax,(%esp)
801041da:	e8 b3 0b 00 00       	call   80104d92 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e2:	8b 40 18             	mov    0x18(%eax),%eax
801041e5:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ee:	8b 40 18             	mov    0x18(%eax),%eax
801041f1:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fa:	8b 40 18             	mov    0x18(%eax),%eax
801041fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104200:	8b 52 18             	mov    0x18(%edx),%edx
80104203:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104207:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010420b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420e:	8b 40 18             	mov    0x18(%eax),%eax
80104211:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104214:	8b 52 18             	mov    0x18(%edx),%edx
80104217:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010421b:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010421f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104222:	8b 40 18             	mov    0x18(%eax),%eax
80104225:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010422c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422f:	8b 40 18             	mov    0x18(%eax),%eax
80104232:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010423c:	8b 40 18             	mov    0x18(%eax),%eax
8010423f:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104249:	83 c0 6c             	add    $0x6c,%eax
8010424c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104253:	00 
80104254:	c7 44 24 04 f9 83 10 	movl   $0x801083f9,0x4(%esp)
8010425b:	80 
8010425c:	89 04 24             	mov    %eax,(%esp)
8010425f:	e8 5e 0d 00 00       	call   80104fc2 <safestrcpy>
  p->cwd = namei("/");
80104264:	c7 04 24 02 84 10 80 	movl   $0x80108402,(%esp)
8010426b:	e8 d4 e1 ff ff       	call   80102444 <namei>
80104270:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104273:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104279:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104280:	c9                   	leave  
80104281:	c3                   	ret    

80104282 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104282:	55                   	push   %ebp
80104283:	89 e5                	mov    %esp,%ebp
80104285:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104288:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010428e:	8b 00                	mov    (%eax),%eax
80104290:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104293:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104297:	7e 34                	jle    801042cd <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104299:	8b 55 08             	mov    0x8(%ebp),%edx
8010429c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429f:	01 c2                	add    %eax,%edx
801042a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042a7:	8b 40 04             	mov    0x4(%eax),%eax
801042aa:	89 54 24 08          	mov    %edx,0x8(%esp)
801042ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b1:	89 54 24 04          	mov    %edx,0x4(%esp)
801042b5:	89 04 24             	mov    %eax,(%esp)
801042b8:	e8 b4 39 00 00       	call   80107c71 <allocuvm>
801042bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042c4:	75 41                	jne    80104307 <growproc+0x85>
      return -1;
801042c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042cb:	eb 58                	jmp    80104325 <growproc+0xa3>
  } else if(n < 0){
801042cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042d1:	79 34                	jns    80104307 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801042d3:	8b 55 08             	mov    0x8(%ebp),%edx
801042d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d9:	01 c2                	add    %eax,%edx
801042db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e1:	8b 40 04             	mov    0x4(%eax),%eax
801042e4:	89 54 24 08          	mov    %edx,0x8(%esp)
801042e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042eb:	89 54 24 04          	mov    %edx,0x4(%esp)
801042ef:	89 04 24             	mov    %eax,(%esp)
801042f2:	e8 54 3a 00 00       	call   80107d4b <deallocuvm>
801042f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042fe:	75 07                	jne    80104307 <growproc+0x85>
      return -1;
80104300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104305:	eb 1e                	jmp    80104325 <growproc+0xa3>
  }
  proc->sz = sz;
80104307:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010430d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104310:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104312:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104318:	89 04 24             	mov    %eax,(%esp)
8010431b:	e8 70 36 00 00       	call   80107990 <switchuvm>
  return 0;
80104320:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104325:	c9                   	leave  
80104326:	c3                   	ret    

80104327 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104327:	55                   	push   %ebp
80104328:	89 e5                	mov    %esp,%ebp
8010432a:	57                   	push   %edi
8010432b:	56                   	push   %esi
8010432c:	53                   	push   %ebx
8010432d:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104330:	e8 2e fd ff ff       	call   80104063 <allocproc>
80104335:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104338:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010433c:	75 0a                	jne    80104348 <fork+0x21>
    return -1;
8010433e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104343:	e9 3a 01 00 00       	jmp    80104482 <fork+0x15b>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104348:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010434e:	8b 10                	mov    (%eax),%edx
80104350:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104356:	8b 40 04             	mov    0x4(%eax),%eax
80104359:	89 54 24 04          	mov    %edx,0x4(%esp)
8010435d:	89 04 24             	mov    %eax,(%esp)
80104360:	e8 82 3b 00 00       	call   80107ee7 <copyuvm>
80104365:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104368:	89 42 04             	mov    %eax,0x4(%edx)
8010436b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010436e:	8b 40 04             	mov    0x4(%eax),%eax
80104371:	85 c0                	test   %eax,%eax
80104373:	75 2c                	jne    801043a1 <fork+0x7a>
    kfree(np->kstack);
80104375:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104378:	8b 40 08             	mov    0x8(%eax),%eax
8010437b:	89 04 24             	mov    %eax,(%esp)
8010437e:	e8 1b e7 ff ff       	call   80102a9e <kfree>
    np->kstack = 0;
80104383:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104386:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010438d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104390:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010439c:	e9 e1 00 00 00       	jmp    80104482 <fork+0x15b>
  }
  np->sz = proc->sz;
801043a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043a7:	8b 10                	mov    (%eax),%edx
801043a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043ac:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801043ae:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043b8:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801043bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043be:	8b 50 18             	mov    0x18(%eax),%edx
801043c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c7:	8b 40 18             	mov    0x18(%eax),%eax
801043ca:	89 c3                	mov    %eax,%ebx
801043cc:	b8 13 00 00 00       	mov    $0x13,%eax
801043d1:	89 d7                	mov    %edx,%edi
801043d3:	89 de                	mov    %ebx,%esi
801043d5:	89 c1                	mov    %eax,%ecx
801043d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801043d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043dc:	8b 40 18             	mov    0x18(%eax),%eax
801043df:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801043e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801043ed:	eb 3d                	jmp    8010442c <fork+0x105>
    if(proc->ofile[i])
801043ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043f8:	83 c2 08             	add    $0x8,%edx
801043fb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043ff:	85 c0                	test   %eax,%eax
80104401:	74 25                	je     80104428 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104403:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104409:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010440c:	83 c2 08             	add    $0x8,%edx
8010440f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104413:	89 04 24             	mov    %eax,(%esp)
80104416:	e8 81 cb ff ff       	call   80100f9c <filedup>
8010441b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010441e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104421:	83 c1 08             	add    $0x8,%ecx
80104424:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104428:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010442c:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104430:	7e bd                	jle    801043ef <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104432:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104438:	8b 40 68             	mov    0x68(%eax),%eax
8010443b:	89 04 24             	mov    %eax,(%esp)
8010443e:	e8 1e d4 ff ff       	call   80101861 <idup>
80104443:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104446:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104449:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010444c:	8b 40 10             	mov    0x10(%eax),%eax
8010444f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104452:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104455:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010445c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104462:	8d 50 6c             	lea    0x6c(%eax),%edx
80104465:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104468:	83 c0 6c             	add    $0x6c,%eax
8010446b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104472:	00 
80104473:	89 54 24 04          	mov    %edx,0x4(%esp)
80104477:	89 04 24             	mov    %eax,(%esp)
8010447a:	e8 43 0b 00 00       	call   80104fc2 <safestrcpy>
  return pid;
8010447f:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104482:	83 c4 2c             	add    $0x2c,%esp
80104485:	5b                   	pop    %ebx
80104486:	5e                   	pop    %esi
80104487:	5f                   	pop    %edi
80104488:	5d                   	pop    %ebp
80104489:	c3                   	ret    

8010448a <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010448a:	55                   	push   %ebp
8010448b:	89 e5                	mov    %esp,%ebp
8010448d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104490:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104497:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010449c:	39 c2                	cmp    %eax,%edx
8010449e:	75 0c                	jne    801044ac <exit+0x22>
    panic("init exiting");
801044a0:	c7 04 24 04 84 10 80 	movl   $0x80108404,(%esp)
801044a7:	e8 9a c0 ff ff       	call   80100546 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801044ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801044b3:	eb 44                	jmp    801044f9 <exit+0x6f>
    if(proc->ofile[fd]){
801044b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044be:	83 c2 08             	add    $0x8,%edx
801044c1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044c5:	85 c0                	test   %eax,%eax
801044c7:	74 2c                	je     801044f5 <exit+0x6b>
      fileclose(proc->ofile[fd]);
801044c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044d2:	83 c2 08             	add    $0x8,%edx
801044d5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044d9:	89 04 24             	mov    %eax,(%esp)
801044dc:	e8 03 cb ff ff       	call   80100fe4 <fileclose>
      proc->ofile[fd] = 0;
801044e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044ea:	83 c2 08             	add    $0x8,%edx
801044ed:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801044f4:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801044f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801044f9:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801044fd:	7e b6                	jle    801044b5 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
801044ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104505:	8b 40 68             	mov    0x68(%eax),%eax
80104508:	89 04 24             	mov    %eax,(%esp)
8010450b:	e8 36 d5 ff ff       	call   80101a46 <iput>
  proc->cwd = 0;
80104510:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104516:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010451d:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104524:	e8 0e 06 00 00       	call   80104b37 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104529:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010452f:	8b 40 14             	mov    0x14(%eax),%eax
80104532:	89 04 24             	mov    %eax,(%esp)
80104535:	e8 bb 03 00 00       	call   801048f5 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010453a:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104541:	eb 38                	jmp    8010457b <exit+0xf1>
    if(p->parent == proc){
80104543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104546:	8b 50 14             	mov    0x14(%eax),%edx
80104549:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010454f:	39 c2                	cmp    %eax,%edx
80104551:	75 24                	jne    80104577 <exit+0xed>
      p->parent = initproc;
80104553:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455c:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010455f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104562:	8b 40 0c             	mov    0xc(%eax),%eax
80104565:	83 f8 05             	cmp    $0x5,%eax
80104568:	75 0d                	jne    80104577 <exit+0xed>
        wakeup1(initproc);
8010456a:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010456f:	89 04 24             	mov    %eax,(%esp)
80104572:	e8 7e 03 00 00       	call   801048f5 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104577:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010457b:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104582:	72 bf                	jb     80104543 <exit+0xb9>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104584:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010458a:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104591:	e8 b4 01 00 00       	call   8010474a <sched>
  panic("zombie exit");
80104596:	c7 04 24 11 84 10 80 	movl   $0x80108411,(%esp)
8010459d:	e8 a4 bf ff ff       	call   80100546 <panic>

801045a2 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801045a2:	55                   	push   %ebp
801045a3:	89 e5                	mov    %esp,%ebp
801045a5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801045a8:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801045af:	e8 83 05 00 00       	call   80104b37 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801045b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045bb:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801045c2:	e9 9a 00 00 00       	jmp    80104661 <wait+0xbf>
      if(p->parent != proc)
801045c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ca:	8b 50 14             	mov    0x14(%eax),%edx
801045cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045d3:	39 c2                	cmp    %eax,%edx
801045d5:	0f 85 81 00 00 00    	jne    8010465c <wait+0xba>
        continue;
      havekids = 1;
801045db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801045e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e5:	8b 40 0c             	mov    0xc(%eax),%eax
801045e8:	83 f8 05             	cmp    $0x5,%eax
801045eb:	75 70                	jne    8010465d <wait+0xbb>
        // Found one.
        pid = p->pid;
801045ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f0:	8b 40 10             	mov    0x10(%eax),%eax
801045f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801045f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f9:	8b 40 08             	mov    0x8(%eax),%eax
801045fc:	89 04 24             	mov    %eax,(%esp)
801045ff:	e8 9a e4 ff ff       	call   80102a9e <kfree>
        p->kstack = 0;
80104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104607:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010460e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104611:	8b 40 04             	mov    0x4(%eax),%eax
80104614:	89 04 24             	mov    %eax,(%esp)
80104617:	e8 eb 37 00 00       	call   80107e07 <freevm>
        p->state = UNUSED;
8010461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104629:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104633:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010463a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104644:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
8010464b:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104652:	e8 42 05 00 00       	call   80104b99 <release>
        return pid;
80104657:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010465a:	eb 53                	jmp    801046af <wait+0x10d>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
8010465c:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465d:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104661:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104668:	0f 82 59 ff ff ff    	jb     801045c7 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
8010466e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104672:	74 0d                	je     80104681 <wait+0xdf>
80104674:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010467a:	8b 40 24             	mov    0x24(%eax),%eax
8010467d:	85 c0                	test   %eax,%eax
8010467f:	74 13                	je     80104694 <wait+0xf2>
      release(&ptable.lock);
80104681:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104688:	e8 0c 05 00 00       	call   80104b99 <release>
      return -1;
8010468d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104692:	eb 1b                	jmp    801046af <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104694:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469a:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
801046a1:	80 
801046a2:	89 04 24             	mov    %eax,(%esp)
801046a5:	e8 b0 01 00 00       	call   8010485a <sleep>
  }
801046aa:	e9 05 ff ff ff       	jmp    801045b4 <wait+0x12>
}
801046af:	c9                   	leave  
801046b0:	c3                   	ret    

801046b1 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801046b1:	55                   	push   %ebp
801046b2:	89 e5                	mov    %esp,%ebp
801046b4:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801046b7:	e8 85 f9 ff ff       	call   80104041 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801046bc:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801046c3:	e8 6f 04 00 00       	call   80104b37 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c8:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801046cf:	eb 5f                	jmp    80104730 <scheduler+0x7f>
      if(p->state != RUNNABLE)
801046d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d4:	8b 40 0c             	mov    0xc(%eax),%eax
801046d7:	83 f8 03             	cmp    $0x3,%eax
801046da:	75 4f                	jne    8010472b <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
801046dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046df:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
801046e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e8:	89 04 24             	mov    %eax,(%esp)
801046eb:	e8 a0 32 00 00       	call   80107990 <switchuvm>
      p->state = RUNNING;
801046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f3:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
801046fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104700:	8b 40 1c             	mov    0x1c(%eax),%eax
80104703:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010470a:	83 c2 04             	add    $0x4,%edx
8010470d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104711:	89 14 24             	mov    %edx,(%esp)
80104714:	e8 1f 09 00 00       	call   80105038 <swtch>
      switchkvm();
80104719:	e8 55 32 00 00       	call   80107973 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
8010471e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104725:	00 00 00 00 
80104729:	eb 01                	jmp    8010472c <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
8010472b:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472c:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104730:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104737:	72 98                	jb     801046d1 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104739:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104740:	e8 54 04 00 00       	call   80104b99 <release>

  }
80104745:	e9 6d ff ff ff       	jmp    801046b7 <scheduler+0x6>

8010474a <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
8010474a:	55                   	push   %ebp
8010474b:	89 e5                	mov    %esp,%ebp
8010474d:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104750:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104757:	e8 05 05 00 00       	call   80104c61 <holding>
8010475c:	85 c0                	test   %eax,%eax
8010475e:	75 0c                	jne    8010476c <sched+0x22>
    panic("sched ptable.lock");
80104760:	c7 04 24 1d 84 10 80 	movl   $0x8010841d,(%esp)
80104767:	e8 da bd ff ff       	call   80100546 <panic>
  if(cpu->ncli != 1)
8010476c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104772:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104778:	83 f8 01             	cmp    $0x1,%eax
8010477b:	74 0c                	je     80104789 <sched+0x3f>
    panic("sched locks");
8010477d:	c7 04 24 2f 84 10 80 	movl   $0x8010842f,(%esp)
80104784:	e8 bd bd ff ff       	call   80100546 <panic>
  if(proc->state == RUNNING)
80104789:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478f:	8b 40 0c             	mov    0xc(%eax),%eax
80104792:	83 f8 04             	cmp    $0x4,%eax
80104795:	75 0c                	jne    801047a3 <sched+0x59>
    panic("sched running");
80104797:	c7 04 24 3b 84 10 80 	movl   $0x8010843b,(%esp)
8010479e:	e8 a3 bd ff ff       	call   80100546 <panic>
  if(readeflags()&FL_IF)
801047a3:	e8 84 f8 ff ff       	call   8010402c <readeflags>
801047a8:	25 00 02 00 00       	and    $0x200,%eax
801047ad:	85 c0                	test   %eax,%eax
801047af:	74 0c                	je     801047bd <sched+0x73>
    panic("sched interruptible");
801047b1:	c7 04 24 49 84 10 80 	movl   $0x80108449,(%esp)
801047b8:	e8 89 bd ff ff       	call   80100546 <panic>
  intena = cpu->intena;
801047bd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047c3:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801047c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801047cc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047d2:	8b 40 04             	mov    0x4(%eax),%eax
801047d5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047dc:	83 c2 1c             	add    $0x1c,%edx
801047df:	89 44 24 04          	mov    %eax,0x4(%esp)
801047e3:	89 14 24             	mov    %edx,(%esp)
801047e6:	e8 4d 08 00 00       	call   80105038 <swtch>
  cpu->intena = intena;
801047eb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047f4:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801047fa:	c9                   	leave  
801047fb:	c3                   	ret    

801047fc <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801047fc:	55                   	push   %ebp
801047fd:	89 e5                	mov    %esp,%ebp
801047ff:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104802:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104809:	e8 29 03 00 00       	call   80104b37 <acquire>
  proc->state = RUNNABLE;
8010480e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104814:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010481b:	e8 2a ff ff ff       	call   8010474a <sched>
  release(&ptable.lock);
80104820:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104827:	e8 6d 03 00 00       	call   80104b99 <release>
}
8010482c:	c9                   	leave  
8010482d:	c3                   	ret    

8010482e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010482e:	55                   	push   %ebp
8010482f:	89 e5                	mov    %esp,%ebp
80104831:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104834:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010483b:	e8 59 03 00 00       	call   80104b99 <release>

  if (first) {
80104840:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104845:	85 c0                	test   %eax,%eax
80104847:	74 0f                	je     80104858 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104849:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104850:	00 00 00 
    initlog();
80104853:	e8 f4 e7 ff ff       	call   8010304c <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104858:	c9                   	leave  
80104859:	c3                   	ret    

8010485a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010485a:	55                   	push   %ebp
8010485b:	89 e5                	mov    %esp,%ebp
8010485d:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104860:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104866:	85 c0                	test   %eax,%eax
80104868:	75 0c                	jne    80104876 <sleep+0x1c>
    panic("sleep");
8010486a:	c7 04 24 5d 84 10 80 	movl   $0x8010845d,(%esp)
80104871:	e8 d0 bc ff ff       	call   80100546 <panic>

  if(lk == 0)
80104876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010487a:	75 0c                	jne    80104888 <sleep+0x2e>
    panic("sleep without lk");
8010487c:	c7 04 24 63 84 10 80 	movl   $0x80108463,(%esp)
80104883:	e8 be bc ff ff       	call   80100546 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104888:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
8010488f:	74 17                	je     801048a8 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104891:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104898:	e8 9a 02 00 00       	call   80104b37 <acquire>
    release(lk);
8010489d:	8b 45 0c             	mov    0xc(%ebp),%eax
801048a0:	89 04 24             	mov    %eax,(%esp)
801048a3:	e8 f1 02 00 00       	call   80104b99 <release>
  }

  // Go to sleep.
  proc->chan = chan;
801048a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ae:	8b 55 08             	mov    0x8(%ebp),%edx
801048b1:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801048b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ba:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801048c1:	e8 84 fe ff ff       	call   8010474a <sched>

  // Tidy up.
  proc->chan = 0;
801048c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048cc:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801048d3:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
801048da:	74 17                	je     801048f3 <sleep+0x99>
    release(&ptable.lock);
801048dc:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048e3:	e8 b1 02 00 00       	call   80104b99 <release>
    acquire(lk);
801048e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801048eb:	89 04 24             	mov    %eax,(%esp)
801048ee:	e8 44 02 00 00       	call   80104b37 <acquire>
  }
}
801048f3:	c9                   	leave  
801048f4:	c3                   	ret    

801048f5 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801048f5:	55                   	push   %ebp
801048f6:	89 e5                	mov    %esp,%ebp
801048f8:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048fb:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
80104902:	eb 24                	jmp    80104928 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104904:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104907:	8b 40 0c             	mov    0xc(%eax),%eax
8010490a:	83 f8 02             	cmp    $0x2,%eax
8010490d:	75 15                	jne    80104924 <wakeup1+0x2f>
8010490f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104912:	8b 40 20             	mov    0x20(%eax),%eax
80104915:	3b 45 08             	cmp    0x8(%ebp),%eax
80104918:	75 0a                	jne    80104924 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010491a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010491d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104924:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104928:	81 7d fc 54 1e 11 80 	cmpl   $0x80111e54,-0x4(%ebp)
8010492f:	72 d3                	jb     80104904 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104931:	c9                   	leave  
80104932:	c3                   	ret    

80104933 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104933:	55                   	push   %ebp
80104934:	89 e5                	mov    %esp,%ebp
80104936:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104939:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104940:	e8 f2 01 00 00       	call   80104b37 <acquire>
  wakeup1(chan);
80104945:	8b 45 08             	mov    0x8(%ebp),%eax
80104948:	89 04 24             	mov    %eax,(%esp)
8010494b:	e8 a5 ff ff ff       	call   801048f5 <wakeup1>
  release(&ptable.lock);
80104950:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104957:	e8 3d 02 00 00       	call   80104b99 <release>
}
8010495c:	c9                   	leave  
8010495d:	c3                   	ret    

8010495e <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010495e:	55                   	push   %ebp
8010495f:	89 e5                	mov    %esp,%ebp
80104961:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104964:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010496b:	e8 c7 01 00 00       	call   80104b37 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104970:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104977:	eb 41                	jmp    801049ba <kill+0x5c>
    if(p->pid == pid){
80104979:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497c:	8b 40 10             	mov    0x10(%eax),%eax
8010497f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104982:	75 32                	jne    801049b6 <kill+0x58>
      p->killed = 1;
80104984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104987:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010498e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104991:	8b 40 0c             	mov    0xc(%eax),%eax
80104994:	83 f8 02             	cmp    $0x2,%eax
80104997:	75 0a                	jne    801049a3 <kill+0x45>
        p->state = RUNNABLE;
80104999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010499c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049a3:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801049aa:	e8 ea 01 00 00       	call   80104b99 <release>
      return 0;
801049af:	b8 00 00 00 00       	mov    $0x0,%eax
801049b4:	eb 1e                	jmp    801049d4 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b6:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801049ba:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
801049c1:	72 b6                	jb     80104979 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801049c3:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801049ca:	e8 ca 01 00 00       	call   80104b99 <release>
  return -1;
801049cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049d4:	c9                   	leave  
801049d5:	c3                   	ret    

801049d6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801049d6:	55                   	push   %ebp
801049d7:	89 e5                	mov    %esp,%ebp
801049d9:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049dc:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
801049e3:	e9 d8 00 00 00       	jmp    80104ac0 <procdump+0xea>
    if(p->state == UNUSED)
801049e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049eb:	8b 40 0c             	mov    0xc(%eax),%eax
801049ee:	85 c0                	test   %eax,%eax
801049f0:	0f 84 c5 00 00 00    	je     80104abb <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801049f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049f9:	8b 40 0c             	mov    0xc(%eax),%eax
801049fc:	83 f8 05             	cmp    $0x5,%eax
801049ff:	77 23                	ja     80104a24 <procdump+0x4e>
80104a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a04:	8b 40 0c             	mov    0xc(%eax),%eax
80104a07:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104a0e:	85 c0                	test   %eax,%eax
80104a10:	74 12                	je     80104a24 <procdump+0x4e>
      state = states[p->state];
80104a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a15:	8b 40 0c             	mov    0xc(%eax),%eax
80104a18:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104a1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104a22:	eb 07                	jmp    80104a2b <procdump+0x55>
    else
      state = "???";
80104a24:	c7 45 ec 74 84 10 80 	movl   $0x80108474,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a2e:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a34:	8b 40 10             	mov    0x10(%eax),%eax
80104a37:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104a3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104a3e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104a42:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a46:	c7 04 24 78 84 10 80 	movl   $0x80108478,(%esp)
80104a4d:	e8 58 b9 ff ff       	call   801003aa <cprintf>
    if(p->state == SLEEPING){
80104a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a55:	8b 40 0c             	mov    0xc(%eax),%eax
80104a58:	83 f8 02             	cmp    $0x2,%eax
80104a5b:	75 50                	jne    80104aad <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a60:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a63:	8b 40 0c             	mov    0xc(%eax),%eax
80104a66:	83 c0 08             	add    $0x8,%eax
80104a69:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104a6c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a70:	89 04 24             	mov    %eax,(%esp)
80104a73:	e8 70 01 00 00       	call   80104be8 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104a7f:	eb 1b                	jmp    80104a9c <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a84:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104a88:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a8c:	c7 04 24 81 84 10 80 	movl   $0x80108481,(%esp)
80104a93:	e8 12 b9 ff ff       	call   801003aa <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104a98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104a9c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104aa0:	7f 0b                	jg     80104aad <procdump+0xd7>
80104aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104aa9:	85 c0                	test   %eax,%eax
80104aab:	75 d4                	jne    80104a81 <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104aad:	c7 04 24 85 84 10 80 	movl   $0x80108485,(%esp)
80104ab4:	e8 f1 b8 ff ff       	call   801003aa <cprintf>
80104ab9:	eb 01                	jmp    80104abc <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104abb:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104abc:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104ac0:	81 7d f0 54 1e 11 80 	cmpl   $0x80111e54,-0x10(%ebp)
80104ac7:	0f 82 1b ff ff ff    	jb     801049e8 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104acd:	c9                   	leave  
80104ace:	c3                   	ret    
	...

80104ad0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ad7:	9c                   	pushf  
80104ad8:	5b                   	pop    %ebx
80104ad9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104adc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104adf:	83 c4 10             	add    $0x10,%esp
80104ae2:	5b                   	pop    %ebx
80104ae3:	5d                   	pop    %ebp
80104ae4:	c3                   	ret    

80104ae5 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104ae5:	55                   	push   %ebp
80104ae6:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104ae8:	fa                   	cli    
}
80104ae9:	5d                   	pop    %ebp
80104aea:	c3                   	ret    

80104aeb <sti>:

static inline void
sti(void)
{
80104aeb:	55                   	push   %ebp
80104aec:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104aee:	fb                   	sti    
}
80104aef:	5d                   	pop    %ebp
80104af0:	c3                   	ret    

80104af1 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104af1:	55                   	push   %ebp
80104af2:	89 e5                	mov    %esp,%ebp
80104af4:	53                   	push   %ebx
80104af5:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80104af8:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104afb:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104afe:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104b01:	89 c3                	mov    %eax,%ebx
80104b03:	89 d8                	mov    %ebx,%eax
80104b05:	f0 87 02             	lock xchg %eax,(%edx)
80104b08:	89 c3                	mov    %eax,%ebx
80104b0a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104b0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104b10:	83 c4 10             	add    $0x10,%esp
80104b13:	5b                   	pop    %ebx
80104b14:	5d                   	pop    %ebp
80104b15:	c3                   	ret    

80104b16 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b16:	55                   	push   %ebp
80104b17:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104b19:	8b 45 08             	mov    0x8(%ebp),%eax
80104b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104b22:	8b 45 08             	mov    0x8(%ebp),%eax
80104b25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80104b2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b35:	5d                   	pop    %ebp
80104b36:	c3                   	ret    

80104b37 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104b37:	55                   	push   %ebp
80104b38:	89 e5                	mov    %esp,%ebp
80104b3a:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104b3d:	e8 49 01 00 00       	call   80104c8b <pushcli>
  if(holding(lk))
80104b42:	8b 45 08             	mov    0x8(%ebp),%eax
80104b45:	89 04 24             	mov    %eax,(%esp)
80104b48:	e8 14 01 00 00       	call   80104c61 <holding>
80104b4d:	85 c0                	test   %eax,%eax
80104b4f:	74 0c                	je     80104b5d <acquire+0x26>
    panic("acquire");
80104b51:	c7 04 24 b1 84 10 80 	movl   $0x801084b1,(%esp)
80104b58:	e8 e9 b9 ff ff       	call   80100546 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104b5d:	90                   	nop
80104b5e:	8b 45 08             	mov    0x8(%ebp),%eax
80104b61:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104b68:	00 
80104b69:	89 04 24             	mov    %eax,(%esp)
80104b6c:	e8 80 ff ff ff       	call   80104af1 <xchg>
80104b71:	85 c0                	test   %eax,%eax
80104b73:	75 e9                	jne    80104b5e <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104b75:	8b 45 08             	mov    0x8(%ebp),%eax
80104b78:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b7f:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104b82:	8b 45 08             	mov    0x8(%ebp),%eax
80104b85:	83 c0 0c             	add    $0xc,%eax
80104b88:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b8c:	8d 45 08             	lea    0x8(%ebp),%eax
80104b8f:	89 04 24             	mov    %eax,(%esp)
80104b92:	e8 51 00 00 00       	call   80104be8 <getcallerpcs>
}
80104b97:	c9                   	leave  
80104b98:	c3                   	ret    

80104b99 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104b99:	55                   	push   %ebp
80104b9a:	89 e5                	mov    %esp,%ebp
80104b9c:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80104ba2:	89 04 24             	mov    %eax,(%esp)
80104ba5:	e8 b7 00 00 00       	call   80104c61 <holding>
80104baa:	85 c0                	test   %eax,%eax
80104bac:	75 0c                	jne    80104bba <release+0x21>
    panic("release");
80104bae:	c7 04 24 b9 84 10 80 	movl   $0x801084b9,(%esp)
80104bb5:	e8 8c b9 ff ff       	call   80100546 <panic>

  lk->pcs[0] = 0;
80104bba:	8b 45 08             	mov    0x8(%ebp),%eax
80104bbd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104bce:	8b 45 08             	mov    0x8(%ebp),%eax
80104bd1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104bd8:	00 
80104bd9:	89 04 24             	mov    %eax,(%esp)
80104bdc:	e8 10 ff ff ff       	call   80104af1 <xchg>

  popcli();
80104be1:	e8 ed 00 00 00       	call   80104cd3 <popcli>
}
80104be6:	c9                   	leave  
80104be7:	c3                   	ret    

80104be8 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104be8:	55                   	push   %ebp
80104be9:	89 e5                	mov    %esp,%ebp
80104beb:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104bee:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf1:	83 e8 08             	sub    $0x8,%eax
80104bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104bf7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104bfe:	eb 38                	jmp    80104c38 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c00:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104c04:	74 53                	je     80104c59 <getcallerpcs+0x71>
80104c06:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104c0d:	76 4a                	jbe    80104c59 <getcallerpcs+0x71>
80104c0f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104c13:	74 44                	je     80104c59 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c15:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c22:	01 c2                	add    %eax,%edx
80104c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c27:	8b 40 04             	mov    0x4(%eax),%eax
80104c2a:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104c2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c2f:	8b 00                	mov    (%eax),%eax
80104c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c34:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104c38:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104c3c:	7e c2                	jle    80104c00 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104c3e:	eb 19                	jmp    80104c59 <getcallerpcs+0x71>
    pcs[i] = 0;
80104c40:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4d:	01 d0                	add    %edx,%eax
80104c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104c55:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104c59:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104c5d:	7e e1                	jle    80104c40 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104c5f:	c9                   	leave  
80104c60:	c3                   	ret    

80104c61 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104c61:	55                   	push   %ebp
80104c62:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104c64:	8b 45 08             	mov    0x8(%ebp),%eax
80104c67:	8b 00                	mov    (%eax),%eax
80104c69:	85 c0                	test   %eax,%eax
80104c6b:	74 17                	je     80104c84 <holding+0x23>
80104c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80104c70:	8b 50 08             	mov    0x8(%eax),%edx
80104c73:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c79:	39 c2                	cmp    %eax,%edx
80104c7b:	75 07                	jne    80104c84 <holding+0x23>
80104c7d:	b8 01 00 00 00       	mov    $0x1,%eax
80104c82:	eb 05                	jmp    80104c89 <holding+0x28>
80104c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c89:	5d                   	pop    %ebp
80104c8a:	c3                   	ret    

80104c8b <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c8b:	55                   	push   %ebp
80104c8c:	89 e5                	mov    %esp,%ebp
80104c8e:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104c91:	e8 3a fe ff ff       	call   80104ad0 <readeflags>
80104c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104c99:	e8 47 fe ff ff       	call   80104ae5 <cli>
  if(cpu->ncli++ == 0)
80104c9e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ca4:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104caa:	85 d2                	test   %edx,%edx
80104cac:	0f 94 c1             	sete   %cl
80104caf:	83 c2 01             	add    $0x1,%edx
80104cb2:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104cb8:	84 c9                	test   %cl,%cl
80104cba:	74 15                	je     80104cd1 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80104cbc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104cc5:	81 e2 00 02 00 00    	and    $0x200,%edx
80104ccb:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104cd1:	c9                   	leave  
80104cd2:	c3                   	ret    

80104cd3 <popcli>:

void
popcli(void)
{
80104cd3:	55                   	push   %ebp
80104cd4:	89 e5                	mov    %esp,%ebp
80104cd6:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104cd9:	e8 f2 fd ff ff       	call   80104ad0 <readeflags>
80104cde:	25 00 02 00 00       	and    $0x200,%eax
80104ce3:	85 c0                	test   %eax,%eax
80104ce5:	74 0c                	je     80104cf3 <popcli+0x20>
    panic("popcli - interruptible");
80104ce7:	c7 04 24 c1 84 10 80 	movl   $0x801084c1,(%esp)
80104cee:	e8 53 b8 ff ff       	call   80100546 <panic>
  if(--cpu->ncli < 0)
80104cf3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cf9:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104cff:	83 ea 01             	sub    $0x1,%edx
80104d02:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104d08:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d0e:	85 c0                	test   %eax,%eax
80104d10:	79 0c                	jns    80104d1e <popcli+0x4b>
    panic("popcli");
80104d12:	c7 04 24 d8 84 10 80 	movl   $0x801084d8,(%esp)
80104d19:	e8 28 b8 ff ff       	call   80100546 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104d1e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d24:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d2a:	85 c0                	test   %eax,%eax
80104d2c:	75 15                	jne    80104d43 <popcli+0x70>
80104d2e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d34:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d3a:	85 c0                	test   %eax,%eax
80104d3c:	74 05                	je     80104d43 <popcli+0x70>
    sti();
80104d3e:	e8 a8 fd ff ff       	call   80104aeb <sti>
}
80104d43:	c9                   	leave  
80104d44:	c3                   	ret    
80104d45:	00 00                	add    %al,(%eax)
	...

80104d48 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104d48:	55                   	push   %ebp
80104d49:	89 e5                	mov    %esp,%ebp
80104d4b:	57                   	push   %edi
80104d4c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104d4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d50:	8b 55 10             	mov    0x10(%ebp),%edx
80104d53:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d56:	89 cb                	mov    %ecx,%ebx
80104d58:	89 df                	mov    %ebx,%edi
80104d5a:	89 d1                	mov    %edx,%ecx
80104d5c:	fc                   	cld    
80104d5d:	f3 aa                	rep stos %al,%es:(%edi)
80104d5f:	89 ca                	mov    %ecx,%edx
80104d61:	89 fb                	mov    %edi,%ebx
80104d63:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104d66:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104d69:	5b                   	pop    %ebx
80104d6a:	5f                   	pop    %edi
80104d6b:	5d                   	pop    %ebp
80104d6c:	c3                   	ret    

80104d6d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104d6d:	55                   	push   %ebp
80104d6e:	89 e5                	mov    %esp,%ebp
80104d70:	57                   	push   %edi
80104d71:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104d72:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d75:	8b 55 10             	mov    0x10(%ebp),%edx
80104d78:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d7b:	89 cb                	mov    %ecx,%ebx
80104d7d:	89 df                	mov    %ebx,%edi
80104d7f:	89 d1                	mov    %edx,%ecx
80104d81:	fc                   	cld    
80104d82:	f3 ab                	rep stos %eax,%es:(%edi)
80104d84:	89 ca                	mov    %ecx,%edx
80104d86:	89 fb                	mov    %edi,%ebx
80104d88:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104d8b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104d8e:	5b                   	pop    %ebx
80104d8f:	5f                   	pop    %edi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    

80104d92 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d92:	55                   	push   %ebp
80104d93:	89 e5                	mov    %esp,%ebp
80104d95:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104d98:	8b 45 08             	mov    0x8(%ebp),%eax
80104d9b:	83 e0 03             	and    $0x3,%eax
80104d9e:	85 c0                	test   %eax,%eax
80104da0:	75 49                	jne    80104deb <memset+0x59>
80104da2:	8b 45 10             	mov    0x10(%ebp),%eax
80104da5:	83 e0 03             	and    $0x3,%eax
80104da8:	85 c0                	test   %eax,%eax
80104daa:	75 3f                	jne    80104deb <memset+0x59>
    c &= 0xFF;
80104dac:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104db3:	8b 45 10             	mov    0x10(%ebp),%eax
80104db6:	c1 e8 02             	shr    $0x2,%eax
80104db9:	89 c2                	mov    %eax,%edx
80104dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dbe:	89 c1                	mov    %eax,%ecx
80104dc0:	c1 e1 18             	shl    $0x18,%ecx
80104dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dc6:	c1 e0 10             	shl    $0x10,%eax
80104dc9:	09 c1                	or     %eax,%ecx
80104dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dce:	c1 e0 08             	shl    $0x8,%eax
80104dd1:	09 c8                	or     %ecx,%eax
80104dd3:	0b 45 0c             	or     0xc(%ebp),%eax
80104dd6:	89 54 24 08          	mov    %edx,0x8(%esp)
80104dda:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dde:	8b 45 08             	mov    0x8(%ebp),%eax
80104de1:	89 04 24             	mov    %eax,(%esp)
80104de4:	e8 84 ff ff ff       	call   80104d6d <stosl>
80104de9:	eb 19                	jmp    80104e04 <memset+0x72>
  } else
    stosb(dst, c, n);
80104deb:	8b 45 10             	mov    0x10(%ebp),%eax
80104dee:	89 44 24 08          	mov    %eax,0x8(%esp)
80104df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104df5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104df9:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfc:	89 04 24             	mov    %eax,(%esp)
80104dff:	e8 44 ff ff ff       	call   80104d48 <stosb>
  return dst;
80104e04:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104e07:	c9                   	leave  
80104e08:	c3                   	ret    

80104e09 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e09:	55                   	push   %ebp
80104e0a:	89 e5                	mov    %esp,%ebp
80104e0c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104e15:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e18:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104e1b:	eb 32                	jmp    80104e4f <memcmp+0x46>
    if(*s1 != *s2)
80104e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e20:	0f b6 10             	movzbl (%eax),%edx
80104e23:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e26:	0f b6 00             	movzbl (%eax),%eax
80104e29:	38 c2                	cmp    %al,%dl
80104e2b:	74 1a                	je     80104e47 <memcmp+0x3e>
      return *s1 - *s2;
80104e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e30:	0f b6 00             	movzbl (%eax),%eax
80104e33:	0f b6 d0             	movzbl %al,%edx
80104e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e39:	0f b6 00             	movzbl (%eax),%eax
80104e3c:	0f b6 c0             	movzbl %al,%eax
80104e3f:	89 d1                	mov    %edx,%ecx
80104e41:	29 c1                	sub    %eax,%ecx
80104e43:	89 c8                	mov    %ecx,%eax
80104e45:	eb 1c                	jmp    80104e63 <memcmp+0x5a>
    s1++, s2++;
80104e47:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e4b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e53:	0f 95 c0             	setne  %al
80104e56:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e5a:	84 c0                	test   %al,%al
80104e5c:	75 bf                	jne    80104e1d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104e5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e63:	c9                   	leave  
80104e64:	c3                   	ret    

80104e65 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e65:	55                   	push   %ebp
80104e66:	89 e5                	mov    %esp,%ebp
80104e68:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104e71:	8b 45 08             	mov    0x8(%ebp),%eax
80104e74:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e7d:	73 54                	jae    80104ed3 <memmove+0x6e>
80104e7f:	8b 45 10             	mov    0x10(%ebp),%eax
80104e82:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e85:	01 d0                	add    %edx,%eax
80104e87:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e8a:	76 47                	jbe    80104ed3 <memmove+0x6e>
    s += n;
80104e8c:	8b 45 10             	mov    0x10(%ebp),%eax
80104e8f:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104e92:	8b 45 10             	mov    0x10(%ebp),%eax
80104e95:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104e98:	eb 13                	jmp    80104ead <memmove+0x48>
      *--d = *--s;
80104e9a:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104e9e:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ea5:	0f b6 10             	movzbl (%eax),%edx
80104ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104eab:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104ead:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104eb1:	0f 95 c0             	setne  %al
80104eb4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104eb8:	84 c0                	test   %al,%al
80104eba:	75 de                	jne    80104e9a <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ebc:	eb 25                	jmp    80104ee3 <memmove+0x7e>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80104ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec1:	0f b6 10             	movzbl (%eax),%edx
80104ec4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ec7:	88 10                	mov    %dl,(%eax)
80104ec9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104ecd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104ed1:	eb 01                	jmp    80104ed4 <memmove+0x6f>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104ed3:	90                   	nop
80104ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ed8:	0f 95 c0             	setne  %al
80104edb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104edf:	84 c0                	test   %al,%al
80104ee1:	75 db                	jne    80104ebe <memmove+0x59>
      *d++ = *s++;

  return dst;
80104ee3:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104ee6:	c9                   	leave  
80104ee7:	c3                   	ret    

80104ee8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ee8:	55                   	push   %ebp
80104ee9:	89 e5                	mov    %esp,%ebp
80104eeb:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80104eee:	8b 45 10             	mov    0x10(%ebp),%eax
80104ef1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104efc:	8b 45 08             	mov    0x8(%ebp),%eax
80104eff:	89 04 24             	mov    %eax,(%esp)
80104f02:	e8 5e ff ff ff       	call   80104e65 <memmove>
}
80104f07:	c9                   	leave  
80104f08:	c3                   	ret    

80104f09 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104f09:	55                   	push   %ebp
80104f0a:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104f0c:	eb 0c                	jmp    80104f1a <strncmp+0x11>
    n--, p++, q++;
80104f0e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104f12:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104f16:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f1e:	74 1a                	je     80104f3a <strncmp+0x31>
80104f20:	8b 45 08             	mov    0x8(%ebp),%eax
80104f23:	0f b6 00             	movzbl (%eax),%eax
80104f26:	84 c0                	test   %al,%al
80104f28:	74 10                	je     80104f3a <strncmp+0x31>
80104f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f2d:	0f b6 10             	movzbl (%eax),%edx
80104f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f33:	0f b6 00             	movzbl (%eax),%eax
80104f36:	38 c2                	cmp    %al,%dl
80104f38:	74 d4                	je     80104f0e <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80104f3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f3e:	75 07                	jne    80104f47 <strncmp+0x3e>
    return 0;
80104f40:	b8 00 00 00 00       	mov    $0x0,%eax
80104f45:	eb 18                	jmp    80104f5f <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
80104f47:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4a:	0f b6 00             	movzbl (%eax),%eax
80104f4d:	0f b6 d0             	movzbl %al,%edx
80104f50:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f53:	0f b6 00             	movzbl (%eax),%eax
80104f56:	0f b6 c0             	movzbl %al,%eax
80104f59:	89 d1                	mov    %edx,%ecx
80104f5b:	29 c1                	sub    %eax,%ecx
80104f5d:	89 c8                	mov    %ecx,%eax
}
80104f5f:	5d                   	pop    %ebp
80104f60:	c3                   	ret    

80104f61 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f61:	55                   	push   %ebp
80104f62:	89 e5                	mov    %esp,%ebp
80104f64:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104f67:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f6d:	90                   	nop
80104f6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f72:	0f 9f c0             	setg   %al
80104f75:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104f79:	84 c0                	test   %al,%al
80104f7b:	74 30                	je     80104fad <strncpy+0x4c>
80104f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f80:	0f b6 10             	movzbl (%eax),%edx
80104f83:	8b 45 08             	mov    0x8(%ebp),%eax
80104f86:	88 10                	mov    %dl,(%eax)
80104f88:	8b 45 08             	mov    0x8(%ebp),%eax
80104f8b:	0f b6 00             	movzbl (%eax),%eax
80104f8e:	84 c0                	test   %al,%al
80104f90:	0f 95 c0             	setne  %al
80104f93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104f97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f9b:	84 c0                	test   %al,%al
80104f9d:	75 cf                	jne    80104f6e <strncpy+0xd>
    ;
  while(n-- > 0)
80104f9f:	eb 0c                	jmp    80104fad <strncpy+0x4c>
    *s++ = 0;
80104fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa4:	c6 00 00             	movb   $0x0,(%eax)
80104fa7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104fab:	eb 01                	jmp    80104fae <strncpy+0x4d>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104fad:	90                   	nop
80104fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fb2:	0f 9f c0             	setg   %al
80104fb5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104fb9:	84 c0                	test   %al,%al
80104fbb:	75 e4                	jne    80104fa1 <strncpy+0x40>
    *s++ = 0;
  return os;
80104fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104fc0:	c9                   	leave  
80104fc1:	c3                   	ret    

80104fc2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fc2:	55                   	push   %ebp
80104fc3:	89 e5                	mov    %esp,%ebp
80104fc5:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80104fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104fce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fd2:	7f 05                	jg     80104fd9 <safestrcpy+0x17>
    return os;
80104fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fd7:	eb 35                	jmp    8010500e <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80104fd9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104fdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fe1:	7e 22                	jle    80105005 <safestrcpy+0x43>
80104fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fe6:	0f b6 10             	movzbl (%eax),%edx
80104fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fec:	88 10                	mov    %dl,(%eax)
80104fee:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff1:	0f b6 00             	movzbl (%eax),%eax
80104ff4:	84 c0                	test   %al,%al
80104ff6:	0f 95 c0             	setne  %al
80104ff9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104ffd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105001:	84 c0                	test   %al,%al
80105003:	75 d4                	jne    80104fd9 <safestrcpy+0x17>
    ;
  *s = 0;
80105005:	8b 45 08             	mov    0x8(%ebp),%eax
80105008:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010500b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010500e:	c9                   	leave  
8010500f:	c3                   	ret    

80105010 <strlen>:

int
strlen(const char *s)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105016:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010501d:	eb 04                	jmp    80105023 <strlen+0x13>
8010501f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105023:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105026:	8b 45 08             	mov    0x8(%ebp),%eax
80105029:	01 d0                	add    %edx,%eax
8010502b:	0f b6 00             	movzbl (%eax),%eax
8010502e:	84 c0                	test   %al,%al
80105030:	75 ed                	jne    8010501f <strlen+0xf>
    ;
  return n;
80105032:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105035:	c9                   	leave  
80105036:	c3                   	ret    
	...

80105038 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105038:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010503c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105040:	55                   	push   %ebp
  pushl %ebx
80105041:	53                   	push   %ebx
  pushl %esi
80105042:	56                   	push   %esi
  pushl %edi
80105043:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105044:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105046:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105048:	5f                   	pop    %edi
  popl %esi
80105049:	5e                   	pop    %esi
  popl %ebx
8010504a:	5b                   	pop    %ebx
  popl %ebp
8010504b:	5d                   	pop    %ebp
  ret
8010504c:	c3                   	ret    
8010504d:	00 00                	add    %al,(%eax)
	...

80105050 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105053:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105059:	8b 00                	mov    (%eax),%eax
8010505b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010505e:	76 12                	jbe    80105072 <fetchint+0x22>
80105060:	8b 45 08             	mov    0x8(%ebp),%eax
80105063:	8d 50 04             	lea    0x4(%eax),%edx
80105066:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010506c:	8b 00                	mov    (%eax),%eax
8010506e:	39 c2                	cmp    %eax,%edx
80105070:	76 07                	jbe    80105079 <fetchint+0x29>
    return -1;
80105072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105077:	eb 0f                	jmp    80105088 <fetchint+0x38>
  *ip = *(int*)(addr);
80105079:	8b 45 08             	mov    0x8(%ebp),%eax
8010507c:	8b 10                	mov    (%eax),%edx
8010507e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105081:	89 10                	mov    %edx,(%eax)
  return 0;
80105083:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105088:	5d                   	pop    %ebp
80105089:	c3                   	ret    

8010508a <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010508a:	55                   	push   %ebp
8010508b:	89 e5                	mov    %esp,%ebp
8010508d:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105090:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105096:	8b 00                	mov    (%eax),%eax
80105098:	3b 45 08             	cmp    0x8(%ebp),%eax
8010509b:	77 07                	ja     801050a4 <fetchstr+0x1a>
    return -1;
8010509d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a2:	eb 48                	jmp    801050ec <fetchstr+0x62>
  *pp = (char*)addr;
801050a4:	8b 55 08             	mov    0x8(%ebp),%edx
801050a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801050aa:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801050ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050b2:	8b 00                	mov    (%eax),%eax
801050b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801050b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ba:	8b 00                	mov    (%eax),%eax
801050bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
801050bf:	eb 1e                	jmp    801050df <fetchstr+0x55>
    if(*s == 0)
801050c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050c4:	0f b6 00             	movzbl (%eax),%eax
801050c7:	84 c0                	test   %al,%al
801050c9:	75 10                	jne    801050db <fetchstr+0x51>
      return s - *pp;
801050cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d1:	8b 00                	mov    (%eax),%eax
801050d3:	89 d1                	mov    %edx,%ecx
801050d5:	29 c1                	sub    %eax,%ecx
801050d7:	89 c8                	mov    %ecx,%eax
801050d9:	eb 11                	jmp    801050ec <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801050db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801050df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801050e5:	72 da                	jb     801050c1 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801050e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050ec:	c9                   	leave  
801050ed:	c3                   	ret    

801050ee <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801050ee:	55                   	push   %ebp
801050ef:	89 e5                	mov    %esp,%ebp
801050f1:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801050f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050fa:	8b 40 18             	mov    0x18(%eax),%eax
801050fd:	8b 50 44             	mov    0x44(%eax),%edx
80105100:	8b 45 08             	mov    0x8(%ebp),%eax
80105103:	c1 e0 02             	shl    $0x2,%eax
80105106:	01 d0                	add    %edx,%eax
80105108:	8d 50 04             	lea    0x4(%eax),%edx
8010510b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010510e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105112:	89 14 24             	mov    %edx,(%esp)
80105115:	e8 36 ff ff ff       	call   80105050 <fetchint>
}
8010511a:	c9                   	leave  
8010511b:	c3                   	ret    

8010511c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010511c:	55                   	push   %ebp
8010511d:	89 e5                	mov    %esp,%ebp
8010511f:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105122:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105125:	89 44 24 04          	mov    %eax,0x4(%esp)
80105129:	8b 45 08             	mov    0x8(%ebp),%eax
8010512c:	89 04 24             	mov    %eax,(%esp)
8010512f:	e8 ba ff ff ff       	call   801050ee <argint>
80105134:	85 c0                	test   %eax,%eax
80105136:	79 07                	jns    8010513f <argptr+0x23>
    return -1;
80105138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513d:	eb 3d                	jmp    8010517c <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010513f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105142:	89 c2                	mov    %eax,%edx
80105144:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514a:	8b 00                	mov    (%eax),%eax
8010514c:	39 c2                	cmp    %eax,%edx
8010514e:	73 16                	jae    80105166 <argptr+0x4a>
80105150:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105153:	89 c2                	mov    %eax,%edx
80105155:	8b 45 10             	mov    0x10(%ebp),%eax
80105158:	01 c2                	add    %eax,%edx
8010515a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105160:	8b 00                	mov    (%eax),%eax
80105162:	39 c2                	cmp    %eax,%edx
80105164:	76 07                	jbe    8010516d <argptr+0x51>
    return -1;
80105166:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516b:	eb 0f                	jmp    8010517c <argptr+0x60>
  *pp = (char*)i;
8010516d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105170:	89 c2                	mov    %eax,%edx
80105172:	8b 45 0c             	mov    0xc(%ebp),%eax
80105175:	89 10                	mov    %edx,(%eax)
  return 0;
80105177:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010517c:	c9                   	leave  
8010517d:	c3                   	ret    

8010517e <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010517e:	55                   	push   %ebp
8010517f:	89 e5                	mov    %esp,%ebp
80105181:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105184:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105187:	89 44 24 04          	mov    %eax,0x4(%esp)
8010518b:	8b 45 08             	mov    0x8(%ebp),%eax
8010518e:	89 04 24             	mov    %eax,(%esp)
80105191:	e8 58 ff ff ff       	call   801050ee <argint>
80105196:	85 c0                	test   %eax,%eax
80105198:	79 07                	jns    801051a1 <argstr+0x23>
    return -1;
8010519a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519f:	eb 12                	jmp    801051b3 <argstr+0x35>
  return fetchstr(addr, pp);
801051a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051a4:	8b 55 0c             	mov    0xc(%ebp),%edx
801051a7:	89 54 24 04          	mov    %edx,0x4(%esp)
801051ab:	89 04 24             	mov    %eax,(%esp)
801051ae:	e8 d7 fe ff ff       	call   8010508a <fetchstr>
}
801051b3:	c9                   	leave  
801051b4:	c3                   	ret    

801051b5 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801051b5:	55                   	push   %ebp
801051b6:	89 e5                	mov    %esp,%ebp
801051b8:	53                   	push   %ebx
801051b9:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801051bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c2:	8b 40 18             	mov    0x18(%eax),%eax
801051c5:	8b 40 1c             	mov    0x1c(%eax),%eax
801051c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801051cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051cf:	7e 30                	jle    80105201 <syscall+0x4c>
801051d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d4:	83 f8 15             	cmp    $0x15,%eax
801051d7:	77 28                	ja     80105201 <syscall+0x4c>
801051d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051dc:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801051e3:	85 c0                	test   %eax,%eax
801051e5:	74 1a                	je     80105201 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801051e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ed:	8b 58 18             	mov    0x18(%eax),%ebx
801051f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f3:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801051fa:	ff d0                	call   *%eax
801051fc:	89 43 1c             	mov    %eax,0x1c(%ebx)
801051ff:	eb 3d                	jmp    8010523e <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105201:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105207:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010520a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105210:	8b 40 10             	mov    0x10(%eax),%eax
80105213:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105216:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010521a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010521e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105222:	c7 04 24 df 84 10 80 	movl   $0x801084df,(%esp)
80105229:	e8 7c b1 ff ff       	call   801003aa <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010522e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105234:	8b 40 18             	mov    0x18(%eax),%eax
80105237:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010523e:	83 c4 24             	add    $0x24,%esp
80105241:	5b                   	pop    %ebx
80105242:	5d                   	pop    %ebp
80105243:	c3                   	ret    

80105244 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010524a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010524d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105251:	8b 45 08             	mov    0x8(%ebp),%eax
80105254:	89 04 24             	mov    %eax,(%esp)
80105257:	e8 92 fe ff ff       	call   801050ee <argint>
8010525c:	85 c0                	test   %eax,%eax
8010525e:	79 07                	jns    80105267 <argfd+0x23>
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105265:	eb 50                	jmp    801052b7 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105267:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010526a:	85 c0                	test   %eax,%eax
8010526c:	78 21                	js     8010528f <argfd+0x4b>
8010526e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105271:	83 f8 0f             	cmp    $0xf,%eax
80105274:	7f 19                	jg     8010528f <argfd+0x4b>
80105276:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010527c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010527f:	83 c2 08             	add    $0x8,%edx
80105282:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105286:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010528d:	75 07                	jne    80105296 <argfd+0x52>
    return -1;
8010528f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105294:	eb 21                	jmp    801052b7 <argfd+0x73>
  if(pfd)
80105296:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010529a:	74 08                	je     801052a4 <argfd+0x60>
    *pfd = fd;
8010529c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010529f:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a2:	89 10                	mov    %edx,(%eax)
  if(pf)
801052a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052a8:	74 08                	je     801052b2 <argfd+0x6e>
    *pf = f;
801052aa:	8b 45 10             	mov    0x10(%ebp),%eax
801052ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052b0:	89 10                	mov    %edx,(%eax)
  return 0;
801052b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052b7:	c9                   	leave  
801052b8:	c3                   	ret    

801052b9 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801052b9:	55                   	push   %ebp
801052ba:	89 e5                	mov    %esp,%ebp
801052bc:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801052c6:	eb 30                	jmp    801052f8 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801052c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052d1:	83 c2 08             	add    $0x8,%edx
801052d4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801052d8:	85 c0                	test   %eax,%eax
801052da:	75 18                	jne    801052f4 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801052dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052e5:	8d 4a 08             	lea    0x8(%edx),%ecx
801052e8:	8b 55 08             	mov    0x8(%ebp),%edx
801052eb:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801052ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052f2:	eb 0f                	jmp    80105303 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801052f8:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801052fc:	7e ca                	jle    801052c8 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801052fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105303:	c9                   	leave  
80105304:	c3                   	ret    

80105305 <sys_dup>:

int
sys_dup(void)
{
80105305:	55                   	push   %ebp
80105306:	89 e5                	mov    %esp,%ebp
80105308:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010530b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010530e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105312:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105319:	00 
8010531a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105321:	e8 1e ff ff ff       	call   80105244 <argfd>
80105326:	85 c0                	test   %eax,%eax
80105328:	79 07                	jns    80105331 <sys_dup+0x2c>
    return -1;
8010532a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532f:	eb 29                	jmp    8010535a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105334:	89 04 24             	mov    %eax,(%esp)
80105337:	e8 7d ff ff ff       	call   801052b9 <fdalloc>
8010533c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010533f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105343:	79 07                	jns    8010534c <sys_dup+0x47>
    return -1;
80105345:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010534a:	eb 0e                	jmp    8010535a <sys_dup+0x55>
  filedup(f);
8010534c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010534f:	89 04 24             	mov    %eax,(%esp)
80105352:	e8 45 bc ff ff       	call   80100f9c <filedup>
  return fd;
80105357:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010535a:	c9                   	leave  
8010535b:	c3                   	ret    

8010535c <sys_read>:

int
sys_read(void)
{
8010535c:	55                   	push   %ebp
8010535d:	89 e5                	mov    %esp,%ebp
8010535f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105362:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105365:	89 44 24 08          	mov    %eax,0x8(%esp)
80105369:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105370:	00 
80105371:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105378:	e8 c7 fe ff ff       	call   80105244 <argfd>
8010537d:	85 c0                	test   %eax,%eax
8010537f:	78 35                	js     801053b6 <sys_read+0x5a>
80105381:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105384:	89 44 24 04          	mov    %eax,0x4(%esp)
80105388:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010538f:	e8 5a fd ff ff       	call   801050ee <argint>
80105394:	85 c0                	test   %eax,%eax
80105396:	78 1e                	js     801053b6 <sys_read+0x5a>
80105398:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010539b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010539f:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801053a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801053ad:	e8 6a fd ff ff       	call   8010511c <argptr>
801053b2:	85 c0                	test   %eax,%eax
801053b4:	79 07                	jns    801053bd <sys_read+0x61>
    return -1;
801053b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bb:	eb 19                	jmp    801053d6 <sys_read+0x7a>
  return fileread(f, p, n);
801053bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801053c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801053ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801053ce:	89 04 24             	mov    %eax,(%esp)
801053d1:	e8 33 bd ff ff       	call   80101109 <fileread>
}
801053d6:	c9                   	leave  
801053d7:	c3                   	ret    

801053d8 <sys_write>:

int
sys_write(void)
{
801053d8:	55                   	push   %ebp
801053d9:	89 e5                	mov    %esp,%ebp
801053db:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053e1:	89 44 24 08          	mov    %eax,0x8(%esp)
801053e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801053ec:	00 
801053ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053f4:	e8 4b fe ff ff       	call   80105244 <argfd>
801053f9:	85 c0                	test   %eax,%eax
801053fb:	78 35                	js     80105432 <sys_write+0x5a>
801053fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105400:	89 44 24 04          	mov    %eax,0x4(%esp)
80105404:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010540b:	e8 de fc ff ff       	call   801050ee <argint>
80105410:	85 c0                	test   %eax,%eax
80105412:	78 1e                	js     80105432 <sys_write+0x5a>
80105414:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105417:	89 44 24 08          	mov    %eax,0x8(%esp)
8010541b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010541e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105422:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105429:	e8 ee fc ff ff       	call   8010511c <argptr>
8010542e:	85 c0                	test   %eax,%eax
80105430:	79 07                	jns    80105439 <sys_write+0x61>
    return -1;
80105432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105437:	eb 19                	jmp    80105452 <sys_write+0x7a>
  return filewrite(f, p, n);
80105439:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010543c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010543f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105442:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105446:	89 54 24 04          	mov    %edx,0x4(%esp)
8010544a:	89 04 24             	mov    %eax,(%esp)
8010544d:	e8 73 bd ff ff       	call   801011c5 <filewrite>
}
80105452:	c9                   	leave  
80105453:	c3                   	ret    

80105454 <sys_close>:

int
sys_close(void)
{
80105454:	55                   	push   %ebp
80105455:	89 e5                	mov    %esp,%ebp
80105457:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010545a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010545d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105461:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105464:	89 44 24 04          	mov    %eax,0x4(%esp)
80105468:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010546f:	e8 d0 fd ff ff       	call   80105244 <argfd>
80105474:	85 c0                	test   %eax,%eax
80105476:	79 07                	jns    8010547f <sys_close+0x2b>
    return -1;
80105478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010547d:	eb 24                	jmp    801054a3 <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010547f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105485:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105488:	83 c2 08             	add    $0x8,%edx
8010548b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105492:	00 
  fileclose(f);
80105493:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105496:	89 04 24             	mov    %eax,(%esp)
80105499:	e8 46 bb ff ff       	call   80100fe4 <fileclose>
  return 0;
8010549e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054a3:	c9                   	leave  
801054a4:	c3                   	ret    

801054a5 <sys_fstat>:

int
sys_fstat(void)
{
801054a5:	55                   	push   %ebp
801054a6:	89 e5                	mov    %esp,%ebp
801054a8:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ae:	89 44 24 08          	mov    %eax,0x8(%esp)
801054b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054b9:	00 
801054ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054c1:	e8 7e fd ff ff       	call   80105244 <argfd>
801054c6:	85 c0                	test   %eax,%eax
801054c8:	78 1f                	js     801054e9 <sys_fstat+0x44>
801054ca:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801054d1:	00 
801054d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801054d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054e0:	e8 37 fc ff ff       	call   8010511c <argptr>
801054e5:	85 c0                	test   %eax,%eax
801054e7:	79 07                	jns    801054f0 <sys_fstat+0x4b>
    return -1;
801054e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ee:	eb 12                	jmp    80105502 <sys_fstat+0x5d>
  return filestat(f, st);
801054f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801054fa:	89 04 24             	mov    %eax,(%esp)
801054fd:	e8 b8 bb ff ff       	call   801010ba <filestat>
}
80105502:	c9                   	leave  
80105503:	c3                   	ret    

80105504 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105504:	55                   	push   %ebp
80105505:	89 e5                	mov    %esp,%ebp
80105507:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010550a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010550d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105518:	e8 61 fc ff ff       	call   8010517e <argstr>
8010551d:	85 c0                	test   %eax,%eax
8010551f:	78 17                	js     80105538 <sys_link+0x34>
80105521:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105524:	89 44 24 04          	mov    %eax,0x4(%esp)
80105528:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010552f:	e8 4a fc ff ff       	call   8010517e <argstr>
80105534:	85 c0                	test   %eax,%eax
80105536:	79 0a                	jns    80105542 <sys_link+0x3e>
    return -1;
80105538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553d:	e9 3c 01 00 00       	jmp    8010567e <sys_link+0x17a>
  if((ip = namei(old)) == 0)
80105542:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105545:	89 04 24             	mov    %eax,(%esp)
80105548:	e8 f7 ce ff ff       	call   80102444 <namei>
8010554d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105554:	75 0a                	jne    80105560 <sys_link+0x5c>
    return -1;
80105556:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555b:	e9 1e 01 00 00       	jmp    8010567e <sys_link+0x17a>

  begin_trans();
80105560:	e8 f7 dc ff ff       	call   8010325c <begin_trans>

  ilock(ip);
80105565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105568:	89 04 24             	mov    %eax,(%esp)
8010556b:	e8 23 c3 ff ff       	call   80101893 <ilock>
  if(ip->type == T_DIR){
80105570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105573:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105577:	66 83 f8 01          	cmp    $0x1,%ax
8010557b:	75 1a                	jne    80105597 <sys_link+0x93>
    iunlockput(ip);
8010557d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105580:	89 04 24             	mov    %eax,(%esp)
80105583:	e8 8f c5 ff ff       	call   80101b17 <iunlockput>
    commit_trans();
80105588:	e8 18 dd ff ff       	call   801032a5 <commit_trans>
    return -1;
8010558d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105592:	e9 e7 00 00 00       	jmp    8010567e <sys_link+0x17a>
  }

  ip->nlink++;
80105597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010559a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010559e:	8d 50 01             	lea    0x1(%eax),%edx
801055a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a4:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801055a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ab:	89 04 24             	mov    %eax,(%esp)
801055ae:	e8 24 c1 ff ff       	call   801016d7 <iupdate>
  iunlock(ip);
801055b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b6:	89 04 24             	mov    %eax,(%esp)
801055b9:	e8 23 c4 ff ff       	call   801019e1 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801055be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055c1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801055c4:	89 54 24 04          	mov    %edx,0x4(%esp)
801055c8:	89 04 24             	mov    %eax,(%esp)
801055cb:	e8 96 ce ff ff       	call   80102466 <nameiparent>
801055d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801055d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055d7:	74 68                	je     80105641 <sys_link+0x13d>
    goto bad;
  ilock(dp);
801055d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055dc:	89 04 24             	mov    %eax,(%esp)
801055df:	e8 af c2 ff ff       	call   80101893 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055e7:	8b 10                	mov    (%eax),%edx
801055e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ec:	8b 00                	mov    (%eax),%eax
801055ee:	39 c2                	cmp    %eax,%edx
801055f0:	75 20                	jne    80105612 <sys_link+0x10e>
801055f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f5:	8b 40 04             	mov    0x4(%eax),%eax
801055f8:	89 44 24 08          	mov    %eax,0x8(%esp)
801055fc:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801055ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105603:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105606:	89 04 24             	mov    %eax,(%esp)
80105609:	e8 73 cb ff ff       	call   80102181 <dirlink>
8010560e:	85 c0                	test   %eax,%eax
80105610:	79 0d                	jns    8010561f <sys_link+0x11b>
    iunlockput(dp);
80105612:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105615:	89 04 24             	mov    %eax,(%esp)
80105618:	e8 fa c4 ff ff       	call   80101b17 <iunlockput>
    goto bad;
8010561d:	eb 23                	jmp    80105642 <sys_link+0x13e>
  }
  iunlockput(dp);
8010561f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105622:	89 04 24             	mov    %eax,(%esp)
80105625:	e8 ed c4 ff ff       	call   80101b17 <iunlockput>
  iput(ip);
8010562a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010562d:	89 04 24             	mov    %eax,(%esp)
80105630:	e8 11 c4 ff ff       	call   80101a46 <iput>

  commit_trans();
80105635:	e8 6b dc ff ff       	call   801032a5 <commit_trans>

  return 0;
8010563a:	b8 00 00 00 00       	mov    $0x0,%eax
8010563f:	eb 3d                	jmp    8010567e <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105641:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
80105642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105645:	89 04 24             	mov    %eax,(%esp)
80105648:	e8 46 c2 ff ff       	call   80101893 <ilock>
  ip->nlink--;
8010564d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105650:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105654:	8d 50 ff             	lea    -0x1(%eax),%edx
80105657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010565a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010565e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105661:	89 04 24             	mov    %eax,(%esp)
80105664:	e8 6e c0 ff ff       	call   801016d7 <iupdate>
  iunlockput(ip);
80105669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566c:	89 04 24             	mov    %eax,(%esp)
8010566f:	e8 a3 c4 ff ff       	call   80101b17 <iunlockput>
  commit_trans();
80105674:	e8 2c dc ff ff       	call   801032a5 <commit_trans>
  return -1;
80105679:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    

80105680 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105686:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010568d:	eb 4b                	jmp    801056da <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010568f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105692:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105699:	00 
8010569a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010569e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801056a5:	8b 45 08             	mov    0x8(%ebp),%eax
801056a8:	89 04 24             	mov    %eax,(%esp)
801056ab:	e8 f0 c6 ff ff       	call   80101da0 <readi>
801056b0:	83 f8 10             	cmp    $0x10,%eax
801056b3:	74 0c                	je     801056c1 <isdirempty+0x41>
      panic("isdirempty: readi");
801056b5:	c7 04 24 fb 84 10 80 	movl   $0x801084fb,(%esp)
801056bc:	e8 85 ae ff ff       	call   80100546 <panic>
    if(de.inum != 0)
801056c1:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801056c5:	66 85 c0             	test   %ax,%ax
801056c8:	74 07                	je     801056d1 <isdirempty+0x51>
      return 0;
801056ca:	b8 00 00 00 00       	mov    $0x0,%eax
801056cf:	eb 1b                	jmp    801056ec <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d4:	83 c0 10             	add    $0x10,%eax
801056d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056dd:	8b 45 08             	mov    0x8(%ebp),%eax
801056e0:	8b 40 18             	mov    0x18(%eax),%eax
801056e3:	39 c2                	cmp    %eax,%edx
801056e5:	72 a8                	jb     8010568f <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801056e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
801056ec:	c9                   	leave  
801056ed:	c3                   	ret    

801056ee <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801056ee:	55                   	push   %ebp
801056ef:	89 e5                	mov    %esp,%ebp
801056f1:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801056f4:	8d 45 cc             	lea    -0x34(%ebp),%eax
801056f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801056fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105702:	e8 77 fa ff ff       	call   8010517e <argstr>
80105707:	85 c0                	test   %eax,%eax
80105709:	79 0a                	jns    80105715 <sys_unlink+0x27>
    return -1;
8010570b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105710:	e9 aa 01 00 00       	jmp    801058bf <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105715:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105718:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010571b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010571f:	89 04 24             	mov    %eax,(%esp)
80105722:	e8 3f cd ff ff       	call   80102466 <nameiparent>
80105727:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010572a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010572e:	75 0a                	jne    8010573a <sys_unlink+0x4c>
    return -1;
80105730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105735:	e9 85 01 00 00       	jmp    801058bf <sys_unlink+0x1d1>

  begin_trans();
8010573a:	e8 1d db ff ff       	call   8010325c <begin_trans>

  ilock(dp);
8010573f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105742:	89 04 24             	mov    %eax,(%esp)
80105745:	e8 49 c1 ff ff       	call   80101893 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010574a:	c7 44 24 04 0d 85 10 	movl   $0x8010850d,0x4(%esp)
80105751:	80 
80105752:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105755:	89 04 24             	mov    %eax,(%esp)
80105758:	e8 3a c9 ff ff       	call   80102097 <namecmp>
8010575d:	85 c0                	test   %eax,%eax
8010575f:	0f 84 45 01 00 00    	je     801058aa <sys_unlink+0x1bc>
80105765:	c7 44 24 04 0f 85 10 	movl   $0x8010850f,0x4(%esp)
8010576c:	80 
8010576d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105770:	89 04 24             	mov    %eax,(%esp)
80105773:	e8 1f c9 ff ff       	call   80102097 <namecmp>
80105778:	85 c0                	test   %eax,%eax
8010577a:	0f 84 2a 01 00 00    	je     801058aa <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105780:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105783:	89 44 24 08          	mov    %eax,0x8(%esp)
80105787:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010578a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010578e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105791:	89 04 24             	mov    %eax,(%esp)
80105794:	e8 20 c9 ff ff       	call   801020b9 <dirlookup>
80105799:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010579c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057a0:	0f 84 03 01 00 00    	je     801058a9 <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
801057a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a9:	89 04 24             	mov    %eax,(%esp)
801057ac:	e8 e2 c0 ff ff       	call   80101893 <ilock>

  if(ip->nlink < 1)
801057b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801057b8:	66 85 c0             	test   %ax,%ax
801057bb:	7f 0c                	jg     801057c9 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
801057bd:	c7 04 24 12 85 10 80 	movl   $0x80108512,(%esp)
801057c4:	e8 7d ad ff ff       	call   80100546 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801057c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057cc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801057d0:	66 83 f8 01          	cmp    $0x1,%ax
801057d4:	75 1f                	jne    801057f5 <sys_unlink+0x107>
801057d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d9:	89 04 24             	mov    %eax,(%esp)
801057dc:	e8 9f fe ff ff       	call   80105680 <isdirempty>
801057e1:	85 c0                	test   %eax,%eax
801057e3:	75 10                	jne    801057f5 <sys_unlink+0x107>
    iunlockput(ip);
801057e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e8:	89 04 24             	mov    %eax,(%esp)
801057eb:	e8 27 c3 ff ff       	call   80101b17 <iunlockput>
    goto bad;
801057f0:	e9 b5 00 00 00       	jmp    801058aa <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
801057f5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801057fc:	00 
801057fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105804:	00 
80105805:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105808:	89 04 24             	mov    %eax,(%esp)
8010580b:	e8 82 f5 ff ff       	call   80104d92 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105810:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105813:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010581a:	00 
8010581b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010581f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105822:	89 44 24 04          	mov    %eax,0x4(%esp)
80105826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105829:	89 04 24             	mov    %eax,(%esp)
8010582c:	e8 d5 c6 ff ff       	call   80101f06 <writei>
80105831:	83 f8 10             	cmp    $0x10,%eax
80105834:	74 0c                	je     80105842 <sys_unlink+0x154>
    panic("unlink: writei");
80105836:	c7 04 24 24 85 10 80 	movl   $0x80108524,(%esp)
8010583d:	e8 04 ad ff ff       	call   80100546 <panic>
  if(ip->type == T_DIR){
80105842:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105845:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105849:	66 83 f8 01          	cmp    $0x1,%ax
8010584d:	75 1c                	jne    8010586b <sys_unlink+0x17d>
    dp->nlink--;
8010584f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105852:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105856:	8d 50 ff             	lea    -0x1(%eax),%edx
80105859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105863:	89 04 24             	mov    %eax,(%esp)
80105866:	e8 6c be ff ff       	call   801016d7 <iupdate>
  }
  iunlockput(dp);
8010586b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586e:	89 04 24             	mov    %eax,(%esp)
80105871:	e8 a1 c2 ff ff       	call   80101b17 <iunlockput>

  ip->nlink--;
80105876:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105879:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010587d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105883:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105887:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010588a:	89 04 24             	mov    %eax,(%esp)
8010588d:	e8 45 be ff ff       	call   801016d7 <iupdate>
  iunlockput(ip);
80105892:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105895:	89 04 24             	mov    %eax,(%esp)
80105898:	e8 7a c2 ff ff       	call   80101b17 <iunlockput>

  commit_trans();
8010589d:	e8 03 da ff ff       	call   801032a5 <commit_trans>

  return 0;
801058a2:	b8 00 00 00 00       	mov    $0x0,%eax
801058a7:	eb 16                	jmp    801058bf <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801058a9:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
801058aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ad:	89 04 24             	mov    %eax,(%esp)
801058b0:	e8 62 c2 ff ff       	call   80101b17 <iunlockput>
  commit_trans();
801058b5:	e8 eb d9 ff ff       	call   801032a5 <commit_trans>
  return -1;
801058ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058bf:	c9                   	leave  
801058c0:	c3                   	ret    

801058c1 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801058c1:	55                   	push   %ebp
801058c2:	89 e5                	mov    %esp,%ebp
801058c4:	83 ec 48             	sub    $0x48,%esp
801058c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801058ca:	8b 55 10             	mov    0x10(%ebp),%edx
801058cd:	8b 45 14             	mov    0x14(%ebp),%eax
801058d0:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801058d4:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801058d8:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058dc:	8d 45 de             	lea    -0x22(%ebp),%eax
801058df:	89 44 24 04          	mov    %eax,0x4(%esp)
801058e3:	8b 45 08             	mov    0x8(%ebp),%eax
801058e6:	89 04 24             	mov    %eax,(%esp)
801058e9:	e8 78 cb ff ff       	call   80102466 <nameiparent>
801058ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058f5:	75 0a                	jne    80105901 <create+0x40>
    return 0;
801058f7:	b8 00 00 00 00       	mov    $0x0,%eax
801058fc:	e9 7e 01 00 00       	jmp    80105a7f <create+0x1be>
  ilock(dp);
80105901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105904:	89 04 24             	mov    %eax,(%esp)
80105907:	e8 87 bf ff ff       	call   80101893 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010590c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010590f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105913:	8d 45 de             	lea    -0x22(%ebp),%eax
80105916:	89 44 24 04          	mov    %eax,0x4(%esp)
8010591a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591d:	89 04 24             	mov    %eax,(%esp)
80105920:	e8 94 c7 ff ff       	call   801020b9 <dirlookup>
80105925:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105928:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010592c:	74 47                	je     80105975 <create+0xb4>
    iunlockput(dp);
8010592e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105931:	89 04 24             	mov    %eax,(%esp)
80105934:	e8 de c1 ff ff       	call   80101b17 <iunlockput>
    ilock(ip);
80105939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010593c:	89 04 24             	mov    %eax,(%esp)
8010593f:	e8 4f bf ff ff       	call   80101893 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105944:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105949:	75 15                	jne    80105960 <create+0x9f>
8010594b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010594e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105952:	66 83 f8 02          	cmp    $0x2,%ax
80105956:	75 08                	jne    80105960 <create+0x9f>
      return ip;
80105958:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595b:	e9 1f 01 00 00       	jmp    80105a7f <create+0x1be>
    iunlockput(ip);
80105960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105963:	89 04 24             	mov    %eax,(%esp)
80105966:	e8 ac c1 ff ff       	call   80101b17 <iunlockput>
    return 0;
8010596b:	b8 00 00 00 00       	mov    $0x0,%eax
80105970:	e9 0a 01 00 00       	jmp    80105a7f <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105975:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105979:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597c:	8b 00                	mov    (%eax),%eax
8010597e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105982:	89 04 24             	mov    %eax,(%esp)
80105985:	e8 6e bc ff ff       	call   801015f8 <ialloc>
8010598a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010598d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105991:	75 0c                	jne    8010599f <create+0xde>
    panic("create: ialloc");
80105993:	c7 04 24 33 85 10 80 	movl   $0x80108533,(%esp)
8010599a:	e8 a7 ab ff ff       	call   80100546 <panic>

  ilock(ip);
8010599f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a2:	89 04 24             	mov    %eax,(%esp)
801059a5:	e8 e9 be ff ff       	call   80101893 <ilock>
  ip->major = major;
801059aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ad:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801059b1:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801059b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b8:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801059bc:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801059c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c3:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801059c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059cc:	89 04 24             	mov    %eax,(%esp)
801059cf:	e8 03 bd ff ff       	call   801016d7 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801059d4:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801059d9:	75 6a                	jne    80105a45 <create+0x184>
    dp->nlink++;  // for ".."
801059db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059de:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059e2:	8d 50 01             	lea    0x1(%eax),%edx
801059e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e8:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801059ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ef:	89 04 24             	mov    %eax,(%esp)
801059f2:	e8 e0 bc ff ff       	call   801016d7 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801059f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059fa:	8b 40 04             	mov    0x4(%eax),%eax
801059fd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a01:	c7 44 24 04 0d 85 10 	movl   $0x8010850d,0x4(%esp)
80105a08:	80 
80105a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a0c:	89 04 24             	mov    %eax,(%esp)
80105a0f:	e8 6d c7 ff ff       	call   80102181 <dirlink>
80105a14:	85 c0                	test   %eax,%eax
80105a16:	78 21                	js     80105a39 <create+0x178>
80105a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1b:	8b 40 04             	mov    0x4(%eax),%eax
80105a1e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a22:	c7 44 24 04 0f 85 10 	movl   $0x8010850f,0x4(%esp)
80105a29:	80 
80105a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a2d:	89 04 24             	mov    %eax,(%esp)
80105a30:	e8 4c c7 ff ff       	call   80102181 <dirlink>
80105a35:	85 c0                	test   %eax,%eax
80105a37:	79 0c                	jns    80105a45 <create+0x184>
      panic("create dots");
80105a39:	c7 04 24 42 85 10 80 	movl   $0x80108542,(%esp)
80105a40:	e8 01 ab ff ff       	call   80100546 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a48:	8b 40 04             	mov    0x4(%eax),%eax
80105a4b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a4f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a52:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a59:	89 04 24             	mov    %eax,(%esp)
80105a5c:	e8 20 c7 ff ff       	call   80102181 <dirlink>
80105a61:	85 c0                	test   %eax,%eax
80105a63:	79 0c                	jns    80105a71 <create+0x1b0>
    panic("create: dirlink");
80105a65:	c7 04 24 4e 85 10 80 	movl   $0x8010854e,(%esp)
80105a6c:	e8 d5 aa ff ff       	call   80100546 <panic>

  iunlockput(dp);
80105a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a74:	89 04 24             	mov    %eax,(%esp)
80105a77:	e8 9b c0 ff ff       	call   80101b17 <iunlockput>

  return ip;
80105a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105a7f:	c9                   	leave  
80105a80:	c3                   	ret    

80105a81 <sys_open>:

int
sys_open(void)
{
80105a81:	55                   	push   %ebp
80105a82:	89 e5                	mov    %esp,%ebp
80105a84:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a87:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a95:	e8 e4 f6 ff ff       	call   8010517e <argstr>
80105a9a:	85 c0                	test   %eax,%eax
80105a9c:	78 17                	js     80105ab5 <sys_open+0x34>
80105a9e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aa5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105aac:	e8 3d f6 ff ff       	call   801050ee <argint>
80105ab1:	85 c0                	test   %eax,%eax
80105ab3:	79 0a                	jns    80105abf <sys_open+0x3e>
    return -1;
80105ab5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aba:	e9 48 01 00 00       	jmp    80105c07 <sys_open+0x186>
  if(omode & O_CREATE){
80105abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ac2:	25 00 02 00 00       	and    $0x200,%eax
80105ac7:	85 c0                	test   %eax,%eax
80105ac9:	74 40                	je     80105b0b <sys_open+0x8a>
    begin_trans();
80105acb:	e8 8c d7 ff ff       	call   8010325c <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ad3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105ada:	00 
80105adb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105ae2:	00 
80105ae3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105aea:	00 
80105aeb:	89 04 24             	mov    %eax,(%esp)
80105aee:	e8 ce fd ff ff       	call   801058c1 <create>
80105af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105af6:	e8 aa d7 ff ff       	call   801032a5 <commit_trans>
    if(ip == 0)
80105afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aff:	75 5c                	jne    80105b5d <sys_open+0xdc>
      return -1;
80105b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b06:	e9 fc 00 00 00       	jmp    80105c07 <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
80105b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105b0e:	89 04 24             	mov    %eax,(%esp)
80105b11:	e8 2e c9 ff ff       	call   80102444 <namei>
80105b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b1d:	75 0a                	jne    80105b29 <sys_open+0xa8>
      return -1;
80105b1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b24:	e9 de 00 00 00       	jmp    80105c07 <sys_open+0x186>
    ilock(ip);
80105b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2c:	89 04 24             	mov    %eax,(%esp)
80105b2f:	e8 5f bd ff ff       	call   80101893 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b37:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b3b:	66 83 f8 01          	cmp    $0x1,%ax
80105b3f:	75 1c                	jne    80105b5d <sys_open+0xdc>
80105b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b44:	85 c0                	test   %eax,%eax
80105b46:	74 15                	je     80105b5d <sys_open+0xdc>
      iunlockput(ip);
80105b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b4b:	89 04 24             	mov    %eax,(%esp)
80105b4e:	e8 c4 bf ff ff       	call   80101b17 <iunlockput>
      return -1;
80105b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b58:	e9 aa 00 00 00       	jmp    80105c07 <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b5d:	e8 da b3 ff ff       	call   80100f3c <filealloc>
80105b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b69:	74 14                	je     80105b7f <sys_open+0xfe>
80105b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b6e:	89 04 24             	mov    %eax,(%esp)
80105b71:	e8 43 f7 ff ff       	call   801052b9 <fdalloc>
80105b76:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105b79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105b7d:	79 23                	jns    80105ba2 <sys_open+0x121>
    if(f)
80105b7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b83:	74 0b                	je     80105b90 <sys_open+0x10f>
      fileclose(f);
80105b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b88:	89 04 24             	mov    %eax,(%esp)
80105b8b:	e8 54 b4 ff ff       	call   80100fe4 <fileclose>
    iunlockput(ip);
80105b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b93:	89 04 24             	mov    %eax,(%esp)
80105b96:	e8 7c bf ff ff       	call   80101b17 <iunlockput>
    return -1;
80105b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba0:	eb 65                	jmp    80105c07 <sys_open+0x186>
  }
  iunlock(ip);
80105ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba5:	89 04 24             	mov    %eax,(%esp)
80105ba8:	e8 34 be ff ff       	call   801019e1 <iunlock>

  f->type = FD_INODE;
80105bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb0:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bbc:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bcc:	83 e0 01             	and    $0x1,%eax
80105bcf:	85 c0                	test   %eax,%eax
80105bd1:	0f 94 c0             	sete   %al
80105bd4:	89 c2                	mov    %eax,%edx
80105bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd9:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bdf:	83 e0 01             	and    $0x1,%eax
80105be2:	85 c0                	test   %eax,%eax
80105be4:	75 0a                	jne    80105bf0 <sys_open+0x16f>
80105be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105be9:	83 e0 02             	and    $0x2,%eax
80105bec:	85 c0                	test   %eax,%eax
80105bee:	74 07                	je     80105bf7 <sys_open+0x176>
80105bf0:	b8 01 00 00 00       	mov    $0x1,%eax
80105bf5:	eb 05                	jmp    80105bfc <sys_open+0x17b>
80105bf7:	b8 00 00 00 00       	mov    $0x0,%eax
80105bfc:	89 c2                	mov    %eax,%edx
80105bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c01:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105c07:	c9                   	leave  
80105c08:	c3                   	ret    

80105c09 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c09:	55                   	push   %ebp
80105c0a:	89 e5                	mov    %esp,%ebp
80105c0c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105c0f:	e8 48 d6 ff ff       	call   8010325c <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c22:	e8 57 f5 ff ff       	call   8010517e <argstr>
80105c27:	85 c0                	test   %eax,%eax
80105c29:	78 2c                	js     80105c57 <sys_mkdir+0x4e>
80105c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105c35:	00 
80105c36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105c3d:	00 
80105c3e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105c45:	00 
80105c46:	89 04 24             	mov    %eax,(%esp)
80105c49:	e8 73 fc ff ff       	call   801058c1 <create>
80105c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c55:	75 0c                	jne    80105c63 <sys_mkdir+0x5a>
    commit_trans();
80105c57:	e8 49 d6 ff ff       	call   801032a5 <commit_trans>
    return -1;
80105c5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c61:	eb 15                	jmp    80105c78 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c66:	89 04 24             	mov    %eax,(%esp)
80105c69:	e8 a9 be ff ff       	call   80101b17 <iunlockput>
  commit_trans();
80105c6e:	e8 32 d6 ff ff       	call   801032a5 <commit_trans>
  return 0;
80105c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c78:	c9                   	leave  
80105c79:	c3                   	ret    

80105c7a <sys_mknod>:

int
sys_mknod(void)
{
80105c7a:	55                   	push   %ebp
80105c7b:	89 e5                	mov    %esp,%ebp
80105c7d:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105c80:	e8 d7 d5 ff ff       	call   8010325c <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105c85:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c88:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c93:	e8 e6 f4 ff ff       	call   8010517e <argstr>
80105c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c9f:	78 5e                	js     80105cff <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105ca1:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ca8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105caf:	e8 3a f4 ff ff       	call   801050ee <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105cb4:	85 c0                	test   %eax,%eax
80105cb6:	78 47                	js     80105cff <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105cb8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cbf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105cc6:	e8 23 f4 ff ff       	call   801050ee <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105ccb:	85 c0                	test   %eax,%eax
80105ccd:	78 30                	js     80105cff <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cd2:	0f bf c8             	movswl %ax,%ecx
80105cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cd8:	0f bf d0             	movswl %ax,%edx
80105cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105cde:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105ce2:	89 54 24 08          	mov    %edx,0x8(%esp)
80105ce6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105ced:	00 
80105cee:	89 04 24             	mov    %eax,(%esp)
80105cf1:	e8 cb fb ff ff       	call   801058c1 <create>
80105cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cfd:	75 0c                	jne    80105d0b <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105cff:	e8 a1 d5 ff ff       	call   801032a5 <commit_trans>
    return -1;
80105d04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d09:	eb 15                	jmp    80105d20 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0e:	89 04 24             	mov    %eax,(%esp)
80105d11:	e8 01 be ff ff       	call   80101b17 <iunlockput>
  commit_trans();
80105d16:	e8 8a d5 ff ff       	call   801032a5 <commit_trans>
  return 0;
80105d1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d20:	c9                   	leave  
80105d21:	c3                   	ret    

80105d22 <sys_chdir>:

int
sys_chdir(void)
{
80105d22:	55                   	push   %ebp
80105d23:	89 e5                	mov    %esp,%ebp
80105d25:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105d28:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d36:	e8 43 f4 ff ff       	call   8010517e <argstr>
80105d3b:	85 c0                	test   %eax,%eax
80105d3d:	78 14                	js     80105d53 <sys_chdir+0x31>
80105d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d42:	89 04 24             	mov    %eax,(%esp)
80105d45:	e8 fa c6 ff ff       	call   80102444 <namei>
80105d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d51:	75 07                	jne    80105d5a <sys_chdir+0x38>
    return -1;
80105d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d58:	eb 57                	jmp    80105db1 <sys_chdir+0x8f>
  ilock(ip);
80105d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5d:	89 04 24             	mov    %eax,(%esp)
80105d60:	e8 2e bb ff ff       	call   80101893 <ilock>
  if(ip->type != T_DIR){
80105d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d68:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d6c:	66 83 f8 01          	cmp    $0x1,%ax
80105d70:	74 12                	je     80105d84 <sys_chdir+0x62>
    iunlockput(ip);
80105d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d75:	89 04 24             	mov    %eax,(%esp)
80105d78:	e8 9a bd ff ff       	call   80101b17 <iunlockput>
    return -1;
80105d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d82:	eb 2d                	jmp    80105db1 <sys_chdir+0x8f>
  }
  iunlock(ip);
80105d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d87:	89 04 24             	mov    %eax,(%esp)
80105d8a:	e8 52 bc ff ff       	call   801019e1 <iunlock>
  iput(proc->cwd);
80105d8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d95:	8b 40 68             	mov    0x68(%eax),%eax
80105d98:	89 04 24             	mov    %eax,(%esp)
80105d9b:	e8 a6 bc ff ff       	call   80101a46 <iput>
  proc->cwd = ip;
80105da0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105da9:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105dac:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105db1:	c9                   	leave  
80105db2:	c3                   	ret    

80105db3 <sys_exec>:

int
sys_exec(void)
{
80105db3:	55                   	push   %ebp
80105db4:	89 e5                	mov    %esp,%ebp
80105db6:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105dbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dbf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dc3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dca:	e8 af f3 ff ff       	call   8010517e <argstr>
80105dcf:	85 c0                	test   %eax,%eax
80105dd1:	78 1a                	js     80105ded <sys_exec+0x3a>
80105dd3:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ddd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105de4:	e8 05 f3 ff ff       	call   801050ee <argint>
80105de9:	85 c0                	test   %eax,%eax
80105deb:	79 0a                	jns    80105df7 <sys_exec+0x44>
    return -1;
80105ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df2:	e9 c8 00 00 00       	jmp    80105ebf <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80105df7:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105dfe:	00 
80105dff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e06:	00 
80105e07:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105e0d:	89 04 24             	mov    %eax,(%esp)
80105e10:	e8 7d ef ff ff       	call   80104d92 <memset>
  for(i=0;; i++){
80105e15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1f:	83 f8 1f             	cmp    $0x1f,%eax
80105e22:	76 0a                	jbe    80105e2e <sys_exec+0x7b>
      return -1;
80105e24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e29:	e9 91 00 00 00       	jmp    80105ebf <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e31:	c1 e0 02             	shl    $0x2,%eax
80105e34:	89 c2                	mov    %eax,%edx
80105e36:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105e3c:	01 c2                	add    %eax,%edx
80105e3e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e44:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e48:	89 14 24             	mov    %edx,(%esp)
80105e4b:	e8 00 f2 ff ff       	call   80105050 <fetchint>
80105e50:	85 c0                	test   %eax,%eax
80105e52:	79 07                	jns    80105e5b <sys_exec+0xa8>
      return -1;
80105e54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e59:	eb 64                	jmp    80105ebf <sys_exec+0x10c>
    if(uarg == 0){
80105e5b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e61:	85 c0                	test   %eax,%eax
80105e63:	75 26                	jne    80105e8b <sys_exec+0xd8>
      argv[i] = 0;
80105e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e68:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105e6f:	00 00 00 00 
      break;
80105e73:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e77:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105e7d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e81:	89 04 24             	mov    %eax,(%esp)
80105e84:	e8 7f ac ff ff       	call   80100b08 <exec>
80105e89:	eb 34                	jmp    80105ebf <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e8b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e94:	c1 e2 02             	shl    $0x2,%edx
80105e97:	01 c2                	add    %eax,%edx
80105e99:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e9f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ea3:	89 04 24             	mov    %eax,(%esp)
80105ea6:	e8 df f1 ff ff       	call   8010508a <fetchstr>
80105eab:	85 c0                	test   %eax,%eax
80105ead:	79 07                	jns    80105eb6 <sys_exec+0x103>
      return -1;
80105eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb4:	eb 09                	jmp    80105ebf <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105eb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80105eba:	e9 5d ff ff ff       	jmp    80105e1c <sys_exec+0x69>
  return exec(path, argv);
}
80105ebf:	c9                   	leave  
80105ec0:	c3                   	ret    

80105ec1 <sys_pipe>:

int
sys_pipe(void)
{
80105ec1:	55                   	push   %ebp
80105ec2:	89 e5                	mov    %esp,%ebp
80105ec4:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ec7:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105ece:	00 
80105ecf:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ed6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105edd:	e8 3a f2 ff ff       	call   8010511c <argptr>
80105ee2:	85 c0                	test   %eax,%eax
80105ee4:	79 0a                	jns    80105ef0 <sys_pipe+0x2f>
    return -1;
80105ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eeb:	e9 9b 00 00 00       	jmp    80105f8b <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80105ef0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ef7:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105efa:	89 04 24             	mov    %eax,(%esp)
80105efd:	e8 6e dd ff ff       	call   80103c70 <pipealloc>
80105f02:	85 c0                	test   %eax,%eax
80105f04:	79 07                	jns    80105f0d <sys_pipe+0x4c>
    return -1;
80105f06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0b:	eb 7e                	jmp    80105f8b <sys_pipe+0xca>
  fd0 = -1;
80105f0d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f17:	89 04 24             	mov    %eax,(%esp)
80105f1a:	e8 9a f3 ff ff       	call   801052b9 <fdalloc>
80105f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f26:	78 14                	js     80105f3c <sys_pipe+0x7b>
80105f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f2b:	89 04 24             	mov    %eax,(%esp)
80105f2e:	e8 86 f3 ff ff       	call   801052b9 <fdalloc>
80105f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f3a:	79 37                	jns    80105f73 <sys_pipe+0xb2>
    if(fd0 >= 0)
80105f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f40:	78 14                	js     80105f56 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80105f42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f4b:	83 c2 08             	add    $0x8,%edx
80105f4e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105f55:	00 
    fileclose(rf);
80105f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f59:	89 04 24             	mov    %eax,(%esp)
80105f5c:	e8 83 b0 ff ff       	call   80100fe4 <fileclose>
    fileclose(wf);
80105f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f64:	89 04 24             	mov    %eax,(%esp)
80105f67:	e8 78 b0 ff ff       	call   80100fe4 <fileclose>
    return -1;
80105f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f71:	eb 18                	jmp    80105f8b <sys_pipe+0xca>
  }
  fd[0] = fd0;
80105f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f79:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f7e:	8d 50 04             	lea    0x4(%eax),%edx
80105f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f84:	89 02                	mov    %eax,(%edx)
  return 0;
80105f86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f8b:	c9                   	leave  
80105f8c:	c3                   	ret    
80105f8d:	00 00                	add    %al,(%eax)
	...

80105f90 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105f96:	e8 8c e3 ff ff       	call   80104327 <fork>
}
80105f9b:	c9                   	leave  
80105f9c:	c3                   	ret    

80105f9d <sys_exit>:

int
sys_exit(void)
{
80105f9d:	55                   	push   %ebp
80105f9e:	89 e5                	mov    %esp,%ebp
80105fa0:	83 ec 08             	sub    $0x8,%esp
  exit();
80105fa3:	e8 e2 e4 ff ff       	call   8010448a <exit>
  return 0;  // not reached
80105fa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fad:	c9                   	leave  
80105fae:	c3                   	ret    

80105faf <sys_wait>:

int
sys_wait(void)
{
80105faf:	55                   	push   %ebp
80105fb0:	89 e5                	mov    %esp,%ebp
80105fb2:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105fb5:	e8 e8 e5 ff ff       	call   801045a2 <wait>
}
80105fba:	c9                   	leave  
80105fbb:	c3                   	ret    

80105fbc <sys_kill>:

int
sys_kill(void)
{
80105fbc:	55                   	push   %ebp
80105fbd:	89 e5                	mov    %esp,%ebp
80105fbf:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105fc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fd0:	e8 19 f1 ff ff       	call   801050ee <argint>
80105fd5:	85 c0                	test   %eax,%eax
80105fd7:	79 07                	jns    80105fe0 <sys_kill+0x24>
    return -1;
80105fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fde:	eb 0b                	jmp    80105feb <sys_kill+0x2f>
  return kill(pid);
80105fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe3:	89 04 24             	mov    %eax,(%esp)
80105fe6:	e8 73 e9 ff ff       	call   8010495e <kill>
}
80105feb:	c9                   	leave  
80105fec:	c3                   	ret    

80105fed <sys_getpid>:

int
sys_getpid(void)
{
80105fed:	55                   	push   %ebp
80105fee:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105ff0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ff6:	8b 40 10             	mov    0x10(%eax),%eax
}
80105ff9:	5d                   	pop    %ebp
80105ffa:	c3                   	ret    

80105ffb <sys_sbrk>:

int
sys_sbrk(void)
{
80105ffb:	55                   	push   %ebp
80105ffc:	89 e5                	mov    %esp,%ebp
80105ffe:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106001:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106004:	89 44 24 04          	mov    %eax,0x4(%esp)
80106008:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010600f:	e8 da f0 ff ff       	call   801050ee <argint>
80106014:	85 c0                	test   %eax,%eax
80106016:	79 07                	jns    8010601f <sys_sbrk+0x24>
    return -1;
80106018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601d:	eb 24                	jmp    80106043 <sys_sbrk+0x48>
  addr = proc->sz;
8010601f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106025:	8b 00                	mov    (%eax),%eax
80106027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010602a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010602d:	89 04 24             	mov    %eax,(%esp)
80106030:	e8 4d e2 ff ff       	call   80104282 <growproc>
80106035:	85 c0                	test   %eax,%eax
80106037:	79 07                	jns    80106040 <sys_sbrk+0x45>
    return -1;
80106039:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603e:	eb 03                	jmp    80106043 <sys_sbrk+0x48>
  return addr;
80106040:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106043:	c9                   	leave  
80106044:	c3                   	ret    

80106045 <sys_sleep>:

int
sys_sleep(void)
{
80106045:	55                   	push   %ebp
80106046:	89 e5                	mov    %esp,%ebp
80106048:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010604b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010604e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106052:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106059:	e8 90 f0 ff ff       	call   801050ee <argint>
8010605e:	85 c0                	test   %eax,%eax
80106060:	79 07                	jns    80106069 <sys_sleep+0x24>
    return -1;
80106062:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106067:	eb 6c                	jmp    801060d5 <sys_sleep+0x90>
  acquire(&tickslock);
80106069:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80106070:	e8 c2 ea ff ff       	call   80104b37 <acquire>
  ticks0 = ticks;
80106075:	a1 a0 26 11 80       	mov    0x801126a0,%eax
8010607a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010607d:	eb 34                	jmp    801060b3 <sys_sleep+0x6e>
    if(proc->killed){
8010607f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106085:	8b 40 24             	mov    0x24(%eax),%eax
80106088:	85 c0                	test   %eax,%eax
8010608a:	74 13                	je     8010609f <sys_sleep+0x5a>
      release(&tickslock);
8010608c:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80106093:	e8 01 eb ff ff       	call   80104b99 <release>
      return -1;
80106098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609d:	eb 36                	jmp    801060d5 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010609f:	c7 44 24 04 60 1e 11 	movl   $0x80111e60,0x4(%esp)
801060a6:	80 
801060a7:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801060ae:	e8 a7 e7 ff ff       	call   8010485a <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060b3:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801060b8:	89 c2                	mov    %eax,%edx
801060ba:	2b 55 f4             	sub    -0xc(%ebp),%edx
801060bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c0:	39 c2                	cmp    %eax,%edx
801060c2:	72 bb                	jb     8010607f <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801060c4:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
801060cb:	e8 c9 ea ff ff       	call   80104b99 <release>
  return 0;
801060d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060d5:	c9                   	leave  
801060d6:	c3                   	ret    

801060d7 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060d7:	55                   	push   %ebp
801060d8:	89 e5                	mov    %esp,%ebp
801060da:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801060dd:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
801060e4:	e8 4e ea ff ff       	call   80104b37 <acquire>
  xticks = ticks;
801060e9:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801060ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801060f1:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
801060f8:	e8 9c ea ff ff       	call   80104b99 <release>
  return xticks;
801060fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106100:	c9                   	leave  
80106101:	c3                   	ret    
	...

80106104 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106104:	55                   	push   %ebp
80106105:	89 e5                	mov    %esp,%ebp
80106107:	83 ec 08             	sub    $0x8,%esp
8010610a:	8b 55 08             	mov    0x8(%ebp),%edx
8010610d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106110:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106114:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106117:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010611b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010611f:	ee                   	out    %al,(%dx)
}
80106120:	c9                   	leave  
80106121:	c3                   	ret    

80106122 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106122:	55                   	push   %ebp
80106123:	89 e5                	mov    %esp,%ebp
80106125:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106128:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
8010612f:	00 
80106130:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106137:	e8 c8 ff ff ff       	call   80106104 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
8010613c:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106143:	00 
80106144:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010614b:	e8 b4 ff ff ff       	call   80106104 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106150:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106157:	00 
80106158:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010615f:	e8 a0 ff ff ff       	call   80106104 <outb>
  picenable(IRQ_TIMER);
80106164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010616b:	e8 89 d9 ff ff       	call   80103af9 <picenable>
}
80106170:	c9                   	leave  
80106171:	c3                   	ret    
	...

80106174 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106174:	1e                   	push   %ds
  pushl %es
80106175:	06                   	push   %es
  pushl %fs
80106176:	0f a0                	push   %fs
  pushl %gs
80106178:	0f a8                	push   %gs
  pushal
8010617a:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010617b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010617f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106181:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106183:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106187:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106189:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010618b:	54                   	push   %esp
  call trap
8010618c:	e8 de 01 00 00       	call   8010636f <trap>
  addl $4, %esp
80106191:	83 c4 04             	add    $0x4,%esp

80106194 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106194:	61                   	popa   
  popl %gs
80106195:	0f a9                	pop    %gs
  popl %fs
80106197:	0f a1                	pop    %fs
  popl %es
80106199:	07                   	pop    %es
  popl %ds
8010619a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010619b:	83 c4 08             	add    $0x8,%esp
  iret
8010619e:	cf                   	iret   
	...

801061a0 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801061a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801061a9:	83 e8 01             	sub    $0x1,%eax
801061ac:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061b0:	8b 45 08             	mov    0x8(%ebp),%eax
801061b3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061b7:	8b 45 08             	mov    0x8(%ebp),%eax
801061ba:	c1 e8 10             	shr    $0x10,%eax
801061bd:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801061c1:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061c4:	0f 01 18             	lidtl  (%eax)
}
801061c7:	c9                   	leave  
801061c8:	c3                   	ret    

801061c9 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801061c9:	55                   	push   %ebp
801061ca:	89 e5                	mov    %esp,%ebp
801061cc:	53                   	push   %ebx
801061cd:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801061d0:	0f 20 d3             	mov    %cr2,%ebx
801061d3:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
801061d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801061d9:	83 c4 10             	add    $0x10,%esp
801061dc:	5b                   	pop    %ebx
801061dd:	5d                   	pop    %ebp
801061de:	c3                   	ret    

801061df <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061df:	55                   	push   %ebp
801061e0:	89 e5                	mov    %esp,%ebp
801061e2:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801061e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061ec:	e9 c3 00 00 00       	jmp    801062b4 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f4:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801061fb:	89 c2                	mov    %eax,%edx
801061fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106200:	66 89 14 c5 a0 1e 11 	mov    %dx,-0x7feee160(,%eax,8)
80106207:	80 
80106208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620b:	66 c7 04 c5 a2 1e 11 	movw   $0x8,-0x7feee15e(,%eax,8)
80106212:	80 08 00 
80106215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106218:	0f b6 14 c5 a4 1e 11 	movzbl -0x7feee15c(,%eax,8),%edx
8010621f:	80 
80106220:	83 e2 e0             	and    $0xffffffe0,%edx
80106223:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
8010622a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010622d:	0f b6 14 c5 a4 1e 11 	movzbl -0x7feee15c(,%eax,8),%edx
80106234:	80 
80106235:	83 e2 1f             	and    $0x1f,%edx
80106238:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
8010623f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106242:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
80106249:	80 
8010624a:	83 e2 f0             	and    $0xfffffff0,%edx
8010624d:	83 ca 0e             	or     $0xe,%edx
80106250:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010625a:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
80106261:	80 
80106262:	83 e2 ef             	and    $0xffffffef,%edx
80106265:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
8010626c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010626f:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
80106276:	80 
80106277:	83 e2 9f             	and    $0xffffff9f,%edx
8010627a:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106284:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
8010628b:	80 
8010628c:	83 ca 80             	or     $0xffffff80,%edx
8010628f:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106299:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801062a0:	c1 e8 10             	shr    $0x10,%eax
801062a3:	89 c2                	mov    %eax,%edx
801062a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a8:	66 89 14 c5 a6 1e 11 	mov    %dx,-0x7feee15a(,%eax,8)
801062af:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801062b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801062b4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801062bb:	0f 8e 30 ff ff ff    	jle    801061f1 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062c1:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801062c6:	66 a3 a0 20 11 80    	mov    %ax,0x801120a0
801062cc:	66 c7 05 a2 20 11 80 	movw   $0x8,0x801120a2
801062d3:	08 00 
801062d5:	0f b6 05 a4 20 11 80 	movzbl 0x801120a4,%eax
801062dc:	83 e0 e0             	and    $0xffffffe0,%eax
801062df:	a2 a4 20 11 80       	mov    %al,0x801120a4
801062e4:	0f b6 05 a4 20 11 80 	movzbl 0x801120a4,%eax
801062eb:	83 e0 1f             	and    $0x1f,%eax
801062ee:	a2 a4 20 11 80       	mov    %al,0x801120a4
801062f3:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
801062fa:	83 c8 0f             	or     $0xf,%eax
801062fd:	a2 a5 20 11 80       	mov    %al,0x801120a5
80106302:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
80106309:	83 e0 ef             	and    $0xffffffef,%eax
8010630c:	a2 a5 20 11 80       	mov    %al,0x801120a5
80106311:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
80106318:	83 c8 60             	or     $0x60,%eax
8010631b:	a2 a5 20 11 80       	mov    %al,0x801120a5
80106320:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
80106327:	83 c8 80             	or     $0xffffff80,%eax
8010632a:	a2 a5 20 11 80       	mov    %al,0x801120a5
8010632f:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106334:	c1 e8 10             	shr    $0x10,%eax
80106337:	66 a3 a6 20 11 80    	mov    %ax,0x801120a6
  
  initlock(&tickslock, "time");
8010633d:	c7 44 24 04 60 85 10 	movl   $0x80108560,0x4(%esp)
80106344:	80 
80106345:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
8010634c:	e8 c5 e7 ff ff       	call   80104b16 <initlock>
}
80106351:	c9                   	leave  
80106352:	c3                   	ret    

80106353 <idtinit>:

void
idtinit(void)
{
80106353:	55                   	push   %ebp
80106354:	89 e5                	mov    %esp,%ebp
80106356:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106359:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106360:	00 
80106361:	c7 04 24 a0 1e 11 80 	movl   $0x80111ea0,(%esp)
80106368:	e8 33 fe ff ff       	call   801061a0 <lidt>
}
8010636d:	c9                   	leave  
8010636e:	c3                   	ret    

8010636f <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010636f:	55                   	push   %ebp
80106370:	89 e5                	mov    %esp,%ebp
80106372:	57                   	push   %edi
80106373:	56                   	push   %esi
80106374:	53                   	push   %ebx
80106375:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106378:	8b 45 08             	mov    0x8(%ebp),%eax
8010637b:	8b 40 30             	mov    0x30(%eax),%eax
8010637e:	83 f8 40             	cmp    $0x40,%eax
80106381:	75 3e                	jne    801063c1 <trap+0x52>
    if(proc->killed)
80106383:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106389:	8b 40 24             	mov    0x24(%eax),%eax
8010638c:	85 c0                	test   %eax,%eax
8010638e:	74 05                	je     80106395 <trap+0x26>
      exit();
80106390:	e8 f5 e0 ff ff       	call   8010448a <exit>
    proc->tf = tf;
80106395:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010639b:	8b 55 08             	mov    0x8(%ebp),%edx
8010639e:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801063a1:	e8 0f ee ff ff       	call   801051b5 <syscall>
    if(proc->killed)
801063a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063ac:	8b 40 24             	mov    0x24(%eax),%eax
801063af:	85 c0                	test   %eax,%eax
801063b1:	0f 84 34 02 00 00    	je     801065eb <trap+0x27c>
      exit();
801063b7:	e8 ce e0 ff ff       	call   8010448a <exit>
    return;
801063bc:	e9 2a 02 00 00       	jmp    801065eb <trap+0x27c>
  }

  switch(tf->trapno){
801063c1:	8b 45 08             	mov    0x8(%ebp),%eax
801063c4:	8b 40 30             	mov    0x30(%eax),%eax
801063c7:	83 e8 20             	sub    $0x20,%eax
801063ca:	83 f8 1f             	cmp    $0x1f,%eax
801063cd:	0f 87 bc 00 00 00    	ja     8010648f <trap+0x120>
801063d3:	8b 04 85 08 86 10 80 	mov    -0x7fef79f8(,%eax,4),%eax
801063da:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801063dc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801063e2:	0f b6 00             	movzbl (%eax),%eax
801063e5:	84 c0                	test   %al,%al
801063e7:	75 31                	jne    8010641a <trap+0xab>
      acquire(&tickslock);
801063e9:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
801063f0:	e8 42 e7 ff ff       	call   80104b37 <acquire>
      ticks++;
801063f5:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801063fa:	83 c0 01             	add    $0x1,%eax
801063fd:	a3 a0 26 11 80       	mov    %eax,0x801126a0
      wakeup(&ticks);
80106402:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80106409:	e8 25 e5 ff ff       	call   80104933 <wakeup>
      release(&tickslock);
8010640e:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80106415:	e8 7f e7 ff ff       	call   80104b99 <release>
    }
    lapiceoi();
8010641a:	e8 06 cb ff ff       	call   80102f25 <lapiceoi>
    break;
8010641f:	e9 41 01 00 00       	jmp    80106565 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106424:	e8 00 c3 ff ff       	call   80102729 <ideintr>
    lapiceoi();
80106429:	e8 f7 ca ff ff       	call   80102f25 <lapiceoi>
    break;
8010642e:	e9 32 01 00 00       	jmp    80106565 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106433:	e8 c9 c8 ff ff       	call   80102d01 <kbdintr>
    lapiceoi();
80106438:	e8 e8 ca ff ff       	call   80102f25 <lapiceoi>
    break;
8010643d:	e9 23 01 00 00       	jmp    80106565 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106442:	e8 a9 03 00 00       	call   801067f0 <uartintr>
    lapiceoi();
80106447:	e8 d9 ca ff ff       	call   80102f25 <lapiceoi>
    break;
8010644c:	e9 14 01 00 00       	jmp    80106565 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80106451:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106454:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106457:	8b 45 08             	mov    0x8(%ebp),%eax
8010645a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010645e:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106461:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106467:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010646a:	0f b6 c0             	movzbl %al,%eax
8010646d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106471:	89 54 24 08          	mov    %edx,0x8(%esp)
80106475:	89 44 24 04          	mov    %eax,0x4(%esp)
80106479:	c7 04 24 68 85 10 80 	movl   $0x80108568,(%esp)
80106480:	e8 25 9f ff ff       	call   801003aa <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106485:	e8 9b ca ff ff       	call   80102f25 <lapiceoi>
    break;
8010648a:	e9 d6 00 00 00       	jmp    80106565 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010648f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106495:	85 c0                	test   %eax,%eax
80106497:	74 11                	je     801064aa <trap+0x13b>
80106499:	8b 45 08             	mov    0x8(%ebp),%eax
8010649c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801064a0:	0f b7 c0             	movzwl %ax,%eax
801064a3:	83 e0 03             	and    $0x3,%eax
801064a6:	85 c0                	test   %eax,%eax
801064a8:	75 46                	jne    801064f0 <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064aa:	e8 1a fd ff ff       	call   801061c9 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
801064af:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064b2:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801064b5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801064bc:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064bf:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801064c2:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064c5:	8b 52 30             	mov    0x30(%edx),%edx
801064c8:	89 44 24 10          	mov    %eax,0x10(%esp)
801064cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801064d0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801064d4:	89 54 24 04          	mov    %edx,0x4(%esp)
801064d8:	c7 04 24 8c 85 10 80 	movl   $0x8010858c,(%esp)
801064df:	e8 c6 9e ff ff       	call   801003aa <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801064e4:	c7 04 24 be 85 10 80 	movl   $0x801085be,(%esp)
801064eb:	e8 56 a0 ff ff       	call   80100546 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064f0:	e8 d4 fc ff ff       	call   801061c9 <rcr2>
801064f5:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801064f7:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064fa:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801064fd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106503:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106506:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106509:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010650c:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010650f:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106512:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106515:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010651b:	83 c0 6c             	add    $0x6c,%eax
8010651e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106521:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106527:	8b 40 10             	mov    0x10(%eax),%eax
8010652a:	89 54 24 1c          	mov    %edx,0x1c(%esp)
8010652e:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106532:	89 74 24 14          	mov    %esi,0x14(%esp)
80106536:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010653a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010653e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106541:	89 54 24 08          	mov    %edx,0x8(%esp)
80106545:	89 44 24 04          	mov    %eax,0x4(%esp)
80106549:	c7 04 24 c4 85 10 80 	movl   $0x801085c4,(%esp)
80106550:	e8 55 9e ff ff       	call   801003aa <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106555:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010655b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106562:	eb 01                	jmp    80106565 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106564:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106565:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010656b:	85 c0                	test   %eax,%eax
8010656d:	74 24                	je     80106593 <trap+0x224>
8010656f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106575:	8b 40 24             	mov    0x24(%eax),%eax
80106578:	85 c0                	test   %eax,%eax
8010657a:	74 17                	je     80106593 <trap+0x224>
8010657c:	8b 45 08             	mov    0x8(%ebp),%eax
8010657f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106583:	0f b7 c0             	movzwl %ax,%eax
80106586:	83 e0 03             	and    $0x3,%eax
80106589:	83 f8 03             	cmp    $0x3,%eax
8010658c:	75 05                	jne    80106593 <trap+0x224>
    exit();
8010658e:	e8 f7 de ff ff       	call   8010448a <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106593:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106599:	85 c0                	test   %eax,%eax
8010659b:	74 1e                	je     801065bb <trap+0x24c>
8010659d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065a3:	8b 40 0c             	mov    0xc(%eax),%eax
801065a6:	83 f8 04             	cmp    $0x4,%eax
801065a9:	75 10                	jne    801065bb <trap+0x24c>
801065ab:	8b 45 08             	mov    0x8(%ebp),%eax
801065ae:	8b 40 30             	mov    0x30(%eax),%eax
801065b1:	83 f8 20             	cmp    $0x20,%eax
801065b4:	75 05                	jne    801065bb <trap+0x24c>
    yield();
801065b6:	e8 41 e2 ff ff       	call   801047fc <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801065bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065c1:	85 c0                	test   %eax,%eax
801065c3:	74 27                	je     801065ec <trap+0x27d>
801065c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065cb:	8b 40 24             	mov    0x24(%eax),%eax
801065ce:	85 c0                	test   %eax,%eax
801065d0:	74 1a                	je     801065ec <trap+0x27d>
801065d2:	8b 45 08             	mov    0x8(%ebp),%eax
801065d5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801065d9:	0f b7 c0             	movzwl %ax,%eax
801065dc:	83 e0 03             	and    $0x3,%eax
801065df:	83 f8 03             	cmp    $0x3,%eax
801065e2:	75 08                	jne    801065ec <trap+0x27d>
    exit();
801065e4:	e8 a1 de ff ff       	call   8010448a <exit>
801065e9:	eb 01                	jmp    801065ec <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801065eb:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801065ec:	83 c4 3c             	add    $0x3c,%esp
801065ef:	5b                   	pop    %ebx
801065f0:	5e                   	pop    %esi
801065f1:	5f                   	pop    %edi
801065f2:	5d                   	pop    %ebp
801065f3:	c3                   	ret    

801065f4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	53                   	push   %ebx
801065f8:	83 ec 14             	sub    $0x14,%esp
801065fb:	8b 45 08             	mov    0x8(%ebp),%eax
801065fe:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106602:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80106606:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010660a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
8010660e:	ec                   	in     (%dx),%al
8010660f:	89 c3                	mov    %eax,%ebx
80106611:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106614:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80106618:	83 c4 14             	add    $0x14,%esp
8010661b:	5b                   	pop    %ebx
8010661c:	5d                   	pop    %ebp
8010661d:	c3                   	ret    

8010661e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010661e:	55                   	push   %ebp
8010661f:	89 e5                	mov    %esp,%ebp
80106621:	83 ec 08             	sub    $0x8,%esp
80106624:	8b 55 08             	mov    0x8(%ebp),%edx
80106627:	8b 45 0c             	mov    0xc(%ebp),%eax
8010662a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010662e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106631:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106635:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106639:	ee                   	out    %al,(%dx)
}
8010663a:	c9                   	leave  
8010663b:	c3                   	ret    

8010663c <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010663c:	55                   	push   %ebp
8010663d:	89 e5                	mov    %esp,%ebp
8010663f:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106642:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106649:	00 
8010664a:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106651:	e8 c8 ff ff ff       	call   8010661e <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106656:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
8010665d:	00 
8010665e:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106665:	e8 b4 ff ff ff       	call   8010661e <outb>
  outb(COM1+0, 115200/9600);
8010666a:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106671:	00 
80106672:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106679:	e8 a0 ff ff ff       	call   8010661e <outb>
  outb(COM1+1, 0);
8010667e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106685:	00 
80106686:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010668d:	e8 8c ff ff ff       	call   8010661e <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106692:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106699:	00 
8010669a:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801066a1:	e8 78 ff ff ff       	call   8010661e <outb>
  outb(COM1+4, 0);
801066a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801066ad:	00 
801066ae:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801066b5:	e8 64 ff ff ff       	call   8010661e <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801066ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801066c1:	00 
801066c2:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801066c9:	e8 50 ff ff ff       	call   8010661e <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801066ce:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801066d5:	e8 1a ff ff ff       	call   801065f4 <inb>
801066da:	3c ff                	cmp    $0xff,%al
801066dc:	74 6c                	je     8010674a <uartinit+0x10e>
    return;
  uart = 1;
801066de:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
801066e5:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801066e8:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801066ef:	e8 00 ff ff ff       	call   801065f4 <inb>
  inb(COM1+0);
801066f4:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801066fb:	e8 f4 fe ff ff       	call   801065f4 <inb>
  picenable(IRQ_COM1);
80106700:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106707:	e8 ed d3 ff ff       	call   80103af9 <picenable>
  ioapicenable(IRQ_COM1, 0);
8010670c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106713:	00 
80106714:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010671b:	e8 8e c2 ff ff       	call   801029ae <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106720:	c7 45 f4 88 86 10 80 	movl   $0x80108688,-0xc(%ebp)
80106727:	eb 15                	jmp    8010673e <uartinit+0x102>
    uartputc(*p);
80106729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672c:	0f b6 00             	movzbl (%eax),%eax
8010672f:	0f be c0             	movsbl %al,%eax
80106732:	89 04 24             	mov    %eax,(%esp)
80106735:	e8 13 00 00 00       	call   8010674d <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010673a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010673e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106741:	0f b6 00             	movzbl (%eax),%eax
80106744:	84 c0                	test   %al,%al
80106746:	75 e1                	jne    80106729 <uartinit+0xed>
80106748:	eb 01                	jmp    8010674b <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010674a:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010674b:	c9                   	leave  
8010674c:	c3                   	ret    

8010674d <uartputc>:

void
uartputc(int c)
{
8010674d:	55                   	push   %ebp
8010674e:	89 e5                	mov    %esp,%ebp
80106750:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106753:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106758:	85 c0                	test   %eax,%eax
8010675a:	74 4d                	je     801067a9 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010675c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106763:	eb 10                	jmp    80106775 <uartputc+0x28>
    microdelay(10);
80106765:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010676c:	e8 d9 c7 ff ff       	call   80102f4a <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106771:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106775:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106779:	7f 16                	jg     80106791 <uartputc+0x44>
8010677b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106782:	e8 6d fe ff ff       	call   801065f4 <inb>
80106787:	0f b6 c0             	movzbl %al,%eax
8010678a:	83 e0 20             	and    $0x20,%eax
8010678d:	85 c0                	test   %eax,%eax
8010678f:	74 d4                	je     80106765 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106791:	8b 45 08             	mov    0x8(%ebp),%eax
80106794:	0f b6 c0             	movzbl %al,%eax
80106797:	89 44 24 04          	mov    %eax,0x4(%esp)
8010679b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801067a2:	e8 77 fe ff ff       	call   8010661e <outb>
801067a7:	eb 01                	jmp    801067aa <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801067a9:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801067aa:	c9                   	leave  
801067ab:	c3                   	ret    

801067ac <uartgetc>:

static int
uartgetc(void)
{
801067ac:	55                   	push   %ebp
801067ad:	89 e5                	mov    %esp,%ebp
801067af:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801067b2:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801067b7:	85 c0                	test   %eax,%eax
801067b9:	75 07                	jne    801067c2 <uartgetc+0x16>
    return -1;
801067bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c0:	eb 2c                	jmp    801067ee <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801067c2:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801067c9:	e8 26 fe ff ff       	call   801065f4 <inb>
801067ce:	0f b6 c0             	movzbl %al,%eax
801067d1:	83 e0 01             	and    $0x1,%eax
801067d4:	85 c0                	test   %eax,%eax
801067d6:	75 07                	jne    801067df <uartgetc+0x33>
    return -1;
801067d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067dd:	eb 0f                	jmp    801067ee <uartgetc+0x42>
  return inb(COM1+0);
801067df:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801067e6:	e8 09 fe ff ff       	call   801065f4 <inb>
801067eb:	0f b6 c0             	movzbl %al,%eax
}
801067ee:	c9                   	leave  
801067ef:	c3                   	ret    

801067f0 <uartintr>:

void
uartintr(void)
{
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801067f6:	c7 04 24 ac 67 10 80 	movl   $0x801067ac,(%esp)
801067fd:	e8 b4 9f ff ff       	call   801007b6 <consoleintr>
}
80106802:	c9                   	leave  
80106803:	c3                   	ret    

80106804 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $0
80106806:	6a 00                	push   $0x0
  jmp alltraps
80106808:	e9 67 f9 ff ff       	jmp    80106174 <alltraps>

8010680d <vector1>:
.globl vector1
vector1:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $1
8010680f:	6a 01                	push   $0x1
  jmp alltraps
80106811:	e9 5e f9 ff ff       	jmp    80106174 <alltraps>

80106816 <vector2>:
.globl vector2
vector2:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $2
80106818:	6a 02                	push   $0x2
  jmp alltraps
8010681a:	e9 55 f9 ff ff       	jmp    80106174 <alltraps>

8010681f <vector3>:
.globl vector3
vector3:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $3
80106821:	6a 03                	push   $0x3
  jmp alltraps
80106823:	e9 4c f9 ff ff       	jmp    80106174 <alltraps>

80106828 <vector4>:
.globl vector4
vector4:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $4
8010682a:	6a 04                	push   $0x4
  jmp alltraps
8010682c:	e9 43 f9 ff ff       	jmp    80106174 <alltraps>

80106831 <vector5>:
.globl vector5
vector5:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $5
80106833:	6a 05                	push   $0x5
  jmp alltraps
80106835:	e9 3a f9 ff ff       	jmp    80106174 <alltraps>

8010683a <vector6>:
.globl vector6
vector6:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $6
8010683c:	6a 06                	push   $0x6
  jmp alltraps
8010683e:	e9 31 f9 ff ff       	jmp    80106174 <alltraps>

80106843 <vector7>:
.globl vector7
vector7:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $7
80106845:	6a 07                	push   $0x7
  jmp alltraps
80106847:	e9 28 f9 ff ff       	jmp    80106174 <alltraps>

8010684c <vector8>:
.globl vector8
vector8:
  pushl $8
8010684c:	6a 08                	push   $0x8
  jmp alltraps
8010684e:	e9 21 f9 ff ff       	jmp    80106174 <alltraps>

80106853 <vector9>:
.globl vector9
vector9:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $9
80106855:	6a 09                	push   $0x9
  jmp alltraps
80106857:	e9 18 f9 ff ff       	jmp    80106174 <alltraps>

8010685c <vector10>:
.globl vector10
vector10:
  pushl $10
8010685c:	6a 0a                	push   $0xa
  jmp alltraps
8010685e:	e9 11 f9 ff ff       	jmp    80106174 <alltraps>

80106863 <vector11>:
.globl vector11
vector11:
  pushl $11
80106863:	6a 0b                	push   $0xb
  jmp alltraps
80106865:	e9 0a f9 ff ff       	jmp    80106174 <alltraps>

8010686a <vector12>:
.globl vector12
vector12:
  pushl $12
8010686a:	6a 0c                	push   $0xc
  jmp alltraps
8010686c:	e9 03 f9 ff ff       	jmp    80106174 <alltraps>

80106871 <vector13>:
.globl vector13
vector13:
  pushl $13
80106871:	6a 0d                	push   $0xd
  jmp alltraps
80106873:	e9 fc f8 ff ff       	jmp    80106174 <alltraps>

80106878 <vector14>:
.globl vector14
vector14:
  pushl $14
80106878:	6a 0e                	push   $0xe
  jmp alltraps
8010687a:	e9 f5 f8 ff ff       	jmp    80106174 <alltraps>

8010687f <vector15>:
.globl vector15
vector15:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $15
80106881:	6a 0f                	push   $0xf
  jmp alltraps
80106883:	e9 ec f8 ff ff       	jmp    80106174 <alltraps>

80106888 <vector16>:
.globl vector16
vector16:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $16
8010688a:	6a 10                	push   $0x10
  jmp alltraps
8010688c:	e9 e3 f8 ff ff       	jmp    80106174 <alltraps>

80106891 <vector17>:
.globl vector17
vector17:
  pushl $17
80106891:	6a 11                	push   $0x11
  jmp alltraps
80106893:	e9 dc f8 ff ff       	jmp    80106174 <alltraps>

80106898 <vector18>:
.globl vector18
vector18:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $18
8010689a:	6a 12                	push   $0x12
  jmp alltraps
8010689c:	e9 d3 f8 ff ff       	jmp    80106174 <alltraps>

801068a1 <vector19>:
.globl vector19
vector19:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $19
801068a3:	6a 13                	push   $0x13
  jmp alltraps
801068a5:	e9 ca f8 ff ff       	jmp    80106174 <alltraps>

801068aa <vector20>:
.globl vector20
vector20:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $20
801068ac:	6a 14                	push   $0x14
  jmp alltraps
801068ae:	e9 c1 f8 ff ff       	jmp    80106174 <alltraps>

801068b3 <vector21>:
.globl vector21
vector21:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $21
801068b5:	6a 15                	push   $0x15
  jmp alltraps
801068b7:	e9 b8 f8 ff ff       	jmp    80106174 <alltraps>

801068bc <vector22>:
.globl vector22
vector22:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $22
801068be:	6a 16                	push   $0x16
  jmp alltraps
801068c0:	e9 af f8 ff ff       	jmp    80106174 <alltraps>

801068c5 <vector23>:
.globl vector23
vector23:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $23
801068c7:	6a 17                	push   $0x17
  jmp alltraps
801068c9:	e9 a6 f8 ff ff       	jmp    80106174 <alltraps>

801068ce <vector24>:
.globl vector24
vector24:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $24
801068d0:	6a 18                	push   $0x18
  jmp alltraps
801068d2:	e9 9d f8 ff ff       	jmp    80106174 <alltraps>

801068d7 <vector25>:
.globl vector25
vector25:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $25
801068d9:	6a 19                	push   $0x19
  jmp alltraps
801068db:	e9 94 f8 ff ff       	jmp    80106174 <alltraps>

801068e0 <vector26>:
.globl vector26
vector26:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $26
801068e2:	6a 1a                	push   $0x1a
  jmp alltraps
801068e4:	e9 8b f8 ff ff       	jmp    80106174 <alltraps>

801068e9 <vector27>:
.globl vector27
vector27:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $27
801068eb:	6a 1b                	push   $0x1b
  jmp alltraps
801068ed:	e9 82 f8 ff ff       	jmp    80106174 <alltraps>

801068f2 <vector28>:
.globl vector28
vector28:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $28
801068f4:	6a 1c                	push   $0x1c
  jmp alltraps
801068f6:	e9 79 f8 ff ff       	jmp    80106174 <alltraps>

801068fb <vector29>:
.globl vector29
vector29:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $29
801068fd:	6a 1d                	push   $0x1d
  jmp alltraps
801068ff:	e9 70 f8 ff ff       	jmp    80106174 <alltraps>

80106904 <vector30>:
.globl vector30
vector30:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $30
80106906:	6a 1e                	push   $0x1e
  jmp alltraps
80106908:	e9 67 f8 ff ff       	jmp    80106174 <alltraps>

8010690d <vector31>:
.globl vector31
vector31:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $31
8010690f:	6a 1f                	push   $0x1f
  jmp alltraps
80106911:	e9 5e f8 ff ff       	jmp    80106174 <alltraps>

80106916 <vector32>:
.globl vector32
vector32:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $32
80106918:	6a 20                	push   $0x20
  jmp alltraps
8010691a:	e9 55 f8 ff ff       	jmp    80106174 <alltraps>

8010691f <vector33>:
.globl vector33
vector33:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $33
80106921:	6a 21                	push   $0x21
  jmp alltraps
80106923:	e9 4c f8 ff ff       	jmp    80106174 <alltraps>

80106928 <vector34>:
.globl vector34
vector34:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $34
8010692a:	6a 22                	push   $0x22
  jmp alltraps
8010692c:	e9 43 f8 ff ff       	jmp    80106174 <alltraps>

80106931 <vector35>:
.globl vector35
vector35:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $35
80106933:	6a 23                	push   $0x23
  jmp alltraps
80106935:	e9 3a f8 ff ff       	jmp    80106174 <alltraps>

8010693a <vector36>:
.globl vector36
vector36:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $36
8010693c:	6a 24                	push   $0x24
  jmp alltraps
8010693e:	e9 31 f8 ff ff       	jmp    80106174 <alltraps>

80106943 <vector37>:
.globl vector37
vector37:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $37
80106945:	6a 25                	push   $0x25
  jmp alltraps
80106947:	e9 28 f8 ff ff       	jmp    80106174 <alltraps>

8010694c <vector38>:
.globl vector38
vector38:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $38
8010694e:	6a 26                	push   $0x26
  jmp alltraps
80106950:	e9 1f f8 ff ff       	jmp    80106174 <alltraps>

80106955 <vector39>:
.globl vector39
vector39:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $39
80106957:	6a 27                	push   $0x27
  jmp alltraps
80106959:	e9 16 f8 ff ff       	jmp    80106174 <alltraps>

8010695e <vector40>:
.globl vector40
vector40:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $40
80106960:	6a 28                	push   $0x28
  jmp alltraps
80106962:	e9 0d f8 ff ff       	jmp    80106174 <alltraps>

80106967 <vector41>:
.globl vector41
vector41:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $41
80106969:	6a 29                	push   $0x29
  jmp alltraps
8010696b:	e9 04 f8 ff ff       	jmp    80106174 <alltraps>

80106970 <vector42>:
.globl vector42
vector42:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $42
80106972:	6a 2a                	push   $0x2a
  jmp alltraps
80106974:	e9 fb f7 ff ff       	jmp    80106174 <alltraps>

80106979 <vector43>:
.globl vector43
vector43:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $43
8010697b:	6a 2b                	push   $0x2b
  jmp alltraps
8010697d:	e9 f2 f7 ff ff       	jmp    80106174 <alltraps>

80106982 <vector44>:
.globl vector44
vector44:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $44
80106984:	6a 2c                	push   $0x2c
  jmp alltraps
80106986:	e9 e9 f7 ff ff       	jmp    80106174 <alltraps>

8010698b <vector45>:
.globl vector45
vector45:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $45
8010698d:	6a 2d                	push   $0x2d
  jmp alltraps
8010698f:	e9 e0 f7 ff ff       	jmp    80106174 <alltraps>

80106994 <vector46>:
.globl vector46
vector46:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $46
80106996:	6a 2e                	push   $0x2e
  jmp alltraps
80106998:	e9 d7 f7 ff ff       	jmp    80106174 <alltraps>

8010699d <vector47>:
.globl vector47
vector47:
  pushl $0
8010699d:	6a 00                	push   $0x0
  pushl $47
8010699f:	6a 2f                	push   $0x2f
  jmp alltraps
801069a1:	e9 ce f7 ff ff       	jmp    80106174 <alltraps>

801069a6 <vector48>:
.globl vector48
vector48:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $48
801069a8:	6a 30                	push   $0x30
  jmp alltraps
801069aa:	e9 c5 f7 ff ff       	jmp    80106174 <alltraps>

801069af <vector49>:
.globl vector49
vector49:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $49
801069b1:	6a 31                	push   $0x31
  jmp alltraps
801069b3:	e9 bc f7 ff ff       	jmp    80106174 <alltraps>

801069b8 <vector50>:
.globl vector50
vector50:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $50
801069ba:	6a 32                	push   $0x32
  jmp alltraps
801069bc:	e9 b3 f7 ff ff       	jmp    80106174 <alltraps>

801069c1 <vector51>:
.globl vector51
vector51:
  pushl $0
801069c1:	6a 00                	push   $0x0
  pushl $51
801069c3:	6a 33                	push   $0x33
  jmp alltraps
801069c5:	e9 aa f7 ff ff       	jmp    80106174 <alltraps>

801069ca <vector52>:
.globl vector52
vector52:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $52
801069cc:	6a 34                	push   $0x34
  jmp alltraps
801069ce:	e9 a1 f7 ff ff       	jmp    80106174 <alltraps>

801069d3 <vector53>:
.globl vector53
vector53:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $53
801069d5:	6a 35                	push   $0x35
  jmp alltraps
801069d7:	e9 98 f7 ff ff       	jmp    80106174 <alltraps>

801069dc <vector54>:
.globl vector54
vector54:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $54
801069de:	6a 36                	push   $0x36
  jmp alltraps
801069e0:	e9 8f f7 ff ff       	jmp    80106174 <alltraps>

801069e5 <vector55>:
.globl vector55
vector55:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $55
801069e7:	6a 37                	push   $0x37
  jmp alltraps
801069e9:	e9 86 f7 ff ff       	jmp    80106174 <alltraps>

801069ee <vector56>:
.globl vector56
vector56:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $56
801069f0:	6a 38                	push   $0x38
  jmp alltraps
801069f2:	e9 7d f7 ff ff       	jmp    80106174 <alltraps>

801069f7 <vector57>:
.globl vector57
vector57:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $57
801069f9:	6a 39                	push   $0x39
  jmp alltraps
801069fb:	e9 74 f7 ff ff       	jmp    80106174 <alltraps>

80106a00 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $58
80106a02:	6a 3a                	push   $0x3a
  jmp alltraps
80106a04:	e9 6b f7 ff ff       	jmp    80106174 <alltraps>

80106a09 <vector59>:
.globl vector59
vector59:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $59
80106a0b:	6a 3b                	push   $0x3b
  jmp alltraps
80106a0d:	e9 62 f7 ff ff       	jmp    80106174 <alltraps>

80106a12 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $60
80106a14:	6a 3c                	push   $0x3c
  jmp alltraps
80106a16:	e9 59 f7 ff ff       	jmp    80106174 <alltraps>

80106a1b <vector61>:
.globl vector61
vector61:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $61
80106a1d:	6a 3d                	push   $0x3d
  jmp alltraps
80106a1f:	e9 50 f7 ff ff       	jmp    80106174 <alltraps>

80106a24 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $62
80106a26:	6a 3e                	push   $0x3e
  jmp alltraps
80106a28:	e9 47 f7 ff ff       	jmp    80106174 <alltraps>

80106a2d <vector63>:
.globl vector63
vector63:
  pushl $0
80106a2d:	6a 00                	push   $0x0
  pushl $63
80106a2f:	6a 3f                	push   $0x3f
  jmp alltraps
80106a31:	e9 3e f7 ff ff       	jmp    80106174 <alltraps>

80106a36 <vector64>:
.globl vector64
vector64:
  pushl $0
80106a36:	6a 00                	push   $0x0
  pushl $64
80106a38:	6a 40                	push   $0x40
  jmp alltraps
80106a3a:	e9 35 f7 ff ff       	jmp    80106174 <alltraps>

80106a3f <vector65>:
.globl vector65
vector65:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $65
80106a41:	6a 41                	push   $0x41
  jmp alltraps
80106a43:	e9 2c f7 ff ff       	jmp    80106174 <alltraps>

80106a48 <vector66>:
.globl vector66
vector66:
  pushl $0
80106a48:	6a 00                	push   $0x0
  pushl $66
80106a4a:	6a 42                	push   $0x42
  jmp alltraps
80106a4c:	e9 23 f7 ff ff       	jmp    80106174 <alltraps>

80106a51 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a51:	6a 00                	push   $0x0
  pushl $67
80106a53:	6a 43                	push   $0x43
  jmp alltraps
80106a55:	e9 1a f7 ff ff       	jmp    80106174 <alltraps>

80106a5a <vector68>:
.globl vector68
vector68:
  pushl $0
80106a5a:	6a 00                	push   $0x0
  pushl $68
80106a5c:	6a 44                	push   $0x44
  jmp alltraps
80106a5e:	e9 11 f7 ff ff       	jmp    80106174 <alltraps>

80106a63 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $69
80106a65:	6a 45                	push   $0x45
  jmp alltraps
80106a67:	e9 08 f7 ff ff       	jmp    80106174 <alltraps>

80106a6c <vector70>:
.globl vector70
vector70:
  pushl $0
80106a6c:	6a 00                	push   $0x0
  pushl $70
80106a6e:	6a 46                	push   $0x46
  jmp alltraps
80106a70:	e9 ff f6 ff ff       	jmp    80106174 <alltraps>

80106a75 <vector71>:
.globl vector71
vector71:
  pushl $0
80106a75:	6a 00                	push   $0x0
  pushl $71
80106a77:	6a 47                	push   $0x47
  jmp alltraps
80106a79:	e9 f6 f6 ff ff       	jmp    80106174 <alltraps>

80106a7e <vector72>:
.globl vector72
vector72:
  pushl $0
80106a7e:	6a 00                	push   $0x0
  pushl $72
80106a80:	6a 48                	push   $0x48
  jmp alltraps
80106a82:	e9 ed f6 ff ff       	jmp    80106174 <alltraps>

80106a87 <vector73>:
.globl vector73
vector73:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $73
80106a89:	6a 49                	push   $0x49
  jmp alltraps
80106a8b:	e9 e4 f6 ff ff       	jmp    80106174 <alltraps>

80106a90 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a90:	6a 00                	push   $0x0
  pushl $74
80106a92:	6a 4a                	push   $0x4a
  jmp alltraps
80106a94:	e9 db f6 ff ff       	jmp    80106174 <alltraps>

80106a99 <vector75>:
.globl vector75
vector75:
  pushl $0
80106a99:	6a 00                	push   $0x0
  pushl $75
80106a9b:	6a 4b                	push   $0x4b
  jmp alltraps
80106a9d:	e9 d2 f6 ff ff       	jmp    80106174 <alltraps>

80106aa2 <vector76>:
.globl vector76
vector76:
  pushl $0
80106aa2:	6a 00                	push   $0x0
  pushl $76
80106aa4:	6a 4c                	push   $0x4c
  jmp alltraps
80106aa6:	e9 c9 f6 ff ff       	jmp    80106174 <alltraps>

80106aab <vector77>:
.globl vector77
vector77:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $77
80106aad:	6a 4d                	push   $0x4d
  jmp alltraps
80106aaf:	e9 c0 f6 ff ff       	jmp    80106174 <alltraps>

80106ab4 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $78
80106ab6:	6a 4e                	push   $0x4e
  jmp alltraps
80106ab8:	e9 b7 f6 ff ff       	jmp    80106174 <alltraps>

80106abd <vector79>:
.globl vector79
vector79:
  pushl $0
80106abd:	6a 00                	push   $0x0
  pushl $79
80106abf:	6a 4f                	push   $0x4f
  jmp alltraps
80106ac1:	e9 ae f6 ff ff       	jmp    80106174 <alltraps>

80106ac6 <vector80>:
.globl vector80
vector80:
  pushl $0
80106ac6:	6a 00                	push   $0x0
  pushl $80
80106ac8:	6a 50                	push   $0x50
  jmp alltraps
80106aca:	e9 a5 f6 ff ff       	jmp    80106174 <alltraps>

80106acf <vector81>:
.globl vector81
vector81:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $81
80106ad1:	6a 51                	push   $0x51
  jmp alltraps
80106ad3:	e9 9c f6 ff ff       	jmp    80106174 <alltraps>

80106ad8 <vector82>:
.globl vector82
vector82:
  pushl $0
80106ad8:	6a 00                	push   $0x0
  pushl $82
80106ada:	6a 52                	push   $0x52
  jmp alltraps
80106adc:	e9 93 f6 ff ff       	jmp    80106174 <alltraps>

80106ae1 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ae1:	6a 00                	push   $0x0
  pushl $83
80106ae3:	6a 53                	push   $0x53
  jmp alltraps
80106ae5:	e9 8a f6 ff ff       	jmp    80106174 <alltraps>

80106aea <vector84>:
.globl vector84
vector84:
  pushl $0
80106aea:	6a 00                	push   $0x0
  pushl $84
80106aec:	6a 54                	push   $0x54
  jmp alltraps
80106aee:	e9 81 f6 ff ff       	jmp    80106174 <alltraps>

80106af3 <vector85>:
.globl vector85
vector85:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $85
80106af5:	6a 55                	push   $0x55
  jmp alltraps
80106af7:	e9 78 f6 ff ff       	jmp    80106174 <alltraps>

80106afc <vector86>:
.globl vector86
vector86:
  pushl $0
80106afc:	6a 00                	push   $0x0
  pushl $86
80106afe:	6a 56                	push   $0x56
  jmp alltraps
80106b00:	e9 6f f6 ff ff       	jmp    80106174 <alltraps>

80106b05 <vector87>:
.globl vector87
vector87:
  pushl $0
80106b05:	6a 00                	push   $0x0
  pushl $87
80106b07:	6a 57                	push   $0x57
  jmp alltraps
80106b09:	e9 66 f6 ff ff       	jmp    80106174 <alltraps>

80106b0e <vector88>:
.globl vector88
vector88:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $88
80106b10:	6a 58                	push   $0x58
  jmp alltraps
80106b12:	e9 5d f6 ff ff       	jmp    80106174 <alltraps>

80106b17 <vector89>:
.globl vector89
vector89:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $89
80106b19:	6a 59                	push   $0x59
  jmp alltraps
80106b1b:	e9 54 f6 ff ff       	jmp    80106174 <alltraps>

80106b20 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b20:	6a 00                	push   $0x0
  pushl $90
80106b22:	6a 5a                	push   $0x5a
  jmp alltraps
80106b24:	e9 4b f6 ff ff       	jmp    80106174 <alltraps>

80106b29 <vector91>:
.globl vector91
vector91:
  pushl $0
80106b29:	6a 00                	push   $0x0
  pushl $91
80106b2b:	6a 5b                	push   $0x5b
  jmp alltraps
80106b2d:	e9 42 f6 ff ff       	jmp    80106174 <alltraps>

80106b32 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b32:	6a 00                	push   $0x0
  pushl $92
80106b34:	6a 5c                	push   $0x5c
  jmp alltraps
80106b36:	e9 39 f6 ff ff       	jmp    80106174 <alltraps>

80106b3b <vector93>:
.globl vector93
vector93:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $93
80106b3d:	6a 5d                	push   $0x5d
  jmp alltraps
80106b3f:	e9 30 f6 ff ff       	jmp    80106174 <alltraps>

80106b44 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b44:	6a 00                	push   $0x0
  pushl $94
80106b46:	6a 5e                	push   $0x5e
  jmp alltraps
80106b48:	e9 27 f6 ff ff       	jmp    80106174 <alltraps>

80106b4d <vector95>:
.globl vector95
vector95:
  pushl $0
80106b4d:	6a 00                	push   $0x0
  pushl $95
80106b4f:	6a 5f                	push   $0x5f
  jmp alltraps
80106b51:	e9 1e f6 ff ff       	jmp    80106174 <alltraps>

80106b56 <vector96>:
.globl vector96
vector96:
  pushl $0
80106b56:	6a 00                	push   $0x0
  pushl $96
80106b58:	6a 60                	push   $0x60
  jmp alltraps
80106b5a:	e9 15 f6 ff ff       	jmp    80106174 <alltraps>

80106b5f <vector97>:
.globl vector97
vector97:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $97
80106b61:	6a 61                	push   $0x61
  jmp alltraps
80106b63:	e9 0c f6 ff ff       	jmp    80106174 <alltraps>

80106b68 <vector98>:
.globl vector98
vector98:
  pushl $0
80106b68:	6a 00                	push   $0x0
  pushl $98
80106b6a:	6a 62                	push   $0x62
  jmp alltraps
80106b6c:	e9 03 f6 ff ff       	jmp    80106174 <alltraps>

80106b71 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b71:	6a 00                	push   $0x0
  pushl $99
80106b73:	6a 63                	push   $0x63
  jmp alltraps
80106b75:	e9 fa f5 ff ff       	jmp    80106174 <alltraps>

80106b7a <vector100>:
.globl vector100
vector100:
  pushl $0
80106b7a:	6a 00                	push   $0x0
  pushl $100
80106b7c:	6a 64                	push   $0x64
  jmp alltraps
80106b7e:	e9 f1 f5 ff ff       	jmp    80106174 <alltraps>

80106b83 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $101
80106b85:	6a 65                	push   $0x65
  jmp alltraps
80106b87:	e9 e8 f5 ff ff       	jmp    80106174 <alltraps>

80106b8c <vector102>:
.globl vector102
vector102:
  pushl $0
80106b8c:	6a 00                	push   $0x0
  pushl $102
80106b8e:	6a 66                	push   $0x66
  jmp alltraps
80106b90:	e9 df f5 ff ff       	jmp    80106174 <alltraps>

80106b95 <vector103>:
.globl vector103
vector103:
  pushl $0
80106b95:	6a 00                	push   $0x0
  pushl $103
80106b97:	6a 67                	push   $0x67
  jmp alltraps
80106b99:	e9 d6 f5 ff ff       	jmp    80106174 <alltraps>

80106b9e <vector104>:
.globl vector104
vector104:
  pushl $0
80106b9e:	6a 00                	push   $0x0
  pushl $104
80106ba0:	6a 68                	push   $0x68
  jmp alltraps
80106ba2:	e9 cd f5 ff ff       	jmp    80106174 <alltraps>

80106ba7 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $105
80106ba9:	6a 69                	push   $0x69
  jmp alltraps
80106bab:	e9 c4 f5 ff ff       	jmp    80106174 <alltraps>

80106bb0 <vector106>:
.globl vector106
vector106:
  pushl $0
80106bb0:	6a 00                	push   $0x0
  pushl $106
80106bb2:	6a 6a                	push   $0x6a
  jmp alltraps
80106bb4:	e9 bb f5 ff ff       	jmp    80106174 <alltraps>

80106bb9 <vector107>:
.globl vector107
vector107:
  pushl $0
80106bb9:	6a 00                	push   $0x0
  pushl $107
80106bbb:	6a 6b                	push   $0x6b
  jmp alltraps
80106bbd:	e9 b2 f5 ff ff       	jmp    80106174 <alltraps>

80106bc2 <vector108>:
.globl vector108
vector108:
  pushl $0
80106bc2:	6a 00                	push   $0x0
  pushl $108
80106bc4:	6a 6c                	push   $0x6c
  jmp alltraps
80106bc6:	e9 a9 f5 ff ff       	jmp    80106174 <alltraps>

80106bcb <vector109>:
.globl vector109
vector109:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $109
80106bcd:	6a 6d                	push   $0x6d
  jmp alltraps
80106bcf:	e9 a0 f5 ff ff       	jmp    80106174 <alltraps>

80106bd4 <vector110>:
.globl vector110
vector110:
  pushl $0
80106bd4:	6a 00                	push   $0x0
  pushl $110
80106bd6:	6a 6e                	push   $0x6e
  jmp alltraps
80106bd8:	e9 97 f5 ff ff       	jmp    80106174 <alltraps>

80106bdd <vector111>:
.globl vector111
vector111:
  pushl $0
80106bdd:	6a 00                	push   $0x0
  pushl $111
80106bdf:	6a 6f                	push   $0x6f
  jmp alltraps
80106be1:	e9 8e f5 ff ff       	jmp    80106174 <alltraps>

80106be6 <vector112>:
.globl vector112
vector112:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $112
80106be8:	6a 70                	push   $0x70
  jmp alltraps
80106bea:	e9 85 f5 ff ff       	jmp    80106174 <alltraps>

80106bef <vector113>:
.globl vector113
vector113:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $113
80106bf1:	6a 71                	push   $0x71
  jmp alltraps
80106bf3:	e9 7c f5 ff ff       	jmp    80106174 <alltraps>

80106bf8 <vector114>:
.globl vector114
vector114:
  pushl $0
80106bf8:	6a 00                	push   $0x0
  pushl $114
80106bfa:	6a 72                	push   $0x72
  jmp alltraps
80106bfc:	e9 73 f5 ff ff       	jmp    80106174 <alltraps>

80106c01 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c01:	6a 00                	push   $0x0
  pushl $115
80106c03:	6a 73                	push   $0x73
  jmp alltraps
80106c05:	e9 6a f5 ff ff       	jmp    80106174 <alltraps>

80106c0a <vector116>:
.globl vector116
vector116:
  pushl $0
80106c0a:	6a 00                	push   $0x0
  pushl $116
80106c0c:	6a 74                	push   $0x74
  jmp alltraps
80106c0e:	e9 61 f5 ff ff       	jmp    80106174 <alltraps>

80106c13 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $117
80106c15:	6a 75                	push   $0x75
  jmp alltraps
80106c17:	e9 58 f5 ff ff       	jmp    80106174 <alltraps>

80106c1c <vector118>:
.globl vector118
vector118:
  pushl $0
80106c1c:	6a 00                	push   $0x0
  pushl $118
80106c1e:	6a 76                	push   $0x76
  jmp alltraps
80106c20:	e9 4f f5 ff ff       	jmp    80106174 <alltraps>

80106c25 <vector119>:
.globl vector119
vector119:
  pushl $0
80106c25:	6a 00                	push   $0x0
  pushl $119
80106c27:	6a 77                	push   $0x77
  jmp alltraps
80106c29:	e9 46 f5 ff ff       	jmp    80106174 <alltraps>

80106c2e <vector120>:
.globl vector120
vector120:
  pushl $0
80106c2e:	6a 00                	push   $0x0
  pushl $120
80106c30:	6a 78                	push   $0x78
  jmp alltraps
80106c32:	e9 3d f5 ff ff       	jmp    80106174 <alltraps>

80106c37 <vector121>:
.globl vector121
vector121:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $121
80106c39:	6a 79                	push   $0x79
  jmp alltraps
80106c3b:	e9 34 f5 ff ff       	jmp    80106174 <alltraps>

80106c40 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c40:	6a 00                	push   $0x0
  pushl $122
80106c42:	6a 7a                	push   $0x7a
  jmp alltraps
80106c44:	e9 2b f5 ff ff       	jmp    80106174 <alltraps>

80106c49 <vector123>:
.globl vector123
vector123:
  pushl $0
80106c49:	6a 00                	push   $0x0
  pushl $123
80106c4b:	6a 7b                	push   $0x7b
  jmp alltraps
80106c4d:	e9 22 f5 ff ff       	jmp    80106174 <alltraps>

80106c52 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c52:	6a 00                	push   $0x0
  pushl $124
80106c54:	6a 7c                	push   $0x7c
  jmp alltraps
80106c56:	e9 19 f5 ff ff       	jmp    80106174 <alltraps>

80106c5b <vector125>:
.globl vector125
vector125:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $125
80106c5d:	6a 7d                	push   $0x7d
  jmp alltraps
80106c5f:	e9 10 f5 ff ff       	jmp    80106174 <alltraps>

80106c64 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c64:	6a 00                	push   $0x0
  pushl $126
80106c66:	6a 7e                	push   $0x7e
  jmp alltraps
80106c68:	e9 07 f5 ff ff       	jmp    80106174 <alltraps>

80106c6d <vector127>:
.globl vector127
vector127:
  pushl $0
80106c6d:	6a 00                	push   $0x0
  pushl $127
80106c6f:	6a 7f                	push   $0x7f
  jmp alltraps
80106c71:	e9 fe f4 ff ff       	jmp    80106174 <alltraps>

80106c76 <vector128>:
.globl vector128
vector128:
  pushl $0
80106c76:	6a 00                	push   $0x0
  pushl $128
80106c78:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c7d:	e9 f2 f4 ff ff       	jmp    80106174 <alltraps>

80106c82 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $129
80106c84:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c89:	e9 e6 f4 ff ff       	jmp    80106174 <alltraps>

80106c8e <vector130>:
.globl vector130
vector130:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $130
80106c90:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c95:	e9 da f4 ff ff       	jmp    80106174 <alltraps>

80106c9a <vector131>:
.globl vector131
vector131:
  pushl $0
80106c9a:	6a 00                	push   $0x0
  pushl $131
80106c9c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ca1:	e9 ce f4 ff ff       	jmp    80106174 <alltraps>

80106ca6 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ca6:	6a 00                	push   $0x0
  pushl $132
80106ca8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106cad:	e9 c2 f4 ff ff       	jmp    80106174 <alltraps>

80106cb2 <vector133>:
.globl vector133
vector133:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $133
80106cb4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106cb9:	e9 b6 f4 ff ff       	jmp    80106174 <alltraps>

80106cbe <vector134>:
.globl vector134
vector134:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $134
80106cc0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106cc5:	e9 aa f4 ff ff       	jmp    80106174 <alltraps>

80106cca <vector135>:
.globl vector135
vector135:
  pushl $0
80106cca:	6a 00                	push   $0x0
  pushl $135
80106ccc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106cd1:	e9 9e f4 ff ff       	jmp    80106174 <alltraps>

80106cd6 <vector136>:
.globl vector136
vector136:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $136
80106cd8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106cdd:	e9 92 f4 ff ff       	jmp    80106174 <alltraps>

80106ce2 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $137
80106ce4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ce9:	e9 86 f4 ff ff       	jmp    80106174 <alltraps>

80106cee <vector138>:
.globl vector138
vector138:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $138
80106cf0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106cf5:	e9 7a f4 ff ff       	jmp    80106174 <alltraps>

80106cfa <vector139>:
.globl vector139
vector139:
  pushl $0
80106cfa:	6a 00                	push   $0x0
  pushl $139
80106cfc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d01:	e9 6e f4 ff ff       	jmp    80106174 <alltraps>

80106d06 <vector140>:
.globl vector140
vector140:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $140
80106d08:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d0d:	e9 62 f4 ff ff       	jmp    80106174 <alltraps>

80106d12 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $141
80106d14:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d19:	e9 56 f4 ff ff       	jmp    80106174 <alltraps>

80106d1e <vector142>:
.globl vector142
vector142:
  pushl $0
80106d1e:	6a 00                	push   $0x0
  pushl $142
80106d20:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d25:	e9 4a f4 ff ff       	jmp    80106174 <alltraps>

80106d2a <vector143>:
.globl vector143
vector143:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $143
80106d2c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d31:	e9 3e f4 ff ff       	jmp    80106174 <alltraps>

80106d36 <vector144>:
.globl vector144
vector144:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $144
80106d38:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d3d:	e9 32 f4 ff ff       	jmp    80106174 <alltraps>

80106d42 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $145
80106d44:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d49:	e9 26 f4 ff ff       	jmp    80106174 <alltraps>

80106d4e <vector146>:
.globl vector146
vector146:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $146
80106d50:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d55:	e9 1a f4 ff ff       	jmp    80106174 <alltraps>

80106d5a <vector147>:
.globl vector147
vector147:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $147
80106d5c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d61:	e9 0e f4 ff ff       	jmp    80106174 <alltraps>

80106d66 <vector148>:
.globl vector148
vector148:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $148
80106d68:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d6d:	e9 02 f4 ff ff       	jmp    80106174 <alltraps>

80106d72 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $149
80106d74:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d79:	e9 f6 f3 ff ff       	jmp    80106174 <alltraps>

80106d7e <vector150>:
.globl vector150
vector150:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $150
80106d80:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d85:	e9 ea f3 ff ff       	jmp    80106174 <alltraps>

80106d8a <vector151>:
.globl vector151
vector151:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $151
80106d8c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d91:	e9 de f3 ff ff       	jmp    80106174 <alltraps>

80106d96 <vector152>:
.globl vector152
vector152:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $152
80106d98:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d9d:	e9 d2 f3 ff ff       	jmp    80106174 <alltraps>

80106da2 <vector153>:
.globl vector153
vector153:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $153
80106da4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106da9:	e9 c6 f3 ff ff       	jmp    80106174 <alltraps>

80106dae <vector154>:
.globl vector154
vector154:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $154
80106db0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106db5:	e9 ba f3 ff ff       	jmp    80106174 <alltraps>

80106dba <vector155>:
.globl vector155
vector155:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $155
80106dbc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106dc1:	e9 ae f3 ff ff       	jmp    80106174 <alltraps>

80106dc6 <vector156>:
.globl vector156
vector156:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $156
80106dc8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106dcd:	e9 a2 f3 ff ff       	jmp    80106174 <alltraps>

80106dd2 <vector157>:
.globl vector157
vector157:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $157
80106dd4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106dd9:	e9 96 f3 ff ff       	jmp    80106174 <alltraps>

80106dde <vector158>:
.globl vector158
vector158:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $158
80106de0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106de5:	e9 8a f3 ff ff       	jmp    80106174 <alltraps>

80106dea <vector159>:
.globl vector159
vector159:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $159
80106dec:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106df1:	e9 7e f3 ff ff       	jmp    80106174 <alltraps>

80106df6 <vector160>:
.globl vector160
vector160:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $160
80106df8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106dfd:	e9 72 f3 ff ff       	jmp    80106174 <alltraps>

80106e02 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $161
80106e04:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e09:	e9 66 f3 ff ff       	jmp    80106174 <alltraps>

80106e0e <vector162>:
.globl vector162
vector162:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $162
80106e10:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e15:	e9 5a f3 ff ff       	jmp    80106174 <alltraps>

80106e1a <vector163>:
.globl vector163
vector163:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $163
80106e1c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e21:	e9 4e f3 ff ff       	jmp    80106174 <alltraps>

80106e26 <vector164>:
.globl vector164
vector164:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $164
80106e28:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e2d:	e9 42 f3 ff ff       	jmp    80106174 <alltraps>

80106e32 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $165
80106e34:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e39:	e9 36 f3 ff ff       	jmp    80106174 <alltraps>

80106e3e <vector166>:
.globl vector166
vector166:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $166
80106e40:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e45:	e9 2a f3 ff ff       	jmp    80106174 <alltraps>

80106e4a <vector167>:
.globl vector167
vector167:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $167
80106e4c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e51:	e9 1e f3 ff ff       	jmp    80106174 <alltraps>

80106e56 <vector168>:
.globl vector168
vector168:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $168
80106e58:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e5d:	e9 12 f3 ff ff       	jmp    80106174 <alltraps>

80106e62 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $169
80106e64:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e69:	e9 06 f3 ff ff       	jmp    80106174 <alltraps>

80106e6e <vector170>:
.globl vector170
vector170:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $170
80106e70:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e75:	e9 fa f2 ff ff       	jmp    80106174 <alltraps>

80106e7a <vector171>:
.globl vector171
vector171:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $171
80106e7c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e81:	e9 ee f2 ff ff       	jmp    80106174 <alltraps>

80106e86 <vector172>:
.globl vector172
vector172:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $172
80106e88:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e8d:	e9 e2 f2 ff ff       	jmp    80106174 <alltraps>

80106e92 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $173
80106e94:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e99:	e9 d6 f2 ff ff       	jmp    80106174 <alltraps>

80106e9e <vector174>:
.globl vector174
vector174:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $174
80106ea0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ea5:	e9 ca f2 ff ff       	jmp    80106174 <alltraps>

80106eaa <vector175>:
.globl vector175
vector175:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $175
80106eac:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106eb1:	e9 be f2 ff ff       	jmp    80106174 <alltraps>

80106eb6 <vector176>:
.globl vector176
vector176:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $176
80106eb8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ebd:	e9 b2 f2 ff ff       	jmp    80106174 <alltraps>

80106ec2 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $177
80106ec4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106ec9:	e9 a6 f2 ff ff       	jmp    80106174 <alltraps>

80106ece <vector178>:
.globl vector178
vector178:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $178
80106ed0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ed5:	e9 9a f2 ff ff       	jmp    80106174 <alltraps>

80106eda <vector179>:
.globl vector179
vector179:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $179
80106edc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ee1:	e9 8e f2 ff ff       	jmp    80106174 <alltraps>

80106ee6 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $180
80106ee8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106eed:	e9 82 f2 ff ff       	jmp    80106174 <alltraps>

80106ef2 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $181
80106ef4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106ef9:	e9 76 f2 ff ff       	jmp    80106174 <alltraps>

80106efe <vector182>:
.globl vector182
vector182:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $182
80106f00:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f05:	e9 6a f2 ff ff       	jmp    80106174 <alltraps>

80106f0a <vector183>:
.globl vector183
vector183:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $183
80106f0c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f11:	e9 5e f2 ff ff       	jmp    80106174 <alltraps>

80106f16 <vector184>:
.globl vector184
vector184:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $184
80106f18:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f1d:	e9 52 f2 ff ff       	jmp    80106174 <alltraps>

80106f22 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $185
80106f24:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f29:	e9 46 f2 ff ff       	jmp    80106174 <alltraps>

80106f2e <vector186>:
.globl vector186
vector186:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $186
80106f30:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f35:	e9 3a f2 ff ff       	jmp    80106174 <alltraps>

80106f3a <vector187>:
.globl vector187
vector187:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $187
80106f3c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f41:	e9 2e f2 ff ff       	jmp    80106174 <alltraps>

80106f46 <vector188>:
.globl vector188
vector188:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $188
80106f48:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f4d:	e9 22 f2 ff ff       	jmp    80106174 <alltraps>

80106f52 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $189
80106f54:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f59:	e9 16 f2 ff ff       	jmp    80106174 <alltraps>

80106f5e <vector190>:
.globl vector190
vector190:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $190
80106f60:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f65:	e9 0a f2 ff ff       	jmp    80106174 <alltraps>

80106f6a <vector191>:
.globl vector191
vector191:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $191
80106f6c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f71:	e9 fe f1 ff ff       	jmp    80106174 <alltraps>

80106f76 <vector192>:
.globl vector192
vector192:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $192
80106f78:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f7d:	e9 f2 f1 ff ff       	jmp    80106174 <alltraps>

80106f82 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $193
80106f84:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f89:	e9 e6 f1 ff ff       	jmp    80106174 <alltraps>

80106f8e <vector194>:
.globl vector194
vector194:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $194
80106f90:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f95:	e9 da f1 ff ff       	jmp    80106174 <alltraps>

80106f9a <vector195>:
.globl vector195
vector195:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $195
80106f9c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106fa1:	e9 ce f1 ff ff       	jmp    80106174 <alltraps>

80106fa6 <vector196>:
.globl vector196
vector196:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $196
80106fa8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106fad:	e9 c2 f1 ff ff       	jmp    80106174 <alltraps>

80106fb2 <vector197>:
.globl vector197
vector197:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $197
80106fb4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106fb9:	e9 b6 f1 ff ff       	jmp    80106174 <alltraps>

80106fbe <vector198>:
.globl vector198
vector198:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $198
80106fc0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106fc5:	e9 aa f1 ff ff       	jmp    80106174 <alltraps>

80106fca <vector199>:
.globl vector199
vector199:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $199
80106fcc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106fd1:	e9 9e f1 ff ff       	jmp    80106174 <alltraps>

80106fd6 <vector200>:
.globl vector200
vector200:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $200
80106fd8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106fdd:	e9 92 f1 ff ff       	jmp    80106174 <alltraps>

80106fe2 <vector201>:
.globl vector201
vector201:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $201
80106fe4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106fe9:	e9 86 f1 ff ff       	jmp    80106174 <alltraps>

80106fee <vector202>:
.globl vector202
vector202:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $202
80106ff0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106ff5:	e9 7a f1 ff ff       	jmp    80106174 <alltraps>

80106ffa <vector203>:
.globl vector203
vector203:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $203
80106ffc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107001:	e9 6e f1 ff ff       	jmp    80106174 <alltraps>

80107006 <vector204>:
.globl vector204
vector204:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $204
80107008:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010700d:	e9 62 f1 ff ff       	jmp    80106174 <alltraps>

80107012 <vector205>:
.globl vector205
vector205:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $205
80107014:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107019:	e9 56 f1 ff ff       	jmp    80106174 <alltraps>

8010701e <vector206>:
.globl vector206
vector206:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $206
80107020:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107025:	e9 4a f1 ff ff       	jmp    80106174 <alltraps>

8010702a <vector207>:
.globl vector207
vector207:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $207
8010702c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107031:	e9 3e f1 ff ff       	jmp    80106174 <alltraps>

80107036 <vector208>:
.globl vector208
vector208:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $208
80107038:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010703d:	e9 32 f1 ff ff       	jmp    80106174 <alltraps>

80107042 <vector209>:
.globl vector209
vector209:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $209
80107044:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107049:	e9 26 f1 ff ff       	jmp    80106174 <alltraps>

8010704e <vector210>:
.globl vector210
vector210:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $210
80107050:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107055:	e9 1a f1 ff ff       	jmp    80106174 <alltraps>

8010705a <vector211>:
.globl vector211
vector211:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $211
8010705c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107061:	e9 0e f1 ff ff       	jmp    80106174 <alltraps>

80107066 <vector212>:
.globl vector212
vector212:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $212
80107068:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010706d:	e9 02 f1 ff ff       	jmp    80106174 <alltraps>

80107072 <vector213>:
.globl vector213
vector213:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $213
80107074:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107079:	e9 f6 f0 ff ff       	jmp    80106174 <alltraps>

8010707e <vector214>:
.globl vector214
vector214:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $214
80107080:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107085:	e9 ea f0 ff ff       	jmp    80106174 <alltraps>

8010708a <vector215>:
.globl vector215
vector215:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $215
8010708c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107091:	e9 de f0 ff ff       	jmp    80106174 <alltraps>

80107096 <vector216>:
.globl vector216
vector216:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $216
80107098:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010709d:	e9 d2 f0 ff ff       	jmp    80106174 <alltraps>

801070a2 <vector217>:
.globl vector217
vector217:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $217
801070a4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801070a9:	e9 c6 f0 ff ff       	jmp    80106174 <alltraps>

801070ae <vector218>:
.globl vector218
vector218:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $218
801070b0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801070b5:	e9 ba f0 ff ff       	jmp    80106174 <alltraps>

801070ba <vector219>:
.globl vector219
vector219:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $219
801070bc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801070c1:	e9 ae f0 ff ff       	jmp    80106174 <alltraps>

801070c6 <vector220>:
.globl vector220
vector220:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $220
801070c8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801070cd:	e9 a2 f0 ff ff       	jmp    80106174 <alltraps>

801070d2 <vector221>:
.globl vector221
vector221:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $221
801070d4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801070d9:	e9 96 f0 ff ff       	jmp    80106174 <alltraps>

801070de <vector222>:
.globl vector222
vector222:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $222
801070e0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801070e5:	e9 8a f0 ff ff       	jmp    80106174 <alltraps>

801070ea <vector223>:
.globl vector223
vector223:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $223
801070ec:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801070f1:	e9 7e f0 ff ff       	jmp    80106174 <alltraps>

801070f6 <vector224>:
.globl vector224
vector224:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $224
801070f8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070fd:	e9 72 f0 ff ff       	jmp    80106174 <alltraps>

80107102 <vector225>:
.globl vector225
vector225:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $225
80107104:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107109:	e9 66 f0 ff ff       	jmp    80106174 <alltraps>

8010710e <vector226>:
.globl vector226
vector226:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $226
80107110:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107115:	e9 5a f0 ff ff       	jmp    80106174 <alltraps>

8010711a <vector227>:
.globl vector227
vector227:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $227
8010711c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107121:	e9 4e f0 ff ff       	jmp    80106174 <alltraps>

80107126 <vector228>:
.globl vector228
vector228:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $228
80107128:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010712d:	e9 42 f0 ff ff       	jmp    80106174 <alltraps>

80107132 <vector229>:
.globl vector229
vector229:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $229
80107134:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107139:	e9 36 f0 ff ff       	jmp    80106174 <alltraps>

8010713e <vector230>:
.globl vector230
vector230:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $230
80107140:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107145:	e9 2a f0 ff ff       	jmp    80106174 <alltraps>

8010714a <vector231>:
.globl vector231
vector231:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $231
8010714c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107151:	e9 1e f0 ff ff       	jmp    80106174 <alltraps>

80107156 <vector232>:
.globl vector232
vector232:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $232
80107158:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010715d:	e9 12 f0 ff ff       	jmp    80106174 <alltraps>

80107162 <vector233>:
.globl vector233
vector233:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $233
80107164:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107169:	e9 06 f0 ff ff       	jmp    80106174 <alltraps>

8010716e <vector234>:
.globl vector234
vector234:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $234
80107170:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107175:	e9 fa ef ff ff       	jmp    80106174 <alltraps>

8010717a <vector235>:
.globl vector235
vector235:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $235
8010717c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107181:	e9 ee ef ff ff       	jmp    80106174 <alltraps>

80107186 <vector236>:
.globl vector236
vector236:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $236
80107188:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010718d:	e9 e2 ef ff ff       	jmp    80106174 <alltraps>

80107192 <vector237>:
.globl vector237
vector237:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $237
80107194:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107199:	e9 d6 ef ff ff       	jmp    80106174 <alltraps>

8010719e <vector238>:
.globl vector238
vector238:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $238
801071a0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801071a5:	e9 ca ef ff ff       	jmp    80106174 <alltraps>

801071aa <vector239>:
.globl vector239
vector239:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $239
801071ac:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801071b1:	e9 be ef ff ff       	jmp    80106174 <alltraps>

801071b6 <vector240>:
.globl vector240
vector240:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $240
801071b8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801071bd:	e9 b2 ef ff ff       	jmp    80106174 <alltraps>

801071c2 <vector241>:
.globl vector241
vector241:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $241
801071c4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801071c9:	e9 a6 ef ff ff       	jmp    80106174 <alltraps>

801071ce <vector242>:
.globl vector242
vector242:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $242
801071d0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801071d5:	e9 9a ef ff ff       	jmp    80106174 <alltraps>

801071da <vector243>:
.globl vector243
vector243:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $243
801071dc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801071e1:	e9 8e ef ff ff       	jmp    80106174 <alltraps>

801071e6 <vector244>:
.globl vector244
vector244:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $244
801071e8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801071ed:	e9 82 ef ff ff       	jmp    80106174 <alltraps>

801071f2 <vector245>:
.globl vector245
vector245:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $245
801071f4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071f9:	e9 76 ef ff ff       	jmp    80106174 <alltraps>

801071fe <vector246>:
.globl vector246
vector246:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $246
80107200:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107205:	e9 6a ef ff ff       	jmp    80106174 <alltraps>

8010720a <vector247>:
.globl vector247
vector247:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $247
8010720c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107211:	e9 5e ef ff ff       	jmp    80106174 <alltraps>

80107216 <vector248>:
.globl vector248
vector248:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $248
80107218:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010721d:	e9 52 ef ff ff       	jmp    80106174 <alltraps>

80107222 <vector249>:
.globl vector249
vector249:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $249
80107224:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107229:	e9 46 ef ff ff       	jmp    80106174 <alltraps>

8010722e <vector250>:
.globl vector250
vector250:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $250
80107230:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107235:	e9 3a ef ff ff       	jmp    80106174 <alltraps>

8010723a <vector251>:
.globl vector251
vector251:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $251
8010723c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107241:	e9 2e ef ff ff       	jmp    80106174 <alltraps>

80107246 <vector252>:
.globl vector252
vector252:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $252
80107248:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010724d:	e9 22 ef ff ff       	jmp    80106174 <alltraps>

80107252 <vector253>:
.globl vector253
vector253:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $253
80107254:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107259:	e9 16 ef ff ff       	jmp    80106174 <alltraps>

8010725e <vector254>:
.globl vector254
vector254:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $254
80107260:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107265:	e9 0a ef ff ff       	jmp    80106174 <alltraps>

8010726a <vector255>:
.globl vector255
vector255:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $255
8010726c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107271:	e9 fe ee ff ff       	jmp    80106174 <alltraps>
	...

80107278 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107278:	55                   	push   %ebp
80107279:	89 e5                	mov    %esp,%ebp
8010727b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010727e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107281:	83 e8 01             	sub    $0x1,%eax
80107284:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107288:	8b 45 08             	mov    0x8(%ebp),%eax
8010728b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010728f:	8b 45 08             	mov    0x8(%ebp),%eax
80107292:	c1 e8 10             	shr    $0x10,%eax
80107295:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107299:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010729c:	0f 01 10             	lgdtl  (%eax)
}
8010729f:	c9                   	leave  
801072a0:	c3                   	ret    

801072a1 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801072a1:	55                   	push   %ebp
801072a2:	89 e5                	mov    %esp,%ebp
801072a4:	83 ec 04             	sub    $0x4,%esp
801072a7:	8b 45 08             	mov    0x8(%ebp),%eax
801072aa:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801072ae:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801072b2:	0f 00 d8             	ltr    %ax
}
801072b5:	c9                   	leave  
801072b6:	c3                   	ret    

801072b7 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801072b7:	55                   	push   %ebp
801072b8:	89 e5                	mov    %esp,%ebp
801072ba:	83 ec 04             	sub    $0x4,%esp
801072bd:	8b 45 08             	mov    0x8(%ebp),%eax
801072c0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801072c4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801072c8:	8e e8                	mov    %eax,%gs
}
801072ca:	c9                   	leave  
801072cb:	c3                   	ret    

801072cc <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801072cc:	55                   	push   %ebp
801072cd:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072cf:	8b 45 08             	mov    0x8(%ebp),%eax
801072d2:	0f 22 d8             	mov    %eax,%cr3
}
801072d5:	5d                   	pop    %ebp
801072d6:	c3                   	ret    

801072d7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801072d7:	55                   	push   %ebp
801072d8:	89 e5                	mov    %esp,%ebp
801072da:	8b 45 08             	mov    0x8(%ebp),%eax
801072dd:	05 00 00 00 80       	add    $0x80000000,%eax
801072e2:	5d                   	pop    %ebp
801072e3:	c3                   	ret    

801072e4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801072e4:	55                   	push   %ebp
801072e5:	89 e5                	mov    %esp,%ebp
801072e7:	8b 45 08             	mov    0x8(%ebp),%eax
801072ea:	05 00 00 00 80       	add    $0x80000000,%eax
801072ef:	5d                   	pop    %ebp
801072f0:	c3                   	ret    

801072f1 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801072f1:	55                   	push   %ebp
801072f2:	89 e5                	mov    %esp,%ebp
801072f4:	53                   	push   %ebx
801072f5:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801072f8:	e8 cc bb ff ff       	call   80102ec9 <cpunum>
801072fd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107303:	05 20 f9 10 80       	add    $0x8010f920,%eax
80107308:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010730b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730e:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107317:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010731d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107320:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107327:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010732b:	83 e2 f0             	and    $0xfffffff0,%edx
8010732e:	83 ca 0a             	or     $0xa,%edx
80107331:	88 50 7d             	mov    %dl,0x7d(%eax)
80107334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107337:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010733b:	83 ca 10             	or     $0x10,%edx
8010733e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107344:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107348:	83 e2 9f             	and    $0xffffff9f,%edx
8010734b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010734e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107351:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107355:	83 ca 80             	or     $0xffffff80,%edx
80107358:	88 50 7d             	mov    %dl,0x7d(%eax)
8010735b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010735e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107362:	83 ca 0f             	or     $0xf,%edx
80107365:	88 50 7e             	mov    %dl,0x7e(%eax)
80107368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010736b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010736f:	83 e2 ef             	and    $0xffffffef,%edx
80107372:	88 50 7e             	mov    %dl,0x7e(%eax)
80107375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107378:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010737c:	83 e2 df             	and    $0xffffffdf,%edx
8010737f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107385:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107389:	83 ca 40             	or     $0x40,%edx
8010738c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010738f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107392:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107396:	83 ca 80             	or     $0xffffff80,%edx
80107399:	88 50 7e             	mov    %dl,0x7e(%eax)
8010739c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739f:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801073a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a6:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801073ad:	ff ff 
801073af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b2:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801073b9:	00 00 
801073bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073be:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801073c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801073cf:	83 e2 f0             	and    $0xfffffff0,%edx
801073d2:	83 ca 02             	or     $0x2,%edx
801073d5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801073db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073de:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801073e5:	83 ca 10             	or     $0x10,%edx
801073e8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801073ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801073f8:	83 e2 9f             	and    $0xffffff9f,%edx
801073fb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107404:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010740b:	83 ca 80             	or     $0xffffff80,%edx
8010740e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107414:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107417:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010741e:	83 ca 0f             	or     $0xf,%edx
80107421:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107427:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107431:	83 e2 ef             	and    $0xffffffef,%edx
80107434:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010743a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010743d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107444:	83 e2 df             	and    $0xffffffdf,%edx
80107447:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010744d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107450:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107457:	83 ca 40             	or     $0x40,%edx
8010745a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107463:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010746a:	83 ca 80             	or     $0xffffff80,%edx
8010746d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107476:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010747d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107480:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107487:	ff ff 
80107489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748c:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107493:	00 00 
80107495:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107498:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010749f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801074a9:	83 e2 f0             	and    $0xfffffff0,%edx
801074ac:	83 ca 0a             	or     $0xa,%edx
801074af:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801074b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801074bf:	83 ca 10             	or     $0x10,%edx
801074c2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801074c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074cb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801074d2:	83 ca 60             	or     $0x60,%edx
801074d5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801074db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074de:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801074e5:	83 ca 80             	or     $0xffffff80,%edx
801074e8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801074ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801074f8:	83 ca 0f             	or     $0xf,%edx
801074fb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107504:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010750b:	83 e2 ef             	and    $0xffffffef,%edx
8010750e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107514:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107517:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010751e:	83 e2 df             	and    $0xffffffdf,%edx
80107521:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107531:	83 ca 40             	or     $0x40,%edx
80107534:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010753a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107544:	83 ca 80             	or     $0xffffff80,%edx
80107547:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010754d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107550:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010755a:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107561:	ff ff 
80107563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107566:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010756d:	00 00 
8010756f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107572:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107583:	83 e2 f0             	and    $0xfffffff0,%edx
80107586:	83 ca 02             	or     $0x2,%edx
80107589:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010758f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107592:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107599:	83 ca 10             	or     $0x10,%edx
8010759c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801075a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801075ac:	83 ca 60             	or     $0x60,%edx
801075af:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801075b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801075bf:	83 ca 80             	or     $0xffffff80,%edx
801075c2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801075c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075cb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801075d2:	83 ca 0f             	or     $0xf,%edx
801075d5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801075db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075de:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801075e5:	83 e2 ef             	and    $0xffffffef,%edx
801075e8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801075ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801075f8:	83 e2 df             	and    $0xffffffdf,%edx
801075fb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107604:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010760b:	83 ca 40             	or     $0x40,%edx
8010760e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107617:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010761e:	83 ca 80             	or     $0xffffff80,%edx
80107621:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107627:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010762a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107634:	05 b4 00 00 00       	add    $0xb4,%eax
80107639:	89 c3                	mov    %eax,%ebx
8010763b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763e:	05 b4 00 00 00       	add    $0xb4,%eax
80107643:	c1 e8 10             	shr    $0x10,%eax
80107646:	89 c1                	mov    %eax,%ecx
80107648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764b:	05 b4 00 00 00       	add    $0xb4,%eax
80107650:	c1 e8 18             	shr    $0x18,%eax
80107653:	89 c2                	mov    %eax,%edx
80107655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107658:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010765f:	00 00 
80107661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107664:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010766b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010766e:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107677:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010767e:	83 e1 f0             	and    $0xfffffff0,%ecx
80107681:	83 c9 02             	or     $0x2,%ecx
80107684:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010768a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107694:	83 c9 10             	or     $0x10,%ecx
80107697:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010769d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a0:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801076a7:	83 e1 9f             	and    $0xffffff9f,%ecx
801076aa:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801076b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b3:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801076ba:	83 c9 80             	or     $0xffffff80,%ecx
801076bd:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801076c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c6:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801076cd:	83 e1 f0             	and    $0xfffffff0,%ecx
801076d0:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801076d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d9:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801076e0:	83 e1 ef             	and    $0xffffffef,%ecx
801076e3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801076e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ec:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801076f3:	83 e1 df             	and    $0xffffffdf,%ecx
801076f6:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801076fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ff:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107706:	83 c9 40             	or     $0x40,%ecx
80107709:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010770f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107712:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107719:	83 c9 80             	or     $0xffffff80,%ecx
8010771c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107725:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010772b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772e:	83 c0 70             	add    $0x70,%eax
80107731:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107738:	00 
80107739:	89 04 24             	mov    %eax,(%esp)
8010773c:	e8 37 fb ff ff       	call   80107278 <lgdt>
  loadgs(SEG_KCPU << 3);
80107741:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107748:	e8 6a fb ff ff       	call   801072b7 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
8010774d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107750:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107756:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010775d:	00 00 00 00 
}
80107761:	83 c4 24             	add    $0x24,%esp
80107764:	5b                   	pop    %ebx
80107765:	5d                   	pop    %ebp
80107766:	c3                   	ret    

80107767 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107767:	55                   	push   %ebp
80107768:	89 e5                	mov    %esp,%ebp
8010776a:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010776d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107770:	c1 e8 16             	shr    $0x16,%eax
80107773:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010777a:	8b 45 08             	mov    0x8(%ebp),%eax
8010777d:	01 d0                	add    %edx,%eax
8010777f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107782:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107785:	8b 00                	mov    (%eax),%eax
80107787:	83 e0 01             	and    $0x1,%eax
8010778a:	85 c0                	test   %eax,%eax
8010778c:	74 17                	je     801077a5 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010778e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107791:	8b 00                	mov    (%eax),%eax
80107793:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107798:	89 04 24             	mov    %eax,(%esp)
8010779b:	e8 44 fb ff ff       	call   801072e4 <p2v>
801077a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077a3:	eb 4b                	jmp    801077f0 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801077a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801077a9:	74 0e                	je     801077b9 <walkpgdir+0x52>
801077ab:	e8 87 b3 ff ff       	call   80102b37 <kalloc>
801077b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077b7:	75 07                	jne    801077c0 <walkpgdir+0x59>
      return 0;
801077b9:	b8 00 00 00 00       	mov    $0x0,%eax
801077be:	eb 47                	jmp    80107807 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801077c0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801077c7:	00 
801077c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801077cf:	00 
801077d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d3:	89 04 24             	mov    %eax,(%esp)
801077d6:	e8 b7 d5 ff ff       	call   80104d92 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801077db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077de:	89 04 24             	mov    %eax,(%esp)
801077e1:	e8 f1 fa ff ff       	call   801072d7 <v2p>
801077e6:	89 c2                	mov    %eax,%edx
801077e8:	83 ca 07             	or     $0x7,%edx
801077eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077ee:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801077f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801077f3:	c1 e8 0c             	shr    $0xc,%eax
801077f6:	25 ff 03 00 00       	and    $0x3ff,%eax
801077fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107805:	01 d0                	add    %edx,%eax
}
80107807:	c9                   	leave  
80107808:	c3                   	ret    

80107809 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107809:	55                   	push   %ebp
8010780a:	89 e5                	mov    %esp,%ebp
8010780c:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010780f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107812:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107817:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010781a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010781d:	8b 45 10             	mov    0x10(%ebp),%eax
80107820:	01 d0                	add    %edx,%eax
80107822:	83 e8 01             	sub    $0x1,%eax
80107825:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010782a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010782d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107834:	00 
80107835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107838:	89 44 24 04          	mov    %eax,0x4(%esp)
8010783c:	8b 45 08             	mov    0x8(%ebp),%eax
8010783f:	89 04 24             	mov    %eax,(%esp)
80107842:	e8 20 ff ff ff       	call   80107767 <walkpgdir>
80107847:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010784a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010784e:	75 07                	jne    80107857 <mappages+0x4e>
      return -1;
80107850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107855:	eb 46                	jmp    8010789d <mappages+0x94>
    if(*pte & PTE_P)
80107857:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010785a:	8b 00                	mov    (%eax),%eax
8010785c:	83 e0 01             	and    $0x1,%eax
8010785f:	85 c0                	test   %eax,%eax
80107861:	74 0c                	je     8010786f <mappages+0x66>
      panic("remap");
80107863:	c7 04 24 90 86 10 80 	movl   $0x80108690,(%esp)
8010786a:	e8 d7 8c ff ff       	call   80100546 <panic>
    *pte = pa | perm | PTE_P;
8010786f:	8b 45 18             	mov    0x18(%ebp),%eax
80107872:	0b 45 14             	or     0x14(%ebp),%eax
80107875:	89 c2                	mov    %eax,%edx
80107877:	83 ca 01             	or     $0x1,%edx
8010787a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010787d:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010787f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107882:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107885:	74 10                	je     80107897 <mappages+0x8e>
      break;
    a += PGSIZE;
80107887:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010788e:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107895:	eb 96                	jmp    8010782d <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107897:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107898:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010789d:	c9                   	leave  
8010789e:	c3                   	ret    

8010789f <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010789f:	55                   	push   %ebp
801078a0:	89 e5                	mov    %esp,%ebp
801078a2:	53                   	push   %ebx
801078a3:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801078a6:	e8 8c b2 ff ff       	call   80102b37 <kalloc>
801078ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078b2:	75 0a                	jne    801078be <setupkvm+0x1f>
    return 0;
801078b4:	b8 00 00 00 00       	mov    $0x0,%eax
801078b9:	e9 98 00 00 00       	jmp    80107956 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801078be:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801078c5:	00 
801078c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801078cd:	00 
801078ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078d1:	89 04 24             	mov    %eax,(%esp)
801078d4:	e8 b9 d4 ff ff       	call   80104d92 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801078d9:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801078e0:	e8 ff f9 ff ff       	call   801072e4 <p2v>
801078e5:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801078ea:	76 0c                	jbe    801078f8 <setupkvm+0x59>
    panic("PHYSTOP too high");
801078ec:	c7 04 24 96 86 10 80 	movl   $0x80108696,(%esp)
801078f3:	e8 4e 8c ff ff       	call   80100546 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078f8:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
801078ff:	eb 49                	jmp    8010794a <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80107901:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107904:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107907:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010790a:	8b 50 04             	mov    0x4(%eax),%edx
8010790d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107910:	8b 58 08             	mov    0x8(%eax),%ebx
80107913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107916:	8b 40 04             	mov    0x4(%eax),%eax
80107919:	29 c3                	sub    %eax,%ebx
8010791b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791e:	8b 00                	mov    (%eax),%eax
80107920:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107924:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107928:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010792c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107930:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107933:	89 04 24             	mov    %eax,(%esp)
80107936:	e8 ce fe ff ff       	call   80107809 <mappages>
8010793b:	85 c0                	test   %eax,%eax
8010793d:	79 07                	jns    80107946 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010793f:	b8 00 00 00 00       	mov    $0x0,%eax
80107944:	eb 10                	jmp    80107956 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107946:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010794a:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107951:	72 ae                	jb     80107901 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107953:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107956:	83 c4 34             	add    $0x34,%esp
80107959:	5b                   	pop    %ebx
8010795a:	5d                   	pop    %ebp
8010795b:	c3                   	ret    

8010795c <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010795c:	55                   	push   %ebp
8010795d:	89 e5                	mov    %esp,%ebp
8010795f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107962:	e8 38 ff ff ff       	call   8010789f <setupkvm>
80107967:	a3 f8 26 11 80       	mov    %eax,0x801126f8
  switchkvm();
8010796c:	e8 02 00 00 00       	call   80107973 <switchkvm>
}
80107971:	c9                   	leave  
80107972:	c3                   	ret    

80107973 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107973:	55                   	push   %ebp
80107974:	89 e5                	mov    %esp,%ebp
80107976:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107979:	a1 f8 26 11 80       	mov    0x801126f8,%eax
8010797e:	89 04 24             	mov    %eax,(%esp)
80107981:	e8 51 f9 ff ff       	call   801072d7 <v2p>
80107986:	89 04 24             	mov    %eax,(%esp)
80107989:	e8 3e f9 ff ff       	call   801072cc <lcr3>
}
8010798e:	c9                   	leave  
8010798f:	c3                   	ret    

80107990 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	53                   	push   %ebx
80107994:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107997:	e8 ef d2 ff ff       	call   80104c8b <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010799c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801079a2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801079a9:	83 c2 08             	add    $0x8,%edx
801079ac:	89 d3                	mov    %edx,%ebx
801079ae:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801079b5:	83 c2 08             	add    $0x8,%edx
801079b8:	c1 ea 10             	shr    $0x10,%edx
801079bb:	89 d1                	mov    %edx,%ecx
801079bd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801079c4:	83 c2 08             	add    $0x8,%edx
801079c7:	c1 ea 18             	shr    $0x18,%edx
801079ca:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801079d1:	67 00 
801079d3:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801079da:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801079e0:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801079e7:	83 e1 f0             	and    $0xfffffff0,%ecx
801079ea:	83 c9 09             	or     $0x9,%ecx
801079ed:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801079f3:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801079fa:	83 c9 10             	or     $0x10,%ecx
801079fd:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107a03:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107a0a:	83 e1 9f             	and    $0xffffff9f,%ecx
80107a0d:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107a13:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107a1a:	83 c9 80             	or     $0xffffff80,%ecx
80107a1d:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107a23:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107a2a:	83 e1 f0             	and    $0xfffffff0,%ecx
80107a2d:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107a33:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107a3a:	83 e1 ef             	and    $0xffffffef,%ecx
80107a3d:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107a43:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107a4a:	83 e1 df             	and    $0xffffffdf,%ecx
80107a4d:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107a53:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107a5a:	83 c9 40             	or     $0x40,%ecx
80107a5d:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107a63:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107a6a:	83 e1 7f             	and    $0x7f,%ecx
80107a6d:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107a73:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107a79:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107a7f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107a86:	83 e2 ef             	and    $0xffffffef,%edx
80107a89:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107a8f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107a95:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107a9b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107aa1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107aa8:	8b 52 08             	mov    0x8(%edx),%edx
80107aab:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107ab1:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107ab4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107abb:	e8 e1 f7 ff ff       	call   801072a1 <ltr>
  if(p->pgdir == 0)
80107ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ac3:	8b 40 04             	mov    0x4(%eax),%eax
80107ac6:	85 c0                	test   %eax,%eax
80107ac8:	75 0c                	jne    80107ad6 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107aca:	c7 04 24 a7 86 10 80 	movl   $0x801086a7,(%esp)
80107ad1:	e8 70 8a ff ff       	call   80100546 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107ad6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad9:	8b 40 04             	mov    0x4(%eax),%eax
80107adc:	89 04 24             	mov    %eax,(%esp)
80107adf:	e8 f3 f7 ff ff       	call   801072d7 <v2p>
80107ae4:	89 04 24             	mov    %eax,(%esp)
80107ae7:	e8 e0 f7 ff ff       	call   801072cc <lcr3>
  popcli();
80107aec:	e8 e2 d1 ff ff       	call   80104cd3 <popcli>
}
80107af1:	83 c4 14             	add    $0x14,%esp
80107af4:	5b                   	pop    %ebx
80107af5:	5d                   	pop    %ebp
80107af6:	c3                   	ret    

80107af7 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107af7:	55                   	push   %ebp
80107af8:	89 e5                	mov    %esp,%ebp
80107afa:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107afd:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107b04:	76 0c                	jbe    80107b12 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107b06:	c7 04 24 bb 86 10 80 	movl   $0x801086bb,(%esp)
80107b0d:	e8 34 8a ff ff       	call   80100546 <panic>
  mem = kalloc();
80107b12:	e8 20 b0 ff ff       	call   80102b37 <kalloc>
80107b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107b1a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b21:	00 
80107b22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b29:	00 
80107b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2d:	89 04 24             	mov    %eax,(%esp)
80107b30:	e8 5d d2 ff ff       	call   80104d92 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b38:	89 04 24             	mov    %eax,(%esp)
80107b3b:	e8 97 f7 ff ff       	call   801072d7 <v2p>
80107b40:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107b47:	00 
80107b48:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107b4c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b53:	00 
80107b54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b5b:	00 
80107b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5f:	89 04 24             	mov    %eax,(%esp)
80107b62:	e8 a2 fc ff ff       	call   80107809 <mappages>
  memmove(mem, init, sz);
80107b67:	8b 45 10             	mov    0x10(%ebp),%eax
80107b6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80107b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b71:	89 44 24 04          	mov    %eax,0x4(%esp)
80107b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b78:	89 04 24             	mov    %eax,(%esp)
80107b7b:	e8 e5 d2 ff ff       	call   80104e65 <memmove>
}
80107b80:	c9                   	leave  
80107b81:	c3                   	ret    

80107b82 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107b82:	55                   	push   %ebp
80107b83:	89 e5                	mov    %esp,%ebp
80107b85:	53                   	push   %ebx
80107b86:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107b89:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b8c:	25 ff 0f 00 00       	and    $0xfff,%eax
80107b91:	85 c0                	test   %eax,%eax
80107b93:	74 0c                	je     80107ba1 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107b95:	c7 04 24 d8 86 10 80 	movl   $0x801086d8,(%esp)
80107b9c:	e8 a5 89 ff ff       	call   80100546 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ba8:	e9 ad 00 00 00       	jmp    80107c5a <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bb3:	01 d0                	add    %edx,%eax
80107bb5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107bbc:	00 
80107bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80107bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80107bc4:	89 04 24             	mov    %eax,(%esp)
80107bc7:	e8 9b fb ff ff       	call   80107767 <walkpgdir>
80107bcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bd3:	75 0c                	jne    80107be1 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107bd5:	c7 04 24 fb 86 10 80 	movl   $0x801086fb,(%esp)
80107bdc:	e8 65 89 ff ff       	call   80100546 <panic>
    pa = PTE_ADDR(*pte);
80107be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107be4:	8b 00                	mov    (%eax),%eax
80107be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107beb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf1:	8b 55 18             	mov    0x18(%ebp),%edx
80107bf4:	89 d1                	mov    %edx,%ecx
80107bf6:	29 c1                	sub    %eax,%ecx
80107bf8:	89 c8                	mov    %ecx,%eax
80107bfa:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107bff:	77 11                	ja     80107c12 <loaduvm+0x90>
      n = sz - i;
80107c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c04:	8b 55 18             	mov    0x18(%ebp),%edx
80107c07:	89 d1                	mov    %edx,%ecx
80107c09:	29 c1                	sub    %eax,%ecx
80107c0b:	89 c8                	mov    %ecx,%eax
80107c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c10:	eb 07                	jmp    80107c19 <loaduvm+0x97>
    else
      n = PGSIZE;
80107c12:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1c:	8b 55 14             	mov    0x14(%ebp),%edx
80107c1f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c25:	89 04 24             	mov    %eax,(%esp)
80107c28:	e8 b7 f6 ff ff       	call   801072e4 <p2v>
80107c2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107c30:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107c34:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107c38:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c3c:	8b 45 10             	mov    0x10(%ebp),%eax
80107c3f:	89 04 24             	mov    %eax,(%esp)
80107c42:	e8 59 a1 ff ff       	call   80101da0 <readi>
80107c47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c4a:	74 07                	je     80107c53 <loaduvm+0xd1>
      return -1;
80107c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c51:	eb 18                	jmp    80107c6b <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107c53:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5d:	3b 45 18             	cmp    0x18(%ebp),%eax
80107c60:	0f 82 47 ff ff ff    	jb     80107bad <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107c66:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c6b:	83 c4 24             	add    $0x24,%esp
80107c6e:	5b                   	pop    %ebx
80107c6f:	5d                   	pop    %ebp
80107c70:	c3                   	ret    

80107c71 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c71:	55                   	push   %ebp
80107c72:	89 e5                	mov    %esp,%ebp
80107c74:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107c77:	8b 45 10             	mov    0x10(%ebp),%eax
80107c7a:	85 c0                	test   %eax,%eax
80107c7c:	79 0a                	jns    80107c88 <allocuvm+0x17>
    return 0;
80107c7e:	b8 00 00 00 00       	mov    $0x0,%eax
80107c83:	e9 c1 00 00 00       	jmp    80107d49 <allocuvm+0xd8>
  if(newsz < oldsz)
80107c88:	8b 45 10             	mov    0x10(%ebp),%eax
80107c8b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c8e:	73 08                	jae    80107c98 <allocuvm+0x27>
    return oldsz;
80107c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c93:	e9 b1 00 00 00       	jmp    80107d49 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107c98:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c9b:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ca0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107ca8:	e9 8d 00 00 00       	jmp    80107d3a <allocuvm+0xc9>
    mem = kalloc();
80107cad:	e8 85 ae ff ff       	call   80102b37 <kalloc>
80107cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107cb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107cb9:	75 2c                	jne    80107ce7 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107cbb:	c7 04 24 19 87 10 80 	movl   $0x80108719,(%esp)
80107cc2:	e8 e3 86 ff ff       	call   801003aa <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cca:	89 44 24 08          	mov    %eax,0x8(%esp)
80107cce:	8b 45 10             	mov    0x10(%ebp),%eax
80107cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd8:	89 04 24             	mov    %eax,(%esp)
80107cdb:	e8 6b 00 00 00       	call   80107d4b <deallocuvm>
      return 0;
80107ce0:	b8 00 00 00 00       	mov    $0x0,%eax
80107ce5:	eb 62                	jmp    80107d49 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107ce7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107cee:	00 
80107cef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107cf6:	00 
80107cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cfa:	89 04 24             	mov    %eax,(%esp)
80107cfd:	e8 90 d0 ff ff       	call   80104d92 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d05:	89 04 24             	mov    %eax,(%esp)
80107d08:	e8 ca f5 ff ff       	call   801072d7 <v2p>
80107d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107d10:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107d17:	00 
80107d18:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107d1c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d23:	00 
80107d24:	89 54 24 04          	mov    %edx,0x4(%esp)
80107d28:	8b 45 08             	mov    0x8(%ebp),%eax
80107d2b:	89 04 24             	mov    %eax,(%esp)
80107d2e:	e8 d6 fa ff ff       	call   80107809 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107d33:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3d:	3b 45 10             	cmp    0x10(%ebp),%eax
80107d40:	0f 82 67 ff ff ff    	jb     80107cad <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107d46:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107d49:	c9                   	leave  
80107d4a:	c3                   	ret    

80107d4b <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d4b:	55                   	push   %ebp
80107d4c:	89 e5                	mov    %esp,%ebp
80107d4e:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107d51:	8b 45 10             	mov    0x10(%ebp),%eax
80107d54:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d57:	72 08                	jb     80107d61 <deallocuvm+0x16>
    return oldsz;
80107d59:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d5c:	e9 a4 00 00 00       	jmp    80107e05 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107d61:	8b 45 10             	mov    0x10(%ebp),%eax
80107d64:	05 ff 0f 00 00       	add    $0xfff,%eax
80107d69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107d71:	e9 80 00 00 00       	jmp    80107df6 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d79:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107d80:	00 
80107d81:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d85:	8b 45 08             	mov    0x8(%ebp),%eax
80107d88:	89 04 24             	mov    %eax,(%esp)
80107d8b:	e8 d7 f9 ff ff       	call   80107767 <walkpgdir>
80107d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107d93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d97:	75 09                	jne    80107da2 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107d99:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107da0:	eb 4d                	jmp    80107def <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107da5:	8b 00                	mov    (%eax),%eax
80107da7:	83 e0 01             	and    $0x1,%eax
80107daa:	85 c0                	test   %eax,%eax
80107dac:	74 41                	je     80107def <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107db1:	8b 00                	mov    (%eax),%eax
80107db3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107db8:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107dbb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107dbf:	75 0c                	jne    80107dcd <deallocuvm+0x82>
        panic("kfree");
80107dc1:	c7 04 24 31 87 10 80 	movl   $0x80108731,(%esp)
80107dc8:	e8 79 87 ff ff       	call   80100546 <panic>
      char *v = p2v(pa);
80107dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107dd0:	89 04 24             	mov    %eax,(%esp)
80107dd3:	e8 0c f5 ff ff       	call   801072e4 <p2v>
80107dd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dde:	89 04 24             	mov    %eax,(%esp)
80107de1:	e8 b8 ac ff ff       	call   80102a9e <kfree>
      *pte = 0;
80107de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107de9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107def:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df9:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107dfc:	0f 82 74 ff ff ff    	jb     80107d76 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107e02:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e05:	c9                   	leave  
80107e06:	c3                   	ret    

80107e07 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e07:	55                   	push   %ebp
80107e08:	89 e5                	mov    %esp,%ebp
80107e0a:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107e11:	75 0c                	jne    80107e1f <freevm+0x18>
    panic("freevm: no pgdir");
80107e13:	c7 04 24 37 87 10 80 	movl   $0x80108737,(%esp)
80107e1a:	e8 27 87 ff ff       	call   80100546 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107e1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e26:	00 
80107e27:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107e2e:	80 
80107e2f:	8b 45 08             	mov    0x8(%ebp),%eax
80107e32:	89 04 24             	mov    %eax,(%esp)
80107e35:	e8 11 ff ff ff       	call   80107d4b <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107e3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e41:	eb 48                	jmp    80107e8b <freevm+0x84>
    if(pgdir[i] & PTE_P){
80107e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e46:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e4d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e50:	01 d0                	add    %edx,%eax
80107e52:	8b 00                	mov    (%eax),%eax
80107e54:	83 e0 01             	and    $0x1,%eax
80107e57:	85 c0                	test   %eax,%eax
80107e59:	74 2c                	je     80107e87 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e65:	8b 45 08             	mov    0x8(%ebp),%eax
80107e68:	01 d0                	add    %edx,%eax
80107e6a:	8b 00                	mov    (%eax),%eax
80107e6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e71:	89 04 24             	mov    %eax,(%esp)
80107e74:	e8 6b f4 ff ff       	call   801072e4 <p2v>
80107e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e7f:	89 04 24             	mov    %eax,(%esp)
80107e82:	e8 17 ac ff ff       	call   80102a9e <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107e87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107e8b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107e92:	76 af                	jbe    80107e43 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107e94:	8b 45 08             	mov    0x8(%ebp),%eax
80107e97:	89 04 24             	mov    %eax,(%esp)
80107e9a:	e8 ff ab ff ff       	call   80102a9e <kfree>
}
80107e9f:	c9                   	leave  
80107ea0:	c3                   	ret    

80107ea1 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107ea1:	55                   	push   %ebp
80107ea2:	89 e5                	mov    %esp,%ebp
80107ea4:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ea7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107eae:	00 
80107eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
80107eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80107eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb9:	89 04 24             	mov    %eax,(%esp)
80107ebc:	e8 a6 f8 ff ff       	call   80107767 <walkpgdir>
80107ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107ec4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ec8:	75 0c                	jne    80107ed6 <clearpteu+0x35>
    panic("clearpteu");
80107eca:	c7 04 24 48 87 10 80 	movl   $0x80108748,(%esp)
80107ed1:	e8 70 86 ff ff       	call   80100546 <panic>
  *pte &= ~PTE_U;
80107ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed9:	8b 00                	mov    (%eax),%eax
80107edb:	89 c2                	mov    %eax,%edx
80107edd:	83 e2 fb             	and    $0xfffffffb,%edx
80107ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee3:	89 10                	mov    %edx,(%eax)
}
80107ee5:	c9                   	leave  
80107ee6:	c3                   	ret    

80107ee7 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107ee7:	55                   	push   %ebp
80107ee8:	89 e5                	mov    %esp,%ebp
80107eea:	53                   	push   %ebx
80107eeb:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107eee:	e8 ac f9 ff ff       	call   8010789f <setupkvm>
80107ef3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ef6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107efa:	75 0a                	jne    80107f06 <copyuvm+0x1f>
    return 0;
80107efc:	b8 00 00 00 00       	mov    $0x0,%eax
80107f01:	e9 fd 00 00 00       	jmp    80108003 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80107f06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f0d:	e9 cc 00 00 00       	jmp    80107fde <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f15:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f1c:	00 
80107f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f21:	8b 45 08             	mov    0x8(%ebp),%eax
80107f24:	89 04 24             	mov    %eax,(%esp)
80107f27:	e8 3b f8 ff ff       	call   80107767 <walkpgdir>
80107f2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f33:	75 0c                	jne    80107f41 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80107f35:	c7 04 24 52 87 10 80 	movl   $0x80108752,(%esp)
80107f3c:	e8 05 86 ff ff       	call   80100546 <panic>
    if(!(*pte & PTE_P))
80107f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f44:	8b 00                	mov    (%eax),%eax
80107f46:	83 e0 01             	and    $0x1,%eax
80107f49:	85 c0                	test   %eax,%eax
80107f4b:	75 0c                	jne    80107f59 <copyuvm+0x72>
      panic("copyuvm: page not present");
80107f4d:	c7 04 24 6c 87 10 80 	movl   $0x8010876c,(%esp)
80107f54:	e8 ed 85 ff ff       	call   80100546 <panic>
    pa = PTE_ADDR(*pte);
80107f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f5c:	8b 00                	mov    (%eax),%eax
80107f5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f63:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f69:	8b 00                	mov    (%eax),%eax
80107f6b:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107f73:	e8 bf ab ff ff       	call   80102b37 <kalloc>
80107f78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107f7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107f7f:	74 6e                	je     80107fef <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80107f81:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f84:	89 04 24             	mov    %eax,(%esp)
80107f87:	e8 58 f3 ff ff       	call   801072e4 <p2v>
80107f8c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f93:	00 
80107f94:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f9b:	89 04 24             	mov    %eax,(%esp)
80107f9e:	e8 c2 ce ff ff       	call   80104e65 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80107fa3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80107fa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107fa9:	89 04 24             	mov    %eax,(%esp)
80107fac:	e8 26 f3 ff ff       	call   801072d7 <v2p>
80107fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107fb4:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107fb8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107fbc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fc3:	00 
80107fc4:	89 54 24 04          	mov    %edx,0x4(%esp)
80107fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fcb:	89 04 24             	mov    %eax,(%esp)
80107fce:	e8 36 f8 ff ff       	call   80107809 <mappages>
80107fd3:	85 c0                	test   %eax,%eax
80107fd5:	78 1b                	js     80107ff2 <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107fd7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe1:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fe4:	0f 82 28 ff ff ff    	jb     80107f12 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80107fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fed:	eb 14                	jmp    80108003 <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80107fef:	90                   	nop
80107ff0:	eb 01                	jmp    80107ff3 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80107ff2:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80107ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ff6:	89 04 24             	mov    %eax,(%esp)
80107ff9:	e8 09 fe ff ff       	call   80107e07 <freevm>
  return 0;
80107ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108003:	83 c4 44             	add    $0x44,%esp
80108006:	5b                   	pop    %ebx
80108007:	5d                   	pop    %ebp
80108008:	c3                   	ret    

80108009 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108009:	55                   	push   %ebp
8010800a:	89 e5                	mov    %esp,%ebp
8010800c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010800f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108016:	00 
80108017:	8b 45 0c             	mov    0xc(%ebp),%eax
8010801a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010801e:	8b 45 08             	mov    0x8(%ebp),%eax
80108021:	89 04 24             	mov    %eax,(%esp)
80108024:	e8 3e f7 ff ff       	call   80107767 <walkpgdir>
80108029:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010802c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802f:	8b 00                	mov    (%eax),%eax
80108031:	83 e0 01             	and    $0x1,%eax
80108034:	85 c0                	test   %eax,%eax
80108036:	75 07                	jne    8010803f <uva2ka+0x36>
    return 0;
80108038:	b8 00 00 00 00       	mov    $0x0,%eax
8010803d:	eb 25                	jmp    80108064 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010803f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108042:	8b 00                	mov    (%eax),%eax
80108044:	83 e0 04             	and    $0x4,%eax
80108047:	85 c0                	test   %eax,%eax
80108049:	75 07                	jne    80108052 <uva2ka+0x49>
    return 0;
8010804b:	b8 00 00 00 00       	mov    $0x0,%eax
80108050:	eb 12                	jmp    80108064 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108055:	8b 00                	mov    (%eax),%eax
80108057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010805c:	89 04 24             	mov    %eax,(%esp)
8010805f:	e8 80 f2 ff ff       	call   801072e4 <p2v>
}
80108064:	c9                   	leave  
80108065:	c3                   	ret    

80108066 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108066:	55                   	push   %ebp
80108067:	89 e5                	mov    %esp,%ebp
80108069:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010806c:	8b 45 10             	mov    0x10(%ebp),%eax
8010806f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108072:	e9 89 00 00 00       	jmp    80108100 <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
80108077:	8b 45 0c             	mov    0xc(%ebp),%eax
8010807a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010807f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108082:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108085:	89 44 24 04          	mov    %eax,0x4(%esp)
80108089:	8b 45 08             	mov    0x8(%ebp),%eax
8010808c:	89 04 24             	mov    %eax,(%esp)
8010808f:	e8 75 ff ff ff       	call   80108009 <uva2ka>
80108094:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108097:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010809b:	75 07                	jne    801080a4 <copyout+0x3e>
      return -1;
8010809d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080a2:	eb 6b                	jmp    8010810f <copyout+0xa9>
    n = PGSIZE - (va - va0);
801080a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801080a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801080aa:	89 d1                	mov    %edx,%ecx
801080ac:	29 c1                	sub    %eax,%ecx
801080ae:	89 c8                	mov    %ecx,%eax
801080b0:	05 00 10 00 00       	add    $0x1000,%eax
801080b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801080b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080bb:	3b 45 14             	cmp    0x14(%ebp),%eax
801080be:	76 06                	jbe    801080c6 <copyout+0x60>
      n = len;
801080c0:	8b 45 14             	mov    0x14(%ebp),%eax
801080c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801080c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801080cc:	29 c2                	sub    %eax,%edx
801080ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080d1:	01 c2                	add    %eax,%edx
801080d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080d6:	89 44 24 08          	mov    %eax,0x8(%esp)
801080da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801080e1:	89 14 24             	mov    %edx,(%esp)
801080e4:	e8 7c cd ff ff       	call   80104e65 <memmove>
    len -= n;
801080e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080ec:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801080ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080f2:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801080f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080f8:	05 00 10 00 00       	add    $0x1000,%eax
801080fd:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108100:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108104:	0f 85 6d ff ff ff    	jne    80108077 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010810a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010810f:	c9                   	leave  
80108110:	c3                   	ret    
