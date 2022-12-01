### raw media data
* extract yuv and pcm
    * `ffmpeg -i love.mp4 -s 768x432 -pix_fmt yuv420p -t 30 -y love_768x432_yuv420p_30.yuv -ar 48000 -ac 2 -f s16le -t 30 -y love_48000_2_s16le.pcm`
* play yuv and pcm
   * `ffplay -i love_768x432_yuv420p_30.yuv -pixel_format yuv420p -video_size 768x432 -framerate 30 -loop 100| ffplay -i love_48000_2_s16le.pcm -ar 48000 -ac 2 -f s16le -loop 100`

### virtual device
* create virual device for virtual mic [see this [solution](https://www.coder.work/article/7393349)]
    * `pactl load-module module-null-sink sink_name="virtual_speaker" sink_properties=device.description="virtual_speaker"`
    * `pactl load-module module-remap-source master="virtual_speaker.monitor" source_name="virtual_mic" source_properties=device.description="virtual_mic"`
* create virtual device for virtual camera [see [akcvam](https://github.com/webcamoid/akvcam) and this [solution](https://github.com/wonderful27x/study_notes/blob/main/AV-MEDIA/ffmpeg/ffmpeg_linux.md)]
* output media to intput of virtual device (camera and mic)
    * `ffmpeg -i love.mp4 -f v4l2 /dev/video0 -f pulse "stream name"`
    * `ffmpeg -re -i love.mp4 -s 768x432 -r 30 -vcodec rawvideo -pix_fmt rgb24 -f v4l2 /dev/video7 -f pulse "stream name"`
    * `ffmpeg -i love.mp4 -f pulse "stream name" | ffmpeg -re -i love.mp4 -s 768x432 -r 30 -vcodec rawvideo -pix_fmt rgb24 -f v4l2 /dev/video7`
* record media from virtual device (camera and mic)
    * `ffmpeg -f alsa -i pulse -f v4l2 -i /dev/video0 out.mp4`
* push to cloud
    * `ffmpeg -f alsa -i pulse -f v4l2 -i /dev/video0 -f rtsp -rtsp_transport udp rtsp://127.0.0.1/live/stream`
* play from cloud
    * `ffplay -i rtsp://127.0.0.1/live/stream -fflags nobuffer`

0.linux 虚拟摄像头akvcam,link https://github.com/webcamoid/akvcam
1)before start install some tools
video for linux: 
$sudo apt-get install v4l-utils
DynamicKernel ModuleSupport:
$sudo apt-get install dkms
2)download and build
$git clone https://github.com/webcamoid/akvcam.git
$cd akvcam/src
$make
$sudo make dkms_install
3)config
$sudo mkdir -p /etc/akvcam
$sudo touch /etc/akvcam/config.ini
$sudo chmod -vf 644 /etc/akvcam/config.ini
copy this default config: https://github.com/webcamoid/akvcam/blob/master/share/config_example.ini content to config.ini
when done output device should map to /dev/video7 and capture device to /dev/video0,remember this and take a look for there size in config.ini
4)load driver
$cd akvcam/src
$sudo modprobe videodev
$sudo insmod akvcam.ko
it may call a problem: insmod:ERROR:could not insert module akvcam.ko:Unknow symbol in module,do not worry about,just flow the steps below:
$modinfo akvcam.ko | grep depends
it will list the depends moudles,copy them one by one to the command below:
$modprobe moudle_name
$...
$sudo insmod akvcam.ko
5)load on boot (not neccesarry but convienent)
$sudo vim /etc/modules-load.d/akvcam.conf
add "akvcam" to it
6)test
test output
$v4l2-compliance -d /dev/video7 -f -s
test capture
$v4l2-compliance -d /dev/video0 -f -s
7)use for ffmpeg
add video source as virtual camera data
$ffmpeg -i video_name.mp4 -s 640x480 -r 30 -f v4l2 -vcodec rawvideo -pix_fmt rgb24 /dev/video7
capture/record camera and save as mp4 file
$ffmpeg -i /dev/video0 -vcodec libx264 camera1.mp4
just play it
$ffplay -i camera1.mp4


1.录制MIC,这里使用默认default
todo: 具体设备有待研究
$ffmpeg -f alsa -i default -ac 2 -ar 48000 -acodec libfdk_aac arecord2.aac

2.录制桌面,设备为:0.0,偏移0 0
todo: 坐标偏移有待研究,设备查看有待研究
$ffmpeg -f x11grab -i :0.0+0+0 -s 1280x720 -vcodec libx264 -r 10 screen1.avi

3.同时录制桌面和MIC,
todo: 不知为啥加上采样率ar会报错
$ffmpeg -f alsa -i default -ac 2 -acodec libfdk_aac -f x11grab -i :0.0 -s 1920x1080 -vcodec libx264 -t 10 mic_screen1.mp4

4.多宫格
ffmpeg -i love.mp4 -i love.mp4 -i love.mp4 -i love.mp4 -filter_complex "nullsrc=size=640x480[base]; \
[0:v]setpts=PTS-STARTPTS,scale=320x240[upperleft]; \
[1:v]setpts=PTS-STARTPTS,scale=320x240[upperright]; \
[2:v]setpts=PTS-STARTPTS,scale=320x240[lowerleft]; \
[3:v]setpts=PTS-STARTPTS,scale=320x240[lowerright]; \
[base][upperleft] overlay=shortest=1[tmp1]; \
[tmp1][upperright] overlay=shortest=1:x=320[tmp2]; \
[tmp2][lowerleft] overlay=shortest=1:y=240[tmp3]; \
[tmp3][lowerright] overlay=shortest=1:x=320:y=240" -t 25 love_multi.mp4

