
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 1d 08 00 	movl   $0x81d,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 2a 04 00 00       	call   44d <printf>
    exit();
  23:	e8 a8 02 00 00       	call   2d0 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 f5 01 00 00       	call   241 <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 ac 02 00 00       	call   300 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 69 02 00 00       	call   2d0 <exit>
  67:	90                   	nop

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	90                   	nop
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	0f b6 10             	movzbl (%eax),%edx
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	88 10                	mov    %dl,(%eax)
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	84 c0                	test   %al,%al
  ad:	0f 95 c0             	setne  %al
  b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  b8:	84 c0                	test   %al,%al
  ba:	75 de                	jne    9a <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 08                	jmp    ce <strcmp+0xd>
    p++, q++;
  c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	84 c0                	test   %al,%al
  d6:	74 10                	je     e8 <strcmp+0x27>
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	38 c2                	cmp    %al,%dl
  e6:	74 de                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	0f b6 d0             	movzbl %al,%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 c0             	movzbl %al,%eax
  fa:	89 d1                	mov    %edx,%ecx
  fc:	29 c1                	sub    %eax,%ecx
  fe:	89 c8                	mov    %ecx,%eax
}
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <strlen>:

uint
strlen(char *s)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10f:	eb 04                	jmp    115 <strlen+0x13>
 111:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 115:	8b 55 fc             	mov    -0x4(%ebp),%edx
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	01 d0                	add    %edx,%eax
 11d:	0f b6 00             	movzbl (%eax),%eax
 120:	84 c0                	test   %al,%al
 122:	75 ed                	jne    111 <strlen+0xf>
    ;
  return n;
 124:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 127:	c9                   	leave  
 128:	c3                   	ret    

00000129 <memset>:

void*
memset(void *dst, int c, uint n)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
 12c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12f:	8b 45 10             	mov    0x10(%ebp),%eax
 132:	89 44 24 08          	mov    %eax,0x8(%esp)
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	89 44 24 04          	mov    %eax,0x4(%esp)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	89 04 24             	mov    %eax,(%esp)
 143:	e8 20 ff ff ff       	call   68 <stosb>
  return dst;
 148:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14b:	c9                   	leave  
 14c:	c3                   	ret    

0000014d <strchr>:

char*
strchr(const char *s, char c)
{
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
 150:	83 ec 04             	sub    $0x4,%esp
 153:	8b 45 0c             	mov    0xc(%ebp),%eax
 156:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 159:	eb 14                	jmp    16f <strchr+0x22>
    if(*s == c)
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	3a 45 fc             	cmp    -0x4(%ebp),%al
 164:	75 05                	jne    16b <strchr+0x1e>
      return (char*)s;
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	eb 13                	jmp    17e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
 172:	0f b6 00             	movzbl (%eax),%eax
 175:	84 c0                	test   %al,%al
 177:	75 e2                	jne    15b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 179:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17e:	c9                   	leave  
 17f:	c3                   	ret    

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18d:	eb 46                	jmp    1d5 <gets+0x55>
    cc = read(0, &c, 1);
 18f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 196:	00 
 197:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19a:	89 44 24 04          	mov    %eax,0x4(%esp)
 19e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a5:	e8 3e 01 00 00       	call   2e8 <read>
 1aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b1:	7e 2f                	jle    1e2 <gets+0x62>
      break;
    buf[i++] = c;
 1b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	01 c2                	add    %eax,%edx
 1bb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bf:	88 02                	mov    %al,(%edx)
 1c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c9:	3c 0a                	cmp    $0xa,%al
 1cb:	74 16                	je     1e3 <gets+0x63>
 1cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d1:	3c 0d                	cmp    $0xd,%al
 1d3:	74 0e                	je     1e3 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d8:	83 c0 01             	add    $0x1,%eax
 1db:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1de:	7c af                	jl     18f <gets+0xf>
 1e0:	eb 01                	jmp    1e3 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	01 d0                	add    %edx,%eax
 1eb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f1:	c9                   	leave  
 1f2:	c3                   	ret    

000001f3 <stat>:

int
stat(char *n, struct stat *st)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
 1f6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 200:	00 
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	89 04 24             	mov    %eax,(%esp)
 207:	e8 04 01 00 00       	call   310 <open>
 20c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 213:	79 07                	jns    21c <stat+0x29>
    return -1;
 215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21a:	eb 23                	jmp    23f <stat+0x4c>
  r = fstat(fd, st);
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	89 44 24 04          	mov    %eax,0x4(%esp)
 223:	8b 45 f4             	mov    -0xc(%ebp),%eax
 226:	89 04 24             	mov    %eax,(%esp)
 229:	e8 fa 00 00 00       	call   328 <fstat>
 22e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 231:	8b 45 f4             	mov    -0xc(%ebp),%eax
 234:	89 04 24             	mov    %eax,(%esp)
 237:	e8 bc 00 00 00       	call   2f8 <close>
  return r;
 23c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23f:	c9                   	leave  
 240:	c3                   	ret    

00000241 <atoi>:

int
atoi(const char *s)
{
 241:	55                   	push   %ebp
 242:	89 e5                	mov    %esp,%ebp
 244:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 247:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24e:	eb 23                	jmp    273 <atoi+0x32>
    n = n*10 + *s++ - '0';
 250:	8b 55 fc             	mov    -0x4(%ebp),%edx
 253:	89 d0                	mov    %edx,%eax
 255:	c1 e0 02             	shl    $0x2,%eax
 258:	01 d0                	add    %edx,%eax
 25a:	01 c0                	add    %eax,%eax
 25c:	89 c2                	mov    %eax,%edx
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	0f be c0             	movsbl %al,%eax
 267:	01 d0                	add    %edx,%eax
 269:	83 e8 30             	sub    $0x30,%eax
 26c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 26f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	3c 2f                	cmp    $0x2f,%al
 27b:	7e 0a                	jle    287 <atoi+0x46>
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	0f b6 00             	movzbl (%eax),%eax
 283:	3c 39                	cmp    $0x39,%al
 285:	7e c9                	jle    250 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 287:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28a:	c9                   	leave  
 28b:	c3                   	ret    

0000028c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28c:	55                   	push   %ebp
 28d:	89 e5                	mov    %esp,%ebp
 28f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29e:	eb 13                	jmp    2b3 <memmove+0x27>
    *dst++ = *src++;
 2a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a3:	0f b6 10             	movzbl (%eax),%edx
 2a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a9:	88 10                	mov    %dl,(%eax)
 2ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2af:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2b7:	0f 9f c0             	setg   %al
 2ba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2be:	84 c0                	test   %al,%al
 2c0:	75 de                	jne    2a0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    
 2c7:	90                   	nop

000002c8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c8:	b8 01 00 00 00       	mov    $0x1,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <exit>:
SYSCALL(exit)
 2d0:	b8 02 00 00 00       	mov    $0x2,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <wait>:
SYSCALL(wait)
 2d8:	b8 03 00 00 00       	mov    $0x3,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <pipe>:
SYSCALL(pipe)
 2e0:	b8 04 00 00 00       	mov    $0x4,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <read>:
SYSCALL(read)
 2e8:	b8 05 00 00 00       	mov    $0x5,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <write>:
SYSCALL(write)
 2f0:	b8 10 00 00 00       	mov    $0x10,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <close>:
SYSCALL(close)
 2f8:	b8 15 00 00 00       	mov    $0x15,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <kill>:
SYSCALL(kill)
 300:	b8 06 00 00 00       	mov    $0x6,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <exec>:
SYSCALL(exec)
 308:	b8 07 00 00 00       	mov    $0x7,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <open>:
SYSCALL(open)
 310:	b8 0f 00 00 00       	mov    $0xf,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <mknod>:
SYSCALL(mknod)
 318:	b8 11 00 00 00       	mov    $0x11,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <unlink>:
SYSCALL(unlink)
 320:	b8 12 00 00 00       	mov    $0x12,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <fstat>:
SYSCALL(fstat)
 328:	b8 08 00 00 00       	mov    $0x8,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <link>:
SYSCALL(link)
 330:	b8 13 00 00 00       	mov    $0x13,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <mkdir>:
SYSCALL(mkdir)
 338:	b8 14 00 00 00       	mov    $0x14,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <chdir>:
SYSCALL(chdir)
 340:	b8 09 00 00 00       	mov    $0x9,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <dup>:
SYSCALL(dup)
 348:	b8 0a 00 00 00       	mov    $0xa,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <getpid>:
SYSCALL(getpid)
 350:	b8 0b 00 00 00       	mov    $0xb,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sbrk>:
SYSCALL(sbrk)
 358:	b8 0c 00 00 00       	mov    $0xc,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <sleep>:
SYSCALL(sleep)
 360:	b8 0d 00 00 00       	mov    $0xd,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <uptime>:
SYSCALL(uptime)
 368:	b8 0e 00 00 00       	mov    $0xe,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	83 ec 28             	sub    $0x28,%esp
 376:	8b 45 0c             	mov    0xc(%ebp),%eax
 379:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 383:	00 
 384:	8d 45 f4             	lea    -0xc(%ebp),%eax
 387:	89 44 24 04          	mov    %eax,0x4(%esp)
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	89 04 24             	mov    %eax,(%esp)
 391:	e8 5a ff ff ff       	call   2f0 <write>
}
 396:	c9                   	leave  
 397:	c3                   	ret    

00000398 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a9:	74 17                	je     3c2 <printint+0x2a>
 3ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3af:	79 11                	jns    3c2 <printint+0x2a>
    neg = 1;
 3b1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	f7 d8                	neg    %eax
 3bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c0:	eb 06                	jmp    3c8 <printint+0x30>
  } else {
    x = xx;
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d5:	ba 00 00 00 00       	mov    $0x0,%edx
 3da:	f7 f1                	div    %ecx
 3dc:	89 d0                	mov    %edx,%eax
 3de:	0f b6 80 74 0a 00 00 	movzbl 0xa74(%eax),%eax
 3e5:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3eb:	01 ca                	add    %ecx,%edx
 3ed:	88 02                	mov    %al,(%edx)
 3ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3f3:	8b 55 10             	mov    0x10(%ebp),%edx
 3f6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fc:	ba 00 00 00 00       	mov    $0x0,%edx
 401:	f7 75 d4             	divl   -0x2c(%ebp)
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
 407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40b:	75 c2                	jne    3cf <printint+0x37>
  if(neg)
 40d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 411:	74 2e                	je     441 <printint+0xa9>
    buf[i++] = '-';
 413:	8d 55 dc             	lea    -0x24(%ebp),%edx
 416:	8b 45 f4             	mov    -0xc(%ebp),%eax
 419:	01 d0                	add    %edx,%eax
 41b:	c6 00 2d             	movb   $0x2d,(%eax)
 41e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 422:	eb 1d                	jmp    441 <printint+0xa9>
    putc(fd, buf[i]);
 424:	8d 55 dc             	lea    -0x24(%ebp),%edx
 427:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42a:	01 d0                	add    %edx,%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	0f be c0             	movsbl %al,%eax
 432:	89 44 24 04          	mov    %eax,0x4(%esp)
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	89 04 24             	mov    %eax,(%esp)
 43c:	e8 2f ff ff ff       	call   370 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 441:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 445:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 449:	79 d9                	jns    424 <printint+0x8c>
    putc(fd, buf[i]);
}
 44b:	c9                   	leave  
 44c:	c3                   	ret    

0000044d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 453:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 45a:	8d 45 0c             	lea    0xc(%ebp),%eax
 45d:	83 c0 04             	add    $0x4,%eax
 460:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 463:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 46a:	e9 7d 01 00 00       	jmp    5ec <printf+0x19f>
    c = fmt[i] & 0xff;
 46f:	8b 55 0c             	mov    0xc(%ebp),%edx
 472:	8b 45 f0             	mov    -0x10(%ebp),%eax
 475:	01 d0                	add    %edx,%eax
 477:	0f b6 00             	movzbl (%eax),%eax
 47a:	0f be c0             	movsbl %al,%eax
 47d:	25 ff 00 00 00       	and    $0xff,%eax
 482:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 485:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 489:	75 2c                	jne    4b7 <printf+0x6a>
      if(c == '%'){
 48b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 48f:	75 0c                	jne    49d <printf+0x50>
        state = '%';
 491:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 498:	e9 4b 01 00 00       	jmp    5e8 <printf+0x19b>
      } else {
        putc(fd, c);
 49d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a0:	0f be c0             	movsbl %al,%eax
 4a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	89 04 24             	mov    %eax,(%esp)
 4ad:	e8 be fe ff ff       	call   370 <putc>
 4b2:	e9 31 01 00 00       	jmp    5e8 <printf+0x19b>
      }
    } else if(state == '%'){
 4b7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4bb:	0f 85 27 01 00 00    	jne    5e8 <printf+0x19b>
      if(c == 'd'){
 4c1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c5:	75 2d                	jne    4f4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ca:	8b 00                	mov    (%eax),%eax
 4cc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d3:	00 
 4d4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4db:	00 
 4dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	89 04 24             	mov    %eax,(%esp)
 4e6:	e8 ad fe ff ff       	call   398 <printint>
        ap++;
 4eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ef:	e9 ed 00 00 00       	jmp    5e1 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4f4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f8:	74 06                	je     500 <printf+0xb3>
 4fa:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4fe:	75 2d                	jne    52d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 500:	8b 45 e8             	mov    -0x18(%ebp),%eax
 503:	8b 00                	mov    (%eax),%eax
 505:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 50c:	00 
 50d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 514:	00 
 515:	89 44 24 04          	mov    %eax,0x4(%esp)
 519:	8b 45 08             	mov    0x8(%ebp),%eax
 51c:	89 04 24             	mov    %eax,(%esp)
 51f:	e8 74 fe ff ff       	call   398 <printint>
        ap++;
 524:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 528:	e9 b4 00 00 00       	jmp    5e1 <printf+0x194>
      } else if(c == 's'){
 52d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 531:	75 46                	jne    579 <printf+0x12c>
        s = (char*)*ap;
 533:	8b 45 e8             	mov    -0x18(%ebp),%eax
 536:	8b 00                	mov    (%eax),%eax
 538:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 53f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 543:	75 27                	jne    56c <printf+0x11f>
          s = "(null)";
 545:	c7 45 f4 31 08 00 00 	movl   $0x831,-0xc(%ebp)
        while(*s != 0){
 54c:	eb 1e                	jmp    56c <printf+0x11f>
          putc(fd, *s);
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	89 44 24 04          	mov    %eax,0x4(%esp)
 55b:	8b 45 08             	mov    0x8(%ebp),%eax
 55e:	89 04 24             	mov    %eax,(%esp)
 561:	e8 0a fe ff ff       	call   370 <putc>
          s++;
 566:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 56a:	eb 01                	jmp    56d <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56c:	90                   	nop
 56d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 570:	0f b6 00             	movzbl (%eax),%eax
 573:	84 c0                	test   %al,%al
 575:	75 d7                	jne    54e <printf+0x101>
 577:	eb 68                	jmp    5e1 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 579:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 57d:	75 1d                	jne    59c <printf+0x14f>
        putc(fd, *ap);
 57f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 582:	8b 00                	mov    (%eax),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	89 44 24 04          	mov    %eax,0x4(%esp)
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 da fd ff ff       	call   370 <putc>
        ap++;
 596:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59a:	eb 45                	jmp    5e1 <printf+0x194>
      } else if(c == '%'){
 59c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a0:	75 17                	jne    5b9 <printf+0x16c>
        putc(fd, c);
 5a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a5:	0f be c0             	movsbl %al,%eax
 5a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	89 04 24             	mov    %eax,(%esp)
 5b2:	e8 b9 fd ff ff       	call   370 <putc>
 5b7:	eb 28                	jmp    5e1 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c0:	00 
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	89 04 24             	mov    %eax,(%esp)
 5c7:	e8 a4 fd ff ff       	call   370 <putc>
        putc(fd, c);
 5cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	89 04 24             	mov    %eax,(%esp)
 5dc:	e8 8f fd ff ff       	call   370 <putc>
      }
      state = 0;
 5e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ec:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f2:	01 d0                	add    %edx,%eax
 5f4:	0f b6 00             	movzbl (%eax),%eax
 5f7:	84 c0                	test   %al,%al
 5f9:	0f 85 70 fe ff ff    	jne    46f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ff:	c9                   	leave  
 600:	c3                   	ret    
 601:	90                   	nop
 602:	90                   	nop
 603:	90                   	nop

00000604 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	83 e8 08             	sub    $0x8,%eax
 610:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 613:	a1 90 0a 00 00       	mov    0xa90,%eax
 618:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61b:	eb 24                	jmp    641 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 12                	ja     639 <free+0x35>
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 24                	ja     653 <free+0x4f>
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 637:	77 1a                	ja     653 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 647:	76 d4                	jbe    61d <free+0x19>
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	76 ca                	jbe    61d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	01 c2                	add    %eax,%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	39 c2                	cmp    %eax,%edx
 66c:	75 24                	jne    692 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	8b 40 04             	mov    0x4(%eax),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	eb 0a                	jmp    69c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 10                	mov    (%eax),%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	01 d0                	add    %edx,%eax
 6ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b1:	75 20                	jne    6d3 <free+0xcf>
    p->s.size += bp->s.size;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 50 04             	mov    0x4(%eax),%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	01 c2                	add    %eax,%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	89 10                	mov    %edx,(%eax)
 6d1:	eb 08                	jmp    6db <free+0xd7>
  } else
    p->s.ptr = bp;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 6e3:	c9                   	leave  
 6e4:	c3                   	ret    

000006e5 <morecore>:

static Header*
morecore(uint nu)
{
 6e5:	55                   	push   %ebp
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6eb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f2:	77 07                	ja     6fb <morecore+0x16>
    nu = 4096;
 6f4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	c1 e0 03             	shl    $0x3,%eax
 701:	89 04 24             	mov    %eax,(%esp)
 704:	e8 4f fc ff ff       	call   358 <sbrk>
 709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 710:	75 07                	jne    719 <morecore+0x34>
    return 0;
 712:	b8 00 00 00 00       	mov    $0x0,%eax
 717:	eb 22                	jmp    73b <morecore+0x56>
  hp = (Header*)p;
 719:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	8b 55 08             	mov    0x8(%ebp),%edx
 725:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72b:	83 c0 08             	add    $0x8,%eax
 72e:	89 04 24             	mov    %eax,(%esp)
 731:	e8 ce fe ff ff       	call   604 <free>
  return freep;
 736:	a1 90 0a 00 00       	mov    0xa90,%eax
}
 73b:	c9                   	leave  
 73c:	c3                   	ret    

0000073d <malloc>:

void*
malloc(uint nbytes)
{
 73d:	55                   	push   %ebp
 73e:	89 e5                	mov    %esp,%ebp
 740:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	83 c0 07             	add    $0x7,%eax
 749:	c1 e8 03             	shr    $0x3,%eax
 74c:	83 c0 01             	add    $0x1,%eax
 74f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 752:	a1 90 0a 00 00       	mov    0xa90,%eax
 757:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75e:	75 23                	jne    783 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 760:	c7 45 f0 88 0a 00 00 	movl   $0xa88,-0x10(%ebp)
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	a3 90 0a 00 00       	mov    %eax,0xa90
 76f:	a1 90 0a 00 00       	mov    0xa90,%eax
 774:	a3 88 0a 00 00       	mov    %eax,0xa88
    base.s.size = 0;
 779:	c7 05 8c 0a 00 00 00 	movl   $0x0,0xa8c
 780:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 794:	72 4d                	jb     7e3 <malloc+0xa6>
      if(p->s.size == nunits)
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79f:	75 0c                	jne    7ad <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	89 10                	mov    %edx,(%eax)
 7ab:	eb 26                	jmp    7d3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	89 c2                	mov    %eax,%edx
 7b5:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	c1 e0 03             	shl    $0x3,%eax
 7c7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	a3 90 0a 00 00       	mov    %eax,0xa90
      return (void*)(p + 1);
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	83 c0 08             	add    $0x8,%eax
 7e1:	eb 38                	jmp    81b <malloc+0xde>
    }
    if(p == freep)
 7e3:	a1 90 0a 00 00       	mov    0xa90,%eax
 7e8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7eb:	75 1b                	jne    808 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f0:	89 04 24             	mov    %eax,(%esp)
 7f3:	e8 ed fe ff ff       	call   6e5 <morecore>
 7f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ff:	75 07                	jne    808 <malloc+0xcb>
        return 0;
 801:	b8 00 00 00 00       	mov    $0x0,%eax
 806:	eb 13                	jmp    81b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 816:	e9 70 ff ff ff       	jmp    78b <malloc+0x4e>
}
 81b:	c9                   	leave  
 81c:	c3                   	ret    
