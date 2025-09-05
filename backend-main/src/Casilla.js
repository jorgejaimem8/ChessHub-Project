const Pieza = require('./piezas/Pieza');


class Casilla {
    constructor() {
        this.color = true;
        this.pieza = null; // La pieza es inicialmente nula, puedes establecerla después
        this.lado = true;
    }
    
    getColor() {
        return this.color;
    }
    
    setColor(color) {
        this.color = color;
    }
    
    getPieza() {
        return this.pieza;
    }
    
    setPieza(pieza) {
        this.pieza = pieza;
    }
    
    isFilled() {
        
    }
}

module.exports = Casilla;

