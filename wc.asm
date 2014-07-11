
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 60 0c 00 00       	add    $0xc60,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 60 0c 00 00       	add    $0xc60,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 91 09 00 00 	movl   $0x991,(%esp)
  5b:	e8 61 02 00 00       	call   2c1 <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 60 0c 00 	movl   $0xc60,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 b7 03 00 00       	call   45c <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 97 09 00 	movl   $0x997,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 f5 04 00 00       	call   5c1 <printf>
    exit();
  cc:	e8 73 03 00 00       	call   444 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 14          	mov    %eax,0x14(%esp)
  d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  db:	89 44 24 10          	mov    %eax,0x10(%esp)
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	c7 44 24 04 a7 09 00 	movl   $0x9a7,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 c0 04 00 00       	call   5c1 <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
 112:	c7 44 24 04 b4 09 00 	movl   $0x9b4,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 19 03 00 00       	call   444 <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
 138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	8b 00                	mov    (%eax),%eax
 14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 151:	00 
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 2a 03 00 00       	call   484 <open>
 15a:	89 44 24 18          	mov    %eax,0x18(%esp)
 15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 163:	79 2f                	jns    194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	8b 00                	mov    (%eax),%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	c7 44 24 04 b5 09 00 	movl   $0x9b5,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 32 04 00 00       	call   5c1 <printf>
      exit();
 18f:	e8 b0 02 00 00       	call   444 <exit>
    }
    wc(fd, argv[i]);
 194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8b 00                	mov    (%eax),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
 1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 aa 02 00 00       	call   46c <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1d4:	e8 6b 02 00 00       	call   444 <exit>
 1d9:	90                   	nop
 1da:	90                   	nop
 1db:	90                   	nop

000001dc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	57                   	push   %edi
 1e0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e4:	8b 55 10             	mov    0x10(%ebp),%edx
 1e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ea:	89 cb                	mov    %ecx,%ebx
 1ec:	89 df                	mov    %ebx,%edi
 1ee:	89 d1                	mov    %edx,%ecx
 1f0:	fc                   	cld    
 1f1:	f3 aa                	rep stos %al,%es:(%edi)
 1f3:	89 ca                	mov    %ecx,%edx
 1f5:	89 fb                	mov    %edi,%ebx
 1f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1fa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fd:	5b                   	pop    %ebx
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    

00000201 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 20d:	90                   	nop
 20e:	8b 45 0c             	mov    0xc(%ebp),%eax
 211:	0f b6 10             	movzbl (%eax),%edx
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	88 10                	mov    %dl,(%eax)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	84 c0                	test   %al,%al
 221:	0f 95 c0             	setne  %al
 224:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 228:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 22c:	84 c0                	test   %al,%al
 22e:	75 de                	jne    20e <strcpy+0xd>
    ;
  return os;
 230:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 233:	c9                   	leave  
 234:	c3                   	ret    

00000235 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 238:	eb 08                	jmp    242 <strcmp+0xd>
    p++, q++;
 23a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	0f b6 00             	movzbl (%eax),%eax
 248:	84 c0                	test   %al,%al
 24a:	74 10                	je     25c <strcmp+0x27>
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	0f b6 10             	movzbl (%eax),%edx
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	0f b6 00             	movzbl (%eax),%eax
 258:	38 c2                	cmp    %al,%dl
 25a:	74 de                	je     23a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f b6 d0             	movzbl %al,%edx
 265:	8b 45 0c             	mov    0xc(%ebp),%eax
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	0f b6 c0             	movzbl %al,%eax
 26e:	89 d1                	mov    %edx,%ecx
 270:	29 c1                	sub    %eax,%ecx
 272:	89 c8                	mov    %ecx,%eax
}
 274:	5d                   	pop    %ebp
 275:	c3                   	ret    

00000276 <strlen>:

uint
strlen(char *s)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 27c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 283:	eb 04                	jmp    289 <strlen+0x13>
 285:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 289:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	01 d0                	add    %edx,%eax
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	84 c0                	test   %al,%al
 296:	75 ed                	jne    285 <strlen+0xf>
    ;
  return n;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <memset>:

void*
memset(void *dst, int c, uint n)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2a3:	8b 45 10             	mov    0x10(%ebp),%eax
 2a6:	89 44 24 08          	mov    %eax,0x8(%esp)
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	89 04 24             	mov    %eax,(%esp)
 2b7:	e8 20 ff ff ff       	call   1dc <stosb>
  return dst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <strchr>:

char*
strchr(const char *s, char c)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	83 ec 04             	sub    $0x4,%esp
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2cd:	eb 14                	jmp    2e3 <strchr+0x22>
    if(*s == c)
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2d8:	75 05                	jne    2df <strchr+0x1e>
      return (char*)s;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	eb 13                	jmp    2f2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	84 c0                	test   %al,%al
 2eb:	75 e2                	jne    2cf <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <gets>:

char*
gets(char *buf, int max)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 301:	eb 46                	jmp    349 <gets+0x55>
    cc = read(0, &c, 1);
 303:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 30a:	00 
 30b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 30e:	89 44 24 04          	mov    %eax,0x4(%esp)
 312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 319:	e8 3e 01 00 00       	call   45c <read>
 31e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 321:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 325:	7e 2f                	jle    356 <gets+0x62>
      break;
    buf[i++] = c;
 327:	8b 55 f4             	mov    -0xc(%ebp),%edx
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	01 c2                	add    %eax,%edx
 32f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 333:	88 02                	mov    %al,(%edx)
 335:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 339:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33d:	3c 0a                	cmp    $0xa,%al
 33f:	74 16                	je     357 <gets+0x63>
 341:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 345:	3c 0d                	cmp    $0xd,%al
 347:	74 0e                	je     357 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 349:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34c:	83 c0 01             	add    $0x1,%eax
 34f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 352:	7c af                	jl     303 <gets+0xf>
 354:	eb 01                	jmp    357 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 356:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 357:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	01 d0                	add    %edx,%eax
 35f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
}
 365:	c9                   	leave  
 366:	c3                   	ret    

00000367 <stat>:

int
stat(char *n, struct stat *st)
{
 367:	55                   	push   %ebp
 368:	89 e5                	mov    %esp,%ebp
 36a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 374:	00 
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	89 04 24             	mov    %eax,(%esp)
 37b:	e8 04 01 00 00       	call   484 <open>
 380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 383:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 387:	79 07                	jns    390 <stat+0x29>
    return -1;
 389:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38e:	eb 23                	jmp    3b3 <stat+0x4c>
  r = fstat(fd, st);
 390:	8b 45 0c             	mov    0xc(%ebp),%eax
 393:	89 44 24 04          	mov    %eax,0x4(%esp)
 397:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39a:	89 04 24             	mov    %eax,(%esp)
 39d:	e8 fa 00 00 00       	call   49c <fstat>
 3a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a8:	89 04 24             	mov    %eax,(%esp)
 3ab:	e8 bc 00 00 00       	call   46c <close>
  return r;
 3b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <atoi>:

int
atoi(const char *s)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c2:	eb 23                	jmp    3e7 <atoi+0x32>
    n = n*10 + *s++ - '0';
 3c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c7:	89 d0                	mov    %edx,%eax
 3c9:	c1 e0 02             	shl    $0x2,%eax
 3cc:	01 d0                	add    %edx,%eax
 3ce:	01 c0                	add    %eax,%eax
 3d0:	89 c2                	mov    %eax,%edx
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	0f be c0             	movsbl %al,%eax
 3db:	01 d0                	add    %edx,%eax
 3dd:	83 e8 30             	sub    $0x30,%eax
 3e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	0f b6 00             	movzbl (%eax),%eax
 3ed:	3c 2f                	cmp    $0x2f,%al
 3ef:	7e 0a                	jle    3fb <atoi+0x46>
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	0f b6 00             	movzbl (%eax),%eax
 3f7:	3c 39                	cmp    $0x39,%al
 3f9:	7e c9                	jle    3c4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fe:	c9                   	leave  
 3ff:	c3                   	ret    

00000400 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 40c:	8b 45 0c             	mov    0xc(%ebp),%eax
 40f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 412:	eb 13                	jmp    427 <memmove+0x27>
    *dst++ = *src++;
 414:	8b 45 f8             	mov    -0x8(%ebp),%eax
 417:	0f b6 10             	movzbl (%eax),%edx
 41a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41d:	88 10                	mov    %dl,(%eax)
 41f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 423:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 42b:	0f 9f c0             	setg   %al
 42e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 432:	84 c0                	test   %al,%al
 434:	75 de                	jne    414 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 436:	8b 45 08             	mov    0x8(%ebp),%eax
}
 439:	c9                   	leave  
 43a:	c3                   	ret    
 43b:	90                   	nop

0000043c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 43c:	b8 01 00 00 00       	mov    $0x1,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <exit>:
SYSCALL(exit)
 444:	b8 02 00 00 00       	mov    $0x2,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <wait>:
SYSCALL(wait)
 44c:	b8 03 00 00 00       	mov    $0x3,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <pipe>:
SYSCALL(pipe)
 454:	b8 04 00 00 00       	mov    $0x4,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <read>:
SYSCALL(read)
 45c:	b8 05 00 00 00       	mov    $0x5,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <write>:
SYSCALL(write)
 464:	b8 10 00 00 00       	mov    $0x10,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <close>:
SYSCALL(close)
 46c:	b8 15 00 00 00       	mov    $0x15,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <kill>:
SYSCALL(kill)
 474:	b8 06 00 00 00       	mov    $0x6,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <exec>:
SYSCALL(exec)
 47c:	b8 07 00 00 00       	mov    $0x7,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <open>:
SYSCALL(open)
 484:	b8 0f 00 00 00       	mov    $0xf,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <mknod>:
SYSCALL(mknod)
 48c:	b8 11 00 00 00       	mov    $0x11,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <unlink>:
SYSCALL(unlink)
 494:	b8 12 00 00 00       	mov    $0x12,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <fstat>:
SYSCALL(fstat)
 49c:	b8 08 00 00 00       	mov    $0x8,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <link>:
SYSCALL(link)
 4a4:	b8 13 00 00 00       	mov    $0x13,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <mkdir>:
SYSCALL(mkdir)
 4ac:	b8 14 00 00 00       	mov    $0x14,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <chdir>:
SYSCALL(chdir)
 4b4:	b8 09 00 00 00       	mov    $0x9,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <dup>:
SYSCALL(dup)
 4bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <getpid>:
SYSCALL(getpid)
 4c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <sbrk>:
SYSCALL(sbrk)
 4cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <sleep>:
SYSCALL(sleep)
 4d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <uptime>:
SYSCALL(uptime)
 4dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	83 ec 28             	sub    $0x28,%esp
 4ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ed:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f7:	00 
 4f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	89 04 24             	mov    %eax,(%esp)
 505:	e8 5a ff ff ff       	call   464 <write>
}
 50a:	c9                   	leave  
 50b:	c3                   	ret    

0000050c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 512:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 519:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 51d:	74 17                	je     536 <printint+0x2a>
 51f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 523:	79 11                	jns    536 <printint+0x2a>
    neg = 1;
 525:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 52c:	8b 45 0c             	mov    0xc(%ebp),%eax
 52f:	f7 d8                	neg    %eax
 531:	89 45 ec             	mov    %eax,-0x14(%ebp)
 534:	eb 06                	jmp    53c <printint+0x30>
  } else {
    x = xx;
 536:	8b 45 0c             	mov    0xc(%ebp),%eax
 539:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 53c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 543:	8b 4d 10             	mov    0x10(%ebp),%ecx
 546:	8b 45 ec             	mov    -0x14(%ebp),%eax
 549:	ba 00 00 00 00       	mov    $0x0,%edx
 54e:	f7 f1                	div    %ecx
 550:	89 d0                	mov    %edx,%eax
 552:	0f b6 80 2c 0c 00 00 	movzbl 0xc2c(%eax),%eax
 559:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 55c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 55f:	01 ca                	add    %ecx,%edx
 561:	88 02                	mov    %al,(%edx)
 563:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 567:	8b 55 10             	mov    0x10(%ebp),%edx
 56a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 56d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 570:	ba 00 00 00 00       	mov    $0x0,%edx
 575:	f7 75 d4             	divl   -0x2c(%ebp)
 578:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57f:	75 c2                	jne    543 <printint+0x37>
  if(neg)
 581:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 585:	74 2e                	je     5b5 <printint+0xa9>
    buf[i++] = '-';
 587:	8d 55 dc             	lea    -0x24(%ebp),%edx
 58a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58d:	01 d0                	add    %edx,%eax
 58f:	c6 00 2d             	movb   $0x2d,(%eax)
 592:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 596:	eb 1d                	jmp    5b5 <printint+0xa9>
    putc(fd, buf[i]);
 598:	8d 55 dc             	lea    -0x24(%ebp),%edx
 59b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59e:	01 d0                	add    %edx,%eax
 5a0:	0f b6 00             	movzbl (%eax),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	89 04 24             	mov    %eax,(%esp)
 5b0:	e8 2f ff ff ff       	call   4e4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5b5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bd:	79 d9                	jns    598 <printint+0x8c>
    putc(fd, buf[i]);
}
 5bf:	c9                   	leave  
 5c0:	c3                   	ret    

000005c1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5c1:	55                   	push   %ebp
 5c2:	89 e5                	mov    %esp,%ebp
 5c4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ce:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d1:	83 c0 04             	add    $0x4,%eax
 5d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5de:	e9 7d 01 00 00       	jmp    760 <printf+0x19f>
    c = fmt[i] & 0xff;
 5e3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e9:	01 d0                	add    %edx,%eax
 5eb:	0f b6 00             	movzbl (%eax),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	25 ff 00 00 00       	and    $0xff,%eax
 5f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5fd:	75 2c                	jne    62b <printf+0x6a>
      if(c == '%'){
 5ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 603:	75 0c                	jne    611 <printf+0x50>
        state = '%';
 605:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 60c:	e9 4b 01 00 00       	jmp    75c <printf+0x19b>
      } else {
        putc(fd, c);
 611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 614:	0f be c0             	movsbl %al,%eax
 617:	89 44 24 04          	mov    %eax,0x4(%esp)
 61b:	8b 45 08             	mov    0x8(%ebp),%eax
 61e:	89 04 24             	mov    %eax,(%esp)
 621:	e8 be fe ff ff       	call   4e4 <putc>
 626:	e9 31 01 00 00       	jmp    75c <printf+0x19b>
      }
    } else if(state == '%'){
 62b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 62f:	0f 85 27 01 00 00    	jne    75c <printf+0x19b>
      if(c == 'd'){
 635:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 639:	75 2d                	jne    668 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 63b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 647:	00 
 648:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 64f:	00 
 650:	89 44 24 04          	mov    %eax,0x4(%esp)
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	89 04 24             	mov    %eax,(%esp)
 65a:	e8 ad fe ff ff       	call   50c <printint>
        ap++;
 65f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 663:	e9 ed 00 00 00       	jmp    755 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 668:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 66c:	74 06                	je     674 <printf+0xb3>
 66e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 672:	75 2d                	jne    6a1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 674:	8b 45 e8             	mov    -0x18(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 680:	00 
 681:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 688:	00 
 689:	89 44 24 04          	mov    %eax,0x4(%esp)
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
 690:	89 04 24             	mov    %eax,(%esp)
 693:	e8 74 fe ff ff       	call   50c <printint>
        ap++;
 698:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69c:	e9 b4 00 00 00       	jmp    755 <printf+0x194>
      } else if(c == 's'){
 6a1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6a5:	75 46                	jne    6ed <printf+0x12c>
        s = (char*)*ap;
 6a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b7:	75 27                	jne    6e0 <printf+0x11f>
          s = "(null)";
 6b9:	c7 45 f4 c9 09 00 00 	movl   $0x9c9,-0xc(%ebp)
        while(*s != 0){
 6c0:	eb 1e                	jmp    6e0 <printf+0x11f>
          putc(fd, *s);
 6c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c5:	0f b6 00             	movzbl (%eax),%eax
 6c8:	0f be c0             	movsbl %al,%eax
 6cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6cf:	8b 45 08             	mov    0x8(%ebp),%eax
 6d2:	89 04 24             	mov    %eax,(%esp)
 6d5:	e8 0a fe ff ff       	call   4e4 <putc>
          s++;
 6da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6de:	eb 01                	jmp    6e1 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e0:	90                   	nop
 6e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e4:	0f b6 00             	movzbl (%eax),%eax
 6e7:	84 c0                	test   %al,%al
 6e9:	75 d7                	jne    6c2 <printf+0x101>
 6eb:	eb 68                	jmp    755 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ed:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f1:	75 1d                	jne    710 <printf+0x14f>
        putc(fd, *ap);
 6f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	0f be c0             	movsbl %al,%eax
 6fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ff:	8b 45 08             	mov    0x8(%ebp),%eax
 702:	89 04 24             	mov    %eax,(%esp)
 705:	e8 da fd ff ff       	call   4e4 <putc>
        ap++;
 70a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 70e:	eb 45                	jmp    755 <printf+0x194>
      } else if(c == '%'){
 710:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 714:	75 17                	jne    72d <printf+0x16c>
        putc(fd, c);
 716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 719:	0f be c0             	movsbl %al,%eax
 71c:	89 44 24 04          	mov    %eax,0x4(%esp)
 720:	8b 45 08             	mov    0x8(%ebp),%eax
 723:	89 04 24             	mov    %eax,(%esp)
 726:	e8 b9 fd ff ff       	call   4e4 <putc>
 72b:	eb 28                	jmp    755 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 72d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 734:	00 
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	89 04 24             	mov    %eax,(%esp)
 73b:	e8 a4 fd ff ff       	call   4e4 <putc>
        putc(fd, c);
 740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 743:	0f be c0             	movsbl %al,%eax
 746:	89 44 24 04          	mov    %eax,0x4(%esp)
 74a:	8b 45 08             	mov    0x8(%ebp),%eax
 74d:	89 04 24             	mov    %eax,(%esp)
 750:	e8 8f fd ff ff       	call   4e4 <putc>
      }
      state = 0;
 755:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 75c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 760:	8b 55 0c             	mov    0xc(%ebp),%edx
 763:	8b 45 f0             	mov    -0x10(%ebp),%eax
 766:	01 d0                	add    %edx,%eax
 768:	0f b6 00             	movzbl (%eax),%eax
 76b:	84 c0                	test   %al,%al
 76d:	0f 85 70 fe ff ff    	jne    5e3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 773:	c9                   	leave  
 774:	c3                   	ret    
 775:	90                   	nop
 776:	90                   	nop
 777:	90                   	nop

00000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	83 e8 08             	sub    $0x8,%eax
 784:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 787:	a1 48 0c 00 00       	mov    0xc48,%eax
 78c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78f:	eb 24                	jmp    7b5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 799:	77 12                	ja     7ad <free+0x35>
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a1:	77 24                	ja     7c7 <free+0x4f>
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 00                	mov    (%eax),%eax
 7a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ab:	77 1a                	ja     7c7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bb:	76 d4                	jbe    791 <free+0x19>
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c5:	76 ca                	jbe    791 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d7:	01 c2                	add    %eax,%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	39 c2                	cmp    %eax,%edx
 7e0:	75 24                	jne    806 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	8b 50 04             	mov    0x4(%eax),%edx
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	8b 40 04             	mov    0x4(%eax),%eax
 7f0:	01 c2                	add    %eax,%edx
 7f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	8b 10                	mov    (%eax),%edx
 7ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 802:	89 10                	mov    %edx,(%eax)
 804:	eb 0a                	jmp    810 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 10                	mov    (%eax),%edx
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	01 d0                	add    %edx,%eax
 822:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 825:	75 20                	jne    847 <free+0xcf>
    p->s.size += bp->s.size;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 50 04             	mov    0x4(%eax),%edx
 82d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 830:	8b 40 04             	mov    0x4(%eax),%eax
 833:	01 c2                	add    %eax,%edx
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 83b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83e:	8b 10                	mov    (%eax),%edx
 840:	8b 45 fc             	mov    -0x4(%ebp),%eax
 843:	89 10                	mov    %edx,(%eax)
 845:	eb 08                	jmp    84f <free+0xd7>
  } else
    p->s.ptr = bp;
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84d:	89 10                	mov    %edx,(%eax)
  freep = p;
 84f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 852:	a3 48 0c 00 00       	mov    %eax,0xc48
}
 857:	c9                   	leave  
 858:	c3                   	ret    

00000859 <morecore>:

static Header*
morecore(uint nu)
{
 859:	55                   	push   %ebp
 85a:	89 e5                	mov    %esp,%ebp
 85c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 85f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 866:	77 07                	ja     86f <morecore+0x16>
    nu = 4096;
 868:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 86f:	8b 45 08             	mov    0x8(%ebp),%eax
 872:	c1 e0 03             	shl    $0x3,%eax
 875:	89 04 24             	mov    %eax,(%esp)
 878:	e8 4f fc ff ff       	call   4cc <sbrk>
 87d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 880:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 884:	75 07                	jne    88d <morecore+0x34>
    return 0;
 886:	b8 00 00 00 00       	mov    $0x0,%eax
 88b:	eb 22                	jmp    8af <morecore+0x56>
  hp = (Header*)p;
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 893:	8b 45 f0             	mov    -0x10(%ebp),%eax
 896:	8b 55 08             	mov    0x8(%ebp),%edx
 899:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89f:	83 c0 08             	add    $0x8,%eax
 8a2:	89 04 24             	mov    %eax,(%esp)
 8a5:	e8 ce fe ff ff       	call   778 <free>
  return freep;
 8aa:	a1 48 0c 00 00       	mov    0xc48,%eax
}
 8af:	c9                   	leave  
 8b0:	c3                   	ret    

000008b1 <malloc>:

void*
malloc(uint nbytes)
{
 8b1:	55                   	push   %ebp
 8b2:	89 e5                	mov    %esp,%ebp
 8b4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ba:	83 c0 07             	add    $0x7,%eax
 8bd:	c1 e8 03             	shr    $0x3,%eax
 8c0:	83 c0 01             	add    $0x1,%eax
 8c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8c6:	a1 48 0c 00 00       	mov    0xc48,%eax
 8cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d2:	75 23                	jne    8f7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8d4:	c7 45 f0 40 0c 00 00 	movl   $0xc40,-0x10(%ebp)
 8db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8de:	a3 48 0c 00 00       	mov    %eax,0xc48
 8e3:	a1 48 0c 00 00       	mov    0xc48,%eax
 8e8:	a3 40 0c 00 00       	mov    %eax,0xc40
    base.s.size = 0;
 8ed:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 8f4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fa:	8b 00                	mov    (%eax),%eax
 8fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 902:	8b 40 04             	mov    0x4(%eax),%eax
 905:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 908:	72 4d                	jb     957 <malloc+0xa6>
      if(p->s.size == nunits)
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	8b 40 04             	mov    0x4(%eax),%eax
 910:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 913:	75 0c                	jne    921 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	8b 10                	mov    (%eax),%edx
 91a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91d:	89 10                	mov    %edx,(%eax)
 91f:	eb 26                	jmp    947 <malloc+0x96>
      else {
        p->s.size -= nunits;
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	8b 40 04             	mov    0x4(%eax),%eax
 927:	89 c2                	mov    %eax,%edx
 929:	2b 55 ec             	sub    -0x14(%ebp),%edx
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	8b 40 04             	mov    0x4(%eax),%eax
 938:	c1 e0 03             	shl    $0x3,%eax
 93b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	8b 55 ec             	mov    -0x14(%ebp),%edx
 944:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 947:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94a:	a3 48 0c 00 00       	mov    %eax,0xc48
      return (void*)(p + 1);
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	83 c0 08             	add    $0x8,%eax
 955:	eb 38                	jmp    98f <malloc+0xde>
    }
    if(p == freep)
 957:	a1 48 0c 00 00       	mov    0xc48,%eax
 95c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 95f:	75 1b                	jne    97c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 961:	8b 45 ec             	mov    -0x14(%ebp),%eax
 964:	89 04 24             	mov    %eax,(%esp)
 967:	e8 ed fe ff ff       	call   859 <morecore>
 96c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 96f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 973:	75 07                	jne    97c <malloc+0xcb>
        return 0;
 975:	b8 00 00 00 00       	mov    $0x0,%eax
 97a:	eb 13                	jmp    98f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 982:	8b 45 f4             	mov    -0xc(%ebp),%eax
 985:	8b 00                	mov    (%eax),%eax
 987:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 98a:	e9 70 ff ff ff       	jmp    8ff <malloc+0x4e>
}
 98f:	c9                   	leave  
 990:	c3                   	ret    
