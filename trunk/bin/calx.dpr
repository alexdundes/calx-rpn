program calx;

uses
  Forms,
  wPrincipalForm in 'wPrincipalForm.pas' {PrincipalForm},
  uCalx in 'uCalx.pas',
  uAboutForm in 'uAboutForm.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPrincipalForm, PrincipalForm);
  Application.Run;
end.
