unit IBAN.Utils;

interface

uses
  System.Classes;

type
  TIBANUtils = class
  public
    class function GetIBAN(inSiglaPais, inCCC: string): string; // Genera un IBAN para una CCC. EJ: "ES17"
    class function IsValidIBAN(inFull: String; Errores: TStringList=nil): Boolean; // Valida un IBAN (Generico todos los paises SEPA)
  end;

implementation

uses
  System.SysUtils,
  IBAN.Types;

  { TIBANUtils }

class function TIBANUtils.GetIBAN(inSiglaPais, inCCC: string): string;
var
  IBAN: TrBancoIBANInfo;
begin
  IBAN.BuildEmpty(inSiglaPais);
  IBAN.DC := IBAN.GetDigitoControl(inCCC);

  Result := IBAN.ToIBAN;
end;

class function TIBANUtils.IsValidIBAN(inFull: String; Errores: TStringList=nil): Boolean;
var
  Cuenta: TrBancoCuentaInfo;
  IBAN: TrBancoIBANInfo;
begin
  // Descomponemos la cuenta
  Cuenta.Build(inFull);

  // Descomponemos el IBAN
  IBAN.Build(Cuenta.IBAN);

  // Valida
  Result := IBAN.IsValid(Cuenta.CCC, Errores);
end;

end.
