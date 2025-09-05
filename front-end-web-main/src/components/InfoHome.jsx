import React from "react";
import '../styles/InfoHome.css';

function InfoHome() {
  /* Modos de juego */
  const BulletInfo = "Bullet";
  const BlitzInfo = "Blitz";
  const RapidInfo = "Rapid";
  /* Información acerca de cada modo de juego */
  const BulletText = "Esta variante del juego se caracteriza por partidas realmente extremadamente rápidas, \
	en las que cada jugador cuenta con 3 minuto de tiempo para realizar sus movimientos."
  const BlitzText = "En el ajedrez Blitz, cada jugador tiene un tiempo máximo de 5 minutos.\
   Esto hace que cada movimiento deba ser rápido y preciso, ya que no hay mucho \
  margen para pensar demasiado.";
  const RapidText = "En este modo de juego los jugadores cuentan con 10 minutos.A diferencia de las partidas clásicas,\
  donde se cuenta con varias horas para pensar y planificar cada jugada, en el ajedrez rápido el reloj es un factor determinante.";
  
  /* Información acerca del juego */
  const Partidas = " Juega partidas en modo local contra la máquina o en modo online contra otros usuarios.\
   Existen tres modos de juego, Blitz, Bullet y Rapid. Estos se diferencian en el límite de tiempo para jugar.\
   Al jugar partidas se te otrorgarán tanto puntos de recompensa como puntos de ELO.";
  const ELO = " Los puntos de ELO se utilizan para categorizar a los jugadores.\
   ¡Gana partidas para conseguir gran cantidad de puntos de ELO y jugar contra los mejores jugadores!\
   Al incrementar tu puntuación de ELO, jugarás en distintos ambientes de tableros llamados Arenas.\
   En el apartado de \"Ranking\" puedes consultar los mejores jugadores en cada modo de juego.";
  const Recompensas = " Los puntos de recompensa se ganan independientemente de si ganas o pierdes partidas.\
   Con estos puntos puedes acceder al apartado de \"Pase de batalla\" para reclamar recompensas asombrosas.\
   Para poder utilizar las recompensas desbloqueadas en partida, accede al apartado de \"Personalizacion\".";

  /* Cuadro informativo acerca de los diferentes modos de juego */
  return (
    <div className="infoHome-background">
      <div>
        <div className="infoHome-title">
          COMO JUGAR
        </div>
        <div className="infoHome-boxContainer">
          <div className="infoHome-box">
              <div className="infoHome-boxTitle">Puntos de Elo</div>
              <div className="infoHome-boxText">{ELO}</div>
          </div>
          <div className="infoHome-box">
            <div className="infoHome-boxTitle">Partidas</div>
            <div className="infoHome-boxText">{Partidas}</div>
          </div>
          <div className="infoHome-box">
            <div className="infoHome-boxTitle">Puntos de Recompensa</div>
            <div className="infoHome-boxText">{Recompensas}</div>
          </div>
        </div>
      </div>
      {/* <hr style={{width: '90%'}}/> */}
      <div>
        <div className="infoHome-title">
          MODOS DE JUEGO
        </div>
        <div className="infoHome-boxContainer">
          <div className="infoHome-box">
              <div className="infoHome-boxTitle">{BulletInfo}</div>
              <div className="infoHome-boxText">{BulletText}</div>
          </div>
          <div className="infoHome-box">
            <div className="infoHome-boxTitle">{BlitzInfo}</div>
            <div className="infoHome-boxText">{BlitzText}</div>
          </div>
          <div className="infoHome-box">
            <div className="infoHome-boxTitle">{RapidInfo}</div>
            <div className="infoHome-boxText">{RapidText}</div>
          </div>
        </div>
      </div> 
    </div>
  );
}

export default InfoHome; 