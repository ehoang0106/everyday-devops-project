# Weather App

A modern, minimalist weather application inspired by Not Boring Weather.

## Features
- Real-time weather data powered by OpenWeatherMap API
- 6-day weather forecast
- Geolocation support (browser + IP-based fallback)
- City search functionality
- Bold, minimalist design with huge typography
- Fully responsive (desktop, tablet, mobile)

## Running with Docker

### Build the Docker image:
```bash
docker build -t weather-app .
```

### Run the container:
```bash
docker run -d -p 8080:80 --name weather-app weather-app
```

### Access the app:
Open your browser and navigate to:
```
http://localhost:8080
```

### Stop the container:
```bash
docker stop weather-app
```

### Remove the container:
```bash
docker rm weather-app
```

### View logs:
```bash
docker logs weather-app
```

## Running without Docker

Start a simple HTTP server:
```bash
python3 -m http.server 8000
```

Then open http://localhost:8000 in your browser.

## Configuration

Before using the app, make sure to add your OpenWeatherMap API key in `app.js`:

```javascript
const API_KEY = 'YOUR_API_KEY_HERE';
```

Get a free API key at: https://openweathermap.org/api

## Tech Stack
- HTML5
- CSS3 (with modern features like backdrop-filter, flexbox, grid)
- Vanilla JavaScript (ES6+)
- OpenWeatherMap API
- IPregistry API (for geolocation)
- Nginx (for Docker deployment)
