import "phoenix_html"
import "../css/video_chat.scss"
import socket from './socket'

import {hasCameraElement, setupWebcamAndDetection} from "./webcam"
if(hasCameraElement()) setupWebcamAndDetection(socket);