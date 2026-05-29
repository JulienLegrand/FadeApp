#Requires AutoHotkey v2.0
#Include "AppVol.ahk"

; --- Configuration ---
appAExe := "chrome.exe"
appBExe := "msedge.exe"

fadeDuration := 3000   ; durée du fondu en ms
steps := 20
stepDelay := fadeDuration / steps

; 0 = Chrome actif, 1 = Edge actif
global currentState := 0

; --- Raccourci : CTRL + ALT + F ---
^!f::
{
    global currentState

    if (currentState = 0) {
        ; Fondu Chrome -> Edge
        TrayTip("Fondu Chrome → Edge")
        Fade(appAExe, appBExe)
        currentState := 1
    } else {
        ; Fondu Edge -> Chrome
        TrayTip("Fondu Edge → Chrome")
        Fade(appBExe, appAExe)
        currentState := 0
    }
    TrayTip()
}

Fade(fromExe, toExe)
{
    global steps, stepDelay

    Loop steps
    {
        levelFrom := 1 - (A_Index / steps) ; 1 → 0
        levelTo   := (A_Index / steps)     ; 0 → 1

        SetAppVolume(fromExe, levelFrom)
        SetAppVolume(toExe, levelTo)

        Sleep stepDelay
    }
}

SetAppVolume(exeName, level)
{
    ; level entre 0.0 et 1.0
    vol := level * 100

    AppVol(exeName, vol)
}
