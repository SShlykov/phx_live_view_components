import "../css/app.scss"
import "phoenix_html"
import {Socket} from "phoenix"
import socket from './socket'
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let Hooks = {}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

liveSocket.connect()
window.liveSocket = liveSocket

import {hasCameraElement, setupWebcamAndDetection} from "./webcam"
if(hasCameraElement()) setupWebcamAndDetection(socket);