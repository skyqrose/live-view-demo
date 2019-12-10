import React, { useState, useEffect, useRef } from "react";

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
