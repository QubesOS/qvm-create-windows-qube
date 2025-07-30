@echo off
title %~f0

:: Copyright (C) 2023 Elliot Killick <contact@elliotkillick.com>
:: Licensed under the MIT License. See LICENSE file for details.

:: DEBUG

reg add "HKLM\Software\Invisible Things Lab\Qubes Tools" /v "LogLevel" /t REG_DWORD /d 5

cd installer || exit
for %%i in (qubes-tools-*.exe qubes-tools-*.msi) do (
    start %%i /passive
)
