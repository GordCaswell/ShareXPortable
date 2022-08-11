!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\App\ShareX\ShareX\*.*"
			CopyFiles /SILENT "$INSTDIR\App\ShareX\ShareX\*.*" "$INSTDIR\Data\ShareX\*.*"
			RMDir /r "$INSTDIR\App\ShareX\ShareX"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\ShareX\PortableApps"
		Rename "$INSTDIR\App\ShareX\PortableApps" "$INSTDIR\App\ShareX\Portable"
	${EndIf}
!macroend