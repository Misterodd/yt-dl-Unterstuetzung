
@echo off
chcp 1252 && setlocal EnableDelayedExpansion && 0youtube-dl -U && set dg=1000000000
REM if "%1"=="" ( goto loaded ) 
if "%1"=="auto" goto :auto 
if "%1"=="music" goto :music 
if "%1"=="help" goto :help 
:loaded
echo "Hi, ich helfe dir beim Download." & echo "Der Name der .txt Datei mit den Links, oder selbst hintereinader hier einfügen. ("Link1 link2 link3 ...")" & echo "Wenn nichts eingetragen wird, nutze ich die 0vids.txt Datei hier im Ordner."
set /P link=
echo "Möchtest du nur gesagt bekommen wenn was fertig ist oder auch genau sehen wie weit der Downloader ist?"
set /P q="Schreibe '-q' für nur gesagt bekommen "- 
if "%q%"=='-q' set q=-q
if "%link%"=="" set link=0vids.txt
echo Es wird %link% genutzt
for /f "delims=" %%a  in ("%link%") do set "Extension=%%~xa"
if "%Extension%"==".txt" (
goto aaa
)
goto input2

:aaa
set txt="-a" 
echo Text-Datei erkannt ,"%link%", modus: %txt% 
if "%txt%"=="" echo OH NEIN, hab falsch programmiert F002! && pause && goto finende
:input2
 echo "Möchtest du den Download verlangsamen?"
	
	 set /P d= "[j]a oder [n]ein? "
	 if /I "%d%"=="j" set /P dg="auf wie schnell in KB? "
echo "Möchtest du nur Musik herunterladen?"
set /P m="[J]a oder [N]ein? "
if /I "%m%"=="j" goto :music
echo "Möchtest du die Qualität vollständig selbst wählen?" 
set /P man="[J]a oder [N]ein? "
if /I "%man%"=="j" goto manual
echo "OK, dennoch muss ich paar Dinge klären:" & echo "Welches Dateiformat soll genutzt werden? " & echo "[1] Einfach das beste" & echo "[2] webm für allerhöchste quali (bis zu 4k) oder "&echo "[3] mp4 für maximal HD"
	set /P f=" 1 oder 2 oder 3? "
	if /I "%f%"=="1" goto best
	if /I "%f%"=="2" goto bestMP4
	if /I "%f%"=="3" goto bestWEBM
	
goto ende
	
:bestMP4
echo "Lade jetzt die ganzen Daten in mp4. Das dauert etwas..."
0youtube-dl -r %dg% %q% --console-title --no-warnings -i -f bestvideo[ext=mp4]+bestaudio[ext=mp4]/bestvideo[ext=mp4]+bestaudio[ext=m4a] --all-subs --embed-subs --youtube-skip-dash-manifest  --merge-output-format mp4 %txt% %link%
goto ende

:bestWEBM
echo "Lade jetzt die ganzen Daten in webm. Das dauert etwas..."
0youtube-dl -r %dg% %q% --console-title --no-warnings -i -f bestvideo[ext=webm]+bestaudio[ext=webm] --all-subs --embed-subs --youtube-skip-dash-manifest  --merge-output-format webm %txt% %link%
goto ende

:manual
echo "OK, alles manuell..." & echo "Auf gehts!" & echo "Zuerst müssen wir aussuchen welches Format wir nutzen wollen: " 
echo "Hierfür brauche ich den link EINES Videos, wie z. B. https://www.zdf.de/comedy/die-anstalt/die-anstalt-clip-4-154.html:" 
set /P chklink=
set /P chISlink="Soll dieser gleich auch runtergeldaen werden? [j/n] "
if %chISlink%==j set txt="" && set link=%chklink%
0youtube-dl -F %chklink%
echo "Gut jetzt haben wir die mögliche Formate, möchtest du einfach das beste nehmen? Geht für mehrere Platformen."
set /P ch="[J]a oder [N]ein? " 
if /I "%ch%"=="J" goto best
echo "OK dann Brauche ich die Videospur." & echo "bitte wähle das format mp4 oder webm, findest du bei 'extension'.
echo "Trage hier den gewünschten 'format code' ein, es geht auch 'bestvideo[ext=mp4]' oder 'bestvideo[ext=webm]'"
echo "Wichtig ist hier, dass nur audio mit den selben Formaten genutzt werden können, also mp4 und m4a oder webm."
set /P vd="Trage nun den 'format code' ein "
echo "Sage mir doch bitte das format, welches du gewählt hast, mp4 oder webm"
set /P fm=
if %fm%==m4a set fm=mp4
if %fm%==webm set ad=bestaudio[ext=webm] && goto j1
set ad=bestaudio[ext=mp4]/bestvideo[ext=mp4]+bestaudio[ext=m4a]
:j1
echo es wurde das Audioformat %ad% gewählt.
0youtube-dl -r %dg%K %q% --newline --console-title --no-warnings -i -f %ad%+%ad% --all-subs --embed-subs  --merge-output-format %fm% %txt% %link%
goto ende

:best
0youtube-dl -r %dg%K %q% -i --all-subs --console-title --embed-subs -f best %txt% %link%

goto ende

:auto
0youtube-dl -r 800K -q --console-title --no-warnings -i -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo[ext=mp4]+bestaudio[ext=mp4] --all-subs --embed-subs --youtube-skip-dash-manifest  --merge-output-format mp4 -a 0VidTHIS.txt
goto finende

:music
echo "Ich suche in 0vids.txt in diesem Ordner noch Videos" && pause
0youtube-dl -r %dg%K -q -x --embed-thumbnail --add-metadata --console-title --audio-quality 0 --geo-bypass -i -o %(autonumber)s-%(title)s_by_%(uploader)s.%(ext)s  --audio-format mp3 -a 0vids.txt 
goto ende

:help
echo "Hi ich bin die Hilfe. Bitte achte darauf, dass entweder die 0youtube-dl.exe Datei in C:\Windows"
echo "oder im Ordner hast wo du dieses Script ausführst."
echo "Videos von der ARD Seite können zur zeit nicht heruntergeladen werden, aber vom WDR."
echo "Du kannst dieses Script mit folgenede Kommandos nutzen: "
echo auto :
echo "Dies führt dazu, dass die Links in der Datei '0vids.txt' automatisch in höchstens HD heruntergeldaen werden. Die 0vids.txt Datei muss dort sein wo dieses Script ausgeführt wird.
echo music :
echo "Dies führt dazu, dass die Links in der Datei '0vids.txt' automatisch hier in MP3s geladen werden."
echo help :
echo "Du siehst das hier."
pause
set /P doo="Normal fortfahren? [j/n] "
if /I "%doo%"=="j" goto loaded
goto :finende
:ende
	 endlocal & echo. & echo "So das wars, im Ordner wo du das hier aktiviert hast liegen jetzt die Video(s). Öffne die Videos am besten mit VLC Du kanst das  hier schließen." & call systemTrayNotification.exe -tooltip warning -time 300000 -title "Fertig" -text "So das wars, im Ordner wo du das hier aktiviert hast liegen jetzt die Video(s). Öffne die Videos am besten mit VLC" -icon question &	 pause
		:finende
	
	