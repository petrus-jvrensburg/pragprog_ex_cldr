   @ECHO OFF
    rem IF NOT "%~f0" == "~f0" GOTO :WinNT
    @"../../Common/ThirdPartyTools/jruby-1.6.0.RC1/bin/jruby" -S "../../Common/ThirdPartyTools/jruby-1.6.0.RC1/bin/rake" %1 %2 %3 %4 %5 %6 %7 %8 %9
    GOTO :EOF
    rem :WinNT
    @"%~dp0" "%~dpn0" %*

