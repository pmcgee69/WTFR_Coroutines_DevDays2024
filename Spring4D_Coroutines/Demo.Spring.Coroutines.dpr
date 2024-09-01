{$APPTYPE CONSOLE}
program Demo.Spring.Coroutines;
uses
  SysUtils, Spring, Spring.Collections, Spring.Coroutines, Spring.Collections.Generators;

procedure say(i:integer); overload; begin for var x in [1..i] do writeln end;
procedure say(s:string);  overload; begin say(2);  writeln(s);   writeln end;

procedure Fibonacci(const n: Integer);
begin
  var a := 0;
  var b := 1;
      for var i := 0 to n do begin
          var c := a;
              a := b;
              b := c + b;
              Yield(c);
      end;
end;

procedure Main;
var
  fibo1 : Func<Integer,IEnumerable<UInt64>>;
  fibo2 : IEnumerable<UInt64>;
  foo   : Func<Integer,Integer>;
  foo2  : Func<Integer>;
begin

  fibo1 := TGenerator<Integer, UInt64>.Create(Fibonacci);

  say('fibo1 : Int -> IEnumerable');
  for var i in fibo1(10) do Write(i, ' ');  writeln;  writeln;

  var x:=fibo1(10);
  Write(x.First, ' ');  writeln;  writeln;



  fibo2 := TGenerator<Integer, UInt64>.Create(Fibonacci) . Bind(10);

  say('fibo2 : IEnumberable   { Int -> IEnumerable initialised with 10}');
  for var i in fibo2 do Write(i, ' ');  writeln;  writeln;


  foo := TCoroutine<Integer,Integer>.Create(  procedure(const a: Integer)
                                              begin
                                                 Yield(a);
                                                 Yield(a + 1);
                                                 Yield(a + 2);
                                              end);
  say('function foo yielding {a, a+1, a+2}');
  writeln('foo(1)  ',foo(1));
  writeln('foo(1)  ',foo(1));
  writeln('foo(1)  ',foo(1));
  writeln('foo(1)  ',foo(1));
  writeln('foo(2)  ',foo(2));
  writeln('foo(2)  ',foo(2));
  writeln;


  foo2 := TCoroutine<Integer,Integer>.Create( procedure(const a: Integer)
                                              begin
                                                var c:=a;
                                                while true do begin Yield(c); inc(c) end;
                                              end
                                            ) . Bind(1);

  say('function foo2 yielding {+1} initialised with arg=1');
  for var i in [1..10] do begin Write(foo2, ' '); readln end;

  say(3);
end;


begin
  Main;
  Readln;
  ReportMemoryLeaksOnShutdown := True;
end.
