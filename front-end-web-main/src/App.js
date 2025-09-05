import React from 'react';
import './App.css';
import { Routes, Route } from 'react-router-dom';
import Home from './pages/Home.jsx'
import Login from './pages/Login.jsx';
import SignUp from './pages/SignUp.jsx';
import Game from './pages/Game.jsx'
import GameIA from './pages/GameIA.jsx'
import Ranking from './pages/Ranking.jsx';
import GameOnline from './pages/GameOnline.jsx';
import GameAsync from './pages/GameAsync.jsx';
import BattlePass from './pages/BattlePass.jsx';
import Arenas from './pages/Arenas.jsx';
import Personalizacion from './pages/Personalizacion.jsx';
import UserProfile from './pages/UserProfile.jsx';
import EditCredentials from './pages/EditCredentials.jsx';
import { GameMode, UserInfo, ShowUserProfile } from './components/CustomHooks.jsx';
import {SocketContext, socket} from './context/socket';

function App() {
  const {gameMode, updateMode} = GameMode(); 
  const {userInfo, updateUserInfo, modifyAvatarColor, modifyAvatarImage, resetUserInfo} = UserInfo();
  const {userProfileVisibility, updateUserProfileVisibility} = ShowUserProfile();

  return (
    <SocketContext.Provider value={socket}>
      <div className="App">
        <Routes>
          <Route path="/home" element={<Home updateMode={updateMode} gameMode={gameMode} userInfo={userInfo} updateUserInfo={updateUserInfo} resetUserInfo={resetUserInfo}/>} />
          <Route path="/login" element={<Login updateUserInfo={updateUserInfo}/>} />
          <Route path='/signup' element={<SignUp updateUserInfo={updateUserInfo}/>} />
          <Route path='/cambio-credenciales' element={<EditCredentials userInfo={userInfo}/>} /> {/* Pendiente de terminar (calvera) */}
          <Route path='/profile' element={<UserProfile userProfileVisibility={userProfileVisibility} updateUserProfileVisibility={updateUserProfileVisibility} userInfo={userInfo} modifyAvatarColor={modifyAvatarColor} modifyAvatarImage={modifyAvatarImage} updateUserInfo={updateUserInfo} resetUserInfo={resetUserInfo}/>} />
          <Route path='/battlePass' element={<BattlePass userInfo={userInfo} />} />
          <Route path='/ranking' element={<Ranking />} />
          <Route path='/arenas' element={<Arenas userInfo={userInfo} updateUserInfo={updateUserInfo}/>} />
          <Route path='/personalizacion' element={<Personalizacion userInfo={userInfo} updateUserInfo={updateUserInfo}/>} />
          <Route path='/game' element={<Game gameMode={gameMode} userInfo={userInfo} updateUserInfo={updateUserInfo}/>} />
          <Route path='/gameOnline/:roomId/:colorSuffix' element={<GameOnline gameMode={gameMode} userInfo={userInfo}/>} />
          <Route path='/gameAsync/:id' element={<GameAsync gameMode={gameMode} userInfo={userInfo}/>} />

          <Route path='/gameIA' element={<GameIA gameMode={gameMode} userInfo={userInfo} updateUserInfo={updateUserInfo}/>} />
        </Routes>
      </div>
    </SocketContext.Provider>
  );
}

export default App;
