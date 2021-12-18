# Elixir - Tcp

**A basic TCP server in elixir**

## How is this working

When the app starts it starts a `Tcp.Registry` genserver that will hold the genservers that will handle each tcp client (`Tcp.Server`). It will also start a `Tcp.Listener` task that will listen to the port for new connections. When the `Tcp.Listener` receives a connection it will start a new isntance of `Tcp.Server` and pass it the socket. It will also register this socket to the `Tcp.Registry`.
