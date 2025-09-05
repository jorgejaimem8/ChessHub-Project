const express = require("express")
const pool = require('../config/db');
const bcrypt = require('bcrypt');
const router = express.Router();


// Ruta /users/all, con la lista de todos los usuarios
router.get("/all", async (req, res) => {
    let client;
    try {
        client = await pool.connect();  // Importante conectarse a la pool para peticiones GET
        console.log('Connected to the database');
        const selectAllUsersQuery = `
            SELECT * FROM Miguel.Usuario
        `;
        const result = await client.query(selectAllUsersQuery);
        res.status(200).json(result.rows); // Send the rows fetched from the database as JSON response
    } catch (error) {
        console.error('Error al obtener usuarios:', error);
        res.status(500).json({ message: "Error al obtener usuarios" });
    } finally {
        if (client) {
            client.release();
            console.log('Connection released');
        }
    }
});



// Ruta /users/all_asignaciones, con la lista de todos los usuarios
router.get("/all_asignaciones", async (req, res) => {
    let client;
    try {
        client = await pool.connect(); // Important to connect to the pool for GET requests
        console.log('Connected to the database');
        
        // SQL query to select all assignments from the Posee table
        const selectAllAsignacionesQuery = `
            SELECT * FROM Miguel.Posee
        `;
        
        // Execute the query to select all assignments
        const result = await client.query(selectAllAsignacionesQuery);
        
        // Send the rows fetched from the database as JSON response
        res.status(200).json(result.rows);
    } catch (error) {
        console.error('Error al obtener todas las asignaciones usuarios-recompensas:', error);
        res.status(500).json({ message: "Error al obtener todas las asignaciones usuarios-recompensas" });
    } finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});


// Ruta /users/all_recompensas, con la lista de todos los usuarios
router.get("/all_recompensas", async (req, res) => {
    let client;
    try {
        client = await pool.connect(); // Important to connect to the pool for GET requests
        console.log('Connected to the database');
        
        // SQL query to select all rewards from the Recompensas table
        const selectAllRewardsQuery = `
            SELECT * FROM Miguel.Recompensas
        `;
        
        // Execute the query to select all rewards
        const result = await client.query(selectAllRewardsQuery);
        
        // Send the rows fetched from the database as JSON response
        res.status(200).json(result.rows);
    } catch (error) {
        console.error('Error al obtener todas las recompensas:', error);
        res.status(500).json({ message: "Error al obtener todas las recompensas" });
    } finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});


// Route /users/login to log in a user
router.post("/login", async (req, res) => {
    // Get user credentials from the request body
    const { nombre, contraseña } = req.body;

    try {
        client = await pool.connect();
        // Query to fetch user data based on username
        const getUserQuery = `
            SELECT id, nombre, contraseña
            FROM Miguel.Usuario
            WHERE nombre = $1
        `;

        // Execute the query to fetch user data
        const { rows } = await client.query(getUserQuery, [nombre]);

        // If no user found with the provided username
        if (rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        const user = rows[0];

        // Check if the provided password matches the hashed password stored in the database
        const isPasswordMatch = await bcrypt.compare(contraseña, user.contraseña);

        if (!isPasswordMatch) {
            return res.status(401).json({ message: "Credenciales inválidas" });
        }

        // If password matches, create a session for the user
        req.session.userId = user.id;

        // Return success message along with user ID
        res.status(200).json({ message: "Inicio de sesión exitoso", userId: user.id });
    } catch (error) {
        console.error('Error al iniciar sesión:', error);
        res.status(500).json({ message: "Error al iniciar sesión" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});




// Ruta /users/register, para registrar un nuevo usuario
router.post("/register", async (req, res) => {
    // Obtener los datos del usuario desde el cuerpo de la solicitud
    const { nombre, contraseña, correoElectronico, victorias, empates, derrotas} = req.body;

    try {

        client = await pool.connect();
        // Generar un hash de la contraseña utilizando bcrypt
        const hashedPassword = await bcrypt.hash(contraseña, 8);

        // Consulta SQL para insertar un nuevo usuario en la tabla Usuario
        const insertUserQuery = `
            INSERT INTO Miguel.Usuario (nombre, contraseña, correoElectronico, victorias, empates, derrotas)
            VALUES ($1, $2, $3, $4, $5, $6)
        `;

        // Parámetros para la consulta SQL
        const values = [nombre, hashedPassword, correoElectronico, victorias, empates, derrotas];

        // Ejecutar la consulta para insertar el nuevo usuario
        await client.query(insertUserQuery, values);
        
        console.log('Usuario registrado exitosamente');
        res.status(200).json({ message: "Registro exitoso" });
    } catch (error) {
        console.error('Error al registrar un nuevo usuario:', error);
        res.status(500).json({ message: "Error al registrar un nuevo usuario" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});
router.post("/actualizar-elo/:userId/:mode", async (req, res) => {
    const userId = req.params.userId;
    const mode = req.params.mode;
    const newElo = req.body.newElo;

    try {
        let eloColumn;
        switch (mode) {
            case 'blitz':
                eloColumn = 'eloblitz';
                break;
            case 'bullet':
                eloColumn = 'elobullet';
                break;
            case 'rapid':
                eloColumn = 'elorapid';
                break;
            default:
                return res.status(400).json({ message: "Modo de juego no válido" });
        }

        // Query to update the Elo of the user in the specified mode
        const updateEloQuery = `
            UPDATE Miguel.Usuario
            SET ${eloColumn} = $1
            WHERE id = $2
        `;

        // Execute the query to update the Elo
        await pool.query(updateEloQuery, [newElo, userId]);

        res.status(200).json({ message: "Elo actualizado exitosamente" });
    } catch (error) {
        console.error('Error al actualizar el Elo:', error);
        res.status(500).json({ message: "Error al actualizar el Elo" });
    }
});

// Ruta /play/register_partida_asincrona, para que el usuario pueda elegir si jugar bullet, blitz o rapid
router.post("/register_partida_asincrona", async (req, res) => {
    // Crear nueva fila en la tabla PartidaAsincrona (sin tablero actual ni turno)

    let idUsuarioBlancas = req.body.usuarioBlancas;
    let idUsuarioNegras = req.body.usuarioNegras;

    console.log('Usuario blancas:', idUsuarioBlancas);
    console.log('Usuario negras:', idUsuarioNegras);

    try {
        client = await pool.connect();
        const registrarPartida = `
            INSERT INTO Miguel.PartidaAsincronaTableroDefi (UsuarioBlancasId, UsuarioNegrasId)
            VALUES ($1, $2)
            RETURNING id;
        `;

        const { rows } = await client.query(registrarPartida, [idUsuarioBlancas, idUsuarioNegras]);
        console.log('Partida asíncrona registrada exitosamente');
        const nuevaPartidaId = rows[0].id; // Obtener el ID de la nueva partida desde el resultado de la consulta
        res.status(200).json({ id: nuevaPartidaId, message: "Partida asíncrona registrada exitosamente" });
    }
    catch (error) {
        console.error('Error al registrar una nueva partida asincrona:', error);
        res.status(500).json({ message: "Error al registrar una nueva partida asincrona" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});


// Ruta /users/remove_partida_asincrona, para que el usuario pueda elegir si jugar bullet, blitz o rapid
router.post("/remove_partida_asincrona/:id_partida", async (req, res) => {

    const idPartida = req.params.id_partida;

    console.log('Id de la partida a borrar:', idPartida);
    const client = await pool.connect();
    try {
        const deletePartidaQuery = `
        DELETE FROM Miguel.PartidaAsincronaTableroDefi
        WHERE Id = $1
    `;

        

        await client.query("BEGIN");

        await client.query(deletePartidaQuery, [idPartida]);

        await client.query("COMMIT");



        console.log('Partida asíncrona borrada exitosamente');
        res.status(200).json({ message: "Partida asíncrona borrada exitosamente" });
    }
    catch (error) {
        console.error('Error al eliminar la nueva partida asincrona:', error);
        res.status(500).json({ message: "Error al eliminar lapartida asincrona" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});

// Ruta /users/remove_partida_asincrona, para que el usuario pueda elegir si jugar bullet, blitz o rapid
router.get("/get_partida_asincrona/:id_partida", async (req, res) => {

    const idPartida = req.params.id_partida;


    try {
        const selectPartidaQuery = `
        SELECT * FROM Miguel.PartidaAsincronaTableroDefi
        WHERE Id = $1
    `;

        const client = await pool.connect();

        await client.query("BEGIN");

        const result = await client.query(selectPartidaQuery, [idPartida]);


        await client.query("COMMIT");

        client.release();


        console.log('Partida asíncrona obtenida exitosamente');
        res.status(200).json(result.rows);
    }
    catch (error) {
        console.error('Error al obtener la nueva partida asincrona:', error);
        res.status(500).json({ message: "Error al obtener la partida asincrona" });
    }
});

router.post("/update_cambio_partida_asincrona/:id_partida", async (req, res) => {
    // Seleccionar la partida en la que actualizar el tablero
    const idPartida = req.params.id_partida;
    const { tablero_actual } = req.body; // Obtener el tablero actual del cuerpo de la solicitud
    const client = await pool.connect();
    try {
        
        const updatePartidaQuery = `
            UPDATE Miguel.PartidaAsincronaTableroDefi
            SET Tablero = $1
            WHERE Id = $2
        `;

        // Ejecutar la consulta para actualizar el tablero con el nuevo tablero_actual
        await client.query(updatePartidaQuery, [tablero_actual, idPartida]);

        // Enviar una respuesta exitosa
        res.status(200).json({ message: "Tablero actualizado exitosamente" });
    } catch (error) {
        console.error('Error al actualizar el tablero:', error);
        res.status(500).json({ message: "Error al actualizar el tablero" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});


// Ruta /users/get_partidas_asincronas/:id_user, para que el usuario pueda elegir si jugar bullet, blitz o rapid
router.get("/get_partidas_asincronas/:id_user", async (req, res) => {
    let client;
    const idUsuario = req.params.id_user;
    try {
        client = await pool.connect(); // Important to connect to the pool for GET requests
        
        // SQL query to select all asynchronous matches from the PartidaAsincronaTablero table
        const selectAllPartidasAsincronasQuery = `
            SELECT * FROM Miguel.PartidaAsincronaTableroDefi WHERE UsuarioBlancasId = $1 OR UsuarioNegrasId = $1
        `;
        
        // Execute the query to select all asynchronous matches
        const result = await client.query(selectAllPartidasAsincronasQuery, [idUsuario]);
        
        // Send the rows fetched from the database as JSON response
        res.status(200).json(result.rows);
    } catch (error) {
        console.error('Error al obtener las partidas asíncronas del usuario:', error);
        res.status(500).json({ message: "Error al obtener las partidas asíncronas del usuario" });
    } finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});

// Ruta /users/all_partidas_asincronas, para que el usuario pueda elegir si jugar bullet, blitz o rapid
router.get("/all_partidas_asincronas", async (req, res) => {
    let client;
    try {
        client = await pool.connect(); // Important to connect to the pool for GET requests
        console.log('Connected to the database');
        
        // SQL query to select all asynchronous matches from the PartidaAsincronaTablero table
        const selectAllPartidasAsincronasQuery = `
            SELECT * FROM Miguel.PartidaAsincronaTableroDefi
        `;
        
        // Execute the query to select all asynchronous matches
        const result = await client.query(selectAllPartidasAsincronasQuery);
        
        // Send the rows fetched from the database as JSON response
        res.status(200).json(result.rows);
    } catch (error) {
        console.error('Error al obtener todas las partidas asincronas:', error);
        res.status(500).json({ message: "Error al obtener todas las partidas asincronas" });
    } finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});

  

// Ruta /users/register_recompensa, para registrar una nueva recompensa
router.post("/register_recompensa", async (req, res) => {
    // Obtener los datos de la recompensa desde el cuerpo de la solicitud
    const { tipo, descripcion } = req.body;
    const client = await pool.connect();
    try {
        // Consulta SQL para insertar una nueva recompensa en la tabla Recompensas
        const insertRewardQuery = `
            INSERT INTO Miguel.Recompensas (Tipo, Descripcion)
            VALUES ($1, $2)
        `;

        // Parámetros para la consulta SQL
        const values = [tipo, descripcion];

        // Ejecutar la consulta para insertar la nueva recompensa
        await client.query(insertRewardQuery, values);
        
        console.log('Recompensa registrada exitosamente');
        res.status(200).json({ message: "Recompensa registrada exitosamente" });
    } catch (error) {
        console.error('Error al registrar una nueva recompensa:', error);
        res.status(500).json({ message: "Error al registrar una nueva recompensa" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});



// Route /users/logout to log out a user
router.post("/logout", (req, res) => {
    
    try {
        // Destroy the user's session
        req.session.destroy((err) => {
            if (err) {
                console.error('Error al cerrar sesión:', err);
                return res.status(500).json({ message: "Error al cerrar sesión" });
            }
            // Session destroyed successfully
            res.status(200).json({ message: "Sesión cerrada exitosamente" });
        });
    } catch (error) {
        console.error('Error al cerrar sesión:', error);
        res.status(500).json({ message: "Error al cerrar sesión" });
    }
    
});

// Route /users/update_recompensa/:id_usuario/:id_recompensa
router.put("/update_recompensa/:id_usuario/:id_recompensa", async (req, res) => {
    const userId = req.params.id_usuario; // Corrected parameter name
    const rewardId = req.params.id_recompensa; // Corrected parameter name
    const client = await pool.connect();
        try {
            
            const insertIntoPoseeQuery = `
            INSERT INTO Miguel.posee (UsuarioId, RecompensaId)
            VALUES ($1, $2)
        `;
            
        await client.query(insertIntoPoseeQuery, [userId, rewardId]);

            res.status(200).json({ message: "Recompensa asignada exitosamente" });
        } catch (error) {
            console.error('Error al asignar la recomepnsa:', error);
            res.status(500).json({ message: "Error al asignar la recompensa" });
        }
        finally {
            if (client) {
                client.release(); // Release the client back to the pool
                console.log('Connection released');
            }
        }
});

// Route /users/:id
router.route("/:id")
    // Obtener info de un usuario en concreto (perfil)
    .get(async (req, res) => {
        const userId = req.params.id;

        try {
            // Query to fetch user data based on ID
            const getUserQuery = `
                SELECT u.*,
                    COALESCE(MAX(p.recompensaid), 0) AS recompensaMasAlta,
                    COALESCE(u.Victorias, 0) * 4 + COALESCE(u.Empates, 0) * 2 + COALESCE(u.Derrotas, 0) AS puntosExperiencia
                FROM Miguel.Usuario u
                LEFT JOIN Miguel.posee p ON u.id = p.usuarioid
                WHERE u.id = $1
                GROUP BY u.id;
            `;

            
            // Execute the query to fetch user data
            const { rows } = await pool.query(getUserQuery, [userId]);

            // If no user found with the provided ID
            if (rows.length === 0) {
                return res.status(404).json({ message: "Usuario no encontrado" });
            }

            const user = rows[0];
            res.status(200).json(user);
        } catch (error) {
            console.error('Error al obtener información del usuario:', error);
            res.status(500).json({ message: "Error al obtener información del usuario" });
        }
    })
    // Actualizar un usuario en concreto
    .put(async (req, res) => {
        const userId = req.params.id;
        const { nombre, contraseña, correoElectronico } = req.body;
        const client = await pool.connect();
        try {
            // Query to update user data
            const updateUserQuery = `
                UPDATE Miguel.Usuario
                SET nombre = $1, contraseña = $2, correoElectronico = $3
                WHERE id = $4
            `;
            
            // Execute the query to update user data
            await client.query(updateUserQuery, [nombre, contraseña, correoElectronico, userId]);

            res.status(200).json({ message: "Usuario actualizado exitosamente" });
        } catch (error) {
            console.error('Error al actualizar el usuario:', error);
            res.status(500).json({ message: "Error al actualizar el usuario" });
        }
        finally {
            if (client) {
                client.release(); // Release the client back to the pool
                console.log('Connection released');
            }
        }
    })
    // Borrar un usuario en concreto
    .delete(async (req, res) => {
        const userId = req.params.id;
        const client = await pool.connect();
        try {
            // Query to delete user data
            const deleteUserQuery = `
                DELETE FROM Miguel.Usuario
                WHERE id = $1
            `;
            
            // Execute the query to delete user data
            await client.query(deleteUserQuery, [userId]);

            res.status(200).json({ message: "Usuario eliminado exitosamente" });
        } catch (error) {
            console.error('Error al eliminar el usuario:', error);
            res.status(500).json({ message: "Error al eliminar el usuario" });
        }
        finally {
            if (client) {
                client.release(); // Release the client back to the pool
                console.log('Connection released');
            }
        }
    });



// Ruta /users/update_puntos/:modo/:idGanador/:idPerdedor, para que se actualicen los ELO de los jugadores
router.post("/update_puntos/:modo/:idGanador/:idPerdedor/:esEmpate", async (req, res) => {
    const { idGanador, idPerdedor, esEmpate } = req.params;
    console.log(req.params)
    const modo = req.params.modo;
    const client = await pool.connect();
      try {

        let eloColumn;
        switch (modo) {
            case 'blitz':
                eloColumn = 'eloblitz';
                break;
            case 'bullet':
                eloColumn = 'elobullet';
                break;
            case 'rapid':
                eloColumn = 'elorapid';
                break;
            default:
                return res.status(400).json({ message: "Modo de liderazgo no válido" });
        }

        // Actualización de ELO -------------------------------------------------------------------------
          
        const obtenerELOJugadorQuery = `
            SELECT u.${eloColumn} AS elo
            FROM Miguel.Usuario u
            WHERE u.id = $1;
        `;

        const { rows: puntuacionGanador } = await client.query(obtenerELOJugadorQuery, [idGanador]);
        const { rows: puntuacionPerdedor } = await client.query(obtenerELOJugadorQuery, [idPerdedor]);

        // Check if ganador is undefined or if it has zero length
        if (!puntuacionGanador || puntuacionGanador.length === 0) {
            return res.status(404).json({ message: "Usuario ganador no encontrado" });
        }
        if (!puntuacionPerdedor || puntuacionPerdedor.length === 0) {
            return res.status(404).json({ message: "Usuario perdedor no encontrado" });
        }

        const usuarioGanador = puntuacionGanador[0];
        const usuarioPerdedor = puntuacionPerdedor[0];

        console.log('ELO Usuario ganador:', usuarioGanador.elo);
        console.log('XP Usuario ganador:', usuarioGanador.puntosexperiencia);

        console.log('ELO Usuario perdedor:', usuarioPerdedor.elo);
        console.log('XP Usuario perdedor:', usuarioPerdedor.puntosexperiencia);
          
          const K = 20;
          const puntuacionEsperadaGanador = 1 / (1 + 10 ** ((usuarioPerdedor.elo - usuarioGanador.elo) / 400));
          const puntuacionEsperadaPerdedor = 1 - puntuacionEsperadaGanador;
  
          const nuevoELOGanador = usuarioGanador.elo + Math.round(K * (1 - puntuacionEsperadaGanador));
          const nuevoELOPerdedor = usuarioPerdedor.elo + Math.round(K * (0 - puntuacionEsperadaPerdedor));
  
  
        
        const updateELOGanador = `UPDATE Miguel.Usuario SET ${eloColumn} = $1 WHERE Id = $2;`;
        await client.query(updateELOGanador, [nuevoELOGanador, idGanador]);

        const updateELOPerdedor = `UPDATE Miguel.Usuario SET ${eloColumn} = $1 WHERE Id = $2;`;
        await client.query(updateELOPerdedor, [nuevoELOPerdedor, idPerdedor]);
        
        console.log("Nuevo ELO ganador:", nuevoELOGanador);
        console.log("Nuevo ELO perdedor:", nuevoELOPerdedor);

        // Actualización de victorias y derrotas -------------------------------------------------------------------------

        const obtenerPuntosJugadorQuery = `
            SELECT
                u.Victorias,
                u.Empates,
                u.Derrotas
            FROM Miguel.Usuario u
            WHERE u.id = $1;
        `;

        if(esEmpate === "true"){   // Si es empate
            const { rows: metricasJugador1 } = await client.query(obtenerPuntosJugadorQuery, [idGanador]);
            const metricasUsuarioJugador1 = metricasJugador1[0];
            const nuevosEmpatesJugador1 = metricasUsuarioJugador1.empates + 1;
            const updateEmpatesJugador1 = `UPDATE Miguel.Usuario SET empates = $1 WHERE Id = $2;`;
            await pool.query(updateEmpatesJugador1, [nuevosEmpatesJugador1, idGanador]);

            const { rows: metricasJugador2 } = await client.query(obtenerPuntosJugadorQuery, [idPerdedor]);
            const metricasUsuarioJugador2 = metricasJugador2[0];
            const nuevosEmpatesJugador2 = metricasUsuarioJugador2.empates + 1;
            const updateEmpatesJugador2 = `UPDATE Miguel.Usuario SET empates = $1 WHERE Id = $2;`;
            await client.query(updateEmpatesJugador2, [nuevosEmpatesJugador2, idPerdedor]);
            
        }
        else {  // Si hay un ganador
            const { rows: metricasGanador } = await client.query(obtenerPuntosJugadorQuery, [idGanador]);
            const metricasUsuarioGanador = metricasGanador[0];
            const nuevasVictorias = metricasUsuarioGanador.victorias + 1;
            const updateVictoriasGanador = `UPDATE Miguel.Usuario SET victorias = $1 WHERE Id = $2;`;
            await client.query(updateVictoriasGanador, [nuevasVictorias, idGanador]);
            

            const { rows: metricasPerdedor } = await client.query(obtenerPuntosJugadorQuery, [idPerdedor]);
            const metricasUsuarioPerdedor = metricasPerdedor[0];
            const nuevasDerrotas = metricasUsuarioPerdedor.derrotas + 1;
            const updateDerrotasPerdedor = `UPDATE Miguel.Usuario SET derrotas = $1 WHERE Id = $2;`;
            await client.query(updateDerrotasPerdedor, [nuevasDerrotas, idPerdedor]);
        }

        

  
        res.status(200).json({ message: 'ELO ratings updated successfully' });
        } 
        catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Error updating ELO ratings' });
        }
        finally {
            if (client) {
                client.release(); // Release the client back to the pool
                console.log('Connection released');
            }
        }
  })
  router.get("/ranking/:mode", async (req, res) => {
    const mode = req.params.mode;

    try {
        let eloColumn;
        switch (mode) {
            case 'blitz':
                eloColumn = 'eloblitz';
                break;
            case 'bullet':
                eloColumn = 'elobullet';
                break;
            case 'rapid':
                eloColumn = 'elorapid';
                break;
            default:
                return res.status(400).json({ message: "Modo de liderazgo no válido" });
        }

        // Query to fetch the top 10 users sorted by the specified ELO column
        const getUsersQuery = `
            SELECT id, nombre, ${eloColumn} AS elo
            FROM Miguel.Usuario
            ORDER BY ${eloColumn} DESC
            LIMIT 10
        `;
        
        // Execute the query to fetch users
        const { rows } = await pool.query(getUsersQuery);

        // Send the sorted leaderboard as JSON response
        res.status(200).json(rows);
    } catch (error) {
        console.error('Error al obtener el leaderboard:', error);
        res.status(500).json({ message: "Error al obtener el leaderboard" });
    }
});

// Ruta para obtener el número de avatar y número de color dado un ID de usuario
router.get("/avatar_color/:id", async (req, res) => {
    const userId = req.params.id;

    try {
        // Consulta para obtener el número de avatar y el número de color del usuario
        const getAvatarColorQuery = `
            SELECT Avatar, Color
            FROM Miguel.Usuario
            WHERE Id = $1;
        `;

        // Ejecutar la consulta para obtener el número de avatar y el número de color
        const { rows } = await pool.query(getAvatarColorQuery, [userId]);

        // Verificar si se encontró el usuario
        if (rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        // Enviar el número de avatar y el número de color como respuesta JSON
        const { avatar, color } = rows[0];
        res.status(200).json({ avatar, color });
    } catch (error) {
        console.error('Error al obtener el número de avatar y color:', error);
        res.status(500).json({ message: "Error al obtener el número de avatar y color" });
    }
});
// Ruta para actualizar el número de avatar y el número de color dado un ID de usuario
router.post("/update_avatar_color/:id", async (req, res) => {
    const userId = req.params.id;
    const { avatar, color } = req.body;
    const client = await pool.connect();
    try {
        // Verificar si se proporcionaron el avatar y el color en la solicitud
        if (!avatar || !color) {
            return res.status(400).json({ message: "Se deben proporcionar el número de avatar y el número de color" });
        }

        // Consulta para actualizar el número de avatar y el número de color del usuario
        const updateAvatarColorQuery = `
            UPDATE Miguel.Usuario
            SET Avatar = $1, Color = $2
            WHERE Id = $3;
        `;

        await client.query(updateAvatarColorQuery, [avatar, color, userId]);
        // Ejecutar la consulta para actualizar el número de avatar y el número de color
        
        // Enviar una respuesta de éxito
        res.status(200).json({ message: "Número de avatar y número de color actualizados correctamente" });
    } catch (error) {
        console.error('Error al actualizar el número de avatar y color:', error);
        res.status(500).json({ message: "Error al actualizar el número de avatar y color" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});
// Ruta para obtener toda la información de un usuario dado su ID
router.get("/:id", async (req, res) => {
    const userId = req.params.id;

    try {
        // Consulta para obtener toda la información del usuario
        const getUserInfoQuery = `
            SELECT * FROM Miguel.Usuario
            WHERE Id = $1;
        `;

        // Ejecutar la consulta para obtener la información del usuario
        const { rows } = await pool.query(getUserInfoQuery, [userId]);

        // Verificar si se encontró un usuario con el ID proporcionado
        if (rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        // Enviar la información del usuario como respuesta
        res.status(200).json({ user: rows[0] });
    } catch (error) {
        console.error('Error al obtener la información del usuario:', error);
        res.status(500).json({ message: "Error al obtener la información del usuario" });
    }
});

// Ruta para obtener los puntos del pase de batalla dado un ID de usuario
router.get("/puntos_pase_batalla/:id", async (req, res) => {
    const userId = req.params.id;

    try {
        // Consulta para obtener los puntos del pase de batalla del usuario
        const getBattlePassPointsQuery = `
            SELECT PuntosPase
            FROM Miguel.Usuario
            WHERE Id = $1;
        `;

        // Ejecutar la consulta para obtener los puntos del pase de batalla
        const { rows } = await pool.query(getBattlePassPointsQuery, [userId]);

        // Verificar si se encontró el usuario
        if (rows.length === 0) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        // Enviar los puntos del pase de batalla como respuesta JSON
        const puntosPaseBatalla = rows[0].puntospase;
        res.status(200).json({ puntosPaseBatalla });
    } catch (error) {
        console.error('Error al obtener los puntos del pase de batalla:', error);
        res.status(500).json({ message: "Error al obtener los puntos del pase de batalla" });
    }
});
// Ruta para actualizar los puntos del pase de batalla dado un ID de usuario
router.post("/update_puntos_pase_batalla/:id", async (req, res) => {
    const userId = req.params.id;
    const { puntosPaseBatalla } = req.body;

    try {
        // Verificar si se proporcionaron los puntos del pase de batalla en la solicitud
        if (!puntosPaseBatalla) {
            return res.status(400).json({ message: "Se deben proporcionar los puntos del pase de batalla" });
        }

        // Consulta para actualizar los puntos del pase de batalla del usuario
        const updateBattlePassPointsQuery = `
            UPDATE Miguel.Usuario
            SET PuntosPase = $1
            WHERE Id = $2;
        `;

        // Ejecutar la consulta para actualizar los puntos del pase de batalla
        await pool.query(updateBattlePassPointsQuery, [puntosPaseBatalla, userId]);

        // Enviar una respuesta de éxito
        res.status(200).json({ message: "Puntos del pase de batalla actualizados correctamente" });
    } catch (error) {
        console.error('Error al actualizar los puntos del pase de batalla:', error);
        res.status(500).json({ message: "Error al actualizar los puntos del pase de batalla" });
    }
});

// Ruta para actualizar el set de piezas de un usuario dado su ID
router.post("/update_set_piezas/:id", async (req, res) => {
    const userId = req.params.id;
    const { setPiezas } = req.body;

    try {
        // Verificar si se proporcionó el set de piezas en la solicitud
        if (!setPiezas) {
            return res.status(400).json({ message: "Se debe proporcionar el set de piezas" });
        }

        // Consulta para actualizar el set de piezas del usuario
        const updateSetPiezasQuery = `
            UPDATE Miguel.Usuario
            SET setPiezas = $1
            WHERE Id = $2;
        `;

        // Ejecutar la consulta para actualizar el set de piezas
        await pool.query(updateSetPiezasQuery, [setPiezas, userId]);

        // Enviar una respuesta de éxito
        res.status(200).json({ message: "Set de piezas actualizado correctamente" });
    } catch (error) {
        console.error('Error al actualizar el set de piezas:', error);
        res.status(500).json({ message: "Error al actualizar el set de piezas" });
    }
});
// Ruta para actualizar el campo emoticonos de un usuario dado su ID
router.post("/update_emoticonos/:id", async (req, res) => {
    const userId = req.params.id;
    const { emoticonos } = req.body;
    const client = await pool.connect();
    try {
        // Verificar si se proporcionó el emoticono en la solicitud
        if (!emoticonos) {
            return res.status(400).json({ message: "Se debe proporcionar la lista de emoticonos" });
        }

        // Consulta para actualizar el emoticono del usuario
        const updateEmoticonosQuery = `
            UPDATE Miguel.Usuario
            SET emoticonos = $1
            WHERE Id = $2;
        `;

        // Ejecutar la consulta para actualizar el emoticono
        await client.query(updateEmoticonosQuery, [emoticonos, userId]);

        // Enviar una respuesta de éxito
        res.status(200).json({ message: "Emoticonos actualizados correctamente" });
    } catch (error) {
        console.error('Error al actualizar los emoticonos:', error);
        res.status(500).json({ message: "Error al actualizar los emoticonos" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});
// Ruta para actualizar los puntosPase de un usuario dado su ID
router.post("/update_nivel_pase/:id", async (req, res) => {
    const userId = req.params.id;
    const { nivelPase } = req.body;
    const client = await pool.connect();
    try {
        // Verificar si se proporcionaron los puntosPase en la solicitud
        if (!nivelPase) {
            return res.status(400).json({ message: "Se debe proporcionar los puntosPase" });
        }

        // Consulta para actualizar los puntosPase del usuario
        const updatenivelPaseQuery = `
            UPDATE Miguel.Usuario
            SET nivelPase = $1
            WHERE Id = $2;
        `;

        // Ejecutar la consulta para actualizar los puntosPase
        await client.query(updatenivelPaseQuery, [nivelPase, userId]);

        // Enviar una respuesta de éxito
        res.status(200).json({ message: "PuntosPase actualizados correctamente" });
    } catch (error) {
        console.error('Error al actualizar los puntosPase:', error);
        res.status(500).json({ message: "Error al actualizar los puntosPase" });
    }
    finally {
        if (client) {
            client.release(); // Release the client back to the pool
            console.log('Connection released');
        }
    }
});

module.exports = router;