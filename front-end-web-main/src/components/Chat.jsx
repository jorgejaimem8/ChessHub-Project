import React, { useState, useEffect, useRef, useContext } from "react";
import './../styles/Chat.css'
import { SocketContext } from './../context/socket';
import EmojiEmotionsIcon from '@mui/icons-material/EmojiEmotions';

function Chat({ roomId, userInfo }) {
  const socket = useContext(SocketContext);
  const [value, setValue] = useState(''); /* Contenido del mensaje que se va a enviar */
  const [message, setMessage] = useState([]); /* Lista de mensajes enviados y recibidos */
  const inputRef = useRef(null); /* Referencia sobre el input*/
  const chatContainerRef = useRef(null); /* Referencia sobre los mensajes enviados y recibidos */
  const [showEmotes, setShowEmotes] = useState(false);
  const [avaliableEmotes, setAvaliableEmotes] = useState(['😁️','😂️','👍️','😲️']);

  const handleClickEmotes = () => {
    setAvaliableEmotes(userInfo.userEmotes);
    setShowEmotes(!showEmotes);
  }

  useEffect(() => {
    /* Se recibe un mensaje del servidor */
    const handleChatMessage = (data) => {
      receiveMessage(data);
    };

    if (socket) {
      /* Si se ha recibido mensaje del otro usuario, se añade a la lista de mensajes */
      socket.on('chat message', handleChatMessage);
      /* Desplaza los mensajes del chat hacia arriba conforme se envian/reciben mensajes */
      chatContainerRef.current.scrollTop = chatContainerRef.current.scrollHeight;

      /* Previene de que se reciban mensajes 2 veces */
      return () => {
        socket.off('chat message', handleChatMessage);
      };
    }
  }, [socket]);

  const handleSubmit = (e) => {
    e.preventDefault();
    /* Se construye el mensaje que se quiere enviar */
    const newMessage = {
      body: value,  // Contenido del mensaje
      from: 'Me' // Emisor del mensaje
    };
    
    /* Envio del mensaje al servidor */
    if (value) {
      setMessage([...message, newMessage]); // Añade el nuevo mensaje a la lista de mensajes
      socket.emit('chat message', { roomId: roomId, body: value, from: socket.id }); // Envía el mensaje creado a través del socket con un evento de tipo 'chat message' 
      inputRef.current.value = ''; // Vacía el input
      setValue(''); // Vacia el buffer de mensajes escritos
    }
  };

  const sendEmote = (emote) => {

    const newMessage = {
      body: emote,  // Contenido del mensaje
      from: 'Me' // Emisor del mensaje
    };
    
    /* Envio del mensaje al servidor */
    if (emote) {
      setMessage([...message, newMessage]); // Añade el nuevo mensaje a la lista de mensajes
      socket.emit('chat message', { roomId: roomId, body: emote, from: socket.id }); // Envía el mensaje creado a través del socket con un evento de tipo 'chat message' 
      setValue(''); // Vacia el buffer de mensajes escritos
    }
  }
  /* Añade el mensaje recibido a la lista de mensajes */
  function receiveMessage(msg) {
    setMessage(state => [...state, msg]);
  }

  /* Chat */
  return (
    <div className="chat">
      <ul id="messages" ref={chatContainerRef}> 
        { /* Muestra los mensajes en forma de lista */ }
        {message && message.slice().reverse().map((msg, i) => (
          <li key={i} className={msg.from === "Me" ? "me" : "them"}>
            {msg.body}
          </li>
        ))}
      </ul>
      {<div className={`envioEmotes ${showEmotes ? '' : 'hidden'}`}>
       {showEmotes && avaliableEmotes.map((emote,index) => (
          <button type="button" key={index} className="selectEmote" onClick={() => {sendEmote(emote)}}>{emote}</button>
        ))}
      </div>}
      {/* Input para escribir mensajes */}
      <form onSubmit={handleSubmit} className="form">
        <button className="chatEmojis" type="button" onClick={handleClickEmotes}>
          <EmojiEmotionsIcon sx={{
            color: 'white',
            bgcolor: 'transparent'
          }}/>
        </button>
        <input className="input"
          type="text" 
          placeholder="Escribe un mensaje" 
          autoComplete="off"
          ref={inputRef}
          onChange={(e) => setValue(e.target.value)} /* Se construye el mensaje a enviar */
        />
        {/* Botón para enviar mensajes */}
        <button type="submit" className="sendButton">Enviar</button>
      </form>
    </div>
  );
}

export default Chat;
