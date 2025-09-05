import React, { useEffect } from "react";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import SideBar from "../components/SideBar";
import MenuIcon from '@mui/icons-material/Menu';
import Avatar from '@mui/material/Avatar';
import '../styles/UserProfile.css'
import Profile from "../components/Profile.jsx";
const apiUrl = process.env.REACT_APP_API_URL;

function UserProfile ( args ) {
  const [showSidebar, setShowSidebar] = useState(false); /* Mostrar o esconder el sideBar */
  const [showPopUp, setShowPopUp] = useState(false); 
  const navigate = useNavigate();
  const handleClick = () => {
    navigate('/cambio-credenciales');
  }

  const [informacionUsuario, setInformacionUsuario] = useState({
    nombre : '',
    correo : '',
    eloBlitz : '',
    eloBullet : '',
    eloRapid : '',
    victorias : '',
    derrotas : '',
    empates : '',
  });

  const [error, setError] = useState(null);
  useEffect(() => {

    const fetchUserData = async () => {
      // Pedir informacion del usuario al backend
      try {
        const response = await fetch(`${apiUrl}/users/${args.userInfo.userId}`); // Construct URL using userId
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        const userData = await response.json();
        setInformacionUsuario(prevState => ({ ...prevState, nombre : userData.nombre }))
        setInformacionUsuario(prevState => ({ ...prevState, correo : userData.correoelectronico }))
        setInformacionUsuario(prevState => ({ ...prevState, victorias : (userData.victorias === null ? 0 : userData.victorias) }))
        setInformacionUsuario(prevState => ({ ...prevState, derrotas : (userData.derrotas === null ? 0 : userData.derrotas) }))
        setInformacionUsuario(prevState => ({ ...prevState, empates : (userData.empates === null ? 0 : userData.empates) }))
        setInformacionUsuario(prevState => ({ ...prevState, eloBlitz : userData.eloblitz }))
        setInformacionUsuario(prevState => ({ ...prevState, eloBullet : userData.elobullet }))
        setInformacionUsuario(prevState => ({ ...prevState, eloRapid : userData.elorapid }))
      } catch (error) {
        setError(error.message);
      }
    }

    fetchUserData();
  }, [])

  const handleClickEliminar = async () => {
    try {
      const response = await fetch(`${apiUrl}/users/${args.userInfo.userId}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
        },
      }); // Construct URL using userId
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      else {
        const userData = await response.json();
        args.resetUserInfo();
        setShowPopUp(false);
        navigate('/home');
      }
    } catch (error) {
      setError(error.message);
    }
  }

  return (
    <div className="backgroundProfile">
      <div className={showSidebar ? "sideProfile open" : "sideProfile"}>
        {/* sideBar */}
        <SideBar setShowSidebar={setShowSidebar} />
      </div>
      <div className="titleProfile">
        {/* Botón para desplegar el sidebar */}
        <button className={!showSidebar ? "sideMenuButton" : "sideMenuButton hidden"} onClick={() => setShowSidebar(true)}>
          <MenuIcon sx={{
            color: '#fff',
            backgroundColor: 'transparent',
            height: 52,
            width: 52,
          }} />
        </button>
        {/* Título de la página */}
        <h1 className="pageTitleProfile">PERFIL DE USUARIO</h1>
      </div>
      <div className="containerProfile">
        <div className={`containerProfile center ${args.userProfileVisibility ? 'showingProfile' : ''}`}>
          {showPopUp && 
          <div className="userInfoProfilePopUp">
            <h1><u>¿Estás seguro de que quieres eliminar la cuenta?</u></h1>
            <div className="userInfoProfilePopUpButtonsContainer">
              <button className="userInfoProfilePopUpButtons confirm" onClick={handleClickEliminar}>Si</button>
              <button className="userInfoProfilePopUpButtons cancel" onClick={() => setShowPopUp(false)}>No</button>
            </div>
          </div> }
          {!args.userProfileVisibility && <>
            <div className="userInfoProfile">
              <button className="userInfoProfileAvatarButton" onClick={args.updateUserProfileVisibility}>
                <Avatar 
                  alt="User"
                  src={args.userInfo.avatarImage}
                  sx={{ bgcolor: args.userInfo.avatarColor, width: 52, height: 52 }}
                />
              </button>
              <div className="userInfoProfileTextTitle">
                <h2><u>INFORMACION DE LA CUENTA</u></h2>
                <div className="userInfoProfileTextContent">
                  <div style={{overflow: 'auto'}}>
                    <h3>Nombre de usuario: {informacionUsuario.nombre}</h3>
                    <h3>Correo Electrónico: {informacionUsuario.correo}</h3>
                    <h3>Contraseña: *****************</h3>
                  </div>
                  <div className="userInfoButtonContainer">
                    <button className="userInfoModifyProfileButton" onClick={handleClick}>
                      Modificar información
                    </button>
                    <button className="userInfoDeleteProfileButton" onClick={() => setShowPopUp(true)}>
                      Eliminar cuenta
                    </button>
                  </div>
                </div>
              </div>
            </div>
            <div className="userEloProfile">
              <div className="userEloProfileTextTitle">
                <h2><u>PUNTUACIÓN</u></h2>
                <div>
                  <h3>Elo en modo Rapid: {informacionUsuario.eloRapid}</h3>
                  <h3>Elo en modo Blitz: {informacionUsuario.eloBlitz}</h3>
                  <h3>Elo en modo Bullet: {informacionUsuario.eloBullet}</h3>
                </div>
              </div>
              <div className="userEloProfileTextTitle">
                <h2><u>ESTADÍSTICAS</u></h2>
                <div>
                  <h3>Victorias: {informacionUsuario.victorias}</h3>
                  <h3>Empates: {informacionUsuario.empates}</h3>
                  <h3>Derrotas: {informacionUsuario.derrotas}</h3>
                </div>
              </div>
            </div>
          </>}
          {args.userProfileVisibility && <>
            <Profile updateUserProfileVisibility={args.updateUserProfileVisibility} userInfo={args.userInfo} modifyAvatarImage={args.modifyAvatarImage} modifyAvatarColor={args.modifyAvatarColor}/>
          </>}
        </div>
      </div>
    </div>
  );
}

export default UserProfile;