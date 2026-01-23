<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Land Converter - Precise Area Conversion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2e7d32;
            --secondary-color: #1b5e20;
            --background: #f0f2f5;
            --surface: #ffffff;
        }

        body {
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--background);
            display: flex;
            justify-content: center;
            padding: 20px;
            margin: 0;
        }

        .container {
            background: var(--surface);
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 450px;
        }

        h2 {
            color: var(--primary-color);
            text-align: center;
            margin-bottom: 25px;
        }

        .toggle-container {
            display: flex;
            background: #eee;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 4px;
        }

        .toggle-btn {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }

        .active {
            background: var(--primary-color);
            color: white;
        }

        .form-group {
            margin-bottom: 15px;
            position: relative;
        }

        label {
            display: block;
            font-size: 13px;
            color: #666;
            margin-bottom: 5px;
            margin-left: 5px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper i {
            position: absolute;
            left: 12px;
            color: var(--primary-color);
        }

        input, select {
            width: 100%;
            padding: 12px 12px 12px 40px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border 0.3s;
        }

        input:focus {
            border-color: var(--primary-color);
            outline: none;
        }

        .btn-calc {
            width: 100%;
            padding: 15px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-calc:hover { background: var(--secondary-color); }

        .btn-help {
            width: 100%;
            background: none;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            padding: 10px;
            margin-top: 15px;
            border-radius: 8px;
            cursor: pointer;
        }

        .result-card {
            margin-top: 20px;
            padding: 15px;
            background: #e8f5e9;
            border-radius: 8px;
            border-left: 5px solid var(--primary-color);
            display: none;
        }

        .result-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
            font-size: 16px;
        }

        .hidden { display: none; }
    </style>
</head>
<body>

<div class="container">
    <h2>Land Converter</h2>

    <!-- Toggle between Normal and Reverse -->
    <div class="toggle-container">
        <button id="btnNormal" class="toggle-btn active" onclick="setMode(false)">Traditional</button>
        <button id="btnReverse" class="toggle-btn" onclick="setMode(true)">Standard</button>
    </div>

    <!-- Hand Measurement (Laggee) -->
    <div class="form-group">
        <label>Hand Measurement (Laggee)</label>
        <div class="input-wrapper">
            <i class="fas fa-ruler-horizontal"></i>
            <select id="handUnit">
                <option value="4">4.0 Hand</option>
                <option value="4.5">4.5 Hand</option>
                <option value="6" selected>6.0 Hand (Standard)</option>
                <option value="6.5">6.5 Hand</option>
                <option value="7">7.0 Hand</option>
            </select>
        </div>
    </div>

    <!-- Traditional Inputs -->
    <div id="traditionalGroup">
        <div class="form-group">
            <label>Bigha</label>
            <div class="input-wrapper">
                <i class="fas fa-vector-square"></i>
                <input type="number" id="bigha" placeholder="0">
            </div>
        </div>
        <div class="form-group">
            <label>Kattha</label>
            <div class="input-wrapper">
                <i class="fas fa-mountain"></i>
                <input type="number" id="kattha" placeholder="0">
            </div>
        </div>
        <div class="form-group">
            <label>Dhur</label>
            <div class="input-wrapper">
                <i class="fas fa-map"></i>
                <input type="number" id="dhur" placeholder="0">
            </div>
        </div>
        <div class="form-group">
            <label>Dhurki</label>
            <div class="input-wrapper">
                <i class="fas fa-globe"></i>
                <input type="number" id="dhurki" placeholder="0">
            </div>
        </div>
    </div>

    <!-- Standard Inputs (Hidden by default) -->
    <div id="standardGroup" class="hidden">
        <div class="form-group">
            <label>Acre</label>
            <div class="input-wrapper">
                <i class="fas fa-chart-area"></i>
                <input type="number" id="acre" placeholder="0">
            </div>
        </div>
        <div class="form-group">
            <label>Decimal</label>
            <div class="input-wrapper">
                <i class="fas fa-border-all"></i>
                <input type="number" id="decimal" placeholder="0">
            </div>
        </div>
    </div>

    <button class="btn-calc" onclick="calculate()">CALCULATE</button>
    
    <button class="btn-help" onclick="window.open('https://www.youtube.com/shorts/eLoAcope63c')">
        <i class="fab fa-youtube"></i> How to Use
    </button>

    <div id="resultCard" class="result-card">
        <div id="res1" class="result-item"></div>
        <div id="res2" class="result-item"></div>
        <div id="res3" class="result-item"></div>
    </div>
</div>

<script>
    let isReverse = false;

    function setMode(mode) {
        isReverse = mode;
        document.getElementById('btnNormal').classList.toggle('active', !mode);
        document.getElementById('btnReverse').classList.toggle('active', mode);
        document.getElementById('traditionalGroup').classList.toggle('hidden', mode);
        document.getElementById('standardGroup').classList.toggle('hidden', !mode);
        document.getElementById('resultCard').style.display = 'none';
    }

    function calculate() {
        const hand = parseFloat(document.getElementById('handUnit').value);
        const resultCard = document.getElementById('resultCard');
        
        // 1 Dhur in Sq. Ft = (Hand * 1.5)^2
        const sqFtPerDhur = Math.pow(hand * 1.5, 2);

        if (!isReverse) {
            // Traditional to Standard
            const b = parseFloat(document.getElementById('bigha').value) || 0;
            const k = parseFloat(document.getElementById('kattha').value) || 0;
            const d = parseFloat(document.getElementById('dhur').value) || 0;
            const dk = parseFloat(document.getElementById('dhurki').value) || 0;

            const totalDhur = (b * 400) + (k * 20) + d + (dk / 20);
            const totalSqFt = totalDhur * sqFtPerDhur;

            const acres = totalSqFt / 43560;
            const decimals = totalSqFt / 435.6;

            showResults(
                `Acres: <span>${acres.toFixed(4)}</span>`,
                `Decimals: <span>${decimals.toFixed(2)}</span>`,
                `Sq. Feet: <span>${totalSqFt.toFixed(2)}</span>`
            );
        } else {
            // Standard to Traditional
            const acreVal = parseFloat(document.getElementById('acre').value) || 0;
            const decVal = parseFloat(document.getElementById('decimal').value) || 0;

            const totalSqFt = (acreVal * 43560) + (decVal * 435.6);
            const totalDhur = totalSqFt / sqFtPerDhur;

            const bigha = Math.floor(totalDhur / 400);
            const kattha = Math.floor((totalDhur % 400) / 20);
            const dhur = (totalDhur % 20).toFixed(2);

            showResults(
                `Bigha: <span>${bigha}</span>`,
                `Kattha: <span>${kattha}</span>`,
                `Dhur: <span>${dhur}</span>`
            );
        }
    }

    function showResults(r1, r2, r3) {
        const card = document.getElementById('resultCard');
        card.style.display = 'block';
        document.getElementById('res1').innerHTML = r1;
        document.getElementById('res2').innerHTML = r2;
        document.getElementById('res3').innerHTML = r3;
    }
</script>

</body>
</html>
