<?php
    date_default_timezone_set('America/Mexico_City');
    header('Content-type: text/plain; charset=utf-8');


    $json = file_get_contents('php://input');
    $data = json_decode($json);

    $limit = "10";
    $id = $data->track_id;
    $danceability = $data->danceability;
    $energy = $data->energy;
    $acousticness = $data->acousticness;
    $instrumentalness = $data->instrumentalness;
    $valence = $data->valence;

     // abrimos la sesión cURL
    $ch = curl_init();

    // definimos cada uno de los parámetros
    $parametros = "?limit=".$limit.'&seed_tracks='.$id.'&target_danceability='.$danceability.'&target_energy='.$energy;
    $parametros .= '&target_acousticness='.$acousticness.'&target_instrumentalness='.$instrumentalness.'&target_valence='.$valence;

    // definimos la URL a la que hacemos la petición
    curl_setopt($ch, CURLOPT_URL,"https://api.spotify.com/v1/recommendations".$parametros);

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

    $idArray = array();
    for($i=0;$i<sizeof($json_response->tracks);$i++){
      $id = $json_response->tracks[$i]->id;
      if($id != $data->track_id) 
        array_push($idArray,$id);
    } 
    //$idJSON = (object) $idArray;
    $idJSON->ids = $idArray;

    // regresamos los datos 
    print_r(json_encode($idJSON));
?>