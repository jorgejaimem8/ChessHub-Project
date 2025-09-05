const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const http = require('http');
const { Server } = require("socket.io");
const pool = require('./config/db');

const session = require('express-session');
const pgSession = require('connect-pg-simple')(session);

const crypto = require('crypto');

const { spawn } = require('child_process');
const path = require('path');



const app = express();
app.use(cors());
app.use(bodyParser.json());



// Generate a random session secret
const sessionSecret = crypto.randomBytes(64).toString('hex');

// Configure session middleware
app.use(session({
  secret: sessionSecret,
  resave: false,
  saveUninitialized: false,
  store: new session.MemoryStore(), // Use memory-store for session storage
  cookie: { secure: false } // Set secure to true if using HTTPS
}));

// Crear un servidor HTTP utilizando Express
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ["GET", "POST"],
  },
  connectionStateRecovery: {
    // the backup duration of the sessions and the packets
    maxDisconnectionDuration: 2 * 60 * 1000,
    // whether to skip middlewares upon successful recovery
    skipMiddlewares: false
  }
});


/*const stockfishPath = path.join(__dirname, 'stockfish', 'stockfish-windows-x86-64-sse41-popcnt');

console.log('Ruta a Stockfish:', stockfishPath);

const stockfishProcess = spawn(stockfishPath);
stockfishProcess.stdin.setEncoding('utf-8');
stockfishProcess.stdout.setEncoding('utf-8');
stockfishProcess.stdin.write('uci\n');
stockfishProcess.stdin.write('isready\n');
stockfishProcess.stdin.write('ucinewgame\n');
stockfishProcess.stdin.write('position startpos\n');
stockfishProcess.stdin.write('go depth 5\n');


// Escuchar los eventos de salida estándar de Stockfish
stockfishProcess.stdout.on('data', (data) => {
  console.log(`Stockfish output: ${data}`);
  // Aquí puedes procesar la salida de Stockfish y extraer el mejor movimiento
  // Ejemplo: analizar la salida en busca del mejor movimiento y realizar acciones en consecuencia
});

// Escuchar los eventos de salida de errores de Stockfish
stockfishProcess.stderr.on('data', (data) => {
  console.error(`Stockfish error: ${data}`);
  // Aquí puedes manejar cualquier error que ocurra durante la comunicación con Stockfish
});

// Esperar a que Stockfish esté listo antes de enviar más comandos
stockfishProcess.stdout.on('data', (data) => {
  if (data.includes('readyok')) {
    console.log('Stockfish is ready');
    // Aquí puedes enviar más comandos a Stockfish, como "go depth 5" u otros comandos UCI
    stockfishProcess.stdin.write('go depth 5\n');
  }
});

// Consulta SQL para borrar la tabla Usuario
const dropTableUsuarioQuery = `
      DROP TABLE Miguel.Usuario CASCADE;
`;
*/
// Consulta SQL para crear la tabla Usuario
  const createTableUsuarioQuery = `
      CREATE TABLE IF NOT EXISTS Miguel.Usuario (
          Id SERIAL PRIMARY KEY,
          Nombre VARCHAR(100) NOT NULL,
          Contraseña VARCHAR(100) NOT NULL,
          CorreoElectronico VARCHAR(100) UNIQUE NOT NULL,
          EloBlitz INTEGER DEFAULT 1200,
          EloRapid INTEGER DEFAULT 1200,
          EloBullet INTEGER DEFAULT 1200,
          Victorias INTEGER DEFAULT 0,
          Derrotas INTEGER DEFAULT 0,
          Empates INTEGER DEFAULT 0,
          Arena VARCHAR(100) DEFAULT 'Madera',
          Avatar VARCHAR(100) DEFAULT '/static/media/wK.ae4879833ee0111ba3b20402a2a3fe81.svg',
          Color VARCHAR(100) DEFAULT 'orange',
          PuntosPase INTEGER DEFAULT 0,
          setPiezas VARCHAR(100) DEFAULT 'DEFECTO',
          emoticonos VARCHAR(100) DEFAULT '{\"😁\",\"😁\",\"😁\",\"😁\"}',
          nivelPase INTEGER DEFAULT 0
      )
  `;
// Consulta SQL para crear la tabla Recompensas
const createTableRecompensasQuery = `
CREATE TABLE IF NOT EXISTS Miguel.Recompensas (
Id SERIAL PRIMARY KEY,
Tipo VARCHAR(100) NOT NULL,
Descripcion TEXT
)
`;

// Consulta SQL para crear la tabla Partidas
const createTablePartidasQuery = `
CREATE TABLE IF NOT EXISTS Miguel.Partidas (
Id SERIAL PRIMARY KEY,
JugadorBlanco INTEGER,
JugadorNegro INTEGER,
FOREIGN KEY (JugadorBlanco) REFERENCES Miguel.Usuario(Id),
FOREIGN KEY (JugadorNegro) REFERENCES Miguel.Usuario(Id),
RitmoDeJuego VARCHAR(100),
Estado VARCHAR(100),
ModoJuego VARCHAR(100),
FechaHoraInicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FechaHoraFin TIMESTAMP
)
`;

// Consulta SQL para crear la tabla "posee"
const createTablePoseeQuery = `
CREATE TABLE IF NOT EXISTS Miguel.posee (
UsuarioId INTEGER REFERENCES Miguel.Usuario(Id),
RecompensaId INTEGER REFERENCES Miguel.Recompensas(Id),
PRIMARY KEY (UsuarioId, RecompensaId)
)
`;

const createTablePartidaAsincronaQuery = `
CREATE TABLE IF NOT EXISTS Miguel.PartidaAsincronaTableroDefi (
Id SERIAL PRIMARY KEY,
UsuarioBlancasId INTEGER REFERENCES Miguel.Usuario(Id),
UsuarioNegrasId INTEGER REFERENCES Miguel.Usuario(Id),
Tablero VARCHAR(65000)
)
`;


const createTableUsuarioTienePartidaAsincronaQuery = `
CREATE TABLE IF NOT EXISTS Miguel.UsuarioTienePartidaAsincrona (
UsuarioId INTEGER REFERENCES Miguel.Usuario(Id),
PartidaAsincronaId INTEGER REFERENCES Miguel.PartidaAsincrona(Id),
PRIMARY KEY (UsuarioId, PartidaAsincronaId)
)
`;



// Rutas de los usuarios
const userRouter = require("./routes/users")
app.use("/users", userRouter)

// Rutas para jugar
const playRouter = require("./routes/play")
app.use("/play", playRouter)

// Rutas para la página principal
const { disconnect } = require('process');




var games = []; // Utilizamos un array para almacenar las salas

io.on("connection", (socket) => {
  console.log(`User Connected: ${socket.id}`);
  socket.on('join_room', function ({ mode, elo, userId }) {
    console.log("buscando sala");
    // Buscar una sala libre con el modo de juego especificado
    let arena;
    if (elo < 1500) {
      arena='MADERA';
    }
    else if (elo < 1800) {
      arena='MARMOL';
    } 
    else if (elo < 2100) {
      arena='ORO';
    } 
    else if (elo < 2400) {
      arena='ESMERALDA';
    } 
    else if (elo > 2400) {
      arena='DIAMANTE';
    } 
    const room = games.find(room => room.mode === mode && room.players < 2 && arena === room.jugadorArena);

    if (room) {
      // Si se encuentra una sala libre, el jugador se une a ella
      room.players++;
      room.playersIds.push(socket.id); // sockets de los usuarios
      room.usersIds.push(userId); // ids de los usuarios
      socket.join((room.roomId).toString());
      
      room.playersIds.forEach((playerId) => {
        io.to(playerId).emit("match_found");
      });
      // Con el siguiente timeOut, permitimos a los jugadores cancelar la partida durante un periodo de 5 segundos
      room.timeOutId = setTimeout(() => { // Da cierto tiempo para poder cancelar la partida
        console.log("room: ",room)
        room.playersIds.forEach((playerId) => {
          const playerColor = playerId === socket.id ? 'white' : 'black'; // Asignar colores de manera diferente
          const id = playerId === socket.id ? room.usersIds[0] : room.usersIds[1];
          io.to(playerId).emit('game_ready', { roomId: room.roomId, color: playerColor, mode, opponent: id});
          console.log("a jugar", room.roomId)
        });
      }, 5000); // 5000 milisegundos = 5 segundos
    } else {
      // Si no se encuentra una sala libre, se crea una nueva sala
      const roomId = Math.floor(Math.random() * 100000); // Generar un ID de sala aleatorio
      games.push({ roomId, mode, players: 1, playersIds: [socket.id], usersIds:[userId], elo, jugadorArena:arena});
      socket.join(roomId.toString()); // Convertir el ID de la sala a cadena antes de unirse
      socket.emit('room_created', { roomId, mode, color: 'white' });
    }
  });

  socket.on("send_message", (data) => {
    socket.to(data.room).emit("receive_message", data);
  });
  socket.on("move", (data) => {
    console.log("ha movido")
    socket.to(data.roomId).emit("movido", data.tableroEnviar)
  })
  socket.on('chat message', (data) => { // Se recibe un menaje enviado por otro usuario
    console.log(data)
    socket.to(data.roomId).emit('chat message', {body:data.body,from:data.from} )
  });
  socket.on("cancel_search", ({ mode }) => { // Si se cancela la busqueda, se elimina la sala creada
    console.log(`cancel search: ${socket.id}`);
    const room = games.find(room => room.mode === mode && room.players < 2 );
    games.splice(games.indexOf(room),1);
  });
  socket.on("cancel_match", () => { // Si ya se había encontrado partida, se cancela
    console.log(`Game canceled by: ${socket.id}`);

    for (let i = 0; i < games.length; i++) {
      const room = games[i];
      const playerIndex = room.playersIds.indexOf(socket.id);
      if (playerIndex !== -1) {
        clearTimeout(room.timeOutId); // Limpia el timeout de comienzo de la partida
        room.playersIds.splice(playerIndex, 1);
        room.players--;
        const remainingPlayerId = room.playersIds[0]; // Avisa al otro jugador de la cancelación de la partida
        io.to(remainingPlayerId).emit("match_canceled");
        games.splice(i, 1); // Remove the room from the games array
            break;
      }
    }
  });
  socket.on("I_surrender", ({ roomId }) => {
    console.log(`User ${socket.id} surrendered from room ${roomId}`);
    for (let i = 0; i < games.length; i++) {
      const room = games[i];
      const playerIndex = room.playersIds.indexOf(socket.id);
      if (playerIndex !== -1) {
        room.playersIds.splice(playerIndex, 1);
        room.players--;

        const remainingPlayerId = room.playersIds[0]; // Avisa al otro jugador
        io.to(remainingPlayerId).emit("oponent_surrendered");
        games.splice(i, 1); // Remove the room from the games array
            break;
      }
    }
  });
  socket.on("Gano_partida", ({ roomId, cause }) => {
    console.log(`User ${socket.id} gano from room ${roomId}`);
    for (let i = 0; i < games.length; i++) {
      const room = games[i];
      const playerIndex = room.playersIds.indexOf(socket.id);
      if (playerIndex !== -1) {
        room.playersIds.splice(playerIndex, 1);
        room.players--;

        const remainingPlayerId = room.playersIds[0]; // Avisa al otro jugador
        io.to(remainingPlayerId).emit("has_perdido", {cause});
        games.splice(i, 1); // Remove the room from the games array
            break;
      }
    }
  });
  socket.on("empato_partida", ({ roomId, cause }) => {
    console.log(`User ${socket.id} gano from room ${roomId}`);
    for (let i = 0; i < games.length; i++) {
      const room = games[i];
      const playerIndex = room.playersIds.indexOf(socket.id);
      if (playerIndex !== -1) {
        room.playersIds.splice(playerIndex, 1);
        room.players--;

        const remainingPlayerId = room.playersIds[0]; // Avisa al otro jugador
        io.to(remainingPlayerId).emit("has_empatado", {cause});
        games.splice(i, 1); // Remove the room from the games array
            break;
      }
    }
  });
  socket.on("time_expired", () => {
    for (let i = 0; i < games.length; i++) {
      const room = games[i];
      const playerIndex = room.playersIds.indexOf(socket.id);
      if (playerIndex !== -1) {
        room.playersIds.splice(playerIndex, 1);
        room.players--;
        games.splice(i, 1); // Remove the room from the games array
            break;
      }
    }
  })
  // Sincronización de temporizadores con el otro jugador
  socket.on("sync_timers", ({minutes2, seconds2}) => {
    for (let i = 0; i < games.length; i++) {
      const room = games[i];
      const playerIndex = room.playersIds.indexOf(socket.id);

      if (playerIndex !== -1) {
        const remainingPlayerId = (playerIndex+1)%2;
        io.to(room.playersIds[remainingPlayerId]).emit("value_timers",({minutos : minutes2,segundos : seconds2}));
        break;
      }
    }
  })
  socket.on("disconnect", () => { // Un jugador se desconecta
    for (let i = 0; i < games.length; i++) {
      const room = games[i];
      const playerIndex = room.playersIds.indexOf(socket.id);
      if (playerIndex !== -1) {
        // Player found in this room
        console.log(`User ${socket.id} disconnected from room ${room.roomId}`);
        // Perform any necessary actions, such as removing the player from the room
        room.playersIds.splice(playerIndex, 1);
        room.players--;

        // If there are no more players in the room, you might want to clean up the room
        if (room.players === 0) {
            games.splice(i, 1); // Remove the room from the games array
                }
        else { // Notificar al jugador de que ha ganado la partida (el otro ha abandonado)
          const remainingPlayerId = room.playersIds[0];
          io.to(remainingPlayerId).emit("player_disconnected");
          games.splice(i, 1); // Remove the room from the games array
        }
        break; // No need to continue searching
      }
    }
  })
});

module.exports = server;