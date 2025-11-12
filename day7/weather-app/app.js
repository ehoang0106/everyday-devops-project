// OpenWeatherMap API Configuration
// Get your free API key from: https://openweathermap.org/api
const API_KEY = '17f479c11d7d372baa39d9a5e3de5f1a'; // Replace with your API key
const API_BASE_URL = 'https://api.openweathermap.org/data/2.5';

// DOM Elements
const loadingElement = document.getElementById('loading');
const errorElement = document.getElementById('error');
const weatherContent = document.getElementById('weather-content');
const errorMessage = document.querySelector('.error-message');
const retryBtn = document.getElementById('retry-btn');
const cityInput = document.getElementById('city-input');
const searchBtn = document.getElementById('search-btn');

// Persistent Search Bar Elements
const citySearchInput = document.getElementById('city-search-input');
const citySearchBtn = document.getElementById('city-search-btn');
const myLocationBtn = document.getElementById('my-location-btn');

// Current Weather Elements
const cityName = document.getElementById('city-name');
const currentDate = document.getElementById('current-date');
const temp = document.getElementById('temp');
const weatherIcon = document.getElementById('weather-icon');
const description = document.getElementById('description');
const feelsLike = document.getElementById('feels-like');
const humidity = document.getElementById('humidity');
const windSpeed = document.getElementById('wind-speed');
const pressure = document.getElementById('pressure');

// Forecast Elements
const forecastContainer = document.getElementById('forecast-container');

// Initialize App
function init() {
    if (API_KEY === 'YOUR_API_KEY_HERE') {
        showError('Please add your OpenWeatherMap API key in app.js. Get one free at https://openweathermap.org/api');
        return;
    }

    getUserLocation();
}

// Get User's Location
function getUserLocation() {
    showLoading();

    if (!navigator.geolocation) {
        showError('Geolocation is not supported by your browser');
        return;
    }

    navigator.geolocation.getCurrentPosition(
        (position) => {
            const { latitude, longitude } = position.coords;
            console.log(`Browser geolocation detected: Latitude ${latitude}, Longitude ${longitude}`);
            fetchWeatherData(latitude, longitude);
        },
        (error) => {
            console.error('Browser geolocation error:', error.code, error.message);
            handleLocationError(error);
        },
        {
            enableHighAccuracy: false,
            timeout: 10000,
            maximumAge: 300000
        }
    );
}

// Handle Geolocation Errors
function handleLocationError(error) {
    let message = '';

    switch(error.code) {
        case error.PERMISSION_DENIED:
            message = 'Location access denied.';
            break;
        case error.POSITION_UNAVAILABLE:
            message = 'Location information is unavailable.';
            break;
        case error.TIMEOUT:
            message = 'Location request timed out.';
            break;
        default:
            message = 'An unknown error occurred while getting your location.';
    }

    console.log('Browser geolocation failed. Trying IP-based detection...');
    // Hide error message and show loading while trying IP geolocation
    showLoading();
    tryIPGeolocation();
}

// Try IP-based Geolocation - Using IPregistry.co for accuracy
async function tryIPGeolocation() {
    try {
        console.log('Attempting IP geolocation via ipregistry.co...');
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 8000); // 8 second timeout

        // Using tryout key for testing - replace with your own key for production
        const response = await fetch('https://api.ipregistry.co/?key=tryout', {
            signal: controller.signal
        });
        clearTimeout(timeoutId);

        console.log('IPregistry response status:', response.status);

        if (!response.ok) {
            console.error('ipregistry.co returned error:', response.status, response.statusText);
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        console.log('IPregistry full response:', JSON.stringify(data, null, 2));

        if (data.location && data.location.latitude && data.location.longitude) {
            console.log(`✓ Location detected via IPregistry: ${data.location.city}, ${data.location.country.name} (${data.location.latitude}, ${data.location.longitude})`);
            fetchWeatherData(data.location.latitude, data.location.longitude);
            return;
        } else {
            console.error('ipregistry.co: No location data in response');
            throw new Error('No location data');
        }
    } catch (error) {
        if (error.name === 'AbortError') {
            console.error('IPregistry geolocation timed out after 8 seconds');
        } else {
            console.error('IPregistry geolocation failed:', error.message);
        }
        console.log('Falling back to alternative IP geolocation...');
        tryAlternativeIPGeolocation();
    }
}

// Try alternative IP Geolocation service (ip-api.com - no rate limit for personal use)
async function tryAlternativeIPGeolocation() {
    try {
        console.log('Trying alternative IP geolocation via ip-api.com...');
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 8000);

        const response = await fetch('http://ip-api.com/json/', {
            signal: controller.signal
        });
        clearTimeout(timeoutId);

        console.log('ip-api.com response status:', response.status);

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        console.log('ip-api.com full response:', JSON.stringify(data, null, 2));

        if (data.status === 'success' && data.lat && data.lon) {
            console.log(`✓ Location detected via ip-api.com: ${data.city}, ${data.country} (${data.lat}, ${data.lon})`);
            fetchWeatherData(data.lat, data.lon);
            return;
        } else {
            console.error('ip-api.com failed:', data.message || 'Unknown error');
            throw new Error(data.message || 'No location data');
        }
    } catch (error) {
        if (error.name === 'AbortError') {
            console.error('ip-api.com geolocation timed out after 8 seconds');
        } else {
            console.error('ip-api.com geolocation failed:', error.message);
        }
        console.error('All geolocation methods have failed.');
        tryFinalGeolocationFallback();
    }
}

// Final fallback - show error and ask user to search
function tryFinalGeolocationFallback() {
    console.error('All geolocation methods failed. Please search for your city manually.');
    showError('Unable to detect your location automatically. Please search for your city using the search bar above.');
}

// Fetch Weather Data by Coordinates
async function fetchWeatherData(lat, lon) {
    showLoading();
    console.log(`Fetching weather for coordinates: Latitude ${lat}, Longitude ${lon}`);

    try {
        // Fetch current weather
        const currentWeatherResponse = await fetch(
            `${API_BASE_URL}/weather?lat=${lat}&lon=${lon}&units=imperial&appid=${API_KEY}`
        );

        if (!currentWeatherResponse.ok) {
            throw new Error('Failed to fetch current weather data');
        }

        const currentWeather = await currentWeatherResponse.json();

        // Fetch 6-day forecast
        const forecastResponse = await fetch(
            `${API_BASE_URL}/forecast?lat=${lat}&lon=${lon}&units=imperial&appid=${API_KEY}`
        );

        if (!forecastResponse.ok) {
            throw new Error('Failed to fetch forecast data');
        }

        const forecastData = await forecastResponse.json();

        // Display the data
        displayCurrentWeather(currentWeather);
        displayForecast(forecastData);
        showWeatherContent();

    } catch (error) {
        showError('Failed to fetch weather data. Please try again or enter a city name.');
        console.error('Error fetching weather data:', error);
    }
}

// Fetch Weather Data by City Name
async function fetchWeatherByCity(cityName) {
    showLoading();

    try {
        // Fetch current weather
        const currentWeatherResponse = await fetch(
            `${API_BASE_URL}/weather?q=${encodeURIComponent(cityName)}&units=imperial&appid=${API_KEY}`
        );

        if (!currentWeatherResponse.ok) {
            throw new Error('City not found');
        }

        const currentWeather = await currentWeatherResponse.json();

        // Fetch 6-day forecast using coordinates from current weather
        const forecastResponse = await fetch(
            `${API_BASE_URL}/forecast?lat=${currentWeather.coord.lat}&lon=${currentWeather.coord.lon}&units=imperial&appid=${API_KEY}`
        );

        if (!forecastResponse.ok) {
            throw new Error('Failed to fetch forecast data');
        }

        const forecastData = await forecastResponse.json();

        // Display the data
        displayCurrentWeather(currentWeather);
        displayForecast(forecastData);
        showWeatherContent();

    } catch (error) {
        showError('City not found. Please check the spelling and try again.');
        console.error('Error fetching weather data:', error);
    }
}

// Display Current Weather
function displayCurrentWeather(data) {
    // Location and Date
    cityName.textContent = `${data.name}, ${data.sys.country}`;
    currentDate.textContent = formatDate(new Date());

    // Temperature
    temp.textContent = Math.round(data.main.temp);

    // Weather Icon
    const iconCode = data.weather[0].icon;
    weatherIcon.src = `https://openweathermap.org/img/wn/${iconCode}@4x.png`;
    weatherIcon.alt = data.weather[0].description;

    // Description
    description.textContent = data.weather[0].description;

    // Details
    feelsLike.textContent = `${Math.round(data.main.feels_like)}°F`;
    humidity.textContent = `${data.main.humidity}%`;
    windSpeed.textContent = `${Math.round(data.wind.speed)} mph`;
    pressure.textContent = `${data.main.pressure} hPa`;
}

// Display 6-Day Forecast
function displayForecast(data) {
    // Clear previous forecast
    forecastContainer.innerHTML = '';

    // Get one forecast per day (at 12:00 PM) for next 6 days
    const dailyForecasts = data.list.filter(item => {
        const date = new Date(item.dt * 1000);
        return date.getHours() === 12;
    }).slice(0, 6);

    // If we don't have 6 forecasts at 12:00, get first forecast of each day
    if (dailyForecasts.length < 6) {
        const uniqueDays = new Set();
        const alternativeForecasts = [];

        for (const item of data.list) {
            const date = new Date(item.dt * 1000);
            const dayKey = date.toDateString();

            if (!uniqueDays.has(dayKey) && alternativeForecasts.length < 6) {
                uniqueDays.add(dayKey);
                alternativeForecasts.push(item);
            }
        }

        alternativeForecasts.forEach(forecast => {
            createForecastCard(forecast);
        });
    } else {
        dailyForecasts.forEach(forecast => {
            createForecastCard(forecast);
        });
    }
}

// Create Forecast Card
function createForecastCard(forecast) {
    const date = new Date(forecast.dt * 1000);
    const iconCode = forecast.weather[0].icon;

    const card = document.createElement('div');
    card.className = 'forecast-card';

    card.innerHTML = `
        <div class="forecast-date">${formatForecastDate(date)}</div>
        <div class="forecast-icon">
            <img src="https://openweathermap.org/img/wn/${iconCode}@2x.png" alt="${forecast.weather[0].description}">
        </div>
        <div class="forecast-temp">${Math.round(forecast.main.temp)}°F</div>
        <div class="forecast-desc">${forecast.weather[0].description}</div>
    `;

    forecastContainer.appendChild(card);
}

// Format Date for Current Weather
function formatDate(date) {
    const options = {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    };
    return date.toLocaleDateString('en-US', options);
}

// Format Date for Forecast
function formatForecastDate(date) {
    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    if (date.toDateString() === today.toDateString()) {
        return 'Today';
    } else if (date.toDateString() === tomorrow.toDateString()) {
        return 'Tomorrow';
    } else {
        const options = { weekday: 'short', month: 'short', day: 'numeric' };
        return date.toLocaleDateString('en-US', options);
    }
}

// UI State Management
function showLoading() {
    loadingElement.classList.remove('hidden');
    errorElement.classList.add('hidden');
    weatherContent.classList.add('hidden');
}

function showError(message) {
    errorMessage.textContent = message;
    errorElement.classList.remove('hidden');
    loadingElement.classList.add('hidden');
    weatherContent.classList.add('hidden');
}

function showWeatherContent() {
    weatherContent.classList.remove('hidden');
    loadingElement.classList.add('hidden');
    errorElement.classList.add('hidden');
}

// Event Listeners
retryBtn.addEventListener('click', init);

searchBtn.addEventListener('click', () => {
    const city = cityInput.value.trim();
    if (city) {
        fetchWeatherByCity(city);
    }
});

cityInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        const city = cityInput.value.trim();
        if (city) {
            fetchWeatherByCity(city);
        }
    }
});

// Persistent Search Bar Event Listeners
citySearchBtn.addEventListener('click', () => {
    const city = citySearchInput.value.trim();
    if (city) {
        fetchWeatherByCity(city);
        citySearchInput.value = ''; // Clear input after search
    }
});

citySearchInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        const city = citySearchInput.value.trim();
        if (city) {
            fetchWeatherByCity(city);
            citySearchInput.value = ''; // Clear input after search
        }
    }
});

myLocationBtn.addEventListener('click', () => {
    getUserLocation();
});

// Start the app
init();
