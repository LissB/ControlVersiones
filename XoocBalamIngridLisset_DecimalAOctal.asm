;Carrera:   Ing. En Sistemas Computacionales
;Grado:     6
;Grupo:     "A"
;Materia:   Lenguaje de interfaz
;Profesor:  LCC. Juan Bernardo Alfonso Tzuc Dzib
;Nombre:    Xooc Balam Ingrid Lisset
;Matricula: 17070047
;Fecha:     17/Marzo/2020

.model small    ;Se define el modelo de tipo small
.stack 100      ;Se determina el tama�o de la pila, en este caso es de 100
.data           ;En este apartado se declaran todas las variables que se utilizar�n en el programa.

    dece    db 0 ;Variable que guarda las decenas del n�mero que se ingresa
    uni     db 0 ;Variable que guarda las unidades del n�mero que se ingresa
    i       db 1 ;variable que funciona como contador. Cuenta cu�ntas veces ya se ha repetido 
                 ;la etiqueta imprimir, 
    
    dato    db 0 ;variable que almacena el n�mero que se ingresa desde teclado.
                 ;De igual manera, esta variable se utiliza para guardar el rresultado de la divisi�n
                 ;de la variable dato entre la variable octal.
                
    octal   db 8 ;La variable octal almacena el valor de 8, porque dentro del programa es 
                 ;la variable que representa al divisor del m�todo para convertir de decimal a octal.
    
    mensaje       db 10,13,"El n�mero ingresado en Octal es: ","$" ;Esta variable es la que almacena
                                                               ;el mensaje que se muestra casi al
                                                               ;final del programa. 
                                                                 
    msg           db 10,13,'Ingresa un n�mero: $'              ;Esta variable es la que almacena
                                                               ;el mensaje que se muestra para ingresar
                                                               ;el n�mero con el que se va ha 
                                                               ;trabajar.  
                                                               
    resultArreglo db 20 dup(0), "$" ;Esta variable sirve como un arreglo de datos, ya que, al asignarle 20 dup(0), significa que se define en memoria la repetici�n de 20 veces el valor 0. 
                                    ;Esta variable almacena todos los residuos de las divisiones 
                                    ;que se vayan generando en el programa
                                   
    
    
.code  
    mov ax,@data ;Para poder utilizar las variables que se han declarado, se le asignan al registro ax
    mov ds, ax   ;Se le asigna al segmento de datos (ds) todo lo que se cargo anteriormente en ax.
    mov di, 00h  ;Se inicializa en 0 el registro �ndice destino
    mov si, 00h  ;Se inicializa en 0 el registro �ndice fuente
    
    mov ah, 09h  ;Se mueve la interrupci�n 09h a ah, para que se realice una petici�n para mostrar el mensaje
    lea dx, msg  ;Lea carga el mensaje en el segmento de datos y
    int 21h      ;la interrupci�n 21h muestra el mensaje desde la consola (pantalla)       
    
    mov ah,01h   ;01h se encarga de realizar una petici�n junto con la
    int 21h      ;interrupci�n 21h.Cuando se ingresa el caracter autom�ticamente se guarda en al.  
    sub al,30h   ;Como el caracter se guarda en al, entonces a al se le resta 30h para conocer en
                 ;el valor de ese dato en el c�digo ascii
    mov dece,al  ;cuando se termina de realizar la resta, se asigna a la variable dece
                 ;que es el encargado de alamacenar las decenas del n�mero con el que se trabajar�.
    
    mov ah, 01h  ;Se realiza de nuevo una petici�n, pero esta vez para obtener las unidades del n�mero
    int 21h      ;se muestra la consola para ingresar el caracter. Este caracter se guarda el al.
    sub al,30h   ;Se le resta 30h a al para conocer cu�l es el n�mero ingresado, posteriormente
    mov uni,al   ;este resultado se le es asignado a la variable uni.
    
    
    ;Procedimiento para guardar el n�mero ingresado a la variable numero
    ;Como el n�mero ingresado esta separado en decenas y unidades entonces se realiza lo siguiente.
    mov al,dece ;Se mueve al acumulador al el valor de la variable dece.
    mov bl,10   ;Se asigna el valor de 10 en el registro base, ya que una decena equiva a 10
    mul bl      ;Se multiplica al por bl para tener el resultado. El resultado se guarda en al
    add al,uni  ;Como ya se tiene las decenas ahora solo se le suma las unidades al registro al.
    mov dato,al ;Ahora solo se guarda en la variable dato el n�mero entero.
           
    ciclo:  ;En esta etiqueta se realizar�n las divisiones y se ir�n guardando los datos en un arreglo.        
        ;Primero se realiza la divisi�n 
        xor ax,ax     ;Se encarga de limpiar los registros
        mov bl,octal  ;La variable octal contiene el valor del divisor y se meuve a bl.
        mov al,dato   ;La variable dato tiene el dividendo y lo mueve en al.
              
                      ;La f�rmula para la divisi�n es al=al/bl. Es por eso que, se guardaron los valores
                      ;anteriores en los regiatros correspondientes.
                      ;El cociente de la divisi�n se guada en al (al=al/bl)
                      ;El residuo de la divisi�n se guada en ah (ah=res). 
        div bl        ;Se realiza la divisi�n.
        mov dato,al   ;Ahora, se copia el cociente de la divisi�n en la variable dato, y
                
        cmp dato,0    ;Compara el valor de la variable dato con 0
        je salir      ;Si es igual a cero, entonces salta a la etiqueta salir
                      ;Si es diferente a cero realiza todo lo dem�s.
        
        mov resultArreglo[si],ah  ;mueve en el arreglo resultArreglo[si], lo que est� en ah.
                                  ;donde si, es el indice fuente y tiene un valor inicial de 0. y
                                  ;donde ah, contiene el residuo de la divisi�n realizada anteriormente.
        inc si                    ;Incrementa en un valor si
    jmp ciclo                     ;jmp hace que se repita de nuevo la etiqueta ciclo
       
    salir:  ;La etiqueta salir realiza el �ltimo registro en el arreglo resultArreglo[si]
        mov resultArreglo[si],ah  ;mueve en el arreglo resultArreglo[si], lo que est� en ah.
                                  ;donde si, es el indice fuente y tiene un valor inicial de 0. y
                                  ;donde ah, contiene el residuo de la divisi�n realizada anteriormente.
        inc si                    ;Incrementa en un valor si
        
    call mostrar                  ;Para mostrar el resultado de la conversi�n de decimal a octal
                                  ;se llama a la etiqueta mostrar.
    mostrar: 
        mov ah, 09h               ;Se mueve la interrupci�n 09h a ah, para que se realice una petici�n para mostrar el mensaje
        lea dx, mensaje           ;Lea carga el mensaje en el segmento de datos y
        int 21h                   ;la interrupci�n 21h muestra el mensaje desde la consola (pantalla) 
        mov di,si                 ;Se utiliza el indice destino asign�ndole el valor del indice fuente.
        call imprimir             ;Se llama a la etiqueta imprimir.

    imprimir:      ;Esta etiqueta se encarga de mostrar los datos del arreglo resultArreglo[di], pero de manera invertida 
        mov bh,0   ;Se asigna el valor de 0 a bh para que en el siguiente procedimeinto no afecte los resultados.
        mov bl,i   ;El contador i, inicializado en 1 se mueve al registro bl.
                   
                   ;Para poder comparar si ya se ha impreso todos los registros del arreglo, se 
        cmp bx,si  ;compara bx(almacena el contador i) con si (tiene la cantidad de los registros realizados en el arreglo).
        jnbe fin   ;Si bx es mayor que si, entonces va a la etiqueta fin.
        
                   ;Si es menor que si, realiza todo lo siguiente.  
        mov ax,di  ;Se asigna a ax la cantidad de registros del arreglo almacena en di. 
        sub al,1   ;Se le resta uno al registro al para obtener la �ltima posici�n del arreglo  
        mov di,ax  ;y ese resultado se mueve al �ndice destino
  
        mov al,resultArreglo[di] ;Se mueve a al lo que este en el arreglo en una determinada posici�n. Para comenzar a imprimir los resultados de la �ltima posici�n a la primera,
                                ;se le asigna la posici�n [di] al arreglo resultArreglo.
        mov bx,ax               ;Se mueve el dato obtenido de ax a bx. 
        mov ah,02h              ;02h indica la operacion que coloca al cursor
        mov dl,bl               ;Se mueve en dl lo que est� guardado en bl y
        add dl,30h              ;se le suma 30h para tener el dato original
        int 21h                 ;Por �ltimo se realiza la interrupci�n 21h, encargado de mostrar el resultado en la pantalla
        inc i                   ;incrementa en contador i
    jmp imprimir                ;jmp indica que se realiza un salto a la etiqueta imprimir
    
    fin:      ;Esta etiqueta indica que se ha terminado el proceso.
        .exit ;sirve para salir
ret          ;Retorno del programa
end          ;Fin del archivo fuente.