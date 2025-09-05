import React, { useState } from 'react';
import '../styles/Login.css';
import { useNavigate } from 'react-router-dom';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import { Tooltip } from '@mui/material';
import { UserInfo } from '../components/CustomHooks';
const apiUrl = process.env.REACT_APP_API_URL;

function Login({ updateUserInfo }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();
  const handleClick = () => {
    navigate('/home');
  }

  const labelColorStyle = {
    color: 'white',
  };
  const [error, setError] = useState('');

  const handleLogin = async () => {
    try {
      const response = await fetch(`${apiUrl}/users/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ nombre: username, contraseña: password }),
        timeout: 10000, // Tiempo de espera de 10 segundos (10000 milisegundos)
      });
      const parseRes = await response.json();
      if (response.ok) {
        updateUserInfo({ field : "loggedIn", value : 'true' }); // Marca que el usuario tiene sesión iniciada 
        updateUserInfo({ field : "userId", value : parseRes.userId }); // Actualiza el id del usuario
        navigate('/home');
      } else {
        if (response.status === 401) {
          setError('Contraseña incorrecta');
        } 
        else if (response.status === 404) {
          setError('Usuario incorrecto')
        }
        else {
          setError('Error desconocido, por favor intenta de nuevo');
        }
      }
    } catch (error) {
      console.error('Error de red:', error);
      if (error instanceof TypeError && error.message === 'Failed to fetch') {
        setError('Error de red: No se pudo conectar al servidor');
      } else {
        setError('Error de red, por favor intenta de nuevo');
      }
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      handleLogin();
    }
  };

  return (
    <div className='mainContainerLogin'>
      <div className='wrapperLogin'>
        <div>
          {/* Botón para volver al menú principal */}
          <button className='titleButtonLogin' onClick={handleClick}>
            {/* Hint para el botón */}
            <Tooltip title="Volver al menú principal">
              <h1 className='titleLogin'>ChessHub</h1>
            </Tooltip>
          </button>
        </div>
        <div className="formLogin">
          <h3 className='formTitleLogin'><u>Inicio de Sesión</u></h3>
          {/* Input para el nombre de usuario */}
          <Box
            component="form"
            sx={{
              '& > :not(style)': { m: 1, width: '25ch' },
            }}
            noValidate
            autoComplete="off"
          >
            <TextField
              id="username"
              label="Nombre de usuario"
              variant="outlined"
              value={username}
              color="warning" /* Color del borde */
              InputLabelProps={{
                style: labelColorStyle,
              }}
              InputProps={{
                style: { color: 'white' } // Change text color to white
              }}
              onChange={(e) => setUsername(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && e.preventDefault()}
            />
          </Box>
          {/* Input para la contraseña */}
          <Box
            component="form"
            sx={{
              '& > :not(style)': { m: 1, width: '25ch' },
            }}
            noValidate
            autoComplete="off"
          >
            <TextField
              id="password"
              label="Contraseña"
              type="password"
              variant="outlined"
              value={password}
              color="warning" /* Color del borde */
              InputLabelProps={{
                style: labelColorStyle,
              }}
              InputProps={{
                style: { color: 'white' } // Change text color to white
              }}
              onChange={(e) => setPassword(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && e.preventDefault()}
            />
          </Box>
          {/* Botón para proceder al login */}
          {/* Mostrar mensaje de error */}
          {error && (
            <p className="error-message">{error}</p>
          )}
          <Button
            variant="contained"
            onClick={handleLogin}
            sx={{
              padding: '10px 40px',
              fontSize: '16px',
              bgcolor: '#F77F00',
              '&:hover': { background: "#F77F00" }
            }}
          >
            Iniciar sesión
          </Button>
          {/* Botón para acceder a signup */}
          <a className='registrateLogin' onClick={() => { navigate('/signup') }}>¿No tienes cuenta? Regístrate</a>
        </div>
      </div>
    </div>
  );
}

export default Login;