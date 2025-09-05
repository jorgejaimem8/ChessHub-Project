const Tablero = require('../Tablero.js'); // Asegúrate de importar correctamente Tablero.js
const Pieza = require('./Pieza.js'); // Asegúrate de importar correctamente Pieza.js

class Peon {
    constructor(x, y, color, tablero) {
        this.Posicion = {x, y};
        this.color = color;
        this.tablero = tablero;
        this.puntos = 1;
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

    obtenerMovimientosDisponibles() {
        let movimientos_disponibles_peon = [];
        const casillas = this.tablero.getCasillas();
        let casilla;

        // PEONES BLANCOS
        if (this.color === "blancas"){
            casilla = casillas[this.Posicion.x][this.Posicion.y + 1];
            if(casilla !== undefined && casilla !== null && casilla.getPieza() === null) {
                this._agregarMovimiento(this.Posicion.x, this.Posicion.y + 1, movimientos_disponibles_peon);
            }
            if(this.Posicion.y === 1) {
                let casillaAux = casillas[this.Posicion.x][this.Posicion.y + 1];
                if(casillaAux.getPieza() === null) {
                    casilla = casillas[this.Posicion.x][this.Posicion.y + 2];
                    if(casilla !== undefined && casilla !== null && casilla.getPieza() === null) {
                        this._agregarMovimiento(this.Posicion.x, this.Posicion.y + 2, movimientos_disponibles_peon);
                    }
                }
            }
            
        }

        // PEONES NEGROS
        else {
            casilla = casillas[this.Posicion.x][this.Posicion.y - 1];
            if(casilla !== undefined && casilla !== null && casilla.getPieza() === null) {
                this._agregarMovimiento(this.Posicion.x, this.Posicion.y - 1, movimientos_disponibles_peon);
            }
            if (this.Posicion.y === 6){
                let casillaAux = casillas[this.Posicion.x][this.Posicion.y - 1];
                if(casillaAux.getPieza() === null) {
                    casilla = casillas[this.Posicion.x][this.Posicion.y - 2];
                    if(casilla !== undefined && casilla !== null && casilla.getPieza() === null) {
                        this._agregarMovimiento(this.Posicion.x, this.Posicion.y - 2, movimientos_disponibles_peon);
                    }
                }
            }
        }
        
        if (this.color === "blancas"){
            // Movimiento diagonal izquierda con blancas
            if(this._esMovimientoValido(this.Posicion.x - 1, this.Posicion.y + 1)) {
                casilla = casillas[this.Posicion.x - 1][this.Posicion.y + 1];
                if (casilla !== undefined && casilla.getPieza() !== null && casilla.getPieza().getColor() !== this.color) {
                    this._agregarMovimiento(this.Posicion.x - 1, this.Posicion.y + 1, movimientos_disponibles_peon);
                }
            }
            // Movimiento diagonal derecha con blancas
            if(this._esMovimientoValido(this.Posicion.x + 1, this.Posicion.y + 1)) {
                casilla = casillas[this.Posicion.x + 1][this.Posicion.y + 1];
                if (casilla !== undefined && casilla.getPieza() !== null && casilla.getPieza().getColor() !== this.color) {
                    this._agregarMovimiento(this.Posicion.x + 1, this.Posicion.y + 1, movimientos_disponibles_peon);
                }
            }
        }
        else {
            // Movimiento diagonal derecha con negras
            if(this._esMovimientoValido(this.Posicion.x + 1, this.Posicion.y - 1)) {
                casilla = casillas[this.Posicion.x + 1][this.Posicion.y - 1];
                if (casilla !== undefined && casilla.getPieza() !== null && casilla.getPieza().getColor() !== this.color) {
                    this._agregarMovimiento(this.Posicion.x + 1, this.Posicion.y - 1, movimientos_disponibles_peon);
                }
            }
            // Movimiento diagonal izquierda con negras
            if(this._esMovimientoValido(this.Posicion.x - 1, this.Posicion.y - 1)) {
                casilla = casillas[this.Posicion.x - 1][this.Posicion.y - 1];
                if (casilla !== undefined && casilla.getPieza() !== null && casilla.getPieza().getColor() !== this.color) {
                    this._agregarMovimiento(this.Posicion.x - 1, this.Posicion.y - 1, movimientos_disponibles_peon);
                }
            }
        }

        return movimientos_disponibles_peon;
    }

    imprimirMovimientosDisponibles() {
        const movimientos = this.obtenerMovimientosDisponibles();
        console.log("Movimientos disponibles del peon:");
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
module.exports = Peon;