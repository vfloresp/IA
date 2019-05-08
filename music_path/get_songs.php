<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    date_default_timezone_set('America/Mexico_City');
    header('Content-type: text/plain; charset=utf-8');


    $json = file_get_contents('php://input');
    $data = json_decode($json);

    $limit = "3";
    $id = $data->track_id;
    $danceability = $data->danceability;
    $energy = $data->energy;
    $acousticness = $data->acousticness;
    $instrumentalness = $data->instrumentalness;
    $valence = $data->valence;

     // abrimos la sesión cURL
    $ch = curl_init();

    // definimos la URL a la que hacemos la petición
    curl_setopt($ch, CURLOPT_URL,"https://api.spotify.com/v1/recommendations");
    // indicamos el tipo de petición: POST
    curl_setopt($ch, CURLOPT_POST, TRUE);
    
    // definimos cada uno de los parámetros
    $parametros = "limit=".$limit.'&seed_tracks='.$id.'&target_danceability='.$danceability.'&target_energy='.$energy;
    $parametros .= '&target_acousticness='.$acousticness.'&target_instrumentalness='.$instrumentalness.'&target_valence='.$valence;
    curl_setopt($ch, CURLOPT_POSTFIELDS, $parametros);
    var_dump($parametros);

    // definimos los headers
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        'Authorization: Bearer '.$data->token,
        'Accept: application/json',
        'Content-Type: application/json'
    ));

    // recibimos la respuesta y la guardamos en una variable
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $remote_server_output = curl_exec($ch);

    // cerramos la sesión cURL
    curl_close($ch);

    $json_response = json_decode($remote_server_output);
    

    // regresamos los datos 
    print_r($remote_server_output);
?>