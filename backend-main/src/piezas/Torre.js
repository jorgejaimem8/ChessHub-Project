const Tablero = require('../Tablero.js'); // Asegúrate de importar correctamente Tablero.js
const Pieza = require('./Pieza.js')
class Torre {
    constructor(x, y, color, tablero, lado) {
        this.Posicion = {x, y};
        this.color = color;
        this.tablero = tablero;
        this.puntos = 5;
        this.lado = lado;
    }
    getLado(){
        return this.lado;
    }
    setLado(lado){
        this.lado = lado;
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
        let movimientos_disponibles_torre = [];

        // Eje +x
        this._agregarMovimientosEnEje(1, 0, movimientos_disponibles_torre, comprobarEstaPiezaProtegida);

        // Eje +y
        this._agregarMovimientosEnEje(0, 1, movimientos_disponibles_torre, comprobarEstaPiezaProtegida);

        // Eje -x
        this._agregarMovimientosEnEje(-1, 0, movimientos_disponibles_torre, comprobarEstaPiezaProtegida);

        // Eje -y
        this._agregarMovimientosEnEje(0, -1, movimientos_disponibles_torre, comprobarEstaPiezaProtegida);

        

        return movimientos_disponibles_torre;
    }

    imprimirMovimientosDisponibles() {
        const movimientos = this.obtenerMovimientosDisponibles();
        console.log("Movimientos disponibles de la torre:");
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
    _esMovimientoValido(x, y) {
        return x >= 0 && x < 8 && y >= 0 && y < 8;
    }
}
module.exports = Torre;