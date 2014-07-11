
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <opentest>:

// simple file system tests

void
opentest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
       6:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
       b:	c7 44 24 04 a6 41 00 	movl   $0x41a6,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 a2 3d 00 00       	call   3dbd <printf>
  fd = open("echo", 0);
      1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      22:	00 
      23:	c7 04 24 90 41 00 00 	movl   $0x4190,(%esp)
      2a:	e8 51 3c 00 00       	call   3c80 <open>
      2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
      32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      36:	79 1a                	jns    52 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
      38:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
      3d:	c7 44 24 04 b1 41 00 	movl   $0x41b1,0x4(%esp)
      44:	00 
      45:	89 04 24             	mov    %eax,(%esp)
      48:	e8 70 3d 00 00       	call   3dbd <printf>
    exit();
      4d:	e8 ee 3b 00 00       	call   3c40 <exit>
  }
  close(fd);
      52:	8b 45 f4             	mov    -0xc(%ebp),%eax
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 0b 3c 00 00       	call   3c68 <close>
  fd = open("doesnotexist", 0);
      5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      64:	00 
      65:	c7 04 24 c4 41 00 00 	movl   $0x41c4,(%esp)
      6c:	e8 0f 3c 00 00       	call   3c80 <open>
      71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
      74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      78:	78 1a                	js     94 <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
      7a:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
      7f:	c7 44 24 04 d1 41 00 	movl   $0x41d1,0x4(%esp)
      86:	00 
      87:	89 04 24             	mov    %eax,(%esp)
      8a:	e8 2e 3d 00 00       	call   3dbd <printf>
    exit();
      8f:	e8 ac 3b 00 00       	call   3c40 <exit>
  }
  printf(stdout, "open test ok\n");
      94:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
      99:	c7 44 24 04 ef 41 00 	movl   $0x41ef,0x4(%esp)
      a0:	00 
      a1:	89 04 24             	mov    %eax,(%esp)
      a4:	e8 14 3d 00 00       	call   3dbd <printf>
}
      a9:	c9                   	leave  
      aa:	c3                   	ret    

000000ab <writetest>:

void
writetest(void)
{
      ab:	55                   	push   %ebp
      ac:	89 e5                	mov    %esp,%ebp
      ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
      b1:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
      b6:	c7 44 24 04 fd 41 00 	movl   $0x41fd,0x4(%esp)
      bd:	00 
      be:	89 04 24             	mov    %eax,(%esp)
      c1:	e8 f7 3c 00 00       	call   3dbd <printf>
  fd = open("small", O_CREATE|O_RDWR);
      c6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
      cd:	00 
      ce:	c7 04 24 0e 42 00 00 	movl   $0x420e,(%esp)
      d5:	e8 a6 3b 00 00       	call   3c80 <open>
      da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
      dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      e1:	78 21                	js     104 <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
      e3:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
      e8:	c7 44 24 04 14 42 00 	movl   $0x4214,0x4(%esp)
      ef:	00 
      f0:	89 04 24             	mov    %eax,(%esp)
      f3:	e8 c5 3c 00 00       	call   3dbd <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
      f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      ff:	e9 a0 00 00 00       	jmp    1a4 <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     104:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     109:	c7 44 24 04 2f 42 00 	movl   $0x422f,0x4(%esp)
     110:	00 
     111:	89 04 24             	mov    %eax,(%esp)
     114:	e8 a4 3c 00 00       	call   3dbd <printf>
    exit();
     119:	e8 22 3b 00 00       	call   3c40 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     11e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     125:	00 
     126:	c7 44 24 04 4b 42 00 	movl   $0x424b,0x4(%esp)
     12d:	00 
     12e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     131:	89 04 24             	mov    %eax,(%esp)
     134:	e8 27 3b 00 00       	call   3c60 <write>
     139:	83 f8 0a             	cmp    $0xa,%eax
     13c:	74 21                	je     15f <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     13e:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     143:	8b 55 f4             	mov    -0xc(%ebp),%edx
     146:	89 54 24 08          	mov    %edx,0x8(%esp)
     14a:	c7 44 24 04 58 42 00 	movl   $0x4258,0x4(%esp)
     151:	00 
     152:	89 04 24             	mov    %eax,(%esp)
     155:	e8 63 3c 00 00       	call   3dbd <printf>
      exit();
     15a:	e8 e1 3a 00 00       	call   3c40 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     15f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     166:	00 
     167:	c7 44 24 04 7c 42 00 	movl   $0x427c,0x4(%esp)
     16e:	00 
     16f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     172:	89 04 24             	mov    %eax,(%esp)
     175:	e8 e6 3a 00 00       	call   3c60 <write>
     17a:	83 f8 0a             	cmp    $0xa,%eax
     17d:	74 21                	je     1a0 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     17f:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     184:	8b 55 f4             	mov    -0xc(%ebp),%edx
     187:	89 54 24 08          	mov    %edx,0x8(%esp)
     18b:	c7 44 24 04 88 42 00 	movl   $0x4288,0x4(%esp)
     192:	00 
     193:	89 04 24             	mov    %eax,(%esp)
     196:	e8 22 3c 00 00       	call   3dbd <printf>
      exit();
     19b:	e8 a0 3a 00 00       	call   3c40 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     1a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1a4:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     1a8:	0f 8e 70 ff ff ff    	jle    11e <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     1ae:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     1b3:	c7 44 24 04 ac 42 00 	movl   $0x42ac,0x4(%esp)
     1ba:	00 
     1bb:	89 04 24             	mov    %eax,(%esp)
     1be:	e8 fa 3b 00 00       	call   3dbd <printf>
  close(fd);
     1c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1c6:	89 04 24             	mov    %eax,(%esp)
     1c9:	e8 9a 3a 00 00       	call   3c68 <close>
  fd = open("small", O_RDONLY);
     1ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     1d5:	00 
     1d6:	c7 04 24 0e 42 00 00 	movl   $0x420e,(%esp)
     1dd:	e8 9e 3a 00 00       	call   3c80 <open>
     1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     1e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1e9:	78 3e                	js     229 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
     1eb:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     1f0:	c7 44 24 04 b7 42 00 	movl   $0x42b7,0x4(%esp)
     1f7:	00 
     1f8:	89 04 24             	mov    %eax,(%esp)
     1fb:	e8 bd 3b 00 00       	call   3dbd <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     200:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     207:	00 
     208:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
     20f:	00 
     210:	8b 45 f0             	mov    -0x10(%ebp),%eax
     213:	89 04 24             	mov    %eax,(%esp)
     216:	e8 3d 3a 00 00       	call   3c58 <read>
     21b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     21e:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     225:	74 1c                	je     243 <writetest+0x198>
     227:	eb 4c                	jmp    275 <writetest+0x1ca>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     229:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     22e:	c7 44 24 04 d0 42 00 	movl   $0x42d0,0x4(%esp)
     235:	00 
     236:	89 04 24             	mov    %eax,(%esp)
     239:	e8 7f 3b 00 00       	call   3dbd <printf>
    exit();
     23e:	e8 fd 39 00 00       	call   3c40 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     243:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     248:	c7 44 24 04 eb 42 00 	movl   $0x42eb,0x4(%esp)
     24f:	00 
     250:	89 04 24             	mov    %eax,(%esp)
     253:	e8 65 3b 00 00       	call   3dbd <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     258:	8b 45 f0             	mov    -0x10(%ebp),%eax
     25b:	89 04 24             	mov    %eax,(%esp)
     25e:	e8 05 3a 00 00       	call   3c68 <close>

  if(unlink("small") < 0){
     263:	c7 04 24 0e 42 00 00 	movl   $0x420e,(%esp)
     26a:	e8 21 3a 00 00       	call   3c90 <unlink>
     26f:	85 c0                	test   %eax,%eax
     271:	78 1c                	js     28f <writetest+0x1e4>
     273:	eb 34                	jmp    2a9 <writetest+0x1fe>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     275:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     27a:	c7 44 24 04 fe 42 00 	movl   $0x42fe,0x4(%esp)
     281:	00 
     282:	89 04 24             	mov    %eax,(%esp)
     285:	e8 33 3b 00 00       	call   3dbd <printf>
    exit();
     28a:	e8 b1 39 00 00       	call   3c40 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     28f:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     294:	c7 44 24 04 0b 43 00 	movl   $0x430b,0x4(%esp)
     29b:	00 
     29c:	89 04 24             	mov    %eax,(%esp)
     29f:	e8 19 3b 00 00       	call   3dbd <printf>
    exit();
     2a4:	e8 97 39 00 00       	call   3c40 <exit>
  }
  printf(stdout, "small file test ok\n");
     2a9:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     2ae:	c7 44 24 04 20 43 00 	movl   $0x4320,0x4(%esp)
     2b5:	00 
     2b6:	89 04 24             	mov    %eax,(%esp)
     2b9:	e8 ff 3a 00 00       	call   3dbd <printf>
}
     2be:	c9                   	leave  
     2bf:	c3                   	ret    

000002c0 <writetest1>:

void
writetest1(void)
{
     2c0:	55                   	push   %ebp
     2c1:	89 e5                	mov    %esp,%ebp
     2c3:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     2c6:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     2cb:	c7 44 24 04 34 43 00 	movl   $0x4334,0x4(%esp)
     2d2:	00 
     2d3:	89 04 24             	mov    %eax,(%esp)
     2d6:	e8 e2 3a 00 00       	call   3dbd <printf>

  fd = open("big", O_CREATE|O_RDWR);
     2db:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     2e2:	00 
     2e3:	c7 04 24 44 43 00 00 	movl   $0x4344,(%esp)
     2ea:	e8 91 39 00 00       	call   3c80 <open>
     2ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     2f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     2f6:	79 1a                	jns    312 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     2f8:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     2fd:	c7 44 24 04 48 43 00 	movl   $0x4348,0x4(%esp)
     304:	00 
     305:	89 04 24             	mov    %eax,(%esp)
     308:	e8 b0 3a 00 00       	call   3dbd <printf>
    exit();
     30d:	e8 2e 39 00 00       	call   3c40 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     319:	eb 51                	jmp    36c <writetest1+0xac>
    ((int*)buf)[0] = i;
     31b:	b8 c0 86 00 00       	mov    $0x86c0,%eax
     320:	8b 55 f4             	mov    -0xc(%ebp),%edx
     323:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     325:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     32c:	00 
     32d:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
     334:	00 
     335:	8b 45 ec             	mov    -0x14(%ebp),%eax
     338:	89 04 24             	mov    %eax,(%esp)
     33b:	e8 20 39 00 00       	call   3c60 <write>
     340:	3d 00 02 00 00       	cmp    $0x200,%eax
     345:	74 21                	je     368 <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     347:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     34c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     34f:	89 54 24 08          	mov    %edx,0x8(%esp)
     353:	c7 44 24 04 62 43 00 	movl   $0x4362,0x4(%esp)
     35a:	00 
     35b:	89 04 24             	mov    %eax,(%esp)
     35e:	e8 5a 3a 00 00       	call   3dbd <printf>
      exit();
     363:	e8 d8 38 00 00       	call   3c40 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     368:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     36c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     36f:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     374:	76 a5                	jbe    31b <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     376:	8b 45 ec             	mov    -0x14(%ebp),%eax
     379:	89 04 24             	mov    %eax,(%esp)
     37c:	e8 e7 38 00 00       	call   3c68 <close>

  fd = open("big", O_RDONLY);
     381:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     388:	00 
     389:	c7 04 24 44 43 00 00 	movl   $0x4344,(%esp)
     390:	e8 eb 38 00 00       	call   3c80 <open>
     395:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     398:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     39c:	79 1a                	jns    3b8 <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
     39e:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     3a3:	c7 44 24 04 80 43 00 	movl   $0x4380,0x4(%esp)
     3aa:	00 
     3ab:	89 04 24             	mov    %eax,(%esp)
     3ae:	e8 0a 3a 00 00       	call   3dbd <printf>
    exit();
     3b3:	e8 88 38 00 00       	call   3c40 <exit>
  }

  n = 0;
     3b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     3bf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     3c6:	00 
     3c7:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
     3ce:	00 
     3cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     3d2:	89 04 24             	mov    %eax,(%esp)
     3d5:	e8 7e 38 00 00       	call   3c58 <read>
     3da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     3dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     3e1:	75 2e                	jne    411 <writetest1+0x151>
      if(n == MAXFILE - 1){
     3e3:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     3ea:	0f 85 8c 00 00 00    	jne    47c <writetest1+0x1bc>
        printf(stdout, "read only %d blocks from big", n);
     3f0:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     3f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3f8:	89 54 24 08          	mov    %edx,0x8(%esp)
     3fc:	c7 44 24 04 99 43 00 	movl   $0x4399,0x4(%esp)
     403:	00 
     404:	89 04 24             	mov    %eax,(%esp)
     407:	e8 b1 39 00 00       	call   3dbd <printf>
        exit();
     40c:	e8 2f 38 00 00       	call   3c40 <exit>
      }
      break;
    } else if(i != 512){
     411:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     418:	74 21                	je     43b <writetest1+0x17b>
      printf(stdout, "read failed %d\n", i);
     41a:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     41f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     422:	89 54 24 08          	mov    %edx,0x8(%esp)
     426:	c7 44 24 04 b6 43 00 	movl   $0x43b6,0x4(%esp)
     42d:	00 
     42e:	89 04 24             	mov    %eax,(%esp)
     431:	e8 87 39 00 00       	call   3dbd <printf>
      exit();
     436:	e8 05 38 00 00       	call   3c40 <exit>
    }
    if(((int*)buf)[0] != n){
     43b:	b8 c0 86 00 00       	mov    $0x86c0,%eax
     440:	8b 00                	mov    (%eax),%eax
     442:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     445:	74 2c                	je     473 <writetest1+0x1b3>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     447:	b8 c0 86 00 00       	mov    $0x86c0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     44c:	8b 10                	mov    (%eax),%edx
     44e:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     453:	89 54 24 0c          	mov    %edx,0xc(%esp)
     457:	8b 55 f0             	mov    -0x10(%ebp),%edx
     45a:	89 54 24 08          	mov    %edx,0x8(%esp)
     45e:	c7 44 24 04 c8 43 00 	movl   $0x43c8,0x4(%esp)
     465:	00 
     466:	89 04 24             	mov    %eax,(%esp)
     469:	e8 4f 39 00 00       	call   3dbd <printf>
             n, ((int*)buf)[0]);
      exit();
     46e:	e8 cd 37 00 00       	call   3c40 <exit>
    }
    n++;
     473:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     477:	e9 43 ff ff ff       	jmp    3bf <writetest1+0xff>
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
     47c:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     47d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     480:	89 04 24             	mov    %eax,(%esp)
     483:	e8 e0 37 00 00       	call   3c68 <close>
  if(unlink("big") < 0){
     488:	c7 04 24 44 43 00 00 	movl   $0x4344,(%esp)
     48f:	e8 fc 37 00 00       	call   3c90 <unlink>
     494:	85 c0                	test   %eax,%eax
     496:	79 1a                	jns    4b2 <writetest1+0x1f2>
    printf(stdout, "unlink big failed\n");
     498:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     49d:	c7 44 24 04 e8 43 00 	movl   $0x43e8,0x4(%esp)
     4a4:	00 
     4a5:	89 04 24             	mov    %eax,(%esp)
     4a8:	e8 10 39 00 00       	call   3dbd <printf>
    exit();
     4ad:	e8 8e 37 00 00       	call   3c40 <exit>
  }
  printf(stdout, "big files ok\n");
     4b2:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     4b7:	c7 44 24 04 fb 43 00 	movl   $0x43fb,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 f6 38 00 00       	call   3dbd <printf>
}
     4c7:	c9                   	leave  
     4c8:	c3                   	ret    

000004c9 <createtest>:

void
createtest(void)
{
     4c9:	55                   	push   %ebp
     4ca:	89 e5                	mov    %esp,%ebp
     4cc:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     4cf:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     4d4:	c7 44 24 04 0c 44 00 	movl   $0x440c,0x4(%esp)
     4db:	00 
     4dc:	89 04 24             	mov    %eax,(%esp)
     4df:	e8 d9 38 00 00       	call   3dbd <printf>

  name[0] = 'a';
     4e4:	c6 05 c0 a6 00 00 61 	movb   $0x61,0xa6c0
  name[2] = '\0';
     4eb:	c6 05 c2 a6 00 00 00 	movb   $0x0,0xa6c2
  for(i = 0; i < 52; i++){
     4f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4f9:	eb 31                	jmp    52c <createtest+0x63>
    name[1] = '0' + i;
     4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fe:	83 c0 30             	add    $0x30,%eax
     501:	a2 c1 a6 00 00       	mov    %al,0xa6c1
    fd = open(name, O_CREATE|O_RDWR);
     506:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     50d:	00 
     50e:	c7 04 24 c0 a6 00 00 	movl   $0xa6c0,(%esp)
     515:	e8 66 37 00 00       	call   3c80 <open>
     51a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     51d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     520:	89 04 24             	mov    %eax,(%esp)
     523:	e8 40 37 00 00       	call   3c68 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     528:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     52c:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     530:	7e c9                	jle    4fb <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     532:	c6 05 c0 a6 00 00 61 	movb   $0x61,0xa6c0
  name[2] = '\0';
     539:	c6 05 c2 a6 00 00 00 	movb   $0x0,0xa6c2
  for(i = 0; i < 52; i++){
     540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     547:	eb 1b                	jmp    564 <createtest+0x9b>
    name[1] = '0' + i;
     549:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54c:	83 c0 30             	add    $0x30,%eax
     54f:	a2 c1 a6 00 00       	mov    %al,0xa6c1
    unlink(name);
     554:	c7 04 24 c0 a6 00 00 	movl   $0xa6c0,(%esp)
     55b:	e8 30 37 00 00       	call   3c90 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     564:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     568:	7e df                	jle    549 <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     56a:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     56f:	c7 44 24 04 34 44 00 	movl   $0x4434,0x4(%esp)
     576:	00 
     577:	89 04 24             	mov    %eax,(%esp)
     57a:	e8 3e 38 00 00       	call   3dbd <printf>
}
     57f:	c9                   	leave  
     580:	c3                   	ret    

00000581 <dirtest>:

void dirtest(void)
{
     581:	55                   	push   %ebp
     582:	89 e5                	mov    %esp,%ebp
     584:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     587:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     58c:	c7 44 24 04 5a 44 00 	movl   $0x445a,0x4(%esp)
     593:	00 
     594:	89 04 24             	mov    %eax,(%esp)
     597:	e8 21 38 00 00       	call   3dbd <printf>

  if(mkdir("dir0") < 0){
     59c:	c7 04 24 66 44 00 00 	movl   $0x4466,(%esp)
     5a3:	e8 00 37 00 00       	call   3ca8 <mkdir>
     5a8:	85 c0                	test   %eax,%eax
     5aa:	79 1a                	jns    5c6 <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     5ac:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     5b1:	c7 44 24 04 6b 44 00 	movl   $0x446b,0x4(%esp)
     5b8:	00 
     5b9:	89 04 24             	mov    %eax,(%esp)
     5bc:	e8 fc 37 00 00       	call   3dbd <printf>
    exit();
     5c1:	e8 7a 36 00 00       	call   3c40 <exit>
  }

  if(chdir("dir0") < 0){
     5c6:	c7 04 24 66 44 00 00 	movl   $0x4466,(%esp)
     5cd:	e8 de 36 00 00       	call   3cb0 <chdir>
     5d2:	85 c0                	test   %eax,%eax
     5d4:	79 1a                	jns    5f0 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     5d6:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     5db:	c7 44 24 04 79 44 00 	movl   $0x4479,0x4(%esp)
     5e2:	00 
     5e3:	89 04 24             	mov    %eax,(%esp)
     5e6:	e8 d2 37 00 00       	call   3dbd <printf>
    exit();
     5eb:	e8 50 36 00 00       	call   3c40 <exit>
  }

  if(chdir("..") < 0){
     5f0:	c7 04 24 8c 44 00 00 	movl   $0x448c,(%esp)
     5f7:	e8 b4 36 00 00       	call   3cb0 <chdir>
     5fc:	85 c0                	test   %eax,%eax
     5fe:	79 1a                	jns    61a <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     600:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     605:	c7 44 24 04 8f 44 00 	movl   $0x448f,0x4(%esp)
     60c:	00 
     60d:	89 04 24             	mov    %eax,(%esp)
     610:	e8 a8 37 00 00       	call   3dbd <printf>
    exit();
     615:	e8 26 36 00 00       	call   3c40 <exit>
  }

  if(unlink("dir0") < 0){
     61a:	c7 04 24 66 44 00 00 	movl   $0x4466,(%esp)
     621:	e8 6a 36 00 00       	call   3c90 <unlink>
     626:	85 c0                	test   %eax,%eax
     628:	79 1a                	jns    644 <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     62a:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     62f:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
     636:	00 
     637:	89 04 24             	mov    %eax,(%esp)
     63a:	e8 7e 37 00 00       	call   3dbd <printf>
    exit();
     63f:	e8 fc 35 00 00       	call   3c40 <exit>
  }
  printf(stdout, "mkdir test\n");
     644:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     649:	c7 44 24 04 5a 44 00 	movl   $0x445a,0x4(%esp)
     650:	00 
     651:	89 04 24             	mov    %eax,(%esp)
     654:	e8 64 37 00 00       	call   3dbd <printf>
}
     659:	c9                   	leave  
     65a:	c3                   	ret    

0000065b <exectest>:

void
exectest(void)
{
     65b:	55                   	push   %ebp
     65c:	89 e5                	mov    %esp,%ebp
     65e:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     661:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     666:	c7 44 24 04 b4 44 00 	movl   $0x44b4,0x4(%esp)
     66d:	00 
     66e:	89 04 24             	mov    %eax,(%esp)
     671:	e8 47 37 00 00       	call   3dbd <printf>
  if(exec("echo", echoargv) < 0){
     676:	c7 44 24 04 d0 5e 00 	movl   $0x5ed0,0x4(%esp)
     67d:	00 
     67e:	c7 04 24 90 41 00 00 	movl   $0x4190,(%esp)
     685:	e8 ee 35 00 00       	call   3c78 <exec>
     68a:	85 c0                	test   %eax,%eax
     68c:	79 1a                	jns    6a8 <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     68e:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
     693:	c7 44 24 04 bf 44 00 	movl   $0x44bf,0x4(%esp)
     69a:	00 
     69b:	89 04 24             	mov    %eax,(%esp)
     69e:	e8 1a 37 00 00       	call   3dbd <printf>
    exit();
     6a3:	e8 98 35 00 00       	call   3c40 <exit>
  }
}
     6a8:	c9                   	leave  
     6a9:	c3                   	ret    

000006aa <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     6aa:	55                   	push   %ebp
     6ab:	89 e5                	mov    %esp,%ebp
     6ad:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     6b0:	8d 45 d8             	lea    -0x28(%ebp),%eax
     6b3:	89 04 24             	mov    %eax,(%esp)
     6b6:	e8 95 35 00 00       	call   3c50 <pipe>
     6bb:	85 c0                	test   %eax,%eax
     6bd:	74 19                	je     6d8 <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     6bf:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
     6c6:	00 
     6c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6ce:	e8 ea 36 00 00       	call   3dbd <printf>
    exit();
     6d3:	e8 68 35 00 00       	call   3c40 <exit>
  }
  pid = fork();
     6d8:	e8 5b 35 00 00       	call   3c38 <fork>
     6dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     6e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     6e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     6eb:	0f 85 86 00 00 00    	jne    777 <pipe1+0xcd>
    close(fds[0]);
     6f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6f4:	89 04 24             	mov    %eax,(%esp)
     6f7:	e8 6c 35 00 00       	call   3c68 <close>
    for(n = 0; n < 5; n++){
     6fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     703:	eb 67                	jmp    76c <pipe1+0xc2>
      for(i = 0; i < 1033; i++)
     705:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     70c:	eb 16                	jmp    724 <pipe1+0x7a>
        buf[i] = seq++;
     70e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     711:	8b 55 f0             	mov    -0x10(%ebp),%edx
     714:	81 c2 c0 86 00 00    	add    $0x86c0,%edx
     71a:	88 02                	mov    %al,(%edx)
     71c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     720:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     724:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     72b:	7e e1                	jle    70e <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     72d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     730:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     737:	00 
     738:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
     73f:	00 
     740:	89 04 24             	mov    %eax,(%esp)
     743:	e8 18 35 00 00       	call   3c60 <write>
     748:	3d 09 04 00 00       	cmp    $0x409,%eax
     74d:	74 19                	je     768 <pipe1+0xbe>
        printf(1, "pipe1 oops 1\n");
     74f:	c7 44 24 04 e0 44 00 	movl   $0x44e0,0x4(%esp)
     756:	00 
     757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     75e:	e8 5a 36 00 00       	call   3dbd <printf>
        exit();
     763:	e8 d8 34 00 00       	call   3c40 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     768:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     76c:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     770:	7e 93                	jle    705 <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     772:	e8 c9 34 00 00       	call   3c40 <exit>
  } else if(pid > 0){
     777:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     77b:	0f 8e fc 00 00 00    	jle    87d <pipe1+0x1d3>
    close(fds[1]);
     781:	8b 45 dc             	mov    -0x24(%ebp),%eax
     784:	89 04 24             	mov    %eax,(%esp)
     787:	e8 dc 34 00 00       	call   3c68 <close>
    total = 0;
     78c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     793:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     79a:	eb 6b                	jmp    807 <pipe1+0x15d>
      for(i = 0; i < n; i++){
     79c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     7a3:	eb 40                	jmp    7e5 <pipe1+0x13b>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7a8:	05 c0 86 00 00       	add    $0x86c0,%eax
     7ad:	0f b6 00             	movzbl (%eax),%eax
     7b0:	0f be c0             	movsbl %al,%eax
     7b3:	33 45 f4             	xor    -0xc(%ebp),%eax
     7b6:	25 ff 00 00 00       	and    $0xff,%eax
     7bb:	85 c0                	test   %eax,%eax
     7bd:	0f 95 c0             	setne  %al
     7c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7c4:	84 c0                	test   %al,%al
     7c6:	74 19                	je     7e1 <pipe1+0x137>
          printf(1, "pipe1 oops 2\n");
     7c8:	c7 44 24 04 ee 44 00 	movl   $0x44ee,0x4(%esp)
     7cf:	00 
     7d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7d7:	e8 e1 35 00 00       	call   3dbd <printf>
     7dc:	e9 b5 00 00 00       	jmp    896 <pipe1+0x1ec>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     7e1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     7e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7eb:	7c b8                	jl     7a5 <pipe1+0xfb>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     7ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7f0:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     7f3:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     7f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7f9:	3d 00 20 00 00       	cmp    $0x2000,%eax
     7fe:	76 07                	jbe    807 <pipe1+0x15d>
        cc = sizeof(buf);
     800:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     807:	8b 45 d8             	mov    -0x28(%ebp),%eax
     80a:	8b 55 e8             	mov    -0x18(%ebp),%edx
     80d:	89 54 24 08          	mov    %edx,0x8(%esp)
     811:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
     818:	00 
     819:	89 04 24             	mov    %eax,(%esp)
     81c:	e8 37 34 00 00       	call   3c58 <read>
     821:	89 45 ec             	mov    %eax,-0x14(%ebp)
     824:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     828:	0f 8f 6e ff ff ff    	jg     79c <pipe1+0xf2>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     82e:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     835:	74 20                	je     857 <pipe1+0x1ad>
      printf(1, "pipe1 oops 3 total %d\n", total);
     837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     83a:	89 44 24 08          	mov    %eax,0x8(%esp)
     83e:	c7 44 24 04 fc 44 00 	movl   $0x44fc,0x4(%esp)
     845:	00 
     846:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     84d:	e8 6b 35 00 00       	call   3dbd <printf>
      exit();
     852:	e8 e9 33 00 00       	call   3c40 <exit>
    }
    close(fds[0]);
     857:	8b 45 d8             	mov    -0x28(%ebp),%eax
     85a:	89 04 24             	mov    %eax,(%esp)
     85d:	e8 06 34 00 00       	call   3c68 <close>
    wait();
     862:	e8 e1 33 00 00       	call   3c48 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     867:	c7 44 24 04 13 45 00 	movl   $0x4513,0x4(%esp)
     86e:	00 
     86f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     876:	e8 42 35 00 00       	call   3dbd <printf>
     87b:	eb 19                	jmp    896 <pipe1+0x1ec>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     87d:	c7 44 24 04 1d 45 00 	movl   $0x451d,0x4(%esp)
     884:	00 
     885:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     88c:	e8 2c 35 00 00       	call   3dbd <printf>
    exit();
     891:	e8 aa 33 00 00       	call   3c40 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     896:	c9                   	leave  
     897:	c3                   	ret    

00000898 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     898:	55                   	push   %ebp
     899:	89 e5                	mov    %esp,%ebp
     89b:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     89e:	c7 44 24 04 2c 45 00 	movl   $0x452c,0x4(%esp)
     8a5:	00 
     8a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8ad:	e8 0b 35 00 00       	call   3dbd <printf>
  pid1 = fork();
     8b2:	e8 81 33 00 00       	call   3c38 <fork>
     8b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     8ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8be:	75 02                	jne    8c2 <preempt+0x2a>
    for(;;)
      ;
     8c0:	eb fe                	jmp    8c0 <preempt+0x28>

  pid2 = fork();
     8c2:	e8 71 33 00 00       	call   3c38 <fork>
     8c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     8ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8ce:	75 02                	jne    8d2 <preempt+0x3a>
    for(;;)
      ;
     8d0:	eb fe                	jmp    8d0 <preempt+0x38>

  pipe(pfds);
     8d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     8d5:	89 04 24             	mov    %eax,(%esp)
     8d8:	e8 73 33 00 00       	call   3c50 <pipe>
  pid3 = fork();
     8dd:	e8 56 33 00 00       	call   3c38 <fork>
     8e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     8e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8e9:	75 4c                	jne    937 <preempt+0x9f>
    close(pfds[0]);
     8eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8ee:	89 04 24             	mov    %eax,(%esp)
     8f1:	e8 72 33 00 00       	call   3c68 <close>
    if(write(pfds[1], "x", 1) != 1)
     8f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8f9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     900:	00 
     901:	c7 44 24 04 36 45 00 	movl   $0x4536,0x4(%esp)
     908:	00 
     909:	89 04 24             	mov    %eax,(%esp)
     90c:	e8 4f 33 00 00       	call   3c60 <write>
     911:	83 f8 01             	cmp    $0x1,%eax
     914:	74 14                	je     92a <preempt+0x92>
      printf(1, "preempt write error");
     916:	c7 44 24 04 38 45 00 	movl   $0x4538,0x4(%esp)
     91d:	00 
     91e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     925:	e8 93 34 00 00       	call   3dbd <printf>
    close(pfds[1]);
     92a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     92d:	89 04 24             	mov    %eax,(%esp)
     930:	e8 33 33 00 00       	call   3c68 <close>
    for(;;)
      ;
     935:	eb fe                	jmp    935 <preempt+0x9d>
  }

  close(pfds[1]);
     937:	8b 45 e8             	mov    -0x18(%ebp),%eax
     93a:	89 04 24             	mov    %eax,(%esp)
     93d:	e8 26 33 00 00       	call   3c68 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     945:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     94c:	00 
     94d:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
     954:	00 
     955:	89 04 24             	mov    %eax,(%esp)
     958:	e8 fb 32 00 00       	call   3c58 <read>
     95d:	83 f8 01             	cmp    $0x1,%eax
     960:	74 16                	je     978 <preempt+0xe0>
    printf(1, "preempt read error");
     962:	c7 44 24 04 4c 45 00 	movl   $0x454c,0x4(%esp)
     969:	00 
     96a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     971:	e8 47 34 00 00       	call   3dbd <printf>
     976:	eb 77                	jmp    9ef <preempt+0x157>
    return;
  }
  close(pfds[0]);
     978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     97b:	89 04 24             	mov    %eax,(%esp)
     97e:	e8 e5 32 00 00       	call   3c68 <close>
  printf(1, "kill... ");
     983:	c7 44 24 04 5f 45 00 	movl   $0x455f,0x4(%esp)
     98a:	00 
     98b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     992:	e8 26 34 00 00       	call   3dbd <printf>
  kill(pid1);
     997:	8b 45 f4             	mov    -0xc(%ebp),%eax
     99a:	89 04 24             	mov    %eax,(%esp)
     99d:	e8 ce 32 00 00       	call   3c70 <kill>
  kill(pid2);
     9a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9a5:	89 04 24             	mov    %eax,(%esp)
     9a8:	e8 c3 32 00 00       	call   3c70 <kill>
  kill(pid3);
     9ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9b0:	89 04 24             	mov    %eax,(%esp)
     9b3:	e8 b8 32 00 00       	call   3c70 <kill>
  printf(1, "wait... ");
     9b8:	c7 44 24 04 68 45 00 	movl   $0x4568,0x4(%esp)
     9bf:	00 
     9c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9c7:	e8 f1 33 00 00       	call   3dbd <printf>
  wait();
     9cc:	e8 77 32 00 00       	call   3c48 <wait>
  wait();
     9d1:	e8 72 32 00 00       	call   3c48 <wait>
  wait();
     9d6:	e8 6d 32 00 00       	call   3c48 <wait>
  printf(1, "preempt ok\n");
     9db:	c7 44 24 04 71 45 00 	movl   $0x4571,0x4(%esp)
     9e2:	00 
     9e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9ea:	e8 ce 33 00 00       	call   3dbd <printf>
}
     9ef:	c9                   	leave  
     9f0:	c3                   	ret    

000009f1 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     9f1:	55                   	push   %ebp
     9f2:	89 e5                	mov    %esp,%ebp
     9f4:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     9f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9fe:	eb 53                	jmp    a53 <exitwait+0x62>
    pid = fork();
     a00:	e8 33 32 00 00       	call   3c38 <fork>
     a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     a08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a0c:	79 16                	jns    a24 <exitwait+0x33>
      printf(1, "fork failed\n");
     a0e:	c7 44 24 04 7d 45 00 	movl   $0x457d,0x4(%esp)
     a15:	00 
     a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a1d:	e8 9b 33 00 00       	call   3dbd <printf>
      return;
     a22:	eb 49                	jmp    a6d <exitwait+0x7c>
    }
    if(pid){
     a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a28:	74 20                	je     a4a <exitwait+0x59>
      if(wait() != pid){
     a2a:	e8 19 32 00 00       	call   3c48 <wait>
     a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     a32:	74 1b                	je     a4f <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     a34:	c7 44 24 04 8a 45 00 	movl   $0x458a,0x4(%esp)
     a3b:	00 
     a3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a43:	e8 75 33 00 00       	call   3dbd <printf>
        return;
     a48:	eb 23                	jmp    a6d <exitwait+0x7c>
      }
    } else {
      exit();
     a4a:	e8 f1 31 00 00       	call   3c40 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     a4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a53:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     a57:	7e a7                	jle    a00 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     a59:	c7 44 24 04 9a 45 00 	movl   $0x459a,0x4(%esp)
     a60:	00 
     a61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a68:	e8 50 33 00 00       	call   3dbd <printf>
}
     a6d:	c9                   	leave  
     a6e:	c3                   	ret    

00000a6f <mem>:

void
mem(void)
{
     a6f:	55                   	push   %ebp
     a70:	89 e5                	mov    %esp,%ebp
     a72:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     a75:	c7 44 24 04 a7 45 00 	movl   $0x45a7,0x4(%esp)
     a7c:	00 
     a7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a84:	e8 34 33 00 00       	call   3dbd <printf>
  ppid = getpid();
     a89:	e8 32 32 00 00       	call   3cc0 <getpid>
     a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     a91:	e8 a2 31 00 00       	call   3c38 <fork>
     a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
     a99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     a9d:	0f 85 aa 00 00 00    	jne    b4d <mem+0xde>
    m1 = 0;
     aa3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     aaa:	eb 0e                	jmp    aba <mem+0x4b>
      *(char**)m2 = m1;
     aac:	8b 45 e8             	mov    -0x18(%ebp),%eax
     aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ab2:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     aba:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     ac1:	e8 e7 35 00 00       	call   40ad <malloc>
     ac6:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ac9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     acd:	75 dd                	jne    aac <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     acf:	eb 19                	jmp    aea <mem+0x7b>
      m2 = *(char**)m1;
     ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad4:	8b 00                	mov    (%eax),%eax
     ad6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     adc:	89 04 24             	mov    %eax,(%esp)
     adf:	e8 90 34 00 00       	call   3f74 <free>
      m1 = m2;
     ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     aee:	75 e1                	jne    ad1 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     af0:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     af7:	e8 b1 35 00 00       	call   40ad <malloc>
     afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b03:	75 24                	jne    b29 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     b05:	c7 44 24 04 b1 45 00 	movl   $0x45b1,0x4(%esp)
     b0c:	00 
     b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b14:	e8 a4 32 00 00       	call   3dbd <printf>
      kill(ppid);
     b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b1c:	89 04 24             	mov    %eax,(%esp)
     b1f:	e8 4c 31 00 00       	call   3c70 <kill>
      exit();
     b24:	e8 17 31 00 00       	call   3c40 <exit>
    }
    free(m1);
     b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2c:	89 04 24             	mov    %eax,(%esp)
     b2f:	e8 40 34 00 00       	call   3f74 <free>
    printf(1, "mem ok\n");
     b34:	c7 44 24 04 cb 45 00 	movl   $0x45cb,0x4(%esp)
     b3b:	00 
     b3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b43:	e8 75 32 00 00       	call   3dbd <printf>
    exit();
     b48:	e8 f3 30 00 00       	call   3c40 <exit>
  } else {
    wait();
     b4d:	e8 f6 30 00 00       	call   3c48 <wait>
  }
}
     b52:	c9                   	leave  
     b53:	c3                   	ret    

00000b54 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     b54:	55                   	push   %ebp
     b55:	89 e5                	mov    %esp,%ebp
     b57:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     b5a:	c7 44 24 04 d3 45 00 	movl   $0x45d3,0x4(%esp)
     b61:	00 
     b62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b69:	e8 4f 32 00 00       	call   3dbd <printf>

  unlink("sharedfd");
     b6e:	c7 04 24 e2 45 00 00 	movl   $0x45e2,(%esp)
     b75:	e8 16 31 00 00       	call   3c90 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     b7a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     b81:	00 
     b82:	c7 04 24 e2 45 00 00 	movl   $0x45e2,(%esp)
     b89:	e8 f2 30 00 00       	call   3c80 <open>
     b8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     b91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b95:	79 19                	jns    bb0 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     b97:	c7 44 24 04 ec 45 00 	movl   $0x45ec,0x4(%esp)
     b9e:	00 
     b9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ba6:	e8 12 32 00 00       	call   3dbd <printf>
     bab:	e9 a0 01 00 00       	jmp    d50 <sharedfd+0x1fc>
    return;
  }
  pid = fork();
     bb0:	e8 83 30 00 00       	call   3c38 <fork>
     bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     bb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     bbc:	75 07                	jne    bc5 <sharedfd+0x71>
     bbe:	b8 63 00 00 00       	mov    $0x63,%eax
     bc3:	eb 05                	jmp    bca <sharedfd+0x76>
     bc5:	b8 70 00 00 00       	mov    $0x70,%eax
     bca:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     bd1:	00 
     bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
     bd6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bd9:	89 04 24             	mov    %eax,(%esp)
     bdc:	e8 b8 2e 00 00       	call   3a99 <memset>
  for(i = 0; i < 1000; i++){
     be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     be8:	eb 39                	jmp    c23 <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     bea:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     bf1:	00 
     bf2:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bfc:	89 04 24             	mov    %eax,(%esp)
     bff:	e8 5c 30 00 00       	call   3c60 <write>
     c04:	83 f8 0a             	cmp    $0xa,%eax
     c07:	74 16                	je     c1f <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     c09:	c7 44 24 04 18 46 00 	movl   $0x4618,0x4(%esp)
     c10:	00 
     c11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c18:	e8 a0 31 00 00       	call   3dbd <printf>
      break;
     c1d:	eb 0d                	jmp    c2c <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     c1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c23:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     c2a:	7e be                	jle    bea <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     c2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     c30:	75 05                	jne    c37 <sharedfd+0xe3>
    exit();
     c32:	e8 09 30 00 00       	call   3c40 <exit>
  else
    wait();
     c37:	e8 0c 30 00 00       	call   3c48 <wait>
  close(fd);
     c3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c3f:	89 04 24             	mov    %eax,(%esp)
     c42:	e8 21 30 00 00       	call   3c68 <close>
  fd = open("sharedfd", 0);
     c47:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c4e:	00 
     c4f:	c7 04 24 e2 45 00 00 	movl   $0x45e2,(%esp)
     c56:	e8 25 30 00 00       	call   3c80 <open>
     c5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     c5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c62:	79 19                	jns    c7d <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     c64:	c7 44 24 04 38 46 00 	movl   $0x4638,0x4(%esp)
     c6b:	00 
     c6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c73:	e8 45 31 00 00       	call   3dbd <printf>
     c78:	e9 d3 00 00 00       	jmp    d50 <sharedfd+0x1fc>
    return;
  }
  nc = np = 0;
     c7d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     c8a:	eb 3b                	jmp    cc7 <sharedfd+0x173>
    for(i = 0; i < sizeof(buf); i++){
     c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c93:	eb 2a                	jmp    cbf <sharedfd+0x16b>
      if(buf[i] == 'c')
     c95:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9b:	01 d0                	add    %edx,%eax
     c9d:	0f b6 00             	movzbl (%eax),%eax
     ca0:	3c 63                	cmp    $0x63,%al
     ca2:	75 04                	jne    ca8 <sharedfd+0x154>
        nc++;
     ca4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     ca8:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cae:	01 d0                	add    %edx,%eax
     cb0:	0f b6 00             	movzbl (%eax),%eax
     cb3:	3c 70                	cmp    $0x70,%al
     cb5:	75 04                	jne    cbb <sharedfd+0x167>
        np++;
     cb7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     cbb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc2:	83 f8 09             	cmp    $0x9,%eax
     cc5:	76 ce                	jbe    c95 <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     cc7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     cce:	00 
     ccf:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
     cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cd9:	89 04 24             	mov    %eax,(%esp)
     cdc:	e8 77 2f 00 00       	call   3c58 <read>
     ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
     ce4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     ce8:	7f a2                	jg     c8c <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ced:	89 04 24             	mov    %eax,(%esp)
     cf0:	e8 73 2f 00 00       	call   3c68 <close>
  unlink("sharedfd");
     cf5:	c7 04 24 e2 45 00 00 	movl   $0x45e2,(%esp)
     cfc:	e8 8f 2f 00 00       	call   3c90 <unlink>
  if(nc == 10000 && np == 10000){
     d01:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     d08:	75 1f                	jne    d29 <sharedfd+0x1d5>
     d0a:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     d11:	75 16                	jne    d29 <sharedfd+0x1d5>
    printf(1, "sharedfd ok\n");
     d13:	c7 44 24 04 63 46 00 	movl   $0x4663,0x4(%esp)
     d1a:	00 
     d1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d22:	e8 96 30 00 00       	call   3dbd <printf>
     d27:	eb 27                	jmp    d50 <sharedfd+0x1fc>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
     d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d33:	89 44 24 08          	mov    %eax,0x8(%esp)
     d37:	c7 44 24 04 70 46 00 	movl   $0x4670,0x4(%esp)
     d3e:	00 
     d3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d46:	e8 72 30 00 00       	call   3dbd <printf>
    exit();
     d4b:	e8 f0 2e 00 00       	call   3c40 <exit>
  }
}
     d50:	c9                   	leave  
     d51:	c3                   	ret    

00000d52 <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
     d52:	55                   	push   %ebp
     d53:	89 e5                	mov    %esp,%ebp
     d55:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
     d58:	c7 44 24 04 85 46 00 	movl   $0x4685,0x4(%esp)
     d5f:	00 
     d60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d67:	e8 51 30 00 00       	call   3dbd <printf>

  unlink("f1");
     d6c:	c7 04 24 94 46 00 00 	movl   $0x4694,(%esp)
     d73:	e8 18 2f 00 00       	call   3c90 <unlink>
  unlink("f2");
     d78:	c7 04 24 97 46 00 00 	movl   $0x4697,(%esp)
     d7f:	e8 0c 2f 00 00       	call   3c90 <unlink>

  pid = fork();
     d84:	e8 af 2e 00 00       	call   3c38 <fork>
     d89:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
     d8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d90:	79 19                	jns    dab <twofiles+0x59>
    printf(1, "fork failed\n");
     d92:	c7 44 24 04 7d 45 00 	movl   $0x457d,0x4(%esp)
     d99:	00 
     d9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     da1:	e8 17 30 00 00       	call   3dbd <printf>
    exit();
     da6:	e8 95 2e 00 00       	call   3c40 <exit>
  }

  fname = pid ? "f1" : "f2";
     dab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     daf:	74 07                	je     db8 <twofiles+0x66>
     db1:	b8 94 46 00 00       	mov    $0x4694,%eax
     db6:	eb 05                	jmp    dbd <twofiles+0x6b>
     db8:	b8 97 46 00 00       	mov    $0x4697,%eax
     dbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  fd = open(fname, O_CREATE | O_RDWR);
     dc0:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     dc7:	00 
     dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     dcb:	89 04 24             	mov    %eax,(%esp)
     dce:	e8 ad 2e 00 00       	call   3c80 <open>
     dd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
     dd6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     dda:	79 19                	jns    df5 <twofiles+0xa3>
    printf(1, "create failed\n");
     ddc:	c7 44 24 04 9a 46 00 	movl   $0x469a,0x4(%esp)
     de3:	00 
     de4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     deb:	e8 cd 2f 00 00       	call   3dbd <printf>
    exit();
     df0:	e8 4b 2e 00 00       	call   3c40 <exit>
  }

  memset(buf, pid?'p':'c', 512);
     df5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     df9:	74 07                	je     e02 <twofiles+0xb0>
     dfb:	b8 70 00 00 00       	mov    $0x70,%eax
     e00:	eb 05                	jmp    e07 <twofiles+0xb5>
     e02:	b8 63 00 00 00       	mov    $0x63,%eax
     e07:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     e0e:	00 
     e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     e13:	c7 04 24 c0 86 00 00 	movl   $0x86c0,(%esp)
     e1a:	e8 7a 2c 00 00       	call   3a99 <memset>
  for(i = 0; i < 12; i++){
     e1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e26:	eb 4b                	jmp    e73 <twofiles+0x121>
    if((n = write(fd, buf, 500)) != 500){
     e28:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
     e2f:	00 
     e30:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
     e37:	00 
     e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e3b:	89 04 24             	mov    %eax,(%esp)
     e3e:	e8 1d 2e 00 00       	call   3c60 <write>
     e43:	89 45 dc             	mov    %eax,-0x24(%ebp)
     e46:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
     e4d:	74 20                	je     e6f <twofiles+0x11d>
      printf(1, "write failed %d\n", n);
     e4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
     e52:	89 44 24 08          	mov    %eax,0x8(%esp)
     e56:	c7 44 24 04 a9 46 00 	movl   $0x46a9,0x4(%esp)
     e5d:	00 
     e5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e65:	e8 53 2f 00 00       	call   3dbd <printf>
      exit();
     e6a:	e8 d1 2d 00 00       	call   3c40 <exit>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
     e6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     e73:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
     e77:	7e af                	jle    e28 <twofiles+0xd6>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
     e79:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e7c:	89 04 24             	mov    %eax,(%esp)
     e7f:	e8 e4 2d 00 00       	call   3c68 <close>
  if(pid)
     e84:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e88:	74 11                	je     e9b <twofiles+0x149>
    wait();
     e8a:	e8 b9 2d 00 00       	call   3c48 <wait>
  else
    exit();

  for(i = 0; i < 2; i++){
     e8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e96:	e9 e7 00 00 00       	jmp    f82 <twofiles+0x230>
  }
  close(fd);
  if(pid)
    wait();
  else
    exit();
     e9b:	e8 a0 2d 00 00       	call   3c40 <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
     ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ea4:	74 07                	je     ead <twofiles+0x15b>
     ea6:	b8 94 46 00 00       	mov    $0x4694,%eax
     eab:	eb 05                	jmp    eb2 <twofiles+0x160>
     ead:	b8 97 46 00 00       	mov    $0x4697,%eax
     eb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     eb9:	00 
     eba:	89 04 24             	mov    %eax,(%esp)
     ebd:	e8 be 2d 00 00       	call   3c80 <open>
     ec2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
     ec5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
     ecc:	eb 58                	jmp    f26 <twofiles+0x1d4>
      for(j = 0; j < n; j++){
     ece:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ed5:	eb 41                	jmp    f18 <twofiles+0x1c6>
        if(buf[j] != (i?'p':'c')){
     ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eda:	05 c0 86 00 00       	add    $0x86c0,%eax
     edf:	0f b6 00             	movzbl (%eax),%eax
     ee2:	0f be d0             	movsbl %al,%edx
     ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ee9:	74 07                	je     ef2 <twofiles+0x1a0>
     eeb:	b8 70 00 00 00       	mov    $0x70,%eax
     ef0:	eb 05                	jmp    ef7 <twofiles+0x1a5>
     ef2:	b8 63 00 00 00       	mov    $0x63,%eax
     ef7:	39 c2                	cmp    %eax,%edx
     ef9:	74 19                	je     f14 <twofiles+0x1c2>
          printf(1, "wrong char\n");
     efb:	c7 44 24 04 ba 46 00 	movl   $0x46ba,0x4(%esp)
     f02:	00 
     f03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f0a:	e8 ae 2e 00 00       	call   3dbd <printf>
          exit();
     f0f:	e8 2c 2d 00 00       	call   3c40 <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
     f14:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f1b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     f1e:	7c b7                	jl     ed7 <twofiles+0x185>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
     f20:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f23:	01 45 ec             	add    %eax,-0x14(%ebp)
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f26:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     f2d:	00 
     f2e:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
     f35:	00 
     f36:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f39:	89 04 24             	mov    %eax,(%esp)
     f3c:	e8 17 2d 00 00       	call   3c58 <read>
     f41:	89 45 dc             	mov    %eax,-0x24(%ebp)
     f44:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     f48:	7f 84                	jg     ece <twofiles+0x17c>
          exit();
        }
      }
      total += n;
    }
    close(fd);
     f4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f4d:	89 04 24             	mov    %eax,(%esp)
     f50:	e8 13 2d 00 00       	call   3c68 <close>
    if(total != 12*500){
     f55:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
     f5c:	74 20                	je     f7e <twofiles+0x22c>
      printf(1, "wrong length %d\n", total);
     f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f61:	89 44 24 08          	mov    %eax,0x8(%esp)
     f65:	c7 44 24 04 c6 46 00 	movl   $0x46c6,0x4(%esp)
     f6c:	00 
     f6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f74:	e8 44 2e 00 00       	call   3dbd <printf>
      exit();
     f79:	e8 c2 2c 00 00       	call   3c40 <exit>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
     f7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f82:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
     f86:	0f 8e 14 ff ff ff    	jle    ea0 <twofiles+0x14e>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
     f8c:	c7 04 24 94 46 00 00 	movl   $0x4694,(%esp)
     f93:	e8 f8 2c 00 00       	call   3c90 <unlink>
  unlink("f2");
     f98:	c7 04 24 97 46 00 00 	movl   $0x4697,(%esp)
     f9f:	e8 ec 2c 00 00       	call   3c90 <unlink>

  printf(1, "twofiles ok\n");
     fa4:	c7 44 24 04 d7 46 00 	movl   $0x46d7,0x4(%esp)
     fab:	00 
     fac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fb3:	e8 05 2e 00 00       	call   3dbd <printf>
}
     fb8:	c9                   	leave  
     fb9:	c3                   	ret    

00000fba <createdelete>:

// two processes create and delete different files in same directory
void
createdelete(void)
{
     fba:	55                   	push   %ebp
     fbb:	89 e5                	mov    %esp,%ebp
     fbd:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     fc0:	c7 44 24 04 e4 46 00 	movl   $0x46e4,0x4(%esp)
     fc7:	00 
     fc8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fcf:	e8 e9 2d 00 00       	call   3dbd <printf>
  pid = fork();
     fd4:	e8 5f 2c 00 00       	call   3c38 <fork>
     fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid < 0){
     fdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fe0:	79 19                	jns    ffb <createdelete+0x41>
    printf(1, "fork failed\n");
     fe2:	c7 44 24 04 7d 45 00 	movl   $0x457d,0x4(%esp)
     fe9:	00 
     fea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ff1:	e8 c7 2d 00 00       	call   3dbd <printf>
    exit();
     ff6:	e8 45 2c 00 00       	call   3c40 <exit>
  }

  name[0] = pid ? 'p' : 'c';
     ffb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fff:	74 07                	je     1008 <createdelete+0x4e>
    1001:	b8 70 00 00 00       	mov    $0x70,%eax
    1006:	eb 05                	jmp    100d <createdelete+0x53>
    1008:	b8 63 00 00 00       	mov    $0x63,%eax
    100d:	88 45 cc             	mov    %al,-0x34(%ebp)
  name[2] = '\0';
    1010:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  for(i = 0; i < N; i++){
    1014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    101b:	e9 97 00 00 00       	jmp    10b7 <createdelete+0xfd>
    name[1] = '0' + i;
    1020:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1023:	83 c0 30             	add    $0x30,%eax
    1026:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
    1029:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1030:	00 
    1031:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1034:	89 04 24             	mov    %eax,(%esp)
    1037:	e8 44 2c 00 00       	call   3c80 <open>
    103c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    103f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1043:	79 19                	jns    105e <createdelete+0xa4>
      printf(1, "create failed\n");
    1045:	c7 44 24 04 9a 46 00 	movl   $0x469a,0x4(%esp)
    104c:	00 
    104d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1054:	e8 64 2d 00 00       	call   3dbd <printf>
      exit();
    1059:	e8 e2 2b 00 00       	call   3c40 <exit>
    }
    close(fd);
    105e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1061:	89 04 24             	mov    %eax,(%esp)
    1064:	e8 ff 2b 00 00       	call   3c68 <close>
    if(i > 0 && (i % 2 ) == 0){
    1069:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    106d:	7e 44                	jle    10b3 <createdelete+0xf9>
    106f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1072:	83 e0 01             	and    $0x1,%eax
    1075:	85 c0                	test   %eax,%eax
    1077:	75 3a                	jne    10b3 <createdelete+0xf9>
      name[1] = '0' + (i / 2);
    1079:	8b 45 f4             	mov    -0xc(%ebp),%eax
    107c:	89 c2                	mov    %eax,%edx
    107e:	c1 ea 1f             	shr    $0x1f,%edx
    1081:	01 d0                	add    %edx,%eax
    1083:	d1 f8                	sar    %eax
    1085:	83 c0 30             	add    $0x30,%eax
    1088:	88 45 cd             	mov    %al,-0x33(%ebp)
      if(unlink(name) < 0){
    108b:	8d 45 cc             	lea    -0x34(%ebp),%eax
    108e:	89 04 24             	mov    %eax,(%esp)
    1091:	e8 fa 2b 00 00       	call   3c90 <unlink>
    1096:	85 c0                	test   %eax,%eax
    1098:	79 19                	jns    10b3 <createdelete+0xf9>
        printf(1, "unlink failed\n");
    109a:	c7 44 24 04 f7 46 00 	movl   $0x46f7,0x4(%esp)
    10a1:	00 
    10a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10a9:	e8 0f 2d 00 00       	call   3dbd <printf>
        exit();
    10ae:	e8 8d 2b 00 00       	call   3c40 <exit>
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
  for(i = 0; i < N; i++){
    10b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10b7:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    10bb:	0f 8e 5f ff ff ff    	jle    1020 <createdelete+0x66>
        exit();
      }
    }
  }

  if(pid==0)
    10c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10c5:	75 05                	jne    10cc <createdelete+0x112>
    exit();
    10c7:	e8 74 2b 00 00       	call   3c40 <exit>
  else
    wait();
    10cc:	e8 77 2b 00 00       	call   3c48 <wait>

  for(i = 0; i < N; i++){
    10d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10d8:	e9 34 01 00 00       	jmp    1211 <createdelete+0x257>
    name[0] = 'p';
    10dd:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    10e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10e4:	83 c0 30             	add    $0x30,%eax
    10e7:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    10ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10f1:	00 
    10f2:	8d 45 cc             	lea    -0x34(%ebp),%eax
    10f5:	89 04 24             	mov    %eax,(%esp)
    10f8:	e8 83 2b 00 00       	call   3c80 <open>
    10fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    1100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1104:	74 06                	je     110c <createdelete+0x152>
    1106:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    110a:	7e 26                	jle    1132 <createdelete+0x178>
    110c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1110:	79 20                	jns    1132 <createdelete+0x178>
      printf(1, "oops createdelete %s didn't exist\n", name);
    1112:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1115:	89 44 24 08          	mov    %eax,0x8(%esp)
    1119:	c7 44 24 04 08 47 00 	movl   $0x4708,0x4(%esp)
    1120:	00 
    1121:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1128:	e8 90 2c 00 00       	call   3dbd <printf>
      exit();
    112d:	e8 0e 2b 00 00       	call   3c40 <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    1132:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1136:	7e 2c                	jle    1164 <createdelete+0x1aa>
    1138:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    113c:	7f 26                	jg     1164 <createdelete+0x1aa>
    113e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1142:	78 20                	js     1164 <createdelete+0x1aa>
      printf(1, "oops createdelete %s did exist\n", name);
    1144:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1147:	89 44 24 08          	mov    %eax,0x8(%esp)
    114b:	c7 44 24 04 2c 47 00 	movl   $0x472c,0x4(%esp)
    1152:	00 
    1153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    115a:	e8 5e 2c 00 00       	call   3dbd <printf>
      exit();
    115f:	e8 dc 2a 00 00       	call   3c40 <exit>
    }
    if(fd >= 0)
    1164:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1168:	78 0b                	js     1175 <createdelete+0x1bb>
      close(fd);
    116a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    116d:	89 04 24             	mov    %eax,(%esp)
    1170:	e8 f3 2a 00 00       	call   3c68 <close>

    name[0] = 'c';
    1175:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    name[1] = '0' + i;
    1179:	8b 45 f4             	mov    -0xc(%ebp),%eax
    117c:	83 c0 30             	add    $0x30,%eax
    117f:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    1182:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1189:	00 
    118a:	8d 45 cc             	lea    -0x34(%ebp),%eax
    118d:	89 04 24             	mov    %eax,(%esp)
    1190:	e8 eb 2a 00 00       	call   3c80 <open>
    1195:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    1198:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    119c:	74 06                	je     11a4 <createdelete+0x1ea>
    119e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    11a2:	7e 26                	jle    11ca <createdelete+0x210>
    11a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11a8:	79 20                	jns    11ca <createdelete+0x210>
      printf(1, "oops createdelete %s didn't exist\n", name);
    11aa:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11ad:	89 44 24 08          	mov    %eax,0x8(%esp)
    11b1:	c7 44 24 04 08 47 00 	movl   $0x4708,0x4(%esp)
    11b8:	00 
    11b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c0:	e8 f8 2b 00 00       	call   3dbd <printf>
      exit();
    11c5:	e8 76 2a 00 00       	call   3c40 <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    11ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11ce:	7e 2c                	jle    11fc <createdelete+0x242>
    11d0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    11d4:	7f 26                	jg     11fc <createdelete+0x242>
    11d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11da:	78 20                	js     11fc <createdelete+0x242>
      printf(1, "oops createdelete %s did exist\n", name);
    11dc:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11df:	89 44 24 08          	mov    %eax,0x8(%esp)
    11e3:	c7 44 24 04 2c 47 00 	movl   $0x472c,0x4(%esp)
    11ea:	00 
    11eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11f2:	e8 c6 2b 00 00       	call   3dbd <printf>
      exit();
    11f7:	e8 44 2a 00 00       	call   3c40 <exit>
    }
    if(fd >= 0)
    11fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1200:	78 0b                	js     120d <createdelete+0x253>
      close(fd);
    1202:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1205:	89 04 24             	mov    %eax,(%esp)
    1208:	e8 5b 2a 00 00       	call   3c68 <close>
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    120d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1211:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1215:	0f 8e c2 fe ff ff    	jle    10dd <createdelete+0x123>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    121b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1222:	eb 2b                	jmp    124f <createdelete+0x295>
    name[0] = 'p';
    1224:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    1228:	8b 45 f4             	mov    -0xc(%ebp),%eax
    122b:	83 c0 30             	add    $0x30,%eax
    122e:	88 45 cd             	mov    %al,-0x33(%ebp)
    unlink(name);
    1231:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1234:	89 04 24             	mov    %eax,(%esp)
    1237:	e8 54 2a 00 00       	call   3c90 <unlink>
    name[0] = 'c';
    123c:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    unlink(name);
    1240:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1243:	89 04 24             	mov    %eax,(%esp)
    1246:	e8 45 2a 00 00       	call   3c90 <unlink>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    124b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    124f:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1253:	7e cf                	jle    1224 <createdelete+0x26a>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
    1255:	c7 44 24 04 4c 47 00 	movl   $0x474c,0x4(%esp)
    125c:	00 
    125d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1264:	e8 54 2b 00 00       	call   3dbd <printf>
}
    1269:	c9                   	leave  
    126a:	c3                   	ret    

0000126b <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    126b:	55                   	push   %ebp
    126c:	89 e5                	mov    %esp,%ebp
    126e:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1271:	c7 44 24 04 5d 47 00 	movl   $0x475d,0x4(%esp)
    1278:	00 
    1279:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1280:	e8 38 2b 00 00       	call   3dbd <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1285:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    128c:	00 
    128d:	c7 04 24 6e 47 00 00 	movl   $0x476e,(%esp)
    1294:	e8 e7 29 00 00       	call   3c80 <open>
    1299:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    129c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12a0:	79 19                	jns    12bb <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    12a2:	c7 44 24 04 79 47 00 	movl   $0x4779,0x4(%esp)
    12a9:	00 
    12aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12b1:	e8 07 2b 00 00       	call   3dbd <printf>
    exit();
    12b6:	e8 85 29 00 00       	call   3c40 <exit>
  }
  write(fd, "hello", 5);
    12bb:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    12c2:	00 
    12c3:	c7 44 24 04 93 47 00 	movl   $0x4793,0x4(%esp)
    12ca:	00 
    12cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ce:	89 04 24             	mov    %eax,(%esp)
    12d1:	e8 8a 29 00 00       	call   3c60 <write>
  close(fd);
    12d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d9:	89 04 24             	mov    %eax,(%esp)
    12dc:	e8 87 29 00 00       	call   3c68 <close>

  fd = open("unlinkread", O_RDWR);
    12e1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    12e8:	00 
    12e9:	c7 04 24 6e 47 00 00 	movl   $0x476e,(%esp)
    12f0:	e8 8b 29 00 00       	call   3c80 <open>
    12f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    12f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12fc:	79 19                	jns    1317 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    12fe:	c7 44 24 04 99 47 00 	movl   $0x4799,0x4(%esp)
    1305:	00 
    1306:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    130d:	e8 ab 2a 00 00       	call   3dbd <printf>
    exit();
    1312:	e8 29 29 00 00       	call   3c40 <exit>
  }
  if(unlink("unlinkread") != 0){
    1317:	c7 04 24 6e 47 00 00 	movl   $0x476e,(%esp)
    131e:	e8 6d 29 00 00       	call   3c90 <unlink>
    1323:	85 c0                	test   %eax,%eax
    1325:	74 19                	je     1340 <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    1327:	c7 44 24 04 b1 47 00 	movl   $0x47b1,0x4(%esp)
    132e:	00 
    132f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1336:	e8 82 2a 00 00       	call   3dbd <printf>
    exit();
    133b:	e8 00 29 00 00       	call   3c40 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1340:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1347:	00 
    1348:	c7 04 24 6e 47 00 00 	movl   $0x476e,(%esp)
    134f:	e8 2c 29 00 00       	call   3c80 <open>
    1354:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    1357:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    135e:	00 
    135f:	c7 44 24 04 cb 47 00 	movl   $0x47cb,0x4(%esp)
    1366:	00 
    1367:	8b 45 f0             	mov    -0x10(%ebp),%eax
    136a:	89 04 24             	mov    %eax,(%esp)
    136d:	e8 ee 28 00 00       	call   3c60 <write>
  close(fd1);
    1372:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1375:	89 04 24             	mov    %eax,(%esp)
    1378:	e8 eb 28 00 00       	call   3c68 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    137d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1384:	00 
    1385:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    138c:	00 
    138d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1390:	89 04 24             	mov    %eax,(%esp)
    1393:	e8 c0 28 00 00       	call   3c58 <read>
    1398:	83 f8 05             	cmp    $0x5,%eax
    139b:	74 19                	je     13b6 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    139d:	c7 44 24 04 cf 47 00 	movl   $0x47cf,0x4(%esp)
    13a4:	00 
    13a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13ac:	e8 0c 2a 00 00       	call   3dbd <printf>
    exit();
    13b1:	e8 8a 28 00 00       	call   3c40 <exit>
  }
  if(buf[0] != 'h'){
    13b6:	0f b6 05 c0 86 00 00 	movzbl 0x86c0,%eax
    13bd:	3c 68                	cmp    $0x68,%al
    13bf:	74 19                	je     13da <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    13c1:	c7 44 24 04 e6 47 00 	movl   $0x47e6,0x4(%esp)
    13c8:	00 
    13c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13d0:	e8 e8 29 00 00       	call   3dbd <printf>
    exit();
    13d5:	e8 66 28 00 00       	call   3c40 <exit>
  }
  if(write(fd, buf, 10) != 10){
    13da:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    13e1:	00 
    13e2:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    13e9:	00 
    13ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ed:	89 04 24             	mov    %eax,(%esp)
    13f0:	e8 6b 28 00 00       	call   3c60 <write>
    13f5:	83 f8 0a             	cmp    $0xa,%eax
    13f8:	74 19                	je     1413 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    13fa:	c7 44 24 04 fd 47 00 	movl   $0x47fd,0x4(%esp)
    1401:	00 
    1402:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1409:	e8 af 29 00 00       	call   3dbd <printf>
    exit();
    140e:	e8 2d 28 00 00       	call   3c40 <exit>
  }
  close(fd);
    1413:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1416:	89 04 24             	mov    %eax,(%esp)
    1419:	e8 4a 28 00 00       	call   3c68 <close>
  unlink("unlinkread");
    141e:	c7 04 24 6e 47 00 00 	movl   $0x476e,(%esp)
    1425:	e8 66 28 00 00       	call   3c90 <unlink>
  printf(1, "unlinkread ok\n");
    142a:	c7 44 24 04 16 48 00 	movl   $0x4816,0x4(%esp)
    1431:	00 
    1432:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1439:	e8 7f 29 00 00       	call   3dbd <printf>
}
    143e:	c9                   	leave  
    143f:	c3                   	ret    

00001440 <linktest>:

void
linktest(void)
{
    1440:	55                   	push   %ebp
    1441:	89 e5                	mov    %esp,%ebp
    1443:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    1446:	c7 44 24 04 25 48 00 	movl   $0x4825,0x4(%esp)
    144d:	00 
    144e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1455:	e8 63 29 00 00       	call   3dbd <printf>

  unlink("lf1");
    145a:	c7 04 24 2f 48 00 00 	movl   $0x482f,(%esp)
    1461:	e8 2a 28 00 00       	call   3c90 <unlink>
  unlink("lf2");
    1466:	c7 04 24 33 48 00 00 	movl   $0x4833,(%esp)
    146d:	e8 1e 28 00 00       	call   3c90 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1472:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1479:	00 
    147a:	c7 04 24 2f 48 00 00 	movl   $0x482f,(%esp)
    1481:	e8 fa 27 00 00       	call   3c80 <open>
    1486:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    148d:	79 19                	jns    14a8 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    148f:	c7 44 24 04 37 48 00 	movl   $0x4837,0x4(%esp)
    1496:	00 
    1497:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    149e:	e8 1a 29 00 00       	call   3dbd <printf>
    exit();
    14a3:	e8 98 27 00 00       	call   3c40 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    14a8:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    14af:	00 
    14b0:	c7 44 24 04 93 47 00 	movl   $0x4793,0x4(%esp)
    14b7:	00 
    14b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bb:	89 04 24             	mov    %eax,(%esp)
    14be:	e8 9d 27 00 00       	call   3c60 <write>
    14c3:	83 f8 05             	cmp    $0x5,%eax
    14c6:	74 19                	je     14e1 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    14c8:	c7 44 24 04 4a 48 00 	movl   $0x484a,0x4(%esp)
    14cf:	00 
    14d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14d7:	e8 e1 28 00 00       	call   3dbd <printf>
    exit();
    14dc:	e8 5f 27 00 00       	call   3c40 <exit>
  }
  close(fd);
    14e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e4:	89 04 24             	mov    %eax,(%esp)
    14e7:	e8 7c 27 00 00       	call   3c68 <close>

  if(link("lf1", "lf2") < 0){
    14ec:	c7 44 24 04 33 48 00 	movl   $0x4833,0x4(%esp)
    14f3:	00 
    14f4:	c7 04 24 2f 48 00 00 	movl   $0x482f,(%esp)
    14fb:	e8 a0 27 00 00       	call   3ca0 <link>
    1500:	85 c0                	test   %eax,%eax
    1502:	79 19                	jns    151d <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    1504:	c7 44 24 04 5c 48 00 	movl   $0x485c,0x4(%esp)
    150b:	00 
    150c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1513:	e8 a5 28 00 00       	call   3dbd <printf>
    exit();
    1518:	e8 23 27 00 00       	call   3c40 <exit>
  }
  unlink("lf1");
    151d:	c7 04 24 2f 48 00 00 	movl   $0x482f,(%esp)
    1524:	e8 67 27 00 00       	call   3c90 <unlink>

  if(open("lf1", 0) >= 0){
    1529:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1530:	00 
    1531:	c7 04 24 2f 48 00 00 	movl   $0x482f,(%esp)
    1538:	e8 43 27 00 00       	call   3c80 <open>
    153d:	85 c0                	test   %eax,%eax
    153f:	78 19                	js     155a <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    1541:	c7 44 24 04 74 48 00 	movl   $0x4874,0x4(%esp)
    1548:	00 
    1549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1550:	e8 68 28 00 00       	call   3dbd <printf>
    exit();
    1555:	e8 e6 26 00 00       	call   3c40 <exit>
  }

  fd = open("lf2", 0);
    155a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1561:	00 
    1562:	c7 04 24 33 48 00 00 	movl   $0x4833,(%esp)
    1569:	e8 12 27 00 00       	call   3c80 <open>
    156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1575:	79 19                	jns    1590 <linktest+0x150>
    printf(1, "open lf2 failed\n");
    1577:	c7 44 24 04 99 48 00 	movl   $0x4899,0x4(%esp)
    157e:	00 
    157f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1586:	e8 32 28 00 00       	call   3dbd <printf>
    exit();
    158b:	e8 b0 26 00 00       	call   3c40 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1590:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1597:	00 
    1598:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    159f:	00 
    15a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a3:	89 04 24             	mov    %eax,(%esp)
    15a6:	e8 ad 26 00 00       	call   3c58 <read>
    15ab:	83 f8 05             	cmp    $0x5,%eax
    15ae:	74 19                	je     15c9 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    15b0:	c7 44 24 04 aa 48 00 	movl   $0x48aa,0x4(%esp)
    15b7:	00 
    15b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15bf:	e8 f9 27 00 00       	call   3dbd <printf>
    exit();
    15c4:	e8 77 26 00 00       	call   3c40 <exit>
  }
  close(fd);
    15c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15cc:	89 04 24             	mov    %eax,(%esp)
    15cf:	e8 94 26 00 00       	call   3c68 <close>

  if(link("lf2", "lf2") >= 0){
    15d4:	c7 44 24 04 33 48 00 	movl   $0x4833,0x4(%esp)
    15db:	00 
    15dc:	c7 04 24 33 48 00 00 	movl   $0x4833,(%esp)
    15e3:	e8 b8 26 00 00       	call   3ca0 <link>
    15e8:	85 c0                	test   %eax,%eax
    15ea:	78 19                	js     1605 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    15ec:	c7 44 24 04 bb 48 00 	movl   $0x48bb,0x4(%esp)
    15f3:	00 
    15f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15fb:	e8 bd 27 00 00       	call   3dbd <printf>
    exit();
    1600:	e8 3b 26 00 00       	call   3c40 <exit>
  }

  unlink("lf2");
    1605:	c7 04 24 33 48 00 00 	movl   $0x4833,(%esp)
    160c:	e8 7f 26 00 00       	call   3c90 <unlink>
  if(link("lf2", "lf1") >= 0){
    1611:	c7 44 24 04 2f 48 00 	movl   $0x482f,0x4(%esp)
    1618:	00 
    1619:	c7 04 24 33 48 00 00 	movl   $0x4833,(%esp)
    1620:	e8 7b 26 00 00       	call   3ca0 <link>
    1625:	85 c0                	test   %eax,%eax
    1627:	78 19                	js     1642 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    1629:	c7 44 24 04 dc 48 00 	movl   $0x48dc,0x4(%esp)
    1630:	00 
    1631:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1638:	e8 80 27 00 00       	call   3dbd <printf>
    exit();
    163d:	e8 fe 25 00 00       	call   3c40 <exit>
  }

  if(link(".", "lf1") >= 0){
    1642:	c7 44 24 04 2f 48 00 	movl   $0x482f,0x4(%esp)
    1649:	00 
    164a:	c7 04 24 ff 48 00 00 	movl   $0x48ff,(%esp)
    1651:	e8 4a 26 00 00       	call   3ca0 <link>
    1656:	85 c0                	test   %eax,%eax
    1658:	78 19                	js     1673 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    165a:	c7 44 24 04 01 49 00 	movl   $0x4901,0x4(%esp)
    1661:	00 
    1662:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1669:	e8 4f 27 00 00       	call   3dbd <printf>
    exit();
    166e:	e8 cd 25 00 00       	call   3c40 <exit>
  }

  printf(1, "linktest ok\n");
    1673:	c7 44 24 04 1d 49 00 	movl   $0x491d,0x4(%esp)
    167a:	00 
    167b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1682:	e8 36 27 00 00       	call   3dbd <printf>
}
    1687:	c9                   	leave  
    1688:	c3                   	ret    

00001689 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1689:	55                   	push   %ebp
    168a:	89 e5                	mov    %esp,%ebp
    168c:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    168f:	c7 44 24 04 2a 49 00 	movl   $0x492a,0x4(%esp)
    1696:	00 
    1697:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    169e:	e8 1a 27 00 00       	call   3dbd <printf>
  file[0] = 'C';
    16a3:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    16a7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    16ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    16b2:	e9 f7 00 00 00       	jmp    17ae <concreate+0x125>
    file[1] = '0' + i;
    16b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ba:	83 c0 30             	add    $0x30,%eax
    16bd:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    16c0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16c3:	89 04 24             	mov    %eax,(%esp)
    16c6:	e8 c5 25 00 00       	call   3c90 <unlink>
    pid = fork();
    16cb:	e8 68 25 00 00       	call   3c38 <fork>
    16d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    16d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16d7:	74 3a                	je     1713 <concreate+0x8a>
    16d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16dc:	ba 56 55 55 55       	mov    $0x55555556,%edx
    16e1:	89 c8                	mov    %ecx,%eax
    16e3:	f7 ea                	imul   %edx
    16e5:	89 c8                	mov    %ecx,%eax
    16e7:	c1 f8 1f             	sar    $0x1f,%eax
    16ea:	29 c2                	sub    %eax,%edx
    16ec:	89 d0                	mov    %edx,%eax
    16ee:	01 c0                	add    %eax,%eax
    16f0:	01 d0                	add    %edx,%eax
    16f2:	89 ca                	mov    %ecx,%edx
    16f4:	29 c2                	sub    %eax,%edx
    16f6:	83 fa 01             	cmp    $0x1,%edx
    16f9:	75 18                	jne    1713 <concreate+0x8a>
      link("C0", file);
    16fb:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16fe:	89 44 24 04          	mov    %eax,0x4(%esp)
    1702:	c7 04 24 3a 49 00 00 	movl   $0x493a,(%esp)
    1709:	e8 92 25 00 00       	call   3ca0 <link>
    170e:	e9 87 00 00 00       	jmp    179a <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    1713:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1717:	75 3a                	jne    1753 <concreate+0xca>
    1719:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    171c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1721:	89 c8                	mov    %ecx,%eax
    1723:	f7 ea                	imul   %edx
    1725:	d1 fa                	sar    %edx
    1727:	89 c8                	mov    %ecx,%eax
    1729:	c1 f8 1f             	sar    $0x1f,%eax
    172c:	29 c2                	sub    %eax,%edx
    172e:	89 d0                	mov    %edx,%eax
    1730:	c1 e0 02             	shl    $0x2,%eax
    1733:	01 d0                	add    %edx,%eax
    1735:	89 ca                	mov    %ecx,%edx
    1737:	29 c2                	sub    %eax,%edx
    1739:	83 fa 01             	cmp    $0x1,%edx
    173c:	75 15                	jne    1753 <concreate+0xca>
      link("C0", file);
    173e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1741:	89 44 24 04          	mov    %eax,0x4(%esp)
    1745:	c7 04 24 3a 49 00 00 	movl   $0x493a,(%esp)
    174c:	e8 4f 25 00 00       	call   3ca0 <link>
    1751:	eb 47                	jmp    179a <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1753:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    175a:	00 
    175b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    175e:	89 04 24             	mov    %eax,(%esp)
    1761:	e8 1a 25 00 00       	call   3c80 <open>
    1766:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    1769:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    176d:	79 20                	jns    178f <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    176f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1772:	89 44 24 08          	mov    %eax,0x8(%esp)
    1776:	c7 44 24 04 3d 49 00 	movl   $0x493d,0x4(%esp)
    177d:	00 
    177e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1785:	e8 33 26 00 00       	call   3dbd <printf>
        exit();
    178a:	e8 b1 24 00 00       	call   3c40 <exit>
      }
      close(fd);
    178f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1792:	89 04 24             	mov    %eax,(%esp)
    1795:	e8 ce 24 00 00       	call   3c68 <close>
    }
    if(pid == 0)
    179a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    179e:	75 05                	jne    17a5 <concreate+0x11c>
      exit();
    17a0:	e8 9b 24 00 00       	call   3c40 <exit>
    else
      wait();
    17a5:	e8 9e 24 00 00       	call   3c48 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    17aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    17ae:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    17b2:	0f 8e ff fe ff ff    	jle    16b7 <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    17b8:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    17bf:	00 
    17c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17c7:	00 
    17c8:	8d 45 bd             	lea    -0x43(%ebp),%eax
    17cb:	89 04 24             	mov    %eax,(%esp)
    17ce:	e8 c6 22 00 00       	call   3a99 <memset>
  fd = open(".", 0);
    17d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17da:	00 
    17db:	c7 04 24 ff 48 00 00 	movl   $0x48ff,(%esp)
    17e2:	e8 99 24 00 00       	call   3c80 <open>
    17e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    17ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    17f1:	e9 a7 00 00 00       	jmp    189d <concreate+0x214>
    if(de.inum == 0)
    17f6:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    17fa:	66 85 c0             	test   %ax,%ax
    17fd:	0f 84 99 00 00 00    	je     189c <concreate+0x213>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1803:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1807:	3c 43                	cmp    $0x43,%al
    1809:	0f 85 8e 00 00 00    	jne    189d <concreate+0x214>
    180f:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1813:	84 c0                	test   %al,%al
    1815:	0f 85 82 00 00 00    	jne    189d <concreate+0x214>
      i = de.name[1] - '0';
    181b:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    181f:	0f be c0             	movsbl %al,%eax
    1822:	83 e8 30             	sub    $0x30,%eax
    1825:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    182c:	78 08                	js     1836 <concreate+0x1ad>
    182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1831:	83 f8 27             	cmp    $0x27,%eax
    1834:	76 23                	jbe    1859 <concreate+0x1d0>
        printf(1, "concreate weird file %s\n", de.name);
    1836:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1839:	83 c0 02             	add    $0x2,%eax
    183c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1840:	c7 44 24 04 59 49 00 	movl   $0x4959,0x4(%esp)
    1847:	00 
    1848:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    184f:	e8 69 25 00 00       	call   3dbd <printf>
        exit();
    1854:	e8 e7 23 00 00       	call   3c40 <exit>
      }
      if(fa[i]){
    1859:	8d 55 bd             	lea    -0x43(%ebp),%edx
    185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185f:	01 d0                	add    %edx,%eax
    1861:	0f b6 00             	movzbl (%eax),%eax
    1864:	84 c0                	test   %al,%al
    1866:	74 23                	je     188b <concreate+0x202>
        printf(1, "concreate duplicate file %s\n", de.name);
    1868:	8d 45 ac             	lea    -0x54(%ebp),%eax
    186b:	83 c0 02             	add    $0x2,%eax
    186e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1872:	c7 44 24 04 72 49 00 	movl   $0x4972,0x4(%esp)
    1879:	00 
    187a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1881:	e8 37 25 00 00       	call   3dbd <printf>
        exit();
    1886:	e8 b5 23 00 00       	call   3c40 <exit>
      }
      fa[i] = 1;
    188b:	8d 55 bd             	lea    -0x43(%ebp),%edx
    188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1891:	01 d0                	add    %edx,%eax
    1893:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1896:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    189a:	eb 01                	jmp    189d <concreate+0x214>
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    189c:	90                   	nop
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    189d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    18a4:	00 
    18a5:	8d 45 ac             	lea    -0x54(%ebp),%eax
    18a8:	89 44 24 04          	mov    %eax,0x4(%esp)
    18ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18af:	89 04 24             	mov    %eax,(%esp)
    18b2:	e8 a1 23 00 00       	call   3c58 <read>
    18b7:	85 c0                	test   %eax,%eax
    18b9:	0f 8f 37 ff ff ff    	jg     17f6 <concreate+0x16d>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    18bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18c2:	89 04 24             	mov    %eax,(%esp)
    18c5:	e8 9e 23 00 00       	call   3c68 <close>

  if(n != 40){
    18ca:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    18ce:	74 19                	je     18e9 <concreate+0x260>
    printf(1, "concreate not enough files in directory listing\n");
    18d0:	c7 44 24 04 90 49 00 	movl   $0x4990,0x4(%esp)
    18d7:	00 
    18d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18df:	e8 d9 24 00 00       	call   3dbd <printf>
    exit();
    18e4:	e8 57 23 00 00       	call   3c40 <exit>
  }

  for(i = 0; i < 40; i++){
    18e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    18f0:	e9 2d 01 00 00       	jmp    1a22 <concreate+0x399>
    file[1] = '0' + i;
    18f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f8:	83 c0 30             	add    $0x30,%eax
    18fb:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    18fe:	e8 35 23 00 00       	call   3c38 <fork>
    1903:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1906:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    190a:	79 19                	jns    1925 <concreate+0x29c>
      printf(1, "fork failed\n");
    190c:	c7 44 24 04 7d 45 00 	movl   $0x457d,0x4(%esp)
    1913:	00 
    1914:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    191b:	e8 9d 24 00 00       	call   3dbd <printf>
      exit();
    1920:	e8 1b 23 00 00       	call   3c40 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1925:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1928:	ba 56 55 55 55       	mov    $0x55555556,%edx
    192d:	89 c8                	mov    %ecx,%eax
    192f:	f7 ea                	imul   %edx
    1931:	89 c8                	mov    %ecx,%eax
    1933:	c1 f8 1f             	sar    $0x1f,%eax
    1936:	29 c2                	sub    %eax,%edx
    1938:	89 d0                	mov    %edx,%eax
    193a:	01 c0                	add    %eax,%eax
    193c:	01 d0                	add    %edx,%eax
    193e:	89 ca                	mov    %ecx,%edx
    1940:	29 c2                	sub    %eax,%edx
    1942:	85 d2                	test   %edx,%edx
    1944:	75 06                	jne    194c <concreate+0x2c3>
    1946:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    194a:	74 28                	je     1974 <concreate+0x2eb>
       ((i % 3) == 1 && pid != 0)){
    194c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    194f:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1954:	89 c8                	mov    %ecx,%eax
    1956:	f7 ea                	imul   %edx
    1958:	89 c8                	mov    %ecx,%eax
    195a:	c1 f8 1f             	sar    $0x1f,%eax
    195d:	29 c2                	sub    %eax,%edx
    195f:	89 d0                	mov    %edx,%eax
    1961:	01 c0                	add    %eax,%eax
    1963:	01 d0                	add    %edx,%eax
    1965:	89 ca                	mov    %ecx,%edx
    1967:	29 c2                	sub    %eax,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1969:	83 fa 01             	cmp    $0x1,%edx
    196c:	75 74                	jne    19e2 <concreate+0x359>
       ((i % 3) == 1 && pid != 0)){
    196e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1972:	74 6e                	je     19e2 <concreate+0x359>
      close(open(file, 0));
    1974:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    197b:	00 
    197c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    197f:	89 04 24             	mov    %eax,(%esp)
    1982:	e8 f9 22 00 00       	call   3c80 <open>
    1987:	89 04 24             	mov    %eax,(%esp)
    198a:	e8 d9 22 00 00       	call   3c68 <close>
      close(open(file, 0));
    198f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1996:	00 
    1997:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    199a:	89 04 24             	mov    %eax,(%esp)
    199d:	e8 de 22 00 00       	call   3c80 <open>
    19a2:	89 04 24             	mov    %eax,(%esp)
    19a5:	e8 be 22 00 00       	call   3c68 <close>
      close(open(file, 0));
    19aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19b1:	00 
    19b2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19b5:	89 04 24             	mov    %eax,(%esp)
    19b8:	e8 c3 22 00 00       	call   3c80 <open>
    19bd:	89 04 24             	mov    %eax,(%esp)
    19c0:	e8 a3 22 00 00       	call   3c68 <close>
      close(open(file, 0));
    19c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19cc:	00 
    19cd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19d0:	89 04 24             	mov    %eax,(%esp)
    19d3:	e8 a8 22 00 00       	call   3c80 <open>
    19d8:	89 04 24             	mov    %eax,(%esp)
    19db:	e8 88 22 00 00       	call   3c68 <close>
    19e0:	eb 2c                	jmp    1a0e <concreate+0x385>
    } else {
      unlink(file);
    19e2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e5:	89 04 24             	mov    %eax,(%esp)
    19e8:	e8 a3 22 00 00       	call   3c90 <unlink>
      unlink(file);
    19ed:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19f0:	89 04 24             	mov    %eax,(%esp)
    19f3:	e8 98 22 00 00       	call   3c90 <unlink>
      unlink(file);
    19f8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19fb:	89 04 24             	mov    %eax,(%esp)
    19fe:	e8 8d 22 00 00       	call   3c90 <unlink>
      unlink(file);
    1a03:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a06:	89 04 24             	mov    %eax,(%esp)
    1a09:	e8 82 22 00 00       	call   3c90 <unlink>
    }
    if(pid == 0)
    1a0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a12:	75 05                	jne    1a19 <concreate+0x390>
      exit();
    1a14:	e8 27 22 00 00       	call   3c40 <exit>
    else
      wait();
    1a19:	e8 2a 22 00 00       	call   3c48 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1a1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a22:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a26:	0f 8e c9 fe ff ff    	jle    18f5 <concreate+0x26c>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1a2c:	c7 44 24 04 c1 49 00 	movl   $0x49c1,0x4(%esp)
    1a33:	00 
    1a34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a3b:	e8 7d 23 00 00       	call   3dbd <printf>
}
    1a40:	c9                   	leave  
    1a41:	c3                   	ret    

00001a42 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1a42:	55                   	push   %ebp
    1a43:	89 e5                	mov    %esp,%ebp
    1a45:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1a48:	c7 44 24 04 cf 49 00 	movl   $0x49cf,0x4(%esp)
    1a4f:	00 
    1a50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a57:	e8 61 23 00 00       	call   3dbd <printf>

  unlink("x");
    1a5c:	c7 04 24 36 45 00 00 	movl   $0x4536,(%esp)
    1a63:	e8 28 22 00 00       	call   3c90 <unlink>
  pid = fork();
    1a68:	e8 cb 21 00 00       	call   3c38 <fork>
    1a6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1a70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a74:	79 19                	jns    1a8f <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1a76:	c7 44 24 04 7d 45 00 	movl   $0x457d,0x4(%esp)
    1a7d:	00 
    1a7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a85:	e8 33 23 00 00       	call   3dbd <printf>
    exit();
    1a8a:	e8 b1 21 00 00       	call   3c40 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1a8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a93:	74 07                	je     1a9c <linkunlink+0x5a>
    1a95:	b8 01 00 00 00       	mov    $0x1,%eax
    1a9a:	eb 05                	jmp    1aa1 <linkunlink+0x5f>
    1a9c:	b8 61 00 00 00       	mov    $0x61,%eax
    1aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1aab:	e9 8e 00 00 00       	jmp    1b3e <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    1ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab3:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1ab9:	05 39 30 00 00       	add    $0x3039,%eax
    1abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1ac1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1ac4:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1ac9:	89 c8                	mov    %ecx,%eax
    1acb:	f7 e2                	mul    %edx
    1acd:	d1 ea                	shr    %edx
    1acf:	89 d0                	mov    %edx,%eax
    1ad1:	01 c0                	add    %eax,%eax
    1ad3:	01 d0                	add    %edx,%eax
    1ad5:	89 ca                	mov    %ecx,%edx
    1ad7:	29 c2                	sub    %eax,%edx
    1ad9:	85 d2                	test   %edx,%edx
    1adb:	75 1e                	jne    1afb <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    1add:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1ae4:	00 
    1ae5:	c7 04 24 36 45 00 00 	movl   $0x4536,(%esp)
    1aec:	e8 8f 21 00 00       	call   3c80 <open>
    1af1:	89 04 24             	mov    %eax,(%esp)
    1af4:	e8 6f 21 00 00       	call   3c68 <close>
    1af9:	eb 3f                	jmp    1b3a <linkunlink+0xf8>
    } else if((x % 3) == 1){
    1afb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1afe:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1b03:	89 c8                	mov    %ecx,%eax
    1b05:	f7 e2                	mul    %edx
    1b07:	d1 ea                	shr    %edx
    1b09:	89 d0                	mov    %edx,%eax
    1b0b:	01 c0                	add    %eax,%eax
    1b0d:	01 d0                	add    %edx,%eax
    1b0f:	89 ca                	mov    %ecx,%edx
    1b11:	29 c2                	sub    %eax,%edx
    1b13:	83 fa 01             	cmp    $0x1,%edx
    1b16:	75 16                	jne    1b2e <linkunlink+0xec>
      link("cat", "x");
    1b18:	c7 44 24 04 36 45 00 	movl   $0x4536,0x4(%esp)
    1b1f:	00 
    1b20:	c7 04 24 e0 49 00 00 	movl   $0x49e0,(%esp)
    1b27:	e8 74 21 00 00       	call   3ca0 <link>
    1b2c:	eb 0c                	jmp    1b3a <linkunlink+0xf8>
    } else {
      unlink("x");
    1b2e:	c7 04 24 36 45 00 00 	movl   $0x4536,(%esp)
    1b35:	e8 56 21 00 00       	call   3c90 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1b3a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1b3e:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1b42:	0f 8e 68 ff ff ff    	jle    1ab0 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1b48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b4c:	74 1b                	je     1b69 <linkunlink+0x127>
    wait();
    1b4e:	e8 f5 20 00 00       	call   3c48 <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1b53:	c7 44 24 04 e4 49 00 	movl   $0x49e4,0x4(%esp)
    1b5a:	00 
    1b5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b62:	e8 56 22 00 00       	call   3dbd <printf>
    1b67:	eb 05                	jmp    1b6e <linkunlink+0x12c>
  }

  if(pid)
    wait();
  else 
    exit();
    1b69:	e8 d2 20 00 00       	call   3c40 <exit>

  printf(1, "linkunlink ok\n");
}
    1b6e:	c9                   	leave  
    1b6f:	c3                   	ret    

00001b70 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1b70:	55                   	push   %ebp
    1b71:	89 e5                	mov    %esp,%ebp
    1b73:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1b76:	c7 44 24 04 f3 49 00 	movl   $0x49f3,0x4(%esp)
    1b7d:	00 
    1b7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b85:	e8 33 22 00 00       	call   3dbd <printf>
  unlink("bd");
    1b8a:	c7 04 24 00 4a 00 00 	movl   $0x4a00,(%esp)
    1b91:	e8 fa 20 00 00       	call   3c90 <unlink>

  fd = open("bd", O_CREATE);
    1b96:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1b9d:	00 
    1b9e:	c7 04 24 00 4a 00 00 	movl   $0x4a00,(%esp)
    1ba5:	e8 d6 20 00 00       	call   3c80 <open>
    1baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1bad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1bb1:	79 19                	jns    1bcc <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1bb3:	c7 44 24 04 03 4a 00 	movl   $0x4a03,0x4(%esp)
    1bba:	00 
    1bbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bc2:	e8 f6 21 00 00       	call   3dbd <printf>
    exit();
    1bc7:	e8 74 20 00 00       	call   3c40 <exit>
  }
  close(fd);
    1bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bcf:	89 04 24             	mov    %eax,(%esp)
    1bd2:	e8 91 20 00 00       	call   3c68 <close>

  for(i = 0; i < 500; i++){
    1bd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1bde:	eb 6a                	jmp    1c4a <bigdir+0xda>
    name[0] = 'x';
    1be0:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be7:	89 c2                	mov    %eax,%edx
    1be9:	c1 fa 1f             	sar    $0x1f,%edx
    1bec:	c1 ea 1a             	shr    $0x1a,%edx
    1bef:	01 d0                	add    %edx,%eax
    1bf1:	c1 f8 06             	sar    $0x6,%eax
    1bf4:	83 c0 30             	add    $0x30,%eax
    1bf7:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bfd:	89 c2                	mov    %eax,%edx
    1bff:	c1 fa 1f             	sar    $0x1f,%edx
    1c02:	c1 ea 1a             	shr    $0x1a,%edx
    1c05:	01 d0                	add    %edx,%eax
    1c07:	83 e0 3f             	and    $0x3f,%eax
    1c0a:	29 d0                	sub    %edx,%eax
    1c0c:	83 c0 30             	add    $0x30,%eax
    1c0f:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1c12:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1c16:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c19:	89 44 24 04          	mov    %eax,0x4(%esp)
    1c1d:	c7 04 24 00 4a 00 00 	movl   $0x4a00,(%esp)
    1c24:	e8 77 20 00 00       	call   3ca0 <link>
    1c29:	85 c0                	test   %eax,%eax
    1c2b:	74 19                	je     1c46 <bigdir+0xd6>
      printf(1, "bigdir link failed\n");
    1c2d:	c7 44 24 04 19 4a 00 	movl   $0x4a19,0x4(%esp)
    1c34:	00 
    1c35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c3c:	e8 7c 21 00 00       	call   3dbd <printf>
      exit();
    1c41:	e8 fa 1f 00 00       	call   3c40 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1c46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1c4a:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1c51:	7e 8d                	jle    1be0 <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1c53:	c7 04 24 00 4a 00 00 	movl   $0x4a00,(%esp)
    1c5a:	e8 31 20 00 00       	call   3c90 <unlink>
  for(i = 0; i < 500; i++){
    1c5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c66:	eb 62                	jmp    1cca <bigdir+0x15a>
    name[0] = 'x';
    1c68:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c6f:	89 c2                	mov    %eax,%edx
    1c71:	c1 fa 1f             	sar    $0x1f,%edx
    1c74:	c1 ea 1a             	shr    $0x1a,%edx
    1c77:	01 d0                	add    %edx,%eax
    1c79:	c1 f8 06             	sar    $0x6,%eax
    1c7c:	83 c0 30             	add    $0x30,%eax
    1c7f:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c85:	89 c2                	mov    %eax,%edx
    1c87:	c1 fa 1f             	sar    $0x1f,%edx
    1c8a:	c1 ea 1a             	shr    $0x1a,%edx
    1c8d:	01 d0                	add    %edx,%eax
    1c8f:	83 e0 3f             	and    $0x3f,%eax
    1c92:	29 d0                	sub    %edx,%eax
    1c94:	83 c0 30             	add    $0x30,%eax
    1c97:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1c9a:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1c9e:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ca1:	89 04 24             	mov    %eax,(%esp)
    1ca4:	e8 e7 1f 00 00       	call   3c90 <unlink>
    1ca9:	85 c0                	test   %eax,%eax
    1cab:	74 19                	je     1cc6 <bigdir+0x156>
      printf(1, "bigdir unlink failed");
    1cad:	c7 44 24 04 2d 4a 00 	movl   $0x4a2d,0x4(%esp)
    1cb4:	00 
    1cb5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cbc:	e8 fc 20 00 00       	call   3dbd <printf>
      exit();
    1cc1:	e8 7a 1f 00 00       	call   3c40 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1cc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cca:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1cd1:	7e 95                	jle    1c68 <bigdir+0xf8>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1cd3:	c7 44 24 04 42 4a 00 	movl   $0x4a42,0x4(%esp)
    1cda:	00 
    1cdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ce2:	e8 d6 20 00 00       	call   3dbd <printf>
}
    1ce7:	c9                   	leave  
    1ce8:	c3                   	ret    

00001ce9 <subdir>:

void
subdir(void)
{
    1ce9:	55                   	push   %ebp
    1cea:	89 e5                	mov    %esp,%ebp
    1cec:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1cef:	c7 44 24 04 4d 4a 00 	movl   $0x4a4d,0x4(%esp)
    1cf6:	00 
    1cf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cfe:	e8 ba 20 00 00       	call   3dbd <printf>

  unlink("ff");
    1d03:	c7 04 24 5a 4a 00 00 	movl   $0x4a5a,(%esp)
    1d0a:	e8 81 1f 00 00       	call   3c90 <unlink>
  if(mkdir("dd") != 0){
    1d0f:	c7 04 24 5d 4a 00 00 	movl   $0x4a5d,(%esp)
    1d16:	e8 8d 1f 00 00       	call   3ca8 <mkdir>
    1d1b:	85 c0                	test   %eax,%eax
    1d1d:	74 19                	je     1d38 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1d1f:	c7 44 24 04 60 4a 00 	movl   $0x4a60,0x4(%esp)
    1d26:	00 
    1d27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d2e:	e8 8a 20 00 00       	call   3dbd <printf>
    exit();
    1d33:	e8 08 1f 00 00       	call   3c40 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d38:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d3f:	00 
    1d40:	c7 04 24 78 4a 00 00 	movl   $0x4a78,(%esp)
    1d47:	e8 34 1f 00 00       	call   3c80 <open>
    1d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1d4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1d53:	79 19                	jns    1d6e <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    1d55:	c7 44 24 04 7e 4a 00 	movl   $0x4a7e,0x4(%esp)
    1d5c:	00 
    1d5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d64:	e8 54 20 00 00       	call   3dbd <printf>
    exit();
    1d69:	e8 d2 1e 00 00       	call   3c40 <exit>
  }
  write(fd, "ff", 2);
    1d6e:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1d75:	00 
    1d76:	c7 44 24 04 5a 4a 00 	movl   $0x4a5a,0x4(%esp)
    1d7d:	00 
    1d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d81:	89 04 24             	mov    %eax,(%esp)
    1d84:	e8 d7 1e 00 00       	call   3c60 <write>
  close(fd);
    1d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d8c:	89 04 24             	mov    %eax,(%esp)
    1d8f:	e8 d4 1e 00 00       	call   3c68 <close>
  
  if(unlink("dd") >= 0){
    1d94:	c7 04 24 5d 4a 00 00 	movl   $0x4a5d,(%esp)
    1d9b:	e8 f0 1e 00 00       	call   3c90 <unlink>
    1da0:	85 c0                	test   %eax,%eax
    1da2:	78 19                	js     1dbd <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1da4:	c7 44 24 04 94 4a 00 	movl   $0x4a94,0x4(%esp)
    1dab:	00 
    1dac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1db3:	e8 05 20 00 00       	call   3dbd <printf>
    exit();
    1db8:	e8 83 1e 00 00       	call   3c40 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    1dbd:	c7 04 24 ba 4a 00 00 	movl   $0x4aba,(%esp)
    1dc4:	e8 df 1e 00 00       	call   3ca8 <mkdir>
    1dc9:	85 c0                	test   %eax,%eax
    1dcb:	74 19                	je     1de6 <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    1dcd:	c7 44 24 04 c1 4a 00 	movl   $0x4ac1,0x4(%esp)
    1dd4:	00 
    1dd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ddc:	e8 dc 1f 00 00       	call   3dbd <printf>
    exit();
    1de1:	e8 5a 1e 00 00       	call   3c40 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1de6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1ded:	00 
    1dee:	c7 04 24 dc 4a 00 00 	movl   $0x4adc,(%esp)
    1df5:	e8 86 1e 00 00       	call   3c80 <open>
    1dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1e01:	79 19                	jns    1e1c <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    1e03:	c7 44 24 04 e5 4a 00 	movl   $0x4ae5,0x4(%esp)
    1e0a:	00 
    1e0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e12:	e8 a6 1f 00 00       	call   3dbd <printf>
    exit();
    1e17:	e8 24 1e 00 00       	call   3c40 <exit>
  }
  write(fd, "FF", 2);
    1e1c:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1e23:	00 
    1e24:	c7 44 24 04 fd 4a 00 	movl   $0x4afd,0x4(%esp)
    1e2b:	00 
    1e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e2f:	89 04 24             	mov    %eax,(%esp)
    1e32:	e8 29 1e 00 00       	call   3c60 <write>
  close(fd);
    1e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e3a:	89 04 24             	mov    %eax,(%esp)
    1e3d:	e8 26 1e 00 00       	call   3c68 <close>

  fd = open("dd/dd/../ff", 0);
    1e42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1e49:	00 
    1e4a:	c7 04 24 00 4b 00 00 	movl   $0x4b00,(%esp)
    1e51:	e8 2a 1e 00 00       	call   3c80 <open>
    1e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1e5d:	79 19                	jns    1e78 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    1e5f:	c7 44 24 04 0c 4b 00 	movl   $0x4b0c,0x4(%esp)
    1e66:	00 
    1e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e6e:	e8 4a 1f 00 00       	call   3dbd <printf>
    exit();
    1e73:	e8 c8 1d 00 00       	call   3c40 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    1e78:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1e7f:	00 
    1e80:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    1e87:	00 
    1e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e8b:	89 04 24             	mov    %eax,(%esp)
    1e8e:	e8 c5 1d 00 00       	call   3c58 <read>
    1e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    1e96:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    1e9a:	75 0b                	jne    1ea7 <subdir+0x1be>
    1e9c:	0f b6 05 c0 86 00 00 	movzbl 0x86c0,%eax
    1ea3:	3c 66                	cmp    $0x66,%al
    1ea5:	74 19                	je     1ec0 <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    1ea7:	c7 44 24 04 25 4b 00 	movl   $0x4b25,0x4(%esp)
    1eae:	00 
    1eaf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eb6:	e8 02 1f 00 00       	call   3dbd <printf>
    exit();
    1ebb:	e8 80 1d 00 00       	call   3c40 <exit>
  }
  close(fd);
    1ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ec3:	89 04 24             	mov    %eax,(%esp)
    1ec6:	e8 9d 1d 00 00       	call   3c68 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1ecb:	c7 44 24 04 40 4b 00 	movl   $0x4b40,0x4(%esp)
    1ed2:	00 
    1ed3:	c7 04 24 dc 4a 00 00 	movl   $0x4adc,(%esp)
    1eda:	e8 c1 1d 00 00       	call   3ca0 <link>
    1edf:	85 c0                	test   %eax,%eax
    1ee1:	74 19                	je     1efc <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1ee3:	c7 44 24 04 4c 4b 00 	movl   $0x4b4c,0x4(%esp)
    1eea:	00 
    1eeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ef2:	e8 c6 1e 00 00       	call   3dbd <printf>
    exit();
    1ef7:	e8 44 1d 00 00       	call   3c40 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    1efc:	c7 04 24 dc 4a 00 00 	movl   $0x4adc,(%esp)
    1f03:	e8 88 1d 00 00       	call   3c90 <unlink>
    1f08:	85 c0                	test   %eax,%eax
    1f0a:	74 19                	je     1f25 <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    1f0c:	c7 44 24 04 6d 4b 00 	movl   $0x4b6d,0x4(%esp)
    1f13:	00 
    1f14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f1b:	e8 9d 1e 00 00       	call   3dbd <printf>
    exit();
    1f20:	e8 1b 1d 00 00       	call   3c40 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f2c:	00 
    1f2d:	c7 04 24 dc 4a 00 00 	movl   $0x4adc,(%esp)
    1f34:	e8 47 1d 00 00       	call   3c80 <open>
    1f39:	85 c0                	test   %eax,%eax
    1f3b:	78 19                	js     1f56 <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    1f3d:	c7 44 24 04 88 4b 00 	movl   $0x4b88,0x4(%esp)
    1f44:	00 
    1f45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f4c:	e8 6c 1e 00 00       	call   3dbd <printf>
    exit();
    1f51:	e8 ea 1c 00 00       	call   3c40 <exit>
  }

  if(chdir("dd") != 0){
    1f56:	c7 04 24 5d 4a 00 00 	movl   $0x4a5d,(%esp)
    1f5d:	e8 4e 1d 00 00       	call   3cb0 <chdir>
    1f62:	85 c0                	test   %eax,%eax
    1f64:	74 19                	je     1f7f <subdir+0x296>
    printf(1, "chdir dd failed\n");
    1f66:	c7 44 24 04 ac 4b 00 	movl   $0x4bac,0x4(%esp)
    1f6d:	00 
    1f6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f75:	e8 43 1e 00 00       	call   3dbd <printf>
    exit();
    1f7a:	e8 c1 1c 00 00       	call   3c40 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    1f7f:	c7 04 24 bd 4b 00 00 	movl   $0x4bbd,(%esp)
    1f86:	e8 25 1d 00 00       	call   3cb0 <chdir>
    1f8b:	85 c0                	test   %eax,%eax
    1f8d:	74 19                	je     1fa8 <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    1f8f:	c7 44 24 04 c9 4b 00 	movl   $0x4bc9,0x4(%esp)
    1f96:	00 
    1f97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f9e:	e8 1a 1e 00 00       	call   3dbd <printf>
    exit();
    1fa3:	e8 98 1c 00 00       	call   3c40 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    1fa8:	c7 04 24 e3 4b 00 00 	movl   $0x4be3,(%esp)
    1faf:	e8 fc 1c 00 00       	call   3cb0 <chdir>
    1fb4:	85 c0                	test   %eax,%eax
    1fb6:	74 19                	je     1fd1 <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    1fb8:	c7 44 24 04 c9 4b 00 	movl   $0x4bc9,0x4(%esp)
    1fbf:	00 
    1fc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fc7:	e8 f1 1d 00 00       	call   3dbd <printf>
    exit();
    1fcc:	e8 6f 1c 00 00       	call   3c40 <exit>
  }
  if(chdir("./..") != 0){
    1fd1:	c7 04 24 f2 4b 00 00 	movl   $0x4bf2,(%esp)
    1fd8:	e8 d3 1c 00 00       	call   3cb0 <chdir>
    1fdd:	85 c0                	test   %eax,%eax
    1fdf:	74 19                	je     1ffa <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    1fe1:	c7 44 24 04 f7 4b 00 	movl   $0x4bf7,0x4(%esp)
    1fe8:	00 
    1fe9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ff0:	e8 c8 1d 00 00       	call   3dbd <printf>
    exit();
    1ff5:	e8 46 1c 00 00       	call   3c40 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    1ffa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2001:	00 
    2002:	c7 04 24 40 4b 00 00 	movl   $0x4b40,(%esp)
    2009:	e8 72 1c 00 00       	call   3c80 <open>
    200e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2011:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2015:	79 19                	jns    2030 <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    2017:	c7 44 24 04 0a 4c 00 	movl   $0x4c0a,0x4(%esp)
    201e:	00 
    201f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2026:	e8 92 1d 00 00       	call   3dbd <printf>
    exit();
    202b:	e8 10 1c 00 00       	call   3c40 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    2030:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2037:	00 
    2038:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    203f:	00 
    2040:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2043:	89 04 24             	mov    %eax,(%esp)
    2046:	e8 0d 1c 00 00       	call   3c58 <read>
    204b:	83 f8 02             	cmp    $0x2,%eax
    204e:	74 19                	je     2069 <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    2050:	c7 44 24 04 22 4c 00 	movl   $0x4c22,0x4(%esp)
    2057:	00 
    2058:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    205f:	e8 59 1d 00 00       	call   3dbd <printf>
    exit();
    2064:	e8 d7 1b 00 00       	call   3c40 <exit>
  }
  close(fd);
    2069:	8b 45 f4             	mov    -0xc(%ebp),%eax
    206c:	89 04 24             	mov    %eax,(%esp)
    206f:	e8 f4 1b 00 00       	call   3c68 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2074:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    207b:	00 
    207c:	c7 04 24 dc 4a 00 00 	movl   $0x4adc,(%esp)
    2083:	e8 f8 1b 00 00       	call   3c80 <open>
    2088:	85 c0                	test   %eax,%eax
    208a:	78 19                	js     20a5 <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    208c:	c7 44 24 04 40 4c 00 	movl   $0x4c40,0x4(%esp)
    2093:	00 
    2094:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    209b:	e8 1d 1d 00 00       	call   3dbd <printf>
    exit();
    20a0:	e8 9b 1b 00 00       	call   3c40 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    20a5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20ac:	00 
    20ad:	c7 04 24 65 4c 00 00 	movl   $0x4c65,(%esp)
    20b4:	e8 c7 1b 00 00       	call   3c80 <open>
    20b9:	85 c0                	test   %eax,%eax
    20bb:	78 19                	js     20d6 <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    20bd:	c7 44 24 04 6e 4c 00 	movl   $0x4c6e,0x4(%esp)
    20c4:	00 
    20c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20cc:	e8 ec 1c 00 00       	call   3dbd <printf>
    exit();
    20d1:	e8 6a 1b 00 00       	call   3c40 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    20d6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20dd:	00 
    20de:	c7 04 24 8a 4c 00 00 	movl   $0x4c8a,(%esp)
    20e5:	e8 96 1b 00 00       	call   3c80 <open>
    20ea:	85 c0                	test   %eax,%eax
    20ec:	78 19                	js     2107 <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    20ee:	c7 44 24 04 93 4c 00 	movl   $0x4c93,0x4(%esp)
    20f5:	00 
    20f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20fd:	e8 bb 1c 00 00       	call   3dbd <printf>
    exit();
    2102:	e8 39 1b 00 00       	call   3c40 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    2107:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    210e:	00 
    210f:	c7 04 24 5d 4a 00 00 	movl   $0x4a5d,(%esp)
    2116:	e8 65 1b 00 00       	call   3c80 <open>
    211b:	85 c0                	test   %eax,%eax
    211d:	78 19                	js     2138 <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    211f:	c7 44 24 04 af 4c 00 	movl   $0x4caf,0x4(%esp)
    2126:	00 
    2127:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    212e:	e8 8a 1c 00 00       	call   3dbd <printf>
    exit();
    2133:	e8 08 1b 00 00       	call   3c40 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    2138:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    213f:	00 
    2140:	c7 04 24 5d 4a 00 00 	movl   $0x4a5d,(%esp)
    2147:	e8 34 1b 00 00       	call   3c80 <open>
    214c:	85 c0                	test   %eax,%eax
    214e:	78 19                	js     2169 <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    2150:	c7 44 24 04 c5 4c 00 	movl   $0x4cc5,0x4(%esp)
    2157:	00 
    2158:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    215f:	e8 59 1c 00 00       	call   3dbd <printf>
    exit();
    2164:	e8 d7 1a 00 00       	call   3c40 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    2169:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    2170:	00 
    2171:	c7 04 24 5d 4a 00 00 	movl   $0x4a5d,(%esp)
    2178:	e8 03 1b 00 00       	call   3c80 <open>
    217d:	85 c0                	test   %eax,%eax
    217f:	78 19                	js     219a <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    2181:	c7 44 24 04 de 4c 00 	movl   $0x4cde,0x4(%esp)
    2188:	00 
    2189:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2190:	e8 28 1c 00 00       	call   3dbd <printf>
    exit();
    2195:	e8 a6 1a 00 00       	call   3c40 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    219a:	c7 44 24 04 f9 4c 00 	movl   $0x4cf9,0x4(%esp)
    21a1:	00 
    21a2:	c7 04 24 65 4c 00 00 	movl   $0x4c65,(%esp)
    21a9:	e8 f2 1a 00 00       	call   3ca0 <link>
    21ae:	85 c0                	test   %eax,%eax
    21b0:	75 19                	jne    21cb <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    21b2:	c7 44 24 04 04 4d 00 	movl   $0x4d04,0x4(%esp)
    21b9:	00 
    21ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21c1:	e8 f7 1b 00 00       	call   3dbd <printf>
    exit();
    21c6:	e8 75 1a 00 00       	call   3c40 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    21cb:	c7 44 24 04 f9 4c 00 	movl   $0x4cf9,0x4(%esp)
    21d2:	00 
    21d3:	c7 04 24 8a 4c 00 00 	movl   $0x4c8a,(%esp)
    21da:	e8 c1 1a 00 00       	call   3ca0 <link>
    21df:	85 c0                	test   %eax,%eax
    21e1:	75 19                	jne    21fc <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    21e3:	c7 44 24 04 28 4d 00 	movl   $0x4d28,0x4(%esp)
    21ea:	00 
    21eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21f2:	e8 c6 1b 00 00       	call   3dbd <printf>
    exit();
    21f7:	e8 44 1a 00 00       	call   3c40 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    21fc:	c7 44 24 04 40 4b 00 	movl   $0x4b40,0x4(%esp)
    2203:	00 
    2204:	c7 04 24 78 4a 00 00 	movl   $0x4a78,(%esp)
    220b:	e8 90 1a 00 00       	call   3ca0 <link>
    2210:	85 c0                	test   %eax,%eax
    2212:	75 19                	jne    222d <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2214:	c7 44 24 04 4c 4d 00 	movl   $0x4d4c,0x4(%esp)
    221b:	00 
    221c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2223:	e8 95 1b 00 00       	call   3dbd <printf>
    exit();
    2228:	e8 13 1a 00 00       	call   3c40 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    222d:	c7 04 24 65 4c 00 00 	movl   $0x4c65,(%esp)
    2234:	e8 6f 1a 00 00       	call   3ca8 <mkdir>
    2239:	85 c0                	test   %eax,%eax
    223b:	75 19                	jne    2256 <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    223d:	c7 44 24 04 6e 4d 00 	movl   $0x4d6e,0x4(%esp)
    2244:	00 
    2245:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    224c:	e8 6c 1b 00 00       	call   3dbd <printf>
    exit();
    2251:	e8 ea 19 00 00       	call   3c40 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    2256:	c7 04 24 8a 4c 00 00 	movl   $0x4c8a,(%esp)
    225d:	e8 46 1a 00 00       	call   3ca8 <mkdir>
    2262:	85 c0                	test   %eax,%eax
    2264:	75 19                	jne    227f <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2266:	c7 44 24 04 89 4d 00 	movl   $0x4d89,0x4(%esp)
    226d:	00 
    226e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2275:	e8 43 1b 00 00       	call   3dbd <printf>
    exit();
    227a:	e8 c1 19 00 00       	call   3c40 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    227f:	c7 04 24 40 4b 00 00 	movl   $0x4b40,(%esp)
    2286:	e8 1d 1a 00 00       	call   3ca8 <mkdir>
    228b:	85 c0                	test   %eax,%eax
    228d:	75 19                	jne    22a8 <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    228f:	c7 44 24 04 a4 4d 00 	movl   $0x4da4,0x4(%esp)
    2296:	00 
    2297:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    229e:	e8 1a 1b 00 00       	call   3dbd <printf>
    exit();
    22a3:	e8 98 19 00 00       	call   3c40 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    22a8:	c7 04 24 8a 4c 00 00 	movl   $0x4c8a,(%esp)
    22af:	e8 dc 19 00 00       	call   3c90 <unlink>
    22b4:	85 c0                	test   %eax,%eax
    22b6:	75 19                	jne    22d1 <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    22b8:	c7 44 24 04 c1 4d 00 	movl   $0x4dc1,0x4(%esp)
    22bf:	00 
    22c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22c7:	e8 f1 1a 00 00       	call   3dbd <printf>
    exit();
    22cc:	e8 6f 19 00 00       	call   3c40 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    22d1:	c7 04 24 65 4c 00 00 	movl   $0x4c65,(%esp)
    22d8:	e8 b3 19 00 00       	call   3c90 <unlink>
    22dd:	85 c0                	test   %eax,%eax
    22df:	75 19                	jne    22fa <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    22e1:	c7 44 24 04 dd 4d 00 	movl   $0x4ddd,0x4(%esp)
    22e8:	00 
    22e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22f0:	e8 c8 1a 00 00       	call   3dbd <printf>
    exit();
    22f5:	e8 46 19 00 00       	call   3c40 <exit>
  }
  if(chdir("dd/ff") == 0){
    22fa:	c7 04 24 78 4a 00 00 	movl   $0x4a78,(%esp)
    2301:	e8 aa 19 00 00       	call   3cb0 <chdir>
    2306:	85 c0                	test   %eax,%eax
    2308:	75 19                	jne    2323 <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    230a:	c7 44 24 04 f9 4d 00 	movl   $0x4df9,0x4(%esp)
    2311:	00 
    2312:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2319:	e8 9f 1a 00 00       	call   3dbd <printf>
    exit();
    231e:	e8 1d 19 00 00       	call   3c40 <exit>
  }
  if(chdir("dd/xx") == 0){
    2323:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    232a:	e8 81 19 00 00       	call   3cb0 <chdir>
    232f:	85 c0                	test   %eax,%eax
    2331:	75 19                	jne    234c <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    2333:	c7 44 24 04 17 4e 00 	movl   $0x4e17,0x4(%esp)
    233a:	00 
    233b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2342:	e8 76 1a 00 00       	call   3dbd <printf>
    exit();
    2347:	e8 f4 18 00 00       	call   3c40 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    234c:	c7 04 24 40 4b 00 00 	movl   $0x4b40,(%esp)
    2353:	e8 38 19 00 00       	call   3c90 <unlink>
    2358:	85 c0                	test   %eax,%eax
    235a:	74 19                	je     2375 <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    235c:	c7 44 24 04 6d 4b 00 	movl   $0x4b6d,0x4(%esp)
    2363:	00 
    2364:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    236b:	e8 4d 1a 00 00       	call   3dbd <printf>
    exit();
    2370:	e8 cb 18 00 00       	call   3c40 <exit>
  }
  if(unlink("dd/ff") != 0){
    2375:	c7 04 24 78 4a 00 00 	movl   $0x4a78,(%esp)
    237c:	e8 0f 19 00 00       	call   3c90 <unlink>
    2381:	85 c0                	test   %eax,%eax
    2383:	74 19                	je     239e <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    2385:	c7 44 24 04 2f 4e 00 	movl   $0x4e2f,0x4(%esp)
    238c:	00 
    238d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2394:	e8 24 1a 00 00       	call   3dbd <printf>
    exit();
    2399:	e8 a2 18 00 00       	call   3c40 <exit>
  }
  if(unlink("dd") == 0){
    239e:	c7 04 24 5d 4a 00 00 	movl   $0x4a5d,(%esp)
    23a5:	e8 e6 18 00 00       	call   3c90 <unlink>
    23aa:	85 c0                	test   %eax,%eax
    23ac:	75 19                	jne    23c7 <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    23ae:	c7 44 24 04 44 4e 00 	movl   $0x4e44,0x4(%esp)
    23b5:	00 
    23b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23bd:	e8 fb 19 00 00       	call   3dbd <printf>
    exit();
    23c2:	e8 79 18 00 00       	call   3c40 <exit>
  }
  if(unlink("dd/dd") < 0){
    23c7:	c7 04 24 64 4e 00 00 	movl   $0x4e64,(%esp)
    23ce:	e8 bd 18 00 00       	call   3c90 <unlink>
    23d3:	85 c0                	test   %eax,%eax
    23d5:	79 19                	jns    23f0 <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    23d7:	c7 44 24 04 6a 4e 00 	movl   $0x4e6a,0x4(%esp)
    23de:	00 
    23df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23e6:	e8 d2 19 00 00       	call   3dbd <printf>
    exit();
    23eb:	e8 50 18 00 00       	call   3c40 <exit>
  }
  if(unlink("dd") < 0){
    23f0:	c7 04 24 5d 4a 00 00 	movl   $0x4a5d,(%esp)
    23f7:	e8 94 18 00 00       	call   3c90 <unlink>
    23fc:	85 c0                	test   %eax,%eax
    23fe:	79 19                	jns    2419 <subdir+0x730>
    printf(1, "unlink dd failed\n");
    2400:	c7 44 24 04 7f 4e 00 	movl   $0x4e7f,0x4(%esp)
    2407:	00 
    2408:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    240f:	e8 a9 19 00 00       	call   3dbd <printf>
    exit();
    2414:	e8 27 18 00 00       	call   3c40 <exit>
  }

  printf(1, "subdir ok\n");
    2419:	c7 44 24 04 91 4e 00 	movl   $0x4e91,0x4(%esp)
    2420:	00 
    2421:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2428:	e8 90 19 00 00       	call   3dbd <printf>
}
    242d:	c9                   	leave  
    242e:	c3                   	ret    

0000242f <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    242f:	55                   	push   %ebp
    2430:	89 e5                	mov    %esp,%ebp
    2432:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2435:	c7 44 24 04 9c 4e 00 	movl   $0x4e9c,0x4(%esp)
    243c:	00 
    243d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2444:	e8 74 19 00 00       	call   3dbd <printf>

  unlink("bigwrite");
    2449:	c7 04 24 ab 4e 00 00 	movl   $0x4eab,(%esp)
    2450:	e8 3b 18 00 00       	call   3c90 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2455:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    245c:	e9 b3 00 00 00       	jmp    2514 <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2461:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2468:	00 
    2469:	c7 04 24 ab 4e 00 00 	movl   $0x4eab,(%esp)
    2470:	e8 0b 18 00 00       	call   3c80 <open>
    2475:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    2478:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    247c:	79 19                	jns    2497 <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    247e:	c7 44 24 04 b4 4e 00 	movl   $0x4eb4,0x4(%esp)
    2485:	00 
    2486:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    248d:	e8 2b 19 00 00       	call   3dbd <printf>
      exit();
    2492:	e8 a9 17 00 00       	call   3c40 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    249e:	eb 50                	jmp    24f0 <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    24a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24a3:	89 44 24 08          	mov    %eax,0x8(%esp)
    24a7:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    24ae:	00 
    24af:	8b 45 ec             	mov    -0x14(%ebp),%eax
    24b2:	89 04 24             	mov    %eax,(%esp)
    24b5:	e8 a6 17 00 00       	call   3c60 <write>
    24ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    24bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    24c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    24c3:	74 27                	je     24ec <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    24c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    24c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
    24cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24cf:	89 44 24 08          	mov    %eax,0x8(%esp)
    24d3:	c7 44 24 04 cc 4e 00 	movl   $0x4ecc,0x4(%esp)
    24da:	00 
    24db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24e2:	e8 d6 18 00 00       	call   3dbd <printf>
        exit();
    24e7:	e8 54 17 00 00       	call   3c40 <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    24ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    24f0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    24f4:	7e aa                	jle    24a0 <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    24f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    24f9:	89 04 24             	mov    %eax,(%esp)
    24fc:	e8 67 17 00 00       	call   3c68 <close>
    unlink("bigwrite");
    2501:	c7 04 24 ab 4e 00 00 	movl   $0x4eab,(%esp)
    2508:	e8 83 17 00 00       	call   3c90 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    250d:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    2514:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    251b:	0f 8e 40 ff ff ff    	jle    2461 <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    2521:	c7 44 24 04 de 4e 00 	movl   $0x4ede,0x4(%esp)
    2528:	00 
    2529:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2530:	e8 88 18 00 00       	call   3dbd <printf>
}
    2535:	c9                   	leave  
    2536:	c3                   	ret    

00002537 <bigfile>:

void
bigfile(void)
{
    2537:	55                   	push   %ebp
    2538:	89 e5                	mov    %esp,%ebp
    253a:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    253d:	c7 44 24 04 eb 4e 00 	movl   $0x4eeb,0x4(%esp)
    2544:	00 
    2545:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    254c:	e8 6c 18 00 00       	call   3dbd <printf>

  unlink("bigfile");
    2551:	c7 04 24 f9 4e 00 00 	movl   $0x4ef9,(%esp)
    2558:	e8 33 17 00 00       	call   3c90 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    255d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2564:	00 
    2565:	c7 04 24 f9 4e 00 00 	movl   $0x4ef9,(%esp)
    256c:	e8 0f 17 00 00       	call   3c80 <open>
    2571:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2578:	79 19                	jns    2593 <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    257a:	c7 44 24 04 01 4f 00 	movl   $0x4f01,0x4(%esp)
    2581:	00 
    2582:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2589:	e8 2f 18 00 00       	call   3dbd <printf>
    exit();
    258e:	e8 ad 16 00 00       	call   3c40 <exit>
  }
  for(i = 0; i < 20; i++){
    2593:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    259a:	eb 5a                	jmp    25f6 <bigfile+0xbf>
    memset(buf, i, 600);
    259c:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    25a3:	00 
    25a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25a7:	89 44 24 04          	mov    %eax,0x4(%esp)
    25ab:	c7 04 24 c0 86 00 00 	movl   $0x86c0,(%esp)
    25b2:	e8 e2 14 00 00       	call   3a99 <memset>
    if(write(fd, buf, 600) != 600){
    25b7:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    25be:	00 
    25bf:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    25c6:	00 
    25c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    25ca:	89 04 24             	mov    %eax,(%esp)
    25cd:	e8 8e 16 00 00       	call   3c60 <write>
    25d2:	3d 58 02 00 00       	cmp    $0x258,%eax
    25d7:	74 19                	je     25f2 <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    25d9:	c7 44 24 04 17 4f 00 	movl   $0x4f17,0x4(%esp)
    25e0:	00 
    25e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25e8:	e8 d0 17 00 00       	call   3dbd <printf>
      exit();
    25ed:	e8 4e 16 00 00       	call   3c40 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    25f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    25f6:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    25fa:	7e a0                	jle    259c <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    25fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    25ff:	89 04 24             	mov    %eax,(%esp)
    2602:	e8 61 16 00 00       	call   3c68 <close>

  fd = open("bigfile", 0);
    2607:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    260e:	00 
    260f:	c7 04 24 f9 4e 00 00 	movl   $0x4ef9,(%esp)
    2616:	e8 65 16 00 00       	call   3c80 <open>
    261b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    261e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2622:	79 19                	jns    263d <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    2624:	c7 44 24 04 2d 4f 00 	movl   $0x4f2d,0x4(%esp)
    262b:	00 
    262c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2633:	e8 85 17 00 00       	call   3dbd <printf>
    exit();
    2638:	e8 03 16 00 00       	call   3c40 <exit>
  }
  total = 0;
    263d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    2644:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    264b:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    2652:	00 
    2653:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    265a:	00 
    265b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    265e:	89 04 24             	mov    %eax,(%esp)
    2661:	e8 f2 15 00 00       	call   3c58 <read>
    2666:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    2669:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    266d:	79 19                	jns    2688 <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    266f:	c7 44 24 04 42 4f 00 	movl   $0x4f42,0x4(%esp)
    2676:	00 
    2677:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    267e:	e8 3a 17 00 00       	call   3dbd <printf>
      exit();
    2683:	e8 b8 15 00 00       	call   3c40 <exit>
    }
    if(cc == 0)
    2688:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    268c:	74 7e                	je     270c <bigfile+0x1d5>
      break;
    if(cc != 300){
    268e:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2695:	74 19                	je     26b0 <bigfile+0x179>
      printf(1, "short read bigfile\n");
    2697:	c7 44 24 04 57 4f 00 	movl   $0x4f57,0x4(%esp)
    269e:	00 
    269f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26a6:	e8 12 17 00 00       	call   3dbd <printf>
      exit();
    26ab:	e8 90 15 00 00       	call   3c40 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    26b0:	0f b6 05 c0 86 00 00 	movzbl 0x86c0,%eax
    26b7:	0f be d0             	movsbl %al,%edx
    26ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26bd:	89 c1                	mov    %eax,%ecx
    26bf:	c1 e9 1f             	shr    $0x1f,%ecx
    26c2:	01 c8                	add    %ecx,%eax
    26c4:	d1 f8                	sar    %eax
    26c6:	39 c2                	cmp    %eax,%edx
    26c8:	75 1a                	jne    26e4 <bigfile+0x1ad>
    26ca:	0f b6 05 eb 87 00 00 	movzbl 0x87eb,%eax
    26d1:	0f be d0             	movsbl %al,%edx
    26d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26d7:	89 c1                	mov    %eax,%ecx
    26d9:	c1 e9 1f             	shr    $0x1f,%ecx
    26dc:	01 c8                	add    %ecx,%eax
    26de:	d1 f8                	sar    %eax
    26e0:	39 c2                	cmp    %eax,%edx
    26e2:	74 19                	je     26fd <bigfile+0x1c6>
      printf(1, "read bigfile wrong data\n");
    26e4:	c7 44 24 04 6b 4f 00 	movl   $0x4f6b,0x4(%esp)
    26eb:	00 
    26ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26f3:	e8 c5 16 00 00       	call   3dbd <printf>
      exit();
    26f8:	e8 43 15 00 00       	call   3c40 <exit>
    }
    total += cc;
    26fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2700:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    2703:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    2707:	e9 3f ff ff ff       	jmp    264b <bigfile+0x114>
    if(cc < 0){
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    270c:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    270d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2710:	89 04 24             	mov    %eax,(%esp)
    2713:	e8 50 15 00 00       	call   3c68 <close>
  if(total != 20*600){
    2718:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    271f:	74 19                	je     273a <bigfile+0x203>
    printf(1, "read bigfile wrong total\n");
    2721:	c7 44 24 04 84 4f 00 	movl   $0x4f84,0x4(%esp)
    2728:	00 
    2729:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2730:	e8 88 16 00 00       	call   3dbd <printf>
    exit();
    2735:	e8 06 15 00 00       	call   3c40 <exit>
  }
  unlink("bigfile");
    273a:	c7 04 24 f9 4e 00 00 	movl   $0x4ef9,(%esp)
    2741:	e8 4a 15 00 00       	call   3c90 <unlink>

  printf(1, "bigfile test ok\n");
    2746:	c7 44 24 04 9e 4f 00 	movl   $0x4f9e,0x4(%esp)
    274d:	00 
    274e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2755:	e8 63 16 00 00       	call   3dbd <printf>
}
    275a:	c9                   	leave  
    275b:	c3                   	ret    

0000275c <fourteen>:

void
fourteen(void)
{
    275c:	55                   	push   %ebp
    275d:	89 e5                	mov    %esp,%ebp
    275f:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2762:	c7 44 24 04 af 4f 00 	movl   $0x4faf,0x4(%esp)
    2769:	00 
    276a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2771:	e8 47 16 00 00       	call   3dbd <printf>

  if(mkdir("12345678901234") != 0){
    2776:	c7 04 24 be 4f 00 00 	movl   $0x4fbe,(%esp)
    277d:	e8 26 15 00 00       	call   3ca8 <mkdir>
    2782:	85 c0                	test   %eax,%eax
    2784:	74 19                	je     279f <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2786:	c7 44 24 04 cd 4f 00 	movl   $0x4fcd,0x4(%esp)
    278d:	00 
    278e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2795:	e8 23 16 00 00       	call   3dbd <printf>
    exit();
    279a:	e8 a1 14 00 00       	call   3c40 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    279f:	c7 04 24 ec 4f 00 00 	movl   $0x4fec,(%esp)
    27a6:	e8 fd 14 00 00       	call   3ca8 <mkdir>
    27ab:	85 c0                	test   %eax,%eax
    27ad:	74 19                	je     27c8 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    27af:	c7 44 24 04 0c 50 00 	movl   $0x500c,0x4(%esp)
    27b6:	00 
    27b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27be:	e8 fa 15 00 00       	call   3dbd <printf>
    exit();
    27c3:	e8 78 14 00 00       	call   3c40 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27c8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    27cf:	00 
    27d0:	c7 04 24 3c 50 00 00 	movl   $0x503c,(%esp)
    27d7:	e8 a4 14 00 00       	call   3c80 <open>
    27dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    27df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    27e3:	79 19                	jns    27fe <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    27e5:	c7 44 24 04 6c 50 00 	movl   $0x506c,0x4(%esp)
    27ec:	00 
    27ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27f4:	e8 c4 15 00 00       	call   3dbd <printf>
    exit();
    27f9:	e8 42 14 00 00       	call   3c40 <exit>
  }
  close(fd);
    27fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2801:	89 04 24             	mov    %eax,(%esp)
    2804:	e8 5f 14 00 00       	call   3c68 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2809:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2810:	00 
    2811:	c7 04 24 ac 50 00 00 	movl   $0x50ac,(%esp)
    2818:	e8 63 14 00 00       	call   3c80 <open>
    281d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2824:	79 19                	jns    283f <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2826:	c7 44 24 04 dc 50 00 	movl   $0x50dc,0x4(%esp)
    282d:	00 
    282e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2835:	e8 83 15 00 00       	call   3dbd <printf>
    exit();
    283a:	e8 01 14 00 00       	call   3c40 <exit>
  }
  close(fd);
    283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2842:	89 04 24             	mov    %eax,(%esp)
    2845:	e8 1e 14 00 00       	call   3c68 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    284a:	c7 04 24 16 51 00 00 	movl   $0x5116,(%esp)
    2851:	e8 52 14 00 00       	call   3ca8 <mkdir>
    2856:	85 c0                	test   %eax,%eax
    2858:	75 19                	jne    2873 <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    285a:	c7 44 24 04 34 51 00 	movl   $0x5134,0x4(%esp)
    2861:	00 
    2862:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2869:	e8 4f 15 00 00       	call   3dbd <printf>
    exit();
    286e:	e8 cd 13 00 00       	call   3c40 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2873:	c7 04 24 64 51 00 00 	movl   $0x5164,(%esp)
    287a:	e8 29 14 00 00       	call   3ca8 <mkdir>
    287f:	85 c0                	test   %eax,%eax
    2881:	75 19                	jne    289c <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2883:	c7 44 24 04 84 51 00 	movl   $0x5184,0x4(%esp)
    288a:	00 
    288b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2892:	e8 26 15 00 00       	call   3dbd <printf>
    exit();
    2897:	e8 a4 13 00 00       	call   3c40 <exit>
  }

  printf(1, "fourteen ok\n");
    289c:	c7 44 24 04 b5 51 00 	movl   $0x51b5,0x4(%esp)
    28a3:	00 
    28a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28ab:	e8 0d 15 00 00       	call   3dbd <printf>
}
    28b0:	c9                   	leave  
    28b1:	c3                   	ret    

000028b2 <rmdot>:

void
rmdot(void)
{
    28b2:	55                   	push   %ebp
    28b3:	89 e5                	mov    %esp,%ebp
    28b5:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    28b8:	c7 44 24 04 c2 51 00 	movl   $0x51c2,0x4(%esp)
    28bf:	00 
    28c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28c7:	e8 f1 14 00 00       	call   3dbd <printf>
  if(mkdir("dots") != 0){
    28cc:	c7 04 24 ce 51 00 00 	movl   $0x51ce,(%esp)
    28d3:	e8 d0 13 00 00       	call   3ca8 <mkdir>
    28d8:	85 c0                	test   %eax,%eax
    28da:	74 19                	je     28f5 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    28dc:	c7 44 24 04 d3 51 00 	movl   $0x51d3,0x4(%esp)
    28e3:	00 
    28e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28eb:	e8 cd 14 00 00       	call   3dbd <printf>
    exit();
    28f0:	e8 4b 13 00 00       	call   3c40 <exit>
  }
  if(chdir("dots") != 0){
    28f5:	c7 04 24 ce 51 00 00 	movl   $0x51ce,(%esp)
    28fc:	e8 af 13 00 00       	call   3cb0 <chdir>
    2901:	85 c0                	test   %eax,%eax
    2903:	74 19                	je     291e <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2905:	c7 44 24 04 e6 51 00 	movl   $0x51e6,0x4(%esp)
    290c:	00 
    290d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2914:	e8 a4 14 00 00       	call   3dbd <printf>
    exit();
    2919:	e8 22 13 00 00       	call   3c40 <exit>
  }
  if(unlink(".") == 0){
    291e:	c7 04 24 ff 48 00 00 	movl   $0x48ff,(%esp)
    2925:	e8 66 13 00 00       	call   3c90 <unlink>
    292a:	85 c0                	test   %eax,%eax
    292c:	75 19                	jne    2947 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    292e:	c7 44 24 04 f9 51 00 	movl   $0x51f9,0x4(%esp)
    2935:	00 
    2936:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    293d:	e8 7b 14 00 00       	call   3dbd <printf>
    exit();
    2942:	e8 f9 12 00 00       	call   3c40 <exit>
  }
  if(unlink("..") == 0){
    2947:	c7 04 24 8c 44 00 00 	movl   $0x448c,(%esp)
    294e:	e8 3d 13 00 00       	call   3c90 <unlink>
    2953:	85 c0                	test   %eax,%eax
    2955:	75 19                	jne    2970 <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2957:	c7 44 24 04 07 52 00 	movl   $0x5207,0x4(%esp)
    295e:	00 
    295f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2966:	e8 52 14 00 00       	call   3dbd <printf>
    exit();
    296b:	e8 d0 12 00 00       	call   3c40 <exit>
  }
  if(chdir("/") != 0){
    2970:	c7 04 24 16 52 00 00 	movl   $0x5216,(%esp)
    2977:	e8 34 13 00 00       	call   3cb0 <chdir>
    297c:	85 c0                	test   %eax,%eax
    297e:	74 19                	je     2999 <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2980:	c7 44 24 04 18 52 00 	movl   $0x5218,0x4(%esp)
    2987:	00 
    2988:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    298f:	e8 29 14 00 00       	call   3dbd <printf>
    exit();
    2994:	e8 a7 12 00 00       	call   3c40 <exit>
  }
  if(unlink("dots/.") == 0){
    2999:	c7 04 24 28 52 00 00 	movl   $0x5228,(%esp)
    29a0:	e8 eb 12 00 00       	call   3c90 <unlink>
    29a5:	85 c0                	test   %eax,%eax
    29a7:	75 19                	jne    29c2 <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    29a9:	c7 44 24 04 2f 52 00 	movl   $0x522f,0x4(%esp)
    29b0:	00 
    29b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29b8:	e8 00 14 00 00       	call   3dbd <printf>
    exit();
    29bd:	e8 7e 12 00 00       	call   3c40 <exit>
  }
  if(unlink("dots/..") == 0){
    29c2:	c7 04 24 46 52 00 00 	movl   $0x5246,(%esp)
    29c9:	e8 c2 12 00 00       	call   3c90 <unlink>
    29ce:	85 c0                	test   %eax,%eax
    29d0:	75 19                	jne    29eb <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    29d2:	c7 44 24 04 4e 52 00 	movl   $0x524e,0x4(%esp)
    29d9:	00 
    29da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29e1:	e8 d7 13 00 00       	call   3dbd <printf>
    exit();
    29e6:	e8 55 12 00 00       	call   3c40 <exit>
  }
  if(unlink("dots") != 0){
    29eb:	c7 04 24 ce 51 00 00 	movl   $0x51ce,(%esp)
    29f2:	e8 99 12 00 00       	call   3c90 <unlink>
    29f7:	85 c0                	test   %eax,%eax
    29f9:	74 19                	je     2a14 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    29fb:	c7 44 24 04 66 52 00 	movl   $0x5266,0x4(%esp)
    2a02:	00 
    2a03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a0a:	e8 ae 13 00 00       	call   3dbd <printf>
    exit();
    2a0f:	e8 2c 12 00 00       	call   3c40 <exit>
  }
  printf(1, "rmdot ok\n");
    2a14:	c7 44 24 04 7b 52 00 	movl   $0x527b,0x4(%esp)
    2a1b:	00 
    2a1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a23:	e8 95 13 00 00       	call   3dbd <printf>
}
    2a28:	c9                   	leave  
    2a29:	c3                   	ret    

00002a2a <dirfile>:

void
dirfile(void)
{
    2a2a:	55                   	push   %ebp
    2a2b:	89 e5                	mov    %esp,%ebp
    2a2d:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2a30:	c7 44 24 04 85 52 00 	movl   $0x5285,0x4(%esp)
    2a37:	00 
    2a38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a3f:	e8 79 13 00 00       	call   3dbd <printf>

  fd = open("dirfile", O_CREATE);
    2a44:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a4b:	00 
    2a4c:	c7 04 24 92 52 00 00 	movl   $0x5292,(%esp)
    2a53:	e8 28 12 00 00       	call   3c80 <open>
    2a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a5f:	79 19                	jns    2a7a <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2a61:	c7 44 24 04 9a 52 00 	movl   $0x529a,0x4(%esp)
    2a68:	00 
    2a69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a70:	e8 48 13 00 00       	call   3dbd <printf>
    exit();
    2a75:	e8 c6 11 00 00       	call   3c40 <exit>
  }
  close(fd);
    2a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a7d:	89 04 24             	mov    %eax,(%esp)
    2a80:	e8 e3 11 00 00       	call   3c68 <close>
  if(chdir("dirfile") == 0){
    2a85:	c7 04 24 92 52 00 00 	movl   $0x5292,(%esp)
    2a8c:	e8 1f 12 00 00       	call   3cb0 <chdir>
    2a91:	85 c0                	test   %eax,%eax
    2a93:	75 19                	jne    2aae <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2a95:	c7 44 24 04 b1 52 00 	movl   $0x52b1,0x4(%esp)
    2a9c:	00 
    2a9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aa4:	e8 14 13 00 00       	call   3dbd <printf>
    exit();
    2aa9:	e8 92 11 00 00       	call   3c40 <exit>
  }
  fd = open("dirfile/xx", 0);
    2aae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2ab5:	00 
    2ab6:	c7 04 24 cb 52 00 00 	movl   $0x52cb,(%esp)
    2abd:	e8 be 11 00 00       	call   3c80 <open>
    2ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ac9:	78 19                	js     2ae4 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2acb:	c7 44 24 04 d6 52 00 	movl   $0x52d6,0x4(%esp)
    2ad2:	00 
    2ad3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ada:	e8 de 12 00 00       	call   3dbd <printf>
    exit();
    2adf:	e8 5c 11 00 00       	call   3c40 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2ae4:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2aeb:	00 
    2aec:	c7 04 24 cb 52 00 00 	movl   $0x52cb,(%esp)
    2af3:	e8 88 11 00 00       	call   3c80 <open>
    2af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aff:	78 19                	js     2b1a <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2b01:	c7 44 24 04 d6 52 00 	movl   $0x52d6,0x4(%esp)
    2b08:	00 
    2b09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b10:	e8 a8 12 00 00       	call   3dbd <printf>
    exit();
    2b15:	e8 26 11 00 00       	call   3c40 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2b1a:	c7 04 24 cb 52 00 00 	movl   $0x52cb,(%esp)
    2b21:	e8 82 11 00 00       	call   3ca8 <mkdir>
    2b26:	85 c0                	test   %eax,%eax
    2b28:	75 19                	jne    2b43 <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2b2a:	c7 44 24 04 f4 52 00 	movl   $0x52f4,0x4(%esp)
    2b31:	00 
    2b32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b39:	e8 7f 12 00 00       	call   3dbd <printf>
    exit();
    2b3e:	e8 fd 10 00 00       	call   3c40 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2b43:	c7 04 24 cb 52 00 00 	movl   $0x52cb,(%esp)
    2b4a:	e8 41 11 00 00       	call   3c90 <unlink>
    2b4f:	85 c0                	test   %eax,%eax
    2b51:	75 19                	jne    2b6c <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2b53:	c7 44 24 04 11 53 00 	movl   $0x5311,0x4(%esp)
    2b5a:	00 
    2b5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b62:	e8 56 12 00 00       	call   3dbd <printf>
    exit();
    2b67:	e8 d4 10 00 00       	call   3c40 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2b6c:	c7 44 24 04 cb 52 00 	movl   $0x52cb,0x4(%esp)
    2b73:	00 
    2b74:	c7 04 24 2f 53 00 00 	movl   $0x532f,(%esp)
    2b7b:	e8 20 11 00 00       	call   3ca0 <link>
    2b80:	85 c0                	test   %eax,%eax
    2b82:	75 19                	jne    2b9d <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2b84:	c7 44 24 04 38 53 00 	movl   $0x5338,0x4(%esp)
    2b8b:	00 
    2b8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b93:	e8 25 12 00 00       	call   3dbd <printf>
    exit();
    2b98:	e8 a3 10 00 00       	call   3c40 <exit>
  }
  if(unlink("dirfile") != 0){
    2b9d:	c7 04 24 92 52 00 00 	movl   $0x5292,(%esp)
    2ba4:	e8 e7 10 00 00       	call   3c90 <unlink>
    2ba9:	85 c0                	test   %eax,%eax
    2bab:	74 19                	je     2bc6 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2bad:	c7 44 24 04 57 53 00 	movl   $0x5357,0x4(%esp)
    2bb4:	00 
    2bb5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bbc:	e8 fc 11 00 00       	call   3dbd <printf>
    exit();
    2bc1:	e8 7a 10 00 00       	call   3c40 <exit>
  }

  fd = open(".", O_RDWR);
    2bc6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2bcd:	00 
    2bce:	c7 04 24 ff 48 00 00 	movl   $0x48ff,(%esp)
    2bd5:	e8 a6 10 00 00       	call   3c80 <open>
    2bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2be1:	78 19                	js     2bfc <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2be3:	c7 44 24 04 70 53 00 	movl   $0x5370,0x4(%esp)
    2bea:	00 
    2beb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bf2:	e8 c6 11 00 00       	call   3dbd <printf>
    exit();
    2bf7:	e8 44 10 00 00       	call   3c40 <exit>
  }
  fd = open(".", 0);
    2bfc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2c03:	00 
    2c04:	c7 04 24 ff 48 00 00 	movl   $0x48ff,(%esp)
    2c0b:	e8 70 10 00 00       	call   3c80 <open>
    2c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2c13:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2c1a:	00 
    2c1b:	c7 44 24 04 36 45 00 	movl   $0x4536,0x4(%esp)
    2c22:	00 
    2c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c26:	89 04 24             	mov    %eax,(%esp)
    2c29:	e8 32 10 00 00       	call   3c60 <write>
    2c2e:	85 c0                	test   %eax,%eax
    2c30:	7e 19                	jle    2c4b <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2c32:	c7 44 24 04 8f 53 00 	movl   $0x538f,0x4(%esp)
    2c39:	00 
    2c3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c41:	e8 77 11 00 00       	call   3dbd <printf>
    exit();
    2c46:	e8 f5 0f 00 00       	call   3c40 <exit>
  }
  close(fd);
    2c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c4e:	89 04 24             	mov    %eax,(%esp)
    2c51:	e8 12 10 00 00       	call   3c68 <close>

  printf(1, "dir vs file OK\n");
    2c56:	c7 44 24 04 a3 53 00 	movl   $0x53a3,0x4(%esp)
    2c5d:	00 
    2c5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c65:	e8 53 11 00 00       	call   3dbd <printf>
}
    2c6a:	c9                   	leave  
    2c6b:	c3                   	ret    

00002c6c <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2c6c:	55                   	push   %ebp
    2c6d:	89 e5                	mov    %esp,%ebp
    2c6f:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2c72:	c7 44 24 04 b3 53 00 	movl   $0x53b3,0x4(%esp)
    2c79:	00 
    2c7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c81:	e8 37 11 00 00       	call   3dbd <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2c86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2c8d:	e9 d2 00 00 00       	jmp    2d64 <iref+0xf8>
    if(mkdir("irefd") != 0){
    2c92:	c7 04 24 c4 53 00 00 	movl   $0x53c4,(%esp)
    2c99:	e8 0a 10 00 00       	call   3ca8 <mkdir>
    2c9e:	85 c0                	test   %eax,%eax
    2ca0:	74 19                	je     2cbb <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2ca2:	c7 44 24 04 ca 53 00 	movl   $0x53ca,0x4(%esp)
    2ca9:	00 
    2caa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cb1:	e8 07 11 00 00       	call   3dbd <printf>
      exit();
    2cb6:	e8 85 0f 00 00       	call   3c40 <exit>
    }
    if(chdir("irefd") != 0){
    2cbb:	c7 04 24 c4 53 00 00 	movl   $0x53c4,(%esp)
    2cc2:	e8 e9 0f 00 00       	call   3cb0 <chdir>
    2cc7:	85 c0                	test   %eax,%eax
    2cc9:	74 19                	je     2ce4 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2ccb:	c7 44 24 04 de 53 00 	movl   $0x53de,0x4(%esp)
    2cd2:	00 
    2cd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cda:	e8 de 10 00 00       	call   3dbd <printf>
      exit();
    2cdf:	e8 5c 0f 00 00       	call   3c40 <exit>
    }

    mkdir("");
    2ce4:	c7 04 24 f2 53 00 00 	movl   $0x53f2,(%esp)
    2ceb:	e8 b8 0f 00 00       	call   3ca8 <mkdir>
    link("README", "");
    2cf0:	c7 44 24 04 f2 53 00 	movl   $0x53f2,0x4(%esp)
    2cf7:	00 
    2cf8:	c7 04 24 2f 53 00 00 	movl   $0x532f,(%esp)
    2cff:	e8 9c 0f 00 00       	call   3ca0 <link>
    fd = open("", O_CREATE);
    2d04:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d0b:	00 
    2d0c:	c7 04 24 f2 53 00 00 	movl   $0x53f2,(%esp)
    2d13:	e8 68 0f 00 00       	call   3c80 <open>
    2d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d1f:	78 0b                	js     2d2c <iref+0xc0>
      close(fd);
    2d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2d24:	89 04 24             	mov    %eax,(%esp)
    2d27:	e8 3c 0f 00 00       	call   3c68 <close>
    fd = open("xx", O_CREATE);
    2d2c:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d33:	00 
    2d34:	c7 04 24 f3 53 00 00 	movl   $0x53f3,(%esp)
    2d3b:	e8 40 0f 00 00       	call   3c80 <open>
    2d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2d43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d47:	78 0b                	js     2d54 <iref+0xe8>
      close(fd);
    2d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2d4c:	89 04 24             	mov    %eax,(%esp)
    2d4f:	e8 14 0f 00 00       	call   3c68 <close>
    unlink("xx");
    2d54:	c7 04 24 f3 53 00 00 	movl   $0x53f3,(%esp)
    2d5b:	e8 30 0f 00 00       	call   3c90 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2d60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2d64:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2d68:	0f 8e 24 ff ff ff    	jle    2c92 <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2d6e:	c7 04 24 16 52 00 00 	movl   $0x5216,(%esp)
    2d75:	e8 36 0f 00 00       	call   3cb0 <chdir>
  printf(1, "empty file name OK\n");
    2d7a:	c7 44 24 04 f6 53 00 	movl   $0x53f6,0x4(%esp)
    2d81:	00 
    2d82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d89:	e8 2f 10 00 00       	call   3dbd <printf>
}
    2d8e:	c9                   	leave  
    2d8f:	c3                   	ret    

00002d90 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2d90:	55                   	push   %ebp
    2d91:	89 e5                	mov    %esp,%ebp
    2d93:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    2d96:	c7 44 24 04 0a 54 00 	movl   $0x540a,0x4(%esp)
    2d9d:	00 
    2d9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2da5:	e8 13 10 00 00       	call   3dbd <printf>

  for(n=0; n<1000; n++){
    2daa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2db1:	eb 1d                	jmp    2dd0 <forktest+0x40>
    pid = fork();
    2db3:	e8 80 0e 00 00       	call   3c38 <fork>
    2db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    2dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2dbf:	78 1a                	js     2ddb <forktest+0x4b>
      break;
    if(pid == 0)
    2dc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2dc5:	75 05                	jne    2dcc <forktest+0x3c>
      exit();
    2dc7:	e8 74 0e 00 00       	call   3c40 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    2dcc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2dd0:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    2dd7:	7e da                	jle    2db3 <forktest+0x23>
    2dd9:	eb 01                	jmp    2ddc <forktest+0x4c>
    pid = fork();
    if(pid < 0)
      break;
    2ddb:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    2ddc:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    2de3:	75 3f                	jne    2e24 <forktest+0x94>
    printf(1, "fork claimed to work 1000 times!\n");
    2de5:	c7 44 24 04 18 54 00 	movl   $0x5418,0x4(%esp)
    2dec:	00 
    2ded:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2df4:	e8 c4 0f 00 00       	call   3dbd <printf>
    exit();
    2df9:	e8 42 0e 00 00       	call   3c40 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    2dfe:	e8 45 0e 00 00       	call   3c48 <wait>
    2e03:	85 c0                	test   %eax,%eax
    2e05:	79 19                	jns    2e20 <forktest+0x90>
      printf(1, "wait stopped early\n");
    2e07:	c7 44 24 04 3a 54 00 	movl   $0x543a,0x4(%esp)
    2e0e:	00 
    2e0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e16:	e8 a2 0f 00 00       	call   3dbd <printf>
      exit();
    2e1b:	e8 20 0e 00 00       	call   3c40 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    2e20:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    2e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e28:	7f d4                	jg     2dfe <forktest+0x6e>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    2e2a:	e8 19 0e 00 00       	call   3c48 <wait>
    2e2f:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e32:	74 19                	je     2e4d <forktest+0xbd>
    printf(1, "wait got too many\n");
    2e34:	c7 44 24 04 4e 54 00 	movl   $0x544e,0x4(%esp)
    2e3b:	00 
    2e3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e43:	e8 75 0f 00 00       	call   3dbd <printf>
    exit();
    2e48:	e8 f3 0d 00 00       	call   3c40 <exit>
  }
  
  printf(1, "fork test OK\n");
    2e4d:	c7 44 24 04 61 54 00 	movl   $0x5461,0x4(%esp)
    2e54:	00 
    2e55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e5c:	e8 5c 0f 00 00       	call   3dbd <printf>
}
    2e61:	c9                   	leave  
    2e62:	c3                   	ret    

00002e63 <sbrktest>:

void
sbrktest(void)
{
    2e63:	55                   	push   %ebp
    2e64:	89 e5                	mov    %esp,%ebp
    2e66:	53                   	push   %ebx
    2e67:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2e6d:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    2e72:	c7 44 24 04 6f 54 00 	movl   $0x546f,0x4(%esp)
    2e79:	00 
    2e7a:	89 04 24             	mov    %eax,(%esp)
    2e7d:	e8 3b 0f 00 00       	call   3dbd <printf>
  oldbrk = sbrk(0);
    2e82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e89:	e8 3a 0e 00 00       	call   3cc8 <sbrk>
    2e8e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    2e91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e98:	e8 2b 0e 00 00       	call   3cc8 <sbrk>
    2e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    2ea0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2ea7:	eb 59                	jmp    2f02 <sbrktest+0x9f>
    b = sbrk(1);
    2ea9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2eb0:	e8 13 0e 00 00       	call   3cc8 <sbrk>
    2eb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    2eb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2ebb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2ebe:	74 2f                	je     2eef <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2ec0:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    2ec5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2ec8:	89 54 24 10          	mov    %edx,0x10(%esp)
    2ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2ecf:	89 54 24 0c          	mov    %edx,0xc(%esp)
    2ed3:	8b 55 f0             	mov    -0x10(%ebp),%edx
    2ed6:	89 54 24 08          	mov    %edx,0x8(%esp)
    2eda:	c7 44 24 04 7a 54 00 	movl   $0x547a,0x4(%esp)
    2ee1:	00 
    2ee2:	89 04 24             	mov    %eax,(%esp)
    2ee5:	e8 d3 0e 00 00       	call   3dbd <printf>
      exit();
    2eea:	e8 51 0d 00 00       	call   3c40 <exit>
    }
    *b = 1;
    2eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2ef2:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    2ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2ef8:	83 c0 01             	add    $0x1,%eax
    2efb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    2efe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2f02:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    2f09:	7e 9e                	jle    2ea9 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    2f0b:	e8 28 0d 00 00       	call   3c38 <fork>
    2f10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    2f13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2f17:	79 1a                	jns    2f33 <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    2f19:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    2f1e:	c7 44 24 04 95 54 00 	movl   $0x5495,0x4(%esp)
    2f25:	00 
    2f26:	89 04 24             	mov    %eax,(%esp)
    2f29:	e8 8f 0e 00 00       	call   3dbd <printf>
    exit();
    2f2e:	e8 0d 0d 00 00       	call   3c40 <exit>
  }
  c = sbrk(1);
    2f33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f3a:	e8 89 0d 00 00       	call   3cc8 <sbrk>
    2f3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    2f42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f49:	e8 7a 0d 00 00       	call   3cc8 <sbrk>
    2f4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    2f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f54:	83 c0 01             	add    $0x1,%eax
    2f57:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    2f5a:	74 1a                	je     2f76 <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    2f5c:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    2f61:	c7 44 24 04 ac 54 00 	movl   $0x54ac,0x4(%esp)
    2f68:	00 
    2f69:	89 04 24             	mov    %eax,(%esp)
    2f6c:	e8 4c 0e 00 00       	call   3dbd <printf>
    exit();
    2f71:	e8 ca 0c 00 00       	call   3c40 <exit>
  }
  if(pid == 0)
    2f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2f7a:	75 05                	jne    2f81 <sbrktest+0x11e>
    exit();
    2f7c:	e8 bf 0c 00 00       	call   3c40 <exit>
  wait();
    2f81:	e8 c2 0c 00 00       	call   3c48 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2f86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f8d:	e8 36 0d 00 00       	call   3cc8 <sbrk>
    2f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    2f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f98:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2f9d:	89 d1                	mov    %edx,%ecx
    2f9f:	29 c1                	sub    %eax,%ecx
    2fa1:	89 c8                	mov    %ecx,%eax
    2fa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    2fa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2fa9:	89 04 24             	mov    %eax,(%esp)
    2fac:	e8 17 0d 00 00       	call   3cc8 <sbrk>
    2fb1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    2fb4:	8b 45 d8             	mov    -0x28(%ebp),%eax
    2fb7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2fba:	74 1a                	je     2fd6 <sbrktest+0x173>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2fbc:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    2fc1:	c7 44 24 04 c8 54 00 	movl   $0x54c8,0x4(%esp)
    2fc8:	00 
    2fc9:	89 04 24             	mov    %eax,(%esp)
    2fcc:	e8 ec 0d 00 00       	call   3dbd <printf>
    exit();
    2fd1:	e8 6a 0c 00 00       	call   3c40 <exit>
  }
  lastaddr = (char*) (BIG-1);
    2fd6:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    2fdd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2fe0:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    2fe3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fea:	e8 d9 0c 00 00       	call   3cc8 <sbrk>
    2fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    2ff2:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2ff9:	e8 ca 0c 00 00       	call   3cc8 <sbrk>
    2ffe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3001:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3005:	75 1a                	jne    3021 <sbrktest+0x1be>
    printf(stdout, "sbrk could not deallocate\n");
    3007:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    300c:	c7 44 24 04 06 55 00 	movl   $0x5506,0x4(%esp)
    3013:	00 
    3014:	89 04 24             	mov    %eax,(%esp)
    3017:	e8 a1 0d 00 00       	call   3dbd <printf>
    exit();
    301c:	e8 1f 0c 00 00       	call   3c40 <exit>
  }
  c = sbrk(0);
    3021:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3028:	e8 9b 0c 00 00       	call   3cc8 <sbrk>
    302d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    3030:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3033:	2d 00 10 00 00       	sub    $0x1000,%eax
    3038:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    303b:	74 28                	je     3065 <sbrktest+0x202>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    303d:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    3042:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3045:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3049:	8b 55 f4             	mov    -0xc(%ebp),%edx
    304c:	89 54 24 08          	mov    %edx,0x8(%esp)
    3050:	c7 44 24 04 24 55 00 	movl   $0x5524,0x4(%esp)
    3057:	00 
    3058:	89 04 24             	mov    %eax,(%esp)
    305b:	e8 5d 0d 00 00       	call   3dbd <printf>
    exit();
    3060:	e8 db 0b 00 00       	call   3c40 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3065:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    306c:	e8 57 0c 00 00       	call   3cc8 <sbrk>
    3071:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3074:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    307b:	e8 48 0c 00 00       	call   3cc8 <sbrk>
    3080:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3083:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3086:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3089:	75 19                	jne    30a4 <sbrktest+0x241>
    308b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3092:	e8 31 0c 00 00       	call   3cc8 <sbrk>
    3097:	8b 55 f4             	mov    -0xc(%ebp),%edx
    309a:	81 c2 00 10 00 00    	add    $0x1000,%edx
    30a0:	39 d0                	cmp    %edx,%eax
    30a2:	74 28                	je     30cc <sbrktest+0x269>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    30a4:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    30a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
    30ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
    30b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
    30b3:	89 54 24 08          	mov    %edx,0x8(%esp)
    30b7:	c7 44 24 04 5c 55 00 	movl   $0x555c,0x4(%esp)
    30be:	00 
    30bf:	89 04 24             	mov    %eax,(%esp)
    30c2:	e8 f6 0c 00 00       	call   3dbd <printf>
    exit();
    30c7:	e8 74 0b 00 00       	call   3c40 <exit>
  }
  if(*lastaddr == 99){
    30cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    30cf:	0f b6 00             	movzbl (%eax),%eax
    30d2:	3c 63                	cmp    $0x63,%al
    30d4:	75 1a                	jne    30f0 <sbrktest+0x28d>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    30d6:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    30db:	c7 44 24 04 84 55 00 	movl   $0x5584,0x4(%esp)
    30e2:	00 
    30e3:	89 04 24             	mov    %eax,(%esp)
    30e6:	e8 d2 0c 00 00       	call   3dbd <printf>
    exit();
    30eb:	e8 50 0b 00 00       	call   3c40 <exit>
  }

  a = sbrk(0);
    30f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30f7:	e8 cc 0b 00 00       	call   3cc8 <sbrk>
    30fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    30ff:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3102:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3109:	e8 ba 0b 00 00       	call   3cc8 <sbrk>
    310e:	89 da                	mov    %ebx,%edx
    3110:	29 c2                	sub    %eax,%edx
    3112:	89 d0                	mov    %edx,%eax
    3114:	89 04 24             	mov    %eax,(%esp)
    3117:	e8 ac 0b 00 00       	call   3cc8 <sbrk>
    311c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    311f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3122:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3125:	74 28                	je     314f <sbrktest+0x2ec>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3127:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    312c:	8b 55 e0             	mov    -0x20(%ebp),%edx
    312f:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3133:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3136:	89 54 24 08          	mov    %edx,0x8(%esp)
    313a:	c7 44 24 04 b4 55 00 	movl   $0x55b4,0x4(%esp)
    3141:	00 
    3142:	89 04 24             	mov    %eax,(%esp)
    3145:	e8 73 0c 00 00       	call   3dbd <printf>
    exit();
    314a:	e8 f1 0a 00 00       	call   3c40 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    314f:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    3156:	eb 7b                	jmp    31d3 <sbrktest+0x370>
    ppid = getpid();
    3158:	e8 63 0b 00 00       	call   3cc0 <getpid>
    315d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    3160:	e8 d3 0a 00 00       	call   3c38 <fork>
    3165:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    3168:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    316c:	79 1a                	jns    3188 <sbrktest+0x325>
      printf(stdout, "fork failed\n");
    316e:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    3173:	c7 44 24 04 7d 45 00 	movl   $0x457d,0x4(%esp)
    317a:	00 
    317b:	89 04 24             	mov    %eax,(%esp)
    317e:	e8 3a 0c 00 00       	call   3dbd <printf>
      exit();
    3183:	e8 b8 0a 00 00       	call   3c40 <exit>
    }
    if(pid == 0){
    3188:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    318c:	75 39                	jne    31c7 <sbrktest+0x364>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3191:	0f b6 00             	movzbl (%eax),%eax
    3194:	0f be d0             	movsbl %al,%edx
    3197:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    319c:	89 54 24 0c          	mov    %edx,0xc(%esp)
    31a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
    31a3:	89 54 24 08          	mov    %edx,0x8(%esp)
    31a7:	c7 44 24 04 d5 55 00 	movl   $0x55d5,0x4(%esp)
    31ae:	00 
    31af:	89 04 24             	mov    %eax,(%esp)
    31b2:	e8 06 0c 00 00       	call   3dbd <printf>
      kill(ppid);
    31b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
    31ba:	89 04 24             	mov    %eax,(%esp)
    31bd:	e8 ae 0a 00 00       	call   3c70 <kill>
      exit();
    31c2:	e8 79 0a 00 00       	call   3c40 <exit>
    }
    wait();
    31c7:	e8 7c 0a 00 00       	call   3c48 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    31cc:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    31d3:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    31da:	0f 86 78 ff ff ff    	jbe    3158 <sbrktest+0x2f5>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    31e0:	8d 45 c8             	lea    -0x38(%ebp),%eax
    31e3:	89 04 24             	mov    %eax,(%esp)
    31e6:	e8 65 0a 00 00       	call   3c50 <pipe>
    31eb:	85 c0                	test   %eax,%eax
    31ed:	74 19                	je     3208 <sbrktest+0x3a5>
    printf(1, "pipe() failed\n");
    31ef:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
    31f6:	00 
    31f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31fe:	e8 ba 0b 00 00       	call   3dbd <printf>
    exit();
    3203:	e8 38 0a 00 00       	call   3c40 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3208:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    320f:	e9 89 00 00 00       	jmp    329d <sbrktest+0x43a>
    if((pids[i] = fork()) == 0){
    3214:	e8 1f 0a 00 00       	call   3c38 <fork>
    3219:	8b 55 f0             	mov    -0x10(%ebp),%edx
    321c:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    3220:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3223:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3227:	85 c0                	test   %eax,%eax
    3229:	75 48                	jne    3273 <sbrktest+0x410>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    322b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3232:	e8 91 0a 00 00       	call   3cc8 <sbrk>
    3237:	ba 00 00 40 06       	mov    $0x6400000,%edx
    323c:	89 d1                	mov    %edx,%ecx
    323e:	29 c1                	sub    %eax,%ecx
    3240:	89 c8                	mov    %ecx,%eax
    3242:	89 04 24             	mov    %eax,(%esp)
    3245:	e8 7e 0a 00 00       	call   3cc8 <sbrk>
      write(fds[1], "x", 1);
    324a:	8b 45 cc             	mov    -0x34(%ebp),%eax
    324d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3254:	00 
    3255:	c7 44 24 04 36 45 00 	movl   $0x4536,0x4(%esp)
    325c:	00 
    325d:	89 04 24             	mov    %eax,(%esp)
    3260:	e8 fb 09 00 00       	call   3c60 <write>
      // sit around until killed
      for(;;) sleep(1000);
    3265:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    326c:	e8 5f 0a 00 00       	call   3cd0 <sleep>
    3271:	eb f2                	jmp    3265 <sbrktest+0x402>
    }
    if(pids[i] != -1)
    3273:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3276:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    327a:	83 f8 ff             	cmp    $0xffffffff,%eax
    327d:	74 1a                	je     3299 <sbrktest+0x436>
      read(fds[0], &scratch, 1);
    327f:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3282:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3289:	00 
    328a:	8d 55 9f             	lea    -0x61(%ebp),%edx
    328d:	89 54 24 04          	mov    %edx,0x4(%esp)
    3291:	89 04 24             	mov    %eax,(%esp)
    3294:	e8 bf 09 00 00       	call   3c58 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3299:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    32a0:	83 f8 09             	cmp    $0x9,%eax
    32a3:	0f 86 6b ff ff ff    	jbe    3214 <sbrktest+0x3b1>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    32a9:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    32b0:	e8 13 0a 00 00       	call   3cc8 <sbrk>
    32b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    32b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    32bf:	eb 27                	jmp    32e8 <sbrktest+0x485>
    if(pids[i] == -1)
    32c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    32c4:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    32c8:	83 f8 ff             	cmp    $0xffffffff,%eax
    32cb:	74 16                	je     32e3 <sbrktest+0x480>
      continue;
    kill(pids[i]);
    32cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    32d0:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    32d4:	89 04 24             	mov    %eax,(%esp)
    32d7:	e8 94 09 00 00       	call   3c70 <kill>
    wait();
    32dc:	e8 67 09 00 00       	call   3c48 <wait>
    32e1:	eb 01                	jmp    32e4 <sbrktest+0x481>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    32e3:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    32e4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    32e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    32eb:	83 f8 09             	cmp    $0x9,%eax
    32ee:	76 d1                	jbe    32c1 <sbrktest+0x45e>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    32f0:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    32f4:	75 1a                	jne    3310 <sbrktest+0x4ad>
    printf(stdout, "failed sbrk leaked memory\n");
    32f6:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    32fb:	c7 44 24 04 ee 55 00 	movl   $0x55ee,0x4(%esp)
    3302:	00 
    3303:	89 04 24             	mov    %eax,(%esp)
    3306:	e8 b2 0a 00 00       	call   3dbd <printf>
    exit();
    330b:	e8 30 09 00 00       	call   3c40 <exit>
  }

  if(sbrk(0) > oldbrk)
    3310:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3317:	e8 ac 09 00 00       	call   3cc8 <sbrk>
    331c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    331f:	76 1d                	jbe    333e <sbrktest+0x4db>
    sbrk(-(sbrk(0) - oldbrk));
    3321:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    332b:	e8 98 09 00 00       	call   3cc8 <sbrk>
    3330:	89 da                	mov    %ebx,%edx
    3332:	29 c2                	sub    %eax,%edx
    3334:	89 d0                	mov    %edx,%eax
    3336:	89 04 24             	mov    %eax,(%esp)
    3339:	e8 8a 09 00 00       	call   3cc8 <sbrk>

  printf(stdout, "sbrk test OK\n");
    333e:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    3343:	c7 44 24 04 09 56 00 	movl   $0x5609,0x4(%esp)
    334a:	00 
    334b:	89 04 24             	mov    %eax,(%esp)
    334e:	e8 6a 0a 00 00       	call   3dbd <printf>
}
    3353:	81 c4 84 00 00 00    	add    $0x84,%esp
    3359:	5b                   	pop    %ebx
    335a:	5d                   	pop    %ebp
    335b:	c3                   	ret    

0000335c <validateint>:

void
validateint(int *p)
{
    335c:	55                   	push   %ebp
    335d:	89 e5                	mov    %esp,%ebp
    335f:	56                   	push   %esi
    3360:	53                   	push   %ebx
    3361:	83 ec 14             	sub    $0x14,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    3364:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
    336b:	8b 55 08             	mov    0x8(%ebp),%edx
    336e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3371:	89 d1                	mov    %edx,%ecx
    3373:	89 e3                	mov    %esp,%ebx
    3375:	89 cc                	mov    %ecx,%esp
    3377:	cd 40                	int    $0x40
    3379:	89 dc                	mov    %ebx,%esp
    337b:	89 c6                	mov    %eax,%esi
    337d:	89 75 f4             	mov    %esi,-0xc(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3380:	83 c4 14             	add    $0x14,%esp
    3383:	5b                   	pop    %ebx
    3384:	5e                   	pop    %esi
    3385:	5d                   	pop    %ebp
    3386:	c3                   	ret    

00003387 <validatetest>:

void
validatetest(void)
{
    3387:	55                   	push   %ebp
    3388:	89 e5                	mov    %esp,%ebp
    338a:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    338d:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    3392:	c7 44 24 04 17 56 00 	movl   $0x5617,0x4(%esp)
    3399:	00 
    339a:	89 04 24             	mov    %eax,(%esp)
    339d:	e8 1b 0a 00 00       	call   3dbd <printf>
  hi = 1100*1024;
    33a2:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    33a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    33b0:	eb 7f                	jmp    3431 <validatetest+0xaa>
    if((pid = fork()) == 0){
    33b2:	e8 81 08 00 00       	call   3c38 <fork>
    33b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    33ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    33be:	75 10                	jne    33d0 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    33c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33c3:	89 04 24             	mov    %eax,(%esp)
    33c6:	e8 91 ff ff ff       	call   335c <validateint>
      exit();
    33cb:	e8 70 08 00 00       	call   3c40 <exit>
    }
    sleep(0);
    33d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33d7:	e8 f4 08 00 00       	call   3cd0 <sleep>
    sleep(0);
    33dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33e3:	e8 e8 08 00 00       	call   3cd0 <sleep>
    kill(pid);
    33e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    33eb:	89 04 24             	mov    %eax,(%esp)
    33ee:	e8 7d 08 00 00       	call   3c70 <kill>
    wait();
    33f3:	e8 50 08 00 00       	call   3c48 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    33f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33fb:	89 44 24 04          	mov    %eax,0x4(%esp)
    33ff:	c7 04 24 26 56 00 00 	movl   $0x5626,(%esp)
    3406:	e8 95 08 00 00       	call   3ca0 <link>
    340b:	83 f8 ff             	cmp    $0xffffffff,%eax
    340e:	74 1a                	je     342a <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    3410:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    3415:	c7 44 24 04 31 56 00 	movl   $0x5631,0x4(%esp)
    341c:	00 
    341d:	89 04 24             	mov    %eax,(%esp)
    3420:	e8 98 09 00 00       	call   3dbd <printf>
      exit();
    3425:	e8 16 08 00 00       	call   3c40 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    342a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    3431:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3434:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3437:	0f 83 75 ff ff ff    	jae    33b2 <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    343d:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    3442:	c7 44 24 04 4a 56 00 	movl   $0x564a,0x4(%esp)
    3449:	00 
    344a:	89 04 24             	mov    %eax,(%esp)
    344d:	e8 6b 09 00 00       	call   3dbd <printf>
}
    3452:	c9                   	leave  
    3453:	c3                   	ret    

00003454 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3454:	55                   	push   %ebp
    3455:	89 e5                	mov    %esp,%ebp
    3457:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    345a:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    345f:	c7 44 24 04 57 56 00 	movl   $0x5657,0x4(%esp)
    3466:	00 
    3467:	89 04 24             	mov    %eax,(%esp)
    346a:	e8 4e 09 00 00       	call   3dbd <printf>
  for(i = 0; i < sizeof(uninit); i++){
    346f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3476:	eb 2d                	jmp    34a5 <bsstest+0x51>
    if(uninit[i] != '\0'){
    3478:	8b 45 f4             	mov    -0xc(%ebp),%eax
    347b:	05 a0 5f 00 00       	add    $0x5fa0,%eax
    3480:	0f b6 00             	movzbl (%eax),%eax
    3483:	84 c0                	test   %al,%al
    3485:	74 1a                	je     34a1 <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    3487:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    348c:	c7 44 24 04 61 56 00 	movl   $0x5661,0x4(%esp)
    3493:	00 
    3494:	89 04 24             	mov    %eax,(%esp)
    3497:	e8 21 09 00 00       	call   3dbd <printf>
      exit();
    349c:	e8 9f 07 00 00       	call   3c40 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    34a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    34a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34a8:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    34ad:	76 c9                	jbe    3478 <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    34af:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    34b4:	c7 44 24 04 72 56 00 	movl   $0x5672,0x4(%esp)
    34bb:	00 
    34bc:	89 04 24             	mov    %eax,(%esp)
    34bf:	e8 f9 08 00 00       	call   3dbd <printf>
}
    34c4:	c9                   	leave  
    34c5:	c3                   	ret    

000034c6 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    34c6:	55                   	push   %ebp
    34c7:	89 e5                	mov    %esp,%ebp
    34c9:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    34cc:	c7 04 24 7f 56 00 00 	movl   $0x567f,(%esp)
    34d3:	e8 b8 07 00 00       	call   3c90 <unlink>
  pid = fork();
    34d8:	e8 5b 07 00 00       	call   3c38 <fork>
    34dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    34e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    34e4:	0f 85 90 00 00 00    	jne    357a <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    34ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    34f1:	eb 12                	jmp    3505 <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    34f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34f6:	c7 04 85 00 5f 00 00 	movl   $0x568c,0x5f00(,%eax,4)
    34fd:	8c 56 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3501:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3505:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3509:	7e e8                	jle    34f3 <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    350b:	c7 05 7c 5f 00 00 00 	movl   $0x0,0x5f7c
    3512:	00 00 00 
    printf(stdout, "bigarg test\n");
    3515:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    351a:	c7 44 24 04 69 57 00 	movl   $0x5769,0x4(%esp)
    3521:	00 
    3522:	89 04 24             	mov    %eax,(%esp)
    3525:	e8 93 08 00 00       	call   3dbd <printf>
    exec("echo", args);
    352a:	c7 44 24 04 00 5f 00 	movl   $0x5f00,0x4(%esp)
    3531:	00 
    3532:	c7 04 24 90 41 00 00 	movl   $0x4190,(%esp)
    3539:	e8 3a 07 00 00       	call   3c78 <exec>
    printf(stdout, "bigarg test ok\n");
    353e:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    3543:	c7 44 24 04 76 57 00 	movl   $0x5776,0x4(%esp)
    354a:	00 
    354b:	89 04 24             	mov    %eax,(%esp)
    354e:	e8 6a 08 00 00       	call   3dbd <printf>
    fd = open("bigarg-ok", O_CREATE);
    3553:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    355a:	00 
    355b:	c7 04 24 7f 56 00 00 	movl   $0x567f,(%esp)
    3562:	e8 19 07 00 00       	call   3c80 <open>
    3567:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    356a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    356d:	89 04 24             	mov    %eax,(%esp)
    3570:	e8 f3 06 00 00       	call   3c68 <close>
    exit();
    3575:	e8 c6 06 00 00       	call   3c40 <exit>
  } else if(pid < 0){
    357a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    357e:	79 1a                	jns    359a <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    3580:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    3585:	c7 44 24 04 86 57 00 	movl   $0x5786,0x4(%esp)
    358c:	00 
    358d:	89 04 24             	mov    %eax,(%esp)
    3590:	e8 28 08 00 00       	call   3dbd <printf>
    exit();
    3595:	e8 a6 06 00 00       	call   3c40 <exit>
  }
  wait();
    359a:	e8 a9 06 00 00       	call   3c48 <wait>
  fd = open("bigarg-ok", 0);
    359f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    35a6:	00 
    35a7:	c7 04 24 7f 56 00 00 	movl   $0x567f,(%esp)
    35ae:	e8 cd 06 00 00       	call   3c80 <open>
    35b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    35b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    35ba:	79 1a                	jns    35d6 <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    35bc:	a1 e4 5e 00 00       	mov    0x5ee4,%eax
    35c1:	c7 44 24 04 9f 57 00 	movl   $0x579f,0x4(%esp)
    35c8:	00 
    35c9:	89 04 24             	mov    %eax,(%esp)
    35cc:	e8 ec 07 00 00       	call   3dbd <printf>
    exit();
    35d1:	e8 6a 06 00 00       	call   3c40 <exit>
  }
  close(fd);
    35d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    35d9:	89 04 24             	mov    %eax,(%esp)
    35dc:	e8 87 06 00 00       	call   3c68 <close>
  unlink("bigarg-ok");
    35e1:	c7 04 24 7f 56 00 00 	movl   $0x567f,(%esp)
    35e8:	e8 a3 06 00 00       	call   3c90 <unlink>
}
    35ed:	c9                   	leave  
    35ee:	c3                   	ret    

000035ef <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    35ef:	55                   	push   %ebp
    35f0:	89 e5                	mov    %esp,%ebp
    35f2:	53                   	push   %ebx
    35f3:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    35f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    35fd:	c7 44 24 04 b4 57 00 	movl   $0x57b4,0x4(%esp)
    3604:	00 
    3605:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    360c:	e8 ac 07 00 00       	call   3dbd <printf>

  for(nfiles = 0; ; nfiles++){
    3611:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    3618:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    361c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    361f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3624:	89 c8                	mov    %ecx,%eax
    3626:	f7 ea                	imul   %edx
    3628:	c1 fa 06             	sar    $0x6,%edx
    362b:	89 c8                	mov    %ecx,%eax
    362d:	c1 f8 1f             	sar    $0x1f,%eax
    3630:	89 d1                	mov    %edx,%ecx
    3632:	29 c1                	sub    %eax,%ecx
    3634:	89 c8                	mov    %ecx,%eax
    3636:	83 c0 30             	add    $0x30,%eax
    3639:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    363c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    363f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3644:	89 d8                	mov    %ebx,%eax
    3646:	f7 ea                	imul   %edx
    3648:	c1 fa 06             	sar    $0x6,%edx
    364b:	89 d8                	mov    %ebx,%eax
    364d:	c1 f8 1f             	sar    $0x1f,%eax
    3650:	89 d1                	mov    %edx,%ecx
    3652:	29 c1                	sub    %eax,%ecx
    3654:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    365a:	89 d9                	mov    %ebx,%ecx
    365c:	29 c1                	sub    %eax,%ecx
    365e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3663:	89 c8                	mov    %ecx,%eax
    3665:	f7 ea                	imul   %edx
    3667:	c1 fa 05             	sar    $0x5,%edx
    366a:	89 c8                	mov    %ecx,%eax
    366c:	c1 f8 1f             	sar    $0x1f,%eax
    366f:	89 d1                	mov    %edx,%ecx
    3671:	29 c1                	sub    %eax,%ecx
    3673:	89 c8                	mov    %ecx,%eax
    3675:	83 c0 30             	add    $0x30,%eax
    3678:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    367b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    367e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3683:	89 d8                	mov    %ebx,%eax
    3685:	f7 ea                	imul   %edx
    3687:	c1 fa 05             	sar    $0x5,%edx
    368a:	89 d8                	mov    %ebx,%eax
    368c:	c1 f8 1f             	sar    $0x1f,%eax
    368f:	89 d1                	mov    %edx,%ecx
    3691:	29 c1                	sub    %eax,%ecx
    3693:	6b c1 64             	imul   $0x64,%ecx,%eax
    3696:	89 d9                	mov    %ebx,%ecx
    3698:	29 c1                	sub    %eax,%ecx
    369a:	ba 67 66 66 66       	mov    $0x66666667,%edx
    369f:	89 c8                	mov    %ecx,%eax
    36a1:	f7 ea                	imul   %edx
    36a3:	c1 fa 02             	sar    $0x2,%edx
    36a6:	89 c8                	mov    %ecx,%eax
    36a8:	c1 f8 1f             	sar    $0x1f,%eax
    36ab:	89 d1                	mov    %edx,%ecx
    36ad:	29 c1                	sub    %eax,%ecx
    36af:	89 c8                	mov    %ecx,%eax
    36b1:	83 c0 30             	add    $0x30,%eax
    36b4:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    36b7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    36ba:	ba 67 66 66 66       	mov    $0x66666667,%edx
    36bf:	89 c8                	mov    %ecx,%eax
    36c1:	f7 ea                	imul   %edx
    36c3:	c1 fa 02             	sar    $0x2,%edx
    36c6:	89 c8                	mov    %ecx,%eax
    36c8:	c1 f8 1f             	sar    $0x1f,%eax
    36cb:	29 c2                	sub    %eax,%edx
    36cd:	89 d0                	mov    %edx,%eax
    36cf:	c1 e0 02             	shl    $0x2,%eax
    36d2:	01 d0                	add    %edx,%eax
    36d4:	01 c0                	add    %eax,%eax
    36d6:	89 ca                	mov    %ecx,%edx
    36d8:	29 c2                	sub    %eax,%edx
    36da:	89 d0                	mov    %edx,%eax
    36dc:	83 c0 30             	add    $0x30,%eax
    36df:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    36e2:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    36e6:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36e9:	89 44 24 08          	mov    %eax,0x8(%esp)
    36ed:	c7 44 24 04 c1 57 00 	movl   $0x57c1,0x4(%esp)
    36f4:	00 
    36f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36fc:	e8 bc 06 00 00       	call   3dbd <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3701:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3708:	00 
    3709:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    370c:	89 04 24             	mov    %eax,(%esp)
    370f:	e8 6c 05 00 00       	call   3c80 <open>
    3714:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3717:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    371b:	79 20                	jns    373d <fsfull+0x14e>
      printf(1, "open %s failed\n", name);
    371d:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3720:	89 44 24 08          	mov    %eax,0x8(%esp)
    3724:	c7 44 24 04 cd 57 00 	movl   $0x57cd,0x4(%esp)
    372b:	00 
    372c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3733:	e8 85 06 00 00       	call   3dbd <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3738:	e9 51 01 00 00       	jmp    388e <fsfull+0x29f>
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf(1, "open %s failed\n", name);
      break;
    }
    int total = 0;
    373d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    3744:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    374b:	00 
    374c:	c7 44 24 04 c0 86 00 	movl   $0x86c0,0x4(%esp)
    3753:	00 
    3754:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3757:	89 04 24             	mov    %eax,(%esp)
    375a:	e8 01 05 00 00       	call   3c60 <write>
    375f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3762:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3769:	7e 0c                	jle    3777 <fsfull+0x188>
        break;
      total += cc;
    376b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    376e:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3771:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3775:	eb cd                	jmp    3744 <fsfull+0x155>
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
    3777:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3778:	8b 45 ec             	mov    -0x14(%ebp),%eax
    377b:	89 44 24 08          	mov    %eax,0x8(%esp)
    377f:	c7 44 24 04 dd 57 00 	movl   $0x57dd,0x4(%esp)
    3786:	00 
    3787:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    378e:	e8 2a 06 00 00       	call   3dbd <printf>
    close(fd);
    3793:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3796:	89 04 24             	mov    %eax,(%esp)
    3799:	e8 ca 04 00 00       	call   3c68 <close>
    if(total == 0)
    379e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    37a2:	0f 84 e6 00 00 00    	je     388e <fsfull+0x29f>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    37a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    37ac:	e9 67 fe ff ff       	jmp    3618 <fsfull+0x29>

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    37b1:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    37b5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    37b8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    37bd:	89 c8                	mov    %ecx,%eax
    37bf:	f7 ea                	imul   %edx
    37c1:	c1 fa 06             	sar    $0x6,%edx
    37c4:	89 c8                	mov    %ecx,%eax
    37c6:	c1 f8 1f             	sar    $0x1f,%eax
    37c9:	89 d1                	mov    %edx,%ecx
    37cb:	29 c1                	sub    %eax,%ecx
    37cd:	89 c8                	mov    %ecx,%eax
    37cf:	83 c0 30             	add    $0x30,%eax
    37d2:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    37d5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    37d8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    37dd:	89 d8                	mov    %ebx,%eax
    37df:	f7 ea                	imul   %edx
    37e1:	c1 fa 06             	sar    $0x6,%edx
    37e4:	89 d8                	mov    %ebx,%eax
    37e6:	c1 f8 1f             	sar    $0x1f,%eax
    37e9:	89 d1                	mov    %edx,%ecx
    37eb:	29 c1                	sub    %eax,%ecx
    37ed:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    37f3:	89 d9                	mov    %ebx,%ecx
    37f5:	29 c1                	sub    %eax,%ecx
    37f7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    37fc:	89 c8                	mov    %ecx,%eax
    37fe:	f7 ea                	imul   %edx
    3800:	c1 fa 05             	sar    $0x5,%edx
    3803:	89 c8                	mov    %ecx,%eax
    3805:	c1 f8 1f             	sar    $0x1f,%eax
    3808:	89 d1                	mov    %edx,%ecx
    380a:	29 c1                	sub    %eax,%ecx
    380c:	89 c8                	mov    %ecx,%eax
    380e:	83 c0 30             	add    $0x30,%eax
    3811:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3814:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3817:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    381c:	89 d8                	mov    %ebx,%eax
    381e:	f7 ea                	imul   %edx
    3820:	c1 fa 05             	sar    $0x5,%edx
    3823:	89 d8                	mov    %ebx,%eax
    3825:	c1 f8 1f             	sar    $0x1f,%eax
    3828:	89 d1                	mov    %edx,%ecx
    382a:	29 c1                	sub    %eax,%ecx
    382c:	6b c1 64             	imul   $0x64,%ecx,%eax
    382f:	89 d9                	mov    %ebx,%ecx
    3831:	29 c1                	sub    %eax,%ecx
    3833:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3838:	89 c8                	mov    %ecx,%eax
    383a:	f7 ea                	imul   %edx
    383c:	c1 fa 02             	sar    $0x2,%edx
    383f:	89 c8                	mov    %ecx,%eax
    3841:	c1 f8 1f             	sar    $0x1f,%eax
    3844:	89 d1                	mov    %edx,%ecx
    3846:	29 c1                	sub    %eax,%ecx
    3848:	89 c8                	mov    %ecx,%eax
    384a:	83 c0 30             	add    $0x30,%eax
    384d:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3850:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3853:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3858:	89 c8                	mov    %ecx,%eax
    385a:	f7 ea                	imul   %edx
    385c:	c1 fa 02             	sar    $0x2,%edx
    385f:	89 c8                	mov    %ecx,%eax
    3861:	c1 f8 1f             	sar    $0x1f,%eax
    3864:	29 c2                	sub    %eax,%edx
    3866:	89 d0                	mov    %edx,%eax
    3868:	c1 e0 02             	shl    $0x2,%eax
    386b:	01 d0                	add    %edx,%eax
    386d:	01 c0                	add    %eax,%eax
    386f:	89 ca                	mov    %ecx,%edx
    3871:	29 c2                	sub    %eax,%edx
    3873:	89 d0                	mov    %edx,%eax
    3875:	83 c0 30             	add    $0x30,%eax
    3878:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    387b:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    387f:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3882:	89 04 24             	mov    %eax,(%esp)
    3885:	e8 06 04 00 00       	call   3c90 <unlink>
    nfiles--;
    388a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    388e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3892:	0f 89 19 ff ff ff    	jns    37b1 <fsfull+0x1c2>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3898:	c7 44 24 04 ed 57 00 	movl   $0x57ed,0x4(%esp)
    389f:	00 
    38a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38a7:	e8 11 05 00 00       	call   3dbd <printf>
}
    38ac:	83 c4 74             	add    $0x74,%esp
    38af:	5b                   	pop    %ebx
    38b0:	5d                   	pop    %ebp
    38b1:	c3                   	ret    

000038b2 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    38b2:	55                   	push   %ebp
    38b3:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    38b5:	a1 e8 5e 00 00       	mov    0x5ee8,%eax
    38ba:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    38c0:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    38c5:	a3 e8 5e 00 00       	mov    %eax,0x5ee8
  return randstate;
    38ca:	a1 e8 5e 00 00       	mov    0x5ee8,%eax
}
    38cf:	5d                   	pop    %ebp
    38d0:	c3                   	ret    

000038d1 <main>:

int
main(int argc, char *argv[])
{
    38d1:	55                   	push   %ebp
    38d2:	89 e5                	mov    %esp,%ebp
    38d4:	83 e4 f0             	and    $0xfffffff0,%esp
    38d7:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    38da:	c7 44 24 04 03 58 00 	movl   $0x5803,0x4(%esp)
    38e1:	00 
    38e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38e9:	e8 cf 04 00 00       	call   3dbd <printf>

  if(open("usertests.ran", 0) >= 0){
    38ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    38f5:	00 
    38f6:	c7 04 24 17 58 00 00 	movl   $0x5817,(%esp)
    38fd:	e8 7e 03 00 00       	call   3c80 <open>
    3902:	85 c0                	test   %eax,%eax
    3904:	78 19                	js     391f <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3906:	c7 44 24 04 28 58 00 	movl   $0x5828,0x4(%esp)
    390d:	00 
    390e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3915:	e8 a3 04 00 00       	call   3dbd <printf>
    exit();
    391a:	e8 21 03 00 00       	call   3c40 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    391f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3926:	00 
    3927:	c7 04 24 17 58 00 00 	movl   $0x5817,(%esp)
    392e:	e8 4d 03 00 00       	call   3c80 <open>
    3933:	89 04 24             	mov    %eax,(%esp)
    3936:	e8 2d 03 00 00       	call   3c68 <close>

  bigargtest();
    393b:	e8 86 fb ff ff       	call   34c6 <bigargtest>
  bigwrite();
    3940:	e8 ea ea ff ff       	call   242f <bigwrite>
  bigargtest();
    3945:	e8 7c fb ff ff       	call   34c6 <bigargtest>
  bsstest();
    394a:	e8 05 fb ff ff       	call   3454 <bsstest>
  sbrktest();
    394f:	e8 0f f5 ff ff       	call   2e63 <sbrktest>
  validatetest();
    3954:	e8 2e fa ff ff       	call   3387 <validatetest>

  opentest();
    3959:	e8 a2 c6 ff ff       	call   0 <opentest>
  writetest();
    395e:	e8 48 c7 ff ff       	call   ab <writetest>
  writetest1();
    3963:	e8 58 c9 ff ff       	call   2c0 <writetest1>
  createtest();
    3968:	e8 5c cb ff ff       	call   4c9 <createtest>

  mem();
    396d:	e8 fd d0 ff ff       	call   a6f <mem>
  pipe1();
    3972:	e8 33 cd ff ff       	call   6aa <pipe1>
  preempt();
    3977:	e8 1c cf ff ff       	call   898 <preempt>
  exitwait();
    397c:	e8 70 d0 ff ff       	call   9f1 <exitwait>

  rmdot();
    3981:	e8 2c ef ff ff       	call   28b2 <rmdot>
  fourteen();
    3986:	e8 d1 ed ff ff       	call   275c <fourteen>
  bigfile();
    398b:	e8 a7 eb ff ff       	call   2537 <bigfile>
  subdir();
    3990:	e8 54 e3 ff ff       	call   1ce9 <subdir>
  concreate();
    3995:	e8 ef dc ff ff       	call   1689 <concreate>
  linkunlink();
    399a:	e8 a3 e0 ff ff       	call   1a42 <linkunlink>
  linktest();
    399f:	e8 9c da ff ff       	call   1440 <linktest>
  unlinkread();
    39a4:	e8 c2 d8 ff ff       	call   126b <unlinkread>
  createdelete();
    39a9:	e8 0c d6 ff ff       	call   fba <createdelete>
  twofiles();
    39ae:	e8 9f d3 ff ff       	call   d52 <twofiles>
  sharedfd();
    39b3:	e8 9c d1 ff ff       	call   b54 <sharedfd>
  dirfile();
    39b8:	e8 6d f0 ff ff       	call   2a2a <dirfile>
  iref();
    39bd:	e8 aa f2 ff ff       	call   2c6c <iref>
  forktest();
    39c2:	e8 c9 f3 ff ff       	call   2d90 <forktest>
  bigdir(); // slow
    39c7:	e8 a4 e1 ff ff       	call   1b70 <bigdir>

  exectest();
    39cc:	e8 8a cc ff ff       	call   65b <exectest>

  exit();
    39d1:	e8 6a 02 00 00       	call   3c40 <exit>
    39d6:	90                   	nop
    39d7:	90                   	nop

000039d8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    39d8:	55                   	push   %ebp
    39d9:	89 e5                	mov    %esp,%ebp
    39db:	57                   	push   %edi
    39dc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    39dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
    39e0:	8b 55 10             	mov    0x10(%ebp),%edx
    39e3:	8b 45 0c             	mov    0xc(%ebp),%eax
    39e6:	89 cb                	mov    %ecx,%ebx
    39e8:	89 df                	mov    %ebx,%edi
    39ea:	89 d1                	mov    %edx,%ecx
    39ec:	fc                   	cld    
    39ed:	f3 aa                	rep stos %al,%es:(%edi)
    39ef:	89 ca                	mov    %ecx,%edx
    39f1:	89 fb                	mov    %edi,%ebx
    39f3:	89 5d 08             	mov    %ebx,0x8(%ebp)
    39f6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    39f9:	5b                   	pop    %ebx
    39fa:	5f                   	pop    %edi
    39fb:	5d                   	pop    %ebp
    39fc:	c3                   	ret    

000039fd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    39fd:	55                   	push   %ebp
    39fe:	89 e5                	mov    %esp,%ebp
    3a00:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3a03:	8b 45 08             	mov    0x8(%ebp),%eax
    3a06:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3a09:	90                   	nop
    3a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a0d:	0f b6 10             	movzbl (%eax),%edx
    3a10:	8b 45 08             	mov    0x8(%ebp),%eax
    3a13:	88 10                	mov    %dl,(%eax)
    3a15:	8b 45 08             	mov    0x8(%ebp),%eax
    3a18:	0f b6 00             	movzbl (%eax),%eax
    3a1b:	84 c0                	test   %al,%al
    3a1d:	0f 95 c0             	setne  %al
    3a20:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3a24:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    3a28:	84 c0                	test   %al,%al
    3a2a:	75 de                	jne    3a0a <strcpy+0xd>
    ;
  return os;
    3a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a2f:	c9                   	leave  
    3a30:	c3                   	ret    

00003a31 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3a31:	55                   	push   %ebp
    3a32:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3a34:	eb 08                	jmp    3a3e <strcmp+0xd>
    p++, q++;
    3a36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3a3a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3a3e:	8b 45 08             	mov    0x8(%ebp),%eax
    3a41:	0f b6 00             	movzbl (%eax),%eax
    3a44:	84 c0                	test   %al,%al
    3a46:	74 10                	je     3a58 <strcmp+0x27>
    3a48:	8b 45 08             	mov    0x8(%ebp),%eax
    3a4b:	0f b6 10             	movzbl (%eax),%edx
    3a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a51:	0f b6 00             	movzbl (%eax),%eax
    3a54:	38 c2                	cmp    %al,%dl
    3a56:	74 de                	je     3a36 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3a58:	8b 45 08             	mov    0x8(%ebp),%eax
    3a5b:	0f b6 00             	movzbl (%eax),%eax
    3a5e:	0f b6 d0             	movzbl %al,%edx
    3a61:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a64:	0f b6 00             	movzbl (%eax),%eax
    3a67:	0f b6 c0             	movzbl %al,%eax
    3a6a:	89 d1                	mov    %edx,%ecx
    3a6c:	29 c1                	sub    %eax,%ecx
    3a6e:	89 c8                	mov    %ecx,%eax
}
    3a70:	5d                   	pop    %ebp
    3a71:	c3                   	ret    

00003a72 <strlen>:

uint
strlen(char *s)
{
    3a72:	55                   	push   %ebp
    3a73:	89 e5                	mov    %esp,%ebp
    3a75:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3a78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3a7f:	eb 04                	jmp    3a85 <strlen+0x13>
    3a81:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3a85:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3a88:	8b 45 08             	mov    0x8(%ebp),%eax
    3a8b:	01 d0                	add    %edx,%eax
    3a8d:	0f b6 00             	movzbl (%eax),%eax
    3a90:	84 c0                	test   %al,%al
    3a92:	75 ed                	jne    3a81 <strlen+0xf>
    ;
  return n;
    3a94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a97:	c9                   	leave  
    3a98:	c3                   	ret    

00003a99 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3a99:	55                   	push   %ebp
    3a9a:	89 e5                	mov    %esp,%ebp
    3a9c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3a9f:	8b 45 10             	mov    0x10(%ebp),%eax
    3aa2:	89 44 24 08          	mov    %eax,0x8(%esp)
    3aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
    3aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
    3aad:	8b 45 08             	mov    0x8(%ebp),%eax
    3ab0:	89 04 24             	mov    %eax,(%esp)
    3ab3:	e8 20 ff ff ff       	call   39d8 <stosb>
  return dst;
    3ab8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3abb:	c9                   	leave  
    3abc:	c3                   	ret    

00003abd <strchr>:

char*
strchr(const char *s, char c)
{
    3abd:	55                   	push   %ebp
    3abe:	89 e5                	mov    %esp,%ebp
    3ac0:	83 ec 04             	sub    $0x4,%esp
    3ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ac6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3ac9:	eb 14                	jmp    3adf <strchr+0x22>
    if(*s == c)
    3acb:	8b 45 08             	mov    0x8(%ebp),%eax
    3ace:	0f b6 00             	movzbl (%eax),%eax
    3ad1:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3ad4:	75 05                	jne    3adb <strchr+0x1e>
      return (char*)s;
    3ad6:	8b 45 08             	mov    0x8(%ebp),%eax
    3ad9:	eb 13                	jmp    3aee <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3adb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3adf:	8b 45 08             	mov    0x8(%ebp),%eax
    3ae2:	0f b6 00             	movzbl (%eax),%eax
    3ae5:	84 c0                	test   %al,%al
    3ae7:	75 e2                	jne    3acb <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3aee:	c9                   	leave  
    3aef:	c3                   	ret    

00003af0 <gets>:

char*
gets(char *buf, int max)
{
    3af0:	55                   	push   %ebp
    3af1:	89 e5                	mov    %esp,%ebp
    3af3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3af6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3afd:	eb 46                	jmp    3b45 <gets+0x55>
    cc = read(0, &c, 1);
    3aff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3b06:	00 
    3b07:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3b0a:	89 44 24 04          	mov    %eax,0x4(%esp)
    3b0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3b15:	e8 3e 01 00 00       	call   3c58 <read>
    3b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3b1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3b21:	7e 2f                	jle    3b52 <gets+0x62>
      break;
    buf[i++] = c;
    3b23:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3b26:	8b 45 08             	mov    0x8(%ebp),%eax
    3b29:	01 c2                	add    %eax,%edx
    3b2b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b2f:	88 02                	mov    %al,(%edx)
    3b31:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
    3b35:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b39:	3c 0a                	cmp    $0xa,%al
    3b3b:	74 16                	je     3b53 <gets+0x63>
    3b3d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b41:	3c 0d                	cmp    $0xd,%al
    3b43:	74 0e                	je     3b53 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b48:	83 c0 01             	add    $0x1,%eax
    3b4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3b4e:	7c af                	jl     3aff <gets+0xf>
    3b50:	eb 01                	jmp    3b53 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3b52:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3b56:	8b 45 08             	mov    0x8(%ebp),%eax
    3b59:	01 d0                	add    %edx,%eax
    3b5b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3b5e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3b61:	c9                   	leave  
    3b62:	c3                   	ret    

00003b63 <stat>:

int
stat(char *n, struct stat *st)
{
    3b63:	55                   	push   %ebp
    3b64:	89 e5                	mov    %esp,%ebp
    3b66:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3b69:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b70:	00 
    3b71:	8b 45 08             	mov    0x8(%ebp),%eax
    3b74:	89 04 24             	mov    %eax,(%esp)
    3b77:	e8 04 01 00 00       	call   3c80 <open>
    3b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b83:	79 07                	jns    3b8c <stat+0x29>
    return -1;
    3b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3b8a:	eb 23                	jmp    3baf <stat+0x4c>
  r = fstat(fd, st);
    3b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
    3b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b96:	89 04 24             	mov    %eax,(%esp)
    3b99:	e8 fa 00 00 00       	call   3c98 <fstat>
    3b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ba4:	89 04 24             	mov    %eax,(%esp)
    3ba7:	e8 bc 00 00 00       	call   3c68 <close>
  return r;
    3bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3baf:	c9                   	leave  
    3bb0:	c3                   	ret    

00003bb1 <atoi>:

int
atoi(const char *s)
{
    3bb1:	55                   	push   %ebp
    3bb2:	89 e5                	mov    %esp,%ebp
    3bb4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3bb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3bbe:	eb 23                	jmp    3be3 <atoi+0x32>
    n = n*10 + *s++ - '0';
    3bc0:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3bc3:	89 d0                	mov    %edx,%eax
    3bc5:	c1 e0 02             	shl    $0x2,%eax
    3bc8:	01 d0                	add    %edx,%eax
    3bca:	01 c0                	add    %eax,%eax
    3bcc:	89 c2                	mov    %eax,%edx
    3bce:	8b 45 08             	mov    0x8(%ebp),%eax
    3bd1:	0f b6 00             	movzbl (%eax),%eax
    3bd4:	0f be c0             	movsbl %al,%eax
    3bd7:	01 d0                	add    %edx,%eax
    3bd9:	83 e8 30             	sub    $0x30,%eax
    3bdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3bdf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3be3:	8b 45 08             	mov    0x8(%ebp),%eax
    3be6:	0f b6 00             	movzbl (%eax),%eax
    3be9:	3c 2f                	cmp    $0x2f,%al
    3beb:	7e 0a                	jle    3bf7 <atoi+0x46>
    3bed:	8b 45 08             	mov    0x8(%ebp),%eax
    3bf0:	0f b6 00             	movzbl (%eax),%eax
    3bf3:	3c 39                	cmp    $0x39,%al
    3bf5:	7e c9                	jle    3bc0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3bfa:	c9                   	leave  
    3bfb:	c3                   	ret    

00003bfc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3bfc:	55                   	push   %ebp
    3bfd:	89 e5                	mov    %esp,%ebp
    3bff:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3c02:	8b 45 08             	mov    0x8(%ebp),%eax
    3c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3c08:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3c0e:	eb 13                	jmp    3c23 <memmove+0x27>
    *dst++ = *src++;
    3c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3c13:	0f b6 10             	movzbl (%eax),%edx
    3c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3c19:	88 10                	mov    %dl,(%eax)
    3c1b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3c1f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3c23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3c27:	0f 9f c0             	setg   %al
    3c2a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    3c2e:	84 c0                	test   %al,%al
    3c30:	75 de                	jne    3c10 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3c32:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3c35:	c9                   	leave  
    3c36:	c3                   	ret    
    3c37:	90                   	nop

00003c38 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3c38:	b8 01 00 00 00       	mov    $0x1,%eax
    3c3d:	cd 40                	int    $0x40
    3c3f:	c3                   	ret    

00003c40 <exit>:
SYSCALL(exit)
    3c40:	b8 02 00 00 00       	mov    $0x2,%eax
    3c45:	cd 40                	int    $0x40
    3c47:	c3                   	ret    

00003c48 <wait>:
SYSCALL(wait)
    3c48:	b8 03 00 00 00       	mov    $0x3,%eax
    3c4d:	cd 40                	int    $0x40
    3c4f:	c3                   	ret    

00003c50 <pipe>:
SYSCALL(pipe)
    3c50:	b8 04 00 00 00       	mov    $0x4,%eax
    3c55:	cd 40                	int    $0x40
    3c57:	c3                   	ret    

00003c58 <read>:
SYSCALL(read)
    3c58:	b8 05 00 00 00       	mov    $0x5,%eax
    3c5d:	cd 40                	int    $0x40
    3c5f:	c3                   	ret    

00003c60 <write>:
SYSCALL(write)
    3c60:	b8 10 00 00 00       	mov    $0x10,%eax
    3c65:	cd 40                	int    $0x40
    3c67:	c3                   	ret    

00003c68 <close>:
SYSCALL(close)
    3c68:	b8 15 00 00 00       	mov    $0x15,%eax
    3c6d:	cd 40                	int    $0x40
    3c6f:	c3                   	ret    

00003c70 <kill>:
SYSCALL(kill)
    3c70:	b8 06 00 00 00       	mov    $0x6,%eax
    3c75:	cd 40                	int    $0x40
    3c77:	c3                   	ret    

00003c78 <exec>:
SYSCALL(exec)
    3c78:	b8 07 00 00 00       	mov    $0x7,%eax
    3c7d:	cd 40                	int    $0x40
    3c7f:	c3                   	ret    

00003c80 <open>:
SYSCALL(open)
    3c80:	b8 0f 00 00 00       	mov    $0xf,%eax
    3c85:	cd 40                	int    $0x40
    3c87:	c3                   	ret    

00003c88 <mknod>:
SYSCALL(mknod)
    3c88:	b8 11 00 00 00       	mov    $0x11,%eax
    3c8d:	cd 40                	int    $0x40
    3c8f:	c3                   	ret    

00003c90 <unlink>:
SYSCALL(unlink)
    3c90:	b8 12 00 00 00       	mov    $0x12,%eax
    3c95:	cd 40                	int    $0x40
    3c97:	c3                   	ret    

00003c98 <fstat>:
SYSCALL(fstat)
    3c98:	b8 08 00 00 00       	mov    $0x8,%eax
    3c9d:	cd 40                	int    $0x40
    3c9f:	c3                   	ret    

00003ca0 <link>:
SYSCALL(link)
    3ca0:	b8 13 00 00 00       	mov    $0x13,%eax
    3ca5:	cd 40                	int    $0x40
    3ca7:	c3                   	ret    

00003ca8 <mkdir>:
SYSCALL(mkdir)
    3ca8:	b8 14 00 00 00       	mov    $0x14,%eax
    3cad:	cd 40                	int    $0x40
    3caf:	c3                   	ret    

00003cb0 <chdir>:
SYSCALL(chdir)
    3cb0:	b8 09 00 00 00       	mov    $0x9,%eax
    3cb5:	cd 40                	int    $0x40
    3cb7:	c3                   	ret    

00003cb8 <dup>:
SYSCALL(dup)
    3cb8:	b8 0a 00 00 00       	mov    $0xa,%eax
    3cbd:	cd 40                	int    $0x40
    3cbf:	c3                   	ret    

00003cc0 <getpid>:
SYSCALL(getpid)
    3cc0:	b8 0b 00 00 00       	mov    $0xb,%eax
    3cc5:	cd 40                	int    $0x40
    3cc7:	c3                   	ret    

00003cc8 <sbrk>:
SYSCALL(sbrk)
    3cc8:	b8 0c 00 00 00       	mov    $0xc,%eax
    3ccd:	cd 40                	int    $0x40
    3ccf:	c3                   	ret    

00003cd0 <sleep>:
SYSCALL(sleep)
    3cd0:	b8 0d 00 00 00       	mov    $0xd,%eax
    3cd5:	cd 40                	int    $0x40
    3cd7:	c3                   	ret    

00003cd8 <uptime>:
SYSCALL(uptime)
    3cd8:	b8 0e 00 00 00       	mov    $0xe,%eax
    3cdd:	cd 40                	int    $0x40
    3cdf:	c3                   	ret    

00003ce0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3ce0:	55                   	push   %ebp
    3ce1:	89 e5                	mov    %esp,%ebp
    3ce3:	83 ec 28             	sub    $0x28,%esp
    3ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ce9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3cec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3cf3:	00 
    3cf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
    3cfb:	8b 45 08             	mov    0x8(%ebp),%eax
    3cfe:	89 04 24             	mov    %eax,(%esp)
    3d01:	e8 5a ff ff ff       	call   3c60 <write>
}
    3d06:	c9                   	leave  
    3d07:	c3                   	ret    

00003d08 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3d08:	55                   	push   %ebp
    3d09:	89 e5                	mov    %esp,%ebp
    3d0b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3d0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3d15:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3d19:	74 17                	je     3d32 <printint+0x2a>
    3d1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3d1f:	79 11                	jns    3d32 <printint+0x2a>
    neg = 1;
    3d21:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3d28:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d2b:	f7 d8                	neg    %eax
    3d2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3d30:	eb 06                	jmp    3d38 <printint+0x30>
  } else {
    x = xx;
    3d32:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3d38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3d3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d45:	ba 00 00 00 00       	mov    $0x0,%edx
    3d4a:	f7 f1                	div    %ecx
    3d4c:	89 d0                	mov    %edx,%eax
    3d4e:	0f b6 80 ec 5e 00 00 	movzbl 0x5eec(%eax),%eax
    3d55:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    3d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3d5b:	01 ca                	add    %ecx,%edx
    3d5d:	88 02                	mov    %al,(%edx)
    3d5f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
    3d63:	8b 55 10             	mov    0x10(%ebp),%edx
    3d66:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    3d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d6c:	ba 00 00 00 00       	mov    $0x0,%edx
    3d71:	f7 75 d4             	divl   -0x2c(%ebp)
    3d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3d77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3d7b:	75 c2                	jne    3d3f <printint+0x37>
  if(neg)
    3d7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d81:	74 2e                	je     3db1 <printint+0xa9>
    buf[i++] = '-';
    3d83:	8d 55 dc             	lea    -0x24(%ebp),%edx
    3d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d89:	01 d0                	add    %edx,%eax
    3d8b:	c6 00 2d             	movb   $0x2d,(%eax)
    3d8e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
    3d92:	eb 1d                	jmp    3db1 <printint+0xa9>
    putc(fd, buf[i]);
    3d94:	8d 55 dc             	lea    -0x24(%ebp),%edx
    3d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d9a:	01 d0                	add    %edx,%eax
    3d9c:	0f b6 00             	movzbl (%eax),%eax
    3d9f:	0f be c0             	movsbl %al,%eax
    3da2:	89 44 24 04          	mov    %eax,0x4(%esp)
    3da6:	8b 45 08             	mov    0x8(%ebp),%eax
    3da9:	89 04 24             	mov    %eax,(%esp)
    3dac:	e8 2f ff ff ff       	call   3ce0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3db1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    3db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3db9:	79 d9                	jns    3d94 <printint+0x8c>
    putc(fd, buf[i]);
}
    3dbb:	c9                   	leave  
    3dbc:	c3                   	ret    

00003dbd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3dbd:	55                   	push   %ebp
    3dbe:	89 e5                	mov    %esp,%ebp
    3dc0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    3dc3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    3dca:	8d 45 0c             	lea    0xc(%ebp),%eax
    3dcd:	83 c0 04             	add    $0x4,%eax
    3dd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    3dd3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3dda:	e9 7d 01 00 00       	jmp    3f5c <printf+0x19f>
    c = fmt[i] & 0xff;
    3ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
    3de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3de5:	01 d0                	add    %edx,%eax
    3de7:	0f b6 00             	movzbl (%eax),%eax
    3dea:	0f be c0             	movsbl %al,%eax
    3ded:	25 ff 00 00 00       	and    $0xff,%eax
    3df2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    3df5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3df9:	75 2c                	jne    3e27 <printf+0x6a>
      if(c == '%'){
    3dfb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3dff:	75 0c                	jne    3e0d <printf+0x50>
        state = '%';
    3e01:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    3e08:	e9 4b 01 00 00       	jmp    3f58 <printf+0x19b>
      } else {
        putc(fd, c);
    3e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e10:	0f be c0             	movsbl %al,%eax
    3e13:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e17:	8b 45 08             	mov    0x8(%ebp),%eax
    3e1a:	89 04 24             	mov    %eax,(%esp)
    3e1d:	e8 be fe ff ff       	call   3ce0 <putc>
    3e22:	e9 31 01 00 00       	jmp    3f58 <printf+0x19b>
      }
    } else if(state == '%'){
    3e27:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    3e2b:	0f 85 27 01 00 00    	jne    3f58 <printf+0x19b>
      if(c == 'd'){
    3e31:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    3e35:	75 2d                	jne    3e64 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    3e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e3a:	8b 00                	mov    (%eax),%eax
    3e3c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    3e43:	00 
    3e44:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    3e4b:	00 
    3e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e50:	8b 45 08             	mov    0x8(%ebp),%eax
    3e53:	89 04 24             	mov    %eax,(%esp)
    3e56:	e8 ad fe ff ff       	call   3d08 <printint>
        ap++;
    3e5b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3e5f:	e9 ed 00 00 00       	jmp    3f51 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    3e64:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    3e68:	74 06                	je     3e70 <printf+0xb3>
    3e6a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    3e6e:	75 2d                	jne    3e9d <printf+0xe0>
        printint(fd, *ap, 16, 0);
    3e70:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e73:	8b 00                	mov    (%eax),%eax
    3e75:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    3e7c:	00 
    3e7d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    3e84:	00 
    3e85:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e89:	8b 45 08             	mov    0x8(%ebp),%eax
    3e8c:	89 04 24             	mov    %eax,(%esp)
    3e8f:	e8 74 fe ff ff       	call   3d08 <printint>
        ap++;
    3e94:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3e98:	e9 b4 00 00 00       	jmp    3f51 <printf+0x194>
      } else if(c == 's'){
    3e9d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    3ea1:	75 46                	jne    3ee9 <printf+0x12c>
        s = (char*)*ap;
    3ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3ea6:	8b 00                	mov    (%eax),%eax
    3ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    3eab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    3eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3eb3:	75 27                	jne    3edc <printf+0x11f>
          s = "(null)";
    3eb5:	c7 45 f4 52 58 00 00 	movl   $0x5852,-0xc(%ebp)
        while(*s != 0){
    3ebc:	eb 1e                	jmp    3edc <printf+0x11f>
          putc(fd, *s);
    3ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ec1:	0f b6 00             	movzbl (%eax),%eax
    3ec4:	0f be c0             	movsbl %al,%eax
    3ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ecb:	8b 45 08             	mov    0x8(%ebp),%eax
    3ece:	89 04 24             	mov    %eax,(%esp)
    3ed1:	e8 0a fe ff ff       	call   3ce0 <putc>
          s++;
    3ed6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3eda:	eb 01                	jmp    3edd <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3edc:	90                   	nop
    3edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ee0:	0f b6 00             	movzbl (%eax),%eax
    3ee3:	84 c0                	test   %al,%al
    3ee5:	75 d7                	jne    3ebe <printf+0x101>
    3ee7:	eb 68                	jmp    3f51 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3ee9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    3eed:	75 1d                	jne    3f0c <printf+0x14f>
        putc(fd, *ap);
    3eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3ef2:	8b 00                	mov    (%eax),%eax
    3ef4:	0f be c0             	movsbl %al,%eax
    3ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
    3efb:	8b 45 08             	mov    0x8(%ebp),%eax
    3efe:	89 04 24             	mov    %eax,(%esp)
    3f01:	e8 da fd ff ff       	call   3ce0 <putc>
        ap++;
    3f06:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3f0a:	eb 45                	jmp    3f51 <printf+0x194>
      } else if(c == '%'){
    3f0c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3f10:	75 17                	jne    3f29 <printf+0x16c>
        putc(fd, c);
    3f12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3f15:	0f be c0             	movsbl %al,%eax
    3f18:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f1c:	8b 45 08             	mov    0x8(%ebp),%eax
    3f1f:	89 04 24             	mov    %eax,(%esp)
    3f22:	e8 b9 fd ff ff       	call   3ce0 <putc>
    3f27:	eb 28                	jmp    3f51 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    3f29:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    3f30:	00 
    3f31:	8b 45 08             	mov    0x8(%ebp),%eax
    3f34:	89 04 24             	mov    %eax,(%esp)
    3f37:	e8 a4 fd ff ff       	call   3ce0 <putc>
        putc(fd, c);
    3f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3f3f:	0f be c0             	movsbl %al,%eax
    3f42:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f46:	8b 45 08             	mov    0x8(%ebp),%eax
    3f49:	89 04 24             	mov    %eax,(%esp)
    3f4c:	e8 8f fd ff ff       	call   3ce0 <putc>
      }
      state = 0;
    3f51:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3f58:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
    3f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3f62:	01 d0                	add    %edx,%eax
    3f64:	0f b6 00             	movzbl (%eax),%eax
    3f67:	84 c0                	test   %al,%al
    3f69:	0f 85 70 fe ff ff    	jne    3ddf <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    3f6f:	c9                   	leave  
    3f70:	c3                   	ret    
    3f71:	90                   	nop
    3f72:	90                   	nop
    3f73:	90                   	nop

00003f74 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3f74:	55                   	push   %ebp
    3f75:	89 e5                	mov    %esp,%ebp
    3f77:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3f7a:	8b 45 08             	mov    0x8(%ebp),%eax
    3f7d:	83 e8 08             	sub    $0x8,%eax
    3f80:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3f83:	a1 88 5f 00 00       	mov    0x5f88,%eax
    3f88:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f8b:	eb 24                	jmp    3fb1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f90:	8b 00                	mov    (%eax),%eax
    3f92:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f95:	77 12                	ja     3fa9 <free+0x35>
    3f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f9a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f9d:	77 24                	ja     3fc3 <free+0x4f>
    3f9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fa2:	8b 00                	mov    (%eax),%eax
    3fa4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3fa7:	77 1a                	ja     3fc3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fac:	8b 00                	mov    (%eax),%eax
    3fae:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3fb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fb4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3fb7:	76 d4                	jbe    3f8d <free+0x19>
    3fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fbc:	8b 00                	mov    (%eax),%eax
    3fbe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3fc1:	76 ca                	jbe    3f8d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    3fc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fc6:	8b 40 04             	mov    0x4(%eax),%eax
    3fc9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    3fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fd3:	01 c2                	add    %eax,%edx
    3fd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fd8:	8b 00                	mov    (%eax),%eax
    3fda:	39 c2                	cmp    %eax,%edx
    3fdc:	75 24                	jne    4002 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    3fde:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fe1:	8b 50 04             	mov    0x4(%eax),%edx
    3fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fe7:	8b 00                	mov    (%eax),%eax
    3fe9:	8b 40 04             	mov    0x4(%eax),%eax
    3fec:	01 c2                	add    %eax,%edx
    3fee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3ff1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    3ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ff7:	8b 00                	mov    (%eax),%eax
    3ff9:	8b 10                	mov    (%eax),%edx
    3ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3ffe:	89 10                	mov    %edx,(%eax)
    4000:	eb 0a                	jmp    400c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    4002:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4005:	8b 10                	mov    (%eax),%edx
    4007:	8b 45 f8             	mov    -0x8(%ebp),%eax
    400a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    400c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    400f:	8b 40 04             	mov    0x4(%eax),%eax
    4012:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4019:	8b 45 fc             	mov    -0x4(%ebp),%eax
    401c:	01 d0                	add    %edx,%eax
    401e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4021:	75 20                	jne    4043 <free+0xcf>
    p->s.size += bp->s.size;
    4023:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4026:	8b 50 04             	mov    0x4(%eax),%edx
    4029:	8b 45 f8             	mov    -0x8(%ebp),%eax
    402c:	8b 40 04             	mov    0x4(%eax),%eax
    402f:	01 c2                	add    %eax,%edx
    4031:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4034:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4037:	8b 45 f8             	mov    -0x8(%ebp),%eax
    403a:	8b 10                	mov    (%eax),%edx
    403c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    403f:	89 10                	mov    %edx,(%eax)
    4041:	eb 08                	jmp    404b <free+0xd7>
  } else
    p->s.ptr = bp;
    4043:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4046:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4049:	89 10                	mov    %edx,(%eax)
  freep = p;
    404b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    404e:	a3 88 5f 00 00       	mov    %eax,0x5f88
}
    4053:	c9                   	leave  
    4054:	c3                   	ret    

00004055 <morecore>:

static Header*
morecore(uint nu)
{
    4055:	55                   	push   %ebp
    4056:	89 e5                	mov    %esp,%ebp
    4058:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    405b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4062:	77 07                	ja     406b <morecore+0x16>
    nu = 4096;
    4064:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    406b:	8b 45 08             	mov    0x8(%ebp),%eax
    406e:	c1 e0 03             	shl    $0x3,%eax
    4071:	89 04 24             	mov    %eax,(%esp)
    4074:	e8 4f fc ff ff       	call   3cc8 <sbrk>
    4079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    407c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4080:	75 07                	jne    4089 <morecore+0x34>
    return 0;
    4082:	b8 00 00 00 00       	mov    $0x0,%eax
    4087:	eb 22                	jmp    40ab <morecore+0x56>
  hp = (Header*)p;
    4089:	8b 45 f4             	mov    -0xc(%ebp),%eax
    408c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    408f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4092:	8b 55 08             	mov    0x8(%ebp),%edx
    4095:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4098:	8b 45 f0             	mov    -0x10(%ebp),%eax
    409b:	83 c0 08             	add    $0x8,%eax
    409e:	89 04 24             	mov    %eax,(%esp)
    40a1:	e8 ce fe ff ff       	call   3f74 <free>
  return freep;
    40a6:	a1 88 5f 00 00       	mov    0x5f88,%eax
}
    40ab:	c9                   	leave  
    40ac:	c3                   	ret    

000040ad <malloc>:

void*
malloc(uint nbytes)
{
    40ad:	55                   	push   %ebp
    40ae:	89 e5                	mov    %esp,%ebp
    40b0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    40b3:	8b 45 08             	mov    0x8(%ebp),%eax
    40b6:	83 c0 07             	add    $0x7,%eax
    40b9:	c1 e8 03             	shr    $0x3,%eax
    40bc:	83 c0 01             	add    $0x1,%eax
    40bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    40c2:	a1 88 5f 00 00       	mov    0x5f88,%eax
    40c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    40ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    40ce:	75 23                	jne    40f3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    40d0:	c7 45 f0 80 5f 00 00 	movl   $0x5f80,-0x10(%ebp)
    40d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40da:	a3 88 5f 00 00       	mov    %eax,0x5f88
    40df:	a1 88 5f 00 00       	mov    0x5f88,%eax
    40e4:	a3 80 5f 00 00       	mov    %eax,0x5f80
    base.s.size = 0;
    40e9:	c7 05 84 5f 00 00 00 	movl   $0x0,0x5f84
    40f0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    40f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40f6:	8b 00                	mov    (%eax),%eax
    40f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    40fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40fe:	8b 40 04             	mov    0x4(%eax),%eax
    4101:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4104:	72 4d                	jb     4153 <malloc+0xa6>
      if(p->s.size == nunits)
    4106:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4109:	8b 40 04             	mov    0x4(%eax),%eax
    410c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    410f:	75 0c                	jne    411d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    4111:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4114:	8b 10                	mov    (%eax),%edx
    4116:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4119:	89 10                	mov    %edx,(%eax)
    411b:	eb 26                	jmp    4143 <malloc+0x96>
      else {
        p->s.size -= nunits;
    411d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4120:	8b 40 04             	mov    0x4(%eax),%eax
    4123:	89 c2                	mov    %eax,%edx
    4125:	2b 55 ec             	sub    -0x14(%ebp),%edx
    4128:	8b 45 f4             	mov    -0xc(%ebp),%eax
    412b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    412e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4131:	8b 40 04             	mov    0x4(%eax),%eax
    4134:	c1 e0 03             	shl    $0x3,%eax
    4137:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    413a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    413d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    4140:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    4143:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4146:	a3 88 5f 00 00       	mov    %eax,0x5f88
      return (void*)(p + 1);
    414b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    414e:	83 c0 08             	add    $0x8,%eax
    4151:	eb 38                	jmp    418b <malloc+0xde>
    }
    if(p == freep)
    4153:	a1 88 5f 00 00       	mov    0x5f88,%eax
    4158:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    415b:	75 1b                	jne    4178 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    415d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4160:	89 04 24             	mov    %eax,(%esp)
    4163:	e8 ed fe ff ff       	call   4055 <morecore>
    4168:	89 45 f4             	mov    %eax,-0xc(%ebp)
    416b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    416f:	75 07                	jne    4178 <malloc+0xcb>
        return 0;
    4171:	b8 00 00 00 00       	mov    $0x0,%eax
    4176:	eb 13                	jmp    418b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4178:	8b 45 f4             	mov    -0xc(%ebp),%eax
    417b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4181:	8b 00                	mov    (%eax),%eax
    4183:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4186:	e9 70 ff ff ff       	jmp    40fb <malloc+0x4e>
}
    418b:	c9                   	leave  
    418c:	c3                   	ret    
