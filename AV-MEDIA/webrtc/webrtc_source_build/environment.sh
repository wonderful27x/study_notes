#!/bin/bash

#============代理proxy===================
#export HTTP_PROXY=http://127.0.0.1:1080
#export HTTPS_PROXY=https://127.0.0.1:1080
#export HTTP_PROXY=socks5://127.0.0.1:1080
#export HTTPS_PROXY=socks5://127.0.0.1:1080
#export HTTP_PROXY=socks5h://127.0.0.1:1080
#export HTTPS_PROXY=socks5h://127.0.0.1:1080
#export HTTP_PROXY=socks5h://localhost:1080
#export HTTPS_PROXY=socks5h://localhost:1080
#export http_proxy='socks5://127.0.0.1:1080'
#export https_proxy='socks5://127.0.0.1:1080'
#export socks5_proxy='socks5://127.0.0.1:1080'
export http_proxy=http://127.0.0.1:1080
export https_proxy=https://127.0.0.1:1080
export all_proxy=socks5://127.0.0.1:1080


#===========git proxy================================
#git config --global http.proxy 'http://127.0.0.1:1080'
#git config --global https.proxy 'https://127.0.0.1:1080'
git config --global http.proxy 'socks5://127.0.0.1:1080'
git config --global https.proxy 'socks5://127.0.0.1:1080'


#===========ignore git ssl===============
#export GIT_SSL_NO_VERIFY=true
#git config --global http.sslVerify false

#==========enable git ssl===============
git config --global http.sslVerify true


#==========disable depot_tools_update,depot_tools proxy config==========
export DEPOT_TOOLS_UPDATE=0
export NO_AUTH_BOTO_CONFIG=/home/wonderful/wonderful/tools/depot_tools/http_proxy.boto


#=============show env================
env

