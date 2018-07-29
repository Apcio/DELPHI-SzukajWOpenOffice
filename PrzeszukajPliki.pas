unit PrzeszukajPliki;

interface

uses
  System.Generics.Collections, ActiveX, ComObj, System.Classes, System.StrUtils, System.IOUtils,
  System.Types, System.Variants;

type
  TZnalezione = record
    nazwaPliku: string;
    sciezka: string;
    liczba: integer;
  end;

type
  TZnalazlemEvent = procedure(nazwa: string) of object;
  TCzyscEvent = procedure of object;
  TPobierzElementEvent = procedure(poz: Integer; var obiekt: TZnalezione) of object;

type
  TPrzeszukajPlikiKlasa = class(TComponent)
  private
    oo: Variant;
    oknoOO: Variant;
    parametry: Variant;
    dokument: Variant;

    listaZnalezionych: TArray<TZnalezione>;

    procedure informujOZdarzeniuZnalezione(element: TZnalezione);
    procedure informujOZdarzeniuCzysc();

    function pobierzListePlikow(katalog: string): TStringDynArray;
    function testujPlik(sciezka: string; szukana: string): TZnalezione;

  public
    zdarzenieZnalezione: TZnalazlemEvent;
    zdarzenieCzysc: TCzyscEvent;
    zdarzeniePobierzElement: TPobierzElementEvent;

    podkatalogi: Boolean;
    wyrazenieRegularne: Boolean;

    procedure szukaj(tekst: string; katalog: string);
  end;

var
  przeszukajKlasa: TPrzeszukajPlikiKlasa;

implementation

procedure TPrzeszukajPlikiKlasa.szukaj(tekst: string; katalog: string);
var
  pliki: TStringDynArray;
  i: Integer;
  obiekt: TZnalezione;
begin
  SetLength(listaZnalezionych, 0);
  informujOZdarzeniuCzysc();

  pliki := pobierzListePlikow(katalog);

  oo := CreateOleObject('com.sun.star.ServiceManager');
  oknoOO := oo.CreateInstance('com.sun.star.frame.Desktop');
  parametry := VarArrayCreate([0, 0], VarVariant);
  parametry[0] := oo.Bridge_getStruct('com.sun.star.beans.PropertyValue');
  parametry[0].Name := 'Hidden';
  parametry[0].Value := True;

  for i := 0 to Length(pliki) - 1 do
  begin
    obiekt := testujPlik(pliki[i], tekst);
    if obiekt.liczba > 0 then
    begin
      SetLength(listaZnalezionych, SizeOf(listaZnalezionych) + 1);
      listaZnalezionych[SizeOf(listaZnalezionych) - 1] := obiekt;
      informujOZdarzeniuZnalezione(obiekt);
    end;
  end;

  oknoOO := Unassigned();
  parametry := UnAssigned();
  oo := Unassigned();
end;

procedure TPrzeszukajPlikiKlasa.informujOZdarzeniuZnalezione(element: TZnalezione);
begin
  if Assigned(zdarzenieZnalezione) then
    zdarzenieZnalezione(element.nazwaPliku);
end;

procedure TPrzeszukajPlikiKlasa.informujOZdarzeniuCzysc();
begin
  if Assigned(zdarzenieCzysc) then
    zdarzenieCzysc();
end;

function TPrzeszukajPlikiKlasa.pobierzListePlikow(katalog: string): TStringDynArray;
var
  opcjeWyszukiwania: TSearchOption;
begin
  if podkatalogi = True then
    opcjeWyszukiwania := TSearchOption.soAllDirectories
  else
    opcjeWyszukiwania := TSearchOption.soTopDirectoryOnly;

  Result := TDirectory.GetFiles(katalog, '*.odt', opcjeWyszukiwania, nil);
end;

function TPrzeszukajPlikiKlasa.testujPlik(sciezka: string; szukana: string): TZnalezione;
var
  sciezkaOO: string;
  szukacz: Variant;
  znalezione: Variant;
begin
  Result.sciezka := sciezka;
  Result.nazwaPliku := TPath.GetFileName(sciezka);
  Result.liczba := 0;

  sciezkaOO := 'file:///' + ReplaceStr(sciezka, '\', '/');

  Dokument := oknoOO.LoadComponentFromURL(sciezkaOO, '_blank', 0, parametry);

  szukacz := Dokument.createSearchDescriptor;
  szukacz.setSearchString(szukana);
  szukacz.SearchCaseSensitive := False;
  szukacz.SearchRegularExpression := wyrazenieRegularne;

  znalezione := Dokument.FindFirst(szukacz);

  while ((VarIsNull(znalezione) = False) AND (VarIsEmpty(znalezione) = False) AND (VarIsType(znalezione, varUnknown) = False)) do
  begin
    Inc(Result.liczba);
    znalezione := Dokument.FindNext(znalezione.End, szukacz);
  end;

  Dokument.Close(False);
  Dokument := UnAssigned();
end;

end.
