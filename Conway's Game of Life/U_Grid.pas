unit U_Grid;                                      // Coroutine version

interface
uses
   System.SysUtils, Vcl.ExtCtrls, Vcl.Graphics;

procedure Init;
procedure Init_Coros(PB:TPaintBox);
procedure FlipCell (x,y:integer);
procedure UpdateGrid_Coro(PB:TPaintBox);
procedure ProcessCells_Coro(PB:TPaintBox);

const
   CELL_SIZE = 20; // size of each cell in pixels
   NUM_CELLS = 50; // number of cells in each row and column


{  Calculate the new state of each cell based on the rules of the game

   Rule 1: any live cell with fewer than two live neighbors dies, as if by underpopulation
   Rule 2: any live cell with two or three live neighbors lives on to the next generation
   Rule 3: any live cell with more than three live neighbors dies, as if by overpopulation
   Rule 4: any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction
}


implementation
uses U_Patterns;

var
   cellMatrix: array[0..NUM_CELLS-1, 0..NUM_CELLS-1] of Integer;
   tempMatrix: array[0..NUM_CELLS-1, 0..NUM_CELLS-1] of Integer;
   cell_fn   : array[0..NUM_CELLS*NUM_CELLS-1] of TProc;               // 2500 anon fns


procedure Init;
begin
  for var i := 0 to NUM_CELLS - 1 do
  for var j := 0 to NUM_CELLS - 1 do
      cellMatrix[i, j] := 0;

  Randomize;
  for var i := 0 to NUM_CELLS - 1 do
  for var j := 0 to NUM_CELLS - 1 do
      if Random(2) = 1 then cellMatrix[i, j] := 1;
end;






procedure DrawGrid(PB:TPaintBox);
begin
  PB.Canvas.Pen.Color := clBlack;
  for var i := 0 to NUM_CELLS do
  begin
    PB.Canvas.MoveTo(i * CELL_SIZE, 0);
    PB.Canvas.LineTo(i * CELL_SIZE, NUM_CELLS * CELL_SIZE); // vertical lines
    PB.Canvas.MoveTo(0, i * CELL_SIZE);
    PB.Canvas.LineTo(NUM_CELLS * CELL_SIZE, i * CELL_SIZE); // horizontal lines
  end;
end;


procedure ProcessCells_Coro(PB:TPaintBox);
begin
  for var i := 0 to NUM_CELLS - 1 do
  for var j := 0 to NUM_CELLS - 1 do
      tempMatrix[i, j] := cellMatrix[i, j];

  var total_cells := NUM_CELLS*NUM_CELLS-1;

  for var i := 0 to total_cells do cell_fn[i]();
end;


procedure UpdateGrid_Coro(PB:TPaintBox);
begin
   DrawGrid(PB);
   ProcessCells_Coro(PB);
end;


procedure FlipCell (x,y:integer);
begin
  if cellMatrix[x, y] = 1 then cellMatrix[x, y] := 0
                          else cellMatrix[x, y] := 1;
end;


//  - -   - -   - -   - -   - -

function UpdateCell(row, col, neighbours:integer):integer;
begin
      result := tempMatrix[row,col];
      if (tempMatrix[row,col] = 1) and (neighbours < 2) then exit(0);
      if (tempMatrix[row,col] = 1) and (neighbours > 3) then exit(0);
      if (tempMatrix[row,col] = 0) and (neighbours = 3) then exit(1);
end;


function GetNeighborCount_Coro(row,col: integer; const pattern:string): integer;
begin
  var s := 1;
  var neighborCount := 0;
  for var i := row-1 to row+1 do
  for var j := col-1 to col+1 do
    begin
         if (pattern[s] = '1') and
            (tempMatrix[i, j] = 1) then Inc(neighborCount);
         inc(s);
    end;
  result := neighborCount;
end;


procedure DrawCell_Coro(i, j:integer; PB:TPaintBox);
begin
      if cellMatrix[i, j] = 1 then begin
         PB.Canvas.Brush.Color := clBlack; // alive cells are black
         PB.Canvas.Rectangle(i * CELL_SIZE, j * CELL_SIZE, (i + 1) * CELL_SIZE, (j + 1) * CELL_SIZE);
      end
      else begin
         PB.Canvas.Brush.Color := clWhite; // dead cells are white
         PB.Canvas.Rectangle(i * CELL_SIZE, j * CELL_SIZE, (i + 1) * CELL_SIZE, (j + 1) * CELL_SIZE);
      end;
end;



procedure Init_Coros(PB:TPaintBox);
begin
    var coro_fn := function(row, col:integer; const pattern:string) : TProc
                   begin
                   result := procedure
                                 begin
                                    var neighbours          := GetNeighborCount_Coro(row, col, pattern);
                                        cellMatrix[row,col] := UpdateCell(row,col,neighbours );
                                        DrawCell_coro(row, col, PB);
                                 end;
                   end;

    var N     := NUM_CELLS-1;
    var range := [1..N-1];

    cell_fn[0] := coro_fn( 0, 0, Cell_patterns[TL_Corner] );
    cell_fn[1] := coro_fn( 0, N, Cell_patterns[TR_Corner] );
    cell_fn[2] := coro_fn( N, 0, Cell_patterns[BL_Corner] );
    cell_fn[3] := coro_fn( N, N, Cell_patterns[BR_Corner] );

    var x:=4;
    var j:integer;

    for j in range do begin
        cell_fn[x] := coro_fn( 0, j, Cell_patterns[T_Edge] );
        inc(x);
    end;

    for j in range do begin
        cell_fn[x] := coro_fn( j, 0, Cell_patterns[L_Edge] );
        inc(x);
    end;

    for j in range do begin
        cell_fn[x] := coro_fn( j, N, Cell_patterns[R_Edge] );
        inc(x);
    end;

    for j in range do begin
        cell_fn[x] := coro_fn( N, j, Cell_patterns[B_Edge] );
        inc(x);
    end;

    var i : integer;

    for i in range do
    for j in range do begin
        cell_fn[x] := coro_fn( i, j, Cell_patterns[Middle] );
        inc(x);
    end;
end;


end.
