unit U_Grid;        // Coroutine version

interface
uses
   System.SysUtils, Vcl.ExtCtrls, Vcl.Graphics;

procedure Init;
procedure UpdateGrid(PB:TPaintBox);
procedure FlipCell (x,y:integer);
procedure Process_Cells(PB:TPaintBox);

const
   CELL_SIZE = 20; // size of each cell in pixels
   NUM_CELLS = 50; // number of cells in each row and column

implementation

var
   cellMatrix: array[0..NUM_CELLS - 1, 0..NUM_CELLS - 1] of Integer;
   tempMatrix: array[0..NUM_CELLS - 1, 0..NUM_CELLS - 1] of Integer;


procedure Init;
begin
  // set all cells to 0 (dead)                                //  omg   💀
  for var i := 0 to NUM_CELLS - 1 do                          //
  for var j := 0 to NUM_CELLS - 1 do                          //
      cellMatrix[i, j] := 0;                                  //
                                                              //
  // set some random cells to 1 (alive)                       //
  Randomize;                                                  //
  for var i := 0 to NUM_CELLS - 1 do                          //
  for var j := 0 to NUM_CELLS - 1 do                          //
      if Random(2) = 1 then cellMatrix[i, j] := 1;            //
end;


procedure DrawGrid(PB:TPaintBox);
begin
  PB.Canvas.Pen.Color := clBlack;
  for var i := 1 to NUM_CELLS do
  begin
    PB.Canvas.MoveTo(i * CELL_SIZE, 0);
    PB.Canvas.LineTo(i * CELL_SIZE, NUM_CELLS * CELL_SIZE); // vertical lines
    PB.Canvas.MoveTo(0, i * CELL_SIZE);
    PB.Canvas.LineTo(NUM_CELLS * CELL_SIZE, i * CELL_SIZE); // horizontal lines
  end;
end;


procedure DrawCells(PB:TPaintBox);
begin
  for var i := 0 to NUM_CELLS - 1 do
  for var j := 0 to NUM_CELLS - 1 do
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
end;


procedure UpdateGrid(PB:TPaintBox);
begin
   DrawGrid (PB);
   DrawCells(PB);
end;


procedure FlipCell (x,y:integer);
begin
  if cellMatrix[x, y] = 1 then cellMatrix[x, y] := 0
                          else cellMatrix[x, y] := 1;
end;


function GetNeighborCount(row, col: Integer): Integer;
begin
  var neighborCount := 0;
  for var i := row - 1 to row + 1 do
  for var j := col - 1 to col + 1 do
    begin
      // check if the cell is within the bounds of the matrix
      if (i >= 0) and (j >= 0)
                  and (i < NUM_CELLS) and (j < NUM_CELLS)
                  and ( (i <> row) or (j <> col) )         // exclude the current cell
      then
         if cellMatrix[i, j] = 1 then Inc(neighborCount);
    end;
  Result := neighborCount;
end;


{  Calculate the new state of each cell based on the rules of the game

   rule 1: any live cell with fewer than two live neighbors dies, as if by underpopulation
   rule 2: any live cell with two or three live neighbors lives on to the next generation
   rule 3: any live cell with more than three live neighbors dies, as if by overpopulation
   rule 4: any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction
}

procedure Process_Cells(PB:TPaintBox);
var i,j:integer;
begin
  // use the temporary matrix for calculations to avoid changing the cell states prematurely
  for i := 0 to NUM_CELLS - 1 do
  for j := 0 to NUM_CELLS - 1 do
      tempMatrix[i, j] := cellMatrix[i, j];

  for i := 0 to NUM_CELLS - 1 do
  for j := 0 to NUM_CELLS - 1 do
    begin
      var neighborCount := GetNeighborCount(i, j);
      if (cellMatrix[i, j] = 1) and (neighborCount < 2) then
          tempMatrix[i, j]:= 0
      else
      if (cellMatrix[i, j] = 1) and (neighborCount > 3) then
          tempMatrix[i, j]:= 0
      else
      if (cellMatrix[i, j] = 0) and (neighborCount = 3) then
          tempMatrix[i, j]:= 1;
    end;

  for i := 0 to NUM_CELLS - 1 do
  for j := 0 to NUM_CELLS - 1 do
      cellMatrix[i, j] := tempMatrix[i, j];   // update the cellMatrix with the new states

  UpdateGrid(PB);
end;

end.