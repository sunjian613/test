@ECHO OFF
ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::
ECHO.::                 Monkey����                  ::
ECHO.::               ���ߣ�MonkeyDemo                 ::
ECHO.::               �汾  V1.0.1                  ::
ECHO.::               ʱ�䣺2017.02.10              ::
ECHO.:::::::::::::::::::::::::::::::::::::::::::::::::
IF NOT EXIST %~dp0\config.conf GOTO EXIT
ECHO.[ INFO ] ׼��Monkey����
ECHO.[ INFO ] ��ȡconfig.conf����Ϣ
 
 
REM �������ļ��л�ð���
FOR /F "tokens=1,2 delims==" %%a in (config.conf) do (
    IF %%a == packageName SET packageName=%%b
    IF %%a == appEnName SET appEnName=%%b
    IF %%a == appversion SET appversion=%%b
)
 
REM ��ȡ����,��ʽΪ��20140808
SET c_date=%date:~0,4%%date:~5,2%%date:~8,2%
REM ��ȡ��Сʱ,��ʽΪ��24Сʱ�ƣ�10��ǰ��0
SET c_time=%time:~0,2%
    IF /i %c_time% LSS 10 (
SET c_time=0%time:~1,1%
)
REM ���Сʱ���֡��룬��ʽΪ: 131420
SET c_time=%c_time%%time:~3,2%%time:~6,2%
REM ��������ʱ�����Ϊ��־�ļ���
SET logfilename=%c_date%%c_time%
 
 
REM ������������Ŀ¼������APP��־����Ŀ¼
IF NOT EXIST %~dp0\%c_date%    md %~dp0\%c_date%
SET logdir="%~dp0\%c_date%\%appEnName%%appversion%"
IF NOT EXIST %logdir% (
    ECHO.[ Exec ] ����Ŀ¼��%c_date%\%appEnName%%appversion%
    md %logdir%
)
 
 
REM ����ֻ���Ϣ����ʾ������
adb shell cat /system/build.prop>phone.info
FOR /F "tokens=1,2 delims==" %%a in (phone.info) do (
    IF %%a == ro.build.version.release SET androidOS=%%b
    IF %%a == ro.product.model SET model=%%b
    IF %%a == ro.product.brand SET brand=%%b
)
del /a/f/q phone.info
ECHO.[ INFO ] ��ȡPhone��Ϣ
ECHO.         �ֻ�Ʒ��: %brand%
ECHO.         �ֻ��ͺ�: %model%
ECHO.         ϵͳ�汾: Android %androidOS%
ECHO.Phone��Ϣ>"%logdir%\%logfilename%_%model%.txt"
ECHO.�ֻ�Ʒ��: %brand%>>"%logdir%\%logfilename%_%model%.txt"
ECHO.�ֻ��ͺ�: %model%>>"%logdir%\%logfilename%_%model%.txt"
ECHO.ϵͳ�汾: Android %androidOS%>>"%logdir%\%logfilename%_%model%.txt"
 
ECHO.
ECHO.[ Exec ] ʹ��Logcat���Phone��log
adb logcat -c
REM ECHO.[ INFO ] ��ͣ2��...
ping -n 2 127.0.0.1>nul
ECHO.
ECHO.[ INFO ] ��ʼִ��Monkey����
REM ECHO.[ INFO ] ǿ�ƹر�׼�����Ե�APP
adb shell am force-stop %packageName%
 
:::::::::::::::::Monkey��������::::::::::::::::::::::::
::::::::::::�޸Ĳ�������ڴ��������޸�:::::::::::::::::

ECHO.[ Exec ] adb shell monkey 
adb shell monkey -p %packageName% -v 100
 
::::::::::::�޸Ĳ�������ڴ��������޸�:::::::::::::::::
::::::::::::::::::::::END::::::::::::::::::::::::::::::
ECHO.[ INFO ] ִ��Monkey�������
ECHO.
 
ECHO.[ Exce ] �ֻ�����
adb shell screencap -p /sdcard/monkey_run_end.png
ECHO.[ INFO ] ��������ͼƬ������
adb pull /sdcard/monkey_run_end.png %logdir%
cd %logdir%
ren monkey_run_end.png %logfilename%.png
 
ECHO.
ECHO.[ Exec ] ʹ��Logcat������־
adb logcat -d >%logdir%\%logfilename%_logcat.log
 
REM ECHO.
REM ECHO.[ Exec ] ����traces�ļ�
REM adb shell cat /data/anr/traces.txt>%logfilename%_traces.log
 
 
REM ����չ,�ϴ���־��������
 
:EXIT
ECHO.
ECHO.[ INFO ] �밴������رմ���...
 
 
PAUSE>nul