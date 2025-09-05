import { useState } from "react";
import whiteKing from '../images/pieces/cburnett/wK.svg'

/* Establece el modo de juego al que se está jugando */
export const GameMode = () => {
  const [gameMode, setGameMode] = useState('Rapid');
  const updateMode = (newMode) => {
    setGameMode(newMode);
  };
  return {
    gameMode,
    updateMode,
  };
}

/* Hook para mostrar el perfil del usuario */
export const ShowUserProfile = () => { 
  const [userProfileVisibility, setUserProfileVisibility] = useState(false);
  const updateUserProfileVisibility = () => {
    setUserProfileVisibility(!userProfileVisibility);
  };
  return {
    userProfileVisibility,
    updateUserProfileVisibility,
  };
}

/* Hook para información acerca del usuario */
export const UserInfo = () => {
  const [userInfo, setUserInfo] = useState({
    /* Información a guardar de cada usuario */
    loggedIn : sessionStorage.getItem('loggedIn') || 'false',
    userName : sessionStorage.getItem('userName') || '',
    userId : sessionStorage.getItem('userId') || '',
    avatarImage : sessionStorage.getItem('avatarImage') || whiteKing, 
    avatarColor: sessionStorage.getItem('avatarColor') || 'orange',
    eloRapid : sessionStorage.getItem('eloRapid') || '', 
    eloBullet : sessionStorage.getItem('eloBullet') || '', 
    eloBlitz : sessionStorage.getItem('eloBlitz') || '',
    userPiezas : sessionStorage.getItem('userPiezas') || '',
    userEmotes : sessionStorage.getItem('userEmotes') || ['','','',''],
    opponentId : sessionStorage.getItem('opponentId') || '',
    opponentName: sessionStorage.getItem('opponentName') || '',
    opponentElo : sessionStorage.getItem('opponentElo') || '',
  });
  const resetUserInfo = () => {
    /* resetea la información del usuario */
    sessionStorage.clear();
    setUserInfo({
      loggedIn : 'false',
      userName : '',
      userId : '',
      avatarImage : whiteKing, 
      avatarColor: 'orange',
      eloRapid : '', 
      eloBullet : '', 
      eloBlitz : '',
      userPiezas : '',
      userEmotes : ['','','',''],
      oppponentId : '',
      opponentName: '',
      opponentElo : '',
    });
  }
  const updateUserInfo = (data) => {
    setUserInfo(prevState => ({
      /* Modifica solo el campo campo indicado con el valor indicado */
      ...prevState,
      [data.field] : data.value,
    }));
    // Actualiza los valores en el navegador
    sessionStorage.setItem([data.field], data.value);
  }
  const modifyAvatarImage = (newAvatar) => {
    setUserInfo(prevState => ({
      ...prevState,
      avatarImage : newAvatar,
    }));
    // Actualiza los valores en el navegador
    sessionStorage.setItem('avatarImage', newAvatar);
  };
  const modifyAvatarColor = (newColor) => {
    setUserInfo(prevState => ({
      ...prevState,
      avatarColor : newColor,
    }));
    // Actualiza los valores en el navegador
    sessionStorage.setItem('avatarColor', newColor);
  }

  return {
    userInfo,
    updateUserInfo,
    modifyAvatarImage,
    modifyAvatarColor,
    resetUserInfo,
  }
}