
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 21 08 00 00       	mov    $0x821,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 23 08 00 00       	mov    $0x823,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 25 08 00 	movl   $0x825,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 f8 03 00 00       	call   451 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 68 02 00 00       	call   2d4 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	0f b6 10             	movzbl (%eax),%edx
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	88 10                	mov    %dl,(%eax)
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	84 c0                	test   %al,%al
  b1:	0f 95 c0             	setne  %al
  b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  bc:	84 c0                	test   %al,%al
  be:	75 de                	jne    9e <strcpy+0xd>
    ;
  return os;
  c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c3:	c9                   	leave  
  c4:	c3                   	ret    

000000c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c8:	eb 08                	jmp    d2 <strcmp+0xd>
    p++, q++;
  ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ce:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 00             	movzbl (%eax),%eax
  d8:	84 c0                	test   %al,%al
  da:	74 10                	je     ec <strcmp+0x27>
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 10             	movzbl (%eax),%edx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	38 c2                	cmp    %al,%dl
  ea:	74 de                	je     ca <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 d0             	movzbl %al,%edx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 c0             	movzbl %al,%eax
  fe:	89 d1                	mov    %edx,%ecx
 100:	29 c1                	sub    %eax,%ecx
 102:	89 c8                	mov    %ecx,%eax
}
 104:	5d                   	pop    %ebp
 105:	c3                   	ret    

00000106 <strlen>:

uint
strlen(char *s)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 113:	eb 04                	jmp    119 <strlen+0x13>
 115:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 119:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	01 d0                	add    %edx,%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	84 c0                	test   %al,%al
 126:	75 ed                	jne    115 <strlen+0xf>
    ;
  return n;
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <memset>:

void*
memset(void *dst, int c, uint n)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	89 44 24 08          	mov    %eax,0x8(%esp)
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 44 24 04          	mov    %eax,0x4(%esp)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	89 04 24             	mov    %eax,(%esp)
 147:	e8 20 ff ff ff       	call   6c <stosb>
  return dst;
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <strchr>:

char*
strchr(const char *s, char c)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 04             	sub    $0x4,%esp
 157:	8b 45 0c             	mov    0xc(%ebp),%eax
 15a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15d:	eb 14                	jmp    173 <strchr+0x22>
    if(*s == c)
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	0f b6 00             	movzbl (%eax),%eax
 165:	3a 45 fc             	cmp    -0x4(%ebp),%al
 168:	75 05                	jne    16f <strchr+0x1e>
      return (char*)s;
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	eb 13                	jmp    182 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	84 c0                	test   %al,%al
 17b:	75 e2                	jne    15f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 182:	c9                   	leave  
 183:	c3                   	ret    

00000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 191:	eb 46                	jmp    1d9 <gets+0x55>
    cc = read(0, &c, 1);
 193:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 19a:	00 
 19b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19e:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a9:	e8 3e 01 00 00       	call   2ec <read>
 1ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b5:	7e 2f                	jle    1e6 <gets+0x62>
      break;
    buf[i++] = c;
 1b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 c2                	add    %eax,%edx
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	88 02                	mov    %al,(%edx)
 1c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	3c 0a                	cmp    $0xa,%al
 1cf:	74 16                	je     1e7 <gets+0x63>
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0e                	je     1e7 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e2:	7c af                	jl     193 <gets+0xf>
 1e4:	eb 01                	jmp    1e7 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 d0                	add    %edx,%eax
 1ef:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <stat>:

int
stat(char *n, struct stat *st)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 204:	00 
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	89 04 24             	mov    %eax,(%esp)
 20b:	e8 04 01 00 00       	call   314 <open>
 210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 217:	79 07                	jns    220 <stat+0x29>
    return -1;
 219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21e:	eb 23                	jmp    243 <stat+0x4c>
  r = fstat(fd, st);
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	89 44 24 04          	mov    %eax,0x4(%esp)
 227:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22a:	89 04 24             	mov    %eax,(%esp)
 22d:	e8 fa 00 00 00       	call   32c <fstat>
 232:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	89 04 24             	mov    %eax,(%esp)
 23b:	e8 bc 00 00 00       	call   2fc <close>
  return r;
 240:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 243:	c9                   	leave  
 244:	c3                   	ret    

00000245 <atoi>:

int
atoi(const char *s)
{
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 24b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 252:	eb 23                	jmp    277 <atoi+0x32>
    n = n*10 + *s++ - '0';
 254:	8b 55 fc             	mov    -0x4(%ebp),%edx
 257:	89 d0                	mov    %edx,%eax
 259:	c1 e0 02             	shl    $0x2,%eax
 25c:	01 d0                	add    %edx,%eax
 25e:	01 c0                	add    %eax,%eax
 260:	89 c2                	mov    %eax,%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	0f be c0             	movsbl %al,%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	83 e8 30             	sub    $0x30,%eax
 270:	89 45 fc             	mov    %eax,-0x4(%ebp)
 273:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 2f                	cmp    $0x2f,%al
 27f:	7e 0a                	jle    28b <atoi+0x46>
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 39                	cmp    $0x39,%al
 289:	7e c9                	jle    254 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28e:	c9                   	leave  
 28f:	c3                   	ret    

00000290 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29c:	8b 45 0c             	mov    0xc(%ebp),%eax
 29f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a2:	eb 13                	jmp    2b7 <memmove+0x27>
    *dst++ = *src++;
 2a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a7:	0f b6 10             	movzbl (%eax),%edx
 2aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ad:	88 10                	mov    %dl,(%eax)
 2af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2b3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2bb:	0f 9f c0             	setg   %al
 2be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2c2:	84 c0                	test   %al,%al
 2c4:	75 de                	jne    2a4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    
 2cb:	90                   	nop

000002cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cc:	b8 01 00 00 00       	mov    $0x1,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exit>:
SYSCALL(exit)
 2d4:	b8 02 00 00 00       	mov    $0x2,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <wait>:
SYSCALL(wait)
 2dc:	b8 03 00 00 00       	mov    $0x3,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <pipe>:
SYSCALL(pipe)
 2e4:	b8 04 00 00 00       	mov    $0x4,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <read>:
SYSCALL(read)
 2ec:	b8 05 00 00 00       	mov    $0x5,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <write>:
SYSCALL(write)
 2f4:	b8 10 00 00 00       	mov    $0x10,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <close>:
SYSCALL(close)
 2fc:	b8 15 00 00 00       	mov    $0x15,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <kill>:
SYSCALL(kill)
 304:	b8 06 00 00 00       	mov    $0x6,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <exec>:
SYSCALL(exec)
 30c:	b8 07 00 00 00       	mov    $0x7,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <open>:
SYSCALL(open)
 314:	b8 0f 00 00 00       	mov    $0xf,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <mknod>:
SYSCALL(mknod)
 31c:	b8 11 00 00 00       	mov    $0x11,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <unlink>:
SYSCALL(unlink)
 324:	b8 12 00 00 00       	mov    $0x12,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <fstat>:
SYSCALL(fstat)
 32c:	b8 08 00 00 00       	mov    $0x8,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <link>:
SYSCALL(link)
 334:	b8 13 00 00 00       	mov    $0x13,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <mkdir>:
SYSCALL(mkdir)
 33c:	b8 14 00 00 00       	mov    $0x14,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <chdir>:
SYSCALL(chdir)
 344:	b8 09 00 00 00       	mov    $0x9,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <dup>:
SYSCALL(dup)
 34c:	b8 0a 00 00 00       	mov    $0xa,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <getpid>:
SYSCALL(getpid)
 354:	b8 0b 00 00 00       	mov    $0xb,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <sbrk>:
SYSCALL(sbrk)
 35c:	b8 0c 00 00 00       	mov    $0xc,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <sleep>:
SYSCALL(sleep)
 364:	b8 0d 00 00 00       	mov    $0xd,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <uptime>:
SYSCALL(uptime)
 36c:	b8 0e 00 00 00       	mov    $0xe,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 28             	sub    $0x28,%esp
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 380:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 387:	00 
 388:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38b:	89 44 24 04          	mov    %eax,0x4(%esp)
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	89 04 24             	mov    %eax,(%esp)
 395:	e8 5a ff ff ff       	call   2f4 <write>
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ad:	74 17                	je     3c6 <printint+0x2a>
 3af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b3:	79 11                	jns    3c6 <printint+0x2a>
    neg = 1;
 3b5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	f7 d8                	neg    %eax
 3c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c4:	eb 06                	jmp    3cc <printint+0x30>
  } else {
    x = xx;
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d9:	ba 00 00 00 00       	mov    $0x0,%edx
 3de:	f7 f1                	div    %ecx
 3e0:	89 d0                	mov    %edx,%eax
 3e2:	0f b6 80 70 0a 00 00 	movzbl 0xa70(%eax),%eax
 3e9:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ef:	01 ca                	add    %ecx,%edx
 3f1:	88 02                	mov    %al,(%edx)
 3f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3f7:	8b 55 10             	mov    0x10(%ebp),%edx
 3fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 400:	ba 00 00 00 00       	mov    $0x0,%edx
 405:	f7 75 d4             	divl   -0x2c(%ebp)
 408:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40f:	75 c2                	jne    3d3 <printint+0x37>
  if(neg)
 411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 415:	74 2e                	je     445 <printint+0xa9>
    buf[i++] = '-';
 417:	8d 55 dc             	lea    -0x24(%ebp),%edx
 41a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41d:	01 d0                	add    %edx,%eax
 41f:	c6 00 2d             	movb   $0x2d,(%eax)
 422:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 426:	eb 1d                	jmp    445 <printint+0xa9>
    putc(fd, buf[i]);
 428:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42e:	01 d0                	add    %edx,%eax
 430:	0f b6 00             	movzbl (%eax),%eax
 433:	0f be c0             	movsbl %al,%eax
 436:	89 44 24 04          	mov    %eax,0x4(%esp)
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	89 04 24             	mov    %eax,(%esp)
 440:	e8 2f ff ff ff       	call   374 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 445:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44d:	79 d9                	jns    428 <printint+0x8c>
    putc(fd, buf[i]);
}
 44f:	c9                   	leave  
 450:	c3                   	ret    

00000451 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 457:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 45e:	8d 45 0c             	lea    0xc(%ebp),%eax
 461:	83 c0 04             	add    $0x4,%eax
 464:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 46e:	e9 7d 01 00 00       	jmp    5f0 <printf+0x19f>
    c = fmt[i] & 0xff;
 473:	8b 55 0c             	mov    0xc(%ebp),%edx
 476:	8b 45 f0             	mov    -0x10(%ebp),%eax
 479:	01 d0                	add    %edx,%eax
 47b:	0f b6 00             	movzbl (%eax),%eax
 47e:	0f be c0             	movsbl %al,%eax
 481:	25 ff 00 00 00       	and    $0xff,%eax
 486:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 489:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48d:	75 2c                	jne    4bb <printf+0x6a>
      if(c == '%'){
 48f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 493:	75 0c                	jne    4a1 <printf+0x50>
        state = '%';
 495:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49c:	e9 4b 01 00 00       	jmp    5ec <printf+0x19b>
      } else {
        putc(fd, c);
 4a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a4:	0f be c0             	movsbl %al,%eax
 4a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	89 04 24             	mov    %eax,(%esp)
 4b1:	e8 be fe ff ff       	call   374 <putc>
 4b6:	e9 31 01 00 00       	jmp    5ec <printf+0x19b>
      }
    } else if(state == '%'){
 4bb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4bf:	0f 85 27 01 00 00    	jne    5ec <printf+0x19b>
      if(c == 'd'){
 4c5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c9:	75 2d                	jne    4f8 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ce:	8b 00                	mov    (%eax),%eax
 4d0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d7:	00 
 4d8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4df:	00 
 4e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	89 04 24             	mov    %eax,(%esp)
 4ea:	e8 ad fe ff ff       	call   39c <printint>
        ap++;
 4ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f3:	e9 ed 00 00 00       	jmp    5e5 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4f8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fc:	74 06                	je     504 <printf+0xb3>
 4fe:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 502:	75 2d                	jne    531 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 504:	8b 45 e8             	mov    -0x18(%ebp),%eax
 507:	8b 00                	mov    (%eax),%eax
 509:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 510:	00 
 511:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 518:	00 
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	89 04 24             	mov    %eax,(%esp)
 523:	e8 74 fe ff ff       	call   39c <printint>
        ap++;
 528:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52c:	e9 b4 00 00 00       	jmp    5e5 <printf+0x194>
      } else if(c == 's'){
 531:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 535:	75 46                	jne    57d <printf+0x12c>
        s = (char*)*ap;
 537:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 547:	75 27                	jne    570 <printf+0x11f>
          s = "(null)";
 549:	c7 45 f4 2a 08 00 00 	movl   $0x82a,-0xc(%ebp)
        while(*s != 0){
 550:	eb 1e                	jmp    570 <printf+0x11f>
          putc(fd, *s);
 552:	8b 45 f4             	mov    -0xc(%ebp),%eax
 555:	0f b6 00             	movzbl (%eax),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	89 44 24 04          	mov    %eax,0x4(%esp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 0a fe ff ff       	call   374 <putc>
          s++;
 56a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 56e:	eb 01                	jmp    571 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 570:	90                   	nop
 571:	8b 45 f4             	mov    -0xc(%ebp),%eax
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	84 c0                	test   %al,%al
 579:	75 d7                	jne    552 <printf+0x101>
 57b:	eb 68                	jmp    5e5 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 581:	75 1d                	jne    5a0 <printf+0x14f>
        putc(fd, *ap);
 583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 586:	8b 00                	mov    (%eax),%eax
 588:	0f be c0             	movsbl %al,%eax
 58b:	89 44 24 04          	mov    %eax,0x4(%esp)
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 da fd ff ff       	call   374 <putc>
        ap++;
 59a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59e:	eb 45                	jmp    5e5 <printf+0x194>
      } else if(c == '%'){
 5a0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a4:	75 17                	jne    5bd <printf+0x16c>
        putc(fd, c);
 5a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	89 04 24             	mov    %eax,(%esp)
 5b6:	e8 b9 fd ff ff       	call   374 <putc>
 5bb:	eb 28                	jmp    5e5 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5bd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c4:	00 
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 a4 fd ff ff       	call   374 <putc>
        putc(fd, c);
 5d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 8f fd ff ff       	call   374 <putc>
      }
      state = 0;
 5e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f6:	01 d0                	add    %edx,%eax
 5f8:	0f b6 00             	movzbl (%eax),%eax
 5fb:	84 c0                	test   %al,%al
 5fd:	0f 85 70 fe ff ff    	jne    473 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 603:	c9                   	leave  
 604:	c3                   	ret    
 605:	90                   	nop
 606:	90                   	nop
 607:	90                   	nop

00000608 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	83 e8 08             	sub    $0x8,%eax
 614:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 617:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 61c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61f:	eb 24                	jmp    645 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 629:	77 12                	ja     63d <free+0x35>
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 631:	77 24                	ja     657 <free+0x4f>
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63b:	77 1a                	ja     657 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	89 45 fc             	mov    %eax,-0x4(%ebp)
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64b:	76 d4                	jbe    621 <free+0x19>
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 655:	76 ca                	jbe    621 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	8b 40 04             	mov    0x4(%eax),%eax
 65d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	01 c2                	add    %eax,%edx
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	39 c2                	cmp    %eax,%edx
 670:	75 24                	jne    696 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	8b 50 04             	mov    0x4(%eax),%edx
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	8b 40 04             	mov    0x4(%eax),%eax
 680:	01 c2                	add    %eax,%edx
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	8b 10                	mov    (%eax),%edx
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	89 10                	mov    %edx,(%eax)
 694:	eb 0a                	jmp    6a0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 10                	mov    (%eax),%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 40 04             	mov    0x4(%eax),%eax
 6a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	01 d0                	add    %edx,%eax
 6b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b5:	75 20                	jne    6d7 <free+0xcf>
    p->s.size += bp->s.size;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 50 04             	mov    0x4(%eax),%edx
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	8b 40 04             	mov    0x4(%eax),%eax
 6c3:	01 c2                	add    %eax,%edx
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	8b 10                	mov    (%eax),%edx
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	89 10                	mov    %edx,(%eax)
 6d5:	eb 08                	jmp    6df <free+0xd7>
  } else
    p->s.ptr = bp;
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6dd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	a3 8c 0a 00 00       	mov    %eax,0xa8c
}
 6e7:	c9                   	leave  
 6e8:	c3                   	ret    

000006e9 <morecore>:

static Header*
morecore(uint nu)
{
 6e9:	55                   	push   %ebp
 6ea:	89 e5                	mov    %esp,%ebp
 6ec:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ef:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f6:	77 07                	ja     6ff <morecore+0x16>
    nu = 4096;
 6f8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ff:	8b 45 08             	mov    0x8(%ebp),%eax
 702:	c1 e0 03             	shl    $0x3,%eax
 705:	89 04 24             	mov    %eax,(%esp)
 708:	e8 4f fc ff ff       	call   35c <sbrk>
 70d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 710:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 714:	75 07                	jne    71d <morecore+0x34>
    return 0;
 716:	b8 00 00 00 00       	mov    $0x0,%eax
 71b:	eb 22                	jmp    73f <morecore+0x56>
  hp = (Header*)p;
 71d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 720:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 723:	8b 45 f0             	mov    -0x10(%ebp),%eax
 726:	8b 55 08             	mov    0x8(%ebp),%edx
 729:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 72c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72f:	83 c0 08             	add    $0x8,%eax
 732:	89 04 24             	mov    %eax,(%esp)
 735:	e8 ce fe ff ff       	call   608 <free>
  return freep;
 73a:	a1 8c 0a 00 00       	mov    0xa8c,%eax
}
 73f:	c9                   	leave  
 740:	c3                   	ret    

00000741 <malloc>:

void*
malloc(uint nbytes)
{
 741:	55                   	push   %ebp
 742:	89 e5                	mov    %esp,%ebp
 744:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 747:	8b 45 08             	mov    0x8(%ebp),%eax
 74a:	83 c0 07             	add    $0x7,%eax
 74d:	c1 e8 03             	shr    $0x3,%eax
 750:	83 c0 01             	add    $0x1,%eax
 753:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 756:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 75b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 762:	75 23                	jne    787 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 764:	c7 45 f0 84 0a 00 00 	movl   $0xa84,-0x10(%ebp)
 76b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76e:	a3 8c 0a 00 00       	mov    %eax,0xa8c
 773:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 778:	a3 84 0a 00 00       	mov    %eax,0xa84
    base.s.size = 0;
 77d:	c7 05 88 0a 00 00 00 	movl   $0x0,0xa88
 784:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 798:	72 4d                	jb     7e7 <malloc+0xa6>
      if(p->s.size == nunits)
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	8b 40 04             	mov    0x4(%eax),%eax
 7a0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a3:	75 0c                	jne    7b1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8b 10                	mov    (%eax),%edx
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ad:	89 10                	mov    %edx,(%eax)
 7af:	eb 26                	jmp    7d7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	89 c2                	mov    %eax,%edx
 7b9:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	c1 e0 03             	shl    $0x3,%eax
 7cb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	a3 8c 0a 00 00       	mov    %eax,0xa8c
      return (void*)(p + 1);
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	83 c0 08             	add    $0x8,%eax
 7e5:	eb 38                	jmp    81f <malloc+0xde>
    }
    if(p == freep)
 7e7:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 7ec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ef:	75 1b                	jne    80c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f4:	89 04 24             	mov    %eax,(%esp)
 7f7:	e8 ed fe ff ff       	call   6e9 <morecore>
 7fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 803:	75 07                	jne    80c <malloc+0xcb>
        return 0;
 805:	b8 00 00 00 00       	mov    $0x0,%eax
 80a:	eb 13                	jmp    81f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	8b 00                	mov    (%eax),%eax
 817:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 81a:	e9 70 ff ff ff       	jmp    78f <malloc+0x4e>
}
 81f:	c9                   	leave  
 820:	c3                   	ret    
