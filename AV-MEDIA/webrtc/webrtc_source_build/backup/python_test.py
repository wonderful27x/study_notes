#!/usr/bin/env python3


import sys
assert sys.version_info >= (3, 0), 'This script requires Python 3.'

import subprocess


def main():
  cmd = ['vpython3', '/home/wonderful/wonderful/media/webrtc/webrtc_source/src/third_party/depot_tools/gsutil.py', 'ls', 'gs://chromium-clang-format/904e70f14e6e2681c58ca944659afe1c482fa9a9']
  print('python ls test...')
  print('run subprocess.check_call(' + str(cmd) + ')')
  subprocess.check_call(cmd)
  return 0


if __name__ == '__main__':
  sys.exit(main())
