// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// === LiveView setup ===
import {Socket} from "phoenix";
import LiveSocket from "phoenix_live_view";

let liveSocket = new LiveSocket("/live", Socket);
liveSocket.connect();

import { LeafletMap, LeafletTiles, LeafletMarker } from "./elements/leaflet";
customElements.define("leaflet-map", LeafletMap);
customElements.define("leaflet-tiles", LeafletTiles);
customElements.define("leaflet-marker", LeafletMarker);

// === React component ===
import React from "react";
import { render } from "react-dom";
import Route from "./components/Route.jsx";

const initComponent = () => {
  const dataEl = document.getElementById("route-data");
  if (!dataEl) {
    console.warn("Could not find route-data element");
    return;
  }

  const data = JSON.parse(dataEl.innerHTML);

  const rootEl = document.getElementById("route-root");
  if (!rootEl) {
    console.warn("Could not find route-root element");
    return;
  }

  render(React.createElement(Route, data), rootEl);
};

initComponent();
