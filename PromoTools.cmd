@ECHO OFF
color 0A

:choice
echo Your choices:
echo.
echo * Type the W key for text watermark.
echo.
echo * Type the S key for image snapshots.
echo.
echo * Type the C key for promo video cutter.
echo.
 
set /P c=... Make your selection of either: [W/S]  
if /I "%c%" EQU "W" goto :yeswatermark
if /I "%c%" EQU "S" goto :yessnapshot
if /I "%c%" EQU "C" goto :yescutter
 
goto :choice


:yeswatermark
@ECHO OFF


set /p watermark="Enter watermark text: "

set /p outputname="Enter short file ID to add to title (e.g. v2): "


FOR %%F IN (%*) DO (
    ffmpeg -i %%F -filter_complex "drawtext=text='%watermark%':x=10:y=10: fontfile=/path/to/font.ttf:fontsize=44:fontcolor=white: shadowcolor=black:shadowx=2:shadowy=2" "C:/PromoTools/output/watermarks/%%~nF-%outputname%.mp4"
)

CLS
echo Finished. You can find the file in WATERMARKS folder.
echo.
echo To continue with something else hit any key otherwise close the window. 
PAUSE
CLS
goto :choice

 
:yessnapshot

@ECHO OFF

color 0A

set /p outputname="Enter short file ID to add to title (e.g. v2): "
set /p seconds="How many seconds between image snapshots? "

FOR %%F IN (%*) DO (
	ffmpeg.exe -i %%F -vf fps=1/%seconds% "C:/PromoTools/output/snapshots/%%~nF-%outputname%%%05d.jpg"
)

CLS
echo Finished. You can find the file in SNAPSHOTS folder.
echo.
echo To continue with something else hit any key otherwise close the window. 
PAUSE
CLS
goto :choice


:yescutter

@ECHO OFF
color 0A

set /p distance="How many seconds should pass between snapshots? "
set /p snapshot="How many seconds long should each snapshot be? "
set /p outputname="Add some text to the title so you know which version this is (e.g. v2 - don't use spaces) "


FOR %%F IN (%*) DO (
    ffmpeg -i %%F -filter_complex "select='lt(mod(t,%distance%),%snapshot%)',setpts=N/FRAME_RATE/TB;aselect='lt(mod(t,%distance%),%snapshot%)',asetpts=N/FRAME_RATE/TB" "C:/PromoTools/output/cutter/%%~nF-%outputname%.mp4"
)
PAUSE

CLS
echo Finished. You can find the file in CUTTER folder.
echo.
echo To continue with something else hit any key otherwise close the window. 
PAUSE
CLS
goto :choice