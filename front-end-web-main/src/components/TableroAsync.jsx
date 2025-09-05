import React, { useEffect, useState } from 'react';
import Casilla from './Casilla';
import '../styles/TableroOnline.css'
const apiUrl = process.env.REACT_APP_API_URL;
import damaNegra from '../images/pieces/cburnett/bQ.svg'
import damaBlanca from '../images/pieces/cburnett/wQ.svg'
import caballoNegra from '../images/pieces/cburnett/bN.svg'
import caballoBlanca from '../images/pieces/cburnett/wN.svg'
import alfilNegra from '../images/pieces/cburnett/bB.svg'
import alfilBlanca from '../images/pieces/cburnett/wB.svg'
import torreNegra from '../images/pieces/cburnett/bR.svg'
import torreBlanca from '../images/pieces/cburnett/wR.svg'


const TableroAsync = ({ arena, setGameState, tableroNuevo, id_partida, blancasAbajo, turno, setTurno, userInfo, movido, setMovido,has_perdido, setHas_perdido, has_empatado, setHas_empatado}) => {
  const [showModal, setShowModal] = useState(false);
  const [selectedOption, setSelectedOption] = useState(null);
  const openModal = () => {
      setShowModal(true);
  };

  const closeModal = () => {
      setShowModal(false);
  };
  const [torreBlancaIzdaMovida, setTorreBlancaIzdaMovida] = useState(false);
  const [torreBlancaDchaMovida, setTorreBlancaDchaMovida] = useState(false);
  const [torreNegraIzdaMovida, setTorreNegraIzdaMovida] = useState(false);
  const [torreNegraDchaMovida, setTorreNegraDchaMovida] = useState(false);
  const [reyBlancoMovido, setReyBlancoMovido] = useState(false);
  const [reyNegroMovido, setReyNegroMovido] = useState(false);
  
    function traducirTableroAJSON(matrizAux, turnoPartida) {
      const piezas = {
          'p': 'peon',
          'n': 'caballo',
          'b': 'alfil',
          'r': 'torre',
          'q': 'dama',
          'k': 'rey',
      };
      const json = {
          has_perdido: has_perdido,
          has_empatado:has_empatado,
          turno: turnoPartida === 0 ? 'blancas' : 'negras', // Añadir el turno al principio del JSON
          ha_movido_rey_blanco: reyBlancoMovido,
          ha_movido_rey_negro: reyNegroMovido,
          ha_movido_torre_blanca_dcha: torreBlancaDchaMovida,
          ha_movido_torre_blanca_izqda: torreBlancaIzdaMovida,
          ha_movido_torre_negra_dcha: torreNegraDchaMovida,
          ha_movido_torre_negra_izqda: torreNegraIzdaMovida,
          peon: [],
          alfil: [],
          caballo: [],
          torre: [],
          dama: [],
          rey: []
      };
      const matrizReorganizada = matrizAux.slice().reverse();

      matrizReorganizada.forEach((fila, x) => {
          fila.forEach((pieza, y) => {
              if (pieza !== '') {
                  const color = (pieza === pieza.toUpperCase() ? 'blancas' : 'negras');
                  const tipo = piezas[pieza.toLowerCase()];
                  json[tipo].push({
                      x: y,
                      y: x, // Invertir la posición
                      color: color
                  });
              }
          });
      });
      return json;
    }

    function transformarMovimientos(json) {
        const movsPosiblesNew = {};
        Object.keys(json.allMovements).forEach(pieza => {
               if (pieza === 'comer' || pieza === 'bloquear') {
                  // Obtener la sección de movimientos correspondiente
                  let movimientos = json.allMovements[pieza][0];
                  
                  // Recorrer cada tipo de pieza dentro de la sección de movimientos
                  for (let pieza2 in movimientos) {
                      // Obtener los movimientos de la pieza
                      let movimientosPieza = movimientos[pieza2];
                      
                      // Procesar cada movimiento de la pieza
                      movimientosPieza.forEach((movimiento) => {
                        let newX = 0;
                        let newY = 0;
                        let key = 0;
                              newX = movimiento.fromColor === 'blancas' ? 7 - movimiento.fromY : 7 - movimiento.fromY;
                              newY = movimiento.fromX;
                              key = `[${newX}-${newY}]`;
                          if (!movsPosiblesNew[key]) {
                              movsPosiblesNew[key] = [];  
                          }
                          // Agregar los movimientos posibles al objeto
                          movsPosiblesNew[key].push([7 - movimiento.y, movimiento.x]);
                      });
                  }
              }else if(pieza==='jaque'){
                //pasalo
              }else{
              json.allMovements[pieza].forEach((movimientos) => {
                  let newX=0;
                  let newY=0;
                  let key=0;
                  if (Array.isArray(movimientos)) {
                      movimientos.forEach((movimiento, i) => {
                          if(i===0){
                              // newX = movimiento.fromColor === 'blancas' ? 7 - movimiento.fromY : 7 - movimiento.fromY;
                              let newX = 7 - movimiento.fromY;
                              newY = movimiento.fromX;
                              key = `[${newX}-${newY}]`;
                          }
                          if (!movsPosiblesNew[key]) {
                              movsPosiblesNew[key] = [];  
                          }else{
                              movsPosiblesNew[key].push([7 - movimiento.y, movimiento.x]);
                          }
                      });
                  }
              });
            }
            }
        );
        // Eliminar los movimientos que no sean de piezas del color que le toca jugar
        // for (const key in movsPosiblesNew) {
        //   const [x, y] = key.slice(1, -1).split('-');
        //   const piece = tablero[x][y];
          
        //   if ((blancasAbajo && piece === piece.toLowerCase()) || // Si es el tablero de blancas y la pieza es negra
        //   (!blancasAbajo && piece === piece.toUpperCase())) { // o si es el tablero de blancas y la pieza es negra
        //     delete movsPosiblesNew[key];
        //   }
          
        // }
        return movsPosiblesNew;
    }

    const [movsPosibles, setMovsPosibles] = useState({})


    
    const [tablero, setTablero] = useState(null)

    //Matriz que indica si una casilla es alcanzable por la pieza seleccionada 
    const [alcanzables, setAlcanzables] = useState(['', '', '', '', '', '', '', ''].map(() => ['', '', '', '', '', '', '', ''])) //8x8

    //Coordenadas de la pieza seleccionada
    const [piezaSel, setPiezaSel] = useState(null)

    //movimiento es:
    //{fil:x, col:y} (coordenadas a las que se ha movido piezasel)
    const [movimiento, setNewMov] = useState(0)

    // Que color esta jugando. 0: blancas, 1: negras
    // const [turno, setTurno] = useState(0) 

        //SE SELECCIONA UNA PIEZA NUEVA
    useEffect(() => {
        if (tableroNuevo) { //Si se ha seleccionado una pieza
          setTablero(tableroNuevo)
          submitMov(tableroNuevo, turno)
        }
    }, [tableroNuevo, turno])



    useEffect(()=>{
      if(movsPosibles && tablero){
        let aux = movsPosibles;
        for (const key in aux) {
            const [x, y] = key.slice(1, -1).split('-');
            const piece = tablero[x][y];
            if ((turno === 0 && piece === piece.toLowerCase()) || // Si le tocara a las blancas y la pieza es negra
                (turno === 1 && piece === piece.toUpperCase())) { // o si le tocara a las negras y la pieza es blanca
                delete aux[key];
            }
            
        }
        setMovsPosibles(aux)
      }

    }, [tablero, movsPosibles])
    // Funcion que envia tablero al servidor
    // Si el movimiento es legal: actualiza los movimientos posibles dado el nuevo tablero y devuelve true
    // Si el movimiento no es legal: devuelve false y no actualiza los movimientos posibles
    const submitMov = async(nuevoTablero, turnoPar)=>{
      try {
            const jsonMatriz = traducirTableroAJSON(nuevoTablero, turnoPar); // Convertir el nuevo tablero en una cadena JSON
            // Se envia el tablero al back para que valide si el movimiento es legal y devuelva los movimientos posibles
            // const response = await fetch('http://13.51.136.199:3001/play', {
            const response = await fetch(`${apiUrl}/play`, {
                method: 'POST',
                headers: {
                    'Content-type': 'application/json',
                },
                body: JSON.stringify(jsonMatriz),
            });

            const parseRes = await response.json(); // parseRes es el objeto JSON que se recibe
            
            
            
            if (parseRes.jugadaLegal === true) { // Si la jugada es legal (campo jugadaLegal) se cambian los movimientos posibles
              const newMovsPosibles = transformarMovimientos(parseRes);
                
                // Comprobacion si se viola clavada (si con alguno de los nuevos movs posibles se come a un rey)
                for (const key in newMovsPosibles) { 
                    const movements = newMovsPosibles[key];
                    for (const movement of movements) {
                        const [x, y] = movement;
                        const piece = nuevoTablero[x][y].toLowerCase();
                        if (piece === 'k') {
                            return false;
                        }
                    }
                }

                setMovsPosibles(newMovsPosibles);

              return true;

            } else if(parseRes["Jaque mate"]===true){
              setHas_perdido(true);
              setGameState(prevState => ({
                ...prevState,
                victory: true,
                victoryCause: 'jaque',
                ganador:turno
              }));
              return true;

            }else if(parseRes["tablas"]===true || parseRes["Rey ahogado"]===true){
              setHas_empatado(true);
              setGameState(prevState => ({
                ...prevState,
                victory: false,
                empate:true,
                ganador:turno
              }));
              return true;
            }
             else { //La jugada no es legal

              return false;
            }
        } catch (err) {
            console.error('pillao un error en submitMov:');
            console.error(err.message);
            return false;
        }
    }


    const [X, setX] = useState(null);
    const [Y, setY] = useState(null);
    const [oldX, setOldX] = useState(null);
    const [oldY, setOldY] = useState(null);

    //SE SELECCIONA UNA PIEZA NUEVA
    useEffect(() => {
        if (piezaSel) { //Si se ha seleccionado una pieza
            const newAlcanzables = ['', '', '', '', '', '', '', ''].map(() => ['', '', '', '', '', '', '', '']) //8x8
            const filSel = piezaSel.fila
            const colSel = piezaSel.col
            const alcanzables = movsPosibles['['+filSel+'-'+colSel+']'] 
            if (alcanzables) {
                alcanzables.forEach(([x, y]) => {
                    newAlcanzables[x][y] = 's'; //una 's' en las casillas alcanzables por la pieza seleccionada
                });
                setAlcanzables(newAlcanzables);
            }
        }
    }, [piezaSel])

    //OCURRE UN MOVIMIENTO
    useEffect(() => {
      if(piezaSel && movimiento !== 0 && ((turno === 0 && blancasAbajo===true && tablero[piezaSel.fila][piezaSel.col] === tablero[piezaSel.fila][piezaSel.col].toUpperCase()) || (turno===1 && blancasAbajo===false && tablero[piezaSel.fila][piezaSel.col] === tablero[piezaSel.fila][piezaSel.col].toLowerCase()))){ //Si ha ocurrido un movimiento
          //Se obtienen las coordenadas de la casilla origen
            const oldX = piezaSel.fila
            const oldY = piezaSel.col
            setOldX(oldX)
            setOldY(oldY)
            //Se obtienen las coordenadas de la casilla destino
            const newX = movimiento.fila
            const newY = movimiento.col
            if(tablero[oldX][oldY]==='k'){
              setReyNegroMovido(true);
            }else if(tablero[oldX][oldY]==='K'){
              setReyBlancoMovido(true);
            }else if(tablero[oldX][oldY]==='r'){
              if(oldY===0){
                setTorreNegraIzdaMovida(true)
              }else{
                setTorreNegraDchaMovida(true)
              }
            }else if (tablero[oldX][oldY]==='R'){
              if(oldY===0){
                setTorreBlancaIzdaMovida(true)
              }else{
                setTorreBlancaDchaMovida(true)
              }
            }
            // Se intercambian los contenidos de las casillas
            const newTablero = JSON.parse(JSON.stringify(tablero)) //asi se hace una copia  
            newTablero[newX][newY] = tablero[oldX][oldY]
            newTablero[oldX][oldY] = ''

            if((newTablero[newX][newY]==='K' || newTablero[newX][newY]==='k')&&(Math.abs(oldY-newY))===2){
              if(newY===6){
                newTablero[newX][5] = newTablero[newX][newY+1]
                newTablero[newX][7]=''
              }
              if(newY===2){
                newTablero[newX][3] = newTablero[newX][newY-2]
                newTablero[newX][0]=''
              }
            } else if((newTablero[newX][newY]==='P' && newX==0 ) || (newTablero[newX][newY]==='p' && newX==7)){
                setX(prevX => newX);
                setY(prevY => newY);

                openModal();
                return
            }

            submitMov(newTablero, turno === 0 ? 1 : 0)
            .then(isLegal => {
              if (isLegal) {
                setTablero(newTablero); // Se cambia el tablero
                setAlcanzables(['', '', '', '', '', '', '', ''].map(() => ['', '', '', '', '', '', '', ''])); // Se limpian las casillas alcanzables
                
                // setTurno(turno === 0 ? 1 : 0); // Cambia el color que tiene el turno
                const postData = {
                  id_partida:id_partida,
                  tablero_actual:traducirTableroAJSON(newTablero, turno === 0 ? 1 : 0)
                };
                // Configura las opciones de la solicitud
                const requestOptions = {
                  method: 'POST',
                  headers: {
                    'Content-Type': 'application/json'
                    // Si necesitas agregar más encabezados, puedes hacerlo aquí
                  }, 
                  body: JSON.stringify(postData) // Convierte los datos a formato JSON
                };
                
                // Realiza la solicitud POST a la API utilizando fetch
                fetch(`${apiUrl}/users/update_cambio_partida_asincrona/${id_partida}`, requestOptions)
                  .then(response => response.json())
                  .catch(error => {
                    console.error('Error al realizar la solicitud POST:', error);
                    // Aquí puedes manejar el error si la solicitud POST falla
                  });
              const timeout = setTimeout(() => {
                      setMovido(true);
                    }, 1000);
              }
              setPiezaSel(null); // No hay piezas seleccionadas
            })
            .catch(error => {
              // Manejar el error aquí si es necesario
              console.error("Error al procesar el movimiento:", error);
            });

        }
    }, [movimiento])

    useEffect(()=>{
      if(has_perdido || has_empatado){
        const postData = {
                  tablero_actual:traducirTableroAJSON(tablero,turno === 0 ? 1 : 0)
                };

                // Configura las opciones de la solicitud
                const requestOptions = {
                  method: 'POST',
                  headers: {
                    'Content-Type': 'application/json'
                    // Si necesitas agregar más encabezados, puedes hacerlo aquí
                  }, 
                  body: JSON.stringify(postData) // Convierte los datos a formato JSON
                };

                // Realiza la solicitud POST a la API utilizando fetch
                fetch(`${apiUrl}/users/update_cambio_partida_asincrona/${id_partida}`, requestOptions)
                  .then(response => response.json())
                  .catch(error => {
                    console.error('Error al realizar la solicitud POST:', error);
                    // Aquí puedes manejar el error si la solicitud POST falla
                  });
      }
    }, [has_perdido, tablero, has_empatado])
    
    useEffect(() =>{
      if(!showModal && selectedOption){
         const newTablero = JSON.parse(JSON.stringify(tablero)) //asi se hace una copia 
           newTablero[X][Y]= selectedOption;
          // newTablero[turno === 0 ? X+1 : X-1][Y] = ''
          newTablero[oldX][oldY] = ''
         submitMov(newTablero, turno === 0 ? 1 : 0)
            .then(isLegal => {
              if (isLegal) {
                setTablero(newTablero); // Se cambia el tablero
                // setTurno(turno === 0 ? 1 : 0); // Cambia el color que tiene el turno
                const postData = {
                  tablero_actual:traducirTableroAJSON(newTablero,turno === 0 ? 1 : 0)
                };

                // Configura las opciones de la solicitud
                const requestOptions = {
                  method: 'POST',
                  headers: {
                    'Content-Type': 'application/json'
                    // Si necesitas agregar más encabezados, puedes hacerlo aquí
                  }, 
                  body: JSON.stringify(postData) // Convierte los datos a formato JSON
                };

                // Realiza la solicitud POST a la API utilizando fetch
                fetch(`${apiUrl}/users/update_cambio_partida_asincrona/${id_partida}`, requestOptions)
                  .then(response => response.json())
                  .catch(error => {
                    console.error('Error al realizar la solicitud POST:', error);
                    // Aquí puedes manejar el error si la solicitud POST falla
                  });
               const timeout = setTimeout(() => {
                      setMovido(true);
                    }, 1000);   
              }
              setPiezaSel(null); // No hay piezas seleccionadas
            })
            .catch(error => {
              // Manejar el error aquí si es necesario
              console.error("Error al procesar el movimiento:", error);
            });
      }
    },[showModal])
    
    return (
        <>
        <div className={`tableroOnline ${!blancasAbajo ? 'rotated' : ''}`}>
            {[...Array(8)].map((_, rowIndex) => (
                <div key={rowIndex}  className="filatabOnline">
                    {[...Array(8)].map((_, colIndex) => (
                        <Casilla 
                            key={`${rowIndex}-${colIndex}`} // Add unique key prop here
                            tablero={tablero}
                            alcanzables={alcanzables}
                            rowIndex={rowIndex} 
                            colIndex={colIndex} 
                            piezaSel={piezaSel} 
                            setPiezaSel={setPiezaSel}
                            movsPosibles={movsPosibles}
                            setNewMov={setNewMov}
                            blancasAbajo={blancasAbajo}
                            arena={"MADERA"}
                            userInfo={userInfo}
                        />
                    ))}
                </div>
            ))}
        </div>
        {showModal && (
            <div className="modal">
                <div className="modal-content">
                    <span className="close" onClick={closeModal}>&times;</span>
                    <p>Selecciona una opción para coronar:</p>
                    <div className='opciones-modal-tablero'> 
                        <img style={{ width: '50px', height: '50px' }} src={turno === 0 ? `${damaBlanca}` : `${damaNegra}`} onClick={() => { setSelectedOption(turno === 0 ? 'Q' : 'q'); closeModal(); }} alt="Dama" />
                        <img style={{ width: '50px', height: '50px' }} src={turno === 0 ? `${alfilBlanca}` : `${alfilNegra}`} onClick={() => { setSelectedOption(turno === 0 ? 'B' : 'b'); closeModal(); }} alt="Alfil" />
                        <img style={{ width: '50px', height: '50px' }} src={turno === 0 ? `${caballoBlanca}` : `${caballoNegra}`} onClick={() => { setSelectedOption(turno === 0 ? 'N' : 'n'); closeModal(); }} alt="Caballo" />
                        <img style={{ width: '50px', height: '50px' }} src={turno === 0 ? `${torreBlanca}` : `${torreNegra}`} onClick={() => { setSelectedOption(turno === 0 ? 'R' : 'r'); closeModal(); }} alt="Torre" />
                    </div>

                </div>
            </div>
        )}
        </>
    );
};

export default TableroAsync;