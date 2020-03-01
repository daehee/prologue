import asyncdispatch
from asynchttpserver import newAsyncHttpServer, serve, close, AsyncHttpServer


from request import NativeRequest
from ../core/nativesettings import Settings
from ../core/context import Router, ReversedRouter, ReRouter, HandlerAsync, Event, ErrorHandlerTable


type
  Server* = AsyncHttpServer

  Prologue* = ref object
    server*: Server
    settings*: Settings
    router*: Router
    reversedRouter*: ReversedRouter
    reRouter*: ReRouter
    middlewares*: seq[HandlerAsync]
    startup*: seq[Event]
    shutdown*: seq[Event]
    errorHandlerTable*: ErrorHandlerTable
    

proc appName*(app: Prologue): string {.inline.} =
  app.settings.appName

proc serve*(app: Prologue, port: Port,
  callback: proc (request: NativeRequest): Future[void] {.closure, gcsafe.},
  address = "") =
  waitFor app.server.serve(port, callback, address)

proc close*(app: Prologue) =
  app.server.close()

proc newPrologueServer*(reuseAddr = true, reusePort = false,
                         maxBody = 8388608): Server =
  newAsyncHttpServer(reuseAddr, reusePort, maxBody)
