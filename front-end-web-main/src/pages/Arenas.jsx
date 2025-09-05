import React from "react";
import { useState, useEffect, useRef } from "react";
import '../styles/Arenas.css'
import SideBar from "../components/SideBar";
import MenuIcon from '@mui/icons-material/Menu';
import Madera from '../images/boards/madera.png';
import Marmol from '../images/boards/marmol.png';
import Oro from '../images/boards/oro.png';
import Diamante from '../images/boards/diamante.png';
import Esmeralda from '../images/boards/esmeralda.png';
import ArrowBackIosNewIcon from '@mui/icons-material/ArrowBackIosNew';
import { Tooltip } from "@mui/material";
const apiUrl = process.env.REACT_APP_API_URL;

function Arenas({ userInfo, updateUserInfo }) {
  const [showSidebar, setShowSidebar] = useState(false); /* Mostrar o esconder el sideBar */
  const [hoveredArena, setHoveredArena] = useState(null);  /* Arena sobre la que se pasa el ratón */
  /* Hook para mostrar informacion de la arena sobre la que se clica */
  const [arenaPopUp, setArenaPopUp] = useState({
    showArena: '',
    showArenaStr: '',
    showArenaElo: '',
    showPopUp: false,
  });
  // Hook para guardar la informacion del modo de juego que se esta mostrando en pantalla
  const [mostrandoPantalla, setMostrandoPantalla] = useState({ modo : 'Rapid', elo : '', arena : 'MADERA' }); // valores por defecto

  const [error, setError] = useState(null);
  // Pedir al backend la info del usuario
  useEffect(() => {

    const fetchUserData = async () => {
      if(userInfo.loggedIn==='true'){
            try {
             const response = await fetch(`${apiUrl}/users/${userInfo.userId}`); // Construct URL using userId
             if (!response.ok) {
               throw new Error('Network response was not ok');
             }
             const userData = await response.json();
             // Guardar info del usuario que pueda ser util posteriormente
             setMostrandoPantalla(prevState => ({ ...prevState, elo : userData.elorapid }));
             updateUserInfo({ field : "eloRapid", value : userData.elorapid });
             updateUserInfo({ field : "eloBlitz", value : userData.eloblitz });
             updateUserInfo({ field : "eloBullet", value : userData.elobullet });
           } catch (error) {
             setError(error.message);
           }
      }
    }

    fetchUserData();
  }, []);

  /* Arenas del juego y su contenido */
  const arenas = [
    {
      img: Madera, str: 'MADERA', elo: '1200 - 1499',
      des: 'Este tablero de ajedrez se encuentra tallado en la madera más antigua\
      y noble que jamás hayas visto. Cada cuadro está meticulosamente pulido, revelando\
      la rica tonalidad de la madera que parece respirar vida propia. Este tablero de \
      ajedrez de madera no es solo un juego, es un artefacto encantado que despierta la \
      imaginación y desafía la mente. Es un testigo silencioso de innumerables batallas y \
      estrategias, y un recordatorio de que, en el juego del ajedrez, como en la vida misma, \
      cada movimiento cuenta.'},
    {
      img: Marmol, str: 'MARMOL', elo: '1500 - 1799',
      des: 'Tallado con precisión divina por manos expertas de un antiguo artesano,\
      este tablero de mármol es una obra maestra que desafía la imaginación.Cuando \
      un jugador se sienta frente a este tablero de maravillas, siente una conexión\
      con lo divino, como si estuviera tocando un fragmento del mismísimo cosmos. \
      Cada movimiento en este tablero es una danza cósmica, un ballet de estrategia y destino.\
      Quienes se aventuran a jugar en este tablero de mármol no solo participan en un juego,\
      sino que se sumergen en una experiencia trascendental, donde los límites entre la realidad\
      y la fantasía se desdibujan y el alma misma se eleva hacia las estrellas.'},
    {
      img: Oro, str: 'ORO', elo: '1800 - 2099',
      des: 'Este tablero de ajedrez de oro no solo es una obra maestra de artesanía, sino\
      también un símbolo de poder y prestigio. Cada vez que se mueve una pieza en este \
      tablero dorado, resuena un eco melodioso que llena el aire con una sensación de grandeza\
      y solemnidad. Los jugadores que se aventuran a desafiarlo saben que estan entrando en \
      un reino de majestuosidad y desafío, donde cada movimiento es una danza entre la gloria y la derrota.'},
    {
      img: Esmeralda, str: 'ESMERALDA', elo: '2100 - 2399',
      des: 'Quienes se aventuran a jugar en este tablero de esmeralda no solo se enfrentan\
      a un desafío de habilidad, sino que también se sumergen en un viaje de descubrimiento\
      personal y crecimiento espiritual.Cada partida en este tablero es una experiencia única,\
      es una danza de luz y sombra, donde los jugadores se sumergen en un mundo de estrategia\
      y astucia, donde los movimientos resonan como susurros antiguos entre las montañas, y el destino\
      mismo parece tejerse en cada jugada.'},
    {
      img: Diamante, str: 'DIAMANTE', elo: '2400 - 3000',
      des: 'Tallado con habilidad divina este tablero de diamante es una obra maestra de la belleza\
      y la magia. Cuando los jugadores tocan las piezas, sienten una energía mágica que fluye a través\
      de ellas, una conexión con la esencia misma del juego. Los espectadores que tienen el privilegio\
      de presenciar una partida en este tablero quedan maravillados por su belleza deslumbrante y su\
      aura de misterio. El tablero de ajedrez de diamante permanece como un símbolo de poder y elegancia,\
      una joya en la corona de la creación misma, esperando a que aquellos lo suficientemente valientes\
      para desafiarlo se atrevan a jugar el juego de los dioses.'},
  ];

  /* Descripción de la arena a mostrar */
  const [descripcion, setDescripcion] = useState('');
  useEffect(() => {
    const selectedArena = arenas.find(arena => arena.img === arenaPopUp.showArena);
    if (selectedArena) {
      setDescripcion(selectedArena.des);
    } else {
      setDescripcion('');
    }
  }, [arenaPopUp.showArena]);


  useEffect(() => {

    const actualizarMostrandoPantalla = () => {
      var nuevaArena = '';
      if (mostrandoPantalla.elo < 1500) {
        nuevaArena = 'MADERA';
      } 
      else if (mostrandoPantalla.elo >= 1500 && mostrandoPantalla.elo < 1800) {
        nuevaArena = 'MARMOL';
      }
      else if (mostrandoPantalla.elo >= 1800 && mostrandoPantalla.elo < 2100) {
        nuevaArena = 'ORO';
      }
      else if (mostrandoPantalla.elo >= 2100 && mostrandoPantalla.elo < 2400) {
        nuevaArena = 'ESMERALDA';
      }
      else if (mostrandoPantalla.elo > 2400) {
        nuevaArena = 'DIAMANTE';
      }

      setMostrandoPantalla(prevState => ({
        ...prevState,
        arena : nuevaArena,
      }));

    }
    actualizarMostrandoPantalla();
  }, [mostrandoPantalla.modo, mostrandoPantalla.elo])

  /* Arenas de juego */
  return (
    <div className="background-arenas">
      <div className={showSidebar ? "sideArenas open" : "sideArenas"}>
        {/* sideBar */}
        <SideBar setShowSidebar={setShowSidebar} />
      </div>
      <div className="titleArenas">
        {/* Botón para desplegar el sidebar */}
        <button className={!showSidebar ? "sideMenuButton" : "sideMenuButton hidden"} onClick={() => setShowSidebar(true)}>
          <MenuIcon sx={{
            color: '#fff',
            backgroundColor: 'transparent',
            height: 52,
            width: 52,
          }} />
        </button>
        {/* Título de la página */}
        <h1 className="pageTitleArenas">ARENAS DE JUEGO</h1>
      </div>
      <div className="arenas-container">
        {!arenaPopUp.showPopUp &&
          <div className="arenas-container center">
            <div className="arenasContentShowing">
              <div>
                <button className={mostrandoPantalla.modo === 'Rapid' ? "contenidoButtonArenas selected" : "contenidoButtonArenas"} 
                  onClick={() => setMostrandoPantalla(prevState => ({...prevState, modo : 'Rapid', elo : userInfo.eloRapid}))}>
                  Rapid
                </button>
                <button className={mostrandoPantalla.modo === 'Bullet' ? "contenidoButtonArenas selected" : "contenidoButtonArenas"} 
                  onClick={() => setMostrandoPantalla(prevState => ({...prevState, modo :'Bullet', elo : userInfo.eloBullet}))}>
                  Bullet
                </button>
                <button className={mostrandoPantalla.modo === 'Blitz' ? "contenidoButtonArenas selected" : "contenidoButtonArenas"} 
                  onClick={() => setMostrandoPantalla(prevState => ({...prevState,modo : 'Blitz', elo : userInfo.eloBlitz}))}>
                  Blitz
                </button>
              </div>
              <h2 className="infoPuntosArenas">Elo {mostrandoPantalla.modo} : {mostrandoPantalla.elo}</h2>
            </div>
            {/* Listado de las arenas */}
            <div className="arenas">
              {arenas.map((arena, index) => (
                <div key={index} className="lista-arenas" onMouseEnter={() => setHoveredArena(index)} onMouseLeave={() => setHoveredArena(null)}>
                  <button className="boton-arenas"
                    onClick={() => setArenaPopUp({ showArena: arena.img, showArenaStr: arena.str, showArenaElo: arena.elo, showPopUp: true })}>
                    {/* Imagen de la arena */}
                    <img className={mostrandoPantalla.arena === arena.str ? "imagenArena glowing-background" : "imagenArena"} src={arena.img} alt={`Tablero ${index}`} />
                  </button>
                  {hoveredArena === index &&
                    <div className="message">
                      {/* Información "on hover" */}
                      Arena {index + 1}
                    </div>}
                </div>
              ))}
            </div>
          </div>
        }
        {arenaPopUp.showPopUp &&
          <div className="arenas-container focusArena">
            {/* Botón para volver hacia atrás (al listado de arenas) */}
            <div className="atras">
              <button className="atras-boton" onClick={() => setArenaPopUp({ showArena: '', showArenaStr: '', showArenaElo: '', showPopUp: false })}>
                <Tooltip title="Atrás">
                  <ArrowBackIosNewIcon sx={{
                    height: 32,
                    width: 32,
                    color: 'white',
                  }} />
                </Tooltip>
              </button>
            </div>
            <div className="infoYarena">
              {/* Información acerca de la arena */}
              <div className="arenaInfo">
                <div className={`arenaInfo text`}>
                  <h2>ARENA DE {arenaPopUp.showArenaStr}</h2>
                  <div className="arenaInfo list">
                    <p className="arenaInfo elo">Elo requerido : {arenaPopUp.showArenaElo}</p>
                    <hr style={{ width: '80%', padding: '0' }}></hr>
                    {/* Descripción de la arena */}
                    <p className="arenaInfo descripcion">{descripcion}</p>
                  </div>
                </div>
              </div>
              {/* Imagen de la arena cuando se ha desplegado su información */}
              <div className="arenaPopUp">
                <img className="imagenPopUp" src={arenaPopUp.showArena} alt='arena' />
              </div>
            </div>
          </div>
        }
      </div>
    </div>
  );
}

export default Arenas;