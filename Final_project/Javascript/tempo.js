            const cityIds = {
    1: 1010500,    // Aveiro
    2: 1020500,    // Beja
    3: 1030300,    // Braga
    4: 1040200,    // Bragança
    5: 1050200,    // Castelo Branco
    6: 1060300,    // Coimbra
    7: 1070500,    // Évora
    8: 1080500,    // Faro
    9: 1090700,    // Guarda
    10: 1100900,   // Leiria
    11: 1110600,   // Lisboa
    12: 1121400,   // Portalegre
    13: 1131200,   // Porto
    14: 1141600,   // Santarém
    15: 1151200,   // Setúbal
    16: 1160900,   // Viana do Castelo
    17: 1171400,   // Vila Real
    18: 1182300,   // Viseu
    19: 3430100,   // Angra do Heroísmo
    20: 3470100,   // Horta
    21: 3420300,   // Ponta Delgada
    22: 2310300,    // Funchal
};

function fetchWeatherForecast() {
    var distritoId = document.querySelector('#hiddenDistritoId').value;
    //var distritoId = parseInt(document.getElementById(hiddenDistritoId).value, 10)
    const cityId = cityIds[distritoId];
    const apiUrl = `https://api.ipma.pt/open-data/forecast/meteorology/cities/daily/${cityId}.json`;
    console.log(apiUrl);

    fetch(apiUrl)
        .then((response) => response.json())
        .then((data) => {
            const forecast = data.data; // Daily forecast data
            let forecastHTML = "";

            // Array with the names of the months
            const months = [
                "Janeiro",
                "Fevereiro",
                "Março",
                "Abril",
                "Maio",
                "Junho",
                "Julho",
                "Agosto",
                "Setembro",
                "Outubro",
                "Novembro",
                "Dezembro",
            ];

            // Mapping of idWeatherType to images
            const weatherImages = {
                0: "imagens/sol.png",                  // No information / General icon
                1: "imagens/ipmaicons/w_ic_d_01anim.svg", // Clear sky
                2: "imagens/ipmaicons/w_ic_d_02anim.svg", // Partly cloudy
                3: "imagens/ipmaicons/w_ic_d_03anim.svg", // Sunny intervals
                4: "imagens/ipmaicons/w_ic_d_04anim.svg", // Cloudy
                5: "imagens/ipmaicons/w_ic_d_05anim.svg", // Showers/rain (Cloudy with high cloud)
                6: "imagens/ipmaicons/w_ic_d_06anim.svg", // Showers/rain
                7: "imagens/ipmaicons/w_ic_d_07anim.svg", // Light showers/rain
                8: "imagens/ipmaicons/w_ic_d_08anim.svg", // Heavy showers/rain
                9: "imagens/ipmaicons/w_ic_d_09anim.svg", // Rain/showers
                10: "imagens/ipmaicons/w_ic_d_10anim.svg", // Light rain
                11: "imagens/ipmaicons/w_ic_d_11anim.svg", // Heavy rain/showers
                12: "imagens/ipmaicons/w_ic_d_12anim.svg", // Intermittent rain
                13: "imagens/ipmaicons/w_ic_d_13anim.svg", // Drizzle (Intermittent light rain)
                14: "imagens/ipmaicons/w_ic_d_14anim.svg", // Mist
                15: "imagens/ipmaicons/w_ic_d_15anim.svg", // Fog
                16: "imagens/ipmaicons/w_ic_d_16anim.svg", // Snow
                17: "imagens/ipmaicons/w_ic_d_17anim.svg", // Thunderstorms
                18: "imagens/ipmaicons/w_ic_d_18anim.svg", // Showers and thunderstorms
                19: "imagens/ipmaicons/w_ic_d_19anim.svg", // Hail
                20: "imagens/ipmaicons/w_ic_d_20anim.svg", // Frost
                21: "imagens/ipmaicons/w_ic_d_21anim.svg", // Rain and thunderstorms
                22: "imagens/ipmaicons/w_ic_d_22anim.svg", // Convective clouds
                23: "imagens/ipmaicons/w_ic_d_23anim.svg", // Partly cloudy (Variable cloudiness)
                24: "imagens/ipmaicons/w_ic_d_24anim.svg", // Fog
                25: "imagens/ipmaicons/w_ic_d_25anim.svg", // Cloudy
                26: "imagens/ipmaicons/w_ic_d_26anim.svg", // Snow showers
                27: "imagens/ipmaicons/w_ic_d_27anim.svg", // Rain and snow
                28: "imagens/ipmaicons/w_ic_d_28anim.svg", // Rain and snow
                29: "imagens/ipmaicons/w_ic_d_29anim.svg", // Rain and snow
                30: "imagens/ipmaicons/w_ic_d_30anim.svg"  // Rain and snow
            };

            forecast.forEach((day) => {
                const tMin = day.tMin !== undefined ? day.tMin : "N/A";
                const tMax = day.tMax !== undefined ? day.tMax : "N/A";
                const precipitaProb =
                    day.precipitaProb !== undefined ? day.precipitaProb : "N/A";

                // Convert the date to the format dd/month
                const date = new Date(day.forecastDate);
                const dayOfMonth = String(date.getDate()).padStart(2, "0"); // Day of the month with two digits
                const monthName = months[date.getMonth()]; // Get the name of the month
                const formattedDate = `${dayOfMonth}/${monthName}`;

                // Get the corresponding image for idWeatherType
                const weatherTypeImage =
                    weatherImages[day.idWeatherType] || "imagens/sol.png"; // Default image if type not found

                forecastHTML += `
          <div class="forecast">
            ${formattedDate} <img src="${weatherTypeImage}" alt="Weather type image" style="width: 50px; height: auto;" /> ${tMin}.C a ${tMax}.C
          </div>
        `;
            });

            document.getElementById("forecastContainer").innerHTML =
                forecastHTML;
        })
        .catch((error) => {
            console.error("Erro:", error);
            document.getElementById("forecastContainer").innerHTML = `
        <p>Erro ao carregar a previsão do tempo.</p>
      `;
        });
}

// Call the function when the page loads
fetchWeatherForecast();