program Szukaj;

uses
  Vcl.Forms,
  OknoGlowne in 'OknoGlowne.pas' {PrzeszukajOO},
  PrzeszukajPliki in 'PrzeszukajPliki.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPrzeszukajOO, PrzeszukajOO);
  Application.Run;
end.
