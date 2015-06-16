unit uCom;

interface

uses Windows, SysUtils;

type
  TCom = class
  private
    FHCom: cardinal;
    FRef: integer;
    Buffer: array[0..511] of byte;
    BufferCount: integer;
  public
    ComName: string;
    baudrate: integer;
    ComList: array of integer;
    ComCount: integer;

    constructor Create;
    destructor Destroy; override;

    function isOpen: boolean;
    procedure Open;
    procedure Close;

    procedure SendByte(buf: byte; immediate: boolean = false);
    procedure Send(buf: array of byte; immediate: boolean = false); overload;
    procedure Send(buf: array of byte; size: integer; immediate: boolean = false); overload;

    procedure GetByte(var buf: byte);
    procedure Get(var buf: array of byte); overload;
    procedure Get(var buf: array of byte; size: cardinal); overload;

    function InputCount: integer;
    function OutputCount: integer;

    procedure RefreshComList;

    procedure WriteBuffer(buf: array of byte; size: integer);
    procedure BeginWrite;
    procedure EndWrite;
  end;

implementation

{ TCom }

procedure TCom.Close;
begin
  if isOpen then
    CloseHandle(FHCom);
  FHCom := 0;
end;

procedure TCom.Open;
var
  DCB: _DCB;
  TimeOuts: COMMTIMEOUTS;
begin
  FHCom := CreateFile(PChar('\\.\' + ComName), GENERIC_READ + GENERIC_WRITE, 0, nil, OPEN_EXISTING, 0, 0);
  if integer(FHCom) = -1 then
    raise Exception.Create('Cannot open selected port (createFile error ¹' + IntToStr(GetLastError) + ')');

  GetCommState(FHCom, dcb);
  dcb.Parity:= NOPARITY;
  dcb.BaudRate:= baudrate;
  dcb.XonLim:= 1024;
  dcb.XoffLim:= 1024;
  dcb.wReserved:= 0;
  dcb.ByteSize:= 8;
  dcb.StopBits:= ONESTOPBIT;
  dcb.Flags := dcb.Flags and not $300; // disable xon/xoff flow control
  if not SetCommState(FHCom, dcb) then
  begin
    Close;
    raise Exception.Create('Cannot open selected port (setCommState error ¹' + IntToStr(GetLastError) + ')');
  end;

  TimeOuts.ReadIntervalTimeout := 100;
  TimeOuts.ReadTotalTimeoutMultiplier := 100;
  TimeOuts.ReadTotalTimeoutConstant := 100;
  TimeOuts.WriteTotalTimeoutMultiplier := 100;
  TimeOuts.WriteTotalTimeoutConstant := 100;
  SetCommTimeOuts(FHCom, TimeOuts);
end;

function TCom.OutputCount: integer;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
  if isOpen then
  begin
    ClearCommError(FHCom, Errors, @ComStat);
    Result := ComStat.cbOutQue;
  end
  else
    Result := 0;
end;

procedure TCom.RefreshComList;
var
  i: integer;
  isExists: boolean;
  LastComName: string;
begin
  SetLength(ComList, 0);
  ComCount := 0;
  LastComName := ComName;
  for i := 1 to 31 do
  begin
    ComName := format('COM%d', [i]);
    isExists := true;
    try
      Open;
    except
      on E: Exception do isExists := false;
    end;

    if isOpen then
      Close;

    if isExists then
    begin
      inc(ComCount);
      SetLength(ComList, ComCount);
      ComList[ComCount-1] := i;
    end;
  end;
  ComName := LastComName;
end;

procedure TCom.Send(buf: array of byte; immediate: boolean = false);
var
  writted: cardinal;
begin
  if immediate or (FRef = 0) then
    WriteFile(FHCom, buf, sizeof(buf), writted, nil)
  else
    WriteBuffer(buf, sizeof(buf));
end;

procedure TCom.Send(buf: array of byte; size: integer; immediate: boolean = false);
var
  writted: cardinal;
begin
  if immediate or (FRef = 0) then
    WriteFile(FHCom, buf, size, writted, nil)
  else
    WriteBuffer(buf, size);
end;

procedure TCom.SendByte(buf: byte; immediate: boolean = false);
var
  written: cardinal;
begin
  if immediate or (FRef = 0) then
    WriteFile(FHCom, buf, 1, written, nil)
  else
    WriteBuffer(buf, 1);
end;

procedure TCom.WriteBuffer(buf: array of byte; size: integer);
begin
  if BufferCount + size > sizeof(Buffer) then
  begin
    Send(Buffer, BufferCount, true);
    BufferCount := 0;
  end;

  CopyMemory(@Buffer[BufferCount], @Buf, size);
  inc(BufferCount, size);
end;

procedure TCom.Get(var buf: array of byte);
var
  readen: cardinal;
begin
  ReadFile(FHCom, buf, sizeof(buf), readen, nil);
end;

procedure TCom.Get(var buf: array of byte; size: cardinal);
var
  readen: cardinal;
begin
  ReadFile(FHCom, buf, size, readen, nil);
end;

procedure TCom.GetByte(var buf: byte);
var
  readen: cardinal;
begin
  ReadFile(FHCom, buf, sizeof(buf), readen, nil);
end;

function TCom.InputCount: integer;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
  if isOpen then
  begin
    ClearCommError(FHCom, Errors, @ComStat);
    Result := ComStat.cbInQue;
  end
  else
    Result := 0;
end;

function TCom.isOpen: boolean;
begin
  Result := (FHCom > 0);
end;

constructor TCom.Create;
begin
  inherited;
  FHCom := 0;
  FRef := 0;
  BufferCount := 0;
  ComCount := 0;
  SetLength(ComList, 0);
  ComName := 'COM1';
  baudrate := 115200;
end;

destructor TCom.Destroy;
begin
  if isOpen then
    Close;
  inherited;
end;

procedure TCom.BeginWrite;
begin
  inc(FRef);
end;

procedure TCom.EndWrite;
begin
  if FRef > 0 then
    dec(FRef);

  if FRef = 0 then
  begin
    Send(Buffer, BufferCount);
    BufferCount := 0;
  end;
end;

end.
