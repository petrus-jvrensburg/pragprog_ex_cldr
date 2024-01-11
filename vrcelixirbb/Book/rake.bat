   @ECHO OFF
    rem IF NOT "%~f0" == "~f0" GOTO :WinNT
    @"../Common/ThirdPartyTools/jruby-1.7.22/bin/jruby" -S "../Common/ThirdPartyTools/jruby-1.7.22/bin/rake" %1 %2 %3 %4 %5 %6 %7 %8 %9
    GOTO :EOF
    rem :WinNT
    @"%~dp0" "%~dpn0" %*

