
class Pieza {
    constructor(x, y) {
        this.color = color;
        this.posicion = {x, y};
    }

    getColor() {
        return this.color;
    }

    setColor(color) {
        this.color = color;
    }

    getPosicion() {
        return this.posicion;
    }

    setPosicion(posicion) {
        this.posicion = posicion;
    }

    piezasDelMismoColor(tablero) {
        let piezasDelMismoColor = Array.from( { length: 8}, () => Array(8).fill(false));
        for (let i = 0; i < 8; i++) {
            for (let j = 0; j < 8; j++) {
                if (tablero.getCasillas()[i][j].getPieza().getColor() == this.equipo && !(tablero.getCasillas()[i][j].getPieza() instanceof Vacia))
                    piezasDelMismoColor[i][j] = true;
            }
        }
        return piezasDelMismoColor;
    }

    piezasDeOtroColor(tablero) {
        let piezasDelEquipoContrario = Array.from({ length: 8 }, () => Array(8).fill(false));
        for (let i = 0; i < 8; i++) {
            for (let j = 0; j < 8; j++) {
                if (tablero.getCasillas()[i][j].getPieza().isEquipo() != this.equipo && !(tablero.getCasillas()[i][j].getPieza() instanceof NoPieza))
                    piezasDelEquipoContrario[i][j] = true;
            }
        }
        return piezasDelEquipoContrario;
    }
}

module.exports = Pieza;