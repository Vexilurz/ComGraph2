unit uBuildInfo;

interface

uses Windows, SysUtils;

function GetAppVersion(PathToExe: string):string;
function GetBuild(PathToExe: string): string;

implementation

function GetAppVersion(PathToExe: string):string;
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
begin
  Result := '0.0.0.0';
  Size := GetFileVersionInfoSize(PChar(PathToExe), Size2);
  if Size > 0 then
  begin
    GetMem(Pt, Size);
    try
      GetFileVersionInfo(PChar(PathToExe), 0, Size, Pt);
      VerQueryValue(Pt, '\', Pt2, Size2);
      with TVSFixedFileInfo(Pt2^) do
      begin
        Result:= IntToStr(HiWord(dwFileVersionMS))+'.'+
                 IntToStr(LoWord(dwFileVersionMS))+'.'+
                 IntToStr(HiWord(dwFileVersionLS))+'.'+
                 IntToStr(LoWord(dwFileVersionLS));
      end;
    finally
      FreeMem(Pt);
    end;
  end;
end;

function GetBuild(PathToExe: string): string;
var
  pos: integer;
  s: string;
begin
  s := GetAppVersion(PathToExe);
  Result := '';
  Pos := Length(s);
  while (Pos >= 1) and (s[pos] <> '.') do
  begin
    Result := s[pos] + result;
    dec(pos);
  end;
end;

end.
