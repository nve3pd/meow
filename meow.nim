import os
import posix

proc perror(s: cstring) {.header: "<stdio.h>", importc: "perror".}


proc die(s: cstring): int {.discardable.} =
  perror(s)
  quit(1)


proc do_cat(path: cstring): int {.discardable.} =
  var 
    fd: cint
    n: int
    buf: ptr cstring

  fd = posix.open(path, O_RDONLY)
  if fd < 0:
    die(path)

  while true:
    n = posix.read(fd, buf.addr(), sizeof(buf))
    if n < 0: die(path)
    if n == 0: break
    if posix.write(STDOUT_FILENO, buf.addr(), n) < 0:
      die(path)

  if posix.close(fd) < 0:
    die(path)


proc main(): int =
  if os.paramCount() < 1:
    quit(1)
    
  for i in countup(1, os.paramCount()):
    do_cat(commandLineParams()[i - 1])


if isMainModule:
  discard main()
