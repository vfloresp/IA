<?php
    date_default_timezone_set(America/Mexico_City);
    header('Content-type: text/plain; charset=utf-8');
    /*nodo = genes ; genes = [danceability, energy, acousticness, instrumentalness, valence]
    CONSULTA: algGenerico([0.53,0.21,0.11,0.68,0.04],[0.45,0.12,0.11,0.53,0.1])*/


    $json = file_get_contents('php://input');
    $data = json_decode($json);

    $genIni="[".$data->genIni->danceability.",".$data->genIni->energy.",".$data->genIni->acousticness.",".$data->genIni->instrumentalness.",".$data->genIni->valence."]";
    $genFin="[".$data->genFin->danceability.",".$data->genFin->energy.",".$data->genFin->acousticness.",".$data->genFin->instrumentalness.",".$data->genFin->valence."]";
    
    $cmd = "swipl -f /var/www/html/music_path/Genetico.pl -g 'algGenerico(".$genIni.",".$genFin.")',halt";

    exec( $cmd, $output );
    $output = $output[0];
    $output = substr($output,1,-1);

    $genArray = array();
    $i = 0;
    while($output){
        $genArray[$i]->danceability = substr($output,1,strpos($output,",")-1);
        $output = substr($output,strpos($output,",")+1);
        $genArray[$i]->energy = substr($output,0,strpos($output,","));
        $output = substr($output,strpos($output,",")+1);
        $genArray[$i]->acousticness = substr($output,0,strpos($output,","));
        $output = substr($output,strpos($output,",")+1);
        $genArray[$i]->instrumentalness = substr($output,0,strpos($output,","));
        $output = substr($output,strpos($output,",")+1);
        $genArray[$i]->valence = substr($output,0,strpos($output,"]"));
        $output = substr($output,strpos($output,"]")+2);
        $i++;
    }

    print_r(json_encode($genArray) );

   
?> 