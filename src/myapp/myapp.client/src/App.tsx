import { useEffect, useState } from 'react'
import './App.css'

type WeatherForecast = {
  date: string
  temperatureC: number
  temperatureF: number
  summary: string | null
}

function App() {
  const [forecasts, setForecasts] = useState<WeatherForecast[] | null>(null)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetch('/api/weatherforecast')
      .then((response) => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        return response.json() as Promise<WeatherForecast[]>
      })
      .then(setForecasts)
      .catch((e: Error) => setError(e.message))
  }, [])

  return (
    <main>
      <h1>MyApp</h1>
      <h2>Weather forecast from the .NET API</h2>
      {error && <p role="alert">Could not load forecast: {error}</p>}
      {!forecasts && !error && <p>Loading…</p>}
      {forecasts && (
        <table>
          <thead>
            <tr>
              <th>Date</th>
              <th>Temp. (C)</th>
              <th>Temp. (F)</th>
              <th>Summary</th>
            </tr>
          </thead>
          <tbody>
            {forecasts.map((f) => (
              <tr key={f.date}>
                <td>{f.date}</td>
                <td>{f.temperatureC}</td>
                <td>{f.temperatureF}</td>
                <td>{f.summary}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </main>
  )
}

export default App
