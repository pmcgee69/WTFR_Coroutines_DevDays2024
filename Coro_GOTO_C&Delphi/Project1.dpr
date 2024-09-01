{$APPTYPE CONSOLE}
program Project1;
uses system.Character;
type
  range_struct = record
      type
         Tstate = (at_start, in_loop, done);
      var
         ch_in,
         ch_out  : char;
            s    : string;
         stop,
         i, rep  : integer;
         state   : Tstate;

      constructor λ(_str:string);
      function    resume() : char;
  end;

  constructor range_struct.λ(_str:string);
  begin
      s     := _str;
      state := at_start;
  end;

  function range_struct.resume() : char;
  label α,β,δ;
  begin
           case state of
                at_start : goto α;
                in_loop  : goto β;
                done     : goto δ;
           end;

     α :   i     := 0;
           rep   := 0;
           state := in_loop;
           stop  := length(s);

           begin
     β :       if rep > 0  then begin
                  dec(rep);
                  exit(ch_out);
               end;

               if i = stop then state := done
               else
               begin
                  inc(i);
                  ch_in := s[i];
                  if not (ch_in in ['0'..'9']) then state := done;

                  rep := ord(ch_in)-$30;
                  inc(i);
                  ch_out := s[i];
                  dec(rep);
                  exit(ch_out);
               end;
           end;

     δ :   exit(#0);

  end;

begin
   var π := range_struct.λ('3w1.1g6o1g1l1e1.1c2o3m');
   var ch:  char;
   repeat
      ch := π.resume;
      if ch>#0 then write(ch)
               else write(' ::');
   until ch = #0;

   writeln;
   writeln;
   writeln('Mwah ha ha. GOTO is back, baby!');
   readln;
end.



