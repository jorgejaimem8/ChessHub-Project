import React, { useState, useEffect } from 'react';
import '../styles/Casilla.css'
/* Imagenes de piezas */
const imagenesPiezas = require.context('../images/pieces', true);

const Casilla = (args) => {

    // Definir los colores de las casillas según la arena seleccionada
    let BLANCO, NEGRO;
    switch (args.arena) {
        case 'MADERA':
            BLANCO = '#D2B48C';
            NEGRO = '#8B4513';
            break; 
        case 'MARMOL':
            BLANCO = '#f5f5f5';
            NEGRO = '#B8B8B8';
            break;
        case 'ORO':
            BLANCO = '#FFEA70';
            NEGRO = '#F5D000';
            break;
        case 'ESMERALDA':
            BLANCO = '#50C878';
            NEGRO = '#38A869';
            break;
        case 'DIAMANTE':
            BLANCO = '#F0F0F0';
            NEGRO = '#B0E0E6';
            break;
        default:
          break;
    }

    const mFila = args.rowIndex
    const mCol = args.colIndex

    //PARA MOSTRAR TABLERO CON NEGRAS ABAJO CAMBIAR LOS #COLORES
    const colorCasilla = ((mFila+mCol) %2 === 0)? BLANCO : NEGRO

    const imagen = {
        height: '90%',
        width: '90%',
    }

    function char2Src(char, alcanzable) {
        let img = ''
        let alt = ''
        let familiaPieza = '';
        // Si el usuario no ha iniciado sesión, jugará con el set de piezas por defecto
        if (args.userInfo.loggedIn === 'true') {
          familiaPieza = args.userInfo.userPiezas === 'DEFECTO' ? 'CBURNETT' : args.userInfo.userPiezas; 
        }else{
          familiaPieza = 'CBURNETT';
        }

        switch (char) {
            case 'p':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/bP.svg`);
                alt = 'peon negro';
                break;
            case 'r':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/bR.svg`);
                alt = 'torre negra';
                break;
            case 'n':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/bN.svg`);
                alt = 'caballo negro';
                break;
            case 'b':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/bB.svg`);
                alt = 'alfil negro';
                break;
            case 'q':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/bQ.svg`);
                alt = 'reina negra';
                break;
            case 'k':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/bK.svg`);
                alt = 'rey negro';
                break;
            case 'P':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/wP.svg`);
                alt = 'peon blanco';
                break;
            case 'R':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/wR.svg`);
                alt = 'torre blanca';
                break;
            case 'N':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/wN.svg`);
                alt = 'caballo blanco';
                break;
            case 'B':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/wB.svg`);
                alt = 'alfil blanco';
                break;
            case 'Q':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/wQ.svg`);
                alt = 'reina blanca';
                break;
            case 'K':
                img = imagenesPiezas(`./${familiaPieza.toLowerCase()}/wK.svg`);
                alt = 'rey blanco';
                break;
            default:
                img = require('../images/Empty.svg').default;
                alt = 'casilla vacia';
                break;
        }
        let alcanzableImg = (char === '')? require('../images/alcanzaVacia.svg').default : require('../images/alcanzaMata.svg').default
        return(
            <div style={{position: 'relative'}}>
                <img style={imagen} src={img} alt={alt} />
                {alcanzable !== '' &&
                    <img style={{...imagen, position: 'absolute', top: 0, left: 0}} src={alcanzableImg}/>}
            </div>
        )
    
        
    }

    const [hovered, setHovered] = useState(false);

    const handleMouseIn = () => {setHovered(true)}
    const handleMouseOut = () => {setHovered(false)}

    
    /**
     * Maneja el evento de clic para la casilla.
     */
    const handleClick = () => {
        
        //Si soy una casilla con una pieza seleccionable y me seleccionan cambio piezaSel
        if ('['+mFila+'-'+mCol+']' in args.movsPosibles){
            args.setPiezaSel({fila: mFila, col: mCol})
        } else { //Si me han clickado y no soy una pieza seleccionable (entre las q tienen movs posibles)
          if (args.piezaSel!==null){ //Si hay una pieza seleccionada
              //Se comprueba si esta casilla esta entre movs posibles de la pieza seleccionada, si lo esta setNewMov
              const filaSel = args.piezaSel.fila
              const colSel = args.piezaSel.col
              // const soyMovPosible = args.movsPosibles['['+filaSel+'-'+colSel+']'].some(
              //     (element) => element[0] === mFila && element[1] === mCol
              // );
              // if (soyMovPosible) {
              //     args.setNewMov({fila: mFila, col: mCol})
              // }
              const movPosiblesKey = '[' + filaSel + '-' + colSel + ']';
              if (movPosiblesKey in args.movsPosibles) {
                  const soyMovPosible = args.movsPosibles[movPosiblesKey].some(
                      (element) => element[0] === mFila && element[1] === mCol
                  );
                  if (soyMovPosible) {
                      args.setNewMov({ fila: mFila, col: mCol });
                  }
              }
            }  
        }
    }

    
    return (
        <button 
            onClick={handleClick} 
            onMouseEnter={handleMouseIn} 
            onMouseLeave={handleMouseOut}
            className="casilla-base" // Aplicar la clase CSS para los estilos base
           style={{
                backgroundColor: hovered ? '#D3FFDE' : colorCasilla,
                transform: !args.blancasAbajo ? 'rotate(180deg)' : 'none' // Aplica rotación si blancasAbajo es true
            }} // Aplicar dinámicamente el color de la casilla
        >       
        { args.tablero  ? char2Src(args.tablero[mFila][mCol], args.alcanzables[mFila][mCol]): ""}

        </button>
     );
}
 
export default Casilla;