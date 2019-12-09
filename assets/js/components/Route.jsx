import React, { useState } from "react";

export default (props) => {
  const [route, setRoute] = useState(props);
  const {name, stops, vehicles} = route;

  return (
    <div id="route">
      <h2>{name} Line</h2>

      <table border="1" cellPadding="8" cellSpacing="0">
        <tbody>
          {stops.map(stop => (
            <tr key={stop.id}>
              <td>{stop.name}</td>
              <td>
                {stop.predictions
                  .sort((a, b) => a.minutes - b.minutes)
                  .map(prediction =>
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
