!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\ShareX\Portable"
		Rename "$INSTDIR\App\ShareX\Portable" "$INSTDIR\App\ShareX\PortableApps"
		
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\App\ShareX\Portable"
		Rename "$INSTDIR\App\ShareX\Portable" "$INSTDIR\App\ShareX\PortableApps"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\ShareX\ShareX\*.*"
			CopyFiles /SILENT "$INSTDIR\App\ShareX\ShareX\*.*" "$INSTDIR\Data"
			RMDir /r "$INSTDIR\App\ShareX\ShareX"
	${EndIf}
!macroend