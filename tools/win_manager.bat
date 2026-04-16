@echo off
set Action=%1
set Slot=%2

set FilePath=%TEMP%\kanata_slot_%Slot%.txt

if "%Action%"=="show" if "%Slot%"=="0" (
    powershell -Command "Get-ChildItem '%TEMP%\kanata_slot_*.txt' | ForEach-Object { $hwnd = Get-Content $_.FullName; & nircmd.exe win show handle $hwnd; & nircmd.exe win activate handle $hwnd; Remove-Item $_.FullName }"
    exit /b
)

if "%Action%"=="hide" (
    powershell -Command "$def = '[DllImport(\"user32.dll\")] public static extern int GetForegroundWindow();'; $type = Add-Type -MemberDefinition $def -Name \"Win32\" -Namespace Win32 -PassThru; $hwnd = $type::GetForegroundWindow(); $hwnd | Out-File '%FilePath%'; & nircmd.exe win hide handle $hwnd"
    exit /b
)

if "%Action%"=="show" (
    powershell -Command "if (Test-Path '%FilePath%') { $hwnd = Get-Content '%FilePath%'; & nircmd.exe win show handle $hwnd; & nircmd.exe win activate handle $hwnd; Remove-Item '%FilePath%' }"
    exit /b
)