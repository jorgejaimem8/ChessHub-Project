  import React from "react";
  import { useState, useEffect } from "react";
  import '../styles/Ranking.css';
  import SideBar from '../components/SideBar';
  import MenuIcon from '@mui/icons-material/Menu';
  import TablaRanking from "../components/TablaRanking";
  import Alert from '@mui/material/Alert';

  const apiUrl = process.env.REACT_APP_API_URL;


function Ranking() {
  const [showSidebar, setShowSidebar] = useState(false);
  const [data, setData] = useState(null);

  //Obtencion rankings de las 3 modalidades
  useEffect(() => {
    Promise.all([ //Se hacen concurrentemente las 3 llamadas a la API
      fetch(`${apiUrl}/users/ranking/bullet`).then(response => response.json()),
      fetch(`${apiUrl}/users/ranking/rapid`).then(response => response.json()),
      fetch(`${apiUrl}/users/ranking/blitz`).then(response => response.json())
    ])
    .then(([bulletData, rapidData, blitzData]) => {
      setData({ //Se concatenan los rankings de las tres modalidades en un json
        bullet: bulletData,
        rapid: rapidData,
        blitz: blitzData
      });
    })
    .catch(error => console.error('Error:', error));
  }, []);

  return (
    <div className="background-ranking">
      <div className={showSidebar ? "sideRanking open" : "sideRanking"}>
      {/* sideBar */}
      <SideBar setShowSidebar={setShowSidebar}/>
      </div>
      <div className="titleRanking">
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
        <h1 className="pageTitleRanking">RANKING GLOBAL</h1>
      </div>
      {/* <div style={{display:'flex', flexDirection:'column', flexGrow:'1', justifyContent:'center', alignItems:'center'}}>
        <div style={{width:'80%', display: 'flex', justifyContent:'space-around'}}>
          <div>{data && <TablaRanking data={data.bullet} modalidad={'Bullet'}/>}</div>
          <div>{data && <TablaRanking data={data.rapid} modalidad={'Rapid'}/>}</div>
          <div>{data && <TablaRanking data={data.blitz} modalidad={'Blitz'}/>}</div>
          <div>{data===null && <Alert severity="error">API inaccesible.</Alert>}</div>
        </div>
      </div> */}
      <div className="centroRanking">
        <div className="contenidoCentroRanking">
          <div>{data && <TablaRanking data={data.bullet} modalidad={'Bullet'}/>}</div>
          <div>{data && <TablaRanking data={data.rapid} modalidad={'Rapid'}/>}</div>
          <div>{data && <TablaRanking data={data.blitz} modalidad={'Blitz'}/>}</div>
        </div>
      </div>
    </div>
  );
}

export default Ranking;