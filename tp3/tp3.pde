Jugador j;
Escenario e;
Pelota p;

PImage fondo;

int vidas, nivel;
boolean start; //Nos ayudará a iniciar el movimiento de la pelota
String estado;

void setup() {
  size(500, 700);

  fondo = loadImage("background.png"); //Se carga la imagen del fondo (la imagen debe de estar en el mismo lugar que este archivo)

  vidas = 3; //Se le asigna al jugador un maximo de 3 vidas
  nivel = 1; //Se inicia el juego en el nivel 1
  start = false;

  j = new Jugador();
  e = new Escenario(nivel);
  p = new Pelota(j.getPosicion());

  e.crearEscenario();

  textSize( 24 );
  textAlign( CENTER, CENTER );

  estado = "Instrucciones";
}


void draw() {
  if (estado.equals("Instrucciones")) {
    background( 0, 0, 0 );
    text( estado, width/2, height/8 );
    text( "Bienvenido a mi juego :D\nusa las flechas IZQUIERDA y DERECHA\npara moverte\n\ndestruye todos los bloques\nhaz un records de puntos\n y diviertete\n\ncuidado!!\ncada nivel aumenta más la dificultad D:\n\nPulsa ESPACIO para jugar", width/2, height/2 );
  } else if (estado.equals("Juego")) {
    //Si el juegador aun no ha perdido la pelota y el aun hay bloques que eliminar, el juego sigue
    if (!p.validarMuerte() && e.getNumBlocks() != 0) {
      background(fondo); //Se coloca el fondo

      e.mostrar(); //Se muestran los bloques


      //Si se presiona una tecla, start cambia a verdadero
      if (keyPressed) {
        start = true;
      }

      j.mover();
      j.mostrar();

      p.mostrar();

      //Si se start es verdadero, la pelota comenzará a moverse
      if (start) {
        p.mover();
        p.validarBordes();
        p.rebotar(j.getPosicion(), j.getAncho(), j.getAlto());
        p.eliminarBlock(e.getBlocks(), e.getColores(), e.getAncho(), e.getAlto());
      }

      fill(255);   
      textAlign(CENTER);
      textSize(30);

      //Se muestra en pantalla el puntaje del jugador y sus vidas
      text("Score: " + p.getPuntos() + "   Life: " + vidas, width/2, 35);
    } 
    //Si ya no hay bloques por eliminar, se inicia el siguiente nivel
    else if (e.getNumBlocks() == 0) {
      background(0);
      fill(255);

      textAlign(CENTER);

      //Se muestra al usuario el nivel que acaba de completar
      text("NIVEL " + nivel, width/2, height/2);
      text("COMPLETED", width/2, height/2 + 50);

      //Si el usuario presiona una tecla, inicia el siguiente nivel
      if (keyPressed) {
        nivel++; //Aumenta el nivel
        reset(); //Se incia el juego con el nivel correspodiente
      }
    } 
    //Si el jugador ya no tiene vidas, el juego termina
    else if (vidas == 0) { 
      background(0);
      fill(255);
      textAlign(CENTER);

      //Se muestra al usuario el puntaje que alcanzó a lo largo del juego
      text("GAME OVER", width/2, height/2);

      text("Score " + p.getPuntos(), width/2, height/2 + 50);

      text("Press ENTER", width/2, height - 200);

      //Si el usuario presiona la tecla ENTER, el juego inicia desde 0
      if (keyCode == ENTER) {
        setup();
      }
    }
    /*Si ninguna de las condiciones anteriores se cumplen, 
     quiere decir que el jugador solo perdió su pelota, asi que
     se le da una pelota nueva en su posicion actual*/
    else {
      p.setPosicion(j.getPosicion()); //Se posiciona la pelota en su base
      start = false;
      vidas--; //Cuando se pierde la pelota, se pierde una vida :(
    }
  }
}
void keyPressed() {
  //evento que cambia de instrucciones a juego
  if ( estado.equals("Instrucciones") && key == ' ' ) {
    estado = "Juego";
  }
}

//Metodo para crear el siguiente nivel
void reset() {
  e = new Escenario(nivel);
  e.crearEscenario();
  j = new Jugador();
  p.setPosicion(j.getPosicion());
}
