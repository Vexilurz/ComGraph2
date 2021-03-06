unit uGraphDrawer;

interface

uses Windows, SysUtils, Chart, uMemory, uGlobal;

type
  PChart = ^TChart;
  TGraphDrawer = class
  private
    Chart: PChart;
    DataIndex: integer;
    VisibleDataIndex: integer;
    MaxChannels: byte;   // number of channels, existing in program
    TempValue: Pint64;

    LogFile: textfile;
    LogXpos: cardinal;
    isLogFileOpen: boolean;
  public
    InputData: PMemory;
    MaxVisibleData: cardinal;

    ChannelsCount: byte; // how many channels choosed in user options
    BitsPerNumber: byte; //8, 16, 24, 32, 64
    ChannelData: array of Int64; // dunno how to do this with pointers =(
    Scroll: boolean;
    SignEnabled: boolean;
    LogsEnabled: boolean;

    constructor Create(Chart: PChart; MaxChannels: byte);
    destructor Destroy; override;

    procedure ParseData;
    procedure DrawTick; // one tick to draw new data
    procedure NewLogFile(filename: string);
    procedure CloseLogFile;
    procedure OpenLogFile(filename: string);
  end;

implementation

{ TGraphDrawer }

constructor TGraphDrawer.Create(Chart: PChart; MaxChannels: byte);
begin
  inherited Create;
  self.MaxChannels := MaxChannels;
  SetLength(ChannelData, MaxChannels); // yeah, yeah... it's bad... but i tried!
  ChannelsCount := 1;
  BitsPerNumber := 32;
  DataIndex := 0;
  VisibleDataIndex := 0;
  MaxVisibleData := 256;
  Scroll := true;
  SignEnabled := true;
  LogsEnabled := true;
  self.Chart := Chart;
  LogXpos := 0;
  isLogFileOpen := false;
end;

destructor TGraphDrawer.Destroy;
begin

  inherited;
end;

procedure TGraphDrawer.ParseData;
//const
//  Mask: array[0..3] of byte = ($1, $3, $F);
var
  i, j: integer;
  data: byte;
  value: int64;
  sign: byte;
  lastDataIndex: cardinal;
  signBit: int64;
begin
  for i := 0 to ChannelsCount - 1 do
  begin
    lastDataIndex := DataIndex;
    // todo this, may be...
//    if BitsPerNumber < 8 then
//    begin
//      if i mod (8 div BitsPerNumber) = 0 then
//        data := InputData.Data[(i div BitsPerNumber) + lastDataIndex];
//      value := data and Mask[BitsPerNumber];
//      data := data shr BitsPerNumber; // <- todo
//      inc(DataIndex);
//    end
//    else
//    begin
      value := 0;
      for j := 0 to BitsPerNumber div 8 - 1 do
      begin
        value := value + InputData.Data[(i div BitsPerNumber + j) + lastDataIndex] shl (j * 8);
        inc(DataIndex);
      end;
//    end;
    signBit := 1 shl (BitsPerNumber -1);
    if SignEnabled and (value and signBit <> 0) then
      value := value or not (signBit - 1);
    ChannelData[i] := value;
  end;
end;

procedure TGraphDrawer.DrawTick;
var
  i, j: cardinal;
  tmp: integer;
  LogStr: string;
begin
  DataIndex := 0;
  while DataIndex < InputData.MaxData do
  begin
    ParseData;
    LogStr := IntToStr(LogXpos)+#9;
    if not Scroll then
    begin
      for i := 0 to ChannelsCount-1 do
      begin
        //Chart.Series[i].BeginUpdate;
        if VisibleDataIndex < Chart.Series[i].Count then
          Chart.Series[i].YValue[VisibleDataIndex] := ChannelData[i]
        else
          Chart.Series[i].AddY(ChannelData[i]);
        //Chart.Series[i].EndUpdate;
        LogStr := LogStr + IntToStr(ChannelData[i])+#9;
      end;
      if LogsEnabled then
      begin
        WriteLn(LogFile, LogStr);
        inc(LogXpos);
      end;

      if VisibleDataIndex >= MaxVisibleData - 1 then
        VisibleDataIndex := 0
      else
        inc(VisibleDataIndex);
    end
    else
    begin // Scroll = true
      for i := 0 to ChannelsCount-1 do
      begin
        Chart.Series[i].BeginUpdate;
        if Chart.Series[i].Count >= MaxVisibleData then
        begin
          try
            Chart.Series[i].Delete(0);
          except else
          end;
        end;
        Chart.Series[i].AddXY(Chart.Series[i].Count, ChannelData[i]);
        LogStr := LogStr + IntToStr(ChannelData[i])+#9;
        for j := 0 to Chart.Series[i].Count - 1 do
          Chart.Series[i].XValue[j] := j;
        Chart.Series[i].EndUpdate;
      end;
      if LogsEnabled then
      begin
        WriteLn(LogFile, LogStr);
        inc(LogXpos);
      end;
    end;
  end;
end;

procedure TGraphDrawer.CloseLogFile;
begin
  if isLogFileOpen then
  begin
    CloseFile(LogFile);
    isLogFileOpen := false;
  end;
end;

procedure TGraphDrawer.NewLogFile(filename: string);
begin
  CloseLogFile;
  if not isLogFileOpen then
  begin
    AssignFile(LogFile, filename);
    Rewrite(LogFile);
    isLogFileOpen := true;
    LogXpos := 0;
  end;
end;

procedure TGraphDrawer.OpenLogFile(filename: string);
var
  f: textfile;
  i, x: integer;
  y: array [0..3] of integer; // todo
begin
  if FileExists(filename) then
  begin
    for i := 0 to MaxChannels-1 do
      Chart.Series[i].Clear;
    AssignFile(f, filename);
    Reset(f);
      while not eof(f) do
      begin
        ReadLn(f, x, y[0], y[1], y[2], y[3]); // todo
        for i := 0 to MaxChannels-1 do
          Chart.Series[i].AddXY(x, y[i]);
      end;
      Chart.BottomAxis.SetMinMax(0, x);
    CloseFile(f);
  end;
end;

end.
