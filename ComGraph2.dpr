program ComGraph2;

uses
  Forms,
  uMain in 'src\uMain.pas' {fmMain},
  uCom in 'src\uCom.pas' {$R *.res},
  uComGraph in 'src\uComGraph.pas',
  uGraphDrawer in 'src\uGraphDrawer.pas',
  uMemory in 'src\uMemory.pas',
  uGlobal in 'src\uGlobal.pas' {$R *.res},
  uBuildInfo in 'src\uBuildInfo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ComGraph2';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
