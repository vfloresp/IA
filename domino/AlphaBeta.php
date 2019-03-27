<?php
    date_default_timezone_set(America/Mexico_City);
    header('Content-type: text/plain; charset=utf-8');


    $json = file_get_contents('php://input');
    $data = json_decode($json);

    $miLIsta = '[';$aux = 'A';
    foreach($data->misPiezas as $pieza){
        $miLIsta = $miLIsta.'[['.$pieza[0].','.$pieza[1].'],'.$aux.'],';
        $aux++;
    }
    $miLIsta = rtrim($miLIsta,',').']';

    $listaIncognitas = '[';
    foreach($data->incognitas as $pieza){
        $listaIncognitas = $listaIncognitas.'[['.$pieza[0].','.$pieza[1].'],'.$aux.'],';
        $aux++;
    }
    $listaIncognitas = rtrim($listaIncognitas,',').']';

    $listaAbiertas = '['.$data->abiertas[0].','.$data->abiertas[1].']';
    
    $cmd = "swipl -f /var/www/html/AlphaBeta.pl -g 'alphaBeta(".$miLIsta.",".$listaIncognitas.",".$listaAbiertas.",[],".$data->depth.",[[],-5000],[[],5000],1,ValorH,".$data->countPiezasCont."),write(ValorH)',halt";

    exec( $cmd, $output );
    if(substr($output[0],0,22)=="Sin fichas disponibles"){
        $output[0] ="Sin fichas disponibles";
    }else{
        //$output[0]= substr($output[0],-12,5);
        preg_match_all('!\d+!', substr($output[0],-12,5), $matches);
        $output = [intval($matches[0]),intval($matches[1])];

    }
    print_r(json_encode( $output) );

   
?> 

