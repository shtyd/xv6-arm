
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bf 00 00 00       	jmp    d1 <grep+0xd1>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 53                	jmp    74 <grep+0x74>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 c2 01 00 00       	call   1fb <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2e                	je     6b <grep+0x6b>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	89 d1                	mov    %edx,%ecx
  50:	29 c1                	sub    %eax,%ecx
  52:	89 c8                	mov    %ecx,%eax
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 81 05 00 00       	call   5ec <write>
      }
      p = q+1;
  6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6e:	83 c0 01             	add    $0x1,%eax
  71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  74:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  7b:	00 
  7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7f:	89 04 24             	mov    %eax,(%esp)
  82:	e8 c2 03 00 00       	call   449 <strchr>
  87:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8e:	75 91                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  90:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  97:	75 07                	jne    a0 <grep+0xa0>
      m = 0;
  99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a4:	7e 2b                	jle    d1 <grep+0xd1>
      m -= p - buf;
  a6:	ba 60 0e 00 00       	mov    $0xe60,%edx
  ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ae:	89 d1                	mov    %edx,%ecx
  b0:	29 c1                	sub    %eax,%ecx
  b2:	89 c8                	mov    %ecx,%eax
  b4:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  c5:	c7 04 24 60 0e 00 00 	movl   $0xe60,(%esp)
  cc:	e8 b7 04 00 00       	call   588 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d4:	ba 00 04 00 00       	mov    $0x400,%edx
  d9:	89 d1                	mov    %edx,%ecx
  db:	29 c1                	sub    %eax,%ecx
  dd:	89 c8                	mov    %ecx,%eax
  df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e2:	81 c2 60 0e 00 00    	add    $0xe60,%edx
  e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	89 04 24             	mov    %eax,(%esp)
  f6:	e8 e9 04 00 00       	call   5e4 <read>
  fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 102:	0f 8f 0a ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 108:	c9                   	leave  
 109:	c3                   	ret    

0000010a <main>:

int
main(int argc, char *argv[])
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	83 e4 f0             	and    $0xfffffff0,%esp
 110:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 113:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 117:	7f 19                	jg     132 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 119:	c7 44 24 04 1c 0b 00 	movl   $0xb1c,0x4(%esp)
 120:	00 
 121:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 128:	e8 1c 06 00 00       	call   749 <printf>
    exit();
 12d:	e8 9a 04 00 00       	call   5cc <exit>
  }
  pattern = argv[1];
 132:	8b 45 0c             	mov    0xc(%ebp),%eax
 135:	8b 40 04             	mov    0x4(%eax),%eax
 138:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 13c:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 140:	7f 19                	jg     15b <main+0x51>
    grep(pattern, 0);
 142:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 149:	00 
 14a:	8b 44 24 18          	mov    0x18(%esp),%eax
 14e:	89 04 24             	mov    %eax,(%esp)
 151:	e8 aa fe ff ff       	call   0 <grep>
    exit();
 156:	e8 71 04 00 00       	call   5cc <exit>
  }

  for(i = 2; i < argc; i++){
 15b:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 162:	00 
 163:	e9 81 00 00 00       	jmp    1e9 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 168:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 16c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	01 d0                	add    %edx,%eax
 178:	8b 00                	mov    (%eax),%eax
 17a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 181:	00 
 182:	89 04 24             	mov    %eax,(%esp)
 185:	e8 82 04 00 00       	call   60c <open>
 18a:	89 44 24 14          	mov    %eax,0x14(%esp)
 18e:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 193:	79 2f                	jns    1c4 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 195:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 199:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	01 d0                	add    %edx,%eax
 1a5:	8b 00                	mov    (%eax),%eax
 1a7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ab:	c7 44 24 04 3c 0b 00 	movl   $0xb3c,0x4(%esp)
 1b2:	00 
 1b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ba:	e8 8a 05 00 00       	call   749 <printf>
      exit();
 1bf:	e8 08 04 00 00       	call   5cc <exit>
    }
    grep(pattern, fd);
 1c4:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cc:	8b 44 24 18          	mov    0x18(%esp),%eax
 1d0:	89 04 24             	mov    %eax,(%esp)
 1d3:	e8 28 fe ff ff       	call   0 <grep>
    close(fd);
 1d8:	8b 44 24 14          	mov    0x14(%esp),%eax
 1dc:	89 04 24             	mov    %eax,(%esp)
 1df:	e8 10 04 00 00       	call   5f4 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1e4:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1ed:	3b 45 08             	cmp    0x8(%ebp),%eax
 1f0:	0f 8c 72 ff ff ff    	jl     168 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1f6:	e8 d1 03 00 00       	call   5cc <exit>

000001fb <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 00             	movzbl (%eax),%eax
 207:	3c 5e                	cmp    $0x5e,%al
 209:	75 17                	jne    222 <match+0x27>
    return matchhere(re+1, text);
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	8d 50 01             	lea    0x1(%eax),%edx
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	89 44 24 04          	mov    %eax,0x4(%esp)
 218:	89 14 24             	mov    %edx,(%esp)
 21b:	e8 39 00 00 00       	call   259 <matchhere>
 220:	eb 35                	jmp    257 <match+0x5c>
  do{  // must look at empty string
    if(matchhere(re, text))
 222:	8b 45 0c             	mov    0xc(%ebp),%eax
 225:	89 44 24 04          	mov    %eax,0x4(%esp)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	89 04 24             	mov    %eax,(%esp)
 22f:	e8 25 00 00 00       	call   259 <matchhere>
 234:	85 c0                	test   %eax,%eax
 236:	74 07                	je     23f <match+0x44>
      return 1;
 238:	b8 01 00 00 00       	mov    $0x1,%eax
 23d:	eb 18                	jmp    257 <match+0x5c>
  }while(*text++ != '\0');
 23f:	8b 45 0c             	mov    0xc(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	0f 95 c0             	setne  %al
 24a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 24e:	84 c0                	test   %al,%al
 250:	75 d0                	jne    222 <match+0x27>
  return 0;
 252:	b8 00 00 00 00       	mov    $0x0,%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	84 c0                	test   %al,%al
 267:	75 0a                	jne    273 <matchhere+0x1a>
    return 1;
 269:	b8 01 00 00 00       	mov    $0x1,%eax
 26e:	e9 9b 00 00 00       	jmp    30e <matchhere+0xb5>
  if(re[1] == '*')
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	83 c0 01             	add    $0x1,%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	3c 2a                	cmp    $0x2a,%al
 27e:	75 24                	jne    2a4 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	8d 48 02             	lea    0x2(%eax),%ecx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	0f be c0             	movsbl %al,%eax
 28f:	8b 55 0c             	mov    0xc(%ebp),%edx
 292:	89 54 24 08          	mov    %edx,0x8(%esp)
 296:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 6e 00 00 00       	call   310 <matchstar>
 2a2:	eb 6a                	jmp    30e <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	3c 24                	cmp    $0x24,%al
 2ac:	75 1d                	jne    2cb <matchhere+0x72>
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	83 c0 01             	add    $0x1,%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	84 c0                	test   %al,%al
 2b9:	75 10                	jne    2cb <matchhere+0x72>
    return *text == '\0';
 2bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	84 c0                	test   %al,%al
 2c3:	0f 94 c0             	sete   %al
 2c6:	0f b6 c0             	movzbl %al,%eax
 2c9:	eb 43                	jmp    30e <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	84 c0                	test   %al,%al
 2d3:	74 34                	je     309 <matchhere+0xb0>
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3c 2e                	cmp    $0x2e,%al
 2dd:	74 10                	je     2ef <matchhere+0x96>
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	0f b6 10             	movzbl (%eax),%edx
 2e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	38 c2                	cmp    %al,%dl
 2ed:	75 1a                	jne    309 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f2:	8d 50 01             	lea    0x1(%eax),%edx
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	83 c0 01             	add    $0x1,%eax
 2fb:	89 54 24 04          	mov    %edx,0x4(%esp)
 2ff:	89 04 24             	mov    %eax,(%esp)
 302:	e8 52 ff ff ff       	call   259 <matchhere>
 307:	eb 05                	jmp    30e <matchhere+0xb5>
  return 0;
 309:	b8 00 00 00 00       	mov    $0x0,%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 316:	8b 45 10             	mov    0x10(%ebp),%eax
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	89 04 24             	mov    %eax,(%esp)
 323:	e8 31 ff ff ff       	call   259 <matchhere>
 328:	85 c0                	test   %eax,%eax
 32a:	74 07                	je     333 <matchstar+0x23>
      return 1;
 32c:	b8 01 00 00 00       	mov    $0x1,%eax
 331:	eb 2c                	jmp    35f <matchstar+0x4f>
  }while(*text!='\0' && (*text++==c || c=='.'));
 333:	8b 45 10             	mov    0x10(%ebp),%eax
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	84 c0                	test   %al,%al
 33b:	74 1d                	je     35a <matchstar+0x4a>
 33d:	8b 45 10             	mov    0x10(%ebp),%eax
 340:	0f b6 00             	movzbl (%eax),%eax
 343:	0f be c0             	movsbl %al,%eax
 346:	3b 45 08             	cmp    0x8(%ebp),%eax
 349:	0f 94 c0             	sete   %al
 34c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
 350:	84 c0                	test   %al,%al
 352:	75 c2                	jne    316 <matchstar+0x6>
 354:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 358:	74 bc                	je     316 <matchstar+0x6>
  return 0;
 35a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    
 361:	90                   	nop
 362:	90                   	nop
 363:	90                   	nop

00000364 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 369:	8b 4d 08             	mov    0x8(%ebp),%ecx
 36c:	8b 55 10             	mov    0x10(%ebp),%edx
 36f:	8b 45 0c             	mov    0xc(%ebp),%eax
 372:	89 cb                	mov    %ecx,%ebx
 374:	89 df                	mov    %ebx,%edi
 376:	89 d1                	mov    %edx,%ecx
 378:	fc                   	cld    
 379:	f3 aa                	rep stos %al,%es:(%edi)
 37b:	89 ca                	mov    %ecx,%edx
 37d:	89 fb                	mov    %edi,%ebx
 37f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 382:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 385:	5b                   	pop    %ebx
 386:	5f                   	pop    %edi
 387:	5d                   	pop    %ebp
 388:	c3                   	ret    

00000389 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 395:	90                   	nop
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	0f b6 10             	movzbl (%eax),%edx
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	88 10                	mov    %dl,(%eax)
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	84 c0                	test   %al,%al
 3a9:	0f 95 c0             	setne  %al
 3ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3b4:	84 c0                	test   %al,%al
 3b6:	75 de                	jne    396 <strcpy+0xd>
    ;
  return os;
 3b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3bb:	c9                   	leave  
 3bc:	c3                   	ret    

000003bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3bd:	55                   	push   %ebp
 3be:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3c0:	eb 08                	jmp    3ca <strcmp+0xd>
    p++, q++;
 3c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ca:	8b 45 08             	mov    0x8(%ebp),%eax
 3cd:	0f b6 00             	movzbl (%eax),%eax
 3d0:	84 c0                	test   %al,%al
 3d2:	74 10                	je     3e4 <strcmp+0x27>
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	0f b6 10             	movzbl (%eax),%edx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	38 c2                	cmp    %al,%dl
 3e2:	74 de                	je     3c2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	0f b6 d0             	movzbl %al,%edx
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	0f b6 00             	movzbl (%eax),%eax
 3f3:	0f b6 c0             	movzbl %al,%eax
 3f6:	89 d1                	mov    %edx,%ecx
 3f8:	29 c1                	sub    %eax,%ecx
 3fa:	89 c8                	mov    %ecx,%eax
}
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    

000003fe <strlen>:

uint
strlen(char *s)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 40b:	eb 04                	jmp    411 <strlen+0x13>
 40d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 411:	8b 55 fc             	mov    -0x4(%ebp),%edx
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	01 d0                	add    %edx,%eax
 419:	0f b6 00             	movzbl (%eax),%eax
 41c:	84 c0                	test   %al,%al
 41e:	75 ed                	jne    40d <strlen+0xf>
    ;
  return n;
 420:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 423:	c9                   	leave  
 424:	c3                   	ret    

00000425 <memset>:

void*
memset(void *dst, int c, uint n)
{
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 42b:	8b 45 10             	mov    0x10(%ebp),%eax
 42e:	89 44 24 08          	mov    %eax,0x8(%esp)
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	89 44 24 04          	mov    %eax,0x4(%esp)
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	89 04 24             	mov    %eax,(%esp)
 43f:	e8 20 ff ff ff       	call   364 <stosb>
  return dst;
 444:	8b 45 08             	mov    0x8(%ebp),%eax
}
 447:	c9                   	leave  
 448:	c3                   	ret    

00000449 <strchr>:

char*
strchr(const char *s, char c)
{
 449:	55                   	push   %ebp
 44a:	89 e5                	mov    %esp,%ebp
 44c:	83 ec 04             	sub    $0x4,%esp
 44f:	8b 45 0c             	mov    0xc(%ebp),%eax
 452:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 455:	eb 14                	jmp    46b <strchr+0x22>
    if(*s == c)
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 460:	75 05                	jne    467 <strchr+0x1e>
      return (char*)s;
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	eb 13                	jmp    47a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 467:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	0f b6 00             	movzbl (%eax),%eax
 471:	84 c0                	test   %al,%al
 473:	75 e2                	jne    457 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 475:	b8 00 00 00 00       	mov    $0x0,%eax
}
 47a:	c9                   	leave  
 47b:	c3                   	ret    

0000047c <gets>:

char*
gets(char *buf, int max)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 489:	eb 46                	jmp    4d1 <gets+0x55>
    cc = read(0, &c, 1);
 48b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 492:	00 
 493:	8d 45 ef             	lea    -0x11(%ebp),%eax
 496:	89 44 24 04          	mov    %eax,0x4(%esp)
 49a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4a1:	e8 3e 01 00 00       	call   5e4 <read>
 4a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ad:	7e 2f                	jle    4de <gets+0x62>
      break;
    buf[i++] = c;
 4af:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	01 c2                	add    %eax,%edx
 4b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bb:	88 02                	mov    %al,(%edx)
 4bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 4c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c5:	3c 0a                	cmp    $0xa,%al
 4c7:	74 16                	je     4df <gets+0x63>
 4c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4cd:	3c 0d                	cmp    $0xd,%al
 4cf:	74 0e                	je     4df <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d4:	83 c0 01             	add    $0x1,%eax
 4d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4da:	7c af                	jl     48b <gets+0xf>
 4dc:	eb 01                	jmp    4df <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4de:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4df:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	01 d0                	add    %edx,%eax
 4e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ed:	c9                   	leave  
 4ee:	c3                   	ret    

000004ef <stat>:

int
stat(char *n, struct stat *st)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4fc:	00 
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
 500:	89 04 24             	mov    %eax,(%esp)
 503:	e8 04 01 00 00       	call   60c <open>
 508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 50b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50f:	79 07                	jns    518 <stat+0x29>
    return -1;
 511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 516:	eb 23                	jmp    53b <stat+0x4c>
  r = fstat(fd, st);
 518:	8b 45 0c             	mov    0xc(%ebp),%eax
 51b:	89 44 24 04          	mov    %eax,0x4(%esp)
 51f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 522:	89 04 24             	mov    %eax,(%esp)
 525:	e8 fa 00 00 00       	call   624 <fstat>
 52a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 bc 00 00 00       	call   5f4 <close>
  return r;
 538:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 53b:	c9                   	leave  
 53c:	c3                   	ret    

0000053d <atoi>:

int
atoi(const char *s)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 543:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 54a:	eb 23                	jmp    56f <atoi+0x32>
    n = n*10 + *s++ - '0';
 54c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 54f:	89 d0                	mov    %edx,%eax
 551:	c1 e0 02             	shl    $0x2,%eax
 554:	01 d0                	add    %edx,%eax
 556:	01 c0                	add    %eax,%eax
 558:	89 c2                	mov    %eax,%edx
 55a:	8b 45 08             	mov    0x8(%ebp),%eax
 55d:	0f b6 00             	movzbl (%eax),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	01 d0                	add    %edx,%eax
 565:	83 e8 30             	sub    $0x30,%eax
 568:	89 45 fc             	mov    %eax,-0x4(%ebp)
 56b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	3c 2f                	cmp    $0x2f,%al
 577:	7e 0a                	jle    583 <atoi+0x46>
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	0f b6 00             	movzbl (%eax),%eax
 57f:	3c 39                	cmp    $0x39,%al
 581:	7e c9                	jle    54c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 583:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 586:	c9                   	leave  
 587:	c3                   	ret    

00000588 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 588:	55                   	push   %ebp
 589:	89 e5                	mov    %esp,%ebp
 58b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
 597:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 59a:	eb 13                	jmp    5af <memmove+0x27>
    *dst++ = *src++;
 59c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 59f:	0f b6 10             	movzbl (%eax),%edx
 5a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a5:	88 10                	mov    %dl,(%eax)
 5a7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5ab:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5b3:	0f 9f c0             	setg   %al
 5b6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5ba:	84 c0                	test   %al,%al
 5bc:	75 de                	jne    59c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c1:	c9                   	leave  
 5c2:	c3                   	ret    
 5c3:	90                   	nop

000005c4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c4:	b8 01 00 00 00       	mov    $0x1,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <exit>:
SYSCALL(exit)
 5cc:	b8 02 00 00 00       	mov    $0x2,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <wait>:
SYSCALL(wait)
 5d4:	b8 03 00 00 00       	mov    $0x3,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <pipe>:
SYSCALL(pipe)
 5dc:	b8 04 00 00 00       	mov    $0x4,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <read>:
SYSCALL(read)
 5e4:	b8 05 00 00 00       	mov    $0x5,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <write>:
SYSCALL(write)
 5ec:	b8 10 00 00 00       	mov    $0x10,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <close>:
SYSCALL(close)
 5f4:	b8 15 00 00 00       	mov    $0x15,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <kill>:
SYSCALL(kill)
 5fc:	b8 06 00 00 00       	mov    $0x6,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <exec>:
SYSCALL(exec)
 604:	b8 07 00 00 00       	mov    $0x7,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <open>:
SYSCALL(open)
 60c:	b8 0f 00 00 00       	mov    $0xf,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <mknod>:
SYSCALL(mknod)
 614:	b8 11 00 00 00       	mov    $0x11,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <unlink>:
SYSCALL(unlink)
 61c:	b8 12 00 00 00       	mov    $0x12,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <fstat>:
SYSCALL(fstat)
 624:	b8 08 00 00 00       	mov    $0x8,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <link>:
SYSCALL(link)
 62c:	b8 13 00 00 00       	mov    $0x13,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <mkdir>:
SYSCALL(mkdir)
 634:	b8 14 00 00 00       	mov    $0x14,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <chdir>:
SYSCALL(chdir)
 63c:	b8 09 00 00 00       	mov    $0x9,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <dup>:
SYSCALL(dup)
 644:	b8 0a 00 00 00       	mov    $0xa,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <getpid>:
SYSCALL(getpid)
 64c:	b8 0b 00 00 00       	mov    $0xb,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <sbrk>:
SYSCALL(sbrk)
 654:	b8 0c 00 00 00       	mov    $0xc,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <sleep>:
SYSCALL(sleep)
 65c:	b8 0d 00 00 00       	mov    $0xd,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <uptime>:
SYSCALL(uptime)
 664:	b8 0e 00 00 00       	mov    $0xe,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
 66f:	83 ec 28             	sub    $0x28,%esp
 672:	8b 45 0c             	mov    0xc(%ebp),%eax
 675:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 678:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 67f:	00 
 680:	8d 45 f4             	lea    -0xc(%ebp),%eax
 683:	89 44 24 04          	mov    %eax,0x4(%esp)
 687:	8b 45 08             	mov    0x8(%ebp),%eax
 68a:	89 04 24             	mov    %eax,(%esp)
 68d:	e8 5a ff ff ff       	call   5ec <write>
}
 692:	c9                   	leave  
 693:	c3                   	ret    

00000694 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 69a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6a1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6a5:	74 17                	je     6be <printint+0x2a>
 6a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ab:	79 11                	jns    6be <printint+0x2a>
    neg = 1;
 6ad:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b7:	f7 d8                	neg    %eax
 6b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6bc:	eb 06                	jmp    6c4 <printint+0x30>
  } else {
    x = xx;
 6be:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d1:	ba 00 00 00 00       	mov    $0x0,%edx
 6d6:	f7 f1                	div    %ecx
 6d8:	89 d0                	mov    %edx,%eax
 6da:	0f b6 80 18 0e 00 00 	movzbl 0xe18(%eax),%eax
 6e1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6e7:	01 ca                	add    %ecx,%edx
 6e9:	88 02                	mov    %al,(%edx)
 6eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 6ef:	8b 55 10             	mov    0x10(%ebp),%edx
 6f2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f8:	ba 00 00 00 00       	mov    $0x0,%edx
 6fd:	f7 75 d4             	divl   -0x2c(%ebp)
 700:	89 45 ec             	mov    %eax,-0x14(%ebp)
 703:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 707:	75 c2                	jne    6cb <printint+0x37>
  if(neg)
 709:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70d:	74 2e                	je     73d <printint+0xa9>
    buf[i++] = '-';
 70f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 712:	8b 45 f4             	mov    -0xc(%ebp),%eax
 715:	01 d0                	add    %edx,%eax
 717:	c6 00 2d             	movb   $0x2d,(%eax)
 71a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 71e:	eb 1d                	jmp    73d <printint+0xa9>
    putc(fd, buf[i]);
 720:	8d 55 dc             	lea    -0x24(%ebp),%edx
 723:	8b 45 f4             	mov    -0xc(%ebp),%eax
 726:	01 d0                	add    %edx,%eax
 728:	0f b6 00             	movzbl (%eax),%eax
 72b:	0f be c0             	movsbl %al,%eax
 72e:	89 44 24 04          	mov    %eax,0x4(%esp)
 732:	8b 45 08             	mov    0x8(%ebp),%eax
 735:	89 04 24             	mov    %eax,(%esp)
 738:	e8 2f ff ff ff       	call   66c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 73d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 745:	79 d9                	jns    720 <printint+0x8c>
    putc(fd, buf[i]);
}
 747:	c9                   	leave  
 748:	c3                   	ret    

00000749 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 74f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 756:	8d 45 0c             	lea    0xc(%ebp),%eax
 759:	83 c0 04             	add    $0x4,%eax
 75c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 75f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 766:	e9 7d 01 00 00       	jmp    8e8 <printf+0x19f>
    c = fmt[i] & 0xff;
 76b:	8b 55 0c             	mov    0xc(%ebp),%edx
 76e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 771:	01 d0                	add    %edx,%eax
 773:	0f b6 00             	movzbl (%eax),%eax
 776:	0f be c0             	movsbl %al,%eax
 779:	25 ff 00 00 00       	and    $0xff,%eax
 77e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 781:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 785:	75 2c                	jne    7b3 <printf+0x6a>
      if(c == '%'){
 787:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 78b:	75 0c                	jne    799 <printf+0x50>
        state = '%';
 78d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 794:	e9 4b 01 00 00       	jmp    8e4 <printf+0x19b>
      } else {
        putc(fd, c);
 799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79c:	0f be c0             	movsbl %al,%eax
 79f:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	89 04 24             	mov    %eax,(%esp)
 7a9:	e8 be fe ff ff       	call   66c <putc>
 7ae:	e9 31 01 00 00       	jmp    8e4 <printf+0x19b>
      }
    } else if(state == '%'){
 7b3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7b7:	0f 85 27 01 00 00    	jne    8e4 <printf+0x19b>
      if(c == 'd'){
 7bd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7c1:	75 2d                	jne    7f0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7cf:	00 
 7d0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7d7:	00 
 7d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 ad fe ff ff       	call   694 <printint>
        ap++;
 7e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7eb:	e9 ed 00 00 00       	jmp    8dd <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 7f0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7f4:	74 06                	je     7fc <printf+0xb3>
 7f6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7fa:	75 2d                	jne    829 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ff:	8b 00                	mov    (%eax),%eax
 801:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 808:	00 
 809:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 810:	00 
 811:	89 44 24 04          	mov    %eax,0x4(%esp)
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	89 04 24             	mov    %eax,(%esp)
 81b:	e8 74 fe ff ff       	call   694 <printint>
        ap++;
 820:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 824:	e9 b4 00 00 00       	jmp    8dd <printf+0x194>
      } else if(c == 's'){
 829:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 82d:	75 46                	jne    875 <printf+0x12c>
        s = (char*)*ap;
 82f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 837:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 83b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83f:	75 27                	jne    868 <printf+0x11f>
          s = "(null)";
 841:	c7 45 f4 52 0b 00 00 	movl   $0xb52,-0xc(%ebp)
        while(*s != 0){
 848:	eb 1e                	jmp    868 <printf+0x11f>
          putc(fd, *s);
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	0f b6 00             	movzbl (%eax),%eax
 850:	0f be c0             	movsbl %al,%eax
 853:	89 44 24 04          	mov    %eax,0x4(%esp)
 857:	8b 45 08             	mov    0x8(%ebp),%eax
 85a:	89 04 24             	mov    %eax,(%esp)
 85d:	e8 0a fe ff ff       	call   66c <putc>
          s++;
 862:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 866:	eb 01                	jmp    869 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 868:	90                   	nop
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	0f b6 00             	movzbl (%eax),%eax
 86f:	84 c0                	test   %al,%al
 871:	75 d7                	jne    84a <printf+0x101>
 873:	eb 68                	jmp    8dd <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 875:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 879:	75 1d                	jne    898 <printf+0x14f>
        putc(fd, *ap);
 87b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 87e:	8b 00                	mov    (%eax),%eax
 880:	0f be c0             	movsbl %al,%eax
 883:	89 44 24 04          	mov    %eax,0x4(%esp)
 887:	8b 45 08             	mov    0x8(%ebp),%eax
 88a:	89 04 24             	mov    %eax,(%esp)
 88d:	e8 da fd ff ff       	call   66c <putc>
        ap++;
 892:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 896:	eb 45                	jmp    8dd <printf+0x194>
      } else if(c == '%'){
 898:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 89c:	75 17                	jne    8b5 <printf+0x16c>
        putc(fd, c);
 89e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a1:	0f be c0             	movsbl %al,%eax
 8a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a8:	8b 45 08             	mov    0x8(%ebp),%eax
 8ab:	89 04 24             	mov    %eax,(%esp)
 8ae:	e8 b9 fd ff ff       	call   66c <putc>
 8b3:	eb 28                	jmp    8dd <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8b5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8bc:	00 
 8bd:	8b 45 08             	mov    0x8(%ebp),%eax
 8c0:	89 04 24             	mov    %eax,(%esp)
 8c3:	e8 a4 fd ff ff       	call   66c <putc>
        putc(fd, c);
 8c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8cb:	0f be c0             	movsbl %al,%eax
 8ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d2:	8b 45 08             	mov    0x8(%ebp),%eax
 8d5:	89 04 24             	mov    %eax,(%esp)
 8d8:	e8 8f fd ff ff       	call   66c <putc>
      }
      state = 0;
 8dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8e8:	8b 55 0c             	mov    0xc(%ebp),%edx
 8eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ee:	01 d0                	add    %edx,%eax
 8f0:	0f b6 00             	movzbl (%eax),%eax
 8f3:	84 c0                	test   %al,%al
 8f5:	0f 85 70 fe ff ff    	jne    76b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8fb:	c9                   	leave  
 8fc:	c3                   	ret    
 8fd:	90                   	nop
 8fe:	90                   	nop
 8ff:	90                   	nop

00000900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 906:	8b 45 08             	mov    0x8(%ebp),%eax
 909:	83 e8 08             	sub    $0x8,%eax
 90c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90f:	a1 48 0e 00 00       	mov    0xe48,%eax
 914:	89 45 fc             	mov    %eax,-0x4(%ebp)
 917:	eb 24                	jmp    93d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 921:	77 12                	ja     935 <free+0x35>
 923:	8b 45 f8             	mov    -0x8(%ebp),%eax
 926:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 929:	77 24                	ja     94f <free+0x4f>
 92b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92e:	8b 00                	mov    (%eax),%eax
 930:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 933:	77 1a                	ja     94f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 93d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 940:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 943:	76 d4                	jbe    919 <free+0x19>
 945:	8b 45 fc             	mov    -0x4(%ebp),%eax
 948:	8b 00                	mov    (%eax),%eax
 94a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94d:	76 ca                	jbe    919 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 94f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 952:	8b 40 04             	mov    0x4(%eax),%eax
 955:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 95c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95f:	01 c2                	add    %eax,%edx
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	8b 00                	mov    (%eax),%eax
 966:	39 c2                	cmp    %eax,%edx
 968:	75 24                	jne    98e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96d:	8b 50 04             	mov    0x4(%eax),%edx
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	8b 00                	mov    (%eax),%eax
 975:	8b 40 04             	mov    0x4(%eax),%eax
 978:	01 c2                	add    %eax,%edx
 97a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 980:	8b 45 fc             	mov    -0x4(%ebp),%eax
 983:	8b 00                	mov    (%eax),%eax
 985:	8b 10                	mov    (%eax),%edx
 987:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98a:	89 10                	mov    %edx,(%eax)
 98c:	eb 0a                	jmp    998 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 991:	8b 10                	mov    (%eax),%edx
 993:	8b 45 f8             	mov    -0x8(%ebp),%eax
 996:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 998:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99b:	8b 40 04             	mov    0x4(%eax),%eax
 99e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a8:	01 d0                	add    %edx,%eax
 9aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ad:	75 20                	jne    9cf <free+0xcf>
    p->s.size += bp->s.size;
 9af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b2:	8b 50 04             	mov    0x4(%eax),%edx
 9b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b8:	8b 40 04             	mov    0x4(%eax),%eax
 9bb:	01 c2                	add    %eax,%edx
 9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c6:	8b 10                	mov    (%eax),%edx
 9c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cb:	89 10                	mov    %edx,(%eax)
 9cd:	eb 08                	jmp    9d7 <free+0xd7>
  } else
    p->s.ptr = bp;
 9cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9d5:	89 10                	mov    %edx,(%eax)
  freep = p;
 9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9da:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9df:	c9                   	leave  
 9e0:	c3                   	ret    

000009e1 <morecore>:

static Header*
morecore(uint nu)
{
 9e1:	55                   	push   %ebp
 9e2:	89 e5                	mov    %esp,%ebp
 9e4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9e7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9ee:	77 07                	ja     9f7 <morecore+0x16>
    nu = 4096;
 9f0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9f7:	8b 45 08             	mov    0x8(%ebp),%eax
 9fa:	c1 e0 03             	shl    $0x3,%eax
 9fd:	89 04 24             	mov    %eax,(%esp)
 a00:	e8 4f fc ff ff       	call   654 <sbrk>
 a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a08:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a0c:	75 07                	jne    a15 <morecore+0x34>
    return 0;
 a0e:	b8 00 00 00 00       	mov    $0x0,%eax
 a13:	eb 22                	jmp    a37 <morecore+0x56>
  hp = (Header*)p;
 a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1e:	8b 55 08             	mov    0x8(%ebp),%edx
 a21:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a27:	83 c0 08             	add    $0x8,%eax
 a2a:	89 04 24             	mov    %eax,(%esp)
 a2d:	e8 ce fe ff ff       	call   900 <free>
  return freep;
 a32:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a37:	c9                   	leave  
 a38:	c3                   	ret    

00000a39 <malloc>:

void*
malloc(uint nbytes)
{
 a39:	55                   	push   %ebp
 a3a:	89 e5                	mov    %esp,%ebp
 a3c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a3f:	8b 45 08             	mov    0x8(%ebp),%eax
 a42:	83 c0 07             	add    $0x7,%eax
 a45:	c1 e8 03             	shr    $0x3,%eax
 a48:	83 c0 01             	add    $0x1,%eax
 a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a4e:	a1 48 0e 00 00       	mov    0xe48,%eax
 a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a5a:	75 23                	jne    a7f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a5c:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a66:	a3 48 0e 00 00       	mov    %eax,0xe48
 a6b:	a1 48 0e 00 00       	mov    0xe48,%eax
 a70:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a75:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a7c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a82:	8b 00                	mov    (%eax),%eax
 a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8a:	8b 40 04             	mov    0x4(%eax),%eax
 a8d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a90:	72 4d                	jb     adf <malloc+0xa6>
      if(p->s.size == nunits)
 a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a95:	8b 40 04             	mov    0x4(%eax),%eax
 a98:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a9b:	75 0c                	jne    aa9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	8b 10                	mov    (%eax),%edx
 aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa5:	89 10                	mov    %edx,(%eax)
 aa7:	eb 26                	jmp    acf <malloc+0x96>
      else {
        p->s.size -= nunits;
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	8b 40 04             	mov    0x4(%eax),%eax
 aaf:	89 c2                	mov    %eax,%edx
 ab1:	2b 55 ec             	sub    -0x14(%ebp),%edx
 ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abd:	8b 40 04             	mov    0x4(%eax),%eax
 ac0:	c1 e0 03             	shl    $0x3,%eax
 ac3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 acc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad2:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ada:	83 c0 08             	add    $0x8,%eax
 add:	eb 38                	jmp    b17 <malloc+0xde>
    }
    if(p == freep)
 adf:	a1 48 0e 00 00       	mov    0xe48,%eax
 ae4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ae7:	75 1b                	jne    b04 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aec:	89 04 24             	mov    %eax,(%esp)
 aef:	e8 ed fe ff ff       	call   9e1 <morecore>
 af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 afb:	75 07                	jne    b04 <malloc+0xcb>
        return 0;
 afd:	b8 00 00 00 00       	mov    $0x0,%eax
 b02:	eb 13                	jmp    b17 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0d:	8b 00                	mov    (%eax),%eax
 b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b12:	e9 70 ff ff ff       	jmp    a87 <malloc+0x4e>
}
 b17:	c9                   	leave  
 b18:	c3                   	ret    
