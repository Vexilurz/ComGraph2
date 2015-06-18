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
  public
    InputData: PMemory;
    MaxVisibleData: cardinal;

    ChannelsCount: byte; // how many channels choosed in user options
    BitsPerNumber: byte; //8, 16, 24, 32, 64
    ChannelData: array of Int64; // dunno how to do this with pointers =(
    Scroll: boolean;

    constructor Create(Chart: PChart; MaxChannels: byte);
    destructor Destroy; override;

    procedure ParseData;
    procedure DrawTick; // one tick to draw new data
  end;

implementation

{ TGraphDrawer }

constructor TGraphDrawer.Create(Chart: PChart; MaxChannels: byte);
begin
  inherited Create;
  self.MaxChannels := MaxChannels;
  SetLength(ChannelData, MaxChannels); // yeah, yeah... it's bad... but i tried!
//  ChannelData := AllocMem(MaxChannels * SizeOf(Int64));
//  if ChannelData = nil then
//    raise Exception.Create('TGraphDrawer.ChannelData: can''t alloc memory.');
  ChannelsCount := 1;
  BitsPerNumber := 32;
  DataIndex := 0;
  VisibleDataIndex := 0;
  MaxVisibleData := 256;
  Scroll := true;
  self.Chart := Chart;
end;

destructor TGraphDrawer.Destroy;
begin
//  if ChannelData <> nil then
//  begin
//    FreeMemory(ChannelData);
//    ChannelData := nil;
//  end;
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
    if value and signBit <> 0 then
      value := value or not (signBit - 1);
    ChannelData[i] := value;
  end;
end;

procedure TGraphDrawer.DrawTick;
var
  i, j: cardinal;
begin
  DataIndex := 0;
  while DataIndex < InputData.MaxData do
  begin
    ParseData;
    if Scroll = false then
    begin
      for i := 0 to ChannelsCount-1 do
      begin
        if VisibleDataIndex < Chart.Series[i].Count then
          Chart.Series[i].YValue[VisibleDataIndex] := ChannelData[i]
        else
          Chart.Series[i].AddY(ChannelData[i]);
      end;

      if VisibleDataIndex >= MaxVisibleData then
        VisibleDataIndex := 0
      else
        inc(VisibleDataIndex);
    end
    else
    begin // Scroll = true
      for i := 0 to ChannelsCount-1 do
      begin
        if VisibleDataIndex < Chart.Series[i].Count then
        begin
          for j := 1 to Chart.Series[i].Count-1 do
          begin
            Chart.Series[i].YValue[j-1] := Chart.Series[i].YValue[j];
          end;
          Chart.Series[i].YValue[MaxVisibleData] := ChannelData[i];
        end
        else
          Chart.Series[i].AddY(ChannelData[i]);

        if VisibleDataIndex < MaxVisibleData then
          inc(VisibleDataIndex)
        else
          VisibleDataIndex := MaxVisibleData;
      end;
    end;
  end;
end;

end.
