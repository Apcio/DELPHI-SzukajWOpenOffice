unit OknoGlowne;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ActiveX, ComObj,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.Samples.Spin,
  Vcl.Imaging.pngimage, PrzeszukajPliki;

type
  TPobierzElementEvent = procedure(poz: Integer; var obiekt: TZnalezione) of Object;

type
  TPrzeszukajOO = class(TForm)
    Label1: TLabel;
    sciezkaEdit: TButtonedEdit;
    ImageList1: TImageList;
    FileOpenDialog1: TFileOpenDialog;
    podfolderyChk: TCheckBox;
    szukajTresc: TEdit;
    Label2: TLabel;
    Button1: TButton;
    CheckBox4: TCheckBox;
    wynikiLista: TListBox;
    opisMemo: TMemo;
    Image1: TImage;
    procedure sciezkaEditRightButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrzeszukajV2Click(Sender: TObject);
    procedure podfolderyChkClick(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
  private
    { Private declarations }

    zdarzeniePobierzElement: TPobierzElementEvent;

    procedure wstawElementDoListy(nazwa: string);
    procedure czyscListe();

  public
    { Public declarations }
  end;

var
  PrzeszukajOO: TPrzeszukajOO;

implementation

{$R *.dfm}

procedure TPrzeszukajOO.CheckBox4Click(Sender: TObject);
begin
  przeszukajKlasa.wyrazenieRegularne := CheckBox4.Checked;
end;

procedure TPrzeszukajOO.FormCreate(Sender: TObject);
begin
  przeszukajKlasa := TPrzeszukajPlikiKlasa.Create(Self);
  przeszukajKlasa.zdarzenieZnalezione := wstawElementDoListy;
  przeszukajKlasa.zdarzenieCzysc := czyscListe
end;

procedure TPrzeszukajOO.podfolderyChkClick(Sender: TObject);
begin
  przeszukajKlasa.podkatalogi := podfolderyChk.Checked;
end;

procedure TPrzeszukajOO.PrzeszukajV2Click(Sender: TObject);
begin
  przeszukajKlasa.szukaj(szukajTresc.Text, sciezkaEdit.Text);
end;

procedure TPrzeszukajOO.sciezkaEditRightButtonClick(Sender: TObject);
begin
  if FileOpenDialog1.Execute() = True then
    sciezkaEdit.Text := FileOpenDialog1.FileName;
end;

procedure TPrzeszukajOO.wstawElementDoListy(nazwa: string);
begin
  wynikiLista.Items.Add(nazwa);
end;

procedure TPrzeszukajOO.czyscListe();
begin
  wynikiLista.Items.Clear();
end;

end.
