unit uMainComGraph;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, TeeProcs, Chart, ExtCtrls, ComCtrls, ToolWin, Menus,
  ImgList, StdCtrls, Buttons, Spin, uCom, uGlobalComGraph, uGraphDrawer, uMemory;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    menuExit: TMenuItem;
    ToolBar1: TToolBar;
    sbMain: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Chart: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
    ilToolBar: TImageList;
    ToolButton1: TToolButton;
    cbCOM: TComboBox;
    bnComRefresh: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    seSendBefore: TSpinEdit;
    Label3: TLabel;
    cbChannelsCount: TComboBox;
    Label4: TLabel;
    cbChannel1: TCheckBox;
    cbChannel2: TCheckBox;
    cbChannel3: TCheckBox;
    cbChannel4: TCheckBox;
    Label5: TLabel;
    seMaxData: TSpinEdit;
    Label6: TLabel;
    edChannel1: TEdit;
    edChannel2: TEdit;
    edChannel3: TEdit;
    edChannel4: TEdit;
    cbAutoScale: TCheckBox;
    Label7: TLabel;
    seMinScale: TSpinEdit;
    seMaxScale: TSpinEdit;
    tbMaxVisibleData: TTrackBar;
    lbMaxData: TLabel;
    bnStartStop: TBitBtn;
    bnSingleReq: TBitBtn;
    Options1: TMenuItem;
    menuSquareDiscrete: TMenuItem;
    menuGraphAutoScroll: TMenuItem;
    Label8: TLabel;
    bnSquareDiscrete: TToolButton;
    bnGraphAutoScroll: TToolButton;
    ToolButton4: TToolButton;
    cbBitsPerNumber: TComboBox;
    timerMain: TTimer;
    procedure menuExitClick(Sender: TObject);
    procedure bnComRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAutoScaleClick(Sender: TObject);
    procedure bnStartStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure menuSquareDiscreteClick(Sender: TObject);
    procedure menuGraphAutoScrollClick(Sender: TObject);
    procedure bnSingleReqClick(Sender: TObject);
    procedure tbMaxVisibleDataChange(Sender: TObject);
    procedure timerMainTimer(Sender: TObject);
  private
    { Private declarations }
    function SquareDiscrete: boolean;
    function GraphAutoScroll: boolean;
    procedure SwitchEnabledField(FieldsEnable: boolean);

    procedure SetFields;
    procedure SetMaxVisibleData;
    procedure WorkOnce; // - needs opened COM port
    function CalcMaxData(ValuesCount: cardinal; BitsPerNumber: byte): cardinal;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;
  isWork: boolean = false;
  ComGraph: TComGraph;
  GraphDrawer: TGraphDrawer;

implementation

{$R *.dfm}

{ TfmMain }

// ***** INTERFACE *****

procedure TfmMain.menuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.menuSquareDiscreteClick(Sender: TObject);
begin
  menuSquareDiscrete.Checked := not menuSquareDiscrete.Checked;
  bnSquareDiscrete.Down := menuSquareDiscrete.Checked;
end;
procedure TfmMain.menuGraphAutoScrollClick(Sender: TObject);
begin
  menuGraphAutoScroll.Checked := not menuGraphAutoScroll.Checked;
  bnGraphAutoScroll.Down := menuGraphAutoScroll.Checked;
end;
function TfmMain.SquareDiscrete: boolean;
begin
  result := menuSquareDiscrete.Checked;
end;
function TfmMain.GraphAutoScroll: boolean;
begin
  result := menuGraphAutoScroll.Checked;
end;

procedure TfmMain.tbMaxVisibleDataChange(Sender: TObject);
begin
  lbMaxData.Caption := 'Max visible data = ' + IntToStr(tbMaxVisibleData.Position);
  SetMaxVisibleData;
end;

procedure TfmMain.bnComRefreshClick(Sender: TObject);
begin
  ComGraph.RefreshComList(@cbCOM);
end;

procedure TfmMain.SwitchEnabledField(FieldsEnable: boolean);
begin
  cbCOM.Enabled := FieldsEnable;
  seSendBefore.Enabled := FieldsEnable;
  cbChannelsCount.Enabled := FieldsEnable;
  seMaxData.Enabled := FieldsEnable;
  bnSingleReq.Enabled := FieldsEnable;
  bnComRefresh.Enabled := FieldsEnable;
  cbBitsPerNumber.Enabled := FieldsEnable;
  tbMaxVisibleData.Enabled := FieldsEnable;
end;

// ***** LOGIC *****

function TfmMain.CalcMaxData(ValuesCount: cardinal;
  BitsPerNumber: byte): cardinal;
begin
  if BitsPerNumber < 8 then
    result := ValuesCount
  else
    result := ValuesCount * (BitsPerNumber div 8);
end;

procedure TfmMain.SetMaxVisibleData;
begin
  GraphDrawer.MaxVisibleData := tbMaxVisibleData.Position;
  Chart.BottomAxis.SetMinMax(0, tbMaxVisibleData.Position);
end;

procedure TfmMain.SetFields;
begin
  ComGraph.ComData.MaxData := CalcMaxData(seMaxData.Value,
    StrToInt(cbBitsPerNumber.Text));
  if ComGraph.ComData.Data <> nil then
  begin
    GraphDrawer.InputData := @ComGraph.ComData;
  end;
  GraphDrawer.ChannelsCount := cbChannelsCount.ItemIndex + 1;
  GraphDrawer.BitsPerNumber := StrToInt(cbBitsPerNumber.Text);
  SetMaxVisibleData;
end;

procedure TfmMain.WorkOnce;
begin
  ComGraph.SendAndGetData(seSendBefore.Value);
  GraphDrawer.DrawTick;
end;

procedure TfmMain.bnSingleReqClick(Sender: TObject);
begin
  SetFields;
  ComGraph.StartComSession(cbCOM.text);
  WorkOnce;
  ComGraph.EndComSession;
end;

procedure TfmMain.timerMainTimer(Sender: TObject);
begin
  Application.ProcessMessages;
  WorkOnce;
end;

procedure TfmMain.bnStartStopClick(Sender: TObject);
begin
  if isWork then
  begin
    with bnStartStop do
    begin
      Kind := bkIgnore;
      Caption := 'Start';
    end;
    ComGraph.EndComSession;
  end
  else
  begin
    with bnStartStop do
    begin
      Kind := bkNo;
      Caption := 'Stop';
    end;
    SetFields;
    ComGraph.StartComSession(cbCOM.text);
  end;
  isWork := not isWork;
  SwitchEnabledField(not isWork);
  bnStartStop.ModalResult := mrNone;
  timerMain.Enabled := isWork;
end;

procedure TfmMain.cbAutoScaleClick(Sender: TObject);
begin
  Chart.LeftAxis.Automatic := cbAutoScale.Checked;
  Chart.LeftAxis.Maximum := seMaxScale.Value;
  Chart.LeftAxis.Minimum := seMinScale.Value;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if isWork then
    bnStartStop.Click;
  GraphDrawer.Destroy;
  ComGraph.Destroy;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  ComGraph := TComGraph.Create;
  GraphDrawer := TGraphDrawer.Create(@Chart);
  bnComRefresh.Click;
end;

initialization

end.
