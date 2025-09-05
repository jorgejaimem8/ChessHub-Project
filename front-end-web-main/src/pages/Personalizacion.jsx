import React, { useEffect } from "react";
import '../styles/Personalizacion.css';
import { useState } from "react";
import SideBar from "../components/SideBar";
import MenuIcon from '@mui/icons-material/Menu';
import Pagination from '@mui/material/Pagination';
const apiUrl = process.env.REACT_APP_API_URL;

// Importar las imágenes de las piezas
const imagenesPiezas = require.context('../images/pieces', true);


function Personalizacion ({ userInfo, updateUserInfo }) {
  /* Hook para controlar si el sideBar es visible o no lo es */
  const [showSidebar, setShowSidebar] = useState(false);
  const [rewardShowing, setRewardShowing] = useState('piezas');
  const [currentPagePiezas, setCurrentPagePiezas] = useState(1); // State to track the current page
  const [currentPageEmotes, setCurrentPageEmotes] = useState(1); // State to track the current page

  const chunkSizePiezas = 4; // Number of elements per chunk
  const chunkSizeEmotes = 9;

  // Function to split the array into chunks
  const chunkArray = (arr, size) => {
    return arr.reduce((chunks, el, i) => {
      if (i % size === 0) {
        chunks.push([el]);
      } else {
        chunks[chunks.length - 1].push(el);
      }
      return chunks;
    }, []);
  };

  // Set de piezas del usuario
  const [fichasSelected, setFichasSelected] = useState('DEFECTO');
  // Conjunto de emoticonos del usuario
  const [emotesSelected, setEmotesSelected] = useState(['','','','']);
  // Nivel del usuario (recompensas desbloqueadas)
  const [userLevel, setUserLevel] = useState(0);

  const [error, setError] = useState(null);
  useEffect(() => { // Pedir la información del usuario

    const fetchUserData = async () => {
      if(userInfo.loggedIn==='true'){
        try {
          const response = await fetch(`${apiUrl}/users/${userInfo.userId}`); // Construct URL using userId
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          const userData = await response.json();
          setUserLevel(userData.nivelpase); // Actualizar nivel pase de batalla del usuario para saber que recompensas tiene desbloqueadas
          setFichasSelected(userData.setpiezas);
  
          // Lee del back-end el set de emoticonos del usuario
          const emojiArray = userData.emoticonos.replace(/[{}"]/g, '').split(',');
          const emojisCleaned = emojiArray.map(emoji => emoji.trim()).filter(emoji => emoji !== '');
          setEmotesSelected(emojisCleaned);
          updateUserInfo({ field : 'userEmotes', value : emojisCleaned });
        } catch (error) {
          setError(error.message);
        }
      }
    }

    fetchUserData();
  }, [])

  // Emoticonos del juego
  const emotesPreview = [
    { level: 1, value: '😁️'},
    { level: 3, value: '😂️'},
    { level: 5, value: '👍️'},
    { level: 7, value: '😲️'},
    { level: 9, value: '😭️'},
    { level: 11, value: '😅️'},
    { level: 13, value: '👊️'},
    { level: 15, value: '🤩️'},
    { level: 17, value: '🤯️'},
    { level: 19, value: '😜️'},
    { level: 21, value: '🫠️'},
    { level: 23, value: '😎️'},
    { level: 25, value: '😡️'},
    { level: 27, value: '😈️'},
    { level: 29, value: '👻️'},
  ];
  // Piezas del juego
  const PIEZAS = ['K', 'Q', 'B', 'N', 'P', 'R'];
  const piezasPreview = [
    { level: 0, modelo: 'DEFECTO'},
    { level: 2, modelo: 'ALPHA'},
    { level: 4, modelo: 'CARDINAL'},
    { level: 6, modelo: 'CELTIC'},
    { level: 8, modelo: 'CHESS7'},
    { level: 10, modelo: 'CHESSNUT'},
    { level: 12, modelo: 'COMPANION'},
    { level: 14, modelo: 'FANTASY'},
    { level: 16, modelo: 'FRESCA'},
    { level: 18, modelo: 'GOVERNOR'},
    { level: 20, modelo: 'KOSAL'},
    { level: 22, modelo: 'LEIPZIG'},
    { level: 24, modelo: 'MPCHESS'},
    { level: 26, modelo: 'PIXEL'},
    { level: 28, modelo: 'MAESTRO'},
    { level: 30, modelo: 'ANARCANDY'},
  ];

  const piezasChunks = chunkArray(piezasPreview, chunkSizePiezas);
  const emotesChunks = chunkArray(emotesPreview, chunkSizeEmotes);

  const handleChangePagePiezas = (event, newPage) => {
    setCurrentPagePiezas(newPage);
  };

  const handleChangePageEmotes = (event, newPage) => {
    setCurrentPageEmotes(newPage);
  };

  const addEmote = (emote) => {
    setEmotesSelected(prevEmotes => {
      const newEmotes = [...prevEmotes.slice(1), emote];
      return newEmotes.length > 4 ? newEmotes.slice(0, 4) : newEmotes;
    });
  };

  const sendUserPiezas = async () => {
    const setPiezas = fichasSelected;
    updateUserInfo({ field : 'userPiezas', value : fichasSelected })
    try {
      const response = await fetch(`${apiUrl}/users/update_set_piezas/${userInfo.userId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ setPiezas })
      });
      const data = await response.json();
    
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
    } catch (error) {
      setError(error.message);
    }
  }

  const sendUserEmoticonos = async () => {
    var emoticonos = emotesSelected;
    updateUserInfo({ field : 'userEmotes', value : emotesSelected});
    try {
      const response = await fetch(`${apiUrl}/users/update_emoticonos/${userInfo.userId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ emoticonos })
      });
      const data = await response.json();
    
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
    } catch (error) {
      setError(error.message);
    }
  }

  return(
    <div className="fondoPersonalizacion">
      {/* Menú desplegable (sideBar) */}
      <div className={showSidebar ? "sidePersonalizacion open" : "sidePersonalizacion"}>
        <SideBar setShowSidebar={setShowSidebar}/>
      </div>
      <div className="titlePersonalizacion">
        {/* Botón para desplegar el sidebar */}
        <button className={!showSidebar ? "sideMenuButtonPersonalizacion" : "sideMenuButtonPersonalizacion hidden"} 
          onClick={() => setShowSidebar(true)}>
          <MenuIcon sx={{
            color: '#fff',
            backgroundColor: 'transparent',
            height: 52,
            width: 52,
          }} />
        </button>
        {/* Título de la página */}
        <h1 className="pageTitlePersonalizacion">PERSONALIZACION</h1>
      </div>
      <div className="containerPersonalizacion">
        <div className="containerPersonalizacion center">
          <div className="menuDeslizante">
            {/* Contenido a mostrar (piezas / emoticonos) */}
            <div>
              <button className={rewardShowing == 'piezas' ? "contenidoButton selected" : "contenidoButton"}
                onClick={() => setRewardShowing('piezas')}>
                  Piezas
              </button>
              <button className={rewardShowing == 'emoticonos' ? "contenidoButton selected" : "contenidoButton"} 
                onClick={() => setRewardShowing('emoticonos')}>
                  Emoticonos
              </button>
            </div>
            {/* Mensajes informativos cuando se muestran piezas/emoticonos */}
            {rewardShowing === 'piezas' ? (
              <div style={{textDecoration: 'underline'}}>
                Selecciona un aspecto para las piezas
              </div>
            ) : (
              <div style={{textDecoration: 'underline'}}>
                Selecciona 4 emoticonos para la partida
              </div>
            )}
            {/* Eleccion de piezas / Emoticonos */}
            {rewardShowing === 'piezas' ? (
              /* Listado de aspectos de piezas */
              <div className="menuDeslizanteContenido">
                {piezasChunks[currentPagePiezas - 1]?.map((piezas, i) => (
                  <button key={i} className={userLevel >= piezas.level ? (`listadoPiezas ${fichasSelected === piezas.modelo ? 'selected' : ''}`)
                  : ("listadoPiezas locked")}
                    onClick={() => setFichasSelected(piezas.modelo)} disabled={userLevel < piezas.level}>
                    <div className="modeloPiezas">
                      {piezas.modelo}
                    </div>
                    <div className="familiaPiezas">
                      {PIEZAS.map((blancas, index) => (
                        (piezas.modelo === "DEFECTO") ? (
                          <img key={index} className="piezasIndividuales" src={imagenesPiezas(`./cburnett/w${blancas}.svg`)} />
                        ) : (
                          <img key={index} className="piezasIndividuales" src={imagenesPiezas(`./${piezas.modelo.toLowerCase()}/w${blancas}.svg`)} />
                        )
                      ))}
                    </div>
                    <div className="familiaPiezas">
                      {PIEZAS.map((negras, index) => (
                        (piezas.modelo === "DEFECTO") ? (
                          <img key={index} className="piezasIndividuales" src={imagenesPiezas(`./cburnett/b${negras}.svg`)} />
                        ) : (
                          <img key={index} className="piezasIndividuales" src={imagenesPiezas(`./${piezas.modelo.toLowerCase()}/b${negras}.svg`)} />
                        )
                      ))}
                    </div>
                  </button>
                ))}
              </div> 
            ) : (
              /* Listado de emoticonos */
              <div className="menuDeslizanteContenido">
                {emotesChunks[currentPageEmotes - 1]?.map((emotes, i) => (
                  <button key={i} className={userLevel >= emotes.level ? (`listadoEmotes ${emotesSelected.find(selected => selected == emotes.value) ? 'selected' : ''}`)
                   : ("listadoEmotes locked")}
                    onClick={() => addEmote(emotes.value)} disabled={userLevel < emotes.level}>
                    {emotes.value}
                  </button>
                ))}
              </div> 
            )}
            {/* Botones para cambiar de páginas */}
            {rewardShowing === 'piezas' ? (
              <div className="menuDeslizantePagina">
                <div className="paginationContainer">
                  <Pagination
                    defaultPage={1}
                    count={piezasChunks.length}
                    page={currentPagePiezas}
                    onChange={handleChangePagePiezas}
                    color="primary"
                  />
                </div>
                <div className="cambiosButtonContainer">
                  <button onClick={sendUserPiezas} className="guardarCambiosButton">Guardar cambios</button>
                </div>
              </div>
            ) : (
              <div className="menuDeslizantePagina">
                <div className="paginationContainer">
                  <Pagination
                    defaultPage={1}
                    count={emotesChunks.length}
                    page={currentPageEmotes}
                    onChange={handleChangePageEmotes}
                    color="primary"
                  />
                </div>
                <div className="cambiosButtonContainer">
                  <button onClick={sendUserEmoticonos} className="guardarCambiosButton">Guardar cambios</button>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default Personalizacion;