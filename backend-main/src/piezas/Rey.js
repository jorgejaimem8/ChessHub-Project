const Tablero = require('../Tablero.js'); // Asegúrate de importar correctamente Tablero.js
const Pieza = require('./Pieza.js'); // Asegúrate de importar correctamente Pieza.js
const Peon = require('../piezas/Peon');
const Caballo = require('../piezas/Caballo');
const Alfil = require('../piezas/Alfil');
const Torre = require('../piezas/Torre');
const Dama = require('../piezas/Dama');

//const Posicion = require('./Posicion.js'); // Asegúrate de importar correctamente Posicion.js

class Rey {
    constructor(x, y, color, tablero) {
        this.Posicion = {x, y};
        this.color = color;
        this.tablero = tablero;
        this.estoy_en_jaque = false;
    }
    getColor() {
        return this.color;
    }

    setColor(color) {
        this.color = color;
    }

    getPosicion() {
        return this.Posicion;
    }

    setPosicion(Posicion) {
        this.Posicion = Posicion;
    }


    getClassName() {
        return this.constructor.name;
    }

    obtenerPiezas(color) {
        const piezas = [];
        const casillas = this.tablero.getCasillas();
        // Recorre todas las casillas del tablero
        for (let x = 0; x < 8; x++) {
            for (let y = 0; y < 8; y++) {
                const casilla = casillas[x][y];
                const pieza = casilla.getPieza();
                
                // Si la casilla contiene una pieza y es del color especificado, agrégala a la lista de piezas
                if (pieza !== null && pieza.getColor() === color) {
                    piezas.push(pieza);
                }
            }
        }

        return piezas;
    }

    obtenerPosicionesAtacadasPorOponente(colorRey, comprobarEstaPiezaProtegida) {
        let posicionesAtacadasPorOponente = [];
        const colorOponente = colorRey === 'blancas' ? 'negras' : 'blancas';
        const piezasOponente = this.obtenerPiezas(colorOponente);
        piezasOponente.forEach(pieza => {
            if (pieza instanceof Caballo || pieza instanceof Alfil || pieza instanceof Torre || pieza instanceof Dama) {
                
                const movimientosDisponibles = pieza.obtenerMovimientosDisponibles(comprobarEstaPiezaProtegida);
                posicionesAtacadasPorOponente.push(...movimientosDisponibles);
            }
            else if (pieza instanceof Peon){
                if (pieza.color == 'blancas'){
                    const x1 = pieza.Posicion.x - 1;
                    const y1 = pieza.Posicion.y + 1;
                    const x2 = pieza.Posicion.x + 1;
                    const y2 = pieza.Posicion.y + 1;
        
                    if (pieza._esMovimientoValido(x1, y1)) {
                        posicionesAtacadasPorOponente.push({ x: x1, y: y1 });
                    }
        
                    if (pieza._esMovimientoValido(x2, y2)) {
                        posicionesAtacadasPorOponente.push({ x: x2, y: y2 });
                    }
                }
                else {
                    const x3 = pieza.Posicion.x - 1;
                    const y3 = pieza.Posicion.y - 1;
                    const x4 = pieza.Posicion.x + 1;
                    const y4 = pieza.Posicion.y - 1;
                    if (pieza._esMovimientoValido(x3, y3)) {
                        posicionesAtacadasPorOponente.push({ x: x3, y: y3 });
                    }
        
                    if (pieza._esMovimientoValido(x4, y4)) {
                        posicionesAtacadasPorOponente.push({ x: x4, y: y4 });
                    }
                }
            }
            else if (pieza instanceof Rey){
                const casillas = pieza.tablero.getCasillas();
                for (let dx = -1; dx <= 1; dx++) {
                    for (let dy = -1; dy <= 1; dy++) {
                        if (dx === 0 && dy === 0) continue; // No considerar el movimiento de estar en el mismo lugar
            
                        const x = pieza.Posicion.x + dx;
                        const y = pieza.Posicion.y + dy;
            
                        if (pieza._esMovimientoValido(x, y)) {
                            const casilla = casillas[x][y];
                            if (casilla !== undefined) {
                                posicionesAtacadasPorOponente.push({ x, y });
                            }
                        }
                    }
                }

            }
        });
        return posicionesAtacadasPorOponente;
    }
    
    obtenerPosicionesAtacadasPorOponenteFormato(colorRey) {
        let posicionesAtacadasPorOponente = {
            peon: [],
            alfil: [],
            caballo: [],
            torre: [],
            dama: [],
            rey: []
        };
    
        const colorOponente = colorRey === 'blancas' ? 'negras' : 'blancas';
        const piezasOponente = this.obtenerPiezas(colorOponente);
        
        piezasOponente.forEach(pieza => {
            if (pieza instanceof Caballo || pieza instanceof Alfil || pieza instanceof Torre || pieza instanceof Dama || pieza instanceof Peon) {
                const movimientosDisponibles = pieza.obtenerMovimientosDisponibles();
                // Agregar las propiedades fromX y fromY a cada movimiento
                movimientosDisponibles.forEach(movimiento => {
                    movimiento.fromX = pieza.Posicion.x;
                    movimiento.fromY = pieza.Posicion.y;
                });
                posicionesAtacadasPorOponente[pieza.constructor.name.toLowerCase()].push(...movimientosDisponibles);
            }
        });
        return posicionesAtacadasPorOponente;
    }
    
    
    
    
    movimientoCoincideConCasilla(movimientos, x, y) {
        return movimientos.some(movimiento => movimiento.x === x && movimiento.y === y);
    }
    obtenerMovimientosDisponibles() {
        const movimientos_disponibles_rey = [];
        const casillas = this.tablero.getCasillas();
        
        // Obtener todos los movimientos disponibles del rey
        for (let dx = -1; dx <= 1; dx++) {
            for (let dy = -1; dy <= 1; dy++) {
                if (dx !== 0 || dy !== 0){// No considerar el movimiento de estar en el mismo lugar
                    const x = this.Posicion.x + dx;
                    const y = this.Posicion.y + dy;
                    if (this._esMovimientoValido(x, y)) {
                        const casilla = casillas[x][y];
                        if (casilla !== undefined && casilla !== null) {
                            //console.log("HOLA", this._esMovimientoValido(x, y));
                            if (casilla.getPieza() === null) {
                                movimientos_disponibles_rey.push({ x, y });
                            } else {
                                if (casilla.getPieza().getColor() !== this.color) {
                                    movimientos_disponibles_rey.push({ x, y});
                                }
                            }
                        }
                    }
                }
            }
        }
    
    
        // Filtrar los movimientos que resulten en jaque
        console.log("color ", this.color);
        const posicionesAtacadasPorOponente = this.obtenerPosicionesAtacadasPorOponente(this.color, true);
        const casillasAtacadas = posicionesAtacadasPorOponente.map(movimiento => ({ x: movimiento.x, y: movimiento.y }));
        const movimientosSinJaque = movimientos_disponibles_rey.filter(movimiento => {
            const x = movimiento.x;
            const y = movimiento.y;
            return !this.movimientoCoincideConCasilla(casillasAtacadas, x, y);
        });
        return movimientosSinJaque;
    }
    
    jaque(pieza) {
        const posicionesAtacadasPorOponente = this.obtenerPosicionesAtacadasPorOponente(pieza.color, false);
        return this.movimientoCoincideConCasilla(posicionesAtacadasPorOponente, pieza.Posicion.x, pieza.Posicion.y);
    }



    jaqueMate(pieza, movimientos_disponibles_oponente) {
        console.log("Movimientos disponibles del oponente: ", movimientos_disponibles_oponente);
        let jaque_mate = true;
        let coordenadasDesdeJaque;
        console.log("COORDENADAS REY: ", pieza.Posicion.x, pieza.Posicion.y);
        
        // Obtener desde dónde nos hacen jaque
        coordenadasDesdeJaque = this.getCasillaDesdeJaque(pieza, movimientos_disponibles_oponente);
        console.log("coordenadasDesdeJaque: ", coordenadasDesdeJaque);
        
        // Una vez tenemos desde dónde nos hacen jaque, comprobamos si podemos comer a la pieza que nos hace jaque
        let piezaQuePuedeComer = this.puedeComerPieza(coordenadasDesdeJaque, movimientos_disponibles_oponente);
        if (piezaQuePuedeComer !== null) {
            console.log("Encontrado pieza que puede comer:", piezaQuePuedeComer);
            jaque_mate = false;
        }

        // Comprobar si podemos poner una pieza entre el rey y la pieza que nos hace jaque
        let sePuedeBloquear = this.sePuedePonerEnMedio(coordenadasDesdeJaque, pieza, movimientos_disponibles_oponente);
        console.log("Se puede bloquear: ", sePuedeBloquear);
        if (sePuedeBloquear) {
            jaque_mate = false;
        }

        return jaque_mate;
    }

    getCasillaDesdeJaque(posicionRey, posicionesAtacadas) {
        // Iterar sobre cada tipo de pieza del oponente
        for (const tipoPieza in posicionesAtacadas) {
            // Verificar si el valor asociado a tipoPieza es un array
            if (Array.isArray(posicionesAtacadas[tipoPieza])) {
                // Iterar sobre cada movimiento disponible de esa pieza
                for (const movimiento of posicionesAtacadas[tipoPieza]) {
                    // Verificar si el movimiento coincide con la posición del rey
                    if (movimiento.x === posicionRey.Posicion.x && movimiento.y === posicionRey.Posicion.y) {
                        return {fromX: movimiento.fromX, fromY: movimiento.fromY };
                    }
                }
            }
        }
        // Si no se encuentra ninguna pieza que amenaza al rey, devolver null
        return null;
    }
    getPiezaEnCasilla(x, y){
        const casilla = this.tablero.getCasillas()[x][y];
        return casilla.getPieza();
    }
    

    puedeComerPieza(coordenadasDesdeJaque, movimientos_disponibles) {
        const piezasQueComen = [];
        if (coordenadasDesdeJaque !== null) {
            for (const piezaType in movimientos_disponibles) {
                //console.log("Tipo de pieza: ", piezaType);
                const movimientosPieza = movimientos_disponibles[piezaType];
                //console.log("Movimientos de la pieza: ", movimientosPieza);
                for (const movimiento of movimientosPieza) {
                    // Verificar si el movimiento coincide con las coordenadas de la pieza que da jaque
                    if (movimiento.x === coordenadasDesdeJaque.fromX && movimiento.y === coordenadasDesdeJaque.fromY) {
                        const pieza = {
                            tipo: piezaType,
                            x: movimiento.x,
                            y: movimiento.y,
                            fromX: movimiento.fromX,
                            fromY: movimiento.fromY
                        };
                        console.log("Encontrada pieza que puede comer:", pieza);
                        piezasQueComen.push(pieza);
                    }
                }
            }
        }
        return piezasQueComen.length > 0 ? piezasQueComen : null;
    }

    // Obtener los movimientos que bloquean el jaque
    getBlockingPositions(coordenadasDesdeJaque, pieza) {
        const blockingPositions = [];
        const [jaqueX, jaqueY] = [coordenadasDesdeJaque.fromX, coordenadasDesdeJaque.fromY];
    
        // Calculamos el desplazamiento en x e y
        const dx = Math.sign(pieza.Posicion.x - jaqueX);
        const dy = Math.sign(pieza.Posicion.y - jaqueY);
    
        // Si la pieza y el rey están en la misma fila
        if (jaqueY === pieza.Posicion.y) {
            for (let x = jaqueX + dx; x !== pieza.Posicion.x; x += dx) {
                blockingPositions.push({ x, y: jaqueY });
            }
        }
        // Si la pieza y el rey están en la misma columna
        else if (jaqueX === pieza.Posicion.x) {
            for (let y = jaqueY + dy; y !== pieza.Posicion.y; y += dy) {
                blockingPositions.push({ x: jaqueX, y });
            }
        }
        // Si la pieza y el rey están en una diagonal
        else if (Math.abs(pieza.Posicion.x - jaqueX) === Math.abs(pieza.Posicion.y - jaqueY)) {
            let x = jaqueX + dx;
            let y = jaqueY + dy;
            while (x !== pieza.Posicion.x && y !== pieza.Posicion.y) {
                blockingPositions.push({ x, y });
                x += dx;
                y += dy;
            }
        }
    
        return blockingPositions;
    }
    

    // Método para comprobar si alguna pieza puede interponerse entre el rey y la pieza que nos hace jaque
    sePuedePonerEnMedio(coordenadasDesdeJaque, pieza, movimientos_disponibles) {
        const casillasCaminoJaque = this.getBlockingPositions(coordenadasDesdeJaque, pieza);
        console.log("Casillas en el camino del jaque: ", casillasCaminoJaque);
        console.log("Movimientos Disponibles", movimientos_disponibles);
        let movimientosDePosiblesBloqueantes = this.getPiezasBloqueantes(casillasCaminoJaque, movimientos_disponibles);
        //console.log("Movimientos de posibles bloqueantes: ", movimientosDePosiblesBloqueantes);
        return movimientosDePosiblesBloqueantes;
    }
    getPiezasBloqueantes(casillasCaminoJaque, movimientos_disponibles) {
        const movimientosBloqueantes = {};
    
        for (const piezaType in movimientos_disponibles) {
            const movimientosPieza = movimientos_disponibles[piezaType];
            const piezasBloqueantes = movimientosPieza.filter(movimiento => {
                for (const casilla of casillasCaminoJaque) {
                    if (movimiento.x === casilla.x && movimiento.y === casilla.y) {
                        return true;
                    }
                }
                return false;
            });
    
            if (piezasBloqueantes.length > 0) {
                if (!movimientosBloqueantes[piezaType]) {
                    movimientosBloqueantes[piezaType] = [];
                }
                movimientosBloqueantes[piezaType].push(...piezasBloqueantes);
            }
        }
    
        return movimientosBloqueantes;
    }
    
    
    getFromValues(list, x, y) {
        for (const tuple of list) {
            if (tuple.x === x && tuple.y === y) {
                return { fromX: list[0].fromX, fromY: list[0].fromY };
            }
        }
        return null;
    }

    hasCommonTuple(list1, list2) {
    for (const tuple1 of list1) {
        for (const tuple2 of list2) {
            if (tuple1.x === tuple2.x && tuple1.y === tuple2.y) {
                return true; // Found a common tuple
            }
        }
    }
    return false; // No common tuple found
}

    enroque(ha_movido_rey_blanco, ha_movido_rey_negro, ha_movido_torre_blanca_dcha, ha_movido_torre_blanca_izqda, ha_movido_torre_negra_dcha, ha_movido_torre_negra_izqda
        ,turno, lado) {
        // Verificar que el rey y la torre involucrada no se hayan movido
        const casillas = this.tablero.getCasillas();
        if (turno === 'blancas' && !ha_movido_rey_blanco || turno === 'negras' && !ha_movido_rey_negro) {
            // Determinar las posiciones para el enroque
            if ((lado === "corto" && turno === 'blancas' && !ha_movido_torre_blanca_dcha && !ha_movido_rey_blanco) || (lado === "corto" && turno === 'negras' && !ha_movido_torre_negra_dcha && !ha_movido_rey_negro)) {
                if (casillas[5][this.Posicion.y].getPieza() !== null || casillas[6][this.Posicion.y].getPieza() !== null){
                    console.log("No se puede realizar el enroque: Hay piezas en el camino");
                    return false;
                }
                if (this.jaque(this)) {
                    console.log("No se puede realizar el enroque: El rey está en jaque");
                    return false;
                }
                const movimientosSinJaque = this.obtenerPosicionesAtacadasPorOponente(turno, false);
                //console.log("Moviminetos que evitan el jaque", movimientosSinJaque);
                if (this.movimientoCoincideConCasilla(movimientosSinJaque, 5, this.Posicion.y) ||
                    this.movimientoCoincideConCasilla(movimientosSinJaque, 6, this.Posicion.y)) {
                    console.log("No se puede realizar el enroque " + lado + " de las " + this.color + ": El rey pasa por una casilla bajo ataque");
                    return false;
                }

            } else if ((lado === "largo" && turno === 'blancas' && !ha_movido_torre_blanca_izqda && !ha_movido_rey_blanco) || (lado === "largo" && turno === "negras" && !ha_movido_torre_negra_izqda && !ha_movido_rey_negro))  {
                if (casillas[3][this.Posicion.y].getPieza() !== null || casillas[2][this.Posicion.y].getPieza() !== null || casillas[1][this.Posicion.y].getPieza() !== null){
                    console.log("No se puede realizar el enroque: Hay piezas en el camino");
                    return false;
                }
                if (this.jaque(this)) {
                    console.log("No se puede realizar el enroque: El rey está en jaque");
                    return false;
                }
                const movimientosSinJaque = this.obtenerPosicionesAtacadasPorOponente(turno, false);
                if (this.movimientoCoincideConCasilla(movimientosSinJaque, 3, this.Posicion.y) ||
                    this.movimientoCoincideConCasilla(movimientosSinJaque, 2, this.Posicion.y)) {
                    console.log("No se puede realizar el enroque " + lado + " de las " + this.color + ": El rey pasa por una casilla bajo ataque");
                    return false;
                }
            } else {
                console.log("Lado de enroque no válido");
                return false;
            }
            return true;
        } else {
            console.log("No se puede realizar el enroque: El rey o la torre han sido movidos previamente");
        }
    }

    
    // jaqueMate(pieza, movimientos_disponibles_oponente) {
    //     let jaque_mate = false;
    //     let hay_jaque = this.jaque(pieza)[0];
    //     let piezas_del_oponente = this.jaque(pieza)[1];
    
    //     if (hay_jaque) {
    //         for (const piezaType in movimientos_disponibles_oponente) {
    //             const movimientosPieza = movimientos_disponibles_oponente[piezaType];
    
    //             for (const movimiento of movimientosPieza) {
    //                 const x = movimiento.x;
    //                 const y = movimiento.y;
    
    //                 for (const piezaa of piezas_del_oponente) {
    //                     if (piezaa.Posicion.x === x && piezaa.Posicion.y === y && movimiento.fromColor !== piezaa.color) {
    //                         // Match found, handle your logic here
    //                         console.log("Match found:", piezaa, movimiento, movimientosPieza);
    //                         jaque_mate = true; // Update the jaque_mate variable accordingly
    //                         // return jaque_mate;
    //                         // break; // Exit the inner loop once a match is found
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }
    
    
    

    imprimirMovimientosDisponibles() {
        const movimientos = this.obtenerMovimientosDisponibles();
        console.log("Movimientos disponibles del rey:");
        movimientos.forEach(movimiento => {
            console.log(`(${movimiento.x}, ${movimiento.y})`);
        });
    }
    _agregarMovimiento(x, y, movimientos) {
        if (this._esMovimientoValido(x, y)) {
            movimientos.push({ x, y });
        }
    }

    _esMovimientoValido(x, y) {
        return x >= 0 && x < 8 && y >= 0 && y < 8;
    }
}
module.exports = Rey;