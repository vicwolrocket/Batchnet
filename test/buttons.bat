@Echo off & Cls
 
:# Updated version of example at: https://youtu.be/ZYhvUbek4Xc
 
:# Batch clickable button macros and example functions
:# Author: T3RRY Version: 2.0.5 Last Update: 11/07/2021
:# New features:
:# Added 'def' arg to allow this file to be called to define macros for use in a calling file.
:#  - Note:
:#        - Delayed Expansion be DISabled prior to defining macros
:#        - Delayed Expansion must be ENabled to expand macros
:# Expanded help information
:# Reduced number of macros and functions to simplify usage
:# Added new switches to make.btn for controlling button toggle type and defaults
:# Added prompt for permission to install bg.exe ; a required component of this file.
 
:testEnviron
 If "!!" == "" (Goto :button_help)
 Set "Buttons_File=%~f0"
 
(Set \n=^^^
 
%= \n macro newline variable. Do not modify =%)
(Set LF=^
 
 
%= LF newline variable. Do not modify =%)
 
CLS
 
====================:# OS Requirement tests
:# Verify NTFS drive ** ADS Used to store Settings applied in demo function ColorMod
 (Echo(verify.NTFS >"%~f0:Status") || (
  Echo(This file must be located on an NTFS drive as it utilises Alternate Data Streams.
  Pause
  Exit /B 1
 )
 
=========================:# Windows Version control.
 Set "Win10="
 Ver | Findstr /LIC:" 10." > nul && Set "Win10=true"
 
============================:# Test if virtual terminal codes enabled ; enable if false
:# removes win10 flag definition if version does not support Virtual Terminal sequences
 If defined Win10 (
  Reg Query HKCU\Console | %SystemRoot%\System32\findstr.exe /LIC:"VirtualTerminalLevel    REG_DWORD    0x1" > nul || (
    Reg Add HKCU\Console /f /v VirtualTerminalLevel /t REG_DWORD /d 1
  ) > Nul || Set "Win10="
 )
 If not defined Win10 (
  Echo(Virtual terminal sequences not supported on your system
  Pause
  Exit /B 1
 )
 
:# Buttons macro Based on function at: https://www.dostips.com/forum/viewtopic.php?f=3&t=9222
 
:# Script Structure:
:# OS and Exe Validation
:# - Variable and macro Setup
:#  - Functions
:#   - Macro help handling
:#    - [Script Break - Jump to :Main]
:#     - Embedded Exe for Mouse and Key Inputs
:#      - Main script body
 
 Set "reg.restore=(Call )"
 
:# disable QuickEdit if enabled. Restored at :end label if disabled by script
  For /f "skip=1 Tokens=3" %%G in ('reg query HKEY_CURRENT_USER\console\ /v Quickedit')Do Set "QE.reg=%%G"
   If "%QE.reg%" == "0x1" (
   (Reg add HKEY_CURRENT_USER\console\ /v QuickEdit /t REG_DWORD /d 0x0 /f) > nul
   Set "reg.restore=Reg add HKEY_CURRENT_USER\console\ /v QuickEdit /t REG_DWORD /d 0x1 /f"
  )
 
 For /f %%e in ('Echo Prompt $E ^| cmd')Do Set "\E=%%~e"
 
 If not exist "%TEMP%\BG.exe" (
  Echo(%\E%[33mThis program requires Bg.exe to run.%\E%[0m
  Echo( Install from this file %\E%[32m[Y]%\E%[0m or Exit %\E%[31m[N]%\E%[0m ?
  For /f "delims=" %%C in ('choice.exe /N /C:YN')Do if %%C==Y (
   Certutil -decode "%~f0" "%TEMP%\BG.exe" > nul
  )Else Goto :eof
  Cls
 )
 
 Set BG.exe="%TEMP%\BG.exe"
 
 For /f "tokens=4 Delims=: " %%C in ('CHCP')Do Set "active.cp=%%C"
 chcp 65001 > nul
 
 Set "/??=0"
:#0  \E33m
:#0 Call this file with one of the below macro or function \E37mNames\E33m
:#0 to see it's full usage information.
:#0  \E36m
:#0 Macros: \E37m
:#0  Make.Btn   \E38;2;81;81;131m %Make.Btn% GroupName /S button text \E37m
:#0  Get.Click  \E38;2;81;81;131m %Get.Click% GroupName OtherGroupName \E37m
:#0  If.Btn     \E38;2;81;81;131m %If.Btn[Groupname]%[#] command \E37m
:#0  Buffer     \E38;2;81;81;131m %Buffer:@=Alt% \E37m
:#0             \E38;2;81;81;131m %Buffer:@=Main% \E37m
:#0  Clean.Exit \E38;2;81;81;131m %Clean.Exit%
:#0  \E36m
:#0 Functions: \E37m
:#0  YesNo      \E38;2;81;81;131m Call :YesNo "Option 1" "Option 2" "Spoken Prompt"
:#0  \E36m
:#0 Define macros for use in a calling .bat or .cmd script: \E37m
:#0  Call buttons.bat def
:#0 
 
 Set "Buffer?=1"
:#1 \E36m
:#1 Usage:   %Buffer:@=Alt%
:#1 \E0m          - Switch to Alt buffer; preserving content of main screen buffer.
:#1 \E36m
:#1          %Buffer:@=Main%
:#1 \E0m          - Returns to main screen buffer.
:#1
 Set "Buffer.Hash=@"
 Set "Buffer=If not "!Buffer.Hash!"=="@" ( <nul set /p "=!@!" )Else (Cls&Call "%~f0" Buffer&Call Echo(%\E%[31mUsage Error in %%0 - Missing or Incorrect Substitution^^!%\E%[0m&Pause &Exit)"
 Set "Alt=%\E%[?1049h%\E%[?25l"
 Set "Main=%\E%[?25h%\E%[?1049l%\E%[?25l"
 
:# button sound fx. disable by undefining buttonsfx below ; prior to definition of OnCLick macro
 Set "buttonsfx=On"
 %BG.exe% Play "%WINDIR%\Media\Windows Feed Discovered.wav"
 Set "OnClick=(Call )"
 Set "OnType=(Call )"
 If defined buttonsfx (
  For /f "Delims=" %%G in ('Dir /b /s "%WINDIR%\SystemApps\*KbdKeyTap.wav"')Do If exist "%%~G" Set "OnClick=(Start /b "" %BG.exe% Play "%%~G")"
  Set "OnType=(start /b "" %BG.exe% Play "%WINDIR%\Media\Windows Feed Discovered.wav")"
 )
 
 Set "Get.Click?=2"
:#2 \E36m
:#2 Usage: %Get.Click% \E0m{^<\E31mGroupName\E0m^> ^| ^<\E31mGroupName\E0m^> ^<\E31mOtherGroupName\E0m^>}
:#2 \E33m
:#2 Performs the following Actions: \E0m
:#2  - Launches Bg.exe with mouse arg to get mouse click
:#2  - Assigns 1 indexed Y;X pos of mouse click to c{Pos}
:#2  - Performs a conditional comparison via substring modifications
:#2    of all buttons Coordinates defined in each btn[GroupName] array
:#2    matching against the Y;X value of c{Pos}
:#2 \E33m
:#2 On clicked position matching a buttons defined Coordinates: \E0m
:#2  - If %Make.Btn% /T or /TM Switches used to define defined btn[Groupname][Index]{t}:
:#2    - /T:
:#2      - Toggles button visually by inverting colors
:#2      - Toggles btn[Groupname][Index]{state} variable value: true / false
:#2    - /TM:
:#2      - Forces btn[Groupname][Index]{state} true for clicked button.
:#2      * Use In conjunction with /D 'default' or /CD 'Conditional Default' switch
:#2        when a mandatory single selection is required.
:#2  - Defines the following:
:#2     If.btn[GroupName]=\E35mIf [Groupname][Index] == [GroupName]\E0m
:#2     Group=GroupName
:#2     Clicked[Groupname]=Button Text
:#2     ValidClick[GroupName]=[GroupName][Index]
:#2     - Tip reference values directly using: \E36m
:#2       !Clicked[%Group%]!
:#2       !ValidClick[%Group%]!  \E0m
:#2  - Plays the system file KbdKeyTap.wav [If Present] as a clicking sound.
:#2 \E33m
:#2 On clicked position not matching a buttons defined Coordinates: \E0m
:#2  - Defines:
:#2     If.btn[GroupName]=\E36mIf Not.Clicked ==\E0m
:#2  - Undefined:
:#2     Group
:#2      - To loop to a label and wait for a valid click of any
:#2        button defined to a supplied GroupName, Use:
:#2        \E36mIf not defined Group Goto :\E33mlabel\E0m
:#2     Clicked[Groupname]
:#2     ValidClick[GroupName]
:#2 
 Set "If.Btn?=4"
:#4 \E36m
:#4 Usage: %If.btn\E35m[GroupName]\E36m%\E31m[Index] \E90m(Command)\E0m
:#4 
:#4  -\E33m Compares clicked button \E0m[GroupName][Index]\E33m against \E0m[Groupname]\E31m[arg]\E0m
:#4 
 
:# return button click coords in c{pos} variable n Y;X format
 Set Get.Click=For %%n in (1 2)Do if %%n==2 (%\n%
  Set "Group="%\n%
  For %%G in (!GroupName!)Do (%\n: Update display of toggle state =%
   For /l %%i in (1 1 !Btns[%%G][i]!)Do (%\n%
    If not "!Btn[%%G][%%i]{state}!"=="true" (%\n%
     ^<nul set /P "=!Btn[%%G][%%i]!"%\n%
    )Else If Defined Btn[%%G][%%i]{t} (%\n%
     set "tmpstr=!Btn[%%G][%%i]:38=7;38!"%\n%
     ^<nul set /P "=!tmpstr:48=7;48!"%\n%
  )))%\n%
  for /f "tokens=1,2" %%X in ('%BG.exe% mouse')Do (%\n: Wait for mouse input =%
   Set /A "c{pos}=%%X+1"                         %\n: Adjust X axis for 1 index =%
   Set "c{pos}=!c{Pos}!;%%Y"                     %!!%
   For %%G in (!GroupName!)Do (                  %\n: iterate over list of supplied group names =%
    Set "If.Btn[%%G]=If Not.Clicked =="          %\n: assign or clear default values for return variables =%
    Set "Clicked[%%G]="%\n%
    Set "ValidClick[%%G]="%\n%
    Set "ValidClick[%%G]{t}="%\n%
    For /F "Delims=" %%C in ("!c{Pos}!")Do (     %\n: expand Coordinate var for use in substring modification =%
     For /l %%I in (1 1 !btns[%%G][I]!)Do (      %\n: test if [Y;X] Coord contained in btn Coord Var =%
      If not "!btn[%%G][%%I][Coord]:[%%C]=!" == "!btn[%%G][%%I][Coord]!" (%\n%
       %OnClick%                                 %\n: play click sound effect if available =%
       Set "Group=%%G"                           %\n: assign groupname value the button clicked belongs to =%
       Set "If.Btn[%%G]=If [%%G][%%I] == [%%G]"  %\n: define If.Btn[GroupName] macro =%
       Set "ValidClick[%%G]=[%%G][%%I]"          %\n: assign [GroupName][Index] of clicked button =%
       Set "Clicked[%%G]=!Btn[%%G][%%I][String]!"%\n: assign the text containd in the clicked button =%
       If Defined Btn[%%G][%%I][items] (%\n%
        Set Btn[%%G][%%I][items]="!Btn[%%G][%%I][items]:{EQ}==!"%\n%
        Set "Btn[%%G][%%I][items]=!Btn[%%G][%%I][items]: =" "!"%\n%
        Set "Tmp.Items=!Btn[%%G][%%I][items]!"%\n%
        Set "Btn[%%G][%%I][items]="%\n%
        For %%t in (!Tmp.Items!)Do (%\n%
         Set "tmp.str=%%~t"%\n%
         Set "tmp.str=!tmp.Str:_= !"%\n%
         Set "!tmp.str!"%\n%
         Echo(!tmp.str!^|findstr.exe /R "[0-9]" ^> nul ^|^| Set "Btn[%%G][%%I][items]=!Btn[%%G][%%I][items]! "!tmp.str!""%\n%
        )%\n%
       )%\n%
       If Defined Btn[%%G][%%I]{t} (             %\n: toggle state handling. =%
        Set "ValidClick[%%G]{t}=[%%G][%%I]"      %\n: flag toggle state change for toggle.If.Not macro =%
        If "!Btn[%%G][%%I]{state}!"=="true" (    %\n: update console display of toggle state by inverting colors =%
        If not defined Btn[%%G][%%I]{m} (%\n%
         ^<nul set /P "=!Btn[%%G][%%I]!"%\n%
          Set "Btn[%%G][%%I]{state}=false"%\n%
         )%\n%
        )Else (%\n%
         set "tmpstr=!Btn[%%G][%%I]:38=7;38!"%\n%
         ^<nul set /P "=!tmpstr:48=7;48!"%\n%
         Set "Btn[%%G][%%I]{state}=true"%\n%
  )))))))%\n%
 )Else Set GroupName=
 
 Set "Toggle.If.not?=5"
:#5 \E36m
:#5 Usage: %Toggle.If.Not% \E0m{^<\E31m[Groupname][Index]\E0m^> ^| ^<\E31m[Groupname][Index]\E0m^> ^<\E31m[OtherGroupname][Index]\E0m^>}
:#5 \E33m
:#5 Macro Actions: \E0m
:#5 - Defines {state} false for all toggle buttons in GroupName except [Groupname][Index] 
:#5 - Updates Display Color of all buttons; Inverting each button with {state}=true
:#5 
:#5 * Multiple [GroupName][Index]'s \E31m with unique GroupNames \E0m may be supplied
:#5 \E33m
:#5 Example usage:\E36m
:#5 %Toggle.If.Not% !ValidClick[GroupName]!
:#5 \E0m
 Set Toggle.If.not=For %%n in (1 2)Do if %%n==2 (%\n%
  For /f "tokens=1,2 Delims=[]" %%G in ("!GroupName: =!")Do (%\n: Remove spaces from arg assignment =%
   If defined ValidClick[%%G]{t} (               %\n: If state change flagged true in Get.Click macro =%
    For /l %%i in (1 1 !btns[%%G][i]!)Do (       %\n: test each button in groupname =%
     If not "%%i"=="%%H" (                       %\n: If not button EQU clciked button =%
      Set "btn[%%G][%%i]{state}=false"           %\n: Force btn[%%G][%%i]{state} false =%
      ^<nul Set /P "=!btn[%%G][%%i]!"            %\n: Display button in standard unselected color =%
  ))))%\n%
 )Else Set GroupName=
 
 Set "Clean.Exit?=7"
:#7 
:#7 Clean.Exit \E33m
:#7  Restores codepage and Quickedit registry state
:#7  Clears the title and screen ; ends the local environment
:#7  executes Goto :Eof
:#7 \E0m
 Set Clean.Exit=(%\n%
  cls %\n%
  (%Reg.Restore%) ^> nul %\n%
  (Title ) %\n%
  ^<nul set /p "=%\E%[?25h" %\n%
  CHCP %active.cp% ^> nul %\n%
  Endlocal %\n%
  Goto :Eof %\n%
 )
 
 Set "Make.Btn?=9"
:#9  \E33m
:#9 Make.Btn Macro Usage: \E36m
:#9 %Make.Btn%\E0m ^<\E31mGroupName\E0m^> ^<\E31m/S "Btn text"\E0m^> [\E32m/Y Coord\E0m] [\E32m/X Coord\E0m] [\E32m/FG R G B\E0m]
:#9            [\E32m/BG R G B\E0m] [\E32m/BO \E0m{\E33mR G B\E0m^|\E33mR G B + R G B\E0m^|\E33mValue\E0m}] [\E32m/T\E0m] [\E32m/N\E0m]
:#9            [^<\E31m/TM\E0m^> [\E32m/D\E0m]^|[\E32m/CD Variable\E0m]]
:#9  \E37m
:#9  - Arg 1 must be Groupname. Switch order is NOT mandatory.
:#9  \E36m
:#9   /N \E37mReset button count for GroupName (Arg 1) to 0. use when creating buttons in a :label that is returned to. \E36m
:#9   /T \E37mDefine button as toggleable. Button state: 'Btn[Groupname][i]{state}' variable
:#9      alternates true or false when clicked; and clicked buttons Color is inverted on match. \E36m
:#9   /TM \E0m'Toggle Mandatory' as above; however mandatory true state for last selected button \E36m
:#9      /D  \E0m'default selection' ; Flags toggle {state} true on definition. \E31m * Requires \E36m/TM
:#9      /CD \E0m'Conditional default selection' ; If /CD Variable contains /S string
:#9           Flags toggle {state} true on definition. \E31m * Requires \E36m/TM
:#9 
:#9 Note: \E36m/BO \E37m{'Button box'} may supply a pair of R G B values for FG and BG by concatenating values with '+'
:#9   IE: '\E36m/BO \E38;2;255;0;0m\E48;2;0;0;100m38 2 255 0 0 + 48 2 0 0 100\E0m'
:#9   R G B sequences are groups of three integers between 0 and 255. Each R G B value adjusts the intensity of
:#9  that color. Valid values for Virtual terminal sequences can be referenced at:
:#9  \E32m https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences#text-formatting
:#9  \E33m
:#9 Default Y and X Coordinates is used are /X value is ommited \E37m
:#9 - Button defaults to next X spacing if /Y position included ; Else X = 2
:#9 - Button defaults to next Y spacing if /Y ommited ;
:#9   - defaults to previous /X spacing if /X also ommited
:#9 
:#9 \E38;2;81;81;131mExpansion time is approxiamtely 1/33rd of a second when all switches used.
:#9 \E0m
 
 Set Make.Btn[Switches]="S" "Y" "X" "FG" "BG" "BO" "T" "TM" "D" "N" "CD" "Def"
 
 Set Make.Btn=For %%n in (1 2)Do if %%n==2 (                              %\n: CAPTURE ARG STRING =%
  Set "Make.Btn[Syntax]=%\E%[33m!Make.Btn[args]!"%\n%
  For /F "Tokens=1,2 Delims==" %%G in ('Set "Make.Btn_" 2^^^> nul')Do Set "%%~G=" %\n: RESETS ALL MACRO INTERNAL VARS =%
  If not "!Make.Btn[args]:* /=!" == "!Make.Btn[args]!" (                              %\n: BUILD Make.Btn.Args[!Make.Btn_arg[i]!] ARRAY IF ARGS PRESENT =%
   Set "Make.Btn_leading.args=!Make.Btn[args]:*/=!"                                   %\n: SPLIT ARGS FROM SWITCHES =%
   For /F "Delims=" %%G in ("!Make.Btn_leading.args!")Do Set "Make.Btn_leading.args=!Make.Btn[args]:/%%G=!"%\n%
   Set ^"Make.Btn[args]=!Make.Btn[args]:"=!"                                          %\n: REMOVE DOUBLEQUOTES FROM REMAINING ARGSTRING - SWITCHES =%
   Set "Make.Btn_arg[i]=0"                                                            %\n: ZERO INDEX FOR ARGS ARRAY =%
   For %%G in (!Make.Btn_leading.args!)Do (                                           %\n: BUILD ARGS ARRAY =%
    Set /A "Make.Btn_arg[i]+=1"%\n%
    Set "Make.Btn_arg[!Make.Btn_arg[i]!]=%%~G"%\n%
    For %%i in ("!Make.Btn_arg[i]!")Do (                                              %\n: SUBSTITUTE THE FOLLOWING POISON CHARACTERS =%
     Set "Make.Btn_arg[%%~i]=!Make.Btn_arg[%%~i]:{SC}=;!"%\n%
     Set "Make.Btn_arg[%%~i]=!Make.Btn_arg[%%~i]:{QM}=?!"%\n%
     Set "Make.Btn_arg[%%~i]=!Make.Btn_arg[%%~i]:{FS}=/!"%\n%
     Set "Make.Btn_arg[%%~i]=!Make.Btn_arg[%%~i]:{AS}=*!"%\n%
     Set "Make.Btn_arg[%%~i]=!Make.Btn_arg[%%~i]:{EQ}==!"%\n%
     Set ^"Make.Btn_arg[%%~i]=!Make.Btn_arg[%%~i]:{DQ}="!"%\n%
  ))) Else (                                                                           %\n: IF NO ARGS REMOVE DOUBLEQUOTES FROM ARGSTRING - SWITCHES =%
   Set ^"Make.Btn[args]=!Make.Btn[args]:"=!"%\n%
   Set "Make.Btn_Arg[1]=!Make.Btn[args]!"%\n%
   Set "Make.Btn_Arg[i]=1"%\n%
  )%\n%
  For /L %%L in (2 1 4)Do If "!Make.Btn_LastSwitch!" == "" (%\n%
   If "!Make.Btn[args]:~-%%L,1!" == " " Set "Make.Btn_LastSwitch=_"%\n%
   If "!Make.Btn[args]:~-%%L,1!" == "/" (                                              %\n: FLAG LAST SWITCH TRUE IF NO SUBARGS ; FOR SWITCHES UP TO 3 CHARCTERS LONG =%
    For /F "Delims=" %%v in ('Set /A "%%L-1"')Do Set "Make.Btn_Switch[!Make.Btn[args]:~-%%v!]=true"%\n%
    If not "!Make.Btn[args]:/?=!." == "!Make.Btn[args]!." Set "Make.Btn_Switch[help]=true"%\n%
    Set "Make.Btn[args]=!Make.Btn[args]:~0,-%%L!"%\n%
    Set "Make.Btn_LastSwitch=_"%\n%
   )%\n%
  )%\n%
  For %%G in ( %Make.Btn[Switches]% )Do If not "!Make.Btn[args]:/%%~G =!" == "!Make.Btn[args]!" (%\n: SPLIT AND ASSIGN SWITCH VALUES =%
   Set "Make.Btn_Switch[%%~G]=!Make.Btn[args]:*/%%~G =!"%\n%
   If not "!Make.Btn_Switch[%%~G]:*/=!" == "!Make.Btn_Switch[%%~G]!" (%\n%
    Set "Make.Btn_Trail[%%~G]=!Make.Btn_Switch[%%~G]:*/=!"%\n%
    For %%v in ("!Make.Btn_Trail[%%~G]!")Do (%\n%
     Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]: /%%~v=!"%\n%
     Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:/%%~v=!"%\n%
    )%\n%
    Set "Make.Btn_Trail[%%~G]="%\n%
    If "!Make.Btn_Switch[%%~G]:~-1!" == " " Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:~0,-1!"%\n%
    If "!Make.Btn_Switch[%%~G]!" == "" Set "Make.Btn_Switch[%%~G]=true"%\n%
    If not "!Make.Btn_Switch[%%~G]!" == "" If not "!Make.Btn_Switch[%%~G]!" == "true" (%\n%
     Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:{SC}=;!"%\n%
     Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:{QM}=?!"%\n%
     Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:{FS}=/!"%\n%
     Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:{AS}=*!"%\n%
     Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:{EQ}==!"%\n%
     Set ^"Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:{DQ}="!"%\n%
   ))%\n%
   If "!Make.Btn_Switch[%%~G]:~-1!" == " " Set "Make.Btn_Switch[%%~G]=!Make.Btn_Switch[%%~G]:~0,-1!"%\n%
  )%\n: ACTION SWITCH ASSESSMENT BELOW. USE CONDITIONAL TESTING OF VALID SWITCHES OR ARGS ARRAY TO ENACT COMMANDS FOR YOUR MACRO FUNCTION =%
  If not defined Make.Btn_Arg[1] (%\n:           Enforce button Groupname Definiton via Arg 1 =%
   Call "%Buttons_File%" Make.Btn%\n%
   ^<nul Set /P "=%\E%[E ^! %\E%[31mMissing Arg 1 GroupName in:%\E%[36m %%Make.btn%%%\E%[31m GroupName!Make.Btn[Syntax]:  = !%\E%[0m%\E%[E"%\n%
   Pause %\n%
   cls %\n%
   (%Reg.Restore%) ^> nul %\n%
   (Title ) %\n%
   ^<nul set /p "=%\E%[?25h" %\n%
   CHCP %active.cp% ^> nul %\n%
   Endlocal %\n%
   Goto :Eof %\n%
  )%\n%
  If not defined Make.Btn_Switch[S] (%\n:        Enforce button text definition via /S switch parameter value =%
   Call "%Buttons_File%" Make.Btn%\n%
   ^<nul Set /P "=%\E%[E ^! %\E%[31mMissing Switch /S in:%\E%[36m %%Make.btn%%!Make.Btn[Syntax]:  = ! %\E%[31m/S Button text%\E%[0m%\E%[E"%\n%
   Pause %\n%
   cls %\n%
   (%Reg.Restore%) ^> nul %\n%
   (Title ) %\n%
   ^<nul set /p "=%\E%[?25h" %\n%
   CHCP %active.cp% ^> nul %\n%
   Endlocal %\n%
   Goto :Eof %\n%
  )%\n%
  For %%e in ("!Make.Btn_Arg[1]!")Do (%!!%
   If defined Make.Btn_Switch[N] (%\n:           Reset button group index and X Y positions if /N switch used =%
    Set "Btn[%%~e][X]="%\n%
    Set "Btn[%%~e][Y]="%\n%
    Set "Btns[%%~e][i]=0"%\n%
   )%\n%
   If defined Make.Btn_Switch[Y] (%\n:           Determine button Y Position according to /Y switch usage or default increment =%
    Set /A "Btn[%%~e][Y]=!Make.Btn_Switch[Y]!"%\n%
   )Else (%\n%
    Set /A "Btn[%%~e][Y]+=3+0"%\n%
   )%\n%
   If defined Make.Btn_Switch[X] (%\n:           Determine button X Position according to /X usage or default increment =%
    Set /A "Btn[%%~e][X]=!Make.Btn_Switch[X]!"%\n%
   )Else (%\n%
    If defined Make.Btn_Switch[Y] (%\n%
     Set /A "Btn[%%~e][X]=!L[%%~e][X]!+0"%\n%
    )Else (%\n%
     If not defined Btn[%%~e][X] Set "Btn[%%~e][X]=2"%\n%
   ))%\n%
   If !Btn[%%~e][X]! LSS 2 ( Set "Btn[%%~e][X]=2" )%\n%
   Set /a "Btns[%%~e][i]+=1+0"%\n:               Increment button Index =%
   For %%f in ("!Btns[%%~e][i]!")Do (%\n:        Expand button index =%
    Set "Btn[%%~e][!Btns[%%~e][i]!][p]=!Btn[%%~e][Y]!;!Btn[%%~e][X]!"%\n%
    Set "Btn[%%~e][!Btns[%%~e][i]!][string]=!Make.Btn_Switch[S]!"%\n%
    If /I "!Make.Btn_Switch[T]!"=="true" (%\n:   Define toggle vars according to /T or /TM switche usage =%
     Set "Btn[%%~e][%%~f]{t}=true"%\n%
     Set "Btn[%%~e][%%~f]{state}=false"%\n%
    ) Else If /I "!Make.Btn_Switch[TM]!"=="true" (%\n%
     Set "Btn[%%~e][%%~f]{t}=true"%\n%
     Set "Btn[%%~e][%%~f]{state}=false"%\n%
     Set "Btn[%%~e][%%~f]{m}=true"%\n%
    ) Else (%\n:                                 If /Tor /TM toggle switches not used ; ensure toggle vars undefined =%
     Set "Btn[%%~e][%%~f]{t}="%\n%
     Set "Btn[%%~e][%%~f]{state}="%\n%
     Set "Btn[%%~e][%%~f]{m}="%\n%
    )%\n%
    If defined Make.Btn_Switch[D] (%\n:          Define button as toggle state true =%
     If defined Btn[%%~e][%%~f]{t} (%\n:         if button is defined as toggleable =%
      Set "Btn[%%~e][%%~f]{state}=true"%\n%
    ))%\n%
    If defined Make.Btn_Switch[CD] (%\n:         Test supplied variable for contents of button text =%
     If defined Btn[%%~e][%%~f]{t} (%\n:         if button is defined as toggleable =%
      For %%1 in ("!Make.Btn_Switch[CD]!")Do (%\n%
       For %%2 in ("!Make.Btn_Switch[S]!")Do (%\n%
        If not "!%%~1:%%~2=!"=="!%%~1!" (%\n:     Define button as toggle state true on match =%
         Set "Btn[%%~e][%%~f]{state}=true"%\n%
    )))))%\n%
    If defined Make.Btn_Switch[FG] (%\n:         Assign Foreground color =%
     Set "Btn[%%~e][FG]=%\E%[38;2;!Make.Btn_Switch[FG]: =;!m"%\n%
    )Else (%\n%
     set "Btn[%%~e][FG]=%\E%[38;2;0;0;0m"%\n%
    )%\n%
    If defined Make.Btn_Switch[BG] (%\n%
     Set "Btn[%%~e][BG]=%\E%[48;2;!Make.Btn_Switch[BG]: =;!m"%\n%
    )Else (%\n%
     Set "Btn[%%~e][BG]=%\E%[48;2;230;230;200m"%\n%
    )%\n%
    If defined Make.Btn_Switch[BO] (%\n:         Process value of /BO border color =%
     Set "Btn[%%~e][Col]=!Btn[%%~e][Col]: + =m%\E%[!"%\n%
     Set "Btn[%%~e][Col]=%\E%[!Make.Btn_Switch[BO]: =;!m"%\n%
     Set "Btn[%%~e][Col]=!Btn[%%~e][Col]:+=m%\E%[!"%\n%
     Set "Btn[%%~e][Col]=!Btn[%%~e][Col]:[;=[!"%\n%
     Set "Btn[%%~e][Col]=!Btn[%%~e][Col]:;;=;!"%\n%
     Set "Btn[%%~e][Col]=!Btn[%%~e][Col]:;m=m!"%\n%
    ) Else (%\n:                                 Enact default border color if no value supplied =%
     set "Btn[%%~e][Col]=%\E%[90m"%\n%
    )%\n%
    Set "len="%\n:                               Get string length of button text =%
    Set "tmp.s=#!Make.Btn_Switch[S]!"%\n%
    For %%P in (8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (%\n%
     If "!tmp.s:~%%P,1!" NEQ "" (%\n%
      Set /a "len+=%%P"%\n%
      Set "tmp.s=!tmp.s:~%%P!"%\n%
    ))%\n%
    Set /A "Btn{Xmin}=!Btn[%%~e][X]!+1", "Btn{Xmax}=!Btn[%%~e][X]!+len", "l[%%~e][X]=!Btn[%%~e][X]!+len+2"%\n%
    Set "Btn[%%~e][%%~f][S]="%\n%
    Set "Btn[%%~e][%%~f][Bar]="%\n%
    Set "Btn[%%~e][%%~f][Coord]="%\n%
    For /l %%i in (!Btn{Xmin}! 1 !Btn{Xmax}!)Do (%\n%
     Set /A "Btn[%%~e][%%~f][Len]=%%i-3", "Xoffset=%%i-1"%\n%
     Set "Btn[%%~e][%%~f][Coord]=!Btn[%%~e][%%~f][Coord]![!Btn[%%~e][Y]!;!Xoffset!]"%\n%
     Set "Btn[%%~e][%%~f][Bar]=!Btn[%%~e][%%~f][Bar]!═"%\n%
     Set "Btn[%%~e][%%~f][S]=!Btn[%%~e][%%~f][S]! "%\n%
    )%\n%
    Set /A "Btn[%%e][Cpos]=!Btn[%%~e][Y]!+2"%\n%
    If defined Make.Btn_Switch[Def] Set "btn[%%~e][%%~f][items]=!Make.Btn_Switch[Def]!"%\n%
    Set "Btn[%%~e][%%~f]=%\E%[!Btn[%%~e][Y]!;!Btn[%%~e][X]!H!Btn[%%~e][col]!%\E%7║%\E%8%\E%A╔!Btn[%%~e][%%~f][Bar]!╗%\E%8%\E%B╚!Btn[%%~e][%%~f][Bar]!╝%\E%8%\E%C%\E%[0m!Btn[%%~e][FG]!!Btn[%%~e][BG]!!Make.Btn_Switch[S]!%\E%[0m!Btn[%%~e][col]!║%\E%[0m%\E%[2E%\E%7"%\n%
    Set "Btn[%%~e][%%~f][t]=%\E%[0m!Btn[%%~e][FG]!!Btn[%%~e][BG]!!Make.Btn_Switch[S]!%\E%[0m!Btn[%%~e][col]!║%\E%[0m%\E%[K"%\n%
  ))%\n%
 %= ESCAPE AMPERSANDS AND REDIRECTION CHARACTERS.  =%) Else Set Make.Btn[args]=
 
 <nul set /p "=%\E%[?25l"
 
 If not "%~1" == "" (
  If /I not "%~1" == "def" (
   Goto :button_help
  )Else Goto :Eof
 )
 
==========
 Goto :Main
==========
 
:# HELP INFO
 
============
:button_help </?|Function_Name|Macro_Name>
 Set "_D="
 If not "%~1"=="" (
  Setlocal EnableDelayedExpansion
  Set "_D=!%~1?!"
 )
 Endlocal & Set "_D=%_D%"
 
 If not "%~1"=="" (
  If Defined _D (
   Mode 120,45
   (
    Echo(%\E%[36mSyntax: %\E%[0m^<%\E%[31mMandatory%\E%[0m^> [%\E%[32mOptional%\E%[0m] {%\E%[33mMutually^%\E%[0m^|%\E%[33mExclusive%\E%[0m}
    For /f "Tokens=2* Delims=%_D%" %%T in ('Findstr /BLIC:":#%_D%" "%Buttons_File%"')Do (
     Set "line=%%T"
     Call Set "line=%%line:buttons.bat="%~f0"%%"
     Call Echo(%%Line:\E=%\E%[%%
    )
   )> "%TEMP%\%~n0_Help"
   Type "%TEMP%\%~n0_Help" > Con
   <Nul Set /p "=%\E%[?25h"
   Exit /B -1
  )Else (
   Findstr /BLIC:":%~1 " "%~f0" >nul && (
    Echo(%\E%[36mSyntax: %\E%[0m^<%\E%[31mMandatory%\E%[0m^> [%\E%[32mOptional%\E%[0m] {%\E%[33mMutually^%\E%[0m^|%\E%[33mExclusive%\E%[0m}
    <nul Set /P "=%\E%[K %~1 Usage:%\E%[2E Call "
    Findstr /BLIC:":%~1 " "%Buttons_File%"
    Echo(%\E%[?25h
    Exit /B -1
   ) || (
    Echo(Help query '%~1' does not match any existing Macro or Function.
    Echo(Check your Spelling and try again.%\E%[?25h
    Exit /B -1
   )
  )
 )Else (
  Echo(%\E%[33mDelayed Expansion %\E%[31mmust not %\E%[33mbe enabled prior to running %\E%[36m%~nx0%\E%[0m%\E%[?25h
  Exit /B -1
 )
Goto :eof
 
============
:# Functions
======
:YesNo      ["Option 1"] ["Prompt 2"] ["Spoken Prompt"]
:# Default:     Yes           No
 
 %Buffer:@=Alt%
 If not "%~3"=="" start /b "" PowerShell -Nop -ep Bypass -C "Add-Type –AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('%~3');
 
 If "%~1"=="" %Make.Btn% YN /N /S "Yes" /Y 3 /X 3 /FG 0 0 0 /BG 255 0 0 /BO 38 2 60 0 0 + 48 2 20 20 40
 If not "%~1"=="" %Make.Btn% YN /N /S "%~1" /Y 3 /X 3 /FG 0 0 0 /BG 255 0 0 /BO 38 2 60 0 0 + 48 2 20 20 40
 If "%~2"=="" %Make.Btn% YN /S "No" /Y 3 /FG 0 0 0 /BG 0 255 0 /BO 38 2 0 60 0 + 48 2 20 20 40
 If not "%~2"=="" %Make.Btn% YN /S "%~2" /Y 3 /FG 0 0 0 /BG 0 255 0 /BO 38 2 0 60 0 + 48 2 20 20 40
 
:YesNoWait
 %Get.Click% YN
 If defined ValidClick[YN] (
  %Buffer:@=Main%
 )Else Goto :YesNoWait
 %If.Btn[YN]%[1] Exit /B 1
 %If.Btn[YN]%[2] Exit /B 2
 
=========
:ColorMod <Prefixvar.Extension> [-l]
:# Prefix var doubles as the name of the Alternate data stream color variables as saved to / loaded from
:# values returned:
:# prefixvar.ext.FG.Color prefixvar.ext.BG.Color
:# prefixvar.ext_FG_Red prefix.var_FG_Blue prefix.var_FG_Green
:# prefixvar.ext_BG_Red prefix.var_BG_Blue prefix.var_BG_Green
:#
 %Buffer:@=Alt%
 If Not "%~1" == "" Set "Type=%~1"
 
:# load any existing saved values.
 (For /F "UsebackQ Delims=" %%G in ("%~f0:%Type%")Do %%G) 2> nul
 If /I "%~2"=="-l" Goto :Eof
 
 If "!%Type%_FG_Red!"=="" If "!%Type%_BG_Red!"=="" (
  For %%Z in ("FG" "BG")Do (
   If not defined %Type%.%%~Z.Color (
    Cls & Echo(Defalut value for %Type%.%%~Z.Color must be defined in format rrr;ggg;bbb
    Pause
    Exit
   )
   For /F "Tokens=1,2,3 Delims=;" %%1 in ("!%Type%.%%~Z.Color!")Do (
    Set "%Type%_%%~Z_Red=%%1"
    Set "%Type%_%%~Z_Green=%%2"
    Set "%Type%_%%~Z_Blue=%%3"
 )))
 
 If "!%Type%_Zone!" == "" Set "%Type%_Zone=BG"
 If "!%Type%_Spectrum!" == "" Set "%Type%_Spectrum=%Type%_!%Type%_Zone!_Blue"
 
:# definition of /d switch assigns default toggle state to last stored value; or default value if no value stored.
 
%= [CMcolor][1] =%       %Make.btn% CMcolor /s Red /y 3 /x 3 /fg 255 0 0 /bg 0 0 0 /bo 48 2 0 0 0 + 38 2 255 255 255 /tm /cd %Type%_Spectrum /N
%= [CMcolor][2] =%       %Make.btn% CMcolor /s Green /y 3 /fg 0 255 0 /bg 0 0 0 /bo 48 2 0 0 0 + 38 2 255 255 255 /tm /cd %Type%_Spectrum
%= [CMcolor][3] =%       %Make.btn% CMcolor /s Blue /y 3 /fg 0 0 255 /bg 0 0 0 /bo 48 2 0 0 0 + 38 2 255 255 255 /tm /cd %Type%_Spectrum
 
%= [CMzone][1] =%        %Make.btn% CMzone /s FG /y 6 /x 3 /tm /bo 48 2 0 0 0 + 38 2 255 255 255 /cd %Type%_Zone /N
%= [CMzone][2] =%        %Make.btn% CMzone /s BG /y 6 /x 7 /bo 48 2 0 0 0 + 38 2 255 255 255 /tm /cd %Type%_Zone
 
%= [CMcontrol][2] =%         %Make.btn% CMcontrol /s " ▲   " /y 6 /x 11 /fg 255 255 255 /bg 50 20 50 /bo 33 /N
%= [CMcontrol][3] =%         %Make.btn% CMcontrol /s " ▼   " /y 6 /fg 255 255 255 /bg 50 20 50 /bo 33
%= [CMcontrol][1] =%         %Make.btn% CMcontrol /s "     Accept       " /bg 180 160 0 /bo 32 /y 9 /x 3
 
:ColorModLoop
 Set "%Type%.FG.Color=!%Type%_FG_Red!;!%Type%_FG_Green!;!%Type%_FG_Blue!"
 Set "%Type%.BG.Color=!%Type%_BG_Red!;!%Type%_BG_Green!;!%Type%_BG_Blue!"
 
 <nul Set /P "=%\E%[13d%\E%[G%\E%[38;2;255;255;255m%\E%[48;2;!%Type%.BG.Color!m%Type% FG: %\E%[38;2;!%Type%.FG.Color!m!%Type%_FG_Red!;!%Type%_FG_Green!;!%Type%_FG_Blue! %\E%[38;2;255;255;255mBG:%\E%[38;2;!%Type%.FG.Color!m!%Type%_BG_Red!;!%Type%_BG_Green!;!%Type%_BG_Blue!%\E%[0m%\E%[K"
 
 %Get.Click% CMzone CMcolor CMcontrol
 If not defined Group Goto :ColorModLoop
 
 If not "%Group%" == "CMcontrol" %Toggle.If.Not% !ValidClick[%Group%]!
 
 If "%Group%"=="CMzone" (
  Set "%Type%_Zone=!Clicked[%Group%]!"
  If "!Clicked[%Group%]!"=="FG" (
   Set "%Type%_Spectrum=!%Type%_Spectrum:BG=FG!"
  )Else Set "%Type%_Spectrum=!%Type%_Spectrum:FG=BG!"
 )
 
 If "%Group%"=="CMcolor" Set "%Type%_Spectrum=%Type%_!%Type%_Zone!_!Clicked[%Group%]!"
 
 For /f "Delims=" %%G in ("!%Type%_Spectrum!") Do (
  %If.Btn[CMcontrol]%[1] (
   If not !%%G! EQU 255 ( Set /A "%%G+=5" )Else Start /b "" %BG.exe% play "%WINDIR%\Media\Windows Error.wav"
  )
  %If.Btn[CMcontrol]%[2] (
   If not !%%G! EQU 0 ( Set /A "%%G-=5" )Else Start /b "" %BG.exe% play "%WINDIR%\Media\Windows Error.wav"
 ))
 
:# Update stored Color values in alternate data stream
 (For /f "Delims=" %%G in ('Set %Type%')Do Echo(Set "%%G") >"%~f0:%Type%"
 
 %If.Btn[CMcontrol]%[3] (
  %Buffer:@=Main%
  Goto :Eof
 )
 
Goto :ColorModLoop
 
 
==========
:ShowState <GroupName>
 %Buffer:@=Alt%
 For %%G in (%*)Do (
  For /l %%i in (1 1 !Btns[%%~G][i]!)Do If defined Btn[%%~G][%%i]{t} Echo(Btn[%%~G][%%i]{state}=!Btn[%%~G][%%i]{state}!
 )
 Timeout /T 15
 %Buffer:@=Main%
 Cls
Goto :eof
 
==========================
:# REQUIRED UTILITY BG.exe
:# - Allows mouse click to be accepted [ blocking input ]
:# - Allows .Wav files to be played
:# - Refer to the documentation at the github repository for all usage options. [ link below ]
 
/* BG.exe V 3.9
  https://github.com/carlos-montiers/consolesoft-mirror/blob/master/bg/README.md
  Copyright (C) 2010-2018 Carlos Montiers Aguilera
 
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
 
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
 
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
 
  Carlos Montiers Aguilera
  cmontiers@gmail.com
 */
 
-----BEGIN CERTIFICATE-----
TVqQAAMAAAAEAAAA//8AALgAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAgAAAAA4fug4AtAnNIbgBTM0hVGhpcyBwcm9ncmFtIGNhbm5v
dCBiZSBydW4gaW4gRE9TIG1vZGUuDQ0KJAAAAAAAAABQRQAATAEEAG3tp1sAAAAA
AAAAAOAADwMLAQIZABoAAAAIAAAAAgAAcCcAAAAQAAAAAMD/AABAAAAQAAAAAgAA
BAAAAAEAAAAEAAAAAAAAAABgAAAABAAAu00AAAMAAAAAACAAABAAAAAAEAAAEAAA
AAAAABAAAAAAAAAAAAAAAABQAABMBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAD4UAAAlAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC50ZXh0AAAA
IBkAAAAQAAAAGgAAAAQAAAAAAAAAAAAAAAAAACAAUGAucmRhdGEAALgBAAAAMAAA
AAIAAAAeAAAAAAAAAAAAAAAAAABAAGBALmJzcwAAAACMAAAAAEAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAgABgwC5pZGF0YQAATAQAAABQAAAABgAAACAAAAAAAAAAAAAA
AAAAAEAAMMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
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
/yU8UUAAkJD/JThRQACQkP8lNFFAAJCQ/yUwUUAAkJD/JSxRQACQkP8lKFFAAJCQ
/yUkUUAAkJD/JSBRQACQkP8lHFFAAJCQ/yUYUUAAkJD/JRRRQACQkP8lEFFAAJCQ
/yUMUUAAkJD/JQhRQACQkP8lBFFAAJCQ/yUAUUAAkJD/JfxQQACQkP8l+FBAAJCQ
/////wAAAAD/////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
QwBPAE4ATwBVAFQAJAAAAEsARQBSAE4ARQBMADMAMgAuAEQATABMAAAAU2V0Q3Vy
cmVudENvbnNvbGVGb250RXgAVABlAHIAbQBpAG4AYQBsAAAAJQBkACAAJQBkACAA
JQBkACAAJQBkACAAJQBkACAAJQBkACAAJQBkACAAJQBkAAoAAABDAE8ATgBJAE4A
JAAAACUAZAAgACUAZAAKAAAAAABQAFIASQBOAFQAAABGAEMAUABSAEkATgBUAAAA
QwBPAEwATwBSAAAATABPAEMAQQBUAEUAAABMAEEAUwBUAEsAQgBEAAAASwBCAEQA
AABNAE8AVQBTAEUAAABEAEEAVABFAFQASQBNAEUAAABTAEwARQBFAFAAAABDAFUA
UgBTAE8AUgAAAEYATwBOAFQAAABQAEwAQQBZAAAAAACkMEAAACZAALAwQACAG0AA
wDBAANAaQADMMEAAwBlAANowQABgGUAA6jBAABAZQADyMEAAIBhAAP4wQACwF0AA
EDFAAGAXQAAcMUAAYBZAACoxQAAwFEAANDFAAIATQABHQ0M6ICh0ZG02NC0xKSA1
LjEuMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkUAAAAAAAAAAAAADcUwAA
+FAAALBQAAAAAAAAAAAAACBUAABEUQAA6FAAAAAAAAAAAAAAMFQAAHxRAADwUAAA
AAAAAAAAAABAVAAAhFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjFEAAJpRAACoUQAA
tlEAAMRRAADcUQAA7lEAAAxSAAAcUgAALlIAAD5SAABSUgAAalIAAIZSAACYUgAA
qlIAAMRSAADMUgAAAAAAAOJSAAD0UgAA/lIAAAhTAAAQUwAAGlMAACZTAAAyUwAA
PFMAAEhTAABUUwAAXlMAAGhTAAAAAAAAclMAAAAAAACEUwAAAAAAAIxRAACaUQAA
qFEAALZRAADEUQAA3FEAAO5RAAAMUgAAHFIAAC5SAAA+UgAAUlIAAGpSAACGUgAA
mFIAAKpSAADEUgAAzFIAAAAAAADiUgAA9FIAAP5SAAAIUwAAEFMAABpTAAAmUwAA
MlMAADxTAABIUwAAVFMAAF5TAABoUwAAAAAAAHJTAAAAAAAAhFMAAAAAAABTAENs
b3NlSGFuZGxlAJIAQ3JlYXRlRmlsZVcAGgFFeGl0UHJvY2VzcwBkAUZyZWVMaWJy
YXJ5AKQBR2V0Q29uc29sZUN1cnNvckluZm8AALABR2V0Q29uc29sZU1vZGUAALYB
R2V0Q29uc29sZVNjcmVlbkJ1ZmZlckluZm8AAAQCR2V0TG9jYWxUaW1lAABFAkdl
dFByb2NBZGRyZXNzAAAsA0xvYWRMaWJyYXJ5VwAApQNSZWFkQ29uc29sZUlucHV0
VwDzA1NldENvbnNvbGVDdXJzb3JJbmZvAAD1A1NldENvbnNvbGVDdXJzb3JQb3Np
dGlvbgAA9wNTZXRDb25zb2xlRm9udAAAAQRTZXRDb25zb2xlTW9kZQAACgRTZXRD
b25zb2xlVGV4dEF0dHJpYnV0ZQB0BFNsZWVwAOwEV3JpdGVDb25zb2xlT3V0cHV0
VwB3AF9fd2dldG1haW5hcmdzAAAFAV9maWxlbm8AOwFfZ2V0Y2gAAGEBX2lvYgAA
xAFfa2JoaXQAALUCX3NldG1vZGUAAI0DX3djc2ljbXAAAEsEZnB1dHdjAAB1BGlz
d2N0eXBlAACqBHNldGxvY2FsZQD0BHdjc2NweQAABwV3Y3N0b2wAAA4Fd3ByaW50
ZgDIAU9lbVRvQ2hhckJ1ZmZXAAAJAFBsYXlTb3VuZFcAAAAAAFAAAABQAAAAUAAA
AFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAA
AFAAAABQAAAAUAAAS0VSTkVMMzIuZGxsAAAAABRQAAAUUAAAFFAAABRQAAAUUAAA
FFAAABRQAAAUUAAAFFAAABRQAAAUUAAAFFAAABRQAABtc3ZjcnQuZGxsAAAoUAAA
VVNFUjMyLmRsbAAAPFAAAFdJTk1NLkRMTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
-----END CERTIFICATE-----
 
=========================
:Main Script body
=========================
 
:# Enable Macros; facilitate nested variables !element[%index%]!
 Setlocal enableDelayedExpansion
 
:# Ensure no Existing variables prefixed 'Btn'
 For /f "Tokens=1,2 Delims==" %%G in ('Set Btn 2^> nul')Do Set "%%G="
 
 Set /A "Density=4", "minX=5", "maxX=45", "minY=5", "maxY=20"
 Set "Live.Cell.Char=╬"
 Set "Live.Cell.Char[i]=20"
 
 For %%z in (Live Dead)Do Call :ColorMod %%z.cell -l
 
 If "!Live.Cell.FG.Color!"=="" Set "Live.Cell.FG.Color=250;70;0"
 If "!Live.Cell.BG.Color!"=="" Set "Live.Cell.BG.Color=0;80;160"
 If "!Dead.Cell.FG.Color!"=="" Set "Dead.Cell.FG.Color=20;30;40"
 If "!Dead.Cell.BG.Color!"=="" Set "Dead.Cell.BG.Color=0;0;0"
 
%= [demo][1] =% %Make.Btn% demo /S Option One /t
%= [demo][2] =% %Make.Btn% demo /S Option Two /t
%= [demo][3] =% %Make.Btn% demo /S Option Three /t
%= [demo][4] =% %Make.Btn% demo /S "    Exit      " /bo 38 2 190 160 0 + 48 2 40 0 0 /bg 40 0 0 /fg 40 200 40
 
:loop
 
%= [CellCol][1] =% %Make.Btn% CellCol /S Live.Cell /X 20/fg %!!% /bg %!!% /bo 33 /N
%= [CellCol][2] =% %Make.Btn% CellCol /S Dead.Cell /fg %!!% /bg %!!% /bo 33
 
 %Get.Click% demo CellCol
 
rem Title Y;X:!C{pos}! C:!Clicked[%Group%]! VC:!ValidClick[%Group%]!
 %If.btn[demo]%[4] (
  Call :YesNo Yes No "Are you sure?"
  If "!Clicked[YN]!" == "Yes" (
   cls
   Set btn[ | findstr /lic:"{state}"
   Pause
   %Clean.Exit%
  )
 ) 
 If "%Group%"=="CellCol" Call :ColorMod !Clicked[CellCol]!
 
Goto :loop
