<?php
    date_default_timezone_set('America/Mexico_City');
    header('Content-type: text/plain; charset=utf-8');


    $json = file_get_contents('php://input');
    $data = json_decode($json);

    /*$limit = "10";
    $id = $data->track_id;
    $danceability = $data->danceability;
    $energy = $data->energy;
    $acousticness = $data->acousticness;
    $instrumentalness = $data->instrumentalness;
    $valence = $data->valence;*/
    $ids = $data->ids;
    $parametros = '?ids=';
    for($m=0; $m<sizeof($ids) ; $m++){
        $parametros.=$ids[$m].',';
    }
    $parametros = substr($parametros,0,-1);

     // abrimos la sesión cURL
    $ch = curl_init();
    
      // definimos la URL a la que hacemos la petición
    curl_setopt($ch, CURLOPT_URL,"https://api.spotify.com/v1/tracks".$parametros);

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
    $json_songs = $json_response->tracks;

    $songsArray = array();
    for($i=0;$i<sizeof($json_songs);$i++){
      $songsArray[$i]->id = $json_songs[$i]->id;
      $songsArray[$i]->name = $json_songs[$i]->name;
      $songsArray[$i]->artist = $json_songs[$i]->artists[0]->name;
      $songsArray[$i]->image_url = $json_songs[$i]->album->images[0]->url;
    } 

    $songsJSON->canciones = $songsArray;

    // regresamos los datos 
    //print_r(json_encode($json_response));
    print_r(json_encode($songsJSON));
?>