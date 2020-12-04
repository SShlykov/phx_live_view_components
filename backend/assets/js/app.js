import "../css/app.scss"
import "select2/dist/css/select2.css"
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"
import jQuery from "jquery"
import select2 from "select2"

let Hooks = {}

let msgScroll = () => {
  document.getElementById('chat_room_messages').scrollIntoView({ behavior: 'smooth', block: 'end' })
}

let scrollAt = () => {
  let scrollTop = document.documentElement.scrollTop || document.body.scrollTop
  let scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight
  let clientHeight = document.documentElement.clientHeight

  return scrollTop / (scrollHeight - clientHeight) * 100
}

Hooks.InfiniteScroll = {
  page() { return this.el.dataset.page },
  mounted(){
    this.pending = this.page()
    window.addEventListener("scroll", e => {
      if(this.pending == this.page() && scrollAt() > 90){
        this.pending = this.page() + 1
        this.pushEvent("load-more", {})
      }
    })
  },
  updated(){ this.pending = this.page() }
}

Hooks.ChatScroll = {
  mounted(){msgScroll()},
  updated(){msgScroll()}
}
Hooks.SelectCountry = {

  initSelect2() {
    let hook = this,
        $select = jQuery(hook.el).find("select");
    
    $select.select2()
    .on("select2:select", (e) => hook.selected(hook, e))
    
    return $select;
  },

  mounted() {
    this.initSelect2();
  },

  selected(hook, event) {
    let id = event.params.data.id;
    hook.pushEvent("country_selected", {country: id})
  }
}



let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

liveSocket.connect()
window.liveSocket = liveSocket