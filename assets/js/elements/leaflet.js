import L from "leaflet";

// For LiveView to interoperate with an imperative JS library like Leaflet, we
// need a way of translating DOM updates into JS function calls. `react-leaflet`
// serves as this "adapter" when using React; here we create a similar adapter
// using the HTML Custom Elements standard.

const LeafletMap = class extends HTMLElement {
  constructor() {
    super();

    // The Leaflet map div "shouldn't exist" from LiveView's perspective, so we
    // isolate it in a shadow DOM to prevent it from being deleted.
    let shadowDom = this.attachShadow({mode: "open"});

    // Copy the main document's styles into the shadow DOM.
    Array.from(document.getElementsByTagName("link"))
      .filter((link) => link.getAttribute("rel") === "stylesheet")
      .forEach((link) => shadowDom.appendChild(link.cloneNode()));

    // Hack: In the `connectedCallback` the dimensions of the container are 0x0,
    // likely because the browser has not yet computed its style at that point
    // in the lifecycle. This results in a glitchy map because Leaflet needs to
    // know the height of the container when it initializes. We work around this
    // by duplicating the width and height from the stylesheet here.
    this.container = document.createElement("div");
    this.container.className = "leaflet-container";
    this.container.style.height = "400px";
    this.container.style.width = "400px";
    shadowDom.appendChild(this.container);
  }

  connectedCallback() {
    if (this.isConnected) {
      let lat = parseFloat(this.getAttribute("lat")) || 0.0;
      let lng = parseFloat(this.getAttribute("lng")) || 0.0;
      let zoom = parseInt(this.getAttribute("zoom"));

      this.map = L.map(this.container, { center: [lat, lng], zoom });
    }
  }

  disconnectedCallback() {
    if (this.map) { this.map.remove(); }
  }
};

const LeafletTiles = class extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    if (this.isConnected && this.parentElement.map) {
      this.layer = L.tileLayer(
        this.getAttribute("url"),
        { attribution: this.getAttribute("attribution") }
      )
      this.layer.addTo(this.parentElement.map);
    }
  }

  disconnectedCallback() {
    if (this.layer) { this.layer.remove(); }
  }
};

const LeafletMarker = class extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    if (this.isConnected && this.parentElement.map) {
      this.marker = L.marker(this.latLng);
      this.marker.addTo(this.parentElement.map);
    }
  }

  disconnectedCallback() {
    if (this.marker) { this.marker.remove(); }
  }

  attributeChangedCallback(attr, oldValue, newValue) {
    if (this.marker && ["lat", "lng"].includes(attr)) {
      this.marker.setLatLng(this.latLng);
    }
  }

  static get observedAttributes() { return ["lat", "lng"]; }

  get latLng() {
    return [
      parseFloat(this.getAttribute("lat")),
      parseFloat(this.getAttribute("lng"))
    ];
  }
};

export { LeafletMap, LeafletTiles, LeafletMarker };
