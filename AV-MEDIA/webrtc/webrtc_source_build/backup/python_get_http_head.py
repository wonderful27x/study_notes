#!/usr/bin/env python3


import sys
import os
import time
assert sys.version_info >= (3, 0), 'This script requires Python 3.'

import subprocess


def main():
  t = time.time()
  st = str(int(round(t*1000000)))
  filename = st + '.stat'
  url = 'https://storage.googleapis.com/chromium-clang-format/904e70f14e6e2681c58ca944659afe1c482fa9a9'
  cmd = ['curl','-x','socks5h://127.0.0.1:1080','-I', url,'-o',filename]
  print('run subprocess.check_call(' + str(cmd) + ')')
  subprocess.check_call(cmd)
  with open(filename,"r") as f:
      out = f.read()
  print('out: ' + str(out))
  os.remove(filename)
  return 0


if __name__ == '__main__':
  sys.exit(main())
