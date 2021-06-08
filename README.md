# Jarvan

Jarvan es un lenguaje imperativo, fuertemente tipado, con alcance estático y "Coloquial", ofrece una manera fácil y divertida de programar.

# Estructura de un programa

Un programa en Jarvan tiene la siguiente estructura:
```
{
    <instrucción>
}
```
Es decir, cualquier instrucción debe estar dentro de un bloque delimitado por los tokens { y }.
Un programa en Jarvan podría verse así:

```
{
    Beticas 
    bs x,y;
    [bs] z;
    z = [x,y]
    if (x > y) {
       metele(z, x) 
    }
    
    imprimir(z)
    
}
```

# Identificadores

En Jarvan, un identificador se utiliza para nombrar variables y funciones, pueden ser de cualquier longitud, deben empezar por una letra, un guión bajo (\_) o un signo de ($),  y no está permitido el uso de guiones (-). Además, los identificadores son sensibles a mayúsculas, por ejemplo, la variable `firstName` es diferente a la variable `firstname`.

# Instrucciones

## Declaración de variables

Para la declaración de variables en Jarvan, se usa la palabra reservada `Beticas`. Esto abrirá un nuevo bloque de instrucciones para la declaración de variables que culmina con la útlima declaración sin el operador de secuenciación `;`.
```
{
    Beticas
    bs n = 1;
    letra m = 'm';
    bsf d = 0.1
}
```

## Secuenciación
```
{
    <instrucción1>;
    <instrucción2>
}
```
Una secuenciación de instrucciones es una instrucción que permite ejecutar varias instrucciones consecutivamente, el operador de la secuenciación es el `;`,  el cual es un operador binario, por lo tanto la última instrucción en un bloque no lleva `;`.

## Asignación
```
<variable> = <expresion>
```    
La instrucción de asignación evalúa la expresión del lado derecho y la almacena en la variable del lado izquierdo, el tipo del resultado de evaluar la expresión debe coincidir con el tipo de la variable.

## Bloque

Un bloque permite secuenciar un conjunto de instrucciones y declarar variables locales. Su sintaxis es la siguiente.
    
```
{
    <variables>
    <instruccion1>;
    <instruccion2>;
    ...
    <instuccionN>    
}
```

> Nota: la declaración de variables es opcional en un bloque.

## Entrada
```
leer(<variable>)
```

Permite obtener entrada escrita por parte del usuario, donde `<variable>`, es la variable donde se va almacenar el valor introducido.

## Salida
```
imprimir(<expresion>)
```    
Permite imprimir en consola el resultado de evaluar una expresión.


# Reglas de alcance.

Para utilizar una variable primero debe ser declarada al comienzo de un bloque o como parte de la variable
de iteración de una instrucción `vacila`. Es posible anidar bloques e instrucciones `vacila` y también es posible
declarar variables con el mismo nombre que otra variable en un bloque o `vacila` exterior. En este caso se
dice que la variable interior esconde a la variable exterior y cualquier instrucción del bloque será incapaz
de acceder a la variable exterior.

# Operadores

## Relacionales

`==` : igualdad.  
`!=`: desigualdad.  

## Aritmeticos

`+`: adición o concatenacion de strings.  
`-`: substrancción.  
`*`: producto.  
`^`: potencia.  
`/`: división.  
`//`: división entera.  
`%`: resto de la división entera.  
`+=`, `-=`, `*=`, `^=`, `/=`, `//=`, `%=`: aplicar y asignar. Ejemplo: i += 1 es lo mismo que i = i+1.  
`>`: mayor que.  
`<`: menor que.  
`>=`: mayor o igual.  
`<=`: menor o igual.  

## Logicos

`&&`: and  
`||`: or  
`!`: negación  

# Conversiones de tipo.

`devalua(<bs>)`: Esta función convierte una variable de tipo `bs` en una de tipo `bsf`.  
`efectivo(<bsf>)`: Esta función convierte una variable de tipo `bsf` en una de tipo `bs`, o una variable de tipo `letra` o `Labia` en una de tipo `bs`, siempre y cuando tengan caracteres únicamente numéricos.   

# Comentarios.

Los comentarios pueden ser de una línea o más de una línea. En caso de una línea se debe usar el token `#`. Para comentarios que contengan más de una línea se hace uso del token `/#` al principio y `#/` para el final.

```
    { Beticas
        bs n = 1;
        # Este es un comentario
        letra a = 'a'
    }
```

Tipos
=======================

Jarvan cuenta con tipos escalares y tipos compuestos. Toda variable puede ser declarada siempre que no haya sido declarada anteriormente dentro del mismo alcance. Todo tipo esacalar debe ser declarado en letra minúscula, mientras que los tipos compuestos deben ser declarados con inicial mayúscula. Esto se logra de esta forma <tipo> <NombreVariable>.

Escalares
-------------
- `qlq`: Puede optar por dos valores: `coba` o `elda`, representando el 0 y el 1, respectivamente. `qlq` tiene por default el valor `coba`.
- `bs`: Número entero de 4 bytes (32 bits), complemento a 2.
- `bsf`: Número punto flotante con precisión sencilla, según norma estándar IEEE 754.
- `letra`: Caracter ASCII. El valor debe de declararse dentro de comillas simples `''`.
- `nulo`: Tipo de valor único `nada`.
-------------
```
    {
    Beticas
    qlq a = elda;
    letra l = 'A';
    bs e = 1;
    bsf f = 1.2
    }
```

Compuestos:
-------------
- `Labia`: Cadena de caracteres.
-  `Metro<tipo[<tamaño>]>`: Arreglo de tamaño constante.
-  `Metrobus<tipo[tamaño]>`: Listas, arreglos de tamaño dinámico.
- `Bus`: Registro. Tipo de estructura que puede contener elementos de diferentes tipos.
- `Bululu`: Registros variantes.
- Apuntadores `@`: Apuntador a memoria del heap.
-------------
```
    {
        Beticas
        Labia m = "Hola chamita";
        [qlq] a = [coba, elda, elda];
        bs @z;
        Bus chacaito {
            bsf pasaje = 10.2 ;
            labia canto = "Pasaje al entrar";
        }
    }
```

Metro
-------------
Los `Metro` pueden definirse posicionando cada elemento o solo pasando un número entero que define el tamaño del `Metro`. En caso de no definir cada posición del `Metro`, se llenará con valores de tipo `nulo`. Se pueden usar ciertas funciones sobre el tipo `Metro`, estas son:

- `tam(<Metro>)`: Retorna la longitud de un arreglo.  
- `sitio(<Metro>, <expresión>)`: Retorna el índice de la primera ocurrencia en el arreglo del valor resultante de evaluar la expresión.
- `voltea(<Metro>)`: Invierte el orden del arreglo. 
-------------
    ```
    { Beticas
    Metro<bs[5]> a = [1,2,3,4,5];
    Metro<letra[5]> b
    tam(a);
    sitio(2,a)
    }
    ```

Metrobus
-------------
Los `Metrobus` pueden definirse por extensión o solo pasando un número entero que define el tamaño del `Metrobus`. Es análogo al `Metro`, con la diferencia de que su tamaño puede variar gracias a las funciones de `mete()` y `saca()`. Se pueden usar estas funciones sobre los tipo `Metrobus`:

- `tam(<Metrobus>)`: Retorna la longitud de un arreglo.  
- `sitio(<Metrobus>, <expresión>)`: Retorna el índice de la primera ocurrencia en el arreglo del valor resultante de evaluar la expresión.
- `mete(<Metrobus>, <expresión>)`: Agrega un elemento al arreglo.  
- `saca(<Metrobus>)`: Saca el último elemento del arreglo.  
- `voltea(<Metrobus>)`: Invierte el orden del arreglo. 
-------------
    ```
    { Beticas
    Metrobus<bs[5]> a = [1,2,3,4,5];
    Metrobus<letra[5]> b
    }
    ```

Mecanismos de selección
=======================

`porsia/sino/nimodo`
--------------

    porsia (condición) {
        <instrucciones>
        .
        .
        .
    }
    sino (condición) {
        <instrucciones>
        .
        .
        .
    }
    .
    .
    .
    nimodo {
        <instrucciones>
        .
        .
        .
    }

El lenguaje usará la palabra reservada `porsia` como mecanismo de selección. Después de esta palabra reservada seguirá un espacio y luego entre paréntesis la `condición` que puede ser una expresión o variable booleana. Abrimos un bloque y se ejecutarán la `instrucciones` en caso de cumplirse la `condición`.  
En caso de querer evaluar más condiciones podemos hacer uso de la palabra reservada `sino` seguida de la misma estructura del `porsia` y de igual forma ejecutará su bloque de `instrucciones` en caso de cumplirse la `condición`. `sino` solo será parte de nuestro lenguaje en caso de estar precedido por un bloque `porsia`.  
Finalmente en el caso de no cumplirse alguna de las `condición` de los porsia y sino previos usamos la palabra reservada `nimodo` para ejecutar una instrucciones. `nimodo` solo será parte de nuestro lenguaje en caso de estar precedido por uno o más bloques `porsia` o `sino`.  

`switch/case`
-------------

    tantea (variable) {
        caso (expresión) {
            <instrucciones>
            .
            .
            .
        }
        caso (expresión) {
            <instrucciones>
            .
            .
            .
        }
        .
        .
        .
    }

El leguaje usará la palabra reservada `tantea` en caso de querer ejecutar instrucciones de acuerdo al valor de una variable. seguido de `tantea` tendremos entre parentésis una `variable` que tendrá que estar previamente declarada.  
Seguido de esto tendremos un bloque conformado por un conjunto de bloques con la siguiente estructura: la palabra reservada `caso` seguida por una `expresión` entre parentesís y luego un bloque con una o mas `instrucciones`.  
De forma tal que se ejecutará la `instrucciones` del bloque en caso de que la `variable` tenga el valor de `expresión`.  

Mecánismos de repetición
========================

`vacila` (Repetición determinada)
------------------------------

    vacila (variable; condición; paso) {
        <instrucciones>
        .
        .
        .
    }

Usaremos la palabra reservada `vacila` para realizar repeticiones determinadas.  
Luego del `vacila` entre paréntesis colocamos la siguiente estructura:  

- Iniciamos una `variable`. Está tendrá un alcance local dentro de este bloque.  
- Definimos una `condición` que puede ser una expersión o variable booleana.  
- Definimos el `paso` de la `variable` el cual puede ser en notación estándar o susfija. 

El lenguaje ejecutará las `instrucciones` y se detendrá en caso de cumplirse la `condición`.   

    vacila (variable in iterador) {
        <instrucciones>
        .
        .
        .
    }

El usuario tambien podrá usar la palabra reservada `vacila` para definir una repetición sobre un iterable.  
Luego del `vacila` entre paréntesis colocamos la siguiente estructura:  

- Declaramos `variable`. Está tendrá un alcance local dentro de este bloque.  
- Palabra reservada `in`.  
- Objeto o variable del tipo `iterable`.  

En este caso la repetición se ejecutará por cada uno de los iterandos de `iterador`.  

Adicional a esto, el usuario podrá usar las palabras reservadas `achanta` en caso de querer detener la repetición, o `siguela` para saltar al siguiente paso en la repetición.  

`pegao` (Repetición indeterminada)
----------------------------------
            
    pegao (<condición>) {
        <instrucciones>
        .
        .
        .
    }

Usaremos la palabra reservada `pegao` para realizar repeticiones indeterminadas.  
Seguida de la palabra reservada `pegao` tendremos entre paréntesis una `condición` que puede ser una expresión o variable booleana y luego la apertura de un bloque de `instrucciones`.  
La reoetición se ejecutará y se detendrá en caso de cumplirse la `condición`.  
Adicional a esto, el usuario podrá usar las palabras reservadas `achanta` en caso de querer detener la repetición, o `siguela` para saltar al siguiente paso en la repetición.

Subrutinas.
=======================
En jarvan las funciones solo pueden retornar escalares, además las funciones pueden ser pasadas como argumentos a otras funciones. Al momento de definir los argumentos que recibirá una función se debe declarar el tipo de cada argumento, para pasar una variable por referencia se debe pasar como argumento el apuntador a dicha variable. Una función puede no tener un valor de retorno explícito en ese caso el valor de retorno por defecto será “coba”. La sintaxis de las funciones es la siguiente:

### Declaracion de funciones.
 
La declaración de una función consiste en la palabra reservada `Chamba`. seguido  de:
            
- Nombre de la función.
- Tipo de valor a retornar. En caso de referirnos a un procedimiento (función sin valor de retorno) se puede ignorar esta parte.
- Lista de parámetros, encerrados entre paréntesis y separados por coma.
- El cuerpo de la función encerrado entre llaves `{...}`

Por ejemplo el siguiente código define una función llamada `mychamba` y un procedimeinto llamado `saimeLannister`:
            
 ```
 Chamba bs mychamba(bs a){
            rescata a * a
 }

 Chamba nulo saimeLannister(letra a) {
     a = a + 'chambeando'
 }
 ```
La palabra reservada `rescata` especifica el valor retornado por la función. Para llamar a esta función la sintaxis es la siguiente: `mychamba(5)`

### Invocar una función.

Para invocar a la función anterior la sintaxis es la siguiente: `mychamba(5)`. Una función debe estar en el alcance cuando es llamada, pero puede estar declarada luego de la llamada, por ejemplo:

 ```
 mychamba(5)
            
 Chamba mychamba(bs a){
            rescata a * a
 }
 ```
            
 
### Pasaje de parámetros por referencia.
  
Para pasar una variable como parametro a una función por referencia, basta pasar el apuntador a dicha variable. Los Arreglos y Registros solo son pasados por referencia.

 ```
 Chamba mychamba(bs @a){
            rescata a * a
 }
 ```
            
 ### Recursión.
 
 Una función puede invocarse a sí misma, la sintaxis para una recursión es la siguiente:
 
 ```
 Chamba factorial(bs n){
            if(n == 0){
                rescata 1
            }
            rescata n * factorial(n-1)
 }
 ```
