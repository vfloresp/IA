<?php
    date_default_timezone_set('America/Mexico_City');
    header('Content-type: text/plain; charset=utf-8');


    $json = file_get_contents('php://input');
    $data = json_decode($json);

    $parameter = $data->search;

     // abrimos la sesión cURL
    $ch = curl_init();

    // definimos cada uno de los parámetros
    $parametros = "?q=".$parameter.'&type=track&limit=7';


    // definimos la URL a la que hacemos la petición
    curl_setopt($ch, CURLOPT_URL,"https://api.spotify.com/v1/search".$parametros);

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
    $json_songs = $json_response->tracks->items;

    $songsArray = array();
    for($i=0;$i<sizeof($json_songs);$i++){
      $songsArray[$i]->id = $json_songs[$i]->id;
      $songsArray[$i]->name = $json_songs[$i]->name;
      $songsArray[$i]->artist = $json_songs[$i]->artists[0]->name;
      $songsArray[$i]->image_url = $json_songs[$i]->album->images[0]->url;
    } 

    $songsJSON = (object) $songsArray;

    // regresamos los datos 
    print_r($songsJSON);
?>