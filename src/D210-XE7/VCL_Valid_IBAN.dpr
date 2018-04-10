program VCL_Valid_IBAN;

uses
  Vcl.Forms,
  uMain in '..\uMain.pas' {frmMain},
  IBAN.Funcs in '..\IBAN.Funcs.pas',
  IBAN.Types in '..\IBAN.Types.pas',
  IBAN.Utils in '..\IBAN.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
