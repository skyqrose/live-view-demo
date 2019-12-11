import React, { useState, useEffect, useRef } from "react";
import { Map, Marker, TileLayer } from "react-leaflet";

export default (props) => {
  const [route, setRoute] = useState(props);
  const [isOnline, setIsOnline] = useState(true);
  const inFlightRef = useRef(false);

  useEffect(() => {
    const interval = setInterval(() => {
      if (!inFlightRef.current) {
        inFlightRef.current = true;

        fetch(`/demo/react_api/${route.id}`)
          .then((resp) => {
            setIsOnline(true);
            resp.json().then((route) => { setRoute(route) });
          })
          .catch(() => { setIsOnline(false); })
          .finally(() => { inFlightRef.current = false; });
      }
    }, 2000)

    return () => { clearInterval(interval); };
  }, [route]);

  const {name, stops, vehicles} = route;

  return (
    <div id="route">
      <h2>{name}</h2>

      {!isOnline && <p>Error getting data. Reconnecting...</p>}

      <Map center={[42.5, -71.5]} zoom={8}>
        <TileLayer
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          attribution="&copy; <a href=&quot;http://osm.org/copyright&quot;>OpenStreetMap</a> contributors"
        />
        {vehicles.map(vehicle => (
          <Marker position={[vehicle.latitude, vehicle.longitude]}></Marker>
        ))}
      </Map>

      <table border="1" cellPadding="8" cellSpacing="0">
        <tbody>
          {stops.map(stop => (
            <tr key={stop.id}>
              <td>{stop.name}</td>
              <td>
                {stop.predictions.map(prediction =>
                  <div key={prediction.id}>{prediction.minutes} min.</div>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
