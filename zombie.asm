
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 76 02 00 00       	call   284 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fe 02 00 00       	call   31c <sleep>
  exit();
  1e:	e8 69 02 00 00       	call   28c <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	90                   	nop
  56:	8b 45 0c             	mov    0xc(%ebp),%eax
  59:	0f b6 10             	movzbl (%eax),%edx
  5c:	8b 45 08             	mov    0x8(%ebp),%eax
  5f:	88 10                	mov    %dl,(%eax)
  61:	8b 45 08             	mov    0x8(%ebp),%eax
  64:	0f b6 00             	movzbl (%eax),%eax
  67:	84 c0                	test   %al,%al
  69:	0f 95 c0             	setne  %al
  6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  70:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  74:	84 c0                	test   %al,%al
  76:	75 de                	jne    56 <strcpy+0xd>
    ;
  return os;
  78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7b:	c9                   	leave  
  7c:	c3                   	ret    

0000007d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  80:	eb 08                	jmp    8a <strcmp+0xd>
    p++, q++;
  82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  86:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8a:	8b 45 08             	mov    0x8(%ebp),%eax
  8d:	0f b6 00             	movzbl (%eax),%eax
  90:	84 c0                	test   %al,%al
  92:	74 10                	je     a4 <strcmp+0x27>
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	0f b6 10             	movzbl (%eax),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	0f b6 00             	movzbl (%eax),%eax
  a0:	38 c2                	cmp    %al,%dl
  a2:	74 de                	je     82 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	0f b6 d0             	movzbl %al,%edx
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	0f b6 c0             	movzbl %al,%eax
  b6:	89 d1                	mov    %edx,%ecx
  b8:	29 c1                	sub    %eax,%ecx
  ba:	89 c8                	mov    %ecx,%eax
}
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    

000000be <strlen>:

uint
strlen(char *s)
{
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  cb:	eb 04                	jmp    d1 <strlen+0x13>
  cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	01 d0                	add    %edx,%eax
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	75 ed                	jne    cd <strlen+0xf>
    ;
  return n;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	89 04 24             	mov    %eax,(%esp)
  ff:	e8 20 ff ff ff       	call   24 <stosb>
  return dst;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
}
 107:	c9                   	leave  
 108:	c3                   	ret    

00000109 <strchr>:

char*
strchr(const char *s, char c)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 115:	eb 14                	jmp    12b <strchr+0x22>
    if(*s == c)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 120:	75 05                	jne    127 <strchr+0x1e>
      return (char*)s;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	eb 13                	jmp    13a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 127:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 e2                	jne    117 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 135:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 149:	eb 46                	jmp    191 <gets+0x55>
    cc = read(0, &c, 1);
 14b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 152:	00 
 153:	8d 45 ef             	lea    -0x11(%ebp),%eax
 156:	89 44 24 04          	mov    %eax,0x4(%esp)
 15a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 161:	e8 3e 01 00 00       	call   2a4 <read>
 166:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 16d:	7e 2f                	jle    19e <gets+0x62>
      break;
    buf[i++] = c;
 16f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	01 c2                	add    %eax,%edx
 177:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17b:	88 02                	mov    %al,(%edx)
 17d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 181:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 185:	3c 0a                	cmp    $0xa,%al
 187:	74 16                	je     19f <gets+0x63>
 189:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18d:	3c 0d                	cmp    $0xd,%al
 18f:	74 0e                	je     19f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 191:	8b 45 f4             	mov    -0xc(%ebp),%eax
 194:	83 c0 01             	add    $0x1,%eax
 197:	3b 45 0c             	cmp    0xc(%ebp),%eax
 19a:	7c af                	jl     14b <gets+0xf>
 19c:	eb 01                	jmp    19f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 19e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	01 d0                	add    %edx,%eax
 1a7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <stat>:

int
stat(char *n, struct stat *st)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1bc:	00 
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	89 04 24             	mov    %eax,(%esp)
 1c3:	e8 04 01 00 00       	call   2cc <open>
 1c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cf:	79 07                	jns    1d8 <stat+0x29>
    return -1;
 1d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d6:	eb 23                	jmp    1fb <stat+0x4c>
  r = fstat(fd, st);
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	89 44 24 04          	mov    %eax,0x4(%esp)
 1df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e2:	89 04 24             	mov    %eax,(%esp)
 1e5:	e8 fa 00 00 00       	call   2e4 <fstat>
 1ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f0:	89 04 24             	mov    %eax,(%esp)
 1f3:	e8 bc 00 00 00       	call   2b4 <close>
  return r;
 1f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <atoi>:

int
atoi(const char *s)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 20a:	eb 23                	jmp    22f <atoi+0x32>
    n = n*10 + *s++ - '0';
 20c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20f:	89 d0                	mov    %edx,%eax
 211:	c1 e0 02             	shl    $0x2,%eax
 214:	01 d0                	add    %edx,%eax
 216:	01 c0                	add    %eax,%eax
 218:	89 c2                	mov    %eax,%edx
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	0f be c0             	movsbl %al,%eax
 223:	01 d0                	add    %edx,%eax
 225:	83 e8 30             	sub    $0x30,%eax
 228:	89 45 fc             	mov    %eax,-0x4(%ebp)
 22b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 2f                	cmp    $0x2f,%al
 237:	7e 0a                	jle    243 <atoi+0x46>
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	3c 39                	cmp    $0x39,%al
 241:	7e c9                	jle    20c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 243:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 254:	8b 45 0c             	mov    0xc(%ebp),%eax
 257:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 25a:	eb 13                	jmp    26f <memmove+0x27>
    *dst++ = *src++;
 25c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 25f:	0f b6 10             	movzbl (%eax),%edx
 262:	8b 45 fc             	mov    -0x4(%ebp),%eax
 265:	88 10                	mov    %dl,(%eax)
 267:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 26b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 273:	0f 9f c0             	setg   %al
 276:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 27a:	84 c0                	test   %al,%al
 27c:	75 de                	jne    25c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    
 283:	90                   	nop

00000284 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 284:	b8 01 00 00 00       	mov    $0x1,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <exit>:
SYSCALL(exit)
 28c:	b8 02 00 00 00       	mov    $0x2,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <wait>:
SYSCALL(wait)
 294:	b8 03 00 00 00       	mov    $0x3,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <pipe>:
SYSCALL(pipe)
 29c:	b8 04 00 00 00       	mov    $0x4,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <read>:
SYSCALL(read)
 2a4:	b8 05 00 00 00       	mov    $0x5,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <write>:
SYSCALL(write)
 2ac:	b8 10 00 00 00       	mov    $0x10,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <close>:
SYSCALL(close)
 2b4:	b8 15 00 00 00       	mov    $0x15,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <kill>:
SYSCALL(kill)
 2bc:	b8 06 00 00 00       	mov    $0x6,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exec>:
SYSCALL(exec)
 2c4:	b8 07 00 00 00       	mov    $0x7,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <open>:
SYSCALL(open)
 2cc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <mknod>:
SYSCALL(mknod)
 2d4:	b8 11 00 00 00       	mov    $0x11,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <unlink>:
SYSCALL(unlink)
 2dc:	b8 12 00 00 00       	mov    $0x12,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <fstat>:
SYSCALL(fstat)
 2e4:	b8 08 00 00 00       	mov    $0x8,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <link>:
SYSCALL(link)
 2ec:	b8 13 00 00 00       	mov    $0x13,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <mkdir>:
SYSCALL(mkdir)
 2f4:	b8 14 00 00 00       	mov    $0x14,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <chdir>:
SYSCALL(chdir)
 2fc:	b8 09 00 00 00       	mov    $0x9,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <dup>:
SYSCALL(dup)
 304:	b8 0a 00 00 00       	mov    $0xa,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <getpid>:
SYSCALL(getpid)
 30c:	b8 0b 00 00 00       	mov    $0xb,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <sbrk>:
SYSCALL(sbrk)
 314:	b8 0c 00 00 00       	mov    $0xc,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <sleep>:
SYSCALL(sleep)
 31c:	b8 0d 00 00 00       	mov    $0xd,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <uptime>:
SYSCALL(uptime)
 324:	b8 0e 00 00 00       	mov    $0xe,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	83 ec 28             	sub    $0x28,%esp
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 338:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 33f:	00 
 340:	8d 45 f4             	lea    -0xc(%ebp),%eax
 343:	89 44 24 04          	mov    %eax,0x4(%esp)
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	89 04 24             	mov    %eax,(%esp)
 34d:	e8 5a ff ff ff       	call   2ac <write>
}
 352:	c9                   	leave  
 353:	c3                   	ret    

00000354 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 35a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 361:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 365:	74 17                	je     37e <printint+0x2a>
 367:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 36b:	79 11                	jns    37e <printint+0x2a>
    neg = 1;
 36d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	f7 d8                	neg    %eax
 379:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37c:	eb 06                	jmp    384 <printint+0x30>
  } else {
    x = xx;
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 38b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 391:	ba 00 00 00 00       	mov    $0x0,%edx
 396:	f7 f1                	div    %ecx
 398:	89 d0                	mov    %edx,%eax
 39a:	0f b6 80 1c 0a 00 00 	movzbl 0xa1c(%eax),%eax
 3a1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a7:	01 ca                	add    %ecx,%edx
 3a9:	88 02                	mov    %al,(%edx)
 3ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3af:	8b 55 10             	mov    0x10(%ebp),%edx
 3b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b8:	ba 00 00 00 00       	mov    $0x0,%edx
 3bd:	f7 75 d4             	divl   -0x2c(%ebp)
 3c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c7:	75 c2                	jne    38b <printint+0x37>
  if(neg)
 3c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3cd:	74 2e                	je     3fd <printint+0xa9>
    buf[i++] = '-';
 3cf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d5:	01 d0                	add    %edx,%eax
 3d7:	c6 00 2d             	movb   $0x2d,(%eax)
 3da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 3de:	eb 1d                	jmp    3fd <printint+0xa9>
    putc(fd, buf[i]);
 3e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e6:	01 d0                	add    %edx,%eax
 3e8:	0f b6 00             	movzbl (%eax),%eax
 3eb:	0f be c0             	movsbl %al,%eax
 3ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f2:	8b 45 08             	mov    0x8(%ebp),%eax
 3f5:	89 04 24             	mov    %eax,(%esp)
 3f8:	e8 2f ff ff ff       	call   32c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3fd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 401:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 405:	79 d9                	jns    3e0 <printint+0x8c>
    putc(fd, buf[i]);
}
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 40f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 416:	8d 45 0c             	lea    0xc(%ebp),%eax
 419:	83 c0 04             	add    $0x4,%eax
 41c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 41f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 426:	e9 7d 01 00 00       	jmp    5a8 <printf+0x19f>
    c = fmt[i] & 0xff;
 42b:	8b 55 0c             	mov    0xc(%ebp),%edx
 42e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 431:	01 d0                	add    %edx,%eax
 433:	0f b6 00             	movzbl (%eax),%eax
 436:	0f be c0             	movsbl %al,%eax
 439:	25 ff 00 00 00       	and    $0xff,%eax
 43e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 441:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 445:	75 2c                	jne    473 <printf+0x6a>
      if(c == '%'){
 447:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 44b:	75 0c                	jne    459 <printf+0x50>
        state = '%';
 44d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 454:	e9 4b 01 00 00       	jmp    5a4 <printf+0x19b>
      } else {
        putc(fd, c);
 459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 45c:	0f be c0             	movsbl %al,%eax
 45f:	89 44 24 04          	mov    %eax,0x4(%esp)
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	89 04 24             	mov    %eax,(%esp)
 469:	e8 be fe ff ff       	call   32c <putc>
 46e:	e9 31 01 00 00       	jmp    5a4 <printf+0x19b>
      }
    } else if(state == '%'){
 473:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 477:	0f 85 27 01 00 00    	jne    5a4 <printf+0x19b>
      if(c == 'd'){
 47d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 481:	75 2d                	jne    4b0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 483:	8b 45 e8             	mov    -0x18(%ebp),%eax
 486:	8b 00                	mov    (%eax),%eax
 488:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 48f:	00 
 490:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 497:	00 
 498:	89 44 24 04          	mov    %eax,0x4(%esp)
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	89 04 24             	mov    %eax,(%esp)
 4a2:	e8 ad fe ff ff       	call   354 <printint>
        ap++;
 4a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ab:	e9 ed 00 00 00       	jmp    59d <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4b0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4b4:	74 06                	je     4bc <printf+0xb3>
 4b6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ba:	75 2d                	jne    4e9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bf:	8b 00                	mov    (%eax),%eax
 4c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4c8:	00 
 4c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4d0:	00 
 4d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d5:	8b 45 08             	mov    0x8(%ebp),%eax
 4d8:	89 04 24             	mov    %eax,(%esp)
 4db:	e8 74 fe ff ff       	call   354 <printint>
        ap++;
 4e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e4:	e9 b4 00 00 00       	jmp    59d <printf+0x194>
      } else if(c == 's'){
 4e9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4ed:	75 46                	jne    535 <printf+0x12c>
        s = (char*)*ap;
 4ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f2:	8b 00                	mov    (%eax),%eax
 4f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ff:	75 27                	jne    528 <printf+0x11f>
          s = "(null)";
 501:	c7 45 f4 d9 07 00 00 	movl   $0x7d9,-0xc(%ebp)
        while(*s != 0){
 508:	eb 1e                	jmp    528 <printf+0x11f>
          putc(fd, *s);
 50a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50d:	0f b6 00             	movzbl (%eax),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	89 44 24 04          	mov    %eax,0x4(%esp)
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	89 04 24             	mov    %eax,(%esp)
 51d:	e8 0a fe ff ff       	call   32c <putc>
          s++;
 522:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 526:	eb 01                	jmp    529 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 528:	90                   	nop
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52c:	0f b6 00             	movzbl (%eax),%eax
 52f:	84 c0                	test   %al,%al
 531:	75 d7                	jne    50a <printf+0x101>
 533:	eb 68                	jmp    59d <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 535:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 539:	75 1d                	jne    558 <printf+0x14f>
        putc(fd, *ap);
 53b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53e:	8b 00                	mov    (%eax),%eax
 540:	0f be c0             	movsbl %al,%eax
 543:	89 44 24 04          	mov    %eax,0x4(%esp)
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	89 04 24             	mov    %eax,(%esp)
 54d:	e8 da fd ff ff       	call   32c <putc>
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 556:	eb 45                	jmp    59d <printf+0x194>
      } else if(c == '%'){
 558:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55c:	75 17                	jne    575 <printf+0x16c>
        putc(fd, c);
 55e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	89 44 24 04          	mov    %eax,0x4(%esp)
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	89 04 24             	mov    %eax,(%esp)
 56e:	e8 b9 fd ff ff       	call   32c <putc>
 573:	eb 28                	jmp    59d <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 575:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 57c:	00 
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	89 04 24             	mov    %eax,(%esp)
 583:	e8 a4 fd ff ff       	call   32c <putc>
        putc(fd, c);
 588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	89 44 24 04          	mov    %eax,0x4(%esp)
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 04 24             	mov    %eax,(%esp)
 598:	e8 8f fd ff ff       	call   32c <putc>
      }
      state = 0;
 59d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ae:	01 d0                	add    %edx,%eax
 5b0:	0f b6 00             	movzbl (%eax),%eax
 5b3:	84 c0                	test   %al,%al
 5b5:	0f 85 70 fe ff ff    	jne    42b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5bb:	c9                   	leave  
 5bc:	c3                   	ret    
 5bd:	90                   	nop
 5be:	90                   	nop
 5bf:	90                   	nop

000005c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	83 e8 08             	sub    $0x8,%eax
 5cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cf:	a1 38 0a 00 00       	mov    0xa38,%eax
 5d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d7:	eb 24                	jmp    5fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5dc:	8b 00                	mov    (%eax),%eax
 5de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e1:	77 12                	ja     5f5 <free+0x35>
 5e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e9:	77 24                	ja     60f <free+0x4f>
 5eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f3:	77 1a                	ja     60f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 600:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 603:	76 d4                	jbe    5d9 <free+0x19>
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60d:	76 ca                	jbe    5d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	8b 40 04             	mov    0x4(%eax),%eax
 615:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	01 c2                	add    %eax,%edx
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	39 c2                	cmp    %eax,%edx
 628:	75 24                	jne    64e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 62a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62d:	8b 50 04             	mov    0x4(%eax),%edx
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	8b 40 04             	mov    0x4(%eax),%eax
 638:	01 c2                	add    %eax,%edx
 63a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	8b 10                	mov    (%eax),%edx
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	89 10                	mov    %edx,(%eax)
 64c:	eb 0a                	jmp    658 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 10                	mov    (%eax),%edx
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 40 04             	mov    0x4(%eax),%eax
 65e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	01 d0                	add    %edx,%eax
 66a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66d:	75 20                	jne    68f <free+0xcf>
    p->s.size += bp->s.size;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 50 04             	mov    0x4(%eax),%edx
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	8b 40 04             	mov    0x4(%eax),%eax
 67b:	01 c2                	add    %eax,%edx
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	8b 10                	mov    (%eax),%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	89 10                	mov    %edx,(%eax)
 68d:	eb 08                	jmp    697 <free+0xd7>
  } else
    p->s.ptr = bp;
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 55 f8             	mov    -0x8(%ebp),%edx
 695:	89 10                	mov    %edx,(%eax)
  freep = p;
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	a3 38 0a 00 00       	mov    %eax,0xa38
}
 69f:	c9                   	leave  
 6a0:	c3                   	ret    

000006a1 <morecore>:

static Header*
morecore(uint nu)
{
 6a1:	55                   	push   %ebp
 6a2:	89 e5                	mov    %esp,%ebp
 6a4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6a7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ae:	77 07                	ja     6b7 <morecore+0x16>
    nu = 4096;
 6b0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6b7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ba:	c1 e0 03             	shl    $0x3,%eax
 6bd:	89 04 24             	mov    %eax,(%esp)
 6c0:	e8 4f fc ff ff       	call   314 <sbrk>
 6c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6cc:	75 07                	jne    6d5 <morecore+0x34>
    return 0;
 6ce:	b8 00 00 00 00       	mov    $0x0,%eax
 6d3:	eb 22                	jmp    6f7 <morecore+0x56>
  hp = (Header*)p;
 6d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6de:	8b 55 08             	mov    0x8(%ebp),%edx
 6e1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e7:	83 c0 08             	add    $0x8,%eax
 6ea:	89 04 24             	mov    %eax,(%esp)
 6ed:	e8 ce fe ff ff       	call   5c0 <free>
  return freep;
 6f2:	a1 38 0a 00 00       	mov    0xa38,%eax
}
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <malloc>:

void*
malloc(uint nbytes)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ff:	8b 45 08             	mov    0x8(%ebp),%eax
 702:	83 c0 07             	add    $0x7,%eax
 705:	c1 e8 03             	shr    $0x3,%eax
 708:	83 c0 01             	add    $0x1,%eax
 70b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 70e:	a1 38 0a 00 00       	mov    0xa38,%eax
 713:	89 45 f0             	mov    %eax,-0x10(%ebp)
 716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71a:	75 23                	jne    73f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 71c:	c7 45 f0 30 0a 00 00 	movl   $0xa30,-0x10(%ebp)
 723:	8b 45 f0             	mov    -0x10(%ebp),%eax
 726:	a3 38 0a 00 00       	mov    %eax,0xa38
 72b:	a1 38 0a 00 00       	mov    0xa38,%eax
 730:	a3 30 0a 00 00       	mov    %eax,0xa30
    base.s.size = 0;
 735:	c7 05 34 0a 00 00 00 	movl   $0x0,0xa34
 73c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	8b 00                	mov    (%eax),%eax
 744:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 750:	72 4d                	jb     79f <malloc+0xa6>
      if(p->s.size == nunits)
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75b:	75 0c                	jne    769 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 10                	mov    (%eax),%edx
 762:	8b 45 f0             	mov    -0x10(%ebp),%eax
 765:	89 10                	mov    %edx,(%eax)
 767:	eb 26                	jmp    78f <malloc+0x96>
      else {
        p->s.size -= nunits;
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	89 c2                	mov    %eax,%edx
 771:	2b 55 ec             	sub    -0x14(%ebp),%edx
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	c1 e0 03             	shl    $0x3,%eax
 783:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 786:	8b 45 f4             	mov    -0xc(%ebp),%eax
 789:	8b 55 ec             	mov    -0x14(%ebp),%edx
 78c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	a3 38 0a 00 00       	mov    %eax,0xa38
      return (void*)(p + 1);
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	83 c0 08             	add    $0x8,%eax
 79d:	eb 38                	jmp    7d7 <malloc+0xde>
    }
    if(p == freep)
 79f:	a1 38 0a 00 00       	mov    0xa38,%eax
 7a4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7a7:	75 1b                	jne    7c4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ac:	89 04 24             	mov    %eax,(%esp)
 7af:	e8 ed fe ff ff       	call   6a1 <morecore>
 7b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7bb:	75 07                	jne    7c4 <malloc+0xcb>
        return 0;
 7bd:	b8 00 00 00 00       	mov    $0x0,%eax
 7c2:	eb 13                	jmp    7d7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 00                	mov    (%eax),%eax
 7cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7d2:	e9 70 ff ff ff       	jmp    747 <malloc+0x4e>
}
 7d7:	c9                   	leave  
 7d8:	c3                   	ret    
