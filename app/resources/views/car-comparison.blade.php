<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comparación Detallada - CarWizard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="{{ asset('css/car-comparison.css') }}">
</head>

<body>
    <!-- navbar -->
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="#">
                <img src="https://via.placeholder.com/150x40/4366e6/ffffff?text=CarWizard" alt="CarWizard">
            </a>
            <a href="{{ route('comparador') }}" class="button button--secondary">
                <i class="fas fa-arrow-left"></i> Volver al comparador
            </a>
        </div>
    </nav>

    <!-- header -->
    <section class="header-section">
        <div class="container">
            <h1 class="text-center mb-3">
                @foreach($autos as $key => $auto)
                    {{ $auto->marca }} {{ $auto->modelo }}
                    @if($key < count($autos) - 1) vs @endif
                @endforeach
            </h1>
            <p class="text-center">Comparación de las características técnicas, de equipamiento y precios de 
                @foreach($autos as $key => $auto)
                    {{ $auto->marca }} {{ $auto->modelo }}
                    @if($key < count($autos) - 1) {{ $key == count($autos) - 2 ? ' y ' : ', ' }} @endif
                @endforeach.
            </p>
        </div>
    </section>

    <!-- contenido principal -->
    <div class="container comparison">
        <!-- Cards de autos -->
        <div class="row mb-4">
            @foreach($autos as $auto)
            <div class="col-md-{{ 12/count($autos) }} mb-3">
                <div class="car">
                    <img src="{{ asset('storage/uploads/placeholder-auto.png') }}" alt="{{ $auto->marca }} {{ $auto->modelo }}" class="car__image">
                    <h3 class="car__title">{{ $auto->marca }} {{ $auto->modelo }}</h3>
                    <p class="car__subtitle">{{ $auto->version }}</p>
                    <div class="car__price">${{ number_format($auto->price, 0, '.', ',') }}</div>
                </div>
            </div>
            @endforeach
        </div>

        <!-- Información general -->
        <div class="comparison__section">
            <h2 class="comparison__title">Información general</h2>
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Año</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->year }}</div>
                    @endforeach
                </div>
            </div>
        </div>

        <!-- Motor y rendimiento -->
        <div class="comparison__section">
            <h2 class="comparison__title">Motor</h2>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Combustible</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->motor->combustible }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Cilindrada</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->motor->cilindrada }} L</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Potencia</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">
                            {{ $auto->motor->potencia }} hp
                        </div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Torque</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">
                            {{ $auto->motor->torque }} lb-pie
                        </div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Cilindros</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->motor->cilindros }}</div>
                    @endforeach
                </div>
            </div>

            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Tipo de Motor</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->motor->tipo }}</div>
                    @endforeach
                </div>
            </div>

            @if(isset($autos[0]->motor->valvulas))
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Válvulas</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->motor->valvulas }}</div>
                    @endforeach
                </div>
            </div>
            @endif
        </div>

        <!-- Transmisión -->
        <div class="comparison__section">
            <h2 class="comparison__title">Transmisión</h2>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Tipo</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->transmision->tipo }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Tracción</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->transmision->traccion }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Velocidades</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->transmision->marchas }}</div>
                    @endforeach
                </div>
            </div>
        </div>

        <!-- Dimensiones -->
        <div class="comparison__section">
            <h2 class="comparison__title">Dimensiones y Capacidades</h2>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Largo (mm)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->largo }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Ancho (mm)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->ancho }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Alto (mm)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->alto }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Distancia entre ejes (mm)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->distancia_ejes }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Peso (kg)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->peso }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Capacidad de carga (L)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->capacidad_carga }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Capacidad de tanque (L)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->capacidad_tanque }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Puertas</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->puertas }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Asientos</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->dimension->asientos }}</div>
                    @endforeach
                </div>
            </div>
        </div>

        <!-- Rendimiento -->
        @if(isset($autos[0]->rendimiento))
        <div class="comparison__section">
            <h2 class="comparison__title">Rendimiento</h2>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Ciudad (L/100km)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->rendimiento->ciudad }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Carretera (L/100km)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->rendimiento->carretera }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Combinado (L/100km)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->rendimiento->combinado }}</div>
                    @endforeach
                </div>
            </div>
            
            <div class="comparison__feature">
                <h3 class="comparison__feature-header">Autonomía (km)</h3>
                <div class="comparison__feature-values">
                    @foreach($autos as $auto)
                        <div class="comparison__feature-value">{{ $auto->rendimiento->autonomia }}</div>
                    @endforeach
                </div>
            </div>
        </div>
        @endif

        <!-- Volver al comparador -->
        <div class="text-center mt-5 mb-4">
            <a href="{{ route('comparador') }}" class="btn btn-primary">Volver al comparador</a>
        </div>
    </div>

    <!-- Footer -->
    <footer class="py-4 footer">
        <div class="container text-center">
            <p class="mb-0">CarWizard © 2025 - Todos los derechos reservados</p>
        </div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 