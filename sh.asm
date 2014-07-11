
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 53 0f 00 00       	call   f64 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 e0 14 00 00 	mov    0x14e0(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 b4 14 00 00 	movl   $0x14b4,(%esp)
      2b:	e8 2a 03 00 00       	call   35a <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 1f 0f 00 00       	call   f64 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 3f 0f 00 00       	call   f9c <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 bb 14 00 	movl   $0x14bb,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 66 10 00 00       	call   10e1 <printf>
    break;
      7b:	e9 84 01 00 00       	jmp    204 <runcmd+0x204>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 f8 0e 00 00       	call   f8c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 f8 0e 00 00       	call   fa4 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 cb 14 00 	movl   $0x14cb,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 13 10 00 00       	call   10e1 <printf>
      exit();
      ce:	e8 91 0e 00 00       	call   f64 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
    break;
      e1:	e9 1e 01 00 00       	jmp    204 <runcmd+0x204>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      ec:	e8 8f 02 00 00       	call   380 <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 64 0e 00 00       	call   f6c <wait>
    runcmd(lcmd->right);
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
    break;
     116:	e9 e9 00 00 00       	jmp    204 <runcmd+0x204>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 48 0e 00 00       	call   f74 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 db 14 00 00 	movl   $0x14db,(%esp)
     137:	e8 1e 02 00 00       	call   35a <panic>
    if(fork1() == 0){
     13c:	e8 3f 02 00 00       	call   380 <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 3b 0e 00 00       	call   f8c <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 80 0e 00 00       	call   fdc <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 25 0e 00 00       	call   f8c <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 1a 0e 00 00       	call   f8c <close>
      runcmd(pcmd->left);
     172:	8b 45 e8             	mov    -0x18(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 fb 01 00 00       	call   380 <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 f7 0d 00 00       	call   f8c <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 3c 0e 00 00       	call   fdc <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 e1 0d 00 00       	call   f8c <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 d6 0d 00 00       	call   f8c <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 bd 0d 00 00       	call   f8c <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 b2 0d 00 00       	call   f8c <close>
    wait();
     1da:	e8 8d 0d 00 00       	call   f6c <wait>
    wait();
     1df:	e8 88 0d 00 00       	call   f6c <wait>
    break;
     1e4:	eb 1e                	jmp    204 <runcmd+0x204>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 8f 01 00 00       	call   380 <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 0e                	jne    203 <runcmd+0x203>
      runcmd(bcmd->cmd);
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
    break;
     203:	90                   	nop
  }
  exit();
     204:	e8 5b 0d 00 00       	call   f64 <exit>

00000209 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     209:	55                   	push   %ebp
     20a:	89 e5                	mov    %esp,%ebp
     20c:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     20f:	c7 44 24 04 f8 14 00 	movl   $0x14f8,0x4(%esp)
     216:	00 
     217:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     21e:	e8 be 0e 00 00       	call   10e1 <printf>
  memset(buf, 0, nbuf);
     223:	8b 45 0c             	mov    0xc(%ebp),%eax
     226:	89 44 24 08          	mov    %eax,0x8(%esp)
     22a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     231:	00 
     232:	8b 45 08             	mov    0x8(%ebp),%eax
     235:	89 04 24             	mov    %eax,(%esp)
     238:	e8 80 0b 00 00       	call   dbd <memset>
  gets(buf, nbuf);
     23d:	8b 45 0c             	mov    0xc(%ebp),%eax
     240:	89 44 24 04          	mov    %eax,0x4(%esp)
     244:	8b 45 08             	mov    0x8(%ebp),%eax
     247:	89 04 24             	mov    %eax,(%esp)
     24a:	e8 c5 0b 00 00       	call   e14 <gets>
  if(buf[0] == 0) // EOF
     24f:	8b 45 08             	mov    0x8(%ebp),%eax
     252:	0f b6 00             	movzbl (%eax),%eax
     255:	84 c0                	test   %al,%al
     257:	75 07                	jne    260 <getcmd+0x57>
    return -1;
     259:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     25e:	eb 05                	jmp    265 <getcmd+0x5c>
  return 0;
     260:	b8 00 00 00 00       	mov    $0x0,%eax
}
     265:	c9                   	leave  
     266:	c3                   	ret    

00000267 <main>:

int
main(void)
{
     267:	55                   	push   %ebp
     268:	89 e5                	mov    %esp,%ebp
     26a:	83 e4 f0             	and    $0xfffffff0,%esp
     26d:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     270:	eb 19                	jmp    28b <main+0x24>
    if(fd >= 3){
     272:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     277:	7e 12                	jle    28b <main+0x24>
      close(fd);
     279:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27d:	89 04 24             	mov    %eax,(%esp)
     280:	e8 07 0d 00 00       	call   f8c <close>
      break;
     285:	90                   	nop
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     286:	e9 ae 00 00 00       	jmp    339 <main+0xd2>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     28b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     292:	00 
     293:	c7 04 24 fb 14 00 00 	movl   $0x14fb,(%esp)
     29a:	e8 05 0d 00 00       	call   fa4 <open>
     29f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a3:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a8:	79 c8                	jns    272 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2aa:	e9 8a 00 00 00       	jmp    339 <main+0xd2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2af:	0f b6 05 60 1a 00 00 	movzbl 0x1a60,%eax
     2b6:	3c 63                	cmp    $0x63,%al
     2b8:	75 5a                	jne    314 <main+0xad>
     2ba:	0f b6 05 61 1a 00 00 	movzbl 0x1a61,%eax
     2c1:	3c 64                	cmp    $0x64,%al
     2c3:	75 4f                	jne    314 <main+0xad>
     2c5:	0f b6 05 62 1a 00 00 	movzbl 0x1a62,%eax
     2cc:	3c 20                	cmp    $0x20,%al
     2ce:	75 44                	jne    314 <main+0xad>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2d0:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     2d7:	e8 ba 0a 00 00       	call   d96 <strlen>
     2dc:	83 e8 01             	sub    $0x1,%eax
     2df:	c6 80 60 1a 00 00 00 	movb   $0x0,0x1a60(%eax)
      if(chdir(buf+3) < 0)
     2e6:	c7 04 24 63 1a 00 00 	movl   $0x1a63,(%esp)
     2ed:	e8 e2 0c 00 00       	call   fd4 <chdir>
     2f2:	85 c0                	test   %eax,%eax
     2f4:	79 42                	jns    338 <main+0xd1>
        printf(2, "cannot cd %s\n", buf+3);
     2f6:	c7 44 24 08 63 1a 00 	movl   $0x1a63,0x8(%esp)
     2fd:	00 
     2fe:	c7 44 24 04 03 15 00 	movl   $0x1503,0x4(%esp)
     305:	00 
     306:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     30d:	e8 cf 0d 00 00       	call   10e1 <printf>
      continue;
     312:	eb 24                	jmp    338 <main+0xd1>
    }
    if(fork1() == 0)
     314:	e8 67 00 00 00       	call   380 <fork1>
     319:	85 c0                	test   %eax,%eax
     31b:	75 14                	jne    331 <main+0xca>
      runcmd(parsecmd(buf));
     31d:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     324:	e8 c9 03 00 00       	call   6f2 <parsecmd>
     329:	89 04 24             	mov    %eax,(%esp)
     32c:	e8 cf fc ff ff       	call   0 <runcmd>
    wait();
     331:	e8 36 0c 00 00       	call   f6c <wait>
     336:	eb 01                	jmp    339 <main+0xd2>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
     338:	90                   	nop
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     339:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     340:	00 
     341:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     348:	e8 bc fe ff ff       	call   209 <getcmd>
     34d:	85 c0                	test   %eax,%eax
     34f:	0f 89 5a ff ff ff    	jns    2af <main+0x48>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     355:	e8 0a 0c 00 00       	call   f64 <exit>

0000035a <panic>:
}

void
panic(char *s)
{
     35a:	55                   	push   %ebp
     35b:	89 e5                	mov    %esp,%ebp
     35d:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     360:	8b 45 08             	mov    0x8(%ebp),%eax
     363:	89 44 24 08          	mov    %eax,0x8(%esp)
     367:	c7 44 24 04 11 15 00 	movl   $0x1511,0x4(%esp)
     36e:	00 
     36f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     376:	e8 66 0d 00 00       	call   10e1 <printf>
  exit();
     37b:	e8 e4 0b 00 00       	call   f64 <exit>

00000380 <fork1>:
}

int
fork1(void)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     386:	e8 d1 0b 00 00       	call   f5c <fork>
     38b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     38e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     392:	75 0c                	jne    3a0 <fork1+0x20>
    panic("fork");
     394:	c7 04 24 15 15 00 00 	movl   $0x1515,(%esp)
     39b:	e8 ba ff ff ff       	call   35a <panic>
  return pid;
     3a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3a3:	c9                   	leave  
     3a4:	c3                   	ret    

000003a5 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3a5:	55                   	push   %ebp
     3a6:	89 e5                	mov    %esp,%ebp
     3a8:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ab:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3b2:	e8 1a 10 00 00       	call   13d1 <malloc>
     3b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3ba:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3c1:	00 
     3c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c9:	00 
     3ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3cd:	89 04 24             	mov    %eax,(%esp)
     3d0:	e8 e8 09 00 00       	call   dbd <memset>
  cmd->type = EXEC;
     3d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e1:	c9                   	leave  
     3e2:	c3                   	ret    

000003e3 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3e3:	55                   	push   %ebp
     3e4:	89 e5                	mov    %esp,%ebp
     3e6:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e9:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3f0:	e8 dc 0f 00 00       	call   13d1 <malloc>
     3f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f8:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3ff:	00 
     400:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     407:	00 
     408:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40b:	89 04 24             	mov    %eax,(%esp)
     40e:	e8 aa 09 00 00       	call   dbd <memset>
  cmd->type = REDIR;
     413:	8b 45 f4             	mov    -0xc(%ebp),%eax
     416:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     41c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41f:	8b 55 08             	mov    0x8(%ebp),%edx
     422:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     425:	8b 45 f4             	mov    -0xc(%ebp),%eax
     428:	8b 55 0c             	mov    0xc(%ebp),%edx
     42b:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     42e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     431:	8b 55 10             	mov    0x10(%ebp),%edx
     434:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     437:	8b 45 f4             	mov    -0xc(%ebp),%eax
     43a:	8b 55 14             	mov    0x14(%ebp),%edx
     43d:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     440:	8b 45 f4             	mov    -0xc(%ebp),%eax
     443:	8b 55 18             	mov    0x18(%ebp),%edx
     446:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     449:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     44c:	c9                   	leave  
     44d:	c3                   	ret    

0000044e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     44e:	55                   	push   %ebp
     44f:	89 e5                	mov    %esp,%ebp
     451:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     454:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     45b:	e8 71 0f 00 00       	call   13d1 <malloc>
     460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     463:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     46a:	00 
     46b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     472:	00 
     473:	8b 45 f4             	mov    -0xc(%ebp),%eax
     476:	89 04 24             	mov    %eax,(%esp)
     479:	e8 3f 09 00 00       	call   dbd <memset>
  cmd->type = PIPE;
     47e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     481:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     487:	8b 45 f4             	mov    -0xc(%ebp),%eax
     48a:	8b 55 08             	mov    0x8(%ebp),%edx
     48d:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     490:	8b 45 f4             	mov    -0xc(%ebp),%eax
     493:	8b 55 0c             	mov    0xc(%ebp),%edx
     496:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     499:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     49c:	c9                   	leave  
     49d:	c3                   	ret    

0000049e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     49e:	55                   	push   %ebp
     49f:	89 e5                	mov    %esp,%ebp
     4a1:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4ab:	e8 21 0f 00 00       	call   13d1 <malloc>
     4b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4b3:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4ba:	00 
     4bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4c2:	00 
     4c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c6:	89 04 24             	mov    %eax,(%esp)
     4c9:	e8 ef 08 00 00       	call   dbd <memset>
  cmd->type = LIST;
     4ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d1:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4da:	8b 55 08             	mov    0x8(%ebp),%edx
     4dd:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e3:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e6:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4ec:	c9                   	leave  
     4ed:	c3                   	ret    

000004ee <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4ee:	55                   	push   %ebp
     4ef:	89 e5                	mov    %esp,%ebp
     4f1:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4fb:	e8 d1 0e 00 00       	call   13d1 <malloc>
     500:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     503:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     50a:	00 
     50b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     512:	00 
     513:	8b 45 f4             	mov    -0xc(%ebp),%eax
     516:	89 04 24             	mov    %eax,(%esp)
     519:	e8 9f 08 00 00       	call   dbd <memset>
  cmd->type = BACK;
     51e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     521:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     527:	8b 45 f4             	mov    -0xc(%ebp),%eax
     52a:	8b 55 08             	mov    0x8(%ebp),%edx
     52d:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     530:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     533:	c9                   	leave  
     534:	c3                   	ret    

00000535 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     535:	55                   	push   %ebp
     536:	89 e5                	mov    %esp,%ebp
     538:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     53b:	8b 45 08             	mov    0x8(%ebp),%eax
     53e:	8b 00                	mov    (%eax),%eax
     540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     543:	eb 04                	jmp    549 <gettoken+0x14>
    s++;
     545:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     549:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     54f:	73 1d                	jae    56e <gettoken+0x39>
     551:	8b 45 f4             	mov    -0xc(%ebp),%eax
     554:	0f b6 00             	movzbl (%eax),%eax
     557:	0f be c0             	movsbl %al,%eax
     55a:	89 44 24 04          	mov    %eax,0x4(%esp)
     55e:	c7 04 24 24 1a 00 00 	movl   $0x1a24,(%esp)
     565:	e8 77 08 00 00       	call   de1 <strchr>
     56a:	85 c0                	test   %eax,%eax
     56c:	75 d7                	jne    545 <gettoken+0x10>
    s++;
  if(q)
     56e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     572:	74 08                	je     57c <gettoken+0x47>
    *q = s;
     574:	8b 45 10             	mov    0x10(%ebp),%eax
     577:	8b 55 f4             	mov    -0xc(%ebp),%edx
     57a:	89 10                	mov    %edx,(%eax)
  ret = *s;
     57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57f:	0f b6 00             	movzbl (%eax),%eax
     582:	0f be c0             	movsbl %al,%eax
     585:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     588:	8b 45 f4             	mov    -0xc(%ebp),%eax
     58b:	0f b6 00             	movzbl (%eax),%eax
     58e:	0f be c0             	movsbl %al,%eax
     591:	83 f8 3c             	cmp    $0x3c,%eax
     594:	7f 1e                	jg     5b4 <gettoken+0x7f>
     596:	83 f8 3b             	cmp    $0x3b,%eax
     599:	7d 23                	jge    5be <gettoken+0x89>
     59b:	83 f8 29             	cmp    $0x29,%eax
     59e:	7f 3f                	jg     5df <gettoken+0xaa>
     5a0:	83 f8 28             	cmp    $0x28,%eax
     5a3:	7d 19                	jge    5be <gettoken+0x89>
     5a5:	85 c0                	test   %eax,%eax
     5a7:	0f 84 83 00 00 00    	je     630 <gettoken+0xfb>
     5ad:	83 f8 26             	cmp    $0x26,%eax
     5b0:	74 0c                	je     5be <gettoken+0x89>
     5b2:	eb 2b                	jmp    5df <gettoken+0xaa>
     5b4:	83 f8 3e             	cmp    $0x3e,%eax
     5b7:	74 0b                	je     5c4 <gettoken+0x8f>
     5b9:	83 f8 7c             	cmp    $0x7c,%eax
     5bc:	75 21                	jne    5df <gettoken+0xaa>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5c2:	eb 73                	jmp    637 <gettoken+0x102>
  case '>':
    s++;
     5c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cb:	0f b6 00             	movzbl (%eax),%eax
     5ce:	3c 3e                	cmp    $0x3e,%al
     5d0:	75 61                	jne    633 <gettoken+0xfe>
      ret = '+';
     5d2:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5dd:	eb 54                	jmp    633 <gettoken+0xfe>
  default:
    ret = 'a';
     5df:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5e6:	eb 04                	jmp    5ec <gettoken+0xb7>
      s++;
     5e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f2:	73 42                	jae    636 <gettoken+0x101>
     5f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f7:	0f b6 00             	movzbl (%eax),%eax
     5fa:	0f be c0             	movsbl %al,%eax
     5fd:	89 44 24 04          	mov    %eax,0x4(%esp)
     601:	c7 04 24 24 1a 00 00 	movl   $0x1a24,(%esp)
     608:	e8 d4 07 00 00       	call   de1 <strchr>
     60d:	85 c0                	test   %eax,%eax
     60f:	75 25                	jne    636 <gettoken+0x101>
     611:	8b 45 f4             	mov    -0xc(%ebp),%eax
     614:	0f b6 00             	movzbl (%eax),%eax
     617:	0f be c0             	movsbl %al,%eax
     61a:	89 44 24 04          	mov    %eax,0x4(%esp)
     61e:	c7 04 24 2a 1a 00 00 	movl   $0x1a2a,(%esp)
     625:	e8 b7 07 00 00       	call   de1 <strchr>
     62a:	85 c0                	test   %eax,%eax
     62c:	74 ba                	je     5e8 <gettoken+0xb3>
      s++;
    break;
     62e:	eb 06                	jmp    636 <gettoken+0x101>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     630:	90                   	nop
     631:	eb 04                	jmp    637 <gettoken+0x102>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     633:	90                   	nop
     634:	eb 01                	jmp    637 <gettoken+0x102>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     636:	90                   	nop
  }
  if(eq)
     637:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     63b:	74 0e                	je     64b <gettoken+0x116>
    *eq = s;
     63d:	8b 45 14             	mov    0x14(%ebp),%eax
     640:	8b 55 f4             	mov    -0xc(%ebp),%edx
     643:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     645:	eb 04                	jmp    64b <gettoken+0x116>
    s++;
     647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     651:	73 1d                	jae    670 <gettoken+0x13b>
     653:	8b 45 f4             	mov    -0xc(%ebp),%eax
     656:	0f b6 00             	movzbl (%eax),%eax
     659:	0f be c0             	movsbl %al,%eax
     65c:	89 44 24 04          	mov    %eax,0x4(%esp)
     660:	c7 04 24 24 1a 00 00 	movl   $0x1a24,(%esp)
     667:	e8 75 07 00 00       	call   de1 <strchr>
     66c:	85 c0                	test   %eax,%eax
     66e:	75 d7                	jne    647 <gettoken+0x112>
    s++;
  *ps = s;
     670:	8b 45 08             	mov    0x8(%ebp),%eax
     673:	8b 55 f4             	mov    -0xc(%ebp),%edx
     676:	89 10                	mov    %edx,(%eax)
  return ret;
     678:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     67b:	c9                   	leave  
     67c:	c3                   	ret    

0000067d <peek>:

int
peek(char **ps, char *es, char *toks)
{
     67d:	55                   	push   %ebp
     67e:	89 e5                	mov    %esp,%ebp
     680:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     683:	8b 45 08             	mov    0x8(%ebp),%eax
     686:	8b 00                	mov    (%eax),%eax
     688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     68b:	eb 04                	jmp    691 <peek+0x14>
    s++;
     68d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     691:	8b 45 f4             	mov    -0xc(%ebp),%eax
     694:	3b 45 0c             	cmp    0xc(%ebp),%eax
     697:	73 1d                	jae    6b6 <peek+0x39>
     699:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69c:	0f b6 00             	movzbl (%eax),%eax
     69f:	0f be c0             	movsbl %al,%eax
     6a2:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a6:	c7 04 24 24 1a 00 00 	movl   $0x1a24,(%esp)
     6ad:	e8 2f 07 00 00       	call   de1 <strchr>
     6b2:	85 c0                	test   %eax,%eax
     6b4:	75 d7                	jne    68d <peek+0x10>
    s++;
  *ps = s;
     6b6:	8b 45 08             	mov    0x8(%ebp),%eax
     6b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6bc:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c1:	0f b6 00             	movzbl (%eax),%eax
     6c4:	84 c0                	test   %al,%al
     6c6:	74 23                	je     6eb <peek+0x6e>
     6c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cb:	0f b6 00             	movzbl (%eax),%eax
     6ce:	0f be c0             	movsbl %al,%eax
     6d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d5:	8b 45 10             	mov    0x10(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 01 07 00 00       	call   de1 <strchr>
     6e0:	85 c0                	test   %eax,%eax
     6e2:	74 07                	je     6eb <peek+0x6e>
     6e4:	b8 01 00 00 00       	mov    $0x1,%eax
     6e9:	eb 05                	jmp    6f0 <peek+0x73>
     6eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6f0:	c9                   	leave  
     6f1:	c3                   	ret    

000006f2 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6f2:	55                   	push   %ebp
     6f3:	89 e5                	mov    %esp,%ebp
     6f5:	53                   	push   %ebx
     6f6:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6fc:	8b 45 08             	mov    0x8(%ebp),%eax
     6ff:	89 04 24             	mov    %eax,(%esp)
     702:	e8 8f 06 00 00       	call   d96 <strlen>
     707:	01 d8                	add    %ebx,%eax
     709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     70f:	89 44 24 04          	mov    %eax,0x4(%esp)
     713:	8d 45 08             	lea    0x8(%ebp),%eax
     716:	89 04 24             	mov    %eax,(%esp)
     719:	e8 60 00 00 00       	call   77e <parseline>
     71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     721:	c7 44 24 08 1a 15 00 	movl   $0x151a,0x8(%esp)
     728:	00 
     729:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72c:	89 44 24 04          	mov    %eax,0x4(%esp)
     730:	8d 45 08             	lea    0x8(%ebp),%eax
     733:	89 04 24             	mov    %eax,(%esp)
     736:	e8 42 ff ff ff       	call   67d <peek>
  if(s != es){
     73b:	8b 45 08             	mov    0x8(%ebp),%eax
     73e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     741:	74 27                	je     76a <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     743:	8b 45 08             	mov    0x8(%ebp),%eax
     746:	89 44 24 08          	mov    %eax,0x8(%esp)
     74a:	c7 44 24 04 1b 15 00 	movl   $0x151b,0x4(%esp)
     751:	00 
     752:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     759:	e8 83 09 00 00       	call   10e1 <printf>
    panic("syntax");
     75e:	c7 04 24 2a 15 00 00 	movl   $0x152a,(%esp)
     765:	e8 f0 fb ff ff       	call   35a <panic>
  }
  nulterminate(cmd);
     76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     76d:	89 04 24             	mov    %eax,(%esp)
     770:	e8 a5 04 00 00       	call   c1a <nulterminate>
  return cmd;
     775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     778:	83 c4 24             	add    $0x24,%esp
     77b:	5b                   	pop    %ebx
     77c:	5d                   	pop    %ebp
     77d:	c3                   	ret    

0000077e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     77e:	55                   	push   %ebp
     77f:	89 e5                	mov    %esp,%ebp
     781:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     784:	8b 45 0c             	mov    0xc(%ebp),%eax
     787:	89 44 24 04          	mov    %eax,0x4(%esp)
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	89 04 24             	mov    %eax,(%esp)
     791:	e8 bc 00 00 00       	call   852 <parsepipe>
     796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     799:	eb 30                	jmp    7cb <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     79b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7a2:	00 
     7a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7aa:	00 
     7ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ae:	89 44 24 04          	mov    %eax,0x4(%esp)
     7b2:	8b 45 08             	mov    0x8(%ebp),%eax
     7b5:	89 04 24             	mov    %eax,(%esp)
     7b8:	e8 78 fd ff ff       	call   535 <gettoken>
    cmd = backcmd(cmd);
     7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c0:	89 04 24             	mov    %eax,(%esp)
     7c3:	e8 26 fd ff ff       	call   4ee <backcmd>
     7c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7cb:	c7 44 24 08 31 15 00 	movl   $0x1531,0x8(%esp)
     7d2:	00 
     7d3:	8b 45 0c             	mov    0xc(%ebp),%eax
     7d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     7da:	8b 45 08             	mov    0x8(%ebp),%eax
     7dd:	89 04 24             	mov    %eax,(%esp)
     7e0:	e8 98 fe ff ff       	call   67d <peek>
     7e5:	85 c0                	test   %eax,%eax
     7e7:	75 b2                	jne    79b <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e9:	c7 44 24 08 33 15 00 	movl   $0x1533,0x8(%esp)
     7f0:	00 
     7f1:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f8:	8b 45 08             	mov    0x8(%ebp),%eax
     7fb:	89 04 24             	mov    %eax,(%esp)
     7fe:	e8 7a fe ff ff       	call   67d <peek>
     803:	85 c0                	test   %eax,%eax
     805:	74 46                	je     84d <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     807:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80e:	00 
     80f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     816:	00 
     817:	8b 45 0c             	mov    0xc(%ebp),%eax
     81a:	89 44 24 04          	mov    %eax,0x4(%esp)
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 0c fd ff ff       	call   535 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     829:	8b 45 0c             	mov    0xc(%ebp),%eax
     82c:	89 44 24 04          	mov    %eax,0x4(%esp)
     830:	8b 45 08             	mov    0x8(%ebp),%eax
     833:	89 04 24             	mov    %eax,(%esp)
     836:	e8 43 ff ff ff       	call   77e <parseline>
     83b:	89 44 24 04          	mov    %eax,0x4(%esp)
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	89 04 24             	mov    %eax,(%esp)
     845:	e8 54 fc ff ff       	call   49e <listcmd>
     84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     850:	c9                   	leave  
     851:	c3                   	ret    

00000852 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     852:	55                   	push   %ebp
     853:	89 e5                	mov    %esp,%ebp
     855:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     858:	8b 45 0c             	mov    0xc(%ebp),%eax
     85b:	89 44 24 04          	mov    %eax,0x4(%esp)
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	89 04 24             	mov    %eax,(%esp)
     865:	e8 68 02 00 00       	call   ad2 <parseexec>
     86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     86d:	c7 44 24 08 35 15 00 	movl   $0x1535,0x8(%esp)
     874:	00 
     875:	8b 45 0c             	mov    0xc(%ebp),%eax
     878:	89 44 24 04          	mov    %eax,0x4(%esp)
     87c:	8b 45 08             	mov    0x8(%ebp),%eax
     87f:	89 04 24             	mov    %eax,(%esp)
     882:	e8 f6 fd ff ff       	call   67d <peek>
     887:	85 c0                	test   %eax,%eax
     889:	74 46                	je     8d1 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     88b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     892:	00 
     893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     89a:	00 
     89b:	8b 45 0c             	mov    0xc(%ebp),%eax
     89e:	89 44 24 04          	mov    %eax,0x4(%esp)
     8a2:	8b 45 08             	mov    0x8(%ebp),%eax
     8a5:	89 04 24             	mov    %eax,(%esp)
     8a8:	e8 88 fc ff ff       	call   535 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b4:	8b 45 08             	mov    0x8(%ebp),%eax
     8b7:	89 04 24             	mov    %eax,(%esp)
     8ba:	e8 93 ff ff ff       	call   852 <parsepipe>
     8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c6:	89 04 24             	mov    %eax,(%esp)
     8c9:	e8 80 fb ff ff       	call   44e <pipecmd>
     8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8d4:	c9                   	leave  
     8d5:	c3                   	ret    

000008d6 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8d6:	55                   	push   %ebp
     8d7:	89 e5                	mov    %esp,%ebp
     8d9:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8dc:	e9 f6 00 00 00       	jmp    9d7 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     8e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8e8:	00 
     8e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8f0:	00 
     8f1:	8b 45 10             	mov    0x10(%ebp),%eax
     8f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 32 fc ff ff       	call   535 <gettoken>
     903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     906:	8d 45 ec             	lea    -0x14(%ebp),%eax
     909:	89 44 24 0c          	mov    %eax,0xc(%esp)
     90d:	8d 45 f0             	lea    -0x10(%ebp),%eax
     910:	89 44 24 08          	mov    %eax,0x8(%esp)
     914:	8b 45 10             	mov    0x10(%ebp),%eax
     917:	89 44 24 04          	mov    %eax,0x4(%esp)
     91b:	8b 45 0c             	mov    0xc(%ebp),%eax
     91e:	89 04 24             	mov    %eax,(%esp)
     921:	e8 0f fc ff ff       	call   535 <gettoken>
     926:	83 f8 61             	cmp    $0x61,%eax
     929:	74 0c                	je     937 <parseredirs+0x61>
      panic("missing file for redirection");
     92b:	c7 04 24 37 15 00 00 	movl   $0x1537,(%esp)
     932:	e8 23 fa ff ff       	call   35a <panic>
    switch(tok){
     937:	8b 45 f4             	mov    -0xc(%ebp),%eax
     93a:	83 f8 3c             	cmp    $0x3c,%eax
     93d:	74 0f                	je     94e <parseredirs+0x78>
     93f:	83 f8 3e             	cmp    $0x3e,%eax
     942:	74 38                	je     97c <parseredirs+0xa6>
     944:	83 f8 2b             	cmp    $0x2b,%eax
     947:	74 61                	je     9aa <parseredirs+0xd4>
     949:	e9 89 00 00 00       	jmp    9d7 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     94e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     951:	8b 45 f0             	mov    -0x10(%ebp),%eax
     954:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     95b:	00 
     95c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     963:	00 
     964:	89 54 24 08          	mov    %edx,0x8(%esp)
     968:	89 44 24 04          	mov    %eax,0x4(%esp)
     96c:	8b 45 08             	mov    0x8(%ebp),%eax
     96f:	89 04 24             	mov    %eax,(%esp)
     972:	e8 6c fa ff ff       	call   3e3 <redircmd>
     977:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     97a:	eb 5b                	jmp    9d7 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     97c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     982:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     989:	00 
     98a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     991:	00 
     992:	89 54 24 08          	mov    %edx,0x8(%esp)
     996:	89 44 24 04          	mov    %eax,0x4(%esp)
     99a:	8b 45 08             	mov    0x8(%ebp),%eax
     99d:	89 04 24             	mov    %eax,(%esp)
     9a0:	e8 3e fa ff ff       	call   3e3 <redircmd>
     9a5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9a8:	eb 2d                	jmp    9d7 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9b0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     9b7:	00 
     9b8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9bf:	00 
     9c0:	89 54 24 08          	mov    %edx,0x8(%esp)
     9c4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c8:	8b 45 08             	mov    0x8(%ebp),%eax
     9cb:	89 04 24             	mov    %eax,(%esp)
     9ce:	e8 10 fa ff ff       	call   3e3 <redircmd>
     9d3:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9d6:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9d7:	c7 44 24 08 54 15 00 	movl   $0x1554,0x8(%esp)
     9de:	00 
     9df:	8b 45 10             	mov    0x10(%ebp),%eax
     9e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e6:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e9:	89 04 24             	mov    %eax,(%esp)
     9ec:	e8 8c fc ff ff       	call   67d <peek>
     9f1:	85 c0                	test   %eax,%eax
     9f3:	0f 85 e8 fe ff ff    	jne    8e1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9fc:	c9                   	leave  
     9fd:	c3                   	ret    

000009fe <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9fe:	55                   	push   %ebp
     9ff:	89 e5                	mov    %esp,%ebp
     a01:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a04:	c7 44 24 08 57 15 00 	movl   $0x1557,0x8(%esp)
     a0b:	00 
     a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a13:	8b 45 08             	mov    0x8(%ebp),%eax
     a16:	89 04 24             	mov    %eax,(%esp)
     a19:	e8 5f fc ff ff       	call   67d <peek>
     a1e:	85 c0                	test   %eax,%eax
     a20:	75 0c                	jne    a2e <parseblock+0x30>
    panic("parseblock");
     a22:	c7 04 24 59 15 00 00 	movl   $0x1559,(%esp)
     a29:	e8 2c f9 ff ff       	call   35a <panic>
  gettoken(ps, es, 0, 0);
     a2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a35:	00 
     a36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a3d:	00 
     a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     a41:	89 44 24 04          	mov    %eax,0x4(%esp)
     a45:	8b 45 08             	mov    0x8(%ebp),%eax
     a48:	89 04 24             	mov    %eax,(%esp)
     a4b:	e8 e5 fa ff ff       	call   535 <gettoken>
  cmd = parseline(ps, es);
     a50:	8b 45 0c             	mov    0xc(%ebp),%eax
     a53:	89 44 24 04          	mov    %eax,0x4(%esp)
     a57:	8b 45 08             	mov    0x8(%ebp),%eax
     a5a:	89 04 24             	mov    %eax,(%esp)
     a5d:	e8 1c fd ff ff       	call   77e <parseline>
     a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a65:	c7 44 24 08 64 15 00 	movl   $0x1564,0x8(%esp)
     a6c:	00 
     a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     a70:	89 44 24 04          	mov    %eax,0x4(%esp)
     a74:	8b 45 08             	mov    0x8(%ebp),%eax
     a77:	89 04 24             	mov    %eax,(%esp)
     a7a:	e8 fe fb ff ff       	call   67d <peek>
     a7f:	85 c0                	test   %eax,%eax
     a81:	75 0c                	jne    a8f <parseblock+0x91>
    panic("syntax - missing )");
     a83:	c7 04 24 66 15 00 00 	movl   $0x1566,(%esp)
     a8a:	e8 cb f8 ff ff       	call   35a <panic>
  gettoken(ps, es, 0, 0);
     a8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a96:	00 
     a97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a9e:	00 
     a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa6:	8b 45 08             	mov    0x8(%ebp),%eax
     aa9:	89 04 24             	mov    %eax,(%esp)
     aac:	e8 84 fa ff ff       	call   535 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab8:	8b 45 08             	mov    0x8(%ebp),%eax
     abb:	89 44 24 04          	mov    %eax,0x4(%esp)
     abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac2:	89 04 24             	mov    %eax,(%esp)
     ac5:	e8 0c fe ff ff       	call   8d6 <parseredirs>
     aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ad0:	c9                   	leave  
     ad1:	c3                   	ret    

00000ad2 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     ad2:	55                   	push   %ebp
     ad3:	89 e5                	mov    %esp,%ebp
     ad5:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     ad8:	c7 44 24 08 57 15 00 	movl   $0x1557,0x8(%esp)
     adf:	00 
     ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae7:	8b 45 08             	mov    0x8(%ebp),%eax
     aea:	89 04 24             	mov    %eax,(%esp)
     aed:	e8 8b fb ff ff       	call   67d <peek>
     af2:	85 c0                	test   %eax,%eax
     af4:	74 17                	je     b0d <parseexec+0x3b>
    return parseblock(ps, es);
     af6:	8b 45 0c             	mov    0xc(%ebp),%eax
     af9:	89 44 24 04          	mov    %eax,0x4(%esp)
     afd:	8b 45 08             	mov    0x8(%ebp),%eax
     b00:	89 04 24             	mov    %eax,(%esp)
     b03:	e8 f6 fe ff ff       	call   9fe <parseblock>
     b08:	e9 0b 01 00 00       	jmp    c18 <parseexec+0x146>

  ret = execcmd();
     b0d:	e8 93 f8 ff ff       	call   3a5 <execcmd>
     b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b18:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     b22:	8b 45 0c             	mov    0xc(%ebp),%eax
     b25:	89 44 24 08          	mov    %eax,0x8(%esp)
     b29:	8b 45 08             	mov    0x8(%ebp),%eax
     b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
     b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b33:	89 04 24             	mov    %eax,(%esp)
     b36:	e8 9b fd ff ff       	call   8d6 <parseredirs>
     b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b3e:	e9 8e 00 00 00       	jmp    bd1 <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b43:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b46:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
     b51:	8b 45 0c             	mov    0xc(%ebp),%eax
     b54:	89 44 24 04          	mov    %eax,0x4(%esp)
     b58:	8b 45 08             	mov    0x8(%ebp),%eax
     b5b:	89 04 24             	mov    %eax,(%esp)
     b5e:	e8 d2 f9 ff ff       	call   535 <gettoken>
     b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b6a:	0f 84 85 00 00 00    	je     bf5 <parseexec+0x123>
      break;
    if(tok != 'a')
     b70:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b74:	74 0c                	je     b82 <parseexec+0xb0>
      panic("syntax");
     b76:	c7 04 24 2a 15 00 00 	movl   $0x152a,(%esp)
     b7d:	e8 d8 f7 ff ff       	call   35a <panic>
    cmd->argv[argc] = q;
     b82:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b8b:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b95:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b98:	83 c1 08             	add    $0x8,%ecx
     b9b:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b9f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     ba3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ba7:	7e 0c                	jle    bb5 <parseexec+0xe3>
      panic("too many args");
     ba9:	c7 04 24 79 15 00 00 	movl   $0x1579,(%esp)
     bb0:	e8 a5 f7 ff ff       	call   35a <panic>
    ret = parseredirs(ret, ps, es);
     bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb8:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbc:	8b 45 08             	mov    0x8(%ebp),%eax
     bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bc6:	89 04 24             	mov    %eax,(%esp)
     bc9:	e8 08 fd ff ff       	call   8d6 <parseredirs>
     bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     bd1:	c7 44 24 08 87 15 00 	movl   $0x1587,0x8(%esp)
     bd8:	00 
     bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
     bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
     be0:	8b 45 08             	mov    0x8(%ebp),%eax
     be3:	89 04 24             	mov    %eax,(%esp)
     be6:	e8 92 fa ff ff       	call   67d <peek>
     beb:	85 c0                	test   %eax,%eax
     bed:	0f 84 50 ff ff ff    	je     b43 <parseexec+0x71>
     bf3:	eb 01                	jmp    bf6 <parseexec+0x124>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     bf5:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bfc:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c03:	00 
  cmd->eargv[argc] = 0;
     c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c0a:	83 c2 08             	add    $0x8,%edx
     c0d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c14:	00 
  return ret;
     c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     c18:	c9                   	leave  
     c19:	c3                   	ret    

00000c1a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     c1a:	55                   	push   %ebp
     c1b:	89 e5                	mov    %esp,%ebp
     c1d:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c24:	75 0a                	jne    c30 <nulterminate+0x16>
    return 0;
     c26:	b8 00 00 00 00       	mov    $0x0,%eax
     c2b:	e9 c9 00 00 00       	jmp    cf9 <nulterminate+0xdf>
  
  switch(cmd->type){
     c30:	8b 45 08             	mov    0x8(%ebp),%eax
     c33:	8b 00                	mov    (%eax),%eax
     c35:	83 f8 05             	cmp    $0x5,%eax
     c38:	0f 87 b8 00 00 00    	ja     cf6 <nulterminate+0xdc>
     c3e:	8b 04 85 8c 15 00 00 	mov    0x158c(,%eax,4),%eax
     c45:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c47:	8b 45 08             	mov    0x8(%ebp),%eax
     c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c54:	eb 14                	jmp    c6a <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c5c:	83 c2 08             	add    $0x8,%edx
     c5f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c63:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c70:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c74:	85 c0                	test   %eax,%eax
     c76:	75 de                	jne    c56 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c78:	eb 7c                	jmp    cf6 <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c7a:	8b 45 08             	mov    0x8(%ebp),%eax
     c7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c83:	8b 40 04             	mov    0x4(%eax),%eax
     c86:	89 04 24             	mov    %eax,(%esp)
     c89:	e8 8c ff ff ff       	call   c1a <nulterminate>
    *rcmd->efile = 0;
     c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c91:	8b 40 0c             	mov    0xc(%eax),%eax
     c94:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c97:	eb 5d                	jmp    cf6 <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c99:	8b 45 08             	mov    0x8(%ebp),%eax
     c9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ca2:	8b 40 04             	mov    0x4(%eax),%eax
     ca5:	89 04 24             	mov    %eax,(%esp)
     ca8:	e8 6d ff ff ff       	call   c1a <nulterminate>
    nulterminate(pcmd->right);
     cad:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cb0:	8b 40 08             	mov    0x8(%eax),%eax
     cb3:	89 04 24             	mov    %eax,(%esp)
     cb6:	e8 5f ff ff ff       	call   c1a <nulterminate>
    break;
     cbb:	eb 39                	jmp    cf6 <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     cbd:	8b 45 08             	mov    0x8(%ebp),%eax
     cc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     cc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cc6:	8b 40 04             	mov    0x4(%eax),%eax
     cc9:	89 04 24             	mov    %eax,(%esp)
     ccc:	e8 49 ff ff ff       	call   c1a <nulterminate>
    nulterminate(lcmd->right);
     cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cd4:	8b 40 08             	mov    0x8(%eax),%eax
     cd7:	89 04 24             	mov    %eax,(%esp)
     cda:	e8 3b ff ff ff       	call   c1a <nulterminate>
    break;
     cdf:	eb 15                	jmp    cf6 <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     ce1:	8b 45 08             	mov    0x8(%ebp),%eax
     ce4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     cea:	8b 40 04             	mov    0x4(%eax),%eax
     ced:	89 04 24             	mov    %eax,(%esp)
     cf0:	e8 25 ff ff ff       	call   c1a <nulterminate>
    break;
     cf5:	90                   	nop
  }
  return cmd;
     cf6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cf9:	c9                   	leave  
     cfa:	c3                   	ret    
     cfb:	90                   	nop

00000cfc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     cfc:	55                   	push   %ebp
     cfd:	89 e5                	mov    %esp,%ebp
     cff:	57                   	push   %edi
     d00:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     d01:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d04:	8b 55 10             	mov    0x10(%ebp),%edx
     d07:	8b 45 0c             	mov    0xc(%ebp),%eax
     d0a:	89 cb                	mov    %ecx,%ebx
     d0c:	89 df                	mov    %ebx,%edi
     d0e:	89 d1                	mov    %edx,%ecx
     d10:	fc                   	cld    
     d11:	f3 aa                	rep stos %al,%es:(%edi)
     d13:	89 ca                	mov    %ecx,%edx
     d15:	89 fb                	mov    %edi,%ebx
     d17:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d1a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d1d:	5b                   	pop    %ebx
     d1e:	5f                   	pop    %edi
     d1f:	5d                   	pop    %ebp
     d20:	c3                   	ret    

00000d21 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     d21:	55                   	push   %ebp
     d22:	89 e5                	mov    %esp,%ebp
     d24:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d27:	8b 45 08             	mov    0x8(%ebp),%eax
     d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d2d:	90                   	nop
     d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
     d31:	0f b6 10             	movzbl (%eax),%edx
     d34:	8b 45 08             	mov    0x8(%ebp),%eax
     d37:	88 10                	mov    %dl,(%eax)
     d39:	8b 45 08             	mov    0x8(%ebp),%eax
     d3c:	0f b6 00             	movzbl (%eax),%eax
     d3f:	84 c0                	test   %al,%al
     d41:	0f 95 c0             	setne  %al
     d44:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d48:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     d4c:	84 c0                	test   %al,%al
     d4e:	75 de                	jne    d2e <strcpy+0xd>
    ;
  return os;
     d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d53:	c9                   	leave  
     d54:	c3                   	ret    

00000d55 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d55:	55                   	push   %ebp
     d56:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d58:	eb 08                	jmp    d62 <strcmp+0xd>
    p++, q++;
     d5a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d5e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d62:	8b 45 08             	mov    0x8(%ebp),%eax
     d65:	0f b6 00             	movzbl (%eax),%eax
     d68:	84 c0                	test   %al,%al
     d6a:	74 10                	je     d7c <strcmp+0x27>
     d6c:	8b 45 08             	mov    0x8(%ebp),%eax
     d6f:	0f b6 10             	movzbl (%eax),%edx
     d72:	8b 45 0c             	mov    0xc(%ebp),%eax
     d75:	0f b6 00             	movzbl (%eax),%eax
     d78:	38 c2                	cmp    %al,%dl
     d7a:	74 de                	je     d5a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d7c:	8b 45 08             	mov    0x8(%ebp),%eax
     d7f:	0f b6 00             	movzbl (%eax),%eax
     d82:	0f b6 d0             	movzbl %al,%edx
     d85:	8b 45 0c             	mov    0xc(%ebp),%eax
     d88:	0f b6 00             	movzbl (%eax),%eax
     d8b:	0f b6 c0             	movzbl %al,%eax
     d8e:	89 d1                	mov    %edx,%ecx
     d90:	29 c1                	sub    %eax,%ecx
     d92:	89 c8                	mov    %ecx,%eax
}
     d94:	5d                   	pop    %ebp
     d95:	c3                   	ret    

00000d96 <strlen>:

uint
strlen(char *s)
{
     d96:	55                   	push   %ebp
     d97:	89 e5                	mov    %esp,%ebp
     d99:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     da3:	eb 04                	jmp    da9 <strlen+0x13>
     da5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     da9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     dac:	8b 45 08             	mov    0x8(%ebp),%eax
     daf:	01 d0                	add    %edx,%eax
     db1:	0f b6 00             	movzbl (%eax),%eax
     db4:	84 c0                	test   %al,%al
     db6:	75 ed                	jne    da5 <strlen+0xf>
    ;
  return n;
     db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     dbb:	c9                   	leave  
     dbc:	c3                   	ret    

00000dbd <memset>:

void*
memset(void *dst, int c, uint n)
{
     dbd:	55                   	push   %ebp
     dbe:	89 e5                	mov    %esp,%ebp
     dc0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     dc3:	8b 45 10             	mov    0x10(%ebp),%eax
     dc6:	89 44 24 08          	mov    %eax,0x8(%esp)
     dca:	8b 45 0c             	mov    0xc(%ebp),%eax
     dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
     dd1:	8b 45 08             	mov    0x8(%ebp),%eax
     dd4:	89 04 24             	mov    %eax,(%esp)
     dd7:	e8 20 ff ff ff       	call   cfc <stosb>
  return dst;
     ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ddf:	c9                   	leave  
     de0:	c3                   	ret    

00000de1 <strchr>:

char*
strchr(const char *s, char c)
{
     de1:	55                   	push   %ebp
     de2:	89 e5                	mov    %esp,%ebp
     de4:	83 ec 04             	sub    $0x4,%esp
     de7:	8b 45 0c             	mov    0xc(%ebp),%eax
     dea:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     ded:	eb 14                	jmp    e03 <strchr+0x22>
    if(*s == c)
     def:	8b 45 08             	mov    0x8(%ebp),%eax
     df2:	0f b6 00             	movzbl (%eax),%eax
     df5:	3a 45 fc             	cmp    -0x4(%ebp),%al
     df8:	75 05                	jne    dff <strchr+0x1e>
      return (char*)s;
     dfa:	8b 45 08             	mov    0x8(%ebp),%eax
     dfd:	eb 13                	jmp    e12 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     dff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     e03:	8b 45 08             	mov    0x8(%ebp),%eax
     e06:	0f b6 00             	movzbl (%eax),%eax
     e09:	84 c0                	test   %al,%al
     e0b:	75 e2                	jne    def <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e12:	c9                   	leave  
     e13:	c3                   	ret    

00000e14 <gets>:

char*
gets(char *buf, int max)
{
     e14:	55                   	push   %ebp
     e15:	89 e5                	mov    %esp,%ebp
     e17:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e21:	eb 46                	jmp    e69 <gets+0x55>
    cc = read(0, &c, 1);
     e23:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e2a:	00 
     e2b:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
     e32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e39:	e8 3e 01 00 00       	call   f7c <read>
     e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e45:	7e 2f                	jle    e76 <gets+0x62>
      break;
    buf[i++] = c;
     e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e4a:	8b 45 08             	mov    0x8(%ebp),%eax
     e4d:	01 c2                	add    %eax,%edx
     e4f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e53:	88 02                	mov    %al,(%edx)
     e55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     e59:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e5d:	3c 0a                	cmp    $0xa,%al
     e5f:	74 16                	je     e77 <gets+0x63>
     e61:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e65:	3c 0d                	cmp    $0xd,%al
     e67:	74 0e                	je     e77 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e6c:	83 c0 01             	add    $0x1,%eax
     e6f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e72:	7c af                	jl     e23 <gets+0xf>
     e74:	eb 01                	jmp    e77 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     e76:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e7a:	8b 45 08             	mov    0x8(%ebp),%eax
     e7d:	01 d0                	add    %edx,%eax
     e7f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e82:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e85:	c9                   	leave  
     e86:	c3                   	ret    

00000e87 <stat>:

int
stat(char *n, struct stat *st)
{
     e87:	55                   	push   %ebp
     e88:	89 e5                	mov    %esp,%ebp
     e8a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e94:	00 
     e95:	8b 45 08             	mov    0x8(%ebp),%eax
     e98:	89 04 24             	mov    %eax,(%esp)
     e9b:	e8 04 01 00 00       	call   fa4 <open>
     ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ea7:	79 07                	jns    eb0 <stat+0x29>
    return -1;
     ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eae:	eb 23                	jmp    ed3 <stat+0x4c>
  r = fstat(fd, st);
     eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eba:	89 04 24             	mov    %eax,(%esp)
     ebd:	e8 fa 00 00 00       	call   fbc <fstat>
     ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ec8:	89 04 24             	mov    %eax,(%esp)
     ecb:	e8 bc 00 00 00       	call   f8c <close>
  return r;
     ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ed3:	c9                   	leave  
     ed4:	c3                   	ret    

00000ed5 <atoi>:

int
atoi(const char *s)
{
     ed5:	55                   	push   %ebp
     ed6:	89 e5                	mov    %esp,%ebp
     ed8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     edb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ee2:	eb 23                	jmp    f07 <atoi+0x32>
    n = n*10 + *s++ - '0';
     ee4:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ee7:	89 d0                	mov    %edx,%eax
     ee9:	c1 e0 02             	shl    $0x2,%eax
     eec:	01 d0                	add    %edx,%eax
     eee:	01 c0                	add    %eax,%eax
     ef0:	89 c2                	mov    %eax,%edx
     ef2:	8b 45 08             	mov    0x8(%ebp),%eax
     ef5:	0f b6 00             	movzbl (%eax),%eax
     ef8:	0f be c0             	movsbl %al,%eax
     efb:	01 d0                	add    %edx,%eax
     efd:	83 e8 30             	sub    $0x30,%eax
     f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
     f03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f07:	8b 45 08             	mov    0x8(%ebp),%eax
     f0a:	0f b6 00             	movzbl (%eax),%eax
     f0d:	3c 2f                	cmp    $0x2f,%al
     f0f:	7e 0a                	jle    f1b <atoi+0x46>
     f11:	8b 45 08             	mov    0x8(%ebp),%eax
     f14:	0f b6 00             	movzbl (%eax),%eax
     f17:	3c 39                	cmp    $0x39,%al
     f19:	7e c9                	jle    ee4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f1e:	c9                   	leave  
     f1f:	c3                   	ret    

00000f20 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f20:	55                   	push   %ebp
     f21:	89 e5                	mov    %esp,%ebp
     f23:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f26:	8b 45 08             	mov    0x8(%ebp),%eax
     f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
     f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f32:	eb 13                	jmp    f47 <memmove+0x27>
    *dst++ = *src++;
     f34:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f37:	0f b6 10             	movzbl (%eax),%edx
     f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f3d:	88 10                	mov    %dl,(%eax)
     f3f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     f43:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f4b:	0f 9f c0             	setg   %al
     f4e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     f52:	84 c0                	test   %al,%al
     f54:	75 de                	jne    f34 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f56:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f59:	c9                   	leave  
     f5a:	c3                   	ret    
     f5b:	90                   	nop

00000f5c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f5c:	b8 01 00 00 00       	mov    $0x1,%eax
     f61:	cd 40                	int    $0x40
     f63:	c3                   	ret    

00000f64 <exit>:
SYSCALL(exit)
     f64:	b8 02 00 00 00       	mov    $0x2,%eax
     f69:	cd 40                	int    $0x40
     f6b:	c3                   	ret    

00000f6c <wait>:
SYSCALL(wait)
     f6c:	b8 03 00 00 00       	mov    $0x3,%eax
     f71:	cd 40                	int    $0x40
     f73:	c3                   	ret    

00000f74 <pipe>:
SYSCALL(pipe)
     f74:	b8 04 00 00 00       	mov    $0x4,%eax
     f79:	cd 40                	int    $0x40
     f7b:	c3                   	ret    

00000f7c <read>:
SYSCALL(read)
     f7c:	b8 05 00 00 00       	mov    $0x5,%eax
     f81:	cd 40                	int    $0x40
     f83:	c3                   	ret    

00000f84 <write>:
SYSCALL(write)
     f84:	b8 10 00 00 00       	mov    $0x10,%eax
     f89:	cd 40                	int    $0x40
     f8b:	c3                   	ret    

00000f8c <close>:
SYSCALL(close)
     f8c:	b8 15 00 00 00       	mov    $0x15,%eax
     f91:	cd 40                	int    $0x40
     f93:	c3                   	ret    

00000f94 <kill>:
SYSCALL(kill)
     f94:	b8 06 00 00 00       	mov    $0x6,%eax
     f99:	cd 40                	int    $0x40
     f9b:	c3                   	ret    

00000f9c <exec>:
SYSCALL(exec)
     f9c:	b8 07 00 00 00       	mov    $0x7,%eax
     fa1:	cd 40                	int    $0x40
     fa3:	c3                   	ret    

00000fa4 <open>:
SYSCALL(open)
     fa4:	b8 0f 00 00 00       	mov    $0xf,%eax
     fa9:	cd 40                	int    $0x40
     fab:	c3                   	ret    

00000fac <mknod>:
SYSCALL(mknod)
     fac:	b8 11 00 00 00       	mov    $0x11,%eax
     fb1:	cd 40                	int    $0x40
     fb3:	c3                   	ret    

00000fb4 <unlink>:
SYSCALL(unlink)
     fb4:	b8 12 00 00 00       	mov    $0x12,%eax
     fb9:	cd 40                	int    $0x40
     fbb:	c3                   	ret    

00000fbc <fstat>:
SYSCALL(fstat)
     fbc:	b8 08 00 00 00       	mov    $0x8,%eax
     fc1:	cd 40                	int    $0x40
     fc3:	c3                   	ret    

00000fc4 <link>:
SYSCALL(link)
     fc4:	b8 13 00 00 00       	mov    $0x13,%eax
     fc9:	cd 40                	int    $0x40
     fcb:	c3                   	ret    

00000fcc <mkdir>:
SYSCALL(mkdir)
     fcc:	b8 14 00 00 00       	mov    $0x14,%eax
     fd1:	cd 40                	int    $0x40
     fd3:	c3                   	ret    

00000fd4 <chdir>:
SYSCALL(chdir)
     fd4:	b8 09 00 00 00       	mov    $0x9,%eax
     fd9:	cd 40                	int    $0x40
     fdb:	c3                   	ret    

00000fdc <dup>:
SYSCALL(dup)
     fdc:	b8 0a 00 00 00       	mov    $0xa,%eax
     fe1:	cd 40                	int    $0x40
     fe3:	c3                   	ret    

00000fe4 <getpid>:
SYSCALL(getpid)
     fe4:	b8 0b 00 00 00       	mov    $0xb,%eax
     fe9:	cd 40                	int    $0x40
     feb:	c3                   	ret    

00000fec <sbrk>:
SYSCALL(sbrk)
     fec:	b8 0c 00 00 00       	mov    $0xc,%eax
     ff1:	cd 40                	int    $0x40
     ff3:	c3                   	ret    

00000ff4 <sleep>:
SYSCALL(sleep)
     ff4:	b8 0d 00 00 00       	mov    $0xd,%eax
     ff9:	cd 40                	int    $0x40
     ffb:	c3                   	ret    

00000ffc <uptime>:
SYSCALL(uptime)
     ffc:	b8 0e 00 00 00       	mov    $0xe,%eax
    1001:	cd 40                	int    $0x40
    1003:	c3                   	ret    

00001004 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1004:	55                   	push   %ebp
    1005:	89 e5                	mov    %esp,%ebp
    1007:	83 ec 28             	sub    $0x28,%esp
    100a:	8b 45 0c             	mov    0xc(%ebp),%eax
    100d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1010:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1017:	00 
    1018:	8d 45 f4             	lea    -0xc(%ebp),%eax
    101b:	89 44 24 04          	mov    %eax,0x4(%esp)
    101f:	8b 45 08             	mov    0x8(%ebp),%eax
    1022:	89 04 24             	mov    %eax,(%esp)
    1025:	e8 5a ff ff ff       	call   f84 <write>
}
    102a:	c9                   	leave  
    102b:	c3                   	ret    

0000102c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    102c:	55                   	push   %ebp
    102d:	89 e5                	mov    %esp,%ebp
    102f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1032:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1039:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    103d:	74 17                	je     1056 <printint+0x2a>
    103f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1043:	79 11                	jns    1056 <printint+0x2a>
    neg = 1;
    1045:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    104c:	8b 45 0c             	mov    0xc(%ebp),%eax
    104f:	f7 d8                	neg    %eax
    1051:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1054:	eb 06                	jmp    105c <printint+0x30>
  } else {
    x = xx;
    1056:	8b 45 0c             	mov    0xc(%ebp),%eax
    1059:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    105c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1063:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1066:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1069:	ba 00 00 00 00       	mov    $0x0,%edx
    106e:	f7 f1                	div    %ecx
    1070:	89 d0                	mov    %edx,%eax
    1072:	0f b6 80 34 1a 00 00 	movzbl 0x1a34(%eax),%eax
    1079:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    107c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    107f:	01 ca                	add    %ecx,%edx
    1081:	88 02                	mov    %al,(%edx)
    1083:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
    1087:	8b 55 10             	mov    0x10(%ebp),%edx
    108a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    108d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1090:	ba 00 00 00 00       	mov    $0x0,%edx
    1095:	f7 75 d4             	divl   -0x2c(%ebp)
    1098:	89 45 ec             	mov    %eax,-0x14(%ebp)
    109b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    109f:	75 c2                	jne    1063 <printint+0x37>
  if(neg)
    10a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10a5:	74 2e                	je     10d5 <printint+0xa9>
    buf[i++] = '-';
    10a7:	8d 55 dc             	lea    -0x24(%ebp),%edx
    10aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10ad:	01 d0                	add    %edx,%eax
    10af:	c6 00 2d             	movb   $0x2d,(%eax)
    10b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
    10b6:	eb 1d                	jmp    10d5 <printint+0xa9>
    putc(fd, buf[i]);
    10b8:	8d 55 dc             	lea    -0x24(%ebp),%edx
    10bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10be:	01 d0                	add    %edx,%eax
    10c0:	0f b6 00             	movzbl (%eax),%eax
    10c3:	0f be c0             	movsbl %al,%eax
    10c6:	89 44 24 04          	mov    %eax,0x4(%esp)
    10ca:	8b 45 08             	mov    0x8(%ebp),%eax
    10cd:	89 04 24             	mov    %eax,(%esp)
    10d0:	e8 2f ff ff ff       	call   1004 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    10d5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10dd:	79 d9                	jns    10b8 <printint+0x8c>
    putc(fd, buf[i]);
}
    10df:	c9                   	leave  
    10e0:	c3                   	ret    

000010e1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    10e1:	55                   	push   %ebp
    10e2:	89 e5                	mov    %esp,%ebp
    10e4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10ee:	8d 45 0c             	lea    0xc(%ebp),%eax
    10f1:	83 c0 04             	add    $0x4,%eax
    10f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    10f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    10fe:	e9 7d 01 00 00       	jmp    1280 <printf+0x19f>
    c = fmt[i] & 0xff;
    1103:	8b 55 0c             	mov    0xc(%ebp),%edx
    1106:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1109:	01 d0                	add    %edx,%eax
    110b:	0f b6 00             	movzbl (%eax),%eax
    110e:	0f be c0             	movsbl %al,%eax
    1111:	25 ff 00 00 00       	and    $0xff,%eax
    1116:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1119:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    111d:	75 2c                	jne    114b <printf+0x6a>
      if(c == '%'){
    111f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1123:	75 0c                	jne    1131 <printf+0x50>
        state = '%';
    1125:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    112c:	e9 4b 01 00 00       	jmp    127c <printf+0x19b>
      } else {
        putc(fd, c);
    1131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1134:	0f be c0             	movsbl %al,%eax
    1137:	89 44 24 04          	mov    %eax,0x4(%esp)
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	89 04 24             	mov    %eax,(%esp)
    1141:	e8 be fe ff ff       	call   1004 <putc>
    1146:	e9 31 01 00 00       	jmp    127c <printf+0x19b>
      }
    } else if(state == '%'){
    114b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    114f:	0f 85 27 01 00 00    	jne    127c <printf+0x19b>
      if(c == 'd'){
    1155:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1159:	75 2d                	jne    1188 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    115b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    115e:	8b 00                	mov    (%eax),%eax
    1160:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1167:	00 
    1168:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    116f:	00 
    1170:	89 44 24 04          	mov    %eax,0x4(%esp)
    1174:	8b 45 08             	mov    0x8(%ebp),%eax
    1177:	89 04 24             	mov    %eax,(%esp)
    117a:	e8 ad fe ff ff       	call   102c <printint>
        ap++;
    117f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1183:	e9 ed 00 00 00       	jmp    1275 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    1188:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    118c:	74 06                	je     1194 <printf+0xb3>
    118e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1192:	75 2d                	jne    11c1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1194:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1197:	8b 00                	mov    (%eax),%eax
    1199:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    11a0:	00 
    11a1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    11a8:	00 
    11a9:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ad:	8b 45 08             	mov    0x8(%ebp),%eax
    11b0:	89 04 24             	mov    %eax,(%esp)
    11b3:	e8 74 fe ff ff       	call   102c <printint>
        ap++;
    11b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11bc:	e9 b4 00 00 00       	jmp    1275 <printf+0x194>
      } else if(c == 's'){
    11c1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    11c5:	75 46                	jne    120d <printf+0x12c>
        s = (char*)*ap;
    11c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11ca:	8b 00                	mov    (%eax),%eax
    11cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    11cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    11d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11d7:	75 27                	jne    1200 <printf+0x11f>
          s = "(null)";
    11d9:	c7 45 f4 a4 15 00 00 	movl   $0x15a4,-0xc(%ebp)
        while(*s != 0){
    11e0:	eb 1e                	jmp    1200 <printf+0x11f>
          putc(fd, *s);
    11e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11e5:	0f b6 00             	movzbl (%eax),%eax
    11e8:	0f be c0             	movsbl %al,%eax
    11eb:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ef:	8b 45 08             	mov    0x8(%ebp),%eax
    11f2:	89 04 24             	mov    %eax,(%esp)
    11f5:	e8 0a fe ff ff       	call   1004 <putc>
          s++;
    11fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11fe:	eb 01                	jmp    1201 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1200:	90                   	nop
    1201:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1204:	0f b6 00             	movzbl (%eax),%eax
    1207:	84 c0                	test   %al,%al
    1209:	75 d7                	jne    11e2 <printf+0x101>
    120b:	eb 68                	jmp    1275 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    120d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1211:	75 1d                	jne    1230 <printf+0x14f>
        putc(fd, *ap);
    1213:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1216:	8b 00                	mov    (%eax),%eax
    1218:	0f be c0             	movsbl %al,%eax
    121b:	89 44 24 04          	mov    %eax,0x4(%esp)
    121f:	8b 45 08             	mov    0x8(%ebp),%eax
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 da fd ff ff       	call   1004 <putc>
        ap++;
    122a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    122e:	eb 45                	jmp    1275 <printf+0x194>
      } else if(c == '%'){
    1230:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1234:	75 17                	jne    124d <printf+0x16c>
        putc(fd, c);
    1236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1239:	0f be c0             	movsbl %al,%eax
    123c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1240:	8b 45 08             	mov    0x8(%ebp),%eax
    1243:	89 04 24             	mov    %eax,(%esp)
    1246:	e8 b9 fd ff ff       	call   1004 <putc>
    124b:	eb 28                	jmp    1275 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    124d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1254:	00 
    1255:	8b 45 08             	mov    0x8(%ebp),%eax
    1258:	89 04 24             	mov    %eax,(%esp)
    125b:	e8 a4 fd ff ff       	call   1004 <putc>
        putc(fd, c);
    1260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1263:	0f be c0             	movsbl %al,%eax
    1266:	89 44 24 04          	mov    %eax,0x4(%esp)
    126a:	8b 45 08             	mov    0x8(%ebp),%eax
    126d:	89 04 24             	mov    %eax,(%esp)
    1270:	e8 8f fd ff ff       	call   1004 <putc>
      }
      state = 0;
    1275:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    127c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1280:	8b 55 0c             	mov    0xc(%ebp),%edx
    1283:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1286:	01 d0                	add    %edx,%eax
    1288:	0f b6 00             	movzbl (%eax),%eax
    128b:	84 c0                	test   %al,%al
    128d:	0f 85 70 fe ff ff    	jne    1103 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1293:	c9                   	leave  
    1294:	c3                   	ret    
    1295:	90                   	nop
    1296:	90                   	nop
    1297:	90                   	nop

00001298 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1298:	55                   	push   %ebp
    1299:	89 e5                	mov    %esp,%ebp
    129b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    129e:	8b 45 08             	mov    0x8(%ebp),%eax
    12a1:	83 e8 08             	sub    $0x8,%eax
    12a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12a7:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    12ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12af:	eb 24                	jmp    12d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b4:	8b 00                	mov    (%eax),%eax
    12b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12b9:	77 12                	ja     12cd <free+0x35>
    12bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12c1:	77 24                	ja     12e7 <free+0x4f>
    12c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c6:	8b 00                	mov    (%eax),%eax
    12c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12cb:	77 1a                	ja     12e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d0:	8b 00                	mov    (%eax),%eax
    12d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12db:	76 d4                	jbe    12b1 <free+0x19>
    12dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e0:	8b 00                	mov    (%eax),%eax
    12e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12e5:	76 ca                	jbe    12b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    12e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ea:	8b 40 04             	mov    0x4(%eax),%eax
    12ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12f7:	01 c2                	add    %eax,%edx
    12f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fc:	8b 00                	mov    (%eax),%eax
    12fe:	39 c2                	cmp    %eax,%edx
    1300:	75 24                	jne    1326 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1302:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1305:	8b 50 04             	mov    0x4(%eax),%edx
    1308:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130b:	8b 00                	mov    (%eax),%eax
    130d:	8b 40 04             	mov    0x4(%eax),%eax
    1310:	01 c2                	add    %eax,%edx
    1312:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1315:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1318:	8b 45 fc             	mov    -0x4(%ebp),%eax
    131b:	8b 00                	mov    (%eax),%eax
    131d:	8b 10                	mov    (%eax),%edx
    131f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1322:	89 10                	mov    %edx,(%eax)
    1324:	eb 0a                	jmp    1330 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1326:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1329:	8b 10                	mov    (%eax),%edx
    132b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    132e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1330:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1333:	8b 40 04             	mov    0x4(%eax),%eax
    1336:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1340:	01 d0                	add    %edx,%eax
    1342:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1345:	75 20                	jne    1367 <free+0xcf>
    p->s.size += bp->s.size;
    1347:	8b 45 fc             	mov    -0x4(%ebp),%eax
    134a:	8b 50 04             	mov    0x4(%eax),%edx
    134d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1350:	8b 40 04             	mov    0x4(%eax),%eax
    1353:	01 c2                	add    %eax,%edx
    1355:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1358:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    135b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    135e:	8b 10                	mov    (%eax),%edx
    1360:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1363:	89 10                	mov    %edx,(%eax)
    1365:	eb 08                	jmp    136f <free+0xd7>
  } else
    p->s.ptr = bp;
    1367:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    136d:	89 10                	mov    %edx,(%eax)
  freep = p;
    136f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1372:	a3 cc 1a 00 00       	mov    %eax,0x1acc
}
    1377:	c9                   	leave  
    1378:	c3                   	ret    

00001379 <morecore>:

static Header*
morecore(uint nu)
{
    1379:	55                   	push   %ebp
    137a:	89 e5                	mov    %esp,%ebp
    137c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    137f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1386:	77 07                	ja     138f <morecore+0x16>
    nu = 4096;
    1388:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    138f:	8b 45 08             	mov    0x8(%ebp),%eax
    1392:	c1 e0 03             	shl    $0x3,%eax
    1395:	89 04 24             	mov    %eax,(%esp)
    1398:	e8 4f fc ff ff       	call   fec <sbrk>
    139d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    13a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    13a4:	75 07                	jne    13ad <morecore+0x34>
    return 0;
    13a6:	b8 00 00 00 00       	mov    $0x0,%eax
    13ab:	eb 22                	jmp    13cf <morecore+0x56>
  hp = (Header*)p;
    13ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    13b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13b6:	8b 55 08             	mov    0x8(%ebp),%edx
    13b9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    13bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13bf:	83 c0 08             	add    $0x8,%eax
    13c2:	89 04 24             	mov    %eax,(%esp)
    13c5:	e8 ce fe ff ff       	call   1298 <free>
  return freep;
    13ca:	a1 cc 1a 00 00       	mov    0x1acc,%eax
}
    13cf:	c9                   	leave  
    13d0:	c3                   	ret    

000013d1 <malloc>:

void*
malloc(uint nbytes)
{
    13d1:	55                   	push   %ebp
    13d2:	89 e5                	mov    %esp,%ebp
    13d4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	83 c0 07             	add    $0x7,%eax
    13dd:	c1 e8 03             	shr    $0x3,%eax
    13e0:	83 c0 01             	add    $0x1,%eax
    13e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    13e6:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    13eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13f2:	75 23                	jne    1417 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    13f4:	c7 45 f0 c4 1a 00 00 	movl   $0x1ac4,-0x10(%ebp)
    13fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13fe:	a3 cc 1a 00 00       	mov    %eax,0x1acc
    1403:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    1408:	a3 c4 1a 00 00       	mov    %eax,0x1ac4
    base.s.size = 0;
    140d:	c7 05 c8 1a 00 00 00 	movl   $0x0,0x1ac8
    1414:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1417:	8b 45 f0             	mov    -0x10(%ebp),%eax
    141a:	8b 00                	mov    (%eax),%eax
    141c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    141f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1422:	8b 40 04             	mov    0x4(%eax),%eax
    1425:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1428:	72 4d                	jb     1477 <malloc+0xa6>
      if(p->s.size == nunits)
    142a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142d:	8b 40 04             	mov    0x4(%eax),%eax
    1430:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1433:	75 0c                	jne    1441 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1435:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1438:	8b 10                	mov    (%eax),%edx
    143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    143d:	89 10                	mov    %edx,(%eax)
    143f:	eb 26                	jmp    1467 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1441:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1444:	8b 40 04             	mov    0x4(%eax),%eax
    1447:	89 c2                	mov    %eax,%edx
    1449:	2b 55 ec             	sub    -0x14(%ebp),%edx
    144c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1452:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1455:	8b 40 04             	mov    0x4(%eax),%eax
    1458:	c1 e0 03             	shl    $0x3,%eax
    145b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1461:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1464:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1467:	8b 45 f0             	mov    -0x10(%ebp),%eax
    146a:	a3 cc 1a 00 00       	mov    %eax,0x1acc
      return (void*)(p + 1);
    146f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1472:	83 c0 08             	add    $0x8,%eax
    1475:	eb 38                	jmp    14af <malloc+0xde>
    }
    if(p == freep)
    1477:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    147c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    147f:	75 1b                	jne    149c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1481:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1484:	89 04 24             	mov    %eax,(%esp)
    1487:	e8 ed fe ff ff       	call   1379 <morecore>
    148c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    148f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1493:	75 07                	jne    149c <malloc+0xcb>
        return 0;
    1495:	b8 00 00 00 00       	mov    $0x0,%eax
    149a:	eb 13                	jmp    14af <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    149c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    149f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    14a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a5:	8b 00                	mov    (%eax),%eax
    14a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    14aa:	e9 70 ff ff ff       	jmp    141f <malloc+0x4e>
}
    14af:	c9                   	leave  
    14b0:	c3                   	ret    
