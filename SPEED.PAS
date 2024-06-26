{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/amdeksystem88-0)
  @abstract(Target: Turbo Pascal 7)
}

Program SPEED;

Uses Dos;

Var
 Language:(_French,_English,_Germany,_Italian,_Spain);
 TmpLanguage:String;
 I:Integer;
 Regs:Registers;

Function StrToUpper(S:String):String;
Var
 I:Byte;
Begin
 For I:=1 to Length(S)do Begin
  If S[I] in['a'..'z']Then S[I]:=Chr(Ord(S[I])-32);
 End;
 StrToUpper:=S;
End;

Procedure SetSpeedAMI(Fast:Boolean);Begin
 If(Fast)Then Begin
  Regs.AH:=$F0;
  Regs.AL:=$02;
  Intr($16,Regs);
 End
  Else
 Begin
  Regs.AH:=$F0;
  Regs.AL:=$01;
  Intr($16,Regs);
 End;
End;

BEGIN
 Language:=_French;
 TmpLanguage:=GetEnv('LANGUAGE');
 If TmpLanguage<>''Then Begin
  If TmpLanguage[1]='"'Then TmpLanguage:=Copy(TmpLanguage,2,255);
  If StrToUpper(Copy(TmpLanguage,1,2))='EN'Then Language:=_English Else
  If StrToUpper(Copy(TmpLanguage,1,2))='GR'Then Language:=_Germany Else
  If StrToUpper(Copy(TmpLanguage,1,2))='IT'Then Language:=_Italian Else
  If StrToUpper(Copy(TmpLanguage,1,2))='SP'Then Language:=_Spain;
 End;
 If(ParamStr(1)='/?')or(ParamStr(1)='--help')or(ParamStr(1)='-h')Then Begin
  Case Language of
   _English:Begin
    WriteLn('SPEED : This command changes the operating speed of the microprocessor.');
    WriteLn;
    WriteLn('SPEED [/?] [{S | H}] [{E | D}] [{+ | -}]');
    WriteLn;
    WriteLn('/?         = Help for this command');
    WriteLn('S          = Standard speed');
    WriteLn('H          = High speed');
    WriteLn('D          = Disable front-panel');
    WriteLn('E          = Enable front-panel');
    WriteLn('+          = High speed for AMI BIOS');
    WriteLn('-          = Normal speed for AMI BIOS');
   End;
   Else Begin
    WriteLn('SPEED: Cette commande permet de changer la vitesse de ',
                    'fonctionnement du microprocesseur.');
    WriteLn;
    WriteLn('SPEED [/?] [{S | H}] [{E | D}] [{+ | -}]');
    WriteLn;
    WriteLn(' /?   Ce param�tre permet de founir de l''aide sur cette commande.');
    WriteLn('D     Ce param�tre permet de d�sactiver le bouton � double vitesse ',
                   'du panneau frontal (s''il est pr�sent).');
    WriteLn('E     Ce param�tre permet d''activer le bouton � double vitesse du ',
                   'panneau frontal (s''il est pr�sent).');
    WriteLn('H     Ce param�tre permet de s�lectionner la haute vitesse ',
                   'du microprocesseur.');
    WriteLn('S     Ce param�tre permet de s�lectionner la vitesse standard ',
                  'du microprocesseur.');
    WriteLn('+     Ce param�tre permet de passer en mode rapide (Turbo) avec les BIOS AMI');
    WriteLn('-     Ce param�tre permet de passer en mode normal avec les BIOS AMI');
   End;
  End;
 End
  Else
 If ParamCount>0 Then Begin
  For I:=1 to ParamCount do Begin
   If StrToUpper(ParamStr(I))='D'Then Begin
     { Amdek System/88}
    Regs.AL:=0;
    Regs.AH:=4;
    Intr($15,Regs);
   End
    Else
   If StrToUpper(ParamStr(I))='E'Then Begin
     { Amdek System/88}
    Regs.AL:=1;
    Regs.AH:=4;
    Intr($15,Regs);
   End
    Else
   If StrToUpper(ParamStr(I))='H'Then Begin
     { Amdek System/88}
    Regs.AL:=8;
    Regs.AH:=4;
    Intr($15,Regs);
   End
    Else
   If StrToUpper(ParamStr(I))='S'Then Begin
     { Amdek System/88}
    Regs.AL:=6;
    Regs.AH:=4;
    Intr($15,Regs);
   End
    Else
   If ParamStr(I)='+'Then Begin
    SetSpeedAMI(True);
   End
    Else
   If ParamStr(I)='-'Then Begin
    SetSpeedAMI(False);
   End
    Else
   Begin
    WriteLn('Param�tre invalide !');
    Halt;
   End;
  End;
 End
  Else
 WriteLn('Param�tre requis !');
END.