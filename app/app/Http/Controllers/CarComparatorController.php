<?php

namespace App\Http\Controllers;

use App\Models\Make;
use App\Models\CarModel;
use App\Models\Trim;
use App\Models\Motor;
use App\Models\Body;
use App\Models\Mileage;
use App\Models\Year;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class CarComparatorController extends Controller
{
    public function index()
    {
        $makes = DB::table('makes')->get();
        return view('comparador', compact('makes'));
    }

    public function getModelos(Request $request)
    {
        $makeId = $request->input('make_id');
        $modelos = DB::table('make_models')
            ->where('make_id', $makeId)
            ->select('id', 'name')
            ->get();
        return response()->json($modelos);
    }

    public function getVersiones(Request $request)
    {
        $makeModelId = $request->input('make_model_id');
        $versiones = DB::table('trims')
            ->where('make_model_id', $makeModelId)
            ->select('id', 'name', 'year')
            ->get();
        return response()->json($versiones);
    }

    public function getAutoDetalle(Request $request)
    {
        $autoId = $request->auto_id;
        Log::info('CarComparator - getAutoDetalle: Solicitud recibida', ['autoId' => $autoId]);
        
        $trim = Trim::with(['engine', 'body', 'mileage', 'year', 'makeModel.make', 'makeModel.model'])
            ->findOrFail($autoId);
            
        Log::info('CarComparator - getAutoDetalle: Auto encontrado', [
            'autoId' => $autoId,
            'marca' => $trim->makeModel->make->name ?? 'N/A',
            'modelo' => $trim->makeModel->model->PK_name ?? 'N/A',
            'version' => $trim->name
        ]);
        
        // Formatear datos para mantener compatibilidad con la vista existente
        $auto = [
            'id' => $trim->PK_id,
            'marca' => $trim->makeModel->make->name ?? 'N/A',
            'modelo' => $trim->makeModel->model->PK_name ?? 'N/A',
            'version' => $trim->name,
            'year' => $trim->year ? $trim->year->year : 'N/A',
            'price' => $trim->price ?? 0,
            'motor' => [
                'combustible' => $trim->engine->fuel_type ?? 'N/A',
                'cilindrada' => $trim->engine->size ?? 'N/A',
                'potencia' => $trim->engine->horsepower_hp ?? 'N/A',
                'torque' => $trim->engine->torque_ft_lbs ?? 'N/A',
                'cilindros' => $trim->engine->cylinders ?? 'N/A',
                'tipo' => $trim->engine->engine_type ?? 'N/A',
                'valvulas' => $trim->engine->valves ?? 'N/A',
                'transmision' => $trim->engine->transmission ?? 'N/A',
            ],
            'transmision' => [
                'tipo' => $trim->engine->transmission ?? 'N/A',
                'traccion' => $trim->engine->drive_type ?? 'N/A',
                'marchas' => preg_replace('/[^0-9]/', '', $trim->engine->transmission ?? '') ?: 'N/A',
            ],
            'dimension' => [
                'largo' => $trim->body->length ?? 'N/A',
                'ancho' => $trim->body->width ?? 'N/A',
                'alto' => $trim->body->height ?? 'N/A',
                'distancia_ejes' => $trim->body->wheel_base ?? 'N/A',
                'peso' => $trim->body->curb_weight ?? 'N/A',
                'capacidad_carga' => $trim->body->cargo_capacity ?? 'N/A',
                'capacidad_tanque' => $trim->mileage->fuel_tank_capacity ?? 'N/A',
                'puertas' => $trim->body->doors ?? 'N/A',
                'asientos' => $trim->body->seats ?? 'N/A',
            ],
            'rendimiento' => [
                'ciudad' => $trim->mileage->city_LitersAt100km ?? 'N/A',
                'carretera' => $trim->mileage->highway_LitersAt100km ?? 'N/A',
                'combinado' => $trim->mileage->combined_LitersAt100km ?? 'N/A',
                'autonomia' => $trim->mileage->range_highway ?? 'N/A',
            ],
        ];
        
        return response()->json($auto);
    }

    public function comparacionDetallada(Request $request)
    {
        $autos = $request->input('autos');
        if (!is_array($autos) || count($autos) !== 2) {
            return response()->json(['error' => 'Debes seleccionar dos autos para comparar.'], 400);
        }

        $result = [];
        foreach ($autos as $auto) {
            if (!isset($auto['make_id'], $auto['model_id'], $auto['year'])) {
                \Log::error('Faltan datos para buscar el trim', $auto);
                return response()->json(['error' => 'Faltan datos para buscar el trim.'], 400);
            }
            $car = \DB::table('trims')
                ->join('make_models', 'trims.make_model_id', '=', 'make_models.id')
                ->join('models', 'make_models.name', '=', 'models.name')
                ->join('makes', 'make_models.make_id', '=', 'makes.id')
                ->join('engines', 'trims.engine_id', '=', 'engines.id')
                ->join('bodies', 'trims.body_id', '=', 'bodies.id')
                ->join('mileages', 'trims.mileage_id', '=', 'mileages.id')
                ->where('make_models.make_id', $auto['make_id'])
                ->where('make_models.id', $auto['model_id'])
                ->where('trims.year', $auto['year'])
                ->select(
                    'trims.*',
                    'make_models.name AS model_name',
                    'makes.name AS make_name',
                    'engines.*',
                    'bodies.*',
                    'mileages.*'
                )
                ->first();
            if (!$car) {
                \Log::error('No se encontró información para el auto', $auto);
                return response()->json(['error' => 'No se encontró información para uno de los autos seleccionados.'], 404);
            }
            // Codificar la foto a base64 si existe
            if (isset($car->photo) && !is_null($car->photo)) {
                $car->photo = base64_encode($car->photo);
            }
            $result[] = $car;
        }
        return response()->json($result);
    }
} 