unit uMemory;

interface

uses Windows, SysUtils;

type
  PMemory = ^TMemory;
  TMemory = class
  private
    FMaxData: cardinal;

    procedure SetMaxData(value: cardinal);
    procedure FreeData;
  public
    Name: string;
    Data: PByteArray;
    property MaxData: cardinal read FMaxData write SetMaxData;

    constructor Create(Name: string);
    destructor Destroy; override;
  end;

implementation

{ TMemory }

procedure TMemory.FreeData;
begin
  if Data <> nil then
  begin
    FreeMemory(Data);
    Data := nil;
  end;
end;

constructor TMemory.Create(Name: string);
begin
  inherited Create;
  FMaxData := 0;
  Data := nil;
  self.Name := Name;
end;

destructor TMemory.Destroy;
begin
  FreeData;
  inherited;
end;

procedure TMemory.SetMaxData(value: cardinal);
begin
  if value = FMaxData then
    Exit;
  if value = 0 then
    raise Exception.Create(Name+': can''t alloc memory: value = 0.');

  FreeData;
  Data := AllocMem(value);
  FMaxData := value;
  if Data = nil then
    raise Exception.Create(Name+': can''t alloc memory.');
end;

end.
