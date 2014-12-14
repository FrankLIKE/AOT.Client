@echo off
TITLE LLVM Builder Task.

PowerShell -NoProfile -ExecutionPolicy unrestricted -File "%~dp0ClangSetupvNextInstaller.ps1" "%~dp0ClangBuilder"


