const Tablero = require('../Tablero.js'); // Asegúrate de importar correctamente Tablero.js
const Pieza = require('./Pieza.js'); // Asegúrate de importar correctamente Pieza.js
//const Posicion = require('./Posicion.js'); // Asegúrate de importar correctamente Posicion.js

class Dama {
    constructor(x, y, color, tablero) {
        this.Posicion = { x, y };
        this.color = color;
        this.tablero = tablero;
        this.puntos = 9;
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

    obtenerMovimientosDisponibles(comprobarEstaPiezaProtegida) {
        let movimientos_disponibles_dama = [];
        // Eje +x
        this._agregarMovimientosEnEje(1, 0, movimientos_disponibles_dama, comprobarEstaPiezaProtegida);

        // Eje +y
        this._agregarMovimientosEnEje(0, 1, movimientos_disponibles_dama, comprobarEstaPiezaProtegida);

        // Eje -x
        this._agregarMovimientosEnEje(-1, 0, movimientos_disponibles_dama, comprobarEstaPiezaProtegida);

        // Eje -y
        this._agregarMovimientosEnEje(0, -1, movimientos_disponibles_dama, comprobarEstaPiezaProtegida);

        this._agregarMovimientosEnDiagonal(1, 1, movimientos_disponibles_dama, comprobarEstaPiezaProtegida); // Diagonal +
        this._agregarMovimientosEnDiagonal(1, -1, movimientos_disponibles_dama, comprobarEstaPiezaProtegida); // Diagonal -
        this._agregarMovimientosEnDiagonal(-1, 1, movimientos_disponibles_dama, comprobarEstaPiezaProtegida); // Diagonal -
        this._agregarMovimientosEnDiagonal(-1, -1, movimientos_disponibles_dama, comprobarEstaPiezaProtegida); // Diagonal +
        
        return movimientos_disponibles_dama;
    }

    imprimirMovimientosDisponibles() {
        const movimientos = this.obtenerMovimientosDisponibles();
        console.log("Movimientos disponibles de la dama:");
        movimientos.forEach(movimiento => {
            console.log(`(${movimiento.x}, ${movimiento.y})`);
        });
    }
    _agregarMovimientosEnEje(deltaX, deltaY, movimientos, comprobarEstaPiezaProtegida) {
        let k = 1;
        while (this._esMovimientoValido(this.Posicion.x + k * deltaX, this.Posicion.y + k * deltaY)) {
            const x = this.Posicion.x + k * deltaX;
            const y = this.Posicion.y + k * deltaY;

            const casilla = this.tablero.getCasillas()[x][y];

            if (casilla !== undefined && casilla !== null) {
                if (casilla.getPieza() === null) {
                    movimientos.push({ x, y });
                } else {
                    if (comprobarEstaPiezaProtegida){
                        movimientos.push({x, y});
                    }
                    else {
                        if (casilla.getPieza().getColor() !== this.color) {
                            movimientos.push({ x, y});
                        }
                    }
                    break;
                }
            }

            k++;
        }
    }

    _agregarMovimientosEnDiagonal(deltaX, deltaY, movimientos, comprobarEstaPiezaProtegida) {
        let k = 1;
        while (this._esMovimientoValido(this.Posicion.x + k * deltaX, this.Posicion.y + k * deltaY)) {
            const x = this.Posicion.x + k * deltaX;
            const y = this.Posicion.y + k * deltaY;

            const casilla = this.tablero.getCasillas()[x][y];

            if (casilla !== undefined && casilla !== null) {
                if (casilla.getPieza() === null) {
                    movimientos.push({ x, y });
                } else {
                    if (comprobarEstaPiezaProtegida){
                        movimientos.push({x, y});
                    }
                    else {
                        if (casilla.getPieza().getColor() !== this.color) {
                            movimientos.push({ x, y});
                        }
                    }
                    break;
                }
            }

            k++;
        }
    }

    _esMovimientoValido(x, y) {
        return x >= 0 && x < 8 && y >= 0 && y < 8;
    }
}
module.exports = Dama;