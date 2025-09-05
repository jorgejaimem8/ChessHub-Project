import React from "react";
import { useState } from "react";
import '../styles/EditCredentials.css';
import { useNavigate } from 'react-router-dom';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import { Tooltip } from '@mui/material';
import { UserInfo } from "../components/CustomHooks";
const apiUrl = process.env.REACT_APP_API_URL;

function EditCredentials ({ userInfo }) {
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
  /* Gestión del cambio de credenciales */
  const handleCredentials = async () => {
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
          const response = await fetch(`${apiUrl}/users/${userInfo.userId}`, {
            method: 'PUT',
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
              setError('No se han podido actualizar las credenciales');
            }
          }
        } catch (error) {
          console.error('Error de red:', error);
        }
      }
    }
  }

  return(
    <div className='mainContainerCredentials'>
      <div className='wrapperCredentials'>
        <div>
          {/* Botón para volver al menú principal */}
          <button className='titleButtonCredentials' onClick={handleClick}>
            {/* Hint para el botón */}
            <Tooltip title="Volver al menú principal">
              <h1 className='titleCredentials'>ChessHub</h1>
            </Tooltip>
          </button>
        </div>
        <div className="formCredentials">
          <h3 className='formTitleCredentials'><u>Modificar credenciales</u></h3>
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
          {/* Botón para proceder al Credentials */}
          <Button 
            variant="contained" 
            onClick={handleCredentials} 
            sx={{ padding: '10px 40px' ,
            fontSize: '16px', 
            bgcolor: '#F77F00',
            '&:hover': {background: "#F77F00"}
            }}
            color='warning'
          >
            Modificar Credenciales
          </Button>
        </div>
      </div>
    </div> 
  );
}

export default EditCredentials;