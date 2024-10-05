@echo off
mkdir output_mp3
for %%f in (*.mp4) do (
    echo 正在转换 %%f 到 mp3 ...
    ffmpeg -i "%%f" -q:a 0 -map a "output_mp3/%%~nf.mp3"
)
echo 所有文件转换完成。
pause
