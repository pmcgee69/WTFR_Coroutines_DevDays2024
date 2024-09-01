program Project4;

uses
  Vcl.Forms,
  U_Conway_Original in 'U_Conway_Original.pas' {Form1},
  U_Grid_Norm in 'U_Grid_Norm.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
