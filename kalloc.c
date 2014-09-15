// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "uart.h"

void freerange(void *vstart, void *vend);

extern char end[]; // first address after kernel loaded from ELF file

struct run {
	struct run *next;
};

struct {
	// struct spinlock lock;
	//int use_lock;
	struct run *freelist;
} kmem;

char *kakunin1,*kakunin2,*kakunin3,*kakunin4,*kakunin5, *fl;
extern int t_flag;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
	uart_puts("kinit1\n");
	// initlock(&kmem.lock, "kmem");
	// kmem.use_lock = 0;
	freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
	uart_puts("kinit2\n");
	freerange(vstart, vend);
	// kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
	uart_puts("freerange\n");
	char *p;
	p = (char*)PGROUNDUP((uint)vstart); // 切り上げ

	for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
		kfree(p);
}

//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
	struct run *r;
	
	//アドレスvがページ境界に合っているか、endより大きいか、PHYSTOP以下であるか
	if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
		uart_puts("kfree_panic");
	//panic("kfree");
//	uart_puts("C");
	// Fill with junk to catch dangling refs. ??
	// freedメモリ空間は１で埋め尽くす.
	memset(v, 1, PGSIZE);
	
//	uart_puts("D");
	// if(kmem.use_lock)
	//  acquire(&kmem.lock);
	r = (struct run*)v;
	r->next = kmem.freelist;      /*r->nextに既存のfreeリストを代入*/
	kmem.freelist = r;            /*freeリストがこのrを指すようにする。*/
	                              /*結局、rがfreeリストの先頭に挿入されたということになる*/
	
	fl = (char*)kmem.freelist;
//	uart_puts("E");
	//if(kmem.use_lock)
	//  release(&kmem.lock);
}

void
check_fl(void)
{
	kakunin1 = (char*)kmem.freelist;
	kakunin2 = (char*)kmem.freelist->next;
	kakunin3 = (char*)kmem.freelist->next->next;
	kakunin4 = (char*)kmem.freelist->next->next->next;
	kakunin5 = (char*)kmem.freelist->next->next->next->next;
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
	struct run *r;
	
	// if(kmem.use_lock)
	//  acquire(&kmem.lock);
	r = kmem.freelist;
       	
//	check_fl();

        // freelistが空でないならば、その先頭の要素アドレスを返し、リストの次の要素を先頭にする。
        // (つまりリストの先頭要素を削除する)
	if(r)
		kmem.freelist = r->next;
	else
		uart_puts("no elements in free list\n");

	//if(kmem.use_lock)
	//  release(&kmem.lock);
	// freeリストの要素がひとつもなければ0を返す。
	/* kakunin = (char*)kmem.freelist;   //現在２つ目のfreelistの要素が0になっている。 */
	/* while(1) {} */


	return (char*)r;
}

//16KB境界に整列した4KBの物理メモリを探して取得する。
char*
kalloc_pd(void)
{
       struct run *r, *s;
       
       // if(kmem.use_lock)
       //  acquire(&kmem.lock);
       s = kmem.freelist;
       r = s->next;

       //リストの最初が16KB境界にあるかどうか
       if (!((uint)s % (PGSIZE * 4)))
       {
	       kmem.freelist = s->next;
	       return (char*)s;
       }

       //16KB境界にある要素を見つけるまでループ
       while ((uint)r % (PGSIZE * 4))
       {
	       s = r;
	       r = s->next;
       }
       
       //リンクをつなぎ直して該当要素の削除 (本当にこれできてますか!?)
       s->next = r->next;

       return (char*)r;       
       //if(r)
       //  kmem.freelist = r->next;
       //if(kmem.use_lock)
       //  release(&kmem.lock);
       //return (char*)r;
}

