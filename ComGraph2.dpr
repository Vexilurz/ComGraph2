program ComGraph2;

uses
  Forms,
  uMainComGraph in 'src\uMainComGraph.pas' {fmMain},
  uCom in 'src\uCom.pas' {$R *.res},
  uGlobalComGraph in 'src\uGlobalComGraph.pas',
  uGraphDrawer in 'src\uGraphDrawer.pas',
  uMemory in 'src\uMemory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
