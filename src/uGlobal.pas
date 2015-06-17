unit uGlobal;

interface

uses Windows, SysUtils;

const
  StatusMessages : array [0..5] of string = (
    'Opening COM port...',
    'Closing COM port...',
    'Done!',
    'Ready',
    'Trying to request...',
    'Exchanging data with COM port...');

type
  TStatusMessages = (
    stComOpen,
    stComClose,
    stDone,
    stReady,
    stWorkOnce,
    stDataExchange
  );

  PString = ^string;

  PInterfaceFunc = ^TInterfaceFunc;
  TInterfaceFunc = class
  private
    FStatus: PString;
  public
    constructor Create(Status: PString);
    destructor Destroy; override;

    procedure SetStatus(value: TStatusMessages);
  end;

implementation

constructor TInterfaceFunc.Create(Status: PString);
begin
  inherited Create;
  FStatus := Status;
end;

destructor TInterfaceFunc.Destroy;
begin

  inherited;
end;

procedure TInterfaceFunc.SetStatus(value: TStatusMessages);
begin
  FStatus^ := StatusMessages[integer(value)];
end;

end.
