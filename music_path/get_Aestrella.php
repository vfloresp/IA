<?php
    date_default_timezone_set(America/Mexico_City);
    header('Content-type: text/plain; charset=utf-8');
   /*input: final (canción a la que queremos llegar), lista que describe al grafo que tiene
    información de canciones
    output: lista lineal de resultados
    nodo de canción: [id,valor heurístico, [id vecino 1, distancia entre nodo actual y vecino 1],..
    ...,[id vecino n, distancia entre nodo actual y vecino n]].*/
    /*consulta: aEstrella('zy24',[['42ab',25,['32fa',4],['ds54',11]],['32fa',15,['48lo',3],['31cd',6]],['48lo',11,['zy24',1],['76de',2]],['31cd',10],['76de',5],['ds54',13,['22db',6],['cc66',5]],['22db',10],['cc66',9,['zy24',3]],['zy24',0]])*/


    $json = file_get_contents('php://input');
    $data = json_decode($json);

    $idFin = $data->idFin;
    $grafo = "[";
    for($i=0;$i<sizeof($data->graph);$i++){
        $grafo .= "['".$data->graph[$i][0]. "',";
        $grafo .= $data->graph[$i][1]. ",";
        for($j=0;$j<sizeof($data->graph[$i][2]);$j++){
            $grafo .= "['".$data->graph[$i][2][$j][0]."',";
            $grafo .= $data->graph[$i][2][$j][1]."],";
        }
        $grafo = substr($grafo,0,-1);
        $grafo .= "],";
    }
    $grafo = substr($grafo,0,-1);
    if(substr($grafo,strlen($grafo)-2,1)!="]"){
        $grafo .= "]";
    }
    
    $cmd = "swipl -f /var/www/html/music_path/AEstrella.pl -g 'aEstrella('".$idFin."',".$grafo.")',halt";

    print_r($cmd);
    exec( $cmd, $output );
    //$output = $output[0];
    //$output = substr($output,1,-1);

    $listaArray = array();
    /*for($k=0;$k<sizeof($output)-2;$k++){
        array_push($listaArray,$output[$k]);
    }*/
    array_slice($listaArray,-3);
    /*while($output){
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
    }*/
    $res->resultado=$listaArray;
    print_r(json_encode($output));
  
?> 