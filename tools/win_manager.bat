@echo off
set Action=%1
set Slot=%2
set FilePath=%TEMP%\kanata_slot_%Slot%.txt

:: ==============================
:: 逻辑：显示所有 (Show All - 当 Slot 为 0 时)
:: ==============================
if "%Action%"=="show" if "%Slot%"=="0" (
    :: 【修改点】加入了 & nircmd.exe win activate handle $hwnd
    :: 这样恢复出来的窗口会被强制激活
    powershell -Command "Get-ChildItem '%TEMP%\kanata_slot_*.txt' | ForEach-Object { $hwnd = Get-Content $_.FullName; & nircmd.exe win show handle $hwnd; & nircmd.exe win activate handle $hwnd; Remove-Item $_.FullName }"
    exit /b
)

:: ==============================
:: 逻辑：隐藏 (Hide - 普通槽位)
:: ==============================
if "%Action%"=="hide" (
    powershell -Command "$def = '[DllImport(\"user32.dll\")] public static extern int GetForegroundWindow();'; $type = Add-Type -MemberDefinition $def -Name \"Win32\" -Namespace Win32 -PassThru; $hwnd = $type::GetForegroundWindow(); $hwnd | Out-File '%FilePath%'; & nircmd.exe win hide handle $hwnd"
    exit /b
)

:: ==============================
:: 逻辑：显示 (Show - 普通槽位)
:: ==============================
if "%Action%"=="show" (
    :: 【修改点】在 show 之后，紧接着执行 activate
    powershell -Command "if (Test-Path '%FilePath%') { $hwnd = Get-Content '%FilePath%'; & nircmd.exe win show handle $hwnd; & nircmd.exe win activate handle $hwnd; Remove-Item '%FilePath%' }"
    exit /b
)