unit uGraphDrawer;

interface

uses Windows, SysUtils, Chart, uMemory;

type
  PChart = ^TChart;
  TGraphDrawer = class
  private
    Chart: PChart;
    DataIndex: integer;
    VisibleDataIndex: integer;
    const MaxChannels = 4;
//    procedure AddNewData; // Adds input data to visible data
  public
    InputData: PMemory;
//    VisibleData: TMemory;
    MaxVisibleData: cardinal;

    ChannelsCount: byte; // 1..4
    BitsPerNumber: byte; //1..64

    ChannelData: array [0..MaxChannels-1] of Int64;

    constructor Create(Chart: PChart);
    destructor Destroy; override;

    procedure DrawTick; // one tick to draw new data

    procedure ParseData;
  end;

implementation

{ TGraphDrawer }

constructor TGraphDrawer.Create(Chart: PChart);
begin
  inherited Create;
  ChannelsCount := 1;
  BitsPerNumber := 32;
  DataIndex := 0;
  VisibleDataIndex := 0;
//  VisibleData := TMemory.Create('VisibleData');
  MaxVisibleData := 256;
  self.Chart := Chart;

  // todo:
//  ChannelData := AllocMem(4 * sizeof(int64));
end;

destructor TGraphDrawer.Destroy;
begin
//  VisibleData.Destroy;
//  FreeMemory(ChannelData);
  inherited;
end;

//procedure TGraphDrawer.AddNewData;
//var
//  tmpDelta: cardinal;
//begin
//  if InputData.MaxData > VisibleData.MaxData then
//  begin
//    CopyMemory(VisibleData.Data, InputData.Data, VisibleData.MaxData);
//    DataIndex := 0;
//  end
//  else
//  begin
//    if DataIndex + InputData.MaxData > VisibleData.MaxData then
//    begin
//      tmpDelta := VisibleData.MaxData - DataIndex;
//      CopyMemory(pointer(integer(VisibleData.Data)+DataIndex), InputData.Data,
//        tmpDelta);
//      CopyMemory(VisibleData.Data, pointer(integer(InputData.Data) + tmpDelta),
//        InputData.MaxData - tmpDelta);
//      DataIndex := tmpDelta - 1;
//    end
//    else
//    begin
////      DataIndex := (DataIndex + InputData.MaxData) mod VisibleData.MaxData;
////      CopyMemory(pointer(integer(VisibleData.Data + DataIndex)), InputData.Data, InputData.MaxData);
//
//      CopyMemory(pointer(integer(VisibleData.Data)+DataIndex), InputData.Data,
//        InputData.MaxData);
//      DataIndex := (DataIndex + InputData.MaxData) mod VisibleData.MaxData;
////      if DataIndex + InputData.MaxData = VisibleData.MaxData then
////        DataIndex := 0
////      else
////        DataIndex := DataIndex + InputData.MaxData;
//    end;
//  end;
//end;

procedure TGraphDrawer.ParseData;
const
  Mask: array[0..3] of byte = ($1, $3, $7, $F);
var
  i, j: integer;
  data: byte;
  value: int64;
  lastDataIndex: cardinal;
begin
  lastDataIndex := DataIndex;
  for i := 0 to ChannelsCount - 1 do
  begin
    if BitsPerNumber < 8 then
    begin
      if i mod (8 div BitsPerNumber) = 0 then
        data := InputData.Data[(i div BitsPerNumber) + lastDataIndex];
      value := data and Mask[BitsPerNumber];
      data := data shr BitsPerNumber; //todo
      inc(DataIndex);
    end
    else
    begin
      value := 0;
      for j := 0 to BitsPerNumber div 8 - 1 do
      begin
        value := value + InputData.Data[(i div BitsPerNumber + j) + lastDataIndex] shl (j * 8);
        inc(DataIndex);
      end;
    end;
    ChannelData[i] := value;
  end;
end;

procedure TGraphDrawer.DrawTick;
var
  i: cardinal;
begin
//  AddNewData;
  DataIndex := 0;
  while DataIndex < InputData.MaxData do
  begin
    ParseData;
    for i := 0 to ChannelsCount-1 do
    begin
      if VisibleDataIndex < Chart.Series[0].Count then
        Chart.Series[i].YValue[VisibleDataIndex] := ChannelData[i]
      else
        Chart.Series[i].AddY(ChannelData[i]);
    end;
    if VisibleDataIndex >= MaxVisibleData then
      VisibleDataIndex := 0
    else
      inc(VisibleDataIndex);
  end;
end;

end.
