import socketio from "socket.io-client";
import React from 'react';

// export const socket = socketio.connect("http://localhost:3001");
export const socket = socketio.connect(process.env.REACT_APP_API_URL);
export const SocketContext = React.createContext();