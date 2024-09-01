unit U_Conway_Original;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  U_Grid_Norm;

type
  TForm1 = class(TForm)
    Button1   : TButton;
    Timer1    : TTimer;
    PaintBox1 : TPaintBox;
    procedure Button1Click  (Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
    procedure Timer1Timer   (Sender: TObject);
  end;

var
  Form1: TForm1;


implementation
{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
  U_Grid_Norm.Init;
end;


procedure TForm1.PaintBox1Click(Sender: TObject);
begin
  var x := (Mouse.CursorPos.X - PaintBox1.ClientOrigin.X) div CELL_SIZE;
  var y := (Mouse.CursorPos.Y - PaintBox1.ClientOrigin.Y) div CELL_SIZE;

  U_Grid_Norm.FlipCell(x,y);
  U_Grid_Norm.UpdateGrid(PaintBox1);
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
  U_Grid_Norm.Process_Cells(PaintBox1);
end;

end.


