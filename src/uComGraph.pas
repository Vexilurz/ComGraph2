unit uComGraph;

interface

uses Windows, SysUtils, StdCtrls, Classes, uCom, uMemory, uGlobal;

type
  PComboBox = ^TComboBox;
  TComGraph = class
  private
    IntFunc: PInterfaceFunc;
  public
    Com: TCom;
    ComData: TMemory;

    constructor Create(IntFunc: PInterfaceFunc);
    destructor Destroy; override;

    procedure RefreshComList(ComboBox: PComboBox);
    procedure StartComSession(ComName: string);
    procedure EndComSession;
    procedure SendAndGetData(SendByteBefore: byte);
  end;

implementation

{ TComGraph }

constructor TComGraph.Create(IntFunc: PInterfaceFunc);
begin
  inherited Create;
  self.IntFunc := IntFunc;
  ComData := TMemory.Create('ComGraphData');
  Com := TCom.Create;
end;

destructor TComGraph.Destroy;
begin
  Com.Destroy;
  ComData.Destroy;
  inherited;
end;

procedure TComGraph.SendAndGetData(SendByteBefore: byte);
begin
  if Com.isOpen then
  begin
    Com.SendByte(SendByteBefore);
    Com.Get(ComData.Data^, ComData.MaxData);
  end;
end;

procedure TComGraph.StartComSession(ComName: string);
begin
  IntFunc.SetStatus(stComOpen);
  if Com.isOpen and (Com.ComName <> ComName) then
    Com.Close;

  if not Com.isOpen then
  begin
    Com.ComName := ComName;
    Com.Open;
  end;
end;

procedure TComGraph.EndComSession;
begin
  IntFunc.SetStatus(stComClose);
  Com.Close;
  IntFunc.SetStatus(stReady);
end;

procedure TComGraph.RefreshComList(ComboBox: PComboBox);
var
  i: integer;
  newItem: string;
  storeCom: string;
  storeIndex: integer;
begin
  storeCom := ComboBox.Text;
  storeIndex := -1;
  ComboBox.Items.BeginUpdate;
  ComboBox.Items.Clear;
  Com.RefreshComList;
  for i := 0 to Com.ComCount-1 do
  begin
    newItem := 'COM'+IntToStr(Com.ComList[i]);
    ComboBox.Items.Add(newItem);
    if newItem = storeCom then
      storeIndex := i;
  end;
  if Com.ComCount = 0 then
    ComboBox.Text := '<nothing>'
  else
  begin
    if storeIndex <> -1 then
      ComboBox.ItemIndex := storeIndex
    else
      ComboBox.ItemIndex := 0;
  end;
  ComboBox.Items.EndUpdate;
end;

end.
