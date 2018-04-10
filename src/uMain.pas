unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtPais: TEdit;
    edtCCC: TEdit;
    btnGenerarIBAN: TButton;
    edtNewIBAN: TEdit;
    TabSheet2: TTabSheet;
    btnValid_IBAN: TButton;
    edtIBAN_valid: TEdit;
    Label4: TLabel;
    TabSheet3: TTabSheet;
    Label5: TLabel;
    edtEntidad: TEdit;
    Label6: TLabel;
    edtOficina: TEdit;
    Label7: TLabel;
    edtDC: TEdit;
    Label8: TLabel;
    edtCuenta: TEdit;
    btnToCCC: TButton;
    Label9: TLabel;
    edtIBANFullElect: TEdit;
    Label10: TLabel;
    edtIBANFullPapel: TEdit;
    procedure btnGenerarIBANClick(Sender: TObject);
    procedure btnValid_IBANClick(Sender: TObject);
    procedure btnToCCCClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
 IBAN.Utils,
 IBAN.Types;

{$R *.dfm}

procedure TfrmMain.btnGenerarIBANClick(Sender: TObject);
var
  Cuenta: TrBancoCuentaInfo;
begin
  edtNewIBAN.Text := TIBANUtils.GetIBAN(edtPais.Text, edtCCC.Text);

  Cuenta.Build(edtNewIBAN.Text, edtCCC.Text);

  edtIBANFullPapel.Text := Cuenta.ToFormatPapel;
  edtIBANFullElect.Text := Cuenta.ToFormatElect;
end;

procedure TfrmMain.btnToCCCClick(Sender: TObject);
var
  Cuenta: TrBancoCCCInfoESP;
begin
  Cuenta.Build(edtEntidad.Text, edtOficina.Text, edtDC.Text, edtCuenta.Text);
  edtCCC.Text := Cuenta.ToCCC;
end;

procedure TfrmMain.btnValid_IBANClick(Sender: TObject);
var
  Msg: TStringList;
begin
  Msg := TStringList.Create;
  try
     if TIBANUtils.IsValidIBAN(edtIBAN_valid.Text, Msg) then
        ShowMessage('OK')
     else
        ShowMessage('Fail!!!' + #13#10 + Trim(Msg.Text));
  finally
     FreeAndNil(Msg);
  end;
end;

end.
