${SegmentFile}

!addplugindir "${PACKAGE}\App\AppInfo\Launcher"
!addincludedir "${PACKAGE}\App\AppInfo\Launcher"
!include DotNet.nsh

Var AutoCheckUpdate
Var CheckPreReleaseUpdates
Var CustomLanguage

${SegmentInit}
	${If} ${FileExists} "${PACKAGE}\App\ShareX\ShareX\*.*"
		CopyFiles /SILENT "${PACKAGE}\App\ShareX\ShareX\*.*" "${PACKAGE}\Data\ShareX"
		RMDir /r "${PACKAGE}\App\ShareX\ShareX"
	${EndIf}
	${If} ${FileExists} "${PACKAGE}\Data\ShareX\*.*"
		${AndIf} ${FileExists} "${PACKAGE}\Data\Backup\*.*"
		Goto MoveShareXData
	${ElseIf} ${FileExists} "${PACKAGE}\Data\Backup\*.*"
		Goto MoveShareXData
	${EndIf}
	MoveShareXData:
		${If} ${FileExists} "${PACKAGE}\Data\Backup\*.*"
			CopyFiles /SILENT "${PACKAGE}\Data\Backup\*.*" "${PACKAGE}\Data\ShareX\Backup"
			RMDir /r "${PACKAGE}\Data\Backup"
		${OrIf} ${FileExists} "${PACKAGE}\Data\ImageEffects\*.*"
			CopyFiles /SILENT "${PACKAGE}\Data\ImageEffects\*.*" "${PACKAGE}\Data\ShareX\ImageEffects"
			RMDir /r "${PACKAGE}\Data\ImageEffects"
		${OrIf} ${FileExists} "${PACKAGE}\Data\Logs\*.*"
			CopyFiles /SILENT "${PACKAGE}\Data\Logs\*.*" "${PACKAGE}\Data\ShareX\Logs"
			RMDir /r "${PACKAGE}\Data\Logs"
		${OrIf} ${FileExists} "${PACKAGE}\Data\Screenshots\*.*"
			CopyFiles /SILENT "${PACKAGE}\Data\Screenshots\*.*" "${PACKAGE}\Data\ShareX\Screenshots"
			RMDir /r "${PACKAGE}\Data\Screenshots"
		${OrIf} ${FileExists} "${PACKAGE}\Data\Tools\*.*"
			CopyFiles /SILENT "${PACKAGE}\Data\Tools\*.*" "${PACKAGE}\Data\ShareX\Tools"
			RMDir /r "${PACKAGE}\Data\Tools"
		${OrIf} ${FileExists} "${PACKAGE}\Data\ApplicationConfig.json"
			Rename "${PACKAGE}\Data\ApplicationConfig.json" "${PACKAGE}\Data\ShareX\ApplicationConfig.json"
		${OrIf} ${FileExists} "${PACKAGE}\Data\History.json"
			Rename "${PACKAGE}\Data\History.json" "${PACKAGE}\Data\ShareX\History.json"
		${OrIf} ${FileExists} "${PACKAGE}\Data\HotkeysConfig.json"
			Rename "${PACKAGE}\Data\HotkeysConfig.json" "${PACKAGE}\Data\ShareX\HotkeysConfig.json"
		${OrIf} ${FileExists} "${PACKAGE}\Data\UploadersConfig.json"
			Rename "${PACKAGE}\Data\UploadersConfig.json" "${PACKAGE}\Data\ShareX\UplaodersConfig.json"
		${EndIf}


;; Heavily borrowed from PAL's Language.nsh Segment File as ShareX's language handling is in a format similar to PortableApps.comLocaleName, whereas the folders are in a format similar to glibc
	ReadEnvStr $0 PortableApps.comLanguageCode
	ReadEnvStr $1 PAL:_IgnoreLanguage
	${If} $0 == ""
	${OrIf} $1 == true
	
		${SetEnvironmentVariableDefault} PortableApps.comLanguageCode en
		${SetEnvironmentVariableDefault} PortableApps.comLocaleCode2 en
		${SetEnvironmentVariableDefault} PortableApps.comLocaleCode3 eng
		${SetEnvironmentVariableDefault} PortableApps.comLocaleglibc en_US
		${SetEnvironmentVariableDefault} PortableApps.comLocaleID 1033
		${SetEnvironmentVariableDefault} PortableApps.comLocaleWinName LANG_ENGLISH
		ReadEnvStr $0 PortableApps.comLocaleName
		${If} $0 == ""
			ReadEnvStr $0 PortableApps.comLocaleWinName
			StrCpy $0 $0 "" 5 ; Chop off the LANG_
			${SetEnvironmentVariable} PortableApps.comLocaleName $0
		${EndIf}
	
		ClearErrors
		${If} ${FileExists} "${PACKAGE}\Data\ApplicationConfig.json"
		StrCpy $2 "Automatic"
		nsJSON::Set /file "${PACKAGE}\Data\ApplicationConfig.json"
		nsJSON::Get `Language` /end
			Pop $CustomLanguage
				${If} $CustomLanguage != "Automatic"
					System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LanguageCustom", "$CustomLanguage").r0'
				${EndIf}
		${EndIf}
	${EndIf}
	ClearErrors
	ReadEnvStr $3 PAL:LanguageCustom
	${If} ${Errors}
		${ReadLauncherConfig} $4 Language Base
		${If} $4 != ""
			ClearErrors
			${ReadLauncherConfig} $5 LanguageStrings $4
			${If} ${Errors}
				StrCpy $5 $4
			${EndIf}
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LanguageCustom", "$5").r0'
			${If} $5 == "Dutch";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\nl-NL\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "French";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\fr\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "German";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\de\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Hungarian";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\hu\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Indonesian";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\id-ID\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Italian";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\it-IT\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Japanese";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\ja-JP\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Korean";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\ko-KR\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Mexican Spanish";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\es-MX\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Persian";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\fa-IR\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Polish";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\pl\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Portuguese";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\pt-PT\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}	
			${ElseIf} $5 == "Portuguese-Brazil";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\pt-BR\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Romanian";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\ro\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}	
			${ElseIf} $5 == "Russian";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\ru\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Simplified Chinese";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\zh-CN\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Spanish";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\es\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Traditional Chinese";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\zh-TW\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Turkish";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\tr\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Ukrainian";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\uk\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${ElseIf} $5 == "Vietnamese";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\vi-VN\*.*"
					Goto WriteLanguage
				${Else}
					Goto SetToEnglish
				${EndIf}
			${Else}
				SetToEnglish:
					System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LanguageCustom", "English").r0'
					Goto WriteLanguage
			${EndIf}
		${EndIf}
	${EndIf}
	WriteLanguage:
		ReadEnvStr $7 PAL:LanguageCustom
		nsJSON::Set /file "${PACKAGE}\Data\ApplicationConfig.json"
		nsJSON::Set `Language`/value `$7`
		nsJSON::Serialize /file "${PACKAGE}\Data\ApplicationConfig.json"
		
;;	Borrowed from PAL 3.x pending release of PAL update
	; If appinfo.ini\[Dependencies]:UsesDotNetVersion is not empty, search
	; for a .NET Framework install of the specified version. Valid version
	; numbers are:
	;
	;  - (1.0|1.1|2.0|3.0|3.5)[SP<n>]
	;  - 4.0[SP<n>][C|F]
    ;  - (4.5|4.5.1|4.5.2|4.6|4.6.1|4.6.2|4.7|4.7.1|4.7.2|4.8)

	ReadINIStr $0 $EXEDIR\App\AppInfo\appinfo.ini Dependencies UsesDotNetVersion
	${If} $0 != ""
		${IfThen} $0 == 4.0 ${|} StrCpy $0 4.0C ${|}
		${If} ${HasDotNetFramework} $0
			; Required .NET version found
			${DebugMsg} ".NET Framework $0 found"
		${ElseIf} ${Errors}
			; Invalid .NET version
			${InvalidValueError} [Dependencies]:UsesDotNetVersion $0
		${Else}
			; Required .NET version not found
			${DebugMsg} "Unable to find .NET Framework $0"
			MessageBox MB_OK|MB_ICONSTOP `$(LauncherNoDotNet)`
			Quit
		${EndIf}
	${EndIf}
!macroend

${SegmentPreExecPrimary}
	nsJSON::Set /file "${PACKAGE}\Data\ApplicationConfig.json"
	nsJSON::Get `AutoCheckUpdate` /end
		Pop $AutoCheckUpdate
		${If} $AutoCheckUpdate == true
			nsJSON::Set `AutoCheckUpdate` /value `false`
		${EndIf}
	nsJSON::Get `CheckPreReleaseUpdates` /end
		Pop $CheckPreReleaseUpdates
		${If} $CheckPreReleaseUpdates == true
			nsJSON::Set `CheckPreReleaseUpdates` /value `false`
		${EndIf}
	nsJSON::Serialize /file "${PACKAGE}\Data\ApplicationConfig.json"
!macroend