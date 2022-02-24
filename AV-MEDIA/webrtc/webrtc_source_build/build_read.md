webrtc源码编译最难的是下载，下载不仅包括源码的下载，还包括各种库的下载,以及与系统匹配的依赖的下载  
如果下载有环节出了问题通常编译也会出各种问题，下载全部完成，编译也就水到渠成了  
下载通常需要科学上网，我使用的是shadowsocks,接下来需要设置各种应用的代理让其能访问外网  
剩下的流程按照官方流程就行：  
https://webrtc.googlesource.com/src/+/main/docs/native-code/development/index.md  
fetch 是下载源码  
gclient sync 通常就是下载与当前分支匹配的各种依赖环境，是编译成功的关键，所以切换分支后需要gclient sync  

一、设置代理  
#===============不同应用支持的代理不同============================  
#比如有的代理是socks5,有的代理又是http,所以不能设置为全局统一的  

#==============不同应用设置代理的方式不同========================  
#比如git可以通过命令参数--global或配置文件设置git全局的代理  
#然而curl只能通过配置文件或者在每次运行时使用-x参数  
#配置文件方式设置代理并不友好，能通过命令设置一次使代理对于某一应用单独起作用是最佳的选择，
#比如下面git的设置，而像curl这类应用却没有这种设置，因此不同应用代理的设置方式会不一样，增加麻烦  
#特别注意!!!:  
#如果是基于~/.xxxrc配置文件方式的代理设置对于sudo的命令是不起作用的，对使用sudo的我们必须手动修改其脚本设置代理，比如python脚本中的curl需要我们自行添加-x设置代理  

1.设置curl代理(方式：配置文件,用完后应当恢复)(对sudo无效)  
vim ~/.curlrc
proxy = "socks5h://127.0.0.1:1080"  

2.设置wget代理,参考/etc/wgetrc(方式：配置文件,用完后应当恢复)(对sudo无效)  
vim ~/.wgetrc
#You can set the default proxies for Wget to use for http, https, and ftp.  
#They will override the value in the environment.  
#https_proxy = http://proxy.yoyodyne.com:18023/  
#http_proxy = http://proxy.yoyodyne.com:18023/  
#ftp_proxy = http://proxy.yoyodyne.com:18023/  
https_proxy = http://127.0.0.1:1080/  
http_proxy = http://127.0.0.1:1080/  
ftp_proxy = http://127.0.0.1:1080/  
#If you do not want to use proxy at all, set this to off.  
#use_proxy = on  
use_proxy = on  

3.设置git代理(方式：命令)  
git config --global http.proxy 'socks5://127.0.0.1:1080'  
git config --global https.proxy 'socks5://127.0.0.1:1080'  

4.设置当前shell代理(方式：命令),测试发现对python无效  
export http_proxy='http://127.0.0.1:1080'  
export https_proxy='https://127.0.0.1:1080'  
export socks5_proxy='socks5://127.0.0.1:1080'  

5.设置系统代理，这样其他应用如python就可以正常访问外网(方式：配置文件,用完后应当恢复)  
(这似乎仍然有问题，不用担心，车道山钱币右路，往下看!!!)
vim /etc/environmen  
export http_proxy='http://127.0.0.1:1080'  
export https_proxy='https://127.0.0.1:1080'  
export socks5_proxy='socks5://127.0.0.1:1080'  

6.设置depot_tools环境变量  
#禁止更新  
export DEPOT_TOOLS_UPDATE=0  
#设置代理  
#在depot_tools下新建文件http_proxy.boto  
#然后输入:  
 	[Boto]  
 	proxy = 127.0.0.1  
 	proxy_port = 1080  
#设置环境变量NO_AUTH_BOTO_CONFIG指向此文件  
export NO_AUTH_BOTO_CONFIG=/home/wonderful/wonderful/tools/depot_tools/http_proxy.boto  

7.实际应用中如果发现还有无法下载的情况，首先应当复制连接在浏览器下载，确定没问题再根据输出信息查找问题，  
通常需要分析文件下载脚本如python脚本.确定问题后通常有两种解决方法，一是通过手动修复脚本重新运行脚步，  
值得注意的是gclient sync命令通常会同步脚步，当我们修改脚步文件再gclient sync时修改的脚步又被恢复了，  
为了解决这个问题，我们可以直接运行修改的脚本，然后再gclient snyc;第二种解决办法就是从浏览器下载文件复制到指定目录  
!!!在遇到问题时grep命名将会对你有很大的帮助  

二.下载源码(官方流程)  
https://webrtc.googlesource.com/src/+/main/docs/native-code/development/index.md  
1.运行./build/install-build-deps.sh 提示系统版本太高: ERROR: The only supported distros are...  
	只支持Ubuntu 14.04 LTS - Ubuntu 20.10，修改install-build-deps.sh脚本，  
	找到ERROR: The only supported distros are错误的地方，直接将exit 1注释掉  
	注意不兼容的可以有可能造成错误  
	注意这些库是通过apt安装的，因此最好先取消所有代理

2.gclient sync 卡在 install-sysroot.py
	1).修改python脚本，使用curl代替urllib下载，具体参考back/install-sysroot.py
 	2).直接运行脚本(根据错误提示,有详细的命令)	
	3).git restore install-sysroot.py 命令恢复文件
	4).重新运行gclient sync

3.gclient sync 卡在 download_from_google_storage.py
	1).修改python脚本，使用curl代替urllib下载，具体参考back/download_from_google_storage.py
 	2).直接运行脚本(根据错误提示,有详细的命令)	
	   如:python3 src/third_party/depot_tools/download_from_google_storage.py download_from_google_storage --directory --recursive --num_threads=10 --no_auth --quiet --bucket chromium-webrtc-resources src/resources
	3).git restore download_from_google_storage.py 命令恢复文件
	4).重新运行gclient sync
	5).再次卡在gclient sync，根据错误提示重复上面的步骤
	
4.gclient sync 过程中发现最后卡在 generate_location_tags.py 
	将/etc/environment 添加的代理去掉，然后shell命令行添加  
	export HTTP_PROXY=socks5://127.0.0.1:1080  
	export HTTPS_PROXY=socks5://127.0.0.1:1080  
	根据错误提示直接运行脚步
	如: vpython3 src/testing/generate_location_tags.py --out src/testing/location_tags.json  
	再次运行gclient sync...
	祝你好运！
	
	

三.编译(官方流程)  
https://webrtc.googlesource.com/src/+/main/docs/native-code/development/index.md  
1.编译,webrtc使用ninja编  
	和cmake处理CMakeLists生成Makefile,然后make通过Makefile编译类似  
	gn处理.gn文件生成.ninja文件  
	ninja通过.ninja文件编译  
	在生成.ninja文件时会调用install-sysroot.py生成一个CR_SYSROOT_HASH的宏，  
	所以修改install-sysroot.py通常导致无法编译，哪怕是添加打印，  
	所以记得拷贝一份，编译时再替换回来，参src/build/config/posix/BUILD.gn  
	gn desc <build_dir> <targetname> 命令可以帮助我们获取一些配置信息  
	<build_dir> 表示编译目录，即gn gen 生成的目录  
	<targetname> 表示对应.gn要生成的目标文件，通常是.gn文件中static_library(name)或executable(name)这样的形式  
	比如.ninja中有个宏，我想知道它是在哪里定义的，可以输入以下命令：  
	gn desc out/Default/ :webrtc_lib_link_test defines --blame  


四.运行demo  
	程序崩溃???!!!...
	放弃。。。
