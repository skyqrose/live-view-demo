defmodule LiveViewDemo.Backend do
  @moduledoc "Returns randomized fake data for the purposes of this demo."

  defmodule Route do
    defstruct [:name, :stops, :vehicles]
  end

  defmodule Stop do
    defstruct [:id, :name, :predictions]
  end

  defmodule Prediction do
    defstruct [:id, :minutes]
  end

  defmodule Vehicle do
    defstruct [:id, :latitude, :longitude]
  end

  def route(route_id) do
    %Route{name: route_id, stops: fake_stops(), vehicles: fake_vehicles()}
  end

  defp fake_stops do
    [
      %Stop{id: "1", name: "Oncefield", predictions: fake_predictions()},
      %Stop{id: "2", name: "Twosbury", predictions: fake_predictions()},
      %Stop{id: "3", name: "Thriceburg", predictions: fake_predictions()},
      %Stop{id: "4", name: "Fourhattan", predictions: fake_predictions()},
      %Stop{id: "5", name: "Fivingway", predictions: fake_predictions()},
      %Stop{id: "6", name: "Six Street", predictions: fake_predictions()},
      %Stop{id: "7", name: "Sevenborough", predictions: fake_predictions()},
      %Stop{id: "8", name: "Octothorpe", predictions: fake_predictions()}
    ]
  end

  defp fake_vehicles do
    [
      %Vehicle{id: "1", latitude: 42 + :rand.uniform(), longitude: -71 - :rand.uniform()},
      %Vehicle{id: "2", latitude: 42 + :rand.uniform(), longitude: -71 - :rand.uniform()},
      %Vehicle{id: "3", latitude: 42 + :rand.uniform(), longitude: -71 - :rand.uniform()},
      %Vehicle{id: "4", latitude: 42 + :rand.uniform(), longitude: -71 - :rand.uniform()},
      %Vehicle{id: "5", latitude: 42 + :rand.uniform(), longitude: -71 - :rand.uniform()},
      %Vehicle{id: "6", latitude: 42 + :rand.uniform(), longitude: -71 - :rand.uniform()}
    ]
  end

  defp fake_predictions do
    [
      %Prediction{id: "1", minutes: :rand.uniform(20)},
      %Prediction{id: "2", minutes: :rand.uniform(20)}
    ]
  end
end
