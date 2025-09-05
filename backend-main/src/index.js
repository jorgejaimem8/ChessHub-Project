const server = require('./server');

function startServer() {

    const port = process.env.PORT || 3001;
    server.listen(port, () => {
        console.log(`Server is running on port ${port}`);
    });
}
  
startServer();