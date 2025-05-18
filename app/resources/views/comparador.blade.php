<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Comparador de Coches</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            max-width: 1200px;
            padding: 2rem;
        }
        .card {
            border: none;
            border-radius: 18px;
            box-shadow: 0 6px 24px rgba(111, 66, 193, 0.10), 0 1.5px 4px rgba(0,0,0,0.04);
            margin-bottom: 1rem;
            background: white;
            transition: box-shadow 0.3s;
        }
        .card:hover {
            box-shadow: 0 12px 32px rgba(111, 66, 193, 0.18), 0 2px 8px rgba(0,0,0,0.06);
        }
        .card-header {
            background: #6f42c1;
            color: white;
            border-radius: 18px 18px 0 0 !important;
            padding: 1.2rem 1rem;
            font-size: 1.3rem;
            letter-spacing: 1px;
            font-weight: 600;
            box-shadow: 0 2px 8px #6f42c133;
        }
        .form-control {
            border-radius: 12px;
            padding: 0.9rem;
            border: 1.5px solid #e0d7f3;
            margin-bottom: 1.1rem;
            font-size: 1.08rem;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.2rem #6f42c133;
            border-color: #6f42c1;
        }
        .btn-primary {
            border-radius: 12px;
            padding: 0.9rem 2.2rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            background: linear-gradient(90deg, #6f42c1 60%, #a084e8 100%);
            border: none;
            transition: all 0.3s ease;
            color: #fff;
            box-shadow: 0 2px 8px #6f42c133;
        }
        .btn-primary:hover {
            transform: translateY(-2px) scale(1.04);
            box-shadow: 0 6px 18px #6f42c144;
            background: linear-gradient(90deg, #a084e8 0%, #6f42c1 100%);
        }
        .comparison-title {
            color: #2c3e50;
            font-weight: 800;
            margin-bottom: 1.2rem;
            text-align: center;
            letter-spacing: 2px;
        }
        .car-section {
            padding: 1.7rem 1.2rem 1.2rem 1.2rem;
        }
        .loading {
            display: none;
            text-align: center;
            padding: 1rem;
        }
        .loading i {
            animation: spin 1s linear infinite;
            color: #6f42c1;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .table-responsive {
            margin-top: 2.5rem;
        }
        table.table {
            background: #fff;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 2px 12px #6f42c122;
        }
        table.table th, table.table td {
            vertical-align: middle !important;
            font-size: 1.05rem;
        }
        table.table th {
            background: #f3eaff;
            color: #6f42c1;
            font-weight: 700;
            border-bottom: 2px solid #e0d7f3;
        }
        table.table td {
            border-bottom: 1.5px solid #f3eaff;
        }
        .alert-warning, .alert-danger {
            font-size: 1.1rem;
            border-radius: 10px;
        }
        @media (max-width: 900px) {
            .car-section { padding: 1rem; }
            .comparison-title { font-size: 2rem; }
        }
    </style>
</head>
<body>
    <div style="background: #6f42c1; height: 56px; width: 100vw; position: fixed; top: 0; left: 0; z-index: 1000;"></div>
    <div class="container" style="margin-top: 80px;">
        <h1 class="comparison-title" style="font-size:2.8rem;">CarWizard</h1>
        <h4 class="text-center mb-4" style="color:#6f42c1;font-weight:500;">your trusted pre-owned car comparison tool</h4>
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h2 class="mb-0"><i class="fas fa-car"></i> Vehicle 1</h2>
                    </div>
                    <div class="car-section">
                        <select id="make1" class="form-control">
                            <option value="">Select a make</option>
                            @foreach($makes as $make)
                                <option value="{{ $make->id }}">{{ $make->name }}</option>
                            @endforeach
                        </select>
                        <select id="model1" class="form-control">
                            <option value="">Select a model</option>
                        </select>
                        <select id="year1" class="form-control">
                            <option value="">Select a year</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h2 class="mb-0"><i class="fas fa-car"></i> Vehicle 2</h2>
                    </div>
                    <div class="car-section">
                        <select id="make2" class="form-control">
                            <option value="">Select a make</option>
                            @foreach($makes as $make)
                                <option value="{{ $make->id }}">{{ $make->name }}</option>
                            @endforeach
                        </select>
                        <select id="model2" class="form-control">
                            <option value="">Select a model</option>
                        </select>
                        <select id="year2" class="form-control">
                            <option value="">Select a year</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-center mt-4">
            <button id="compare" class="btn btn-primary">
                <i class="fas fa-balance-scale"></i> Compare Vehicles
            </button>
        </div>
        <div id="loading" class="loading mt-4">
            <i class="fas fa-spinner fa-2x"></i>
            <p>Loading comparison...</p>
        </div>
        <div id="result" class="mt-4"></div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            function showLoading() {
                $('#loading').show();
                $('#result').hide();
            }

            function hideLoading() {
                $('#loading').hide();
                $('#result').show();
            }

            $('#make1, #make2').change(function() {
                var makeId = $(this).val();
                var modelSelect = $(this).attr('id') === 'make1' ? $('#model1') : $('#model2');
                var yearSelect = $(this).attr('id') === 'make1' ? $('#year1') : $('#year2');
                
                showLoading();
                
                $.ajax({
                    url: '/comparador/modelos',
                    method: 'POST',
                    data: { make_id: makeId },
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    success: function(data) {
                        modelSelect.empty().append('<option value="">Select a model</option>');
                        data.forEach(function(model) {
                            modelSelect.append('<option value="' + model.id + '">' + model.name + '</option>');
                        });
                        yearSelect.empty().append('<option value="">Select a year</option>');
                        hideLoading();
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', error);
                        hideLoading();
                        alert('Error fetching the selected vehicles. Please try again.');
                    }
                });
            });

            $('#model1, #model2').change(function() {
                var makeModelId = $(this).val();
                var yearSelect = $(this).attr('id') === 'model1' ? $('#year1') : $('#year2');
                
                showLoading();
                
                $.ajax({
                    url: '/comparador/versiones',
                    method: 'POST',
                    data: { make_model_id: makeModelId },
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    success: function(data) {
                        yearSelect.empty().append('<option value="">Select a year</option>');
                        data.forEach(function(version) {
                            yearSelect.append('<option value="' + version.year + '">' + version.year + '</option>');
                        });
                        hideLoading();
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', error);
                        hideLoading();
                        alert('Error fetching the selected vehicles. Please try again.');
                    }
                });
            });

            $('#compare').click(function() {
                var make1 = $('#make1').val();
                var model1 = $('#model1').val();
                var year1 = $('#year1').val();
                var make2 = $('#make2').val();
                var model2 = $('#model2').val();
                var year2 = $('#year2').val();

                if (make1 && model1 && year1 && make2 && model2 && year2) {
                    showLoading();
                    // Construir el payload con make_id, model_id y year para cada coche
                    var autos = [
                        { make_id: make1, model_id: model1, year: year1 },
                        { make_id: make2, model_id: model2, year: year2 }
                    ];
                    $.ajax({
                        url: '/comparador/detallado',
                        method: 'POST',
                        data: { autos: autos },
                        headers: { 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') },
                        success: function(data) {
                            hideLoading();
                            if (data.length === 2) {
                                $('#result').html(renderComparisonTable(data));
                            } else {
                                $('#result').html('<div class="alert alert-warning">No data found for comparison.</div>');
                            }
                        },
                        error: function(xhr, status, error) {
                            hideLoading();
                            $('#result').html('<div class="alert alert-danger">Error comparing vehicles.</div>');
                        }
                    });
                } else {
                    $('#result').html('<div class="alert alert-warning">Please select all fields for both vehicles.</div>');
                }
            });

            // Función para renderizar la tabla de comparación
            function renderComparisonTable(data) {
                var labels = {
                    make_name: 'Make',
                    model_name: 'Model',
                    year: 'Year',
                    name: 'Trim',
                    engine_type: 'Engine Type',
                    fuel_type: 'Fuel Type',
                    cylinders: 'Cylinders',
                    size: 'Displacement',
                    horsepower_hp: 'Horsepower (HP)',
                    torque_ft_lbs: 'Torque (ft-lbs)',
                    transmission: 'Transmission',
                    drive_type: 'Drivetrain',
                    doors: 'Doors',
                    seats: 'Seats',
                    length: 'Length',
                    width: 'Width',
                    height: 'Height',
                    wheel_base: 'Wheelbase',
                    curb_weight: 'Weight',
                    fuel_tank_capacity: 'Fuel Tank Capacity',
                    city_LitersAt100km: 'City Consumption (L/100km)',
                    highway_LitersAt100km: 'Highway Consumption (L/100km)',
                    combined_LitersAt100km: 'Combined Consumption (L/100km)',
                    range_highway: 'Highway Range',
                };
                var keys = Object.keys(labels);
                var html = '<div class="table-responsive">';
                html += '<table class="table table-bordered table-striped">';
                html += '<thead><tr><th>Feature</th><th>Vehicle 1</th><th>Vehicle 2</th></tr></thead><tbody>';
                // Mostrar la foto si existe
                html += '<tr><th>Photo</th>';
                for (var i = 0; i < 2; i++) {
                    if (data[i].photo) {
                        html += '<td style="text-align:center;"><img src="data:image/jpeg;base64,' + data[i].photo + '" alt="Vehicle Photo" style="max-width:220px;max-height:160px;border-radius:12px;box-shadow:0 2px 8px #0002;display:block;margin:0 auto;">';
                        // Mostrar precio debajo de la foto
                        if (data[i].msrp !== undefined && data[i].msrp !== null) {
                            html += '<div style="margin-top:10px;font-size:1.35rem;font-weight:700;color:#fff;background:linear-gradient(90deg,#6f42c1 60%,#a084e8 100%);border-radius:8px;padding:7px 0;box-shadow:0 2px 8px #6f42c133;letter-spacing:1px;">';
                            html += '<span style="font-size:1.1rem;margin-right:4px;">&#36;</span>' + Number(data[i].msrp).toLocaleString('en-US') + '</div>';
                        }
                        html += '</td>';
                    } else {
                        html += '<td>-</td>';
                    }
                }
                html += '</tr>';
                // Renderizar el resto de la tabla (sin msrp)
                keys.forEach(function(key) {
                    html += '<tr>';
                    html += '<th>' + labels[key] + '</th>';
                    for (var i = 0; i < 2; i++) {
                        var value = data[i][key];
                        // Si es un número flotante o un string que representa un float
                        if ((typeof value === 'number' && !Number.isInteger(value)) || (typeof value === 'string' && /^-?\d*\.\d+$/.test(value))) {
                            value = parseFloat(value).toFixed(2);
                        }
                        html += '<td>' + (value !== undefined ? value : '-') + '</td>';
                    }
                    html += '</tr>';
                });
                html += '</tbody></table></div>';
                return html;
            }
        });
    </script>
</body>
</html> 