# Pequeña wiki en la que poner dudas o resolver alguna duda que tengamos #
# ---------------------------------------------------------------------- #

* Diferencia entre clases con estado y sin estado, y en que casos aplicar unos u otros?¿
    Básicamente si tu clase tiene elementos o widgets que a lo largo del tiempo van a cambiar, debes tener una clase con estado, si la
    clase es plana o simplemente de visualización, da igual.
* Identificar que clases necesitarán estado y que clases no.
    Clase Casilla de Ajedrez debe guardar estado ya que dinámicamente va a cambiar su contendio a lo largo del tiempo.


# Como lanzar el servidor back end, y como configurar PostMan para poder visualizar peticiones #
    * Para probar la aplicacion y que no de problemas(almenos en google chrome), lanzar la aplicacion asi:
        flutter run -d chrome --web-browser-flag "--disable-web-security"

    * Para lanzar el servidor backend:
        npm run devStart
        Lo lanzará en localhost en el puerto especificado en la configuración

    * Descargar PostMan
        Body: JSON y raw al configurar el entorno


# Formato del JSON a postear al servidor al hacer un movimiento en el tablero #

{
    "peones": [
        {
            "x": 0,
            "y": 1,
            "color": "blanca"
        },
        {
            "x": 1,
            "y": 1,
            "color": "blanca"
        },
        {
            "x": 2,
            "y": 1,
            "color": "blanca"
        },
        {
            "x": 3,
            "y": 1,
            "color": "blanca"
        },
        {
            "x": 4,
            "y": 1,
            "color": "blanca"
        },
        {
            "x": 5,
            "y": 1,
            "color": "blanca"
        },
        {
            "x": 6,
            "y": 1,
            "color": "blanca"
        },
        {
            "x": 7,
            "y": 1,
            "color": "blanca"
        },
        {
            "x": 0,
            "y": 6,
            "color": "negra"
        },
        {
            "x": 1,
            "y": 6,
            "color": "negra"
        },
        {
            "x": 2,
            "y": 6,
            "color": "negra"
        },
        {
            "x": 3,
            "y": 6,
            "color": "negra"
        },
        {
            "x": 4,
            "y": 6,
            "color": "negra"
        },
        {
            "x": 5,
            "y": 6,
            "color": "negra"
        },
        {
            "x": 6,
            "y": 6,
            "color": "negra"
        },
        {
            "x": 7,
            "y": 6,
            "color": "negra"
        }
    ],
    "alfiles": [
        {
            "x": 2,
            "y": 0,
            "color": "blanca"
        },
        {
            "x": 5,
            "y": 0,
            "color": "blanca"
        },
        {
            "x": 2,
            "y": 7,
            "color": "negra"
        },
        {
            "x": 5,
            "y": 7,
            "color": "negra"
        }
    ],
    "caballos": [
        {
            "x": 1,
            "y": 0,
            "color": "blanca"
        },
        {
            "x": 6,
            "y": 0,
            "color": "blanca"
        },
        {
            "x": 1,
            "y": 7,
            "color": "negra"
        },
        {
            "x": 6,
            "y": 7,
            "color": "negra"
        }
    ],
    "torres": [
        {
            "x": 0,
            "y": 0,
            "color": "blanca"
        },
        {
            "x": 7,
            "y": 0,
            "color": "blanca"
        },
        {
            "x": 0,
            "y": 7,
            "color": "negra"
        },
        {
            "x": 7,
            "y": 7,
            "color": "negra"
        }
    ],
    "damas": [
        {
            "x": 3,
            "y": 0,
            "color": "blanca"
        },
        {
            "x": 3,
            "y": 7,
            "color": "negra"
        }
    ],
    "reyes": [
        {
            "x": 4,
            "y": 0,
            "color": "blanca"
        },
        {
            "x": 4,
            "y": 7,
            "color": "negra"
        }
    ]
}

# Lanzar la aplicación en ventana #
start ms-settings:developers

# Jugamos con IA poner campo IA: "color que lleva la IA" en json, cuando le toque a la IA recibimos el movimiento que ha hecho la IA sino recibiremos el json normal #
# Recibimos el movimiento de la IA con un json pequeño asi:
# {
# "fromX": 6,
# "fromY": 7,
# "fromColor": "color con el que juega la ia"
# "x": 3 
# "y": 4 
# } 
#
