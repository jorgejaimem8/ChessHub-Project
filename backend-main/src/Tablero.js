const Casilla = require('./Casilla.js');
const Dama = require('./piezas/Dama.js');
const Peon = require('./piezas/Peon.js');
const Alfil = require('./piezas/Alfil.js');
const Caballo = require('./piezas/Caballo.js');
const Rey = require('./piezas/Rey.js');
const Torre = require('./piezas/Torre.js');
const Pieza = require('./piezas/Pieza.js');

class Tablero {
    constructor() {
        this.N = 8;
        this.M = 8;
        this.casillas = [];

        for (let i = 0; i < this.N; i++){
            this.casillas[i] = [];
            for (let j = 0; j < this.M; j++){
                this.casillas[i][j] = new Casilla();
            }
        }

    }

    getCasillas(){
        return this.casillas;
    }

    setCasillas(casillas){
        this.casillas = casillas;
    }
    inicializarPiezas() {
        const peon_1_b = new Peon(0, 1, "blanca");
        const peon_2_b = new Peon(1, 1, "blanca");
        const peon_3_b = new Peon(2, 1, "blanca");
        const peon_4_b = new Peon(3, 1, "blanca");
        const peon_5_b = new Peon(4, 1, "blanca");
        const peon_6_b = new Peon(5, 1, "blanca");
        const peon_7_b = new Peon(6, 1, "blanca");
        const peon_8_b = new Peon(7, 1, "blanca");

        const alfil_de_negras_b = new Alfil(2, 0, "blanca");
        const alfil_de_blancas_b = new Alfil(5, 0, "blanca");

        const caballo_izqda_b = new Caballo(1, 0, "blanca");
        const caballo_dcha_b = new Caballo(6, 0, "blanca");

        const torre_dcha_b = new Torre(0, 0, "blanca", "derecha");
        const torre_izqda_b = new Torre(7, 0, "blanca", "izquierda");

        const dama_b = new Dama(3, 0, "blanca");

        const rey_b = new Rey(4, 0, "blanca");

        // Inicialización de negras
        const peon_1_n = new Peon(0, 6, "negra");
        const peon_2_n = new Peon(1, 6, "negra");
        const peon_3_n = new Peon(2, 6, "negra");
        const peon_4_n = new Peon(3, 6, "negra");
        const peon_5_n = new Peon(4, 6, "negra");
        const peon_6_n = new Peon(5, 6, "negra");
        const peon_7_n = new Peon(6, 6, "negra");
        const peon_8_n = new Peon(7, 6, "negra");

        const alfil_de_negras_n = new Alfil(2, 7, "negra");
        const alfil_de_blancas_n = new Alfil(5, 7, "negra");

        const caballo_izqda_n = new Caballo(1, 7, "negra");
        const caballo_dcha_n = new Caballo(6, 7, "negra");

        const torre_dcha_n = new Torre(0, 7, "negra", "derecha");
        const torre_izqda_n = new Torre(7, 7, "negra", "izquierda");

        const dama_n = new Dama(3, 7, "negra");

        const rey_n = new Rey(4, 7, "negra");

        const chessboardState = {
            peon: [
                { x: peon_1_b.Posicion.x, y: peon_1_b.Posicion.y, color: peon_1_b.color },
                { x: peon_2_b.Posicion.x, y: peon_2_b.Posicion.y, color: peon_2_b.color },
                { x: peon_3_b.Posicion.x, y: peon_3_b.Posicion.y, color: peon_3_b.color },
                { x: peon_4_b.Posicion.x, y: peon_4_b.Posicion.y, color: peon_4_b.color },
                { x: peon_5_b.Posicion.x, y: peon_5_b.Posicion.y, color: peon_5_b.color },
                { x: peon_6_b.Posicion.x, y: peon_6_b.Posicion.y, color: peon_6_b.color },
                { x: peon_7_b.Posicion.x, y: peon_7_b.Posicion.y, color: peon_7_b.color },
                { x: peon_8_b.Posicion.x, y: peon_8_b.Posicion.y, color:peon_8_b.color },

                { x: peon_1_n.Posicion.x, y: peon_1_n.Posicion.y, color: peon_1_n.color },
                { x: peon_2_n.Posicion.x, y: peon_2_n.Posicion.y, color: peon_2_n.color },
                { x: peon_3_n.Posicion.x, y: peon_3_n.Posicion.y, color: peon_3_n.color },
                { x: peon_4_n.Posicion.x, y: peon_4_n.Posicion.y, color: peon_4_n.color },
                { x: peon_5_n.Posicion.x, y: peon_5_n.Posicion.y, color: peon_5_n.color },
                { x: peon_6_n.Posicion.x, y: peon_6_n.Posicion.y, color: peon_6_n.color },
                { x: peon_7_n.Posicion.x, y: peon_7_n.Posicion.y, color: peon_7_n.color },
                { x: peon_8_n.Posicion.x, y: peon_8_n.Posicion.y, color:peon_8_n.color }
            ],
            alfil: [
                { x: alfil_de_negras_b.Posicion.x, y: alfil_de_negras_b.Posicion.y, color: alfil_de_negras_b.color },
                { x: alfil_de_blancas_b.Posicion.x, y: alfil_de_blancas_b.Posicion.y, color: alfil_de_blancas_b.color },

                { x: alfil_de_negras_n.Posicion.x, y: alfil_de_negras_n.Posicion.y, color: alfil_de_negras_n.color },
                { x: alfil_de_blancas_n.Posicion.x, y: alfil_de_blancas_n.Posicion.y, color: alfil_de_blancas_n.color }
            ],
            caballo: [
                { x: caballo_izqda_b.Posicion.x, y: caballo_izqda_b.Posicion.y, color: caballo_izqda_b.color },
                { x: caballo_dcha_b.Posicion.x, y: caballo_dcha_b.Posicion.y, color: caballo_dcha_b.color },

                { x: caballo_izqda_n.Posicion.x, y: caballo_izqda_n.Posicion.y, color: caballo_izqda_n.color },
                { x: caballo_dcha_n.Posicion.x, y: caballo_dcha_n.Posicion.y, color: caballo_dcha_n.color }
            ],
            torre: [
                { x: torre_dcha_b.Posicion.x, y: torre_dcha_b.Posicion.y, color: torre_dcha_b.color , lado: torre_dcha_b.lado},
                { x: torre_izqda_b.Posicion.x, y: torre_izqda_b.Posicion.y, color: torre_izqda_b.color,lado: torre_izqda_b.lado },

                { x: torre_dcha_n.Posicion.x, y: torre_dcha_n.Posicion.y, color: torre_dcha_n.color, lado: torre_dcha_n.lado },
                { x: torre_izqda_n.Posicion.x, y: torre_izqda_n.Posicion.y, color: torre_izqda_n.color, lado: torre_izqda_n.lado }
            ],
            dama: [
                { x: dama_b.Posicion.x, y: dama_b.Posicion.y, color: dama_b.color },
                { x: dama_n.Posicion.x, y: dama_n.Posicion.y, color: dama_n.color }
            ],
            rey: [
                { x: rey_b.Posicion.x, y: rey_b.Posicion.y, color: rey_b.color },
                { x: rey_n.Posicion.x, y: rey_n.Posicion.y, color: rey_n.color }
            ]
        };
        return chessboardState;
    }

    actualizarTablero(chessboardState) {
        for (const tipo_pieza in chessboardState) {
            if(tipo_pieza !== "turno" && tipo_pieza !== "IA") {
                if (chessboardState.hasOwnProperty(tipo_pieza)) {
                    const piezas = chessboardState[tipo_pieza];
                    for (let i = 0; i < piezas.length; i++) {
                        const pieza = piezas[i];
                        const {x, y, color, lado} = pieza;
                        let objeto_pieza = this.createPiece(tipo_pieza, x, y, color,lado);
                        this.casillas[x][y].setPieza(objeto_pieza);
                    }
                }
            }
        }

    }
    
    createPiece(tipo_pieza, x, y, color, lado) {
        switch (tipo_pieza) {
            case 'peon':
                return new Peon(x, y, color, this);
            case 'alfil':
                return new Alfil(x, y, color, this);
            case 'caballo':
                return new Caballo(x, y, color, this);
            case 'torre':
                return new Torre(x, y, color, this, lado);
            case 'dama':
                return new Dama(x, y, color, this);
            case 'rey':
                return new Rey(x, y, color, this);
            default:
                return null;
        }
    }
    
    eliminarPieza(x, y) {
        const casilla = this.tablero.getCasillas()[x][y];
        if (casilla !== null && casilla.getPieza() !== null) {
            const piezaEliminada = casilla.getPieza();
            casilla.setPieza(null);
            return piezaEliminada;
        } else {
            return null; // No hay pieza en la casilla especificada
        }
    }
    

    mostrarTablero() {
        for (let i = 0; i < this.N; i++) {
            for (let j = 0; j < this.M; j++) {
                const casilla = this.casillas[i][j];
                if(casilla.getPieza() != null) {
                    console.log(`[${i}, ${j}]: ${casilla.getPieza().getClassName()} ${casilla.getPieza().color}`);
                }
            }
        }
    }
}
module.exports = Tablero;