unit U_Conway_Vcl;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  U_Grid;

type
  TForm1 = class(TForm)
    Button1   : TButton;
    Timer1    : TTimer;
    PaintBox1 : TPaintBox;
    procedure Button1Click  (Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
    procedure Timer1Timer   (Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;


implementation
{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  U_Grid.Init_Coros(PaintBox1);
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  U_Grid.Init;
end;


procedure TForm1.PaintBox1Click(Sender: TObject);
begin
  var x := (Mouse.CursorPos.X - PaintBox1.ClientOrigin.X) div CELL_SIZE;
  var y := (Mouse.CursorPos.Y - PaintBox1.ClientOrigin.Y) div CELL_SIZE;

  U_Grid.FlipCell(x,y);
  U_Grid.UpdateGrid_Coro(PaintBox1);
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
  U_Grid.ProcessCells_Coro(PaintBox1);
end;

end.


