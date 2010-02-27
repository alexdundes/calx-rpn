unit uAboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TAboutForm = class(TForm)
    Image1: TImage;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Titulo = 'Calx-RPN V. 0.05';

implementation

{$R *.dfm}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Caption := 'Sobre o ' + Titulo;
  Label1.Caption := Titulo;
  Image1.Picture.Assign(Application.Icon);
end;

end.
