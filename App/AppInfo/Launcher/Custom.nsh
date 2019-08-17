${SegmentFile}

!addplugindir "${PACKAGE}\App\AppInfo\Launcher"

Var AutoCheckUpdate
Var CheckPreReleaseUpdates
Var CustomLanguage

${SegmentInit} ;; Heavily borrowed from PAL's Language.nsh Segment File as ShareX's language handling is in a format similar to PortableApps.comLocaleName, whereas the folders are in a format similar to glibc
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
			${ElseIf} $5 == "Portuguese-Brazil";
				${If} ${FileExists} "{PACKAGE}\App\ShareX\Languages\pt-BR\*.*"
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