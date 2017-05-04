program Reversii;

uses
    crt,sysutils;
type
    tmatriz=array[1..10,1..10] of char;
var
    matriz:tmatriz;
    sinmovidas,fin,turno,libres,blancas,negras,resultado,pasoturno:integer;
    colorjugador,colorpc,volverAJugar:char;
    nombre:string;

//Inicio
Procedure Inicio(var nombre:string;var colorJugador,colorpc:char;var fin,turno:integer);
var
    opcionUno:char;
    salir:integer;
Begin
    writeln('-------------------');
    writeln('     Reversi       ');
    writeln('-------------------');
    writeln();
    fin:=0;
    //Menu de opciones de ingreso de datos principales: nombre y color de ficha, se asignan a las variables correspondientes. Opcion de ver las instrucciones con vuelta al menu principal.
    writeln('Ingrese Nombre');
    readln(nombre);

    repeat
        clrscr;
        writeln('Bienvenido ',nombre,' elegi tu color presionando la letra correspondiente a continuacion: ' );
        writeln('a) Blanco b) Negro c)Instrucciones' );
        opcionUno:=readkey;
        //Arranca jugando las negras, turno 1 PC turno 0 Jugador
        case opcionUno of
            'a':
                Begin
                    colorJugador := 'B';
                    colorpc := 'N';
                    turno:=1;
                    salir := 1;
                end;
            'b':
                Begin
                    colorJugador := 'N';
                    colorpc := 'B';
                    turno:=0;
                    salir := 1;
                end;
            'c':
                Begin
                    clrscr;

                    writeln('El juego se inicia con cuatro fichas posicionadas en el centro del tablero ');
                    writeln('en forma de un cuadrado, dos mostrando el lado blanco hacia arriba y dos el lado ');
                    writeln('negro. El primer movimiento lo realiza el jugador con las fichas negras.');
                    readkey;
                    clrscr;
                end
            Else
                Begin
                    clrscr;
                    writeln('Opcion Incorrecta ');
                    readkey;
                end;
            end;
    until salir = 1;
End;

//Llenar matriz
Procedure Llenar_Matriz (var matriz:tmatriz);
var
        i:integer;
        num:string;
Begin
    //Se ejecuta un for en el que se llena el rango del tablero.
    For i:=1 to 10 do
        begin
            num := IntToStr(i-1);
            matriz[1,i]:= num[1];
            matriz[10,i]:= num[1];
            matriz[i,1]:= num[1];
            matriz[i,10]:= num[1];
        end;
    //Las posiciones por defecto, y valores nulos del tablero *.

    matriz[5,5]:='B';
    matriz[6,6]:='B';
    matriz[5,6]:='N';
    matriz[6,5]:='N';

        {matriz[5,4]:='N';
    matriz[5,5]:='N';
    matriz[5,6]:='B';
    matriz[5,7]:='N';}

    matriz[10,10]:='*';
    matriz[10,1]:='*';
    matriz[1,1]:='*';
    matriz[1,10]:='*';
End;

//Movimientos
Procedure Movimientos (var fila,columna:integer;cond:integer);
Begin
    Case Cond of
        1:
            Begin
                fila:=fila-1;
                columna:=columna;
            End;
        2:
            Begin
                fila:=fila-1;
                columna:=columna+1;
            End;
        3:
            Begin
                fila:=fila;
                columna:=columna+1;
            End;
        4:
            Begin
                fila:=fila+1;
                columna:=columna+1;
            End;
        5:
            Begin
                fila:=fila+1;
                columna:=columna;
            End;
        6:
            Begin
                fila:=fila+1;
                columna:=columna-1;
            End;
        7:
            Begin
                fila:=fila;
                columna:=columna-1;
            End;
        8:
            Begin
                fila:=fila-1;
                columna:=columna-1;
            End;
    End;
End;

//Intercambiador
Procedure Intercambiador ( var matriz:tmatriz; fila,columna,newfila,newcolumna,cond,tipo:integer;colorjugador,colorpc:char );
Var
    tempfila,tempcolumna:integer;
    ficha:char;
Begin
    IF ( tipo =1 ) Then
        ficha:= colorjugador;
    IF ( tipo =2 ) Then
        ficha:= colorpc;
    tempfila:=fila;
    tempcolumna:=columna;
    Movimientos(tempfila,tempcolumna,cond);
    REPEAT
        matriz[tempfila,tempcolumna]:=ficha;
        Movimientos(tempfila,tempcolumna,cond);
    UNTIL((tempfila=newfila) AND (tempcolumna=newcolumna));
End;

//Detector de sandwitch
Function Detector_de_Sandwitch (var matriz:tmatriz ; fila,columna:integer; var newfila,newcolumna,cantidad:integer;cond,tipo:integer;colorjugador,colorpc:char):Boolean;
var
    salir:integer;
    ficha:char;
Begin
    if (tipo=1) Then
        ficha:= colorjugador;
    if (tipo=2) Then
        ficha:= colorpc;
    salir:=0;
    cantidad:=0;
    REPEAT
        Movimientos(newfila,newcolumna,cond);
        inc(cantidad);
        if(matriz[newfila,newcolumna]= ficha) then
            salir:=1;
        if((matriz[newfila,newcolumna]<>colorpc) AND (matriz[newfila,newcolumna]<>colorjugador) ) then
            salir:=2;
    UNTIL(salir<>0);

    if(salir=1)then
        Detector_de_Sandwitch:=True;
    if(salir=2)then
        Detector_de_Sandwitch:=False;
End;

//Contador para pasar de turno
procedure pasarDeTurno(var pasoturno:integer);
begin
    pasoturno:= pasoturno+1;
end;

//Chequeador de Posicion
Function Chequeador (var matriz:tmatriz;fila,columna,newfila,newcolumna,tipo:integer;colorjugador,colorpc:char): boolean;
Var
    ficha:char;
Begin
    if (tipo=1) Then
        ficha:= colorpc;
    if (tipo=2) Then
        ficha:= colorjugador;
    if (matriz[fila,columna]=#0) then
        Begin
            if (matriz[newfila,newcolumna]= ficha) then
                Chequeador:= true
            Else
                Chequeador:= false;
        End
    Else
        Chequeador:= false;
End;

//Seleccionador de Orientacion
Function Orientacion (var matriz:tmatriz;fila,columna,tipo,bien,pasoturno:integer;var maxcantidad:integer;colorjugador,colorpc:char):Boolean;
Var
    newfila,newcolumna,ok,i,cantidad:integer;
Begin
    ok:=0;
    maxcantidad:=0;
    for i:=1 to 8 do
        Begin
            newfila:=fila;
            newcolumna:=columna;
            Movimientos(newfila,newcolumna,i);
            if(Chequeador(matriz,fila,columna,newfila,newcolumna,tipo,colorjugador,colorpc)) Then
                Begin
                    if(Detector_de_Sandwitch(matriz,fila,columna,newfila,newcolumna,cantidad,i,tipo,colorjugador,colorpc)) Then
                        Begin
                            maxcantidad:= cantidad+maxcantidad;
                            IF ((tipo =1) or ( bien =100) ) Then
                                Begin
                                    Intercambiador(matriz,fila,columna,newfila,newcolumna,i,tipo,colorjugador,colorpc);
                                    inc(ok);
                                End;
                            IF ( tipo =2 ) Then
                                inc(ok);
                        End;

                End
            else

        End;
    if(ok=0) then
        Orientacion:= False
    else
        Orientacion:= True;
End;

//Contador de fichas
Procedure Contador_de_fichas (var matriz:tmatriz;var libres,blancas,negras:integer);
Var
    i,j:integer;
Begin
    libres:=0;
    blancas:=0;
    negras:=0;
    For i:=2 to 9 do
        Begin
            For j:=2 to 9 do
                Begin
                    IF ( matriz[i,j] = #0 ) Then
                        inc(libres);
                    IF ( matriz[i,j] = 'B' ) Then
                        inc(blancas);
                    IF ( matriz[i,j] = 'N' ) Then
                        inc(negras);
                End;
        End;
    clrscr;
    write('Cantidad de Blancas : ',blancas);
    writeln;
    write('Cantidad de Negras : ',negras);
    writeln;
    write('Cantidad de Espacios libres : ',libres);
    writeln;
    writeln;
End;

//Inteligencia artificial
Procedure Posicion_de_la_pc(var matriz:tmatriz ;var fila ,columna,maxcantidad,tipo,pasoturno,turno:integer;var bien:integer;colorjugador,colorpc:char);
Var
    i,j,mayorcantidad,mejorfila,mejorcolumna:integer;
Begin
    mayorcantidad:=0;
    FOR i:=2 to 9 do
        Begin
            FOR j:=2 to 9 do
                Begin
                    fila:=i;
                    columna:=j;
                    IF(Orientacion(matriz ,fila,columna,tipo,bien,pasoturno,maxcantidad,colorjugador,colorpc)) Then
                        Begin
                            IF ( mayorcantidad < maxcantidad ) Then
                                Begin
                                    mayorcantidad:=maxcantidad;
                                    mejorfila:=i;
                                    mejorcolumna:=j;
                                    inc(bien);
                                End;

                        End
                    else
                    //Lo que hace es llamar a este procedimiento que va sumando en una variable hasta 64 que sont odas las posiciones, si de las 64 ninguna entro a orientacion es porque no hay movimeitnos
                        pasardeturno(pasoturno);
                    if(pasoturno = 64) then
                        begin
                            writeln('se pasara de turno automaticamente, no hay jugadas disponibles');
                            readkey;
                        end;
                End;
        End;
    IF ( bien <> 0) Then
        Begin
            maxcantidad:=0;
            bien:=100;//Este valor lo puse por poner para que pueda entrar y cambiar las fichas
            fila:=mejorfila;
            columna:=mejorcolumna;
        End;
End;

//Ingresar datos
Procedure Ingresar_Datos ( var matriz:tmatriz;var salir,turno,libres,blancas,negras,resultado,pasoturno,sinmovidas:integer;colorjugador,colorpc:char);
var
    fila,columna,tipo,maxcantidad,bien:integer;

Begin
    bien:=0;
    maxcantidad:=0;
    writeln('Ingrese 0 para salir');
            //USUARIO
                if(turno=0) then
                    Begin
                        writeln('Tu Turno ');
                        tipo:=2;
                        pasoturno:=0;
                        Posicion_de_la_pc(matriz,fila,columna,maxcantidad,tipo,pasoturno,turno,bien,colorpc,colorjugador);
                        IF (bien<>0) THEN
                            Begin
                                write('Posicion de la Fila : ');
                                readln(fila);
                                                         if(fila = 0) then
                                                         Halt(0);
                                write('Posicion de la Columna : ');
                                readln(columna);
                                inc(columna);
                                inc(fila);
                                tipo:=1;
                                turno:=1;
                                if(Orientacion(matriz,fila,columna,tipo,bien,pasoturno,maxcantidad,colorjugador,colorpc)) then
                                    Begin
                                        writeln('Cantidad de fichas convertidas = ',maxcantidad);
                                        readkey;
                                        matriz[fila,columna]:= colorjugador;
                                        Contador_de_fichas(matriz,libres,blancas,negras);
                                        sinmovidas:=0;
                                    End
                                Else
                                    Begin
                                        clrscr;
                                        writeln ('Error en posicion, ingrese una nueva');
                                        readkey;
                                        turno:=0;
                                    End;

                            End
                        Else
                            Begin
                                inc(sinmovidas);
                                turno:= 1;
                            End;
                        End
            //PC
                Else
                    Begin
                        writeln('Turno de la PC ');
                        tipo:=2;
                        turno:=0;
                        pasoturno:=0;
                        Posicion_de_la_pc(matriz,fila,columna,maxcantidad,tipo,pasoturno,turno,bien,colorjugador,colorpc);
                          if (Orientacion(matriz,fila,columna,tipo,bien,pasoturno,maxcantidad,colorjugador,colorpc)) then
                              Begin
                                  writeln('Cantidad de fichas convertidas = ',maxcantidad);
                                  readkey;
                                  matriz[fila,columna]:=colorpc;
                                  Contador_de_fichas(matriz,libres,blancas,negras);
                                  sinmovidas:=0;
                              End
                          Else
                              Begin
                                  inc(sinmovidas);
                                  turno:= 0;
                              End;
                    End;
                         if(sinmovidas = 2)then
                         resultado:= 1;


End;

//Mostrar Matriz
Procedure Mostrar_Matriz(var matriz:tmatriz);
var
    i,j:integer;
Begin
    clrscr;
    writeln;
    For i:=1 to 10 do
        begin
            For j:=1 to 10 do
                begin
                     write(matriz[i,j],'  ');
                end;
        writeln;
        writeln;
        end;
End;

//Resultados
Procedure Resultado_final(var matriz:tmatriz ;var libres,blancas,negras:integer;var nombre:string;var colorJugador,colorPC:char);
Begin
    clrscr;
    Writeln;
    Writeln;
    Writeln;
    IF (blancas < negras) Then
        Begin
                 if(colorJugador = 'B') then
                      begin
                      Contador_de_fichas(matriz,libres,blancas,negras);
                       writeln('GANO LAS NEGRAS , PERDISTE ',nombre);
                      end;
                   if(colorJugador = 'N') then
                      begin
                           Contador_de_fichas(matriz,libres,blancas,negras);
                           writeln('GANO LAS NEGRAS , GANASTE ',nombre);
                      end;
         End;
    IF (blancas = negras) Then
        Begin
            Contador_de_fichas(matriz,libres,blancas,negras);
            writeln('Empate !   ');
        End;
    IF (blancas > negras) Then
        Begin
                 if(colorJugador = 'B') then
                      begin
                  Contador_de_fichas(matriz,libres,blancas,negras);
                  writeln('GANO LAS BLANCAS , GANASTE ',nombre);
                      end;
                   if(colorJugador = 'N') then
                      begin
                  Contador_de_fichas(matriz,libres,blancas,negras);
                  writeln('GANO LAS BLANCAS, PERDISTE ',nombre);
                      end;
         End;
    readkey;
    fin:= 1;
End;
procedure desarrollo (var matriz:tmatriz;var nombre:string;var colorjugador,colorpc:char;var fin,turno,libres,blancas,negras,resultado,pasoturno,sinmovidas:integer);
begin
    REPEAT
        Mostrar_Matriz(matriz);
        Ingresar_Datos(matriz,fin,turno,libres,blancas,negras,resultado,pasoturno,sinmovidas,colorjugador,colorpc);
        IF (resultado=1)Then
            Resultado_final(matriz,libres,blancas,negras,nombre,colorJugador,colorPC);
    UNTIL (fin=1);
end;

procedure juego(var matriz:tmatriz;var nombre:string;var colorjugador,colorpc,volverAJugar:char;var fin,turno,libres,blancas,negras,resultado,pasoturno,sinmovidas:integer);
    begin
        repeat
          Inicio(nombre,colorjugador,colorpc,fin,turno);
          Llenar_Matriz(matriz);
          resultado:=0;
          pasoturno:= 0;
          sinmovidas:=0;
          desarrollo(matriz, nombre, colorjugador,colorpc, fin,turno,libres,blancas,negras,resultado,pasoturno,sinmovidas);
          clrscr;
          writeln('Juego terminado, desea volver a jugar?  S/N ');
          readln(volverAJugar);
        until(volverAJugar= 'n');
        clrscr;
    end;

procedure creditos();
    begin
        clrscr;
        writeln('Creditos: Giovanni, Camila, Nicolas, Gonzalo');
        writeln('Guarnallen');
        readkey;
    end;

procedure colorinterfaz();
    begin
    textcolor(white);
    textbackground(white);
    end;

//Programa Principal
BEGIN
    colorinterfaz;
    juego(matriz, nombre, colorjugador,colorpc,volverAJugar, fin,turno,libres,blancas,negras,resultado,pasoturno,sinmovidas);
    creditos;
END.
