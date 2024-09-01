{$APPTYPE CONSOLE}
program Project2;

type
  range_struct = record
      type
         Tstate = (at_start, in_loop, done);
      var
         stop, step,
            i, start : integer;
         state       : Tstate;

      constructor λ( _start, _stop : integer; _step:integer = 1);
      function    resume() : integer;
  end;

  constructor range_struct.λ( _start, _stop, _step:integer);
  begin
      start := _start;
      stop  := _stop;
      step  := _step;
      state := at_start;
  end;

  function range_struct.resume() : integer;
  label α,β,δ;
  begin
           case state of
                at_start : goto α;
                in_loop  : goto β;
                done     : goto δ;
           end;

     α :   i:=start;
           repeat
               begin
                   state := in_loop;
                   exit(i);
     β :           i     := i + step;
               end
           until i >= stop;
           state := done;

     δ :   exit(0);

  end;

begin

   var x := range_struct.λ(3,20,4);

   writeln('1st call : ', x.resume);
   writeln('2nd call : ', x.resume);
   writeln('3rd call : ', x.resume);
   writeln('4th call : ', x.resume);
   writeln('5th call : ', x.resume);

   writeln;
   writeln('Mwah ha ha. GOTO is back, baby!');
   readln;
end.


            //  ˃ Ф Ж Ξ Π Ο Δ Ώ Ψ Ω π λ ρ σ τ φ χ ψ
            //  Δ Ψ π λ ψ


