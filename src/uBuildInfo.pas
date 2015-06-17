unit uBuildInfo;

interface

uses Windows, SysUtils;

function GetVersion: string;
function GetBuild: string;

implementation

function GetVersion: string;
var
  dump: DWORD;
  size: integer;
  buffer: PChar;
  VersionPointer, TransBuffer: PChar;
  Temp: integer;
  CalcLangCharSet: string;
  NameApp: string;
begin
  NameApp := paramstr(0);

  size := GetFileVersionInfoSize(PChar(NameApp), dump);
  buffer := StrAlloc(size+1);
  try
    GetFileVersionInfo(PChar(NameApp), 0, size, buffer);

    VerQueryValue(buffer, '\VarFileInfo\Translation', pointer(TransBuffer),
    dump);
    if dump >= 4 then
    begin
      temp:=0;
      StrLCopy(@temp, TransBuffer, 2);
      CalcLangCharSet:=IntToHex(temp, 4);
      StrLCopy(@temp, TransBuffer+2, 2);
      CalcLangCharSet := CalcLangCharSet+IntToHex(temp, 4);
    end;

    VerQueryValue(buffer, pchar('\StringFileInfo\'+CalcLangCharSet+
    '\'+'FileVersion'), pointer(VersionPointer), dump);
    if (dump > 1) then
    begin
      Result := VersionPointer;
    end
    else
      Result := '0.0.0.0';
  finally
    StrDispose(Buffer);
  end;
end;

function GetBuild: string;
var
  pos: integer;
  s: string;
begin
  s := GetVersion;
  Result := '';
  Pos := Length(s);
  while (Pos >= 1) and (s[pos] <> '.') do
  begin
    Result := s[pos] + result;
    dec(pos);
  end;
end;

end.
