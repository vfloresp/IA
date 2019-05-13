<?php
    date_default_timezone_set('America/Mexico_City');
    header('Content-type: text/plain; charset=utf-8');

    $json = file_get_contents('php://input');
    $data = json_decode($json);

     // abrimos la sesión cURL
    $ch = curl_init();

    $parametros = "?ids=";
    for($i=0;$i<sizeof($data->ids);$i++){
      $parametros .= $data->ids[$i].',';
    };
    $parametros = substr($parametros,0,-1);
    // definimos la URL a la que hacemos la petición
    curl_setopt($ch, CURLOPT_URL,"https://api.spotify.com/v1/audio-features".$parametros);

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

    $features = array();
    for($i=0;$i<sizeof($json_response->audio_features);$i++){
        $features[$i]->danceability = $json_response->audio_features[$i]->danceability;
        $features[$i]->energy = $json_response->audio_features[$i]->energy;
        $features[$i]->acousticness = $json_response->audio_features[$i]->acousticness;
        $features[$i]->valence = $json_response->audio_features[$i]->valence;
        $features[$i]->tempo = $json_response->audio_features[$i]->tempo;
        $features[$i]->instrumentalness = $json_response->audio_features[$i]->instrumentalness;
        $features[$i]->id = $json_response->audio_features[$i]->id;
    };

    //$featuresJSON = (object) $features;
    $featuresJSON->features = $features;


    // regresamos los datos 
    print_r(json_encode($featuresJSON));
?>