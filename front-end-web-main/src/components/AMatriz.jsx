function AMatriz({ jsonData }) {
  // Extraer solo las piezas de ajedrez del objeto jsonData
  const { has_perdido, has_empatado, turno, piezaCoronada,ha_movido_rey_blanco, ha_movido_rey_negro, ha_movido_torre_blanca_dcha, ha_movido_torre_blanca_izqda, ha_movido_torre_negra_dcha, ha_movido_torre_negra_izqda, ...piezas } = jsonData;
  
  const matriz = [];
  for (let i = 0; i < 8; i++) {
    matriz.push(Array(8).fill(''));
  }

  // Función para obtener el símbolo de la pieza
  const getPieceSymbol = (color, tipo) => {
    let symbol = '';
    if (tipo === 'peon') {
      symbol = color === 'negras' ? 'p' : 'P';
    }else if(tipo === 'alfil') {
      symbol = color === 'negras' ? 'b' : 'B';
    }else if(tipo === 'caballo') {
      symbol = color === 'negras' ? 'n' : 'N';
    }else if(tipo === 'dama') {
      symbol = color === 'negras' ? 'q' : 'Q';
    }else if(tipo === 'torre') {
      symbol = color === 'negras' ? 'r' : 'R';
    }else if(tipo === 'rey') {
      symbol = color === 'negras' ? 'k' : 'K';
    }

    return symbol;
  };

  // Colocar las piezas en la matriz
  for (const tipo in piezas) {
    piezas[tipo].forEach(pieza => {
      const { x, y, color } = pieza;
      matriz[7-y][x] = getPieceSymbol(color, tipo);
      // matriz[y][x] = getPieceSymbol(color, tipo);
    });
  }

  return matriz;
}

export default AMatriz;


