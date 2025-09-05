
import React, { useState } from 'react';
import '../styles/SignUp.css';
import { useNavigate } from 'react-router-dom';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import { Tooltip, Typography } from '@mui/material';
const apiUrl = process.env.REACT_APP_API_URL;

function SignUp({ updateUserInfo }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [email, setEmail] = useState('');
  const [segundaPassword, setSegundaPassword] = useState('');
  const navigate = useNavigate();
  const handleClick = () => {
    navigate('/home');
  }
  const labelColorStyle = {
    color: 'white',
  };

  const [error, setError] = useState('');
  const handleSignUp = async () => {
    if (username === '' || password === '' || segundaPassword === '' || email === '') {
      setError('Rellena todos los campos');
    }
    else if ( email.indexOf('@') === -1) {
      setError('Email incorrecto');
    }
    else {
      if (password.localeCompare(segundaPassword) !== 0 ) {
        setError('Las contraseñas deben de coincidir');
      }
      else {
        try {
          const response = await fetch(`${apiUrl}/users/register`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ nombre:username, contraseña:password, correoElectronico:email}),
          });
          if (response.ok) {
            // Si la solicitud es exitosa, navega al menú del juego
            navigate('/home');
          } else {
            // Si la solicitud falla, muestra un mensaje de error
            if (response.status === 500) {
              setError('No se ha podido registrar el usuario');
            }
          }
        } catch (error) {
          console.error('Error de red:', error);
        }
      }
    }
  };

  return (
    <div className='mainContainerSignup'>
      <div className='wrapperSignup'>
        <div>
          {/* Botón para volver al menú principal */}
          <button className='titleButtonSignup' onClick={handleClick}>
            {/* Hint para el botón */}
            <Tooltip title="Volver al menú principal">
              <h1 className='titleSignup'>ChessHub</h1>
            </Tooltip>
          </button>
        </div>
        <div className="formSignup">
          <h3 className='formTitleSignup'><u>Crear Cuenta</u></h3>
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
              id="email"  
              label="Correo electronico" 
              variant="outlined" 
              type='email'
              value={email}
              color="warning" /* Color del borde */
              InputLabelProps={{
                style: labelColorStyle,
              }}
              InputProps={{
                style: { color: 'white' } // Change text color to white
              }}
              onChange={(e) => setEmail(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && e.preventDefault()}
            />
          </Box>
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
              label="Introduzca una contraseña" 
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
          {/* Input para repertir la contraseña */}
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
              label="Introduzca la contraseña de nuevo" 
              type="password"
              variant="outlined" 
              value={segundaPassword}
              color="warning" /* Color del borde */
              InputLabelProps={{
                style: labelColorStyle,
              }}
              InputProps={{
                style: { color: 'white' } // Change text color to white
              }}
              onChange={(e) => setSegundaPassword(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && e.preventDefault()}
            />
          </Box>
          {/* Mostrar mensaje de error */}
          {error && (
            <p className="error-message">{error}</p>
          )}
          {/* Botón para proceder al signup */}
          <Button 
            variant="contained" 
            onClick={handleSignUp} 
            sx={{ padding: '10px 40px' ,
            fontSize: '16px', 
            bgcolor: '#F77F00',
            '&:hover': {background: "#F77F00"}
            }}
            color='warning'
          >
            Registrarse
          </Button>
        </div>
      </div>
    </div> 
  );
}

export default SignUp;