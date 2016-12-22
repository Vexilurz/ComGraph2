unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, TeeProcs, Chart, ExtCtrls, ComCtrls, ToolWin, Menus,
  ImgList, StdCtrls, Buttons, Spin, uCom, uComGraph, uGraphDrawer, uMemory,
  uGlobal, IniFiles, uBuildInfo, pngimage;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    menuExit: TMenuItem;
    ToolBar1: TToolBar;
    sbMain: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Chart: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
    ilToolBar: TImageList;
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
    cbBitsPerNumber: TComboBox;
    timerMain: TTimer;
    ToolButton2: TToolButton;
    bnNumbersSign: TToolButton;
    menuNumbersSign: TMenuItem;
    N1: TMenuItem;
    seTimerFreq: TSpinEdit;
    Label9: TLabel;
    ToolButton1: TToolButton;
    bnLogsEn: TToolButton;
    N2: TMenuItem;
    menuLogsEn: TMenuItem;
    bnOpenLog: TToolButton;
    menuOpenLog: TMenuItem;
    dlgOpen: TOpenDialog;
    Splitter1: TSplitter;
    Image1: TImage;
    cbSqrt: TCheckBox;
    Series5: TFastLineSeries;
    Label10: TLabel;
    Label11: TLabel;
    seBaudRate: TSpinEdit;
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
    procedure menuNumbersSignClick(Sender: TObject);
    procedure menuLogsEnClick(Sender: TObject);
    procedure menuOpenLogClick(Sender: TObject);
  private
    { Private declarations }
    procedure ConfigRead;
    procedure ConfigWrite;

    function ValuesCount: cardinal;
    function BitsPerNumber: byte;
    function ChannelsCount: byte;
    procedure SwitchEnabledField(FieldsEnable: boolean);
    procedure RenewChannelsActive;
    procedure RefreshChannelsCheckbox;
    procedure ChangeAutoScale;
    procedure ChangeDiscrete(isOn: boolean);

    procedure SetFields;
    procedure SetMaxVisibleData;
    procedure WorkOnce; // - needs opened COM port
    function CalcMaxData: cardinal;
    function GetLogFileName: string;
  public
    { Public declarations }
  end;

const
  cComGraph = 'ComGraph';

var
  fmMain: TfmMain;
  MaxChannels: byte = 4;
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
begin Close; end;

procedure TfmMain.ChangeDiscrete(isOn: boolean);
var
  i: integer;
  obj: TComponent;
begin
  for i := 1 to MaxChannels+1 do
  begin
    obj := FindComponent('Series'+IntToStr(i));
    if obj <> nil then
      (obj as TFastLineSeries).Stairs := isOn;
  end;
end;

procedure TfmMain.menuSquareDiscreteClick(Sender: TObject);
begin
  menuSquareDiscrete.Checked := not menuSquareDiscrete.Checked;
  bnSquareDiscrete.Down := menuSquareDiscrete.Checked;
  ChangeDiscrete(menuSquareDiscrete.Checked);
end;
procedure TfmMain.menuGraphAutoScrollClick(Sender: TObject);
begin
  menuGraphAutoScroll.Checked := not menuGraphAutoScroll.Checked;
  bnGraphAutoScroll.Down := menuGraphAutoScroll.Checked;
  GraphDrawer.Scroll := menuGraphAutoScroll.Checked;
end;
procedure TfmMain.menuLogsEnClick(Sender: TObject);
begin
  menuLogsEn.Checked := not menuLogsEn.Checked;
  bnLogsEn.Down := menuLogsEn.Checked;
  GraphDrawer.LogsEnabled := menuLogsEn.Checked;
end;
procedure TfmMain.menuNumbersSignClick(Sender: TObject);
begin
  menuNumbersSign.Checked := not menuNumbersSign.Checked;
  bnNumbersSign.Down := menuNumbersSign.Checked;
  GraphDrawer.SignEnabled := menuNumbersSign.Checked;
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
  seTimerFreq.Enabled := FieldsEnable;
end;

procedure TfmMain.RefreshChannelsCheckbox;
var
  i: integer;
begin
  cbChannelsCount.Items.Clear;
  for i := 1 to MaxChannels do
  begin
    cbChannelsCount.Items.Add(IntToStr(i));
  end;
end;

procedure TfmMain.RenewChannelsActive;
var
  obj: TComponent;
  i: integer;
begin
  for i := 1 to MaxChannels do
  begin
    obj := FindComponent('cbChannel'+IntToStr(i));
    if obj <> nil then
      Chart.Series[i-1].Active := (obj as TCheckBox).Checked;
  end;
  Chart.Series[MaxChannels].Active := cbSqrt.Checked;   // !!!

end;
procedure TfmMain.cbChannel1Click(Sender: TObject);
begin
  RenewChannelsActive;
end;

function TfmMain.ValuesCount: cardinal;
begin result := seValuesCount.Value; end;
function TfmMain.BitsPerNumber: byte;
begin result := StrToInt(cbBitsPerNumber.Text); end;
function TfmMain.ChannelsCount: byte;
begin result := cbChannelsCount.ItemIndex+1; end;

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
var
  i: integer;
  obj: TComponent;
begin
  with Config do
  begin
    WriteString (cComGraph,'COM',cbCOM.Text);
    WriteInteger(cComGraph,'BaudRate',seBaudRate.Value);
    WriteInteger(cComGraph,'Send',seSendBefore.Value);
    WriteInteger(cComGraph,'Channels',ChannelsCount);
    WriteInteger(cComGraph,'Values',ValuesCount);
    WriteInteger(cComGraph,'BitsPerInd',cbBitsPerNumber.ItemIndex);
    WriteInteger(cComGraph,'Visible',tbMaxVisibleData.Position);
    for i := 1 to MaxChannels do
    begin
      obj := FindComponent('cbChannel'+IntToStr(i));
      if obj <> nil then
        WriteBool(cComGraph,'Channel'+IntToStr(i), (obj as TCheckBox).Checked);
    end;
    WriteBool   (cComGraph,'AutoScale',cbAutoScale.Checked);
    WriteInteger(cComGraph,'MIN',seMinScale.Value);
    WriteInteger(cComGraph,'MAX',seMaxScale.Value);
    WriteBool   (cComGraph,'Scroll',GraphDrawer.Scroll);
    WriteBool   (cComGraph,'Discrete',menuSquareDiscrete.Checked);
    WriteBool   (cComGraph,'Sign',GraphDrawer.SignEnabled);
    WriteBool   (cComGraph,'LogsEn',GraphDrawer.LogsEnabled);
    WriteInteger(cComGraph,'TimerFreq',seTimerFreq.Value);
  end;
end;
procedure TfmMain.ConfigRead;
var
  i, tmp: integer;
  obj: TComponent;
begin
  with Config do
  begin
    cbCOM.Text := ReadString(cComGraph,'COM','COM1');
    seBaudRate.Value := ReadInteger(cComGraph,'BaudRate',115200);
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
    for i := 1 to MaxChannels do
    begin
      obj := FindComponent('cbChannel'+IntToStr(i));
      if obj <> nil then
        (obj as TCheckBox).Checked := ReadBool(cComGraph,'Channel'+IntToStr(i),true);
    end;
      RenewChannelsActive;
    cbAutoScale.Checked := ReadBool(cComGraph,'AutoScale',true);
      ChangeAutoScale;
    seMinScale.Value := ReadInteger(cComGraph,'MIN',-32768);
    seMaxScale.Value := ReadInteger(cComGraph,'MAX',32767);
    menuGraphAutoScroll.Checked := ReadBool(cComGraph, 'Scroll', true);
      bnGraphAutoScroll.Down := menuGraphAutoScroll.Checked;
      GraphDrawer.Scroll := menuGraphAutoScroll.Checked;
    menuSquareDiscrete.Checked := ReadBool(cComGraph, 'Discrete', false);
      bnSquareDiscrete.Down := menuSquareDiscrete.Checked;
      ChangeDiscrete(menuSquareDiscrete.Checked);
    menuNumbersSign.Checked := ReadBool(cComGraph, 'Sign', true);
      bnNumbersSign.Down := menuNumbersSign.Checked;
      GraphDrawer.SignEnabled := menuNumbersSign.Checked;
    menuLogsEn.Checked := ReadBool(cComGraph, 'LogsEn', true);
      bnLogsEn.Down := menuLogsEn.Checked;
      GraphDrawer.LogsEnabled := menuLogsEn.Checked;
    seTimerFreq.Value := ReadInteger(cComGraph,'TimerFreq',1);
  end;
end;

function TfmMain.GetLogFileName: string;
begin
  result := 'Logs/'+FormatDateTime('dd.mm.yyyy_hh-mm-ss', now)+
      '_send'+IntToStr(seSendBefore.Value)+'_'+FloatToStr(now)+'.log';
end;

procedure TfmMain.menuOpenLogClick(Sender: TObject);
begin
  if dlgOpen.Execute() then
    GraphDrawer.OpenLogFile(dlgOpen.FileName);
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
  Chart.BottomAxis.SetMinMax(0, tbMaxVisibleData.Position-1);
  for i := 0 to MaxChannels do
  begin
    Chart.Series[i].BeginUpdate;
    for j := 0 to Chart.Series[i].Count - GraphDrawer.MaxVisibleData - 1 do
    begin
      try
        Chart.Series[i].Delete(j);
      except else
      end;
    end;
    for j := 0 to Chart.Series[i].Count - 1 do
      Chart.Series[i].XValue[j] := j;
    Chart.Series[i].EndUpdate;
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
var
  i: integer;
  obj: TComponent;
begin
  IntFunc.SetStatus(stDataExchange);
  Application.ProcessMessages;
  ComGraph.SendAndGetData(seSendBefore.Value);
  GraphDrawer.DrawTick;
  for i := 1 to MaxChannels do
  begin
    obj := FindComponent('edChannel'+IntToStr(i));
    if obj <> nil then
      (obj as TEdit).Text := IntToStr(GraphDrawer.ChannelData[i-1]);
  end;
end;

procedure TfmMain.bnSingleReqClick(Sender: TObject);
begin
  SetFields;
  ComGraph.StartComSession(cbCOM.text, seBaudRate.Value);
  if GraphDrawer.LogsEnabled then
    GraphDrawer.NewLogFile(GetLogFileName);
  WorkOnce;
  GraphDrawer.CloseLogFile;
  ComGraph.EndComSession;
end;

procedure TfmMain.timerMainTimer(Sender: TObject);
begin
  WorkOnce;
end;

procedure TfmMain.bnStartStopClick(Sender: TObject);
begin
  if isWork then
  begin
    if ComGraph.Com.isOpen then
      begin
      with bnStartStop do
      begin
        Kind := bkIgnore;
        Caption := 'Start';
      end;
      ComGraph.EndComSession;
      GraphDrawer.CloseLogFile;
      isWork := false;
    end;
  end
  else
  begin
    if not ComGraph.Com.isOpen then
      ComGraph.StartComSession(cbCOM.text, seBaudRate.Value);
    if ComGraph.Com.isOpen then
    begin
      with bnStartStop do
      begin
        Kind := bkNo;
        Caption := 'Stop';
      end;
      SetFields;
      timerMain.Interval := seTimerFreq.Value;
      if GraphDrawer.LogsEnabled then
        GraphDrawer.NewLogFile(GetLogFileName);
      isWork := true;
    end;
  end;
  SwitchEnabledField(not isWork);
  bnStartStop.ModalResult := mrNone;
  timerMain.Enabled := isWork;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  MaxChannels := Chart.SeriesCount-1;
  RefreshChannelsCheckbox;
  Config := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  dlgOpen.InitialDir := ExtractFilePath(Application.ExeName);
  IntFunc := TInterfaceFunc.Create(@sbMain, 1);
  ComGraph := TComGraph.Create(@IntFunc);
  GraphDrawer := TGraphDrawer.Create(@Chart, MaxChannels);
  ConfigRead;
  bnComRefresh.Click;
  Caption := Caption + ' Build '+GetBuild(Application.ExeName)+
    '. Vexilurz (c) Measurements Systems.';
//  image1.Picture.Bitmap.TransparentColor := clWhite;
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

initialization

end.
