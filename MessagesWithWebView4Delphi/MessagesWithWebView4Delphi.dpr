program MessagesWithWebView4Delphi;

uses
  Forms,
  uMainForm in 'uMainForm.pas' {Form1},
  uExtensionForm in 'uExtensionForm.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
