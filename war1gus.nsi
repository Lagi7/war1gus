;       _________ __                 __
;      /   _____//  |_____________ _/  |______     ____  __ __  ______
;      \_____  \\   __\_  __ \__  \\   __\__  \   / ___\|  |  \/  ___/
;      /        \|  |  |  | \// __ \|  |  / __ \_/ /_/  >  |  /\___ |
;     /_______  /|__|  |__|  (____  /__| (____  /\___  /|____//____  >
;             \/                  \/          \//_____/            \/
;  ______________________                           ______________________
;                        T H E   W A R   B E G I N S
;         Stratagus - A free fantasy real time strategy game engine
;
;    war1gus.nsi - Windows NSIS Installer for War1gus
;    Copyright (C) 2010-2014  Pali Rohar <pali.rohar@gmail.com>, cybermind <cybermindid@gmail.com>
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 2 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;

;--------------------------------

!ifdef QUIET
!verbose 2
!endif

!define redefine "!insertmacro redefine"
!macro redefine symbol value
!undef ${symbol}
!define ${symbol} "${value}"
!macroend

!include "MUI2.nsh"
!include "Sections.nsh"

;--------------------------------

; General variables
!define NAME "War1gus"
!define VERSION "2.4"
!define VIVERSION "${VERSION}.0.0"
!define HOMEPAGE "https://github.com/wargus/war1gus"
!define LICENSE "GPL v2"
!define COPYRIGHT "Copyright (c) 1998-2015 by The Stratagus Project"
!define STRATAGUS_NAME "Stratagus"
!define STRATAGUS_HOMEPAGE "https://github.com/wargus/stratagus"

;--------------------------------

!define ICON "war1gus.ico"
!define EXE "war1gus.exe"
!define WARTOOL "war1tool.exe"
!define UNINSTALL "uninstall.exe"
!define INSTALLER "${NAME}-${VERSION}.exe"
!define INSTALLDIR "$PROGRAMFILES\${NAME}\"

; Installer for x86-64 systems
!ifdef x86_64
${redefine} INSTALLER "${NAME}-${VERSION}-x86_64.exe"
${redefine} INSTALLDIR "$PROGRAMFILES64\${NAME}\"
${redefine} NAME "Wargus (64 bit)"
${redefine} STRATAGUS_NAME "Stratagus (64 bit)"
!endif

; Registry paths
!define REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
!define STRATAGUS_REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${STRATAGUS_NAME}"

;--------------------------------

; Download and extract nessesary 3rd party programs
!ifndef NO_DOWNLOAD
!endif

!addplugindir .

;--------------------------------

Var STARTMENUDIR
Var DATADIR
Var EXTRACTNEEDED

Var OptDataset
Var OptMusic
Var DataDirectory

!define MUI_ICON "${ICON}"
!define MUI_UNICON "${ICON}"

; Installer pages

!define MUI_ABORTWARNING
!define MUI_LANGDLL_ALLLANGUAGES
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!define MUI_FINISHPAGE_RUN "$INSTDIR\${EXE}"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOREBOOTSUPPORT
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${REGKEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "StartMenu"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "COPYING"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY

!define MUI_PAGE_HEADER_TEXT "$(EXTRACTDATA_PAGE_HEADER_TEXT)"
!define MUI_PAGE_HEADER_SUBTEXT "$(EXTRACTDATA_PAGE_HEADER_SUBTEXT)"
!define MUI_DIRECTORYPAGE_TEXT_TOP "$(EXTRACTDATA_PAGE_TEXT_TOP)"
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "$(EXTRACTDATA_PAGE_TEXT_DESTINATION)"
!define MUI_DIRECTORYPAGE_VARIABLE $DATADIR
!define MUI_DIRECTORYPAGE_VERIFYONLEAVE
!define MUI_PAGE_CUSTOMFUNCTION_PRE PageExtractDataPre
!define MUI_PAGE_CUSTOMFUNCTION_SHOW PageExtractDataShow
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE PageExtractDataLeave
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_STARTMENU Application $STARTMENUDIR
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Available languages
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Russian"

!insertmacro MUI_RESERVEFILE_LANGDLL

; Language-dependent strings
LangString INSTALLER_RUNNING ${LANG_ENGLISH} "${NAME} Installer is already running"
LangString INSTALLER_RUNNING ${LANG_RUSSIAN} "���������� ${NAME} ��� �������"
LangString NO_STRATAGUS ${LANG_ENGLISH} "${STRATAGUS_NAME} ${VERSION} is not installed.$\nYou need ${STRATAGUS_NAME} ${VERSION} to run ${NAME}!$\nFirst install ${STRATAGUS_NAME} ${VERSION} from ${STRATAGUS_HOMEPAGE}"
LangString NO_STRATAGUS ${LANG_RUSSIAN} "${STRATAGUS_NAME} ${VERSION} is not installed.$\nYou need ${STRATAGUS_NAME} ${VERSION} to run ${NAME}!$\nFirst install ${STRATAGUS_NAME} ${VERSION} from ${STRATAGUS_HOMEPAGE}"
LangString REMOVEPREVIOUS ${LANG_ENGLISH} "Removing previous installation"
LangString REMOVEPREVIOUS ${LANG_RUSSIAN} "��������� ����� �� ���������� ���������"
LangString REMOVECONFIGURATION ${LANG_ENGLISH} "Removing configuration and data files:"
LangString REMOVECONFIGURATION ${LANG_RUSSIAN} "��������� ������ � ����� ������������:"
LangString DESC_REMOVEEXE ${LANG_ENGLISH} "Remove ${NAME} binary executables"
LangString DESC_REMOVEEXE ${LANG_RUSSIAN} "��������� ����������� ����� ${NAME}"
LangString DESC_REMOVECONF ${LANG_ENGLISH} "Remove all other configuration and extracted data files and directories in ${NAME} install directory created by user or ${NAME}"
LangString DESC_REMOVECONF ${LANG_RUSSIAN} "������� ��� ������ ����� � ���������� � ������������ ����� ${NAME}, ��������� ������������� ${NAME}"

LangString EXTRACTDATA_FILES ${LANG_ENGLISH} "Extracting Warcraft II data files..."
LangString EXTRACTDATA_FILES ${LANG_RUSSIAN} "����������� ����� Warcraft II..."
LangString EXTRACTDATA_RIP_AUDIO ${LANG_ENGLISH} "Ripping Warcraft II audio tracks..."
LangString EXTRACTDATA_RIP_AUDIO ${LANG_RUSSIAN} "���������� CD-������ Warcraft II..."
LangString EXTRACTDATA_COPY_AUDIO ${LANG_ENGLISH} "Coping Warcraft II audio tracks..."
LangString EXTRACTDATA_COPY_AUDIO ${LANG_RUSSIAN} "���������� ������ Warcraft II..."
LangString EXTRACTDATA_CONVERT_AUDIO ${LANG_ENGLISH} "Converting Warcraft II audio tracks..."
LangString EXTRACTDATA_CONVERT_AUDIO ${LANG_RUSSIAN} "�������������� ������ Warcraft II..."

LangString EXTRACTDATA_FILES_FAILED ${LANG_ENGLISH} "Extracting Warcraft II data files failed."
LangString EXTRACTDATA_FILES_FAILED ${LANG_RUSSIAN} "�� ������� ������� ����� Warcraft II."
LangString EXTRACTDATA_RIP_AUDIO_FAILED ${LANG_ENGLISH} "Ripping Warcraft II audio tracks failed."
LangString EXTRACTDATA_RIP_AUDIO_FAILED ${LANG_RUSSIAN} "�� ������� ����������� CD-������ Warcraft II."
LangString EXTRACTDATA_COPY_AUDIO_FAILED ${LANG_ENGLISH} "Coping Warcraft II audio tracks failed."
LangString EXTRACTDATA_COPY_AUDIO_FAILED ${LANG_RUSSIAN} "�� ������� ����������� ������ Warcraft II."
LangString EXTRACTDATA_CONVERT_AUDIO_FAILED ${LANG_ENGLISH} "Converting Warcraft II audio tracks failed."
LangString EXTRACTDATA_CONVERT_AUDIO_FAILED ${LANG_RUSSIAN} "�� ������� ��������������� ������ Warcraft II."

LangString EXTRACTDATA_PAGE_HEADER_TEXT ${LANG_ENGLISH} "Choose Warcraft II Location"
LangString EXTRACTDATA_PAGE_HEADER_TEXT ${LANG_RUSSIAN} "������� �������������� Warcraft II"
LangString EXTRACTDATA_PAGE_HEADER_SUBTEXT ${LANG_ENGLISH} "Choose the folder in which are Warcraft II data files."
LangString EXTRACTDATA_PAGE_HEADER_SUBTEXT ${LANG_RUSSIAN} "������� �����, � ������� ���������� ����� Warcraft II."
LangString EXTRACTDATA_PAGE_TEXT_TOP ${LANG_ENGLISH} "Setup will extract Warcraft II data files from the following folder. You can specify location of CD or install location of Warcraft II data files (doesn't work for Battle.net edition)."
LangString EXTRACTDATA_PAGE_TEXT_TOP ${LANG_RUSSIAN} "��������� ��������� �������� ����� Warcraft II �� ��������� �����. �� ������ ������� ���� CD-���� � �����, ���� ������� ����� � ������������� Warcraft II (�� �������� ��� ������ Battle.net)."
LangString EXTRACTDATA_PAGE_TEXT_DESTINATION ${LANG_ENGLISH} "Source Folder"
LangString EXTRACTDATA_PAGE_TEXT_DESTINATION ${LANG_RUSSIAN} "����� � ������� Warcraft II"
LangString EXTRACTDATA_PAGE_NOT_VALID ${LANG_ENGLISH} "This is not valid Warcraft II data directory."
LangString EXTRACTDATA_PAGE_NOT_VALID ${LANG_RUSSIAN} "��������� ��������� �� ���������� Warcraft II � ��������� �����."

LangString STR_VERSION ${LANG_ENGLISH} "version"
LangString STR_VERSION ${LANG_RUSSIAN} "������"

!ifdef x86_64
LangString x86_64_ONLY ${LANG_ENGLISH} "This version is for 64 bits computers only"
LangString x86_64_ONLY ${LANG_RUSSIAN} "��� ������ ������������� ��� 64-������ ������"
!endif

;--------------------------------

Name "${NAME}"
Icon "${ICON}"
OutFile "${INSTALLER}"
InstallDir "${INSTALLDIR}"
InstallDirRegKey HKLM "${REGKEY}" "InstallLocation"

VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${NAME} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "InternalName" "${NAME} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${COPYRIGHT}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "License" "${LICENSE}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Homepage" "${HOMEPAGE}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "OriginalFilename" "${INSTALLER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${NAME} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${VERSION}"
VIProductVersion "${VIVERSION}"

BrandingText "${NAME}, $(STR_VERSION) ${VERSION}  ${HOMEPAGE}"
ShowInstDetails Show
ShowUnInstDetails Show
XPStyle on
RequestExecutionLevel admin

ReserveFile "${WARTOOL}"

;--------------------------------

Section "${NAME}"
	SectionIn RO
SectionEnd

SectionGroup "Data set" dataset
	Section "Warcraft 2" opt1Warcraft
	SectionEnd

	Section /o "Aleona Tales" opt1AT
	SectionEnd
SectionGroupEnd

SectionGroup "Music" music
	Section  "MIDI music" opt2MIDI
	SectionEnd

	Section /o "CD Music" opt2CD
	SectionEnd
SectionGroupEnd

Section "-${NAME}" UninstallPrevious

	SectionIn RO

	ReadRegStr $0 HKLM "${REGKEY}" "InstallLocation"
	StrCmp $0 "" +7

	DetailPrint "$(REMOVEPREVIOUS)"
	SetDetailsPrint none
	ExecWait "$0\${UNINSTALL} /S _?=$0"
	Delete "$0\${UNINSTALL}"
	RMDir $0
	SetDetailsPrint lastused

SectionEnd

Section "-${NAME}"

	SectionIn RO

	SetOutPath "$INSTDIR"
	File "${EXE}"
	File "${WARTOOL}"

	ClearErrors

	!cd ${CMAKE_CURRENT_SOURCE_DIR}

	SetOutPath "$INSTDIR\maps"
	File /r /x *.pud* "maps\"
	SetOutPath "$INSTDIR\scripts"
	File /r "scripts\"
	SetOutPath "$INSTDIR\campaigns"
	File /r "campaigns\"
	StrCmp $OptDataset  ${opt1Warcraft} optwar2
	SetOutPath "$INSTDIR\graphics"
	File /r "graphics\"
	SetOutPath "$INSTDIR\music"
	File /r "music\"
	SetOutPath "$INSTDIR\sounds"
	File /r "sounds\"
optwar2:
	SetOutPath "$INSTDIR"

	CreateDirectory "$INSTDIR\music"
	CreateDirectory "$INSTDIR\graphics"
	CreateDirectory "$INSTDIR\graphics\ui"
	CreateDirectory "$INSTDIR\graphics\ui\cursors"
	CreateDirectory "$INSTDIR\graphics\missiles"
	
	File "/oname=music\${SF2BANK}" "${SF2BANK}"
	File "/oname=graphics\ui\cursors\cross.png" "contrib\cross.png"
	File "/oname=graphics\missiles\red_cross.png" "contrib\red_cross.png"
	File "/oname=graphics\ui\mana.png" "contrib\mana.png"
	File "/oname=graphics\ui\mana2.png" "contrib\mana2.png"
	File "/oname=graphics\ui\health.png" "contrib\health.png"
	File "/oname=graphics\ui\health2.png" "contrib\health2.png"
	File "/oname=graphics\ui\food.png" "contrib\food.png"
	File "/oname=graphics\ui\score.png" "contrib\score.png"
	File "/oname=graphics\ui\ore,stone,coal.png" "contrib\ore,stone,coal.png"

	!cd ${CMAKE_CURRENT_BINARY_DIR}

	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
	CreateDirectory "$SMPROGRAMS\$STARTMENUDIR"
	CreateShortCut "$SMPROGRAMS\$STARTMENUDIR\${NAME}.lnk" "$INSTDIR\${EXE}"
	CreateShortCut "$SMPROGRAMS\$STARTMENUDIR\Uninstall.lnk" "$INSTDIR\${UNINSTALL}"
	CreateShortcut "$DESKTOP\${NAME}.lnk" "$INSTDIR\${EXE}"
	!insertmacro MUI_STARTMENU_WRITE_END

	WriteRegStr HKLM "${REGKEY}" "DisplayName" "${NAME}"
	WriteRegStr HKLM "${REGKEY}" "UninstallString" "$\"$INSTDIR\${UNINSTALL}$\""
	WriteRegStr HKLM "${REGKEY}" "QuietUninstallString" "$\"$INSTDIR\${UNINSTALL}$\" /S"
	WriteRegStr HKLM "${REGKEY}" "InstallLocation" "$INSTDIR"
	WriteRegStr HKLM "${REGKEY}" "DisplayIcon" "$\"$INSTDIR\${EXE}$\",0"
	WriteRegStr HKLM "${REGKEY}" "DisplayVersion" "${VERSION}"
	WriteRegStr HKLM "${REGKEY}" "HelpLink" "${HOMEPAGE}"
	WriteRegStr HKLM "${REGKEY}" "URLUpdateInfo" "${HOMEPAGE}"
	WriteRegStr HKLM "${REGKEY}" "URLInfoAbout" "${HOMEPAGE}"
	WriteRegDWORD HKLM "${REGKEY}" "NoModify" 1
	WriteRegDWORD HKLM "${REGKEY}" "NoRepair" 1
	WriteRegStr HKLM "${REGKEY}" "DataDir" "$DATADIR"
	WriteRegStr HKLM "${STRATAGUS_REGKEY}\Games" "${NAME}" "${VERSION}"

	WriteUninstaller "$INSTDIR\${UNINSTALL}"

SectionEnd

;--------------------------------

Function PageExtractDataPre

    ; Checks if War1gus has been already extracted and skips the extraction stage
	StrCmp $OptDataset  ${opt1AT} noextract
	File "/oname=$TEMP\${WARTOOL}" "${WARTOOL}"

	ClearErrors
	FileOpen $0 "$INSTDIR\extracted" "r"
	IfErrors extract

	FileRead $0 $1
	FileClose $0

	ExecDos::exec /TOSTACK "$\"$TEMP\${WARTOOL}$\" -V"
	Pop $0
	Pop $2
	Delete "$TEMP\${WARTOOL}"

	IntCmp $0 0 0 0 extract

	StrCmp $1 $2 noextract

	StrCpy $2 "$2$\r$\n"
	StrCmp $1 $2 0 extract


noextract:

	StrCpy $EXTRACTNEEDED "no"
	Abort

extract:

	StrCpy $EXTRACTNEEDED "yes"

FunctionEnd

Function PageExtractDataShow

	FindWindow $0 "#32770" "" $HWNDPARENT
	GetDlgItem $1 $0 1023
	ShowWindow $1 0
	GetDlgItem $1 $0 1024
	ShowWindow $1 0

FunctionEnd

Function PageExtractDataLeave

	IfFileExists "$DATADIR\data\rezdat.war" +4
	IfFileExists "$DATADIR\SUPPORT\TOMES\TOME.1" +3

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_PAGE_NOT_VALID)"
	Abort

FunctionEnd

Var KeyStr
Section "-${NAME}" ExtractData
	
	StrCmp "$EXTRACTNEEDED" "no" end

	AddSize 110348

	DetailPrint ""
	DetailPrint "$(EXTRACTDATA_FILES)"
	StrCpy $DataDirectory "$DATADIR"
	IfFileExists "$DATADIR\SUPPORT\TOMES\TOME.1" +2
	StrCpy $DataDirectory "$\"$DATADIR\data$\""
	
	DetailPrint "$DataDirectory"
	StrCmp $OptMusic "${opt2CD}" 0 +2
	StrCpy $KeyStr "$KeyStr -r"
	ExecDos::exec /DETAILED "$\"$INSTDIR\${WARTOOL}$\" $KeyStr -v $\"$DataDirectory$\" $\"$INSTDIR$\""
	Pop $0
	IntCmp $0 0 +3

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_FILES_FAILED)"
	Abort

end:

SectionEnd

;--------------------------------

Section "un.${NAME}" Executable

	SectionIn RO

	Delete "$INSTDIR\${EXE}"
	Delete "$INSTDIR\${WARTOOL}"
	Delete "$INSTDIR\${UNINSTALL}"

	IfFileExists "$INSTDIR\scripts\wc2-config.lua" 0 +2
	Rename "$INSTDIR\scripts\wc2-config.lua" "$INSTDIR\wc2-config.lua"

	RMDir /r "$INSTDIR\scripts"

	IfFileExists "$INSTDIR\wc2-config.lua" 0 +3
	CreateDirectory "$INSTDIR\scripts"
	Rename "$INSTDIR\wc2-config.lua" "$INSTDIR\scripts\wc2-config.lua"

	Delete "$INSTDIR\campaigns\human\level*h_c.sms"
	Delete "$INSTDIR\campaigns\orc\level*o_c.sms"
	Delete "$INSTDIR\campaigns\human-exp\levelx*h_c.sms"
	Delete "$INSTDIR\campaigns\orc-exp\levelx*o_c.sms"
	RMDir "$INSTDIR\campaigns\human"
	RMDir "$INSTDIR\campaigns\orc"
	RMDir "$INSTDIR\campaigns\human-exp"
	RMDir "$INSTDIR\campaigns\orc-exp"
	RMDir "$INSTDIR\campaigns"
	RMDir "$INSTDIR"

	!insertmacro MUI_STARTMENU_GETFOLDER Application $STARTMENUDIR
	Delete "$SMPROGRAMS\$STARTMENUDIR\${NAME}.lnk"
	Delete "$SMPROGRAMS\$STARTMENUDIR\Uninstall.lnk"
	RMDir "$SMPROGRAMS\$STARTMENUDIR"
	Delete "$DESKTOP\${NAME}.lnk"

	DeleteRegKey HKLM "${REGKEY}"
	DeleteRegValue HKLM "${STRATAGUS_REGKEY}\Games" "${NAME}"

	ClearErrors
	EnumRegValue $0 HKLM "${REGKEY}\Games" 0
	IfErrors +2

	DeleteRegKey /ifempty HKLM "${STRATAGUS_REGKEY}\Games"

SectionEnd

Section /o "un.Configuration" Configuration

	DetailPrint "$(REMOVECONFIGURATION)"
	RMDir /r "$INSTDIR"

SectionEnd

!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT "${Executable}" "$(DESC_REMOVEEXE)"
!insertmacro MUI_DESCRIPTION_TEXT "${Configuration}" "$(DESC_REMOVECONF)"
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END

;--------------------------------

Function .onInit
	; Set default components options
	StrCpy $OptDataset ${opt1Warcraft}
	StrCpy $OptMusic ${opt2MIDI}

	; Check if War1gus installer is already running
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 +3

	MessageBox MB_OK|MB_ICONEXCLAMATION "$(INSTALLER_RUNNING)"
	Abort

!ifdef x86_64

	System::Call "kernel32::GetCurrentProcess() i .s"
	System::Call "kernel32::IsWow64Process(i s, *i .r0)"
	IntCmp $0 0 0 0 +3

	MessageBox MB_OK|MB_ICONSTOP "$(x86_64_ONLY)"
	Abort

!endif

	ReadRegStr $DATADIR HKLM "${REGKEY}" "DataDir"
	StrCmp $DATADIR "" 0 +2

	StrCpy $DATADIR "D:"
	!insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function .onSelChange

  !insertmacro StartRadioButtons $OptDataset
    !insertmacro RadioButton ${opt1Warcraft}
    !insertmacro RadioButton ${opt1AT}
  !insertmacro EndRadioButtons
	
  !insertmacro StartRadioButtons $OptMusic
    !insertmacro RadioButton ${opt2CD}
    !insertmacro RadioButton ${opt2MIDI}
  !insertmacro EndRadioButtons
	
FunctionEnd

;--------------------------------

!ifdef UPX

!ifndef UPX_FLAGS
!define UPX_FLAGS "-9"
!else
${redefine} UPX_FLAGS "${UPX_FLAGS} -9"
!endif

!ifdef QUIET
${redefine} UPX_FLAGS "${UPX_FLAGS} -q"
!endif

!packhdr "exehead.tmp" "${UPX} ${UPX_FLAGS} exehead.tmp"

!endif

;!finalize "gpg --armor --sign --detach-sig %1"

;--------------------------------

!ifndef NO_DOWNLOAD
!endif

;--------------------------------
