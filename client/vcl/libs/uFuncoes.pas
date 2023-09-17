unit uFuncoes;

interface

type
  Funcoes = class
  public
    {$REGION 'Funções de texto'}
     class function  PegaSeq(Texto : String; posicao : Integer;sep : String = '|') : String;
     class function  ContaSeq(Texto : String; Sep: String = '|') : Integer;
     class function  ContaSeqSD(Texto : String; Sep: String = '|') : Integer;
     class function  AchaPosSeq(Texto,Oque : String;sep : String = '|') : Integer;
     class function  ApagaSeq(Texto : String;indice : Integer;sep : String = '|') : String;
     class function  ClonarTexto(Texto : String; Quant : Integer) : String;
     class function  LPAD(Texto : String; Tamanho : Integer; Adicionar : String) : String;
     class function  RPAD(Texto : String; Tamanho : Integer; Adicionar : String) : String;
     class function  PosR(OQue: String; Onde: String) : Integer;
     class function  GeraStringRandomica(Tamanho : Integer; Tipo : Word) : String;
     class function  RetornaValorExtenso(fValor : Real) : String;
     {$ENDREGION}
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Math;

{ Funcoes }

class function Funcoes.AchaPosSeq(Texto, Oque, sep: String): Integer;
// Retorna a posicao de um item em uma sequencia
// Exemplo: achaposseq('1,ab,3,4','ab') = 2
Var i   : Integer;
begin
   Result := 0;
   for i := 1 to contaseq(Texto,Sep) do begin
      if pegaseq(Texto,i,sep) = Oque then begin
         Result := i;
         break;
      end;
   end;
end;

class function Funcoes.ApagaSeq(Texto: String; indice: Integer;
  sep: String): String;
// Retorna uma sequencia excluindo o item informado
// Exemplo: apagaseq('1,2,3,4',2) = '1,3,4'
Var
   i   : Integer;
   aux : String;
begin
   Result := '';
   for i := 1 to contaseq(Texto,Sep) do begin
      Aux := pegaseq(Texto,i,sep);
      if i <> Indice then begin
         if Result <> '' then Result := Result + Sep;
         Result := Result + Aux;
      end;
   end;
end;

class function Funcoes.ClonarTexto(Texto: String; Quant: Integer): String;
Var i : Integer;
Begin
   Result := '';
   for i := 1 to Quant do Result := Result + texto;
end;

class function Funcoes.ContaSeq(Texto, Sep: String): Integer;
// Retorna a quantidade de dados em uma sequencia do tipo: 23,78,58,90
// Exemplo: contaseq(tipo) = 4
Var conta : Integer; tmp : String;
begin
   conta  := 0;
   while length(Texto) > 0 do begin
      if pos(sep,Texto) > 0 then begin
         tmp   := copy(Texto,1,pos(sep,Texto)-1);
         Texto := copy(Texto,pos(sep,texto)+1,length(Texto));
         inc(conta);
      end else begin
         tmp := texto;
         inc(conta);
         texto := '';
      end;
   end;
   Result := conta;
end;

class function Funcoes.ContaSeqSD(Texto, Sep: String): Integer;
Var
   sl    : TStringList;
begin
   sl                 := TStringList.Create;
   sl.StrictDelimiter := True;
   sl.Delimiter       := Sep[1];
   sl.DelimitedText   := Texto;
   Result := sl.Count;
end;

class function Funcoes.GeraStringRandomica(Tamanho: Integer;
  Tipo: Word): String;
//fonte: http://showdelphi.com.br/dica-funcao-para-gerar-uma-senha-aleatoria-delphi/
var I: Integer; Chave: String;
const
   str1 = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
   str2 = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   str3 = '1234567890abcdefghijklmnopqrstuvwxyz';
   str4 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
   str5 = '1234567890';
   str6 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   str7 = 'abcdefghijklmnopqrstuvwxyz';
   str8 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'; //base32
begin
   Chave := '';
   for I := 1 to Tamanho do begin
      case Tipo of
         1 : Chave := Chave + str1[Random(Length(str1)) + 1];
         2 : Chave := Chave + str2[Random(Length(str2)) + 1];
         3 : Chave := Chave + str3[Random(Length(str3)) + 1];
         4 : Chave := Chave + str4[Random(Length(str4)) + 1];
         5 : Chave := Chave + str5[Random(Length(str5)) + 1];
         6 : Chave := Chave + str6[Random(Length(str6)) + 1];
         7 : Chave := Chave + str7[Random(Length(str7)) + 1];
         8 : Chave := Chave + str8[Random(Length(str7)) + 1];
      end;
   end;
   Result := Chave;
end;

class function Funcoes.LPAD(Texto: String; Tamanho: Integer;
  Adicionar: String): String;
var i, TamAtual, TamAdd : Integer; sAux : String;
begin
   TamAtual := Length(Texto);
   TamAdd   := Tamanho - TamAtual;
   if TamAdd > 0 then
      sAux := ClonarTexto(Adicionar,TamAdd)
   else
      sAux := '';
   Result := sAux + Texto;
end;

class function Funcoes.PegaSeq(Texto: String; posicao: Integer;
  sep: String): String;
// Retorna a string n de uma sequencia do tipo: 23,78,58,90 ou 10|25|52|58
// Exemplo: pegaseq(tipo,2) = 78
var sl : TStringList;
begin
   try
      sl := TStringList.Create;
      sl.StrictDelimiter := True;
      sl.Delimiter       := Sep[1];
      sl.DelimitedText   := Texto;
      if (sl.Count) < posicao then
         Result := ''
      else
         Result := sl.Strings[Posicao-1];
   finally
      FreeAndNil(sl);
   end;
end;

class function Funcoes.PosR(OQue, Onde: String): Integer;
var
   Pos, Tam1, Tam2 : Integer;
   Achou : Boolean;
begin
   Tam1   := Length(OQue);
   Tam2   := Length(Onde);
   Pos    := Tam2-Tam1+1;
   Achou  := False;
   while (Pos >= 1) and not Achou do begin
      if Copy(Onde, Pos, Tam1) = OQue then
         Achou := True
      else
         Pos := Pos - 1;
   end;
   Result := Pos;
end;

class function Funcoes.RetornaValorExtenso(fValor: Real): String;
//fonte: https://www.devmedia.com.br/valor-por-extenso-delphi/21974
const
   unidade: array[1..19] of string = (
      'Um', 'Dois', 'Três', 'Quatro', 'Cinco',
      'Seis', 'Sete', 'Oito', 'Nove', 'Dez', 'Onze',
      'Doze', 'Treze', 'Quatorze', 'Quinze', 'Dezesseis',
      'Dezessete', 'Dezoito', 'Dezenove'
   );
   centena: array[1..9] of string = (
      'Cento', 'Duzentos', 'Trezentos',
      'Quatrocentos', 'Quinhentos', 'Seiscentos',
      'Setecentos', 'Oitocentos', 'Novecentos'
   );
   dezena: array[2..9] of string = (
      'Vinte', 'Trinta', 'Quarenta', 'Cinquenta', 'Sessenta', 'Setenta', 'Oitenta', 'Noventa'
   );
   qualificaS: array[0..4] of string = ('', 'Mil', 'Milhão',  'Bilhão',  'Trilhão');
   qualificaP: array[0..4] of string = ('', 'Mil', 'Milhões', 'Bilhões', 'Trilhões');
var
   inteiro: Int64;
   resto: real;
   fValorS, s, sAux, fValorP, centavos: string;
   n, unid, dez, cent, tam, i: integer;
   umReal, tem: boolean;
begin
   if (fValor = 0) then begin
      Result := 'zero';
      exit;
   end;
   inteiro  := trunc(fValor);    // parte inteira do valor
   resto    := fValor - inteiro; // parte fracionária do valor
   fValorS  := IntToStr(inteiro);
   if (length(fValorS) > 15) then begin
      Result := 'Erro: valor superior a 999 trilhões.';
      exit;
   end;
   s := '';
   centavos := IntToStr(round(resto * 100));
   // definindo o extenso da parte inteira do valor
   i := 0;
   umReal := false; tem := false;
   while (fValorS <> '0') do  begin
      tam := length(fValorS);
      // retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
      // 1a. parte = 789 (centena)
      // 2a. parte = 456 (mil)
      // 3a. parte = 123 (milhões)
      if (tam > 3) then begin
         fValorP := copy(fValorS, tam-2, tam);
         fValorS := copy(fValorS, 1, tam-3);
      end else begin // última parte do valor
         fValorP := fValorS;
         fValorS := '0';
      end;
      if (fValorP <> '000') then begin
         sAux := '';
         if (fValorP = '100') then
            sAux := 'cem'
         else begin
            n     := strtoint(fValorP);   // para n = 371, tem-se:
            cent  := n div 100;           // cent = 3 (centena trezentos)
            dez   := (n mod 100) div 10;  // dez  = 7 (dezena setenta)
            unid  := (n mod 100) mod 10;  // unid = 1 (unidade um)
            if (cent <> 0) then
               sAux := centena[cent];
            if ((dez <> 0) or (unid <> 0)) then begin
               if ((n mod 100) <= 19) then begin
                  if (length(sAux) <> 0) then
                     sAux := sAux + ' e ' + unidade[n mod 100]
                  else
                     sAux := unidade[n mod 100];
               end else begin
                  if (length(sAux) <> 0) then
                     sAux := sAux + ' e ' + dezena[dez]
                  else
                     sAux := dezena[dez];
                  if (unid <> 0) then
                     if (length(sAux) <> 0) then
                        sAux := sAux + ' e ' + unidade[unid]
                     else
                        sAux := unidade[unid];
               end;
            end;
         end;
         if ((fValorP = '1') or (fValorP = '001')) then begin
            if (i = 0)  then        // 1a. parte do valor (um real)
               umReal := true
            else
               sAux := sAux + ' ' + qualificaS[i];
         end else if (i <> 0) then
            sAux := sAux + ' ' + qualificaP[i];
         if (length(s) <> 0) then
            s := sAux + ', ' + s
         else
            s := sAux;
      end;
      if (((i = 0) or (i = 1)) and (length(s) <> 0)) then
         tem := true;               // tem centena ou mil no valor
      i := i + 1;                   // próximo qualificador: 1- mil, 2- milhão, 3- bilhão, ...
   end;
   if (length(s) <> 0) then begin
      if (umReal) then
         s := s + ' Real'
      else if (tem) then
         s := s + ' Reais'
      else
         s := s + ' de Reais';
   end;
   // definindo o extenso dos centavos do valor
   if (centavos <> '0') then begin  // valor com centavos
      if (length(s) <> 0)  then     // se não é valor somente com centavos
         s := s + ' e ';
      if (centavos = '1') then
         s := s + 'um Centavo'
      else begin
         n := strtoint(centavos);
         if (n <= 19) then
            s := s + unidade[n]
         else begin                 // para n = 37, tem-se:
            unid := n mod 10;       // unid = 37 % 10 = 7 (unidade sete)
            dez := n div 10;        // dez  = 37 / 10 = 3 (dezena trinta)
            s := s + dezena[dez];
            if (unid <> 0)
            then s := s + ' e ' + unidade[unid];
         end;
         s := s + ' Centavos';
      end;
   end;
   Result := s;
end;

class function Funcoes.RPAD(Texto: String; Tamanho: Integer;
  Adicionar: String): String;
var i, TamAtual, TamAdd : Integer; sAux : String;
begin
   TamAtual := Length(Texto);
   TamAdd   := Tamanho - TamAtual;
   if TamAdd > 0 then
      sAux := ClonarTexto(Adicionar,TamAdd)
   else
      sAux := '';
   Result := Texto+sAux;
end;

end.
