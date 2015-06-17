unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, TeeProcs, Chart, ExtCtrls, ComCtrls, ToolWin, Menus,
  ImgList, StdCtrls, Buttons, Spin, uCom, uComGraph, uGraphDrawer, uMemory,
  uGlobal, IniFiles;

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
    seValuesCount: TSpinEdit;
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
    Series5: TFastLineSeries;
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
    procedure cbChannel1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ConfigRead;
    procedure ConfigWrite;

    function SquareDiscrete: boolean;
    function GraphAutoScroll: boolean;
    function ValuesCount: cardinal;
    function BitsPerNumber: byte;
    function ChannelsCount: byte;
    procedure SwitchEnabledField(FieldsEnable: boolean);
    procedure RenewChannelsActive;
    procedure ChangeAutoScale;

    procedure SetFields;
    procedure SetMaxVisibleData;
    procedure WorkOnce; // - needs opened COM port
    function CalcMaxData: cardinal;
  public
    { Public declarations }
  end;

const
  cComGraph = 'ComGraph';

var
  fmMain: TfmMain;
  isWork: boolean = false;
  ComGraph: TComGraph;
  GraphDrawer: TGraphDrawer;
  IntFunc: TInterfaceFunc;
  Config: TIniFile;

implementation

{$R *.dfm}

{ TfmMain }

// ***** INTERFACE *****

procedure TfmMain.menuExitClick(Sender: TObject);
begin
  Close;
end;

function TfmMain.SquareDiscrete: boolean;
begin
  result := menuSquareDiscrete.Checked;
end;
function TfmMain.GraphAutoScroll: boolean;
begin
  result := menuGraphAutoScroll.Checked;
end;
procedure TfmMain.menuSquareDiscreteClick(Sender: TObject);
begin
  menuSquareDiscrete.Checked := not menuSquareDiscrete.Checked;
  bnSquareDiscrete.Down := menuSquareDiscrete.Checked;
  GraphDrawer.Discrete := SquareDiscrete;
end;
procedure TfmMain.menuGraphAutoScrollClick(Sender: TObject);
begin
  menuGraphAutoScroll.Checked := not menuGraphAutoScroll.Checked;
  bnGraphAutoScroll.Down := menuGraphAutoScroll.Checked;
  GraphDrawer.Scroll := GraphAutoScroll;
end;

procedure TfmMain.tbMaxVisibleDataChange(Sender: TObject);
begin
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
  seValuesCount.Enabled := FieldsEnable;
  bnSingleReq.Enabled := FieldsEnable;
  bnComRefresh.Enabled := FieldsEnable;
  cbBitsPerNumber.Enabled := FieldsEnable;
//  tbMaxVisibleData.Enabled := FieldsEnable;
end;

procedure TfmMain.RenewChannelsActive;
begin
  Chart.Series[0].Active := cbChannel1.Checked;
  Chart.Series[1].Active := cbChannel2.Checked;
  Chart.Series[2].Active := cbChannel3.Checked;
  Chart.Series[3].Active := cbChannel4.Checked;
end;
procedure TfmMain.cbChannel1Click(Sender: TObject);
begin
  RenewChannelsActive;
end;

function TfmMain.ValuesCount: cardinal;
begin
  result := seValuesCount.Value;
end;
function TfmMain.BitsPerNumber: byte;
begin
  result := StrToInt(cbBitsPerNumber.Text);
end;
function TfmMain.ChannelsCount: byte;
begin
  result := cbChannelsCount.ItemIndex+1;
end;

procedure TfmMain.ChangeAutoScale;
begin
  Chart.LeftAxis.Automatic := cbAutoScale.Checked;
  Chart.LeftAxis.Maximum := seMaxScale.Value;
  Chart.LeftAxis.Minimum := seMinScale.Value;
end;
procedure TfmMain.cbAutoScaleClick(Sender: TObject);
begin
  ChangeAutoScale;
end;

procedure TfmMain.ConfigWrite;
begin
  with Config do
  begin
    WriteString (cComGraph,'COM',cbCOM.Text);
    WriteInteger(cComGraph,'Send',seSendBefore.Value);
    WriteInteger(cComGraph,'Channels',ChannelsCount);
    WriteInteger(cComGraph,'Values',ValuesCount);
    WriteInteger(cComGraph,'BitsPerInd',cbBitsPerNumber.ItemIndex);
    WriteInteger(cComGraph,'Visible',tbMaxVisibleData.Position);
    WriteBool   (cComGraph,'Channel1',cbChannel1.Checked);
    WriteBool   (cComGraph,'Channel2',cbChannel2.Checked);
    WriteBool   (cComGraph,'Channel3',cbChannel3.Checked);
    WriteBool   (cComGraph,'Channel4',cbChannel4.Checked);
    WriteBool   (cComGraph,'AutoScale',cbAutoScale.Checked);
    WriteInteger(cComGraph,'MIN',seMinScale.Value);
    WriteInteger(cComGraph,'MAX',seMaxScale.Value);
    WriteBool   (cComGraph,'Scroll',menuGraphAutoScroll.Checked);
    WriteBool   (cComGraph,'Discrete',menuSquareDiscrete.Checked);
  end;
end;
procedure TfmMain.ConfigRead;
var
  tmp: integer;
begin
  with Config do
  begin
    cbCOM.Text := ReadString(cComGraph,'COM','COM1');
    seSendBefore.Value := ReadInteger(cComGraph,'Send',2);
    cbChannelsCount.ItemIndex := ReadInteger(cComGraph,'Channels',1)-1;
    seValuesCount.Value := ReadInteger(cComGraph,'Values',1);
    tmp := ReadInteger(cComGraph,'BitsPerInd',3);
    if (tmp < 0) or (tmp > 4) then
      cbBitsPerNumber.ItemIndex := 3
    else
      cbBitsPerNumber.ItemIndex := tmp;
    tmp := ReadInteger(cComGraph,'Visible',256);
    if tmp > 2 then
    begin
      tbMaxVisibleData.Position := tmp;
      SetMaxVisibleData;
    end;
    cbChannel1.Checked := ReadBool(cComGraph,'Channel1',true);
    cbChannel2.Checked := ReadBool(cComGraph,'Channel2',true);
    cbChannel3.Checked := ReadBool(cComGraph,'Channel3',true);
    cbChannel4.Checked := ReadBool(cComGraph,'Channel4',true);
    RenewChannelsActive;
    cbAutoScale.Checked := ReadBool(cComGraph,'AutoScale',true);
    ChangeAutoScale;
    seMinScale.Value := ReadInteger(cComGraph,'MIN',-32768);
    seMaxScale.Value := ReadInteger(cComGraph,'MAX',32767);
    menuGraphAutoScroll.Checked := ReadBool(cComGraph, 'Scroll', true);
    bnGraphAutoScroll.Down := GraphAutoScroll;
    GraphDrawer.Scroll := GraphAutoScroll;
    menuSquareDiscrete.Checked  := ReadBool(cComGraph, 'Discrete', false);
    bnSquareDiscrete.Down := SquareDiscrete;
    GraphDrawer.Discrete := SquareDiscrete;
  end;
end;

// ***** LOGIC *****

function TfmMain.CalcMaxData: cardinal;
begin
  if BitsPerNumber < 8 then
    result := ValuesCount * ChannelsCount
  else
    result := ValuesCount * ChannelsCount * (BitsPerNumber div 8);
end;

procedure TfmMain.SetMaxVisibleData;
var
  i, j: integer;
begin
  lbMaxData.Caption := 'Max visible data = ' + IntToStr(tbMaxVisibleData.Position);
  GraphDrawer.MaxVisibleData := tbMaxVisibleData.Position;
  Chart.BottomAxis.SetMinMax(0, tbMaxVisibleData.Position);
  for i := 0 to 4 do
  begin
    if Chart.Series[i].Count > GraphDrawer.MaxVisibleData then
      for j := Chart.Series[i].Count-1 downto GraphDrawer.MaxVisibleData-1 do
      begin
        Chart.Series[i].Delete(j);
      end;
  end;
end;

procedure TfmMain.SetFields;
begin
  ComGraph.ComData.MaxData := CalcMaxData;
  if ComGraph.ComData.Data <> nil then
  begin
    GraphDrawer.InputData := @ComGraph.ComData;
  end;
  GraphDrawer.ChannelsCount := ChannelsCount;
  GraphDrawer.BitsPerNumber := BitsPerNumber;
  SetMaxVisibleData;
end;

procedure TfmMain.WorkOnce;
begin
  IntFunc.SetStatus(stDataExchange);
  Application.ProcessMessages;
  ComGraph.SendAndGetData(seSendBefore.Value);
  GraphDrawer.DrawTick;
  edChannel1.Text := IntToStr(GraphDrawer.ChannelData[0]);
  edChannel2.Text := IntToStr(GraphDrawer.ChannelData[1]);
  edChannel3.Text := IntToStr(GraphDrawer.ChannelData[2]);
  edChannel4.Text := IntToStr(GraphDrawer.ChannelData[3]);
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
//  Application.ProcessMessages;
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

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ConfigWrite;
  if isWork then
    bnStartStop.Click;
  GraphDrawer.Destroy;
  ComGraph.Destroy;
  IntFunc.Destroy;
  Config.Destroy;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Config := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  IntFunc := TInterfaceFunc.Create(@sbMain.Panels[1].Text);
  ComGraph := TComGraph.Create(@IntFunc);
  GraphDrawer := TGraphDrawer.Create(@Chart);
  ConfigRead;
  bnComRefresh.Click;
end;

initialization

end.