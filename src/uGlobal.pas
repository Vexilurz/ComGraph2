unit uGlobal;

interface

uses Windows, SysUtils, ComCtrls;

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

  PStatusBar = ^TStatusBar;

  PInterfaceFunc = ^TInterfaceFunc;
  TInterfaceFunc = class
  private
    FStatusBar: PStatusBar;
    FPanelIndex: byte;
  public
    constructor Create(StatusBar: PStatusBar; PanelIndex: byte);
    destructor Destroy; override;

    procedure SetStatus(value: TStatusMessages);
  end;

implementation

constructor TInterfaceFunc.Create(StatusBar: PStatusBar; PanelIndex: byte);
begin
  inherited Create;
  FStatusBar := StatusBar;
  FPanelIndex := PanelIndex;
end;

destructor TInterfaceFunc.Destroy;
begin

  inherited;
end;

procedure TInterfaceFunc.SetStatus(value: TStatusMessages);
begin
  FStatusBar.Panels[FPanelIndex].Text := StatusMessages[integer(value)];
end;

end.
