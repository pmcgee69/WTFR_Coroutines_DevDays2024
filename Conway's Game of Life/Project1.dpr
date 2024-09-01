program Project1;

uses
  Vcl.Forms,
  U_Conway_vcl in 'U_Conway_vcl.pas' {Form1},
  U_Grid in 'U_Grid.pas',
  U_Patterns in 'U_Patterns.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
