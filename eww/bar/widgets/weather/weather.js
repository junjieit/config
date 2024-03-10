// https://openweathermap.org
const path = require("path");
const fs = require("fs");

const lat = process.env.LAT;
const lon = process.env.LON;
const appId = process.env.WETHER_APP_ID;
const lang = process.env.LANG;
const units = "metric";

async function getIcon(title) {
  const imageFileUrl = path.join(__dirname, "./weather-icon", `${title}.png`);
  if (fs.existsSync(imageFileUrl)) {
    return imageFileUrl;
  }
  const result = await fetch(
    `https://openweathermap.org/img/wn/${title}@2x.png`
  );
  const blob = await result.blob();
  const arrayBuffer = await blob.arrayBuffer();
  const buffer = Buffer.from(arrayBuffer);
  fs.writeFileSync(imageFileUrl, buffer);
  return imageFileUrl;
}

async function getForecastWearher() {
  const apiUrl = "http://api.openweathermap.org/data/2.5/forecast";
  const result = await fetch(
    `${apiUrl}?lat=${lat}&lon=${lon}&appid=${appId}&lang=${lang}&units=${units}`
  );
  const data = await result.json();
  return data;
}

async function getWeather() {
  // https://openweathermap.org/current
  const apiUrl = "https://api.openweathermap.org/data/2.5/weather";
  const result = await fetch(
    `${apiUrl}?lat=${lat}&lon=${lon}&appid=${appId}&lang=${lang}&units=${units}`
  );
  const data = await result.json();
  const { weather, main } = data;
  if (!weather.length) return null;
  const [currentWeather] = weather;

  const { description, icon } = currentWeather;
  const iconUrl = await getIcon(icon);
  const weatherInfo = {
    temperature: main.feels_like,
    humidity: main.humidity,
    temperature_min: main.temp_min,
    temperature_max: main.temp_max,
    weatherMain: currentWeather.main,
    description: description,
    icon: iconUrl,
  };
  return weatherInfo;
}

function timeComputed(time) {
  const gap = time - Date.now();
  const hour = (gap / 1000 / 60 / 60).toFixed(2);
  if (hour > 24) {
    const dayHour = (hour % 24).toFixed();
    const day = Math.floor(hour / 24);
    return `${day}d.${dayHour}h`;
  }
  return `${hour}h`;
}

const TEMPERATURE_CHANGE_FEEL_METRIC = 4;
function getForecastCompareText(forecastData, currentTemperature, weatherMain) {
  let text = "";
  let temperatureChanged = false;
  let rainChanged = false;
  forecastData.list
    .sort((a, b) => (a.dt - b.dt > 0 ? 1 : -1))
    .some((item) => {
      const { weather, main, dt } = item;
      const time = Number(dt + "000");
      if (!weather.length) return false;
      const [currentWeather] = weather;
      if (!rainChanged && currentWeather.main !== weatherMain) {
        text += `${timeComputed(time)}: ${currentWeather.main}; `;
        rainChanged = true;
      }
      if (!temperatureChanged) {
        const temperatureChangeMetric = main.feels_like - currentTemperature;
        if (
          Math.abs(temperatureChangeMetric) > TEMPERATURE_CHANGE_FEEL_METRIC
        ) {
          temperatureChanged = true;
          text += `${timeComputed(time)}: ${
            temperatureChangeMetric > 0 ? "+" : ""
          }${temperatureChangeMetric.toFixed(2)}°C; `;
        }
      }
      return rainChanged && temperatureChanged;
    });
  return text;
}

async function getAllWeatherData() {
  const [weatherData, forecastData] = await Promise.all([
    getWeather(),
    getForecastWearher(),
  ]);
  const forecastCompareText = getForecastCompareText(
    forecastData,
    weatherData.temperature,
    weatherData.weatherMain
  );
  return JSON.stringify({
    forecastCompareText: forecastCompareText ? `(${forecastCompareText})` : "",
    weatherData,
  });
}

module.exports = {
  getWeather,
  getAllWeatherData,
};
