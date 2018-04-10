unit IBAN.Funcs;

interface

uses
  System.Classes;

type
  // Funciones Genericas
  TIBANFuncs = class
  public
    class function GetNumbersOnly(value: string): string;
    class function GetAlphaNumericsOnly(value: string): string;

    class function Mod97(value: String): Integer;

    class procedure AddNotNil(value: string; Lista: TStringList=nil);
  end;

implementation

uses
  System.SysUtils;

{ TIBANFuncs }

class function TIBANFuncs.GetNumbersOnly(value: string): string;

  function IsNumber(Caracter: Char): Boolean;
  begin
     Result := CharInSet(Caracter, ['0'..'9']);
  end;

  var
  i: Integer;
begin
  Result := '';

  Value := Trim(Value);
  for i:=1 to Length(Value) do
  begin
     if IsNumber(Value[i]) then
        Result := Result + Value[i];
  end;
end;

class function TIBANFuncs.GetAlphaNumericsOnly(value: string): string;

  function IsAlphaNumeric(Caracter: Char): Boolean;
  begin
     Result := CharInSet(Caracter, ['A'..'Z']) or
               CharInSet(Caracter, ['a'..'z']) or
               CharInSet(Caracter, ['0'..'9']);
  end;

var
  i: Integer;
begin
  Result := '';

  Value := Trim(Value);
  for i:=1 to Length(Value) do
  begin
     if IsAlphaNumeric(Value[i]) then
        Result := Result + Value[i];
  end;
end;

class function TIBANFuncs.Mod97(value: String): Integer;
begin
  Result := 0;
  while Length(value) > 0 do
  begin
     Result := StrToIntDef(IntToStr(Result) + Copy(value,1,6), 0) mod 97;
     Delete(value,1,6);
  end;
end;

class procedure TIBANFuncs.AddNotNil(value: string; Lista: TStringList=nil);
begin
  if Assigned(Lista) then
     Lista.Add(value);
end;

end.
