unit IBAN.Types;

interface

uses
  System.Classes;

type
  {$REGION 'Doc'}
  /////////////////////////////////////////////////////////////////////////////////
  // Ref:
  //    https://es.wikipedia.org/wiki/International_Bank_Account_Number
  //    http://www.lasexta.com/tecnologia-tecnoxplora/ciencia/divulgacion/iban-asi-calculan-numeros-cuenta-bancaria_2014020957fca03d0cf2fd8cc6b0e1a2.html
  //    http://www.neleste.com/validar-ccc-con-php/
  /////////////////////////////////////////////////////////////////////////////////
  //    IBAN Completo.: ES1720852066623456789011
  //    IBAN Deglosado: ES17 + 2085    + 2066    + 62 + 34 5678 9011
  //                    IBAN + Entidad + Oficina + DC + Cuenta
  //                          [-------------CCC-ESP----------------]
  /////////////////////////////////////////////////////////////////////////////////
  //    IBAN...: ES17 ("ES" = 2 digitos pais, "17" Digito verificador de toda la CCC)
  //    Entidad: 2085
  //    Oficina: 2066
  //    DC.....: 62
  //    Cuenta.: 3456789011
  /////////////////////////////////////////////////////////////////////////////////
  //    BIC....: ?? Pendiente
  //    SWIFT..: ?? Pendiente
  /////////////////////////////////////////////////////////////////////////////////
  {$ENDREGION}

  { Info Bancaria de la Cuenta. Generico para UE }
  TrBancoCuentaInfo = record
  private
    function AddPrefixPapelIBAN(Value: string): string;
    function DelPrifixPapelIBAN(Value: string): string;

  public
    IBAN: string; // size(4)                             // Codigo del Pais (ISO 3166-1) + Digito verificador
    CCC: string;  // size(Varia Segun Pais), maxsize(30) // En el caso de España (Entidad + Oficina + DC + Cuenta).

    // HELPERs
    function ToFull(Sep:string=''): string; // IBAN Completo (ES1720852066623456789011) IBAN-ESP: maxsize(24) | IBAN:maxsize(34)
    function ToFormatPapel: string;
    function ToFormatElect: string;

    procedure Build(inIBAN, inCCC: string); overload;
    procedure Build(inFull: string); overload;
  end;

  { Info Bancaria del Codigo del Pais, IBAN = "International Bank Account Number" }
  TrBancoIBANInfo = record
  private
    function PaisToIBANTable(inPais: string): string;
    function ToIBAN_Table: string;
    function GetStrAValidar(inCCC: string): string;

    function IsValid_DC(inCCC: String; Errores: TStringList=nil): Boolean;
    function IsValid_Base(Errores: TStringList=nil): Boolean;
  public
    Pais: string;
    DC: string;

    // HELPERs
    function ToIBAN: string;

    function Build(inPais, inDC: string): TrBancoIBANInfo; overload;
    function Build(inIBAN: string): TrBancoIBANInfo; overload;
    function BuildEmpty(inPais: string): TrBancoIBANInfo;

    function GetDigitoControl(inCCC: string): string;
    function IsValid(inCCC: String; Errores: TStringList=nil): Boolean;
  end;

  { Info del CCC = "Código Cuenta Cliente" Española }
  TrBancoCCCInfoESP = record
  public
    Entidad: string;
    Oficina: string;
    DC: string;
    Cuenta: string;

    // HELPERs
    function ToCCC(Sep:string=''): string;
    function Build(inEntidad, inOficina, inDC, inCuenta: string): TrBancoCCCInfoESP; overload;
    function Build(inCCC: string): TrBancoCCCInfoESP; overload;
  end;

implementation

uses
  System.SysUtils,
  IBAN.Funcs;

const
  _PrefixFormatPapelIBAN = 'IBAN';

resourcestring
  IBANInvalidoStr = 'IBAN Inválido';
  PaisIBANInvalidoStr = 'Pais del IBAN Inválido';
  DcIBANInvalidoStr = 'Digito Control del IBAN Inválido';

{ TrBancoCuentaInfo }

function TrBancoCuentaInfo.AddPrefixPapelIBAN(Value: string): string;
begin
  Result := _PrefixFormatPapelIBAN + ' ' + Trim(Value);
end;

function TrBancoCuentaInfo.DelPrifixPapelIBAN(Value: string): string;
var
  AValue: string;
  Prefix: string;
  PrefixSize: Integer;
begin
  Result := Value;

  // Del Prefix IBAN
  AValue     := Trim(Value);
  PrefixSize := Length(_PrefixFormatPapelIBAN);
  Prefix     := Copy(AValue, 1, PrefixSize);

  if SameText(Prefix, _PrefixFormatPapelIBAN) then //Si tiene el prefijo lo quitamos.
  begin
     Result := Copy(AValue, PrefixSize+1, Length(AValue));
     Result := Trim(Result);
  end;
end;

function TrBancoCuentaInfo.ToFull(Sep:string=''): string;
begin
  Result := Trim(Self.IBAN) + Sep +
            Trim(Self.CCC);
end;

function TrBancoCuentaInfo.ToFormatElect: string;
begin
  Result := Self.ToFull;
end;

function TrBancoCuentaInfo.ToFormatPapel: string;
begin
  // Add Prefix IBAN
  Result := Self.AddPrefixPapelIBAN( Self.ToFull(' ') );
end;

procedure TrBancoCuentaInfo.Build(inIBAN, inCCC: string);
begin
  Self.IBAN := inIBAN;
  Self.CCC  := inCCC;
end;

procedure TrBancoCuentaInfo.Build(inFull: string);
var
  Value: string;
begin
  // Clean
  Value := inFull;
  Value := Self.DelPrifixPapelIBAN(Value);
  Value := TIBANFuncs.GetAlphaNumericsOnly(Value);

  // Separa
  Self.IBAN := Copy(Value, 1, 4);
  Self.CCC  := Copy(Value, 5, Length(Value)); //El restante es el CCC
end;

{ TrBancoIBANInfo }

function TrBancoIBANInfo.PaisToIBANTable(inPais: string): string;

  function CharToDigitTable(const Value: Char): string;
  const
    Initial_A: char = 'A';
  var
    iValue: byte;
  begin
    ////////////////////////////////////////////////////////////////////////////////////////
    // Cambias las letras que queden a numeros segun esta tabla:
    //  A=10, B=11, C=12, D=13, E=14, F=15, G=16, H=17, I=18, J=19, K=20, L=21, M=22,
    //  N=23, O=24, P=25, Q=26, R=27, S=28, T=29, U=30, V=31, W=32, X=33, Y=34, Z=35
    ////////////////////////////////////////////////////////////////////////////////////////
    Result := Value;

    if CharInSet(Value, ['A'..'Z']) then
    begin
       iValue := (byte(Value) - byte(Initial_A)) + 10;
       result := IntToStr(iValue);
    end;
  end;

var
  i: Integer;
  Valor: string;
begin
  Result := '';
  inPais := AnsiUpperCase(inPais);
  for i:=1 to Length(inPais) do
  begin
     Valor  := CharToDigitTable(inPais[i]);
     Result := Result + Valor;
  end;
end;

function TrBancoIBANInfo.ToIBAN: string;
begin
  Result := Self.Pais + Self.DC;
end;

function TrBancoIBANInfo.ToIBAN_Table: string;
begin
  Result := Self.PaisToIBANTable(Self.Pais) + Self.DC;
end;

function TrBancoIBANInfo.Build(inPais, inDC: string): TrBancoIBANInfo;
begin
  Result := Self;

  Self.Pais := inPais;
  Self.DC   := inDC;
end;

function TrBancoIBANInfo.Build(inIBAN: string): TrBancoIBANInfo;
begin
  // Ej: "ES78"
  Result := Self;

  inIBAN := Trim(inIBAN);
  Self.Pais := Copy(inIBAN, 1, 2);
  Self.DC   := Copy(inIBAN, 3, 4);
end;

function TrBancoIBANInfo.BuildEmpty(inPais: string): TrBancoIBANInfo;
begin
  Result := Self;

  Self.Pais := inPais;
  Self.DC   := '00';
end;

function TrBancoIBANInfo.GetStrAValidar(inCCC: string): string;
begin
  Result := Trim(inCCC) + Self.ToIBAN_Table;
end;

function TrBancoIBANInfo.GetDigitoControl(inCCC: string): string;
var
  AValidar: string;
  iValue: Integer;
  NewDV: Integer;
begin
  {$REGION 'Doc_Calc_DC_IBAN'}
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /// Calculo del DC del IBAN
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //   1) Tomas el numero de cuenta sin espacios ni guiones ni nada (ejemplo aleman, sin digitos de control) :
  //      370400440532013000
  //
  //   2) A�ades al final el pais y digitos de control vacios 00 ('ES00' � 'DE00' en el ejemplo):
  //      370400440532013000DE00
  //
  //   3) Cambias las letras que queden a numeros segun esta tabla:
  //      A=10, B=11, C=12, D=13, E=14, F=15, G=16, H=17, I=18, J=19, K=20, L=21, M=22,
  //      N=23, O=24, P=25, Q=26, R=27, S=28, T=29, U=30, V=31, W=32, X=33, Y=34, Z=35
  //
  //      370400440532013000DE00 se convierte en 370400440532013000131400
  //
  //   4) 370400440532013000131400 mod 97 = 9
  //
  //   5) 98 - 9 = 89
  //      Al final quedaria asi: DE89 37040044 0532013000
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  {$ENDREGION}

  AValidar := Self.GetStrAValidar(inCCC);
  iValue   := TIBANFuncs.Mod97(AValidar);
  NewDV    := 98 - iValue;

  if NewDV < 10 then //Solo para asegurar que tengas 2 digitos.
     Result := '0' + IntToStr(NewDV)
  else
     Result := IntToStr(NewDV);
end;

function TrBancoIBANInfo.IsValid_DC(inCCC: String; Errores: TStringList=nil): Boolean;
var
  AValidar: string;
begin
  // Generamos la linea para validar
  AValidar := Self.GetStrAValidar(inCCC);

  // Valida
  Result := TIBANFuncs.Mod97(AValidar) = 1;

  if (not Result) then
     TIBANFuncs.AddNotNil(IBANInvalidoStr, Errores);
end;

function TrBancoIBANInfo.IsValid_Base(Errores: TStringList=nil): Boolean;
begin
  Result := True;

  if (Self.Pais.IsEmpty) or (Self.Pais.Length < 2) then
  begin
     TIBANFuncs.AddNotNil(PaisIBANInvalidoStr, Errores);
     Result := False;
  end;

  if (Self.DC.IsEmpty) or (Self.DC.Length < 2) or (StrToIntDef(Self.DC, -1) = -1) then
  begin
     TIBANFuncs.AddNotNil(DcIBANInvalidoStr, Errores);
     Result := False;
  end;
end;

function TrBancoIBANInfo.IsValid(inCCC: String; Errores: TStringList=nil): Boolean;
begin
  if Self.IsValid_Base(Errores) and
     Self.IsValid_DC(inCCC, Errores) then
  begin
     Result := True;
  end
  else
  begin
     Result := False;
  end;
end;

{ TrBancoCCCInfoESP }

function TrBancoCCCInfoESP.ToCCC(Sep:string=''): string;
begin
  Result := Self.Entidad + Sep +
            Self.Oficina + Sep +
            Self.DC      + Sep +
            Self.Cuenta;
end;

function TrBancoCCCInfoESP.Build(inEntidad, inOficina, inDC, inCuenta: string): TrBancoCCCInfoESP;
begin
  Self.Entidad := inEntidad;
  Self.Oficina := inOficina;
  Self.DC      := inDC;
  Self.Cuenta  := inCuenta;
end;

function TrBancoCCCInfoESP.Build(inCCC: string): TrBancoCCCInfoESP;
var
  Value: string;
begin
  Value := TIBANFuncs.GetNumbersOnly(inCCC);

  Self.Entidad := Copy(Value, 1 , 4);
  Self.Oficina := Copy(Value, 5 , 4);
  Self.DC      := Copy(Value, 9 , 2);
  Self.Cuenta  := Copy(Value, 11, Length(Value));
end;

end.
