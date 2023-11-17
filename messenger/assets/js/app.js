// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import "./chats_socket.js";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

const LocalStateStore = {
  mounted() {
    this.handleEvent("setSessionStorageItem", (obj) =>
      this.setSessionStorageItem(obj)
    ),
      this.handleEvent("restore", (obj) => this.restore(obj));
  },
  setSessionStorageItem({ name, item }) {
    console.log("event");
    sessionStorage.setItem(name, item);
  },
  restore({ name, event }) {
    item = sessionStorage.getItem(name);
    console.log(event);
    this.pushEvent(event, item);
  },
};

let Hooks = {};

Hooks.LocalStateStore = LocalStateStore;
Hooks.Session = {
  mounted() {
    this.handleEvent("setSession", async ({ token }) => {
      sessionStorage.setItem("token", token);

      await fetch(`/auth`, {
        method: "post",
        body: JSON.stringify({ token }),
        credentials: "include",
        headers: {
          "x-csrf-token": csrfToken,
          "Content-Type": "application/json",
        },
      })
        .then((res) => {
          return res.json();
        })
        .then((res) => {
          this.pushEvent("redirect_to_chats", {});
        });
    });

    this.handleEvent("removeSession", async () => {
      sessionStorage.removeItem("token");

      await fetch(`/logout`, {
        method: "post",
        body: JSON.stringify({}),
        credentials: "include",
        headers: {
          "x-csrf-token": csrfToken,
          "Content-Type": "application/json",
        },
      })
        .then((res) => {
          return res.json();
        })
        .then((res) => {
          console.log(res);
          this.pushEvent("redirect_to_login", {});
        });
    });
  },
};

window.addEventListener(`phx:scroll_to_bottom`, () => {
  let el = document.getElementById("scrollable-chat");

  el && el.scrollTo({ behavior: "smooth", top: el.scrollHeight });
});

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
